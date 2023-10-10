Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A389E7BF1DE
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 06:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377089AbjJJEOi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 00:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376523AbjJJEOg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 00:14:36 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57EFC9D;
        Mon,  9 Oct 2023 21:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696911275; x=1728447275;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=NixF7mghyMnZvy2CotfyUwLk3SOORl9Ul3wg6OH9Zlg=;
  b=n0hUWJDC4eNw8FvjPuuv6hWQ+58UlJgeidlPWEcdqFK4U7Y+iZgmadrB
   QSNHnKru8ToeOwEUFh3fdBh1hGEVMWkeO4rKR6rTbTzQpDsoJceMIpn9M
   24/SBQdTIQcKPGu7EDhh4uRmD88n09RKTEUbtTNs1vnjJJ+1+65zaSOrW
   XNjpagjH8PPyyEobAMWYx8oSkbbGpO0RsECoT8RfJ3LCfNXdVYPYUIokr
   UWXj2Syskxvgy8QcKWze1upsetuV9KweZ0B2/mduWaOJtIT1f4TXUEFTe
   tAXQBj/NZnXDK1AmE+r8oVhujPlKO0EMQE0vwzIv66lyRP1SqwtDSpT/g
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="369373084"
X-IronPort-AV: E=Sophos;i="6.03,211,1694761200"; 
   d="scan'208";a="369373084"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2023 21:14:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="1000519372"
X-IronPort-AV: E=Sophos;i="6.03,211,1694761200"; 
   d="scan'208";a="1000519372"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Oct 2023 21:14:34 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 9 Oct 2023 21:14:33 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 9 Oct 2023 21:14:33 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Mon, 9 Oct 2023 21:14:33 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Mon, 9 Oct 2023 21:14:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TMEMdXVXVVf7JcavIQiNmJQHIlPE6Vl8Z+T48FqjRBO9obqN49qcle3lsjW9aQ3iKUQLsfEUKE5BDqxMMitvQwxCC5tfwpKzaH95GOQRwcY5JqEgMdR66zQTL+sgBKCTcXRdyFvYuD/KQbRh5Th4tx6nyejea2/+cjekC8m8jAYwjV1CMLgZhQHuKqJqyFmisWoU85raJuJDnEI09f/Btd0WzpIGYzoF1NXm3w7adykGMBGsAiVu2g3ytBYDhktEZuN35hQPOstK2gRvmYmOvoKvy5rw7WGZCjqxorlBnWIMj5eTHnSUs46dGTW9Ya+J5mCr/lzoZP/snTrWv0H/Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J3vDwJb/8DwzipUlqFbDnVjynJRSRhyMgR34PQ8xZ2U=;
 b=Av8TbBlwxKwbQmRBqazzuXoHGkMKKzTHLsXRLOIQuND3Z1JgoTtm3o2qLZHyLcnpgPgjh8T9aVQQYBRp8QgOI2H0HaAKJauhzrPKdTOJHTGX/BYWq/grToQFNUp0gOdE20faudwbEBQNaV9RKXPizu1nfxE0egne90+ApPV/C8+E7Y8nq4i8Z3B8qPvxF8Tu+fwXoz0am2NUsMtMssYdDEOt+GOhSFU3ogS4SNuRuQkICXYFujjt//fvJAVYXOaqLi20NBSem2fnafxtFHs+do1CtgME+3h3lu9WgonZsvZZmqXhDGUGTXckwH5O0HAu4IpTHAicity7aHEWxTFj4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS0PR11MB8231.namprd11.prod.outlook.com (2603:10b6:8:15c::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6863.36; Tue, 10 Oct 2023 04:14:29 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::5e79:2d52:51e:f602]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::5e79:2d52:51e:f602%6]) with mapi id 15.20.6863.032; Tue, 10 Oct 2023
 04:14:29 +0000
Date:   Tue, 10 Oct 2023 11:46:24 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Like Xu <like.xu.linux@gmail.com>, <pbonzini@redhat.com>,
        <chao.gao@intel.com>, <kai.huang@intel.com>,
        <robert.hoo.linux@gmail.com>, <yuan.yao@linux.intel.com>,
        kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 01/12] KVM: x86/mmu: helpers to return if KVM honors
 guest MTRRs
Message-ID: <ZSTJEJepdnmC5PA5@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230714064656.20147-1-yan.y.zhao@intel.com>
 <20230714065006.20201-1-yan.y.zhao@intel.com>
 <553e3a0f-156b-e5d2-037b-2d9acaf52329@gmail.com>
 <ZSRZ_y64UPXBG6lA@google.com>
 <ZSRwNO4xWU6Dx1ne@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZSRwNO4xWU6Dx1ne@google.com>
X-ClientProxiedBy: SG2PR01CA0161.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS0PR11MB8231:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b7b95c7-40be-4fb3-47ba-08dbc94765e7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7ZFFiEGJhWCcrHeqwI1EEVCwvY0PNGkRrzmdYbW/B6+mxQ/s36nY0tkOm7mTVeHw4JVL+SPSwq36ctlvDQT+SQOa+Kg8vnwpPQMO67nGFa5m22U97c4bOxMC1WvflZT/WP2GI5+fEjK9AFnplFUgrzSpCdGHwKZef4N5poPkTgjkvCdar1mHUhYsQonFVVP8ftkKfNJ3BfaF1+JqDac9nDFJpSlsOY/dMDg4oE567ywo843ao96DwfAFT8rCiqtPpX6V0I5WNpMNubtcB/S8Ohad9T27ZsPAsyK0GbYy+UtKsGIFtU3VsZQw79rox3jvI4c/QPRa47t11k/4qBt0umqAC7+hW09XcUNr6tUqsGhWERslcTtyov+qTVI73XeG3whLNgg1iqgHY6AVf/EkzoKKw8AFiq0/MyumwgBcUfe6PAj/Go5jIhH263gFaIYfhm3b7blgC02nV+J9LcDzgJ4Q94yhHZRGaa7VXW4+S6oAEBzXn1LMBv5sdOFP6Ew82dKMestCe1K0kflLmojdWqdytpKruTPYtxn/CFgZ/mxiDPRpq/cBeoWLvZpH72ua
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(136003)(39860400002)(346002)(376002)(230922051799003)(186009)(451199024)(64100799003)(1800799009)(2906002)(6506007)(83380400001)(53546011)(26005)(54906003)(316002)(66556008)(66476007)(6916009)(66946007)(4326008)(8676002)(5660300002)(41300700001)(6512007)(6486002)(3450700001)(478600001)(8936002)(6666004)(82960400001)(86362001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OGxhdm9palhQLzdiM09vYmRYSHpLOHBhSmQ0eUFWYzJIZVNIYlVJYUc3a1VN?=
 =?utf-8?B?R1JweHFGN0puSjBObWJtVWlaTElOV3dqbXFpdEhEanZpcjdXenZ1d2NoRGh3?=
 =?utf-8?B?MFNtYUVhVWJyUlE5K2N2RWc5TWZwdFduZ2tKdUVmNFNCLzJFQmxUZFc3OXUz?=
 =?utf-8?B?RThUWE14bktIZ3FEeHNIVUJhbkdHSGthYjdzb1dmQTIvdFRic3RXYXR2WDJn?=
 =?utf-8?B?UUpnUm5FcmJJTllUbUcxRzFEZ3NJa0FjekxORlhnK0tTWWtnZEczM2cwTDli?=
 =?utf-8?B?WjJxMitpcXY0aWhWbWFiV1EwdEVxcUZkbGRwMDJPNGJmOHhxM01IZEdTUWlv?=
 =?utf-8?B?RGVnOStpb1BaMDh4Y3YvZmdlTjY4c29MSUwzbjNuSUw3c3o0cHAzdUxxZFdT?=
 =?utf-8?B?cFRQRk1PL3pvbzRIMGNlZDN1ZURCcjFCOEpZUkI1a0R0WHdsd1ZMSVE3Z3dv?=
 =?utf-8?B?QU42c01KSDd0NnFmemdhTkFaTXpjZDltVUxCNXg0YXpDd1J5RWtzRDg3eFlJ?=
 =?utf-8?B?akYwUDhKWDJVQ1dTdllzT2h5TzkvSXU5Z0xkYlViaXUvR2ZjK3dIazlsalYr?=
 =?utf-8?B?OStUa2xsOThXbjdDM0xsTk5pdGJaVVQwZ2NlZTdBUCsvemFyZjdOOXRaTVZx?=
 =?utf-8?B?aUVPRkJMRVhqc3BQT0RNTitlSGdXelZtVzRoNEYzS2lOQnlncmtITkI3aGxm?=
 =?utf-8?B?WFl0MGdncGZWdG85ZUxxZmV1UkpFTDdtNE1FMHhKNFgvaTM2NFhXSGI5SGpv?=
 =?utf-8?B?ZHFEOCt5UXZhdjUyUmZTWDE0WU55OVRNMjRoTnl0L3d4ZmR1dFhDSHUvQjRH?=
 =?utf-8?B?WlZqSHBnN2xsVUtYeUpMUHpGdDRrZ2d5V1Z4NTVQeHNZVnB5bDlnNThjaFlo?=
 =?utf-8?B?bnRCWG9LZ1YxNHg4YUFzcHVVa1hKY0hxUUJQbUJMQm5QcWZHT0daRGUxWlZT?=
 =?utf-8?B?S2ZmQmtMMXUyMkVhK2xiLzlDeFFKd0JzVU5mVWs3QmhkRmN5bXd1dXFXNmhB?=
 =?utf-8?B?Wnk3UlZqTjFUMEM1M01HSmYwSjFXYWNYLzQ1NisyaCtTNndnTkJHTm9IQW0w?=
 =?utf-8?B?Qmp2Rlo0L0h2SXQ3WElPODlDNmNPRkVDMVNaQzJwL3hEcDFLb1JRUkxPcFdz?=
 =?utf-8?B?MVVOT01UQnhvRVNseURvWmtoelQ2UmlWUGlQeWZUNUJ5b1FIZmhwT1JnS0sz?=
 =?utf-8?B?YzZuVENlNnpVa0syNHJESllHQ2gwVkxmQ3d4ZzFlSkhVTnF5ZVlBYURzRHRW?=
 =?utf-8?B?TlhyV2Fwd21Jem1BMzV2SHRiTWN5aUhaL0tWUjlzUy92bzIydHkxbE1HZ2Ix?=
 =?utf-8?B?bGV1cTlDNUZTaXIxbXNrNkxWbnhreDJqN3VOS3o4bVpvVURUZG8yZURqUDNK?=
 =?utf-8?B?N1B0c1grZnVCbTR2WmRXMUZSYzhaTDd0TDAzZlRsQll1aGU4NjROZHpUUWpL?=
 =?utf-8?B?em1tRVJ2NGF1QStMN3JZemNyaitPZFhkUUFZRERNQ25EdzZsTmZpN2VhbTY2?=
 =?utf-8?B?NkxnK2tTcU1FMnBEZ3V3UzFWaU0vR1F1VE9FRWRwYS9nNDZCNGlWTkxSK0VI?=
 =?utf-8?B?b1JpbFltV0UyQ0NuQTJkSDZWYUNudEc5L1paZWU1QmJ2TGZYUjlvTEltQ1l4?=
 =?utf-8?B?Qm8wVThLcE1TSG9VbGxZMXNlODhDL0ptRnBjVlBDbmRqWlhLaSt5MlY5TDNE?=
 =?utf-8?B?RmlQUmNMa0FEQzdvZzVRZzdpRjdTaU9WdlpHMThVREhTQ2dDMDlrbGl3dHBX?=
 =?utf-8?B?ZmJaVTdCNUJHVlRnV0pwQ3hRSzE3d29PK3dSTkNjZGVqeHdRVUxNbWJiTFh5?=
 =?utf-8?B?TERhcVhrdll6YmtFQk1sZC92ZUNvSnN3K2pqT3NGV3VjcHlManZKK3pBaXBl?=
 =?utf-8?B?cHFkRjhNOGYrQi9xUlIxbHppQTZEZWN5V0hybzlPbXI3SXVReHZNWlUweWtL?=
 =?utf-8?B?SXR3djAxOXBZSnM3d1l6ZG5zQVoxZVdiM0QvWDNEaDZGNVFPWldCU1pkazJp?=
 =?utf-8?B?VWFzbUpSL3VpL0h5c0o3dWYyelpwT2ZkVjVCSXp3ZUIxbFhhMFBaRUYzNjlZ?=
 =?utf-8?B?VERNMVY0N0orbkt4a0diSjRSWDVSU2dXNEhVQWpsbk1qbmZiK0QvSFY4bkxM?=
 =?utf-8?Q?wQXEzpNrhes/QV6yto/Qknn3r?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b7b95c7-40be-4fb3-47ba-08dbc94765e7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2023 04:14:29.3907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TPlly5LBzePY6NBvLnkXe9WtciFkUxl51RD99SfD8w/6wFMUu6yxwoSZoWAk6jilSJkedbF4yCDSPkLXFbfIAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8231
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 09, 2023 at 02:27:16PM -0700, Sean Christopherson wrote:
> On Mon, Oct 09, 2023, Sean Christopherson wrote:
> > On Sat, Oct 07, 2023, Like Xu wrote:
> > > On 14/7/2023 2:50 pm, Yan Zhao wrote:
> > > > diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> > > > index 92d5a1924fc1..38bd449226f6 100644
> > > > --- a/arch/x86/kvm/mmu.h
> > > > +++ b/arch/x86/kvm/mmu.h
> > > > @@ -235,6 +235,13 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> > > >   	return -(u32)fault & errcode;
> > > >   }
> > > > +bool __kvm_mmu_honors_guest_mtrrs(struct kvm *kvm, bool vm_has_noncoherent_dma);
> > > > +
> > > > +static inline bool kvm_mmu_honors_guest_mtrrs(struct kvm *kvm)
> > > > +{
> > > > +	return __kvm_mmu_honors_guest_mtrrs(kvm, kvm_arch_has_noncoherent_dma(kvm));
> > > > +}
> > > > +
> > > >   void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
> > > >   int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
> > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > index 1e5db621241f..b4f89f015c37 100644
> > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > @@ -4516,6 +4516,21 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
> > > >   }
> > > >   #endif
> > > > +bool __kvm_mmu_honors_guest_mtrrs(struct kvm *kvm, bool vm_has_noncoherent_dma)
> > > 
> > > According to the motivation provided in the comment, the function will no
> > > longer need to be passed the parameter "struct kvm *kvm" but will rely on
> > > the global parameters (plus vm_has_noncoherent_dma), removing "*kvm" ?
> > 
> > Yeah, I'll fixup the commit to drop @kvm from the inner helper.  Thanks!
> 
> Gah, and I gave more bad advice when I suggested this idea.  There's no need to
> explicitly check tdp_enabled, as shadow_memtype_mask is set to zero if TDP is
> disabled.  And that must be the case, e.g. make_spte() would generate a corrupt
> shadow_memtype_mask were non-zero on Intel with shadow paging.
> 
> Yan, can you take a look at what I ended up with (see below) to make sure it
> looks sane/acceptable to you?
yes, tested working on my side.
I think why we added the checking of tdp_enabled was because of the existing check
in patch 3. As noncoherent DMAs checking is not on hot paths, the previous double
checking is also good :)

BTW, as param "kvm" is now removed from the helper, better to remove the word
"second" in comment in patch 4, i.e.

-        * So, specify the second parameter as true here to indicate
-        * non-coherent DMAs are/were involved and TDP zap might be
-        * necessary.
+        * So, specify the parameter as true here to indicate non-coherent
+        * DMAs are/were involved and TDP zap might be necessary.

Sorry and thanks a lot for helps on this series! 
