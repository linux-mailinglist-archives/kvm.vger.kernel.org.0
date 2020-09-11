Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867A72668CA
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 21:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgIKTbW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 15:31:22 -0400
Received: from mail-dm6nam12on2080.outbound.protection.outlook.com ([40.107.243.80]:23168
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725967AbgIKTbB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 15:31:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UUwivRyycJCJbXqdMI52jDXZ4OK+Yx9dLPhUS95l5sNtY3TSh+EFtj+KtUUnPy8/xKedz+Nxi7dO6ezNA1mJPetkPmLeVB2Q/c/PtOr0VWBxJg/Uaj/ArTAJaKNLbV2OYRhT/BbTl1+gK7L6W1+zCZ7lNuOls6i+EMUHH6GAn12HRjIrnVQtZ+02rgeN2CFrL2lddxJ5y5L7F8hecJ77xviajVzEdXL05G5kAmx++/E5Wkrvwwql+30JlS53GHlPFItL42DLFwbKl+QaHd5jyFNE0IJneEJYU0vLY+fAXQf/v+3uTsNqmaRyaIp/phWYsgB7QGF3WyfYwWFZKLQAbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ig/6wsw048VE9ZPJm9cY0oj5dbpCDYIjCRHQNAwOgaY=;
 b=VZ1YYlirYwtrX93IahhNr7QfkU8yvVzC4cs5fkEBR7k1eDuLL5CqVYLKx5iJMUesbZHM7h+yUW3n45qnte8hqgpNu05VxzX72haZ3EWHp2uvn0XJulp+es/75cvEPGrE+JVpU/egWXTCmhOj3wE9HwBHh7NtQxFO7tQZ8um0WyzBjCHeCdQbLz1mtMebCeGE3cBJKpxAApeG11AVZKAbNXKUCwOAfbgbBKHHqpRctqEkFUzyS5qOup5ICJAwwxlBO7aZPS62oYTUHYxPoV4EwAo3T+7BWNjvCtb5/uWYJy2jkKh0V43Eo0A0/4UbCuvCIztToynwlwuGtZwObVfj/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ig/6wsw048VE9ZPJm9cY0oj5dbpCDYIjCRHQNAwOgaY=;
 b=JTwvGTIURYwNLkQ7DHTOILKeHu8k5IH+EP0qkDO95C+Korr5ONqvHpbTqAKy1QFWiHcB+WBvbjZSGfKgAGmfia5lRRQU4dtZGV2KTrKszdFqHlWOODH635l7K1FaMtZ7D7MNKbk5goLeKCaoUg41W7Bwa2+yLWlPldrWM+3GxGA=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4543.namprd12.prod.outlook.com (2603:10b6:806:9d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Fri, 11 Sep
 2020 19:28:52 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d%4]) with mapi id 15.20.3370.017; Fri, 11 Sep 2020
 19:28:52 +0000
Subject: [PATCH v6 08/12] KVM: SVM: Remove set_cr_intercept,
 clr_cr_intercept and is_cr_intercept
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, babu.moger@amd.com,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, tglx@linutronix.de
Date:   Fri, 11 Sep 2020 14:28:50 -0500
Message-ID: <159985253016.11252.16945893859439811480.stgit@bmoger-ubuntu>
In-Reply-To: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
References: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR1101CA0001.namprd11.prod.outlook.com
 (2603:10b6:4:4c::11) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by DM5PR1101CA0001.namprd11.prod.outlook.com (2603:10b6:4:4c::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Fri, 11 Sep 2020 19:28:51 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b4da534b-f813-4756-696d-08d85688ea8e
X-MS-TrafficTypeDiagnostic: SA0PR12MB4543:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45430124C389E0A642E640BF95240@SA0PR12MB4543.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:40;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kvcRhVk8lqEvjQ8Gj0JCSqZYkYnYilwI8xDdt/B0tqSNHZXTkuxavTUckDEhIsroaar0RavwuH1wl7u/hiZyF/gB53IH0RjarSGdnhZNXA37tYzbI1dXEJo9dCfwVuSB04HthWMFgSBrMdi5nvGRN9bxDbbH5QDmtm7Ze1q0UQZ/lMJIFq4oCRM/nV7uy3xYZDf0a4b9xoGPUgkCf4z++7JnOIL+quxTtVMqb79Qhz58m9ZmLtnlErCShr3lSjBysktA2xYRMkaYQuqwxcHw7maeWDfgjBNFPgioNLy+QyoSJ1xRL/EJ2G7vh9jd0TAk4VwXJ+gsYFsb6Z0XCkDo4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(376002)(136003)(346002)(366004)(39860400002)(396003)(2906002)(956004)(66946007)(66476007)(103116003)(8676002)(66556008)(52116002)(5660300002)(7416002)(9686003)(4326008)(8936002)(44832011)(186003)(16526019)(86362001)(33716001)(16576012)(6486002)(316002)(478600001)(26005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: FqY7eG3Wg+AKBgqaE17meuXzZU7dT7AnhINp2Ot+Ry0PDezdEYydpXLLRqwXt3AxicsuNc7wt+xvXDzKNHmLr+31hEqUjEpiNijH9urFzVWvi+mIIq/NrbEdJpsxnfDmMYgmSJDK7gQMDMLpjIiRIeSJr2N6WSJhR26u1pSH7tloG00hML1IOJhzbXeSTEaGf64q67EvMXmpDuHnMgFTvNgZHY779GgANFRtNVi6zmGPA/+n5uipELRBWnyCHz4GTZFfB2FAdnLqAwYneGrm6YCAfzBdiN5L0TwdcddOfoz64IXO+Rh7tZK2EQydfvcPt0jPf0RFYkD93hFDumM1ZBCH9Q5nIZeMARBEaWBa/VG8yPVA3ND9XYJIwN3/f/rZlXJuupmCzESIRzidCi135aHwFxjN8Zl/TcGQrAXN2flS6vqWWg4fTs4FAKCna7flWYjtCIIdglMD466roiMj2sRS+m9AeNShc+rgrvGNpLyDaIaVHWHZkxULD6WrWOmTiZ/UNow6A+BIiMoqbNvpv2kc5uZ9Pvcul5IgtJnjJa5KUKYNNtWwvvD1IA2kFzOS9aDvMXiI4kkZs7T9706LUmffaUNyxhFwHB6agg8mGSct3NgP22tlbbWokhzco40obmg6CTVdO9uwY0vKIJZ1RQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4da534b-f813-4756-696d-08d85688ea8e
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2020 19:28:52.5037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w38KTf8h0bEE6I8qbx/Ac/AOTiJbEZIpUqWRHFMDHHVzYkOpdtutLMgzx7PkHJTT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4543
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove set_cr_intercept, clr_cr_intercept and is_cr_intercept. Instead
call generic svm_set_intercept, svm_clr_intercept an dsvm_is_intercep
tfor all cr intercepts.

Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/svm.c |   34 +++++++++++++++++-----------------
 arch/x86/kvm/svm/svm.h |   25 -------------------------
 2 files changed, 17 insertions(+), 42 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 17bfa34033ac..0d7397f4a4f7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -992,14 +992,14 @@ static void init_vmcb(struct vcpu_svm *svm)
 
 	svm->vcpu.arch.hflags = 0;
 
-	set_cr_intercept(svm, INTERCEPT_CR0_READ);
-	set_cr_intercept(svm, INTERCEPT_CR3_READ);
-	set_cr_intercept(svm, INTERCEPT_CR4_READ);
-	set_cr_intercept(svm, INTERCEPT_CR0_WRITE);
-	set_cr_intercept(svm, INTERCEPT_CR3_WRITE);
-	set_cr_intercept(svm, INTERCEPT_CR4_WRITE);
+	svm_set_intercept(svm, INTERCEPT_CR0_READ);
+	svm_set_intercept(svm, INTERCEPT_CR3_READ);
+	svm_set_intercept(svm, INTERCEPT_CR4_READ);
+	svm_set_intercept(svm, INTERCEPT_CR0_WRITE);
+	svm_set_intercept(svm, INTERCEPT_CR3_WRITE);
+	svm_set_intercept(svm, INTERCEPT_CR4_WRITE);
 	if (!kvm_vcpu_apicv_active(&svm->vcpu))
-		set_cr_intercept(svm, INTERCEPT_CR8_WRITE);
+		svm_set_intercept(svm, INTERCEPT_CR8_WRITE);
 
 	set_dr_intercepts(svm);
 
@@ -1094,8 +1094,8 @@ static void init_vmcb(struct vcpu_svm *svm)
 		control->nested_ctl |= SVM_NESTED_CTL_NP_ENABLE;
 		svm_clr_intercept(svm, INTERCEPT_INVLPG);
 		clr_exception_intercept(svm, INTERCEPT_PF_VECTOR);
-		clr_cr_intercept(svm, INTERCEPT_CR3_READ);
-		clr_cr_intercept(svm, INTERCEPT_CR3_WRITE);
+		svm_clr_intercept(svm, INTERCEPT_CR3_READ);
+		svm_clr_intercept(svm, INTERCEPT_CR3_WRITE);
 		save->g_pat = svm->vcpu.arch.pat;
 		save->cr3 = 0;
 		save->cr4 = 0;
@@ -1549,11 +1549,11 @@ static void update_cr0_intercept(struct vcpu_svm *svm)
 	vmcb_mark_dirty(svm->vmcb, VMCB_CR);
 
 	if (gcr0 == *hcr0) {
-		clr_cr_intercept(svm, INTERCEPT_CR0_READ);
-		clr_cr_intercept(svm, INTERCEPT_CR0_WRITE);
+		svm_clr_intercept(svm, INTERCEPT_CR0_READ);
+		svm_clr_intercept(svm, INTERCEPT_CR0_WRITE);
 	} else {
-		set_cr_intercept(svm, INTERCEPT_CR0_READ);
-		set_cr_intercept(svm, INTERCEPT_CR0_WRITE);
+		svm_set_intercept(svm, INTERCEPT_CR0_READ);
+		svm_set_intercept(svm, INTERCEPT_CR0_WRITE);
 	}
 }
 
@@ -2931,7 +2931,7 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 
 	trace_kvm_exit(exit_code, vcpu, KVM_ISA_SVM);
 
-	if (!is_cr_intercept(svm, INTERCEPT_CR0_WRITE))
+	if (!svm_is_intercept(svm, INTERCEPT_CR0_WRITE))
 		vcpu->arch.cr0 = svm->vmcb->save.cr0;
 	if (npt_enabled)
 		vcpu->arch.cr3 = svm->vmcb->save.cr3;
@@ -3056,13 +3056,13 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 	if (nested_svm_virtualize_tpr(vcpu))
 		return;
 
-	clr_cr_intercept(svm, INTERCEPT_CR8_WRITE);
+	svm_clr_intercept(svm, INTERCEPT_CR8_WRITE);
 
 	if (irr == -1)
 		return;
 
 	if (tpr >= irr)
-		set_cr_intercept(svm, INTERCEPT_CR8_WRITE);
+		svm_set_intercept(svm, INTERCEPT_CR8_WRITE);
 }
 
 bool svm_nmi_blocked(struct kvm_vcpu *vcpu)
@@ -3250,7 +3250,7 @@ static inline void sync_cr8_to_lapic(struct kvm_vcpu *vcpu)
 	if (nested_svm_virtualize_tpr(vcpu))
 		return;
 
-	if (!is_cr_intercept(svm, INTERCEPT_CR8_WRITE)) {
+	if (!svm_is_intercept(svm, INTERCEPT_CR8_WRITE)) {
 		int cr8 = svm->vmcb->control.int_ctl & V_TPR_MASK;
 		kvm_set_cr8(vcpu, cr8);
 	}
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index ffb35a83048f..8128bac75fa2 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -228,31 +228,6 @@ static inline bool vmcb_is_intercept(struct vmcb_control_area *control, int bit)
 	return test_bit(bit, (unsigned long *)&control->intercepts);
 }
 
-static inline void set_cr_intercept(struct vcpu_svm *svm, int bit)
-{
-	struct vmcb *vmcb = get_host_vmcb(svm);
-
-	vmcb_set_intercept(&vmcb->control, bit);
-
-	recalc_intercepts(svm);
-}
-
-static inline void clr_cr_intercept(struct vcpu_svm *svm, int bit)
-{
-	struct vmcb *vmcb = get_host_vmcb(svm);
-
-	vmcb_clr_intercept(&vmcb->control, bit);
-
-	recalc_intercepts(svm);
-}
-
-static inline bool is_cr_intercept(struct vcpu_svm *svm, int bit)
-{
-	struct vmcb *vmcb = get_host_vmcb(svm);
-
-	return vmcb_is_intercept(&vmcb->control, bit);
-}
-
 static inline void set_dr_intercepts(struct vcpu_svm *svm)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);

