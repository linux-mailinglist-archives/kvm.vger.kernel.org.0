Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD5CF632A25
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 17:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbiKUQ6t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 11:58:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiKUQ6o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 11:58:44 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A29E1C;
        Mon, 21 Nov 2022 08:58:43 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ALG8fHX016915;
        Mon, 21 Nov 2022 16:58:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=IcjHOh29UXKMQdZ88jdKrD+XSJ+s2lAkRYNggVJmOMc=;
 b=U9MI2K5BKScTJWzuebnNR9QU53S82veQuq5bDG5tdE3l7MPvc9SOxMwWdlaB1pnZy7T7
 YkE3X3Lhj2sGdXq/vDKXAlHfyrjsJiP4wjzcLAVbSkUI5TIwDDFqn/nXL4UZ9SdwtC2y
 bOYSWqnBp+aWFDnJmw0EPNQehzCYugY443Xpqts5r/u4eY8/bvIEKWHYgYHm6xFdIm4V
 NkRyhXqgkqSv1Dgq9k3HVcXQ2LZ/QnwpJFIUmMuR+uD/Qw7tSUof4cEygjj56iUWSOba
 7B8zHnWAd7SVvEZFhzwXyyUfasbSUEZeXEknF7hgTpBkQSx4YN/ZONa5WMA4jyxJWbGK Dw== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ky91kntgp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 16:58:43 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ALGoav9004691;
        Mon, 21 Nov 2022 16:58:40 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3kxpdj27ay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 16:58:40 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ALGwbxu65733014
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 16:58:37 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6CE63A405B;
        Mon, 21 Nov 2022 16:58:37 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5932AA4054;
        Mon, 21 Nov 2022 16:58:37 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 21 Nov 2022 16:58:37 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 18A44E029C; Mon, 21 Nov 2022 17:58:37 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Eric Farman <farman@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [PATCH v2 1/2] vfio/ccw: sort out physical vs virtual pointers usage
Date:   Mon, 21 Nov 2022 17:58:35 +0100
Message-Id: <20221121165836.283781-2-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221121165836.283781-1-farman@linux.ibm.com>
References: <20221121165836.283781-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: nOkBo3JcHF1ixpR_NV_HUJtEYmpLd2MK
X-Proofpoint-GUID: nOkBo3JcHF1ixpR_NV_HUJtEYmpLd2MK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_14,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 phishscore=0 mlxlogscore=897 priorityscore=1501 impostorscore=0
 suspectscore=0 malwarescore=0 clxscore=1015 adultscore=0
 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2211210128
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexander Gordeev <agordeev@linux.ibm.com>

The ORB's interrupt parameter field is stored unmodified into the
interruption code when an I/O interrupt occurs. As this reflects
a real device, let's store the physical address of the subchannel
struct so it can be used when processing an interrupt.

Note: this currently doesn't fix a real bug, since virtual
addresses are identical to physical ones.

Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
[EF: Updated commit message]
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_fsm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
index a59c758869f8..0a5e8b4a6743 100644
--- a/drivers/s390/cio/vfio_ccw_fsm.c
+++ b/drivers/s390/cio/vfio_ccw_fsm.c
@@ -29,7 +29,7 @@ static int fsm_io_helper(struct vfio_ccw_private *private)
 
 	spin_lock_irqsave(sch->lock, flags);
 
-	orb = cp_get_orb(&private->cp, (u32)(addr_t)sch, sch->lpm);
+	orb = cp_get_orb(&private->cp, (u32)virt_to_phys(sch), sch->lpm);
 	if (!orb) {
 		ret = -EIO;
 		goto out;
-- 
2.34.1

