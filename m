Return-Path: <kvm+bounces-67729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A7516D12912
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 13:35:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0BD77309955B
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 12:34:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83170356A28;
	Mon, 12 Jan 2026 12:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MkhsYEEd";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="SdpiOzSF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1960F2D7DD1
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 12:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768221282; cv=none; b=UjKUJOflzcI3BGct2uhwnb9r0IBQZ8+GRpvBhLVP2b6/SGMQkcI+4aAGfQloqngt0RonYrakB8Mtq9PxWDheoacz6YsdbPuPmscliVQ8aMK8c1LT1c3LfzxQZEdoMVzrKLPNswPXr/Zuvjpxs9Dv7NXNgUQKkXksGcuZHXppkvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768221282; c=relaxed/simple;
	bh=rGPSDgDO6c3sERLaoCCZTPj2kbYbLBUM8/oll2zoge4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r8LnApc0k9XeC+qduhZS3EYXU6rtYWFk5wAvSNnnGW+AfbreS/3mvJgXXJGDWD2FPow4AL3vrWH+xlsuoIqmwdUYtnNuLsZ7t7P5JoqhERQZsPgzBCSUNHFYZ5p0qt4NHZHqTvRqX2i9oCKcJATwWIucRQbbnvcTDn3g50k11Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MkhsYEEd; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=SdpiOzSF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768221280;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7LP28G4NUOFSwzs2iYvgDZdy+2UTu3gq6I+xV1I8lLw=;
	b=MkhsYEEd8rBCiuo5MXs/Sk7oDw+Av/Vg9qjUyFduRv1iCuZwRpVC+FmG85pieX5pQ+yu1d
	/7zSJntr1VKOUfw2Uw4LHv1MAVq6sv6hZoVcT7JhPSy4HkzDJ8HdMKZe5MiUIeufE5EMzM
	GU7yBlrFZnuiCUp3uRQT9wlWx5VOvFU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-7pRo5yWvMTy318wW8SIcCg-1; Mon, 12 Jan 2026 07:34:36 -0500
X-MC-Unique: 7pRo5yWvMTy318wW8SIcCg-1
X-Mimecast-MFC-AGG-ID: 7pRo5yWvMTy318wW8SIcCg_1768221276
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-47775585257so43976835e9.1
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 04:34:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768221275; x=1768826075; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7LP28G4NUOFSwzs2iYvgDZdy+2UTu3gq6I+xV1I8lLw=;
        b=SdpiOzSFFGRMVAD4SRDGziSM4lSDL5DZPPr0Iz16QwtjAGrt4TZz68EVOvcH+asO2j
         pfOnT2+a1hhqedpHJYc8PKREc22lBkl2eCR3NvD5bh1HyFv2NqOGzlsksbEDZMlfvfZj
         yyMjKKmN05yrLl47gprm9phOrzQTcfWb3ZZA2gSpsxXr0D3V9fg1ANHKLJkzTUOA1KFB
         k+aRP6psfrE37JdxCGj7BMQy6a0SHS6Gf4ORqjr1UglvDXfoZvO3/8wg1yrwAL+5FQnz
         oKfSOKsfyuJ/RXpGOYVDeeuDi67gRjtF3xYYapmwv6tgplGjVGkldobu8+TdAgsiap2O
         pDdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768221275; x=1768826075;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7LP28G4NUOFSwzs2iYvgDZdy+2UTu3gq6I+xV1I8lLw=;
        b=wU45+TuAP9dRqAOL5ZWyadSFMkpXnMkZLj1LIoiTIUk2KcUkFVnpzE7QyESZQY6gqQ
         9XkRag7UKx1hCC5xZEcXIPuK4wWEOxp/qzfPe6uy1t9bPpZ9+dMoy10aguMRY0l1J+Us
         IM7GGQAgnhsHrg0z2U4tEP+IK40dg7J4dtA+w/ZiOyb3/i/KiStxve7qkAR5yQKrhEO0
         9RXa9rkpkQXMYuo5rea3HhFMKhK5mBoqxyHXki1cDtZzh7OruYoL2hhxzg8VXaAkKzDO
         mSoQmegaFqNv8JQ0Sif1w4gOPB2d+nCv4rkzwgeLWH6Rw2CS4tqY5Y7yS1hzUt6fBtNi
         bnZg==
X-Forwarded-Encrypted: i=1; AJvYcCVDLLkJYkCuLPDRNpKsCZkQCJY4uhogtXBdeFfaUpdtkAMrEt9AFOLnbP6DaYv6HfnTie0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzlSHonvHEx+KiLddZ4DBKVZ11P4acmECJNhjbc/7Is4Jy52sw6
	nRkd+eTS9rGkTXnKIOuWXUEOVyBkxzou9A65YdG33W9PQXQebcRIX4FyPMQ6nNn/HZODwyJGBZU
	j9hSIrJn8FmybV4OBbBkhilqt0s1ex6TQNWKEy8/UdPOEciJ4f7X5NQ==
X-Gm-Gg: AY/fxX7LCEw0XubGjjzD1UZTSJ6RSr/cgNFC75XiyaGBC95OnRioTzqxpK0Xt4iGP9S
	0GLLYwntSGRykhodN0O0XIhRUZiiDVTDhLm8GZMNfIpSU+l1+5c3WgfU0xTATrxz51u/JRaBcBq
	VSzjH/LQXnKM/go5vXWm5GWToa0fzzaklm/qjzTcIAV9uOfltZXkRaQ4ulr5yOIce6/QrKjAAUW
	oHSFmyw9BD6XhAv+eAbBoaJHv8YppbDh48AMezPhWLXKgS3J9uwkDtbpwRnDHrUduKxX/v+Aa2Y
	1PuGJC/9eJIlYExMZOa1Ex3ZipS0DXHphecAxGIYgninXzSKGHDcOw9S9WpJAZdGjCvVvl9OGoG
	aZS4ajQRjTAlRIfkcJu/D3g==
X-Received: by 2002:a05:600c:19cc:b0:47a:7fd0:9f01 with SMTP id 5b1f17b1804b1-47d84b21227mr221225945e9.16.1768221275481;
        Mon, 12 Jan 2026 04:34:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHSIv/YVrI3F1CuJ1neX54aCZ2PcfOjaqDop2oAdNGNWB0y923eY7phci0m/71Xv8yG33sjWQ==
X-Received: by 2002:a05:600c:19cc:b0:47a:7fd0:9f01 with SMTP id 5b1f17b1804b1-47d84b21227mr221225515e9.16.1768221275033;
        Mon, 12 Jan 2026 04:34:35 -0800 (PST)
Received: from imammedo-mac ([185.140.112.229])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d87167832sm136279605e9.7.2026.01.12.04.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 04:34:34 -0800 (PST)
Date: Mon, 12 Jan 2026 13:34:32 +0100
From: Igor Mammedov <imammedo@redhat.com>
To: Oliver Steffen <osteffen@redhat.com>
Cc: qemu-devel@nongnu.org, Richard Henderson <richard.henderson@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 Ani Sinha <anisinha@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>,
 Luigi Leonardi <leonardi@redhat.com>, Zhao Liu <zhao1.liu@intel.com>, Joerg
 Roedel <joerg.roedel@amd.com>, Gerd Hoffmann <kraxel@redhat.com>,
 kvm@vger.kernel.org, Eduardo Habkost <eduardo@habkost.net>, "Michael S.
 Tsirkin" <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Subject: Re: [PATCH v3 0/6] igvm: Supply MADT via IGVM parameter
Message-ID: <20260112133432.0a1fb87f@imammedo-mac>
In-Reply-To: <20260109143413.293593-1-osteffen@redhat.com>
References: <20260109143413.293593-1-osteffen@redhat.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-apple-darwin24.5.0)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri,  9 Jan 2026 15:34:07 +0100
Oliver Steffen <osteffen@redhat.com> wrote:

> When launching using an IGVM file, supply a copy of the MADT (part of the ACPI
> tables) via an IGVM parameter (IGVM_VHY_MADT) to the guest, in addition to the
> regular fw_cfg mechanism.

I've had some questions wrt using MADT in previous version,
and possible ways to avoid issues.
not of those where addressed though.

So questions stay the same, see:
https://patchew.org/QEMU/20251211103136.1578463-1-osteffen@redhat.com/#20251219140933.7b102fc5@imammedo

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
> 
> [1] https://github.com/coconut-svsm/svsm/pull/858
> [2] https://gitlab.com/qemu-project/qemu/-/issues/2882
> [3] https://github.com/coconut-svsm/svsm/issues/646
> 
> v3:
> - Pass the machine state into IGVM file processing context instead of MADT data
> - Generate MADT from inside the IGVM backend
> - Refactor: Extract common code for finding IGVM parameter from IGVM parameter handlers
> - Add NULL pointer check for igvm_get_buffer()
> 
> v2:
> - Provide more context in the message of the main commit
> - Document the madt parameter of IgvmCfgClass::process()
> - Document why no MADT data is provided the process call in sev.c
> 
> Based-on: <20251118122133.1695767-1-kraxel@redhat.com>
> Signed-off-by: Oliver Steffen <osteffen@redhat.com>
> 
> Oliver Steffen (6):
>   hw/acpi: Make BIOS linker optional
>   hw/acpi: Add standalone function to build MADT
>   igvm: Add missing NULL check
>   igvm: Add common function for finding parameter entries
>   igvm: Pass machine state to IGVM file processing
>   igvm: Fill MADT IGVM parameter field
> 
>  backends/igvm-cfg.c       |   2 +-
>  backends/igvm.c           | 169 +++++++++++++++++++++++++-------------
>  hw/acpi/aml-build.c       |   7 +-
>  hw/i386/acpi-build.c      |   8 ++
>  hw/i386/acpi-build.h      |   2 +
>  include/system/igvm-cfg.h |   3 +-
>  include/system/igvm.h     |   3 +-
>  target/i386/sev.c         |   2 +-
>  8 files changed, 132 insertions(+), 64 deletions(-)
> 


