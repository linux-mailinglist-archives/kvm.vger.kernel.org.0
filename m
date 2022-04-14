Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14CAF5007C7
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 10:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240903AbiDNIGX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 04:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240795AbiDNIGF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 04:06:05 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606824EA01;
        Thu, 14 Apr 2022 01:03:33 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23E7Tvq9038637;
        Thu, 14 Apr 2022 08:03:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=v81zIWqThSoQpw1Xj9yot2v6/xoNQsgoV/ZgOMSNg7o=;
 b=P3FdPHfdHS6TrrmOb1FOEPzeUSR2dJvYyzZ0Oq7xUapj9al7yBPn16MkmPtk4HyVkl8u
 ANPtri979JVwaQkpSHolSmVysqVAcuQ5fBYnp+3uwi2y2dCij5fulpaOciEZZ4yi7xFn
 8N37so8DWp5dr6Fxm2Ll3XziWTDt28wfdIYhlW+tlMRppoM7AxfdJjl0yZP0cQwNZjZY
 iEG6yMTJiWc294o6dh1Fej57T/t+ARs8hqJtUupW3hntdy6A3U/dcYNFwgzFjXEPKriy
 XdThZ8opTQ7PnkBqVny+kW9dKHgzVjm9YHXx0DltQMqtXvRW7uliOIzajEs5tjKGXFF7 1w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3febx9vbf3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 08:03:32 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23E7wiBB030170;
        Thu, 14 Apr 2022 08:03:31 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3febx9vbe8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 08:03:31 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23E7mLRg007743;
        Thu, 14 Apr 2022 08:03:28 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3fb1s8pg2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 08:03:28 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23E7op1v46662120
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 07:50:51 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3EC70AE056;
        Thu, 14 Apr 2022 08:03:25 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B53A4AE051;
        Thu, 14 Apr 2022 08:03:24 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.1.140])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Apr 2022 08:03:24 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v10 13/19] KVM: s390: pv: destroy the configuration before its memory
Date:   Thu, 14 Apr 2022 10:03:04 +0200
Message-Id: <20220414080311.1084834-14-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220414080311.1084834-1-imbrenda@linux.ibm.com>
References: <20220414080311.1084834-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7bWngln4b-oAJTTu9uf-cbyGToujqeO2
X-Proofpoint-ORIG-GUID: 47aUpe6vwn9HwSVmWts3-wR8QJ67_owT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-14_02,2022-04-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 impostorscore=0
 malwarescore=0 phishscore=0 suspectscore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204140044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the Destroy Secure Configuration UVC before the loop to destroy
the memory. If the protected VM has memory, it will be cleaned up and
made accessible by the Destroy Secure Configuraion UVC. The struct
page for the relevant pages will still have the protected bit set, so
the loop is still needed to clean that up.

Switching the order of those two operations does not change the
outcome, but it is significantly faster.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/pv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index be3b467f8feb..bd850be08c86 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -168,6 +168,8 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 {
 	int cc;
 
+	cc = uv_cmd_nodata(kvm_s390_pv_get_handle(kvm),
+			   UVC_CMD_DESTROY_SEC_CONF, rc, rrc);
 	/*
 	 * if the mm still has a mapping, make all its pages accessible
 	 * before destroying the guest
@@ -177,8 +179,6 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 		mmput(kvm->mm);
 	}
 
-	cc = uv_cmd_nodata(kvm_s390_pv_get_handle(kvm),
-			   UVC_CMD_DESTROY_SEC_CONF, rc, rrc);
 	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
 	if (!cc) {
 		atomic_dec(&kvm->mm->context.protected_count);
-- 
2.34.1

