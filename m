Return-Path: <kvm+bounces-59533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 78A9FBBEDBB
	for <lists+kvm@lfdr.de>; Mon, 06 Oct 2025 19:55:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id CE5D834A8A1
	for <lists+kvm@lfdr.de>; Mon,  6 Oct 2025 17:55:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51ACC2D29C8;
	Mon,  6 Oct 2025 17:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NstfYjh8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B4127A135;
	Mon,  6 Oct 2025 17:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759773304; cv=none; b=b7lzGwFoJHfpEgsfNnnVOd+SoATU4Hpo5c91Lic1dVzatvM0yA9NJMM9xwWx/G7hUmmTsyAfMkTvXWDb7IJQ3cSxkGLUB1mLjkZhv4GUCYdse8dczz2BAS/hOLtAckbh0QpPlMI+aMGLV0aQZoC15feYBydK2Dph/k4OTFrx98k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759773304; c=relaxed/simple;
	bh=OrzhZUhqaOPvxSScylhPqu1GUjJmZzUCqVaJ6svNe0A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=euLdmqJvTY7LjAyfKgZYWzJfxQJUC8Ipuh+mzAVoPnRRUwXhUC4uXRjmUTt6t2z5XPruMHQ479uc+jJeUOcDOQfxTvbZD5B494U5r4jiyElcUleLtv6dBRqgx2bKhGI0bgacMg3aSxe3Pyb+u+K7f/PUhv7lQfa3CWGLcTS5u4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NstfYjh8; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 596DXi6D013981;
	Mon, 6 Oct 2025 17:54:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=nnlGO/
	buJD5PNd+VzUXVnHoPh9UB9cRnsDAnS8lcYeA=; b=NstfYjh8M5B9FlkOjwENIU
	2QK/hnc7aX32rfdg1ChTJulPhHcaJv7zJNnESaO2RfbSzHJDjXE4RJc9jAg982yV
	v29JDO38rJszpd8jGgnQ/B59tiDX/GlgIjaTmHKxADtZfn79iQDgAjTzblRd08Fw
	qur4nV+MjTyXobbOVGobyHbqrQrgKeGvf4jkZtk1FAySDY5kfD9MMcYmv2YIi7FQ
	+MykCWMdCXJYv/kHuPjkeOSxjKvXrSTZrRQanIuC8snZxt64P8gQantkLVN9JpMZ
	hZKsCKaJWuyT++ZZEY4R478jPJPnD7hBpfpSXptQPgWrNKJmxq5MzB/x/lOoXK0Q
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49js0saquw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Oct 2025 17:54:57 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 596G6lRC000900;
	Mon, 6 Oct 2025 17:54:56 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49ke9xyfqs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Oct 2025 17:54:56 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 596Hst4r32309950
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Oct 2025 17:54:55 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2035058055;
	Mon,  6 Oct 2025 17:54:55 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 00E165803F;
	Mon,  6 Oct 2025 17:54:54 +0000 (GMT)
Received: from [9.61.253.189] (unknown [9.61.253.189])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Oct 2025 17:54:53 +0000 (GMT)
Message-ID: <c0818c13-8075-4db0-b76f-3c9b10516e7a@linux.ibm.com>
Date: Mon, 6 Oct 2025 10:54:51 -0700
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
Content-Language: en-US
From: Farhan Ali <alifm@linux.ibm.com>
In-Reply-To: <aOE1JMryY_Oa663e@wunner.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=EqnfbCcA c=1 sm=1 tr=0 ts=68e40271 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=NEAV23lmAAAA:8 a=P-IC7800AAAA:8
 a=zJXkMSJU7NT2EHsJNlkA:9 a=QEXdDO2ut3YA:10 a=d3PnA9EDa4IxuAV0gXij:22
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: G_iHf6DPdxWFX7bOfHcVmCoXVaDJECte
X-Proofpoint-ORIG-GUID: G_iHf6DPdxWFX7bOfHcVmCoXVaDJECte
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDAzMDIwMSBTYWx0ZWRfXwhIK5IHCE55F
 CCzwbBr+Ky5DIdqWODmAyMbg1O6jxJlDRAPMfsLzbkukHi4uOGPLu5i/1QW0PuaLbW8flxJwQbv
 J/S19+ocrNrCFEumQwptApG89m2N0hFuE9ZZjFe6azOUERZRxOcwdWK0L2pLmajy7sC/M7h+agN
 bEVslKNRiVvEU4O92mSRF+8DIoFnfY0tYhqdEHN21yGib2o6tYJGY2r0EofERM/RdcK+i9isT6s
 84KAxUY2uUkbUsSV73JcK53x6IJ4dgESlEnYswoeklfcckBBMmdi/V0NG1vNSL7tVDfJUAid+6s
 2+m0tVZbb5D2cqFzPffkHHRJSUNhEuMMAPP+Fv3vII8PXi5jJiYUMPULKeb4yYxfzGuNWjniAgu
 rusalSO9MufWyO+WqB/wuL0/OtVIrQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-06_05,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 impostorscore=0 adultscore=0 phishscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2510030201


On 10/4/2025 7:54 AM, Lukas Wunner wrote:
> On Wed, Oct 01, 2025 at 10:12:03AM -0700, Farhan Ali wrote:
>> AFAIU if the state_saved flag was set to true then any state that we have
>> saved should be valid and should be okay to be restored from. We just want
>> to avoid saving any invalid data.
> The state_saved flag is used by the PCI core to detect whether a driver
> has called pci_save_state() in one of its suspend callbacks.  If it did,
> the PCI core assumes that the driver has taken on the responsibility to
> put the device into a low power state.  The PCI core will thus not put
> the device into a low power state itself and it won't (again) call
> pci_save_state().
>
> Hence state_saved is cleared before the driver suspend callbacks are
> invoked and it is checked afterwards.
>
> Clearing the state_saved flag in pci_restore_state() merely serves the
> purpose of ensuring that the flag is cleared ahead of the next suspend
> and resume cycle.
>
> It is a fallacy to think that state_saved indicates validity of the
> saved state.

Hi Lukas,

Thanks for the detailed explanation, this was very helpful for me.

> Unfortunately pci_restore_state() was amended by c82f63e411f1 to
> bail out if state_saved is false.  This has arguably caused more
> problems than it solved, so I have prepared this development branch
> which essentially reverts the commit and undoes most of the awful
> workarounds that it necessitated:
>
> https://github.com/l1k/linux/commits/aer_reset_v1
>
> I intend to submit this after the merge window has closed.
>
> The motivation of c82f63e411f1 was to prevent restoring state if
> pci_save_state() hasn't been called before.  I am solving that by
> calling pci_save_state() on device addition, hence error
> recoverability is ensured at all times.
>
> I believe this also makes patch [01/10] in your series unnecessary.

I tested your patches + patches 2-10 of this series. It unfortunately 
didn't completely help with the s390x use case. We still need the check 
to in pci_save_state() from this patch to make sure we are not saving 
error values, which can be written back to the device in 
pci_restore_state().

As part of the error recovery userspace can use the VFIO_DEVICE_RESET to 
reset the device (pci_try_reset_function()). The function call for this is:

pci_dev_save_and_disable 
<https://elixir.bootlin.com/linux/v6.17.1/C/ident/pci_dev_save_and_disable>();

__pci_reset_function_locked 
<https://elixir.bootlin.com/linux/v6.17.1/C/ident/__pci_reset_function_locked>();

pci_dev_restore 
<https://elixir.bootlin.com/linux/v6.17.1/C/ident/pci_dev_restore>();

So we can end up overwriting the initial saved state (added by you in 
pci_bus_add_device()). Do we need to update the 
pci_dev_save_and_disable() not to save the state?

Thanks

Farhan


>
> A lot of drivers call pci_save_state() in their probe hook and
> that continues to be correct if they modified Config Space
> vis-a-vis what was saved on device addition.
>
> Thanks,
>
> Lukas

