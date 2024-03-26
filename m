Return-Path: <kvm+bounces-12657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F91F88B98F
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 05:57:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 77383B228F3
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 04:57:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A76582D72;
	Tue, 26 Mar 2024 04:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="R8UAajQM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E829229B0;
	Tue, 26 Mar 2024 04:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711429031; cv=none; b=PiplrbfEv68UhkSmsMmXg+83XrzHenxw1+aXlx6Rpovp+1zQ9ff6PjTNPzkddjs8icEVslPilnJROM0mqOf90a3/DJTnAOnQQ4U9DMyzZk47pymQEOS0k3wbSHDFmUM8U1ghJSbto+45qlLf/soSHWmyTg44llQ8MlCPvSV1wfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711429031; c=relaxed/simple;
	bh=wTPd6VG/y+IacKYaZJPunIqqKUApdLnWu6mqqf8Q/8g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kJi+4iQqM5b70Xme9TMIQPPzeS7U8AaeNph8R+JtnEEbwwxI7WaSUlc3hGxvlGRn1T5M+j2y3w/2+Pgz0eDUf9QGHtBWOCoHZAkQd+LVEUt97RZhrFx60DsWG8rVzitobwxuK/6UlQkGbOvBbkU9mwiykuSX8m4U89A8D/c8a8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=R8UAajQM; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42Q3xBZ1027625;
	Tue, 26 Mar 2024 04:56:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=NBOgjNgvGMe34QEDF7gDzP15BhfQn7A3sJSHVdmYu2g=;
 b=R8UAajQMosouNFzn0g97zjG0zc9NFmx8IvPh73c3GXb1i4Y3kE4NfPuBAnCPaNy8ZTdk
 kK96FoZBXIAgJULcMjiKij4avCgtOtUBxIZig31WfcbKSprLzl6QBanjYWXYvs2mtowE
 JulKlInNM0P3Jyqtg6IY0ruhvVSa/PwNGJmVyqXpHj/7+4VzPZxBTyGCfSP3lBGQTAYE
 gaeAE6VvVaa60jNwXyBka7HlfmkUIDhfSIFQZtocE1gtFVqASAG8iEIR5vAJq9TOC3mI
 44GHhPntfXJmz4nP61d8X74AyPY+AhHZui7NJezlwji7HZxWUDROsmhfb2kMAYjLwBbq Og== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x3krygdyp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Mar 2024 04:56:45 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42Q4uiQM013896;
	Tue, 26 Mar 2024 04:56:44 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x3krygdyj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Mar 2024 04:56:44 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 42Q34Vx4025458;
	Tue, 26 Mar 2024 04:56:43 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3x2awmng5r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Mar 2024 04:56:43 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 42Q4ubng46530840
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 04:56:39 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A956320040;
	Tue, 26 Mar 2024 04:56:37 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 835432004F;
	Tue, 26 Mar 2024 04:56:33 +0000 (GMT)
Received: from [9.43.56.140] (unknown [9.43.56.140])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 26 Mar 2024 04:56:33 +0000 (GMT)
Message-ID: <b102eb8e-c3b5-4d65-9113-3cc43e980b9b@linux.ibm.com>
Date: Tue, 26 Mar 2024 10:26:32 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 3/3] pseries/iommu: Enable DDW for VFIO TCE create
Content-Language: en-US
To: Michael Ellerman <mpe@ellerman.id.au>, tpearson@raptorengineering.com,
        alex.williamson@redhat.com, linuxppc-dev@lists.ozlabs.org
Cc: npiggin@gmail.com, christophe.leroy@csgroup.eu, aneesh.kumar@kernel.org,
        naveen.n.rao@linux.ibm.com, gbatra@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com, aik@ozlabs.ru, jgg@ziepe.ca,
        robh@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        aik@amd.com, msuchanek@suse.de, jroedel@suse.de, vaibhav@linux.ibm.com,
        svaidy@linux.ibm.com
References: <171026724548.8367.8321359354119254395.stgit@linux.ibm.com>
 <171026728072.8367.13581504605624115205.stgit@linux.ibm.com>
 <87zfv22szi.fsf@mail.lhotse>
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
In-Reply-To: <87zfv22szi.fsf@mail.lhotse>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: H7yzpYNpzHmY0p4JXdLihxeEU_FspdxM
X-Proofpoint-GUID: bFFropFSeiwnwi_t5Nz0u3h9lb-0mPi2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_02,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 mlxlogscore=999 spamscore=0 suspectscore=0 phishscore=0
 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0 lowpriorityscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403260029

Hi Michael,

On 3/13/24 18:23, Michael Ellerman wrote:
> Hi Shivaprasad,
>
> Shivaprasad G Bhat <sbhat@linux.ibm.com> writes:
>> The commit 9d67c9433509 ("powerpc/iommu: Add \"borrowing\"
>> iommu_table_group_ops") implemented the "borrow" mechanism for
>> the pSeries SPAPR TCE. It did implement this support partially
>> that it left out creating the DDW if not present already.
>>
>> The patch here attempts to fix the missing gaps.
>>   - Expose the DDW info to user by collecting it during probe.
>>   - Create the window and the iommu table if not present during
>>     VFIO_SPAPR_TCE_CREATE.
>>   - Remove and recreate the window if the pageshift and window sizes
>>     do not match.
>>   - Restore the original window in enable_ddw() if the user had
>>     created/modified the DDW. As there is preference for DIRECT mapping
>>     on the host driver side, the user created window is removed.
>>
>> The changes work only for the non-SRIOV-VF scenarios for PEs having
>> 2 DMA windows.
> This crashes on powernv.


Thanks for pointing this out.  I will take care of this in v2 of this RFC.


Regards,

Shivaprasad


