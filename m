Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3A806BEA1A
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 14:33:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbjCQNdI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 09:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjCQNdH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 09:33:07 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 546DE303D1;
        Fri, 17 Mar 2023 06:33:05 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32HClHSu004295;
        Fri, 17 Mar 2023 13:33:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=6gqMow8JJbaoH/VVuHmjPaKF26zU/5ZDM4Y57FnAlfE=;
 b=l5d3t+8OImYaJ1O0Gt5sjzJTDVHueJPJz1HuHppiH0JitvQj864urweLCNYBcrXVygmI
 faC55sT57Iy9yzUrhGIZrE3iPj+856AXMLsFeV/eJ3blP8wBuXhO95pz8aBAknwebCIu
 G5/rWQSyB7ZHZS8+gRgpRaxLPaEW2DAsPpz4I6kKZ5N1XwLxnpdptJSsSuVc6HkBED+/
 Zmmbawe23qCOf24dKgGJDcI92cbNLNh7SJmCrwRVzbYyhoLWDx6e7F0f0KBwtZG3Pt08
 5Po/Dhh59VTKqs8QKzPRSneoxv+dbyXdwTRS5Vobx1tR/V4csukFv5hwerSj5PJzZGao QQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pcrh2sgpq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Mar 2023 13:33:04 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32HCm0Ql006206;
        Fri, 17 Mar 2023 13:33:04 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pcrh2sgnu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Mar 2023 13:33:03 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32HDHKHs027488;
        Fri, 17 Mar 2023 13:33:02 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3pbsyxsstx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Mar 2023 13:33:02 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32HDWwrf26084032
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Mar 2023 13:32:58 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F174C2004E;
        Fri, 17 Mar 2023 13:32:57 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7A1720049;
        Fri, 17 Mar 2023 13:32:57 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 17 Mar 2023 13:32:57 +0000 (GMT)
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 0/3] s390x: Add misaligned instruction tests
Date:   Fri, 17 Mar 2023 14:32:50 +0100
Message-Id: <20230317133253.965010-1-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tYSWa6swGIgYqS3mwMWQiH7jqh95i2sA
X-Proofpoint-ORIG-GUID: rDyveTjKhS9UJ2x1lv8zH9Z6iV52tTfs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-17_08,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 suspectscore=0 adultscore=0 spamscore=0 mlxlogscore=999 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303170089
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instructions on s390 must be halfword aligned.
Add two tests for that.
These currently fail when using TCG, Ilya Leoshkevich <iii@linux.ibm.com>
posted fixes to the qemu mailing list.

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

Range-diff against v3:
1:  6ae1eb7d = 1:  c00f8aa2 s390x/spec_ex: Use PSW macro
2:  a0d02438 ! 2:  d9e3f6e0 s390x/spec_ex: Add test introducing odd address into PSW
    @@ Commit message
         the odd address.
         Add a test for this.
     
    +    Acked-by: Janosch Frank <frankja@linux.ibm.com>
         Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
     
      ## s390x/spec_ex.c ##
    @@ s390x/spec_ex.c: static int psw_bit_12_is_1(void)
     +
     +	expect_invalid_psw(odd);
     +	fixup_psw.mask = extract_psw_mask();
    -+	asm volatile ( "xr	%%r0,%%r0\n"
    ++	asm volatile ( "xgr	%%r0,%%r0\n"
     +		"	larl	%%r1,0f\n"
     +		"	stg	%%r1,%[fixup_addr]\n"
     +		"	lpswe	%[odd_psw]\n"
3:  e771deeb ! 3:  7ea75611 s390x/spec_ex: Add test of EXECUTE with odd target address
    @@ Commit message
         specification exception occurs.
         Add a test for this.
     
    +    Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
         Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
     
      ## s390x/spec_ex.c ##

base-commit: 20de8c3b54078ebc3df0b47344f9ce55bf52b7a5
-- 
2.39.1

