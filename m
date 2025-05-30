Return-Path: <kvm+bounces-48106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B8E4AC92EF
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 18:05:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0A7571BC26BB
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 16:05:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28701236424;
	Fri, 30 May 2025 16:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gayFclrN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2076.outbound.protection.outlook.com [40.107.223.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277F218FC80;
	Fri, 30 May 2025 16:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748621108; cv=fail; b=jPqT0C999HHFVsa48K1O4+70PX3edAojQWTWXu8lDmh+ACL1kTfDQg+3WLFMrICp+DOszHCiaDSbz661nsreAUrC7tOerLcmrn/HrtN2eoautC+H5hGIn5wXWwO0ufEHX1VDIHv/KMoPy1brHnzQZR3kJQ1ri0dKglNyajUIKT0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748621108; c=relaxed/simple;
	bh=oLorEgCF5nMp6FWLbuhVyDeTA2nk6PmTU7l+2n3dJfg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OdsF6HS80rwfYObGOgN1M/ZIp1qeTeJxxYebJfY8mryT5Q0C1JHuUhmzT4e8sejpqX0/EhYHNcKGEFIpscT9frJNoGGfH4rSS0ADQ7OcxBg/qiga1qzAnqQItk1Wm5CjvElsSRZkrlTrBiyGlhgQbXRsvSN6zVyeKFaerAtAf14=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gayFclrN; arc=fail smtp.client-ip=40.107.223.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Io5S6Bb+S1n/mUaF7Z2I9LCkUTzqvLJ3L8iyEcYLbN83oCno9I1dbaXBUFffgEVF5EvWwpZU8R6CYvwhsZnnHn1FPKStgNi94UpOc+TzxBy9D0yIGROoVRXnbweFes0dMqUdwIV9kNE807/CQlxuxY/mTcNcIoYDR/0Ewv4WFgliR93gYw508IYvBRGqISifQon2MkpwfUYxoYVTf1wVOa2b7Oe7ZqdPrsLPm2T0ikwn3rgR5WrBKwWhyIX8bfeiOBZaTqWzi+TxlGeVThonHewBEtuDR6G01chdBMw/tCFvFydloRyspyWmUvCTZ7CKAx4NTWhMXI34lUsxUGBSsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YEKvxZDwA5o52kQmfp11M6L02lIvPnTeMpa4q3HB0PU=;
 b=DrOnWpffRZrd7YD96J22vV21nDTu5K5Y/70GkC3xSQ6eVAd3IiHxACWDBcKFl6vjXPXc6uWRFW9zNYKGsKOwEIfonIpJvhs2eWhDa00tpj1LgIRGmQ+7X9f1VLRaP4rMV6IBHlKEihw9kK3vVxY+dthWZOlBdU5ttr09T7qj3GwSeeyhDulIDyP2blC+XhNhRZ3wzzDXIpE5u2sy4idCk6j2ebyz/6xlARj0flTOtwb0bqrCyO0iHnrUqUGrye7rKILphFGkGZPKSOtOJidnku7/P1/MugcWicxSZ19dR9pvuwl7EOgvD3qp9jmupdIojKSSBtRXBF+0WOSK4xsa4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YEKvxZDwA5o52kQmfp11M6L02lIvPnTeMpa4q3HB0PU=;
 b=gayFclrNIyRll4bbkYfh9Jy3Pn30NTYJ0RbL0/BTJKLd9QVXclus1yWoIEx/tXpg3u/ijk1Mn6dvy1NoYnnvhVbVxJ8+KvhV7MiCnOx26UD+a9gIRJxdw7BD1g34yeqc1rwdZnC/9JrEDQFhOPtqF5C7auq2Lj5k0Vk/skTeryA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by CH2PR12MB9541.namprd12.prod.outlook.com (2603:10b6:610:27e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.31; Fri, 30 May
 2025 16:05:00 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::7298:510:d37d:fa92]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::7298:510:d37d:fa92%3]) with mapi id 15.20.8769.029; Fri, 30 May 2025
 16:04:59 +0000
Date: Fri, 30 May 2025 11:04:53 -0500
From: John Allen <john.allen@amd.com>
To: Chao Gao <chao.gao@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	tglx@linutronix.de, dave.hansen@intel.com, seanjc@google.com,
	pbonzini@redhat.com, peterz@infradead.org,
	rick.p.edgecombe@intel.com, weijiang.yang@intel.com, bp@alien8.de,
	chang.seok.bae@intel.com, xin3.li@intel.com,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Mitchell Levy <levymitchell0@gmail.com>,
	Vignesh Balasubramanian <vigbalas@amd.com>
Subject: Re: [PATCH v8 5/6] x86/fpu/xstate: Introduce "guest-only" supervisor
 xfeature set
Message-ID: <aDnXJS37+sOtDIrV@AUSJOHALLEN.amd.com>
References: <20250522151031.426788-1-chao.gao@intel.com>
 <20250522151031.426788-6-chao.gao@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250522151031.426788-6-chao.gao@intel.com>
X-ClientProxiedBy: CH0P220CA0019.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:ef::26) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|CH2PR12MB9541:EE_
X-MS-Office365-Filtering-Correlation-Id: 9686deb5-0d93-4b43-5087-08dd9f93ba76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Mtb/gqEEOuSyMV6rnT0YYKEZcbyhbDbqjLTampLeABjICT68mJAKcAiaKfS3?=
 =?us-ascii?Q?t9ZjGwBwmySuaZ/jpW6CUnNlMMfkg187skhYEsq+tKZuC+h/f9NzgSdkJCwn?=
 =?us-ascii?Q?R7NG9BCTPEPtO74jLZ57Y/blLlQ9nKbPGdIx7HaLb3lT9INa1m3xE1DMAu9u?=
 =?us-ascii?Q?lqidgF1zdxSkRSxSiL2QWj58P9/rrFusePgIBIKzIO6/LZ2CeEFVukG2yKHI?=
 =?us-ascii?Q?4ZXc8QpVx1HdET9Q+C1PF5o9aw0g2FAbqmui4Sl9qHiKczsJzrT0SKkvL87J?=
 =?us-ascii?Q?aQLi4JnJPV4GaZSqw4DXVV9T+U1gkbGN0c2iOSunOQAJNop56rNRXdpD+KSI?=
 =?us-ascii?Q?RvSfL9JsMZVbWjBrXclWBPfH3LZqFSMrXER44nXofGzM404j48dbe7LgG08+?=
 =?us-ascii?Q?AjvdsHsBn0waDA1BGvKEOplw7DrR0P8/a2IJPwHSmLVYgod5eRIWlXiwEJnn?=
 =?us-ascii?Q?o0IMc8I0zIqnpmIzIi32u3tx7x+K0ZX8rULAh36Yzatfi4pHtHPAS1fPSlBK?=
 =?us-ascii?Q?dOI7isjHMjOsAF1RaJReVQJQmafYkhevGgAFmZg8cbAAJadNpw7WEU5E7x6N?=
 =?us-ascii?Q?eg09tzgy13ZmxMN0zGnhew6BZxKtAQhD7SlgFjHD56FSJMGj1olYbroHQnNf?=
 =?us-ascii?Q?2fFmxzAaufXn/4WBQDSvposbRlO/LKzy2zVNis/5kdO5tAS48ERcvtUPh5bK?=
 =?us-ascii?Q?DkLSr9kOEYzuNja1HxY5J4sYfXZjOioh5UYrJERMiDE84AFViq+sIAcLij+/?=
 =?us-ascii?Q?dG9P7/8a/kJJsJlNMBlVdHhgMr9LxT7zdC6XvI9QTirAL1H9EXyXm1aTHOjr?=
 =?us-ascii?Q?6iXero74K7J51J3gdxLyEXgecXHmuDW4u20Fya98ZL32jjQxHNNUWUkV8yWo?=
 =?us-ascii?Q?ec8NojQkIi3jHcPhfsCpOgByFTBUEOp2TgN0gLQlffTAf8mwDvEbqbV6vVrU?=
 =?us-ascii?Q?+xk0fiK71HrzzFdYcbESzFgb8MNyzii/4EknziajUsXVqTMRj/AqwiNnG58E?=
 =?us-ascii?Q?3wfTkpQVgkHbtvveGhDT6vJYs+iRb4J8sW44EHzVSqBNloADM2csr+LdZ7hw?=
 =?us-ascii?Q?6vUnDu8tjEM2CQuCexY9oNHHeXYsXh15OPQjHVteot+R9lpoKDffDYeeVE8I?=
 =?us-ascii?Q?xTCrGJOVbqpn2nM8iD4imI/nQTu87TQvaWBBDvMSkxkjuUHe/oO4CqaIWW6E?=
 =?us-ascii?Q?7W9QDZSw+BG20t/+9G5JkmeN5hbgTmZb34tmDSEooPEViTVSTWYFGGVT4+v1?=
 =?us-ascii?Q?hJDC2LeAtfEkUjvJEx+NPeWksOo5PJz5XT792bIPn13d6JfIq/S5Q4TJyXeg?=
 =?us-ascii?Q?vYtTWyf9WDa6aTspo9KVXxXPPuYWs6oyGqQD7sdgjHFbshTIZe0A8+ptIstO?=
 =?us-ascii?Q?+YDT5gfvjduQgvagtcP+5zQkSIU2V95BZy3niDN5n0Im9PChHNlCV5RGtfb5?=
 =?us-ascii?Q?C4G5YT0O5Wg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Kw1Nw7cc9ixBt3mXxECINAEEActCd/an29XN0o796vrWXTzR2AlGTg7IOCmH?=
 =?us-ascii?Q?KHWRb9ZAP2md3iNsC6JU1OfZcsCoCUItDOsCESuW+Mzqw8ehlneVHBIbhEyx?=
 =?us-ascii?Q?Shw8Veq/p/B7ejiQbl3o3SnNZ+3CffVKRa3NQ6u0Usyawod+BddzUi1DkWeu?=
 =?us-ascii?Q?ccRFUQ3oLzyjOwC0OsV6yVtjH0hr1iPWfZMEWTHTZbkF+bQNzRKuepEojGgl?=
 =?us-ascii?Q?p517dC455RuQGFU8thcmh3JfQS1clfT36MMDjzKeDH2wNkG8RcEvGIf4zA2m?=
 =?us-ascii?Q?Nu5lzG2+l1C9XCTDGqKqxiYWKe/3B1MQhN9nIKX8dxxuSKL7jaCaN3tBAwmA?=
 =?us-ascii?Q?ye6cwkr/cyPmg6wnDVwSYklJnfx0qVFgrBGyRA65f1khdXWtMDQrMgr4x/8g?=
 =?us-ascii?Q?gybPAw+uLzlkfnXieG5zbT8XKn322izPoT3bQ+0YGf7tYXmCmEe4jI09u/Xa?=
 =?us-ascii?Q?PpYPDycEo0kzG4A7ZfCCn23an5Ld8N8BA1LN1Dzl+UI7e0ee/MDtyUGzTcgS?=
 =?us-ascii?Q?HUna2kctwmMMAK9TlpNvCFOPJ1maPf9ozqMn7zx4Lh6EH77vzItGg3KnzAWC?=
 =?us-ascii?Q?i6l9wKTUut9x5WR78WvLbct7HDZPFHqzMEqLb6YkEw1jCh9N6JkBm9z3DnGQ?=
 =?us-ascii?Q?siPOfcrLSn1q9f+HyEz1TEg5I3oa76A19xD6R+c9G/D9+RrAhvAsf5AOIZ2m?=
 =?us-ascii?Q?e1TS8rCdxyXcb+X2HFNkKY0ReNAe0ViuGknGKs1Pk0i9fdOr5xSV6BkdsTfU?=
 =?us-ascii?Q?KLwsMLI4stFpKA7XXya5+eIOTN4/zEOU7W+O6Aq028Z06vru70xK84ICiMBi?=
 =?us-ascii?Q?05QRlOlVlNj3XlDAv5EPudaWUxpoEsW3JHq7/g9Hm/ayllw/2BiSguV0QXQl?=
 =?us-ascii?Q?DdC3cUFCKgUv+lBi5JOxdjpUe73ITZXoXhWwMVMnQrCm7whD3gG/RUIVqfWy?=
 =?us-ascii?Q?VV5A0dvNZ97L9XbFWQzMqEdyrDnT8XxEklPD1SPF4DvHx65Lq64C3a0miFmn?=
 =?us-ascii?Q?bBI6vYmlgLd2MLDrkbajFyElOh3bgM5XRFRRmuoHUJDaLSczXyim3i8tN/+6?=
 =?us-ascii?Q?w650Tq0R4TaI7V31dC+29IaCzBlB5ZEBnV2qmzfSFCG1hDM8n4935mI88R/S?=
 =?us-ascii?Q?KKuTrwEGfu6I0cz3W+sOyb5MgO4MyZ6Dp8YBtXCOnxyo+q6p+3Mwt2NvZRMY?=
 =?us-ascii?Q?XpSlIkmn2y9gMPj/0IZqgJM93J3hWWvirBf0EIRWBhsysiZiZNwDGlSXVMOg?=
 =?us-ascii?Q?YwHf2hjuVNXq9cqbv0+hVmJDmXui11H1REgh2z4xqsQTCNM9iJr2+qZl20mw?=
 =?us-ascii?Q?7kfK6JMKLqO+VQh3wpgu2QJSJyzjZY/al0NTTVvKOm9uhp7B/kg2YRKiSkj+?=
 =?us-ascii?Q?aIZJZKgZBj3628xe6xjFVRfaSLyBY6Wa7qjAhwmg1yl2+GWZ12WvmW6mHJza?=
 =?us-ascii?Q?S5GjLUrEZ/MCwTSwkC4kIyNwZDxOcGAxRO7pBQc7vi+Nje6f774IIc29RKFe?=
 =?us-ascii?Q?T6g4aZ0TW8GkBGfVNQM4G3UUnmFBdI4bD30PQIoveEhMlJjqXWmw3j4zZ7Yz?=
 =?us-ascii?Q?A9ehzNAfoDwJMlQDsk2vU3nbtK24PWrMVIMcqVjE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9686deb5-0d93-4b43-5087-08dd9f93ba76
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2025 16:04:59.6335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2t5rJrow79eQ+OoAmjbml5GbZZ0VJQLDC72n8TvN49sF947FyTKUbSgAocHYMDeoIzVcWrFvSlwUuQ5mpQgg4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB9541

On Thu, May 22, 2025 at 08:10:08AM -0700, Chao Gao wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
> 
> In preparation for upcoming CET virtualization support, the CET supervisor
> state will be added as a "guest-only" feature, since it is required only by
> KVM (i.e., guest FPUs). Establish the infrastructure for "guest-only"
> features.
> 
> Define a new XFEATURE_MASK_GUEST_SUPERVISOR mask to specify features that
> are enabled by default in guest FPUs but not in host FPUs. Specifically,
> for any bit in this set, permission is granted and XSAVE space is allocated
> during vCPU creation. Non-guest FPUs cannot enable guest-only features,
> even dynamically, and no XSAVE space will be allocated for them.
> 
> The mask is currently empty, but this will be changed by a subsequent
> patch.
> 
> Co-developed-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>

Reviewed-by: John Allen <john.allen@amd.com>

