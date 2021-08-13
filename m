Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B43653EB1A0
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 09:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239524AbhHMHiG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 03:38:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43946 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239505AbhHMHiD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Aug 2021 03:38:03 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17D7ZHd9022476;
        Fri, 13 Aug 2021 03:37:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=KyGO7FLlpd+rt5ORsA4SyMUviVJNOjLvEVvaHWGSibE=;
 b=iNXI36y1o0oZRgWB97IP6Zr67y25CUv71MNPVUHr/qmJlZQ7bMoWW5VhW7xjNiSBqvHT
 +6wRWibcQxT3KOPA4Q9Ak5AsJXz6v410EjYU/evynGeBV5l7MJkNBLauuCJh266mxlI4
 B2TO9MznUtEfiwhxwq64BV6mSWFJEUmjiJ19SnB+wxNLQ8UEIzGFj5tPTUzl0y3r31BH
 FU6n/luL6kszqQk5DxrnH3B9YNb0H7W6mWGFJ6UkZSBdLmcSMxmqavWnpqrDh79W++Bc
 +jYtU+oCE3sf4bJLZGi9ICUSV4Kyq+KqRMPYk9jg3X2jKu1FaOVGfSyE+MeZfhB2GfYw 2Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3accugkr1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 03:37:37 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17D7ZMtO023059;
        Fri, 13 Aug 2021 03:37:36 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3accugkr10-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 03:37:36 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17D7N5oA022622;
        Fri, 13 Aug 2021 07:37:34 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 3abaq4dxj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 07:37:34 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17D7bV7u51511586
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 07:37:31 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CBCF642041;
        Fri, 13 Aug 2021 07:37:31 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E3854203F;
        Fri, 13 Aug 2021 07:37:31 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 13 Aug 2021 07:37:31 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH 4/8] lib: s390x: Start using bitops instead of magic constants
Date:   Fri, 13 Aug 2021 07:36:11 +0000
Message-Id: <20210813073615.32837-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210813073615.32837-1-frankja@linux.ibm.com>
References: <20210813073615.32837-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 74ml6MDSE5nnVz6nb4ZRtkj607N3kdIg
X-Proofpoint-ORIG-GUID: 6AXnAvxdWt3b7Bgf-47duwAJrIIdj1Ts
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-13_01:2021-08-12,2021-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 clxscore=1015 impostorscore=0
 bulkscore=0 priorityscore=1501 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108130044
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TEID data is specified in the Principles of Operation as bits so it
makes more sens to test the bits instead of anding the mask.

We need to set -Wno-address-of-packed-member since for test bit we
take an address of a struct lowcore member.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/interrupt.c | 5 +++--
 s390x/Makefile        | 1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index 1248bceb..e05c212e 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -8,6 +8,7 @@
  *  David Hildenbrand <david@redhat.com>
  */
 #include <libcflat.h>
+#include <bitops.h>
 #include <asm/barrier.h>
 #include <sclp.h>
 #include <interrupt.h>
@@ -77,8 +78,8 @@ static void fixup_pgm_int(struct stack_frame_int *stack)
 		break;
 	case PGM_INT_CODE_PROTECTION:
 		/* Handling for iep.c test case. */
-		if (lc->trans_exc_id & 0x80UL && lc->trans_exc_id & 0x04UL &&
-		    !(lc->trans_exc_id & 0x08UL))
+		if (test_bit_inv(56, &lc->trans_exc_id) && test_bit_inv(61, &lc->trans_exc_id) &&
+		    !test_bit_inv(60, &lc->trans_exc_id))
 			/*
 			 * We branched to the instruction that caused
 			 * the exception so we can use the return
diff --git a/s390x/Makefile b/s390x/Makefile
index ef8041a6..d260b336 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -45,6 +45,7 @@ CFLAGS += -O2
 CFLAGS += -march=zEC12
 CFLAGS += -mbackchain
 CFLAGS += -fno-delete-null-pointer-checks
+CFLAGS += -Wno-address-of-packed-member
 LDFLAGS += -nostdlib -Wl,--build-id=none
 
 # We want to keep intermediate files
-- 
2.30.2

