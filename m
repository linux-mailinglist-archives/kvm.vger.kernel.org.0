Return-Path: <kvm+bounces-35527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E0470A12220
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 12:09:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34F461887844
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 11:09:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19FBF20CCD1;
	Wed, 15 Jan 2025 11:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AiNQ9ucK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B280E1E98EA
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 11:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736939363; cv=none; b=WmZMO5QrNACeaWiPaD0gu9kCKRjNxKaC1EdDyvnHL8X7AlsFvYaZNNcuoMKFh5qVhtbcpFWu1yHKjgNlkIfRVbK9llxxWGeDMhsQXI3d0qpAVZfQpgHz5XqBe1L1onvfAmbf1XyxVJAetoy6rp6yfolCbmF4kSTk0D4ucyBJC5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736939363; c=relaxed/simple;
	bh=PjbU3RZ1UQ8hHYSv91N25YkhJULshLv7+qSUMc1cLvI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cQTeJAsu6+mlLZOnGW0wutB8tt5wRnNQQHXB8459pV3LPWJq1nUP3ZNs6j1PilsN+2w/rRhulda3jVcQLKicC7P0CgKN+8UCI6BY+F/4s5SrJC5O746ue2RrZVw33ZXC4uwqSZyweOlm0WAXT5OU4KorI1xKwGXki9Wtdc7prDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AiNQ9ucK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736939359;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pp3W/euv0r0qhGV6FGZjL/PZ+k8+BYGIfdPd25Fr7yw=;
	b=AiNQ9ucKaA8L1oFdglNZ91hTTMPBp4LSzBZ/zaxiAmZ5h3MNN8YGiul7L2cP40RLQtCAkZ
	aUWtCnhbT8rHFPtiaFcSaroyPTaItWkkRWJswWIJU4O8D7yt7kHpMfY/Wr4pkZTN16AbDO
	01nTbAFjrYdQYFvctfIBn98gs7sbHyk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-170-eUy5kJMpNIWYDEqdHKSrfw-1; Wed, 15 Jan 2025 06:09:18 -0500
X-MC-Unique: eUy5kJMpNIWYDEqdHKSrfw-1
X-Mimecast-MFC-AGG-ID: eUy5kJMpNIWYDEqdHKSrfw
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-385ded5e92aso2428528f8f.3
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 03:09:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736939357; x=1737544157;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pp3W/euv0r0qhGV6FGZjL/PZ+k8+BYGIfdPd25Fr7yw=;
        b=UQ9nhbRQqaKeEV7ZDtxWYhDk1UKfkG9a/Oh4BQVs10abBgX2pibpBuBmbzzQEw70Wq
         ULENShj4jCgaGG1BRsV4swHh2rYHJgh+YYP5H/QIM6SuV7gmOt0L87Sqb2mzNFGIbFBv
         HZ82K8LfZ/ZGHjrfrquPjAdHRk5uOCMIHM+BVOhwNR1wTq+M6ZgeS7T3aSFQpwlbGnGe
         xYpAA75GmD5ohGQp4mqz/Mo0Qvz7CrfeWzP3Kj1B7ErPBGZELShrvAD63tTJb5/qugz+
         kD6q1/4NwundFbiQi+VQn5VNxR960zBlbxZ6o6CmP0HIQ/9p3nHo11LqUnoiWW6QqEl+
         UCSQ==
X-Forwarded-Encrypted: i=1; AJvYcCWK0W8NvNvuQVKsud1xYZkSnr3wS58tjYBXEL6RiGFFBQv7wg3AjbTjq+UEQvlFOiOhmnA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwrMzF2CI107VhmoJexi++4r7rpkgFXgNHipGtcHLLdDHhRFAz8
	DARMaF2kTd5kTduyWKkfY/MymkJav8n785i23DUkehY0cGG5EdBmicBiA3flpP55lwbhTHINgoM
	NINomWVnDZ0lny4xVb5KfSQ/OIqWZ7pgu2/rbRcYvIIrAZ8bFqA==
X-Gm-Gg: ASbGncvZoA8hGat5d7bqi1X6tPyI1schX6nWSUlFo+VxhMjJtqMXo0UCKi8vGJ7o6bK
	cYA4AEitYx2UOdEYkqH5Af4LQktPGPcWuoTJ0BOr4ejOwURfYEZYJVxAta8X/8qxwdKtkF2Etwt
	hO5B3pK0/j7SOPfh+sVoaO1Hv5z/J7csnUsNaB4Tir1Mlygm2CvieXMzIhZi71TRU+8xPsJdNaI
	3oWUj2DwpgW5MZJMujrf+6Ib7cQAzAb5IT66dcm+836vph4Kg==
X-Received: by 2002:a5d:6489:0:b0:38b:da32:4f40 with SMTP id ffacd0b85a97d-38bda325049mr10094366f8f.2.1736939357176;
        Wed, 15 Jan 2025 03:09:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGjBjZqwkDRHQGNQexbwma8Lf2w9a+i4uejIYX1kRhn6RIQ+2tRuMIzzsXS14AdA49ut5IGFQ==
X-Received: by 2002:a5d:6489:0:b0:38b:da32:4f40 with SMTP id ffacd0b85a97d-38bda325049mr10094332f8f.2.1736939356795;
        Wed, 15 Jan 2025 03:09:16 -0800 (PST)
Received: from redhat.com ([2a02:14f:1f5:8f43:2a76:9f8c:65e8:ce7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38be4222dcdsm3342117f8f.51.2025.01.15.03.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2025 03:09:16 -0800 (PST)
Date: Wed, 15 Jan 2025 06:09:12 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Shiju Jose <shiju.jose@huawei.com>, Ani Sinha <anisinha@redhat.com>,
	Dongjiu Geng <gengdongjiu1@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Shannon Zhao <shannon.zhaosl@gmail.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, qemu-arm@nongnu.org,
	qemu-devel@nongnu.org
Subject: Re: [PATCH v6 00/16] Prepare GHES driver to support error injection
Message-ID: <20250115060854-mutt-send-email-mst@kernel.org>
References: <cover.1733561462.git.mchehab+huawei@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1733561462.git.mchehab+huawei@kernel.org>

On Sat, Dec 07, 2024 at 09:54:06AM +0100, Mauro Carvalho Chehab wrote:
> Hi Michael,
> 
> Please ignore the patch series I sent yesterday:
> 	https://lore.kernel.org/qemu-devel/20241207093922.1efa02ec@foz.lan/T/#t
> 
> The git range was wrong, and it was supposed to be v6. This is the right one.
> It is based on the top of v9.2.0-rc3.
> 
> Could you please merge this series for ACPI stuff? All patches were already
> reviewed by Igor. The changes against v4 are just on some patch descriptions,
> plus the addition of Reviewed-by. No Code changes.
> 
> Thanks,
> Mauro


Still waiting for a version with minor nits fixed.

> -
> 
> During the development of a patch series meant to allow GHESv2 error injections,
> it was requested a change on how CPER offsets are calculated, by adding a new
> BIOS pointer and reworking the GHES logic. See:
> 
> https://lore.kernel.org/qemu-devel/cover.1726293808.git.mchehab+huawei@kernel.org/
> 
> Such change ended being a big patch, so several intermediate steps are needed,
> together with several cleanups and renames.
> 
> As agreed duing v10 review, I'll be splitting the big patch series into separate pull 
> requests, starting with the cleanup series. This is the first patch set, containing
> only such preparation patches.
> 
> The next series will contain the shift to use offsets from the location of the
> HEST table, together with a migration logic to make it compatible with 9.1.
> 
> ---
> 
> v5:
> - some changes at patches description and added some R-B;
> - no changes at the code.
> 
> v4:
> - merged a patch renaming the function which calculate offsets to:
>   get_hw_error_offsets(), to avoid the need of such change at the next
>   patch series;
> - removed a functional change at the logic which makes
>   the GHES record generation more generic;
> - a couple of trivial changes on patch descriptions and line break cleanups.
> 
> v3:
> - improved some patch descriptions;
> - some patches got reordered to better reflect the changes;
> - patch v2 08/15: acpi/ghes: Prepare to support multiple sources on ghes
>   was split on two patches. The first one is in this cleanup series:
>       acpi/ghes: Change ghes fill logic to work with only one source
>   contains just the simplification logic. The actual preparation will
>   be moved to this series:
>      https://lore.kernel.org/qemu-devel/cover.1727782588.git.mchehab+huawei@kernel.org/
> 
> v2: 
> - some indentation fixes;
> - some description improvements;
> - fixed a badly-solved merge conflict that ended renaming a parameter.
> 
> Mauro Carvalho Chehab (16):
>   acpi/ghes: get rid of ACPI_HEST_SRC_ID_RESERVED
>   acpi/ghes: simplify acpi_ghes_record_errors() code
>   acpi/ghes: simplify the per-arch caller to build HEST table
>   acpi/ghes: better handle source_id and notification
>   acpi/ghes: Fix acpi_ghes_record_errors() argument
>   acpi/ghes: Remove a duplicated out of bounds check
>   acpi/ghes: Change the type for source_id
>   acpi/ghes: don't check if physical_address is not zero
>   acpi/ghes: make the GHES record generation more generic
>   acpi/ghes: better name GHES memory error function
>   acpi/ghes: don't crash QEMU if ghes GED is not found
>   acpi/ghes: rename etc/hardware_error file macros
>   acpi/ghes: better name the offset of the hardware error firmware
>   acpi/ghes: move offset calculus to a separate function
>   acpi/ghes: Change ghes fill logic to work with only one source
>   docs: acpi_hest_ghes: fix documentation for CPER size
> 
>  docs/specs/acpi_hest_ghes.rst  |   6 +-
>  hw/acpi/generic_event_device.c |   4 +-
>  hw/acpi/ghes-stub.c            |   2 +-
>  hw/acpi/ghes.c                 | 259 +++++++++++++++++++--------------
>  hw/arm/virt-acpi-build.c       |   5 +-
>  include/hw/acpi/ghes.h         |  16 +-
>  target/arm/kvm.c               |   2 +-
>  7 files changed, 169 insertions(+), 125 deletions(-)
> 
> -- 
> 2.47.1
> 


