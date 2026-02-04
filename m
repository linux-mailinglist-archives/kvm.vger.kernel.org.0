Return-Path: <kvm+bounces-70239-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QI5PD4Fug2lNmwMAu9opvQ
	(envelope-from <kvm+bounces-70239-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 17:06:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C570E9DED
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 17:06:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 7AB9D306AD59
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 15:26:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4DDE426D11;
	Wed,  4 Feb 2026 15:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rru1evNG"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95C442AA9;
	Wed,  4 Feb 2026 15:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218662; cv=none; b=lYmVZPmbg1k8gYgeDqXWy9tWNODm9jfCNIiT7l3i9sh86IQWvRS53bltxqEvXVeW+RFmaZNAPRM5K9xq3+vHhq8dvgSkf5PAgCdiYR7OMXf1US6bSAwCs5P8i7WjbLA+RvUxnNzi3UCnLmoBsmSDJroFIPGTWckWRLsi7DGrTPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218662; c=relaxed/simple;
	bh=qLwBxj62ANHouRxDyj54fbrhw+n4L4kNVwakO33ly8E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZT1qJNs+iDo0zCeDubBcwohfaLiUU12gmXSrb5JUlVpgASeFsWXODhYUn3DBwhBlx7zkrJhJ5Jq9ZKdHgmsyQij4k7lisst03cSt9aiJOWOXO1Vs+1gQXZYOfr1Xn8gHrly/y9QwGK9PG+549jycvgjTQq+mEUFNKDR5C0FD//8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rru1evNG; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 613N04u4025645;
	Wed, 4 Feb 2026 15:23:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ubKiLh
	KQsDs/uDx7xbrwcvAMyP4lIKNzVi8v6GnPdMM=; b=rru1evNGfZdzSFxj0fotV1
	edB3DXVwo+Ve9bkQBs/BKpRZfV030l2UROTmhy8zOSMZNGzOYv+tyreRO6S988J/
	eBH3MgBgwIh+tgxzMUfnqdPM00o3i17sRF8Iu21tKcTgrRlNkdM63cGjZm/nhcQ+
	r/7VSUWnxqX9XMr6Bfygcl1oVbbfqu3qYyM1XkMvS1wxzcikD0Id5SAdZe0M759H
	z0v8lb5c0zsHSaEad5nFV6s9qiKNen7PzsG48cZbM53pw0j9QdfU9v0YcivHCinR
	3ff3YkPDbV0d1pdabWDvxNX53SPCXpjk1X2M5/HOYrlwBsXbAYqpeJOnJ/kV/qvA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c19dtag8e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:23:47 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 614FNk8x025600;
	Wed, 4 Feb 2026 15:23:46 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c19dtag89-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:23:46 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 614CQ8IV029108;
	Wed, 4 Feb 2026 15:23:45 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c1v2sdvcf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:23:45 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 614FNfqt46531004
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 4 Feb 2026 15:23:41 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A48622004B;
	Wed,  4 Feb 2026 15:23:41 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 70CE920043;
	Wed,  4 Feb 2026 15:23:38 +0000 (GMT)
Received: from [9.79.200.210] (unknown [9.79.200.210])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  4 Feb 2026 15:23:38 +0000 (GMT)
Message-ID: <918060d2-3ccc-4c7b-a7f1-65c110e124aa@linux.ibm.com>
Date: Wed, 4 Feb 2026 20:53:48 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] powerpc: iommu: Initial IOMMUFD support for PPC64
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, iommu@lists.linux.dev, chleroy@kernel.org,
        mpe@ellerman.id.au, maddy@linux.ibm.com, npiggin@gmail.com,
        alex@shazbot.org, joerg.roedel@amd.com, kevin.tian@intel.com,
        gbatra@linux.ibm.com, clg@kaod.org, vaibhav@linux.ibm.com,
        brking@linux.vnet.ibm.com, nnmlinux@linux.ibm.com,
        amachhiw@linux.ibm.com, tpearson@raptorengineering.com
References: <176953894915.725.1102545144304639827.stgit@linux.ibm.com>
 <20260127191643.GQ1134360@nvidia.com>
 <2127b181-2c3a-4470-9b79-b508a18275c9@linux.ibm.com>
 <20260203180725.GD3931454@nvidia.com>
Content-Language: en-US
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
In-Reply-To: <20260203180725.GD3931454@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDExNyBTYWx0ZWRfXxFcMB+ZOxlRe
 rwc8IEUsWaxBGFlxEMTA3V/trdzQEPK3YRUjWZqEcXcarBDNEIs3uQohQiqE3QEr6bZJh+KrMeZ
 kVnj12gmt8PBZCMZxo8LWX5cMUJN0syHcffYYvDKh+D1etcAjVXRxKN4Q0uzIikZK1yiZVC5+Cq
 SyjSpVc+rDsJjNUcXuUccZSaGGSLfCVSdvOVIUFM94503cwdY5Xxw+qztyx5gV4X5q/RNHjq5Xb
 DvwFNLDazLMs/Q5YgOyutdvLAOH9UoemZhm5HD6kTErWevbf7YXIbFB4fJmlHep+8eoCR/lRfO6
 vLUcs3jN7/AqGFF8lOLooXgniZEh0Qh/KH4rHK2Iw3K2iw/N7MYMGvs3SZIROWaRFND0KVvURWz
 zCd+x9bebnROHYE+Wde1IseAAPo8c7WYJ84OVamzkw3jakrI3slM22yKaaAPW4Ti+h/m8PvIICP
 NEs7pmG2VhSSlUReTtA==
X-Proofpoint-GUID: BvtaPfqgF8Y9PB153aFGVcHMeZ94GlS4
X-Proofpoint-ORIG-GUID: A7bgImTb_ZhuOsb-XjlxkxU_dOL4uApz
X-Authority-Analysis: v=2.4 cv=LesxKzfi c=1 sm=1 tr=0 ts=69836483 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=EGYj-OwPAAAA:8 a=pEZ9rK_A_dQy-odCcdsA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=xQyHFheebwQZ3wMG2Lhb:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-04_04,2026-02-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015
 adultscore=0 suspectscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2601150000 definitions=main-2602040117
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.ozlabs.org,lists.linux.dev,kernel.org,ellerman.id.au,linux.ibm.com,gmail.com,shazbot.org,amd.com,intel.com,kaod.org,linux.vnet.ibm.com,raptorengineering.com];
	TAGGED_FROM(0.00)[bounces-70239-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[ibm.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sbhat@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_TWELVE(0.00)[13];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5C570E9DED
X-Rspamd-Action: no action


On 2/3/26 11:37 PM, Jason Gunthorpe wrote:
> On Tue, Feb 03, 2026 at 09:22:13PM +0530, Shivaprasad G Bhat wrote:
>>> Then you'd want to introduce a new domain op to get the apertures
>>> instead of the single range hard coded into the domain struct. The new
>>> op would be able to return a list. We can use this op to return
>>> apertures for sign extension page tables too.
>>>
>>> Update iommufd to calculate the reserved regions by evaluating the
>>> whole list.
>>>
>>> I think you'll find this pretty straight forward, I'd do it as a
>>> followup patch to this one.
>>
>> Thanks. I will wait for that patch.
> I think you will have to make it :)


Sure. Thanks!


>
>> There are ioctl number conflicts like
>>
>> # grep -n "VFIO_BASE + 1[89]" include/uapi/linux/vfio.h | grep define
>> 940:#defineVFIO_DEVICE_BIND_IOMMUFD_IO(VFIO_TYPE, VFIO_BASE + 18)
>> 976:#defineVFIO_DEVICE_ATTACH_IOMMUFD_PT_IO(VFIO_TYPE, VFIO_BASE + 19)
>> 1833:#defineVFIO_IOMMU_SPAPR_UNREGISTER_MEMORY_IO(VFIO_TYPE, VFIO_BASE + 18)
>> 1856:#defineVFIO_IOMMU_SPAPR_TCE_CREATE_IO(VFIO_TYPE, VFIO_BASE + 19)
>> # grep -n "VFIO_BASE + 20" include/uapi/linux/vfio.h | grep define
>> 999:#defineVFIO_DEVICE_DETACH_IOMMUFD_PT_IO(VFIO_TYPE, VFIO_BASE + 20)
>> 1870:#defineVFIO_IOMMU_SPAPR_TCE_REMOVE_IO(VFIO_TYPE, VFIO_BASE + 20)
> It's Ok the compat codes will know what type it is operating in before
> it decodes any of those.


I agree, the additional PPC specific ioctls can be selectively handled based

on arch.


>
>> You are right. We do have some use cases beyond VMM, I will consider compat
>> driver only if it is helpful there.
> You can also use the type1 compat mode which will magically start
> working with PPC..
>
>>> You should also implement the BLOCKING domain type to make VFIO work
>>> better
>   
>> I am not sure how this could help making VFIO better. May be, I am not able
>> to imagine the advantages with the current platform domain approach
>> in place. Could you please elaborate more on this?
> VFIO always uses a BLOCKED domain when it opens the device, then it
> changes to a paging domain. If the driver doesn't support a native
> BLOCKED domain then it allocates an empty page table and uses that.
>
> A proper native BLOCKED domain has better error handling
> characteristics since it is not allowed to fail attach and it doesn't
> require allocation.
>
> I think you will also find what you are doing easier if you push the
> iommu_domain down through the PPC iommu ops instead of retaining these
> unnecessary historical layers.


I see there is some more history around this being discussed before on 
the patch here,

https://lore.kernel.org/all/20220701061751.1955857-1-aik@ozlabs.ru/

Will try to dig more and address this in future.

Thanks,

Shivaprasad

> Jason

