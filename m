Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7D535D67F
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 06:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbhDMEcG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 00:32:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:5126 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229733AbhDMEcE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 00:32:04 -0400
IronPort-SDR: 0yG4cDc8GIBQvKyif1NWrGAPAOQaX9tdaDjPZRqmCVuXOvQWXDBE1aws+vxnCb8ecq+OwjAwZG
 YtKr2ObHm9Ng==
X-IronPort-AV: E=McAfee;i="6200,9189,9952"; a="191147461"
X-IronPort-AV: E=Sophos;i="5.82,218,1613462400"; 
   d="scan'208";a="191147461"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2021 21:31:43 -0700
IronPort-SDR: jN9ERtv9OjP5+3prKksrVx+kq0CKCKbWFvW/Wd3PoQU+s9DUvI6e/6yTwLhZP4mrdnmPzfWcFB
 ATB38dEzGfHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,218,1613462400"; 
   d="scan'208";a="417697196"
Received: from local-michael-cet-test.sh.intel.com (HELO localhost) ([10.239.159.166])
  by fmsmga008.fm.intel.com with ESMTP; 12 Apr 2021 21:31:40 -0700
Date:   Tue, 13 Apr 2021 12:44:00 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] [kvm-unit-tests PATCH] x86/access: Fix intermittent test
 failure
Message-ID: <20210413044400.GA23691@local-michael-cet-test.sh.intel.com>
References: <20210409075518.32065-1-weijiang.yang@intel.com>
 <1c641daa-c11d-69b6-e63b-ff7d0576c093@redhat.com>
 <YHCkIRvXAFmS/hUn@google.com>
 <20210412132551.GA20077@local-michael-cet-test.sh.intel.com>
 <YHSR4lWFupf6m9sv@google.com>
 <20210413031351.GA22945@local-michael-cet-test.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
In-Reply-To: <20210413031351.GA22945@local-michael-cet-test.sh.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Sorry, attached wrong patch in previous email, my original purpose is to flush the mapping
for the execution function.

On Tue, Apr 13, 2021 at 11:13:51AM +0800, Yang Weijiang wrote:
> On Mon, Apr 12, 2021 at 06:30:58PM +0000, Sean Christopherson wrote:
> > On Mon, Apr 12, 2021, Yang Weijiang wrote:
> > > On Fri, Apr 09, 2021 at 06:59:45PM +0000, Sean Christopherson wrote:
> > > > On Fri, Apr 09, 2021, Paolo Bonzini wrote:
> > > > > On 09/04/21 09:55, Yang Weijiang wrote:
> > > > > > During kvm-unit-test, below failure pattern is observed, this is due to testing thread
> > > > > > migration + cache "lazy" flush during test, so forcely flush the cache to avoid the issue.
> > > > > > Pin the test app to certain physical CPU can fix the issue as well. The error report is
> > > > > > misleading, pke is the victim of the issue.
> > > > > > 
> > > > > > test user cr4.pke: FAIL: error code 5 expected 4
> > > > > > Dump mapping: address: 0x123400000000
> > > > > > ------L4: 21ea007
> > > > > > ------L3: 21eb007
> > > > > > ------L2: 21ec000
> > > > > > ------L1: 2000000
> > > > > > 
> > > > > > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > > > > > ---
> > > > > >   x86/access.c | 2 ++
> > > > > >   1 file changed, 2 insertions(+)
> > > > > > 
> > > > > > diff --git a/x86/access.c b/x86/access.c
> > > > > > index 7dc9eb6..379d533 100644
> > > > > > --- a/x86/access.c
> > > > > > +++ b/x86/access.c
> > > > > > @@ -211,6 +211,8 @@ static unsigned set_cr4_smep(int smep)
> > > > > >           ptl2[2] |= PT_USER_MASK;
> > > > > >       if (!r)
> > > > > >           shadow_cr4 = cr4;
> > > > > > +
> > > > > > +    invlpg((void *)(ptl2[2] & ~PAGE_SIZE));
> > > > > >       return r;
> > > > > >   }
> > > > > > 
> > > > > 
> > > > > Applied, thanks.
> > > > 
> > > > Egad, I can't keep up with this new Paolo :-D
> > > > 
> > > > 
> > > > Would it also work to move the existing invlpg() into ac_test_do_access()?
> > > >
> > > Hi, Sean,
> > > You patch works for the app on my side, but one thing makes my confused, my patch
> > > invalidates the mapping for test code(ac_test_do_access), but your patch invlidates
> > > at->virt, they're not mapped to the same page. Why it works?
> > 
> > I don't know why your patch works.  Best guess is that INVLPG on the PMD is
> > causing the CPU to flush the entire TLB, i.e. the problematic entry is collateral
> > damage.
> Hi, Sean,
> Maybe you've figured out the root cause, just attached the patch to let you know what I did
> for comparison, toggling two different invlpg() got significant different results.
> 
> > 
> > > I simplified the test by only executing two patterns as below:
> > > 
> > > printf("\n############# start test ############\n\n");
> > > at.flags = 0x8000000;
> > > ac_test_exec(&at, &pool);
> > > at.flags = 0x200000; /* or 0x10200000 */
> > > ac_test_exec(&at, &pool);
> > > printf("############# end test ############\n\n");
> > > 
> > > with your patch I still got error code 5 while getting  error code 4 with my patch.
> > > What makes it different?
> > 
> > Now I'm really confused.  This:
> > 
> >   at.flags = 0x8000000;                                                         
> >   ac_test_exec(&at, &pool);
> > 
> > runs the test with a not-present PTE.  I don't understand how you are getting
> > error code '5' (USER + PRESENT) when running the user test; there shouldn't be
> > anything for at->virt in the TLB.
> error code '5' is (USER + PG protection violation) :-)
> 
> > 
> > Are there tests being run before this point?
> What I changed is included in the patch.
> 
> > Even then, explicitly flushing
> > at->virt should work.  The fact that set_cr4_smep() modifies a PMD and not the
> > leaf PTE should be irrelevant.  Per the SDM:
> > 
> >   INVLPG also invalidates all entries in all paging-structure caches associated
> >   with the current PCID, regardless of the linear addresses to which they correspond.
> Even PCID is not enabled in CR4? If it's the case, it cannot tell why two
> different flavor of invalidation makes different results.
> 
> Thanks for the comments!

> diff --git a/x86/access.c b/x86/access.c
> index 7dc9eb6..c7bb009 100644
> --- a/x86/access.c
> +++ b/x86/access.c
> @@ -638,6 +638,7 @@ static int ac_test_do_access(ac_test_t *at)
>      unsigned long rsp;
>      _Bool success = true;
>      int flags = at->flags;
> +    extern u64 ptl2[];
>  
>      ++unique;
>      if (!(unique & 65535)) {
> @@ -670,6 +671,8 @@ static int ac_test_do_access(ac_test_t *at)
>  	fault = 0;
>      }
>  
> +    //invlpg((void *)(ptl2[2] & ~PAGE_SIZE));
> +    invlpg(at->virt);
>      asm volatile ("mov $fixed1, %%rsi \n\t"
>  		  "mov %%rsp, %%rdx \n\t"
>  		  "cmp $0, %[user] \n\t"
> @@ -740,6 +743,8 @@ static int ac_test_do_access(ac_test_t *at)
>              printf("PASS\n");
>  	}
>      }
> +    printf("cr0 = 0x%lx, cr3 = 0x%lx, cr4 = 0x%lx\n", read_cr0(), read_cr3(), read_cr4());
> +    printf("at->flags = 0x%x, error = 0x%x, fault = 0x%x\n\n", at->flags, e, fault);
>      return success;
>  }
>  
> @@ -955,7 +960,7 @@ static int ac_test_run(void)
>  {
>      ac_test_t at;
>      ac_pool_t pool;
> -    int i, tests, successes;
> +    int tests, successes;
>  
>      printf("run\n");
>      tests = successes = 0;
> @@ -1018,7 +1023,17 @@ static int ac_test_run(void)
>  
>      ac_env_int(&pool);
>      ac_test_init(&at, (void *)(0x123400000000 + 16 * smp_id()));
> -    do {
> +//////////////////////////////////////////////////////////////
> +    printf("\n############# start test ############\n\n");
> +    at.flags = 0x8000000 - 1;
> +    ac_test_bump(&at);
> +    ac_test_exec(&at, &pool);
> +    at.flags = 0x200000 - 1;
> +    ac_test_bump(&at);
> +    ac_test_exec(&at, &pool);
> +    printf("\n############# end test ############\n\n");
> +//////////////////////////////////////////////////////////////
> +    /*do {
>  	++tests;
>  	successes += ac_test_exec(&at, &pool);
>      } while (ac_test_bump(&at));
> @@ -1026,7 +1041,7 @@ static int ac_test_run(void)
>      for (i = 0; i < ARRAY_SIZE(ac_test_cases); i++) {
>  	++tests;
>  	successes += ac_test_cases[i](&pool);
> -    }
> +    }*/
>  
>      printf("\n%d tests, %d failures\n", tests, tests - successes);
>  


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="access.patch"

diff --git a/x86/access.c b/x86/access.c
index 7dc9eb6..87985fe 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -670,6 +670,8 @@ static int ac_test_do_access(ac_test_t *at)
 	fault = 0;
     }
 
+    invlpg(ac_test_do_access);
+    //invlpg(at->virt);
     asm volatile ("mov $fixed1, %%rsi \n\t"
 		  "mov %%rsp, %%rdx \n\t"
 		  "cmp $0, %[user] \n\t"
@@ -740,6 +742,8 @@ static int ac_test_do_access(ac_test_t *at)
             printf("PASS\n");
 	}
     }
+    printf("cr0 = 0x%lx, cr3 = 0x%lx, cr4 = 0x%lx\n", read_cr0(), read_cr3(), read_cr4());
+    printf("ac_test_do_access = %p, at->flags = 0x%x, error = 0x%x, fault = 0x%x\n\n", ac_test_do_access, at->flags, e, fault);
     return success;
 }
 
@@ -955,7 +959,7 @@ static int ac_test_run(void)
 {
     ac_test_t at;
     ac_pool_t pool;
-    int i, tests, successes;
+    int tests, successes;
 
     printf("run\n");
     tests = successes = 0;
@@ -1018,7 +1022,17 @@ static int ac_test_run(void)
 
     ac_env_int(&pool);
     ac_test_init(&at, (void *)(0x123400000000 + 16 * smp_id()));
-    do {
+//////////////////////////////////////////////////////////////
+    printf("\n############# start test ############\n\n");
+    at.flags = 0x8000000 - 1;
+    ac_test_bump(&at);
+    ac_test_exec(&at, &pool);
+    at.flags = 0x200000 - 1;
+    ac_test_bump(&at);
+    ac_test_exec(&at, &pool);
+    printf("\n############# end test ############\n\n");
+//////////////////////////////////////////////////////////////
+    /*do {
 	++tests;
 	successes += ac_test_exec(&at, &pool);
     } while (ac_test_bump(&at));
@@ -1026,7 +1040,7 @@ static int ac_test_run(void)
     for (i = 0; i < ARRAY_SIZE(ac_test_cases); i++) {
 	++tests;
 	successes += ac_test_cases[i](&pool);
-    }
+    }*/
 
     printf("\n%d tests, %d failures\n", tests, tests - successes);
 

--d6Gm4EdcadzBjdND--
