Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16A9655E825
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 18:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347077AbiF1N5S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 09:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346956AbiF1N4c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 09:56:32 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C390A33892;
        Tue, 28 Jun 2022 06:56:31 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SDAr35015630;
        Tue, 28 Jun 2022 13:56:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=4PDDYu47xYi5NlXnaGbJcUyWy+VgpQ4eNVpki9Xu4RY=;
 b=KUG0cz7MB2oLaitah+qJLhHTi2ggiIwHXsdi3o88t3oRcZZg2IN2qUk7apW1kZZkVm6o
 4zD2j5LcfvN912pP1CAt9egNuKMx3u9Yx3inGFR1HTUL5v80WUSZnLSurU0AEPih/cDU
 /tFCNgh4aYZbj9uEvLZ0RAdAtBndNanQKLvKa38R50p2qTtjKWe1LG/n1cHdcdq1X2Mh
 TS81gbBwMwpw7VnLXp6BDabomcmwhJL6eKz0POhJKcF3vJLc8qp6EM+Qv8LOG1c5SIhK
 9hI68vQuUn1OxuPh6oY8OtaqzFQY0DN8v4h356r/hVZYz4lAnjQOgJHH41HWlp3ZsF9U HQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h01tjb26m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 13:56:31 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25SDCJRO022500;
        Tue, 28 Jun 2022 13:56:31 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h01tjb25e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 13:56:30 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25SDqGFP006564;
        Tue, 28 Jun 2022 13:56:28 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3gwt093pe0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 13:56:28 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25SDtP1422806910
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 13:55:25 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3181A4C040;
        Tue, 28 Jun 2022 13:56:25 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CAC444C046;
        Tue, 28 Jun 2022 13:56:24 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.40])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 28 Jun 2022 13:56:24 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v12 12/18] KVM: s390: pv: destroy the configuration before its memory
Date:   Tue, 28 Jun 2022 15:56:13 +0200
Message-Id: <20220628135619.32410-13-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628135619.32410-1-imbrenda@linux.ibm.com>
References: <20220628135619.32410-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -gq5wcgaTqoDLhZ9bWMWZru2_wzwWN_3
X-Proofpoint-ORIG-GUID: U7CGtxIq8nEq0jUwgV18U7BPt72O-x1v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-28_07,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 priorityscore=1501 phishscore=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 bulkscore=0 spamscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206280057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the Destroy Secure Configuration UVC before the loop to destroy
the memory. If the protected VM has memory, it will be cleaned up and
made accessible by the Destroy Secure Configuration UVC. The struct
page for the relevant pages will still have the protected bit set, so
the loop is still needed to clean that up.

Switching the order of those two operations does not change the
outcome, but it is significantly faster.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/pv.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index a389555d62e7..6cffea26c47f 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -163,6 +163,9 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 {
 	int cc;
 
+	cc = uv_cmd_nodata(kvm_s390_pv_get_handle(kvm),
+			   UVC_CMD_DESTROY_SEC_CONF, rc, rrc);
+	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
 	/*
 	 * if the mm still has a mapping, make all its pages accessible
 	 * before destroying the guest
@@ -172,9 +175,6 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 		mmput(kvm->mm);
 	}
 
-	cc = uv_cmd_nodata(kvm_s390_pv_get_handle(kvm),
-			   UVC_CMD_DESTROY_SEC_CONF, rc, rrc);
-	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
 	if (!cc) {
 		atomic_dec(&kvm->mm->context.protected_count);
 		kvm_s390_pv_dealloc_vm(kvm);
-- 
2.36.1

