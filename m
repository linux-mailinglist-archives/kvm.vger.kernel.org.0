Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 166126FD634
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 07:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbjEJFaz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 01:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjEJFax (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 01:30:53 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F1FE5E;
        Tue,  9 May 2023 22:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683696652; x=1715232652;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ONbnVjpHO3DZtfDdhzbR0+cWX3D9A8PiMxqAWEdISgI=;
  b=Ec7CtnmcaKKStkSK+d3UP37Qlvyv+tcTdG2Z0EcKDVyynolXykqxqT5g
   scxGoMNSJEzIp1v89HjVFugMij6A0E+pNRmWm6xvUS9Svq+96VsEC83m6
   hU/XpbolCtw4M+kQIgWmuuqywDHE5uTjjj+eTSgddjvHTIK1Ut4QiDuuD
   +fTpvLKT3suo0VddJkbh/eX/Z1Ieg99pW/DoczY3QK+Wi8NesfrgJ9O/C
   3jT5+D/yV3mhYUO4UIHBVgqOjBBJxlbPz2iZDlW2Il0F1yAH2I4NHGPLC
   EIGCNXBnzTDDNvzpPfik4wjNZWA+1FT4+3uvL5Ekh7vrFP1aj8fw2PwFD
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="413421460"
X-IronPort-AV: E=Sophos;i="5.99,263,1677571200"; 
   d="scan'208";a="413421460"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 22:30:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="811000936"
X-IronPort-AV: E=Sophos;i="5.99,263,1677571200"; 
   d="scan'208";a="811000936"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 09 May 2023 22:30:51 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 22:30:51 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 22:30:50 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 9 May 2023 22:30:50 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 9 May 2023 22:30:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lfgicZK0kc2tq8BVFAJ/diGP0c3k8zmxRFyg9ifeM8qjCOVNQHevk99i5Q7O8FYvSfTH20jmejv2tDrR9m/4X/wC2fvi9Fx3WwYfvYRqJVv60O3w2PLEa5mMVJPiiXmVMCyONy8errwoDztRGe0NN1WJ0N/oqKwxWxB4LtJMZ4heiOkxEvv820YLxGXM4sMXknyCZQ1tz8qmy5WbfHr1Ly04RjoYAjhuWJlC4B71nsoPdJBASZZNFPkke0NuC0Zafcn1UOVp34PYQa0ze4230gIm1uaWJaUhmiMudDnm+0RKS056rFqsuczz87tn6GDf9WA+ScQrq2DppvEvvDSn6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p9BpgFzw/quBTzY7V9meaBk1j4jTAtviib68Oh2J/OI=;
 b=SIv1Vq5+uyf7K324psCRdrfdci2RfAXaCNT5S4FfVdyzYsZwxluyCI0AjkZ5LILnQDlC66YLjR8t6HgKcX+QZOxaO406VWD8CFv/LqhhByS7t3O2NaZ7Hp9icUOVVsZ5STW2aK28ihIWd47m22gDrgeQrWh5DCSo5y9TK5Z0xH4XDEAaOeeSXXrIyROcs4tAW3FJt+rUHY0DZ3DFZxZCy57kzjqRRJdTh+dpDnlK/Qc+dtaHALXdIGLZ/5+2ARKnkZSrVhu5tbygsoxkhPcyekH3k+2UFKLHxJBDnOgs0xVfiQhw+JLl/4V9t/V9CoGAtu/fDy9/lSpxxbZDWrnGMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by CY8PR11MB6868.namprd11.prod.outlook.com (2603:10b6:930:5c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18; Wed, 10 May
 2023 05:30:47 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%9]) with mapi id 15.20.6363.031; Wed, 10 May 2023
 05:30:40 +0000
Date:   Wed, 10 May 2023 13:30:29 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>
Subject: Re: [PATCH v2 1/6] KVM: x86/mmu: add a new mmu zap helper to
 indicate memtype changes
Message-ID: <ZFsr9TynkA/CyPgg@chao-email>
References: <20230509134825.1523-1-yan.y.zhao@intel.com>
 <20230509135006.1604-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230509135006.1604-1-yan.y.zhao@intel.com>
X-ClientProxiedBy: SG2PR04CA0161.apcprd04.prod.outlook.com (2603:1096:4::23)
 To PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|CY8PR11MB6868:EE_
X-MS-Office365-Filtering-Correlation-Id: 458d9cee-2673-4086-f05e-08db5117b0b2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3S5Fmoniqd9GjmZeSwu0alKctHDGvs8wpzXW8aP7xKgv75TW9n3d5nYYnBY2NNzTSE8LrgmoeDrvDuzAzxadcQvMLjHC14llwUVnf5kRXoiEVtqzfny2CRjibN7osLDGBo9T/e8ZxS8swAeyko3JNwZAIt1QB/phYOaETrsI8bWq1qVWef+O+86jdINQhU/H73nyLOYQkpGnxr/75GTOi0HDqh1GMzXrhhPgsDLwqV9NIRRiVsy9X4qmpqsFArkZJqenGna8utNn/XiFA6aKDTeQDe39wm0WqYLzU6CoC7eXfEIJmYVwfjNwMld7aXM2VvXxoZ5gxPt0ZqkyGXQVZU9K0lM8d/sCdrKX0XnY969XmmgBWLvZorbvUsjZ6HT10NGW0I9W8ant6InUAVneRab7y8hkuqzMuXCDJTpcSN/UsMNhPyTosH7cELavvnr+5NKvSidv21ozgXNVfMIQY+V4HaVlbV16vrJ7ooEJ/UCgBXV3WdLTH8Tm9Uh4iz55r5GyRYWbm+66c3ArCtJvpg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(346002)(136003)(376002)(39860400002)(366004)(451199021)(66946007)(33716001)(66476007)(6666004)(6486002)(66556008)(6636002)(4326008)(316002)(26005)(2906002)(41300700001)(6862004)(8936002)(8676002)(6506007)(9686003)(6512007)(186003)(44832011)(5660300002)(86362001)(84970400001)(38100700002)(82960400001)(478600001)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C8Vsf/w0kt4Im3sUHRaEEEQiORW6xXNTGvdDCxGo2MfU8ID6+prT2j/UW1m1?=
 =?us-ascii?Q?dIeHgxKt0dZArYUJK7LmKTeHtKbrTRC+7oOg+vf32hfyMEulR2O3WDi7ODZ5?=
 =?us-ascii?Q?ZyOGhVfMAIUZjvaCeFrzSuhEnO5l/fm6kyhe6z7nG6Rf/FfPBSVlNJOYq3bZ?=
 =?us-ascii?Q?SBItCO5x/YuLvRVNw0e/QIDSdPU5mGYaVrbzH8ORrCWcDikEdINgeHn6Kg7W?=
 =?us-ascii?Q?/MVz2+xia8p+A5WsheoplWDw4ElTfp/lRP6LFObLI8qbOpivGfFHn9gPEy8t?=
 =?us-ascii?Q?hOW6Qd/wY+rCfYhK8CyOg+kyBlf8CVvzkoFKJuHmUwWrrgmIZU6exuaIzIQ/?=
 =?us-ascii?Q?pCqLPFjAv5AK7+hYAvXXk4OpXuWcqWsxd2WIaKsn27FDHkrV1ED9747SW1zq?=
 =?us-ascii?Q?XyFwIITf918zCmomOoOgKQLoFmBmWa+0o/kxV/rGhp17KDoK1xB7zoXT2PxI?=
 =?us-ascii?Q?ezgPHMOWFRELmnG8AEqA5++mo77bhwNl0OpHtxQvEZgb283e04iQhGmDBxSA?=
 =?us-ascii?Q?OQOl9hlJRJcWunfX+NPTtaxdZ3WYRCVuQTf2nx1mT9qM4dO/51BTzfgj5Cci?=
 =?us-ascii?Q?lXZrQu8abfNrpanNakAGQ3WsNRAMrm+Q/jMROHr/xLBxMokQcKzRrLqK91A+?=
 =?us-ascii?Q?5GWLTE0AhnxuVdC/+mipGTi+djT3dUlLmVzOdr6yGarwh6KWXuPWQbjMuSu0?=
 =?us-ascii?Q?lZ4AuUhtsw6pcJ2gt2GsjYH45zVx3m+YKqFHwR3WRlxZYWNu0tD1oRlz//ic?=
 =?us-ascii?Q?DQoXhfPjywwjgiT4AS963orRyeBMq51sFMO+GEtXIRbVjoAz1c0TPV3pHGBA?=
 =?us-ascii?Q?Q7xJZGOoTqbsBKnHM0uClZZVdaxqALAwXRgybFVbXYBOOXvvB0PWqbl5Q8wT?=
 =?us-ascii?Q?OAuv5DMmVol0JMuMtI9m+ujMi+aIZJkRK5m8UcJqBiW1p2Md0GaoIDOQozK5?=
 =?us-ascii?Q?cKc5vHhrPxLmwnpdtkUFpQYDmSesyUwa1gBruI6N7xzVw74iC+jPJrY2rQHV?=
 =?us-ascii?Q?/In/oUxvJkHS/WGmxsX3IW8Pgg6JW2W75G+MEuK5XNSZCkEDpF7QozRRtuZZ?=
 =?us-ascii?Q?rG4/5lC8rNHINLRzmJFbeStgOumc2jI2ABiTNRYIc0YGdHhT64KJrRfFViMK?=
 =?us-ascii?Q?fEH74H4w9BM9Cj31DZVirhnWTaC/eWWjOaBT/lKlzQEXEr6ZpOOooSOyTm6k?=
 =?us-ascii?Q?/0yO8beUjZjmT6v3OYtTYNAre/YXS7lYX/paKpnQwTQSYEAutmrvUNIoRpdQ?=
 =?us-ascii?Q?rrk+7bxe4J0xBxfIK5Td8z3qCw9h2iYZdYgAcP/S/e1qIpfMio/HBHmwYaf9?=
 =?us-ascii?Q?tsAgBOwyGs2vwT0WLa6mbI/n/fa3ysibVH+Hp6vwy9FnpQey7x2lsUf1xBhS?=
 =?us-ascii?Q?8Ie3d5aLlvAr1cKXKxCIlyL8DjNoOqScN/WaBYaecxoi1hoGZ3URJkrqkmnl?=
 =?us-ascii?Q?MMqMWxn7pCqO350NjFEpyvAWh5owqgTU/sWlSmffZYZqX8GPpdA4R3yvyhJA?=
 =?us-ascii?Q?huYn/XNT3fT90vf9UBIL+r6Wvt5XmIBqf0Bk+98CpZQ6Fm9+XUtKZmf+b3h/?=
 =?us-ascii?Q?qY42ptoW0jyqZMpMJ28RbWnBOSZNcwhwKu6vz475?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 458d9cee-2673-4086-f05e-08db5117b0b2
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 05:30:39.7520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zkiP6kcZcQN0JNNdCIwW5HSuiFVUmKjjvxoS+bwXHIY3OtPCjT1v5E8gOeVbZpdhkknqFA9Y1zS8KsOPOvfRhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6868
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

On Tue, May 09, 2023 at 09:50:06PM +0800, Yan Zhao wrote:
>Add a helper to indicate that the kvm_zap_gfn_range() request is to update
>memory type.
>
>Then the zap can be avoided in cases:
>1. TDP is not enabled.
>2. EPT is not enabled.
>
>This is because only memory type of EPT leaf entries are subjected to
>change when noncoherent DMA/guest CR0.CD/guest MTRR settings change.
>
>Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
>---
> arch/x86/kvm/mmu.h     |  1 +
> arch/x86/kvm/mmu/mmu.c | 16 ++++++++++++++++
> 2 files changed, 17 insertions(+)
>
>diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
>index 92d5a1924fc1..a04577afbc71 100644
>--- a/arch/x86/kvm/mmu.h
>+++ b/arch/x86/kvm/mmu.h
>@@ -236,6 +236,7 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> }
> 
> void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
>+void kvm_zap_gfn_for_memtype(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
> 
> int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
> 
>diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>index c8961f45e3b1..2706754794d1 100644
>--- a/arch/x86/kvm/mmu/mmu.c
>+++ b/arch/x86/kvm/mmu/mmu.c
>@@ -6272,6 +6272,22 @@ static bool kvm_rmap_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_e
> 	return flush;
> }
> 
>+/*
>+ * Invalidate (zap) TDP SPTEs that cover GFNs from gfn_start and up to gfn_end
>+ * (not including it) for reason of memory type being updated.
>+ */
>+void kvm_zap_gfn_for_memtype(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
>+{
>+	/* Currently only memory type of EPT leaf entries are affected by
>+	 * guest CR0.CD and guest MTRR.
>+	 * So skip invalidation (zap) in other cases
>+	 */
>+	if (!shadow_memtype_mask)

Do you need to check kvm_arch_has_noncoherent_dma()? if yes, maybe just extract
the first if() statement and its associated comment from kvm_tdp_page_fault()?

>+		return;
>+
>+	kvm_zap_gfn_range(kvm, gpa_to_gfn(0), gpa_to_gfn(~0ULL));

This should be:

	kvm_zap_gfn_range(kvm, start, end);

>+}
>+
> /*
>  * Invalidate (zap) SPTEs that cover GFNs from gfn_start and up to gfn_end
>  * (not including it)
>-- 
>2.17.1
>
