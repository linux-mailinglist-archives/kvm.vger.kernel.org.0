Return-Path: <kvm+bounces-66172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E776ACC8167
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 15:10:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 14E67304E8CB
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 14:03:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7A773596FD;
	Wed, 17 Dec 2025 14:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C5+/DREw";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="L6XNEMhE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04082349AE1
	for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 14:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765980040; cv=none; b=IvoVLKeeDmbsEaoKobC+uf0pUXYXHpzyFBJIgqn7Tb5nMMHCKbFvGVhfn78iESL8VTpR0nsJQFvt8C4xhUjxdMEyxiNVYwebsIP2w88Oqhe0WYikcb3CKgAU1mbDTt4WvoNpXdFRdc0o7+dzcbC08HrNK+9hdYyvU37gjvGJIDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765980040; c=relaxed/simple;
	bh=cID+ZVg6VpXXH5zpDT6fnjB/6M2CKZw8A847+o/J+ng=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=niqchPABv6SU49ZH1g0VDDEIVVXOCOML9b+6lDdLQN/QO1/AND+s87goAHpMufNmxRVc4LwTGoqD3+OeJ50FAxisbcIb7hAnH2NdGCrkwgwGsyLvXL3ZnGB4+pJBwAZkuF3tN2FrzCSGa/VwRbtOerwTGUyGEGn/PGEfIMcsFGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C5+/DREw; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=L6XNEMhE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765980037;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HbthGM/G+GWpXtODayU7RTgZ2Jepun9Dt1c05gz+DX8=;
	b=C5+/DREwHBVfoLmVKc2LutKjYSb5OqzbVFwJ7oszdJwqIoADCyPFg2Q12tZzwMHpxhj7j1
	rwN6VoErpKRI/R4oiYzxwp3n8ld2JKRtxTKMop+eHNzGhZXGVdgofIAk+dtPaZjQ5KsSeJ
	+lDNnvbw64kSFaM3fe0XS1yqQZcgkzM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-hCytScPiOpiq-23cn3VFMA-1; Wed, 17 Dec 2025 09:00:36 -0500
X-MC-Unique: hCytScPiOpiq-23cn3VFMA-1
X-Mimecast-MFC-AGG-ID: hCytScPiOpiq-23cn3VFMA_1765980035
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-47918084ac1so53700775e9.2
        for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 06:00:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765980035; x=1766584835; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HbthGM/G+GWpXtODayU7RTgZ2Jepun9Dt1c05gz+DX8=;
        b=L6XNEMhEE40T7TfCeDdKHoBGdRbXUfH5yv+kK6jiynSWeY6P/B0uwZbaoq/qMvtWeg
         ReMkbzVTo02vmWbekkKD9WI/YDttWaKM7aGRTJd3+7lAOuyxdGDTbtOdsSBpGYlZ9hd/
         r+UiLeNpBz1i1VD8XKO1rOQH+NQDu0lS7Vld4qE+LLAqXJ7jjbqXUj2/ICJ4wCRN4ieq
         IojuA9M3+lJTDNLTZxFjVRdNmj7Htyp5uEasAxNSWBHefzE/LZ2dD9Z5awfL51jVjeEn
         FrU9Njz0SYHOVt8rj0ggw6vv7yXSOKjBzYeJJTVhhNkfErDxB/ZLFkjHJwfZP7XHz2nC
         /VjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765980035; x=1766584835;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HbthGM/G+GWpXtODayU7RTgZ2Jepun9Dt1c05gz+DX8=;
        b=mlSFq2Aiy8f73z3zmbgyAqFy1TPLBnBfDAa9xVmZkLhfgdsXL8DmQWqQRZMZYuXeNJ
         8r9a7nFzc/qgQU70PfxmBziAOVRMMVObVsNMcUguQtwLzO0IzdufxXmTICmsl5DPIkJd
         1EgViUI0iLgmcXqqbxGH380wV4kd5mz4BFgW1FQf1S2y8ya9MXqYPDpSzpYPRhDOgXAq
         ojOz47XEIHjAFWXi8B90ZU7q15spWCI6TuMJPArGvPdaMaMgUetWyrOtp8BPEV2WivYK
         AKJ06yZxBP/9urEzibZxeMOewaAIDV5Oh+G25Zl8SkDN96Ou2qzMDnPLHherhohiR+hZ
         jJfg==
X-Forwarded-Encrypted: i=1; AJvYcCVI/pmuzr05SaUC7Bb+0olLHbxGS6Z9Vi8k6I0WALueqC740VyNG/ZbZ6V106ReXQf1tmU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzUqGsz/FqpPrsrCqVj1nSM+v3xtRbWL0wEcfe2mS36/L8Yw9bC
	vMps6b0rfs6XAx1d9MTCJsLz9uQNXY/Kf3txJcpc2gdgEybqo3gMnBoq8tBbOcMnqnDpPASamMP
	TVEUbeZ/sPXTFLKYpaUTF0qYrp2miGd+CBEnEYxhKAmbunOeflEO/fw==
X-Gm-Gg: AY/fxX5p61LUSwFkeppQmzgWmWjkZlVI6XOy9lyIVCaZd9BVE8QtUYsqVMFNlt3Kfko
	NjroLcjsSi5bVGefTgQgXb5Ptpal1xr57PCR20I7tdH2x9c8jJV6vSLHXvdjcspvZG9OSbtUvYi
	kvvj4D2oXi1cimY5Sw7HcQI1ncVbnS88Y6ma17VCqbIC/iQ6NLkYkQEWExJ6Qjk2NsgQdFjUevv
	BGc2sRbRu34ukrSRAWO5HwUBJhAPUZb3tq5bD5+i8KgabXNweewJ08Ts+ClO7Ci7Xe2XW5Ntjfy
	AAHVpIvniqRyvWvrI4zi5BOQZm+jdASGhNYZy9LbIRtPliPNbfaUtaUEJh9/LynUETCJBw==
X-Received: by 2002:a05:600c:870b:b0:477:214f:bd95 with SMTP id 5b1f17b1804b1-47a970ee01fmr121266415e9.23.1765980035277;
        Wed, 17 Dec 2025 06:00:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHF3Fr/Zcas6umUDcUr9uZT23jIj6/PQ2ws/ggCzapTqhVg7JQ7VBdYoNAD+a6a+0T+RRnEZw==
X-Received: by 2002:a05:600c:870b:b0:477:214f:bd95 with SMTP id 5b1f17b1804b1-47a970ee01fmr121266215e9.23.1765980034769;
        Wed, 17 Dec 2025 06:00:34 -0800 (PST)
Received: from imammedo ([213.175.46.86])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47bd932a3e5sm30087275e9.0.2025.12.17.06.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 06:00:34 -0800 (PST)
Date: Wed, 17 Dec 2025 15:00:29 +0100
From: Igor Mammedov <imammedo@redhat.com>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "Michael S . Tsirkin"
 <mst@redhat.com>, Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?=
 <philmd@linaro.org>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Thomas
 Huth <thuth@redhat.com>, qemu-devel@nongnu.org, devel@lists.libvirt.org,
 kvm@vger.kernel.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org, Richard
 Henderson <richard.henderson@linaro.org>, Sergio Lopez <slp@redhat.com>,
 Gerd Hoffmann <kraxel@redhat.com>, Peter Maydell
 <peter.maydell@linaro.org>, Laurent Vivier <lvivier@redhat.com>, Jiaxun
 Yang <jiaxun.yang@flygoat.com>, Yi Liu <yi.l.liu@intel.com>, Eduardo
 Habkost <eduardo@habkost.net>, Alistair Francis <alistair.francis@wdc.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, Weiwei Li <liwei1518@gmail.com>, Amit Shah
 <amit@kernel.org>, Xiaoyao Li <xiaoyao.li@intel.com>, Yanan Wang
 <wangyanan55@huawei.com>, Helge Deller <deller@gmx.de>, Palmer Dabbelt
 <palmer@dabbelt.com>, "Daniel P . =?UTF-8?B?QmVycmFuZ8Op?="
 <berrange@redhat.com>, Ani Sinha <anisinha@redhat.com>, Fabiano Rosas
 <farosas@suse.de>, Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 =?UTF-8?B?Q2zDqW1lbnQ=?= Mathieu--Drif <clement.mathieu--drif@eviden.com>,
 =?UTF-8?B?TWFyYy1BbmRyw6k=?= Lureau <marcandre.lureau@redhat.com>, Huacai
 Chen <chenhuacai@kernel.org>, Jason Wang <jasowang@redhat.com>, Mark
 Cave-Ayland <mark.caveayland@nutanix.com>, BALATON Zoltan
 <balaton@eik.bme.hu>, Peter Krempa <pkrempa@redhat.com>, Jiri Denemark
 <jdenemar@redhat.com>
Subject: Re: [PATCH v5 06/28] docs/specs/acpi_cpu_hotplug: Remove legacy cpu
 hotplug descriptions
Message-ID: <20251217150029.3a3bc19d@imammedo>
In-Reply-To: <20251202162835.3227894-7-zhao1.liu@intel.com>
References: <20251202162835.3227894-1-zhao1.liu@intel.com>
	<20251202162835.3227894-7-zhao1.liu@intel.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  3 Dec 2025 00:28:13 +0800
Zhao Liu <zhao1.liu@intel.com> wrote:

> Legacy cpu hotplug has been removed totally and machines start with
> modern cpu hotplug interface directly.
> 
> Therefore, update the documentation to describe current QEMU cpu hotplug
> logic.
> 
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

Reviewed-by: Igor Mammedov <imammedo@redhat.com>

> ---
> Changes since v4:
>  * New patch.
> ---
>  docs/specs/acpi_cpu_hotplug.rst | 28 +++-------------------------
>  1 file changed, 3 insertions(+), 25 deletions(-)
> 
> diff --git a/docs/specs/acpi_cpu_hotplug.rst b/docs/specs/acpi_cpu_hotplug.rst
> index 351057c96761..f49678100044 100644
> --- a/docs/specs/acpi_cpu_hotplug.rst
> +++ b/docs/specs/acpi_cpu_hotplug.rst
> @@ -8,22 +8,6 @@ ACPI BIOS GPE.2 handler is dedicated for notifying OS about CPU hot-add
>  and hot-remove events.
>  
>  
> -Legacy ACPI CPU hotplug interface registers
> --------------------------------------------
> -
> -CPU present bitmap for:
> -
> -- ICH9-LPC (IO port 0x0cd8-0xcf7, 1-byte access)
> -- PIIX-PM  (IO port 0xaf00-0xaf1f, 1-byte access)
> -- One bit per CPU. Bit position reflects corresponding CPU APIC ID. Read-only.
> -- The first DWORD in bitmap is used in write mode to switch from legacy
> -  to modern CPU hotplug interface, write 0 into it to do switch.
> -
> -QEMU sets corresponding CPU bit on hot-add event and issues SCI
> -with GPE.2 event set. CPU present map is read by ACPI BIOS GPE.2 handler
> -to notify OS about CPU hot-add events. CPU hot-remove isn't supported.
> -
> -
>  Modern ACPI CPU hotplug interface registers
>  -------------------------------------------
>  
> @@ -189,20 +173,14 @@ Typical usecases
>  (x86) Detecting and enabling modern CPU hotplug interface
>  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>  
> -QEMU starts with legacy CPU hotplug interface enabled. Detecting and
> -switching to modern interface is based on the 2 legacy CPU hotplug features:
> -
> -#. Writes into CPU bitmap are ignored.
> -#. CPU bitmap always has bit #0 set, corresponding to boot CPU.
> -
> -Use following steps to detect and enable modern CPU hotplug interface:
> +QEMU starts with modern CPU hotplug interface enabled. Use following steps to
> +detect modern CPU hotplug interface:
>  
> -#. Store 0x0 to the 'CPU selector' register, attempting to switch to modern mode
>  #. Store 0x0 to the 'CPU selector' register, to ensure valid selector value
>  #. Store 0x0 to the 'Command field' register
>  #. Read the 'Command data 2' register.
>     If read value is 0x0, the modern interface is enabled.
> -   Otherwise legacy or no CPU hotplug interface available
> +   Otherwise no CPU hotplug interface available
>  
>  Get a cpu with pending event
>  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^


