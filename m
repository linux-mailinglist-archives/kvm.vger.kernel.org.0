Return-Path: <kvm+bounces-58440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76380B94000
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 04:26:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D9C1416837A
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 02:26:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5210426E717;
	Tue, 23 Sep 2025 02:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CxioQbUP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00B51DDA09
	for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 02:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758594396; cv=none; b=ULU484uiVkC3NzWDX9/BMyPGvz1SFDfheFT20GCb9k0hIiJYryGWDEUgk8qPeOmhd3o3BNP6mRgLPZxKJ8RHFjnTkmwdAUQofaommBRHSkyyxdTWY8Q79lVqtlKY+tiWucqcrm13KIIlImR42Km0QnWJW7yUS/HR1pean52GiU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758594396; c=relaxed/simple;
	bh=g9MBrqKRxZdbNaQ2i02BY1V65gw6a+Y7SeILJk5mGz8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mYPZ5tpY+B2KOdaBnA0fzcyrOvQkROHwD+VmIzjA3SN4mrAbGRUFRpFeprUc+mhXpY3nTzyKaYRsCh4Zt7htLZvLdEUrRhtzrTgqKd46lGMHnmcZbtXTG9ZZJOD/Gvk/JwxXLD/izL4ArkQ4XPSZXe2JWmtFwDBElYnosgpIikI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CxioQbUP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758594393;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4PCUD8Djs42q6wF1aYGU4dHZzCceidwhyTYH/cv8Ps8=;
	b=CxioQbUPhIJYHnS14nRJO6/OsqhoufsrIptD7QP6JHHqeNb6uO1L2eATAeUbUuBmvxj4G0
	ry1HqRtBmx5FZ+Giuzqfg9GZI1ZGVJXPpeUvL2D8JyJLhB9rGSKywZo5WXdJ8WyXaMs9Ef
	/srTlu6Wn0xJUWdgK/d1TX0z1bg/7IA=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-590-DGEgaN5BPa233NOypJDygQ-1; Mon, 22 Sep 2025 22:26:31 -0400
X-MC-Unique: DGEgaN5BPa233NOypJDygQ-1
X-Mimecast-MFC-AGG-ID: DGEgaN5BPa233NOypJDygQ_1758594391
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4d413127749so3751201cf.2
        for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 19:26:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758594391; x=1759199191;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4PCUD8Djs42q6wF1aYGU4dHZzCceidwhyTYH/cv8Ps8=;
        b=bVFEQ+sv+LHcIe2r1bULGRjrEz39clvEHhrpbPkECqi4CsxutTj8XRJeY23MuQGbmG
         fDRFWUej2y6RFw3een0rdeeejXblyZxeXa434clknHDZVA1EIKgbaJnz/lhSJ+CD2zOc
         FpaOJuToNpphxC9h1cTH1gShJL1lPzSIwGzyCFwLaNILOBiba+wUOFrN65Eg1RB0wGrN
         Lz4T/cQEHfcEGllis+LcsjVnGZ1y4qrFSqBPVVO53cq3FSDyUvlVmrVUaztsnyTs1PNx
         r+wcLxSn51uY1MUTUia1AjWZpeZwZaU+wc6WhbpHjedsYG7xb6brgUvtKMMsAbkyjnbW
         PVHA==
X-Forwarded-Encrypted: i=1; AJvYcCXomsJBMgVDYpa2s8SMBUGjLYqEzfPjVCOq/OohFqhLCQq0dPjZlZpFmqWHsnxtL+3fBro=@vger.kernel.org
X-Gm-Message-State: AOJu0YylsnjHND38YlDvYtGTqJM+avIN9fOwWOJzKwDOfTg3dpr3HRuD
	QRtyxaXGimYJiAqGY1gtT7Kh5jjBGC6y72/TekuF2PmjJrwq+HZmd5583Isf9r+sCxiby9Wy1PS
	14tvYVOCwC0jjdWz0NgcJpmt+R+9BLJyfHU+v0KB73QbH5bOvhjHNRA==
X-Gm-Gg: ASbGnctedI4SnGazhpYO3GMtEMuDVeumLyY877QDahDydY82VR24iyn+EuSWhKXs4pq
	jJ4VyLm4yUAMpQwDLwNWcZ4EnK+s+YfpCT0fsS87bL6Hb9XHuY7SdQKrmQKyIoOoK4IU65m3IRw
	m10owPoqM4xtB1QACOiB3QH1JjqAev6m5tPcp8zGHhx76CnoYsU4LKJYTEgyrgyEtRfGIomci3k
	//eXbdewmFkqNgepJrM8yRCxek7pHbj+j4027W4FfFoUtE3uIHVx1K02X3UGHq31gwL/MO5L+rn
	JCLvqHqXrrjOQDwwfA/yWceEGm3nrWSr3H5PSvkW
X-Received: by 2002:a05:622a:22a0:b0:4b7:9abe:e1d0 with SMTP id d75a77b69052e-4d3736be686mr10224441cf.83.1758594391141;
        Mon, 22 Sep 2025 19:26:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEh1sa0UCiSmZuNAaBvHrwWnpQZ66gjDzkXkZDaP2M4kQe89ePy6njY8SwRBtPjwxnoKyKQGQ==
X-Received: by 2002:a05:622a:22a0:b0:4b7:9abe:e1d0 with SMTP id d75a77b69052e-4d3736be686mr10224311cf.83.1758594390717;
        Mon, 22 Sep 2025 19:26:30 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4bd9b0c128bsm81896451cf.0.2025.09.22.19.26.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Sep 2025 19:26:30 -0700 (PDT)
Message-ID: <066e288e-8421-4daf-ae62-f24e54f8be68@redhat.com>
Date: Mon, 22 Sep 2025 22:26:26 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/11] iommu: Compute iommu_groups properly for PCIe
 switches
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>,
 Jason Gunthorpe <jgg@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
 Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
 tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
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
 <20250922191029.7a000d64.alex.williamson@redhat.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <20250922191029.7a000d64.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/22/25 9:10 PM, Alex Williamson wrote:
> On Mon, 22 Sep 2025 20:15:41 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
>> On Mon, Sep 22, 2025 at 04:32:00PM -0600, Alex Williamson wrote:
>>> The ACS capability was only introduced in PCIe 2.0 and vendors have
>>> only become more diligent about implementing it as it's become
>>> important for device isolation and assignment.
>>
>> IDK about this, I have very new systems and they still not have ACS
>> flags according to this interpretation.
> 
> But how can we assume that lack of a non-required capability means
> anything at all??
>   
ok, I'll bite on the the dumb answer...
lots of non-support is represented by lack of a control structure.
... should we assume there are hidden VFs b/c there is a lack of a vf cap structure?
... <insert your favorite dumb answer here> :-)

I can certainly see why a hw vendor would -not- put a control structure
into a piece of hw that is not needed, as the spec states.
For every piece of hw one creates, one has to invest resources to verify
it is working correctly, and if verification is done correctly, verify it
doesn't cause unexpected errors.  I've seen this resource req back in
my HDL days (developers design w/HDL; hw verification engineers are the
QE equivalent to sw, verifying the hw does and does not do what it is spec'd).

Penalizing a hw vendor for following the spec, and saving resources,
seems wrong to me, to require them to quirk their spec-correct device.

I suspect section 6.12.1.2 was written by hw vendors, looking to reduce
their hw design & verification efforts.  If written by sw vendors, it
would have likely required 'empty ACS' structs as you have mentioned in other thread(s).

>>> IMO, we can't assume anything at all about a multifunction device
>>> that does not implement ACS.
>>
>> Yeah this is all true.
>>
>> But we are already assuming. Today we assume MFDs without caps must
>> have internal loopback in some cases, and then in other cases we
>> assume they don't.
> 
> Where?  Is this in reference to our handling of multi-function
> endpoints vs whether downstream switch ports are represented as
> multi-function vs multi-slot?
> 
> I believe we consider multifunction endpoints and root ports to lack
> isolation if they do not expose an ACS capability and an "empty" ACS
> capability on a multifunction endpoint is sufficient to declare that
> the device does not support internal p2p.  Everything else is quirks.
> 
>> I've sent and people have tested various different rules - please tell
>> me what you can live with.
> 
> I think this interpretation that lack of an ACS capability implies
> anything is wrong.  Lack of a specific p2p capability within an ACS
> capability does imply lack of p2p support.
> 
>> Assuming the MFD does not have internal loopback, while not entirely
>> satisfactory, is the one that gives the least practical breakage.
> 
> Seems like it's fixing one gap and opening another.  I don't see that we
> can implement ingress and egress isolation without breakage.  We may
> need an opt-in to continue egress only isolation.
> 
>> I think it most accurately reflects the majority of real hardware out
>> there.
>>
>> We can quirk to fix the remainder.
>>
>> This is the best plan I've got..
> 
> And hardware vendors are going to volunteer that they lack p2p
> isolation and we need to add a quirk to reduce the isolation... the
> dynamics are not in our favor.  Hardware vendors have no incentive to
> do the right thing.  Thanks,
> 
I gave an example above why hw vendors have every incentive not to add an ACS structure if they don't need it.
Not doing so, when they can do p2p, is a clear PCIe spec violation.  Punishing the correct implementations for the
incorrect ones is not appropriate, and is further incentive to continue to be incorrect.

Don't we have the hooks with kernel cmdline disable_acs_redir & config_acs params to solve the insecure cases
that may (would) be found, so breaking the isolation is relatively easy to fix vs adding quirks as is done today for proper spec interpretation?

- Don

> Alex
> 


