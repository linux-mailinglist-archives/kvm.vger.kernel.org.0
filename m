Return-Path: <kvm+bounces-53579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EC282B143D0
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 23:25:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D484189934A
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 21:25:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7178275878;
	Mon, 28 Jul 2025 21:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="AiJGs3Fv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786F521C18D;
	Mon, 28 Jul 2025 21:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753737915; cv=none; b=ZBPw0Pkovl7BSfY/P4zsRyHfCiIKov6HyXwCEjwfg2b6t0+UbtK6k/gRcm2JRiEKfoY/SKAggOjygwc3kH5qL8a8+S5WJCcTJniGpGNjV1uwsi9ypUe+AMuiIscl+2GkzmpBVRDaAgYcBmt7Om0lkpAhxriIl2SRj0dAH35PNMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753737915; c=relaxed/simple;
	bh=hFGF4ak4iL9Eg7qXDoI/Knr80giZOYy2BcIVSQFdahs=;
	h=Message-ID:Date:MIME-Version:Subject:References:To:Cc:From:
	 In-Reply-To:Content-Type; b=k9r3QpkFmhWvXtqULW0inV4HNWKMbm1mbDJ6wTBlxBhsUmLOpZowqtfxQEFDYn3Wn+rLnfL5+nHkgeYhpTcoVV6RroN2y+5IENTuLmoKdoXoz5SiLlDn16zTcGnLjhQo4DpChO/jczMyNQmkxHTwlb7pHM+eRVfFua1jFaH0wGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=AiJGs3Fv; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56SDBOgI027003;
	Mon, 28 Jul 2025 21:25:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=RsIpm1
	ZePftr61CV00pezlWbIWceZ1DWlXmXkQqYnbI=; b=AiJGs3Fvcesi9WQsru5oEp
	mlv3Xk53vRkPhtV8WAHA2L5FvwRemw0lHQCeBV4ifuSKHJoTwq9w0pzaZdVNDeML
	ZVbVLMbYDmILSsq21Ig5YCc+uNbu5lhXEgDpuNvZ6SX52mtJhHEXjdMO3pfe8nsf
	mBxFbNZ9Eur0kEckWEbPn7710G11jATj0Clcbb1ezkopZsxM2yt8Im1VLFZ5wOXm
	dIvuuC/OaVPVhp2/hJNIseI140hbV69NJVWrhnOOg7s8Q0Od153k94+H6SKiNuCt
	hI29WYghUIa/4zFkJeHHiC740MFD8ODYqC/L4WO288G1p+JyQafZubryoM8Rewlw
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 484qemkayj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Jul 2025 21:25:05 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 56SJAibc018301;
	Mon, 28 Jul 2025 21:25:04 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 485abnyhhx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Jul 2025 21:25:04 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 56SLP3lI58327434
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Jul 2025 21:25:03 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8E6865805D;
	Mon, 28 Jul 2025 21:25:03 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2B91358059;
	Mon, 28 Jul 2025 21:25:03 +0000 (GMT)
Received: from [9.24.20.98] (unknown [9.24.20.98])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 28 Jul 2025 21:25:03 +0000 (GMT)
Message-ID: <c2bba86f-d9d2-4bab-97e4-d983bffbb485@linux.ibm.com>
Date: Mon, 28 Jul 2025 16:25:02 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: vhost: linux-next: kernel crash at vhost_dev_cleanup/kfree
Content-Language: en-US
References: <1b28a10e-0cff-405e-9106-0c20e70854f9@linux.ibm.com>
To: jasowang@redhat.com
Cc: mst@redhat.com, kvm@vger.kernel.org, virtualization@lists.linux.dev,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jonah.palmer@oracle.com, Eric Farman <farman@linux.ibm.com>
From: JAEHOON KIM <jhkim@linux.ibm.com>
In-Reply-To: <1b28a10e-0cff-405e-9106-0c20e70854f9@linux.ibm.com>
X-Forwarded-Message-Id: <1b28a10e-0cff-405e-9106-0c20e70854f9@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JNDVpRasbacsR66uLIqWAC1n7XU-CD_o
X-Proofpoint-GUID: JNDVpRasbacsR66uLIqWAC1n7XU-CD_o
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI4MDE1OCBTYWx0ZWRfXwJI2oKzajmWT
 oqxgMxP28FEyAmTx3ojVVGrhRGA2q1xvu6el+2mPwR39gkjXmRa0myhuKm4JzbFGqu5guMyfrSG
 mAUb4tCwCUmKig+6BVrXC3eqzgsTHrV3o6x9ocOUF5GprsdLqxYnDjLQOIffwp/Mt+rUvN3+11f
 IMr+WNPcuQrBuQEVqL+8+LSYmWqiq0kDRgWcL8sgiVcp0cP09ph09B0OkVbRDmYeaMfVfT6BhFf
 vdB2++r+DkjMQeg5Pa7OJv21pyI/S+lBs1EQEgzamDgmELb9emxFOlYyNj2X6xH2kmFJeTMHk98
 v9HEBupywZH7KM2xOV5LVWnXautn2MVv6drfF+1v5u2bjTNAP71S6yTC92pkDJxtGvsk8YD1CPi
 R22E7zwWsf3NnWdxyJBefiSpRoVtjLQ4jDJHBcvH2DE+8YElRjc/D3MJVkm1TQWIMvRQq9E+
X-Authority-Analysis: v=2.4 cv=BJOzrEQG c=1 sm=1 tr=0 ts=6887eab1 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=8vsdKcPWeYT-9k0nS1MA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-28_04,2025-07-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 suspectscore=0 spamscore=0 lowpriorityscore=0
 mlxlogscore=812 priorityscore=1501 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 clxscore=1011 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507280158


Dear Jason Wang,

I would like to kindly report a kernel crash issue on our s390x server 
which seems to be related to the following patch.
--------------------------------------------------------------------------------------------------------------------------
   commit 7918bb2d19c9 ("vhost: basic in order support")
https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/commit/?id=7918bb2d19c9
--------------------------------------------------------------------------------------------------------------------------

This patch landed in linux-next between July 16th and 17th. Since then,  
kernel crash have been observed during stress testing.
The issue can be confirmed using the following command:
-------------------------------------------
   stress-ng --dev 1 -t 10s
-------------------------------------------

Crash log and call stack are as follows.
Additionally, this crash appears similar to the issue discussed in the 
following thread:
https://lore.kernel.org/kvm/bvjomrplpsjklglped5pmwttzmljigasdafjiizt2sfmytc5rr@ljpu455kx52j/

[ 5413.029569] Unable to handle kernel pointer dereference in virtual 
kernel address space
[ 5413.029573] Failing address: 00000328856e8000 TEID: 00000328856e8803
[ 5413.029576] Fault in home space mode while using kernel ASCE.
[ 5413.029580] AS:0000000371fdc007 R3:0000000000000024
[ 5413.029607] Oops: 003b ilc:3 [#1]SMP
   .......
[ 5413.029655] CPU: 23 UID: 0 PID: 2339 Comm: stress-ng-dev Not tainted 
6.16.0-rc6-10099-g60a66ed35d6b #63 NONE
[ 5413.029659] Hardware name: IBM 3906 M05 780 (LPAR)
[ 5413.029662] Krnl PSW : 0704e00180000000 0000032714b9f156 
(kfree+0x66/0x340)
[ 5413.029673]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 
PM:0 RI:0 EA:3
[ 5413.029677] Krnl GPRS: 0000000000000002 0000008c056e8000 
0000262500000000 0000000085bf4610
[ 5413.029681]            0000000085bf4660 0000000085bf4618 
0000032716402270 0000032694e0391a
[ 5413.029683]            0000032716402290 0000032714720000 
00000328856e8000 0000262500000000
[ 5413.029685]            000003ff8312cfa8 0000000000000000 
000023015ba00000 000002a71e8d3ba8
[ 5413.029697] Krnl Code: 0000032714b9f146: e3e060080008 ag %r14,8(%r6)
[ 5413.029697]            0000032714b9f14c: ec1e06b93a59 risbgn 
%r1,%r14,6,185,58
[ 5413.029697]           #0000032714b9f152: b90800a1 agr %r10,%r1
[ 5413.029697]           >0000032714b9f156: e320a0080004 lg      %r2,8(%r10)
[ 5413.029697]            0000032714b9f15c: a7210001 tmll    %r2,1
[ 5413.029697]            0000032714b9f160: a77400e0 brc 7,0000032714b9f320
[ 5413.029697]            0000032714b9f164: c004000000ca brcl 
0,0000032714b9f2f8
[ 5413.029697]            0000032714b9f16a: 95f5a030 cli 48(%r10),245
[ 5413.029738] Call Trace:
[ 5413.029741]  [<0000032714b9f156>] kfree+0x66/0x340
[ 5413.029747]  [<0000032694e0391a>] vhost_dev_free_iovecs+0x9a/0xc0 [vhost]
[ 5413.029757]  [<0000032694e05406>] vhost_dev_cleanup+0xb6/0x210 [vhost]
[ 5413.029763]  [<000003269507000a>] vhost_vsock_dev_release+0x1aa/0x1e0 
[vhost_vsock]
[ 5413.029768]  [<0000032714c16ece>] __fput+0xee/0x2e0
[ 5413.029774]  [<00000327148c0488>] task_work_run+0x88/0xd0
[ 5413.029783]  [<00000327148977aa>] do_exit+0x18a/0x4e0
[ 5413.029786]  [<0000032714897cf0>] do_group_exit+0x40/0xc0
[ 5413.029789]  [<0000032714897dce>] __s390x_sys_exit_group+0x2e/0x30
[ 5413.029792]  [<00000327156519c6>] __do_syscall+0x136/0x340
[ 5413.029797]  [<000003271565d5de>] system_call+0x6e/0x90
[ 5413.029802] Last Breaking-Event-Address:
[ 5413.029803]  [<0000032694e03914>] vhost_dev_free_iovecs+0x94/0xc0 [vhost]
[ 5413.029811] Kernel panic - not syncing: Fatal exception: panic_on_oops


Best regards,
Jaehoon Kim


