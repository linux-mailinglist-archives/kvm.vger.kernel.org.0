Return-Path: <kvm+bounces-17207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D6AA8C2A09
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 20:43:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD1DB288306
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 18:43:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 220D24437A;
	Fri, 10 May 2024 18:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=raptorengineering.com header.i=@raptorengineering.com header.b="CJy1hrkt"
X-Original-To: kvm@vger.kernel.org
Received: from raptorengineering.com (mail.raptorengineering.com [23.155.224.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07FC345012;
	Fri, 10 May 2024 18:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.155.224.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715366594; cv=none; b=qiiUeuWJktCzFUsrlXi8b6jAeCSenRUsASbuLkWa0CEbPLaA9yO6++zyUs1tnJRXW2uqFq1m/SHWaqTTX1e8rRcIHCQcbNDbrKsiK+dLuD6BSSEp0jZSG+1XCWYl4rai7LEeWfGeKvJhxnMOxKbGNSq6u0KpwvsqkmPM/GYPWEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715366594; c=relaxed/simple;
	bh=HgF/3Xa5VSNjvU/9axvTODFvHXS3OxmrPA3wQpo+6SY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SwS1hvQQsW3nlUhKYcyfKfPKOH9UYfUwwLsPC4cJ/La/5HnxYYAJyZf5qHTERL9taKz6TvopgYC2iikMD9rTmJHgr+fNui2jjN6ZmiQXGdQTk0s9Z07+k6we7PKw09Q3Ift4ZenX4ejN8tHON1ioO+eGv5u5uLDC7fEGE6Wzbt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raptorengineering.com; spf=pass smtp.mailfrom=raptorengineering.com; dkim=pass (1024-bit key) header.d=raptorengineering.com header.i=@raptorengineering.com header.b=CJy1hrkt; arc=none smtp.client-ip=23.155.224.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raptorengineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raptorengineering.com
Received: from localhost (localhost [127.0.0.1])
	by mail.rptsys.com (Postfix) with ESMTP id 8AD098286B62;
	Fri, 10 May 2024 13:33:16 -0500 (CDT)
Received: from mail.rptsys.com ([127.0.0.1])
	by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id 6_lArAH4eB26; Fri, 10 May 2024 13:33:15 -0500 (CDT)
Received: from localhost (localhost [127.0.0.1])
	by mail.rptsys.com (Postfix) with ESMTP id BE7B9828545C;
	Fri, 10 May 2024 13:33:15 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.rptsys.com BE7B9828545C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=raptorengineering.com; s=B8E824E6-0BE2-11E6-931D-288C65937AAD;
	t=1715365995; bh=/XIFIR9y/2aocYtN3V2XjaxnPUosdNnwRa6IYBoAXzA=;
	h=Message-ID:Date:MIME-Version:To:From;
	b=CJy1hrktEB9x2OiZs64ig8A6vj/hAO/TrVpn4xyLbZrYt1jiF5E6+9uKZ8lcnwXhs
	 UTYcm1KtnLbVMzjSISe55+IxF/BbadMrJ3848lhIIXnj9P2J3ZR3iypriRFHaJsL0I
	 MYgsa2Nqe9lxgudeG0G8f12VdNsjaUYb2e4/U6/w=
X-Virus-Scanned: amavisd-new at rptsys.com
Received: from mail.rptsys.com ([127.0.0.1])
	by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id DW4fhZglJ2dW; Fri, 10 May 2024 13:33:15 -0500 (CDT)
Received: from [10.11.0.2] (5.edge.rptsys.com [23.155.224.38])
	by mail.rptsys.com (Postfix) with ESMTPSA id CCE2E82853A8;
	Fri, 10 May 2024 13:33:14 -0500 (CDT)
Message-ID: <202e8af6-8073-4d87-a38f-746644bb338d@raptorengineering.com>
Date: Fri, 10 May 2024 13:33:13 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 0/6] powerpc: pSeries: vfio: iommu: Re-enable
 support for SPAPR TCE VFIO
To: Jason Gunthorpe <jgg@ziepe.ca>, Shivaprasad G Bhat <sbhat@linux.ibm.com>
Cc: kvm@vger.kernel.org, aik@ozlabs.ru, linux-kernel@vger.kernel.org,
 oohall@gmail.com, ruscur@russell.cc, brking@linux.vnet.ibm.com,
 robh@kernel.org, svaidy@linux.ibm.com, aneesh.kumar@kernel.org,
 joel@jms.id.au, naveen.n.rao@linux.ibm.com, msuchanek@suse.de,
 jroedel@suse.de, gbatra@linux.vnet.ibm.com, npiggin@gmail.com,
 alex.williamson@redhat.com, mahesh@linux.ibm.com,
 tpearson@raptorengineering.com, Alexey Kardashevskiy <aik@amd.com>,
 vaibhav@linux.ibm.com, linuxppc-dev@lists.ozlabs.org
References: <171450753489.10851.3056035705169121613.stgit@linux.ibm.com>
 <20240501140942.GA1723318@ziepe.ca>
 <703f15b0-d895-4518-9886-0827a6c4e769@amd.com>
 <8c28a1d5-ac84-445b-80e6-a705e6d7ff1b@linux.ibm.com>
 <20240506174357.GF901876@ziepe.ca>
Content-Language: en-US
From: Shawn Anastasio <sanastasio@raptorengineering.com>
In-Reply-To: <20240506174357.GF901876@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/6/24 12:43 PM, Jason Gunthorpe wrote:
> On Sat, May 04, 2024 at 12:33:53AM +0530, Shivaprasad G Bhat wrote:
>> We have legacy workloads using VFIO in userspace/kvm guests running
>> on downstream distro kernels. We want these workloads to be able to
>> continue running on our arch.
> 
> It has been broken since 2018, I don't find this reasoning entirely
> reasonable :\
>

Raptor is currently working on an automated test runner setup to
exercise the VFIO subsystem on PowerNV and (to a lesser extent) pSeries,
so breakages like this going forward will hopefully be caught much more
quickly.

>> I firmly believe the refactoring in this patch series is a step in
>> that direction.
> 
> But fine, as long as we are going to fix it. PPC really needs this to
> be resolved to keep working.
>

Agreed. Modernizing/de-cluttering PPC's IOMMU code in general is another
task that we're working towards. As mentioned previously on the list,
we're working towards a more standard IOMMU driver for PPC that can be
used with dma_iommu, which I think will be a good step towards cleaning
this up. Initially PowerNV is going to be our target, but to the extent
that it is possible and useful, pSeries support could be brought in
later.

> Jason

Thanks,
Shawn

