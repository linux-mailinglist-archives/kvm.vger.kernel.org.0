Return-Path: <kvm+bounces-58426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 93606B937CD
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 00:32:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD81D1907BC8
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 22:32:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD39230171C;
	Mon, 22 Sep 2025 22:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YHkJJIg9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52FE21DE2A7
	for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 22:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758580330; cv=none; b=Ez6S66gMwEgpsIrHjycCdFEsyYYdX70oUq4L6lXgrKT7ZnGJGKBiZjuLqsUz8LDObVtUoQL/0LSYjlXNmQULdh0aZtX99buRijCbgmd4p3V8YeavFaqBrTAFtzCH92hpxQBVsNsQYpDRHhiIvIu74eoMaYk50zDeiX2jhfPdK48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758580330; c=relaxed/simple;
	bh=tGsUKlZfH22Kkdt+rXlTfFHGLqAHCVSokUZMQlqwc6Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qjevvH4FSLRU3SiDUVelhM0DMl8P1HOxRUhnhLJL5FPankTMRjfbkz/NZ8UyDTv/PVUuaJotSTqmIlaMnV1MG36xCn0LlnIz797mkUcuv5w++PQldlMnm1fTtk2UTo++U59LwrSFpXkz1uufAZEK4Fv0AAueymU7NWtQuiozRN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YHkJJIg9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758580327;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WrM/zxhwv4klqtoRkgBDgOYK9tDXhnKZzT4SJVNV1Qg=;
	b=YHkJJIg9piSWBZ6j2clBLYX91lXPcvTl6/cqX7K/5zNg5XA1wugi1pJjRoZXHc6TZbs7Ye
	fnE5tPjzCKJlfK/rlwichoZymdOCD8xx2jMPyl+blzwKbzlWNWvmvCUTJzTue2zT+JTS7g
	j81LVpXj9kTuO8aqkQsfL31Po/MLCXY=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-462-gsVXxPO4NxucKpNzf4A2zA-1; Mon, 22 Sep 2025 18:32:05 -0400
X-MC-Unique: gsVXxPO4NxucKpNzf4A2zA-1
X-Mimecast-MFC-AGG-ID: gsVXxPO4NxucKpNzf4A2zA_1758580325
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-8935214d60bso113617839f.1
        for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 15:32:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758580325; x=1759185125;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WrM/zxhwv4klqtoRkgBDgOYK9tDXhnKZzT4SJVNV1Qg=;
        b=pGwySpsmAQlTvWAL6dwM/8BAy49UNDdf3YXvNm++ugWT76WJrsl9rUlMJPrZU8E7NZ
         pj4KXGdWsWsUD7LPRRFzKwdgu2BpE+J6tH2RA5JOc+dJ2pGkCogqr+6uG3jfnq//+L7A
         WGj4wtc2gNfUPlNVmW02gTPLYTMnGzF7iBuF91LbEm4D8l/iAHrfqUXVFIFAX4taQ5FK
         BDpw0BCeEOdOtCS43KIqSGP4KDFNqDkx7usQgNvjYyKmfuCyU4AMA2FSYYMDuicel7HO
         g5OESXPB6lOWICy+c9WkatkoBBe9BJ1+zyCOuayGf447J8+Dw+UzaXNH8RZIAi822Iln
         9qZA==
X-Forwarded-Encrypted: i=1; AJvYcCUWUCDvITra/vjpphGsYhc+l1rB5VGogahDpNFyRtGJoAWSNhqvfCEK4kzcesksglTIAeo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQmiGuMbdyi+lzNkHlgESnSYdc6OfKNr/DbXdoo2290jW8UwPX
	k+vwbTcv28UzYf4U8X4cG9wiD1RhXr5M/9UW0DUntomdOnamRudbEb0LnbJlDn3O0vgs+yHvTsn
	MczWgJQ/uk6CagrsY+kjg4Ek5mZZ5fjXkrbINnka5CTkBbWSkQADiyA==
X-Gm-Gg: ASbGncs5iTuqCkRBiCBQQ6bkrS3KL7BL38I11GAQAlU0TPyqG9njG+vdmvfEcR7GkSO
	I+cfTcji63Brf/Z+LiML37rUQh17Cyg7wN11Q8cLUJtgZ8RIROUe9VqZFD+jEAtJT0vIXo3FY6Q
	GaMpg1IpcMiCo6ltI7b0G1RMyDKrrJQHi8soKLM1dj7JAOTkwdJk4J+KGytTPLd4s1Yr6iydiKd
	RwmI41NMRmZLJZSjwCvBiVyOw5Q8A+YnV3itF1EIhqVFMRkmuswKKEXfxURSNKLon9/rFP6WW1E
	Pk8HU18fmM6jRkvJQ7A+BiJiyU+CBz52kSaqs0Gjl2c=
X-Received: by 2002:a05:6e02:164d:b0:400:7d06:dd6d with SMTP id e9e14a558f8ab-42581e09c50mr3117415ab.1.1758580325075;
        Mon, 22 Sep 2025 15:32:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFJEglC1l9HK0trhwS8TUhgMjco7KnQFggHDZoCeb4hUnb+WHFtfyngwGswerl1XqO2iXxTzA==
X-Received: by 2002:a05:6e02:164d:b0:400:7d06:dd6d with SMTP id e9e14a558f8ab-42581e09c50mr3117245ab.1.1758580324618;
        Mon, 22 Sep 2025 15:32:04 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-53d50aa460bsm6196930173.52.2025.09.22.15.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 15:32:03 -0700 (PDT)
Date: Mon, 22 Sep 2025 16:32:00 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Donald Dutile <ddutile@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 linux-pci@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>, Will Deacon
 <will@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>,
 galshalom@nvidia.com, Joerg Roedel <jroedel@suse.de>, Kevin Tian
 <kevin.tian@intel.com>, kvm@vger.kernel.org, maorg@nvidia.com,
 patches@lists.linux.dev, tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH 03/11] iommu: Compute iommu_groups properly for PCIe
 switches
Message-ID: <20250922163200.14025a41.alex.williamson@redhat.com>
In-Reply-To: <20250718133259.GD2250220@nvidia.com>
References: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
	<3-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
	<20250701132905.67d29191.alex.williamson@redhat.com>
	<20250702010407.GB1051729@nvidia.com>
	<c05104a1-7c8e-4ce9-bfa3-bcbc8c9e0ef5@redhat.com>
	<20250717202744.GA2250220@nvidia.com>
	<2cb00715-bfa8-427a-a785-fa36667f91f9@redhat.com>
	<20250718133259.GD2250220@nvidia.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 18 Jul 2025 10:32:59 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, Jul 17, 2025 at 10:31:42PM -0400, Donald Dutile wrote:
>  
> > > > If no (optional) ACS P2P Egress control, and no other ACS control, then I read/decode
> > > > the spec to mean no p2p btwn functions is possible, b/c if it is possible, by spec,
> > > > it must have an ACS cap to control it; ergo, no ACS cap, no p2p capability/routing.  
> > > 
> > > Where did you see this? Linux has never worked this way, we have
> > > extensive ACS quirks specifically because we've assumed no ACS cap
> > > means P2P is possible and not controllable.
> > >   
> > e.g., Section 6.12.1.2 ACS Functions in SR-IOV, SIOV, and Multi-Function Devices
> >  ...
> >  ACS P2P Request Redirect: must be implemented by Functions that support peer-to-peer traffic with other Functions.
> >                            ^^^^
> > 
> > It's been noted/stated/admitted that MFDs have not followed the ACS
> > rules, and thus the quirks may/are needed.
> > 
> > Linux default code should not be opposite of the spec, i.e., if no
> > ACS, then P2P is possible, thus all fcns are part of an IOMMU group.
> > The spec states that ACS support must be provided if p2p traffic
> > with other functions is supported.  
> 
> Linux is definately the opposite of this.
> 
> Alex would you agree to reverse this logic for MFDs? If the MFD does
> not have ACS cap then the MFD does not do internal loopback P2P?
> 
> I think that solves all the MFD related problems.

Sorry, I'm way, way late to responding to this, but I interpret this to
mean that if a multifunction device implements an ACS capability, it
must implement ACS P2P RR if it supports P2P between functions.  If the
ACS capability does not implement ACS P2P RR then we can assume that the
device does not support P2P between functions, but if the device does
not implement an ACS capability at all, we cannot assume anything.

This is effectively why NIC vendors like Intel started implementing an
empty ACS capability, such that we can infer that there is no P2P
between functions.

I'm just catching up from some extended PTO, but this statement in the
cover of the new series is setting off red flags for me:

  For multi-function-devices, a PCIe topology like:

                    -- MFD 00:1f.0 ACS not supported
    Root 00:00.00 --|- MFD 00:1f.2 ACS not supported
                    |- MFD 00:1f.6 ACS = REQ_ACS_FLAGS

  Will group [1f.0, 1f.2] and 1f.6 gets a single device group. However from
  a spec perspective each device should get its own group, because ACS not
  supported can assume no loopback is possible by spec.

The ACS capability was only introduced in PCIe 2.0 and vendors have
only become more diligent about implementing it as it's become
important for device isolation and assignment.  IMO, we can't assume
anything at all about a multifunction device that does not implement
ACS.  Thanks,

Alex


