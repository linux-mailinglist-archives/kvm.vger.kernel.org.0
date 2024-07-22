Return-Path: <kvm+bounces-22049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D51B2938F6B
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 14:55:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 569721F21F23
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 12:55:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59AAC16D4EF;
	Mon, 22 Jul 2024 12:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KK+VUyiF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7243516A38B;
	Mon, 22 Jul 2024 12:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721652923; cv=fail; b=b+7TMDgVGSfT50UwcS/iqz3npwhbVgL4J3AYUW9SCHfMM7OLZtEKWbkY6k2mHUGQqf2eIxULZr3ZLw4Jp24sW0IK43qkd1uF+b2To5qdalGyxUtCMsxfGTr/9aTRfWav0V+iQfHZrQ4oGVI6cv5R99/oNfn/VwR8eH9P7yEA6wo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721652923; c=relaxed/simple;
	bh=I6YrU8/08XleCo4Fy5ENQS0mRX13R7HJsCmGLCPXYns=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QW8uzq5/n4dSvtJiuf4rq8QEZZQJ5Yzsa/XIIIuvL53hY1JZVImH0yF6bc34OByk8HLeQFjKz/1IyzWIG1y/Mk/ReORNtlRoV0o1s2ulxy2lcSx9zA7I4NXHGUUc/Ldbt03WXldUetXuMh+VTMaZpfY4KJeirdhNgyBIgORDt4k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KK+VUyiF; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721652921; x=1753188921;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=I6YrU8/08XleCo4Fy5ENQS0mRX13R7HJsCmGLCPXYns=;
  b=KK+VUyiFddXYHyduC1CR0gOgN3DQ2fcAEGO9of1gAg4dwvfyXDtFWDxx
   MWrCrUl9K5XpHzuL7j8SG9/cBX/r1z7gFMbqR8kXfuRuiI86wDYGhq1OY
   S/FvgRzg7AsZbP4O6BdMEgL3iB2lH3LUk2/4opCNPVb6MhlKxAagu82FK
   ujcTkt6tSsmMMn3xp0Mws54E5PZFhDKv8WEkQQvUQyvJdlMdC8kd6R1Md
   uqFVqYucNn3GnvuiZfxaaCGsCInH5XoKlSg6fTsllQ7gmRXmPccqXnSYy
   Ud/DkSpIPbICkcycF1VO3VnXE99Rj0hXBVuZsCrs5Eg9QfiJGguJB82WQ
   w==;
X-CSE-ConnectionGUID: sF41KJNyQYeSLY3MSqMO6A==
X-CSE-MsgGUID: Cjtz7S1ITP6uOWbSsFFaXw==
X-IronPort-AV: E=McAfee;i="6700,10204,11140"; a="30607119"
X-IronPort-AV: E=Sophos;i="6.09,228,1716274800"; 
   d="scan'208";a="30607119"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2024 05:55:21 -0700
X-CSE-ConnectionGUID: pJDn6Z3cSoqDTKg/cHO9ow==
X-CSE-MsgGUID: MD4GvWnhRdmnrIEjM0duGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,228,1716274800"; 
   d="scan'208";a="89324148"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Jul 2024 05:55:21 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 22 Jul 2024 05:55:20 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 22 Jul 2024 05:55:20 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 22 Jul 2024 05:55:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XSCwXklKcUwAoIjIk8oQ5y1KlrcaLaQixcFhyP4GG6zyDZMLGX5knI2Gq1E2VH0CAOajgpQb47r7L5JpKgM86HRAnNJw5tNiBAxSc+5C+gpD4P2fo16ljHmv0N5dw/owuVvcYaR/XpiVHAth7r4yEVIB09F+c6qXtMx6Iouady5IYJLwYlNDXGzZDHRnH5gG0Oq8+aRPF5hPS8EV6Nm4FKrPp5ZkLwzMw2VhW5em/BzGyUXpmH8ArmG9KcAcNfX2bfjZZUwq2W/7UnMFUtCqsE3NGaIOoxm4m4ASJR+8uQfdT5+Jc9YAejoPfZBtcpMxliLeJG/86Dk3CdYw9NLt4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4tNNW979yjmCtkJa7QTj87GFCPEtkqWR4FUBD/EV9BM=;
 b=bCx/bUJQtrFpvKIsYxdav3XlRtLvMtl1HwXvdD9pL4LLlgTzH/ZpSkS4wR8T9VP/H69U7eNXRKK2jwIpgxxN+KQb7BbXbTdSDybYus2JHtVFDkOfSQnjEC4T6/NdaUdDLWmUse9WHH9S4oLj0AdA/8oQ8e2T8C3k7I4XBAHfJbYQkBoPybidt+TkHepSJfVLojPOj+Iqa1zh3lEWnzz0tLgcFcEkOg4CdplfKQIViD7oH6lwoWpb7e7VPjB2A6elJS8Ms00lR3+bGLoQ1nQlwpNDNUwd4TUapvtmpkBH7PbO/O2KjltD2I7717H2gWS9q3bCROOgIAOlUeuusbK1yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA1PR11MB7698.namprd11.prod.outlook.com (2603:10b6:806:332::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29; Mon, 22 Jul
 2024 12:55:18 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%6]) with mapi id 15.20.7784.016; Mon, 22 Jul 2024
 12:55:18 +0000
Date: Mon, 22 Jul 2024 20:55:07 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Zeng Guang <guang.zeng@intel.com>
Subject: Re: [PATCH 0/6] KVM: nVMX: Fix IPIv vs. nested posted interrupts
Message-ID: <Zp5Wq1h40JMSYL5a@chao-email>
References: <20240720000138.3027780-1-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240720000138.3027780-1-seanjc@google.com>
X-ClientProxiedBy: SI1PR02CA0029.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::20) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA1PR11MB7698:EE_
X-MS-Office365-Filtering-Correlation-Id: 5936f150-5d4b-4c67-4166-08dcaa4d89c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?K/xTeedgdn85KtSCUQHAGfZIYeag9ghaxtq3q0j/JSeaIgxPbT+F7JnS3vnS?=
 =?us-ascii?Q?fZX0zJaJS/t1sIf6ASxN30s2w1WA0NFVcQEVAfZ4q9pCmouxIK7x81wsBrdg?=
 =?us-ascii?Q?Z0uC/F8+ixaCWJfy5H2HVyOXuvIUagk1WUVtct0SOXC7CVtoWAGekg+u6mI3?=
 =?us-ascii?Q?gX76txfWYA09lsHjbEZaahtOZZUmHZA8b8QD8BnG3uTCa9JeLv2QPoKIEeRR?=
 =?us-ascii?Q?zAw1dsjdL6uFY/3+7qeRhZVbXh8i6qw9lSakrfH4aSMOTjRGfZlZ1+Ju1NwN?=
 =?us-ascii?Q?lrVtHNbSVPnkM5EomNPHvXEsVvhsrJxRqy741rGnSLO9HjcxS0xQT48kECxW?=
 =?us-ascii?Q?Og0WvdCjxK2TpKLkjOVAe7baJaXb3KCtkwOPDUzvY6EmDWhhk0HILT2K56+t?=
 =?us-ascii?Q?6UGT4VFP9U3LEZPmj2P6jbF0T2jRc09QL154DmJu+NWkayfzbeRbQvGBAKTn?=
 =?us-ascii?Q?I2bvMtu6TiBqn4Rr+figah0oys0QjVPBix708AiVM2FUvyE5Lr2Nq6LD4Pc4?=
 =?us-ascii?Q?yKo4G4DY+FQhe5b6vfG/bnHfq7AbWSsZhR7xlk8g1c7or+1efGlrgaMdelhm?=
 =?us-ascii?Q?Tl05gHYZWOyOZFMzOkgmdjanXYF4gIccb8JOup4P9+6zOfD4hpETLZa3+QHR?=
 =?us-ascii?Q?M/nqvpc+VOmkFUj9QBuTqrWD3Uibx6BlByeg29nlQPizgyru4a2u/9MhUWe+?=
 =?us-ascii?Q?55r5cMS/1PRc6n0UtjS02AhTZtx54EGt4hLL0/id5wCt0+fKymgljHSNRFeD?=
 =?us-ascii?Q?R4640cjGk9pbMYhfKDq60N/uE3OGHzq7yPVGzAai5yjZVZ56AOHNbuG7VKFb?=
 =?us-ascii?Q?xv2Y2zndGz0OTy73j3Id2gMLt+vPSqykbyMw00eCwJ9leNOHcg3faWwqaMtC?=
 =?us-ascii?Q?OtEe1N8tZzruSHUO/tYwyPSv/hCyTLjJw9obpFVZnWSmUjpT1eMoQGUqhs+G?=
 =?us-ascii?Q?J6v2J1bpXN/dVynbHf1LqzBbLwku7XkmuoNpayLAAUamCKp55ZKKl9qdDdco?=
 =?us-ascii?Q?TBA3uYjCamAn1eYRNUhRG3L5xppGReivwCCar63mDGfJSeKaia50Fqe3/NQu?=
 =?us-ascii?Q?zJTxC15RyviS+SQ7H8t93n1WEcAseOSUw/skZpZavA1bbdrD6RjVuFt61+N5?=
 =?us-ascii?Q?PrBdwOLa2GkcXiRM918orFY9gNUdH1NUVsAhDovZwBtsssZ5GB2BgqxClFgM?=
 =?us-ascii?Q?1XRhKxeuZ9d8vBHDJyqfaNe+FR2OAz6XaLnejY+kLMTEMtMX163LrsogYVwt?=
 =?us-ascii?Q?9YG2eghVyQjrtE53IYpDCZargF/tXrKqZAGvyi4f8acFdYUSZcS3YkEQMd+z?=
 =?us-ascii?Q?5gQCgMjbL89tq9BQ+JHzMpCYn0H3CtbZEB9KvY6WU4vQeg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5w5XzlO46qkmgkMoZ/CCcAbpcxby8YAKWeRrUt299Y+80JRCus4zJ7Xnb46j?=
 =?us-ascii?Q?hZCvzuNuSJ96wedN9u989PyRizMwwDWl9ZiQ6PGUSWADdGrvgmc5Xe0KXEPQ?=
 =?us-ascii?Q?F26QcryY706avHD8EZGoCBxSRU6e6K7G7W57GX0uwUIYRtolk+f4OJZduz6d?=
 =?us-ascii?Q?Cn3yWKZshbrDT8G+Von+LbYKAfN3ClwlOdHItdypN/2S1cqkKkum0FkIakdE?=
 =?us-ascii?Q?Cxtv+N7BGDe8TjkcSnTtRO41fj1GgMeQHBwwrAAH/KSU3hN0qxau7C1hFkda?=
 =?us-ascii?Q?jOhBMW24bZRmXtqFDzUlIPizZxa7kYBSd4W0+FTD04qA6DN/7CkoTyOSWD/R?=
 =?us-ascii?Q?6RCXdszZaQ90atGNEtJyCN7vKOn1cSWeAObAGtYvKA2O2hqf66ROjRqCzuoD?=
 =?us-ascii?Q?Y6hcrj7PrVkgxBNB/SUQwLqFJB1d9U2ol9ltnFhTgLka/hNVwiNiAHfv4X9j?=
 =?us-ascii?Q?qZQcVYguI+uFl09Uj4idg7/GcbpdaLtngVQyeWGACI2l/kcaBJoGHfkViy/l?=
 =?us-ascii?Q?InU8wnDYp9WqseY3MwNZjBkObBnxyr+3TyFJmmHCnRtqm2rg6Qrc3eni+FiN?=
 =?us-ascii?Q?cHH/PWRyyYk08nGF0gqnJlJSRGkICdP9KoMrw9/w+dpIdkynGmAgNw3S4i7U?=
 =?us-ascii?Q?MvAhi845PGGphG2swdsxWXBKc5eVfBjWf5nt0E/cCDTQycXucAYPrcFU2JV/?=
 =?us-ascii?Q?LXqG3OMX9vHGe5EY36lx/4izLydMJtQo7k7A5kGM3uGYoY4lZwMf/4fIU5R2?=
 =?us-ascii?Q?IGMOquj6G8EFS3thWJns6+hS3jQHKK91kMNKTp2LysfuzRPB6y2JlifoT8Pk?=
 =?us-ascii?Q?nT3EHWteCW8xk5i5yYcuWS8oRy7ValgRl54dVT2Cm5ycNYKTq2kpmCXvMrHV?=
 =?us-ascii?Q?Pnv14SKcv8Vly4dsUvL+D+2T58mJJxyxtYsKC64KHQ91TYWbceuf/nqLMexR?=
 =?us-ascii?Q?pZ3rpAkgMv9e7Y2+82PsCxipDllfhii/sBpUqSuVkA2J0agfHiCCxND7i/tQ?=
 =?us-ascii?Q?uFTn3DxyBm8Dje8se/Ob383NtzzcGuuQknqmAJwpoA2gPcr1jd4hkmT0TvKE?=
 =?us-ascii?Q?wPUAfJyeXk408KsChR6vwiXy1xk2vmCdUE9AgzwkzREo5v6J2uMepW7rzfpA?=
 =?us-ascii?Q?qUzLtw0xACYerREH/8/f4c2emSooBd2w3kMFAD6zOftJymL8cqdqcPqncmJ/?=
 =?us-ascii?Q?IGy2JJR4TTmfuREMpW0cU4qNJz9ZvnRJ3F44EzsZzjifbFGgpT1HykA/6uIp?=
 =?us-ascii?Q?wWxrUwpWW78h9MkHj7h/a4Bs5uhJHhAvfTYANLkUdvQCBzHDHlvQ+Kcx65u+?=
 =?us-ascii?Q?WM+uTb8LCByhulMzjHzlLjDjGWKfS1wL6dc+5M3StNH8hh/ciBFFYyHy4E2M?=
 =?us-ascii?Q?sA0sP+urXCg1MKCf49OSzRRWtOoSGGZUSZ98IN0kHB8FG55S54foe5/kZIWP?=
 =?us-ascii?Q?Jfribwe+NQEvRG22z+A9w+b/BUzknJMAMSdQnme7Iqjm1CUmnakCt2/JYpav?=
 =?us-ascii?Q?UejqUCfTmK3lLx09fsa98zbHvTStm9tG3ZcWQQz92YnL9iWEourKqqUoBxK9?=
 =?us-ascii?Q?dBEw4gDxmxo/HTMZaXvWNoUqB4RhEbba+8ZI8/J+?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5936f150-5d4b-4c67-4166-08dcaa4d89c2
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2024 12:55:18.1307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jXENy7RxXgRrtrsc0n1oU5M6XZdmrkeCOFfSeVqMTbSvn8adZ6rxzTBHY0OsK6EcFShuOVJ6IsAn8H74BWwLHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7698
X-OriginatorOrg: intel.com

On Fri, Jul 19, 2024 at 05:01:32PM -0700, Sean Christopherson wrote:
>Fix a bug where KVM injects L2's nested posted interrupt into L1 as a
>nested VM-Exit instead of triggering PI processing.  The actual bug is
>technically a generic nested posted interrupts problem, but due to the
>way that KVM handles interrupt delivery, I'm 99.9% certain the issue is
>limited to IPI virtualization being enabled.

Theoretically VT-d posted interrupt can also trigger this issue.

The fix looks good to me. For the whole series:

Reviewed-by: Chao Gao <chao.gao@intel.com>

