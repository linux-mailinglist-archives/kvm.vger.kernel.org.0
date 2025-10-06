Return-Path: <kvm+bounces-59551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F357BBF957
	for <lists+kvm@lfdr.de>; Mon, 06 Oct 2025 23:36:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 408DF188CE63
	for <lists+kvm@lfdr.de>; Mon,  6 Oct 2025 21:36:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11877264628;
	Mon,  6 Oct 2025 21:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YEtwGFNQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874181C84A2;
	Mon,  6 Oct 2025 21:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759786561; cv=none; b=WoOCC2RHs6C5nWOHBRpwigazT5HbI8wZOZXwzQu0Tpw13ZVzRMLb46YOhaeczwspM3hWBMvtYQMAIijqH86Iiu04WYzisKV1KpYHZrwmBYnYwyx5Fshjz4d8xzQG6LWM5lPTorYnWvfYRwy9m/C2tAC38mWvTdLqK69DFH9D3wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759786561; c=relaxed/simple;
	bh=etvkfma8yW1ZykwMn+puevnAsTMuzHWkX0vmF6waK8E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=km2cKybH7FlAIEFBayILoiHHOERq7B/CQkkeZE1IaecRv2VJivKGxMQ4ycnONqKW+WHEFxtsZkAHznirvNqfp33um4bxro8AfXspBlmUKGy4T0quG31a0+qkWlJr20AYgVm8SNYQikzmx0uzPR7Ol35TwBjR742QHBW7Oyg38J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YEtwGFNQ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 596FQIZB002608;
	Mon, 6 Oct 2025 21:35:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=K4xoou
	3f1/fGhaO7cCx95dIF5XW4C0r3jYUoc6ewByk=; b=YEtwGFNQoStRSrfsnedXUs
	NDZYTTBJ6TUUlYkbzcQ+vHR2PYLto5tL+8mzND4ICBSAiMTYXRgn5yH3U4QRNqfg
	HEUvxqDL16ULL81IvRb4OLoo0kdzljDziFlGl86Fu/UdjZ3/xGquWA3FXRafWVqo
	Gn34Xrc5prM9ARJyce9oPSBDcTjERuH6QZJ7zpdZWXJbt4xLqVzp7sDzjGyVYEZ1
	jI6LsJTEha5sb2w8WMyfl0yoq0Kkgt7C+hsRhXN+kP2aqaD6/OzSPeR854FN3c+9
	/QesgX0GsIZdT2jf/Fyfj57hKWA6YPekaRZ7+vtZ3XJ3hEdeVyxMphiF9Y1jvWQg
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49ju8ak79j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Oct 2025 21:35:55 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 596JamWh000882;
	Mon, 6 Oct 2025 21:35:54 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49ke9y0ben-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Oct 2025 21:35:54 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 596LZqW112780092
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Oct 2025 21:35:53 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B666D5804E;
	Mon,  6 Oct 2025 21:35:52 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 964005803F;
	Mon,  6 Oct 2025 21:35:51 +0000 (GMT)
Received: from [9.61.246.158] (unknown [9.61.246.158])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Oct 2025 21:35:51 +0000 (GMT)
Message-ID: <8c14d648-453c-4426-af69-4e911a1128c1@linux.ibm.com>
Date: Mon, 6 Oct 2025 14:35:49 -0700
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
References: <20250924171628.826-1-alifm@linux.ibm.com>
 <20250924171628.826-2-alifm@linux.ibm.com>
 <20251001151543.GB408411@p1gen4-pw042f0m>
 <ae5b191d-ffc6-4d40-a44b-d08e04cac6be@linux.ibm.com>
 <aOE1JMryY_Oa663e@wunner.de>
 <c0818c13-8075-4db0-b76f-3c9b10516e7a@linux.ibm.com>
 <aOQX6ZTMvekd6gWy@wunner.de>
Content-Language: en-US
From: Farhan Ali <alifm@linux.ibm.com>
In-Reply-To: <aOQX6ZTMvekd6gWy@wunner.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rQVBehlCCeBzgU_KJmb6rUFBE5xkGYKF
X-Authority-Analysis: v=2.4 cv=BpiQAIX5 c=1 sm=1 tr=0 ts=68e4363b cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=P-IC7800AAAA:8 a=llH-7ruy7LQ9Hh-1ergA:9
 a=QEXdDO2ut3YA:10 a=d3PnA9EDa4IxuAV0gXij:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA0MDAyMiBTYWx0ZWRfX0bNRaJrcwjVQ
 ib4JIC9SEXoS4U2+7/6fU6owftzvjZfIJAnP+9K7lSableKt1JtokQklf3aCUeU1IG8Rqz6KcjX
 eetWhkJZWij8rHi32vBSjttOCwlRI/zlb+1K4JCZyMY3yKqeNlC+nTIfedN8c0aHEdfjuNZPrWc
 7lSe+ar53fu6CzsXx8Yea9IAs9OKS4unYVfoMO5h5TAS/eJCTjQsa05Gxq0LcDP7YIppmkKU9gY
 sksL9yNF7eq1LUSjV2wXaTLkAs+iV9i6Ym44F71LqffLWKYtvFLpg9sovhe76hu9ZAjrfUw0RcA
 l6Y5nLjHwA9YVwh8uek+3VE2QicXHSAMxypahVvav/eZOXOsiJrF0N+2wb9p4JEfBfQa3QPRQm5
 XRZ57xg7OAQEKyAnvmzfZfBcQ1sixQ==
X-Proofpoint-ORIG-GUID: rQVBehlCCeBzgU_KJmb6rUFBE5xkGYKF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-06_06,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 suspectscore=0 bulkscore=0 impostorscore=0 adultscore=0 clxscore=1015
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2509150000
 definitions=main-2510040022


On 10/6/2025 12:26 PM, Lukas Wunner wrote:
> On Mon, Oct 06, 2025 at 10:54:51AM -0700, Farhan Ali wrote:
>> On 10/4/2025 7:54 AM, Lukas Wunner wrote:
>>> I believe this also makes patch [01/10] in your series unnecessary.
>> I tested your patches + patches 2-10 of this series. It unfortunately didn't
>> completely help with the s390x use case. We still need the check to in
>> pci_save_state() from this patch to make sure we are not saving error
>> values, which can be written back to the device in pci_restore_state().
> What's the caller of pci_save_state() that needs this?
>
> Can you move the check for PCI_POSSIBLE_ERROR() to the caller?
> I think plenty of other callers don't need this, so it adds
> extra overhead for them and down the road it'll be difficult
> to untangle which caller needs it and which doesn't.

The caller would be pci_dev_save_and_disable(). Are you suggesting 
moving the PCI_POSSIBLE_ERROR() prior to calling pci_save_state()?

>
>> As part of the error recovery userspace can use the VFIO_DEVICE_RESET to
>> reset the device (pci_try_reset_function()). The function call for this is:
>>
>> pci_dev_save_and_disable <https://elixir.bootlin.com/linux/v6.17.1/C/ident/pci_dev_save_and_disable>();
>>
>> __pci_reset_function_locked <https://elixir.bootlin.com/linux/v6.17.1/C/ident/__pci_reset_function_locked>();
>>
>> pci_dev_restore
>> <https://elixir.bootlin.com/linux/v6.17.1/C/ident/pci_dev_restore>();
>>
>> So we can end up overwriting the initial saved state (added by you in
>> pci_bus_add_device()). Do we need to update the pci_dev_save_and_disable()
>> not to save the state?
> The state saved on device addition is just the initial state and
> it is fine if later on it gets updated (which is a nicer term than
> "overwritten").  E.g. when portdrv.c instantiates port services
> and drivers are bound to them, various registers in Config Space
> are changed, hence pcie_portdrv_probe() calls pci_save_state()
> again.
>
> However we can discuss whether pci_save_state() is still needed
> in pci_dev_save_and_disable().

The commit 8dd7f8036c12 ("PCI: add support for function level reset") 
introduced the logic of saving/restoring the device state after an FLR. 
My assumption is it was done to save the most recent state of the device 
(as the state could be updated by drivers). So I think it would still 
make sense to save the device state in pci_dev_save_and_disable() if the 
Config Space is still accessible?

Thanks

Farhan


