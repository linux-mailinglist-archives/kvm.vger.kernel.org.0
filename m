Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F29FE494E44
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 13:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243738AbiATMwM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 07:52:12 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:49064 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243642AbiATMwK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 07:52:10 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 18C68218E9;
        Thu, 20 Jan 2022 12:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1642683129; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p8KeZQrCQfErvYWz185pteTDx7tPqAujEBCarpF244o=;
        b=rtfMAZRjW+5jVC70ZCqGJOyUihDZnVRiMWAwaOjdvrFWNcSF5sTED421792y5sVVHI2auS
        588nI9VE2nSRMfnQ1xPp0w5DCphZSKWpZYHRt35HupfDyFUApJuaob4SusRzrxu9yF6ze7
        R5TiewY15jY27ynjLJo30KGu37rLaJ4=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7C9AF13EA5;
        Thu, 20 Jan 2022 12:52:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id EEEkHPha6WGIagAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Thu, 20 Jan 2022 12:52:08 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, seanjc@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de,
        varad.gautam@suse.com
Subject: [kvm-unit-tests 07/13] x86: AMD SEV-ES: Handle WBINVD #VC
Date:   Thu, 20 Jan 2022 13:51:16 +0100
Message-Id: <20220120125122.4633-8-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220120125122.4633-1-varad.gautam@suse.com>
References: <20220120125122.4633-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add Linux's sev_es_ghcb_hv_call helper to allow VMGEXIT from the #VC
handler, and handle SVM_EXIT_WBINVD using this.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 lib/x86/amd_sev_vc.c | 66 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/lib/x86/amd_sev_vc.c b/lib/x86/amd_sev_vc.c
index 142f2cd..27a3ed0 100644
--- a/lib/x86/amd_sev_vc.c
+++ b/lib/x86/amd_sev_vc.c
@@ -52,6 +52,69 @@ static void vc_finish_insn(struct es_em_ctxt *ctxt)
 	ctxt->regs->rip += ctxt->insn.length;
 }
 
+static inline u64 lower_bits(u64 val, unsigned int bits)
+{
+	u64 mask = (1ULL << bits) - 1;
+
+	return (val & mask);
+}
+
+static inline void sev_es_wr_ghcb_msr(u64 val)
+{
+	wrmsr(MSR_AMD64_SEV_ES_GHCB, val);
+}
+
+static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
+					  struct es_em_ctxt *ctxt,
+					  u64 exit_code, u64 exit_info_1,
+					  u64 exit_info_2)
+{
+	enum es_result ret;
+
+	/* Fill in protocol and format specifiers */
+	ghcb->protocol_version = GHCB_PROTOCOL_MAX;
+	ghcb->ghcb_usage       = GHCB_DEFAULT_USAGE;
+
+	ghcb_set_sw_exit_code(ghcb, exit_code);
+	ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
+	ghcb_set_sw_exit_info_2(ghcb, exit_info_2);
+
+	sev_es_wr_ghcb_msr(__pa(ghcb));
+	VMGEXIT();
+
+	if ((ghcb->save.sw_exit_info_1 & 0xffffffff) == 1) {
+		u64 info = ghcb->save.sw_exit_info_2;
+		unsigned long v;
+
+		info = ghcb->save.sw_exit_info_2;
+		v = info & SVM_EVTINJ_VEC_MASK;
+
+		/* Check if exception information from hypervisor is sane. */
+		if ((info & SVM_EVTINJ_VALID) &&
+		    ((v == GP_VECTOR) || (v == UD_VECTOR)) &&
+		    ((info & SVM_EVTINJ_TYPE_MASK) == SVM_EVTINJ_TYPE_EXEPT)) {
+			ctxt->fi.vector = v;
+			if (info & SVM_EVTINJ_VALID_ERR)
+				ctxt->fi.error_code = info >> 32;
+			ret = ES_EXCEPTION;
+		} else {
+			ret = ES_VMM_ERROR;
+		}
+	} else if (ghcb->save.sw_exit_info_1 & 0xffffffff) {
+		ret = ES_VMM_ERROR;
+	} else {
+		ret = ES_OK;
+	}
+
+	return ret;
+}
+
+static enum es_result vc_handle_wbinvd(struct ghcb *ghcb,
+				       struct es_em_ctxt *ctxt)
+{
+	return sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_WBINVD, 0, 0);
+}
+
 static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
 					 struct ghcb *ghcb,
 					 unsigned long exit_code)
@@ -59,6 +122,9 @@ static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
 	enum es_result result;
 
 	switch (exit_code) {
+	case SVM_EXIT_WBINVD:
+		result = vc_handle_wbinvd(ghcb, ctxt);
+		break;
 	default:
 		/*
 		 * Unexpected #VC exception
-- 
2.32.0

