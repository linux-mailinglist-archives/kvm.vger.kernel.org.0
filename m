Return-Path: <kvm+bounces-72014-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UOZtGpBsoGk3jgQAu9opvQ
	(envelope-from <kvm+bounces-72014-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:53:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id A5A121A92AB
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:53:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 9DBC5309520A
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:32:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B401B3F076F;
	Thu, 26 Feb 2026 15:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lilITf6r"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BE53F0761;
	Thu, 26 Feb 2026 15:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772119947; cv=fail; b=HyYOvMw+gG2FrbE9dke+gaAhFB7rVG+Nuwqz0nCf8r09il+aICNYMy1FcahTE1ZxeXIlOmrqw+L6ewKE1GpMhuamkwdF2N6Jip+mKPLQZtpoK55a02ao4XBZfJ6DbOfZdl+6/GIfsOcqDBc05pSeld2kGkixt6K/9QGGFR5OwLI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772119947; c=relaxed/simple;
	bh=tHsGz4M/FVTC6ohE1J8Wy5ho64icFgjStfvKXjfFz2w=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LAN6ROO1O3W7faSefrp+tNHhYQvsrga7UZUveHE5MRQ1E64kfakQ4tOICHV0HndH/Nif+DLa0zmG7ech3eOUTBCljrFi5UrnHYswV3jMtgaU2LbViK3lEa4ZdD04/wVy0Tog66HQsXOC1WmKEpLA9k/4DlPdXCrV+oi24aycNuc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lilITf6r; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772119944; x=1803655944;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=tHsGz4M/FVTC6ohE1J8Wy5ho64icFgjStfvKXjfFz2w=;
  b=lilITf6reQ3RE+3ToTrZGNS0LVw/O9Qe10k9KuIe5JUlVGgAnEZI4sQg
   y9MWVhyDs+WxkBsLnjVX44RcRhlErh3aeGuj0BEAMLocZxpDKmTXRBVJ7
   HrvuG6vv+FXb+19ElzyDZU8xWOZ4vOTR8aMA8TUmET5YtPH+GOSxDworI
   HAe/K17aImmRNk3dFh7cl8JQuJBHowif8D0rv/ZgsF5ByBIkKJP28w2Ha
   jIJsfKCI7boIgDFNbWriID8+/vd9xCJrSiNaLUFjBQRatNVfg6gEbJsXG
   7+PBfG2GPG6d8wuTqXqWTF6mG/w4ays3uPp/1dQJ2tR3QpU54oHsf/QDP
   w==;
X-CSE-ConnectionGUID: EhTWtLIGQGWI5g37a0s8Og==
X-CSE-MsgGUID: sh2mWmDLTiqKeo3Yw9dE6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11713"; a="75785169"
X-IronPort-AV: E=Sophos;i="6.21,312,1763452800"; 
   d="scan'208";a="75785169"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2026 07:32:24 -0800
X-CSE-ConnectionGUID: xX1fGGoaRvCqsdEbTL8SIw==
X-CSE-MsgGUID: /Dyc33PbTvS+FEZwDMZaNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,312,1763452800"; 
   d="scan'208";a="244154231"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2026 07:32:24 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 26 Feb 2026 07:32:23 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 26 Feb 2026 07:32:23 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.25) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 26 Feb 2026 07:32:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e30RuZiMY5jVvbHvZkV47GPi04uM8Cm4z1qD5ff4m07GX1nvzLdYl4nk1UZU7pcwpXza5+5xhGoGLAO1uvKifTFD1nDiL30Q5oZhSNHxC7MIHQRCsD5RO/NyznUomGcjFy/w0aJPxIiqizMw7cO2gKGkUczSsQiR8Ns0ec68+Ugpmw/X/1lWhrEJpBvi8KH/ykK0WXap6Sq1O8pI6+tilxGxvcpuPn0psH6X+ebU917/KgFHVLfngsigKQaIGgLPP7LMimTVgd2QPKLIvifzp2VoDiZa/Lhs4GJlRsFDreSq4n5+FGIGiVI21yT6Gv1f4Ujf73zla8V/LC3TXSceNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=abwAM/0NUaF/knnS66nINdxbATrssUabv/Gx9ROD6eI=;
 b=DMo8X5FPfIGNjgTPo4Kf1SG9YZFEIx2t/acSl5CjbTLn1Q25BIljvEjoRypws1FvRnxmw4u+oKNhrsPNdR8Y+hYkNnEpExAZv04rT0kJcM6V2PLBzxZGOO/YL1ietXcfzBYs46kdAmLCW/y5z0oiG7AwOZotZ9mweFGc1/PeAEbs9CKS5JVd6MjlszlkHf52DCd0WajYtXTY6hLao7SOhTNnCpdVQ7guXAYw7htag7d6KofdyCLWB0PrR1colzInv5O2wpvbSAtmcmbM83UbZgYnzQpaQ1IkS271nAu3ItdAdmaKvQT/3PINmcT5q760HV8qA+0qGmcUxHMaMqC95Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SN7PR11MB7440.namprd11.prod.outlook.com (2603:10b6:806:340::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Thu, 26 Feb
 2026 15:32:19 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9654.007; Thu, 26 Feb 2026
 15:32:19 +0000
Date: Thu, 26 Feb 2026 23:32:06 +0800
From: Chao Gao <chao.gao@intel.com>
To: <dan.j.williams@intel.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "sagis@google.com" <sagis@google.com>, "Duan,
 Zhenzhong" <zhenzhong.duan@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "paulmck@kernel.org" <paulmck@kernel.org>,
	"tglx@kernel.org" <tglx@kernel.org>, "yilun.xu@linux.intel.com"
	<yilun.xu@linux.intel.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v4 21/24] x86/virt/tdx: Avoid updates during
 update-sensitive operations
Message-ID: <aaBndinjh51R2wQU@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
 <20260212143606.534586-22-chao.gao@intel.com>
 <a0a5301140be5a3d944b1c91914b93017af026fb.camel@intel.com>
 <aZ+31DJr0cI7v8C9@intel.com>
 <699fe97dc212f_2f4a100b@dwillia2-mobl4.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <699fe97dc212f_2f4a100b@dwillia2-mobl4.notmuch>
X-ClientProxiedBy: TPYP295CA0058.TWNP295.PROD.OUTLOOK.COM (2603:1096:7d0:8::9)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SN7PR11MB7440:EE_
X-MS-Office365-Filtering-Correlation-Id: cf77a031-8492-4c4a-43df-08de754c3a1f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: TvfETNzGTyuzk5/LZXjnxu4k7WA5gj6Hkk7RT10/h+7kG5mpDc5qWq6H+n5naWwUxNKbLKsco4qa3Ok41wiOX0efi6qHZSRyZVh0cYOGBx1zLbWV7gWTIfc2CFcJ4F3ZXY7EAmqjqb4SxyFMF3SlsrRjZpWFZi6b/LUuGadFnmKMGcUe0AepQO/Ec2pXRo13kpZCeSHNtFEFPQOstDdoF4hyU2GavpLM1kfuezJc5bnbFJFKyoNFcF/raxg1CZhTOLSdqUv7TiJuJdADT2wHB2WowmoXmLqFmX18qjbKsbrEhG6Wi8Yf5h16cKmeE+xMtI1A+77yidpJeAbrYsMmivPtP5fMV9R+7JyS+LqtHWYxEDYAAl8SBF7BT77os0vkUFuCCxWRAL1WrbT2CK3P3B/N6wbpU8yG1Zo2e5Tr8y66xcoP2EEzCUGc13/DDAV0yBUbLXmBhQ+3668H6kLFAG3tFJVlBnM3suoqGE9P7K4hj2oOyqAi/FkcUViPhmhESVSqrZi2/xOeChK2cRQKN93dZ46U7qI2/6kIcEpkUAHDfZIM2EqEZB/Ke4bn4tEHZlyZH2CZDTSOBMCO7LgJz7NaNTVOfOvb1P+LvLbFuZup2yCjCrfgVLAd2MJ50B7SFHXbjzdUpieHiGXr50icDrd0hsRhft0Y1XPdEbkRza455heQcuw1insh/B/NXNVVcF/WZ2Ekvf/ksM1b9+lNhp4m4p9x0z42jySNYNbuQ1w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rz14zv1WXzSVBOFXRCVKGaV1OR0jbttIH4fMTbO0fnd6rmCxeJVjiW2CJOD4?=
 =?us-ascii?Q?7zjBwWxlWa+z8KlQN1X8VQNampumUVcGJpYPhtgOr5utvOzakdAfatXoguLv?=
 =?us-ascii?Q?61mJROIZAQRAxRhd0zO1JexWCKr0cuzb26R8QegiMZYjvHyF7Bs46IIzo2vQ?=
 =?us-ascii?Q?5gLI5zTKpDbYGyywaJ0qoHsiCJwABt4dZ6Ij9hOczgZoFJQGaToNXon47bOv?=
 =?us-ascii?Q?cdZPSRUjdqZG4wzUhmefRungBSsM6E1VfXzfjX02bUlU/SS02WMNMM+y06rt?=
 =?us-ascii?Q?krJtwiPopB9u8txGw4zD9w+8XQkqU0YCR2oTeme/BM9dYl5usMMAofil/7Fa?=
 =?us-ascii?Q?L3a80fBzio+0UqTqtF9h4slijQ/8bFJfMV56D2FYBqnJFMlWJ7e8uUANyU5+?=
 =?us-ascii?Q?iLR5aCu13euhx17CijNeC03JW/PglpOhax+wxvgMypKJwnzALAEr0fyaoq8Y?=
 =?us-ascii?Q?yg6O0L2Lb72mSY5w3Nm4qIp4JkWyfaqBUzVYFnlRR3Dh1YG8w3lDnX/+vEdq?=
 =?us-ascii?Q?cIf46aNYMygg+eVxr6RT+z8tmPrgDj+p1zszUFhdHX4p0LxL5MUeLluquPqU?=
 =?us-ascii?Q?qNMriNqv043MBNs0QNGw1235/OliKBZP0f1Uz+scvR1z9/iFi5ZmqzcK5hrt?=
 =?us-ascii?Q?RrHolm8onJa1dId2LomAl7aeDouHhAV8omtT1eDehuSsSU/NfiVilg5uJxqR?=
 =?us-ascii?Q?yk9Gfivm25J0ULeCG41867YQiRCZS1v/mESKpQ1rKnOoOjAvxgPfpjywtA55?=
 =?us-ascii?Q?ztgtoF1T0g2Ya3OzC6MUQ7JITvBg8kz4LTmVZk6W8Ig8lDa4To0yyS9RLPN7?=
 =?us-ascii?Q?Uy3daWycSWk7lC50V98C9MmZseZqdcFtfiTh13G0vQh3BQp8OrhCe5IgUZ1R?=
 =?us-ascii?Q?5PYzI6w22fka1GvX91nOrsQkeluyeeqjWdnCwmut5PchMxhAY854v/n5g2V3?=
 =?us-ascii?Q?TCVzfHZr/b++7yM+6IyjEqIgmNZEMZeFHOa1VWoprsACN/MAoC5ugrbhaboD?=
 =?us-ascii?Q?Y62lnyG8g7siFdOI6SgUVcO2YULWY85T4kQejIsb4PaU7zr2UX75CuQX8ry0?=
 =?us-ascii?Q?5qTn7COpIj/uu8/RFvqScm8p21E0es9RYM8KhGSN2uQrxkOSQU1PVn3FoR3K?=
 =?us-ascii?Q?Qxk7BcTLSBreldeXwEeJ3RMIyqecsDHbhiMkC84RbKeVGcVPaNNcYlcv5q9q?=
 =?us-ascii?Q?xVGexG/CJoYl8JPyWvKAIHIpgTp1eYvX8Ty0ccLjqZlIofd8nsO9/g8wie9h?=
 =?us-ascii?Q?1O6D9ME427eyS0N50tw8tNmoqBbeKnvKTHCJ1M+U+mca0vaasqiiKKc06CT6?=
 =?us-ascii?Q?coQIxjnGKGMTLrZysaG8uV281Pio1Wz3FxnEQ0BO9KAPzuhAEfaHo662xeCR?=
 =?us-ascii?Q?YP2s+PGmDbCGSvJB5Zbsntv3AdAlgnhozq3qQDBDQdh8wfjz0yuTLiMbhxRI?=
 =?us-ascii?Q?Qdc8hSAqT+AMcN5VjSpRRhxjHli7PogQvi5pTaujEYgldxuTz+vZVc/m3EqO?=
 =?us-ascii?Q?QZPymnaXKVkWQIX8NPlUROrrdqDFHNxuJf7Jb5lsIdoNm3blu7tw+r4TwFm/?=
 =?us-ascii?Q?WbmbdmhRFYZIWjMAZNOejojM6RuW0KJzOQrX8eQXJ2tdr1Egvr5SmTd1pISz?=
 =?us-ascii?Q?9pnANZfSY7jmmAW3PyWBDfrMRxrQ5Qi6uwyYTQdSPcLi17TpnUtbOhoLrhWX?=
 =?us-ascii?Q?Ly1NAQbm5L3GTun9dRVGmN37rrCwm7tpgainfDs7Uv5/kPtwLtYQaXRcxN8M?=
 =?us-ascii?Q?v9AY2lNNrw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cf77a031-8492-4c4a-43df-08de754c3a1f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 15:32:18.8375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KogXIxho3dgONrSX3fZcNenE2aFVZ0w15nSw49hk5s6A9dlfXOFzmgKZpia97Wwa0RDFMI+2+NVaz4p6h2papw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7440
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72014-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	RCPT_COUNT_TWELVE(0.00)[26];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: A5A121A92AB
X-Rspamd-Action: no action

>> >The changelog says "doing nothing" isn't an option, and we need to depend on
>> >TDH.SYS.SHUTDOWN to catch such incompatibilities.
>
>Doing nothing in the kernel is fine. This is a tooling problem.
>
>> >To me this means we cannot support module update if TDH.SYS.SHUTDOWN doesn't
>> >support this "AVOID_COMPAT_SENSITIVE" feature, because w/o it we cannot tell
>> >whether the update is happening during any sensitive operation.
>> >
>> 
>> Good point.
>> 
>> I'm fine with disabling updates in this case. The only concern is that it would
>> block even perfectly compatible updates, but this only impacts a few older
>> modules, so it shouldn't be a big problem. And the value of supporting old
>> modules will also diminish over time.
>> 
>> But IMO, the kernel's incompatibility check is intentionally best effort, not a
>> guarantee. For example, the kernel doesn't verify if the module update is
>> compatible with the CPU or P-SEAMLDR. So non-compatible updates may slip through
>> anyway, and the expectation for users is "run non-compatible updates at their
>> own risk". Given this, allowing updates when one incompatibility check is
>> not supported (i.e., AVOID_COMPAT_SENSITIVE) is also acceptable. At minimum,
>> users can choose not to perform updates if the module lacks
>> AVOID_COMPAT_SENSITIVE support.
>> 
>> I'm fine with either approach, but slightly prefer disabling updates in
>> this case. Let's see if anyone has strong opinions on this.
>
>Do not make Linux carry short lived one-off complexity. Make userspace
>do a "if $module_version < $min_module_version_for_compat_detect" and
>tell the user to update at their own risk if that minimum version is not
>met. Linux should be encouraging the module to be better, not
>accommodate every early generation miss like this with permanent hacks.

I realize there's a potential issue with this update sequence:

old module (no compat detection) -> newer module (has compat detection) -> latest module

The problem arises during the second update. Userspace checks the currently
loaded module version and sees it supports compatibility detection, so it
expects the kernel to perform these checks. However, the kernel still thinks
the module lacks this capability because it never refreshes the module's
features after the first update.

Regarding disabling updates, I was thinking of an approach like the one below.
Do you think this is a workaround/hack?

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 2cf3a01d0b9c..50fe6373984d 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1192,9 +1192,7 @@ int tdx_module_shutdown(void)
	 * modules as new modules likely have higher handoff version.
	 */
	args.rcx = tdx_sysinfo.handoff.module_hv;
-
-	if (tdx_supports_update_compatibility(&tdx_sysinfo))
-		args.rcx |= TDX_SYS_SHUTDOWN_AVOID_COMPAT_SENSITIVE;
+	args.rcx |= TDX_SYS_SHUTDOWN_AVOID_COMPAT_SENSITIVE;
 
	ret = seamcall(TDH_SYS_SHUTDOWN, &args);
 
diff --git a/drivers/virt/coco/tdx-host/tdx-host.c b/drivers/virt/coco/tdx-host/tdx-host.c
index 9ade3028a5bd..c7f0853e8ce5 100644
--- a/drivers/virt/coco/tdx-host/tdx-host.c
+++ b/drivers/virt/coco/tdx-host/tdx-host.c
@@ -181,6 +181,11 @@ static void seamldr_init(struct device *dev)
		return;
	}
 
+	if (!tdx_supports_update_compatibility(tdx_sysinfo)) {
+		pr_info("Current TDX Module does not support update compatibility\n");
+		return;
+	}
+
	tdx_fwl = firmware_upload_register(THIS_MODULE, dev, "tdx_module",
					   &tdx_fw_ops, NULL);
	ret = PTR_ERR_OR_ZERO(tdx_fwl);


