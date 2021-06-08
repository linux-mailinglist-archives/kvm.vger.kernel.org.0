Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B932E39F578
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 13:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbhFHLrr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 07:47:47 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63322 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232100AbhFHLrq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Jun 2021 07:47:46 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 158BYo1e140595;
        Tue, 8 Jun 2021 07:45:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=sS0JANVLyfIxxMl7EcBYqF4lbrq79PHW9PMhxynRU7g=;
 b=a4d3aIg47RrkZXpHObuJEFAOh/4qBhMMMPdm5/oaqpTFR0GOQl+udn/5GrsMKVaW3S+1
 npai+gS6IiqZ/rDUn/rnkwUfM9DtzKH/5XQcPwxhpHzyWLiIP95rkw1aF+LHYtrXiBwK
 UPh02Wt21HvjGk6ZfAIPlveg8EwgEIuBc7FnTW0pHQfh2bX0i8+aGw9rdKgyROvERwHa
 JN/Ju4NcK2dqDoqwmZg2VjHvbAWm2Snu6BfPUYJ7hcMb1Q7nn1TiO3VQLni+qzxQpUym
 yo0VdA2dGHfPOa1bPOZs9GBdELSgv3F0sOrNgsHof0jM8r+VkgS3TIj3b16Sfe28yBa8 ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3926q3a373-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 07:45:53 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 158BZ6rZ141742;
        Tue, 8 Jun 2021 07:45:52 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3926q3a36g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 07:45:52 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 158Bi5L5014314;
        Tue, 8 Jun 2021 11:45:50 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3900w8hfqd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 11:45:50 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 158BjlfX32309696
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Jun 2021 11:45:47 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 704974C046;
        Tue,  8 Jun 2021 11:45:47 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D2594C044;
        Tue,  8 Jun 2021 11:45:47 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue,  8 Jun 2021 11:45:47 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 18D97E014D; Tue,  8 Jun 2021 13:45:47 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     pbonzini@redhat.com
Cc:     borntraeger@de.ibm.com, bgardon@google.com, dmatlack@google.com,
        drjones@redhat.com, frankja@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, peterx@redhat.com,
        venkateshs@chromium.org
Subject: [PATCH] KVM: selftests: introduce P47V64 for s390x
Date:   Tue,  8 Jun 2021 13:45:46 +0200
Message-Id: <20210608114546.6419-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <4d6513f3-d921-dff0-d883-51c6dbdcbe39@de.ibm.com>
References: <4d6513f3-d921-dff0-d883-51c6dbdcbe39@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5UbgigelJQShbkPpi6Gj-WUgN8AUd3z4
X-Proofpoint-ORIG-GUID: _6orvKeGM5APhuZOs2UBO6z5itzD10Mb
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-08_09:2021-06-04,2021-06-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 spamscore=0
 malwarescore=0 mlxlogscore=956 adultscore=0 phishscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106080077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

s390x can have up to 47bits of physical guest and 64bits of virtual
address  bits. Add a new address mode to avoid errors of testcases
going beyond 47bits.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h | 3 ++-
 tools/testing/selftests/kvm/lib/kvm_util.c     | 5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index fcd8e3855111..6d3f71822976 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -43,6 +43,7 @@ enum vm_guest_mode {
 	VM_MODE_P40V48_4K,
 	VM_MODE_P40V48_64K,
 	VM_MODE_PXXV48_4K,	/* For 48bits VA but ANY bits PA */
+	VM_MODE_P47V64_4K,	/* For 48bits VA but ANY bits PA */
 	NUM_VM_MODES,
 };
 
@@ -60,7 +61,7 @@ enum vm_guest_mode {
 
 #elif defined(__s390x__)
 
-#define VM_MODE_DEFAULT			VM_MODE_P52V48_4K
+#define VM_MODE_DEFAULT			VM_MODE_P47V64_4K
 #define MIN_PAGE_SHIFT			12U
 #define ptes_per_page(page_size)	((page_size) / 16)
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 28e528c19d28..d61ad15b1979 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -175,6 +175,7 @@ const char *vm_guest_mode_string(uint32_t i)
 		[VM_MODE_P40V48_4K]	= "PA-bits:40,  VA-bits:48,  4K pages",
 		[VM_MODE_P40V48_64K]	= "PA-bits:40,  VA-bits:48, 64K pages",
 		[VM_MODE_PXXV48_4K]	= "PA-bits:ANY, VA-bits:48,  4K pages",
+		[VM_MODE_P47V64_4K]	= "PA-bits:47,  VA-bits:64,  4K pages",
 	};
 	_Static_assert(sizeof(strings)/sizeof(char *) == NUM_VM_MODES,
 		       "Missing new mode strings?");
@@ -192,6 +193,7 @@ const struct vm_guest_mode_params vm_guest_mode_params[] = {
 	{ 40, 48,  0x1000, 12 },
 	{ 40, 48, 0x10000, 16 },
 	{  0,  0,  0x1000, 12 },
+	{ 47, 64,  0x1000, 12 },
 };
 _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params) == NUM_VM_MODES,
 	       "Missing new mode params?");
@@ -277,6 +279,9 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
 		TEST_FAIL("VM_MODE_PXXV48_4K not supported on non-x86 platforms");
 #endif
 		break;
+	case VM_MODE_P47V64_4K:
+		vm->pgtable_levels = 4;
+		break;
 	default:
 		TEST_FAIL("Unknown guest mode, mode: 0x%x", mode);
 	}
-- 
2.31.1

