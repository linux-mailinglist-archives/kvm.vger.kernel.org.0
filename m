Return-Path: <kvm+bounces-59725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C4BA1BCA4DF
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 19:02:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 935111891174
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 17:03:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74A9D238C36;
	Thu,  9 Oct 2025 17:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YulqAWs9"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BD11F5827;
	Thu,  9 Oct 2025 17:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760029345; cv=none; b=bM8u7zBU+nNd1SVe7fKFc4dFVZNU/Y1bqLfDqQkuF39H2eNA2nbN/cxslL/cLFtn3zLDpBO9mdV7CUrCaalB7iPMZXIQtEYeEauW8cph1Cv7RvqUj5YmSwfm1O4aYOhku85vdMmmr9m0sqntC4BOxkfqebu6Eigdu018Om515Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760029345; c=relaxed/simple;
	bh=QgnR/HwhNhSQ9rPGYBD4UO6dcq7lD76CLURSX9hdWFs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bRZQbEX8JrLX2kI+uRBzfPCutojTa4L/fblEJdDZfqi3hvy/0fsVttXaBBfSMwBW9kkaGpl4GnQbV5rkmN66y0SPbyjFT3ArBZ77NtCLxRoY3gYhaEh4yBWPyX2yWXvZhBe5R9qRrwYPWSj0crjwIDBSOx/571qmglM2d7znLsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YulqAWs9; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 599FCtkj030354;
	Thu, 9 Oct 2025 17:02:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=7uVDGY
	DGuD7pi8jbA4svzyEeWQPOvkF6IhUXF9ciUCQ=; b=YulqAWs9ZQC+9FGwk678il
	/sPhxXN6mEIEgBvqddeQUXa7LX8AAkDIS2UMYgvPPI/nPg8freREb2OhGflL72Zb
	gyffJmWGt+OeUC+4KOWNmH0/d30sVmW0fbEbkL+u5Mq67YYz7qiJdq3HWgi7diJY
	g6dgYQx+bNk8aaPB7Cc4k6S7Q1q+1EfOS697LDvKV3VCaD2NwffRsCtpeL7W2FlT
	pAHg1WXvTGQd/wapxzogbRa59gNQ9TRZIfFUrkMifvEh1qCwKiUC+arjnmoYw7Yv
	fnIza5cr4o8eqPEqGkSfjh+XJbQTCDqxMSGxIf3K+2/3BufN1nrNTG5Z30BcxvDA
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49nv81p19h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Oct 2025 17:02:17 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 599FUJRe021016;
	Thu, 9 Oct 2025 17:02:16 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 49nv8snnht-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Oct 2025 17:02:16 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 599H2ENJ26739184
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 9 Oct 2025 17:02:15 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 982025805C;
	Thu,  9 Oct 2025 17:02:14 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C444458051;
	Thu,  9 Oct 2025 17:02:13 +0000 (GMT)
Received: from [9.61.255.148] (unknown [9.61.255.148])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  9 Oct 2025 17:02:13 +0000 (GMT)
Message-ID: <3df48e3e-48e1-4cfb-aca9-7af606481b7c@linux.ibm.com>
Date: Thu, 9 Oct 2025 10:02:12 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/10] PCI: Avoid saving error values for config space
To: Lukas Wunner <lukas@wunner.de>
Cc: Benjamin Block <bblock@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, alex.williamson@redhat.com,
        helgaas@kernel.org, clg@redhat.com, schnelle@linux.ibm.com,
        mjrosato@linux.ibm.com
References: <20251001151543.GB408411@p1gen4-pw042f0m>
 <ae5b191d-ffc6-4d40-a44b-d08e04cac6be@linux.ibm.com>
 <aOE1JMryY_Oa663e@wunner.de>
 <c0818c13-8075-4db0-b76f-3c9b10516e7a@linux.ibm.com>
 <aOQX6ZTMvekd6gWy@wunner.de>
 <8c14d648-453c-4426-af69-4e911a1128c1@linux.ibm.com>
 <aOZoWDQV0TNh-NiM@wunner.de>
 <21ef5524-738a-43d5-bc9a-87f907a8aa70@linux.ibm.com>
 <aOaqEhLOzWzswx8O@wunner.de>
 <6c514ba0-7910-4770-903f-62c3e827a40b@linux.ibm.com>
 <aOc_k2MjZI6hYgKy@wunner.de>
Content-Language: en-US
From: Farhan Ali <alifm@linux.ibm.com>
In-Reply-To: <aOc_k2MjZI6hYgKy@wunner.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bafFVx3f06gl-_Yidcp7EXRZxhZ3rqMO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfX/qH7lxY8ol5y
 Xo9Y5lGDGb5MYDIkjwe/UN7P5YbmY3DxROtMTHKu4+QTBPrlj95ySAboK6G2UIhyMdhFkzHjUbB
 Inysn7MGvwPFfPBiKrfUHPgIUUdnPYtFWB3xFETRH5ynM8rcWlPovER2rUYhTU2ltsP60MNKgaj
 poksRuo4rNHMac/qtvbKZK1f75pkArPdpvimKUzt5XUJ6tRQZG/gaoz6Yk30ZiT/9WgqS3VBH/O
 BDAJeyIN2ZtGNPhRSttDMOz3ZnlsTtkvW1gsLSdt2odWs/hrU80M6Sz+uPAH9VFmPfQulM9reKu
 TqQLnFY8CV9JdkcDo716BopusxQJzhCAmuyHiYb8Zh5oe4iu8k3AXPVgoi0NzRxhzK7+ZJqvUY1
 xNE4B2/p3ixUnZXrcHaZWioanGCYmQ==
X-Authority-Analysis: v=2.4 cv=cKntc1eN c=1 sm=1 tr=0 ts=68e7ea99 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=DbQBQAxenkTviduvMPIA:9
 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: bafFVx3f06gl-_Yidcp7EXRZxhZ3rqMO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-09_06,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 phishscore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510080121


On 10/8/2025 9:52 PM, Lukas Wunner wrote:
> On Wed, Oct 08, 2025 at 02:55:56PM -0700, Farhan Ali wrote:
>>>> On 10/8/2025 6:34 AM, Lukas Wunner wrote:
>>>>> I also don't quite understand why the VM needs to perform a reset.
>>>>> Why can't you just let the VM tell the host that a reset is needed
>>>>> (PCI_ERS_RESULT_NEED_RESET) and then the host resets the device on
>>>>> behalf of the VM?
>> The reset is not performed by the VM, reset is still done by the host. My
>> approach for a VM to let the host know that reset was needed, was to
>> intercept any reset instructions for the PCI device in QEMU. QEMU would then
>> drive a reset via VFIO_DEVICE_RESET. Maybe I am missing something, but based
>> on what we have today in vfio driver, we don't have a mechanism for
>> userspace to reset a device other than VFIO_DEVICE_RESET and
>> VFIO_PCI_DEVICE_HOT_RESET ioctls.
> The ask is for the host to notify the VM of the ->error_detected() event
> and the VM then responding with one of the "enum pci_ers_result" values.

Maybe there is some confusion here. Could you clarify what do you mean 
by VM responding with "enum pci_ers_result" values? Is it a device 
driver (for example an NVMe driver) running in the VM that should do 
that? Or is it something else you are suggesting?

Let me try to clarify what I am trying to do with this patch series. For 
passthrough devices to a VM, the driver bound to the device on the host 
is vfio-pci. vfio-pci driver does support the error_detected() callback 
(vfio_pci_core_aer_err_detected()), and on an PCI error s390x recovery 
code on the host will call the vfio-pci error_detected() callback. The 
vfio-pci error_detected() callback will notify userspace/QEMU via an 
eventfd, and return PCI_ERS_RESULT_CAN_RECOVER. At this point the s390x 
error recovery on the host will skip any further action(see patch 7) and 
let userspace drive the error recovery.

Once userspace/QEMU is notified, it then inject this error into the VM 
so device drivers in the VM can take recovery actions. For example for a 
passthrough NVMe device, the VM's OS NVMe driver will access the device. 
At this point the VM's NVMe driver's error_detected() will drive the 
recovery by returning PCI_ERS_RESULT_NEED_RESET, and the s390x error 
recovery in the VM's OS will try to do a reset. Resets are privileged 
operations and so the VM will need intervention from QEMU to perform the 
reset. QEMU will invoke the ioctls to now notify the host that the VM is 
requesting a reset of the device. The vfio-pci driver on the host will 
then perform the reset on the device.

Thanks Farhan


