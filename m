Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0633E76181E
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 14:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233408AbjGYMTp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 08:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232511AbjGYMTm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 08:19:42 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9304E172A
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 05:19:39 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-992acf67388so804063666b.1
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 05:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1690287578; x=1690892378;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nYrCQRR/69uqvDwM5fk4fzz23/zdzo0otjNSbYd4kR4=;
        b=KECCAYKlu20hKqsaQ4cOSf/3XzAD8hYrj/Rq2i3xcScjjDq9v7gLd/Vebx9XKJy70R
         L3ZHAfde1TfZJEfYJIz+7y538pVaLD4BXAl5n6z457PNa/O8z0wxZ9+i2S+kce2NKO3+
         w4E62Zd36jyq63Hfa7x4SywHmX21aimGeLl9n+LUL/rBSkf+wXxvirER3kdFMqhX4gdY
         KX458aMnUL9L8s21mq1nbCCgrK9bRnN0kUduRFISzfKl1AYfFovoZjMr5tROPR0jGJib
         /iidJKWqni07Uk3c0D31vyZQpAUyis2tLLxy9k9amz0x0mwsMa2S5YzWVqKCj+BuB1gf
         Ppyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690287578; x=1690892378;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nYrCQRR/69uqvDwM5fk4fzz23/zdzo0otjNSbYd4kR4=;
        b=in3TRl2+Mp7IPhUPgjn4Sx3KGxtR9RperpBGMhp2wB9Gi0Kuh0zOmKplYGpNB1XVTN
         4g83x+Wwr03DLiTjrd519CWGWm3OFapW5gpiT6mJxXsjVRr3W/2caMVt5gJlUFrhTVRN
         JCqWbMLVjYDQFJ7SNmfI4nth78ZE9xb8sy5YHYnXBVOFRHgcipjeDU4tWbCOOAvBsbl4
         UO54CfnI7dpK/2G1YeVPcICxHjY/niStJddZMrj7PL8bhPVnJySoy5fGE2Qr3ZsL84D6
         kpOL8UNMMavUqW/8VNZz935cYTpv9u/bwXVY2Kdfh64P9Dzgv527gPkcimWBCKTTi0EX
         UJsQ==
X-Gm-Message-State: ABy/qLZrauXg979FqxLi/Be/Ofg7SX3BOULH7oboNl1Ly4vfFcqw76AA
        L1qx3pCLKUy7nuefFKmeDrGYTCIiNfhnFdZdpK0=
X-Google-Smtp-Source: APBJJlHCHvLtlmTSM3H9bL/uWGD5Lv9NiCDBzeiIz5nwstqRlZHtUf3IkveyPLYhqClhO5SYVEDC6Q==
X-Received: by 2002:a17:906:74d6:b0:993:d7f3:f055 with SMTP id z22-20020a17090674d600b00993d7f3f055mr11899478ejl.11.1690287577659;
        Tue, 25 Jul 2023 05:19:37 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id e27-20020a170906375b00b00988f168811bsm8205127ejc.135.2023.07.25.05.19.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jul 2023 05:19:37 -0700 (PDT)
Date:   Tue, 25 Jul 2023 14:19:36 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, mtosatti@redhat.com,
        peter.maydell@linaro.org, pasic@linux.ibm.com,
        borntraeger@linux.ibm.com, dbarboza@ventanamicro.com,
        kvm@vger.kernel.org, qemu-arm@nongnu.org, qemu-s390x@nongnu.org
Subject: Re: [PATCH] kvm: Remove KVM_CREATE_IRQCHIP support assumption
Message-ID: <20230725-539b009b8e15994408dbb47b@orel>
References: <20230722062115.11950-2-ajones@ventanamicro.com>
 <81dd6b4c-200f-bb35-69fa-ed623eb7e6d1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81dd6b4c-200f-bb35-69fa-ed623eb7e6d1@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 24, 2023 at 11:53:39AM +0200, Thomas Huth wrote:
> On 22/07/2023 08.21, Andrew Jones wrote:
> > Since Linux commit 00f918f61c56 ("RISC-V: KVM: Skeletal in-kernel AIA
> > irqchip support") checking KVM_CAP_IRQCHIP returns non-zero when the
> > RISC-V platform has AIA. The cap indicates KVM supports at least one
> > of the following ioctls:
> > 
> >    KVM_CREATE_IRQCHIP
> >    KVM_IRQ_LINE
> >    KVM_GET_IRQCHIP
> >    KVM_SET_IRQCHIP
> >    KVM_GET_LAPIC
> >    KVM_SET_LAPIC
> > 
> > but the cap doesn't imply that KVM must support any of those ioctls
> > in particular. However, QEMU was assuming the KVM_CREATE_IRQCHIP
> > ioctl was supported. Stop making that assumption by introducing a
> > KVM parameter that each architecture which supports KVM_CREATE_IRQCHIP
> > sets. Adding parameters isn't awesome, but given how the
> > KVM_CAP_IRQCHIP isn't very helpful on its own, we don't have a lot of
> > options.
> > 
> > Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
> > ---
> > 
> > While this fixes booting guests on riscv KVM with AIA it's unlikely
> > to get merged before the QEMU support for KVM AIA[1] lands, which
> > would also fix the issue. I think this patch is still worth considering
> > though since QEMU's assumption is wrong.
> > 
> > [1] https://lore.kernel.org/all/20230714084429.22349-1-yongxuan.wang@sifive.com/
> > 
> > 
> >   accel/kvm/kvm-all.c    | 5 ++++-
> >   include/sysemu/kvm.h   | 1 +
> >   target/arm/kvm.c       | 3 +++
> >   target/i386/kvm/kvm.c  | 2 ++
> >   target/s390x/kvm/kvm.c | 3 +++
> >   5 files changed, 13 insertions(+), 1 deletion(-)
> > 
> > diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> > index 373d876c0580..0f5ff8630502 100644
> > --- a/accel/kvm/kvm-all.c
> > +++ b/accel/kvm/kvm-all.c
> > @@ -86,6 +86,7 @@ struct KVMParkedVcpu {
> >   };
> >   KVMState *kvm_state;
> > +bool kvm_has_create_irqchip;
> >   bool kvm_kernel_irqchip;
> >   bool kvm_split_irqchip;
> >   bool kvm_async_interrupts_allowed;
> > @@ -2377,8 +2378,10 @@ static void kvm_irqchip_create(KVMState *s)
> >           if (s->kernel_irqchip_split == ON_OFF_AUTO_ON) {
> >               error_report("Split IRQ chip mode not supported.");
> >               exit(1);
> > -        } else {
> > +        } else if (kvm_has_create_irqchip) {
> >               ret = kvm_vm_ioctl(s, KVM_CREATE_IRQCHIP);
> > +        } else {
> > +            return;
> >           }
> >       }
> >       if (ret < 0) {
> 
> I think I'd do this differntly... at the beginning of the function, there is
> a check for kvm_check_extension(s, KVM_CAP_IRQCHIP) etc. ... I think you
> could now replace that check with a simple
> 
> 	if (!kvm_has_create_irqchip) {
> 		return;
> 	}
> 
> The "kvm_vm_enable_cap(s, KVM_CAP_S390_IRQCHIP, 0)" of course has to be
> moved to the target/s390x/kvm/kvm.c file, too.

Actually, once we've moved the s390 cap enablement to the s390 file we can
just drop the whole if-else chain. We don't want the
if (!kvm_has_create_irqchip) at the top because we want to try
kvm_arch_irqchip_create() even when kvm_has_create_irqchip is false, and
we don't need to check KVM_CREATE_IRQCHIP for kvm_arch_irqchip_create()
either. Keeping the check, as it is above in this v1, of
kvm_has_create_irqchip for KVM_CREATE_IRQCHIP is still necessary, though.

Thanks,
drew
