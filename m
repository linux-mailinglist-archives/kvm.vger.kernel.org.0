Return-Path: <kvm+bounces-16846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 031CC8BE711
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 17:11:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ADD811F2668C
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 15:11:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94167161914;
	Tue,  7 May 2024 15:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QPc2lD4J"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4059A1EB3F;
	Tue,  7 May 2024 15:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715094663; cv=none; b=iGjlbOXmpSQRUQI1vwtfSLRUW/YxrhIH46WMbeZT3TqEeLIEbib77mPghIPa9vJf9hErm5tuDFQrS52Am644qPgi2lJ2Ozc0McApNNji/ni3WmyIOXOhdcOq7jpH5sRiY1MXUUabIapSCzY1/9KodNnne1+1kfPd1TA61yt3yA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715094663; c=relaxed/simple;
	bh=VMnu+pDmL+oYK7xiki7kzb8soYvaBtZJpE+R7cKcFxY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LadJ00ZzYx54aipe8GmeWztEnviAWA4pcemXtzvmHT6t04yUlwUGBD2+4c2+8hck8f+Eo7he9OetB+VjDDi5XxlCTgun3gc+ay1eQVe0WK7nGvqm28yNRUhhTmMBnpoXzjcZwYgZKx0IxBfz0G7HPJAZ7IcDZkTML00Z7KuyJ5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QPc2lD4J; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 447Em1DS018420;
	Tue, 7 May 2024 15:10:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=VMnu+pDmL+oYK7xiki7kzb8soYvaBtZJpE+R7cKcFxY=;
 b=QPc2lD4JTvtN0dOCusf02LiAEeVIKQODE0mSW35TJxQ5vrTqx+UMkAh0gmsf73NJ73ng
 WlXvDL5yZGwnzPar137I8oybZ29oTtih3lLodvw++S3HycN+Si2MTycqZLyGlKQaXmf0
 K8OxXGJkfwXOhKdBJCXmVHHuTIQjHIX+AlOxRul/MoDEnstoIuttFFlerjIOXEfpzPtE
 5qvPgsB7tUkJEyXa4/LDoFCcA7K6lVFPTeYOfD7wKJHsnyeN37RCkyFC+fQcqzi/c12p
 kQuyiHpLdGVaQDPX9JJzXqLM8XzK4BbH1WO34z2kwpObYPBeSp5x/kcVqmV3GONr10wL jQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xypc6g25h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 15:10:35 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 447FAYij024802;
	Tue, 7 May 2024 15:10:35 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xypc6g25d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 15:10:34 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 447Eg5bt028576;
	Tue, 7 May 2024 15:10:33 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xwyr070js-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 15:10:33 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 447FAR8820906388
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 May 2024 15:10:29 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B3D8820043;
	Tue,  7 May 2024 15:10:27 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E7E782004E;
	Tue,  7 May 2024 15:10:23 +0000 (GMT)
Received: from [9.79.183.213] (unknown [9.79.183.213])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  7 May 2024 15:10:23 +0000 (GMT)
Message-ID: <1c277ae0-14cc-4d79-a7a1-455ed996b67a@linux.ibm.com>
Date: Tue, 7 May 2024 20:40:23 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 0/6] powerpc: pSeries: vfio: iommu: Re-enable
 support for SPAPR TCE VFIO
Content-Language: en-US
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Alexey Kardashevskiy <aik@amd.com>, mpe@ellerman.id.au,
        tpearson@raptorengineering.com, alex.williamson@redhat.com,
        linuxppc-dev@lists.ozlabs.org, npiggin@gmail.com,
        christophe.leroy@csgroup.eu, aneesh.kumar@kernel.org,
        naveen.n.rao@linux.ibm.com, gbatra@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com, aik@ozlabs.ru, ruscur@russell.cc,
        robh@kernel.org, linux-kernel@vger.kernel.org, joel@jms.id.au,
        kvm@vger.kernel.org, msuchanek@suse.de, oohall@gmail.com,
        mahesh@linux.ibm.com, jroedel@suse.de, vaibhav@linux.ibm.com,
        svaidy@linux.ibm.com
References: <171450753489.10851.3056035705169121613.stgit@linux.ibm.com>
 <20240501140942.GA1723318@ziepe.ca>
 <703f15b0-d895-4518-9886-0827a6c4e769@amd.com>
 <8c28a1d5-ac84-445b-80e6-a705e6d7ff1b@linux.ibm.com>
 <20240506174357.GF901876@ziepe.ca>
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
In-Reply-To: <20240506174357.GF901876@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: J4Gsgo8V3_3M_QYRnBmu-upxnqO-CmvX
X-Proofpoint-ORIG-GUID: TasHpAtQk2MCFNjakLGTISoKhTN09Sii
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-07_08,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 spamscore=0 suspectscore=0 priorityscore=1501 mlxscore=0 impostorscore=0
 lowpriorityscore=0 clxscore=1015 phishscore=0 mlxlogscore=960
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405070104

Hi Jason,


On 5/6/24 23:13, Jason Gunthorpe wrote:
> On Sat, May 04, 2024 at 12:33:53AM +0530, Shivaprasad G Bhat wrote:
>> We have legacy workloads using VFIO in userspace/kvm guests running
>> on downstream distro kernels. We want these workloads to be able to
>> continue running on our arch.
> It has been broken since 2018, I don't find this reasoning entirely
> reasonable :\

Though upstream has been broken since 2018 for pSeries, the breaking

patches got trickled into downstream distro kernels only in the last few

years. The legacy workloads that were running on PowerNV with these

downstream distros are now broken on the pSeries logical partitions

without the fixes in this series.

>> I firmly believe the refactoring in this patch series is a step in
>> that direction.
> But fine, as long as we are going to fix it. PPC really needs this to
> be resolved to keep working.

Thanks, We are working on it.


Regards,

Shivaprasad

>
> Jason

