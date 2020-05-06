Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E88891C674F
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 07:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgEFFMc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 01:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725857AbgEFFMb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 01:12:31 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6D5C061A0F;
        Tue,  5 May 2020 22:12:31 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1003)
        id 49H4Tl5Brzz9sSw; Wed,  6 May 2020 15:12:27 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1588741947; bh=Jt8KIzci0gy2YxX2jQYZA8AehfqZw/2Pk9tmasBajkU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rgy/bb75LbWZAJRxY1RKVgfXYFjWXLSye77DI8lVkNAgfHno2PfywNXmU7vMgX8hc
         2rrq8Okwk2tS5IIseRULN7zPnI5VXxwwfLE+K+P0ocVhq7uggO4u8XUzdtemHGehAg
         1NNKjf2qG2WDxt8hm0yIHea+48jiocskLlz9bD/gh/ASCe8BW1kIzCUQDyFMxdeYZ4
         SeOtIOB//TtXlKwn+yriPo4ROhWTBgsire5zuWILuWmB69qKdMWEmaEC7y8dUsiS3m
         emHKC4lwdaC6Mg70VNB25fX7OBfm04CzvCqbdVJ3lfkSnhC9w6kTmztCPJHtpkr8v+
         CWXmUOSKumUhw==
Date:   Wed, 6 May 2020 15:12:18 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Laurent Vivier <lvivier@redhat.com>
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 4/4] KVM: PPC: Book3S HV: Flush guest mappings when
 turning dirty tracking on/off
Message-ID: <20200506051217.GA24968@blackberry>
References: <20181212041430.GA22265@blackberry>
 <20181212041717.GE22265@blackberry>
 <58247760-00de-203d-a779-7fda3a739248@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58247760-00de-203d-a779-7fda3a739248@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 05:57:59PM +0200, Laurent Vivier wrote:
> On 12/12/2018 05:17, Paul Mackerras wrote:
> > +	if (change == KVM_MR_FLAGS_ONLY && kvm_is_radix(kvm) &&
> > +	    ((new->flags ^ old->flags) & KVM_MEM_LOG_DIRTY_PAGES))
> > +		kvmppc_radix_flush_memslot(kvm, old);
> >  }
> 
> Hi,
> 
> this part introduces a regression in QEMU test suite.
> 
> We have the following warning in the host kernel log:
> 
[snip]
> 
> The problem is detected with the "migration-test" test program in qemu,
> on a POWER9 host in radix mode with THP. It happens only the first time
> the test program is run after loading kvm_hv. The warning is an explicit
> detection [1] of a problem:

Yes, we found a valid PTE where we didn't expect there to be one.

[snip]
> I reproduce the problem in QEMU 4.2 build directory with :
> 
>  sudo rmmod kvm_hv
>  sudo modprobe kvm_hv
>  make check-qtest-ppc64
> 
> or once the test binary is built with
> 
>  sudo rmmod kvm_hv
>  sudo modprobe kvm_hv
>  export QTEST_QEMU_BINARY=ppc64-softmmu/qemu-system-ppc64
>  tests/qtest/migration-test
> 
> The sub-test is "/migration/validate_uuid_error" that generates some
> memory stress with a SLOF program in the source guest and fails because
> of a mismatch with the destination guest. So the source guest continues
> to execute the stress program while the migration is aborted.
> 
> Another way to reproduce the problem is:
> 
> Source guest:
> 
> sudo rmmod kvm-hv
> sudo modprobe kvm-hv
> qemu-system-ppc64 -display none -accel kvm -name source -m 256M \
>                   -nodefaults -prom-env use-nvramrc?=true \
>                   -prom-env 'nvramrc=hex ." _" begin 6400000 100000 \
>                   do i c@ 1 + i c! 1000 +loop ." B" 0 until' -monitor \
>                   stdio
> 
> Destination guest (on the same host):
> 
> qemu-system-ppc64 -display none -accel kvm -name source -m 512M \
>                   -nodefaults -monitor stdio -incoming tcp:0:4444
> 
> Then in source guest monitor:
> 
> (qemu) migrate tcp:localhost:4444
> 
> The migration intentionally fails because of a memory size mismatch and
> the warning is generated in the host kernel log.

I built QEMU 4.2 and tried all three methods you list without seeing
the problem manifest itself.  Is there any other configuration
regarding THP or anything necessary?

I was using the patch below, which you could try also, since you are
better able to trigger the problem.  I never saw the "flush_memslot
was necessary" message nor the WARN_ON.  If you see the flush_memslot
message then that will give us a clue as to where the problem is
coming from.

Regards,
Paul.

--
diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include/asm/kvm_book3s.h
index 506e4df2d730..14ddf1411279 100644
--- a/arch/powerpc/include/asm/kvm_book3s.h
+++ b/arch/powerpc/include/asm/kvm_book3s.h
@@ -220,7 +220,7 @@ extern int kvm_test_age_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
 			unsigned long gfn);
 extern long kvmppc_hv_get_dirty_log_radix(struct kvm *kvm,
 			struct kvm_memory_slot *memslot, unsigned long *map);
-extern void kvmppc_radix_flush_memslot(struct kvm *kvm,
+extern int kvmppc_radix_flush_memslot(struct kvm *kvm,
 			const struct kvm_memory_slot *memslot);
 extern int kvmhv_get_rmmu_info(struct kvm *kvm, struct kvm_ppc_rmmu_info *info);
 
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index aa12cd4078b3..930042632d8f 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -433,7 +433,7 @@ static void kvmppc_unmap_free_pte(struct kvm *kvm, pte_t *pte, bool full,
 		for (it = 0; it < PTRS_PER_PTE; ++it, ++p) {
 			if (pte_val(*p) == 0)
 				continue;
-			WARN_ON_ONCE(1);
+			WARN_ON(1);
 			kvmppc_unmap_pte(kvm, p,
 					 pte_pfn(*p) << PAGE_SHIFT,
 					 PAGE_SHIFT, NULL, lpid);
@@ -1092,30 +1092,34 @@ long kvmppc_hv_get_dirty_log_radix(struct kvm *kvm,
 	return 0;
 }
 
-void kvmppc_radix_flush_memslot(struct kvm *kvm,
+int kvmppc_radix_flush_memslot(struct kvm *kvm,
 				const struct kvm_memory_slot *memslot)
 {
 	unsigned long n;
 	pte_t *ptep;
 	unsigned long gpa;
 	unsigned int shift;
+	int ret = 0;
 
 	if (kvm->arch.secure_guest & KVMPPC_SECURE_INIT_START)
 		kvmppc_uvmem_drop_pages(memslot, kvm, true);
 
 	if (kvm->arch.secure_guest & KVMPPC_SECURE_INIT_DONE)
-		return;
+		return 0;
 
 	gpa = memslot->base_gfn << PAGE_SHIFT;
 	spin_lock(&kvm->mmu_lock);
 	for (n = memslot->npages; n; --n) {
 		ptep = __find_linux_pte(kvm->arch.pgtable, gpa, NULL, &shift);
-		if (ptep && pte_present(*ptep))
+		if (ptep && pte_present(*ptep)) {
 			kvmppc_unmap_pte(kvm, ptep, gpa, shift, memslot,
 					 kvm->arch.lpid);
+			ret = 1;
+		}
 		gpa += PAGE_SIZE;
 	}
 	spin_unlock(&kvm->mmu_lock);
+	return ret;
 }
 
 static void add_rmmu_ap_encoding(struct kvm_ppc_rmmu_info *info,
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 93493f0cbfe8..40b50f867835 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4508,6 +4508,10 @@ static void kvmppc_core_commit_memory_region_hv(struct kvm *kvm,
 	if (change == KVM_MR_FLAGS_ONLY && kvm_is_radix(kvm) &&
 	    ((new->flags ^ old->flags) & KVM_MEM_LOG_DIRTY_PAGES))
 		kvmppc_radix_flush_memslot(kvm, old);
+	else if (kvm_is_radix(kvm) && kvmppc_radix_flush_memslot(kvm, old))
+		pr_err("flush_memslot was necessary - change = %d flags %x -> %x\n",
+		       change, old->flags, new->flags);
+
 	/*
 	 * If UV hasn't yet called H_SVM_INIT_START, don't register memslots.
 	 */
