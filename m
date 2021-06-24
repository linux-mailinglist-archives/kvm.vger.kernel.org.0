Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68F9C3B2E7C
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 14:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbhFXMEe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 08:04:34 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37120 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230299AbhFXME3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Jun 2021 08:04:29 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15OBYXDV017272;
        Thu, 24 Jun 2021 08:02:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=qwDRxQQ5l3uyFblHYBLRq4oPFf3xSak7YlAw2UlOoHI=;
 b=gPveNsCbm+C5YllNDvOu18QZLp4Eu6aGEMKmv+fbd2BGj5McQ3mZv9kfoodRNmEwZ879
 sEvwDuXXnF8kumR/cEXp01xJVXK4ZFYrVcJDZoScRsXa27yMJBXSrangGTT0qeibgsyN
 NBYAFoDXKYVEK9RN7ygHBBn5LyGgHrpl+Ms1mZdjbdsNl7H4sF3w7msHPlPpEpbKYA5v
 0euKO/bilkEtbrcfp7T6HLeJXdxb89VV9WcbDAUIEyAbNSNJIjnnkStFhbDKOzRkGAP6
 2SLe2WTm50d6yZKLYwlO/84/speLnl3bicaXmRli91fgWdGnkBm/mbxHqN4ghBqGLG33 yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39cqpemcr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jun 2021 08:02:10 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15OBYlE0018389;
        Thu, 24 Jun 2021 08:02:10 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39cqpemcpb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jun 2021 08:02:10 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15OC1t3d014578;
        Thu, 24 Jun 2021 12:02:07 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3998789d46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jun 2021 12:02:06 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15OC24wY30933286
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Jun 2021 12:02:04 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10615AE05D;
        Thu, 24 Jun 2021 12:02:04 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C5B5AAE059;
        Thu, 24 Jun 2021 12:02:03 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 24 Jun 2021 12:02:03 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        seiden@linux.ibm.com
Subject: [PATCH 2/3] s390x: snippets: Add snippet compilation
Date:   Thu, 24 Jun 2021 12:01:51 +0000
Message-Id: <20210624120152.344009-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210624120152.344009-1-frankja@linux.ibm.com>
References: <20210624120152.344009-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rwwJNp01SMHHWqgICx9cpTiYNvZEVLFJ
X-Proofpoint-ORIG-GUID: fxtHxKCUT3NhXJhPZIhGuGYOsBrIwgqi
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-24_11:2021-06-24,2021-06-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 priorityscore=1501 mlxlogscore=999 bulkscore=0 malwarescore=0
 clxscore=1015 mlxscore=0 suspectscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106240062
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Steffen Eiden <seiden@linux.ibm.com>

This patch provides the necessary make targets to properly compile
snippets and link them into their associated host.

To define the guest-host definition, we use the make-feature
`SECONDEXPANSION` in combination with `Target specific Variable
Values`. The variable `snippets` has different values depending on the
current target. This enables us to define which snippets (=guests)
belong to which hosts. Furthermore, using the second-expansion, we can
use `snippets` in the perquisites of the host's `%.elf` rule, which
otherwise would be not set.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
---
 s390x/Makefile | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/s390x/Makefile b/s390x/Makefile
index 8820e99..ba32f4c 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -76,11 +76,26 @@ OBJDIRS += lib/s390x
 asmlib = $(TEST_DIR)/cstart64.o $(TEST_DIR)/cpu.o
 
 FLATLIBS = $(libcflat)
-%.elf: %.o $(FLATLIBS) $(SRCDIR)/s390x/flat.lds $(asmlib)
-	$(CC) $(CFLAGS) -c -o $(@:.elf=.aux.o) \
-		$(SRCDIR)/lib/auxinfo.c -DPROGNAME=\"$@\"
-	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/flat.lds \
-		$(filter %.o, $^) $(FLATLIBS) $(@:.elf=.aux.o)
+
+SNIPPET_DIR = $(TEST_DIR)/snippets
+snippet_asmlib = $(SNIPPET_DIR)/c/cstart.o
+
+# perquisites (=guests) for the snippet hosts.
+# $(TEST_DIR)/<snippet-host>.elf: snippets = $(SNIPPET_DIR)/<c/asm>/<snippet>.gbin
+
+$(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o $(FLATLIBS)
+	$(OBJCOPY) -O binary $(patsubst %.gbin,%.o,$@) $@
+	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $@ $@
+
+$(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_asmlib) $(FLATLIBS)
+	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/c/flat.lds $(patsubst %.gbin,%.o,$@) $(snippet_asmlib) $(FLATLIBS)
+	$(OBJCOPY) -O binary $@ $@
+	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $@ $@
+
+.SECONDEXPANSION:
+%.elf: $$(snippets) %.o $(FLATLIBS) $(SRCDIR)/s390x/flat.lds $(asmlib)
+	$(CC) $(CFLAGS) -c -o $(@:.elf=.aux.o) $(SRCDIR)/lib/auxinfo.c -DPROGNAME=\"$@\"
+	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/flat.lds $(filter %.o, $^) $(FLATLIBS) $(snippets) $(@:.elf=.aux.o)
 	$(RM) $(@:.elf=.aux.o)
 	@chmod a-x $@
 
@@ -94,7 +109,7 @@ FLATLIBS = $(libcflat)
 	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --no-verify --image $< -o $@
 
 arch_clean: asm_offsets_clean
-	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(TEST_DIR)/.*.d lib/s390x/.*.d
+	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(TEST_DIR)/.*.d $(SNIPPET_DIR)/c/*.{o,gbin} $(SNIPPET_DIR)/c/.*.d lib/s390x/.*.d
 
 generated-files = $(asm-offsets)
 $(tests:.elf=.o) $(asmlib) $(cflatobjs): $(generated-files)
-- 
2.27.0

