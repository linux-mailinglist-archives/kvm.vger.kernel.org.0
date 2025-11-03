Return-Path: <kvm+bounces-61777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C7EE5C29CAD
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 02:39:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 603504E96BC
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 01:39:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1CFF277CB3;
	Mon,  3 Nov 2025 01:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mko89ybF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8AF2773DA;
	Mon,  3 Nov 2025 01:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762133972; cv=fail; b=kZRDpy4O6Icpur3qtMumnO9ozfMKhJqgfuBmWTTtoqJ0KjC10Fu1KdebliE/6ATklc330Gqq+cN4HVS8YxeiDnItIbAVuWrWhxkH/urjl15jM8O0z3ud4dgbKz41GeEeZZ9lbN8kxYff7+iS9xabzGc3b+JB3g1L8jnwZOw/yAY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762133972; c=relaxed/simple;
	bh=N/5KJTSI199ZZAfEjw3sIX2gdoZ0mNU7+vy3ThtWlWc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cT0K0ju9p+a4JriYSD9O2AXgN3GUe8O2/MII+s63Kz0v3DiSmKA2c0T40C1/krycxtmdTp5EKMRqRGtfL6Wnw22+LWyM3jixU7ioeRfeuXeCcod533I9Pfo6p9bpzD2Kzmz1/mIzpJP2g2j0TqFF8Nz0YD9MdTX0CCBprcfLCyE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Mko89ybF; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762133969; x=1793669969;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=N/5KJTSI199ZZAfEjw3sIX2gdoZ0mNU7+vy3ThtWlWc=;
  b=Mko89ybFJhBdrw2v4HAch23pedywBaXwX2tUKpppqfAFSqjmIUh5tuMt
   T4qEFkGM0H2Va0teP4t1OLDwB0Oa6iHIQ2JWS3L4fkOZmgESXAIF2oEAX
   I1t4Fpk9jL1BugDz6myW8075PCDl9RE6Eu+0IrL01g22SroNryg2HGSEA
   /LAmg2dsCDp37uoL97aB+OjnfZYLy+GT8Sfm2lUacFMCsIs4gLTVZW4Ln
   JUOzGlD8QWXF7tXCWTSGOvMFuczfb/70UoY9V2+ZmnyspqxbqbI7YyIDk
   dV7d1LnzUSmzZ1K1E6qw3m4A2fMz1ww2yqY2siNbOfo7+0ZI9Z9PlY0Ft
   A==;
X-CSE-ConnectionGUID: bnQ/wg7WSZW8ly2as6WSIQ==
X-CSE-MsgGUID: ZQPlcKLUQFq6cKVBEhSuXw==
X-IronPort-AV: E=McAfee;i="6800,10657,11601"; a="67861013"
X-IronPort-AV: E=Sophos;i="6.19,275,1754982000"; 
   d="scan'208";a="67861013"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2025 17:39:29 -0800
X-CSE-ConnectionGUID: w02tQKrfTM6p6yZbof+zGw==
X-CSE-MsgGUID: tMlOg5wqTVy0Td+zigI6XQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,275,1754982000"; 
   d="scan'208";a="191854107"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2025 17:39:28 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 2 Nov 2025 17:39:27 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Sun, 2 Nov 2025 17:39:27 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.66) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 2 Nov 2025 17:39:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TZ37nahmGWZtMzNUItiTh+g7rYfnzKfdjZWASlxNakdPBzUZ3OYDPSl9pZ5UeuyeBwM2f8PjIUnH+jckqd70TPHXssBAr4KyeuRok030XTxo+63oc2BM0Zof9V4q3lUgHuKiLmcicjtGxV7oMxvXeWRtaDM8sJnr9+9WeiTCUvqeRgbW5ThCPqq1VBBNB3VR+mlrZ4jhCMcYX4onzQ62VigDvZVGVExDl0NklX1avJw+GeOrBwUD1q7VdsIyy5B+wMoSmlu8qv5TtNIAcfF8JIiskerxvP/bbIVrVhghQCKajjMEDoSyyYO/51lFugYYQz0Zj9z2FhRv1a9sP103OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ky2QnQU3NciDoPu3cRhaLSFzH40y+n+2Ic9g9pHOvlk=;
 b=aMBvihl1GZxMvjLK82EiPDcHlA1rM/6n31Y87RdrIDhgUMaUYYh03H5VS72lvph8v0QBdIRQFYRnhJoIaac1u6mJQTnbfWJD3kYWgj7v+JLvor+hcrjNFODnk+8pcTBG6haZWZDwG4TcBpwgyL1p4l8ZX4p+XGkslzHDZdliHo8912cHshFBiYNhtQsPxLbL8BnJo0AiF41X5sxWkaSKKAVX4eyKAM8ObaShhxfSk64sW8dUnLby50aCA+3xs/wpA5RKPtx/0KFrJalIattb6r1d1PaRwPPNuLW6+i4Suvpbv3NGj3MX3MMOf4x+XGXo9qtnaraUOu/2ugcp+XU18Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MW4PR11MB6714.namprd11.prod.outlook.com (2603:10b6:303:20f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Mon, 3 Nov
 2025 01:39:25 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9275.013; Mon, 3 Nov 2025
 01:39:25 +0000
Date: Mon, 3 Nov 2025 09:36:57 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan
	<maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, Paul Walmsley
	<pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou
	<aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda
	<imbrenda@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, "Kirill A.
 Shutemov" <kas@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>, <loongarch@lists.linux.dev>,
	<linux-mips@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
	<kvm-riscv@lists.infradead.org>, <linux-riscv@lists.infradead.org>,
	<x86@kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>, Kai Huang
	<kai.huang@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, Michael Roth
	<michael.roth@amd.com>, Vishal Annapurve <vannapurve@google.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>, Ackerley Tng
	<ackerleytng@google.com>
Subject: Re: [PATCH v4 26/28] KVM: TDX: Guard VM state transitions with "all"
 the locks
Message-ID: <aQgHOcy28pSEfTZK@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20251030200951.3402865-1-seanjc@google.com>
 <20251030200951.3402865-27-seanjc@google.com>
 <aQRyyieyDrZZMpIt@yzhao56-desk.sh.intel.com>
 <aQTzO7D1O02zQbcD@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aQTzO7D1O02zQbcD@google.com>
X-ClientProxiedBy: KUZPR01CA0005.apcprd01.prod.exchangelabs.com
 (2603:1096:d10:34::18) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MW4PR11MB6714:EE_
X-MS-Office365-Filtering-Correlation-Id: 21cb14b1-4042-460f-882d-08de1a79d1dd
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?64YMsPioydEklVA26gT/SEqnRklCj+AUOcbhDQCATiwYwQGxw2ojzT7z/4E5?=
 =?us-ascii?Q?Fba/JQ0sbJFv9VGZS8PtmFh9PWFj1AcV7cDjIAiixvyyP8w0nuPio1m2EuyY?=
 =?us-ascii?Q?MMEV+TzmIT5PFL+u8tHw+5vKMz2PZlXxIftTZAIl3fGqvpyaos6XKsmm+jei?=
 =?us-ascii?Q?WSUELCbsjxLAiA+3GJ+8cWxnjVjkDKUnbduKzBK+loM/b2r866pYFFpt8suO?=
 =?us-ascii?Q?U/LdtNiWkkpKiNHAyPiboU4s7M7Gx8ythXRwjZeohZuhzfLTXOPeUX8A7J29?=
 =?us-ascii?Q?gBKF6lCJ4BZBg0SXmPxWSFauBoLQ283tVtAJqo7AmXwWbe49GzLg7OjBS04/?=
 =?us-ascii?Q?ugyl/23VdSZjmqH6aM+3lgUexMddeeZn5xNChd7U+OmhZEeKNKHKUEG2kuol?=
 =?us-ascii?Q?grWnC/SCYkqgUkBeIAQgj6YvfpikY0g/BphHsnIryGzv2QsfxlGSa2lGx3mB?=
 =?us-ascii?Q?YgXzU/H3YTinKnSLLfqCbrzLkZ2GPkLdRTvHqpd3OXakcZR5s3Vpumyy7KTH?=
 =?us-ascii?Q?wWVqpPkjCOHBbTIyOpZFVpm2AL99jYpixGE5N6KpJfbhHSFxbiX3W6pLfH7Y?=
 =?us-ascii?Q?tvv6qsLeD1WStgDyonalD6cVNnFymIqyrqfU628ZiBOqRFmluAC2jyHTrfVm?=
 =?us-ascii?Q?g6dh2tcAzPrczjWZJKxA5XWmh/GyzeuJHvJNAX8zhMYe26iE5Gtg3DlU0jDq?=
 =?us-ascii?Q?rHkdNzqvjnINgXD3rhQ2rcC3qTCA/pzffVp20boYNMX+9e/KaZhQe+vkv6Gz?=
 =?us-ascii?Q?gz93xZznND8/WVnalHPJeyIleJV1G+tjymi98E0IXoD2TIW3M1WspPGcn4s0?=
 =?us-ascii?Q?NuFwNzLqVezc+q8Os9He+6MUwoLMzsnqheStztNllCARyIdL4AsqSo4SWzPq?=
 =?us-ascii?Q?16bXV7ORQooALsClWJj+Q3IY7rTTkWNsHihzK+AmIJ39xfHq/IBL/jCWsg0J?=
 =?us-ascii?Q?eSqet9VDSxR3W8U3J+7ilGnd7uQ6LYCRwwfT1b4Xjst6tmk6EK5HdlajG/o5?=
 =?us-ascii?Q?BgvpcXrkD1SGQaUCUxtGS3LY0PdiU0t/OC/elbUSpzfcD6af2d1h6vF3DX+r?=
 =?us-ascii?Q?OHmqhRgrg1SWD03Xof02VPiDOz4wWKt8J+3am+poxc5ZypV6fEZNmq5nM2XQ?=
 =?us-ascii?Q?jPK3wvykzPJQI9pfgXrnCe6RlHeJLTa5+TfGi167QKJkfFGSvFJrf+2wI9U/?=
 =?us-ascii?Q?JG0TG4pXOHJ9EUFEdFJ6ZLnBGRjaaHiEPhwMpmjDLeP/FKmffhIR4s8HX4js?=
 =?us-ascii?Q?S6g17CSEbV6I//oHPOZypZJcHsS+x1AaAKDs/VZktrBlVkDMt0JmeiIAqGxH?=
 =?us-ascii?Q?oLV9u2WYXrl5L/Uh0qqyKajp1aVgoHSzAJh+djmEVBLdLjJU6+wQp2rozNyP?=
 =?us-ascii?Q?9WLW4cLoPX3AA+3wwGzn3hANzBy9Y6ONq1IK6HiCJmYG5bcOi+LQ/RMJ0uMx?=
 =?us-ascii?Q?XbQItW/98eB9GpdF+yZlu3sUo6PxvuXW?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P7R594Sn6oxeioHpa/PBumxMzFwifptYWZBUUqcpWn+MDLfiqtTd2isAtzZ+?=
 =?us-ascii?Q?G5aj+X28emP0QIO0EhSHGlscLS+zVT+612LMUy+yVBoEyqgakw9c8AtLKHNl?=
 =?us-ascii?Q?jlhW4JyiXX2ZgTHsI/9mzx3p1OZfqVUcyqvhuGcUu4Bg9e+5dl7nZFQnxZuU?=
 =?us-ascii?Q?+i5evXI1ikZW/zhN4sgwcAmCWcyN8Mvn7wm2xSg18MgEU5V98tVhA+Cjk+FV?=
 =?us-ascii?Q?1QhxicPGx4u5eGWYAvNrjUiMPzOceH/cJ4MlY/yRX4516+Z93+BaD3H8fZuT?=
 =?us-ascii?Q?DSxlzNOcejiQ+E1irifTqlASr2bfgFqciN9ZfLViNozZYH8WoHf8Dlzr33pH?=
 =?us-ascii?Q?V6pJj2TYlV2X2iKsbmrK73vZXoKeXcYkGyUwmRI0ndWTFy1bxetW/oGcqNWA?=
 =?us-ascii?Q?XysKSA5ccDeP5sRkz1uFzAmLJcAuPzJEqritIr4wH8Js8fI86vJMc21SAd8v?=
 =?us-ascii?Q?Gc1p21NM/CKCdU/PpRjfWcRsoEw5nY62x2g56Akyhvp8Fpy9B0pIC/qussN3?=
 =?us-ascii?Q?daf5mdcqIWC1hzNXiN9KZ3JCUnlBo9HU6ywD+GBO2L0f8Xgcl8cEN+bEgnW9?=
 =?us-ascii?Q?qCxHzwDWCPcLWdiMsgBN5uJfkzgUnZ/72mcpXuwC1J/lfJVdh2WmhHBlXwSs?=
 =?us-ascii?Q?HaVq6ayFgvadibrcShv8xZTTufZ5pyA0g95XzJ8q4jgFtG7aiGs6JYo3xqYY?=
 =?us-ascii?Q?3NU9ZDgqmHio/UwsfqIzMaVdRy9d8PYhcH7x3dyT5VF/r7KLoMgii06B8xXT?=
 =?us-ascii?Q?wUm4tD09obOyr+l+wLCO7Lcu0TaE9abq7NmdrBlR+C7z/Qgm1wL4gIE1F1qx?=
 =?us-ascii?Q?i9RxRpp4mVV794gKUzzwxLgHyMnJJ4IO1l9tBnggOkaGyWqngGvZLmDr6ook?=
 =?us-ascii?Q?OLlMc6TxkxBlumiVPiacWNuvAC9YDln/36UdAJmUEkgZev+FGCD7hy1UQ2xA?=
 =?us-ascii?Q?ywZgKIds3Pf+KadOmQPNP/7wbdK3/QQvr+ZGInE5gFfZQ3bT/F6DbElulzYr?=
 =?us-ascii?Q?Jf+hNyyF2shd8kbB7M6jkCm5CcVKiAQkuVAr0CJ0g2bsw8iSNPTkaErdZ+FL?=
 =?us-ascii?Q?XTD0DDT9Pg95BXBV5see1t64UvMyn/P2v8feVBbISAOtDvzO8r3VyiKk4yrx?=
 =?us-ascii?Q?ANEYm1rE1Al+VdZ7cZJl+MknHokxjRgfIOOpFnawOgH1LjT3DXt0f+dK7Om7?=
 =?us-ascii?Q?fQ0FzR/s+OzPLn++mNY2jAE2z8hUzziwQAKAQ1nfOeWejyVqPFDQduZQoCSl?=
 =?us-ascii?Q?eoEDXPsflJ9pMiAmAZlr2LJtdHG3Hd/BrE1Wi/uHtEA+hoCxcYBuPaQyujzj?=
 =?us-ascii?Q?lofQqOd60oLdMy9B/l7jTsJmt2WR3hz7F3HTezUylml1X7wTBF8kvfjhD9as?=
 =?us-ascii?Q?OfeAsejb7+kSe6DaCIeW1onarXTxK/ztJa63UChBUbEowmDRlZuU1BgziIws?=
 =?us-ascii?Q?vpCNw1PdfYO3B1EI4t/EULjhhsLfmqAS7Vr48krEAnZw+bqS+NYZQ0rIV8V7?=
 =?us-ascii?Q?VR9k58+VdweIlA66PjLoGIYKedJ3EN+xuwFcC8lHK4UmVG2FIFujDcRgoxf8?=
 =?us-ascii?Q?LzTo/87aF5Plzs3UbnvZFTrCxehsiXfdkg3fN2jx?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 21cb14b1-4042-460f-882d-08de1a79d1dd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2025 01:39:25.0038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S0VFmCBg6QNFHvcN2chshxU0Ut75qSDA2aa5dg1IonrHIZ1D55Pe6Jhk/kb+KC3dK8kadjovOsA2DUo+miePhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6714
X-OriginatorOrg: intel.com

On Fri, Oct 31, 2025 at 10:34:51AM -0700, Sean Christopherson wrote:
> On Fri, Oct 31, 2025, Yan Zhao wrote:
> > On Thu, Oct 30, 2025 at 01:09:49PM -0700, Sean Christopherson wrote:
> > > Acquire kvm->lock, kvm->slots_lock, and all vcpu->mutex locks when
> > > servicing ioctls that (a) transition the TD to a new state, i.e. when
> > > doing INIT or FINALIZE or (b) are only valid if the TD is in a specific
> > > state, i.e. when initializing a vCPU or memory region.  Acquiring "all"
> > > the locks fixes several KVM_BUG_ON() situations where a SEAMCALL can fail
> > > due to racing actions, e.g. if tdh_vp_create() contends with either
> > > tdh_mr_extend() or tdh_mr_finalize().
> > > 
> > > For all intents and purposes, the paths in question are fully serialized,
> > > i.e. there's no reason to try and allow anything remotely interesting to
> > > happen.  Smack 'em with a big hammer instead of trying to be "nice".
> > > 
> > > Acquire kvm->lock to prevent VM-wide things from happening, slots_lock to
> > > prevent kvm_mmu_zap_all_fast(), and _all_ vCPU mutexes to prevent vCPUs
> > s/kvm_mmu_zap_all_fast/kvm_mmu_zap_memslot
> 
> Argh!  Third time's a charm?  Hopefully...
> 
> > > @@ -3170,7 +3208,8 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
> > >  
> > >  int tdx_vcpu_unlocked_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
> > >  {
> > > -	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> > > +	struct kvm *kvm = vcpu->kvm;
> > > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > reverse xmas tree ?
> 
> No, because the shorter line generates an input to the longer line.  E.g. we could
> do this if we really, really want an xmas tree:
> 
> 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> 	struct kvm *kvm = vcpu->kvm;
> 
> but this won't compile
> 
> 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> 	struct kvm *kvm = vcpu->kvm;
Ah! Sorry. My attention was caught by the line length, completely missing the
dependency :(

