Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5056C6F917D
	for <lists+kvm@lfdr.de>; Sat,  6 May 2023 13:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbjEFLXI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 May 2023 07:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbjEFLXG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 May 2023 07:23:06 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278A88A53;
        Sat,  6 May 2023 04:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683372185; x=1714908185;
  h=date:from:to:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=g+4Xi9YxhQerEdJPK+uYvAl+2aWVO7wRi0IW1C1mzQY=;
  b=gK1e6zNuhtxRvMnYO6kriOGqXl3Li0iuB0qhzz75Se5mOUdownFeHgSZ
   3+347picd52aN3n/XsdK1PiiMMhNREEIzwX87quJHlIVd3cVALKaeBlqf
   nbq51MZ/51ixXi5GfF++5eS7KER9qbgxt7092wTizo/6EBg2ogcEI4+mr
   CcZJus5bbtr8Q4KWNijuNPxoq0y+KX+yMpZnqobFvLf80e4x3hH5padHM
   xEgoXqAB6nf9x6LZlPA/Np97joDffy/Ab9iP55ogiK68t2Q0EQovjmFIp
   GrMrRq1OcY9Z5ZQxBbBvtBhoObUUEhKFPAAB19cB1Zb15CI+h8OFAutuN
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10701"; a="328995568"
X-IronPort-AV: E=Sophos;i="5.99,254,1677571200"; 
   d="scan'208";a="328995568"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2023 04:23:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10701"; a="675453588"
X-IronPort-AV: E=Sophos;i="5.99,254,1677571200"; 
   d="scan'208";a="675453588"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 06 May 2023 04:23:04 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sat, 6 May 2023 04:23:04 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sat, 6 May 2023 04:23:03 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sat, 6 May 2023 04:23:03 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sat, 6 May 2023 04:23:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YELc8jUFBm49RS7wM+/BVgusGgShtdS8sOLCGi+vs8n0qMzNh8IEbS2Mp6+8T7q/jB1eTUE3wZFXDrg5v7VShlGkesSc71auDB5xGGC83gYSWFyd+gbO6+XUvUDKBJxPaMIhIwB2A4pY5LyeqJW3wqTWNHcqEVCOa1cDxTyO1oO1VMyiBrqSPwJOyvRS0qcCo8TMYrna5ci25IAppcJ3VoFhcaqD6BiSe5UMKwwM6BMbTtjVYu9nG2QxgWbxakvWLDi+zfx39M5GTBB1cPqM+b5jJsmbStVAKQeLzb8HaQJAa0YLgxgVbMGqtZYuXIuOauzMVNKE2M0c7M95VPAdTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UOjhDT/682sK1vCIr5JqAz8iLuKduV7DSiuO5xa6xRo=;
 b=PMBZUnYtU03IHSskLeDUvx4HGPfY2wAxGb+HYw3W7OVyWednTlRrcBPzG1/tzLl7UsTIKx9WmJeU8JXd9iy8r/7+3aiFMUcx5i7M5yvqKWAgRyhjVcUL4y9qjmFEwhRBiUmvQX7ptW6IhnSYjIm5/iB6DaRYK/BbEBgXetV3A87e7zO5uQEuiIVGaqO+xyjYwkbbYb++9GuogguaF9UG5iTQEQZkydFdFkhF+jtFNVC1Z9ElKw97kmjTXQUbuUO0omVJrCUBQi3wdI99T9HM00dYQXFDHyHn5ec6okuUP+2uZbT4dtM1MzY7tTxRo94omW5RBJZpBUbxjE7ngzpLsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH3PR11MB7913.namprd11.prod.outlook.com (2603:10b6:610:12e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.29; Sat, 6 May
 2023 11:23:02 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4%6]) with mapi id 15.20.6363.027; Sat, 6 May 2023
 11:23:01 +0000
Date:   Sat, 6 May 2023 18:57:59 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>, <kvm@vger.kernel.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        "Zhenyu Wang" <zhenyuw@linux.intel.com>,
        Ben Gardon <bgardon@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        <intel-gvt-dev@lists.freedesktop.org>,
        "Zhi Wang" <zhi.a.wang@intel.com>
Subject: Re: [PATCH v2 05/27] drm/i915/gvt: Verify VFIO-pinned page is THP
 when shadowing 2M gtt entry
Message-ID: <ZFYyt2fF6alyKlzO@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230311002258.852397-1-seanjc@google.com>
 <20230311002258.852397-6-seanjc@google.com>
 <ZBP7oZ1lkJhlSNpY@yzhao56-desk.sh.intel.com>
 <ZFQYbHTYgG4HJ+ac@google.com>
 <ZFX1PaKIa44WtSNX@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZFX1PaKIa44WtSNX@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: SG2PR01CA0126.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::30) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH3PR11MB7913:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ad565e1-5547-46f7-3d32-08db4e244074
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ovPfP7Tl/CjNZtSN03eaT3jFOWl/h8TI2gAB2Bd9jq3znb8vK6t3NhGSI9xiXyEHlIcdHpfdXfPsiwOhyOmQ5QOrXSFpzk2QYdt2cyZquOFereX9SprACdEpul4rKTUBbHUlzweJF2x+PWJdwLlnUJSJLQw2KGyNN4WOdWvyRezC/IqkuEAQKR8KUFg9TbUp1jOnk6yU3ojKx+v0XUTEwcLdftBQTh+X1QDQ5hAnNoBVzZBJH/dW4sNei6FeKLnoserCzJMb7JxctXqYsP8EHi8iRS6TV69aERDX+g0R9Fw2NFirxyS6ARiQhgP6MNQvwAjgSNjo3KmTpFuhNgprZzpuzkmGEmmSrq1E+i2HO7uOSzSR0TjaJAfKTbiFdLGMQsjotnjq7RwGBx3ADlZR/xoz0AebFlk2Ldh+JmqMMNMLt2z+nPuTsyJ4Z1Udoeew7YoXglrw3ci0/cbSiZkxny8BxgO8KAOCCC+rK6y6DLOrK+oGg/psQyRAfsUGuVyaQ7DvwN8fvrV7b9xIna2B3k2oeyzl7LHGksoCEnUAbfPFyMyhD6IiP98XTNNKTQZW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(39860400002)(136003)(366004)(396003)(451199021)(6486002)(186003)(38100700002)(86362001)(82960400001)(26005)(6506007)(6512007)(2906002)(6636002)(66946007)(66556008)(3450700001)(66476007)(110136005)(41300700001)(8676002)(5660300002)(8936002)(316002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/hGutdhRQ8khcerP+enzKhI7thet5pfU9otFegNa7Dp+fN10OKdSRPDzfRz8?=
 =?us-ascii?Q?QPJMKm16m40wzlyJBWBsJagxKT7pP3J4izlwa2yoz3HLU0PKAJiZSNAszVTl?=
 =?us-ascii?Q?uUrbZaQl2B1WbK31zlmlH1c99mgaojihuojo/sFrxGi5uDIgt04PkOWA937u?=
 =?us-ascii?Q?060yLULtsFaa5wQL9bBCeJTQo7q0axDAQUg//fIsSj1N3AO5nPi5bRGYvcxw?=
 =?us-ascii?Q?Nz27pzwx7o+WOQ1eZufxw+wBuxHKLY8ZF1juM1l2XXOf3YUPW0u0Wboo+VVE?=
 =?us-ascii?Q?kDoXHcOuGwK1hN3sLhIqCx9d8QH/G39d7wKcns2d91dUAq4hYz1kuCzPsUP5?=
 =?us-ascii?Q?H3WJrWVtOorfqhpl7HWzIUBy7plKrvnfnrw8SXZjUBbPDCaXooZHs84eJC6U?=
 =?us-ascii?Q?zRlZtweIac/JgvAe6xnpGFd7ean7WiW/1pl5EBx6PtBzHH0qP8NKkMbL+0n8?=
 =?us-ascii?Q?NYFBSJBqTGRudFZlrDdD9otlnCVnPp5aGwwJM4mtwXsCzsfLKi58UUDW+6RR?=
 =?us-ascii?Q?kqgTJLXtLzUf7lL5bWAk4V/rIZoYgRzSkoeqO9sAWvwSA+lP+UM2uZGGb4b3?=
 =?us-ascii?Q?YLuZheXcUFzJ6VrTI4Gh13RIq9L/kV32MnfrCb5ZdaqzkC/La+c/RkvItfu9?=
 =?us-ascii?Q?BJAtG3BwC0WrcI8GtFv8P6i2zZLLWrRQQaMe+dYlQCgAiJBq0Qtjv5NGbcwr?=
 =?us-ascii?Q?2RRdoXzjz0NGBjqXc8sLVLLwUHErCKZK2GXQq2hUQ9bpYxN9b93mLFCoDOfa?=
 =?us-ascii?Q?o/yunZlc9HqaUgV3/9n6P7k/o+2aOgDd4KsVqjXMZIld6B5WmcDc9/3kjBaV?=
 =?us-ascii?Q?RhhtEBvibPX2uDGmFIJ+7YzakHCjQ6sqnMm7zviyLHnGDaz3O8x/bo2vtWxR?=
 =?us-ascii?Q?kjadvBYxces+YoKMKAIK1kEOUcsOX8/bHT0yuzg2Oq1EytYVAcp/2p6AD8vR?=
 =?us-ascii?Q?weOeG6HxdhXM3FXOJ27YDoRMx05oIRyWjy3gdK6EW9DkGylkGz/0u3eXWoDO?=
 =?us-ascii?Q?98ZwMjnbkN5tb+OY9k2tLSA7C9kGoojrsKPG3bpzJzlvOKkmjHL+u53FLiwa?=
 =?us-ascii?Q?kTcZjeW38Mk5QyCvBkOa+XxxVVwB4xGgNhuI+ezb43/aBnuBuYr9epmu75Mm?=
 =?us-ascii?Q?iEW3tBicpQiYiXqWAyQzsxW1V4njxKHBheeKqZgIQxYO/J7/mfllwdrU9S60?=
 =?us-ascii?Q?Y/LeZWG9ghRkaPNJfx6mLWEF+1MW4EVpnX8GjitjOuog27/laZQJwIErpOiF?=
 =?us-ascii?Q?FYnLcG7Eo5/gON+tdOFVoLNystbq1OGwzLJ+omjM/nDlNBQh3WLBBWuDoYnW?=
 =?us-ascii?Q?b3Ifo8phf8n5pwfMBiYeXCTiFGrPpF/XIWxszFfMBfNqQJmQ200PNhsU0uLZ?=
 =?us-ascii?Q?EgL2A42XE+uNu8fw/Ml5DiTiYqiCzL0p6Vb2rQIDx0s3mpgXOM44pUjUO1tp?=
 =?us-ascii?Q?2GzyA2OgAe+ci94HsUjdgpr1wCaI+z5HL+SlrtaiDYymPbGsJgoFTGZhrOVY?=
 =?us-ascii?Q?NEfu75yQojsgUUDHvnSPNpO3z4AK8Yc+PRo1O2ByhsqiA+aynMSeAgRivitc?=
 =?us-ascii?Q?XC/Kj2EYO2EOA0SaDKRDhrrP0Jj6DcIU3wSpKA6y?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ad565e1-5547-46f7-3d32-08db4e244074
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2023 11:23:01.2243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h77bHBYumedar2cse2LIp1luQDujlb/d43MZ/+sm74RxVDK1n+8DTXSHDOL4IDLwFe4Hw/9/KHX8SXjg/81UxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7913
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 06, 2023 at 02:35:41PM +0800, Yan Zhao wrote:
> > > Maybe the checking of PageTransHuge(cur_page) and bailing out is not necessary.
> > > If a page is not transparent huge, but there are 512 contigous 4K
> > > pages, I think it's still good to map them in IOMMU in 2M.
> > > See vfio_pin_map_dma() who does similar things.
> > 
> > I agree that bailing isn't strictly necessary, and processing "blindly" should
> > Just Work for HugeTLB and other hugepage types.  I was going to argue that it
> > would be safer to add this and then drop it at the end, but I think that's a
> > specious argument.  If not checking the page type is unsafe, then the existing
> > code is buggy, and this changelog literally states that the check for contiguous
> > pages guards against any such problems.
> > 
> > I do think there's a (very, very theoretical) issue though.  For "CONFIG_SPARSEMEM=y
> > && CONFIG_SPARSEMEM_VMEMMAP=n", struct pages aren't virtually contiguous with respect
> > to their pfns, i.e. it's possible (again, very theoretically) that two struct pages
> > could be virtually contiguous but physically discontiguous.  I suspect I'm being
> > ridiculously paranoid, but for the efficient cases where pages are guaranteed to
> > be contiguous, the extra page_to_pfn() checks should be optimized away by the
> > compiler, i.e. there's no meaningful downside to the paranoia.
> To make sure I understand it correctly:
> There are 3 conditions:
> (1) Two struct pages aren't virtually contiguous, but there PFNs are contiguous.
> (2) Two struct pages are virtually contiguous but their PFNs aren't contiguous.
>     (Looks this will not happen?)
> (3) Two struct pages are virtually contiguous, and their PFNs are contiguous, too.
>     But they have different backends, e.g.
>     PFN 1 and PFN 2 are contiguous, while PFN 1 belongs to RAM, and PFN 2
>     belongs to DEVMEM.
> 
> I think you mean condition (3) is problematic, am I right?
Oh, I got it now.
You are saying about condition (2), with "CONFIG_SPARSEMEM=y &&
CONFIG_SPARSEMEM_VMEMMAP=n".
Two struct pages are contiguous if one is at one section's tail and another at
another section's head, but the two sections aren't for contiguous PFNs.

> > 
> > TL;DR: My plan is to drop this patch and instead harden the continuity check.
> 
> So you want to check page zone?
