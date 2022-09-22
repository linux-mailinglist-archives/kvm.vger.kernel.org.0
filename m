Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA7065E6CEF
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 22:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbiIVUUt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 16:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiIVUUr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 16:20:47 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4925105D43
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 13:20:46 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id b5so2118044pgb.6
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 13:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=PEtL6tjAFEbYRFtjp67vkzxOhEzllvdETbKw+9Ze9R0=;
        b=ir1aSAI8TTsCF88OTU4nrYSWMxKyQ+AELSor0stziM3A41GKfZAfPz+Uzg9JC7jsZP
         Lrk77DMi0RcfeC6fCCijw9qIbve0bW6fGOTVRDMH1RJYhxlcZ4ZvncPdlSW44H+oTn5o
         jTWhO19Trz45FI5i19P6y4H4YrHk1HwJXG/6VbHoMi6YGtA1kqG8FqS2DxJrLUf/LgUu
         RkTn5KCZm7oHyG1N1JgdXACjqW6ULesGf1Ytm3DDyko3bTagDekSy9U3Vhhd2VinAcU8
         fR4XdcnkzCNP+DAeYgK0tl05wMqDRMp46Yi7ruDJITJC9MC4o7wVA2nQkbtP3mJx4imI
         iZlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=PEtL6tjAFEbYRFtjp67vkzxOhEzllvdETbKw+9Ze9R0=;
        b=dtGh3804RVts0gZQgbZkO5f3T+F5xxLV9avbsfgoLb9XpNyGGJCNw23J6NrtRn59l6
         DntgEUzX1vlLt3R8djuqU2vLR9r+OxLVsm8WL6Khu5H2LXfq8PpGb4PV9067OCk7Fbpz
         Ie/xxl5WUPLuGl6pd31o4Fi4S0qJcmn+wkvngVaLeC777i9o+YbqyKMUuM3OQn+09mPw
         ZXMklOAMTi9teajPhryO5HEJ/fHcm41+shwVciwKpXtFAiuyeBisPeEZbwEtkfdBRVKc
         GgNqsZdOP9xKbZFIKMwlm8z9Py12sZzY41aC10ZX7VmBN+yFH7ql8I9zdVRChwE3KNJU
         Mr8w==
X-Gm-Message-State: ACrzQf1yfOMZKMQSfCc1+8W6hY5EKO2BS/1VEanUoqIML4ZsDMinwWID
        HuVn4GFYBfHiF1Rv+8hC2FDapw==
X-Google-Smtp-Source: AMsMyM437MyCwMVcvMLwEZGhVbqEe8gyHgLTc73/prQlCUY+5gAJJt1UK8wnFIaFkURr1k3xQd3ojw==
X-Received: by 2002:a05:6a02:186:b0:439:49a3:479b with SMTP id bj6-20020a056a02018600b0043949a3479bmr4527133pgb.171.1663878045896;
        Thu, 22 Sep 2022 13:20:45 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id s17-20020a170902ea1100b00176b5035045sm4515610plg.202.2022.09.22.13.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 13:20:45 -0700 (PDT)
Date:   Thu, 22 Sep 2022 20:20:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Vipin Sharma <vipinsh@google.com>, pbonzini@redhat.com,
        jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: selftests: Check result in hyperv_features.c
 test only for successful hypercalls
Message-ID: <YyzDmYAhWkMRt6E4@google.com>
References: <20220922062451.2927010-1-vipinsh@google.com>
 <87fsgjol20.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fsgjol20.fsf@redhat.com>
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

Tweaked the shortlog to make it a wee bit shorter:

  KVM: selftests: Check result in hyperv_features for successful hypercalls

On Thu, Sep 22, 2022, Vitaly Kuznetsov wrote:
> Vipin Sharma <vipinsh@google.com> writes:
> 
> > Commit cc5851c6be86 ("KVM: selftests: Use exception fixup for #UD/#GP
> > Hyper-V MSR/hcall tests") introduced a wrong guest assert in guest_hcall().
> > It is not checking the successful hypercall results and only checks the result

Wrap changelogs at ~75 chars.  It's ok to go over for things like stack traces
and Fixes:, where the format of the text is more important than the line length.
But for "just words", stay under 75 chars.

> > when a fault happens.
> >
> >   GUEST_ASSERT_2(!hcall->ud_expected || res == hcall->expect,
> >                  hcall->expect, res);
> >
> > Correct the assertion by only checking results of the successful
> > hypercalls.
> >
> > This issue was observed when this test started failing after building it
> > in Clang. Above guest assert statement fails because "res" is not equal
> > to "hcall->expect" when "hcall->ud_expected" is true. "res" gets some
> > garbage value in Clang from the RAX register. In GCC, RAX is 0 because
> > it using RAX for @output_address in the asm statement and resetting it
> > to 0 before using it as output operand in the same asm statement. Clang
> > is not using RAX for @output_address.
> >
> > Load RAX with some default input value so that the compiler cannot
> > modify it or use it for anything else. This makes sure that KVM is

Try to avoid pronouns as they are often ambiguous, and even when they're not, using
pronouns can sometimes require more effort from the readers, e.g. might require the
reader to "jump back" in the sentence to understand what "it" means.

And for cases like this, RAX is one more char, so just type RAX.

> > correctly clearing up return value on successful hypercall and compiler cannot
> > generate any false positive.
> >
> > Fixes: cc5851c6be86 ("KVM: selftests: Use exception fixup for #UD/#GP Hyper-V MSR/hcall tests")
> > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Reviewed-by: Jim Mattson <jmattson@google.com>
> >
> > ---
> >
> > Jim's Reviewed-by is only for the code change and not shortlog message
> > of v1.

This is "working as intended".  When someone gives a conditional Reviewed-by,
the intent is very much that _if_ you make the requested changes in good faith,
then their review will be carried.  In other words, not adding Jim's review
would be "wrong" from a certain perspective.

> > Also, there is one change in asm which was not present in v1 and
> > not reviewed by Jim. But I am writing his name here so that it is not missed
> > when patch is merged.

Heh, the fact that you felt compelled to write this is a very, very good indication
that this should be two patches.

The bug Vitaly encountered is exactly why it's pre

> Could you please include the attached patch to your series? Thanks a bunch!

Pushed both (as three patches) to branch `for_paolo/6.1` at:

    https://github.com/sean-jc/linux.git

> For your patch:
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

...

> Subject: [PATCH] KVM: selftests: Do not set reserved control bits when testing
>  invalid Hyper-V hypercall number

I shortened this one too, 94 chars is a bit much :-)

  KVM: selftests: Don't set reserved bits for invalid Hyper-V hypercall number
