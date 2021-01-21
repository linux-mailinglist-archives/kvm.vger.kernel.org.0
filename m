Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 877A22FEFD2
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 17:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732585AbhAUQIl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 11:08:41 -0500
Received: from mail-bn8nam12on2063.outbound.protection.outlook.com ([40.107.237.63]:47200
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732279AbhAUQHo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jan 2021 11:07:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lWo6cvRXwiY0p/6dN6GMGkEVeApd39aByU3w1YdSOkrHucP07iFtYTuKtdbjZP9smk7RGmqlC6+Xsqmuq2EpFHiH2DQJO/xgEKQ0QrgxvYiP3F7HSTzrqOSkaaB9KjkIFG5139hp4xfZQKMxAjlqz5ObazFjgJ92SWnAVU0g+6zZyadrmfp1y4qWvrk+nZOpjmQvpUzg5kp5p0XeruPc4w14b6iqj+1x3Z65HXA+00YIrdwD6o+AqfNMz7Z9p3d0nh+xxLTgW+espeNM5qwKgbepHK4GT7Lk5IAnbMLLTm+UGHnBLvAAl5sdufEngzSsNGWiL5k4kXsFxIZ9J2Qyzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0sUq+zaGbNYXIcb4XvQd+BOgLCEfE5KymwmHGuDfTyk=;
 b=j8FP2o5f3wfIMP0hX232nhiUod+qXWLIvFvf0fJggaH/TCHFMNwYM9YGdtf1YeZ/V1l8L+/+1xOSUkhbgbyF/xDQKsQHCQV0j6dv7yAHbfbBZzhrLkxE+Eil9kUCrXwAP6xL/k/k9Lespu1F3+QDQUyAEeXhMVz8f77hZXxnbIvhHIH70nHGse6eLc/ejqwISxiEzpOuYS1Kix23Q9H3F7MCbeb5ro6HTH60nCPKV+stKgGuyugmp2SAAin8k1rWt51nKGURsMSDji1ReWmdrDpn27RqIALRApOeG3vggut0S8PJvD+XWAX6ZjDd9G+06Q2R3iG5PffHRfvMPi4d/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0sUq+zaGbNYXIcb4XvQd+BOgLCEfE5KymwmHGuDfTyk=;
 b=F0bpJmk34qY4as5EITAidqgwsgKAi39TOmwkmTb2oVG2KPhbEyuZHBEMN0txBqN/czzf1ecJEfcfheNDcgY00bHtMVQLxcQNwdaNZmQ27bqC7RVyFhEemhX23xJq6w7dpFRf3vJPUpLXMbRKFm2ITrLROlfEgOaKS7Dc2qxUYwg=
Authentication-Results: amacapital.net; dkim=none (message not signed)
 header.d=none;amacapital.net; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1494.namprd12.prod.outlook.com (2603:10b6:910:f::22)
 by CY4PR1201MB0215.namprd12.prod.outlook.com (2603:10b6:910:1d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Thu, 21 Jan
 2021 16:06:47 +0000
Received: from CY4PR12MB1494.namprd12.prod.outlook.com
 ([fe80::25d2:a078:e7b:a819]) by CY4PR12MB1494.namprd12.prod.outlook.com
 ([fe80::25d2:a078:e7b:a819%11]) with mapi id 15.20.3784.014; Thu, 21 Jan 2021
 16:06:47 +0000
Subject: Re: [PATCH v2 2/4] KVM: SVM: Add emulation support for #GP triggered
 by SVM instructions
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Wei Huang <wei.huang2@amd.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, seanjc@google.com, joro@8bytes.org,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, bsd@redhat.com,
        dgilbert@redhat.com, luto@amacapital.net
References: <20210121065508.1169585-1-wei.huang2@amd.com>
 <20210121065508.1169585-3-wei.huang2@amd.com>
 <cc55536e913e79d7ca99cbeb853586ca5187c5a9.camel@redhat.com>
From:   Wei Huang <whuang2@amd.com>
Message-ID: <c77f4f42-657a-6643-8432-a07ccf3b221e@amd.com>
Date:   Thu, 21 Jan 2021 10:06:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <cc55536e913e79d7ca99cbeb853586ca5187c5a9.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.113.46.183]
X-ClientProxiedBy: MN2PR05CA0049.namprd05.prod.outlook.com
 (2603:10b6:208:236::18) To CY4PR12MB1494.namprd12.prod.outlook.com
 (2603:10b6:910:f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.29] (70.113.46.183) by MN2PR05CA0049.namprd05.prod.outlook.com (2603:10b6:208:236::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.5 via Frontend Transport; Thu, 21 Jan 2021 16:06:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6571ad43-f318-4a01-79b0-08d8be268dbe
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0215:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0215B55A35147AF779F38158CFA10@CY4PR1201MB0215.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZWrbaFAk2xCJeiT+gFt0jYWZJi7mrLQLOKwJIW2bhvghfPy5F/rssmSVINoWPDoo8fLyOi5zaa1Q8mvyTuZ4bxJgsX93I+gCHsynzr25qa79KoeKKwyUq/3EDYxdixvgoq0LNLipjDUCcRgO69xWKcup18vfANgYUAy0H3uScUsBxn7kcdS0VxxoBxyIT2tDh+XZL8/g0NPnFT3sf+ui8zaRQlWLFXYS7jCJJtSK+yEen84fc4w3se35Vn4r0O4+PbTMqsZunDDRrzzDZM1d5V3J61OKp2sJIFSDR39pasu6ODMOj46MTcgcBKcqdnR3zLvd7E5x/3YdC9ENN9QCk3LmLnMg5Vv7mgOZtVE0moNa7/NUabp0WPl2i3c23fh8v2LF1avqQ5cFdC1d/SVQg2OBITePbl9YrO3AqZ/t12v2CkhDKfB9gzKWSE//4FD8kfAn5M06ORx+UcxGExR+XLVxBgyn2movJ5nZ2ez+qKY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1494.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(366004)(346002)(376002)(4326008)(66476007)(31686004)(83380400001)(2906002)(8676002)(5660300002)(478600001)(110136005)(316002)(8936002)(2616005)(36756003)(186003)(66946007)(16526019)(7416002)(31696002)(53546011)(52116002)(16576012)(66556008)(956004)(26005)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eHo1ZjBFanFsVmxWcmJnNFJha285RG1WUTg3L3dKckF4bzg3cVNOTGwvb3Jj?=
 =?utf-8?B?b2xRdit0UDY1U2JxWk1aclY0WGF5b29rYkUvZXZrSUx1STZEc21hK2grZ3Zu?=
 =?utf-8?B?NFlyamRiajR6d1RVL3VIa0pUYVFZRFZDL0tNaHp6Ym5hMVR0RDlvdDJxUFJX?=
 =?utf-8?B?d2dSWVNIaTNBK1JwSzZxOUIwRG5HRmxlL3FsK0ZVN2t1TTlrS2F1OTJJUEQx?=
 =?utf-8?B?Rm1yT21ySEVkN2lMY281T1o1d3ZUUHJhc1B4eGVvdE9LcWxYWmJYT1BjY1A0?=
 =?utf-8?B?ZTh1MmdlLzl1bi91OG9jRVgxajFCNDJaYlM5OFA1QzRyZlNrUFRqS1JGVzZN?=
 =?utf-8?B?VzM2c1g1NVVSdnc1Rk1JS2Z2WVhSUjlCMXRlYkRUOXllc0s1TmIrQWdBZXpw?=
 =?utf-8?B?TitXN1hUT1B4MjcvVlNJYmtxRXNJNlVCNzFIZWZvVzZrQmVIbHl0N3JuazNR?=
 =?utf-8?B?amxHVkg1YlAxUHVheThUMG5GVFZnY0V5NFN1SC90ZUNlV0JDUjBaMkovcFpl?=
 =?utf-8?B?Z29XL1dPT1Jweis2OUdwemtFM0VtaDNCRzlpa1Jaa0s3T0NONmhtREJDWUU3?=
 =?utf-8?B?Y0diMkNSaS9QODI5ejI4S1FkTld3SFZYVDJyL3FGS2FzNnRZcXVtYk03Qm5X?=
 =?utf-8?B?YkNwcEhTc2tvKzhnQXV3T2VQTzRWd3lWTUNXeFZ4N3BiZnVuZXpwK05YWlFK?=
 =?utf-8?B?UVE2K0p2akw3ck5YRHFvMUZnanFTZDgxMWVycXVBVEVHYkF6anIrNC9zWnFL?=
 =?utf-8?B?bzh1OURFaEVBVS9TVGttMktSZlZ6T2RHNmhvTUs4RWE3RUJ4dHNQYUZCTDNY?=
 =?utf-8?B?QmZQZ2lGRUJhUnQ5Tlk5SnB5YXE1ODNHVzIyMFN4MCtHdmJmS0kzZW9Cek9l?=
 =?utf-8?B?OWQ4QldrbjdkQUhHQlNhUkRxZFgzS1BkK3dHYlgra3BySUhxdHhFWkhjdExD?=
 =?utf-8?B?bkQrUTNKaXF0V1YzbVp3Nzh1RmVCVWJGclNCM1NMN29ndDVjY29HRE5HTTNL?=
 =?utf-8?B?SXc2UGxzcDAwMUordEZBNUF1SXhLdWFTenJhb3E2MVpjdEdnMW12OERGTk9K?=
 =?utf-8?B?TnhNR3dGQ0JDZzVXSWNrZFhXN3NUWUlsN0k4ZTg3UGcrVnJ2bmxyR3NqWVNY?=
 =?utf-8?B?czdPQzd6Vk9YMTh0ek85aUJONEprcjRRa0Jnalg0QXB6M0VXNVU5bGMrSGh4?=
 =?utf-8?B?WEtGditpN0dTb0NkRWcvZlpUWjRBY2NBS3BxelhOcEorMEZrYUJ0Qkt1aEQx?=
 =?utf-8?B?WGZPbVJoR004cnNVUmNjV3NLRllFQ0VvK1dDNVZ4ZzRkdEVETk9sankwakkz?=
 =?utf-8?Q?tdsvlkqYIg4JGkxwW0ZnEBdpsKaLaFhTlu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6571ad43-f318-4a01-79b0-08d8be268dbe
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1494.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 16:06:47.1439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QzUFZfdMT5+oyXxaoooMKz6DiNicLYXI3QcU/YPh6vRIBTCiky4CQkW0L7qUe9Wl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/21/21 8:07 AM, Maxim Levitsky wrote:
> On Thu, 2021-01-21 at 01:55 -0500, Wei Huang wrote:
>> From: Bandan Das <bsd@redhat.com>
>>
>> While running SVM related instructions (VMRUN/VMSAVE/VMLOAD), some AMD
>> CPUs check EAX against reserved memory regions (e.g. SMM memory on host)
>> before checking VMCB's instruction intercept. If EAX falls into such
>> memory areas, #GP is triggered before VMEXIT. This causes problem under
>> nested virtualization. To solve this problem, KVM needs to trap #GP and
>> check the instructions triggering #GP. For VM execution instructions,
>> KVM emulates these instructions.
>>
>> Co-developed-by: Wei Huang <wei.huang2@amd.com>
>> Signed-off-by: Wei Huang <wei.huang2@amd.com>
>> Signed-off-by: Bandan Das <bsd@redhat.com>
>> ---
>>  arch/x86/kvm/svm/svm.c | 99 ++++++++++++++++++++++++++++++++++--------
>>  1 file changed, 81 insertions(+), 18 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 7ef171790d02..6ed523cab068 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -288,6 +288,9 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
>>  		if (!(efer & EFER_SVME)) {
>>  			svm_leave_nested(svm);
>>  			svm_set_gif(svm, true);
>> +			/* #GP intercept is still needed in vmware_backdoor */
>> +			if (!enable_vmware_backdoor)
>> +				clr_exception_intercept(svm, GP_VECTOR);
> Again I would prefer a flag for the errata workaround, but this is still
> better.

Instead of using !enable_vmware_backdoor, will the following be better?
Or the existing form is acceptable.

if (!kvm_cpu_cap_has(X86_FEATURE_SVME_ADDR_CHK))
	clr_exception_intercept(svm, GP_VECTOR);

> 
>>  
>>  			/*
>>  			 * Free the nested guest state, unless we are in SMM.
>> @@ -309,6 +312,9 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
>>  
>>  	svm->vmcb->save.efer = efer | EFER_SVME;
>>  	vmcb_mark_dirty(svm->vmcb, VMCB_CR);
>> +	/* Enable #GP interception for SVM instructions */
>> +	set_exception_intercept(svm, GP_VECTOR);
>> +
>>  	return 0;
>>  }
>>  
>> @@ -1957,24 +1963,6 @@ static int ac_interception(struct vcpu_svm *svm)
>>  	return 1;
>>  }
>>  
>> -static int gp_interception(struct vcpu_svm *svm)
>> -{
>> -	struct kvm_vcpu *vcpu = &svm->vcpu;
>> -	u32 error_code = svm->vmcb->control.exit_info_1;
>> -
>> -	WARN_ON_ONCE(!enable_vmware_backdoor);
>> -
>> -	/*
>> -	 * VMware backdoor emulation on #GP interception only handles IN{S},
>> -	 * OUT{S}, and RDPMC, none of which generate a non-zero error code.
>> -	 */
>> -	if (error_code) {
>> -		kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
>> -		return 1;
>> -	}
>> -	return kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE_GP);
>> -}
>> -
>>  static bool is_erratum_383(void)
>>  {
>>  	int err, i;
>> @@ -2173,6 +2161,81 @@ static int vmrun_interception(struct vcpu_svm *svm)
>>  	return nested_svm_vmrun(svm);
>>  }
>>  
>> +enum {
>> +	NOT_SVM_INSTR,
>> +	SVM_INSTR_VMRUN,
>> +	SVM_INSTR_VMLOAD,
>> +	SVM_INSTR_VMSAVE,
>> +};
>> +
>> +/* Return NOT_SVM_INSTR if not SVM instrs, otherwise return decode result */
>> +static int svm_instr_opcode(struct kvm_vcpu *vcpu)
>> +{
>> +	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
>> +
>> +	if (ctxt->b != 0x1 || ctxt->opcode_len != 2)
>> +		return NOT_SVM_INSTR;
>> +
>> +	switch (ctxt->modrm) {
>> +	case 0xd8: /* VMRUN */
>> +		return SVM_INSTR_VMRUN;
>> +	case 0xda: /* VMLOAD */
>> +		return SVM_INSTR_VMLOAD;
>> +	case 0xdb: /* VMSAVE */
>> +		return SVM_INSTR_VMSAVE;
>> +	default:
>> +		break;
>> +	}
>> +
>> +	return NOT_SVM_INSTR;
>> +}
>> +
>> +static int emulate_svm_instr(struct kvm_vcpu *vcpu, int opcode)
>> +{
>> +	int (*const svm_instr_handlers[])(struct vcpu_svm *svm) = {
>> +		[SVM_INSTR_VMRUN] = vmrun_interception,
>> +		[SVM_INSTR_VMLOAD] = vmload_interception,
>> +		[SVM_INSTR_VMSAVE] = vmsave_interception,
>> +	};
>> +	struct vcpu_svm *svm = to_svm(vcpu);
>> +
>> +	return svm_instr_handlers[opcode](svm);
>> +}
>> +
>> +/*
>> + * #GP handling code. Note that #GP can be triggered under the following two
>> + * cases:
>> + *   1) SVM VM-related instructions (VMRUN/VMSAVE/VMLOAD) that trigger #GP on
>> + *      some AMD CPUs when EAX of these instructions are in the reserved memory
>> + *      regions (e.g. SMM memory on host).
>> + *   2) VMware backdoor
>> + */
>> +static int gp_interception(struct vcpu_svm *svm)
>> +{
>> +	struct kvm_vcpu *vcpu = &svm->vcpu;
>> +	u32 error_code = svm->vmcb->control.exit_info_1;
>> +	int opcode;
>> +
>> +	/* Both #GP cases have zero error_code */
> 
> I would have kept the original description of possible #GP reasons
> for the VMWARE backdoor and that WARN_ON_ONCE that was removed.
> 

Will do

> 
>> +	if (error_code)
>> +		goto reinject;
>> +
>> +	/* Decode the instruction for usage later */
>> +	if (x86_emulate_decoded_instruction(vcpu, 0, NULL, 0) != EMULATION_OK)
>> +		goto reinject;
>> +
>> +	opcode = svm_instr_opcode(vcpu);
>> +	if (opcode)
> 
> I prefer opcode != NOT_SVM_INSTR.
> 
>> +		return emulate_svm_instr(vcpu, opcode);
>> +	else
> 
> 'WARN_ON_ONCE(!enable_vmware_backdoor)' I think can be placed here.
> 
> 
>> +		return kvm_emulate_instruction(vcpu,
>> +				EMULTYPE_VMWARE_GP | EMULTYPE_NO_DECODE);
> 
> I tested the vmware backdoor a bit (using the kvm unit tests) and I found out a tiny pre-existing bug
> there:
> 
> We shouldn't emulate the vmware backdoor for a nested guest, but rather let it do it.
> 
> The below patch (on top of your patches) works for me and allows the vmware backdoor 
> test to pass when kvm unit tests run in a guest.
> 

This fix can be a separate patch? This problem exist even before this
patchset.

> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index fe97b0e41824a..4557fdc9c3e1b 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2243,7 +2243,7 @@ static int gp_interception(struct vcpu_svm *svm)
>  	opcode = svm_instr_opcode(vcpu);
>  	if (opcode)
>  		return emulate_svm_instr(vcpu, opcode);
> -	else
> +	else if (!is_guest_mode(vcpu))
>  		return kvm_emulate_instruction(vcpu,
>  				EMULTYPE_VMWARE_GP | EMULTYPE_NO_DECODE);
>  
> 
> 
> Best regards,
> 	Maxim Levitsky
> 
>> +
>> +reinject:
>> +	kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
>> +	return 1;
>> +}
>> +
>>  void svm_set_gif(struct vcpu_svm *svm, bool value)
>>  {
>>  	if (value) {
> 
> 
> 
> 
> 
