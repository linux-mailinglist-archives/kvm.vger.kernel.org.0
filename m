Return-Path: <kvm+bounces-47205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F22CABE891
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 02:33:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF0077A77B5
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 00:33:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 720C07081A;
	Wed, 21 May 2025 00:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oCDu1vj6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0804B1E57;
	Wed, 21 May 2025 00:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747787591; cv=fail; b=ESF/eNchmYo3HldwH1/CRAjlLS+OT1cCJa/HLo8vV72WKAuDFLIJqXr4ZLgB3WuVvdPDw8GSq66pNhqI+GGZ3BxqXqUDBIFxrJKr6qF6bH7FNsNyfCwHccsXUHMTJkNwviEe6WesgdlCxkPBVypoKN6/DOVeFLbxxNxpVvlA6Cs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747787591; c=relaxed/simple;
	bh=4Taq1+0e5DJ0RmNZkyYa5P2uiQwF4JJiXImPjjTFsQs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WH2RpIEef9dzXetSO13R7ITKC08ytqa8FM+epUEmyFD3AEkJsQ5Pull1SP3S1TTynOMCNi0ITfjiu/dTV/TBd+giYl5kSP5Cep+pxvoFziUMWZftQZ8+JH2/cjCgy71lwqi7UZJcfP5/eEuYrpueAXkOoNxmngX9ybpoj2rP9tg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oCDu1vj6; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747787591; x=1779323591;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=4Taq1+0e5DJ0RmNZkyYa5P2uiQwF4JJiXImPjjTFsQs=;
  b=oCDu1vj6sJqGJ0IlqBgbTvymOMorDFBs9PXwYWvE9P77zIjww+QTQ9Y5
   sike3U69lrmC+qIl+PnZlD4oO7kl0Ddo817BKacLi5o5x8cxkGDkLkX/u
   HvuxGTnoRm7QEq1VZv4EInsL8sM9OzFxvPJWFyfRdYSxNql9vU4flrt0M
   JyPHxpJLHcRCHiLvMEsrR1Cl+cr8vJ+0VFBPQZVDz9yvF5Ps99dpKLgjy
   8S2lIbNm+BRIjyxYd0KIMaViilQTcnVLzz9rG15mxagWxBIUur8C//LEH
   2PANkJHwjScGFLrNJzP3o59u6pXhG++hvmuKgXgbyZst0o+AD8s9eMfT9
   g==;
X-CSE-ConnectionGUID: yjlbajmrQLqmyB8qik1Skw==
X-CSE-MsgGUID: Qu7nODijSy6stOqdwwwcsg==
X-IronPort-AV: E=McAfee;i="6700,10204,11439"; a="49646515"
X-IronPort-AV: E=Sophos;i="6.15,303,1739865600"; 
   d="scan'208";a="49646515"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 17:33:10 -0700
X-CSE-ConnectionGUID: kU63dvjWTcitrkVXnkDckw==
X-CSE-MsgGUID: lLmO7W8lTEy6P9v0f97M8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,303,1739865600"; 
   d="scan'208";a="144736346"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 17:33:08 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 20 May 2025 17:33:08 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 20 May 2025 17:33:08 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 20 May 2025 17:33:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C3Q8OSN+5VnqTN6b3Qhini7YHZ/JYMYJDW4y07fSivViIXRyt6+91HcaZBfhtqJCmFCzC7zlvKTXX5Yw9RAZ2h7FWeKZBS+SqW9eAWqW7hbUDGYKS13Eg3eiroWQzMElJKq0rZY4/jKaeWVcGJCkY6WM2r1QP/MmTUWjn5ws+pxmDkqOyJKhlzFLSlASQYKQL19OK9STh7beXlDzEDW83zMtACScx4vZeoHAOwLqE+3LNIFDWLmpSZhh2aWTl08zigSvc3DQPbk4qLWMIpM7mj2pHOtu41EPFIhglDTXWnIE9HTicJEfF6qfDGeHeX1maADTWMCafW3I3poou46ljg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SBmaSqwPdNaDFFLf5Btbmnn/nbgumZcAXiiBrc6AdCU=;
 b=O8FpA0eyYNtWfDNGjiwhoBSdpXjM21zkUBtPJXVae78pr/yV6lWzXC+wTL+TRcqUI6e7jsEGzNZDnyBJblmjsCiFA3QlcmbezpMDp5RqRCzhh+BL3lh6+AtD0TM6L0bxe4BrUDRxjOZCaGZc1uon4MO1isD8ybNSYQpPtNnq6NeCO+iuhndpBc8pPlrbIIX1/ndtNDU2iuQ9PiERAQOTvBiaJi3a47anWp7I7R+dO55C6lMdmVn9pFyoy2gqIbtOu0tLwBmT6oPXfjcN1BDOICqpEL3fnWS8CiH2D6Euz6SaiWaiWr/6ax2Yq2wzD/BAYT07H/7QP1HW5xBwFZA/eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by MN0PR11MB6301.namprd11.prod.outlook.com (2603:10b6:208:3c3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Wed, 21 May
 2025 00:33:06 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8746.030; Wed, 21 May 2025
 00:33:06 +0000
Date: Wed, 21 May 2025 08:32:56 +0800
From: Chao Gao <chao.gao@intel.com>
To: <mlevitsk@redhat.com>
CC: <kvm@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Sean
 Christopherson" <seanjc@google.com>, Borislav Petkov <bp@alien8.de>,
	<x86@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	<linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v4 3/4] x86: nVMX: check vmcs12->guest_ia32_debugctl
 value given by L2
Message-ID: <aC0fOC8IiQJShYOe@intel.com>
References: <20250515005353.952707-1-mlevitsk@redhat.com>
 <20250515005353.952707-4-mlevitsk@redhat.com>
 <aCaxlS+juu1Rl7Mv@intel.com>
 <d9ea18ac1148c9596755c4df8548cdb8394f2ee0.camel@redhat.com>
 <fababe6628c448a4aa96e1ad47ad862eddf90c24.camel@redhat.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fababe6628c448a4aa96e1ad47ad862eddf90c24.camel@redhat.com>
X-ClientProxiedBy: SG2PR04CA0160.apcprd04.prod.outlook.com (2603:1096:4::22)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|MN0PR11MB6301:EE_
X-MS-Office365-Filtering-Correlation-Id: 6fecb3de-787b-478e-63fd-08dd97ff0dd6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?mkwZcvHRk0b7ylo8f5EbgJ2gXIMLO2KWGSnJ1x2d+zAs/glT9Ny3vaJcdC?=
 =?iso-8859-1?Q?kbEW+FnUMnCprsRS2zsiWk5dRS95PQWB1sxOM+dNG+/UFH1ee9ZXtxJUdA?=
 =?iso-8859-1?Q?/45Q4iCfJofLC5zKy1UGLy4wB+dpqR9Tqeirtnw2rSJX0rbMQrP5oV1ROu?=
 =?iso-8859-1?Q?rEWfmMU78oK5ryW0ZrTIzxJVjJAx75XJzeBZgh8MDjAkIIDX3rYknhcrs+?=
 =?iso-8859-1?Q?YZ8ibz9Tn/Z6goFMf32DSStH0FCieVo0R8Iqw3+mwucGFlcMBNO+k+WMY4?=
 =?iso-8859-1?Q?x9aF3QoTrd1wVlM8L+wNO/+cxpSd9a4aUicM6CoPDXMHU3kSG8/bOSrygD?=
 =?iso-8859-1?Q?5AOjqUBc3Iel+KfoJR5C5TQJ2hRYvuFeRWae5gllxQBKuwq4SPIHlx4rxQ?=
 =?iso-8859-1?Q?1aK7Vm9d4XOm1yxXZtGD9xJE452Yyhl5EhnAcGFyIozszybHV6CzO/4bw8?=
 =?iso-8859-1?Q?vGQRKu9XFn0gcj0jlUkmQoCooB9rpP7hGGjGZqQZRDYqrMyF0+5hgHfAm5?=
 =?iso-8859-1?Q?jrHGYIAkfpKmDDG10l1oyWxnmjWp+a8VlSKzQx/13F/XeOV/CtQon8clyP?=
 =?iso-8859-1?Q?KBFVADWhfKt67PGGHr3mXQeUw5UtHATbfVDMULhJkkKiHfPItJOWRivrzQ?=
 =?iso-8859-1?Q?eSbvDfCm7ecVW0zNImUv6pCW0YI+8PHDBE9jtCigk1hrhefaJ2uX47T9g8?=
 =?iso-8859-1?Q?BrvokNghsx29X2ROiDkohFTY+3LdR0/4D8Y09nEanNJp9lIsGOsb7GBgnP?=
 =?iso-8859-1?Q?FNKswmKXEKtlO0/K41QrDRQEkyQz8KXU4P8sSGAfWJKIekM5+zla/zaIHJ?=
 =?iso-8859-1?Q?xSO1y/gXu11YJZ/MLPzjkQIlp646SDLef6f6n8w3zkhVWObD+MaWAYPMUH?=
 =?iso-8859-1?Q?ZVoa9SrOXOYzKx2BaSP0hvUZwH0Jdf1uBHn2Ka92TdpTgfNa6eX79QBX3r?=
 =?iso-8859-1?Q?3Mkzdte06Q5i8PJ21K8Jf3yUxqcX46jxPtpT4hRwNgCkfHcpfXbRvzNKfR?=
 =?iso-8859-1?Q?4dAq3M7hNAOyBr18wCdVORD9mZ9AplbOpsYtV+ymhC18rlLBFIwrtxosVG?=
 =?iso-8859-1?Q?SZSzoSeOucV32ycd8FjfCVsLwkJQgAxSRR3SDxAoO5IiQPwPqikooT3wDj?=
 =?iso-8859-1?Q?moVzRqPPNAcC+5LfPk3vR/GmD94SDS6ILnNqOWecDi08Fj6RSqeCkgkAbS?=
 =?iso-8859-1?Q?oyQpsq46h4kpGQK/FBsmVLTOP+DSjBiYmkdNacTBspcp4scfKw8H+ZYfeb?=
 =?iso-8859-1?Q?T9A8h6uHTuahcU8aheHceDFFRnri+C7vbdeKuPNSTE7vEiNsYrKUTuJOjp?=
 =?iso-8859-1?Q?DKVLybttx/PVWJVyEpd6oNnff7GXftN3+rcDCTa/nD2hLihLGZS2vUBV7i?=
 =?iso-8859-1?Q?U+VA0qqremOHdjjKOh8wjWMf9kneZdPgyZ6eoLpdNw8/r5ul8XhhTZkwzZ?=
 =?iso-8859-1?Q?OWyoo7ZPMwWuubAco6Lav5BhJ3/utfgUUSPEcRf1HSDSSi3P0UUSZG1s80?=
 =?iso-8859-1?Q?M=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?AhOx2/hmpjJl1VqSqtoG4UKdz9LIE8ikxgd4m0O5h97fpaKgZ0jZrDgDO0?=
 =?iso-8859-1?Q?kjAVQTtOOdF1jEBG1h4AlXXM2t1qHMzVHeGU1dIQbp9k4zjhW/7N+v+Gye?=
 =?iso-8859-1?Q?nKHnKViy1cLiyz0U7xvn3vngJoMYHSX7mQLL1f9ffMGPrXCN1ZcNSQiLFS?=
 =?iso-8859-1?Q?d94YV13mQKcUTlc+eU8xHP2DrEj8sl3+8MSIzaLZxFiTkmmAlFl3AYbhnp?=
 =?iso-8859-1?Q?mFuC200O4vByPwWxO3uHYdILX3IBePhdg8EBFGXcj0nhU+xv/KhIK2asTp?=
 =?iso-8859-1?Q?CmozO9KbCkMsSbcJIX3DQIfgWRvkVSIcJlCBdUMrewcNMNl3zOU04sytgi?=
 =?iso-8859-1?Q?RrEwCXaQz+9R2PL/F72hYx8lemKE1bRcZtG/kq/u2XRKYJWnfPhBG4IjD0?=
 =?iso-8859-1?Q?+kwYeJDCOdmhDA8m8RM3S0B5Mt6ulzY39V4vbZD3gIzcHYCcAH8amTUsMY?=
 =?iso-8859-1?Q?3/FUbyx65WYxdgpX0MHro6k5eeXhU8sPwSNliIMS3GD8zzU8MYeOOqXMiQ?=
 =?iso-8859-1?Q?sel1+ZGG+sS01ga8usu20T06FkWwWcSfzkcmMUtx70JSfjCr3F+TFEnQg5?=
 =?iso-8859-1?Q?9iy/fPd4h3eyHAImLfHSw4ArtgilHbyiVTH/cIhACUnO4LPK/5rL7UqVT4?=
 =?iso-8859-1?Q?uz3VhD4PwQda/aFl+VwSSSJwWsWHzz0MAeE489TYT+lgy35pGHo75nTyVh?=
 =?iso-8859-1?Q?NEgKVq09YJe/k2xjnMEZkQRQB3EH2IizyfSOIUbuD//ZxCdfKea6J0QPnI?=
 =?iso-8859-1?Q?jWSbZjiSi5/XiJuIe8Y3r5IZHWGGVhmJ4Oynmu3S8uMQlDsYEFayL6Md2a?=
 =?iso-8859-1?Q?lbXB7jPHj2EmD7mIYz0TBk8TR849wuRgye02O8bLOrWTUymL3AnPzFpFHm?=
 =?iso-8859-1?Q?9XpvTsFvlY6CFyN0WWzzWm4/D624FW+9M9GfAHeaarzh1U5KhG5tbqOVv8?=
 =?iso-8859-1?Q?3bWpF3c5MtlbpHC8P04X7IDTDvBmWWL8KAC5FUmUGL95IYsXTYXW7QHECL?=
 =?iso-8859-1?Q?JcBmWVPsyYjlnrAJeWsffqlvBvKuBS6VG7k6EkS4dFLrKYLqays+/SEzOI?=
 =?iso-8859-1?Q?XD/RvGGgHK65gEdw9OGgtSZDd/96rbxfQw1FWMBfnMNK3hPzKqhUe+FwdX?=
 =?iso-8859-1?Q?LygLpKh9rFuJQBXN+jZdvY2F6WdQYMpH+hexkwqKo7+IZS6jfzgjEp6jHw?=
 =?iso-8859-1?Q?5TYJjeOSAt10PEBr2dmIVbsqv/ZuaJbyWa/5C/F2DBpmOkkhReyDK/FOrz?=
 =?iso-8859-1?Q?cF0BpzQ9Pvw+tKLG4k6cKyQEusune+5dXjT7IG5CV1zqRKkmp9kOW9qU9E?=
 =?iso-8859-1?Q?Soa/CtEcK8AsIxyF5XbChAKheg90keismISdXV3VZ2PL/2wUArHXN/XW1i?=
 =?iso-8859-1?Q?8ey4g5awLFZ6VrLCxrCzH/dOL3C8mFWe5WJ7SS8s6NTENBNqbRkFD3IYgb?=
 =?iso-8859-1?Q?1crnIqs+uVh6FvKyRiERgcQkhapzA80DzOGlxGPz4mNoYeOUNVwJEfsJLK?=
 =?iso-8859-1?Q?aUM4wXLBrPM6SnjCVGEp/ATzmh4hf26Rwax2t01ruLCCFW1rHsIEIqwfGK?=
 =?iso-8859-1?Q?Sw1EO3EJb4EKK/5csErSiFvKSnjUnEAjdgZqHWKCJtxWJ2DDmNZ+5F8GKn?=
 =?iso-8859-1?Q?fv/XVM61O/Hc5PzGNeHJN/+N5jHNsknmCI?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fecb3de-787b-478e-63fd-08dd97ff0dd6
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2025 00:33:06.3280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pYycdKRAjUPzBDcbykV5PRs1v1GfDAPcFt76i8SUktp1sGEKB7EuofX/gOPnZE2hFDHFaJM29H9InZEb/exljw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6301
X-OriginatorOrg: intel.com

On Tue, May 20, 2025 at 05:48:44PM -0400, mlevitsk@redhat.com wrote:
>On Fri, 2025-05-16 at 10:50 -0400, mlevitsk@redhat.com wrote:
>> On Fri, 2025-05-16 at 11:31 +0800, Chao Gao wrote:
>> > On Wed, May 14, 2025 at 08:53:52PM -0400, Maxim Levitsky wrote:
>> > > Check the vmcs12 guest_ia32_debugctl value before loading it, to avoid L2
>> > > being able to load arbitrary values to hardware IA32_DEBUGCTL.
>> > > 
>> > > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
>> > > ---
>> > > arch/x86/kvm/vmx/nested.c | 4 ++++
>> > > arch/x86/kvm/vmx/vmx.c    | 2 +-
>> > > arch/x86/kvm/vmx/vmx.h    | 2 ++
>> > > 3 files changed, 7 insertions(+), 1 deletion(-)
>> > > 
>> > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> > > index e073e3008b16..0bda6400e30a 100644
>> > > --- a/arch/x86/kvm/vmx/nested.c
>> > > +++ b/arch/x86/kvm/vmx/nested.c
>> > > @@ -3193,6 +3193,10 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
>> > > 	     CC((vmcs12->guest_bndcfgs & MSR_IA32_BNDCFGS_RSVD))))
>> > > 		return -EINVAL;
>> > > 
>> > > +	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) &&
>> > > +	     CC(vmcs12->guest_ia32_debugctl & ~vmx_get_supported_debugctl(vcpu, false)))
>> > > +		return -EINVAL;
>> > > +
>> > 
>> > How about grouping this check with the one against DR7 a few lines above?
>> 
>> Good idea, will do.
>
>Besides the above change, is there anything else to change in this patchset?
>If not I'll sent a new version soon.

...

>> > > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>> > > index 6d1e40ecc024..1b80479505d3 100644
>> > > --- a/arch/x86/kvm/vmx/vmx.h
>> > > +++ b/arch/x86/kvm/vmx/vmx.h
>> > > @@ -413,7 +413,9 @@ static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
>> > > 		vmx_disable_intercept_for_msr(vcpu, msr, type);
>> > > }
>> > > 
>> > > +
>> > 
>> > stray newline.

Can you remove this newline? (not sure if you've already noticed this)

Also, the shortlogs for patches 3-4 don't follow the convention. They should be
"KVM: nVMX" and "KVM: VMX". With these fixed,

Reviewed-by: Chao Gao <chao.gao@intel.com>

