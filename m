Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A30C526991
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 20:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383354AbiEMSte (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 14:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383212AbiEMStd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 14:49:33 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C499165D29
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 11:49:31 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id b32so11325934ljf.1
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 11:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ywqjvCpLCTVPfjulU+NB5/mlV1UelqjH8K01XclRWvk=;
        b=JwoxiQkuclKF4XliKj7a/7FkhbSUr9SfGhqgMhXNb2GfHf+y1nJx6FrIa+REj8A4gz
         bj+911qrI6RcSD9Zh10TZWhGFw5EG0xtI7C289cfTO0kAdFBCp8CwPv1AU7sam8X5VIq
         FS1Vl/1ISSyxYDMett1LNT+ce7S+uFseGeJU1qgwD+2/bCI89Z8yRguMoft8FddCwUZr
         SMVKNfnvX7J/oPAu9/OnBNZHQODWaOBIERv5CjmHA5RBkvjth9ipyKAHKj6G8SLkxYYk
         LIUtCVvsmG5QHDAHlzoY+Mci/2p3IQKEtoxYmDs/u9bDrgpVhd9LHxrMTQnUQpM/ACqa
         K/lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ywqjvCpLCTVPfjulU+NB5/mlV1UelqjH8K01XclRWvk=;
        b=UdFvNDx7bLQmjAybDkFaQaxN4NE6AjrhFOFJWq96kOheehUJ1n1A9y/6xF8yFaZW35
         53O1C7ENwMF0xN/d4OchX7mTFWu2Un01Dqz7zd6PeOkWlVp13x/ablB1adwIA3nLMfkR
         Byy2kB/qq3wsuhynoBxGhPr9hWvRjAogO7u0lgZlVn8nkJpuC9zCumJd2Mixru7/7Xu5
         ejutcwxPvUiWaZ+6mv3hHvckuTUMUsK//eYs06YJJQHP4CbYOUOP0A3A2Ct0BdQtb6Rf
         haZ5+JHEf4a2grhaaOAY6uKy3Bvr3UOTevMir3IBspYvjYyIh+Ch58YLT9jQ8wpQjA1/
         OnoQ==
X-Gm-Message-State: AOAM5315H/pBA650/WoWc4l25uixgZz1v7z5ADbe9ZTatOHiD0ZekR9+
        2xH2ZDR0+KmqA4QQdKXIBKzW98ydCy446vQnneoHwQ==
X-Google-Smtp-Source: ABdhPJzt3B7cK/a9zQw3Wkki26oEfhQFSQHo9nfczJ7AFuroPAx8iUR0V2+oEzIxu7oR1qY3tgiRne/Fgs9VfOkYSo4=
X-Received: by 2002:a05:651c:b24:b0:250:6414:c91a with SMTP id
 b36-20020a05651c0b2400b002506414c91amr3785750ljr.198.1652467769955; Fri, 13
 May 2022 11:49:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220513182038.2564643-1-juew@google.com> <20220513182038.2564643-2-juew@google.com>
In-Reply-To: <20220513182038.2564643-2-juew@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 13 May 2022 11:49:03 -0700
Message-ID: <CALzav=dDEuOaD85gJ2MR0Y968Nm52AzmZ=SNvLoDZ-C335dQkg@mail.gmail.com>
Subject: Re: [PATCH v3 1/7] KVM: x86: Make APIC_VERSION capture only the magic 0x14UL.
To:     Jue Wang <juew@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tony Luck <tony.luck@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        Greg Thelen <gthelen@google.com>,
        Jiaqi Yan <jiaqiyan@google.com>
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

On Fri, May 13, 2022 at 11:22 AM Jue Wang <juew@google.com> wrote:
>
> This series adds the Corrected Machine Check Interrupt (CMCI) and
> Uncorrectable Error No Action required (UCNA) emulation to KVM. The
> former is implemented as a LVT CMCI vector. The emulation of UCNA share
> the MCE emulation infrastructure.
>
> This is the first of 3 patches that clean up KVM APIC LVT logic.

The change log should explain what a patch does and why. With the
current change log it's not clear what is being cleaned up in the KVM
APIC logic, and it's not clear what that has to do with CMCI/UNCA
emulation. This is important for reviewing (I can't tell if this patch
is correct since I can't tell what it's trying to accomplish) and for
future reference (e.g. people reading the git history).

>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Jue Wang <juew@google.com>
> ---
>  arch/x86/kvm/lapic.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 9322e6340a74..73b94e312f97 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -54,7 +54,7 @@
>  #define PRIo64 "o"
>
>  /* 14 is the version for Xeon and Pentium 8.4.8*/
> -#define APIC_VERSION                   (0x14UL | ((KVM_APIC_LVT_NUM - 1) << 16))
> +#define APIC_VERSION                   0x14UL
>  #define LAPIC_MMIO_LENGTH              (1 << 12)
>  /* followed define is not in apicdef.h */
>  #define MAX_APIC_VECTOR                        256
> @@ -367,7 +367,7 @@ static inline int apic_lvt_nmi_mode(u32 lvt_val)
>  void kvm_apic_set_version(struct kvm_vcpu *vcpu)
>  {
>         struct kvm_lapic *apic = vcpu->arch.apic;
> -       u32 v = APIC_VERSION;
> +       u32 v = APIC_VERSION | ((KVM_APIC_LVT_NUM - 1) << 16);

This change looks redundant with the change to APIC_VERSION above.

>
>         if (!lapic_in_kernel(vcpu))
>                 return;
> --
> 2.36.0.550.gb090851708-goog
>
