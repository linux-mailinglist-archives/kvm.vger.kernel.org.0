Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A40A264BA9E
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 18:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234825AbiLMRHv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 12:07:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235172AbiLMRHn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 12:07:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B019C
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 09:06:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670951214;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EOYSn0ABw/PTlascbUku2DcG8a5ddyAdOvMJyDDxsb0=;
        b=O1l6gSDdqjHzJIeBhM/gNnJ53SQGeVEVAVKik4/3jUPNZQyTWwimoOUUcSZMLOCZmWSZyt
        Aw/MAdRaS2SaKcS2SrghkL7P743mvxuDpc8bmgqjbplScBX2bc5vINlUeZBs4yIaaot45X
        s/Lz7CGkQjMH+mhTjAEnrxhtyEukJeA=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-655-F_4XVBaaOyWnUJMhwvG0YA-1; Tue, 13 Dec 2022 12:06:51 -0500
X-MC-Unique: F_4XVBaaOyWnUJMhwvG0YA-1
Received: by mail-ej1-f70.google.com with SMTP id dn11-20020a17090794cb00b007c14ea70afcso5923183ejc.0
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 09:06:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EOYSn0ABw/PTlascbUku2DcG8a5ddyAdOvMJyDDxsb0=;
        b=QUZh8M6OzKNY8EYhgB2vVcy0Hy6Z4MPqOrcgYV8eXwtVwiMWO7fUS4udxeBR1WJBUb
         6Ev1ZF7lln6zurY/fM3obF58kSWQTpo0OLRz5ZibiTF9mq9Y6IlOx+B9OdNZ3ACm9mjb
         d5y5um451KLH5FmuKWFnY4t8pcm8IxTXI94s/ZzzKKnpXp1MycBMUpn9yWbgJIB2/AYF
         Cz0H24FuT1TGCezCfjLPVdJ6vAV0HYr/od4UzAJyatXMCZVND/xsP+XkoKGui6UhljGQ
         NeBZGA6Sjit70gMDtUuiYhyPeFFpW6GPdhDznFMEWpk5N7O6xBosMi8iue4IGDKbQIi1
         11vg==
X-Gm-Message-State: ANoB5pkq5j2XCDYW3EQuqH8gd/47hn91z2KedJb/Ixx3T5706MGXdDF1
        +BJ7XPi3kiQ/9SYBfazwOCNsUkpo7UmPrBmFd2lxwzFSwOVVLltDdgGxAL3KZcF5YXy5n6OSHFS
        ezOQj/CqyGlrO
X-Received: by 2002:a17:906:8805:b0:7c1:3125:955f with SMTP id zh5-20020a170906880500b007c13125955fmr15800642ejb.65.1670951210024;
        Tue, 13 Dec 2022 09:06:50 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5dlhfqvH6MBKRYHOqv9AiDTlEqEMKNVVthP0BR1nci7rLMKfiH59/D15hJSmQ0o+mXEC48MA==
X-Received: by 2002:a17:906:8805:b0:7c1:3125:955f with SMTP id zh5-20020a170906880500b007c13125955fmr15800632ejb.65.1670951209855;
        Tue, 13 Dec 2022 09:06:49 -0800 (PST)
Received: from ovpn-194-169.brq.redhat.com (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id g1-20020aa7c841000000b004704658abebsm609741edt.54.2022.12.13.09.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 09:06:49 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, kernel test robot <lkp@intel.com>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [linux-stable-rc:linux-5.15.y 2855/9999]
 arch/x86/kvm/hyperv.c:2185:5: warning: stack frame size (1036) exceeds
 limit (1024) in 'kvm_hv_hypercall'
In-Reply-To: <202212122016.eqBzscLJ-lkp@intel.com>
References: <202212122016.eqBzscLJ-lkp@intel.com>
Date:   Tue, 13 Dec 2022 18:06:48 +0100
Message-ID: <87zgbr9qs7.fsf@ovpn-194-169.brq.redhat.com>
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
> FYI, the error/warning still remains.
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> head:   2b8b2c150867edf2f7c351b27e2ce18865b0a25a
> commit: cb188e07105f2216f5efbefac95df4b6ce266906 [2855/9999] KVM: x86: hyper-v: HVCALL_SEND_IPI_EX is an XMM fast hypercall
> config: i386-buildonly-randconfig-r003-20221212
> compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?id=cb188e07105f2216f5efbefac95df4b6ce266906
>         git remote add linux-stable-rc https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>         git fetch --no-tags linux-stable-rc linux-5.15.y
>         git checkout cb188e07105f2216f5efbefac95df4b6ce266906
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash arch/x86/kvm/
>
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
>>> arch/x86/kvm/hyperv.c:2185:5: warning: stack frame size (1036) exceeds limit (1024) in 'kvm_hv_hypercall' [-Wframe-larger-than]
>    int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>        ^
>    1 warning generated.
>

There's a 'fix' for this in kvm/next:

commit 7d5e88d301f84a7b64602dbe3640f288223095ea
Author: Vitaly Kuznetsov <vkuznets@redhat.com>
Date:   Tue Nov 1 15:53:56 2022 +0100

    KVM: x86: hyper-v: Use preallocated buffer in 'struct kvm_vcpu_hv' instead of on-stack 'sparse_banks'

but I'm unsure whether it's worth cherry-picking into stable@, I doubt
this is a real world issue (i386, clang, Windows guests,...).

-- 
Vitaly

