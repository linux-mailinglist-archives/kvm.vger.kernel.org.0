Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACEA665C611
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 19:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238775AbjACSYi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 13:24:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238766AbjACSYd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 13:24:33 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 572AE13D34
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 10:24:32 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id n65-20020a17090a2cc700b0021bc5ef7a14so32004731pjd.0
        for <kvm@vger.kernel.org>; Tue, 03 Jan 2023 10:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rk3/IZ0Tali2mWQU+drpOkqSz37XQmDfj78i0CHemRY=;
        b=FlkKNfLDlAP8KDjh3L3g/64PFtn919TQ/dEwCVWbZTQmB8k3I7+2px0b5z6KR9ENoL
         OEJ9qsPSyZ/YWDVJryD89jmPqXv4VxvCdJLbXdr0ssZN6wcOeq7zgP3iXDxz+z5lQF7S
         ymVNtowkcqEYDRvEa1sVqV1pt/kDo2BC1UZpsggapdy/MbVKwBLcDNkucMr1bJAEpRWC
         YI4MVmVPoYzrtNgqMgvQ7Jbgc/Z16Lw+w8GyBaVdNMU2mWDRZB8zRwzCIX4eu1TMABm3
         1+AB2OjbUnzbT7JZwnN7bJap0kMnRNpzOWkoJNH7vEqY4/wuEOAmJ1Ow52t73N+sNShO
         BDAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rk3/IZ0Tali2mWQU+drpOkqSz37XQmDfj78i0CHemRY=;
        b=zuASv+YO1WhqY4K/dzkZzWwsl9dDuc4dpcvvyEgTpb3G5rrknGoat+c+IRmhcmkue9
         1VBW7R1JSBIQBmGEaAVH0vpGwY4nRA8a6/E8v8jCiP1TbahJLkFZy0egpYmj4MUHfooZ
         8FQT5ijTODUXx/oYE4E2SB1lHY8du0ubGTzXE3nV9FNG4jGdYyJqrFmOF9H/wJ6sXqJh
         pn4KqVYKcSFrhU4+MpupQh6baNWQ9++v8hHtIERtrVMe3wAwJJNWF5CeXoNQfZdI2OFw
         D10PXCZK+Fmz6WSZ226dyn9w0trvKOtoKF8FrOARpqGAyyraCcIKFaon2U5cnjmPpcH7
         al/Q==
X-Gm-Message-State: AFqh2koDvvN3G6cWzFfN7RpRLJGSocasts4f9gdED2KRzBtR9gU1UXfi
        Fv8D1ZwPR9o+2VaucxRmhk66RlN8S7xmaPYY
X-Google-Smtp-Source: AMrXdXtt6NTSkuKb0mgaJaN0bgvqUqV6cEjq67Vt81B0EL3xPwhmHnOY3MX9tl5Z/bMZoJUhr9GuTg==
X-Received: by 2002:a17:902:9049:b0:189:6d32:afeb with SMTP id w9-20020a170902904900b001896d32afebmr4242465plz.1.1672770271759;
        Tue, 03 Jan 2023 10:24:31 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id k11-20020a170902c40b00b001926a76e8absm19693858plk.114.2023.01.03.10.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 10:24:31 -0800 (PST)
Date:   Tue, 3 Jan 2023 18:24:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH v2 1/2] KVM: selftests: Assert that XSAVE supports XTILE
 in amx_test
Message-ID: <Y7Ry24zfi1/ZOnf8@google.com>
References: <20221230013648.2850519-1-aaronlewis@google.com>
 <20221230013648.2850519-2-aaronlewis@google.com>
 <Y7RwZg9XGIJREcph@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7RwZg9XGIJREcph@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 03, 2023, Sean Christopherson wrote:
> On Fri, Dec 30, 2022, Aaron Lewis wrote:
> > The check in amx_test that ensures that XSAVE supports XTILE, doesn't
> > actually check anything.  It simply returns a bool which the test does
> > nothing with.
> > 
> > Assert that XSAVE supports XTILE.
> > 
> > Fixes: 5dc19f1c7dd3 ("KVM: selftests: Convert AMX test to use X86_PROPRETY_XXX")
> 
> Doh.
> 
> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > ---
> >  tools/testing/selftests/kvm/x86_64/amx_test.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
> > index bd72c6eb3b670..2f555f5c93e99 100644
> > --- a/tools/testing/selftests/kvm/x86_64/amx_test.c
> > +++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
> > @@ -119,9 +119,9 @@ static inline void check_cpuid_xsave(void)
> >  	GUEST_ASSERT(this_cpu_has(X86_FEATURE_OSXSAVE));
> >  }
> >  
> > -static bool check_xsave_supports_xtile(void)
> > +static inline void check_xsave_supports_xtile(void)
> 
> Don't explicitly tag local static functions as inline (ignore the existing code
> that sets a bad precedent), modern compilers don't need the hint to generate
> optimal code,
> 
> >  {
> > -	return __xgetbv(0) & XFEATURE_MASK_XTILE;
> > +	GUEST_ASSERT(__xgetbv(0) & XFEATURE_MASK_XTILE);
> 
> Any objection to moving the assertion into check_xtile_info() and dropping this
> one-line helper?

Actually, this code is silly, and arguably unnecessary. init_regs() explicitly
sets XCR0 to XFEATURE_MASK_XTILE.  If something goes awry, XSETBV should #GP.
If we want to be really paranoid and assert that KVM didn't silently fail XSETBV,
then the more logical place for the assertion is immediately after the XSETBV.

i.e.

  static void init_regs(void)
  {
	uint64_t cr4, xcr0;

	/* turn on CR4.OSXSAVE */
	cr4 = get_cr4();
	cr4 |= X86_CR4_OSXSAVE;
	set_cr4(cr4);

	xcr0 = __xgetbv(0);
	xcr0 |= XFEATURE_MASK_XTILE;
	__xsetbv(0x0, xcr0);

	GUEST_ASSERT((__xgetbv(0) & XFEATURE_MASK_XTILE) == XFEATURE_MASK_XTILE);
  }
