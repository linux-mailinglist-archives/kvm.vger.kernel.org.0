Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0E3531DB9D
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 15:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233562AbhBQOnJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 09:43:09 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55700 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233542AbhBQOnI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Feb 2021 09:43:08 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11HEZNrC189774;
        Wed, 17 Feb 2021 09:42:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=a3IxyveesgxYnc4x6l6ab0vsfXg8aBqrZpXFqDRJyHI=;
 b=QstLV2069QV9bb88iYCBwYAM/Z8QXJvPr8HcYu0Hgl0LixW+UjVFxYNnto0nF1T2jV21
 nn5eN+Neh4T8uaJQEnSWEYrSFvk8o+W3bex9Z1RxxUMcjgPnr7s55/XTuz+T8oYvbi6J
 k01hKotcm7N13dr7uSirCwe8n4KLZ/e6ABVuQVf63t7qCf0gpy8VO6MM+vZBV8v37T2V
 VW/9UQZd8Y9AJx60fQ6yiq9Uw8ywN4rPO1E7U/sruQQpOjbUVM+is4cflsfZBPeNf28r
 lxDRZ/HhCQfSHo5UfZHIr24bagDzXV+xEXg95yElv8LOsb/4wiW+j2a2cahir1u6Wlx5 rA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36s3ew3ska-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 09:42:25 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11HEZvda192795;
        Wed, 17 Feb 2021 09:42:25 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36s3ew3shq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 09:42:25 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11HEgMHn023514;
        Wed, 17 Feb 2021 14:42:22 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 36p6d89yan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 14:42:22 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11HEgJSi38732092
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 14:42:19 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8040F11C04C;
        Wed, 17 Feb 2021 14:42:19 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC79F11C054;
        Wed, 17 Feb 2021 14:42:18 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 17 Feb 2021 14:42:18 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        pmorel@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 0/8] s390x: Cleanup exception register save/restore and implement backtrace
Date:   Wed, 17 Feb 2021 09:41:08 -0500
Message-Id: <20210217144116.3368-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-17_12:2021-02-16,2021-02-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0 clxscore=1015
 spamscore=0 phishscore=0 impostorscore=0 mlxscore=0 malwarescore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170113
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

v2:
	* Added full CR saving to fix diag308 test
	* Added rev-bys

Janosch Frank (8):
  s390x: Fix fpc store address in RESTORE_REGS_STACK
  s390x: Fully commit to stack save area for exceptions
  RFC: s390x: Define STACK_FRAME_INT_SIZE macro
  s390x: Introduce and use CALL_INT_HANDLER macro
  s390x: Provide preliminary backtrace support
  s390x: Print more information on program exceptions
  s390x: Move diag308_load_reset to stack saving
  s390x: Remove SAVE/RESTORE_stack

 lib/s390x/asm-offsets.c   | 15 +++++--
 lib/s390x/asm/arch_def.h  | 29 ++++++++++---
 lib/s390x/asm/interrupt.h |  4 +-
 lib/s390x/interrupt.c     | 43 +++++++++++++++---
 lib/s390x/stack.c         | 20 ++++++---
 s390x/Makefile            |  1 +
 s390x/cpu.S               |  6 ++-
 s390x/cstart64.S          | 25 +++--------
 s390x/macros.S            | 91 +++++++++++++++++++--------------------
 9 files changed, 140 insertions(+), 94 deletions(-)

-- 
2.25.1

