Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4FE54547CB
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 14:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237913AbhKQNxG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 08:53:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237900AbhKQNxF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 08:53:05 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB99C061767
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 05:50:06 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id c4so4838375wrd.9
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 05:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AtoA6q/GKeI6tuoywiJtjx2k9+Gj7KYL9VHmZ5tR8BE=;
        b=Rh9T0b4+6lqL3xYv140BWU5kZrxm3KzRhyb1CcdYKtT25U8Y8jSZnNrq7HQ+VtdAUr
         PxBX5vvZcUealsmSmV/s+DLtxkERwrdZv6YwME/mB5hp80/fyRn4B5fsf2D6R282pXrk
         nwViZ+CHCFAUIWZ52fSmeJ5Qqi2yk8CB56RuYnMGyVnu53RE7kUIoHgRy9H+T4/b+CAJ
         C37lf0fRYsZwQnWCezQoMzGpy9oWzzKKLles1CzdIiygehb1VvRKZRVUSzHPNzL+nhnZ
         W4t+MOqOyHMBkZjh9lhJRMix/oA+/Hm5Qrqcpv15NiM7ztNQi2Kz5HIOALX2Sy0O3WY8
         ViFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AtoA6q/GKeI6tuoywiJtjx2k9+Gj7KYL9VHmZ5tR8BE=;
        b=UwMs6YRfg9qRSeBIpG1mNcvxtjb1F90R6EiJyo4ey9CCvJpDsiWHHUUTA3XmDCtIX/
         lpdFH4kn2oSgkctbR+zHPqFVkK8rvEUyg8WRjfkJfixDOt8DhRzyo6pkNyyOqmT7OADc
         /7Gk/qSUWY9MaLtLEYiv2nuKpmplSeY2tBPG6Y7nf0S950t1AH7szrDyBa+1oUhY+h/D
         ev9ybqXO3oY/qBS4UO/jimPWEFZp+Pz69CEcVNn429fChsROaxmgcsHHJ+9hQE4qynx3
         fKZfr0Hq0v94k23Ila5FDrkvmDlDLM8UPITehimUGnuwDbeYRilAmT8Yah3hTo4Iy9eo
         linA==
X-Gm-Message-State: AOAM5300PcdLNtPTUa2Kbrr3xc1UoGbfkScoUs2VzXV+n9Bx19Ju2LI6
        ++mJzl4qj8UfrC+deEcuYbUbfCXuQOpqeg==
X-Google-Smtp-Source: ABdhPJybvMxR6U3SxlHhvfbdjFwwPGT8Zk6sMGweHZpeziLzTRGT/VmDGbZNB9KjK4LzTn+Efch9pA==
X-Received: by 2002:a5d:4411:: with SMTP id z17mr19819779wrq.59.1637157004494;
        Wed, 17 Nov 2021 05:50:04 -0800 (PST)
Received: from xps15.suse.de (ip5f5aa686.dynamic.kabel-deutschland.de. [95.90.166.134])
        by smtp.gmail.com with ESMTPSA id m14sm28290709wrp.28.2021.11.17.05.50.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 05:50:04 -0800 (PST)
From:   Varad Gautam <varadgautam@gmail.com>
X-Google-Original-From: Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, zxwang42@gmail.com,
        marcorr@google.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Subject: [RFC kvm-unit-tests 12/12] x86: AMD SEV-ES: Handle string IO for IOIO #VC
Date:   Wed, 17 Nov 2021 14:47:52 +0100
Message-Id: <20211117134752.32662-13-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117134752.32662-1-varad.gautam@suse.com>
References: <20211117134752.32662-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Using Linux's IOIO #VC processing logic.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 lib/x86/amd_sev_vc.c | 108 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 106 insertions(+), 2 deletions(-)

diff --git a/lib/x86/amd_sev_vc.c b/lib/x86/amd_sev_vc.c
index bb912e4..24db992 100644
--- a/lib/x86/amd_sev_vc.c
+++ b/lib/x86/amd_sev_vc.c
@@ -307,10 +307,46 @@ static enum es_result vc_ioio_exitinfo(struct es_em_ctxt *ctxt, u64 *exitinfo)
 	return ES_OK;
 }
 
+static enum es_result vc_insn_string_read(struct es_em_ctxt *ctxt,
+					  void *src, unsigned char *buf,
+					  unsigned int data_size,
+					  unsigned int count,
+					  bool backwards)
+{
+	int i, b = backwards ? -1 : 1;
+
+	for (i = 0; i < count; i++) {
+		void *s = src + (i * data_size * b);
+		unsigned char *d = buf + (i * data_size);
+
+		memcpy(d, s, data_size);
+	}
+
+	return ES_OK;
+}
+
+static enum es_result vc_insn_string_write(struct es_em_ctxt *ctxt,
+					   void *dst, unsigned char *buf,
+					   unsigned int data_size,
+					   unsigned int count,
+					   bool backwards)
+{
+	int i, s = backwards ? -1 : 1;
+
+	for (i = 0; i < count; i++) {
+		void *d = dst + (i * data_size * s);
+		unsigned char *b = buf + (i * data_size);
+
+		memcpy(d, b, data_size);
+	}
+
+	return ES_OK;
+}
+
 static enum es_result vc_handle_ioio(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 {
 	struct ex_regs *regs = ctxt->regs;
-	u64 exit_info_1;
+	u64 exit_info_1, exit_info_2;
 	enum es_result ret;
 
 	ret = vc_ioio_exitinfo(ctxt, &exit_info_1);
@@ -318,7 +354,75 @@ static enum es_result vc_handle_ioio(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 		return ret;
 
 	if (exit_info_1 & IOIO_TYPE_STR) {
-		ret = ES_VMM_ERROR;
+		/* (REP) INS/OUTS */
+
+		bool df = ((regs->rflags & X86_EFLAGS_DF) == X86_EFLAGS_DF);
+		unsigned int io_bytes, exit_bytes;
+		unsigned int ghcb_count, op_count;
+		unsigned long es_base;
+		u64 sw_scratch;
+
+		/*
+		 * For the string variants with rep prefix the amount of in/out
+		 * operations per #VC exception is limited so that the kernel
+		 * has a chance to take interrupts and re-schedule while the
+		 * instruction is emulated.
+		 */
+		io_bytes   = (exit_info_1 >> 4) & 0x7;
+		ghcb_count = sizeof(ghcb->shared_buffer) / io_bytes;
+
+		op_count    = (exit_info_1 & IOIO_REP) ? regs->rcx : 1;
+		exit_info_2 = op_count < ghcb_count ? op_count : ghcb_count;
+		exit_bytes  = exit_info_2 * io_bytes;
+
+		es_base = 0;
+
+		/* Read bytes of OUTS into the shared buffer */
+		if (!(exit_info_1 & IOIO_TYPE_IN)) {
+			ret = vc_insn_string_read(ctxt,
+					       (void *)(es_base + regs->rsi),
+					       ghcb->shared_buffer, io_bytes,
+					       exit_info_2, df);
+			if (ret)
+				return ret;
+		}
+
+		/*
+		 * Issue an VMGEXIT to the HV to consume the bytes from the
+		 * shared buffer or to have it write them into the shared buffer
+		 * depending on the instruction: OUTS or INS.
+		 */
+		sw_scratch = __pa(ghcb) + offsetof(struct ghcb, shared_buffer);
+		ghcb_set_sw_scratch(ghcb, sw_scratch);
+		ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_IOIO,
+					  exit_info_1, exit_info_2);
+		if (ret != ES_OK)
+			return ret;
+
+		/* Read bytes from shared buffer into the guest's destination. */
+		if (exit_info_1 & IOIO_TYPE_IN) {
+			ret = vc_insn_string_write(ctxt,
+						   (void *)(es_base + regs->rdi),
+						   ghcb->shared_buffer, io_bytes,
+						   exit_info_2, df);
+			if (ret)
+				return ret;
+
+			if (df)
+				regs->rdi -= exit_bytes;
+			else
+				regs->rdi += exit_bytes;
+		} else {
+			if (df)
+				regs->rsi -= exit_bytes;
+			else
+				regs->rsi += exit_bytes;
+		}
+
+		if (exit_info_1 & IOIO_REP)
+			regs->rcx -= exit_info_2;
+
+		ret = regs->rcx ? ES_RETRY : ES_OK;
 	} else {
 		/* IN/OUT into/from rAX */
 
-- 
2.32.0

