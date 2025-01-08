Return-Path: <kvm+bounces-34736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CF866A050E6
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 03:35:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4ACD1188A268
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 02:35:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A09D175D4F;
	Wed,  8 Jan 2025 02:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ID59PEhi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B563134AB;
	Wed,  8 Jan 2025 02:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736303724; cv=fail; b=lsuM6WIgzcjrjWhAgC2i1/GvpzMxb7VfwRW6tV/jpjvS8di8b7UaU4sOsrVWq0bTJj9Mh7oDp+epwVbZ+YTUdO8LGZmvTp1PDh8axRy35Sys89L68LylMmZiB2EsgKvTg/2CJbJ+/pX39Dq9wmuqnqIr8m/OipFHfKXndFt1ku4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736303724; c=relaxed/simple;
	bh=QE8YiC1KWSv2LsrI2sU+Q6lJgADSEYi4pP6XuQOeGjk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KqyJJZ9NprN8Bky5CCfLPbSSj/xyIZGZuXhCiEIZMJtDAQRJ/fxhiuqtA2Z4XUt0HvMBDvRoabOvvHRvRt1ii2vHrVpXVY1nsPQtkzmnXS5765XedWLHoKEMd51Wv6w0+HsleKNGeG8i+y3w6fDfjMesinpsZe+TAMf3Fru2/gE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ID59PEhi; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736303723; x=1767839723;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=QE8YiC1KWSv2LsrI2sU+Q6lJgADSEYi4pP6XuQOeGjk=;
  b=ID59PEhik1d3aWooVS725qDlBLxsa/Qxv65ZZcoPy/FjA69/FvjMc40Q
   /1OQOyfsXJr9SI3rw3CZG7VJGO7GmmFQteTuvzTsc0u10/msm80TOhPh8
   VbJ0Umpw1VTEntDF42+bhE6NqZ2dYlttqbBRo1IhxhMbUbESvGaGlQx1K
   2VsNIS/Y0OxPKXf3eIWu+5xf2U1Kmo7M3KQ37IlbwOdHWZrHSxLfJ6iih
   dL+Nz9tEHLUGuPNKWzUFHxnHYABJZlBM/Ofyce2jWGREvvZsbB2vr6AOV
   FRIYh2F5nvS/Ba5Ab6QV2nRcYikcV1jNn3NY4n5Ql0CW4Jt8QhI9r/AgD
   w==;
X-CSE-ConnectionGUID: 7BxARkylSk6dbXWHNfq3+A==
X-CSE-MsgGUID: 1MCRqJsbRT2OvZUGSkoyXQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11308"; a="47929300"
X-IronPort-AV: E=Sophos;i="6.12,296,1728975600"; 
   d="scan'208";a="47929300"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2025 18:35:21 -0800
X-CSE-ConnectionGUID: AR3/58PsSXuAh+IrpNDNsA==
X-CSE-MsgGUID: o6BlfJEgQtaH5CmcJfVp7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,296,1728975600"; 
   d="scan'208";a="102865748"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Jan 2025 18:35:08 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 7 Jan 2025 18:35:05 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 7 Jan 2025 18:35:05 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 7 Jan 2025 18:35:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oPGRnZPzp7bqfeRVkQpRGUNDePoTW1VQKqVQmCyAg/EHORYWe005ca15bt2J+/F7YCPccOuJ8lXM4MZ2FqnmhegaX277BWWYuM5SlfXKXPZhA3NHqREaALPFVvV39bHqxInVPCj+Z31AXzlDhsDKOoQ5hsmFa7KhDw1Cta9WG4wpdjUSN1qtgpFQLOvCPJcF1OxXN6iP2SqRBYY1RyCqXMptS92QRr/qgl09IG+4FS4CrAkC63Sz4dnMoPSi4k8BgSJeY5Vinc8/xFLZKFOmvkDlMT939bcrhawD9b3Eee8WUu/HP/I/POUdBlhvtX1kxbKlR/5t0zAiIRQFwlQrqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3HQa5MBf5Wd0p4fBNvIu4yhS0n7O70f20tmuGkiOM3I=;
 b=aOg/KN4Y2ynDsaYtw9kCuaoPGStFXHQb0Qot7uESCOMGn1gTQwMQxlvGxdKtEHG2aCeLJDQuxSomWLJANzyniItu3nSb7C5S1NeshbF9dfGFHBPpzcP1dB3ijKu99rNnOYABmFIOqK51AiFosLjZFwCZeyaZXK8LkhC1jr0pgp6kMAMq9Ivw6cFMQlMtcU4g5hWb26cr4qz+QyyI/4dVhByPTp900vMaZPDKzn/6WvM2nzog5OhTXC1N+4R6Pv8F9jnyC1UWR99TYz6CGrpRMiHkRMSU4mJsEFuLY7ISTIGs5HUi33USLI+9Z3kt5M5S3tfg8DuPlsnzHBaZDIsaAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CH0PR11MB8235.namprd11.prod.outlook.com (2603:10b6:610:187::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Wed, 8 Jan
 2025 02:34:22 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8335.011; Wed, 8 Jan 2025
 02:34:21 +0000
Date: Wed, 8 Jan 2025 10:34:10 +0800
From: Chao Gao <chao.gao@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <yan.y.zhao@intel.com>,
	<isaku.yamahata@gmail.com>, <kai.huang@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <tony.lindgren@linux.intel.com>,
	<xiaoyao.li@intel.com>, <reinette.chatre@intel.com>, Isaku Yamahata
	<isaku.yamahata@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v2 16/25] KVM: TDX: Get system-wide info about TDX module
 on initialization
Message-ID: <Z33kIrc8/8WOn3sL@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
 <20241030190039.77971-17-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241030190039.77971-17-rick.p.edgecombe@intel.com>
X-ClientProxiedBy: SG2PR06CA0249.apcprd06.prod.outlook.com
 (2603:1096:4:ac::33) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CH0PR11MB8235:EE_
X-MS-Office365-Filtering-Correlation-Id: 593d82df-116d-4c6d-94e9-08dd2f8cf564
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?LwaT2LhSG6XC3RlLT0J0YMsHtJQffbk9SNvSOCQpOxqRra+MazAvXMk3mUkg?=
 =?us-ascii?Q?d5QPP7MHQ9064EVNyLg/ami1s8g5HRchc+fXvjpy6pogMVd1BnhQyYWQbhK5?=
 =?us-ascii?Q?70w0DZ/IsgBqmTbOgDpwr6/OerQ35nvCoO4z7AC+H9yxMo6uotaRZUVP8OKo?=
 =?us-ascii?Q?sR30Z3/B1ih9ll3XWrLhmMDyMHKKnY9TzgVMKdLSIDTLnAIky4T4GRxjZeav?=
 =?us-ascii?Q?Zou04J2ke/pinuyOSl5Ds1BkcO4U+k/BezGO4tvVuwKSZRtVzGkTqukkGsmF?=
 =?us-ascii?Q?xEg2OVaff4C8D4irVsR96OqgYZlz87UHlDluhabIESOS0wnjYOEPN8LUiXhD?=
 =?us-ascii?Q?VE9JOE8aJIqU6+uv9VjK1xEnhVewfirmlpuN/C3ibsD24SIziUpaBWuPfJi1?=
 =?us-ascii?Q?HRb78j0E74w34cFGwtrLC+laJJ+g85emqKhUgHjyDj0jDMVebFZhF1ZZK1WU?=
 =?us-ascii?Q?4mM/CkHwzSIPvozQTvwXRQqYmN5WLZklcN62USuAPo3c98r1vAl/8NMkYsu5?=
 =?us-ascii?Q?b2dfYfhbA4z+6gVTgKED+l/vgXxgDvz1w5+/DF2tFbSnvyoa0WEMx6fCl31q?=
 =?us-ascii?Q?vPru63FpLpbQLusjlYCa41gd0/hecFm3IeAgMXg3/0PHKpoVjJHZscWKvpAD?=
 =?us-ascii?Q?pRNaVbl9J6CByDuPzq0yjdwYJr2aWn8Gy/44Wzb4/Lat45xfiyTppIgyDH2g?=
 =?us-ascii?Q?VbBcoTtQyurx7hUBYN9aKZHOSQNYcfBXtgGNbw9Nw3mh1DkSRNeVqT0D4TL2?=
 =?us-ascii?Q?hePfSDN8uHhc6FTW5N1J7K5gy9sGE+r3I1DxSIGkbYb7VyCUT4NsEWQYBwxt?=
 =?us-ascii?Q?fbgDPSB/8q9DN8nG6tWkc3ZESy7cI2t+du9ztewq8aGGEIVpm1tsDuZIrc8Q?=
 =?us-ascii?Q?mMpR/kL2mZALeoUIL0M9u8+dUQV/rmIaX5MivMphbQ9xtq7yWjSmB7JDqJeO?=
 =?us-ascii?Q?hl53o/UYvDsmoBg/WjzTt6Xncl6SITEhufqTpWyURHVaKjR2dtaDPnJ/vjZk?=
 =?us-ascii?Q?poprlhYydkMaPKFFfpLJ52lkzCavZJ41c2ZcvbNl5zu2nP3Pj9DABJkav43P?=
 =?us-ascii?Q?5gSD87T3ek6PG2WUc0FH27KFnTIsz4rIRPm91v03tUeLO5r7WeuQ4fLYhugl?=
 =?us-ascii?Q?owHtiSgmnEDmB6yBlrLwsaGVtKH7d+h2/hCFef8fqzCmvX3ZRsjpcjong3BZ?=
 =?us-ascii?Q?R9AqGKvQJEIdLreafw+VdvUmkfXazoclMmmYfp1RrrytlFcQTiPpimQ0ee9s?=
 =?us-ascii?Q?mGKbWSdnOMOun68ii1emKDM1+Ipjcl7jLBkI+xnXs96RvBJX61EbYqcZWnCJ?=
 =?us-ascii?Q?pfiQHaDZgjt9G6dkc6aYrwEvXUivxJVakV2Kz09wnYDJMgnad4EFQBIbwoLl?=
 =?us-ascii?Q?rYq1JayN9U2nM2ZzLwMczayvCoZl?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZgLSiY77FigNg2Mvk+9RlNkDhzpcneXk6W1KFpZHQw4hRHdC66t9kvtt18dK?=
 =?us-ascii?Q?ByzzlAtqdQKrEyJ+DMkoniVnqJX3pkoDHapMEdV+mSyQ+ZIIYYCvZwMjBSJn?=
 =?us-ascii?Q?5kDecIz1Nen5ZgTfysrQNMvF8xeV/5pOxzua1d8bMMJEjYiBMB1Q0uRfmj+g?=
 =?us-ascii?Q?MoS7xSLTWiKh3ucTyMEOZH6E5AbcTNWdj5Qcz1oOcXnWdmQu3VBveIOf1Tkf?=
 =?us-ascii?Q?iUOi+CCanIxvfAnsi9o4sZhL39NhB7BzT6VPZcAM6TlKqQreNIxIHJfYgjTN?=
 =?us-ascii?Q?3UzqZlBV8NnQ0DbZn6QroyFOSbWrphAiyIfrMXWmofiE2gtjhCvBsKnpKHar?=
 =?us-ascii?Q?cVSporueqq4yeBecH6FGTPEao4iY2Czlxzh74zJvPGskh82v3B5CZmFjbnPn?=
 =?us-ascii?Q?22iAd7QNEiIQfTSDvk2dFGvfP8hnL2yYNBjjnEOTWK5blNR/3IT8UxWN8z0D?=
 =?us-ascii?Q?brhWwOomlbh8e//fUK69tCrkueb6Wc/mNKw/t+h47lWEimEBvin8IcNype38?=
 =?us-ascii?Q?z4WQtNJW/M0LJY2ohwkA4zWgrgDwNA1e0Mh6gXaJmkl0UjqGKNQRXE5ScRRf?=
 =?us-ascii?Q?Y7oDsrZ/SEJMzJnQg2M+R7OmyXgwW07iL3+bG7QEQuJCR3OomWIkrpwiMPFz?=
 =?us-ascii?Q?/3wgqVt7+7R1fIdUrlYx/c+Bt1DQlAHWl38LsgYZCpfL45v2hnLhZUtCE4GR?=
 =?us-ascii?Q?FL/f/WiaYoe21KYMerJrJuYMgVq+CVbOVKmfxnkug3GB8U2+u3dOI2YCTjSX?=
 =?us-ascii?Q?1ChYgo89uw4gmUwQ1vrfp9bMm515WbgxxIUqL73T2j+mK9udj04K/SWAlVqz?=
 =?us-ascii?Q?84iIKS3HyZu9/l1EzFLkQyl7fHdJoPsvNt7/J5YNC5F+/V3ViaydUJ9vwYMF?=
 =?us-ascii?Q?eLRnrxx2nzfUoLrZATmoV15HbcBSKOknZ9CKiuU+8nwjnfUMkE9HO7urQiIF?=
 =?us-ascii?Q?uu93Erbo6DWQhMD6UplyCBBpTPm1SrDBAHoGD1iSyIazvbKCLEZMRUqCckkp?=
 =?us-ascii?Q?4NM4YpzvKvgdtdcOt8hZe0qk7LzwrpicXNx7d+ZLWlXbfigubNGbwUqlHpUZ?=
 =?us-ascii?Q?L7HbPbA1XMbIhbAzgqLCwfPDg9SnRljtPPxqGQugfobWN1FRYeyKboU5A4Da?=
 =?us-ascii?Q?jSM8hvnFZ5hEcXkF+XeNO/LrbdhOC70/KeoGZuQ0obgjSugt9KnS7rTKYoE2?=
 =?us-ascii?Q?ZNS8IAkKmkiFgiWMkF/IvmCEGeS8DQm64z6Cq1e8gZGW1ECna2q1MTgzcOgH?=
 =?us-ascii?Q?blbmsJI+B7plZU2LL24u0UXuMWT+qkolxgQNC732d2+N80HCIeCzxxLz8Ddm?=
 =?us-ascii?Q?keD7CyCU/qq+/wZnqrIocC4ZxINmZMmyv6XHbUuqBlvu+n+7x2SbAhKZhQzq?=
 =?us-ascii?Q?xZLiEE0r9ZHCAhiuMijlHXMX9bFqLZTpHLAKfbiQdIrUvtd7i+SyBpdca/9m?=
 =?us-ascii?Q?WCr1d+UVFpcGprzJR+aUF4Vn/RqMAW03oVCpsRgp5XOuk1TmcXi2xzxCI3c0?=
 =?us-ascii?Q?8OBRGv2YfFLd9OKaAJWEU12BmARNN491yRIawAlRwHGuQekxWPDGd8R1/6ZD?=
 =?us-ascii?Q?dL4lVwURDzL1kl3fPf19DsiuujIRd7eOq24ieSH5?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 593d82df-116d-4c6d-94e9-08dd2f8cf564
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2025 02:34:21.8297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MvNDsJM/K8YJ944vIgi4G2cndr+QQoenQTsNuvuZEclj2EDLukEKo26OjogB000dwG8ZQhX/4V1ChPBkCWwokA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8235
X-OriginatorOrg: intel.com

>@@ -147,11 +278,17 @@ static int __init __tdx_bringup(void)
> 		goto get_sysinfo_err;
> 	}
> 
>+	/* Check TDX module and KVM capabilities */
>+	if (!tdx_get_supported_attrs(&tdx_sysinfo->td_conf) ||
>+	    !tdx_get_supported_xfam(&tdx_sysinfo->td_conf))
>+		goto get_sysinfo_err;

The return value should be set to -EINVAL before the goto.

>+
> 	/*
> 	 * Leave hardware virtualization enabled after TDX is enabled
> 	 * successfully.  TDX CPU hotplug depends on this.
> 	 */
> 	return 0;
>+
> get_sysinfo_err:
> 	__do_tdx_cleanup();
> tdx_bringup_err:
>-- 
>2.47.0
>
>

