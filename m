Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB0652F8226
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 18:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbhAORWt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 12:22:49 -0500
Received: from mail-co1nam11on2062.outbound.protection.outlook.com ([40.107.220.62]:31456
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727975AbhAORWt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 12:22:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Or7z3oX1/5D7FICa9EfJnmaxROBCyNnna8YzMhWSosEW/EjZ2GiturqUyKP0OB3bc4+aSGRO631umlqtrm8HvViQJc7v6GoXHUVrM4tYgHnEJZGj3hL8wsOQHWXBSYQYsgMRRarDJdegL7VAFF140PBC3nx3s0DBZXGX9U+yLR1P3vGeyjZNh6H3lzkPzafosmveQS3cSST1SLOS25/FnDdn3h0JT8VRRaAKJZXBlDHwMs/4zs11TqhzZHLhX9DyrJ4D1VLVHRm63H5xOZ2oiDYhOjy+kgI5b777u+ujii833oKxJciaFnMFGR16TLtzkoyBN+5waq9CI7V8dw3XDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Q93GfI1y4S19Pvk1QPlF+hZ2LFWYLsozgShUiI1Zco=;
 b=BOBqTH+sIZcuxxachP5YJSQE2AIMM+cqFdnU1KU4qhWKNVMpOjjX4J2nvtp55hAb7Tr9SooK+Fyax/zQV0pen4sNWHId8JW5nGJo/l0bcbOMpCUPFOzYC5/8JWJPhmGlzz0irAnYhLDLZyqeQ26RlyTuAAoh8V1TKv1KK62UO5MUK3evzfZ1rM5/AebWzeE4jmNi4NxmtYnVDgsQs/fYamRmjjqfMZbLJ2dH/u6JXysTtEQdr1/MUF4iuDzLVquFvozK7DRUy7RgyZqk0NFMBpAI6NI6uD13U1QqFkLrbLJs1s207eY77h7PZmJkClP3+sMHzs67Mxx1xBaruspZ0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Q93GfI1y4S19Pvk1QPlF+hZ2LFWYLsozgShUiI1Zco=;
 b=JkUGquL9rUplEG5+4yY08jz6C2sGhO+DVOhB5G0mIsP21K2J8XqgI91VRnhmjDSXx9ZZQ3BokqkaIQYXNS51RRLzYJ4K+FADoit6V7ScIWEAAAaISsXqQwat0/REHYpEPX7jjQGnAUNmAGoEGdsWMtUEtRWnyt/w1i6k33ysB70=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4383.namprd12.prod.outlook.com (2603:10b6:806:94::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.9; Fri, 15 Jan
 2021 17:21:57 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff%5]) with mapi id 15.20.3763.010; Fri, 15 Jan 2021
 17:21:57 +0000
Subject: [PATCH v3 2/2] KVM: SVM: Add support for Virtual SPEC_CTRL
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de
Cc:     fenghua.yu@intel.com, tony.luck@intel.com, wanpengli@tencent.com,
        kvm@vger.kernel.org, thomas.lendacky@amd.com, peterz@infradead.org,
        seanjc@google.com, joro@8bytes.org, x86@kernel.org,
        kyung.min.park@intel.com, linux-kernel@vger.kernel.org,
        krish.sadhukhan@oracle.com, hpa@zytor.com, mgross@linux.intel.com,
        vkuznets@redhat.com, kim.phillips@amd.com, wei.huang2@amd.com,
        jmattson@google.com
Date:   Fri, 15 Jan 2021 11:21:40 -0600
Message-ID: <161073130040.13848.4508590528993822806.stgit@bmoger-ubuntu>
In-Reply-To: <161073115461.13848.18035972823733547803.stgit@bmoger-ubuntu>
References: <161073115461.13848.18035972823733547803.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0119.namprd05.prod.outlook.com
 (2603:10b6:803:42::36) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN4PR0501CA0119.namprd05.prod.outlook.com (2603:10b6:803:42::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.6 via Frontend Transport; Fri, 15 Jan 2021 17:21:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bdaa0231-264d-49d5-0c18-08d8b97a0f70
X-MS-TrafficTypeDiagnostic: SA0PR12MB4383:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB438323E856ED2D9206850EAC95A70@SA0PR12MB4383.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5gyvlzxsKNxA66bA0q/m8onDBF7aOcc6UEkXO8gVkkSw17OVR7f2znaio+u/ewTCjQalvU3NQ+KL4dvT3hcHeLDiyO9XYw6JZ5ZmmW9uRltFa3cypR0GmU7OTPacjetBSm8HmVQw8uY9GYKPclpwDui0Lcg2M8FlCo9RUvUumh3Afs6cjp22atLMIevP865rCgR50otLGONQwv86bIS64+tDj0q0VtEEYleCy+FWumb+7G3kP/enhKgVKVKI7W0XAGKL6cWp1hZqEsgKy5JSrOOpRbZPQLO+rjT6VoVMdJahGlAZdh5HnGCIjpLQgTqHAIY9/RS7RNJY68GvPu8SM/NWgH8x9ahBhFfHK0MqNjOgjP0OGOU1Zh7zU4pSH1w9mDz05GiNKrRSZQLeDpEAjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(136003)(39860400002)(376002)(366004)(346002)(4326008)(956004)(16526019)(33716001)(7416002)(316002)(44832011)(83380400001)(478600001)(52116002)(9686003)(6666004)(66556008)(103116003)(66476007)(8936002)(26005)(16576012)(6486002)(8676002)(186003)(86362001)(2906002)(5660300002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Ukx3Sy90VEUyRnBISlh5WjBHQldhVzBVd1l2ZXptbU1pejZUb0VPcHZMZkVz?=
 =?utf-8?B?SHJGYzJ3Wkc1NlcyVXBCeEJFRHk2QmFHQUhtbmhLRDFnbWEyQVhmYUxUb1do?=
 =?utf-8?B?NDJtRmxtYUFQMUZEZmxCcG01RDQ0MGwrS1pXSDhiMlI4Uk1Wa3dhUXAzZkJy?=
 =?utf-8?B?Q1BkOFFDaWlDNk9rNVFTdHlEajdUb3Bab0JNdEJTbW55SExLaFZhUkw2YlJG?=
 =?utf-8?B?NHpMUGN4RDBiVGlyelRidUNWRDZINFEvZEphQnBNUGtEbnRNWWprTE9VOTVa?=
 =?utf-8?B?N0E5N29rVUdEcUFiR09mSnRFOFVCWVhaZ3dvZHZadGQxL05GaTZ5OVNXeXdX?=
 =?utf-8?B?SUlCRjhXdVNWUm5sTUhmcU1ObGhaZFFjUXNmMzh0MlJLcnhna0RkZFgyS1NC?=
 =?utf-8?B?TzNpdWt5czQ0WHZ0VlpSNGxKTW5QaW9SOUFrSWxXRUhuU25TZDl3ckVhYW9q?=
 =?utf-8?B?VGJqNXZLQmtzZmVadTE5MjVTOHRJZjlwczFLU2hFc3htN0dNNlZ1U3hVaUh6?=
 =?utf-8?B?YXVJcTkrc0pJbnhEc1liN1ZzN0lnVDVZbXZqUGxScDljdWhkRk9SVFhTMndO?=
 =?utf-8?B?aFVZd2lnVDJDV2xHcXpkalpWU29tSG1PMVhRYUhicDJpL2JXKy9Fakt5NHor?=
 =?utf-8?B?c2g4Q0w2VTJGNWJTSkxaMUFBRHNxaXBsT0F4b0YxNHB5UTMwY1l6RG5QSVBj?=
 =?utf-8?B?bUJEVE85ejdWanZpSFpXdWFNbTI5djJmYVl0a3YvNDdrRlZtRkwxc2pTMTli?=
 =?utf-8?B?Z29Tbm82dHlLYmVNcS9ZaGd4MVZoUVpEM3IyYmJpQllFN3pBQkRtL3hzVXhU?=
 =?utf-8?B?TEtienowSDFCSG1WSnlZZE9JemUzV1ZjYWhsT3pYbGtFZjlaLzV5LzUwYVVZ?=
 =?utf-8?B?amN5SXZzQXgyZTdaa3hFQjdIaDNweGRwNjFpM3grODUwdVNEaVFXT0k4amxL?=
 =?utf-8?B?QWFLVGo2enh0bDVMTi82alUycUhRZm1LT2E0di9VaFo3UmUzUDFhNFIzRTNN?=
 =?utf-8?B?M3ZPSlVsUjN5RktTM0pOcU1tcytHNWg5WUxDYkFwYUptNTV1dGFQRHFPeUU1?=
 =?utf-8?B?M0NwWWI2RjYwVkkrZUI0M0hzcFZxbDNHaEdzVjRqZGltYzV3THd3ckNLUEJU?=
 =?utf-8?B?U2hIMjNBZ3RDZzk4TnR4RGFFd2d0QitvUWpXKytRZjZndTIvOHE2YWkwelRm?=
 =?utf-8?B?NDM3MjJTTFpoWkJuVzdDSHZ4MGI5NWQzUi9sTVpvNXRFb1NQd3hsN1FKZWhF?=
 =?utf-8?B?Y0JTK3NjNGFRcjNWSUNZN2VYZExaZ2I5MzlnL2dQaDNhcFRtb3BRMXJkdGpV?=
 =?utf-8?Q?DfCENZ7DncRGs=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdaa0231-264d-49d5-0c18-08d8b97a0f70
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 17:21:57.0654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3UlJZyliUcAi6OsUFT4chUFhXOnBkhuoadQFkPZ0eyOzjboh4sN8pFtNU+seYTVZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4383
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Newer AMD processors have a feature to virtualize the use of the
SPEC_CTRL MSR. A hypervisor may wish to impose speculation controls on
guest execution or a guest may want to impose its own speculation
controls. Therefore, the processor implements both host and guest
versions of SPEC_CTRL. Presence of this feature is indicated via CPUID
function 0x8000000A_EDX[20]: GuestSpecCtrl.  Hypervisors are not
required to enable this feature since it is automatically enabled on
processors that support it.

When in host mode, the host SPEC_CTRL value is in effect and writes
update only the host version of SPEC_CTRL. On a VMRUN, the processor
loads the guest version of SPEC_CTRL from the VMCB. When the guest
writes SPEC_CTRL, only the guest version is updated. On a VMEXIT,
the guest version is saved into the VMCB and the processor returns
to only using the host SPEC_CTRL for speculation control. The guest
SPEC_CTRL is located at offset 0x2E0 in the VMCB.

The effective SPEC_CTRL setting is the guest SPEC_CTRL setting or'ed
with the hypervisor SPEC_CTRL setting. This allows the hypervisor to
ensure a minimum SPEC_CTRL if desired.

This support also fixes an issue where a guest may sometimes see an
inconsistent value for the SPEC_CTRL MSR on processors that support
this feature. With the current SPEC_CTRL support, the first write to
SPEC_CTRL is intercepted and the virtualized version of the SPEC_CTRL
MSR is not updated. When the guest reads back the SPEC_CTRL MSR, it
will be 0x0, instead of the actual expected value. There isn’t a
security concern here, because the host SPEC_CTRL value is or’ed with
the Guest SPEC_CTRL value to generate the effective SPEC_CTRL value.
KVM writes with the guest's virtualized SPEC_CTRL value to SPEC_CTRL
MSR just before the VMRUN, so it will always have the actual value
even though it doesn’t appear that way in the guest. The guest will
only see the proper value for the SPEC_CTRL register if the guest was
to write to the SPEC_CTRL register again. With Virtual SPEC_CTRL
support, the save area spec_ctrl is properly saved and restored.
So, the guest will always see the proper value when it is read back.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/include/asm/svm.h |    4 +++-
 arch/x86/kvm/svm/sev.c     |    4 ++++
 arch/x86/kvm/svm/svm.c     |   19 +++++++++++++++----
 3 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 1c561945b426..772e60efe243 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -269,7 +269,9 @@ struct vmcb_save_area {
 	 * SEV-ES guests when referenced through the GHCB or for
 	 * saving to the host save area.
 	 */
-	u8 reserved_7[80];
+	u8 reserved_7[72];
+	u32 spec_ctrl;		/* Guest version of SPEC_CTRL at 0x2E0 */
+	u8 reserved_7b[4];
 	u32 pkru;
 	u8 reserved_7a[20];
 	u64 reserved_8;		/* rax already available at 0x01f8 */
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c8ffdbc81709..959d6e47bd84 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -546,6 +546,10 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	save->pkru = svm->vcpu.arch.pkru;
 	save->xss  = svm->vcpu.arch.ia32_xss;
 
+	/* Update the guest SPEC_CTRL value in the save area */
+	if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
+		save->spec_ctrl = svm->spec_ctrl;
+
 	/*
 	 * SEV-ES will use a VMSA that is pointed to by the VMCB, not
 	 * the traditional VMSA that is part of the VMCB. Copy the
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7ef171790d02..a0cb01a5c8c5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1244,6 +1244,9 @@ static void init_vmcb(struct vcpu_svm *svm)
 
 	svm_check_invpcid(svm);
 
+	if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
+		save->spec_ctrl = svm->spec_ctrl;
+
 	if (kvm_vcpu_apicv_active(&svm->vcpu))
 		avic_init_vmcb(svm);
 
@@ -3789,7 +3792,10 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	 * is no need to worry about the conditional branch over the wrmsr
 	 * being speculatively taken.
 	 */
-	x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
+	if (static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
+		svm->vmcb->save.spec_ctrl = svm->spec_ctrl;
+	else
+		x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
 
 	svm_vcpu_enter_exit(vcpu, svm);
 
@@ -3808,13 +3814,18 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	 * If the L02 MSR bitmap does not intercept the MSR, then we need to
 	 * save it.
 	 */
-	if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
-		svm->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
+	if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL))) {
+		if (static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
+			svm->spec_ctrl = svm->vmcb->save.spec_ctrl;
+		else
+			svm->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
+	}
 
 	if (!sev_es_guest(svm->vcpu.kvm))
 		reload_tss(vcpu);
 
-	x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
+	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
+		x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
 
 	if (!sev_es_guest(svm->vcpu.kvm)) {
 		vcpu->arch.cr2 = svm->vmcb->save.cr2;

