Return-Path: <kvm+bounces-58655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6CE1B9A41C
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 16:32:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DEC493AD75C
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 14:32:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B12B9306D21;
	Wed, 24 Sep 2025 14:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CxByUQeD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B70749C;
	Wed, 24 Sep 2025 14:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758724363; cv=fail; b=ES8piB5/Ak6g6iycV6h19xLd294YJmGt3BFnlE8V13hkFUiIYV55uPiPL7r6RLSTbH1kX0791y4L+VaGoBAX39kQopcdUAyHDBNkkFtFnSK0NHZayoDs/5Swv82By6Y51fNhGW5g2EgiM55Ar9j01b68YaOy2ak5Dq+ldxwh8RU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758724363; c=relaxed/simple;
	bh=enqnwlAx7o39a8XpmBe28kjFKxwN/JLp3ChjWdKFH3k=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=O17h+lxeZXzaqLZYi4o0t1NPTXLNvmftsrekG/PSHviSXfRMd+4cEA+DjoLMoyytQ6QFU0drZOLOFAI7dmjKqixy7MjylMTXAKVm1Emuis7kuak5qyQp9Nvx1bckhAVz1Vtymnv7aa/uEzNy6dPpWTKgapro6bMeLQwsSmuElqI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CxByUQeD; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758724362; x=1790260362;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=enqnwlAx7o39a8XpmBe28kjFKxwN/JLp3ChjWdKFH3k=;
  b=CxByUQeDhEPUrmdGUdhwJy8tmEAf6eRysDcNX11WUJqOEKr48xiI1sG4
   8Kd8xfZ4gsEDib7/BJz3rUCalq/DFs4xFtjsZGy5aXYcmUCTruYY06mZ+
   p143j8jveY14ENJGM2xk5C2eF04qhxGfrnTXWZCoQRiKrSUFEO/lohsJW
   4dThctsRimGCnRuRcNq4OMjjB2tz1luMJLR0oKXCV16+QX2c328dpYnDH
   nBo0iUEmC7DXwo2eRcDeH+d8gbJ3rANPFesG44vEKoAT/fe73GEEXgORi
   7ngXoidy2VKRYv7zJJfYKoTkIVB8XFvnY5CTyLrI+N7F0TEDTpn5LN+di
   A==;
X-CSE-ConnectionGUID: vcDWZwpKQI6ct3u4hA2zpQ==
X-CSE-MsgGUID: F1OwuDGfRKixEY44GNb1eg==
X-IronPort-AV: E=McAfee;i="6800,10657,11563"; a="60724628"
X-IronPort-AV: E=Sophos;i="6.18,290,1751266800"; 
   d="scan'208";a="60724628"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 07:32:42 -0700
X-CSE-ConnectionGUID: oYfqLpSgTVWMSh88AH7B/g==
X-CSE-MsgGUID: QMKnosdmRf6KRlj+fc7T3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,290,1751266800"; 
   d="scan'208";a="200747236"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 07:32:41 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 24 Sep 2025 07:32:40 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 24 Sep 2025 07:32:40 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.36) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 24 Sep 2025 07:32:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=atfjBccPCQyQhUR5UHwicLECO2hGXupXziUrJt7hiLtUFFibEkqSt1Y2JHDSGADQ1Lu9GXqQAc57lvlsad5ww9QdFge1ZlXX8BtyQMBcJazRpEoPYW3EV9qHG7SS8gYahgsi598yvStf2NvAqNRy8odH8IOm/MQGFT7FAz+on4u3PZr4a81djloJTdc3C9KQvazoNLv86Lx4EcMFnyPHmzzU21AtmbQVMlX1HedeR0Npv8mExeaC8gZP5llbwLa791nBxha1Gh1bKqVFrmkEkfbRmBniYhlcjKXipH5pd9plK/zw3pCsuGAwgI1z9kb1cXXeqsJhQpK9vfF/8r9Nmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YhAKfgNMhdWPBi1gO/DLLEuO5YY1fFPphh23pTr8voY=;
 b=vjdHsA1c+VZwK+7yqMce6G78lMqGgXlKeRoFZvnXom3Lp6bqx05IukhkIXh1NGZFgkDXq3Kl4I7AffPvvFiSYwEWGIyizGqE4h40kLdWcBDRWPULaxGi4NyPXUFJWP5JLxbfE595WLNATp11HkjWU/QoIEE18O18w420bKRl+Oey943oJRdT7lNqC1PMHErS8aK4YvjEKZZ+PTmJrnuU4Ja7bWz8vycIse8AUm9PLFKS66Ru/sCP6AQldYo1a8uj+K/+p0gRbaBcr9I+Kr/KFy/JEF+Wp0DUrEURXUyFLEg3FvDoYoXG2iB40ugQ7HlBfAJAJK8/+ZPUkTee4XgNqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ2PR11MB7425.namprd11.prod.outlook.com (2603:10b6:a03:4c0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.10; Wed, 24 Sep
 2025 14:32:36 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%3]) with mapi id 15.20.9137.018; Wed, 24 Sep 2025
 14:32:36 +0000
Date: Wed, 24 Sep 2025 22:32:25 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Binbin Wu
	<binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, "Maxim
 Levitsky" <mlevitsk@redhat.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>,
	"Xin Li" <xin@zytor.com>
Subject: Re: [PATCH v16 00/51] KVM: x86: Super Mega CET
Message-ID: <aNQA+VNTyr9kDJCM@intel.com>
References: <20250919223258.1604852-1-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
X-ClientProxiedBy: TP0P295CA0022.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:5::18) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ2PR11MB7425:EE_
X-MS-Office365-Filtering-Correlation-Id: c2af8bad-8d1e-45f8-fc56-08ddfb7734dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?AuffMIPMZvtqReC+akHMsIhGirTHLxYAZkzmp0b6sEoCziHj/MwJ0wa5toV5?=
 =?us-ascii?Q?XRjJuLviA5aeN9GJTEZ2VxHbzRMMUkLWIjHVcGo05zm3ONsJFRuMcRbgdyBN?=
 =?us-ascii?Q?lZoVqUCzlyQyOM+yLg1xNc2FO4GWvAl6WWhyp+/OOMBm39woMQxLgPARgLoh?=
 =?us-ascii?Q?WpSF7TcT2AePt/my83vagemu91rAWrqDvwPobSsTbjMomaV5Gdgz/2OoJARw?=
 =?us-ascii?Q?nopbIoAeXQbaWRTnCs23KHb/VeEkR2qAv89p70x7ihTAvD7rMRuCZF/dJlV5?=
 =?us-ascii?Q?JQ8QDOmTOpo2kifWNUTu7msfVXYleiVmmJO3pcgTnabv26v1smbTOZpFYJjP?=
 =?us-ascii?Q?XfirHQh1xX0xNZ0oo8TDhZYFHgo0RrJQ0l8TabJf8/8yBxypFcOV/POXFXab?=
 =?us-ascii?Q?ee9DuvjAWMMrTCauxudx2X9vqIZEYvQ1paaaeZ1V0kL6IV5WThPV9DCrwXSq?=
 =?us-ascii?Q?4P3ZN8u4dhkMlgCrrD6vQX+ewbY61JtH3ONDvDiDZAENIvIKX0OSsFheJkwg?=
 =?us-ascii?Q?jt59WdWMBuY8A2Op4o9bk8sqtODgRx1FIngw+Fa8+R4Xe8QFmFFrYfmUXxCC?=
 =?us-ascii?Q?fIqizAknqBq+fqp3aC9lUrb8xzgFm3W3KiJe8iRtkWqGGJ3aCcNk4f3Incqx?=
 =?us-ascii?Q?4jkXoCiDge5Z68HR2nLwFb9oNAeSJQLqvwNXJ9+Qpg5mABomrB2ekce/mF3G?=
 =?us-ascii?Q?nbI7kCarASWUvoTUpGudYHk4M8zcrHeKMA4Dm4KR6RCcq4vbJkyjMLM7X5RC?=
 =?us-ascii?Q?v5vTSP8oEyJPXK6MW+vg8L1TjU5spFbp+iAQeCokpAJmV/ypc6UbSzINEqni?=
 =?us-ascii?Q?bkOE2ValQDCu0n4egvjaVINI/1ozERsjE4LpoO82ibbuFeoRW6nLV92Mb0SH?=
 =?us-ascii?Q?Y8+GF1JNnPye1XBXvsMvPJ/3XN5KdYjr59362bCkeBunN+Kb8eXbRH052l2l?=
 =?us-ascii?Q?mbIh1dTSRlj5P35ZDsQz1j0CtcAUmcZjpcMb0TOCJVhgAXudLz/rQS+LDm5o?=
 =?us-ascii?Q?WhsB67i2GyItFMuLYTxw/ZX7e9KUAREYdMhjqSt0j8Qgr3+OaO40y0FB9E/j?=
 =?us-ascii?Q?Ah3xjvPlLwK/rZkD7HizrCPf3nBkGVQE52b2pFJCdilhCLgLEowzUnaoM0KA?=
 =?us-ascii?Q?f51AwxUmm+7axXcWstH7ZHEf+L+in9+MtZ0fwox3fJ0rUG9Qi9PIPQbfzWkT?=
 =?us-ascii?Q?Jg5LNvaIXmEq1NblV1cM48RKJcGeGUUt1AXiF0VT0FpGpySaEB6md7SD1DMA?=
 =?us-ascii?Q?rNVxGq4SLeMU36Gebj8E7OQZIWZKZwpNJ25CHAuJCQXFrsfT47DO4QFGqjwr?=
 =?us-ascii?Q?g029y+kkRPkyb1zfxhG9nNXoUBGXEyAj+xw8u1ftLfmM09T7kSaaFxM3w9Qm?=
 =?us-ascii?Q?wbN0Wipi/jUTy3UoIRkV2ToIS+mnp3x7Q8fA02K/MZL+jYdmfceHGy8hAVq0?=
 =?us-ascii?Q?QLcXikZTbl4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BbQmrRLcHU7/D3NvtiF1/TD6017PCfPNJeLn6axcMjhFEs8veWfjx9rvTA+z?=
 =?us-ascii?Q?hD1MxzW2ZXqm4/A3So9RXUDObLYNOhEhF1//YfFVIt2ukfvIZoNhlKJzSBKu?=
 =?us-ascii?Q?XMq4hV/9ctWk8n85I5W7eby2E4vZxL5h5gYk1dE4kfrzXid9znOQGbczv8xq?=
 =?us-ascii?Q?GrHC/cXLYzh0AZpCJeRoPd0pLgsLdOqjiuxcrkgfAdNrQfiNkuQ0kh8acUZ9?=
 =?us-ascii?Q?pvxuNaphOkreG8eiutYFoO7/njM/Yg6OCIEImSlqy4nXLpFNLo4Pwd1OiunC?=
 =?us-ascii?Q?vaeSJy+QN2sdPlEt1XiY6HrthD41OeINwDjY3mADuCj7Tdl6kor0QedtBsIc?=
 =?us-ascii?Q?lzXn8hvxscuSqReGDq71dhGzoEJSsgkOshvDVyIGzutN7Uhl/FDi47aXqcgF?=
 =?us-ascii?Q?WYOAv7S07N1AyCjtXUuj8u31JKSqGQ66XzPzl/oCKkuvdp60U1yna72jBYFH?=
 =?us-ascii?Q?B5t9NoCxsiULEOJE4Rl23lQRpzCDJemxKT/WzjT1l01wsrwYGDS/1EF2Z75v?=
 =?us-ascii?Q?WFNpmszUPfN5zhEDl9xIMKVNtXe/kH+MgNuQlybXNcaijYXG5hyRjX353xb+?=
 =?us-ascii?Q?GAqF0H6wgIs085Sn8AKc0zApgQFBSZwvC681XzjUlHVAhqdAxQdicUc2FgCt?=
 =?us-ascii?Q?Bx9zy9OPDbMUw4xRU9ij54rgsna5E2qFxgAakKdC4GrpRbElEkBTZqpv+jYU?=
 =?us-ascii?Q?1j1YtXA6T09lrz3PCg9Go/cynW8aYb4RbQDB77rYsMyQw7REQJ9OmalFOULA?=
 =?us-ascii?Q?KBhO/zqhR/aDSsX4fXcb7HN97VRaKt+grum4HYLyyOfTgCZNtHS398oZtcVz?=
 =?us-ascii?Q?/BsSpX7RFmM3gmIov5GoYvEir8NnWXuH9qyiMpoKMxWuuo4l0hco8CrpDShr?=
 =?us-ascii?Q?m7FFK6qyx0bjjH0mBWm+L/2j22GfPqnUgvkdefv2vsee5yqZOYb2df3d54Dz?=
 =?us-ascii?Q?7aDSy2/oYAWRStL05g1F7iwIlET0X3ojSIjpRmWcnP13imL7utfqG+ED1Dar?=
 =?us-ascii?Q?xUvAOoSxCVOIFX2okinDqA2Pn5LXmckBWbNb1QqJr8eYWXvoFO3nHAFH9EQa?=
 =?us-ascii?Q?3X3icmfwFTtD2mXkqXfA6/8fOZa9UJIMdk4yO4qF0lMqbHkT2fR647VQz+DJ?=
 =?us-ascii?Q?Pl6n0hc9ZphVBu7R700SgeCUQhkQrZub+zbfOpz/H4NDLU4u+oz2D1+mmHXB?=
 =?us-ascii?Q?aH7gnkMsHsJsnIviD70P7sEuOPZUcLPEATYNWp5na4RZMl/rTVjpwWFO5nXD?=
 =?us-ascii?Q?d8Y4a+A5fgSglhuHJTDDOWIfkFsXjBbiizjkg57X/GRiX7cZrRRKnVbyZnYu?=
 =?us-ascii?Q?/9A0HYgcmJ6MP5+LxyVVEVCwVvwXr4g5CB5AqMxiY6XEAQx7UxhsfFb1MYBB?=
 =?us-ascii?Q?8dt8wOiLfNVEmQo3s3Qwx0PybrPpFN+DocvldVuFeasxwLSZoQNb1L0QLk6S?=
 =?us-ascii?Q?HK4LzDzwWX+InlH0qWXC1e4yN17h2E8vudVmF/ihdrNrTOzu2PHAtdkuJ9W6?=
 =?us-ascii?Q?ZX2bENJikJbG0CTsHSL8PrKeie7IfQYmAkXF2lhAxk7oQMrmc/ADfXLCRK2f?=
 =?us-ascii?Q?57tnujxTlHw3sUm7NY7Q2ntLA8oQEWqtf704sKCx?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c2af8bad-8d1e-45f8-fc56-08ddfb7734dc
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2025 14:32:36.6731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KSm3P91rEZ13RoMXEZsdhtRKLJSbj7/fF32WTUkq7rKJWdv0t1ag6+0618PoMS+b3goGdyCHwrJ9UryUjkh4SA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7425
X-OriginatorOrg: intel.com

On Fri, Sep 19, 2025 at 03:32:07PM -0700, Sean Christopherson wrote:
>As the subject suggests, this series continues to grow, as there an absolutely
>stupid number of edge cases and interactions.
>
>There are (a lot) more changes between v15 and v16 than I was hoping for, but
>there all fairly "minor" in the sense that it's things like disabling SHSTK
>when using the shadow MMU.  I.e. it's mostly "configuration" fixes, and very
>few logical changes (outside of msrs_test.c, which has non-trivial changes due
>to ignore_msrs, argh).
>
>So, my plan is to still land this in 6.18.  I'm going to push it to -next
>today to get as much testing as possible, but in a dedicated branch so that I
>can fixup as needed (e.g. even if it's just for reviews).  I'll freeze the
>hashes sometime next week.

The CET branch in your kvm-x86 repo passed all my tests on an Emerald Rapids
system, including:

1. kselftest
2. KVM-Unit-Test for both i386 and x86_64
3. glibc unit tests in the guest

