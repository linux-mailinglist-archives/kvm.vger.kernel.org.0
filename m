Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F1F2D1D87
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 23:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbgLGWj3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 17:39:29 -0500
Received: from mail-bn7nam10on2050.outbound.protection.outlook.com ([40.107.92.50]:42081
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726346AbgLGWj2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 17:39:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G/JmnpVRGg8MVc+OaUrjudEDKv41KCubyAXL90hIk/0YQ0QlCR8KBOtnBdGiWLjT8lEM3uoDVahitPqKAQmSSigoabdGeWrOWKKULEvGbV08obEloZgZPO++Xvemsekz7Z4zEmWiuD6VlWmRNgE08H0m/SW/hf6l/2aB/ILQNknqkDDYOXYOohXQp37ND2xtcVwpiYAQzji9fcQomCPHLPUtr/+ocG613pGhmW6CSOxS1mS1eEndNMfJnKztn86u4WjMS/ZCKqAhVK629nPqaTZ0K2Zw2sk4UOSMipYE5PClyfpzUrKHnxBw1iai8w/PCyuUDBI2c5/fojL8RPkDMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XlLG7m30kwVOuRPzmIdBGQ8rtLT2mvx9QvGpuSmXea8=;
 b=IetuHc8N3YMPRMrtRex21aA2lq8pLu7zqTfkERhVQS4T60Ize4bdpYUeqAfB6jnp1Z0BznrRvALSblJ642yOd7jH5BtueyFGru9ZW+EHbfS0PS4lxLZV3AM5ttN0aSgIhGkg2UvlZ/TCVhgrMQklgQdIhhQiRepHyetsOxf/aN9qYfCKqqeyn9xDd+lvY/i1+omS2JAsNTyV7V0rpEQCdqazZrF6Qphphra288i9HO3zJzqtrfRJ1+mZmcLFAdHv00zdnQXd02dUHaDYO7gXH7USue3EypxSRv+6hZpRQGRMglpkFeuG2HTfTHSjplqDav3oZXH6cUv0dW/YjKNMHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XlLG7m30kwVOuRPzmIdBGQ8rtLT2mvx9QvGpuSmXea8=;
 b=HuIWI9DnCJgZ3oKjN+qlpsLl/LvHHvd2FVYWS3x7BI0S+LiKS/lsGhPQygexY4TfvEwTdJuKylR634iTzCuaJR6bFfU3O2wvwHZ+Y4mF3hCn5VG3x7tWeO35nH/4eCVjwEQA9OyZ1BW6Ctc+mM69djiZn2gWocfIzt22lpsipVg=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN6PR12MB2624.namprd12.prod.outlook.com (2603:10b6:805:70::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.31; Mon, 7 Dec
 2020 22:38:01 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::d877:baf6:9425:ece]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::d877:baf6:9425:ece%3]) with mapi id 15.20.3632.023; Mon, 7 Dec 2020
 22:38:01 +0000
Subject: [PATCH 2/2] KVM: SVM: Add support for Virtual SPEC_CTRL
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
Date:   Mon, 07 Dec 2020 16:37:59 -0600
Message-ID: <160738067970.28590.1275116532320186155.stgit@bmoger-ubuntu>
In-Reply-To: <160738054169.28590.5171339079028237631.stgit@bmoger-ubuntu>
References: <160738054169.28590.5171339079028237631.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN6PR08CA0015.namprd08.prod.outlook.com
 (2603:10b6:805:66::28) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN6PR08CA0015.namprd08.prod.outlook.com (2603:10b6:805:66::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Mon, 7 Dec 2020 22:38:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d7a4100d-1e79-41f2-3571-08d89b00c0e4
X-MS-TrafficTypeDiagnostic: SN6PR12MB2624:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2624D38CA026ACBB11479C0195CE0@SN6PR12MB2624.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sEihhe8ISiYrHup2HJH84msXdBA2hKrfJr2tRVVS6DFvBRAFDZzpW7CFAkfllHo6VjVKFiozab5UqHbAPMVUZwwaQcf30GtXoes6YJ7T4mdkH8/aGl/NDXNqGjapDCaTD4qNGl+zD/S1L3rNAgJZrHdofgs7rsxiL7V4D3uI2pADP5V2U4ng3JumjivljOoxnE//js/V4PMk9W58Nb8HAjib0Cme2pVBpWxFgvtnUWY3kJATIYfgkREJQ20n5dIv4KR2g5iTthQ6rw4Ahvrx0QbS89ZCII8cWiE5lBsYUJl4MONyc2zKPTnke0oPQA0kZZRpRJRdw45zrkQzJo/D+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(366004)(346002)(136003)(376002)(39860400002)(7416002)(8676002)(66946007)(5660300002)(66556008)(86362001)(478600001)(66476007)(83380400001)(16526019)(33716001)(8936002)(26005)(52116002)(103116003)(6486002)(44832011)(9686003)(316002)(2906002)(956004)(4326008)(186003)(16576012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RTVETUR1RWg2WVE0eE9USVpwUi9obXdkdWEvRXFwWlJYb1Z1TmExUW52NFly?=
 =?utf-8?B?bVJ4QkdUQVBnbTNFRmF1OWxILzRhNEFRVFVadkEvYld3YlBFMkx5Zkl1aHhE?=
 =?utf-8?B?S01qb3NXYlp6M1FUQjgvMW80dG8ybldMbFRDVG9YY010aklKbVBzVndwMGRr?=
 =?utf-8?B?cmdFdDEyWk9tbGFBdFgxUXFqOFFJVUpLZlErVlhKZXBnbDlwZHFtcVBaNXI4?=
 =?utf-8?B?ZHN5cmxWdnZFNmRCVUdNRG5FelowOUsvdFhUZzdFK2F2bHRnQlUxeEwzSllz?=
 =?utf-8?B?Y3JRQWdsaFZpNEZqTEM0TkpzTjczWW1EalRXT2hkY1dVak9iRU5tMEdlUGkz?=
 =?utf-8?B?bnR6Qm1kWTFDL3lyQUZyWm1iOGU4TU1HYWpBSmVSazZUeTZsc25ncW1zWkpa?=
 =?utf-8?B?dmt3eUVLNUJlRGc4UlVIekcwMmNZcWFmRXlGZ3ovUHhMMXBHM2FBKzhJMHo5?=
 =?utf-8?B?NmJGOHQyWnh2TUpZQTd0a0RYaXQ3cS9HQUhraldBTERraFNab2Y2UmpwUC9h?=
 =?utf-8?B?bnRrUVE5TXRkN2Y2ZVpoVlZZV3JlT3hsdHhhbktkRTRBSGJScGRrUENDenhI?=
 =?utf-8?B?Y2tyTjNsUk1rdFhWRE4rb09ickRNZ01YbkkvQzlvL3EzUHpUdmRlcFN3QTNS?=
 =?utf-8?B?Uyt5UUlWUjlFL000encrMHg1bjVyM2VDN3htT1NkRVZNQ1hsMXl1b2plVUFY?=
 =?utf-8?B?dmwzUHdhNE1CVWhsbEJnNEZqZGJMME55eVZEcElGN2F2RTZjRVBadzFHdWUw?=
 =?utf-8?B?bERSd2g5Z0x6TWg5M0lpYlFvUExSTVNEVHRlSThEQ3F1ZGhBb0dwTTI0NnFP?=
 =?utf-8?B?YzZKVDN3UjNtMHRWWTB3WkV3RHBNWFQvL0JMSHVuZjVhNFdDZGJFZ3ozcEov?=
 =?utf-8?B?VC9ldmpGazhqaVp4dWxhUTJjMWQ1eXQ2Qyt2U2tETjZtcko3cjFoT3lybzE0?=
 =?utf-8?B?WkIxbFVsZUErUXloL1RveDFReHRNK1pHZVM4K2ZPV09mVm5WaE1qVFJIMGoz?=
 =?utf-8?B?MXFweFZNb2pFVXdZMXVYTVphREo3VC9Bc1JMd3RKck82UGZtclFWdWszMmpo?=
 =?utf-8?B?bkNUU2RKMlFxK3Jwa1RVcThtRHpMbWdrNUprVVRYSmxzMjE1eCtJdndobFZy?=
 =?utf-8?B?d3ZJK2V1bnFmY1pVRVMwbUlyVW82aTZ3RzZib2FDbFZVMURyb3N6eEV3dHdW?=
 =?utf-8?B?eUxQcjM0aFZ6aXBzY1gwSnlUaXZDRzlEQkN3MlFCYjBsc0R2MHFtT2pHZGNp?=
 =?utf-8?B?Q3dOOWozRGRFdkVERDlrSkJtdGxCUlFCa1prczl2NENUamd5RnNBWTVDOG90?=
 =?utf-8?Q?6J1SzP8nkC6eo=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2020 22:38:00.9872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: d7a4100d-1e79-41f2-3571-08d89b00c0e4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kg2viv17pp71YKH0XKhwHyhHQx603lNB5GibEWUl86InY5uwNvoKtiuWPLOUv4Mh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2624
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Newer AMD processors have a feature to virtualize the use of the
SPEC_CTRL MSR. When supported, the SPEC_CTRL MSR is automatically
virtualized and no longer requires hypervisor intervention.

This feature is detected via CPUID function 0x8000000A_EDX[20]:
GuestSpecCtrl.

Hypervisors are not required to enable this feature since it is
automatically enabled on processors that support it.

When this feature is enabled, the hypervisor no longer has to
intercept the usage of the SPEC_CTRL MSR and no longer is required to
save and restore the guest SPEC_CTRL setting when switching
hypervisor/guest modes.  The effective SPEC_CTRL setting is the guest
SPEC_CTRL setting or'ed with the hypervisor SPEC_CTRL setting. This
allows the hypervisor to ensure a minimum SPEC_CTRL if desired.

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
 arch/x86/kvm/svm/svm.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 79b3a564f1c9..3d73ec0cdb87 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1230,6 +1230,14 @@ static void init_vmcb(struct vcpu_svm *svm)
 
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
 
@@ -3590,7 +3598,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	 * is no need to worry about the conditional branch over the wrmsr
 	 * being speculatively taken.
 	 */
-	x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
+	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
+		x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
 
 	svm_vcpu_enter_exit(vcpu, svm);
 
@@ -3609,12 +3618,14 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	 * If the L02 MSR bitmap does not intercept the MSR, then we need to
 	 * save it.
 	 */
-	if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
+	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL) &&
+	    unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
 		svm->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
 
 	reload_tss(vcpu);
 
-	x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
+	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
+		x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
 
 	vcpu->arch.cr2 = svm->vmcb->save.cr2;
 	vcpu->arch.regs[VCPU_REGS_RAX] = svm->vmcb->save.rax;

