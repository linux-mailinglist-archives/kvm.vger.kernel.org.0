Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E693B7344
	for <lists+kvm@lfdr.de>; Tue, 29 Jun 2021 15:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234049AbhF2NgH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Jun 2021 09:36:07 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38072 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233009AbhF2NgD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Jun 2021 09:36:03 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15TDLYWq084466;
        Tue, 29 Jun 2021 09:33:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=dB1O1qBTTIcgJAFEo2pfvY/MyHw5DQqZMN72f08pZ+A=;
 b=TIB+tiU7Qo7z9gxtAgElOMpVSPOjC7fOwNfZ+h1UGSSuKRs0lbw/B6YtavdJWLOPNZua
 BAXapMUR0pnysWXwgowyyG7OaRc1iL4JE3oKCvVK4lniviGjVVPpCMzOPP6Ek9AVxsKj
 eAYMoihYwVgZLso7tn5FtPlkIsdvLSA0QSWQgZuSw/y/VxMrpBIof/2qfv/Q+aKJRTv3
 DRiof7aRLkL2+OnYPpc94J9ECQeqnC3mMQZx3G0GYTkxhbdJk5GuXXXREMlaP/WyrUxb
 tExaGH8tOqQEVR5+UnMvTsP0yQefllD1e/LwUzviM26p5pdWYiCwrvrzdpm+nRUxXAy6 tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39g4b70bwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 09:33:36 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15TDLttb085761;
        Tue, 29 Jun 2021 09:33:35 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39g4b70bvy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 09:33:35 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15TDTVdA018169;
        Tue, 29 Jun 2021 13:33:34 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 39fv59r46x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 13:33:33 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15TDVtjC13107628
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 13:31:55 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 679F3A40D8;
        Tue, 29 Jun 2021 13:33:31 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29943A40C7;
        Tue, 29 Jun 2021 13:33:31 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 29 Jun 2021 13:33:31 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH 2/5] s390x: sie: Fix sie.h integer types
Date:   Tue, 29 Jun 2021 13:33:19 +0000
Message-Id: <20210629133322.19193-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210629133322.19193-1-frankja@linux.ibm.com>
References: <20210629133322.19193-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YYWs6VCEak2ZvdRuzNggDuUCeFbN0NJ7
X-Proofpoint-GUID: JxZgFEi0t9MXuwGcNZ8KiseLF0FNuuqx
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-29_06:2021-06-28,2021-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 mlxscore=0 suspectscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 impostorscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106290088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's only use the uint*_t types.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/sie.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
index b4bb78c..6ba858a 100644
--- a/lib/s390x/sie.h
+++ b/lib/s390x/sie.h
@@ -173,9 +173,9 @@ struct kvm_s390_sie_block {
 } __attribute__((packed));
 
 struct vm_save_regs {
-	u64 grs[16];
-	u64 fprs[16];
-	u32 fpc;
+	uint64_t grs[16];
+	uint64_t fprs[16];
+	uint32_t fpc;
 };
 
 /* We might be able to nestle all of this into the stack frame. But
@@ -191,7 +191,7 @@ struct vm {
 	struct kvm_s390_sie_block *sblk;
 	struct vm_save_area save_area;
 	/* Ptr to first guest page */
-	u8 *guest_mem;
+	uint8_t *guest_mem;
 };
 
 extern void sie_entry(void);
-- 
2.30.2

