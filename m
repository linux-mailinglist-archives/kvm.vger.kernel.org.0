Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15C617788EF
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 10:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234414AbjHKI3A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 04:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbjHKI27 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 04:28:59 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA969272D;
        Fri, 11 Aug 2023 01:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691742538; x=1723278538;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=sLrAfj0VQTdyRClDOUZGrsjJp3+uGcWeRlrV/GnKtXg=;
  b=hMhjyVw0PKYXYH6+K/nB/V5mWn/2v3G0TrzymQEsXHcB0d5rpivVF5UP
   dgMCKg/NdPa+N80sot1KdjXo8pWnJIeOSIjfNpixKl74m/oILrmrC3n8L
   8v8+3qIiZIGicnWzhuUrpWea9giRwgA+jK0iTfgwOTAWyPhfZO9S8gUeh
   oDlXFUlD7s39OWMAiMbwQAb9JtAtS2YY48/i4QgqbflytGDF1bUJ36Ot2
   nqCiV/ZzcOAzCn9nlVF78QLaDhNXO7mtI/9Y3WR1A0gMebYE4940ds4ff
   cAI8o2pn1sTBQ55aeBskkenwiGkBXbmWDLYGP1ghDGj+700kPMI4CmyYd
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="369098608"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="369098608"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2023 01:28:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="735712984"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="735712984"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 11 Aug 2023 01:28:57 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 11 Aug 2023 01:28:57 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 11 Aug 2023 01:28:56 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 11 Aug 2023 01:28:56 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 11 Aug 2023 01:28:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M/2fPZRJsH6t+IrfrfM9LrnJI/E99nWcYGR8FG2fiMUBpcR2HBhxGQGjx72w5C9tUuISzN0F8AJR6QdZzcePeeb/7Oen+/nwALeF/h66lFrAjHS9OHghKBBJd5jIx3ouaFhPRZQIFXbdKj5bvYWMTuAXuBjZS3K0sYfRcmgZ4KDFU8Z+TG7sGxZz6eviV9cTYdaZgTg0hbMtYUhbpAxK3ksd6+E9Rrq9D4KX7sqJ43S2Vh6iFLfaMAgxDul0Cyh//NoONw/St9/kpFWD2HzMFiPg7vaFFtfqig5SjwOOaa77y8nEFv01GdXckBElBdpj1WnoF/X4cG8exQLD2eD8jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=obmlA6rl4vEVfv3FR4XYfynmzNkhStP3p6+1A4qfbLQ=;
 b=cNICHqJna77gFFYapRc+DfYJ7oDOYa2nGME60/c9Yx0PtX2d+NzvS6NnugBlpbnr0dy1GvjKelsdluGsKmKX0I4GuR0qbZCtPOifelSfio0rGN69Kow34kpg+VVseIE5y0gjAxycHWAfqaVhvzHAObUQo9lexi6Hl43unf8mIAu4NXy1CHKIyVYMre/7C0EmufNeOieQwYMa1BlsQsDRWsa+5xN2fnQn8yagw7WRSopgfNfjzhE0nYOllDzBcqIQ3ycI14QG24Jq3xGCcm/swzWhOOOIDq7VJzZkoTzPrRKE4ahGA6hZKv10FM73Wl+9l0zoHSsi3Es2EZG0DNyeHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 BL1PR11MB5528.namprd11.prod.outlook.com (2603:10b6:208:314::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.19; Fri, 11 Aug
 2023 08:28:54 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63%2]) with mapi id 15.20.6652.029; Fri, 11 Aug 2023
 08:28:54 +0000
Date:   Fri, 11 Aug 2023 16:01:56 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     bibo mao <maobibo@loongson.cn>
CC:     <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
        <mike.kravetz@oracle.com>, <apopple@nvidia.com>, <jgg@nvidia.com>,
        <rppt@kernel.org>, <akpm@linux-foundation.org>,
        <kevin.tian@intel.com>, <david@redhat.com>
Subject: Re: [RFC PATCH v2 5/5] KVM: Unmap pages only when it's indeed
 protected for NUMA migration
Message-ID: <ZNXq9M/WqjEkfi3x@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230810085636.25914-1-yan.y.zhao@intel.com>
 <20230810090218.26244-1-yan.y.zhao@intel.com>
 <277ee023-dc94-6c23-20b2-7deba641f1b1@loongson.cn>
 <ZNWu2YCxy2FQBl4z@yzhao56-desk.sh.intel.com>
 <e7032573-9717-b1b9-7335-cbb0da12cd2a@loongson.cn>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e7032573-9717-b1b9-7335-cbb0da12cd2a@loongson.cn>
X-ClientProxiedBy: SI2PR06CA0010.apcprd06.prod.outlook.com
 (2603:1096:4:186::6) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|BL1PR11MB5528:EE_
X-MS-Office365-Filtering-Correlation-Id: ce485903-fda0-41f8-352f-08db9a44ff7b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3uBXtcZ1uE1Z//ljR9CBc2M44azGunJQqN/0kHPFOIzFj6o+l2r5bsLCQlEsewFk0/ZqN8snj12KD2/wVYx6fxRg0vwuagne7R2+XCI4QagwTPNo127AIAmxGThDsSLnfi+M1KOIypG68ZfeawG0rVCwVCFJ7MMnazPT49JyfNUXbpFkZcXdJT1rx4RlGOVDde6LFUmFHiM3aPQr+yF1Ez0Yy/BmX0BE17Z2qBQcsnP+1qCmHzi84TZ+yHeZzPS7mpUOmTZltDKl1puLaDxV20/3RNxdXZcZ+XkAFnEHeUoD0stZkGd+fYkEWNeY7cb6+SPkdjjMqAbXCYyh90IbHxfmC31MqXmWvZ9jv3Vxmd8mZkdGFk+kI71KITHJQUdJfqg9c7Bu3wgoqXKyKW2P1mOi/myK/RG9JSwV/kSDM9YBbawVyA+Wd0/QdoPfl8vlR2/+aZk5YATTUknRraRvYnQzZHbn5YgkHYDUgldyZkYRkHAKUKye4qVXKsi3JlIdhpzM0YJxaIF2yyEKZkdDuY/XOkcNRMKRFlycEpxcHTpdTj3TLdGQtqTZsEperK+t
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(366004)(136003)(396003)(39860400002)(451199021)(186006)(1800799006)(4326008)(66946007)(66556008)(66476007)(6916009)(41300700001)(86362001)(316002)(26005)(6506007)(6512007)(82960400001)(6486002)(83380400001)(54906003)(478600001)(38100700002)(3450700001)(2906002)(5660300002)(8676002)(8936002)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NVVSUGVWaU5oYXhTRCtncWp2dWVpQndnV3FYVWl0NDgwbVdaL2ZsUGtoZHdn?=
 =?utf-8?B?bXZRd2ZrR3FQc3NPK3hSTGlkQkFYb1ZrYWlySDVXU2Z6SGdWOU0yalkwR0F1?=
 =?utf-8?B?eS9TZGRUY0NUQlhFZnhvR3BDb0RaMTFiNzNCek56RXpHZ29lckNEaW1zYWtC?=
 =?utf-8?B?WmFnZm91UmxXQzdsM1lyZWc0ZVhtbGdEd1kvUEliZGlKRXVKNUtVMUpEYm5u?=
 =?utf-8?B?V3J0bmoxdG96eEM1VU0wZmk2ZEs1RUIvUEprdUUvcEZtdjUrVkpkNEtnczBK?=
 =?utf-8?B?TGRWb0dKQzUyNkhWRkI4SjVzWW1lblNvZWpJUHo3dkt3em1rWjZKNEJSeHhT?=
 =?utf-8?B?aTJ1eEc3U2ZncXE5aEVWMTNnaXF6VzQ4M2thN2dLTzViZXhQRjJTMWNFNHlE?=
 =?utf-8?B?QmZMLzZCK3FReVlDOE9sMVVycXo2Znc0LzNFN2NlZVNSNnZQc1IxNVpqY1lY?=
 =?utf-8?B?cHdPRWQvTXFlaUxxc0pzYzA3dmlWS0E0RERjbCtNOXVPVnI1VDBmQmZwMEpQ?=
 =?utf-8?B?YjV6S3NJUFlmZytCREpGK2ZjWi9mdzVLa1dkS0QvN2tZSkdKelhKaXNKVXRL?=
 =?utf-8?B?eHJOUmk1ZDFJa1MrN0lLYWJrUnhNbUFkdVkxcHZtVmRiWkZ6b1JkeHNEOEZq?=
 =?utf-8?B?RktscWl3Q0VVYzVYV0hpZnUrNFkvQ1ZBeEkvSlRSTlJNK3I0WUxudlJwdi9u?=
 =?utf-8?B?SzU2TS9wZE1taUd6WE1hemJjTGdaRWdxQ3RSUVJ1YVRYbmllT0RTUE9BVFZ5?=
 =?utf-8?B?OE5RdkM1dk01RHFYbnFQUklMbUdWMW1aYmhSNFNqQVZnWkVOblZqUkdNYWIz?=
 =?utf-8?B?UmRSQ0lCcUc4cUxNVytHWjFVaTE4eGU1cFhhWEdRSzRiQVZRNGtHZzkwSVBx?=
 =?utf-8?B?Ly9pMSszSkRDek1wSUF4d3pYMGRQMzExbGsxd0ZiRGRPR1JydHVEdDR6K0g4?=
 =?utf-8?B?YzM2RzBzK0Y4WEgyUVRvYVI4aFNzdEVIcU5xMWlQWmlXdFNycHdJNUNjK2o1?=
 =?utf-8?B?NmpJT0twNVFERVVGd1czcCtXeGJEZGd1TjJnQ0pPRTNaYzF0bDh0OXRVNFd1?=
 =?utf-8?B?VHBidnFCaFlraDcwcWRHV1p5N1Z5eGdFS3hqNlZwbW1Qa0h5TFlqS2RpaGN1?=
 =?utf-8?B?b20zaEF4clp3UjJJWjNJM0taNm5TQ1lodlZab2Y1WlZkaHcvRlZtSGZ2RjFn?=
 =?utf-8?B?Tm5mRHhvT1pSdG1IVGxuMVBsaFNqWnlCSEludG9wVUplbEtHWTRveFRqZk1p?=
 =?utf-8?B?aWQvUCs0OEQwbDRNVXE4TXd6a2pMZFVHNWxJMFozN2FNamFieHA4SUp4T3Fn?=
 =?utf-8?B?d3VsdWx3eWlPQi9NV1VCYjcranpZZjV1L3hQdk5SMjVib1Fic1BmTllOTE8v?=
 =?utf-8?B?YTlpOW1Sa09yNjY1K0QzditSckttUG0xR1pFTnBaZVRLSmVlVEtMVHNWSXBH?=
 =?utf-8?B?SnpoSGxVUTdpYW5uN3cwaVVmSW01YU1oNk5ZNENNWGRoQmtSaGEwSDZYL3Az?=
 =?utf-8?B?c21zcW5mVE93eGU2MlV0LzNIUUdYTzd4RitEVDlFTG1jYTlYd1JOMTJCQzRC?=
 =?utf-8?B?MTEvOGs3Mmh4ZjB6amR0bllmbHZtdnIxTnRUajMwenR4ZmRJamhBNzA1SVpX?=
 =?utf-8?B?bkJuMUk5VWFuTlk5ZmRTRGxKMHRvUkNKM0JLZ0NDaVFtcmFGTUNTeUVWazV4?=
 =?utf-8?B?cTdSNURIVjNSK1VDTlRUR2NxYTlHQmF1NGhVb3M0NEcrakVCVi85clFGd3VX?=
 =?utf-8?B?VzJDV3BDd25ueHUzdENSR29jaVJud2Y1VW85UCtSQmZaMmlvZkx3RmxSeGpG?=
 =?utf-8?B?YWx6N05ENnY2QUE3VnkzTDBPTW04a2NvNGdndUF2QVVUOHVoY01oN0NCVENz?=
 =?utf-8?B?YzRtRGRsSmNGL0VCYUVsT1RKRjRLanJyVzVkM1hubGJtdzBoUTgrSXE1VGlr?=
 =?utf-8?B?bTFTWkMxQTBES2hjNG9nNVI1QVNPbmJjL0dYbUxIeHI2dWw3VWdBZDZCNXND?=
 =?utf-8?B?OXo2dmhDTG56c3JZZktXc1d4SEZrYWorYm1oYU9Zbkh1aGVnWjRKODd4dHps?=
 =?utf-8?B?VHJ0YUlEZzJTODRKNHRXTDVZc0tPR3piOEZ2WkFTMGVrVzBjZ2taQjUyVmFN?=
 =?utf-8?Q?0bl77cjwnF8yINjXlQ3c3xu8O?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ce485903-fda0-41f8-352f-08db9a44ff7b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2023 08:28:53.8991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hyaqgsczzk19xMRGAT8k6Ic7d7JyBEoQflUqK53dq5bJP42mE1XUwReekai9z9Dd/RjgISzzxqH8adceG3R7Tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5528
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 11, 2023 at 03:40:44PM +0800, bibo mao wrote:
> 
> 
> 在 2023/8/11 11:45, Yan Zhao 写道:
> >>> +static void kvm_mmu_notifier_numa_protect(struct mmu_notifier *mn,
> >>> +					  struct mm_struct *mm,
> >>> +					  unsigned long start,
> >>> +					  unsigned long end)
> >>> +{
> >>> +	struct kvm *kvm = mmu_notifier_to_kvm(mn);
> >>> +
> >>> +	WARN_ON_ONCE(!READ_ONCE(kvm->mn_active_invalidate_count));
> >>> +	if (!READ_ONCE(kvm->mmu_invalidate_in_progress))
> >>> +		return;
> >>> +
> >>> +	kvm_handle_hva_range(mn, start, end, __pte(0), kvm_unmap_gfn_range);
> >>> +}
> >> numa balance will scan wide memory range, and there will be one time
> > Though scanning memory range is wide, .invalidate_range_start() is sent
> > for each 2M range.
> yes, range is huge page size when changing numa protection during numa scanning.
> 
> > 
> >> ipi notification with kvm_flush_remote_tlbs. With page level notification,
> >> it may bring out lots of flush remote tlb ipi notification.
> > 
> > Hmm, for VMs with assigned devices, apparently, the flush remote tlb IPIs
> > will be reduced to 0 with this series.
> > 
> > For VMs without assigned devices or mdev devices, I was previously also
> > worried about that there might be more IPIs.
> > But with current test data, there's no more remote tlb IPIs on average.
> > 
> > The reason is below:
> > 
> > Before this series, kvm_unmap_gfn_range() is called for once for a 2M
> > range.
> > After this series, kvm_unmap_gfn_range() is called for once if the 2M is
> > mapped to a huge page in primary MMU, and called for at most 512 times
> > if mapped to 4K pages in primary MMU.
> > 
> > 
> > Though kvm_unmap_gfn_range() is only called once before this series,
> > as the range is blockable, when there're contentions, remote tlb IPIs
> > can be sent page by page in 4K granularity (in tdp_mmu_iter_cond_resched())
> I do not know much about x86, does this happen always or only need reschedule
Ah, sorry, I missed platforms other than x86.
Maybe there will be a big difference in other platforms.

> from code?  so that there will be many times of tlb IPIs in only once function
Only when MMU lock is contended. But it's not seldom because of the contention in
TDP page fault.

> call about kvm_unmap_gfn_range.
> 
> > if the pages are mapped in 4K in secondary MMU.
> > 
> > With this series, on the other hand, .numa_protect() sets range to be
> > unblockable. So there could be less remote tlb IPIs when a 2M range is
> > mapped into small PTEs in secondary MMU.
> > Besides, .numa_protect() is not sent for all pages in a given 2M range.
> No, .numa_protect() is not sent for all pages. It depends on the workload,
> whether the page is accessed for different cpu threads cross-nodes.
The .numa_protect() is called in patch 4 only when PROT_NONE is set to
the page.

> 
> > 
> > Below is my testing data on a VM without assigned devices:
> > The data is an average of 10 times guest boot-up.
> >                    
> >     data           | numa balancing caused  | numa balancing caused    
> >   on average       | #kvm_unmap_gfn_range() | #kvm_flush_remote_tlbs() 
> > -------------------|------------------------|--------------------------
> > before this series |         35             |     8625                 
> > after  this series |      10037             |     4610   
> just be cautious, before the series there are  8625/35 = 246 IPI tlb flush ops
> during one time kvm_unmap_gfn_range, is that x86 specific or generic? 
Only on x86. Didn't test on other platforms.

> 
> By the way are primary mmu and secondary mmu both 4K small page size "on average"?
No. 4K and 2M combined in both.


