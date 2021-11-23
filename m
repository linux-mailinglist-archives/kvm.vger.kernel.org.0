Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D74845A07D
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 11:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235534AbhKWKn1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 05:43:27 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:65220 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234042AbhKWKnZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Nov 2021 05:43:25 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AN9koKL026760;
        Tue, 23 Nov 2021 10:40:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=lK73QdECEZ/VbqIrMPWwnpQiFFDRIjQYMtNs0OX9c7c=;
 b=RZSi4eVScvUcWmskje7xh+6Rt3aGTkQ4updSz3HSeKMr7LhGMpVVr2imCKNCGv1BM5PM
 CTrLzYLxZ1iGDValsdicEibT7k8z4FvbcHfGFfdxXl3ufkLdPwQqS8QM5QC52zcAXWTj
 211FEIeLNY83MViyVIoFC8U+38PatPAd2ciZoh+IgnHqqoPnDGkwC0/pgd/y+kb9Aebm
 LGRHtHrYfxkOq4rqTkZZVXUM/82+5Yhk0/ukHTR/ha1TTFMzEwpmDtOYJa3XNjY6AAMg
 l2I8jdRH1v5sdsqX7aUYA6JPyilzIr9t12aJAJ6cK8EVRMiaJOwJJixn+EX4Ef+S1Lfm RQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cgwyhry26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 10:40:17 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AN9lewO028240;
        Tue, 23 Nov 2021 10:40:16 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cgwyhry1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 10:40:16 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ANAb88V012809;
        Tue, 23 Nov 2021 10:40:13 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3cernapmwm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 10:40:13 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ANAe84k16711962
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 10:40:08 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60673A406E;
        Tue, 23 Nov 2021 10:40:08 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 283F8A405E;
        Tue, 23 Nov 2021 10:40:07 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Nov 2021 10:40:06 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com,
        mhartmay@linux.ibm.com
Subject: [kvm-unit-tests PATCH 3/8] s390x: sie: Add UV information into VM struct
Date:   Tue, 23 Nov 2021 10:39:51 +0000
Message-Id: <20211123103956.2170-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211123103956.2170-1-frankja@linux.ibm.com>
References: <20211123103956.2170-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -bCEJ1pKRHDn1oGw-MQuw6TU7gCIQjtw
X-Proofpoint-ORIG-GUID: lJFg5lVaaeV8PAmTl_3mAitK8iN3NEed
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-23_03,2021-11-23_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=981
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 clxscore=1015
 spamscore=0 impostorscore=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111230059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We need to save the handles for the VM and the VCPU so we can retrieve
them easily after their creation. Since the SIE lib is single guest
cpu only we only save one vcpu handle.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/sie.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
index c6eb6441..1a12faa7 100644
--- a/lib/s390x/sie.h
+++ b/lib/s390x/sie.h
@@ -200,6 +200,11 @@ union {
 	uint64_t	gvrd;			/* 0x01f8 */
 } __attribute__((packed));
 
+struct vm_uv {
+	uint64_t vm_handle;
+	uint64_t vcpu_handle;
+};
+
 struct vm_save_regs {
 	uint64_t grs[16];
 	uint64_t fprs[16];
@@ -220,6 +225,7 @@ struct vm {
 	struct vm_save_area save_area;
 	void *sca;				/* System Control Area */
 	uint8_t *crycb;				/* Crypto Control Block */
+	struct vm_uv uv;			/* PV UV information */
 	/* Ptr to first guest page */
 	uint8_t *guest_mem;
 };
-- 
2.32.0

