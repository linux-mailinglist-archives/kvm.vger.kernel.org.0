Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 937386D5B44
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 10:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233979AbjDDIzN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 04:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233534AbjDDIzL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 04:55:11 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B669E1735;
        Tue,  4 Apr 2023 01:55:10 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3347NkwP009124;
        Tue, 4 Apr 2023 08:55:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=gUJD+S/jFfJKloU+JH38tyHBG5U+w/oG6H/BTu9Au0s=;
 b=houDihF8yUabVkGbVTieHZlvgelMnBZEDkdKqCygS8BTBqlLoGda9/9LZJfh9U8lf1Oj
 bHnGvF+Nh1azSuDSavuF6yPsgIxVPtkMZqJ7wOOFeU5vSal1MdTQOhx8n8g/MX6LbxqC
 bzoaT9LjtwLSOz5BAOCMgC0TMbvw4+eQ2Uj1rFsBdX4LNArXyL7tkA4DxBeMEyv+RAcU
 JvxroZLMyY/WZXHDC8lmvOx5B+FfrJCj4jcNkd6L7NuzH97FF22HlwOepUnuAz3rTaOi
 vP8F4txu4Z3rC9/UUkY8HCSe9+V7SO3DNZ6WQ2RMZlzVsGcey/rao3bFftqB5NfsQxzl HQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pqv581pbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 08:55:10 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3347NwtL010947;
        Tue, 4 Apr 2023 08:55:09 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pqv581pav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 08:55:09 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3342KaC0007870;
        Tue, 4 Apr 2023 08:55:07 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3ppc86ssht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 08:55:07 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3348t2CZ44630500
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Apr 2023 08:55:02 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B26CF2004F;
        Tue,  4 Apr 2023 08:55:02 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68C2520043;
        Tue,  4 Apr 2023 08:55:02 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  4 Apr 2023 08:55:02 +0000 (GMT)
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v5 0/3] s390x: Add misaligned instruction tests
Date:   Tue,  4 Apr 2023 10:54:50 +0200
Message-Id: <20230404085454.2709061-1-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qK2Xrk0_LEla0BPy7F1sKkKDvzJB9oUO
X-Proofpoint-GUID: WeTe1xEP8pHD6GPxCS4IvqJ1_0QJ_ou2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_02,2023-04-03_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0
 phishscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 clxscore=1015
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304040074
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instructions on s390 must be halfword aligned.
Add two tests for that.

v4 -> v5:
 * fix miscompile due to missing barrier (thanks Thomas & Janosch)
 * fix issues with clang (thanks Thomas)

v3 -> v4:
 * zero whole register with xgr (thanks Janosch)
 * pick up tags (thanks Janosch)

v2 -> v3:
 * pick up R-b (thanks Janosch)
 * use br instead of bcr (thanks Claudio)
 * use text section instead of rodata for ex target (thanks Claudio)
 * fix label position (thanks Claudio)

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

Range-diff against v4:
1:  c00f8aa2 = 1:  cdfa2083 s390x/spec_ex: Use PSW macro
2:  d9e3f6e0 ! 2:  5bf32702 s390x/spec_ex: Add test introducing odd address into PSW
    @@ s390x/spec_ex.c: static int psw_bit_12_is_1(void)
      	return check_invalid_psw();
      }
      
    -+extern char misaligned_code[];
    ++extern char misaligned_code_pre[];
     +asm (  ".balign	2\n"
    ++"misaligned_code_pre:\n"
     +"	. = . + 1\n"
    -+"misaligned_code:\n"
     +"	larl	%r0,0\n"
     +"	br	%r1\n"
     +);
     +
     +static int psw_odd_address(void)
     +{
    -+	struct psw odd = PSW_WITH_CUR_MASK((uint64_t)&misaligned_code);
    ++	struct psw odd = PSW_WITH_CUR_MASK(((uint64_t)&misaligned_code_pre) + 1);
     +	uint64_t executed_addr;
     +
     +	expect_invalid_psw(odd);
    @@ s390x/spec_ex.c: static int psw_bit_12_is_1(void)
     +	: [fixup_addr] "=&T" (fixup_psw.addr),
     +	  [executed_addr] "=d" (executed_addr)
     +	: [odd_psw] "Q" (odd)
    -+	: "cc", "%r0", "%r1"
    ++	: "cc", "%r0", "%r1", "memory" /* Compiler barrier like in load_psw */
     +	);
     +
     +	if (!executed_addr) {
3:  7ea75611 ! 3:  14af5979 s390x/spec_ex: Add test of EXECUTE with odd target address
    @@ s390x/spec_ex.c: static int short_psw_bit_12_is_0(void)
     +
     +	asm volatile ( ".pushsection .text.ex_odd\n"
     +		"	.balign	2\n"
    -+		"pre_odd_ex_target:\n"
    ++		"pre_odd_ex_target%=:\n"
     +		"	. = . + 1\n"
     +		"	lr	%[to],%[from]\n"
     +		"	.popsection\n"
     +
    -+		"	larl	%[pre_target_addr],pre_odd_ex_target\n"
    ++		"	larl	%[pre_target_addr],pre_odd_ex_target%=\n"
     +		"	ex	0,1(%[pre_target_addr])\n"
     +		: [pre_target_addr] "=&a" (pre_target_addr),
     +		  [to] "+d" (to)

base-commit: 5b5d27da2973b20ec29b18df4d749fb2190458af
-- 
2.37.2

