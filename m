Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D42595915D3
	for <lists+kvm@lfdr.de>; Fri, 12 Aug 2022 21:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237487AbiHLTQ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Aug 2022 15:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234282AbiHLTQ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Aug 2022 15:16:57 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B69DB07DE
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 12:16:55 -0700 (PDT)
Date:   Fri, 12 Aug 2022 19:16:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660331813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u9T37ubNhR2TCSRYgtaWsmjiFc/iBpV1Xk8mdFp/x2k=;
        b=Qyu0jfpvO9hOSSI7GmlzoOIhxn4x9OBNPkscyV2ZCZgRnyX+LoAZR3Vsu2lHb6llhDqyf3
        ACOf8qncxKmdG9BUxEwSkryWXO+vf8ZKPAcvSWdX6R/oiwDxWtmfnpRLOXPGlZZGh1Nl91
        0UsK469ewuJCGa5mwTPdCpOskyscP30=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH] KVM: selftests: Use TEST_REQUIRE() in nx_huge_pages_test
Message-ID: <YvanIQoL3Y3TlxPB@google.com>
References: <20220812175301.3915004-1-oliver.upton@linux.dev>
 <YvaWKUs+/gLPjOOT@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvaWKUs+/gLPjOOT@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 12, 2022 at 11:04:25AM -0700, David Matlack wrote:
> On Fri, Aug 12, 2022 at 05:53:01PM +0000, Oliver Upton wrote:
> > Avoid boilerplate for checking test preconditions by using
> > TEST_REQUIRE(). While at it, add a precondition for
> > KVM_CAP_VM_DISABLE_NX_HUGE_PAGES to skip (instead of silently pass) on
> > older kernels.
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  .../selftests/kvm/x86_64/nx_huge_pages_test.c | 24 +++++--------------
> >  1 file changed, 6 insertions(+), 18 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> > index cc6421716400..e19933ea34ca 100644
> > --- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> > +++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> > @@ -118,13 +118,6 @@ void run_test(int reclaim_period_ms, bool disable_nx_huge_pages,
> >  	vm = vm_create(1);
> >  
> >  	if (disable_nx_huge_pages) {
> > -		/*
> > -		 * Cannot run the test without NX huge pages if the kernel
> > -		 * does not support it.
> > -		 */
> > -		if (!kvm_check_cap(KVM_CAP_VM_DISABLE_NX_HUGE_PAGES))
> > -			return;
> > -
> >  		r = __vm_disable_nx_huge_pages(vm);
> >  		if (reboot_permissions) {
> >  			TEST_ASSERT(!r, "Disabling NX huge pages should succeed if process has reboot permissions");
> > @@ -248,18 +241,13 @@ int main(int argc, char **argv)
> >  		}
> >  	}
> >  
> > -	if (token != MAGIC_TOKEN) {
> > -		print_skip("This test must be run with the magic token %d.\n"
> > -			   "This is done by nx_huge_pages_test.sh, which\n"
> > -			   "also handles environment setup for the test.",
> > -			   MAGIC_TOKEN);
> > -		exit(KSFT_SKIP);
> > -	}
> > +	TEST_REQUIRE(kvm_has_cap(KVM_CAP_VM_DISABLE_NX_HUGE_PAGES));
> 
> This cap is only needed for run_test(..., true, ...) below so I don't think we should require it for the entire test.

It has always seemed that the test preconditions are a way to pretty-print
a failure/skip instead of having some random ioctl fail deeper in the
test.

If we really see value in adding predicates for individual test cases
then IMO it deserves first-class support in our framework. Otherwise
the next test that comes along is bound to open-code the same thing.

Can't folks just update their kernel? :-)

--
Thanks,
Oliver

> That being said, it still might be good to inform the user that the test is being skipped. So perhaps something like this:
> 
>   ...
>   run_test(reclaim_period_ms, false, reboot_permissions);
> 
>   if (kvm_has_cap(KVM_CAP_VM_DISABLE_NX_HUGE_PAGES))
>           run_test(reclaim_period_ms, true, reboot_permissions);
>   else
>           print_skip("KVM_CAP_VM_DISABLE_NX_HUGE_PAGES not supported");
>   ...
> 
> > +	TEST_REQUIRE(reclaim_period_ms > 0);
> >  
> > -	if (!reclaim_period_ms) {
> > -		print_skip("The NX reclaim period must be specified and non-zero");
> > -		exit(KSFT_SKIP);
> > -	}
> > +	__TEST_REQUIRE(token == MAGIC_TOKEN,
> > +		       "This test must be run with the magic token %d.\n"
> > +		       "This is done by nx_huge_pages_test.sh, which\n"
> > +		       "also handles environment setup for the test.");
> >  
> >  	run_test(reclaim_period_ms, false, reboot_permissions);
> >  	run_test(reclaim_period_ms, true, reboot_permissions);
> > 
> > base-commit: 93472b79715378a2386598d6632c654a2223267b
> > -- 
> > 2.37.1.595.g718a3a8f04-goog
> > 
