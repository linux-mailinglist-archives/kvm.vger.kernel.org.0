Return-Path: <kvm+bounces-40651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C97BA5967B
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 14:38:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BCBE716811F
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 13:38:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 694E222A4E4;
	Mon, 10 Mar 2025 13:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UA5sl2D9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2286227BB9
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 13:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741613921; cv=none; b=D5K1/ZS2oMzjsWmtuUfVRKwdkNAsVzYMVR6gUuFOZhayOBCllgHceAL7YOCflZ40PaizWZDBwevUt5z/lSfTVJUFgV21/153eIxcVaFMJLefzMdAl2BC7YkMSXhQRaUkueeZYVUWR+VKmjsyx5LJy1RRG5QOb1A+6gWCVRifIok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741613921; c=relaxed/simple;
	bh=gNoV67GnzVOt2F/z+eHLRA0jaS/FFQ+qBQgjo1qKkcI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D7MyzU0eBhTGvYIxqefGAbfuz+tSF7SG/OWxndJvzSp/i/XlWEEjmHNnUxlsxVYaTK8qf24k+EV88GSv14CW/YtZzaxOn19Z4EoRi+5tV+5rTCZvof+MKSJmYwlHsn8aMh0OEDhMV2ZLtGiVRekFbNg3uspBpLJKjRHc3qiiykk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UA5sl2D9; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-43bc63876f1so36173015e9.3
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 06:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741613918; x=1742218718; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fI8Ir2Zu1z7LkL/zkdFv81XeyawLXZhGTuauzkxQWC0=;
        b=UA5sl2D9D9uUWRItQlIYVaAJqsxxN5Dc1z6bhovSFRqBFdA/ky00gVg6dSTbYf2k+g
         lcP/5vSRyELlrQRrbs+Yu9MTf/fqz+ta1ZW+E8l7nmg5KvH7ATxNwD8XI70B8twPEVB9
         M4Zj+ArHN4q/wslC2O1njLXInudP/L+Cc50cgXbilSdw90jWAiBL4vgmEvf2RTO1jkjY
         kaeBizCHpJCWzxJMocrlawVlQZiC16oiP1lE2MjnyVNrnEtrrpywDMZJLsKzS5UvTs+q
         9JwXlewrro9bjItgN9nbzsIYJBNAyEVMriTnGGAeqv3amv/CedSeNvUyL+NO8m+ArtWc
         Ohnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741613918; x=1742218718;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fI8Ir2Zu1z7LkL/zkdFv81XeyawLXZhGTuauzkxQWC0=;
        b=Lg4gLVDLea+O5PIXInUHCjVg9UrjUGbPgmN0bCVqCt9zbuQNyug4XndERc/5+k/E/2
         U19HIa35veEUi8ms9aQF1nVR5EzDtxb7KG2e/jy0uPmO2FMv41oQ+FS9vofMXCwxH3gM
         OnEjCmjxltJXpRx4wukcor6OxghQxloijrMgDxDTmOmOwU8jT0LWw/QopKnaDfZ6G+I+
         H8vzsMukMGdySTUGNUifGMeauME4tcXjYUc77rKlzAsPqAC5131x9OZKJDonNB39dTHk
         vh/1lzFFMbGb5D6iozAssXu0XlVsfKE0+qBUtShu2ACzef/w6D7epBim8LxUa1Kg47N/
         nsJg==
X-Forwarded-Encrypted: i=1; AJvYcCWTwFVXFsMxpuD4kWazAn/h8DpDUZpVFHcRZqxfQ3aUpCacTNe4/J7tXb+tlrpHdHyJFpQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9rt7z4ZKPgiBUrw8B9z1urylPkC2PJNcJEeW7VGqfzcyngd5k
	lPGSHvE/s7eirbZTDHqc+FjJ2NA4Y2V7ge72p/7lNRwB/lfRK4jIm5nTmirPxyI=
X-Gm-Gg: ASbGncs4Nia9+m8mU2FcZGyxZbkbuMNvIX1dSLewc+32YVTh3Ig5995E2xsOD4Tj34M
	yobxOCN8bjGgM+oq1M0M1RBLsFQ3CCqXICJpmpZi8GVJ//XZCaThuQYi2ScasFGqri8dv4HecJk
	ztkXYQybds5tLAOuFAsimMPEeEXwF04DAuoWRNG/59NOvwWz/y6xWlVoOkcS9ux4laQJaokIIHg
	6AXd2qJEPS0BKCJCaRgyqU0L1zlbC4YU/U0qWfdXJTNqSD54crQihLSZ1R5Eu7/YrgYpno65r84
	n3xvQSLiZnG8cEyxdQhptJYLNjYf9zttRQPpu4ckHo2ev8RwDGRXLSQCks2bn51OtIibaMTcmJZ
	aQBo9ZUsdSrEskm1XHaOJUks=
X-Google-Smtp-Source: AGHT+IFI1n3NuoI/n8U8/SXHlifSn7tQ/FUgR7JfVMlIX6tnbG1hMXfpyjk+3Tr3iEzmpdh1YIRDsg==
X-Received: by 2002:a05:6000:402a:b0:391:2dea:c9a5 with SMTP id ffacd0b85a97d-39132d6b61cmr8799479f8f.20.1741613917931;
        Mon, 10 Mar 2025 06:38:37 -0700 (PDT)
Received: from [192.168.69.199] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c01cb82sm15420203f8f.51.2025.03.10.06.38.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Mar 2025 06:38:37 -0700 (PDT)
Message-ID: <f76f27e7-730e-4bd9-8a91-7b329aa1249f@linaro.org>
Date: Mon, 10 Mar 2025 14:38:35 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/21] hw/vfio: Build various objects once
To: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>, qemu-devel@nongnu.org
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
 <ef7dcee1-90fe-44be-aa14-6c016d98369f@redhat.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <ef7dcee1-90fe-44be-aa14-6c016d98369f@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/3/25 09:03, Cédric Le Goater wrote:
> On 3/9/25 00:08, Philippe Mathieu-Daudé wrote:
>> By doing the following changes:
>> - Clean some headers up
>> - Replace compile-time CONFIG_KVM check by kvm_enabled()
>> - Replace compile-time CONFIG_IOMMUFD check by iommufd_builtin()
>> we can build less vfio objects.
>>
>> Since v1:
>> - Added R-b tags
>> - Introduce type_is_registered()
>> - Split builtin check VS meson changes (rth)
>> - Consider IGD
>>
>> Philippe Mathieu-Daudé (21):
>>    hw/vfio/common: Include missing 'system/tcg.h' header
>>    hw/vfio/spapr: Do not include <linux/kvm.h>
>>    hw/vfio: Compile some common objects once
>>    hw/vfio: Compile more objects once
>>    hw/vfio: Compile iommufd.c once
>>    system: Declare qemu_[min/max]rampagesize() in 'system/hostmem.h'
>>    hw/vfio: Compile display.c once
>>    system/kvm: Expose kvm_irqchip_[add,remove]_change_notifier()
>>    hw/vfio/pci: Convert CONFIG_KVM check to runtime one
>>    qom: Introduce type_is_registered()
>>    hw/vfio/igd: Define TYPE_VFIO_PCI_IGD_LPC_BRIDGE
>>    hw/vfio/igd: Check CONFIG_VFIO_IGD at runtime using vfio_igd_builtin()
>>    hw/vfio/igd: Compile once
>>    system/iommufd: Introduce iommufd_builtin() helper
>>    hw/vfio/pci: Check CONFIG_IOMMUFD at runtime using iommufd_builtin()
>>    hw/vfio/pci: Compile once
>>    hw/vfio/ap: Check CONFIG_IOMMUFD at runtime using iommufd_builtin()
>>    hw/vfio/ccw: Check CONFIG_IOMMUFD at runtime using iommufd_builtin()
>>    hw/vfio/s390x: Compile AP and CCW once
>>    hw/vfio/platform: Check CONFIG_IOMMUFD at runtime using
>>      iommufd_builtin
>>    hw/vfio/platform: Compile once
>>
>>   docs/devel/vfio-iommufd.rst  |  2 +-
>>   hw/vfio/pci-quirks.h         |  8 +++++
>>   include/exec/ram_addr.h      |  3 --
>>   include/qom/object.h         |  8 +++++
>>   include/system/hostmem.h     |  3 ++
>>   include/system/iommufd.h     |  6 ++++
>>   include/system/kvm.h         |  8 ++---
>>   target/s390x/kvm/kvm_s390x.h |  2 +-
>>   hw/ppc/spapr_caps.c          |  1 +
>>   hw/s390x/s390-virtio-ccw.c   |  1 +
>>   hw/vfio/ap.c                 | 27 ++++++++---------
>>   hw/vfio/ccw.c                | 27 ++++++++---------
>>   hw/vfio/common.c             |  1 +
>>   hw/vfio/igd-stubs.c          | 20 +++++++++++++
>>   hw/vfio/igd.c                |  4 +--
>>   hw/vfio/iommufd.c            |  1 -
>>   hw/vfio/migration.c          |  1 -
>>   hw/vfio/pci-quirks.c         |  9 +++---
>>   hw/vfio/pci.c                | 57 +++++++++++++++++-------------------
>>   hw/vfio/platform.c           | 25 ++++++++--------
>>   hw/vfio/spapr.c              |  4 +--
>>   qom/object.c                 |  5 ++++
>>   hw/vfio/meson.build          | 35 +++++++++++++---------
>>   23 files changed, 152 insertions(+), 106 deletions(-)
>>   create mode 100644 hw/vfio/igd-stubs.c
>>
> 
> Patches 1-9 still look ok and could be merged through the vfio tree
> if maintainers ack patch 6 and 8.
> 
> The rest, depending on type_is_registered(), would be nice to have,
> but since there are conflicts and soft freeze is scheduled for
> tomorrow, we would probably have to wait QEMU 10.1.

No particular rush for the 10.0 release.

