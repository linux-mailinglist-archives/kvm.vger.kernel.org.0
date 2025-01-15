Return-Path: <kvm+bounces-35517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C73C9A11C5C
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 09:46:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D0FB51683E1
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 08:46:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 627D61E7C20;
	Wed, 15 Jan 2025 08:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J/DzVSp7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3531823F275
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 08:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736930811; cv=none; b=eV5FeZXO5cQ4fDkwH0uBKcPdG0aR3kuRAIfeW7IGkZAnhQdhGmPcWCce4R2DRBsDqv/M5KclD/Hq4827Efnjk1q/EtTM4Z863bCb+sarQt/+j2w7nuie6HHMDTKQ7BbZ3PF26eydA1a5sBEgJ2pfFsjQeHWpzlx6LD6IvJuWkac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736930811; c=relaxed/simple;
	bh=GZnApYjwsDBpmM1EkbcygFDXOcJ+UCor3KgOdhjOy9g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EYZSmZ3zsTtZmvSJsXyYfUZ/owGBWaJv0QwXe51loMf2e3sH4iMHeJufyXfLswcsksruzBCtD3ZGlHPlSaFB+VR1eXHz1gNvCvK3C70BWQ8rJYecTA+MMkSMIoA1nNC1fskMZzNgqLlSNfQRBW4r+cWDX0JCLPr79UcMAjj7M8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J/DzVSp7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736930808;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6uIurpLRMFCMfe6HezrOV/WPAVhPmgVEcPBHpkOKDHg=;
	b=J/DzVSp7daK9oHQ5iNLH2Xp4g0j0mkTN7OjBc3Jw5qy7daFpLyBmFcEdKjGhJxEuJhYDk5
	YOElfzc2rXZs6YKfCDqIlAfzuFbsXv2S8SLA8GLCDa46Zi19tUP4x6l6CcnA/jLeYw/nna
	xy2O04pU3i81EkWefXRBnSLPpxDEvoI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-26-X4T9WdoUPPyumFwxsbyU0w-1; Wed, 15 Jan 2025 03:46:46 -0500
X-MC-Unique: X4T9WdoUPPyumFwxsbyU0w-1
X-Mimecast-MFC-AGG-ID: X4T9WdoUPPyumFwxsbyU0w
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4359eb032c9so48587855e9.2
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 00:46:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736930805; x=1737535605;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6uIurpLRMFCMfe6HezrOV/WPAVhPmgVEcPBHpkOKDHg=;
        b=hoJlTLa4e0W6xm72710lrBXiY4REtv4DUcjFQGcBBfHC5MYquIyS/mFvW6CuEAATVZ
         WQcQ9R16JS5oIYWBCsOfSpbHBowu5DdWj9bKyHVtI6j1MdTyLsIruImW1mvJRw9cjOt/
         H9HmHBkoyf+zYN/VgKOs3SDmg/eVRs0J0+f7YDRJ1sBT3/MqTgDNzIKdCIbI90lDhIVP
         mJ7k7TxwdGksuT0RdKnuUof9vYTXeG3jbwCQl/LSsmWcrbAHB+2R2IlJRQq6RpNMMhMy
         uxkbFOHvI8wyK4hjR0q8kUzIwgI1AiD3etwSA1faZyLAhienCYKAu2VgQdbh3+qw2/9/
         Ezag==
X-Forwarded-Encrypted: i=1; AJvYcCWX+zhfgK0u9G1ItBZinQxMwBOXdNiUI9FmqQuKCSFpe89YjhcFN8mcypfJrIu/GQDBxeM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzfcMTEXQONgBOcB6938D/hI6szGdycxOp9r8GOeBz0Y0xgKx6M
	PMjME3ZWoZ4lkadzVkDmG/Y4NAHWoNivBfyaBNnJBbOSD3g7fbZddWioMAcNJ0JwKpXrJD3CuJ2
	I3/aGvHX9pUdi/hq97SmGLe9INpUWqEw3+4MxW48Bmi4yqhvt+Q==
X-Gm-Gg: ASbGncsM0jNkT1SC81QsIc9pCnn29kMPL0IGAbEyRL3Xbtfizl0RjDKqLMOlazDaRZ6
	7Cv4cw6E0aCWKLd6ohSxsyIsV7sdOJFuPEZMBsQUXSuetYUUDyrI66kb9rH0YHXKjTd7enCOA6i
	1R2xLccIzwJAHIKTuJLPoEghLB7kvGuz9dWPBA8Or3NBvJBV/47Xoj1Sdbo4EbFmg128uMQe/wQ
	ADjPlFrFOWvBRXksLbTWlaJEJNhlN0uTX6UWecP0D8HwSL7QA==
X-Received: by 2002:a05:600c:1d1f:b0:434:f99e:a5b5 with SMTP id 5b1f17b1804b1-436e271cf4amr210679795e9.28.1736930804661;
        Wed, 15 Jan 2025 00:46:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHxGvE+CDIhSH3P3PgxaDQ/+MCGDWQX7KRPeVqMQKhQyZvKlJZedQEYQ5HUXKL/lwArB29ZQQ==
X-Received: by 2002:a05:600c:1d1f:b0:434:f99e:a5b5 with SMTP id 5b1f17b1804b1-436e271cf4amr210679545e9.28.1736930804243;
        Wed, 15 Jan 2025 00:46:44 -0800 (PST)
Received: from redhat.com ([2a02:14f:1f5:8f43:2a76:9f8c:65e8:ce7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-437c74aaffesm15429435e9.10.2025.01.15.00.46.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2025 00:46:43 -0800 (PST)
Date: Wed, 15 Jan 2025 03:46:37 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v7 RESEND 0/5] i386: Support SMP Cache Topology
Message-ID: <20250115034612-mutt-send-email-mst@kernel.org>
References: <20250110145115.1574345-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250110145115.1574345-1-zhao1.liu@intel.com>

On Fri, Jan 10, 2025 at 10:51:10PM +0800, Zhao Liu wrote:
> Hi folks,
> 
> This is my v7 resend version (updated the commit message of origin
> v7's Patch 1).
> 
> Compared with v6 [1], v7 dropped the "thread" level cache topology
> (cache per thread):
> 
>  - Patch 1 is the new patch to reject "thread" parameter for smp-cache.
>  - Ptach 2 dropped cache per thread support.
>  (Others remain unchanged.)
> 
> There're several reasons:
> 
>  * Currently, neither i386 nor ARM have real hardware support for per-
>    thread cache.
>  * ARM can't support thread level cache in device tree. [2].
> 
> So it is unnecessary to support it at this moment, even though per-
> thread cache might have potential scheduling benefits for VMs without
> CPU affinity.
> 
> In the future, if there is a clear demand for this feature, the correct
> approach would be to add a new control field in MachineClass.smp_props
> and enable it only for the machines that require it.
> 
> 
> This series is based on the master branch at commit aa3a285b5bc5 ("Merge
> tag 'mem-2024-12-21' of https://github.com/davidhildenbrand/qemu into
> staging").

pc things:

Reviewed-by: Michael S. Tsirkin <mst@redhat.com>



> Smp-cache support of ARM side can be found at [3].
> 
> 
> Background
> ==========
> 
> The x86 and ARM (RISCV) need to allow user to configure cache properties
> (current only topology):
>  * For x86, the default cache topology model (of max/host CPU) does not
>    always match the Host's real physical cache topology. Performance can
>    increase when the configured virtual topology is closer to the
>    physical topology than a default topology would be.
>  * For ARM, QEMU can't get the cache topology information from the CPU
>    registers, then user configuration is necessary. Additionally, the
>    cache information is also needed for MPAM emulation (for TCG) to
>    build the right PPTT. (Originally from Jonathan)
> 
> 
> About smp-cache
> ===============
> 
> The API design has been discussed heavily in [4].
> 
> Now, smp-cache is implemented as a array integrated in -machine. Though
> -machine currently can't support JSON format, this is the one of the
> directions of future.
> 
> An example is as follows:
> 
> smp_cache=smp-cache.0.cache=l1i,smp-cache.0.topology=core,smp-cache.1.cache=l1d,smp-cache.1.topology=core,smp-cache.2.cache=l2,smp-cache.2.topology=module,smp-cache.3.cache=l3,smp-cache.3.topology=die
> 
> "cache" specifies the cache that the properties will be applied on. This
> field is the combination of cache level and cache type. Now it supports
> "l1d" (L1 data cache), "l1i" (L1 instruction cache), "l2" (L2 unified
> cache) and "l3" (L3 unified cache).
> 
> "topology" field accepts CPU topology levels including "core", "module",
> "cluster", "die", "socket", "book", "drawer" and a special value
> "default". (Note, now, in v7, smp-cache doesn't support "thread".)
> 
> The "default" is introduced to make it easier for libvirt to set a
> default parameter value without having to care about the specific
> machine (because currently there is no proper way for machine to
> expose supported topology levels and caches).
> 
> If "default" is set, then the cache topology will follow the
> architecture's default cache topology model. If other CPU topology level
> is set, the cache will be shared at corresponding CPU topology level.
> 
> [1]: Patch v6: https://lore.kernel.org/qemu-devel/20241219083237.265419-1-zhao1.liu@intel.com/
> [2]: Gap of cache per thread for ARM: https://lore.kernel.org/qemu-devel/20250110114100.00002296@huawei.com/T/#m50c37fa5d372feac8e607c279cd446da3e22a12c
> [3]: ARM smp-cache: https://lore.kernel.org/qemu-devel/20250102152012.1049-1-alireza.sanaee@huawei.com/
> [4]: API disscussion: https://lore.kernel.org/qemu-devel/8734ndj33j.fsf@pond.sub.org/
> 
> Thanks and Best Regards,
> Zhao
> ---
> Alireza Sanaee (1):
>   i386/cpu: add has_caches flag to check smp_cache configuration
> 
> Zhao Liu (4):
>   hw/core/machine: Reject thread level cache
>   i386/cpu: Support module level cache topology
>   i386/cpu: Update cache topology with machine's configuration
>   i386/pc: Support cache topology in -machine for PC machine
> 
>  hw/core/machine-smp.c |  9 ++++++
>  hw/i386/pc.c          |  4 +++
>  include/hw/boards.h   |  3 ++
>  qemu-options.hx       | 30 +++++++++++++++++-
>  target/i386/cpu.c     | 71 ++++++++++++++++++++++++++++++++++++++++++-
>  5 files changed, 115 insertions(+), 2 deletions(-)
> 
> -- 
> 2.34.1


