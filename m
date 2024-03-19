Return-Path: <kvm+bounces-12176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6047B880502
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 19:42:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 14B881F23AFD
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 18:42:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55A6539AFD;
	Tue, 19 Mar 2024 18:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=raptorengineering.com header.i=@raptorengineering.com header.b="bZRSuirt"
X-Original-To: kvm@vger.kernel.org
Received: from raptorengineering.com (mail.raptorengineering.com [23.155.224.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1383838F;
	Tue, 19 Mar 2024 18:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.155.224.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710873743; cv=none; b=ut+VYbSRXHZyxkAFEhTTPa9oXM0w17A09TEynD1lCP9Uaipct+DRv02DSkDQIiYOoMQPPoME3LBekTSgvj2WB4RDsimwtJU67+rjh/zHMdhqNlVkGmQPNuKHJwzoFFB7D+EAvaEdL29p3m/fDV+YFdkWFsWFk8V77AXeKCJ3tuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710873743; c=relaxed/simple;
	bh=VN/elIqf9LElJlgNTtPrq8H9FEwfVHcaHoZhKnOzMuw=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=AQ/n38V5DJK+f9aLNkuRxOAH5Mf/d4Hbl0TQKQvfoKrvuTK3UEn7HLi3mh+EQG/e91bZuZk7p8DgavimUh09+JI9WY/gsNW3F0SAqlvdHFxQwGNVY2NqcF6kbV8xH5KdPNJOzDdD50DtBCfFarjFWO0j7Ijz5cxbkq0oxoE9uKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raptorengineering.com; spf=pass smtp.mailfrom=raptorengineering.com; dkim=pass (1024-bit key) header.d=raptorengineering.com header.i=@raptorengineering.com header.b=bZRSuirt; arc=none smtp.client-ip=23.155.224.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raptorengineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raptorengineering.com
Received: from localhost (localhost [127.0.0.1])
	by mail.rptsys.com (Postfix) with ESMTP id 6486482853FD;
	Tue, 19 Mar 2024 13:36:55 -0500 (CDT)
Received: from mail.rptsys.com ([127.0.0.1])
	by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id zNGRQb1hjFIX; Tue, 19 Mar 2024 13:36:53 -0500 (CDT)
Received: from localhost (localhost [127.0.0.1])
	by mail.rptsys.com (Postfix) with ESMTP id 95ED982857C6;
	Tue, 19 Mar 2024 13:36:53 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.rptsys.com 95ED982857C6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=raptorengineering.com; s=B8E824E6-0BE2-11E6-931D-288C65937AAD;
	t=1710873413; bh=jjl+qmMtiRVpAUsU+d+UXWZRLmd8K+2jgNQsp7lj+04=;
	h=Date:From:To:Message-ID:MIME-Version;
	b=bZRSuirtYJVJx6DLzBTldOSSqPcXRGEoyzhi4eq6ezoK3oOseSQDCxWemf+VcT27i
	 P/2bOL4Vy81473wmz5gBDMJvZNe96fzmvW6jtLHauh0qPnwNM/o/JoLAm8dX1OX4HK
	 pEZEQTCZDnUY8x8A6J7bhD/nF/t+H+0XQdN7gKfc=
X-Virus-Scanned: amavisd-new at rptsys.com
Received: from mail.rptsys.com ([127.0.0.1])
	by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id C_5K4lh6-1JZ; Tue, 19 Mar 2024 13:36:53 -0500 (CDT)
Received: from vali.starlink.edu (localhost [127.0.0.1])
	by mail.rptsys.com (Postfix) with ESMTP id 531A182853FD;
	Tue, 19 Mar 2024 13:36:53 -0500 (CDT)
Date: Tue, 19 Mar 2024 13:36:51 -0500 (CDT)
From: Timothy Pearson <tpearson@raptorengineering.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Shivaprasad G Bhat <sbhat@linux.ibm.com>, 
	Timothy Pearson <tpearson@raptorengineering.com>, 
	Alex Williamson <alex.williamson@redhat.com>, 
	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, npiggin <npiggin@gmail.com>, 
	christophe leroy <christophe.leroy@csgroup.eu>, 
	aneesh kumar <aneesh.kumar@kernel.org>, 
	naveen n rao <naveen.n.rao@linux.ibm.com>, 
	gbatra <gbatra@linux.vnet.ibm.com>, brking@linux.vnet.ibm.com, 
	Alexey Kardashevskiy <aik@ozlabs.ru>, robh@kernel.org, 
	linux-kernel <linux-kernel@vger.kernel.org>, 
	kvm <kvm@vger.kernel.org>, aik <aik@amd.com>, msuchanek@suse.de, 
	jroedel <jroedel@suse.de>, vaibhav <vaibhav@linux.ibm.com>, 
	svaidy@linux.ibm.com
Message-ID: <1386271253.24278379.1710873411133.JavaMail.zimbra@raptorengineeringinc.com>
In-Reply-To: <20240319143202.GA66976@ziepe.ca>
References: <171026724548.8367.8321359354119254395.stgit@linux.ibm.com> <171026725393.8367.17497620074051138306.stgit@linux.ibm.com> <20240319143202.GA66976@ziepe.ca>
Subject: Re: [RFC PATCH 1/3] powerpc/pseries/iommu: Bring back userspace
 view for single level TCE tables
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.5.0_GA_3042 (ZimbraWebClient - GC122 (Linux)/8.5.0_GA_3042)
Thread-Topic: powerpc/pseries/iommu: Bring back userspace view for single level TCE tables
Thread-Index: eRa4lP8lSoGisWT5ua6Vo0RITwt14g==



----- Original Message -----
> From: "Jason Gunthorpe" <jgg@ziepe.ca>
> To: "Shivaprasad G Bhat" <sbhat@linux.ibm.com>
> Cc: "Timothy Pearson" <tpearson@raptorengineering.com>, "Alex Williamson" <alex.williamson@redhat.com>, "linuxppc-dev"
> <linuxppc-dev@lists.ozlabs.org>, "Michael Ellerman" <mpe@ellerman.id.au>, "npiggin" <npiggin@gmail.com>, "christophe
> leroy" <christophe.leroy@csgroup.eu>, "aneesh kumar" <aneesh.kumar@kernel.org>, "naveen n rao"
> <naveen.n.rao@linux.ibm.com>, "gbatra" <gbatra@linux.vnet.ibm.com>, brking@linux.vnet.ibm.com, "Alexey Kardashevskiy"
> <aik@ozlabs.ru>, robh@kernel.org, "linux-kernel" <linux-kernel@vger.kernel.org>, "kvm" <kvm@vger.kernel.org>, "aik"
> <aik@amd.com>, msuchanek@suse.de, "jroedel" <jroedel@suse.de>, "vaibhav" <vaibhav@linux.ibm.com>, svaidy@linux.ibm.com
> Sent: Tuesday, March 19, 2024 9:32:02 AM
> Subject: Re: [RFC PATCH 1/3] powerpc/pseries/iommu: Bring back userspace view for single level TCE tables

> On Tue, Mar 12, 2024 at 01:14:20PM -0500, Shivaprasad G Bhat wrote:
>> The commit 090bad39b237a ("powerpc/powernv: Add indirect levels to
>> it_userspace") which implemented the tce indirect levels
>> support for PowerNV ended up removing the single level support
>> which existed by default(generic tce_iommu_userspace_view_alloc/free()
>> calls). On pSeries the TCEs are single level, and the allocation
>> of userspace view is lost with the removal of generic code.
> 
> :( :(
> 
> If this has been broken since 2018 and nobody cared till now can we
> please go in a direction of moving this code to the new iommu APIs
> instead of doubling down on more of this old stuff that apparently
> almost nobody cares about ??
> 
> Jason

Just FYI Raptor is working on porting things over to the new APIs.  RFC patches should be posted in the next week or two.

