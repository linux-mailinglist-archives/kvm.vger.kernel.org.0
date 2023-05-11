Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC016FE9EB
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 04:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbjEKC4o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 22:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjEKC4m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 22:56:42 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E374C3E;
        Wed, 10 May 2023 19:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683773798; x=1715309798;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=uHbo7SZwnztZT6N/t4WrdDvU7dgsFQBhTQlljuDYpBU=;
  b=SxvzJlgnhMqAHCWrqd6dk+gvluwALfWzUCIvNbfJ99ZTfYJNafuBnE2B
   pdMFlRO+aiEPJHDYZr0yj+xVeLLVTnR2CcGwugkEmvvo7I36s445uCR5c
   0hGjF7HRX3P3flL5K3xS7EXExUUUs1Hw+unGAkUgGkz052NOGO+AXLSg1
   1sPgZN0m5BwNYT5u/YY7cG+tpqnKurGhwYlBeuBpPB7xkyN09I3mSU7ZK
   QQktIaAvqL9ovLCr0Qn2b6THjyemBp3ewBobSgkgN/5yErb3RUJMjn1hW
   tqeDD5fItpVHt7CPwWma/XddbBFZlXUF+HdbTWzwM1qsJGMZgB/iJVG6Z
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="349214325"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="349214325"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 19:56:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="811401416"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="811401416"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga002.fm.intel.com with ESMTP; 10 May 2023 19:56:32 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 19:56:31 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 19:56:31 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 10 May 2023 19:56:31 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 10 May 2023 19:56:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TLAX8BBS7rLWhDknnN3YLuHRz48561j/nhNfA5KC8s2+Dnz3kTsUNU/0Go9Nlk/ruYAGsw3hx3N0FIGKvYSzwlcIq/+8KBau16iH+5QCxuwKwauitQtUYKyY7ByAjmx+yEcdS5QphHHBBqbv3X/q9rSgj/W2RmjVE6hbO1AQRRXg9upgb2RbfScrEpg7EdmeJ2Bf60g8VJXJsSnxjtxglufb76r9zh1UoHwDE12RJBM2LQ9mIp1vbQSGLF1/BGv5CYxJqlF83rEa9CgF9HebcZ44t7w5rinBM7b75/22KzmSGCWvmGeJYYz4MBNeg5PMtwfkAt9Ub+0uGlm31XxdjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yBQaCyP9dKMU7dF2fuDeV7TKmXtprNGhAKZSvJPoifw=;
 b=XexIAGFRvEOPKimKcgylK8w5FW6A/6E9vfeQCVodumiRjt3A+tROA7iy7gM3+zoDE7a9+OQtE/f2+UrY9b8f2vr3CHR1t4b324hv296ofH13u3y7uJWELojJbr/f27f6Mp5/QOCVXf1tAJOKCJPT2uEU9mDoHVXZV/jp5bC3f9mQI1BUEpuiOLLo2kPJ0sXM3xNFJUhxjrPH+1eMzNrM9szFIJxXoLh6n3uYkrRVBZYKFahej9KK5dHSYGhcTMBlRejsq2hH6yKr8sHHI/ufaveqOanLQlTXJ/AKTCeVoO1+J+dOTPOaeCSp0BL9SiMO6pjJCdx9NnRktvtUnRe1Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS7PR11MB7781.namprd11.prod.outlook.com (2603:10b6:8:e1::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.20; Thu, 11 May 2023 02:56:29 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4%6]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 02:56:29 +0000
Date:   Thu, 11 May 2023 10:31:25 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v2 3/6] KVM: x86/mmu: only zap EPT when guest MTRR changes
Message-ID: <ZFxTfaWRCfswMzMv@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230509134825.1523-1-yan.y.zhao@intel.com>
 <20230509135143.1721-1-yan.y.zhao@intel.com>
 <ZFsuDWwoKRA0W2/j@chao-email>
 <ZFtPKLvblLcxPvZQ@yzhao56-desk.sh.intel.com>
 <99c982ed53f0dd7e0723f566b5527091b7e4e54c.camel@intel.com>
 <ZFwzq/833QX3n9xc@yzhao56-desk.sh.intel.com>
 <077fbb11f0a74850fb46abe4fda31414db66539a.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <077fbb11f0a74850fb46abe4fda31414db66539a.camel@intel.com>
X-ClientProxiedBy: SG2PR01CA0179.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::35) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS7PR11MB7781:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c166368-3dcf-42a6-7779-08db51cb517a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ErD8e+YVJ6gEB3lHHZd9Vvedpiv2vhU+i77oclE/NF+wRLZYzSrsvIPvUom+9U697ztc0q9B2wZ4GMI7to/v9dtEp/TxI8B4tbJ2C+UzEp1jWErNZYihyA/ObXeqpNEO0faIwlMBVtUTtSgxAzvz0l5VHaZPkNmALBvFaX7pGGj4oPe20YiTapXxYsqVNjXOWjjWwWBcP7Vyb+H+nm/atEckcFMl/hqRJ2iza904gd9JPfWiVtcNvme7Odjo8nuHd5p2NNFjXLdux+VhpAXVcoTX4uP7+3aqTrLjH1CiOJRdVlO9nD09PkIFhFUGbvzDKLCaiXAeVy9rCaDqLHvsQzw800EEoKMiY9fApOSD/Z8V8phuI+MpTsgkzgOnPLAb1Ged4iBAjmhYbUObHH8z0Bb0zA7e1tXcFKEjtdeTvPkvuBHAXp6P9A6OFVOIUNmRlFzk5xevuPY+xoaf0GmYCSVQHxwGkOqymoVxV5odA1Ka1y2sHGYf3nw4NOP+nVix6f61F13cSuqZpPAKGVYIl89Ql5zO6RSI0vs6qq29Yy3khiHSHNCiyvHbl2oNEfGI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(39860400002)(346002)(376002)(396003)(451199021)(82960400001)(86362001)(6636002)(54906003)(38100700002)(83380400001)(186003)(6512007)(26005)(6506007)(6862004)(478600001)(41300700001)(6666004)(6486002)(2906002)(5660300002)(4326008)(3450700001)(8676002)(66476007)(66946007)(8936002)(316002)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?35EDA7s1+ezRxN2hSdnkWfb2Kn3GCe3KvPrOLQWtcCHu3TRIFWNQYtpsheuS?=
 =?us-ascii?Q?ybjOue98JQqjXTSxl6tOYu9pD568cUtZEAjJW/lzqwuoyzNzhCuhwATCoX3n?=
 =?us-ascii?Q?8dkF2o7DHaU36VSTT9qKkUBP6yUDRqbsZEJRkX6XO4kRYqsmJ5ve7g01TiGl?=
 =?us-ascii?Q?bMy3nz8D93YWpzJYNykwYNOaT2T4jO4/w75f3H16n7MJ2NeZ+Q9V9wejKC0U?=
 =?us-ascii?Q?91OHb93C3XHlpMmhqHDWAvQIhJ5f6MY78JyTZt6RTVvfFSlhL7jLCTcwYOga?=
 =?us-ascii?Q?UdOBDLmy0+yPQgOlmVAOEpRN4WVL88AdZKubeBDsVbYBLl5GLOer7FzbOfbv?=
 =?us-ascii?Q?wdcqenDBrYWAcwrxlS3UFLfSf06ZW/oPCaC4lQSqXEitSOo/jKQeLLRFMwWw?=
 =?us-ascii?Q?pg+gzkaQfDAh++hCEYMSJz+hZ8pblkmHkg5zAdCZVxn/J68Xr7Ty1W/CtW7t?=
 =?us-ascii?Q?brcW9REvmuuUO3HYMi8bYZgJJERgF0f19TzeYdwUuf6QAom3WsB6XTC3X8wB?=
 =?us-ascii?Q?fjcbrxvZP4AJ92I+4mC4IPIMD50BRxQitMCsdAUWwLZdzIrdajmpa7aTYaRZ?=
 =?us-ascii?Q?E+qDGaipn+B83JN73V19bHl6dYncqH0LhehxlNNvK5LQGqEUQ6n4DyvaLzDO?=
 =?us-ascii?Q?TXJ7HqSngfiy4aR1Qfy+o4UD131HkRA415mtzL+9vj+tpp+GhnodEVC5XVxV?=
 =?us-ascii?Q?syV+7nT/0505hw9lFGkhRrnUxM98qqzNi9osDUzWdJsjzewTkLlWiUAglqvP?=
 =?us-ascii?Q?N2T/7cYR+IRhFhX3NZuC+5g2HP3E6A6Lw7WPztELMsMp6ni0fpdg66WJyq2P?=
 =?us-ascii?Q?P98QWdnkApNu6dpr7YaEj7fV+WHwClZbmbZKr2W09je70Q/kVRUBTnbNgyef?=
 =?us-ascii?Q?L8dEdPWHCi5dSRB6Ev6Ons6+rzpIILVwQZi4d6AZ9AP6OWo4pCNIGZN01uur?=
 =?us-ascii?Q?wPclJjNkgIvVPHtTQ+uJwfoyKXMJxun5PamPOTCPcUv4Rn3sNGSlTdgNAzz1?=
 =?us-ascii?Q?BMlSAyjgJZzyUxPddv8sxlOe/xWUw2VYRwzWFlH9kBPVec9JhVveMf+gNM6k?=
 =?us-ascii?Q?70ZJqHPkk5M1Ezxjpz2KJWm0oSqbVfRn86yqpTgmckNnsdxOf2zkoFWA6rst?=
 =?us-ascii?Q?DbZ80pxVCns82yUek+PvWUgcVd9E5yinzHim6zt9FHEDMWcffiWW5yNla16V?=
 =?us-ascii?Q?nGiSM9hMQYKcY3w/J4vHjxC7WkzjmYPw3y2r3xVMYzNZHaRkB0BcP4ilzI26?=
 =?us-ascii?Q?R+c/n29dBngSRzhNCWG/Dj6MZ2FCUdnToSPXYImLspqSK4Ux1jjaYlx+015M?=
 =?us-ascii?Q?OZzhhwq6ghQPGpckHWdNoZVghuwOXvYHb6BYk0KMbU40c1Nj6qF1Z4AcOaxS?=
 =?us-ascii?Q?ElgQXHfFUS2KWmOF7oIIQzZVddq0ktwLnJsTHG+UZl2YmsVIgVNmz/ULQmU5?=
 =?us-ascii?Q?J9D+BW6WAFeY3jXvesnhgbCUlAMwytgLIRZqXk2EidpGo8Fsu/JML0zqEfFD?=
 =?us-ascii?Q?3xODZft/S/jO0cGVaCTkR/mMgGZr4NRkDR5zlEYq2Fq/hsKMjj2d2od1+mYt?=
 =?us-ascii?Q?FFnHTo3CArA/XvS2XUb9LrQEM4Tw8a6huliL1xZ8?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c166368-3dcf-42a6-7779-08db51cb517a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 02:56:29.2212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XiVdG/rkQZAdZI74GhqGOh8IOd2aBcIdL7s9il0blBpGnDeQ4PuwZduj6cXOmDnrOjOjj5hSk0LLtgnu5Mj63w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7781
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_HELO_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 11, 2023 at 10:42:13AM +0800, Huang, Kai wrote:
> > > 
> > 
> > I agree shadow_memtype_mask is the right value to check but it's indeed
> > internal to kvm mmu.
> > Including "mmu/spte.h" will further include "mmu/mmu_internal.h"
> > 
> > What about introduce kvm_mmu_memtye_effective() instead as below?
> > 
> 
> [...]
> 
> >  
> > +bool kvm_mmu_memtye_effective(struct kvm *kvm)
> > +{
> > +       return shadow_memtype_mask;
> > +}
> 
> I don't think it's a good name.  shadow_memtype_mask doesn't mean any actual
> effective memtype, but just represent those bits that KVM can manipulate to get
> an effective memtype for the guest access.
> 
> Instead, it should represent the hardware capability to be able to emulate
> guest's MTRR independent from host's MTRR.  So, perhaps something like:
> 
> 	bool kvm_mmu_guest_mtrr_emulatable();

What about kvm_mmu_cap_effective_guest_mtrr()?
Guest MTRR is always emulated with vMTRR.

> 
> It's better if Sean can provide input here.
>
> (Btw, off this topic, I think it's even more reasonable to make
> shadow_memtype_mask only be meaningful when tdp_enabled is true, because the
> capability to override host MTRR and emulate guest MTRR should be only available
> when secondary MMU is turned on).
>  
