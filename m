Return-Path: <kvm+bounces-28130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ED8C5994637
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 13:10:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 71CFD1F29012
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 11:10:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 024311DFE13;
	Tue,  8 Oct 2024 11:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="flky8EG1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B491DFE10
	for <kvm@vger.kernel.org>; Tue,  8 Oct 2024 11:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728385546; cv=none; b=rSOBHqw1dVAMG2ZCl4OYKM+D78SH8i1B8BWXiYWNdIwTqrO9odTF/M1q5HCQUDF7j59Xj+Z8ZimWO9FsmksEGZKlvnRtG6HnqpE62OT5AYRgOMuRfKH8OB0QH3uOJSQj30blAKKspnsAN66kSoCCCE81OYUDNjZDJuXamal/0f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728385546; c=relaxed/simple;
	bh=blpyLMsuFMn24VZPPL8dDbNZnSR7Pou7ksJj/nytLXc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H3jGceMMjrq4RI0kBsc2rJZrxjnLrnfgTxHrkCqYX/128oeoeF+NNg0bb6vWaY4/AoqyBqzAMZYh6CJJ9l6IMKcUKwYwZwTrv//cxQY8Kx8PoxLgG6pLYlSqelT5dCZGWw0O8R8lngiPeVGrSCa/fNNlsVS8JxheqWV2Ce0c4zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=flky8EG1; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2fabb837ddbso75250901fa.1
        for <kvm@vger.kernel.org>; Tue, 08 Oct 2024 04:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1728385542; x=1728990342; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wxNxFS3ZbI3W4kQXbO0lCunpQ22o9dZ3gjnqPR7i4vQ=;
        b=flky8EG1aHAhFOZU+fcGyaSoCVgdRKxcMW1PgG2kjfaTz3yfqrkb1WLRICnPxb+DNl
         oqmBGTxO5Y7HL40xafgfz3W5cIdheWosnGfdrSCMqljJt39HueOFrSBRuUkXrNEqJdi7
         +ctEqm20qppIzVTPqDzYH+tygvEC6OyKlDKyfwquW+HYUpBC3f594JJ+az1U+fsLjkyo
         qFNcYFnISfjGozqdh+9/+dFSwliMNEZxmPq7NdXjoQJut3458cCV+df/shjSQCob/a03
         fgr+XQ6fAG+/yKuMpX3ZaCYMSGgLDtSbLVY718zqcPJPjN6HO/TDBbC3COG85n5FQDpX
         +hbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728385542; x=1728990342;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wxNxFS3ZbI3W4kQXbO0lCunpQ22o9dZ3gjnqPR7i4vQ=;
        b=Teb5lZ7HzQTpcUAhY8ojcTgF4Tuv05suSWew3eL0vXs0fmtRrzO0mxxArlWRvTd5SA
         Kcp/sp/wgwtVBV+dLj6q258XlDnXzaE5Xpb3s2m6qEL5coKK3E7W6YDM5snSzI+m+20Z
         wIexOTGsViV1WqqKt2olysFgl7XCo1TznqonXryNK9qmEE3rR942DSzs1hjo9BOf02La
         1ZUgNh3gqbdcyxfxrpSAu+TEtMOC2Aok+5DoiueQQQxatAir4iMvHJ0AgdpaiG02Rc6G
         yf1Sxg1KabXVovAHb77WMrURG2yt7YBa5i7HI7G7EV20Gx1+wmnYDuAKFINepA9whk40
         Hz6Q==
X-Gm-Message-State: AOJu0Yw7/NqM6HvPU090kXOS7aNfDch+JssbAp/Z/R56eJgrldwnfnWe
	B0SHMIdFgBqb7e6qqv09GzOrDFsEZsxLNozfazmyMhDUhR8n+EpdU1TqQwnHGQ8=
X-Google-Smtp-Source: AGHT+IFUUVsOSGGJPAphsOFCoHIZ+0khfsB4/lk7TDogJccRq5ZqzE4wbYgRX+9fbyD9s7dMaYkATg==
X-Received: by 2002:a05:651c:2211:b0:2f0:27da:6864 with SMTP id 38308e7fff4ca-2faf3c1e75emr93401371fa.17.1728385529761;
        Tue, 08 Oct 2024 04:05:29 -0700 (PDT)
Received: from myrica ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a993d92ed5dsm434265866b.63.2024.10.08.04.05.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2024 04:05:29 -0700 (PDT)
Date: Tue, 8 Oct 2024 12:05:49 +0100
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Subject: Re: [PATCH v6 11/11] arm64: Document Arm Confidential Compute
Message-ID: <20241008110549.GA1058742@myrica>
References: <20241004144307.66199-1-steven.price@arm.com>
 <20241004144307.66199-12-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241004144307.66199-12-steven.price@arm.com>

On Fri, Oct 04, 2024 at 03:43:06PM +0100, Steven Price wrote:
> Add some documentation on Arm CCA and the requirements for running Linux
> as a Realm guest. Also update booting.rst to describe the requirement
> for RIPAS RAM.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  Documentation/arch/arm64/arm-cca.rst | 67 ++++++++++++++++++++++++++++
>  Documentation/arch/arm64/booting.rst |  3 ++
>  Documentation/arch/arm64/index.rst   |  1 +
>  3 files changed, 71 insertions(+)
>  create mode 100644 Documentation/arch/arm64/arm-cca.rst
> 
> diff --git a/Documentation/arch/arm64/arm-cca.rst b/Documentation/arch/arm64/arm-cca.rst
> new file mode 100644
> index 000000000000..ab7f90e64c2f
> --- /dev/null
> +++ b/Documentation/arch/arm64/arm-cca.rst
> @@ -0,0 +1,67 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=====================================
> +Arm Confidential Compute Architecture
> +=====================================
> +
> +Arm systems that support the Realm Management Extension (RME) contain
> +hardware to allow a VM guest to be run in a way which protects the code
> +and data of the guest from the hypervisor. It extends the older "two
> +world" model (Normal and Secure World) into four worlds: Normal, Secure,
> +Root and Realm. Linux can then also be run as a guest to a monitor
> +running in the Realm world.
> +
> +The monitor running in the Realm world is known as the Realm Management
> +Monitor (RMM) and implements the Realm Management Monitor
> +specification[1]. The monitor acts a bit like a hypervisor (e.g. it runs
> +in EL2 and manages the stage 2 page tables etc of the guests running in
> +Realm world), however much of the control is handled by a hypervisor
> +running in the Normal World. The Normal World hypervisor uses the Realm
> +Management Interface (RMI) defined by the RMM specification to request
> +the RMM to perform operations (e.g. mapping memory or executing a vCPU).
> +
> +The RMM defines an environment for guests where the address space (IPA)
> +is split into two. The lower half is protected - any memory that is
> +mapped in this half cannot be seen by the Normal World and the RMM
> +restricts what operations the Normal World can perform on this memory
> +(e.g. the Normal World cannot replace pages in this region without the
> +guest's cooperation). The upper half is shared, the Normal World is free
> +to make changes to the pages in this region, and is able to emulate MMIO
> +devices in this region too.
> +
> +A guest running in a Realm may also communicate with the RMM to request
> +changes in its environment or to perform attestation about its
> +environment. In particular it may request that areas of the protected
> +address space are transitioned between 'RAM' and 'EMPTY' (in either
> +direction). This allows a Realm guest to give up memory to be returned
> +to the Normal World, or to request new memory from the Normal World.
> +Without an explicit request from the Realm guest the RMM will otherwise
> +prevent the Normal World from making these changes.

We could mention that this interface is "RSI", so readers know what to
look for next

> +
> +Linux as a Realm Guest
> +----------------------
> +
> +To run Linux as a guest within a Realm, the following must be provided
> +either by the VMM or by a `boot loader` run in the Realm before Linux:
> +
> + * All protected RAM described to Linux (by DT or ACPI) must be marked
> +   RIPAS RAM before handing over the Linux.

"handing control over to Linux", or something like that?

> +
> + * MMIO devices must be either unprotected (e.g. emulated by the Normal
> +   World) or marked RIPAS DEV.
> +
> + * MMIO devices emulated by the Normal World and used very early in boot
> +   (specifically earlycon) must be specified in the upper half of IPA.
> +   For earlycon this can be done by specifying the address on the
> +   command line, e.g.: ``earlycon=uart,mmio,0x101000000``

This is going to be needed frequently, so maybe we should explain in a
little more detail how we come up with this value: "e.g. with an IPA size
of 33 and the base address of the emulated UART at 0x1000000,
``earlycon=uart,mmio,0x101000000``"

(Because the example IPA size is rather unintuitive and specific to the
kvmtool memory map)

Thanks,
Jean

> +
> + * Linux will use bounce buffers for communicating with unprotected
> +   devices. It will transition some protected memory to RIPAS EMPTY and
> +   expect to be able to access unprotected pages at the same IPA address
> +   but with the highest valid IPA bit set. The expectation is that the
> +   VMM will remove the physical pages from the protected mapping and
> +   provide those pages as unprotected pages.
> +
> +References
> +----------
> +[1] https://developer.arm.com/documentation/den0137/
> diff --git a/Documentation/arch/arm64/booting.rst b/Documentation/arch/arm64/booting.rst
> index b57776a68f15..30164fb24a24 100644
> --- a/Documentation/arch/arm64/booting.rst
> +++ b/Documentation/arch/arm64/booting.rst
> @@ -41,6 +41,9 @@ to automatically locate and size all RAM, or it may use knowledge of
>  the RAM in the machine, or any other method the boot loader designer
>  sees fit.)
>  
> +For Arm Confidential Compute Realms this includes ensuring that all
> +protected RAM has a Realm IPA state (RIPAS) of "RAM".
> +
>  
>  2. Setup the device tree
>  -------------------------
> diff --git a/Documentation/arch/arm64/index.rst b/Documentation/arch/arm64/index.rst
> index 78544de0a8a9..12c243c3af20 100644
> --- a/Documentation/arch/arm64/index.rst
> +++ b/Documentation/arch/arm64/index.rst
> @@ -10,6 +10,7 @@ ARM64 Architecture
>      acpi_object_usage
>      amu
>      arm-acpi
> +    arm-cca
>      asymmetric-32bit
>      booting
>      cpu-feature-registers
> -- 
> 2.34.1
> 
> 

