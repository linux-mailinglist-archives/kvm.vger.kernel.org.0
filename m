Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1139220A7B6
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 23:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406949AbgFYVrN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 17:47:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52041 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2406811AbgFYVrL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 17:47:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593121629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=kgGg8jMkbvcZ8iFUP5N32zhARfU1/gNnbQngU0bR5Hg=;
        b=Rtqf75KD2dBvAoHzq1W9gc/MJmWZB7Fj4HbeESG85+0NdG5hUSC0wXV2WV97ziKV43O/vw
        lSuI8UJ3XePpWztwX9RHt3MrxIjuzcq6LSgBvqa9Qn21ISeW7KgJIyBfZEZh3hzy2TStC5
        BBCsRcUPwbFWN2TfBoUTfxIlQRiN2Ko=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-mZZ0iYCOMZ-QZKedegce-g-1; Thu, 25 Jun 2020 17:47:05 -0400
X-MC-Unique: mZZ0iYCOMZ-QZKedegce-g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B53F4800C64;
        Thu, 25 Jun 2020 21:47:04 +0000 (UTC)
Received: from horse.redhat.com (ovpn-116-4.rdu2.redhat.com [10.10.116.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A9C915C240;
        Thu, 25 Jun 2020 21:47:01 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 4C3E6220244; Thu, 25 Jun 2020 17:47:01 -0400 (EDT)
Date:   Thu, 25 Jun 2020 17:47:01 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     virtio-fs@redhat.com, vkuznets@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com
Subject: [RFC PATCH] kvm,x86: Exit to user space in case of page fault error
Message-ID: <20200625214701.GA180786@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Page fault error handling behavior in kvm seems little inconsistent when
page fault reports error. If we are doing fault synchronously
then we capture error (-EFAULT) returned by __gfn_to_pfn_memslot() and
exit to user space and qemu reports error, "error: kvm run failed Bad address".

But if we are doing async page fault, then async_pf_execute() will simply
ignore the error reported by get_user_pages_remote() or
by kvm_mmu_do_page_fault(). It is assumed that page fault was successful
and either a page ready event is injected in guest or guest is brought
out of artificial halt state and run again. In both the cases when guest
retries the instruction, it takes exit again as page fault was not
successful in previous attempt. And then this infinite loop continues
forever.

Trying fault in a loop will make sense if error is temporary and will
be resolved on retry. But I don't see any intention in the code to
determine if error is temporary or not.  Whether to do fault synchronously
or asynchronously, depends on so many variables but none of the varibales
is whether error is temporary or not. (kvm_can_do_async_pf()).

And that makes it very inconsistent or unpredictable to figure out whether
kvm will exit to qemu with error or it will just retry and go into an
infinite loop.

This patch tries to make this behavior consistent. That is instead of
getting into infinite loop of retrying page fault, exit to user space
and stop VM if page fault error happens.

In future this can be improved by injecting errors into guest. As of
now we don't have any race free method to inject errors in guest.

When page fault error happens in async path save that pfn and when next
time guest retries, do a sync fault instead of async fault. So that if error
is encountered, we exit to qemu and avoid infinite loop.

As of now only one error pfn is stored and that means it could be
overwritten before next a retry from guest happens. But this is
just a hint and if we miss it, some other time we will catch it.
If this becomes an issue, we could maintain an array of error
gfn later to help ease the issue.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/mmu.h              |  2 +-
 arch/x86/kvm/mmu/mmu.c          |  2 +-
 arch/x86/kvm/x86.c              | 14 +++++++++++---
 4 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index be5363b21540..3c0677b9d3d5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -778,6 +778,7 @@ struct kvm_vcpu_arch {
 		unsigned long nested_apf_token;
 		bool delivery_as_pf_vmexit;
 		bool pageready_pending;
+		gfn_t error_gfn;
 	} apf;
 
 	/* OSVW MSRs (AMD only) */
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 444bb9c54548..d0a2a12c7bb6 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -60,7 +60,7 @@ void kvm_init_mmu(struct kvm_vcpu *vcpu, bool reset_roots);
 void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, u32 cr0, u32 cr4, u32 efer);
 void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 			     bool accessed_dirty, gpa_t new_eptp);
-bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu);
+bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu, gfn_t gfn);
 int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 				u64 fault_address, char *insn, int insn_len);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 76817d13c86e..a882a6a9f7a7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4078,7 +4078,7 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 	if (!async)
 		return false; /* *pfn has correct page already */
 
-	if (!prefault && kvm_can_do_async_pf(vcpu)) {
+	if (!prefault && kvm_can_do_async_pf(vcpu, cr2_or_gpa >> PAGE_SHIFT)) {
 		trace_kvm_try_async_get_page(cr2_or_gpa, gfn);
 		if (kvm_find_async_pf_gfn(vcpu, gfn)) {
 			trace_kvm_async_pf_doublefault(cr2_or_gpa, gfn);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3b92db412335..a6af7e9831b9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10380,7 +10380,9 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 	      work->arch.cr3 != vcpu->arch.mmu->get_guest_pgd(vcpu))
 		return;
 
-	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true);
+	r = kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true);
+	if (r < 0)
+		vcpu->arch.apf.error_gfn = work->cr2_or_gpa >> PAGE_SHIFT;
 }
 
 static inline u32 kvm_async_pf_hash_fn(gfn_t gfn)
@@ -10490,7 +10492,7 @@ static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
 	return true;
 }
 
-bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
+bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
 	if (unlikely(!lapic_in_kernel(vcpu) ||
 		     kvm_event_needs_reinjection(vcpu) ||
@@ -10504,7 +10506,13 @@ bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
 	 * If interrupts are off we cannot even use an artificial
 	 * halt state.
 	 */
-	return kvm_arch_interrupt_allowed(vcpu);
+	if (!kvm_arch_interrupt_allowed(vcpu))
+		return false;
+
+	if (vcpu->arch.apf.error_gfn == gfn)
+		return false;
+
+	return true;
 }
 
 bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
-- 
2.25.4

