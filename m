Return-Path: <kvm+bounces-58434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B7F59B93CB1
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 03:10:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B6C019027BE
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 01:11:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24C861DF99C;
	Tue, 23 Sep 2025 01:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GcY3De/x"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE771DDA09
	for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 01:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758589837; cv=none; b=iYYaYDwya9UFnzpaQVsNo6/67kOj/q6U2uXg7L+e/u3VmFzZNTSzosPIKMy4aIO+WItsyB+0SP8RNac57x10W4Wgh7XVJFKVN2OiA6nDp3trfhPe8EbVd4yM8QW3DR0GBCpK081ciDNJm0stbjvdBl7PZ/ufSK+ukLoLY9aWefs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758589837; c=relaxed/simple;
	bh=9rAyCAp0JWycHOc8mJx4dBKJhDcA9CLu0OXu8TULZ0w=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WjHsTXBjeHMYUTds0YgSPXdsAoXbu6jhEzX/HTVBe3a1wuMByINzX5w/2sWYOqPT9T2OK/l3uwg8xhxV7XVZyFoPM4e68+VezfzUvtdw+OiuAcuTme37N8JqYXnqRpJl/PESZlHEy4Z1pa7vKPjOZ8l2xCOkiJ2KagUp7yxRdGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GcY3De/x; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758589834;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MMdCl+IiTEZQdjIFjdJwfIpOIRvy1QynTRS3PoYFQjM=;
	b=GcY3De/xda7cLyeKuSL4ev9JkPKpyhESnznTHEG/uFAQBSZu9TfU4vyQn1oCtI3FKlKyQx
	AA2AAuCCbjzLTpyS3QvuT15R5+bp86Kv7eix1qjiRpNlIS4G56I7In2KxUadwsDJj0TSq6
	vsry2uRv62cDbKhP4ltclY8jcWUgG/s=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-314-yrz3D3EuPGaAWQTpEe2bzQ-1; Mon, 22 Sep 2025 21:10:32 -0400
X-MC-Unique: yrz3D3EuPGaAWQTpEe2bzQ-1
X-Mimecast-MFC-AGG-ID: yrz3D3EuPGaAWQTpEe2bzQ_1758589832
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-42571642af9so6490545ab.0
        for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 18:10:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758589832; x=1759194632;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MMdCl+IiTEZQdjIFjdJwfIpOIRvy1QynTRS3PoYFQjM=;
        b=rjLpFEvLv1egrY23rhCPmYHbW/djwCHrEOGRExbOB62xXOS5K9oC+9K7Pyqm4zwaQO
         fdLZv0xFBsbT/5k9z/YQNoolfsJrGBtz1OoAzm4d7oS/hYzoq4AATsCCmKOLnyFLiBBe
         BZjU6/RFOrwIITt3968Z9YLH//4Qq9isW0+mwvVeV31ZFVEO8dqfEN7LbwHYAKEWeYyf
         SFJJuMFyydzni8q3AbIfTK+sYpw1jsSudJBBajqkjRP2nxuWAuFJkphrY9NpgFzZjIgE
         kGLu59RDSLucmtdbFgQXQ51Uc+eZyc7mTtJYHlPPMcDKD9KGB33pIhaHHb7cqw7fNPet
         VvZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVzo74veBSpl+Q07zKfmTuPYADLc7hFkWUFA8warZFusLW+Gt7vcMJOmh+pyARfKCpRlzA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxS9TiRcWwlQKBkGUHlzjoRQ2Ofol+V90qEXibbV2ze5smP16Tz
	tnCimcFz16M6F395nd5nLJqkP9ntZKi1Y3jqkzD8E3O7SZfsV+OaG7Qwq6pPfOfuGTEYrFOO1jl
	VUzz26EB8PnmXHnTlZsI9Yt8GTrQJHHlxmEra8KJYxiJ1omDS1+NRjQ==
X-Gm-Gg: ASbGncspnIVaXl/V12+AdeAI1XDQt9TQ5wxTltsIAdKcgZTatITDKfkPZj+eAGvX32D
	LkFKV3l/qJqU36tEIKVSpbYbn5TRU9x8/MaHF+q6KNpaw4VAp8PQ7fq6OORRDAD4XrALzVZP6r+
	euGA4wGinpmUmfoXeMi/OQ0tlQu6gN8Jqt7w1xQYV+Wf86E05m3/5IPAWrN4rKVjn0eHNzwUh3s
	OKlVZ2fKQEOyZzaGbR1MKEpOLe1KbwXNUazBaRsvzghQKTu/noOn1i3SXg0Cp+ddsjQ/qi26sfe
	PZ3J/iz0+7gxQxtn9xEuzMPa8vQhyGc3TCzwQriFVII=
X-Received: by 2002:a05:6e02:1062:b0:425:84b6:a7de with SMTP id e9e14a558f8ab-42584b6aa30mr980455ab.0.1758589831765;
        Mon, 22 Sep 2025 18:10:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEjujwsV4+PvdiPV9xPzzt8xVXDXwwoMNeGQllr4EYycFAIvL2pedut8GhHoH/nZ1k7CtN0Ig==
X-Received: by 2002:a05:6e02:1062:b0:425:84b6:a7de with SMTP id e9e14a558f8ab-42584b6aa30mr980355ab.0.1758589831423;
        Mon, 22 Sep 2025 18:10:31 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-56221c6f374sm865008173.55.2025.09.22.18.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 18:10:30 -0700 (PDT)
Date: Mon, 22 Sep 2025 19:10:29 -0600
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
Message-ID: <20250922191029.7a000d64.alex.williamson@redhat.com>
In-Reply-To: <20250922231541.GF1391379@nvidia.com>
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
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 22 Sep 2025 20:15:41 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Sep 22, 2025 at 04:32:00PM -0600, Alex Williamson wrote:
> > The ACS capability was only introduced in PCIe 2.0 and vendors have
> > only become more diligent about implementing it as it's become
> > important for device isolation and assignment.    
> 
> IDK about this, I have very new systems and they still not have ACS
> flags according to this interpretation.

But how can we assume that lack of a non-required capability means
anything at all??
 
> > IMO, we can't assume anything at all about a multifunction device
> > that does not implement ACS.  
> 
> Yeah this is all true. 
> 
> But we are already assuming. Today we assume MFDs without caps must
> have internal loopback in some cases, and then in other cases we
> assume they don't.

Where?  Is this in reference to our handling of multi-function
endpoints vs whether downstream switch ports are represented as
multi-function vs multi-slot?

I believe we consider multifunction endpoints and root ports to lack
isolation if they do not expose an ACS capability and an "empty" ACS
capability on a multifunction endpoint is sufficient to declare that
the device does not support internal p2p.  Everything else is quirks.

> I've sent and people have tested various different rules - please tell
> me what you can live with.

I think this interpretation that lack of an ACS capability implies
anything is wrong.  Lack of a specific p2p capability within an ACS
capability does imply lack of p2p support.

> Assuming the MFD does not have internal loopback, while not entirely
> satisfactory, is the one that gives the least practical breakage.

Seems like it's fixing one gap and opening another.  I don't see that we
can implement ingress and egress isolation without breakage.  We may
need an opt-in to continue egress only isolation.

> I think it most accurately reflects the majority of real hardware out
> there.
> 
> We can quirk to fix the remainder.
> 
> This is the best plan I've got..

And hardware vendors are going to volunteer that they lack p2p
isolation and we need to add a quirk to reduce the isolation... the
dynamics are not in our favor.  Hardware vendors have no incentive to
do the right thing.  Thanks,

Alex


