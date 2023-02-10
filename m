Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D76E2691ECD
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 13:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbjBJMDT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 07:03:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbjBJMDR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 07:03:17 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2064.outbound.protection.outlook.com [40.107.100.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D8411A;
        Fri, 10 Feb 2023 04:03:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MYtI8MvMfCW0zmWyzjhxZaSEAiGvoD2KhHqGPbQabgXofJGcJ07A0Hkd1UK9SBDOj4j0rODdG/MI4/gI3E0GpfIkcyZ4Ytt9HV5HH1W77wIIJWwSerZ+9abO1QJ4J6Ze5JEm891M+o42ZVgI+hbWzqEsRuCepmo7ajSuvqFcXqYSqdj5quk90kbeBJ63bOOYx5pGpE/Y707i75EJ3aA99DlRBtCx/m2ZKS197PK7Lc0DsJhJoJdG1litSRzKw0mfGw84AOcZycakeTayBJYCG0HIe/GEQasiotQcMBC54XZAHb9ueZsSzIrVnhweIbjarWjCv76DcxpQSuWDFi0wfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jLgNH4uXulDMKUFGMamAT9KL08sDZOkaJvuiLAGvRl0=;
 b=AzqMRJSvH+GzVncb1cip1+mRV7DgY0LlFGpphu3tDS/dMK2t6KtYd9pE//htkK+l4q17GfKa5jIhBnPhqNB7SNcpAnj0pnKKrWgZve4P9CGdpyLqwxJEcesqBTudrBQ45S8V8pR6bBztozWtJ/xKr7Z7oI/cnSXVsf6gU/CzExNZkV8F6RkNGgnoRy+CRbZd4H1V/G97Przhf30Y4+58oyN6NS3bPiCF+YDpO/Q/nBCivJj6ScQLlJ0Qvz3fSg4QdNukJj8osklI6Trm3AICMiAvdbdxX59i9Rcl9Zf000ZyPh16O2hua3EmljLjYbev6rXQfsXyrz9Otoy7DyQ4aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jLgNH4uXulDMKUFGMamAT9KL08sDZOkaJvuiLAGvRl0=;
 b=T/I73PFWf6aUwNyHxXY8a0NNIGUIaVLyCAMhRQTqooJk3acviFnkitIMqDCkNIgDA4dnHYuT/9hEAG/fNa5Qoiyerg8jeHCFzP1OiHdODPTfUkxfIrKAVkwpmtJ50LZz0z5hJajoF7sAtrhvZRauYRheP1rClBoDd17EOYnNdVw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB6305.namprd12.prod.outlook.com (2603:10b6:208:3e7::16)
 by BY5PR12MB4051.namprd12.prod.outlook.com (2603:10b6:a03:20c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 12:03:10 +0000
Received: from IA1PR12MB6305.namprd12.prod.outlook.com
 ([fe80::1eac:a719:2b3c:b4c1]) by IA1PR12MB6305.namprd12.prod.outlook.com
 ([fe80::1eac:a719:2b3c:b4c1%7]) with mapi id 15.20.6064.036; Fri, 10 Feb 2023
 12:03:10 +0000
Message-ID: <6f7fec84-1915-4499-104d-d29bf78270b5@amd.com>
Date:   Fri, 10 Feb 2023 17:32:55 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 10/11] KVM: SVM: implement support for vNMI
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Santosh Shukla <santosh.shukla@amd.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
 <20221129193717.513824-11-mlevitsk@redhat.com> <Y9R1+hPaTWcEZMOX@google.com>
Content-Language: en-US
From:   Santosh Shukla <santosh.shukla@amd.com>
In-Reply-To: <Y9R1+hPaTWcEZMOX@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0053.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ac::8) To IA1PR12MB6305.namprd12.prod.outlook.com
 (2603:10b6:208:3e7::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB6305:EE_|BY5PR12MB4051:EE_
X-MS-Office365-Filtering-Correlation-Id: 0abbf29a-9ffb-46af-97c3-08db0b5ec74b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XNafJ/cXdZLzkIi1dJiK5cwX+HgN9MNDeCgSvWJdhsXBMt6tToCmlIai7DfFM8A7Humi6kqFyr55PL6TbjU+jJevoeFOIPyAevTRahppqgJmoXjq8uU0IDHy5m0AheR7/A2TF7ZV1L8t5WZEO3+Y9+LQk5mJy7itt6yYZOhrg4kno1nOrchhWRP9WxJMFBYkxVv6v2gdNkhx8jDQvN2y8k2Nokv+82at1g4lQIDhIl56RJZv5LXBqCzTdGfNqsxTOOd5cF4XZ1B06Nte2pq8BjNL0yS15/Gtf3HDM3d6FypeJZMss72BaLJmmagkVy5yDMjAptkEyPvgkfvo2HZ+madXCfXmm+Ob74yICt+wdYs7f0qh8L4InKguJ/6vgP46MzY3b8qOiFeO7Kjyx41l9F8ohMxU84U98zVnoyfPNM2cU4PioHwjJo87lWh+SIq8ny7+XJoEmVLZDeLK/7HZ0r7/wEN/nQmyRDxHOGHXwarv+T5gqSEbnG6hvVORDAgsq4+3HDElG+FHSpdP5Wc5mPKxfW9BO5byAduLXw6P9tv1GZNNUpzqnrLaFWt+WC4LWe30IC4ZwZh0qZtMkMvp+cbGnGcx9f9U6cmcMFJXrKWwk4Axg1s0XxkAkcuHxQdD52FDeloLRiUO0JFzVuIACJObJ+Z/4Vue7aXrKJBJv4+rU7DFIj6ib5UIbMhFSMcKZXB35ih1GamLlwWKoCIAeyUuRMV+8bCEwTB7bQV/iWw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6305.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(376002)(346002)(136003)(39860400002)(451199018)(5660300002)(26005)(7416002)(86362001)(186003)(31696002)(8936002)(2616005)(38100700002)(83380400001)(6512007)(41300700001)(54906003)(110136005)(66946007)(4326008)(316002)(66476007)(8676002)(66556008)(6506007)(53546011)(6666004)(478600001)(55236004)(6486002)(36756003)(31686004)(44832011)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d1RwNHdMWmh3WEhYdWtINzFlYzRJRCtOMGVaRTZ3YWk4dUxRVmU4TnJlYUwz?=
 =?utf-8?B?bnFoVEx2em5LcHFiTTBKZ1dEUENnU2lBdE1QaU5sU1hobnVsMkRVR3JZNWM3?=
 =?utf-8?B?eDFjeHZ6Umg2L2xOSlJ1QWhPT2pjNmtoaEliTXdhRWo5akEyMS9Qb284WU1T?=
 =?utf-8?B?THdsNzJ4Zld3UkhRblMwTUptZWF0S3U2akNMSnlFSGtnRVM0bmdBRFBRUEZR?=
 =?utf-8?B?enZqUTduMnZQRlBRMmpWU0h6SzVvN1pZZFdRVHF1N3NERzFKelRSNk9HMzI0?=
 =?utf-8?B?dDZ4eGtWWlc1ZG8wN09LeGQxSnlLcWx2V1NkcU83TkNPSkY5bGl1bkZlWjY3?=
 =?utf-8?B?T0x4aTZITjNCai9aaWpZMnpEMldjR3A4N1ZBV2QxOCtSN1ZxOEd5TzNCc09U?=
 =?utf-8?B?Z1pEVC91ZzFqbVlqRXZPcmVudG5QWXJmMFJQMU9BamxsZldzTlBGUXVzdmJ2?=
 =?utf-8?B?WkRzemNneWhlbUxWTmZ1Szd0UjI0SEsvNjFidng5ajJQWnlSVmFLNzJRWHZW?=
 =?utf-8?B?eVJabjV3Qnc4MmpGZDdQM3k2ZW5FcUovSm85TEpPS00wajdyRjR3d3Q4aGRo?=
 =?utf-8?B?Ymd3ek8xL0MxWWduc251ZkRMclhTMTNxL1VrSURYanFBOUJ2aDNJUEk4c1Jn?=
 =?utf-8?B?VitJK3NzZ0JzYlVLelFFMXJ0ekRkU1ZoWjZtdHFZdmJZQ3Y1RjJHb1U0SGdM?=
 =?utf-8?B?SlF2LzV6NjZHSlNaa3BvamFWS2UwS3dpMzI4czlHaEJZb3BYQ2dyS2o4am5X?=
 =?utf-8?B?MUFVUG5hN1lpamVOTGJPSFByOS92dWdhSWxDVnR3STVWMVptaU5VL0NrckY4?=
 =?utf-8?B?MkxvT3RGNVB4cTV6Q1FzUEJFMTVEYlNIS3pMZUZ4Slo5S05vUHExYldyYWMx?=
 =?utf-8?B?R0Fkd0Z4NkwxR1E0NVM0VEZVMU9YdXI5TkRjckJ6TjNDUUtXR2U2VCtZenhh?=
 =?utf-8?B?UjJFQTBxV2kvK2R4UDRjQWNoN3Y4TXFWTkRNS1VPc24rb0dJRnh2NVk3OHVX?=
 =?utf-8?B?cml1VU04ZE9TK0o4Y1pKNjNTdlhKT1QxTWszZHBnb0c4Z1VYY2NVYTlQZUx5?=
 =?utf-8?B?eG1tS0dSc1pvaktKWFEyOXZublhSKzExSlF3REtGcm1Ra0YwNXllcXVBR1BV?=
 =?utf-8?B?UUM1Vkh6THg5OTc1L20yRUVaTUllbWZ1MVhxbnMrV1hHaXI5NVpvbno3ZytG?=
 =?utf-8?B?ZDJicTdUZHBqU1BLemphMEVvOERIWlBlWUF1ZkRMT1d3NnBiZVdVa0xLcmgx?=
 =?utf-8?B?bjhPNnl4em9UcE9lWFBNcjJSZkhQeGg3NWhMTDBhUmR6dGpxOHdjS2ExY2pn?=
 =?utf-8?B?RXZQSit2NXFrQitaUjI2Y05HM3hneFQ2QXQ5dGFqZ1pQVi9KR0ZYQXBqNU1k?=
 =?utf-8?B?NlBSQzNjaHoyOHZqWXlRbFRrUlp2U0wrdlhqZVQrUTRwUkk5MktDbDBIc1BI?=
 =?utf-8?B?bm9LYVdyZ3g4czMzQlVhY1A5akJlNWM0THlpdzF3QkpzR2VLbzVaNlZIL0h5?=
 =?utf-8?B?THU4Q3pBWnh2WTE5THBybGRoblNvSWNZT3pHRXM0TU92R0ltM1YxYkkrNmZE?=
 =?utf-8?B?MGdxUmpaZ21DMTdWcFpXNjV3UWdQTEVOUnVCN1NmOE9QelBYQnkzcG4yS01h?=
 =?utf-8?B?UUhHbkx5Um4zejkzOStqMUpkbUo2citvSCt6S0NLeXZvYTRjNFkrTE0zVXg0?=
 =?utf-8?B?VjcxQXY2TTJGejR5TzJUajVqOTZmamFIZmFjZUJRajVzMFdkamZBVVQ3dUFk?=
 =?utf-8?B?SDVCVlRVNlFQZ2h3SmkzWGxTeU9lbzdWQzlnQmt1a1M3NnRYbGc2aW1UZmlz?=
 =?utf-8?B?WG5BdUU5NzB5dXZGdE5KSmxYYXhHNzRucVNvUEVSRll6YUJ4Vm5TZ3BobEpL?=
 =?utf-8?B?TmZxUm9Fc2dlcHNwY2pkcWdWODNkQTRSMjlOY0ZxN0xrK3kxQi83MTVVZURZ?=
 =?utf-8?B?dXVWWU9JblB2VHJRSVg4cUtxSHc0V09ZU3Z4NlV3TGV5a2w0TXg2Y3NuSWYv?=
 =?utf-8?B?SjVBUU5YekdmZFltTzFPV0lJcEZmYThsS3VSbmxrU1o5bnorS3pobDYzTWFk?=
 =?utf-8?B?RUh3TGxtd0tsSDFiOEJyT0ZqZXpOa005L3F4Q2ErL2ZhdVByUVJoRXRxZ25T?=
 =?utf-8?Q?7+h0GsYrGl1n4WG4K7sh+0itu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0abbf29a-9ffb-46af-97c3-08db0b5ec74b
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6305.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 12:03:10.5704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Kivtw4Tr43LzlMNcwXIBdWg1PCfrBogkt0PvkTLuBwXr56SPKUgbTcxUiuD3oQtZQrzBxNNxHrLNQTLkHtt2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4051
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/28/2023 6:40 AM, Sean Christopherson wrote:
> On Tue, Nov 29, 2022, Maxim Levitsky wrote:
>> This patch implements support for injecting pending
>> NMIs via the .kvm_x86_set_hw_nmi_pending using new AMD's vNMI
>> feature.
>>
>> Note that the vNMI can't cause a VM exit, which is needed
>> when a nested guest intercepts NMIs.
>>
>> Therefore to avoid breaking nesting, the vNMI is inhibited while
>> a nested guest is running and instead, the legacy NMI window
>> detection and delivery method is used.
>>
>> While it is possible to passthrough the vNMI if a nested guest
>> doesn't intercept NMIs, such usage is very uncommon, and it's
>> not worth to optimize for.
>>
>> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
>> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
>> ---
>>  arch/x86/kvm/svm/nested.c |  42 +++++++++++++++
>>  arch/x86/kvm/svm/svm.c    | 111 ++++++++++++++++++++++++++++++--------
>>  arch/x86/kvm/svm/svm.h    |  10 ++++
>>  3 files changed, 140 insertions(+), 23 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
>> index e891318595113e..5bea672bf8b12d 100644
>> --- a/arch/x86/kvm/svm/nested.c
>> +++ b/arch/x86/kvm/svm/nested.c
>> @@ -623,6 +623,42 @@ static bool is_evtinj_nmi(u32 evtinj)
>>  	return type == SVM_EVTINJ_TYPE_NMI;
>>  }
>>  
>> +static void nested_svm_save_vnmi(struct vcpu_svm *svm)
>> +{
>> +	struct vmcb *vmcb01 = svm->vmcb01.ptr;
>> +
>> +	/*
>> +	 * Copy the vNMI state back to software NMI tracking state
>> +	 * for the duration of the nested run
>> +	 */
>> +
> 
> Unecessary newline.
> 
ok.

>> +	svm->nmi_masked = vmcb01->control.int_ctl & V_NMI_MASK;
>> +	svm->vcpu.arch.nmi_pending += vmcb01->control.int_ctl & V_NMI_PENDING;
>> +}
>> +
>> +static void nested_svm_restore_vnmi(struct vcpu_svm *svm)
>> +{
>> +	struct kvm_vcpu *vcpu = &svm->vcpu;
>> +	struct vmcb *vmcb01 = svm->vmcb01.ptr;
>> +
>> +	/*
>> +	 * Restore the vNMI state from the software NMI tracking state
>> +	 * after a nested run
>> +	 */
>> +
> 
> Unnecessary newline.
>

ok.
 
>> +	if (svm->nmi_masked)
>> +		vmcb01->control.int_ctl |= V_NMI_MASK;
>> +	else
>> +		vmcb01->control.int_ctl &= ~V_NMI_MASK;
>> +
>> +	if (vcpu->arch.nmi_pending) {
>> +		vcpu->arch.nmi_pending--;
>> +		vmcb01->control.int_ctl |= V_NMI_PENDING;
>> +	} else
>> +		vmcb01->control.int_ctl &= ~V_NMI_PENDING;
> 
> Needs curly braces.
> 
Yes.

Thanks,
Santosh
