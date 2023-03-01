Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89A576A7673
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 22:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjCAVzV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 16:55:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjCAVzU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 16:55:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F72E2F7B0
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 13:54:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677707672;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vZkr8nDyx5NdIY8rUX0qdQ7EJqXixGN16DtsL7K32jk=;
        b=SisaqXMxWo1+Zahb1mD3KVUfH3fJw12SCicW/Suu7fRgniCuvUUK8jGzzs+zIenDrv/1/Q
        DLRIYgPjUlvMsS1e5LHXTPQrc80ycU+DeuhZxmBV38wJ0e+oT4uWEc//o74BWoAtGpiJfS
        OaGdl5+a1BUUAqyk5w3zpFbEPky0G1I=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-99-swr3NpORNQ2EQWEqxyOgeg-1; Wed, 01 Mar 2023 16:54:31 -0500
X-MC-Unique: swr3NpORNQ2EQWEqxyOgeg-1
Received: by mail-wr1-f69.google.com with SMTP id g6-20020adfa486000000b002c55ef1ec94so2795875wrb.0
        for <kvm@vger.kernel.org>; Wed, 01 Mar 2023 13:54:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677707670;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vZkr8nDyx5NdIY8rUX0qdQ7EJqXixGN16DtsL7K32jk=;
        b=cz/pFP1bPihDwxKg/KdLaJ7+x51C4em4/alTHPmK9jWEZBW5DCPFfvtLGyJ0DoroMw
         hE+Ygxgfg2Ec1VF5odGszHGg81S6I5ZwjqK+EOYSU3UpARFSOaNC8rkNDMPGEoNQgyB6
         gklprzy6m9vNFQQnc9/iguVpXIOYaexWSM+EWnZ8AcE5uiD402V5gnGQEk+u/xPAkbaQ
         GfqIuv2wMtoZSvIdFQhk2WQ2qqDD9hVvcntPX9G4wnGv5Nf4Ic35TqyjvcKpPUBUKPrc
         CLxNxw6+gJ2/6GGf+jzatACy8S+iCM2LBLcpLmShDsgPUDfyKD2kgyAoJRtGrvWZisbD
         8B8w==
X-Gm-Message-State: AO0yUKUTn36Nvr5uqkEdfaEBZVS7OBKn8me7toCUaPcy0fVhLIjN/d8/
        N3IYygQLnfkq1oYyqsMEr0xLkewjhZR1+r8eFaNJPGPh1MZ7fFTMi0lvzyJtdz2MNXvIZmlF1oy
        7oL0+ECTneUUw
X-Received: by 2002:a05:600c:a42:b0:3e2:1f00:bff7 with SMTP id c2-20020a05600c0a4200b003e21f00bff7mr6308545wmq.12.1677707670135;
        Wed, 01 Mar 2023 13:54:30 -0800 (PST)
X-Google-Smtp-Source: AK7set8DKsfkguH/N7HOoJwYYzs64dHEczSt4kvr/TdYo3R9NnbcLLlUCwEh5DBRzQnJEWFAIyrnVQ==
X-Received: by 2002:a05:600c:a42:b0:3e2:1f00:bff7 with SMTP id c2-20020a05600c0a4200b003e21f00bff7mr6308528wmq.12.1677707669773;
        Wed, 01 Mar 2023 13:54:29 -0800 (PST)
Received: from redhat.com ([2.52.141.194])
        by smtp.gmail.com with ESMTPSA id bg12-20020a05600c3c8c00b003e8dc7a03basm820085wmb.41.2023.03.01.13.54.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 13:54:29 -0800 (PST)
Date:   Wed, 1 Mar 2023 16:54:25 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc:     qemu-devel@nongnu.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Sergio Lopez <slp@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org, Eduardo Habkost <eduardo@habkost.net>,
        qemu-ppc@nongnu.org, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Subject: Re: [PATCH 0/5] hw/timer/i8254: Un-inline and simplify IRQs
Message-ID: <20230301165402-mutt-send-email-mst@kernel.org>
References: <20230215174353.37097-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230215174353.37097-1-philmd@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 15, 2023 at 06:43:48PM +0100, Philippe Mathieu-Daudé wrote:
> i8254_pit_init() uses a odd pattern of "use this IRQ output
> line if non-NULL, otherwise use the ISA IRQ #number as output".
> 
> Rework as simply "Use this IRQ output".


Acked-by: Michael S. Tsirkin <mst@redhat.com>


Given it also affects KVM I will let Paolo merge this.

> Un-inline/rename/document functions.
> 
> Based-on: <20230215161641.32663-1-philmd@linaro.org>
>           "hw/ide: Untangle ISA/PCI abuses of ide_init_ioport" v2
> https://lore.kernel.org/qemu-devel/20230215161641.32663-1-philmd@linaro.org/
> 
> Philippe Mathieu-Daudé (5):
>   hw/timer/hpet: Include missing 'hw/qdev-properties.h' header
>   hw/timer/i8254: Factor i8254_pit_create() out and document
>   hw/i386/pc: Un-inline i8254_pit_init()
>   hw/timer/i8254: Really inline i8254_pit_init()
>   hw/i386/kvm: Factor i8254_pit_create_try_kvm() out
> 
>  hw/i386/kvm/i8254.c        | 18 ++++++++++++++
>  hw/i386/microvm.c          |  6 +----
>  hw/i386/pc.c               | 15 +++++-------
>  hw/isa/i82378.c            |  2 +-
>  hw/isa/piix4.c             |  4 ++--
>  hw/isa/vt82c686.c          |  2 +-
>  hw/mips/jazz.c             |  2 +-
>  hw/timer/hpet.c            |  1 +
>  hw/timer/i8254.c           | 16 +++++++++++++
>  include/hw/timer/i8254.h   | 48 +++++++++++++-------------------------
>  target/i386/kvm/kvm-stub.c |  6 +++++
>  11 files changed, 69 insertions(+), 51 deletions(-)
> 
> -- 
> 2.38.1

