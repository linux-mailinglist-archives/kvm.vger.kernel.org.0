Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C07E2B6B2E
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 18:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbgKQRI5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 12:08:57 -0500
Received: from mail-dm6nam11on2052.outbound.protection.outlook.com ([40.107.223.52]:19136
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728487AbgKQRI4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 12:08:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MxWK0M6WK7elXd6ZThcqyTRcI892/PO5uMFQTn1WdnzSNyZJ1J2s2G9dxBwuqUX8LSaXayS3MpL9CGdju36emaoEpodO+A/Fy2W7m9OdbagdcAu3sHm0vFtdp68lmu93bp82OHIB/O/N6Wfs/nw2L69lfadQciO/HzjCIZlN3M2DJL+cibF87NETAZhMsKGjsfdKyBhDGNIKZX6Qfw35vH7Z+59qvcs6M5OHjTNOfWZBpGinjxPrxAtNX214Req70B6OR8Zv/5w0qo1Myr+nd0nyR2wB/6bkXPeiiRWsaqMExGcUSYIRhf65I4VpK60qQ+eSoaJPOS4VQUtaaJ/xAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pz6XKK5knHG3n+HFC+WTUWLA+DRNa2OYCXiU9WPJ3EU=;
 b=bGF7M0ohnu3fXX19waYvWCYWMgSABELSLGsLl0Wl8XnY1fU7do6vr3pSPDi08/2vKEd5+QFrP7XPlqXluNjaYVgomUpmutOGryZIhb8w/J4h+8atrACjqxNMZVeYq/dbA4O4rRPQ2lAWSjcjVD2Ur9wGLno7vd02XoARbc4P6n7EbiJpOs6x22pkReAzraBSUSVk1pCf7unFYCTz9C5ifvxnzcsID91+B+l9WFYyg33v6nRN5nbIQiLKHxEwvJpvid7gA7WagFoq6YpUAYvtB/Ws+r0IX3KLFUTZL42mTdZes7sNSTcX8p9go7WfgccQSTEyOLTo/lEofD1t1g0/uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pz6XKK5knHG3n+HFC+WTUWLA+DRNa2OYCXiU9WPJ3EU=;
 b=xVhUOSVOrknXFZGLh6BJLKoS/KXFXZ8kXcw5qtn2ITRZbJeA/jtw4JxqTfG2yXrCanvUP+IxyOlK3li9+nDdEE5dVRTgOhwP9qNYuA0Az8J9Ay5jycG9QFRbk5yRBUHPTosCL0uv/kCqfZdLv9VDEBQltEe0Jkmo3K24hMTX6II=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1772.namprd12.prod.outlook.com (2603:10b6:3:107::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.25; Tue, 17 Nov 2020 17:08:51 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Tue, 17 Nov
 2020 17:08:51 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v4 08/34] KVM: SVM: Prevent debugging under SEV-ES
Date:   Tue, 17 Nov 2020 11:07:11 -0600
Message-Id: <ca28a6232e479849139d8de41b8f6e3f512de381.1605632857.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1605632857.git.thomas.lendacky@amd.com>
References: <cover.1605632857.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM6PR14CA0054.namprd14.prod.outlook.com
 (2603:10b6:5:18f::31) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM6PR14CA0054.namprd14.prod.outlook.com (2603:10b6:5:18f::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Tue, 17 Nov 2020 17:08:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: de351532-4d12-4cef-3f1d-08d88b1b74a2
X-MS-TrafficTypeDiagnostic: DM5PR12MB1772:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB17727B816FC70A11C3476A57ECE20@DM5PR12MB1772.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1002;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nnpHNu1hv9ikOrELYOI8/Z2TXlUXJxr27TW1Joqlem4dAyZu1F7e1DpsMGVkNy6RKtacr62h3wc5IE82ZfNQAhK1oKNQUqQAu8yJVytlLbvKdxdGP5KhLcmuAT0EmMjqn7Z9D+lLtmb21XhXM50PYJxcaQpivv/aItVbE3rixKs5UEztIff9D1RuDsmYOS4widyO4t/xM5G/4sXJNuObsxUW0SmngSrCouJFPy9AYXWTGebP+hn9mCH4DGSJqDUTYdox0Tk+AmPN04+6ABDSdMQDtYKUqMHkX+jdUgyripXBYncFBZif2eQOSPIP6Kq4N10otONpYLb3kZx5BqpRhQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(6486002)(66476007)(66946007)(8936002)(83380400001)(5660300002)(26005)(478600001)(66556008)(16526019)(6666004)(186003)(36756003)(86362001)(8676002)(316002)(956004)(52116002)(4326008)(54906003)(7696005)(7416002)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: DZZOSluKAEUJvS/JxzJpWbPZq01JWr0WTjTcq/fOMhyqw1lRCdZeB/OTzTwTrMWx2BQ8zxrk56uZOM7G8MOBeucROnM6pV7vk7Bon+KpzVt2KYgwreIpXSSxf9GyiZMP7qf9uxt0e6+0B2stz59SAlcw/gZBsuOppS+Vr12FNShUraqepGanf11yaVmmenrH/ZX7jcyXmdv8cwVy3YtLYnJc/ODtRtEuN7qdQb8yZYYugQbvWzYWgemNoMtxNKoK9aNM02DHDt0J9J83UXwRrGYAqffiI6bBzAgzT0U67nVW81D0NC20N803OeBL/0k7zF2lEh0sezzuBsGnHtLcjN7kLXk6+ggOYWFK8CvPG2/0OKV1k8ogtchcF4+fRcEXHqJcpHY6x2nd3tvwaRddZ/xG0AE6G2PdqnRXE9bvKa+RQNXg/WcIP+CammlbMLCu3UxCtHaupzN6KX41N6HqcvjVyZFpADsItRqS0QISkHcpXnWJbdDoW7ixX5Tf5TeBAVYbwXMYmcTVEZZRKFX6H60a+rxDbdcTefLysVNZmpTQ7Yhw7KFBTpV+XxEv3+d1Rwf4Cql3UbbIGrqm2vkzVxJmY/eYIUsDSjJ/DSXLQC/sZdzRVA9j8kZxK/QN3ZjrTRGjsBrwRQ+Lk+JlCVUUuw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de351532-4d12-4cef-3f1d-08d88b1b74a2
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 17:08:51.1992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UCueKn2sYpsl87ojK4rZxDplu4DLI4wqlXSmeH++u2+bnK+8tvky8bpf+jFm+ySdCJXwoqJ7BIqqe+ZYgZtdsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1772
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Since the guest register state of an SEV-ES guest is encrypted, debugging
is not supported. Update the code to prevent guest debugging when the
guest has protected state.

Additionally, an SEV-ES guest must only and always intercept DR7 reads and
writes. Update set_dr_intercepts() and clr_dr_intercepts() to account for
this.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/svm.c |  9 +++++
 arch/x86/kvm/svm/svm.h | 81 +++++++++++++++++++++++-------------------
 arch/x86/kvm/x86.c     |  3 ++
 3 files changed, 57 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9a3d57ed997f..7f805cd5bbe7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1802,6 +1802,9 @@ static void svm_set_dr6(struct vcpu_svm *svm, unsigned long value)
 {
 	struct vmcb *vmcb = svm->vmcb;
 
+	if (svm->vcpu.arch.guest_state_protected)
+		return;
+
 	if (unlikely(value != vmcb->save.dr6)) {
 		vmcb->save.dr6 = value;
 		vmcb_mark_dirty(vmcb, VMCB_DR);
@@ -1812,6 +1815,9 @@ static void svm_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (vcpu->arch.guest_state_protected)
+		return;
+
 	get_debugreg(vcpu->arch.db[0], 0);
 	get_debugreg(vcpu->arch.db[1], 1);
 	get_debugreg(vcpu->arch.db[2], 2);
@@ -1830,6 +1836,9 @@ static void svm_set_dr7(struct kvm_vcpu *vcpu, unsigned long value)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (vcpu->arch.guest_state_protected)
+		return;
+
 	svm->vmcb->save.dr7 = value;
 	vmcb_mark_dirty(svm->vmcb, VMCB_DR);
 }
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 8f0a3ed0d790..66ea889f71ed 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -198,6 +198,28 @@ static inline struct kvm_svm *to_kvm_svm(struct kvm *kvm)
 	return container_of(kvm, struct kvm_svm, kvm);
 }
 
+static inline bool sev_guest(struct kvm *kvm)
+{
+#ifdef CONFIG_KVM_AMD_SEV
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+
+	return sev->active;
+#else
+	return false;
+#endif
+}
+
+static inline bool sev_es_guest(struct kvm *kvm)
+{
+#ifdef CONFIG_KVM_AMD_SEV
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+
+	return sev_guest(kvm) && sev->es_active;
+#else
+	return false;
+#endif
+}
+
 static inline void vmcb_mark_all_dirty(struct vmcb *vmcb)
 {
 	vmcb->control.clean = 0;
@@ -249,21 +271,24 @@ static inline void set_dr_intercepts(struct vcpu_svm *svm)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);
 
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_READ);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_READ);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_READ);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_READ);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_READ);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_READ);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_READ);
+	if (!sev_es_guest(svm->vcpu.kvm)) {
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_WRITE);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_WRITE);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_WRITE);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_WRITE);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_WRITE);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_WRITE);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_WRITE);
+	}
+
 	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_WRITE);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_WRITE);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_WRITE);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_WRITE);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_WRITE);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_WRITE);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_WRITE);
 	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
 
 	recalc_intercepts(svm);
@@ -275,6 +300,12 @@ static inline void clr_dr_intercepts(struct vcpu_svm *svm)
 
 	vmcb->control.intercepts[INTERCEPT_DR] = 0;
 
+	/* DR7 access must remain intercepted for an SEV-ES guest */
+	if (sev_es_guest(svm->vcpu.kvm)) {
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
+	}
+
 	recalc_intercepts(svm);
 }
 
@@ -480,28 +511,6 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
 
 extern unsigned int max_sev_asid;
 
-static inline bool sev_guest(struct kvm *kvm)
-{
-#ifdef CONFIG_KVM_AMD_SEV
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-
-	return sev->active;
-#else
-	return false;
-#endif
-}
-
-static inline bool sev_es_guest(struct kvm *kvm)
-{
-#ifdef CONFIG_KVM_AMD_SEV
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-
-	return sev_guest(kvm) && sev->es_active;
-#else
-	return false;
-#endif
-}
-
 static inline bool svm_sev_enabled(void)
 {
 	return IS_ENABLED(CONFIG_KVM_AMD_SEV) ? max_sev_asid : 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3aafbd2540be..569fbdb4ee87 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9663,6 +9663,9 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 	unsigned long rflags;
 	int i, r;
 
+	if (vcpu->arch.guest_state_protected)
+		return -EINVAL;
+
 	vcpu_load(vcpu);
 
 	if (dbg->control & (KVM_GUESTDBG_INJECT_DB | KVM_GUESTDBG_INJECT_BP)) {
-- 
2.28.0

