Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D81052CEAC
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 10:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235637AbiESIu6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 04:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231838AbiESIu5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 04:50:57 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97EBD109B;
        Thu, 19 May 2022 01:50:48 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-d6e29fb3d7so5943286fac.7;
        Thu, 19 May 2022 01:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s/jKTM8nU9QM/2p2qPlG421S2RUaa03Kvk8UUYYHtlg=;
        b=epSxT9TMjeanb166onZsIfWhvoMygyPn4fGEFLp0dS+HeiZ5rtmuurVeamS+ty4RKM
         KoKtTSwclnIpKNd1Lpua0MZui8kxcAHrk/6vlnGNoKmLId7WrDGDzi74cEQrNFerEm27
         dY4lk3q+oO+H/Sby6PUvA1v59g2/uXXTGxWoKoM7LaW8KxgaBVQ+Hi35Z3ntB+AglLpT
         lEVZj/L91AHjEoSCFQ+TfrXlp8iY+goi8njZHWUq/MY5ZF951GtMf0LV5dQD6btCnt6l
         Xh8ddytJ3oECbyw0K0Rdc7N2i9WOOq2+nMiXO9Pv7ZjAITDBq7et908jTg+3gtbR8yo4
         +bQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s/jKTM8nU9QM/2p2qPlG421S2RUaa03Kvk8UUYYHtlg=;
        b=UXRO3k3fAZdRbyJq4d+mGS9HJojRSlUlk106hWIr0RAJiHoJRGHA3QFMziEwRvqMHp
         W33ZAVIAQxzhWZJ7wT9XYS8Nn1arU+b76LEaZIoGOfj2rDd3apiZWF/8sdoaoOcB4pfq
         DwMptpGDYkh4DOgC8+08NPrquoYiFUeE5Qtggxql2xOhoSsiRR4XaVPEiZx7PK1iFf3D
         4vXE+2+94b3hLeBY1SU/aJ8Mp6PRe08ymKvv6h4KwA66aMfB0UtXETFCBEg6ZqjTilYm
         h8Xekw1gPPPxMw9SOf4q88JJIpBgKNn0KlY5LDb46XEAVDhS6Cpov+ESQX8SXibStZzl
         S3nA==
X-Gm-Message-State: AOAM530euq1FnJrW+R3Art1trmBUz/C0fCnx/6owM2zmZvNsnPhwlItx
        IIoa2oz2tOqhQ5FFO9duC4ZtFkjqjL4jPRPXCvFMHGCC
X-Google-Smtp-Source: ABdhPJy0iY2R0vgsXz9NosQtaKPCaAqqgY79hu+YUz6RmsMviX9IKBJlflLg7nACAsalGqatvr83Yiau6+xJITKPqpc=
X-Received: by 2002:a05:6870:311d:b0:de:9b6c:362b with SMTP id
 v29-20020a056870311d00b000de9b6c362bmr2262545oaa.200.1652950247928; Thu, 19
 May 2022 01:50:47 -0700 (PDT)
MIME-Version: 1.0
References: <1652236710-36524-1-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1652236710-36524-1-git-send-email-wanpengli@tencent.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 19 May 2022 16:50:36 +0800
Message-ID: <CANRm+Cz0S7DwojGkGOuyygGnZb8xz1T-fOCjQm5pzf5tCadPvg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: LAPIC: Disarm LAPIC timer includes pending
 timer around TSC deadline switch
To:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
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

ping,
On Wed, 11 May 2022 at 10:39, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> From: Wanpeng Li <wanpengli@tencent.com>
>
> The timer is disarmed when switching between TSC deadline and other modes,
> however, the pending timer is still in-flight, so let's accurately set
> everything to a disarmed state, this patch does it by clearing pending
> when canceling the timer.
>
> Fixes: 4427593258 (KVM: x86: thoroughly disarm LAPIC timer around TSC deadline switch)
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v1 -> v2:
>  * clear pending in cancel_apic_timer
>
>  arch/x86/kvm/lapic.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 66b0eb0bda94..6268880c8eed 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1548,6 +1548,7 @@ static void cancel_apic_timer(struct kvm_lapic *apic)
>         if (apic->lapic_timer.hv_timer_in_use)
>                 cancel_hv_timer(apic);
>         preempt_enable();
> +       atomic_set(&apic->lapic_timer.pending, 0);
>  }
>
>  static void apic_update_lvtt(struct kvm_lapic *apic)
> --
> 2.25.1
>
