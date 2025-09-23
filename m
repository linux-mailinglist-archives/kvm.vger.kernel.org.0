Return-Path: <kvm+bounces-58511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E6A4B949F2
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 08:52:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13A5C17FB6A
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 06:52:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B59C730F93D;
	Tue, 23 Sep 2025 06:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nujROopX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A23D1F4297;
	Tue, 23 Sep 2025 06:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758610339; cv=fail; b=SDwgnz2HBTjPe4Mz7wgGyAOwjiq/7+XfGbcopFmxAg87et1uiPjo5eQDs0BBrzbuqRNEGnPEdE8bRRIDNUujCcaD0pmSEHc3YBz3k2NvYiS3pn7oYd9TS1fjJz0+dlDRzqEEAJIn/4cHBH1KT+S6noG/6Mk+2xA7Ux0HLAvsHFk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758610339; c=relaxed/simple;
	bh=FdEZZr1jH9CHcjlEdk9u5sVVdOj2arh6Mk1V12YbSio=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=aQihL9pKD105Kzat9o4ao3BbjvqlfdPRZ6le11HC/WSRJoqR9xSHq0uSjt4QSdLv9RoI1ayHIFFNulJrKRyEmGqZwDHU9Ql5syawAGMnHUlOwpq5g9GTxcCvoVM0UuxnhH+yFPnGVpA25u7pbZP8/u/4TlUBViCMZNLFtAvIwtc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nujROopX; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758610338; x=1790146338;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=FdEZZr1jH9CHcjlEdk9u5sVVdOj2arh6Mk1V12YbSio=;
  b=nujROopXE9W3QWvnPe/rjz3yaaIAx/0K1cf2p6K+19P1vwwVn7dZ6nJ/
   LnC+4+vXPiQ7M8kNZnl2d096hDq50TJQqSANHn3ZVpCxtC98gTlbQ7NrE
   m/bcotqXCvZrsmm47oL5Ml8RHi4jGapKSuM29sUbNy0oArOMBmpNxybaw
   UGX6qclQdLQn33hKK70yyS4/o/2LQ954CxLSnKd/8KY913HCBl5tFbvTM
   aHaakQUHuZBqeadgyxSZV+bLvFv2ursC0pIKMWxQ8MziVp9sL9dJBYIjW
   oO7GypKiKiuMlPLwckPxB+G/hshOHcz8koQLNJOkILby7XBw0swh6cCTb
   g==;
X-CSE-ConnectionGUID: ibaUvmjXSEOHz39NNmph6Q==
X-CSE-MsgGUID: HhslMNbxSguG+PWOTSx8VA==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="64707293"
X-IronPort-AV: E=Sophos;i="6.18,287,1751266800"; 
   d="scan'208";a="64707293"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 23:52:17 -0700
X-CSE-ConnectionGUID: r1YzkhF5SXe9sTH2w0XyAg==
X-CSE-MsgGUID: lr/mOLvuSeaL3Ow7QHTuDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,287,1751266800"; 
   d="scan'208";a="180981550"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 23:52:18 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 23:52:16 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 22 Sep 2025 23:52:16 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.5) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 23:52:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X32vssBLfEGqnCD1VE/slJ1A6hV/qIB8a08xKIJFJ4rpcSavMkpZVK5d8fE7YQMm55pvPBLZ2fRveyIsmluLnnPP+l9b9LoznXP3hqPZzXUW6Izf6RfShHDIXWWbiY7f91vmbi8ay+K9Pi+z/yWsJQVwvdd0wKCM1sRdOH/gJLChAj6014aS5chLauzXATAWruGPVEmEUbqNxkXOXCLwz/1Z2F/1AuuC8lI1cYzvD38fjiEvDMPGhZIUsuXmEc7pSMNBmMeCGGEaIFTnbgj91NR4Bn8z2Qqtm5sYCDT2DdA90PF4ASnC1YXVsHizmkQqsAKZQSCYI9JExS1VIrWjKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3isCQYug0XIQiDjkAsDr/9p3p2x5U6aipp8K+kyW0CA=;
 b=K6Wvi0jhgD1ew1tD7afJWPFxfqePETzQqswWx8Wd1UXM+Ottf6KDC9B8QTuFvIXha8dA+UR9dixQMRSLNlXBgOzlW3sE3wLvjtRy5cpNXRdcAFUGP/VrDgjpB6uRLtYT/bk5z8UfdLswytMma8NYJhOolMA9BEU9rFZNdjm+RoM1ZwS0PmcPU5YX79lep8+WwqlixkecA12p2pjfFV6e7wIO9vFBtXR90NAdd1oOsqr5xJm3g3ElRN9ZspoCXk66jfvEyMKczTO7xP+sFzyf3+IwOiUqFNR6q1WTFUIbK8UeUfJZ7xdOZYeSf5iFlMmOEFpCdZxkmnvgYjdmHc9wUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CO1PR11MB4818.namprd11.prod.outlook.com (2603:10b6:303:93::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 06:52:14 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%3]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 06:52:14 +0000
Date: Tue, 23 Sep 2025 14:52:04 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Binbin Wu
	<binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, "Maxim
 Levitsky" <mlevitsk@redhat.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>,
	"Xin Li" <xin@zytor.com>
Subject: Re: [PATCH v16 48/51] KVM: selftests: Add KVM_{G,S}ET_ONE_REG
 coverage to MSRs test
Message-ID: <aNJDlIgBus9ksYE7@intel.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-49-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250919223258.1604852-49-seanjc@google.com>
X-ClientProxiedBy: SI1PR02CA0008.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::14) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CO1PR11MB4818:EE_
X-MS-Office365-Filtering-Correlation-Id: 5969b59e-004e-4ece-67dc-08ddfa6dba93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?HpI8fSvncUtn7gLtifFehoeTr1dZWcgjtHWn+PE6gElATQB2929PGgONiZbI?=
 =?us-ascii?Q?gYvvL/2BqwTraQI+u+LWWxoyh1QkA+MCkKl3CwSjsNOMZtVe5gCil6XoJmYf?=
 =?us-ascii?Q?NTbQsslADvUJ7ln6PoFWXN2G8mVlWILUPcgB7sC0ZIxyLS9T2RR6NZAcbpqx?=
 =?us-ascii?Q?3eblC+Q5sEzzDA+AIgq9Bs3sZTc+hdH2PSYDoVg+yqJGIp/qGho8poP/wizK?=
 =?us-ascii?Q?aKIPbR/VWLrQTX0429vjArRPSzFpawANVZRUtd8uhX4SLmC1dutfIQQM44jq?=
 =?us-ascii?Q?Rtss+u8xWjM9f1RuLM1I+Rr4qdP4giFjhADXMN/ZHzBXRi2BCJhkvzJEA9Qu?=
 =?us-ascii?Q?XDW0RFHujhCOMqATZuc8DUDox9OnyM3V3QDEU9lsPUCU2dk1qmq491s6o0gP?=
 =?us-ascii?Q?COYGOCDO6yLcLlTEICgDuZCtU75lTEgg2onohgniRiYdGbF+Fz2bEgr2tYFk?=
 =?us-ascii?Q?hOBC1V6O3LNTeCTQl83oYEVweiWxNV8RD+ng8ccEvGnPo2v3IkTEsi7oobRq?=
 =?us-ascii?Q?WU2+HpskPgg3c5OJaHa/aCDzIolevp61E7ZASXrada8N/soIK4AOHa8y5nGM?=
 =?us-ascii?Q?ENGH0fTKjZwaJ6QmJP8eYc1eAFLvRdJfkh4Rgl+ab1KiS79iHenEBHIb+8lr?=
 =?us-ascii?Q?3eDaBVYvkXuVIsG9q/tjEV1HyvRIVd9DAWc2whHIaTimkcSl0+frcmx0S77w?=
 =?us-ascii?Q?n9moQqPGNuV8CSe8jzW0zqupDokP1keal8OQOkVLgz7itCgPfPX8IEQMNQUP?=
 =?us-ascii?Q?WPNF7FrW9DQS0UV9Ao0xG/2DQT1o+1w8CByXOn4ZWTdOm2pMmGyQJ9XyXxp5?=
 =?us-ascii?Q?aK8bT+x9xNjOl+uYX4aG6Y7MwuBYZU5F2Untb9apF3msu1+VjK4rT0olQt+8?=
 =?us-ascii?Q?zoSha/Gw1cUzNSaC27TKrHWELYfBBI4JcgeEopgSZ1ecskWcXzg/vpGXWzVf?=
 =?us-ascii?Q?1AR/sdnAAX8aUZZeRdNZBNSG4wF884Ob0TEl09T3SeGszMZYwPNc+JaP+kiF?=
 =?us-ascii?Q?u+xGzAIo9x/VKMgZ6ptsgNlveHH2uX7GhbS3nsGhRFuCo7E8qh/M9Xt9pDXI?=
 =?us-ascii?Q?+ycPtrtMEXvtkjmnQo5MC2LfzUKJbOeXOwe8S/AYUDUtUsBzFgtwt7wsvACd?=
 =?us-ascii?Q?6SYyN3thY3Dm4gwlvabjHy65R2fgsnkX/MWCXJ+rIR9r7XwTbh7mdj+Hw5Mm?=
 =?us-ascii?Q?XHEdLrzDE/b/JT3IZCrTzGMZy2uhhUjBfmLlfH+pUBkgG1g9ZfvuBiKBPUSC?=
 =?us-ascii?Q?vdXz/DXkdb+TczgHjepjh1JVq2RU2X6jynTDTCShBrlFPyE08WD7+bKw82L7?=
 =?us-ascii?Q?ypOcdg/DKIuWvcoMbGDZj978NVFkr/x9lHowyDO2pxw2eCE75FMHxqaMPWMQ?=
 =?us-ascii?Q?Z7Cge+jxgIYNEraCc78KjfAPDqqQEILUfcH+vK8bUWA0UI97sqnZFoc8DYqB?=
 =?us-ascii?Q?wJocA/ASpC0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hJvkCFM/xj/XuHqS09fUbT/RtokW1fb9rdgTaeMaMQWjIWKkz7afH7tbV2oJ?=
 =?us-ascii?Q?IoeDpSNrfnRuKf/2jZJNQfA0tuNPj8iZmVoiJjKsQ3DOU/BnGynXRF/REnqo?=
 =?us-ascii?Q?DC5XpbGaeT4Cn4BwXSEQDFeY+zCoFa95QKfD8O9hwawq5oux5klY3NhwB/Tk?=
 =?us-ascii?Q?5fUHFbb8araPd5YQwKrqA33HSJlBjA2mH53OdAfzUigHSkadmrcKENYiUJbl?=
 =?us-ascii?Q?Nd0ETUprln1THR0E9JfI/vCfwAGLvS/jTNoldm4GSnud44B4T3L6I2VXq87i?=
 =?us-ascii?Q?EhytJDLnEXVlloYpEXdfHGeiVWa4PsUrgwjDypJBm1sfYfWjPxcn8ZBSwwHC?=
 =?us-ascii?Q?VISbVYjgyQXclFHHpSK0C6WrHmxSFLfI4dD8Is++FzRaGq/sSqWe71oHBL07?=
 =?us-ascii?Q?9xot8+EQ9LExnyon7Tdad/EY6QTT/yRqUf9UuOYw3nu5WgD8HrIJ4whBQRIF?=
 =?us-ascii?Q?6cK1E1VHiHZwS68Cp0w4y6b7ZFYk75ycZYWsCX7BipMxgF4uyGh9xx4a9yGt?=
 =?us-ascii?Q?ObnLiN4GhSTz9YNUKkmawClXe3NmmU8SXl1BlszFPk/Ky8bqPVfu8aEeXWhk?=
 =?us-ascii?Q?CIA1M3J+iZ14bF6uDJzqsScJHtyQ1XyM6BpBWE23Kz9I5fNe+3bh//ue5Ni5?=
 =?us-ascii?Q?uR4w61GPw8wuIQtDwfZpe8RPgJkP0uIeK9u2x4BDAJH3fdolDdFPRBvkAM7v?=
 =?us-ascii?Q?5B9QWdXblpoDco8lLMOU+YVNx0c5+mjm6DBobsNKpA0ObRnfuMgO7n1s2uTw?=
 =?us-ascii?Q?KrKLXcGXYUNMuy9sWnqX0MbiOUQlKET9BsCA/ofswCMtT2zyRe4v2biX7rQc?=
 =?us-ascii?Q?DT6V3m2yqzNI/cxaCijE4QzIkdhDnmELeyaETbWgDXk/J3itqgHhxLGu2bSx?=
 =?us-ascii?Q?CB4VlxXcq2Mrrd8+IBD/X6FNLcUmS9e+cm0L8TMrh0mth4tXIq76SBL9yrIC?=
 =?us-ascii?Q?kJhW62Q/tY+pdVWV6vws/izI5oRklfO7TSKucu/asw7Otu+rz3NgkYMaDlbr?=
 =?us-ascii?Q?yRjtDF4xC5Nec3yeklR/q0KZm8GzYqtihL7T1Ccj3Pc8yCjtit5GXXebnG6H?=
 =?us-ascii?Q?Cu0VimfVGBAUkZ9wCafIgRay7EMCfyuel3n0KEU3J4jzgfpmt6tv4vaYoQDp?=
 =?us-ascii?Q?UBOFZ7WXipNWDm7IulBmCa0p+AygeL/gEL9a5R3q9mDG9Sxn/D/zyC2i9oqh?=
 =?us-ascii?Q?2TgC+adTmENyBSDWUiMTC7nH1w36V7c8Hqwz7HzaOHFczmLh2SmNPoOfkw0x?=
 =?us-ascii?Q?t9zOjG92fbKLu9v21dB2bORHrm8ij6JzHEiIDSGsnMdj33qMJ0cZYV0/r/Yi?=
 =?us-ascii?Q?mi5S/O0reEO7fn6dGw0TBSf3iSulrsKJVQKin7L34bSRlYtAhhiQmr2ejl3G?=
 =?us-ascii?Q?K2syF2c291RS5F/TnyCZnBIkXkEAX+uomBZ0YqJ7fkbpPyCU8zkNWeH0vc88?=
 =?us-ascii?Q?MP6WojvCURqvTxr3QVGeCnJLCd7SZEfL+/LBg7BYbcu1T9r7g++HhZhLttTw?=
 =?us-ascii?Q?KQeviMw56/2O+qyuRbRgWpySF+FFx7FRC6N4wq8gE/rL9svZgg1MrYS6Krsv?=
 =?us-ascii?Q?6qYg9mNvWRiTp7SFtTGsyQSXrZNRKtSZeXcFTyBa?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5969b59e-004e-4ece-67dc-08ddfa6dba93
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 06:52:14.7488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gbPnoVQp8EkCmYF2sljpcRGvZxJS8l1gIn7KD8KAqlw59bEQYz0aU3O2pEo9Sm0lxScYmcMnGZpF1PsyFLXaBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4818
X-OriginatorOrg: intel.com

On Fri, Sep 19, 2025 at 03:32:55PM -0700, Sean Christopherson wrote:
>When KVM_{G,S}ET_ONE_REG are supported, verify that MSRs can be accessed
>via ONE_REG and through the dedicated MSR ioctls.  For simplicity, run
>the test twice, e.g. instead of trying to get MSR values into the exact
>right state when switching write methods.
>
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

