Return-Path: <kvm+bounces-70987-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cIdcMxDpjWms8gAAu9opvQ
	(envelope-from <kvm+bounces-70987-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:52:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EA4A12E955
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:52:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A3C4530E403D
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 14:46:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4456835CB84;
	Thu, 12 Feb 2026 14:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SN/MtWht"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F29935502A;
	Thu, 12 Feb 2026 14:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770907595; cv=fail; b=NMBFKhZ2GJ0AO1GXH1gHyToNccD8kP4KhTT9a2MIV1Ai/dfpG2b8QoPGWNmBFXIx0T4DjVuhUGjvOKc5RKsIoIY96nJHHPmqGJUzwbXKSffNg4aTERQh5Dx7ykmQDxma8ARyXIHdHAs6VtTid0aCXgzuQr9ALvXlwpl5LV0HNnA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770907595; c=relaxed/simple;
	bh=SXyzL5h2+siYiNZ4IYxt0ywbyCh3aE7dBQczcXcHH1A=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=f7rTNdhVVuRnGqs/Y6L7t7FdgqK0xvZHo7zqKClucyiX7ONezR0WKBL+D2Lat6WqisYD8xI5R9i7ijn2LAt78mrgRn/6Nuvr8VCfPuuBdmSRbi+IxaTSJJtXwnnwzhzGbmx1Ocl8H0SbzQAvFLSYpkUhVOJmrfjJ+An5wyRBz50=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SN/MtWht; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770907594; x=1802443594;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=SXyzL5h2+siYiNZ4IYxt0ywbyCh3aE7dBQczcXcHH1A=;
  b=SN/MtWhtFEF9BPGPCMYIkGGkxHDCCrykB73EsByypSBigR0LhpHKmKCM
   A5n1hm3xteadH0Sh/BW55Aq3ewlXHJea6tm6lrYUrm/2ziQbZF+DUU45g
   IEl8ARhMcg8W9d7PoaR/jaBRS/oJdGyhiOb1+zxpg91y3khw3hAH56y9R
   hFugMun/udgchz0Sk+EPvBaH53TBwLEqARRs+kdDyDhS6k/cMBUfk9eyK
   Pb5ckkAx93lCE4/4auqGnVxB0lPGBAKz2j5xahwDPoeWKwtQhpSZgDf83
   kvSDjzUfKkvhZRfmUnS6aaol8gE8LmvG44JQtuFWbwSsomhEde61vUx9l
   g==;
X-CSE-ConnectionGUID: HzQgkO8hQKism6LhJqCVnQ==
X-CSE-MsgGUID: xoB2K0tYT5qB5DYW4SL3TA==
X-IronPort-AV: E=McAfee;i="6800,10657,11699"; a="71974394"
X-IronPort-AV: E=Sophos;i="6.21,286,1763452800"; 
   d="scan'208";a="71974394"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 06:46:33 -0800
X-CSE-ConnectionGUID: jHKcT1xySG602U3r0s3Kwg==
X-CSE-MsgGUID: Hzd2TbCoRrKkZT9H8Go1Mw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,286,1763452800"; 
   d="scan'208";a="212119899"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 06:46:32 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 12 Feb 2026 06:46:31 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 12 Feb 2026 06:46:31 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.17)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 12 Feb 2026 06:46:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tPXr/Da/JtK8iKuGZxxEQYmf6gdtvOPrXikTM9BWIHgZ+9qKHMxGZaj7Gj+zDsDrExUeMS0anhwmzgDlSCAKaJ+OeHYrNgK+3JcvYvaGurDfDD+XyLPQ0+ijLxhKFVZpSzOXhnrUEfUwUnE34IVFbxrnPTYwz+pfSq8L1Z0AsIhI7b3Mn349lkgqaXt5M+YrBo1cV5D9xq9mRTS2VCVGrwN9MV9Twv7Cp/KCH3LZPBSkvc+rBObzqdrfXkM4GmOpZQ7cMgVmmyHKYJxTitNcPavqx6/3tv+FcpIQPOErSqYfPk++xxhUU11SHlv/iUlPjvdMJR0bMYtDjI203FIaWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AU3Vu8id3QR7bjhiZWKv4R7eN1gHLg7DCSMuqyGNMGk=;
 b=JkwHrePXzXZVT8a13/FNtSVmyaquGLjJzUUBPby+PtaLeZZ8l2LY8tffcNFiV75qMDUvg99+VU1iI4i088gClbaiH+rYPGqmkK5gdkuOcnSkq55WdBGRQllivUbC6M85jskxXmHhQIOtOo1Tc8KvR1w1/GGItS20Bc61SFi1W45mGJYdRMDP90mdHxkWVFCDyib/bshrAlPOkN5pxTEXUr7JsZBhNF27Xrv3QWmD75ABVILb+RTxMbtNxONGUOQNehp1DDZoXBSeeHdWl2T7sVx7KyPXNizy9NK7bMKJQNy1bcIeS+3EJs2EZmd/6UQz5wFq5rerHQkBWao6UcWErA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by MN6PR11MB8172.namprd11.prod.outlook.com (2603:10b6:208:478::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.13; Thu, 12 Feb
 2026 14:46:28 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9611.012; Thu, 12 Feb 2026
 14:46:28 +0000
Date: Thu, 12 Feb 2026 22:46:13 +0800
From: Chao Gao <chao.gao@intel.com>
To: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <linux-doc@vger.kernel.org>
CC: <reinette.chatre@intel.com>, <ira.weiny@intel.com>, <kai.huang@intel.com>,
	<dan.j.williams@intel.com>, <yilun.xu@linux.intel.com>, <sagis@google.com>,
	<vannapurve@google.com>, <paulmck@kernel.org>, <nik.borisov@suse.com>,
	<zhenzhong.duan@intel.com>, <seanjc@google.com>,
	<rick.p.edgecombe@intel.com>, <kas@kernel.org>,
	<dave.hansen@linux.intel.com>, <vishal.l.verma@intel.com>,
	<binbin.wu@linux.intel.com>, <tony.lindgren@linux.intel.com>, Borislav Petkov
	<bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar
	<mingo@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Paolo Bonzini
	<pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>
Subject: Re: [PATCH v4 00/24] Runtime TDX Module update support
Message-ID: <aY3ntae1jaKyd7zb@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260212143606.534586-1-chao.gao@intel.com>
X-ClientProxiedBy: SG2PR01CA0170.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::26) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|MN6PR11MB8172:EE_
X-MS-Office365-Filtering-Correlation-Id: 29597747-564f-4ead-f688-08de6a45810e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?0l/A52Bq02RP0Z0fuVbsNIFTcBuOZ7WglUwYAyDXJAR92OwJTqCP5w3+AKyB?=
 =?us-ascii?Q?/uOuBAANscyHxwz0AEZiLtx5EcHsHhRHMqV1Daq2POSgRydLjJr6vk3K1Ujb?=
 =?us-ascii?Q?hoIaXBnLuclfHfmQwpRC1bgoY1UQjYTYAbNdSEtvHL4t7Lc39U/l0kfIncUz?=
 =?us-ascii?Q?8xN4xtnt9+s9ox4mrG4YoM38Pg7nL+DHAjjWNJqoqolukxT8uSGrovciws68?=
 =?us-ascii?Q?gqxkCdvrvzwi+qW3nIj8NQ7Ka1HxkzY552MwJ4Bw4AxzZAMhRhTA98DnZtNj?=
 =?us-ascii?Q?hr6HsnlqT7aFrm8goXnXaGgDl7UBqRpUkohjTPRZiS6Gx+JD2V5tjgvho82C?=
 =?us-ascii?Q?Ks5b7NEA7lgpj0CJwvdj+3lWEMLJinszQfPEN+lTtV+qoHx7AuIVl0QIgAt4?=
 =?us-ascii?Q?ohIWpgsrs+O4ASMa65tI2uYYisJwTzhsJzo53HNgqpKmayB45OP2Wsxawqtf?=
 =?us-ascii?Q?zi/bVPZvDZTqt0hoUioTV+4FEH1ZxflK4GeEQx0XoO5gjl16ZAKLkr/cDSCY?=
 =?us-ascii?Q?YHCi4YgqsDBHKgz5RcVnzQ0rFS9sYTwNxNRjcr4B4nDLJOKxEA/WIgrs7Dws?=
 =?us-ascii?Q?G56Gqraps+e0eQjGGG2/FeLJMzyO2nL8PoIq7AH84RLoElG+MnLHy/ciEK5z?=
 =?us-ascii?Q?bdKtqPDWOrzzmAs60Mxp3smR3EPWGoyumDpx570KYN9wHYqRyRifPaLVwUaz?=
 =?us-ascii?Q?lO2yBEfydAo2ZqEYo9+XfLZj/8CQSYJj7tEytSpo52VY4WyT5NLw9bCbVWAd?=
 =?us-ascii?Q?uNQ5yR1fBCa3gd0hTNY1aJP7mj3Np593oFmxpNK0/j8w/BRGPt0pBzV6QpVA?=
 =?us-ascii?Q?75ARL1x6pOw3JfhJnaATGAmp3jMlXtYJc32K/YzyVZOfmgco8CpFQ2/60cF9?=
 =?us-ascii?Q?UahFWFKk/XQrEPM26nWV1UbVKKggEgbu/o+wmDLdLyvrmLsdLwnyof04rCsU?=
 =?us-ascii?Q?DLziNYhCODrmR/C+TxSVEpU3huiiyyXTGtR09UTVy1imOkJgkSuGX2yxngvG?=
 =?us-ascii?Q?fZLZBcKkL8Cav5v75xoxPuzF6L8oD5eEMAu9bzVbH3ti8ta/KGaV9BGKVazm?=
 =?us-ascii?Q?OsTUUWPX7M6Oz/6MBI5FZAmzjG9gEkD4pGNga3lYhOk5/D5DPtBYSBjY/d0Y?=
 =?us-ascii?Q?ePpzWGk3d4vzDnQaljnZp12upu1M5fce3DMWj0CMLjDwB/UA8HLR0rFr8KtN?=
 =?us-ascii?Q?eGMWzoTbvkcMGdmGr6G/QaBGtY88LzMkDGuvgIjZX5S7MC3ec5DUmEjuyfd2?=
 =?us-ascii?Q?hywrXzMLNANHAq864co0FN1hHNP5MVWLrVg7Rb+kMnoOyq5IQQm2glXkukZ2?=
 =?us-ascii?Q?woo1JmG0pde6EcIFvDOcPwVio7qX25nhlMsu+2BpN4tfSrGGkC4hpBS2f0dA?=
 =?us-ascii?Q?GrWefPCi0L9SfgiLBlX6e4VwuxGtaPi7q7e5OtD+nQm8ZVmulCEKQjCvlLRS?=
 =?us-ascii?Q?rH4pfdwUpAvCAiDyW8+XiPkry86RJ5eheztgsQu8ZGOY+VJ5BovOiwqIo7nU?=
 =?us-ascii?Q?m5LHF5Hfa4A6h2TX64ZDp9ZmuipKtIT1PJLOe8UjF5mLq1RB6Odtd5Q8M8b2?=
 =?us-ascii?Q?QONQ8uNZ+ED5OUw0wz0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f10Fhj6XenZehkPaB+S/oXZ88M54/iamgc0Ywk7emSfF7gMIKhh1lfweOoBc?=
 =?us-ascii?Q?0xzsHi9amwDziqWfgYEUh07+F0RVhllbWxFUuk8qYPC86Du51syMFj7QWw2z?=
 =?us-ascii?Q?w7cdokxxw0z93SQaAL6Qdu63nvOdYFG/mrKFCPcUMOeEb9ug7gb/9v37BY+3?=
 =?us-ascii?Q?gsIBbC2m+qSJvb4CO3h4lwhJSMfzRWCO/oFGHEsC8i7ZJ7IygelLymTMpQ11?=
 =?us-ascii?Q?uOEpSv5ZUIALz4D/hUP/ZLGzFeslcmYC+7QGPw2s3r9/J5rLHzlsKwnga7NO?=
 =?us-ascii?Q?zLVctqQPUo7u/9Wa3fvt3WGLLroyMXFp/KungzL6R0WImUL+o8kjpIiILjQv?=
 =?us-ascii?Q?qjWDvHPHjM6p4NroUwXHHYXsqK7HKOFuWwvODl0KbA+UYEoffV3E6gpaMDuy?=
 =?us-ascii?Q?AloLju+3nqWyl5Mw4ZVMDFJJiJHIoTayatKzMPfrM5+0zZd6iZdAswtLiSXi?=
 =?us-ascii?Q?H+7XBEAxdbrFG/XJVp022K3oCwHCVymlqT0vMHO6pb6Nb0MM8iNzoKETuWp9?=
 =?us-ascii?Q?bn4XtwE6aHg8o4IQKx3xb86CZ7EAHliVSOMIDnofDthj+Cz18g9+qB7nlI62?=
 =?us-ascii?Q?O+4KeDg36yjnwCIixDe4iqeoESdTccQZR6qzYyspHcL43Zag1b9oCuEMzOpH?=
 =?us-ascii?Q?Nd9QCSWif30y+xLWnhB7onJA3+As7X2LLm+9vLjO8JCpLNHx6RICXAjcl2Ji?=
 =?us-ascii?Q?UNzFUXujlQStO1ENsrjeB1Pn4atVBgbfQJrpXdDaPfbr82situ1e17O90XUM?=
 =?us-ascii?Q?5JWMjRcFYSJ0A4ikrTfJKKA3yQJv9EXfSfIxrr7innYmYcdc2N787+uVpK9J?=
 =?us-ascii?Q?tGrrozRan8b9H5qcM5PFXF23kkvLaXJ3pcJV345iu0caf1zloQJvMAMvAn7k?=
 =?us-ascii?Q?7TiV2wDUEnMMD6k9FHJH4r92Riir0ogUASDMxBeSF6map/3IvvfpijF1OOo0?=
 =?us-ascii?Q?VKDjerUTCtHG5ncAg8sh8TPYU/3IokL0hEKUrkzKwgcqmi7cX1yHeW2L5/Ki?=
 =?us-ascii?Q?kIuqLvZC7Fagha/bjDDcbbyJjZMypGOzahZbr5LTLB62vdD5ih1FLAy17uro?=
 =?us-ascii?Q?AzX1plErYVly+DuLmrD+JSMoIRCHbiW8qPmf0ZNdWmaL2nsxcvzxG+W8Gefb?=
 =?us-ascii?Q?DRRnl7KTVbyRCWZb8lP0nDwxovTJtUG7ZBjKNAnPDJZo+sm9MDR/yG6SM3GX?=
 =?us-ascii?Q?l3Lj+D/scCRcdnhLGsL2ckuloVVDWOjmsUp3BJso6K6mrlJnGpVLTEbWLrqM?=
 =?us-ascii?Q?tSL2HKRmKbhFKy7ULw/lEwhu2wKlSNIbeKI5Kmc4stYeTuM6kBrSuXVqjQWD?=
 =?us-ascii?Q?TxZFb8JwTIEO+goE+90tk6jCoKhGHIonl4FDpEBnuEEmMV7Bqh1nkjZm3rhv?=
 =?us-ascii?Q?oGzOgs/lUol5Bj/sIIxM/r2tMysoQkWXv80/LUKRZBCHur0anibPUdhgKqOz?=
 =?us-ascii?Q?ITLwTtFgy2fy/uSZvcfPjsHa2WeRHhUpWEaovraioSYpDRbshIOIsXHG2NNF?=
 =?us-ascii?Q?Jg53uw2hil4XZYzrq7zalkfqNYoAzobt3CpJiYiFx8nSpg60TJPix5h0AQE9?=
 =?us-ascii?Q?WJ0UCZoOHv/vwgZ4apGIg0Q7l5ji+rBp1aSXRZvQOi/0pehejLG8y07dZS2o?=
 =?us-ascii?Q?Xdn49TNPTf41+R7adp9/VHStkprnkhvKdf7jddNW2a5E4GFA+3DMwMd79k4o?=
 =?us-ascii?Q?nNPetOZQvOUf00D9zpxCnqT6DXSsYrVDPwEhI6gQQMa4ePFVeyhyQXa1RyH1?=
 =?us-ascii?Q?7M5ilxJKsg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 29597747-564f-4ead-f688-08de6a45810e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2026 14:46:28.5086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: byJ4bXPoH+BQAcTS/yaQM9zalwSpET7ZO6nSEXDO53WVShH4bMOTMvqm+GWUiG0bxBL/Wkd4a/15xwTvNv1f6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8172
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_SEVEN(0.00)[10];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[28];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70987-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: 4EA4A12E955
X-Rspamd-Action: no action

On Thu, Feb 12, 2026 at 06:35:03AM -0800, Chao Gao wrote:
>
>Note that like v3, this v4 is not based on Sean's VMXON series to make this
>series more reviewable.

There are some conflicts between Sean's VMXON v2 and this TDX module update series:

1. tdx_cpu_enable() is unexported in the VMXON series but used in this series.
2. tdx_module_status is removed in the VMXON series but accessed in this series.
3. Several functions are tagged as __init but called in this series at runtime

Below is a sample diff showing how to resolve the conflicts. This series is not
ready for merge yet. The diff is posted just to give you a sense of how these
two series intersect:

diff --cc arch/x86/include/asm/tdx.h
index a149740b24e8,50a58160deef..000000000000
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@@ -97,57 -104,22 +104,21 @@@ static inline long tdx_kvm_hypercall(un
  #endif /* CONFIG_INTEL_TDX_GUEST && CONFIG_KVM_GUEST */
  
  #ifdef CONFIG_INTEL_TDX_HOST
- u64 __seamcall(u64 fn, struct tdx_module_args *args);
- u64 __seamcall_ret(u64 fn, struct tdx_module_args *args);
- u64 __seamcall_saved_ret(u64 fn, struct tdx_module_args *args);
  void tdx_init(void);
+ int tdx_cpu_enable(void);
 -int tdx_enable(void);
+ const char *tdx_dump_mce_info(struct mce *m);
+ const struct tdx_sys_info *tdx_get_sysinfo(void);
  
- #include <linux/preempt.h>
- #include <asm/archrandom.h>
- #include <asm/processor.h>
- 
- typedef u64 (*sc_func_t)(u64 fn, struct tdx_module_args *args);
- 
- static __always_inline u64 __seamcall_dirty_cache(sc_func_t func, u64 fn,
-						  struct tdx_module_args *args)
+ static inline bool tdx_supports_runtime_update(const struct tdx_sys_info *sysinfo)
  {
-	lockdep_assert_preemption_disabled();
- 
-	/*
-	 * SEAMCALLs are made to the TDX module and can generate dirty
-	 * cachelines of TDX private memory.  Mark cache state incoherent
-	 * so that the cache can be flushed during kexec.
-	 *
-	 * This needs to be done before actually making the SEAMCALL,
-	 * because kexec-ing CPU could send NMI to stop remote CPUs,
-	 * in which case even disabling IRQ won't help here.
-	 */
-	this_cpu_write(cache_state_incoherent, true);
- 
-	return func(fn, args);
+	return sysinfo->features.tdx_features0 & TDX_FEATURES0_TD_PRESERVING;
  }
  
- static __always_inline u64 sc_retry(sc_func_t func, u64 fn,
-			   struct tdx_module_args *args)
+ static inline bool tdx_supports_update_compatibility(const struct tdx_sys_info *sysinfo)
  {
-	int retry = RDRAND_RETRY_LOOPS;
-	u64 ret;
- 
-	do {
-		preempt_disable();
-		ret = __seamcall_dirty_cache(func, fn, args);
-		preempt_enable();
-	} while (ret == TDX_RND_NO_ENTROPY && --retry);
- 
-	return ret;
+	return sysinfo->features.tdx_features0 & TDX_FEATURES0_UPDATE_COMPAT;
  }
  
- #define seamcall(_fn, _args)		sc_retry(__seamcall, (_fn), (_args))
- #define seamcall_ret(_fn, _args)	sc_retry(__seamcall_ret, (_fn), (_args))
- #define seamcall_saved_ret(_fn, _args)	sc_retry(__seamcall_saved_ret, (_fn), (_args))
- const char *tdx_dump_mce_info(struct mce *m);
- const struct tdx_sys_info *tdx_get_sysinfo(void);
- 
  int tdx_guest_keyid_alloc(void);
  u32 tdx_get_nr_guest_keyids(void);
  void tdx_guest_keyid_free(unsigned int keyid);
diff --cc arch/x86/virt/vmx/tdx/tdx.c
index 55d3463e0e93,2cf3a01d0b9c..000000000000
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@@ -40,7 -39,8 +40,9 @@@
  #include <asm/cpu_device_id.h>
  #include <asm/processor.h>
  #include <asm/mce.h>
 +#include <asm/virt.h>
+ 
+ #include "seamcall_internal.h"
  #include "tdx.h"
  
  static u32 tdx_global_keyid __ro_after_init;
@@@ -53,57 -53,16 +55,15 @@@ static DEFINE_PER_CPU(bool, tdx_lp_init
  
  static struct tdmr_info_list tdx_tdmr_list;
  
 -static enum tdx_module_status_t tdx_module_status;
 -static DEFINE_MUTEX(tdx_module_lock);
+ static bool sysinit_done;
+ static int sysinit_ret;
+ 
  /* All TDX-usable memory regions.  Protected by mem_hotplug_lock. */
  static LIST_HEAD(tdx_memlist);
  
 -static struct tdx_sys_info tdx_sysinfo;
 +static struct tdx_sys_info tdx_sysinfo __ro_after_init;
 +static bool tdx_module_initialized __ro_after_init;
  
- typedef void (*sc_err_func_t)(u64 fn, u64 err, struct tdx_module_args *args);
- 
- static inline void seamcall_err(u64 fn, u64 err, struct tdx_module_args *args)
- {
-	pr_err("SEAMCALL (0x%016llx) failed: 0x%016llx\n", fn, err);
- }
- 
- static inline void seamcall_err_ret(u64 fn, u64 err,
-				    struct tdx_module_args *args)
- {
-	seamcall_err(fn, err, args);
-	pr_err("RCX 0x%016llx RDX 0x%016llx R08 0x%016llx\n",
-			args->rcx, args->rdx, args->r8);
-	pr_err("R09 0x%016llx R10 0x%016llx R11 0x%016llx\n",
-			args->r9, args->r10, args->r11);
- }
- 
- static __always_inline int sc_retry_prerr(sc_func_t func,
-					  sc_err_func_t err_func,
-					  u64 fn, struct tdx_module_args *args)
- {
-	u64 sret = sc_retry(func, fn, args);
- 
-	if (sret == TDX_SUCCESS)
-		return 0;
- 
-	if (sret == TDX_SEAMCALL_VMFAILINVALID)
-		return -ENODEV;
- 
-	if (sret == TDX_SEAMCALL_GP)
-		return -EOPNOTSUPP;
- 
-	if (sret == TDX_SEAMCALL_UD)
-		return -EACCES;
- 
-	err_func(fn, sret, args);
-	return -EIO;
- }
- 
- #define seamcall_prerr(__fn, __args)						\
-	sc_retry_prerr(__seamcall, seamcall_err, (__fn), (__args))
- 
- #define seamcall_prerr_ret(__fn, __args)					\
-	sc_retry_prerr(__seamcall_ret, seamcall_err_ret, (__fn), (__args))
- 
  /*
   * Do the module global initialization once and return its result.
   * It can be done on any cpu.  It's always called with interrupts
@@@ -142,11 -99,17 +100,11 @@@ out
  }
  
  /**
 - * tdx_cpu_enable - Enable TDX on local cpu
 - *
 - * Do one-time TDX module per-cpu initialization SEAMCALL (and TDX module
 - * global initialization SEAMCALL if not done) on local cpu to make this
 - * cpu be ready to run any other SEAMCALLs.
 - *
 - * Always call this function via IPI function calls.
 - *
 - * Return 0 on success, otherwise errors.
 + * Enable VMXON and then do one-time TDX module per-cpu initialization SEAMCALL
 + * (and TDX module global initialization SEAMCALL if not done) on local cpu to
 + * make this cpu be ready to run any other SEAMCALLs.
   */
- static int tdx_cpu_enable(void)
+ int tdx_cpu_enable(void)
  {
	struct tdx_module_args args = {};
	int ret;
@@@ -1236,51 -1114,168 +1194,150 @@@ err_free_tdxmem
	goto out_put_tdxmem;
  }
  
 -static int __tdx_enable(void)
 +static __init int tdx_enable(void)
  {
 +	enum cpuhp_state state;
	int ret;
  
 -	ret = init_tdx_module();
 -	if (ret) {
 -		pr_err("module initialization failed (%d)\n", ret);
 -		tdx_module_status = TDX_MODULE_ERROR;
 -		return ret;
 +	if (!cpu_feature_enabled(X86_FEATURE_TDX_HOST_PLATFORM)) {
 +		pr_err("TDX not supported by the host platform\n");
 +		return -ENODEV;
	}
  
 -	pr_info("module initialized\n");
 -	tdx_module_status = TDX_MODULE_INITIALIZED;
 -
 -	return 0;
 -}
 +	if (!cpu_feature_enabled(X86_FEATURE_XSAVE)) {
 +		pr_err("XSAVE is required for TDX\n");
 +		return -EINVAL;
 +	}
  
 -/**
 - * tdx_enable - Enable TDX module to make it ready to run TDX guests
 - *
 - * This function assumes the caller has: 1) held read lock of CPU hotplug
 - * lock to prevent any new cpu from becoming online; 2) done both VMXON
 - * and tdx_cpu_enable() on all online cpus.
 - *
 - * This function requires there's at least one online cpu for each CPU
 - * package to succeed.
 - *
 - * This function can be called in parallel by multiple callers.
 - *
 - * Return 0 if TDX is enabled successfully, otherwise error.
 - */
 -int tdx_enable(void)
 -{
 -	int ret;
 +	if (!cpu_feature_enabled(X86_FEATURE_MOVDIR64B)) {
 +		pr_err("MOVDIR64B is required for TDX\n");
 +		return -EINVAL;
 +	}
  
 -	if (!boot_cpu_has(X86_FEATURE_TDX_HOST_PLATFORM))
 +	if (!cpu_feature_enabled(X86_FEATURE_SELFSNOOP)) {
 +		pr_err("Self-snoop is required for TDX\n");
		return -ENODEV;
 +	}
  
 -	lockdep_assert_cpus_held();
 -
 -	mutex_lock(&tdx_module_lock);
 +	state = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "virt/tdx:online",
 +				  tdx_online_cpu, tdx_offline_cpu);
 +	if (state < 0)
 +		return state;
  
 -	switch (tdx_module_status) {
 -	case TDX_MODULE_UNINITIALIZED:
 -		ret = __tdx_enable();
 -		break;
 -	case TDX_MODULE_INITIALIZED:
 -		/* Already initialized, great, tell the caller. */
 -		ret = 0;
 -		break;
 -	default:
 -		/* Failed to initialize in the previous attempts */
 -		ret = -EINVAL;
 -		break;
 +	ret = init_tdx_module();
 +	if (ret) {
 +		pr_err("TDX-Module initialization failed (%d)\n", ret);
 +		cpuhp_remove_state(state);
 +		return ret;
	}
  
 -	mutex_unlock(&tdx_module_lock);
 +	register_syscore(&tdx_syscore);
  
 -	return ret;
 +	tdx_module_initialized = true;
 +	pr_info("TDX-Module initialized\n");
 +	return 0;
  }
 -EXPORT_SYMBOL_FOR_KVM(tdx_enable);
 +subsys_initcall(tdx_enable);
  
+ #define TDX_SYS_SHUTDOWN_AVOID_COMPAT_SENSITIVE BIT(16)
+ 
+ int tdx_module_shutdown(void)
+ {
+	struct tdx_module_args args = {};
+	u64 ret;
+	int cpu;
+ 
+	/*
+	 * Shut down the TDX Module and prepare handoff data for the next
+	 * TDX Module. This SEAMCALL requires a handoff version. Use the
+	 * module's handoff version, as it is the highest version the
+	 * module can produce and is more likely to be supported by new
+	 * modules as new modules likely have higher handoff version.
+	 */
+	args.rcx = tdx_sysinfo.handoff.module_hv;
+ 
+	if (tdx_supports_update_compatibility(&tdx_sysinfo))
+		args.rcx |= TDX_SYS_SHUTDOWN_AVOID_COMPAT_SENSITIVE;
+ 
+	ret = seamcall(TDH_SYS_SHUTDOWN, &args);
+ 
+	/*
+	 * Return -EBUSY to signal that there is one or more ongoing flows
+	 * which may not be compatible with an updated TDX module, so that
+	 * userspace can retry on this error.
+	 */
+	if ((ret & TDX_SEAMCALL_STATUS_MASK) == TDX_UPDATE_COMPAT_SENSITIVE)
+		return -EBUSY;
+	else if (ret)
+		return -EIO;
+ 
 -	tdx_module_status = TDX_MODULE_UNINITIALIZED;
++	tdx_module_initialized = false;
+	sysinit_done = false;
+	sysinit_ret = 0;
+ 
+	for_each_online_cpu(cpu)
+		per_cpu(tdx_lp_initialized, cpu) = false;
+	return 0;
+ }
+ 
+ int tdx_module_run_update(void)
+ {
+	struct tdx_module_args args = {};
+	int ret;
+ 
+	ret = seamcall_prerr(TDH_SYS_UPDATE, &args);
+	if (ret) {
+		pr_err("TDX-Module update failed (%d)\n", ret);
 -		tdx_module_status = TDX_MODULE_ERROR;
+		return ret;
+	}
+ 
 -	tdx_module_status = TDX_MODULE_INITIALIZED;
++	tdx_module_initialized = true;
+	return 0;
+ }
+ 
+ /*
+  * Update tdx_sysinfo and check if any TDX module features changed after
+  * updates
+  */
+ int tdx_module_post_update(struct tdx_sys_info *info)
+ {
+	struct tdx_sys_info_version *old, *new;
+	int ret;
+ 
+	/* Shouldn't fail as the update has succeeded */
+	ret = get_tdx_sys_info(info);
+	if (WARN_ONCE(ret, "version retrieval failed after update, replace TDX Module\n"))
+		return ret;
+ 
+	old = &tdx_sysinfo.version;
+	new = &info->version;
+	pr_info("version %u.%u.%02u -> %u.%u.%02u\n", old->major_version,
+						      old->minor_version,
+						      old->update_version,
+						      new->major_version,
+						      new->minor_version,
+						      new->update_version);
+ 
+	/*
+	 * Blindly refreshing the entire tdx_sysinfo could disrupt running
+	 * software, as it may subtly rely on the previous state unless
+	 * proven otherwise.
+	 *
+	 * Only refresh version information (including handoff version)
+	 * that does not affect functionality, and ignore all other
+	 * changes.
+	 */
+	tdx_sysinfo.version	= info->version;
+	tdx_sysinfo.handoff	= info->handoff;
+ 
+	if (!memcmp(&tdx_sysinfo, info, sizeof(*info)))
+		return 0;
+ 
+	pr_info("TDX module features have changed after updates, but might not take effect.\n");
+	pr_info("Please consider updating your BIOS to install the TDX Module.\n");
+	return 0;
+ }
+ 
  static bool is_pamt_page(unsigned long phys)
  {
	struct tdmr_info_list *tdmr_list = &tdx_tdmr_list;
@@@ -1530,12 -1525,17 +1587,12 @@@ void __init tdx_init(void
  
  const struct tdx_sys_info *tdx_get_sysinfo(void)
  {
 -	const struct tdx_sys_info *p = NULL;
 -
 -	/* Make sure all fields in @tdx_sysinfo have been populated */
 -	mutex_lock(&tdx_module_lock);
 -	if (tdx_module_status == TDX_MODULE_INITIALIZED)
 -		p = (const struct tdx_sys_info *)&tdx_sysinfo;
 -	mutex_unlock(&tdx_module_lock);
 +	if (!tdx_module_initialized)
 +		return NULL;
  
 -	return p;
 +	return (const struct tdx_sys_info *)&tdx_sysinfo;
  }
- EXPORT_SYMBOL_FOR_KVM(tdx_get_sysinfo);
+ EXPORT_SYMBOL_FOR_MODULES(tdx_get_sysinfo, "kvm-intel,tdx-host");
  
  u32 tdx_get_nr_guest_keyids(void)
  {
diff --cc arch/x86/virt/vmx/tdx/tdx_global_metadata.c
index c7db393a9cfb,6aee10c36489..000000000000
--- a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
+++ b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c


