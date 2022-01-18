Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBEEC492336
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 10:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236149AbiARJxA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 04:53:00 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38094 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234412AbiARJwe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 04:52:34 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20I6YQ6M003501;
        Tue, 18 Jan 2022 09:52:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=YmnpOvVMnVJCBPQFTQzSGP29GQCLDBp1L/Hu7pd2a94=;
 b=BUNgPNrRnaY9iDoLWhtbED+d8eOThqjngbcKWF8kFNL9n/VGTtuFBKaXTD39lhETQ/5v
 3lbPAVgRPEa/eGnt2//HLytDSlRm39WL2nLrN+vkFbynVjy13zESbLlKs5WQiOSuHNVg
 jgHyeUqfob3jNRDcBOOcCua4Ss8BCPAzzndk3zQ7sRVXpMJEiTUDQjKBO+f7XnDESzLF
 p9Kprbl7IG/6ixnIRSCAZZDH6BdPPnEUmy7sdkhLMbW4Kz8yugaBcV3Z5HBMOe0LPfte
 8oJYd9OfJgob/jSEqu58JivpymsTL4j/7Eplg7JWPNTzbLRbv0MCpHdbOisrP4BjOn8L ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dngcqctfb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 09:52:33 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20I9CHoH032281;
        Tue, 18 Jan 2022 09:52:33 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dngcqctf0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 09:52:32 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20I9lPbL027155;
        Tue, 18 Jan 2022 09:52:31 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3dknw99gjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 09:52:31 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20I9qRuF40894936
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 09:52:28 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D186CA4057;
        Tue, 18 Jan 2022 09:52:27 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90E6EA4051;
        Tue, 18 Jan 2022 09:52:27 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 09:52:27 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v1 10/10] KVM: s390: selftests: Make use of capability in MEM_OP test
Date:   Tue, 18 Jan 2022 10:52:10 +0100
Message-Id: <20220118095210.1651483-11-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220118095210.1651483-1-scgl@linux.ibm.com>
References: <20220118095210.1651483-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Bj9j9ury-LIHZyEIAM_ientqs7Ca4KAg
X-Proofpoint-ORIG-GUID: gjNmfIzPcFvb1I84G2tgZBOKhbTktv6H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_02,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 lowpriorityscore=0
 suspectscore=0 spamscore=0 impostorscore=0 clxscore=1015 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180057
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
index 774d5756f41d..7bdd6727d0ff 100644
--- a/tools/testing/selftests/kvm/s390x/memop.c
+++ b/tools/testing/selftests/kvm/s390x/memop.c
@@ -308,6 +308,7 @@ int main(int argc, char *argv[])
 	struct kvm_vm *vm;
 	struct kvm_run *run;
 	struct kvm_s390_mem_op ksmo;
+	bool has_skey_ext;
 	vm_vaddr_t guest_mem1;
 	vm_vaddr_t guest_mem2;
 	vm_paddr_t guest_mem1_abs;
@@ -322,6 +323,9 @@ int main(int argc, char *argv[])
 	}
 	if (maxsize > sizeof(mem1))
 		maxsize = sizeof(mem1);
+	has_skey_ext = kvm_check_cap(KVM_CAP_S390_MEM_OP_SKEY);
+	if (!has_skey_ext)
+		print_skip("CAP_S390_MEM_OP_SKEY not supported");
 
 	/* Create VM */
 	vm = vm_create_default(VCPU_ID, 0, guest_code);
@@ -342,7 +346,7 @@ int main(int argc, char *argv[])
 	TEST_ASSERT(!memcmp(mem1, mem2, maxsize),
 		    "Memory contents do not match!");
 
-	{
+	if (has_skey_ext) {
 		vm_vaddr_t guest_0_page = vm_vaddr_alloc(vm, PAGE_SIZE, 0);
 		vm_vaddr_t guest_last_page = vm_vaddr_alloc(vm, PAGE_SIZE, last_page_addr);
 		vm_paddr_t guest_mem2_abs = addr_gva2gpa(vm, guest_mem2);
@@ -515,6 +519,14 @@ int main(int argc, char *argv[])
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

