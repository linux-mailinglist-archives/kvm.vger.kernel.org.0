Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECBDF248599
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 15:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbgHRNFD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 09:05:03 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60084 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726353AbgHRNEz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Aug 2020 09:04:55 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07ICZOW1022661;
        Tue, 18 Aug 2020 09:04:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=0fOdFmUJ4Kg2RB4NqXo9O0/DZSYrjVMhMdobhvPjHd4=;
 b=f3fxSVQKKdCrMEIPHluDmh2YohTy+DJl2/20XeqUlXKAz2heEUMwWN5aoaVhozDn+OND
 ApXnMEXGYoGAXPFTnF22UC7Ffv6IjYuiTVHJvSlWE51pyltiidJwULU8hIfuV0HPxnRl
 iX2hxX7C03L+DHCOooXNy5b2hL4qwUf3H7dWsCkDoSiLS6iLQJfDEIRjoOKjeYpyfJrh
 30fY8mJLr/kaJLOW/3BDVF+chyiCyRILUwC5DfBySpfO4mIlEyexd79oIG8IGFyyNxbT
 x13GaY65ysrxtAnjwcU9NAyH3NinDtJqlpDAFUrTdtymBUedHIn0cp7mhB2GXs+QYZsm pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3304pfha5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Aug 2020 09:04:54 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07ICaEwa026129;
        Tue, 18 Aug 2020 09:04:54 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3304pfha4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Aug 2020 09:04:53 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07ID28rZ005356;
        Tue, 18 Aug 2020 13:04:52 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3304bt0p8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Aug 2020 13:04:52 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07ID4ne027722174
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 13:04:49 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 43FDA4C050;
        Tue, 18 Aug 2020 13:04:49 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9F3B4C058;
        Tue, 18 Aug 2020 13:04:48 +0000 (GMT)
Received: from marcibm.ibmuc.com (unknown [9.145.52.109])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Aug 2020 13:04:48 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     <kvm@vger.kernel.org>
Cc:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH 2/4] scripts: add support for architecture dependent functions
Date:   Tue, 18 Aug 2020 15:04:22 +0200
Message-Id: <20200818130424.20522-3-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200818130424.20522-1-mhartmay@linux.ibm.com>
References: <20200818130424.20522-1-mhartmay@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_07:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 spamscore=0 clxscore=1015 lowpriorityscore=0
 suspectscore=1 mlxlogscore=999 impostorscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180090
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is necessary to keep architecture dependent code separate from
common code.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
---
 README.md           | 3 ++-
 scripts/common.bash | 8 ++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/README.md b/README.md
index 48be206c6db1..24d4bdaaee0d 100644
--- a/README.md
+++ b/README.md
@@ -134,7 +134,8 @@ all unit tests.
 ## Directory structure
 
     .:                  configure script, top-level Makefile, and run_tests.sh
-    ./scripts:          helper scripts for building and running tests
+    ./scripts:          general architecture neutral helper scripts for building and running tests
+    ./scripts/<ARCH>:   architecture dependent helper scripts for building and running tests
     ./lib:              general architecture neutral services for the tests
     ./lib/<ARCH>:       architecture dependent services for the tests
     ./<ARCH>:           the sources of the tests and the created objects/images
diff --git a/scripts/common.bash b/scripts/common.bash
index 96655c9ffd1f..c7acdf14a835 100644
--- a/scripts/common.bash
+++ b/scripts/common.bash
@@ -1,3 +1,4 @@
+source config.mak
 
 function for_each_unittest()
 {
@@ -52,3 +53,10 @@ function for_each_unittest()
 	fi
 	exec {fd}<&-
 }
+
+# The current file has to be the only file sourcing the arch helper
+# file
+ARCH_FUNC=scripts/${ARCH}/func.bash
+if [ -f "${ARCH_FUNC}" ]; then
+	source "${ARCH_FUNC}"
+fi
-- 
2.25.4

