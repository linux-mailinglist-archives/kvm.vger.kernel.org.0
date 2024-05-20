Return-Path: <kvm+bounces-17746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BFCA28C99BB
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 10:21:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 513E91F20DD2
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 08:21:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 411AE1C69C;
	Mon, 20 May 2024 08:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SbRAsbpL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21AC17591;
	Mon, 20 May 2024 08:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716193250; cv=none; b=hFzrI+1HJDn8blSPZp1jfyIlBiX/C6hDU1fyxPYBZd4DUCc7vzqJELrUCDhqofSR7+nPGvVnWV11FF1GvHYzdoRD+FnkjfPTzAcsBW84YpBU+tTk5cae2aNS984xbP1DDvsG5tJZCKKpDAPL1Xi89kbEgfmKgzD0kS8SR45pwGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716193250; c=relaxed/simple;
	bh=4BjkvU5DK4WH4zkVWLjVrDEW+y8o7VvmkiksGIQa2UI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HJcYwgRibVEo43Mw+Nie929wkN/j1jDMXfaIorFVMu1sEL0NjmOZyeqi5K0AwIdm6qQ9chlspsf2CVwITOb4cxjTYb2qkk1x7aQPhCPtyI0Mmx3zd7fJBkUDnWCJUBncauNOZxz90BMrzJl5Jy+Uh+92WTnelxprD2NXhpQ8g+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SbRAsbpL; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44K7jwGA026212;
	Mon, 20 May 2024 08:20:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=6ibjdJZpJPbLn0KY6yYakUfCG8KCGMWhloUWxKT+g6M=;
 b=SbRAsbpL6MbKXttKxFTYkQKKsB/QbB20CcPMdZcQKTiUdSCSQO1jGGaMZvNCqx9C3eML
 yy+VJVB1pRQmcvt8JRKn21pq19RpJ0qZ28Cci3EeL/UAXL0j+j7Uoax1hmW/0nmnnGDA
 3kaYYk4ACMcGviFgmXxE9FOkA5epY7yBbOPs3Ws5so1FtZ3ojwbgadxu9vl2zI2yjNCM
 L5qhHUKdznlZLdzwc3HjqhBjNTNQXAB06qBi20wH3nTFDMKxhwexwQePAb+b7Y/usVGe
 QIdGK3ynouq/FUWZkT0qBkudp7HC/guK8PCFxrLV0FQsO73ndhJUdEaIirCY7pqDhT72 BA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y80ypg8vm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 May 2024 08:20:30 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44K8KT6a014300;
	Mon, 20 May 2024 08:20:29 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y80ypg8vh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 May 2024 08:20:29 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44K50bKS000967;
	Mon, 20 May 2024 08:20:29 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3y771yxvyw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 May 2024 08:20:28 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44K8KNmA36110756
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 May 2024 08:20:25 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 36B2C2004D;
	Mon, 20 May 2024 08:20:23 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6662D20040;
	Mon, 20 May 2024 08:20:21 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.in.ibm.com (unknown [9.204.206.66])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 20 May 2024 08:20:21 +0000 (GMT)
From: Gautam Menghani <gautam@linux.ibm.com>
To: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
        naveen.n.rao@linux.ibm.com, clg@kaod.org
Cc: Gautam Menghani <gautam@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 0/3] XICS emulation optimizations in KVM for PPC
Date: Mon, 20 May 2024 13:50:07 +0530
Message-ID: <20240520082014.140697-1-gautam@linux.ibm.com>
X-Mailer: git-send-email 2.44.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: llrPwTYK0wMMi7VVcjfeLRcnn2qBhCRI
X-Proofpoint-ORIG-GUID: VIym0kwuFRaMK0W0EVnT3K-BNOvclc-h
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-20_04,2024-05-17_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=599 clxscore=1011 bulkscore=0 suspectscore=0 adultscore=0
 malwarescore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2405010000 definitions=main-2405200068

Optimize the XICS emulation code in KVM as per the 'performance todos'
in the comments of book3s_xics.c. 

Performance numbers:
1. Test case: Pgbench run in a KVM on PowerVM guest for 120 secs


2. Time taken by arch_send_call_function_single_ipi() currently measured 
with funclatency [1].

$ ./funclatency.py -u arch_send_call_function_single_ipi

usecs               : count     distribution
0 -> 1          : 7        |                                        |
2 -> 3          : 16       |                                        |
4 -> 7          : 141      |                                        |
8 -> 15         : 4455631  |****************************************|
16 -> 31         : 437981   |***                                     |
32 -> 63         : 5036     |                                        |
64 -> 127        : 92       |                                        |

avg = 12 usecs, total: 60,532,481 usecs, count: 4,898,904


3. Time taken by arch_send_call_function_single_ipi() with changes in
this series.

$ ./funclatency.py -u arch_send_call_function_single_ipi

usecs               : count     distribution
0 -> 1          : 15       |                                        |
2 -> 3          : 7        |                                        |
4 -> 7          : 3798     |                                        |
8 -> 15         : 4569610  |****************************************|
16 -> 31         : 339284   |**                                      |
32 -> 63         : 4542     |                                        |
64 -> 127        : 68       |                                        |
128 -> 255        : 0        |                                        |
256 -> 511        : 1        |                                        |

avg = 11 usecs, total: 57,720,612 usecs, count: 4,917,325

4. This patch series has been also tested on KVM on Power8 CPU.

[1]: https://github.com/iovisor/bcc/blob/master/tools/funclatency.py

Changes v1 -> v1 resend
1. Add Cedric to CC

Gautam Menghani (3):
  arch/powerpc/kvm: Use bitmap to speed up resend of irqs in ICS
  arch/powerpc/kvm: Optimize the server number -> ICP lookup
  arch/powerpc/kvm: Reduce lock contention by moving spinlock from ics
    to irq_state

 arch/powerpc/kvm/book3s_hv_rm_xics.c |  8 ++--
 arch/powerpc/kvm/book3s_xics.c       | 70 ++++++++++++----------------
 arch/powerpc/kvm/book3s_xics.h       | 13 ++----
 3 files changed, 39 insertions(+), 52 deletions(-)

-- 
2.44.0


