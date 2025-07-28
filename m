Return-Path: <kvm+bounces-53577-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C3E8B14398
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 22:53:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 07C4C7B0622
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 20:51:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C67122A4F6;
	Mon, 28 Jul 2025 20:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iILanYIJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9F62236FF;
	Mon, 28 Jul 2025 20:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753735984; cv=none; b=AS3ixEZkBIl/vuQxyyzbF6k7JpHcasos58DapzNUSG/LVFwgr185UYqWAnSzdD+V6JXFCto5OhE7FQFvJmhADhOxQgV6ux7g2XjD0lAOPszQ6sMmdMbvxZ+uONVmHy91SWxw3bjcmavtFuLmY8MgzD+vswYRKd0obpgbQlssdRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753735984; c=relaxed/simple;
	bh=cF4SyXtqXvTUmC4fAGd1dcUwXleYQvxcBS0IZpSVUas=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=nx4EhzL8CeLYVGUmJQTbOeKy+C/A44GC+htJBzpIQAokByRdYcZRJiyoR/11hv93wyNCqh/Hf7sD+pnhVCFLsO708KAATwD5MztSr5DR2Tggr4XHNcqCdq309tekb28hA1SRQh/YW612IXClOmakTvTJedCA9J1XhgdIvqJmnqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=iILanYIJ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56SGRl9K011939;
	Mon, 28 Jul 2025 20:52:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=UGlfmwfsh4Vr/pXuF9ToEw67g2Yt
	m6shnzntkhJVzGU=; b=iILanYIJtFaWs8UbiO8WBSaerHemEJdTyQY0m7sNpB0M
	UN+d9H0sG3kXMr5gb3eYQV5K1UvdLtwvtB9I/ky++0ng9x9qHBcxXquFHdSLlhR2
	4T8qzhNOWFAYpEJUVzY06ldVJU0q/BQEBO64XIO5jCQbsmzeuivX+1XmlK0riVUC
	iODKw2hp6kxuL/t1RBNbAJizgYUFzLnR6Tfvl6nOMOYWuUdtmXyFBUmJ7yXnZqeW
	l2FvNb3WqoZXW5ROGLFym3fy5mfZV25QAxjuvtfXOp1BwT1Oc887KBoyPyw/8G3K
	iwluVV5TZi2r4n8L9p+x7GLs/lTHymfO7JqN/s9v8A==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 484qemk6e8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Jul 2025 20:52:21 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 56SKOD9q028745;
	Mon, 28 Jul 2025 20:52:20 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 485c22f4bc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Jul 2025 20:52:20 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 56SKqCNi29950686
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Jul 2025 20:52:12 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4DE215805C;
	Mon, 28 Jul 2025 20:52:19 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DEF2358058;
	Mon, 28 Jul 2025 20:52:18 +0000 (GMT)
Received: from [9.24.20.98] (unknown [9.24.20.98])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 28 Jul 2025 20:52:18 +0000 (GMT)
Message-ID: <1b28a10e-0cff-405e-9106-0c20e70854f9@linux.ibm.com>
Date: Mon, 28 Jul 2025 15:52:18 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: jasowang@redhat.com
Cc: mst@redhat.com, kvm@vger.kernel.org, virtualization@lists.linux.dev,
        netdev@vger.kernel.org, inux-kernel@vger.kernel.org,
        jonah.palmer@oracle.com, Eric Farman <farman@linux.ibm.com>
From: JAEHOON KIM <jhkim@linux.ibm.com>
Subject: vhost: linux-next: kernel crash at vhost_dev_cleanup/kfree
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TCEV5JEFpBT1uv6QJDiUZzebQTa3i5Qk
X-Proofpoint-GUID: TCEV5JEFpBT1uv6QJDiUZzebQTa3i5Qk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI4MDE1NCBTYWx0ZWRfXw88S2OX53J0B
 bq/elWxbXqvMHGR/vpbAn0OyS2wCojAG1LtcQ3Me5gj1P//BiFHYw/5UjX6ovy7lI0AZ77emTJR
 BflX8efOEcr940uaomkgZUB6j3RBmtFjCMrOsUvD8kVbOH2MJ1S2047wZjFtbimkVrdhVGkEUXF
 mxIQoz4mVuDQg8ojI9RJHvIRvXuq1Ekcoc1ELdzU4LVlHGDOdH57KZxtUHD/ruQHzXSh7j6SaEF
 D2CimkOzaQMwmevKDiGF1M3xHaibD333QJOSWf6BUDKseiI5ICSD57WqR7YC40eQqDJsP1m6T7l
 obDh/ILRLsHd1lqptxWooHr4fFmYyFwJ6vEwPhkkeiTJ4ekalVmGg1eXjNKtemWxSH3zARSoF+x
 GwdD9tkYEI/w/ZmUaqxjPKcOC5TjL4seozi3btom2Y9sYgwgJIscjO4EgL+yUuclxPACbNjj
X-Authority-Analysis: v=2.4 cv=BJOzrEQG c=1 sm=1 tr=0 ts=6887e305 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=8vsdKcPWeYT-9k0nS1MA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-28_03,2025-07-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 suspectscore=0 spamscore=0 lowpriorityscore=0
 mlxlogscore=754 priorityscore=1501 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 clxscore=1011 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507280154


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
[ 5413.029697] Krnl Code: 0000032714b9f146: e3e060080008 ag      %r14,8(%r6)
[ 5413.029697]            0000032714b9f14c: ec1e06b93a59 risbgn  
%r1,%r14,6,185,58
[ 5413.029697]           #0000032714b9f152: b90800a1 agr     %r10,%r1
[ 5413.029697]           >0000032714b9f156: e320a0080004 lg      %r2,8(%r10)
[ 5413.029697]            0000032714b9f15c: a7210001 tmll    %r2,1
[ 5413.029697]            0000032714b9f160: a77400e0 brc     
7,0000032714b9f320
[ 5413.029697]            0000032714b9f164: c004000000ca brcl    
0,0000032714b9f2f8
[ 5413.029697]            0000032714b9f16a: 95f5a030 cli     48(%r10),245
[ 5413.029738] Call Trace:
[ 5413.029741]  [<0000032714b9f156>] kfree+0x66/0x340
[ 5413.029747]  [<0000032694e0391a>] vhost_dev_free_iovecs+0x9a/0xc0 
[vhost]
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


