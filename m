Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 855CD2E991D
	for <lists+kvm@lfdr.de>; Mon,  4 Jan 2021 16:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbhADPsE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jan 2021 10:48:04 -0500
Received: from mail-dm6nam11on2064.outbound.protection.outlook.com ([40.107.223.64]:56512
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726333AbhADPsE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jan 2021 10:48:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lYP7MLYCugXjtZYrqcbnHLomhY7whuQdR8uvW7kkvjeTjLQgUupgsF68b2bP+7CbrTTH7hgXjxhJ2zqtovpnwCUsuT+ptWOtJrrn+M4EJW79m9e8K7nII70vjPf2hmhqkU3HinkyIUpjKO0U5JhRDL3jQbvGVCrZVklMz3dL66udSz5/ImNvkgfn3fdU6mMw0JHpAN/f/Hbvx5b34C4InvuYCjHC2H3jSHRrTPrM2C4NIgwlzEJGNeTOSomlJPCxIrOvY7gRC3k+DaMgkoqM1+tXeKuvypBi+nisbgaZwnc13SW8AQcaIpt9h3BtEiBfz71l7zbB44gI8r62EDPISQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=INlFJg+cMQqi1eyrQved7DlCYFm/i+TZnif3o5XiVvo=;
 b=eTwytTEBfMrc1VUKjKcPbbPXOclyUCWvKYJHr8+VBdB2SFzzLvQCN4Z3fPWF9zgpzSNH6XJ3xiJlDPChbGtPsyFFvUW0bebgYKoI9bECLS6ayLd1+UkyuA4NSZb/o9LlG0PCBY6a6HhhXVxgl58XuUAhwDYAgDAb8pFrdIJqTqzp9A/qijzHoCH2Xyh2h8E9G/Ntuu+DGyqsZpv9OOiTeSNpytQvy+Ll7L5WoC3ZFrYhR+ufsWbCmwdtr24JOQs/0/l1lJqMo2eNFZINHW/rjsXT237Atg6px7CxzST0C1aGz3EWdsm99da8p6+Tkb2JJlmds9Ed4AXW5GpgVuP/qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=INlFJg+cMQqi1eyrQved7DlCYFm/i+TZnif3o5XiVvo=;
 b=DF/Jp63IeIoDDN3ge4c0HTctnnTxHGhr+iUdIrU4BbbwiKKtLh7J9uz85E8k76hF/RgBJF/PAamovugjzAqApK/cCuDo4lefzGTw3N04PPj5DjP3CGKBTVLSTsU4n+wln4RU42hSyF0bHqAY+aLXKwYM7hpMS+jEgYw/+7fMMUM=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB2358.namprd12.prod.outlook.com (2603:10b6:4:b3::34) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3721.19; Mon, 4 Jan 2021 15:47:09 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3721.024; Mon, 4 Jan 2021
 15:47:08 +0000
Subject: Re: [PATCH v2 2/2] KVM: SVM: Add support for Virtual SPEC_CTRL
To:     Babu Moger <babu.moger@amd.com>, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de
Cc:     fenghua.yu@intel.com, tony.luck@intel.com, wanpengli@tencent.com,
        kvm@vger.kernel.org, peterz@infradead.org, seanjc@google.com,
        joro@8bytes.org, x86@kernel.org, kyung.min.park@intel.com,
        linux-kernel@vger.kernel.org, krish.sadhukhan@oracle.com,
        hpa@zytor.com, mgross@linux.intel.com, vkuznets@redhat.com,
        kim.phillips@amd.com, wei.huang2@amd.com, jmattson@google.com
References: <160867624053.3471.7106539070175910424.stgit@bmoger-ubuntu>
 <160867631505.3471.3808049369257008114.stgit@bmoger-ubuntu>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <f7fb8383-6bec-3982-7526-f9ea7ab3673f@amd.com>
Date:   Mon, 4 Jan 2021 09:47:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <160867631505.3471.3808049369257008114.stgit@bmoger-ubuntu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA9PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:806:20::7) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA9PR03CA0002.namprd03.prod.outlook.com (2603:10b6:806:20::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.30 via Frontend Transport; Mon, 4 Jan 2021 15:47:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8c75f79d-fa81-425e-3495-08d8b0c7fe3b
X-MS-TrafficTypeDiagnostic: DM5PR12MB2358:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB2358BD767D54569E05C18ECBECD20@DM5PR12MB2358.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xkHZ9vseVZdRgH6vKwvoc9QmZgH7cV0A1VjOw5Lj5hW/yvXI3ySGf6OD6QeEu3/rGvL24OrttrGPzWXu7awaw5yUA+wGxvN6hxbJqsGx2+2jVgL1EO+RAXlRr2teA4cb5fm37ESz47Icep1AX8ku3uhRsmrF7e9dgU0NK+knwHDByHf27PCk507Y0tTFylbDHxsKIDe14QUlwTM9b+M5amSJlRiz1j4TXrLU4wuTgK4g4IhEAqLn4ypLe6z49DQe15KLwLhY8s/UplFUvNA7CgoqsBwBE32XwNBOJSA4Uc9zTQ7KHH2PSSvWKwaYoT4d3kVhOp2KBSbmPE518njMYj4FduF2v/OqKd6gGeJceGX1NsdaGuy39Djwc3HEQiHgzYV5fPK1zkekC7eC70v4VUtGbGZ4jO+c7ghAgXXNnOicFBoQ+uPIb50KvbgklY/P7X28AnYDPxWQ90PXO9j8Vq2xCYlZR1ybTtPvnTW4xAQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(136003)(366004)(39860400002)(66556008)(478600001)(66476007)(31686004)(4326008)(5660300002)(7416002)(36756003)(83380400001)(8676002)(53546011)(6506007)(316002)(2906002)(16526019)(956004)(2616005)(52116002)(31696002)(86362001)(26005)(6512007)(186003)(8936002)(6486002)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?c3ZiTzlFMjdNekU1RTJwd0Mvb251SHptSVRIeWVMRGh0cFo1M1BkTjROUHBi?=
 =?utf-8?B?QU5FaGFlSmwwUUNJS1hBYXJxdUR0RThBT0h1MjBIVk1jY1BSd0FLeHFYQVY2?=
 =?utf-8?B?cGZLSFhNU2dlVVMybmowWGZvZnpSV0JiaG1QN21WRXBaZjJJZUtoK09uN1JJ?=
 =?utf-8?B?RTJ3dUtmL25RZHZLUjltYnRrY1dUNkI2UWxmMHErMlFqaVFES1ZvSFlhNEdv?=
 =?utf-8?B?N01McHd4RWZleC92ajVENmgyOExleEtsQXdhU3JVT0FIaFZLWi9HZGhDeW1D?=
 =?utf-8?B?QjY4VjFJdzdVeGRPZWZmUGtXb2dtYVFSeFl6aWwrSzZrdHp1UFdmYjgrK1lB?=
 =?utf-8?B?eEVjazdVUDhsYWVHeERUSXVtTGprR1lOeCtiYVNNSCtmZTVxakVFSFJQWFkr?=
 =?utf-8?B?bXowc0Q3Q3VRR1NqQUZBd0p4TUUvODREU3UzTFluQXMwZkM0YkVmUE84V1RK?=
 =?utf-8?B?TVpMSzhrRXF0cjkwOHBtOWYxc0p4dXRSRUlGck1JR3Z3a0JBa0lPSWhUS1I5?=
 =?utf-8?B?WmYrTVdqcE5kTjAyL0UvVlI1eDZ0SXRvbzRyZGM3MTdVNE1MVFZBVk5LaEdW?=
 =?utf-8?B?L09jMStrMy8rN3pwQnBtZXZZV2ZZbDBScE9lQndEaThBOUlQdVNDcTV0bHRG?=
 =?utf-8?B?THQ3SE1NNnFObjRzSUtDdnZET3FXQWNzeUxINE9rbytRdlVhVyt1R0VZaU56?=
 =?utf-8?B?SlhIOTd4dkZPdmdRVHBTbVU0bURqRlhmT2lUWTZQbG9NWU8reXpiU1pMK0pk?=
 =?utf-8?B?UGh6VEpsWEZHOHhtZTdpNFdtd2xwS3N2aUorRzBTSVloNEFIa2daL0VsdGJo?=
 =?utf-8?B?cDhMRW9FVW9qSjVNUVJ6STdVSk4vYUFub1JqcW5EYnRHdXhCQmtpdEt6a3Fv?=
 =?utf-8?B?T2xnLytDb2Ivb055VTcwR2QwQUdvLzYwZmRSa2Y4SU5rL2VPZmM5eklYcXNo?=
 =?utf-8?B?cDByMmdHQVFpdG1RZk5HZHZpRUI5cTBSVkphbE93YlBBc1d6eHNOQmRSUEly?=
 =?utf-8?B?MTFzeFNob0JWa3h3OUNmUmZlUE1qTDJTN3ZBdGRhMzVZcWhqQUpIUGF3L2sx?=
 =?utf-8?B?S2kzVkpHMUswYi9JTUNKaGJ3cFUvRTI1eGRmUlY1Y2xEd29oalBTMjA3c0Fo?=
 =?utf-8?B?M1JTQjZKSFdnVmZ3aUI1ZGhDS2FaeUZxci9Rc2lZWVRVZ0gweG5WWHFhaXQv?=
 =?utf-8?B?OHZaYVU2dUpqOG1xN3gwVXR1R1IzR2thZ0VWUXhlMlFIT21LM2NpbllTUloy?=
 =?utf-8?B?UXBpVGZpNk15UDU0a2lqTys3MFFJT09pb1hkS2d4bzhTbjBuVDF3ODBaclR5?=
 =?utf-8?Q?h2vWZGM9iUkchXVw6U9YS6N4/6i6vlHjj5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2021 15:47:08.1599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c75f79d-fa81-425e-3495-08d8b0c7fe3b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A+z7MkwuqWlJ30U6ZobPpeHmPkPy6d1pz6HSTpfh3qtkShIdvR7H3LyK47sNppZ0mna6VU9z0ykBShdhfwLbqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2358
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/22/20 4:31 PM, Babu Moger wrote:
> Newer AMD processors have a feature to virtualize the use of the
> SPEC_CTRL MSR. A hypervisor may wish to impose speculation controls on
> guest execution or a guest may want to impose its own speculation
> controls. Therefore, the processor implements both host and guest
> versions of SPEC_CTRL. Presence of this feature is indicated via CPUID
> function 0x8000000A_EDX[20]: GuestSpecCtrl.  Hypervisors are not
> required to enable this feature since it is automatically enabled on
> processors that support it.
> 
> When in host mode, the host SPEC_CTRL value is in effect and writes
> update only the host version of SPEC_CTRL. On a VMRUN, the processor
> loads the guest version of SPEC_CTRL from the VMCB. When the guest
> writes SPEC_CTRL, only the guest version is updated. On a VMEXIT,
> the guest version is saved into the VMCB and the processor returns
> to only using the host SPEC_CTRL for speculation control. The guest
> SPEC_CTRL is located at offset 0x2E0 in the VMCB.

With the SEV-ES hypervisor support now in the tree, this will need to add 
support in sev_es_sync_vmsa() to put the initial svm->spec_ctrl value in 
the SEV-ES VMSA.

> 
> The effective SPEC_CTRL setting is the guest SPEC_CTRL setting or'ed
> with the hypervisor SPEC_CTRL setting. This allows the hypervisor to
> ensure a minimum SPEC_CTRL if desired.
> 
> This support also fixes an issue where a guest may sometimes see an
> inconsistent value for the SPEC_CTRL MSR on processors that support
> this feature. With the current SPEC_CTRL support, the first write to
> SPEC_CTRL is intercepted and the virtualized version of the SPEC_CTRL
> MSR is not updated. When the guest reads back the SPEC_CTRL MSR, it
> will be 0x0, instead of the actual expected value. There isn’t a
> security concern here, because the host SPEC_CTRL value is or’ed with
> the Guest SPEC_CTRL value to generate the effective SPEC_CTRL value.
> KVM writes with the guest's virtualized SPEC_CTRL value to SPEC_CTRL
> MSR just before the VMRUN, so it will always have the actual value
> even though it doesn’t appear that way in the guest. The guest will
> only see the proper value for the SPEC_CTRL register if the guest was
> to write to the SPEC_CTRL register again. With Virtual SPEC_CTRL
> support, the MSR interception of SPEC_CTRL is disabled during
> vmcb_init, so this will no longer be an issue.
> 
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---
>   arch/x86/include/asm/svm.h |    4 +++-
>   arch/x86/kvm/svm/svm.c     |   29 +++++++++++++++++++++++++----
>   2 files changed, 28 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 71d630bb5e08..753b25db427c 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -248,12 +248,14 @@ struct vmcb_save_area {
>   	u64 br_to;
>   	u64 last_excp_from;
>   	u64 last_excp_to;
> +	u8 reserved_12[72];
> +	u32 spec_ctrl;		/* Guest version of SPEC_CTRL at 0x2E0 */
>   
>   	/*
>   	 * The following part of the save area is valid only for
>   	 * SEV-ES guests when referenced through the GHCB.
>   	 */
> -	u8 reserved_7[104];
> +	u8 reserved_7[28];
>   	u64 reserved_8;		/* rax already available at 0x01f8 */
>   	u64 rcx;
>   	u64 rdx;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 79b3a564f1c9..6d3db3e8cdfe 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1230,6 +1230,16 @@ static void init_vmcb(struct vcpu_svm *svm)
>   
>   	svm_check_invpcid(svm);
>   
> +	/*
> +	 * If the host supports V_SPEC_CTRL then disable the interception
> +	 * of MSR_IA32_SPEC_CTRL.
> +	 */
> +	if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL)) {
> +		save->spec_ctrl = svm->spec_ctrl;
> +		set_msr_interception(&svm->vcpu, svm->msrpm,
> +				     MSR_IA32_SPEC_CTRL, 1, 1);
> +	}
> +

I thought Jim's feedback was to keep the support as originally coded with 
respect to the MSR intercept and only update the svm_vcpu_run() to either 
read/write the MSR or read/write the save area value based on the feature. 
So I think this can be removed.

>   	if (kvm_vcpu_apicv_active(&svm->vcpu))
>   		avic_init_vmcb(svm);
>   
> @@ -2549,7 +2559,10 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD))
>   			return 1;
>   
> -		msr_info->data = svm->spec_ctrl;
> +		if (static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> +			msr_info->data = svm->vmcb->save.spec_ctrl;
> +		else
> +			msr_info->data = svm->spec_ctrl;

This is unneeded since svm->vmcb->save.spec_ctrl is saved in 
svm->spec_ctrl on VMEXIT.

>   		break;
>   	case MSR_AMD64_VIRT_SPEC_CTRL:
>   		if (!msr_info->host_initiated &&
> @@ -2640,6 +2653,8 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>   			return 1;
>   
>   		svm->spec_ctrl = data;
> +		if (static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> +			svm->vmcb->save.spec_ctrl = data;

And this is unneeded since svm->vmcb->save.spec_ctrl is set to 
svm->spec_ctrl before VMRUN.

>   		if (!data)
>   			break;
>   
> @@ -3590,7 +3605,10 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>   	 * is no need to worry about the conditional branch over the wrmsr
>   	 * being speculatively taken.
>   	 */
> -	x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
> +	if (static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> +		svm->vmcb->save.spec_ctrl = svm->spec_ctrl;
> +	else
> +		x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
>   
>   	svm_vcpu_enter_exit(vcpu, svm);
>   
> @@ -3609,12 +3627,15 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>   	 * If the L02 MSR bitmap does not intercept the MSR, then we need to
>   	 * save it.
>   	 */
> -	if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
> +	if (static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> +		svm->spec_ctrl = svm->vmcb->save.spec_ctrl;
> +	else if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
>   		svm->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);

If I understood Jim's feedback correctly, this will change to something like:

if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL))) {
	if (static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
		svm->spec_ctrl = svm->vmcb->save.spec_ctrl;
	else
		svm->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
}

Thanks,
Tom

>   
>   	reload_tss(vcpu);
>   
> -	x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
> +	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> +		x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
>   
>   	vcpu->arch.cr2 = svm->vmcb->save.cr2;
>   	vcpu->arch.regs[VCPU_REGS_RAX] = svm->vmcb->save.rax;
> 
