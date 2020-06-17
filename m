Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ACE81FCF96
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 16:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgFQOba (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 10:31:30 -0400
Received: from mail-mw2nam10on2056.outbound.protection.outlook.com ([40.107.94.56]:57921
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725901AbgFQOb3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jun 2020 10:31:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k8VxtaOOjpJpABOa6P+/U8KJaSXJZlrGRwNdpsQ/k9d06E9LLFUBpUPS1LgabVTQAaaUCT1OHwHNaL01tRN8k4IpiFxwqOwtt96bdmHl6FSxhIUY63NDBPpPPesIumOHkX+qeDxJxn/AQruWIdjfYQ7rrGoCyCEExEp/tQGKLxoxVPhPEJZ6gcSjkVU9bc63Y2t65jaz4LjfJAECM4O3pGaWoDuKnzN9Sqyq6XqwDfVr1TbxViwmoj15vvjqpPJ/7tStT+uwTErHHkOr0cUrrdwFNF19Ofgu5yXS4r/dNXE23bzZzl59iRsnQnUmFHkZhR98WWHz0pRn8Jv8BT2XbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mM7O4c8AOyHGwnikHUghyBmhtSHDWGNrhamFrpd0D3Q=;
 b=cpjDLyJMCID2WrZwMZg1Gff/2ddnGRem2tfBm9HLSYzdjerj1bDMtJtec1ACjlDtq+ljShI48VoU4pVgViiKpF0cbwo/UMc/Ml9Nr/9Nl1/pywUPQoK73ZZa0pnWuZPzjljeXgSzA0YCuEj5KEpOo1z0FDTk+vlLMVgOEwuu0tvcTUsy5xcdb2q25I9oA+TD1co4jCU0LX3D9GtIQHh6g1v2on9TQrtf8eDARZaYfai8rXQB0dDBiV84xFf332X4bxGHeCBU2qYkvTgzhsKTU/SuNzq7qMO07US5y5N1QrPVQT8zTJOplc1sg78KwB/4dQ7qpdBL8brbLWPmYVtW2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mM7O4c8AOyHGwnikHUghyBmhtSHDWGNrhamFrpd0D3Q=;
 b=e+x0veOcZy/EXxYQWXzyBvNJXJHCeOdx8SvzROZ6fDbZuHjYn9LTx4JzQ25bTalCHC7wGhvUOT4+fFDRxOzlal346Nav3u7t6Op/wDwyNps82OGJRH8FiubKrFnQmTxPrMAt9WyD6OlQbmjTW+6yGqSeXBw9iRi05vYCPRObREs=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4350.namprd12.prod.outlook.com (2603:10b6:806:92::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.22; Wed, 17 Jun
 2020 14:31:23 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2%3]) with mapi id 15.20.3088.029; Wed, 17 Jun 2020
 14:31:23 +0000
Subject: RE: [PATCH v2 1/3] KVM: X86: Move handling of INVPCID types to x86
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "jmattson@google.com" <jmattson@google.com>
References: <159234483706.6230.13753828995249423191.stgit@bmoger-ubuntu>
 <159234501692.6230.5105866433978454983.stgit@bmoger-ubuntu>
 <87tuz9hpnu.fsf@vitty.brq.redhat.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <ce262481-df27-7f4a-51ba-52d8babe942b@amd.com>
Date:   Wed, 17 Jun 2020 09:31:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <87tuz9hpnu.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR15CA0038.namprd15.prod.outlook.com
 (2603:10b6:4:4b::24) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.79] (165.204.77.1) by DM5PR15CA0038.namprd15.prod.outlook.com (2603:10b6:4:4b::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.21 via Frontend Transport; Wed, 17 Jun 2020 14:31:22 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0183d8b2-5307-4de0-e592-08d812cb1c4a
X-MS-TrafficTypeDiagnostic: SA0PR12MB4350:
X-Microsoft-Antispam-PRVS: <SA0PR12MB4350FAB7F0903A8FDCDABA2C959A0@SA0PR12MB4350.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 04371797A5
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vv/yxKJflnTflIzeZM1N0eN+Lfge6e2y9q965ig6OObyHR24YsdN6qEuolSWmiWPzhpWOXwHmn28UFnBeIgqSy178DX9mskU/I1+FGPUd7jw6K0vCZcY207bFxS9agi1UnYzeAziwxWQ4EsdzB3UOYfi4SARw6OxtY4ghyJMLfwBO7fy6Xpqv+N3FXqiCtrIzPaytNn7bu0AHC4Zat+SDPnVk/SY6uQnhcYAcqDhoBB4s5DwzZ6iAsamZiPqpbITlnlwPN7okiNAXAaz5s5kltQuONA4nb9LUIdlkvhdvHIM0b9e5zmIOU/prb55UuZM1zcyRM++RYTzOCxP7tYjHsJWfRZVpNHh/eqANb8Wetv3LrzgA/28i/Vw4p4BVKKw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(346002)(376002)(39860400002)(366004)(316002)(31686004)(8936002)(16576012)(8676002)(7416002)(54906003)(2616005)(5660300002)(4326008)(956004)(44832011)(6916009)(478600001)(26005)(186003)(16526019)(36756003)(83380400001)(53546011)(52116002)(66476007)(66946007)(31696002)(2906002)(6486002)(66556008)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: B11b2Nv0AlhY60UwGiLHY8kwn2i1qOU6nooniy37+GWPttSvgt+xwQ65S/FGuly/Mg8l8hEaGxEN6pQz6D8XJO9ZjQaHtcZClTPyDDmwJxZcQ6SEDVe98PhYhSrVLN+J68LL8DLxRcKZ993svmP1BACw82hVwXzP8f6EHDLY4NuUETqwmG1Osh6LTGGVSGWMXshPfYhy7wr6Qu/oZdfyFuwHRa4Ml3Coz0NCkwC/rkbxl8hrhRdXbQZpJeR/qTtmM+XxNPp808vD/XwtYhdaWZESkpa2lDxAFnxfpI3c2AHIVJEH8+DZE/N58bfkVhKjXwM7JRWxx1nuTX2N/VZpwz67com2agFnXMcKtQ8uBn7zPSwu4Hn09VvBLSFRKFcGQx80F9nQOY+WI4N1Dmy+xxzC5TmvxVvsG44QsWfEEDW74rO4jlvR83pEu8lDaVLpy6VWyB3Ao75e6SZWJGtS7xC2L8D3H0jzUbxqI5LyBio=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0183d8b2-5307-4de0-e592-08d812cb1c4a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2020 14:31:23.7285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wCCDKWlkEjc/mqrj4O44uQ+Z5ec4xAzt0K7aYHYv7kRjV4SutOo15RvuZU7vjJCR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4350
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Vitaly Kuznetsov <vkuznets@redhat.com>
> Sent: Wednesday, June 17, 2020 6:56 AM
> To: Moger, Babu <Babu.Moger@amd.com>
> Cc: linux-kernel@vger.kernel.org; kvm@vger.kernel.org;
> wanpengli@tencent.com; joro@8bytes.org; x86@kernel.org;
> sean.j.christopherson@intel.com; mingo@redhat.com; bp@alien8.de;
> hpa@zytor.com; pbonzini@redhat.com; tglx@linutronix.de;
> jmattson@google.com
> Subject: Re: [PATCH v2 1/3] KVM: X86: Move handling of INVPCID types to x86
> 
> Babu Moger <babu.moger@amd.com> writes:
> 
> > INVPCID instruction handling is mostly same across both VMX and
> > SVM. So, move the code to common x86.c.
> >
> > Signed-off-by: Babu Moger <babu.moger@amd.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c |   68 +----------------------------------------
> >  arch/x86/kvm/x86.c     |   79
> ++++++++++++++++++++++++++++++++++++++++++++++++
> >  arch/x86/kvm/x86.h     |    3 +-
> >  3 files changed, 82 insertions(+), 68 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 170cc76a581f..b4140cfd15fd 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -5477,11 +5477,7 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
> >  {
> >  	u32 vmx_instruction_info;
> >  	unsigned long type;
> > -	bool pcid_enabled;
> >  	gva_t gva;
> > -	struct x86_exception e;
> > -	unsigned i;
> > -	unsigned long roots_to_free = 0;
> >  	struct {
> >  		u64 pcid;
> >  		u64 gla;
> > @@ -5508,69 +5504,7 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
> >  				sizeof(operand), &gva))
> >  		return 1;
> >
> > -	if (kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e)) {
> > -		kvm_inject_emulated_page_fault(vcpu, &e);
> > -		return 1;
> > -	}
> > -
> > -	if (operand.pcid >> 12 != 0) {
> > -		kvm_inject_gp(vcpu, 0);
> > -		return 1;
> > -	}
> > -
> > -	pcid_enabled = kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
> > -
> > -	switch (type) {
> > -	case INVPCID_TYPE_INDIV_ADDR:
> > -		if ((!pcid_enabled && (operand.pcid != 0)) ||
> > -		    is_noncanonical_address(operand.gla, vcpu)) {
> > -			kvm_inject_gp(vcpu, 0);
> > -			return 1;
> > -		}
> > -		kvm_mmu_invpcid_gva(vcpu, operand.gla, operand.pcid);
> > -		return kvm_skip_emulated_instruction(vcpu);
> > -
> > -	case INVPCID_TYPE_SINGLE_CTXT:
> > -		if (!pcid_enabled && (operand.pcid != 0)) {
> > -			kvm_inject_gp(vcpu, 0);
> > -			return 1;
> > -		}
> > -
> > -		if (kvm_get_active_pcid(vcpu) == operand.pcid) {
> > -			kvm_mmu_sync_roots(vcpu);
> > -			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT,
> vcpu);
> > -		}
> > -
> > -		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
> > -			if (kvm_get_pcid(vcpu, vcpu->arch.mmu-
> >prev_roots[i].pgd)
> > -			    == operand.pcid)
> > -				roots_to_free |=
> KVM_MMU_ROOT_PREVIOUS(i);
> > -
> > -		kvm_mmu_free_roots(vcpu, vcpu->arch.mmu, roots_to_free);
> > -		/*
> > -		 * If neither the current cr3 nor any of the prev_roots use the
> > -		 * given PCID, then nothing needs to be done here because a
> > -		 * resync will happen anyway before switching to any other
> CR3.
> > -		 */
> > -
> > -		return kvm_skip_emulated_instruction(vcpu);
> > -
> > -	case INVPCID_TYPE_ALL_NON_GLOBAL:
> > -		/*
> > -		 * Currently, KVM doesn't mark global entries in the shadow
> > -		 * page tables, so a non-global flush just degenerates to a
> > -		 * global flush. If needed, we could optimize this later by
> > -		 * keeping track of global entries in shadow page tables.
> > -		 */
> > -
> > -		/* fall-through */
> > -	case INVPCID_TYPE_ALL_INCL_GLOBAL:
> > -		kvm_mmu_unload(vcpu);
> > -		return kvm_skip_emulated_instruction(vcpu);
> > -
> > -	default:
> > -		BUG(); /* We have already checked above that type <= 3 */
> > -	}
> > +	return kvm_handle_invpcid_types(vcpu,  gva, type);
> 
> Nit: redundant space.

Sure. Will fix.

> 
> >  }
> >
> >  static int handle_pml_full(struct kvm_vcpu *vcpu)
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 9e41b5135340..9c858ca0e592 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -70,6 +70,7 @@
> >  #include <asm/irq_remapping.h>
> >  #include <asm/mshyperv.h>
> >  #include <asm/hypervisor.h>
> > +#include <asm/tlbflush.h>
> >  #include <asm/intel_pt.h>
> >  #include <asm/emulate_prefix.h>
> >  #include <clocksource/hyperv_timer.h>
> > @@ -10714,6 +10715,84 @@ u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu
> *vcpu)
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_spec_ctrl_valid_bits);
> >
> > +int kvm_handle_invpcid_types(struct kvm_vcpu *vcpu, gva_t gva,
> > +			     unsigned long type)
> 
> (sorry if this was discussed before) do we really need '_types' suffix?

Ok. I will remove _types.

> 
> > +{
> > +	unsigned long roots_to_free = 0;
> > +	struct x86_exception e;
> > +	bool pcid_enabled;
> > +	unsigned int i;
> > +	struct {
> > +		u64 pcid;
> > +		u64 gla;
> > +	} operand;
> > +
> > +	if (kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e)) {
> > +		kvm_inject_emulated_page_fault(vcpu, &e);
> > +		return 1;
> > +	}
> > +
> > +	if (operand.pcid >> 12 != 0) {
> > +		kvm_inject_gp(vcpu, 0);
> > +		return 1;
> > +	}
> > +
> > +	pcid_enabled = kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
> > +
> > +	switch (type) {
> > +	case INVPCID_TYPE_INDIV_ADDR:
> > +		if ((!pcid_enabled && (operand.pcid != 0)) ||
> > +		    is_noncanonical_address(operand.gla, vcpu)) {
> > +			kvm_inject_gp(vcpu, 0);
> > +			return 1;
> > +		}
> > +		kvm_mmu_invpcid_gva(vcpu, operand.gla, operand.pcid);
> > +		return kvm_skip_emulated_instruction(vcpu);
> > +
> > +	case INVPCID_TYPE_SINGLE_CTXT:
> > +		if (!pcid_enabled && (operand.pcid != 0)) {
> > +			kvm_inject_gp(vcpu, 0);
> > +			return 1;
> > +		}
> > +
> > +		if (kvm_get_active_pcid(vcpu) == operand.pcid) {
> > +			kvm_mmu_sync_roots(vcpu);
> > +			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT,
> vcpu);
> > +		}
> > +
> > +		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
> > +			if (kvm_get_pcid(vcpu, vcpu->arch.mmu-
> >prev_roots[i].pgd)
> > +			    == operand.pcid)
> > +				roots_to_free |=
> KVM_MMU_ROOT_PREVIOUS(i);
> > +
> > +		kvm_mmu_free_roots(vcpu, vcpu->arch.mmu, roots_to_free);
> > +		/*
> > +		 * If neither the current cr3 nor any of the prev_roots use the
> > +		 * given PCID, then nothing needs to be done here because a
> > +		 * resync will happen anyway before switching to any other
> CR3.
> > +		 */
> > +
> > +		return kvm_skip_emulated_instruction(vcpu);
> > +
> > +	case INVPCID_TYPE_ALL_NON_GLOBAL:
> > +		/*
> > +		 * Currently, KVM doesn't mark global entries in the shadow
> > +		 * page tables, so a non-global flush just degenerates to a
> > +		 * global flush. If needed, we could optimize this later by
> > +		 * keeping track of global entries in shadow page tables.
> > +		 */
> > +
> > +		/* fall-through */
> > +	case INVPCID_TYPE_ALL_INCL_GLOBAL:
> > +		kvm_mmu_unload(vcpu);
> > +		return kvm_skip_emulated_instruction(vcpu);
> > +
> > +	default:
> > +		BUG(); /* We have already checked above that type <= 3 */
> 
> The check was left in VMX' handle_invpcid() so we either need to update
> the comment to something like "the caller was supposed to check that
> type <= 3" or move the check to kvm_handle_invpcid_types().

Ok. Will update the comment. Thanks

> 
> > +	}
> > +}
> > +EXPORT_SYMBOL_GPL(kvm_handle_invpcid_types);
> > +
> >  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
> >  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
> >  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
> > diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> > index 6eb62e97e59f..f706f6f7196d 100644
> > --- a/arch/x86/kvm/x86.h
> > +++ b/arch/x86/kvm/x86.h
> > @@ -365,5 +365,6 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu
> *vcpu);
> >  void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
> >  u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu);
> >  bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu);
> > -
> > +int kvm_handle_invpcid_types(struct kvm_vcpu *vcpu, gva_t gva,
> > +			     unsigned long type);
> >  #endif
> >
> 
> --
> Vitaly

