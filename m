Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0E41642C15
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 16:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232705AbiLEPlq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 10:41:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232343AbiLEPlo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 10:41:44 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2082.outbound.protection.outlook.com [40.107.94.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93CF1FC7;
        Mon,  5 Dec 2022 07:41:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aE5p97renGegennQ55JleNK94pt7X5PoreSGWYxkU2jIJSBgUrpf/BAQze9MrHskE1V10meFG8lLx9s+310jJxaU8s1jBqGTDDbNusOHJY1bmuuzLtCa5vvH6QJ03DnKSX891m3M6MLuNVRoRuUaf6Nm0659db8DmwACzKKc3kbPs8NLQ/Fv40srUDe9w4tiMpA8Dpc6akLcaflMPyVYkoaje9YxaUELMY6G/Y7zx7TGAWRAG8s7d1ECch2HSJfjOwMpGjyDHeWLIPyeWhZF/phgqXAZJgYJAC0wuwwGGZPsgI0yTLeaEgvRxALQFMGLGXTLZBi9q6CNo/Z4qNyUZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aRa72fzOWZ3ARl6ZtLuQRoM+bu40kWmgM5ql3xjSJWY=;
 b=O4mk6Io5eWErVlLiT5Z0dYx/Y3fXARW4lmqA6d+V1uk2HnyQE8brpDJZZcIf5K04vZfnr91AS8fyCaNkHd8LDSPy8a+rA4Iybsjmzk/0Ep386oXJvFHfibPBhym7v7tuwd2t+AMz1Zk8N5eSwsyGxWgY+GxEUE5O/7xEQ38aUojAL6SBIunD315SU244gEZzue7f0rIHq3U3hVU7b8y5/mHpfjzm6wqlolY6/uZ6qdSbm1JToVH8jcRpwt+Hxyry+0VdHAJ6ZjC4bnh7pWvAj0s+vcKZ1MUctyv+24RA7efJJ9povhMwM6VYCcjObm7L7Ar+Dp/ZFe8vpzYZcoIkJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aRa72fzOWZ3ARl6ZtLuQRoM+bu40kWmgM5ql3xjSJWY=;
 b=XQuqO7rAa1IMDT513v+iFXN5yqbm+JZEnX2xNbF0B02KKCSM2pl5aY4uABEIHSdrfbeE2kdnE0GpAh4g576d3lbAP2evAIBA84A2j45Jrb+yJSV6tp3fXyyJJIGFhI0R+eG1NBEzKvY4t75Z+z7E69gt3e6wu364UCGIc8VSUBA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by BL1PR12MB5946.namprd12.prod.outlook.com (2603:10b6:208:399::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Mon, 5 Dec
 2022 15:41:39 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::caf0:cffe:94c4:df18]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::caf0:cffe:94c4:df18%4]) with mapi id 15.20.5880.014; Mon, 5 Dec 2022
 15:41:39 +0000
Message-ID: <41abb37b-c74a-f2cf-c0ce-74d5d6487e92@amd.com>
Date:   Mon, 5 Dec 2022 21:11:21 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 06/11] KVM: SVM: add wrappers to enable/disable IRET
 interception
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Sandipan Das <sandipan.das@amd.com>,
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
        Sean Christopherson <seanjc@google.com>, santosh.shukla@amd.com
References: <20221129193717.513824-1-mlevitsk@redhat.com>
 <20221129193717.513824-7-mlevitsk@redhat.com>
From:   Santosh Shukla <santosh.shukla@amd.com>
In-Reply-To: <20221129193717.513824-7-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0026.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:97::17) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6323:EE_|BL1PR12MB5946:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f582a0a-ab42-4eb6-093e-08dad6d732d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UVtSC4gpdcvQi8fBwXons+7+PXqB2vOY1+ouWPAAUBJcNeR3DWw623rs/MN98+7DBi5H2J09xLA60H4TQflriw2K5c+IAjTVJuF02N2p44BYejxzOFsHBx1JEGmqNJXpNUoxtIqwL7Lyw/ZPojOiA4BfqY/geWVp2laHu2QWZUFLorVKw2YztxGaHX0IjbS/LjkcKpzRcHZPbiAB7Fgra1IIPDPwwhC589YcY6y4FmrnsfZZ9GiS6MYKlQrOH3Uk4laLzm+glKbaiKXxD/OAv1Xu2KV1A9qARuFvwDsZvqCZXktZVbGNi8n+++8tHVV12OZ4plsLDR7m5CfNWITGz7q0t7b79yFZGjEXFCNc2lEU2hMD+txyzLhc2WS2K2MyPBipKMXcM7ZKvZzw1CPpz8EEXRQMR6nJfEF6DN3g/7F2iV1VdhkPkRuYuMoL11nHkAL0FFrUingxbUIgh3Q3vPTzJnrf5lpNZdAJtg44TUu2hlDuN6YK+c0fkr1gnveDSAd6dUvhCsXF3QCdEoo/AZ32NR16t4f7usQZ+oAlj4zsjIA0DeEun9GubiJEBbOIcAyzM7wK8n1un7OYaoPw43xJHu0ykQVGpSkrwIczflGavxyxCfx0ka2ZLD+5DVRfvgRkQE2zrsbFWJt2xCXPWksNTgqq2khsbB8nSM6wKEp1vFqCh/ofoKZoPz/psKWVIkB4xkMxuHVNZv876kf7t7dCYDxDfDjc3efzYyWTHos=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(346002)(39860400002)(396003)(376002)(451199015)(36756003)(31686004)(38100700002)(31696002)(86362001)(2906002)(41300700001)(8936002)(4326008)(44832011)(5660300002)(7416002)(83380400001)(66946007)(478600001)(6486002)(66476007)(66556008)(316002)(54906003)(2616005)(8676002)(6666004)(53546011)(6506007)(26005)(186003)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NGJOa2dFRUNOZlVnemY1UVBpbjUzbDBQbnBsYVNTOCt0bjFVYWp0dnNhbnRs?=
 =?utf-8?B?U2pXQ3lBcVZ5VFg0SDBuTUhTVm1rNjFtN2w1UUhvY2hDL3plcDJOaE93dlB2?=
 =?utf-8?B?TXZBWk83ZnBKelp4N1R2S0tQaTZQaFhjck52WSt1a01jQlRFRHJ2S1Z6SGpw?=
 =?utf-8?B?ZHJNeTg5cEhqRmZHSzc5QmE3M1JUcVpqMmdNYkV4eHZtZkJVMkUrMzdDc3NH?=
 =?utf-8?B?NzM0bDQ1NkFqNkpLQzlHWEkxSjlTcUlTNTBWUEI3d1p5YVlZYkRYcm1RQ1h4?=
 =?utf-8?B?S0ZNK2VlZUNMS1MwNDc2RDlrMGtpaU1FT21EaWF3emlycjhrS1ZPR0FlVFFC?=
 =?utf-8?B?MjNqbWd1b0dZd1M4UU1rckt6TmJxNXUyWXZrNG9KWFl0WHF1a1VOSE1Jd1pp?=
 =?utf-8?B?UWNhQWVXNnVyWmRUM0Z6U2N5a003WTZzWHRtem50REJnaGZrTkFJTkx5UTlM?=
 =?utf-8?B?KzAyTFRJc28xU0Q3ZUZnRUdhZ0UrR1EydzhiR1NSc3JEUDhQVGVyLzF6ZVVC?=
 =?utf-8?B?L3IxbmQ4NUtvVURoMTFUeDZvUk9wSFBUUy9zck1zQ2dZeXQxOWtSMHdRNXA2?=
 =?utf-8?B?M1plVVpKUlJZVHYvdHl5Z0xRcUl3cUQzVWpIc2VEK1RSMGNDUGhtald2Z05K?=
 =?utf-8?B?RTdYbDJCMWhtbzZzd0JTcS8rdzl2S1NiMWEyOFMxYWIzK0UyaXpUM1J2cFMx?=
 =?utf-8?B?bnNJcWhKMFpDckVGcElGZFBtclFWSmhla0EvRWlsZlNrekVNbGRxckxGR1R1?=
 =?utf-8?B?bXlja2pxbWd1ZExQMmpBd3lwa0ZLSStQYURaY1BHTGJ1cFFjc1ZxL1d1dVpH?=
 =?utf-8?B?ZmVKNVpaaXhHbzhLajRwdG0wL3lVSXVWRVFHaWZqNXZOd1ozNmNUQmxkRWNq?=
 =?utf-8?B?OW5TMGJxWkR4eHZsdXhRTnFNOHV5a3lFQ1Juc0VjNEoyWmk0amxZMEpXdnRl?=
 =?utf-8?B?UFUrWCtGZ0h5dDNLaHZoZjg2VUtmN0VOaUJieGM3SkJkQTJjVTJDdlc3dllW?=
 =?utf-8?B?MnlmQmtNbmpxYnl2MDlZaklMbkZCWkNkS1BHUWdud1NDajZuTEVFZ3hvbTcx?=
 =?utf-8?B?MjkwUEgzMUNxb2lsZzg3RnpOSkszdjJib1FqV1NaSmpua3ppVTBmaVBQWFFG?=
 =?utf-8?B?anVjQWpqU3gyR2R4eVl2M1d5OXFXMTNxL05lenlQeml3eU90SWdSU05CUXZQ?=
 =?utf-8?B?cGFCZEdBd3UvajJFKytrb3RaWVZqVWdQdlkzZ2dYaGtMRjA2N21yVm1aUXVP?=
 =?utf-8?B?VEhRSWlXM25ySkdyOVhyRE4zZlZhajhsZ3oxRFRTNldNcUNXVU5NaCtqYzYz?=
 =?utf-8?B?ZnN5TUI0NTdIRDVFZ3VUakloSGVsbEVhTktaMldvckc4NkZHd2QzQnVUWmxL?=
 =?utf-8?B?bUoreGs4eFV0QSt3WEZSc1E5cWhlTndRd2VudjJnMjljQk1MYjFGaDlGTmlD?=
 =?utf-8?B?a0VJaXpTM1hxbDBUUmxrZzRPL2UzNElhMEVXMm5hem9kVVkwUjJGaGpyZGFS?=
 =?utf-8?B?QVUrYVVZTENyUTlpNHJ4YmlxZUxWVmJIbkc3aUpNT0l4SnZtcnpLYm5WMXA0?=
 =?utf-8?B?YU1pV2Fwa3QvQ3BoTm1SMzhkZCtuZDRjdjl1blFsT2IzcUVvKzhXZFlsRVpN?=
 =?utf-8?B?dGJaTGxPTEI3SUNTYVovc1JoTmhnZ1p4Wjg3NUhnczljanF2M09zcWFtcmJo?=
 =?utf-8?B?WUlEYm83TENTSjNkUmhIalZRZWQxeS83VE96ZEpiSXZhSmk2bzBXRUphalVU?=
 =?utf-8?B?VFRGWkFOSzNuSlpjdEhLdjdNTWVZRlBsbk1ZdC9ERTV0WWcyZGxwMnBBbU1m?=
 =?utf-8?B?dU9YamVaeGFRL3huQUpDZk5pYW01QUo2K09nSVgwQVFuTHFYREpYUWVORVBX?=
 =?utf-8?B?MXY1RU12YWs2RTJhdTlFbGg2djU2eXlBRHNrdmhZd0g0a1hzVWE3Z1o4alVF?=
 =?utf-8?B?WUNJTGg3UDVtRkVFNnM5Z0tFd0JsdG4zSll1RHlmaHNKU29GYmY1OXphUXJU?=
 =?utf-8?B?RVJGYkZmejZtVCtJWVg5a05BY3ZBS0R2NWxRUTVnV3gzZmhwN1A3ck0yM2JW?=
 =?utf-8?B?NEhPbjcwU2hHSldaMWxXV2pVa1lZQnA3QTBRYmw4SitMeklIcHZyZ0hDM1NG?=
 =?utf-8?Q?xJcs/Fe7WCJodFWWgDHHu+aha?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f582a0a-ab42-4eb6-093e-08dad6d732d0
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 15:41:38.9685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6OCWNi4vPjWXfSWI52caVNO3uHfsej1bKLSfTbOTF1G7ILr1lFMKVL+oyqaMTynNpmpHmhRCSuufi+j0Ho1GDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5946
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/30/2022 1:07 AM, Maxim Levitsky wrote:
> SEV-ES guests don't use IRET interception for the detection of
> an end of a NMI.
> 
> Therefore it makes sense to create a wrapper to avoid repeating
> the check for the SEV-ES.
> 
> No functional change is intended.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/svm/svm.c | 28 +++++++++++++++++++---------
>  1 file changed, 19 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 512b2aa21137e2..cfed6ab29c839a 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2468,16 +2468,29 @@ static int task_switch_interception(struct kvm_vcpu *vcpu)
>  			       has_error_code, error_code);
>  }
>  
> +static void svm_disable_iret_interception(struct vcpu_svm *svm)
> +{
> +	if (!sev_es_guest(svm->vcpu.kvm))
> +		svm_clr_intercept(svm, INTERCEPT_IRET);
> +}
> +
> +static void svm_enable_iret_interception(struct vcpu_svm *svm)
> +{
> +	if (!sev_es_guest(svm->vcpu.kvm))
> +		svm_set_intercept(svm, INTERCEPT_IRET);
> +}
> +

nits:
s/_iret_interception / _iret_intercept
does that make sense?

Thanks,
Santosh

>  static int iret_interception(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
>  	++vcpu->stat.nmi_window_exits;
>  	svm->awaiting_iret_completion = true;
> -	if (!sev_es_guest(vcpu->kvm)) {
> -		svm_clr_intercept(svm, INTERCEPT_IRET);
> +
> +	svm_disable_iret_interception(svm);
> +	if (!sev_es_guest(vcpu->kvm))
>  		svm->nmi_iret_rip = kvm_rip_read(vcpu);
> -	}
> +
>  	kvm_make_request(KVM_REQ_EVENT, vcpu);
>  	return 1;
>  }
> @@ -3470,8 +3483,7 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
>  		return;
>  
>  	svm->nmi_masked = true;
> -	if (!sev_es_guest(vcpu->kvm))
> -		svm_set_intercept(svm, INTERCEPT_IRET);
> +	svm_enable_iret_interception(svm);
>  	++vcpu->stat.nmi_injections;
>  }
>  
> @@ -3614,12 +3626,10 @@ static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
>  
>  	if (masked) {
>  		svm->nmi_masked = true;
> -		if (!sev_es_guest(vcpu->kvm))
> -			svm_set_intercept(svm, INTERCEPT_IRET);
> +		svm_enable_iret_interception(svm);
>  	} else {
>  		svm->nmi_masked = false;
> -		if (!sev_es_guest(vcpu->kvm))
> -			svm_clr_intercept(svm, INTERCEPT_IRET);
> +		svm_disable_iret_interception(svm);
>  	}
>  }
>  

