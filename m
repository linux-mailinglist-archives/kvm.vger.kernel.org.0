Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B28C6C8532
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 19:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbjCXSf3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 14:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjCXSfV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 14:35:21 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596F120A11
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 11:35:05 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id n125so3349527ybg.7
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 11:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679682904;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c6NswupsfIhuqFBcnQy/83JAo/+d4572KJXCmPdgXQo=;
        b=qT97gXwseq6XfGvc0vAFQ1yKSTEj44+PfQRo5w9+1avD9ifBebs86KuwekzuCRqkwc
         RJtWjHj5ktafb2j5BAbVBGMf0Nlk/oPG1p9nKkKlZ0PFvbMsTcDHEk/kq2G519BiYlq1
         ubS43c3Jtwe7rp7Q6g6AhEanPBGYNB+GZFtLII3Qc0O0ey+YkK9/PR23yLfkv7I/LqrA
         n4umamZGxbX+0LORHyYut7CH97krVGqSP40patAqS5t52/vRG3XgUOT6fWpxAei1/pyT
         Bv6MPgrp7HL1eTilZgaMhI3ZZqbUceRA5kBdXSFJuLe+Wl5WO4CDbFKUA2k5MBjiiRyk
         W2/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679682904;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c6NswupsfIhuqFBcnQy/83JAo/+d4572KJXCmPdgXQo=;
        b=G0zUetXafbGiEAIy40U9wlDsU06kH8IVzQsD/NmFj2+gIMc2TEVvWC3JRhptJew3gi
         kFivhxB5pPQpcKbnHxEq6JpB8SRBbFnnCest/+rceL9uSrAY1ReW4qlumJBQ+sNX+L4l
         apHLU6uDrBOiomZuezBz3cWB8nNk7FVGdYtzJOn1i9iYrHSH2DR1yvndEDGx84dcYW7y
         yfIHhrfDKO8XzRM+cF9jSQIE7Tn1fapu6a1Zdoq78TfWt8aWiXeodYT4WVKSmyfXxE+X
         +RHwgMUblfjyL1NGS4dS09MAYNSIgswRVWV9ckMTFYbu0FhXteDv5xXnH7sZyOLtY077
         Ke7A==
X-Gm-Message-State: AAQBX9eRzzFEWCIEPJbhfZBoJp4EOScWFpZl6kxlScOkVpy52PSKf6vW
        /lAoNrYgyQQBiZh4wv/Dc3sRNQpEbVOlB5Cr6XWg7QAYBt3QyXIa/mDy8Q==
X-Google-Smtp-Source: AKy350YN+ujUGvesVqsbcvCCJc6hfjyjea+IyrxRl1p/ZFNb1YH60oDCXvfXoRVaA3jl5vCyW6MmqwPhbgV01T8GYaM=
X-Received: by 2002:a05:6902:1181:b0:b6c:2224:8a77 with SMTP id
 m1-20020a056902118100b00b6c22248a77mr1983582ybu.1.1679682904419; Fri, 24 Mar
 2023 11:35:04 -0700 (PDT)
MIME-Version: 1.0
References: <20230113122910.672417-1-jiangshanlai@gmail.com> <167934153606.1941128.1026865175616779306.b4-ty@google.com>
In-Reply-To: <167934153606.1941128.1026865175616779306.b4-ty@google.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Fri, 24 Mar 2023 11:34:28 -0700
Message-ID: <CAL715W+a=og5f-v1o+56wTDmLJr1HitgFzmvL276BuomZvS7YA@mail.gmail.com>
Subject: Re: [PATCH] kvm: x86/mmu: Simplify pte_list_{add|remove}
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 23, 2023 at 3:51=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, 13 Jan 2023 20:29:10 +0800, Lai Jiangshan wrote:
> > Simplify pte_list_{add|remove} by ensuring all the non-head pte_list_de=
sc
> > to be full and addition/removal actions being performed on the head.
> >
> > To make pte_list_add() return a count as before, @tail_count is also
> > added to the struct pte_list_desc.
> >
> > No visible performace is changed in tests.  But pte_list_add() is no lo=
nger
> > shown in the perf result for the COWed pages even the guest forks milli=
ons
> > of tasks.
> >
> > [...]
>
> Applied to kvm-x86 mmu, thanks!  I added quite a few comments and a BUG_O=
N() to
> sanity check that the head is never empty when trying to remove an entry,=
 but I
> didn't make anything changes to the code itself.
>
> [1/1] kvm: x86/mmu: Simplify pte_list_{add|remove}
>       https://github.com/kvm-x86/linux/commit/141705b78381
>

I am not sure if it is possible, but now spte_count is u32 so does
tail_count. I wonder if an attacker could use the potential integer
overflow to trigger this? E.g,: creating a huge number of little L1
EPTs with the many nGPA-> one GPA? hmm, I think it could overflow
tail_count? Please double check.

spte_count is u32, but assigned to an (signed) int j and BUG_ON(j <
0)? Please don't add more BUG_ON in KVM mmu... and please change
either 'spte_count' to 'int' or 'j' to u32.

In general, please, no BUG_ON(), at least no more BUG_ON() on our nested MM=
U...

Please take a second thought on this one before merge!

Thanks.

-Mingwei
