Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1069F549B95
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 20:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244491AbiFMSeU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 14:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244839AbiFMSeE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 14:34:04 -0400
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44903C9EC3
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 07:53:55 -0700 (PDT)
Received: from pps.filterd (m0150241.ppops.net [127.0.0.1])
        by mx0a-002e3701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25DBV4v7019141;
        Mon, 13 Jun 2022 14:51:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pps0720;
 bh=dpg2CkSb3NxFngRdc1OuUtz8hLpvDHui4eYcX2h/7Go=;
 b=ntNWum9wDC4nhs9VvS44ECRoH3UppLVtI3Z2Sem10fzW64Cwbb13W/W20VLQcfkJkQxj
 7eOdRKbVlCCMJSO07vapMNqgu2yK6c6ptL1LywPbm3P/lYNKXQdUWhNL2e1uCv+bg3FG
 IrbsPCBTJOasWEBzY1+embazxo53qfXp1YdgTOvZWLF/+MoZAHBXtqstvAUmyGn/ksMI
 ltev4kWDKJ6Y3Z5gHSmn2czKGuH925ZAsqB4fbu4Jg5U+F+Yyjwbh5IP4Av9XL3y4UuF
 xNhuwHY2GKkWRF6gq6Jtd3eDFsnglyH1NEZ+lPRulI+Zs6lFD5o0BmnKa9YJph0FjaX+ Ug== 
Received: from p1lg14881.it.hpe.com (p1lg14881.it.hpe.com [16.230.97.202])
        by mx0a-002e3701.pphosted.com (PPS) with ESMTPS id 3gp4dxsxuh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Jun 2022 14:51:40 +0000
Received: from p1lg14886.dc01.its.hpecorp.net (unknown [10.119.18.237])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by p1lg14881.it.hpe.com (Postfix) with ESMTPS id DDEAA8058CB;
        Mon, 13 Jun 2022 14:51:38 +0000 (UTC)
Received: from dog.eag.rdlabs.hpecorp.net (unknown [16.231.227.36])
        by p1lg14886.dc01.its.hpecorp.net (Postfix) with ESMTP id 8E985809C42;
        Mon, 13 Jun 2022 14:51:37 +0000 (UTC)
Received: by dog.eag.rdlabs.hpecorp.net (Postfix, from userid 48777)
        id CD6FD302F481D; Mon, 13 Jun 2022 09:51:36 -0500 (CDT)
From:   Kyle Meyer <kyle.meyer@hpe.com>
To:     kvm@vger.kernel.org, x86@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, mingo@redhat.com, tglx@linutronix.de
Cc:     russ.anderson@hpe.com, payton@hpe.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com,
        Kyle Meyer <kyle.meyer@hpe.com>
Subject: [PATCH] KVM: x86: Increase KVM_MAX_VCPUS to 2048
Date:   Mon, 13 Jun 2022 09:50:22 -0500
Message-Id: <20220613145022.183105-1-kyle.meyer@hpe.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: uNCH9iqoqSY8EmT7dKpVx9tcX6meKmEz
X-Proofpoint-GUID: uNCH9iqoqSY8EmT7dKpVx9tcX6meKmEz
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-13_06,2022-06-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=953 phishscore=0 clxscore=1011 adultscore=0 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 impostorscore=0
 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206130066
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Increase KVM_MAX_VCPUS to 2048 so we can run larger virtual machines.

Notable changes:

* KVM_CAP_MAX_VCPUS will return 2048.
* KVM_MAX_VCPU_IDS will increase from 4096 to 8192.
* KVM_HV_MAX_SPARSE_VCPU_SET_BITS will increase from 16 to 32.

* CPUID[HYPERV_CPUID_IMPLEMENT_LIMITS (00x40000005)].EAX will now be 2048.

* struct kvm will increase from 40336 B to 40464 B.
* struct kvm_arch will increase from 34488 B to 34616 B.
* struct kvm_ioapic will increase from 5240 B to 9848 B.

* vcpu_mask in kvm_hv_flush_tlb will increase from 128 B to 256 B.
* vcpu_mask in kvm_hv_send_ipi will increase from 128 B to 256 B.
* vcpu_bitmap in ioapic_write_indirect will increase from 128 B to 256 B.
* vp_bitmap in sparse_set_to_vcpu_mask will increase from 128 B to 256 B.
* sparse_banks in kvm_hv_flush_tlb will increase from 128 B to 256 B.
* sparse_banks in kvm_hv_send_ipi will increase from 128 B to 256 B.

Signed-off-by: Kyle Meyer <kyle.meyer@hpe.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3a240a64ac68..58653c63899f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -38,7 +38,7 @@
 
 #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
 
-#define KVM_MAX_VCPUS 1024
+#define KVM_MAX_VCPUS 2048
 
 /*
  * In x86, the VCPU ID corresponds to the APIC ID, and APIC IDs
-- 
2.26.2

