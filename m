Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7253283319
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 11:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725934AbgJEJXE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 05:23:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38341 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725887AbgJEJXD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Oct 2020 05:23:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601889781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=ugm8HlWBBQwIq6YqZ4bqZwMlHXIN2IqfB12xnKXSLh4=;
        b=Zr9+LqYH3m2q1IdW/ADuGp20Tk7QlIixE07mwiyHONqiy1dKr+GD29vIth2xPrTvCiVOBX
        nhhRxBed0uZ6lnORynUOpP/PTlZzMbnn1CSJO7GiBz/FWLv7hjIv/g24yUmD4gAQgDluWy
        mgiSFU5Fa2oh0mNV0DYWVO4KlemTDjQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-yGfYEv3kP3WGCk5YE7_AHw-1; Mon, 05 Oct 2020 05:22:58 -0400
X-MC-Unique: yGfYEv3kP3WGCk5YE7_AHw-1
Received: by mail-wm1-f69.google.com with SMTP id 73so1532876wma.5
        for <kvm@vger.kernel.org>; Mon, 05 Oct 2020 02:22:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ugm8HlWBBQwIq6YqZ4bqZwMlHXIN2IqfB12xnKXSLh4=;
        b=DQTFiHTWYWkyh0uC+uDVv6Qt52Po5f5e2l7FRBdqdwrn0ggHmIKAeKc5UaqKcVtR91
         83CpUPfMA2D0xSCHS0leTYLx8dqvYrR0rgTjcVQMW7XJBRkXD1v6g7Ffrp5Z204Fv1Jv
         vKli/xVA//w2rkjTqKdj9ttsxRZN0OH48s2UHF48aS2hMn8zSUVkWPD6Qb+cZLgUV9wM
         FVPeNfLVOij2yq7CVOvVn1OmAV01BBLdM5UTn2b8sDU7gcinlVFksMpC9M3eWNv5hcNf
         FfdjuZwoMD3TkMPCgLRHfrmL13DyoYF5J8hWlfMwYSt07i2rQ9INx6XhNRvTBRFn7yuG
         QDmA==
X-Gm-Message-State: AOAM533B2GIdsZKz60xClYb2ImYuyipQwDCzcporzpYvubqHGrZxoXzQ
        qAdNvFeCrwDnCxTiVGDlX393Yh4NrfRZE6S7V+hwPFI2bN9V0L+2CL0Apwvb3QSE3pLdmE4GcqS
        c8tW12Yvs6oGq
X-Received: by 2002:adf:dd46:: with SMTP id u6mr5188156wrm.295.1601889777064;
        Mon, 05 Oct 2020 02:22:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyrKIsZvC6VCHHIw4whcHXW+LhIfZVH91rvZ5S3upGP+1eW7tYsX6+I6wejZGnSuKWVujq9IA==
X-Received: by 2002:adf:dd46:: with SMTP id u6mr5188134wrm.295.1601889776884;
        Mon, 05 Oct 2020 02:22:56 -0700 (PDT)
Received: from [192.168.1.36] (106.red-83-59-162.dynamicip.rima-tde.net. [83.59.162.106])
        by smtp.gmail.com with ESMTPSA id a7sm11085392wmh.6.2020.10.05.02.22.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2020 02:22:56 -0700 (PDT)
Subject: Re: [PATCH v3 17/19] hw/arm: Automatically select the 'virt' machine
 on KVM
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm-devel <kvm@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
        qemu-arm <qemu-arm@nongnu.org>, Fam Zheng <fam@euphon.net>,
        Richard Henderson <richard.henderson@linaro.org>
References: <20200316160634.3386-1-philmd@redhat.com>
 <20200316160634.3386-18-philmd@redhat.com>
 <CAFEAcA-Rt__Du0TqqVFov4mNoBvC9hTt7t7e-3G45Eck4z94tQ@mail.gmail.com>
 <CAFEAcA-u53dVdv8EJdeeOWxw+SfPJueTq7M6g0vBF5XM2Go4zw@mail.gmail.com>
 <c7d07e18-57dd-7b55-f3dc-283c9d13e4b5@redhat.com>
 <8253ddd7-3149-17d9-1174-6474c4bde605@redhat.com>
 <36629bed-9b32-01a0-fdc2-831b10e4bad9@redhat.com>
Autocrypt: addr=philmd@redhat.com; keydata=
 mQINBDXML8YBEADXCtUkDBKQvNsQA7sDpw6YLE/1tKHwm24A1au9Hfy/OFmkpzo+MD+dYc+7
 bvnqWAeGweq2SDq8zbzFZ1gJBd6+e5v1a/UrTxvwBk51yEkadrpRbi+r2bDpTJwXc/uEtYAB
 GvsTZMtiQVA4kRID1KCdgLa3zztPLCj5H1VZhqZsiGvXa/nMIlhvacRXdbgllPPJ72cLUkXf
 z1Zu4AkEKpccZaJspmLWGSzGu6UTZ7UfVeR2Hcc2KI9oZB1qthmZ1+PZyGZ/Dy+z+zklC0xl
 XIpQPmnfy9+/1hj1LzJ+pe3HzEodtlVA+rdttSvA6nmHKIt8Ul6b/h1DFTmUT1lN1WbAGxmg
 CH1O26cz5nTrzdjoqC/b8PpZiT0kO5MKKgiu5S4PRIxW2+RA4H9nq7nztNZ1Y39bDpzwE5Sp
 bDHzd5owmLxMLZAINtCtQuRbSOcMjZlg4zohA9TQP9krGIk+qTR+H4CV22sWldSkVtsoTaA2
 qNeSJhfHQY0TyQvFbqRsSNIe2gTDzzEQ8itsmdHHE/yzhcCVvlUzXhAT6pIN0OT+cdsTTfif
 MIcDboys92auTuJ7U+4jWF1+WUaJ8gDL69ThAsu7mGDBbm80P3vvUZ4fQM14NkxOnuGRrJxO
 qjWNJ2ZUxgyHAh5TCxMLKWZoL5hpnvx3dF3Ti9HW2dsUUWICSQARAQABtDJQaGlsaXBwZSBN
 YXRoaWV1LURhdWTDqSAoUGhpbCkgPHBoaWxtZEByZWRoYXQuY29tPokCVQQTAQgAPwIbDwYL
 CQgHAwIGFQgCCQoLBBYCAwECHgECF4AWIQSJweePYB7obIZ0lcuio/1u3q3A3gUCXsfWwAUJ
 KtymWgAKCRCio/1u3q3A3ircD/9Vjh3aFNJ3uF3hddeoFg1H038wZr/xi8/rX27M1Vj2j9VH
 0B8Olp4KUQw/hyO6kUxqkoojmzRpmzvlpZ0cUiZJo2bQIWnvScyHxFCv33kHe+YEIqoJlaQc
 JfKYlbCoubz+02E2A6bFD9+BvCY0LBbEj5POwyKGiDMjHKCGuzSuDRbCn0Mz4kCa7nFMF5Jv
 piC+JemRdiBd6102ThqgIsyGEBXuf1sy0QIVyXgaqr9O2b/0VoXpQId7yY7OJuYYxs7kQoXI
 6WzSMpmuXGkmfxOgbc/L6YbzB0JOriX0iRClxu4dEUg8Bs2pNnr6huY2Ft+qb41RzCJvvMyu
 gS32LfN0bTZ6Qm2A8ayMtUQgnwZDSO23OKgQWZVglGliY3ezHZ6lVwC24Vjkmq/2yBSLakZE
 6DZUjZzCW1nvtRK05ebyK6tofRsx8xB8pL/kcBb9nCuh70aLR+5cmE41X4O+MVJbwfP5s/RW
 9BFSL3qgXuXso/3XuWTQjJJGgKhB6xXjMmb1J4q/h5IuVV4juv1Fem9sfmyrh+Wi5V1IzKI7
 RPJ3KVb937eBgSENk53P0gUorwzUcO+ASEo3Z1cBKkJSPigDbeEjVfXQMzNt0oDRzpQqH2vp
 apo2jHnidWt8BsckuWZpxcZ9+/9obQ55DyVQHGiTN39hkETy3Emdnz1JVHTU0Q==
Message-ID: <f3b931f5-c785-1d98-edd1-e5fcc91ff0ce@redhat.com>
Date:   Mon, 5 Oct 2020 11:22:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <36629bed-9b32-01a0-fdc2-831b10e4bad9@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/1/20 5:05 PM, Philippe Mathieu-Daudé wrote:
> On 10/1/20 9:38 AM, Paolo Bonzini wrote:
>> On 29/09/20 22:36, Philippe Mathieu-Daudé wrote:
>>> Yes, the problem if I don't restrict to KVM, when
>>> using the Xen accelerator odd things occur
>>> (using configure --enable-xen --disable-tcg --disable-kvm):
>>>
>>> Compiling C object libqemu-i386-softmmu.fa.p/hw_cpu_a15mpcore.c.o
>>> hw/cpu/a15mpcore.c:28:10: fatal error: kvm_arm.h: No such file or directory
>>>
>>> See
>>> https://wiki.xenproject.org/wiki/Xen_ARM_with_Virtualization_Extensions#Use_of_qemu-system-i386_on_ARM
>>
>> I don't understand.  Is Xen adding CONFIG_ARM_VIRT=y to
>> default-configs/i386-softmmu.mak??
> 
> No, this is when using:
> 
>  config ARM_VIRT
>      bool
> +    default y
> 
> I had the understanding devices in hw/$BASEARCH would be only
> included for $ARCH, but I was wrong, any arch kconfig-include
> the devices of the other archs.
> 
> I tried the following diff which doesn't build because various
> devices in *non*-archdep folders use arch-specific Kconfig values:
> 
> -- >8 --
> diff --git a/meson.build b/meson.build
> index 9ab5d514d7..cfe19d0007 100644
> --- a/meson.build
> +++ b/meson.build
> @@ -575,6 +575,7 @@ foreach target : target_dirs
>      if fs.is_file(target_kconfig)
>        minikconf_input += [target_kconfig]
>      endif
> +    minikconf_input += 'hw' / config_target['TARGET_BASE_ARCH'] / 'Kconfig'
>      config_devices_mak = configure_file(
>        input: minikconf_input,
>        output: config_devices_mak,
> diff --git a/hw/Kconfig b/hw/Kconfig
> index 4de1797ffd..64c120175a 100644
> --- a/hw/Kconfig
> +++ b/hw/Kconfig
> @@ -41,29 +41,29 @@ source vfio/Kconfig
>  source watchdog/Kconfig
> 
>  # arch Kconfig
> -source arm/Kconfig
> -source alpha/Kconfig
> -source avr/Kconfig
> -source cris/Kconfig
> -source hppa/Kconfig
> -source i386/Kconfig
> -source lm32/Kconfig
> -source m68k/Kconfig
> -source microblaze/Kconfig
> -source mips/Kconfig
> -source moxie/Kconfig
> -source nios2/Kconfig
> -source openrisc/Kconfig
> -source ppc/Kconfig
> -source riscv/Kconfig
> -source rx/Kconfig
> -source s390x/Kconfig
> -source sh4/Kconfig
> -source sparc/Kconfig
> -source sparc64/Kconfig
> -source tricore/Kconfig
> -source unicore32/Kconfig
> -source xtensa/Kconfig
> 
>  # Symbols used by multiple targets
>  config TEST_DEVICES
> ---

List of arch-indep Kconfig using arch-defined selectors:

hw/acpi/Kconfig:42:    depends on PC
hw/intc/Kconfig:31:    depends on ARM_GIC && KVM
hw/intc/Kconfig:36:    depends on OPENPIC && KVM
hw/intc/Kconfig:40:    depends on POWERNV || PSERIES
hw/intc/Kconfig:49:    depends on XICS && KVM
hw/intc/Kconfig:60:    depends on S390_FLIC && KVM
hw/mem/Kconfig:11:    depends on (PC || PSERIES || ARM_VIRT)
hw/pci-bridge/Kconfig:8:    default y if Q35
hw/timer/Kconfig:14:    default y if PC
hw/tpm/Kconfig:18:    depends on TPM && PC
hw/tpm/Kconfig:24:    depends on TPM && PSERIES
hw/vfio/Kconfig:16:    depends on LINUX && S390_CCW_VIRTIO
hw/vfio/Kconfig:38:    depends on LINUX && S390_CCW_VIRTIO

