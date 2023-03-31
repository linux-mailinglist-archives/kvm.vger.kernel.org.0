Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 920D96D2573
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 18:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233378AbjCaQ1P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 12:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbjCaQ1B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 12:27:01 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D08C25559
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 09:22:14 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id cp21-20020a17090afb9500b0023c061f2bd0so11044004pjb.5
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 09:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680279650;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IlosCzecR6cRWajNixyjSSLIxtgYT0q2yaybSbegs4c=;
        b=W0ItSrp3r7EhJIhR0G35ykUakAMMlxE/i+z3unYA9rO+TYGdrmbX3BsaL91uWBf6Vx
         ZsFuHyPAvLOuTHfklFdRHuiTng9WIz0ZLpJuRHoxMbgwSG8acf5OmeOI7VsnLzIoZAms
         IuTW8msm7cNCeE5O6DEvgG4fAmxRINlw03s2dBy770uhZSUpqoAY1LIawZZ+yM//Xtr9
         CHDmEWgcL8ril7KSRY6dM389P/WD8DrUzbPnaKpGY3lHOV4Edd9g0fAyoXD5JWrSkDck
         T2YhuAphLuEr752WS+E6u86X7pUTG5QrV+ksxdaOhVkN45rczw0Y1iQJ6yVuVreTC7K+
         wQYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680279650;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IlosCzecR6cRWajNixyjSSLIxtgYT0q2yaybSbegs4c=;
        b=X0UTMi4RoSxR8vDTl4bVdMLoVIkS6t/WQwlj9er5rj4QqnDxMmwWvIoBN6yNGIYIFG
         oRq9kOhc8AvH/Kq8bXLawREDzfrYfZEW6BIZY5Vhqxh25diFUAEzeYuJaxhxNe8RY73E
         S/ThInVzYvU8UA/PxR7AnMSry6RfTJlYfC6f4Ais1CdgRQVt8h8TY6hZNabdyhwwuM8B
         Wf5PqAY81xj2waQxMn/8VHWkgC3flF7zefk8mTQds5pEoDT4/VmCWf1uidzgvl90YbPY
         a7F5e6AzgUVTQRUY2yRMfw/KEl29gETcHxIWEzxJ0p8+fHhobBpM105y3kRzmLaAQzmt
         pZjA==
X-Gm-Message-State: AAQBX9eSBPCuxfETwUG1tJPlYa9X58jwji84U0UcqoSV9y1MtSHD23bR
        wplJWXTNqtyOrg0+Pzy/PWI994Vgrlw=
X-Google-Smtp-Source: AKy350YdadCTrQx6xpNvwugt/5iy6s46JPCHVMhdJIDUIbGi4aSjSMzxtdg9y3ReX0vWa4CgyijbtMw0n5Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c194:b0:1a2:87a2:c927 with SMTP id
 d20-20020a170902c19400b001a287a2c927mr2780371pld.12.1680279649934; Fri, 31
 Mar 2023 09:20:49 -0700 (PDT)
Date:   Fri, 31 Mar 2023 09:20:48 -0700
In-Reply-To: <20230331135709.132713-3-minipli@grsecurity.net>
Mime-Version: 1.0
References: <20230331135709.132713-1-minipli@grsecurity.net> <20230331135709.132713-3-minipli@grsecurity.net>
Message-ID: <ZCcIYMYeDpE8nYm/@google.com>
Subject: Re: [kvm-unit-tests PATCH v2 2/4] x86/access: CR0.WP toggling write
 to r/o data test
From:   Sean Christopherson <seanjc@google.com>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 31, 2023, Mathias Krause wrote:
> We already have tests that verify a write access to an r/o page is

"supervisor write access"

> successful when CR0.WP=0, but we lack a test that explicitly verifies
> that the same access will fail after we set CR0.WP=1 without flushing

s/fail/fault to be more precise about the expected behavior.

> any associated TLB entries either explicitly (INVLPG) or implicitly
> (write to CR3). Add such a test.

Without pronouns:

    KUT has tests that verify a supervisor write access to an r/o page is
    successful when CR0.WP=0, but lacks a test that explicitly verifies that
    the same access faults after setting CR0.WP=1 without flushing any
    associated TLB entries, either explicitly (INVLPG) or implicitly (write
    to CR3). Add such a test.

> 
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> ---
>  x86/access.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 54 insertions(+), 2 deletions(-)
> 
> diff --git a/x86/access.c b/x86/access.c
> index 203353a3f74f..d1ec99b4fa73 100644
> --- a/x86/access.c
> +++ b/x86/access.c
> @@ -575,9 +575,10 @@ fault:
>  		at->expected_error &= ~PFERR_FETCH_MASK;
>  }
>  
> -static void ac_set_expected_status(ac_test_t *at)
> +static void __ac_set_expected_status(ac_test_t *at, bool flush)
>  {
> -	invlpg(at->virt);
> +	if (flush)
> +		invlpg(at->virt);
>  
>  	if (at->ptep)
>  		at->expected_pte = *at->ptep;
> @@ -599,6 +600,11 @@ static void ac_set_expected_status(ac_test_t *at)
>  	ac_emulate_access(at, at->flags);
>  }
>  
> +static void ac_set_expected_status(ac_test_t *at)
> +{
> +	__ac_set_expected_status(at, true);
> +}
> +
>  static pt_element_t ac_get_pt(ac_test_t *at, int i, pt_element_t *ptep)
>  {
>  	pt_element_t pte;
> @@ -1061,6 +1067,51 @@ err:
>  	return 0;
>  }
>  
> +static int check_write_cr0wp(ac_pt_env_t *pt_env)

How about check_toggle_cr0_wp() so that it's (hopefully) obvious that the testcase
does more than just check writes to CR0.WP?  Ah, or maybe the "write" is 

> +{
> +	ac_test_t at;
> +	int err = 0;
> +
> +	ac_test_init(&at, 0xffff923042007000ul, pt_env);
> +	at.flags = AC_PDE_PRESENT_MASK | AC_PTE_PRESENT_MASK |
> +		   AC_PDE_ACCESSED_MASK | AC_PTE_ACCESSED_MASK |
> +		   AC_ACCESS_WRITE_MASK;
> +	ac_test_setup_ptes(&at);
> +
> +	/*
> +	 * Under VMX the guest might own the CR0.WP bit, requiring KVM to
> +	 * manually keep track of its state where needed, e.g. in the guest
> +	 * page table walker.
> +	 *
> +	 * We load CR0.WP with the inverse value of what would be used during

Avoid pronouns in comments too.  If the immediate code is doing something, phrase
the comment as a command (same "rule" as changelogs), e.g.

	/*
	 * Load CR0.WP with the inverse value of what will be used during the
	 * access test, and toggle EFER.NX to coerce KVM into rebuilding the
	 * current MMU context based on the soon-to-be-stale CR0.WP.
	 */

> +	 * the access test and toggle EFER.NX to flush and rebuild the current
> +	 * MMU context based on that value.
> +	 */
> +
> +	set_cr0_wp(1);
> +	set_efer_nx(1);
> +	set_efer_nx(0);

Rather than copy+paste and end up with a superfluous for-loop, through the guts
of the test into a separate inner function, e.g.

  static int __check_toggle_cr0_wp(ac_test_t *at, bool cr0_wp_initially_set)

and then use @cr0_wp_initially_set to set/clear AC_CPU_CR0_WP_MASK.  And for the
printf(), check "at.flags & AC_CPU_CR0_WP_MASK" to determine whether the access
was expected to fault or succeed.  That should make it easy to test all the
combinations.

And then when FEP comes along, add that as a param too.  FEP is probably better
off passing the flag instead of a bool, e.g.

  static int __check_toggle_cr0_wp(ac_test_t *at, bool cr0_wp_initially_set,
				   int fep_flag)

Ah, a better approach would be to capture the flags in a global macro:

  #define TOGGLE_CR0_WP_BASE_FLAGS (base flags without CR0_WP_MASK or FEP_MASK)

and then take the "extra" flags as a param

  static int __check_toggle_cr0_wp(ac_test_t *at, int flags)

which will yield simple code in the helper

  ac->flags = TOGGLE_CR0_WP_BASE_FLAGS | flags;

and somewhat self-documenting code in the caller:

  ret = __check_toggle_cr0_wp(&at, AC_CPU_CR0_WP_MASK);

  ret = __check_toggle_cr0_wp(&at, 0);

  ret = __check_toggle_cr0_wp(&at, AC_CPU_CR0_WP_MASK | FEP_MASK);

  ...

> +
> +	if (!ac_test_do_access(&at)) {
> +		printf("%s: CR0.WP=0 r/o write fail\n", __FUNCTION__);

"fail" is ambiguous.  Did the access fault, or did the test fail?  Better would
be something like (in the inner helper):

		printf("%s: supervisor write with CR0.WP=%d did not %S as expected\n",
		       __FUNCTION__, !!(at->flags & AC_CPU_CR0_WP_MASK),
		       (at->flags & AC_CPU_CR0_WP_MASK) ? "FAULT" : "SUCCEED");
