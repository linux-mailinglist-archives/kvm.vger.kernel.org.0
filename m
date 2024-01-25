Return-Path: <kvm+bounces-6998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BBF4D83BE78
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 11:18:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4906B1F22BE9
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 10:18:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE4651CAB7;
	Thu, 25 Jan 2024 10:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Znirczv+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BA11CAAB;
	Thu, 25 Jan 2024 10:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.55.52.120
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706177863; cv=fail; b=MeUmjo3XG0VN+ywe1IqmHB9XUN5R74OQ4qFLMRmV9+BFuJXDJgNilo99rxg/jvMpltec5ZcD+L/hW9XSQaHoAsk4SNL05zLm+s+q3P6CDhXEZXuDbvb+Quha2fIXedSSLLInPmrQzn5gZYRDtFq4M/XVG+qvyjsojuqViuFN9m4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706177863; c=relaxed/simple;
	bh=AcTACSvztMn0jgIxSWqWw4J6w7u/HhJWHupinlFZ4PI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NXx9rGYE1wa+OHgUAag1zrkIGj2tvlgs633S5mgW/0C0EXKM9vDdMLBOGRkDp0YmNvUuAM1Xv4RSJ2nC7vEtLx0sbM85m42XxD2WQx/NJsu8uaTr0sgLagpD/l9ns58jVfpzwQSFMQTu/Q1G23pJf2elvO5XVxTJJti2oDlgWqo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Znirczv+; arc=fail smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706177861; x=1737713861;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=AcTACSvztMn0jgIxSWqWw4J6w7u/HhJWHupinlFZ4PI=;
  b=Znirczv+prjO62CLRQYP/zGVElAOewMEy3lkRuzL+4RA1C1xx3uPZpmY
   3q7wp6DBjbIv5Cl3dEWldq50cYJd9lXYcSFjLT/M4SpVuoeL1aFRsGtNr
   153A0h5EoW6VzfBMiLWMU2rUPeE78pQbnhI8VK3ixkIk5JEFL9vvZVLMd
   2pSAweRm+cSHPqTfAk93S8K6Jq9re3aKGSsGZdtonzcDe7Bn0F5zwbAlk
   zeUjei5ICMCdapM3AWX72Xsk6Q0gHWBC00TL3WuQ2fB88boGKS5nMyUDY
   gDtytx5DVaouML/EJOHBJz1SyOu20PqKfvzEildXe3tGSDAjE5Pb68HAT
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="400977363"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="400977363"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2024 02:17:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="909952390"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="909952390"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Jan 2024 02:17:39 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Jan 2024 02:17:39 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Jan 2024 02:17:38 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 25 Jan 2024 02:17:38 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 25 Jan 2024 02:17:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S9cJSiRveV1sG9zsVpWxd2zTLqRXmBl2xrbdQ6qHdFgBqLqpBBtKpzBwSPiR4hlTs/mR8vDU7erfnnZXKxZPQp2wxXtFf1a8ugo//9sR0nhx9j/8Uf8vv/30HpTsGBdQICSA20PBNIY6tv96CegMsGJ0cJ+qIP3pSu6dLS0N89x2PBqoAtLyTDl/DQ1RVzDfxbUhd86FdAEFY04PiKfFo9HfuOFyXzKtGTPMbKTQQj3Xqjj/VNLVoy/6Z4ubuvRz4pz8OJA+YMFJsphsgs7R9g+paZKTvvOJIUGovs3uo8zTYwNj3xIYctFo5ng8mSqjOQG5ojwm1dJUxbOsT+QbbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=htJr0fnSzt94mCg1LAu/T/P85yBR0YML4AOtJdO3cQ8=;
 b=PnGtbfZvM3CLxJ/ZNJqz5DAAUeh++pKjbbmCFEmIq1RJbtUsBu+gJ/0Dn9CkjbdMThrSdYucvXNhVCES0emw4bDoCME0aW2Bnao4o77+EwI22H7uoSOvrPDxFOYG0LXap117yfc06trIQmdu1A2MFTTijpDQsiraaXlhpThby09nJfc7G0nsE221Vuk6GmyrNd7cSg8QonXnO1nTtD9iWOdiNp10gocGSh1MEFPSijemRDIOKl6DfAAp5gMvOCElOX7KWIPGeS4GidvWSp7pu6StIcP6QMFRsjHMhtH5haqwcvtAYF2nyjdfZqPUC3yF15lkID6W81KaVEbCW6HAVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CH0PR11MB5268.namprd11.prod.outlook.com (2603:10b6:610:e3::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.26; Thu, 25 Jan
 2024 10:17:37 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::2903:9163:549:3b0d]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::2903:9163:549:3b0d%6]) with mapi id 15.20.7202.034; Thu, 25 Jan 2024
 10:17:37 +0000
Date: Thu, 25 Jan 2024 18:17:26 +0800
From: Chao Gao <chao.gao@intel.com>
To: Yang Weijiang <weijiang.yang@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<yuan.yao@linux.intel.com>, <peterz@infradead.org>,
	<rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>, <john.allen@amd.com>
Subject: Re: [PATCH v9 10/27] KVM: x86: Refine xsave-managed guest
 register/MSR reset handling
Message-ID: <ZbI1NqPLpnSZc6g9@chao-email>
References: <20240124024200.102792-1-weijiang.yang@intel.com>
 <20240124024200.102792-11-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240124024200.102792-11-weijiang.yang@intel.com>
X-ClientProxiedBy: SG2PR02CA0099.apcprd02.prod.outlook.com
 (2603:1096:4:92::15) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CH0PR11MB5268:EE_
X-MS-Office365-Filtering-Correlation-Id: 19c8df37-de2c-40e4-4090-08dc1d8eda79
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /bsvGBOcnCkMPagKVEe1NAf473HFWa9Iaq2asyMsIeEJSmQiW0ckuX8PqHyDyLwbo3Fod1RNj7ypiL9IKO6uKwBrGaygNHQGZIe4fP1H2BrxjpOYCsrC1zYf4d6+Z1e4N/tR+vAijwZYWTqA0BbSfvgboLj804gpYXtj2bzzw25KAF8fw0rFEZALT/EK5O5KSem5bwKVy23gvC3cnjTo191G2nqPjGIvMSm15CFEmN+QGRmIQnVVoPcpK0bMACsaXBoVehVXuhxfbIycGXjlHubGuIWlR8KuEgn5xD6brXLf9HvrxbhTBFLntSv51DMZPI/94v5nBIDgY/6Lmz1xHuWMIgM/4m7QjhTnXgsI61s02b+6c3O/5JYKsBqt/mxm99sabBGXq0gAc6fYmiGpoQo8zlu34Ocff/iC/fQ8LgALAc0CBboiiVzGy24mNSGa8iGYQNm04wK65LfsyM2u4FPO2MI7xHUGJrajqpZQcCM64DPWbuXCFfXbVa1OUvnmBYaOdAZTfduXmbBErL0Vvo5Wp6Mmf98RYuC4AvuTS5ZnfBOoUbpiXJZY4MtckzSY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(376002)(136003)(396003)(39860400002)(346002)(366004)(230922051799003)(186009)(1800799012)(64100799003)(451199024)(83380400001)(6666004)(44832011)(9686003)(5660300002)(8676002)(6862004)(66946007)(6506007)(316002)(6636002)(66556008)(66476007)(6512007)(478600001)(4326008)(6486002)(26005)(8936002)(38100700002)(82960400001)(2906002)(33716001)(86362001)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fGiVdarBTanZGBqghcUtt+z/17j4C3HfJ4d8dZJ83ehMA97Uv2Pr+1Iel+U1?=
 =?us-ascii?Q?wSVeiCT2ctNYVhi9O4uY4FKjmJsshYA2I6F5JgpV71mSWrIavDRCOoqHWhGn?=
 =?us-ascii?Q?dhkToSham2eF2LWfG5hgrgmfNUR4LOij8c+6qwUdHingO8BHlPspYT4R9tbH?=
 =?us-ascii?Q?UabHBaOHo5Ym90vymJqsnk+yAIbPiRGYAENAQAiM0exYKOtx+5PsjRPPah/Y?=
 =?us-ascii?Q?37r4RQVPPYFuW6QALzNsjXj+NeMlorcapXN7J0sVfwLOzHkFgEqOkQHeyAxv?=
 =?us-ascii?Q?wtPawtxwaLp1CHLiCWzHKvem0B6nxipxmNxiD+PgNgLHYX7s4GvkxBYfu7dF?=
 =?us-ascii?Q?7m7/ni1RaG14nWXxh3i8XbPgSWzilOArWDjS1j9gs1DuA5IIqHOZv3a6ptH1?=
 =?us-ascii?Q?YnkYuU4dAVSz9aN7zejV72EWDIzrc3bojoQ7/fp/WrhH3grWeG4uw5sGn6ol?=
 =?us-ascii?Q?KKLgh34yEYzQ2j3TEd+1Q/jMSk4fCyvESLtsynWaFMtQ0zAaWLEA2A1dgS0e?=
 =?us-ascii?Q?DMAWnz0IqgqIO4l0+4oRrB6FXgTbkKGxUgrOxMUVs8NavchtnIBLHZuuUE3H?=
 =?us-ascii?Q?wnO0NCG45FvvwN1ySXVkwZ7brWVzR+F4VxyW7onnm2VVYHRMKaraLfHGFrw/?=
 =?us-ascii?Q?BhzRdZP4/ZVT0rVcW6aJi6puh7WIa3b/yOKuKHrz0BlGfrrcFS5eIsss9EW1?=
 =?us-ascii?Q?wDPva5C0x0z5hQlaxIurVpRrRjmWWO7xBBfm9J+5qqsH35eN7UJOeU+NhC43?=
 =?us-ascii?Q?vc6o4IUbGyoIpE6dcs4OCRDAZAHn0swQfvn5hjYr05nSoRwxcagBUYbZB/sp?=
 =?us-ascii?Q?OjA5BNR4Ywu2RuRc1vP9OSeRb5wioNlc1PueRyGRR46P9JlWnbMREBLFwdbI?=
 =?us-ascii?Q?Wh/MC+Ns0OOGX0Q4v+QTA9dTFr4UXIKYmnPy5WQ71KVj/6H15zVkERpnNRUL?=
 =?us-ascii?Q?dmUtTzhiBpMwdtGUvWc+6mRxJACc/gyzO7spE5YbsR6ZBvExGOL31bXV2cXd?=
 =?us-ascii?Q?brSNk5yO1kTgQ8si2Zi72xyfIrkoUzRMXF5DFbzX7+ayRljeLKh1REGT3/DW?=
 =?us-ascii?Q?po/rZeS5k5lYhKqPTqASLeoqphULZhqowcFbdW6QtshvrBRr8SsgOsnZ4rMB?=
 =?us-ascii?Q?FzrK1N1sGtkS9/xIGwYky4rnQ1HG6uOqFhwcteR62YaOcpJt9d8F2ePsCsGi?=
 =?us-ascii?Q?R/z3XKFXWhSoI2wxDpRWfeS+UnhDeYwC3D+cThcW9fWmZWoQJXHyaFfk7Uw5?=
 =?us-ascii?Q?W4ab+BnVWEZmQb0pcXy6cvdDuSIuu8lrHTXRXS2PjMLyExugFJ4lsPl4MrBa?=
 =?us-ascii?Q?X/y8IqiWNKJp/dsz/ufFJS13tGqEdraZpV7PyFUFA/T1bV2lI7lN+4y/j1bS?=
 =?us-ascii?Q?k5bBHupF5eQivU688BPWMaa4zoWBaGcuEA3h6qMsSWnqMFO5g52LJ+0qXRUA?=
 =?us-ascii?Q?C7JgoHg8vjG9sJkQCLYpFd+66nnX6o1HvfOdaLoX6VqUCbbmqsYoc4V+53Ha?=
 =?us-ascii?Q?7s/DJSzvGmSHAyB8FZRuEyB7/PAS26KCwvytSgWfkTpj2ADybNNSo6LzPC0V?=
 =?us-ascii?Q?MDizXRcMoX59QK/8k3QTO6UStgzXMfKuKz5l4YKN?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 19c8df37-de2c-40e4-4090-08dc1d8eda79
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2024 10:17:36.9557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p8GsQgCSPJIyTWH6TFe22exOuU9cKiqUryM5GGHbbW9k7ZcwKTnCyiKwzZ3gKSXeSRXjuIrdwlsll+KIHRVMAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5268
X-OriginatorOrg: intel.com

On Tue, Jan 23, 2024 at 06:41:43PM -0800, Yang Weijiang wrote:
>Tweak the code a bit to facilitate resetting more xstate components in
>the future, e.g., adding CET's xstate-managed MSRs.
>
>No functional change intended.
>
>Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>---
> arch/x86/kvm/x86.c | 15 ++++++++++++---
> 1 file changed, 12 insertions(+), 3 deletions(-)
>
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index 0e7dc3398293..3671f4868d1b 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -12205,6 +12205,11 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
> 		static_branch_dec(&kvm_has_noapic_vcpu);
> }
> 
>+static inline bool is_xstate_reset_needed(void)
>+{
>+	return kvm_cpu_cap_has(X86_FEATURE_MPX);
>+}
>+
> void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> {
> 	struct kvm_cpuid_entry2 *cpuid_0x1;
>@@ -12262,7 +12267,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> 	kvm_async_pf_hash_reset(vcpu);
> 	vcpu->arch.apf.halted = false;
> 
>-	if (vcpu->arch.guest_fpu.fpstate && kvm_mpx_supported()) {
>+	if (vcpu->arch.guest_fpu.fpstate && is_xstate_reset_needed()) {
> 		struct fpstate *fpstate = vcpu->arch.guest_fpu.fpstate;
> 
> 		/*
>@@ -12272,8 +12277,12 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> 		if (init_event)
> 			kvm_put_guest_fpu(vcpu);
> 
>-		fpstate_clear_xstate_component(fpstate, XFEATURE_BNDREGS);
>-		fpstate_clear_xstate_component(fpstate, XFEATURE_BNDCSR);
>+		if (kvm_cpu_cap_has(X86_FEATURE_MPX)) {
>+			fpstate_clear_xstate_component(fpstate,
>+						       XFEATURE_BNDREGS);
>+			fpstate_clear_xstate_component(fpstate,
>+						       XFEATURE_BNDCSR);
>+		}

Checking whether KVM supports MPX is indirect and adds complexity.

how about something like:

#define XSTATE_NEED_RESET_MASK		(XFEATURE_MASK_BNDREGS | \
					 XFEATURE_MASK_BNDCSR)

	u64 reset_mask;
	...

	reset_mask = (kvm_caps.supported_xcr0 | kvm_caps.supported_xss) &
			XSTATE_NEED_RESET_MASK;
	if (vcpu->arch.guest_fpu.fpstate && reset_mask) {
	...
		for_each_set_bit(i, &reset_mask, XFEATURE_MAX)
			fpstate_clear_xstate_component(fpstate, i);
	...
	}

then in patch 24, you can simply add CET_U/S into XSTATE_NEED_RESET_MASK.

