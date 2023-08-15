Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0CC77CECF
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 17:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237845AbjHOPOo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 11:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237933AbjHOPOg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 11:14:36 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 705741991;
        Tue, 15 Aug 2023 08:14:25 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37FEvxkd032228;
        Tue, 15 Aug 2023 15:14:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=/zcgXKoZMciTpOBuD50eYv5goCIWXhHMXvhUY/hTGXk=;
 b=QAXWLbmj2lBuhdKLJDbOr/atxFXn9odhg1sLWu6uo6ImFMDoXp6NQWTv2jesgINnNXIs
 6l/UTxzSahUZivqbMBG53BdZrj/SfrcUUzbQKhZG92S7YNs0WWUpachqfQxJdqV7nVNr
 kk25frsluvGxto/Uu5hsAWcy4pCQs0FblYQwfmtwS4dXd44M0Zvvr635tVOZnre1T1yp
 Rml9qsDAWLi7soVZlz65RB4t0C1JLCM6muui6Kip01UAlicv8iwt8ZJZ/6ivPmk0MxcB
 gUiKBV60DCn/3dMFYdfoYS9LAEl/JKctsSw33AmauySn7xc/dw0Q0U3DkhQlOpiUCrOw 5Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sgbk28efw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 15:14:24 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37FF0IbX006386;
        Tue, 15 Aug 2023 15:14:24 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sgbk28efb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 15:14:24 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37FF9GQc001119;
        Tue, 15 Aug 2023 15:14:23 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3semsy5wq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 15:14:23 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37FFEJdc24576560
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Aug 2023 15:14:19 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 788552004B;
        Tue, 15 Aug 2023 15:14:16 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3900020043;
        Tue, 15 Aug 2023 15:14:16 +0000 (GMT)
Received: from a46lp73.lnxne.boe (unknown [9.152.108.100])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 15 Aug 2023 15:14:16 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Michael Mueller <mimu@linux.vnet.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
Subject: [PATCH v4 1/4] KVM: s390: pv: relax WARN_ONCE condition for destroy fast
Date:   Tue, 15 Aug 2023 17:14:12 +0200
Message-ID: <20230815151415.379760-2-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230815151415.379760-1-seiden@linux.ibm.com>
References: <20230815151415.379760-1-seiden@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: cjbOihYAISd5ktWgvDac6-aIY9BcAVjl
X-Proofpoint-GUID: n6Q6orN31Kf3HB1L6qWJGIPbNEmOwxkD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-15_16,2023-08-15_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 impostorscore=0 phishscore=0
 mlxlogscore=787 spamscore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308150134
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Viktor Mihajlovski <mihajlov@linux.ibm.com>

Destroy configuration fast may return with RC 0x104 if there
are still bound APQNs in the configuration. The final cleanup
will occur with the standard destroy configuration UVC as
at this point in time all APQNs have been reset and thus
unbound. Therefore, don't warn if RC 0x104 is reported.

Signed-off-by: Viktor Mihajlovski <mihajlov@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
---
 arch/s390/kvm/pv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 8d3f39a8a11e..8570ee324607 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -285,7 +285,8 @@ static int kvm_s390_pv_deinit_vm_fast(struct kvm *kvm, u16 *rc, u16 *rrc)
 	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
 	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM FAST: rc %x rrc %x",
 		     uvcb.header.rc, uvcb.header.rrc);
-	WARN_ONCE(cc, "protvirt destroy vm fast failed handle %llx rc %x rrc %x",
+	WARN_ONCE(cc && uvcb.header.rc != 0x104,
+		  "protvirt destroy vm fast failed handle %llx rc %x rrc %x",
 		  kvm_s390_pv_get_handle(kvm), uvcb.header.rc, uvcb.header.rrc);
 	/* Intended memory leak on "impossible" error */
 	if (!cc)
-- 
2.41.0

