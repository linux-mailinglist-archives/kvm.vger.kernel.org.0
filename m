Return-Path: <kvm+bounces-26445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C8B797479D
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 03:07:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ECDF91F2705D
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 01:07:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A05E1E4B2;
	Wed, 11 Sep 2024 01:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KyJCO7vB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E97E17BA6;
	Wed, 11 Sep 2024 01:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726016848; cv=fail; b=RrDL+GVLzfD4uIUbfTsm4ERlXb2rYt4iEQ7puw10xt0bSSFb5KdTcL/BLjLzjFhQoXyN3LNs4rpsPPNgcwnfNCZNScY5JlGH02szBiIKxfXZ+Tm5w69QritwceVt89egRc/s9mBlrjbrZmDEh+gyAWANPeS1g8lhmExC5N2pqY0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726016848; c=relaxed/simple;
	bh=Tp4NalvaL9UiQFskvRrPu5aigAoRQCGIzFJ1bmI56L0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Gx8af4SkLah7YYgDqNZonRAXxfNZ8X8uGlx5QSduigARejZ699S9OyNE1ZxQ2rn1Yez1DK0Dn0VMNReMx3JtPP2BqxrKlq5/417aqB6zGJ1U3rGMfKIthw6gP9uL7xQtBjdxjmxNNgTRidNBd0eNgVJpDYyP+5HrQ2OouFVHvKQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KyJCO7vB; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726016846; x=1757552846;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=Tp4NalvaL9UiQFskvRrPu5aigAoRQCGIzFJ1bmI56L0=;
  b=KyJCO7vB7BlZ/jzCUbAsnDlovehBRlJaGFrVIZdI/I6L75bCFph3p5Cs
   6lHVCNa8V5pl2y8R/LfYSHBB6Ah+mzjW9CsgnJzyzRLuvp7JZxHkrkAkp
   OqXg1qSJ069PpurfIL8XGCbL+sJ3QbYk1MKqqzMyFK/VPryVnuhm8v1EJ
   B5II7IgtRGN5MT8rPgLYM3OlZsj+yetAKz9L8BHbhXt4n1Faejb9PJwwt
   c0vi68mHMPB6A3YPOYtUM463XnGzb63hY2O4q6iDrG6D6VgvwYIE2XWGR
   aeUQTRuIFWkD+y1nz3hNKNlOajlWK2eHj3rv3FTQ4XDoWSt6rEHwupmdC
   w==;
X-CSE-ConnectionGUID: N7CLs8rWS4m8auIh2h3e6g==
X-CSE-MsgGUID: GcqBmUiVSYiyhVVB+hB4hA==
X-IronPort-AV: E=McAfee;i="6700,10204,11191"; a="35365615"
X-IronPort-AV: E=Sophos;i="6.10,218,1719903600"; 
   d="scan'208";a="35365615"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 18:07:24 -0700
X-CSE-ConnectionGUID: ds+I9VASTN+PxViwbT7Fyw==
X-CSE-MsgGUID: d2Zf+RD5Qly7z4ta882Cww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,218,1719903600"; 
   d="scan'208";a="67439722"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Sep 2024 18:07:24 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Sep 2024 18:07:23 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 10 Sep 2024 18:07:23 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.44) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 10 Sep 2024 18:07:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tHbOYcgT7VRK5sdxtLBvk4Zvx+I/Xul0eGyqy50ovbRVb0GMpYfSUt0/pSUZ+snJwkHuy0MjdoBG7Uk4v6XCWDY+qn8PeTMam7mkXdbubWjVvnL+zy3724l8m9aCn8/OjZ4OvHrjt0FYgheLhmmXt2erJfG0Rg593OVmWho9oz/BQyQHgk+kSMmChE3YZzx67kUus90z+EEyt9X3PRSVdw2aIVRruzwSR3HhBkmADM9SSqDdTv5C8iUhYUSIGf877worbyJW8OVVpL+ORysf3g/ZbQvGDNPYnw0XaXZjGuxgZmO1ifgfE8YuFT12ZfGh5YCCyE0PwxC6GPxtOvYyfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QLrUTyoMhGeg+BOAqu3giLNAuiMr0msQpRXqhFjnwnY=;
 b=FxRcV0AhlG8ECDGnjORblereXbdtwMxf9bNMfY0J51OHR6r+T5qhBjN7MOoo4aAr2erZZBZVw/Np8XiHcyW2Ymswd/Y37Wg3ykckAM0MGyUsWxH1jbK92nHo7rdFD1o9aI3QxE5hxF538+1CYL6qSyq8MrPnTbDy7bGl8pbnBSh3lvsO0HwZ/SB87zWta5O8Ct+v0iK43btVDa4qlvZ/fwxuBogNKBAAkFZ4llMDPnw6vYteZGLgNOpCDMtA4hs3aNUziL2Y1Rf1q6C/jo66GbpIccTCWf9aCOdgEClAX3cv/t0dHwN2wDFuafrU7q2hWLlBjc1hWBk1Putk6IySDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 LV2PR11MB6021.namprd11.prod.outlook.com (2603:10b6:408:17e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24; Wed, 11 Sep
 2024 01:07:21 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.7939.017; Wed, 11 Sep 2024
 01:07:21 +0000
Date: Wed, 11 Sep 2024 09:05:24 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/21] KVM: TDX: Implement hooks to propagate changes of
 TDP MMU mirror page table
Message-ID: <ZuDs1FhSfF3+uy3B@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-15-rick.p.edgecombe@intel.com>
 <5303616b-5001-43f4-a4d7-2dc7579f2d0d@intel.com>
 <a675c5f0696118f5d7d1f3c22e188051f14485ce.camel@intel.com>
 <128db3b3-f971-497c-910c-b6e2f9bafaf6@redhat.com>
 <4b2bea4b62445db76b5ac5c6083a72ffffd8f5d0.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4b2bea4b62445db76b5ac5c6083a72ffffd8f5d0.camel@intel.com>
X-ClientProxiedBy: SG2PR02CA0116.apcprd02.prod.outlook.com
 (2603:1096:4:92::32) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|LV2PR11MB6021:EE_
X-MS-Office365-Filtering-Correlation-Id: 364f616e-5cbb-4116-3192-08dcd1fe1681
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?uNxGxnUtem+QZZKq3aghrQtZyEfeuWrwycPX6s1N2vqPzp83U+YLtZmHtE?=
 =?iso-8859-1?Q?pG2aXneOvHEFe4ELs9Q+n3Z19i8gSteumMPz75q2m+nhcvUsmTM9IFP9kM?=
 =?iso-8859-1?Q?K0v5yhpS72zeIdCTuBNrkz+LhiKuAkfMqw8wrcKmRYJSGpy8ap4stZzwuf?=
 =?iso-8859-1?Q?juKzcF45pdHPNpd0szKeSGY8MfjJLykf7QsaTwaVp88BfjRF0qxzJo5vW8?=
 =?iso-8859-1?Q?MgVbJVcPpJ3mPNJkgkhaorC4UHTGwf1Io7Fsf0oy5tmEfvNjOTwOToOJIJ?=
 =?iso-8859-1?Q?7A2XdD3jN/jtNrJWTvAUCdPeaL+pqjmGQ5lAwN4dAHmEcmkdi7Le3L2A20?=
 =?iso-8859-1?Q?m84bQmDHGTFFAUDvp8FNNysm7hRqZ+ebC72PJUKKCSP1frKh3ni5+rCXPI?=
 =?iso-8859-1?Q?djEliZn7muFZO/PXRoIhaErJW6aVQO7cY19CmgQnSaN5V9b0A0kbTxqrZW?=
 =?iso-8859-1?Q?Kb6/1uBoKXnQ74R5mfXX5pjXfGxK5W0Jxj92JKYJ9koBcbmbjlV3m9utax?=
 =?iso-8859-1?Q?RfA2I37x0d65IZuDMFr0J6uqyhbII7ka4p/+d2bSKEvBAjTXmi9CJBsBFB?=
 =?iso-8859-1?Q?5ZG7YNFsbxwKRZTM4dABMHXLeeoF1gMyqvmsZgFJTGfQrwAnzoLDozOocD?=
 =?iso-8859-1?Q?LiLYyEN2MsDWS+1mHoWg3JYlBTo8ndfgmtx1ZVcRQERKWrtg4d8ZalVwV5?=
 =?iso-8859-1?Q?rb3S6zHfbBblGJ3jlVPtr1ABVayjhMRI9CUsMJJV/ME1EoqKp5M6+sLpZ3?=
 =?iso-8859-1?Q?hpyPOwwMRveuPsA2w+CXjBWzu3kNtWAFvcUbp3I+dNlB994RH12gOMTyDi?=
 =?iso-8859-1?Q?kuhXwnPxIAKCNo8+FCgIzCLL4qWd7+9R05364u3kfKc/o85X+FSKE4Xmz2?=
 =?iso-8859-1?Q?bJtJn3pMFBeNZeFB8jOjumYEYPq1fXkkxMggmc7P7QHkZb87XF2ind+QGn?=
 =?iso-8859-1?Q?cMk2N1/wc0KgUHy2umSap6bHkQxUwyDnRV8CDMIVAZjXV6tThxGWKnDwJe?=
 =?iso-8859-1?Q?rpBMHQfmaJZIxf6Ipe71QCQm4kAMiVGdykkohKKQK0ytbKpDtGc0RViTmG?=
 =?iso-8859-1?Q?tAo9np2YKLMATT8HX14AwnM55RxYHfi+nDvb3BJ54HeAlqajXfEyEmTj72?=
 =?iso-8859-1?Q?ADzn+6OHC6Baga4jTwDeG6XMEI01yp0K4HCphTAQYbcHT5Ut9jl4/utSpf?=
 =?iso-8859-1?Q?GvPQtXTZqA2zYP76h6OhOmJJNBN5ICsklUoL4cNUn6OpCvIZ/U1V1luktZ?=
 =?iso-8859-1?Q?lwF/K6VU8VJrYFTGnwVtobT21f60iYzZ86J75p+vvCUOrhA/wo3vltZSNg?=
 =?iso-8859-1?Q?mFNxY0MoDqvtsPmyzZKuZ3pnE3MLEwLJScm+PjquQWcFFsUBaf/6+zCWhL?=
 =?iso-8859-1?Q?1l1Fj4qpCen4FRb88F4OpFy7BVXPGHTw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?+jDySEMgIjRs0eLFrSrCSWlcqWnlxn4ezqO2Ql0JOtRGFWDCATmTsyC29D?=
 =?iso-8859-1?Q?SvLNDyq5SJQJLYkVgJ3hyBqLM5v52xM8IZg2isNEPlKDYcUtH0iopJcU9l?=
 =?iso-8859-1?Q?h+fLunJVuNO+UZJM1mgDZ2oN6yxrGK9v5IG+gDQJ4Q7QgYsgqJ80ZjrOME?=
 =?iso-8859-1?Q?9zlrsocOJAri3nv2T2UBpE98R5nFHVGJ+S0BfW/kpZcEKrQl9ynQgUTL7f?=
 =?iso-8859-1?Q?xzw83ICpHCvHeof8ix59obVjaeQwNEUsJ33BXE0vrghFidSM3twlNubJzM?=
 =?iso-8859-1?Q?9dzgvdNdQvGLF29s7IIHe3Vk0mUwMD9Sd6P9xFRw66R0h/e5/Kyw4TTsxa?=
 =?iso-8859-1?Q?9qyHuX/IL7qqFIfpa1SjYr/LulGXiolVEqZuN0GDmGJZXt/EOzwU4wyRdv?=
 =?iso-8859-1?Q?BBAB4WGTMaXzmDtHwdL2GujB7o6OwTezn0Mb41Gg81Zy1yYCpCIibcpgSg?=
 =?iso-8859-1?Q?asMOuNxjYi5AozBpi7H3WggWmDu/sAr6sJZ+rBF9ttnfKqW6CjkTozg5Hz?=
 =?iso-8859-1?Q?PsQ0kdSeoPHbVigyzoPN0JCSHIS+9eLvoeVORbPBjn/BEdhr5ChzYj1nvv?=
 =?iso-8859-1?Q?HdnhPFyRazYWTh+IkSyPXDep1/iMmWxYM3KgXSkvEzJ6vVMgI6V29pgEgU?=
 =?iso-8859-1?Q?W+Qa7gKZAkZkvvi36kcph+GGT/f+T54DONSiqIteZbMAEzW4M7w0Bht8Kd?=
 =?iso-8859-1?Q?K23Z9HOPd/eIG09cv9YcmidDpRQQZrD/h82pR9E6JdqRByrN6HlsU/OR3n?=
 =?iso-8859-1?Q?QKHod891Pwp5gy4sXYRgJeIfMPE5EWkY2aDLsKFarocDqGwAvxs1ZHf7Rf?=
 =?iso-8859-1?Q?APhpJlh/lgWICbRKQODfM2B0tSpQERZkj2tU7kXE/l2wNypcIxbRqd60jH?=
 =?iso-8859-1?Q?yM1l96LqCUufoLzkhFdkwvtGQrx9cLL4dK1g2vTZXPNk0U5pjQVtXdba2/?=
 =?iso-8859-1?Q?jhOz43W5ogtFsZs1dvYDTQm5qtx68NNbo5b2wNWiGcSl0HN1xemd2IbaF8?=
 =?iso-8859-1?Q?MWa/lA02I0Cmg2JajJKejPuDp/5MJrLJ6qw6cnieipjTVQrkHBEN5l4+Ck?=
 =?iso-8859-1?Q?/RbUn4H0zEOjfA5ts0VmRjSqx4Znnt8fuwSQGs7WkDstndgmcnAYkkYmAT?=
 =?iso-8859-1?Q?opoJomp8uPyTQ/GrF2oM7pxCkYowpNbFemx0etk237Y5K4eKneZuYQM1dU?=
 =?iso-8859-1?Q?gY17mRAYjZHI8kXRYxpD7suFnQtSflUxxqiz/r2q2bDCEInvN9xOPk9SNZ?=
 =?iso-8859-1?Q?HoodIeQYTdswStBUhCgkZSKsbd/RFfaC2wwtAcAIU18mOdA9KOsUxIvQpA?=
 =?iso-8859-1?Q?YeRt7+OmeZ2n227IOPNVOQcn8idnaNKFvnO3c5mlGVELfOXBqmyoNAcxcD?=
 =?iso-8859-1?Q?7UzAB4BWZQHNhdH7thb11Wtdtq06X8Cwd8DIysc5JsWvFAaOvZ9Yvntz3K?=
 =?iso-8859-1?Q?c7PdnJFlc4lbzbWmTIo1H6MJ2GM2ptUuMh5WSEXhWUCQGgNQNmshetJ/gh?=
 =?iso-8859-1?Q?oHu9j0za3zj0/4iypYZ6R69Sq5D4eBwflTOkpVJv/6HSHXZRXfejwZJlcb?=
 =?iso-8859-1?Q?7sFWqUNRlWT6ERKnpEFeCcT+MO76mKsyDV8UyC7fYOszq/OpDYeNDYrBoe?=
 =?iso-8859-1?Q?2V4tgqw7bRSHjGApbO6vcPXyB8oG3HOa16?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 364f616e-5cbb-4116-3192-08dcd1fe1681
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2024 01:07:21.0536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /6YbmjNKQWkgWbvQw+RXNKeDVWWDuye45LMBQJ359t2VJAB2ZwyFwsKj0XuIUYzr1YNVCipSvyD97Dctwls/rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB6021
X-OriginatorOrg: intel.com

On Wed, Sep 11, 2024 at 07:58:01AM +0800, Edgecombe, Rick P wrote:
> On Tue, 2024-09-10 at 11:33 +0200, Paolo Bonzini wrote:
> > > But actually, I wonder if we need to remove the KVM_BUG_ON(). I think if you
> > > did
> > > a KVM_PRE_FAULT_MEMORY and then deleted the memslot you could hit it?
> > 
> > I think all paths to handle_removed_pt() are safe:
> > 
> > __tdp_mmu_zap_root
> >          tdp_mmu_zap_root
> >                  kvm_tdp_mmu_zap_all
> >                          kvm_arch_flush_shadow_all
> >                                  kvm_flush_shadow_all
> >                                          kvm_destroy_vm (*)
> >                                          kvm_mmu_notifier_release (*)
> >                  kvm_tdp_mmu_zap_invalidated_roots
> >                          kvm_mmu_zap_all_fast (**)
> > kvm_tdp_mmu_zap_sp
> >          kvm_recover_nx_huge_pages (***)
> 
> But not all paths to remove_external_spte():
> kvm_arch_flush_shadow_memslot()
>   kvm_mmu_zap_memslot_leafs()
>     kvm_tdp_mmu_unmap_gfn_range()
>       tdp_mmu_zap_leafs()
>         tdp_mmu_iter_set_spte()
>           tdp_mmu_set_spte()
>             remove_external_spte()
>               tdx_sept_remove_private_spte()
> 
> But we can probably keep the warning if we prevent KVM_PRE_FAULT_MEMORY as you
> pointed earlier. I didn't see that that kvm->arch.pre_fault_allowed  got added.
Note:
If we diallow vCPU to be created before vm ioctl KVM_TDX_INIT_VM is done,
the vCPU ioctl KVM_PRE_FAULT_MEMORY can't be executed.
Then we can't hit the 
"if (KVM_BUG_ON(!is_hkid_assigned(to_kvm_tdx(kvm)), kvm))"
in tdx_sept_remove_private_spte().

