Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E91425089A1
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 15:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359325AbiDTNs4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 09:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379053AbiDTNsu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 09:48:50 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D3FA3B542;
        Wed, 20 Apr 2022 06:46:05 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23KDDR5p031529;
        Wed, 20 Apr 2022 13:46:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=GVQWUJg5PcLWQHAvgnUSiQlon8GzP2GbnsGXNnRomyw=;
 b=DyCyp8zGdW51kGuLJKbQQBudDxLQkxvq0g3RD9gW1YIoVJU9HhRIP2nndFAeIsGTnEZ+
 gHrjPxBq7zqxUhyatMG8Rle5zWvb99rjMMc4EgfBHVwPzwxtMbOOMEDgfgtjN51tlFeA
 /ssfdKkvcqPAyaBH1uyN88t+k1mN6WTyLWC75fQmmUKDbSj0dK3dQMOMyMW11cLZnLPY
 IxG2Uc+B9n7TR+lOfIK1eXRCzhLlm5dQ5no7bpjwQkf/NPHiVWanhqgZJWSM3G7dUDDU
 LqB+lbIklXxTrFljHUM+pULwpZNvrBgdHslbpCMl8VntNqicuIKT86zZpMQe3izSPB/Q 9g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fhyqe0bb7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 13:46:04 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23KDGUlH014162;
        Wed, 20 Apr 2022 13:46:04 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fhyqe0ba4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 13:46:04 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23KDhrfO004679;
        Wed, 20 Apr 2022 13:46:02 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3ffvt9cnmq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 13:46:01 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23KDjweR7995716
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Apr 2022 13:45:58 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9BD8DAE04D;
        Wed, 20 Apr 2022 13:45:58 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67A6DAE056;
        Wed, 20 Apr 2022 13:45:58 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 20 Apr 2022 13:45:58 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 3/4] s390x: don't run migration tests under PV
Date:   Wed, 20 Apr 2022 15:45:56 +0200
Message-Id: <20220420134557.1307305-4-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220420134557.1307305-1-nrb@linux.ibm.com>
References: <20220420134557.1307305-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3dDGieTD0FWy6nRVmzSh0RXNWhLKmFi-
X-Proofpoint-ORIG-GUID: OgAXJc25ulIt2TJo4W0Car-JvU-Po2k0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_03,2022-04-20_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 suspectscore=0 malwarescore=0
 adultscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 impostorscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204200081
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PV doesn't support migration, so don't run the migration tests there.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Thomas Huth <thuth@redhat.com>
---
 s390x/run               | 5 +++++
 scripts/s390x/func.bash | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/s390x/run b/s390x/run
index 2bcdabbaa14f..24138f6803be 100755
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
diff --git a/scripts/s390x/func.bash b/scripts/s390x/func.bash
index bf799a567c3b..2a941bbb0794 100644
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
-- 
2.31.1

