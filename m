Return-Path: <kvm+bounces-5446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31ADF821F73
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 17:26:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 443B51C2232F
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 16:26:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45BCE14F97;
	Tue,  2 Jan 2024 16:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="IjGqirk6"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62E914F6D;
	Tue,  2 Jan 2024 16:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 402FWGbn012292;
	Tue, 2 Jan 2024 16:26:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=kZ3b7RK6UJi/xK6jovsXdOxCWHRkHkfZJaS/Z9Zt5Hk=;
 b=IjGqirk6iOPumfvNfdnwlS+0GZlNaN0GDRwdXssJvoj28Q30xEYbMDqNC6JUx1VdgtzS
 c3kIa3z5b70Cfu01pRpxCsKX8Y35/8s/vq81Z2chc5wpVr0ZzY9UxZT8nqU08UAuTFW2
 dzqh+us/X2R4HJz8/xj4zz280K/zUZPcnmjOIT0afxVuqPylxm8i9hT5lZh/SNQDFHLr
 prZbaMlcMGS/a1jHdArxf1dFxwWeZBU49jBxttok2u6zwPs2RX4xXYOMzjbx9YKkc//A
 Xapb+yLiIDQSxQhgztEDjKflLLmLpkHfQL+kfof8AbVSkcmpHUGBcLrTUsqkQTTk1wwQ 3Q== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vcf2j9j7u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Jan 2024 16:26:19 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 402G67GC017581;
	Tue, 2 Jan 2024 16:26:18 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vcf2j9j6c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Jan 2024 16:26:18 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 402GLfRO017850;
	Tue, 2 Jan 2024 16:26:17 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vawwyp1s9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Jan 2024 16:26:17 +0000
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 402GQFpC36569360
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 2 Jan 2024 16:26:15 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5F29858059;
	Tue,  2 Jan 2024 16:26:15 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 387E55804B;
	Tue,  2 Jan 2024 16:26:14 +0000 (GMT)
Received: from [9.61.19.53] (unknown [9.61.19.53])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  2 Jan 2024 16:26:14 +0000 (GMT)
Message-ID: <48d70d1d-0320-4c40-b82c-3754ce6ba79a@linux.ibm.com>
Date: Tue, 2 Jan 2024 11:26:13 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/6] s390/vfio-ap: reset queues removed from guest's AP
 configuration
Content-Language: en-US
From: Anthony Krowiak <akrowiak@linux.ibm.com>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: jjherne@linux.ibm.com, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        pbonzini@redhat.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com
References: <20231212212522.307893-1-akrowiak@linux.ibm.com>
In-Reply-To: <20231212212522.307893-1-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: p27g7wgGzg7wx52F16I9WWKYF_4QmUxM
X-Proofpoint-ORIG-GUID: bpcTsWU2JnigLqaMaBoeM-WZT4bZLh_s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-02_05,2024-01-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 clxscore=1011 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401020125

PING! Happy New Year!

On 12/12/23 4:25 PM, Tony Krowiak wrote:
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
> * Restored Halil's Acked-by and Reviewed-by tags (Halil)
>
> * Restored Halil's code refactor of reset_queues_for_apids function in
>    patch 4
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

