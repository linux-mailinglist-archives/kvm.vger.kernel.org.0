Return-Path: <kvm+bounces-35610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D4653A13037
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 01:53:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0F6A3A454A
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 00:53:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B5DC219ED;
	Thu, 16 Jan 2025 00:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AbH4uQLL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A0C182B4;
	Thu, 16 Jan 2025 00:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736988794; cv=fail; b=JPb1HPmTYH9EpHjujY/hsooqwZHwexUI9ipguqpq3e3+fPLFiJFE32vA5HQBmS2gs/H/Nyzpt3l9g5OTDOomRSZLCcCauzzp0jNJgRB6QRSTMiWDNSr+NnbxqpyEZuXLe0CCcEkCM2NMWHvC2nbgxU3lOoPXzq1XOeawfW5MUUw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736988794; c=relaxed/simple;
	bh=1LuDmrLVTd6vvSsqSTRiKuA9ErfBUi5nNV/l2XKmo8I=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BeauwVgGsLLKkpVkenowQcZgiqQdglUNPc4avMojCXUJ2656tuvSq7U474aXtpqL6YJxycZj5f2dDpiCayRu7oM4SbJ1IRXLCGMytP6p6qCTCQAto8s9B7oRi45LTgbdEamMo4dL1v47a4r9cDADd/e36bSn9BfunG2Ugpz/ftw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AbH4uQLL; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736988792; x=1768524792;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=1LuDmrLVTd6vvSsqSTRiKuA9ErfBUi5nNV/l2XKmo8I=;
  b=AbH4uQLLOIl8VBH/7o4nPywQa1TNCNk45TWBXuyCdFa9LRfyX3NwzcVB
   5Arr6ytQBsb/O6wmoAvu+bFM2EA0E0SG009wnbKNw/Ne5916Zs1yMljyd
   SAR47Lz/aVbxlBeuGhEWYKnMubqjEGi/2FxFx1K6LFvHzndOgMRQSfSsh
   Xoi5b5EOyyugWtM1CHoepj8JO6p8LX6di2IBF/oXbAGxRM0byYe6R2ai2
   kSg+mzEojqq5/MDvqhTt6hYubL0yoOQKNlww2YwS8OmSQh7CqQaBhsZML
   W1DGvOKLVX9kAXzj1Ak1qjUCqbqlMjQD3Xesueqee/d+3NlKZ9rGOQH93
   Q==;
X-CSE-ConnectionGUID: YbVy6qMvSlOsMnXj/hPs7w==
X-CSE-MsgGUID: WD3rEsSERUGI4DCi4qEsUw==
X-IronPort-AV: E=McAfee;i="6700,10204,11316"; a="37577166"
X-IronPort-AV: E=Sophos;i="6.13,207,1732608000"; 
   d="scan'208";a="37577166"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2025 16:53:11 -0800
X-CSE-ConnectionGUID: DRjF8t+KSqi5WBm7Q3FAww==
X-CSE-MsgGUID: 0l/PfdAqRSqEKPuAU51wNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,207,1732608000"; 
   d="scan'208";a="105896275"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Jan 2025 16:53:11 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 15 Jan 2025 16:53:10 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 15 Jan 2025 16:53:10 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 15 Jan 2025 16:53:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nzszKtEg3rx2mniVpUNsGvk0FdH/ADAK4K/H8hwCCNYyQUeayv5rlYgDFg7GkXNAHwaCSFQilXCK7rvUSZ0Et1pC91lf6T0Fla0fe7+SpFTfkGVwx3yYLTJ1h4f7lAWoGtBZznUdMlLqCX8U8MX5BmTrgNb2rNqA2qMj3At5zrbSNJ/Ks3+hdrEKYnn+Zj1GVza830S6m6eWs09UPzadoEPP/wRXpO3o+30gdfEJ2PMBIDYi9guki9l54vGqgMg3N9cXXGv+QW9QIsx6F0VwXGLG0JBCGAbuyf8FTIgCVwT63AGeGiBkuRNKQjm71CXS/A7lPEHWs4F7z3anRFZ2qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3YGXqI3bzjfRBAA2nGkb4Gz5yZzGEzgrC+cJsPy99bs=;
 b=eUyazRNmJqVxqBWHIoAp92oIm/2sHL980JhNmAZ3bhiYZhVt+kqZRe5enYDhCN5G0LwiaA0QcteDHWlTGwBl/jw4/x6OTE0Nqpt9+vIPxvlRXW8bj8rGbdN1k57ZgVUtHaAG/kubaVnb4dKdGB/ZTpIBXs922qqGI6TqD2eIBuVlA7+R1bVMyVQBguRUG7RwYpXSZzL3Ei/J5zbn2yIxgjv2RsuuBqBFLxNL6fGDcZyB/ZV1iHPFZLLmPYgC+hUejDoHf5fNlqExmFcJVPFeFtg1VbGwdrzWCGDd0r2751yGtw+Khkac3aK2WcDcslJ7E3kWsB7lkEVI9EqasJqMUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM6PR11MB4673.namprd11.prod.outlook.com (2603:10b6:5:2a4::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8356.14; Thu, 16 Jan 2025 00:53:07 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8335.017; Thu, 16 Jan 2025
 00:53:07 +0000
Date: Thu, 16 Jan 2025 08:52:10 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <seanjc@google.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
	<kai.huang@intel.com>, <adrian.hunter@intel.com>,
	<reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@intel.com>, <binbin.wu@linux.intel.com>,
	<dmatlack@google.com>, <isaku.yamahata@intel.com>, <isaku.yamahata@gmail.com>
Subject: Re: [PATCH 0/7] KVM: TDX SEPT SEAMCALL retry
Message-ID: <Z4hYOviOCaOcpxsw@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250113020925.18789-1-yan.y.zhao@intel.com>
 <cd099216-5fc7-4a79-8d35-b87c356e122b@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cd099216-5fc7-4a79-8d35-b87c356e122b@redhat.com>
X-ClientProxiedBy: SI2PR01CA0012.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::8) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM6PR11MB4673:EE_
X-MS-Office365-Filtering-Correlation-Id: 99bc52bb-7edb-47c3-0764-08dd35c82457
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?+QYe9s3NKDjfZXoOp9ZQ1C9S2IBVyL21ry5/v2izg9iCXNlQ/z0w9B3jkRp3?=
 =?us-ascii?Q?N6bPaj+Rq+RBO3iEEQsya2n38Y2j44kQOsnhK+TafmlfmEM8UEJ0sxABl1dZ?=
 =?us-ascii?Q?qfpVFKNuuEvBtvZkRlnP1InALkvnOfx6YleVzeAqWUa+1T2uqiJ1LNWPKewc?=
 =?us-ascii?Q?KbSkaQYg3zX85Bux+57TidGJ5Y9myFB1xy1G0e9N084FwEunQ5bXjYTYijXw?=
 =?us-ascii?Q?FV68GCcyQ7bbNG4cNf5/ukUvsqEUs2GRANivhixrXm+EOwQQgdIXDenqNyeR?=
 =?us-ascii?Q?c3xk51AdHBkX2O9ARN3XMzn+O1TkK6vuS5nuj3Dg1cP0gfTFvTRRXaAz6f0w?=
 =?us-ascii?Q?IXvV/z0CqfUj8RS2bltjdp4I1HG6nWlSzik1HB5wf7lRygHTPPYwjuf4gkxn?=
 =?us-ascii?Q?MrN5SNhkVvuFlgBoPTye5FbMsvUuQiLi916OnIHM0BS1ocIuWIr2A01O4keS?=
 =?us-ascii?Q?hOMoESDF7nXNIimjf+ID5PuVvymaYXawa0jT8B3fDzj7TLGt9rEne0fB9aZ9?=
 =?us-ascii?Q?Ra20tOKt5Tf5f9V5WjketsSQIPqNfmXftXBKQ8WifgV3hPHelUTlW+fMSP2S?=
 =?us-ascii?Q?+FJ0x/aVogTJW1GNmzN0HmM9/197J/fv9TehUjFFuDZJ6Iva+7tUVWZSxP7b?=
 =?us-ascii?Q?W1K/RoIyzwTd6Sdo0P+ULGzmqKhsMfir+9/cokdoRTwnsOH83zYkYHN6OJOS?=
 =?us-ascii?Q?s887KHpqsYTBi8yvWE0geDuqaEdOLwW7ot7++yuWsN65O287oGAWAp/FvuvS?=
 =?us-ascii?Q?jeMnI5XhoMOT4sD8z4Rh/IJWDtRlF6G2d0afEB6tRi1RHFNjJwa+BO1aIdyj?=
 =?us-ascii?Q?7zneKrxXRb5vCNE7JOqn6JUiSt88pNkttEIATky1jPNj/AhSv52USM4KdBl2?=
 =?us-ascii?Q?jESB59bl8hsam2LVYPkgZoYzMDvYvd5UdBzqodAv/EYwbZHjnZyyv4f4jd8E?=
 =?us-ascii?Q?8JsMVa2WcogBCtUoKyddWqpM7vOKc5MsfFkJJjPXs8Wx5xJnIrfVJx3sZLHD?=
 =?us-ascii?Q?ec9md2Rnu0Yp2/ScPOXTah9nVgnPf8AH4Qou4ZE1IwbmEdwpC8J84wYEAFvo?=
 =?us-ascii?Q?jvFzaafYN/f/Ce0xTUMZqskpTRq1aju3XMHswh+WKMIFV3lFTfmVoC9IZzYu?=
 =?us-ascii?Q?ukk3H492xSpYRUW7/Bsg32sHQMwyiG+PbcnG5ge78TImNweigJ2W6iezTrEb?=
 =?us-ascii?Q?w8VHxR3Y5vn8BNjF9aoJHthEX+W8gcJjuiFzKpqAaBRftipEvySc0i6i3T1I?=
 =?us-ascii?Q?Osg0IlnwtlaSZi74D0lppMbCe47KEA/Hfv9/Bs/aSjF4kNEuNO23k6gm/u+H?=
 =?us-ascii?Q?c2GgataHGRWLblNAVwse642/P606V+4pGARVvBajeFKrYg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MZS+uMh0qePANhqhEv9oMX1Q/GVy7ZkG2cqg9PVZclGnl7jZYVJWZx7f/kOo?=
 =?us-ascii?Q?LaSNRV3saIP1GH9q65Z1cBOH1vOZTF1+CArvOFkPFwBK6cNq4ciyOzk1hD5E?=
 =?us-ascii?Q?RHuR0YnwRSIWtIMXXjzBrFSxfaOEH3dxhRYEgWDXz0TIMahlTIhZqK7eb4gG?=
 =?us-ascii?Q?ubxHHoEoIrEaTWDrHuRzk1J2bk3ood3mSn9zaQnRO+IB8YGpRQxpC3uwtpcR?=
 =?us-ascii?Q?ICbggK8Y+nC8+3SRoCw21WpyMcICJ/23ivyasZ52AEN+/pdbmKf6ZgWPMjt/?=
 =?us-ascii?Q?ivJJk4dwMleV0KW9SjyqDyoEDXOk4WCW4GTqkAx+5l6HLDp4RQKLRFvZn8cE?=
 =?us-ascii?Q?pUEHtcNwDB5EcxZuyPtBacj+UI0tvo/UvFdYDktUVfEHv0tYRAIpFQ8g6RKX?=
 =?us-ascii?Q?jNkVd8Jy/GgvBC7gi+jMezpze/0U3+ziyzCqKuhkUD4VEgbMo8z0SzYpWFeL?=
 =?us-ascii?Q?TKSGYWNZbY6i7xeibTja1cpPFMhPMxyAf7C+AG8lqzhFBMnzvdh7+YMvGw9H?=
 =?us-ascii?Q?TLEJ8PXROM8dYLy+vnzdX3r0BrePUQbu7+9ryVThsI2qovp/598GKDr678f3?=
 =?us-ascii?Q?DvhEv+83k/uX3/Yg7YZk21bWypg+M67Bfr8+fLnOvKuxrXOb/AxR5hVysCB6?=
 =?us-ascii?Q?K4ttdKgwdaGqsrYYW9j1c3FdlaazYieE3W7qQMFL+pV8zeHttcEIgp7ohN8m?=
 =?us-ascii?Q?oXRKUh8aCqZ102gVnSwBcPwl5EmiiyQ3Eq6PTUUxdkJvcRI3ljgktzfUMJhp?=
 =?us-ascii?Q?2FKD9ICtnqkqX8Ul+jGAyjie4yhu9TQPTsVsCuXOp4njKeahhyN7cI+FuGor?=
 =?us-ascii?Q?SFHfALZV+OiqbedScwneUaLI5Y1BGwu34pZp3UG2AytZBkb1RHx1OLRcDUvh?=
 =?us-ascii?Q?u+u6e4wpChH6zytZKU+RIZ7YLLWHSmfcos6UR/sC0lYlvmR7nNsj9clr4zvw?=
 =?us-ascii?Q?lqbtOkjZxnmi9ZXXCv/4oWfDeLCN3xVbqx+PllWs/flvAvEWlDWSH0+lnDD6?=
 =?us-ascii?Q?F1voo/dB2PXqUnCZcKCDDtXE1S/Tff/Ibrvoy7M7Gc4W7f0wrnhnE+bvNvll?=
 =?us-ascii?Q?C+GHRfah/8bW+gtBKGzsWmvM+Zk9ZXpreu5cCaeKN1GSsO/03B0aU0DLkvsr?=
 =?us-ascii?Q?FeYQOX2XdAW1lVspSNkj4oDV4tMWW2MEx18qCj8TZIHUu5UgeWcgQ6h9dzMU?=
 =?us-ascii?Q?wG6tuwUmDiqgOE3nu2BiCJ9V3HaLAukuCCW0bKWAQk9xMULjako77qu9sIOB?=
 =?us-ascii?Q?lMB7qaqEOXkCXnZRm/Fz0WOu1a/JvlTDpsR2PdsZYBhLzzJWgK5d9tvc0UFE?=
 =?us-ascii?Q?d1urQjLBG32ubTjrJ5qWzwN2cea7SnN7qmdGofOrbJX9GM4MJQPOf/pYWgJy?=
 =?us-ascii?Q?rPBDIVAd6zh1nWfIUGKDR4wRx08gdxlIlHKWC16ompEX9kEUL9hR2+d/ttvw?=
 =?us-ascii?Q?VWTAtRgewmk1T/TU3Ko8x3dPgiJ3OQfg4gKMAQ0dMO7txEr6tGx7ZPFJKJvu?=
 =?us-ascii?Q?XmzL42s1LU/XvpR32fgQ9o8uZs9VM7WGbJ2NALLpkx5ioOT9jNiZZr4H0/RD?=
 =?us-ascii?Q?EzID7zfuNqZy3+fdUIHMUO4oa6iyfGmOvtIkF0s3?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 99bc52bb-7edb-47c3-0764-08dd35c82457
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2025 00:53:07.7527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PIDxE7oAXmavZmgSS8uNOzDbssfh9X6kyNdMV7hWi+sBe9R5uY08ka/PQYCroWtsxqvEJ+giFeAfYWpNm0hbEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4673
X-OriginatorOrg: intel.com

On Wed, Jan 15, 2025 at 05:43:51PM +0100, Paolo Bonzini wrote:
> On 1/13/25 03:09, Yan Zhao wrote:
> > This series aims to provide a clean solution to avoid the blind retries in
> > the previous hack [1] in "TDX MMU Part 2," following the initial
> > discussions to [2], further discussions in the RFC, and the PUCK [3].
> > 
> > A full analysis of the lock status for each SEAMCALL relevant to KVM is
> > available at [4].
> > 
> > This series categorizes the SEPT-related SEAMCALLs (used for page
> > installation and uninstallation) into three groups:
> > 
> > Group 1: tdh_mem_page_add().
> >         - Invoked only during TD build time.
> >         - Proposal: Return -EBUSY on TDX_OPERAND_BUSY.
> >         - Patch 1.
> > 
> > Group 2: tdh_mem_sept_add(), tdh_mem_page_aug().
> >         - Invoked for TD runtime page installation.
> >         - Proposal: Retry locally in the TDX EPT violation handler for
> >           RET_PF_RETRY.
> >         - Patches 2-3.
> > 
> > Group 3: tdh_mem_range_block(), tdh_mem_track(), tdh_mem_page_remove().
> >         - Invoked for page uninstallation, with KVM mmu_lock held for write.
> >         - Proposal: Kick off vCPUs and no vCPU entry on TDX_OPERAND_BUSY.
> >         - Patch 4.
> > 
> > Patches 5/6/7 are fixup patches:
> > Patch 5: Return -EBUSY instead of -EAGAIN when tdh_mem_sept_add() is busy.
> > Patch 6: Remove the retry loop for tdh_phymem_page_wbinvd_hkid().
> > Patch 7: Warn on force_immediate_exit in tdx_vcpu_run().
> > 
> > Code base: kvm-coco-queue 2f30b837bf7b.
> > Applies to the tail since the dependence on
> > commit 8e801e55ba8f ("KVM: TDX: Handle EPT violation/misconfig exit"),
> > 
> > Thanks
> > Yan
> > 
> > RFC --> v1:
> > - Split patch 1 in RFC into patches 1,2,3,5, and add new fixup patches 6/7.
> > - Add contention analysis of tdh_mem_page_add() in patch 1 log.
> > - Provide justification in patch 2 log and add checks for RET_PF_CONTINUE.
> > - Use "a per-VM flag wait_for_sept_zap + KVM_REQ_OUTSIDE_GUEST_MODE"
> >    instead of a arch-specific request to prevent vCPUs from TD entry in patch 4
> >    (Sean).
> > 
> > RFC: https://lore.kernel.org/all/20241121115139.26338-1-yan.y.zhao@intel.com
> > [1] https://lore.kernel.org/all/20241112073909.22326-1-yan.y.zhao@intel.com
> > [2] https://lore.kernel.org/kvm/20240904030751.117579-10-rick.p.edgecombe@intel.com/
> > [3] https://drive.google.com/drive/folders/1k0qOarKuZXpzRsKDtVeC5Lpl9-amJ6AJ?resourcekey=0-l9uVpVEBC34Uar1ReaqisQ
> > [4] https://lore.kernel.org/kvm/ZuP5eNXFCljzRgWo@yzhao56-desk.sh.intel.com
> 
> Thanks, I applied this to kvm-coco-queue and patch 2 to kvm/queue.  It is
> spread all over the branch to make the dependencies clearer, so here's some
> ideas on how to include these.
> 
> Patches 6 and 7 should be squashed into the respective bases, as they have
> essentially no functional change.
> 
> For the rest, patch 1 can be treated as a fixup too, and I have two
> proposals.
> 
> First possibility, separate series:
> * patches 1+5 are merged into a single patch.
> * patches 3+4 become two more patches in this separate series
> 
> Second possibility, squash everything:
> * patches 1+5 are squashed into the respective bases
> * patches 3+4 are included in the EPT violation series
> 
> On the PUCK call I said that I prefer the first, mostly to keep track of who
> needs to handle TDX_OPERAND_BUSY, but if it makes it easier for Yan then
> feel free to go for the second.
Thank you, Paolo.

I'm ok with either way.

For the first, hmm, a bad thing is that though
tdh_mem_sept_add()/tdh_mem_page_aug()/tdh_mem_sept_add() all need to handle
TDX_OPERAND_BUSY, the one for tdh_mem_page_aug() has already been squashed
into the MMU part 2.

If you like, maybe I can extract the one for tdh_mem_page_aug() and merge it
with 1+5.

Then since 3 depends on EPT violation, for the first, 3+4 can also be included
in the EPT violation series, right?

> 
> Paolo
> 
> > Yan Zhao (7):
> >    KVM: TDX: Return -EBUSY when tdh_mem_page_add() encounters
> >      TDX_OPERAND_BUSY
> >    KVM: x86/mmu: Return RET_PF* instead of 1 in kvm_mmu_page_fault()
> >    KVM: TDX: Retry locally in TDX EPT violation handler on RET_PF_RETRY
> >    KVM: TDX: Kick off vCPUs when SEAMCALL is busy during TD page removal
> >    fixup! KVM: TDX: Implement hooks to propagate changes of TDP MMU
> >      mirror page table
> >    fixup! KVM: TDX: Implement hooks to propagate changes of TDP MMU
> >      mirror page table
> >    fixup! KVM: TDX: Implement TDX vcpu enter/exit path
> > 
> >   arch/x86/kvm/mmu/mmu.c          |  10 ++-
> >   arch/x86/kvm/mmu/mmu_internal.h |  12 ++-
> >   arch/x86/kvm/vmx/tdx.c          | 135 ++++++++++++++++++++++++++------
> >   arch/x86/kvm/vmx/tdx.h          |   7 ++
> >   4 files changed, 134 insertions(+), 30 deletions(-)
> > 
> 
> 

