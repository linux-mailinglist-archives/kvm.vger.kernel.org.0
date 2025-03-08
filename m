Return-Path: <kvm+bounces-40499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C46C6A57F51
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 23:31:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 962803B03E1
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 22:31:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 221C51ADFE4;
	Sat,  8 Mar 2025 22:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rb02ZjY7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70BA152F88
	for <kvm@vger.kernel.org>; Sat,  8 Mar 2025 22:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741473104; cv=none; b=psbNLwYDToG9q2q0FKS4XTwR4Q9+yUrX9D30XuTsy0OtQYIka+i8qKioTekn/7axtHDrpzy0XHdkIsJQvHiYdeh5KTXskX+3fvCfxNLntuJR90lu9ZZz0Wr+1SW+OVs1C6zpH0vD+5roofWY9q4BFTyTsVP6KJzWT9FOAO3ov5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741473104; c=relaxed/simple;
	bh=tcPc/FN99wvCoe4iOt9eJJoI4oHF3R5I/JWgubThSxM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pi/GgmzpNW76l+77sOgld17+y6Av99oYbXjcGbYNrax8YaLnwN165oPTauFD8pqpcMeun9e7vvGAaYat0Eu0ccgcFuj4MS1BkrrX5xoUbEP0My2isCl5nopdaCXf0HK6e7tK9YFqo1OXD3mUXG1mTHTBONoIuvZJkfliG9O6Xx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rb02ZjY7; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-39130ee05b0so1678679f8f.3
        for <kvm@vger.kernel.org>; Sat, 08 Mar 2025 14:31:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741473100; x=1742077900; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B8Rlp4V6S1t7oJktJmT4N97/Nig9UKhKh3NovYXeL9Q=;
        b=rb02ZjY7yoc4h0boap81sDKKlN4zpyy8wKt7trPN05rM7pBbO/rT9l+kN5+dlwCS5A
         gbx64WEpy4WyBqwNiTUvgO/tyB7Lu4HwQ17qFPiuSpbAZIRpSaplPzNNuAKT594hh2uH
         S8EXmdNKMO4S750avdvMPZqNJbbrOgDFvEwZqPZSiwROGeJMT+A9helJtG3vYcxq2ZD7
         QVRelZwEjtF5Y4h1ODfO0BUpWGVQiSolt3fxEaS0yufx/Wxyq3SCdZCNkp+Dj/QnDkrL
         3cxsMyqRt10Giq+WoQaAHLOUxDkNH4Rv3oI9iHsAZgpECOsfiP6nF+Jn19JihaExpK+z
         OHJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741473100; x=1742077900;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B8Rlp4V6S1t7oJktJmT4N97/Nig9UKhKh3NovYXeL9Q=;
        b=DaZRbcOJwujzmGQIiQrzp8yL+8z5idbsY9kjCj9PR+hav6ez5RAEQncGpsJR/gV5Se
         r7Kv3kcE4I+jgHkP7m6bIgDE+UFxXznrqWjqm6LWbQzHfznj+chCoAmvI5GPlrKrXZ3n
         9NZDg1qgrrLkplEIttk9PBDWO2/M3dk1xk+ucaXRLRuAsZilS1sV0onbMjdVf9SmlCtk
         VFDSlyVI5filP/sLOmZwBRaEEjuP4xt6NlR0pmaHbgPraO7cARuv9JthS7SAUB7aJ1l4
         HY/UrMAvbb+VQZzO0vr286NiGC38bIJM0HMQhsoxeRokbmssrGVNnx7nN5Ug4yNgAdey
         kaeQ==
X-Forwarded-Encrypted: i=1; AJvYcCVIelG07M2MmyDu8wcSp/kC40Z5nkT8al7TRM2nkv9uVOvwS+6BgtIWDxInRgm5Mn4jJJw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPY2lF/O8b44fJqbWaMbEaw3iilG61cjK4R7Lp10vDqDL0Vo5I
	AygsyGt+nZh9lZKiWZk3X6HBfEXqKdY6sLCbPEZcqVnt+Hc+seCLAkBrlzZ7pqI=
X-Gm-Gg: ASbGncuKLmuarcd1oMIVl3Nh1iDFHHtU6dQ8XMS6NDWGboS1iMVmooHivmXrEyM6oV2
	j1KZntFDBgNdVgvQvZig+rWNKjaAJ5QzDH2IxPJSAKis1Mbqh1ePzNgpKtC0Lna9kKyrNnV0vS1
	M/R9BXBOyJa6RFxJBUkz8hiULznUDo2u35dRbpl13LbNJafiDihyQ321PMasXMe16ODkSL1xlGS
	XrLDCAULlRlGfq8xL1Isg42z6b3SczgKLU3u7BoIPCxZrgJfek52zdCZdyVmbEILiAYDCybk2et
	tAgRByPx5ib+6h9ud1chrloNmcP82tuhqNgNuy75utEVbJUbNaHTjzO+J/14PGxayM/wiam9Sjz
	LebJdk+rzrrTl
X-Google-Smtp-Source: AGHT+IEUyp5zyLW4DlZ5XMw4Rz/AB1UhVYoOBt2PmhgSGnUVYhH1w2Daq730E4oLE2cx+AX3j4HjzQ==
X-Received: by 2002:a05:6000:1549:b0:391:3291:e416 with SMTP id ffacd0b85a97d-39132d69868mr5082979f8f.19.1741473099723;
        Sat, 08 Mar 2025 14:31:39 -0800 (PST)
Received: from [192.168.69.199] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912bfdfba9sm10244185f8f.39.2025.03.08.14.31.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Mar 2025 14:31:38 -0800 (PST)
Message-ID: <9598e89e-b5a3-4abf-aca2-14652f541b34@linaro.org>
Date: Sat, 8 Mar 2025 23:31:36 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/14] hw/vfio: Build various objects once
To: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>, qemu-devel@nongnu.org
Cc: Alex Williamson <alex.williamson@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>, qemu-ppc@nongnu.org,
 Thomas Huth <thuth@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Tony Krowiak <akrowiak@linux.ibm.com>, Ilya Leoshkevich <iii@linux.ibm.com>,
 kvm@vger.kernel.org, Yi Liu <yi.l.liu@intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Zhenzhong Duan <zhenzhong.duan@intel.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>,
 Peter Xu <peterx@redhat.com>, Pierrick Bouvier
 <pierrick.bouvier@linaro.org>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Eric Auger <eric.auger@redhat.com>, qemu-s390x@nongnu.org,
 Jason Herne <jjherne@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 Nicholas Piggin <npiggin@gmail.com>, Halil Pasic <pasic@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>
References: <20250307180337.14811-1-philmd@linaro.org>
 <180f941a-74ce-41c0-999d-e0d4cef85c3d@redhat.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <180f941a-74ce-41c0-999d-e0d4cef85c3d@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/3/25 18:48, Cédric Le Goater wrote:
> Hello,
> 
> On 3/7/25 19:03, Philippe Mathieu-Daudé wrote:
>> By doing the following changes:
>> - Clean some headers up
>> - Replace compile-time CONFIG_KVM check by kvm_enabled()
>> - Replace compile-time CONFIG_IOMMUFD check by iommufd_builtin()
>> we can build less vfio objects.
>>
>> Philippe Mathieu-Daudé (14):
>>    hw/vfio/common: Include missing 'system/tcg.h' header
>>    hw/vfio/spapr: Do not include <linux/kvm.h>
>>    hw/vfio: Compile some common objects once
>>    hw/vfio: Compile more objects once
>>    hw/vfio: Compile iommufd.c once
>>    system: Declare qemu_[min/max]rampagesize() in 'system/hostmem.h'
>>    hw/vfio: Compile display.c once
>>    system/kvm: Expose kvm_irqchip_[add,remove]_change_notifier()
>>    hw/vfio/pci: Convert CONFIG_KVM check to runtime one
>>    system/iommufd: Introduce iommufd_builtin() helper
>>    hw/vfio/pci: Check CONFIG_IOMMUFD at runtime using iommufd_builtin()
>>    hw/vfio/ap: Check CONFIG_IOMMUFD at runtime using iommufd_builtin()
>>    hw/vfio/ccw: Check CONFIG_IOMMUFD at runtime using iommufd_builtin()
>>    hw/vfio/platform: Check CONFIG_IOMMUFD at runtime using
>>      iommufd_builtin
>>
>>   docs/devel/vfio-iommufd.rst  |  2 +-
>>   include/exec/ram_addr.h      |  3 --
>>   include/system/hostmem.h     |  3 ++
>>   include/system/iommufd.h     |  8 +++++
>>   include/system/kvm.h         |  8 ++---
>>   target/s390x/kvm/kvm_s390x.h |  2 +-
>>   accel/stubs/kvm-stub.c       | 12 ++++++++
>>   hw/ppc/spapr_caps.c          |  1 +
>>   hw/s390x/s390-virtio-ccw.c   |  1 +
>>   hw/vfio/ap.c                 | 27 ++++++++---------
>>   hw/vfio/ccw.c                | 27 ++++++++---------
>>   hw/vfio/common.c             |  1 +
>>   hw/vfio/iommufd.c            |  1 -
>>   hw/vfio/migration.c          |  1 -
>>   hw/vfio/pci.c                | 57 +++++++++++++++++-------------------
>>   hw/vfio/platform.c           | 25 ++++++++--------
>>   hw/vfio/spapr.c              |  4 +--
>>   hw/vfio/meson.build          | 33 ++++++++++++---------
>>   18 files changed, 117 insertions(+), 99 deletions(-)
>>
> 
> Patches 1-9 look ok and should be considered for the next PR if
> maintainers ack patch 6 and 8.

OK.

> vfio-amd-xgbe and vfio-calxeda-xgmac should be treated like
> vfio-platform, and since vfio-platform was designed for aarch64,
> these devices should not be available on arm, ppc, ppc64, riscv*,
> loongarch. That said, vfio-platform and devices being deprecated in
> the QEMU 10.0 cycle, we could just wait for the removal in QEMU 10.2.
> 
> How could we (simply) remove CONFIG_VFIO_IGD in hw/vfio/pci-quirks.c ?
> and compile this file only once.
> 
> The vfio-pci devices are available in nearly all targets when it
> only makes sense to have them in i386, x86_64, aarch64, ppc64,
> where they are supported, and also possibly in ppc (tcg) and arm
> (tcg) for historical reasons and just because they happen to work.
> ppc (tcg) doesn't support MSIs with vfio-pci devices so I don't
> think we care much.
> 
> Patches 10-14 are wrong because they remove the "iommufd" property of
> the "vfio-*" devices. We can't take these.

I suppose this is due to the wrong implementation of iommufd_builtin()
I mentioned in patch #10, which check instance but not class.

Thanks!

