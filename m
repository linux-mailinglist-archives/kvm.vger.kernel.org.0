Return-Path: <kvm+bounces-60606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EFD13BF49C6
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 06:54:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF6E14679ED
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 04:54:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB4A7239E6F;
	Tue, 21 Oct 2025 04:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="i7rQU2Gv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A0D21255A
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 04:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761022464; cv=none; b=KVCCUIyruB2Dg4v7gM8gS6ECXpMUGaU3wK4Hyutl8FEtZU9P9/gIkQbCl3S6X3hBjuFdcWEicgMwMrSO+TZVWrknWsSaHqhnq/O3wS+9/RSqJyqmb0jyv23D5AVHWkuB+sEuv9KDa+0ByHIUgITcMXwlOv1FeSPClmhhbqaHBUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761022464; c=relaxed/simple;
	bh=S21WgRh2CgjMhGyMCh9u01fNU9C1s4usvvgrKet41Vk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UUrLBLlNhlQUeh8O0EaekdHHYJJ/vo9YnWBAsGze76UU3/sTO1zoZERBz/rSZjZx1Kx1Xd9PXKo8uenBc2ayY+QDp/IJw3HOjATv02/7nMkOBNjpyWU+tro3yq1CqBWpEmwJbZgAmoBtGXzvBW03WuPQGLtBnvz+OZaYshJvLVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=i7rQU2Gv; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59L2vl1v007748;
	Tue, 21 Oct 2025 04:54:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=NFKh4h
	t4hFSOdQzwq1AmS2Pc/7IYmgtNIe2JKEo3f1A=; b=i7rQU2GvxaQ1FaYQ/zO+am
	rnLFGbAsU2QquOrVkvlcuONR2Ake5xwBfBbqCzCC4YenhPcAS1VuZNuUV/8YeU9B
	/VGvMCKJ8elUpaZdGkpQ+UWVHeG9KYswDLgRSXhOmCIXcEJG80F7MPxDEW/oBlwE
	ductAtvQ40xb9COEJRGtfjJmcxV7Oz6gRQjB1MkGkw7xgOgaoM0yWF3TYldn4UOv
	4tf6ONYiMFnGs8iH3ag4uUL/0hyvmcj+vWBTv4azDJrFnmzH/0FBcZrbhgDr/XaS
	QuplXX7AnTD/geeKKInkalgSdhomqG6fqzFWT98dWJP8gWwnTuCYBzpJ6mULdn3g
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v326n2x7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Oct 2025 04:54:14 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59L4pbl6018349;
	Tue, 21 Oct 2025 04:54:13 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v326n2x6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Oct 2025 04:54:13 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59L28jeG017081;
	Tue, 21 Oct 2025 04:54:12 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49vnkxs5u2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Oct 2025 04:54:12 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59L4sBSE7799986
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 04:54:11 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A719958067;
	Tue, 21 Oct 2025 04:54:11 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2D68F5805D;
	Tue, 21 Oct 2025 04:54:09 +0000 (GMT)
Received: from [9.109.242.24] (unknown [9.109.242.24])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 21 Oct 2025 04:54:08 +0000 (GMT)
Message-ID: <fdb7e249-b801-4f57-943d-71e620df2fb3@linux.ibm.com>
Date: Tue, 21 Oct 2025 10:24:07 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/18] hw/ppc/spapr: Remove deprecated pseries-3.0 ->
 pseries-4.2 machines
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org,
        =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Nicholas Piggin <npiggin@gmail.com>,
        qemu-ppc@nongnu.org, kvm@vger.kernel.org,
        Chinmay Rath <rathc@linux.ibm.com>
References: <20251020103815.78415-1-philmd@linaro.org>
Content-Language: en-US
From: Harsh Prateek Bora <harshpb@linux.ibm.com>
In-Reply-To: <20251020103815.78415-1-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=EJELElZC c=1 sm=1 tr=0 ts=68f711f6 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=f7IdgyKtn90A:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=GLR4iIx02OIjODZsis0A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=oH34dK2VZjykjzsv8OSz:22 a=cPQSjfK2_nFv0Q5t_7PE:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22
 a=jd6J4Gguk5HxikPWLKER:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfXxB7aRVRdXeK8
 zCu5U3Kd3m8aTvInr6WvcUe3K6HULugPO07gbG8JZFuS5WQOsehXKUXFvzepSmqsUykGMTLdvVx
 GcKpBjnXjhNT0RgcdPl0Mf3HN0FjM8UopDoEJDnMx/EuAWuTfumUMNr/mp8viqz8y31zFs6MSyo
 H/QfZ1Ja9g2P26HZ8U3pTdS3twQUKnlM0k1Ci9Lx53ikkM+yZrHfvqkkGDjZwtIQc8FZevJCU3g
 mRoAvaeHRuwLIpnk2CpwV55VxD5JvBojrD6LEZBYsoobj2QGM46MiyWN7nbhdoB3iuyoQiRbO+a
 JRJc3uUW17dpsPyLaY0oY0PN3ldTsWQ809FsteHx204Ts5Scol/pS6CFPh9PJpXg2n4j/OJe+qG
 +uR3zIHXb3UUJyD2Tb5gDnqow+K8xg==
X-Proofpoint-GUID: D5oKnqXmEzXn5SbvMkWos5pkiqF7rwDb
X-Proofpoint-ORIG-GUID: WDuAOAPfPmu7T1bLe9QYgK9nl7Nvr96M
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_07,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 suspectscore=0 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180022

+Cedric

Hi Phillipe,

It had been done and the patches were reviewed already here (you were in 
CC too):

https://lore.kernel.org/qemu-devel/20251009184057.19973-1-harshpb@linux.ibm.com/

Let us try to avoid duplication of implementation/review efforts.
If the motivation to re-do is just to split, I think let us consider the 
original series to avoid duplication of review efforts. I should 
probably send more frequent PRs to avoid such scenarios in future.

Thanks for your contribution in reviewing other patches though. It's 
highly appreciated.

regards,
Harsh

On 10/20/25 16:07, Philippe Mathieu-Daudé wrote:
> Remove the deprecated pseries-3.0 up to pseries-4.2 machines,
> which are older than 6 years. Remove resulting dead code.
> 
> Philippe Mathieu-Daudé (18):
>    hw/ppc/spapr: Remove deprecated pseries-3.0 machine
>    hw/ppc/spapr: Remove SpaprMachineClass::spapr_irq_xics_legacy field
>    hw/ppc/spapr: Remove SpaprMachineClass::legacy_irq_allocation field
>    hw/ppc/spapr: Remove SpaprMachineClass::nr_xirqs field
>    hw/ppc/spapr: Remove deprecated pseries-3.1 machine
>    hw/ppc/spapr: Remove SpaprMachineClass::broken_host_serial_model field
>    target/ppc/kvm: Remove kvmppc_get_host_serial() as unused
>    target/ppc/kvm: Remove kvmppc_get_host_model() as unused
>    hw/ppc/spapr: Remove SpaprMachineClass::dr_phb_enabled field
>    hw/ppc/spapr: Remove SpaprMachineClass::update_dt_enabled field
>    hw/ppc/spapr: Remove deprecated pseries-4.0 machine
>    hw/ppc/spapr: Remove SpaprMachineClass::pre_4_1_migration field
>    hw/ppc/spapr: Remove SpaprMachineClass::phb_placement callback
>    hw/ppc/spapr: Remove deprecated pseries-4.1 machine
>    hw/ppc/spapr: Remove SpaprMachineClass::smp_threads_vsmt field
>    hw/ppc/spapr: Remove SpaprMachineClass::linux_pci_probe field
>    hw/ppc/spapr: Remove deprecated pseries-4.2 machine
>    hw/ppc/spapr: Remove SpaprMachineClass::rma_limit field
> 
>   include/hw/ppc/spapr.h     |  16 --
>   include/hw/ppc/spapr_irq.h |   1 -
>   target/ppc/kvm_ppc.h       |  12 --
>   hw/ppc/spapr.c             | 298 ++++++++-----------------------------
>   hw/ppc/spapr_caps.c        |   6 -
>   hw/ppc/spapr_events.c      |  20 +--
>   hw/ppc/spapr_hcall.c       |   5 -
>   hw/ppc/spapr_irq.c         |  36 +----
>   hw/ppc/spapr_pci.c         |  32 +---
>   hw/ppc/spapr_vio.c         |   9 --
>   target/ppc/kvm.c           |  11 --
>   11 files changed, 75 insertions(+), 371 deletions(-)
> 

