Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE63528021C
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 17:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732462AbgJAPFN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 11:05:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23384 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732410AbgJAPFM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Oct 2020 11:05:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601564711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=ozwahTrh0gYx3QGzy7JSLi5eTBpyC4YR/nZOoeypAXs=;
        b=YjW1Y5E1xdNCoLPpKSbTiBDXg0rw8wSQTnY9ClKXm21cl20L3E58gHt+WljnaP9oZJrT4l
        j/35La0twY1j45UcprUO3eYXlqFSm/EQhPGoxbWggQQ1q+9kZF6hP9GmVbJLwKTVAyDBIq
        vd9qasTKb/aQOIooNXo/d2jWknqLLes=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-WnVSjcbVM7m45hufSmALMw-1; Thu, 01 Oct 2020 11:05:08 -0400
X-MC-Unique: WnVSjcbVM7m45hufSmALMw-1
Received: by mail-wr1-f69.google.com with SMTP id a12so2166958wrg.13
        for <kvm@vger.kernel.org>; Thu, 01 Oct 2020 08:05:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ozwahTrh0gYx3QGzy7JSLi5eTBpyC4YR/nZOoeypAXs=;
        b=bvwHkBPIX5PPKLk4l8fXQVfEXWRb8fKOGmQv56KEYgt+V8MAeBpuX/7xk7NQM6nOL6
         rm/kPHqeYcwG6wrYabBLG6nwK/QkTa+cRsjtGgIESBr1ix/XXWiLgUV/nu07NJPwPVuh
         K8EAQXDYI35Cy3IrpZZ5W0RsW1A08C7i8SiMNg/V9mf0LC6X29nT6liFQTMCZgSSIkae
         732P6TgVKUQV5Op0HAcDtkT0xm38m935k9vVaLbHkj6MBeEg1knv4pleGw6bK3MeuCxg
         tLDu4fCEwaVqaVuUOrMwSkijAAuQmr/gyX4tgiAy9Xc57kIkzbqy5sNCLgZK7I2oYRQC
         Q0Nw==
X-Gm-Message-State: AOAM5319XFUpr0RyHD8UlBl6a5wBYmiCiWOm+xTj9SncabXRTSfJGsID
        RFfrchIJg1Zxw/3kP+S8kS/BmKf1Pp3gGz4zBMv8sSh2LOMxThEAYozWlPqJuTXjdTaCi1M3caG
        6mJCeRGe21kga
X-Received: by 2002:adf:81e6:: with SMTP id 93mr9525005wra.412.1601564707468;
        Thu, 01 Oct 2020 08:05:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwgid+t7lqGezqNUTksKI7P6mItzlW552MPgJn+mX0UibjkumZtM1nAEiEq5eXf4Z3wfV67SQ==
X-Received: by 2002:adf:81e6:: with SMTP id 93mr9524971wra.412.1601564707106;
        Thu, 01 Oct 2020 08:05:07 -0700 (PDT)
Received: from [192.168.1.36] (74.red-83-53-161.dynamicip.rima-tde.net. [83.53.161.74])
        by smtp.gmail.com with ESMTPSA id x16sm9856874wrq.62.2020.10.01.08.05.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Oct 2020 08:05:06 -0700 (PDT)
Subject: Re: [PATCH v3 17/19] hw/arm: Automatically select the 'virt' machine
 on KVM
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
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
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
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
Message-ID: <36629bed-9b32-01a0-fdc2-831b10e4bad9@redhat.com>
Date:   Thu, 1 Oct 2020 17:05:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <8253ddd7-3149-17d9-1174-6474c4bde605@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/1/20 9:38 AM, Paolo Bonzini wrote:
> On 29/09/20 22:36, Philippe Mathieu-Daudé wrote:
>> Yes, the problem if I don't restrict to KVM, when
>> using the Xen accelerator odd things occur
>> (using configure --enable-xen --disable-tcg --disable-kvm):
>>
>> Compiling C object libqemu-i386-softmmu.fa.p/hw_cpu_a15mpcore.c.o
>> hw/cpu/a15mpcore.c:28:10: fatal error: kvm_arm.h: No such file or directory
>>
>> See
>> https://wiki.xenproject.org/wiki/Xen_ARM_with_Virtualization_Extensions#Use_of_qemu-system-i386_on_ARM
> 
> I don't understand.  Is Xen adding CONFIG_ARM_VIRT=y to
> default-configs/i386-softmmu.mak??

No, this is when using:

 config ARM_VIRT
     bool
+    default y

I had the understanding devices in hw/$BASEARCH would be only
included for $ARCH, but I was wrong, any arch kconfig-include
the devices of the other archs.

I tried the following diff which doesn't build because various
devices in *non*-archdep folders use arch-specific Kconfig values:

-- >8 --
diff --git a/meson.build b/meson.build
index 9ab5d514d7..cfe19d0007 100644
--- a/meson.build
+++ b/meson.build
@@ -575,6 +575,7 @@ foreach target : target_dirs
     if fs.is_file(target_kconfig)
       minikconf_input += [target_kconfig]
     endif
+    minikconf_input += 'hw' / config_target['TARGET_BASE_ARCH'] / 'Kconfig'
     config_devices_mak = configure_file(
       input: minikconf_input,
       output: config_devices_mak,
diff --git a/hw/Kconfig b/hw/Kconfig
index 4de1797ffd..64c120175a 100644
--- a/hw/Kconfig
+++ b/hw/Kconfig
@@ -41,29 +41,29 @@ source vfio/Kconfig
 source watchdog/Kconfig

 # arch Kconfig
-source arm/Kconfig
-source alpha/Kconfig
-source avr/Kconfig
-source cris/Kconfig
-source hppa/Kconfig
-source i386/Kconfig
-source lm32/Kconfig
-source m68k/Kconfig
-source microblaze/Kconfig
-source mips/Kconfig
-source moxie/Kconfig
-source nios2/Kconfig
-source openrisc/Kconfig
-source ppc/Kconfig
-source riscv/Kconfig
-source rx/Kconfig
-source s390x/Kconfig
-source sh4/Kconfig
-source sparc/Kconfig
-source sparc64/Kconfig
-source tricore/Kconfig
-source unicore32/Kconfig
-source xtensa/Kconfig

 # Symbols used by multiple targets
 config TEST_DEVICES
---

> 
> (By the way, there are duplicate Kconfig symbols between target/arm and
> hw/cpu, they could/should be removed from target/arm).

I'd rather define Kconfig entry where the model is, so in this case
keep them defined in hw/cpu/Kconfig and remove dup entries from
hw/arm/Kconfig (if Peter is OK with that).

> 
> Paolo
> 

