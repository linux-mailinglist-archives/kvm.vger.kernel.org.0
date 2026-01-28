Return-Path: <kvm+bounces-69339-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KN0gNCP+eWm71QEAu9opvQ
	(envelope-from <kvm+bounces-69339-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 13:16:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 49717A1116
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 13:16:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DFD31301727A
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 12:16:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7C812DCBFD;
	Wed, 28 Jan 2026 12:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WVaaDyZB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0559419E97F;
	Wed, 28 Jan 2026 12:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769602582; cv=fail; b=VbCPOB6vy0iEV1URri4pcG3P53EpxCt3pQgTWVeVfsFMBqQHurfeMiUNM/tYNSE1acWrNOwo/Uu2/S8SO7tDMClRIWW0mx/fFEuhJ9NeFh7ZR4bOPrSO9AGKsd5l+4JAICUqcuJO9rqDS1eTumYcRAh7V1McSodi3g9RHKUDkJ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769602582; c=relaxed/simple;
	bh=koNhoyZElmt6pzskoQ8rIRF9omohE+nmgt3cxhs8Kdw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FA0uI/ZD+YbLBvUHU0sIfdvm3bN34bCi66a43CH8xcWrqeQLUD/RF7Vp0gjNr1uQjNpiH0ePThioAuJgl4cUsqJUvKbUXek07eKRqWeHRbDYxXwinI63n7pNwgFPVi18Qpj67suY0JlpUVNGd1Tnog2wH3EaH33vnNqCs+0Z3A8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WVaaDyZB; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769602579; x=1801138579;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=koNhoyZElmt6pzskoQ8rIRF9omohE+nmgt3cxhs8Kdw=;
  b=WVaaDyZBfU1XUvGsKW7iIg6wdb3aOPrrmF5CaKsmSLYdWfu+KI9isNbE
   ns9hZ5C6P8ZcyQ4PjakQSlQmFzDjpU9AhEnKSznEaXPvk3tdHlClPhQ0l
   nac7vm4l99NqweKQlsvuUJuIcRuyw76kCxTCCSL2BDKJSu3R+Li8WF1K0
   X4u+D0XuEkGRkJNeIrhyD51pXNs72Pt0RCRkHcW1h3EQV3ctY9SJa+/F0
   pDL2Nbc5heXDg3/qPKwH/F8xdH/Vp2eHZUc/8m2d22pYhw+smyzrDqxKH
   veL1Fh2Nrptb7s15HhPMjzCrvJ1oy9CQMcmnLKXDcHbjs8HsSNodH+tvT
   A==;
X-CSE-ConnectionGUID: wjK2FiLTT3qBjtWnoqRfeA==
X-CSE-MsgGUID: YoS0GhxEQGaD2JNL++paEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11684"; a="70903216"
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="70903216"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 04:16:18 -0800
X-CSE-ConnectionGUID: rPNXYWFBQey8yIuGqcYFmg==
X-CSE-MsgGUID: asetMt9SQ+uZF8HEIJPn3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="208616998"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 04:16:18 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 28 Jan 2026 04:16:17 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 28 Jan 2026 04:16:17 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.47) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 28 Jan 2026 04:16:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t+o57d/uC82DncUy7doYKA50n9GahaA6ilyjWWK5CvQ0GwtyDd3VQPRMrxWvoplyyMQWVaR5TLk3GqHHSAy6py7mAIrlIHHlLsp7BctpyZ9SjeN7tVKC/V1yGqHPbjf0DM1oR2BQFOfW+kytvvPr0JNhQYWTxFGGJk/i0Fa9dvPVYTNfKBC7G9QbJLrXBBcuf6bv28sktPnxRxjtc7AQwEJ9Rfc7vhW7FmlnwnCnk9IY7XcyiLaG3XKx02g5sjCeG3Q48S+X2TreCIGXENSgNKPrraUkgmfH9mg/JVcGW3rLMe969GXMQ31IZ2wIgueLkEBl6R/1ETLrFqf1QJVwMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kk4gmwg9XqcuA5xC9JAYb0VdhrQlz6DIa+67Cnh1oBc=;
 b=FoDUDIlXX2R9315OQPZwlcqQ/UKBtKkFwgjPXbgFCm9Bw2PnHBjoISddEAmo/gyWh+gTfo8UY7bOY/WN/BMbJTAj/v11B7l7FSrgJHJCJusEVdvNsUVuhlOTVBx5wkEk3MmITCs8LVlrSDiFdDXSrjhqUjCsst3FL6XHx5TaUyJhD0xge3FEyjq44l2py485PziOtNnYc8p1r+BwBV3cnkZ3m40AGjeKYaH2c7HTpRSffyyN5gD7yyHTUvvxJFE608gFHJF1VL2o8JeLS/7nxj7TAYqGkmeWZ8ZmR0dNTMrKk1mGbRLKXp9/9R5+q5EOtf8+PLtful72lmhlVDtQ1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA1PR11MB7366.namprd11.prod.outlook.com (2603:10b6:208:422::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Wed, 28 Jan
 2026 12:16:13 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9542.010; Wed, 28 Jan 2026
 12:16:13 +0000
Date: Wed, 28 Jan 2026 20:16:00 +0800
From: Chao Gao <chao.gao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <reinette.chatre@intel.com>,
	<ira.weiny@intel.com>, <kai.huang@intel.com>, <dan.j.williams@intel.com>,
	<yilun.xu@linux.intel.com>, <sagis@google.com>, <vannapurve@google.com>,
	<paulmck@kernel.org>, <nik.borisov@suse.com>, <zhenzhong.duan@intel.com>,
	<seanjc@google.com>, <rick.p.edgecombe@intel.com>, <kas@kernel.org>,
	<dave.hansen@linux.intel.com>, <vishal.l.verma@intel.com>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 02/26] x86/virt/tdx: Use %# prefix for hex values in
 SEAMCALL error messages
Message-ID: <aXn+AHBfbbeGzxWO@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-3-chao.gao@intel.com>
 <35fa8047-7506-4a78-b493-732160c3d25c@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <35fa8047-7506-4a78-b493-732160c3d25c@linux.intel.com>
X-ClientProxiedBy: SG2PR02CA0075.apcprd02.prod.outlook.com
 (2603:1096:4:90::15) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA1PR11MB7366:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c1c6d31-ec2e-4d94-55f8-08de5e670782
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?c99fAXZLmSkjdqVCa29DqQQBdrvdZEhs5slsctqtTuS+T04WmoEF5gTTCops?=
 =?us-ascii?Q?+epAb7kbx9+EVzDjXohuqbn/MN2v/cn0nalWaTF/T+G3oN3I00KnROVNyiSs?=
 =?us-ascii?Q?Iaf8NAGB4rNOFXcf38hPdjGeTmFBWMMO4uevUSMFj/hzSRd2fHRBvOT1FnRi?=
 =?us-ascii?Q?mkL4JY6yYGsCIRTMcC23AOcn1YaArs7OBycwGR7jE/kOVdVAAKvDUZPhQPUq?=
 =?us-ascii?Q?L2XxrHYrKCjgufe1rKLN1KsCyvBcQ9hOTUIlSmfYmTk780JP1UGyiFEUKoE1?=
 =?us-ascii?Q?HssrMLiAyuPSoRnmlafEUIP6g1KXNEhQM6RvYLHtQ145E09xr1ZEGy1+ZO/A?=
 =?us-ascii?Q?AGmzL+y98xii4t2fW/fcIJQJ/F/2E3hzS1z7XghERn5xIowWsPgI+Nlztg/N?=
 =?us-ascii?Q?k9iJV2EK/uTBWhM5AkCwttVJyPHXOBbSrLs9x5FlDrXOCXA40C+H6iJiNmp3?=
 =?us-ascii?Q?CX6cGyAdmwjwl4pV05r2/LhZFh3w/aUr8y+ucmMx0R3HNKi3v/8YdoiIEHCD?=
 =?us-ascii?Q?UGmgEZMqRPi7Gy9AtQiPnSdlojL+qsKg7AHvPa8kNpzYGLAvVMqHSh3bzaVL?=
 =?us-ascii?Q?rgrw2RzBy0wbjNQXf52cVELeD7sqUwQ+9+tl73ffdZWlVd9L55c06KXLwgS8?=
 =?us-ascii?Q?smXHty0XA7ufGDTDOaAReMvIau9FLkMM/XWMbe2z4fLaPwbNrLohyBL3n+1g?=
 =?us-ascii?Q?UmP6QARN1epGHkxMcSroPKUlIBVK/lDqKpTmkAvkQAFST0U28EDWz8R6X4pV?=
 =?us-ascii?Q?0I7aRK0k45ryKoSHo2gTKUHpcRqnM7VUqg7Dgw1014Uia56gwaR3fIEIBbLg?=
 =?us-ascii?Q?LSaVyBqeW8t9P6lZwwTvoees8ohOHGM252zH5Ibc2UCDM1JqOWrprK9epV+d?=
 =?us-ascii?Q?ewUrJOA6XTNGLd/8U+Rajed+iZmaC11plaviquudwHwEekGBQYfTr0lr5TCJ?=
 =?us-ascii?Q?WlqM8Fl2GMLwpbGxbCoeOSiOD8nI21bU9k0Z8WlSI/u5hZ/BDYLExfjF5Es1?=
 =?us-ascii?Q?Ojto4KdnXsTT9AyVhXKrbSHTb6mhTj2Y88/NKRpfSXMGvCE1wQnQKe4xxyay?=
 =?us-ascii?Q?GwoZknduA9ZSzV2i+10CfkSeAi9kma10C9lgJYTrmWzChrFlk1z47bwvD9GH?=
 =?us-ascii?Q?37WaEhnOJl/j+aZHYr304FpT2JjLEPAo94bL9a+er1ndyHIIC36O/He12bxN?=
 =?us-ascii?Q?dkfLeLQV7iyHvRKrud6Gd5iJQcgn4gW49OzG1jRpydAf4tSdjL66NYJP6H3K?=
 =?us-ascii?Q?BA/PAt9SBDI+w6Gd4Cs3lHFp+djduLPaasTR9m69LTASLmhIZrTwTyhSUmch?=
 =?us-ascii?Q?dRYKXqxFS7Tlf7ZnQWWUNa4Y3Lkn60TEKTfxMV0mHNIf8FTAnHxFSPPMkyYA?=
 =?us-ascii?Q?5hB4IxBl9Vr34+fJDuLno6nxWCfqSpVxajPAAFayUfSTPbbVCVKGrTmrmWKj?=
 =?us-ascii?Q?dIreCd7nZ8JGnd9Lc7wipgwiem5asp6USaSRiLQDNZn5ugPDVP9446FuHIvD?=
 =?us-ascii?Q?TzNrW/vXS4xc1Nri+VOoIdxGojSV3aeaVd0nD5/SktTdmzy5AeAeaGiJClBK?=
 =?us-ascii?Q?EjuLB6iV86aHT9KrlZ1Si2Na4x4xsOmsJotthQhz?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?toZYQ6f55IGJu9l3MOTBN+aArZkEmbx1tenXzwBB90Eb+ZBX1neOM1PbVr1A?=
 =?us-ascii?Q?AzRADFZnXKDWeKO+HI734DxeaXnVPkWUd7tKA43PfzeuLuZSfrZIWTzyVXS6?=
 =?us-ascii?Q?8vR65ymxDfJSG3zfu9CS0ya7WVFJfPddOeQc1vk/OXR+T2FsaOGjq+5Xahwd?=
 =?us-ascii?Q?OimvfONaDr7gK8yYKIn/e2nhd9q1bsYvCMfa5YK407U13SLTeMpb7DXf+fkb?=
 =?us-ascii?Q?NW57RA3Vvp0GH6c4NvhdojVYYv3Ki+GLzqBJEWmxGJLPGzboRLsNCtNooTQg?=
 =?us-ascii?Q?tinc1cRMilxJv9cxUV5ipNRIZh8xeDK45uAQf+l4/gcNgXPRb8x2U+heRnL+?=
 =?us-ascii?Q?VS+QcgZJY5+rguFKlLM0V9noakJZivHxDO43uhy6nnv6IWNrQEZ1Qc1Z5ICQ?=
 =?us-ascii?Q?z9gmzjxO2Vw32eusFj7qojeb3NRRq3BpIDG0e0aezdzHlrUXmstqEbHJj6aO?=
 =?us-ascii?Q?w9wXofdtrI3E+MEaQifZsrANGOpn1q8uRCcWBoPcEOc0d3HM4+VurKD3Edim?=
 =?us-ascii?Q?53oLuldxyWVyoeDCie8Vd3IS1MMJsbUBe4/pcjLO4xY7KzdV+fvx8Bwz2Ndf?=
 =?us-ascii?Q?aeKTUf0xwrYXJBlf+CR/77fQClIJYrMAPFtFa7c8q9A8F52uyLoaQTv4qbPf?=
 =?us-ascii?Q?urcoupbNgaxqgb0ucSioLQAEZFPsUR1BGU2ZgwKZ0y0ufepER5FUYMJfuXId?=
 =?us-ascii?Q?a1auErwxTOGkUecy/b37Lor0s1rpj+r7NPYi9Vxm57RMqwP12ny96Mj9EfFQ?=
 =?us-ascii?Q?WUm0w9TN+fP7WzFVQj1QRq9Lix2dYGoxFpEiBDNqIzS/ba9TNY3nne67v2Ai?=
 =?us-ascii?Q?YPCB5F1pK3pyO+7SaQgnbOHSDuS1BR55kCrOWlFnqv4SwE3cCai+uaqLBDCv?=
 =?us-ascii?Q?EHhu9qKZwMaJIfJ9y0Z5i4AO6mxOnzGL0hISCLXXXa/vB9e7wMzqZBN7qyH/?=
 =?us-ascii?Q?CShvaw5EBsocBfCvHNU/bs3ISBttEUt753OlkYjpGuWBmSuz5oAG/DI95C8M?=
 =?us-ascii?Q?88+rMpiNmG3OYhpXScxfyZo0CMVHxc5G1+AfnyWfPilMQFD5kfSnMi2Oj/+G?=
 =?us-ascii?Q?a1xjd9kq6tj8FZ10DeqK8QuorT+MZEWzqhmqkbxsQ/svDTlcDtoX0FGD0Ftk?=
 =?us-ascii?Q?EIe7dOGhtlDG5TBWqE5BgdPwks6dQ+hHJsWL1t32PeBczXXIWchCfxvDC+ts?=
 =?us-ascii?Q?yxEJ1zesldKZiMYG9krZpnhNeUufLcqo32V4wX8QPwWVyyM31VRWWXbm3sxS?=
 =?us-ascii?Q?FxeFfv3iVyfRRnqtmHOGl3zLuxs0BkpvfxE3eGDk99UVWFH5MrEHZa4cLKKC?=
 =?us-ascii?Q?XTedx48FUfpV8zVd0zaZ3X8Q1qgnenm0gmsRgO+u4F/LiCwbr/RDPWVIsmIU?=
 =?us-ascii?Q?O6c9R+ffEoRYZwh5XG9S7dU0Azj5csPT28YUPlrWc9nJkff6e8ExhAJ96Tzm?=
 =?us-ascii?Q?0rOiHtK2bomiUjwwfg5UammdszP0BXc4L2MDIhitnKp3tpjUquZXpIPRiUQ5?=
 =?us-ascii?Q?1iMErgzn15dIu20Q1o/pf3Ub8GsCaJcQYNURAc5+sXH56nhaLFpzwrMo2d6k?=
 =?us-ascii?Q?X2+ilvYsgqBJcC09wjZOfTYiq0Kut1t84n7IUAOzLo/MxWugXT63hZUa2R99?=
 =?us-ascii?Q?3U6mYiZqDdI1RKPMLR7Xz3vraicCXr5QI3mgzNaV7Hr7zAwIlt5dq2aPYCze?=
 =?us-ascii?Q?koZvFFPRvFDeLyzzhuYameoX81LcgfFsjRSFucHSp9g2G46gQkEdQhBhpIWZ?=
 =?us-ascii?Q?FFyjGsa5eg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c1c6d31-ec2e-4d94-55f8-08de5e670782
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 12:16:13.5055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B4nWg7V9a+p9T3Ps1BFAEL+X289cHZCk2N17gh6bK4/qSR/rz+gjS4yNRxUlv6TVVSu2tOyzqt6Rr4E1g1M7vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7366
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69339-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,intel.com:mid];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 49717A1116
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 09:34:03AM +0800, Binbin Wu wrote:
>
>
>On 1/23/2026 10:55 PM, Chao Gao wrote:
>> "%#" format specifier automatically adds the "0x" prefix and has one less
>> character than "0x%".
>> 
>> For conciseness, replace "0x%" with "%#" when printing hexadecimal values
>> in SEAMCALL error messages.
>> 
>> Suggested-by: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Chao Gao <chao.gao@intel.com>
>
>Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
>
>> ---
>> "0x%" is also used to print TDMR ranges. I didn't convert them to reduce
>> code churn, but if they should be converted for consistency, I'm happy
>> to do that.
>
>Generally, is there any preference for coding in Linux kernel about
>"0x%" VS. "%#"? Or developers just make their own choices?

There seems to be no clear guidance on "0x%x" vs. "%#x".

If anyone has strong objections to this change, I can definitely drop it. I
included this patch because Dan suggested it during his review, though I'm not
sure how strongly he feels about it.

I searched lore and found the example below where "%#x" is preferred in another
subsystem:

https://lore.kernel.org/all/20251202231352.GF1712166@ZenIV/

