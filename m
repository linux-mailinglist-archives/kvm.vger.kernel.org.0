Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E621704337
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 04:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjEPCFF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 22:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjEPCFD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 22:05:03 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0903013E;
        Mon, 15 May 2023 19:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684202701; x=1715738701;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=p5Eyjtlbclyy4h+KSg2uP9ztkhhmRogTHiO1qm5s1bE=;
  b=XK3UYvQf5pzvtvXKncZvKWtSci+omMxEQGPabbtINx5MYCZ8BEFhbfN1
   irfFTb7Ny62hLoUuFy94ns6PGEy23NltrdyQ9EJFcoP7Jtqj+2ZG3EDI5
   u0mZamXZObAT1frf/nS1ZI3qfvh/f+tc0aygOJkT8NJCK7Xo94/OJSekl
   g6HWNIImTgYjVdbLMkMUNWQcueTs0vkP5+ItDPatgZoIF8TTj42Na+AaO
   McsdDt6QqyAB39ogYxX4V/LUsAC8CN2wVDHEu25swx6wyKKeCa6LafN6e
   NOHs6ZICWBfZvzFXzYVf7vrUUzEaB6Kf1+HJQPKEms5dQGppD6m9qVCCR
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="330974709"
X-IronPort-AV: E=Sophos;i="5.99,277,1677571200"; 
   d="scan'208";a="330974709"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2023 19:05:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="845508613"
X-IronPort-AV: E=Sophos;i="5.99,277,1677571200"; 
   d="scan'208";a="845508613"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP; 15 May 2023 19:05:01 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 19:05:01 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 19:05:01 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 15 May 2023 19:05:01 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 15 May 2023 19:05:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nd/BiMmVXTy1/mCsuv8YbQBYVJbcZeMCv7JOGdFAyDNBw6K/mbjyx93ZE/DYFyxEowE07z0EwAbfIxV/WIKA7gg6P6T7xvXPd5CbwciiavU703W40qsJ67hxAmqpyORvk038CfYwniZg2rG7l90bJ2SRCQjVPvx+/i+p904giOKTteJDsTcXGv0scx76EgA8iVYT8f4Bp17yzNAPvqIamQ23/86eoWIJmhvV2b36H34u1uOIW4euaUcMa+YPvzU+kVJlXJfmGtahpDmDhbJzzg8KZVj5qOjwkZUMuLRB752lMM18/R+ohjV0BcBpY5IYtHDa7zICgABZKgWSipjQFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y4Ss9VnId/oJs1TX9RLXO72pTQ/AJnxvbpU3mROcaJM=;
 b=MHsQIN/Yb9J6GCO9sG29tWO/fhEuWPbHbumoTLf3HgjpyQWgMVgkN4wGDgTkLyEqBP5busfdAoKT/p0LzvaoTmvYQu1n7ziMZVXbR1H3Lh12e6wl1DQjnJKLo/MpSK26mXJElgfl+jJ6GcEeqGcpRzy5rj1YsI99nc4BAz2QfcUzV7L0T63EN7KP6xPE/y87bFVZ2Zh+pt25PZ25r9pg4WiEimBtQMVd78kyGrlGpFb069hbu6QKDtYJ598biQaqIhoYQyvmY7EMQsM0uRvo4CiNMtWskkcWK5Hwxe/2SmW7Djw4yUB0cjkZGWoLClZFuFv9xzr9/Nx2xixenqIH4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by DS0PR11MB7407.namprd11.prod.outlook.com (2603:10b6:8:136::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Tue, 16 May
 2023 02:04:58 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%2]) with mapi id 15.20.6387.030; Tue, 16 May 2023
 02:04:58 +0000
Date:   Tue, 16 May 2023 10:04:46 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
CC:     <kvm@vger.kernel.org>, Jiaan Lu <jiaan.lu@intel.com>,
        Zhang Chen <chen.zhang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 02/11] KVM: x86: Advertise CPUID.7.2.EDX and
 RRSBA_CTRL support
Message-ID: <ZGLkvlx5W0JStTjD@chao-email>
References: <20230414062545.270178-1-chao.gao@intel.com>
 <20230414062545.270178-3-chao.gao@intel.com>
 <a88b2504-b79b-83d6-383e-a948f9da662b@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a88b2504-b79b-83d6-383e-a948f9da662b@intel.com>
X-ClientProxiedBy: SG2P153CA0021.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::8)
 To PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|DS0PR11MB7407:EE_
X-MS-Office365-Filtering-Correlation-Id: 44f32495-279a-439d-b73a-08db55b1f2c1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ccIoX/rkZRDI0MypHe9+nv7LjyOat01i45zCEqigAA8O2u6TNYYJpCGzKW4908ZaKVlfDQyR1J3DLMQ1v5bb3STlV+ieym8lsuwMAFHvyvl66WuaS9oxXjAMCUU9j0fsqZy/18JhS2W7VMNWrL5xY1r/cmo/FxQWE9G67J4jAoeJMBSURyA9DJhCuaEmI36Dg/u62KLmVgktHsMnVWItjh5mvpgdSTjngQzuRxcXuB1t1/dcN9Tvzsl/lc6Hp8JaDvtaLe71XJGkelpCv4++bwp2Q+QCQ5fuTI1yWbKDwWrNPgTYZLWklrTJ3vhLYd5PVsq9aa0RYuNg+d3OhmXuwuFRFAm3KF6rj0hAxqLc/+ELwlOdem37F6o27v/FrlCPCcNEch85WKfP3GMcw655SQTW3IAZRIgIZAgLmrwDwhNa0qLWYWDdvpTylWbG85m1GHe7lfZHKThLHb53dlEn4KC7DO30T1uRLO+6+tICnccdY4YuD1wgIrgQLwEB89HWjXf6u9SNBSeG28iWzfM0gjAwLmhGa+848zALd3OFcgvaT4c6tBYrv6JlgHiE6oU5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(396003)(346002)(366004)(39860400002)(136003)(451199021)(4326008)(66946007)(6636002)(66556008)(66476007)(478600001)(6486002)(86362001)(316002)(54906003)(83380400001)(26005)(186003)(6512007)(9686003)(6506007)(6862004)(5660300002)(8936002)(7416002)(8676002)(44832011)(6666004)(2906002)(33716001)(82960400001)(41300700001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5I+Uc/y4sjN2qNrWQq7vfAYiOB4f6amE9GKSc3Q/virjzHdFeKrFwOwNdTQQ?=
 =?us-ascii?Q?YkNa6qd/qIkS+nUNDSdoiVDUamhzqkp5cvh0ND3i2uDUQ3nuCmI1eOYfX0iT?=
 =?us-ascii?Q?ujOHkLu0wrsCytYCC5Xr0Qd9NHo8/Lv2edvVSPoEbeXvohjVgfH2ay7TgeO7?=
 =?us-ascii?Q?1jdIInr/0gN/97nlvJn+vd7nBKBHrrw3nRE/30uPlG0ATFLD1a8WHYtxpxUj?=
 =?us-ascii?Q?dx7HnoycUBqjQ0LcND3Mpoml61TusfR9Rda9BahxLrQze2RUsJkRtjNlydjJ?=
 =?us-ascii?Q?K2Dpjy6Uv0yWJ/CtLpdAjPywjVt8p8G5o37rQpXpLvLqBZzdL7BfXdBTdO/F?=
 =?us-ascii?Q?Vx9epFRxuXK9qZwR/6457bjbAfxYMjYOt9hfq1bpcBL0qYs+Q8q6fQbv4WTD?=
 =?us-ascii?Q?8Kpnz81SSXpNBt8d/yWfxdjltdvU3zdwo94tfjoxwXONi8GYX6L8B39Bg6XW?=
 =?us-ascii?Q?wWoJPCLnOTzte2TnmaWUjMce/Dl2Slv+HTaLtDxryG2gYnyGJiT+wkwKwTpV?=
 =?us-ascii?Q?dK6Qd2eGtAacwWCYR1+kkKT+oafi6GtPjujGkltvWJ7btAXlAeVdcKXRSiBP?=
 =?us-ascii?Q?inBgftn3Dx3Uj15Mr+tBllbk1iwt/ZKYz2Zq6JA2bTJqQ3wTMG2lfFqgBMUT?=
 =?us-ascii?Q?LyenBh52MqdnWVamGQ1/rcP74/4oKyXKoif1PVuVS4iSxDXvyzSuN2dOCRnA?=
 =?us-ascii?Q?tKxlhIkfZlgLemtQU1uVb4DkGqXAFI5J6HpsLhkGZ9IJlV7IB+0I9roI0QqQ?=
 =?us-ascii?Q?4Sewou9of7ft4HbQMol6fmUSD7g+Oiyah5k1u4HfkwdHJUH491O6Q7t4GpsZ?=
 =?us-ascii?Q?d7EAADoXmRDFlpu+vzaSpR1/XBypwUzde4aKfu/nZ0CBoxIjwp1/odpIEIBb?=
 =?us-ascii?Q?wb2L8YgG3ZJ/DkuUMwcKuE5tKdZ050gplTa4S124CNp7XKQ7+HJcHrs47QJq?=
 =?us-ascii?Q?zw3ovGv/muueIgD2/19Xy5V7zL+B/i3s1zvE4FV7oOPWe+G95it4+RHeSOK0?=
 =?us-ascii?Q?GhrFHUSX4bSzw51jdE5XBj5ZbBaRVQo/TmrwV3EYAjIMEnOpv9PVW1B1mj9B?=
 =?us-ascii?Q?2I+SwUcA2wPNZa+fO8FB8oYxrgv4JKwH8bduAumwhHD8N7RE6sXhrKDJFPFf?=
 =?us-ascii?Q?VRkz2z7onv9qkU3Byk6XqGkgqOT2+VCbdNe/rZiPmxzqzQAROIMnwm0Pa2Zs?=
 =?us-ascii?Q?cgcjts8qUDcuWzy79jCj6ntKCIDBISRaCxHxWVELYj75KtsFB13mS0ODJrNC?=
 =?us-ascii?Q?YZ4OBp5Lnlc2MrGPR8u3wwLm0Uok6/VubHmiVCufioNK/1qY2c+9KxODWyr6?=
 =?us-ascii?Q?vhxseapkq6PIxo9mf+P3zcCTZt+jHRIKbp4KyhGy9+FX5jWD00wmefQ4tT25?=
 =?us-ascii?Q?v13zVCimW+cUSw8PfH7mgecejXwBGxHY3eXQldQ7FJytMAy8IuYRGmMORVau?=
 =?us-ascii?Q?dxt0X4tTLFODoRGEIIl2PWQixH9Zgkm/3Eu/cB5hIBP6KH/sFIvshic9RIdn?=
 =?us-ascii?Q?cgzNY+TNQtAlwoJ0Z6Xd7ndSElSo5vzffaP6Kll+KqwD3rBE68mXcLh4NVm8?=
 =?us-ascii?Q?b0IZpTP2UBnB69gJ5Ff/Sfa8inkOeRndTNQUTd3b?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 44f32495-279a-439d-b73a-08db55b1f2c1
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 02:04:57.6993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YC4+rJJTDnAUeVnQSrpV4AZyAHIcFK8/wcSx8O5XRs0axo5/vBjj3VrFMdkuaP9ZOaHSU8oMmSnbdMr0SIFL9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7407
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 15, 2023 at 02:53:07PM +0800, Xiaoyao Li wrote:
>On 4/14/2023 2:25 PM, Chao Gao wrote:
>> From: Zhang Chen <chen.zhang@intel.com>
>> 
>> Add a kvm-only CPUID feature leaf for CPUID.7.2.EDX and RRSBA_CTRL
>> as the first feature in the leaf.
>> 
>> RRSBA_CTRL is enumerated by CPUID.7.2.EDX[2]. If supported, RRSBA_DIS_U
>> (bit 5) and RRSBA_DIS_S (bit 6) of IA32_SPEC_CTRL MSR can be used to
>> disable RRSBA behavior for CPL3 and CPL0/1/2 respectively.
>> 
>> Note that KVM does not intercept guests' IA32_SPEC_CTRL MSR accesses
>> after a non-zero is written to the MSR. Therefore, guests can already
>> toggle the two bits if the host supports RRSBA_CTRL, and no extra code
>> is needed to allow guests to toggle the two bits.
>
>This is a bug that also matters with other bits in MSR_IA32_SPEC_CTRL which
>has a dedicated enumeration CPUID bit and no support in KVM yet.

Do you mean passing through the MSR is a bug? guest can write any hardware
supported value to the MSR if the MSR isn't intercepted.

I guess this is intentional and a trade-off for performance (note that
context-switch may cause writes to the MSR). And see

commit 841c2be09fe4 ("kvm: x86: replace kvm_spec_ctrl_test_value with runtime test on the host")

it appears that this behavior is widely recognized.

>
>I think we need to fix this bug at first.

I have no idea how to fix the "bug" without intercepting the MSR. The
performance penalty makes me think intercepting the MSR is not a viable
solution.

>
>> Signed-off-by: Zhang Chen <chen.zhang@intel.com>
>> Signed-off-by: Chao Gao <chao.gao@intel.com>
>> Tested-by: Jiaan Lu <jiaan.lu@intel.com>
>> ---
>>   arch/x86/kvm/cpuid.c         | 22 +++++++++++++++++++---
>>   arch/x86/kvm/reverse_cpuid.h |  7 +++++++
>>   2 files changed, 26 insertions(+), 3 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 9583a110cf5f..f024c3ac2203 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -685,6 +685,10 @@ void kvm_set_cpu_caps(void)
>>   		SF(SGX1) | SF(SGX2) | SF(SGX_EDECCSSA)
>>   	);
>> +	kvm_cpu_cap_init_kvm_defined(CPUID_7_2_EDX,
>> +		SF(RRSBA_CTRL)
>> +	);
>> +
>
>Please move this hook up to right follow the leaf CPUID_7_1_EAX.

sure. will do.
