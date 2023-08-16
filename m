Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0E4277D9E5
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 07:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241936AbjHPFlx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 01:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241983AbjHPFlh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 01:41:37 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D78542726;
        Tue, 15 Aug 2023 22:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692164489; x=1723700489;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=iAd1Lj/9A5FKiL2ZQd5eFHUWfaPQraeJaHf3/5mxF4c=;
  b=KDZ0YjD4W4FhRZ/NY6cQyHZ7PTuPrELSSCOu/GCNu3VoFVz5z05AvKlk
   DgahpQ/0StFh1aUEEDKyge/OzVXnibp+3GhSwWHCgNI1z/FbHCnuSZBcA
   QW7SWYuBb33pMk9xKVQkRE72YFtuQoH1hjR2ivjGB9/V77vGLvkuwknEc
   nRmnBvEn4mwgpX4DqLIfPY6ZnPyEyciPPvx/ApohrlwoWiojThN2d5tDc
   ce7nsxpja2JNTqrl2+dz9oRw+o85Z9SYbZEqBHnygPUnZyfCWq+Noy8ci
   cOvu81E8o4gU4T9WLuBgdmcTYfcbdEwaLAbrlHaJai9QhzKHEBZ2sI/xr
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="438791149"
X-IronPort-AV: E=Sophos;i="6.01,176,1684825200"; 
   d="scan'208";a="438791149"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2023 22:41:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="848349662"
X-IronPort-AV: E=Sophos;i="6.01,176,1684825200"; 
   d="scan'208";a="848349662"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 15 Aug 2023 22:41:26 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 15 Aug 2023 22:41:25 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 15 Aug 2023 22:41:25 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 15 Aug 2023 22:41:25 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 15 Aug 2023 22:41:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UqfOjydtXdpcIbP2Dsby4s5+VJrUlQHscy/kRune3w/Z7esaRezFromzAbidQRoZsP+G5MRwqXVkKKxM9Gih8Uso+A+SMnZEFzUOXvo25pMYszOAuthy7+pAiJZNL13J83c+wGgbNYAgkrfbMziIuMVhzBBF3nEigA++N/yYdpZYvMBERKahinHrang9YbFKL9pEOlGT1R+NFMHthlgks8VawW6E1fRY1/CDRfPChSObVFJOxJevspRHsCanr6W1JzO2HQcxDOWMX+RTx+Xz6Rzdgml9xbVHoSBnIfzDUELKC34NBcWdZz/4tqTHPlp0RbiPKG/0HrNqYbUtghrHbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=arHs/7LnORDXuRiaBFWp/1oH8EwCGJC+pnvE8VYvTYk=;
 b=RbLT5GawYum0KyEDfwDcVR3N/u78t2i6dYjVNjLdNBmuhDprR/zgDx7T+UHg5l3DhX1DLARfhsGFiEy5atH4MnklzcmQoBupzGpyFGWq3zHDML0hyBvlz9/nfb6fMQa9nlia8EOL8lx8zUWBeFZ+qQu0mvR19oX9xalP9jR93O1DhYbrZ5sXgpt3+gGFjT2slHnflMYOzRUXmwDgZKREvHSNtCOHzvC+X1ZBK8MdKg9RrNn9Ap2enehIoVt+qNhfdqvMG3kfwdFxUKLxKMO+gjaXB3XvxX859zzUu5FfLWgoaguiddhPfb9VSagfqW5NWBqxvIMutqmRK1qsTaDZfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6678.22; Wed, 16 Aug 2023 05:41:23 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63%2]) with mapi id 15.20.6678.029; Wed, 16 Aug 2023
 05:41:23 +0000
Date:   Wed, 16 Aug 2023 13:14:20 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     bibo mao <maobibo@loongson.cn>
CC:     Sean Christopherson <seanjc@google.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <pbonzini@redhat.com>, <mike.kravetz@oracle.com>,
        <apopple@nvidia.com>, <jgg@nvidia.com>, <rppt@kernel.org>,
        <akpm@linux-foundation.org>, <kevin.tian@intel.com>,
        <david@redhat.com>
Subject: Re: [RFC PATCH v2 5/5] KVM: Unmap pages only when it's indeed
 protected for NUMA migration
Message-ID: <ZNxbLPG8qbs1FjhM@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <ZNWu2YCxy2FQBl4z@yzhao56-desk.sh.intel.com>
 <e7032573-9717-b1b9-7335-cbb0da12cd2a@loongson.cn>
 <ZNXq9M/WqjEkfi3x@yzhao56-desk.sh.intel.com>
 <ZNZshVZI5bRq4mZQ@google.com>
 <ZNnPF4W26ZbAyGto@yzhao56-desk.sh.intel.com>
 <ZNpZDH9//vk8Rqvo@google.com>
 <ZNra3eDNTaKVc7MT@yzhao56-desk.sh.intel.com>
 <ZNuQ0grC44Dbh5hS@google.com>
 <107cdaaf-237f-16b9-ebe2-7eefd2b21f8f@loongson.cn>
 <c8ccc8f1-300a-09be-db6b-df2a1dedd4cf@loongson.cn>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c8ccc8f1-300a-09be-db6b-df2a1dedd4cf@loongson.cn>
X-ClientProxiedBy: KL1PR01CA0095.apcprd01.prod.exchangelabs.com
 (2603:1096:820:2::35) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH8PR11MB8107:EE_
X-MS-Office365-Filtering-Correlation-Id: 62a2fc6f-034d-44b9-61cf-08db9e1b6ce3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6SdqYN/I8ZFBplJ9qDrDKbTeWMz6McFG8CB09yqX9vRlIGm6o6LCvOcGOeGGenltwgXXKrmvqKiPqUswMzOe0gRPYDq035VGLz70kPnXilK1fc5SbMavhhbHWf49Owu+HrfhCRZ/Rl4yk3qxKLTpGo1voPnbGTjiH8ZJlJrJFRIk+mpoxGq3vm6sJdk4E64P49go5tkFSaZXbxOPatkT5SbkIUBqW8yMcVmiOPVFqt8bY3jD0qJrl1CeX7+RZJDC1xmTGQAW7j/ftqIFeRNGpajHQs5iHbxY+KS9vbtBzkWJXYrPPSr0elO6eV1Hk7NvPFR1RkJ37CUQ0u59/LX5hXweH7+/BlhORhiC7Karg/0sxe4Okvvq4IIJF5FtEU7WeUSp6FGYx4IjGBwKWRJfnyCgBitcEuxWlqgikZjt3AaCZQJCnFdM6S5NXVj4Zvq5CyBfE4f1zJDbblZWLvWJoapTp8ldfihrewT5a7TzcBANEQZDN+QndIetAOOCcm0b+7amkRlSAEx/ZfP1a6Fcv9R4EwruQRsotJe1dek7h7Acf0B5MZ0l4D9PU09DIQs9Zz3kcEQsb7khzO8t0sHXwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(39860400002)(396003)(346002)(136003)(1800799009)(451199024)(186009)(54906003)(66476007)(66556008)(66946007)(6512007)(6486002)(6506007)(2906002)(478600001)(966005)(26005)(6916009)(7416002)(5660300002)(83380400001)(41300700001)(3450700001)(316002)(8936002)(4326008)(8676002)(38100700002)(82960400001)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bFZmNFRWTWFWU1JaRFdTQ2lQY3BDSTcxOWx3am1mMzJMTzFxTkp3LzYxN0Fu?=
 =?utf-8?B?K3NtaTE2b2tQTVA0T0w2MkdGai8yT1RmWXoyTGRsYzhwSG9oZmZTdm0vbTZy?=
 =?utf-8?B?K2h0R0tUQ243bnQxaTFQMW5XdG1MU1ZKTHN2WTNkT1FhWmMvVU5RS2Yyc0Vh?=
 =?utf-8?B?ZEVzRjFOWnUvdGZsS1FiRU10WHZxQmR1RlBkNGl0KzZtWFl1M21KSGd2dWpQ?=
 =?utf-8?B?TUdzaVBybUZHVjEybHlxNEpjaWFZL3V0VWJZLzJNUE9wSXdVQ3VhTWlFME5V?=
 =?utf-8?B?MVFISkJWdm5WdXptWTI3Tnp4WDZLWmc1OEQ5OEZFWlhNQ3pHZDJTMCtYQ3NF?=
 =?utf-8?B?WHVNRDJDL2liemZUYjRxbTJjUW90Q2lDcmV6Kzcrbk1MTXE5MVM4WHdZK0hl?=
 =?utf-8?B?aXdFMUNjdExqRG9uc2pOZmd5d0g2Q2dyRWVuSHpPQkhZQThEMEVYeVM2TjZ3?=
 =?utf-8?B?UVVMT296Tm54OFE5cmhiejcrdUd6dEdwY0NnRXRXK1VMSHB2U0QzWGxLVWY1?=
 =?utf-8?B?S2tMOUNaZmIzZTdzd3dlbnN0WFNTZUptWi9Cdk56Q0xtTStvR2xVZU0wQ1oz?=
 =?utf-8?B?eTZXQmJDUlpXR29FMFZicEdVSTZDUWNSN1NzMnByNlVpbGlTMXZyVDhPNWRq?=
 =?utf-8?B?bGxPRnRlL2lCRmkremJIOGtpTUkxMnR3dVlPNDU3OTV2OFc4eEFEdzdRUVc4?=
 =?utf-8?B?eWRlT2EweHc3WVNkdEZMSDNzMUR0OUllcTBzOHNEbHlpcks5K0ZrQWdEUjRa?=
 =?utf-8?B?WXBRN0p2ek01dFkyOXN4YTZ5VWVQeTFBY2phdzF1blJYNEJkWXRUMWtZemM1?=
 =?utf-8?B?Tmp4NVJqczl5b1dzMElvVk92eWY2VVNQeXl5VEZ1aTBXbldCcUtXN0VpeWt6?=
 =?utf-8?B?QmpqUWlDenhFRVVsQlNCUTh5U1pzOURCOEVvRVA4OEJlam1aNUgxWFRhYjBN?=
 =?utf-8?B?VFdlMTVocHgyYURlWnBZQlRoaFFqYkp5eitDMG1hMFZLMGVlZGtTb2Q4WFNM?=
 =?utf-8?B?N3orK3pzaXV2Y05XVDZEV21WVUlLYkRzeUg0QkZtQ1BxT1FVM2RFK3JraEZV?=
 =?utf-8?B?anBIQmhBZnYvTExIMmJXdnRTN2VXNTVCMDdFWkwwTExkc0JtYkdWZ090QnhG?=
 =?utf-8?B?cTBnR0FnQlBkTDYyMlAwVGIwNEY1OTJqM0Y3aExpVGFWbTJ1ZytMM2t5VTc1?=
 =?utf-8?B?eTczZWhKY2hvcmhRZi9JdzE5MXFLRFk4cFRnYzBsQVBDNFMrR1lYVWl3QnVQ?=
 =?utf-8?B?ZXRyWHJuUDE2MURydCtFRUJVU3gwTEhDMHdXUGFzbFdHUVFZUUZ4OWNPSzZ6?=
 =?utf-8?B?RVJoTkJvQnNhNjRwR0NadWtENjl2Q1pIR2xWWVk5RGE4QzZSaU9vR2xzTU1T?=
 =?utf-8?B?aEdodFM2NnNwaWxwMjNyTnhPSzQxblNZZlNXZ2hGTm15OElRZklRNG0yOFJW?=
 =?utf-8?B?NEg1enM0TmpXeVExRU9RL2pYQlNLbWttQWJPekZKMmVibnVickdyYitKUEJl?=
 =?utf-8?B?bDBkSjZjc3U0ZHZDc1puQjdyckdZQjAwL2JxQTJJRkp4QWdCTkJ1d2p0QzNN?=
 =?utf-8?B?YW9IT2RCZlBidUNMYU1yazlpek9vWUdGTkVxSXNjK2tESkkxWUs2cTdRRjZs?=
 =?utf-8?B?Q2ZabUJianB3anF2elVMaXhJdU14VnZWSnNKaEdIS0Iwanl5NExlYnhEdW1Y?=
 =?utf-8?B?SjVKcXZxT3dYNXl2RGxRTndRRHZOdXFIQyswWk1qcnJPTEMxb1p2eDY0V0ZI?=
 =?utf-8?B?eTVyZ2hjempOQlNBQ2tCek12QnFUWUE2VmVDVlFuSjJpMU9qT2k5dkxUTXYz?=
 =?utf-8?B?d25GQndYMFlzTnZkQ3FWUWlNcStidldRL0VWd2hFUjdNZDRKREpwQytpSm1B?=
 =?utf-8?B?cjh4MU1XdUdwRER3aG8xdFhQVHNoVTdkTElPWFVhQWpZZWFTQ2Q1Ym1paGFJ?=
 =?utf-8?B?REpzeUgzMWVpMlNJdEtrUDQyZ0duNC83ejYrZGRHZ00rb3FLUGdqZ2drbWxj?=
 =?utf-8?B?NGlzZ1d5Mm85YnNrOHRxVW5NV3RPcmtRcVVPSEZNU0tnaUxTNGNMd1ZyaVZD?=
 =?utf-8?B?OEpZdkJVYUJEWTIvenRrN2xvNm1oVnp5bnJ1Qm92YW9ybURydVprbnJRTmlX?=
 =?utf-8?Q?yVLkTQTQqa3u73RCEp8tQksXK?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 62a2fc6f-034d-44b9-61cf-08db9e1b6ce3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2023 05:41:23.3341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vPOFnyGgN9UWAxwVxK5sCPxrGWyr1HDDdMPtPH52J1RVzusLEuHvZO214yfiJaqWbwNM9R01ls4uRVXBfdCL/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8107
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

On Wed, Aug 16, 2023 at 11:44:29AM +0800, bibo mao wrote:
> 
> 
> 在 2023/8/16 10:43, bibo mao 写道:
> > 
> > 
> > 在 2023/8/15 22:50, Sean Christopherson 写道:
> >> On Tue, Aug 15, 2023, Yan Zhao wrote:
> >>> On Mon, Aug 14, 2023 at 09:40:44AM -0700, Sean Christopherson wrote:
> >>>>>> Note, I'm assuming secondary MMUs aren't allowed to map swap entries...
> >>>>>>
> >>>>>> Compile tested only.
> >>>>>
> >>>>> I don't find a matching end to each
> >>>>> mmu_notifier_invalidate_range_start_nonblock().
> >>>>
> >>>> It pairs with existing call to mmu_notifier_invalidate_range_end() in change_pmd_range():
> >>>>
> >>>> 	if (range.start)
> >>>> 		mmu_notifier_invalidate_range_end(&range);
> >>> No, It doesn't work for mmu_notifier_invalidate_range_start() sent in change_pte_range(),
> >>> if we only want the range to include pages successfully set to PROT_NONE.
> >>
> >> Precise invalidation was a non-goal for my hack-a-patch.  The intent was purely
> >> to defer invalidation until it was actually needed, but still perform only a
> >> single notification so as to batch the TLB flushes, e.g. the start() call still
> >> used the original @end.
> >>
> >> The idea was to play nice with the scenario where nothing in a VMA could be migrated.
> >> It was complete untested though, so it may not have actually done anything to reduce
> >> the number of pointless invalidations.
> > For numa-balance scenery, can original page still be used by application even if pte
> > is changed with PROT_NONE?  If it can be used, maybe we can zap shadow mmu and flush tlb
For GUPs that does not honor FOLL_HONOR_NUMA_FAULT, yes,

See https://lore.kernel.org/all/20230803143208.383663-1-david@redhat.com/

> Since there is kvm_mmu_notifier_change_pte notification when numa page is replaced with
> new page, my meaning that can original page still be used by application even if pte
> is changed with PROT_NONE and before replaced with new page?
It's not .change_pte() notification, which is sent when COW.
The do_numa_page()/do_huge_pmd_numa_page() will try to unmap old page
protected with PROT_NONE, and if every check passes, a separate
.invalidate_range_start()/end() with event type MMU_NOTIFY_CLEAR will be
sent.

So, I think KVM (though it honors FOLL_HONOR_NUMA_FAULT), can safely
keep mapping maybe-dma pages until MMU_NOTIFY_CLEAR is sent.
(this approach is implemented in RFC v1
https://lore.kernel.org/all/20230810085636.25914-1-yan.y.zhao@intel.com/)

> 
> And for primary mmu, tlb is flushed after pte is changed with PROT_NONE and 
> after mmu_notifier_invalidate_range_end notification for secondary mmu.
> Regards
> Bibo Mao

> >> in notification mmu_notifier_invalidate_range_end with precised range, the range can
But I don't think flush tlb only in the .invalidate_range_end() in
secondary MMU is a good idea.
Flush must be done before kvm->mmu_lock is unlocked, otherwise,
confusion will be caused when multiple threads trying to update the
secondary MMU.

> >> be cross-range between range mmu_gather and mmu_notifier_range.



