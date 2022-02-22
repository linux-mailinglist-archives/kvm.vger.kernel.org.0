Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9CC24BF50E
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 10:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbiBVJtr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 04:49:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbiBVJto (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 04:49:44 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0584BB0BE;
        Tue, 22 Feb 2022 01:49:18 -0800 (PST)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21M7P83t004369;
        Tue, 22 Feb 2022 09:49:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=6IReOAqy0Z8UM4schNqCchNJHkETG/+eBxKewWfk0Hc=;
 b=hcvRAYdrU9LT0PHr8jfzN8fc1PH923cZw6FtSitVBItYBuX+S+2zP/y8M+T+EWijOzjJ
 Jt+0Vbyvl0aoFSAjBKw1PL2s8FbmiNKLKHLbB335ma22Fi6Efe8GPiWnvR6xlaUqNTTi
 FQ+PFQ/SgWnw/tjQDM4NoZZ6pXkM7Jt1yjptnAWerdnXZRF5ifO3p6ZXyXr0x16Me02j
 780eHEGLmBajK/m/5ORJZo/aoRtC8DwGZgwTRD8UV8Lf50fU7KciHvrdV5Spgb5zqbzX
 vPpbSR2r8uXQKbsI4UQNELvFhTBeF0tIaM3PbOq/kJbggi2GT13EmUVYE6Rc2zfVmz7+ 2Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ecue4k0uc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 09:49:18 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21M9iWF7006473;
        Tue, 22 Feb 2022 09:49:17 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ecue4k0tv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 09:49:17 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21M9bOpY012012;
        Tue, 22 Feb 2022 09:49:15 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3eaqtjgeg2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 09:49:15 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21M9nCae55312744
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Feb 2022 09:49:12 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F22EE4C05C;
        Tue, 22 Feb 2022 09:49:11 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E76A34C059;
        Tue, 22 Feb 2022 09:49:11 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 22 Feb 2022 09:49:11 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id A774BE04EB; Tue, 22 Feb 2022 10:49:11 +0100 (CET)
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [GIT PULL 01/13] KVM: s390: MAINTAINERS: promote Claudio Imbrenda
Date:   Tue, 22 Feb 2022 10:48:58 +0100
Message-Id: <20220222094910.18331-2-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220222094910.18331-1-borntraeger@linux.ibm.com>
References: <20220222094910.18331-1-borntraeger@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: d6Tp3ptJjM75hXVbIpB4uMNc9_yGRJZo
X-Proofpoint-GUID: XpZNsyH937JFE2huB38Bi-mW6bO-OoNy
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-22_02,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 impostorscore=0 bulkscore=0 spamscore=0 adultscore=0 priorityscore=1501
 malwarescore=0 mlxscore=0 mlxlogscore=918 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202220054
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Claudio has volunteered to be more involved in the maintainership of
s390 KVM.

Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20220210085310.26388-1-borntraeger@linux.ibm.com
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3e461db9cd91..fe332650d032 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10547,8 +10547,8 @@ F:	arch/riscv/kvm/
 KERNEL VIRTUAL MACHINE for s390 (KVM/s390)
 M:	Christian Borntraeger <borntraeger@linux.ibm.com>
 M:	Janosch Frank <frankja@linux.ibm.com>
+M:	Claudio Imbrenda <imbrenda@linux.ibm.com>
 R:	David Hildenbrand <david@redhat.com>
-R:	Claudio Imbrenda <imbrenda@linux.ibm.com>
 L:	kvm@vger.kernel.org
 S:	Supported
 W:	http://www.ibm.com/developerworks/linux/linux390/
-- 
2.35.1

