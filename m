Return-Path: <kvm+bounces-65543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 70E39CAEF7B
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 06:49:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2738F3024BE3
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 05:49:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8B3031ED91;
	Tue,  9 Dec 2025 05:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a7ACpsA1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000D031ED7D;
	Tue,  9 Dec 2025 05:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765259346; cv=fail; b=XZO4o8HuOomIr1vk0RzHSCoSVwKmiN0hrQ3KAJn817boes2SD/WFQ4iebNgAg6nXiMoRo822zoOilRR5XxAbZ5KfIXiKgEWPQLYDbjPjvtqqH1NNZTMoUMYCaiflwLxSqe43NjQBVx/zL5iGLYc+P3lD4xCD3KHQJEvMyzWXeCQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765259346; c=relaxed/simple;
	bh=j4/NDTMhzQuX3e0fCAuTn86I0ve6cNqGh/kQIxyIWSI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HpCrR2qDj45+0iOSj4OEalizb7ymyxQm0raABOv42WTd/PWG/SVE1Mjs1uRY/9txzh3xesgsUVnBD7fJJ7At5Q7+FHD6X4wjgvyG9qWHh3OHMRfO1APqUli9GeQ9yreQpNKid5aJNEKXYOGpchsGz7QTYBnJpjObQjriGhvQRzo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a7ACpsA1; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765259345; x=1796795345;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=j4/NDTMhzQuX3e0fCAuTn86I0ve6cNqGh/kQIxyIWSI=;
  b=a7ACpsA1SeKj5YoKKDYOeso0qprQ22HJtfGD2tYdrRuTm/iR1i6D7XZF
   6B5X/COD73A0+eUxZpLrv4BKrtYcPZXCAJyfbPCFW638ZrqwFtwliW0Mp
   1ZODkAz3xBHFEUXJ1jfhdl6uY7Ve2X4/0jFUwOJLqDpOho7Ef4aldGCFF
   KG3Sq06xiFY15SM9Ntq405qePFNd9zh7knlk9m+l0HUxkAkIDSQ80hCq8
   KSU36irXnROqat7arvTBGn78yvkWmt5EuqPQU7jie2BmvAmWR/Ldrh5mD
   faD/u+uYTzJv/79Yb+Kku/i+bI1UYzGoktdq/qbuqgvAEDyoflGgrSmhv
   g==;
X-CSE-ConnectionGUID: yY/nzqukTyePU51QUsC14w==
X-CSE-MsgGUID: ekWYTeG/SnGo+Nr3RD9l8Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11636"; a="67290470"
X-IronPort-AV: E=Sophos;i="6.20,260,1758610800"; 
   d="scan'208";a="67290470"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 21:49:04 -0800
X-CSE-ConnectionGUID: 0+Ly5cvkRDWmacf3bs2uOQ==
X-CSE-MsgGUID: ujNc6lHFTFGUQWk9oMndSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,260,1758610800"; 
   d="scan'208";a="200609639"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 21:49:04 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 8 Dec 2025 21:49:02 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 8 Dec 2025 21:49:02 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.46) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 8 Dec 2025 21:49:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=chSwprdc/L21/ZyrSqny+E2hwz4b4YbvQegYcbkI6KI5++bQvv+6IM5DaJJcaLcCDx0LuAB5GSqJieILtagrA7434xx1Iy2RBwemqCmJUtREaCungP/2/HjzYLpTu/VvWG5W+M8NQwjOob60P4CC95uqIaXpbaRRB/oKGuU6TsbsKFlwWJ/GkBoqrWOlYTtXE94X8tdKxR3TgaVNXfWVLjpG1Kt8nyI6oV/ve8euQbuahzmdbTNqaAMNO4r/ja6argoCqfORxiUKRiiZlNBkb/RI6PIGI88aXAfjWnkOCTFDk+VOHYRzFL2PEht0UPa9hyCV7KAIl4DajLN3f8quUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JXLMyawvm/+12EjmlyJ+qnRCCZctu8PW7aM02Xgre/s=;
 b=LSTk05hSjpk5qskv+DaBJSxDIqwWfgC6v5EC1Eridyy01HlxO9AMr/4SHZlgy0IWzMGBcxSjRNrLyPPidnXrxh2HVofqR5UdWQZBweOVLtBwmbbZ6txJvhPF8cCbqTwRhx/dUTa8IpKikUFIrrIqVWXJQdzrAdFQn8To7GZcT2SH6pWIbz7JOXv8CArAZZuODrz1NOnMqEKfd5Kofh8OS8JjYTfv/wSksFFl3ShIkBYQv/XjUct27FKXDV4R1K0AFa4vWUMxjqcijAW/zY/hsJeE77EQ8Ai5hfkgS+td64d6iBYxO0bccPRgO9NeUliu7xEl/FqsUSOF/q+ZRKJloQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by BY1PR11MB7984.namprd11.prod.outlook.com (2603:10b6:a03:531::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Tue, 9 Dec
 2025 05:49:00 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9388.013; Tue, 9 Dec 2025
 05:49:00 +0000
Date: Tue, 9 Dec 2025 13:48:51 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>, Dan Williams
	<dan.j.williams@intel.com>
Subject: Re: [PATCH v2 2/7] KVM: x86: Extract VMXON and EFER.SVME enablement
 to kernel
Message-ID: <aTe4QyE3h8LHOAMb@intel.com>
References: <20251206011054.494190-1-seanjc@google.com>
 <20251206011054.494190-3-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251206011054.494190-3-seanjc@google.com>
X-ClientProxiedBy: TP0P295CA0043.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:4::18) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|BY1PR11MB7984:EE_
X-MS-Office365-Filtering-Correlation-Id: f6c0e914-daa3-4c7e-e0af-08de36e6a6d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?mGSPI9/1KsjdiDBSgVSVYRz7WIIP+MAKh6VkHDOjGO4pioK9yqZ6RIw6TlU/?=
 =?us-ascii?Q?1HTm5G5W64Oe0HY5BMbTLduV4KC+7yA/V9icKqSZrXHj2KGWMlaMxo8Hc76I?=
 =?us-ascii?Q?ncIlJ4rcwWxnoRDPARGg9SNMxdL5DL6kKdOH58xY8TDmkWiqJg9lbI3zgbj+?=
 =?us-ascii?Q?mK9/yx0fQi/6NEjtNgpZAUkSBtM9JpWWKjhkOyWdHl+/9LeltBhRaXLhtFa+?=
 =?us-ascii?Q?p4ntRkNoeAJph0AUMH8mJhBf6s5D0qpM9Bn3GuHtwEwtB9QM2Op0p1GCyTkT?=
 =?us-ascii?Q?nbEUg4IB1kePqq/RBx4BCMVcBuosTkCtIUbzPMQJMRmdumJYj7nUzE1fGGgi?=
 =?us-ascii?Q?1U/U7nvmC/kmN4X6oHJ8/KPMSl17EzZ4l0x+2vhjs1jBL7Y6yZxIJx0+HsQJ?=
 =?us-ascii?Q?FEb4GxBOjjmsw8hMZrKGB4XjZa+SU+PPv6SXJ8O+XPSYqkXj3iF+ozUsXlLZ?=
 =?us-ascii?Q?lh3TOE4KbRwQ7WKzTs+fCIqdBbabDuFy9YwrCyOcwuckwtF402Rw7jJKC0os?=
 =?us-ascii?Q?wzVEWDUEE5EThIne1JlNLBsF9i1ADIbxSmxQVbZhFfsFHR5J7tN7drutI9hI?=
 =?us-ascii?Q?7LeHm04PSLnNp0TP2mr/1+hDeL024lqL1jtjr7R/YgFBV9mhLDNkd31TMqJN?=
 =?us-ascii?Q?H12foRVKGfByDE+xhwnWwjr5gIYPWNEvx0MPaU1kYWvZFNf9R0IqFSkwAafO?=
 =?us-ascii?Q?b5+G4yxSwNyLwlafPp6qiS8JxcoEGF8aCE0QxxE7PCgEPTyc0ZYe8Ba7zm00?=
 =?us-ascii?Q?7z4mKPepXqLGJv2rNJC5Py9KtTwkC2pfgfnuAWp/+tNB8o2zM2tkhD6n0zh+?=
 =?us-ascii?Q?axnmjAvlJBNvCqpxq6g7H24wYzh21m4D4zJ1PmwIMnsFOklJ8OgmMLgFlWRj?=
 =?us-ascii?Q?2fge3U1w/G2JDRIu5/3beTwsF4SJ97I2QdzAv0vfGZQK7ON63lKBmsK6UlcN?=
 =?us-ascii?Q?xqS8dKLA5rc/4msFfrFAU9dnnir7JJmlg3EIU2K9znLNhnEXHAo1BBFebhyA?=
 =?us-ascii?Q?ghNX/iBYnQJg5srsdjVSHNQp9Y0H/bL4cR/ILwyYvG6QmxGLfWBhYgs0LPdb?=
 =?us-ascii?Q?htDSSljdEvfgIEu8yMrUqgcOj2KKSgeEdL4sKerW4juQ+eQ2h0l21zGPtalW?=
 =?us-ascii?Q?UXnF6ol9PDg2MiuHCpFRf4T2WqKW8pwCgagAKatmMRzOxSSy+8fHlnjJmHKY?=
 =?us-ascii?Q?uyVrsmSN335Ef0ytxpxwurRfUVDEoqdVJd92ZXxxfQToUOWEvGaY4SQTvH55?=
 =?us-ascii?Q?yZX8qgNx+OVSRNq/BvivnX9kxkGZ+IzU0SPMiQqpSIpTBWIjh3TOzXuFujvc?=
 =?us-ascii?Q?s0yh4GfKSOS4sakfNdJOyDG56uLl0cnAXDU4q/uZAPDdEVdnMopS6AHCUf3S?=
 =?us-ascii?Q?tWCJT+kzAKXe9ENdl/8zESBTFds/vPIJADSI11edPRAik/mjlrT8uuxqCkIg?=
 =?us-ascii?Q?9BcpVNYABkyyt62EGdaTvzHPF/05C8Fn?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G3cK8w5zCqS4yYrq3O9nKF6oZ5aSF8yZZJUTIOdqgaUuVE3RPpf2inDtsJx8?=
 =?us-ascii?Q?lltEYZWVfiBc21t0u2KjAAj0oKSLahr6x8HFgid2AE4wETuyJQjgHnls9cOe?=
 =?us-ascii?Q?bWW7AkN7S6bj2uOesPsCeq2RWJEaDbAhnONZ83ZtdcnjEJWeYcwZga8Vu/xV?=
 =?us-ascii?Q?UkzsCCmFM94De94OQQKsa0Ds3RJ7aI6n5eoyCE3n1J8ONxIcpUpZFvqLvtJX?=
 =?us-ascii?Q?cPEwPknMWvbHnxE71wc+ZayWKqdCId2OqSKGmhVyZSmtCTT9dYNUXK8BmxRc?=
 =?us-ascii?Q?zfa63EG60CbtcHa1R0nqePX8XjXnm+qkdLh6GDk02EoTUIl9n14dsl7Rkgtv?=
 =?us-ascii?Q?uNhUqiJqW+YP10Q8nAQdowPPPhD5pQ0sahkbtv14C0S07aOLPbA5QVjnXdYO?=
 =?us-ascii?Q?INMR6BBh1NtsncFLTeTGVz4+70KPOdsyAhk41Joie4hUxiAQEUHKgVZa9bf/?=
 =?us-ascii?Q?GrSXO288gxDzI1WBa7sYbtlX/LE61Z8aJRDhUn+wCgerHTTGGeV51dDIdCix?=
 =?us-ascii?Q?tEbJRDMGM6lYnx9p7HvOBYJ+rGbLbJ8S/UHsmkcCPLLngJ95h5egmFW0MwIH?=
 =?us-ascii?Q?UblUSDPkjtr+74bmoI6D6PzkvTdUao0jAMScyKz6aOQTfbuM4cRznCg1FYGG?=
 =?us-ascii?Q?vPPKWjwo5o12/+PnDiE1swjqCd0wr9GD6LD/4TS4sUJ1LkVkj1gPzcNZLXNE?=
 =?us-ascii?Q?dw+TJZ4yOXJ1ZlzAx1Y3TNnuHtATLNrDjDeDknU9i/ERjgk7JfoUir04u/ea?=
 =?us-ascii?Q?ld4NTEKnvKYkGRKZLfjKa8kuey1zILGTw5rMLlogeX0AmwNP3qM8i8+wNQm2?=
 =?us-ascii?Q?2ZIRNfC1QR0Uy319mGELHO4UllIDfdhnr/GJa62aHPaJLWaT9f+SuER/8qV2?=
 =?us-ascii?Q?eGG2VPM+GUshFop1Mo1xJuVu6MPpK+nCzAcuN2c6LX8in6aWwZST2MkS/YP6?=
 =?us-ascii?Q?iyaaRolb+lcjuGeg7P4ZjmTLdYx3iN3Vodp7sBsxg6/T6c8sWeqfq0CpLqzB?=
 =?us-ascii?Q?w2tU1XsD6HiZWUamFPHqe4oXErN0rJN8tGxvWwLbBa/fZQr+srJLpbw/SOvn?=
 =?us-ascii?Q?ZgAcRdcelwGWtkGYf1k6Y5PDKlTjNuT/Nw1KtEG0C/pPQOiH3CvlYs8y+t/N?=
 =?us-ascii?Q?EvFIJ52XyrCyZ40dIN/wk1LGWy9izpcBpFS2+r6k339WrfPX2aGqocx7pAv0?=
 =?us-ascii?Q?FGu74An/ynrlZ6EdtBxleQybrQGiJDipi9rHNqF2bPGM1Kb7u6F2EpXrirLU?=
 =?us-ascii?Q?IeRWuclqNJerjvobMyh6Lk/PNNdpPiICmtFECvsq0yaA7yhl0fNUU+53Ebqe?=
 =?us-ascii?Q?0gw9VVdphRmbsBV+zgXQrWyPTds1VfYP2cF/eIBrxK5hdmR0zZdhUPrgn2MD?=
 =?us-ascii?Q?Tk+biHrMgXBhrexJ9x6qUp9w2MBo/MFuJGU8PN99c8tkEhDLLFrcc9BW0lrB?=
 =?us-ascii?Q?wwoYKqdHpa5n5cafSYhOhjHI6ugdXR2zbG7HCYfh5afvOHM4LhvIHvRBtOEA?=
 =?us-ascii?Q?kuxFJRGdtUgLPZbZuGWaSI8RgOtR4XCndJD04e2dGcEsw0QiEiuA0fAMpUrW?=
 =?us-ascii?Q?xFWZSVKzKGK+sJZ6NceBqkUVIUa+7JeOISu8AYwv?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f6c0e914-daa3-4c7e-e0af-08de36e6a6d9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 05:49:00.4584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L/qCoMoEX+GTVc44etaaL167qJGjz1JLGoS3HpDcW4awR25/6QSBn6XTVtbt4iFlaOS9dUmMhjLeFBhndzh6Eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB7984
X-OriginatorOrg: intel.com

>--- /dev/null
>+++ b/arch/x86/include/asm/virt.h
>@@ -0,0 +1,26 @@
>+/* SPDX-License-Identifier: GPL-2.0-only */
>+#ifndef _ASM_X86_VIRT_H
>+#define _ASM_X86_VIRT_H
>+
>+#include <asm/reboot.h>

asm/reboot.h isn't used.

>+
>+typedef void (cpu_emergency_virt_cb)(void);
>+
>+#if IS_ENABLED(CONFIG_KVM_X86)
>+extern bool virt_rebooting;
>+
>+void __init x86_virt_init(void);
>+
>+int x86_virt_get_cpu(int feat);
>+void x86_virt_put_cpu(int feat);
>+
>+int x86_virt_emergency_disable_virtualization_cpu(void);
>+
>+void x86_virt_register_emergency_callback(cpu_emergency_virt_cb *callback);
>+void x86_virt_unregister_emergency_callback(cpu_emergency_virt_cb *callback);
>+#else
>+static __always_inline void x86_virt_init(void) {}

Why does this need to be "__always_inline" rather than just "inline"?

> static void emergency_reboot_disable_virtualization(void)
> {
> 	local_irq_disable();
>@@ -587,16 +543,11 @@ static void emergency_reboot_disable_virtualization(void)
> 	 * We can't take any locks and we may be on an inconsistent state, so
> 	 * use NMIs as IPIs to tell the other CPUs to disable VMX/SVM and halt.
> 	 *
>-	 * Do the NMI shootdown even if virtualization is off on _this_ CPU, as
>-	 * other CPUs may have virtualization enabled.
>+	 * Safely force _this_ CPU out of VMX/SVM operation, and if necessary,
>+	 * blast NMIs to force other CPUs out of VMX/SVM as well.k

								 ^ stray "k".

I don't understand the "if necessary" part. My understanding is this code
issues NMIs if CPUs support VMX or SVM. If so, I think the code snippet below
would be more readable:

	if (cpu_feature_enabled(X86_FEATURE_VMX) ||
	    cpu_feature_enabled(X86_FEATURE_SVM)) {
		x86_virt_emergency_disable_virtualization_cpu();
		nmi_shootdown_cpus_on_restart();
	}

Then x86_virt_emergency_disable_virtualization_cpu() wouldn't need to return
anything. And readers wouldn't need to trace down the function to understand
when NMIs are "necessary" and when they are not.

> 	 */
>-	if (rcu_access_pointer(cpu_emergency_virt_callback)) {
>-		/* Safely force _this_ CPU out of VMX/SVM operation. */
>-		cpu_emergency_disable_virtualization();
>-
>-		/* Disable VMX/SVM and halt on other CPUs. */
>+	if (!x86_virt_emergency_disable_virtualization_cpu())
> 		nmi_shootdown_cpus_on_restart();
>-	}
> }

<snip>

>+#define x86_virt_call(fn)				\
>+({							\
>+	int __r;					\
>+							\
>+	if (IS_ENABLED(CONFIG_KVM_INTEL) &&		\
>+	    cpu_feature_enabled(X86_FEATURE_VMX))	\
>+		__r = x86_vmx_##fn();			\
>+	else if (IS_ENABLED(CONFIG_KVM_AMD) &&		\
>+		 cpu_feature_enabled(X86_FEATURE_SVM))	\
>+		__r = x86_svm_##fn();			\
>+	else						\
>+		__r = -EOPNOTSUPP;			\
>+							\
>+	__r;						\
>+})
>+
>+int x86_virt_get_cpu(int feat)
>+{
>+	int r;
>+
>+	if (!x86_virt_feature || x86_virt_feature != feat)
>+		return -EOPNOTSUPP;
>+
>+	if (this_cpu_inc_return(virtualization_nr_users) > 1)
>+		return 0;

Should we assert that preemption is disabled? Calling this API when preemption
is enabled is wrong.

Maybe use __this_cpu_inc_return(), which already verifies preemption status.

<snip>

>+int x86_virt_emergency_disable_virtualization_cpu(void)
>+{
>+	if (!x86_virt_feature)
>+		return -EOPNOTSUPP;
>+
>+	/*
>+	 * IRQs must be disabled as virtualization is enabled in hardware via
>+	 * function call IPIs, i.e. IRQs need to be disabled to guarantee
>+	 * virtualization stays disabled.
>+	 */
>+	lockdep_assert_irqs_disabled();
>+
>+	/*
>+	 * Do the NMI shootdown even if virtualization is off on _this_ CPU, as
>+	 * other CPUs may have virtualization enabled.
>+	 *
>+	 * TODO: Track whether or not virtualization might be enabled on other
>+	 *	 CPUs?  May not be worth avoiding the NMI shootdown...
>+	 */

This comment is misplaced. NMIs are issued by the caller.

>+	(void)x86_virt_call(emergency_disable_virtualization_cpu);
>+	return 0;
>+}

