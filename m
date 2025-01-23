Return-Path: <kvm+bounces-36353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B12BA1A46E
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 13:42:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6BDDF1644CF
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 12:42:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E49DF20F07C;
	Thu, 23 Jan 2025 12:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y9s6dMmn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7C5136E3B
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 12:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737636116; cv=none; b=tCmFFLraGEz/QxzvViZwmigSfm6suGKYATvkim4dILuRRPFxf/Nrx/5zDFNKU2tW26PY/vVAFcngRzfkgyiOL6yvpg7dVA4E1qf9q5xEJqfgr9EXlqmWqfyc7J/IhL3ps0KqEz37bX2heERqRCKFSX0v95Q8EgV+SjvQGlgpXu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737636116; c=relaxed/simple;
	bh=OlU2/UUlea+lG4tV50En4ktxe/fonxdcvwbkAFIMtfQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hsU5Nsnpvn0ZFA0P6j+DibO/68wwYlQ3r83GEt85Ne6I50sl6pt3j56qK1GqgiV9ZC6DYNcUW1ioqwnTfOxBX9/bJzcAZ0Xw8S6NIwXtF629KDkwh0G+yYCy6G5EVK99UxriT7FXuWMZjG8zuxskLMXCKDLe9dUUl5EbOVxbVzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y9s6dMmn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737636113;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u5FZv+8u+d2GtcDrre/mQ3Ye6vAjYVJKfIBRUFGXtx4=;
	b=Y9s6dMmnj61YDzY1sLqeXDIBLP4aWJSIui5SL0vsposG3mC7jl1aNHSccQ9IFLxETGWf/s
	kfkKpUy1vEiDqiHHUJeHSez1/GN4JWH4OLMC/ryiPHqBdI+hJ9F2WUW+Xd0Ebg7wGVj/XC
	P8t9ysL6E/NgUyuZpNZdhNKQquQS5F4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-ddq0XIrlM9qVw9cPV9uGbw-1; Thu, 23 Jan 2025 07:41:52 -0500
X-MC-Unique: ddq0XIrlM9qVw9cPV9uGbw-1
X-Mimecast-MFC-AGG-ID: ddq0XIrlM9qVw9cPV9uGbw
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-436723bf7ffso6092625e9.3
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 04:41:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737636111; x=1738240911;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u5FZv+8u+d2GtcDrre/mQ3Ye6vAjYVJKfIBRUFGXtx4=;
        b=Vf+cKkGNHslTdZrYU9PzGigwyy9je0eympg8c2nQNtSjwYumqwiNSum6U8vArfG7DQ
         GqDw2rAPLgCNt2/UajaxIq6SeKptDbsUYaEfurl8xYGTJSxSLOSUj5LBPByX5eeAFlG8
         wY91V9X+FDnT9SE2k7a98Z4CI36xe/XbXLyqF9LHE4yBeicMBTDr+glgx0ujN0x6oFQX
         iKZ55gaDVN/7n9VDcnw+ve1J17mRKXVe+trgJ8kfrAgplyECKvpPn0a5epdqSNOE0FaV
         rhLOtsZKQBE1apiflDo7pPYaFiLySpoAjIvDn2+uDl5At2GE7P3HGZVrBDLX5E6JeXcn
         Jkpg==
X-Forwarded-Encrypted: i=1; AJvYcCW4zRsbdQ9aGKg3NIGXISBaOQqtn5SdV6ATyyGrapuwHPYD82Lj6/gCssWMqo5iR6Z7bd0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBXO+7sqRwwwbPyFEAbhGFv74nd/e4flgPuJthp2WaJnLzWeo/
	vKqScWLNFTVr7L38Ud3mWO1aW5JaxeWFsPq5bm21GbjSnB9e0r4mROyInJuUB/DVaDTz/ESRr1R
	pyaa2IZsGinGVpF6fwogw6oQLL8ldc/RAfYPos/BsC4LeA31zLw==
X-Gm-Gg: ASbGncsRANvZ3LrD8X9NrRD8aQ33qj6I/sAR1OHKjX/9X8zukQmyyAR/MMKozYPQxyT
	aFTuCOZQTH9bxdpi8Pr2FdVCOqK/jXykDZk7sc04NBAVN2X4grIUbTF3sDUzeP0BscBCn5TneZ7
	+2n0o/TDt2TmHaAoUu/pP+R0odfQwWFXgzIk0z+8M6PbHKVMvy9D7LzRx+LnTnzpmCyvdqAigWO
	XM326PM38Y36zURAK4uDSt8umkcPH/FFxeMrOFdSJPUjOiEmENlVEsPT8mVM2CyGElrLJDmtYl5
	vmuICwmD5YogUmMHc8d0iWe6bsj0fOsKRo56XJ+BMA==
X-Received: by 2002:a05:600c:1987:b0:434:f753:6012 with SMTP id 5b1f17b1804b1-438913f2f4emr259295215e9.17.1737636110979;
        Thu, 23 Jan 2025 04:41:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFaf0J1FpGBG9DXD2cCzVrXAaT6T+N0ZijcOGKXj6jeyiABkDxsaVx5NBozYlDdObLnfmJtRw==
X-Received: by 2002:a05:600c:1987:b0:434:f753:6012 with SMTP id 5b1f17b1804b1-438913f2f4emr259294915e9.17.1737636110549;
        Thu, 23 Jan 2025 04:41:50 -0800 (PST)
Received: from imammedo.users.ipa.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf32151f1sm19447922f8f.14.2025.01.23.04.41.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2025 04:41:49 -0800 (PST)
Date: Thu, 23 Jan 2025 13:41:48 +0100
From: Igor Mammedov <imammedo@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Riku Voipio <riku.voipio@iki.fi>,
 Richard Henderson <richard.henderson@linaro.org>, Zhao Liu
 <zhao1.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>, Marcel
 Apfelbaum <marcel.apfelbaum@gmail.com>, Ani Sinha <anisinha@redhat.com>,
 Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>, Yanan Wang
 <wangyanan55@huawei.com>, Cornelia Huck <cohuck@redhat.com>, "Daniel P.
 =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>, Eric Blake
 <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, rick.p.edgecombe@intel.com, kvm@vger.kernel.org,
 qemu-devel@nongnu.org
Subject: Re: [PATCH v6 40/60] hw/i386: add eoi_intercept_unsupported member
 to X86MachineState
Message-ID: <20250123134148.036d52b0@imammedo.users.ipa.redhat.com>
In-Reply-To: <20241105062408.3533704-41-xiaoyao.li@intel.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
	<20241105062408.3533704-41-xiaoyao.li@intel.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  5 Nov 2024 01:23:48 -0500
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> Add a new bool member, eoi_intercept_unsupported, to X86MachineState
> with default value false. Set true for TDX VM.

I'd rename it to enable_eoi_intercept, by default set to true for evrything
and make TDX override this to false.
> 
> Inability to intercept eoi causes impossibility to emulate level
> triggered interrupt to be re-injected when level is still kept active.
> which affects interrupt controller emulation.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>  hw/i386/x86.c         | 1 +
>  include/hw/i386/x86.h | 1 +
>  target/i386/kvm/tdx.c | 2 ++
>  3 files changed, 4 insertions(+)
> 
> diff --git a/hw/i386/x86.c b/hw/i386/x86.c
> index 01fc5e656272..82faeed24ff9 100644
> --- a/hw/i386/x86.c
> +++ b/hw/i386/x86.c
> @@ -370,6 +370,7 @@ static void x86_machine_initfn(Object *obj)
>      x86ms->oem_table_id = g_strndup(ACPI_BUILD_APPNAME8, 8);
>      x86ms->bus_lock_ratelimit = 0;
>      x86ms->above_4g_mem_start = 4 * GiB;
> +    x86ms->eoi_intercept_unsupported = false;
>  }
>  
>  static void x86_machine_class_init(ObjectClass *oc, void *data)
> diff --git a/include/hw/i386/x86.h b/include/hw/i386/x86.h
> index d43cb3908e65..fd9a30391755 100644
> --- a/include/hw/i386/x86.h
> +++ b/include/hw/i386/x86.h
> @@ -73,6 +73,7 @@ struct X86MachineState {
>      uint64_t above_4g_mem_start;
>  
>      /* CPU and apic information: */
> +    bool eoi_intercept_unsupported;
>      unsigned pci_irq_mask;
>      unsigned apic_id_limit;
>      uint16_t boot_cpus;
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index 9ab4e911f78a..9dcb77e011bd 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -388,6 +388,8 @@ static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>          return -EOPNOTSUPP;
>      }
>  
> +    x86ms->eoi_intercept_unsupported = true;

I don't particulary like accel go to its parent (machine) object and override things there
and that being buried deep inside.

How do you start TDX guest?
Is there a machine property or something like it to enable TDX?

> +
>      /*
>       * Set kvm_readonly_mem_allowed to false, because TDX only supports readonly
>       * memory for shared memory but not for private memory. Besides, whether a


