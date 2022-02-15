Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 092F74B7081
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 17:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241004AbiBOPuz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 10:50:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240760AbiBOPux (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 10:50:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5069FE66
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 07:50:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644940242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K3jeeW7pxg14TP2ZOulAqNmRd4jmpA2Kcrd4ZpsN3LE=;
        b=U6WAP4JpSoiJHU7Wi7sOLN1CHYX7/XuAxm3qEtdp3OnCKuFhOor72WERwGNbz5VE6EMz4d
        0+EzHbv3NshFj/3u2Cj9ZWws/9o2mXBGuIGVaMbK2NdzFfnSgn0o5i/E2g6wmmnNDqF7qN
        zx8ZaCbiurmUE1su3+hS7LjJ9Cwstuc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-149-ULxTF3yxPdSX-OKi005pog-1; Tue, 15 Feb 2022 10:50:41 -0500
X-MC-Unique: ULxTF3yxPdSX-OKi005pog-1
Received: by mail-ed1-f70.google.com with SMTP id m4-20020a50cc04000000b0040edb9d147cso41641edi.15
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 07:50:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K3jeeW7pxg14TP2ZOulAqNmRd4jmpA2Kcrd4ZpsN3LE=;
        b=AoRDUdOyroDDDu8eTkKo3+X2LCC1x+zQKUmwGbh5yLGvSnoVeqvwkzcCQNlFU+kw06
         ibgaK4vZ2YdSoME9fCKeFq8aAKB/Q7VbcK027m9u+P4DanCf1peg4tkM/PKjWf+9pPD3
         lJ2VHYCdWw545lb0MlCTLj+bU7Oi8aLqUVkwEBM5Od+YbNJQKg29Z1vUv8u98v6M+KQB
         hnnArjGkkNaCRaQEQHxWeL73gf0TNB/5crLo9TeSwlSzJwKxy2sh3hUh7uciur4RHzUH
         iULCsaWAvelXmqTkRjrQGU3wZrSCLSf7H3r5jtPXhJDmTTCptTYLvhlOBqwyZ2DaJF9T
         iYkA==
X-Gm-Message-State: AOAM53198ToLAYnB/U3h6TtMIMRA4Y9hZStkOzayxad9f3D/+8FgpVWW
        kOdi9hdEfEEBIrzoS8aCwaUHa9O32TM7b7FSiiAK6yDeBSg3xpvAj8etdy23vg+KllWhSrlNmBX
        SyiCjcaqpckCo
X-Received: by 2002:a05:6402:2741:: with SMTP id z1mr4459150edd.193.1644940239920;
        Tue, 15 Feb 2022 07:50:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxrwVMuutX28T0oQ7vyLCx9kPt+VdGME0xZXXb+FrDrshsYXUpd34KFdwazrQIGvVFZ2O6iig==
X-Received: by 2002:a05:6402:2741:: with SMTP id z1mr4459132edd.193.1644940239655;
        Tue, 15 Feb 2022 07:50:39 -0800 (PST)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id 5sm2740398ejq.176.2022.02.15.07.50.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 07:50:39 -0800 (PST)
Date:   Tue, 15 Feb 2022 16:50:37 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Marc Zyngier <maz@kernel.org>, pbonzini@redhat.com,
        thuth@redhat.com, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] lib/devicetree: Support 64 bit addresses
 for the initrd
Message-ID: <20220215155037.7q5aivsuxu657ztp@gator>
References: <20220214120506.30617-1-alexandru.elisei@arm.com>
 <20220214135226.joxzj2tgg244wl6n@gator>
 <YgphzKLQLb5pMYoP@monolith.localdoman>
 <20220214142444.saeogrpgpx6kaamm@gator>
 <YgqBPSV+CMyzfNlv@monolith.localdoman>
 <87k0dx4c23.wl-maz@kernel.org>
 <20220215073212.fp5lh4gfxk7clwwc@gator>
 <Ygt7PbS6zW9H1By4@monolith.localdoman>
 <20220215125300.6b5ff3luxikc4jhd@gator>
 <Ygu1q6r4oalKzn0H@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ygu1q6r4oalKzn0H@monolith.localdoman>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 15, 2022 at 02:16:32PM +0000, Alexandru Elisei wrote:
> Hi Drew,
> 
> On Tue, Feb 15, 2022 at 01:53:00PM +0100, Andrew Jones wrote:
> > On Tue, Feb 15, 2022 at 10:07:16AM +0000, Alexandru Elisei wrote:
> > > 
> > > I've started working on the next iteration of the kvmtool test
> > > runner support series, I'll do my best to make sure kvmtool wll be able to run
> > > the tests when kvm-unit-tests has been configured with --arch=arm.
> > >
> > 
> > Excellent!
> > 
> > BTW, I went ahead an pushed a patch to misc/queue to improve the initrd
> > address stuff
> > 
> > https://gitlab.com/rhdrjones/kvm-unit-tests/-/commit/6f8f74ed2d9953830a3c74669f25439d9ad68dec
> > 
> > It may be necessary for you if kvmtool shares its fdt creation between
> > aarch64 and aarch32 guests, emitting 8 byte initrd addresses for both,
> > even though the aarch32 guest puts the fdt below 4G.
> 
> While trying your patch (it works, but with the caveat below), I remembered that
> kvmtool is not able to run kvm-unit-tests for arm. That's because the code is
> not relocatable (like it is for arm64) and the text address is hardcoded in the
> makefile.
> 
> In past, to run the arm tests with kvmtool, I was doing this change:
> 
> diff --git a/arm/Makefile.arm b/arm/Makefile.arm
> index 3a4cc6b26234..6c580b067413 100644
> --- a/arm/Makefile.arm
> +++ b/arm/Makefile.arm
> @@ -14,7 +14,7 @@ CFLAGS += $(machine)
>  CFLAGS += -mcpu=$(PROCESSOR)
>  CFLAGS += -mno-unaligned-access
>  
> -arch_LDFLAGS = -Ttext=40010000
> +arch_LDFLAGS = -Ttext=80008000
>  
>  define arch_elf_check =
>  endef
> 
> Any suggestions how to fix that? One way would be to change the LDFLAGS based on
> $TARGET. Another way would be to make the arm tests relocatable, I tried to do
> that in the past but I couldn't make any progress.

Ideally we'd eventually make it relocatable, but it's not worth moving
mountains, so I'm OK with the LDFLAGS approach.

> 
> Separate from that, I also tried to run the 32 bit arm tests with run_tests.sh.
> The runner uses qemu-system-arm (because $ARCH_NAME is arm in
> scripts/arch-run.bash::search_qemu_binary()), but uses kvm as the accelerator
> (because /dev/kvm exists in scrips/arch-run.bash::kvm_available()). This fails
> with the error:
> 
> qemu-system-arm: -accel kvm: invalid accelerator kvm
> 
> I don't think that's supposed to happen, as kvm_available() specifically returns
> true if $HOST = aarch64 and $ARCH = arm. Any suggestions?
> 

Ah, that's a kvm-unit-tests bug. Typically qemu-system-$ARCH_NAME is
correct and, with TCG, qemu-system-arm runs the arm built unit tests fine.
But, when KVM is enabled, the QEMU used should be qemu-system-$HOST.

I don't think we want to change search_qemu_binary(), though, as that
would require ACCEL being set first and may not apply to all
architectures. Probably the best thing to do is fix this up in arm/run

diff --git a/arm/run b/arm/run
index 2153bd320751..ff18def43403 100755
--- a/arm/run
+++ b/arm/run
@@ -13,6 +13,10 @@ processor="$PROCESSOR"
 ACCEL=$(get_qemu_accelerator) ||
        exit $?
 
+if [ "$ACCEL" = "kvm" ] && [ -z "$QEMU" ]; then
+       QEMU=qemu-system-$HOST
+fi
+
 qemu=$(search_qemu_binary) ||
        exit $?
 

Thanks,
drew

