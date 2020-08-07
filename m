Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF02423E555
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 02:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgHGArU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 20:47:20 -0400
Received: from mail-dm6nam12on2052.outbound.protection.outlook.com ([40.107.243.52]:53217
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726845AbgHGArT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Aug 2020 20:47:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=doVC5UVNc06B64mRBuZ+clV+j+tEnGutCOcKmAmVafqHEbJgULi8esCjg7fkX1UjiqeqUU9ZCD7pfTgzIjfJgcFDJwtD6+tqC1z3Eu5nbDrpeW6OI7TAJYHE6X4dQhyfozOu/Frpjq5dPzJCXKUHT6hHz5FcX0sUmHhAKPJDRnPn3iG/LeMiDSaBmURPKE5qfLXrkcZK9/iRhdoRiyEOwCUNDMztzMLKxkRaxS1Gbe7I33TUIake1rVbtPulFkVKui0u9NF7WbZvgvnnSNU/6FoRNXjo8Pi25ftB8M+EMLAEAT7/Az4kuFhgw1jOTV1nsMx+98sMC18CIDUqsUa61w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gcn+PDyVWiZ5BWEFkJ0PL3+4l3UCjnMBz5UVdGFUwho=;
 b=Z0qs8MG+d8Fam1CnQBK9Njxn0c5HlwBVKoJOP8UpZQSdSndBDAXkCFlWTrJLJ4wPNMVOJXx6T+UkeYl0ibqbt8ada9GBBIm5Aw7cwFd4282TM2MaLlj+TzpWHr+XMxezUgtWZJIWWA46PzU0WYv3RxVQZ2bb9STuJx3LV2HyV/iSapd3Lh8IbkcxqtCBQ3F/oWPScpftp8e/NxLTh8x/weswZiUNqlDUJKZAd5suzRGT7c89isPMAsZaVhyB2Pq9dyacZ6SSOZRc+bKVs8hK8wTZRwGzY3m2KeWdeuzMw3jz3xK5pB8oyobTLNS02rlrxm8ry41McDWPWhZdZcg/VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gcn+PDyVWiZ5BWEFkJ0PL3+4l3UCjnMBz5UVdGFUwho=;
 b=0Df6oRfNnAYzwgTCLSLLK98w41xDVQ8KiKRfrb83042sVrZjp5OMvxmL8pm3IwgvCbW+07Pb4icSTiJCJi2gR5Yz9ANc67h6JJH3oYL68a/koUTWbV+6JsiY4OnW5KuO0cP7ILDduBJOaaAH+N5l4VHaSCEhT/DkBa4DvwreIHA=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4479.namprd12.prod.outlook.com (2603:10b6:806:95::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Fri, 7 Aug
 2020 00:47:16 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c%6]) with mapi id 15.20.3239.023; Fri, 7 Aug 2020
 00:47:16 +0000
Subject: [PATCH v4 08/12] KVM: SVM: Remove set_cr_intercept,
 clr_cr_intercept and is_cr_intercept
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     kvm@vger.kernel.org, joro@8bytes.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, tglx@linutronix.de
Date:   Thu, 06 Aug 2020 19:47:13 -0500
Message-ID: <159676123395.12805.16488410340966484419.stgit@bmoger-ubuntu>
In-Reply-To: <159676101387.12805.18038347880482984693.stgit@bmoger-ubuntu>
References: <159676101387.12805.18038347880482984693.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0028.namprd05.prod.outlook.com
 (2603:10b6:803:40::41) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN4PR0501CA0028.namprd05.prod.outlook.com (2603:10b6:803:40::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.6 via Frontend Transport; Fri, 7 Aug 2020 00:47:14 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7b33244e-f071-4e77-f77f-08d83a6b6e5f
X-MS-TrafficTypeDiagnostic: SA0PR12MB4479:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4479EB3CCA3A8655C13E76F495490@SA0PR12MB4479.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:106;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TqYIRbW4d8CwZvPjj9pzbo1lpjEbwgf/cC11XLsOL5Jl5TMrXNWYdw9BZRMZhJHWKOTyNkpiTEscKTnLx6RIWgXYTNxRB1Gh4t9E1qQvIucX1fRYHXOsxDYpiE3XUUbo7JpRewspNOfnXjKRuHoTV+2WB/tlQqtU/exaEDetyjCFHI/oLZrE0pb1ihcLf5NYeLkqchMtsegtJtrqmGrnhTU6oMiBOAO49Xdg909B6SHbA1wr2NDjGmpBFtDIpxy5kpVfXvYDpLb7dreRJdeyq52lJbuM70URHoeRy2FiyrvGdFTbU/DLWATs+/CIhPy7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(7916004)(39860400002)(396003)(376002)(346002)(136003)(366004)(5660300002)(6486002)(52116002)(2906002)(16576012)(4326008)(83380400001)(7416002)(956004)(44832011)(33716001)(26005)(9686003)(8676002)(66476007)(66556008)(103116003)(66946007)(8936002)(86362001)(16526019)(186003)(478600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: mYmSWAUnL4jw1+qo0kqQ/AEBqVd7YIt0xbzNwFkxB33fnmX3AJTGVeK/eCXkPaKyCGFBfCM9mCWHUtORk/olkeb2vcVkvFebx32ZnlthEZLWppZ9zVS88AtYatNwvaYxNtIrAYL7xgBfCJZMkZCvAr8vD1OCXUBjEdLTh784JZN4+1GLlYPE+k9YGGWLTDqYLFoSIxkUxSZBr/oFceHsuT0RebOMPfTC3SH86hCgkZXlln/a3dMwtd9H7fQ5Ni3CHzVXSZn5hV1UhNBU6qd3Mo7+fekWnSRrmo6nCyE7kuuL1fZs8IkobOHnXgV43LhrvEIdHk0PVqIzSpmFLSDcqt+Gl/tjc4HT4nNeoH4/PkwVL9k+TN7Czk+R+OeXvmnXRHMiMxOyzQ4qPSyCijUaIy4sEl5QsiGMJ74L+XJzPEylbw64wGmbsK7nAX4UwSYoPlcjQio73vJ2UL95Chr17XR138gCZNMeSofVuTRmXE7GpahQkWjDFwItZhAQWtlE+YMXm/KSxM+LTZfcpKG/73vZ1NfA1GaYJ8OC6+Q0MRYGhc6QdEh+BkP7UdopXg88CAbCs0rTfnH1NkTm8RGz23uB9oD/8/Oq+yTdtjtCFenX2xqV0YhGceHq0HnTK4Gr5sYHUpdFx5yfitd3p6fbHg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b33244e-f071-4e77-f77f-08d83a6b6e5f
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2020 00:47:16.2268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tl6yjEqXYR4SPZ21mJX3Ik6KntmwSsv87kmdfeqj2Mwm8pQieUJUKDDm0RwsIUn8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4479
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove set_cr_intercept, clr_cr_intercept and is_cr_intercept. Instead
call generic set_intercept, clr_intercept and is_intercept for all
cr intercepts.

Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/svm.c |   34 +++++++++++++++++-----------------
 arch/x86/kvm/svm/svm.h |   25 -------------------------
 2 files changed, 17 insertions(+), 42 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9bafb025df05..b40ed18cb5c2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -977,14 +977,14 @@ static void init_vmcb(struct vcpu_svm *svm)
 
 	svm->vcpu.arch.hflags = 0;
 
-	set_cr_intercept(svm, INTERCEPT_CR0_READ);
-	set_cr_intercept(svm, INTERCEPT_CR3_READ);
-	set_cr_intercept(svm, INTERCEPT_CR4_READ);
-	set_cr_intercept(svm, INTERCEPT_CR0_WRITE);
-	set_cr_intercept(svm, INTERCEPT_CR3_WRITE);
-	set_cr_intercept(svm, INTERCEPT_CR4_WRITE);
+	set_intercept(svm, INTERCEPT_CR0_READ);
+	set_intercept(svm, INTERCEPT_CR3_READ);
+	set_intercept(svm, INTERCEPT_CR4_READ);
+	set_intercept(svm, INTERCEPT_CR0_WRITE);
+	set_intercept(svm, INTERCEPT_CR3_WRITE);
+	set_intercept(svm, INTERCEPT_CR4_WRITE);
 	if (!kvm_vcpu_apicv_active(&svm->vcpu))
-		set_cr_intercept(svm, INTERCEPT_CR8_WRITE);
+		set_intercept(svm, INTERCEPT_CR8_WRITE);
 
 	set_dr_intercepts(svm);
 
@@ -1079,8 +1079,8 @@ static void init_vmcb(struct vcpu_svm *svm)
 		control->nested_ctl |= SVM_NESTED_CTL_NP_ENABLE;
 		clr_intercept(svm, INTERCEPT_INVLPG);
 		clr_exception_intercept(svm, INTERCEPT_PF_VECTOR);
-		clr_cr_intercept(svm, INTERCEPT_CR3_READ);
-		clr_cr_intercept(svm, INTERCEPT_CR3_WRITE);
+		clr_intercept(svm, INTERCEPT_CR3_READ);
+		clr_intercept(svm, INTERCEPT_CR3_WRITE);
 		save->g_pat = svm->vcpu.arch.pat;
 		save->cr3 = 0;
 		save->cr4 = 0;
@@ -1534,11 +1534,11 @@ static void update_cr0_intercept(struct vcpu_svm *svm)
 	mark_dirty(svm->vmcb, VMCB_CR);
 
 	if (gcr0 == *hcr0) {
-		clr_cr_intercept(svm, INTERCEPT_CR0_READ);
-		clr_cr_intercept(svm, INTERCEPT_CR0_WRITE);
+		clr_intercept(svm, INTERCEPT_CR0_READ);
+		clr_intercept(svm, INTERCEPT_CR0_WRITE);
 	} else {
-		set_cr_intercept(svm, INTERCEPT_CR0_READ);
-		set_cr_intercept(svm, INTERCEPT_CR0_WRITE);
+		set_intercept(svm, INTERCEPT_CR0_READ);
+		set_intercept(svm, INTERCEPT_CR0_WRITE);
 	}
 }
 
@@ -2915,7 +2915,7 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 
 	trace_kvm_exit(exit_code, vcpu, KVM_ISA_SVM);
 
-	if (!is_cr_intercept(svm, INTERCEPT_CR0_WRITE))
+	if (!is_intercept(svm, INTERCEPT_CR0_WRITE))
 		vcpu->arch.cr0 = svm->vmcb->save.cr0;
 	if (npt_enabled)
 		vcpu->arch.cr3 = svm->vmcb->save.cr3;
@@ -3041,13 +3041,13 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 	if (svm_nested_virtualize_tpr(vcpu))
 		return;
 
-	clr_cr_intercept(svm, INTERCEPT_CR8_WRITE);
+	clr_intercept(svm, INTERCEPT_CR8_WRITE);
 
 	if (irr == -1)
 		return;
 
 	if (tpr >= irr)
-		set_cr_intercept(svm, INTERCEPT_CR8_WRITE);
+		set_intercept(svm, INTERCEPT_CR8_WRITE);
 }
 
 bool svm_nmi_blocked(struct kvm_vcpu *vcpu)
@@ -3235,7 +3235,7 @@ static inline void sync_cr8_to_lapic(struct kvm_vcpu *vcpu)
 	if (svm_nested_virtualize_tpr(vcpu))
 		return;
 
-	if (!is_cr_intercept(svm, INTERCEPT_CR8_WRITE)) {
+	if (!is_intercept(svm, INTERCEPT_CR8_WRITE)) {
 		int cr8 = svm->vmcb->control.int_ctl & V_TPR_MASK;
 		kvm_set_cr8(vcpu, cr8);
 	}
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0025d6f2641f..6c3f0e1c4555 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -231,31 +231,6 @@ static inline bool vmcb_is_intercept(struct vmcb_control_area *control, int bit)
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

