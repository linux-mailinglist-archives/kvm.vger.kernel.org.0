Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3484F4AC704
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 18:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380867AbiBGROl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 12:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358073AbiBGRAN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 12:00:13 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 653A9C0401DB;
        Mon,  7 Feb 2022 09:00:13 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 217GxKJ1011891;
        Mon, 7 Feb 2022 17:00:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=2oJrwHymPzS0Lm9boeb+v0aDXG99f4jNEJXZnQvWgI0=;
 b=FPyciDNvCBPtBVhuIaNOrYDVhU8WPk7TosxvQoXo1BQUqCzEl+nzJoHz4S5WEZUtsF8q
 qtAoXUqaOsp1+zTWMZOOEpcwM8PhgvkZ7tCgxRHaiKX9cBYqAQsARceeorXL/IBK1FXw
 OzGgfW6CbW4DdnEBPEHI55dIctH/RXmgEzUWzhQDwuSkRPOJ4CBxYwTyLwU9yCDqFvDv
 6WORH0K5GzFtVP7PcseVuDtu5sKCy+nWhvDlGtz55Sfhbj6d8xoVDuPpwowBqjN7+rz6
 /Emrj/PPAgDumznsJVEGtWQjBzQnPcFG/KLbX4lnxvU0HaMboanU7p861wvjDuhH3g57 hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e22nk9x5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 17:00:11 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 217GxO97012452;
        Mon, 7 Feb 2022 17:00:10 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e22nk9x4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 17:00:10 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 217GqXlo006990;
        Mon, 7 Feb 2022 17:00:08 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3e2ygpvwg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 17:00:08 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 217H04PG44433692
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Feb 2022 17:00:04 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B505EA405E;
        Mon,  7 Feb 2022 17:00:04 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 485BEA4070;
        Mon,  7 Feb 2022 17:00:04 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Feb 2022 17:00:04 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH v2 10/11] KVM: s390: selftests: Make use of capability in MEM_OP test
Date:   Mon,  7 Feb 2022 17:59:29 +0100
Message-Id: <20220207165930.1608621-11-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220207165930.1608621-1-scgl@linux.ibm.com>
References: <20220207165930.1608621-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nYKkGYNMjvMvLcrKXzRoMdObxyqTPkGm
X-Proofpoint-ORIG-GUID: IJvopDaFhXUuGXgOST4tLcLmboWPZ9dy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_06,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 malwarescore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 mlxlogscore=999 clxscore=1015 phishscore=0 impostorscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202070103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Only test the functionality whose availability is indicated by
KVM_CAP_S390_MEM_OP_SKEY if the capability indicates support.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---
 tools/testing/selftests/kvm/s390x/memop.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/s390x/memop.c b/tools/testing/selftests/kvm/s390x/memop.c
index 5246582cac2e..ac08fd5aa746 100644
--- a/tools/testing/selftests/kvm/s390x/memop.c
+++ b/tools/testing/selftests/kvm/s390x/memop.c
@@ -306,6 +306,7 @@ int main(int argc, char *argv[])
 	struct kvm_vm *vm;
 	struct kvm_run *run;
 	struct kvm_s390_mem_op ksmo;
+	bool has_skey_ext;
 	vm_vaddr_t guest_mem1;
 	vm_vaddr_t guest_mem2;
 	vm_paddr_t guest_mem1_abs;
@@ -320,6 +321,9 @@ int main(int argc, char *argv[])
 	}
 	if (maxsize > sizeof(mem1))
 		maxsize = sizeof(mem1);
+	has_skey_ext = kvm_check_cap(KVM_CAP_S390_MEM_OP_EXTENSION);
+	if (!has_skey_ext)
+		print_skip("Storage key extension not supported");
 
 	/* Create VM */
 	vm = vm_create_default(VCPU_ID, 0, guest_code);
@@ -340,7 +344,7 @@ int main(int argc, char *argv[])
 	TEST_ASSERT(!memcmp(mem1, mem2, maxsize),
 		    "Memory contents do not match!");
 
-	{
+	if (has_skey_ext) {
 		vm_vaddr_t guest_0_page = vm_vaddr_alloc(vm, PAGE_SIZE, 0);
 		vm_vaddr_t guest_last_page = vm_vaddr_alloc(vm, PAGE_SIZE, last_page_addr);
 		vm_paddr_t guest_mem2_abs = addr_gva2gpa(vm, guest_mem2);
@@ -513,6 +517,14 @@ int main(int argc, char *argv[])
 		TEST_ASSERT(rv != 0, "Fetch should result in exception");
 		rv = _vm_read_guest_key(vm, mem2, addr_gva2gpa(vm, 0), 2048, 2);
 		TEST_ASSERT(rv == 4, "Fetch should result in protection exception");
+	} else {
+		struct ucall uc;
+
+		do {
+			vcpu_run(vm, VCPU_ID);
+			get_ucall(vm, VCPU_ID, &uc);
+			ASSERT_EQ(uc.cmd, UCALL_SYNC);
+		} while (uc.args[1] < 100);
 	}
 
 	/* Check error conditions */
-- 
2.32.0

