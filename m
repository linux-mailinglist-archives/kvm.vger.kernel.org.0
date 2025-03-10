Return-Path: <kvm+bounces-40593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C92C5A58D94
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 09:03:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9935B165338
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 08:03:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E0F622331B;
	Mon, 10 Mar 2025 08:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cfkzDpgh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9E92206A4
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 08:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741593806; cv=none; b=Gl/WquUduYhLUEXB8oUd7/nLOVuJXGJ1J0n2YJiuUWJ33V1etbNAMeS/3rnoWqfXKxq4keRKs3UYPEmMPRZfBJxYx3au/4xyX9mw9GFud67gUrm/dyDmE3Qaimw3QagcYPP7JGs1XlEdyemMf4gJs73zKmi7VboaHkItcPtoXBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741593806; c=relaxed/simple;
	bh=4KSvtmmSbXWERR036+ANP5TJkPT4w+2F6XfHOxGP+BE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aSxDFyWNl151E9VNh8G6jwiQ+6bfQbKibv2a2ef97EKKPJxqa6anVqrGZgkmjxWPIhSIAprp3KZmqoh1akywyyQG+ZjCNDCv+Hg+ngl43p6AVSLPJuIkPH/vg8xgxCIgBBLmHqjyo3hEsjKALXmRiHwKhOd5T/25CPah76lMOM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cfkzDpgh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741593804;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xIVSdz2MinvUr+DLjL9xfvKnY1MvlYQJvFa060PTh6o=;
	b=cfkzDpgheqwlfns6y6ak/KLTXdq5wm4fa/RVEkk4qcIJrssdWN6zvS9ZMlBrnnCKmm0RUa
	XN/w3LCD6C8Cp1+Ye/PU/rweljVmIM/x3/c+xTcUcj1ljxQFJN3waK7mnxpgnctKz8YbDC
	+/bRrQJSeyTloYUbquIDxpzRkFh6lsw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-LZuR1OwrNv6ETG2iydv27A-1; Mon, 10 Mar 2025 04:03:22 -0400
X-MC-Unique: LZuR1OwrNv6ETG2iydv27A-1
X-Mimecast-MFC-AGG-ID: LZuR1OwrNv6ETG2iydv27A_1741593802
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3912aab7a36so1430220f8f.0
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 01:03:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741593802; x=1742198602;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xIVSdz2MinvUr+DLjL9xfvKnY1MvlYQJvFa060PTh6o=;
        b=NLtXAQ9J/TGkdrTNQ0nG73rZ4jpzw6aWlK5RTn6BTe6ODr5KQCR+cjDvnCoWIY7CAJ
         CU3GShYc3xB4jXuBvcuYbIFuKB6hKC4bIUuMD02lBEgwvgys/QFUc8UzHzW84EJIxti1
         N3M4QP4t7XXNKD0I65Foid1cx/cwzmQLH2CgamKRiYgg5dWA0il05+h+LI8pzwhOAd1R
         Upyz6/p1TXJctKnPYaTL4iulc00tvzhR6Clg4yj5La6CRYB6niOGRxUslI76BZzkvZ8a
         bX8lUTyri6ZhOFPfA6J37gIEKrIi8fTKeyismNsfMYxyRRAHf7G62Odwe7a0XMH/YOkl
         O22A==
X-Forwarded-Encrypted: i=1; AJvYcCVmK4eSoX8scV9wRvJXwYT/yBaa40pbXUMezt2Hgg2ivSbXsr9dtSZQ8QMtTABDm9wSbG8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/2yJIndt1Ld3mvv1vxLw2cUtDXOGL7/7ZmtM1gfja9YZonoeY
	M/uEk8yzadK9fip70WrzHB5uuVq3Qtz/ghhRu/1C7GNuSs27zZyYa+g+VclJPitao8KvKx+1sIZ
	y4UEVeo9L/Ytj2JLMKy5FIN1zoTbJfTXIFX1uZs++IY4lJlluuQ==
X-Gm-Gg: ASbGnct2vH1PmIqTuTrbxfOfeQVCzZv5pgSQNBpwEA7gYPcLOieB7/lbkulWAv1aLLv
	KcDV8+4J5cHfDuUMnoJuYBF8vTnU9k61HnS87EO3YRBvEgmT1BNyuEhNMQqnvus6M2uv5iHcGX8
	I0vVxTw43vAlmIJkwzeJN1RCbOjZaSZo8zJAmF6p4d35NrAsteUZEFGZOiefaYtbp8LbK7lQZIa
	25NYP4Tx0jTyze0ECPPOltlct4QjvSZr5LG1a1nJRnAFL3ckESkCST2fEPHgLsR/UqtqKbvuLj1
	ws/5C0rgkN+WaQHpLD26F3hqCPcP61LZIlqZIwuZwQ3F0/QT/sLSqw==
X-Received: by 2002:a05:6000:1448:b0:391:4608:e7be with SMTP id ffacd0b85a97d-3914608e99amr2208704f8f.14.1741593801713;
        Mon, 10 Mar 2025 01:03:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHJGh5VB+FGTLMkyV6wBPPMs9rZZ91esPMCh05KZGnJ2K/ObsJwO4lUzb7sUcfkZNMNS8FIjA==
X-Received: by 2002:a05:6000:1448:b0:391:4608:e7be with SMTP id ffacd0b85a97d-3914608e99amr2208659f8f.14.1741593801237;
        Mon, 10 Mar 2025 01:03:21 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:9db0:474c:ff43:9f5c? ([2a01:e0a:280:24f0:9db0:474c:ff43:9f5c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c1037bfsm14127380f8f.96.2025.03.10.01.03.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Mar 2025 01:03:20 -0700 (PDT)
Message-ID: <ef7dcee1-90fe-44be-aa14-6c016d98369f@redhat.com>
Date: Mon, 10 Mar 2025 09:03:19 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/21] hw/vfio: Build various objects once
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Yi Liu <yi.l.liu@intel.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Tony Krowiak <akrowiak@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>,
 Halil Pasic <pasic@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
 David Hildenbrand <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Tomita Moeko
 <tomitamoeko@gmail.com>, qemu-ppc@nongnu.org,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Eric Farman <farman@linux.ibm.com>, Eduardo Habkost <eduardo@habkost.net>,
 Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
 Zhenzhong Duan <zhenzhong.duan@intel.com>, qemu-s390x@nongnu.org,
 Eric Auger <eric.auger@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 Ilya Leoshkevich <iii@linux.ibm.com>, Jason Herne <jjherne@linux.ibm.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>
References: <20250308230917.18907-1-philmd@linaro.org>
Content-Language: en-US, fr
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <20250308230917.18907-1-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/9/25 00:08, Philippe Mathieu-Daudé wrote:
> By doing the following changes:
> - Clean some headers up
> - Replace compile-time CONFIG_KVM check by kvm_enabled()
> - Replace compile-time CONFIG_IOMMUFD check by iommufd_builtin()
> we can build less vfio objects.
> 
> Since v1:
> - Added R-b tags
> - Introduce type_is_registered()
> - Split builtin check VS meson changes (rth)
> - Consider IGD
> 
> Philippe Mathieu-Daudé (21):
>    hw/vfio/common: Include missing 'system/tcg.h' header
>    hw/vfio/spapr: Do not include <linux/kvm.h>
>    hw/vfio: Compile some common objects once
>    hw/vfio: Compile more objects once
>    hw/vfio: Compile iommufd.c once
>    system: Declare qemu_[min/max]rampagesize() in 'system/hostmem.h'
>    hw/vfio: Compile display.c once
>    system/kvm: Expose kvm_irqchip_[add,remove]_change_notifier()
>    hw/vfio/pci: Convert CONFIG_KVM check to runtime one
>    qom: Introduce type_is_registered()
>    hw/vfio/igd: Define TYPE_VFIO_PCI_IGD_LPC_BRIDGE
>    hw/vfio/igd: Check CONFIG_VFIO_IGD at runtime using vfio_igd_builtin()
>    hw/vfio/igd: Compile once
>    system/iommufd: Introduce iommufd_builtin() helper
>    hw/vfio/pci: Check CONFIG_IOMMUFD at runtime using iommufd_builtin()
>    hw/vfio/pci: Compile once
>    hw/vfio/ap: Check CONFIG_IOMMUFD at runtime using iommufd_builtin()
>    hw/vfio/ccw: Check CONFIG_IOMMUFD at runtime using iommufd_builtin()
>    hw/vfio/s390x: Compile AP and CCW once
>    hw/vfio/platform: Check CONFIG_IOMMUFD at runtime using
>      iommufd_builtin
>    hw/vfio/platform: Compile once
> 
>   docs/devel/vfio-iommufd.rst  |  2 +-
>   hw/vfio/pci-quirks.h         |  8 +++++
>   include/exec/ram_addr.h      |  3 --
>   include/qom/object.h         |  8 +++++
>   include/system/hostmem.h     |  3 ++
>   include/system/iommufd.h     |  6 ++++
>   include/system/kvm.h         |  8 ++---
>   target/s390x/kvm/kvm_s390x.h |  2 +-
>   hw/ppc/spapr_caps.c          |  1 +
>   hw/s390x/s390-virtio-ccw.c   |  1 +
>   hw/vfio/ap.c                 | 27 ++++++++---------
>   hw/vfio/ccw.c                | 27 ++++++++---------
>   hw/vfio/common.c             |  1 +
>   hw/vfio/igd-stubs.c          | 20 +++++++++++++
>   hw/vfio/igd.c                |  4 +--
>   hw/vfio/iommufd.c            |  1 -
>   hw/vfio/migration.c          |  1 -
>   hw/vfio/pci-quirks.c         |  9 +++---
>   hw/vfio/pci.c                | 57 +++++++++++++++++-------------------
>   hw/vfio/platform.c           | 25 ++++++++--------
>   hw/vfio/spapr.c              |  4 +--
>   qom/object.c                 |  5 ++++
>   hw/vfio/meson.build          | 35 +++++++++++++---------
>   23 files changed, 152 insertions(+), 106 deletions(-)
>   create mode 100644 hw/vfio/igd-stubs.c
> 

Patches 1-9 still look ok and could be merged through the vfio tree
if maintainers ack patch 6 and 8.

The rest, depending on type_is_registered(), would be nice to have,
but since there are conflicts and soft freeze is scheduled for
tomorrow, we would probably have to wait QEMU 10.1.

Thanks,

C.


