Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48DA87049F5
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 12:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbjEPKCz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 06:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbjEPKCx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 06:02:53 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD7AAE58;
        Tue, 16 May 2023 03:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684231372; x=1715767372;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=L/LNoqs1tISEtlbcw7xR+7RlMB79xqPMCNJdcg7oGJ0=;
  b=jKsg9IxZX7QHh2sZotnIDJkHGJ6zjiXV1VmQHLvmIBi8CZbYk3hYCMw1
   vSfPClL2Vc4vPY96QHn2vVTUHOW4LkqydyaUMSg7LBgJn+bdn9YGOMj89
   CKHDt5j0zyH8lGF8iKi05oHhUYBWnP3PW+qJeK0GdAxtLUP48koUEnLED
   HV0owvQKN2q4dwd96wnOrDpRGdrksuaZfJm0UtBd+m7+NaoC23oTVBs/6
   NKED20CG4Ya8AeVydTA9nRxhltS+MaN5CG2AdZUOG/v4334X2vv2Z/gYe
   jKUEVyqgbU4Q1L4vqBElauKybWHRB2trxgfUWZMJazQolMKA8aHWoTMEq
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="437778282"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="437778282"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 03:02:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="770977447"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="770977447"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 16 May 2023 03:02:52 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 03:02:52 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 03:02:51 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 16 May 2023 03:02:51 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 16 May 2023 03:02:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=beMbRf6nvxtyUR3rxYr9xn5I7iJ37wMpR5MPiCWFCiscbT4El1A5TZY8IIaE4GNwv23vDvtjuzuV4dfsYzi6h/a/1g8fJq4KT8Xek3qY9xIOKTsk3enxrd0/ge37gQNmo+cAxjC5dBeR1FCnMSfJ5aG3D77vtdl9TRY9iJP3pSG/KMccXfpv/XFG1sI0e5rT+OVzYLShcGlciMKRqHOmN/pvxjw2Dv04tm1zZ29RyEKoQG/3mdpWgBs2/Kprgg/0M8XgCmRjiJ1so5tDkX8FZjDyWw9gscss6EvVCaVVX7l8u771Nj/DOKTw0np9yVMtY25z3JyDJ8DDArBCCnL5jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hru+np02JJfkgaLRRMYDC7UyI4+C5LvTpxsG9EUVoEo=;
 b=kaOhKHFtTmgzkRECYfNF8A7QcqMVlKvgH2WLbBRoDQHuRIG0anyPa0GD9tP3vyNRXhsZAmgZ80nQBRsYbRhDchbalBlqf6jm7UvxUcTHY9G2X1EXv6l6/BYTG4hePLRqrl+nKJhHNemfZsp6XRxeF36eGdxNqZ1fkLk4O/FkV+O77sSf2FOPQAvbT87kOkhkKvwbBuMXFK3ZQ7Jx7fUp65m9bzy1dyhe5XPPTSQm+0vXOc3FX8kD8rrdo+VS9S+n5Ar7jjkPzBSOP9G+azeAeR0KKRIhJqC8XLCvjcwlfHJfEf9H1nrvfcYA93tnLU4o93uyMrId7wneJ5SQFjilEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5957.namprd11.prod.outlook.com (2603:10b6:510:1e0::14)
 by SA1PR11MB6735.namprd11.prod.outlook.com (2603:10b6:806:25e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Tue, 16 May
 2023 10:02:48 +0000
Received: from PH7PR11MB5957.namprd11.prod.outlook.com
 ([fe80::c190:aae6:9019:1ac8]) by PH7PR11MB5957.namprd11.prod.outlook.com
 ([fe80::c190:aae6:9019:1ac8%6]) with mapi id 15.20.6387.030; Tue, 16 May 2023
 10:02:47 +0000
Date:   Tue, 16 May 2023 17:37:42 +0800
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
Message-ID: <ZGNO5gYKOhhnslsp@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230513003600.818142-1-seanjc@google.com>
 <20230513003600.818142-4-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230513003600.818142-4-seanjc@google.com>
X-ClientProxiedBy: SG2PR01CA0192.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::21) To PH7PR11MB5957.namprd11.prod.outlook.com
 (2603:10b6:510:1e0::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5957:EE_|SA1PR11MB6735:EE_
X-MS-Office365-Filtering-Correlation-Id: f5613010-340a-4755-8fa8-08db55f4b38c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aINCX1nmUTyJPWligkw4mBkQpDPoYC2t2m6j+EJiO0zsCX1X2bbMpRUr8wZZ4lDTWaS1kyClVD5dT5mo7YDfXugR5CpI6L1GWkZXjnVIXC1TJAryfrZ/jgnyg6Eehx1xPsyVm6oSqtHunk4FYIsHNKlzj+RvEyosN2g9eSGkqEsQ2xlzTNlfr8gMmYZZVvDFFw0TBXpV0edu7O3q3tm80sQO+sVEhmgw4XiaUvTOupz3APWtdFTYebl0hB7f4UNhi33NCNZuoREyiN+V+UXD6sZ1SZ+l5eGc2EZhoFl6t9mX4ga2xbYl761SA1+fS9679oRJWowd5oEjJmxv2x4a1aueMSyyC3JrcWRTVEjhV+Bi7qmZ5Tp8cJYPodYu/eo1xsO9UcYQHBNMD/o+wE1URHg8PiREnbkydU0mVq6O5J9g5WlWskUj3bLN51YD7HaHDOhEMj9Wrns946dCC2biHxd/9VWLC1t+oOgP9LOS7ppJyRTg/zYOaU9M81ny/j9gYuNaIXR2NTOvoZCqpc1VvkzQR6SFnaWO2ttmYDOK1ls=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5957.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(346002)(136003)(376002)(39860400002)(451199021)(54906003)(316002)(478600001)(66476007)(6916009)(66946007)(66556008)(966005)(4326008)(6486002)(86362001)(15650500001)(5660300002)(8676002)(8936002)(6666004)(3450700001)(82960400001)(2906002)(41300700001)(38100700002)(6512007)(26005)(186003)(6506007)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?prfZnhYPtA6Y2yRV/GDaVNxR8UzNtSzl4Qo+NSa2OvotFhnKQqjOQbL5ZwES?=
 =?us-ascii?Q?K9qGnq8S83YZb+rAfNXNYIrU0Bam5Tvu8WbSCQcCZQI/+TIs15BUxajtNKbs?=
 =?us-ascii?Q?1iriPrM6QR6rCQgncsEz0aft8HxPyb5lhLKdyrPDk1QkcNolxzNpsFRifqv5?=
 =?us-ascii?Q?8ZTsQ/hoUXwq4Mq14xE4+dLX00FaevIibiTHX3OprSl3nNMDcGyXj2ktPKI4?=
 =?us-ascii?Q?MOzzQuWNIANwhoZ5Fvd4O1j5qCbAwHe2jwyOTvEG57eG9bllwhg7ijJu/Mmm?=
 =?us-ascii?Q?U+drwfOxhJTs6GuAqyo5qY6xJJCAw+Qpfwo/h/rxmEJhvE2ETeiQA68+/xGs?=
 =?us-ascii?Q?96U9wM/4GmuiTxqp56BnYXlcMoKD8Vhf7yatpnl+5i8DjIMXv0iLeLJVtAxX?=
 =?us-ascii?Q?Nn7/BDRZNu/YDKNAWcuHDQEPQkZwcpTrnawGAF6nI//4JpJsQKGkG68CqkIa?=
 =?us-ascii?Q?mecHOuOuMKMnvapgMEctjy5IO/NpDowulQW0UgENwS6NzhMIn4wlmTTj4ls7?=
 =?us-ascii?Q?qEtt7f4Qk7/72wmp/o9u58kMhLrrGZRL97RP40LtlQjHHKBPBsheN2gC8qYB?=
 =?us-ascii?Q?y5OiV+QYpDOuzrO//Tr6sLd/UNGixTbX+79FbjS7isoGdrl3Iez8f+kNpC9K?=
 =?us-ascii?Q?A2Fom0izZZ2YaI8nQGH4+ysR5FGw/aia14p+XgkPhjMhca5vW7qxAxB+9q9v?=
 =?us-ascii?Q?d8aXJ7IgSw/QwhKgKBiAB4hSzvtzY5qXsdKI35bg0TADCtqqPRCHUYMlRpnz?=
 =?us-ascii?Q?UZ2JlveKab/5C+AS2XKMM5PbgqoWm1uHqjbGD2H8iHUEl0dJYYeduljwhX8O?=
 =?us-ascii?Q?vVF2jBZfofqNqg8aJlNPlNGeBuHORVsBwPAFwlhKWAgtBdTTxgoFsSPMKlKb?=
 =?us-ascii?Q?CXVF6S2MvHKc1VZGWfxLyievc3hgjXzqbKWkwDAIGr9PR45a5NZm9ODKo50m?=
 =?us-ascii?Q?AsogaKAAye238NWXespOqrYsgmjFnVIcRzFHu9hN+V5O2fW/kawmfUNV7mgc?=
 =?us-ascii?Q?P46Q0XyGn6hYvZBCZ2PTX+Ph9J5Toj8h1E7I41/rvy5k8emud1BtVRFgcIp/?=
 =?us-ascii?Q?uCXkaW1+fe7Ioq3jnvCfKzqYoSx0ki9l6Ul4nJrGjOQrA96i0JcstmHsVj0G?=
 =?us-ascii?Q?zvI/p3EphVP7b8n22/pN69dXnyMSOQqZCJ18U/peqttkPyyjJp75gA1ehSVq?=
 =?us-ascii?Q?C6mbTAVSsE3dyeJkPP3oEO0g64eBxRWlWIRp45G/XJyarKrflrgAjybIaM6Q?=
 =?us-ascii?Q?QMcQWUvxY/a8jOw+3/99YEdF3RgAoG7wJILy/nFso5vyQc/Gh7c3DucQ5wx3?=
 =?us-ascii?Q?eTXCcc/+DdSAtM2l5rbSe5VIGJUDcc5VYlwBq4h3Hz+VNHcbC4DP6hNvFXrS?=
 =?us-ascii?Q?sz5NWvhUoL8LcDh8pPv0IpNCiG7XzOUtBA1tZrJjRIlTW9vKbQnwx4LhuuYr?=
 =?us-ascii?Q?29pRr4P7rdtx/P7371prZiDb9Cwov/yOGXGs91dn3tlujvW5gYSjFj4V2j5k?=
 =?us-ascii?Q?u24Imt71sf5JbM7AR0UHumgjzaUNV804agSWQu0FwcDS1xO8youOr7AB72PL?=
 =?us-ascii?Q?hGd82X8QVCp8sEkbKeLOKlPmsnpyaoIc3DOKGe0o?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f5613010-340a-4755-8fa8-08db55f4b38c
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5957.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 10:02:47.7741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i/Z9cOk3TFAdjdJnNPm09nxImOZnjk2ZxcG/emC9vvSc9k1y6CHkfTJ+qiRDjSo40BJmBhakVVKNGwhDG8pp1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6735
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

hi Sean

Do you think it's necessary to double check that struct page pointers
are also contiguous?

And do you like to also include a fix as below, which is to remove the
warning in vfio_device_container_unpin_pages() when npage is 0?

@ -169,7 +173,8 @@ static int gvt_pin_guest_page(struct intel_vgpu *vgpu, unsigned long gfn,
        *page = base_page;
        return 0;
 err:
-       gvt_unpin_guest_page(vgpu, gfn, npage * PAGE_SIZE);
+       if (npage)
+               gvt_unpin_guest_page(vgpu, gfn, npage * PAGE_SIZE);
        return ret;
 }

BTW, I've sent a separate fix for vfio_iommu_type1_pin_pages() to ensure
struct page is a valid address.
https://lore.kernel.org/lkml/20230516093007.15234-1-yan.y.zhao@intel.com/

On Fri, May 12, 2023 at 05:35:35PM -0700, Sean Christopherson wrote:
> When shadowing a GTT entry with a 2M page, verify that the pfns are
> contiguous, not just that the struct page pointers are contiguous.  The
> memory map is virtual contiguous if "CONFIG_FLATMEM=y ||
> CONFIG_SPARSEMEM_VMEMMAP=y", but not for "CONFIG_SPARSEMEM=y &&
> CONFIG_SPARSEMEM_VMEMMAP=n", so theoretically KVMGT could encounter struct
> pages that are virtually contiguous, but not physically contiguous.
> 
> In practice, this flaw is likely a non-issue as it would cause functional
> problems iff a section isn't 2M aligned _and_ is directly adjacent to
> another section with discontiguous pfns.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  drivers/gpu/drm/i915/gvt/kvmgt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index de675d799c7d..429f0f993a13 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -161,7 +161,7 @@ static int gvt_pin_guest_page(struct intel_vgpu *vgpu, unsigned long gfn,
>  
>  		if (npage == 0)
>  			base_page = cur_page;
> -		else if (base_page + npage != cur_page) {
> +		else if (page_to_pfn(base_page) + npage != page_to_pfn(cur_page)) {
>  			gvt_vgpu_err("The pages are not continuous\n");
>  			ret = -EINVAL;
>  			npage++;
> -- 
> 2.40.1.606.ga4b1b128d6-goog
> 
