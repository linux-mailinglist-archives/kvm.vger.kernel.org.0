Return-Path: <kvm+bounces-16538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E1E0B8BB3A7
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 21:04:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F0671F2547A
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 19:04:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CDAF155320;
	Fri,  3 May 2024 19:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tcB95ld7"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D988719470;
	Fri,  3 May 2024 19:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714763054; cv=none; b=FQDxkiqhDMzuCO3yF+DRXA7iZzDvggKqwuv0Rg4rzDgXv1qZaWeq7wrGkYVqvrcGf353mDUj6D1j6eE1LGyzGmqiiFyyZSjf/0MdteTyNLMR7wmBIS/AuuF7FSGMEOwHEAzitRDJ3FxSwhY1fCJ5YIhMBsFtvMeUpN8JjOPe7J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714763054; c=relaxed/simple;
	bh=yZu7Wfwbh9rMiIjMpuuZBffDox68iEv5CAmzsJErwYI=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=JoUAlU0d3Kk2nOdwWXLp0U4CKzL0AKxzC7+zj0F/+YbWMbi7rZHbpTc4BTtraDd/vjRLZI08wEKLaHbjAhc/xWmWXZa+OgxKSMDnUHKYz3kWMDGP0c1tspHL+EJlw7zfQWb0+iRVVsvfAXfRhmjtojfF8Fm27lpDUAFIOtzGYG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tcB95ld7; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 443Ivu5q028623;
	Fri, 3 May 2024 19:04:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : from : subject : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=WUBN60VCN41QsJywwzVL25QchOzXSBNS8hgmPyNLXoY=;
 b=tcB95ld7F7DijM4jVRbG2d1AYQmdxCaHJM34Q3PoDLipUPJQ1pJ543y3VIPdbs2k+oCs
 QUCw1mzJFaWp9Y1bbiJfOIUCmkb3XH3ZBHQhVlFO9CLQOyoAHYIUbU2n3tM5mDJjsCQN
 WqJUROicsJyS7pRjxAt+iP4EmT2xYqcbGwRDLxc+pcPJ70hfrvAr/lp3S5zA3Zaogfwz
 kgQh8Z9jPTZUURxlBaGgFsS2i4+f5BN+ImGaSAs3Ny10dPsBD3f560xJsQVJlQ0cVPsS
 nT8Cas4rsVJ8BQpoIwxDaE4niuwHEipEdZ59VE/trks9J3FCVoT/fy1C/3dH6zn2Bmfm Rw== 
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xw5ne00ja-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 May 2024 19:04:07 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 443HZclN003184;
	Fri, 3 May 2024 19:04:06 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xscppyc96-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 May 2024 19:04:05 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 443J42N450790692
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 3 May 2024 19:04:04 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E3F7B20063;
	Fri,  3 May 2024 19:04:01 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 26D3620040;
	Fri,  3 May 2024 19:03:57 +0000 (GMT)
Received: from [9.79.188.181] (unknown [9.79.188.181])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  3 May 2024 19:03:56 +0000 (GMT)
Message-ID: <8c28a1d5-ac84-445b-80e6-a705e6d7ff1b@linux.ibm.com>
Date: Sat, 4 May 2024 00:33:53 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Subject: Re: [RFC PATCH v2 0/6] powerpc: pSeries: vfio: iommu: Re-enable
 support for SPAPR TCE VFIO
To: Alexey Kardashevskiy <aik@amd.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: mpe@ellerman.id.au, tpearson@raptorengineering.com,
        alex.williamson@redhat.com, linuxppc-dev@lists.ozlabs.org,
        npiggin@gmail.com, christophe.leroy@csgroup.eu,
        aneesh.kumar@kernel.org, naveen.n.rao@linux.ibm.com,
        gbatra@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, aik@ozlabs.ru,
        ruscur@russell.cc, robh@kernel.org, linux-kernel@vger.kernel.org,
        joel@jms.id.au, kvm@vger.kernel.org, msuchanek@suse.de,
        oohall@gmail.com, mahesh@linux.ibm.com, jroedel@suse.de,
        vaibhav@linux.ibm.com, svaidy@linux.ibm.com
References: <171450753489.10851.3056035705169121613.stgit@linux.ibm.com>
 <20240501140942.GA1723318@ziepe.ca>
 <703f15b0-d895-4518-9886-0827a6c4e769@amd.com>
Content-Language: en-US
In-Reply-To: <703f15b0-d895-4518-9886-0827a6c4e769@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: poz_TeyDDzWMN_PHYlELhlAb9MGLU0Q6
X-Proofpoint-GUID: poz_TeyDDzWMN_PHYlELhlAb9MGLU0Q6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-03_13,2024-05-03_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 priorityscore=1501 malwarescore=0 phishscore=0
 impostorscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2405030134

On 5/2/24 06:59, Alexey Kardashevskiy wrote:
>
>
> On 2/5/24 00:09, Jason Gunthorpe wrote:
>> On Tue, Apr 30, 2024 at 03:05:34PM -0500, Shivaprasad G Bhat wrote:
>>> RFC v1 was posted here [1]. As I was testing more and fixing the
>>> issues, I realized its clean to have the table_group_ops implemented
>>> the way it is done on PowerNV and stop 'borrowing' the DMA windows
>>> for pSeries.
>>>
>>> This patch-set implements the iommu table_group_ops for pSeries for
>>> VFIO SPAPR TCE sub-driver thereby enabling the VFIO support on POWER
>>> pSeries machines.
>>
>> Wait, did they previously not have any support?
> >
>> Again, this TCE stuff needs to go away, not grow. I can grudgingly
>> accept fixing it where it used to work, but not enabling more HW that
>> never worked before! :(
>
>
> This used to work when I tried last time 2+ years ago, not a new 
> stuff. Thanks,
>
Thanks Alexey for pitching in.


Hi Jason,


As Alexey implied, this used to work in the past.


The support for pSeries VFIO exists for a long time, and the support
for VFIO_SPAPR_TCE_v2_IOMMU also was added with
9d67c9433509 ("powerpc/iommu: Add "borrowing" iommu_table_group_ops")


The commit 090bad39b237a ("powerpc/powernv: Add indirect levels to 
it_userspace")
broke the userspace view for pSeries, which the Patch 6 here tries to
bring back.


We found more issues with 9d67c9433509 and I felt its
better to stop "borrowing" the DMA windows as that would be
cleaner which is what is done in Patch 6.


In this process we discovered few bugs in upstream as well, which
we have been trying to fix and have posted few of fixes earlier like,
d2d00e15808 powerpc: iommu: Bring back table group release_ownership() call
83b3836bf83 iommu: Allow ops->default_domain to work when !CONFIG_IOMMU_DMA


So, this patch series tries to fix some more issues(patch 2, 4, 6)
coupled with some code refactoring(1, 3, 5 & 6) to stop "borrowing"
DMA windows.


We have legacy workloads using VFIO in userspace/kvm guests running
on downstream distro kernels. We want these workloads to be able to
continue running on our arch.


Going forward we are planning to have the IOMMUFD support for PPC64,
I firmly believe the refactoring in this patch series is a step in
that direction.


Thanks,
Shivaprasad

