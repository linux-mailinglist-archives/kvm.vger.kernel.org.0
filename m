Return-Path: <kvm+bounces-52275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C093B039BA
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 10:44:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D4D03B4BDA
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 08:44:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5691923C4E5;
	Mon, 14 Jul 2025 08:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AZF5DED5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F6C7464;
	Mon, 14 Jul 2025 08:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752482671; cv=fail; b=UeggR7JodBZhKypRQMzSw6XNwjCyK+4qh+mt134ww7JYVXj8PyNQPCU92FvjeFqYnGO8HgAzLAxqCyDt4IMWamgm9xWfq9nQjq/4UVJX6yX1ijUFX+TNGxQjUL+TmGrdfnbtgk8f7JUcowQDwlxVPljhwVzV+8uQiUpRK5OrW2o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752482671; c=relaxed/simple;
	bh=gQWkKxeTBueRNIATTehtYeiSnhMrz3hX9K5MLwl3syY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ke5C6W33lx0BJvF/ihQVofz4NVilMbvnCIFgJbcDxySzBXbXKHukRLixjQsIpk/9MnjAUsHGF/z6Lkfo9f9BO7XElqkjrqKi+mZyauRG6pOMUBz22esBAwCuQuWA4wDelYWZUSVUbXDLNXKv+2A4kCZH6Td0KcgNku4HU02tCrk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AZF5DED5; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752482670; x=1784018670;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=gQWkKxeTBueRNIATTehtYeiSnhMrz3hX9K5MLwl3syY=;
  b=AZF5DED5mwTs4OJeDDhpMIIWjXenyof5KfsFA/WaVGP7QGBM/nc1LLtR
   hrOywGFDAjbFA+ifuxhNSfwH8AGTeEGmBKm6qfw7GO75KP3Rkyp5IfsKL
   m16HJ98L9Qvto49/VWqWuJ1Gd/W8u82zaWhExLoXqhZYGVmXKC5/htDF0
   5L0XKBokixlWjqphYxs8iMpLfF2sH7AjNPu2KNg/xUnOnl0nrgoFXlXRf
   YxlUM0BGL59LT5WUoqShQVgW0AMYWfNQR07gSe9FtjK7Lx5XzkKgH3JB0
   6Q7rNCzwe46uRIibhTe1vDUteUXvW6L2EjKe+mF+XX74nrNfP34iaQpJx
   Q==;
X-CSE-ConnectionGUID: EMUbT/JrSbWOm8QbWjXj9A==
X-CSE-MsgGUID: bGQVe8nXQ+ClWeiQ/cCXVg==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="53780327"
X-IronPort-AV: E=Sophos;i="6.16,310,1744095600"; 
   d="scan'208";a="53780327"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 01:44:29 -0700
X-CSE-ConnectionGUID: boF9a3vQQL605HPVcwOZ1g==
X-CSE-MsgGUID: Twb9K+GzSBSQ0KSTsVNXRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,310,1744095600"; 
   d="scan'208";a="156977593"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 01:44:29 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 14 Jul 2025 01:44:28 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 14 Jul 2025 01:44:28 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.69) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 14 Jul 2025 01:44:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AMCWv/q3NmGrZkYZ2/oN8/4bJeZtpz1MOoBkOQiMc6Oukrecm0Y3TRpjY/PQgFC0eQit8COLMzARsZlPq2WPOMQDNEdoSmwNOAJY7tFJlg5P0nMZT70sPc4qclt5nXjbWii/74n/4ts5+znDEpIJGRJtjAmIuifcQX/PMh8bJc0CzK27jx9hv0vVNBs5PNYDQGgCVcgLl+dXqPg92uLNqy8vTgAJj8KDDYininlrxyD3mJimp/8u3veY1P/8wP2lwlNezlblASZlCHhCyeMRTi7DDB1WT6jqAh4Xk1QH2iYiZGQfRAl6j5C65qOV+gGqXuieXoUVhg9iq3J+S4LMkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fjtHUvtiXJnzYmIVx5kwEnyxmmKSp+3puJjYwjhOIWI=;
 b=FH8eEEybSwhI+RXL4OUg2rEBpFBZnOMnBUuUSbgpoXnMil/adL6ZzVPyaMwPGrJZmiCG61eycyxngRRy7SrZ34VrOLG1jWeqqU/BEJO6c2ERUeQF7vp3F7XVTuUpvyZ+kdqT5NAjKNAl5cYencwDHVoLr0wEPzDR70XjdIKZNsYSKPb6Aops9DPFCWlkHziDSVQ0lvQczQYz587jEI0uVvSVJWnPDsh5rcSdAbjjgz8gDVFH9vmqjJm25zJHg1kWXflyn8RUZnt1V9KSXMOBG/bq58Ia4A9lEy8h0yk+yVWy3a+LyltSQzaLT3Ww2lBOOoC6Qra/nssD/Zho8xzxtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA1PR11MB8857.namprd11.prod.outlook.com (2603:10b6:806:46b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.33; Mon, 14 Jul
 2025 08:44:26 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%6]) with mapi id 15.20.8901.033; Mon, 14 Jul 2025
 08:44:25 +0000
Date: Mon, 14 Jul 2025 16:44:15 +0800
From: Chao Gao <chao.gao@intel.com>
To: Kai Huang <kai.huang@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<thomas.lendacky@amd.com>, <nikunj@amd.com>, <bp@alien8.de>,
	<isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>,
	<rick.p.edgecombe@intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] KVM: x86: Reject KVM_SET_TSC_KHZ VM ioctl when
 vCPUs have been created
Message-ID: <aHTDX1IQuyWYUwL+@intel.com>
References: <cover.1752444335.git.kai.huang@intel.com>
 <135a35223ce8d01cea06b6cef30bfe494ec85827.1752444335.git.kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <135a35223ce8d01cea06b6cef30bfe494ec85827.1752444335.git.kai.huang@intel.com>
X-ClientProxiedBy: SG2PR03CA0093.apcprd03.prod.outlook.com
 (2603:1096:4:7c::21) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA1PR11MB8857:EE_
X-MS-Office365-Filtering-Correlation-Id: 52114cec-b8e0-411c-f11e-08ddc2b2a2fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?9QKLsdAHKf6OF0xXkBh5e7DsqGwJVPsjZu+skfDknfmUnLdCGccTKy8GnahR?=
 =?us-ascii?Q?qJuCDE59KoNyN37zLTdMg8d2FAOIMRFgzoIxErLE4EZmZm0B6x0hkTmBP522?=
 =?us-ascii?Q?roxv+iqNQP4QEv2WvUkklC4w+9gC2+XS5fdn+zYSacFgmvyZXH4yN+Inzm7A?=
 =?us-ascii?Q?mD6GcEa/O9oRgMm2IGv9UA1qWaBK6s0mvW1ULHhrGOEIdZdQvNtTWTOOfgTb?=
 =?us-ascii?Q?B3MfFBl+Fxk/DPlmBsU9pqTclgVQO2o6xtQR3R2jFXzp6iNbnfWipyR8W8dN?=
 =?us-ascii?Q?7vdMJebD7fmV6PDguTIWTqBj7fW1vm1BEvb3U1w1Vb6fAmyhmNEjcw75lbXR?=
 =?us-ascii?Q?QL6mOdIJA80SC1RAqblBQNMI9tqhbBujvLu+Gn4LCiin0Z9Pxz+kZomyzgIF?=
 =?us-ascii?Q?ZiToLxNa/yq9DdljMLPlqPJmYbI6PD6YXFSHMe+E0mQQz2GuFJ7lF0DfTurh?=
 =?us-ascii?Q?SfPSSCA1fArECXgeysyGhg83P8YWGjC/pL11wGM0V8GeN1r3BqYZl4kCUD+Z?=
 =?us-ascii?Q?LBzEFC1SmOTAwGZI7ottQy8aKWCbsQvX37kY2YKWjmOzhZXFs9qjPVCs8f1Q?=
 =?us-ascii?Q?fxhMtmySo4+p6YiJgnUgQPECLfmbHHN9E/sIvGaOX4SbTwqtp+0NFxstmGWN?=
 =?us-ascii?Q?FFGai92hO9MMNcbsbN6ErySGP1lhjTdjtUFVYN2Bfw95w1j05UP0UkxgwNoH?=
 =?us-ascii?Q?xDsEaV8fO/NxIxb13dD8RZ7JY3rmAMiFGKFfAkf8g2TKjwdEiIDXoc31thXp?=
 =?us-ascii?Q?EBpOVnDo9LvuzuY+SaSy6iViZmtDIyeYCx7U7pNOtd2SC43N0ssqQmPijOdb?=
 =?us-ascii?Q?qGZxJnZiMFMHKbQlWEh5UUwfh2mKO84O1SganeQbrIXqE0kvDRUJ7ZaA/mUA?=
 =?us-ascii?Q?mnY34LxJX4ZpzMMfRQiIzFcM8hqXYBL+JONSyQTKbnqljrKfbX/KNUxagKBL?=
 =?us-ascii?Q?+col4rmDSAt37h5vOtEYpuM3Xu2oEg1P5wG2tGNCK0nYri0seCmXnIqhSsa5?=
 =?us-ascii?Q?6Ew/6fa0c2VObyyyaLJPvvYVzBZqfrSUnlWvUvwSC03BWSvGPkz3h6aRIiuq?=
 =?us-ascii?Q?95UsGa/lKpSUmvshL+AfQVv+6Anqxiaq7a7f6BlJnrcb8tNKOZqsjQWbXhsd?=
 =?us-ascii?Q?H/SxDmFI/pK01tGY/P3VqqHITj40HzErFJc+THdcZ+ldEWuzwD9EDizxCnEx?=
 =?us-ascii?Q?s1cgYlNmFGiA3aTQgzFBB3DsMH2rce6BQOw0qodUqt0hi4pE4Gn/sSChX7Wo?=
 =?us-ascii?Q?dEhOnbTbi8dcZGBkhnrkjByNB2FAgkc4U8Z7mpEkSBqYwsQ1bKhkVOQA69Wk?=
 =?us-ascii?Q?wV5iOb48IhediFLzWgtBl7vcFqmd1/6EoDQaNSx73MA+nzGuxjZS8o85O+/l?=
 =?us-ascii?Q?BG27kXeHkD0MOCp5DMDzuBPWqIGbkWWEXGAJ1nEsAJDd3yyXTg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XtjiPoA9+kdH2574ebTcbsep5x1r/Pal611RM1ucRilndWhTmDcdIu/V5BOG?=
 =?us-ascii?Q?4eDBTbjoHjQ4kbCQXYnSxaNM7YrYHooy/KiYyAvgdW3PqYE0FbAbxqqKdv6n?=
 =?us-ascii?Q?/mhNB9LU3tpXB4TODw8SXRd7P/BrVmrE6KBwNX8GasaVFOO0CUWsr5re+nhs?=
 =?us-ascii?Q?JR3mBRSGXsdFtGok8OeP2aNcvwonLmuVoSQCorxaIdJhqF31e83bsACmorL9?=
 =?us-ascii?Q?5F6jBsoycHZHlHav7xfC5SV3HfVoAA9TrYT03TkZw1cpW6Bhj0cuXn87aWYC?=
 =?us-ascii?Q?lTuz7r+7ha8ELmJNky2GSdJB4AwDJs45IE7JHbWMchLefc8ci79iwiHmftag?=
 =?us-ascii?Q?UCAiSP4DtFWWjS80n4lemhdSQxRRpEbuaUom6ZTKpZg3cnuHeyaPaJnDq2ox?=
 =?us-ascii?Q?DQxnwJPbMdRiUsuVvY8TdISAXYNq0WYUTw508X6f4sxXu2GPLkyWFC9Ja9lR?=
 =?us-ascii?Q?jUZTM6Tj33A05AWngh5WQubz8rDrto6CKBjhEWqVm+txBMi/z1ql7wYLeb3a?=
 =?us-ascii?Q?Ifpq4r1ERxC+DOWxy88seAVYEdQnLTU8g4RCS3AVAUlnnBcl4qmohuGHzwHP?=
 =?us-ascii?Q?ueyHgdS6ysP3cK6l2sYvi05pHIei054OpGbw8b3SY+rmrjLn1eQfMSOs/+10?=
 =?us-ascii?Q?0MPGS7LfwZ+lrIU5wQkUDC4LejXb/EN526DXHX47MyH8Us6n/rRDEHUWzeRg?=
 =?us-ascii?Q?bokmBtNrKkprfoS6722nZWMsvql2SzTYSiLiUJOFEgGRViV4zAoc4Ozreast?=
 =?us-ascii?Q?xn6nL2NpsScOJV9UUWlkQ9sVXQLYvu1/Yfy15wAFpJljHM9ZWjEn7ZtBX3oO?=
 =?us-ascii?Q?bEuVKlcKqPnvP70gaPoX/E0xPLqP1LR8jdE9Qhnn/QvLLJKQr3XLou0bqFhn?=
 =?us-ascii?Q?p/gaBSCfidYRscf8wBjx3XkHEBnoxnjotC0cVGRhMmQxUCfWSHCc94bSH0cZ?=
 =?us-ascii?Q?JJhXIstCfMzAn4WZT4+IAjnB4Z3h9wQoWkXiBIT1M3r420IQP8cJW8/ZgXFG?=
 =?us-ascii?Q?udCQMsuB3L7uqWpPaBIRhnv1HfSCYQ+hRNboYcZKyC3Li7UhdfwiJnJ/4PRE?=
 =?us-ascii?Q?hTKjYE5TTm/mLGpS/xbQzlUvmyUM8PmLqEBYhfjOVohmIBQGebsivckW6mHD?=
 =?us-ascii?Q?xpzdxvWlYa4ieU8KmHNNapYBfB6EO7noye+nQplklKQPg2syQcqxyb32N0z+?=
 =?us-ascii?Q?65npej4e3X7LdvUPPPoM5fknPp6na4ikl2n3Q2WDWYcNCgv5HeUtP/XPOti4?=
 =?us-ascii?Q?ShmSbp4Hh+BalZ1KVRevquV8alfSFvzFP4+0OauP69u6xXufkyD18TJ3Hg5F?=
 =?us-ascii?Q?TZ2ONCvhbwCzrWG6VMpfX7JJrfzDvgc6QsBikmHGb4P0g1HAMw4MtiR0p+L9?=
 =?us-ascii?Q?STkfXk58UmpTlkVMrS99hxyXdoF7MstuHZlYZYJUwWuxW49OIWGuNMrDtKvz?=
 =?us-ascii?Q?5HbtWHHweRZ4ACy7aE5/kKBFKBRwQ6gYmoBVyJvPHA1dK7xqms+igzASLfif?=
 =?us-ascii?Q?qFBdYH0Z3lIwwSugpr5vvCwReXLMCucUnFKfm4qKk6aZAO/pFcpsr6SZ+gBm?=
 =?us-ascii?Q?jWsUQdiVzqYj8gvYQPIlRsGDkF0H3vthIl+gqAHi?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 52114cec-b8e0-411c-f11e-08ddc2b2a2fe
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 08:44:25.2314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mgFOTzo5GD8WeBNTsQFumqjEisL76aqMT/HXPbP0pKwUm9IxfPMZIdZMhV882NE9YMY/u4qDGqOvugXi+gpEqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8857
X-OriginatorOrg: intel.com

On Mon, Jul 14, 2025 at 10:20:19AM +1200, Kai Huang wrote:
>Reject the KVM_SET_TSC_KHZ VM ioctl when vCPUs have been created and
>update the documentation to reflect it.
>
>The VM scope KVM_SET_TSC_KHZ ioctl is used to set up the default TSC
>frequency that all subsequently created vCPUs can use.  It is only
>intended to be called before any vCPU is created.  Allowing it to be
>called after that only results in confusion but nothing good.
>
>Note this is an ABI change.  But currently in Qemu (the de facto
>userspace VMM) only TDX uses this VM ioctl, and it is only called once
>before creating any vCPU, therefore the risk of breaking userspace is
>pretty low.
>
>Suggested-by: Sean Christopherson <seanjc@google.com>
>Signed-off-by: Kai Huang <kai.huang@intel.com>
>Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

