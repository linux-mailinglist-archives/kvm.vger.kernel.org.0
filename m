Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBA146C035
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 17:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239403AbhLGQFk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 11:05:40 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26820 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239386AbhLGQFi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 11:05:38 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7Drdhk016118;
        Tue, 7 Dec 2021 16:02:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=z9pZVm+YpSi/UgHeAj7lN3onUBnqhUsuRCVF2LlEX3o=;
 b=QLACR+UGnYI9ySQiwP4AQMB260UKb7cHPIjOO+H/xqu+iwQuP1NkfH1Ny3yIyyvbNdtv
 lwk6gNY+M6WSqU+nKrOIC8jugVMFYxUwv0UKtKDJn54Xy521rSytEy6HuZoFRnOpaH/Q
 HQ+D5bSZvxQegPITfcgtmSweWBh6Y3aB2jSUEKPl2DmYPFHGWH1WORprJBNoRrBoZAZF
 A14Dcmx+1dyyzH7PFGxVMtCfDnjGVtlvGZAy7/DUNPzXTlG7sVjL5CCA5cY1Qwsy4Mv4
 fSh1qTELAE9GBKrlPwy8fzqKfktpaIheO3EO9/VV7HwAJzA94BezKsxvGlwmI5k+utl8 Kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ct8w6u0gq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 16:02:07 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B7Fd1Ct013577;
        Tue, 7 Dec 2021 16:02:07 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ct8w6u0fp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 16:02:07 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B7FqhMm010876;
        Tue, 7 Dec 2021 16:02:05 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3cqykj870d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 16:02:04 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B7G21Jm28574078
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 16:02:01 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3D394C05E;
        Tue,  7 Dec 2021 16:02:01 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 53B774C063;
        Tue,  7 Dec 2021 16:02:00 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  7 Dec 2021 16:02:00 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 03/10] s390x: sie: Add UV information into VM struct
Date:   Tue,  7 Dec 2021 15:59:58 +0000
Message-Id: <20211207160005.1586-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211207160005.1586-1-frankja@linux.ibm.com>
References: <20211207160005.1586-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Ef5bRRiBM-5xQJdiModp5Sfq3RDeG4Jw
X-Proofpoint-ORIG-GUID: YGogpSt1x_QYVT-qcYKbSbSAMdIy7nCT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_06,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=966 bulkscore=0 clxscore=1015 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112070098
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We need to save the handles for the VM and the VCPU so we can retrieve
them easily after their creation. Since the SIE lib is single guest
cpu only we only save one vcpu handle.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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

