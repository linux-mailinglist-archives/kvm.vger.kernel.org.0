Return-Path: <kvm+bounces-7086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4269D83D631
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:25:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7A9CBB25832
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:25:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBE601EF1C;
	Fri, 26 Jan 2024 08:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FGlKkciv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0FFBA53;
	Fri, 26 Jan 2024 08:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259197; cv=fail; b=sUdZdTy2/NJE0rkCET1POblf9QjIPhXdMuLr++FGZOiSz1Qbram58bFd/soZAB8M2Gj8j2DKwTN4S8Oye2T8oXVTqZ8bQEh09UoaM1cg+YsJHJvGOSnvpxVxJlyuG0adMReA2QRwCBsAWp2W0FGbOO1yenG2v84hFjWDEGYndaw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259197; c=relaxed/simple;
	bh=mB6nd6IOO7O5oMDObzA9YBmsh3E1NpT3rgm5i6QY6gU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XqCVYi3iTv9jDfPz7OkqNOyej+LUhsDYzq13qeEhjiOX8FP5npTylwFME9HQZlF9jlHpdXrecUBwRI674K6D09FJj1bQcgL2B2V05mVhTuKQsBQV6SsPu73HZy2bE8qs4ZQn2jQwACtsAKttxfWumU5fgKKdDVz63dKmV671P0I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FGlKkciv; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259195; x=1737795195;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=mB6nd6IOO7O5oMDObzA9YBmsh3E1NpT3rgm5i6QY6gU=;
  b=FGlKkciv67CxOjf24UdNw2zMvnR9tzhmS+Jz1DUIfsl52CApo7goe1Vq
   NsRZL+FldlOzkAmrtyxWgY2Of5WFobQrbK02Cz6pxOWQMhUo2bl/ADyip
   Q2RnYOei1p+oIEQ7izTFNWL+8CFKQ+NxxvPQOUe9ni9carbAoMGx5ebwx
   xYVHzhWSl9Bj2kIume2cO6n0YhtPA588IACnSyb+kii6Ez9awLfAuwnzm
   3cCauKvAVUs+M456PtkpEJfU09DXv2PYTmTG8pBCxHCBXLgBuABQtQ3Mn
   r1zHBFuzjQO5orSV+XYzzElwo7pAWb3HlP+/a8qRwAXeQc5KtDORx+yKh
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9081319"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9081319"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:53:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="28775413"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Jan 2024 00:53:14 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 26 Jan 2024 00:53:14 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 26 Jan 2024 00:53:14 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 26 Jan 2024 00:53:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hNTrD1ESLp0O4D13UlVzhPeGExtbm/0AhcF46nRe5ZkFtdVBe9U2yDG3eKKErJ2MO7rBOWwXti/qWqpMlAiynSJeO83WLVJkKzdjWIV8aio4YsDMBaiEbCZpsjwnRSB/sa5jj9OAu1lZOYC/I84feNPjzqRGA4NVhH94EVTdaqtZOBQRBz4g/KoI2pEhFDUwg4xiNPJ/djSLyVNe+V2u2qLXKBTZYl+Kig//jlNd95s6/Ei9fs33TQMHUG61dFVFZLJx3Sd+CPnvbfnsKG6TB8mll+oW+Q1S+U+uGqcjfnOqwAU+8AaUU9ppC+MW874xGzkjMgeN+Kvcbu6hCIn5SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Di7meIPl9U8Z5iL0vTY04z8FnjnyaGJiB7Y5n6hZEg0=;
 b=QAc76vRkWzjuAr+g57M/3QSpggg6v5A22cXacWoZPTe4zLT3OS3pmLDELvSdffQ1xpiK76eaj8ZOzVdbJlWlan/JymYLF88cRkwMDKh3d+zkA6EefuvCpnMumAQAoZtrcOcptUPoWy0SFoUnbjnDqjfv9BUWHsCribOr+xNciaKzLoJJBsguZLFpoRXXm/Vqq+hBUa4HBHw5FWon97/2gmzXwwOzBvWHRC+VyHdTm8JwB8TbepA5IXlTG9vtb0V4amO3GwDwUgYt7DJveIualzTkj+Ms7zL25QZqRO9Esean2wIjZRO75eFX2GE99Fu0f/AIx9+vxzqgflgi+xb7aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH7PR11MB8009.namprd11.prod.outlook.com (2603:10b6:510:248::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.37; Fri, 26 Jan
 2024 08:53:10 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::2903:9163:549:3b0d]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::2903:9163:549:3b0d%6]) with mapi id 15.20.7228.027; Fri, 26 Jan 2024
 08:53:09 +0000
Date: Fri, 26 Jan 2024 16:53:01 +0800
From: Chao Gao <chao.gao@intel.com>
To: Yang Weijiang <weijiang.yang@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<yuan.yao@linux.intel.com>, <peterz@infradead.org>,
	<rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>, <john.allen@amd.com>
Subject: Re: [PATCH v9 27/27] KVM: x86: Stop emulating for CET protected
 branch instructions
Message-ID: <ZbNy7TVq62JurQRc@chao-email>
References: <20240124024200.102792-1-weijiang.yang@intel.com>
 <20240124024200.102792-28-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240124024200.102792-28-weijiang.yang@intel.com>
X-ClientProxiedBy: SI2PR01CA0027.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::7) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH7PR11MB8009:EE_
X-MS-Office365-Filtering-Correlation-Id: 66926643-4aef-493f-c10c-08dc1e4c3890
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4teuHsn/3IvzFmJHTUNUSHanqT1uxc56supGOEm8ivk0T1xPYCeBoZNle1idmNQ3D8tbm3FV6PL4Z7JTc7If3fkUg6iL8rZYT/J4gK66nwwqxf+OApnnqn1sUg9MVgEcJ42U13Z2Voom6IcqyhE32NBZIeWoFoA0WlUuDVuBKH9tw2Dpf7VmsrkvOUQFuw6UfceIiK/EMl94diPaSlNXzHlhF1c62Z6j5NtQgZp1BFrsrKzH+0OtwRCL1RF0e3/1nbooqXuLdvyhjpfNDpiHYzaHrOG2fADwQ5LWv95e+Q1EhJfYMCFsmqHVwuaVhyXXPTeHm4lJsYm9S1JxAqBvFTGlo3z91G2Mn6Pcq4vPH2n6P5EiBoUDKWdjNsjS/+hCU5VSWQNS7+yNi3TD5lI1uddbbOoi7JLMHvWgamKAXq3UG+Kmdwi/QSPWkUktmNQ1iv0RKvobqOWzmrTd9lv9om1FddojIVShO8uR8qRowZqzaZXFiVcJozAA65euqloTPR2cUhAi4jDfVLulcXsWpHkgKG5xpPnK/3x2vvUZ5VrXLQrTT+yB1inThgF3o6J0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(366004)(346002)(376002)(136003)(39860400002)(396003)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(83380400001)(26005)(4326008)(44832011)(86362001)(6862004)(82960400001)(8676002)(66946007)(5660300002)(316002)(6486002)(6636002)(66476007)(66556008)(38100700002)(478600001)(2906002)(33716001)(9686003)(6512007)(8936002)(41300700001)(6666004)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rjPezKbgehuh8ecXpH/eV9rn1r6wqFBQjKQoUKDa866R42E5zobKFyLeHawg?=
 =?us-ascii?Q?Yk//wFP1Ibq3lD2Z6e5iXJIfCx2oVRwGRnokfpp+WKJPUlJmPU9fHyzo0g/b?=
 =?us-ascii?Q?iRrsVHKIbVvmW1zPvmrW3lbz2epZgifuv7SwakhYesn/xdGO5pHwyILNruQc?=
 =?us-ascii?Q?Qy/ZaqQ4Nl/fldEWbSrlVxXKQHFk1lUZENobG6MBtpNYN0EBk4n/4wsavR1P?=
 =?us-ascii?Q?MKxom+FqxeGbyuZTqPatkU40RY7rB+5iPUPulYyFjvo5Iljm5575LZo5srkN?=
 =?us-ascii?Q?G8cdqOSwoYuSOJvj6RBF/LKTrpqi4YEzTC1qHwuJpr6BJyR+D3LOYR7i32x7?=
 =?us-ascii?Q?9CtOFLNjZd8AjOdeAEorf3HarRlTqlaglcHvNBeudSyLLrn+wjOdprHzkEQB?=
 =?us-ascii?Q?6/m6PDPjlP7HznQu49ztIFWDxWYxbbseG6J2jErv1nPnbKTHbLtbab0d94nb?=
 =?us-ascii?Q?47bYOk+dUSRFNKpYIN++IdE2e+JpHqPXiL7r07T6k436nT3deG+nfpJwt/D8?=
 =?us-ascii?Q?wfx7yKzbN2HT+8bkOdxT8Zp09n6AYm2HUcErd9e/q4E5dIz7cBYl8o1VHnz3?=
 =?us-ascii?Q?MaubFoCZplYeqrtL44YoeChS2eauE4qM830SEm+vP01NBfdTIqUxJrG685n/?=
 =?us-ascii?Q?Zl/XXAx7hwfaR/Jcy8Hs56RFmkK8WooRilRreFKZp41VMTt9ZF4yRmcFmPz4?=
 =?us-ascii?Q?Ge4chh+18yZVBJCOpj2mp6DbnOiFhILi8CtQGs3cuY7xkCknVa0N29rn/Pgl?=
 =?us-ascii?Q?LOQpadi36zY/bIb2BSSmGN0FGAlcoM8BpxOeVjyaSYTpBTV2Ny3rVIapyMBn?=
 =?us-ascii?Q?QONnbd5So592dLsn+9PLR1oaQKDiSMbb7k+QxdzBXnVk/f5ry1EFJ+7nuXeh?=
 =?us-ascii?Q?jouQhvZpFeaaxn6lji0jX/ghjr8IZRoYAHdYdDbjLfNSkoy/rHetUf035Bvl?=
 =?us-ascii?Q?cpBIiPudpwtgaDS72fjuRhi8adHImUSWkdbjBD64QZe16+3NzeCPSgMNJ5hd?=
 =?us-ascii?Q?+JIlHGNgBfeBR1InoFdfllfBsPaadAsAevHM2jy0vqP5p1O/fdQERcwnsh9a?=
 =?us-ascii?Q?i1C/g3jWOyuR+AWE+wxstJGwlj0hULHMm2Od9z2N6OvtwUq4eyx/TrTmoFzv?=
 =?us-ascii?Q?QVqKz009PJklQZrz5Q72+sKaNUmvVuux48AEDI33GT5pRbEV8XzaRaGRLhGo?=
 =?us-ascii?Q?757K0zBDqd+SEtEqjFIIyMLtbdoMSId7L00XKvO+Ecj6lbdh/hHicvx0etYu?=
 =?us-ascii?Q?TE8/fzHkd4sPQcniWLr53qd0LFNeDBwuc5om6uSFycgBOvJuiATmzVGnFfo1?=
 =?us-ascii?Q?C+ZLgDDKM7L/nhxyAittbJyPH7Lr1Sc/JMtEH6dcDek2itOcDlWvUJFWkHCe?=
 =?us-ascii?Q?8fHlPYIfPpJHrxLwq6Vr3duqXYsuDKuLnh7XECPtKp7jKHGJlH9FSgX07p4z?=
 =?us-ascii?Q?c7hN7BuGU+dG57byRedJ7qyOWrsVCfdym5ZoG0ccpqlGYICRnX55R4719Lhd?=
 =?us-ascii?Q?TOb5mFuKtAObHIDsXxWM9lzjCef9iRXfZtNNAbm/r4IbaiY9c7ogwvJVPJpD?=
 =?us-ascii?Q?BC44dJuiJ5Z+oQN8mCq8sGN7NsqenaCgGZqb1nnM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 66926643-4aef-493f-c10c-08dc1e4c3890
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 08:53:09.6308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2oXdVllGdkRQ6DIazObD4N6FL+BrJiHTKO6CdAF9/S2iwKXWGvxkz3MIysSYmSOpZJv1lFhim//lxoMstvf60w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8009
X-OriginatorOrg: intel.com

On Tue, Jan 23, 2024 at 06:42:00PM -0800, Yang Weijiang wrote:
>Don't emulate the branch instructions, e.g., CALL/RET/JMP etc., when CET
>is active in guest, return KVM_INTERNAL_ERROR_EMULATION to userspace to
>handle it.
>
>KVM doesn't emulate CPU behaviors to check CET protected stuffs while
>emulating guest instructions, instead it stops emulation on detecting
>the instructions in process are CET protected. By doing so, it can avoid
>generating bogus #CP in guest and preventing CET protected execution flow
>subversion from guest side.
>
>Suggested-by: Chao Gao <chao.gao@intel.com>
>Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>---
> arch/x86/kvm/emulate.c | 27 ++++++++++++++++-----------
> 1 file changed, 16 insertions(+), 11 deletions(-)
>
>diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
>index e223043ef5b2..ad15ce055a1d 100644
>--- a/arch/x86/kvm/emulate.c
>+++ b/arch/x86/kvm/emulate.c
>@@ -178,6 +178,7 @@
> #define IncSP       ((u64)1 << 54)  /* SP is incremented before ModRM calc */
> #define TwoMemOp    ((u64)1 << 55)  /* Instruction has two memory operand */
> #define IsBranch    ((u64)1 << 56)  /* Instruction is considered a branch. */
>+#define IsProtected ((u64)1 << 57)  /* Instruction is protected by CET. */

the name IsProtected doesn't seem clear to me. Its meaning isn't obvious from
the name and may be confused with protected mode. Maybe we can add two flags:
"IndirectBranch" and "ShadowStack".

> 
> #define DstXacc     (DstAccLo | SrcAccHi | SrcWrite)
> 
>@@ -4098,9 +4099,9 @@ static const struct opcode group4[] = {
> static const struct opcode group5[] = {
> 	F(DstMem | SrcNone | Lock,		em_inc),
> 	F(DstMem | SrcNone | Lock,		em_dec),
>-	I(SrcMem | NearBranch | IsBranch,       em_call_near_abs),
>-	I(SrcMemFAddr | ImplicitOps | IsBranch, em_call_far),
>-	I(SrcMem | NearBranch | IsBranch,       em_jmp_abs),
>+	I(SrcMem | NearBranch | IsBranch | IsProtected, em_call_near_abs),
>+	I(SrcMemFAddr | ImplicitOps | IsBranch | IsProtected, em_call_far),
>+	I(SrcMem | NearBranch | IsBranch | IsProtected, em_jmp_abs),

In SDM, I don't see a list of instructions that are affected by CET. how do you
get the list.

