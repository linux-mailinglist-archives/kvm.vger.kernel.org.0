Return-Path: <kvm+bounces-13269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CE128938EB
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 10:22:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6B564B21285
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 08:22:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5704EC148;
	Mon,  1 Apr 2024 08:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YSENjTCg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4196DBA49;
	Mon,  1 Apr 2024 08:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711959737; cv=fail; b=bAoV8DO+00T0BPJvl0H6KeaEeTiUqoU4TUc38qB7mdgBRE20qgXoRu1gO417TVvKzmL1Sv4spxBA5QXYDv8oGxrCC2Uc4953dqr73qmnAd5ezGXHMizs3zwRRChPoyWhrfAPFbE/6AWLgfIVUw4rISG68Hhe++5MbPttdisnQAQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711959737; c=relaxed/simple;
	bh=gTP2edtB3J2/BS48xcIAex1bMTzQc3HOLjSyQvgIW5E=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=oRzj0l5JXRNAk9yghHVa93FQtqpW3NDVJwtUI4nLZ9ODjfOaBHd9mVnK7iyHmiXXs593J4mqxD7pR4ZwebNskBc2U+QMRD+E9ZKSby+ZM/mDIaOBjX/Ku2Bl31Kw2TQIS3QJ3uRAJWXavgHyr2l3Lmh5UBoLUZggtiz4RWNITQc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YSENjTCg; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711959735; x=1743495735;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=gTP2edtB3J2/BS48xcIAex1bMTzQc3HOLjSyQvgIW5E=;
  b=YSENjTCgNkShsTzI0B0ZsA33+dMFZ7o+Vy2eBVa0feLKFUokziMEELPl
   qJR77rhTO7sQbGwIYhPaF+9F7Ru/tesBTFkA5UOh5cCpL8ji+szE2hjfS
   4JynHwAmVdLsz27nd2S55tLH521KjoenFuPNZ+1Lm6g4bVV2C6RAZaHlB
   T6VSH8cUFAMA7eQbt82iE378CQ7AT5NkJkmJ2EH1kxRD3NGSxySclwe0w
   Gm/QeBnuMhMXejh87VR9HdOT9fjXi35fzgZPoBTzVW2EGGvdWZBAuyER2
   qFCxWn4oh+wduFMmjOEgj6ESOXxYKKsbuaxO8cVmIsXNrZoLdH0qYO7QO
   w==;
X-CSE-ConnectionGUID: 1mXDbSKxRm+toZ+FrZiWKA==
X-CSE-MsgGUID: rAtgwdpTTEyxCI9QDnr7Iw==
X-IronPort-AV: E=McAfee;i="6600,9927,11030"; a="7290253"
X-IronPort-AV: E=Sophos;i="6.07,171,1708416000"; 
   d="scan'208";a="7290253"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2024 01:22:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,171,1708416000"; 
   d="scan'208";a="48841608"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Apr 2024 01:22:13 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 1 Apr 2024 01:22:12 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 1 Apr 2024 01:22:11 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 1 Apr 2024 01:22:11 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 1 Apr 2024 01:22:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nX9Oeib054JuA1mgE6b4j61MNz4fYYiZg5Vg74BWFQBV0/Px2i8O1Tn0ZDeUSqEhQi947tp0AkfIKCmmctULDd4JDaDScTyBqM8gdSZnN+NioX2jDnU2TXElAc0rPFovglqD8ZAZ5hNidwotyWTGux4zxZkINoVTTaeOukQc4MVUqt6kxHz9X5zVD/Xiu7Ul2RFNAun1I4PM2Pz/J0HnVZ6tszYt+v4EqoWYlk/bcKitmic2d6erGhsX5+Otm379PWg6CHLrPOqnMPLHbb68mvvIuiwucvKI9fPOb04lrMj5Av6STsjGJ+k9eVotSAn/UH3MjsQ5uhaj28aLkBpRwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OBml6bvNrmqrt8oEeOyB0QYd4B3fg6+r0ce3wchHYj8=;
 b=DZKPW5v/Aelalgjqn4DJBBGOJfR+4E+Xz/pqb3bsQGaA8WrAhew+W/zE9ontMIHnWdGG81LAK2vhvjqrEDueyBQ5KN7oyHL8Lvyl1yNEBJjo+NfMn4jh6V+N9ie7aZCUEIHmPwjou2laZKHQ/zrX1qmvs0F4VzflwFBLZczXP7HtEM22tRQfmQSmWHhi3EGyLzcEkCIxEo8JpkqwNgYuTdrbORhLh8T2zm13OqP9ioCkmpcNHnaEruPuEGCh6G/B065ELX9vG9xaQBkg1S9yi7bopYO/UkDUS8HHKZsRUah1Nt9paeYI2779+5C+p5izCmHFkVXzpVBAppQriAZK8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CH0PR11MB8086.namprd11.prod.outlook.com (2603:10b6:610:190::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Mon, 1 Apr
 2024 08:22:09 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7452.019; Mon, 1 Apr 2024
 08:22:09 +0000
Date: Mon, 1 Apr 2024 16:22:00 +0800
From: Chao Gao <chao.gao@intel.com>
To: <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>
Subject: Re: [PATCH v19 102/130] KVM: TDX: handle EXCEPTION_NMI and
 EXTERNAL_INTERRUPT
Message-ID: <ZgpuqJW365ZfuJao@chao-email>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <3ac413f1d4adbac7db88a2cade97ded3b076c540.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3ac413f1d4adbac7db88a2cade97ded3b076c540.1708933498.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SI2PR01CA0011.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::6) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CH0PR11MB8086:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G2vgSka2vaSAvGhC2yxOYbOKUsEseb9O1/4l5uFi1dmsShKkyYbOrtZw53GNkpKvMR+DrGyGYn3Y+1GDf6OVWZLbebFs8EgloxUUwWpbYZA7SCUyfPHsGzIQvip7ffh9vv5huXnTUfVLOaM4iGigQ2qP9gCVHhJzhE5RATCLyvOVvMoei9DZ7p2sX9J4eU0/u6E4ZrtRM4edNMX6MrNQmn0BK9g6bgRrvoWmNO8evmszEkTgT1YlI4UUGhqErh08UYHoO2kfrSvJvWVCp68Gq2s+uD7RmnLf90zSky4cO09o97jc+Qv8y/dHQlUAK/P3Km3NAO9X1MejaBQ6CkOLyM5ltCtegCYF2zIYyZfO6Rjw7X+fjlyt/p1y5Ad3dpDg9wxlCzawd55hDJIxN62AIi3x9dihi9GSlOWVmgw8C1NOd2QwNMT0rXLpL0b2RM7WJ+6zu16r2Wo9uOVbPvN8NIAWz+KV5PcXcT3Djnnv1tVyMWZX/PrFR97bYDFpJHRFtBWZ4iWjrzU1QGtLsGAcp/TlTpALz87KgdUPl3WIq/3i87P0a5cAAKubSoyclhoz4QYWB1EO50CW+v+ug5adF7mdW7nQQvdYMSo5rK3ek/x1fdTbe3A4jt/Z30jOAZT76f8Etx+JZ9VuNX23mC8+5/SWKYm559QKJJUSQ5jgDxs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eezuW0uoRHEp62hFKREP+bsF6Zfy5G9K+PqMJKe28PCMp7TEXkSVHYTWaH0G?=
 =?us-ascii?Q?/MfOILWWC1a2+2hCiKwMf+54GROLsmn6fuDiUzm6B5npmzMy7anBl2kvSnPZ?=
 =?us-ascii?Q?MY5f8ChBbtm8FKYcWoqA9XQ+X8Bb+9JNX+X13IZWZcn/ZN5Hzfeb899dDjM8?=
 =?us-ascii?Q?JFGNZsx6vPL3FUHfxV6K+eP9YglorIxQObRQJGBQ8C2wABjxXl4Mq7csjUIu?=
 =?us-ascii?Q?urIXmRhtlGzV/BRlI2H24WGL+0lQvUXutIdEcftpgYAgIx8+92RNMTC07iyM?=
 =?us-ascii?Q?50w5hvp9d4bZIg1E8lsvqkuvmvNvPdPC2SsLOvyVRbli08boYK9cjt/SeTAD?=
 =?us-ascii?Q?8UPhCehGxfJOjmduD1foHzMwU3fTviCjQWuzvyxs9vlWOwQaPaYlRhfRT/Ed?=
 =?us-ascii?Q?b0IkDZ4af1GQkuHUDkrv+7WfLuhhmPQ7pj/PxumrNtoQo4PI2tgPO0y4RGAC?=
 =?us-ascii?Q?APsNS2WAuYVPaYZQ0wgTIaJmOhQQ0Jlr0DxZiauz3FDPowKZuDKtXRrrsuow?=
 =?us-ascii?Q?2ZaDGNBIhx/6ivQN6LkCd4lbhVOhGOg5GJetGkCOBTQMSqF2WFrnB0TeiYTo?=
 =?us-ascii?Q?t1hzytZ8rZAN9kETVDTDBRX0qZ5jLiJixAjrEXdj1+9vJc3MXUosglW+RYPE?=
 =?us-ascii?Q?tRVJSqdDa6F8p4bmzPKQ+YJkc+oSKu5c+Cn8U+LdhSXQKhfJY/jmkmgEvODs?=
 =?us-ascii?Q?b2lz5/mzrnlFkBRMjMWvo4iMQ4tipAFbDn2VgZNAOOG/GufObpxRuLX+QvU4?=
 =?us-ascii?Q?bEWXFCvBaUHAWP4cNmdnggUgatPLbkbgTyqL0k6aA0TlwUyaqDhCL70hSgYU?=
 =?us-ascii?Q?QSUYpZLmIKJbMSlF2lqBfIBEtqpqppFUL385hnFMSIBYS1IJLS+omU7e6jOj?=
 =?us-ascii?Q?tVB5V0qdTJJPwys2NO+lqDPtuY5Os34b7rv67MGhvfallEhhLUViyTGSIGmj?=
 =?us-ascii?Q?Ufap6l9DfTB21i+e0VAkYJ8Lb/XPRimuauLGJcEiJe/lE9D/KU+7If/AAaqw?=
 =?us-ascii?Q?G0mezJEqrcFleURUJslmAQ9msjpjkopnNpfUh4RAoPwQuCitpdJ8UItBRobn?=
 =?us-ascii?Q?sZtir5az8kr/RI9l+nA4zorj/lFkGNGioSOiD8xcbFYO0LEew45jz4k+76m1?=
 =?us-ascii?Q?C6VaOHqxjWT0WpW2dUt6MaCNkNlWcSVe7tomoFT4cnPddIQJk9BRnFCrEOqj?=
 =?us-ascii?Q?4aayUxIn0hltc13Syi/ngARDaz9pz0T/JZp5Z7ONRxRVaFUriChV8VLQe8D2?=
 =?us-ascii?Q?2yJOhFoOCiDi2U49/dGJKQNm8raKcqVb/+eZFPlrJLiBYmr0dS8NKvKXTa3h?=
 =?us-ascii?Q?OXWTxBmQPorVlSSyNWLltDBZE+NfJJUpiN25lloXOM0YM3r6CaDPRkJimX8i?=
 =?us-ascii?Q?kkCATyCsAteHyfQ7aGKj04gAJl1WCHiIjKuMAervO/0CVjqLmpJmxYgO0mpx?=
 =?us-ascii?Q?qEIYRWxLtczg67gLOzI5eMwdH1twF7yzu/a8fHkELt6pVjOBwZ9hEIRU9qFE?=
 =?us-ascii?Q?y57wxz0S+fVR7h89hBpjgKOUnP/zovVKEh+NFFwvmJs405x7Yvw4O58Qw87k?=
 =?us-ascii?Q?ROCfO6sml+rbx+7TnCInod9ivymqB/Hnw+UdWwb4?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e5f46247-37ff-4581-b676-08dc5224d32f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2024 08:22:09.6635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KRMauA317m+25dHC3nm0uf1Pgm+YT46lV+7zu/+SAAsQFTN7N6KrV83BgQ8z2zQ5Y/P+zjS74d5oakKfVXYcdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8086
X-OriginatorOrg: intel.com

On Mon, Feb 26, 2024 at 12:26:44AM -0800, isaku.yamahata@intel.com wrote:
>From: Isaku Yamahata <isaku.yamahata@intel.com>
>
>Because guest TD state is protected, exceptions in guest TDs can't be
>intercepted.  TDX VMM doesn't need to handle exceptions.
>tdx_handle_exit_irqoff() handles NMI and machine check.  Ignore NMI and

tdx_handle_exit_irqoff() doesn't handle NMIs.

>machine check and continue guest TD execution.
>
>For external interrupt, increment stats same to the VMX case.
>
>Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
>---
> arch/x86/kvm/vmx/tdx.c | 23 +++++++++++++++++++++++
> 1 file changed, 23 insertions(+)
>
>diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>index 0db80fa020d2..bdd74682b474 100644
>--- a/arch/x86/kvm/vmx/tdx.c
>+++ b/arch/x86/kvm/vmx/tdx.c
>@@ -918,6 +918,25 @@ void tdx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
> 		vmx_handle_exception_irqoff(vcpu, tdexit_intr_info(vcpu));
> }
> 
>+static int tdx_handle_exception(struct kvm_vcpu *vcpu)
>+{
>+	u32 intr_info = tdexit_intr_info(vcpu);
>+
>+	if (is_nmi(intr_info) || is_machine_check(intr_info))
>+		return 1;

Add a comment in code as well.

>+
>+	kvm_pr_unimpl("unexpected exception 0x%x(exit_reason 0x%llx qual 0x%lx)\n",
>+		intr_info,
>+		to_tdx(vcpu)->exit_reason.full, tdexit_exit_qual(vcpu));
>+	return -EFAULT;

-EFAULT looks incorrect.

>+}
>+
>+static int tdx_handle_external_interrupt(struct kvm_vcpu *vcpu)
>+{
>+	++vcpu->stat.irq_exits;
>+	return 1;
>+}
>+
> static int tdx_handle_triple_fault(struct kvm_vcpu *vcpu)
> {
> 	vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
>@@ -1390,6 +1409,10 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
> 	WARN_ON_ONCE(fastpath != EXIT_FASTPATH_NONE);
> 
> 	switch (exit_reason.basic) {
>+	case EXIT_REASON_EXCEPTION_NMI:
>+		return tdx_handle_exception(vcpu);
>+	case EXIT_REASON_EXTERNAL_INTERRUPT:
>+		return tdx_handle_external_interrupt(vcpu);
> 	case EXIT_REASON_EPT_VIOLATION:
> 		return tdx_handle_ept_violation(vcpu);
> 	case EXIT_REASON_EPT_MISCONFIG:
>-- 
>2.25.1
>
>

