Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC25743DFA
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 16:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbjF3Ozh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 10:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232795AbjF3Oze (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 10:55:34 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA207171E;
        Fri, 30 Jun 2023 07:55:33 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35UElZM4001376;
        Fri, 30 Jun 2023 14:55:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=U99M8H6iNOUWtIkJQrIPB10eO5cV/7YcdbEOSRxv9qE=;
 b=jxZkE3kddgE1lyD49moNLKbCSj24PkB2f5ShP3g7h7jugAE9Mki/9wR53wC+AipojnyB
 cMtDzaM58j/tUL2EU2SBU5KISprurecesecGzOrFCMs2MD9axEEEfjV9g8Db+dmLzGLl
 0DMusfbPxmhVkh2L79+GUxvmGpTr8d04y0yEsGva745TGupjTy4I7ByLBfrNTYj3JDe8
 Jf7bCgAz6R5Qw987RW+WtUcxhl0Rl0OkhlP/qMTwGlh5+x2dl7M2vePe+YkeAwMhsjr8
 J6mVxanw6ZTZEVLSZxlEmQ95q6Ok3hlTrMQYDYyIwLYzwwHVlQ1DEeQmbrq4FcrKZKPe 1w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rj14fr4xx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 14:55:32 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35UEmfli004360;
        Fri, 30 Jun 2023 14:55:32 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rj14fr4wm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 14:55:32 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35UB943c031583;
        Fri, 30 Jun 2023 14:55:29 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3rdr4532x8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 14:55:29 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35UEtQQD19071600
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Jun 2023 14:55:26 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5BF6A20040;
        Fri, 30 Jun 2023 14:55:26 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6BEAC20043;
        Fri, 30 Jun 2023 14:55:25 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 30 Jun 2023 14:55:25 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, david@redhat.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests RFC 2/3] lib: s390x: sclp: Clear ASCII screen on setup
Date:   Fri, 30 Jun 2023 14:54:48 +0000
Message-Id: <20230630145449.2312-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230630145449.2312-1-frankja@linux.ibm.com>
References: <20230630145449.2312-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: W3JydlZGx7rYOv9rAC6rQtnUM0eJndPD
X-Proofpoint-ORIG-GUID: 7bpjyP9dGnGvC2z4epodsOH0NKY5PtYy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-30_05,2023-06-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306300123
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In contrast to the line-mode console the ASCII console will retain
previously written text on a reboot. So let's clear the console on
setup so only our text will be displayed. To not clear the whole
screen when running under QEMU we switch the run command to the line
mode console.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/sclp-console.c | 2 ++
 s390x/run                | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/sclp-console.c b/lib/s390x/sclp-console.c
index 384080b0..534d3443 100644
--- a/lib/s390x/sclp-console.c
+++ b/lib/s390x/sclp-console.c
@@ -233,6 +233,8 @@ void sclp_console_setup(void)
 {
 	/* We send ASCII and line mode. */
 	sclp_write_event_mask(0, SCLP_EVENT_MASK_MSG_ASCII | SCLP_EVENT_MASK_MSG);
+	/* Hard terminal reset to clear screen */
+	sclp_print_ascii("\ec");
 }
 
 void sclp_print(const char *str)
diff --git a/s390x/run b/s390x/run
index f1111dbd..68f8e733 100755
--- a/s390x/run
+++ b/s390x/run
@@ -28,7 +28,7 @@ fi
 M='-machine s390-ccw-virtio'
 M+=",accel=$ACCEL"
 command="$qemu -nodefaults -nographic $M"
-command+=" -chardev stdio,id=con0 -device sclpconsole,chardev=con0"
+command+=" -chardev stdio,id=con0 -device sclplmconsole,chardev=con0"
 command+=" -kernel"
 command="$(panic_cmd) $(migration_cmd) $(timeout_cmd) $command"
 
-- 
2.34.1

