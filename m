Return-Path: <kvm+bounces-65000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 41858C975E1
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 13:50:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 0C3B83418A3
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 12:49:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E53FA321441;
	Mon,  1 Dec 2025 12:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lV/h6XUL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982C4311963;
	Mon,  1 Dec 2025 12:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764593122; cv=none; b=iZqBB+YNQhhgVrAsaOfWW8Y0Aowd6BNF/KnzqF7p9oPdaUqZWqrov18kT1/r1rn+TeYmN2eZAI3/yzWnawLpd3OxR0fcNdQ7Ib2cg6FcG5K0Iz4h8VeopfgStUV1thS/P1Rko17Gx51JQKu4YK19M8H3rjP9+w1m+rLCfIfMhWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764593122; c=relaxed/simple;
	bh=GX8wIsfhukMFpDMcMPXM5Y/O2nms2D6e0UNYSvpFKmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJrSnx+CEUjMLvStHB0oep52a1m+M4KL2wj7HzbrhMWCY3kCAenpNO5HkyIbu0oqoeS5hMWA/B5OcvD29wned4lZo2KVnK83cSMVO2WRHUnDj0mLWPRyPIkdrb9KjDiKXnJb6WKKfTBVkzQs8EgfVWPOzgp0HCrco/0XsdisSrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lV/h6XUL; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5B1C6n31022200;
	Mon, 1 Dec 2025 12:45:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=HEqNFjQTA0qF1DbMf
	lv8015gLZwFoaVrxXidbIxhHeo=; b=lV/h6XULBYK+zV7+6osWSPUhPk/3OL4Tw
	PZIdOwzlAGuy8DI7I33T1a53vVFjq9I0O9qkxjS13NWP1JCUWdhmnNDFyIgWtY3D
	PxvOV363Qo7jrH14rE4BvACUt79R2vf9T2Tim4iGnNeWBn2iHA3sGEfGOMLqgp2m
	v4FZOF39QqUXbn0oaKCVxkiDRowl2FC6hl/AvLk1V4GrLsw0kLXUinLUbucxcpTq
	gwVIm+GPlB1KfQgcV6dfJIUbto9eZjQcFri0tGonPxdH2HA9K7LcKBqfIYUnUXAV
	xnVRB3Ji28Sv+6h5YlOgu3ZflrS2oFbcWGF2bJYKEgNzRZ1Pc53Zg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aqrbfy56x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Dec 2025 12:45:17 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5B1Bucmr024098;
	Mon, 1 Dec 2025 12:45:16 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4arb5s6jrs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Dec 2025 12:45:16 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5B1CjCF830015748
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 1 Dec 2025 12:45:12 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7A26220040;
	Mon,  1 Dec 2025 12:45:12 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 06BAD2004B;
	Mon,  1 Dec 2025 12:45:12 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.111.74.48])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  1 Dec 2025 12:45:11 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        Eric Farman <farman@linux.ibm.com>,
        Christoph Schlameuss <schlameuss@linux.ibm.com>
Subject: [GIT PULL 07/10] KVM: s390: vsie: Check alignment of BSCA header
Date: Mon,  1 Dec 2025 13:33:49 +0100
Message-ID: <20251201124334.110483-8-frankja@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: nkRkOyWfQ-Y_E5soqKtDlES0nLBvavmQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI5MDAxNiBTYWx0ZWRfX8xfV6O/cOBsL
 GEocV4UCs2N/Aur+0w0NY1jZOpxL0zLWqbCdwQ1g6jo1WHY/pHEWLiLL1LM8AkqMqdXykkGalFm
 lLgAsPAy+Mr8V17lrUWAxZUTF1qEK1UiC7WAEAxnHPdkupXvCzZoDAR6wk45BXJwkR19HO4PMOP
 CS2rSCPctKw6yIiswfRj3woky+WsGkxmkX4QhE4BZB95bqN7aNVnF3W32MpRr3wpnFI5qY86Rm9
 s6xIWXRBnSODZyzmPcbQFwg/qevJMC7p01ygW5yVikYj3znRevxFcjTRYwLooLo3jHm9cEN3EVK
 7mmu723NiAzKBaNTHaXfknnCCWLKUvMAHK6ys9P0KaCqFrmvKcF9KNWooK6DeLdeeZN5L967Pzr
 YG0Bn/e0Icm4QfQPJa1j93zdMaB9hg==
X-Authority-Analysis: v=2.4 cv=UO7Q3Sfy c=1 sm=1 tr=0 ts=692d8ddd cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=WQVFApdd__GhjK0almYA:9 a=NqO74GWdXPXpGKcKHaDJD/ajO6k=:19
X-Proofpoint-GUID: nkRkOyWfQ-Y_E5soqKtDlES0nLBvavmQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 adultscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 phishscore=0 clxscore=1011 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511290016

From: Eric Farman <farman@linux.ibm.com>

The VSIE code currently checks that the BSCA struct fits within
a page, and returns a validity exception 0x003b if it doesn't.
The BSCA is pinned in memory rather than shadowed (see block
comment at end of kvm_s390_cpu_feat_init()), so enforcing the
CPU entries to be on the same pinned page makes sense.

Except those entries aren't going to be used below the guest,
and according to the definition of that validity exception only
the header of the BSCA (everything but the CPU entries) needs to
be within a page. Adjust the alignment check to account for that.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/vsie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 347268f89f2f..d23ab5120888 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -782,7 +782,7 @@ static int pin_blocks(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 		else if ((gpa & ~0x1fffUL) == kvm_s390_get_prefix(vcpu))
 			rc = set_validity_icpt(scb_s, 0x0011U);
 		else if ((gpa & PAGE_MASK) !=
-			 ((gpa + sizeof(struct bsca_block) - 1) & PAGE_MASK))
+			 ((gpa + offsetof(struct bsca_block, cpu[0]) - 1) & PAGE_MASK))
 			rc = set_validity_icpt(scb_s, 0x003bU);
 		if (!rc) {
 			rc = pin_guest_page(vcpu->kvm, gpa, &hpa);
-- 
2.52.0


