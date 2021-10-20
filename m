Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C793435271
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 20:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbhJTSQP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 14:16:15 -0400
Received: from mail-mw2nam12on2042.outbound.protection.outlook.com ([40.107.244.42]:51808
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230031AbhJTSQN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 14:16:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lTZHo1k2LaZye9XyVTWq0y5KpDA8KBVdhGhkQWe6v/1k1V1Tj5JmGdBtFdZyw6pVs7zDxGP6T/bapEFXvQiWcO7Z9PUMzDvZpurn7HKD/GY189dDnPNClfU7BVp/LaJuBLsLtMy42WcJWxawA+s9wvTZ4wbfktXgFBj5M72L4TCtgNuSpNV5g4N9Z1aCddNkVCdyTzU2neTEJ9JttkKS/fiR+je8LY9rv4uJRBc6Y7mLMoO2en6OIJSyVW1lebta1ZB/wPTApERQotD7IPC0SkpwTNez8sktHskVTqo3WgsMqSTCp9fJAcIiTrZDLscaY38929QBDIXsiH2huLaEUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1DoCCcVcTtO1Zu6DRXNoY2rZPt1michfD+JQdkQZ4ts=;
 b=Wmta+pit+PU4+cDYet6h1lt17mL5OS6ZqDK5G1N9hA2VPRvch6y3Irw1u9tq2CoQAkDqGlLZD5OE57jdwt+rEE97JXMPYxAB0SMhc02CSsoCETZvAj1jzdI7DySyax17wYoNmqwVYIqUJByUlhwijXIjEeh76LIcdBBIb6JLR/WjA/oxmsNHoy4OdQFahdPtss7uAQxX2DI5QePwScJVt0SETW9qm+bGHs5j6lKNzzMDAyH6dQf+5RPg+i2yR3sk909VyoJZl3UdpJ+6AmFw25Y4iLri/LUeh38CMLiHE2ZCbQZoZzx6/z1wS063vBg0nKgoUnrujC0lBzImLBJW6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1DoCCcVcTtO1Zu6DRXNoY2rZPt1michfD+JQdkQZ4ts=;
 b=OIY0f3Zk9Dl2TQQilXU6imq3cbr8lVgS8UOQ9q2FRLdwFvw496E1srooXpvCdsE4GVeLKFpTNRI46zvdc9i7r7eiS6WPV+FG7dmCroFHyzOSIyBck2Prnf3WNgE26PP+TKmbu1XMXp27dV+KXfY/jYfjFeg0DRTCGzGFtDqr9h0=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5328.namprd12.prod.outlook.com (2603:10b6:5:39f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Wed, 20 Oct
 2021 18:13:56 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9%7]) with mapi id 15.20.4628.016; Wed, 20 Oct 2021
 18:13:56 +0000
Subject: Re: [PATCH v5 4/6] KVM: SVM: Add support to handle AP reset MSR
 protocol
To:     Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
References: <20211020124416.24523-1-joro@8bytes.org>
 <20211020124416.24523-5-joro@8bytes.org> <YXBUlYll8JDjH/Wd@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <95d99b9a-8600-619b-9b83-63597d937bc6@amd.com>
Date:   Wed, 20 Oct 2021 13:13:53 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <YXBUlYll8JDjH/Wd@google.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR03CA0021.namprd03.prod.outlook.com
 (2603:10b6:208:2d::34) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from [10.236.30.241] (165.204.77.1) by BL0PR03CA0021.namprd03.prod.outlook.com (2603:10b6:208:2d::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15 via Frontend Transport; Wed, 20 Oct 2021 18:13:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf5573eb-d0f5-4884-ec75-08d993f5617d
X-MS-TrafficTypeDiagnostic: DM4PR12MB5328:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB532887CE326C0E17E4EFD9ACECBE9@DM4PR12MB5328.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: shoCeiMeY9eTokOAwUL8P7VaJnubbquckOGZlgUMldRXS/TsLBNTEZV3wo6FjxHuC0IIXbudsBA3+s0F9HQQB3BJLmfujzSNASNpSPmt7wnEIMLh1dg1Wt+ancFcMpN+unW24HipsRj4ugvdEJQockdh8pVb0a1u2m4WOlrIIW7m29qNA20R8WL0P3xEYrD/hsO70W9TyilyHM8IbwmHZ0N0sHgGrQVoMRMYolsd/XjKx4gqPFz1zwIk53f1Hi7lL1tc7wr5XUXhq42EjRn7IyQvappcZvJS+PaHzdWdQt93m6EvRAcKdS7XHSJTYpD7/NwZtnCdD+699K9lKnHIHCELkDov70n+TQvcTLU3sLcTyE57OUBRSL9jaCSIIBv9kC3pHhEaUX476mKQVvjPrl/hWtSLnSevmnij/5rtnvxSLx8YvazA7wENHIBypPMJc/Ql5DJpkf/p0fgNS8aOI4QHyzv5jSWZg3iBOmm3dS+MBt8f7igYgUziIzpoI7Ys515kPlT9cbljhQMiiAZF+TsZBPfBeB1Tt+Jm2rKJV4X+6s6u4kZCpd5EK1oDzljGGG563gB8MRMVknR0NzfIBXya6PyYgEONqex+mV0FW66xkooe3AIMVQJR+2iqWfbq2XCMwKiF2MIy3D8hfBqp3dvjeFpOev1GojVqB+AolyM8dfVz8DpJAXvKkFuJvsLRy4bPOcmg//7N3r0ThRWnPXx9IOFjeglwfHvDrW7yCDanjUIIcd9/wHrCHN5VcFqh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(7416002)(53546011)(8936002)(6486002)(26005)(86362001)(38100700002)(4326008)(508600001)(31686004)(31696002)(5660300002)(8676002)(956004)(186003)(36756003)(66946007)(16576012)(110136005)(54906003)(66556008)(83380400001)(316002)(66476007)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?Windows-1252?Q?+06GPvWaJ8XIrSUiTc6YncRJRFhGS0oZCLyyjSd0ipIyQ52G+jHBuh6p?=
 =?Windows-1252?Q?h/RIC4OSQ4BN9F9AumOL0tdUVzpcgk4mJrxUOj0OL8Ay/rm/Xr0Fl5Xt?=
 =?Windows-1252?Q?i+UUW47/PLTGlYB5m0mBXmXbOxnaXKy32FiNodDccqzf6/klaaZnIea/?=
 =?Windows-1252?Q?Y68PmKQ2iOw/8IRCmHIWHDcwNke8CYP+9Gr/pVaKR19H+Lyg1Wx9tA47?=
 =?Windows-1252?Q?8ALQ0jTvhawYBcRxaiZy3OsUAinDkYu1iamp5ndJtweopMQhs0XDnPec?=
 =?Windows-1252?Q?1tWx0CBFTEbt6CWA3bbafttbdxk/dJQZSZkF/BE608LaldPNEvUEwPz3?=
 =?Windows-1252?Q?+xCBZzbIxTaUTHMWXBc11YgrAlwJb/t/jjm/yTGFRCP2XJBZ3aAuGEGi?=
 =?Windows-1252?Q?5CpEonQMJWb3jNMm7SGXIAaVgvOnbQI3HR0ZXUE0Bfk91b/TpShGej/J?=
 =?Windows-1252?Q?AGVuQ87bAkhkQkSU4JsEVvzKjL5JzJhLh32JO5BF80urgwlO5gapks0A?=
 =?Windows-1252?Q?6ruvzd6F+n/70nZkf/dRtGjar97oqlTJwE62wE6tZ+MlBgd5IVr0PUcj?=
 =?Windows-1252?Q?DL+119PeQ6IEBW78rm5kFLE6nQ0BWDTWr2HXuDYqHy0lAOOYHXVn7sva?=
 =?Windows-1252?Q?rGdgpSJDPs0QuqZT8VpUBWZ/hhJvFe9yASa4GI9ej/25yLUJdXiC0ugl?=
 =?Windows-1252?Q?7eK/1MrHXWHrTBkHNhQR6jhZctLWYtUHPi5B6Biml5jfNsu66gmeoSEY?=
 =?Windows-1252?Q?OXjeyfwemHMjTyX+ltbNSqzt3bPEaRjiX8UV1b+nLngLhOfJ6U75gNEb?=
 =?Windows-1252?Q?cHA9UPLqEUYi9d9+7Uz9+zt+wpNhmxS270LDCMGVbyXh+AUU2vIZOn9r?=
 =?Windows-1252?Q?9sfy5wHDuogp4VxLlc7+toAbIe22aLMMORQEz9XC6zfyrZbi5TH4VrDc?=
 =?Windows-1252?Q?U8FwV6wq44s3PS/AsMCiiStUr0Mngfd7wa3VjUBtbMzkhmMipd4sfDZl?=
 =?Windows-1252?Q?XIcveXaWqyQQkF885dZmABtlLWHTeQ92rmK+3ZTH5/j7wfndb6DPNq4X?=
 =?Windows-1252?Q?Pp+JSFkAhWKyq4KY7Z1BUMYDWgyhNyGwJmP5wNQljHmUt/yd1HO59sLF?=
 =?Windows-1252?Q?CeWfQ3SfYusH1+wvreLvjNmVizyjDPLjr2ve12N8LSxTfJsdQIHZKWwK?=
 =?Windows-1252?Q?2kpe2asvAjX9EeMnl7HGob1HeP4hYqpOhQbOuHM43I9boWr+JtH5PB82?=
 =?Windows-1252?Q?R+zIedsv8e5ZBf2nO+8rPemkA2ZKVBF0+RuCtrBlsGGjq7paC7StIGi7?=
 =?Windows-1252?Q?K6CkzNGPuP9xobTPv1eGL0QilO7SgK80I5McXcjqJPBSG/MlVBXyBiu3?=
 =?Windows-1252?Q?2OQaLi0K3Ncm+vLejLFUFOmNPQ9dDXdhcOBEeiXL1DY/kfWpnRwzMLDD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf5573eb-d0f5-4884-ec75-08d993f5617d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 18:13:56.4316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tlendack@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5328
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/20/21 12:40 PM, Sean Christopherson wrote:
> On Wed, Oct 20, 2021, Joerg Roedel wrote:
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> Add support for AP Reset Hold being invoked using the GHCB MSR protocol,
>> available in version 2 of the GHCB specification.
> 
> The changelog needs to explain how this is actually supposed to work.  Doesn't
> need gory details, just a basic explanation of the sequence of events to wake a
> vCPU that requested a reset hold.
> 
> I apologize in advance for the following rant(s).  There's some actionable feedback,
> but a lot of it is just me complaining about the reset hold nonsense.
> 
> For the actual feedback, attached are two patches: patch 1 eliminates the
> "first_sipi_received" hack, patch 2 is a (hopefully) fixed version of this patch
> (but doesn't have an updated changelog).  Both are compile tested only.  There
> will be a benign conflict with patch 05 of this series.
> 
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> Signed-off-by: Joerg Roedel <jroedel@suse.de>
>> ---
>>   arch/x86/include/asm/kvm_host.h |  1 -
>>   arch/x86/kvm/svm/sev.c          | 52 ++++++++++++++++++++++++++-------
>>   arch/x86/kvm/svm/svm.h          |  8 +++++
>>   3 files changed, 49 insertions(+), 12 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index b67f550616cf..5c6b1469cc3b 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -237,7 +237,6 @@ enum x86_intercept_stage;
>>   	KVM_GUESTDBG_INJECT_DB | \
>>   	KVM_GUESTDBG_BLOCKIRQ)
>>   
>> -
> 
> Spurious whitespace change.
> 
>>   #define PFERR_PRESENT_BIT 0
>>   #define PFERR_WRITE_BIT 1
>>   #define PFERR_USER_BIT 2
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 9afa71cb36e6..10af4ac83971 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -2246,6 +2246,9 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
>>   
>>   void sev_es_unmap_ghcb(struct vcpu_svm *svm)
>>   {
>> +	/* Clear any indication that the vCPU is in a type of AP Reset Hold */
>> +	svm->reset_hold_type = AP_RESET_HOLD_NONE;
>> +
>>   	if (!svm->ghcb)
>>   		return;
>>   
>> @@ -2405,14 +2408,21 @@ static u64 ghcb_msr_version_info(void)
>>   	return msr;
>>   }
>>   
>> -static int sev_emulate_ap_reset_hold(struct vcpu_svm *svm)
>> +static int sev_emulate_ap_reset_hold(struct vcpu_svm *svm, enum ap_reset_hold_type type)
>>   {
>>   	int ret = kvm_skip_emulated_instruction(&svm->vcpu);
>>   
>> +	svm->reset_hold_type = type;
>> +
>>   	return __kvm_vcpu_halt(&svm->vcpu,
>>   			       KVM_MP_STATE_AP_RESET_HOLD, KVM_EXIT_AP_RESET_HOLD) && ret;
>>   }
>>   
>> +static u64 ghcb_msr_ap_rst_resp(u64 value)
>> +{
>> +	return (u64)GHCB_MSR_AP_RESET_HOLD_RESP | (value << GHCB_DATA_LOW);
>> +}
>> +
>>   static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
>>   {
>>   	struct vmcb_control_area *control = &svm->vmcb->control;
>> @@ -2459,6 +2469,16 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
>>   
>>   		break;
>>   	}
>> +	case GHCB_MSR_AP_RESET_HOLD_REQ:
>> +		ret = sev_emulate_ap_reset_hold(svm, AP_RESET_HOLD_MSR_PROTO);
>> +
>> +		/*
>> +		 * Preset the result to a non-SIPI return and then only set
>> +		 * the result to non-zero when delivering a SIPI.
>> +		 */
>> +		svm->vmcb->control.ghcb_gpa = ghcb_msr_ap_rst_resp(0);
> 
> This can race with the SIPI and effectively corrupt svm->vmcb->control.ghcb_gpa.
> 
>          vCPU0                           vCPU1
>                                          #VMGEXIT(RESET_HOLD)
>                                          __kvm_vcpu_halt()
>          INIT
>          SIPI
>          sev_vcpu_deliver_sipi_vector()
>          ghcb_msr_ap_rst_resp(1);

This isn't possible. vCPU0 doesn't set vCPU1's GHCB value. vCPU1's GHCB 
value is set when vCPU1 handles events in vcpu_enter_guest().

Thanks,
Tom

>                                          ghcb_msr_ap_rst_resp(0);
> 
> Note, the "INIT" above is mostly a guess.  I'm pretty sure it's necessary because
> I don't see how KVM can possibly be correct otherwise.  The SIPI handler (below)
> quite clearly expects the vCPU to have been in an AP reset hold, but the invocation
> of sev_vcpu_deliver_sipi_vector is gated by the vCPU being in
> KVM_MP_STATE_INIT_RECEIVED, not KVM_MP_STATE_AP_RESET_HOLD.  That implies the BSP
> must INIT the AP.
> 
>                  if (vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED) {
>                          /* evaluate pending_events before reading the vector */
>                          smp_rmb();
>                          sipi_vector = apic->sipi_vector;
>                          kvm_x86_ops.vcpu_deliver_sipi_vector(vcpu, sipi_vector);
>                          vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
>                  }
> 
> But the GHCB 2.0 spec doesn't actually say that; it instead implies that SIPI is
> supposed to be able to directly wake the AP.
> 
>    * When a guest AP reaches its HLT loop (or similar method for parking the AP),
>      it instead can either:
>        1. Issue an AP Reset Hold NAE event.
>        2. Issue the AP Reset Hold Request MSR Protocol
>    * The hypervisor treats treats either request like the guest issued a HLT
>                     ^^^^^^^^^^^^^                                        ^^^
>                     spec typo                                            ???
>      instruction and marks the vCPU as halted.
>    * When the hypervisor receives a SIPI request for the vCPU, it will not update
>                                     ^^^^^^^^^^^^
>      any register values and, instead, it will either complete the AP Reset Hold
>      NAE event or complete the AP Reset Hold MSR protocol
>    * Mark the vCPU as active, allowing the VMGEXIT to complete.
>    * Upon return from the VMGEXIT, the AP must transition from its current execution
>      mode into real mode and begin executing at the reset vector supplied in the SIPI
>      request.
> 
> Piecing things together, my understanding is that the "hold request" really is
> intended to be a HLT, but with extra semantics where the host sets sw_exit_info_2
> to indicate that the vCPU was woken by INIT-SIPI.
> 
> It's probably too late to change the spec, but I'm going to complain anyways.
> This is all ridiculously convoluted and completely unnecessary.  As pointed out
> in the SNP series regarding AP "creation", this can be fully handled in the guest
> via a simple mailbox between firmware and kernel.  What's really fubar is that
> the guest firmware and kernel already have a mailbox!  But it's defined by the
> GHCB spec instead of e.g. ACPI, and so instead of handling this fully within the
> guest, the hypervisor (and PSP to some extent on SNP because of the secrets page!!!)
> gets involved.
> 
> The complications to support this in the guest firmware are hilarious, e.g. the
> guest hasto manually switch from 64-bit mode to Real Mode just so that the kernel
> can continue to use a horribly antiquated method for gaining control of APs.
> 
>> +
>> +		break;
>>   	case GHCB_MSR_TERM_REQ: {
>>   		u64 reason_set, reason_code;
>>   
>> @@ -2544,7 +2564,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>>   		ret = svm_invoke_exit_handler(vcpu, SVM_EXIT_IRET);
>>   		break;
>>   	case SVM_VMGEXIT_AP_HLT_LOOP:
>> -		ret = sev_emulate_ap_reset_hold(svm);
>> +		ret = sev_emulate_ap_reset_hold(svm, AP_RESET_HOLD_NAE_EVENT);
>>   		break;
>>   	case SVM_VMGEXIT_AP_JUMP_TABLE: {
>>   		struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
>> @@ -2679,13 +2699,23 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
> 
> Tying into above, handling this in SIPI is flawed.  For example, if the guest
> does INIT-SIPI-SIPI without a reset hold, KVM would incorrect set sw_exit_info_2
> on the SIPI.  Because this mess requires an INIT, KVM has lost track of whether
> the guest was in KVM_MP_STATE_AP_RESET_HOLD and thus can't know if the SIPI
> arrived after a reset hold.  Looking at KVM, IIUC, this bug is why the hack
> "received_first_sipi" exists.
> 
> Of course this all begs the question of why there's a "reset hold" concept in
> the first place.  It's literally HLT with a flag to say "you got INIT-SIPI".
> But the guest has to supply and fill a jump table!  Just put the flag in the
> jump table!!!!
> 
>>   		return;
>>   	}
>>   
>> -	/*
>> -	 * Subsequent SIPI: Return from an AP Reset Hold VMGEXIT, where
>> -	 * the guest will set the CS and RIP. Set SW_EXIT_INFO_2 to a
>> -	 * non-zero value.
>> -	 */
>> -	if (!svm->ghcb)
>> -		return;
>> -
>> -	ghcb_set_sw_exit_info_2(svm->ghcb, 1);
>> +	/* Subsequent SIPI */
>> +	switch (svm->reset_hold_type) {
>> +	case AP_RESET_HOLD_NAE_EVENT:
>> +		/*
>> +		 * Return from an AP Reset Hold VMGEXIT, where the guest will
>> +		 * set the CS and RIP. Set SW_EXIT_INFO_2 to a non-zero value.
>> +		 */
>> +		ghcb_set_sw_exit_info_2(svm->ghcb, 1);
> 
> Doesn't this need to check for a null svm->ghcb?
> 
> I also suspect a boolean might make it easier to understand the implications
> and also make the whole thing less error prone, e.g.
> 
>          if (svm->reset_hold_msr_protocol) {
> 
>          } else if (svm->ghcb) {
> 
>          }
> 
>> +		break;
>> +	case AP_RESET_HOLD_MSR_PROTO:
>> +		/*
>> +		 * Return from an AP Reset Hold VMGEXIT, where the guest will
>> +		 * set the CS and RIP. Set GHCB data field to a non-zero value.
>> +		 */
>> +		svm->vmcb->control.ghcb_gpa = ghcb_msr_ap_rst_resp(1);
>> +		break;
>> +	default:
>> +		break;
>> +	}
>>   }
>> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
>> index 68e5f16a0554..bf9379f1cfb8 100644
>> --- a/arch/x86/kvm/svm/svm.h
>> +++ b/arch/x86/kvm/svm/svm.h
>> @@ -69,6 +69,12 @@ enum {
>>   /* TPR and CR2 are always written before VMRUN */
>>   #define VMCB_ALWAYS_DIRTY_MASK	((1U << VMCB_INTR) | (1U << VMCB_CR2))
>>   
>> +enum ap_reset_hold_type {
>> +	AP_RESET_HOLD_NONE,
>> +	AP_RESET_HOLD_NAE_EVENT,
>> +	AP_RESET_HOLD_MSR_PROTO,
>> +};
>> +
>>   struct kvm_sev_info {
>>   	bool active;		/* SEV enabled guest */
>>   	bool es_active;		/* SEV-ES enabled guest */
>> @@ -199,6 +205,8 @@ struct vcpu_svm {
>>   	bool ghcb_sa_free;
>>   
>>   	bool guest_state_loaded;
>> +
>> +	enum ap_reset_hold_type reset_hold_type;
>>   };
>>   
>>   struct svm_cpu_data {
>> -- 
>> 2.33.1
>>
