Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6CB5B7B97
	for <lists+kvm@lfdr.de>; Tue, 13 Sep 2022 21:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiIMTws (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Sep 2022 15:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiIMTwq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Sep 2022 15:52:46 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC45F6BCEE;
        Tue, 13 Sep 2022 12:52:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CzuxAHDTTu4EKGcuYVnbQA6KuqS2fdadHk9te4Nah0PlcMv+sszLERxY7JDZjvbF0aavdhGC6Pz05l3uJd9GpwotG4ZKOqc72OJu3tPw8RX81N9pG/IUERqWcaVNdhm0kMEjjXOr94IxRkoDqnOLvLzVrcv1sLtGHRWJvyC09AEjFzxMMRc6aJxN090gbGmLyfYWuRow+eje+z2TKcMys/LvhN+BMvXLA2OStOtMYlusatW+crhZOgxIdJU09jqlVxjma9vWhiPNGZqjWhhnNWTh3XC7e5gsxdxwpdoUSBY4HOGE6JE0Ltihc15M81oGIx8/s4mvZuxcrJEMiyJfWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ded+tbl+XkSZPOng5mMQXZCUbBtHAVWDwv+iYhhbo1w=;
 b=XdHvh73ZmkU+PTKC1IQxUIg7tEcaHADbcNZ6pEpAELWGjblVXVKiGMOcumqpM5PtdH4gNMxsZyCd3KQkMO2c9x3qmY/o8G787EC2gge9d2TqgF+cxELzRlo6Lv/+iAFalkG41Bh0Y/umye5do3ozguDyANQZR80DHUK3QxKlCid3Lr9C1NRY4AHs5kaBOFqzqJTe34XA+we6oUdGZA1ghNluj/MDDfps78LGSJpBBstL07+aAC0xiAnQbyuRHRRAsFz5o281ILcoJ2dZnRbw/tUTl2mcJHo7n3NVpnMJUMbkoJApfDJPYSZswPa7AD37pL7g9Foa0ILLpqG5RSZuVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ded+tbl+XkSZPOng5mMQXZCUbBtHAVWDwv+iYhhbo1w=;
 b=wPI2x64cB5+J4nu1wK/7DWRvYepMJLrZBsK78StaPin9bFLJ+VK0ysvfneaygd5YqQ1MSgd/E2FTLIseivg/saa2PjlGMt8XrfHNMBUT2wGYgZa6b/P9PVVNeDKn8r6yRvC1USejmp9MflJ/wTZuh1EASAGm+eb80klEbFBNe7w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 MW3PR12MB4490.namprd12.prod.outlook.com (2603:10b6:303:2f::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.14; Tue, 13 Sep 2022 19:52:43 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::2cdd:defc:a6d3:7599]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::2cdd:defc:a6d3:7599%3]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 19:52:43 +0000
Message-ID: <b6fcb487-56fc-12ea-6f67-b14b0b156ee0@amd.com>
Date:   Tue, 13 Sep 2022 14:52:40 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v2 04/23] KVM: x86: Inhibit AVIC SPTEs if any vCPU enables
 x2APIC
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
References: <20220903002254.2411750-1-seanjc@google.com>
 <20220903002254.2411750-5-seanjc@google.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <20220903002254.2411750-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0157.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::12) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5445:EE_|MW3PR12MB4490:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cece9d0-1d79-43eb-ad4f-08da95c185a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0+QC7N6y8eETunWamGV8zEN0IaDAkBFGytFvMXUoli8D4+d6LiKqjSyrHciyIl/aphNGGmLASw+Mn+hSZYnL/ZeFEGHqBu/vCLFhmwf9DpiN9SSADUkSd22DsmmzW8sZIwuTnJK5kNEVZlX9Q3YW2sTbSR6BcBsgNl0KdOgluovUreyLii2WaitCa+7RrBcrnIf3GiJ36YF0+Sau7LgnbpsSJakglkEShtUOAMt9PAkUpVvPsXhIxFIev446hf/Wnlb5K4PaZldRcfn/fIbDAT50ElsE8EiOPA5ddpMfGQw6ZoQOFvNNQ3lsFqDaSTx5/lcdxkt8Ic4EpUiDZduVGe9tObaTSiQeLr33i6qnOE5hvJu3E1VT641k2eW/nUaRIdARyp6OP+gyItZ63GNeLcQCPZy0eCb1BNXZV4IrdQGV0UN/KkVRxLX+AT1H07ODxQ/7rQxp/6/wsd8gei+AQQjcSFrluD0TQ+RPXYAcKt6EO4eFQ7uOzpB6pO77XyQpjGbcWuMjG6AYPNCgy2wizpilKnnl5flSa9V5YHg2qAqASEBXlL8vj7ZZSeLdf9gYwLNhYxsR/jGVDMDqXQKZBCaUZIt3wO/6mt/9XcGV8GwmU0aUULJlDXfqKUvjOj2kEanZ625TQ1a6IKrvPp1uFf6/KAoKOIhLnA1HxQXo47YkMo2rw07dlCQr51L7knljTSoh6lirxWKvMLKr3xvRmQMOkbzn0c47EalZ2kGPpgzgevFwC4MCnV97ujjn0S0ALIVIUl+Xdi0Quk+AgqL67BVazZBKVtrJsOxXbTAYkBxX9SAWkCsmvZw1PNDHHQPlPAHLhdnHmsymd5LHDvs+Rw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(366004)(39860400002)(136003)(396003)(451199015)(66946007)(110136005)(26005)(316002)(54906003)(6506007)(36756003)(31686004)(6512007)(38100700002)(5660300002)(8936002)(8676002)(4326008)(2906002)(31696002)(86362001)(66476007)(83380400001)(6486002)(53546011)(186003)(66556008)(478600001)(41300700001)(2616005)(45980500001)(43740500002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R1ZsTFRjRXpwaEVoMW1leUlxVmtKVjVoT3RVMjhzZG11Um9HR2VkN090eDh1?=
 =?utf-8?B?TWNoVlprYWRwc2VBSFp6cFVadE02RWNTNGxES1VtN3NHNTJWOTZNdTlzRFc4?=
 =?utf-8?B?YWFSRHRzYzNSYjA3NjlUeXhURjN1c0hKNzAzd0lHeUdnakZPTmhlZzhKZ2FJ?=
 =?utf-8?B?Rmw3c3A0YlV4TWkranZnem9JVjZ1bmNLZ0Q1Lzk1YTR2U1Ara25KSEZvN1BE?=
 =?utf-8?B?RDBvaXMzdnR0Q1cwYWlreXpNSFVUYjBVYkcwS0RMUkROeUdONWoyd0h3dFhP?=
 =?utf-8?B?b01sd2pmZWdjSStIcEdNRkhCN3JkOWdhY1IwMS83SHM2RTVrSGVtVHBZZ2l4?=
 =?utf-8?B?NzdhS25aTVdCZ0tFQVpscTRPMXRqRXJlcWJvV0h2YXhSVVFHTVZ4bTJFUkhx?=
 =?utf-8?B?TjQ5bklsUW9tTHlrWXdXd1R4dyt6Uy9YUFJHelE4cHJzazZtQTJJeDhaSDJ2?=
 =?utf-8?B?L2xlQy9KYlVoZHdaT0Y4SEtZMGFCKyszUUwzSHVBRm4wZ2dtSnB0YnhMcVBO?=
 =?utf-8?B?TTNHVEhyWHRUSlpOOEJTcHhlanZJK1RCVCtaZVQ4b2c3MXg1VXVCUC84a1pw?=
 =?utf-8?B?QnpWaThSRmozc0RQRGhsb1dISUVLbnhaelg4cENEVjhpNjEvZHNDb1BwRzBI?=
 =?utf-8?B?ZmhnUXlPYWI5b3JkbVREekx0RENBZjVkeXFZaXVIRXpDTldvc05mdlA2YW9V?=
 =?utf-8?B?ZGdYK2YrQjIwY1dneVo5SmVsa2JhWkF5RE5pU2hHZEhBUEhCUUIxR1hzSnFL?=
 =?utf-8?B?VWljV0NTTWVzdmJKZ0JOWmVSSktHcmZtbTN1bnRsQXJYYUVZS0VnbkowdlRq?=
 =?utf-8?B?YVNvM0pteDl0SHV6djBRZExaclVqUldVMXZQRzZ4Ym9mT0NndlQ0cm04WUdL?=
 =?utf-8?B?WHZKbURIdmRodWNSZXU0MkpvcU5oWWxFTjZBSDBUcENoSXc0Y042dVVudzJH?=
 =?utf-8?B?MUpxR2JuTXZsWDZ1TWk1WmsyNUtrcFVtR1VwdE9udWx1YzlqNHE5eXNnTFJG?=
 =?utf-8?B?UVMyWkp1SERnTmFycnUyWjlHZkgzYjFDN2ZKaHFITk9ZaVlPZlpDajA5aWsr?=
 =?utf-8?B?RzFOTjd5OHNwWlJ4cGpEVktMd3JVUGFkdDVncFRRMU0rOEVPMXU4UTB1RTI5?=
 =?utf-8?B?c1Y0cG1wTU1FSXdYNExEd05LUFprYmxiTS9uTXMyTkMrSGQ4Q2RCUHQ5UTJ4?=
 =?utf-8?B?M1Z3Z3pNWURGMHphL0NNRTg0dkQrQjg5OGhUSEwyRlJ6WHJIT3l1ZDUrMW41?=
 =?utf-8?B?cHJoQUdaM2NocjBpNG1rSGVUWmFuLzV3cnNmVk5DWXkvUFZOYnVhYTA4WDJX?=
 =?utf-8?B?K0kvV1lERlFwbEVVQSthNGovdUVoMFFuaU9XbVFNRFJoYUJtbldSSVRmVklw?=
 =?utf-8?B?all2a1V3OFgvM0FjenI1MGxhc0pMTjVFbm53U004NFJ5bGJLbDBmZ3V3SlRU?=
 =?utf-8?B?a2loWGNxWnAzK2c3V012NHhZSm9QdU9wdjNoZk5PeHdDYW9naC9aUGVmNDZL?=
 =?utf-8?B?UGZkSXNaZHJXa1NLaHZYb3kwRktIZWcxTTk0YTFrR1ZrbzFpa2tDRTk0KzE3?=
 =?utf-8?B?eHBteXh4NlZKbTJubDhiMWNNQWdaZXoyNnNVdVdqd2hrMFRHaWlQY01DWVFm?=
 =?utf-8?B?KzFwQUZ3K1Y1Q1BCU1pVRlRJaHZCcFJVYUpVRFZ3a3BCaG5yV3NwTzNOelBU?=
 =?utf-8?B?ZUduNVNWblVzRlFFc1VKRFhFK0VRUHJ4WEJra3YvOHRIdWRCSHBDK2FNSXp3?=
 =?utf-8?B?dG90V0gxZkxjSXZ3TnFUYnBiMmkyN0tvUm4zRHBnd2FVM1BIYytvNURhSENX?=
 =?utf-8?B?VzVsVVRkMWg2Umt4TWdrUUszTWFhTGhDamg1S1pFMC9CM3dyemlqVlViQ1V0?=
 =?utf-8?B?d3pCRTBUYzV3TDdRbERaK2VLdmJVUGJjcHY2V3hnTlA4ODBMRHlFSXdCS3RY?=
 =?utf-8?B?Nm4xWXNKWERPL1NSRjA5ZWE3OHBJTnhiS3BxU3ZDWldvZHpldkN0RFJuUkxH?=
 =?utf-8?B?YUVTV0lIUTBDd0tvdE1iOU12eUg1cWMwaDQyQTNWVjcyQ1o3eDUwWC9QMkpi?=
 =?utf-8?B?cVRUNGJLU2RHTS8wYnI2ZUpnOXR3eVVLekdLdC95QzRHaENRdTdJWnhVS1Zs?=
 =?utf-8?Q?M/7e6Jc4FISgIePeT7w0Zw6im?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cece9d0-1d79-43eb-ad4f-08da95c185a1
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2022 19:52:43.1882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OeDLosJsAmg9C/CwQobhjX49sIi1m7+fLz/vaUDUDq07pJyeza9jLOqjjq3fow2ARnBLjUjhO2U8llOhAkA9gQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4490
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean,

This patch inhibits VM running in x2APIC mode on system w/ x2AVIC support.

On 9/2/2022 7:22 PM, Sean Christopherson wrote:
> Reintroduce APICV_INHIBIT_REASON_X2APIC as a "partial" inhibit for AMD
> to fix a bug where the APIC access page is visible to vCPUs that have
> x2APIC enabled, i.e. shouldn't be able to "see" the xAPIC MMIO region.
> 
> On AMD, due to its "hybrid" mode where AVIC is enabled when x2APIC is
> enabled even without x2AVIC support, the bug occurs any time AVIC is
> enabled as x2APIC is fully emulated by KVM.  I.e. hardware isn't aware
> that the guest is operating in x2APIC mode.
> 
> Opportunistically drop the "can" while updating avic_activate_vmcb()'s
> comment, i.e. to state that KVM _does_ support the hybrid mode.  Move
> the "Note:" down a line to conform to preferred kernel/KVM multi-line
> comment style.
> 
> Leave Intel as-is for now to avoid a subtle performance regression, even
> though Intel likely suffers from the same bug.  On Intel, in theory the
> bug rears its head only when vCPUs share host page tables (extremely
> likely) and x2APIC enabling is not consistent within the guest, i.e. if
> some vCPUs have x2APIC enabled and other does do not (unlikely to occur
> except in certain situations, e.g. bringing up APs).
> 
> Fixes: 0e311d33bfbe ("KVM: SVM: Introduce hybrid-AVIC mode")
> Cc: stable@vger.kernel.org
> Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 10 ++++++++++
>   arch/x86/kvm/lapic.c            |  4 +++-
>   arch/x86/kvm/mmu/mmu.c          |  2 +-
>   arch/x86/kvm/svm/avic.c         | 15 +++++++-------
>   arch/x86/kvm/x86.c              | 35 +++++++++++++++++++++++++++++----
>   5 files changed, 53 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 2c96c43c313a..1fd1b66ceeb6 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1132,6 +1132,15 @@ enum kvm_apicv_inhibit {
>   	 * AVIC is disabled because SEV doesn't support it.
>   	 */
>   	APICV_INHIBIT_REASON_SEV,
> +
> +	/*
> +	 * Due to sharing page tables across vCPUs, the xAPIC memslot must be
> +	 * inhibited if any vCPU has x2APIC enabled.  Note, this is a "partial"
> +	 * inhibit; APICv can still be activated, but KVM mustn't retain/create
> +	 * SPTEs for the APIC access page.  Like the APIC ID and APIC base
> +	 * inhibits, this is sticky for simplicity.
> +	 */
> +	APICV_INHIBIT_REASON_X2APIC,

Actually, shouldn't the APICV_INHIBIT_REASON_X2APIC is set only when 
vCPU has x2APIC enabled on the system with _NO x2AVIC support_ ? For 
example, .....

>   };
>   
>   struct kvm_arch {
> @@ -1903,6 +1912,7 @@ gpa_t kvm_mmu_gva_to_gpa_write(struct kvm_vcpu *vcpu, gva_t gva,
>   gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu, gva_t gva,
>   				struct x86_exception *exception);
>   
> +bool kvm_apicv_memslot_activated(struct kvm *kvm);
>   bool kvm_apicv_activated(struct kvm *kvm);
>   bool kvm_vcpu_apicv_activated(struct kvm_vcpu *vcpu);
>   void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 38e9b8e5278c..d956cd37908e 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2394,8 +2394,10 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
>   		}
>   	}
>   
> -	if (((old_value ^ value) & X2APIC_ENABLE) && (value & X2APIC_ENABLE))
> +	if (((old_value ^ value) & X2APIC_ENABLE) && (value & X2APIC_ENABLE)) {
>   		kvm_apic_set_x2apic_id(apic, vcpu->vcpu_id);
> +		kvm_set_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_X2APIC);
> +	}

.... Here, since we do not want to inhibit APICV/AVIC on system that can 
support x2AVIC, this should be set in the vendor-specific call-back 
function, where appropriate checks can be made.

>   
>   	if ((old_value ^ value) & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE)) {
>   		kvm_vcpu_update_apicv(vcpu);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e418ef3ecfcb..cea25552869f 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4150,7 +4150,7 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>   		 * when the AVIC is re-enabled.
>   		 */
>   		if (slot && slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT &&
> -		    !kvm_apicv_activated(vcpu->kvm))
> +		    !kvm_apicv_memslot_activated(vcpu->kvm))
>   			return RET_PF_EMULATE;
>   	}
>   
> ....
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d7374d768296..6ab9088c2531 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9379,15 +9379,29 @@ static void kvm_pv_kick_cpu_op(struct kvm *kvm, int apicid)
>   	kvm_irq_delivery_to_apic(kvm, NULL, &lapic_irq, NULL);
>   }
>   
> -bool kvm_apicv_activated(struct kvm *kvm)
> +bool kvm_apicv_memslot_activated(struct kvm *kvm)
>   {
>   	return (READ_ONCE(kvm->arch.apicv_inhibit_reasons) == 0);
>   }
> +
> +static unsigned long kvm_apicv_get_inhibit_reasons(struct kvm *kvm)
> +{
> +	/*
> +	 * x2APIC only needs to "inhibit" the MMIO region, all other aspects of
> +	 * APICv can continue to be utilized.
> +	 */
> +	return READ_ONCE(kvm->arch.apicv_inhibit_reasons) & ~APICV_INHIBIT_REASON_X2APIC;
> +}
> +
> +bool kvm_apicv_activated(struct kvm *kvm)
> +{
> +	return !kvm_apicv_get_inhibit_reasons(kvm);
> +}
>   EXPORT_SYMBOL_GPL(kvm_apicv_activated);
>   
>   bool kvm_vcpu_apicv_activated(struct kvm_vcpu *vcpu)
>   {
> -	ulong vm_reasons = READ_ONCE(vcpu->kvm->arch.apicv_inhibit_reasons);
> +	ulong vm_reasons = kvm_apicv_get_inhibit_reasons(vcpu->kvm);
>   	ulong vcpu_reasons = static_call(kvm_x86_vcpu_get_apicv_inhibit_reasons)(vcpu);
>   
>   	return (vm_reasons | vcpu_reasons) == 0;
> @@ -10122,7 +10136,15 @@ void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
>   
>   	set_or_clear_apicv_inhibit(&new, reason, set);
>   
> -	if (!!old != !!new) {
> +	/*
> +	 * If the overall "is APICv activated" status is unchanged, simply add
> +	 * or remove the inihbit from the pile.  x2APIC is an exception, as it
> +	 * is a partial inhibit (only blocks SPTEs for the APIC access page).
> +	 * If x2APIC is the only inhibit in either the old or the new set, then
> +	 * vCPUs need to be kicked to transition between partially-inhibited
> +	 * and fully-inhibited.
> +	 */
> +	if ((!!old != !!new) || old == X2APIC_ENABLE || new == X2APIC_ENABLE) {

Why are we comparing APICV inhibit reasons (old, new) with X2APIC_ENABLE 
here? Do you mean to compare with APICV_INHIBIT_REASON_X2APIC?

Thanks,
Suravee

>   		/*
>   		 * Kick all vCPUs before setting apicv_inhibit_reasons to avoid
>   		 * false positives in the sanity check WARN in svm_vcpu_run().
> @@ -10137,7 +10159,12 @@ void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
>   		 */
>   		kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_UPDATE);
>   		kvm->arch.apicv_inhibit_reasons = new;
> -		if (new) {
> +
> +		/*
> +		 * Zap SPTEs for the APIC access page if APICv is newly
> +		 * inhibited (partially or fully).
> +		 */
> +		if (new && !old) {
>   			unsigned long gfn = gpa_to_gfn(APIC_DEFAULT_PHYS_BASE);
>   			kvm_zap_gfn_range(kvm, gfn, gfn+1);
>   		}
