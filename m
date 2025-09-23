Return-Path: <kvm+bounces-58435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ABDEDB93D15
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 03:18:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 64CFC17FE51
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 01:18:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAADD20458A;
	Tue, 23 Sep 2025 01:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d6JQygw4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792671E1C02
	for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 01:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758590265; cv=none; b=UhE1X8KCzelPMkSFAv/uPaqttpot2AsYacPLboRmh8vkNgQXDE/36xIyPCBcKtZOMLjR4XkBGlqwEqxFUj5roP5FQHd5eBNf8IEGomE5F48XRmy5gIMSl0gghgzBSrvl+JDlLkQgoTD9DEKeEyQKBX8i/m9bI+pPEoFLZKZTR7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758590265; c=relaxed/simple;
	bh=1/e3AyiZPS/c0G1aMUyRNLYzo4gjhYckdUnHLFkO2mw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cvjy2vemixejSQawgNcmcKDC2xIgoPwaPEAC9jMV4/CFVUb0UhCbDW5R9UYOdNbD6qI1igqvJdGvNcIQdHTPn3VSjchrnub0zVj4gamJSW39x0I7dGPyL4WEAfCdf4k0PIwDaZp1CeecVcv6CiJ6J6QcZvUw1VFskSG2r2+UIdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d6JQygw4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758590262;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ut+zQ+Ol2AC0M60Dd4+aidn6RjiEypu7DiFVdYxlNks=;
	b=d6JQygw4nT3nPSBkXQHm7Bbzxs1a6F+jz+TOUYbgFulGFMFQp1S14AwACz1AJ1fjph9gSa
	sKYfM65WIm/2CpXVoIGsnM+cJCeXepqbGpMaIMwtWtBGpsqM6BrqL88A7xff8FnLU8RkTv
	Lq3VXGDld2onzP6NL/HlbuQFcPsdudA=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616-r-jh2EYuOUOTnlhGFd9cRA-1; Mon, 22 Sep 2025 21:17:40 -0400
X-MC-Unique: r-jh2EYuOUOTnlhGFd9cRA-1
X-Mimecast-MFC-AGG-ID: r-jh2EYuOUOTnlhGFd9cRA_1758590260
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-34102441bc8so578051fac.2
        for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 18:17:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758590260; x=1759195060;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ut+zQ+Ol2AC0M60Dd4+aidn6RjiEypu7DiFVdYxlNks=;
        b=v7eU9lUyW9RF5g0vpENPTVRpppi1LvxOAPa6GIWDfMTLcV+a+UsAxfuZO4lgEer/es
         rC6smt2V7z7pS/yhWZ6pfdXVMPa6zO0o/XDOfzhk1m0idFCcLAPqKDInqebUTaUM7hIE
         +MSUyIpKG638I4wfmxcCVonJMHLkI69uhmaNZgFjxbyGVuZDj2pVnH9dZFLDvprOkoss
         CmJxApKKp9mInedNYGjTrBEjFPdn9AA9I7n5eJYwVn+VFBIshNyPn8VnE5i4j3ooSzvJ
         /1A4McSbU/MZlCD/IVTYE0j2356XVH2hsV13ILp2zZOOJeaC9KoEoh7F+SpQtgattFmB
         MoXw==
X-Forwarded-Encrypted: i=1; AJvYcCXmvvHlGOVkHOcNxA740sN77UfgblxkSdPOPD3m0qsZJck/UooH3FPVHI4HvyAysYw7h/o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2YBs6LSwnLxoJOXOkUOYmp+rp4NVdt8AfAA1aSJ/Cjo/rS2LM
	rS3Dg8AhT1F2Tv44iZ/exzNhecxjLg3W5rB0hlWQdfx0ziqRYcICES4yeSafyFW/lRyYFjy3T8o
	ofSJ1vHpUkRWzUtrvoc+YDQKNjOFUQfG3hpHuzMCFaldw42C/kSDpmA==
X-Gm-Gg: ASbGnct0SJCDIIE6g6bQ+Se67nIT/YP6jNhj6nPsdrFehTDHnox9m1EocI2PD6FKZzW
	QJs33hklgFDdPMG8iWHc7yhdcjGFa+EX/zOvd0ZpzMDzWqtv+PfhViTQRTAwX4dv6BYlsTjznjE
	FKaKNK5ZICOCFW7A1AcQ+hC5FpMLVUnBus6B1iwvtZHt7RHWcOlS4SQG8cJBc3Knif1IHrw6eIb
	cX+w88fJriduSR5dhwndYWMnhpYwwVXccvKqAxCbkbGbxd8MgDo7wic5oPScObiIVAVW6Iua1c4
	zur81rRbuOPJs3BsRxnm+nnRcZ1nT7QbbpQzVwumvJw=
X-Received: by 2002:a05:6808:308d:b0:43d:3c37:a342 with SMTP id 5614622812f47-43f2d12e4d7mr161932b6e.0.1758590260137;
        Mon, 22 Sep 2025 18:17:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFq9zHgq75BiE7ApXBV1Yytp3xnXFPeZg11oR2JKDr/lqHrXhwW6Di8HRCOFBIdLqEvOuYtIw==
X-Received: by 2002:a05:6808:308d:b0:43d:3c37:a342 with SMTP id 5614622812f47-43f2d12e4d7mr161918b6e.0.1758590259726;
        Mon, 22 Sep 2025 18:17:39 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-43e20b45410sm3700113b6e.12.2025.09.22.18.17.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 18:17:39 -0700 (PDT)
Date: Mon, 22 Sep 2025 19:17:37 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Donald Dutile <ddutile@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 linux-pci@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>, Will Deacon
 <will@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>,
 galshalom@nvidia.com, Joerg Roedel <jroedel@suse.de>, Kevin Tian
 <kevin.tian@intel.com>, kvm@vger.kernel.org, maorg@nvidia.com,
 patches@lists.linux.dev, tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH 03/11] iommu: Compute iommu_groups properly for PCIe
 switches
Message-ID: <20250922191737.0df0dbed.alex.williamson@redhat.com>
In-Reply-To: <1845b412-e96d-438a-8c05-680ef70c04e6@redhat.com>
References: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
	<3-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
	<20250701132905.67d29191.alex.williamson@redhat.com>
	<20250702010407.GB1051729@nvidia.com>
	<c05104a1-7c8e-4ce9-bfa3-bcbc8c9e0ef5@redhat.com>
	<20250717202744.GA2250220@nvidia.com>
	<2cb00715-bfa8-427a-a785-fa36667f91f9@redhat.com>
	<20250718133259.GD2250220@nvidia.com>
	<20250922163200.14025a41.alex.williamson@redhat.com>
	<20250922231541.GF1391379@nvidia.com>
	<1845b412-e96d-438a-8c05-680ef70c04e6@redhat.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 22 Sep 2025 20:51:31 -0400
Donald Dutile <ddutile@redhat.com> wrote:

> On 9/22/25 7:15 PM, Jason Gunthorpe wrote:
> > On Mon, Sep 22, 2025 at 04:32:00PM -0600, Alex Williamson wrote:  
> >> The ACS capability was only introduced in PCIe 2.0 and vendors have
> >> only become more diligent about implementing it as it's become
> >> important for device isolation and assignment.  
> PCIe-2.0 spec-wise, was released in 2007, 18 years ago.
> If hw is on a 3-yr lifecycle, that's 6 generations (7th including this year releases, assuming
> gen-1 was 2007); assuming a 5yr hw cycle, that's 4 generations of hardware.
> 
> Maybe a more interesting date is when DC servers implemented device-assignment/SRIOV
> in full-scale, and then, determine number of hw generations from that point on as
> 'learning -> devel-changing' years.
> I recall we had in in 'enterprise' customers in 2010, which only shaves one generation
> from above counts.

I don't see the relevance of these timelines.  A vendor with their head
in the sand still has their head in the sand regardless of time
passing.  Device assignment has a heavy non-enterprise user base.

> > IDK about this, I have very new systems and they still not have ACS
> > flags according to this interpretation.
> >   
> >> IMO, we can't assume anything at all about a multifunction device
> >> that does not implement ACS.  
> > 
> > Yeah this is all true.
> > 
> > But we are already assuming. Today we assume MFDs without caps must
> > have internal loopback in some cases, and then in other cases we
> > assume they don't.
> > 
> > I've sent and people have tested various different rules - please tell
> > me what you can live with.
> > 
> > Assuming the MFD does not have internal loopback, while not entirely
> > satisfactory, is the one that gives the least practical breakage.
> > 
> > I think it most accurately reflects the majority of real hardware out
> > there.
> > 
> > We can quirk to fix the remainder.
> > 
> > This is the best plan I've got..
> > 
> > Jason
> >   
> 
> +1 to Jason's conclusions.
> We should design the quirk hook to add ACS hooks for MFDs that do
> not adhere to the spec., which should be the minority, and that's what
> quirks are suppose to handle -- the odd cases.

Sorry, I can't agree.  I think we're conflating lack of a specific ACS
p2p capability to imply lack of internal p2p with lack of an ACS
capability at all.  I don't believe we can infer anything from the
latter.  Thanks,

Alex


