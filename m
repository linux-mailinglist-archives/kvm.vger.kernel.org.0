Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7250A77774E
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 13:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235382AbjHJLiq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 07:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235374AbjHJLip (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 07:38:45 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14DB92701
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 04:38:41 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-51bece5d935so1021758a12.1
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 04:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1691667519; x=1692272319;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=u8BlrjfKyS0XzZleStxvCQDwuXM/ozhO8WeUHPV+lJs=;
        b=KA3CsJ1xuUdfjaE4BfWCJQyNxuFCvFlEtF/RTai/3mLxyiYCKjtxOS4Na8Luml7jPQ
         aJhxn9MNWZkKNbyDfL4uGoS2xTB8UUkWdmfgYplqqQfvN0LG3Ru+JHZcuWG6J3mfL4DF
         vyvK7gtthd59xhENQXfJb4ldPDvpLjxtUYljRVYGUv3LMGBXRXyOiGJ1Vqh5YhUEs76i
         ejiz5vI2i41I/bdySHKvmnUurCxxBLNZE8fszYf/dmCsvx2KQQxXCtGsK+NK7HDuATSy
         2OOpFb0T/226o39rwMYK7HfDxTX2OohbY9XJsZUjkFf039cgbKGIom02eOm/4NEdQpOC
         W54w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691667519; x=1692272319;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u8BlrjfKyS0XzZleStxvCQDwuXM/ozhO8WeUHPV+lJs=;
        b=EzHQp18TLLd6XmsyGeRt0lI/06Q9odMP5aSKH14l6gjhY9P7NVU2F7Dx4zZtghwv5u
         luUyQV/DMGorfot+5m86Kfl0VZGYOAeJvqG9d2r51E+Mq5q21u/dijXvSZb3k2iuGoQy
         6m7b8GcCOqWEy7TYsnY4OAPsbJksjurZxPiaIngNZ88L1qFa2yVdMfcqLyZTmTPGdC7H
         JLc4wOIPWpGQR7V++Hya5Zo+LfqpEHdiRSK0P9sOkU9pFl/h+VurI++JMauto9Bpjal8
         /8kNg031WStgEBWKSn9oAyQ2BFQT8sSn/DzSlsb6mG8ROp7946g/32PmyxlVlfz9RQGB
         5M0A==
X-Gm-Message-State: AOJu0Yy5w1RBYF/Dg6uSn9MEzWgVZH2S6pJ6F2qXvz1MirzLBmU0sDtO
        znKO2l2kui2YTu1TdpTV1jsmybxFhyVy0Kr5uwkg1g==
X-Google-Smtp-Source: AGHT+IHxWF/ElJm8JTxCpNFi3l9phquDtya2Edpxm1u0LhFucJ2hLSfxYfwYz66rMTbhLXpW56jG4TXq8sX05F9FM8c=
X-Received: by 2002:a05:6402:1211:b0:523:10c0:9dc with SMTP id
 c17-20020a056402121100b0052310c009dcmr2108404edw.8.1691667519485; Thu, 10 Aug
 2023 04:38:39 -0700 (PDT)
MIME-Version: 1.0
References: <20230725122601.424738-2-ajones@ventanamicro.com> <20230810-3326d0a412d01fe729f7e6e4@orel>
In-Reply-To: <20230810-3326d0a412d01fe729f7e6e4@orel>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Thu, 10 Aug 2023 12:38:28 +0100
Message-ID: <CAFEAcA9Yj+9oWgjU1t=df+As0K7FhaE4YLJ9ee2oRpSEejTjCg@mail.gmail.com>
Subject: Re: [PATCH v2] kvm: Remove KVM_CREATE_IRQCHIP support assumption
To:     Andrew Jones <ajones@ventanamicro.com>
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, mtosatti@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, thuth@redhat.com,
        dbarboza@ventanamicro.com, kvm@vger.kernel.org,
        qemu-arm@nongnu.org, qemu-s390x@nongnu.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 10 Aug 2023 at 12:29, Andrew Jones <ajones@ventanamicro.com> wrote:
>
>
> Hi Paolo,
>
> Is this good for 8.1?

Is it fixing a regression since 8.0 ?

thanks
-- PMM

>
> Thanks,
> drew
>
>
> On Tue, Jul 25, 2023 at 02:26:02PM +0200, Andrew Jones wrote:
> > Since Linux commit 00f918f61c56 ("RISC-V: KVM: Skeletal in-kernel AIA
> > irqchip support") checking KVM_CAP_IRQCHIP returns non-zero when the
> > RISC-V platform has AIA. The cap indicates KVM supports at least one
> > of the following ioctls:
> >
> >   KVM_CREATE_IRQCHIP
> >   KVM_IRQ_LINE
> >   KVM_GET_IRQCHIP
> >   KVM_SET_IRQCHIP
> >   KVM_GET_LAPIC
> >   KVM_SET_LAPIC
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
> > v2:
> >   - Move the s390x code to an s390x file. [Thomas]
> >   - Drop the KVM_CAP_IRQCHIP check from the top of kvm_irqchip_create(),
> >     as it's no longer necessary.
> >
> >  accel/kvm/kvm-all.c    | 16 ++++------------
> >  include/sysemu/kvm.h   |  1 +
> >  target/arm/kvm.c       |  3 +++
> >  target/i386/kvm/kvm.c  |  2 ++
> >  target/s390x/kvm/kvm.c | 11 +++++++++++
> >  5 files changed, 21 insertions(+), 12 deletions(-)
> >
> > diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> > index 373d876c0580..cddcb6eca641 100644
> > --- a/accel/kvm/kvm-all.c
> > +++ b/accel/kvm/kvm-all.c
> > @@ -86,6 +86,7 @@ struct KVMParkedVcpu {
> >  };
> >
> >  KVMState *kvm_state;
> > +bool kvm_has_create_irqchip;
> >  bool kvm_kernel_irqchip;
> >  bool kvm_split_irqchip;
> >  bool kvm_async_interrupts_allowed;
> > @@ -2358,17 +2359,6 @@ static void kvm_irqchip_create(KVMState *s)
> >      int ret;
> >
> >      assert(s->kernel_irqchip_split != ON_OFF_AUTO_AUTO);
> > -    if (kvm_check_extension(s, KVM_CAP_IRQCHIP)) {
> > -        ;
> > -    } else if (kvm_check_extension(s, KVM_CAP_S390_IRQCHIP)) {
> > -        ret = kvm_vm_enable_cap(s, KVM_CAP_S390_IRQCHIP, 0);
> > -        if (ret < 0) {
> > -            fprintf(stderr, "Enable kernel irqchip failed: %s\n", strerror(-ret));
> > -            exit(1);
> > -        }
> > -    } else {
> > -        return;
> > -    }
> >
> >      /* First probe and see if there's a arch-specific hook to create the
> >       * in-kernel irqchip for us */
> > @@ -2377,8 +2367,10 @@ static void kvm_irqchip_create(KVMState *s)
> >          if (s->kernel_irqchip_split == ON_OFF_AUTO_ON) {
> >              error_report("Split IRQ chip mode not supported.");
> >              exit(1);
> > -        } else {
> > +        } else if (kvm_has_create_irqchip) {
> >              ret = kvm_vm_ioctl(s, KVM_CREATE_IRQCHIP);
> > +        } else {
> > +            return;
> >          }
> >      }
> >      if (ret < 0) {
> > diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> > index 115f0cca79d1..84b1bb3dc91e 100644
> > --- a/include/sysemu/kvm.h
> > +++ b/include/sysemu/kvm.h
> > @@ -32,6 +32,7 @@
> >  #ifdef CONFIG_KVM_IS_POSSIBLE
> >
> >  extern bool kvm_allowed;
> > +extern bool kvm_has_create_irqchip;
> >  extern bool kvm_kernel_irqchip;
> >  extern bool kvm_split_irqchip;
> >  extern bool kvm_async_interrupts_allowed;
> > diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> > index b4c7654f4980..2fa87b495d68 100644
> > --- a/target/arm/kvm.c
> > +++ b/target/arm/kvm.c
> > @@ -250,6 +250,9 @@ int kvm_arm_get_max_vm_ipa_size(MachineState *ms, bool *fixed_ipa)
> >  int kvm_arch_init(MachineState *ms, KVMState *s)
> >  {
> >      int ret = 0;
> > +
> > +    kvm_has_create_irqchip = kvm_check_extension(s, KVM_CAP_IRQCHIP);
> > +
> >      /* For ARM interrupt delivery is always asynchronous,
> >       * whether we are using an in-kernel VGIC or not.
> >       */
> > diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> > index ebfaf3d24c79..6363e67f092d 100644
> > --- a/target/i386/kvm/kvm.c
> > +++ b/target/i386/kvm/kvm.c
> > @@ -2771,6 +2771,8 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
> >          }
> >      }
> >
> > +    kvm_has_create_irqchip = kvm_check_extension(s, KVM_CAP_IRQCHIP);
> > +
> >      return 0;
> >  }
> >
> > diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
> > index a9e5880349d9..bcc735227f7d 100644
> > --- a/target/s390x/kvm/kvm.c
> > +++ b/target/s390x/kvm/kvm.c
> > @@ -391,6 +391,17 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
> >      }
> >
> >      kvm_set_max_memslot_size(KVM_SLOT_MAX_BYTES);
> > +
> > +    kvm_has_create_irqchip = kvm_check_extension(s, KVM_CAP_S390_IRQCHIP);
> > +    if (kvm_has_create_irqchip) {
> > +        int ret = kvm_vm_enable_cap(s, KVM_CAP_S390_IRQCHIP, 0);
> > +
> > +        if (ret < 0) {
> > +            fprintf(stderr, "Enable kernel irqchip failed: %s\n", strerror(-ret));
> > +            exit(1);
> > +        }
> > +    }
> > +
> >      return 0;
> >  }
> >
> > --
> > 2.41.0
> >
