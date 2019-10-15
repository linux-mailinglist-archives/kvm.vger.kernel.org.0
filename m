Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBDE6D79AD
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 17:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387418AbfJOPWF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 11:22:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42619 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387417AbfJOPWE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 11:22:04 -0400
Received: from mail-pf1-f197.google.com ([209.85.210.197])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <gpiccoli@canonical.com>)
        id 1iKOeA-0001Es-2g
        for kvm@vger.kernel.org; Tue, 15 Oct 2019 15:22:02 +0000
Received: by mail-pf1-f197.google.com with SMTP id r19so16211155pfh.7
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 08:22:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=4uWEMUtO+/0Vvy5QnKlN0NMPVmJvd5IxagN1D1K9RuM=;
        b=S3BQ5km1fZtMxDjVNapa6rGotM7+BiYeFD9AZcqrPjH3DfeXpwsckUdNzDSlRDq7YN
         oQ604vdRSeomk56ysH21+iijnEz7nFMh11qC2p7JwQTe6xK9ADKzLY26iCN1B+S9ZqnZ
         kPbtHa+8V8BAXNgZtCCLKHI+S8bOSGSOMgTsJob+mS4KPd83i9KHcr1w5D48ZEYHPZsI
         vK8LYwFqyHwHljtwfU8FRLw95ZKz0RpScVU2PzWjQBmPJ4wZP6dyBv4ZI6MK6rm5sWnf
         uReBmThtrJ2TopRk7FZr1x2PJ7uI49jhFZMD61qJ2+SudQZkBdJpjd0veRk0CvvmBjyn
         YRlQ==
X-Gm-Message-State: APjAAAUu7CFLDlpwokD9NUm3iOJ9YwlYS8atGLpupzZodC8g82oH3Q8H
        rLMkiTAtigTZPEBLJn7ZpozIJviqKxD+/ywlZsTRPItsFhzqKAx9IeT8jYqoT3PPzDQRMTLUNFb
        IgZhx2lL9eovp7vH1T2GcH5Xq/2dkAQ==
X-Received: by 2002:a63:3c41:: with SMTP id i1mr4452942pgn.287.1571152920614;
        Tue, 15 Oct 2019 08:22:00 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzqIwZ8/hi+1TI04wvVCUT6kOctE1TYvzNEHURTZj+QItUndJsJWTqG0o6Iq6T0rUfS9prSFw==
X-Received: by 2002:a63:3c41:: with SMTP id i1mr4452910pgn.287.1571152920254;
        Tue, 15 Oct 2019 08:22:00 -0700 (PDT)
Received: from [192.168.1.200] (201-92-249-168.dsl.telesp.net.br. [201.92.249.168])
        by smtp.gmail.com with ESMTPSA id r21sm28603670pfc.27.2019.10.15.08.21.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Oct 2019 08:21:59 -0700 (PDT)
Subject: Re: Advice on oops - memory trap on non-memory access instruction
 (invalid CR2?)
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     kvm@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-mm@kvack.org, platform-driver-x86@vger.kernel.org,
        x86@kernel.org, iommu@lists.linux-foundation.org,
        "Guilherme G. Piccoli" <kernel@gpiccoli.net>,
        gavin.guo@canonical.com, halves@canonical.com,
        ioanna-maria.alifieraki@canonical.com, jay.vosburgh@canonical.com,
        mfo@canonical.com
References: <66eeae28-bfd3-c7a0-011c-801981b74243@canonical.com>
 <alpine.DEB.2.21.1910141602270.2531@nanos.tec.linutronix.de>
From:   "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Openpgp: preference=signencrypt
Autocrypt: addr=gpiccoli@canonical.com; prefer-encrypt=mutual; keydata=
 mQENBFpVBxcBCADPNKmu2iNKLepiv8+Ssx7+fVR8lrL7cvakMNFPXsXk+f0Bgq9NazNKWJIn
 Qxpa1iEWTZcLS8ikjatHMECJJqWlt2YcjU5MGbH1mZh+bT3RxrJRhxONz5e5YILyNp7jX+Vh
 30rhj3J0vdrlIhPS8/bAt5tvTb3ceWEic9mWZMsosPavsKVcLIO6iZFlzXVu2WJ9cov8eQM/
 irIgzvmFEcRyiQ4K+XUhuA0ccGwgvoJv4/GWVPJFHfMX9+dat0Ev8HQEbN/mko/bUS4Wprdv
 7HR5tP9efSLucnsVzay0O6niZ61e5c97oUa9bdqHyApkCnGgKCpg7OZqLMM9Y3EcdMIJABEB
 AAG0LUd1aWxoZXJtZSBHLiBQaWNjb2xpIDxncGljY29saUBjYW5vbmljYWwuY29tPokBNwQT
 AQgAIQUCWmClvQIbAwULCQgHAgYVCAkKCwIEFgIDAQIeAQIXgAAKCRDOR5EF9K/7Gza3B/9d
 5yczvEwvlh6ksYq+juyuElLvNwMFuyMPsvMfP38UslU8S3lf+ETukN1S8XVdeq9yscwtsRW/
 4YoUwHinJGRovqy8gFlm3SAtjfdqysgJqUJwBmOtcsHkmvFXJmPPGVoH9rMCUr9s6VDPox8f
 q2W5M7XE9YpsfchS/0fMn+DenhQpV3W6pbLtuDvH/81GKrhxO8whSEkByZbbc+mqRhUSTdN3
 iMpRL0sULKPVYbVMbQEAnfJJ1LDkPqlTikAgt3peP7AaSpGs1e3pFzSEEW1VD2jIUmmDku0D
 LmTHRl4t9KpbU/H2/OPZkrm7809QovJGRAxjLLPcYOAP7DUeltveuQENBFpVBxcBCADbxD6J
 aNw/KgiSsbx5Sv8nNqO1ObTjhDR1wJw+02Bar9DGuFvx5/qs3ArSZkl8qX0X9Vhptk8rYnkn
 pfcrtPBYLoux8zmrGPA5vRgK2ItvSc0WN31YR/6nqnMfeC4CumFa/yLl26uzHJa5RYYQ47jg
 kZPehpc7IqEQ5IKy6cCKjgAkuvM1rDP1kWQ9noVhTUFr2SYVTT/WBHqUWorjhu57/OREo+Tl
 nxI1KrnmW0DbF52tYoHLt85dK10HQrV35OEFXuz0QPSNrYJT0CZHpUprkUxrupDgkM+2F5LI
 bIcaIQ4uDMWRyHpDbczQtmTke0x41AeIND3GUc+PQ4hWGp9XABEBAAGJAR8EGAEIAAkFAlpV
 BxcCGwwACgkQzkeRBfSv+xv1wwgAj39/45O3eHN5pK0XMyiRF4ihH9p1+8JVfBoSQw7AJ6oU
 1Hoa+sZnlag/l2GTjC8dfEGNoZd3aRxqfkTrpu2TcfT6jIAsxGjnu+fUCoRNZzmjvRziw3T8
 egSPz+GbNXrTXB8g/nc9mqHPPprOiVHDSK8aGoBqkQAPZDjUtRwVx112wtaQwArT2+bDbb/Y
 Yh6gTrYoRYHo6FuQl5YsHop/fmTahpTx11IMjuh6IJQ+lvdpdfYJ6hmAZ9kiVszDF6pGFVkY
 kHWtnE2Aa5qkxnA2HoFpqFifNWn5TyvJFpyqwVhVI8XYtXyVHub/WbXLWQwSJA4OHmqU8gDl
 X18zwLgdiQ==
Message-ID: <331f83c2-1d52-dfdb-1006-e910ff20c3a5@canonical.com>
Date:   Tue, 15 Oct 2019 12:21:45 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.1910141602270.2531@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/10/2019 11:10, Thomas Gleixner wrote:
> On Mon, 14 Oct 2019, Guilherme G. Piccoli wrote:
>> Modules linked in: <...>
>> CPU: 40 PID: 78274 Comm: qemu-system-x86 Tainted: P W  OE
> 
> Tainted: P     - Proprietary module loaded ...
> 
> Try again without that module

Thanks Thomas, for the prompt response. This is some ScaleIO stuff, I
guess it's part of customer setup, and I agree would be better to not
have this kind of module loaded. Anyway, the analysis of oops show a
quite odd situation that we'd like to at least have a strong clue before
saying the scaleio stuff is the culprit.

> 
> Tainted: W     - Warning issued before
> 
> Are you sure that that warning is harmless and unrelated?
> 

Sorry I didn't mention that before, the warn is:

[5946866.593060] WARNING: CPU: 42 PID: 173056 at
/build/linux-lts-xenial-80t3lB/linux-lts-xenial-4.4.0/arch/x86/events/intel/core.c:1868
intel_pmu_handle_irq+0x2d4/0x470()
[5946866.593061] perfevents: irq loop stuck!

It happened ~700 days before the oops (yeah, the uptime is quite large,
about 900 days when the oops happened heh).


>> 4.4.0-45-generic #66~14.04.1-Ubuntu
> 
> Does the same problem happen with a not so dead kernel? CR2 handling got
> quite some updates/fixes since then.

Unfortunately we don't have ways to test that for now, but your comment
is quite interesting - we can take a look in the CR2 fixes since v4.4.

But what do you think about having a #PF while the instruction pointed
in the oops Code section (and the RIP address) is not a memory-related insn?

Thanks,


Guilherme
> 
> Thanks,
> 
> 	tglx
> 
> 
