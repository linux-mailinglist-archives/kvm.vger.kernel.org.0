Return-Path: <kvm+bounces-64999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BB86C975DE
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 13:50:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5B77E34404C
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 12:49:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7D9F32143C;
	Mon,  1 Dec 2025 12:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kN9/Vk63"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5734F313524;
	Mon,  1 Dec 2025 12:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764593122; cv=none; b=fl/X0R/5jzGwROoZilQjsKMy/Iu4jOeD6GGHy2VE5KomAgUeohr/33iFsCwzCwlEzSt8i7HKFEpjg9yc6Kq9NZ6JFYFV7cy7UsWPnutjsDnpk1Bh0lFyXYa2n202LxMWx7QcY4QgWKGkk4S69EJkTvOJci5Xk+4puQ8N487EfTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764593122; c=relaxed/simple;
	bh=UrSdsnRCLK46rz2R1zecoxdfirzf4l6jLL1fnTC2mUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XjR3mdxtDK5nQWAqq/Hff1+ToDB6OmBaUZMG7MmwnlayyAyj8mPahFzF05fDA6LpueQsa1Dm4263EzfFDccaxl0/NMwYY0E+FObxlI6H08h4yWJoRlIwri4f5me5fAGP0eajN2ZDvKF6XdEWaoydWRK4VpPRItRyoqaf4kjUPZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kN9/Vk63; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5B1CV2Er026038;
	Mon, 1 Dec 2025 12:45:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=lbw9/NLbPzRsRylXw
	k/Lpw5sobQkq0LObAGfrAB57OI=; b=kN9/Vk63WSbPnVquPdbNyWlhg+IlmqqZu
	J0vtJ6koSXhhLoSIJVc/IWTv2j4y4++m+RYXOIG4doMThQMQqlmaFOksPGFw/bPF
	pPa4ra2lrRz75kZX1RiQn/jSqsGEmRv4wJBFsMqnIHgWr83HP6QU+a0OTp5iqvTP
	I9AZQPWRw0QSfmi4/vRgjtgLvBG8PjaN6Mq58nxA4UaZ+9Elg3VlAgAJQCUYeDhu
	Ab/A304Ol3lwzuetLC+Hxr6XLYN44nxMAMsvYjaoyADQEaRATrEnObZ27ZzKB052
	VbBB4t4eIAgV9NRIulLGryh0uAQMlbjdfVKxqMScqVqTIMTRnRAtQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aqq8uf21k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Dec 2025 12:45:16 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5B1CKC0M008636;
	Mon, 1 Dec 2025 12:45:15 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4arc5mpcdn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Dec 2025 12:45:15 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5B1CjB6u46268810
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 1 Dec 2025 12:45:11 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6E73920040;
	Mon,  1 Dec 2025 12:45:11 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EDE8E20043;
	Mon,  1 Dec 2025 12:45:10 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.111.74.48])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  1 Dec 2025 12:45:10 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        Ankit Agrawal <ankita@nvidia.com>
Subject: [GIT PULL 05/10] Documentation: kvm: Fix ordering
Date: Mon,  1 Dec 2025 13:33:47 +0100
Message-ID: <20251201124334.110483-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201124334.110483-1-frankja@linux.ibm.com>
References: <20251201124334.110483-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: KCVS2dNN2dpP-u16d41FZeVYJSZ4eviC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI5MDAwOCBTYWx0ZWRfX6Tk1tiUdbZmn
 591Kx6pVWV8IU3ZgwucT28T4a6KBoiTaVezL1VAyPy9hpM28aq+iDHu2xNiW8paPCILPWC8gJzF
 I91+EIJ+SBWMy9JvYkE6HddcY/KoFFiPkG3IA+vNtTEqVY6D92FBTQJ9j95GowHqcvESIuYsQQd
 Fae67ZlI1MwQO2V+BnEbM0BgmJTbvLEOlzRzZfs5UcCqx80/WHxI6ok6EbzTos8PmF10ZzuMJlA
 pDDeLtwWvGNsz2z8KxQABVLM+LsIQo6Qf5UXUUNYb4iRGUZ540D6Os5X/ExQisMtFvLMh2WukX6
 Oj06efiUSkXtvDuNTpkQ24EDApJmfok0RL54+9IeAOR7Ei0+MtrRnaYefifrmzLbLLA8fvRnfOu
 CLPTSSKuhPCCAeeYiQTyb/0FE+EuqQ==
X-Authority-Analysis: v=2.4 cv=Scz6t/Ru c=1 sm=1 tr=0 ts=692d8ddc cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Ikd4Dj_1AAAA:8 a=VnNF1IyMAAAA:8
 a=toVySWWxgNmqVGSqDGYA:9
X-Proofpoint-GUID: KCVS2dNN2dpP-u16d41FZeVYJSZ4eviC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 clxscore=1015 spamscore=0 impostorscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511290008

7.43 has been assigned twice, make
KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED 7.44.

Fixes: f55ce5a6cd33 ("KVM: arm64: Expose new KVM cap for cacheable PFNMAP")
Reviewed-by: Ankit Agrawal <ankita@nvidia.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 Documentation/virt/kvm/api.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 57061fa29e6a..72b2fae99a83 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8692,7 +8692,7 @@ given VM.
 When this capability is enabled, KVM resets the VCPU when setting
 MP_STATE_INIT_RECEIVED through IOCTL.  The original MP_STATE is preserved.
 
-7.43 KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED
+7.44 KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED
 -------------------------------------------
 
 :Architectures: arm64
-- 
2.52.0


