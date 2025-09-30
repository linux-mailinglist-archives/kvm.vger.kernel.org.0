Return-Path: <kvm+bounces-59095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A4AC3BABD98
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 09:39:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D0E917A13DA
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 07:37:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3230C24C068;
	Tue, 30 Sep 2025 07:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="durinMor"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680171DD0EF
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 07:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759217935; cv=none; b=SiChfVhvFwbShDiBGAqQBftNfuf4hcYUo1vhH09pcZ2gr1yd6CI4l0b5mSC12wtZ5w43/PV5fd/1ZwO3iUeRG9ipUeQ8WQxAqL0k1/mPzMoifdUpPDFer+zrwVIWIdxWyAlmZ2GXKtaTmVxUsItTFKpwlmz+uo1FobHIotY1o7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759217935; c=relaxed/simple;
	bh=JzsPaylpPSomY6B3Pzvtyud5ATxcqhQ3ZeLbetsT6Uc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hun8EdyWjpfEnuaZmvffxocVprXn5NwlS3ZlNEDLygWweOW93m8iD0piTiAaP6U7q/qhNC9FxfDtAmLa6g8r0fBqBzCBW9Z09mDmuerqrdCCX7ecyN41wnUcWbVoIWbSQqBq9PBFHJOeCdtRO0E36n8rtC7ke0D53EYUNwEsEhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=durinMor; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-41174604d88so2840469f8f.2
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 00:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759217932; x=1759822732; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qE2E68kg55lkWKGNUPUbXEU5stTPqSQmthsm27d4faI=;
        b=durinMor7mcV+I2Q+Ulaon8wUHdKeky83CSI1x8QIPEbvRMmELKPvtgMyCndJz625h
         Lt+Fs45gV2PezRkmmvZu93NelEUFUHw46BNp6yh1CpFzCIMjEGoR7Iznu7Yw/TN5IS5y
         wSHy5Dp+en4Nx947nQ+scVvQVgVjYvjSejVq7TlewasiOzNBdzG9iXLo+eyY5M1J2AE7
         Psa/Evs6kDKgLcnhtP3O/9RCU4H+BNXvvtSGFTBBmhDdn0Ns824A29e/V7ZXmIv7TlwL
         unppyT2p+voOkm/JTCBq4o8plrRhd8Dd+vdT/KkKJhSCsvzA0yuj7rupbLLVxJDY1zZx
         qjww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759217932; x=1759822732;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qE2E68kg55lkWKGNUPUbXEU5stTPqSQmthsm27d4faI=;
        b=Oxj3muYdRtFa0qfE/AAJ8VQKXqVDxCg/P/jOHdgpWDJwXcIF+QjfoVJR/Xx4znYxUX
         IP5yMQocxugFxypZUMq4Yujk7Ja9aOUwClOZAvpcLoHzCH7DarYF1LtfjX45b+CUtf/s
         ADXkI/muNBeqADWydZZheGQ91t3GWHd5nS5fDBFDsl601DD8dq4/C0uc1GqkZnxJFKOY
         cbTWmEsW25hyKTbztvNwppba43dGuRIy4n6sZJNiNtMA4nywHNR4CXme9pcyr3C7ovt8
         OHbT2yXOG//bG5LKddPfwXnjheuxubHXd0oDng/iaRlm3t1AWCu8lbxv6d0Iq6igajWo
         dbEw==
X-Forwarded-Encrypted: i=1; AJvYcCUZLXUDKTezi4q0RnMEFF3RgUpiA9737xqHMdk+FDXaIoI5lCmKIABM+7DX/sJmqCvO3n0=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywjv/gygTyeXLJLa4pWryKKgbuAhSQfXgecBkhGxbdfFX8Uqc8J
	gakdbobnxy/bFPj4Kqlo09dz0LOpEjWuDryc6zaguAhDtqU7IHGjDqFARLLkxXQsZAU=
X-Gm-Gg: ASbGncsFnanWdRvNq+bSioe6KU7xg5LnaMTlNavfKQhtDxjDJI4FEU2RrbCzZZEbWAP
	NGZbjqOyKYJlKOMB4Mcae17fyY+sZHFuRgLVMQhByGL6pPS7AhK+c3BxMt08YDMvA37s+nftgdm
	UlUXUSyc4GAstVqKS+MK6TcRXE6A3D6FkmiqGAHP2rQyNMQyMAM+wJqanCF9k/uUc6DCDKav+T2
	oIntryeYA1kVQAPW+wffUAGCZotxLKta6o/69pmbE/CN9OYDF0Lo/W16pzJfl9A3qdN3X5TJ+zw
	npmwu8o41gB0vUPHTImx3qXog+31UGh2+/QlHvbiidVb+wIuynZGqMlrOgJ/2fs7nMar1rfd/D6
	77r8o0Gk0YX9rySUlQfHSoDvLezq5XjTSZQlFhdAyyHzx+YlQt+yBVt0XdxoPB1DGKO/KOm19Jl
	tdst4IOgupOfIXr6S2eNNgAtxK
X-Google-Smtp-Source: AGHT+IE+CAzuCcPF3rL8oHgsDWK0spr1fitX6ekcCdqYoQO8jnWYejdEAIaIwc3jMgWkxQsuV9mqBA==
X-Received: by 2002:a05:6000:2f87:b0:3e9:2fea:6795 with SMTP id ffacd0b85a97d-40e4b389223mr19891217f8f.53.1759217931688;
        Tue, 30 Sep 2025 00:38:51 -0700 (PDT)
Received: from [192.168.69.221] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc5602efdsm22464734f8f.34.2025.09.30.00.38.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 00:38:51 -0700 (PDT)
Message-ID: <b06323d4-96e8-41c2-b437-ea27b2952e7a@linaro.org>
Date: Tue, 30 Sep 2025 09:38:49 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 16/17] hw/virtio/vhost: Replace legacy
 cpu_physical_memory_*map() calls
To: qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>
Cc: Jason Herne <jjherne@linux.ibm.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Stefano Garzarella <sgarzare@redhat.com>, xen-devel@lists.xenproject.org,
 Paolo Bonzini <pbonzini@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>,
 Anthony PERARD <anthony@xenproject.org>, Paul Durrant <paul@xen.org>,
 Eric Farman <farman@linux.ibm.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 Halil Pasic <pasic@linux.ibm.com>, Matthew Rosato <mjrosato@linux.ibm.com>,
 Reinoud Zandijk <reinoud@netbsd.org>, Zhao Liu <zhao1.liu@intel.com>,
 David Woodhouse <dwmw2@infradead.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sunil Muthuswamy <sunilmut@microsoft.com>, kvm@vger.kernel.org,
 "Michael S. Tsirkin" <mst@redhat.com>, Peter Xu <peterx@redhat.com>,
 Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 David Hildenbrand <david@redhat.com>
References: <20250930041326.6448-1-philmd@linaro.org>
 <20250930041326.6448-17-philmd@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250930041326.6448-17-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 30/9/25 06:13, Philippe Mathieu-Daudé wrote:
> Use VirtIODevice::dma_as address space to convert the legacy
> cpu_physical_memory_[un]map() calls to address_space_[un]map().
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   hw/virtio/vhost.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
> index 6557c58d12a..890d2bac585 100644
> --- a/hw/virtio/vhost.c
> +++ b/hw/virtio/vhost.c
> @@ -27,6 +27,7 @@
>   #include "migration/blocker.h"
>   #include "migration/qemu-file-types.h"
>   #include "system/dma.h"
> +#include "system/memory.h"
>   #include "trace.h"
>   
>   /* enabled until disconnected backend stabilizes */
> @@ -455,7 +456,8 @@ static void *vhost_memory_map(struct vhost_dev *dev, hwaddr addr,
>                                 hwaddr *plen, bool is_write)
>   {
>       if (!vhost_dev_has_iommu(dev)) {
> -        return cpu_physical_memory_map(addr, plen, is_write);
> +        return address_space_map(vdev->dma_as, addr, plen, is_write,
> +                                 MEMTXATTRS_UNSPECIFIED);
>       } else {
>           return (void *)(uintptr_t)addr;
>       }
> @@ -466,7 +468,7 @@ static void vhost_memory_unmap(struct vhost_dev *dev, void *buffer,
>                                  hwaddr access_len)
>   {
>       if (!vhost_dev_has_iommu(dev)) {
> -        cpu_physical_memory_unmap(buffer, len, is_write, access_len);
> +        address_space_unmap(vdev->dma_as, buffer, len, is_write, access_len);
>       }
>   }
>   

Forgot to squash:

-- >8 --
diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index 890d2bac585..acd359bdb3f 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -456,7 +456,7 @@ static void *vhost_memory_map(struct vhost_dev *dev, 
hwaddr addr,
                                hwaddr *plen, bool is_write)
  {
      if (!vhost_dev_has_iommu(dev)) {
-        return address_space_map(vdev->dma_as, addr, plen, is_write,
+        return address_space_map(dev->vdev->dma_as, addr, plen, is_write,
                                   MEMTXATTRS_UNSPECIFIED);
      } else {
          return (void *)(uintptr_t)addr;
(1/2) Stage this hunk [y,n,q,a,d,j,J,g,/,e,p,?]? y
@@ -468,7 +468,8 @@ static void vhost_memory_unmap(struct vhost_dev 
*dev, void *buffer,
                                 hwaddr access_len)
  {
      if (!vhost_dev_has_iommu(dev)) {
-        address_space_unmap(vdev->dma_as, buffer, len, is_write, 
access_len);
+        address_space_unmap(dev->vdev->dma_as, buffer, len, is_write,
+                            access_len);
      }
  }

---

