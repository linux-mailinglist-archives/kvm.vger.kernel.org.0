Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E49E03F8D76
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 20:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243218AbhHZSCL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 14:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232159AbhHZSCJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 14:02:09 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64B4FC061757
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 11:01:20 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id u11-20020a17090adb4b00b00181668a56d6so2945012pjx.5
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 11:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QgZbnxVtGJ1vU/xYWeI8fIAwGH0NNU1l0sk9BASJi3A=;
        b=m05C5aXu8Pz/nvLpy6GaHwayrmqJ1a0LQNiWk7QGQicePlSFWGwaghG+4McxbSm/uA
         LYz0gR0yUdFu5PZiWDKnEuWGwS3vvHlMyd5bS3rnlFQsYutpCNBW8v/D3gUzUbdG2hxp
         LYncdVHUeJ9xl7BV7uFRCTfwRKYT9JmKaSckDYn4slA4i0UA7b91GCS6oAXm0D05Yi3d
         NISu2BjvNbgkcTqo0jsE5poaEDLF21tzV1+hMdSjyi/3gVdvXIJcnV4EetWmHgIReyhs
         NkOOQuxwH2oaCqTHwnpRtstgz4c2/WeUCHh2cOSRt140wh6NUGK5T2I5NyhLTP1EuLGy
         gUWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QgZbnxVtGJ1vU/xYWeI8fIAwGH0NNU1l0sk9BASJi3A=;
        b=a2/jZ6dUxx6icyy5nfdKOEkh/FglSIoO6BCIwK5ulC99ONLg80bFC73Ayul1yVJjsE
         I3FWrFcA5kq9veOzIsd0wxTPiVj1CUH2L/6kK4vNbWOIeb18su1xVRCYvNrVxuxlF4iH
         xOaoBspho0r0PNRfuyhph9aLUiRxazSUs43v8TAidUI9P0b/1PHLyUB1Wmlww64OdVL0
         B8SxiXfpaGwbSdLUewNfe+/KRhRd/dceLJeC0eoSCEo8NfE5BLFT6gFvzo59YH9KQbTK
         Sb72jZnkxOvfjEjT/Qp7NW/qDh6/sjNI9nVZZ5Slo7TraQIPIboCjNowvTHXwOX1pyBz
         21Bw==
X-Gm-Message-State: AOAM530o4MfAvUaPNKFKOoq8fm+7fUcygYUZCCxhshrOng2wTy/3zE3N
        JKuXAtOkgvLnFbpFpFIPjKzahw==
X-Google-Smtp-Source: ABdhPJxxFcXXfOWnor0WexUD6PjVXREgNNqrFllU6KFIMg9SikX544/6MYI/MJLisdURixL8YcU5Fg==
X-Received: by 2002:a17:902:684d:b0:138:7bed:7471 with SMTP id f13-20020a170902684d00b001387bed7471mr4723273pln.68.1630000879595;
        Thu, 26 Aug 2021 11:01:19 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u25sm3503724pfn.209.2021.08.26.11.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 11:01:19 -0700 (PDT)
Date:   Thu, 26 Aug 2021 18:01:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Eduardo Habkost <ehabkost@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] KVM: x86: Fix stack-out-of-bounds memory access
 from ioapic_write_indirect()
Message-ID: <YSfW62JxXXBI1/UE@google.com>
References: <87mtp7jowv.fsf@vitty.brq.redhat.com>
 <CAOpTY_ot8teH5x5vVS2HvuMx5LSKLPtyen_ZUM1p7ncci4LFbA@mail.gmail.com>
 <87k0kakip9.fsf@vitty.brq.redhat.com>
 <2df0b6d18115fb7f2701587b7937d8ddae38e36a.camel@redhat.com>
 <87h7fej5ov.fsf@vitty.brq.redhat.com>
 <36b6656637d1e6aaa2ab5098f7ebc27644466294.camel@redhat.com>
 <87bl5lkgfm.fsf@vitty.brq.redhat.com>
 <CAOpTY_q=0cuxXAToJrcqCRERY_sUSB1HNVBVNiEpH6Dsy0-+yA@mail.gmail.com>
 <87tujcidka.fsf@vitty.brq.redhat.com>
 <20210826145210.gpfbiagntwoswrzp@habkost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210826145210.gpfbiagntwoswrzp@habkost.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 26, 2021, Eduardo Habkost wrote:
> > @@ -918,7 +918,7 @@ static bool kvm_apic_is_broadcast_dest(struct kvm *kvm, struct kvm_lapic **src,
> >  static inline bool kvm_apic_map_get_dest_lapic(struct kvm *kvm,
> >                 struct kvm_lapic **src, struct kvm_lapic_irq *irq,
> >                 struct kvm_apic_map *map, struct kvm_lapic ***dst,
> > -               unsigned long *bitmap)
> > +               unsigned long *bitmap64)
> 
> You can communicate the expected bitmap size to the compiler
> without typedefs if using DECLARE_BITMAP inside the function
> parameter list is acceptable coding style (is it?).
> 
> For example, the following would have allowed the compiler to
> catch the bug you are fixing:
> 
> Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
> ---
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index d7c25d0c1354..e8c64747121a 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -236,7 +236,7 @@ bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector);
>  void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu);
>  
>  void kvm_bitmap_or_dest_vcpus(struct kvm *kvm, struct kvm_lapic_irq *irq,
> -			      unsigned long *vcpu_bitmap);
> +			      DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS));
>  
>  bool kvm_intr_is_single_vcpu_fast(struct kvm *kvm, struct kvm_lapic_irq *irq,
>  			struct kvm_vcpu **dest_vcpu);
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 76fb00921203..1df113894cba 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1166,7 +1166,7 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
>   * each available vcpu to identify the same.
>   */
>  void kvm_bitmap_or_dest_vcpus(struct kvm *kvm, struct kvm_lapic_irq *irq,
> -			      unsigned long *vcpu_bitmap)
> +			      DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS))
>  {
>  	struct kvm_lapic **dest_vcpu = NULL;
>  	struct kvm_lapic *src = NULL;

Sadly, that would not have actually caught the bug.  In C++, an array param does
indeed have a fixed size, but in C an array param is nothing more than syntatic
sugar that is demoted to a plain ol' pointer.  E.g. gcc-10 and clang-11 both
happily compile with "DECLARE_BITMAP(vcpu_bitmap, 0)" and the original single
"unsigned long vcpu_bitmap".  Maybe there are gcc extensions to enforce array
sizes?  But if there are, they are not (yet) enabled for kernel builds.
