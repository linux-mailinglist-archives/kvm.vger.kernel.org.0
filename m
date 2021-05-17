Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6F753831F9
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 16:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239681AbhEQOnq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 10:43:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41051 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240708AbhEQOlb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 May 2021 10:41:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621262414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SxUjYdy1tvR24tzvdmrjzuEpUmQ6NlqelxDqornlhWs=;
        b=KubCOiBoIzWTvn8E77Fa7/xktx39wIR8k6sYuAoal4XBvxTIaItfyXm2knKWoYte4OsN/O
        F1x8H749sJaBrdPFScm0FRlNDCsx92anP4BfwVmIgpyp2W/cWATvfwDyJlyynCcJ3u4gHI
        dPj+QWYouKMBxeWUiqRbGNP0JIAIgX0=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-J_lVYKpGPjqDDlo7Va2tYA-1; Mon, 17 May 2021 10:40:12 -0400
X-MC-Unique: J_lVYKpGPjqDDlo7Va2tYA-1
Received: by mail-ej1-f71.google.com with SMTP id z1-20020a1709068141b02903cd421d7803so1110437ejw.22
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 07:40:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=SxUjYdy1tvR24tzvdmrjzuEpUmQ6NlqelxDqornlhWs=;
        b=t29D+tU1//EdVXJfIpwwuwoGXvfNH6SGQN16bZ+RKXExwDyDqlw/NM8HaBaVn1DwB7
         2lkMHGFtjX47fzdh2z8hX170MgZQOciNmB7Xg57XzdHZtCN18Ue15d41aEcIN0zY2ki0
         1PxvMNCKlfdOpI0I5WMJJMsmxY+RRiG2n0yxTfpGKd0x2n98nPZaiWyuiT5ypnXlZ9ck
         CvGREeZTYftHg3wmQpHTB8JF++Tqok/E+Cs/WZC8nQo06egbqx3Zk2H/ejTaU0oCnTDH
         oWeUaBoWOey3i8UmHMtQfnLTdzT1NSNariza+DEZ38QbvoXyNCnaFgATnXMfQxJKl3dP
         eejQ==
X-Gm-Message-State: AOAM532pPTUD09syqa25d1Sb8jErbSb2ov6GDRg+oOomvr/ZjFiPTNua
        Sc8bmrLp/rFOqHII7Yaun+xttMj0JYOzzK3rY9zc+aeKuv2uTdP9GpfgGuZo3y/ab4lNbZTzz7e
        Vd+x2Da3ywG7Q
X-Received: by 2002:aa7:df11:: with SMTP id c17mr376110edy.317.1621262411377;
        Mon, 17 May 2021 07:40:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz42t5kTR1xxy06OepELp1nQDlUl1jD3Zm9FpDE0EI4Puq5NeCaei+Mj5JPcRuymz3KoGxBYQ==
X-Received: by 2002:aa7:df11:: with SMTP id c17mr376090edy.317.1621262411180;
        Mon, 17 May 2021 07:40:11 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id ga12sm8558863ejc.13.2021.05.17.07.40.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 07:40:10 -0700 (PDT)
Date:   Mon, 17 May 2021 16:40:08 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, nikos.nikoleris@arm.com,
        andre.przywara@arm.com, eric.auger@redhat.com
Subject: Re: [PATCH kvm-unit-tests v3 4/8] arm/arm64: mmu: Stop mapping an
 assumed IO region
Message-ID: <20210517144008.b3byacluano7dtyk@gator.home>
References: <20210429164130.405198-1-drjones@redhat.com>
 <20210429164130.405198-5-drjones@redhat.com>
 <94288c5b-8894-5f8b-2477-6e45e087c4b5@arm.com>
 <0ca20ae5-d797-1c9f-9414-1d162d86f1b5@arm.com>
 <20210513171844.n3h3c7l5srhuriyy@gator>
 <20210513174313.j7ff6j5jhzvocnuh@gator>
 <b3d12a27-efda-86e0-b86c-c23e1371f473@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b3d12a27-efda-86e0-b86c-c23e1371f473@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 17, 2021 at 11:38:46AM +0100, Alexandru Elisei wrote:
> Hi Drew,
> 
> On 5/13/21 6:43 PM, Andrew Jones wrote:
> > On Thu, May 13, 2021 at 07:18:44PM +0200, Andrew Jones wrote:
> >> [..]
> >> Thanks Alex,
> >>
> >> I think a better fix is this untested one below, though. If you can test
> >> it out and confirm it also resolves the issue, then I'll add this patch
> >> to the series.
> >>
> >> Thanks,
> >> drew
> >>
> >>
> >> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> >> index 95c418c10eb4..deafd5695c33 100644
> >> --- a/arm/micro-bench.c
> >> +++ b/arm/micro-bench.c
> >> @@ -273,16 +273,22 @@ static void hvc_exec(void)
> >>         asm volatile("mov w0, #0x4b000000; hvc #0" ::: "w0");
> >>  }
> >>  
> >> -static void mmio_read_user_exec(void)
> >> +/*
> >> + * FIXME: Read device-id in virtio mmio here in order to
> >> + * force an exit to userspace. This address needs to be
> >> + * updated in the future if any relevant changes in QEMU
> >> + * test-dev are made.
> >> + */
> >> +static void *userspace_emulated_addr;
> >> +
> >> +static bool mmio_read_user_prep(void)
> >>  {
> >> -       /*
> >> -        * FIXME: Read device-id in virtio mmio here in order to
> >> -        * force an exit to userspace. This address needs to be
> >> -        * updated in the future if any relevant changes in QEMU
> >> -        * test-dev are made.
> >> -        */
> >> -       void *userspace_emulated_addr = (void*)0x0a000008;
> >> +       userspace_emulated_addr = (void*)ioremap(0x0a000008, 8);
> >> +       return true;
> >> +}
> >>  
> >> +static void mmio_read_user_exec(void)
> >> +{
> >>         readl(userspace_emulated_addr);
> >>  }
> >>  
> >> @@ -309,14 +315,14 @@ struct exit_test {
> >>  };
> >>  
> >>  static struct exit_test tests[] = {
> >> -       {"hvc",                 NULL,           hvc_exec,               NULL,           65536,          true},
> >> -       {"mmio_read_user",      NULL,           mmio_read_user_exec,    NULL,           65536,          true},
> >> -       {"mmio_read_vgic",      NULL,           mmio_read_vgic_exec,    NULL,           65536,          true},
> >> -       {"eoi",                 NULL,           eoi_exec,               NULL,           65536,          true},
> >> -       {"ipi",                 ipi_prep,       ipi_exec,               NULL,           65536,          true},
> >> -       {"ipi_hw",              ipi_hw_prep,    ipi_exec,               NULL,           65536,          true},
> >> -       {"lpi",                 lpi_prep,       lpi_exec,               NULL,           65536,          true},
> >> -       {"timer_10ms",          timer_prep,     timer_exec,             timer_post,     256,            true},
> >> +       {"hvc",                 NULL,                   hvc_exec,               NULL,           65536,          true},
> >> +       {"mmio_read_user",      mmio_read_user_prep,    mmio_read_user_exec,    NULL,           65536,          true},
> >> +       {"mmio_read_vgic",      NULL,                   mmio_read_vgic_exec,    NULL,           65536,          true},
> >> +       {"eoi",                 NULL,                   eoi_exec,               NULL,           65536,          true},
> >> +       {"ipi",                 ipi_prep,               ipi_exec,               NULL,           65536,          true},
> >> +       {"ipi_hw",              ipi_hw_prep,            ipi_exec,               NULL,           65536,          true},
> >> +       {"lpi",                 lpi_prep,               lpi_exec,               NULL,           65536,          true},
> >> +       {"timer_10ms",          timer_prep,             timer_exec,             timer_post,     256,            true},
> >>  };
> >>  
> >>  struct ns_time {
> >>
> > I still haven't tested it (beyond compiling), but I've tweaked this a bit.
> > You can see it here
> >
> > https://gitlab.com/rhdrjones/kvm-unit-tests/-/commit/71938030d160e021db3388037d0d407df17e8e5e
> >
> > The whole v4 of this series is here
> >
> > https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/efiprep
> 
> Had a look at the patch, looks good; in my suggestion I wrongly thought that readl
> reads a long (64 bits), not an uint32_t value:
> 
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> I also ran some tests on the v4 series from your repo.
> 
> Qemu TCG on x86 machine:
>     - arm compiled with arm-linux-gnu-gcc and arm-none-eabi-gcc
>     - arm64, 4k and 64k pages.
> 
> Odroid-c4:
>     - arm, both compilers, under kvmtool
>     - arm64, 4k, 16k and 64k pages under qemu KVM and kvmtool
> 
> Rockpro64:
>     - arm, both compilers, under kvmtool
>     - arm64, 4k and 64k pages, under qemu KVM and kvmtool.
> 
> The ITS migration tests I had to run manually on the rockpro64 (Odroid has a
> gicv2) because it looks like the run script wasn't detecting the prompt to start
> migration. I'm guessing something on my side, because I had issues with the
> migration tests before. Nonetheless, those tests ran just fine manually under qemu
> and kvmtool, so everything looks correct to me:
> 
> Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
>

Thanks Alex! I've added your tags, applied to arm/queue and sent the pull
request.

Thanks,
drew

