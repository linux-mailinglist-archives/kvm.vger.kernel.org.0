Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF007610A1
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 12:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233520AbjGYKZA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 06:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233509AbjGYKY7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 06:24:59 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72CB3199D
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 03:24:50 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-9936b3d0286so933100266b.0
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 03:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1690280689; x=1690885489;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1p7MISDkCiYaiy9i9jbTvJ/hqGF3kuP6hXJ1xHmOvYA=;
        b=oeG4F8sMUGN2oCm5jifaER8r5T10e2Ad3mlC67oCI4QwivfGP76xigVREoO4aeDDHf
         AYgHi3cJL7ATjr1hd+vST5p0JV8j1tiAGgJDad69+85vkShSIRoMNoDOW1f/UQiDFsgP
         5+KDPsnc4B6Q8ddRYn3QdBgHZVp1oXFyjCl80r7w+gblLYU/TTnWquMHSzDzJKs3IbiF
         ncd5HoUlLHdtHeUs/TNoXfGT8UtKcwL0zL5u9V3kro6yNAwLsen92J90OqFke+7HXilz
         8Nlm5IByIgvuGV+U8/T+0HuE0oP096NDTt2Od5AuUo+EkyzCrTUPUaojYqRQldjLKaQH
         2RBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690280689; x=1690885489;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1p7MISDkCiYaiy9i9jbTvJ/hqGF3kuP6hXJ1xHmOvYA=;
        b=dCE6aXXD7zx6UMX/+HWZ7B5urFsiPt46h4Z/8Z7259QTDjEarKzTJ+YIgq8qEaPEsR
         bCnqB/GdizY6TEWcsTBME5puRnCRHIXK/Vw4p+rKe0SLA31CLIYXdy1hqvajCZYQdwln
         w+r7Qj7mZOc8kDo4ul1VmLyyZW0TucYbXDNom3X+mfHJ1TJOw0hulm9cBdqQ0yHKNTMJ
         Av8wy7kXcIPIBUaTsXfgpvXoT0ptU/GjxrFO0EWuVs1gM3MtJTT6pij85YWy6kzSCnJK
         +GmfOteBxkdrjG7jn0KpljevcaA81/h/I3uGgd69lVjsUj/mp2AAQGTchCYgNpchikM6
         jI6w==
X-Gm-Message-State: ABy/qLZ4Y4edqJ6uSysf+ChHa+uaiT+gwv3VttsKkosgQ35yxbgx7du+
        1dmw6+gZuDbyN55sQPAxbMv7TMOXzdGvj3sZy50=
X-Google-Smtp-Source: APBJJlHS57CS1mBgiX5uWMNsvP/Zch+nybxcneg3VBKKN7CiqbGve1QcbwWvut+hzvb3WzaX1t/mmQ==
X-Received: by 2002:a17:906:77d9:b0:99b:4edc:8a00 with SMTP id m25-20020a17090677d900b0099b4edc8a00mr12418127ejn.37.1690280688816;
        Tue, 25 Jul 2023 03:24:48 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id v27-20020a170906339b00b00985ed2f1584sm8061846eja.187.2023.07.25.03.24.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jul 2023 03:24:48 -0700 (PDT)
Date:   Tue, 25 Jul 2023 12:24:47 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, mtosatti@redhat.com,
        peter.maydell@linaro.org, pasic@linux.ibm.com,
        borntraeger@linux.ibm.com, dbarboza@ventanamicro.com,
        kvm@vger.kernel.org, qemu-arm@nongnu.org, qemu-s390x@nongnu.org
Subject: Re: [PATCH] kvm: Remove KVM_CREATE_IRQCHIP support assumption
Message-ID: <20230725-2345f08d2b8dd875b8082259@orel>
References: <20230722062115.11950-2-ajones@ventanamicro.com>
 <81dd6b4c-200f-bb35-69fa-ed623eb7e6d1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81dd6b4c-200f-bb35-69fa-ed623eb7e6d1@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
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
>

Sounds good. I'll do that for v2.

Thanks,
drew
