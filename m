Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4EC876466A
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 08:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbjG0GGl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 02:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231840AbjG0GGi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 02:06:38 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8657CEC;
        Wed, 26 Jul 2023 23:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690437997; x=1721973997;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=g/oGJ7sske938ZapkL9eTjJeodLfAten61BNy0vXq54=;
  b=UH2Zti7GDEECNdUxjdTEdmk4SMsmBkNazWJKd+LuiRg9LzI7eNlce8PC
   JJ+CEquTNFWVdt2KKdTqLYvTzyCkmSwh/6ijQeQCiiQDJlsjg6Iwtio0e
   fBasHstD+Alo95/XSYsh8Y8J10GtcmMVIe9Q1nfvxca2WUV53a7kqm67j
   kMYcLfrbjjTKyW0TCXvduTBqriAkkO1njMkQauN0W30NPUQIP19AawCCS
   qWlpUdRct6BodrFqXnyhjtr8gvEexQZvEVboX5hF36zwUFfNEtVMUU8FO
   r2jRwFfKFGJVmXniCcpqLsbPyJLMieH9VqvHxpOf5xZXWHKb0BZdMG7R4
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="348495652"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="348495652"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2023 23:06:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="720769178"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="720769178"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 26 Jul 2023 23:06:33 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 26 Jul 2023 23:06:33 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 26 Jul 2023 23:06:32 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 26 Jul 2023 23:06:32 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 26 Jul 2023 23:06:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lAbezsXhjN3hPTYK5TTzDvSSzvCVX5jcb1Bd31QJr1SQzbCu29tNwht2TAATc7cUEiuu/dAOzEeQdAN2XkmmRQzA8jfqQk7cOPF3HN6X7C8C15W2JsCOWJGhdjVRWijOANAhJOXdKqLXrt626NsQ/eMZQg3pFq7bc0hrPUT3enny2CDopFWFaoE5JL8oqZPMXxqJhpoOj2KQ/xDpwoIYqGWyxjRI9Laa4oZ92PQiwcd7L66fkcO2sBwvhreczH8nmeeo4XZkSrBDbSvWvL4sI/wEB4okPc3QOT9teouXO1+DuiJA/J5Nnjjs3JTmNm5NOrpdMe2ofapYsh1FfBd4+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kzpqa0h5b/S2TKrUIZucOlxp7ylZOuTPIyJZdjUhn8Y=;
 b=HgzqQNhicnvda8mbG02c+ipml+o8yibjqJ9T8HyXY9lJuNiW0sjtsAenGupjEHR51ypd9LxU8dpXVWcADuMIqaqeQebn6oGA2OobTMfSiIIYlk6RkWIFVFNdXGay9zPIREJ7zazbpLipdKa6/VBr65LS0pAyMtqihfjUABDSoFNnrjFFQlQD4V0C34xfjrAI/uwUdr6LFXTgE4mkugMuI6imyjWBWgCGd5lWF30jVRWRFfuNOpiaEARJcpuxpojKBQgsNG4UpMpmKeaaUBYwDTlpz0AnbvzYDO2EDzq36zx77GkiPIZTsk+3OG+qi4mX7WeuFF5v+9dUWgEpcbLFQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SA3PR11MB7416.namprd11.prod.outlook.com (2603:10b6:806:316::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Thu, 27 Jul
 2023 06:06:25 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::e19b:4538:227d:3d37]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::e19b:4538:227d:3d37%6]) with mapi id 15.20.6631.026; Thu, 27 Jul 2023
 06:06:25 +0000
Message-ID: <4565ab4b-f386-7b70-4634-627e92acbb45@intel.com>
Date:   Thu, 27 Jul 2023 14:06:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v4 09/20] KVM:x86: Add common code of CET MSR access
Content-Language: en-US
To:     Chao Gao <chao.gao@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
References: <20230721030352.72414-1-weijiang.yang@intel.com>
 <20230721030352.72414-10-weijiang.yang@intel.com>
 <ZMDMQHwlj9m7C39s@chao-email>
 <67250373-c5f4-d1d7-9334-4c9e6a43ab63@intel.com>
 <ZMEjudsdr8WEiw3b@chao-email>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZMEjudsdr8WEiw3b@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SGAP274CA0007.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::19)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SA3PR11MB7416:EE_
X-MS-Office365-Filtering-Correlation-Id: d0bc99a9-804e-460c-f1c8-08db8e679bb9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: imIrL073+9/dOPznGxTam0AdBexvF8ZLIZN5VgHdxdIyZ/wofgD6g3SWbAS3MQEP26Vd8hxMGEBOv8y4Le8JSDs0wHfu6dvAMqN+TDilRoFROnG6iRFYmV3DZ9UZnybA19QHV2Yqi3W9RijYNCfJDxo6ps3poVh9eBZ+pYmsU7agocP4Nm2YiCByou6+1q3IBmxjZo+ubZHf6UlFWVAv2tfBICl4dFeGMEWguxCO2t0qZD5y8CICsZiAlRxDcY9ujkRTECPcimEqSHjINNYAWWjl5mc4IUI1pAv5Flkwm31aQMXtyXgSj5v/YPzWLPekJE7FxIF5syam9kjmYlvvRIbK56Mm7s3WpofZ5Vo6gzjQmiwkLdoF1LPT8M+Bw3E3ZkBDzXL0K+9gaqlhX56UM1MdRBJB3ejX0Dr1FZtu3Rme5w2/CBq0mIBkOsaY8pGOzeoKlRlH+iFCto7B/nnIzdspoZiIC/3B8L/mryVaGbitBOVJNXYcisGyIINGouISeUcPWM5nfQN2A324i1eDCr/PoUOED0cDqg/mWuLl4mkU6F04VI0lBJVxVfEqNT6b1WMaP/0QZwLvuEKu/O7mTz+fVQ0nkHlDi3IfXO0XTZev7jWc7YIA0LYC+wiDSRbxnlxDCFqt/mZL5IpGi/nm3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(376002)(366004)(346002)(39860400002)(451199021)(2616005)(53546011)(6506007)(4326008)(186003)(26005)(83380400001)(6666004)(31696002)(478600001)(86362001)(37006003)(82960400001)(6486002)(36756003)(6636002)(66946007)(41300700001)(316002)(66476007)(6862004)(8676002)(66556008)(38100700002)(8936002)(2906002)(5660300002)(6512007)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MFNSYzN5WFBGcEo4K1pQdTRyVTFXeFRJaldyMmZGSW54WDNGOWVZcEtwSk91?=
 =?utf-8?B?N20rN29EMnBRQmNLdE94K3Q5M2tuRmpDWnRJanJHREVXUmc3UGZITkdHL1NY?=
 =?utf-8?B?a3ZUaC92UGxwWURuWklSWHRNamdoT1JwUi9ZQVpjNWJOYXVmcUNwUy9reDNy?=
 =?utf-8?B?Z1FzOVR2T0tnZU51VENQb2ZWQTRzQWdTVzYwSlphNnVuakdPMU9OTmVwTXFS?=
 =?utf-8?B?QktvbXVTcFBNUFBpTFhQbWpHcVEzTVA4QVEyN1h6d1VXZzZsaXZRbFJaTkU4?=
 =?utf-8?B?V1FsK0FDSGppQkhDVlZzOTJ5ZnJ3SzY4MEFta3IweGVMMDNPcS92U1ZhMHF5?=
 =?utf-8?B?THVraFhmVUJ4OVBJbUJ2bDBkejQxNjlpem43TWdkRUc0Y0pPVUVzWXlmZFQr?=
 =?utf-8?B?aXJRTVdWYXcxUjhlTWl4SHBObVRESG5oYjFWMjJLWmwyWDh0SFV6UFJDLzRP?=
 =?utf-8?B?UHdsU01HaUlraXNRTXNTY2lJT0FnTTNycEsvKzlmdFN4QzY1M3FsSzNnbmxa?=
 =?utf-8?B?TjU1ODB1TTNKc3dTSmI5clMxV1dOaDR1QXlVQ1B2WVN5RlB5cmdMWk92bFRH?=
 =?utf-8?B?L05Rc09oczRzdXVUTGNhZHA0aXMvWXNHRzdhZzVpM0NUNEdZbUFvd2tody96?=
 =?utf-8?B?cnA3YkJrb2tKVit5OEl0NTBMT2JoNGd0ckxVZzJuTkVJeklkMkd5bzlFUE40?=
 =?utf-8?B?Tkp0M3RFdElXQVcvSEFUTG16eDR6anpMbTE5VmRnK0pvT1N1NzgxY2U0Y0FD?=
 =?utf-8?B?U05tM01jSHk0Y0d4TEszSTdLejJUVXBzZElwZGFmSkF5M0w2RXE4WEwwdGRJ?=
 =?utf-8?B?Wlk3Vndkc0Fjay91Vy9uV0lJR25NN3MwL3hPVHl0VWlobnVTSnFlWk5TWm1w?=
 =?utf-8?B?ejZEMUhlQ0p4N1RwL3cyOHA4REhnckl2SDk2Qk1aV2lMMVJPTzFOLzhjWSsr?=
 =?utf-8?B?cEJsd0I2TGdnNGt3OHZCT3ZuT2g3ZmQyajZqb2lYUm9DamFKYVdjaVZYVS9y?=
 =?utf-8?B?WElzcnhTYVFQb2plbXp2bDhkOCszRmNpYXAwRE5ldDhQZzRIZ2g3SllYUDFh?=
 =?utf-8?B?Z05sVHMxREl5NWR2WmZtZ01yY2JrVjF4TEFUNmQxUXIwSkkrRWVuYTV5RSsz?=
 =?utf-8?B?SmhPVERNRkl3VnFrS01jeUhSU3N5bVpQaWxlRjRmZFVadzc2dENaNjBGUUl6?=
 =?utf-8?B?ek12MVdqWkRSQVZIZ3AyNHZpUjRCbXFORWo2cmJyNUU3SjR0LzA2M2JnNXU1?=
 =?utf-8?B?U2dvQTVraWZXSE16MGtYZVMwVys1Q1o5VzhlRUxqYkoxUzM0b2Zjdm1BVEVX?=
 =?utf-8?B?cFEyU0p0TzNrRXVhOEF3bldBNFJTWjdVUHRoQ0dxTTErNHZxblNheHNPZE9q?=
 =?utf-8?B?OHVWOWJMSlo3bFBsS3ZFd01SdHlPeFFjWW8xZnZ6YUV2azQ2c21FejlXZk9G?=
 =?utf-8?B?cnF5b2xnNm5uVWVsZExiMnVyNFpkdm5qSjdvbGlrejZhM25CWEdERGk3RldB?=
 =?utf-8?B?YW1PcXAyVWVxbUxVMmFlQlBRaFhtOVJ5TzFvRXpkTzBvUXZ5WitDbzVYSzJ1?=
 =?utf-8?B?SERndWlOWEl2U3htcmRsUmswQVFXOFR6YnlRcWo4dG9VSjM4VFVjVEJ2MXVZ?=
 =?utf-8?B?OGRPNFF5a2RCa21aT1pWaXBVdUwwYjVmYTBJM3lkNHRBNDlaTHJrOWgwbUlz?=
 =?utf-8?B?QWlENFBaQXZlRlRZbFJ6TW1PL0x0THlTZHhweTMxNDVyTFFrN3Z4djUyaTUx?=
 =?utf-8?B?eUkvRUhQZ2NwNTY1Z3ZueEhIMTc3SngydUZJS3IxeTJDbGYvWS9iQStxSXN5?=
 =?utf-8?B?Wmlpd3Z2N2NibUVqMkVLV0pjWSthWktBSlVzR2duZnpNUGNQNXVyZlpFWjlw?=
 =?utf-8?B?UUgyWkNoZmg2eHFZK1pnNU1XcjlubWVOZFIyVTArOUgwK1V3RzBnSEVudGVG?=
 =?utf-8?B?N2F1bU9oSmIrc3V0R0F6dzU2SitpbnNhekNnTWtZRzZ4NlZWc3hDbDZ6aVNF?=
 =?utf-8?B?VDRaek1mekdaMWJLWHl6aDVzNk1GaGF4dWNUSDI4MUxXTUNkQkRiNWxESE0v?=
 =?utf-8?B?TklJWFkzRzYra2lqaVBlUi9XMFNReXEyYmRWclZwMUo2eDZyQ09YT1lEYnd6?=
 =?utf-8?B?blRGNkV6K2R5Z3YreTdUZWErbjJCdWtTdEJaUUFzaDdXcktLMUdQM0Mzc2dr?=
 =?utf-8?B?NUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d0bc99a9-804e-460c-f1c8-08db8e679bb9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2023 06:06:25.1386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a2bj+JEVjd3MCfyEkl5vt4ItKAsDuszPPIrMqwvFm9LTT67dw8TTaIKI5i8qYKS31TPmRrKr290sIUBaBfDLYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7416
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/26/2023 9:46 PM, Chao Gao wrote:
> On Wed, Jul 26, 2023 at 04:26:06PM +0800, Yang, Weijiang wrote:
>>>> +	/*
>>>> +	 * This function cannot work without later CET MSR read/write
>>>> +	 * emulation patch.
>>> Probably you should consider merging the "later" patch into this one.
>>> Then you can get rid of this comment and make this patch easier for
>>> review ...
>> Which later patch you mean? If you mean [13/20] KVM:VMX: Emulate read and
>> write to CET MSRs,
>>
>> then I intentionally separate these two, this one is for CET MSR common
>> checks and operations,
>>
>> the latter is specific to VMX, and add the above comments in case someone is
> The problem of this organization is the handling of S_CET, SSP, INT_SSP_TABLE
> MSR is incomplete in this patch. I think a better organization is to either
> merge this patch and patch 13, or move all changes related to S_CET, SSP,
> INT_SSP_TABLE into patch 13? e.g.,

Yes, I'm thinking of merging this patch with patch 13 to make it 
complete, thanks for

the suggestion!

>
> 	case MSR_IA32_U_CET:
> -	case MSR_IA32_S_CET:
> 		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
> 			return 1;
> 		if ((!guest_can_use(vcpu, X86_FEATURE_SHSTK) &&
> 		     (data & CET_SHSTK_MASK_BITS)) ||
> 		    (!guest_can_use(vcpu, X86_FEATURE_IBT) &&
> 		     (data & CET_IBT_MASK_BITS)))
> 			return 1;
> -		if (msr == MSR_IA32_U_CET)
> -			kvm_set_xsave_msr(msr_info);
> 		kvm_set_xsave_msr(msr_info);
> 		break;
> -	case MSR_KVM_GUEST_SSP:
> -	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
> 	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> 		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
> 			return 1;
> 		if (is_noncanonical_address(data, vcpu))
> 			return 1;
> 		if (!IS_ALIGNED(data, 4))
> 			return 1;
> 		if (msr == MSR_IA32_PL0_SSP || msr == MSR_IA32_PL1_SSP ||
> 		    msr == MSR_IA32_PL2_SSP) {
> 			vcpu->arch.cet_s_ssp[msr - MSR_IA32_PL0_SSP] = data;
> 		} else if (msr == MSR_IA32_PL3_SSP) {
> 			kvm_set_xsave_msr(msr_info);
> 		}
> 		break;
>
>
>
> BTW, shouldn't bit2:0 of MSR_KVM_GUEST_SSP be 0? i.e., for MSR_KVM_GUEST_SSP,
> the alignment check should be IS_ALIGNED(data, 8).

The check for GUEST_SSP should be consistent with that of PLx_SSPs, 
otherwise there would

be issues, maybe I need to change the alignment check as :

#ifdef CONFIG_X86_64

if (!IS_ALIGNED(data, 8))
	return 1;
#else
if (!IS_ALIGNED(data, 4))

	return 1;
#endif

>
>> bisecting
>>
>> the patches and happens to split at this patch, then it would faulted and
>> take some actions.
> I am not sure what kind of issue you are worrying about. In my understanding,
> KVM hasn't advertised the support of IBT and SHSTK, so,
> kvm_cpu_cap_has(X86_FEATURE_SHSTK/IBT) will always return false. and then
> kvm_cet_is_msr_accessible() is guaranteed to return false.
>
> If there is any issue in your mind, you can fix it or reorganize your patches to
> avoid the issue. To me, adding a comment and a warning is not a good solution.

I will reorganize the patches and merge the code in this patch to patch 13.

>
>>>> int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>>> {
>>>> 	u32 msr = msr_info->index;
>>>> @@ -3982,6 +4023,35 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>>> 		vcpu->arch.guest_fpu.xfd_err = data;
>>>> 		break;
>>>> #endif
>>>> +#define CET_IBT_MASK_BITS	GENMASK_ULL(63, 2)
>>> bit9:6 are reserved even if IBT is supported.
>> Yes, as IBT is only available on Intel platforms, I move the handling of bit
>> 9:6 to VMX  related patch.
> IIUC, bits 9:6 are not reserved for IBT. I don't get how IBT availability
> affects the handling of bits 9:6.

I handle it in this way,  when IBT is not available all bits 63:2 should 
be handled as reserved. When IBT is

available, additional checks for bits 9:6 should be enforced.

>
>> Here's the common check in case IBT is not available.
>>
>>>> @@ -12131,6 +12217,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>>>>
>>>> 	vcpu->arch.cr3 = 0;
>>>> 	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
>>>> +	memset(vcpu->arch.cet_s_ssp, 0, sizeof(vcpu->arch.cet_s_ssp));
>>> ... this begs the question: where other MSRs are reset. I suppose
>>> U_CET/PL3_SSP are handled when resetting guest FPU. But how about S_CET
>>> and INT_SSP_TAB? there is no answer in this patch.
>> I think the related guest VMCS fields(S_CET/INT_SSP_TAB/SSP) should be reset
>> to 0 in vmx_vcpu_reset(),
>>
>> do you think so?
> Yes, looks good.
