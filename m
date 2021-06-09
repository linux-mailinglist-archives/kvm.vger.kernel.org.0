Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB633A20E3
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 01:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbhFIXo7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 19:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhFIXo4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 19:44:56 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45FE8C061574
        for <kvm@vger.kernel.org>; Wed,  9 Jun 2021 16:42:45 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id u7-20020a259b470000b02904dca50820c2so33538153ybo.11
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 16:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=VEMIxquREMiHOnk/Jwp5zKxKYIE/fmUnZrtCHKTS9JE=;
        b=cbLQOldlrEJpcz3ehwNa0GO97G4YQJTH0mM5y5ltEc8E+CH1uqML8Bj64K0EVu30JJ
         lQin+4Y57CJR9RBI/i6RMN2srl3OySvH7RVzRiYUXSqYZJ7/2rUS7VBGCUFDX6eVOGGV
         gorWsAPUaEBxLAmCAr0nMY/SJik9PG7v4ogEteRbF+T+iq3TpHt0ifU6AY2Hd+2QSAtr
         wwmzNLmP+dWZqu/w6oaNsUN8maJbimA0pnE8qGCoDj6PUjz5CWqnR2UuqdRQqXhH+UWi
         9Wzi29AG3Yrug992Nbg8VDpxOjSnIoR00AXzvMuZg4FabugdtEYLObZEeBtqjJbh5MmE
         HGew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=VEMIxquREMiHOnk/Jwp5zKxKYIE/fmUnZrtCHKTS9JE=;
        b=N+A43LTnqGJHU8nQ0eoAeRyeGNHcxGsmXUHNgfJpjThoplLG8vBMgI694KZd6ZiJro
         0bDkW+4czr6xNyZTQSUyAZzW4AZv0iuOSM5tga6z+0Xs6VU4LhKWwA5pD/jqkIs/4RwI
         D0Y/xysJWQjaXCHAiE6Nk9eUEHVaFZx5JioSthTdNIkbfOwNNWmFxzVnFuxPcp37Ipfr
         Fj49CKiURXjVdcIJeqYj6hKXR35k/EUhQsPfGCpg+AgiL9+dspACUl/NVfJQDWJfjuG3
         st4QgpvJMDN6/Vv7wpD1GXKH76LRdQ4e5h66rKndswa+iqeIMkhV8ifcxtVTAisr6o4t
         tUTQ==
X-Gm-Message-State: AOAM530NL6Gi6RhXjmtSZIPDJsfz8C81aLz5bGVHcYqnlod6c1eVEk9k
        PPQZiA5yUX6zS/ke7QdgT2wOhnR8fmc=
X-Google-Smtp-Source: ABdhPJzQvihd2dKUwtYo1j9tsKMwkQ02mHyj3HmBM1skP2T35iB6n8uIriD5vHGZbWoTiEXqps95CbyFTp8=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:8daf:e5e:ae50:4f28])
 (user=seanjc job=sendgmr) by 2002:a25:4fc4:: with SMTP id d187mr3417113ybb.245.1623282164446;
 Wed, 09 Jun 2021 16:42:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  9 Jun 2021 16:42:21 -0700
In-Reply-To: <20210609234235.1244004-1-seanjc@google.com>
Message-Id: <20210609234235.1244004-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210609234235.1244004-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH 01/15] KVM: nVMX: Sync all PGDs on nested transition with
 shadow paging
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Junaid Shahid <junaids@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Trigger a full TLB flush on behalf of the guest on nested VM-Enter and
VM-Exit when VPID is disabled for L2.  kvm_mmu_new_pgd() syncs only the
current PGD, which can theoretically leave stale, unsync'd entries in a
previous guest PGD, which could be consumed if L2 is allowed to load CR3
with PCID_NOFLUSH=1.

Rename KVM_REQ_HV_TLB_FLUSH to KVM_REQ_TLB_FLUSH_GUEST so that it can
be utilized for its obvious purpose of emulating a guest TLB flush.

Note, there is no change the actual TLB flush executed by KVM, even
though the fast PGD switch uses KVM_REQ_TLB_FLUSH_CURRENT.  When VPID is
disabled for L2, vpid02 is guaranteed to be '0', and thus
nested_get_vpid02() will return the VPID that is shared by L1 and L2.

Generate the request outside of kvm_mmu_new_pgd(), as getting the common
helper to correctly identify which requested is needed is quite painful.
E.g. using KVM_REQ_TLB_FLUSH_GUEST when nested EPT is in play is wrong as
a TLB flush from the L1 kernel's perspective does not invalidate EPT
mappings.  And, by using KVM_REQ_TLB_FLUSH_GUEST, nVMX can do future
simplification by moving the logic into nested_vmx_transition_tlb_flush().

Fixes: 41fab65e7c44 ("KVM: nVMX: Skip MMU sync on nested VMX transition when possible")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/hyperv.c           |  2 +-
 arch/x86/kvm/vmx/nested.c       | 17 ++++++++++++-----
 arch/x86/kvm/x86.c              |  2 +-
 4 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9c7ced0e3171..6652e51a86fd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -85,7 +85,7 @@
 #define KVM_REQ_APICV_UPDATE \
 	KVM_ARCH_REQ_FLAGS(25, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_TLB_FLUSH_CURRENT	KVM_ARCH_REQ(26)
-#define KVM_REQ_HV_TLB_FLUSH \
+#define KVM_REQ_TLB_FLUSH_GUEST \
 	KVM_ARCH_REQ_FLAGS(27, KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_APF_READY		KVM_ARCH_REQ(28)
 #define KVM_REQ_MSR_FILTER_CHANGED	KVM_ARCH_REQ(29)
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index f00830e5202f..fdd1eca717fd 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1704,7 +1704,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, u64 ingpa, u16 rep_cnt, bool
 	 * vcpu->arch.cr3 may not be up-to-date for running vCPUs so we can't
 	 * analyze it here, flush TLB regardless of the specified address space.
 	 */
-	kvm_make_vcpus_request_mask(kvm, KVM_REQ_HV_TLB_FLUSH,
+	kvm_make_vcpus_request_mask(kvm, KVM_REQ_TLB_FLUSH_GUEST,
 				    NULL, vcpu_mask, &hv_vcpu->tlb_flush);
 
 ret_success:
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6058a65a6ede..1c243758dd2c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1127,12 +1127,19 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool ne
 
 	/*
 	 * Unconditionally skip the TLB flush on fast CR3 switch, all TLB
-	 * flushes are handled by nested_vmx_transition_tlb_flush().  See
-	 * nested_vmx_transition_mmu_sync for details on skipping the MMU sync.
+	 * flushes are handled by nested_vmx_transition_tlb_flush().
 	 */
-	if (!nested_ept)
-		kvm_mmu_new_pgd(vcpu, cr3, true,
-				!nested_vmx_transition_mmu_sync(vcpu));
+	if (!nested_ept) {
+		kvm_mmu_new_pgd(vcpu, cr3, true, true);
+
+		/*
+		 * A TLB flush on VM-Enter/VM-Exit flushes all linear mappings
+		 * across all PCIDs, i.e. all PGDs need to be synchronized.
+		 * See nested_vmx_transition_mmu_sync() for more details.
+		 */
+		if (nested_vmx_transition_mmu_sync(vcpu))
+			kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
+	}
 
 	vcpu->arch.cr3 = cr3;
 	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9dd23bdfc6cc..905de6854efa 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9167,7 +9167,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		}
 		if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
 			kvm_vcpu_flush_tlb_current(vcpu);
-		if (kvm_check_request(KVM_REQ_HV_TLB_FLUSH, vcpu))
+		if (kvm_check_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu))
 			kvm_vcpu_flush_tlb_guest(vcpu);
 
 		if (kvm_check_request(KVM_REQ_REPORT_TPR_ACCESS, vcpu)) {
-- 
2.32.0.rc1.229.g3e70b5a671-goog

