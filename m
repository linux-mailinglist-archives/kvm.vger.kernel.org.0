Return-Path: <kvm+bounces-69520-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2KT8CM8Ue2nLBAIAu9opvQ
	(envelope-from <kvm+bounces-69520-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 09:05:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9299AAD193
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 09:05:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 086AC30234F6
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 08:05:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B778E37B3F5;
	Thu, 29 Jan 2026 08:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X+PvCTA/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6AAA37107C;
	Thu, 29 Jan 2026 08:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769673922; cv=fail; b=FYjiPdsacI2Wvu4/yO1YV9nkv3SnO1/VT9VRYzAgwOzQMBEcrrp6m6AL6qir3cO2kAnJJlhU4SWeEDSNsF4d+ayaAmb4Juq5HjJRndHWNBJ6ZjAGYPPLJ513PmRI0vGk4lZggpU21Kdrmh2JmLwAXOkNebleBGYIvC+i8E3ZtXM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769673922; c=relaxed/simple;
	bh=GyUQq938SVW4E54LdP4DK2a6xRx9vdvSoY1ZYcsMyxA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=T8K91m9OQ266HsN7U4GQtNpPRN4bt0UIR8x/1ZBI8+RBP3HjgbngBJYbj9+MZZBiwu2ZQJDph6bUaYKOen4K3f/B/2cVOdQvXMaXHEeAvPCtspa9cYdllj90sJicqPSt9R3L3q7tQogtfqk2dL81/yvfaqdQ3cX+02/zLXeqVqo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X+PvCTA/; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769673916; x=1801209916;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=GyUQq938SVW4E54LdP4DK2a6xRx9vdvSoY1ZYcsMyxA=;
  b=X+PvCTA/Pvm+zopxCWOIa7iR/czHuoDZkioVRDn39nqFSRe8xOD3B4ZO
   fwsRKe+wtNvyjJk00KrM4T59nuRLQO/rsoD2MZUPmiy4e4GMDPEwONpZ7
   WhpjGRmcnHolJPgt29hIH4NCTVxyof3rrQuUQmwAXF9GR893mdyTfsSX5
   c1YHmM28LxCL0EM32mSLZA7tETpNk+KiayvpNsAWU6FjwUu0S7fiNJp6O
   unN9oLlSJ4y/v1IOeY8lgf9F9nDixPud03zDJBoVNPdGvjUJlIXzG6V5Q
   DOFb529vq4llMyMVA54+etSjAw9RpFDoyV62FF6cwe68cNFUuTMGgZYiv
   g==;
X-CSE-ConnectionGUID: u6CSqBoIQASp+iN1CUUE8g==
X-CSE-MsgGUID: 8U1UD7HiT5S+bQCxDwLhdw==
X-IronPort-AV: E=McAfee;i="6800,10657,11685"; a="81634235"
X-IronPort-AV: E=Sophos;i="6.21,260,1763452800"; 
   d="scan'208";a="81634235"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 00:05:15 -0800
X-CSE-ConnectionGUID: n91luudtTCCDYRXtV6eTfg==
X-CSE-MsgGUID: zVVNwNVCQgaS6sjww+SqBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,260,1763452800"; 
   d="scan'208";a="208293777"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 00:05:13 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 29 Jan 2026 00:05:12 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 29 Jan 2026 00:05:12 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.14) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 29 Jan 2026 00:05:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r59O1pgtqmkIS2woncFSKMz7RhJ/KpJaEjIfkwTcarQ8ZJpmEtGeYlKdPEqq2KUXNFGmSqzBb/L/UBU06qo6d4/4T2JEdsD58x+fwCoA4p3t/1i/pJrQ0SwuViyNyl9mFEuCa97cmrsllbXAC8RwRKkkQIeXa4n9f6sQdZKY4WaWgsPXGl79L3wMC/o6esshMVo300p2+UL6rzcjgCD060tCryqmb9C4++1w3vz3rJwKeNwJicFiSMKBvBs6wgEJc58Ll3YakmkDdnmjitVwh8vAmAaY93c0uibe7jQJD3+CPafWxjU2iAZIahBimc0lS4V9H03qtRWzRLo905moIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IF2VlEBp/nxjVWDOYuKXyJlHRG+qi3gvQTRpIkeKa1A=;
 b=VLRnV2sFA9y0w9KWAyWaeKxdzifNVJ9PAmXebtBy9CeG+1c4ylHx/lb4i6pP/SwzMrQec77YI8UljjA3gTBNJse+xLkWhnuFIlykQpviu+Q5+oFlKLUGq4G4iHlI2gjPNpuQNtz/wSP8Q/0ZvpHw5wDMiE1qXfHrLO0lg0isork/Xpguy4Xxt3pQLxunrnvUokpP4JsjTNmZCL+xw/pYcXmnt3HdtxOTBoAqnhGqjGIu9sNFqDKrm+PHcE24yDvJ9OtyYrWst4pXZDz2zNob3gz5YD6us9/hTN6PGRfoWyzCf/ONNezecmiYSdY4apuTQ/GbEubUtSr0lSPCOoXdYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DM4PR11MB8226.namprd11.prod.outlook.com (2603:10b6:8:182::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Thu, 29 Jan
 2026 08:05:08 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9564.006; Thu, 29 Jan 2026
 08:05:05 +0000
Date: Thu, 29 Jan 2026 16:04:51 +0800
From: Chao Gao <chao.gao@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <reinette.chatre@intel.com>,
	<ira.weiny@intel.com>, <kai.huang@intel.com>, <dan.j.williams@intel.com>,
	<yilun.xu@linux.intel.com>, <sagis@google.com>, <vannapurve@google.com>,
	<paulmck@kernel.org>, <nik.borisov@suse.com>, <zhenzhong.duan@intel.com>,
	<seanjc@google.com>, <rick.p.edgecombe@intel.com>, <kas@kernel.org>,
	<dave.hansen@linux.intel.com>, <vishal.l.verma@intel.com>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 03/26] x86/virt/tdx: Move low level SEAMCALL helpers
 out of <asm/tdx.h>
Message-ID: <aXsUo5Hi52LkwJcS@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-4-chao.gao@intel.com>
 <3e134fb9-95c0-442b-8a25-834ffd8d87f9@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3e134fb9-95c0-442b-8a25-834ffd8d87f9@intel.com>
X-ClientProxiedBy: SI2PR01CA0015.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::15) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DM4PR11MB8226:EE_
X-MS-Office365-Filtering-Correlation-Id: a277bdd7-b517-4d36-9129-08de5f0d1c7e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?kVkspvUU6fNwvlQvG5IMLGnWSVdS3AawoTIa6/AnmTAMqD5FhgASbSHqJaFS?=
 =?us-ascii?Q?Aeeys1MlqEw54letF/tre5tB0mxYuPn+9mUsdo03+38km0J+u+Q6OHNPdRcR?=
 =?us-ascii?Q?HyxMjUmJWf/7Q03coBhnLaGdyIxFxKmJXWFrUFddUSJAr959C+BHL+feSnI5?=
 =?us-ascii?Q?aeQSUvXh0HYQY9DxOrkAHSLHtq4zuVUWF6cxsTyF2457ophLQu1C52lFT3pt?=
 =?us-ascii?Q?K2SXXYXbMYNOjYlkv58vrKLrJ0wqAc44XjwTbS+EnvQqWn3HEwPVD0JiRAiI?=
 =?us-ascii?Q?BY8uXomeqs0Z4lSTwSWdadfLPNchnuPrLv6qMNSXfLJcQS2Awie2AXIT5iIP?=
 =?us-ascii?Q?We0qvedLcCeZs05CSGIJgI2lk2B+DrM9gq+STj8p41ipxFCcZ0e0UdMKTQph?=
 =?us-ascii?Q?/uDlnTiA4Ai+F6Xe6ljSjUBRsSQxK5/ksXM1+iMfhibig92lTRPNrv/bSUKJ?=
 =?us-ascii?Q?nhuiMvgpSgRPJO1rBPaghHpzJkGS+3xccQcUGkHnC9hoXwfkgCEswK/7bCYa?=
 =?us-ascii?Q?TtHBEygJWeU01tz9/9tG88hQkRDsSaN4Sle0atCAKRKZPbEQhQrK12qdQLGn?=
 =?us-ascii?Q?3X4MDs6p/KF3QdJ0l1QkWe/UELOZpBDFzGdNLbJ2Mw+iMp+pPnMTjFn2ZG0m?=
 =?us-ascii?Q?F/vVKjSCaXuNRN4W4vKFWHxW/s36Cd84gsbzdaMdvBNvF+guaIB/lwRuRi8/?=
 =?us-ascii?Q?nmNmxop9pr7iTTOEh3IKOaZDP7TGUwOOSum2UqEVwABWA6mtwkGnM/mY0fwp?=
 =?us-ascii?Q?gOi9TbL3lHj6Yil8/EAjsL3sRpoNgSR4waLs8ZBVth0sNRsAjNwc1qWYBSXn?=
 =?us-ascii?Q?0nSqqXtc6z0OryXAPGR/C8VATT52gSHHKYeVNcgAg1Cd3e1hYs89TZGStwFB?=
 =?us-ascii?Q?DHgrNWJGP0LOcNAno6BNGyOW1+qZVu2DhsPvs9YO3Ft2DUZLwRTCtJkitTS8?=
 =?us-ascii?Q?1L54ROUz/Ar8BayndZQzygLPKs+AV68Qn+8ySdNs6w67pC4Ju4o/JBtsgttt?=
 =?us-ascii?Q?p1SqaHEAa/oNUih5jE2fObnjFXB1F2oyb2ciqYrNRjA58wIgjuJI5+kY5uTF?=
 =?us-ascii?Q?wiNYaN7FsjJUpes2o3X6y/cHMMT5XEjnx+4rKE6Oz4d9AWV8MqRZM26Yyg8F?=
 =?us-ascii?Q?tIHPtLdnU1+PtbX1mmWQiAz3TdLFgZWFnzlXpapY/JZ2442gvFgYB1sKKPd3?=
 =?us-ascii?Q?8VaJitXep6fLMHMRQrhetyCxEg2PjptNkHul7FfR1DqHRwnUAjXUBiwZzi1V?=
 =?us-ascii?Q?XXB3IP7awjFNS5SfWByRppU1la7PQJfjyVqlIPMFPHEjo8v1BVsthptudyto?=
 =?us-ascii?Q?YW/jMHiCttkfwJWlqIKlBcYCU2bxi76+XNi8wR7pQm9r5dveu5tF+W512inZ?=
 =?us-ascii?Q?5i/8/IDHIn4HNq1hwAJoRu8luIty7QKt7lDpvKGTfN7ESddYp/v8QSyqpwec?=
 =?us-ascii?Q?JFyXkc1vjAJUifWYi6PEwdFGY9wH8U/IpLUaWZTmi3uHlZA/IboVNp1TVRs6?=
 =?us-ascii?Q?mPE22LKzsKBARc17++bHjm6b8EUW7doVqqMbPFmSiffS0iL75rdGuxBSCXDs?=
 =?us-ascii?Q?n2GHs4NdOCX18DlhW8M=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BV30gN3urv0bq9woYbas17EsXQ2VRPEJ7sIv+qmbt5aNSsgdGb/wjllq291p?=
 =?us-ascii?Q?YEITle+OgmSXMNH2IqbvT/i7zunn44N/0stvZlZcNmkARPRjbf3b41ileze1?=
 =?us-ascii?Q?+GJCSKtYTmiaY5J0EhN0TNTMZPb1cPb/obmICt0QLtvMLPBMRD330D+nuGNC?=
 =?us-ascii?Q?84sq45gYV1TNfolpDk5kQohp7QjuA+/ETgDp5r/c4Ji9rSmqA0lG00u9YD18?=
 =?us-ascii?Q?hn4SfGaib5vk1X3AA48cKlcWMQnpqPkDPm+V8nYOjgpTON7Y5Gj/v55D2N9p?=
 =?us-ascii?Q?j68Pj/knU28J+4UR40kxAuakKsnOUQJGf8UoAbbRl6QrQA7MNPcWHbu+DbJJ?=
 =?us-ascii?Q?EcS195W1wHozZvLymQAT7q+ilBuBrCPMq8e5Qi8SpkQHJgLze2riaf3qWlM9?=
 =?us-ascii?Q?YWaGcSyFzKzdJ6/cxeQOcnwntibqN7OXPczuPgtuLQ7S4CltxfEqA2rLpAPI?=
 =?us-ascii?Q?IndMs8i1sNjDGRwUo/ToRK9ITiofLGMhAcG1o4ciRvn+rAU3k9cLhKs609r2?=
 =?us-ascii?Q?zEHMJiL0P4Pp4KuLd6imx/tKZ6kCwtJ46H4aELzgrXhLMyUfF/iyQ7xoaRaS?=
 =?us-ascii?Q?bsRn0JXYeWNhm9SleG1na+oJJQogBhu4c0XFyLQ1IUrUMN2Jws3/r/7ld85Y?=
 =?us-ascii?Q?wsNh3SfEgpZH6UJQSKSnhhNB4yQ7MhOjPUeLOhtikH4oHcI7n/B1chQa2kSN?=
 =?us-ascii?Q?MyZ9Y1UkSe3xSERJ1R/gVtfSGqLw5jmoAdk77gvIiKIknJhAI2sCKqZxXJl5?=
 =?us-ascii?Q?AVVZwYHVaD43MiUKby6nI7ZMTuomrGBZ/9fjfQFTKpJPyD0wMLR8OTQGwyf9?=
 =?us-ascii?Q?4R7IfsmSjNMv4u8xQk0qL9L3bfzfYirsQQreMSEHBzN1ohAUULKA/11FEbM8?=
 =?us-ascii?Q?MPC0vJLCACy+Up4rU1wRIyr0sGRlYzgTmI4Rvmf8KIRQBt0sVbm5eoyUMJYF?=
 =?us-ascii?Q?T2NTagDEkEWcVNy0NQicgUEyNESq3J81aHTRAcfoJgzeCnnGmqdG0Of4TpE9?=
 =?us-ascii?Q?DWFARNAvOzKxq4Ua+UVu72yrkiZjUtpUf30ZVEVqEzHy5IW8Tpo4gW1XIMkk?=
 =?us-ascii?Q?70fr2+w7j1UECzoSqrjsHfCPgeZzQZB0AbBP/YsGcw1VSraKvCKvJ/QKwT7n?=
 =?us-ascii?Q?099WlRRlt92WyLKGmg4dYFUaEd7zR68eKr0rt/n7mn6U1psTFUKqw2YRq93e?=
 =?us-ascii?Q?wy1vxYHmsB0Xtnl/IwFdAPKEzqbdAkVr9STh4o0IMgCWTDLxDo2aFdxEOwD/?=
 =?us-ascii?Q?xERQgcuWy0vdLFz/PnVVkwmQg8euafec0DBtvXukBVuHmT5cdTzO9mhoerfO?=
 =?us-ascii?Q?eGTNNAokrDByZbbP1E9Bg4lAYtGI/90EgGgl2o/jiB5OwOMITzAa6D65Gf7j?=
 =?us-ascii?Q?3JLpH9MTywNgGX24a9joRLwfoc0wIFc/iU5xGY7seO8ocaEzdg4Zw/ty/+v5?=
 =?us-ascii?Q?aCoTHD8Foj8FmQ6CxhWhWduxCt+2lsd5Hf8sx/oV1HlHdTLLsOw3ASlxfKky?=
 =?us-ascii?Q?FwPZZYKsjx/l6W0ONovJBz352wjIzE0sLAp5d/SpP6Mox51EUmZoDx+dy6L8?=
 =?us-ascii?Q?SleJood3FjhN24aXOfoJYXryEv6LLFYvkBpyujqgh6XYclcrg1lzxq72wU9l?=
 =?us-ascii?Q?SbBtNSzqnJkxfCxRITC02YRgUiiYN8xw1TWZ+cimGQ4mBIk719CcoAGJAvfC?=
 =?us-ascii?Q?Ehl8CqUq1Guw6NdoyXEzZCRLhQWMbBsbxO1FNXk92gl4JJ/JlkEG/d8PcPNi?=
 =?us-ascii?Q?VPiQWsvr+Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a277bdd7-b517-4d36-9129-08de5f0d1c7e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 08:05:05.8379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fDo1o3XlQSrVDL4K1hzOBlEZWCxzjzVjxpqNrovoi9tQpodlnAamaMRY6LEXBT2R3q8OK+84CM1Qpg8pR+zXcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8226
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
	TAGGED_FROM(0.00)[bounces-69520-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 9299AAD193
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 08:37:35AM -0800, Dave Hansen wrote:
>On 1/23/26 06:55, Chao Gao wrote:
>> +++ b/arch/x86/virt/vmx/tdx/seamcall.h
>
>Moving the code to a local header is a good thing. The more private
>these things are, the better.
>
>I _do_ like when I see these things have a label in the filename like:
>
>	internal.h
>
>or even:
>
>	seamcall_internal.h
>
>That really catches your eye. It would also be ideal to have a small
>blurb at the top of the file to say what its scope is, just to explain
>what folks should be adding to it or not.
>
>If you get a chance to add those, all the better. But either way:
>
>Acked-by: Dave Hansen <dave.hansen@linux.intel.com>

Thanks.

I will rename it to "seamcall_internal.h" and add the following at the top:

/*
 * SEAMCALL utilities for TDX host-side operations.
 * 
 * Provides convenient wrappers around SEAMCALL assembly with retry logic,
 * error reporting and cache coherency tracking.
 */

