Return-Path: <kvm+bounces-3113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0F28800BD0
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 14:27:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B602281BB2
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 13:27:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A36E23AC20;
	Fri,  1 Dec 2023 13:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="b3IvISyq"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE829A;
	Fri,  1 Dec 2023 05:26:58 -0800 (PST)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B1DCLa6031369;
	Fri, 1 Dec 2023 13:26:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=A/ZDY3iMXTmlBTkd0T3nTIBxZ02YQ1nU+CkMmTJwzDQ=;
 b=b3IvISyq/i4tQwQwdMCAZ6vAFo4l5iVkevRCc7hYFohDi5REiLQYN/zx7EtIUqkzn8tj
 P9R9t+hO+880JaA6cAAY+m7fUWVWEb/RZEBSh0CG/vER5l46TUf8HmyT4EOFCyYpXJV1
 dqRz0ZgiIjnnDOPG/Vov2IDqakwqb8s/VL3h6EjRbx5zw8e0XuTDPKDXGwtCp8HMVgRP
 O9xgzP/GY7+D0EROdXE4P33UEHfBHHbiqzc1lv5qWf6ezRhMWSPWGSnxXHf28Ga9+H84
 SXIuMvQqARN9j4DYKCqOLffXKDgwtdHvQTtTcPlG3VO858pyT9+oGj6dw/8nRKzAhNJJ LA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uqg5pgas2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 13:26:42 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3B1DNCjG004385;
	Fri, 1 Dec 2023 13:26:41 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uqg5pgard-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 13:26:41 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B1AXo7a006360;
	Fri, 1 Dec 2023 13:26:40 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3ukwfkmu5x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 13:26:40 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B1DQXfL43450710
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 1 Dec 2023 13:26:33 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5D93E20043;
	Fri,  1 Dec 2023 13:26:33 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8C20E20040;
	Fri,  1 Dec 2023 13:26:29 +0000 (GMT)
Received: from vaibhav?linux.ibm.com (unknown [9.171.33.138])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri,  1 Dec 2023 13:26:29 +0000 (GMT)
Received: by vaibhav@linux.ibm.com (sSMTP sendmail emulation); Fri, 01 Dec 2023 18:56:28 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jordan Niethe <jniethe5@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>, mikey@neuling.org,
        paulus@ozlabs.org, sbhat@linux.ibm.com, gautam@linux.ibm.com,
        kconsul@linux.vnet.ibm.com, amachhiw@linux.vnet.ibm.com,
        David.Laight@ACULAB.COM
Subject: [PATCH 01/12] KVM: PPC: Book3S HV nestedv2: Invalidate RPT before deleting a guest
Date: Fri,  1 Dec 2023 18:56:06 +0530
Message-ID: <20231201132618.555031-2-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231201132618.555031-1-vaibhav@linux.ibm.com>
References: <20231201132618.555031-1-vaibhav@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1FsD7gW8GMcu76CTNudWKZfhyK5ZJnxd
X-Proofpoint-ORIG-GUID: 1yVRbjODkfjdMlILvYtysiI1THkeTetq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-01_11,2023-11-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxlogscore=802 spamscore=0
 malwarescore=0 impostorscore=0 mlxscore=0 bulkscore=0 clxscore=1011
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2312010092

From: Jordan Niethe <jniethe5@gmail.com>

An L0 must invalidate the L2's RPT during H_GUEST_DELETE if this has not
already been done. This is a slow operation that means H_GUEST_DELETE
must return H_BUSY multiple times before completing. Invalidating the
tables before deleting the guest so there is less work for the L0 to do.

Signed-off-by: Jordan Niethe <jniethe5@gmail.com>
---
 arch/powerpc/include/asm/kvm_book3s.h | 1 +
 arch/powerpc/kvm/book3s_hv.c          | 6 ++++--
 arch/powerpc/kvm/book3s_hv_nested.c   | 2 +-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include/asm/kvm_book3s.h
index 4f527d09c92b..a37736ed3728 100644
--- a/arch/powerpc/include/asm/kvm_book3s.h
+++ b/arch/powerpc/include/asm/kvm_book3s.h
@@ -302,6 +302,7 @@ void kvmhv_nested_exit(void);
 void kvmhv_vm_nested_init(struct kvm *kvm);
 long kvmhv_set_partition_table(struct kvm_vcpu *vcpu);
 long kvmhv_copy_tofrom_guest_nested(struct kvm_vcpu *vcpu);
+void kvmhv_flush_lpid(u64 lpid);
 void kvmhv_set_ptbl_entry(u64 lpid, u64 dw0, u64 dw1);
 void kvmhv_release_all_nested(struct kvm *kvm);
 long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu);
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 1ed6ec140701..5543e8490cd9 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -5691,10 +5691,12 @@ static void kvmppc_core_destroy_vm_hv(struct kvm *kvm)
 			kvmhv_set_ptbl_entry(kvm->arch.lpid, 0, 0);
 	}
 
-	if (kvmhv_is_nestedv2())
+	if (kvmhv_is_nestedv2()) {
+		kvmhv_flush_lpid(kvm->arch.lpid);
 		plpar_guest_delete(0, kvm->arch.lpid);
-	else
+	} else {
 		kvmppc_free_lpid(kvm->arch.lpid);
+	}
 
 	kvmppc_free_pimap(kvm);
 }
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 3b658b8696bc..5c375ec1a3c6 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -503,7 +503,7 @@ void kvmhv_nested_exit(void)
 	}
 }
 
-static void kvmhv_flush_lpid(u64 lpid)
+void kvmhv_flush_lpid(u64 lpid)
 {
 	long rc;
 
-- 
2.42.0


