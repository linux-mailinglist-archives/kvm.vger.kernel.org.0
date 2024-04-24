Return-Path: <kvm+bounces-15785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A45D98B07DF
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 13:00:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5AAD71F22F56
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 11:00:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6453C15A4A2;
	Wed, 24 Apr 2024 10:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iViOsoNu"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5AD11598FA
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 10:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713956393; cv=none; b=W050UXi+PX2nCVvlJC4InqdvBC3w8Hpdb+WxkqIUvXJIdfO7raD04mVXVqy6DUJ0mTuFicszzQy324/5tHOoVvmxMibJrR2OG8MdcOGZP8HzhpLyjUzwrsmgzi00a2YPjzeulZZEUl2Ca9N225UT2Pv7YWCpXY82Dm9+T2pH8rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713956393; c=relaxed/simple;
	bh=o7USaYeVPVK0g01NOIl8VSnZQOpu7dw+TC1uB+Vfp8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CbgIMXzhvDHQ61hanwykcXA2K9SR7QF0rupA9m+hf4lWUkV1HZ3VlVGwrY1wxhyboLP3JF7Tgt+cc7jEbCqO9go8JbkbQfoXX8/B+ewfepz5z/qlb33Z8BXH+ev8iUkKpdnCT5yjKdQAvXwiLCUfT03dTCrNXxXJ05hJqP3dC5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=iViOsoNu; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43OAjDSs008323;
	Wed, 24 Apr 2024 10:59:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=6YsTXc+zYHihPnTz1e2cseegNy0pYRGbAuq00a2OkEo=;
 b=iViOsoNuhz0McHWv8pztdOGI0J25+9vp9hNd+YtNRmWVpknuQTmSmZmiVmfH6DUWwM1J
 PwFOrvr7TVzo133zQA3BONxt90MavUmtWprRgVfIqhUnNl9MnZRCuffINdBYIcmSreBh
 N0FZXTMqqN8iCIaKQxHePXP6tFXylT5APmSaLnQIAdBrjdBrDumjAmVu4JYeuyhLSnYn
 yvukBQJ8rPsxjTfwwH1s5cX5Wetipfgup7vJFce/euHFkqJzvmSIscjNtWFbwsUtrOt1
 2+ZCbpI7WQsYvJVG8xjbB+6sRF5/OfsV39FJeRCFqUW1UY/UjQ8CjSvLhiLDzn8TOesP 8A== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xq0jh813g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:47 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43OAxkQ8030239;
	Wed, 24 Apr 2024 10:59:46 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xq0jh813f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:46 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43O7cCYa023012;
	Wed, 24 Apr 2024 10:59:46 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xms1p36vm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:46 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43OAxeOH40763748
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Apr 2024 10:59:42 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A0A542006C;
	Wed, 24 Apr 2024 10:59:40 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 78D762006E;
	Wed, 24 Apr 2024 10:59:40 +0000 (GMT)
Received: from t14-nrb.boeblingen.de.ibm.com (unknown [9.152.224.21])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 24 Apr 2024 10:59:40 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Nicholas Piggin <npiggin@gmail.com>
Subject: [kvm-unit-tests GIT PULL 10/13] s390x: Fix is_pv check in run script
Date: Wed, 24 Apr 2024 12:59:29 +0200
Message-ID: <20240424105935.184138-11-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240424105935.184138-1-nrb@linux.ibm.com>
References: <20240424105935.184138-1-nrb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8gXJqliP8jtiz577d1-sQfeT9qWZmAIg
X-Proofpoint-ORIG-GUID: qoe48LZVJOg7RYK4paotC8rczzIIcxSz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-24_08,2024-04-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 mlxscore=0
 impostorscore=0 phishscore=0 bulkscore=0 priorityscore=1501 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404240045

From: Nicholas Piggin <npiggin@gmail.com>

Shellcheck reports "is_pv references arguments, but none are ever
passed." and suggests "use is_pv "$@" if function's $1 should mean
script's $1."

The is_pv test does not evaluate to true for .pv.bin file names, only
for _PV suffix test names. The arch_cmd_s390x() function appends
.pv.bin to the file name AND _PV to the test name, so this does not
affect run_tests.sh runs, but it might prevent PV tests from being
run directly with the s390x-run command.

Reported-by: shellcheck SC2119, SC2120
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/run | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/s390x/run b/s390x/run
index e58fa4af..34552c27 100755
--- a/s390x/run
+++ b/s390x/run
@@ -21,12 +21,12 @@ is_pv() {
 	return 1
 }
 
-if is_pv && [ "$ACCEL" = "tcg" ]; then
+if is_pv "$@" && [ "$ACCEL" = "tcg" ]; then
 	echo "Protected Virtualization isn't supported under TCG"
 	exit 2
 fi
 
-if is_pv && [ "$MIGRATION" = "yes" ]; then
+if is_pv "$@" && [ "$MIGRATION" = "yes" ]; then
 	echo "Migration isn't supported under Protected Virtualization"
 	exit 2
 fi
@@ -34,12 +34,12 @@ fi
 M='-machine s390-ccw-virtio'
 M+=",accel=$ACCEL$ACCEL_PROPS"
 
-if is_pv; then
+if is_pv "$@"; then
 	M+=",confidential-guest-support=pv0"
 fi
 
 command="$qemu -nodefaults -nographic $M"
-if is_pv; then
+if is_pv "$@"; then
 	command+=" -object s390-pv-guest,id=pv0"
 fi
 command+=" -chardev stdio,id=con0 -device sclpconsole,chardev=con0"
-- 
2.44.0


