Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F07B4547C7
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 14:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbhKQNxB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 08:53:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237900AbhKQNxA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 08:53:00 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF5FDC061570
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 05:50:01 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id d27so4844047wrb.6
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 05:50:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W/WPJseiDWII0ZLeJwuVUEstTgCWEJ8F8dVgfT5JFVA=;
        b=jWXOooA6KCcxa++OWoBSPVU/rRmkONjNlbpdbfLkfb+13BI6eAV+JewPeqrDVo8D5G
         G8yLijGR0UKprrUM92nhHvGxe68xBDFMDqirZB07wvghlIdvhU8kCKJLkH538stXcnLz
         AK087MJ5aU47344SDh04wqW8l2tUL1ziNuEb4sKpAkanxP0thOsJPOjxiASW3/L+gfBt
         hmNSlzIvjZngLgNGnbEt5UO2bcw+H1uR9zj0DnbxFBRpwnRpYve9VKk2IJK4A887UGNS
         KJugGKVufvQIkcA0nG2yNrRtaYUrxpjyVbtSHts1YDrsBPvq+caabwWLV6KlCD+XhM6i
         AUeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W/WPJseiDWII0ZLeJwuVUEstTgCWEJ8F8dVgfT5JFVA=;
        b=YXjB2vVErpx0JeVinU3b2Z8+P29aVO3QLL5hLL0CAX8ue8sdFjE7F0vfGnSml7/7oc
         qwdilP4nb6aqt+ub+abdBxxKL1h532R9Vxrb0fyAE23Sosev9eHaqoCQQhukMVPC6ExK
         zEfWq8LmYjdrDWMaqk09hKv2MSRIMwGTjEmI0shksHlgsD/tV1hevzWR2GeU2G8mADS/
         HLi/NW7HpGHSEv+yDZ8DM+kA5vuIeF9ZoYpYIDlRNC4FQhTw4WRza2XTb29DL7Bv6OMs
         nwpeSR1tecTZxRxfsiGgIpuwwvFFzM9MOldkbpwL9NcevdISKiSHg2Hl1Q1/H3ZwKTGh
         deBQ==
X-Gm-Message-State: AOAM532/3Sv/sXdUbuGAmrkiTI+buWhrx9UNcm9Avte/KOChJpLzfjug
        LmsSPCQ7REwHjVPLGQdpA+bHWXgm4BJWNQ==
X-Google-Smtp-Source: ABdhPJwfPKoKOg1SpSs6ertKslg7qaHTOxq8/dtddcDOSTl1HHQhYktc+egtWk+dlLuJ4KZzcjiNOw==
X-Received: by 2002:a5d:4cd1:: with SMTP id c17mr20406663wrt.31.1637156999882;
        Wed, 17 Nov 2021 05:49:59 -0800 (PST)
Received: from xps15.suse.de (ip5f5aa686.dynamic.kabel-deutschland.de. [95.90.166.134])
        by smtp.gmail.com with ESMTPSA id m14sm28290709wrp.28.2021.11.17.05.49.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 05:49:59 -0800 (PST)
From:   Varad Gautam <varadgautam@gmail.com>
X-Google-Original-From: Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, zxwang42@gmail.com,
        marcorr@google.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Subject: [RFC kvm-unit-tests 08/12] x86: AMD SEV-ES: Handle CPUID #VC
Date:   Wed, 17 Nov 2021 14:47:48 +0100
Message-Id: <20211117134752.32662-9-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117134752.32662-1-varad.gautam@suse.com>
References: <20211117134752.32662-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Using Linux's CPUID #VC processing logic.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 lib/x86/amd_sev_vc.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/lib/x86/amd_sev_vc.c b/lib/x86/amd_sev_vc.c
index 27a3ed0..91f57e0 100644
--- a/lib/x86/amd_sev_vc.c
+++ b/lib/x86/amd_sev_vc.c
@@ -2,6 +2,7 @@
 
 #include "amd_sev.h"
 #include "svm.h"
+#include "x86/xsave.h"
 
 extern phys_addr_t ghcb_addr;
 
@@ -115,6 +116,43 @@ static enum es_result vc_handle_wbinvd(struct ghcb *ghcb,
 	return sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_WBINVD, 0, 0);
 }
 
+static enum es_result vc_handle_cpuid(struct ghcb *ghcb,
+				      struct es_em_ctxt *ctxt)
+{
+	struct ex_regs *regs = ctxt->regs;
+	u32 cr4 = read_cr4();
+	enum es_result ret;
+
+	ghcb_set_rax(ghcb, regs->rax);
+	ghcb_set_rcx(ghcb, regs->rcx);
+
+	if (cr4 & X86_CR4_OSXSAVE) {
+		/* Safe to read xcr0 */
+		u64 xcr0;
+		xgetbv_checking(XCR_XFEATURE_ENABLED_MASK, &xcr0);
+		ghcb_set_xcr0(ghcb, xcr0);
+	} else
+		/* xgetbv will cause #GP - use reset value for xcr0 */
+		ghcb_set_xcr0(ghcb, 1);
+
+	ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_CPUID, 0, 0);
+	if (ret != ES_OK)
+		return ret;
+
+	if (!(ghcb_rax_is_valid(ghcb) &&
+	      ghcb_rbx_is_valid(ghcb) &&
+	      ghcb_rcx_is_valid(ghcb) &&
+	      ghcb_rdx_is_valid(ghcb)))
+		return ES_VMM_ERROR;
+
+	regs->rax = ghcb->save.rax;
+	regs->rbx = ghcb->save.rbx;
+	regs->rcx = ghcb->save.rcx;
+	regs->rdx = ghcb->save.rdx;
+
+	return ES_OK;
+}
+
 static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
 					 struct ghcb *ghcb,
 					 unsigned long exit_code)
@@ -125,6 +163,9 @@ static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
 	case SVM_EXIT_WBINVD:
 		result = vc_handle_wbinvd(ghcb, ctxt);
 		break;
+	case SVM_EXIT_CPUID:
+		result = vc_handle_cpuid(ghcb, ctxt);
+		break;
 	default:
 		/*
 		 * Unexpected #VC exception
-- 
2.32.0

