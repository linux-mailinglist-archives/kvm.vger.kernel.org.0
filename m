Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 274B0707CE8
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 11:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjERJcF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 05:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbjERJcD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 05:32:03 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D86211D;
        Thu, 18 May 2023 02:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684402320; x=1715938320;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=nmg8GIogYPKL9iIC359ahzB2QqiDAkSC0BALsty60k4=;
  b=cUPcJKdybWk2NpOrdVkLEhyFn848aOZELdfEUHJ9unEaw9XkDTW8DoNR
   GNNiFY14i4wCRpPed7gJXCNqQipYzBKxeK88e11byKCQaJzpAziHv32Vk
   MlxAxX2LTqW9tV2+ajBCAJsAYmd//ihvGfGcac6rv102NySgMfTK1ycf6
   Xj7UUV8KGdwPtWQCuxNfjvQ3HNLbq9AdJZFqzhNiMNR5VAg1oCeza9tYG
   Teq4zYvafPdhKA+tM2X9geXfAPXg037gI1UORW1JSi9YZnmw7nMGLnbPg
   4T9KCPC7Fiy5Jx/1URkXBdLVphsvEaxvQhI1czW3FM2cJsZf3jXR/FNo6
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="332387832"
X-IronPort-AV: E=Sophos;i="5.99,284,1677571200"; 
   d="scan'208";a="332387832"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 02:31:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="702070702"
X-IronPort-AV: E=Sophos;i="5.99,284,1677571200"; 
   d="scan'208";a="702070702"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 18 May 2023 02:31:59 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 18 May 2023 02:31:59 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 18 May 2023 02:31:58 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 18 May 2023 02:31:58 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 18 May 2023 02:31:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jnvex84q6Ui/ZhtIh22AEzRfXh9a7kcED0Ery1LsQiTlMICfmnnmNLvldRqUrJNm00aCQVgkUqVUgf7jyAf3dDYFkOpTwtbXHWnQnVJVTUhEtIg3XoQndDeKa4sQLH9WC7NTPhtsXb36G/dBMAnPaOB9AdfL6vuyuZXDocYM/pUHBzqlP9i6SEFaV+EmlQJzkW3Ls9TEhMreC7AZYz9CxBtu1IpiJCru5C4pVtFE8VxoizSjrF+4wV8oRdgu1FCzAsqL6F/CTBQBiDShRB57aBjQIyPJAXuTw1MTFDdPZR3QIvYfPig3DmG9VZ1JzO5q88PRlurrJfYuf4refVaqDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FMRFuTOMEh5WApT3VJiWvJaemoQIFGZk5sIjw4yQuEI=;
 b=eaACjm9OTUb9Ksq+9hAgeCXSgFcf4JFrqOo2yifng88sfZJUL3dxAl8a7i09ynRSOKtXaYPwwApbeLrkEFHEwRPw/m52lYslIu8cUh9Fleu6HlLlF+v3CKpM0xligU42Zqctmnr//0TQzdDYBlKm5gmPGYUN4CcFTGzxchCjLnlXTsyMIuXxL0wslZprhGnAxlTgUX01EyS1q2/sPlJAXB/auE+bqfOByYXw02v8A0IY+407OxKvLjs3CpqIUPOA/9bauL+lBr0TojeaYyocOnQfFMlYyRYy286XY/B+LjZ56DQyFigHP/VTI4wcZ/tdvtekuSWmu3F3sWY8JzRzyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH0PR11MB5250.namprd11.prod.outlook.com (2603:10b6:610:e1::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.19; Thu, 18 May 2023 09:31:50 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4%6]) with mapi id 15.20.6387.033; Thu, 18 May 2023
 09:31:50 +0000
Date:   Thu, 18 May 2023 17:06:43 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v3 03/28] drm/i915/gvt: Verify hugepages are contiguous
 in physical address space
Message-ID: <ZGXqo+tG35S2c+QQ@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230513003600.818142-1-seanjc@google.com>
 <20230513003600.818142-4-seanjc@google.com>
 <ZGNO5gYKOhhnslsp@yzhao56-desk.sh.intel.com>
 <ZGTpsvZed+r3Low1@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZGTpsvZed+r3Low1@google.com>
X-ClientProxiedBy: SG2PR04CA0162.apcprd04.prod.outlook.com (2603:1096:4::24)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH0PR11MB5250:EE_
X-MS-Office365-Filtering-Correlation-Id: d96b28ec-0f90-4afd-99a7-08db5782b572
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jw7LY2g8x5bRRYzkajominM15/PeqwctmTnMDSG3kenHqHbHIqV1MS/0QlELhGOBzXnJmut6rdvKEvdr7kDaRRp7iiseqBgN0fEe8/eY9sHm2dimQm1DoDgUZjT77oPCnL8YrTB6hT64ncjgCg+vIVWSgrFBlCLyt3Pnmvchm9f7GRJmfuaxqWCchm1VwmjWifOLVSc0mO89rKlNbSZ11eBIlhu0GeD9mhk8PIk28jGTugq8nWZ+9uhFrsdpncZWMV5r9xO9Lb5I67ALCYt/0CCFNWVCQ/x5MUR+oIzTdZhpNtE+f1NEjQOHJVU0tH0YfIpmpBJw9QZpaG8f2vfCpIFPGl+E/S899kqSMPfc2RhLKFxSe3008Y1DsGEy6NtV8qsXGyayZ1j7E7QOX6hihBWxZvilW5aI+o364DR5G0LVPbV1LkOUMdC5hmxmABpdw6MSBSH+sjY4RI7OsU9jyB2D1RFK/cgOgrjx7v+m7+CC+xyeO+yXJLa3qO+ILaB3gfSoaAJgoGqqb4D1d+jTzDuWEK4GmeoB4B2kUzlrnJIPxMGBb7eSE9hVAcRUxAaS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(39860400002)(396003)(376002)(136003)(451199021)(8936002)(83380400001)(8676002)(2906002)(316002)(38100700002)(3450700001)(41300700001)(66476007)(66556008)(6916009)(4326008)(86362001)(66946007)(6486002)(82960400001)(6512007)(6506007)(5660300002)(26005)(6666004)(54906003)(478600001)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NDyCoJj7x0yBEv9C68ald0Uc3+VsGold7ZnKWoMKcUWRX1LwrSdEeaSIfXBo?=
 =?us-ascii?Q?m8mVIfwHEO+cRpCt6cmZayqWFxQCMSbeSqjdmXsHU2dgc9N1HDQTto82oJZZ?=
 =?us-ascii?Q?8k+3FQhFOlTOlRTbK0NhcArmL6yR7kGEJq21NdFZ0kBrTaw6pXnxPrF1mSHo?=
 =?us-ascii?Q?FNY/XkSf39gyuD5IxOF7Jdyebg1ojqxVEdjTxM8iFVSnfmAJidV1sykeK3Zg?=
 =?us-ascii?Q?0RL/6vPCJOf0MHcpU9CCkgTn4ts0rT2nTbmQ8kydqLERncHuHGC72ILx3Tlf?=
 =?us-ascii?Q?+VDkAyUsWgvURqXU+9/oxbhl9W3LR1o5igoHx5T9PHgaPesYaizYRTZMj6s/?=
 =?us-ascii?Q?fUy1FUSYwvzSvxYE04BRDSyHd2/sxiP4Jd+dMqrRxq3zg7bvlxcZ22Ci15v2?=
 =?us-ascii?Q?GwZT6WP6AUsufO504H7bD/TeC4d20A1TAvGJhYzAHaXtX5ampE/B5L7jzOC8?=
 =?us-ascii?Q?wEqQE85a+nW6yL3Hpp98IgjmN7py9/FOxJmRR8tn++uftNlEfcREtMx0K5f4?=
 =?us-ascii?Q?dM/HFsPRZc2An2KIAK6EhsBY9FW89TkpHqgP4PMJeT94N1tVKOnwSGfP8eoF?=
 =?us-ascii?Q?2yGr/Ttm69xxH+9stAjf6dyNLSEn2gaW8VScaxS/o6NrX3uqOfhcQS0It2J4?=
 =?us-ascii?Q?WXJKVcKHAPX5p2VXStlIuNSL8EhfOcMzGXhX+iTD6fFdO4ECcunrT0+2dcVf?=
 =?us-ascii?Q?Q38OrgSnyPsgaApLOUiVLG1W1DRoOKfxVyhfo/LfgMELeC0swaknmA5u9anH?=
 =?us-ascii?Q?X+DaHF+h4Umt11ApbZNk0hGz2Pq2Vy/jrjn3yDNqD4iWk7tUuh0k46YY78bt?=
 =?us-ascii?Q?U5LmC36aeBfZVXRvgHIydEzOiEMbWhY4NDuV26TZE4J93YGDxmout2fTdyze?=
 =?us-ascii?Q?tglkES6mFQrLhjFwQhu/HnW1ZkcB7OkxK5vPYaAbjPHnT+xjwBcSBNsSYUn2?=
 =?us-ascii?Q?nIDEytDHiYiLlm/569KTQAZrw3UAGzGdbQ526Y+lFmjGmDoYrUFCAHaMTkPj?=
 =?us-ascii?Q?RAO+lCu8r46H65qHP+G9PRU5s4eEieneOEuj23qTC3C7WpOwQ0w5h3AG6SzR?=
 =?us-ascii?Q?yk1jFrWmKbr4Mm03/i1A9Qw+LyyVvMQvVQsyliGstlnvWz1WkORY4coF0beD?=
 =?us-ascii?Q?X+xwziJVkhZyZaY7tINHG/ToeHKTThUv3d7yRcLCTaUfbfLSJJOxbSkfkgXz?=
 =?us-ascii?Q?g1GKLGrn+XlgHPoS/RrTOXKlW+tGyC518Mi3++ZM3t52G0yDg+V568F7XXkG?=
 =?us-ascii?Q?aSFVDhw7af50BSq1mdAuD41ULMczBiEpPDeywWAFU50fGnvB5wajI5KbjnsJ?=
 =?us-ascii?Q?/P4XT0yWQ85fy1JOr2ni6KHHUAawLrarGhhvxuZ8DQkT0S6XC0g9InBtkD3S?=
 =?us-ascii?Q?z02/SPn9VBTNj39me/sWwIGrNe6QsAT/5byBH8pTeKOYqrO3NpbKgnCC/aMG?=
 =?us-ascii?Q?aJo0ZCziIAdTHJ/8+KjOHeJhV9CZ9xOGkfjtO8nIsWkLQnSSBVLIUK56RvcD?=
 =?us-ascii?Q?RdLmT4VIB/e4ETCJmy4yb97Wp0EVNMLGDiq0bBMJS+1cqsDexAjz9heXiCg4?=
 =?us-ascii?Q?dg0YC2zVcx+YdF1r+lZzLkLQUwdLbH4d6Vj8PL9Z?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d96b28ec-0f90-4afd-99a7-08db5782b572
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2023 09:31:50.6737
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZcGhs5FEqoVqinnYQ0eBjCMP4d8Mi9QR0dndK/kcFBfHgiyNPwqTyTqTrl0tQKGrkcBDf3yyxNj+MM7c8MP+mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5250
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

On Wed, May 17, 2023 at 07:50:26AM -0700, Sean Christopherson wrote:
> On Tue, May 16, 2023, Yan Zhao wrote:
> > hi Sean
> > 
> > Do you think it's necessary to double check that struct page pointers
> > are also contiguous?
> 
> No, the virtual address space should be irrelevant.  The only way it would be
> problematic is if something in dma_map_page() expected to be able to access the
> entire chunk of memory by getting the virtual address of only the first page,
> but I can't imagine that code is reading or writing memory, let alone doing so
> across a huge range of memory.
Yes, I do find arm_iommu version of dma_map_page() access the memory by getting
virtual address of pages passed in, but it's implemented as page by page, not only
from the first page.

dma_map_page
  dma_map_page_attrs
    ops->map_page
      arm_iommu_map_page
         __dma_page_cpu_to_dev
           dma_cache_maint_page


Just a little worried about the condition of PFNs are contiguous
while they belong to different backends, e.g. one from system memory and
one from MMIO.
But I don't know how to avoid this without complicated checks.
And this condition might not happen in practice.


> 
> > And do you like to also include a fix as below, which is to remove the
> > warning in vfio_device_container_unpin_pages() when npage is 0?
> > 
> > @ -169,7 +173,8 @@ static int gvt_pin_guest_page(struct intel_vgpu *vgpu, unsigned long gfn,
> >         *page = base_page;
> >         return 0;
> >  err:
> > -       gvt_unpin_guest_page(vgpu, gfn, npage * PAGE_SIZE);
> > +       if (npage)
> > +               gvt_unpin_guest_page(vgpu, gfn, npage * PAGE_SIZE);
> >         return ret;
> >  }
> 
> Sure.  Want to give your SoB?  I'll write a changelog.
>
Thanks!
It's just a small code piece. Whatever is convenient for you :)
