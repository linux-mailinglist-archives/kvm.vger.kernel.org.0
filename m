Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A88BF635321
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 09:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236688AbiKWIrY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 03:47:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236681AbiKWIrV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 03:47:21 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A9A92B57;
        Wed, 23 Nov 2022 00:47:19 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AN6C7bs039793;
        Wed, 23 Nov 2022 08:47:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=zke0vGSRnM2M3jyXPQp7cHnF4OeHrBe60tp0p0hm6/k=;
 b=OFYk7XeCrzFaXXI4xKKgZ2iEIwfojgHcgT6D6RIcQrXhhIFZMbri9s2PcOLsGYyBoDgY
 JL5cvLaGFqB4Pl/5bxMdyIAZiMEj+FVOMe05xw2QLByRDybn/rJws85bBcNJlGE2KCG0
 0+oo9uRc+E8RN36Qa1T2kCCexzCR3HIJDZxJniageJhPxvKMVKnG3r8X2+sj9/BG+4VW
 LWJIUiU1TEChf/zN/QXd/U72UYFq34MDwGve2nhO9o7IM5qlUFSalgsd+VV3e4K/pvZO
 qZopQSSO9gm8dcKwj/rZ+l04AbA2drev+z6JStfdID5XAofpANnBjcnamUR7zpHet4rF DA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m10ffeww8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 08:47:18 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AN8kceV028283;
        Wed, 23 Nov 2022 08:47:18 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m10ffewv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 08:47:18 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AN8ZKo6007498;
        Wed, 23 Nov 2022 08:47:15 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3kxps93xfq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 08:47:15 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AN8lCiE63766956
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 08:47:12 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 848D911C04C;
        Wed, 23 Nov 2022 08:47:12 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B96C811C04A;
        Wed, 23 Nov 2022 08:47:11 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Nov 2022 08:47:11 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH 3/5] lib: s390x: sie: Set guest memory pointer
Date:   Wed, 23 Nov 2022 08:46:54 +0000
Message-Id: <20221123084656.19864-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221123084656.19864-1-frankja@linux.ibm.com>
References: <20221123084656.19864-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: CijI2Z_Uharv_zFQS-vhakKYG2MhRxHE
X-Proofpoint-GUID: lPwzxoU-tseG11B9UsOM9bPF25GV1-o6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_04,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 spamscore=0 clxscore=1015 lowpriorityscore=0
 bulkscore=0 suspectscore=0 impostorscore=0 malwarescore=0 mlxscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211230064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Seems like it was introduced but never set. It's nicer to have a
pointer than to cast the MSO of a VM.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/sie.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
index a71985b6..9241b4b4 100644
--- a/lib/s390x/sie.c
+++ b/lib/s390x/sie.c
@@ -93,6 +93,7 @@ void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t guest_mem_len)
 
 	/* Guest memory chunks are always 1MB */
 	assert(!(guest_mem_len & ~HPAGE_MASK));
+	vm->guest_mem = (uint8_t *)guest_mem;
 	/* For non-PV guests we re-use the host's ASCE for ease of use */
 	vm->save_area.guest.asce = stctg(1);
 	/* Currently MSO/MSL is the easiest option */
-- 
2.34.1

