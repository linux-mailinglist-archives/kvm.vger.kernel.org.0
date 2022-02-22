Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFB34BF517
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 10:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbiBVJt4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 04:49:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbiBVJts (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 04:49:48 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE60CC3351;
        Tue, 22 Feb 2022 01:49:22 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21M8Bp0n005727;
        Tue, 22 Feb 2022 09:49:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=bd4APmQN06Qjjkzb9dUT4ird+TuEAx3MsdP9Utk6vb0=;
 b=Wh6xWXpMJYzA0ubBTm4o+CP3x8VBnTCS1KTziNpFzpxkoX2fQ7wdIw8r0Kau9VsLegsJ
 DtXTtduVgd27giYtxA5Oce+XaLZ9MNWhr8IMP5BZs+Fj1dZFNh1enYPNEXxlcCu6K/ph
 D7OB9BW+HyYvoKhGZVKSAM8goTYR6e8AtZ2xjLjWABn6PmP4I+FQ/Gne9mERzyal64Ak
 TY8A/1pPbxqCBoh/ORXDQj16vYWrpFW0zBNy/1X4wYW/4YeVr0SLUAzNcOjdPJvlfdxd
 vOvgpdmctfqB/2WAITS9gLBx5j8HvuT/KWT9K9aehhDSHhoxnngntymhcJQpxHztZEBi nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ecv3ua0cr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 09:49:22 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21M9nL7K013598;
        Tue, 22 Feb 2022 09:49:21 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ecv3ua0by-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 09:49:21 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21M9bPFG012213;
        Tue, 22 Feb 2022 09:49:19 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 3eaqtjgegh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 09:49:19 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21M9nFMf57672062
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Feb 2022 09:49:15 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 89C1511C052;
        Tue, 22 Feb 2022 09:49:15 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77BFB11C04A;
        Tue, 22 Feb 2022 09:49:15 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 22 Feb 2022 09:49:15 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 39830E04DC; Tue, 22 Feb 2022 10:49:15 +0100 (CET)
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
Subject: [GIT PULL 12/13] KVM: s390: Clarify key argument for MEM_OP in api docs
Date:   Tue, 22 Feb 2022 10:49:09 +0100
Message-Id: <20220222094910.18331-13-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220222094910.18331-1-borntraeger@linux.ibm.com>
References: <20220222094910.18331-1-borntraeger@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: nPEzvR2C9HRCTiwDzX6gEF3SLQS7271-
X-Proofpoint-GUID: ixgExbietxZfvTP_f2gohoxCnhSZe2s0
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-22_02,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202220054
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

Clarify that the key argument represents the access key, not the whole
storage key.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Link: https://lore.kernel.org/r/20220221143657.3712481-1-scgl@linux.ibm.com
Fixes: 5e35d0eb472b ("KVM: s390: Update api documentation for memop ioctl")
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 Documentation/virt/kvm/api.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 48f23bb80d7f..622667cc87ef 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -3763,7 +3763,7 @@ KVM_S390_MEMOP_F_INJECT_EXCEPTION is set.
 
 If the KVM_S390_MEMOP_F_SKEY_PROTECTION flag is set, storage key
 protection is also in effect and may cause exceptions if accesses are
-prohibited given the access key passed in "key".
+prohibited given the access key designated by "key"; the valid range is 0..15.
 KVM_S390_MEMOP_F_SKEY_PROTECTION is available if KVM_CAP_S390_MEM_OP_EXTENSION
 is > 0.
 
-- 
2.35.1

