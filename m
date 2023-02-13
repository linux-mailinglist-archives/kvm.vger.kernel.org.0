Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAA4693CE4
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 04:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjBMDbb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 22:31:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBMDba (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 22:31:30 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2ABD4EEB
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 19:31:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676259086; x=1707795086;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=T0S9xcR19yfOCxCm3V8qnextxdgoU8yEz2MjAuK7gAM=;
  b=c7WmaIsJqT0jQzC7HfOLXz4p9RR7y1ZI4rC72iUHOoL36fFFH2zvdQfQ
   j4siTcF4MQvo872q0B38JCkx+8Jd22WTVeJs1iHZHOj5DL8DYZe5uvaZa
   VlxYw1pYeXCCrvv9L5kwF9f0kskyXYpAYDlgZXhyywa8Pq+W9AoACvDC1
   J6uoOaTI0x5D3MmpKRI8j+yNdBH8QRRTTfHdynmxkrk2ZJF+OZCmL83fN
   lpvMzESvwErrsUuponlgHYCMpxqVHDvmKvRnYkpUTvkBLHCpK+1IG2nOr
   J64/2gsRDV7FtY4lN0n0pGmQ6ud2+8qhVjW9Ul4lS0P4iAqC9yXeXIAse
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="328505517"
X-IronPort-AV: E=Sophos;i="5.97,291,1669104000"; 
   d="scan'208";a="328505517"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2023 19:31:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="997544364"
X-IronPort-AV: E=Sophos;i="5.97,291,1669104000"; 
   d="scan'208";a="997544364"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP; 12 Feb 2023 19:31:26 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 12 Feb 2023 19:31:25 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 12 Feb 2023 19:31:25 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 12 Feb 2023 19:31:25 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 12 Feb 2023 19:31:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FIPm11e89BY/0BtMoP/zfs0BU7Nn+8AE2DG6DLbfrQfaylr+LWoTZPnzIM5hdRR2OWtQBq57sGXmQl4+XyhEslHqENvAwQd9D1DnGBr3uYBlGW92XbjM9QTohlqdTPaiEpV+a/Tzq45KHP7YXWKjqMNGgVeAypkxvO4MPI9394KZbQC+zJyQovYiXtS2NblpwNf98MzRTxKconP4Xf/cNuyuxzaFMyWEK6GKj68NNAsrxMBm23c1dVByIhE6kwXsUy8mkiiNYK7X//ZAejJIdMBZp6gqbyavU+VaDKITPqbjDwMPqq6jT9y5IUVTTEftmF6jV8Ymf9PYVpPTAcbikQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tzVjjaYFi6sGpBK6FHf758sOWjkFVN3hhm8KFL/2RHU=;
 b=knzVlpUzVFH2+Kphp7AOuitQWVg281RD8dEOECE8GZhf3EEN32MhppvRX7f1xSnAh87r00WesEsRdpGL3QFSm9nIW8qMyS8yCsF6if0o0RNiwXyzz5Y/c59Tx4vF50sOqmLegnpMNir8YNSr1/sFcx3YwnK7KQAyw0aleHkHJ9FkPsMcAro8Mt8GXM1Oecb5r2HMK99YZDhvQ9om0UGTTC3I41/+tZkOteffb67VuQCi4m5E9zFVagfCmEA726RevCpUBGv/uCWP3aZPodxp2H/lye/oeNY2RAidWk7Rmzy4F+V1s75k0nTtYeVlVPuuVfxRSFLBqZlvbxoq8/KVow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by CH0PR11MB5345.namprd11.prod.outlook.com (2603:10b6:610:b8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 03:31:21 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09%8]) with mapi id 15.20.6086.022; Mon, 13 Feb 2023
 03:31:21 +0000
Date:   Mon, 13 Feb 2023 11:31:39 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>,
        <yu.c.zhang@linux.intel.com>, <yuan.yao@linux.intel.com>,
        <jingqi.liu@intel.com>, <weijiang.yang@intel.com>,
        <isaku.yamahata@intel.com>, <kirill.shutemov@linux.intel.com>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 7/9] KVM: x86: When guest set CR3, handle LAM bits
 semantics
Message-ID: <Y+mvG8S3W5lXoZNJ@gao-cwp>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
 <20230209024022.3371768-8-robert.hu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230209024022.3371768-8-robert.hu@linux.intel.com>
X-ClientProxiedBy: SG2PR01CA0167.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::23) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|CH0PR11MB5345:EE_
X-MS-Office365-Filtering-Correlation-Id: 3580a99a-dae7-4491-54d8-08db0d72c6ad
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0t2QJm0SebxtZ1L001HHi/mFlHUJ5JPdkhkTgRrRCDEc8V94bJboFlSDjYjmVzdW1ZO4/QYoUZwxyKjmGq5P/f0zsWslSsifYjtWhGlZpwLzRPTRPi3MHLBYL7/BQ2ST6s66LIAwp1ra5spkLxdvEtt4F7ZsKCGdurcI1Q/0o09Ew1DiMpBqvAoWgwjLQOn3pdZbPHx2ROmzmAwj1tXkHJSsHIL1iAVk7pixlKnlnDG2l/uwHLOgxWjoEKXaKjQrKVcId8kmfhghm5Gh4NCLlaz6J9fKQxXQO0h2eRvAwnn16/ZRfkI+Rky6Eq9YP/3CkpPe+UGpnwLU1KU6TRgLb9WpanR27byopYEnVw1tCJQGAq75QvfcpiZ0kb6BC8Q+m2mfSw/qqHQUckKkb3YDJULGEqcGT0lezhD+9jatF8+A4Tdi5AaBmo5isFCe+EYkKq55K+q85mysdoWvyGgzjd3Lz8KkrcRWOAKO7IEoB89ILoWTkN8KcJNvecW7i71g5OSYg1GRBqr3IBGuNLXyqEWIQmcxB4Eyj9CJMZiIXUVsgMc8b8OE3W8vNy/gh0Z0Rl3NW5qKwnUcLblW1XgtkZwu7Dd+IwV7hhsH74JplkuYTk+Z5+djrgDF83+sBkbVrWDWx1XNt5h3m10H3+Fsgq6jxZt4sypLUXYrupvR5Q/lhgsFgISoelFCaNsU4vXWt/aKgMVoxXDkJQDWVxeUyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(376002)(346002)(366004)(396003)(39860400002)(136003)(451199018)(44832011)(2906002)(5660300002)(6512007)(83380400001)(26005)(186003)(82960400001)(38100700002)(33716001)(66946007)(4326008)(6916009)(8676002)(316002)(66556008)(8936002)(66476007)(9686003)(41300700001)(6666004)(478600001)(6506007)(86362001)(6486002)(67856001)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BBDbYkU8hUrXMYb+eqrz2W3LNoMp+Esb7d9g1i1iioKAdwQ0Nc7yT5m6RCOQ?=
 =?us-ascii?Q?Ll0GX5/ph1leBsvY610zAz/oRsLHWOC0iCwrdczK6yWW4X+OJq9Qgd98QCwu?=
 =?us-ascii?Q?ENMqJIouMuUCcHJdL0+q44xFhsiSz0/1wEPb2IxI5o4LRTvNitVQE4QhKmTg?=
 =?us-ascii?Q?HoNnewkg3jRTO1Fjmvo+ygy5xf6vVGywgyuvS5wjnPM0UhGkav7VSv5XsV0j?=
 =?us-ascii?Q?pHYgEnSidNi9cAK/nlIEZ3zaUI5kL/Gh3omMxXWqJd0G77+b9S+FOi7Fivk+?=
 =?us-ascii?Q?9PlnO3qZHVLL4rqVy365lSTePAl1EHdtGKMIDRxKtmLcRXGn+dk8K35J2eCy?=
 =?us-ascii?Q?TOo1vf2b5kIiIf9470IHuSKA0o/SGeghbRlOb8E3QRTI4QVaNtfFQKjjOODH?=
 =?us-ascii?Q?7pi+awVLk7Do+gKeMGav3KpnUdxDtpKOvoCFRwI1J+2VJy1K8Vj34oe0vyPL?=
 =?us-ascii?Q?2TqB+QTV75+7DJwnKcKSc96VDRQgHtuZebprx8Beg+qdT9TguHw3/Ah9EFVo?=
 =?us-ascii?Q?MA6XOIX9bANbJ8RL7LmyyC2eIqJBKy1ymfoX9PIOPfJfgCY42DLN+UL95KkL?=
 =?us-ascii?Q?Xa1qnj8/kVORNaOzP8sf4ZCuME7K2GSvjDwMTMHtbHDfiz95xU8T/jSCLBgU?=
 =?us-ascii?Q?Ko9nlVimwolx19p+LknYyY/F1ZVC4mxXQI801tLHin+Ug/lHr8eAMkxbD4Vr?=
 =?us-ascii?Q?4gJjZ2zRbGY7IDUQeO9acxSdwTDXEAeaB23IUxa3u5t84WSA6LHwqiJSvc7O?=
 =?us-ascii?Q?BSc0+oNW7gFgzYlFuUzo/rddq4xo2OEpqDLtsApWiOq3k4ug8Ot4eAiOeIHw?=
 =?us-ascii?Q?rCo+kqthwmbs49JXg7ot8z+ituMNoNMA+o0FPerzFTed07Z7ci1cAHeD7kNN?=
 =?us-ascii?Q?kbLoNEiiREZRdi0jRXzY1y2iQjG31jwuFu+B8eNmzdtKfvNK3YQb+hmUYGhb?=
 =?us-ascii?Q?ep5FmwmaWoTtm4FJgk1kdgwdLMmBChYibP5EBB1Vtqtr0OhKksEDEWCFxBMH?=
 =?us-ascii?Q?zRGswCHMDtgBi2a1/BHmFA/4yV+EDI6q7nyGqJnl5Jh+w+YtZJDcSWjx4AOG?=
 =?us-ascii?Q?akiRQepy4WPu0eVGy7621UXxsGnHXr+b5CtdsIpC+IHlAVvGunPCOfuTLtMb?=
 =?us-ascii?Q?WL0ZpXnyW+Sh4z1Qmz8CJy20/oOhwEa73jsyg1TlAufhiAsYLe2Q++/91POz?=
 =?us-ascii?Q?/lL1RE9rapB6RAzaKyuKfcNm9ciPU1dOsyVYmu66+WRBNgGdRpIKXrS66sx8?=
 =?us-ascii?Q?U5z09RjOTeBA7nSrlhPMssbvGvVk2YToFD0NcXbSdXArybeZYuhmAXA7id0J?=
 =?us-ascii?Q?QxCHywLSi/WRG5wXQFRG1/ozcJ8aDkKG2Uch66jz/gok/9wLi2sTv7rRSZxq?=
 =?us-ascii?Q?zrBDEFvc8vnrT08Miy3RKMPmKQUJxmozNSnpGmj2HX+lw/Czlp9DUMcQ1EvG?=
 =?us-ascii?Q?msX5T9PeDfrLRah8OmM+MpU9a8jeeNPkQ4jePqhQKvCa6t2/o8zlXFg8G/uU?=
 =?us-ascii?Q?0OqnZ2DaDQNF2opvPsdSrzZ9tEmS5Jd+h4BNxfFyp8S1/IrmteAZE7cRmQp4?=
 =?us-ascii?Q?BmwBVKpqrnmwJFGQjggcdx4omgR9FAFnF8tSW3YL?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3580a99a-dae7-4491-54d8-08db0d72c6ad
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 03:31:21.5300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OWxsqtlv4mdvnouqkJ5jjmXhNvFJny4UfgRP4rmwB92q3TP6JGEiY6CaNtKiE7x+7RbonPOf8V0QUgFO342rdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5345
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 09, 2023 at 10:40:20AM +0800, Robert Hoo wrote:
>When only changes LAM bits, ask next vcpu run to load mmu pgd, so that it
>will build new CR3 with LAM bits updates.
>When changes on CR3's effective address bits, no matter LAM bits changes or not,
>go through normal pgd update process.

Please squash this into patch 2.

>
>Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>
>Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
>---
> arch/x86/kvm/x86.c | 24 ++++++++++++++++++++----
> 1 file changed, 20 insertions(+), 4 deletions(-)
>
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index 3218f465ae71..7df6c9dd12a5 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -1242,9 +1242,9 @@ static bool kvm_is_valid_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
> int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
> {
> 	bool skip_tlb_flush = false;
>-	unsigned long pcid = 0;
>+	unsigned long pcid = 0, old_cr3;
> #ifdef CONFIG_X86_64

>-	bool pcid_enabled = kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
>+	bool pcid_enabled = !!kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);

This change isn't related. Please drop it or post it separately.

> 
> 	if (pcid_enabled) {
> 		skip_tlb_flush = cr3 & X86_CR3_PCID_NOFLUSH;
>@@ -1257,6 +1257,10 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
> 	if (cr3 == kvm_read_cr3(vcpu) && !is_pae_paging(vcpu))
> 		goto handle_tlb_flush;
> 
>+	if (!guest_cpuid_has(vcpu, X86_FEATURE_LAM) &&
>+	    (cr3 & (X86_CR3_LAM_U48 | X86_CR3_LAM_U57)))
>+		return	1;

can you move this check to kvm_vcpu_is_valid_cr3(), i.e., return false in
that function if any LAM bit is toggled while LAM isn't exposed to the guest?

>+
> 	/*
> 	 * Do not condition the GPA check on long mode, this helper is used to
> 	 * stuff CR3, e.g. for RSM emulation, and there is no guarantee that
>@@ -1268,8 +1272,20 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
> 	if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, cr3))
> 		return 1;
> 
>-	if (cr3 != kvm_read_cr3(vcpu))
>-		kvm_mmu_new_pgd(vcpu, cr3);
>+	old_cr3 = kvm_read_cr3(vcpu);
>+	if (cr3 != old_cr3) {
>+		if ((cr3 ^ old_cr3) & CR3_ADDR_MASK) {

Does this check against CR3_ADDR_MASK necessarily mean LAM bits are
toggled, i.e., CR3_ADDR_MASK == ~(X86_CR3_LAM_U48 | X86_CR3_LAM_U57)?

Why not check if LAM bits are changed? This way the patch only changes
cases related to LAM, keeping other cases intact.

>+			kvm_mmu_new_pgd(vcpu, cr3 & ~(X86_CR3_LAM_U48 |
>+					X86_CR3_LAM_U57));

Do you need to touch kvm_mmu_new_pgd() in nested_vmx_load_cr3()?

>+		} else {
>+			/*
>+			 * Though effective addr no change, mark the
>+			 * request so that LAM bits will take effect
>+			 * when enter guest.
>+			 */
>+			kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
>+		}
>+	}
> 
> 	vcpu->arch.cr3 = cr3;
> 	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
>-- 
>2.31.1
>
