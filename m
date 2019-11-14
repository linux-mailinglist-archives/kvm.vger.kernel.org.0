Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE28FFCF85
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 21:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbfKNUPt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 15:15:49 -0500
Received: from mail-eopbgr730059.outbound.protection.outlook.com ([40.107.73.59]:60877
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727178AbfKNUPr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 15:15:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n+3eDtMiT2pbsuFQg8GXOGAT9rQ6P8MBp5W5axqD8TSRx3D7SKH/eNsEdg0mbECmoooKlw4ZWaWJgi+EVBT9t+56j3vCEJNh03JlGO/7KPc5Bhq4L5Hu/cuVEBjDDgaWO/8kXDY3ztosEIRUFeEM1/4ci0b2zTBAg4DNC+q9VHlSlTwhvGqyyk2soOP9FR0hfUO0Ud4ZKkDT37DN0+P8UiETU1Un6oMsaX/KkqgQvAJJ7VC/SQGBBfdG8J3wxVEcldJ2ZQ9/XWKdehQaFobUH9ydmf1A/U3z4R5djSxyHQFuz3xtRHUoYQcNdpayD7lNVlhyDpWlSW5heEv+wZRxqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qKaW3WqHK3n0YLFAVVGF0ft5+UKKUPTa98GpufIq8FE=;
 b=eQsGTdDRFpUW4+D6y1lw75KahVOeyG6+elnKoNenaQdYdTcFcXJqpvxrbEMhhNlag6mivTAiS2y9IGOlntmOoeo3s9WwccNKmBE6dDUB6IjA92R2PtJm/GdFUXDVDuRDXpdkiMCtsFnmMXuXy3ng53BvK4kAC6lJjxk4Vl4YOzmHtNiFZ8jU7mZJWIzYyGcavgCtgip/wXb6HVURSl5MLt7kCLnBO9pEFrLKea5LH5BLZ4sQ4dMq4pvYcYK413GignEeLbPmxqaNzrbGNkB1AAIwXDRvnOoTFn6+tnjQMxCidJ2O6elbCzCKs9jX82Yh1Y64J9iU707ZTOQkeJsh7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qKaW3WqHK3n0YLFAVVGF0ft5+UKKUPTa98GpufIq8FE=;
 b=CwTE0/LG1AdDxHKpRTY8Kqs3ZAorVscdf+V2b1IRRCPyGZ0hxh5WXkLMMpCHOV76jBdscWt4ib34/4YYc8wX0ARS+pKDSBohXIHHTYM+9i45cs5XgUc5ZqeLhTF9u3IAmapqOrfssFxfxbHw+XK371zg6V5UW/rGYHXpy0wj9E0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3739.namprd12.prod.outlook.com (10.255.172.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Thu, 14 Nov 2019 20:15:38 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2451.027; Thu, 14 Nov 2019
 20:15:38 +0000
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, joro@8bytes.org,
        vkuznets@redhat.com, rkagan@virtuozzo.com, graf@amazon.com,
        jschoenh@amazon.de, karahmed@amazon.de, rimasluk@amazon.com,
        jon.grimm@amd.com,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v5 06/18] kvm: x86: svm: Add support to (de)activate posted interrupts
Date:   Thu, 14 Nov 2019 14:15:08 -0600
Message-Id: <1573762520-80328-7-git-send-email-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 8fbf26b2-0d4c-4fb8-ac49-08d7693f6a84
X-MS-TrafficTypeDiagnostic: DM6PR12MB3739:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB373916E40ADDF20AF92F86E0F3710@DM6PR12MB3739.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:303;
X-Forefront-PRVS: 02213C82F8
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(376002)(39860400002)(346002)(136003)(189003)(199004)(6506007)(25786009)(86362001)(6512007)(6436002)(8676002)(47776003)(7416002)(66066001)(6486002)(50226002)(4326008)(3846002)(8936002)(4720700003)(81156014)(2906002)(16586007)(7736002)(66556008)(305945005)(66476007)(2616005)(6116002)(66946007)(186003)(316002)(14454004)(486006)(478600001)(99286004)(81166006)(26005)(14444005)(476003)(5660300002)(44832011)(386003)(446003)(52116002)(51416003)(76176011)(50466002)(6666004)(36756003)(11346002)(48376002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3739;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0sXIkTChCfHi6eYIVIP1Ir0AUxjwjHGh+poc5RZJQNRGUcbfsoMA5eWZT0UNyL836j0wRkccj0ENMutxQgwOidE+AkBiHTlVfsAv9FEhlmDD8s3q9hcMx+Q45ku6k5+oKGoR7eFaPA2vraIihnAA2g8BFW99RBTTsKAUNqxc97ahAoS4kD7lP6C49hn3Z8cGnU7tX6oaTCR+Rb5cufKauBqQYEV/Ec4/Vm+0diGfXrI6EIR2UC3Qr1cieQecuSWFjsol5gds0dEAFKcUdqhg2dKG8Zoggr60hGk7t/lLU3vtephjaMI59y2NwRl50NdgxS2aGgAaXw3v2la5vRQ3PZgityQ5cW7W2tU9EjnQ5pUrAr4WZDenVD7/v32Qp9rDQAO8F4WF0Yyyuk9pA7rPmNHiNF2zLSCZo0ZdGG0rdVSyt1mCiFniFuS6qbPnyZs0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fbf26b2-0d4c-4fb8-ac49-08d7693f6a84
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2019 20:15:38.8589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xmNhbGH8NeyC8o0tjl+pluhtpvIgxNfif1DcLl0h+cK6Yo/xOnUa4Q0tsnmw10DjEhLjNDE++so4xiKPN9WjMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3739
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce interface for (de)activate posted interrupts, and
implement SVM hooks to toggle AMD IOMMU guest virtual APIC mode.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm.c | 37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 3395e4c..38401f9 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5134,17 +5134,52 @@ static void svm_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
 {
 }
 
+static int svm_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
+{
+	int ret = 0;
+	unsigned long flags;
+	struct amd_svm_iommu_ir *ir;
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (!kvm_arch_has_assigned_device(vcpu->kvm))
+		return 0;
+
+	/*
+	 * Here, we go through the per-vcpu ir_list to update all existing
+	 * interrupt remapping table entry targeting this vcpu.
+	 */
+	spin_lock_irqsave(&svm->ir_list_lock, flags);
+
+	if (list_empty(&svm->ir_list))
+		goto out;
+
+	list_for_each_entry(ir, &svm->ir_list, node) {
+		if (activate)
+			ret = amd_iommu_activate_guest_mode(ir->data);
+		else
+			ret = amd_iommu_deactivate_guest_mode(ir->data);
+		if (ret)
+			break;
+	}
+out:
+	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
+	return ret;
+}
+
 /* Note: Currently only used by Hyper-V. */
 static void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb *vmcb = svm->vmcb;
+	bool activated = kvm_vcpu_apicv_active(vcpu);
 
-	if (kvm_vcpu_apicv_active(vcpu))
+	if (activated)
 		vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
 	else
 		vmcb->control.int_ctl &= ~AVIC_ENABLE_MASK;
 	mark_dirty(vmcb, VMCB_AVIC);
+
+	svm_set_pi_irte_mode(vcpu, activated);
 }
 
 static void svm_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
-- 
1.8.3.1

