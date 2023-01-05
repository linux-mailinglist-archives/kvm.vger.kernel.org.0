Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55F2165F6FC
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 23:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236078AbjAEWqh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 17:46:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232346AbjAEWqf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 17:46:35 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 794681C439
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 14:46:34 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id h16so37493853wrz.12
        for <kvm@vger.kernel.org>; Thu, 05 Jan 2023 14:46:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/CMOVEXmdwc6z1I+uN+eHcW8GJeuG+2AejyUNyWzYcA=;
        b=OMtvLgzkK3DXDd8d9GeGNbcJ240SHa5PtbM/WGJxqbA0tGp53aefTNrIC+/0ilvnc8
         rPalAfAoV8SU7yCvMi8UG6/4GxQDTxwFigfv/gEAEk66GYdW/oTANiqBDhP14Ge//aNL
         bvJ+qdnz1dLavn0Fb9yF7SG1u53vsV8ugfnzyG7pTpokq1lP3Shhs0Jclp6rXFeB3y6c
         uvCqmXw92yqseBceushL2xqCYyqFREly4iPkEjxEE6EZLFoge9pClk0V4Sb82ZdjO/qU
         NIH07hR5di5fX7p37JaUj+7S1suusSJiv5MFAkFH0DoZ0dUxD+KNDz6Ffjyhy0JTFn9p
         9PPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/CMOVEXmdwc6z1I+uN+eHcW8GJeuG+2AejyUNyWzYcA=;
        b=zKyeSdyDISGp199lnpv37WxF8/TfC2c7cF+PL9w3sQXqPiS/OqwpR6RN2pCizHWEXj
         VGdADnnvJyZAF5N36nBjphw/hgQ9YFPVq5j7M2gAEHf0hsvrK9jp8VFXnLPXhTKTqnVr
         RzQvlar+/7GSCu4akL4sp/5/qpc/1Mf9JT5VlSa6paO/GsZjMbHZG/T+1GpjcOw+OE+X
         8eWS1oSY1iD+otiyNs0TtMlUdkyqfW5TwfmSqvUCLJAzE+TTTrGZTJKadW3Izt8GJGgM
         uaL7LgXgQVXg9u5O/5NpqlPz/VMVxAk3i5luGt0KX7XvWLdFhwKP93YhxcuJ9+NIEkjS
         Unww==
X-Gm-Message-State: AFqh2kqyRFjgraNN8iWbPmHPdx29JFnCNWXfw124SL5jMkd+FVpP28t9
        oNds2gOkaLL/qrBNN51Kxy4TeBRJDdxRtXA47zo6zg==
X-Google-Smtp-Source: AMrXdXsWYqo4L+YEWDkjmq7vxb7F1kojO1RdKPEAhLTVsivIuHv8gUty77dT6KMpADBDEhPJQGebvTNfT0Wmrj3CIjQ=
X-Received: by 2002:a5d:5343:0:b0:242:4cc5:dc6a with SMTP id
 t3-20020a5d5343000000b002424cc5dc6amr1086973wrv.206.1672958792862; Thu, 05
 Jan 2023 14:46:32 -0800 (PST)
MIME-Version: 1.0
References: <20221230162442.3781098-1-aaronlewis@google.com>
 <20221230162442.3781098-7-aaronlewis@google.com> <Y7Wzx5qW1zMQJq88@google.com>
In-Reply-To: <Y7Wzx5qW1zMQJq88@google.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Thu, 5 Jan 2023 22:46:21 +0000
Message-ID: <CAAAPnDET+z6CY7_SKe5qx-r5Br7e4MP+TvGq5Km4btYd27Li3Q@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] KVM: selftests: Add XCR0 Test
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Content-Type: text/plain; charset="UTF-8"
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

On Wed, Jan 4, 2023 at 5:13 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Dec 30, 2022, Aaron Lewis wrote:
> > +static uint64_t get_supported_user_xfeatures(void)
>
> I would rather put this in processor.h too, with a "this_cpu" prefix.  Maybe
> this_cpu_supported_xcr0() or this_cpu_supported_user_xfeatures()?

this_cpu_supported_xcr0 works for me.

>
> > +{
> > +     uint32_t a, b, c, d;
> > +
> > +     cpuid(0xd, &a, &b, &c, &d);
> > +
> > +     return a | ((uint64_t)d << 32);
> > +}
> > +
> > +static void guest_code(void)
> > +{
> > +     uint64_t xcr0_rest;
>
> s/rest/reset ?
>
> > +     uint64_t supported_xcr0;
> > +     uint64_t xfeature_mask;
> > +     uint64_t supported_state;
> > +
> > +     set_cr4(get_cr4() | X86_CR4_OSXSAVE);
> > +
> > +     xcr0_rest = xgetbv(0);
> > +     supported_xcr0 = get_supported_user_xfeatures();
> > +
> > +     GUEST_ASSERT(xcr0_rest == 1ul);
>
> XFEATURE_MASK_FP instead of 1ul.
>
> > +
> > +     /* Check AVX */
> > +     xfeature_mask = XFEATURE_MASK_SSE | XFEATURE_MASK_YMM;
> > +     supported_state = supported_xcr0 & xfeature_mask;
> > +     GUEST_ASSERT(supported_state != XFEATURE_MASK_YMM);
>
> Oof, this took me far too long to read correctly.  What about?
>
>         /* AVX can be supported if and only if SSE is supported. */
>         GUEST_ASSERT((supported_xcr0 & XFEATURE_MASK_SSE) ||
>                      !(supported_xcr0 & XFEATURE_MASK_YMM));
>
> Hmm or maybe add helpers?  Printing the info on failure would also make it easier
> to debug.  E.g.
>
> static void check_all_or_none_xfeature(uint64_t supported_xcr0, uint64_t mask)
> {
>         supported_xcr0 &= mask;
>
>         GUEST_ASSERT_2(!supported_xcr0 || supported_xcr0 == mask,
>                        supported_xcr0, mask);
> }
>
> static void check_xfeature_dependencies(uint64_t supported_xcr0, uint64_t mask,
>                                         uint64_t dependencies)
> {
>         supported_xcr0 &= (mask | dependencies);
>
>         GUEST_ASSERT_3(!(supported_xcr0 & mask) ||
>                        supported_xcr0 == (mask | dependencies),
>                        supported_xcr0, mask, dependencies);
> }
>
> would yield
>
>         check_xfeature_dependencies(supported_xcr0, XFEATURE_MASK_YMM,
>                                     XFEATURE_MASK_SSE);
>
> and then for AVX512:
>
>         check_xfeature_dependencies(supported_xcr0, XFEATURE_MASK_AVX512,
>                                     XFEATURE_MASK_SSE | XFEATURE_MASK_YMM);
>         check_all_or_none_xfeature(supported_xcr0, XFEATURE_MASK_AVX512);
>
> That would more or less eliminate the need for comments, and IMO makes it more
> obvious what is being checked.

The reason I chose not to use helpers here was it hides the line
number the assert occured on.  With helpers you have multiple places
the problem came from and one place it's asserting.  The way I wrote
it the line number in the assert tells you exactly where the problem
occured.

I get you can deduce the line number with the values passed back in
the assert, but the assert information printed out on the host has to
be purposefully vague because you get one fmt for the entire test.  If
I was able to do a printf style asserts from the guest, that would
allow me to provide more, clear context to tie it back.  Having the
line number where the assert fired I felt was useful to keep.

I guess one way to get the best of both worlds would be to have the
helpers return a bool rather than assert in the helper.  I could also
include the additional info you suggested in the asserts.

That said, if we do end up going with helpers I don't think we have to
call them both like in the AVX512 example.  They both check the same
thing, except check_xfeature_dependencies() additionally allows for
dependencies to be used.  E.g.

if you call:
check_xfeature_dependencies(supported_xcr0, XFEATURE_MASK_AVX512, 0)

it's the same as calling:
check_all_or_none_xfeature(supported_xcr0, XFEATURE_MASK_AVX512)

Maybe we should call them: check_xfeature() and
check_xfeature_dependencies(), or with_dependencies... something to
show they are related to each other.

>
> > +     xsetbv(0, supported_xcr0);
> > +
> > +     GUEST_DONE();
> > +}
> > +
> > +static void guest_gp_handler(struct ex_regs *regs)
> > +{
> > +     GUEST_ASSERT(!"Failed to set the supported xfeature bits in XCR0.");
>
> I'd rather add an xsetbv_safe() variant than install a #GP handler.  That would
> also make it super easy to add negative testing.  E.g. (completely untested)
>
> static inline uint8_t xsetbv_safe(uint32_t index, uint64_t value)
> {
>         u32 eax = value;
>         u32 edx = value >> 32;
>
>         return kvm_asm_safe("xsetbv", "a" (eax), "d" (edx), "c" (index));
> }
>
> and
>         vector = xsetbv_safe(0, supported_xcr0);
>         GUEST_ASSERT_2(!vector, supported_xcr0, vector);
>
> and rudimentary negative testing
>
>         for (i = 0; i < 64; i++) {
>                 if (supported_xcr0 & BIT_ULL(i))
>                         continue;
>
>                 vector = xsetbv_safe(0, supported_xcr0 | BIT_ULL(i));
>                 GUEST_ASSERT_2(vector == GP_VECTOR, supported_xcr0, vector);
>         }

I like the idea of this additional test.  I'll add it.
