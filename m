Return-Path: <kvm+bounces-20380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E9E479144E7
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 10:31:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1896D1C22370
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 08:31:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D686C5339E;
	Mon, 24 Jun 2024 08:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LrMwEbTz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8242A84A53;
	Mon, 24 Jun 2024 08:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719217909; cv=fail; b=CZsGYvosuLHEH/Uor1xd15MYLrid0dFDXg19Xf5KRsgPQqf4uZfRzX1V3MNTxY5D4nAE4deLCevSua0QU0w5OtF367KpCKJPDRyG2HINY4G7pvhQu+w0RGoROTDugb7TbpFn9QPlvQ6rElZYyiezLB2Awk8f3tPSkOyAF+s9BHg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719217909; c=relaxed/simple;
	bh=4VCGAWg4Dk4PpscMNLyeav0II6e82u8aW8m/dzsU9MY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ib/y2mhhE0nVX1A8h5c3Q/YfRFoBHfEnyWTeAgEgw3XYEt6PrfYqgfsbb8FsOjaGJiDlO+l68JPPSoKZpeLNhxmNAJtIgqtgqRlwaX/JZ7NJrFJneeP5N+i85nYfZNA3GrPbrKXvUo15tbWxy4NEHHVEstxo3dMokeiovPwfdVQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LrMwEbTz; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719217908; x=1750753908;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=4VCGAWg4Dk4PpscMNLyeav0II6e82u8aW8m/dzsU9MY=;
  b=LrMwEbTzoEOKvOexMXPBFJEGMEdN5evcFCyvMrXdZEku2wgvsXHcaZXU
   iF6rVexiN+n2hmDk477C9cZ2G+DYOdZ43fwaECZjyBqWplmng0KvI0+Sg
   TOA+Ci4VATQH9AXLwTKD1Ocq1p/8O6bog7MQdKJlBh8ee15GnuP83KrJN
   IjkTJ47Glyhqb6oVvs8lhFxQGmO2N599clwKKFr3l6d7YazBoP8DM6VZl
   jEiwyCWKYIMH0oWS4WyuYkmWlwKrzVsfkNOmhsEZuLkshLhbKV3+SN5Jz
   oPH+zLRqwkbbOHOid+MJkjlHsZThpvBBO1s6JISqwzj2c6hyE+END8IPb
   Q==;
X-CSE-ConnectionGUID: D1NHl2ARTCODxWZAJuVUWQ==
X-CSE-MsgGUID: EX3WOraZSA2V9eV0BkXaqQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11112"; a="26766032"
X-IronPort-AV: E=Sophos;i="6.08,261,1712646000"; 
   d="scan'208";a="26766032"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2024 01:31:47 -0700
X-CSE-ConnectionGUID: DFSn50WYQ8WVGe4hlUnCWg==
X-CSE-MsgGUID: ir8ZLrkKRRuCUEPzjkzMTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,261,1712646000"; 
   d="scan'208";a="43036520"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Jun 2024 01:31:46 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 24 Jun 2024 01:31:45 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 24 Jun 2024 01:31:45 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 24 Jun 2024 01:31:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=df/krK/Y4kc4i7JoQNG2jMwQZ2sSh+r0YTDmTdVFXpZid3gHRHAqJ43j5sy/TlprUitMg8h3Xec1xRlCQRnSaRQ5N6U/DmmZp/S9ind6I7/EQgOiTEOsf4wkcMLmNFMqUV1Wa8WyozorWWCR86HyjpbqZUAHRRnPvMvAna2ytNpSM2d5CZGXcE7KS+/XS/MhcX4dR0pYZ43V3kY78UvWwVQV3D/ISx7vBliouVUGAAm5hylmsU9kmBSeDT/+GFr6WAlR7PXl9EMivjYmzt1OTmSHZl1gNfO6FSUdafEajAJbv/ONpEYsK6ZX1QUM6IZhJX2JCAAXu/7WdGDrtBC6+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QmSFcWJO3ZYxZPDNnAcN+5qkzt6MoEIgjn1EaZZJPyY=;
 b=VzEeZm23/8/9dv+08bZ8Hr9vTTnyCuEIcVjVdHJcruw69A/t/x9MFi7Ue0h6DTnujmnJ4/h+EJZiA/KzePI/4QAkfrJ/JTIX7rYqPO6+Ouq8/RGMlGTpoNlXjgFaFNpuQ3rS8obRvVADSMMp0ABhnx6o2oQdUJD/6Dl5W77mF/zR4y4B4MEFfLb4XF+WTA0SaRhdMCimFeqHyOptx+6Qjcq7bz6y4bDd3GxAb1SiOSWAV32KVIvEmV3JD+qWzb4py/JrEtyqG7k05mN7aU7juMrDbsALAoxYNcRJYg4Ff5BB3UrSXZnkOHArZvYh2B3DXSrWDjxxtcJpRxKEwAeAIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA1PR11MB8328.namprd11.prod.outlook.com (2603:10b6:806:376::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.28; Mon, 24 Jun
 2024 08:31:42 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7698.025; Mon, 24 Jun 2024
 08:31:42 +0000
Date: Mon, 24 Jun 2024 16:30:31 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kai.huang@intel.com>, <dmatlack@google.com>, <erdemaktas@google.com>,
	<isaku.yamahata@gmail.com>, <linux-kernel@vger.kernel.org>,
	<sagis@google.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [PATCH v3 13/17] KVM: x86/tdp_mmu: Support mirror root for TDP
 MMU
Message-ID: <Znkup9TbTIfBNzcv@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
 <20240619223614.290657-14-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240619223614.290657-14-rick.p.edgecombe@intel.com>
X-ClientProxiedBy: SG2PR04CA0169.apcprd04.prod.outlook.com (2603:1096:4::31)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA1PR11MB8328:EE_
X-MS-Office365-Filtering-Correlation-Id: 4012805a-783f-4fab-e4ce-08dc94281343
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|376011|366013|1800799021;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?MwPSlkVuz01YUfuWUgm0HoABDgY/iXyQubF0N5uBjVHgObOHUtgfFmbENreK?=
 =?us-ascii?Q?RneMkr03eQBlH2DC1K1aGupIgsY6258yxHQkB0RtwPMbnnAnu3aPWc94g0uy?=
 =?us-ascii?Q?o5ZNV33tRqmDRzuZKUSvKfjkiSa7DcOb9gXBXZeahTQAV+IJzQHoiDsLs6Xc?=
 =?us-ascii?Q?HwoNwGJZP64QBjucOax+lyeblxx9GzhlZZMhJc+U8p4l+BYl860nR3aWiDZg?=
 =?us-ascii?Q?q+dq8zUsJS8NL6OdbQLH6KF8pepSZFNCZlIbJ1K+FLwA/QnrWi8m5BXnb/1R?=
 =?us-ascii?Q?QhiSsWP80jdMMv/QS/tOyM/OIsHNUzJzIpifDJEYnn9MQktKgIGxpg5l+Zd6?=
 =?us-ascii?Q?Opjyuia/eX8zefbg+sr1ykVvbqup43510qouuYRWs7YYReumGEQ5AYGuRuMt?=
 =?us-ascii?Q?1UkdbGHtMUzG5FDEarbEk214j4GEv9G66iKQEtsMVK9H0e3NrPIthGFx3QfF?=
 =?us-ascii?Q?AyY0sQFwb5itUBG5llwH4MhlPeJG7OSxcI6Gvjajz2J9/rMatP9/zSiAl1gM?=
 =?us-ascii?Q?sh0/9epLJwEWOWYlwNgqqXhAmvHb4WJ4K8x7e1IrYZntgdvOX8xG4ujfwzql?=
 =?us-ascii?Q?q27sc0bU4qQw0LHXvy4XE+qNe5GgjeZDSQnYS/Xjs7qLJQbqWTnfqvyVm9O7?=
 =?us-ascii?Q?6WmujAa6k/UbFYfWKb18ci73aTYGrpacX2+f6A4epWC22RN6Xllb2xnKc2p3?=
 =?us-ascii?Q?J0/9yuEyrXFZ+zaLgjhPHIlOVuONDaZh7lY3BczZJJRn9ksac+rL8igRcnHQ?=
 =?us-ascii?Q?OwF+3PSI2pCjfUAU29hMAcbxJrfG3TFqDunlkwnQWgaK9+kvP2wwTRoClNpL?=
 =?us-ascii?Q?nVzcdujcf9ElnVAT2Z3WOC02kKIXkNKH+xMeB+EaXHabGvtOWCw+m4doImcP?=
 =?us-ascii?Q?qNStIHkgcYN0Nuef3OVmrVaEE4JfvaGINZd9VBrXmEeAVSNxvNr9r1Ll0RxK?=
 =?us-ascii?Q?9rvde1nNo8Sq3+P3BkJ9oyuuyc1kPAQ9sox691ZR3Che8I62tbqGw1NaaRQS?=
 =?us-ascii?Q?8qhuIjnlwCN/Q0MC7ijrQeRyUiE1R9fsND8R/mcbhs6GTUxBo+g24dAMqHmA?=
 =?us-ascii?Q?AiUnTQsHo0BE4VgGGKkuGByKN6q9uDYUj34SFZMBkvsQ1Q6PIQjv4Kc+Ei4k?=
 =?us-ascii?Q?UCI7/j+g7osiZws+iiXBRoI64vJt+v7MJPmWFBxMJIU8kHNeHSu9CZUEtoMX?=
 =?us-ascii?Q?N0ln6uDFDn4lRi/sWZg+3TMRekfAJccYYYGMINLFb52DpwlgxaCviErVM3xL?=
 =?us-ascii?Q?hpe395ilB+W0fnLewY3tcWMzCtK7DOOH4Wa/ZMRlJi53/fdts0KxCDMkEGSL?=
 =?us-ascii?Q?7fcHETX8PonAYe5bsN9XiiuE?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(366013)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d9dGOHUnSLp51DMDsx5FxeyGW+QqwYfVyOX9H3p6hSfU8212r/ZWlDtKYVPf?=
 =?us-ascii?Q?HsVVFs1WWfAOqrI528ESdVYZ2aiBCKSxMmoQd5KSrvQA57hoFQvkLBWTglDs?=
 =?us-ascii?Q?C8Ii28nXDs1OqX1D0v1OyFnGD+0a/Ar2AlCiJiYHBDjwMVMiMZGNhzcIZ0A1?=
 =?us-ascii?Q?b7p2VfrvEUguaRVmNrl8Ovbe9B0p6RHncSo0CesuxandOuzHSoaX7/Bn9spA?=
 =?us-ascii?Q?z6vROVD7LhKJsXVWvfdqP82mktJ/uBPjO/Dbd9GNEYVsZkuCFs6t1S5s6tHh?=
 =?us-ascii?Q?7Saoe63a3dA0vB6EkZxRxo/n56MUFfjNU5wGlnHj/wTWiduvlR0zUys2aWGy?=
 =?us-ascii?Q?Ppf5uYRSeWkwJcU5nae85426ba7pvQzbOEbZ4PfHpG0lx5b1FYJDLACm0Um6?=
 =?us-ascii?Q?jDmMJfaH/srbaib8rluLm/yhHAG1JnMn/5ly72PTeQlnGffe7pSBnT2Utuc0?=
 =?us-ascii?Q?Y7u7HpEFNTxKtaNj1cLHeoMHwc1e7Y/tiSCKhvb3EgtTpTSBlkpfY2gaCRLk?=
 =?us-ascii?Q?1pLaDDV2nSrTC4Obw/4etBz0ZMRJ7KDTB1H/omuwYzX4y4DvBOh2nLt7GOPY?=
 =?us-ascii?Q?yPyEyCMtt2GB/sE7T9loUHkFyUNRtOn0n4rwqXnMnSAyoEZMjUIXjp0Wm95O?=
 =?us-ascii?Q?dEXcZ8PV8BimqBKNdXZYMFC04v9piFJaQyR9BAzt195rcT9L4p+T4z7G2c0D?=
 =?us-ascii?Q?B/h7R028icfjUkypJQ8OzrbzqlOv7FnQaO4Xj47umw/qrs//nxo3PGYmNWif?=
 =?us-ascii?Q?Eur47i7YguHlvEnbIrHPEcLmlBt6KYFC2FCldB3hmFGeE6k7glXPPZBJnm4I?=
 =?us-ascii?Q?yzLCl6Ql2FtPeDF4Ir96g1YDKMnR0BfXHJ7n3wl8PSH+OCb7VtG4uiuOtC7m?=
 =?us-ascii?Q?k4Syp2GBTCnePEIYW9XrceN3W/+lHXTtXgMxEy2AHtGj8hPpILtnIKeV1Bi4?=
 =?us-ascii?Q?0d/tfCozarmSgbyAA9QdQ0zjl0zb0F5fIDI2D4CO8jk8spIWcWar2E4Ncc4j?=
 =?us-ascii?Q?W4YJrUsQRZpyel+OkhRj/r154L8gZMG7WR9Bcy/2O0is2Rvc0XdBG9adenQV?=
 =?us-ascii?Q?da4iOA5/GvTeVUASI49Haor8WF+NcyPlLnlw9OihoYrl4WXik03OiVmWpb40?=
 =?us-ascii?Q?LZJZIrAClhAJXQ+LSfu7FpLdTtwId+43LA1VOKSmUZysqPUQ4yG6MwBYKN13?=
 =?us-ascii?Q?SbO+8mv+P2lb/65OwfREjSX/NfV0Y3rJOUqnVG9tFm7hfTRWjWMtjhofGtRL?=
 =?us-ascii?Q?VmIcEYQlWwKAHoVVlkFp0rVcPGVV5d3PgWCRZwgejmOfys6AO802BQhFP9J3?=
 =?us-ascii?Q?r4lSol3aFPk54XDmrbdLEByxlvhxmAAJmHusExfVYDvULlOhLjwbvHrIB+Jy?=
 =?us-ascii?Q?zEB3RNRb0qdnxZv31NnHqhu0QNNrDtE1Ts2zbGxnAYlpde3Xn372Hb1PxZqE?=
 =?us-ascii?Q?U0t9MFWJziGVwXvIY6p9jQ1EJNZlTpOFFcI16rKu110GuraUD3zcm5JFBCUO?=
 =?us-ascii?Q?64hsYRNqs2yUxz1UN+y/xuFOWfadpb2xRWEogAAsxoPtPIpxNbYzWQI5l0ND?=
 =?us-ascii?Q?wjYrOK7sTWCmmBpp1X8U7Res41oA54t849+D7Rc6?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4012805a-783f-4fab-e4ce-08dc94281343
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2024 08:31:42.3647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m3YMmW6p9yRrOCLue7+qdj2m04dUxjMXw8Lg3NCn2Ts1r2/mJg+a53vSgYdqkrQ5d7MGbVnY/4NTgcHYh/NfJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8328
X-OriginatorOrg: intel.com

On Wed, Jun 19, 2024 at 03:36:10PM -0700, Rick Edgecombe wrote:
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e9c1783a8743..287dcc2685e4 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3701,7 +3701,9 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
>  	int r;
>  
>  	if (tdp_mmu_enabled) {
> -		kvm_tdp_mmu_alloc_root(vcpu);
> +		if (kvm_has_mirrored_tdp(vcpu->kvm))
> +			kvm_tdp_mmu_alloc_root(vcpu, true);
> +		kvm_tdp_mmu_alloc_root(vcpu, false);
>  		return 0;
>  	}
mmu_alloc_direct_roots() is called when vcpu->arch.mmu->root.hpa is INVALID_PAGE
in kvm_mmu_reload(), which could happen after direct root is invalidated.

> -void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
> +void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu, bool mirror)
>  {
>  	struct kvm_mmu *mmu = vcpu->arch.mmu;
>  	union kvm_mmu_page_role role = mmu->root_role;
> @@ -241,6 +246,9 @@ void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
>  	struct kvm *kvm = vcpu->kvm;
>  	struct kvm_mmu_page *root;
>  
> +	if (mirror)
> +		role.is_mirror = 1;
> +
Could we add a validity check of mirror_root_hpa to prevent an incorrect ref
count increment of the mirror root?

+       if (mirror) {
+               if (mmu->mirror_root_hpa != INVALID_PAGE)
+                       return;
+
                role.is_mirror = true;
+       }

>  	/*
>  	 * Check for an existing root before acquiring the pages lock to avoid
>  	 * unnecessary serialization if multiple vCPUs are loading a new root.
> @@ -292,8 +300,12 @@ void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
>  	 * and actually consuming the root if it's invalidated after dropping
>  	 * mmu_lock, and the root can't be freed as this vCPU holds a reference.
>  	 */
> -	mmu->root.hpa = __pa(root->spt);
> -	mmu->root.pgd = 0;
> +	if (mirror) {
> +		mmu->mirror_root_hpa = __pa(root->spt);
> +	} else {
> +		mmu->root.hpa = __pa(root->spt);
> +		mmu->root.pgd = 0;
> +	}
>  }

