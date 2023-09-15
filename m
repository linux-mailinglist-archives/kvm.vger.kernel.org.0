Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 232E67A28D7
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 22:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237566AbjIOU7J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 16:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237429AbjIOU6m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 16:58:42 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2063.outbound.protection.outlook.com [40.107.94.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F233C2719;
        Fri, 15 Sep 2023 13:58:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gj/JIFqiA2cAxKROLie39Cd1HPGuXSVSnv5i+Mqgspq+jeZ0C2VRj8HpNMBI+k7mBKWAyrIu3epDvpk4NKmoO8Q23LtN9nwovrOp1seuf0mGmJ37DeNYJkPq0S8z0zpxTEA3HlxFRBD/05cAE9h8MBesWv7YrMaNYW4hSa/A9rMQWl3VZs18KwHUZwyJATkv1vTEuBf2CEdcu4PyExx1YxHB3UM+FgBxXXQv/rqVUn7IDV9e3E4we5mmg10kuXzHcjMOTFgnDDrBOdXc/r/hOiTV7RzpfrimCEXggZ0jQ8MqL5xn5awLCG1ODxdkV+VjvxLJ0aowFj20sxyh0RJq7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/I16jz3TmqZVSazWw2625oem/IFTYFOJarfpvGgCzWc=;
 b=TwCoMOaG4iRZuRL3BekcslJeEg2irEw9wLXaVxjlFIsDNanbvEyl+x7MH0I1JmBWjv/wdt428Deh1TCNI0gnVz89l21Xfo75U5Cs79M4IqfzHAumCKeSz1h4wzZIUQP11hmCe9UcrQP9uVP6pKtdohP4bnAZzPhfnR5kc3pP22muIjEl1/lLSb8Turr0iO5Yqj4Xi4x4R2skIpkkrbfW4q+9EHzQ7eM1sGWhsi0c5JV1C6r8ft+AIQd3dX10ZxQlxA8lD15WVlrDffZS5kZDcOqi11r2bX83UWJRQ7bjjr0uLverqGZr/lkhsJPRzXCgMGfgOWLY38s3n9rAQW8GNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/I16jz3TmqZVSazWw2625oem/IFTYFOJarfpvGgCzWc=;
 b=qyFY4YFHi7cIgzDu6hlxJ3pZMF9A+hSil8Izii0H8Kes+yu3ZAm8JsE8hPlw9RXw9j6E51kgmAlOL9Dy+FbGoh4BfBCHuZFSyCl+KL3CpVJNLR11/LdFkAZgi2astJOJudM0L1PoFVQphfrtonaeZVXNPvmpS/QVQsltzWnyjMc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by SJ0PR12MB5454.namprd12.prod.outlook.com (2603:10b6:a03:304::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.20; Fri, 15 Sep
 2023 20:58:02 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd%7]) with mapi id 15.20.6792.021; Fri, 15 Sep 2023
 20:58:01 +0000
Message-ID: <a77054e9-1a5f-f86e-616b-0c8bf1c26e83@amd.com>
Date:   Fri, 15 Sep 2023 15:57:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2 2/3] KVM: SVM: Fix TSC_AUX virtualization intercept
 update logic
Content-Language: en-US
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Babu Moger <babu.moger@amd.com>
References: <cover.1694811272.git.thomas.lendacky@amd.com>
 <aa46606f21303d5b45544ed2043966c2b3d7f69a.1694811272.git.thomas.lendacky@amd.com>
In-Reply-To: <aa46606f21303d5b45544ed2043966c2b3d7f69a.1694811272.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0049.namprd05.prod.outlook.com
 (2603:10b6:803:41::26) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|SJ0PR12MB5454:EE_
X-MS-Office365-Filtering-Correlation-Id: c41b588c-a62a-4322-bcf3-08dbb62e72e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EM7RKSbPpvOvFDJIp23ufXWYZynSHGuPJObOO3+/nsLrrgZOUuNiYD2Zj0TXOYH17/OM2HQ0KN4X3cgme85X4IBmpL1iyDIdGPYitDqtUE5p7j1BG5Ma5VpkLyxA2FEkrSkGJE2EXkEvkk2zB68BbJBupDEcoTLC2rhcCjH/+Y3TqrFfcVXr4NovUfqdzsxoMG5OsH9ZxwiyyR9zU6qpDiPo25JiKhH9ngXRCW3KyjpTGIWAVMcUb+YH3SNnLUmJEtM+Z1aIOuZB1fkJhywC5R2Glf3I3CHcV+tgofYB8f2FDW2HUvs/5bDW9jl2SXysXYmqji5WErq+1bRTwr87PY0SI9kgS2ll0Sk+NyPWpdDdyPjhN6LkWEz5yzqROWFqQkJAqbEcUalh9eVKSuCLVP4pykDx81+3xvMGwlZy6yxxkYZYELMhNrgAOmx9o8I9J6FF17ZxjvLJRP+e5qoXOqfvgkgN3vHpBhS/LzHEb1ZfFqVvKRSiw+jcwYKu/46s/0w1KtsOVO2HLhLrNZ20u+m3AEER6GUrkDADe2tiQgSqvqx+CWHMhYQBZ7jFIVmor8M6VIAq/O0B/E/lQCTSRssqE9FQDG0Btg5pMgVsA2mvU2YiZRdBjyafF9Y5JRm7MnEbbZyr/NP24M0rHFw1kw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(136003)(39860400002)(346002)(376002)(186009)(1800799009)(451199024)(2906002)(83380400001)(6512007)(53546011)(86362001)(2616005)(38100700002)(31696002)(478600001)(6506007)(6666004)(26005)(8676002)(4326008)(15650500001)(36756003)(41300700001)(66476007)(6486002)(8936002)(54906003)(316002)(5660300002)(66556008)(66946007)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cXNnMzBpK1FrZnNtV0FIMDVnbTdzL05hZS90RXdzd21JVFVQcjh3U2l6K1RN?=
 =?utf-8?B?d0NmeXJmMDhMNXhBR3lsSG5Hd2lCeEhOVWJKcEg3dmp4bHRDQk5oV1F2SlY5?=
 =?utf-8?B?TVVLUnVPQXZTSlJWSTR3RGJsRUNFNFNlU0hUbmNpdURwSGZySHRqTmxnVStx?=
 =?utf-8?B?RlhXc25Kd0x1OHduOE1KT0lzQ0JMaVBNSUgreW43Wmhjb1F0d1JzUHo4cnBJ?=
 =?utf-8?B?cUx0Nm1TaGovRXJkdGt5c3Y5TitkU1BCRWc0MmdTcEZHRzFTckhkc01RNnFD?=
 =?utf-8?B?d0lrQy85eVVUaWIxb2pPbGhpTXhlSWUwQVByeVp6cHM5REdMYXByUUtxc1VX?=
 =?utf-8?B?RUpId1FmekV1a2dzOEI4TS9yM1BDMkZrWHRaa3Zqdm5lTmRsVTZUZ3dqT1l6?=
 =?utf-8?B?TW1rbXVHbWNVNFA4TnlFRjYrZkM5M0hDSkExUHh5RVRiSTMvY05ER1hzY1pa?=
 =?utf-8?B?eTBoa3BjMWEreWdkZFp5WDJJdWZHenMybjdraXByRXdhQjZWSlZsTUhibmtF?=
 =?utf-8?B?VEJaZUFZbmIvREhJLzRKM25mM1VKTVcrbVpOZVo0ZVBlZmdRUGs0elFoZGN2?=
 =?utf-8?B?NTNTbnJZZWNNcEFXMVJ2bXc0cFZqWWFXYzhsR21NN3BFdTQvVXNuT3B1dXVI?=
 =?utf-8?B?cENFM3RpVmlJNFdoTUpCYWVSeWtIelB5Q1plWU0wT0pIeWVkY0xQU3NZVldw?=
 =?utf-8?B?MjRiOFI4blF6bEVnaUtGWXQ5aTBpR2xNZmZwa0kxdERxMjM3QjcvbTIvZXVO?=
 =?utf-8?B?RElmT0h5MjVON1I3TFNvU09QdEdZTU9KVVRXSTcxS0N3Mmsrd09wZlgxd201?=
 =?utf-8?B?KysweXV4MHFXNFhPMjFoSS9zQTR1WTE2emEweENrNVBINHM4cnV1azJhQVkx?=
 =?utf-8?B?azYxckJUUTRwRHpjMk41WVBLeVdvU1RpdzBSRjMvaTBXQnRxRnRBUGFjdVJH?=
 =?utf-8?B?VjR1V0ptWnRBL1NNTHNpUDBGQ1RUNWdHbVlrS3NjQmhVeVkyOVdvQlB6ZC9Z?=
 =?utf-8?B?enllOFIyRFI4YU5ZS0Jxd3Vsei9EeERVUzhiajBTdjFDdDNIQkwya3FqWi80?=
 =?utf-8?B?QmoweHRYYWRmclN0V25GWm0veGVhbFNSOGJ3OEllOWd5QzZMb04vdFI0aDJR?=
 =?utf-8?B?R3ZxMnR4QXJQbjBnd2FvTXI5TmxSenRmVzBBa3Zjb29uNUc0b2crK3gyNFpv?=
 =?utf-8?B?aWR2UjNQNjRCU1FRVlFSU3FHUEJIRys0STh5M2VkR2ZBL3kxZWFock5pY2lX?=
 =?utf-8?B?bktscWNicStvaE9Gd3BaZUF6S1NyWSs0QXg3aHRaTDZEUXRDckZVTjdSRi9i?=
 =?utf-8?B?enVFeHVEMmlHYzFMbXpucnZBbExmNlVCNlJpMU05ak9oSVhEK1ZWc2gxdTVL?=
 =?utf-8?B?QTlHa2RmTlR3SWs2eVdMZHZrQXA5aDJjR2QzZm1sM1Rzd1pGMm5tUEF0MUE1?=
 =?utf-8?B?QnJKazI5Zno0UFVTTWxHSUVrcHdoYjNTdzhSVThuTEp2L2c1WkU4TUpZNXpX?=
 =?utf-8?B?ck9CWXZybzRobzdQNzhIRVJpUjE2aWREdjlkZmpoajQ2dEs1R0szQXB2Tk42?=
 =?utf-8?B?alYwTnlZODkyT2ZNVktHM2FHSXIvdkVCZnhnb3d5ajFQTHlBcy9qcGJhSkNT?=
 =?utf-8?B?ekRocVd5V01UNVdTR3hnWlpoNmVyRkFnbVc0dnFRT0djWXZYOEQyc0tQei9s?=
 =?utf-8?B?S2M1MVFhMjVTSGJma21kdXkyWjlrNk9KbktaL3VvK3htRW93eVhRMFlsRUE2?=
 =?utf-8?B?K0ZaYXRwbXEwZjMvTVo2TEd2ZUUzME5wakIraXA4cmtjekw4Mnc3R0pFejlN?=
 =?utf-8?B?VFpjbnZUVEoxNTdhYzREbVBBSCtYZFpzdXZ0VldmN051RGZ5TnlhRlEvVEVn?=
 =?utf-8?B?dXlIS3pWNHhGY1RWd1NVZjArZWlPVUx2eHYxZWd3MCs2S2dqZWN5SkNSMjFt?=
 =?utf-8?B?N2hDaXc2MmFoaEdMdDRQNlFNZ3BwbGNEV3FhaHRvQ1VZdXNWWFBIdUxMUG1l?=
 =?utf-8?B?d0NkRWtHNE5pblRaN04xSDFONXB0ajFpR1M5NnBSRkFxeE1qY0JGMU9uejJQ?=
 =?utf-8?B?QmtNRkVCQ3dYWWFLL2R0U0hMakUralI1Sys4V0hCd285UXRhTVNvTnljb3Ew?=
 =?utf-8?Q?F3fn6lg9ESICGxDNAVheWGIhS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c41b588c-a62a-4322-bcf3-08dbb62e72e8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2023 20:58:01.6726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FrmKEKDyIZt7rz5ZwHZ++nmpUXBnHOIYi4i8vRTe3PLcZkWKaEpAlmC7J+WfR9s98jlWlw+ZVN1pyXIZa3pmAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5454
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/15/23 15:54, Tom Lendacky wrote:
> With the TSC_AUX virtualization support now in the vcpu_set_after_cpuid()
> path, the intercepts must be either cleared or set based on the guest
> CPUID input. Currently the support only clears the intercepts.
> 
> Also, vcpu_set_after_cpuid() calls svm_recalc_instruction_intercepts() as
> part of the processing, so the setting or clearing of the RDTSCP intercept
> can be dropped from the TSC_AUX virtualization support.
> 
> Update the support to always set or clear the TSC_AUX MSR intercept based
> on the virtualization requirements.
> 
> Fixes: 296d5a17e793 ("KVM: SEV-ES: Use V_TSC_AUX if available instead of RDTSC/MSR_TSC_AUX intercepts")
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

In the end, I was really on the fence about this being a separate patch 
given the common Fixes: tag. Your call, feel free to squash with patch #1 
and massage the commit message if you'd like (or I can send a v3 with them 
squashed if you prefer).

Thanks,
Tom

> ---
>   arch/x86/kvm/svm/sev.c | 11 +++++------
>   1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 4ac01f338903..4900c078045a 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2966,12 +2966,11 @@ static void sev_es_vcpu_after_set_cpuid(struct vcpu_svm *svm)
>   {
>   	struct kvm_vcpu *vcpu = &svm->vcpu;
>   
> -	if (boot_cpu_has(X86_FEATURE_V_TSC_AUX) &&
> -	    (guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) ||
> -	     guest_cpuid_has(vcpu, X86_FEATURE_RDPID))) {
> -		set_msr_interception(vcpu, svm->msrpm, MSR_TSC_AUX, 1, 1);
> -		if (guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
> -			svm_clr_intercept(svm, INTERCEPT_RDTSCP);
> +	if (boot_cpu_has(X86_FEATURE_V_TSC_AUX)) {
> +		bool v_tsc_aux = guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) ||
> +				 guest_cpuid_has(vcpu, X86_FEATURE_RDPID);
> +
> +		set_msr_interception(vcpu, svm->msrpm, MSR_TSC_AUX, v_tsc_aux, v_tsc_aux);
>   	}
>   }
>   
