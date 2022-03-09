Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBE974D378A
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 18:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237033AbiCIRKg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 12:10:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236585AbiCIRK2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 12:10:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6E0CD1BE120
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 09:01:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646845282;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PmPxCROnkmuVdU5NYrU4XL6BIT6O1oBuXgVRzY2Lfe8=;
        b=UZpoyp0e+IfVAnUO4iFB0K3vcta2IWN6ho0nmnlxW2d4JRR5FznA+61352Wmmz8syuicdu
        FGG5Qq0aelTJf0DeFahqX34BsF+o4JYgjlTu9npZKnSkumD8n9ieaYcCcWRFu5WRlCGAD7
        +lfATO+BIHbYvChMXFWYVwk3p7IP4Ls=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665--S_wrmesNv6W1sqc1BS-xA-1; Wed, 09 Mar 2022 12:01:19 -0500
X-MC-Unique: -S_wrmesNv6W1sqc1BS-xA-1
Received: by mail-ej1-f70.google.com with SMTP id y5-20020a1709060a8500b006da9258a34cso1607906ejf.21
        for <kvm@vger.kernel.org>; Wed, 09 Mar 2022 09:01:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PmPxCROnkmuVdU5NYrU4XL6BIT6O1oBuXgVRzY2Lfe8=;
        b=JIas60wUk2xYp0kAFK9mr5dlsWZnQ7+Fl3/Zwg+px2MvyeWuMvVCznv6VDJu+e9ubI
         1mWhlkfAbCuh+CjHU+FrlIce4bdjBov7MupeiJURnH3dP0PVwtFRwGJjMQHVKD27tR12
         m1SX4JRQekUwl0Te/9NsVUwMHUhJoy051IzBaA8lfqvev4wQafPvSxlvAKXPMNFN/+jN
         BXcv9YA95w7PISIcOrP/rWF6X4ru2nH4qAu/S1DxdHQBVmu3omE9hwJuEcS0HMSRw4pF
         S8b7OdONg+liGZHqGSIIyv7S4RSwPUSshDCOMA8AvBKyjbcUJ2KorBdy21lAiDJBs60v
         OQbg==
X-Gm-Message-State: AOAM5300pplsktpVR1kWgpyEDniL/kJZp+7/yVCbxkBPXjUDeImu6DAj
        Ug+PG+6v/zxusoGfF8FURzz/EoxnnphniEl/tcj+3tUxUrhj0FLmEkeHSDRh13DbW13zcegsHkE
        MJ3oliCIlC4ZP
X-Received: by 2002:a50:e1ca:0:b0:413:b403:f8e6 with SMTP id m10-20020a50e1ca000000b00413b403f8e6mr409214edl.204.1646845278470;
        Wed, 09 Mar 2022 09:01:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyFQSO8dCiRl5i0qGqRd2XRMqjhdfaUGLmyzRWN2NSXaTriK9rlPzsdU/DvsRag1Pi36ygPNA==
X-Received: by 2002:a50:e1ca:0:b0:413:b403:f8e6 with SMTP id m10-20020a50e1ca000000b00413b403f8e6mr409182edl.204.1646845278203;
        Wed, 09 Mar 2022 09:01:18 -0800 (PST)
Received: from gator (cst-prg-78-140.cust.vodafone.cz. [46.135.78.140])
        by smtp.gmail.com with ESMTPSA id g13-20020a50bf4d000000b00410d407da2esm1079848edk.13.2022.03.09.09.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 09:01:17 -0800 (PST)
Date:   Wed, 9 Mar 2022 18:01:15 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH 1/2] arm: Change text base address for 32
 bit tests when running under kvmtool
Message-ID: <20220309170115.pthw4vnxuwqpjrfw@gator>
References: <20220309162117.56681-1-alexandru.elisei@arm.com>
 <20220309162117.56681-2-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220309162117.56681-2-alexandru.elisei@arm.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 09, 2022 at 04:21:16PM +0000, Alexandru Elisei wrote:
> The 32 bit tests do not have relocation support and rely on the build
> system to set the text base address to 0x4001_0000, which is the memory
> location where the test is placed by qemu. However, kvmtool loads a payload
> at a different address, 0x8000_8000, when loading a test with --kernel.
> When using --firmware, the default is 0x8000_0000, but that can be changed
> with the --firmware-address comand line option.
> 
> When 32 bit tests are configured to run under kvmtool, set the text base
> address to 0x8000_8000.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/Makefile.arm | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arm/Makefile.arm b/arm/Makefile.arm
> index 3a4cc6b26234..01fd4c7bb6e2 100644
> --- a/arm/Makefile.arm
> +++ b/arm/Makefile.arm
> @@ -14,7 +14,13 @@ CFLAGS += $(machine)
>  CFLAGS += -mcpu=$(PROCESSOR)
>  CFLAGS += -mno-unaligned-access
>  
> +ifeq ($(TARGET),qemu)
>  arch_LDFLAGS = -Ttext=40010000
> +else ifeq ($(TARGET),kvmtool)
> +arch_LDFLAGS = -Ttext=80008000
> +else
> +$(error Unknown target $(TARGET))
> +endif
>  
>  define arch_elf_check =
>  endef
> -- 
> 2.35.1
>

Applied to arm/queue,
https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/queue

Thanks,
drew

