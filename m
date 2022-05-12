Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0208B524921
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 11:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352131AbiELJg1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 05:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352092AbiELJfr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 05:35:47 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C94821260
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 02:35:43 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24C8pT1H030577
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=s5OOIJLPaqiWzPJBzXiF04VKqQzACmsxIroRAPG62Po=;
 b=LTyq6Qf5lTMNq6hsd1ann7ZRmv8Xeuc1CDiej7p6xpulO+iRdpt0T0aCFG9EnwgMGHHM
 M7xVwibyKXXzpX+KAu2NUp0fyV8SAnAu+bPXlME8bKsZFFYnlFrs8rP7bQS5WVmpi+pp
 l38os9SOBFjnRNZyQ271Hd/VKtlsriJfhqQIcBbVchE1z4yAViJZtfZq9DPMSss46FJV
 CbGCkLMXQ9irRt1RFN3ziy+6+oPgfDaNDWXEnQErw6qwi7qhdv++O7oUlZOZEIJc2SmY
 6Xm9o1QkiAMafBgLt2+ZzGgBFUfCsv1yuM56lw43OuWc8KkiW62cT9yhtQ3fIAZ8fLM/ GQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0y3kh0d8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:42 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24C8re9M037384
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:42 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0y3kh0ck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:41 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24C9WeD2001628;
        Thu, 12 May 2022 09:35:39 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3fwgd8w8xd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:39 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24C9LvT453936532
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 09:21:57 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C69711C05B;
        Thu, 12 May 2022 09:35:35 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 452DE11C04A;
        Thu, 12 May 2022 09:35:35 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.10.145])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 May 2022 09:35:35 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 18/28] s390x: don't run migration tests under PV
Date:   Thu, 12 May 2022 11:35:13 +0200
Message-Id: <20220512093523.36132-19-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220512093523.36132-1-imbrenda@linux.ibm.com>
References: <20220512093523.36132-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TAQQwnQTjBdZtfAD15zNjaYnqzvtUbFm
X-Proofpoint-GUID: LrJXhI023hWOLUFKQFqJoXBmrrFDwzri
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_02,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 mlxlogscore=999 lowpriorityscore=0 spamscore=0 adultscore=0 suspectscore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205120044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

PV doesn't support migration, so don't run the migration tests there.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 scripts/s390x/func.bash | 2 +-
 s390x/run               | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/scripts/s390x/func.bash b/scripts/s390x/func.bash
index bf799a56..2a941bbb 100644
--- a/scripts/s390x/func.bash
+++ b/scripts/s390x/func.bash
@@ -21,7 +21,7 @@ function arch_cmd_s390x()
 	"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
 
 	# run PV test case
-	if [ "$ACCEL" = 'tcg' ]; then
+	if [ "$ACCEL" = 'tcg' ] || find_word "migration" "$groups"; then
 		return
 	fi
 	kernel=${kernel%.elf}.pv.bin
diff --git a/s390x/run b/s390x/run
index 2bcdabba..24138f68 100755
--- a/s390x/run
+++ b/s390x/run
@@ -20,6 +20,11 @@ if [ "${1: -7}" = ".pv.bin" ] || [ "${TESTNAME: -3}" = "_PV" ] && [ "$ACCEL" = "
 	exit 2
 fi
 
+if [ "${1: -7}" = ".pv.bin" ] || [ "${TESTNAME: -3}" = "_PV" ] && [ "$MIGRATION" = "yes" ]; then
+	echo "Migration isn't supported under Protected Virtualization"
+	exit 2
+fi
+
 M='-machine s390-ccw-virtio'
 M+=",accel=$ACCEL"
 command="$qemu -nodefaults -nographic $M"
-- 
2.36.1

