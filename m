Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF7426A6AA
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 16:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgION7q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 09:59:46 -0400
Received: from mail-dm6nam08on2053.outbound.protection.outlook.com ([40.107.102.53]:8993
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726463AbgIONyk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 09:54:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L5LXm4Rn4YbhZCK+p9J+VJwFqui0KeXJ2IX/LI7VqZfWF90cFS0OzPMLGQ2D/LcP495sUovA6ftP9HemXUR8dMyT5R7rG7x2GQqgZiI4VInOdXSPz0q0UjZFdbwK2QN6VvdTMjQZ6vgcQrO37XkYn0h8J0m9bQsbc3i2/405njeHEXxnxl9rNDBDXqMUyyJ/Xj5CS1wJ3K7hm7L63wiM4HYUPJYFIGAH1s4/ydC6bVnAgAAtLdk9lgmsw4p2z8fSn9PlDCSj/VG/CeJVexNDKqKX+vQjYt5zbXqZA4HnvFYD0lxm9CZy22vHmES8T569ebkH3S8oXTVTQ7r+ONEAAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GGF/fWX15NAQdjY1qAXjVsARwO5GPINAaDfAUelBiN4=;
 b=auArcioLqDJUOlkn62Bzg81tD8DKzfydrxeVK533eWoMgHU7Ktp3D48sbvDR6ymRrTz7PZZKXUjppA9Xidu+SDCRs+vj+dnwpFXCaqa+oEYyibw8i6ou9x2HtF4Mc0tq6inVLzbpiaoDXuSHPo0jGC/+Ra4xqODpQ3zmGjgyDS0MSrFD9odsVHxcmw5iZWHEMThEkXRpRsVA7xW1Um6wHC0ruEQLetYuDBSnA68RRdJaljFVCGml0o61Jg1j+6GVuOrTDpYgjljOKJzdi0QtB2jRGqdJ1C+HTQnbwJNn0uywyMAMAZT91YCuRLttT/z8+VOOzgqU0s9qF0skAIBYeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GGF/fWX15NAQdjY1qAXjVsARwO5GPINAaDfAUelBiN4=;
 b=OupnzTjpXDzK9zCMsojslVZ2yIhs1pir+lOuc4Ab7MhuJF2N+n54UgPrCB2GVe5r4PnYxIlMU65L2DojtnrCACHCoxWXenRs89uUVUK1SQeAd2RslawIVE7SujDjtsHn/jv65G9pot11sbgAeVerUSosSO9074xIrlLOvIY0lCc=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR12MB1926.namprd12.prod.outlook.com (2603:10b6:903:11b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.17; Tue, 15 Sep
 2020 13:37:15 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::989b:b1b2:464c:443]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::989b:b1b2:464c:443%10]) with mapi id 15.20.3370.019; Tue, 15 Sep 2020
 13:37:15 +0000
Subject: Re: [RFC PATCH 08/35] KVM: SVM: Prevent debugging under SEV-ES
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
 <58093c542b5b442b88941828595fb2548706f1bf.1600114548.git.thomas.lendacky@amd.com>
 <20200914212601.GA7192@sjchrist-ice>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <fd790047-4107-b28a-262e-03ed5bc4c421@amd.com>
Date:   Tue, 15 Sep 2020 08:37:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200914212601.GA7192@sjchrist-ice>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR1101CA0014.namprd11.prod.outlook.com
 (2603:10b6:4:4c::24) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by DM5PR1101CA0014.namprd11.prod.outlook.com (2603:10b6:4:4c::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Tue, 15 Sep 2020 13:37:14 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 80bfdd24-a4dd-4e39-0c97-08d8597c7547
X-MS-TrafficTypeDiagnostic: CY4PR12MB1926:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB1926051DA538BBFD26009750EC200@CY4PR12MB1926.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: li+AsokNHR7Jal67tJQx8PuLMBGN9iUewhhB7Zdg6vhazj57vE+iibCMPvj3zFI+cKLomLYBezAZlRK/tMin3EzhqOKk3BEcHpcjx8DLZF5ps6tl7faH25c33tB2D8w3uLTkBAIWXm1ImkzGQlGl54y5sihqbix+uDwG3FmKxOIWGFGiBbuOgRZ7Zg+dOHHztGEDjAF/dfEbXZMxc5eS5vJ11Smaq3izbJRiIWAn6TrGxuN915RfF5n5Pzr8IjY3cCbI9fUnR7TkClLKjDYYjflqf84M2Lyp7qMUDXMuojCedNY1vffRIOcgwtmfcImrk9I24jB6i0BSfoULhm3Gx2pyq02hPPT059TpRop7Uai+x9adsSGDNJT+ElC7TnMZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(366004)(346002)(136003)(8676002)(6916009)(31696002)(54906003)(31686004)(83380400001)(86362001)(2906002)(5660300002)(66946007)(66476007)(66556008)(478600001)(7416002)(8936002)(26005)(6486002)(36756003)(53546011)(16576012)(4326008)(316002)(16526019)(186003)(52116002)(2616005)(956004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: lmS4d5YKMidQrJbF+3iNwYgQCdAD+UyA9cDdSmn6PkD3N70lz+jDuZPb00QFyM2qByzYE7QQOC5/XMORHxvfeDE8nReW69fNmj/bVZWV1KADTnfch9HEI6E84CWH+YaiWBPX8V0Ykn0O3jxjFeVdGrRud4hORqOHJqT0Jy28h0XgpziB23m7k7qNVMZDEJA5Vf3pkbPIXEyDsAUiZlv1lHgx3dqKOBc9gz9yk9DMomsaVkZRC4M8e7h8GjPLd01hzZTTq45xidlnwNzpeHyAcUA815qeJAJZ+jF0Uy3ahnuYI1+h3SH3Sc4dR2EtJkt+sKMcpGmqFMeXjReTYMRlMGgU2BCoo3oVkgQG48IAp9S+uNPR0HPwZugWk2cLKDQOEOIdTPYtWvvxrFGiYpebtxsvtw+MWqoeNKKhuXzWXxxkev1vGndITnwqiJYq7w3icpuH6CzIH40cs1tQwnaaPisaOsL2TFKxhTgMVf7IA8y21XBZmmuOmntUCTTlJ+5eCplcQxjKAIuSGMNRHCdEGAw98iQgKj/F+paqPTVRHKyjX6WXBeQnCeQXkVX7GSFMUnGRUWPSSVN66OwDeHTmA9D/t5B265Xu/JsjKEYOPouqD19DUjYLwbJdISKNCou/Ve/54SY+Q79IM5Bff2riyA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80bfdd24-a4dd-4e39-0c97-08d8597c7547
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2020 13:37:15.4231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FxmxwrQ+e1KmPs2FnWKOgs+lSpimWXT/rlReGx/3frvEFhq1a+tNHlFNFIS7SKkDyIMMoZb3mIzJMK87lkd+eA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1926
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/14/20 4:26 PM, Sean Christopherson wrote:
> On Mon, Sep 14, 2020 at 03:15:22PM -0500, Tom Lendacky wrote:
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> Since the guest register state of an SEV-ES guest is encrypted, debugging
>> is not supported. Update the code to prevent guest debugging when the
>> guest is an SEV-ES guest. This includes adding a callable function that
>> is used to determine if the guest supports being debugged.
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> ---
>>  arch/x86/include/asm/kvm_host.h |  2 ++
>>  arch/x86/kvm/svm/svm.c          | 16 ++++++++++++++++
>>  arch/x86/kvm/vmx/vmx.c          |  7 +++++++
>>  arch/x86/kvm/x86.c              |  3 +++
>>  4 files changed, 28 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index c900992701d6..3e2a3d2a8ba8 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1234,6 +1234,8 @@ struct kvm_x86_ops {
>>  	void (*reg_read_override)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
>>  	void (*reg_write_override)(struct kvm_vcpu *vcpu, enum kvm_reg reg,
>>  				   unsigned long val);
>> +
>> +	bool (*allow_debug)(struct kvm *kvm);
> 
> Why add both allow_debug() and vmsa_encrypted?  I assume there are scenarios
> where allow_debug() != vmsa_encrypted?  E.g. is there a debug mode for SEV-ES
> where the VMSA is not encrypted, but KVM (ironically) can't intercept #DBs or
> something?

No, once the guest has had LAUNCH_UPDATE_VMSA run against the vCPUs, then
the vCPU states are all encrypted. But that doesn't mean that debugging
can't be done in the future.

> 
> Alternatively, have you explored using a new VM_TYPE for SEV-ES guests?  With
> a genericized vmsa_encrypted, that would allow something like the following
> for scenarios where the VMSA is not (yet?) encrypted for an SEV-ES guest.  I
> don't love bleeding the VM type into x86.c, but for one-off quirks like this
> I think it'd be preferable to adding a kvm_x86_ops hook.
> 
> int kvm_arch_vcpu_ioctl_set_guest_debug(...)
> {
> 	if (vcpu->arch.guest_state_protected ||
> 	    kvm->arch.vm_type == KVM_X86_SEV_ES_VM)
> 		return -EINVAL;
> }
> 

I haven't explored that, I'll look into it.

Thanks,
Tom
