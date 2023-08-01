Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB48C76A6D0
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 04:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbjHACMl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 22:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231390AbjHACMh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 22:12:37 -0400
Received: from mgamail.intel.com (unknown [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2091BEB;
        Mon, 31 Jul 2023 19:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690855953; x=1722391953;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=hJ4qDbFOUefabXwvGwHKMsxnvbKXfRnhQXHSK4e6qLc=;
  b=QK+m/hVH8ph9w0XjXihs3VdL4qCihb6IIp0X1Geu1tbq97IgKYGlG5xr
   YwpNlBpdOLv5QrmgVY1KqjFzQ72sfdlRQ8FhsKUUnAUuoIoYwKseg1k1c
   VOXUtyEXjJ7M/WmsFqX60YkZHiVBmsdVTppbWGd5sCQ9BrOrhkDNnrfuw
   FUe1nNMgpEg89b4scvAULpfdnV/PbB+9SWxJ8jk516gCuEg8ZngpFBSfP
   28JBaEmmQpbFRrTRQuK9dZIZg/J90vR9rFg9jdQqmAMap5YAy9VLCu+SC
   2tKOy7+BMv4RAAItP4cm1xXbKUc6ivTvkvacfs5OXDTo4CdESHtklOsaw
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="433011042"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="433011042"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 19:12:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="818615614"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="818615614"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 31 Jul 2023 19:12:32 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 31 Jul 2023 19:12:31 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 31 Jul 2023 19:12:31 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 31 Jul 2023 19:12:31 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 31 Jul 2023 19:12:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VTisfg0kwnv3uUqmBRJ1yRE5m4Ud20eYgRmynmmZQgWYf2v0qWHdpWsSkkl8lGBGc6lCl3RBaOSAYWGwy/KnQO6FUabfGLiRefCax0rRMhgBREGY3R6CpppbVbTTpP4h8ROivDEDX4wGRTBpz7GOjVi8jzC+gdqx4yMBT2DYdnkP237hV+iLDiVq39TCLrRzGJKyeCqHGa9n/d0GPwtAiATW7QIAKEyDpul4pLGYiNEq1G2KQpaeiFja0lzet+0enZZtoevpBojIoIpXAK4QTzkQr4WagYxLElVlsE2yf/iA3Cfl3htuFDpn+LCsCAjNO7pPuny9srBPEJqqXxK+5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9XZy0NkuYmbvhOEjNdTwL/GoLQ3JUuPDGJmgN/vWLwQ=;
 b=WsyWA7uOw/s4Y/Ft0t5OT9FUKvGmwSPZHLwtGd271WuQLjy22mFQadvdOVM03s1XKaoByoWuSMjEQiyn3u09XwcMcCipmzWU80hVpZT0fs/SFBx1pqWAEFsRb2IIazO+r8O8lVE9HLgOHJ8MsoxxX3wPJe4mME4Cq7AnoBsIyzqilCppJ9B2618wtkf8m6ryYjConwiEBLYWhpr9cfCj+8UHLjsJJj+m9HITYV1WSfaTV+t6rqymaB8sO+lrry3ERkwYTCDQrvQDSsvfsCsWwWOvHiLiXj1gf42qL3NbnP7LV+OSwqBKtlE6YBwoYg6ADUH0ngFftdBcJwhucJ0QMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MN2PR11MB4536.namprd11.prod.outlook.com (2603:10b6:208:26a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.43; Tue, 1 Aug
 2023 02:12:24 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63%2]) with mapi id 15.20.6631.043; Tue, 1 Aug 2023
 02:12:23 +0000
Date:   Tue, 1 Aug 2023 09:45:32 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Yongwei Ma <yongwei.ma@intel.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v4 07/29] drm/i915/gvt: Error out on an attempt to
 shadowing an unknown GTT entry type
Message-ID: <ZMhjvIbkvgVN44/T@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230729013535.1070024-1-seanjc@google.com>
 <20230729013535.1070024-8-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230729013535.1070024-8-seanjc@google.com>
X-ClientProxiedBy: SI2PR01CA0029.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::8) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MN2PR11MB4536:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f262d11-55fe-4615-7bd3-08db9234bea4
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yCFHr71xw16SIJF+b+xe8u9G23JiYe6NIMmwkAXB1LIB/uYRvdKWIqEMLPeIeoaKd28qY27FCpAwvwAJ2FhAX21ysJQr+e/SM6BKRimS9zVD5DFq9d1YUJa4otDn+YA3MajauvFl/qlRYumbqMLRCTagPGTPDk933plpEaKceJFrqCNqoWHSiU+dCgIUfdINS35WE5ZHz0KON5VLhwUE0lwD/MnePEu0aKPmaKagxv0rD1CqNACksf7iPed/of6lNXPH2r1KRSS1gkM7GG6E2NnETUgOnfgCSIGhLRq/VQA2dp3/UPwma5DNKC/zJN6QLuvBBkicxX+xqjpkHysTIstvFW1GCCNIys2W7Y3GpMse3rhf198nlqu+tHM7Kj+lxiklLkC9Aw3OdY3Q1sR8aJ8JAqspvEdEh3USQcBmtu6ltejEn9lnIUiLTAjXgDCi6R0tsGVzrLvteWpO5BSEot+Q8IjTpP9f8wj++TydFo0N18NV8+X+hUR6m77euMA9oc6nE5EZrm+BGxrtZwWmcwzWhUglLyMKty1v9Hfk4oCOiTYPShVmwgcn5tldkjcq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(39860400002)(376002)(136003)(396003)(451199021)(6512007)(6486002)(6506007)(26005)(83380400001)(186003)(66946007)(66556008)(54906003)(82960400001)(41300700001)(38100700002)(86362001)(66476007)(316002)(5660300002)(6916009)(4326008)(8676002)(8936002)(2906002)(3450700001)(6666004)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FETf4oQ2ouBXjgXTE0QEJ3Oc7YCwsNZ7nVxEV0L2i7Ql2BCUjVs47h3tCr0o?=
 =?us-ascii?Q?J7IIWShmWRCmbQH+YAjOkgPZdCM9VYtkrAwJQIxCkv1b45KSbEoMeUUjO6yc?=
 =?us-ascii?Q?OtMbQvp6iB7k4S5wiUq+r9oEYXbINzeEpNXZm01yiQA4qHmf/3DGMA1bE2r8?=
 =?us-ascii?Q?aeTNj6yO0Spe4Lg/zPme77O2/QEqOo5SrXdLwOYku0dUdl43osixcoKlBZqJ?=
 =?us-ascii?Q?ark4dIqzFooc3QtJcao4hQuY42ZyGC4tVcR9Yrhn8dnXLhq9pPkwNBo8XzpL?=
 =?us-ascii?Q?F+p6KgaPpaIuefTI48ZypyMOFLo1xIgJXudioD3UBsUoIlrPkbSjVXj9remc?=
 =?us-ascii?Q?NrXIC4Thaet2vvtcq7WYDgIuS8am/mLwbvVfwu1UxgAd5S5RiSs/DiRidv6O?=
 =?us-ascii?Q?V8P/MskClHkvuV/fTOYwsNW8hsXn8x2Ncpodb/yrkbQhQp3uDKKDLumRSynx?=
 =?us-ascii?Q?rQ+7yHqCGwyEq4pIVvS5st/Ft8XP2AZjdBm+Xf4Uh7l/jJKgUIqs64H1AUeK?=
 =?us-ascii?Q?czjKTKqMPTbLlXsa1TkoPgmoG84nPrpZaOnpkEK96Rr9WY4+A1VjjwCHtZ9z?=
 =?us-ascii?Q?bTjGx0YCozOxNdLIeWt0hAxz8Ai02n5mbpJyWxWUJAxevmrCuYp+sutGWOyg?=
 =?us-ascii?Q?LZSXFK2M/05TVnS5sAYSbWuQbd68Fxj4h55tRR3OzPJyKgg3YO1s/LQEHANj?=
 =?us-ascii?Q?OptnjUHoL0gz9BeDA0aD7v2KnGZhC5+mNI8FUlRiTlj1VsoqElznXDxoNk/r?=
 =?us-ascii?Q?h8+KANgdKCtq52eeGc1smQw61EZsds86XfOl0+tp80K7rdeob7hw9ynqMXNh?=
 =?us-ascii?Q?QDYcYJGwettAwK5vTjMz68YMidEogs7eGqb53m/MqagXkAbqYg5jYAeOSeAc?=
 =?us-ascii?Q?J7qsb7SUUCeNrTg0skPDkcEe2rhSi70HWNO0B62DsnXRMb+tCTTUBDbeCU90?=
 =?us-ascii?Q?2JmApclhWLEaOatpe/XjdOJ+1MAgqduSIoCkd/GH9oM4h/OAXdSUbfvkOgVO?=
 =?us-ascii?Q?Y0Y29DFY73UA8tZFYF9yYhBt+PVSkW7rtu5x3bFOw0mbZvqqOqF9mZNv4u+i?=
 =?us-ascii?Q?6GSqaRG5Y7nqx0iOvGy+wu1/4ZsG5CTYhI/SjbjhoxhbfIGNxzo4XtoC7/U0?=
 =?us-ascii?Q?xHZrAADmY7BYsJKhotXSyUBiOVjs7Yz+9boAt4PUOc+aEty0lnMqqWGfQa0X?=
 =?us-ascii?Q?2yf1QZb1biDTA5RnXGv2HsxkOct0OShCN5Euy5don33HH4ogd3t8nSA0fPRD?=
 =?us-ascii?Q?M4jyiC2VPnoaD7hfQBhNjLyJtwnuTCXCOJRsFFnNpTrp+jJ0sQkZ2S88qM2n?=
 =?us-ascii?Q?YUqra4ANi4f+yjqJoCZmViEBIfSBkWFWpUCW+heQ96CNxwhCmJBTKl0L8GCt?=
 =?us-ascii?Q?nRSycx/EVq2ZPFN+biraT/jPUhki9Znnx2956G//Q4icdzBVb5lj+4sCHt2H?=
 =?us-ascii?Q?VE3hXuRmF0NR+4Xe+WqMIZVeuE3K+v9IXXsFqVO5i6OFYnok/NC5bXQB2YYn?=
 =?us-ascii?Q?d3eWho4Qn6cMMvJ/lJIvHGC9zLwZj0h59vJ+K0CefEdyLjunJV89Nz8BVuJG?=
 =?us-ascii?Q?wN0L2PcOvRD8zDl2LL7WUE7te2yD+q+Eim1eRlZ9?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f262d11-55fe-4615-7bd3-08db9234bea4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2023 02:12:23.9085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9cHiayAwFRTXxFAxuuDLSzELcXTpD5GXp7QDcoJNSy2z8oPEFOyvvlM3LG0Yu9545RXOuj6xCdNIZrgzh1OLUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4536
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>

On Fri, Jul 28, 2023 at 06:35:13PM -0700, Sean Christopherson wrote:
> Bail from ppgtt_populate_shadow_entry() if an unexpected GTT entry type
> is encountered instead of subtly falling through to the common "direct
> shadow" path.  Eliminating the default/error path's reliance on the common
> handling will allow hoisting intel_gvt_dma_map_guest_page() into the case
> statements so that the 2MiB case can try intel_gvt_dma_map_guest_page()
> and fallback to splitting the entry on failure.
> 
> Reviewed-by: Zhi Wang <zhi.a.wang@intel.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  drivers/gpu/drm/i915/gvt/gtt.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/gpu/drm/i915/gvt/gtt.c b/drivers/gpu/drm/i915/gvt/gtt.c
> index 2aed31b497c9..61e38acee2d5 100644
> --- a/drivers/gpu/drm/i915/gvt/gtt.c
> +++ b/drivers/gpu/drm/i915/gvt/gtt.c
> @@ -1306,6 +1306,7 @@ static int ppgtt_populate_shadow_entry(struct intel_vgpu *vgpu,
>  		return -EINVAL;
>  	default:
>  		GEM_BUG_ON(1);
> +		return -EINVAL;
>  	}
>  
>  	/* direct shadow */
> -- 
> 2.41.0.487.g6d72f3e995-goog
> 
