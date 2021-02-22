Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A1232131D
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 10:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbhBVJ3q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 04:29:46 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11936 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229863AbhBVJ3o (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Feb 2021 04:29:44 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11M9RdZE138736;
        Mon, 22 Feb 2021 04:29:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=+cbhk8kI2bEmLFXN30z5ezQEltoLjE9PpEM040R4HCQ=;
 b=UJ9+ovbmwS0R+jElxTUYdSX4NevLrBP4qw30yEfpJzjkAChqgorMI/4TDseQezatxi+r
 jkBw12wYDEdAISkQEI1cnpzqcoQEiAYfdsmUo6NLJ08gXDaEPBdafvgxalkY+ihlG7x+
 D5xkiHcYhh+YDg5PYU/u0QnnsgQL81ppTpU/2AxFF2CtWJMrP2SFowbqTCebNQWZv0t5
 QQwXt/+8Kn0wDlpnFvKL/njsAqZar1bGFLTVhp7Y8iDgWRZPxAXMsTYiIEfAv4eHNHL2
 esyyxjZgzir04jaTsmZeznQDsX1cAjknhHApxnU1yNEgQZPfeEwPvtq8zPGiGzw39P96 GA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36va0d8325-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 04:29:02 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11M9RrRL140225;
        Mon, 22 Feb 2021 04:28:34 -0500
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36va0d8255-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 04:28:33 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11M8vxI3024945;
        Mon, 22 Feb 2021 08:59:11 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 36tt288rbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 08:59:11 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11M8x8Wh41353606
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Feb 2021 08:59:08 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79A25AE059;
        Mon, 22 Feb 2021 08:59:08 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE066AE056;
        Mon, 22 Feb 2021 08:59:07 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 22 Feb 2021 08:59:07 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        pmorel@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 0/7] s390x: Cleanup exception register save/restore and implement backtrace
Date:   Mon, 22 Feb 2021 03:57:49 -0500
Message-Id: <20210222085756.14396-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-22_02:2021-02-18,2021-02-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 impostorscore=0 clxscore=1015
 bulkscore=0 priorityscore=1501 suspectscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102220081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Having two sets of macros for saving and restoring registers on
exceptions doesn't seem optimal to me. Therefore this patch set
removes the old macros that use the lowcore as storage in favor of the
stack using ones. At the same time we move over to generated offsets
instead of subtracting from the stack piece by piece. Changes to the
stack struct are easier that way.

Additionally let's add backtrace support and print the GRs on
exception so we get a bit more information when something goes wrong.

v3:
	* Squashed the STACK_FRAME_INT_SIZE definition patch
	* Added a backchain store before we branch to the C pgm handler
	* Switched to the *int*_t types from kernel style types
	* Added comments

v2:
	* Added full CR saving to fix diag308 test
	* Added rev-bys

Janosch Frank (7):
  s390x: Fix fpc store address in RESTORE_REGS_STACK
  s390x: Fully commit to stack save area for exceptions
  s390x: Introduce and use CALL_INT_HANDLER macro
  s390x: Provide preliminary backtrace support
  s390x: Print more information on program exceptions
  s390x: Move diag308_load_reset to stack saving
  s390x: Remove SAVE/RESTORE_STACK and lowcore fpc and fprs save areas

 lib/s390x/asm-offsets.c   | 17 ++++---
 lib/s390x/asm/arch_def.h  | 35 ++++++++++----
 lib/s390x/asm/interrupt.h |  4 +-
 lib/s390x/interrupt.c     | 43 +++++++++++++++---
 lib/s390x/stack.c         | 20 +++++---
 s390x/Makefile            |  1 +
 s390x/cpu.S               |  6 ++-
 s390x/cstart64.S          | 25 ++--------
 s390x/macros.S            | 96 ++++++++++++++++++++-------------------
 9 files changed, 148 insertions(+), 99 deletions(-)

-- 
2.25.1

