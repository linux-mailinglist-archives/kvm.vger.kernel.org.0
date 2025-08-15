Return-Path: <kvm+bounces-54813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EC24B287DA
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 23:39:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E2D571D05CCE
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 21:39:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4459A2C0F61;
	Fri, 15 Aug 2025 21:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="EfF7fv5J"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6092BE042;
	Fri, 15 Aug 2025 21:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755293800; cv=none; b=DEVGjS/oNKbBMkTh5+SlSp5frrWnJYmMRc6kL+YUSON/hjlyiNBWu2T3At99nnTH4K2pdtnQ7luMcPUfBcyV27wyi/0LtEjf16Ki6G4Oyhc/SPuiO6GIuP0TZVt7rWO6BzDkX0F8kYFImqimVsHmSoXtYJipnggj3bGc/hILNdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755293800; c=relaxed/simple;
	bh=B/twj5r3juH/ifMdr1BYMzMd10c1Lu7QAWhOIBEVKYg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qNHHZDRZbBjuz3A9vgVS6I/f63vQ1kWV0R7KDKoCj+E6JO3pRxo3DsvBT5T6on9taU81soL2R0M+xxAxYMxY7W7VAIT8e64b/YMNfgsIx9j9nlZ44RDMJGyxKQZ3Z5Ixbzh8sd3clLkTGYX+xOEXKu778AiO92xtUYuZncPUBXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=EfF7fv5J; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57FGwQIX020189;
	Fri, 15 Aug 2025 21:36:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=nufP6a
	Tmq5KxJFQkk20gGDjNqydT7/AukDK59rrdrF4=; b=EfF7fv5JqnTP5wcdz8c42G
	jjD0vfYOCWOXWqNMgvYSJ37iyuO2k58Nl75W5aYw+F5q3cHOUqsxhQsu2zgLTIh7
	2jjajxqRS113QKlx8ekQxRL38QVxm6RzPXxS3nsPlf6nxl2BhTR9yK05edpyVsjR
	VlFRzlxCO6iBNKiUFB8dbZ4FRwecvuKe4OkouFgPYG+a8Wl46UiqTBzq6gPglmFw
	b7PXB9MssOxnQYHI9+AEovtSDdFFa+9byhF4xBVS34EJsV5cVKGLcy0OrB8t2dIV
	YTy5WcDLylwg0rydO0f17HymvHE3MbqxlowxLPxLYgYo3NJ4ZLUzYils0IUCfLbw
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48duruscg7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 Aug 2025 21:36:31 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57FKjg8q020752;
	Fri, 15 Aug 2025 21:36:30 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48ehnqaqv2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 Aug 2025 21:36:30 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57FLaToq25232098
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 21:36:29 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4ACE85805C;
	Fri, 15 Aug 2025 21:36:29 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8823F58058;
	Fri, 15 Aug 2025 21:36:28 +0000 (GMT)
Received: from [9.61.255.132] (unknown [9.61.255.132])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 15 Aug 2025 21:36:28 +0000 (GMT)
Message-ID: <ffc2fc08-2e95-4b35-840c-be8f5511340f@linux.ibm.com>
Date: Fri, 15 Aug 2025 14:36:26 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 6/6] vfio: Allow error notification and recovery for
 ISM device
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        schnelle@linux.ibm.com, mjrosato@linux.ibm.com
References: <20250814204850.GA346571@bhelgaas>
 <60855b41-a1ad-4966-aa5e-325256692279@linux.ibm.com>
 <20250815144855.51f2ac24.alex.williamson@redhat.com>
Content-Language: en-US
From: Farhan Ali <alifm@linux.ibm.com>
In-Reply-To: <20250815144855.51f2ac24.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xUyHZzTahb3OF9DOSMsN1wJfwXWVoSv7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEyMDIyNCBTYWx0ZWRfX7hOa+R1ILWL5
 63vK1jZFzLhCXX6Qax42tLoVJAAMSwWTJX33/m/DIzuswiYkE+6JAtiG7rUwBT+fLu2lpt3m2Wi
 sofHlQa2JvmDmz/JySzIkSv3Fb505HafAKKkATVuPSNFy/1ZKEbRqAh+RwTvjO3DprcD9nTu/dc
 DPZYmtKC7fKAZq8IUUCOMemcZdXeCIcnQCM0gEMd4rhktb9WUjnYMDmV4OucNqKadyeLYhA2KCa
 Omnpo/K156/RrKefkeke7BoOfcbrOkY1VMGXsVgD+8IFSLQuOg+I5/8dtP0e8VJevyHxtHPUR7c
 R3vNrq4sy6F02gVMRJTbrh7hUKtx8d1a4WNpdDGCT+YtVVe5ZXtMlyuH8+3tGH7OGLOlM6M2wBT
 lRVk7PfP
X-Authority-Analysis: v=2.4 cv=QtNe3Uyd c=1 sm=1 tr=0 ts=689fa85f cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=qcL1lsCXI_0MITy6uOMA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: xUyHZzTahb3OF9DOSMsN1wJfwXWVoSv7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-15_07,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 phishscore=0 clxscore=1015 malwarescore=0
 spamscore=0 suspectscore=0 impostorscore=0 bulkscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508120224


On 8/15/2025 1:48 PM, Alex Williamson wrote:
> On Thu, 14 Aug 2025 14:02:05 -0700
> Farhan Ali <alifm@linux.ibm.com> wrote:
>
>> On 8/14/2025 1:48 PM, Bjorn Helgaas wrote:
>>> On Wed, Aug 13, 2025 at 10:08:20AM -0700, Farhan Ali wrote:
>>>> VFIO allows error recovery and notification for devices that
>>>> are PCIe (and thus AER) capable. But for PCI devices on IBM
>>>> s390 error recovery involves platform firmware and
>>>> notification to operating system is done by architecture
>>>> specific way. The Internal Shared Memory(ISM) device is a legacy
>>>> PCI device (so not PCIe capable), but can still be recovered
>>>> when notified of an error.
>>> "PCIe (and thus AER) capable" reads as though AER is required for all
>>> PCIe devices, but AER is optional.
>>>
>>> I don't know the details of VFIO and why it tests for PCIe instead of
>>> AER.  Maybe AER is not relevant here and you don't need to mention
>>> AER above at all?
>> The original change that introduced this commit dad9f89 "VFIO-AER:
>> Vfio-pci driver changes for supporting AER" was adding the support for
>> AER for vfio. My assumption is the author thought if the device is AER
>> capable the pcie check should be sufficient? I can remove the AER
>> references in commit message. Thanks Farhan
> I've looked back through discussions when this went in and can't find
> any specific reasoning about why we chose pci_is_pcie() here.  Maybe
> we were trying to avoid setting up an error signal on devices that
> cannot have AER, but then why didn't we check specifically for AER.
> Maybe some version used PCIe specific calls in the handler that we
> didn't want to check runtime, but I don't spot such a dependency now.
>
> Possibly we should just remove the check.  We're configuring the error
> signaling on the vast majority of devices, it's extremely rare that it
> fires anyway, reporting it on a device where it cannot trigger seems
> relatively negligible and avoids extra ugly code.  Thanks,
>
> Alex

Okay will remove the check and re-word the commit message.

Thanks
Farhan


