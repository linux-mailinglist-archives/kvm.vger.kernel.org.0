Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45D5B524914
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 11:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352134AbiELJgD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 05:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352021AbiELJfi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 05:35:38 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B15F69B6F
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 02:35:37 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24C9ExM2019410
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=xVJIVy3QaU4L3MX6L22atdB87JuPOHgA71UqFhj3OwQ=;
 b=tQ4y6TW+CX0NWBPBxgQzkbJ3DH5fS58VoL5cgUhGVUsROYBrKOsKoLX8I+XdRQMGa8Oj
 mQaHwCXyvTxjmqSknX1wbxnJaVwQT3dea4+Pj8he1TIDjGQP+XXCpjCsYkofm2ZyidA9
 9va9RDZw88UvS9kC5Tl3+DlM/2hA0/kvm5bDWs1WZgnNUybCOPCBwDpB6yCTMba6CZrb
 lh0IpDKaPzYTe1EqCAfITsryKXb6SF+ssw6pGv3x0KeJk2bEIdJf/GVXFlwDQrfFxvmg
 r5/sh4LgdW4aMJY6EQki8Ce3zGNTuLgPDcewuYWMKeghUY4zocKFThWeLsu5CXxmWdJy 7Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0yefrbbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:36 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24C9GUK1027531
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:36 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0yefrbb5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:36 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24C9Xd5V007560;
        Thu, 12 May 2022 09:35:34 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3fwgd8n98e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:34 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24C9ZVqY38994298
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 09:35:31 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 04A8511C04C;
        Thu, 12 May 2022 09:35:31 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9E0911C058;
        Thu, 12 May 2022 09:35:30 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.10.145])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 May 2022 09:35:30 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 06/28] lib: s390x: hardware: Add host_is_qemu() function
Date:   Thu, 12 May 2022 11:35:01 +0200
Message-Id: <20220512093523.36132-7-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220512093523.36132-1-imbrenda@linux.ibm.com>
References: <20220512093523.36132-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: kGNiYYWJS30Ul11aTNDkqn6tdk2z28UH
X-Proofpoint-GUID: XhBwPH2_Y54PtnwM0zAqTt7L-Ub2WCh6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_02,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 priorityscore=1501 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205120044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

In the future we'll likely need to check if we're hosted on QEMU so
let's make this as easy as possible by providing a dedicated function.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/hardware.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/lib/s390x/hardware.h b/lib/s390x/hardware.h
index 01eeb261..86fe873c 100644
--- a/lib/s390x/hardware.h
+++ b/lib/s390x/hardware.h
@@ -45,6 +45,11 @@ static inline bool host_is_lpar(void)
 	return detect_host() == HOST_IS_LPAR;
 }
 
+static inline bool host_is_qemu(void)
+{
+	return host_is_tcg() || host_is_kvm();
+}
+
 static inline bool machine_is_z15(void)
 {
 	uint16_t machine = get_machine_id();
-- 
2.36.1

