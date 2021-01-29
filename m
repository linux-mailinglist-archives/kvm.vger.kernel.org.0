Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 277C43082A6
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 01:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbhA2ArU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 19:47:20 -0500
Received: from mail-dm6nam11on2081.outbound.protection.outlook.com ([40.107.223.81]:51312
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231652AbhA2ApT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jan 2021 19:45:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kQD9raEwsFGG4TaRa19VC4bst+E1P+AkaF7UnpSo9C9Uz7W/xKAFVznjgHbvikytQrhyCn+QIGgu8LADVfBgjNsBiHyMf5bDsHNb+UlzrAbjJuBhKWwMNXxjjHITkjDVzDxpIX6IonZ6Ah+XKtmV+RikKlD9N6QZE1yIqGBbmmgx1uTSJWkWA10mj4WdBdLZdhLPhnvXAPfW7ARw2eZxGialBPnrRDrT0/STL3N866WCl8p91Uq1d2D45FxpWVROhqd/oF55ywEGBHppPgC4Up2EWCTXz+z5gG3doWceeqGJURD9O+/6b2lSye0EXy7L1SNcsrHEFUUKN7t67yvORA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cbGm3ocNhLunoo9a9azp9O3/ggkhDcw6JXr/msUKJQ0=;
 b=SYl70fulnN0mRkZT1fKjAlSrDkVmFinZrU/dCoVBbsejP36aAG+4NH/gdtv4qoWsE3dLk6c3qN764k4MHk9aOoEDhRWyy6DUQMSicR+H3RHl3bWW4XXqRSJLiypJYLTX6qaguTwbdmbG0lXKdvYVKgpLAcjiRD7UpBxxd3Z4hK5SG1jUTgFSVPM07E2WwBy+ewrP1n3mvJeu8g2NBqChRA6nXlCccl2i05vWocJ0qTDBSJFjNMG1yq8rYoonOG20PK5v+qFKpfobB7RtWPI0k5q8QKaNpq0P1M41D2Ytx+n41CLHDH+CehqZhBmjAtWkbCJVX/2yFL2aWi2EqRcV8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cbGm3ocNhLunoo9a9azp9O3/ggkhDcw6JXr/msUKJQ0=;
 b=V1FFT4WzsP6jyc8UJqiWHI7+3SnPlGvnMZksb4GYcJBUC4v78l9sWGC3pUmSkdOwnJzL172NP4NFdgMSx6SlaKtUok9Eyuh/WPnngwAVmvw/yoV0dxWWdcKFoC86q2XguyYKfhtUFmDk4D0TeFwpRUFeDPICAhph+vTfj087qz4=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Fri, 29 Jan
 2021 00:43:31 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff%5]) with mapi id 15.20.3805.019; Fri, 29 Jan 2021
 00:43:31 +0000
Subject: [PATCH v4 2/2] KVM: SVM: Add support for Virtual SPEC_CTRL
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
Date:   Thu, 28 Jan 2021 18:43:29 -0600
Message-ID: <161188100955.28787.11816849358413330720.stgit@bmoger-ubuntu>
In-Reply-To: <161188083424.28787.9510741752032213167.stgit@bmoger-ubuntu>
References: <161188083424.28787.9510741752032213167.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0401CA0008.namprd04.prod.outlook.com
 (2603:10b6:803:21::18) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN4PR0401CA0008.namprd04.prod.outlook.com (2603:10b6:803:21::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Fri, 29 Jan 2021 00:43:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1fc49e40-95a2-4800-b663-08d8c3eee66e
X-MS-TrafficTypeDiagnostic: SN1PR12MB2560:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2560830BB0F067724421F15995B99@SN1PR12MB2560.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mImU/BqrsWbu3ls/juIwhE4zSuf77BfSL+UN6vWYQ4Bk7RDFMlI8EiXxUnUkH45BqnWeRyzJOENwnqWK32eVNaNz1Zdy/ey/W9M57lfcpY80m19fI9CtklxAbhQirFWylV3MSM9ewqjHh/KmN4FFhj3NBzsIFEUHLfY5JwOpbjJjbb1cEr9qvGQA7XczwmAuk0TIl2RytznaVyrFbCXBH4Vy8iVpYO8Eg04IhIWpFbDGq/8JxTCZorpmw5gX9MlYFVkTYuGrTulmewAXIGGugUwYMVDDXTTDCUZYwXQbeiEyfNDnoBayzb4hO+FjR//mLaUJNDTDXZcOMRBqNyeCDkNiGpiHRpKqgHE+RaM0tViSFDcw6+doA4Dwq8esGD4+mPJ20JalQJt2P75E93UHeRj3SS8tmZyj+jit/P0+U9mn9pKaO9wHQ90bwmYMsnhMYtPf7HQMct2wksYmO7zDDRLrC4TUy0koY7vgFoDp1Rqrfnwj8Otvt9HPw7Y92PXYDOuw54KGGH1cYExv7wygCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(396003)(39860400002)(136003)(366004)(346002)(376002)(956004)(16576012)(52116002)(7416002)(8936002)(8676002)(316002)(86362001)(83380400001)(103116003)(44832011)(16526019)(186003)(33716001)(4326008)(478600001)(6486002)(9686003)(66476007)(66556008)(5660300002)(26005)(2906002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QzhCYzBYNys1dm5ycEE1YlFzZnFrb3RyQmQ1TXE5R3EvMkVldzVOZnE1MnJR?=
 =?utf-8?B?azJIbFZaWmhsdW5GK1hTcXlhL2FucFB6RldGN2FCRVhWajRpelc0RStyalcy?=
 =?utf-8?B?WGFyOU4rT1VuS2N4MHR6VXVMZnVpSEFmTlFPamo4MGM1QXdRNmVneG9Ud20w?=
 =?utf-8?B?RWRlYkZqVHJmZlpCN2NCSUVXb2NrdTlEWHp4djRvd1NPOWRaNVljQWtTZSs2?=
 =?utf-8?B?RXQyVEtsK2M1bjZnc05MbXJrNSsvNXhjWXlGYnd1c1ppYXB0dDRjSExtRUtO?=
 =?utf-8?B?S3VIWU45aUZhZ2JpS3B6QUhTMEQxODM4SHNmRjg1WWFXTW5wTHFFekN2R3p6?=
 =?utf-8?B?ejhsNnlKVnNJYkhtcEExNWxHL3N0MDdleEIzeGVkc3R3QXRYRDNoMEJITEdm?=
 =?utf-8?B?enpPSTIxTk5sVU84U3RTQ2FCN2hRMHlzTnZoSXh5S25WODMyeFZkdlhHU3Ji?=
 =?utf-8?B?bDBtWG1rbUM5SVNiWi82YlBVamhwQThCYXhpWUoyaFRmRWhiQTlrZ1NjaGRP?=
 =?utf-8?B?THRRNFNOMmZHckVZenRxd044WldMbVlkeCt2cVBwcVJwN2cxRi9ZeHNiR3Fx?=
 =?utf-8?B?YUZuUUh5V1pRN05iSTNYRVI0YWtRUUtOcTdGVVdTVmRVVUdyZ0lKcDhGRjVI?=
 =?utf-8?B?MlgwVG1IUFBqelIrTUx5WGMxQ3RpRkhzUWthZ1hlb3VwT1ZleTg3RUd4N0Js?=
 =?utf-8?B?VXduc0ZJYWIvUDVOMmk5a2FvT0RaSTFhSHVxbUIxcUVHelBEYjdNaTlPVU1H?=
 =?utf-8?B?Yk1pQ203dENGUFJvMTJmY05tZWVvS2dLUkd3amhnZlM3VGxINnpiOHVheHpJ?=
 =?utf-8?B?d3lWUVd4STJvSmkzWlo3MXFyRDN6MTBCYXVNT3cwYy8zeVJGcWkwTEZOUnBC?=
 =?utf-8?B?NmdtRDNDT3d3YjR3d0crcjIwZER4WFpjTmdxQTMrTWpvMytvYzlzZVJhTlhF?=
 =?utf-8?B?eStqRURwTGJqT0hVakw3dHNSWnk1TVROQmRuR1IrcDZoWW5aQ2Z4YUYwczBv?=
 =?utf-8?B?MEh1Y2R0TjRLbHNxcGFpSXNNQzZaVlowNUhsVTZKQ0g5VmtLYTlKcXE5NHl3?=
 =?utf-8?B?SFRGeW1vek5CUC93YXQ5T0JtODhCa0FQTkk2Um96dWMwVExIRlhqTGlGVDBt?=
 =?utf-8?B?QU1MVkI3S21SS041bCs2THVmME81MnBFNFZlMFB4U1BSRlhxVG9uZ0N2QVRP?=
 =?utf-8?B?dGYzZ3ZuTDI0RmR2bjF3Z05EVWllRVJtdHl0aERuMUFmUnR6bGszeFZ2R01o?=
 =?utf-8?B?Z1dYdGZ2TkZKcG9hSkdiTkNlcHFHVTA1VzE0WlZPclpab1FDOGR1Q0U1TUZr?=
 =?utf-8?B?UmdyZVVtUzJqdXVhNm5QQkxnT3Q0VFFXMTRGUFE3SDNqSzlpbythdkxzRG9k?=
 =?utf-8?B?QURQUXIrd0RKcGg5MGRuV2sxenJOd2s5R0FpVDVmS1QvcWxDWFJLU2hjb0NX?=
 =?utf-8?Q?7CJJLiYy?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fc49e40-95a2-4800-b663-08d8c3eee66e
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2021 00:43:31.0262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uF3sUefeyQgwEN5PqOhq/1TSWCN46/ZMr26ZhNfE8Ujy+le7FmANaLiVlhOEtz+g
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2560
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Newer AMD processors have a feature to virtualize the use of the
SPEC_CTRL MSR. Presence of this feature is indicated via CPUID
function 0x8000000A_EDX[20]: GuestSpecCtrl. Hypervisors are not
required to enable this feature since it is automatically enabled on
processors that support it.

A hypervisor may wish to impose speculation controls on guest
execution or a guest may want to impose its own speculation controls.
Therefore, the processor implements both host and guest
versions of SPEC_CTRL.

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
 arch/x86/kvm/svm/nested.c  |    2 ++
 arch/x86/kvm/svm/svm.c     |   27 ++++++++++++++++++++++-----
 3 files changed, 27 insertions(+), 6 deletions(-)

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
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 7a605ad8254d..9e51f9e4f631 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -534,6 +534,7 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 		hsave->save.cr3    = vmcb->save.cr3;
 	else
 		hsave->save.cr3    = kvm_read_cr3(&svm->vcpu);
+	hsave->save.spec_ctrl = vmcb->save.spec_ctrl;
 
 	copy_vmcb_control_area(&hsave->control, &vmcb->control);
 
@@ -675,6 +676,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	kvm_rip_write(&svm->vcpu, hsave->save.rip);
 	svm->vmcb->save.dr7 = DR7_FIXED_1;
 	svm->vmcb->save.cpl = 0;
+	svm->vmcb->save.spec_ctrl = hsave->save.spec_ctrl;
 	svm->vmcb->control.exit_int_info = 0;
 
 	vmcb_mark_all_dirty(svm->vmcb);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f923e14e87df..756129caa611 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1244,6 +1244,14 @@ static void init_vmcb(struct vcpu_svm *svm)
 
 	svm_check_invpcid(svm);
 
+	/*
+	 * If the host supports V_SPEC_CTRL then disable the interception
+	 * of MSR_IA32_SPEC_CTRL.
+	 */
+	if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
+		set_msr_interception(&svm->vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL,
+				     1, 1);
+
 	if (kvm_vcpu_apicv_active(&svm->vcpu))
 		avic_init_vmcb(svm);
 
@@ -2678,7 +2686,10 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    !guest_has_spec_ctrl_msr(vcpu))
 			return 1;
 
-		msr_info->data = svm->spec_ctrl;
+		if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
+			msr_info->data = svm->vmcb->save.spec_ctrl;
+		else
+			msr_info->data = svm->spec_ctrl;
 		break;
 	case MSR_AMD64_VIRT_SPEC_CTRL:
 		if (!msr_info->host_initiated &&
@@ -2779,7 +2790,10 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		if (kvm_spec_ctrl_test_value(data))
 			return 1;
 
-		svm->spec_ctrl = data;
+		if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
+			svm->vmcb->save.spec_ctrl = data;
+		else
+			svm->spec_ctrl = data;
 		if (!data)
 			break;
 
@@ -3791,7 +3805,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	 * is no need to worry about the conditional branch over the wrmsr
 	 * being speculatively taken.
 	 */
-	x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
+	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
+		x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
 
 	svm_vcpu_enter_exit(vcpu, svm);
 
@@ -3810,13 +3825,15 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	 * If the L02 MSR bitmap does not intercept the MSR, then we need to
 	 * save it.
 	 */
-	if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
+	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL) &&
+	    unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
 		svm->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
 
 	if (!sev_es_guest(svm->vcpu.kvm))
 		reload_tss(vcpu);
 
-	x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
+	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
+		x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
 
 	if (!sev_es_guest(svm->vcpu.kvm)) {
 		vcpu->arch.cr2 = svm->vmcb->save.cr2;

