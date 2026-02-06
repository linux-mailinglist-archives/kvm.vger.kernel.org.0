Return-Path: <kvm+bounces-70431-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gJICJ6a/hWnEFwQAu9opvQ
	(envelope-from <kvm+bounces-70431-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 11:17:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0172DFC916
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 11:17:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 996BE303CA43
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 10:16:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE32936E494;
	Fri,  6 Feb 2026 10:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AYkOtPzN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F672FB085;
	Fri,  6 Feb 2026 10:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770372993; cv=fail; b=D9jZuf75hqCY8AehAA3nZyG6u2NsfjBHb/lu60+uTxE1HLHMa5P11O4vPOBc9Zh467G7b1Vrtnm/gs+RRroJFQs+MY8hsw/vau+qpGvTcAwxo9lkGzzCP/rXsiQh76FkDRz68amu2KbSzRGwVtUPx0Bae8cwkAkx3PeMsXb1NYQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770372993; c=relaxed/simple;
	bh=IWc2SMQW+tvaoa4VSB8Ypxl/+BO2w+kQNv6L87jcOp0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=k/ei5hBYIesEVNuD39ur9g5BTed5m8VE6ZxmZX33Z2fbXH6rkbUSxWf+frlYs0mFiCA5BzU5GNcCqHKROYQVlEswK0Ele8Mz3xfmOzDJmqqTLDHPYgKaE+QDjRByMhwxcB1xsTLpNAjvz6XGt7UsLM4RoJeH5zNKqVCF2rnDMjU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AYkOtPzN; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770372992; x=1801908992;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=IWc2SMQW+tvaoa4VSB8Ypxl/+BO2w+kQNv6L87jcOp0=;
  b=AYkOtPzNzhVjtff3XkxqhRIThsepAb/Cx0Zz8embD/0JrURBS2tlKMFb
   E0GmTrSFgblIzIGuCbuJQoCS3RpkgPSaP1qx4GvyR6It+Gv86pkKODvih
   nxqL6Mq0SPuS3fJwAk41Ojf7ZafIbD45FOUMP3ui/ohPcceTOwstGHHtp
   S8lgR8pyXsU3LPHan8KBEYk92EYxVSyzxoh9/j3YSZsNT8j7K+u5WFewg
   5JHom5HXytfgrCPtnVrOx53YYEbNQndFCuEZrv1AEzoAf19gGk1GLzJuy
   p/jeoHBneIZjTmClFy2B7gQBsptWSZsO+lIXTVyrTqWCuaL23gG1UiaH5
   w==;
X-CSE-ConnectionGUID: BlTcABzrQziADZ9NytL+MA==
X-CSE-MsgGUID: JTatuWv3RXSDKDd2sIxcRw==
X-IronPort-AV: E=McAfee;i="6800,10657,11692"; a="71680240"
X-IronPort-AV: E=Sophos;i="6.21,276,1763452800"; 
   d="scan'208";a="71680240"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 02:16:31 -0800
X-CSE-ConnectionGUID: 4pMOBNDkToWOjzmvDlTupw==
X-CSE-MsgGUID: 3n29fyfySqSNqv+faEGM6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,276,1763452800"; 
   d="scan'208";a="210728314"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 02:16:31 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 6 Feb 2026 02:16:30 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Fri, 6 Feb 2026 02:16:30 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.15) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 6 Feb 2026 02:16:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TmpPIPJnXkuO9cCr+RPGTMoVdDbyJYe9DIsGwku09+8Uc8CXFsOtbBr6SsktEOI/1iwRMR3QX5selhh02SLU3smD2mFoAmM9rofS8NMBu+4lSTApgWYrVR8Qe9e9mfqnXPYltIfv3KqmdF6jtiFkvfe3kDjYug5eoOVTBABQuAvH3ZZQFx93Clfmql+U9CNQOJ6wVV9Y9PUa2as+vZUhH99ta8WwmyhHeO983cS/5cEyby1jVvP5T0BD5BT74VcvS+A7quKNHy/HZc3wNo2EKTF9M2Ixks7d0W9BWuX9uIOdR7x0asm61yik7/znHEtxG8l7oUUykRff1rqvb3IKVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aFcPwgMemYf4mSo49hYcwLUB41FN1yY2LiHQTQPgSIo=;
 b=i+Xo9kcHJRebZkWrjA74uC0dSVd1HwDkXfNBm9WDkwJ1BPOYsjfP0gVtzhMUNv2gePz76GHKFtsaZKLwr0MAJP8s2Rnhw7QGttwWUrFZxA2ddTRI1Oyjghy7B8omM08BRjI6bFC9tWJbp2OI+uzbHM/hkEt3zTognA3yKnv2zv44BJl3UU6XTwBKuzo2uiaoV899EdoAM51cDc/Jm58qsDBUbhWPPqx0gV9a/6kopURxascwBOiCJiS0/Aexu3nAA5/OwOMNuv9y/B3YXe7SggZ8VGM+JM+rw36WJpBRWHGY4QjWFLW+dCuAFNRSgUXi2xoOCkgyPKFoFtucjZT5mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB7608.namprd11.prod.outlook.com (2603:10b6:510:269::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Fri, 6 Feb
 2026 10:16:22 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9587.010; Fri, 6 Feb 2026
 10:16:22 +0000
Date: Fri, 6 Feb 2026 18:14:01 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>, Kai Huang
	<kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, "Vishal
 Annapurve" <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>,
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [RFC PATCH v5 44/45] KVM: x86/mmu: Add support for splitting
 S-EPT hugepages on conversion
Message-ID: <aYW+6WzOmCAvNRIH@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
 <20260129011517.3545883-45-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260129011517.3545883-45-seanjc@google.com>
X-ClientProxiedBy: TPYP295CA0023.TWNP295.PROD.OUTLOOK.COM (2603:1096:7d0:a::7)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB7608:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b8285ab-153c-45a4-a258-08de6568c723
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?u4S2QQ8T5fq+CgMcRbSwpI6H5r48MOubjd1xDKjyyXs9GALBwa5VXYy5gdaP?=
 =?us-ascii?Q?75i5wuiKo61gqgVnMq6TU3yaJCRKk6lzh88TtESUjgLzwTv2w9y06nyvvoIZ?=
 =?us-ascii?Q?mZGb9wpDCbG6GLv3GJzhxOIHQwEVa9nGsRRZrqNPtXlVbkZArZ9FkOfDWd9s?=
 =?us-ascii?Q?Ry4JAyV+4cAIumQodnLW3jgIILt4yRnkR7a/AtQ/xuctUZihtrN4NbLVz9Rq?=
 =?us-ascii?Q?Iam7aSsnuoslbhnnR4zlUmufRJqhloT9pK+d58vCk/3T4VT3Vgrr/ZcWEDT7?=
 =?us-ascii?Q?JqIOaAWCy8uDAJhd0ZOqiHDLzayhsh5l5T03gV+r2BYNG3LMCcVkSlozCcLc?=
 =?us-ascii?Q?iHPJaK97lCQleG8jytpJhhbIQ90dD4BOKjZyJMK4p7Fva/277zNj7nF2GzyP?=
 =?us-ascii?Q?+x+i3Tq+LVL5X9hkv3a3cuMj2cRGSb1OoJ4EvxoybPvXpar2+YCEud/F3lM2?=
 =?us-ascii?Q?Whd+kLrChJc1PL52dAV6IMEEtIOl/asIZX9uwitRvrxuNBZIQXKHVgdCoEfp?=
 =?us-ascii?Q?HMrQah8q55D6tzSJlXFsapUoH4gUjGkSFhsRx8lygD/bri1lPctB0G0Drk+J?=
 =?us-ascii?Q?D3/cPB9R0QCo1VjPUDzVvNOrSMezkm6PC4ncQ0pD2Ipvlvcdr1H4Iz1yWcNl?=
 =?us-ascii?Q?8ax8JAiNuDCPRj6Zk80bkL5Du5SGAkrGnM6mgsZxpjIZxHER0YbepFzewDAp?=
 =?us-ascii?Q?oBknLM25KKTZEjI2z/gSilEwIC0Srbzsv657uYEBmeBcOmF81YXRhKSokjkh?=
 =?us-ascii?Q?WbP4rg+m7GYfTgvOuCAQUPH2I2wpb2PdSaDiOesS9DBlI8Wp4Udf5ObzOObh?=
 =?us-ascii?Q?O6SEDGFN/VxlUuyyBsgdCuDWQefWFvlhHy94QC2UM1/Aik03Kec1czMYciK3?=
 =?us-ascii?Q?EiuOPQ/vB9FFQ70K8M0voPHhY35WvF0h054vtmKRkbzRC5f0LeddVHn84SAt?=
 =?us-ascii?Q?GIbL8pjwSyDM6lSJLCzVXjce8Z7SZJYMt3Z7jXpuwaeLFFfY+PPOgW0vI+fr?=
 =?us-ascii?Q?q1KICpjkGW1Cj8sCSbP7qng8XzsdydnLSAq+MKEclPgcZi1HS9eouZipWZxy?=
 =?us-ascii?Q?Zkr0fg+RnzLLcbDDWB+1XnMg6A+jo0ye94QfWEkbxTokpB2/8HxoVYfQ7l1U?=
 =?us-ascii?Q?PMG9abogb5bN28sbi2zdu9rEz6RQXBf/AY36/V4rAKEFIWqsv9BEtb64VdsW?=
 =?us-ascii?Q?qFSFkpa86CcpBdms7fBf/WzjCDqa3eFvf1QSeTrlnyn8fKz5KPHGVsEWjbjS?=
 =?us-ascii?Q?COXxWI9EmXVgFuBw8LrJV+rURYKGcN3s4CwEEA+KogO+57yN0rPXbWJvy5lU?=
 =?us-ascii?Q?j7TOwfNPHgJTjTSw025a5hCrx0ETLJPIGzknR2defVYVVMUCxUZRpbYJfHN7?=
 =?us-ascii?Q?yhpnGOT17C8wX/ZovtCqQxZOwI2bHa6HFv04FtsD3kjMLx9XwLJxTJ+7okvS?=
 =?us-ascii?Q?8EWgSXoSCZ4NduJ9idUs19vE3BD81Ed0oySW+97du7iO32L/eYDa2P42Zgfb?=
 =?us-ascii?Q?a5iDUQx6Zq8uG6NxMVJHf1cuopNPb8pa12JNy+8dZSqdwf816crZmILK5pzr?=
 =?us-ascii?Q?CelbYOrgEdcPAab94fM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/V6xsiTLKPpgVVHYzGpANNQbDbZxf0UA5m2nUJUI0cbo6y7SSRKHXeinDHQX?=
 =?us-ascii?Q?Hb4LVN+w5j+dHuNaFo/GU+6geh+UMebhONYQWmXGNNF24NkjBO9P4w8mqYeE?=
 =?us-ascii?Q?6Kk6bGyNpi2uPgyQmEt/IBi6Duc247j9YFaDtfc1EBBfZ+zbRFTUMpaWpRmF?=
 =?us-ascii?Q?bGvTmMXMvh0eTrtT1lANyU0buJ+E60IJMKUR0mvmrD/7EuMKiJlahobNRIkG?=
 =?us-ascii?Q?d+D4uaIrnmwpRwN33hq4qkAanh7vFOoH3Ub/ww4/W4a/+HhZV/lvqXOrOg38?=
 =?us-ascii?Q?XupU5UrlaZYJtcThuOsUJZ3p58ULjw9EGcvL3RfbQQm/lSQ9a+YGwgVLaAsR?=
 =?us-ascii?Q?EQnbSFA2KowR46le1yDKwMMqVN75q/rGQJd0mfQzGmRO8u71Q97YQj1RI85J?=
 =?us-ascii?Q?9JHxqefQKxlWLigdgVypikWczg7piGfE3UcXM7mqqhOkSF6BxxWPrRY41L/4?=
 =?us-ascii?Q?0qItZ/mQpJwMMVgK/U5jehzbi03KSIGeG2fu5BGBqPgqBUmdYoT43JOIGAnd?=
 =?us-ascii?Q?lkfSbqO/vB9nJMQQRhfQztxUkLrm9lMvXQoPEClUoMRhSXrBm2NqJggDlX5O?=
 =?us-ascii?Q?3W2gEZ0i/nBSdhXJuZtxnyk/KJeFSIj4iwUucwBtZLis2HiDQdq/uIgmG95L?=
 =?us-ascii?Q?4VbZa6lsmAMpL0O7O/EGI/Q0c1OzBzyCKQWO7rcLrkvRuSROdrKrPzfUaUwG?=
 =?us-ascii?Q?eufReusiFAa+0T8iN+Nr85grCiwTqXqiqkgsHgdBW13mYtz1HfqvBxb4y2eC?=
 =?us-ascii?Q?M60L9rTRAcma2Om2AwQiOWZvRZrnEY7DndSU0C+BtZOtd9LtTlJQfHOpXQhw?=
 =?us-ascii?Q?//ItJNEuVNaXec/R9W11IxkzziNt6P2E4QEzQHxEIiH1Yam/BTTnAfaBV2P2?=
 =?us-ascii?Q?QDToTp9Ov4qse4ikYGawZoT0FU71xse9LDs7tuMpgTKeLWIZOPjfevXS2oGG?=
 =?us-ascii?Q?kCWlL5d7czF8Mt0wWeekZ/wVovjbOchOSAXJqMbq+ODsw1IOYOwH1PkgzCVp?=
 =?us-ascii?Q?i6rvPN6YSbxSvDGld3fTZK1kv/EvgVjVAqHm49oSTz3cM5rLTtQjsEV3HFea?=
 =?us-ascii?Q?/QTo9zbrLVQgZRf9DZkU2IV5Ht6SOwftps6RiR1kfpGws6q0wYH4rHdFxV6X?=
 =?us-ascii?Q?Wu8Ww/l1UKlcbh+ryXx5ql/4h7w0mZgwLzXoXvPHiZIxKp8tsHsA71+kh+xQ?=
 =?us-ascii?Q?HGmNarsZ+6B3Chwf8DWdJ080km+afEKnyyQTGDH7SZG51oplMM7f9VBV06jW?=
 =?us-ascii?Q?YeUGe0ua624hK1N9AKlgngyIHN6lN1AllaBL3hj8Bhp+UkIBVfvHJ4cXE5Eq?=
 =?us-ascii?Q?bXSG/hR09p/7P6SgAhwsZ7hqERdh6ddMx6Jd1wCxU2bMArB80tZhOxNpZHqx?=
 =?us-ascii?Q?oR4clxNnVzCu8wRr6vOeBx+Qp6edPh+gd7z3fhF6Q7J04JXjROWMIZDsALpi?=
 =?us-ascii?Q?HYYtk9wVYSDvoiA+llUyC2bdQrgi+FhsYCT7SZeK7zSzOPG9xmt0QV+BWi8a?=
 =?us-ascii?Q?GmRO90F1crdsZ5r1KIIvPIVdMxttaHRCJwdtzO8GAZWDxn1H+VbU/PSafBXw?=
 =?us-ascii?Q?XOdnCCPEYEPvWmWpexQlwvBtPpujHGJ1ZcEO4V9OooOz7QSNExpNs+7twmSE?=
 =?us-ascii?Q?BaeiLyYdAIBfqE8JRx3k0EfDl65lbBrP0QfVjsDzdYf2ffGWZ3D/2gpaty0C?=
 =?us-ascii?Q?s9lO0ZVlth0X6ToFDjNhN8JO6VOC0aoXf+NeRuu13d39OyQrXcX2rkAGWgE+?=
 =?us-ascii?Q?PPyWN8CHZA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b8285ab-153c-45a4-a258-08de6568c723
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 10:16:22.6620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d/4wQy9cK3TLUWtdWT5tXMiLlWBwReMKYbEXG5tOPSBQ5Y9y1VDSYh5yG1xdGvZJkpS/VAiVG7pSSsU7i78pBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7608
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
	TAGGED_FROM(0.00)[bounces-70431-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	HAS_REPLYTO(0.00)[yan.y.zhao@intel.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yan.y.zhao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,yzhao56-desk.sh.intel.com:mid,intel.com:replyto,intel.com:dkim];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 0172DFC916
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 05:15:16PM -0800, Sean Christopherson wrote:
> Add support for splitting S-EPT hugepages in preparation for converting a
> subset of a hugepage to be shared, as KVM must precisely zap/remove S-EPT
> entries to avoid clobbering guest memory (the lifetime of guest private
> memory is tied to the S-EPT).  I.e. KVM needs to first split a hugepage so
> that only the to-be-converted small pages can be zapped.
> 
> To avoid unnecessary work, e.g. if only the tail/end page of massive region
> isn't aligned to the conversion, explicitly detect unaligned head and tail
> pages relative to the max page size support by KVM, i.e. head/tail pages
> that will undergo partial conversion.
> 
> To support splitting an S-EPT hugepage without a vCPU, add a per-VM PAMT
> cache, along with a mutex to guard the cache.  Using a mutex, e.g. versus
> a spinlock, is important at it allows KVM to allocate memory *without*
> dropping the lock, i.e. so that the PAMT cache can be topped-up as needed
> without needed to juggle arch.tdp_mmu_external_cache_lock.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  8 +++-
>  arch/x86/kvm/mmu/mmu.c          |  2 +-
>  arch/x86/kvm/mmu/tdp_mmu.c      | 72 +++++++++++++++++++++++++++++++--
>  arch/x86/kvm/vmx/tdx.c          | 34 +++++++++++++---
>  arch/x86/kvm/vmx/tdx.h          |  2 +
>  5 files changed, 107 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 385f1cf32d70..54dea90a53dc 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1563,6 +1563,12 @@ struct kvm_arch {
>  	 * the code to do so.
>  	 */
>  	spinlock_t tdp_mmu_pages_lock;
> +
> +	/*
> +	 * Protect the per-VM cache of pre-allocate pages used to populate the
> +	 * Dynamic PAMT when splitting S-EPT huge pages without a vCPU.
> +	 */
> +	struct mutex tdp_mmu_external_cache_lock;
Missing "spin_lock_init(&kvm->arch.tdp_mmu_external_cache_lock);" in
kvm_mmu_init_tdp_mmu().

Will check the patch you replied next week.

>  #endif /* CONFIG_X86_64 */
  

