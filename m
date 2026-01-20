Return-Path: <kvm+bounces-68581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id CF2A7D3C203
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 09:27:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 70A53485AE9
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 08:16:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FE073EFD20;
	Tue, 20 Jan 2026 08:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GJfJu4cP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9AA23EFD15;
	Tue, 20 Jan 2026 08:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768896074; cv=fail; b=raS5aygleGne4RkM3u9jLtBQgXgJ3/rJ8l1Unb7QKPrkZOM0FQV5HaMHRw6VKkyqaQm/t9BeR/hxmfLSjj1lZj3W93QrFUadvF3abrhgU/w9TG5HRBhei+n9ha7QNjtAL1jtKmqamsCnZv2vyN2m7aN8cc925SLw9tyea4vsTqg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768896074; c=relaxed/simple;
	bh=Jj5+GDp4QY0R2x7QRLiNgvjsC1lubEM2LogUXTlDlJo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bH3RNIfIBasLuL1IwhDLXfrOPkXcHFKPV2i3HFfPIC71sGhTrLWJwojle+09qS+pYgzKScqNkh/BiFM815/U8YjnDMa0mpCqtBQhGuzqY/fIqsRZwimTFLwafk0SN4POqNqrHkeOqACK+NZXFYkGq43/2w22JZo+7+YYFOBa2pU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GJfJu4cP; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768896073; x=1800432073;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Jj5+GDp4QY0R2x7QRLiNgvjsC1lubEM2LogUXTlDlJo=;
  b=GJfJu4cPl0zKVsB/Fe6H3YGoLlyKFbh6ciwEP4ocDK3K95bVuT9I+Yh8
   vLeZNA4UwPvOr1cERlvmWYR1XjPTd+haP9e2Ffe8WxuHWGfi5zMeWsQUV
   sRih/NOFyyMeBcgAEOGBmUIOU16mHSEXV1+a3vvbFnlTYQMwJduxlFuiC
   1skLZqSumPUbDDOPmQRpyW1ZVRyVqynIuok2W0DAapu9t5YbmBN3pcKQx
   DP69Ll0+RgITHaTl7N+bCIw0De3uyE/LDm24aHugPAe2LVR++fDs/tgs9
   ad6tZ8FDMZlRf5+WpscCYj4kdlkDoflw7eo6+GV5lNJFVKskQ8yOELp+P
   g==;
X-CSE-ConnectionGUID: AVbV9UHXSsyoBYq2nw0EQQ==
X-CSE-MsgGUID: j8Mo5kkxR+2eP/XWpLgQmg==
X-IronPort-AV: E=McAfee;i="6800,10657,11676"; a="95570537"
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="95570537"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 00:01:12 -0800
X-CSE-ConnectionGUID: Y062dhZcTq+ewazifWERgQ==
X-CSE-MsgGUID: 1W0DFzZeT22VKQ7l7Sgi1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="210194307"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 00:01:12 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 00:01:11 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 20 Jan 2026 00:01:11 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.31) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 00:01:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kLuWmtvk0IXPBE9NeGbli5cIvE/+gg2erWuUeAM6O05cCfkoM0/Fg+oQnrtPpv1TAKWV9mDI6OexphHRChUu/2QUCy04EBkPXGKpLVQ7humCVyAq7WRQrr9ZNY5dciuVYOA/g9NEPBxlbKvSa8jIr+hbM/NEjf4QcgUjUH2+1CNl8EGtUc9l2tRpbP7XNg0PQh98sGbSAvTJpGhChIBFCGm2gxhMMD/XXsNF1qRFTSPUETNJ0O8RCfL69gY2uA7vhn572cpTHii/iROP5JebeYQgNieFtC6mw37vWf3/1Uz3cCO8sSGIv3oNuVEJV8fK17aCw6akb7FUxYdW3x/A0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jj5+GDp4QY0R2x7QRLiNgvjsC1lubEM2LogUXTlDlJo=;
 b=G5e7JqyBd1oeet+dt/ToAdapBLuxmnHqdqUk7LCKnlLqsSfA1OteNmBoRpHi3GbFqxJ0IKLmcgO6ujuKh7Dv7ZZtAH9ISs2tr3fU4SVCB84COjC9fdxD5yUaR3gsf8Xt+6tme5JU89ET4ry2SHH4MdFjEJ2iMaPFM4JtLiiRn/xKJ2N1j1cdKgMqyj92OxNMeT5cdONNaDeNUFopYKP5iC5r2Pg53icD/8m/7bbiVOZIU1Dw8yJ0Jig/gdufWR9QQFjGtxVVuvuMWclmqs3HDoBowOGDH48pl99ADABgMu+feLiE6bjKV9KPfQ0UWk7xU5S8ExkVidXEKqyrOFZEsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH0PR11MB5521.namprd11.prod.outlook.com (2603:10b6:610:d4::21)
 by DS0PR11MB8739.namprd11.prod.outlook.com (2603:10b6:8:1bb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Tue, 20 Jan
 2026 08:01:05 +0000
Received: from CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::df20:b825:ae72:5814]) by CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::df20:b825:ae72:5814%5]) with mapi id 15.20.9520.011; Tue, 20 Jan 2026
 08:01:05 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Hansen,
 Dave" <dave.hansen@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Annapurve, Vishal"
	<vannapurve@google.com>, "bp@alien8.de" <bp@alien8.de>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v4 12/16] x86/virt/tdx: Add helpers to allow for
 pre-allocating pages
Thread-Topic: [PATCH v4 12/16] x86/virt/tdx: Add helpers to allow for
 pre-allocating pages
Thread-Index: AQHcWoELZBdGy2q3WEmEfimmygwfnLUEV7eAgAE8jQCAAESUgIBVKf6AgAAJywCAAAQ0gA==
Date: Tue, 20 Jan 2026 08:01:05 +0000
Message-ID: <9fe0ef0c41a7ef8afb1d6cca5c1ed63c3e377333.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-13-rick.p.edgecombe@intel.com>
	 <7a6f5b4e-ad7b-4ad0-95fd-e1698f9b4e06@linux.intel.com>
	 <af0e05e39229adb814601eb9ce720a0278be3c2f.camel@intel.com>
	 <9dcaa60c-6ffa-4f94-b002-3510110782dd@linux.intel.com>
	 <a99ec2d41087c65e6b55ac53af8dc158ec5dc059.camel@intel.com>
	 <aW8yuEX486oJ+zOp@yzhao56-desk.sh.intel.com>
In-Reply-To: <aW8yuEX486oJ+zOp@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR11MB5521:EE_|DS0PR11MB8739:EE_
x-ms-office365-filtering-correlation-id: 533f39a2-b385-4c0c-9695-08de57fa102c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?Q2FncE5ybDlmUm1lYjgwR243OE5Qb3JQcUZGS3hKY1lYZEN4NXRWbDlBb1Y5?=
 =?utf-8?B?U09WMnU5a2x3azhrcTRYNkpzTWpzWW84YmY1K05CSUc0VWdkNC85MWx6RkdZ?=
 =?utf-8?B?ck4zQms4V0pGYWR2clNWZVdjb2tCNFJXWVB6S0x0OXRBMTJDcmQ0SE9rLzdJ?=
 =?utf-8?B?T3pWakE0V080aW9xS2Nyd2VHaXNycUZKMXo1Q1h3L01lNUhLR0E5TTV1MVhs?=
 =?utf-8?B?YWFSODdTVis4ZVQvdGllRmtKS05GNnM2RFVDcFRjdkpNU3crTXNiUDNvdXov?=
 =?utf-8?B?RzlGRWdnR3RDRkgxbEx6NXFOZzh4dWIyeXBveFZlY1NLUHY1VnNKdVBpMjNZ?=
 =?utf-8?B?RVdjQm1HU0xNcDc4RElTck0xK2ZLRkMvNXpMZVF3WEtsN3hCTXBqNTVoRHZD?=
 =?utf-8?B?d1A5dnB0TjBDbEc2SDAvU0xFUHZuUVRyZXVqY1FybUR0eWt6UW9QaEF3dFMz?=
 =?utf-8?B?bDdDZ3JQSnN2SWszSEx3SjREeHJUemNvNDlCQmJ5QlhnZmxtaHMrdzJLaGFZ?=
 =?utf-8?B?cHRiYVRwWGNvMWZvWHpIYW5CelBiN1FZNFFZZDUrZHo0WGdOOUdJcG82eUZR?=
 =?utf-8?B?L1F1aE05U1QyUXlOTjlSbnpDdC9YVnRuT0lydGU0SUxaQkE0Z0RhVkpqak9Q?=
 =?utf-8?B?TXh1Z3FMT3hiNnkxdkJIS3VYa2lYM2Q2RVFFaVBJTXlPZEZmNnRoU3NGZlls?=
 =?utf-8?B?d0pXRVFxS0xwUXhoZmVyZng5VmVzYVlqRTlMNHVyMXlhaGo4aFhQcnpOVmkz?=
 =?utf-8?B?TkwySkozc3Z4SWJVN2ZpSEh2MGh5S3dmZWcrTjVZTFBwcFpaUlRSTWxiaUtH?=
 =?utf-8?B?MGYyTGlvVDBBSkxWUW1RVVhERXNPT2hJVDRtNkN2UEZBWUZXYjFaOEVtWFBj?=
 =?utf-8?B?eGJGelBMUGxvQVNGb2FMUG1nVE56dTVhcEtqalAreXptbG04ZCt1ZHpUcU5v?=
 =?utf-8?B?K1hTaXRLeDZqMGNqU3luMnN5c3BKKytldzQzNDYxYlpKQkxzcnVwendNQWx1?=
 =?utf-8?B?NGxNZmUzWG01ZXZ4QnExbE1idVNlVjhYanZDZm10L2lURHhaWktTc3lwcS9I?=
 =?utf-8?B?VUd2L000Y0pJQ0dJTUJVbWdRYXdpYXhKZnpaNGJ0bTNFNi9oeE9MbkhuL1FH?=
 =?utf-8?B?SStPVjhMWnVvdnB5QU1IMEhHRGxhQTlSaW8xUklSeVcxcjNLbHlSVWVDRGZJ?=
 =?utf-8?B?ZWVIUmdvS1gzWXZsYWYxOXViWEhNUHpBUEZjakRud0w1RTlaaVdSR2hWakVl?=
 =?utf-8?B?QlhBdzBaQStvYTh6NTRlRHJpeThlYVZsb0NUNjVsUFhoR3JxSHNZVDdOWXZ2?=
 =?utf-8?B?OVQ0dUs4VmZaR2ZhM2JzRzhsaTBiWTJXMFlqSU9JQkdQYUdwSWdsd3FUKzl2?=
 =?utf-8?B?cWlFOEdIUzd4dFdLbDlhdHY5U3RzQUIrTjhXWlgwejlCWlpVbUVSREIwc2NI?=
 =?utf-8?B?dmRhKzRYZTB2MDk4UVp4d1ZuSUxKVk5PSjJFNml6Qzh1bVJYemhqcDF2M0Jh?=
 =?utf-8?B?dExWcFdBT1BvRS83ZHB4NkNTRndsZmNUdDZSOEIvLzBaL3lCc1gwZStMdnY3?=
 =?utf-8?B?cStJd3VkelplNXFtOXd2QURTQk5TekxNVUxqSHRPVWJCbW5NZVplSlBraG9D?=
 =?utf-8?B?SVo4UXpWV0VaV1k0VDZtV3pHOTc1MjMxeHdLdm1Wd1UvRCtJSzhkd0o0S0RD?=
 =?utf-8?B?NEdXbGU4M2toek9pRjAxMW9mZUZNeWNjWmFFS09HYUZzbDlnbU1LR2VERlY5?=
 =?utf-8?B?cml6RTFiTXZ0SFZjdVpLUlYvbjk2cFdXV2RDQ2lGaVFRTHBjZk9ML085a291?=
 =?utf-8?B?bmlXdDhqT2xBTXQ0ckx4TUtsd05tZDdJRXJrMlFOZ3dET3orSXgwZjIvbytp?=
 =?utf-8?B?V29SOEkvcmJsZE5jSUdTaHRPZWlFTGIrQ0RtM1paalB5NzBsQ1J2QmxjVTFJ?=
 =?utf-8?B?czNLaGJDdDNZS3g2RERLRFVJTWhVa0dJSmZ5RmtsWFFwMzN1WnJTR2ZFT0dT?=
 =?utf-8?B?UVNQazZkMHluRFpOekZES0hqWHZEcUtyeGZ0K2JBTGpSWE52d09VZ055cTRD?=
 =?utf-8?B?WmpZRmtLcnZnZDBFUTgwSm1PRktWZ2o5NVZ2K0VWblZXRXhUUGRWQUtIN2J5?=
 =?utf-8?B?RmtkSFAyWVlPa05BZnlrc2IyRUFLY3U5bVRMek01dnZ2SWEyVTBHS0FQVjlB?=
 =?utf-8?Q?Rf3yMlfO71zGNfsUlYNgN/8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5521.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VklaQVZWbjZrakNDWW14cnpqaXo5SWNxSlpXcUJhNFNUVzUrRGdiQ2E5Rngz?=
 =?utf-8?B?UUgwVFJOdTlnclorY0FNUEpwdVBXUGVSaGdJc3R1QlJic3dlVDg3WTloNmNY?=
 =?utf-8?B?ZW16bnJ5U241UG54enB4UUVsT0szV0VLYVdSazkyZDBrNnUwa0k1VXpHQVVI?=
 =?utf-8?B?Rk9WOGZsS2ZGQk4xREVpZGYyVkpmaWFWT2d4NU9QQWU4Vy8zV08rTFNPMWZq?=
 =?utf-8?B?LzV5d3F1NGJsNFlsdzNsTnoxYWRIU0dvRG4wbnNPa0pEeXpjT084Z0VKZmpE?=
 =?utf-8?B?ay8xd0laT0JMVFl2cEFUUzNIa0c5L2dLRzJma25saDdZcnhQZkV6U3YwQXpw?=
 =?utf-8?B?cHc3UXBiWmM2eS8yMHp1SktKUUljOTVqODZqQ0tEd0V4TkVmL2QxOTVia1pF?=
 =?utf-8?B?WW03cVNPeTAxV1k2eFU5b1V4a1htdU9Mak9NbG9RbUhHck44M1ZjLzdzRFRU?=
 =?utf-8?B?YkV0QnhKaHVsNm53SUg5SVlXWVdqYVg2T0pJc09lQjgrVE5LbjhHOFZLanEr?=
 =?utf-8?B?TXNyVnB1VVBveUlQUkgrN2VyQjNld3dLdVNCRnhZemlrS1NNOHBlVVhJUGZs?=
 =?utf-8?B?cnhBRHpteFNITTVXWWljczhoakN1OTBPVkNyNzIyK0IyYnlEWjVsSFdQbDFv?=
 =?utf-8?B?cTJ0SEh0S0h5emVuVGxKYVVjSFp2eFJseWZoYXAreGVCRHBVTlBrSHVNWWJ4?=
 =?utf-8?B?bHFOamtRS0JYUVZucnlvWmRSM2RPdXB1TDI0bEFtNUZudWJXQTVPR254Rnlh?=
 =?utf-8?B?S1NwREpLOEF5T0w3VkNpeWpJb3RLcmQvbEhiRkxJeWs3dm4wVmdIUXo3UmlM?=
 =?utf-8?B?VitKUlNOZkhTUjhYUkNRYTJ0QzFQWUNnazllZys1SURneURlaWY0WnJyNm8v?=
 =?utf-8?B?aUlha0NBY1U0YkQ3UTl2aVE0RWJWa2JzK3RWU2pvSFZsLzJMZTMzT1U0bkVI?=
 =?utf-8?B?MTY3Y3JyRys1Tno4QmhRUmlKMHFZcHVNTkN1c2RmK05PbUhSS2RFU3lHMW4y?=
 =?utf-8?B?M2dHWEUzOFRhMkZpVXBQbzk2d0ZkU3FzclhOV21XM1J0L2gyQ1pDMmtkTGgw?=
 =?utf-8?B?MG5lS0pFeWVReDNnU0JWS01FZGNZU1dvdEZ4Y3k4eks2R0RQL1c2RG8rQTJR?=
 =?utf-8?B?UXBmTUhzc2VTUmpqdXIzcTM1SCs5aU1wV1hyVEpzRHpsTzFKOUdoK0VjeUth?=
 =?utf-8?B?MWw4djJmaGdaUjMrTS8wNHI2c3gwMUZ4MjZRRG1VaFdKU2V5aERZZnp5N3RS?=
 =?utf-8?B?SmZ4REJicHVGRTJxdURWZ3JEbHdaTjYyamtxbFJnK3N6Mlk1NGJheVp3ZlJW?=
 =?utf-8?B?cy9tVmpMYy9ybFRxSC96NEExdFNNM281dGlzQ1Evd1g0MDZzOVE0eEFacXRZ?=
 =?utf-8?B?UTZUNVBEM3YrSS9oQlZZT0paMGNXdTVYc2VQTEdaTTAyY2JhajZncmhKdG9z?=
 =?utf-8?B?Z2dSQlFHdkMzUDRDaE5ST2FRNGtlVWEwNGFwMUlzZE91SVRCaXNLZ2JkNU0x?=
 =?utf-8?B?d3hmVDBRS0NjOVJDSHZyR2oydytBS2dWaHAxVmpHcUZsQzQrK0t3dlRiRFFK?=
 =?utf-8?B?N3hzTWdpOUk3M0xSbzFXa2FJc1E5MkszMXV3NHg0Q1AyOE8yTVdISWorMitJ?=
 =?utf-8?B?M21GV3A5T3Q3azI4aDJYMHdLaVpuU2F5Tm11cVkzSzllYUVsazIvYlBMZ2RY?=
 =?utf-8?B?Mm91QnpnOERubkxKT0pXTU0vODFKdjhuZWNMRWNJZkJBSk5NQnVUVmFvTTdn?=
 =?utf-8?B?NEhVektuSGRPd1BQSC9YRGlES3FHL0hqdTMwS1A3WmU5WndYb0xFb1BLM1hJ?=
 =?utf-8?B?aWwvcTVDUVV6OXk2N2tCcEVaN0dSdDJQejJXTE92SW90NWkvZmpjb3Z2NmdZ?=
 =?utf-8?B?VnVaT2JiQ292WnBRUEdLbVNuM3hybXpyVjhUS0tMaGN4cFpSUkpER2pPd3Vh?=
 =?utf-8?B?ZFlwQ1dTRlJIandKK0cxTEFtUnIzdkV3NnlSb0NlM1RFZTdhWWI2SmNNZWlk?=
 =?utf-8?B?VWlmVHRiMnJMc05ueXFiK0orc1lhQ2xBQStGd1BhNFJFVnZpTzJrTk85c3ZW?=
 =?utf-8?B?azJyakhrczFKN3NuZzVyYmtHWUhTMkJzTVV6cHpIK1lnSjY3V0hsalRoRXBW?=
 =?utf-8?B?UzFIbFFkZlpPMlI0eFkyaVRBMFZJYlhMelVMOTV2SlFrOUZyRTV1VzM0enFB?=
 =?utf-8?B?T25XRDdaNDBINnljOGJEd1FFZDB2UEZKcmc3QzdHelBtWXdCK0pOVmNaRzZx?=
 =?utf-8?B?K0dDMUEwNElDVEpOYWV0dWxsV2VTd0t2NjBzYy9Oa3dhM3pXQkxQd2ttSFlR?=
 =?utf-8?B?LzFkR2ZtOHBJR3NtTkxhaG0xd1Z0UkJlL0FkWHUrKzl2cFJScm9GZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <99513DF23C13CA43A78F100DF71377AF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5521.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 533f39a2-b385-4c0c-9695-08de57fa102c
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2026 08:01:05.7747
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bNnOZY0fLRBfc+jinZi5sN/lU7JVnAzqu0OEFkPL+RIZWpcZb+YuC+aTZDjUgxc8bA944ifhzjacQhlE94j3eA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8739
X-OriginatorOrg: intel.com

PiANCj4gQnV0IGluIHRoZSB3b3JzdC1jYXNlIGNvbmRpdGlvbnMsIHdlIGFjdHVhbGx5IG5lZWQg
dGhhdCBtYW55Lg0KPiANCj4gSW4gdGhlIGVuZCwgdGhlIHVudXNlZCBwYWdlcyBpbiBjYWNoZSB3
aWxsIGJlIGZyZWVkIGJ5IG1tdV9mcmVlX21lbW9yeV9jYWNoZXMoKS4NCj4gDQo+ID4gQW5kIEFG
QUlDVCB1bmZvcnR1bmF0ZWx5IHRoZXJlJ3Mgbm8gd2F5IHRvIHJlc29sdmUgdGhpcywgdW5sZXNz
IHdlIHVzZQ0KPiBTbywgSSBkb24ndCB0aGluayBpdCdzIGEgcHJvYmxlbS4NCj4gDQo+IEFuZCBJ
IGFncmVlIHdpdGggQmluYmluIDopDQo+IA0KDQpSaWdodC4gIE92ZXJjaGFyZ2luZyBpcyBub3Qg
YW4gaXNzdWUsIG9uIHRoZSBjb250cmFyeSwgd2UgbmVlZCB0byBtYWtlDQpzdXJlIHRoZXJlJ3Mg
ZW5vdWdoIHBhZ2VzIHNvIHdlIHJlYWxseSBuZWVkIHRvIGNvbnNpZGVyIHRoZSB3b3JzdCBjYXNl
Lg0KDQpJIGFtIG5vdCBzdXJlIHdoYXQgSSB3YXMgdGhpbmtpbmcgOi0pDQo=

