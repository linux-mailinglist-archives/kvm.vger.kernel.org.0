Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23EE4FCF84
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 21:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbfKNUPx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 15:15:53 -0500
Received: from mail-eopbgr730059.outbound.protection.outlook.com ([40.107.73.59]:60877
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727075AbfKNUPw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 15:15:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J+kqmsBtv05w9LcdnxeQTb9M+oCPbn1cpMfPdQGPBQDqIu04FbckZEpQPDpCeUvfg7WB9Ju4JhKoOnIdxDmEZcYUw7c9kkYCbGv2RcZz0QHljXAX8eanTgXJ7corF/NqkwQ+0AbMFY3H34d8POExrQROeochGnNeaWQTixmnImg5DkqpWuCJCeQ7ZcndFA+gxNx0hSLTMYUI8GoIfzMtEmxwYB7XabKsCXg1TS/E74cUn+H/PSBikEbA81CR/wkdzacMZPZtd9EjK/r9HLLeizAkTWLf19eTtThZnZbZW83WHtd2JJX0t3cdgcjR+SXTWo0zSj8w+ibZtvgL7EjmsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fmTODvdyV2+cVJqSvbXzBHRhAplp57b94fhmJH+BT04=;
 b=PTekiZtS5MEiSAyZQ298um2SRHBa73E0HDDzeEA1oOPQdkZtNlHj+uf8dkc5i/eU70lVHQR9utLskjrpQgV9XxmCFXJ4JC40a0J+hP8IGUWYyGkFG9EZKNULB6cDLGUhrgy1+4ysrG3sF59gtJvh/6NnBhcJVJpYBkFFFoxSqLkQvgA4RI4L13Q9o7KHhpUzqO/W9daODFUVtxa8POIwZPBmV5A1exFG36Sj4nlWp68fP3My+Z0LoNzMqVgivZYbjGyjY3++T4UZ9jaS0GfA2gRXAH5kQ42ZmcI/GX/1VhgXfCsSIpv3rH/2zZUxVDv0lw9LVoLUe8chnbZqpSslqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fmTODvdyV2+cVJqSvbXzBHRhAplp57b94fhmJH+BT04=;
 b=KsB6copverbOECqhrM04vO62zCN1e26dkHa4lkZPNjM7EICxPbOT47JUb7pSfYE4U8V1i8h5DomsSgC0aBQ2hA1YhDkDhXZuw633CvVDyUd+krDSbHk3NKEnd6p31yyNvkLbe4m+c8UEs3iWqPCH6bvZxr5JqDKDVAx7yMnPtcI=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3739.namprd12.prod.outlook.com (10.255.172.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Thu, 14 Nov 2019 20:15:44 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2451.027; Thu, 14 Nov 2019
 20:15:44 +0000
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, joro@8bytes.org,
        vkuznets@redhat.com, rkagan@virtuozzo.com, graf@amazon.com,
        jschoenh@amazon.de, karahmed@amazon.de, rimasluk@amazon.com,
        jon.grimm@amd.com,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v5 10/18] svm: Add support for dynamic APICv
Date:   Thu, 14 Nov 2019 14:15:12 -0600
Message-Id: <1573762520-80328-11-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573762520-80328-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1573762520-80328-1-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN1PR12CA0099.namprd12.prod.outlook.com
 (2603:10b6:802:21::34) To DM6PR12MB3865.namprd12.prod.outlook.com
 (2603:10b6:5:1c8::18)
MIME-Version: 1.0
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [165.204.78.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c081ec6a-1131-474e-0e0c-08d7693f6d8d
X-MS-TrafficTypeDiagnostic: DM6PR12MB3739:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB37399BF43AD90A06AA36F47EF3710@DM6PR12MB3739.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 02213C82F8
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(1496009)(396003)(366004)(376002)(39860400002)(346002)(136003)(189003)(199004)(6506007)(25786009)(86362001)(6512007)(6436002)(8676002)(47776003)(7416002)(66066001)(6486002)(50226002)(4326008)(3846002)(8936002)(4720700003)(81156014)(2906002)(16586007)(7736002)(66556008)(305945005)(66476007)(2616005)(6116002)(66946007)(186003)(316002)(14454004)(486006)(478600001)(99286004)(81166006)(26005)(14444005)(476003)(5660300002)(44832011)(386003)(446003)(52116002)(51416003)(76176011)(50466002)(6666004)(36756003)(11346002)(48376002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3739;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FyFtt0YB11h4/K2NCtSSlDy/InSTL+BaZ+uEV2us7hmc0iIsAuOgf/3BQicMgTXO98WKMqdxwmgB185ABw5t7Vbv3ddvHmyjDL7xx8v6uZCohjRCxL6BCBdbH+ZCDljDhc3YCkRJFk+3NQjvjeZRpICgfNzqvwYLq3zEwJB6dgNVs297v2C+Y0/+xHZIMCB38QnhBNRSFrcFGQOmCJvWrSJT24VUupA6/e8Y2+Gu9/u9YbrP87pwYW34RkQtFEShi4DF5cMnAeJDJLAjywZEMksdaulKhwa7E25/7y6oLPIDgEGVNm4RFR0/ZPNs5f3ARlmIoKXEANIW16vfbhrxyM6soRfOxPKlqLrqo18A1TM6SAj8yghoLINTUfg33xJWWBoRHy7UXKEF3PJBgoRAU/N2z+SPCXN+yAdG24/YAv4v8aQ9V3cKDL6ctqC9EuZz
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c081ec6a-1131-474e-0e0c-08d7693f6d8d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2019 20:15:44.1239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gJlxg0IJhqY2daGNRcX6O4RqLex3gnP6r1l6w8DkaSts5q5ZDSyleHgjMlEVxU856cnqCoKlrA0NcV33sxRvnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3739
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add necessary logics to support (de)activate AVIC at runtime.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm.c | 38 ++++++++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 5a4516c..a1890bb 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -386,6 +386,7 @@ struct amd_svm_iommu_ir {
 static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
 static void svm_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa);
 static void svm_complete_interrupts(struct vcpu_svm *svm);
+static inline void avic_post_state_restore(struct kvm_vcpu *vcpu);
 
 static int nested_svm_exit_handled(struct vcpu_svm *svm);
 static int nested_svm_intercept(struct vcpu_svm *svm);
@@ -1489,7 +1490,10 @@ static void avic_init_vmcb(struct vcpu_svm *svm)
 	vmcb->control.avic_logical_id = lpa & AVIC_HPA_MASK;
 	vmcb->control.avic_physical_id = ppa & AVIC_HPA_MASK;
 	vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID_COUNT;
-	vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
+	if (kvm_apicv_activated(svm->vcpu.kvm))
+		vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
+	else
+		vmcb->control.int_ctl &= ~AVIC_ENABLE_MASK;
 }
 
 static void init_vmcb(struct vcpu_svm *svm)
@@ -1696,21 +1700,24 @@ static int avic_update_access_page(struct kvm *kvm, bool activate)
 
 static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 {
-	int ret;
 	u64 *entry, new_entry;
 	int id = vcpu->vcpu_id;
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	ret = avic_update_access_page(vcpu->kvm, true);
-	if (ret)
-		return ret;
-
 	if (id >= AVIC_MAX_PHYSICAL_ID_COUNT)
 		return -EINVAL;
 
 	if (!svm->vcpu.arch.apic->regs)
 		return -EINVAL;
 
+	if (kvm_apicv_activated(vcpu->kvm)) {
+		int ret;
+
+		ret = avic_update_access_page(vcpu->kvm, true);
+		if (ret)
+			return ret;
+	}
+
 	svm->avic_backing_page = virt_to_page(svm->vcpu.arch.apic->regs);
 
 	/* Setting AVIC backing page address in the phy APIC ID table */
@@ -2204,7 +2211,8 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 	/* We initialize this flag to true to make sure that the is_running
 	 * bit would be set the first time the vcpu is loaded.
 	 */
-	svm->avic_is_running = true;
+	if (irqchip_in_kernel(kvm) && kvm_apicv_activated(kvm))
+		svm->avic_is_running = true;
 
 	svm->nested.hsave = page_address(hsave_page);
 
@@ -2341,6 +2349,8 @@ static void svm_vcpu_blocking(struct kvm_vcpu *vcpu)
 
 static void svm_vcpu_unblocking(struct kvm_vcpu *vcpu)
 {
+	if (kvm_check_request(KVM_REQ_APICV_UPDATE, vcpu))
+		kvm_vcpu_update_apicv(vcpu);
 	avic_set_running(vcpu, true);
 }
 
@@ -5165,17 +5175,25 @@ static int svm_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
 	return ret;
 }
 
-/* Note: Currently only used by Hyper-V. */
 static void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb *vmcb = svm->vmcb;
 	bool activated = kvm_vcpu_apicv_active(vcpu);
 
-	if (activated)
+	if (activated) {
+		/**
+		 * During AVIC temporary deactivation, guest could update
+		 * APIC ID, DFR and LDR registers, which would not be trapped
+		 * by avic_unaccelerated_access_interception(). In this case,
+		 * we need to check and update the AVIC logical APIC ID table
+		 * accordingly before re-activating.
+		 */
+		avic_post_state_restore(vcpu);
 		vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
-	else
+	} else {
 		vmcb->control.int_ctl &= ~AVIC_ENABLE_MASK;
+	}
 	mark_dirty(vmcb, VMCB_AVIC);
 
 	svm_set_pi_irte_mode(vcpu, activated);
-- 
1.8.3.1

