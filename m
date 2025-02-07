Return-Path: <kvm+bounces-37547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 357BAA2B804
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 02:40:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34EB0188944E
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 01:40:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B8C5154439;
	Fri,  7 Feb 2025 01:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="nCh6LIlO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B363313C9A4
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 01:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738892374; cv=none; b=gg2dZ2LG+CatvM3Y4u2BQTrmTrz+n4tcR5LtX5CK4/25d6HzthxdIddwONO60Soqc9ZL+MQOLmKrFtmPjU7AMcSBxfUNtC5x+E2OCghoe4NGglsJf7N+ASakSTirhlX+jdGFk+E0Lv1tzbuHcwMQTgnuSZUQiphdMosl7tr61iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738892374; c=relaxed/simple;
	bh=rg6h9j7hSsRLDKpQBSBgp1rUA118C4HJT6vOUsNHgJw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rNT4Ga9xIoWWLUKzTpBZVFUEj3KBZ92zYTSi5vj8GecsrupPWeN+8+lYqwihsegM4GXWFWSKQsB3bI7JrCU1ukTdcWPlIv/LVVmj/Sv3BWKyvYKt7rrbQDr4TUezlw897kB9EdQvG37JxUKUdENvuw5n8sAi7wG094/wFOZMTCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=nCh6LIlO; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 388FB3FA55
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 01:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1738892371;
	bh=b1dO1A4fPI5eS8WT6hBCvAO68gaA09DjpLJhuG6VUwI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=nCh6LIlOnjgqqeP9LxXFZRsOb9TUbGy6sVjP5vVSIbwjloFpe15NSIIKLBjRlAzzQ
	 FDeudwsRRE/+qb5s/G4XpdQvTVEloNOogMMApLwQzcVMa9OD2txBQ8vMt90iV+iSbF
	 HWbi13C/SQ10L0+Hh94a/wl8Iw8fJroq5fGGsn3gAbv8IYFljLWUEombSoOpg6HA4t
	 UEQrigZ2UL0oj7zeELSud4T1+tf/0d614ggd2BkBlnikhrDM5s1AiKH3VZ/nOL5QrL
	 IObnomQdfTVqFm+SorR+4GxzYJeXqf3xRNPP5YY986ClqPq8I5on/qBltuD0Aj7bzS
	 sqL99U3opna6w==
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-5d9fcb4a122so1826538a12.0
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2025 17:39:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738892370; x=1739497170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b1dO1A4fPI5eS8WT6hBCvAO68gaA09DjpLJhuG6VUwI=;
        b=MblYEiXPvYn7hSa71zPF5fvCXl2PZ8Y+G/OfLJi904g6bQswAqeHScIpxRsWkO9gBe
         bIv6hNFaVHPsX4N+1Fbrq+LBF8TNQcYS/7+kEumbyMJBbKcHGLYHUXZzQv7OspRfao0f
         YUAbE23jk+vbz95GW4udyIi04WIdzmyoK+z4QBAjfNxb7DyAEoTDyNHLspk4WN/i+NcB
         2HhlxC8AzHLzrnt9kA787GyLHI76TScS1gvKHFP1FIzzVX8fNkFQu32XtqCD7nbER1gg
         sn9Ly4xQgOsmVicVjZpoZQBBuHoh6md3OkWEX/6wwaLwStN8V+wuFaNltwAhq0McJn4j
         yfkg==
X-Gm-Message-State: AOJu0Yy6l/vTd5loKspb6Taj+f4KZjcYyBjlFmlbgaSaQBEBDdPnboLy
	29c8bwb/G96dlYEC4Py89sIIqdqsBvl08VZkDx2cpjTOuBm23hn3pdiiBe/eOR7bZTlHcfV6374
	BQjyEM+GXZ73verVttYb9a1PH7rlsVornFUoEuoyGVi6+6VyqoKjU3bUuL1CIQCe2irnEFewo4h
	b95MN05boT/wNlyBp8TOg5xVxCFtxrf7wghOthdWoK
X-Gm-Gg: ASbGncv/3QMgAokYButML5K57Dul4N2yp3pFUvROunZh1RfinVqr31PKJt6bLaQAFuM
	yQrUBacbykcojI7T5zswII2hILaG8MpoUjvV3doaW8mGhaaeTsKtWuw91J3JS
X-Received: by 2002:a05:6402:c4b:b0:5d3:e766:6143 with SMTP id 4fb4d7f45d1cf-5de4509b566mr1816319a12.30.1738892370716;
        Thu, 06 Feb 2025 17:39:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEA1P4T7CyKNlBjCPd3feXPu3bSKDsKVxl2JRQltjEhhWAvnx988Pg7gPW3EJvoLdjd/bz9pbKIj2MWA4uYR6c=
X-Received: by 2002:a05:6402:c4b:b0:5d3:e766:6143 with SMTP id
 4fb4d7f45d1cf-5de4509b566mr1816302a12.30.1738892370367; Thu, 06 Feb 2025
 17:39:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250205231728.2527186-1-alex.williamson@redhat.com>
In-Reply-To: <20250205231728.2527186-1-alex.williamson@redhat.com>
From: Mitchell Augustin <mitchell.augustin@canonical.com>
Date: Thu, 6 Feb 2025 19:39:19 -0600
X-Gm-Features: AWEUYZkVdVSE3YCdOATSd_ps38BYnjbfjtvXK9l_0oGFFYSaahc9EADcxC_JmYI
Message-ID: <CAHTA-uajC=5ou5dixDkhF-Fwibyk23vCykxwtFquCnZJW+hwvA@mail.gmail.com>
Subject: Re: [PATCH 0/5] vfio: Improve DMA mapping performance for huge pfnmaps
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterx@redhat.com, 
	clg@redhat.com, akpm@linux-foundation.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks Alex, this all looks great to me and completely eliminates the
boot time slowdown I was seeing in my tests on our DGX H100 and A100.
I also double-checked the memory mappings reported in /proc/iomem, and
everything looks consistent with how it was prior to this series on
both devices.

Reported-by: "Mitchell Augustin" <mitchell.augustin@canonical.com>
Reviewed-by: "Mitchell Augustin" <mitchell.augustin@canonical.com>
Tested-by: "Mitchell Augustin" <mitchell.augustin@canonical.com>


On Wed, Feb 5, 2025 at 5:18=E2=80=AFPM Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> As GPU BAR sizes increase, the overhead of DMA mapping pfnmap ranges has
> become a significant overhead for VMs making use of device assignment.
> Not only does each mapping require upwards of a few seconds, but BARs
> are mapped in and out of the VM address space multiple times during
> guest boot.  Also factor in that multi-GPU configurations are
> increasingly commonplace and BAR sizes are continuing to increase.
> Configurations today can already be delayed minutes during guest boot.
>
> We've taken steps to make Linux a better guest by batching PCI BAR
> sizing operations[1], but it only provides and incremental improvement.
>
> This series attempts to fully address the issue by leveraging the huge
> pfnmap support added in v6.12.  When we insert pfnmaps using pud and pmd
> mappings, we can later take advantage of the knowledge of the mapping
> level page mask to iterate on the relevant mapping stride.  In the
> commonly achieved optimal case, this results in a reduction of pfn
> lookups by a factor of 256k.  For a local test system, an overhead of
> ~1s for DMA mapping a 32GB PCI BAR is reduced to sub-millisecond (8M
> page sized operations reduced to 32 pud sized operations).
>
> Please review, test, and provide feedback.  I hope that mm folks can
> ack the trivial follow_pfnmap_args update to provide the mapping level
> page mask.  Naming is hard, so any preference other than pgmask is
> welcome.  Thanks,
>
> Alex
>
> [1]https://lore.kernel.org/all/20250120182202.1878581-1-alex.williamson@r=
edhat.com/
>
>
> Alex Williamson (5):
>   vfio/type1: Catch zero from pin_user_pages_remote()
>   vfio/type1: Convert all vaddr_get_pfns() callers to use vfio_batch
>   vfio/type1: Use vfio_batch for vaddr_get_pfns()
>   mm: Provide page mask in struct follow_pfnmap_args
>   vfio/type1: Use mapping page mask for pfnmaps
>
>  drivers/vfio/vfio_iommu_type1.c | 107 ++++++++++++++++++++------------
>  include/linux/mm.h              |   2 +
>  mm/memory.c                     |   1 +
>  3 files changed, 72 insertions(+), 38 deletions(-)
>
> --
> 2.47.1
>


--
Mitchell Augustin
Software Engineer - Ubuntu Partner Engineering

