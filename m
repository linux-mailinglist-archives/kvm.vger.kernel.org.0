Return-Path: <kvm+bounces-1463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AF457E7CAB
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 14:54:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 34648B211B1
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 13:54:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C4491C29B;
	Fri, 10 Nov 2023 13:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hcgyPCPk"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204B51B296
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 13:54:23 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784F73821F
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 05:54:22 -0800 (PST)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AADelfQ024524;
	Fri, 10 Nov 2023 13:54:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=v2gxnusife7vqdnhBtE03HjM/kpUA4RM1Tp4SjWMCfo=;
 b=hcgyPCPkHinMDj9+GCzERlhjZwK/JLohgrmpuZvcB0aromLZrlWFrZJb4Tqk9korElwZ
 t5mw8BomhjdeiiM52EWa2739J9xXtwMpxrM58dWqw024+sbiacOOXsTPzWkRyaS/bu6v
 X4tdGCYHa4of4KDsmBhDpvvCyOHozIXArRC+Ip+FG073nkTaQdA8XrMszHlk59Vj0ZW1
 uuLGCAaDgRW6ofOnI1fzSExDacYpu4Kmoe3vSzGv64fQTokzoOnylGNBv41dxm7xaWlp
 ncWyU0CiykmgYqxRC6k9ONOER9GkOeADQRGTvY92jPbS1JVFbYG0q2Wcx0Pk7sOJ86Dl KQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9nkx0b5u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:11 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AADi5x9004252;
	Fri, 10 Nov 2023 13:54:10 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9nkx0b5m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:10 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AADTkkb014320;
	Fri, 10 Nov 2023 13:54:10 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u7w22b7vd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:09 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AADs6hT15467202
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Nov 2023 13:54:06 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C2C1E2004B;
	Fri, 10 Nov 2023 13:54:06 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D71DC20043;
	Fri, 10 Nov 2023 13:54:04 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.179.18.113])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Nov 2023 13:54:04 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 02/26] s390x: run PV guests with confidential guest enabled
Date: Fri, 10 Nov 2023 14:52:11 +0100
Message-ID: <20231110135348.245156-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231110135348.245156-1-nrb@linux.ibm.com>
References: <20231110135348.245156-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tmvrI5s2RdaM2E90WzC5GhrbzEDvJdtY
X-Proofpoint-ORIG-GUID: PS3S6eSJ4lJYEGvbVlu_Rg2KB_4Z5rum
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-10_10,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 malwarescore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 priorityscore=1501 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311100114

PV can only handle one page of SCLP read info, hence it can only support
a maximum of 247 CPUs.

To make sure we respect these limitations under PV, add a confidential
guest device to QEMU when launching a PV guest.

This fixes the topology-2 test failing under PV.

Also refactor the run script a bit to reduce code duplication by moving
the check whether we're running a PV guest to a function.

Suggested-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20230925135259.1685540-1-nrb@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/run | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/s390x/run b/s390x/run
index dcbf3f0..e58fa4a 100755
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


