Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEF2C4EEC3D
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 13:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345487AbiDALTC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 07:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345448AbiDALSe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 07:18:34 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10CD187B97
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 04:16:43 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2319j6AW007942
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=xldSF39mUuRll1043UB57opeZCqbLkGfiTZQPtI7n9g=;
 b=nD/J2jypxnqBEUZ6tIf+WV2OSdu9NdXW0ybioacxwk18jw5FmxITeHw4E/eZijPujUCm
 KINp9jaJC5LR30fqQKKbUWTXufbALw+upueRW+W0JUI1MlBBBSDCrGrsVRmDeZ0AquqF
 7cyw/z4G28XuE835VU6hD47fRhNhmOPpsgbYvGi9lUBCPRyoeBbbrKH4nSlYLX10FsOK
 rtLMEPA5NdYVtYujwkd/zpoxntOko4vqScoXSUD8uXzEYLcauy4bb/vR6ppNYWhsfUON
 U8CkOGgxBpDqF0To+C+xXZrnyEwAocMijD+nCnDDK9lZxxLXg3l094ALbSGICv/uVzvB fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f5y1j9txq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 11:16:43 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 231BEPQM005068
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:42 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f5y1j9twr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:42 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 231B98ib022203;
        Fri, 1 Apr 2022 11:16:40 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3f1tf92wa3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:40 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 231BGbIQ43319722
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Apr 2022 11:16:37 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3FE774C066;
        Fri,  1 Apr 2022 11:16:37 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E9E2C4C06D;
        Fri,  1 Apr 2022 11:16:36 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.3.73])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 Apr 2022 11:16:36 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 27/27] lib: s390x: stidp wrapper and move get_machine_id
Date:   Fri,  1 Apr 2022 13:16:20 +0200
Message-Id: <20220401111620.366435-28-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401111620.366435-1-imbrenda@linux.ibm.com>
References: <20220401111620.366435-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bf8TnckajjUgBQRAbZpapvYCfA2kya-t
X-Proofpoint-GUID: ImkJxq3-y6lL35z0N0_g77ME4QqTb4HU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-01_04,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 clxscore=1015 adultscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 mlxscore=0 mlxlogscore=919 lowpriorityscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204010050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor get_machine_id in arch_def.h into a simple wrapper around
stidp, add back get_machine_id in hardware.h using the stidp wrapper.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h | 4 +---
 lib/s390x/hardware.h     | 5 +++++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 8d860ccf..bab3c374 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -219,13 +219,11 @@ static inline unsigned short stap(void)
 	return cpu_address;
 }
 
-static inline uint16_t get_machine_id(void)
+static inline uint64_t stidp(void)
 {
 	uint64_t cpuid;
 
 	asm volatile("stidp %0" : "=Q" (cpuid));
-	cpuid = cpuid >> 16;
-	cpuid &= 0xffff;
 
 	return cpuid;
 }
diff --git a/lib/s390x/hardware.h b/lib/s390x/hardware.h
index af20be18..01eeb261 100644
--- a/lib/s390x/hardware.h
+++ b/lib/s390x/hardware.h
@@ -25,6 +25,11 @@ enum s390_host {
 
 enum s390_host detect_host(void);
 
+static inline uint16_t get_machine_id(void)
+{
+	return stidp() >> 16;
+}
+
 static inline bool host_is_tcg(void)
 {
 	return detect_host() == HOST_IS_TCG;
-- 
2.34.1

