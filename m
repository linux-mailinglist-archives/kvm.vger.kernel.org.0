Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F39657AEC25
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 14:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234434AbjIZMIu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 08:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbjIZMIs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 08:08:48 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B277E6;
        Tue, 26 Sep 2023 05:08:42 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38QBiPGr028118;
        Tue, 26 Sep 2023 12:08:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=1gJpuwdVqRAqlnTtVV631/kgV+qLy2bqFt2x6eyTQb8=;
 b=DEBWZv1jcCHhPGYbyaEHPBZJA8PEB9j4S6EgtEPaW1PQ7du0OqQbCf4KDJxMgccouSpQ
 xF0KIhiR+2XIZXTIRMyEEeOgep2d2h8Pk+5SfMV1ic+SEDUAAyPE1K2abH3cYeWptF4t
 NvYGXf9jrDaZYfdQvzLZP9KRLpgvU9G9Pvamyc/VPwrGABHtC6ekNOIFwCildkAMxfxB
 ZNUbFUDO4FfSsMIk/s/t2mu4WT43XmiETUeL4kzlzRpxkCJ5QBPesZIpXrJp8UU7nQMQ
 6beQgu97WJ8mPGC1AwCQFZh1kwRbGqgSfS/TP9fHfTPo3HhVBhiNwM55jWyOB2LKWdlx FA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tbwk8tahk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Sep 2023 12:08:33 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38QC6b7Y015419;
        Tue, 26 Sep 2023 12:08:33 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tbwk8tah5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Sep 2023 12:08:32 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 38QBJo4f008143;
        Tue, 26 Sep 2023 12:08:32 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3taaqybgpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Sep 2023 12:08:32 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 38QC8SMc45810398
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Sep 2023 12:08:29 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E180820043;
        Tue, 26 Sep 2023 12:08:28 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7DAE20040;
        Tue, 26 Sep 2023 12:08:28 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 26 Sep 2023 12:08:28 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1] arch-run: migration: properly handle crashing outgoing QEMU
Date:   Tue, 26 Sep 2023 14:08:23 +0200
Message-ID: <20230926120828.1830840-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: S4Kg005CW5jlplTrnNAp5iWhV9dIu93M
X-Proofpoint-ORIG-GUID: SdO8uUsa6Vc_CnwDokNRXewpIrx2lwHG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-26_08,2023-09-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 mlxlogscore=680 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 impostorscore=0 phishscore=0 clxscore=1011 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2309260104
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
Sorry I accidentally sent this only to s390x maintainers and forgot
Paolo and Andrew, hence resending.

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

