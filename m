Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE384858FB
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 20:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243414AbiAETN4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 14:13:56 -0500
Received: from mail-dm6nam12on2055.outbound.protection.outlook.com ([40.107.243.55]:22856
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243404AbiAETNw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 14:13:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ggagsk+PPi+eLgnvYjoC+R64gwBFTSn/qNr0RNbjNifk2FtTEySnqp65pKEeXlpngqLt7cg1q790cAe6/6UAhIJOCoZ0V0ZL1VxIZdaux57zU66oJovg6Wv8KEz4JENIUES+wSqGfZD4UrAjGg3P556fbHob/tjFSZ2iEqlMzbWsb+eTX5vWaW43AzxzXTmwmp8mSwA3UyLW2rbJRzffo58AS/KLs0/I0K8REonB5I6rVNKH8zTarW6c+Hl8A6cK/sBR29sTy02g25dbJ82xX3/q3ceH45y0kQHWA0aejPsaIAAC0YI0UyhHDS83nr2NXE4iV+sJmqPpcvvh5W6N7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YXVoxUmZ/L+hFG514SPIFWQy6hIyqCt/5bqeDC7G4tM=;
 b=KI7ey6ek2ZA29uiDpfxaXa/ZzGloRbSgTClzUkOHZ4us5Xb+To9fOzthq08xNfXIdBeIfeOC2DpJyhK1MIxKMnbK1L9iQfkcxoP3X2lkjvgt0ixr1IbyhHXpwJBG7KhbolG9vsHQmEGSb2lQrfHtJf9G6ctZ5VCr3s+T58LcVn0MGVD0uLatWhZ+cpOF8NZitbU4A3kvvSKhDSfqcIzr9al2yYAemesEWO+DCggImMB64L2FOcKSmDMBTnUe2HhFrmzjDIA1HuKoFqvcENFXiRsK+gFlID1dDhDAqOmrP/YllMF+G8hlEwXKCv3iRrlkIC9vH9CEwteGWwlB0nq3eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YXVoxUmZ/L+hFG514SPIFWQy6hIyqCt/5bqeDC7G4tM=;
 b=eww8MNS+zzYNsVkEFPm/EFiy4pI9QJCS2JyLTcicoVx9XnRgOGikwWYE6xhoNw6fniX6WC3fS29I9fLnOe+Au+h8HHzoypqWN0KrCTMRYNaSHKBiWFPKASjYFEEB3+ZWSOm/tg9yymPeJXP8pEIAMUf70VTe7r0AwYwwH9ZBc08=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM8PR12MB5414.namprd12.prod.outlook.com (2603:10b6:8:3e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Wed, 5 Jan
 2022 19:13:50 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::2429:24de:1fd2:12c5]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::2429:24de:1fd2:12c5%7]) with mapi id 15.20.4823.023; Wed, 5 Jan 2022
 19:13:50 +0000
Subject: Re: [PATCH v5 7/8] KVM: VMX: Update PID-pointer table entry when APIC
 ID is changed
To:     Zeng Guang <guang.zeng@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>, Gao Chao <chao.gao@intel.com>
References: <20211231142849.611-1-guang.zeng@intel.com>
 <20211231142849.611-8-guang.zeng@intel.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <640e82f3-489d-60af-1d31-25096bef1a46@amd.com>
Date:   Wed, 5 Jan 2022 13:13:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <20211231142849.611-8-guang.zeng@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR04CA0029.namprd04.prod.outlook.com
 (2603:10b6:610:52::39) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 03001b38-7bc4-4966-3a7e-08d9d07f815c
X-MS-TrafficTypeDiagnostic: DM8PR12MB5414:EE_
X-Microsoft-Antispam-PRVS: <DM8PR12MB54143CB1B02936D2B4293D43EC4B9@DM8PR12MB5414.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:597;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ssyZjPEliEZ7rcdYU61hKqktAyIDj1ZrPmy1UV+VVEDjsc2J5cdhK9LR2WwRlTvz/PPwv7bJubGOfTUwlVf0mfcGsSp+1FMrqxBVwAu2wCFsVujPhJxeR8FXncPFEzeAvIw/cs3pbCgch2J2mggfrNiO5F/fk+7jvkR5dBgB3Q0thtCBcI9hwM9iAz8OZxeWCyvw+FZLeX5YCiBHrewE7SJphOJMHNntVrXiKJe5R9GLz/KH3MDGjQS3FpjJh/7xcV5JXgl8IV3lOFU+0Huh7B0H3I3Tww2uiZVbS+HGZR/x/zq+DjZnycxmKG2fuy/81KFsHDAKUtxC5N98dZ4UABZkCwil/HK7NKDcdESjd56hPng2/uSVDyu6ZwyW5ykO22ohoApM8R2O86w4EtdJQTq0Stz4lt58sB51bh3Fhcrq2ei/W2/GqZJpf+EEd8vlTFMImUUvLHA0OgZKiXdzkx6WefHjjoXikQxJ4GAJ7+6GTRX4yhUl2Plekewtt8IQeLmijcSlArfXbKhlAt3FqOmwg3qo1XkxxA6QuOFrprFku3YDAkXBR/Kn58U1fyclRJuE6LtR0PfrJRe0iP/ITsOdT1Yev6L7NbzgrJYIMJWwDCSb8pKVEXtpNqoX51dHWV9nwVkVbkmCOEzBhsQFn95GVGuI6WFrnzVgXurERm2EAkcFPZ1XC9x7uFbse570SfmV7khKJzyXPw9GJSJF61VAAt2UvXApJ44TxOqKonNoyH+Nu3C//j4hVKXBlcjb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(508600001)(2906002)(4326008)(6486002)(86362001)(31686004)(6666004)(921005)(83380400001)(6512007)(36756003)(15650500001)(66946007)(110136005)(38100700002)(5660300002)(8676002)(54906003)(66476007)(66556008)(186003)(6506007)(26005)(7416002)(31696002)(8936002)(2616005)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a0xJM2UycXlRNHord0k1bFpoaXV2aTRvZlh0ODJ4K3ZZS3JCS2x0dXhKb0hS?=
 =?utf-8?B?eFJKYTloSUtMOEJmT0U3SHFtU3hGaTIxTVh1S2YzTWFWU1EwMS9MNmJSRWE2?=
 =?utf-8?B?WnZzdE1MbUdNV0ZRNHlLNnp2STNmcEx3ZFlWSFBUcDFYR2JES3VKTm0yMVdn?=
 =?utf-8?B?SGNLTnc2K1MrZmd1dlFieUlkc2lMVVFva2phL3V6OHlTZktpZFZJZFhyWWto?=
 =?utf-8?B?ZkxZQXJ3YXNGMUFmSlFkZXRBaTRsZ2xoUTgyakFaOE5SQXZvQ1J6dDRyKy8x?=
 =?utf-8?B?ZkN1OEtOR2VFbmRqNTkrWHVSL1paZlRpalJ5bkNmWXp4elRWZmFIemErYVQ4?=
 =?utf-8?B?TExSNFN0UERjeVRUb2Y3dFE5S0Rsd0lrM012bWV3QkkrQ1B6UEhEeG5WMFpZ?=
 =?utf-8?B?d2JlaDFTOFhPNmZwQkdwYm1ITFBNdDlLQlhsN3Y1NXFHNmZkb3VWY2FjK0VI?=
 =?utf-8?B?YVdCbmlIVXhXT1ZNbzZ4THZ6ek5ZM0hrSW1XbmZIbE5GSVROZDk2QkpqcHRI?=
 =?utf-8?B?UW5WNkx1YW0xb0g3bmFwWCtuZ0dZL1lhbjAzSUxNenZnYTd4ZlFZekR0K3Mw?=
 =?utf-8?B?N1FmQTZWVVZKQ3dvMlNLUUtXbkdXZ3JoWXlVTFkvTnIwa0R2UHd3QjlveGdX?=
 =?utf-8?B?dGZueXdlM1loUHpFWllnZTI2K3dSNnRDWGJISG9oeDVhZVdac1o4akdRaDB0?=
 =?utf-8?B?dUVEQmg4UWNxM2JsdGN5N3BXMTk1a0ovQUExZmdjNWtGYkpmVkdPTnJueDJv?=
 =?utf-8?B?V0ZFNEJHdG5DYmJjb2RqV2ZlRURhdlhIQ2ozM3NrNkJPYVRHUjR2aVhLMGpK?=
 =?utf-8?B?ODVybE9WZEs2M2lFQUdZby9yOEVWd2ExZGRjR0R6OTBlMk1RbTRBdy9jQ2cr?=
 =?utf-8?B?SURtNVk0NW9wYStZTi9obEFSa0FtZDl2UmRPdlhZaWltMXR3VmJIcnBId2lu?=
 =?utf-8?B?em9aT1JtUnRidExLWTZ6ZHQ5K1haYmFMY2tPUDRtNG9yRVNmR0hyai9aN29z?=
 =?utf-8?B?YlJmWWc2UHphVTZxOFBsWmovbUZyMS9nT1hqd25IREV1ZnQ4N296Q08vbFNL?=
 =?utf-8?B?aERsRkFFMERHem9zWlRlTWJiU3Q3ZHhrcVpoanNzeHBmZ241V0FCbWJ0Q2Fh?=
 =?utf-8?B?RDFGWnk0ejhQYzNIU2hmNGxpR0l1WmR5VmpHb09iazE1UU9aOFlTV3JJRUg2?=
 =?utf-8?B?TjI5NFRSaWVxVGZBVmhaUXR5Q2oyVUhMK3lkV0RQVFRwQ1U3Qy9GREl2dUta?=
 =?utf-8?B?T2twelVkSzZBZHNZWUxsNE9RQ1BjSUo0U1JCbjZpRnBZQmEvZFh1WFNRN2Ft?=
 =?utf-8?B?RXZTTmM4LzB5MDIrS0lldHEyeEJzYUMvZnBxblNiMjBpbHN0OXYxOFQyUFpD?=
 =?utf-8?B?a3lQYTA1b2xqUnJDcGM0ekZOUDVIbGVjOG1jdm9BR2hXSk5tZExNR3lLL2FX?=
 =?utf-8?B?UUlERlJXLytsc3ptM1hod3JCVHdkN1FacWIxZjlvNzdYT0loS0w3MjBPd1NP?=
 =?utf-8?B?azdWQi90N3c0amdGYldHbVRPcjQ5QVV1QkFDZkQyUFg4SXBVbmE5SVlsWmYv?=
 =?utf-8?B?Z240TVVURW43bTBKOVBDeTAyNTd3QXJNcE9sb1V5ODVxTDB2ZFlETnB6ZTFi?=
 =?utf-8?B?bW8vVThIK0JqNnVCM2tRbmM3aHM5MVo0RzF2MGNLbkhiVklhN245bkQzdCtu?=
 =?utf-8?B?L0dOY2g1ZUMwWmVxWWZRVEZuRzRYaFNwcWdoRllzOXhDRjFRYVZsMUZ2dTJK?=
 =?utf-8?B?OGlXaWd1eGJBeEN1azB0Mkd6WTBuOU04Q1cyMW9sSTFOa2xsOXBqNzJYdFNQ?=
 =?utf-8?B?a2g0and3Q3N6anBQNnRsWlpxMzUzWnpwMEtYK1hROW5OTDJOdWJ1ZFFtdnp0?=
 =?utf-8?B?SnVXaWhjL1E4QXV1bHU3NTZDVEtNRlcwVzNVVmcvcjhMVUZyNkhrWTBCZ2pO?=
 =?utf-8?B?YW94K1ZTVldOVmx5V0hSeWFJRldEU2QrVzlIMWpIczhYcVIzSG0wL3JoQjA4?=
 =?utf-8?B?Z3lBeUljakFWTFRra29ocTRmbnlmdFpBQlpERGpsRUZPMHRZclByOHFVbllR?=
 =?utf-8?B?MmNPL2Q5RERrZnhObVE4dkV2eEkvMktURzhhOUdXQXd3cnFkM0NSeFNzSzBH?=
 =?utf-8?B?WnhXd1ZTcjFidS9ZQ1RDNlNRSHFLWlEwdGNaMnI3Qm5kMVhGaEkzNXcyeHdi?=
 =?utf-8?Q?yf2CbDgIraQVOQp/SAnXsfo=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03001b38-7bc4-4966-3a7e-08d9d07f815c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 19:13:50.1583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /n2XML08Lto0gUFCO4qcfqc/EhagYQeplb/TS2noTQrSLW69gBWWm2x7mh65L/Ug3S1raJphJskyrrQZVOSS6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5414
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/31/21 8:28 AM, Zeng Guang wrote:
> In xAPIC mode, guest is allowed to modify APIC ID at runtime.
> If IPI virtualization is enabled, corresponding entry in
> PID-pointer table need change accordingly.
> 
> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  1 +
>   arch/x86/kvm/lapic.c            |  7 +++++--
>   arch/x86/kvm/vmx/vmx.c          | 12 ++++++++++++
>   3 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 2164b9f4c7b0..753bf2a7cebc 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1493,6 +1493,7 @@ struct kvm_x86_ops {
>   	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
>   
>   	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
> +	void (*update_ipiv_pid_entry)(struct kvm_vcpu *vcpu, u8 old_id, u8 new_id);
>   };
>   
>   struct kvm_x86_nested_ops {
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 3ce7142ba00e..83c2c7594bcd 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2007,9 +2007,12 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
>   
>   	switch (reg) {
>   	case APIC_ID:		/* Local APIC ID */
> -		if (!apic_x2apic_mode(apic))
> +		if (!apic_x2apic_mode(apic)) {
> +			u8 old_id = kvm_lapic_get_reg(apic, APIC_ID) >> 24;
> +
>   			kvm_apic_set_xapic_id(apic, val >> 24);
> -		else
> +			kvm_x86_ops.update_ipiv_pid_entry(apic->vcpu, old_id, val >> 24);

Won't this blow up on AMD since there is no corresponding SVM op?

Thanks,
Tom

> +		} else
>   			ret = 1;
>   		break;
>   
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 2e65464d6dee..f21ce15c5eb8 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7633,6 +7633,17 @@ static void vmx_vm_destroy(struct kvm *kvm)
>   		free_pages((unsigned long)kvm_vmx->pid_table, MAX_PID_TABLE_ORDER);
>   }
>   
> +static void vmx_update_ipiv_pid_entry(struct kvm_vcpu *vcpu, u8 old_id, u8 new_id)
> +{
> +	if (enable_ipiv && kvm_vcpu_apicv_active(vcpu)) {
> +		u64 *pid_table = to_kvm_vmx(vcpu->kvm)->pid_table;
> +
> +		WRITE_ONCE(pid_table[old_id], 0);
> +		WRITE_ONCE(pid_table[new_id], __pa(&to_vmx(vcpu)->pi_desc) |
> +				PID_TABLE_ENTRY_VALID);
> +	}
> +}
> +
>   static struct kvm_x86_ops vmx_x86_ops __initdata = {
>   	.name = "kvm_intel",
>   
> @@ -7770,6 +7781,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>   	.complete_emulated_msr = kvm_complete_insn_gp,
>   
>   	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
> +	.update_ipiv_pid_entry = vmx_update_ipiv_pid_entry,
>   };
>   
>   static __init void vmx_setup_user_return_msrs(void)
> 
