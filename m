Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43A43D95BE
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 21:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbhG1TCt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 15:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbhG1TCs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 15:02:48 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33209C061765
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 12:02:46 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id g13so5838019lfj.12
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 12:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WxJfCRcm28Q2mtsiHw3xjSJ0DqRCRRYstcd9Q20/xQQ=;
        b=h1XD5KmacsdUAtbaHNScOkc4DLg84/eQEn/iMfLNe1maR49bt1wCDsB+EWz924QuhM
         yg7UwljEOJ8uTiBJCd5MaKIN9FcLfzEyk4sjhj/afJbP5n1aNqKQTWxRAew7fegon5ju
         yOjQTYyseuc2AAyc8ir3EXAnKfdZBqBPhAlQNqBsKsSXCvlmnd0naeobSxKW9xwxPSpn
         8xwpzF+pzAoouVn63N/KAEyp6KHPP/6HMjX0nwn0QU/VFR1P4dzUdp94aQ22t9qw3dQy
         ssDDge8K9XRwwy2Xqt1I6umnjyXtbdWtSeBwjq49+owOqUN6FnoJ1mwuf6g+iNyuOAAF
         HvGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WxJfCRcm28Q2mtsiHw3xjSJ0DqRCRRYstcd9Q20/xQQ=;
        b=bYvt33KD6xFVlbk0y8C1BcQJjTplJhMq2QcCT8teBrcXP7GxkVBsvBlNscOPo8U8AH
         yTM6TRqbrVew32WBTXWll9VoveIx9Ue9/7cdXYVs3J12UxCi5xjSpUt0uV+z+l0moquZ
         5p8YQHcnIkAIrp2klXMBAbIeQ1E/zozTtraOAlJffkiKOhlBYECrdmYUHcSK9qiySVx2
         qHkZMLP0CZHkYC7vTOeuuiKopsQCnRg/x/HLuwKnMnPmcnMAfAyLJ+lKXrGqvQrpNowz
         Y/jnVXFXABG76k6fs66dO5iNbJfKyJUR1OFaebNrQx5DVRnEl02LRl2PTl6OoV6Wc+b6
         Eugg==
X-Gm-Message-State: AOAM532uv7bzMq9SXsDTABbTq2ZcTKMZXv77Htu5xRMJIuW0Yw5RxmKN
        66rOgABa7ZVI7Shs9z7HjrKfwmHa1jbtE84Wg+k5LA==
X-Google-Smtp-Source: ABdhPJz1ZBo2qfIXLXj9J9AuWps3bxG9GMcoWTo51fL/O5qgHVUFf00HxQNpDGyfKWNQadpw2tNsh9g2M3liJMGm4iE=
X-Received: by 2002:a05:6512:3b94:: with SMTP id g20mr784842lfv.0.1627498964165;
 Wed, 28 Jul 2021 12:02:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210727103251.16561-1-pbonzini@redhat.com>
In-Reply-To: <20210727103251.16561-1-pbonzini@redhat.com>
From:   Oliver Upton <oupton@google.com>
Date:   Wed, 28 Jul 2021 12:02:33 -0700
Message-ID: <CAOQ_Qsg+mwmcuht=rQrqNdzaTGKgak0BQwFHzSj=9RZdK9tB5w@mail.gmail.com>
Subject: Re: [PATCH] KVM: ARM: count remote TLB flushes
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 27, 2021 at 3:33 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> KVM/ARM has an architecture-specific implementation of
> kvm_flush_remote_tlbs; however, unlike the generic one,
> it does not count the flushes in kvm->stat.remote_tlb_flush,
> so that it inexorably remained stuck to zero.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Oliver Upton <oupton@google.com>

> ---
>  arch/arm64/kvm/mmu.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index c10207fed2f3..6cf16b43bfcc 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -81,6 +81,7 @@ static bool memslot_is_logging(struct kvm_memory_slot *memslot)
>  void kvm_flush_remote_tlbs(struct kvm *kvm)
>  {
>         kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
> +       ++kvm->stat.generic.remote_tlb_flush;
>  }
>
>  static bool kvm_is_device_pfn(unsigned long pfn)
> --
> 2.31.1
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
