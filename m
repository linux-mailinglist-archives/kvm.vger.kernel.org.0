Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63FD14DA7DF
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 03:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347204AbiCPCU7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 22:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237405AbiCPCU6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 22:20:58 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25B4427CE;
        Tue, 15 Mar 2022 19:19:45 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-2e59ea0f3d8so8313297b3.7;
        Tue, 15 Mar 2022 19:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2wDOJfE8Udv/yPkkP//z7M6l01Skx49rMSVyt4RFfkk=;
        b=joGnnPIeYb+VlXp+ly8j/0oB5qBB3qaNJh0k/cLpE61oXjRpfr2OVYTdHqwm4hyLSg
         1Bc0W3jnYw0d0kBXJ6PSvyDIzrUrQO4DGn0awBVEED2EpOgB14ixgrHd7dn+YTxkJ0ZL
         ldT0E3UDLviwkPNemhjQLp7MJJXHNdM5342Y4PlJB0HQjFDgT+x/UvAypwVQUXDc6Jf5
         sYqz35ghl125FMfkGglJNm+AUimgLhX+9kEup89hvsqXouTeQLYePAFOnjhdnToy1J6j
         CllkkMQUYaUxGjLY58UYQGWcMMO2NQtkM/5cVWk0f+Ah8ztdGRQdvDl+ryhg5nKbi2rW
         NWLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2wDOJfE8Udv/yPkkP//z7M6l01Skx49rMSVyt4RFfkk=;
        b=yTEW7mEid4wt0t5yxuLYumyShRWcsR8mE1IBsvBv9rbcD90wSSR6pY91tMsND+JA+Y
         USCWyeqLjv7IXrNNNzyYwrr0F0FQng4Fy2HIBF2PS3vKibBTnZfXdYk1Auywk5vgqak9
         ASoOVoudZtii+vCAxmgpRntP9NW5M4C6Icp4trVnEa1gYgmsos2jkwXdEgoigDAyEFy6
         t3O2N4B/IVACHOjxmBtGO5lDPkaIRA0ANHt7AdrriuMT0EVlXDa3TlRxf7NHI/bXNiBQ
         YjL3QDEwkt5k3Wo+axX4b86iw5KRm/roL5d91l2T5hUFp67QqfYRB6inLATFEG8Trzje
         XSxg==
X-Gm-Message-State: AOAM532Z5u73mDNDRg8l66WaTm5aEsaz+Dq4/hpalEPL7EK3tkfi4+nM
        ZajQBfy1GEcAwz3LfwPkj1H6sKsXb3CPbSAuC18=
X-Google-Smtp-Source: ABdhPJw4huEMVFKmb4DDLz4qwY4nPYpek7DI+L85d5wjn5LwIdVaRy+YtAtrq+un+GInFq6nbuqV+PAXA+b1GQ4gGjI=
X-Received: by 2002:a0d:eb02:0:b0:2e5:9d37:58ba with SMTP id
 u2-20020a0deb02000000b002e59d3758bamr2837723ywe.231.1647397184923; Tue, 15
 Mar 2022 19:19:44 -0700 (PDT)
MIME-Version: 1.0
References: <0dabeeb789f57b0d793f85d073893063e692032d.1647336064.git.houwenlong.hwl@antgroup.com>
In-Reply-To: <0dabeeb789f57b0d793f85d073893063e692032d.1647336064.git.houwenlong.hwl@antgroup.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Wed, 16 Mar 2022 10:19:33 +0800
Message-ID: <CAJhGHyCDTxabp_5BizzFofXRNp2ggNFNT-NHCGBO9AgavJyAYw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Don't rebuild page when the page is synced
 and no tlb flushing is required
To:     Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 15, 2022 at 6:45 PM Hou Wenlong <houwenlong.hwl@antgroup.com> wrote:
>
> Before Commit c3e5e415bc1e6 ("KVM: X86: Change kvm_sync_page()
> to return true when remote flush is needed"), the return value
> of kvm_sync_page() indicates whether the page is synced, and
> kvm_mmu_get_page() would rebuild page when the sync fails.
> But now, kvm_sync_page() returns false when the page is
> synced and no tlb flushing is required, which leads to
> rebuild page in kvm_mmu_get_page(). So return the return
> value of mmu->sync_page() directly and check it in
> kvm_mmu_get_page(). If the sync fails, the page will be
> zapped and the invalid_list is not empty, so set flush as
> true is accepted in mmu_sync_children().
>

Good catch.

Acked-by: Lai Jiangshan <jiangshanlai@gmail.com>

> Fixes: c3e5e415bc1e6 ("KVM: X86: Change kvm_sync_page() to return true when remote flush is needed")
> Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 3b8da8b0745e..8efd165ee27c 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1866,17 +1866,14 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
>           &(_kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(_gfn)])     \
>                 if ((_sp)->gfn != (_gfn) || (_sp)->role.direct) {} else
>
> -static bool kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
> +static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>                          struct list_head *invalid_list)

The comments for FNAME(sync_page) can be copied here.
