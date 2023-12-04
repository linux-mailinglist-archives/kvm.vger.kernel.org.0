Return-Path: <kvm+bounces-3413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4215180414E
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 23:06:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F0FE4280F1D
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 22:06:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD6F63A287;
	Mon,  4 Dec 2023 22:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MkbZCp3T"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9061D1B1;
	Mon,  4 Dec 2023 14:06:02 -0800 (PST)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B4M3GBw012810;
	Mon, 4 Dec 2023 22:06:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=b8zszDt2p6JE51wc2mk2G0Ctwu6+vbxgVY4sza9DnWw=;
 b=MkbZCp3TAN5kwdnTxEL7Abxs85UzTgQXYn1mFqbRX+ajhJRXN7UnXbtxNhbgj2VPfJ+j
 4mB74zJ3+ECHXtgJz1dMgphoWAqjjYzXLMDGl1uuUBQk6oR8eHsoSjKLX7f9gZHpJnLW
 /HV8/aEcJz3ECuUFMgHjOoRMFD0WLr5YSEm6GG6cOm2LGcb1q5gfMFXjvcvxbP5MHlkg
 MZ4U4cCMyJKHBvEq4x9TR6KxfhVXRY8ZZGrsuSZJ8mmhJzb3gCcQRKCS81nFTIanycBX
 Kh8Trkf3sj/k1YCMa4gh7Euz5Y6A4YIKZQi8OX3Iji7EEH51ut3cFbFNHXXjnksqOpaT GQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3usq7m839b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Dec 2023 22:06:00 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3B4M3Dpk012633;
	Mon, 4 Dec 2023 22:05:59 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3usq7m838t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Dec 2023 22:05:59 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B4KYKcp030504;
	Mon, 4 Dec 2023 22:05:58 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3urv8ayptr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Dec 2023 22:05:58 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B4M5tAl44761370
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 4 Dec 2023 22:05:55 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 63E5D2004F;
	Mon,  4 Dec 2023 22:05:55 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8D4372004E;
	Mon,  4 Dec 2023 22:05:54 +0000 (GMT)
Received: from li-ce58cfcc-320b-11b2-a85c-85e19b5285e0 (unknown [9.171.42.250])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon,  4 Dec 2023 22:05:54 +0000 (GMT)
Date: Mon, 4 Dec 2023 23:05:29 +0100
From: Halil Pasic <pasic@linux.ibm.com>
To: Tony Krowiak <akrowiak@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, alex.williamson@redhat.com,
        borntraeger@linux.ibm.com, kwankhede@nvidia.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH] s390/vfio-ap: handle response code 01 on queue reset
Message-ID: <20231204230529.07bf7b79.pasic@linux.ibm.com>
In-Reply-To: <7c0d0ad2-b814-47b1-80e9-28ad62af6476@linux.ibm.com>
References: <20231129143529.260264-1-akrowiak@linux.ibm.com>
	<20231204131045.217586a3.pasic@linux.ibm.com>
	<7c0d0ad2-b814-47b1-80e9-28ad62af6476@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: biHgFghmGhXfZq86iu98AAh8z6ahVtRl
X-Proofpoint-GUID: dXhf9GkvCvgY8IQBR-H2Bh_l_oX4VzgF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-04_20,2023-12-04_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=910
 impostorscore=0 mlxscore=0 spamscore=0 clxscore=1015 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2312040173

On Mon, 4 Dec 2023 12:51:49 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> > s/if\/when/at latest before/
> > 
> > I would argue that some of the cleanups need to happen before even 01 is
> > reflected...  
> 
> To what cleanups are you referring?

Event notification and interruption disablement for starters. Otherwise
OS has no way to figure out when is GISA and NIB safe to deallocate.
Those actions are part of the reset process. I.e. some of the reset stuff
can be deferred at most until the queue is made accessible again, some
not so much. 

Regards,
Halil

