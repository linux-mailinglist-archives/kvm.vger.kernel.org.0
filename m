Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8486573DB
	for <lists+kvm@lfdr.de>; Wed, 28 Dec 2022 09:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbiL1IVL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Dec 2022 03:21:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiL1IVJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Dec 2022 03:21:09 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D08E26;
        Wed, 28 Dec 2022 00:21:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672215667; x=1703751667;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=ud7x6N/VZcwlByuAmjb9pzAZL7D+9DkcF39pzl8gafg=;
  b=WkuM642R93shMC6s5dfcE3VqfQ5OPVApOQ51imTs/LxxGp5OqbVlVs/v
   RfkGVQTe+bQozbwEpfzcsCvP6PVnsPsKPWqhG9L+RaAKjADPAlsq2/yTX
   1jPUckN4tNUTOODqgz5Fw5Z2eaWDIxJ4nkL17XhHhapUsEX0tJ6Gnb8+L
   1mNW5RXjOK4tiAwZUt40ZFyi7ryztuOkMUgVhty+MshiBZcZx/yf/YeGR
   gyQo3zUJxpQHS7kDfLkEVvZLqJZCnIoN1Kq4Phhiuv6D30zyCdUnNv+PU
   MW5FFXjhq8A4ORybdEHIR7eAxQSDS6Zk1jYLOzw53Y/9OOtQPss2loZQB
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10573"; a="385254448"
X-IronPort-AV: E=Sophos;i="5.96,280,1665471600"; 
   d="scan'208";a="385254448"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2022 00:20:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10573"; a="741960554"
X-IronPort-AV: E=Sophos;i="5.96,280,1665471600"; 
   d="scan'208";a="741960554"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Dec 2022 00:20:56 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 28 Dec 2022 00:20:56 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 28 Dec 2022 00:20:55 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 28 Dec 2022 00:20:55 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 28 Dec 2022 00:20:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cJrgOksYzcrB1WlDpiKTdSmi5nt8Ags/N1bhIUSzxkKSqRyqPqZ+XKR8eeF3qUHr3+suPbLr+e6v/wEOLGUGK8YjaWG2XjOj668HjB+juwaaudUg79ppX2Qn0JnoF2moo3pJNMcYjCa7ftvTnX8LubqxSKh347katiyo2N2u6lf36OXRmJHPULnWy94wWT+P2Jj8VaoD89hSu0x5CccFaDKFws5D6+e9WoEgO6LoY4Nogi/Tp+REP1jxD8Y42dPOALaqEJ0ry2hdsFNkwoushj2i+Mm7ccx7IOPts8eym5/rFdi7q44snGmiCCBgXXm5uPvWZwJPjAk98WPW/regCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WqQ/5NNio99xdIHKJklsNsbv45dQMESCeDa7qx1Xfqs=;
 b=MiMNROK/79fM8WQYxVyy5wF3fxtmxQDjduMi+fFXg8v+601mGgIfujOMU8/7CJDXkChJ/Jxsm2VFmdrIyNcLOtuGd0cbBVgwswDz3EimS9GzpJmm9P2YK7S/QriECjLynxL8KinbcgyKTAObTQM1znwnZjQ4pLV2mIS9TzRoYZQcE5p6t+Uv7EjxcED6G2+Fj+Ptcym64fxf2XE9lwRsdWcAHFQ4g145napMq1j3f+pK1rvbPKpf69KpqUZnWTFROxKAbu1PkE98AcASG5haIA+Jp3qGbpoKSVec/288UdoZ3VZabHPoGyEUFHzPLItNx/Iubny9NYtNp413mT//ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MN6PR11MB8146.namprd11.prod.outlook.com (2603:10b6:208:470::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.16; Wed, 28 Dec 2022 08:20:52 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::bd50:2cf7:f362:3734]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::bd50:2cf7:f362:3734%9]) with mapi id 15.20.5944.016; Wed, 28 Dec 2022
 08:20:52 +0000
Date:   Wed, 28 Dec 2022 15:57:39 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 26/27] KVM: x86/mmu: Add page-track API to query if a gfn
 is valid
Message-ID: <Y6v287BFez8tU43e@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20221223005739.1295925-1-seanjc@google.com>
 <20221223005739.1295925-27-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221223005739.1295925-27-seanjc@google.com>
X-ClientProxiedBy: SG2PR02CA0113.apcprd02.prod.outlook.com
 (2603:1096:4:92::29) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MN6PR11MB8146:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a2dfd25-7208-435d-e0ed-08dae8ac6eb8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MW8cJPDR1G3DZ2MDYSnl9U8/RLsUDbNs6DoPffkZxg/7QLJUV0CqqJETfPh+rNC5xoWOHoHE/s/MmW2eySl596vSWRn3e7ivuTRpDqfbMioOh/2Vy955gp9/X7bfN/ZcnfBK3Avpo5hmcI2lKjL7UqTuNwHWQkzzmJCOynrb2hPPpz5peMwTcONvtylmspC+MTAFf7d8WlX+wXo1CzYGTy4Uw5gNjTATAMRpXHtZDiJPgTkAIdnUhGe9LBixpemEPqHh47IwPVsS9kvc/VWRgcldyteA8NId9y2LG0v4cyqvBGVO6S37kffJKaLBoze1RATwMFDFdhQHVp4TWH+xXi6O4K47NmL0IcSAb5VMD8aew25QBJ+xBy0aS2LcPslUDxKa8tV4rbRj+jorI3FAglmtLtueUvJ19mYBBT96tcaSyhQnFN2aOrXvzNNXVG9kG7H0eUF2qpMQZzExpVIiNs0W5X/ju+iwLLCF94aVD0/5AruTVyiAwJP6AJSwL7vcNhHissXnKOsj5N96cXfcT47JCrafNVPo282GGIct46O3vKHFufWj9UpzA+YoqCJhC+2n5izYTCIbBvk809zWHXN65ioPtgxLrnv4AymDFFe3KUFvpLs1BcV/oPxPEWtBDDybelQtPkDaIMiWQ+d3NAYpDWU27pqxjTPtKQalFftSMrp5p5djoO8FGcZ5VImg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(136003)(39860400002)(376002)(396003)(451199015)(2906002)(3450700001)(8936002)(5660300002)(41300700001)(4326008)(8676002)(66556008)(66476007)(66946007)(86362001)(6916009)(54906003)(6506007)(82960400001)(316002)(38100700002)(6486002)(478600001)(83380400001)(6666004)(186003)(26005)(6512007)(21314003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RRw1Q8UaSChSylELz2ZWGYU3qkXzF5DtTtcw3x73DC1PatTdeSRrEiA6Wb9g?=
 =?us-ascii?Q?BkpE2xTjPstwSiP9JjMPuutHbzc1x6DofsTgCXHQ+qAGzH4SG0CvIhCoPHgY?=
 =?us-ascii?Q?wrRONDmbVA0EPkSpLerqfWddPT/FOMBX9mqCgtiu9cPYIoqdiGjBqRIZo8Gp?=
 =?us-ascii?Q?YVK/Z1LEopv6VTPumoAo4qJnFHUK4K9Wav27P/9uYVj743Emid+lmr5I8fV1?=
 =?us-ascii?Q?QbI2xxGozEpikxz/EtR+PTxGwQr11fDIwV0rOgQ8CrMeF7VgToESoKBC5May?=
 =?us-ascii?Q?omma7wj6m+2vLZW2kOT5t62FF3ZlJe7OTK4RYT7DdAi3vkXVzT7NCmUbmhh8?=
 =?us-ascii?Q?gT66ynCZd/P4b3ncE3m5IgISkPvyCclgcfajk8lym6in4yYKb6NoJlULyubV?=
 =?us-ascii?Q?7vO6c3C7vDFpRoBuBFb7CUqJ2aJ58gpqrRP2x9l4OSAF0rLh3lJUD/sQfoI+?=
 =?us-ascii?Q?uC3FAA1W15P/ZlbPlxSu1Oe0DlSKOvEHBXHRABPCEMQThGswXyvfvjqdoSPG?=
 =?us-ascii?Q?TTJl63sLnCExCfpqDIoTI+kpqvkCuhGN0SLSBZclPuhkmnPzWyfbRB3WITr0?=
 =?us-ascii?Q?F4AoUNb6l6APjCM2RSVIEwOEyCtdWAZAQEEh+QkVCwsO2P+Pxl8PExRxr7nA?=
 =?us-ascii?Q?+VCj+GkQ8ptl4RvIdOfEUGqy1ocjORhK4rmYXKIsW1NbydhyeJ4ij4KzoTci?=
 =?us-ascii?Q?5h5S3G9W1jr7wwjQcLaoao0kmCXsnKTpdfgZSxjeMpXD3xp9umnmMd/glmkW?=
 =?us-ascii?Q?seN/cJW3F75z7Q1yRFD5EJwAS0mLEcPjEmA4nSEOcHc8X15haIfLNWbGlqfI?=
 =?us-ascii?Q?BJTlmjmD2FtHeuPiF9ziW4ctpwYCWUN3+r1b2SWmt+PmUL7gOAIydzGY0wYt?=
 =?us-ascii?Q?Yen5jm2u2sT9P5bZByBoGm1TNddkDPlJPwbC/gvRnw+qL0wkkS6+iIcJlZqb?=
 =?us-ascii?Q?PjKef90v3gNCvBtKXYzUzhIDJMSGxtaEG62Uinyu/wAq2vqyyI62sOjx65Q/?=
 =?us-ascii?Q?tG1Bvqt4MZOpqDxXth6mj4Qy0LcLxcG2+ypQIfepSxJJ0bw/sfC2HKe3+W3p?=
 =?us-ascii?Q?SBLxLzJ935Gsnp1vNRZ9qvCbqoX3OGCLwGMT/3Tjq3bPJcf6bFYuM/MyDsdx?=
 =?us-ascii?Q?w4PxqrC0bvvsgkPPiMlOct/5Ev5SNIszteSPWflMCy+l/l8wKENLu4omjzaw?=
 =?us-ascii?Q?vygObCBi3P5hzCCnFExlP9M1aFX0TyePUhWxiXugtgYhR4E7b4oHrevO3bQk?=
 =?us-ascii?Q?KjENMW5cFg/twFY8InpkFe/F4ON02Pm2e5UCa69oOxvDdq7St5ha64vEwVd3?=
 =?us-ascii?Q?gqWIBoAGOHPVkmwfjdkYQyaBeoGlalIMIxmAjhMfI4k6CmxfxzAJNNl0b4wC?=
 =?us-ascii?Q?MQFUiEqW5jhEQKYSl73mPeL5xb1PDeJo1YOxCkITvLK2BTQ0rYA/HgQVtAaj?=
 =?us-ascii?Q?k8CCmjug4qMI/n3o6irjYL7kpPmxnmKFadjuMaZFl80cvkSkaUipa0a72t3l?=
 =?us-ascii?Q?/LE9l53xVcrm9SFCcvTPhyI1LtsUQhjdlhawbx553ZlOsGg8OYUojGiPIMoP?=
 =?us-ascii?Q?fpPX3jk3bErhwueD/ocxG+jB51y3OZEuIoZqChiX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a2dfd25-7208-435d-e0ed-08dae8ac6eb8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Dec 2022 08:20:51.7536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LoZ2zFwCQycLPt1PLW6CRQmLBZcjO5BMT+GWLfaBsTnaUovBuy1TD9DqGjDZVMl9NvDF5ECO4NE+S22meG5mwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8146
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 23, 2022 at 12:57:38AM +0000, Sean Christopherson wrote:
> Add a page-track API to query if a gfn is "valid", i.e. is backed by a
> memslot and is visible to the guest.  This is one more step toward
> removing KVM internal details from the page-track APIs.
> 
> Add a FIXME to call out that intel_gvt_is_valid_gfn() is broken with
> respect to 2MiB (or larger) guest entries, e.g. if the starting gfn is
> valid but a 2MiB page starting at the gfn covers "invalid" memory due
> to running beyond the memslot.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_page_track.h |  1 +
>  arch/x86/kvm/mmu/page_track.c         | 13 +++++++++++++
>  drivers/gpu/drm/i915/gvt/gtt.c        | 11 ++---------
>  3 files changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
> index 66a0d7c34311..99e1d6eeb0fb 100644
> --- a/arch/x86/include/asm/kvm_page_track.h
> +++ b/arch/x86/include/asm/kvm_page_track.h
> @@ -52,6 +52,7 @@ int kvm_page_track_register_notifier(struct kvm *kvm,
>  void kvm_page_track_unregister_notifier(struct kvm *kvm,
>  					struct kvm_page_track_notifier_node *n);
>  
> +bool kvm_page_track_is_valid_gfn(struct kvm *kvm, gfn_t gfn);
>  int kvm_write_track_add_gfn(struct kvm *kvm, gfn_t gfn);
>  int kvm_write_track_remove_gfn(struct kvm *kvm, gfn_t gfn);
>  #endif /* CONFIG_KVM_EXTERNAL_WRITE_TRACKING */
> diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
> index 1af431a41f71..9da071a514b3 100644
> --- a/arch/x86/kvm/mmu/page_track.c
> +++ b/arch/x86/kvm/mmu/page_track.c
> @@ -264,6 +264,19 @@ enum pg_level kvm_page_track_max_mapping_level(struct kvm *kvm, gfn_t gfn,
>  }
>  EXPORT_SYMBOL_GPL(kvm_page_track_max_mapping_level);
>  
> +bool kvm_page_track_is_valid_gfn(struct kvm *kvm, gfn_t gfn)
> +{
> +	bool ret;
> +	int idx;
> +
> +	idx = srcu_read_lock(&kvm->srcu);
> +	ret = kvm_is_visible_gfn(kvm, gfn);
> +	srcu_read_unlock(&kvm->srcu, idx);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(kvm_page_track_is_valid_gfn);
This implementation is only to check whether a GFN is within a visible
kvm memslot. So, why this helper function is named kvm_page_track_xxx()?
Don't think it's anything related to page track, and not all of its callers
in KVMGT are for page tracking.

Thanks
Yan

> +
>  /*
>   * add guest page to the tracking pool so that corresponding access on that
>   * page will be intercepted.
> diff --git a/drivers/gpu/drm/i915/gvt/gtt.c b/drivers/gpu/drm/i915/gvt/gtt.c
> index 59ba6639e622..43c4fc23205d 100644
> --- a/drivers/gpu/drm/i915/gvt/gtt.c
> +++ b/drivers/gpu/drm/i915/gvt/gtt.c
> @@ -51,18 +51,11 @@ static int preallocated_oos_pages = 8192;
>  
>  static bool intel_gvt_is_valid_gfn(struct intel_vgpu *vgpu, unsigned long gfn)
>  {
> -	struct kvm *kvm = vgpu->vfio_device.kvm;
> -	int idx;
> -	bool ret;
> -
>  	if (!vgpu->attached)
>  		return false;
>  
> -	idx = srcu_read_lock(&kvm->srcu);
> -	ret = kvm_is_visible_gfn(kvm, gfn);
> -	srcu_read_unlock(&kvm->srcu, idx);
> -
> -	return ret;
> +	/* FIXME: This doesn't properly handle guest entries larger than 4K. */
> +	return kvm_page_track_is_valid_gfn(vgpu->vfio_device.kvm, gfn);
>  }
>  
>  /*
> -- 
> 2.39.0.314.g84b9a713c41-goog
> 
