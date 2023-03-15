Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D03B6BB8B6
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 16:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbjCOP4l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 11:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232693AbjCOP4c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 11:56:32 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37CBF1E2A2;
        Wed, 15 Mar 2023 08:55:52 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32FELRFA014979;
        Wed, 15 Mar 2023 15:54:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=m7eMhkPTzO+FbF0Ri57YweWw90fZ5qOrmev7e+6bwcI=;
 b=Km2Ba3UDIvm1tqr6Y3NwHc0T/K8udjhJvXd78YJ14AS62nnJXzA2jFS2pE3LyC7APTbb
 z3i5Xx4tB5FQatsaQ9JX7UD7vP4UdIYCRUBedwFUj6ykme/t2dR9oULxH+v+3e5POOKd
 AMudMUlM8mRuCK+cQBwBf8lMN3rvodEuj5EZMBrbzjJEr3DuoTMCiizWg4HLd4wBdnYh
 gUQWTqrHKi7vkpfBJNov+QmyWi3t2aDPPpqAoSW+IwRyXZjABOoChiL5SMTZFzWAoF0G
 1p7puI+ZtU2ZDkEnS+sYoTlNZUoHrMFH039Ei0jmDzYmbdTRvNX3eLxsSuW8/1aIIzYQ DQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pbfq8tuh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 15:54:52 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32FELjYY015866;
        Wed, 15 Mar 2023 15:54:52 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pbfq8tufx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 15:54:52 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32FDxPsU021703;
        Wed, 15 Mar 2023 15:54:50 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3pb29ss0d1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 15:54:50 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32FFsk8l22282850
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 15:54:46 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 967FE20049;
        Wed, 15 Mar 2023 15:54:46 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6024520043;
        Wed, 15 Mar 2023 15:54:46 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 15 Mar 2023 15:54:46 +0000 (GMT)
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 0/3] s390x: Add misaligned instruction tests
Date:   Wed, 15 Mar 2023 16:54:41 +0100
Message-Id: <20230315155445.1688249-1-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lC2eSSFQbhbRFNQENaEsdtNELXr1670S
X-Proofpoint-GUID: QGlTqbpeZVN0jfflDSco4SsvbnSnZo19
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-15_08,2023-03-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 adultscore=0 clxscore=1015 impostorscore=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2302240000 definitions=main-2303150131
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instructions on s390 must be halfword aligned.
Add two tests for that.
These currently fail when using TCG.

v3 -> v2:
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

Range-diff against v2:
1:  d82f4fb6 ! 1:  6ae1eb7d s390x/spec_ex: Use PSW macro
    @@ Commit message
         Replace explicit psw definition by PSW macro.
         No functional change intended.
     
    +    Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
         Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
     
      ## s390x/spec_ex.c ##
2:  e537797f ! 2:  a0d02438 s390x/spec_ex: Add test introducing odd address into PSW
    @@ s390x/spec_ex.c: static int psw_bit_12_is_1(void)
     +"	. = . + 1\n"
     +"misaligned_code:\n"
     +"	larl	%r0,0\n"
    -+"	bcr	0xf,%r1\n"
    ++"	br	%r1\n"
     +);
     +
     +static int psw_odd_address(void)
3:  dc552880 ! 3:  e771deeb s390x/spec_ex: Add test of EXECUTE with odd target address
    @@ s390x/spec_ex.c: static int short_psw_bit_12_is_0(void)
     +	uint64_t pre_target_addr;
     +	int to = 0, from = 0x0dd;
     +
    -+	asm volatile ( ".pushsection .rodata\n"
    -+		"pre_odd_ex_target:\n"
    ++	asm volatile ( ".pushsection .text.ex_odd\n"
     +		"	.balign	2\n"
    ++		"pre_odd_ex_target:\n"
     +		"	. = . + 1\n"
     +		"	lr	%[to],%[from]\n"
     +		"	.popsection\n"

base-commit: e3c5c3ef2524c58023073c0fadde2e8ae3c04ec6
-- 
2.39.1

