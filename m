Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC702E9D25
	for <lists+kvm@lfdr.de>; Mon,  4 Jan 2021 19:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbhADSga (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jan 2021 13:36:30 -0500
Received: from mail-mw2nam12on2065.outbound.protection.outlook.com ([40.107.244.65]:50453
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725889AbhADSg3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jan 2021 13:36:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DJ+oepCACeZgAvGcBdJk8fChZ6Piwbwhfzt8Voip9Qjeb1QAlLUia7uZwtCstXZNQFDvMe7ERqwbSeQnygR7YXRUzlIrdCX6N/i5iTekejS0H42vUbYrMUEHy6LKPUN6Ced0xVMKl/rqK5hNXAUst1vWrfBYVyCO/HN+YUuJFtbzq5pyPlgXzuxhGF/s0g7zoMymwd4qvrftZGSbRFIQaou0c10wM6Dhl3tbu0wrLtQgKSdZpvhrNDtUGbQDZMepw5/Zf80xPaTaxru1pInPc6HZHlFWXf39qAGGVgpkex6yBVAKuzT2XeGAdiLkjT5FW5jE8zpJhOKj4v2JJj0Uvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lZlpJ1uBMYoZEpIP+Nokp0Deki7KtYQkSqg013pM7cs=;
 b=c/bEmgxHIXO+z2+zR0uO2ttdfgOVIlrxt8wZacRb3WyadlbmghBbFVm89E4O9dW+HiwtylC9ezOMy8641ttvWTWqChBLviVemjDLyChDbqMFIg7D9ChwNWHvqhvrdICTrtsCyJw6AQFUES21xYrvp41CH6Gq63dsqsx1sZYZFtB2jENGwziJ53eM1PevwYW6CSm8gewr7fA9vmuifHJpvalUDGAZmEEzqwhMWILjBmnESCK30FE2JIuSZNOkLKu01Pn0YUrn8Gia6IwR9G++J9jhbT5AUUkEGrpw5zY5uplqY1ktXJCEtn868cN7yssIaAsA5Hv7KHFAvz4SMoe8jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lZlpJ1uBMYoZEpIP+Nokp0Deki7KtYQkSqg013pM7cs=;
 b=wMAr7EsQ+NpI0Vp7WFuWsNIHXImYMmBo0WxizIPQWbDtI/xUe7VMJtPWCMQSwHrYaPozBAZf/EriunAyXREubwvHiIOLsuWwwzqPd9d6FGPyAdKnUyk/rDJDP5TgHq5vs08+p8kDWJb+5waDL8edppb8lRTDTrJ4k1aseaFGboQ=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2382.namprd12.prod.outlook.com (2603:10b6:802:2e::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20; Mon, 4 Jan
 2021 18:35:35 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff%5]) with mapi id 15.20.3721.024; Mon, 4 Jan 2021
 18:35:35 +0000
Subject: RE: [PATCH v2 2/2] KVM: SVM: Add support for Virtual SPEC_CTRL
To:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>
Cc:     "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "seanjc@google.com" <seanjc@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kyung.min.park@intel.com" <kyung.min.park@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "krish.sadhukhan@oracle.com" <krish.sadhukhan@oracle.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mgross@linux.intel.com" <mgross@linux.intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "Phillips, Kim" <kim.phillips@amd.com>,
        "Huang2, Wei" <Wei.Huang2@amd.com>,
        "jmattson@google.com" <jmattson@google.com>
References: <160867624053.3471.7106539070175910424.stgit@bmoger-ubuntu>
 <160867631505.3471.3808049369257008114.stgit@bmoger-ubuntu>
 <f7fb8383-6bec-3982-7526-f9ea7ab3673f@amd.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <5191561f-0ed1-6d51-56c6-8e54b6a931e1@amd.com>
Date:   Mon, 4 Jan 2021 12:35:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <f7fb8383-6bec-3982-7526-f9ea7ab3673f@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0201CA0013.namprd02.prod.outlook.com
 (2603:10b6:803:2b::23) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.136] (165.204.77.1) by SN4PR0201CA0013.namprd02.prod.outlook.com (2603:10b6:803:2b::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.19 via Frontend Transport; Mon, 4 Jan 2021 18:35:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5b29f98b-5956-4820-268e-08d8b0df86a0
X-MS-TrafficTypeDiagnostic: SN1PR12MB2382:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB23828BE8BB81BBEC21249F5395D20@SN1PR12MB2382.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LY16YWPxpVe8cU9GmPhdbvrP9VKberS1XERQLvo9NFVqe7GkWTty5TnDrCRQgPgPV81GY3sQ8x1QTiYbQ56H4EEH4cCRaUgngGmhJLtJaI0KMmLXthz6Nn3YqyIZPDB4olRXo0CbY0aHFC8RtrZ+DGzkzFXI/UjWymS+ZICWqREkBYlS6sTLmVdDXyOSi/o3hv9wc62BOBGKU1XuPVsAwzmCutd9T57vD498/tO0WjYUwxP1HPOuSqOfjlBGswOVZhEEPPaTt2DdJUKJ/fhkxqN8CO9dRqAlDUB6te26cGaypT91YN2OOPStZ+CmiTrnWoTmYK+SapGP231J617k9hSg/m7C8RKbedglO7cPCPtcuFysFy3bXgfK2SUzGzZiMqNd3Y1qe7CGZKgcJisLz0oD/xsyFw7zhA5xBEwggyhPnC4fimCfCJYgCvjZz6qoQxKe6gn37/8HlK23+p0OLqkpu+gks0ohvR236L/KgG8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(396003)(39860400002)(136003)(44832011)(66556008)(31686004)(16526019)(478600001)(956004)(54906003)(2616005)(5660300002)(52116002)(186003)(66476007)(66946007)(16576012)(110136005)(83380400001)(36756003)(53546011)(8676002)(316002)(6486002)(8936002)(7416002)(31696002)(4326008)(86362001)(2906002)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YjNNODYza1VIcXVwK2NJbGFKdTNuUjVaVldoWldsS0ZXY1FwUW5qMlVIVXR1?=
 =?utf-8?B?L1VtMW5WcXhQdVJBcTNnN3BPWGFtS09OaVhyTHd2VXZ3QkNvRnp2eW00T05s?=
 =?utf-8?B?bU1KWVVNQWxRK2RGa2R4Zk80REJzZTNXUnZvR2ptMjBKTmlvcC9sTEliSHc1?=
 =?utf-8?B?RXJhenIycmV5ZnA3em80c1RUMWdERWpvazY3cStuTEkzbDAyV0N1b1dkdXVK?=
 =?utf-8?B?a0o1SEZWMGpaRFVhM0pGZnhRbjlodFN1ekg1MXdZNENOZDNYdXJSaTRvaVVS?=
 =?utf-8?B?TElianMwMUR2YU43S2VxYWJORzRERmYwMXRxbVNFREIwenV2dmlqS0JGMEEw?=
 =?utf-8?B?OFV0NmFZL2tCWEJla2VsNXpUOGVjQ2h6QjlhSDl6SnBIZHN2cDJGZnFFeFJD?=
 =?utf-8?B?OUpXQzRLQmNwSGg4ZUlOcHE3ODNNMUpMM0NkaENPQ1dxeVhBQVh2YzNwZmxi?=
 =?utf-8?B?VU1VVFprRkE1ZUM5ajZkeEplU0hMZS9nWDBlY1paYzFnZkNzMWd0QitNWjJQ?=
 =?utf-8?B?K3pMWVNWSHlScHhHYTlWTSt3TXByclo1dTV1U0ZteDhVTzhhNHVVUGRJMWxy?=
 =?utf-8?B?YWNzRjlhdFVFbzNManBhWFBSWkQ4M2UwNGZyK24rNTgyaC92OWN5UU5VVzEz?=
 =?utf-8?B?YXlaeFpsemlTQjF6bFRGSFhjMDhPenhzSFhKL2FpRzFnSEl4L0JEZ3dzTGZD?=
 =?utf-8?B?S09qUGZ5YU9sOEJ6VkVBTk9CK1BHTXNnU1ErWE5iQzEvaHhDZm4xNlM0Vllx?=
 =?utf-8?B?YnhRMXJJUWZNb0UxM1c2ZnE5VG92MisyZlJsOGgyaUNEREQ2S1RadWU4c29w?=
 =?utf-8?B?Z0grNVJ6Z2h0TS9ZRVF6QWVqaERYdUFLZ0lRTTN3SFJ1OFpiTTJqYW10V2ht?=
 =?utf-8?B?WU5nN2lHZGo2T0h6NUhQRm1LbXFFTjVzTW85ci9zRGdNVVpubnk5emlkbTdF?=
 =?utf-8?B?MkY2SGdRazRpTmFaRFlQMSsvV1RRVnVHS0ZPbUhIMzFJSzZDZ1l0eDNhRGJN?=
 =?utf-8?B?SmxScjNyeWxtalo3dGZGd1R6ZWpmSUlNdDFLclJzUzZUaVpmb2gxdTliWHhD?=
 =?utf-8?B?L2hWWURya0NNV1pxbEFpWDNqWnZ4eGQ0K0dhZzhMcTVrTkR3dkJZSnVSaCtD?=
 =?utf-8?B?Tjgxd3Z3MUVkUDRIL2x6SXd1bkRQN0tTb3ZIYXJqOGhCUjk1aVVLNTZjWGc3?=
 =?utf-8?B?YTNIeG9yZGJLRFFtWGJEVFp5a1pRUUp6cEtUdzZhUW5kQjlvbXRkWi9PbWhQ?=
 =?utf-8?B?Z1d4UURpN0kzS1JPNVlmeDVnaFhjcGFwV1EreDc1RUVlZCtoNkxKYUpFYVZU?=
 =?utf-8?Q?QdAPemxY8G6nM=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2021 18:35:35.4963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b29f98b-5956-4820-268e-08d8b0df86a0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lqqsIponHKEkLyWdKqnt+73lWQH/h0bTX+4TrGrXuZIgu/cKGP/47cfKquphIlHb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2382
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Lendacky, Thomas <Thomas.Lendacky@amd.com>
> Sent: Monday, January 4, 2021 9:47 AM
> To: Moger, Babu <Babu.Moger@amd.com>; pbonzini@redhat.com;
> tglx@linutronix.de; mingo@redhat.com; bp@alien8.de
> Cc: fenghua.yu@intel.com; tony.luck@intel.com; wanpengli@tencent.com;
> kvm@vger.kernel.org; peterz@infradead.org; seanjc@google.com;
> joro@8bytes.org; x86@kernel.org; kyung.min.park@intel.com; linux-
> kernel@vger.kernel.org; krish.sadhukhan@oracle.com; hpa@zytor.com;
> mgross@linux.intel.com; vkuznets@redhat.com; Phillips, Kim
> <kim.phillips@amd.com>; Huang2, Wei <Wei.Huang2@amd.com>;
> jmattson@google.com
> Subject: Re: [PATCH v2 2/2] KVM: SVM: Add support for Virtual SPEC_CTRL
> 
> On 12/22/20 4:31 PM, Babu Moger wrote:
> > Newer AMD processors have a feature to virtualize the use of the
> > SPEC_CTRL MSR. A hypervisor may wish to impose speculation controls on
> > guest execution or a guest may want to impose its own speculation
> > controls. Therefore, the processor implements both host and guest
> > versions of SPEC_CTRL. Presence of this feature is indicated via CPUID
> > function 0x8000000A_EDX[20]: GuestSpecCtrl.  Hypervisors are not
> > required to enable this feature since it is automatically enabled on
> > processors that support it.
> >
> > When in host mode, the host SPEC_CTRL value is in effect and writes
> > update only the host version of SPEC_CTRL. On a VMRUN, the processor
> > loads the guest version of SPEC_CTRL from the VMCB. When the guest
> > writes SPEC_CTRL, only the guest version is updated. On a VMEXIT, the
> > guest version is saved into the VMCB and the processor returns to only
> > using the host SPEC_CTRL for speculation control. The guest SPEC_CTRL
> > is located at offset 0x2E0 in the VMCB.
> 
> With the SEV-ES hypervisor support now in the tree, this will need to add support
> in sev_es_sync_vmsa() to put the initial svm->spec_ctrl value in the SEV-ES
> VMSA.
> 
> >
> > The effective SPEC_CTRL setting is the guest SPEC_CTRL setting or'ed
> > with the hypervisor SPEC_CTRL setting. This allows the hypervisor to
> > ensure a minimum SPEC_CTRL if desired.
> >
> > This support also fixes an issue where a guest may sometimes see an
> > inconsistent value for the SPEC_CTRL MSR on processors that support
> > this feature. With the current SPEC_CTRL support, the first write to
> > SPEC_CTRL is intercepted and the virtualized version of the SPEC_CTRL
> > MSR is not updated. When the guest reads back the SPEC_CTRL MSR, it
> > will be 0x0, instead of the actual expected value. There isn’t a
> > security concern here, because the host SPEC_CTRL value is or’ed with
> > the Guest SPEC_CTRL value to generate the effective SPEC_CTRL value.
> > KVM writes with the guest's virtualized SPEC_CTRL value to SPEC_CTRL
> > MSR just before the VMRUN, so it will always have the actual value
> > even though it doesn’t appear that way in the guest. The guest will
> > only see the proper value for the SPEC_CTRL register if the guest was
> > to write to the SPEC_CTRL register again. With Virtual SPEC_CTRL
> > support, the MSR interception of SPEC_CTRL is disabled during
> > vmcb_init, so this will no longer be an issue.
> >
> > Signed-off-by: Babu Moger <babu.moger@amd.com>
> > ---
> >   arch/x86/include/asm/svm.h |    4 +++-
> >   arch/x86/kvm/svm/svm.c     |   29 +++++++++++++++++++++++++----
> >   2 files changed, 28 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> > index 71d630bb5e08..753b25db427c 100644
> > --- a/arch/x86/include/asm/svm.h
> > +++ b/arch/x86/include/asm/svm.h
> > @@ -248,12 +248,14 @@ struct vmcb_save_area {
> >   	u64 br_to;
> >   	u64 last_excp_from;
> >   	u64 last_excp_to;
> > +	u8 reserved_12[72];
> > +	u32 spec_ctrl;		/* Guest version of SPEC_CTRL at 0x2E0 */
> >
> >   	/*
> >   	 * The following part of the save area is valid only for
> >   	 * SEV-ES guests when referenced through the GHCB.
> >   	 */
> > -	u8 reserved_7[104];
> > +	u8 reserved_7[28];
> >   	u64 reserved_8;		/* rax already available at 0x01f8 */
> >   	u64 rcx;
> >   	u64 rdx;
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c index
> > 79b3a564f1c9..6d3db3e8cdfe 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -1230,6 +1230,16 @@ static void init_vmcb(struct vcpu_svm *svm)
> >
> >   	svm_check_invpcid(svm);
> >
> > +	/*
> > +	 * If the host supports V_SPEC_CTRL then disable the interception
> > +	 * of MSR_IA32_SPEC_CTRL.
> > +	 */
> > +	if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL)) {
> > +		save->spec_ctrl = svm->spec_ctrl;
> > +		set_msr_interception(&svm->vcpu, svm->msrpm,
> > +				     MSR_IA32_SPEC_CTRL, 1, 1);
> > +	}
> > +
> 
> I thought Jim's feedback was to keep the support as originally coded with
> respect to the MSR intercept and only update the svm_vcpu_run() to either
> read/write the MSR or read/write the save area value based on the feature.
> So I think this can be removed.

Ok. Sure. Will remove this change.

> 
> >   	if (kvm_vcpu_apicv_active(&svm->vcpu))
> >   		avic_init_vmcb(svm);
> >
> > @@ -2549,7 +2559,10 @@ static int svm_get_msr(struct kvm_vcpu *vcpu,
> struct msr_data *msr_info)
> >   		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD))
> >   			return 1;
> >
> > -		msr_info->data = svm->spec_ctrl;
> > +		if (static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> > +			msr_info->data = svm->vmcb->save.spec_ctrl;
> > +		else
> > +			msr_info->data = svm->spec_ctrl;
> 
> This is unneeded since svm->vmcb->save.spec_ctrl is saved in
> svm->spec_ctrl on VMEXIT.

Sure.

> 
> >   		break;
> >   	case MSR_AMD64_VIRT_SPEC_CTRL:
> >   		if (!msr_info->host_initiated &&
> > @@ -2640,6 +2653,8 @@ static int svm_set_msr(struct kvm_vcpu *vcpu,
> struct msr_data *msr)
> >   			return 1;
> >
> >   		svm->spec_ctrl = data;
> > +		if (static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> > +			svm->vmcb->save.spec_ctrl = data;
> 
> And this is unneeded since svm->vmcb->save.spec_ctrl is set to
> svm->spec_ctrl before VMRUN.

Sure.

> 
> >   		if (!data)
> >   			break;
> >
> > @@ -3590,7 +3605,10 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct
> kvm_vcpu *vcpu)
> >   	 * is no need to worry about the conditional branch over the wrmsr
> >   	 * being speculatively taken.
> >   	 */
> > -	x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
> > +	if (static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> > +		svm->vmcb->save.spec_ctrl = svm->spec_ctrl;
> > +	else
> > +		x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
> >
> >   	svm_vcpu_enter_exit(vcpu, svm);
> >
> > @@ -3609,12 +3627,15 @@ static __no_kcsan fastpath_t
> svm_vcpu_run(struct kvm_vcpu *vcpu)
> >   	 * If the L02 MSR bitmap does not intercept the MSR, then we need to
> >   	 * save it.
> >   	 */
> > -	if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
> > +	if (static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> > +		svm->spec_ctrl = svm->vmcb->save.spec_ctrl;
> > +	else if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
> >   		svm->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
> 
> If I understood Jim's feedback correctly, this will change to something like:
> 
> if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL))) {
> 	if (static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> 		svm->spec_ctrl = svm->vmcb->save.spec_ctrl;
> 	else
> 		svm->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
> }

Sure. Will take care of this in next revision. Thanks
Babu

> 
> Thanks,
> Tom
> 
> >
> >   	reload_tss(vcpu);
> >
> > -	x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
> > +	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> > +		x86_spec_ctrl_restore_host(svm->spec_ctrl, svm-
> >virt_spec_ctrl);
> >
> >   	vcpu->arch.cr2 = svm->vmcb->save.cr2;
> >   	vcpu->arch.regs[VCPU_REGS_RAX] = svm->vmcb->save.rax;
> >
