Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0C077B236
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 09:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233906AbjHNHTe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 03:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbjHNHTS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 03:19:18 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A34E73;
        Mon, 14 Aug 2023 00:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691997556; x=1723533556;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=YKqZVxbg1e9b+YT1aSZfaJWivDk5MiDH9i1G2wTsGcw=;
  b=I3Rn2d54O6SBCn98EZIdzaU3sRKHpUGBexW5LZsdfHDnyNH92k/pnnVr
   6yKJ/62vKJTw4D4wGileww4DdzNc33RDum+AuDv5xOuRSnaJcEkTKSOXV
   81b/UOuXEFcSTmYQHwg9PCqiWswZORUWx/ZnyN2symTY/h0I9PNk8jn+U
   1dLNQuyTJzJnxpSzoFi0mLbvDhGqrlVrPUZMVaKDqG7MxD+36C6Dg+fRe
   9TH39RR26oRcdKi1CGyPVpyN1/XaRL93hs97F6ZWChdNYab5QfLhfjVOq
   cPo0QvMyOGnMHeULrOd/1MZzRLO/qp80QlOibURqzcvQLr/erpbQmh1g8
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10801"; a="362131259"
X-IronPort-AV: E=Sophos;i="6.01,172,1684825200"; 
   d="scan'208";a="362131259"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2023 00:19:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10801"; a="762853317"
X-IronPort-AV: E=Sophos;i="6.01,172,1684825200"; 
   d="scan'208";a="762853317"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP; 14 Aug 2023 00:19:12 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 14 Aug 2023 00:19:12 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 14 Aug 2023 00:19:11 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 14 Aug 2023 00:19:11 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 14 Aug 2023 00:19:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wz3tS3PKoftl5unBacHsiN8ll1J7OsCaJhYV8OSD2pJY6cMSPPi2OPqo4Hx4l3xQ9tjhtVRNwRyAkKLxS/epsa2FtVwUIsuD2fONMxePpIneOtiFPD9BUixTbB7LfokojR+5+1zalfZ0vqi9AkNwn+DI2lcU5mIyp0XFIjWNvVL0JmqQNUZImCTQ9xUHHtuuexQYDLuK7lWXlINocJCM7gb0CWFW8kc9xFXzV/TqBHyv2fTGNewJo72Tu+WWUkmHX4N/2d+K2uM4idREfYfgIkyPdbQu66poHRW71JEyuiUGEbzRmkYXoGT5vpIj+pOyxJi7pisYVCUvr0F2kAgWIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7H7g+ZUp+Tv3j/Olxw20zaRfrGsay/h9qWpAq9iZs48=;
 b=L9JSrgCf/8p734brCLqHIeZc1trEi7kYeOMCDj6XZSAoZ+lW/c+kx8QNFM6V0omsJM6KQXVTn36gaBRxAEhGGmpVXppTTwnHplUZq/canvgZ9gGFYEOycqBfjFikZ5nZN9V9smC0KZ3OlAGk0EzchEeB/II+/xmmWcL+mdEfsnxbPL12FKZjMC3WIc8GaYv7ICz7XAFRtaQSryEM3KTOTVrKX9Tz7HEXzU3cfhU2uKGpAA330Zs0LVE317ypuWowT0iPMcRdCC5jTuJgnZvXSihMEX+61pOrBE2nEeiEirB3xD8cmPnW41j4Sq4BMe6sxzmxJnYD0p4/THYlt+UdXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB8478.namprd11.prod.outlook.com (2603:10b6:510:308::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.26; Mon, 14 Aug
 2023 07:19:07 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63%2]) with mapi id 15.20.6652.029; Mon, 14 Aug 2023
 07:19:07 +0000
Date:   Mon, 14 Aug 2023 14:52:07 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     bibo mao <maobibo@loongson.cn>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <pbonzini@redhat.com>, <mike.kravetz@oracle.com>,
        <apopple@nvidia.com>, <jgg@nvidia.com>, <rppt@kernel.org>,
        <akpm@linux-foundation.org>, <kevin.tian@intel.com>,
        <david@redhat.com>
Subject: Re: [RFC PATCH v2 5/5] KVM: Unmap pages only when it's indeed
 protected for NUMA migration
Message-ID: <ZNnPF4W26ZbAyGto@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230810085636.25914-1-yan.y.zhao@intel.com>
 <20230810090218.26244-1-yan.y.zhao@intel.com>
 <277ee023-dc94-6c23-20b2-7deba641f1b1@loongson.cn>
 <ZNWu2YCxy2FQBl4z@yzhao56-desk.sh.intel.com>
 <e7032573-9717-b1b9-7335-cbb0da12cd2a@loongson.cn>
 <ZNXq9M/WqjEkfi3x@yzhao56-desk.sh.intel.com>
 <ZNZshVZI5bRq4mZQ@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZNZshVZI5bRq4mZQ@google.com>
X-ClientProxiedBy: SI2P153CA0030.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::15) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB8478:EE_
X-MS-Office365-Filtering-Correlation-Id: 748708b9-a064-402e-d3d4-08db9c96bf1c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O9jkulqMYPyRTd1WhD1Spd5+S73W5BEgt5XiibxTZB5NFgIoYc6qiWm5k2wkpvLtTvb5D5GDdqOfAbCdgfSk7LKoKxqg/VNQ2MO/TR2X8dyiuShmjDp+q92uZHpeD/cseb5/0JkY2MnzoXdmimZypVvY8fUVliA2l8YpZrJP/EPnAw/DoJEoJbDmtOQJAeY/tYOlBAPGRSWp0xUm6J0vNj2PSBiRmsx0lZxq5Ghoa38j+Afrb935mT3sOXnG3Zb1B/neikbHsttC6zw6LpOkxJ4dk0xFFJpAWOQl4rTKtTJpO4WrQZ5A/Cs7j6CvjowNUd86K9VKSKUA61t0Wilshxkb2UCq2ZGf0Uk+5221r3nwN21nkzba4yDi7UlPtpqiPQybpgwQhv3gxHGjX/mU3govEPyTKHIBBkoD8YDXnCZlz96aHhf98gDzntmm+CbduNtJNkdS7FF3mzGCVCu9+JnrnZR4GejMzH+xWdr4L4xi+CxiPHaabYTDL3rex7yfr16RcvsOiCsZhDfp/XdmlWBx8AvTmXtyPFCWJR2mL4aS76GRV0XeB78iRoPyNTg2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(366004)(376002)(346002)(396003)(186006)(1800799006)(451199021)(66899021)(478600001)(82960400001)(8936002)(8676002)(4326008)(66946007)(66556008)(66476007)(6916009)(316002)(41300700001)(38100700002)(83380400001)(6512007)(6506007)(6486002)(53546011)(26005)(3450700001)(30864003)(2906002)(86362001)(5660300002)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UVQrNU5XSUVlM0VHM3YzK2YrdmNQVEk5RExSbTJXRm9BVC81OXBiRmdic1lL?=
 =?utf-8?B?eGpjRHlyQUYwMzUvTnNPMmRCcGRWNGY5YkE5SHZFZjV6dUxsQlk3YjkxSGxx?=
 =?utf-8?B?Z0doVS9aU0E1eUZFZzNiZDB0R2w5aDlCZDcxNFRmVW1KUVVUbm4ybWVFbWJp?=
 =?utf-8?B?RlhCa3hLOVRxK3VjNnNBdHg1bThaQmw4b1hOUG5RNkYvb1BRaXgxUXdhcjl5?=
 =?utf-8?B?VEIyTEQ3aVpzOVVWUmZjUVNGRlV4NVpuQnJyWVhaeXUrV3BnTi81TzIyeXNt?=
 =?utf-8?B?VjM1TUo2N09tTHY4UzBFa0xRUkM5M1pTYk5OMmVSMFJiT253TWJWQlhWaWd5?=
 =?utf-8?B?elBvREdEcFQ4ZzlGRGhJYlFhSDVCQ3lMbEJiajdlZksrb2hhWjB6VUdGcmlm?=
 =?utf-8?B?WG9ucFhrZ1hVd2lJUmNXVnV3ei9NdjBGSlNJT21IV0xaZkRiTGU1d0pUR3pq?=
 =?utf-8?B?V2xuUkpNc0QyVU8wVG1XMTVqTjRmTmEySjFyT0lKeEFZRlh5Wm1ocEhOaWNx?=
 =?utf-8?B?VGorcWxQdXF3R2NibVFHdGczUmNFL3NSaENJRWE3MTFTRjBaU1F5TndDV1Qz?=
 =?utf-8?B?NFBxS1pLMU5raGdqaThjMmkrelhyK25ZTlorSGRWQkpnU3JHMVNzM0R6d2ls?=
 =?utf-8?B?TjNFVGordktEaGI0QmVrdlpJSktGaGRiS1J1bStDNmdrMytDbHVhTU1iZ2Vu?=
 =?utf-8?B?RythUkZQc3M4bUpDZ1dQOEhJMGMxaTJzQVVscDhURjJYRjBLZWlEekJTNEdI?=
 =?utf-8?B?WllkUFdTZ0JucW9DbHhjU1dUSmRKck9JejdsSk9WSFlDUEwvajU5ZVdzY1Zr?=
 =?utf-8?B?Q1U5NUxoaTZoM2lIdkZjc0FUUVh1RHBRcFowbzc3eGh0Nms2Z3RCaUxJTXg3?=
 =?utf-8?B?aGk0aFpzcEd4SlJabFh6cFkxci9MdTZIUjNxbnRjWjJlY1NJYk1nT3g5dXBv?=
 =?utf-8?B?eFdWaWNIakJNbDhuQWNBZnJtY016QU1IRFJicFQwYkdHR3RPaG92VmM2TXln?=
 =?utf-8?B?WXZmWEVmQzhYMUEwLzRlWEZaRG9JMW1uc3VaTmpiNEhxdmpkZGZUZUpySm9R?=
 =?utf-8?B?ZUdyOGxSUkpZWUxqNzhkY2dsKzVIenRLbU1lbmFEQm5jdURER3dORDRVUFo5?=
 =?utf-8?B?eEpKYkE3UTJhRkpsMWlTcmpkWlIrSE1na1l4UEk4VU12RW9ObmI4Z1lKMVVy?=
 =?utf-8?B?a29TK0N1RHBNa3lkUDNmUWlXdjY4MjRWVEk2UVFtQnAvcHYwUmowUjZ6SFVk?=
 =?utf-8?B?RStPWG9WRzdlYzVjTng0OENiYUk3Tm1PbzQ3d09tYkZ3bjMrdWVMOXVqbmtL?=
 =?utf-8?B?eFQ3NVFaMU4zMHJSYTZxd0Y0aXl5VVdocnE5WGMxYWhqa0NXM0lSWUtXVXIr?=
 =?utf-8?B?MEZGWHBCeUV1THJ5YklBUTR6Q29IWE9zd0VKb0RQRnAxclhiUUhtQk5JUVI1?=
 =?utf-8?B?MWRSZkdjRVJhSTRuYXFLcGcvNXBiNDR5eCtnU09jbGNCZnRtSnlUQThnT3ZB?=
 =?utf-8?B?TWRLWWczWWpIWkNPVTNpb2NJVndUZ0RNUmpZdFJMZ00wR3JWell6VmRhWWNK?=
 =?utf-8?B?VVRqRklwYzNaZk02SzNVb20ydXFBekYraFMxS1haa2FjczNFdnpRSitPaUNI?=
 =?utf-8?B?RmhKRzBQeWRzUkpja0UzTjFBM3VMTTZ3cGZjZkFnOUJYVDlXTHJYdGhVRGVz?=
 =?utf-8?B?N2Z5Nk9nNHlmU0tGbnl1SzJGRUk4RTRQZ2xmaXk4anNFRGg2WlZEaFExL1Jq?=
 =?utf-8?B?eGJ3NW9ZR1ZNUDcwOTdCSmtrSU5XYmwwT1kwaWJRMk16K2gvazVCTmRtL2ZX?=
 =?utf-8?B?SGV0THJpTUpyTHllTVExY0Q1TlZoMzczWHExT3U4WmF3MTc2aXdyaklwZVlV?=
 =?utf-8?B?OWN1aHNaM1FoaE4xNW1rWGtpZGxmUEphWENvUlVzTDNhZ2xtNHphTGxqNlp5?=
 =?utf-8?B?SFJhYVJXeFZUclkrY21yMk5ENmJvS2l1Y2d2dEJyS3lDbTRnb1o5ZDE2eHEy?=
 =?utf-8?B?VG5hT3c5RFRMV09vbmVVeDFoM3JudXFlMEpxYTg1UjJLUHJLLzAvOVRuaG4z?=
 =?utf-8?B?NkdEaTNrclFDZDJXQkxDVlRVd1RqVTVsemNUY2NUeWNvNGF5U0ozWWxNN2Nw?=
 =?utf-8?Q?kJyELZXG5AdoCPzZkPDo+ROJj?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 748708b9-a064-402e-d3d4-08db9c96bf1c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2023 07:19:07.1436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CH2M4iB6U1Ilq0I+gy5BBGbueRgd+xR31YCaYXIWsmK04TguVXoR0KW0UPiAVLtlIGanezMUZzwsIafogE2tmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8478
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 11, 2023 at 10:14:45AM -0700, Sean Christopherson wrote:
> On Fri, Aug 11, 2023, Yan Zhao wrote:
> > On Fri, Aug 11, 2023 at 03:40:44PM +0800, bibo mao wrote:
> > > 
> > > 在 2023/8/11 11:45, Yan Zhao 写道:
> > > >>> +static void kvm_mmu_notifier_numa_protect(struct mmu_notifier *mn,
> > > >>> +					  struct mm_struct *mm,
> > > >>> +					  unsigned long start,
> > > >>> +					  unsigned long end)
> > > >>> +{
> > > >>> +	struct kvm *kvm = mmu_notifier_to_kvm(mn);
> > > >>> +
> > > >>> +	WARN_ON_ONCE(!READ_ONCE(kvm->mn_active_invalidate_count));
> > > >>> +	if (!READ_ONCE(kvm->mmu_invalidate_in_progress))
> > > >>> +		return;
> > > >>> +
> > > >>> +	kvm_handle_hva_range(mn, start, end, __pte(0), kvm_unmap_gfn_range);
> > > >>> +}
> > > >> numa balance will scan wide memory range, and there will be one time
> > > > Though scanning memory range is wide, .invalidate_range_start() is sent
> > > > for each 2M range.
> > > yes, range is huge page size when changing numa protection during numa scanning.
> > > 
> > > > 
> > > >> ipi notification with kvm_flush_remote_tlbs. With page level notification,
> > > >> it may bring out lots of flush remote tlb ipi notification.
> > > > 
> > > > Hmm, for VMs with assigned devices, apparently, the flush remote tlb IPIs
> > > > will be reduced to 0 with this series.
> > > > 
> > > > For VMs without assigned devices or mdev devices, I was previously also
> > > > worried about that there might be more IPIs.
> > > > But with current test data, there's no more remote tlb IPIs on average.
> > > > 
> > > > The reason is below:
> > > > 
> > > > Before this series, kvm_unmap_gfn_range() is called for once for a 2M
> > > > range.
> 
> No, it's potentially called once per 1GiB range.  change_pmd_range() invokes the
> mmu_notifier with addr+end, where "end" is the end of the range covered by the
> PUD, not the the end of the current PMD.  So the worst case scenario would be a
> 256k increase.  Of course, if you have to migrate an entire 1GiB chunk of memory
> then you likely have bigger problems, but still.
Yes, thanks for pointing it out.
I realized it after re-reading the code and re-checking the log message.
This wider range also explained the collected worst data:
44 kvm_unmap_gfn_range() caused 43920 kvm_flush_remote_tlbs()requests. i.e.
998 remote tlb flush requests per kvm_unmap_gfn_range().

> 
> > > > After this series, kvm_unmap_gfn_range() is called for once if the 2M is
> > > > mapped to a huge page in primary MMU, and called for at most 512 times
> > > > if mapped to 4K pages in primary MMU.
> > > > 
> > > > 
> > > > Though kvm_unmap_gfn_range() is only called once before this series,
> > > > as the range is blockable, when there're contentions, remote tlb IPIs
> > > > can be sent page by page in 4K granularity (in tdp_mmu_iter_cond_resched())
> > > I do not know much about x86, does this happen always or only need reschedule
> > Ah, sorry, I missed platforms other than x86.
> > Maybe there will be a big difference in other platforms.
> > 
> > > from code?  so that there will be many times of tlb IPIs in only once function
> > Only when MMU lock is contended. But it's not seldom because of the contention in
> > TDP page fault.
> 
> No?  I don't see how mmu_lock contention would affect the number of calls to 
> kvm_flush_remote_tlbs().  If vCPUs are running and not generating faults, i.e.
> not trying to access the range in question, then ever zap will generate a remote
> TLB flush and thus send IPIs to all running vCPUs.
In tdp_mmu_zap_leafs() for kvm_unmap_gfn_range(), the flow is like this:

1. Check necessity of mmu_lock reschedule
1.a -- if yes,
       1.a.1 do kvm_flush_remote_tlbs() if flush is true.
       1.a.2 reschedule of mmu_lock
       1.a.3 goto 2.
1.b -- if no, goto 2
2. Zap present leaf entry, and set flush to be true
3. Get next gfn and go to to 1

With a wide range to .invalidate_range_start()/end(), it's easy to find
rwlock_needbreak(&kvm->mmu_lock) to be true (goes to 1.a and 1.a.1)
And in tdp_mmu_zap_leafs(), before rescheduling of mmu_lock, tlb flush
request is performed. (1.a.1)


Take a real case for example,
NUMA balancing requests KVM to zap GFN range from 0xb4000 to 0xb9800.
Then when KVM zaps GFN 0xb807b, it will finds mmu_lock needs break
because vCPU is faulting GFN 0xb804c.
And vCPUs fill constantly retry faulting 0xb804c for 3298 times until
.invalidate_range_end().
Then for this zap of GFN range from 0xb4000 - 0xb9800,
vCPUs retry fault of
GFN 0xb804c for 3298 times,
GFN 0xb8074 for 3161 times,
GFN 0xb81ce for 15190 times,
and the accesses of the 3 GFNs cause 3209 times of kvm_flush_remote_tlbs()
for one kvm_unmap_gfn_range() because flush requests are not batched.
(this range is mapped in both 2M and 4K in secondary MMU).

Without the contending of mmu_lock, tdp_mmu_zap_leafs() just combines
all flush requests and leaves 1 kvm_flush_remote_tlbs() to be called
after it returns.


In my test scenario, which is VM boot-up, this kind of contention is
frequent.
Here's the 10 times data for a VM boot-up collected previously.
       |      count of       |       count of          |
       | kvm_unmap_gfn_range | kvm_flush_remote_tlbs() |
-------|---------------------|-------------------------|
   1   |         38          |           14            |
   2   |         28          |         5191            |
   3   |         36          |        13398            |
   4   |         44          |        43920            |
   5   |         28          |           14            |
   6   |         36          |        10803            |
   7   |         38          |          892            |
   8   |         32          |         5905            |
   9   |         32          |           13            |
  10   |         38          |         6096            |
-------|---------------------|-------------------------|
average|         35          |         8625            |


I wonder if we could loose the frequency to check for rescheduling in
tdp_mmu_iter_cond_resched() if the zap range is wide, e.g.

if (iter->next_last_level_gfn ==
    iter->yielded_gfn + KVM_PAGES_PER_HPAGE(PG_LEVEL_2M))
	return false; 

> 
> > > call about kvm_unmap_gfn_range.
> > > 
> > > > if the pages are mapped in 4K in secondary MMU.
> > > > 
> > > > With this series, on the other hand, .numa_protect() sets range to be
> > > > unblockable. So there could be less remote tlb IPIs when a 2M range is
> > > > mapped into small PTEs in secondary MMU.
> > > > Besides, .numa_protect() is not sent for all pages in a given 2M range.
> > > No, .numa_protect() is not sent for all pages. It depends on the workload,
> > > whether the page is accessed for different cpu threads cross-nodes.
> > The .numa_protect() is called in patch 4 only when PROT_NONE is set to
> > the page.
> 
> I'm strongly opposed to adding MMU_NOTIFIER_RANGE_NUMA.  It's too much of a one-off,
> and losing the batching of invalidations makes me nervous.  As Bibo points out,
> the behavior will vary based on the workload, VM configuration, etc.
> 
> There's also a *very* subtle change, in that the notification will be sent while
> holding the PMD/PTE lock.  Taking KVM's mmu_lock under that is *probably* ok, but
> I'm not exactly 100% confident on that.  And the only reason there isn't a more
MMU lock is a rwlock, which is a variant of spinlock.
So, I think taking it within PMD/PTE lock is ok.
Actually we have already done that during the .change_pte() notification, where

kvm_mmu_notifier_change_pte() takes KVM mmu_lock for write,
while PTE lock is held while sending set_pte_at_notify() --> .change_pte() handlers


> obvious bug is because kvm_handle_hva_range() sets may_block to false, e.g. KVM
> won't yield if there's mmu_lock contention.
Yes, KVM won't yield and reschedule of KVM mmu_lock, so it's fine.

> However, *if* it's ok to invoke MMU notifiers while holding PMD/PTE locks, then
> I think we can achieve what you want without losing batching, and without changing
> secondary MMUs.
> 
> Rather than muck with the notification types and add a one-off for NUMA, just
> defer the notification until a present PMD/PTE is actually going to be modified.
> It's not the prettiest, but other than the locking, I don't think has any chance
> of regressing other workloads/configurations.
> 
> Note, I'm assuming secondary MMUs aren't allowed to map swap entries...
> 
> Compile tested only.

I don't find a matching end to each
mmu_notifier_invalidate_range_start_nonblock().

> 
> From: Sean Christopherson <seanjc@google.com>
> Date: Fri, 11 Aug 2023 10:03:36 -0700
> Subject: [PATCH] tmp
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  include/linux/huge_mm.h |  4 +++-
>  include/linux/mm.h      |  3 +++
>  mm/huge_memory.c        |  5 ++++-
>  mm/mprotect.c           | 47 +++++++++++++++++++++++++++++------------
>  4 files changed, 44 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 20284387b841..b88316adaaad 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -7,6 +7,8 @@
>  
>  #include <linux/fs.h> /* only for vma_is_dax() */
>  
> +struct mmu_notifier_range;
> +
>  vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf);
>  int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>  		  pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
> @@ -38,7 +40,7 @@ bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
>  		   unsigned long new_addr, pmd_t *old_pmd, pmd_t *new_pmd);
>  int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  		    pmd_t *pmd, unsigned long addr, pgprot_t newprot,
> -		    unsigned long cp_flags);
> +		    unsigned long cp_flags, struct mmu_notifier_range *range);
>  
>  vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, pfn_t pfn, bool write);
>  vm_fault_t vmf_insert_pfn_pud(struct vm_fault *vmf, pfn_t pfn, bool write);
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 2dd73e4f3d8e..284f61cf9c37 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2478,6 +2478,9 @@ static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma
>  	return !!(vma->vm_flags & VM_WRITE);
>  
>  }
> +
> +void change_pmd_range_notify_secondary_mmus(unsigned long addr,
> +					    struct mmu_notifier_range *range);
>  bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
>  			     pte_t pte);
>  extern long change_protection(struct mmu_gather *tlb,
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index a71cf686e3b2..47c7712b163e 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1808,7 +1808,7 @@ bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
>   */
>  int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  		    pmd_t *pmd, unsigned long addr, pgprot_t newprot,
> -		    unsigned long cp_flags)
> +		    unsigned long cp_flags, struct mmu_notifier_range *range)
>  {
>  	struct mm_struct *mm = vma->vm_mm;
>  	spinlock_t *ptl;
> @@ -1893,6 +1893,9 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  		    !toptier)
>  			xchg_page_access_time(page, jiffies_to_msecs(jiffies));
>  	}
> +
> +	change_pmd_range_notify_secondary_mmus(addr, range);
> +
>  	/*
>  	 * In case prot_numa, we are under mmap_read_lock(mm). It's critical
>  	 * to not clear pmd intermittently to avoid race with MADV_DONTNEED
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index d1a809167f49..f5844adbe0cb 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -82,7 +82,8 @@ bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
>  
>  static long change_pte_range(struct mmu_gather *tlb,
>  		struct vm_area_struct *vma, pmd_t *pmd, unsigned long addr,
> -		unsigned long end, pgprot_t newprot, unsigned long cp_flags)
> +		unsigned long end, pgprot_t newprot, unsigned long cp_flags,
> +		struct mmu_notifier_range *range)
>  {
>  	pte_t *pte, oldpte;
>  	spinlock_t *ptl;
> @@ -164,8 +165,12 @@ static long change_pte_range(struct mmu_gather *tlb,
>  				    !toptier)
>  					xchg_page_access_time(page,
>  						jiffies_to_msecs(jiffies));
> +
> +
>  			}
>  
> +			change_pmd_range_notify_secondary_mmus(addr, range);
> +
>  			oldpte = ptep_modify_prot_start(vma, addr, pte);
>  			ptent = pte_modify(oldpte, newprot);
>  
> @@ -355,6 +360,17 @@ pgtable_populate_needed(struct vm_area_struct *vma, unsigned long cp_flags)
>  		err;							\
>  	})
>  
> +void change_pmd_range_notify_secondary_mmus(unsigned long addr,
> +					    struct mmu_notifier_range *range)
> +{
> +	if (range->start)
> +		return;
> +
> +	VM_WARN_ON(addr >= range->end);
> +	range->start = addr;
> +	mmu_notifier_invalidate_range_start_nonblock(range);
This will cause range from addr to end to be invalidated, which may
include pinned ranges.

> +}
> +
>  static inline long change_pmd_range(struct mmu_gather *tlb,
>  		struct vm_area_struct *vma, pud_t *pud, unsigned long addr,
>  		unsigned long end, pgprot_t newprot, unsigned long cp_flags)
> @@ -365,7 +381,14 @@ static inline long change_pmd_range(struct mmu_gather *tlb,
>  	unsigned long nr_huge_updates = 0;
>  	struct mmu_notifier_range range;
>  
> -	range.start = 0;
> +	/*
> +	 * Defer invalidation of secondary MMUs until a PMD/PTE change is
> +	 * imminent, e.g. NUMA balancing in particular can "fail" for certain
> +	 * types of mappings.  Initialize range.start to '0' and use it to
> +	 * track whether or not the invalidation notification has been set.
> +	 */
> +	mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_VMA, 0,
> +				vma->vm_mm, 0, end);
>  
>  	pmd = pmd_offset(pud, addr);
>  	do {
> @@ -383,18 +406,16 @@ static inline long change_pmd_range(struct mmu_gather *tlb,
>  		if (pmd_none(*pmd))
>  			goto next;
>  
> -		/* invoke the mmu notifier if the pmd is populated */
> -		if (!range.start) {
> -			mmu_notifier_range_init(&range,
> -				MMU_NOTIFY_PROTECTION_VMA, 0,
> -				vma->vm_mm, addr, end);
> -			mmu_notifier_invalidate_range_start(&range);
> -		}
> -
>  		_pmd = pmdp_get_lockless(pmd);
>  		if (is_swap_pmd(_pmd) || pmd_trans_huge(_pmd) || pmd_devmap(_pmd)) {
>  			if ((next - addr != HPAGE_PMD_SIZE) ||
>  			    pgtable_split_needed(vma, cp_flags)) {
> +				/*
> +				 * FIXME: __split_huge_pmd() performs its own
> +				 * mmu_notifier invalidation prior to clearing
> +				 * the PMD, ideally all invalidations for the
> +				 * range would be batched.
> +				 */
>  				__split_huge_pmd(vma, pmd, addr, false, NULL);
>  				/*
>  				 * For file-backed, the pmd could have been
> @@ -407,8 +428,8 @@ static inline long change_pmd_range(struct mmu_gather *tlb,
>  					break;
>  				}
>  			} else {
> -				ret = change_huge_pmd(tlb, vma, pmd,
> -						addr, newprot, cp_flags);
> +				ret = change_huge_pmd(tlb, vma, pmd, addr,
> +						      newprot, cp_flags, &range);
>  				if (ret) {
>  					if (ret == HPAGE_PMD_NR) {
>  						pages += HPAGE_PMD_NR;
> @@ -423,7 +444,7 @@ static inline long change_pmd_range(struct mmu_gather *tlb,
>  		}
>  
>  		ret = change_pte_range(tlb, vma, pmd, addr, next, newprot,
> -				       cp_flags);
> +				       cp_flags, &range);
>  		if (ret < 0)
>  			goto again;
>  		pages += ret;
> 
> base-commit: 1f40f634009556c119974cafce4c7b2f9b8c58ad
> -- 
> 
> 
> 
