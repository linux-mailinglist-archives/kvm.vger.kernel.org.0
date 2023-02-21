Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D05F69E654
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 18:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234743AbjBURvA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 12:51:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234762AbjBURu6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 12:50:58 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4DF2ED6B;
        Tue, 21 Feb 2023 09:50:49 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31LHmNqR027825;
        Tue, 21 Feb 2023 17:50:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=QVSQkG2IvU8uhJISu5edOcszlsa8QDX0sl9Smaxy4uQ=;
 b=J+1TWYCVvsK5703S6FgojLzXqd7QHAN5SAwW6+7c+Kil0T6XQyhM4BtEyiEk1OvRZSn3
 s9+gORbnBIhOzvKdB+ar43kP58ztceVRmA+qnYhM6RTyRC5nifH94Bgyo4NcJ59m7Pcs
 L+wZ17Nx9NdWwYA6lgTqZxfYNrfPiXyOB8aXbfpYTueLGF5568FNHyHW01vJaBfQlLUw
 wkTO95ujXI6VoQAgOO+R8UGkOdShaBnBejBlgyl5QJP7uCcbksrpfaDsVgrLT0HoCPn/
 JVw73xPuXgs/7Ql6qPlItwkWVD4okn2P0MV0XIOZTfpeq1GoVbbduHFUTeY9xwhmC88H kQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nw29f0m16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 17:50:48 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31LHomUs006236;
        Tue, 21 Feb 2023 17:50:48 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nw29f0m0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 17:50:48 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31L8QCe9016582;
        Tue, 21 Feb 2023 17:50:45 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3ntpa6cb0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 17:50:45 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31LHogxa37814612
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Feb 2023 17:50:42 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 120112004D;
        Tue, 21 Feb 2023 17:50:42 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD6E820040;
        Tue, 21 Feb 2023 17:50:41 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.152.224.238])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 21 Feb 2023 17:50:41 +0000 (GMT)
Message-ID: <0a9740faae7f375248c60ff5b0753cadc9ed0348.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 1/3] s390x/spec_ex: Use PSW macro
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Tue, 21 Feb 2023 18:50:41 +0100
In-Reply-To: <20230221174822.1378667-2-nsg@linux.ibm.com>
References: <20230221174822.1378667-1-nsg@linux.ibm.com>
         <20230221174822.1378667-2-nsg@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xWX5mDz9a4J54Pk86xeTntPXQktTXhN2
X-Proofpoint-ORIG-GUID: _cagxmTg-RIJ6fg14VviXuopzQ61ea-o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-21_10,2023-02-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 suspectscore=0 spamscore=0 clxscore=1015 adultscore=0 mlxlogscore=999
 impostorscore=0 priorityscore=1501 malwarescore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302210148
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Messed up the recipients on the cover letter...


Instructions on s390 must be halfword aligned.
Add two tests for that.
These currently fail when using TCG.

v1 -> v2:
 * rebase
 * use PSW macros
 * simplify odd psw test (thanks Claudio)
 * rename some identifiers
 * pick up R-b (thanks Claudio)

Nina Schoetterl-Glausch (3):
  s390x/spec_ex: Use PSW macro
  s390x/spec_ex: Add test introducing odd address into PSW
  s390x/spec_ex: Add test of EXECUTE with odd target address

 s390x/spec_ex.c | 85 +++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 76 insertions(+), 9 deletions(-)

Range-diff against v1:
-:  -------- > 1:  d82f4fb6 s390x/spec_ex: Use PSW macro
1:  62f61c07 ! 2:  e537797f s390x/spec_ex: Add test introducing odd address=
 into PSW
    @@ Commit message
         Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
    =20
      ## s390x/spec_ex.c ##
    -@@ s390x/spec_ex.c: static void fixup_invalid_psw(struct stack_frame_i=
nt *stack)
    - /*
    -  * Load possibly invalid psw, but setup fixup_psw before,
    -  * so that fixup_invalid_psw() can bring us back onto the right track=
.
    -+ * The provided argument is loaded into register 1.
    -  * Also acts as compiler barrier, -> none required in expect/check_in=
valid_psw
    -  */
    --static void load_psw(struct psw psw)
    -+static void load_psw_with_arg(struct psw psw, uint64_t arg)
    - {
    - 	uint64_t scratch;
    -=20
    -@@ s390x/spec_ex.c: static void load_psw(struct psw psw)
    - 	fixup_psw.mask =3D extract_psw_mask();
    - 	asm volatile ( "larl	%[scratch],0f\n"
    - 		"	stg	%[scratch],%[fixup_addr]\n"
    -+		"	lgr	%%r1,%[arg]\n"
    - 		"	lpswe	%[psw]\n"
    - 		"0:	nop\n"
    - 		: [scratch] "=3D&d" (scratch),
    - 		  [fixup_addr] "=3D&T" (fixup_psw.addr)
    --		: [psw] "Q" (psw)
    --		: "cc", "memory"
    -+		: [psw] "Q" (psw),
    -+		  [arg] "d" (arg)
    -+		: "cc", "memory", "%r1"
    - 	);
    - }
    -=20
    -+static void load_psw(struct psw psw)
    -+{
    -+	load_psw_with_arg(psw, 0);
    -+}
    -+
    - static void load_short_psw(struct short_psw psw)
    - {
    - 	uint64_t scratch;
     @@ s390x/spec_ex.c: static void expect_invalid_psw(struct psw psw)
      	invalid_psw_expected =3D true;
      }
     =20
     +static void clear_invalid_psw(void)
     +{
    -+	expected_psw =3D (struct psw){0};
    ++	expected_psw =3D PSW(0, 0);
     +	invalid_psw_expected =3D false;
     +}
     +
    @@ s390x/spec_ex.c: static void expect_invalid_psw(struct psw psw)
      {
      	/* Since the fixup sets this to false we check for false here. */
      	if (!invalid_psw_expected) {
    ++		/*
    ++		 * Early exception recognition: pgm_int_id =3D=3D 0.
    ++		 * Late exception recognition: psw address has been
    ++		 *	incremented by pgm_int_id (unpredictable value)
    ++		 */
      		if (expected_psw.mask =3D=3D invalid_psw.mask &&
     -		    expected_psw.addr =3D=3D invalid_psw.addr)
     +		    expected_psw.addr =3D=3D invalid_psw.addr - lowcore.pgm_int_id)
    @@ s390x/spec_ex.c: static int psw_bit_12_is_1(void)
      	return check_invalid_psw();
      }
     =20
    ++extern char misaligned_code[];
    ++asm (  ".balign	2\n"
    ++"	. =3D . + 1\n"
    ++"misaligned_code:\n"
    ++"	larl	%r0,0\n"
    ++"	bcr	0xf,%r1\n"
    ++);
    ++
     +static int psw_odd_address(void)
     +{
    -+	struct psw odd =3D {
    -+		.mask =3D extract_psw_mask(),
    -+	};
    -+	uint64_t regs[16];
    -+	int r;
    ++	struct psw odd =3D PSW_WITH_CUR_MASK((uint64_t)&misaligned_code);
    ++	uint64_t executed_addr;
     +
    -+	/*
    -+	 * This asm is reentered at an odd address, which should cause a spe=
cification
    -+	 * exception before the first unaligned instruction is executed.
    -+	 * In this case, the interrupt handler fixes the address and the tes=
t succeeds.
    -+	 * If, however, unaligned instructions *are* executed, they are jump=
ed to
    -+	 * from somewhere, with unknown registers, so save and restore those=
 before.
    -+	 */
    -+	asm volatile ( "stmg	%%r0,%%r15,%[regs]\n"
    -+		//can only offset by even number when using larl -> increment by on=
e
    -+		"	larl	%[r],0f\n"
    -+		"	aghi	%[r],1\n"
    -+		"	stg	%[r],%[addr]\n"
    -+		"	xr	%[r],%[r]\n"
    -+		"	brc	0xf,1f\n"
    -+		"0:	. =3D . + 1\n"
    -+		"	lmg	%%r0,%%r15,0(%%r1)\n"
    -+		//address of the instruction itself, should be odd, store for asser=
t
    -+		"	larl	%[r],0\n"
    -+		"	stg	%[r],%[addr]\n"
    -+		"	larl	%[r],0f\n"
    -+		"	aghi	%[r],1\n"
    -+		"	bcr	0xf,%[r]\n"
    -+		"0:	. =3D . + 1\n"
    -+		"1:\n"
    -+	: [addr] "=3DT" (odd.addr),
    -+	  [regs] "=3DQ" (regs),
    -+	  [r] "=3Dd" (r)
    -+	: : "cc", "memory"
    ++	expect_invalid_psw(odd);
    ++	fixup_psw.mask =3D extract_psw_mask();
    ++	asm volatile ( "xr	%%r0,%%r0\n"
    ++		"	larl	%%r1,0f\n"
    ++		"	stg	%%r1,%[fixup_addr]\n"
    ++		"	lpswe	%[odd_psw]\n"
    ++		"0:	lr	%[executed_addr],%%r0\n"
    ++	: [fixup_addr] "=3D&T" (fixup_psw.addr),
    ++	  [executed_addr] "=3Dd" (executed_addr)
    ++	: [odd_psw] "Q" (odd)
    ++	: "cc", "%r0", "%r1"
     +	);
     +
    -+	if (!r) {
    -+		expect_invalid_psw(odd);
    -+		load_psw_with_arg(odd, (uint64_t)&regs);
    ++	if (!executed_addr) {
     +		return check_invalid_psw();
     +	} else {
    -+		assert(odd.addr & 1);
    ++		assert(executed_addr =3D=3D odd.addr);
     +		clear_invalid_psw();
    -+		report_fail("executed unaligned instructions");
    ++		report_fail("did not execute unaligned instructions");
     +		return 1;
     +	}
     +}
2:  30075863 ! 3:  dc552880 s390x/spec_ex: Add test of EXECUTE with odd tar=
get address
    @@ s390x/spec_ex.c: static int short_psw_bit_12_is_0(void)
     =20
     +static int odd_ex_target(void)
     +{
    -+	uint64_t target_addr_pre;
    ++	uint64_t pre_target_addr;
     +	int to =3D 0, from =3D 0x0dd;
     +
     +	asm volatile ( ".pushsection .rodata\n"
    -+		"odd_ex_target_pre_insn:\n"
    -+		"	.balign 2\n"
    ++		"pre_odd_ex_target:\n"
    ++		"	.balign	2\n"
     +		"	. =3D . + 1\n"
     +		"	lr	%[to],%[from]\n"
     +		"	.popsection\n"
     +
    -+		"	larl	%[target_addr_pre],odd_ex_target_pre_insn\n"
    -+		"	ex	0,1(%[target_addr_pre])\n"
    -+		: [target_addr_pre] "=3D&a" (target_addr_pre),
    ++		"	larl	%[pre_target_addr],pre_odd_ex_target\n"
    ++		"	ex	0,1(%[pre_target_addr])\n"
    ++		: [pre_target_addr] "=3D&a" (pre_target_addr),
     +		  [to] "+d" (to)
     +		: [from] "d" (from)
     +	);
     +
    -+	assert((target_addr_pre + 1) & 1);
    ++	assert((pre_target_addr + 1) & 1);
     +	report(to !=3D from, "did not perform ex with odd target");
     +	return 0;
     +}

base-commit: e3c5c3ef2524c58023073c0fadde2e8ae3c04ec6
--=20
2.36.1

