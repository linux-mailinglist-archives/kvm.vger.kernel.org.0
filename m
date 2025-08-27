Return-Path: <kvm+bounces-55851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D6B87B37D51
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 10:15:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BB418188CD3B
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 08:15:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B70E4322774;
	Wed, 27 Aug 2025 08:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RsbHVuP1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75451DFF0;
	Wed, 27 Aug 2025 08:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756282501; cv=fail; b=eTSAh2bPxaOz4J+RNJ01RQm0InHnKg2UoCFntEYbka1ljOmfwvP8b54ez9hUfV2iHfzgQDyV1WQnEuHjJdKz5NfTfRofTAOlCqwUoXrh8nnm++n8kgPnDeIU/mTEHwNFGgrJfCbZX1DYovOnxkbffBxKEwmrFFL7KMqAjEyeXr0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756282501; c=relaxed/simple;
	bh=cGDsEnVdM5YuRS5T3BLwwrTirAv0fe9/TX5jsXQZK1Q=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UunkIvvU71gMGUBPQsxhndhd6X7Bq2QoXWuGTc+8TQTiI1Z4tHfubRmkDQIYW4eXEfhGOxK4UUK07c2zEcWfOwDv9pslyTOL8Am1lDDH+FlIcRn8kS9JSQgGyV/BbfqOl1oBzTBt7clDGAsT33VrHGDN0GFd011TX7qXg70Pm2I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RsbHVuP1; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756282500; x=1787818500;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=cGDsEnVdM5YuRS5T3BLwwrTirAv0fe9/TX5jsXQZK1Q=;
  b=RsbHVuP1x+7AGnJHgdhrXqmekvnZvhCmcDnQuhn60Xjst7K+5LmbFnS+
   RP6GSSvxVJUHV7J2cOenqHoh2reby4uwf0UWlAkzOzT2sIBHn9EJ3ol8k
   L2jeGGU1yg9heQCW+mXioGxFdlrFlYLArk7zwKbEi7QJ/qAfJf+OYCMo5
   5ZcsKNAHI5Tqq6tqel2B4s9CmIiBcnaBP+WuW42C0X6UL4y5ZCzyagXdm
   0Pvm6+97DBdxfsYlGyik2vrbxkY7wOtjJ5mL5XNedocYrqQ0AmPPuUoeA
   oic6ndaTgM7jN5QEnefL1ha+AykM3ONHBlN/Hyf59n7p+itc4SsQHIYb8
   A==;
X-CSE-ConnectionGUID: C4kdVCFOTSqI51yjfpnn4w==
X-CSE-MsgGUID: enWCHFXhRI+arA4Bcl65Mg==
X-IronPort-AV: E=McAfee;i="6800,10657,11534"; a="69244246"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="69244246"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 01:14:59 -0700
X-CSE-ConnectionGUID: +iCDuLjuSRCWpHBiJX2PWA==
X-CSE-MsgGUID: 0PcjCiIRRwOu59/nyhU4Vw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="173950055"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 01:14:58 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 01:14:57 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 27 Aug 2025 01:14:57 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.80)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 01:14:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GpdJSXr9EnSwuIGTJ9wFd/VkRG0lI/69ZyBP6UbuaT0cbqWlOjwlPbPs53mpD4wt9kMk4KANUNSLZpCD7TXzZoram6d1SP1NWo2ngP8Gqv8oL7lAG9iQhxxENBu3oUcqiKZ7QM35JUH4bfs2rXNMtdRQ9BLccuCBn8acV4stLgJKp4ImNgkEvvlaTaeE7Ky68nvFPiejAYeitpDTlaN30b74zJQ4FRETaMXSXgAOe5jid0r67iIg0sOJ9+lovLzfEPrrK+1wbKwEMEKtJDv9vjMBzoqqooAkQeuqnRD0bA/nDniqJYrhafUGqRgnqeCmPuSt9erUI9Qc1HXrsAvYiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7BbH5afdlTsGjT3If3lkun2m89sfijXTGWlDyWreBdI=;
 b=sY9iT4dcMC6QWVak3vHT9NjSc7XLQRkXVRgjAzCn8CySBCSRtKwSI4H9pH35I8qfMogkTtFKBpnxZJsnbyQG72IKZEWht07wTec/ueSH/mIdtTmfbYEYhDiFbz9hwtIIZFMkCLKCHQNCtTY5zDloqQ+BCVen0oOv33Y97kaWsAIrYxjiOhoRlarKa/79t11ZFDx9aFJov2a4XtliHw6K192vReZrp8eqOVHUNf6V3eLkP9n9IiZVYtPbEA8ZxAQ11GPUdJ4S9EgQ3nDLFS099VA0v+DWYYa9+LyZnhA2/tqjDaRZWqq11+jlCw7oSSj5dNH/2rCN75NORelSjVQGuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA2PR11MB4793.namprd11.prod.outlook.com (2603:10b6:806:fa::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9073.15; Wed, 27 Aug 2025 08:14:54 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9052.013; Wed, 27 Aug 2025
 08:14:54 +0000
Date: Wed, 27 Aug 2025 16:14:05 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Michael Roth <michael.roth@amd.com>, "Ira
 Weiny" <ira.weiny@intel.com>, Vishal Annapurve <vannapurve@google.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>
Subject: Re: [RFC PATCH 01/12] KVM: TDX: Drop PROVE_MMU=y sanity check on
 to-be-populated mappings
Message-ID: <aK6+TQ0r1j5j2PCx@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
 <20250827000522.4022426-2-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250827000522.4022426-2-seanjc@google.com>
X-ClientProxiedBy: SG2P153CA0014.APCP153.PROD.OUTLOOK.COM (2603:1096::24) To
 DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA2PR11MB4793:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f5735d0-acea-4d81-0b7d-08dde541cdcb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?1yGgJTR7PVSPreNwoacwBkRmr8UA94IG4jSJIiJzf3IkK/finuU0V11T3FLt?=
 =?us-ascii?Q?4GZJvDGffOC1xi4PHR3Mz8v4dS9TU34HWSI8zwstCLGAY5UlR3mh3KyKPL5L?=
 =?us-ascii?Q?qrdn0zKb8WDdbs9/Fds6BkdErB02Ng6DvgFgbSi2uNOSnw330ux4N/YrKfwm?=
 =?us-ascii?Q?zsi8up7Z7EdMIhhf3H0RyOaxXLG3CsxAwliDhFoOrT9B2PopyvI//g/sZWdv?=
 =?us-ascii?Q?sTc+fDJ8rNkIQBzej3y38uCWq4iZsK02yA44ts6JVcObtcqn7ZjH+IAnCqIX?=
 =?us-ascii?Q?9tP7ekBlL/Nal37hxT7xUNywKrecXvVLFhO0oNlRC4czzTqqgVx6lw17p1ZO?=
 =?us-ascii?Q?bZJyv5WKu79PepmIJ8Ufh9SqxsfhGxshmI9OEtOzNOEPFWUAEeuvrPbVwcVv?=
 =?us-ascii?Q?CPXStayJiqpGVHRBUQQGJ6nN9oF4ltxWWEQdwLx8bZBt+5OoSzOdaod/t+QI?=
 =?us-ascii?Q?EU6r80Z2alN5eseEphsHlmXuKSO1wQKz+nYMikg4kP3ItMHStCqJuUTnYgjH?=
 =?us-ascii?Q?ukK5gFNIrviNipeZ3FeMJSQ/daKKXs3jCq3o1+0uiT79hHCMfKVxM+7TTvhi?=
 =?us-ascii?Q?WYTTnIoY9FkuUpE31gcpubfm26JZ4YQtZVu5DQc+Mao3DackvFsDJqjfTwCx?=
 =?us-ascii?Q?4WGdFWjjK7h9vWYMJWLLvGU54hrEan9aDVIYwT8L+ESv19bb7i7mVT4GUmFn?=
 =?us-ascii?Q?ySItc9FX7xbOS4z2amvDlOZKbKj2C13HUMyDJA8gSQprEugazFdbrmlFffAw?=
 =?us-ascii?Q?y+SDebuhjVdiTarvU4XvxKow/XcHB/dT7Bv6hueytk26FVyMTlLs1dC4AAK9?=
 =?us-ascii?Q?HGQJFc/hBKWARs3TcYL5VLkiSPYStl5x6zuMAju0usi6b9c5NdRbEF9BTWX8?=
 =?us-ascii?Q?Zg01OxagO3JATtxrLy2Jd6dUxqmZdn6XkGXJET2KauaTZNRiq5OunIVbGGQC?=
 =?us-ascii?Q?FQoIW4rVjcfVWjCq9+0ly+BeKzx/Ns+Qrz2okLzZbsMb5KiidLuHwBPvW4IQ?=
 =?us-ascii?Q?j3bTznAGn7mefIrIB7SQjapnqnxmev3na8/IicIB8TqYlaRU7el7mrbMCLNI?=
 =?us-ascii?Q?zbo/IHgaQ52rqhNcWdDYIn4+cA5AqRhmsIsT8LxT8rgqfv0VUXsA+0XLePZ3?=
 =?us-ascii?Q?1NodeYibS41cE/E7jlM1e84NCV6q0uFKdQY+PCbrkfdHgCqVvr7GbQTX6wzB?=
 =?us-ascii?Q?n/KDhGHJRCiaFD6We7Y3VkDaqSJi5EhDkSBX1gEZKgflwAUNkisWIiqfgzYl?=
 =?us-ascii?Q?4a3ZUlsWr722+VUQn9zRe2loSYEGfums+8y8uHtSc5ogqQTIykwKDcOlzDtP?=
 =?us-ascii?Q?lro5nAIhDnbW4fEJapsOb6QZ2ugS97iDHMcWMWNeYstGEErvci0g7+ypXErM?=
 =?us-ascii?Q?4RJ4sV21k0mbfbF7iwIe2lS1mCoGVkyDrGIHkPaXEY418eM2l0O+L88qhQJn?=
 =?us-ascii?Q?pG5qL/1GO3Y=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pvNYVTAa2pxFnc0hTZ6t3RtRFTcINjtOrrB4xTtC3txSdA6zGmAZA+UP9fd0?=
 =?us-ascii?Q?GTOPZB7MedenNI4fS0eVnYKkKX+qeEeSmttMvby+IPYPbT98/Md9o/8vrJw0?=
 =?us-ascii?Q?DAOVBSnCU0Sx1vOLynEJUdP9ALGTxezhSX6OhiJU6y3LkhR7uO/gqEDJTJHd?=
 =?us-ascii?Q?kzA4m1Y7XNCKYivlmcqmfKapVmE9qM9rz60cHjIAZB00mnto1tnoWUzTzTOv?=
 =?us-ascii?Q?akxl/pMDCpxj/Ze4HoPtAFIxJ5gYINol/LQr6YLjks64ZagZORp4vJs506iO?=
 =?us-ascii?Q?FvN/Rml08+NJq9U6pQ2Afv4vwbXABdpTNI+jSc+tQX6kSaCKgT0tCmFOmvql?=
 =?us-ascii?Q?LWbfT69dEcyQb8GaLz8d6hshkfxZqC6VOGE7dldslb3w4qoBquN3VapFi9D6?=
 =?us-ascii?Q?yHbpnVMQrH4HmCCPkCwhoA4EwZpf/NbxmJeAxKTcMXqpkfFCRGd/sF4gVoGI?=
 =?us-ascii?Q?/QlTYK1E1P+Po9fQh5rlWRL6TJnjgHlOT9+UzgjaVcr7GmHZ0IoIg/mB723R?=
 =?us-ascii?Q?O5VRUT8OZA+vHNRq1NvumjXWadO8ZZVwAsLK/Z0SzNhrXoaEcQpVaEJP47Tu?=
 =?us-ascii?Q?GPx3JC7oRZIEcyTqIw9tLTyPTWgR+pUgrnGsiitilGB8wOE6/0ZUYwe5KWkU?=
 =?us-ascii?Q?HZn05UAXiFdxIU72L+4g/f16zIUoSzvTNddA2VMsrx6H7r1DsbcYjvGmR2j4?=
 =?us-ascii?Q?+sKfFfqIFX01Hqp73nrND8mvRln5MgntHpnm5LXXcZ9K4MzxLXFMe33IyLKj?=
 =?us-ascii?Q?ZmzZsFAQq3sC6LH0rcCuZLlgFp2X6ylBN8EIXbpEwaL55W2xm8Jgr0gl8P85?=
 =?us-ascii?Q?593FcHlG2DG8yY+/W7Ed8cOL23YkqYIkvd720c8BrUPHl45tIzK9KL84i+/2?=
 =?us-ascii?Q?rd6sYxlMREBST87NfDWWbgkbMHOZurk9kjgvrudT19pDmWUFreqTyHTPdgD5?=
 =?us-ascii?Q?pQJ21p2w2GG0mN7vZTEnN48gDP+cpk94wlFVtFfXlwIVIX3jfY1Rzcj0tt+T?=
 =?us-ascii?Q?HoJpa29YoYJh+wrodhQmOU5zYa/A4Cqs4xGVay/A3fxUsM40921Z4UbEu1Vh?=
 =?us-ascii?Q?MoiTsr3Ma1CplWZt7YhzVvsWMYwW20rCZ1UzFfiGh/Ibw6JqqztJB5+ZnuV4?=
 =?us-ascii?Q?0SsLA84e8aZN3uvZeZh9tGDAoFltbZf6vYsxlfZieNzE6n3S7gmX1KSZQI+N?=
 =?us-ascii?Q?jVDHCsfv4ZA3IiZLoKUE9g1caWh6h5l5CuP3u+qT42phPrrdxCMeITNA/E7q?=
 =?us-ascii?Q?vWD05WDgz4MN9Usxx0oJNQycoVZgkQBTkqSpMbqIbvfx11HaAf+liL1r281Q?=
 =?us-ascii?Q?gyo96YxSrGZcKVTTH67tTmb098mqh1CjzT0S2UE3zu6DCr7T00LNL7Rqcs7k?=
 =?us-ascii?Q?s2Fjp9C9dOfK4WC7/YwKfjJYtmABqe2muKm1JwMSQkYmzFbqDvQuk8gCjKNU?=
 =?us-ascii?Q?VvtjqqpjetHghXkzu/Nx0NdI+aQZaXRlaUh6J5njmku4SATyGItPXcrdG6RA?=
 =?us-ascii?Q?w7zE69d8Khj2O7UZTY5jd2bpQ9WqBnH4FhLdqGM34FdTvDupGCas27NgPP+V?=
 =?us-ascii?Q?QBsOHJYYE8WLeDQWorHT1Dnr+kWjgvwrio1ORI9M?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f5735d0-acea-4d81-0b7d-08dde541cdcb
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 08:14:54.6883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y2kvtjv5rquCx02w0GQH9vxeSEaPT5mEQh5Du2N4XIXjWeLvNrWBe1wKGYp8nD4nDotkQBF8rlEKNK8YChIS3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4793
X-OriginatorOrg: intel.com

On Tue, Aug 26, 2025 at 05:05:11PM -0700, Sean Christopherson wrote:
> Drop TDX's sanity check that an S-EPT mapping isn't zapped between creating
> said mapping and doing TDH.MEM.PAGE.ADD, as the check is simultaneously
> superfluous and incomplete.  Per commit 2608f1057601 ("KVM: x86/tdp_mmu:
> Add a helper function to walk down the TDP MMU"), the justification for
> introducing kvm_tdp_mmu_gpa_is_mapped() was to check that the target gfn
> was pre-populated, with a link that points to this snippet:
> 
>  : > One small question:
>  : >
>  : > What if the memory region passed to KVM_TDX_INIT_MEM_REGION hasn't been pre-
>  : > populated?  If we want to make KVM_TDX_INIT_MEM_REGION work with these regions,
>  : > then we still need to do the real map.  Or we can make KVM_TDX_INIT_MEM_REGION
>  : > return error when it finds the region hasn't been pre-populated?
>  :
>  : Return an error.  I don't love the idea of bleeding so many TDX details into
>  : userspace, but I'm pretty sure that ship sailed a long, long time ago.
> 
> But that justification makes little sense for the final code, as simply
> doing TDH.MEM.PAGE.ADD without a paranoid sanity check will return an error
> if the S-EPT mapping is invalid (as evidenced by the code being guarded
> with CONFIG_KVM_PROVE_MMU=y).
Checking of kvm_tdp_mmu_gpa_is_mapped() was intended to detect unexpected zaps
like kvm_zap_gfn_range() between kvm_tdp_map_page() and tdh_mem_page_add()?
In that case, TDH.MEM.PAGE.ADD would succeed without any error.

But as you said, the read mmu_lock is dropped before tdh_mem_page_add().
Moreover, it still cannot guard against atomic zaps.

As zaps between kvm_tdp_map_page() and tdh_mem_page_add() could still be
detectable through the incorrect value of nr_premapped in the end, dropping the
checks of kvm_tdp_mmu_gpa_is_mapped() looks good.

> The sanity check is also incomplete in the sense that mmu_lock is dropped
> between the check and TDH.MEM.PAGE.ADD, i.e. will only detect KVM bugs that
> zap SPTEs in a very specific window.
>
> Removing the sanity check will allow removing kvm_tdp_mmu_gpa_is_mapped(),
> which has no business being exposed to vendor code.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/tdx.c | 14 --------------
>  1 file changed, 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 66744f5768c8..a6155f76cc6a 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -3175,20 +3175,6 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>  	if (ret < 0)
>  		goto out;
>  
> -	/*
> -	 * The private mem cannot be zapped after kvm_tdp_map_page()
> -	 * because all paths are covered by slots_lock and the
> -	 * filemap invalidate lock.  Check that they are indeed enough.
> -	 */
> -	if (IS_ENABLED(CONFIG_KVM_PROVE_MMU)) {
> -		scoped_guard(read_lock, &kvm->mmu_lock) {
> -			if (KVM_BUG_ON(!kvm_tdp_mmu_gpa_is_mapped(vcpu, gpa), kvm)) {
> -				ret = -EIO;
> -				goto out;
> -			}
> -		}
> -	}
> -
>  	ret = 0;
>  	err = tdh_mem_page_add(&kvm_tdx->td, gpa, pfn_to_page(pfn),
>  			       src_page, &entry, &level_state);
> -- 
> 2.51.0.268.g9569e192d0-goog
> 

