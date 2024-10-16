Return-Path: <kvm+bounces-29018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A25199A111F
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 20:03:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DE681B25513
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 18:03:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21D342139B5;
	Wed, 16 Oct 2024 18:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Y6Qq5Ag0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38AAF14A09E;
	Wed, 16 Oct 2024 18:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729101812; cv=none; b=fVofO7ZZsXaBzWKSear/+S1a8unaTQ32uWnEyEk5eGKMe5CHEj/lw5IQW2sNfLHIalz7p0hSI0GTGi3+Bwoe5d0WYyevSSG+jsuTCm8fVP0y/qMnSMoS7WLObEAoTw4RmYGhcQRbWmouk/b4XvGGOCkQwL+2oZI9hlUBGpdTcy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729101812; c=relaxed/simple;
	bh=UXCcOWKZV6I6/yVF2lJgJlrVeIINzW/NgqHEuwaLZT4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=blemapqO0EcsqyBBQPh7nCuepMHmS2DCaSWWl7LY3cBU+6MoF3+NU479EwJajJBpVtqDt/ykc20QH/KOLgZLe+WA6ziPE0zTKXOd5tZLjt7SGRD+8HvvbhKw5E1bti7tNdIrcQ3bZSeB/gykPi3jeRQgU6aj8z9on1paSlimgH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Y6Qq5Ag0; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49GFcfu1017296;
	Wed, 16 Oct 2024 18:03:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=GhoLq1R3rr4ntpqOd0mFpzX3nXiEXAbiMKdPNo5ol
	bU=; b=Y6Qq5Ag0XO4pVSLIyH8mrG4YNbaYW8+4HpzmBW9cK1ENvrg8DVc+lEEeo
	XZsTPIwqmkkFW0PzL3Vl9PKJoDyP+JKpST08Al2sr3hljKYa41kyDffZjjVxx4Zb
	ZETM4kDOZZjQwO67Kp6SAO5jsN+5FoMxTvSB9f5MPGTxv55bFnPoIWCXKGFSLzfy
	gP+ZsWZnHzBD0Cg1XaPyhq6vVYV9KyfAdq19erXNTC5Avn8Xj5glt8wCHIwXUoFo
	9In2fQTALklkevgnabz0QvgdJyrlZW9G6UknwsqjWuFgVAKkaK7O0rprLhmP8r4O
	9pvss3sd+cIvqdsK6CWkd9rV1Lrjw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42af3t93kh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Oct 2024 18:03:28 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49GI3Rpo019979;
	Wed, 16 Oct 2024 18:03:27 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42af3t93kf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Oct 2024 18:03:27 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49GEaAvA005377;
	Wed, 16 Oct 2024 18:03:26 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4285njagrf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Oct 2024 18:03:26 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49GI3NpE50004464
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 18:03:23 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 11CF620049;
	Wed, 16 Oct 2024 18:03:23 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AA6692004B;
	Wed, 16 Oct 2024 18:03:22 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 16 Oct 2024 18:03:22 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: =?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>, Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 0/6] s390x: STFLE nested interpretation
Date: Wed, 16 Oct 2024 20:03:11 +0200
Message-ID: <20241016180320.686132-1-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WEho0cf4UHaqne8akJzPU35RNOqpnq45
X-Proofpoint-ORIG-GUID: oWYUpPuIIGwB7IrPZq5ixhvv5GmGsLHI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 priorityscore=1501 spamscore=0 adultscore=0 phishscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410160115

v3 -> v4:
 * pick up R-b's (thanks Claudio, Janosch, Nick)
 * move diag intercept functions into sie-icpt.[hc]
   expose some more functionality to avoid interpreting the diag text
   with bit operations
 * move snippet exit functions into snippet-exit.h,
   guest part in s390x/snippet/lib
 * add barrier before snippet exit
 * simplify test (host and guest), add skip message

Add a test case that tests the interpretation of STFLE performed by a
nested guest using a snippet.
Also add some functionality to s390x lib, namely:
* exit (optionally with return code) from snippet
* add function for checking diag intercepts, replacing pv_icptdata_check_diag

v2 -> v3:
 * pick up Ack (thanks Andrew)
 * minor cosmetic change to rand generator
 * add sie_is_pv function
 * extend sie_is_diag_icpt to support pv, replace pv_icptdata_check_diag

v1 -> v2:
 * implement SHA-256 based PRNG
 * pick up R-b (thanks Claudio)
 * change snippet exit API and implementation (thanks Claudio)
 * add stfle-sie to unittests.cfg

Nina Schoetterl-Glausch (6):
  s390x: lib: Remove double include
  s390x: Add sie_is_pv
  s390x: Add function for checking diagnose intercepts
  s390x: Add library functions for exiting from snippet
  s390x: Use library functions for snippet exit
  s390x: Add test for STFLE interpretive execution (format-0)

 s390x/Makefile                    |   7 +-
 lib/s390x/asm/arch_def.h          |  13 +++
 lib/s390x/asm/facility.h          |  10 ++-
 lib/s390x/pv_icptdata.h           |  42 ---------
 lib/s390x/sie-icpt.h              |  39 +++++++++
 lib/s390x/sie.h                   |   6 ++
 lib/s390x/snippet-exit.h          |  47 ++++++++++
 lib/s390x/sie-icpt.c              |  60 +++++++++++++
 lib/s390x/sie.c                   |   5 +-
 s390x/snippets/lib/snippet-exit.h |  28 ++++++
 s390x/pv-diags.c                  |   9 +-
 s390x/pv-icptcode.c               |  12 +--
 s390x/pv-ipl.c                    |   8 +-
 s390x/sie-dat.c                   |  12 +--
 s390x/snippets/c/sie-dat.c        |  19 +---
 s390x/snippets/c/stfle.c          |  29 +++++++
 s390x/stfle-sie.c                 | 138 ++++++++++++++++++++++++++++++
 s390x/unittests.cfg               |   3 +
 18 files changed, 399 insertions(+), 88 deletions(-)
 delete mode 100644 lib/s390x/pv_icptdata.h
 create mode 100644 lib/s390x/sie-icpt.h
 create mode 100644 lib/s390x/snippet-exit.h
 create mode 100644 lib/s390x/sie-icpt.c
 create mode 100644 s390x/snippets/lib/snippet-exit.h
 create mode 100644 s390x/snippets/c/stfle.c
 create mode 100644 s390x/stfle-sie.c

Range-diff against v3:
1:  baecabf2 < -:  -------- lib: Add pseudo random functions
2:  b30314eb ! 1:  74832900 s390x: lib: Remove double include
    @@ Commit message
         libcflat.h was included twice.
     
         Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
    +    Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
         Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
     
      ## lib/s390x/sie.c ##
3:  f2af539b ! 2:  973607d1 s390x: Add sie_is_pv
    @@ Commit message
     
         Add a function to check if a guest VM is currently running protected.
     
    +    Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
    +    Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
    +    Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
         Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
     
      ## lib/s390x/sie.h ##
4:  c4331d19 ! 3:  56f16e10 s390x: Add function for checking diagnose intercepts
    @@ Commit message
     
         Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
     
    + ## s390x/Makefile ##
    +@@ s390x/Makefile: cflatobjs += lib/s390x/css_lib.o
    + cflatobjs += lib/s390x/malloc_io.o
    + cflatobjs += lib/s390x/uv.o
    + cflatobjs += lib/s390x/sie.o
    ++cflatobjs += lib/s390x/sie-icpt.o
    + cflatobjs += lib/s390x/fault.o
    + 
    + OBJDIRS += lib/s390x
    +
      ## lib/s390x/pv_icptdata.h (deleted) ##
     @@
     -/* SPDX-License-Identifier: GPL-2.0-only */
    @@ lib/s390x/pv_icptdata.h (deleted)
     -}
     -#endif
     
    - ## lib/s390x/sie.h ##
    -@@ lib/s390x/sie.h: static inline bool sie_is_pv(struct vm *vm)
    - 	return vm->sblk->sdf == 2;
    - }
    - 
    + ## lib/s390x/sie-icpt.h (new) ##
    +@@
    ++/* SPDX-License-Identifier: GPL-2.0-only */
    ++/*
    ++ * Functionality for SIE interception handling.
    ++ *
    ++ * Copyright IBM Corp. 2024
    ++ */
    ++
    ++#ifndef _S390X_SIE_ICPT_H_
    ++#define _S390X_SIE_ICPT_H_
    ++
    ++#include <libcflat.h>
    ++#include <sie.h>
    ++
    ++struct diag_itext {
    ++	uint64_t opcode   :  8;
    ++	uint64_t r_1      :  4;
    ++	uint64_t r_2      :  4;
    ++	uint64_t r_base   :  4;
    ++	uint64_t displace : 12;
    ++	uint64_t zero     : 16;
    ++	uint64_t          : 16;
    ++};
    ++
    ++struct diag_itext sblk_ip_as_diag(struct kvm_s390_sie_block *sblk);
    ++
     +/**
     + * sie_is_diag_icpt() - Check if intercept is due to diagnose instruction
     + * @vm: the guest
     + * @diag: the expected diagnose code
     + *
     + * Check that the intercept is due to diagnose @diag and valid.
    -+ * For protected virtualisation, check that the intercept data meets additional
    ++ * For protected virtualization, check that the intercept data meets additional
     + * constraints.
     + *
     + * Returns: true if intercept is due to a valid and has matching diagnose code
     + */
     +bool sie_is_diag_icpt(struct vm *vm, unsigned int diag);
    - void sie_guest_sca_create(struct vm *vm);
    - void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t guest_mem_len);
    - void sie_guest_destroy(struct vm *vm);
    ++
    ++#endif /* _S390X_SIE_ICPT_H_ */
     
    - ## lib/s390x/sie.c ##
    -@@ lib/s390x/sie.c: void sie_check_validity(struct vm *vm, uint16_t vir_exp)
    - 	report(vir_exp == vir, "VALIDITY: %x", vir);
    - }
    - 
    -+bool sie_is_diag_icpt(struct vm *vm, unsigned int diag)
    + ## lib/s390x/sie-icpt.c (new) ##
    +@@
    ++/* SPDX-License-Identifier: GPL-2.0-only */
    ++/*
    ++ * Functionality for SIE interception handling.
    ++ *
    ++ * Copyright IBM Corp. 2024
    ++ */
    ++
    ++#include <sie-icpt.h>
    ++
    ++struct diag_itext sblk_ip_as_diag(struct kvm_s390_sie_block *sblk)
     +{
     +	union {
     +		struct {
    -+			uint64_t     : 16;
     +			uint64_t ipa : 16;
     +			uint64_t ipb : 32;
    ++			uint64_t     : 16;
     +		};
    -+		struct {
    -+			uint64_t          : 16;
    -+			uint64_t opcode   :  8;
    -+			uint64_t r_1      :  4;
    -+			uint64_t r_2      :  4;
    -+			uint64_t r_base   :  4;
    -+			uint64_t displace : 12;
    -+			uint64_t zero     : 16;
    -+		};
    -+	} instr = { .ipa = vm->sblk->ipa, .ipb = vm->sblk->ipb };
    ++		struct diag_itext diag;
    ++	} instr = { .ipa = sblk->ipa, .ipb = sblk->ipb };
    ++
    ++	return instr.diag;
    ++}
    ++
    ++bool sie_is_diag_icpt(struct vm *vm, unsigned int diag)
    ++{
    ++	struct diag_itext instr = sblk_ip_as_diag(vm->sblk);
     +	uint8_t icptcode;
     +	uint64_t code;
     +
    @@ lib/s390x/sie.c: void sie_check_validity(struct vm *vm, uint16_t vir_exp)
     +		break;
     +	default:
     +		/* If a new diag is introduced add it to the cases above! */
    -+		assert_msg(false, "unknown diag");
    ++		assert_msg(false, "unknown diag 0x%x", diag);
     +	}
     +
     +	if (sie_is_pv(vm)) {
    @@ lib/s390x/sie.c: void sie_check_validity(struct vm *vm, uint16_t vir_exp)
     +	code = (code + instr.displace) & 0xffff;
     +	return code == diag;
     +}
    -+
    - void sie_handle_validity(struct vm *vm)
    - {
    - 	if (vm->sblk->icptcode != ICPT_VALIDITY)
     
      ## s390x/pv-diags.c ##
     @@
    @@ s390x/pv-diags.c
      #include <libcflat.h>
      #include <snippet.h>
     -#include <pv_icptdata.h>
    ++#include <sie-icpt.h>
      #include <sie.h>
      #include <sclp.h>
      #include <asm/facility.h>
    @@ s390x/pv-icptcode.c
      #include <sclp.h>
      #include <snippet.h>
     -#include <pv_icptdata.h>
    ++#include <sie-icpt.h>
      #include <asm/facility.h>
      #include <asm/barrier.h>
      #include <asm/sigp.h>
    @@ s390x/pv-ipl.c
      #include <sclp.h>
      #include <snippet.h>
     -#include <pv_icptdata.h>
    ++#include <sie-icpt.h>
      #include <asm/facility.h>
      #include <asm/uv.h>
      
5:  a3f92777 ! 4:  8cafb8da s390x: Add library functions for exiting from snippet
    @@ Commit message
         Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
     
      ## s390x/Makefile ##
    -@@ s390x/Makefile: cflatobjs += lib/s390x/css_lib.o
    - cflatobjs += lib/s390x/malloc_io.o
    - cflatobjs += lib/s390x/uv.o
    - cflatobjs += lib/s390x/sie.o
    -+cflatobjs += lib/s390x/snippet-host.o
    - cflatobjs += lib/s390x/fault.o
    +@@ s390x/Makefile: test_cases: $(tests)
    + test_cases_binary: $(tests_binary)
    + test_cases_pv: $(tests_pv_binary)
    + 
    +-INCLUDE_PATHS = $(SRCDIR)/lib $(SRCDIR)/lib/s390x $(SRCDIR)/s390x
    ++SNIPPET_INCLUDE :=
    ++INCLUDE_PATHS = $(SNIPPET_INCLUDE) $(SRCDIR)/lib $(SRCDIR)/lib/s390x $(SRCDIR)/s390x
    + # Include generated header files (e.g. in case of out-of-source builds)
    + INCLUDE_PATHS += lib
    + CPPFLAGS = $(addprefix -I,$(INCLUDE_PATHS))
    +@@ s390x/Makefile: endif
    + $(SNIPPET_DIR)/asm/%.o: $(SNIPPET_DIR)/asm/%.S $(asm-offsets)
    + 	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
    + 
    ++$(SNIPPET_DIR)/c/%.o: SNIPPET_INCLUDE := $(SNIPPET_DIR)/lib
    + $(SNIPPET_DIR)/c/%.o: $(SNIPPET_DIR)/c/%.c $(asm-offsets)
    + 	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
      
    - OBJDIRS += lib/s390x
     
      ## lib/s390x/asm/arch_def.h ##
     @@ lib/s390x/asm/arch_def.h: static inline uint32_t get_prefix(void)
    @@ lib/s390x/asm/arch_def.h: static inline uint32_t get_prefix(void)
     +
      #endif
     
    - ## lib/s390x/snippet-guest.h (new) ##
    + ## lib/s390x/snippet-exit.h (new) ##
     @@
     +/* SPDX-License-Identifier: GPL-2.0-only */
     +/*
    -+ * Snippet functionality for the guest.
    ++ * Functionality handling snippet exits
     + *
    -+ * Copyright IBM Corp. 2023
    ++ * Copyright IBM Corp. 2024
     + */
     +
    -+#ifndef _S390X_SNIPPET_GUEST_H_
    -+#define _S390X_SNIPPET_GUEST_H_
    -+
    -+#include <asm/arch_def.h>
    -+#include <asm/barrier.h>
    -+
    -+static inline void force_exit(void)
    -+{
    -+	diag44();
    -+	mb(); /* allow host to modify guest memory */
    -+}
    -+
    -+static inline void force_exit_value(uint64_t val)
    -+{
    -+	diag9c(val);
    -+	mb(); /* allow host to modify guest memory */
    -+}
    -+
    -+#endif /* _S390X_SNIPPET_GUEST_H_ */
    -
    - ## lib/s390x/snippet.h => lib/s390x/snippet-host.h ##
    -@@
    - /* SPDX-License-Identifier: GPL-2.0-only */
    - /*
    -- * Snippet definitions
    -+ * Snippet functionality for the host.
    -  *
    -  * Copyright IBM Corp. 2021
    -  * Author: Janosch Frank <frankja@linux.ibm.com>
    -  */
    - 
    --#ifndef _S390X_SNIPPET_H_
    --#define _S390X_SNIPPET_H_
    -+#ifndef _S390X_SNIPPET_HOST_H_
    -+#define _S390X_SNIPPET_HOST_H_
    - 
    - #include <sie.h>
    - #include <uv.h>
    -@@ lib/s390x/snippet-host.h: static inline void snippet_setup_guest(struct vm *vm, bool is_pv)
    - 	}
    - }
    - 
    -+bool snippet_is_force_exit(struct vm *vm);
    -+bool snippet_is_force_exit_value(struct vm *vm);
    -+uint64_t snippet_get_force_exit_value(struct vm *vm);
    -+void snippet_check_force_exit_value(struct vm *vm, uint64_t exit_exp);
    - #endif
    -
    - ## lib/s390x/snippet-host.c (new) ##
    -@@
    -+/* SPDX-License-Identifier: GPL-2.0-only */
    -+/*
    -+ * Snippet functionality for the host.
    -+ *
    -+ * Copyright IBM Corp. 2023
    -+ */
    ++#ifndef _S390X_SNIPPET_EXIT_H_
    ++#define _S390X_SNIPPET_EXIT_H_
     +
     +#include <libcflat.h>
    -+#include <snippet-host.h>
     +#include <sie.h>
    ++#include <sie-icpt.h>
     +
    -+bool snippet_is_force_exit(struct vm *vm)
    ++static inline bool snippet_is_force_exit(struct vm *vm)
     +{
     +	return sie_is_diag_icpt(vm, 0x44);
     +}
     +
    -+bool snippet_is_force_exit_value(struct vm *vm)
    ++static inline bool snippet_is_force_exit_value(struct vm *vm)
     +{
     +	return sie_is_diag_icpt(vm, 0x9c);
     +}
     +
    -+uint64_t snippet_get_force_exit_value(struct vm *vm)
    ++static inline uint64_t snippet_get_force_exit_value(struct vm *vm)
     +{
     +	struct kvm_s390_sie_block *sblk = vm->sblk;
     +
     +	assert(snippet_is_force_exit_value(vm));
     +
    -+	return vm->save_area.guest.grs[(sblk->ipa & 0xf0) >> 4];
    ++	return vm->save_area.guest.grs[sblk_ip_as_diag(sblk).r_1];
     +}
     +
    -+void snippet_check_force_exit_value(struct vm *vm, uint64_t value_exp)
    ++static inline void snippet_check_force_exit_value(struct vm *vm, uint64_t value_exp)
     +{
     +	uint64_t value;
     +
    @@ lib/s390x/snippet-host.c (new)
     +		report_fail("guest forced exit with value");
     +	}
     +}
    -
    - ## lib/s390x/uv.c ##
    -@@
    - #include <asm/uv.h>
    - #include <uv.h>
    - #include <sie.h>
    --#include <snippet.h>
    -+#include <snippet-host.h>
    - 
    - static struct uv_cb_qui uvcb_qui = {
    - 	.header.cmd = UVC_CMD_QUI,
    -
    - ## s390x/mvpg-sie.c ##
    -@@
    - #include <alloc_page.h>
    - #include <sclp.h>
    - #include <sie.h>
    --#include <snippet.h>
    -+#include <snippet-host.h>
    - 
    - static struct vm vm;
    - 
    -
    - ## s390x/pv-diags.c ##
    -@@
    -  *  Janosch Frank <frankja@linux.ibm.com>
    -  */
    - #include <libcflat.h>
    --#include <snippet.h>
    -+#include <snippet-host.h>
    - #include <sie.h>
    - #include <sclp.h>
    - #include <asm/facility.h>
    -
    - ## s390x/pv-icptcode.c ##
    -@@
    - #include <sie.h>
    - #include <smp.h>
    - #include <sclp.h>
    --#include <snippet.h>
    -+#include <snippet-host.h>
    - #include <asm/facility.h>
    - #include <asm/barrier.h>
    - #include <asm/sigp.h>
    -
    - ## s390x/pv-ipl.c ##
    -@@
    - #include <libcflat.h>
    - #include <sie.h>
    - #include <sclp.h>
    --#include <snippet.h>
    -+#include <snippet-host.h>
    - #include <asm/facility.h>
    - #include <asm/uv.h>
    - 
    -
    - ## s390x/sie-dat.c ##
    -@@
    - #include <alloc_page.h>
    - #include <sclp.h>
    - #include <sie.h>
    --#include <snippet.h>
    -+#include <snippet-host.h>
    - #include "snippets/c/sie-dat.h"
    - 
    - static struct vm vm;
    -
    - ## s390x/spec_ex-sie.c ##
    -@@
    - #include <asm/arch_def.h>
    - #include <alloc_page.h>
    - #include <sie.h>
    --#include <snippet.h>
    -+#include <snippet-host.h>
    - #include <hardware.h>
    - 
    - static struct vm vm;
    -
    - ## s390x/uv-host.c ##
    -@@
    - #include <sclp.h>
    - #include <smp.h>
    - #include <uv.h>
    --#include <snippet.h>
    -+#include <snippet-host.h>
    - #include <mmu.h>
    - #include <asm/page.h>
    - #include <asm/pgtable.h>
    ++
    ++#endif /* _S390X_SNIPPET_EXIT_H_ */
    +
    + ## s390x/snippets/lib/snippet-exit.h (new) ##
    +@@
    ++/* SPDX-License-Identifier: GPL-2.0-only */
    ++/*
    ++ * Functionality for exiting the snippet.
    ++ *
    ++ * Copyright IBM Corp. 2023
    ++ */
    ++
    ++#ifndef _S390X_SNIPPET_LIB_EXIT_H_
    ++#define _S390X_SNIPPET_LIB_EXIT_H_
    ++
    ++#include <asm/arch_def.h>
    ++#include <asm/barrier.h>
    ++
    ++static inline void force_exit(void)
    ++{
    ++	mb(); /* host may read any memory written by the guest before */
    ++	diag44();
    ++	mb(); /* allow host to modify guest memory */
    ++}
    ++
    ++static inline void force_exit_value(uint64_t val)
    ++{
    ++	mb(); /* host may read any memory written by the guest before */
    ++	diag9c(val);
    ++	mb(); /* allow host to modify guest memory */
    ++}
    ++
    ++#endif /* _S390X_SNIPPET_LIB_EXIT_H_ */
6:  a1db588b ! 5:  cd79e654 s390x: Use library functions for snippet exit
    @@ Commit message
         Replace the existing code for exiting from snippets with the newly
         introduced library functionality.
     
    +    Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
    +    Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
         Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
     
      ## s390x/sie-dat.c ##
    +@@
    + #include <sclp.h>
    + #include <sie.h>
    + #include <snippet.h>
    ++#include <snippet-exit.h>
    + #include "snippets/c/sie-dat.h"
    + 
    + static struct vm vm;
     @@ s390x/sie-dat.c: static void test_sie_dat(void)
      	uint64_t test_page_gpa, test_page_hpa;
      	uint8_t *test_page_hva, expected_val;
    @@ s390x/snippets/c/sie-dat.c
      #include <libcflat.h>
      #include <asm-generic/page.h>
      #include <asm/mem.h>
    -+#include <snippet-guest.h>
    ++#include <snippet-exit.h>
      #include "sie-dat.h"
      
      static uint8_t test_pages[GUEST_TEST_PAGE_COUNT * PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
7:  0b89b3c6 ! 6:  1e9893b6 s390x: Add test for STFLE interpretive execution (format-0)
    @@ s390x/snippets/c/stfle.c (new)
     + * Snippet used by the STLFE interpretive execution facilities test.
     + */
     +#include <libcflat.h>
    -+#include <snippet-guest.h>
    ++#include <snippet-exit.h>
     +
     +int main(void)
     +{
     +	const unsigned int max_fac_len = 8;
    ++	uint64_t len_arg = max_fac_len - 1;
     +	uint64_t res[max_fac_len + 1];
    ++	uint64_t fac[max_fac_len];
     +
    -+	res[0] = max_fac_len - 1;
    -+	asm volatile ( "lg	0,%[len]\n"
    ++	asm volatile ( "lgr	0,%[len]\n"
     +		"	stfle	%[fac]\n"
    -+		"	stg	0,%[len]\n"
    -+		: [fac] "=QS"(*(uint64_t(*)[max_fac_len])&res[1]),
    -+		  [len] "+RT"(res[0])
    ++		"	lgr	%[len],0\n"
    ++		: [fac] "=Q"(fac),
    ++		  [len] "+d"(len_arg)
     +		:
     +		: "%r0", "cc"
     +	);
    ++	res[0] = len_arg;
    ++	memcpy(&res[1], fac, sizeof(fac));
     +	force_exit_value((uint64_t)&res);
     +	return 0;
     +}
    @@ s390x/stfle-sie.c (new)
     +#include <stdlib.h>
     +#include <asm/facility.h>
     +#include <asm/time.h>
    -+#include <snippet-host.h>
    ++#include <snippet.h>
    ++#include <snippet-exit.h>
     +#include <alloc_page.h>
     +#include <sclp.h>
     +#include <rand.h>
    @@ s390x/stfle-sie.c (new)
     +
     +struct guest_stfle_res {
     +	uint16_t len;
    -+	uint64_t reg;
     +	unsigned char *mem;
     +};
     +
    @@ s390x/stfle-sie.c (new)
     +{
     +	struct guest_stfle_res res;
     +	uint64_t guest_stfle_addr;
    ++	uint64_t reg;
     +
     +	sie(&vm);
     +	assert(snippet_is_force_exit_value(&vm));
     +	guest_stfle_addr = snippet_get_force_exit_value(&vm);
     +	res.mem = &vm.guest_mem[guest_stfle_addr];
    -+	memcpy(&res.reg, res.mem, sizeof(res.reg));
    -+	res.len = (res.reg & 0xff) + 1;
    -+	res.mem += sizeof(res.reg);
    ++	memcpy(&reg, res.mem, sizeof(reg));
    ++	res.len = (reg & 0xff) + 1;
    ++	res.mem += sizeof(reg);
     +	return res;
     +}
     +
    @@ s390x/stfle-sie.c (new)
     +int main(int argc, char **argv)
     +{
     +	struct args args = parse_args(argc, argv);
    ++	bool run_format_0 = test_facility(7);
     +
     +	if (!sclp_facilities.has_sief2) {
     +		report_skip("SIEF2 facility unavailable");
     +		goto out;
     +	}
    ++	if (!run_format_0)
    ++		report_skip("STFLE facility not available");
     +
     +	report_info("PRNG seed: 0x%lx", args.seed);
     +	prng_s = prng_init(args.seed);
     +	setup_guest();
    -+	if (test_facility(7))
    ++	if (run_format_0)
     +		test_stfle_format_0();
     +out:
     +	return report_summary();

base-commit: f246b16099478a916eab37b9bd1eb07c743a67d5
-- 
2.44.0


