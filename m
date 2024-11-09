Return-Path: <kvm+bounces-31342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FE0B9C2AA9
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2024 07:33:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 895281C20E65
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2024 06:33:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 276BD13E03A;
	Sat,  9 Nov 2024 06:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="coUNFJlu"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B40233D73;
	Sat,  9 Nov 2024 06:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731134016; cv=none; b=J3LpexoDIuhvRNiVcTDJoiNq4YQF2ef6WTLi3gCinaXI6AodyJS9lwwMedQi73emEUKXiNJOg59XFvRtmGUEzYCgndQQ4NZrK6VAeKhnCw52J9R/e8BiX/rIf+U9/03003BdMkq6veaoPM89M8Ol4okMePvAUu+h7ANN/gLxGnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731134016; c=relaxed/simple;
	bh=HI7mdwxtDIfxCGEIr1rt1dZgs92M3H6aON910grG48k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UQqZO/ijp+8b4rVSgtjtgMdsvbnKvRPmsEpQcuAos84eL4fuq8CKHpo8AU0TVNjQy/ND6i4Qi8V6Aw1aAK6BRse0nrv5/W/Lt/C3LPBto5hz6tOiHTKs0WlTCOP65SgP71VxMi4xIuiheda/PMwKZD2BOCakwoWQwUshKjjX0ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=coUNFJlu; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A96A846032381;
	Sat, 9 Nov 2024 06:33:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=5Q69+9oGRE54yyMmqawHKG2eGO9/7UWllYZWui/72
	b8=; b=coUNFJluEn/zfn4XyvSaAv02FPEp6WFxuwO+Cl4GI+xVtPyxuNxKDNqW4
	Drfss9QAzczy5ofJTL6pjx0793u7YDPzhOh08ClZ5VoQY4SjFvCGjr9QDyNJ274a
	+HDJSCTe1GlZVEyR5/q/xiNHmFhRDDk+U6vYbRKOPaT7K3GUllTFfroAoQnHSFxZ
	d0d+YDAuBnFRspGlTcZyCIHXNLmdxKE7NFh3rbdIa0VmN66KriSInR/sw6WMmzku
	1FV5eqb0jPEsQONtMiB4VyiQTEg7YQ7pB37d826bUqEL+XQJRnhW7Ez67WWj1tH5
	wu6vNBcWcHbyR37CYx1xkSu/L1E9g==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42t27q02xf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 09 Nov 2024 06:33:18 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4A96XIEi011215;
	Sat, 9 Nov 2024 06:33:18 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42t27q02xb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 09 Nov 2024 06:33:18 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4A96T1wx008439;
	Sat, 9 Nov 2024 06:33:16 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42nywmschr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 09 Nov 2024 06:33:16 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4A96XCe137880160
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 9 Nov 2024 06:33:12 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BD6B220043;
	Sat,  9 Nov 2024 06:33:12 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0208220040;
	Sat,  9 Nov 2024 06:33:10 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.ibm.com.com (unknown [9.124.214.93])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Sat,  9 Nov 2024 06:33:09 +0000 (GMT)
From: Gautam Menghani <gautam@linux.ibm.com>
To: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
        naveen@kernel.org, maddy@linux.ibm.com, vaibhav@linux.ibm.com
Cc: Gautam Menghani <gautam@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Fix doorbell emulation for nested KVM guests in V1 API
Date: Sat,  9 Nov 2024 12:02:54 +0530
Message-ID: <20241109063301.105289-1-gautam@linux.ibm.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dDouhbvY5gkioZ8KsDxqTgClwp4wat77
X-Proofpoint-GUID: aRn4XiYbOUABJkFjYpnODVt-LjL-jNo5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=527 mlxscore=0
 bulkscore=0 priorityscore=1501 adultscore=0 spamscore=0 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411090049

Doorbell emulation for nested KVM guests in V1 API is broken because of
2 reasons:
1. L0 presenting H_EMUL_ASSIST to L1 instead of H_FAC_UNAVAIL
2. Broken plumbing for passing around doorbell state.

Fix the trap passed to L1 and the plumbing for maintaining doorbell
state.

Gautam Menghani (3):
  Revert "KVM: PPC: Book3S HV Nested: Stop forwarding all HFUs to L1"
  KVM: PPC: Book3S HV: Stop using vc->dpdes for nested KVM guests
  KVM: PPC: Book3S HV: Avoid returning to nested hypervisor on pending
    doorbells

 arch/powerpc/kvm/book3s_hv.c        | 41 ++++++++---------------------
 arch/powerpc/kvm/book3s_hv_nested.c | 14 +++++++---
 2 files changed, 21 insertions(+), 34 deletions(-)

-- 
2.45.2


