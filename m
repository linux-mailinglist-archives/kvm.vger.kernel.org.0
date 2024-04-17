Return-Path: <kvm+bounces-14919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 782108A7A7B
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 04:21:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 302C62839CB
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 02:21:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D659863AE;
	Wed, 17 Apr 2024 02:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CkCkJeLQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FF64690;
	Wed, 17 Apr 2024 02:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713320497; cv=fail; b=S1sKx5XL1ZrI2lua01BFnAYW5WQOYvenU2AEL+qCXkbovW8fcQxVIJrPiD7fWlSo200EV4ndv8RYBt9OncLd5qKjJSpEYC27q+k66KR9RwPwacgNqLu5PkMoYIlkDi2Kvh7uLWlJW7jswvACuDN0bSGaMSS0Na28uDtUwWDQtSY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713320497; c=relaxed/simple;
	bh=ZCSUzxxHTna00xiqaIqy1Uesvf6smwOwoAAqTgfrdOc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=o/aExdIEmy7iWiUDniubdrvBWBwFbha33l//4i4WyBCM/LBCHdGQLu2UHVzEFpoTc+4Ckbds8mK9mXa8Rw7hQ0uayRfqzzYI42yVQ0dpE12yqBwOrO9KCeJxDUyg8/zrf3kdxJHldvOYezjCqMdHWn3gITWwUuT1SgLHYa86n+0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CkCkJeLQ; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713320495; x=1744856495;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ZCSUzxxHTna00xiqaIqy1Uesvf6smwOwoAAqTgfrdOc=;
  b=CkCkJeLQSpT4TPNz8Aq0qPevvO6bwJn0QQjODofJpEFsHtXOq7fWiWVb
   VRP3M1JWWvJTGYrQosMzqN8RsMvyt4sS27kyJcxWh3PB11sK3lCgHFeP6
   hbWMC2/B8QIf8N0s9hfj3DnNam/QN+synFnwiN7Z17PO4Ox6wzCqr4g93
   KwIzNYLe4Qo4rymcj1nIB5wr3Clyl6i2+4jxJSNmWnTpI9al0/C6zJOpP
   CfN6W+F2ZMYznehskJv3be3bxoVtc4N4Nmt+/Ms8vqD+h32NK5vKS9Ped
   ZVvfGEMaU+ooqe0VgMtS77ljzhrB5s42+wmqu+OB8g5sAM/Yvx8GNxa8b
   g==;
X-CSE-ConnectionGUID: lYldy8LFQzW2ahk4d6XOiQ==
X-CSE-MsgGUID: T9iwga1UQYmr+Qxv07I8PA==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="20214563"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="20214563"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 19:21:34 -0700
X-CSE-ConnectionGUID: eX0BbxuhS5SnwxmsO8+j6A==
X-CSE-MsgGUID: 3PmY6CIUQcOwhTewaVHVpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="27147418"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Apr 2024 19:21:33 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 19:21:32 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Apr 2024 19:21:32 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Apr 2024 19:21:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OdHdPNukBTKPeDf0qEwImmC0phNo83Qkj1uwYg+uRaRCU/+uywPZaJTtXSba8fSSyOHt0fb15TXJyQj0jFnWmByaS0CxWbi3ozsRXju8N9pIGXKVygtpKE765v/km64XVsiQ5KahNEpmSi+EiYsaU+swKY6m2cQk0D7hdBI2JskzH6xYg6pfB/gyD4oEOe/mEufD5Rd0rvlYi/QKNYBeU8shPPsWgQPXmbHCX4o3G33d9s2OQy56KVnguWF0He8h0IxMwyqRNrGeeib1ecv0YIDZimYca74Qp8Azj4dZgWPz/la/XXtB7OZd7TonjBkwvwdZQllg7MLiL5HZLJT4Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UHyIVjjdvgeQve1ffuQbAuOT8emhDRMcGJE5NR9A6Ug=;
 b=Mv4cfiAjSlpxShfdCMn8Rssf6Fawr6V8DnRHplwYKBYhZOMjsq3CDSdMc2Z9EdmotZDWbWSlgIyBRUA2Iu1EpyRPLCsV2FCSManXi8AA1v/ezpnTAGCO5LWCuRRa74gpdVx+xlc6NgndJkqlijbuBp7TRaSms6x05XeBdFtUk8OleaRNx30fsJwaC6G/VMND4mfnr+aJ9VJYi5xcCQn6ld7DrkKoXRS6c+UVCt/tcusFu9q095NTfJYHyKSAzCCjcUFUMb9jiToX8symsr9bmbYD81XW1OrWUavp+ey0A9rfWqT+WXLkVG5LWOdt3cUm3sDPV6e28Wa2vG/qMgIPkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CY5PR11MB6114.namprd11.prod.outlook.com (2603:10b6:930:2d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.26; Wed, 17 Apr
 2024 02:21:28 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7452.049; Wed, 17 Apr 2024
 02:21:26 +0000
Date: Wed, 17 Apr 2024 10:21:16 +0800
From: Chao Gao <chao.gao@intel.com>
To: <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>, Sean Christopherson
	<sean.j.christopherson@intel.com>
Subject: Re: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages
 for unsupported cases
Message-ID: <Zh8yHEiOKyvZO+QR@chao-email>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <1ed955a44cd81738b498fe52823766622d8ad57f.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1ed955a44cd81738b498fe52823766622d8ad57f.1708933498.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SI1PR02CA0023.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::19) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CY5PR11MB6114:EE_
X-MS-Office365-Filtering-Correlation-Id: deb9b37d-af69-4352-9216-08dc5e851550
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tgFvBmQ/VhYGCl1LAJzbU2XhuQJ19WN1BHZCdSzzMOdy8KFa8we/GQ3euIlQPDJep6wBheiJ8x6/d/PsCGfd8AVmDGWKspSMhRFQJgWtcDU8bXcR0+hgByFcDA3In1dHw8EEU6RnI6EodcXfIyAEHpz+98mI+491wtYsP12ERja2T8Sd8WDoOBX8VviDgnD9Lv18vfs68+k7epYPaWghnHxXFzJ8XdxWl4klRpUHg6ViJ0nDKKTylflJdJbrnaYyjZqZFw+kQdCNwmIqhgQicUoJJThnixSjJ83+IUONdAst8COpubb13E44auEcns8V6olr1rUFVBfn2YK1qAKaLSLqusmEoW/EFj8rvuOsbJhaS56AwZ2l7gU5th5mlDBywIOzIZaxF+oBytOT5A1sJ1AJTXINwHeHDBEK2lGrXqXANBmAGXy9nkPcg205f0p+qXbHg7jkpK+KJ5kiIubCt8Hw60xdBf3SpgWbFX8+G7x4RqC2sZjDQahYSNLAH2AzIiNYQIgeqCrqzTKlyO13RUXMT4RjtRL6NrbciuG84UVB5yEKrcR6OoTHLAkMuj5mTEHqChHR/CWglESXnWf8Ailp023uqHYSWNT4S6VdeItt5dGtJ0z05c+VGzqW0hNr1cH16uxWjRAYQxzgYlVBw/afivVDQvXQ5HhldxDxr1M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0/ag7EjFKvOGa0vIFMnK9JZRCWwwC0Cz88JHMGc2VOXyiuMbw/Ip0QgGagNF?=
 =?us-ascii?Q?tMB6r91Vfc7nAHvKKXvXtD9wIAfM0Bhh+ZDOpF/h9cNin4FYZqiUlnrR2y0o?=
 =?us-ascii?Q?kr1VD92YdUi6E+2HH569lwTUdK/vBwPK321KkeJJG/q5Pjx8CE47weFHKt7T?=
 =?us-ascii?Q?ncrEKnGhIa4Zouec1gjWRZgeDHXfn5HaREq8LWTCwHkKejuH9WnVhXsO66x9?=
 =?us-ascii?Q?lQ+2gnyb6AnciovmsyeEIsClpr0hsKmc9XudeJZhai9PrS+1CMDNWUDF/Qyk?=
 =?us-ascii?Q?UbmIYRwChWWiMuQDdj2RMLDuPmFft5fjQy98cnCY8rE5fjWRwSaJ8SoKJAEy?=
 =?us-ascii?Q?bC+8Ssh+8sywLPwEAGQ6NHDYs4MEpsFrE4DydIGj5R/qySEgPeMtLLtxG5Tn?=
 =?us-ascii?Q?dJglQ2GV2q7TuB8V7GEnAwgnBZXLNHlwdXLfHFBvG3JObblFZMQrviE6zuV3?=
 =?us-ascii?Q?ZtVsRHVC+tU8kDaRXP3POc9owMi/P3Kkqga/RGyEl36U6n2VbdrnzrAW9eXS?=
 =?us-ascii?Q?gckX2oAw55JlLfNzuv7z7FQ0UvxuTVQtSVGUUi9r1wH7BrKht6I/XDVX988d?=
 =?us-ascii?Q?EIJ0hEh+QHCtD1ECx7yStR9NWWWuwh1THOdKzva4L9VjIzr0/864AmaihCsT?=
 =?us-ascii?Q?ak6pL1J27NCvp+A0h2c5WcJERS0a3uJ3Ecp3vDd2HJY0NZih6JzGft9q2r8+?=
 =?us-ascii?Q?w5AXT0nclmthmw0D7NnfkeY2o+FpsJ6r6fpw7yG0axcHdi0jwTXlI+JBg5mk?=
 =?us-ascii?Q?XhgUP6hC8WTCxEdWEfC6tpF0UoPMgqNM+ZckFWzkLfxDKoAX6so44RfHSH1H?=
 =?us-ascii?Q?SehpSjvQ4NEQHfVU2X+kdhVKfoxHOuvPV1v4PeMeUixX1b0keVJC1868ijXK?=
 =?us-ascii?Q?yxrAhUSWuydsGP8bVmn863iNqdYMaYmWm3MAnIZsDIb5TG1x0ssVfmtntIQ1?=
 =?us-ascii?Q?hxlmsb9z9lNrF/1H4jUYvqdrnU20j8R6Q5Wal/z89+e18yrMi/PgrRHOc//x?=
 =?us-ascii?Q?8lL4mvFiFyXq1kqnVqR4xbemwvDIeonUURfrNrX3F3HTqeu5qMkTqs2imU3V?=
 =?us-ascii?Q?F1l8Sk+yC5tfQs0Jrt0x/XFIyfE/uigJUa/K9f8hiBPYtGFTx/KxqpJc+6Vd?=
 =?us-ascii?Q?dnecNmvEL4M105scOtAK2JSqSqfD0BQ5jQsYzWVp7eBD/oYM5CoH4yQQd2dQ?=
 =?us-ascii?Q?yj9gVZ+UHEtXyVxoQ9Vn1iHqdHtT/BUqn0WK5btW3ozWl8ucphAkHILX/cg3?=
 =?us-ascii?Q?oOYdWSNOz5dzchHkgnp0mVkm7JbtWULP0oJiC28aPSA9/mq/u5fXDi6ClhYe?=
 =?us-ascii?Q?qVkBxhoNo2xDYiTNJ93txRrZuxbZlyQRGdhM3VDblIMfo1AhTd8D5eJ6OV9w?=
 =?us-ascii?Q?vEs5OKeWkKJsWO5nTElPDjfje2vlUpkHuYrH8Yd6tYih12Hu95ipfuLv97/O?=
 =?us-ascii?Q?ZLRgHBodGSLtyKdTe75HIL7/TDKDaZ/12BVJABUPtPi8l7COzDWnMzFWuixg?=
 =?us-ascii?Q?l9ZcQyKhUVwUw0x7VxPDIMZyG/n2ZQcrGzH4iOreQZSrioFgo7RfRD+D2Ryc?=
 =?us-ascii?Q?IPx6iKr8BLAEoCKanLI3zgWBCHPGaaTy01PoYYYx?=
X-MS-Exchange-CrossTenant-Network-Message-Id: deb9b37d-af69-4352-9216-08dc5e851550
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2024 02:21:26.5008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: edi9zlN195FT2Nt+GatIzmXSboLTXPCaswbK03xYH6Di94cqDLR6E/tRxuWcI3w1sunD9SB9LRREDH1ey1HnIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6114
X-OriginatorOrg: intel.com

On Mon, Feb 26, 2024 at 12:26:01AM -0800, isaku.yamahata@intel.com wrote:
>@@ -779,6 +780,10 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
> 
> 	lockdep_assert_held_write(&kvm->mmu_lock);
> 
>+	WARN_ON_ONCE(zap_private && !is_private_sp(root));
>+	if (!zap_private && is_private_sp(root))
>+		return false;

Should be "return flush;".

Fengwei and I spent one week chasing a bug where virtio-net in the TD guest may
stop working at some point after bootup if the host enables numad. We finally
found that the bug was introduced by the 'return false' statement, which left
some stale EPT entries unflushed.

I am wondering if we can refactor related functions slightly to make it harder
to make such mistakes and make it easier to identify them. e.g., we could make
"@flush" an in/out parameter of tdp_mmu_zap_leafs(), kvm_tdp_mmu_zap_leafs()
and kvm_tdp_mmu_unmap_gfn_range(). It looks more apparent that "*flush = false"
below could be problematic if the changes were something like:

	if (!zap_private && is_private_sp(root)) {
		*flush = false;
		return;
	}


>+
> 	rcu_read_lock();
> 
> 	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end) {
>@@ -810,13 +815,15 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
>  * true if a TLB flush is needed before releasing the MMU lock, i.e. if one or
>  * more SPTEs were zapped since the MMU lock was last acquired.
>  */
>-bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush)
>+bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush,
>+			   bool zap_private)
> {
> 	struct kvm_mmu_page *root;
> 
> 	lockdep_assert_held_write(&kvm->mmu_lock);
> 	for_each_tdp_mmu_root_yield_safe(kvm, root)
>-		flush = tdp_mmu_zap_leafs(kvm, root, start, end, true, flush);
>+		flush = tdp_mmu_zap_leafs(kvm, root, start, end, true, flush,
>+					  zap_private && is_private_sp(root));
> 
> 	return flush;
> }
>@@ -891,7 +898,7 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
>  * Note, kvm_tdp_mmu_zap_invalidated_roots() is gifted the TDP MMU's reference.
>  * See kvm_tdp_mmu_get_vcpu_root_hpa().
>  */
>-void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
>+void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm, bool skip_private)
> {
> 	struct kvm_mmu_page *root;
> 
>@@ -916,6 +923,12 @@ void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
> 	 * or get/put references to roots.
> 	 */
> 	list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link) {
>+		/*
>+		 * Skip private root since private page table
>+		 * is only torn down when VM is destroyed.
>+		 */
>+		if (skip_private && is_private_sp(root))
>+			continue;
> 		/*
> 		 * Note, invalid roots can outlive a memslot update!  Invalid
> 		 * roots must be *zapped* before the memslot update completes,
>@@ -1104,14 +1117,26 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> 	return ret;
> }
> 
>+/* Used by mmu notifier via kvm_unmap_gfn_range() */
> bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
> 				 bool flush)
> {
> 	struct kvm_mmu_page *root;
>+	bool zap_private = false;
>+
>+	if (kvm_gfn_shared_mask(kvm)) {
>+		if (!range->only_private && !range->only_shared)
>+			/* attributes change */
>+			zap_private = !(range->arg.attributes &
>+					KVM_MEMORY_ATTRIBUTE_PRIVATE);
>+		else
>+			zap_private = range->only_private;
>+	}
> 
> 	__for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, false)
> 		flush = tdp_mmu_zap_leafs(kvm, root, range->start, range->end,
>-					  range->may_block, flush);
>+					  range->may_block, flush,
>+					  zap_private && is_private_sp(root));
> 
> 	return flush;
> }
>diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
>index 20d97aa46c49..b3cf58a50357 100644
>--- a/arch/x86/kvm/mmu/tdp_mmu.h
>+++ b/arch/x86/kvm/mmu/tdp_mmu.h
>@@ -19,10 +19,11 @@ __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
> 
> void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root);
> 
>-bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush);
>+bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush,
>+			   bool zap_private);
> bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
> void kvm_tdp_mmu_zap_all(struct kvm *kvm);
>-void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);
>+void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm, bool skip_private);
> void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm);
> 
> int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
>-- 
>2.25.1
>
>

