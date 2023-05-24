Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C920270F10F
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 10:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240392AbjEXIel (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 04:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240384AbjEXIdt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 04:33:49 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B721810D8;
        Wed, 24 May 2023 01:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684917182; x=1716453182;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=6v4GTWximi0NzG7CS3X91Uy1w8dDV1NMiSdwYUw2pQg=;
  b=X44hu58jb+xNNNfvtHH2Bmm6dlHrg853MZiSCi1DgJA5kupMtJcpFW6P
   u3n2WEX/ZWpLC+mFPatdYlWWRlt/+W+s6w5VW/bhyRZNEQ+rmfMRNOACD
   oMLLG4Us3PVkuM3Qeuw8K6UalGPlKwEtoijAYi2tfXsxJgs7jaTsWm7Mb
   YUcgxxorDP7wTeT68ddAVzBPNq8gpOD6tYqLKZfo9lxsik1JLFspYZkA0
   m6dQTve8Fk6fftdokq9P1Pa0V+VdvN6eeL8xJOXe5bszowDy8Ki7Pe+bL
   RuCs5g7U6eE7O86lzJZOQK0v6m1jGUBzspZpHiwBHsKdhgHfMOFvzDmpB
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="416958744"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="416958744"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 01:32:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="681787189"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="681787189"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 24 May 2023 01:32:50 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 01:32:49 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 01:32:49 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 24 May 2023 01:32:49 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 24 May 2023 01:32:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GNr1IxZadr4eoK/2V0Vx70RHEK9srnDYLyLo29ub47xCs+CvEBCMYDu4oBPKSFKvVwVnGNM1cP4dNTm5UXRXwMg3KYiECt32tZkq32FgZarBDQp0Dui4gsxEeyPddjCf6wVnQgdDhBOZe6hB2tTJIIgEhmCXXma05XbEgga8rwgO3g8YTBMLLR4zSecLWP/bPNY4xuxrXNi1z6uayvagfhqA8oKP2MRajpPTDvEQf5lghJdD8LwB6WJBt+TGOpvZlUnRUHc+9f4YqsOZQyujhH91sAYlYidQCKql3LCf+o4OTPNGZNeZn1a4FblR5ua+urxoyMbixhP6B03w+jwWZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V9WqTCx1A7kMlIIWIrqUaE/Vm6KGsQnmXASUFMGZLyk=;
 b=Y3NpZ0IJBaHH7WohojW5TqzLMvBsC1wdX0WXFQ3ODfDHTI3UmRTJPvDu9IyCOgN+7OmeBk1bqL7Je6MMtv9xNmy0qQ+D3wMhStmtmZJ9sEbh5Gsm7bzxTXPmAP8NZwdMZ8PRCdazYa4jYgqd2opk/xvjJFko1PeaxWgrOnnUIffAqpqbBD/fLSkrJsjEtIPmm3ndCK6FfPVd/xVTd2lrSpUZRDQx5sFHOKkCzfdqiVpEUKDmJ3ih8vXU8/WHYnGx0wd9Lh1vkhs39oK51u442Qd60JuUIDgFv7Yw4VpGoc5hmTJngD9eJGdHTsYFYj7TOg6rS84T5GtsPUWbWgJStw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by CO1PR11MB4993.namprd11.prod.outlook.com (2603:10b6:303:6c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.29; Wed, 24 May
 2023 08:32:47 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%2]) with mapi id 15.20.6411.028; Wed, 24 May 2023
 08:32:47 +0000
Date:   Wed, 24 May 2023 16:32:36 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
CC:     <kvm@vger.kernel.org>, <x86@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] KVM: x86: Track supported ARCH_CAPABILITIES in
 kvm_caps
Message-ID: <ZG3LpLR7itO4dI8U@chao-email>
References: <20230524061634.54141-1-chao.gao@intel.com>
 <20230524061634.54141-2-chao.gao@intel.com>
 <fc72da6d-2f70-63c8-dd6b-f8f8df862b89@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <fc72da6d-2f70-63c8-dd6b-f8f8df862b89@intel.com>
X-ClientProxiedBy: SG2PR03CA0127.apcprd03.prod.outlook.com
 (2603:1096:4:91::31) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|CO1PR11MB4993:EE_
X-MS-Office365-Filtering-Correlation-Id: a69258c7-dad2-47eb-14bb-08db5c3173c5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u/u3Jvu4tQHbCHLwgtVPwZpadzkNsuyM0YTqqiTiR1ZYipIqsbE7uukRUEeP8qZQQtGdN32Sz/6yOzEtM/hpHc1zv6r0kz224etBEH3o0dmKeS+g3IJYgp4hbSHYUU13IB8E/tXtfzPfUXSGdDe+WIzjtLshs75+EgbiuRpJZrXLS/43xfcJMsW9X39YJcHp8/GsupE9cH5bvMS5M16oRO66w63cxGl+UxF27fRW+cAGjuhUwL7UuSyO9NkSrKdlI19von9UCukwiSjaNB13Abszl9sHQPUml0/WVnR6zWA+Kq6YF2zPpx4zt+hgwdmaCIz1ldPDljfPcFyK5o2fkA895dAF0FcC3vxpZHp6LwU4c89MPbAC1ztvUOljfQaUrCYBsjlFvSrwgrIHMupEyO8t8dPO4g4P0vaDcVyalgAnEg/8GkY+4eG8bgAWyERPOnZwBacmsiTMtAhUtOKCo8B5yA9LXP+gCTEL3Koci4Buccx1TKvZXSRf9hg8cDfvqM0RL00Pbbc3Lbi8NGeN/QAPy/t8baIbQVDPwMiqeMu95gV7cMHOmllxgSCy2OKh2Tyo60TRiEs/ihosEG0R4xo7ZeVtVnd0mjNcjaQ33zLu2nbq9vujhW7Lfgu6YliW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(39860400002)(396003)(366004)(136003)(346002)(451199021)(6512007)(26005)(186003)(6506007)(9686003)(7416002)(82960400001)(44832011)(83380400001)(2906002)(38100700002)(41300700001)(6486002)(316002)(54906003)(6666004)(966005)(33716001)(478600001)(66946007)(66556008)(66476007)(6636002)(4326008)(86362001)(8936002)(6862004)(8676002)(5660300002)(473944003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?idDkYBwnkvqi9HMosIqvClEH1wOSUFEbA7OswAKFtVDBgdrqlLErC2Qv17o7?=
 =?us-ascii?Q?RYbzqvfKV2YYmVSolGU/a66mgkS1SfgKAEolJAXuHtVd3JhNHoVQY6MgzQLq?=
 =?us-ascii?Q?1NnoVN9Xoz1WaFfqkKcFx4GyrQxWKUPPzHpSGi4W6DWmYMegHHBUu87iQ/Oi?=
 =?us-ascii?Q?9FnEXLXyOK5PXrTPhbry/M3gn62MotKXjc3apMYY1vTkmHSHUFvDXl61UzxN?=
 =?us-ascii?Q?rgLd3jk+imexQmk1VHQHEj8VuNk8qAH55qQpSVuY2KSxz6JZNWFXbXx8Pz+u?=
 =?us-ascii?Q?bGFmX6+SxGzEegTqCMdVvuTcUMWbXhJowYU9JjtqhgzCB6NkTM9t1SU3m/ht?=
 =?us-ascii?Q?6dIM6wPGnUywQ7R4SUhnoatqmkdLtu+nFOEmwmmTtuqzkb7uUK3IgMHDq8Wf?=
 =?us-ascii?Q?EGWq43ZG3nQfREnCkjOamHCHKnIkhwSQUvb7yKZQR804jcKStJCj39CWbgzh?=
 =?us-ascii?Q?P7cKMR+LR92QJ2EykaQg59YEcL7X6WGp7gkU7Cclp5AKqm/dNaJH7H4aog2y?=
 =?us-ascii?Q?h45L/qn/yzGDm57BzWDJ/N9IrhTyYLb6xKlqNZRQ0XlzT6CoFxc1uL0YPHTO?=
 =?us-ascii?Q?HNO7pQqMcPzs++rQ6P229aRpzaq9mFiU7sfyPNF6FNjEPzZP1AmsAkq9NoxK?=
 =?us-ascii?Q?0LyxMRj+QfL9io/skSK9gj6TFPDWZSiEiOljUlNa9mQ1QZJtXNBXxS2y3EH5?=
 =?us-ascii?Q?qq8B+SCIYFTb7kDInyvc2r9F3nOQfIWGM/nH7jcrwEPGMLnPvw8KoZmVdLAU?=
 =?us-ascii?Q?t1rBCXHuNLxHKr9w+VJEVHZAAnLprgwvGjppu0hBZk46zcNFIUR2N/wdVqa0?=
 =?us-ascii?Q?vce3GaFH4b2vH/PS9P9aYNLXu+QEdFLSboB+ift1wg+CPFbiavAgClmBF/1c?=
 =?us-ascii?Q?dRbf2Mda2qVhzM3qLJ7MzNjmdOyoT/YBvoewLXk9nOFVs7+O8A4FHYTNrrHv?=
 =?us-ascii?Q?jSj8VCCVALYXPQcUKx6b/nqadF1jYjeybu8C0UWeYXkFLXbiIO/sH7UwdAQ9?=
 =?us-ascii?Q?e3sfbUcEhmy7rYKxJzAoOHLBe1DeB0KbT/BtA+q/oUbzD+GzXBS8O+gsfPyy?=
 =?us-ascii?Q?gcizhU4Hgt8WeH2dZocv0x1IP3ffOvPTw2EJKvdzYF6GsunwNSbyHWpcq92G?=
 =?us-ascii?Q?Wf4/BqYbbAwMsDVaT2WMSbIAn6IW+yJMLOyQhwLd6APu9xgxw1BlIltBDdeM?=
 =?us-ascii?Q?CoTj+W8ZFnibHPazzrURl0EnPTJuDd0oVsns8kMSGv5JnBEjaw45eMsdk1BR?=
 =?us-ascii?Q?+GD3OLRe5bFaFOrOj11oDKART31HqCKyZxggR9ZPkRw03dONWFflIVZcJ/Gx?=
 =?us-ascii?Q?sb9bQd9y1CjIyWLMeMYc/ovDUlrV7hvckgXGW3YhjjViClDknuNCm11seiC7?=
 =?us-ascii?Q?ySGUhSQZyvnx7Lg62CqCEkn/CrrEvSsSqn3/06nx8sxpmwq6i1W+KLo32N9g?=
 =?us-ascii?Q?TvdNvQiRGrvkVLm7Rpko2ECrXM8jD8k9Vn7nP+20onoyw24O1pBl+AwDOlC9?=
 =?us-ascii?Q?2VeaNI+l3OD/aos+ImRVZXAcIpw7IvvjY2L70vcYft55DF+pnnyoOzrKc3fq?=
 =?us-ascii?Q?6NAxlScsUT4BdTEPgHjYtg+m+8/dZqGyrztmDTCB?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a69258c7-dad2-47eb-14bb-08db5c3173c5
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 08:32:47.1669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 91DvpMC28/h/vGwKqQIcYAjJ7MxrqVg4MzgJaFRBx0Mjoojb2i3ogc99UJmCucMl6JKHk/r3/wY5LgCHn80xfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4993
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 24, 2023 at 04:14:10PM +0800, Xiaoyao Li wrote:
>On 5/24/2023 2:16 PM, Chao Gao wrote:
>> to avoid computing the supported value at runtime every time.
>> 
>> Toggle the ARCH_CAP_SKIP_VMENTRY_L1DFLUSH bit when l1tf_vmx_mitigation
>> is modified to achieve the same result as runtime computing.
>
>It's not the same result.

it is because ...

>
>In kvm_get_arch_capabilities(), host's value is honored. I.e., when host
>supports ARCH_CAP_SKIP_VMENTRY_L1DFLUSH, l1tf_vmx_mitigation doesn't make any
>difference to the result.

... l1tf_vmx_mitigation should be VMENTER_L1D_FLUSH_NOT_REQUIRED in this
case. l1tf_vmx_mitigation cannot be VMENTER_L1D_FLUSH_NEVER.

>
>> Opportunistically, add a comment to document the problem of allowing
>> changing the supported value of ARCH_CAPABILITIES and the reason why
>> we don't fix it.
>> 
>> No functional change intended.
>> 
>> Link: https://lore.kernel.org/all/ZGZhW%2Fx5OWPmx1qD@google.com/
>> Link: https://lore.kernel.org/all/ZGeU9sYTPxqNGSqI@google.com/
>> Signed-off-by: Chao Gao <chao.gao@intel.com>
>> ---
>>   arch/x86/kvm/vmx/vmx.c | 25 +++++++++++++++++++++++--
>>   arch/x86/kvm/x86.c     |  7 ++++---
>>   arch/x86/kvm/x86.h     |  1 +
>>   3 files changed, 28 insertions(+), 5 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 44fb619803b8..8274ef5e89e5 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -309,10 +309,31 @@ static int vmx_setup_l1d_flush(enum vmx_l1d_flush_state l1tf)
>>   	l1tf_vmx_mitigation = l1tf;
>> -	if (l1tf != VMENTER_L1D_FLUSH_NEVER)
>> +	/*
>> +	 * Update static keys and supported arch capabilities according to
>> +	 * the new mitigation state.
>> +	 *
>> +	 * ARCH_CAP_SKIP_VMENTRY_L1DFLUSH is toggled because if we do cache
>> +	 * flushes for L1 guests on (nested) vmlaunch/vmresume to L2, L1
>> +	 * guests can skip the flush and if we don't, then L1 guests need
>> +	 * to do a flush.
>> +	 *
>> +	 * Toggling ARCH_CAP_SKIP_VMENTRY_L1DFLUSH may present inconsistent
>> +	 * model to the guest, e.g., if userspace isn't careful, a VM can
>> +	 * have vCPUs with different values for ARCH_CAPABILITIES. But
>> +	 * there is almost no chance to fix the issue. Because, to present
>> +	 * a consistent model, KVM essentially needs to disallow changing
>> +	 * the module param after VMs/vCPUs have been created, but that
>> +	 * would prevent userspace from toggling the param while VMs are
>> +	 * running, e.g., in response to a new vulnerability.
>> +	 */
>> +	if (l1tf != VMENTER_L1D_FLUSH_NEVER) {
>>   		static_branch_enable(&vmx_l1d_should_flush);
>> -	else
>> +		kvm_caps.supported_arch_cap |= ARCH_CAP_SKIP_VMENTRY_L1DFLUSH;
>> +	} else {
>>   		static_branch_disable(&vmx_l1d_should_flush);
>> +		kvm_caps.supported_arch_cap &= ~ARCH_CAP_SKIP_VMENTRY_L1DFLUSH;
>> +	}
>>   	if (l1tf == VMENTER_L1D_FLUSH_COND)
>>   		static_branch_enable(&vmx_l1d_flush_cond);
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index c0778ca39650..2408b5f554b7 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1672,7 +1672,7 @@ static int kvm_get_msr_feature(struct kvm_msr_entry *msr)
>>   {
>>   	switch (msr->index) {
>>   	case MSR_IA32_ARCH_CAPABILITIES:
>> -		msr->data = kvm_get_arch_capabilities();
>> +		msr->data = kvm_caps.supported_arch_cap;
>>   		break;
>>   	case MSR_IA32_PERF_CAPABILITIES:
>>   		msr->data = kvm_caps.supported_perf_cap;
>> @@ -7156,7 +7156,7 @@ static void kvm_probe_msr_to_save(u32 msr_index)
>>   			return;
>>   		break;
>>   	case MSR_IA32_TSX_CTRL:
>> -		if (!(kvm_get_arch_capabilities() & ARCH_CAP_TSX_CTRL_MSR))
>> +		if (!(kvm_caps.supported_arch_cap & ARCH_CAP_TSX_CTRL_MSR))
>>   			return;
>>   		break;
>>   	default:
>> @@ -9532,6 +9532,7 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>>   		kvm_caps.max_guest_tsc_khz = max;
>>   	}
>>   	kvm_caps.default_tsc_scaling_ratio = 1ULL << kvm_caps.tsc_scaling_ratio_frac_bits;
>> +	kvm_caps.supported_arch_cap = kvm_get_arch_capabilities();
>>   	kvm_init_msr_lists();
>>   	return 0;
>> @@ -11895,7 +11896,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>>   	if (r)
>>   		goto free_guest_fpu;
>> -	vcpu->arch.arch_capabilities = kvm_get_arch_capabilities();
>> +	vcpu->arch.arch_capabilities = kvm_caps.supported_arch_cap;
>>   	vcpu->arch.msr_platform_info = MSR_PLATFORM_INFO_CPUID_FAULT;
>>   	kvm_xen_init_vcpu(vcpu);
>>   	kvm_vcpu_mtrr_init(vcpu);
>> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>> index c544602d07a3..d3e524bcc169 100644
>> --- a/arch/x86/kvm/x86.h
>> +++ b/arch/x86/kvm/x86.h
>> @@ -29,6 +29,7 @@ struct kvm_caps {
>>   	u64 supported_xcr0;
>>   	u64 supported_xss;
>>   	u64 supported_perf_cap;
>> +	u64 supported_arch_cap;
>>   };
>>   void kvm_spurious_fault(void);
>
