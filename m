Return-Path: <kvm+bounces-27413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59B0B98576A
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 12:55:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D2CC1C21019
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 10:55:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7FF918308A;
	Wed, 25 Sep 2024 10:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dG0uQ9zT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00BE877107;
	Wed, 25 Sep 2024 10:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727261742; cv=fail; b=Vi6ECTvBzpzwb9Lbwhmqp1bqzDhtJac+k6oN/0nvv1l4J7jm879E2wAOS8m+Bx8iGfePMHGfKxiQGYC7pqwWHDrjkYK/bsrqq81lDpu1At2OPeYnHxtGLfJpxEw8MTefFDQbjHZYNjm2imjYLVWhwb1EslRoQe/c+MLiLS2YEQE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727261742; c=relaxed/simple;
	bh=RAK1I+POI+r5Pm1vZfekuwzargAKsCiYoYakBIHzzTA=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=k6bqoCUzqwHNzwcnqvYa5ZQ6GTibKY+qqGhSCEtPvWq+0yNZQW3cltwTG/6jbvXnG4ViMEF3hq7mO0bueaejkS0mUDJphq2YTRPOxmA60hNEptByZR6AklSab3/bZUFHEo4ofV2uRcN3kRo1nocSZEpvDLCqo+oTsU2wiVKIelQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dG0uQ9zT; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727261739; x=1758797739;
  h=date:from:to:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=RAK1I+POI+r5Pm1vZfekuwzargAKsCiYoYakBIHzzTA=;
  b=dG0uQ9zTRxDRuMWzGgYmtQhNkZSEunKNT5cEv5Gy9I7rrZOwQdxmKcwU
   QeYbYCxl7VUo6X86h7eEicPx43xonXWfw40Q+cKhhStizHlrImXwDc9vJ
   s1L2DPXTqaZ3LtAqd34J39M98w/pRMnb3aBO/m/DNp0Bv0an9Re7OO7cU
   Cg5/Umeq2r9FL/6YM9qJegtG/tKHUkUkCKy/oMprQU6+12C2pITPn3l+J
   qU4bYSalTZWWGMGCPk0G2R7LjKIiawDuJQlx4L5pnZAFCstF2867AwZSS
   K1I6mV+BXxW8sXznMejrBB1pzbgMp8ODYEXSoNPn+JKD+7OTz67mAmwac
   Q==;
X-CSE-ConnectionGUID: JcIH05a3RIKVFI3B3/I+eA==
X-CSE-MsgGUID: 0Qg9OPP8RQiLDIY81yBZdA==
X-IronPort-AV: E=McAfee;i="6700,10204,11205"; a="37679127"
X-IronPort-AV: E=Sophos;i="6.10,257,1719903600"; 
   d="scan'208";a="37679127"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2024 03:55:38 -0700
X-CSE-ConnectionGUID: HNuBzTtQSTKQn6CMDDLf6Q==
X-CSE-MsgGUID: IxHM0e/7RlqgXNtOTaBW5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,257,1719903600"; 
   d="scan'208";a="72046843"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Sep 2024 03:55:38 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 25 Sep 2024 03:55:38 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 25 Sep 2024 03:55:38 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 25 Sep 2024 03:55:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yklkQDyEMNQA5HT5pfYeEB4LsCLqoJiSDh2Tza8yVvFTKdb96y47mv3k5oLMMeHPs2YU1ZCfmy7YRBwHXcd6n59s485znGC+FOxWvmuOMFr+uVsneknvB0zFMW+9i2jA0JEiCtDqb0u2w2ztYFMBQ0D1BMmbjKUkVFhcuNsIItWwS1xtcGbjyabPbAyolE+EiOcD5+XJPSFwG5/bcsfXUgrZwGetZ/MCKSEEBXlqmMZ+Swtz920K2mcKcavyZ8m4b8opp3Ur1px9Sl1oBVtWPg8JL1+ByCB4I4APfgPS+B65NxAZmHb/ohPi1Rt+Lr37a/YAMpHVlghvcSSAd9JE8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1qDl08qTJ9hOSgtg6pS+hV70Z1eLYBZEceE52KtLo7U=;
 b=fMUtmF5L02RhIfY0St2ZGcKRPLKbKYqDEAO/nDDpMofYPwrG9KkvQ1sujRi+DtzmYDMISRhCQznpgb3gLalwwRU3LtM8dzNH2Zzmns+2YqMhZVcmr96dXY6TZLRFGcjkcXWGvqL5DBvQXk0Tao7ndsb7Jao8d44dNslUi0kFQOoUVsohLJ2ij8PGrrN7qI1ec4kt5bFLvgk4e9TBcXH+L9N3U/zJ4B6vfMVYpKKW3Yaffs16Ai4C/ay14Vs3SFX8bFllFMeJUGKGWjS0+CnmFQuMS1H7WxylxymyhXzWpMlk9uZQutI5K8PUQo8zExAdPM6VbbyOxVeS2xF2+NDYXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CY5PR11MB6511.namprd11.prod.outlook.com (2603:10b6:930:41::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7982.26; Wed, 25 Sep 2024 10:55:35 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7982.022; Wed, 25 Sep 2024
 10:55:35 +0000
Date: Wed, 25 Sep 2024 18:53:28 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>, Rick P Edgecombe
	<rick.p.edgecombe@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	Yuan Yao <yuan.yao@intel.com>, Kai Huang <kai.huang@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "dmatlack@google.com"
	<dmatlack@google.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>
Subject: Re: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY
 with operand SEPT
Message-ID: <ZvPrqMj1BWrkkwqN@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <Zt9kmVe1nkjVjoEg@google.com>
 <1bbe3a78-8746-4db9-a96c-9dc5f1190f16@redhat.com>
 <ZuBQYvY6Ib4ZYBgx@google.com>
 <CABgObfayLGyWKERXkU+0gjeUg=Sp3r7GEQU=+13sUMpo36weWg@mail.gmail.com>
 <ZuBsTlbrlD6NHyv1@google.com>
 <655170f6a09ad892200cd033efe5498a26504fec.camel@intel.com>
 <ZuCE_KtmXNi0qePb@google.com>
 <ZuP5eNXFCljzRgWo@yzhao56-desk.sh.intel.com>
 <ZuR09EqzU1WbQYGd@google.com>
 <ZuVXBDCWS615bsVa@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZuVXBDCWS615bsVa@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: SI2PR01CA0052.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::11) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CY5PR11MB6511:EE_
X-MS-Office365-Filtering-Correlation-Id: 0fcc734b-921f-4d2c-966b-08dcdd509539
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?oBhaaRleukKrHajjROR0Xv/rJPRoZ6vqLisi6oPdiI7R6DhT/BHvgGi8JKqO?=
 =?us-ascii?Q?Dn6DtrzC5NjAO4aeRzL9fndDc/TouhXlUlmNohnVvBJEmCZ2Ywu3x+fjxHlR?=
 =?us-ascii?Q?a/1pfxgJezXOfi+x3+hvpiwKD/87Mr1hWB8otbFAjC0dVhCLrCh+YZeupsOp?=
 =?us-ascii?Q?Z336eHHPmUGjpBQ5q54n+q2Us2oJHKwOSvgxrtRHm686UcmsProS599ISOBT?=
 =?us-ascii?Q?deg4Zbnh/NhmDPzKV7Hxynd04iwJLjTAhNghs/v5JbaSgpWD5Gx19j1imrlY?=
 =?us-ascii?Q?Xy1M2XEVVzlRhsxGfwc9tPa71vKRvr9aFB7+8YuR263/7W2HzCwxh1E44D1Z?=
 =?us-ascii?Q?vznzkc1D4DhgGRoEUmGj2nhHx+uLAJTRPhG30Q5OHn2TWTKZWwLKPxfG/bXD?=
 =?us-ascii?Q?G5Fj3U9ZpsPk/4PmByWDy8ojTVnRVplPwZAJ/EXVTC+3D0qZgxJhInFmabLJ?=
 =?us-ascii?Q?39iC4hN2aeVIOjtwXU79Nilfj7VZUcWIMv7nrlTO/hRHXvZLLvXXyed96E9m?=
 =?us-ascii?Q?aMqUYK5yd5xgbv4hS3vCUDuNiFZWutV8c63VzvkLbBHGRP7T1lD/GZo1PD5W?=
 =?us-ascii?Q?DYkI5MDp7NTOK+gl3RflW+rulM29mfINTO8TL05iMpER2QEXUJByN8RDa5HO?=
 =?us-ascii?Q?+RkIzaCX/JGbmZE90j2NwOklu0vxrbnHq/vIwj7A7EqT3qfOHmZ32N3JxxU9?=
 =?us-ascii?Q?Nlmt2tVAzpiIqECeW+RISZ3otOFz55bZD6XX6XIVCInE27dxXI5If5ZWxepD?=
 =?us-ascii?Q?1EiKfpEuJoJrMzh/SjHkM3pA+9l+X11cudk0ME8tgJNL1i960MeD/OwgdHyh?=
 =?us-ascii?Q?kHbAKqt4iSJj1e+mHU4Yj3VUvXJ7w6SYeegXXi2KXw9OCj6yfk1RCo9OhPwF?=
 =?us-ascii?Q?zKondxK99WtKiItL3vdzSQgvvI55PPS6pvJHXHD9XTI9OtZZCWv7MeBIKWgi?=
 =?us-ascii?Q?UCoJdbhzE2LRNRbLmWzuaejzU2GeJYZdm+D93+IwBCiiU913uJlaUuootWkp?=
 =?us-ascii?Q?wExk7a28Bvp77By7/T5h+uEYskaDKahxPHUHgOVgQv7VNjxh/4nGl562k27S?=
 =?us-ascii?Q?KPbycYLXfUMce+xSfnaY+lWMfQjKga/Rb0OVtFEffi+HMUDOECuAVeK/86yl?=
 =?us-ascii?Q?3yTp46fAD/SqkUaVzXe21IDxUxZAtrCf2Gr1m/fndnNx7bepDcEdR8yoal3i?=
 =?us-ascii?Q?Sgt8w4gknpkvvA7zIYDsGTkxCtvJ7Pjmm1yLQvY2pL6Iz87R1c3FoeBjxNIP?=
 =?us-ascii?Q?naE+iH+4xK6eaNkq6XUozfw+Fwzz6slrBkb8mRyAxGHNg40qqIA6AwvqOHcw?=
 =?us-ascii?Q?gh1NqftVZloq1KCeDyEwYciO?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Tdp/vjiN9LmU+SC6ZEnWKELSf9DjtVKbYqRsR3GQzX10IQeFcrHYo5l+HWmr?=
 =?us-ascii?Q?Zul0p9uX2lpZlBMlrUr6/WCzGQUUAGbe4dXcA8Nu8HpmZFul7oPs3VbxrTyt?=
 =?us-ascii?Q?jlRfpYREmzGQ3gIPVwcf74WlpHXbPSDWeheuGkpWR0YEKs3+87o0HuzViYJY?=
 =?us-ascii?Q?HEq1ia4ogOTjtEPuWlZZ07uoAQcbd40yng8j7e+uSloSqg4cJHcfqqQROKnH?=
 =?us-ascii?Q?gy4GWrUYOr7KYuLdaG1/2gvSf3sR4mzcjKc4Uhp2Xr5FNApPmlRpy3DOJd8U?=
 =?us-ascii?Q?AP9IJyVeHrJ/M1GOOexW7juBjWpTKmihauEsnK5T0UYFsUWnEvbJmfslxZCu?=
 =?us-ascii?Q?rxjdPQQrVzcKNs5zFxwS1n+TXpQPrCVS61012EsPatiepCbzB1Q7lKxCpQlS?=
 =?us-ascii?Q?AK/lyspEMOWe5Nq8piNvuHYO3/cGxHa/9Ylv5dO9YgSkKjh3ygOh0OAXXNRs?=
 =?us-ascii?Q?hE/dtAxGcr2avHG8g8SJDnIOMpLUvoQHcZuvdkls3r3YxhcHhq5ld/yEsw/+?=
 =?us-ascii?Q?My+JCffoM8zaveMt3ravTQg/7Cjm+gOmr5vYchhL4Nf+TwR3aDc1jCGpNjg8?=
 =?us-ascii?Q?0owhmrGFpiAg2WZPU5U8Dn12cwjVw54f2lEod9+++nKIN4iikk3tyCPYCbhf?=
 =?us-ascii?Q?sr/O5hfK5iBtWCPWBunYID/IY+QrA6hAWl4WBrwqge6Qefjtvv39DnamF7+q?=
 =?us-ascii?Q?7gfarR11aWslWqNWaxX+GOiXgvoWhPh3lAr0M2kJgwYoFYr0mEjI6ozJCBqv?=
 =?us-ascii?Q?EJCSu15Il1fB58OQGeOlvXrz5/CVRII7KT6IN/gZXlW3O0ef0Pr6tVRgyep3?=
 =?us-ascii?Q?1N+GSAWQ9COoObAOj5/gww4Tyv8g5vUtAGXBGtjDWjds1mvV0GOXGtELS1kJ?=
 =?us-ascii?Q?v1rcONVTIMGtOrUXjpJudqxa1bhR7aAeXaLTqORT5/KmaEMxQvqWxVjk6l8u?=
 =?us-ascii?Q?57IjYusxYZUSl0L/rdvAExVgBRMsBfI1P5niEgNnJj1LOlvAiUcMnVNNh2K7?=
 =?us-ascii?Q?DqP4eogxE8ELw6zkHekdFF5dGeSZTJEJfC6VEkh36SLAPy7zKalBiAydBFNV?=
 =?us-ascii?Q?vNM35w2wjSjyc+hLjRRxK27iCFeFssJdYbzNijKlp9GL6V+duAfP3GvwbdoL?=
 =?us-ascii?Q?4Us25+dHnPgxUQf4ySl4lGCfhE/yzuQiw1ZPDIsVPsSacQU5WRa4cLNC/UYd?=
 =?us-ascii?Q?7HaMAaJG+ug909IRsPOH+xo8nRh1PczOsz+z6iyvodjCrmxewHP1L26wYwTH?=
 =?us-ascii?Q?Hqu31rEebCPyhd1Ku3eW62jPGXAlzmiUBWocB0fINq62Nyz+erLFau9wi1E6?=
 =?us-ascii?Q?qDRPzyqQfaCsmCefmVf7PMDoc4YbiIPfUo1U+puwhHQGK9QFqH81BfF5tV70?=
 =?us-ascii?Q?UPUxrc1ckI0mqabR3aSDEvY2DCleC7TrwFijv9sRMECpR71flgolJTQauXCW?=
 =?us-ascii?Q?VWg3XF8Turs6yKjHpFyntXm3B8+id8h8Lv9abs2Pamewat9/XAIuQ9LbJUi4?=
 =?us-ascii?Q?5VAtzj3KOu2PBMmcLjlnrZ0xWMs/AyrA2OVjjFqnr4SPDCXwEKnqqRIj5IJI?=
 =?us-ascii?Q?lSShKQ61sFcAd6FjNKt34ibDk1Ca10f5vbmjTAdV?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fcc734b-921f-4d2c-966b-08dcdd509539
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2024 10:55:35.2440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SWX6MyCooTUMVjwdVqsu2Y6zXXt5aNAm4sdRyxeM960Hb7qYrV5yZFUYuXitw2fG6iMQqXpoMWcYQhO1eN9xCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6511
X-OriginatorOrg: intel.com

On Sat, Sep 14, 2024 at 05:27:32PM +0800, Yan Zhao wrote:
> On Fri, Sep 13, 2024 at 10:23:00AM -0700, Sean Christopherson wrote:
> > On Fri, Sep 13, 2024, Yan Zhao wrote:
> > > This is a lock status report of TDX module for current SEAMCALL retry issue
> > > based on code in TDX module public repo https://github.com/intel/tdx-module.git
> > > branch TDX_1.5.05.
> > > 
> > > TL;DR:
> > > - tdh_mem_track() can contend with tdh_vp_enter().
> > > - tdh_vp_enter() contends with tdh_mem*() when 0-stepping is suspected.
> > 
> > The zero-step logic seems to be the most problematic.  E.g. if KVM is trying to
> > install a page on behalf of two vCPUs, and KVM resumes the guest if it encounters
> > a FROZEN_SPTE when building the non-leaf SPTEs, then one of the vCPUs could
> > trigger the zero-step mitigation if the vCPU that "wins" and gets delayed for
> > whatever reason.
> > 
> > Since FROZEN_SPTE is essentially bit-spinlock with a reaaaaaly slow slow-path,
> > what if instead of resuming the guest if a page fault hits FROZEN_SPTE, KVM retries
> > the fault "locally", i.e. _without_ redoing tdh_vp_enter() to see if the vCPU still
> > hits the fault?
> > 
> > For non-TDX, resuming the guest and letting the vCPU retry the instruction is
> > desirable because in many cases, the winning task will install a valid mapping
> > before KVM can re-run the vCPU, i.e. the fault will be fixed before the
> > instruction is re-executed.  In the happy case, that provides optimal performance
> > as KVM doesn't introduce any extra delay/latency.
> > 
> > But for TDX, the math is different as the cost of a re-hitting a fault is much,
> > much higher, especially in light of the zero-step issues.
> > 
> > E.g. if the TDP MMU returns a unique error code for the frozen case, and
> > kvm_mmu_page_fault() is modified to return the raw return code instead of '1',
> > then the TDX EPT violation path can safely retry locally, similar to the do-while
> > loop in kvm_tdp_map_page().
> > 
> > The only part I don't like about this idea is having two "retry" return values,
> > which creates the potential for bugs due to checking one but not the other.
> > 
> > Hmm, that could be avoided by passing a bool pointer as an out-param to communicate
> > to the TDX S-EPT fault handler that the SPTE is frozen.  I think I like that
> > option better even though the out-param is a bit gross, because it makes it more
> > obvious that the "frozen_spte" is a special case that doesn't need attention for
> > most paths.
> Good idea.
> But could we extend it a bit more to allow TDX's EPT violation handler to also
> retry directly when tdh_mem_sept_add()/tdh_mem_page_aug() returns BUSY?
I'm asking this because merely avoiding invoking tdh_vp_enter() in vCPUs seeing
FROZEN_SPTE might not be enough to prevent zero step mitigation.

E.g. in below selftest with a TD configured with pending_ve_disable=N,
zero step mitigation can be triggered on a vCPU that is stuck in EPT violation
vm exit for more than 6 times (due to that user space does not do memslot
conversion correctly).

So, if vCPU A wins the chance to call tdh_mem_page_aug(), the SEAMCALL may
contend with zero step mitigation code in tdh_vp_enter() in vCPU B stuck
in EPT violation vm exits.


#include <stdint.h>

#include "kvm_util.h"
#include "processor.h"
#include "tdx/tdcall.h"
#include "tdx/tdx.h"
#include "tdx/tdx_util.h"
#include "tdx/test_util.h"
#include "test_util.h"

/*
 * 0x80000000 is arbitrarily selected, but it should not overlap with selftest
 * code or boot page.
 */
#define ZERO_STEP_TEST_AREA_GPA (0x80000000)
/* Test area GPA is arbitrarily selected */
#define ZERO_STEP_AREA_GVA_PRIVATE (0x90000000)

/* The test area is 2MB in size */
#define ZERO_STEP_AREA_SIZE (2 << 20)

#define ZERO_STEP_ASSERT(x)                             \
        do {                                            \
                if (!(x))                               \
                        tdx_test_fatal(__LINE__);       \
        } while (0)


#define ZERO_STEP_ACCEPT_PRINT_PORT 0x87

#define ZERO_STEP_THRESHOLD 6
#define TRIGGER_ZERO_STEP_MITIGATION 1

static int convert_request_cnt;

static void guest_test_zero_step(void)
{
        void *test_area_gva_private = (void *)ZERO_STEP_AREA_GVA_PRIVATE;

        memset(test_area_gva_private, 1, 8);
        tdx_test_success();
}

static void guest_ve_handler(struct ex_regs *regs)
{
        uint64_t ret;
        struct ve_info ve;

        ret = tdg_vp_veinfo_get(&ve);
        ZERO_STEP_ASSERT(!ret);

        /* For this test, we will only handle EXIT_REASON_EPT_VIOLATION */
        ZERO_STEP_ASSERT(ve.exit_reason == EXIT_REASON_EPT_VIOLATION);


        tdx_test_send_64bit(ZERO_STEP_ACCEPT_PRINT_PORT, ve.gpa);

#define MEM_PAGE_ACCEPT_LEVEL_4K 0
#define MEM_PAGE_ACCEPT_LEVEL_2M 1
        ret = tdg_mem_page_accept(ve.gpa, MEM_PAGE_ACCEPT_LEVEL_4K);
        ZERO_STEP_ASSERT(!ret);
}

static void zero_step_test(void)
{
        struct kvm_vm *vm;
        struct kvm_vcpu *vcpu;
        void *guest_code;
        uint64_t test_area_npages;
        vm_vaddr_t test_area_gva_private;

        vm = td_create();
        td_initialize(vm, VM_MEM_SRC_ANONYMOUS, 0);
        guest_code = guest_test_zero_step;
        vcpu = td_vcpu_add(vm, 0, guest_code);
        vm_install_exception_handler(vm, VE_VECTOR, guest_ve_handler);

        test_area_npages = ZERO_STEP_AREA_SIZE / vm->page_size;
        vm_userspace_mem_region_add(vm,
                                    VM_MEM_SRC_ANONYMOUS, ZERO_STEP_TEST_AREA_GPA,
                                    3, test_area_npages, KVM_MEM_GUEST_MEMFD);
        vm->memslots[MEM_REGION_TEST_DATA] = 3;

        test_area_gva_private = ____vm_vaddr_alloc(
                vm, ZERO_STEP_AREA_SIZE, ZERO_STEP_AREA_GVA_PRIVATE,
                ZERO_STEP_TEST_AREA_GPA, MEM_REGION_TEST_DATA, true);
        TEST_ASSERT_EQ(test_area_gva_private, ZERO_STEP_AREA_GVA_PRIVATE);

        td_finalize(vm);
	handle_memory_conversion(vm, ZERO_STEP_TEST_AREA_GPA, ZERO_STEP_AREA_SIZE, false);
        for (;;) {
                vcpu_run(vcpu);
                if (vcpu->run->exit_reason == KVM_EXIT_IO &&
                        vcpu->run->io.port == ZERO_STEP_ACCEPT_PRINT_PORT) {
                        uint64_t gpa = tdx_test_read_64bit(
                                        vcpu, ZERO_STEP_ACCEPT_PRINT_PORT);
                        printf("\t ... guest accepting 1 page at GPA: 0x%lx\n", gpa);
                        continue;
                } else if (vcpu->run->exit_reason == KVM_EXIT_MEMORY_FAULT) {
                        bool skip = TRIGGER_ZERO_STEP_MITIGATION &&
                                    (convert_request_cnt < ZERO_STEP_THRESHOLD -1);

                        convert_request_cnt++;

                        printf("guest request conversion of gpa 0x%llx - 0x%llx to %s, skip=%d\n",
                                vcpu->run->memory_fault.gpa, vcpu->run->memory_fault.size,
                                (vcpu->run->memory_fault.flags == KVM_MEMORY_EXIT_FLAG_PRIVATE) ? "private" : "shared", skip);


                        if (skip)
                                continue;

                        handle_memory_conversion(
                                vm, vcpu->run->memory_fault.gpa,
                                vcpu->run->memory_fault.size,
                                vcpu->run->memory_fault.flags == KVM_MEMORY_EXIT_FLAG_PRIVATE);
                        continue;
                }
                printf("exit reason %d\n", vcpu->run->exit_reason);
                break;
        }

        kvm_vm_free(vm);
}

int main(int argc, char **argv)
{
        /* Disable stdout buffering */
        setbuf(stdout, NULL);

        if (!is_tdx_enabled()) {
                printf("TDX is not supported by the KVM\n"
                       "Skipping the TDX tests.\n");
                return 0;
        }

        run_in_new_process(&zero_step_test);
}

