Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD8197AD998
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 15:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbjIYNxL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 09:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjIYNxK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 09:53:10 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7BBFF;
        Mon, 25 Sep 2023 06:53:04 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38PDeeDL012703;
        Mon, 25 Sep 2023 13:53:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=J9WZJYXPUauxzYA/GO7frAt10HjVFen+/MhZgK96Rl8=;
 b=R4vKjkJ7pQpvCCU0cT9Afe/QzphZcDufs3MHk9f8nchV/3kmbcJHAqVRbwm/A/hXXo3+
 LE/3wGvoadfOBKyfcP3DCrI//xkCmnn3XgAbeKaKxdB2/c/sSuMhzZsBvo1g1uHmO4dQ
 rbaRqf0Tq1fp8XsbTY9hBV0HgsIsG9e9vHBW4RnLizUBWzc1CuMrJVvKEIqpkv6RQoJ/
 pGL5jx69wbkFE3LrwGQeK0RzviOrcrET56U2PX8TLAMoOgi2ovq/6Fnge4Vh/XqQyg1N
 MMu8Dlk2ZJZ2LN6vub1CYUoDlS+Mb2S3eM66nJDFYzuOSBwF+GW7q5zDnOcwROG7VvTQ Xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tbakthkab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Sep 2023 13:53:03 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38PD5vhW009488;
        Mon, 25 Sep 2023 13:53:03 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tbakthka0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Sep 2023 13:53:03 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 38PCaR7X030719;
        Mon, 25 Sep 2023 13:53:02 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tacjjj5a9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Sep 2023 13:53:02 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 38PDqxBu18416242
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Sep 2023 13:52:59 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5544320040;
        Mon, 25 Sep 2023 13:52:59 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34E3F20043;
        Mon, 25 Sep 2023 13:52:59 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 25 Sep 2023 13:52:59 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        nsg@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1] s390x: run PV guests with confidential guest enabled
Date:   Mon, 25 Sep 2023 15:52:45 +0200
Message-ID: <20230925135259.1685540-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jsGE5wAHHrYnRpF35IMzED89tSATN-HB
X-Proofpoint-ORIG-GUID: 3vvH0qZrqnOTN3uuTvXNxwkndQwlHCWI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-25_11,2023-09-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0 spamscore=0
 adultscore=0 clxscore=1011 bulkscore=0 priorityscore=1501 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2309250102
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PV can only handle one page of SCLP read info, hence it can only support
a maximum of 247 CPUs.

To make sure we respect these limitations under PV, add a confidential
guest device to QEMU when launching a PV guest.

This fixes the topology-2 test failing under PV.

Also refactor the run script a bit to reduce code duplication by moving
the check whether we're running a PV guest to a function.

Suggested-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/run | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/s390x/run b/s390x/run
index dcbf3f036415..e58fa4af9f23 100755
--- a/s390x/run
+++ b/s390x/run
@@ -14,19 +14,34 @@ set_qemu_accelerator || exit $?
 qemu=$(search_qemu_binary) ||
 	exit $?
 
-if [ "${1: -7}" = ".pv.bin" ] || [ "${TESTNAME: -3}" = "_PV" ] && [ "$ACCEL" = "tcg" ]; then
+is_pv() {
+	if [ "${1: -7}" = ".pv.bin" ] || [ "${TESTNAME: -3}" = "_PV" ]; then
+		return 0
+	fi
+	return 1
+}
+
+if is_pv && [ "$ACCEL" = "tcg" ]; then
 	echo "Protected Virtualization isn't supported under TCG"
 	exit 2
 fi
 
-if [ "${1: -7}" = ".pv.bin" ] || [ "${TESTNAME: -3}" = "_PV" ] && [ "$MIGRATION" = "yes" ]; then
+if is_pv && [ "$MIGRATION" = "yes" ]; then
 	echo "Migration isn't supported under Protected Virtualization"
 	exit 2
 fi
 
 M='-machine s390-ccw-virtio'
 M+=",accel=$ACCEL$ACCEL_PROPS"
+
+if is_pv; then
+	M+=",confidential-guest-support=pv0"
+fi
+
 command="$qemu -nodefaults -nographic $M"
+if is_pv; then
+	command+=" -object s390-pv-guest,id=pv0"
+fi
 command+=" -chardev stdio,id=con0 -device sclpconsole,chardev=con0"
 command+=" -kernel"
 command="$(panic_cmd) $(migration_cmd) $(timeout_cmd) $command"
-- 
2.41.0

