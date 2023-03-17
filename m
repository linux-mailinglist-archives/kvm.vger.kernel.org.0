Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 355FA6BE178
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 07:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbjCQGpM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 02:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjCQGpK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 02:45:10 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B199CFE5;
        Thu, 16 Mar 2023 23:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679035496; x=1710571496;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=YN2pF5gWGPXsKbQT5TEgeFfBXqtHQavy49oQxrRHOFU=;
  b=MYUeZdiTnE5hXWHVUE35ibZec1ojNOGHIEB5Z11mdenHU2KqeZGAKuH/
   mwQVLKFdkZp25akxfwq66OGoHM+r2Qu6h4Pw0pBfROjYM+oJILCscm+tQ
   p7dQMZAI9aMIcDJ2lTFimKYq9/K/d28jChYfLsMlBLFlyNregU+JQwbhA
   ema9F84OAypHDdatf0KsIh1freouc9Z2zF2pYuS4LDNfIUwtDzwMl/kJm
   gZfxDgMC2jIcXoOUhCOS+/KLWaUHII7HeOgJ521PGbPsLRy5YRUtMJF+1
   Tv+UCJiBd5uqLlQ/3dwHRx5tA/1iZFTm4y/pVwm5HrixG+Oft1LF+Powf
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="339735898"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="339735898"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 23:44:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="710401424"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="710401424"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 16 Mar 2023 23:44:56 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 23:44:55 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 23:44:55 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 23:44:55 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 23:44:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Eq9+nXhy5349J42d+NLLZYoTh+6dCUkTvGt1jhmyWqDJF3nIG5t55pcGjjVY6SvOQPpEp3fAvS4++HJAmchm6fMhFvl3zn4iJPGlZZkv5npZzZnaZYw0u5/MY25cOLBQsbkDb4YC6+UcVs5e+NHtYc2VnwPE6NnpXb75DvFfauN+iASXWV8DL119ea2Q8zsAkVpLyd2DTyoFgmvfSi+KM+gtIZY042AxucVMP+td9IkqQxLG56YWHqIgUqOMn12Y+a6jd1/wCdZRdrqdEYZTlNzki60prUA+BrGHtOQ+732iwlzWLu1lx0utASLAMM1F+vW5fOZUgl37KoGmo4+cXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rXhHEWsupVKs6BjK2Fo/xNYT9WAoZmfd2PwX7k4Aq3Y=;
 b=hWVI1DFrGHc7L3VnXWSAQNJUcmwHVfrY8E5djfVnNZgSY+RDGJ9bXezb8FCddveL3R+LJU4fGFF2XcuyskPO4zsX4uEVYHabR+7kz3EmDP8fkNM5tGqqNpoTvtY30i+EILFcVLo5uIuzzU2Wfnf40TckGkXFVXhdmlJHweUBYYcIxl3nf3TJIG9s9SCQSXsRtSEZY6SpW3Pfufj2pNIo3GOWWUh/FPPD0+lrd6Lf9ULkbxPUrpIiHXxynskZiM43BBr0dqlu6iLuVxHu+KFDKEXizsDgjvatOHV2yv8ovmhZsq1sroV46/qjEcFxp8iWms6GVukD0Yk/bKTDi0sqgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA1PR11MB8253.namprd11.prod.outlook.com (2603:10b6:806:250::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 06:44:52 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e%4]) with mapi id 15.20.6178.026; Fri, 17 Mar 2023
 06:44:52 +0000
Date:   Fri, 17 Mar 2023 14:20:15 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 09/27] drm/i915/gvt: Drop unused helper
 intel_vgpu_reset_gtt()
Message-ID: <ZBQGnz8BXFhrZv+O@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230311002258.852397-1-seanjc@google.com>
 <20230311002258.852397-10-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230311002258.852397-10-seanjc@google.com>
X-ClientProxiedBy: SG2PR01CA0162.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::18) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA1PR11MB8253:EE_
X-MS-Office365-Filtering-Correlation-Id: f6cff1b1-71cc-4f46-d884-08db26b31cb0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MhPMnEj5x1ooK3OSqxNPyIXB+MXilcCO8r18Es60Hy/qg1TIzKkrRaYJYAZC3Z+9a6fL+56AzDdpmn/DiuL92PbV6WHV88F+WGYsQUnwmMBrK4rOUzh7bNxcJuEjw7i8hL1aZycYnbsGHHCzspxf+xKgY+xrPz246ot0lGaXFM4Th0akg3BHT9vEI1yxYblQQz3RohUCRnAwEh8VCPqEiGaaEEQ3aCN82ovO8nw1ACQXb6Ic07aIyxNjP7PWtU9obSbr3vHOizBwk/gDgVG3eV9tcOTyeGaBhxrzSVYPKDLLU4Qv55Ks4ba/i47z594gu3P/I55E2axOKARUCJXRnYiiBGcSuTl6tdhzLR3Loe+WyuowBQC+rN8/lv0DLPboJd8b3oT2Hr/cZKtZVUXfKbznv4ozTm7mF44l2/Ldm8CpEtvp5KVJKr6b0tMVtIxXYtNDnrSvtZL6yVzLvflsVd2sXtlpngPD43qO5XgpzxQtDfOS6VpLNMb5hX9OLjUXibk1H6aEMnEn4RvF8o47erLYCbuG6WONDW03yxmNKBWXGcqveRSjSDZmz+DE245MQfyyZmam/oEvbGkd2xLGL6a/hpVfU5vS0Mzw8BrnaDWQlV4D954kFIKAvH5fiNxShx4Js1T6l+isf0opEC/Wcd+dINHSyifMCOZK1LR6/kgF8/PNdkDLG3ZoU8YJEXvw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(346002)(366004)(136003)(396003)(376002)(451199018)(5660300002)(8936002)(2906002)(41300700001)(3450700001)(316002)(8676002)(66476007)(66556008)(54906003)(478600001)(6486002)(6916009)(6666004)(83380400001)(186003)(26005)(6512007)(6506007)(4326008)(66946007)(86362001)(82960400001)(38100700002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kE4LaAuNKhdyhTTgNhx+w5btrsgfPj017IZ1r6IgUgP5sTsC7Ft2YGovE9SI?=
 =?us-ascii?Q?lm0rHM5+eVxC3hoFPjjql09vfSiulJL95RypkWBcicalzJPtJtq8sjML9f+h?=
 =?us-ascii?Q?fh0mY+yFcjQPTkeYoIGMOCjmZm1gcJ4L4qg/Bu50m9qNsQ+DSBLqOzIM51ye?=
 =?us-ascii?Q?25sCc3okUAQoGfb3oUTNgF9NhpfT0GWPidrdjdcLAnRpR1PzAbu7PWwjA6UE?=
 =?us-ascii?Q?8g34QIdqQ2+2DfmISEtqq4BHfDc3CsDHOerLs3jpKnVzCC+bwNd+XcreZeFa?=
 =?us-ascii?Q?5gGLmmMRKGivp1j8ptxJiy59ElN6H4A6uI/4F8MXuR3m+mY30Nne9MhfxAqk?=
 =?us-ascii?Q?Jas5Hkb6oxNez+5SIY4TXTBSNLkDw/FV0cxSZvOHTyhebiST70c7/J7JceBb?=
 =?us-ascii?Q?64c8arHq4hGH/rk2p4SbzCc2E+QjfJafVRQcXM0hfLQgSk1doUNsymlNiBnp?=
 =?us-ascii?Q?Wna3OUHdPhmKmsbBUdoh8sjnwHWo9uw8sL5jrwEaiqioypRezUrBBAwJiPHB?=
 =?us-ascii?Q?TX4YY+mgD2pdIL/ZX7SaT/HUwI9KWlDaTKU5IfKF2FbYjEtr8HAUic+Wy6bi?=
 =?us-ascii?Q?0VVAwdu50OB4IKO8TCwlTYy9QYMgKdl0ig4Ko3VKFHFZmVOMj6lONNEkxjRX?=
 =?us-ascii?Q?KWLMAhD5j/qQSz7JyZy+vJPDnDYf844ouEVZgvKh7Y64Aga9qcltZbscenTb?=
 =?us-ascii?Q?qRry7Ly7q3viG+YG9AXulv8FRUAdDKQkm+armL41v4uJicDAW6jjbCPqMcxH?=
 =?us-ascii?Q?kUuqeJ3HT1p+Jp8l3dxpyM6BtwTt/2x4Sd04y7Y9G5nHR54fQZyT2i+6l6ED?=
 =?us-ascii?Q?dilZmVIFO9eMP9wADOUXDXgsFdAwSylPzeroHMq47K7TOKpq9VkEfVj3rlgv?=
 =?us-ascii?Q?BgcgHLAbIutzyNWE5ryBfNRiO2TwXjTqvYADYHeZtk9eCOZ9SPsGeEOLGCjn?=
 =?us-ascii?Q?pzDlXInIvsmJRt/u4xZaPnpc94r3ciYE3Jpfqk/zoDA4Kjzyj5eZFvARnMTa?=
 =?us-ascii?Q?1AizQGpeUWWjAExLX2ieZsafGYsOs8r5mpjBLw+mvd2yYQhzELV4ohlCusH0?=
 =?us-ascii?Q?2Rn9UGgsQM7AF5/C+Au9R788o5vwTRcTjt77a5RXd2zsz+x/+BnSstivLi+l?=
 =?us-ascii?Q?05VWh8mPkrpHrGPo0yveR/Y1xdrYd2nPNm5/+QhYMgshZSnBdVX7Eg2nC/+Y?=
 =?us-ascii?Q?ZtBQLEpFvnY5UoJTsX/H5+4pw2M5l1L3SYJFUaUai7rWc2R2/CelPQnlIYms?=
 =?us-ascii?Q?G9jSXitjQN/qciwsZJLkJzVx0VnXoYuLPpzkUGEw0/XC+5tHwOkBEoo65Bbx?=
 =?us-ascii?Q?jVdTD02LcM6lPkqlN3R3m3XDkIvHV1jskdRJYLdwgBk9ckkRdz9xFhmLKNDU?=
 =?us-ascii?Q?QTfWujyZgtv4rekDr3tHvWWW6sTIGlFFXodujsFQsrugo8y0bGz1cKAfAS7w?=
 =?us-ascii?Q?VvOGmrczjW+ltOg53Ymq4HaObJiCn1jH2XiDQ5VTTywv/5WEy3xVO/JqZxKC?=
 =?us-ascii?Q?jmsdHkSsBSsnAjmEg3JJdDmx2TNGdiwH2r5dQAEFuSNPOcoiCty4ZDcofQHS?=
 =?us-ascii?Q?eaiZKg0VN56no4f/PVNd+MC3mzMNzDkwYsUvn/z6uSz9hBv/3SsVarftg8KP?=
 =?us-ascii?Q?Ig=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f6cff1b1-71cc-4f46-d884-08db26b31cb0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 06:44:52.7128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j2z08fA98dhoRlii0aRmEb5Jk61IwwgOUSGbVnEfcy1GEQzv0dZogu2d4saZzHLSo22pwj7lK1hhzpCE05PieA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8253
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>

On Fri, Mar 10, 2023 at 04:22:40PM -0800, Sean Christopherson wrote:
> Drop intel_vgpu_reset_gtt() as it no longer has any callers.  In addition
> to eliminating dead code, this eliminates the last possible scenario where
> __kvmgt_protect_table_find() can be reached without holding vgpu_lock.
> Requiring vgpu_lock to be held when calling __kvmgt_protect_table_find()
> will allow a protecting the gfn hash with vgpu_lock without too much fuss.
> 
> No functional change intended.
> 
> Fixes: ba25d977571e ("drm/i915/gvt: Do not destroy ppgtt_mm during vGPU D3->D0.")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  drivers/gpu/drm/i915/gvt/gtt.c | 18 ------------------
>  drivers/gpu/drm/i915/gvt/gtt.h |  1 -
>  2 files changed, 19 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gvt/gtt.c b/drivers/gpu/drm/i915/gvt/gtt.c
> index e60bcce241f8..293bb2292021 100644
> --- a/drivers/gpu/drm/i915/gvt/gtt.c
> +++ b/drivers/gpu/drm/i915/gvt/gtt.c
> @@ -2845,24 +2845,6 @@ void intel_vgpu_reset_ggtt(struct intel_vgpu *vgpu, bool invalidate_old)
>  	ggtt_invalidate(gvt->gt);
>  }
>  
> -/**
> - * intel_vgpu_reset_gtt - reset the all GTT related status
> - * @vgpu: a vGPU
> - *
> - * This function is called from vfio core to reset reset all
> - * GTT related status, including GGTT, PPGTT, scratch page.
> - *
> - */
> -void intel_vgpu_reset_gtt(struct intel_vgpu *vgpu)
> -{
> -	/* Shadow pages are only created when there is no page
> -	 * table tracking data, so remove page tracking data after
> -	 * removing the shadow pages.
> -	 */
> -	intel_vgpu_destroy_all_ppgtt_mm(vgpu);
> -	intel_vgpu_reset_ggtt(vgpu, true);
> -}
> -
>  /**
>   * intel_gvt_restore_ggtt - restore all vGPU's ggtt entries
>   * @gvt: intel gvt device
> diff --git a/drivers/gpu/drm/i915/gvt/gtt.h b/drivers/gpu/drm/i915/gvt/gtt.h
> index a3b0f59ec8bd..4cb183e06e95 100644
> --- a/drivers/gpu/drm/i915/gvt/gtt.h
> +++ b/drivers/gpu/drm/i915/gvt/gtt.h
> @@ -224,7 +224,6 @@ void intel_vgpu_reset_ggtt(struct intel_vgpu *vgpu, bool invalidate_old);
>  void intel_vgpu_invalidate_ppgtt(struct intel_vgpu *vgpu);
>  
>  int intel_gvt_init_gtt(struct intel_gvt *gvt);
> -void intel_vgpu_reset_gtt(struct intel_vgpu *vgpu);
>  void intel_gvt_clean_gtt(struct intel_gvt *gvt);
>  
>  struct intel_vgpu_mm *intel_gvt_find_ppgtt_mm(struct intel_vgpu *vgpu,
> -- 
> 2.40.0.rc1.284.g88254d51c5-goog
> 
