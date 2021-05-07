Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20E87376D3A
	for <lists+kvm@lfdr.de>; Sat,  8 May 2021 01:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbhEGXWn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 19:22:43 -0400
Received: from mail-dm6nam11on2054.outbound.protection.outlook.com ([40.107.223.54]:26081
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229812AbhEGXWn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 May 2021 19:22:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ncIC5wIw5JqgsDYvSYn0swhD4+nj5E0zkUbN1u8M0p4fUWjiiwdG412Q97/l1/onB/mY0TtJ1scSmiEWkMh27sDGSkV2j5kMHmLwL3d6GATkbP4G0NB45TGR6nRo2ok7V8dssychK6VD2sj9UPtiGypRogG7FnFXPiEgRr9Yf5YeMUgmbOftXuXQQyLbH79z+c0fPvI/XVFQeNEC/nAHsWnOI7kCYLSgcbvyOW873uHcOIhQAbd4CUK29zPxVvve6blFZEHPz18jcyCp/Zu9dWkEbwk9qF5aktr2yCSzAg3ZvOrNcejDD1YVWMsmrde9KBBF1DPljVkG4yab9V7Hbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X8W9B3uDaFECd4s8PzCISfRMD2frNlmTPTk0xjnV8ow=;
 b=G034+ShCcXl2uuQwLaE0+/9M1VgiaI84zJYRB30leJ2OX/BVMqMRxJqIuuKN0YmnaLujMEK/uGk2xzS+fJ4jbms4G1z5RTD5De8naZ786tLfud8kNXNeU9SGMmQKECQ0+0w8Ungk9bWxrUUUP+hTDsYjzEmxtcFX7/fv6aPdO9sdMU6KcEYAM2HldWPiAeDM8H+NfWwZFwsBwepSPQW87qAmmc0WTZEJoPOEU9f+YVx0HUVJecv+8k4J5HDCn90M7q23nd92K3/2usQm1zoFDc4a/TP+PKNntp/59NjNZqIBupVYlMWhqo6iJ6bmWC7qG67fAZPlAyh1NYYljS9NBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X8W9B3uDaFECd4s8PzCISfRMD2frNlmTPTk0xjnV8ow=;
 b=W8wl1mEUGkSkCbuBW1YOZPSkXVty7eLphofJPJDKKKtnKOfB1ovJIq0wZ3dpl+lBxZNS9aeo5CN8RHRhfgMzDYJtUGshex168iPjpnsErcEZEY0UL3cPEp45dlG4z+7pVGGUhjYtZU5/PCay8RBxAarArLxcxkvDrEAL+cCYFRo=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3465.namprd12.prod.outlook.com (2603:10b6:5:3a::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4087.39; Fri, 7 May 2021 23:21:40 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9%12]) with mapi id 15.20.4108.026; Fri, 7 May 2021
 23:21:40 +0000
Subject: Re: [PATCH 2/2] KVM: x86: Allow userspace to update tracked sregs for
 protected guests
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20210507165947.2502412-1-seanjc@google.com>
 <20210507165947.2502412-3-seanjc@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <5f084672-5c0d-a6f3-6dcf-38dd76e0bde0@amd.com>
Date:   Fri, 7 May 2021 18:21:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <20210507165947.2502412-3-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA0PR11CA0188.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::13) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA0PR11CA0188.namprd11.prod.outlook.com (2603:10b6:806:1bc::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend Transport; Fri, 7 May 2021 23:21:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 491bfd5b-afdc-4180-289d-08d911aede8c
X-MS-TrafficTypeDiagnostic: DM6PR12MB3465:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3465BBCE801A29FB8DB629E7EC579@DM6PR12MB3465.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:129;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zUPGdyrv4e0+HAI0tVCy0fS/buohOtOT0F6ppFLHjtMmF4Ng0hsNW29h7mlVgI2qiuF/n0Bluh0awQ59ZNjUBdWuXfiufesd30uOdtVhyFn3ZzNndNfMVdbYW5Utu3wGKaJJvZPggoV0f+dSozRIbRTHHqgsVdnVRkAC1GgOrDiobBKIvSyC/dS6b9Z1W1khREhXSGHkWcVZnZ0z++twFJTQTRyS4s8nywH2e4pKM4poPE1nf+LgH1RTUFInapZocTJinbD70WxIFQ7NuPq/9rmI19d8vEh0YjBSXatjVbQd0UbXJGlhT6NZKyPi5aKDlun3vQmk+gdtdgbr9LcxRxr7O1n3QhXRcmzqF2JszQ4QBILHKxEVTNN/h8Wo9CN9d7dYt1wSP3f91mrGd94y2NdkxdPjl6EtWQUS1tCN2MyZbcqsw4wB/7ksQwvHQfJ83IIfV3GvWPfBFqP4hTik48PYwCaxG34zE+2vRiZrHzJ926ihuK0HoV01MeaCeqRRrpLltia7IDqrFsRTjHwhuMoqvspDtk6majgwfRF6OJGZOO4bwvbRBWEdozGE7qA610jRkYAh6QYrrNJueXfalAZKdavkJKO3UwsLB+b5txjy4Uzd68nvzIU9rXSC9vrMVAcY1KOVWaNC3fK7TMqwURKNEbjaM7Ppt21l0dFW2jKBeN7evP+q2JnbQEOTT0L1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(376002)(366004)(136003)(15650500001)(316002)(86362001)(4326008)(66946007)(186003)(66556008)(6512007)(7416002)(31696002)(478600001)(16526019)(31686004)(54906003)(2616005)(110136005)(2906002)(38100700002)(6486002)(5660300002)(36756003)(8676002)(53546011)(26005)(8936002)(66476007)(6506007)(956004)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UmJ2SXdTb1gwelA0T2g0Q0R5NlAxeE1LNVA1TVAxK1JEVVpZK1dLZWZWdmVh?=
 =?utf-8?B?VWFZUFVzbjZ0ZlVvaGNWWmQ0OWlqSGVVZHdQR24xOFBFdVY3Z0RFNGZWZk52?=
 =?utf-8?B?L2xnMjBIWUZGai9xK0p4S2VQSS9vMHNKQlFjNkFoR0l5ckZ2eUZCakZwV09l?=
 =?utf-8?B?WEdLbWs4Ky9zTDN2OWZpbWtmTWVhMVVscm9HWFlwajVJSXFjaTVJbWNBcUR5?=
 =?utf-8?B?MW5IM2V6MU5sSmptZnU4a1hXK283SGpMMldqNlJRK3U0bnEzdjdIeDFiNSsv?=
 =?utf-8?B?TVo4dU16cEl0aWgyRjZEdTRzRHpJZWxnR0o1TGp6VHdHeTRNTmhTUVBrUnQ4?=
 =?utf-8?B?RUM2M0VJMWVVNU8rbG5lcXpwaEZiWW5hZlQxU0lJWHZDMWVLaVF4ZkxXcWQv?=
 =?utf-8?B?azFNUCtQOVBCLzJhT1hLbWYzK1Z0Y2RoblpBQXRWMEVJVUZCejJ6MlRhdjJB?=
 =?utf-8?B?RkxsemdyQU5XZjRoZTFKcWZ3TVprSGErMG4vRGdEUUN6ZHo4Q1hTRnhjQi9C?=
 =?utf-8?B?OHpYbW05eUFld25uMVZubTZ5b2w3aGcrQzV1c2xyTUNWSy9RbC8vVXVreUxP?=
 =?utf-8?B?Sm5uN1hERE1Ia01IanJvb3BPTk1XU0tiTjB3Wm9UbkxpVGhWTnI1YzNMV2RN?=
 =?utf-8?B?R0dPdXFmU25WaVpsc2NFZnZPRnQrRkw0djljSk01ZUNFK1I3V0NkUVlZaFFw?=
 =?utf-8?B?UEJxWUtNQ0xkN1dPeEk4TEpnMFRpNmE1ZVYrNEt2R3dKREIva3ZUZGJVbEJR?=
 =?utf-8?B?ZHVhMWQ2SC81cVVCWU5NTkVITExyaGJCK1JBaFUrMGpteVhpYkg2WTVESzhl?=
 =?utf-8?B?bmFic1V6a3ZISTNsc0FHbXdyL1IrYWFLb25IMGlRZ2tHcHpDYjY1TDkyRnFF?=
 =?utf-8?B?RHo0QVl4TGxCRm9jbDBldytvRDg2N282bHl3SFI4QWtvaFhoUjNJemROUFhK?=
 =?utf-8?B?T3VDQ0wzR3FnVzVtcGVHaVora1doUFRzdnhFa01aaU1CRG9pRDdaTmtHK1FW?=
 =?utf-8?B?eVhNQUl2V2ZHOHRPeWRjZGJpRFltTUVoZ2FuR01INHcwMVZqRW5LcVE2R0Jp?=
 =?utf-8?B?RUJpc1RkbHJFdFV3MVlrY1RRVjZtamY5LzBncS82OWUxZ2N3bmpiZjliVGY3?=
 =?utf-8?B?TlZYcm1qNU5oQjV5UDZyam5hMjgzczNhVnJQVVBrTlNVSnBDb2FjUFVldEdx?=
 =?utf-8?B?bmE4bDZzaTZ5akQ4dVpFTVl1OHp5L1UxSFRVZkVKc3NBOENybnU3Mkx4TGRs?=
 =?utf-8?B?YVpLM0RHODQwS0xwaFdUWHdKRkFEcXhPUTVXSjU2TTBVbmFWM3F2MERnOGlE?=
 =?utf-8?B?OUkzTWdqd0ZCNVBreCtqTDQzMm4wNTdFOHRxVk95Nllnd2lQcXZSNllGeUIy?=
 =?utf-8?B?d3daelIxQzd1blFCamhiTHVPVDRrbVRNRVJHUmpPRHhMNklkRFVyazErMFlK?=
 =?utf-8?B?bXhoQVoxVDJtWVlnQ0FTYWVmNTV1WVp4RjFQbm1oWkFTNXdSdEJIM1VORlpu?=
 =?utf-8?B?TXhUMk0xSzhwQlYrNlA5RC9FODllTjNQcGZwckladTYrTU1VTUpXbExEOWJP?=
 =?utf-8?B?Vmk0SDJtWjZscjlreUJzSG9vTE9BSitaZnM1OUo1MXBNZnVZNzhLclRHa3BW?=
 =?utf-8?B?NDhySVlIUXY0SnZTblUxSWU5bVd2Q3RpTWlSYXZmMkZsNEwyUWpjMlI1RVZM?=
 =?utf-8?B?ZjFSVGdpRkQwa09nUk04dnBsZlQ3bzBORjBmVHlCVmFzZ0Q2OWFUSUkzV2hP?=
 =?utf-8?Q?/C3yEd30BCUzVs6K8nReXX69Nk/LWGVIySw+q+9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 491bfd5b-afdc-4180-289d-08d911aede8c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2021 23:21:40.6644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P7fIfeEouxuWEWD/jTeHeprsdL06e9nmy3RlFRaYRUzFIi4sqLT63uNVptQxJxwIU/CZjgoCIbd5KZ7AjbZXZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3465
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/7/21 11:59 AM, Sean Christopherson wrote:
> Allow userspace to set CR0, CR4, CR8, and EFER via KVM_SET_SREGS for
> protected guests, e.g. for SEV-ES guests with an encrypted VMSA.  KVM
> tracks the aforementioned registers by trapping guest writes, and also
> exposes the values to userspace via KVM_GET_SREGS.  Skipping the regs
> in KVM_SET_SREGS prevents userspace from updating KVM's CPU model to
> match the known hardware state.

This is very similar to the original patch I had proposed that you were
against :)

I'm assuming it's meant to make live migration a bit easier?

> 
> Fixes: 5265713a0737 ("KVM: x86: Update __get_sregs() / __set_sregs() to support SEV-ES")
> Reported-by: Peter Gonda <pgonda@google.com>
> Cc: stable@vger.kernel.org
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/kvm/x86.c | 73 ++++++++++++++++++++++++++--------------------
>  1 file changed, 42 insertions(+), 31 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3bf52ba5f2bb..1b7d0e97c82b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9963,21 +9963,25 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
>  	if (kvm_set_apic_base(vcpu, &apic_base_msr))
>  		goto out;
>  
> -	if (vcpu->arch.guest_state_protected)
> -		goto skip_protected_regs;
> +	if (!vcpu->arch.guest_state_protected) {
> +		dt.size = sregs->idt.limit;
> +		dt.address = sregs->idt.base;
> +		static_call(kvm_x86_set_idt)(vcpu, &dt);
> +		dt.size = sregs->gdt.limit;
> +		dt.address = sregs->gdt.base;
> +		static_call(kvm_x86_set_gdt)(vcpu, &dt);
>  
> -	dt.size = sregs->idt.limit;
> -	dt.address = sregs->idt.base;
> -	static_call(kvm_x86_set_idt)(vcpu, &dt);
> -	dt.size = sregs->gdt.limit;
> -	dt.address = sregs->gdt.base;
> -	static_call(kvm_x86_set_gdt)(vcpu, &dt);
> -
> -	vcpu->arch.cr2 = sregs->cr2;
> -	mmu_reset_needed |= kvm_read_cr3(vcpu) != sregs->cr3;
> -	vcpu->arch.cr3 = sregs->cr3;
> -	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
> +		vcpu->arch.cr2 = sregs->cr2;
> +		mmu_reset_needed |= kvm_read_cr3(vcpu) != sregs->cr3;
> +		vcpu->arch.cr3 = sregs->cr3;
> +		kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
> +	}
>  
> +	/*
> +	 * Writes to CR0, CR4, CR8, and EFER are trapped (after the instruction
> +	 * completes) for SEV-EV guests, thus userspace is allowed to set them
> +	 * so that KVM's model can be updated to mirror hardware state.
> +	 */
>  	kvm_set_cr8(vcpu, sregs->cr8);
>  
>  	mmu_reset_needed |= vcpu->arch.efer != sregs->efer;
> @@ -9990,35 +9994,42 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
>  	mmu_reset_needed |= kvm_read_cr4(vcpu) != sregs->cr4;
>  	static_call(kvm_x86_set_cr4)(vcpu, sregs->cr4);
>  
> -	idx = srcu_read_lock(&vcpu->kvm->srcu);
> -	if (is_pae_paging(vcpu)) {
> +	/*
> +	 * PDPTEs, like regular PTEs, are always encrypted, thus reading them
> +	 * will return garbage.  Shadow paging, including nested NPT, isn't
> +	 * compatible with protected guests, so ignoring the PDPTEs is a-ok.
> +	 */
> +	if (!vcpu->arch.guest_state_protected && is_pae_paging(vcpu)) {
> +		idx = srcu_read_lock(&vcpu->kvm->srcu);
>  		load_pdptrs(vcpu, vcpu->arch.walk_mmu, kvm_read_cr3(vcpu));
> +		srcu_read_unlock(&vcpu->kvm->srcu, idx);
> +
>  		mmu_reset_needed = 1;
>  	}
> -	srcu_read_unlock(&vcpu->kvm->srcu, idx);
>  
>  	if (mmu_reset_needed)
>  		kvm_mmu_reset_context(vcpu);
>  
> -	kvm_set_segment(vcpu, &sregs->cs, VCPU_SREG_CS);
> -	kvm_set_segment(vcpu, &sregs->ds, VCPU_SREG_DS);
> -	kvm_set_segment(vcpu, &sregs->es, VCPU_SREG_ES);
> -	kvm_set_segment(vcpu, &sregs->fs, VCPU_SREG_FS);
> -	kvm_set_segment(vcpu, &sregs->gs, VCPU_SREG_GS);
> -	kvm_set_segment(vcpu, &sregs->ss, VCPU_SREG_SS);
> +	if (!vcpu->arch.guest_state_protected) {
> +		kvm_set_segment(vcpu, &sregs->cs, VCPU_SREG_CS);
> +		kvm_set_segment(vcpu, &sregs->ds, VCPU_SREG_DS);
> +		kvm_set_segment(vcpu, &sregs->es, VCPU_SREG_ES);
> +		kvm_set_segment(vcpu, &sregs->fs, VCPU_SREG_FS);
> +		kvm_set_segment(vcpu, &sregs->gs, VCPU_SREG_GS);
> +		kvm_set_segment(vcpu, &sregs->ss, VCPU_SREG_SS);
>  
> -	kvm_set_segment(vcpu, &sregs->tr, VCPU_SREG_TR);
> -	kvm_set_segment(vcpu, &sregs->ldt, VCPU_SREG_LDTR);
> +		kvm_set_segment(vcpu, &sregs->tr, VCPU_SREG_TR);
> +		kvm_set_segment(vcpu, &sregs->ldt, VCPU_SREG_LDTR);
>  
> -	update_cr8_intercept(vcpu);
> +		update_cr8_intercept(vcpu);
>  
> -	/* Older userspace won't unhalt the vcpu on reset. */
> -	if (kvm_vcpu_is_bsp(vcpu) && kvm_rip_read(vcpu) == 0xfff0 &&
> -	    sregs->cs.selector == 0xf000 && sregs->cs.base == 0xffff0000 &&
> -	    !is_protmode(vcpu))
> -		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
> +		/* Older userspace won't unhalt the vcpu on reset. */
> +		if (kvm_vcpu_is_bsp(vcpu) && kvm_rip_read(vcpu) == 0xfff0 &&
> +		    sregs->cs.selector == 0xf000 &&
> +		    sregs->cs.base == 0xffff0000 && !is_protmode(vcpu))
> +			vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
> +	}
>  
> -skip_protected_regs:
>  	max_bits = KVM_NR_INTERRUPTS;
>  	pending_vec = find_first_bit(
>  		(const unsigned long *)sregs->interrupt_bitmap, max_bits);
> 
