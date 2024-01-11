Return-Path: <kvm+bounces-6094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 99D3082B110
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 15:55:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 38C241F2550D
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 14:55:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9458D4E1C3;
	Thu, 11 Jan 2024 14:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JL1Wdqds"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 697B64D114;
	Thu, 11 Jan 2024 14:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40BDqEJb010708;
	Thu, 11 Jan 2024 14:52:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=tkz1cSx9IdEECDph4vc580gKOOeh+JqsFYIn/myX+Ew=;
 b=JL1Wdqds9K+Bu4QS+GOnwOmBNQxZQ0yn2NgkdP4nk5jPVHJwGdWHfvIDLWXpVJl9fI1q
 FdCqAPhU9ry2ejudjyqzBcj87AGc8ZAt90bsJY0fyRpW5yFUhflBgJu0Ti1GSqLUUpAu
 zNPaLowHvqXSHIuE4NX6ayKzEr1vn1IagWGuLkDvSqmaj+yPlT2+wRJffbkIproJGmLL
 wJz3koEwdEgrPVqCQ8kDhna4qdh01LfmMsDOgsYUwlT+vrvbP6I4XgDJquAVfwgWQZYy
 lrA3qkT6gmA68H04Y+A3NroIr2YzfGP/AsT4x41dpcXEqIMt8S2tIq8zvqV28wSjGUQB Aw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vjhkesu0p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jan 2024 14:52:28 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40BDqVwJ012339;
	Thu, 11 Jan 2024 14:52:28 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vjhkestyf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jan 2024 14:52:28 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40BCWDPL004384;
	Thu, 11 Jan 2024 14:52:26 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vfjpm3vwn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jan 2024 14:52:26 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40BEqP3t24248978
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jan 2024 14:52:26 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 92F4A5805D;
	Thu, 11 Jan 2024 14:52:25 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C112658058;
	Thu, 11 Jan 2024 14:52:24 +0000 (GMT)
Received: from [9.61.55.182] (unknown [9.61.55.182])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 11 Jan 2024 14:52:24 +0000 (GMT)
Message-ID: <439339ca-74c1-4678-8602-85dc0bea81fb@linux.ibm.com>
Date: Thu, 11 Jan 2024 09:52:24 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/6] s390/vfio-ap: reset queues removed from guest's AP
 configuration
From: Anthony Krowiak <akrowiak@linux.ibm.com>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: jjherne@linux.ibm.com, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        pbonzini@redhat.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com
References: <20240111143846.8801-1-akrowiak@linux.ibm.com>
Content-Language: en-US
In-Reply-To: <20240111143846.8801-1-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ppB82TJY2HWgh2BENK0S__lkFR-3iVk3
X-Proofpoint-ORIG-GUID: L3MOvTATb4h9XEvUonCcmA-UvmD8ZQds
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-11_07,2024-01-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 suspectscore=0 impostorscore=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401110118

Patches 1/6, 4/6 and 5/6 have Acked-by and the rest have at least one 
Reviewed-by. Are there any objections to pushing these?

On 1/11/24 9:38 AM, Tony Krowiak wrote:
> All queues removed from a guest's AP configuration must be reset so when
> they are subsequently made available again to a guest, they re-appear in a
> reset state. There are some scenarios where this is not the case. For
> example, if a queue device that is passed through to a guest is unbound
> from the vfio_ap device driver, the adapter to which the queue is attached
> will be removed from the guest's AP configuration. Doing so implicitly
> removes all queues associated with that adapter because the AP architecture
> precludes removing a single queue. Those queues also need to be reset.
>
> This patch series ensures that all queues removed from a guest's AP
> configuration are reset for all possible scenarios.
>
> Changelog v1=> v2:
> -----------------
> * Added r-b's to patch 6/6 for Jason and Halil
>
> Tony Krowiak (6):
>    s390/vfio-ap: always filter entire AP matrix
>    s390/vfio-ap: loop over the shadow APCB when filtering guest's AP
>      configuration
>    s390/vfio-ap: let 'on_scan_complete' callback filter matrix and update
>      guest's APCB
>    s390/vfio-ap: reset queues filtered from the guest's AP config
>    s390/vfio-ap: reset queues associated with adapter for queue unbound
>      from driver
>    s390/vfio-ap: do not reset queue removed from host config
>
>   drivers/s390/crypto/vfio_ap_ops.c     | 268 +++++++++++++++++---------
>   drivers/s390/crypto/vfio_ap_private.h |  11 +-
>   2 files changed, 184 insertions(+), 95 deletions(-)
>

