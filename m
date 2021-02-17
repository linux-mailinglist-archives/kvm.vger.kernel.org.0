Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5489631DBA2
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 15:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233578AbhBQOnO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 09:43:14 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35300 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233425AbhBQOnJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Feb 2021 09:43:09 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11HEYtG6184900;
        Wed, 17 Feb 2021 09:42:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=vuRLhnrN0FZn6h/Va0uxgrip9AUObOGa8pIcB5cKFpY=;
 b=qMSgP7TorMu+UzqkQsLjJnL+/9ZWGY1VjQ9RIlonHQtwusqZwe558x0fCOe+iYe7/VIF
 fPIunl26cKw2knLnTYdEFievX7QUiSuGRjxfkQFlYhqhxv+4y0sAkMmDJizGtiFx5Ivl
 h0C68qV4p4vLr1QylIDGWDqL6kwnmKdH8zvQSt5no6xEK/HAPeyQwblojv6CU7iWMZZ5
 GsyIxc4uE52urNe1rAEH2CRSQDyFOQf0yZE/lNXThWj49x+gwBHDzk9wKTIw/nnYI9GN
 0dEZzbDJTm1uSu891wr96/CL808gUHV26bmSyRMBHv6KLHlcSSYsQsuEeel7Y/Hj6cbK tQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36s4v40mgb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 09:42:25 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11HEZqhB189874;
        Wed, 17 Feb 2021 09:42:25 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36s4v40mf8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 09:42:25 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11HEgNnH030069;
        Wed, 17 Feb 2021 14:42:23 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 36p61ha00g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 14:42:23 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11HEgKdk63898108
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 14:42:20 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6473311C04C;
        Wed, 17 Feb 2021 14:42:20 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A79D411C04A;
        Wed, 17 Feb 2021 14:42:19 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 17 Feb 2021 14:42:19 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        pmorel@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 1/8] s390x: Fix fpc store address in RESTORE_REGS_STACK
Date:   Wed, 17 Feb 2021 09:41:09 -0500
Message-Id: <20210217144116.3368-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210217144116.3368-1-frankja@linux.ibm.com>
References: <20210217144116.3368-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-17_11:2021-02-16,2021-02-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 mlxscore=0 suspectscore=0
 clxscore=1015 priorityscore=1501 phishscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170109
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The efpc stores in bits 32-63 of a register and we store a full 8
bytes to have the stack 8 byte aligned. This means that the fpc is
stored at offset 4 but we load it from offset 0. Lets replace efpc
with stfpc and get rid of the stg to store at offset 0.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 s390x/macros.S | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/s390x/macros.S b/s390x/macros.S
index 37a6a63e..e51a557a 100644
--- a/s390x/macros.S
+++ b/s390x/macros.S
@@ -54,8 +54,7 @@
 	.endr
 	/* Save fpc, but keep stack aligned on 64bits */
 	slgfi   %r15, 8
-	efpc	%r0
-	stg	%r0, 0(%r15)
+	stfpc	0(%r15)
 	.endm
 
 /* Restore the register in reverse order */
-- 
2.25.1

