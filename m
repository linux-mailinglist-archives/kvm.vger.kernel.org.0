Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD5BB763001
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 10:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233345AbjGZIif (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 04:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbjGZIiL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 04:38:11 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52AD525A;
        Wed, 26 Jul 2023 01:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690360021; x=1721896021;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NNREqpAxxpzulyV10Km1zvlHepMeV5IZLVp5a3MjeXM=;
  b=X8j93kifo5QKL8wfKflDRGBelqEDhzIyYz6M7dJTWP5QdrlU52fYwTv2
   DTOf0HJ6XSzp32+EVw840Y2/WRj3sBHlLFiEGFHH9ZpF68UFxA343utP5
   TAN/a/F32HdL1ETfTV12OwI9zxYGts7zrt3+774EPXs6zUNxaqrxicd0r
   FphhLR0dPb776SJtxwt+XrCmzedKVkO9bLZljMYpvLoIDufXjR7kfIxjk
   oz4c3CfC26I13XbD79fKVQ000etZNUrJrPgSZB9ZHp7y6z5dxcYgudwvG
   NnDLB0x/TEYWPI7cMyz7AUjI8NDfeTlEpRpp5V93iyey3cLa0SdR4ucgN
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="348231914"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="348231914"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2023 01:27:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="761565039"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="761565039"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 26 Jul 2023 01:26:43 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 26 Jul 2023 01:26:27 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 26 Jul 2023 01:26:27 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 26 Jul 2023 01:26:27 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 26 Jul 2023 01:26:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GMQvhKStuhXc5co4+eW+EPCixbkQKTCqkHk5iBymDvbtjDnBpQGoK81tJd9bHaIrw5YbylmmgiVtOsWCMGQ7hkbCVhNgfjjpf7BYKGs5ILJcmJmW/2LLfJsYllR5/tS7+iSOj0N7J3PDPE3FX1m9zyGduh9CDiQQReb53N9nErViHWmtWOfdV9feGLrMpPvKaoex+zfgacDPmRDdqypoev8b3X4rD3OSjdw/AvHS/O73fDCIMlXi/Etn4BRWmwuCGcQ6bT8kRCj2R9X+r+/u6jnEqIrwLQtQeu8kzpBCqfPczS4J+PUpbM1v0vVv8lw/LEGwW7zEXmhrthIIGiPNbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IFL7xXuSWvv541gyoehD5NENqMQB2Ts4VS932tJgj8Y=;
 b=T4n1m2C1XwwrueFewEvEyL+8YutCd1hVXEc+nnnf3dTg070IK/uRsW5RJ3jhpwP3x+/ptfekEcHK0pXx35bF9zPtTZisnHw51+RY3nQxNE8vs6apWRSvmOJp8Tp/ENwJQiUcDdNO/IdbEyrP7nAO7lgjdfjEzJtQE9qqbSs+Ma4Aug6qT9YHCZeeUVicrL+lxNwyTHD4hWibgIBdpiPDS4qUQnqRW109dbwnxr2MV0OLxO1W8mIKpEGfHbj9x3AhTbD1xneaWVnoyuL0VzWg0iJIDEXCjpP8z8ipRs9iyLicXF9yvjp4lkMZHEpOL2LGoNBgLr1IvajFgvfXaPIH1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA2PR11MB4972.namprd11.prod.outlook.com (2603:10b6:806:fb::21)
 by BL3PR11MB6532.namprd11.prod.outlook.com (2603:10b6:208:38f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Wed, 26 Jul
 2023 08:26:19 +0000
Received: from SA2PR11MB4972.namprd11.prod.outlook.com
 ([fe80::2685:1ce9:ec17:894f]) by SA2PR11MB4972.namprd11.prod.outlook.com
 ([fe80::2685:1ce9:ec17:894f%6]) with mapi id 15.20.6631.026; Wed, 26 Jul 2023
 08:26:19 +0000
Message-ID: <67250373-c5f4-d1d7-9334-4c9e6a43ab63@intel.com>
Date:   Wed, 26 Jul 2023 16:26:06 +0800
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
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZMDMQHwlj9m7C39s@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KL1PR02CA0029.apcprd02.prod.outlook.com
 (2603:1096:820:d::16) To SA2PR11MB4972.namprd11.prod.outlook.com
 (2603:10b6:806:fb::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR11MB4972:EE_|BL3PR11MB6532:EE_
X-MS-Office365-Filtering-Correlation-Id: 4844bf55-52ac-4e06-e1fe-08db8db1fc7b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SLZttBvZeeYfGhUchpXmWi+JkgmbEZUBl5JjCE1DmevprLGhs4GzC+IBhAEfaq7kqrqJ3VHJ2CBo8zCVT3Fm0DyopWlbASKrJtd4m/8sxIUDHJ9fHaM+feZ5pw2ekZdCk5cHzjg8yqdBJqrXJoEEf6oK0aksc9XlXrHYnO6Yfz3Ce1/ss4f2H35rjcEjjZEScX3yVkF8DG16SyJGIdp6U83REtitLcQp1948Ekw9a2dLmI2bx0TvTq7X/dsuQ3Xjs/ENT2uyouM3QAUPD7bbLBYIT3Rcg0lmVqcgm63qUfZ/Ft/eZlPtXtZ332lDuhqX7T1p9ikvYU5GzlX8PtZ6Y+3+6jz15TIGzb16Mw4RuUh4SZ8WwC61dyU2aV+JDLQ+uY5sgIBd1Ylvmd08YMa+oBhEJvvaKftlwEvaqHHReIGVX9GpYHUiiBN1PasNVF3Fw3ur+gTNzj718pwOEHfFOLFrBTAzVeEUP+4omY9RyRClPYWZ79n7Ic0O2Y4zPkO6fr0PQXutWkZA8AD4Sm+0jcKtnoXYFVj00gUgTJj0KN7NryFXI3zHTEWOMEVwH3eoTUVAVEcCF2nPlb07MBbTrqno/Vo8Om4jErbqbdERvsbRed7m5UNmmaMARex8c+tzrPgjFdlux6OY2R9N0HVBrQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB4972.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(396003)(346002)(376002)(39860400002)(451199021)(31686004)(6512007)(186003)(2616005)(53546011)(6506007)(26005)(41300700001)(6636002)(316002)(36756003)(66946007)(6486002)(4326008)(5660300002)(2906002)(38100700002)(66556008)(66476007)(8936002)(6862004)(8676002)(83380400001)(31696002)(37006003)(6666004)(86362001)(82960400001)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UFlra2JhL3p0eDRrR3VscDVrQzZxQkJGSTNjYWFBeGZ5NnhZNFh4eklyU0xZ?=
 =?utf-8?B?eGh2bEJSbzVKang1czhUV1kwK3lKc0JPNk1wRlY4bXdQb3FDOGFDNXN0djBH?=
 =?utf-8?B?blNlaERxYnV2ZCtSY2lKZEZPQW9OUjZXS2JlNEplY3QvZUx2ZURyTURybEdN?=
 =?utf-8?B?WmpKb0l0emFsMjh0UXVZL3FVR3N1RFFoMXRpSHo0dDR4NmY3V2k0ajd6eUhp?=
 =?utf-8?B?TnMwRUlPWFdRNUdjS2tCUE4vZGczazNDTUlOcEo3WDY5U2llNFZXRUNneHdD?=
 =?utf-8?B?aktoOEJIRUUzTDN6UDVqSi9XYTA1RHU4MWdPd1VoZlc0M1VxZmJoQThtV0hy?=
 =?utf-8?B?b08yOXAxMmdOT0xXNExXUytMNElGWjYyOEJVWWlKSGtKM3BwWE1ja1pmRjNH?=
 =?utf-8?B?NlJyakVuQVZseVpJbjVackhUODJQZktyQjhRQWZiVUZkQWdYYlFlR1F2bURH?=
 =?utf-8?B?Nmlvd3JoTmp0UEpYeTB6SjdNeTUzU2FmRzVxTUYvTlR4QXAyT0lRc0JMTjBM?=
 =?utf-8?B?OTROWElrZFVaR01SY3o1SUxybllDUHRJQlEvcjBXOTJpa1lUM2k1VVNBS1U0?=
 =?utf-8?B?VnFkcVBrZ2w0bVZEcjIrQnFGNDNNWGMzV3RxMkJ6Q1laVWdhRTZFc0Jmc2Z4?=
 =?utf-8?B?TkF2Z25NVnNWTWgyMFh6UFZubVNHMERGQWN5M3c0QTRQZHlySWtXeDhMaEc2?=
 =?utf-8?B?RXV6UksrZkNCdHlxR1ArK0tBOWdweHJpRld6V2QzUkgwS25GQWp0NGlzeFg1?=
 =?utf-8?B?ZHZiU2QyMTFXdnpMMmc2SW9Ub01iL0hPU1FyMUhITGRBR0d4VXNFcHJVMnIx?=
 =?utf-8?B?M3BOWlMxeU8vY0lneVJFUXlHUU8xM0dPUWZTU3pGaWV6N0VCNnRHRmxKZmpk?=
 =?utf-8?B?S0FSZHFHaFB5Y1dxRTJJNWpldVBoeVUvSmRnWnpjbEpEeWozMTl6N0dHeWdh?=
 =?utf-8?B?dHlzdkl5OGpaT25uL043SEJSdlAxTnNrZ0dGRXMvK0pCeE1wMWdsc0VqYlhl?=
 =?utf-8?B?NW1VVU1NTFdYK3dlaFZGa1BNK0h0cHd3enZ2S2dIZUFqb2J0VERGbVUvcEZD?=
 =?utf-8?B?WlkrNEptT1VaOVFoKzdqUWZUWWdmOGRUdldUTG96MUFmSUpENEcvVjNpeFZY?=
 =?utf-8?B?dEVJc1dUdHVaOEMxSUg3aHdPeEpEK0RrdGVjMjFIWVIycmVZZklMS0VXWUdk?=
 =?utf-8?B?SUN1dkJPY1VhbjBVRy9CMDJCUmVlbmtlSGY5U0hjRG9odW95TnhnM3VRcGZC?=
 =?utf-8?B?c1FDR2JIL21makx3bytVbEo5UHZaL2xwaUt3eVFTcXFkTW8rVnJ5bkhZL1FG?=
 =?utf-8?B?ZjZLcXY0c2lGTFdUQ1IvaE40ZjNXWGtPK050TmF3WVRLZmhlQlJ1ZUFCZ094?=
 =?utf-8?B?VkFSdWQ0Q2R3WmlIby9JZVNMK0laa0NSc3NOTnlXK0l5bzZKVGw0ZXNBcVJM?=
 =?utf-8?B?N2FHV3gzek84cWlxemw2b1ErYk9UcHFpeEdOY1RJSlhPc3RqbXJoS3doNEpr?=
 =?utf-8?B?WG9YVTZxSVRUQ1lteXBGY1M4MXlQd1ZaL2VNNFAxNHZxMVJtSDRuNmRiOEJt?=
 =?utf-8?B?MVAvTDNyQXNOazZ2UG5XR3RkNStNVVBWS0FDTlZmOElQOXZmdEhQOWxvUkNX?=
 =?utf-8?B?SkFBT215OS9pbjlFNVorVWZ0U2hsbFZlV2hrQ0ptYUlmejZhU090Tyt0Tjg3?=
 =?utf-8?B?UnJQLzRHYjk1QTZCY3NYb0tHWGtSR0VXM1B0KzhIV1NGWG40OHd1N0lZUUNL?=
 =?utf-8?B?eVE2ZDBneURZNjdCb1lCbi9xYTMrWm1rWjExcmdkQ2RjcjUyWlk1VE1NaXU2?=
 =?utf-8?B?QWtMSHU0cDVFSFFFOVkwWDlTcXFFZ1FHWUVoMWxxVHZlNUd4ZXJsYVZqeUpu?=
 =?utf-8?B?NmZKaW9LdWEwWHk1d2J1ZVA3VzZmeFRYSFVsZUI2VzBNcklRTkZtRTBqVzFP?=
 =?utf-8?B?VS9GOFgrSlZkQnZIcHQ0aFBSZGUrUWp4WnhocHFhaHh0MGxRMk9manRrNWRp?=
 =?utf-8?B?SXMvVlloUDQrTTVibEprKy9Kb2xtYkhYRFpWUitqeC90RzJHQlk0cVR1V2ph?=
 =?utf-8?B?Qkx2eXM1dGpGL1NRZm8wd0xCMmdyZVVRZXpOY0lZSDZjcklhODkxNkR5VkVa?=
 =?utf-8?B?WW5vSzRNRk9Sd2N1Tmkwdld0RTY0cEhFaE9RbjZyUThIQlAvZ0NTRzZ6U21i?=
 =?utf-8?B?Z2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4844bf55-52ac-4e06-e1fe-08db8db1fc7b
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB4972.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2023 08:26:19.2030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gRTIyUA6QN+1v+v1jIzxCOSZoGmaA4YeGyI0pzInW5GFQiseoS32Bx1iKaFoYJmav0yWfVpKfKg1/eIrDX9pkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6532
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/26/2023 3:33 PM, Chao Gao wrote:
> On Thu, Jul 20, 2023 at 11:03:41PM -0400, Yang Weijiang wrote:
>> +static inline bool is_shadow_stack_msr(struct kvm_vcpu *vcpu,
> remove @vcpu since it isn't used. And I think it is better to accept
> an MSR index than struct msr_data because whether a MSR is a shadow
> stack MSR is entirely decided by the MSR index; other fields in the
> struct msr_data are irrelevant.

Yes, I should have removed it, thanks!

>
>> +				       struct msr_data *msr)
>> +{
>> +	return msr->index == MSR_IA32_PL0_SSP ||
>> +		msr->index == MSR_IA32_PL1_SSP ||
>> +		msr->index == MSR_IA32_PL2_SSP ||
>> +		msr->index == MSR_IA32_PL3_SSP ||
>> +		msr->index == MSR_IA32_INT_SSP_TAB ||
>> +		msr->index == MSR_KVM_GUEST_SSP;
>> +}
>> +
>> +static bool kvm_cet_is_msr_accessible(struct kvm_vcpu *vcpu,
>> +				      struct msr_data *msr)
>> +{
>> +
>> +	/*
>> +	 * This function cannot work without later CET MSR read/write
>> +	 * emulation patch.
> Probably you should consider merging the "later" patch into this one.
> Then you can get rid of this comment and make this patch easier for
> review ...

Which later patch you mean? If you mean [13/20] KVM:VMX: Emulate read 
and write to CET MSRs,

then I intentionally separate these two, this one is for CET MSR common 
checks and operations,

the latter is specific to VMX, and add the above comments in case 
someone is bisecting

the patches and happens to split at this patch, then it would faulted 
and take some actions.

>> int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>> {
>> 	u32 msr = msr_info->index;
>> @@ -3982,6 +4023,35 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>> 		vcpu->arch.guest_fpu.xfd_err = data;
>> 		break;
>> #endif
>> +#define CET_IBT_MASK_BITS	GENMASK_ULL(63, 2)
> bit9:6 are reserved even if IBT is supported.

Yes, as IBT is only available on Intel platforms, I move the handling of 
bit 9:6 to VMX  related patch.

Here's the common check in case IBT is not available.

>
>> @@ -12131,6 +12217,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>>
>> 	vcpu->arch.cr3 = 0;
>> 	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
>> +	memset(vcpu->arch.cet_s_ssp, 0, sizeof(vcpu->arch.cet_s_ssp));
> ... this begs the question: where other MSRs are reset. I suppose
> U_CET/PL3_SSP are handled when resetting guest FPU. But how about S_CET
> and INT_SSP_TAB? there is no answer in this patch.

I think the related guest VMCS fields(S_CET/INT_SSP_TAB/SSP) should be 
reset to 0 in vmx_vcpu_reset(),

do you think so?

