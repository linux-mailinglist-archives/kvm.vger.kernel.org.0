Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 044677AEB4D
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 13:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjIZLSw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 07:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231651AbjIZLSu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 07:18:50 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DFFFE5;
        Tue, 26 Sep 2023 04:18:44 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38Q9wPU6023383;
        Tue, 26 Sep 2023 11:18:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=CmIecJlElZELQ93lsBbDlnUfAjP5ySPiRkRoMFXXUj8=;
 b=F3sYMqJuqVdW595/wCu+s5tnCsZTeMkJpQiFP1fiYVl0kVMbOfaC5RYnpF/L3rUwTdq/
 n6ctCSjbM35rwQVwyK1VeK23An+yS/rv6ROE4DYA/PR1ZZoltDM/j4pY4SH7Sy0RiS1L
 O47hRZmrgJBGLegycQAz/xxf2/gax6Ae7MeMG3g8s7JIvqJZkMTruqPRgEaWCsG1elKr
 NLTYIRkYfTgyQOk9TGYHT3SD3a9ZP94iY27ZJmjCJtAUPjzcfXD7BarK+FQp52uxQh2L
 qB+rfBqxLqtiIIsyi7k7NpjBxRm5m7RcQTMHw9qXUPCcQdqAah7cWBLJkTkR6Jc/bvuE zQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tbpfrkf04-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Sep 2023 11:18:43 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38QAVEmu021104;
        Tue, 26 Sep 2023 11:18:42 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tbpfrkeyq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Sep 2023 11:18:42 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 38QAEoXD030392;
        Tue, 26 Sep 2023 11:18:42 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tad21jf07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Sep 2023 11:18:42 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 38QBId6s44368510
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Sep 2023 11:18:39 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B62F20043;
        Tue, 26 Sep 2023 11:18:39 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D5A2020040;
        Tue, 26 Sep 2023 11:18:38 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 26 Sep 2023 11:18:38 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1] arch-run: migration: properly handle crashing outgoing QEMU
Date:   Tue, 26 Sep 2023 13:18:27 +0200
Message-ID: <20230926111838.1778968-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: S3IMUuNNjWU-G60z2bFRcCKejU11IJNM
X-Proofpoint-ORIG-GUID: sHojvfnQxHu_g7oRk31Sy7cF7dy7c0fa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-26_07,2023-09-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=495 adultscore=0
 clxscore=1015 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2309180000 definitions=main-2309260095
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When outgoing (live) QEMU crashes or times out during migration, we
currently hang forever.

This is because we don't exit the loop querying migration state when QMP
communication fails.

Add proper error handling to the loop and exit when QMP communication
fails for whatever reason.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 scripts/arch-run.bash | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 518607f4b75d..de9890408e24 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -162,8 +162,14 @@ run_migration ()
 	migstatus=`qmp ${qmp1} '"query-migrate"' | grep return`
 	while ! grep -q '"completed"' <<<"$migstatus" ; do
 		sleep 1
-		migstatus=`qmp ${qmp1} '"query-migrate"' | grep return`
-		if grep -q '"failed"' <<<"$migstatus" ; then
+		if ! migstatus=`qmp ${qmp1} '"query-migrate"'`; then
+			echo "ERROR: Querying migration state failed." >&2
+			echo > ${fifo}
+			qmp ${qmp2} '"quit"'> ${qmpout2} 2>/dev/null
+			return 2
+		fi
+		migstatus=`grep return <<<"$migstatus"`
+		if grep -q '"failed"' <<<"$migstatus"; then
 			echo "ERROR: Migration failed." >&2
 			echo > ${fifo}
 			qmp ${qmp1} '"quit"'> ${qmpout1} 2>/dev/null
-- 
2.41.0

