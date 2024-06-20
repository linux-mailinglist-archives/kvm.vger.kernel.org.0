Return-Path: <kvm+bounces-20086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id ED6049107E4
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 16:17:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5C066B212FE
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 14:17:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 031511AE0AB;
	Thu, 20 Jun 2024 14:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GhF+OlzC"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806F21A8C1B;
	Thu, 20 Jun 2024 14:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718893037; cv=none; b=JjkoEY5ETcWBYil4S4aZRrFgTMRQ5bCUekeSgB+CN1avj6hGpNef2/Yb0I9yeZevzavdryvH4wbkFJRvJzuXNiFcT3k9RImhFgDHehHiGJK9CwZowR/2liof96d5x6qMCh0UfCUmQDMG8QrxbIeI1XRMk/r9rtVNWjqFRgM+hYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718893037; c=relaxed/simple;
	bh=RVUz8mlXmQC0CXO6BVM8VI+7nMFpEIwEnxJuTFoQ/9g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tUEWWWDXMsy9K0ux2VylTX6fEs2ascMXOJ9m3qeulywlzQZNZgcWG8fsNy/8vJSQ2KQKL0utfNX6yADi3tUJOgR1e5+1RKFobwRRIc7BVIpjeqw6cjMut8xyl3e3dnHDSK/zqVT4Nx8S+U4wg7Gc7zkn53UJ5L4PyfVPLciX3Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GhF+OlzC; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45KDwiix030807;
	Thu, 20 Jun 2024 14:17:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=pp1; bh=5GE5etBDeDiCUdFC6teWpl5AcU
	eyoidTGzdDP1rd7Fw=; b=GhF+OlzCRQONjjm0TW2NmaIClhTZUBGkOvruC6wA3a
	CabJpbG863zh/A27YXzQjM699LgbQc4STSG+FKTw/H82Po7pLIGPKQrJApqOIIjD
	79do40sxqbo2fujlrUdVVjKoVpHDBLUvARdychyNJS/ngRl/Pu9xob7XACD/sgvG
	2OLdCgjvIb+zybG5XsoSW39pZyIetEJSVA2Yrsj/JqdpiNxH5F1c0GilP0SBJmrq
	qjKx1oya7o+wId82v3wZhaaj93c1T3009WRbABbDNRajcz/kScRdpafX8vodJn/v
	RaSy3YaXViaZwu2k1JBvuLFHxdcIJ/cwNCFet7+hXxiw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yvnsb01wu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 14:17:09 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45KEH8X6031247;
	Thu, 20 Jun 2024 14:17:08 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yvnsb01wr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 14:17:08 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45KCtHbY009422;
	Thu, 20 Jun 2024 14:17:07 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3ysqgn6gek-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 14:17:07 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45KEH2Mv43319778
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 14:17:04 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4B2E320049;
	Thu, 20 Jun 2024 14:17:02 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0CD402004B;
	Thu, 20 Jun 2024 14:17:02 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 20 Jun 2024 14:17:01 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Thomas Huth <thuth@redhat.com>, Nicholas Piggin <npiggin@gmail.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        =?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 0/7] s390x: STFLE nested interpretation
Date: Thu, 20 Jun 2024 16:16:53 +0200
Message-Id: <20240620141700.4124157-1-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5iuV7ctdDbLeSAUnZKDVCwAJDayvwv_F
X-Proofpoint-ORIG-GUID: ioaK9nN5os5GZ1Ex4FmkjMlce-_PJSKt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-20_07,2024-06-20_04,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 phishscore=0 impostorscore=0 mlxscore=0 malwarescore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406200099

v2 -> v3:
 * pick up Ack (thanks Andrew)
 * minor cosmetic change to rand generator
 * add sie_is_pv function
 * extend sie_is_diag_icpt to support pv, replace pv_icptdata_check_diag

Add a test case that tests the interpretation of STFLE performed by a
nested guest using a snippet.
Also add some functionality to lib/, namely:
* pseudo random number generation (arch independent)
* exit (optionally with return code) from snippet (s390x)
* add function for checking diag intercepts, replacing
      pv_icptdata_check_diag (s390x)

v1 -> v2:
 * implement SHA-256 based PRNG
 * pick up R-b (thanks Claudio)
 * change snippet exit API and implementation (thanks Claudio)
 * add stfle-sie to unittests.cfg

Nina Schoetterl-Glausch (7):
  lib: Add pseudo random functions
  s390x: lib: Remove double include
  s390x: Add sie_is_pv
  s390x: Add function for checking diagnose intercepts
  s390x: Add library functions for exiting from snippet
  s390x: Use library functions for snippet exit
  s390x: Add test for STFLE interpretive execution (format-0)

 Makefile                                |   1 +
 s390x/Makefile                          |   3 +
 lib/s390x/asm/arch_def.h                |  13 ++
 lib/s390x/asm/facility.h                |  10 +-
 lib/rand.h                              |  21 +++
 lib/s390x/pv_icptdata.h                 |  42 ------
 lib/s390x/sie.h                         |  18 +++
 lib/s390x/snippet-guest.h               |  26 ++++
 lib/s390x/{snippet.h => snippet-host.h} |  10 +-
 lib/rand.c                              | 177 ++++++++++++++++++++++++
 lib/s390x/sie.c                         |  58 +++++++-
 lib/s390x/snippet-host.c                |  42 ++++++
 lib/s390x/uv.c                          |   2 +-
 s390x/mvpg-sie.c                        |   2 +-
 s390x/pv-diags.c                        |  10 +-
 s390x/pv-icptcode.c                     |  13 +-
 s390x/pv-ipl.c                          |   9 +-
 s390x/sie-dat.c                         |  13 +-
 s390x/snippets/c/sie-dat.c              |  19 +--
 s390x/snippets/c/stfle.c                |  26 ++++
 s390x/spec_ex-sie.c                     |   2 +-
 s390x/stfle-sie.c                       | 134 ++++++++++++++++++
 s390x/uv-host.c                         |   2 +-
 s390x/unittests.cfg                     |   3 +
 24 files changed, 558 insertions(+), 98 deletions(-)
 create mode 100644 lib/rand.h
 delete mode 100644 lib/s390x/pv_icptdata.h
 create mode 100644 lib/s390x/snippet-guest.h
 rename lib/s390x/{snippet.h => snippet-host.h} (92%)
 create mode 100644 lib/rand.c
 create mode 100644 lib/s390x/snippet-host.c
 create mode 100644 s390x/snippets/c/stfle.c
 create mode 100644 s390x/stfle-sie.c

Range-diff against v2:
1:  6c869961 ! 1:  baecabf2 lib: Add pseudo random functions
    @@ Commit message
                 for i in range(8):
                     yield int.from_bytes(state[i*4:(i+1)*4], byteorder="big")
     
    +    Acked-by: Andrew Jones <andrew.jones@linux.dev>
         Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
     
     
    @@ lib/rand.c (new)
     +	return rot(x, 17) ^ rot(x, 19) ^ (x >> 10);
     +}
     +
    -+enum alphabet { a, b, c, d, e, f, g, h, };
    ++enum alphabet { A, B, C, D, E, F, G, H, };
     +
     +static void sha256_chunk(const uint32_t (*chunk)[16], uint32_t (*hash)[8])
     +{
    @@ lib/rand.c (new)
     +	for (int i = 0; i < 64; i++) {
     +		uint32_t t1, t2;
     +
    -+		t1 = w_hash[h] +
    -+		     upper_sig1(w_hash[e]) +
    -+		     ch(w_hash[e], w_hash[f], w_hash[g]) +
    ++		t1 = w_hash[H] +
    ++		     upper_sig1(w_hash[E]) +
    ++		     ch(w_hash[E], w_hash[F], w_hash[G]) +
     +		     K[i] +
     +		     w[i];
     +
    -+		t2 = upper_sig0(w_hash[a]) + maj(w_hash[a], w_hash[b], w_hash[c]);
    ++		t2 = upper_sig0(w_hash[A]) + maj(w_hash[A], w_hash[B], w_hash[C]);
     +
    -+		w_hash[h] = w_hash[g];
    -+		w_hash[g] = w_hash[f];
    -+		w_hash[f] = w_hash[e];
    -+		w_hash[e] = w_hash[d] + t1;
    -+		w_hash[d] = w_hash[c];
    -+		w_hash[c] = w_hash[b];
    -+		w_hash[b] = w_hash[a];
    -+		w_hash[a] = t1 + t2;
    ++		w_hash[H] = w_hash[G];
    ++		w_hash[G] = w_hash[F];
    ++		w_hash[F] = w_hash[E];
    ++		w_hash[E] = w_hash[D] + t1;
    ++		w_hash[D] = w_hash[C];
    ++		w_hash[C] = w_hash[B];
    ++		w_hash[B] = w_hash[A];
    ++		w_hash[A] = t1 + t2;
     +	}
     +
     +	for (int i = 0; i < 8; i++)
2:  77319d3e = 2:  b30314eb s390x: lib: Remove double include
-:  -------- > 3:  f2af539b s390x: Add sie_is_pv
-:  -------- > 4:  c4331d19 s390x: Add function for checking diagnose intercepts
3:  e2c2cad8 ! 5:  a3f92777 s390x: Add library functions for exiting from snippet
    @@ lib/s390x/asm/arch_def.h: static inline uint32_t get_prefix(void)
     +
      #endif
     
    - ## lib/s390x/sie.h ##
    -@@ lib/s390x/sie.h: void sie_expect_validity(struct vm *vm);
    - uint16_t sie_get_validity(struct vm *vm);
    - void sie_check_validity(struct vm *vm, uint16_t vir_exp);
    - void sie_handle_validity(struct vm *vm);
    -+bool sie_is_diag_icpt(struct vm *vm, unsigned int diag);
    - void sie_guest_sca_create(struct vm *vm);
    - void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t guest_mem_len);
    - void sie_guest_destroy(struct vm *vm);
    -
      ## lib/s390x/snippet-guest.h (new) ##
     @@
     +/* SPDX-License-Identifier: GPL-2.0-only */
    @@ lib/s390x/snippet-guest.h (new)
     +	mb(); /* allow host to modify guest memory */
     +}
     +
    -+#endif
    ++#endif /* _S390X_SNIPPET_GUEST_H_ */
     
      ## lib/s390x/snippet.h => lib/s390x/snippet-host.h ##
     @@
    @@ lib/s390x/snippet-host.h: static inline void snippet_setup_guest(struct vm *vm,
     +void snippet_check_force_exit_value(struct vm *vm, uint64_t exit_exp);
      #endif
     
    - ## lib/s390x/sie.c ##
    -@@ lib/s390x/sie.c: void sie_check_validity(struct vm *vm, uint16_t vir_exp)
    - 	report(vir_exp == vir, "VALIDITY: %x", vir);
    - }
    - 
    -+bool sie_is_diag_icpt(struct vm *vm, unsigned int diag)
    -+{
    -+	union {
    -+		struct {
    -+			uint64_t     : 16;
    -+			uint64_t ipa : 16;
    -+			uint64_t ipb : 32;
    -+		};
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
    -+	uint64_t code;
    -+
    -+	assert(diag == 0x44 || diag == 0x9c);
    -+
    -+	if (vm->sblk->icptcode != ICPT_INST)
    -+		return false;
    -+	if (instr.opcode != 0x83 || instr.zero)
    -+		return false;
    -+	code = instr.r_base ? vm->save_area.guest.grs[instr.r_base] : 0;
    -+	code = (code + instr.displace) & 0xffff;
    -+	return code == diag;
    -+}
    -+
    - void sie_handle_validity(struct vm *vm)
    - {
    - 	if (vm->sblk->icptcode != ICPT_VALIDITY)
    -
      ## lib/s390x/snippet-host.c (new) ##
     @@
     +/* SPDX-License-Identifier: GPL-2.0-only */
    @@ s390x/pv-diags.c
      #include <libcflat.h>
     -#include <snippet.h>
     +#include <snippet-host.h>
    - #include <pv_icptdata.h>
      #include <sie.h>
      #include <sclp.h>
    + #include <asm/facility.h>
     
      ## s390x/pv-icptcode.c ##
     @@
    @@ s390x/pv-icptcode.c
      #include <sclp.h>
     -#include <snippet.h>
     +#include <snippet-host.h>
    - #include <pv_icptdata.h>
      #include <asm/facility.h>
      #include <asm/barrier.h>
    + #include <asm/sigp.h>
     
      ## s390x/pv-ipl.c ##
     @@
    @@ s390x/pv-ipl.c
      #include <sclp.h>
     -#include <snippet.h>
     +#include <snippet-host.h>
    - #include <pv_icptdata.h>
      #include <asm/facility.h>
      #include <asm/uv.h>
    + 
     
      ## s390x/sie-dat.c ##
     @@
4:  67fbf0bb ! 6:  a1db588b s390x: Use library functions for snippet exit
    @@ s390x/sie-dat.c: static void test_sie_dat(void)
     
      ## s390x/snippets/c/sie-dat.c ##
     @@
    -  */
      #include <libcflat.h>
      #include <asm-generic/page.h>
    + #include <asm/mem.h>
     +#include <snippet-guest.h>
      #include "sie-dat.h"
      
5:  157079f2 ! 7:  0b89b3c6 s390x: Add test for STFLE interpretive execution (format-0)
    @@ s390x/stfle-sie.c (new)
     +}
     
      ## s390x/unittests.cfg ##
    -@@ s390x/unittests.cfg: extra_params = """-cpu max,ctop=on -smp cpus=1,drawers=2,books=2,sockets=2,cores
    +@@ s390x/unittests.cfg: file = sie-dat.elf
      
    - [sie-dat]
    - file = sie-dat.elf
    + [pv-attest]
    + file = pv-attest.elf
     +
     +[stfle-sie]
     +file = stfle-sie.elf

base-commit: 28ac3b10d6f982b1d9c2fe629f23d23ec5024b4f
-- 
2.44.0


