Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6AB26B26D
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 00:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727759AbgIOWqy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 18:46:54 -0400
Received: from mail-dm6nam12on2087.outbound.protection.outlook.com ([40.107.243.87]:64288
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727492AbgIOPpX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 11:45:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bNP3TnFmi1bgpc0f9mUsBE3hmHlNC9MaVKfAZLpWKv/A09YJ26Gz0iqOkvJSU+0h2DrrVGown+xwhRSbaKQMThS4E0JFNba/2tjePVvkiWx6jX2kKskV/fXUr51EEbPkwylXHa2vCzIi2OXuQyigOmMPiE2i39cSFWLsHXzjHt8MPv76I4BeMb0Ku5/Cv2MhrrZnhv54ewxo1bQje3XEQvwwXiujj2ph4G0ZQReIP9Cwm9ZSqCfFcc1XP7A15kYZ1RnsDol+QLpGB3vv2c/GmAJey0usyvvwnoaGzbAyPl3OM9w4ozTYptaNYG5mVefvJ79L9xdlG+PAlqvoQNxLsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WcjiMe2+++PDyCbACMTLxSbh5q8ZcGbHDCLL8v2xAfM=;
 b=HF7YN5vise69bLIOoomwNdq98Q99iLWYfCG2DVV5c88CB6sIThwF1I2c7VAsl3w145a5g7dl1nFZ6itMUVo46TeWC6vc5MoOI0xEM/tN8S04ag0K2uJCCCXd/InyXnXqf5gUvP+Z3a0NJNF2nq6h7jY/FwlO0b5DtokIw3ZNFZ6cj97ODhNZoAJc4MpzlcA7mMcUqn/rvZEweU6ooHmETclN00DSdYDFAxxjlaVEd0G02rwQUaU3nRwMcAaHCYlf1X9vGoEWHuMU+lYUMpcuK0tvHK3IjnR/Ic7prkqMcff1DHMQHKBNKaovccLDscRL2SJevSsHZpeHFkxqHwd0wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WcjiMe2+++PDyCbACMTLxSbh5q8ZcGbHDCLL8v2xAfM=;
 b=bCAKQD8Uw6xQy3Gy+XkfFWPWjBAUzVFmHzTJe2K7EZz3C80ynVImEGn4VAHYLA5mMDCQfDpMKjbsplESRj1GeXQeRpWWepMdFLikoY+OgzEX6tke+yQguLvAKSW99lDYBLOSeBsT07W5n+ncdIlrOTBl+ZMy2Tne3q9r9XaABxE=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR1201MB0166.namprd12.prod.outlook.com (2603:10b6:910:24::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 15 Sep
 2020 15:45:18 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::989b:b1b2:464c:443]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::989b:b1b2:464c:443%10]) with mapi id 15.20.3370.019; Tue, 15 Sep 2020
 15:45:18 +0000
Subject: Re: [RFC PATCH 21/35] KVM: SVM: Add support for EFER write traps for
 an SEV-ES guest
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
 <240ce8d7c9bd84adf66a4a0625150a1ae215345e.1600114548.git.thomas.lendacky@amd.com>
 <20200914220800.GI7192@sjchrist-ice>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <c5a57f9a-abbb-d12f-c45a-9d5528562212@amd.com>
Date:   Tue, 15 Sep 2020 10:45:15 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200914220800.GI7192@sjchrist-ice>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR01CA0006.prod.exchangelabs.com (2603:10b6:5:296::11)
 To CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by DM6PR01CA0006.prod.exchangelabs.com (2603:10b6:5:296::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Tue, 15 Sep 2020 15:45:17 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c74f795f-0886-45cf-6130-08d8598e58ba
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0166:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB01668A0FE6AF6F13B660B3C3EC200@CY4PR1201MB0166.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sKvVyOCAIYLV6m/AeNqu3pUXIJypM4ZU4BZXBNvRcKZy+DCIcuBLHm/JSpTxfUB8iswkn0ZXhmxhEjv5HB5ZOr5lDf2bpDgZ0H+vsdgYuMG9vB5z5Y57fUeV1m2qmAJmax+ndO0Tv7n9C1Q469zFq3fP5MHUil89CPDRb13KRb3tazaAd42uxSjYXZPBqexQEE42SwdtI7SnPUIXGhNJeisy1ICjAcP/SFKgCsgZuQnD2xKns5OdnNsr0S7o4VpBADKY3jhzaoxxrKXOEoUaWTIdt/jdw6jm6vJOYOdO7Dy+LiLqZjAWWHKIgXKeQYwf7l9CMjbE3uy4hHseOS5ykyMOn0c65TwfCjPF/WlWk7B3ySV05zwLd8FODiZmfK8o
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(366004)(396003)(52116002)(6486002)(2616005)(36756003)(6916009)(956004)(5660300002)(31686004)(54906003)(53546011)(4326008)(66556008)(66476007)(2906002)(16526019)(316002)(16576012)(8676002)(186003)(478600001)(26005)(66946007)(83380400001)(8936002)(86362001)(31696002)(7416002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: H9rSsVjU1By0TISTO2lMYW19bVsLUhsMek+AN4N4W89FyicKoHHXuJ7Zb5D9fu1Vi4NM+C7i0HZjuO/ciEmeGicK+srlB5qITlViKe95JaPXOos3I+stcXoyxSJflG5/WRYCspaBMxliaXvkSMaYfpeuNjjB5qotWYeZSQYCxluTQ3OwA/8H4rsQyv2QOZeq/7lGuNE0bVNm5wZTNvUKlaig0W4tlQnsiJNYCmXw7CzMOQsXeiLrBXAdmi0RVwFCqpgX8g3sutISoO7ObX3YVYNip6jFy0dbEV/DM7eWI3/5d/IuTy2YGv2tf7JuVegckxjqxHm55fpQHIkQFNDa0Rx8dm9txhr6nkoS1rofJDxp4930pLq+PI813wZySq+jzKh+8XyPBrglcNObNFJkqIu13X0pQirpQAHZtdxIuSZEUbt1l0yVstrY37ostxCCzk2v9cXOOMW1UdToKUhPTuOLBqDeKygofPN1jg8W9S7pxRZ+cw6kSQlUkWsKiK5/16SEKVVyCwHMQYpK/BbWERr9ycRmcWgqdGj859/r/dF4ehhslvLUjpX/eTtg0+BX4k+dakQU/1+9ybN/A+pZY1aJBniKQRoEM3fAPLZiUXVz2ujijDtdIo4O6pCbKI0u1IxrZfDGE50W4Q8BjbddiA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c74f795f-0886-45cf-6130-08d8598e58ba
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2020 15:45:18.4531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Vgy8Azj9UN+BHcZN6pEuVkJK1BgRkPv+chg4UVWIx+CmZg46SoZsv2PM4GoKgaZtDzxi3vVGE3VQDhsTXoZMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0166
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/14/20 5:08 PM, Sean Christopherson wrote:
> On Mon, Sep 14, 2020 at 03:15:35PM -0500, Tom Lendacky wrote:
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> For SEV-ES guests, the interception of EFER write access is not
>> recommended. EFER interception occurs prior to EFER being modified and
>> the hypervisor is unable to modify EFER itself because the register is
>> located in the encrypted register state.
>>
>> SEV-ES guests introduce a new EFER write trap. This trap provides
>> intercept support of an EFER write after it has been modified. The new
>> EFER value is provided in the VMCB EXITINFO1 field, allowing the
>> hypervisor to track the setting of the guest EFER.
>>
>> Add support to track the value of the guest EFER value using the EFER
>> write trap so that the hypervisor understands the guest operating mode.
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> ---
>>  arch/x86/include/asm/kvm_host.h |  1 +
>>  arch/x86/include/uapi/asm/svm.h |  2 ++
>>  arch/x86/kvm/svm/svm.c          | 12 ++++++++++++
>>  arch/x86/kvm/x86.c              | 12 ++++++++++++
>>  4 files changed, 27 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 7320a9c68a5a..b535b690eb66 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1427,6 +1427,7 @@ void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
>>  int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
>>  		    int reason, bool has_error_code, u32 error_code);
>>  
>> +int kvm_track_efer(struct kvm_vcpu *vcpu, u64 efer);
>>  int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
>>  int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3);
>>  int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
>> diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
>> index 0bc3942ffdd3..ce937a242995 100644
>> --- a/arch/x86/include/uapi/asm/svm.h
>> +++ b/arch/x86/include/uapi/asm/svm.h
>> @@ -77,6 +77,7 @@
>>  #define SVM_EXIT_MWAIT_COND    0x08c
>>  #define SVM_EXIT_XSETBV        0x08d
>>  #define SVM_EXIT_RDPRU         0x08e
>> +#define SVM_EXIT_EFER_WRITE_TRAP		0x08f
>>  #define SVM_EXIT_NPF           0x400
>>  #define SVM_EXIT_AVIC_INCOMPLETE_IPI		0x401
>>  #define SVM_EXIT_AVIC_UNACCELERATED_ACCESS	0x402
>> @@ -183,6 +184,7 @@
>>  	{ SVM_EXIT_MONITOR,     "monitor" }, \
>>  	{ SVM_EXIT_MWAIT,       "mwait" }, \
>>  	{ SVM_EXIT_XSETBV,      "xsetbv" }, \
>> +	{ SVM_EXIT_EFER_WRITE_TRAP,	"write_efer_trap" }, \
>>  	{ SVM_EXIT_NPF,         "npf" }, \
>>  	{ SVM_EXIT_AVIC_INCOMPLETE_IPI,		"avic_incomplete_ipi" }, \
>>  	{ SVM_EXIT_AVIC_UNACCELERATED_ACCESS,   "avic_unaccelerated_access" }, \
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index ac64a5b128b2..ac467225a51d 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -2466,6 +2466,17 @@ static int cr8_write_interception(struct vcpu_svm *svm)
>>  	return 0;
>>  }
>>  
>> +static int efer_trap(struct vcpu_svm *svm)
>> +{
>> +	int ret;
>> +
>> +	ret = kvm_track_efer(&svm->vcpu, svm->vmcb->control.exit_info_1);
>> +	if (ret)
> 
> Shouldn't this be a WARN or something?  E.g. KVM thinks the WRMSR has faulted,
> while it obviously hasn't, which means KVM's internal model is now out of sync.

Makes sense, I can add something here.

> 
>> +		return ret;
>> +
>> +	return kvm_complete_insn_gp(&svm->vcpu, 0);
>> +}
>> +
>>  static int svm_get_msr_feature(struct kvm_msr_entry *msr)
>>  {
>>  	msr->data = 0;
>> @@ -2944,6 +2955,7 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
>>  	[SVM_EXIT_MWAIT]			= mwait_interception,
>>  	[SVM_EXIT_XSETBV]			= xsetbv_interception,
>>  	[SVM_EXIT_RDPRU]			= rdpru_interception,
>> +	[SVM_EXIT_EFER_WRITE_TRAP]		= efer_trap,
>>  	[SVM_EXIT_NPF]				= npf_interception,
>>  	[SVM_EXIT_RSM]                          = rsm_interception,
>>  	[SVM_EXIT_AVIC_INCOMPLETE_IPI]		= avic_incomplete_ipi_interception,
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 674719d801d2..b65bd0c986d4 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1480,6 +1480,18 @@ static int set_efer(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>  	return 0;
>>  }
>>  
>> +int kvm_track_efer(struct kvm_vcpu *vcpu, u64 efer)
>> +{
>> +	struct msr_data msr_info;
>> +
>> +	msr_info.host_initiated = false;
>> +	msr_info.index = MSR_EFER;
>> +	msr_info.data = efer;
>> +
>> +	return set_efer(vcpu, &msr_info);
>> +}
>> +EXPORT_SYMBOL_GPL(kvm_track_efer);
> 
> I don't see any reason to put this in x86.c, just copy-paste the guts into
> efer_trap() and s/set_efer/kvm_set_msr_common.

Ok, I can do that. I'll add a comment to indicate that the result of doing
that is that set_efer() is ultimately invoked through that path.

Thanks,
Tom

> 
>> +
>>  void kvm_enable_efer_bits(u64 mask)
>>  {
>>         efer_reserved_bits &= ~mask;
>> -- 
>> 2.28.0
>>
