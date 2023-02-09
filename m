Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE1D3690442
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 10:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjBIJzf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 04:55:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbjBIJz0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 04:55:26 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923D0A5C6
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 01:55:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675936520; x=1707472520;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=rZ+Qzs3/gppjFPOK8WLmJaPwgROaLT5mFsaqswTBuKs=;
  b=OJxf4Xi9zjUboeak+GBDqMYEJn6KRUB+UdThRjBPON6wuwyTNa5A7HqA
   vT7HRI+DpwpDx5N0NhgmK47P5+7WfzBBpGR0zcGeVWuzPUgTrCqYVvTiD
   FPUbeOkbQWkRP+Ke+sQc+slxV2AeAKRuewLsJ/ECGCfuciALEiByhs4m/
   pPjGTiryRGoRzLyP28qgo2WfUzqCBq1yRocC32D7BrArUSrEWUK8stBpj
   9LoGdGNt4TbuScJVKupX0HEyc+hFq7OMF2581fA6YM5yUAYKPGAsBad49
   IF/9pFf0s+Euiv73t2fDRIc8AyFvYDbDw/i0+4C8IxoxFsRwzhgJjPmLX
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="313700576"
X-IronPort-AV: E=Sophos;i="5.97,283,1669104000"; 
   d="scan'208";a="313700576"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 01:55:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="736278316"
X-IronPort-AV: E=Sophos;i="5.97,283,1669104000"; 
   d="scan'208";a="736278316"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 09 Feb 2023 01:55:17 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 9 Feb 2023 01:55:16 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 9 Feb 2023 01:55:16 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 9 Feb 2023 01:55:16 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 9 Feb 2023 01:55:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KFpV53loc6rpABwAa/+HesYe7rRhzwVthw+4kna7935FYdD9iI/33yylCvULWL7fhTawJLfdM1RUpxdTZzGFKGZa9eQtLLhm17cbroxU5ZzDDRUk2f5xfWiHXVlraQYV4VpLZFmY8SO5fLxYI3YLDeicB0Fcznjt9g1nBpsnJfQxMDCcF0WKvqHgalg/WbSFIxaV60jP59P6+bHaANxq+DBo+4CJNOHTrzSoHokoitOI+ozfxeA9TIvPDRviHJGfAbGwYEI7gr5NheZ49L44Gkx/KWszosSvZiLBq1i1yTswXGqPsO7JOaxf6Ugf7mMFnKkvDzOQDqgqqK7Qz0IsLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OekZ3Uh37bYZveXBNaTHpVbfuFyz2GgLnYXCDIzkVHY=;
 b=SFpxIiqRt0MijoDOgRM5S+mb8Kqup0LCdOCoEpR7GZJMLlsv5R6hruj4Tym/MZLk90sF+bPVjx1sWfVb1fniijbG46UaCCzk1s+OpMxfaSuYMKzBslk7jTsj2PzTIzZ7PEHmuNmv/uzmUZJvkGaG9Dw9TdjnHc0qQCh7mhcd7YojxBh0IDpP2fEiRgT/eHNaPch5k/GcMk1DUWepQLY5+enupUPuMlxDp6D/HKIfi2+b/d88wBYIvwy8wYhBa3n4BS1PSCcC4HwVYwy+Uik8gbH2x63N9oGqKgqlekHvm1BgrJAwV3dwf3WGA7t6YUp7tE+O9V7zzlDfkSpojsUdjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by SJ1PR11MB6228.namprd11.prod.outlook.com (2603:10b6:a03:459::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Thu, 9 Feb
 2023 09:55:13 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09%7]) with mapi id 15.20.6064.036; Thu, 9 Feb 2023
 09:55:13 +0000
Date:   Thu, 9 Feb 2023 17:55:30 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>,
        <yu.c.zhang@linux.intel.com>, <yuan.yao@linux.intel.com>,
        <jingqi.liu@intel.com>, <weijiang.yang@intel.com>,
        <isaku.yamahata@intel.com>, <kirill.shutemov@linux.intel.com>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 2/9] KVM: x86: MMU: Clear CR3 LAM bits when allocate
 shadow root
Message-ID: <Y+TDEsdjYljRzlPY@gao-cwp>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
 <20230209024022.3371768-3-robert.hu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230209024022.3371768-3-robert.hu@linux.intel.com>
X-ClientProxiedBy: SG2P153CA0045.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::14)
 To PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|SJ1PR11MB6228:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f2c4132-089f-4827-023f-08db0a83bcca
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 48OxDuS63TSk4HskFpYJPpFPkl0Gq63SuyxpbevOBKIZe56n4KslRvVKpbhp1OmrpceAEnWVx72FS2h9Y0VegcJ/26UW5XzoMdly8CEBckQCYQYdalKBulvVlWOcyWO5aFDY5o+Ql38YwA3Aza3aJfZpf6UOokNaNHhfI5C4PIllF9BLuIT8Mm5lsU/kFMaBHPzGbSRObQpUI9Pb7bsiVtOnZPxUaDKkVpLsgl5UBR66qIB5CAsu8wQBTE5NjKjomCt1DfcN9rXgA9mX3txWcj+bRlvgRX55CPSi/v84x7MNdgcqfX9uNhHV+a0Y0s+sdAFWW9bnQYeAaM703Z6sgFclVbVsODO72IwZu1rk4dOtaRXJ2bzsRm7ST8Pgc8fnJ7ZbCB3peqV+TfDGC3NjVwHriNomXxr1kJ4aqwmQxgbNtf7ZLZ30T+LU9gQftYu2yn3/6wzvsd+DZ52M0/9aWVQlTDKk4BR/beqlNAxpScdEs9WYmTdJrnpKpB3ylZEM2dnVOmOsH0Txn+Oy+h25dwdiDoatqq1nCypUxWndPmSMzw17OI7wHZabvVef92nB4kzwqDy1Ul1EiUq0UBY2/YaL9/R68OfhRKqCJMgs2RLqi3DLvbhzqcK4yI2pjgXeEQoKmqkLF3FTnq/bCIW4hlsdIhsf2Xf5s+OXeHSIt9p6L861hdkMDoqnBhfKcUYS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(346002)(39860400002)(136003)(366004)(396003)(376002)(451199018)(2906002)(6486002)(6666004)(478600001)(6512007)(9686003)(6506007)(186003)(26005)(4326008)(6916009)(66946007)(66476007)(66556008)(86362001)(8676002)(4744005)(44832011)(5660300002)(41300700001)(8936002)(38100700002)(82960400001)(316002)(33716001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5kVK3dAiXoZed86ryd2r2Z/8xO3g1QX3S9nLQl6kILDimkI5j/Z6ZpzZuj0p?=
 =?us-ascii?Q?qzf5qCpccXO2zNomBFBNBjjAveST5NPWmWmdNmDxS+ZpqWsWCnxITUkmCKcD?=
 =?us-ascii?Q?lz2CwbFAGqejCa1vXCXnMx6dYKXZeZePvkms3I9dXCpYH7cJbY0dIDWF6JKt?=
 =?us-ascii?Q?FwI8wxmx9kHIT0KFIBFDAGqkyfedkGyM5gOsVldhB0sgF7dHpwUiKRTck0HJ?=
 =?us-ascii?Q?VXjYkgJWBqB18fmLjbMB5W8Lqp1oRThmnKMzK8PZvBFGGtowUF2cD/OSzN/Q?=
 =?us-ascii?Q?EI2ebYb+RE7uL6o912qPqo/VeYPk0vUo2Pil+QpQp2zCF68APit6bf9ONywk?=
 =?us-ascii?Q?5ZB6ckPWhMZbYq9cDlL6SyWT7rqiBpr3spRndF81z7sEYTWHdEFX1EXZMbtV?=
 =?us-ascii?Q?Nl1/1JwMDrFBuftJIYF+8hfOZ/FddX72TA1SxOoLkbI2ohct6pvdiG/X9HTs?=
 =?us-ascii?Q?1Bc96NTfNYIQUvoAeSHjyczDpXJ1NE+q6sakg17zCGo0f5zChnoFT7pYfkTI?=
 =?us-ascii?Q?wUN+Ss/XvNdRG+PUnTeeRguQ0eKLHnp3SvVTkZgxtHj6YoYFh18HYimaSk+8?=
 =?us-ascii?Q?iFjkLoodh+9QmGHsLX/Y34Zkq9KgnkanWpDxE1ma7yKM3kksMGwlokyEPpPJ?=
 =?us-ascii?Q?QiMywIjpynP+ZnuLVmGbgdZ+Cx+VOuizet6oLaGr6HYrnaP98MGM27ae+8SX?=
 =?us-ascii?Q?vqhEmilIeSMTDtVfWII5QM/U5GCQ7mg+ycJusN/JKdpM1HZJdJ0De4uQbGP1?=
 =?us-ascii?Q?lgsUaRHa72MmU1Kl/W2l44FY6vQdhK7GC3ZPoeVhr0Ix3rDp6Nm4f9T4Vg1w?=
 =?us-ascii?Q?sLjsyPyGrC6ltYTRskuA3hmcN+i0W+9wgMXKD++/Z58XH0N0xr7YzEQiOiUj?=
 =?us-ascii?Q?hIlnqeRxoTeTdMrTAm/h2zAmpGINpZyDAPjSPdcnD0h7KmEmuli791F0IRUD?=
 =?us-ascii?Q?vkyiMXwT6W2tM3bUo7EToMVkgLtRfyZ0Zp9YebDKJo5eMciKWbG/9TDfxM5j?=
 =?us-ascii?Q?UMMRjc7I5hMC1TAex1KmRc36nAHo0gxG4hF6NLm3wpqIvFq/FK9Eu/3/rzXS?=
 =?us-ascii?Q?zfMy1CmjctT6ONRUIAOOOZ6+J/md2uzYj965QhVvUSIDNj/0sQFtM2ExNfsO?=
 =?us-ascii?Q?/fq5TjH2AzobVyYaN6Ym6Dna9eKs24mWD6Q19ZduTW/bMkqvAIzEGcy0Yhex?=
 =?us-ascii?Q?w7QVcZ1yqi58SCBs+OneER/DyhASbIK6nVBLgWhJLIxvmEvqvlsXNUcl+D9a?=
 =?us-ascii?Q?TTR3MdBwfme7v+tUoPNNtCopax9+pgT6L7RfQvsZcLWpabzpk47CVKydAGJB?=
 =?us-ascii?Q?410CeIA65ORaFXL59FIIwB8YleGf+raiCuy7gFvUFHmh0EHL4fCui6p8/+fD?=
 =?us-ascii?Q?gWxwuC+53fba6BYyIwShtyed+uW8PSWrk2ScZteCb9DfZfCVXXY4oEkTDUlS?=
 =?us-ascii?Q?1AGjS4gcgmkHNH+BODQUP+HPaoUtp1dQRAKHSiPd5n0P4cEaAItbmPhjqkSb?=
 =?us-ascii?Q?dLzafUoF52Ssijwp+6sr29ilHgWPeYMH4UVvWJhCus8hVo+xbpzZ3sNwywy9?=
 =?us-ascii?Q?RxFc08AGMqQXT4wcxIntV2Lg4F/0dw3r4uLeHYh2?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f2c4132-089f-4827-023f-08db0a83bcca
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 09:55:12.9125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4bZS99CsAZgtPPXlT2KBvw/D8dKsWTqirZ8iJHjLFWFbaGj16VFIhUwC9XlJZeZdd5ew/oLXGEhkY8c/MEzJJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6228
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 09, 2023 at 10:40:15AM +0800, Robert Hoo wrote:
>--- a/arch/x86/kvm/mmu/mmu.c
>+++ b/arch/x86/kvm/mmu/mmu.c
>@@ -3698,8 +3698,11 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
> 	gfn_t root_gfn, root_pgd;
> 	int quadrant, i, r;
> 	hpa_t root;
>-

The blank line should be kept.

>+#ifdef CONFIG_X86_64
>+	root_pgd = mmu->get_guest_pgd(vcpu) & ~(X86_CR3_LAM_U48 | X86_CR3_LAM_U57);
>+#else
> 	root_pgd = mmu->get_guest_pgd(vcpu);
>+#endif

Why are other call sites of mmu->get_guest_pgd() not changed? And what's
the value of the #ifdef?

> 	root_gfn = root_pgd >> PAGE_SHIFT;
> 
> 	if (mmu_check_root(vcpu, root_gfn))
>-- 
>2.31.1
>
