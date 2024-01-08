Return-Path: <kvm+bounces-5849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2468B8275CB
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 17:52:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B62F21F23B30
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 16:52:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A232B54657;
	Mon,  8 Jan 2024 16:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SEc1gS/a"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF4054659;
	Mon,  8 Jan 2024 16:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 408G04EO002580;
	Mon, 8 Jan 2024 16:52:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=6lM1qEBJ4ez92DZuRcV3WtQMWYZTj71I9/AGUweFHuM=;
 b=SEc1gS/aQg8CJsMHb/AtRZbso8s1Iw6wHO30UOCi8A/VhXvvVq+Id7IAxlmTgvje2RIN
 9ruW9Mfpo0G2NBsb5eDfstsox1FdKN15DFcSWuQJ20O4ICjpYQWifyBRNjjLMb/SEe1P
 FW5eZNAt05DSGf9zcqi/x9q8lG8x7bcRPSG5Lw/WCp7z7478OFtLfJMvnrz8DytYfhac
 WCtMbL1VYqGsyAzTlKrDyb9uM8fecYXb3MC5m9qCtubiuHKWniyxzCpQPSdGgBNkVfW9
 yr2hRI7vgXWuNquTv5L2XLorJMk+ELGbphnCb/vjBr4w9NSpzypYn0eTLeQvww6qpQUa Kw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vgjsrcarb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Jan 2024 16:52:39 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 408GnsYb012495;
	Mon, 8 Jan 2024 16:52:38 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vgjsrcaqx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Jan 2024 16:52:38 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 408GVarS000926;
	Mon, 8 Jan 2024 16:52:37 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vfkdk0xtk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Jan 2024 16:52:37 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 408GqaMh65536280
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 8 Jan 2024 16:52:36 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2DCFD58054;
	Mon,  8 Jan 2024 16:52:36 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F35245805A;
	Mon,  8 Jan 2024 16:52:34 +0000 (GMT)
Received: from [9.61.181.127] (unknown [9.61.181.127])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  8 Jan 2024 16:52:34 +0000 (GMT)
Message-ID: <11ac008c-9bea-4b34-bc4b-e0d7e7ed9bef@linux.ibm.com>
Date: Mon, 8 Jan 2024 11:52:34 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/6] s390/vfio-ap: reset queues removed from guest's AP
 configuration
From: Anthony Krowiak <akrowiak@linux.ibm.com>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: jjherne@linux.ibm.com, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        pbonzini@redhat.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com
References: <20231212212522.307893-1-akrowiak@linux.ibm.com>
Content-Language: en-US
In-Reply-To: <20231212212522.307893-1-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: D2899BVSSLB2qjUcFaWZKNwhnb-wl93T
X-Proofpoint-ORIG-GUID: i4pGCOd2Q0Y1-l_jJSZPbEgYmFsB1Tp9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-08_06,2024-01-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 adultscore=0 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401080142

PING!

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

