Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA364638A6D
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 13:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiKYMnM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 07:43:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiKYMnF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 07:43:05 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4072D1A044;
        Fri, 25 Nov 2022 04:43:05 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2APCDxFk005911;
        Fri, 25 Nov 2022 12:43:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=Bxca+I8opI2EtAFH7Pe9fBMMuKdwSybjFKcqoDc4W9A=;
 b=jqm75vt55fQmxBR1pIw/aBrfaBheAEgZNXvwJsH4dyW/EDiTBHF9DaiNFYze3rOjHY38
 Ofvy1WdBtGSuzQbEzGzeCh8AupuqAbWaNmXRzH5vEz5rgKNGGC/Ou+un7EPoUckgXkDH
 fWv8dHSpIc3O7UVxCUphhiXGnB+ndCR+brU9YhEIC55ccdNr5cIa1ZW6DPQhyfx79Wj4
 qFo6us8JCWlvYkU1oHX1zRGWfgZdd7CozX3viDVifFOAtQmAK567XIkvUGjWtpKeQGIB
 ao0CnI2m1p8zCecUARRxZOTqJh/HF/rkDYZs8j03ZOtXDNdCI9c1nTUoQyK9aX3+LM+f lQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2whcghu7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 12:43:04 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2APCEbtv006656;
        Fri, 25 Nov 2022 12:43:03 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2whcghtt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 12:43:03 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2APCZmA5019322;
        Fri, 25 Nov 2022 12:43:02 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3kxps96xgg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 12:43:01 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2APCgwcw4719348
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Nov 2022 12:42:58 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A74284C044;
        Fri, 25 Nov 2022 12:42:58 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3CD0B4C046;
        Fri, 25 Nov 2022 12:42:58 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.63.115])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Nov 2022 12:42:58 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [GIT PULL 05/15] KVM: s390: pv: sort out physical vs virtual pointers usage
Date:   Fri, 25 Nov 2022 13:39:37 +0100
Message-Id: <20221125123947.31047-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221125123947.31047-1-frankja@linux.ibm.com>
References: <20221125123947.31047-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ePf2sA4YPTFwMrE6xWqJtYKnPU7PtYsS
X-Proofpoint-GUID: UJEHuQohqzV-QN4OOvelmRVsfMv8epC4
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-25_04,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 mlxscore=0 suspectscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 impostorscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211250098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

Fix virtual vs physical address confusion (which currently are the same).

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20221020143159.294605-6-nrb@linux.ibm.com
Message-Id: <20221020143159.294605-6-nrb@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/pv.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index c7435c37cdfe..48c4f57d5d76 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -80,8 +80,8 @@ int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
 	/* Input */
 	uvcb.guest_handle = kvm_s390_pv_get_handle(vcpu->kvm);
 	uvcb.num = vcpu->arch.sie_block->icpua;
-	uvcb.state_origin = (u64)vcpu->arch.sie_block;
-	uvcb.stor_origin = (u64)vcpu->arch.pv.stor_base;
+	uvcb.state_origin = virt_to_phys(vcpu->arch.sie_block);
+	uvcb.stor_origin = virt_to_phys((void *)vcpu->arch.pv.stor_base);
 
 	/* Alloc Secure Instruction Data Area Designation */
 	sida_addr = (void *)__get_free_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
@@ -228,8 +228,9 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	uvcb.guest_stor_origin = 0; /* MSO is 0 for KVM */
 	uvcb.guest_stor_len = kvm->arch.pv.guest_len;
 	uvcb.guest_asce = kvm->arch.gmap->asce;
-	uvcb.guest_sca = (unsigned long)kvm->arch.sca;
-	uvcb.conf_base_stor_origin = (u64)kvm->arch.pv.stor_base;
+	uvcb.guest_sca = virt_to_phys(kvm->arch.sca);
+	uvcb.conf_base_stor_origin =
+		virt_to_phys((void *)kvm->arch.pv.stor_base);
 	uvcb.conf_virt_stor_origin = (u64)kvm->arch.pv.stor_var;
 
 	cc = uv_call_sched(0, (u64)&uvcb);
-- 
2.38.1

