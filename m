Return-Path: <kvm+bounces-25780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DD1396A6CD
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 20:46:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9BD6EB24DFF
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 18:46:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51A4E18FDC3;
	Tue,  3 Sep 2024 18:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gREbXCKE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4CE18E030
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 18:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725389194; cv=none; b=iOVKUJBVfJpx/rWIuJTBe2PyRMPwk5KxBbtinWB14LAK16CX2j+8ZFE1JbAr3k1xlFugKS4jHO7rASBKV+ECSSTdKA5ObHV3p8ZEn7Tu8RWBoagGi+TlryktHk+MeOHC38kx/DTtbeAoNOaxuumtdAILwzQvafO+UgO3NYOrc/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725389194; c=relaxed/simple;
	bh=qlr0UzIGWr7ZF42VkXt/zM8XPz1u4cVgQIaq5NN9S1I=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nnKk5Dq04u3ZAoV7L+usPHs4VdwrZAoQDSB/4iO7DgHvMHopWmPm6UpmRuapXQpOYP1KgJzKxnkulqt/cJSjPxlURJ/Vj4CPTZ605xczDx2C39MG4dHLI24yz+4byhdkZoZ/JhGZN7cAI+WxvbnQx0A2FjtGxdf9LAvxfcY7qFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gREbXCKE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725389191;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TX06RE9IIMQkBQtApY9umtDfEHnu65wamVMOEuiSRS8=;
	b=gREbXCKEuF+Cjb62OxmAxfqXxJGTQiZ7hEwuQaNdYHpjER1FHtxSqlvF/RN1Cux33avb1R
	Vb010AgHSjPR2GDWja9zlrO6fyRT2gaE5IPc8I7BZcr/c2ONByNKaLjlYjFMPu472BmJhZ
	yZMjWLraervJkdVNlQbDg1q+FBCQ/G4=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-144-nAcWKA9EMLKmm4gQFkqI8Q-1; Tue, 03 Sep 2024 14:46:30 -0400
X-MC-Unique: nAcWKA9EMLKmm4gQFkqI8Q-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-82a5a149816so26475039f.2
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2024 11:46:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725389190; x=1725993990;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TX06RE9IIMQkBQtApY9umtDfEHnu65wamVMOEuiSRS8=;
        b=oJ5HWdmeji4A3QMY30I35WoiJvAQFetQRVWSkw1a11yA9oWg/ozI9Z3B6uEmZJzRfV
         mOkZGSVJOkjLX43a3qXipjhlfVJfYrD5w7FPRap8bqXq+/a1ih9Mi13Oc/JXpfYGlCma
         TC3Y1QpkFF8KioFacpxPLzNRYWvYcxPZlaZz6xcUhXeNCOBavI79rv2wz8mN3wEdvMgP
         s76KVJ2m4h5yP68nlGa/yfWfccoO8fHlMSGbabX+41UMiRwmgq18RKoNvBRwhrVdYY8/
         Ut25f5aCdTsRwTdrpVNu46IehaqD+ZLYJRoa3tGGdVecShR/tlwGgcDgXGVdB5nfD+WZ
         NAKw==
X-Gm-Message-State: AOJu0YwTJV47zn/m1y14dm0kmOE3EMM9WOHB99iCNzma97KGCwxCA1hk
	QxAYsX+amWS11xcaQbgSBsPkjQBdlfsCL/vivGTRjm2KHdG6hmMQ4tU+uBL62X+cRfXX3C3u5EU
	jDTq4WahBr4568L2wN9K7r/w93VkJiaDp1UrnVXIyYkqWG7WZGkZYVqb0Lg==
X-Received: by 2002:a05:6602:3f42:b0:81f:a783:e595 with SMTP id ca18e2360f4ac-82a26241b57mr913985139f.1.1725389189922;
        Tue, 03 Sep 2024 11:46:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGoJXozVoWgLgS3JiwXYuhacpU68uFJ1d2hQDqCtvpH5J5pnX5D04SqSj6U9xQ8HdLDB3uOTw==
X-Received: by 2002:a05:6602:3f42:b0:81f:a783:e595 with SMTP id ca18e2360f4ac-82a26241b57mr913983639f.1.1725389189552;
        Tue, 03 Sep 2024 11:46:29 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-82a1a42a0a9sm317624039f.24.2024.09.03.11.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2024 11:46:29 -0700 (PDT)
Date: Tue, 3 Sep 2024 12:46:26 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: linux@treblig.org
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio/pci: Remove unused struct 'vfio_pci_mmap_vma'
Message-ID: <20240903124626.3675ae86.alex.williamson@redhat.com>
In-Reply-To: <20240727160307.1000476-1-linux@treblig.org>
References: <20240727160307.1000476-1-linux@treblig.org>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 27 Jul 2024 17:03:06 +0100
linux@treblig.org wrote:

> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> 'vfio_pci_mmap_vma' has been unused since
> commit aac6db75a9fc ("vfio/pci: Use unmap_mapping_range()")
> 
> Remove it.
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index ba0ce0075b2f..2127b82d301a 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -57,11 +57,6 @@ struct vfio_pci_vf_token {
>  	int			users;
>  };
>  
> -struct vfio_pci_mmap_vma {
> -	struct vm_area_struct	*vma;
> -	struct list_head	vma_next;
> -};
> -
>  static inline bool vfio_vga_disabled(void)
>  {
>  #ifdef CONFIG_VFIO_PCI_VGA

Applied to vfio next branch for v6.12.  Thanks!

Alex


