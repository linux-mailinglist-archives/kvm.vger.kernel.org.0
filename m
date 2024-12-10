Return-Path: <kvm+bounces-33401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ED4D79EACD9
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 10:49:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BCBC9290679
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 09:49:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0682423A57A;
	Tue, 10 Dec 2024 09:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XbxX2OxH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D8B23A560;
	Tue, 10 Dec 2024 09:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733823801; cv=fail; b=diz8rP+luD41MY7D76NYWiEC6OM0vWgoTAoq3AZxGqd34C309ZsuPyBCmoUVMxB6hODA3hsX7wvRzcUY+4BjPKYspsW1wmrXLeKPjnBsiebJ6zwjcNpu4356NokyUZwoz6mgy7xGUuonjFA0vQGerdfzfcdRC1TuJs36rItaROI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733823801; c=relaxed/simple;
	bh=vwTITxKIRY1xOOTJCRapZRQnr3axA3qegfdm5yCYPug=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=F0UVduxi5yMh0CbLVeH6WCJwrRAnAl6/3T4CKWYf+lmj4zMRocLeP1APFqk5/GKEvEk/K/q5hEVYO3oVk9sUjitEl3gu74xqv5BuFSOc3GwDUzWHXaqrbjQ+GR/NzKu3R0iUVy0qOucEwC0pwyAcI6gdGrYuQkXFZUN5I6YrKTQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XbxX2OxH; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733823799; x=1765359799;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=vwTITxKIRY1xOOTJCRapZRQnr3axA3qegfdm5yCYPug=;
  b=XbxX2OxHseNP0+Jiwa6hE9OPWmkz6qIUtYJabkbgS9U+ZpI9Ozmky1f9
   A0kmgm0bBe5pN/Cdpq7v6WCyw5DO0GPPJTj0Sjszv3dQLDQqpmkGtwv2b
   2AUlrEiLUUN60jSlIa4hrt7M0aJ8PNDo6AwxGjbacIA5Hqdue5zgNQhjh
   JLelbSBecQis32o4/3CEf/BZ8rolBfB49zBZVAEITHvfyxmJ2bsf6dgX9
   mbbrq2KwQi3UHftYEcsQ99x4U+DvIEHrzBsMYX8ADzYs/MNutBSo54UWF
   DANjOkrjUX/POfVnL4PWn+hrDmStx/64v3yNgFCTkHeHJoyI4q09mOxdq
   A==;
X-CSE-ConnectionGUID: da9eL+K1SYGiuiPAyhoPdw==
X-CSE-MsgGUID: aS9XdC4rTHCVgkdh8jfuQg==
X-IronPort-AV: E=McAfee;i="6700,10204,11281"; a="56638074"
X-IronPort-AV: E=Sophos;i="6.12,222,1728975600"; 
   d="scan'208";a="56638074"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 01:43:17 -0800
X-CSE-ConnectionGUID: QZG5zawpQlSThvoGfhBIng==
X-CSE-MsgGUID: rfmxhsV1QpOm3EQ1Sf/oig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,222,1728975600"; 
   d="scan'208";a="95187456"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Dec 2024 01:43:17 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Dec 2024 01:43:16 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 10 Dec 2024 01:43:16 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 10 Dec 2024 01:43:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LvdvuQSTsAT0Elh1Vr1ew+JIyR/Arx+lSVqNxuglcn7LlI6qJE8Q5/9aUMt1aDjpRKgD2ZVHe4CnWjbuKwf0BqZntQTJzrvpLCGgdwitQEyjCVwR0g7GBGO/pnea0rxwvr/Z2yRP+k6qzVF21fAQXmxRL48IP/JGgkbr/kAm/t+z1PgqQ1lx/QE8rVEIx95FOXbVjlb/mqfAkDhAlY19Q4hvg250qakf8DMwpVNgzEPdeHsAQge/jghffoSD2NHWzuDpjtec6RdE1gLmqKwcsLYEpvK99MHgFfu9mFCa5h0f5JR/b0t1CPBB6rJGY/uYsdXH1ZafAU+9jsjqkH7OQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3wbV0CHQn4Y6Fn2BjBIjnw6ckEalo85ifhOy0vwTIxM=;
 b=hTadOv3u+YIQ2aylzLQCJpz5uGPOliqJTWpN657DWoOjmt2oZAO94ef+WKrMz8kBAwoogM2L7GBvqbZLLBWlIJYrDKoktL5xPkGzs8CETfNDbpB/Kjto4q/1ZUy/3p3bd9lZNpPsFJmpg9Ktl315LP7Zc/8eFFsKtTR65wIHfnuVnXhKQ/6bOxPsdqYjV92Mvhkt2g6axtH9oCqNvnSw+irrg/Ab53UncJmbqP8nN00EIyJRpfYzCnLJp2FNwlCOmr2Kt16h3KyWTGhP0pSUwJIObWcmZK42IVowxPo8XShSp6fsTWK8Ko8osNGL7OzgpNlMLINTlccflox/MjWWCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SN7PR11MB6900.namprd11.prod.outlook.com (2603:10b6:806:2a8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.14; Tue, 10 Dec
 2024 09:43:08 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%2]) with mapi id 15.20.8230.016; Tue, 10 Dec 2024
 09:43:08 +0000
Date: Tue, 10 Dec 2024 17:42:57 +0800
From: Chao Gao <chao.gao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kai.huang@intel.com>,
	<adrian.hunter@intel.com>, <reinette.chatre@intel.com>,
	<xiaoyao.li@intel.com>, <tony.lindgren@linux.intel.com>,
	<isaku.yamahata@intel.com>, <yan.y.zhao@intel.com>, <michael.roth@amd.com>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/7] KVM: TDX: Handle TDX PV port I/O hypercall
Message-ID: <Z1gNIRWSMy2w7CYp@intel.com>
References: <20241201035358.2193078-1-binbin.wu@linux.intel.com>
 <20241201035358.2193078-7-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241201035358.2193078-7-binbin.wu@linux.intel.com>
X-ClientProxiedBy: SI2PR01CA0016.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::20) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SN7PR11MB6900:EE_
X-MS-Office365-Filtering-Correlation-Id: 26c90e88-5db0-4b65-3451-08dd18ff0dba
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?G25s0fqKeYSpV60c1ATbWc0Ary2jyR2+Vw0V+aL7kt2DfEGYHzb2Y/iZWUW2?=
 =?us-ascii?Q?cGO4iyUj0FNS9T4DiIfgjG4ryGd2Zw0tebhiMiLTY6fsoOaeAWeoF/4Mh8Zq?=
 =?us-ascii?Q?QD/KBKvX2+iqr4wOHM9vblco8tBRHbeKwRSwM0pPVC6/AaAjDAv7YhbXvhT4?=
 =?us-ascii?Q?oLzaJYRpxE56aFG6RQQQrAG0vktxE6RdIjTOcx58wt5jN8MSqWFmeQcIN0lO?=
 =?us-ascii?Q?JXtu8DMHUZ7hEQCmZM/ctp/c8iSY9zRUWJvpJct/aKR9T5QM93TsGDEksl2a?=
 =?us-ascii?Q?TTnrG2XtRXBpsuhpWPjihIGCouYfNkdwzxJwPB0+KXynHv04S0nTMDI1xMBz?=
 =?us-ascii?Q?zn0rBzlXxcP2gGBI4GeLlHc9wdqsIYjiLFSU/wtMCdXlWa7IxqfysBM38zCf?=
 =?us-ascii?Q?hxve99aK2pI7wGYZpUtFqZn83yRGgaimfvjd7iPufvg8RN9lJ+Jpq5+YiLK2?=
 =?us-ascii?Q?EE5qAozC/V2LXZG/T4GK1XNpE6IySzLiX9nYNtf66jexut2ItHrWxooJ0mbf?=
 =?us-ascii?Q?sNQEEoIBBvrnzkgNe9SjjpDb8PqDuqest2fZeXs5kF23Qf8Y9PT7UA/1R/c3?=
 =?us-ascii?Q?y1KFCBPCb+tBbGRcntNJYe7WnDJv2HzKIQ0KuKNk1o4IkDhnFMb7VpEjDmyb?=
 =?us-ascii?Q?Y6ECkEPKGaYSZHYTXN9RUMFOAgBSjKQ6QgEuOYNXoQbvEi31nKXICAY9JICI?=
 =?us-ascii?Q?Uy2bqI4GR2q21bKiJ6SOL7DpAQWLTSw9hacIxBFrf4oKV8Ce1/+XOlmjdcke?=
 =?us-ascii?Q?WY0thFKSjRm4Z6rS85hoMT1j1czVtDY1dBgt5TkBQTGHrqFwkJy9RBRlz1E0?=
 =?us-ascii?Q?9MuTPZs3nJJi5oGDVzN8g1UYjEyZzwVTKBnBZVv9EB3kony3yBe0jAo2A7C7?=
 =?us-ascii?Q?ZhDfACx2b2IV4a0tM6IjRF531nwNkvwzsHFQXLoQo1qp+ZvZZxcp12UBSTmB?=
 =?us-ascii?Q?I00vzKjq9slwBdP6H3arbrAaYpYcqjPsYktzeGqRWtkY6Pdiij5EmYrcQ9mt?=
 =?us-ascii?Q?AUrFdcuGpZSuBGeokkzfHOxCh1Nd4fmyrZP4SsmRmWMJ0LFrlPR/M8eLFb1G?=
 =?us-ascii?Q?s+SamlELmJlntVijTkTKvyvXnoOTnJxCZirmhGz3oaJSBbnX2ZXptxaFaSmV?=
 =?us-ascii?Q?1Nq1DgaTyo4Mv5ikTKBZogY7cFM/9PO+NaBL3HXEolof5DVopizaOrNLPhi0?=
 =?us-ascii?Q?3sUy104lm+kpivrTFYF1bsXwnaNW/zyPizcNzlk2ICww0tuUDZCdmcbdtDR1?=
 =?us-ascii?Q?nDiS6aw2JE48pIVSivk3G3fKH7ihLAEvas7PmFXVqPqU2+c3ToJ4dAGgpc9/?=
 =?us-ascii?Q?G5RMVsdej1jxSxiQaV2PEVQTRPJgiAC/dPN+FHa9yF/wUA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0Lip68Px/1bMGu7KH8cCElZ2TtyJ4D2BBlkqV8jqj4KZHDgm52iTzHMltjDa?=
 =?us-ascii?Q?J7XwaC0XiXyOkm8u9/loeO1bJA5Qh6TzyLYs2Xz3evzyFNc4HFqchhfIM4yq?=
 =?us-ascii?Q?zioLXG41UR9d25FEAP9/tdwlbTD46y0g6k7wP77crbTy+DQ5XO7c0/nEVN+s?=
 =?us-ascii?Q?BrspVeXCzTvZKoIFkme685ijeYet5IoM2Y2QRuNcfqKN5/SqX1rtzhQT+jj9?=
 =?us-ascii?Q?ZxSoHKK/VFwNRNRKYoDKSyxCSobuwonTp8RNnL79So61d2jvgdwGE5pPzlK4?=
 =?us-ascii?Q?VE1a/OW1nlXf0uLxB9u8weANa9hmXEdHqNTBq1LlctdoPHc3tZorL9Or9RLN?=
 =?us-ascii?Q?kq13nTdsHb1CR/gRA41ARhc6eC6GeLuWmwg3Pr3+ihcAQAFGBZxe5YX4Pnzc?=
 =?us-ascii?Q?i76jQKLD4ZpAE2mt4tgB22DbQttwyw5DTvIqyACe+EMuZPCzJfF8HfdfxZeG?=
 =?us-ascii?Q?rp1AnorkubrKT7u8rzGdwtkBDmL1NGR9JyO9zIT4XfByx5XNv2+W5funs9Ah?=
 =?us-ascii?Q?hgbJZmM3wDSlSBgJ8FO9VZaduet0WhAa6YwsMMuo5OBSQV7r9iNQ61tEytaa?=
 =?us-ascii?Q?VOpx6fc9nQty0z74KNh219tvRmuXLZ60/dooYRnP30aB9j6XBV7Ooa7rOtzL?=
 =?us-ascii?Q?IYEm/z04sUi+l6dtcr8KB5cIe9twdsagOcaUBxlRE5DZ0gjnVBWHeoNX0jra?=
 =?us-ascii?Q?MkxKlF13LeWy+hWUKlFpixpnr37zhBdEv31UvriG8b8xijcr5L/2kbLPn+nY?=
 =?us-ascii?Q?ae16h1jwtZq+L2Pf9XgoqtlMW3wx8UQx/+4TuiRaqOp9lVaktOU9VV092E8o?=
 =?us-ascii?Q?NCKgB5Z9CFtEXYNTayZJZ3xyMy3XR21S8iywz3KqWNEYYAaKg58quEzTu//r?=
 =?us-ascii?Q?P0upLxTBId2bFVzZIG1QU4Cfrjyn845ur7jxYwnGlsDzVZ8/iTxg2D1IriAy?=
 =?us-ascii?Q?fcYb/+XoVsC4oAQUFZ2liaGHuRXfb3AHNiGI58g0MwI39ORz9AhyKkToMDXO?=
 =?us-ascii?Q?0XXzkgAP+7Af6fQSdNTur910s2cm23VInJ3YdXlyV8V2YAp1TGZ3VE++SxFX?=
 =?us-ascii?Q?ANzdwCRt2Vp1OEJYLnMPXcyZIYXE2mBmtxhlxDWNp/VuVN+f/3s772eFIgol?=
 =?us-ascii?Q?auE4DqannZM8dVR9xFblsICNi9eu3bFw6AnTKVV2ocAL/CLJ1QKr3YmPDDLb?=
 =?us-ascii?Q?CxK4560eexttkrXcDaWmQbjp1Wv4jJ1VGfwJSv0KaJQZvSWB8Rsicag4aN28?=
 =?us-ascii?Q?yoGHt1Kwm2lBsZh0X9lVKFbFX8RKacC6Cg65FzRcTIJmaky/9vHdYpGOtAR3?=
 =?us-ascii?Q?odCNSwS+ZUjDp0rVRe55Kb10QVrXvFI4tpW/Wq5E0ICObmij2C5NiM4Hu9E6?=
 =?us-ascii?Q?xH1CEunnpu2CrIv/Vt2jCspp2Y4vP6YUX3XUFZ9mGxFsPNFEG0aQi1kSY/1/?=
 =?us-ascii?Q?ZTMpp65D4CMvAITx1No+6SKPYoAXVo57Ea6xJ6zNrI8aBe8ICjdcPYgjm65d?=
 =?us-ascii?Q?nYPZL7tBJA88JUuua/XbbNRshGaTi5TSxYzNRdcmHcW17cTr6GFo3znNsGPU?=
 =?us-ascii?Q?bhzopeUa1BlfV8wXgoMygiVMYI2M+W9wWDMaPcbO?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 26c90e88-5db0-4b65-3451-08dd18ff0dba
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2024 09:43:08.3753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zszFVIHm1moUk1zRnc2c1Xyc6OEkpp4OnV8A2W00h0rGQN6W+MLY15wTKFFQgdo9dfDW2j7lbCF+zzXdV5F9Ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6900
X-OriginatorOrg: intel.com

>+static int tdx_emulate_io(struct kvm_vcpu *vcpu)
>+{
>+	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
>+	unsigned long val = 0;
>+	unsigned int port;
>+	int size, ret;
>+	bool write;

..

>+
>+	++vcpu->stat.io_exits;
>+
>+	size = tdvmcall_a0_read(vcpu);
>+	write = tdvmcall_a1_read(vcpu);

a1 (i.e., R13) should be either 0 or 1. Other values are reserved according to
the GHCI spec. It is not appropriate to cast it to a boolean. For example, if
R13=2, KVM shouldn't treat it as a write request; instead, this request should
be rejected.

>+	port = tdvmcall_a2_read(vcpu);
>+
>+	if (size != 1 && size != 2 && size != 4) {
>+		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
>+		return 1;
>+	}

