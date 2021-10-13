Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA4D942BCC7
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 12:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239316AbhJMKaE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 06:30:04 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48434 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239305AbhJMKaE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 06:30:04 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19DAB9CP008814;
        Wed, 13 Oct 2021 06:28:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ucjMvMOyj/JT7AplSbF9mPJvUXBdD5XjNaDH+TSCUdw=;
 b=qYBcMJFb9NpeAN9mSQIU+7sKturEAjuV2DAsKKqMBqgmJ0211cvQ78PseZRYaTtr2sQC
 doWP0tOzWypeKPlaIZA/KyOcdg6oks/hNnLK91moALwD6OKmxW+wZ/UaHiOK7Ye/EL+R
 0Ug0ZRh3uS0mGiYT/qDUd7lzoD6RsN9qa1SyOq6xuh//3JUJRX496Lt7MjwYhwoa1cAL
 g9/bv4BlP/1rKHQcIltHmZADNYIHK+TcTwi6/N5LsFdrsAJZwyht1cQqfBK34GlGQAcd
 Cr1ZrTvrNBwkCBF9u1/1MyIFYkzIMgpzfi3XJYeaROUeKClVjOAFsaocM1ObTAGDe/96 rQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bnpf38w37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 06:28:00 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19DAS0Q3013981;
        Wed, 13 Oct 2021 06:28:00 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bnpf38w2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 06:28:00 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19DAHQmE027121;
        Wed, 13 Oct 2021 10:27:58 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3bk2q9skmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 10:27:57 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19DAM9jI60293558
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 10:22:09 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 331C2A4053;
        Wed, 13 Oct 2021 10:27:47 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7CF55A405B;
        Wed, 13 Oct 2021 10:27:43 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Oct 2021 10:27:43 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com
Subject: [kvm-unit-tests PATCH 1/2] lib: s390x: Fix PSW constant
Date:   Wed, 13 Oct 2021 10:27:21 +0000
Message-Id: <20211013102722.17160-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211013102722.17160-1-frankja@linux.ibm.com>
References: <20211013102722.17160-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Ts2yfrCgYItVp0slwXg5YsKtduV9gk9X
X-Proofpoint-ORIG-GUID: N7U2AzRsoDtawp08ByvZH3j_2wgrtfQS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-13_03,2021-10-13_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 clxscore=1015 lowpriorityscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 spamscore=0 mlxlogscore=791 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110130068
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Somehow the ";" got into that patch and now complicates compilation.
Let's remove it and put the constant in braces.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index b34aa792..40626d72 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -53,7 +53,7 @@ struct psw {
 #define PSW_MASK_PSTATE			0x0001000000000000UL
 #define PSW_MASK_EA			0x0000000100000000UL
 #define PSW_MASK_BA			0x0000000080000000UL
-#define PSW_MASK_64			PSW_MASK_BA | PSW_MASK_EA;
+#define PSW_MASK_64			(PSW_MASK_BA | PSW_MASK_EA)
 
 #define CTL0_LOW_ADDR_PROT		(63 - 35)
 #define CTL0_EDAT			(63 - 40)
-- 
2.30.2

