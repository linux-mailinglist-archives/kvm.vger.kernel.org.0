Return-Path: <kvm+bounces-59899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DFFEBD347A
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 15:49:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A13F334C21B
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 13:49:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5526621D3EE;
	Mon, 13 Oct 2025 13:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mavOLCa2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E10E18C31;
	Mon, 13 Oct 2025 13:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760363378; cv=fail; b=o7EfipAFlDjIuBQxtgybsB//mDzFTo2U0hU1u/MWUb/t0wuyec7Je3I8Kpk5+XXy8xBBUkdiW61mnybaH/Jt5oLVJuqXyw0m2YnLne1Jgv9TFO3Y+G/inryoeHC2GKC5ra/7ge/bFuHrbnJLc04lEW1C2gVIhzOzuGJPX1G/TKM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760363378; c=relaxed/simple;
	bh=iQpk1BkjBhSApRzlQ8/niU1G+vZnx5DZ19MMY6jVYp8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ME0MUdn0JJdJZWcT70VyPO9GXqUF+t2gA2yYTlmjGBp25EGesjuUAXoM01Jmdh0JSuWwxI5YVVY94A86z7ZlUmWONPbhzg5SH+X/Lz4wG2TXMy8mDNfn4IrV1OFcpQhNIMJ9NR2sc8ahCP+FdpiRhz+GWb/9KFf8iHJFTIcC/0U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mavOLCa2; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760363377; x=1791899377;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=iQpk1BkjBhSApRzlQ8/niU1G+vZnx5DZ19MMY6jVYp8=;
  b=mavOLCa2TO4TFWt3cla461CGJHlntwN/m0Hnh4HAD8zRxud/QI9GClMX
   BUCcwo9H1f6mT7MvVc2HiLCgCQzf2mBlkSh1iulZ6XOP6thg+6BMyQ/OC
   lpd01NSGc1j48Yw9gmK4Jf//VJTx8xvMm0GSeSQFMeJ+xbYc5oQDGN3fk
   Mzi1b68/ZaT4vYlB0Qnw6Ff8/c6W4vyCMW86JSrIZCnHNImtD0Ng/TLmQ
   EFa20e7ku8nkGZHKbFFzPoJoJd7d/3zXbWCdDlNQzG1R9UKrf9v2E18QJ
   bweb/N5kPs01gXRcN6Q2wH62mJQjrNIDbPdhcWo8ktUb8Z9ufOfHZs8oC
   Q==;
X-CSE-ConnectionGUID: 7uQOVBEqQ5qjNSZ0gKQRYw==
X-CSE-MsgGUID: 5fSyLFX4SDOEHv/uS9pQZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="50060260"
X-IronPort-AV: E=Sophos;i="6.19,225,1754982000"; 
   d="scan'208";a="50060260"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 06:49:33 -0700
X-CSE-ConnectionGUID: BQXywzdfS/iml8bgKWyodA==
X-CSE-MsgGUID: EN8pKes0RnC7w5rCKCgaMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,225,1754982000"; 
   d="scan'208";a="182037413"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 06:49:32 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 13 Oct 2025 06:49:31 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 13 Oct 2025 06:49:31 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.0) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 13 Oct 2025 06:49:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=seOCpuch/yOQMDVkWNYGTgBu7OZsK0puDgtu+Uf+smmEb1oQjD6MdTe96gWbIla+GpnH8yFJhO3sKsr5lv47ifztZrT5tM0+XVp2tgtxRSmxqEHm1rkhdQE+PA8coO2owWWrQaIhxANGLxwewDnP2KuWsAvSVembhvTJ5n82zfR7rs/JYr6EJeK8g1591p4v2C+zZZ+i3REO7E1NWL0pXC3aef5vjPf9Z5L0EfXtvvcmZ+rxKVfL4TzlxYRAc/n6/Y13ancqoGUvuuLObY8kJOTzU8YdnFpubpDTvC+TobgOG/Xb/rtrR27+vAH9kYbC0SHnnqvaMfB9A45cXM4ntg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BA/yrC7/mpoPcSHgJWgoIYBGHkVZTQnz7SWoBRcJDak=;
 b=eFhudPODWPBrK/jATLLNfg/L6VvZC28s4GIZ6DnfmFIIl0hSCINXjLerQU2W8ijkk5r2GcJCBt8JvGy9T3322TfeC0sE7lRuHGxZy8FsCKzqP8paO/xIsGjunckY7Lnzi3U+TnwM6ps/lymnoBqXaKaZ9vS3Yh19XnoTXhpVEoAp4TQSPGkM1mGdBDo8tYtvqlyvc9sL0iSp8hl/We1w5Sdz0OWsONHGUr8VVip06Uv8TdbtEObzMgDhv1ztDq7iVOk7u314d/GwKpdPqRuvR4Zz/OlsrwmfGrHIzv0Pp2IIB1bdyMy1llpSrHCJS0QIH1WWq9E++Q3YzMJQzQMx/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CY8PR11MB7825.namprd11.prod.outlook.com (2603:10b6:930:71::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9203.13; Mon, 13 Oct 2025 13:49:27 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9203.009; Mon, 13 Oct 2025
 13:49:27 +0000
Date: Mon, 13 Oct 2025 21:47:38 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Xiaoyao Li <xiaoyao.li@intel.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH] KVM: x86: Drop "cache" from user return MSR setter that
 skips WRMSR
Message-ID: <aO0C+nOC6f+9L0Ir@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250919214259.1584273-1-seanjc@google.com>
 <aNvLkRZCZ1ckPhFa@yzhao56-desk.sh.intel.com>
 <aNvT8s01Q5Cr3wAq@yzhao56-desk.sh.intel.com>
 <aNwFTLM3yt6AGAzd@google.com>
 <aN/VaVklfXO5rId4@yzhao56-desk.sh.intel.com>
 <aN__iPxo5P1bFCNk@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aN__iPxo5P1bFCNk@google.com>
X-ClientProxiedBy: KU1PR03CA0027.apcprd03.prod.outlook.com
 (2603:1096:802:19::15) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CY8PR11MB7825:EE_
X-MS-Office365-Filtering-Correlation-Id: cf9c804c-325a-4d31-3cc1-08de0a5f5398
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?njPI7qJkiDb9vjxnQ99lM7HztzCjslIWjrS9ejWm7FGcq3n1NMFcq26aR/dE?=
 =?us-ascii?Q?nBmKdQeSfCUgQGtBZnyQPQU05x/qffJymuE6h+aiRKV6ZItpuQlXn+6jCNXK?=
 =?us-ascii?Q?Z+ZKe2mS2+b98KZ20xA95e8TXs+ETCiiESINbBwQnEewLt1rMbOYyd7aMzzL?=
 =?us-ascii?Q?TkseFAowU74yb2vpvUH0CijQBTrO9R1bfGSwNIpT4R8yqwRMKBXkxyui9FXL?=
 =?us-ascii?Q?omPplGihpZwRhiCY9vXjTaUGk3OB86NxU9cPvOMBpp7HOkdJpb57RsTo1q78?=
 =?us-ascii?Q?wmyWON3G8867FGYFqaLTQRdOKpKGabhSy1DLRoS6ymp6BxNyldGnmEKeWLxh?=
 =?us-ascii?Q?KEuQxHBk+EeTtNahzup7JKvJKFCqbyGUTnQmE/4n8Wt7P/Fs1/7I+AWSweSj?=
 =?us-ascii?Q?OhgW1ntoo5Nj4BgdC5hD8jOduYfI3cvH6dIMHXFStHj4ljeiS6q2WG2YDNnB?=
 =?us-ascii?Q?oQacxJVCpJN92nzsPr9wyyEfzbk6CQgxtyWfN/poXPKoma8Av81W5ZQVAmjE?=
 =?us-ascii?Q?d1KY8Kf+0yJMjL4Y24fgo2NFcT3F4B0uvmp5bzcqMknzxYWNuUbd0TZXNy2A?=
 =?us-ascii?Q?iS+7w88PhM6rEEQPvTAn9HhreAuGa0iPFyjX1+IqbotSrZz2vv8QHpfNWSCY?=
 =?us-ascii?Q?wGcgmiW3j5WgQDx1gC5ZPzQVUMDOdAcCPfhCkkuWhm1mwPbv7AC0hq5tFCMG?=
 =?us-ascii?Q?RkXEJQdVQ2cdHF2LBCSnRfHwK4EtZsmz+osVxvnSXph/V0h2kP5RryEHWHmP?=
 =?us-ascii?Q?+MIMkplfQHLtoEE/8gFDXf9j+PCCCwBwL8qrgjE808Tx08zvxpz5yfn1cQGJ?=
 =?us-ascii?Q?+9qizq3Sd1FIRgen4V1O3EeEW2RWxRzhf4y/snE//QJElEsLv4ct746vLMdI?=
 =?us-ascii?Q?Y+k/EqE9OjPHQQ+5oVlG51mhFICpe3xZl/df3fK7u8aoXp0CdSi8UytYHJuH?=
 =?us-ascii?Q?Cyx4J/1m+5KYLqL0tKNuD/g+e/FRHKxnIdFAKnWlpCzR7qo/sE5vUnHtLWff?=
 =?us-ascii?Q?XcS8Lyh6HCO5yCGW/MfAa8BPxBfgl8ar+vWcTQ6Ze4nbOT4X8B5ksGOuyISn?=
 =?us-ascii?Q?7XknExKkZXozEyXAYTVKl22RB48OIJ2itlbJFezMg2jHkwN1TV7L95MQ9qSw?=
 =?us-ascii?Q?QPnZNKcVMP9loRyKHUx7V/KjoHVFlb9907+HZ40kaSxFvJnFngO33HBOHrpa?=
 =?us-ascii?Q?trAO05+5RPq6j9G4tpUvXDnK22zl9Ep1TKrxEwHdJcaZjRmVNJbHKEGbWbhG?=
 =?us-ascii?Q?hIftY53jZXfsk6Qz+Fig5yTGl3ERCAvIilWpeKoloigJRYVjBzli6DtGWNvp?=
 =?us-ascii?Q?8DXI/k5xkbPC2wYkEyXIsYabjcDz37KsE4B4gbOSEKFAB/WLQHp61tclq/29?=
 =?us-ascii?Q?Pk08rR2X7Lk1Q7U1rIkf28BdV4UVj54iNAYjzFYPeVrggQpTJScw8m5xI087?=
 =?us-ascii?Q?c3i+R0irIjSaif16XwatAKGn253GlQdz?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tbgvyscG7gKn3/4QAQPjXoT3j20Yc0LsOLzLmI5PIAo+yp/8igGOYY7lsZc4?=
 =?us-ascii?Q?PbsXPwADiGl7iIKHfFkifgoI3K36/1D/St1vpZtANK/T1+7uXpdXHQOZ6x1V?=
 =?us-ascii?Q?GqU/QJoiiA6Qp9qk31daZ+VfchApY43WTCVh8vRX5NF8bsWP8Cz8kEw0HNxc?=
 =?us-ascii?Q?CnTB/AyUb/qxWDawH7gwELd01SVUnTrnPEdcCuFrqJyDDc7PvNcFcEuaW3uQ?=
 =?us-ascii?Q?JmbJ9oOmrNOVFX5BzYwwDsOtdsHoRKDPaNxk96ktOP2EnSuTJqw8nsDojcRz?=
 =?us-ascii?Q?T8gY2bjyUVg/euKPrDjnnlw2tTp2uWVIL+k3Wk0Mo3RFuoQa15Qd5m3LIlao?=
 =?us-ascii?Q?TIikZ6CQ6mMA0JcJQHMwOQTlYw6qEZK8eff20bIXw1IfQPiIMpzPcwTBz9I1?=
 =?us-ascii?Q?bDAIutI86mOWvEqvPDx0gnR7BeZnhFdsxoGwfrkaL4C2PBmMiizghVkqF4tX?=
 =?us-ascii?Q?zccWHNrGvsj8JAkAP3CPT/Ik2w095doUgEhl5vpf4S160Yu5grUnOqvzrOD6?=
 =?us-ascii?Q?DZq5ae4wkZiDgDKOPbr+JA4mF9b/TjIYycRp7sJw9PSj+NEosTlv3q+UW/j2?=
 =?us-ascii?Q?fJHZBq4AS3vE+hDWuvUB4RVfv/zYnYSzhENWzUtKKenwWthzDAyOw4T9dnMA?=
 =?us-ascii?Q?A4/M/IAdDK4PeV8Ljq7UjhxD1CIX9CtAedSsVAQO2E/wLAW3/O5Lar9yZbWX?=
 =?us-ascii?Q?5qZlwlNjF5cIU8goipJ0NCz/Lzil4PO0jn5ZDLE73imjrz6SbFkbvILGmME1?=
 =?us-ascii?Q?Dtw7HAxQ+0CjZ44Fg7QN+8nBt1ZA5c8Ld36x9PtYylbKD/doCKR+/QIdyZfV?=
 =?us-ascii?Q?xECbaY5JKtVGlP7VL3X1PxWtNTvMtj7oDz/Dg12P9GhSrgZKKfydJ2oQZeOn?=
 =?us-ascii?Q?R9BAd1xrbt8Lji+gicvCEPiTl6/+XMu4eOvbDSFhxVLPCTbw/YYAfBdAR7Zj?=
 =?us-ascii?Q?8y3Sf5DrAbAc3pI34D3Z9xtjf3GiYMT8wOOyAHSkSU/suaUh1a5vlPtNGV24?=
 =?us-ascii?Q?SHOu5ooN6TvzijkxziRtLUDir/FvViaoA8wUGyPVOJlTXtCbx3YEsTjqlts4?=
 =?us-ascii?Q?KOTyewVLFAKgyycaE6xfjbG2pS8+DKxRD1TXfhH6FqJN2bz+rP6X8H8d2I94?=
 =?us-ascii?Q?m1jv4IIYexgSHGdhznVM5TECHq7tbaEizDYpugz8VTDntIEyc1l33ju44WYI?=
 =?us-ascii?Q?N7SwI32krgHH74WzqwTogCoAZpxePyYkgZqo7A7VtKafOH0tzRmYCWPlbHPC?=
 =?us-ascii?Q?Wr9upcb6QxX8JsfeG4ZlRSaWzh9WYqBgvd1OLFi/eHz6BC4NOslXkLHa2Yg2?=
 =?us-ascii?Q?mevFzIQV9r2yMdEv5yK82icgicbj/Uib73PlTDr6naIwRBHyS6FEJCb0je8A?=
 =?us-ascii?Q?GUreQMCRrt0fMW5SEiwsDa9J4pn08Bt8Pq1dF3WBf6h86rNs5GBtmEWeYif8?=
 =?us-ascii?Q?gDuXnakJCTDNAqKF8P74LAbIppaO910maZlrlhU1ptaDZvkEfx9dJuiha4IC?=
 =?us-ascii?Q?CTBdbcx3q/tYGSlt2hUC6O+bOxZEOLod3NOc7FDrSraCI2gzVAMnU98x80IK?=
 =?us-ascii?Q?yikc5FrIgDWeVu5/Ghk+uVeGzrSWb173fnXgOFPM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cf9c804c-325a-4d31-3cc1-08de0a5f5398
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2025 13:49:27.6581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kNeRrSp4BeIsG19kyfuifzpyD76CCeIklQWGQ6n8bNpRylqxCVSl3+RO0I9MLp3HMSAar3hWRTBdX21z9EBbCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7825
X-OriginatorOrg: intel.com

On Fri, Oct 03, 2025 at 09:53:28AM -0700, Sean Christopherson wrote:
> On Fri, Oct 03, 2025, Yan Zhao wrote:
> > Sorry for the slow response due to the PRC holiday.
> > 
> > On Tue, Sep 30, 2025 at 09:29:00AM -0700, Sean Christopherson wrote:
> > > On Tue, Sep 30, 2025, Yan Zhao wrote:
> > > > On Tue, Sep 30, 2025 at 08:22:41PM +0800, Yan Zhao wrote:
> > > > > On Fri, Sep 19, 2025 at 02:42:59PM -0700, Sean Christopherson wrote:
> > > > > > Rename kvm_user_return_msr_update_cache() to __kvm_set_user_return_msr()
> > > > > > and use the helper kvm_set_user_return_msr() to make it obvious that the
> > > > > > double-underscores version is doing a subset of the work of the "full"
> > > > > > setter.
> > > > > > 
> > > > > > While the function does indeed update a cache, the nomenclature becomes
> > > > > > slightly misleading when adding a getter[1], as the current value isn't
> > > > > > _just_ the cached value, it's also the value that's currently loaded in
> > > > > > hardware.
> > > > > Nit:
> > > > > 
> > > > > For TDX, "it's also the value that's currently loaded in hardware" is not true.
> > > > since tdx module invokes wrmsr()s before each exit to VMM, while KVM only
> > > > invokes __kvm_set_user_return_msr() in tdx_vcpu_put().
> > > 
> > > No?  kvm_user_return_msr_update_cache() is passed the value that's currently
> > > loaded in hardware, by way of the TDX-Module zeroing some MSRs on TD-Exit.
> > > 
> > > Ah, I suspect you're calling out that the cache can be stale.  Maybe this?
> > Right. But not just that the cache can be stale. My previous reply was quite
> > misleading.
> > 
> > As with below tables, where
> > CURR: msrs->values[slot].curr.
> > REAL: value that's currently loaded in hardware
> > 
> > For TDs,
> >                             CURR          REAL
> >    -----------------------------------------------------------------------
> > 1. enable virtualization    host value    host value
> > 
> > 2. TDH.VP.ENTER             host value    guest value (updated by tdx module)
> > 3. TDH.VP.ENTER return      host value    defval (updated by tdx module)
> > 4. tdx_vcpu_put             defval        defval
> > 5. exit to user mode        host value    host value
> > 
> > 
> > For normal VMs,
> >                             CURR                 REAL
> >    -----------------------------------------------------------------------
> > 1. enable virtualization    host value           host value
> > 2. before vcpu_run          shadow guest value   shadow guest value
> > 3. after vcpu_run           shadow guest value   shadow guest value
> > 4. exit to user mode        host value           host value
> > 
> > 
> > Unlike normal VMs, where msrs->values[slot].curr always matches the the value
> > that's currently loaded in hardware. 
> 
> That isn't actually true, see the bottom.
> 
> > For TDs, msrs->values[slot].curr does not contain the value that's currently
> > loaded in hardware in stages 2-3.
> > 
> > >   While the function does indeed update a cache, the nomenclature becomes
> > >   slightly misleading when adding a getter[1], as the current value isn't
> > >   _just_ the cached value, it's also the value that's currently loaded in
> > >   hardware (ignoring that the cache holds stale data until the vCPU is put,
> > So, "stale data" is not accurate.
> > It just can't hold the current hardware loaded value when guest is running in
> > TD.
> 
> Eh, that's still "stale data" as far as KVM is concerned.  Though I'm splitting
> hairs, I totally agree that as written the changelog is misleading.
> 
> > it's also the value that's currently loaded in hardware.
> 
> I just need to append "when KVM is actively running" (or probably something more
> verbose).
> 
> > >   i.e. until KVM prepares to switch back to the host).
> > > 
> > > Actually, that's a bug waiting to happen when the getter comes along.  Rather
> > > than document the potential pitfall, what about adding a prep patch to mimize
> > > the window?  Then _this_ patch shouldn't need the caveat about the cache being
> > > stale.
> > With below patch,
> > 
> > For TDs,
> >                             CURR          REAL
> >    -----------------------------------------------------------------------
> > 1. enable virtualization    host value    host value
> > 2. before TDH.VP.ENTER      defval        host value or defval
> > 3. TDH.VP.ENTER             defval        guest value (updated by tdx module)
> > 4. TDH.VP.ENTER return      defval        defval (updated by tdx module)
> > 5. exit to user mode        host value    host value
> > 
> > msrs->values[slot].curr is still not the current value loaded in hardware.
> 
> Right, this where it becomes stale from my perspective.
Ok, then though after your fix, msrs->values[slot].curr is still not matching
hardware value in stage 2, I think it's harmless. 

> > > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > > index ff41d3d00380..326fa81cb35f 100644
> > > --- a/arch/x86/kvm/vmx/tdx.c
> > > +++ b/arch/x86/kvm/vmx/tdx.c
> > > @@ -789,6 +789,14 @@ void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
> > >                 vt->msr_host_kernel_gs_base = read_msr(MSR_KERNEL_GS_BASE);
> > >  
> > >         vt->guest_state_loaded = true;
> > > +
> > > +       /*
> > > +        * Several of KVM's user-return MSRs are clobbered by the TDX-Module if
> > Hmm, my previous mail didn't mention that besides saving guest value + clobber
> > hardware value before exit to VMM, the TDX module also loads saved guest value
> > to hardware on TDH.VP.ENTER.
> 
> That's not actually unique to TDX.  EFER is setup as a user return MSR, but is
> context switched on VM-Enter/VM-Exit except when running on ancient hardware
> without VM_{ENTRY,EXIT}_LOAD_IA32_EFER (and even then, only when KVM doesn't
> need to atomically switch to avoid toggling EFER.NX while in the host).
>
> I.e. msrs->values[<EFER slot>].curr won't match hardware either while running
> the guest.  But because EFER is atomically loaded on VM-Exit in those cases, the
> curr value can't be stale while KVM is running.
Oh, yes.

