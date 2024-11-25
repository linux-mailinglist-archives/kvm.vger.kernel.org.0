Return-Path: <kvm+bounces-32422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 70B3C9D84D6
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 12:51:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E84F284D80
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 11:51:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE08B1AB500;
	Mon, 25 Nov 2024 11:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="IjHogASQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE0B156997;
	Mon, 25 Nov 2024 11:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732535450; cv=none; b=qjKs7OmO+YyqJe3gKhae4zARpNL52LcWh5XM/tWaMUS+TxQf8sL92/kwjWTYg8/Zl6lWwbbRzJmJpzKToO28L2rkjtcE62A9MDoh6Lv1yvW7WfSzg+evIw1B0sZ/jlvx/K/35oJ2LCsw3EC5j3fYjI/kRPKPplfpOf+kDb8/BjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732535450; c=relaxed/simple;
	bh=JanpGXtIRwmiMhVGEOOqgi2i0g/gmn82m/pr9X94R/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A74D4Qiw2UaCzo8HGZ/BObZNbeV7UgGLesbSQhczJx1chuYBBK+IRA47059CeY1JMuEGuAiP0iSiGdGNVJEfTUDdU1FQppT354TslDoWJEFFKNtuMiEnLAOOfNObH6khGd/THWrKLkqY8tp63S4X3c9BlY7kGJNmCdb/eDt7GPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=IjHogASQ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AP6usLZ027288;
	Mon, 25 Nov 2024 11:50:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=+McmXW+EcqOA/9YPW
	x70i5L7FKrnYwmu/P8j4/fk1yI=; b=IjHogASQltFmpgBUg1mJZm+BJr34i+gwU
	CXWeXIanUFgz2dNtrIDEFMjhfEX4iBcf3lnsmxltkLwV/IJCOg5ErJlz2BiuBQHU
	HbmUMFay3geoLYj4Nl7e46xMyB/SmM2LSg8Ipc+YL4G/KQu3EsfmTO1VQS99eMuw
	HIMXnFrLWNY2q3Zhaz6t0K1h68NhuEhWeh2ohh+ZDo8ZhD3cPXz5mUDV+nrNlG22
	Q0ob5676z7tpNcy85nGWLEmE6muF6Tj3MPSyb8nLXbxNKJOb/sdPA1LKYgCydeN8
	jVtFkFgttLu5Nne46eH88XHUynCu6uur3oKVbqwqOTY5a6uhtYWMg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43387br5bb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Nov 2024 11:50:45 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AP4jQZU002678;
	Mon, 25 Nov 2024 11:50:44 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 433tcmaej6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Nov 2024 11:50:43 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4APBoe5356557990
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Nov 2024 11:50:40 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 33C2E20043;
	Mon, 25 Nov 2024 11:50:40 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 122A62004E;
	Mon, 25 Nov 2024 11:50:40 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 25 Nov 2024 11:50:40 +0000 (GMT)
From: Heiko Carstens <hca@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] KVM: s390: Increase size of union sca_utility to four bytes
Date: Mon, 25 Nov 2024 12:50:39 +0100
Message-ID: <20241125115039.1809353-4-hca@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241125115039.1809353-1-hca@linux.ibm.com>
References: <20241125115039.1809353-1-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0DAZDXYEJ2keVLj6zESkLN4Vh1d7jzfv
X-Proofpoint-ORIG-GUID: 0DAZDXYEJ2keVLj6zESkLN4Vh1d7jzfv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 impostorscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0
 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411250098

kvm_s390_update_topology_change_report() modifies a single bit within
sca_utility using cmpxchg(). Given that the size of the sca_utility union
is two bytes this generates very inefficient code. Change the size to four
bytes, so better code can be generated.

Even though the size of sca_utility doesn't reflect architecture anymore
this seems to be the easiest and most pragmatic approach to avoid
inefficient code.

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 1cd8eaebd3c0..1cb1de232b9e 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -95,10 +95,10 @@ union ipte_control {
 };
 
 union sca_utility {
-	__u16 val;
+	__u32 val;
 	struct {
-		__u16 mtcr : 1;
-		__u16 reserved : 15;
+		__u32 mtcr : 1;
+		__u32	   : 31;
 	};
 };
 
@@ -107,7 +107,7 @@ struct bsca_block {
 	__u64	reserved[5];
 	__u64	mcn;
 	union sca_utility utility;
-	__u8	reserved2[6];
+	__u8	reserved2[4];
 	struct bsca_entry cpu[KVM_S390_BSCA_CPU_SLOTS];
 };
 
@@ -115,7 +115,7 @@ struct esca_block {
 	union ipte_control ipte_control;
 	__u64   reserved1[6];
 	union sca_utility utility;
-	__u8	reserved2[6];
+	__u8	reserved2[4];
 	__u64   mcn[4];
 	__u64   reserved3[20];
 	struct esca_entry cpu[KVM_S390_ESCA_CPU_SLOTS];
-- 
2.45.2


