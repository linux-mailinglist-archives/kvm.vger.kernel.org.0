Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8204BA31F
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 15:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241985AbiBQOgA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 09:36:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241930AbiBQOfh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 09:35:37 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F9E82B1A8D
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 06:35:20 -0800 (PST)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21HEI1l7019755
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 14:35:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=dey7AaCvMS3bYKoSjeam+/u7FC4uH21CkdNym2mmgCk=;
 b=pBpfXmhMVphAy1RWb3+mrZ3v5jCQ42/KmsPYYYAHpvphonjd6zDvtAduVvwP5LA8fU77
 /dVnVrOcG79KMfErpUR3DYrSwB4KRt7H8xNWG9iqcV3p4p046EGwI9EMTY28izKWT0Np
 Qk5LChxSY+fJBeFGqy4M9toJSywmH0N42tHpai46elyNru2mKlGzPHASow8cfBzAhhRc
 KyoxIDRmVjEV488sSGq8FKwFU+zRHIRJJxkAH4vF0HtmJ1WAi668J2gd37kSUECjBwaX
 vwotRiNoh7xAUUrLku4TOhMVrXzyxlWSgZpFcXitL8yhlcyTkZCMSsV5yLw9LECbyvKZ YQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e9hdc0xkr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 14:35:20 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21HEYOwK010295
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 14:35:19 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e9hdc0xjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 14:35:19 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21HEXs5p014165;
        Thu, 17 Feb 2022 14:35:18 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3e64ha12f2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 14:35:17 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21HEZEhG28049894
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Feb 2022 14:35:14 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7BE344204F;
        Thu, 17 Feb 2022 14:35:14 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1DFA542049;
        Thu, 17 Feb 2022 14:35:14 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.2.54])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Feb 2022 14:35:14 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests GIT PULL 3/9] s390x: firq: fix running in PV
Date:   Thu, 17 Feb 2022 15:34:58 +0100
Message-Id: <20220217143504.232688-4-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217143504.232688-1-imbrenda@linux.ibm.com>
References: <20220217143504.232688-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lq6Q9GhF5ssfhv4bUn9dhA6GZ0ASTOZ0
X-Proofpoint-ORIG-GUID: gQMqw-E7nEa1cGW5ElgOiKSNQrl4fTjC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-17_05,2022-02-17_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 malwarescore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 phishscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202170066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
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

