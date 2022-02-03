Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9C674A8878
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 17:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352173AbiBCQSo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 11:18:44 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58674 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352171AbiBCQSm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Feb 2022 11:18:42 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 213EWapH035090
        for <kvm@vger.kernel.org>; Thu, 3 Feb 2022 16:18:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=d95WgPfswLUOO64n8jcLQRDZF3xWkVYRvmy6w5TaVT0=;
 b=b2aIAyb7o2/7OAiTMAbHp+qWCUY2sHu99cgeiPcv1ldvd+lcZNZ4LO+Ln4Uh6UF9EEQ4
 o/o+yyTFMHlyZ7Y142ZUcoq5rPWsGUYOSkYSmBy2iI8YZlvoBqLiY+ZhLtFG+puuhwLI
 iutVVJ5oyzw13M/LCLxWbU2P5KIJzRIgF0oOMV753Xu4qISasW/kwgO2pX5N1/4kc8fJ
 4nta3vuWuG8iDez1q99Z0gaBlK34kqscfk3XLpR7MTqYhyE0yYhOSomb7qWxXZ2UP0fF
 X0y7RhpONMDguXVsoRzdsuQsrdTVvm1c7Q5rj0EZ8vSrPf5vI0dAqHBuT1g2vsmntCkA Fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0b6cakqj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 03 Feb 2022 16:18:41 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 213EWcbn035433
        for <kvm@vger.kernel.org>; Thu, 3 Feb 2022 16:18:39 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0b6cakq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Feb 2022 16:18:39 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 213GHQnO006913;
        Thu, 3 Feb 2022 16:18:37 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3dvw7a7ucc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Feb 2022 16:18:37 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 213GIZp539715078
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Feb 2022 16:18:35 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5682B11C058;
        Thu,  3 Feb 2022 16:18:35 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 095CA11C04C;
        Thu,  3 Feb 2022 16:18:35 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.1.135])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  3 Feb 2022 16:18:34 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     david@redhat.com, frankja@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v1 1/1] s390x: firq: fix running in PV
Date:   Thu,  3 Feb 2022 17:18:34 +0100
Message-Id: <20220203161834.52472-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RuPV5S3errB4bg-vCPzpBvsUWC9rGHx2
X-Proofpoint-GUID: IO-h1sb_xSIBjdiHnzIkE5pCaFGw1ghF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-03_05,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 bulkscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 spamscore=0 malwarescore=0 suspectscore=0 priorityscore=1501 clxscore=1015
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202030097
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If using the qemu CPU type, Protected Virtualization is not available,
and the test will fail to start when run in PV. If specifying the host
CPU type, the test will fail to start with TCG because the host CPU
type requires KVM. In both cases the test will show up as failed.

This patch adds a copy of the firq test definitions for KVM, using the
host CPU type, and specifying that KVM is to be used. The existing
firq tests are then fixed by specifying that TCG is to be used.

When running the tests normally, both variants will be run. If an
accelerator is specified explicitly when running the tests, only one
variant will run and the other will be skipped (and not fail).

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Fixes: 8b98745d ("s390x: firq: floating interrupt test")
---
 s390x/unittests.cfg | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 054560c2..1600e714 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -113,12 +113,26 @@ file = mvpg-sie.elf
 [spec_ex-sie]
 file = spec_ex-sie.elf
 
-[firq-linear-cpu-ids]
+[firq-linear-cpu-ids-kvm]
+file = firq.elf
+timeout = 20
+extra_params = -smp 1,maxcpus=3 -device host-s390x-cpu,core-id=1 -device host-s390x-cpu,core-id=2
+accel = kvm
+
+[firq-nonlinear-cpu-ids-kvm]
+file = firq.elf
+timeout = 20
+extra_params = -smp 1,maxcpus=3 -device host-s390x-cpu,core-id=2 -device host-s390x-cpu,core-id=1
+accel = kvm
+
+[firq-linear-cpu-ids-tcg]
 file = firq.elf
 timeout = 20
 extra_params = -smp 1,maxcpus=3 -cpu qemu -device qemu-s390x-cpu,core-id=1 -device qemu-s390x-cpu,core-id=2
+accel = tcg
 
-[firq-nonlinear-cpu-ids]
+[firq-nonlinear-cpu-ids-tcg]
 file = firq.elf
 timeout = 20
 extra_params = -smp 1,maxcpus=3 -cpu qemu -device qemu-s390x-cpu,core-id=2 -device qemu-s390x-cpu,core-id=1
+accel = tcg
-- 
2.34.1

