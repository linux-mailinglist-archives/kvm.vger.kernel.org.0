Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE9932F293
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 19:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhCESbp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 13:31:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhCESbe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Mar 2021 13:31:34 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058A6C061574
        for <kvm@vger.kernel.org>; Fri,  5 Mar 2021 10:31:34 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id l3so3358822ybf.17
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 10:31:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=zBZf9XbdDoEer6H8DADVbIaEOxSfCjbFi3iuHxyt0ms=;
        b=KTBDgfSe5LeIa7xBzM3hFQj0aQ3RG9tRlpRCR+pTgtUywvTNIB3ryG/8bSK50XMw9m
         H5PgIlYyQHOjzDcBW91MWbWh73qcIxs0ABT/4WYclZ8LzKk7lfe+eCCxc2USWdAJyNzx
         cMajkXr813oxu/VepDXvf0lmelSMr7/yGorz+YtQkXMYwcjfwUP13kEWZg1sppqDW5aq
         fWgD45BVM4tPpZIYU/KiVsRmc37YJtTMjykfV2GJvzCGZ99m0/OntnsBFCrWZ5/i2Rmq
         ZO+b2CRC5AfqrjPWExPVULtpwDmMIuXSqMuWLtzqlIt01G1P0tMXHr291xfduRI4pXwF
         yRBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=zBZf9XbdDoEer6H8DADVbIaEOxSfCjbFi3iuHxyt0ms=;
        b=cX85bOrW3Hax5lc/cEPyAAD3rUIHJolTZboBC71fIsbUJpuwlmo+rnnpU8xKclHTKC
         ZDBNPrrX0yAECWLcWzYnPp4BkLigE1rzKzh1MtjPnTdUQj+ZMOVlYdS4c/1oGxuD4gI4
         C9D88zcnKHf1M5jdjwKQkuE6b4uqfC2SntTXlRPWQolzsXLY2Cuc20iWCa0LRytR8+wm
         Ui5w65xp0EszuRBBK/Wz+I6+FBBnuFpYiBMmTo0mMmE65e4I4tHxaSzv+fm+tvOG4jOL
         v7VMBNcb9+fwZWk6CE4TkffFaRSroOtbdn3l/wDLjoaOnKx78vZ7bOzyhmbKfZYzuqj/
         8Diw==
X-Gm-Message-State: AOAM530Ech0hXc5Qy3P9DGTemfMWg7GmibvOeahJh7hrlafaSqu2t/f+
        F3IGPVcU05IWfJ+e1hKNm/n/ZVyRJI4=
X-Google-Smtp-Source: ABdhPJwsYNYgV7c0HUnqJhultwv9JP3/XlFG52G5c1klvEbzi232XiE57OGPzBaI7ZfoTxRLwMySpuPMb/4=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:9857:be95:97a2:e91c])
 (user=seanjc job=sendgmr) by 2002:a25:38d6:: with SMTP id f205mr16093928yba.448.1614969093316;
 Fri, 05 Mar 2021 10:31:33 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  5 Mar 2021 10:31:14 -0800
In-Reply-To: <20210305183123.3978098-1-seanjc@google.com>
Message-Id: <20210305183123.3978098-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210305183123.3978098-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v4 02/11] KVM: VMX: Track common EPTP for Hyper-V's paravirt
 TLB flush
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

Explicitly track the EPTP that is common to all vCPUs instead of
grabbing vCPU0's EPTP when invoking Hyper-V's paravirt TLB flush.
Tracking the EPTP will allow optimizing the checks when loading a new
EPTP and will also allow dropping ept_pointer_match, e.g. by marking
the common EPTP as invalid.

This also technically fixes a bug where KVM could theoretically flush an
invalid GPA if all vCPUs have an invalid root.  In practice, it's likely
impossible to trigger a remote TLB flush in such a scenario.  In any
case, the superfluous flush is completely benign.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 20 +++++++++-----------
 arch/x86/kvm/vmx/vmx.h |  1 +
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index dde2ebc7cf3a..4082c7a26612 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -483,12 +483,14 @@ static void check_ept_pointer_match(struct kvm *kvm)
 		if (!VALID_PAGE(tmp_eptp)) {
 			tmp_eptp = to_vmx(vcpu)->ept_pointer;
 		} else if (tmp_eptp != to_vmx(vcpu)->ept_pointer) {
+			to_kvm_vmx(kvm)->hv_tlb_eptp = INVALID_PAGE;
 			to_kvm_vmx(kvm)->ept_pointers_match
 				= EPT_POINTERS_MISMATCH;
 			return;
 		}
 	}
 
+	to_kvm_vmx(kvm)->hv_tlb_eptp = tmp_eptp;
 	to_kvm_vmx(kvm)->ept_pointers_match = EPT_POINTERS_MATCH;
 }
 
@@ -501,21 +503,18 @@ static int kvm_fill_hv_flush_list_func(struct hv_guest_mapping_flush_list *flush
 			range->pages);
 }
 
-static inline int __hv_remote_flush_tlb_with_range(struct kvm *kvm,
-		struct kvm_vcpu *vcpu, struct kvm_tlb_range *range)
+static inline int hv_remote_flush_eptp(u64 eptp, struct kvm_tlb_range *range)
 {
-	u64 ept_pointer = to_vmx(vcpu)->ept_pointer;
-
 	/*
 	 * FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE hypercall needs address
 	 * of the base of EPT PML4 table, strip off EPT configuration
 	 * information.
 	 */
 	if (range)
-		return hyperv_flush_guest_mapping_range(ept_pointer & PAGE_MASK,
+		return hyperv_flush_guest_mapping_range(eptp & PAGE_MASK,
 				kvm_fill_hv_flush_list_func, (void *)range);
 	else
-		return hyperv_flush_guest_mapping(ept_pointer & PAGE_MASK);
+		return hyperv_flush_guest_mapping(eptp & PAGE_MASK);
 }
 
 static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
@@ -533,12 +532,11 @@ static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
 		kvm_for_each_vcpu(i, vcpu, kvm) {
 			/* If ept_pointer is invalid pointer, bypass flush request. */
 			if (VALID_PAGE(to_vmx(vcpu)->ept_pointer))
-				ret |= __hv_remote_flush_tlb_with_range(
-					kvm, vcpu, range);
+				ret |= hv_remote_flush_eptp(to_vmx(vcpu)->ept_pointer,
+							    range);
 		}
-	} else {
-		ret = __hv_remote_flush_tlb_with_range(kvm,
-				kvm_get_vcpu(kvm, 0), range);
+	} else if (VALID_PAGE(to_kvm_vmx(kvm)->hv_tlb_eptp)) {
+		ret = hv_remote_flush_eptp(to_kvm_vmx(kvm)->hv_tlb_eptp, range);
 	}
 
 	spin_unlock(&to_kvm_vmx(kvm)->ept_pointer_lock);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 4795955490cb..f846cf3a5d25 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -351,6 +351,7 @@ struct kvm_vmx {
 	bool ept_identity_pagetable_done;
 	gpa_t ept_identity_map_addr;
 
+	hpa_t hv_tlb_eptp;
 	enum ept_pointers_status ept_pointers_match;
 	spinlock_t ept_pointer_lock;
 };
-- 
2.30.1.766.gb4fecdf3b7-goog

