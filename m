Return-Path: <kvm+bounces-54584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CE68FB24812
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 13:11:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A82CF562C04
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 11:11:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 008992F657F;
	Wed, 13 Aug 2025 11:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="IeApgoKb"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8E52F1FC1;
	Wed, 13 Aug 2025 11:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755083455; cv=none; b=g2JE2vne14xYfMVwiAjvvXcC6qnZiq5uS2xqjhQehSew3pQxp8NDj3Z/NhxJsY7/aJG+wrrR5H5jWUdUrTMfY74rftWeDsSO2d0qKIEJkFCEnpx78wD7cx4phV/rGRDCq+huk65BtSdp/zBN8KxSWKIiSWxoWoKmJDAVAafu3q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755083455; c=relaxed/simple;
	bh=YRHKkP8lCy4gB09n41MxzMFyLPd0vNH5p89DiPpzNfM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MUKui6rK62dX40FowlyeAhe6stvJjQjjv0aQd30SRiSLc57txysFZJwlJqDHULG7yXfFRAtXeRg3Y7BiEoSotV02623ODWjJarYeh7u+VysN+vUnd/M6be51ATEjXGuAM4OtEskg7cdT0pR2db8UD54tI/j4U/ndsIokQCakRnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=IeApgoKb; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57CNQFV7008415;
	Wed, 13 Aug 2025 11:10:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=34ovAJe2eGivSa+6mmr7skgxfEMH1W4Ddddhu8cRK
	uM=; b=IeApgoKbhrVy7W51Ag4u5LETY9a13394F8Qi6k8oxhjAnkQh6vf6Sz6gz
	BfJzm0cPUu5II8UfNP6Z2F44a2N2iEXwBN4wCa4V3MDssQxIa5sGIutNxWRiK7oy
	UT8l0k/TQoZ6Pl07gL/5tZBQqmgbGYFFgZawmVbc/yp0CtsNbaMrP3sHDSKvCxwe
	RZPQ6cVsS7YhGt5DQzDCwLPLqWbEVihUbRpkUL1nmtzdBzLw52/FBpql4TipbXXB
	OvbvfQfFxati0xqnNjmy1bkwvy/DXBE1o760Xg1BMDnx/bSyOY07OSVPDgcAjoOZ
	Z05sQMqjjeCRwKK+ahxmDcnTX9Shg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48duruc1m0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 11:10:40 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57DAuKAb010622;
	Wed, 13 Aug 2025 11:10:39 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 48egnuq6k5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 11:10:39 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57DBAbwS52822412
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 11:10:37 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CC6ED2004E;
	Wed, 13 Aug 2025 11:10:37 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9FEA92004B;
	Wed, 13 Aug 2025 11:10:37 +0000 (GMT)
Received: from a46lp67.lnxne.boe (unknown [9.152.108.100])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 13 Aug 2025 11:10:37 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com, corbet@lwn.net, ankita@nvidia.com,
        oliver.upton@linux.dev, linux-doc@vger.kernel.org
Subject: [PATCH] Documentation: kvm: Fix ordering
Date: Wed, 13 Aug 2025 11:04:31 +0000
Message-ID: <20250813110937.527033-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dRacDdhivZng6kdEhlO7hxFVzHGJdlBI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEyMDIyNCBTYWx0ZWRfXx0FCaCriwZwi
 nfDz0cpo4Usw6guU34AX3zn8GSGz4JxhKCmbJplYl81W9axSczeqbBKLKtCf7ciHulnbcj+t6g7
 rD4pX0Eva2cL6EG5VS/cNj30GHJfb96J518kTunSBWj8FDnvw7lR+kh8UEV6+Vx+bhYUcPjwKSl
 az5JLb3GlFKcQoEUd6H78rEFMzyBTItcgYycWFSHxcjkqEj2QJWFtqAe2LbV8mlvw7EelnvtII/
 mjo5ve+rLQwf8BignYcV8S2KsG5GVn2msuGmod/sBIWpw92f5GdvX6YAdiEbUZWepPEEgb5jq1v
 oo0WtyXjfjx7dCB5tHcBiSrsmDJGRZrD+iS12TT+AQkxOdhSaEuSuE3PvemlMNMiYylSMqIdx7C
 p4xLkWOM
X-Authority-Analysis: v=2.4 cv=QtNe3Uyd c=1 sm=1 tr=0 ts=689c72b0 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=toVySWWxgNmqVGSqDGYA:9
X-Proofpoint-ORIG-GUID: dRacDdhivZng6kdEhlO7hxFVzHGJdlBI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-12_08,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 phishscore=0 clxscore=1011 malwarescore=0
 spamscore=0 suspectscore=0 impostorscore=0 bulkscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508120224

7.43 has been assigned twice, make
KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED 7.44.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Fixes: f55ce5a6cd33 ("KVM: arm64: Expose new KVM cap for cacheable PFNMAP")
---

Wanted to rebase a patch that introduces a new capaiblity but the
resulting conflict looked suspicious.

---
 Documentation/virt/kvm/api.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 6aa40ee05a4a..d032d9f306c4 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8651,7 +8651,7 @@ given VM.
 When this capability is enabled, KVM resets the VCPU when setting
 MP_STATE_INIT_RECEIVED through IOCTL.  The original MP_STATE is preserved.
 
-7.43 KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED
+7.44 KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED
 -------------------------------------------
 
 :Architectures: arm64
-- 
2.48.1


