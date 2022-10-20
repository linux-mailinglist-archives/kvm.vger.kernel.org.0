Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 091D360631C
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 16:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbiJTOcP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 10:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiJTOcJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 10:32:09 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D8415D0B5;
        Thu, 20 Oct 2022 07:32:07 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29KEDmL7002223;
        Thu, 20 Oct 2022 14:32:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=K6pGrgvtfbptmI3gc5NJmIdp1nAq3EW53v7SlbciOlw=;
 b=ZrGhLb+oENHZaw/IeQG12TwjREXTh+xTuBYp5h9hj/mmiOklFrisiskPMfCVrIp1aoCF
 2PeV7T5KV0Tm3rBCp2Gl60b9ovXJSXs94HVntXMSZjbPqaHDzZpUZ4xzqkM3h5AxjEHp
 F4rAmbrBhcH+KZ1v7IJC8bRybZLm42BewLNZxPg4p8WQOVlNLUsbGqcxQ0OLXeEilz9j
 dGb1u1q/wjHOZSLA6LOBCIpt1VxHugOY7/vDh6IJeXa8GcQ7XQOy1RIX+BZ92g/wyngK
 d6zgJaa9XiZhefatnOmQOWj9d0IlaW9YMU8ZJpIp4WAM4K3MdNba9l3IRsWIoOUh8PzI JQ== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb7werprh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 14:32:07 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29KELIud021414;
        Thu, 20 Oct 2022 14:32:05 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3k7mg990q3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 14:32:05 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29KEW1Hl2097780
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 14:32:02 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E0ADCAE045;
        Thu, 20 Oct 2022 14:32:01 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9657AAE051;
        Thu, 20 Oct 2022 14:32:01 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Oct 2022 14:32:01 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com
Subject: [v1 5/5] KVM: s390: pv: sort out physical vs virtual pointers usage
Date:   Thu, 20 Oct 2022 16:31:59 +0200
Message-Id: <20221020143159.294605-6-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221020143159.294605-1-nrb@linux.ibm.com>
References: <20221020143159.294605-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bHIK04sMi5Do0hceALPoG9EoOPL7fPTU
X-Proofpoint-ORIG-GUID: bHIK04sMi5Do0hceALPoG9EoOPL7fPTU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_05,2022-10-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 adultscore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210200083
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix virtual vs physical address confusion (which currently are the same).

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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
2.37.3

