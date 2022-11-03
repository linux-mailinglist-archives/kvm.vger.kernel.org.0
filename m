Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D07E6174B1
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 04:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbiKCDAB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 23:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiKCC7t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 22:59:49 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F1591409A
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 19:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667444388; x=1698980388;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vOHdVYqFkxFlPepVtfD8ZP8UFRRj90Zns/jkEJ2oBR4=;
  b=F23zUv22abyw99WnawwYKcnPKHzziyr4EPbLxSb7PpymQ38qJli3NDdQ
   chDEx3IHilYH8CwYm6m+CYGer9ugYfzoVxsfUKfbc/JpM8pO9I3W+yVHG
   cmfcfA96lXNUGufg9aUBUhjy81T91rQS3C065g0D021mdrm5JHdzaFtbz
   cJj3K4hUHTibsQZReZeLT14jCj040FmeATcRfC+IZSoCPhmpTzmEgpmV3
   jVhb25kJsJ2SyI7ch8VSsPOdd9fGhPwCzyqb1gzOVa867Sicx6BTsa0ML
   VeyLHEfKcXm8chAW7FHQCmXMaCMvCDEKMz3v9LNoHd9gWS/5PuQx8vusQ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="371670223"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="371670223"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 19:59:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="585628559"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="585628559"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga003.jf.intel.com with ESMTP; 02 Nov 2022 19:59:46 -0700
Message-ID: <b1279d088165d195ee22ce02ec869f9ae33248d8.camel@linux.intel.com>
Subject: Re: [RFC 1/1] KVM: selftests: rseq_test: use vdso_getcpu() instead
 of syscall()
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, gshan@redhat.com, kvm@vger.kernel.org
Date:   Thu, 03 Nov 2022 10:59:46 +0800
In-Reply-To: <Y2MPe3qhgQG0euE0@google.com>
References: <20221102020128.3030511-1-robert.hu@linux.intel.com>
         <20221102020128.3030511-2-robert.hu@linux.intel.com>
         <Y2MPe3qhgQG0euE0@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-11-03 at 00:46 +0000, Sean Christopherson wrote:
> On Wed, Nov 02, 2022, Robert Hoo wrote:
> > vDSO getcpu() has been in Kernel since 2.6.19, which we can assume
> > generally available.
> > Use vDSO getcpu() to reduce the overhead, so that vcpu thread
> > stalls less
> > therefore can have more odds to hit the race condition.
> > 
> > Fixes: 0fcc102923de ("KVM: selftests: Use getcpu() instead of
> > sched_getcpu() in rseq_test")
> > Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> > ---
> 
> ...
> 
> > @@ -253,7 +269,7 @@ int main(int argc, char *argv[])
> >  			 * across the seq_cnt reads.
> >  			 */
> >  			smp_rmb();
> > -			sys_getcpu(&cpu);
> > +			vdso_getcpu(&cpu, NULL, NULL);
> >  			rseq_cpu = rseq_current_cpu_raw();
> >  			smp_rmb();
> >  		} while (snapshot != atomic_read(&seq_cnt));
> 
> Something seems off here.  Half of the iterations in the migration
> thread have a
> delay of 5+us, which should be more than enough time to complete a
> few getcpu()
> syscalls to stabilize the CPU.
> 
The migration thread delay time is for the whole vcpu thread loop, not
just vcpu_run(), I think.

for (i = 0; !done; i++) {
		vcpu_run(vcpu);
		TEST_ASSERT(get_ucall(vcpu, NULL) == UCALL_SYNC,
			    "Guest failed?");
...
		do {
			...
			vdso_getcpu(&cpu, NULL, NULL);
			rseq_cpu = rseq_current_cpu_raw();
			...
		} while (snapshot != atomic_read(&seq_cnt));

...
	}

> Has anyone tried to figure out why the vCPU thread is apparently
> running slow?
> E.g. is KVM_RUN itself taking a long time, is the task not getting
> scheduled in,
> etc...  I can see how using vDSO would make the vCPU more efficient,
> but I'm
> curious as to why that's a problem in the first place.

Yes, it should be the first-place problem.
But firstly, it's the whole for(){} loop taking more time than before,
that increment can be attributed to those key sub-calls, e.g.
vcpu_run(), get_ucall(), getcpu(), rseq_current_cpu_raw().

Though vcpu_run() should have first attention, reduce others' time
spending also helps.

BTW, I find that x86 get_ucall() have a more vcpu ioctl
(vcpu_regs_get()) than aarch64's, this perhaps explains a little why
the for(){} loop is heavier than aarch64.

uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
@@ -43,12 +95,14 @@
 	if (uc)
 		memset(uc, 0, sizeof(*uc));
 
-	if (run->exit_reason == KVM_EXIT_IO && run->io.port ==
UCALL_PIO_PORT) {
-		struct kvm_regs regs;
-
-		vcpu_regs_get(vcpu, &regs);
-		memcpy(&ucall, addr_gva2hva(vcpu->vm,
(vm_vaddr_t)regs.rdi),
-		       sizeof(ucall));
+	if (run->exit_reason == KVM_EXIT_MMIO &&
+	    run->mmio.phys_addr == (uint64_t)ucall_exit_mmio_addr) {
+		vm_vaddr_t gva;
+
+		TEST_ASSERT(run->mmio.is_write && run->mmio.len == 8,
+			    "Unexpected ucall exit mmio address
access");
+		memcpy(&gva, run->mmio.data, sizeof(gva));
+		memcpy(&ucall, addr_gva2hva(vcpu->vm, gva),
sizeof(ucall));

> 
> Anyways, assuming there's no underlying problem that can be solved,
> the easier
> solution is to just bump the delay in the migration thread.  As per
> its gigantic
> comment, the original bug reproduced with up to 500us delays, so
> bumping the min
> delay to e.g. 5us is acceptable.  If that doesn't guarantee the vCPU
> meets its
> quota, then something else is definitely going on.

