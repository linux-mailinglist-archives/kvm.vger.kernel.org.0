Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E73C4BDC87
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378079AbiBUOhl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 09:37:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378073AbiBUOhh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 09:37:37 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1449C1FA42;
        Mon, 21 Feb 2022 06:37:14 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21LEQ5jG020639;
        Mon, 21 Feb 2022 14:37:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=tSbMXh38w1m5isYJZGMogBGAKJRCnfBSGcDktspG2Ug=;
 b=s4HAo9W6I80iDjKKQhmsLrWqPxcJYiSZUHZj3J9g0z8uwVriH2DWNKH5jJvf8cBkn+n1
 QXTD7UnNFvC7BACGputh1/xn6+W5LD0EcI0QtTuea8DzU/gFytlnhY9VPwiow9UzNIa/
 L5QOtk1Hzd7MQ0Xmh2MFwsOtqXhWkv72QqU1iGn3iPVR55o0+utmA2AgQHy+9bPZLtor
 eGyXfUcH+Z7OufMeb335++dGmjxKfR+7+8NyxBStywWmeAO0rKmhsMZ4cPrGMOZiFiGH
 rFsAe7HyaERzWfPrJT3mfBpZydVK2ufQ0sD+r8hB5rFMKorDU9niCRaevD138PxHU7i7 Rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3eca3skp9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 14:37:11 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21LCxpbY022981;
        Mon, 21 Feb 2022 14:37:09 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3eca3skp8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 14:37:09 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21LESiW9021454;
        Mon, 21 Feb 2022 14:37:07 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3ear68te2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 14:37:07 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21LEb3V252822526
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Feb 2022 14:37:03 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 97286A4040;
        Mon, 21 Feb 2022 14:37:03 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34E2EA4051;
        Mon, 21 Feb 2022 14:37:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Feb 2022 14:37:03 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: s390: Clarify key argument for MEM_OP in api docs
Date:   Mon, 21 Feb 2022 15:36:57 +0100
Message-Id: <20220221143657.3712481-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220211182215.2730017-10-scgl@linux.ibm.com>
References: <20220211182215.2730017-10-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7f4pXBRszYbuNTzEk8_TPPvd-DC6tPt8
X-Proofpoint-ORIG-GUID: JYOJ6p9eazyxRnWLgAwhmir51Je-4MmW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-21_07,2022-02-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 suspectscore=0 priorityscore=1501 mlxscore=0 spamscore=0 bulkscore=0
 adultscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202210087
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clarify that the key argument represents the access key, not the whole
storage key.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
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
 

base-commit: af33593d63a403287b8a6edd217e854a3571938b
-- 
2.32.0

