Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4273B7317
	for <lists+kvm@lfdr.de>; Tue, 29 Jun 2021 15:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233990AbhF2NVe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Jun 2021 09:21:34 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58110 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233141AbhF2NVb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Jun 2021 09:21:31 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15TD3PhU183065;
        Tue, 29 Jun 2021 09:19:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=3QYNEDnztpYo6ahTBFC0BTqZjI+g8c7Anfs38kD1xGY=;
 b=WcezjzdmxZTXUoo7VwSOXL8FvbNQh6f8cAB2tR3Vrvs9ZNNVurB/927uU/M/Cn32xiCf
 wpwEeiSlcM3rZcwXGjPfSjFG3p1TNRgDigIKwdxZ3MQZLCEZhE/bNHzI5f6JnqRfXD90
 Z3i7CjL4rv903zOzfu/virr5NFdXA17iOZuUUE+Jn0g4Ma3k1LlHnkngbr2W49yearW2
 tQeccdXiB+xIHoWLnLZUSdXo23u3WojV1oqekk5CX1Vmu8piMB2BBbzAgYKaSjZ5Ax0D
 +XNHX8qCKiFxPIlu8uhb+Ymc/JEcbjJda32C9rU771yzPWv7WsNisShM8fK1ed+TAHuJ sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39g2k4k5yr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 09:19:03 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15TD3vRj185010;
        Tue, 29 Jun 2021 09:19:02 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39g2k4k5xu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 09:19:02 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15TDCnEd010851;
        Tue, 29 Jun 2021 13:19:00 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 39duv8gp8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 13:19:00 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15TDIwTY23855378
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 13:18:58 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4DA8C4C046;
        Tue, 29 Jun 2021 13:18:58 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11C254C05A;
        Tue, 29 Jun 2021 13:18:58 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 29 Jun 2021 13:18:58 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v2 2/3] s390x: snippets: Add snippet compilation
Date:   Tue, 29 Jun 2021 13:18:40 +0000
Message-Id: <20210629131841.17319-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210629131841.17319-1-frankja@linux.ibm.com>
References: <20210629131841.17319-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jj_eZTggji7f32mv0b-qPOmQ2mLCpdg4
X-Proofpoint-ORIG-GUID: YHgbnMWp1TqUbkrUVNtuhbMDqGTDJxOj
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-29_06:2021-06-28,2021-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 clxscore=1015 impostorscore=0 priorityscore=1501
 suspectscore=0 adultscore=0 mlxscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106290088
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
Acked-by: Thomas Huth <thuth@redhat.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
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
2.30.2

