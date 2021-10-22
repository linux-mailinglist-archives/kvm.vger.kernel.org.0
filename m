Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDA654377BB
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 15:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbhJVNNY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 09:13:24 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14788 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230175AbhJVNNY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Oct 2021 09:13:24 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19MCXfFB007077
        for <kvm@vger.kernel.org>; Fri, 22 Oct 2021 09:11:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=URPdmcktdKoYXaSoyVTpX1e+f3KrDyR5T4MfrpURRds=;
 b=rNFIatu6Dww2sDS5IMaMJhSBrAf79WrXS27SgBznO2DvnYulDqrrkCxUPa6+62/yhHEV
 ilnH7tRDi6fVSYytD6OwkHBsrE5JRa0ZtltXerbpafzEJ3VQg9iEt06bKiV4Ecr8RDS2
 7oIsGlUKyGnvmHcTrauSB5hMkyxEby/xZoLkfV2xM6gbNU14UtBBvRxUYLIo3lsgn3Lc
 raqFcDbYDnum3rd40fxnr20D7bxSzLqjktAUgSjzSqVy0od/9I+2KUmkY2nCDVJjv9DK
 gM3o4er6pmucOXOb7olwIv4CJos0GXOjBDJ34Xz8HEYqi+dQiv/r7qdzFD7eq8dK4jHf kA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3buwderqdb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 22 Oct 2021 09:11:06 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19MCZFO3010107
        for <kvm@vger.kernel.org>; Fri, 22 Oct 2021 09:11:05 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3buwderqcs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Oct 2021 09:11:05 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19MD3guP007858;
        Fri, 22 Oct 2021 13:11:04 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3bqp0krr4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Oct 2021 13:11:03 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19MDB0EJ51249452
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 13:11:00 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD56B11C04A;
        Fri, 22 Oct 2021 13:11:00 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80C3B11C04C;
        Fri, 22 Oct 2021 13:11:00 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Oct 2021 13:11:00 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 0/1] Test spec exception interception
Date:   Fri, 22 Oct 2021 15:10:56 +0200
Message-Id: <20211022131057.1308851-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MjYLXMMwtIfsK8Bjj3_MzYL0B40Yo7-j
X-Proofpoint-ORIG-GUID: f5WDsu-VQk-mDyJqMCkpVpUZ66daRofH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-22_04,2021-10-22_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 clxscore=1015
 phishscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110220074
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When specification exception interpretation is enabled, specification
exceptions need not result in interceptions.
However, if the exception is due to an invalid program new PSW,
interception must occur.
Test this.
Also test that interpretation does occur if interpretation is disabled.

v2 -> v3
	drop patch converting assert to report
	drop non-ascii symbol
	use snippet constants

v1 -> v2
	Add license and test description
	Use lowcore pointer instead of magic value for program new PSW
		-> need to get rid of assert in arch_def.h
	Do not use odd program new PSW, even if irrelevant
	Use SIE lib
	Reword messages
	Fix nits

Janis Schoetterl-Glausch (1):
  s390x: Add specification exception interception test

 s390x/Makefile             |  2 +
 lib/s390x/sie.h            |  1 +
 s390x/snippets/c/spec_ex.c | 21 ++++++++++
 s390x/spec_ex-sie.c        | 82 ++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg        |  3 ++
 5 files changed, 109 insertions(+)
 create mode 100644 s390x/snippets/c/spec_ex.c
 create mode 100644 s390x/spec_ex-sie.c

Range-diff against v2:
1:  f8abbae ! 1:  319eb08 s390x: Add specification exception interception test
    @@ s390x/Makefile: tests += $(TEST_DIR)/mvpg.elf
      
      tests_binary = $(patsubst %.elf,%.bin,$(tests))
      ifneq ($(HOST_KEY_DOCUMENT),)
    -@@ s390x/Makefile: snippet_asmlib = $(SNIPPET_DIR)/c/cstart.o
    +@@ s390x/Makefile: snippet_asmlib = $(SNIPPET_DIR)/c/cstart.o lib/auxinfo.o
      # perquisites (=guests) for the snippet hosts.
      # $(TEST_DIR)/<snippet-host>.elf: snippets = $(SNIPPET_DIR)/<c/asm>/<snippet>.gbin
      $(TEST_DIR)/mvpg-sie.elf: snippets = $(SNIPPET_DIR)/c/mvpg-snippet.gbin
    @@ s390x/snippets/c/spec_ex.c (new)
     @@
     +// SPDX-License-Identifier: GPL-2.0-only
     +/*
    -+ * <utf-8 (C) symbol> Copyright IBM Corp. 2021
    ++ * Copyright IBM Corp. 2021
     + *
     + * Snippet used by specification exception interception test.
     + */
    -+#include <stdint.h>
    ++#include <libcflat.h>
    ++#include <bitops.h>
     +#include <asm/arch_def.h>
     +
     +__attribute__((section(".text"))) int main(void)
    @@ s390x/snippets/c/spec_ex.c (new)
     +	uint64_t bad_psw = 0;
     +
     +	/* PSW bit 12 has no name or meaning and must be 0 */
    -+	lowcore->pgm_new_psw.mask = 1UL << (63 - 12);
    ++	lowcore->pgm_new_psw.mask = BIT(63 - 12);
     +	lowcore->pgm_new_psw.addr = 0xdeadbeee;
     +	asm volatile ("lpsw %0" :: "Q"(bad_psw));
     +	return 0;
    @@ s390x/spec_ex-sie.c (new)
     @@
     +// SPDX-License-Identifier: GPL-2.0-only
     +/*
    -+ * <utf-8 (C) symbol> Copyright IBM Corp. 2021
    ++ * Copyright IBM Corp. 2021
     + *
     + * Specification exception interception test.
     + * Checks that specification exception interceptions occur as expected when
    @@ s390x/spec_ex-sie.c (new)
     +#include <alloc_page.h>
     +#include <vm.h>
     +#include <sie.h>
    ++#include <snippet.h>
     +
     +static struct vm vm;
    -+extern const char _binary_s390x_snippets_c_spec_ex_gbin_start[];
    -+extern const char _binary_s390x_snippets_c_spec_ex_gbin_end[];
    ++extern const char SNIPPET_NAME_START(c, spec_ex)[];
    ++extern const char SNIPPET_NAME_END(c, spec_ex)[];
     +
     +static void setup_guest(void)
     +{
     +	char *guest;
    -+	int binary_size = ((uintptr_t)_binary_s390x_snippets_c_spec_ex_gbin_end -
    -+			   (uintptr_t)_binary_s390x_snippets_c_spec_ex_gbin_start);
    ++	int binary_size = SNIPPET_LEN(c, spec_ex);
     +
     +	setup_vm();
     +	guest = alloc_pages(8);
    -+	memcpy(guest, _binary_s390x_snippets_c_spec_ex_gbin_start, binary_size);
    ++	memcpy(guest, SNIPPET_NAME_START(c, spec_ex), binary_size);
     +	sie_guest_create(&vm, (uint64_t) guest, HPAGE_SIZE);
     +}
     +
     +static void reset_guest(void)
     +{
    -+	vm.sblk->gpsw.addr = PAGE_SIZE * 4;
    -+	vm.sblk->gpsw.mask = PSW_MASK_64;
    ++	vm.sblk->gpsw = snippet_psw;
     +	vm.sblk->icptcode = 0;
     +}
     +

base-commit: 3ac97f8fc847d05d0a5555aefd34e2cac26fdc0c
-- 
2.31.1

