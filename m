Return-Path: <kvm+bounces-57296-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A552B52ECB
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 12:42:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E897A00015
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 10:42:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 524BF30FF39;
	Thu, 11 Sep 2025 10:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YnGqK1oT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C8229A2;
	Thu, 11 Sep 2025 10:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757587356; cv=fail; b=YODmuqpjtOlO1mERsjCB3SSy5oJi1HWo2EdG687l1dkK2TlPAN03m/q7G+eKtwdadQqBMh3X8QR9ber0d+Eh7o7HbZc+VPkCQURYgNNVwUJo//WWDDHQP4+vEmM/1mODJh3an0Q633EanCZFcdX90RuU2fnbyl9wFNgbhgsp9qM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757587356; c=relaxed/simple;
	bh=WdPEmG+XTOUchgQf0TWLGqTliRGqVBIkg16yK3eXJiQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RLRIp34AXoVw31NrF+PdIU69D7VVQL2kjJ3PxmO9/lvOCZti5itgkpsYpxmMm8rXrwT4jlSOKvRr59eXv/10xQgdeHBiaK02w8u4ngsAx/d1YY6DTd8mksJgwgddarq/sFWeYQuQe6Ai/wk1VmPK/QOViO5u2t8Ursi7hyFvtZM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YnGqK1oT; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757587355; x=1789123355;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=WdPEmG+XTOUchgQf0TWLGqTliRGqVBIkg16yK3eXJiQ=;
  b=YnGqK1oTUCChEcs432/YOF69G8Jx9aHu4SnVIpGR80FwKPvvm/X1oZo2
   zOjnBI8A8qC/9KJyT5J9Lds/2Dhc0NI4WwjVicyf/mK6/dehJdNqAAihV
   DmPMJhF8WaZl8tKIRz9CPKfyo9u0+yMT9tqq/XXnEYA++fSMRzAzGerh/
   z2s/65LYklfJIIX7c7Oy52fONE47T9Ohu2fEEsG2K2dE8B3cL6MyrjksL
   TafOxALznMh864pKkZWW4Ipd7ybsyxTKFBBp+z3odKwnqWRd26o9Wrbjr
   YuJS79cGR+I/XpJN8fpmYlDuRYiNPmloQEbtHcF9yntQL5ANZ0Tdqqcl2
   Q==;
X-CSE-ConnectionGUID: ZcVujgydRxOuJkIfjOzETQ==
X-CSE-MsgGUID: dkIds7KxQNOCFtfaPah2hA==
X-IronPort-AV: E=McAfee;i="6800,10657,11549"; a="47486555"
X-IronPort-AV: E=Sophos;i="6.18,257,1751266800"; 
   d="scan'208";a="47486555"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2025 03:42:34 -0700
X-CSE-ConnectionGUID: H6FeXPW7RfKmXCmlW1c59Q==
X-CSE-MsgGUID: no739WhBQOCsHwJkUkciaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,257,1751266800"; 
   d="scan'208";a="197336706"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2025 03:42:34 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 11 Sep 2025 03:42:33 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 11 Sep 2025 03:42:33 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (40.107.102.68)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 11 Sep 2025 03:42:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YjyMxVK4IaNgeveXQV/j0mLuDJebve/E/LgHmNHUynwLa8zbH3apGJ01vPseAsjBy3GKTR/+fWdCm5y4vQu6vWLtlpe63Kq+UzGl2tG2pOxpq8PITYB6f4sTUwGdIOPKOtHVWdzR0oSYDxfcc71SHOsHVwgjpwIlfL3riLx6a5ppDq4Mkb2+3HF/oEbQKp+S+O3B1KUUs4dDXWT53ZbASIkG4MdbmcFaKK9yyBRRbY7YanJZaUhK9FNykSSx17SJ8CShtDCkJyL3h9ExtO0m2CHgDYnnZ/ojYwDgt79pgs3dy4ewzA9HPTu1XOoF4PRw9kYVTnozxCGgUpU4Fc5oMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+iR2BI0E5KTxJOqyV0ovMZvV/vrtPD1WWTZzAlK0Mc4=;
 b=uVG9dcVn43KbPJSd3aakD9LreWvERBNrgpmCGSs2ki1NWNjYb+EMdZoZBCg1vdB9Skaj4S207rm5O4KHDjaFkocnBqujcoDCnxqi8YO9Ke4pQDF26MzHxcGEECDrJlUABdOxLNKdapjTkycrGTGcrXShY4kTjXUPAcTDobZ4H6YcbYefbhaLEHpZNtxOYah4ExpKQzrj9tQbg+UR3KAfqAGNRJMHx6pIKYQtbKmhBmthn7Ll6g/9kY38qMx04IX4bfTCe1t50Bo58PEkQ376vYUzvdlDeP/uL7ZmbMzOLQwBtac0UnbkatZ2q3lmxfPDPL/ClstfmoXoTxfGPf8yoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ0PR11MB5894.namprd11.prod.outlook.com (2603:10b6:a03:42a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 10:42:31 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 10:42:30 +0000
Date: Thu, 11 Sep 2025 18:42:17 +0800
From: Chao Gao <chao.gao@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <acme@redhat.com>,
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <hpa@zytor.com>,
	<john.allen@amd.com>, <mingo@kernel.org>, <mingo@redhat.com>,
	<minipli@grsecurity.net>, <mlevitsk@redhat.com>, <namhyung@kernel.org>,
	<pbonzini@redhat.com>, <prsampat@amd.com>, <rick.p.edgecombe@intel.com>,
	<seanjc@google.com>, <shuah@kernel.org>, <tglx@linutronix.de>,
	<weijiang.yang@intel.com>, <x86@kernel.org>, <xin@zytor.com>
Subject: Re: [PATCH v14 15/22] KVM: x86: Don't emulate instructions guarded
 by CET
Message-ID: <aMKniY+GguBPe8tK@intel.com>
References: <20250909093953.202028-1-chao.gao@intel.com>
 <20250909093953.202028-16-chao.gao@intel.com>
 <8121026d-aede-4f78-a081-b81186b96e9b@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8121026d-aede-4f78-a081-b81186b96e9b@intel.com>
X-ClientProxiedBy: SG2PR06CA0206.apcprd06.prod.outlook.com
 (2603:1096:4:68::14) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ0PR11MB5894:EE_
X-MS-Office365-Filtering-Correlation-Id: cc7c7e67-4671-40b8-da53-08ddf11fe894
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?DvI9womgY9aiZ9nsXS6zqnd6wHHS7lNlIQHzoI74KAt6NX563iUvM5koEVtt?=
 =?us-ascii?Q?vfBaj+3tysKB8ehSfj/WWr1tLvxGyQClKnygZIZSz5gR2QmF6Ar9DypXEEIA?=
 =?us-ascii?Q?DPNIYpzNJOMXgbMgH39OFj5Hmrm8zl6qZf5GCFWWjLRUmgRGTZp/8x9ybWad?=
 =?us-ascii?Q?J6L7U4prIVBW1+FyAQj+vb8wVZUMLMKTYVPrgYBOVzXeUObetoFwGBJv9UKT?=
 =?us-ascii?Q?k91FvYQe4vkihw6cisVyCUx56+anzKNmBnwbq+b/t8vs9qdjm2w/QCd/BcEn?=
 =?us-ascii?Q?TV0R37l9juIkELqr3dDQjGFKiILdtlCPr8E/sCQOhjsaufmJCbdz3UA7F08q?=
 =?us-ascii?Q?ONaHzT5PFxXfZpMWg8sOHU1mJpC2tk2mOaCFah3ynjNmwYbpoZzJ8j94hkTI?=
 =?us-ascii?Q?tTm7F+PAe98E4OO4HPgu0ZdhPtX0whNBT2ALVmgLCtUzStAGaUpwbHzoZXST?=
 =?us-ascii?Q?0ZhlacFfbJGjs5LDpApmWujZzRhZ8K1jB16RP2cqtGRCmvr3pLKuPWBihk8V?=
 =?us-ascii?Q?Vqe/RQmjXt681zrY9u49iplSxscW04PrjZdB/TAr85J/9Ab2sNmkRsBObOO9?=
 =?us-ascii?Q?cMsor+bjmV1e4O4EZToVZ+W8zzEkMKdqpcTE5enRusBn3hg2TvUF5EI+WCYQ?=
 =?us-ascii?Q?HG8afzHk8/tZ2hxYDiOvG+nnFdec3Eg0boSBqsdFyw14Qd25qALimmNZVFf7?=
 =?us-ascii?Q?4iKNDya66vYjhMYgmdERm4R+rca5kSIzJ3CENmbrGEYtllQAgfk03sAwzWKZ?=
 =?us-ascii?Q?05+UFMhTWGD134+oUHpTiXwv8+7aQGC2B9AkOWjEoek8BCcD2B6ST0GpHtiv?=
 =?us-ascii?Q?Di4kbUHUMb9QXY7+obWUX9Pn/R83fz3fpo/x9HVfdRW1qabboERZJfXEUcyT?=
 =?us-ascii?Q?bufBn3K7V3PksLVf0C+cWmxMzF8J6A0npofeYSxp3scDVUwPp8b+4OVtzPm/?=
 =?us-ascii?Q?fW6bjtjJd859HKJfMcIObPkEB0cfncLE56jpeXKBipTndTdFzEV9vWJ+hh19?=
 =?us-ascii?Q?OvcKeZlEz/n98SolDGWcHO2b/+iKHG2P8DdLa2Ozj9r105GlwegW+58bcITH?=
 =?us-ascii?Q?CDgAWZ5mYzsuzdEczljFaKrUgk5wVU3fOAubJmv+jvlAptr1GkVdECjCd/DG?=
 =?us-ascii?Q?UzzB+TLgLRN9qMTbYrhanmiU0LOK+GHfvRKi2qDk/qj5QrjQcfyf0V32vdnU?=
 =?us-ascii?Q?XeIqLP8KS+T4UDBwAK+i2sYoYCPKSGWQpkbi13wIfmjIsV6yiqOsSjlryYUB?=
 =?us-ascii?Q?zCFq4lLnqxQL+uDH1SafqSFL/BtYpp7+5N2ev9zt4j7tBZOrSWm32kRemJML?=
 =?us-ascii?Q?dNobZCAzSGeGX2dE7NKYyqeKafluzG+wtRr19ATQrkshgJqCruHyod0t/mgN?=
 =?us-ascii?Q?T6z8QNmfHpOnoUDn0C3JNjwmn1iD?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FZ76AC0qBal/0qOl89axuH+jFTsf/VgogChQT1sIQ7of0xffWgAEoNoq07dC?=
 =?us-ascii?Q?hcAaz1Hfow64tgaWenuyILjLDSxoCq+iY0rQmylwJ+LfZU6MoBwnGOBJdgI3?=
 =?us-ascii?Q?nMKQDk5IWDiAolpzzN6s+putncpQ5t14po8GDmChxK31MxOve4kinslK8oFh?=
 =?us-ascii?Q?gdxqY1RUo7vUVvRpBRMkZ7rEWBCg2d8h7Kv+UTuWpWinVeQJX3TK7ZczzBBR?=
 =?us-ascii?Q?6Q+6CgdaFiPZ3Uz2e4Qq7y2TEpkvlBStcrV3tqJWD4TAtoRudMhRapcDH18X?=
 =?us-ascii?Q?KeA0AKNa8oyn/hajaGeuFpbJ7AKzBdAVPzEvWX418XY6xKedXUz2oaGyx+aM?=
 =?us-ascii?Q?JTpZYH50aTbdPHKqgTokIiAfnF1bg+DcPT0snBc3j1VBygJCakE01/Mw2yZ1?=
 =?us-ascii?Q?J65mh/AI91DVGivSwB6WUS5M0fE0HZNMePeLOJdEmxw2NHmXoNpNRnebR+6j?=
 =?us-ascii?Q?Ol77l6wUK3TaAPgyF1yowpfZeccjk4exKjb+bNOWJIO0KBUsAc2cTAudMvRh?=
 =?us-ascii?Q?Zcdgvq8ghKnrGCHhqQSejSaYof8t9aX+tDzHQI7LtzHTDtO7MB/qXtSbhrPw?=
 =?us-ascii?Q?FvFXXUG8dAy9SKjch1sNnPWT9S2uIBGv34eQBD5rISkZoZfecfSiJS3QIQ6S?=
 =?us-ascii?Q?sERJ7ri+V57xwTrLBncSevqEO/Rf+apdw/ne4O6LOOFAyCtqfUMqKe8sqzNM?=
 =?us-ascii?Q?m/jlwt2Ql9ldntGkCZtEE1r30IxmCSck6r80ptxUCpFLxcQOEUaCTxfwRISD?=
 =?us-ascii?Q?itQdbHPcPF1x+eHmmSE4eRptPjIxUoHpfCid/XIyXlCZ+Iyyb5Y+Nw3iCRuZ?=
 =?us-ascii?Q?R6Ah88+Lym1Toi8Hfxru+XLm4adg7ssXvkaTk9Lyo4UFC+0YdWbKuM2nLcNl?=
 =?us-ascii?Q?XVcDjIjXEIArYkCg2Oeg2JCxsjk5LH5Hvt7y7PbZN9UieaMT3NYN7fF2T9wN?=
 =?us-ascii?Q?ojvsPOPD70u3sy/EGvjHQDw60phQwaSlO8mmHYJQPEdN1f49/uMI/rBc5vqZ?=
 =?us-ascii?Q?H/+73/We6uAq0jYneIFfZ0lJjeoSztIRIejdFbqJLaxKYTVhaLruc005Ti6j?=
 =?us-ascii?Q?zJzxwBH9ap2PeLz2hJHAbt3HearKXTJu2RV5+RfpI1k2BnBFmjB8mymVO4P7?=
 =?us-ascii?Q?oqdIqFI79c2/thcFomR6WD+ccDSqyXlez6ZItAiBYCbQiQp7H6D8MidnNG8q?=
 =?us-ascii?Q?wkmYOU/wuppD4b6NvL8FTkIVMM3gDYEGOnrHzShEk7kY8twefJ7Cj5u9u8Nj?=
 =?us-ascii?Q?jsdtgLOYY37/q9sdY6tm6wWEyvb517QWX3SukJSiOhtQuYVOVgBf+ajM9jGz?=
 =?us-ascii?Q?ZslCB0V9RDft8SmQgoL8M7iH1LQ86WPE/SY0GIU8B2Lp6XAG/BCgH8nR8apa?=
 =?us-ascii?Q?WmAAgLhjzFsfZ6nPqvJCwOOw2W4OSbT8jjk49qMDJcWJ73pv5ZLmzlAtDFgy?=
 =?us-ascii?Q?ZN3FENxIS/unAmsY5t07RyaVBDyqzPmF0K278jiNx0KoAqwJQNHCgqT5tHVz?=
 =?us-ascii?Q?b2csywkJJIqOziES04hFOddURQ5Q1Gr8pFYWpDEO0f33fcVFo48QCBKQu17G?=
 =?us-ascii?Q?o1YRfjY36hCBDPJxec8s3AWCoQ/avXvWsaSWHIct?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cc7c7e67-4671-40b8-da53-08ddf11fe894
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 10:42:30.7641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: asV/F21OwhPq26ZEuHGT+7rifk4gMBVlkRLdUtfFTJOdMx8bZjdHgYTHy+UC3wlnLzEIv6PtRWncfQZzsZPWWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5894
X-OriginatorOrg: intel.com

>> @@ -4941,6 +4947,24 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
>>   	if (ctxt->d == 0)
>>   		return EMULATION_FAILED;
>> +	if (ctxt->ops->get_cr(ctxt, 4) & X86_CR4_CET) {
>> +		u64 u_cet, s_cet;
>> +		bool stop_em;
>> +
>> +		if (ctxt->ops->get_msr(ctxt, MSR_IA32_U_CET, &u_cet) ||
>> +		    ctxt->ops->get_msr(ctxt, MSR_IA32_S_CET, &s_cet))
>> +			return EMULATION_FAILED;
>> +
>> +		stop_em = ((u_cet & CET_SHSTK_EN) || (s_cet & CET_SHSTK_EN)) &&
>> +			  (opcode.flags & ShadowStack);
>> +
>> +		stop_em |= ((u_cet & CET_ENDBR_EN) || (s_cet & CET_ENDBR_EN)) &&
>> +			   (opcode.flags & IndirBrnTrk);
>
>Why don't check CPL here? Just for simplicity?

I think so. This is a corner case and we don't want to make it very precise
(and thus complex). The reason is that no one had a strong opinion on whether
to do the CPL check or not. I asked the same question before [*], but I don't
have a strong opinion on this either.

[*]: https://lore.kernel.org/kvm/ZaSQn7RCRTaBK1bc@chao-email/

