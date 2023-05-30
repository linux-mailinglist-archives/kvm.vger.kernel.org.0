Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE259715305
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 03:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbjE3Boj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 21:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjE3Boh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 21:44:37 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAFE2E0;
        Mon, 29 May 2023 18:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685411075; x=1716947075;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=aN6mkZMMQbVi5i4IJuCcwGq8idZvhwObS981bQ70Io8=;
  b=LPIz1Hc60AYNt8O/iRU4K1ezahx7dlR1mieHolpyxC8hCqDcZIc8QNtr
   YY6+9QMLH7Jey2Izzw4k0d+XRSSajQHxiCs4EqQ+UnrG9m7xI1QlJDRx3
   fL4N+NbEQgXGQC+JcoJIp+enw24KgRHghrJxjI9GGbCYHKzZ6B7MHgqU3
   YQa7/KyzK0DthtXZENPo5AWcfa6BV8ERdm0kIZIPS5uYoTXhxi/z6MG5J
   wJqURtAk+bsQ1t7016wYom7V9Me19oGsrytKbYr21yfopjVywB6ipvfGt
   bn7jsUmbbyC9Hc47Y9ptJwrooPfUxSJWLznVO9ALDJcH2crvzYaIqO5mz
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="344294963"
X-IronPort-AV: E=Sophos;i="6.00,201,1681196400"; 
   d="scan'208";a="344294963"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2023 18:44:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="830546031"
X-IronPort-AV: E=Sophos;i="6.00,201,1681196400"; 
   d="scan'208";a="830546031"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 29 May 2023 18:44:35 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 29 May 2023 18:44:34 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 29 May 2023 18:44:34 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 29 May 2023 18:44:34 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.42) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 29 May 2023 18:44:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iaUrLRBbrgPLb2tKPjqfbl7LrR6O7kwL5xqQo/68WYbPaGwI39fXHA4bsXmC+JzzD13Xui0fqszVbY9uo7MVklB30sa2ThPTXGTECoL6ZQYMTth1vPvxIHrDBCNL7vokmE6139XZ+1+eztsQqg38rf83ZBwJWI8SoFffDy8Tf79MDQ3kG+immZ/whtHOn86SnC2Jo3DC409Dg60aKHJPx/6ZQaIOkqCJwNQZLqSckc39kuN+8fEgedyYYm7KrzhyhHlbiYE8QJ2aYuwNS9ViPKij7rVwP1CHE7lyNIITam2pglOP2e00xxatffOXEPJj1BByvqfUAezFaiMfkG0rtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tz28gFhVyEjDaI823qa3UsaQ12vJFNWOZEGdpCjvGbY=;
 b=hQcw6NaYZltHLOYO0AlZ3Qn6V660ALsCOWw8q3onstMsVCvqz+Q+BkzeOukwkb1mzARpuCVpUe3aFSehMjH4lhndWtSqMfTLTqLzrG24X1OBvCTs/DLaUaSg8ZUpFs/NqMdL0FRQz7xQS3FomSFy9N7TCI/dnkyremckRmQiG+6kFrPKYtAOz/gwCbwqSSdElkbk2jSFYh6fbk/6+HVPjoDbHihI3ZqJKVAHBnIKj4j6MDTZ1FsuhPLqHLJII+DHdyBcZCijNT4zUBPRxgeqppNck11ehdsu3B5kj9XGTyBMY4KBKiWNO3HaTAXhNanUUfpWaVB1NHm++OjBzIkVBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH0PR11MB7561.namprd11.prod.outlook.com (2603:10b6:510:282::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Tue, 30 May
 2023 01:44:26 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::af48:a141:6dd6:25e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::af48:a141:6dd6:25e%7]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 01:44:26 +0000
Date:   Tue, 30 May 2023 09:19:13 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Robert Hoo <robert.hoo.linux@gmail.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>
Subject: Re: [PATCH v2 5/6] KVM: x86: Keep a per-VM MTRR state
Message-ID: <ZHVPEWOWSyaIWteA@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230509135300.1855-1-yan.y.zhao@intel.com>
 <3f09e751-33fd-7d60-78cd-6857d113e8bd@gmail.com>
 <ZGxbat2mM6AfOOVv@yzhao56-desk.sh.intel.com>
 <ZG1WsnYST4zLqTnv@google.com>
 <ZG3vB052ubr1vBQA@yzhao56-desk.sh.intel.com>
 <ZG5VlRzJkcwo9Qju@google.com>
 <ZG8z493pfPIOPAT2@yzhao56-desk.sh.intel.com>
 <ZG92dWFxu+ue31Sl@google.com>
 <ZHBloxxmY/EUyswL@yzhao56-desk.sh.intel.com>
 <ZHDZpHYQhPtkNnQe@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZHDZpHYQhPtkNnQe@google.com>
X-ClientProxiedBy: SG2PR01CA0156.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::36) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH0PR11MB7561:EE_
X-MS-Office365-Filtering-Correlation-Id: dd3cf100-7a39-4e69-b7b9-08db60af6626
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3ZhVkJU6s2DChEb6st8/aEpaGuthANeZhm2nvpMscXtIqC5jcxSqO1aWQBc+RQ6JzesmfvJwWrgluNonggaFQzcvZmJo1GlmRo1i+iXU1gr33ZPuiRsALJx4bc3m2e0sbFfvYEZtzlYUmcMM/NtM6mSfh16zs3dqTL8ihY4O07DxkZTAUQaMFTDbr07r7acbrMNlGBrwbk/eixH9AfIcllxY7UfSB/soR5Diw36VMduROXbYmeLEDeE8PW857+1zI3IoMFKCBE+Y2PJbmPwc2JNWK0HJ76kAbHLl3rEXvAIiBMANISgTeMbaKKUU0/P8uyOfzEFfYJ02N8unJH5tSm2VYEyImGeW4aZj2ItgKDdtjE+XCAbVXqdPJnXbvK4IQLDUF8CY5b0y1OiEymM+5bgnH7pyrGaxKoAWjHVOQsWtOJqBqYJ6/Xq0PpSCTV/WsRjelKWWUVv9iWaXKURx3KlENkzZrhi1wTiCaDbX9kjVYbWRgVloQYI2ZMQ6xr1NP/JH0joaROpXl5HIQ2D2nWXKrTRkbRGSlnUxA/xozypm4avmuA9naph1QSX5I75R
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(366004)(346002)(136003)(376002)(451199021)(82960400001)(38100700002)(478600001)(86362001)(66946007)(83380400001)(66556008)(66476007)(4326008)(6916009)(3450700001)(2906002)(6666004)(6512007)(6506007)(6486002)(186003)(26005)(316002)(41300700001)(5660300002)(8936002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mVi/rQSidr/9V56ARqac+RC8FBbqK17j8Z+qAKeumUClNg5K8kKzgINPwoTZ?=
 =?us-ascii?Q?T+SaCrk6vBldoo+sKKbcZG0XCmadL7aB0gNVZwRUoDjsXBlJEgZJyqP0Wf06?=
 =?us-ascii?Q?sXkOVFSN0cAss16HQQN0GCoui90211f2h2hExTYH0h5c6LBKyPemsza7UTbw?=
 =?us-ascii?Q?nyqFgU7M04F+ZQMQk1NI3U+wu1rGWZEooqlJYyeHf8WuileOjFhAnsr+EY03?=
 =?us-ascii?Q?6lsQxF40rz5/N6rwBwqscYFGs1ZNz3w6hQP/toEdx1qkAjw+vHABFNYNC0UE?=
 =?us-ascii?Q?ETtyc72XOaAnis45yctb9FeQ+HZVG5hnkx3K0HNw5y0E+psbnovX8H0LkE+9?=
 =?us-ascii?Q?IpUyvNugEVRP6V4GDudpXwtKGFNOjrEk/IGQ1NUqJjSoMTgPXYbmCXpdoQRx?=
 =?us-ascii?Q?+TpJSAJesI67Dm3vExFJKbLhN+cybNPukS5iER+TGmoZYihVKhKkrnAw4Osk?=
 =?us-ascii?Q?DU0Cy0cosfQ4A+qUbfB6FPW9z9G3K8h5pzBkpcMy6oKbe+fMu8x/zL4r9YKS?=
 =?us-ascii?Q?B5kwNj6t5LhAlNYbpHYx5e3K0oRni6m/PEUSr8FlT6ot5NGtARVeejwqUqVW?=
 =?us-ascii?Q?1sCHoVkNd25cKctVTWRUMFiyDeWFKf4UDfcBC+gAqqfpi0Vdm044CxM24+mY?=
 =?us-ascii?Q?8m4LFcsuIYI8ZGYzX0zEeECbZ4ow/ZgMxSmoI2aKFSl7tWt91GU/Wjm7ymwr?=
 =?us-ascii?Q?wVBaKNwcmCBwFcfvTXh76Y2//a7PCvyyYzaWxG7ZwT4YYRFWUDUQhz1wllRL?=
 =?us-ascii?Q?X/UkLre+veHu2PmWtKOyvq3O6VdWSMRv7375rGWkX+NnfBY2wUVZo7cn9Mbe?=
 =?us-ascii?Q?RpFj2591s5yX5awp6AuGxN125cMLDqZuXs00X95cMnj3WgGOpQ0VQE7RT6mu?=
 =?us-ascii?Q?X0iu/SRHMa39x/DJHGI/TkBQiJXuL6WqrMHd0I3rT67k8eSSP9Uc5EXDeisa?=
 =?us-ascii?Q?A7q+3AP1dVoOjVlUya9U2XCfJrsgCxj9MvwK39FVnui4+teeRq90JHcMYaNr?=
 =?us-ascii?Q?NcSE3xni+MOLYp4ZjWeAjZ1skUkHXPaU3iCPHj5SHdE2zhDELMx9u9eyFfPw?=
 =?us-ascii?Q?0dKYK/kFjzom4geRHcTcUOEjNjqFWMY4DRbGkHkKmrQqx57Sy2aA0Au4nOOJ?=
 =?us-ascii?Q?7LA4x64l25SVV096TcpY+QK8ugHEUYPtaD3MMFC7ayBJTd50hTlahZh2r2aI?=
 =?us-ascii?Q?5+4Jf2PxFAcevHgErp+IBY4NSMYDhThozBpfNMoMieBecR8LnUnR9IkOPSAi?=
 =?us-ascii?Q?MP/DmiR+TZa3PkwITlF9yiATNybgZvhLADe9Y3C8WNxXIpPcg1JfooxbbqH9?=
 =?us-ascii?Q?Jhm2KoJYB6EaOAo9Uzs5d70pGwxBt3uw42sp7yrH2GwhgTAJxfs8EoPi7Lnc?=
 =?us-ascii?Q?9EC1GJagTyw4/dShFqq34nlsJhiY+62kjW4ImQpR8BVdVMP6uH0xq/9vr2hz?=
 =?us-ascii?Q?O4cRUrCYLe2Iu2zjZuJj5a1yjtZ5+mebFtoReGMgB6DMGHf4YqYOd3vCeIWT?=
 =?us-ascii?Q?KPK7lf69kS7tap9X5tV0R7+dzcLUE9II6/pi0RFgrGf88lsO2jn9LHGuTF8V?=
 =?us-ascii?Q?Ls9S+yk/MNrsUuuzWRGXq1hBG8fvwfYbqQoOSxp7?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dd3cf100-7a39-4e69-b7b9-08db60af6626
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 01:44:25.6013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Eivr5yDJeG0q99SehjWsbZslq/GzT9tgn/HeJmd8MStkEVAWsy9dFMkEHUo6W6G86l2kAsrZvMd1WJS5r/tsZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7561
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 26, 2023 at 09:09:08AM -0700, Sean Christopherson wrote:
> On Fri, May 26, 2023, Yan Zhao wrote:
> > On Thu, May 25, 2023 at 07:53:41AM -0700, Sean Christopherson wrote:
> > > > > > > So, if KVM zaps SPTEs when CR0.CD is cleared (even when the quirk is enabled),
> > > > > > > then KVM can skip the MTRR zaps when CR0.CD=1 because KVM is ignoring the MTRRs
> > > > > > > and will zap when CR0.CD is cleared.  And to avoid regressing the CR0.CD case,
> > > > > > > if KVM honors guest PAT for the bizarro CR0.CD quirk, then KVM only needs to
> > > > > > > zap non-WB MTRR ranges when CR0.CD is cleared.  Since WB is weak, looking for
> > > > Not only non-WB ranges are required to be zapped.
> > > > Think about a scenario:
> > > > (1) one fixed MTRR range is UC initially. Its EPT entry memtype is UC, too.
> > > > (2) after CR0.CD=1, without zap, its EPT entry memtype is still UC.
> > > > (3) then guest performs MTRR disable, no zap too.
> > > > (4) guest updates this fixed MTRR range to WB, and performs MTRR enable.
> > > > (5) CR0.CD=0. we need to zap this fixed range to update the EPT memtype to WB.
> > > 
> > > KVM installs WB memtype when the quirk is enabled, thus no need to zap.  KVM
> > > currently zaps everything when the quirk is disabled, and I'm not proposing that
> > > be changed.
> > I didn't explain it clearly.
> > 
> > (1) one fixed MTRR range is UC initially. Its EPT entry memtype is UC, too. ==> EPT entry has been created here
> > (2) after CR0.CD=1, because of the quirk, no zap, the created EPT entry memtype is still UC.
> > (3) then guest performs MTRR disable, no zap too, according to our change.
> > (4) guest updates this fixed MTRR range to WB, and performs MTRR enable.
> > (5) CR0.CD=0. we need to zap this fixed range to update the EPT memtype to WB.==>we also need to zap WB range.
> 
> Ugh, right.  But that case can be handled by zapping non-WB ranges on CR0.CD being
> set.  Hmm, and KVM would need to zap everything if CR0.CD is toggled with MTRRs
Ok. Actually even with below "zap everything always", I didn't observe any performance
downgrade on OVMF in my side regarding to this change as we skipped EPT zap in
update_mtrr() when CR0.CD=1.
(even 3 less zaps for vCPU 0 and 1 less zap for APs as initially there are several MTRRs
disabled when CR0.CD=1 without accompanying CR0.CD toggle).

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dadf80fb85e9..ad3c4dc9d7bf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -941,9 +941,9 @@ void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned lon

        if (((cr0 ^ old_cr0) & X86_CR0_CD) &&
-           kvm_mmu_honors_guest_mtrr(vcpu->kvm) &&
-           !kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED)
+           kvm_mmu_honors_guest_mtrr(vcpu->kvm)
                kvm_zap_gfn_range(vcpu->kvm, 0, ~0ULL);
 }
 EXPORT_SYMBOL_GPL(kvm_post_set_cr0);



> disabled, but I don't think OVMF ever does that.  Zapping on CR0.CD toggling would
> would likely introduce a small performance hit for SeaBIOS due to SeaBIOS clearing
> CR0.CD immediately after SIPI, i.e. with MTRRs disabled, but that's arguably a
For SeaBIOS, I also observed 1 less of EPT zap for each vCPU, because
there are 3 more MTRR toggles than CR0.CD toggles for each vCPU, and only 2 MTRR
toggles happen when CR0.CD=0.

> correctness fix since the quirk means KVM incorrectly runs the vCPU with WB SPTEs
> until MTRRs are programmed.

> With precise+batched zapping, zapping non-WB ranges even when CR0.CD is set should
> still be a healthy performance boost for OVMF.
Ok. I'll try to implement in this way in the next version.


> > (2) return MTRR_TYPE_WRBACK if guest mtrr has not been enabled for once
> > u8 kvm_mtrr_get_guest_memory_type(struct kvm_vcpu *vcpu, gfn_t gfn)
> > @@ -628,13 +635,23 @@ u8 kvm_mtrr_get_guest_memory_type(struct kvm_vcpu *vcpu, gfn_t gfn)
> >         struct mtrr_iter iter;
> >         u64 start, end;
> >         int type = -1;
> >         const int wt_wb_mask = (1 << MTRR_TYPE_WRBACK)
> >                                | (1 << MTRR_TYPE_WRTHROUGH);
> >  
> > +       if (!mtrr_state->enabled_once)
> > +               return MTRR_TYPE_WRBACK;
> 
> No, because this assumes too many things about the guest, and completely falls
> apart if the guest reboots.
Ah, right.

> I am not willing to lean on the historical commit messages for the quirk to
> justify any change.  I'm not at all convinced that there was any meaningful thought
> put into ensuring correctness.
> 
> > we can return MTRR_TYPE_WRBACK for CR0.CD=1 only when MTRR is not enbled for
> > once. (And I tried, it works!)
> 
> On your system, for your setup.  The quirk terrifies me because it likely affects
> every KVM-based VM out there (I can't find a single VMM that disables the quirk).
> These changes are limited to VMs with noncoherent DMA, but still.
> 
> In short, I am steadfastly against any change that piles more arbitrary behavior
> functional behavior on top of the quirk, especially when that behavior relies on
> heuristics to try and guess what the guest is doing.

Ok, yes, this is the right insistence.
