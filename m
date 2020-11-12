Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED712AFD41
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 02:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbgKLBb5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 20:31:57 -0500
Received: from mail-dm6nam12on2045.outbound.protection.outlook.com ([40.107.243.45]:4065
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728062AbgKLA3D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Nov 2020 19:29:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KFHPmfM0fyLyDFislKF+yBwKo06mNBbb3zxHOlMsSEThcj+7ELqnWYqvFDjFBYhZBPv1U+VExShfxwcNzvGXJOtNEJ5bKVp8UAcBWLUiThWT/88q81/kI2rfK0rMZ1pF8BtZ+GDpCL3tsAPh1jnN1yDFAvhbYMV45sLfq9BsT/xnkiDWHBUT3yIkPbpP4/HB7/TCb9LYWUTWTHuAqJq92G5S75XP0FYg15ahWrrkoUS9nVRT9XvRdIlvPV0BixqVmMWauz2MbVdtdRM0zzgedMp9CIBNh0Ler78Tir/rrZCHYEq83tHwgEVxGuiHARUJu3SGPvUijFVHbVzOhOoKHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=24Aa+945JfFYUIpfbPY+NXHYF2KeL55BSIt0YsaL1OA=;
 b=A00frcLCQmHfIXepffxysKY1b/AgNsYeRkdz4zU6QdbMmGfTFoUebSLAPb3k/JUUVeuQFov3wuFVlWq4FYt/uEgdqMzuRBHdBLpf+cXUhubf6t8O+1di3E7J9q+V2ZpzFkEr4NiY1MQt9M+oV8YI1gyB4NwJZbZY+rSlZ3fD+90PibtLsZaX1fBRQyrvfQ8OQd9FDIYpWliyOQsTBENMZVu9wWXQ9cMlKAt+MCO9BnQ3yXcHGP+S+9SkjJUarCaar3AQiFaSPugRnPPFbGrJeo+niGC43kinlP/ht7xJmKd5pbMfguqtk8r0PVJ0KPxZ3wRktSL9hGATCd0TAzOd3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=24Aa+945JfFYUIpfbPY+NXHYF2KeL55BSIt0YsaL1OA=;
 b=ZDugBmcfYCW/Her/8W/IMbd/rmljsUGGbqhPnqHW9WnBo01FBOikkm/mp8YktTezWmEZ6Bvt8HL872NBQE+xa9pKILlpAZrcudFHkbrQEg0W2OkszH0eZ7VBOHW4Q2YbIlJOQgvs1jBcHTcoaOed7ZYyVAwDt6fK0ooeqlBoexk=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN6PR12MB4685.namprd12.prod.outlook.com (2603:10b6:805:b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Thu, 12 Nov
 2020 00:28:28 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::d877:baf6:9425:ece]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::d877:baf6:9425:ece%3]) with mapi id 15.20.3541.026; Thu, 12 Nov 2020
 00:28:28 +0000
Subject: [PATCH 2/2] KVM:SVM: Mask SEV encryption bit from CR3 reserved bits
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com
Cc:     junaids@google.com, wanpengli@tencent.com, kvm@vger.kernel.org,
        joro@8bytes.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, tglx@linutronix.de, vkuznets@redhat.com,
        jmattson@google.com
Date:   Wed, 11 Nov 2020 18:28:26 -0600
Message-ID: <160514090654.31583.12433653224184517852.stgit@bmoger-ubuntu>
In-Reply-To: <160514082171.31583.9995411273370528911.stgit@bmoger-ubuntu>
References: <160514082171.31583.9995411273370528911.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR21CA0013.namprd21.prod.outlook.com
 (2603:10b6:3:ac::23) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by DM5PR21CA0013.namprd21.prod.outlook.com (2603:10b6:3:ac::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.9 via Frontend Transport; Thu, 12 Nov 2020 00:28:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e1dd068b-2fbf-4596-ab8f-08d886a1e033
X-MS-TrafficTypeDiagnostic: SN6PR12MB4685:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB46854D73BBF0E94503BD3CF395E70@SN6PR12MB4685.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gf/X5cjOloAuxcFc8vpAi5RmjKjc9um+LjxQXg5JxTFn1mRp1WhjkqXicGJFQ3G2jL+sl8WYpDT/Mtjn3DbOnyRR3+uRFPls0TCQD9wxPQB1efraaTgt6/OatmI65IVFySljwrN4uqsVAZ9pEkk3Nsr2/XTCIqzsDjjHUyGs4y6aanK7WmAadkrzmtNDq1TTS5z2XF7UUXOyZh+QgHkcUSXNaFVx/Kjy06/JsRLkPXkptdzwuwRbOWZr14QtJcYf1XbuJTfSWO317Fnp9m/4pVI+2LUst6PBnJTQw/sznkQR4uqxjW14ciSwLxN9M/1KAwxuzGjdVv1ETMdlKAN3eQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(39860400002)(136003)(396003)(346002)(376002)(83380400001)(52116002)(186003)(9686003)(26005)(6916009)(7416002)(66946007)(44832011)(16576012)(33716001)(103116003)(956004)(66556008)(4326008)(66476007)(316002)(2906002)(16526019)(6486002)(5660300002)(478600001)(8676002)(8936002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 78jCJmmTbqFj8tOKfJmga/9kVDI+JgCNo+kp/S60O7oRHjnZFYb8/UBZjEhf3jlflG2awIJdTNzDXdjZubjBxAWebbRJUKRlwjYKWc20cK8kCK96qluCosoukLYtnb9PBMEi2WiRIf6CHn0spmHzfj24Q7SJEIPan8rNJ6BAgMhNESX4KeBjzLt4oDTKc7pqSJMlzKJ0I1Bi6htaX1Dzs3iekntUHX7Fr21XxIB5p1fsQIC7sI34IsqVmY7JYwK2cPS2bKh8B4p5shGWVOLLPKiwVy8c6YXi+L6rIIvYASo45GtrY8PJXAiYMxdQnGzUY+/4mgGxQaSKshQP97OsOAOPgb55KjoY+6PYh8Ge4SGyFO3bSBDffxt1C3jZ4w4xfZjsmlmNeRqVM80RJbEYfOrAP4aRKpV1vJ8GDqnTIct+daDkVf3r8OAziL+/kB75fa/UsTRilJ5Gwqrco3PJULbu43aLBbo8LiF4fzcvpL70vhdjGVhsf75O9+Hxs4OGP7sRTqAGHd+hYFkrWJu7LFZBzgPAagOEBDDZydznGbURnn6GDASk//JMs1QFK6KmG5aspp/0VYdpGL9qfnDWTmwDhRvO3DkMSk6KrYKtq7SYmpVPRvRbl0pabTt3LhGrUT+/eCgQQbVzp1QGzvoOkA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1dd068b-2fbf-4596-ab8f-08d886a1e033
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2020 00:28:28.4263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HSh6BAt0820Du6qVEO2CMSlvYwqiX72W+XasRKvr9TYSGAhQSLe2uA6y4zp7KUg5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4685
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support to the mask_cr3_rsvd_bits() callback to mask the
encryption bit from the CR3 value when SEV is enabled.

Additionally, cache the encryption mask for quick access during
the check.

Fixes: a780a3ea628268b2 ("KVM: X86: Fix reserved bits check for MOV to CR3")
Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/kvm/svm/svm.c |   11 ++++++++++-
 arch/x86/kvm/svm/svm.h |    3 +++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a491a47d7f5c..c2b1e52810c6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3741,6 +3741,7 @@ static u64 svm_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	struct kvm_cpuid_entry2 *best;
 
 	vcpu->arch.xsaves_enabled = guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
 				    boot_cpu_has(X86_FEATURE_XSAVE) &&
@@ -3771,6 +3772,12 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	if (nested && guest_cpuid_has(vcpu, X86_FEATURE_SVM))
 		kvm_request_apicv_update(vcpu->kvm, false,
 					 APICV_INHIBIT_REASON_NESTED);
+
+	best = kvm_find_cpuid_entry(vcpu, 0x8000001F, 0);
+	if (best)
+		svm->sev_enc_mask = ~(1UL << (best->ebx & 0x3f));
+	else
+		svm->sev_enc_mask = ~0UL;
 }
 
 static bool svm_has_wbinvd_exit(void)
@@ -4072,7 +4079,9 @@ static void enable_smi_window(struct kvm_vcpu *vcpu)
 
 static unsigned long svm_mask_cr3_rsvd_bits(struct kvm_vcpu *vcpu, unsigned long cr3)
 {
-	return cr3;
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	return sev_guest(vcpu->kvm) ? (cr3 & svm->sev_enc_mask) : cr3;
 }
 
 static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, void *insn, int insn_len)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 1d853fe4c778..57a36645a0e4 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -152,6 +152,9 @@ struct vcpu_svm {
 	u64 *avic_physical_id_cache;
 	bool avic_is_running;
 
+	/* SEV Memory encryption mask */
+	unsigned long sev_enc_mask;
+
 	/*
 	 * Per-vcpu list of struct amd_svm_iommu_ir:
 	 * This is used mainly to store interrupt remapping information used

