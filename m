Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABF626BE0EA
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 07:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbjCQGCH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 02:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjCQGCF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 02:02:05 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D207739CCE;
        Thu, 16 Mar 2023 23:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679032924; x=1710568924;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=9uJ3MkfA/qwcgaYzN5ANURWlB8iYIiA//moMDgAR3Aw=;
  b=n7Iq5X0IOC/rj4tOuf+fTshepASYujGNG2KkjpvtYoXOLAFB3deECJzV
   674iqGZ5c74PFb+j8h0tb9c+GKhdNWbdCtqf+6U1VO0MUkBu0K81Sk+CS
   FlceBlemofWWrC+UW4lsZy6/Hlz8r8Jy2iOSin2yrYvwZBLcJtSSaUfZA
   tXOQjUxlzyXvA7Cb2HWex7PiTP/y2cS2P9Uv3iXsiDzg0LNsyRD0OLx1I
   wrjsoPH7sXZIyvCfmdXoyPLACBUZzZuU6m7HPNjzDo0mxTX8tVnOp0U7V
   fwmpHcquq4jY/z1Lf+1eXERYkLWg4Jhr9dGXGV0Rryk7SFt5kEkqNyHhi
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="326551211"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="326551211"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 23:02:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="710396322"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="710396322"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP; 16 Mar 2023 23:02:03 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 23:02:03 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 23:02:03 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 23:02:03 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 23:02:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kb5TS4ntLdlqsIw1899bTdtKjeKPX3QOl2cucj6wsmBg0iZnFIVuOuHUm50KKVpUZcNK4otrvCJwkEgn3qD49InwkMo20VxM33P6b0rf3P3XlDrgg3fHseNGX3PQJ4qnboBCsPRwOL7OZ2yUpVnT/4/8rMuS1n9owhFdbcbziWq3xYUlLunD7CWSuEiQ4BUnRIqGEFiQJpk3sNBdnCVrAwRazXpMSGome7M2BMAffy2hmzZf9t1FuqNpwQAD7SjKu6HqUMjJDuHj7ptdjNZoVVAYf14GDambykb0XdcP+eFoasWrL5biXDppoOa8zc30kNjFWkddCXt5OXgmwh6ZBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NbF2lqX7uO8xlAIvD+rHKCfsIVsO+17heK2Dll2MBik=;
 b=FPPY1mhUoBHnbdnMVBes5sJT5oPt98FOwY+/ZeIFGrLHmRah+tY/h3biBqTlqlIaBV/HXychGvzvasIWdXLzUZh27w+ZGqz6e7tV85NNKXtt130zJV/VMSDGUQKU2Gl7ZT1fMgg0s2iZ1vAGPEsHCMCd51PKARnJ+37eB91nt9FfyQjJ5Q/ooAuXfG0JQyua9gakZQuXUqdpv+ruba0qTbX7LfaQztupw7GWIOSSAg4c5sTLpdEmDxnWnukpbt7bgY1UZHLdSXG25rGEVLbVUfQ2bWXD5KkmB2fL+sa2qok8inoJZlEi9x5Rkws7wu/TNftyIM+QXKkg+dwhTs5CYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 06:01:58 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e%4]) with mapi id 15.20.6178.026; Fri, 17 Mar 2023
 06:01:59 +0000
Date:   Fri, 17 Mar 2023 13:37:21 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 07/27] drm/i915/gvt: Don't rely on KVM's gfn_to_pfn()
 to query possible 2M GTT
Message-ID: <ZBP8kd+4+HjdekPZ@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230311002258.852397-1-seanjc@google.com>
 <20230311002258.852397-8-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230311002258.852397-8-seanjc@google.com>
X-ClientProxiedBy: SG2P153CA0001.APCP153.PROD.OUTLOOK.COM (2603:1096::11) To
 DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|BL1PR11MB5271:EE_
X-MS-Office365-Filtering-Correlation-Id: e412e039-f46d-46b4-abfa-08db26ad1ea9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sJiuyUAvbCDldKNS3My6nyo6h3rGPKwpnRPENeHcp3yq/o6ks/rV+kLaYBf+qHPETwpzvPy4TyreFTkRc1Glp0AWObh1ic5xSLQQbAF1zuoBMI1rlZ6twCt0pnOx20+K5jTp+7bwFrCi/OT4H/gPwy/SBXr4rtaKyVjTJef3FWa2gXGbm88KSM9SdPBJ1D9c6ztgvx7TXqUfkjfFUrZB+tUCxVxXvAdcBFIkwHCgClP+ZhqVD+rQBfrkh210MyEupqexSBFS6Du+X2IBrj2Yk0JARREfqhuDmlb1d7Jul7bqNIHQLw015vs/ApVJzMgCF/4fY4Voptek83TfLyxIgNZhSekC69jljHPV2xVfb2ksDF5OVi60IRKAxT+jtPtxYC8pcjlaGtQT4kG0sR7YbUKYzExE+R4cYnNSvKgw2QnYms3W+gTxctn+/P4exoASXcngYDRcDdnC/5I1iLFH4cao3wio3gXRSjuiryuHq3xcAKdNWfRV6YqzI4+FHHX476JYwyATUO1c3fD+kjDwZuk/1jHQHmPA4nLkE9FRiyp3R5Ihyk0aP32mZyDqb9CJUQk9V43qD5FgZGkdqYzbVrdYjIUvnoRjLDAJGRYdKkdIrEEcFZ2skv4znsl+MDVLVRArCZ6gCyhU/VaSmv/rQA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(136003)(396003)(346002)(39860400002)(451199018)(3450700001)(8936002)(2906002)(5660300002)(38100700002)(82960400001)(86362001)(186003)(6512007)(6506007)(26005)(6666004)(54906003)(316002)(478600001)(41300700001)(6916009)(4326008)(6486002)(66946007)(66556008)(8676002)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nmfQzzflTY5dvvJDGWttAaarotu+A2CjnJbJOj1/Uku+qPdzijuYHjD2FjZt?=
 =?us-ascii?Q?DGdtkw5tfjzp91nAuUs3l90fTmCTWsQxcTjbMwGO92o5yVPa9OBdXR2m19vq?=
 =?us-ascii?Q?UiI69ofM6/U50oGBcdDB+CBk2kLp0kwTlKf66vFNafynyE6oVxJHmf0Ysqi8?=
 =?us-ascii?Q?Z6Qb9qeQvn2KBWh6JWtWvIQ0m0PYBx+oAb3rnrSd3VXtn4LMmWKYxzcwuXOK?=
 =?us-ascii?Q?JxmhUBoBxUOrnubCmoz2EylH6d8Ph6cCl8c7TPabyP+ldI8kpFAih3E1BMPa?=
 =?us-ascii?Q?c4edkqIWwYYk2VcQ3QQo0vJJUQlY68uLHoG4k5jQWF5Q3U9yUMLM9TJ3Nba1?=
 =?us-ascii?Q?MQxPyc274diUw07qx58gDatCAio0PPi+5LJOuNeh75E8uSSHFOBngkawb8Hl?=
 =?us-ascii?Q?ro2A0q3FAWH4SA0sj6uldJRyeB3l3bUy/tdaC2PbQmQst/8mc33qukthdXyQ?=
 =?us-ascii?Q?C1/JjfhURGyVYaJ2kJ9Kn0280xj5noEqJKxoNCCF9lnDLORdkS3L5ya8a5ys?=
 =?us-ascii?Q?8FAUGMU44PHqj/6C6p2WZ1T0/Im29zqbKavm3nNa5pofut0W5HvL68PE55+V?=
 =?us-ascii?Q?lEzSx7k7UOkMXYwWORgL3IAKKtrE2ZHUp9bl/0kHm3ncGvfl0tA85vwKbh6z?=
 =?us-ascii?Q?YjW0DlFMXwhgJfh9i67lpRtRUP+7r1kxP5f5TkfyeuUH7d8I4kLwNXsASUnI?=
 =?us-ascii?Q?LJLbn0o/o2w1toYTWcH4Wt0miCLhT6fQC4JEdGkqJ+50klbYPN2Y/uhoeXvm?=
 =?us-ascii?Q?7bek56S9Y6X/5vmX2aOdaw2W3MPXRnEg8WR0H7C4xhtxidrPx/zhDPteW6+b?=
 =?us-ascii?Q?Dlsfei5VtwYD+Rbpr/Iaz94gLhPq4d0/yD2cF4MXVaf3iik7LkNJd2uhV9Pl?=
 =?us-ascii?Q?B8iiG67PQlnx+iX/4tK4kkWbACgbcCHMpB0sqDaTSiyoAHbchqa3RsQFiDmF?=
 =?us-ascii?Q?y3LFd+gb4HQhKDghPnzdSUSqS//lU6WQcizsvWtfABsVYw6omo4l3PrqQCVu?=
 =?us-ascii?Q?x2VBoLPEm8p/csDI77WQ8FCJopREzxxs7frhw9u+1KXiI6c1JShZcsUFsjSF?=
 =?us-ascii?Q?Yuubktin9rvG+wDv02PT3eVWbYaEundFxUZZDBQY/a5hWuF5T5+RB9JCXdsT?=
 =?us-ascii?Q?C/pumyT0Ty43uHtUde+h9vq78CsZnmVbdDy5btaPgZOEHJH9r13gE4x/vF0F?=
 =?us-ascii?Q?st0zg2go32muFA7szT4wQs84xeSh9aNfXT52Kv/cJeVk7phtFMN+t4m7Mpgn?=
 =?us-ascii?Q?iyCPHGCOClNDx4K1wZuRhhgBI+ZIbP7M+nafUFg9E6/E6tHHCTngEhnntcCV?=
 =?us-ascii?Q?a2eLM0YFIULeVMFv0WEypqc0TQ6W/gw7uhl3+nPzuTFT7iFqdQiBnovs22U6?=
 =?us-ascii?Q?Mlj/bjh+2V+nfthQOUTcJaMeHfv1oQOvxf0pRAd4YM6g9uEtShUzpWZJrzTH?=
 =?us-ascii?Q?jX+s1bCUTc9rPWmZD52Tjir5vFGGxVwUlmrvQKdWUmcH6j2iHI1SyejHy6Pu?=
 =?us-ascii?Q?wLyU7IcG0QI/16rd9EmLH2wziz7vq/Nmgl3Gq/84MrxprfFEX7dIr45dVazK?=
 =?us-ascii?Q?uGetooX5kY3yTWe2qFhgps+ge4WmaqbPIQshr21tZdaz2VCRcKDVYDDYv92i?=
 =?us-ascii?Q?xg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e412e039-f46d-46b4-abfa-08db26ad1ea9
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 06:01:59.0878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DGGHkXlG3ZfK7UYQuvXbi5mmsU71oOnIr+vU8DDq3aRHS9ljQ0WkDuzNzFqigXDxyNzcazFK5EybTA5LTCJpyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5271
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

On Fri, Mar 10, 2023 at 04:22:38PM -0800, Sean Christopherson wrote:
>  /*
> - * Check if can do 2M page
> + * Try to map a 2M gtt entry.
>   * @vgpu: target vgpu
>   * @entry: target pfn's gtt entry
>   *
> - * Return 1 if 2MB huge gtt shadowing is possible, 0 if miscondition,
> - * negative if found err.
> + * Return 1 if 2MB huge gtt shadow was creation, 0 if the entry needs to be
> + * split, negative if found err.
>   */
> -static int is_2MB_gtt_possible(struct intel_vgpu *vgpu,
> -	struct intel_gvt_gtt_entry *entry)
> +static int try_map_2MB_gtt_entry(struct intel_vgpu *vgpu,
> +	struct intel_gvt_gtt_entry *entry, dma_addr_t *dma_addr)
>  {
>  	const struct intel_gvt_gtt_pte_ops *ops = vgpu->gvt->gtt.pte_ops;
>  	unsigned long gfn = ops->get_pfn(entry);
> -	kvm_pfn_t pfn;
>  	int max_level;
> -	int ret;
>  
>  	if (!HAS_PAGE_SIZES(vgpu->gvt->gt->i915, I915_GTT_PAGE_SIZE_2M))
>  		return 0;
> @@ -1173,16 +1171,7 @@ static int is_2MB_gtt_possible(struct intel_vgpu *vgpu,
>  	if (max_level < PG_LEVEL_2M)
>  		return 0;
>  
> -	pfn = gfn_to_pfn(vgpu->vfio_device.kvm, gfn);
> -	if (is_error_noslot_pfn(pfn))
> -		return -EINVAL;
> -
> -	if (!pfn_valid(pfn))
> -		return -EINVAL;
> -
> -	ret = PageTransHuge(pfn_to_page(pfn));
> -	kvm_release_pfn_clean(pfn);
> -	return ret;
> +	return intel_gvt_dma_map_guest_page(vgpu, gfn, I915_GTT_PAGE_SIZE_2M, dma_addr);
intel_gvt_dma_map_guest_page() returns 0 on success, which is not in
consistent with the expected return value of this function, i.e.
"
Return 1 if 2MB huge gtt shadow was creation, 0 if the entry needs to be
split, negative if found err.
"
