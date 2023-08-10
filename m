Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3441777599
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 12:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234787AbjHJKR3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 06:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234459AbjHJKR1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 06:17:27 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D30DF;
        Thu, 10 Aug 2023 03:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691662646; x=1723198646;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=CVCVrYx6U/w3a0E+Xj/AZBpQhn5ABz/ox55go4NskQQ=;
  b=fX8NujWwBVX8i6aAc0hzSO3mnCHK0kNMmVQCu2Q4ISnNy2xRsF+PFts4
   EV2kbkf7QE6BCSI4g5mauM+6ClnOpHaj4PJKtIOdId99BOj7PFk4iMvC9
   nHgDau3PM8DDG32mzPynwys4Q0g37G8dMGCeHmnMME3TRzBARhFQ1zNMS
   g5W9Gy35caal/QUSUKH1K7FHd1Z1j25q1z5LrVMolXOJqpnQmsEthVtRq
   5L55XfLPCX7iiafhJ7g4PwmJt2MKW8ffSAdaYPoQzsaXvdkMp6bGp4DFk
   dGGg9vhw8z2yG9xsIs+dBcZ7+7ljfpxl1uyBOREwq5Q9K4b1unuLsDKxX
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="370256735"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="370256735"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 03:17:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="709096160"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="709096160"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 10 Aug 2023 03:17:25 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 10 Aug 2023 03:17:25 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 10 Aug 2023 03:17:24 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 10 Aug 2023 03:17:24 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 10 Aug 2023 03:17:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HXcAA0yBC7MYz7dctL2glM/++r4fe1vLpFeHhN4DOvUs/bYTQnPDHIH1HQJuGOgjxSj4BSdcYd8Q4bruBdtiCmiCy7pi84Wia3cI19k7yKo1ZjAwXBPgonzSFBchqPoDlTzZoQYaPdf8FJ8gcMITFJ5gpfGuy3ew48aX9s5fLxPpUX9I9xlko2ymr2IewVZhLitYmEZhNldjEsVR2aYRwjU1hbGUXWLTqjH9cPJjnEMPZ6CvohY67xAz2F7Cq/uyVIEf0OKKuiFulvmgJrt7cq68LyswgvT4cC56Bt+dhCKi3W1ZOMnmQHjLlpkO7xOisgJAGam9QmP/gjAXuEsgdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0mRWZaRZsi22A7QK6P20CCCm54bL8+SDHJUw7SBjD4Y=;
 b=b2Gbe6x9S+BfhrFlrZf1gn+YImTJxOBmGUCi7ueeg8K2HDUJokLBoHVJfXdx1giwWEEqnjUkqdw6Hl9R4YhYhv8ZUJGkRw9VQl4kfa425HSnQUtsmgcRPaRUY+xhfApL+mr0zyodoiuTUp5O0k9UuhDMKg5c6QUjin0BUIRb4LqtU3nBOehYqe0yHeCIoXkCO6Ej4LVZGrDbBVd7vDvkAw3Hy29D4IBDzQy4aA8D62ByKoP9M/XF72zZ0H2y5UWtuRYZwDrmiIcZ7NVwtQI2RTLpQPBdwwXIxKaNGpUmRs+Wf9oOvq8asvHGnSyypLKlnts1mOvY22mbMUk62iwgVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB7147.namprd11.prod.outlook.com (2603:10b6:510:1ee::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.47; Thu, 10 Aug
 2023 10:17:21 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63%2]) with mapi id 15.20.6652.029; Thu, 10 Aug 2023
 10:17:20 +0000
Date:   Thu, 10 Aug 2023 17:50:06 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     David Hildenbrand <david@redhat.com>
CC:     <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
        <mike.kravetz@oracle.com>, <apopple@nvidia.com>, <jgg@nvidia.com>,
        <rppt@kernel.org>, <akpm@linux-foundation.org>,
        <kevin.tian@intel.com>
Subject: Re: [RFC PATCH v2 0/5] Reduce NUMA balance caused TLB-shootdowns in
 a VM
Message-ID: <ZNSyzgyTxubo0g/D@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230810085636.25914-1-yan.y.zhao@intel.com>
 <41a893e1-f2e7-23f4-cad2-d5c353a336a3@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <41a893e1-f2e7-23f4-cad2-d5c353a336a3@redhat.com>
X-ClientProxiedBy: CP6P284CA0105.BRAP284.PROD.OUTLOOK.COM
 (2603:10d6:103:1a8::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB7147:EE_
X-MS-Office365-Filtering-Correlation-Id: 1978d3aa-b3d3-4bd8-0560-08db998afb83
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EPmVbKOu4FidGRe61Wxopg6UagSQ8OLpDZBIxekfIuzdOyc5ofr/533v6Vxs96KWm/zDfFZmKYod3PDoKb1pnmrloEVvc1uAjn/tASiEI2kMmk0AI6GUUjSZ5Eb1uynpN79SHiNGRfCbhW7b1kvPiZmmirvMmpiRxY7DyJ1bSjI8eW5S3EWiR4VU1JL/Uc6d8KDw7c8UT7XyTLYXkuigPzE8OUL9lttpZcWwWEHn9pg+Urxd3jjC42sIIc2JJE+RY9Dnyfi9vO+ebrhsHpuuvfHvtDhZXpiDMny3Fwa+1VviQ0jwGRoACvUN/sUxACW29VTDt0FyowmcLqPXOGVBv6f/Cgc4tKhcwN1nfdGY/pn5Z/yY8UqubeQXvnxPyLyWcAMy9KKH8RGMn+cMEQ8XmkuaP5ht5R27jdIZEmxRPGoS/RSEiNEtNWK/vEtV1IjrjaE1qud/zi5pMaNQOqkOJ4ysMCmMO4UpGvWgTxMtlVbOkArg0vjSmeDEJx/jkQZxSDa/sLdml3In25PQowZLIXj6w+Ve+H3IAdKgK+nBq0xQThQuDsitFBHK4qij3bky
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(136003)(396003)(366004)(376002)(186006)(451199021)(1800799006)(86362001)(83380400001)(38100700002)(6512007)(478600001)(107886003)(82960400001)(316002)(8676002)(6506007)(66556008)(26005)(8936002)(6486002)(6666004)(41300700001)(5660300002)(4326008)(3450700001)(66946007)(6916009)(66476007)(2906002)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pCuYGTC5OT0+Fl+HKBPjAIAEd/2diKHPW7j/bJY6UAqQmB+DQzLLzGtFQHQI?=
 =?us-ascii?Q?3aLFxOWr4gUiEmRkmICPgG/C+vE7r6POR7LiO2z6dgRZh5LQhoeREWggzned?=
 =?us-ascii?Q?2F7lfZbBhyqeFU2qRxoDrbTxfH+3EeP/UJeLQz2liTddHTLGFLJpWM2J4Y+v?=
 =?us-ascii?Q?1oeEo4XlAntL5xPjLJtRLmJXR95jbNK3aOwfY/Y4EtRh5J0OhL1gMbq5ZLXR?=
 =?us-ascii?Q?i1g/TTRflglR6Csgkkxc8XZUW/QxPH0x6LSjv4Y7jo+0goIaN2Q4PEQjjfXB?=
 =?us-ascii?Q?9shx4ycZ21BVzquaModeXOMZEhw6tCMrxSNppUX6S66RXHc6q8w9CMje/QIE?=
 =?us-ascii?Q?YYb+HAxqB3w6AEWCG8iibZJRCspdbJYMuYhWPbvz+tIif+pJbojWtVwcKIIO?=
 =?us-ascii?Q?+eY1y7kmIMuDNF6cyvTveFEOl03LmzpQ/VN71YBrXdioZ9tqqjoGUcqe6+77?=
 =?us-ascii?Q?CGL5zf5+cnUtNFZDU3m4n9kItUd2zEvWzcm+4/yN2USoUp7JhF2oS4JWkryD?=
 =?us-ascii?Q?dr8m2spw+qnpd/+KM8vNmOBACJ57cq7KeJNmcxolC9kb0W/kyEbsn9STWnZA?=
 =?us-ascii?Q?Ur2aJCR6GI+vDbHXuMCSFE5B/bnVxjAH4Wvvq3u0ySR2lvW4F2i2ccqWkgDG?=
 =?us-ascii?Q?Afgp2mFfjMnw95jkdhsE+ccmff+5fNDu+9kRwnYlCXGnh3DQQJoYvTbHt+60?=
 =?us-ascii?Q?NqxWuZNp0js8w0IK0VhxUuyrvVwDizADOJibF2t54dyOtxKkL2zz0/cwGg0g?=
 =?us-ascii?Q?mRsf0VXhJOJ/gHrHOTyPpP0SgWf0++K/rvZ9yF10jKhtKMiQOIbkW8OW9Hy/?=
 =?us-ascii?Q?Ob85Myt/ceP3JTsjTRLixnrs+rZLZElqDMq6WCYRAqSXQ/zrx/aYmZSP0xhe?=
 =?us-ascii?Q?MX9ca/pElPnKRVuXH6JYLmFcP45I0AkVnfuXEmWNZR0laNhBuSXaLvKByjik?=
 =?us-ascii?Q?47kQI5FOATXUGjPTU+wX90PMywR4Zcz6wDmu0moJVTKUGZmZFzfhxtmyuGSm?=
 =?us-ascii?Q?Gn9CDumv6zZasIQDhfuTryYp1WpIB0Cj/zBd4P3zFM95NgUpQt38SWYeDHlp?=
 =?us-ascii?Q?RcBCtCCaQ7lniTQkBH9D7rWcsvoKuP/AI+fTbbCZBoN75AeIOHpCxyMR3Edt?=
 =?us-ascii?Q?JEIeNK3fgrvhbw7ai1QzB8PAZm3tv0rCiC6EQpwE0iVCCXZVHJ+TrS2iWgJW?=
 =?us-ascii?Q?W2KGJQ6g37jH+nzLJCp+M2XhpAHGW1MMy8jr78DfwTY2G0SywMf2yjAgcUZZ?=
 =?us-ascii?Q?ldZZZkOC9IXEy6cAdiWzPwapU6ZCCeGIhdWICZvuqaIm0515+uSaD0Ffde7g?=
 =?us-ascii?Q?nmE5sIusiP2vdp4jwUpkhebEh2qmm6BBAiG5ZlwT+hIMM2xSohK4pn4Jj2ye?=
 =?us-ascii?Q?XKkh6xFoZURp9lNLi5g5+IoK9FAUJOntCxW4DRoBPBY9Hb6Gw3k3Bh2htnqg?=
 =?us-ascii?Q?gOoik4b4J69e4yip0NNDTm7pvWcAfW1uEjx90eaNqFaxfGtONvxdTk6ENH2j?=
 =?us-ascii?Q?bUDlNXmNjVAkwxe77nnYM90emQIUXQj58JuiDAmQz3T+kRnOXFYg+bn+dhXI?=
 =?us-ascii?Q?I0zs77BTefww7Kk1RpfK7PCw5ZLbqZQcs81M4jyB?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1978d3aa-b3d3-4bd8-0560-08db998afb83
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2023 10:17:20.8753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vcIOsBB0taHVxtilZ1Va1dhYRI8LCskNFGZajkqjWnOivyS+qIQvUCY6SNp0bFXytjjWi8t6IKBBc8OZVf6x0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7147
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 10, 2023 at 11:34:07AM +0200, David Hildenbrand wrote:
> > This series first introduces a new flag MMU_NOTIFIER_RANGE_NUMA in patch 1
> > to work with mmu notifier event type MMU_NOTIFY_PROTECTION_VMA, so that
> > the subscriber (e.g.KVM) of the mmu notifier can know that an invalidation
> > event is sent for NUMA migration purpose in specific.
> > 
> > Patch 2 skips setting PROT_NONE to long-term pinned pages in the primary
> > MMU to avoid NUMA protection introduced page faults and restoration of old
> > huge PMDs/PTEs in primary MMU.
> > 
> > Patch 3 introduces a new mmu notifier callback .numa_protect(), which
> > will be called in patch 4 when a page is ensured to be PROT_NONE protected.
> > 
> > Then in patch 5, KVM can recognize a .invalidate_range_start() notification
> > is for NUMA balancing specific and do not do the page unmap in secondary
> > MMU until .numa_protect() comes.
> > 
> 
> Why do we need all that, when we should simply not be applying PROT_NONE to
> pinned pages?
> 
> In change_pte_range() we already have:
> 
> if (is_cow_mapping(vma->vm_flags) &&
>     page_count(page) != 1)
> 
> Which includes both, shared and pinned pages.
Ah, right, currently in my side, I don't see any pinned pages are
outside of this condition. 
But I have a question regarding to is_cow_mapping(vma->vm_flags), do we
need to allow pinned pages in !is_cow_mapping(vma->vm_flags)?

> Staring at page #2, are we still missing something similar for THPs?
Yes.

> Why is that MMU notifier thingy and touching KVM code required?
Because NUMA balancing code will firstly send .invalidate_range_start() with
event type MMU_NOTIFY_PROTECTION_VMA to KVM in change_pmd_range()
unconditionally, before it goes down into change_pte_range() and
change_huge_pmd() to check each page count and apply PROT_NONE.

Then current KVM will unmap all notified pages from secondary MMU
in .invalidate_range_start(), which could include pages that finally not
set to PROT_NONE in primary MMU.

For VMs with pass-through devices, though all guest pages are pinned,
KVM still periodically unmap pages in response to the
.invalidate_range_start() notification from auto NUMA balancing, which
is a waste.

So, if there's a new callback sent when pages is set to PROT_NONE for NUMA
migrate only, KVM can unmap only those pages.
As KVM still needs to unmap pages for other type of event in its handler of
.invalidate_range_start() (.i.e. kvm_mmu_notifier_invalidate_range_start()),
and MMU_NOTIFY_PROTECTION_VMA also include other reasons, so patch 1
added a range flag to help KVM not to do a blind unmap in
.invalidate_range_start(), but do it in the new .numa_protect() handler.

> 
> -- 
> Cheers,
> 
> David / dhildenb
> 
> 
