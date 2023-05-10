Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C06566FD933
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 10:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236420AbjEJIZu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 04:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236168AbjEJIZr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 04:25:47 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E363A80;
        Wed, 10 May 2023 01:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683707146; x=1715243146;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=P09r8omtz7vXlmQpweYTDFzucqBctPB77Qe1JZW9+/0=;
  b=d4XVYwKt4hyHxMLUr9y6LY1ULTW4rz9KEiA39o6oWBY8+nuUxXqEb+u+
   Bte/qfQCAhOLQlRSk2wfjvHHn/WZtP2SFiKu0wvQjUogN6ORN1wwu8wQF
   UwbdjbhaMqtukYh+dBg/gva2s1UjGWDJEkHbiQ4z3PmCMjNijnfBohpAl
   WT93mpKyt0YJz5wZBZxvi0/0cgiyV9TH8dPvUmkEy4iq0ilDhHmv0vbio
   Rxtn0edslygYgYhzy57/Qf7MjIcZ88uLqPGMjhU3F2nj8ECsxGYyLQDpp
   7wl8iT23k5SQCPNbV4T0krFwUlferfHfePJqvmhGdxCa5Ak5zQCQHPKN/
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="378256258"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="378256258"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 01:25:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="764203633"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="764203633"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 10 May 2023 01:25:45 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 01:25:45 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 01:25:45 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 10 May 2023 01:25:45 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 10 May 2023 01:25:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hv3vR2mg1qPYeMXn7cLjYiRPjkiPzbslPc+RPkSgQXSdXWbU5qwS87tooTdBitjmzDbJTs4LB9gEm3ofPpA3Oeb7DEWfkIs7z1Mi3rX3X7+uX69LYy41th44c3GPkkZ5KcIRl/OcB4pnkwIdHZytvQ9dcmxrsyhgRZa15teBB3J1uhp0CTuTydbdZb3qq9ezR1amTaNB3/EAiO0LWAFca83cvQL1NsZfTH98v8JxIe0Nfkhx3ywHIRAF4oHLOLr+99U/Gh72QxLBnM/DUj/TRvJSDZ4S+RRJ8l1fQwCjcnWIp8eWmIZEktshqobfeVJVyUB7fZ6zlUyPXuC1vsqmdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G88pypF35IN3l680Mov6+utKdLUAptX8jzKEomP/XNc=;
 b=WSan35jWXxVkO0cURAK9BigsmlrDLc6DApdd4EtEb5eFpQrXuFsEMAPPf4BIlg9giblKueI78O0RPVgzMEwkLagCFk9VG+83jGPHtnlKGcOU9vSGb7Cj51I28XMMjMoRCk5VlDGcjEz1vK7ywGWS8yaOoFM7hyeExJfPJA5jG5U2Ij2QsxFH8JXqYx/qHBQJVe1+WWPFso/Uv1buoGgJnPVcRvig8eKZSqY0UesoL7G6XC2lRgLTAD+oQTY2K356x/7CUsRnmxQIBHi3ErfypjrLZXKwjeF2ABlqMbPs2HfXkZLG8FuQeFAt6xPYeVhMWKcue1st3gu86bwT2AwOxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH0PR11MB4776.namprd11.prod.outlook.com (2603:10b6:510:30::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.32; Wed, 10 May 2023 08:25:42 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4%6]) with mapi id 15.20.6363.032; Wed, 10 May 2023
 08:25:42 +0000
Date:   Wed, 10 May 2023 16:00:40 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Chao Gao <chao.gao@intel.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>
Subject: Re: [PATCH v2 3/6] KVM: x86/mmu: only zap EPT when guest MTRR changes
Message-ID: <ZFtPKLvblLcxPvZQ@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230509134825.1523-1-yan.y.zhao@intel.com>
 <20230509135143.1721-1-yan.y.zhao@intel.com>
 <ZFsuDWwoKRA0W2/j@chao-email>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZFsuDWwoKRA0W2/j@chao-email>
X-ClientProxiedBy: SG2PR04CA0194.apcprd04.prod.outlook.com
 (2603:1096:4:14::32) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH0PR11MB4776:EE_
X-MS-Office365-Filtering-Correlation-Id: cffbc9a8-1951-4305-4d99-08db5130250f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BFy5JILFFS/dPaW9Snj1U8iX2DSl/plL0YWOKk+qQFZe7ZC7gcKodtvwVhfU9EdwqYnCSIpZW20XBI+t6T9Ez8ac8KBaDOoQfjx7fOKB74CWqmqsQqvOj1fvKDQ+UoejJjKiMOIj2+u1dU9uoQO7UL5LpNGSVZGpeNVttevQOHtRLJBTk4jm/zmaRlxUIYnKgweik21vO7bSImPaH8DMLHQCzqTJSbyZGBLSXDxhHDQmG4HbgRa0d/rvdOFtE05Khda6fbYWxwFrHHujaiZln9V01KXG111XpUSK7cpK/COw4JQFZ5ez7G6q6/RvMseoN3HVX1xzLy2+39R1kcW9M5F21jrs+qPnoqE2GovCchy/nK8VjBMOgIgHCai4pJGcWVwxKAxMe3FB/7SPi82S8J9EZlL8kb3psQ1lNGLNmqQcQ85wR3p8nYoelvBGaTUDynIbPsKKeQ1sa01cbLnFC/81pm2ygzvndjZQypNhmGaSz3Zldp8HI44GifusDHccUAgaqEQqzGj+nCgx1bj/OWvoJ9dhMets1fcrR70S4kuIP2T3PkWbimLpc721mnLS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(396003)(366004)(376002)(346002)(451199021)(86362001)(316002)(66556008)(6636002)(478600001)(4326008)(66476007)(66946007)(6486002)(3450700001)(5660300002)(6862004)(8676002)(8936002)(41300700001)(2906002)(82960400001)(186003)(38100700002)(26005)(6512007)(6506007)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jkA79BZ89d4o3iYlc67I1/4u+SgJtXa4TZfaGGw1b9qB/ONAtzOztbYIdJ5g?=
 =?us-ascii?Q?m4BNPuMGxXjG0BtAiVybmUGD4Tn4Cysffr2liG4RRMT485j0ic2zMqRzhD4f?=
 =?us-ascii?Q?uPmOJ3wVkfV7pauq3Lt716mu7hPRI4sxD7bEk6YEjlMKuO9r1MqDJZyB7Ah8?=
 =?us-ascii?Q?L9I7Gyz7cNOgF/OBDU4R/KLoy9PTWW+ymWaBcsy1Z4D8Jy2D6gjvfCXp+dYq?=
 =?us-ascii?Q?9Cyne6c5T2vGitgqy1mWKCwQL/s4GHhtGAL5ja66qERvuwBoZjtceL7VeHzU?=
 =?us-ascii?Q?0d1Rd9AcmfpoeK4zNFsB5tMxDvhL4PJLmFUzJVKPr+UM/wkhr3xP6avioL8U?=
 =?us-ascii?Q?B2htWiCdXTkr0XnL6sP1538xcn9hdjOfqECShLH3ppHymdgu1Rxb30B0WAjQ?=
 =?us-ascii?Q?0IPxV1wFxHupSlo+3Xh4m1irDqrEBiltWDkywLwzZcynmpQcxnZUjbWF/cjN?=
 =?us-ascii?Q?0ElC3h6W3nAqo3xfN0p4Iy77I/+6Fyz9RbGtV2GlUWqEokCegjggjkglng0/?=
 =?us-ascii?Q?05Y/WrAoc3HbNezpDbN2WBmHchaZm4YA6stigMmF/P/pLrASQKaDbYCeH1FO?=
 =?us-ascii?Q?jBosFFf6We3afISxwLi/5l/HISl8iTzc1TU/XpmOUcY81Z88ZnqUA9xuXQ81?=
 =?us-ascii?Q?wUIAvRb2wJz6H2GGNcnJGvciCi3U9cFNq5j2zigThySrBoktu9xktFWL88Wi?=
 =?us-ascii?Q?l8aFsE4PyGkbprjTSCgSKYKr5AJSX/yvRl2sc5L0EmRXT9GG5quvE8RqqoPf?=
 =?us-ascii?Q?pvJmUEYAWT0MZ6oQ2/K6iFN3Dy9/9fMQtayxIXVgME6P/u0GtWgws+YgSjyD?=
 =?us-ascii?Q?fXKSIb4qmAfFWHpmpNsGLIHV9V/7nARpifDdhuqtH8ko4nMYglxtgh2OiCyj?=
 =?us-ascii?Q?PDAJ7qpBG1xShRV6nZlUMfF9SSQYS1CjmNXhs/IKF47j2jfz/MIzPAnd4ONZ?=
 =?us-ascii?Q?tvUbngQ7nxyhA4QZ+FYPaSdBuHCu/4AboTOVHrnJ5Vjf+WGfdCS4IQHgnA9y?=
 =?us-ascii?Q?Vl/BjSADz1Fud01Jb1JTtWopV9W/mYxfvrGPwuPg3fH4LihjGvsWUO2cP06G?=
 =?us-ascii?Q?PFhBvui5BuQin4HZs4P4nhJqGGhuII89BY3e8KcRlgIOReCDufeTBXfbqGW/?=
 =?us-ascii?Q?ka6hOp7iz3aSgKKJy20iJcO034MotEs+71FBvGPUulDkuMhkIB6OnQp62x4z?=
 =?us-ascii?Q?8q+mWrpfp0ALLxo4c5sudqTO0XBmkoZoVzmMvIHfTmCRk8jsOWRVsq9aAeQN?=
 =?us-ascii?Q?vHyymOSKPwY7N8Hlc2U2XBkVjtz6cHO0a8uJQwqMUZBhqO6CHmDZoTrCxct/?=
 =?us-ascii?Q?/5B0LNPdDHsN9lSX5TY+5rtCDIc7/k3o/re45B4kx+t6EN3W5dB/ECy8UavU?=
 =?us-ascii?Q?OWY+uqzbj8FuESRAX8F8kACpShECefSMfTlkJ/yEb5cClS9tAFRISLQtU00W?=
 =?us-ascii?Q?FMGfYDD7+3JEoBDtuhNM85G4da7c0V6Tt0Gc3MnTsDEWdlbwu0+oTHpJSPd/?=
 =?us-ascii?Q?EVMk0TMI1UO7q6Uk/h7d82s3HC3KI6CblR0lJtS4pyeXNGu6yrHeZTVV/2fY?=
 =?us-ascii?Q?er1yGseFvqdmE3yvOKxDtN4lBtbNO3GBe+hT6KXI?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cffbc9a8-1951-4305-4d99-08db5130250f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 08:25:42.6736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qEPrtJKcdH/aog0Zjfkmo0lbAfv44cKGyxkMWkCbycEQzmqhdltotQF6x0Dn7nIGF5WWNloBHnHHABIwlM3uXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4776
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 10, 2023 at 01:39:25PM +0800, Chao Gao wrote:
> On Tue, May 09, 2023 at 09:51:43PM +0800, Yan Zhao wrote:
> >Call new helper kvm_zap_gfn_for_memtype() to skip zap mmu if EPT is not
> >enabled.
> >
> >When guest MTRR changes and it's desired to zap TDP entries to remove
> >stale mappings, only do it when EPT is enabled, because only memory type
> >of EPT leaf is affected by guest MTRR with noncoherent DMA present.
> >
> >Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> >---
> > arch/x86/kvm/mtrr.c | 2 +-
> > 1 file changed, 1 insertion(+), 1 deletion(-)
> >
> >diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
> >index 9fac1ec03463..62ebb9978156 100644
> >--- a/arch/x86/kvm/mtrr.c
> >+++ b/arch/x86/kvm/mtrr.c
> >@@ -330,7 +330,7 @@ static void update_mtrr(struct kvm_vcpu *vcpu, u32 msr)
> > 		var_mtrr_range(&mtrr_state->var_ranges[index], &start, &end);
> > 	}
> > 
> >-	kvm_zap_gfn_range(vcpu->kvm, gpa_to_gfn(start), gpa_to_gfn(end));
> >+	kvm_zap_gfn_for_memtype(vcpu->kvm, gpa_to_gfn(start), gpa_to_gfn(end));
> 
> I am wondering if the check of shadow_memtype_mask (now inside the
> kvm_zap_gfn_for_memtype()) should be moved to the beginning of update_mtrr().
> Because if EPT isn't enabled, computing @start/@end is useless and can be
> skipped.

No, shadow_memtype_mask is not accessible in mtrr.c.
It's better to confine it in mmu related files, e.g. mmu/mmu.c,
mmu/spte.c

> 
> > }
> > 
> > static bool var_mtrr_range_is_valid(struct kvm_mtrr_range *range)
> >-- 
> >2.17.1
> >
