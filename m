Return-Path: <kvm+bounces-5757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25AEA825CA8
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 23:55:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B06B0281983
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 22:55:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7D24364C3;
	Fri,  5 Jan 2024 22:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="I3bKGm8F"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C043609D;
	Fri,  5 Jan 2024 22:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 405MpP3c010378;
	Fri, 5 Jan 2024 22:54:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=3UVybIIU0FfG48CSC4M3W6m2UbiLow30HV/R/zvRJuI=;
 b=I3bKGm8F8C+BNzv50QkWT4/T7rLn8NQhxXexpTmhLt2nlwVRWsUfhgx36ZcKVp8sAPjq
 wUI6NNiGLbkG64mo10TP+uGe4WO+I0JOjSmpCqRK94xjl7kr4cQD+EosxeLGVPCwC/KB
 dejwl0a6rPEkjX3vmgLM1hhat02qsLyLkiLdeL1+FlKxjq4bAAfyt/0jEjcId87JhtrN
 Nwv8eSid1M1jyd6aHa3xyKOiopshTeHkUeWViAOXx0hczPpN1BcxguEp4Ra+EQa1wCus
 z8fH5RmwYZky0Sl4G3LVKACGee3+MN1mjBS97GbSVzYjYyLEnt/deshT2Pew6A1FkHdN 5Q== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vervxaktd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Jan 2024 22:54:27 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 405MmHwI003957;
	Fri, 5 Jan 2024 22:54:27 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vervxakt3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Jan 2024 22:54:26 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 405MQQIC019309;
	Fri, 5 Jan 2024 22:54:25 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vc30t1hrx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Jan 2024 22:54:25 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 405MsMjD15794748
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 5 Jan 2024 22:54:22 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6571820043;
	Fri,  5 Jan 2024 22:54:22 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1EA6B20040;
	Fri,  5 Jan 2024 22:54:22 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  5 Jan 2024 22:54:22 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, Janosch Frank <frankja@linux.ibm.com>,
        Andrew Jones <andrew.jones@linux.dev>, Nico Boehr <nrb@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PATCH v2 0/5] s390x: STFLE nested interpretation
Date: Fri,  5 Jan 2024 23:54:14 +0100
Message-Id: <20240105225419.2841310-1-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: v4Shz_keuOHjj7AMgQHJj8z0sFlzbeBp
X-Proofpoint-GUID: Oi47-oBHUS8qIeUOFQIHXEowA0mTRmFr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-05_08,2024-01-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401050176

v1 -> v2 (range-diff below):
 * implement SHA-256 based PRNG
 * pick up R-b (thanks Claudio)
 * change snippet exit API and implementation (thanks Claudio)
 * add stfle-sie to unittests.cfg

Add a test case that tests the interpretation of STFLE performed by a
nested guest using a snippet.
Also add some functionality to lib/, namely:
* pseudo random number generation (arch independent)
* exit (optionally with return code) from snippet (s390x)

Nina Schoetterl-Glausch (5):
  lib: Add pseudo random functions
  s390x: lib: Remove double include
  s390x: Add library functions for exiting from snippet
  s390x: Use library functions for snippet exit
  s390x: Add test for STFLE interpretive execution (format-0)

 Makefile                                |   1 +
 s390x/Makefile                          |   3 +
 lib/s390x/asm/arch_def.h                |  13 ++
 lib/s390x/asm/facility.h                |  10 +-
 lib/rand.h                              |  21 +++
 lib/s390x/sie.h                         |   1 +
 lib/s390x/snippet-guest.h               |  26 ++++
 lib/s390x/{snippet.h => snippet-host.h} |  10 +-
 lib/rand.c                              | 177 ++++++++++++++++++++++++
 lib/s390x/sie.c                         |  32 ++++-
 lib/s390x/snippet-host.c                |  42 ++++++
 lib/s390x/uv.c                          |   2 +-
 s390x/mvpg-sie.c                        |   2 +-
 s390x/pv-diags.c                        |   2 +-
 s390x/pv-icptcode.c                     |   2 +-
 s390x/pv-ipl.c                          |   2 +-
 s390x/sie-dat.c                         |  13 +-
 s390x/snippets/c/sie-dat.c              |  19 +--
 s390x/snippets/c/stfle.c                |  26 ++++
 s390x/spec_ex-sie.c                     |   2 +-
 s390x/stfle-sie.c                       | 134 ++++++++++++++++++
 s390x/uv-host.c                         |   2 +-
 s390x/unittests.cfg                     |   3 +
 23 files changed, 506 insertions(+), 39 deletions(-)
 create mode 100644 lib/rand.h
 create mode 100644 lib/s390x/snippet-guest.h
 rename lib/s390x/{snippet.h => snippet-host.h} (92%)
 create mode 100644 lib/rand.c
 create mode 100644 lib/s390x/snippet-host.c
 create mode 100644 s390x/snippets/c/stfle.c
 create mode 100644 s390x/stfle-sie.c

Range-diff against v1:
1:  40d815f3 < -:  -------- lib: Add pseudo random functions
-:  -------- > 1:  6c869961 lib: Add pseudo random functions
2:  f5284941 ! 2:  77319d3e s390x: lib: Remove double include
    @@ Commit message
     
         libcflat.h was included twice.
     
    +    Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
         Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
     
      ## lib/s390x/sie.c ##
3:  303cf927 ! 3:  e2c2cad8 s390x: Add library functions for exiting from snippet
    @@ Commit message
         Add this functionality, also add helper functions for the host to check
         for an exit and get or check the value.
         Use diag 0x44 and 0x9c for this.
    -    Add a guest specific snippet header file and rename the host's.
    +    Add a guest specific snippet header file and rename snippet.h to reflect
    +    that it is host specific.
     
         Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
     
    @@ lib/s390x/snippet-host.h: static inline void snippet_setup_guest(struct vm *vm,
      	}
      }
      
    -+bool snippet_check_force_exit(struct vm *vm);
    -+bool snippet_get_force_exit_value(struct vm *vm, uint64_t *value);
    ++bool snippet_is_force_exit(struct vm *vm);
    ++bool snippet_is_force_exit_value(struct vm *vm);
    ++uint64_t snippet_get_force_exit_value(struct vm *vm);
     +void snippet_check_force_exit_value(struct vm *vm, uint64_t exit_exp);
      #endif
     
    @@ lib/s390x/sie.c: void sie_check_validity(struct vm *vm, uint16_t vir_exp)
      
     +bool sie_is_diag_icpt(struct vm *vm, unsigned int diag)
     +{
    -+	uint32_t ipb = vm->sblk->ipb;
    ++	union {
    ++		struct {
    ++			uint64_t     : 16;
    ++			uint64_t ipa : 16;
    ++			uint64_t ipb : 32;
    ++		};
    ++		struct {
    ++			uint64_t          : 16;
    ++			uint64_t opcode   :  8;
    ++			uint64_t r_1      :  4;
    ++			uint64_t r_2      :  4;
    ++			uint64_t r_base   :  4;
    ++			uint64_t displace : 12;
    ++			uint64_t zero     : 16;
    ++		};
    ++	} instr = { .ipa = vm->sblk->ipa, .ipb = vm->sblk->ipb };
     +	uint64_t code;
    -+	uint16_t displace;
    -+	uint8_t base;
    -+	bool ret = true;
     +
    -+	ret = ret && vm->sblk->icptcode == ICPT_INST;
    -+	ret = ret && (vm->sblk->ipa & 0xff00) == 0x8300;
    -+	switch (diag) {
    -+	case 0x44:
    -+	case 0x9c:
    -+		ret = ret && !(ipb & 0xffff);
    -+		ipb >>= 16;
    -+		displace = ipb & 0xfff;
    -+		ipb >>= 12;
    -+		base = ipb & 0xf;
    -+		code = base ? vm->save_area.guest.grs[base] + displace : displace;
    -+		code &= 0xffff;
    -+		ret = ret && (code == diag);
    -+		break;
    -+	default:
    -+		abort(); /* not implemented */
    -+	}
    -+	return ret;
    ++	assert(diag == 0x44 || diag == 0x9c);
    ++
    ++	if (vm->sblk->icptcode != ICPT_INST)
    ++		return false;
    ++	if (instr.opcode != 0x83 || instr.zero)
    ++		return false;
    ++	code = instr.r_base ? vm->save_area.guest.grs[instr.r_base] : 0;
    ++	code = (code + instr.displace) & 0xffff;
    ++	return code == diag;
     +}
     +
      void sie_handle_validity(struct vm *vm)
    @@ lib/s390x/snippet-host.c (new)
     +#include <snippet-host.h>
     +#include <sie.h>
     +
    -+bool snippet_check_force_exit(struct vm *vm)
    ++bool snippet_is_force_exit(struct vm *vm)
     +{
    -+	bool r;
    ++	return sie_is_diag_icpt(vm, 0x44);
    ++}
     +
    -+	r = sie_is_diag_icpt(vm, 0x44);
    -+	report(r, "guest forced exit");
    -+	return r;
    ++bool snippet_is_force_exit_value(struct vm *vm)
    ++{
    ++	return sie_is_diag_icpt(vm, 0x9c);
     +}
     +
    -+bool snippet_get_force_exit_value(struct vm *vm, uint64_t *value)
    ++uint64_t snippet_get_force_exit_value(struct vm *vm)
     +{
     +	struct kvm_s390_sie_block *sblk = vm->sblk;
     +
    -+	if (sie_is_diag_icpt(vm, 0x9c)) {
    -+		*value = vm->save_area.guest.grs[(sblk->ipa & 0xf0) >> 4];
    -+		report_pass("guest forced exit with value: 0x%lx", *value);
    -+		return true;
    -+	}
    -+	report_fail("guest forced exit with value");
    -+	return false;
    ++	assert(snippet_is_force_exit_value(vm));
    ++
    ++	return vm->save_area.guest.grs[(sblk->ipa & 0xf0) >> 4];
     +}
     +
     +void snippet_check_force_exit_value(struct vm *vm, uint64_t value_exp)
     +{
     +	uint64_t value;
     +
    -+	if (snippet_get_force_exit_value(vm, &value))
    -+		report(value == value_exp, "guest exit value matches 0x%lx", value_exp);
    ++	if (snippet_is_force_exit_value(vm)) {
    ++		value = snippet_get_force_exit_value(vm);
    ++		report(value == value_exp, "guest forced exit with value (0x%lx == 0x%lx)",
    ++		       value, value_exp);
    ++	} else {
    ++		report_fail("guest forced exit with value");
    ++	}
     +}
     
      ## lib/s390x/uv.c ##
4:  efe8449a ! 4:  67fbf0bb s390x: Use library functions for snippet exit
    @@ s390x/sie-dat.c: static void test_sie_dat(void)
     -
     -	r1 = (vm.sblk->ipa & 0xf0) >> 4;
     -	test_page_gpa = vm.save_area.guest.grs[r1];
    -+	assert(snippet_get_force_exit_value(&vm, &test_page_gpa));
    ++	assert(snippet_is_force_exit_value(&vm));
    ++	test_page_gpa = snippet_get_force_exit_value(&vm);
      	test_page_hpa = virt_to_pte_phys(guest_root, (void*)test_page_gpa);
      	test_page_hva = __va(test_page_hpa);
      	report_info("test buffer gpa=0x%lx hva=%p", test_page_gpa, test_page_hva);
    @@ s390x/sie-dat.c: static void test_sie_dat(void)
      	sie(&vm);
     -	assert(vm.sblk->icptcode == ICPT_INST &&
     -	       vm.sblk->ipa == 0x8300 && vm.sblk->ipb == 0x440000);
    -+	assert(snippet_check_force_exit(&vm));
    ++	assert(snippet_is_force_exit(&vm));
      
      	contents_match = true;
      	for (unsigned int i = 0; i < GUEST_TEST_PAGE_COUNT; i++) {
5:  f0eaac68 ! 5:  157079f2 s390x: Add test for STFLE interpretive execution (format-0)
    @@ s390x/stfle-sie.c (new)
     +#include <snippet-host.h>
     +#include <alloc_page.h>
     +#include <sclp.h>
    ++#include <rand.h>
     +
     +static struct vm vm;
     +static uint64_t (*fac)[PAGE_SIZE / sizeof(uint64_t)];
    -+static rand_state rand_s;
    ++static prng_state prng_s;
     +
     +static void setup_guest(void)
     +{
    @@ s390x/stfle-sie.c (new)
     +	uint64_t guest_stfle_addr;
     +
     +	sie(&vm);
    -+	assert(snippet_get_force_exit_value(&vm, &guest_stfle_addr));
    ++	assert(snippet_is_force_exit_value(&vm));
    ++	guest_stfle_addr = snippet_get_force_exit_value(&vm);
     +	res.mem = &vm.guest_mem[guest_stfle_addr];
     +	memcpy(&res.reg, res.mem, sizeof(res.reg));
     +	res.len = (res.reg & 0xff) + 1;
    @@ s390x/stfle-sie.c (new)
     +
     +	report_prefix_push("format-0");
     +	for (int j = 0; j < stfle_size(); j++)
    -+		WRITE_ONCE((*fac)[j], rand64(&rand_s));
    ++		WRITE_ONCE((*fac)[j], prng64(&prng_s));
     +	vm.sblk->fac = (uint32_t)(uint64_t)fac;
     +	res = run_guest();
     +	report(res.len == stfle_size(), "stfle len correct");
    @@ s390x/stfle-sie.c (new)
     +		goto out;
     +	}
     +
    -+	report_info("pseudo rand seed: 0x%lx", args.seed);
    -+	rand_s = RAND_STATE_INIT(args.seed);
    ++	report_info("PRNG seed: 0x%lx", args.seed);
    ++	prng_s = prng_init(args.seed);
     +	setup_guest();
     +	if (test_facility(7))
     +		test_stfle_format_0();
     +out:
     +	return report_summary();
     +}
    +
    + ## s390x/unittests.cfg ##
    +@@ s390x/unittests.cfg: extra_params = """-cpu max,ctop=on -smp cpus=1,drawers=2,books=2,sockets=2,cores
    + 
    + [sie-dat]
    + file = sie-dat.elf
    ++
    ++[stfle-sie]
    ++file = stfle-sie.elf

base-commit: 3c1736b1344b9831f17fbd64f95ea89c279564c6
-- 
2.43.0


