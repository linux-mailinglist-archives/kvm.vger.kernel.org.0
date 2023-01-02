Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF07C65AE87
	for <lists+kvm@lfdr.de>; Mon,  2 Jan 2023 10:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbjABJD4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Jan 2023 04:03:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjABJDy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Jan 2023 04:03:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE795280
        for <kvm@vger.kernel.org>; Mon,  2 Jan 2023 01:03:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672650184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Wb1+xDzO2OJICTmTcLvXLbzqWQzlOKX7kH0t48LZ9nw=;
        b=Da+gVFgARCqhxfn8/i8dycZGrLTHLedJ8glh2xHu+WM0JZOIn1acjXacBWe1J9TW1drZEf
        1+N36TVtMiwKruRbmFtGyi8GvxKa37VrYdSgbTLJiXGo1svlXGRXSYQ7ff57gKZMoCDfug
        DDOolpZxu/MM0RDMjV70WpiIITUsqJs=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-99-qyBHKe-tNcy_tPwVcjRjdQ-1; Mon, 02 Jan 2023 04:03:03 -0500
X-MC-Unique: qyBHKe-tNcy_tPwVcjRjdQ-1
Received: by mail-ej1-f69.google.com with SMTP id qb2-20020a1709077e8200b00842b790008fso17370510ejc.21
        for <kvm@vger.kernel.org>; Mon, 02 Jan 2023 01:03:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wb1+xDzO2OJICTmTcLvXLbzqWQzlOKX7kH0t48LZ9nw=;
        b=EOjdHbWZvSbQoopMapoDCpWfXcCL505gdogPGuLctnjGGrwFNOym15hjet/Iy90FlB
         jYjaYZ8CibSGGdbcEeEeFpKFh20RBFseL9f2bSZ+BvaLUyUO7f26rtnzOqO14u2fBhTI
         uQny8qxt8iaJFXpKDmjkbU/aV1grZlBXC/R6EnxAVNenoJGtu2ZQKixbz6wYrHeMGs/+
         7kxSJ5ZiKtBZYMsl/07LqiOOwepYpyCRoxNsl6edY11NRUg05Ayvtc6RzwoTWpV2YKnc
         Xa2nRldoMj3IIp4efE8E10J6PxX66IeYB4PUVa0z6oIUzunUE4/YheeqbKz+ImKD0c9g
         OWFQ==
X-Gm-Message-State: AFqh2krV5BK1gHo9qRn+mMQadnGpjeS12HOfHAnfyFWCkQTNKd/fZRU3
        DTcymTZl3lxb9EsKMBmg+sx8XrdNPugCdt1j0FOI95XzLTJaaWTC83lVcTvAWbK3rWi+kO8jHjk
        JmIzzNxh2Xr0/
X-Received: by 2002:a17:907:6d12:b0:7c1:79f5:9545 with SMTP id sa18-20020a1709076d1200b007c179f59545mr48631499ejc.42.1672650182515;
        Mon, 02 Jan 2023 01:03:02 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvDLPZVroDKNX4cBj7VAjVWNTi2t2B19QGOtb/AWnwmaUyDBdy1Fi3DVGVoJhGS5zpV9MOYgA==
X-Received: by 2002:a17:907:6d12:b0:7c1:79f5:9545 with SMTP id sa18-20020a1709076d1200b007c179f59545mr48631487ejc.42.1672650182353;
        Mon, 02 Jan 2023 01:03:02 -0800 (PST)
Received: from ovpn-193-222.brq.redhat.com (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id jg34-20020a170907972200b0084cb8589523sm2360718ejc.139.2023.01.02.01.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 01:03:01 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kernel test robot <lkp@intel.com>
Cc:     oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [kvm:queue 65/153] arch/x86/kvm/cpuid.c:704:9: error: implicit
 declaration of function 'kvm_cpu_cap_init_scattered'; did you mean
 'kvm_cpu_cap_init_kvm_defined'?
In-Reply-To: <202212272221.bsAakB8X-lkp@intel.com>
References: <202212272221.bsAakB8X-lkp@intel.com>
Date:   Mon, 02 Jan 2023 10:03:00 +0100
Message-ID: <87k025gvgb.fsf@ovpn-193-222.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kernel test robot <lkp@intel.com> writes:

> Hi Vitaly,
>
> FYI, the error/warning was bisected to this commit, please ignore it if it's irrelevant.
>
> tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
> head:   d3f8290e4d039d9970dabd34bd9e6b0a97c35ecc
> commit: 42b76c1ae40b89716c7a804cb575a4b52eb4e12f [65/153] KVM: x86: Add a KVM-only leaf for CPUID_8000_0007_EDX
> config: x86_64-rhel-8.3-func
> compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
> reproduce (this is a W=1 build):
>         # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=42b76c1ae40b89716c7a804cb575a4b52eb4e12f
>         git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
>         git fetch --no-tags kvm queue
>         git checkout 42b76c1ae40b89716c7a804cb575a4b52eb4e12f
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         make W=1 O=build_dir ARCH=x86_64 olddefconfig
>         make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash arch/x86/kvm/
>
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    arch/x86/kvm/cpuid.c: In function 'kvm_set_cpu_caps':
>>> arch/x86/kvm/cpuid.c:704:9: error: implicit declaration of function 'kvm_cpu_cap_init_scattered'; did you mean 'kvm_cpu_cap_init_kvm_defined'? [-Werror=implicit-function-declaration]
>      704 |         kvm_cpu_cap_init_scattered(CPUID_8000_0007_EDX,
>          |         ^~~~~~~~~~~~~~~~~~~~~~~~~~
>          |         kvm_cpu_cap_init_kvm_defined
>    cc1: some warnings being treated as errors

This seems to be fixed in the current kvm/queue;
'kvm_cpu_cap_init_scattered()' is now called
'kvm_cpu_cap_init_kvm_defined()'.

-- 
Vitaly

