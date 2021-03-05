Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C08932F2A8
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 19:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhCESfP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 13:35:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbhCESbn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Mar 2021 13:31:43 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B4BC061756
        for <kvm@vger.kernel.org>; Fri,  5 Mar 2021 10:31:43 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id i188so2460077qkd.7
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 10:31:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=nktY5YypTxDE2PiApdZomAuTOvGlFQpDvQWISfSElkE=;
        b=GC/itasiXPuxLa1SrfizgHqvBQTVq6rY/d1sMzoZu0HxJrSwxfE1bK2gXS+BqEQxOt
         f5svi/6XBf9Ds7rQvhyBss8A/kiP7XIsD3N5drIlL7zy0ifNk2RazXmkAqKYDY2e2z+7
         zju/INmjUxdyaWzKtMZvZvBJDxwrHWhVX9orFUsX1Uuv3fge0mmMYFGdm+bOt1aNnZMv
         NTOJ4hUyfkKb57P24oRiwyUn2yIFOssOEcuhEIVlzZ5zeLAq0+Me1L8m2SpetfIDhsDw
         dlhIndOpoHBpiZECkRiVW2WaRxR1lgRqDPVkTzwpXzOkhGyjJ8yLs8peeWCDBIs7pG+G
         Kcww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=nktY5YypTxDE2PiApdZomAuTOvGlFQpDvQWISfSElkE=;
        b=qMQg2HtsUt71iDgnXAKcRcPxKQZ4YrIlR36LBWUmEppdVV7oEDekZ07pc/y2vscZ7o
         a6BTFRBMMzxVIZSkeh1ErNwgiyz4KbOkR4rP+/T7JB27PRt7xRkNDA6RI4Ewf5XHErBB
         LTRPonUrjecAUAOSISuERKOdUFqWLOIuBxJ+pwT+Hnq/xksMEu0Fx56ZI0YBbfCwb4IG
         4bcBF4cGBF/L6m52HoNd/nIwWxhQu8Jy+ix+V/obu6moiNFEobm6MgqCxFTzqiGjqBen
         pZ9Qc8GAcNRAhu6vQvS95kZJu5V6cKAXrSWtraSiMs+Fez+ZojZiJpk1kkZsFnCKSrsh
         1AbA==
X-Gm-Message-State: AOAM5330l+ggcX6CvRbbq1yjsNg0nUFqXv4i9UoG2JJQA5iohJMVFOc3
        FW2O1ayuSQ1T5MljlYWzlPgReQcyPN8=
X-Google-Smtp-Source: ABdhPJwZ+2c//1yanDKNKhMsNxKtczbRMMwVEh90as4xQI484nk2bKXYLo7uENk/cvEKqyPDFw3H/zHsS18=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:9857:be95:97a2:e91c])
 (user=seanjc job=sendgmr) by 2002:a05:6214:1424:: with SMTP id
 o4mr10183490qvx.34.1614969102470; Fri, 05 Mar 2021 10:31:42 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  5 Mar 2021 10:31:18 -0800
In-Reply-To: <20210305183123.3978098-1-seanjc@google.com>
Message-Id: <20210305183123.3978098-7-seanjc@google.com>
Mime-Version: 1.0
References: <20210305183123.3978098-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v4 06/11] KVM: VMX: Invalidate hv_tlb_eptp to denote an EPTP mismatch
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Drop the dedicated 'ept_pointers_match' field in favor of stuffing
'hv_tlb_eptp' with INVALID_PAGE to mark it as invalid, i.e. to denote
that there is at least one EPTP mismatch.  Use a local variable to
track whether or not a mismatch is detected so that hv_tlb_eptp can be
used to skip redundant flushes.

No functional change intended.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 35 +++++++++++++++++++++++------------
 arch/x86/kvm/vmx/vmx.h |  7 -------
 2 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a1a5b411c903..2582df5ae64d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -500,32 +500,44 @@ static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
 {
 	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
 	struct kvm_vcpu *vcpu;
-	int ret = 0, i;
+	int ret = 0, i, nr_unique_valid_eptps;
 	u64 tmp_eptp;
 
 	spin_lock(&kvm_vmx->ept_pointer_lock);
 
-	if (kvm_vmx->ept_pointers_match != EPT_POINTERS_MATCH) {
-		kvm_vmx->ept_pointers_match = EPT_POINTERS_MATCH;
-		kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
+	if (!VALID_PAGE(kvm_vmx->hv_tlb_eptp)) {
+		nr_unique_valid_eptps = 0;
 
+		/*
+		 * Flush all valid EPTPs, and see if all vCPUs have converged
+		 * on a common EPTP, in which case future flushes can skip the
+		 * loop and flush the common EPTP.
+		 */
 		kvm_for_each_vcpu(i, vcpu, kvm) {
 			tmp_eptp = to_vmx(vcpu)->ept_pointer;
 			if (!VALID_PAGE(tmp_eptp) ||
 			    tmp_eptp == kvm_vmx->hv_tlb_eptp)
 				continue;
 
-			if (!VALID_PAGE(kvm_vmx->hv_tlb_eptp))
+			/*
+			 * Set the tracked EPTP to the first valid EPTP.  Keep
+			 * this EPTP for the entirety of the loop even if more
+			 * EPTPs are encountered as a low effort optimization
+			 * to avoid flushing the same (first) EPTP again.
+			 */
+			if (++nr_unique_valid_eptps == 1)
 				kvm_vmx->hv_tlb_eptp = tmp_eptp;
-			else
-				kvm_vmx->ept_pointers_match
-					= EPT_POINTERS_MISMATCH;
 
 			ret |= hv_remote_flush_eptp(tmp_eptp, range);
 		}
-		if (kvm_vmx->ept_pointers_match == EPT_POINTERS_MISMATCH)
+
+		/*
+		 * The optimized flush of a single EPTP can't be used if there
+		 * are multiple valid EPTPs (obviously).
+		 */
+		if (nr_unique_valid_eptps > 1)
 			kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
-	} else if (VALID_PAGE(kvm_vmx->hv_tlb_eptp)) {
+	} else {
 		ret = hv_remote_flush_eptp(kvm_vmx->hv_tlb_eptp, range);
 	}
 
@@ -3105,8 +3117,7 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 		if (kvm_x86_ops.tlb_remote_flush) {
 			spin_lock(&to_kvm_vmx(kvm)->ept_pointer_lock);
 			to_vmx(vcpu)->ept_pointer = eptp;
-			to_kvm_vmx(kvm)->ept_pointers_match
-				= EPT_POINTERS_CHECK;
+			to_kvm_vmx(kvm)->hv_tlb_eptp = INVALID_PAGE;
 			spin_unlock(&to_kvm_vmx(kvm)->ept_pointer_lock);
 		}
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index f846cf3a5d25..fb7b2000bd0e 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -338,12 +338,6 @@ struct vcpu_vmx {
 	} shadow_msr_intercept;
 };
 
-enum ept_pointers_status {
-	EPT_POINTERS_CHECK = 0,
-	EPT_POINTERS_MATCH = 1,
-	EPT_POINTERS_MISMATCH = 2
-};
-
 struct kvm_vmx {
 	struct kvm kvm;
 
@@ -352,7 +346,6 @@ struct kvm_vmx {
 	gpa_t ept_identity_map_addr;
 
 	hpa_t hv_tlb_eptp;
-	enum ept_pointers_status ept_pointers_match;
 	spinlock_t ept_pointer_lock;
 };
 
-- 
2.30.1.766.gb4fecdf3b7-goog

