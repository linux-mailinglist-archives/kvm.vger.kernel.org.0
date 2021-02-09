Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69A6F3156D7
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 20:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbhBITcd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 14:32:33 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14674 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233478AbhBITTn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Feb 2021 14:19:43 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 119IpMUF078303
        for <kvm@vger.kernel.org>; Tue, 9 Feb 2021 13:52:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=8czvwJUR+kJx91Eh1+JH5ryc0EoQmz7H4akWyq4ENGE=;
 b=GNkRBRNmFtWK0CYgzSyqoIFhMRdZM1OWhPztpACggkjF00akuVDKJB7UO0UEHpTiktYs
 TNAlZ0aYFhxx2BVz+LaCsnYJXL45DbOmxH3j5+nkUiGXAQYL/EKDda+7GSGZ4PxghDNi
 BvAswIg0GKQmwmRIC5dlMqHo94EiWS96gvsDg/AnuofQpOfszwNIfA/+0S9tNaJd2QOs
 9GPwvxmFNnjRcqY7gJZISTNwgeX9XY+5+XiiLNU8RFAMM/yNpfD6zQmTPngS3B34y8Fq
 1iNcSYZSkpOPOv1gS4Yr6vd7oUyBA6qOhSM4pbXhz/ZJDzwyrt9Fj4J8CNM3mff8WuTH iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36kyg9gt00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 09 Feb 2021 13:52:01 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 119IpRIx081165
        for <kvm@vger.kernel.org>; Tue, 9 Feb 2021 13:52:01 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36kyg9gsy7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 13:52:01 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 119IksOa001841;
        Tue, 9 Feb 2021 18:51:58 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 36hjr8bqg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 18:51:58 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 119IpuQ842926574
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Feb 2021 18:51:56 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E9FFEA4062;
        Tue,  9 Feb 2021 18:51:55 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 948E0A4054;
        Tue,  9 Feb 2021 18:51:55 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.1.216])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  9 Feb 2021 18:51:55 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, frankja@linux.ibm.com,
        cohuck@redhat.com, pmorel@linux.ibm.com, borntraeger@de.ibm.com
Subject: [kvm-unit-tests PATCH v1 2/3] s390x: check for specific program interrupt
Date:   Tue,  9 Feb 2021 19:51:53 +0100
Message-Id: <20210209185154.1037852-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210209185154.1037852-1-imbrenda@linux.ibm.com>
References: <20210209185154.1037852-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-09_06:2021-02-09,2021-02-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=664 mlxscore=0
 bulkscore=0 phishscore=0 priorityscore=1501 adultscore=0 clxscore=1015
 spamscore=0 suspectscore=0 malwarescore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We already have check_pgm_int_code to check and report if a specific
program interrupt has occourred, but this approach has some issues.

In order to specify which test is being run, it was needed to push and
pop a prefix for each test, which is not nice to read both in the code
and in the output.

Another issue is that sometimes the condition to test for might require
other checks in addition to the interrupt.

The simple function added in this patch tests if the program intteruupt
received is the one expected.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/asm/interrupt.h | 1 +
 lib/s390x/interrupt.c     | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
index 1a2e2cd8..a33437b1 100644
--- a/lib/s390x/asm/interrupt.h
+++ b/lib/s390x/asm/interrupt.h
@@ -23,6 +23,7 @@ void expect_pgm_int(void);
 void expect_ext_int(void);
 uint16_t clear_pgm_int(void);
 void check_pgm_int_code(uint16_t code);
+int is_pgm(int expected);
 
 /* Activate low-address protection */
 static inline void low_prot_enable(void)
diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index 59e01b1a..6f660285 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -51,6 +51,12 @@ void check_pgm_int_code(uint16_t code)
 	       lc->pgm_int_code);
 }
 
+int is_pgm(int expected)
+{
+	mb();
+	return expected == lc->pgm_int_code;
+}
+
 void register_pgm_cleanup_func(void (*f)(void))
 {
 	pgm_cleanup_func = f;
-- 
2.26.2

