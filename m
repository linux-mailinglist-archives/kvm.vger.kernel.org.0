Return-Path: <kvm+bounces-40485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 86257A57C85
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 18:49:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA20716CA23
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 17:49:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D869D1EB5E0;
	Sat,  8 Mar 2025 17:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bx+9+zpq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128DB1EB5C8
	for <kvm@vger.kernel.org>; Sat,  8 Mar 2025 17:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741456140; cv=none; b=Fg8m0wwmJ7Lnw2eW/O6nCaU0oD19yrQnMJLu18fQnK3sbiHdQ0Q1x16SeG2NkApBNK8nMhZdvHTEwxCgEmKAHkFjAwPs8TB0rRVUxFW55pxH9s5zNX6F5eSDbo8DBZxNmTA7ciRpUtfbuRuL6MygsllH6SIdEKr04z9n9/JH68g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741456140; c=relaxed/simple;
	bh=sw4JBiPxxiGPYyXwzQzZIN6KgSeRvXf6EOFVsxuNxVU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z8bMvkagsueC3OUkELiumtHJvY/d7NsxTD1nZO0oHCMeHbJuTyjav2YQL77kNL+ADsQn0a7nk1brEXprBkijlq04KhV5d4cQNbJKUG4sDdDFYJzwnC8cupfznA2QYhXc3uqdMmSL7RP8h6euUErupefMlLxd19wSajvQuB2o65w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bx+9+zpq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741456137;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RqYX4GyNmjhCYSt2t3v4pMYzCcBUDdBoT2tDD/hWn/o=;
	b=Bx+9+zpqf4kKIHpof8hedpWG/q5x1hTRWRrAAxmo3uT3A0tfDGGXfdhSUAg+jztDc4f20D
	v6zWiUgWtFggAPY98qvYY+5hznyNUgnEI3noRhJ6Ee9HovVr/QxKUFpxiRgman5w/9ZTPR
	+zn/UNHiKq2aSdtISYXWNjabXn8EiJU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-77-v685PIcYNd6DaajipccE1Q-1; Sat, 08 Mar 2025 12:48:55 -0500
X-MC-Unique: v685PIcYNd6DaajipccE1Q-1
X-Mimecast-MFC-AGG-ID: v685PIcYNd6DaajipccE1Q_1741456135
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43943bd1409so19302585e9.3
        for <kvm@vger.kernel.org>; Sat, 08 Mar 2025 09:48:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741456134; x=1742060934;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RqYX4GyNmjhCYSt2t3v4pMYzCcBUDdBoT2tDD/hWn/o=;
        b=UB840OEtchm6baYGaBvHydntKEstHcyml/zRZ69Pe6qPiNW7OyBAzDFWS2U9H59L7T
         hV3RQ4ocKZbg9q2S3tsGAFIjdn4uXSZNx4QDVJmUjynovs4P1yK5pfMIx7E8WaCXFf5s
         9I6N3unXXcApZmOL5Xu3gIE4pI6v4Z1G/FFuV8m37Ez+L4bH84S93ayMxVavS627wV8R
         m4pkjPLrun+YJk8liFxXVECB0x7+byqoCaOztw8+8qnndcimRfusuTshtigy3QMuhv1H
         5fQHMhI8gtgVenjVY0LreEMNZu23wT9Gc1KFS6rT2jgS56fkKbI7Uwqosx1t0XrhZmq2
         g03A==
X-Forwarded-Encrypted: i=1; AJvYcCU5DD3cVn8QJtUKnCGFgkRc5NCFbY/l+lvhbhppEbLDuszHmxlGI8s5h859WqoQtamObj0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJpXfnQVcxObbdaS/FDnbC5/3mghE7mZoX/7Ze1XOSRajAsNNx
	ODxpud5Rgow3MWZOAUtD/0ZgQBPwyJEHXgm/r4QxvuBa4WPBsB6vWTsNYQySJAV48sspPaYI9Mx
	be4CEGLGnB3t672H+YcqbmJvlk5UXgkuj6THKXkC4GAt9cqEN0nfw1M2O/eLc
X-Gm-Gg: ASbGnctr0qLz+50pwBTJN8krsQcawVwuv/z9L2AOBiWxMinIq4CtSKgx0JC7eQwgSAM
	yJggyAApdt85ID5VPIY/bUQlut7eM6xEODK/bLZphPuaxtGIBrjj7aeBBkvZvMoWXVB/xY39whQ
	VzulX8crFUh7z2wWkoh/6kPF2P8pvTBDYkPzoIfmDNkiufcq5R1siSBOjCKkZwhJbKNXfUcyi18
	+jMh/TLQ9V8ODi2OjWWDyPn5I/srqza4iB6rlLV4JuomJzPsfytK0L03VutE9YX6KSGh+yf+JCC
	v2Scz/IUCGpDeIyRBR6iHxhtfMEfH6HXAOvQcSuHFI5f2I0s6TOWMw==
X-Received: by 2002:a05:600c:4f0f:b0:43b:c7bb:84ee with SMTP id 5b1f17b1804b1-43c5a5e57ebmr53116695e9.2.1741456134122;
        Sat, 08 Mar 2025 09:48:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFjGrJ7mPKbYtqVp1F3ZnSoOM/4HBQTxzrfeCxIKvLbfTulfgWruh/5wF80/W1zhVCEqFzuxQ==
X-Received: by 2002:a05:600c:4f0f:b0:43b:c7bb:84ee with SMTP id 5b1f17b1804b1-43c5a5e57ebmr53116435e9.2.1741456133658;
        Sat, 08 Mar 2025 09:48:53 -0800 (PST)
Received: from ?IPV6:2a01:e0a:280:24f0:9db0:474c:ff43:9f5c? ([2a01:e0a:280:24f0:9db0:474c:ff43:9f5c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c015d2bsm9202955f8f.43.2025.03.08.09.48.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Mar 2025 09:48:53 -0800 (PST)
Message-ID: <180f941a-74ce-41c0-999d-e0d4cef85c3d@redhat.com>
Date: Sat, 8 Mar 2025 18:48:51 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/14] hw/vfio: Build various objects once
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
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
Content-Language: en-US, fr
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <20250307180337.14811-1-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello,

On 3/7/25 19:03, Philippe Mathieu-Daudé wrote:
> By doing the following changes:
> - Clean some headers up
> - Replace compile-time CONFIG_KVM check by kvm_enabled()
> - Replace compile-time CONFIG_IOMMUFD check by iommufd_builtin()
> we can build less vfio objects.
> 
> Philippe Mathieu-Daudé (14):
>    hw/vfio/common: Include missing 'system/tcg.h' header
>    hw/vfio/spapr: Do not include <linux/kvm.h>
>    hw/vfio: Compile some common objects once
>    hw/vfio: Compile more objects once
>    hw/vfio: Compile iommufd.c once
>    system: Declare qemu_[min/max]rampagesize() in 'system/hostmem.h'
>    hw/vfio: Compile display.c once
>    system/kvm: Expose kvm_irqchip_[add,remove]_change_notifier()
>    hw/vfio/pci: Convert CONFIG_KVM check to runtime one
>    system/iommufd: Introduce iommufd_builtin() helper
>    hw/vfio/pci: Check CONFIG_IOMMUFD at runtime using iommufd_builtin()
>    hw/vfio/ap: Check CONFIG_IOMMUFD at runtime using iommufd_builtin()
>    hw/vfio/ccw: Check CONFIG_IOMMUFD at runtime using iommufd_builtin()
>    hw/vfio/platform: Check CONFIG_IOMMUFD at runtime using
>      iommufd_builtin
> 
>   docs/devel/vfio-iommufd.rst  |  2 +-
>   include/exec/ram_addr.h      |  3 --
>   include/system/hostmem.h     |  3 ++
>   include/system/iommufd.h     |  8 +++++
>   include/system/kvm.h         |  8 ++---
>   target/s390x/kvm/kvm_s390x.h |  2 +-
>   accel/stubs/kvm-stub.c       | 12 ++++++++
>   hw/ppc/spapr_caps.c          |  1 +
>   hw/s390x/s390-virtio-ccw.c   |  1 +
>   hw/vfio/ap.c                 | 27 ++++++++---------
>   hw/vfio/ccw.c                | 27 ++++++++---------
>   hw/vfio/common.c             |  1 +
>   hw/vfio/iommufd.c            |  1 -
>   hw/vfio/migration.c          |  1 -
>   hw/vfio/pci.c                | 57 +++++++++++++++++-------------------
>   hw/vfio/platform.c           | 25 ++++++++--------
>   hw/vfio/spapr.c              |  4 +--
>   hw/vfio/meson.build          | 33 ++++++++++++---------
>   18 files changed, 117 insertions(+), 99 deletions(-)
> 

Patches 1-9 look ok and should be considered for the next PR if
maintainers ack patch 6 and 8.


Some comments,

vfio-amd-xgbe and vfio-calxeda-xgmac should be treated like
vfio-platform, and since vfio-platform was designed for aarch64,
these devices should not be available on arm, ppc, ppc64, riscv*,
loongarch. That said, vfio-platform and devices being deprecated in
the QEMU 10.0 cycle, we could just wait for the removal in QEMU 10.2.

How could we (simply) remove CONFIG_VFIO_IGD in hw/vfio/pci-quirks.c ?
and compile this file only once.

The vfio-pci devices are available in nearly all targets when it
only makes sense to have them in i386, x86_64, aarch64, ppc64,
where they are supported, and also possibly in ppc (tcg) and arm
(tcg) for historical reasons and just because they happen to work.
ppc (tcg) doesn't support MSIs with vfio-pci devices so I don't
think we care much.

Patches 10-14 are wrong because they remove the "iommufd" property of
the "vfio-*" devices. We can't take these.

Thanks,

C.


