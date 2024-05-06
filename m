Return-Path: <kvm+bounces-16734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D020C8BD26C
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 18:19:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 485521F215E2
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 16:19:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AE87156253;
	Mon,  6 May 2024 16:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bPliABgh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F7E155752;
	Mon,  6 May 2024 16:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715012285; cv=none; b=sLnvNxPkmu36iIwt06xP1EqEE6zd7JTDvYAzPd8PkeURYnWXQZgLv5v1R7MlnyfKnCq6puNBKdjLTZo9qnVYQZycgmKHbOcoJiYkvVYBlBXBqGuRUJNZsv7UgiCDwfnG/XogbgoGPqoOnQeogHVRdRjL3JoFJ86jR4NeL7YeOLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715012285; c=relaxed/simple;
	bh=Vo9RTIBKg+3DsOJCoCq6rRhEswa8+ZSSG9eMTPElXIk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AVet21N5CG2zJ/9F0xPq8Lm3PBQrUSDZZkr0C0JwpCtcSFTSGsSa+Rzg6RXzN0fUJEzEyxB4A3M9GCEtKBR9wbMjOJ0NKkrFif8F2EiqqBMlO7UxEXaXr3qW1peNq8huGGcBnc82QaNzrUJ/UzHs78V/DkDdwYGNPlOndMb51YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bPliABgh; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446G2NJ9004438;
	Mon, 6 May 2024 16:17:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=8H3Vm5cW7qrNl6PSAd3JqDJWcoWJ1ohvcjV/sKl+uNM=;
 b=bPliABgh0o5erJmzUBvQBtBIWL64TTedoEyaPdL9PiW9Ioq84CsD8tysQI81ZAKTD+aY
 Rj1OCaEIZipGXdB0fhnkYYPcghoKJyEixiSt8I0VeiDezuzbNqeIdM9yueOQOaBePm8g
 IiDKRm9XwwK1CB+ZL1Ni2rChdVjs0WGcIJ0VgRWFYVCZD1zkKJokcqK8bs3X4X0Pk5lc
 Evv+ksgVyGojCIINc9S4q4/Yfw+AQHlJZBocYZPMx/tr2YwCYGvitxzvdWKLao2g6E/m
 0u2dzD/jeZ12jXDlDisVhMB6xXHj9b7xc1cR6uphINc5j0S3uNNf4j0xOSoriYeAa0RC 1g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xy2c9g2ag-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 16:17:54 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 446GHrta001342;
	Mon, 6 May 2024 16:17:54 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xy2c9g2ab-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 16:17:53 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 446F9IgO030881;
	Mon, 6 May 2024 16:17:53 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xwybts4cj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 16:17:52 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 446GHlP145547968
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 May 2024 16:17:49 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 66D1D20043;
	Mon,  6 May 2024 16:17:47 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8B73A20040;
	Mon,  6 May 2024 16:17:41 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.ibm.com.com (unknown [9.43.105.31])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 May 2024 16:17:41 +0000 (GMT)
From: Gautam Menghani <gautam@linux.ibm.com>
To: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
        naveen.n.rao@linux.ibm.com
Cc: Gautam Menghani <gautam@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] XICS emulation optimizations in KVM for PPC
Date: Mon,  6 May 2024 21:47:28 +0530
Message-ID: <20240506161735.83358-1-gautam@linux.ibm.com>
X-Mailer: git-send-email 2.44.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YYIbvZvGhflj8dm_A6Ru2VeCSHrTZ_sJ
X-Proofpoint-ORIG-GUID: d2amX_Zf-SdVTwTS1St8_FvBH87EB2_L
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
 definitions=2024-05-06_11,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 malwarescore=0 suspectscore=0 clxscore=1015 phishscore=0 mlxlogscore=777
 impostorscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405060114

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


