Return-Path: <kvm+bounces-54604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58F9CB25253
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 19:47:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 88BFB5A5D59
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 17:46:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9332128C840;
	Wed, 13 Aug 2025 17:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="oePpsgSn"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEBD41EDA2A;
	Wed, 13 Aug 2025 17:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755107163; cv=none; b=fiSO7GOrEalODNwLZsHlcu1Xqs8qIzrvcz5WXdXdh8AaVfydrYPcSJVjZQ1H2NavVNpQuXom6Fd1uuiWddSCM6YirT7mpDGIm7s8xE5eYcRTbbZeUWeA+ridMZtoCadAbaUJk5IgpzyJccsgzESfM/Yi7Hn9Nmj8hCqIO1icb4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755107163; c=relaxed/simple;
	bh=SAOdBmc1A2yvUpKz1bhQ0GLQ7792IE1seIw31EsLfag=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qjR22xQJKOwFrtpJ3K0uKaa9zW81z9ObCaKUyH2CIBJuw4J3Xr7vVYwVlr50znWg3k0UDE6BSaQoTWlYQuTMOFh+rHxLD6n3LH59lSF5G670Wcm6OwplH1wulcTDFSdDvCVhTHWxB6cnTMU6auTJMujtxfcXL9WMAtAhntI1eWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=oePpsgSn; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57DCsCqc025034;
	Wed, 13 Aug 2025 17:45:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=rQO69Y
	O43reCLGESm1EHLJt5kapUKs1OeyQ/5+Z8UhQ=; b=oePpsgSnDa2u64GimtzBFZ
	S4t3UkGJTzriBnUDcPcvk9Jh3KEmwts1g9BkM53UjD3pmZfEpL1o/EHOi0kaHHWc
	4eD5liO1E2isOdemT1hACVk1tVtC8tziwhjSpaBVX/Kk8zYp6cDTqHnW9cfOaFuL
	3h5gOYEfJMGecE2PauitlGjv56Zw/DW1CQPG++Q4sUTfhjbN7vCrB10dKp3ZLDah
	2BuX6F11GfVuOFScCv6MXNt5nMH5+/s57pqtBKBiVi54VpeOfrS3WE0U48ey9daZ
	j+97XHGCD4VsQgBBW2DQJWkeyrxkbjrWjyzFawH7Y5XAh/V29A3dTQMg0WzU2nag
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48ehaaa5ty-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 17:45:58 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57DFRrLU026485;
	Wed, 13 Aug 2025 17:45:58 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48eh218k9e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 17:45:58 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57DHjueL19661334
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 17:45:57 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C98F458056;
	Wed, 13 Aug 2025 17:45:56 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5DA685803F;
	Wed, 13 Aug 2025 17:45:56 +0000 (GMT)
Received: from [9.61.255.61] (unknown [9.61.255.61])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 13 Aug 2025 17:45:56 +0000 (GMT)
Message-ID: <5ca8d085-c211-4b94-a74a-94e75e10d47e@linux.ibm.com>
Date: Wed, 13 Aug 2025 10:45:55 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/6] Error recovery for vfio-pci devices on s390x
To: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: schnelle@linux.ibm.com, mjrosato@linux.ibm.com, alex.williamson@redhat.com
References: <20250813170821.1115-1-alifm@linux.ibm.com>
Content-Language: en-US
From: Farhan Ali <alifm@linux.ibm.com>
In-Reply-To: <20250813170821.1115-1-alifm@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=KPRaDEFo c=1 sm=1 tr=0 ts=689ccf56 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=9txmHK4o2TbF8a1Ol1YA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: Zh1mqMNiSvId3XtYn4XZtygIdiG5JfAh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEyMDIyNCBTYWx0ZWRfXwK9o+QkXgn3O
 WFzrPfzv6Shb0xzFJKyBuuAy0+Y6Q3fqx7XZCi6G7SOmSt27oFUoK+X1cWNZG0OLEhXhbdgp/ZY
 V4zejFubEOhH3+i+feZEcFquTtB68XogZvMG6hdnvdb8khjNmrTNTFyWqmC3odzS3Xglvw83DNT
 8VERQi+IiAgkLuKd97fyAzPb68qJtlYJ5KMVFXeZb9Xn/HnBZ0/fbF6DPjlZuqHWhhLbSP1vvaQ
 hn1sRKC4aRdZ/xdtFK01TkOtdPPkxicmAUnm5WZWOh94uD2ZTvMEG/gxQhIzoRfPjWMxWeHD3jQ
 MlhTMxGnVdPPQYhHRtLfWQR2Rt1MT15zF+ovZTjNUMa4tEijUkzQ32sMPfy+N8cQcbHKHMwELG+
 TLNSCig9
X-Proofpoint-GUID: Zh1mqMNiSvId3XtYn4XZtygIdiG5JfAh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_01,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 malwarescore=0 spamscore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508120224

Also posted a QEMU series utilizing these kernel patches
https://lore.kernel.org/qemu-devel/20250813174152.1238-1-alifm@linux.ibm.com/

Thanks
Farhan

On 8/13/2025 10:08 AM, Farhan Ali wrote:
> Hi,
>
> This Linux kernel patch series introduces support for error recovery for
> passthrough PCI devices on System Z (s390x).
>
> Background
> ----------
> For PCI devices on s390x an operating system receives platform specific
> error events from firmware rather than through AER.Today for
> passthrough/userspace devices, we don't attempt any error recovery
> and ignore any error events for the devices. The passthrough/userspace devices are
> managed by the vfio-pci driver. The driver does register error handling
> callbacks (error_detected), and on an error trigger an eventfd to userspace.
> But we need a mechanism to notify userspace (QEMU/guest/userspace drivers) about
> the error event.
>
> Proposal
> --------
> We can expose this error information (currently only the PCI Error Code) via a
> device specific memory region for s390 vfio pci devices. Userspace can then read
> the memory region to obtain the error information and take appropriate actions
> such as driving a device reset. The memory region provides some flexibility in
> providing more information in the future if required.
>
> I would appreciate some feedback on this approach.
>
> Thanks
> Farhan
>
> Farhan Ali (6):
>    s390/pci: Restore airq unconditionally for the zPCI device
>    s390/pci: Update the logic for detecting passthrough device
>    s390/pci: Store PCI error information for passthrough devices
>    vfio-pci/zdev: Setup a zpci memory region for error information
>    vfio-pci/zdev: Perform platform specific function reset for zPCI
>    vfio: Allow error notification and recovery for ISM device
>
>   arch/s390/include/asm/pci.h       |  29 +++++++
>   arch/s390/pci/pci.c               |   2 +
>   arch/s390/pci/pci_event.c         | 107 ++++++++++++++-----------
>   arch/s390/pci/pci_irq.c           |   3 +-
>   drivers/vfio/pci/vfio_pci_core.c  |  22 +++++-
>   drivers/vfio/pci/vfio_pci_intrs.c |   2 +-
>   drivers/vfio/pci/vfio_pci_priv.h  |   8 ++
>   drivers/vfio/pci/vfio_pci_zdev.c  | 126 +++++++++++++++++++++++++++++-
>   include/uapi/linux/vfio.h         |   2 +
>   include/uapi/linux/vfio_zdev.h    |   5 ++
>   10 files changed, 253 insertions(+), 53 deletions(-)
>

