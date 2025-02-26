Return-Path: <kvm+bounces-39361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 548CDA46B73
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:54:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 05235188B7C8
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 19:55:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3E88256C75;
	Wed, 26 Feb 2025 19:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BYcheDTj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5530721CC66
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 19:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740599684; cv=none; b=XNEGIlp5eXJWhk0jEU8z6a+B93N9qHViHpBwOAO3kJjKezpaerMdOFouaJpTvMrU386jiFdjrP48kokW4IlY5nMTxAjcDUfy2aW26Mk4m+kEG/XOIQv0NeKMEhTsCoqs0Z6aRLnoifVDSQ8U+FcJY3vwSfkYI/CXzqrmTmzuBJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740599684; c=relaxed/simple;
	bh=I1DgX0bKdJT4CKwl7qSHDNaLttfQs1tX87g++C7xQIo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tpGcAtWamENqpw87e00Kr2TnVcV36medi4fx+0/FkCNz7MvjD46xMuUqH7e626ug1JDGA01auntdz5uuJUUlbNcNjaWENqePTofTqDIZFcuWGlg65XXuQKa70aKJv1KUdiGCuPsPp7mbrpvsZlPsggJlNRuVMRTj0Oo/RIUTIr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BYcheDTj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740599681;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=REreCuTx0gkwci3At+fSClZQOC45yVa1FO0Hyxdtpqc=;
	b=BYcheDTjU3wRdwrX/Nt6rAQHIMAdFtk388nKQO+XlNbXgBGxigKoZSLHa69GGIfOdfbixH
	DQlrpqBUu8sWPWrWz2FK51RUvTr/ltON8pEsLu+seWTrsbGF8z8ucoVGvxZnB19e5S7kjo
	uXYWBMsyiyrT1lI4kYy6Z3jjEagNm4c=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-JY_IsPCAO6CW0zvbA3YrSA-1; Wed, 26 Feb 2025 14:54:39 -0500
X-MC-Unique: JY_IsPCAO6CW0zvbA3YrSA-1
X-Mimecast-MFC-AGG-ID: JY_IsPCAO6CW0zvbA3YrSA_1740599679
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-855b7b526fbso2737639f.1
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 11:54:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740599679; x=1741204479;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=REreCuTx0gkwci3At+fSClZQOC45yVa1FO0Hyxdtpqc=;
        b=U44bfzvBRcrPnospInXnk6QsILWQ6QvQG7Cc3p8M4hg8kzltdf8aaAm93xyvItAXV5
         qnHzSin6SW4FyZ5/ilWj7v9VBHr8NA5W+QGiZ0uOnXMW68HN3QeDpZ1s1fhR0IxAZJEr
         CvE17BAmJv3KYxLQ/DPCwWKzO7TROCKfc/Nb5nQPauBcTIEbps1F3l8IAD/AVlSI0hyT
         2t1+vRpAv+x+wS129ma4/qf4wP4FVombaRrzh/ALTrMs2UafEFmQU3d+zNGkLb+JkGZv
         o1zptr5U99zOxrUicPYQMlxfuC3/GM8pSLa/FekeBWFgJvGTY+yITUjJ/J/cvo1063Sw
         ANtQ==
X-Gm-Message-State: AOJu0YysDfbKNNKCdksndHtbJfIsDn+95BzGXU6T15cam0BrfQK5j6q4
	pqDvBWnVJvc0YuXxkkENVaMqKuEC2rGWlCXfcejIozOpz1nrnlYAIUORsG40H/4bq3rYqH9/Sb/
	A3MAoTv/YoAHwvLgi0693qfZYjU6dL0+lrb4ZUn03GKoOt2dTOA==
X-Gm-Gg: ASbGncuWm5BfsU9ub+x3or4CqHK73YlV+ecaYuEHANF+A+eSsixystBAUwHt0h1SD0H
	KhZj82iw67LOpWnIHEOaVcPmpBOZz0/29G6sE2nMVbwvhdEds6C+mWRV05//I7rU6Xr3/5ZveoI
	bTmOot1bYCSuKBFtei3lUYnzdnReRvAuYC7TWP5dRXSEXMajFTMh8dtoxA/ohy/23aEyWo7YTfv
	ZjUyUrGhdnWEgIF/kiWFs3WP2Hhw5cRbgi9x9iAnbZxDwF+HEK8Tp+wPauJ/qmRfz0ew6CnrA9/
	oFp+RU7vAc1Vh+4eDt4=
X-Received: by 2002:a05:6e02:138b:b0:3d2:b808:6af7 with SMTP id e9e14a558f8ab-3d2caf029dcmr52169185ab.3.1740599679160;
        Wed, 26 Feb 2025 11:54:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGclZdN5ci9WTASTIbwQPB6JRSCol267p3y7JPBzh5FgUw4I41vL0bfqhosjvVDmk9CT8cKjA==
X-Received: by 2002:a05:6e02:138b:b0:3d2:b808:6af7 with SMTP id e9e14a558f8ab-3d2caf029dcmr52169055ab.3.1740599678746;
        Wed, 26 Feb 2025 11:54:38 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f061c513fbsm949173.51.2025.02.26.11.54.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 11:54:36 -0800 (PST)
Date: Wed, 26 Feb 2025 12:54:35 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterx@redhat.com,
 mitchell.augustin@canonical.com, clg@redhat.com, jgg@nvidia.com,
 akpm@linux-foundation.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 5/6] mm: Provide address mask in struct
 follow_pfnmap_args
Message-ID: <20250226125435.72bbb00a.alex.williamson@redhat.com>
In-Reply-To: <3d1315ab-ba94-46c2-8dbf-ef26454f7007@redhat.com>
References: <20250218222209.1382449-1-alex.williamson@redhat.com>
	<20250218222209.1382449-6-alex.williamson@redhat.com>
	<3d1315ab-ba94-46c2-8dbf-ef26454f7007@redhat.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 19 Feb 2025 09:31:48 +0100
David Hildenbrand <david@redhat.com> wrote:

> On 18.02.25 23:22, Alex Williamson wrote:
> > follow_pfnmap_start() walks the page table for a given address and
> > fills out the struct follow_pfnmap_args in pfnmap_args_setup().
> > The address mask of the page table level is already provided to this
> > latter function for calculating the pfn.  This address mask can also
> > be useful for the caller to determine the extent of the contiguous
> > mapping.
> > 
> > For example, vfio-pci now supports huge_fault for pfnmaps and is able
> > to insert pud and pmd mappings.  When we DMA map these pfnmaps, ex.
> > PCI MMIO BARs, we iterate follow_pfnmap_start() to get each pfn to test
> > for a contiguous pfn range.  Providing the mapping address mask allows
> > us to skip the extent of the mapping level.  Assuming a 1GB pud level
> > and 4KB page size, iterations are reduced by a factor of 256K.  In wall
> > clock time, mapping a 32GB PCI BAR is reduced from ~1s to <1ms.
> > 
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: linux-mm@kvack.org
> > Reviewed-by: Peter Xu <peterx@redhat.com>
> > Reviewed-by: "Mitchell Augustin" <mitchell.augustin@canonical.com>
> > Tested-by: "Mitchell Augustin" <mitchell.augustin@canonical.com>
> > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---  
> 
> Acked-by: David Hildenbrand <david@redhat.com>

Thanks, David!

Is there any objection from mm folks to bring this in through the vfio
tree?

Patch: https://lore.kernel.org/all/20250218222209.1382449-6-alex.williamson@redhat.com/
Series: https://lore.kernel.org/all/20250218222209.1382449-1-alex.williamson@redhat.com/

Thanks,
Alex


