Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE2F65F77E
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 00:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236349AbjAEXKM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 18:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236293AbjAEXKK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 18:10:10 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D9961459
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 15:10:09 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id c6so7721805pls.4
        for <kvm@vger.kernel.org>; Thu, 05 Jan 2023 15:10:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I00PfRXFv6U8Xy8h8VZKYoXSKEt5A1u/WyccCLlv9P0=;
        b=ZIjg2TcD4Ck+PWR1k1iRhRf+mPTzPqnJzVHfYMsjPVZhazJGf1x8Q97OC/lRmpCDC7
         UypuKLBYEPZRhzcmHcZv16BkjrveWpXAMZH1BQwgdO7B7z763aYHaS+1Vjx4FDwo2saM
         W0kED+WL/+W8kw93Ux6tbPmxWJfWvxWPjX4Xq/VyaW1WMTzh7mqAlYcddksivDoLuRot
         fxRu70O7bPUakIlgdy9K+FgeldVV4dN6nJZTMbroij+0q8BJJvLdEgcE4WUiMY0R59CU
         MY/OJ1C0gFuSUMh6A2MPKul+rlOC1f9nz+4A0+1hFqI/J5RcMFEC5IYr1yrsyCxhI08F
         mmvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I00PfRXFv6U8Xy8h8VZKYoXSKEt5A1u/WyccCLlv9P0=;
        b=OQLxfDyPsmQKMCl62gH/rvONWXuuDvEYyRAW067bEU0mfwejdExLRGLeql4JsBK7uT
         WaEMDhQBfpb0o88t7+Eb3Fck7iOKy5nXvbr9VpBnffqkgxdGpn4QjDnysZvnYlluIRMO
         dfMNK2Ow4ujPU1r68qfGXsk9qHM3QoSFZJsJFBgrPyOA+pGF7KhgIZkbE6iPgvX3spL3
         XjntzeKPMQJKDRoU788hjlA2vdjMkytGwkMRJf45ENm9qSULHKBVeY0S0/5ClIQyv1bz
         VFbrR5rZ3jQWWB+cMioh0MKW5w56/kb9ggWj2MxlixHEHeRwTn4iRTH7WWH8LlKTcQKI
         xhZA==
X-Gm-Message-State: AFqh2kr7KhLZA3UBnY30gaS0SMGLJE3P1I0UQMn3OLBBSokYZ892gDlK
        gf9Xyirp+qe2lEHCyBnscqK3kA==
X-Google-Smtp-Source: AMrXdXs84ctSy+th0zPGM+NNs0yvI53hNLR0begg630kNt7sC5UPeWcZ2dHCnyN94kYPvp8vPEWV9g==
X-Received: by 2002:a05:6a20:a699:b0:b3:66b7:24ff with SMTP id ba25-20020a056a20a69900b000b366b724ffmr41250pzb.1.1672960208498;
        Thu, 05 Jan 2023 15:10:08 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id k12-20020a6568cc000000b004788780dd8esm22390112pgt.63.2023.01.05.15.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 15:10:07 -0800 (PST)
Date:   Thu, 5 Jan 2023 23:10:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH v2 6/6] KVM: selftests: Add XCR0 Test
Message-ID: <Y7dYzEjZcj/NVmHA@google.com>
References: <20221230162442.3781098-1-aaronlewis@google.com>
 <20221230162442.3781098-7-aaronlewis@google.com>
 <Y7Wzx5qW1zMQJq88@google.com>
 <CAAAPnDET+z6CY7_SKe5qx-r5Br7e4MP+TvGq5Km4btYd27Li3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAAPnDET+z6CY7_SKe5qx-r5Br7e4MP+TvGq5Km4btYd27Li3Q@mail.gmail.com>
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

On Thu, Jan 05, 2023, Aaron Lewis wrote:
> On Wed, Jan 4, 2023 at 5:13 PM Sean Christopherson <seanjc@google.com> wrote:
> > Hmm or maybe add helpers?  Printing the info on failure would also make it easier
> > to debug.  E.g.
> >
> > static void check_all_or_none_xfeature(uint64_t supported_xcr0, uint64_t mask)
> > {
> >         supported_xcr0 &= mask;
> >
> >         GUEST_ASSERT_2(!supported_xcr0 || supported_xcr0 == mask,
> >                        supported_xcr0, mask);
> > }
> >
> > static void check_xfeature_dependencies(uint64_t supported_xcr0, uint64_t mask,
> >                                         uint64_t dependencies)
> > {
> >         supported_xcr0 &= (mask | dependencies);
> >
> >         GUEST_ASSERT_3(!(supported_xcr0 & mask) ||
> >                        supported_xcr0 == (mask | dependencies),
> >                        supported_xcr0, mask, dependencies);
> > }
> >
> > would yield
> >
> >         check_xfeature_dependencies(supported_xcr0, XFEATURE_MASK_YMM,
> >                                     XFEATURE_MASK_SSE);
> >
> > and then for AVX512:
> >
> >         check_xfeature_dependencies(supported_xcr0, XFEATURE_MASK_AVX512,
> >                                     XFEATURE_MASK_SSE | XFEATURE_MASK_YMM);
> >         check_all_or_none_xfeature(supported_xcr0, XFEATURE_MASK_AVX512);
> >
> > That would more or less eliminate the need for comments, and IMO makes it more
> > obvious what is being checked.
> 
> The reason I chose not to use helpers here was it hides the line
> number the assert occured on.  With helpers you have multiple places
> the problem came from and one place it's asserting.  The way I wrote
> it the line number in the assert tells you exactly where the problem
> occured.
> 
> I get you can deduce the line number with the values passed back in
> the assert,

But the line number ultimately doesn't matter, no?  In the original code, the
line number lets you know what feature bits failed, but in the proposed helpers
above, that's explicitly provided.

> but the assert information printed out on the host has to
> be purposefully vague because you get one fmt for the entire test

Right, but the line number of the helper disambiguates the data.  E.g. knowing
that the assert in check_xfeature_dependencies() fired lets the reader know what
the args mean.

> If I was able to do a printf style asserts from the guest, that would allow
> me to provide more, clear context to tie it back.

Yeah, we need to figure out a solution for that sooner than later.

> Having the line number where the assert fired I felt was useful to keep.
> 
> I guess one way to get the best of both worlds would be to have the
> helpers return a bool rather than assert in the helper.  I could also
> include the additional info you suggested in the asserts.

That seems like it will end up with hard to read code, and a lot of copy+paste.
E.g.

	GUEST_ASSERT_3(is_valid_xfeature(supported_xcr0, XFEATURE_MASK_AVX512,
					 XFEATURE_MASK_SSE | XFEATURE_MASK_YMM),
		       supported_xcr0, XFEATURE_MASK_AVX512,
		       XFEATURE_MASK_SSE | XFEATURE_MASK_YMM);

isn't the friendliest.

What about using macros?  It's a little gory, but I don't think it'll be a
maintenance issue, and the code is quite small.  And on the plus side, it's more
obvious that the "caller" is making an assertion.

#define ASSERT_ALL_OR_NONE_XFEATURE(supported_xcr0, mask)	\
do {								\
	uint64_t __supported = supported_xcr0 & (mask);		\
								\
	GUEST_ASSERT_2(!supported || supported == (mask),	\
		       supported, (mask));			\
while (0)

> That said, if we do end up going with helpers I don't think we have to
> call them both like in the AVX512 example.  They both check the same
> thing, except check_xfeature_dependencies() additionally allows for
> dependencies to be used.

My thought was to intentionally separate the checks by their semantics, even though
it means more checks.  Asserting that the dependencies are in place is backed by
architectural rules, whereas asserting the "all or nothing" stuff is KVM's own
software-defined rules.
