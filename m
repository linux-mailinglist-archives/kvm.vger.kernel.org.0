Return-Path: <kvm+bounces-66337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E808CCCFFA9
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 14:10:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4BF7D301585B
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 13:09:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E95FA328604;
	Fri, 19 Dec 2025 13:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MJV6u9Ih";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="RrcMQvTN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124322E9757
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 13:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766149781; cv=none; b=dxGvxkNj+F6vvs/bLeWq1sOAq3amaEPiI09CqJb5Qt2kspr5FzYcLbEUZBL2Gvl1wCzpT7g0wypdBtVYPnm1BtRrAR6J6STpEPE9kGtJSwIAtxZ7FqyCdufPEZm44+3dEtlR4gTBeAyvLLS3frrZJCNRtfO28SrOVReRke9mSrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766149781; c=relaxed/simple;
	bh=4y7H6oAhuM3klynkJSmlf0CbMc65ufhaxnucd+lng8Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nXO6kCla1QG8qc/Wwa+vNoMioP8+M1Du1mobiugJHY2v8lJSGWsUn02bJH2kHKy9+axuAP6PHb957dBbdMzkd1K6LewDsK50A6Es095A8Y8G0Hmlk90ZpRqo6lEGu0Xwf71VIHpJAWybbNA9nnGBB579u9fl96jXCgJkGAGcX90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MJV6u9Ih; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=RrcMQvTN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766149777;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uffUYzH4hZM4uYB5GjzxhfgSUKIVobgoDQM6/VUOOxo=;
	b=MJV6u9IhDMHtpRPg/8jHhdajd252cCy8ZivFVA335Njy1Ng/2oOkT3FATc7ZWayrPpkSkB
	EzKmBcJzf5esKZONjzdYCAn3cuF0LE1M2JiVwhxJQP1y/Dmuch4RzPm98cOLXRog3007e7
	yp52IjgSBzMpiGJXmpFaYGSx1yuPXNI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-30-hS3D53mXMYSPdb1E5swf-Q-1; Fri, 19 Dec 2025 08:09:36 -0500
X-MC-Unique: hS3D53mXMYSPdb1E5swf-Q-1
X-Mimecast-MFC-AGG-ID: hS3D53mXMYSPdb1E5swf-Q_1766149775
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-477a11d9e67so8628245e9.2
        for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 05:09:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766149775; x=1766754575; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uffUYzH4hZM4uYB5GjzxhfgSUKIVobgoDQM6/VUOOxo=;
        b=RrcMQvTNKtGMdRwpPnkQpw/a9wpxuztT+AF0KHNIOn1AwnAvbUzCBvnHCWFqbv9C1I
         JhFKb39hWzrdD1ktw7vUCn0GpdxbFo6z9yjITKqF4j6q5UrqyXM7RqoCfK0+0bgLuTlk
         tPbj7hjchyEQIEHAXDnXdQAd91edCDNsARWZfCORzRzy+o+uXr+Y9IGt5Me3h4E/kFHt
         5imL23Q7LpvKl1YmiZR9k5hQWzZP9SEuSTcvilOA80TZV3mIW4IPthWPN2DMWL6TQI5f
         67aMssFGZnWRZW4sECYqe7Nc7Kuqiw0i1f8R3TeKgrGxcuS/wboBBxPT6jUke7hKGwfB
         O6cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766149775; x=1766754575;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uffUYzH4hZM4uYB5GjzxhfgSUKIVobgoDQM6/VUOOxo=;
        b=VAD/Yuvg1FGuzPXpeiHhldreSFtfezIOGiiXzcyToPTcMWND+yAFG65NGOdMNOh3L0
         CDc6n5IUJCGz1yW4SOD2l11o4YfwdJyI4N5qkD4RdB6nwjhrmkjWDN2hGFNhRmBqJ5/M
         VH9S9e+LfhtPE3bU6Enfiq8zbAgrlX3Gwevzh+azrQnTbG5QB/UAcm0g8hwLcF9Thm6A
         9OS3TF9GF2Ar2frt3PD7o9GhbFbuK7KluItOvfVv01nLPJE+kiq/i/LVhWRV21s6f0r5
         yx8P/P5jeLl8sP+YuZsYwrwqQjQFCRUSQxYBQsIpkPYrqN40l0tdnBjwM8KnxayK34dv
         JKlg==
X-Forwarded-Encrypted: i=1; AJvYcCXE45E6g+sdM5m5oBksJAxBBm5TlmhsAvzvVmm8eJ+sILEbDvY0Fz2T3QdIY+srdxQ4etU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEF+tjEngLTDlWJQ97EUz/go4Yj6CGsp/AJZLDf4680fnVohkg
	B4TSs5FK/u1uyklcVUozV15rC5+6zHAbHe4KXQreuawJd1qJ/MWjU9jYVz6rEmCE6oyqZHJM4xg
	cjLb+Z/cdcwBhVIZNqmlTStzHZfYp16+9tDsYEpO8u2HW6zEuDBF63Q==
X-Gm-Gg: AY/fxX6GrhfwLPtZPIYmbZq0JEMObB9xR1IAbeLwO/w2XNryvUaA+qGg5hGFk7v9vQ2
	aplzylCXkcFh/3iua6skmydaF4xf1coZvJRPr9Oog16AGHel0oYfOVUpNfBnMnyYDClAXSOym7k
	J2cYCLlhek5rXojTNxPj41KjsCSr1Q/XEHZVKBH3xb5w3iOTo1q8kWgTndvKS+HXWisEx2ddH6K
	8J9I97MG+0vOhVs8sqDFJWutJMUls/Bf1267T8K2iUjKMEGNvdb4/4K60nAhzU65vGvByZ4OdZR
	qNlC9+lZIIma/eBjMcpdH/NUBF3EYYuIXU5kXr8tssX6WCZif6nPPq8f7LnaIlwyikEYpA==
X-Received: by 2002:a05:6000:2403:b0:42f:8816:a509 with SMTP id ffacd0b85a97d-4324e70492amr3602468f8f.62.1766149775432;
        Fri, 19 Dec 2025 05:09:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHunbsxrkvblgZHsEGkkAXpuWl8VogPXtLRDJCnAmHnAaCs1luS+kVWJ0dtZxScRakdkDjERg==
X-Received: by 2002:a05:6000:2403:b0:42f:8816:a509 with SMTP id ffacd0b85a97d-4324e70492amr3602430f8f.62.1766149774972;
        Fri, 19 Dec 2025 05:09:34 -0800 (PST)
Received: from imammedo ([213.175.46.86])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324ea82fddsm4861315f8f.25.2025.12.19.05.09.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 05:09:34 -0800 (PST)
Date: Fri, 19 Dec 2025 14:09:33 +0100
From: Igor Mammedov <imammedo@redhat.com>
To: Oliver Steffen <osteffen@redhat.com>
Cc: qemu-devel@nongnu.org, Richard Henderson <richard.henderson@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Joerg Roedel <joerg.roedel@amd.com>, Gerd Hoffmann <kraxel@redhat.com>,
 kvm@vger.kernel.org, Zhao Liu <zhao1.liu@intel.com>, Eduardo Habkost
 <eduardo@habkost.net>, Marcelo Tosatti <mtosatti@redhat.com>, Luigi
 Leonardi <leonardi@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>,
 Ani Sinha <anisinha@redhat.com>, Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>
Subject: Re: [PATCH v2 0/3] igvm: Supply MADT via IGVM parameter
Message-ID: <20251219140933.7b102fc5@imammedo>
In-Reply-To: <20251211103136.1578463-1-osteffen@redhat.com>
References: <20251211103136.1578463-1-osteffen@redhat.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 11 Dec 2025 11:31:33 +0100
Oliver Steffen <osteffen@redhat.com> wrote:

> When launching using an IGVM file, supply a copy of the MADT (part of the ACPI
> tables) via an IGVM parameter (IGVM_VHY_MADT) to the guest, in addition to the
> regular fw_cfg mechanism.
> 
> The IGVM parameter can be consumed by Coconut SVSM [1], instead of relying on
> the fw_cfg interface, which has caused problems before due to unexpected access
> [2,3]. Using IGVM parameters is the default way for Coconut SVSM; switching
> over would allow removing specialized code paths for QEMU in Coconut.
> 
> In any case OVMF, which runs after SVSM has already been initialized, will
> continue reading all ACPI tables via fw_cfg and provide fixed up ACPI data to
> the OS as before.
> 
> This series makes ACPI table building more generic by making the BIOS linker
> optional. This allows the MADT to be generated outside of the ACPI build
> context. A new function (acpi_build_madt_standalone()) is added for that. With
> that, the IGVM MADT parameter field can be filled with the MADT data during
> processing of the IGVM file.
> 
> Generating the MADT twice (IGVM processing and ACPI table building) seems
> acceptable, since there is no infrastructure to obtain the MADT out of the ACPI
> table memory area during IGVM processing.


looking at #2 and #3, it seems that root cause is still unknown,
one should be able read tables multiple times from fw_cg.
(so there is a but in QEMU or guest doesn't load ACPI tables correctly).

Also seeing that regenerating tables every time helps,
it hints that PCI subsystem is not configured when tables read 1st time.
Why that causes guest kernel errors is still unclear.

Main conditions to get acpi blob representing is that they should be read
after guest firmware enumerated/configured PCI subsystem and
firmware should use BIOSlinker workflow to load/postprocess
tables otherwise all bets are off (even if this series works for now,
it's subject to break without notice since user doesn't follow proper
procedures for reading/processing ACPI blob).
Hence I dislike this approach.

Alternatively, instead of ACPI tables one can use FW_CFG_MAX_CPUS
like old SeaBIOS used to do if all you need is APIC IDs.
Limitation of this approach is that one can't use sparse APIC ID
configs.
Benefit is that no QEMU change is required whatsoever.

If you still wish to proceed with standalone MADT approach,
please add to justification exact root cause of what corrupts
ACPI tables blob later on. With that, It would be easier to decide if
standalone MADT is an acceptable hack. 

> [1] https://github.com/coconut-svsm/svsm/pull/858
> [2] https://gitlab.com/qemu-project/qemu/-/issues/2882
> [3] https://github.com/coconut-svsm/svsm/issues/646
> 
> v2:
> - Provide more context in the message of the main commit
> - Document the madt parameter of IgvmCfgClass::process()
> - Document why no MADT data is provided the the process call in sev.c
> 
> Based-On: <20251118122133.1695767-1-kraxel@redhat.com>
> Signed-off-by: Oliver Steffen <osteffen@redhat.com>
> 
> Oliver Steffen (3):
>   hw/acpi: Make BIOS linker optional
>   hw/acpi: Add standalone function to build MADT
>   igvm: Fill MADT IGVM parameter field
> 
>  backends/igvm-cfg.c       |  8 +++++++-
>  backends/igvm.c           | 37 ++++++++++++++++++++++++++++++++++++-
>  hw/acpi/aml-build.c       |  7 +++++--
>  hw/i386/acpi-build.c      |  8 ++++++++
>  hw/i386/acpi-build.h      |  2 ++
>  include/system/igvm-cfg.h |  5 ++++-
>  include/system/igvm.h     |  2 +-
>  target/i386/sev.c         |  5 +++--
>  8 files changed, 66 insertions(+), 8 deletions(-)
> 


