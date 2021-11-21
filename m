Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1CB14582CC
	for <lists+kvm@lfdr.de>; Sun, 21 Nov 2021 10:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233098AbhKUJr5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Nov 2021 04:47:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232486AbhKUJr5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Nov 2021 04:47:57 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A8EC061574;
        Sun, 21 Nov 2021 01:44:52 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id y16so19037849ioc.8;
        Sun, 21 Nov 2021 01:44:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RC6de6MWhYCf7e2tsmK+OyxaD0ok72SRMINmAEMjGL0=;
        b=FqVMTJCTyV1aEhJxH5JmMECHEr0Jm6Mkzw5IZRg2OFlhzmDHTfNG8DNGAJOFLwdCmD
         yu92PtvAL0e70ATPi40ceXndpXS/bTCS74cJR+P55DdgJzY5+5eGf9NcZ+N3Ha7ux7OX
         EoeQX0scPHt/bZWWrJ1HB+pYCdfdieP2Kbs027pLuccyduFocrc7540REg9w76QpxKN8
         G5A8rZQj5YdCgWvEn/Ln6MOXU8brqZq3cgAr+0hHIzh8hbSVZEH26fqEjLheTpKwZxO1
         XvvCGFt8IypRk2uWaC5CvGHSimgEFVbkXMBGaZQqwCkWYvZBoWgiC89PBdtOeKyb1rwd
         FTxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RC6de6MWhYCf7e2tsmK+OyxaD0ok72SRMINmAEMjGL0=;
        b=FDFtXcPTWPWtubnHh+1mnmgg6/NHTvYWoBGZxMqAxIIZNZA6aHPWyPK16sPIJvyqs2
         3LBafiQG3+ZGfIFZUIocUqCq5tqd2UG9dc7navmrXndbi5z+FFyrL9qnzP7XUdWCfh2V
         dpZWTase0U2WRe5lLTKqQzwhCDEEFWpkBR7Z5gJBjrQzdSrIfP4L/PmhToUgDiQwi5Dy
         ZiaZtu1aYs4BWZavJBq2HL5J0J3njH1/JSKAStA9BeqVAjB4IMJISAGuh4+IJ2zoSMRG
         IoQ1DYejl+vjVF1APEWMvM7DQ2KUMQx9mER5uzz7UR3aNwHQ16C7xum+t9Y5ekV23O6S
         BUfg==
X-Gm-Message-State: AOAM532HB+Nu4D9sPCy1ls2MMuTCgLQp3mxogHY6So6bmYlHxfSYU4Eu
        PE5R9UXs2xiOlIjX/zhpRCdaYc/FMcvmSjOO2iKwMlpP4zQ=
X-Google-Smtp-Source: ABdhPJzY31VEBXTw0nffYiMRdN2GR5XaqlH24Uejy6diRnkpvdnu18BmDGON83ijGsPOJ5BdN9elyWSFeqJLzm0xvPY=
X-Received: by 2002:a05:6638:4113:: with SMTP id ay19mr40738224jab.149.1637487891807;
 Sun, 21 Nov 2021 01:44:51 -0800 (PST)
MIME-Version: 1.0
References: <20211120015008.3780032-1-seanjc@google.com>
In-Reply-To: <20211120015008.3780032-1-seanjc@google.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Sun, 21 Nov 2021 17:44:40 +0800
Message-ID: <CAJhGHyAvoLYWEfHCaa+GTyDybqK_7++0qSzMDncfTt55NYP12A@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Use yield-safe TDP MMU root iter in MMU
 notifier unmapping
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Hou Wenlong <houwenlong93@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I guess it would conflict with c7785d85b6c6 ("KVM: x86/mmu:
Skip tlb flush if it has been done in zap_gfn_range()") from
Hou in the recent master branch in kvm tree.

On Sat, Nov 20, 2021 at 11:22 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Use the yield-safe variant of the TDP MMU iterator when handling an
> unmapping event from the MMU notifier, as most occurences of the event
> allow yielding.

My spell check add-on in the browser tells:
 occurences ->  occurrences

>
> Fixes: e1eed5847b09 ("KVM: x86/mmu: Allow yielding during MMU notifier unmap/zap, if possible")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 377a96718a2e..a29ebff1cfa0 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1031,7 +1031,7 @@ bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
>  {
>         struct kvm_mmu_page *root;
>
> -       for_each_tdp_mmu_root(kvm, root, range->slot->as_id)
> +       for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, false)
>                 flush |= zap_gfn_range(kvm, root, range->start, range->end,
>                                        range->may_block, flush, false);
>
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>
