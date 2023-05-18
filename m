Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8CCE707756
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 03:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjERBR1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 21:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjERBRZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 21:17:25 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9159A30DC;
        Wed, 17 May 2023 18:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684372644; x=1715908644;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=6H3S+G5xPTYL5h9NBraCzEOK8YHjYyeMC+5+pqmNVQ4=;
  b=hehwagSGItIS+Cz5n0BARcGL77/zN/s5tl4kpxecBw1rGtJDGuiWEWw3
   aQ2ve+3vnGJW/0H10brGyO9+8i7/+GQtl3Nk+Sfw/8bN7KLwnll84leof
   uPi45nYDGm7MUiID1Dq2zX10rRRahTkS15GEhBGMqvTOkL8QWX+wJoO4G
   yP1XxMVfxaZo0quBxPyE6ulZRcPTssLUBMakzU6UhLhecxqsJSoV+VNEv
   ZRQJqkAfXphzFfTfERYHST5FP7xGj9nvQJ49fJUkNAzRJcstT30eU3Rqk
   A32bDteiVMC+BdGjfeazOfxzntLOATK+uxWLkmqjWD1VwXHRQ8wgfpEvx
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="336490656"
X-IronPort-AV: E=Sophos;i="5.99,283,1677571200"; 
   d="scan'208";a="336490656"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2023 18:17:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="791749329"
X-IronPort-AV: E=Sophos;i="5.99,283,1677571200"; 
   d="scan'208";a="791749329"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 17 May 2023 18:17:23 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 17 May 2023 18:17:23 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 17 May 2023 18:17:22 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 17 May 2023 18:17:22 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 17 May 2023 18:17:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m06VVqB7Hw4ShrDqIabRC5EQJRMBEaZg5X+BCamsI/gHljxkAjEumIbvd0vm3i5CKYmUVrsEC3HLIlCEDIXO5uBBbPZ2wGUhDJ4ciqrIkdCfA40yQxfxXhDtp7rENxwqQgzl9+vIuksWm1s+CXFnWNbeI58u10LageOujeCg8MDUW2AaSBE5hp89/kiqUIBmPR8FzDyvJDV+fB6+KBzZiCWykQ/XDJ1BViqIsxRNKu4M4qojehZ9FG1c9go2BwVECrW7F7HmorU04QY3ytwAIFRFDQSKENAYLdeMeoZOh9Dj7GVEsKNGzfiylaElJTC0Erh6BC0Q3aZfmOamoinVYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=re6LUOVc16K4h//h+ljbF+4dKu+ypMuMs3dRfn/SFCg=;
 b=dGZgcgiGgShshqe/p9ktSQZwOJFBouXH5tcvaHuuYWc0cuy1+sqWpAPbPWWRCGXYIaHsvZQzEPBie8awDeYeob4tozRTuxnzMDx2hxmgcxof50L8wZOUuujxZR0S1paVqCnhjGxUy9wGBZ5gTxAfXfb1/1iMf4iKhAREnMot+V9400hL/2LFcfc45IIg6cKW3xk0yXSAqo/y86RtdSsWaNYiT00IGGUbwzn+u/ShwooWOZgXhuRNd7znbFRXTZKBg6tLzchQ4nXh+S+63VJYXoKS7Axk8xZPtDDxT1jbEMUCDDK1AzhglspUf8fkJZSn5LG5myMuuHRYw03VLvmr6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM4PR11MB7758.namprd11.prod.outlook.com (2603:10b6:8:101::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.17; Thu, 18 May 2023 01:17:20 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4%6]) with mapi id 15.20.6387.033; Thu, 18 May 2023
 01:17:19 +0000
Date:   Thu, 18 May 2023 08:52:12 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <alex.williamson@redhat.com>, <kevin.tian@intel.com>,
        <jgg@nvidia.com>
Subject: Re: [PATCH] vfio/type1: check pfn valid before converting to struct
 page
Message-ID: <ZGV2vF0MQwQ+LZRX@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230516093007.15234-1-yan.y.zhao@intel.com>
 <ZGTwaP6peRcpl+GA@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZGTwaP6peRcpl+GA@google.com>
X-ClientProxiedBy: SG2P153CA0049.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::18)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM4PR11MB7758:EE_
X-MS-Office365-Filtering-Correlation-Id: 746f0dc0-ff40-46bb-1e73-08db573d9fcd
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E0xmHgoIvKYpPfDUQZVs8pClj0+K4hDzrYDOb8H23+0BYDYILOg3OxTAceEypNQ1NAI9J+NrT6rXxwmJ5E66kVVweDDnGja2febP9el7eWskFqi5UWbYox7yDDhWEdRVrVOY7mUi32kkmxubjBgzYNuZNZSqoS69AkCRV9kPtbonivesN/fNnbJj8nmp1S9vxFrHNZIV3rr2wjm9eUeBAz2KLlZ36bgR3UWfuSF6T4eAtpX+XEPMbGR0/sKM94W11pu9qreUOCBtJiBJW6tGZlJbluC9yo1kFPh6ZmkNnxqDgMDjbVhmdHyaJRmwVmeTjT3eJyrcZ60PrBvgLF2F/bS7xQ4qLcmA+s/1sD/S++KWx9Rk1v4ZfQm3NZFfR+5DrC1SSeXZwGgj2+kAD5vbu/pqaBUrbX/sky2A35kq55KRWt9rBy5LUOS++juf8KpC1o4H4nB7U6JZrgvl7Yl94eyOhG+NSd9pOLdvJQVU7cqZBpo3L8C1Bh5vDQkKTnH0vS0EgIZHxMCL5tnPeHOeEgcD/5RrRfCgZE/LNKKJyUdEplqku07kNPI6BPnvJqlCi7nfTFWOCrKMDKyUuwLuoekZf4xxlxzocNHtcx7bovg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(346002)(39860400002)(376002)(396003)(451199021)(41300700001)(6666004)(66556008)(316002)(6916009)(4326008)(66476007)(66946007)(6486002)(8936002)(8676002)(5660300002)(478600001)(82960400001)(86362001)(26005)(6512007)(6506007)(3450700001)(2906002)(186003)(38100700002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a4PYn4SbqfV1I/Iaugq8NCbw/UL50/BB005xMd/B8vrcrgd45uC8Ef+XYN2z?=
 =?us-ascii?Q?oDDlGrO39oBQnvPyTeKKIFHT0Kwdfsi5ZGPXSgpYpw4mT2I6vDFeeVFYH1/+?=
 =?us-ascii?Q?twr56A5NQYshQRYjATsvw2S+PNzoma0er3bM6dxcOYtZwmMwiCalFGE4dWGG?=
 =?us-ascii?Q?3kuH1trNjfy+BZLFgwlJkuXA1+qFe9+QxLyoc6uPaza9jcHZHCOjL0Wus0Aq?=
 =?us-ascii?Q?ZRLoClvKGnI0vI4GyxEs/8xYG82A8cTRVvHotvcADQPw7qV5RR6j1xXcocmL?=
 =?us-ascii?Q?kHfRFNn9TjM19R8PVhKb4cyol1mNtzm5oOMXSPPNueiI9A6NUVpItXQH2nSX?=
 =?us-ascii?Q?p2+d8MlIQMvXi4d5L81kh1k4unIoeSHfqHuCs2d54ALf/51gxDVCKWYURoSy?=
 =?us-ascii?Q?+5I9STmiUJ7MRexlBMpcP64A7TOyCPGLSotwGm8b+zsd44pyvx6iPvQ776j5?=
 =?us-ascii?Q?mLgq30sUsGMKKrO0nNAZLjlpRBVUQPUxtA41uaikuoSlYbwlFzbaW9+WMxVy?=
 =?us-ascii?Q?/zR0vYgpZ6igM5CcvyzHTgrVZ9VpIncog7FtB8n0InQ0a1dqEbPDfx01WQsF?=
 =?us-ascii?Q?ihR2C7NTtp0Eb8Hb5Vpn+EZLDPi5AqrV2GVRGYbppESpzAUyMHwMus3wTSfA?=
 =?us-ascii?Q?borezh3x7ZfRbLtCiGyDBnEgWFl/5XSyXlGsEczkl+1ia1eJE9z176X2y7cK?=
 =?us-ascii?Q?WrhmiVsMChodhYSqcIXoVtYTg/wGe2J//kQaZKXwg641wSUYnn95aK38faDR?=
 =?us-ascii?Q?tflVIkGDhn+i1l7IIHB7gAPRtxreGGtf3NRVU+cLAJ9paDwOJH3Vyj9yJDCv?=
 =?us-ascii?Q?6x60owX2/4ykpFMdjAt6CJi6OwLfRe8rb7ecjVl1bhHV3rgY2j20P924Q9rC?=
 =?us-ascii?Q?ZGuIVvRNgAcL4yuxsDjlIS3et0sKFBbaerEJwt0so6C1GEGGyRcGBJLCgXzz?=
 =?us-ascii?Q?ImS47BUALeiyLBSoo9/YulqqVrhplUVnNwNPjjHldLv98CVbxZCCZQEXMVIA?=
 =?us-ascii?Q?3o38uL/rxXgzbXweGlK3+UGDyYxvQ6JKuHUBSEGhZfaU0AphL+odmwo0GLN1?=
 =?us-ascii?Q?2B+fQjI1cQboiR4SaSsxqLaoAY/7l6rZiMTqu/QPSLzvFiCRLAxdw/oaj/ff?=
 =?us-ascii?Q?JF+KhxnR7STxk9joeQomQ1oJMtqbDWFaBN6vUVxWva2dcCkljO1he9Q9ttrJ?=
 =?us-ascii?Q?XlS75Sz0upwcdedSr19Kgk2addqv36fZHuZOMO4v/YD9g3MTxW8/ClldrOU/?=
 =?us-ascii?Q?4B41QFlcnRtuUZQGh5+5yFju7WLCGP1/rVMuflU9KN6URwFIbLyaySTB0amW?=
 =?us-ascii?Q?fuwBSnRPKAIvPrqxKreDRzYojGKpbNlvBW2DeLceiXPfYaYvpRrZGYOfsTb1?=
 =?us-ascii?Q?JMTpHD7ZMXO4gymD5/LUgCKktPPv9yCIrhD1Oykd7KHPYSnbeCStOWCZVbUO?=
 =?us-ascii?Q?tMHtHGg5YVSAz0nX4JDw0W1TdLZZLo69DLeNBiIIGpLM+RdVeJcocRBzliZo?=
 =?us-ascii?Q?GXXB2v1mKwER+IgATZ01Vk5SoRWUbTvepf6tMSTsz/6olvxIzSeIpjubPH5J?=
 =?us-ascii?Q?CKdo48azal7oTMSYF46RdPNuBv9/YCujgMZvFH5F?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 746f0dc0-ff40-46bb-1e73-08db573d9fcd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2023 01:17:19.2543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z1/SLNfSqu8M/2DUhB09hBTxRDkQ+jJypWgUKHgalA57CQwOOwo17EFQduLiI0RIkNUPQ5bA6lJ4lzGwebcQgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7758
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 17, 2023 at 08:19:04AM -0700, Sean Christopherson wrote:
> On Tue, May 16, 2023, Yan Zhao wrote:
> > vfio_pin_page_external() can return a phys_pfn for vma with VM_PFNMAP,
> > e.g. for MMIO PFNs.
> > 
> > It's necessary to check if it's a valid pfn before calling pfn_to_page().
> > 
> > Fixes: 34a255e67615 ("vfio: Replace phys_pfn with pages for vfio_pin_pages()")
> 
> Might be worth adding a blurb to call out that this is _not_ ABI breakage.  Prior
Do you mean "_not_ ABI breakage" with
34a255e67615 ("vfio: Replace phys_pfn with pages for vfio_pin_pages()")
or with this fix commit?

> to the buggy commit, KVMGT manually checked that the pfn pinned by vfio_pin_pages()
> was pfn_valid(), and s390's driver(s) either blindly expected struct page memory,
> e.g. did
> 
>         ret = page_array_pin(&pa, vdev);
>         if (ret < 0) {
>                 page_array_unpin_free(&pa, vdev);
>                 return ret;
>         }
> 
>         l = n;
>         for (i = 0; i < pa.pa_nr; i++) {
>                 struct page *page = pfn_to_page(pa.pa_pfn[i]);
>                 void *from = kmap_local_page(page);
> 
> or in the case of its crypto driver, apparently was all kinds of confused about
> virtual vs. physical, i.e. likely couldn't have worked with anything but "normal"
> memory anyways.
> 
> AFAICT, those are the only in-tree users of vfio_pin_pages().
Though there are no in-tree users currently expect vfio_pin_pages() to cover
MMIO ranges, with the
commit 34a255e67615 ("vfio: Replace phys_pfn with pages for vfio_pin_pages()"),
the IOVA ranges supported by vfio_pin_pages() is still reduced.

Previously, it's the callers(vendor drivers)' option to decide if they want to
support MMIO GFNs or not, while now only if there are other interfaces provided
by VFIO, the vendor drivers could not allow pinning of MMIO GFNs, i.e. no guest
P2P.
