Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 821E24BA30B
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 15:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241109AbiBQOen (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 09:34:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234277AbiBQOen (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 09:34:43 -0500
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB8FB0D3B
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 06:34:28 -0800 (PST)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-2d68d519a33so32604307b3.7
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 06:34:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=49LFxUiFxKOUzkWf8fuZxLiIVO2LF4tYGtZO7DQutPk=;
        b=NwjX1tSy/LF3MUmU7BQKrfxOiVZsUdVkytN8GInhnipKZrLmADEmMvvj8SkSfqGUwW
         bJZ2UHD7aBqqMN4XTKUs3DR9KNSeuRXTt93+e6TD7dFXLNSdHbXT948n/DrYFZA1Jhuc
         CUAohx/NkmoyLga0JgphN1tR083q5Ty2irsDGzs/v3SNSn2EYdSEQbTYEYl+R8gU+Y9h
         y+qOg/VUQFrr5VIBAFUV6NIay2pprrFL+irdP70ot3+0At0p1LHjP1ccfGyQ7BXNUt5i
         YE8lH65+Sm5FQLxHFp0bUTYS94jjc7mab8GiC0RY1RtWn+oNTagKNee/KX07b+FmMWGu
         Rx/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=49LFxUiFxKOUzkWf8fuZxLiIVO2LF4tYGtZO7DQutPk=;
        b=LjQgxjR4dr1dyh0wnYj0Kcf6eWi95pe9iZxHUhn0hGpIPfFFTyKwuOo2pmVeM1QHjL
         opAHtdQYTTAn0JsLa0gezhXH389C5rbxXwi0cevMayJtGo2l889AcUvzj8TM4apb0A1L
         BMbwZS4GK3kY/gdlYr80q/5Ezh3T87DZhwrh0SVqcl67xEfcbi/Ssc7t8dDxxMZHm1KE
         DysgB5lxIkLHl5NOYL5z2uiyYfXeZx4cZWb9vvBQ2Ztps6mk5CgHReau82C8L5Rip/L2
         dSBkJIYxfO2yyFHiuHyicYHYGFzkAhFsWW6phMre4zd7CWDrB+esIsSUK0zVN0zXww+X
         TNfA==
X-Gm-Message-State: AOAM533RVMskxTLhHHMiqbwZL9Y/XfgDwX9TT35Az4szWvVSf5FwWPCl
        B1k9/Em6cHDZcN2wTnKLvqcz8P1AUJiCfnWJQNWMqOMS+gd6/A==
X-Google-Smtp-Source: ABdhPJyIkRYAlxtDSkXAXM9gsY6QUry1r5Zdx2nb46GQMqcX2XtlFC/PJ80AjWP1ADrQ4/8HHffwiTcNe52wpyvTR2Q=
X-Received: by 2002:a81:4fc3:0:b0:2d0:e6ca:b3ac with SMTP id
 d186-20020a814fc3000000b002d0e6cab3acmr2845757ywb.222.1645108467176; Thu, 17
 Feb 2022 06:34:27 -0800 (PST)
MIME-Version: 1.0
References: <20220207051202.577951-1-manali.shukla@amd.com>
 <20220207051202.577951-2-manali.shukla@amd.com> <YgqtwRwYbJD5f9nA@google.com> <e9eba920-9522-6a56-4293-b60c0f1b77ed@amd.com>
In-Reply-To: <e9eba920-9522-6a56-4293-b60c0f1b77ed@amd.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Thu, 17 Feb 2022 14:34:16 +0000
Message-ID: <CAAAPnDH2LXkYkHpV+JTEmEF8PAGRP+wq7hR2nJpt53rO7bb-NA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 1/3] x86: Add routines to set/clear
 PT_USER_MASK for all pages
To:     "Shukla, Manali" <mashukla@amd.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Manali Shukla <manali.shukla@amd.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 17, 2022 at 3:55 AM Shukla, Manali <mashukla@amd.com> wrote:
>
>
>
> On 2/15/2022 1:00 AM, Sean Christopherson wrote:
> > On Mon, Feb 07, 2022, Manali Shukla wrote:
> >> Add following 2 routines :
> >> 1) set_user_mask_all() - set PT_USER_MASK for all the levels of page tables
> >> 2) clear_user_mask_all - clear PT_USER_MASK for all the levels of page tables
> >>
> >> commit 916635a813e975600335c6c47250881b7a328971
> >> (nSVM: Add test for NPT reserved bit and #NPF error code behavior)
> >> clears PT_USER_MASK for all svm testcases. Any tests that requires
> >> usermode access will fail after this commit.
> >
> > Gah, I took the easy route and it burned us.  I would rather we start breaking up
> > the nSVM and nVMX monoliths, e.g. add a separate NPT test and clear the USER flag
> > only in that test, not the "common" nSVM test.
>
> Yeah. I agree. I will try to set/clear User flag in svm_npt_rsvd_bits_test() and
> set User flag by default for all the test cases by calling setup_vm()
> and use walk_pte() to set/clear User flag in svm_npt_rsvd_bits_test().
>
> Walk_pte() routine uses start address and length to walk over the memory
> region where flag needs to be set/clear. So start address and length need to be
> figured out to use this routine.

For the start address and length you can use 'stext' and 'etext' to
compute those.  There's an example in access.c set_cr4_smep(),
however, it uses walk_ptes() as opposed to walk_pte() (similar, but
different).

>
> I will work on this.
>
> >
> > If we don't do that, this should really use walk_pte() instead of adding yet
> > another PTE walker.
>
> -Manali
