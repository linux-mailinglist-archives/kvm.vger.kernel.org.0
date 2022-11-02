Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB086162FB
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 13:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbiKBMqw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 08:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbiKBMqv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 08:46:51 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F85B2A409
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 05:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667393210; x=1698929210;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Jgb4YmENin1+f9m7y2kIPCA3zz5cxyo2k4jO0Ljgggo=;
  b=ftz4vk5Qu9aygW2gVtat9xHwS78QTpspqqUFCfVQKeSjSEhZPuYUIOnK
   84XZAVsMRo/FiTfXAhDjhc3Ao9mlUp0kanM0l5HR0vx04CnOCIP+3QkmN
   P5CjT9RECoy6IaXiLJI/+eo1btIFEjCjgPGwSzi647GaFa8bfaMg+0Xjl
   jgHASQcIw2qK0M5EORLR4mz/zpfPxilihQkhyOyZ0gOzSeCZgZarCgzLC
   ZABJ6R23NIYlzATuARWKO85z43Tk06Sx83sDDS5SJEEdBo4ERjIEU23KI
   AQKjwo5oWTUtc+k/tC3nA90iJlm/fr1T8WaOCTUThi/hLGQ+XRY3xkoUm
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10518"; a="292709129"
X-IronPort-AV: E=Sophos;i="5.95,234,1661842800"; 
   d="scan'208";a="292709129"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 05:46:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10518"; a="665547538"
X-IronPort-AV: E=Sophos;i="5.95,234,1661842800"; 
   d="scan'208";a="665547538"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga008.jf.intel.com with ESMTP; 02 Nov 2022 05:46:48 -0700
Message-ID: <e7b1267741039990e9c36d809b62021ca4f7076e.camel@linux.intel.com>
Subject: Re: [RFC 1/1] KVM: selftests: rseq_test: use vdso_getcpu() instead
 of syscall()
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Gavin Shan <gshan@redhat.com>, pbonzini@redhat.com,
        seanjc@google.com
Cc:     kvm@vger.kernel.org
Date:   Wed, 02 Nov 2022 20:46:47 +0800
In-Reply-To: <7371fbbd-25b0-6cb1-0a46-1f1bd194af2e@redhat.com>
References: <20221102020128.3030511-1-robert.hu@linux.intel.com>
         <20221102020128.3030511-2-robert.hu@linux.intel.com>
         <7371fbbd-25b0-6cb1-0a46-1f1bd194af2e@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-11-02 at 12:24 +0800, Gavin Shan wrote:
> Hi Robert,
> 
> On 11/2/22 10:01 AM, Robert Hoo wrote:
> > vDSO getcpu() has been in Kernel since 2.6.19, which we can assume
> > generally available.
> > Use vDSO getcpu() to reduce the overhead, so that vcpu thread
> > stalls less
> > therefore can have more odds to hit the race condition.
> > 
> 
> It would be nice to provide more context to explain how the race
> condition is caused.

OK. How about this?
... hit the race condition that vcpu_run() inside need to handle pcpu
migration triggered by sched_setaffinity() in migration thread.
> 
> > Fixes: 0fcc102923de ("KVM: selftests: Use getcpu() instead of
> > sched_getcpu() in rseq_test")
> > Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> > ---
> >   tools/testing/selftests/kvm/rseq_test.c | 32 ++++++++++++++++++
> > -------
> >   1 file changed, 24 insertions(+), 8 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/rseq_test.c
> > b/tools/testing/selftests/kvm/rseq_test.c
> > index 6f88da7e60be..0b68a6b19b31 100644
> > --- a/tools/testing/selftests/kvm/rseq_test.c
> > +++ b/tools/testing/selftests/kvm/rseq_test.c
> > @@ -42,15 +42,29 @@ static void guest_code(void)
> >   }
> >   
> >   /*
> > - * We have to perform direct system call for getcpu() because it's
> > - * not available until glic 2.29.
> > + * getcpu() was added in kernel 2.6.19. glibc support wasn't there
> > + * until glibc 2.29.
> > + * We can direct call it from vdso to ease gblic dependency.
> > + *
> > + * vdso manipulation code refers from
> > selftests/x86/test_vsyscall.c
> >    */
> > -static void sys_getcpu(unsigned *cpu)
> > -{
> > -	int r;
> > +typedef long (*getcpu_t)(unsigned *, unsigned *, void *);
> > +static getcpu_t vdso_getcpu;
> >   
> > -	r = syscall(__NR_getcpu, cpu, NULL, NULL);
> > -	TEST_ASSERT(!r, "getcpu failed, errno = %d (%s)", errno,
> > strerror(errno));
> > +static void init_vdso(void)
> > +{
> > +	void *vdso = dlopen("linux-vdso.so.1", RTLD_LAZY | RTLD_LOCAL |
> > +			    RTLD_NOLOAD);
> > +	if (!vdso)
> > +		vdso = dlopen("linux-gate.so.1", RTLD_LAZY | RTLD_LOCAL
> > |
> > +			      RTLD_NOLOAD);
> > +	if (!vdso)
> > +		TEST_ASSERT(!vdso, "failed to find vDSO\n");
> > +
> > +	vdso_getcpu = (getcpu_t)dlsym(vdso, "__vdso_getcpu");
> > +	if (!vdso_getcpu)
> > +		TEST_ASSERT(!vdso_getcpu,
> > +			    "failed to find __vdso_getcpu in vDSO\n");
> >   }
> >   
> 
> As the comments say, vdso manipulation code comes from
> selftests/x86/test_vsyscall.c.
> I would guess 'linux-vdso.so.1' and 'linux-gate.so.1' are x86
> specific. If I'm correct,
> the test case will fail on other architectures, including ARM64.
> 
Ah, right, thanks.
Fortunately ARM and x86 share same vDSO name, and we can define macros
for variations.

       user ABI   vDSO name
       ?????????????????????????????
       aarch64    linux-vdso.so.1
       arm        linux-vdso.so.1
       ia64       linux-gate.so.1
       mips       linux-vdso.so.1
       ppc/32     linux-vdso32.so.1
       ppc/64     linux-vdso64.so.1
       s390       linux-vdso32.so.1
       s390x      linux-vdso64.so.1
       sh         linux-gate.so.1
       i386       linux-gate.so.1
       x86-64     linux-vdso.so.1
       x86/x32    linux-vdso.so.1

While unfortunately, looks like ARM vDSO doesn't have getcpu(). In that
case, we might roll back to syscall(__NR_getcpu)?

aarch64 functions
       The table below lists the symbols exported by the vDSO.

       symbol                   version
       --------------------------------------
       __kernel_rt_sigreturn    LINUX_2.6.39
       __kernel_gettimeofday    LINUX_2.6.39
       __kernel_clock_gettime   LINUX_2.6.39
       __kernel_clock_getres    LINUX_2.6.39

https://man7.org/linux/man-pages/man7/vdso.7.html

> >   static int next_cpu(int cpu)
> > @@ -205,6 +219,8 @@ int main(int argc, char *argv[])
> >   	struct kvm_vcpu *vcpu;
> >   	u32 cpu, rseq_cpu;
> >   
> > +	init_vdso();
> > +
> >   	/* Tell stdout not to buffer its content */
> >   	setbuf(stdout, NULL);
> >   
> > @@ -253,7 +269,7 @@ int main(int argc, char *argv[])
> >   			 * across the seq_cnt reads.
> >   			 */
> >   			smp_rmb();
> > -			sys_getcpu(&cpu);
> > +			vdso_getcpu(&cpu, NULL, NULL);
> >   			rseq_cpu = rseq_current_cpu_raw();
> >   			smp_rmb();
> >   		} while (snapshot != atomic_read(&seq_cnt));
> > 
> 
> Thanks,
> Gavin
> 

