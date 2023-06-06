Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F74C724736
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 17:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237003AbjFFPFd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 11:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238654AbjFFPFT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 11:05:19 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E8FB0;
        Tue,  6 Jun 2023 08:05:18 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 356Eef64031634;
        Tue, 6 Jun 2023 15:05:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=35F1zHjidGaZTVdjMTGdxntJ2lf/CfgjiF7SPm90Zls=;
 b=ZjxlpYsgNbqH/WMIERsu3+fU93saQpEDfdOiIqvIdKM35gpSH5ecOUp3FrT1bNV4ToEm
 YGmibtnVhhwSUzGI+KS865ssHr6D3xjb3Fqt7rY2JeqNppC+rEo0h4+Ba9dVerB90MwW
 +gl2F6i6MuvLBu8kRago6c/fPVYo31sCCj3qmpcRTqehTPpCfdZg0m+IkSSGoTZyfeOK
 Bp6GvFDnojSw2lOBzkmk9L/osiBs0Doa9RZTk8pbtScwGsagMruelIg8xEDkm1nkUD/Y
 XLTnkDPyYBXkg+wtVjw1JkQ3aikd3ziUcCuyOD91ifrIhZhR+cAGsKDDKrI0kVy2WdJf vA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r26kjs46e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jun 2023 15:05:17 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 356EfLUS002323;
        Tue, 6 Jun 2023 15:05:16 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r26kjs45j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jun 2023 15:05:16 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3565vI6r013806;
        Tue, 6 Jun 2023 15:05:14 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3qyx5q9k29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jun 2023 15:05:14 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 356F5BpL27591382
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Jun 2023 15:05:11 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B0B820040;
        Tue,  6 Jun 2023 15:05:11 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23D2420049;
        Tue,  6 Jun 2023 15:05:11 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  6 Jun 2023 15:05:11 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v1] KVM: s390: selftests: CMMA: don't run if CMMA not supported
Date:   Tue,  6 Jun 2023 17:05:10 +0200
Message-Id: <20230606150510.671301-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: O8-CNBYsiVRUUCy4fdCbu-yTyPiYctpE
X-Proofpoint-GUID: HK-VjKVQ9_kVrVHaFV0mKcCc4qL0MdVc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-06_10,2023-06-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 mlxscore=0 phishscore=0 lowpriorityscore=0 spamscore=0 suspectscore=0
 clxscore=1015 impostorscore=0 adultscore=0 mlxlogscore=943
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306060128
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The test at hand queried whether the kernel supports CMMA, but in
addition machine support is required.

Add a check whether the machine supports CMMA.

This fixes the test under G3 (z/VM, KVM).

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 tools/testing/selftests/kvm/s390x/cmma_test.c | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/tools/testing/selftests/kvm/s390x/cmma_test.c b/tools/testing/selftests/kvm/s390x/cmma_test.c
index 6d0751ea224b..1d73e78e8fa7 100644
--- a/tools/testing/selftests/kvm/s390x/cmma_test.c
+++ b/tools/testing/selftests/kvm/s390x/cmma_test.c
@@ -660,12 +660,32 @@ struct testdef {
 	{ "GET_CMMA_BITS: holes are skipped", test_get_skip_holes },
 };
 
+/**
+ * The kernel may support CMMA, but the machine may not (i.e. if running as
+ * guest-3).
+ *
+ * In this case, the CMMA capabilities are all there, but the CMMA-related
+ * ioctls fail. To find out whether the machine supports CMMA, create a
+ * temporary VM and then query the CMMA feature of the VM.
+ */
+static int machine_has_cmma(void)
+{
+	struct kvm_vm *vm = create_vm();
+	int r;
+
+	r = !__kvm_has_device_attr(vm->fd, KVM_S390_VM_MEM_CTRL, KVM_S390_VM_MEM_ENABLE_CMMA);
+	kvm_vm_free(vm);
+
+	return r;
+}
+
 int main(int argc, char *argv[])
 {
 	int idx;
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_SYNC_REGS));
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_S390_CMMA_MIGRATION));
+	TEST_REQUIRE(machine_has_cmma());
 
 	ksft_print_header();
 
-- 
2.39.1

