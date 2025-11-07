Return-Path: <kvm+bounces-62258-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F05F4C3E481
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 03:49:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ADF423AC773
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 02:49:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D7F22DEA80;
	Fri,  7 Nov 2025 02:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PExUlIOw"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8E3F9EC;
	Fri,  7 Nov 2025 02:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762483779; cv=none; b=GAoYGzOUhEEizcgbRAwuZBN2QqPndoCJzHET62BQJcPA7/iQO++r9BSZG5gmdRKwXNK5itmbVEx/7DucfpiuKo9nW2CiCUBDXPrHmgr7IKF6uSODqn0RLsHYD665YjJz+J2PryqSYSMZCabc9Sy+KPcdLzPGVHFTWyPSFiOEeV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762483779; c=relaxed/simple;
	bh=E0vgdpDRF7m+aDgl7VcxSgpA2yL/jzcqJsfLZ7H/bAo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I+Q8Odk9b16z519pPCWKUSTNp40QCTb6BvE/kafG365vYpzdWjZQCh19X+n7qxkPOVcnBFibtO6hldqM75/e+KEUpv9hx68rJN2i6i7HXrpCpUmXIazPJfOgwMS46ff1XDx5EFiwm6XnKtqyssLGf1x9rPMfZU0uDZhns0vSZaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PExUlIOw; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6HO3fl011115;
	Fri, 7 Nov 2025 02:49:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=aHKybDme6QAfLnglNGUNV2jqBw6hs1Xj13Xm/bQK8
	Bk=; b=PExUlIOwxiC3gJsq2QBp+GNPlsd42vHcRRxnlq+rnKQcMrxKYvAyw7P4U
	M4Nwo5h13xUCPBomIYBREneyPhDk2im6GoQP7ePGd6L8ZWeFuAtiwU6ZMV90waKn
	pz+BG64mq/fS9pn/pbSKUubaUJu1tmQL2jwkHbqVEBcVc0/9XW8c69KsfC7Dfmo5
	ogf6ng/P0Jg3kmzoOsog7SLfQh1J25zzTUSqXqJ0BdV+8wmhCu6ujG8wmkLSioOg
	1JO4bpAHEOYgzd2sClBfuSf22/CIz/E9NbrZlkA3T6MaYHNkgwL4LeXvJtuIplxd
	Dja2eSVmwG83i+d8DyWmwr0/VXeiQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a59xcadwt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Nov 2025 02:49:35 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6NBp3D021467;
	Fri, 7 Nov 2025 02:49:34 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4a5xrk0f89-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Nov 2025 02:49:34 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5A72nUhe52167046
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 7 Nov 2025 02:49:30 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 98FB720043;
	Fri,  7 Nov 2025 02:49:30 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8949920040;
	Fri,  7 Nov 2025 02:49:30 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri,  7 Nov 2025 02:49:30 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
	id 59DDBE0308; Fri, 07 Nov 2025 03:49:30 +0100 (CET)
From: Eric Farman <farman@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Christoph Schlameuss <schlameuss@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Eric Farman <farman@linux.ibm.com>
Subject: [PATCH] KVM: s390: vsie: Check alignment of BSCA header
Date: Fri,  7 Nov 2025 03:49:27 +0100
Message-ID: <20251107024927.1414253-1-farman@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAxMDAyMSBTYWx0ZWRfX6slOvv6EL5EX
 HdlseKJWgtPiq7TL01GxC4oejzUljpgCmAXyt2DyhpEdsVs5XgQqJqPL0TImm2AZSaweJf48soR
 w9228+l7DVOqH7fYho3f2e8k9LnvCqo4ikj4dookKH+D5KedteHIxi/xH7v7a7vBL7hjzan4ZPb
 cdE9YnA1y1hmL/KI0+CMC37zJB9b45aCmc14nn59ke8ExNDwQKbcGX8mDw9nV4GVc+lWuHAhdvA
 oMYtuB7EpBaZwnQ5giw2O7HcraBfSa287XTpckm1+kTgYwXW5nFwcwVz6uwowCI9gYzCXmL+1jc
 8xUqW3jr4nZw/vaCDMN8FbBxHU/IG9YGRBwzNUCCYMoW+6/qDoJ9/LIJrN4dsmSNlBoZEH2cxGu
 FtgxebXGm0622dQqcSYJGm9RGmVBig==
X-Proofpoint-GUID: v_E-h1JI6Y3yEUsU_6gThoOZ9QHRCjPA
X-Authority-Analysis: v=2.4 cv=OdCVzxTY c=1 sm=1 tr=0 ts=690d5e3f cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=WQVFApdd__GhjK0almYA:9 a=NqO74GWdXPXpGKcKHaDJD/ajO6k=:19
X-Proofpoint-ORIG-GUID: v_E-h1JI6Y3yEUsU_6gThoOZ9QHRCjPA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_05,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 spamscore=0 suspectscore=0 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1011 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511010021

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
2.48.1


