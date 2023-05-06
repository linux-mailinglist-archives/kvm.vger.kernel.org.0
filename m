Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16B036F8F99
	for <lists+kvm@lfdr.de>; Sat,  6 May 2023 09:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbjEFHBZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 May 2023 03:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbjEFHAy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 May 2023 03:00:54 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B65AD1E;
        Sat,  6 May 2023 00:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683356453; x=1714892453;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=fHmWhcNUbaN5AV94Y44UBAidNFNXbNgNuOy4B08EMJk=;
  b=Z53ejOgTUFPeRbqR/6SS786qF6/QF+jr18jbe31a7SMacGYqLx0kouVh
   w1TUuU1GEXGYKXKrI0AtQnPbXZKOXgP3E7xlIG1ZAlA/RWKrezMvU6z+2
   SbQgBsGyE0aUmnUilFXX8dq6cv1zQzT0w6oBuXKIj9u4pMA+7qzNjsBxB
   aE5X48wg6peH/eZUiFbEHZ6VKPM9jmtlitMWTvI+y313aTTfEIq0G++l/
   R9peMl8C7/cFyLUAgBAJUjLWPHfMuc3ogQESJKHZRZNTN5CuUER6bLsgS
   Xtq49lifMN4toYRNxu1JUT2jsG2euGbiQMK/xA9c4oCDzPYsyRhFCDHDq
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10701"; a="349390706"
X-IronPort-AV: E=Sophos;i="5.99,254,1677571200"; 
   d="scan'208";a="349390706"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2023 00:00:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10701"; a="675408253"
X-IronPort-AV: E=Sophos;i="5.99,254,1677571200"; 
   d="scan'208";a="675408253"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 06 May 2023 00:00:51 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sat, 6 May 2023 00:00:49 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sat, 6 May 2023 00:00:49 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sat, 6 May 2023 00:00:49 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sat, 6 May 2023 00:00:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YRefXiQ99cEFsvra5tpVB2TcfB95soURvY+ANuMBpaMINaaC4GdKCSrRNW659cmQSS10YiKPpdzzRYEhQjbZ47iNrVhjxEdAuKDfkEJDmiI8a1SU5BgCIDACeKaz4wDea6P0kbQpxHhnwsgt02A47yFb5OJ/17VwgtgcKMLeo+vd0zFOnT+aE/b+Ua/mTAuEz+rDLA+Z01kTtV39kKRSL0zi3Rau+Th/DQpkUH2auv00cDhZJF9uA2T+nLQJE7DeE8GrKRjNyxhc2N0KuKaIoe/lnTG1Gs4DClRTjrimXvnxzhpGqohtpDNvpsmrMb7sK4yL6zDwW9TMLWRsTn4MZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=teFW50ycez/OU8NYpvBzs33czKZWMyHaQ8IFSVtIpOI=;
 b=BB2YcEcKLQftFVql1w48XoZycnsRZ+pkdI02wGO54OMN1VDVpgKce8pPBCDBKa9x3hsZGsDIL2dS0VgHoYnm9Ntk3AXIaX4TGwUhJfO57YJ/1VhbKJHSLy3XMyMO8hCfcs/Lr9q+7FC+NQ0rvsx1K3YepYrXC6DhOU09FydRlnD3x8j1E3x8Uz2BWM43t3vhcZIql2w75/rDs6ltB0VEDjYRm/r6i7xJkL++cUjr+bOHAEw7q7Ol6tQWPjNtRWr1gwYXXogolo18HrWXI4kHcSzlFnX4V6DBMSxiab80wZZv93o03T+3oh6Kb5Mb/yG9wluyF859Jt4LtqZRo/PNeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA0PR11MB4624.namprd11.prod.outlook.com (2603:10b6:806:98::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.29; Sat, 6 May 2023 07:00:47 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4%6]) with mapi id 15.20.6363.027; Sat, 6 May 2023
 07:00:47 +0000
Date:   Sat, 6 May 2023 14:35:41 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <intel-gfx@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Ben Gardon" <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        <intel-gvt-dev@lists.freedesktop.org>,
        Zhi Wang <zhi.a.wang@intel.com>
Subject: Re: [PATCH v2 05/27] drm/i915/gvt: Verify VFIO-pinned page is THP
 when shadowing 2M gtt entry
Message-ID: <ZFX1PaKIa44WtSNX@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230311002258.852397-1-seanjc@google.com>
 <20230311002258.852397-6-seanjc@google.com>
 <ZBP7oZ1lkJhlSNpY@yzhao56-desk.sh.intel.com>
 <ZFQYbHTYgG4HJ+ac@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZFQYbHTYgG4HJ+ac@google.com>
X-ClientProxiedBy: SG2PR06CA0194.apcprd06.prod.outlook.com (2603:1096:4:1::26)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA0PR11MB4624:EE_
X-MS-Office365-Filtering-Correlation-Id: 830b0f73-57c1-4e54-f11a-08db4dff9dd7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z0rZW7R54Z3pdzpckQonM1Yc50EWJe98nkQQlKJ06RRcfiwRo1aiZF+fcUQ93WAMccUOlz8UBwcKSBi60j2sH8xxWcfG9hoWHMYkeQG3heaAjDo+2zGKoBTbphyf1P7iw+69XuQTY8JuD2uN4et2cJmR4Ji12FcIzwoKlpvAo3t4tn0b1NhMOranJjkCFxhZRXJmIzNAHiYE4jeBP5MFm8MjvYtVmqd37ErZq6EXPZZNzRQKl0RcRC8BTu+Y2+jurhr/d9rWTyfaK/YuIE4oxpnz6VPrle7N8DIFW6xBK+wjjedT/zI2MocCoMgfWOn5VCRHucTdxvlTyF5NfUXeQFNiVgoxVW0RRwVjE93vqCbcVqmAtR6zYhT948e5pc0n0quAi4kKaJplLh9KlpMcj0SAj5raj79FqmIdscsZLCbhXQyYSkQ1/IPVJQ7DC4RXhICikTY1tElPgLhsgdL4bJe1Umv2cifSfSPS5EJQrUT13i5wymcI9GK0qeR1lfVTQAy/1mc6HDwLwWjRItxEL91qSWjeiJFl8KKgLMI8bN74M/gDNjO4ZyUmRG/momjq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(136003)(396003)(39860400002)(366004)(451199021)(86362001)(8676002)(8936002)(6916009)(6486002)(66946007)(66476007)(66556008)(4326008)(82960400001)(5660300002)(38100700002)(478600001)(41300700001)(2906002)(54906003)(3450700001)(26005)(6512007)(6506007)(316002)(6666004)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h82xBDuHvF2pn7nnPPWrlu2GHDMTjnCwCWqsgcDqQw/dvV8a2CVPZoxhpXBU?=
 =?us-ascii?Q?wSyyP7+xk8k3Sh2qMoSPG9PBRNxkjjwS/zlFBcJhX//aE2+4npUYZ1gmFJQh?=
 =?us-ascii?Q?uupWQOAzW4+eojqcv9Aw7Bc97W0uJxTiyJX5+RiY4FOrMrTx6v3PUnctRbQ/?=
 =?us-ascii?Q?iKK7RY1mmMWa41SitEoNT5VkVjVPNmsU0lBdZASU2BHNjnARMEVfjnETd1ur?=
 =?us-ascii?Q?HC+n6F+BqhScb2hC7dkSTDFOVC4L/zD6NPUQmxh8H2l7LGdww3/zanE1ezug?=
 =?us-ascii?Q?nEZfTeglYGFhJjvmwYNCQZFc1Jedr1ckpEz3PMYFF15giUo0Mo5uDkpyx/AR?=
 =?us-ascii?Q?OxkkgYDCemHOQAh7wkLnt2mjeWh6ADUUScrfPeZ/ZnCXQCZzVWkScy8pdo/N?=
 =?us-ascii?Q?HWDONGAzwoXXk7lURi0fJzveBhAAKHPvofLuNOUG8p3BlXZaQsRr8GDMou4H?=
 =?us-ascii?Q?KYtfbHieZzd1gAItP2p538S38QswLUayieymUf8eBh9rg5EPYusKdGQQJADP?=
 =?us-ascii?Q?rgjqetOoHyRlp+24lrvLsXtKpTDdFMJXY44p27kWQjlAvEnI9OjYJLvtd0D6?=
 =?us-ascii?Q?6mTb+oAyqjvS8AealCftNrh0cPpz6ZAjwYvljbJPJXLfKv02XmaaRLyGaYdt?=
 =?us-ascii?Q?QllhvDFt5GDKHqgcBDC0+plNTZqZtngPgMy1v+R3+j8hQLZndCSSkWuwdUDU?=
 =?us-ascii?Q?4lw6EVjx0O0TiXcV4UCDSMEi9L5dnOd2ro1Nmv5VI1vE9OB4XxNgqtkH9TN+?=
 =?us-ascii?Q?uE71qLm97H15s6GR0zWjcVCgFxMqAel6DcP5YzPC29abj1My8/h/24YWkcBW?=
 =?us-ascii?Q?OwM59Js5CzP4ZIlnac9lwt/xShEhStqhh8j6SWVfJOtD6QRRW81eF0sYa8n0?=
 =?us-ascii?Q?ouMvc0a0KM54BczQCBbPZrvHgZR0Pdw/ViKB9x4hI23xlSM+pvTPBF2p70d8?=
 =?us-ascii?Q?X0KTFIA1ja4Gtp4DTcLgAqvNotE6u5Gi2Vx0jDv4PSu/4IXAilUkjSX8h4Qe?=
 =?us-ascii?Q?z/fWQ0/S+3RDQVyvhN1LnHQPKXSK5lyjME9I+tddRFUKqwQ3BxurvFu5wmJh?=
 =?us-ascii?Q?6i2eJliIWjuFidYKbcnfWml9NYlD+pgLlXW9KVe96T7C4JsABKMq+Rdztyrs?=
 =?us-ascii?Q?o/XjC0aH8mKJdFMdquxePm5k2URYtvLFNO8QGG39hgJxMCxDyDuSobGveWZJ?=
 =?us-ascii?Q?FAxcMMTUr7QWO0XWTZV52KZve93asG6V7f81Gi1TFSIGA21TdktSNbp2ktpo?=
 =?us-ascii?Q?rgijMl3lzC9dvl/MMlg+5Hmb0DNzEYpJVOwnlWMRpqgnw8Zh/RJBlniAhiXc?=
 =?us-ascii?Q?6z3fNdsQY3RueW38LLDbytjdPOgNLoeBspcJcu2Ic7AENgqfPWzSO9/+hraK?=
 =?us-ascii?Q?dWQWKT7Zchha9GkaX67Q9TqZ1iPn0Ny246nP+uVrVWWLkWrR9WPKrkP13We7?=
 =?us-ascii?Q?IuNEnnst6qheMhMh4wkL53eIEYuV/ENnKjoNLv1x0TVJbKtCVCbIH6Ez3Zwx?=
 =?us-ascii?Q?bLFn1PDtohIp44bPM4oG3fXDmLvPL5LpGyt7zAT3jRxJm5/Ja2bs4gfW4Bu1?=
 =?us-ascii?Q?xa/Sw190TtFq2w1TpO+7hEiIMN0HhiHVTNL6IpyM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 830b0f73-57c1-4e54-f11a-08db4dff9dd7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2023 07:00:46.5629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T7ArqLBkdO8fSAZydM8n/5jzk1QVDpQz5kKs4PWJ0E0aLbIGPYrorqECLE4ux7iadxMGCoqhDLJcNDbOCKpOrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4624
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > Maybe the checking of PageTransHuge(cur_page) and bailing out is not necessary.
> > If a page is not transparent huge, but there are 512 contigous 4K
> > pages, I think it's still good to map them in IOMMU in 2M.
> > See vfio_pin_map_dma() who does similar things.
> 
> I agree that bailing isn't strictly necessary, and processing "blindly" should
> Just Work for HugeTLB and other hugepage types.  I was going to argue that it
> would be safer to add this and then drop it at the end, but I think that's a
> specious argument.  If not checking the page type is unsafe, then the existing
> code is buggy, and this changelog literally states that the check for contiguous
> pages guards against any such problems.
> 
> I do think there's a (very, very theoretical) issue though.  For "CONFIG_SPARSEMEM=y
> && CONFIG_SPARSEMEM_VMEMMAP=n", struct pages aren't virtually contiguous with respect
> to their pfns, i.e. it's possible (again, very theoretically) that two struct pages
> could be virtually contiguous but physically discontiguous.  I suspect I'm being
> ridiculously paranoid, but for the efficient cases where pages are guaranteed to
> be contiguous, the extra page_to_pfn() checks should be optimized away by the
> compiler, i.e. there's no meaningful downside to the paranoia.
To make sure I understand it correctly:
There are 3 conditions:
(1) Two struct pages aren't virtually contiguous, but there PFNs are contiguous.
(2) Two struct pages are virtually contiguous but their PFNs aren't contiguous.
    (Looks this will not happen?)
(3) Two struct pages are virtually contiguous, and their PFNs are contiguous, too.
    But they have different backends, e.g.
    PFN 1 and PFN 2 are contiguous, while PFN 1 belongs to RAM, and PFN 2
    belongs to DEVMEM.

I think you mean condition (3) is problematic, am I right?
> 
> TL;DR: My plan is to drop this patch and instead harden the continuity check.

So you want to check page zone?
