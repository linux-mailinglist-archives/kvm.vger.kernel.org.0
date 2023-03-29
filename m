Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70D2C6CD1F1
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 08:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbjC2GLq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 02:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjC2GLp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 02:11:45 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2064.outbound.protection.outlook.com [40.107.93.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18BA42705;
        Tue, 28 Mar 2023 23:11:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YEIywvIRBA8a4Pw+RbH/z285Oh5JvJghRjUkKcTvUIneF8glHGKo4WPj0WbAfJBRPGcZMhokiNEUJbJQ0CldjHx8N+YLopPxqS4Z55sMrekmyH4a4dZ+35bYg8gfka6VaMBYYufxhi2oWMcwY2weGiIB19yOBQzoG0EhNEDLy6dk+9JMQ6gMIwgqgpGVsIxfaO18Q6gTwcOw5GO7C2kaiu0dYJpk8l+w+KMq+0OwmTZqQ8Ze0AZlTweZDPJ8WWLyfdJqlZ4zFnFkUZPJ1oIj2JDnuWiD+D/3/AweLyxTXcAgNuhmIHqc5vSzuduwi5dTDKaldievpm6GV/njiGm1lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fBXOPDWvRKjsapnKwFWieqfN25sPpIK4Mk3MmrSWw9s=;
 b=SE9z9TQ0OKRFC34I0nbxOllLtK/DTn/L4MQ5Dcp8VAzXkKBfPb107RjxsZhFXJSUnotINZYSVtq0vG1+CPCmLOTm/90a1565DnY4mapks10j1mtO+EQnZTu2WK5jCZKi5V4QWdzZWNYZ3fJlPBgvJ4aEVadoixNscxKUBjQR/Rk5JNL95muZ3pHi5EG98/8r9PFuWdk78MCTMy7NwhvQSRzXJ8XQYWvXDChGKDVm2vdESl3ZCe9MxH2eWbuOVgwFqRADhTMcq966NnDEu9BZPA/zozZk1+8iUkuXCbkFKYdr5Xf4h1qh5U2YNE+Rg3pySszvlgB5iUDYQ7hL8N6obA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fBXOPDWvRKjsapnKwFWieqfN25sPpIK4Mk3MmrSWw9s=;
 b=p6g34ZfylY0sHshu3ossexgI1gmcOYXwl3l+8RBXV9VJCQBlLmmePpXrePktIvYzBXvj1Ml5oSVQWqOKI7Sb0U8+ypZl9rkQxI+Vs7btKsHTAa2yFVzfld9ljg7FAtz2GCbB4THM6jHv9zJH+CnXF1WCfKWbAwSl/YBJL3yzzt0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SJ1PR12MB6218.namprd12.prod.outlook.com (2603:10b6:a03:457::17)
 by MN0PR12MB6198.namprd12.prod.outlook.com (2603:10b6:208:3c5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Wed, 29 Mar
 2023 06:11:40 +0000
Received: from SJ1PR12MB6218.namprd12.prod.outlook.com
 ([fe80::bbe5:2fec:bec:c467]) by SJ1PR12MB6218.namprd12.prod.outlook.com
 ([fe80::bbe5:2fec:bec:c467%3]) with mapi id 15.20.6222.030; Wed, 29 Mar 2023
 06:11:40 +0000
Message-ID: <38601264-1957-579f-f156-c782bb9826cc@amd.com>
Date:   Wed, 29 Mar 2023 11:41:22 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [RFC PATCH kernel 2/2] KVM: SEV: PreventHostIBS enablement for
 SEV-ES and SNP guest
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        mingo@redhat.com, acme@kernel.org, jolsa@kernel.org,
        namhyung@kernel.org, tglx@linutronix.de, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com,
        jpoimboe@kernel.org, pawan.kumar.gupta@linux.intel.com,
        babu.moger@amd.com, sandipan.das@amd.com, jmattson@google.com,
        thomas.lendacky@amd.com, nikunj@amd.com, ravi.bangoria@amd.com,
        eranian@google.com, irogers@google.com, kvm@vger.kernel.org,
        x86@kernel.org, linux-perf-users@vger.kernel.org
References: <20230206060545.628502-1-manali.shukla@amd.com>
 <20230206060545.628502-3-manali.shukla@amd.com> <ZB4AOaLRwSB0ClIH@google.com>
From:   Manali Shukla <manali.shukla@amd.com>
In-Reply-To: <ZB4AOaLRwSB0ClIH@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXP287CA0007.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:2c::14) To SJ1PR12MB6218.namprd12.prod.outlook.com
 (2603:10b6:a03:457::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6218:EE_|MN0PR12MB6198:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f8ea423-c4eb-4fb4-b653-08db301c75d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ub69wI5GkMiDSN8Rvr1aEk4gmXZhxWQy8Hiw+D/pndIsGhq8RFgBNMuwNHRu0G3A6roz7rcY8uMJhN1cQqB/ztDM2Ig8aHCwcR/L5nbHuNLOxu/7Z3o8SE5PeFZ6+LHDTk/3nZU2cy4vvxQi4SjtT/nSgixBA2k0ywJDz/H6GF4urjYvxGo8pu8OPuZMpq19u9h1nZu6mKpKmZ0kIppLz0Tw5cylCo9TUOYk4rctROIiTSPI7oQEIS8Fqg+rsjWZEvEpuvMXV+czlkFUgl/JvTQQUxjepV+O2sWycRG+H5bu027iGR0tKXovL8Dr+RhnW16g5c9Xvh+g6FyQCTnHGaaFqtsO0Opyb4QU8H3T0LP4oTBdiKGDw5/oc4qqa6DS1q91OrL7VZ/gIbp1BLBM3+Z/i1vrMa2EpRuBNeZApqs9qstM2byPP3joLp9tEETsYuqcsM47iRwfjFAS7oMkXsrCiLgXxT+5thB1pzzi7CALm5LnHjQAPrBOoJExfHHCxE2UGH0XORf1YQcMI/27fVDdTqgwW52Lml0lkfOKTuNo1O5FfYPHJDyZPfCvNM4JxLj1DoSNNShUFA2piToaXPvBQaAbHoun7MU9ZUmKS+vxxr1kcv4cRVk3A/IxnRXBIDdnuJZwgW3BD4cS6tvr3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6218.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(136003)(376002)(346002)(366004)(451199021)(36756003)(31696002)(31686004)(86362001)(5660300002)(186003)(53546011)(2616005)(83380400001)(26005)(6506007)(6512007)(7416002)(44832011)(8936002)(6666004)(41300700001)(6486002)(4326008)(6916009)(8676002)(2906002)(38100700002)(66946007)(316002)(66476007)(66556008)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y2dMNVUwSnYvVFhNNGdsYUZreWhpZk04SGZ5akVDWE5oYlNpci9KZURvL0xn?=
 =?utf-8?B?WENGdGJCYjZUU2NJMTkreVhXZmh6a2had1NKSzhzQzRIc295NHpBdXpIc3hG?=
 =?utf-8?B?SmMvd3FBQnUvajVCYU5hSWxlbm90eGRuMTQ3ZEhLNDJqRmF5T09FUHU0RGRl?=
 =?utf-8?B?UlpyQVJZL2VwZ2NHcWM3STNvYXJRSlZZZWE5clZNWFkzc3hSSGlFR1FURkR6?=
 =?utf-8?B?S1Vad2taUWRmRXlIRXZJV04vcGNrNENEMFhUNnNrSU9JVGJWc2orVXQ3ZFdH?=
 =?utf-8?B?VElYQ2RKQXhlTFNad2FxMDFUY0ZaNnpiSlVBUnNJSnE3aEhEcEtBWTBWdm5T?=
 =?utf-8?B?RXdTVCtERXAvTWhhYVd5S1NxRU5nQ0h5UCtlSkVVd01hOTVwTmZ2aGFLeFRv?=
 =?utf-8?B?b3JNb1pDRzByQ3U3MGpKRDBEWFdkQm9vNEt0b0ZDbFJCYjVrYVhnWG9tRXVF?=
 =?utf-8?B?dzkxWTg1a1owZWFjZFc2YVpPVmU4V2ZXWmZPaE1DZUo3RHNidnlna2pYVnFy?=
 =?utf-8?B?TVdqcURqeGNZZ1Jzdng2aVJvYVovblV3UU5ENkRlM2lsRDBvNVJBWXM3ZllJ?=
 =?utf-8?B?czJ6dWxodjFqMThlSFJCaEJDS0FNdFZNSlBLcDBmS01zcVRUR1FZMk9COEtW?=
 =?utf-8?B?VjcvNEU4T0xGT004V0h1THFRczlsRTkyTVVyUjNqMWxWdEVHYlNXb1Y0QUlw?=
 =?utf-8?B?d3ZvcUhrNzNOSndEWkNRL0FFOFBIZVhnbXNCQXIwcStMQU54VUJjYXVFS0do?=
 =?utf-8?B?NWkxUThScGV6K2luT0M3TERvNWtZNjRHU0dkWW4yY3F1UnhWQlo1VmJKZGFy?=
 =?utf-8?B?MW5Sa0ZBSjF2VWlvdGptbkEya3pVS1BvVjhGN1pTTFViVlhQSVNiTDgwV1Z0?=
 =?utf-8?B?Ly9LZHhoRXhURzhVdlBNQVBvaU56WGhFVCtjV0xid2V0SFArSUZqS1UxTWpY?=
 =?utf-8?B?WFFrTzNEbVBkdVhodDJESjF4OHlabGROQmQrdEttQWxxTWsvUHBxcll5S094?=
 =?utf-8?B?TldRVzd6S1huajFKUFZiZkxnbDYycmNKM3V5S2wzNWkvSVRtMllJZnFmS2F5?=
 =?utf-8?B?bkhGZU1vV0xrWjlQKzhobHRmWG90TkZPd3BuSDNQWWRSRDN0aUh5MThsWW5R?=
 =?utf-8?B?NXVkTFVnYXA4clJLNVFSL1RKRVhuL21ZdWdybkkwV1N5RVl5RTU1S1J6ZEZ3?=
 =?utf-8?B?TVVvYVdyS2VtUk1Qb3VPZllUQnkwd3hRMTNhMytpSzAwQjBSejNOV0VCYk50?=
 =?utf-8?B?WldhbUpBeW9sam5aSEd0M0hvejhGR3VVbjcyVG5BTFZBcGpyRXpYSjRNY3h2?=
 =?utf-8?B?V1Jqb21VYUFVRmtxcDM1cDRZUGNvYlJwcFl2alVwZ1BZSXJ1K1lmS3Rsd0dn?=
 =?utf-8?B?VHNFdW04c2dOSGpaWE15UUxSQk5hbFNhL3d1akZBdE9wVW5TQUlzWWxrMmtw?=
 =?utf-8?B?ZzZEKzA4TjIxUUlwVUQ0NWgxS2JJTzg4VmF4NTVnV2ZITVkwVE5pSFAwVXhT?=
 =?utf-8?B?RlNMbkpHaW5aRnBqZGxicmpjbU9SVWhLWU1mck9rTWxBUXdtUDJ4b0pvdEJD?=
 =?utf-8?B?UEJ4bmsvQWxLUU5oNWh0L3k4bUtkK0hYdTB1aVRwNUtRd0RvYW5vdzVCL0N1?=
 =?utf-8?B?YzJDTXpneG1kaG5ScXUwUnBreUlCQUtHYXVHdEswVFU5UkEzS3RvOE9pbDRs?=
 =?utf-8?B?RmY4Nkthd0hKSlNMQXVMckxpdTJxOEROR2xKMlhhckYydElNbzhNT3Fzd0pl?=
 =?utf-8?B?MzE2ZVV3QkNCLzZrZ2FaWTY1THlDOVV4L01VckN2VnJrdHM1R0U2M2Y0eXVE?=
 =?utf-8?B?MnE3andHVkJoSlI5dXpRY1BXRjJKOUJSVVBGc1EwczVvVm03VHpWeDhXS2gy?=
 =?utf-8?B?WXJjZ1RlR2Z2WHFFWlgydEVBSlNyNU1YdytIWlJQT1BtclhzR1RVMVhGWVpj?=
 =?utf-8?B?UHNKV0R6M25hME1LU0RsWDdacVhKRndaY0FZemlMU09SZEloTFZqWC9uTHpl?=
 =?utf-8?B?YnVnSHBJWmp3M1BINjBjQjJ0SmpqUjBCUVJGa2tKZVByMXJneGY3QzExanJB?=
 =?utf-8?B?ZnpJdzNmQnZDUUpuNEtQelovT29aZTE1cUNja2lweXhZeTVUVHR6MHZHbmlt?=
 =?utf-8?Q?4Af8e34WR2/sz9Xz9yJuNXPEr?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f8ea423-c4eb-4fb4-b653-08db301c75d1
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6218.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 06:11:40.3097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MzMMZ3CdwOZFg/xhHLNCpKa15H5mqk/Jy3i5uCzpBOlWBn28BAp1GNRHeeVERY2xU/iVG3LZt5YtuIbxx1OHig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6198
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/25/2023 1:25 AM, Sean Christopherson wrote:
> On Mon, Feb 06, 2023, Manali Shukla wrote:
>> Currently, the hypervisor is able to inspect instruction based samples
>> from a guest and gather execution information. SEV-ES and SNP guests
>> can disallow the use of instruction based sampling by hypervisor by
>> enabling the PreventHostIBS feature for the guest.  (More information
>> in Section 15.36.17 APM Volume 2)
>>
>> The MSR_AMD64_IBSFETCHCTL[IbsFetchEn] and MSR_AMD64_IBSOPCTL[IbsOpEn]
>> bits need to be disabled before VMRUN is called when PreventHostIBS
>> feature is enabled. If either of these bits are not 0, VMRUN will fail
>> with VMEXIT_INVALID error code.
>>
>> Because of an IBS race condition when disabling IBS, KVM needs to
>> indicate when it is in a PreventHostIBS window. Activate the window
>> based on whether IBS is currently active or inactive.
>>
>> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
>> ---
>>  arch/x86/include/asm/cpufeatures.h |  1 +
>>  arch/x86/kvm/svm/sev.c             | 10 ++++++++
>>  arch/x86/kvm/svm/svm.c             | 39 ++++++++++++++++++++++++++++--
>>  arch/x86/kvm/svm/svm.h             |  1 +
>>  4 files changed, 49 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
>> index 61012476d66e..1812e74f846a 100644
>> --- a/arch/x86/include/asm/cpufeatures.h
>> +++ b/arch/x86/include/asm/cpufeatures.h
>> @@ -425,6 +425,7 @@
>>  #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
>>  #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* "" Virtual TSC_AUX */
>>  #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
>> +#define X86_FEATURE_PREVENT_HOST_IBS	(19*32+15) /* "" AMD prevent host ibs */
>>  
>>  /*
>>   * BUG word(s)
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 86d6897f4806..b348b8931721 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -569,6 +569,12 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>>  	if (svm->vcpu.guest_debug || (svm->vmcb->save.dr7 & ~DR7_FIXED_1))
>>  		return -EINVAL;
>>  
>> +	if (sev_es_guest(svm->vcpu.kvm) &&
>> +	    guest_cpuid_has(&svm->vcpu, X86_FEATURE_PREVENT_HOST_IBS)) {
>> +		save->sev_features |= BIT(6);
>> +		svm->prevent_hostibs_enabled = true;
>> +	}
>> +
>>  	/*
>>  	 * SEV-ES will use a VMSA that is pointed to by the VMCB, not
>>  	 * the traditional VMSA that is part of the VMCB. Copy the
>> @@ -2158,6 +2164,10 @@ void __init sev_set_cpu_caps(void)
>>  		kvm_cpu_cap_clear(X86_FEATURE_SEV);
>>  	if (!sev_es_enabled)
>>  		kvm_cpu_cap_clear(X86_FEATURE_SEV_ES);
>> +
>> +	/* Enable PreventhostIBS feature for SEV-ES and higher guests */
>> +	if (sev_es_enabled)
>> +		kvm_cpu_cap_set(X86_FEATURE_PREVENT_HOST_IBS);
> 
> Uh, you can't just force a cap, there needs to be actual hardware support.  Just
> copy what was done for X86_FEATURE_SEV_ES.

Okay. I will do the suggested changes.
> 
> 
>>  }
>>  
>>  void __init sev_hardware_setup(void)
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 9a194aa1a75a..47c1e0fff23e 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -3914,10 +3914,39 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_in
>>  
>>  	guest_state_enter_irqoff();
>>  
>> -	if (sev_es_guest(vcpu->kvm))
>> +	if (sev_es_guest(vcpu->kvm)) {
>> +		bool ibs_fetch_active, ibs_op_active;
>> +		u64 ibs_fetch_ctl, ibs_op_ctl;
>> +
>> +		if (svm->prevent_hostibs_enabled) {
>> +			/*
>> +			 * With PreventHostIBS enabled, IBS profiling cannot
>> +			 * be active when VMRUN is executed. Disable IBS before
>> +			 * executing VMRUN and, because of a race condition,
>> +			 * enable the PreventHostIBS window if IBS profiling was
>> +			 * active.
> 
> And the race can't be fixed because...?

Race can not be fixed because VALID and ENABLE bit for IBS_FETCH_CTL and IBS_OP_CTL
are contained in their same resepective MSRs. Due to this reason following scenario can
be generated:
Read IBS_FETCH_CTL (IbsFetchEn bit is 1 and IBSFetchVal bit is 0)
Write IBS_FETCH_CTL (IbsFetchEn is 0 now)
Imagine in between Read and Write, IBSFetchVal changes to 1. Write to IBS_FETCH_CTL will
clear the IBSFetchVal bit. When STGI is executed after VMEXIT, the NMI is taken and check for
valid mask will fail and generate Dazed and Confused NMI messages.
Please refer to cover letter for more details.

> 
>> +			 */
>> +			ibs_fetch_active =
>> +				amd_disable_ibs_fetch(&ibs_fetch_ctl);
>> +			ibs_op_active =
>> +				amd_disable_ibs_op(&ibs_op_ctl);
>> +
>> +			amd_prevent_hostibs_window(ibs_fetch_active ||
>> +						   ibs_op_active);
>> +		}
>> +
>>  		__svm_sev_es_vcpu_run(svm, spec_ctrl_intercepted);
>> -	else
>> +
>> +		if (svm->prevent_hostibs_enabled) {
>> +			if (ibs_fetch_active)
>> +				amd_restore_ibs_fetch(ibs_fetch_ctl);
>> +
>> +			if (ibs_op_active)
>> +				amd_restore_ibs_op(ibs_op_ctl);
> 
> IIUC, this adds up to 2 RDMSRs and 4 WRMSRs to the VMRUN path.  Blech.  There's
> gotta be a better way to implement this.  

I will try to find a better way to implement this.

> Like PeterZ said, this is basically
> exclude_guest.

As I mentioned before, exclude_guest lets the profiler decide whether it wants to trace the guest
data or not, whereas PreventHostIBS lets the owner of the guest decide whether host can trace guest's
data or not.


Thank you for reviewing the patches.

- Manali
