Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF8877B59A
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 11:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234757AbjHNJhC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 05:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234555AbjHNJgb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 05:36:31 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E633B10D1;
        Mon, 14 Aug 2023 02:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692005782; x=1723541782;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=RKvYTqzrXcwlZ7NNW5wfBFv7WF5t4ecZEc6u2PU8cCA=;
  b=Ja2R/CD1REnKvab0ew30Zjw6/rHDtPZDK7/KX2PJqYzieInn1HH/3lDW
   js9Vamyj6SiuyFKh8UB4BJcrCdBGJMQDKAP41K25NKyvlNaNCB0B4n3rY
   ZBd6sjS+De0i9rgFBoxh2/k2RjV8/+pYJfoDUG8jYCUKdhvulD7YJgxg1
   h7oOg5IiXd6qNPUhArpTWr4NBo1xHjuLmyOC91n6+qRFClrmEiH9C8A4+
   TsYgfCUJXe8abOMAjlAu4WQ92UdIOXN+2SLX3EAmIGJTkGRIWMFLGThz8
   5ZqKCCxTIrIcON5WI/s4kBjldfMm2nsrBWnJ7czXqE2M5EFkAF4u3Xad6
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10801"; a="351597682"
X-IronPort-AV: E=Sophos;i="6.01,172,1684825200"; 
   d="scan'208";a="351597682"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2023 02:36:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10801"; a="979930686"
X-IronPort-AV: E=Sophos;i="6.01,172,1684825200"; 
   d="scan'208";a="979930686"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 14 Aug 2023 02:36:22 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 14 Aug 2023 02:36:21 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 14 Aug 2023 02:36:21 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 14 Aug 2023 02:36:21 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 14 Aug 2023 02:36:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jwpG6w20i0ZhLKOBUNCojLyJC9F6Gq/Mfse3+52Sp0rI82ekT165bdkfhBxDhAxrBkLWZXGWkmiHI49+KqDWzhbYQR3x3CGeSnWc+oWB5DsKQZJc6iOHf80ymxcgNHjwON4b/h4WsrS053Yje5rJ5xIp3uOIlq4nYBw8HdWOn0U1mRgplFLVE6LOR2Fr7JQO9mR4UZm/hdYA6BgRReThGyV5elydrVEYXqORMJNWqMxACH5EiSA48Me/vAZzTBdKu4kPC2a521xvKN1RJXi+4RsxR2s52bBfuuc8ES/oKEuawZ64rQR5n0idpRvHJSlcSfN3DwZKzrQo4NBpFRmg5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zf2GFVTKNjQyfFGNf7ahLCEOd68aAhE1WrNzWdTgOsc=;
 b=fkdwfFkreQPo/YIAHbortlwpUXuruN97AYq4DyLwI9JG/oBEIElDKkLBlxRWVC1GbMdZtzGffq0IGXRV2qLXtsL7PZf8m+jtKESdT1sTbEsm4VGGUONRi7F8iT45yLMFESEZBWGfmy+XRnXt+OtZYYE2WFk7o5fQ8j8JvZwMIDeFdPgUCo8Kux89aQIrKiyZGWfgVyXpSVFHR/AxBQfsUM9yvTuLMlbFEdXLNFN0Z+PHl+AbQnLqdnn2uLQxNfTcL9EtVREBTYhy40w/Hx5S+xiLAaQOtDTyMbqktRQvR2SHNKXhfgNGhl+sR993VRutsOxKPKqmdQCAD5mrNTk6Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA1PR11MB6514.namprd11.prod.outlook.com (2603:10b6:208:3a2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.26; Mon, 14 Aug
 2023 09:36:19 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63%2]) with mapi id 15.20.6652.029; Mon, 14 Aug 2023
 09:36:19 +0000
Date:   Mon, 14 Aug 2023 17:09:18 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     John Hubbard <jhubbard@nvidia.com>
CC:     David Hildenbrand <david@redhat.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>,
        <mike.kravetz@oracle.com>, <apopple@nvidia.com>, <jgg@nvidia.com>,
        <rppt@kernel.org>, <akpm@linux-foundation.org>,
        <kevin.tian@intel.com>, Mel Gorman <mgorman@techsingularity.net>
Subject: Re: [RFC PATCH v2 0/5] Reduce NUMA balance caused TLB-shootdowns in
 a VM
Message-ID: <ZNnvPuRUVsUl5umM@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230810085636.25914-1-yan.y.zhao@intel.com>
 <41a893e1-f2e7-23f4-cad2-d5c353a336a3@redhat.com>
 <ZNSyzgyTxubo0g/D@yzhao56-desk.sh.intel.com>
 <6b48a161-257b-a02b-c483-87c04b655635@redhat.com>
 <1ad2c33d-95e1-49ec-acd2-ac02b506974e@nvidia.com>
 <846e9117-1f79-a5e0-1b14-3dba91ab8033@redhat.com>
 <d0ad2642-6d72-489e-91af-a7cb15e75a8a@nvidia.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d0ad2642-6d72-489e-91af-a7cb15e75a8a@nvidia.com>
X-ClientProxiedBy: SG2PR02CA0103.apcprd02.prod.outlook.com
 (2603:1096:4:92::19) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA1PR11MB6514:EE_
X-MS-Office365-Filtering-Correlation-Id: ccc647d1-f269-4f3c-101d-08db9ca9e9d3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NPCHXjX3a69D1C9BX5q9glZeT3aLszePm72M3xxS4LTPFmjdtdvp9OsdJGzJjiBZjrgg5/AyQYSmFPe2YUNJ7ATqby0BLajnmuyja0GyYYPj8vMcxb6+x+lsl8SKjUy7G7u9wDNbTRN7bQ73Dei+aoBOF3JxQXPhDvHv4zPzPOT8byh4+o1a0utV5OqAMqbnAV1I8/oSM9smT9dvwcKfMvqqGbry/1BvXEhk2ONpKNHvJ6tPDWqfrX1I+rlNSf2D87SMyIoCMt2axEcwtQxX+h9eCxWfsRir33w9bxOLFxDpAQwNS6cMVaqDzR38ZVoS46AOi0ArLkU+bzqFcS3n3/RqWZAO6XbZiHZLgfTVrzczp0Euy3PapTP3uoF10JqFYB1wrbyj5sTj1gM8dmKYigNnkN8F+OUwHQhH8c5mepflSLKTVvZSqSLi+nGjiSF3vfHxzVPjaHg528dLUdTyBqPPOXW3zoVfWQbonRD5r84w7PieJncWSbjLwhM59kfAFAWoA3wcInYXHJQnFG20YYKWPofK3zaTieXtsrEPF4G8I9Nd4XNujLo3w6VRPg7Z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(346002)(396003)(366004)(136003)(186006)(1800799006)(451199021)(478600001)(82960400001)(8936002)(8676002)(4326008)(66946007)(66556008)(66476007)(54906003)(6916009)(316002)(41300700001)(38100700002)(83380400001)(6512007)(6486002)(6506007)(53546011)(26005)(3450700001)(86362001)(2906002)(5660300002)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?wLF1m8oNMO2zjcwwuPubg+NiWJmx2zL1Td7HB9nnx2pGx8fZ4wRyxBQMTj?=
 =?iso-8859-1?Q?HtsNKNfIQfLKOAy4bmLNWukm3bNwzqnIXxbJsNykF/LpOIxfGJJu4GJf/z?=
 =?iso-8859-1?Q?mr+ldMBCRml3y2406wMcfW33mvwS9LwcUNE0/W/S4CEyrv9hz8RyNJ+PL6?=
 =?iso-8859-1?Q?uSCoUldq0aTtJYTUDyyf9DA70/HF7pbiO4QmHFyVqv91/zRz9N0OGUGeFo?=
 =?iso-8859-1?Q?hiTokF98j6TdySFrsUtctjlauOda6/mLb5P5c0/zmOdbpiqIKUY5y9GwWA?=
 =?iso-8859-1?Q?sPljoZ2s7GbiDbISlFZNeK03wpAdKkpszyTXLUCY9CUNJDUJnsAcN42svH?=
 =?iso-8859-1?Q?V2mSKVMGaCwUWxG0zC5yE8E8QoYvP83HNjn5hiDcsLMLmvwFwAeACPKwAS?=
 =?iso-8859-1?Q?CzrjH5bNj3JX73vdF7VbO+llWHRI0mZIa1Z55An4dtGDDIJZII3TEUpj0O?=
 =?iso-8859-1?Q?gjLP+W0WoNR44X5b/3WJD0HUkQzluyBF0xR+o2Mefg29+w4lZEjF5/GNTe?=
 =?iso-8859-1?Q?neREMKhAqy+kGechwpPUvjLigXDcdjeX+z+sEOoRsyTQqlftAkoUCh1Z6r?=
 =?iso-8859-1?Q?sc6NpbAau2p+YuJJ7TyxXwef9yNg3uNFeMEz1f6lf6PlifvFr8isvXacqp?=
 =?iso-8859-1?Q?EwDfZbK4fEiALI30NwHVK9kDTQ4sDd+DJzQSYc2wlm6ZdRvn/oIT5nC6zO?=
 =?iso-8859-1?Q?Lx6OM0Z4GGBfxfkGyrzP42C2/FeL8tge6cspDhiv8hNcStzu2Zq6GxVLt5?=
 =?iso-8859-1?Q?1lnv9PE+vFiIEBXXUeC8tOhF9Jeb22Sli2WQ8oTMiPKvZD/2zpxizUSAQT?=
 =?iso-8859-1?Q?hWl2UdFwUo/V6WHzECdnmYDMqCK0uUPZ5quiw73v5bQk5ZbJ1GaeprCtqc?=
 =?iso-8859-1?Q?GCIaG4FgIvRvhDeWq2jVjq1x+htSRvukQgeKSzxZ14W4xc5PWQycB5YZ0I?=
 =?iso-8859-1?Q?kRNfsRQ21WfYfDjJNRACKc2ahuOTLiGUNiIPIyzYDd5gjiTYynGjuABtE0?=
 =?iso-8859-1?Q?gvCcDet4PavJO9rYXfHELKJt1jC8N+fYs2qtyS2SUP7gWg7oX9k+qzimaa?=
 =?iso-8859-1?Q?JOIjT97qg8PyyzC/iTaMAl1hDD/Br8Mp1rVV+aUYSL4sGE3dumiHBGmdfN?=
 =?iso-8859-1?Q?R9gL4HRwzkSnhNOeCKNX5Qmne9TVqJ+HOBdvsgswnP4BGKiBTRcOUgml9U?=
 =?iso-8859-1?Q?as5VEXq7tYYRWNSlPfSq41BwN7TN2EXPw5C0kyp1fTe33K/RfdyMd/BB7C?=
 =?iso-8859-1?Q?Bv6d20E4/MfvVKORWC0T0AizsHmPicCor4D3mVeEGPfaPCCTOhVMhMVBkk?=
 =?iso-8859-1?Q?7ObGFRmbkqi11CYncBa64jebOkIU0ivCzJgCs5ZlzlO6WABuZX4J+DR5/t?=
 =?iso-8859-1?Q?aPAzST4wV8gES0QZajEww1D/DxceX9HXtCkEavMJqxxdTqijDt9w/KmnlW?=
 =?iso-8859-1?Q?42tBRbIqwHpY7HAVbGY+ls0QXGkSUPKkTAFDzElmQhq2sXiaFSpOZhZGpd?=
 =?iso-8859-1?Q?YPABhMsJ+2NQxFhtlqu5eYAbVP0Jlhq23JYD+dgQoPtsHgwslnl8Jm+/cy?=
 =?iso-8859-1?Q?fabuanycQSna7hdY8cnsLcV0Lt3xadk97dOSMfe0YwNgnqH0L7ONrEcVEo?=
 =?iso-8859-1?Q?n9vnlA/7ovkdUN6ijaVkHw4iRTicbu0nGs?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ccc647d1-f269-4f3c-101d-08db9ca9e9d3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2023 09:36:19.0984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 25UvOCujL595U+JvvYxoBvAamS4YQYNMUfay+62/GVRkqhXXffxyyGHKv46inWUXyn8yP9JtepHz9YU9ad5ygg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6514
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 11, 2023 at 12:35:27PM -0700, John Hubbard wrote:
> On 8/11/23 11:39, David Hildenbrand wrote:
> ...
> > > > Should we want to disable NUMA hinting for such VMAs instead (for example, by QEMU/hypervisor) that knows that any NUMA hinting activity on these ranges would be a complete waste of time? I recall that John H. once mentioned that there are
> > > similar issues with GPU memory:  NUMA hinting is actually counter-productive and they end up disabling it.
> > > > 
> > > 
> > > Yes, NUMA balancing is incredibly harmful to performance, for GPU and
> > > accelerators that map memory...and VMs as well, it seems. Basically,
> > > anything that has its own processors and page tables needs to be left
> > > strictly alone by NUMA balancing. Because the kernel is (still, even
> > > today) unaware of what those processors are doing, and so it has no way
> > > to do productive NUMA balancing.
> > 
> > Is there any existing way we could handle that better on a per-VMA level, or on the process level? Any magic toggles?
> > 
> > MMF_HAS_PINNED might be too restrictive. MMF_HAS_PINNED_LONGTERM might be better, but with things like iouring still too restrictive eventually.
> > 
> > I recall that setting a mempolicy could prevent auto-numa from getting active, but that might be undesired.
> > 
> > CCing Mel.
> > 
> 
> Let's discern between page pinning situations, and HMM-style situations.
> Page pinning of CPU memory is unnecessary when setting up for using that
> memory by modern GPUs or accelerators, because the latter can handle
> replayable page faults. So for such cases, the pages are in use by a GPU
> or accelerator, but unpinned.
> 
> The performance problem occurs because for those pages, the NUMA
> balancing causes unmapping, which generates callbacks to the device
> driver, which dutifully unmaps the pages from the GPU or accelerator,
> even if the GPU might be busy using those pages. The device promptly
> causes a device page fault, and the driver then re-establishes the
> device page table mapping, which is good until the next round of
> unmapping from the NUMA balancer.
> 
> hmm_range_fault()-based memory management in particular might benefit
> from having NUMA balancing disabled entirely for the memremap_pages()
> region, come to think of it. That seems relatively easy and clean at
> first glance anyway.
> 
> For other regions (allocated by the device driver), a per-VMA flag
> seems about right: VM_NO_NUMA_BALANCING ?
> 
Thanks a lot for those good suggestions!
For VMs, when could a per-VMA flag be set?
Might be hard in mmap() in QEMU because a VMA may not be used for DMA until
after it's mapped into VFIO.
Then, should VFIO set this flag on after it maps a range?
Could this flag be unset after device hot-unplug?


