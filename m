Return-Path: <kvm+bounces-45274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EF8BAA7C62
	for <lists+kvm@lfdr.de>; Sat,  3 May 2025 00:46:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 91604465BDD
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 22:46:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BB7A21CA1E;
	Fri,  2 May 2025 22:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VdaIQ9o0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239836EB79
	for <kvm@vger.kernel.org>; Fri,  2 May 2025 22:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746225988; cv=none; b=fZh3OOvO/kjzwLmdwBjRSTH8KtyJen4ctDml/DNYtT1y31zYnPqvlByUUEImZooTeqt0BimAnmDW7wAYShDnwtmvcA0OFVZ4AdW3ixqwF9TLK+XoIwh8w8x3QtZGv4jY+pKC0oMXgGs1adA7G9Pskm3OkFCN19kkoplp0yyBA/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746225988; c=relaxed/simple;
	bh=MohwM7fVbor2Vyoh5g3MSChXrAJLw55GPUSBDMuPcGs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PdoaMiiv857C0uejb8KWBDXomfWbPdgAS65x2ueNdS6k3xr2/fUexP7Lxcmzz59y/F6pc6UiIih1gx8f67C0HnV5f9JNltzwkTb0B8uOYZ7h3y1p6cnS7KExeP23vXmEfXGsSUR/yF8Zd8ZB0gS2NS7dgQoWN+NK3aXz+pVbJik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VdaIQ9o0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746225986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HBpwNFNUcKXm2mDG6MpS+gQbwBietEpngWQL4+w2ZxM=;
	b=VdaIQ9o0muyb3kx84nhRREkINiCtdPkYpFSqR/mUSKEnv0Os08JhfjQHEEgiCLE8eFPeOO
	oJN8i+Ib0aw9RWLw6xYLHu2pbqqZvgRmGyBx4xvTK5Gui4Kb9uUlcvpmeiZl5Z+nEavyQs
	aqvnMabT8vtNUC6lHBzMxVqYfvV+/gg=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-478-9xN5RwuKPWGE779-CmakvA-1; Fri, 02 May 2025 18:46:24 -0400
X-MC-Unique: 9xN5RwuKPWGE779-CmakvA-1
X-Mimecast-MFC-AGG-ID: 9xN5RwuKPWGE779-CmakvA_1746225984
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-47ae87b5182so52160231cf.2
        for <kvm@vger.kernel.org>; Fri, 02 May 2025 15:46:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746225984; x=1746830784;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HBpwNFNUcKXm2mDG6MpS+gQbwBietEpngWQL4+w2ZxM=;
        b=kPlKPsFA0rpno+yBkwmqHa6SlFKSrxRy6BqXYeXQFB4+n02udiyquBYgh/tJRc3Xi4
         AaG5e74cLvwPz+nQV09NJbpTzqGEFZtNklqg5yW6lvlq8fkI4VIBRYUhZbYBcdTw/Lqj
         BOA82BSqMOMBJFm2+AGLz1mrXYIsf++nh+LGgTXJRU0RL5bmBMc4VHcq48KOHxDdqaUC
         6rmHGNLicBA6K+L4FByQpl8jZpVkbd5qo5L21H2NeCaprTEiV/s0DwqLcPwkMis9u7mH
         Ptsx20IRz//4kDSGoXeYCnuR2s3IlsSRqq9+lNrcp6yaf1kCedsqzCuy8H/7TOY4DJ3y
         smEA==
X-Gm-Message-State: AOJu0YyjWSCgnJUnUJ3nAJB57MrCE1Z/Hwb27JZSGmptOyhgY0ztD+YN
	2iWTDFhBbdNVRUTzgUGULkmBmSSVvh0mhZ17rSr2t1jZq2Mhlffy9ZuYKbrZEN5YalDGXgpy1Ti
	esYLtInjkcxMTfenGhTiVzx0Nf072e8BDK0bsUAUN3zrD+4lxmg==
X-Gm-Gg: ASbGncsrLb5o85OJAaVDtcN8IXXEuxxkSg3JybBftRxBwXcXKNjplcy/w2ah4OyFUPC
	ikJKdHmypx2F0FYYyVlwYpkSs+qDeq9K3k8djl1FJ3AOdq0vK9gb38hhxJHRuKIjlupyxCeITOn
	S+PwZnaUrVmuqMrtGOnM7WhgI66CFVPYk0Hae6XjiPJyL01BveoSfTsLY4zvA0trStwJ9ghLRdS
	fDUJ0EWS2y7EXoAynpzY8hTSNOr7/xSV9nACtawrniBeVrfBgBPg66qURiH4aC29GwArOwwgqaW
	4Wk=
X-Received: by 2002:a05:622a:5908:b0:47a:e63b:ec60 with SMTP id d75a77b69052e-48c31c182d3mr79854221cf.27.1746225984213;
        Fri, 02 May 2025 15:46:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGUFR3XpnaIDy4pwFEqipRCtx1dBpoUtjuA3Eh3W7Ph6JfUfxzzQ94OxMVeRO2kYgTbY3OQoA==
X-Received: by 2002:a05:622a:5908:b0:47a:e63b:ec60 with SMTP id d75a77b69052e-48c31c182d3mr79854051cf.27.1746225983976;
        Fri, 02 May 2025 15:46:23 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-48b966d7907sm24561601cf.30.2025.05.02.15.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 May 2025 15:46:23 -0700 (PDT)
Date: Fri, 2 May 2025 18:46:20 -0400
From: Peter Xu <peterx@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Adolfo <adolfotregosa@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] vfio/pci: Align huge faults to order
Message-ID: <aBVLPAJVbyIrFjLS@x1.local>
References: <20250502224035.3183451-1-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250502224035.3183451-1-alex.williamson@redhat.com>

On Fri, May 02, 2025 at 04:40:31PM -0600, Alex Williamson wrote:
> The vfio-pci huge_fault handler doesn't make any attempt to insert a
> mapping containing the faulting address, it only inserts mappings if the
> faulting address and resulting pfn are aligned.  This works in a lot of
> cases, particularly in conjunction with QEMU where DMA mappings linearly
> fault the mmap.  However, there are configurations where we don't get
> that linear faulting and pages are faulted on-demand.
> 
> The scenario reported in the bug below is such a case, where the physical
> address width of the CPU is greater than that of the IOMMU, resulting in a
> VM where guest firmware has mapped device MMIO beyond the address width of
> the IOMMU.  In this configuration, the MMIO is faulted on demand and
> tracing indicates that occasionally the faults generate a VM_FAULT_OOM.
> Given the use case, this results in a "error: kvm run failed Bad address",
> killing the VM.
> 
> The host is not under memory pressure in this test, therefore it's
> suspected that VM_FAULT_OOM is actually the result of a NULL return from
> __pte_offset_map_lock() in the get_locked_pte() path from insert_pfn().
> This suggests a potential race inserting a pte concurrent to a pmd, and
> maybe indicates some deficiency in the mm layer properly handling such a
> case.
> 
> Nevertheless, Peter noted the inconsistency of vfio-pci's huge_fault
> handler where our mapping granularity depends on the alignment of the
> faulting address relative to the order rather than aligning the faulting
> address to the order to more consistently insert huge mappings.  This
> change not only uses the page tables more consistently and efficiently, but
> as any fault to an aligned page results in the same mapping, the race
> condition suspected in the VM_FAULT_OOM is avoided.
> 
> Reported-by: Adolfo <adolfotregosa@gmail.com>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=220057
> Fixes: 09dfc8a5f2ce ("vfio/pci: Fallback huge faults for unaligned pfn")
> Cc: stable@vger.kernel.org
> Tested-by: Adolfo <adolfotregosa@gmail.com>
> Co-developed-by: Peter Xu <peterx@redhat.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu


