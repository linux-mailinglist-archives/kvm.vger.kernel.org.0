Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4332E1055
	for <lists+kvm@lfdr.de>; Tue, 22 Dec 2020 23:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728547AbgLVWdI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Dec 2020 17:33:08 -0500
Received: from mail-bn8nam08on2053.outbound.protection.outlook.com ([40.107.100.53]:4961
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728430AbgLVWdH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Dec 2020 17:33:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R+jCj4y4rl7NTISPBLHO9z2Tx9uu0o4zK3qodSxGG0wbVlN1XJHselrI55qkn/IfLgYb3JWsYb+oykqBqLqj+xE3e84c133fKccUIJMXlO1oOqKZTXs6NmHosf1URhTwgsrSGn+P/+kwdeE09RmYI5mLwvb2AxQH07rBI8kmZZDf9kvDw08upyxoB62IxUTV+k70WvY10AWF1OxWlGA4z2LTx+niqqSHQ0UwaWpxor6vx6rm1LtlRbcGEUSrivTgiZSH2Mn3otGzO/5TKhJTaQ4LH/4cFIpAZE3MBegBKXfKqu/qWHr4mKC1nxpUKK2g3onIBey6xaaR6Um3zYeTxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vG8PblkhCjgwr7t1Yagrc9vXFGKKh7F+POyriyA/msY=;
 b=XrVIg1jCs5ZCbe079ozuEiZv6YpFpEz22OJtklT/81oJ6AspkgjGRzk8we2TEPb8SatCgrOLMz6J8n/Xg/ecQGHw7q00LHPJyeMMeTgxngOwyqv7gqadhDeDQI8+SqgV5ULGw4NMzKpm4OrW18exr/cM+bO3dvRL7QUMHnB2vmoLuE6QvXEBsxjViijczTJj+aT+LdosFU9GBsv5yP89OzZ0w1aRfcatgyQUtZYjPAyMUzzivgnDISdpjm1fyV4TTdlLaJl2ntjsvnVvjz0PSygSKYG/J+yMC0Ou5uRKjPxEUfK0qY+wwqaaQqHKE9YyjAKihAvPzRBPeoOOJzRsDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vG8PblkhCjgwr7t1Yagrc9vXFGKKh7F+POyriyA/msY=;
 b=xbcKpxKaLk9wj2mb9pROI625fdcFXkUMPleBmu6nolPceAUH/sdd/0RihzWytI/lA5Kvpz90whoSmBX7JjmxXXnnX3Lad1R4lhTTzOSXpsy5//c5SIq2qJV7hwGfbVhlq0IpDhpcP4G+zwEiZkgp7vtF31yeL0FlxNtYyFH8u28=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2381.namprd12.prod.outlook.com (2603:10b6:802:2f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.33; Tue, 22 Dec
 2020 22:31:56 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff%5]) with mapi id 15.20.3676.033; Tue, 22 Dec 2020
 22:31:56 +0000
Subject: [PATCH v2 2/2] KVM: SVM: Add support for Virtual SPEC_CTRL
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
Date:   Tue, 22 Dec 2020 16:31:55 -0600
Message-ID: <160867631505.3471.3808049369257008114.stgit@bmoger-ubuntu>
In-Reply-To: <160867624053.3471.7106539070175910424.stgit@bmoger-ubuntu>
References: <160867624053.3471.7106539070175910424.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0153.namprd05.prod.outlook.com
 (2603:10b6:803:2c::31) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN4PR0501CA0153.namprd05.prod.outlook.com (2603:10b6:803:2c::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.19 via Frontend Transport; Tue, 22 Dec 2020 22:31:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7e2abd1d-6e25-4054-5f7d-08d8a6c96395
X-MS-TrafficTypeDiagnostic: SN1PR12MB2381:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB23814CB1D801CBD4FF92C9A095DF0@SN1PR12MB2381.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NzdDmtQDNZ/aS8g2vhhl+0zSmiMWGOEwxOpdYPgdpc8XHD/lB7Tt8FXguOPPk+cX+fG2eXoOHb4zPd/Fb99/RCmTGi4pKnc2+852sQCx+DiD81vkVJCy+ZoiJFGRsEsY33Klr6LZqLvIiK9MQgbd+/eQQJi0DKAzIc/0OMXfo6y/+VL6L7/nqSANQiSnu6qqjeHCSeb/Dw3oatZ+uvzlqUyuc8oZPBehbHpNl/WCFkn6usNf5vEIcptvPeub5gauosF9CFL8IekaDRh4+K5/dJlcIlLU9+BK/GaEMzpe85K3rC5QzaHKLKX9g0A29pQFhUlfP6Et0PVumkkr4GvJC4L9VY3HWfMLBxY6epXYb43vG4JGkNkcXq39uGfjs4a7U/jfhRSvtd7DlcCPYc5wnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(346002)(39850400004)(376002)(136003)(396003)(366004)(16526019)(66476007)(26005)(186003)(83380400001)(66946007)(4326008)(103116003)(5660300002)(7416002)(9686003)(66556008)(478600001)(33716001)(956004)(8676002)(6486002)(86362001)(316002)(2906002)(8936002)(52116002)(44832011)(16576012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?T1JwTkNNbDVGZUM2Q3p6SVNaWGhmVzBUSTEvQ0ZKUXMxNFErYmFJcEszVXJn?=
 =?utf-8?B?eW5BM21IOFFmZG9MUTQ5bmVaYnFka2FIb0lTSHZiQWZaeWluVlc0YzFFKzAw?=
 =?utf-8?B?dG9NUEZBSldrU1FIU0RoNnZudVdrVnFPakZjNkxjOWJjdStNVkw5aVdGeGVQ?=
 =?utf-8?B?a0F3ZTM4dWtkSkEyTnNFVlNNRXFzYjhlZlFDcWQ4ejRENFBLWFJhbEl0T0dj?=
 =?utf-8?B?NzN1WUlEeTJyMDFrOENQRHdudXBiUkJ0WEdzZGQ1ZVRFbTR1MjR2bmhoN2lR?=
 =?utf-8?B?K3RCL2FSNmVLN241SFEzaGZyN045Zm1JZVBsQWliZ2R3SWx1YXRWYU9LWXB6?=
 =?utf-8?B?SEtyQmVMZndma0dDaitsemdKaS93TU04WHJpQVJJT2hUTU0xMklwd1h5ZWh1?=
 =?utf-8?B?WGpEcnRFaWRtL0dGYXhtS3dzOGxaTzB4MmdOSWxackdvU0pZcFlqVjRaTkg5?=
 =?utf-8?B?NzA2ZVFNNmx0anhua2cvMlZOV3NwbTdXQVhCdU5LZVpXcE1DYTFMK0d2ZkdL?=
 =?utf-8?B?VjBDZ1NOUmFLWEtaR29vY3orR2dSNG94NU10QTREVm5zTStLM2NrSWFRd2RY?=
 =?utf-8?B?aXQ5clRzVDgwOXRTNHo0UDdCMzRXN2o1YXBIRDVWcVNSZU5FMFdxNzRjRkxI?=
 =?utf-8?B?djhjSVd2a3BqV011MEVmZTNFRFljalovSDBvRE50cWxRa2x4VXZ1a1dtdkYv?=
 =?utf-8?B?Ymh1V1FXNi9jbkYwWmdtWTJpV3R2SGVTNTBLMlNNU2U5eUl6VlF0NU4zbS91?=
 =?utf-8?B?emh2WXBVRjVDOTk0YzRnMm5MYzFGMzBwRXFsRU9obEdUcDh4cWhGK3h5YnBX?=
 =?utf-8?B?bHIrbjV2cUZFNmIvb0pFZTJBcms2Rm5DeEk1UmI3VFdKRmlRcWREK1pDeDQ4?=
 =?utf-8?B?YzV2UXNTU3BadDIxNkJNOHgxMlIxZVN2T21hanowejJabGpRaVlmSXhrRFNK?=
 =?utf-8?B?a1pTdTluMHExWVJOMVVWOGs2emMvUWMzUHNtdVhWV21oU3NoMGRyQWRsVGZ3?=
 =?utf-8?B?c2grVTRVbFRlRWRZM3FKR2dGQTdLZHRYMnBrYUdYeGF6Y0ZwbHlvZHg5emJl?=
 =?utf-8?B?ZTBhTHNBRnpES1VuTmxvZk9LOHJqRER1bkpoSG5Dblk4bkpVU0F2cTh1L2RB?=
 =?utf-8?B?dTFhR3hBVDR0TTlWekV1eDVvU3FET1lwZXNmdFQwaW8vUHlBVkNkeFBBT3lp?=
 =?utf-8?B?RjVOS09QVEthMlJqUGhlckt4TkFZWXlJY21oQWc4dmtMQXh3WXI5Wm9Pa1Nt?=
 =?utf-8?B?ZkhCVE5yUHZUbXVIclhaazFoOFNUcFNmenZIWDdMK3RKZHRBOEVxZ3IrT1Bz?=
 =?utf-8?Q?aRAOikOKUFpyOPY2mF/6kTAP7eKm7HGkJe?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2020 22:31:56.1256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e2abd1d-6e25-4054-5f7d-08d8a6c96395
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: arsoP/hz6cosKEI5C12DFuZkj+/dpWwxa1wKhEbTdKg+u1wM5b4oqmpFSnYEGLnT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2381
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
support, the MSR interception of SPEC_CTRL is disabled during
vmcb_init, so this will no longer be an issue.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/include/asm/svm.h |    4 +++-
 arch/x86/kvm/svm/svm.c     |   29 +++++++++++++++++++++++++----
 2 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 71d630bb5e08..753b25db427c 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -248,12 +248,14 @@ struct vmcb_save_area {
 	u64 br_to;
 	u64 last_excp_from;
 	u64 last_excp_to;
+	u8 reserved_12[72];
+	u32 spec_ctrl;		/* Guest version of SPEC_CTRL at 0x2E0 */
 
 	/*
 	 * The following part of the save area is valid only for
 	 * SEV-ES guests when referenced through the GHCB.
 	 */
-	u8 reserved_7[104];
+	u8 reserved_7[28];
 	u64 reserved_8;		/* rax already available at 0x01f8 */
 	u64 rcx;
 	u64 rdx;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 79b3a564f1c9..6d3db3e8cdfe 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1230,6 +1230,16 @@ static void init_vmcb(struct vcpu_svm *svm)
 
 	svm_check_invpcid(svm);
 
+	/*
+	 * If the host supports V_SPEC_CTRL then disable the interception
+	 * of MSR_IA32_SPEC_CTRL.
+	 */
+	if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL)) {
+		save->spec_ctrl = svm->spec_ctrl;
+		set_msr_interception(&svm->vcpu, svm->msrpm,
+				     MSR_IA32_SPEC_CTRL, 1, 1);
+	}
+
 	if (kvm_vcpu_apicv_active(&svm->vcpu))
 		avic_init_vmcb(svm);
 
@@ -2549,7 +2559,10 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD))
 			return 1;
 
-		msr_info->data = svm->spec_ctrl;
+		if (static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
+			msr_info->data = svm->vmcb->save.spec_ctrl;
+		else
+			msr_info->data = svm->spec_ctrl;
 		break;
 	case MSR_AMD64_VIRT_SPEC_CTRL:
 		if (!msr_info->host_initiated &&
@@ -2640,6 +2653,8 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 			return 1;
 
 		svm->spec_ctrl = data;
+		if (static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
+			svm->vmcb->save.spec_ctrl = data;
 		if (!data)
 			break;
 
@@ -3590,7 +3605,10 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	 * is no need to worry about the conditional branch over the wrmsr
 	 * being speculatively taken.
 	 */
-	x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
+	if (static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
+		svm->vmcb->save.spec_ctrl = svm->spec_ctrl;
+	else
+		x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
 
 	svm_vcpu_enter_exit(vcpu, svm);
 
@@ -3609,12 +3627,15 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	 * If the L02 MSR bitmap does not intercept the MSR, then we need to
 	 * save it.
 	 */
-	if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
+	if (static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
+		svm->spec_ctrl = svm->vmcb->save.spec_ctrl;
+	else if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
 		svm->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
 
 	reload_tss(vcpu);
 
-	x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
+	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
+		x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
 
 	vcpu->arch.cr2 = svm->vmcb->save.cr2;
 	vcpu->arch.regs[VCPU_REGS_RAX] = svm->vmcb->save.rax;

