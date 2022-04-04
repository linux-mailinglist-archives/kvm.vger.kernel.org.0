Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39D034F1B8A
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 23:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380047AbiDDVVU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 17:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379966AbiDDS3E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 14:29:04 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B2E13F48
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 11:27:07 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-2e68c95e0f9so110746087b3.0
        for <kvm@vger.kernel.org>; Mon, 04 Apr 2022 11:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=khyTIUn3m8SPuUMnh7lkp1GRN/S6UpAf1fgYfOLm5Zo=;
        b=CjK5nB03NrxqKwV15ppNKUu/gA89gKFWsSKGrxIR+Q8NfNjxcGM5r+CPUyIAWZn7xd
         iQdKV3YF0cNw2HlPIO2rQBjMdzaAaMXV+SNcPdbLSf1SRmtz+meR4AWvzFtUzZKuhQ9i
         UZXGpUFbGO2TcyRq6PmEfRBD7KCMUcmkFG6A51bKfGXA9BWN4KzhyYdQoSFN8+fUPWn4
         bDQbGiAAmDEWZt5PCU8b6oNmY05zhcv/E2iyA4y4ZOgi7lPrpHrwNujKB+YUOuKkQZqG
         N5d3dFIf4irTSTc2BbkLA41cC2RW4m36dJnhP00LVTY9o4ncHzwWkNqBDYBn77/5ekW6
         /hzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=khyTIUn3m8SPuUMnh7lkp1GRN/S6UpAf1fgYfOLm5Zo=;
        b=juKyFDK1sUmJ8zNWKgVh9Hn+NzUz39NxlSyMIh2uiEqXpdqNY0fF4tFmoLiR9R5viq
         6gY72Gi0FR1bxPad/Yjx14pSttbE4NZUyfOGvttVWtUQYAgwqSPsc0L4/tim4a5aJyqh
         +qGgmHeH+bOao4Gz2joaFdPxYC0yhPzvvy7qIoIE/Gh73bNvV2WvrMcqkgguMZoK/cc6
         PrC7rMygDXJfdOnDCoJHGM2QesQNSHyVSevj4dYgTRLpQpT/1UCJU1RkcFJ2Rxb7zIyR
         RihBMo8d/26MYSCJSfLsTEOfQCEuvq9UI84hlSJY2Akq3JwBPWK++aHArCZWKMNa9Hp6
         DJBw==
X-Gm-Message-State: AOAM533KvKZwG1gSmF0ZgkTWWf6KQjDobXXwB1hA/kuYT5PqeRNVJfTS
        YEBW8kDZL2XroiSkwI7xM9i0DEwrwt2Om3hOND4InA==
X-Google-Smtp-Source: ABdhPJymfU0XtQ2OvJxVW04x/wIyLKAhq/QXjM/Tr9SI2s9QRZF4JzI6uM3nVFsMEGd/pzhKO4LC8c5s/XSjTYI50Lk=
X-Received: by 2002:a0d:d44e:0:b0:2e5:dc71:c82b with SMTP id
 w75-20020a0dd44e000000b002e5dc71c82bmr1242654ywd.42.1649096826511; Mon, 04
 Apr 2022 11:27:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220401233737.3021889-1-dmatlack@google.com> <20220401233737.3021889-3-dmatlack@google.com>
In-Reply-To: <20220401233737.3021889-3-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 4 Apr 2022 11:26:55 -0700
Message-ID: <CANgfPd-myyfOoBttiLGeHF12_r1GZS-z9-OVzswCk_a9A+vNpg@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: x86/mmu: Pass account_nx to tdp_mmu_split_huge_page()
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        "open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)" 
        <kvm@vger.kernel.org>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 1, 2022 at 4:37 PM David Matlack <dmatlack@google.com> wrote:
>
> In preparation for splitting huge pages during fault, pass account_nx to
> tdp_mmu_split_huge_page(). Eager page splitting hard-codes account_nx to
> false because the splitting is being done for dirty-logging rather than
> vCPU execution faults.
>
> No functional change intended.
>
> Signed-off-by: David Matlack <dmatlack@google.com>

Looks good to me, but this will conflict with some other patches from
Mingwei and Sean, so someone will have to send out another version.

> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index d71d177ae6b8..9263765c8068 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1456,7 +1456,8 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
>  }
>
>  static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
> -                                  struct kvm_mmu_page *sp, bool shared)
> +                                  struct kvm_mmu_page *sp, bool shared,
> +                                  bool account_nx)
>  {
>         const u64 huge_spte = iter->old_spte;
>         const int level = iter->level;
> @@ -1479,7 +1480,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
>          * correctness standpoint since the translation will be the same either
>          * way.
>          */
> -       ret = tdp_mmu_link_sp(kvm, iter, sp, false, shared);
> +       ret = tdp_mmu_link_sp(kvm, iter, sp, account_nx, shared);
>         if (ret)
>                 goto out;
>
> @@ -1539,7 +1540,7 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
>                                 continue;
>                 }
>
> -               if (tdp_mmu_split_huge_page(kvm, &iter, sp, shared))
> +               if (tdp_mmu_split_huge_page(kvm, &iter, sp, shared, false))
>                         goto retry;
>
>                 sp = NULL;
> --
> 2.35.1.1094.g7c7d902a7c-goog
>
