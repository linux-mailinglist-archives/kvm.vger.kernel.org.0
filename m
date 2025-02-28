Return-Path: <kvm+bounces-39740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B33B6A49EEA
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 17:34:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0B874189AD9A
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 16:34:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BB01276041;
	Fri, 28 Feb 2025 16:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HEYO8hbN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C27254861
	for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 16:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740760363; cv=none; b=WrFmgHzNaNPFgZyf0iLXZIAfWuE/vALDCrxKVFEbv6KK+33UVqv8EAZTILK+BlGiJ4ttJSPb2HBIADds50a8pAmxQCvn6AhrD9qILHlRw2JDolXEWfpacxW61VDG7Dw8gzeHjZOgQaQZohGN/TXsCkOlf8KdvxzGvRIipm0a8lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740760363; c=relaxed/simple;
	bh=5S1C6+wr8GrU2eVbvvKeo8m0srDxNtxTZ1gK9o+lW4E=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kN3PhOaJHfC+r6Yh71+BCt3j5x3jhVGzR8QYBhYMO+yqOZ/7gA2puSc9BgZWPQt/H2sYgCLypDC9u7rRoil1lrgQlGoS2wi7k4XqoiW+2X+5P81dl99GQN4mZpUZApcVmJBhWN/NfOAZvRz+P4kQKre6oyVABwLximvO3sJxT1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HEYO8hbN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740760360;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dmEeb9lKrGzm9PpnwIENCXTvdUKNgeT1Zk6eq2x1XqY=;
	b=HEYO8hbNdHiWYxIJOBgaNNLV8+Uh+RJpnUyDZghzAqF+a8l9ohbkk2oVrQO7kBiXcUJGJs
	HhhmUVf8FXmh90Hs+hAcoOtUhxMgNHxO3VHrt5PsTtpeRc7XN9cpwXuGtbf6Rfyo9ZY4mu
	u54RKBTbHnYnbC1M72pWVrM1XZJPiZE=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-GGALGV_FOeeabo21liFC5Q-1; Fri, 28 Feb 2025 11:32:37 -0500
X-MC-Unique: GGALGV_FOeeabo21liFC5Q-1
X-Mimecast-MFC-AGG-ID: GGALGV_FOeeabo21liFC5Q_1740760357
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3ce7aa85930so1763655ab.2
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 08:32:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740760357; x=1741365157;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dmEeb9lKrGzm9PpnwIENCXTvdUKNgeT1Zk6eq2x1XqY=;
        b=YP3OI9uUcp69ryJsGOha6gQhpqfkoeo8zvyw1jW6RwHgvcFQ5r2PT47CW27jkuUwpN
         yAVrnGP0qs29S67IXmeMLpytA+WUlU0ERmT5Q7B00EM3dXNMx8Oi58aabT3tbfUVfvPw
         nKVifUj7rtt7TiW5i+s5JXgQ3DyvoEeh6f8kkgVy7z/E645ItCgFpEPCQvlHY+Mn2CPV
         XGdY/EuifmQLy6ruqF1BP41gtdtMQfbQG9OZ+nXomgyAhU531hiShvhZ0T+Uo0OOFRZe
         zU0HI6Mu1aI9Pc+MBnAVIJVqbTZJVmeogsCyOO3b0/mcxOWq1zaUS0ce1vdSYS+FV6pb
         PuwQ==
X-Gm-Message-State: AOJu0YwoXMTKa6ueX7IBqsNw4n5/VMtTJDSWhrzwPQOeMettbFrgACnu
	WinHASU1nlZOvX8OGnkNV3ber8ENLL9zkHF7eSzD5h1TYBIC4csB+32EkORtrQrmbbGBD4PESDB
	j7MO0+yU0E1mxcLKl7QFfdPgpb5Kbs73gUSeC0ugrBxB4X074EA==
X-Gm-Gg: ASbGncvYq17H+PwpOmzjHn/5b+OuZtu9KW4HQFv+GWcAVBzBESnLGHxlkM81coRFEbd
	hCitePtyWz8RcLDo8VOa0LmP7qT1SGDH3TdVOgvSBCDn7qGyN5+yP8Xpj9Lsb5S8d/Dbv4Ho4vd
	rp/PZUO7YgS6m7bhCmuYBcwe62fcUWeJfwmYtZesVhiLYgfMXVKcCq9NtSR3CaPMe3Q7waXj6Nm
	imtsfbWsFtaVbSD7H8qje/l1I7vdEbnJ/Rji45nVUz3yvVgGV1rZQWSdmYDL+g/hOSDOKYA2AEk
	hJaXr1onHlpKNGb3+w0=
X-Received: by 2002:a05:6e02:1748:b0:3d3:d156:7836 with SMTP id e9e14a558f8ab-3d3e6f97e8bmr12715855ab.7.1740760357000;
        Fri, 28 Feb 2025 08:32:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH1OqqoD77aeXTkALnv9pFGNxbF4QLi2N/iLQZh/bOT8+63cQ478MEpB3v7yPmmrcMIMSMziQ==
X-Received: by 2002:a05:6e02:1748:b0:3d3:d156:7836 with SMTP id e9e14a558f8ab-3d3e6f97e8bmr12715695ab.7.1740760356621;
        Fri, 28 Feb 2025 08:32:36 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d3dee6ff9fsm9202015ab.32.2025.02.28.08.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 08:32:34 -0800 (PST)
Date: Fri, 28 Feb 2025 09:32:31 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterx@redhat.com,
 mitchell.augustin@canonical.com, clg@redhat.com, jgg@nvidia.com,
 akpm@linux-foundation.org, linux-mm@kvack.org, david@redhat.com,
 willy@infradead.org
Subject: Re: [PATCH v2 0/6] vfio: Improve DMA mapping performance for huge
 pfnmaps
Message-ID: <20250228093231.338c9f06.alex.williamson@redhat.com>
In-Reply-To: <20250218222209.1382449-1-alex.williamson@redhat.com>
References: <20250218222209.1382449-1-alex.williamson@redhat.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 18 Feb 2025 15:22:00 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> v2:
>  - Rewrapped comment block in 3/6
>  - Added 4/6 to use consistent types (Jason)
>  - Renamed s/pgmask/addr_mask/ (David)
>  - Updated 6/6 with proposed epfn algorithm (Jason)
>  - Applied and retained sign-offs for all but 6/6 where the epfn
>    calculation changed
> 
> v1: https://lore.kernel.org/all/20250205231728.2527186-1-alex.williamson@redhat.com/
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
> [1]https://lore.kernel.org/all/20250120182202.1878581-1-alex.williamson@redhat.com/
> 
> 
> Alex Williamson (6):
>   vfio/type1: Catch zero from pin_user_pages_remote()
>   vfio/type1: Convert all vaddr_get_pfns() callers to use vfio_batch
>   vfio/type1: Use vfio_batch for vaddr_get_pfns()
>   vfio/type1: Use consistent types for page counts
>   mm: Provide address mask in struct follow_pfnmap_args
>   vfio/type1: Use mapping page mask for pfnmaps
> 
>  drivers/vfio/vfio_iommu_type1.c | 123 ++++++++++++++++++++------------
>  include/linux/mm.h              |   2 +
>  mm/memory.c                     |   1 +
>  3 files changed, 80 insertions(+), 46 deletions(-)

With David's blessing relative to mm, applied to vfio next branch for
v6.15.  Thanks all for the reviews and testing!

Alex


