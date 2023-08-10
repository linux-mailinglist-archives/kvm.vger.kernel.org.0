Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED2F47774B1
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 11:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234996AbjHJJfY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 05:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233369AbjHJJfU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 05:35:20 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C564F26AF;
        Thu, 10 Aug 2023 02:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691660110; x=1723196110;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=hBGgYxQPtXHjkZmMv2M1ZSxR9S3R+EMEjV+lKAere+k=;
  b=BUTqpcTo5BsvHG0ZyClcT9Q3PqwppPSqukERyK1Sl2BnO6MSg1FNOpFb
   yOin+Kbxqw95m3k0iUJqKPZko6imrPds6gW59nJT/OgenURxnLB6ENECc
   2G7g+AjL1Z7PQNA9tpiAMARO7TTT+9GHlOwitfphOqgK2GQREFUJNlSIj
   enJwdZj5HlBoPimMHWrwP5MmtSlKFUi7RR6x/WVuzHCCQjU2AKzXCCXBQ
   0f2naW5m6klmHfdC2IAc6OctT2d4kewoVDXYTFv/K14uds/m75Zw+YDd8
   pNK4iYhktr0fPzgvWL/YhQv64fAJxgegj8D2IhE1j560Ssr+BbZUVok+o
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="402314407"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="402314407"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 02:35:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="1062817331"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="1062817331"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga005.fm.intel.com with ESMTP; 10 Aug 2023 02:35:10 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 10 Aug 2023 02:35:10 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 10 Aug 2023 02:35:09 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 10 Aug 2023 02:35:09 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 10 Aug 2023 02:35:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nCdYx4rhWQjKVm+5MwJejRn0MLgchRqvoavgrnF2I6d/Gnrhf/Ggig/IP/2bTYhDGQN+6k1rVRlNyVcr/zK2KD/U5MFS2n7qbQhkWaeu4gB5Bcd3hje991ma4yGlictlEVLOQhiV+e0KqLGjfz8gjf6c1eah+fmYY23DtShtOwkD1wiTy89DT1+5Z9khyMwwQVOz/ZA+r0wohvrZAVGa0i20vTOIbHPeaHfmHLwfUsEIA9ftLn9SLymSR3mSrGF0C8holg14DNTZnwUTKeTIikdzDoHVJAqoz04oT50TFZ6pm/vjMuWrJtwUXSXErsYHT66veGxBIzHl5OJ3UNznrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IymmL5qQiBFNv4YqRbqC0kHN949FmEtD5uDZMTrXokU=;
 b=EqJABLrRYyg1zeqAYgma8tWy512LbWsvVEaVfGulBvN5rsTDEev3LAb76AsO6eZ+czRIffZgkj+rFtJy/QeKTZyaSjzpP3z2b2y0cN4Lc/NdCrKSOU04BWr9n1Wc0q3YTCjnCsT/oUtr6xB5dMxBFNc2BvyN4tOr38Lxlu41cvK5vkXEWNl6MUIXAcMTTLyxfEVKHBWs/H6W0bj7xAzgohZHR/TXdcm7bHDD2YBqqHPKKE0tTBoJ4VrXi3NZcS9rm8D4x+nUd7EAUEgHsWV3OBGpEfjIvmEVf9l8eWIVFIitTEAjQJ63LV+3vDa59Ote4Tquic1SitZ/yj8tOdlNCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MN0PR11MB6157.namprd11.prod.outlook.com (2603:10b6:208:3cb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.30; Thu, 10 Aug
 2023 09:35:05 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63%2]) with mapi id 15.20.6652.029; Thu, 10 Aug 2023
 09:35:04 +0000
Date:   Thu, 10 Aug 2023 17:08:06 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Sean Christopherson <seanjc@google.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <pbonzini@redhat.com>, <mike.kravetz@oracle.com>,
        <apopple@nvidia.com>, <rppt@kernel.org>,
        <akpm@linux-foundation.org>, <kevin.tian@intel.com>
Subject: Re: [RFC PATCH 3/3] KVM: x86/mmu: skip zap maybe-dma-pinned pages
 for NUMA migration
Message-ID: <ZNSo9ubMQgbwe9jw@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230808071329.19995-1-yan.y.zhao@intel.com>
 <20230808071702.20269-1-yan.y.zhao@intel.com>
 <ZNI14eN4bFV5eO4W@nvidia.com>
 <ZNJQf1/jzEeyKaIi@google.com>
 <ZNJSBS9w+6cS5eRM@nvidia.com>
 <ZNLWG++qK1mZcEOq@google.com>
 <ZNLZpWbnSmNRc/Lw@yzhao56-desk.sh.intel.com>
 <ZNN/lNIct0eufg7N@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZNN/lNIct0eufg7N@nvidia.com>
X-ClientProxiedBy: SI2PR01CA0039.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::16) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MN0PR11MB6157:EE_
X-MS-Office365-Filtering-Correlation-Id: 95ed6acd-f598-40ba-963d-08db998513d8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WFeKFuy8rZMrdvNwG6G6RrJ0defowSR32ucu6qRcC2m4ABGkZorJt2WBGq9tIgHaikAc5s0PVjCCATk8wmmcKDKww25oeU2mHO7HRcHKqgbWehHtlqcc7kxL+AAdSuRFP+GUF1ntNx0nBmMvGAnfOcqgN8PIbmD9Gh5n6OGldzOi2Q7Xf35/lNK4h3vfN1HdcilE00Wyu/R9IyG5IQeBouYReYCLx8znNAllhGoRrzItWt6LBt0S4bXGUX8EVSaGA1Uzfb7FbpppnHq9eQUdrY9DwJ8LHJwFXjA/yLLt8TiznGdtrDF3Zt5NPLCIzPycZgrtZkSu8CyWtskw5T/2eEydxS7JAAhtBRMoSdG5b+sd3rihsfOXmU/QV5sKnVtyKgeAK9p+ioF4BHCK8IOhHjWTqepOR+3GL5lpXnIQ8GgHzQvfA7Go2RWNeD8FGtSxX5IACBd5gBpU3N341yg7xZRcE/wjwdYhLRc3psw7QP8wq0w2x3C/m5DvgxyL5uSKLZl9AQslD09ZuAVlBUxhpBl7u4lIIuyebNCmFFyR+zk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(39860400002)(346002)(376002)(396003)(1800799006)(186006)(451199021)(6486002)(82960400001)(6506007)(26005)(966005)(6512007)(107886003)(5660300002)(54906003)(38100700002)(86362001)(4326008)(66476007)(66556008)(66946007)(6916009)(3450700001)(7416002)(316002)(2906002)(83380400001)(8676002)(478600001)(8936002)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fqzuQORdpWLhJsl4N8fLBFk1nwVNa4NEtQLsBpAF8WWG7FW1bmFjnEjZZau7?=
 =?us-ascii?Q?Ws8EsTvkPBEAEAH2hW0Yr/quA+evFYmXoTxNa2qlCZwEaLzaOZIYNF5xR2/s?=
 =?us-ascii?Q?HQcv3Q3GG01/aq3bPsYoGAKnIzZ2vEraSYI94i224qfBx6zTUXUXoudgpUL6?=
 =?us-ascii?Q?dt6+1uKKTZn+gxS0E/Zsd9iGJ0spUZbpgiVfS29xcTnsuJkEEkGwnIDkajPu?=
 =?us-ascii?Q?xtPsOFJjWr7gFarstd0KVzYxt7ViNMBxgyGHl1R0CbioBlzyNVxcEHvu1Yte?=
 =?us-ascii?Q?PU1V+t9Ndf2DBBCtifatansVD0gkYlHisbi/JakOMTySctuMoXSinyPByz4/?=
 =?us-ascii?Q?y0FZvOMlj5Exj1X2tqUg6IhcPvMjObUXmLKpimtyCfJlXOTAmnGl+PfpvEIS?=
 =?us-ascii?Q?NspIjpGfaLOmI2XMC87RHwJ1b/OaWiRw5hkFlnCD6Yse0D0WbY6eJDI8ITyK?=
 =?us-ascii?Q?ONXPiaYeG3ji5dqvWYKbHoEXWU1CHMyExGVsCpIel8BxEEbv+M57QUYDtKoN?=
 =?us-ascii?Q?lZMscEpvSvaDQXHu12orAQliczlRup4rC5KQXYOFt0Sj4KZr5QWMdnZpClnA?=
 =?us-ascii?Q?PNGYk0M9aEKxGIfu+OM3+IFbql+VRDog0LCJ/VAcT50QH+R22zYBrwrMfJBg?=
 =?us-ascii?Q?LmLjjhMig61jL+soE/RXXCx6P5P8IparzRQtPdbrpwvgdCygq/PzvEpyPw/a?=
 =?us-ascii?Q?i00JCIenUEa7+AzT13icgtiO1yjZoxx1I+L5uYXK8wQmHpUhfyoMgUB2Fin/?=
 =?us-ascii?Q?g85zp6jKBFNm86vxt0RTVxiAV/GOQ2+eA7zlciy3hyG09w2wt3hGok0pDRps?=
 =?us-ascii?Q?PjL43xwq4sxM6Fi+moK1Yc4pjUHI4xUtn22jq8psVUWU09yYNibH/46N4Xez?=
 =?us-ascii?Q?gRrQ4iLxmiH6nFbDDJSVBej9S2MrQwC5wLz+uTjr6HK645IizPfpGCwW5tkV?=
 =?us-ascii?Q?r6P78wwsLUi3bPsWJX8OaQxZ7dl8tgVKzGBeJph/lJ10Oot3PBZTCPfi8Kss?=
 =?us-ascii?Q?RuJTezdl9EZtRQIxWPVq/kMprtODxL5XR8EK6YW7/hr8Ahqo//L1WOyzAEk0?=
 =?us-ascii?Q?rGR52W0otLR+tmmDNI334ZjIwzZLpw2eSshVv2QvOc+vhqQgJtd/RCgC+ZUl?=
 =?us-ascii?Q?8nB+BGqWMh44q6ccuCj5csZfn7ll+LdxVzz2n+tgOlYf9spU1IDMxcFCccBT?=
 =?us-ascii?Q?x8BCCewauzGuJuQXQwTIFymwX5qwcnRZcHtI8IIPXvFe/lQ1Qx4c+s7rBng4?=
 =?us-ascii?Q?YzM7ZrWWFlqmsna7S41wpnclRdkSet0UNRVNeFA0/U6vplLYo6kWFaTs0jWM?=
 =?us-ascii?Q?b9HBZGyB3dSXykjk3Z+igeDbdyzuyqnCWaOn1jeR3ddrTnycxIpQDDvBryud?=
 =?us-ascii?Q?sF3ZQUO8/vrtoGkTPSOD9BsyNt0/rZlxPu6xTEma/XO/Nnhhx7NuySz8EdWq?=
 =?us-ascii?Q?7QB/LoFwQhtmV//7+5hyheBcLTF+mFpE9UGCGECGpdnW5/laOQk5dPYHWFPi?=
 =?us-ascii?Q?l+nAcRA96LIM/Gb3aE1x7QP8bwtG8D6iNn3GlPPm2ziYw6nYCsSmj0bFB6V8?=
 =?us-ascii?Q?nJtgkWUUZcUwtoVL4pbZvRvOqi3eN9NcaQESq3PM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 95ed6acd-f598-40ba-963d-08db998513d8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2023 09:35:04.7364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Ef3QNeUrfK1ZNuYVHKjrMcVE/T+jPAsRyTdrjRO2b+wY3MDqyj1LGGfkJVVeAzniZ0nG5UxKSuoOCi7+S/khA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6157
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 09, 2023 at 08:59:16AM -0300, Jason Gunthorpe wrote:
> On Wed, Aug 09, 2023 at 08:11:17AM +0800, Yan Zhao wrote:
> 
> > > Can we just tell userspace to mbind() the pinned region to explicitly exclude the
> > > VMA(s) from NUMA balancing?
> 
> > For VMs with VFIO mdev mediated devices, the VMAs to be pinned are
> > dynamic, I think it's hard to mbind() in advance.
> 
> It is hard to view the mediated devices path as a performance path
> that deserves this kind of intervention :\

Though you are right, maybe we can still make it better?

What about introducing a new callback which will be called when a page
is ensured to be PROT_NONE protected for NUMA balancing?

Then, rather than duplicate mm logic in KVM, KVM can depend on this callback
and do the page unmap in secondary MMU only for pages that are indeed
PROT_NONE protected for NUMA balancing, excluding pages that are obviously
non-NUMA-migratable.

I sent a RFC v2 (commit messages and comments are not well polished) to
show this idea,
https://lore.kernel.org/all/20230810085636.25914-1-yan.y.zhao@intel.com/ 

Do you think we can continue the work?

Thanks a lot for your review!
