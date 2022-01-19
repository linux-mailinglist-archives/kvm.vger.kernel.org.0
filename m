Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 438B5493547
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 08:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351919AbiASHMV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 02:12:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346462AbiASHMU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 02:12:20 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4FDC061574;
        Tue, 18 Jan 2022 23:12:20 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id v8-20020a9d6048000000b005960952c694so1849300otj.12;
        Tue, 18 Jan 2022 23:12:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o7eCy47p8PgyTrOH5oES78YY4Yx66VgoOxIZhjYdi4s=;
        b=jl2DNY2l03Hn739PZbt1QyBMPoc+BjoqY6cKv7uJnJfgaL6TBDarXSUEkkZUXujpE2
         ovVuyCnAYU+WNitEsjwJNNNCroUah20OjR7R2h9qDYFlp19uEdb8YA0V9CE62V09I057
         RnviYjVGmBruwusx/CT8rhBRF4S9u3sR1vcT1D/sNvmWErrQggJ77prMpaSJFICoB70w
         RPyEsofSaHOmMxbYQBMFNHRuQWSr/54FXNGDE4esGqsRx0JQupQi56JHiTWxqhMFgyM2
         E7LKVSkzir1DbTunVzPPJ4TaBcM/d914v8eqiUuiwUxUzmcbHPUBxQXoRV0C0ywv++yL
         bzbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o7eCy47p8PgyTrOH5oES78YY4Yx66VgoOxIZhjYdi4s=;
        b=6INuRiesyhrAZd261cUuBRZ1d+NODNkEwSeOhvsJVcEGbgcpjvrH4Hj5hSC006PEIy
         g4Is9/FeCUtumQfLxBWs5Z+ZrG58KkRmbByWH91gZvAlwYLTK+3JNx5DB19CkwEMs8mO
         apXjJYO+FmKY1ZisG7PPvBL5k0uZqeVkCzF3dket6RRor9FKWMLLroCEMkkWiDf91oY0
         6OxZu/6KMITIQBVmsWQUkJefcFBo8D22vZjacOqFepbQayyhqFmevoH9egihWSsCT7XZ
         H+aA52E5ZrG4tTbZ/sFjgKNhhKcgGmYjUE+q7mHurDQ/GUcj/99ohYu2wJ3CBOvz9VYC
         9u8Q==
X-Gm-Message-State: AOAM533FTMf18bJ8YBeKoogEkhLUKKW90NsCPuu3juzoeqNT8pKoqaoK
        aikj2OZmFMv83YNVQg7+MpUGQ7VEccymstgsW7A=
X-Google-Smtp-Source: ABdhPJxe++bk388gQOrGSG70DftId7fwHoXzzJ4sJ04VPBYqnpYEWJRQg3tiaOSKXH1cVtWcfNf2H5NgQWOv7KCNvN8=
X-Received: by 2002:a9d:7212:: with SMTP id u18mr9062189otj.145.1642576340166;
 Tue, 18 Jan 2022 23:12:20 -0800 (PST)
MIME-Version: 1.0
References: <1641471612-34483-1-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1641471612-34483-1-git-send-email-wanpengli@tencent.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 19 Jan 2022 15:12:09 +0800
Message-ID: <CANRm+CxOvAo_bvMYOkdwRh8og4HxU3mRR94Jp0SO1+qEP2ak_g@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: LAPIC: Enable timer posted-interrupt when
 mwait/hlt is advertised
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Aili Yao <yaoaili@kingsoft.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kindly ping, :)
On Thu, 6 Jan 2022 at 20:21, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> From: Wanpeng Li <wanpengli@tencent.com>
>
> As commit 0c5f81dad46 (KVM: LAPIC: Inject timer interrupt via posted interrupt)
> mentioned that the host admin should well tune the guest setup, so that vCPUs
> are placed on isolated pCPUs, and with several pCPUs surplus for *busy* housekeeping.
> It is better to disable mwait/hlt/pause vmexits to keep the vCPUs in non-root
> mode. However, we may isolate pCPUs for other purpose like DPDK or we can make
> some guests isolated and others not, we may lose vmx preemption timer/timer fastpath
> due to not well tuned setup, and the checking in kvm_can_post_timer_interrupt()
> is not enough. Let's guarantee mwait/hlt is advertised before enabling posted-interrupt
> interrupt. vmx preemption timer/timer fastpath can continue to work if both of them
> are not advertised.
>
> Reported-by: Aili Yao <yaoaili@kingsoft.com>
> Cc: Aili Yao <yaoaili@kingsoft.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v1 -> v2:
>  * also check kvm_hlt_in_guest since sometime mwait is disabled on host
>
>  arch/x86/kvm/lapic.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index f206fc3..fdb7c81 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -113,7 +113,8 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
>
>  static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
>  {
> -       return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
> +       return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
> +               (kvm_mwait_in_guest(vcpu->kvm) || kvm_hlt_in_guest(vcpu->kvm));
>  }
>
>  bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu)
> --
> 2.7.4
>
