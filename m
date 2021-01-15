Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F59F2F7369
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 08:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730392AbhAOHBW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 02:01:22 -0500
Received: from mail-co1nam11on2070.outbound.protection.outlook.com ([40.107.220.70]:35137
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726614AbhAOHBV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 02:01:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PEefWG4WhvcYHsxnqnnePN1yi1yhVaFy9Y4TmOeGXmUjf8gxe0qyFZez1ETIE84SMEfhAKgfE6XsnXSANWG5hPCC0DtK5W28JtBUwTR9Av67HhsaypOaksBS9QCvN+EtcpRylc9Lgw4zBdpSoFjrxE8McWX1PZeG/ceRBuuiOaDi9elh/khcheZqINVb5LU405Rcc8BiBT+b54YqBUfSSVuZma0cQ3H4u7a3NVK+GKK97gvZixQc2Y2C0eqEuB2ZF/t6WrsNiA34pqJ2AJAvRFBj6ysPQutIKqBn0/uKRiiVi8dueX0m17tKTyH/31NXoO2Joxqzl2JAGVksRt9QfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DyEtK9cNNIdSPEo3fQ+5pAOtGgRoFkSlYGmRwgNPFmw=;
 b=FTiyUSGYIwBEGqxJASHy5VflQicLO0l1Ef6cz/3HAdhgMFrgdsc4f6lFKoexZRBRJv0vk7WQgRINi4RY/qnaI2mW3wf45uuoOARkvm0SC2VKYUmjAHHSWmNyi1e9pi7RXUYUHpIv7LlLkMTtydYouCTvJAjtH5LJdV8zIxdDi4dfL53ftseaIWNt3qM3mL1XovDDY3sEl2q5nmaeokkPmObg7N/k7Nlnmq30lxU+sIa8y4vx+xcDeKMz/dpDhLL5sTw+SZSm3Ek0v3pLJWQsuJga/gv1ifQs5IDCUKCFh9jnyTr6x1L3H+N5gF1+g8MNOOR9Hf2G3K/vqLqcjXJhow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DyEtK9cNNIdSPEo3fQ+5pAOtGgRoFkSlYGmRwgNPFmw=;
 b=4m3L8HmmGNLbOf8oJZ63X5igm48NzJiu1ldAzzEaOd6V/D8Nzele9ysIfTiTuGXr/JXAjRhy4xP05sTlaSMbondp+1fuipGB+unRlDVEYQ3Elfb0mp+uY0R4pux9iLSsRQvURYHuMqyWoLMUk6Tdag0Fz7Uo5vICaIWmT9FkrFc=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1494.namprd12.prod.outlook.com (2603:10b6:910:f::22)
 by CY4PR12MB1144.namprd12.prod.outlook.com (2603:10b6:903:3f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Fri, 15 Jan
 2021 07:00:27 +0000
Received: from CY4PR12MB1494.namprd12.prod.outlook.com
 ([fe80::25d2:a078:e7b:a819]) by CY4PR12MB1494.namprd12.prod.outlook.com
 ([fe80::25d2:a078:e7b:a819%11]) with mapi id 15.20.3763.012; Fri, 15 Jan 2021
 07:00:27 +0000
Subject: Re: [PATCH 1/2] KVM: x86: Add emulation support for #GP triggered by
 VM instructions
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Wei Huang <wei.huang2@amd.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        seanjc@google.com, joro@8bytes.org, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, bsd@redhat.com,
        dgilbert@redhat.com, mlevitsk@redhat.com
References: <20210112063703.539893-1-wei.huang2@amd.com>
 <090232a9-7a87-beb9-1402-726bb7cab7e6@redhat.com>
From:   Wei Huang <whuang2@amd.com>
Message-ID: <ed93c796-1750-7cb8-ed4d-dc9c4b68b5a3@amd.com>
Date:   Fri, 15 Jan 2021 01:00:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <090232a9-7a87-beb9-1402-726bb7cab7e6@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [70.113.46.183]
X-ClientProxiedBy: SN4PR0501CA0089.namprd05.prod.outlook.com
 (2603:10b6:803:22::27) To CY4PR12MB1494.namprd12.prod.outlook.com
 (2603:10b6:910:f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.29] (70.113.46.183) by SN4PR0501CA0089.namprd05.prod.outlook.com (2603:10b6:803:22::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.7 via Frontend Transport; Fri, 15 Jan 2021 07:00:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 306e8c21-56b1-4ad4-12d0-08d8b9233cce
X-MS-TrafficTypeDiagnostic: CY4PR12MB1144:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB11440BA5D384271F83D7F811CFA70@CY4PR12MB1144.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W2/mqJTsX482oW4YBqjo3SS74ddOOq9Kqyd1HS1c4ZTRryEPd6beCDJIk3oUPPOKbox1w1n2cqJEQ1sv/JyidPwfDKKlQFa9KfPehYdiut6PjKRn7s6DgkPgpXGxziNvO7Vuhfgbpn6GrhBjka+F0NtVFVQfCretqMPUpSVSogU7+IcUivAegRMA7w04kt6LE5sO1QB2+okOn4g7Ha/x9jPIiTotpUgbg8ewlD90lwtroSz4uaydr2GQiumYLGuMWj4U8k72mQlUtvkcTSBow/1EsPFyTxBA0ZG9lynagzSWJlPIDudM35mlsPk8ejmeTXHGHTchCgahyHYDTttVo3pZ91l5HqQoc9Zx14wvIJapXrg+FwX+JwWsKnOIDtfxcXAsPsWBXjoj0WhMQFSTw3PbXEi50H0Km/uRuKUd+XHZxoeavCbdfzWZIDockOQMRxdAodHSovqpZ8+bN7lCKEN6up1ImSrBzoeduwwgQy4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1494.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(346002)(39860400002)(376002)(16526019)(4326008)(16576012)(7416002)(53546011)(8676002)(316002)(110136005)(186003)(26005)(5660300002)(2616005)(6486002)(478600001)(31696002)(2906002)(66556008)(36756003)(66946007)(52116002)(6666004)(956004)(8936002)(31686004)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?a3RMQWg1ZTBDOU8rNHNkaFMxR0paWG5rbUZRM1ZGNnhXZGYvc1I5NzdFVDdC?=
 =?utf-8?B?V1ZjSGJPaVU0RVk4NnZHYUV6aENpeWEvM2dkTGZFVjN1cTczUHEyVk13QTlX?=
 =?utf-8?B?RC9SR2MvZ2hsVHhKelNVRWlHaG9WaDYvbG5SaE1senpleStmeWdjdkRaN3RJ?=
 =?utf-8?B?VXVyd1hudUpwcjRMbWJjUEQyaVhtcytjTDlDS3VNRHc4MWNybzJjNmRkMDNn?=
 =?utf-8?B?YzBhZlRTOEJuSlI2OGVhazdIRDZ3ckRkQ3puRGtJek5TaFhJanB5amV5UHNw?=
 =?utf-8?B?SEtUaW9aWG5uTVYzT1kwMHpxTFQxbFdGWWI5VFRrQ0pBSmsvZmRsVU1lTDlW?=
 =?utf-8?B?WlJnOG1SZnR5TzU3dXFqckdocWlCcTE2UkhWUk1zOW5HUGJENkpFN0pNN1JZ?=
 =?utf-8?B?UHJjZjY5dlNMQStReExzQ1pEL0RTekRlRzJxZGxYeXpnV3JOc0RlS0lWN3hD?=
 =?utf-8?B?a0xtbTZxclROSEtqTGtob09FS1FQaUJ0dXBnbi9zTS9kd1poVmE4MDB4UG0x?=
 =?utf-8?B?TllyMzFWSG5UVUdwd2VGaGFiemxRSW1IMmE0RWpCOVBIbTNPcHFXa00ybStQ?=
 =?utf-8?B?MWh4TjhMRFVudkRIR1RpTmVieDYzWjdvQlZZOFJjSHFDNnNab3FlaWgrbjR6?=
 =?utf-8?B?Z0krQ3MwclhqR1BlSGIzMVpxaDlieVB1YUpReFhLYVdPd0kvVHFLcFZJNW1I?=
 =?utf-8?B?dHJ2aWw3eWk0ZXB5OHM4WGZVZUg4ZnhQQXlzL0N2TnFieU81NzdaNEhyRVZF?=
 =?utf-8?B?RmxYU0tGU2lPNVZ1SlpMcDIzbkRTTUZoWFhrZis3TG5WZzQvcy9qVWtHUkxs?=
 =?utf-8?B?YXFubmVpOEViTDVpamkrZ3ppMGpnSE9VOFQ2ZHZUNXAvZHhwQ3o1MjBRaStm?=
 =?utf-8?B?TTVBR2hzb25EYWpwQ212c0VmTFp6dzk4SHB3azRTWW9IMllFeDMyRzlRVUxn?=
 =?utf-8?B?cEFBTFcxdVRhQnRXcGlNL2J4MjAvQmE3L1JhdmtqL3YyWkZUVUJBOEJlY202?=
 =?utf-8?B?VjlIWENZdVE4enJiSEx3NjlYUjJRTWkzUXJjeUFGRzdrK3E3MGtna2dBeFVY?=
 =?utf-8?B?dEZwUlRycytYUFo1ODdUdlFycWZYbm5jRkN6eUcwU0pqdThLWStOTmlIcXFR?=
 =?utf-8?B?Vi9scEVDNjZVS2JGbm90MDJCdDk5R3A0QXRQUmhETjJqUWdodktNWTE0VlUx?=
 =?utf-8?B?bEdOQUtwdTNtSmVQVnFOeXNpTTRhVVJDTlJGZWtrakl2dWpRK0duV3VxRHpT?=
 =?utf-8?B?cUp3eFhFbCtEL0UvbHRmQUIvOVlhQ3pkUWo3VEhCclh4UTFJUmZ2UTRhb3p0?=
 =?utf-8?Q?DpKTMxDxTo/Oa2sG+eHcE1Skg5RCNyKmi4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 306e8c21-56b1-4ad4-12d0-08d8b9233cce
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1494.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 07:00:27.1865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 35QqshCRj0M7LD/9B5HeqKqdLPwt0ByU6jwNpa4OLfdHa+p4aySj6X0sgqjjh6n7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1144
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/12/21 8:01 AM, Paolo Bonzini wrote:
> On 12/01/21 07:37, Wei Huang wrote:
>>   static int gp_interception(struct vcpu_svm *svm)
>>   {
>>       struct kvm_vcpu *vcpu = &svm->vcpu;
>>       u32 error_code = svm->vmcb->control.exit_info_1;
>> -
>> -    WARN_ON_ONCE(!enable_vmware_backdoor);
>> +    int rc;
>>         /*
>> -     * VMware backdoor emulation on #GP interception only handles IN{S},
>> -     * OUT{S}, and RDPMC, none of which generate a non-zero error code.
>> +     * Only VMware backdoor and SVM VME errata are handled. Neither of
>> +     * them has non-zero error codes.
>>        */
>>       if (error_code) {
>>           kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
>>           return 1;
>>       }
>> -    return kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE_GP);
>> +
>> +    rc = kvm_emulate_instruction(vcpu, EMULTYPE_PARAVIRT_GP);
>> +    if (rc > 1)
>> +        rc = svm_emulate_vm_instr(vcpu, rc);
>> +    return rc;
>>   }
>>   
> 
> Passing back the third byte is quick hacky.  Instead of this change to
> kvm_emulate_instruction, I'd rather check the instruction bytes in
> gp_interception before calling kvm_emulate_instruction.  That would be
> something like:
> 
> - move "kvm_clear_exception_queue(vcpu);" inside the "if
> (!(emulation_type & EMULTYPE_NO_DECODE))".  It doesn't apply when you
> are coming back from userspace.
> 
> - extract the "if (!(emulation_type & EMULTYPE_NO_DECODE))" body to a
> new function x86_emulate_decoded_instruction.  Call it from
> gp_interception, we know this is not a pagefault and therefore
> vcpu->arch.write_fault_to_shadow_pgtable must be false.

If the whole body inside if-statement is moved out, do you expect the
interface of x86_emulate_decoded_instruction to be something like:

int x86_emulate_decoded_instruction(struct kvm_vcpu *vcpu,
                                    gpa_t cr2_or_gpa,
                                    int emulation_type, void *insn,
                                    int insn_len,
                                    bool write_fault_to_spt)

And if so, what is the emulation type to use when calling this function
from svm.c? EMULTYPE_VMWARE_GP?

> 
> - check ctxt->insn_bytes for an SVM instruction
> 
> - if not an SVM instruction, call kvm_emulate_instruction(vcpu,
> EMULTYPE_VMWARE_GP|EMULTYPE_NO_DECODE).
> 
> Thanks,
> 
> Paolo
> 
