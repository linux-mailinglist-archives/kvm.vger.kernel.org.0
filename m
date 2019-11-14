Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8739BFCF6B
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 21:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfKNUPg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 15:15:36 -0500
Received: from mail-eopbgr730059.outbound.protection.outlook.com ([40.107.73.59]:60877
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726632AbfKNUPf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 15:15:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RPxLtFDBiyYGfiBCdJxgrHa3ET/KKTLguog2cO4OUrLS2CP8+BzUB+P/wMMFRDDB/0chuaTp4WfDpO0QFwKqIgcufslXdc89x+0g6GKFfsu0O+opLgFxSTnk2tRO89U5pjC4LdMGyp7cmJ6DJHYcypdo18eClvYHgOeEkRg7EK2I2RbWNdD4rUFfBGY02HeqpfAt3g9aOycpEsb43ExFAYTEnmJ/CmgKMcurVSECEBdD2EFufoWtqrkY2hxs3NtN1tXD5fWcK0N92dDlrhga/yQsR1AD3OVRLcde++QX4DYZbZ4sxMJrZXsVRZad+bU6gTNVKDZuz2C+ar9by6M1vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xzDipuGPRPvDcktOm15fhfWxGqoQnuRsVISBpEaSiCc=;
 b=fspMg41v12nY1lBy97iSSepKQdJTk7FzQ6Q+UT/YUT9NOugWrPW8h0cVOuPTFwquyQLfrdeJ+KfV/PxNhBFBu0LTzPS620PJDwR0V0bqSnMzuzWiABEzJfkdP0Bno6uEw76YFD66EdAurYaO0ggQDDWjFqJGCd3A55Dx8M7GNl1CUPFKVjWl+/mTNy1BLtoM6X9SpNJ05UOwgj0f7fNUUNHAAFUUO4KtwFiWrk9dWTdu+k9U6CL7YpGeuKycaQY9vWmnWQi3jF0WBVSikNE0EUgZmFyWWVoUMl5GMWW9cQbOXOup11Z8WQPQzvg4gL/uTMZSu7F8dhBHtw2yyXjv3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xzDipuGPRPvDcktOm15fhfWxGqoQnuRsVISBpEaSiCc=;
 b=XKbsHqXdnvEiAERrlpX3ObD9BVgwLBEfLzQUYo5GXcqi6YqDXaB4OlQmc9nTuI3X/jvzdVg3k/pCttbuJLWSMMmKiHJxT5PwCCt9jqZ/HKZb79q9h8fBw8JgFUMk4fB1MexqxMrsGECsCrv8hCncPWgNDR9lGCU8JulCT650ey4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3739.namprd12.prod.outlook.com (10.255.172.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Thu, 14 Nov 2019 20:15:32 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2451.027; Thu, 14 Nov 2019
 20:15:32 +0000
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, joro@8bytes.org,
        vkuznets@redhat.com, rkagan@virtuozzo.com, graf@amazon.com,
        jschoenh@amazon.de, karahmed@amazon.de, rimasluk@amazon.com,
        jon.grimm@amd.com,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v5 01/18] kvm: x86: Modify kvm_x86_ops.get_enable_apicv() to use struct kvm parameter
Date:   Thu, 14 Nov 2019 14:15:03 -0600
Message-Id: <1573762520-80328-2-git-send-email-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 9afe5bb6-0b04-4f3f-c25d-08d7693f665b
X-MS-TrafficTypeDiagnostic: DM6PR12MB3739:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3739AC21621C91AA77F73927F3710@DM6PR12MB3739.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-Forefront-PRVS: 02213C82F8
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(376002)(39860400002)(346002)(136003)(189003)(199004)(6506007)(25786009)(86362001)(6512007)(6436002)(8676002)(47776003)(7416002)(66066001)(6486002)(50226002)(4326008)(3846002)(8936002)(4720700003)(81156014)(2906002)(16586007)(7736002)(66556008)(305945005)(66476007)(2616005)(6116002)(66946007)(186003)(316002)(14454004)(486006)(478600001)(99286004)(81166006)(26005)(14444005)(476003)(5660300002)(44832011)(386003)(446003)(52116002)(51416003)(76176011)(50466002)(6666004)(36756003)(11346002)(48376002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3739;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gBAC2QZSyg/Z/gxV06BUE4bB6ixQk6f+GqYTMYz0PFRDS0CVCvDR9Q3eiYidJlCiarCCj4SNvGFqcXVm8rELMHdQBg/p4db+8DbG8WA3XJeRShWCcCKixfIHVFf83gsmyhhwUblH/rLStVRQCTsATWgGCS+os1lZKOFp3pjYgVuBayrUaahvDOm7fpjy7hApXnOYvFjytAZkKyErH8Xw5milhqpS6VxUyCwf4YupHCTKnzUO0kVRGRcHid8C77RrAh5QbtTYRInpwlvcnEO4HBka9QDFrOflrwSiiM19/bhgDe7GSexC+5DV4F4PWWE+3rxFvqAkUL0tfW2174vcAVdHviCmRBGWDwZ4yJY0jARWQor32zx+VCHCHAxxewy06hZt7wccH6SU4ZH8KaPBb4nOAxKZtIDeULATXbl9ShNT9K3L3TftW6kTm6XyMFD1
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9afe5bb6-0b04-4f3f-c25d-08d7693f665b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2019 20:15:32.1297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PIS0HwEVCVghDHzKvgXj2A1Ybte0IWKuymGzwAzz/l+asIshtiLi8nz1UawYOSeX1BjiefEyOE+7pi9+DOmz0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3739
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Generally, APICv for all vcpus in the VM are enable/disable in the same
manner. So, get_enable_apicv() should represent APICv status of the VM
instead of each VCPU.

Modify kvm_x86_ops.get_enable_apicv() to take struct kvm as parameter
instead of struct kvm_vcpu.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/svm.c              | 4 ++--
 arch/x86/kvm/vmx/vmx.c          | 2 +-
 arch/x86/kvm/x86.c              | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 24d6598..632589a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1084,7 +1084,7 @@ struct kvm_x86_ops {
 	void (*enable_nmi_window)(struct kvm_vcpu *vcpu);
 	void (*enable_irq_window)(struct kvm_vcpu *vcpu);
 	void (*update_cr8_intercept)(struct kvm_vcpu *vcpu, int tpr, int irr);
-	bool (*get_enable_apicv)(struct kvm_vcpu *vcpu);
+	bool (*get_enable_apicv)(struct kvm *kvm);
 	void (*refresh_apicv_exec_ctrl)(struct kvm_vcpu *vcpu);
 	void (*hwapic_irr_update)(struct kvm_vcpu *vcpu, int max_irr);
 	void (*hwapic_isr_update)(struct kvm_vcpu *vcpu, int isr);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index c5673bd..d53ffb8 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5110,9 +5110,9 @@ static void svm_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
 	return;
 }
 
-static bool svm_get_enable_apicv(struct kvm_vcpu *vcpu)
+static bool svm_get_enable_apicv(struct kvm *kvm)
 {
-	return avic && irqchip_split(vcpu->kvm);
+	return avic && irqchip_split(kvm);
 }
 
 static void svm_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5d21a4a..2aa14d5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3739,7 +3739,7 @@ void pt_update_intercept_for_msr(struct vcpu_vmx *vmx)
 	}
 }
 
-static bool vmx_get_enable_apicv(struct kvm_vcpu *vcpu)
+static bool vmx_get_enable_apicv(struct kvm *kvm)
 {
 	return enable_apicv;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ff395f8..4cbb948 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9347,7 +9347,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 		goto fail_free_pio_data;
 
 	if (irqchip_in_kernel(vcpu->kvm)) {
-		vcpu->arch.apicv_active = kvm_x86_ops->get_enable_apicv(vcpu);
+		vcpu->arch.apicv_active = kvm_x86_ops->get_enable_apicv(vcpu->kvm);
 		r = kvm_create_lapic(vcpu, lapic_timer_advance_ns);
 		if (r < 0)
 			goto fail_mmu_destroy;
-- 
1.8.3.1

