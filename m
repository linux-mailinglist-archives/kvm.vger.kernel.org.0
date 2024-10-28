Return-Path: <kvm+bounces-29900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5343E9B3D43
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 23:00:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 145012888DE
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 22:00:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D91D2010E3;
	Mon, 28 Oct 2024 21:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eZxoFPzb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA75201010;
	Mon, 28 Oct 2024 21:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730152313; cv=fail; b=bxgZlAVf6dr2vcdnBTxmyYbgUbyHGJcUE5u7auKlwaK7aUlkrfNW4i/UqxA3IcOCdeDVmp1m47jOAhz7Z++dGaORmeqvhqUrAdSuj+xzNLXW7p/c9Nyn2UVZV+bcf/2eDFfnKL+1xAmDj/kaRrDWti6Eiq4QNKUvawbYem9HbFw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730152313; c=relaxed/simple;
	bh=y1kaJQBTarcoj0DvcNryatsXWOMvU9b4TZnvlvL5bSQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=roHhC2Z7dbnRN5qc5hF6ezNZYcydVbMdWK4AWgwYWh9xL21BCd16wb1fhiYWE8AsbsT9lMEFrrgRTfArmK9E8uMx1ZVUaywVxSkio0inwtXb3btyF6ymcxT4tnG+WMBMB9MSEN6VBG+U9xaLf9k8b3NJ94EM0umQQb4y2y0YjIg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eZxoFPzb; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730152312; x=1761688312;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=y1kaJQBTarcoj0DvcNryatsXWOMvU9b4TZnvlvL5bSQ=;
  b=eZxoFPzbFPR8b0je6LhUZfF8lk64t8DxPgpbqYQ3+mmV4LJ6OMaoS+Fa
   fT7I9qJoghjgje36tUfvWm1VJ6e8z69ZWPfXjrv1LKAu/2aDjd0mL2dJR
   hNEWNoc1FL+6ltOk2AGnRZfABtgPWIpDe988miDbd7Mh5hk45lnnE2lWI
   6R3A/6IdDXyyEpR/n7wwj5uXmHz6+VRzIWHGo/hxAptD4WmUpdltWvWZN
   Ilik4YsWdfmr6rVIZPgZEeirnH2SAkp3paMSzdX/E6YzgvlNRw1R2wYpD
   WoC1/qUa+JVfJe1p0N+d8BEEUGQ+D34n4CB0BW31DYEi6/tzP1KO6EK48
   A==;
X-CSE-ConnectionGUID: qWGcz54vTl2u46nRO3RQxg==
X-CSE-MsgGUID: neNZVFjWQ1mHNWJGVeMrAw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="29912147"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="29912147"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 14:51:51 -0700
X-CSE-ConnectionGUID: eLIK4RP9Te6Kwj8++Q9jPQ==
X-CSE-MsgGUID: tl2E35VDR/maHzF0j9KshQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="86497565"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Oct 2024 14:51:51 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 28 Oct 2024 14:51:50 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 28 Oct 2024 14:51:50 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 28 Oct 2024 14:51:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K/mFkdwmBixL013W/w45rVSY4AfDvckx90ZEFq52x3sTdDppJVIvz0tps0L+J1IekSgKNsvDq1rZRP4+a7dCzV12zQnaMHeF14LY/qCBEyEg2qpwpYDOvqQniIaWX/vG6mwhRkrJDPr7WC044Xg2hu8ICA2qJHQKU69ejLxKV5zcEpz+eGWCszRgw6gAinNDfxFr+oPFZeTnA5sAi8wiJj+YiHhMt4w7S6yaMAIDJsVtYqGJu15Q6oW42eMSjS4Drjk3daTR3ivSZgCMqKgqbJKQ1BqgUdBjBpZ9hpuxNmna+ywie3jT+fKhYWaKQuxFdAk5f3yrGdDAJCdrN0xbhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uDgT3iaRYEajaj9gCZP0wOnQT1YeFcZ4c7MWfoXFew8=;
 b=TG/DtQOOU3bNkYGtc+7ataAwYDZPlq4CrinIHbJASEhFpwdZnF32Wecs4DflKfhYhu1vTHEGKumMIlMM311WYt8tnGjeiVStPhoIWadrzItpcvzfkQSIW+G/0FLZF/Iod+dZWaLi/hRl1fcmF3uuJQzQ5qU1a5uhKl8B3/RA5DF0sAAbjtPqGIBOMJyLtlTUiAdga6UyiKQCPjnVXY194jaBrKTGgg++2drNGdRPCTmYrDnuwCfgFc+htAgGVVtn3Dlv+bgk8awYt1i/j4tCsZNGz/HCqovndAVaNexzboeoPa5dm8vdEoN/eMlgqatk0ImGhDU9sT0yISSIfAS1LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CY5PR11MB6307.namprd11.prod.outlook.com (2603:10b6:930:21::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.24; Mon, 28 Oct
 2024 21:51:47 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%5]) with mapi id 15.20.8093.018; Mon, 28 Oct 2024
 21:51:47 +0000
Date: Mon, 28 Oct 2024 14:51:44 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Kai Huang <kai.huang@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@linux.intel.com>, <tglx@linutronix.de>, <bp@alien8.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <hpa@zytor.com>,
	<dan.j.williams@intel.com>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<adrian.hunter@intel.com>, <nik.borisov@suse.com>, <kai.huang@intel.com>
Subject: Re: [PATCH v6 04/10] x86/virt/tdx: Use dedicated struct members for
 PAMT entry sizes
Message-ID: <67200770bea9b_bc69d2947d@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1730118186.git.kai.huang@intel.com>
 <e1f311a32a1721cb138982d475515e24f18e4edb.1730118186.git.kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e1f311a32a1721cb138982d475515e24f18e4edb.1730118186.git.kai.huang@intel.com>
X-ClientProxiedBy: MW4PR03CA0074.namprd03.prod.outlook.com
 (2603:10b6:303:b6::19) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CY5PR11MB6307:EE_
X-MS-Office365-Filtering-Correlation-Id: a72cb86c-e062-42db-50a3-08dcf79ab8b7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Y29OKCGuhoAyN+o/mcuIRT0JpzP3p5K+bxYGqnyxrOX0SydVf4JSDerNWY4x?=
 =?us-ascii?Q?AnNyvW6LvT6Mi/O5z+GCtPInt7qS6x6I2gwWjn+7rdE2U2vTzkoq6k/pUlqV?=
 =?us-ascii?Q?+lVgTuZq4l8ZqIUx9BrYJlj6WtN7jIfug/nbnItGJzWBuPwXAk8i9eWTDsws?=
 =?us-ascii?Q?7BqaFssNT3E1x6IM2m0pInXomqUPdm8fYCBx2e1hZQyG0IOfKdytgOKtRxJv?=
 =?us-ascii?Q?u7nR8JePoW9cOZ40MSiPzbb//BXMo4wobiYieqVqkhZDQmGlz+t5xN7TI/qW?=
 =?us-ascii?Q?2DskR6VcGMIyfa+FIlajdal0Owxta673X43KNa0TlNI802xhdWlTPMquKhpq?=
 =?us-ascii?Q?II/mrWdhKI4IzwgZ8aeghxoBoOwSlKEzKdgITDn/rD4X5yBU44vdjJoz8pDs?=
 =?us-ascii?Q?Uy6SNJtIt3zn6W3VpMdaYIIFECt3wuKs3hT+2u6eFZLCVfrqIsTTlseh6Ja8?=
 =?us-ascii?Q?dXuG1XqFYjPUT05VWynFCLGWHYg8F/3fTGGQQu6XbE2bPKkRNthTkwKBsXp5?=
 =?us-ascii?Q?D8LWKXGi/zLZNRp1FtfggTs6J0Q1tC5lU4NkG+L53AJnX+QhmgICiDSc1QWN?=
 =?us-ascii?Q?QQvq6ra3L4/r4QE31pDZnZUAlMj/w83RQwBKHJ60WIAjqxolNTh226Zk/5pJ?=
 =?us-ascii?Q?UsLHL0aAb6cenBHuIJnqUDFXro68R64YcAAzUhz76zjtRi5gmByNFQk/ngk8?=
 =?us-ascii?Q?A72gRwIAoCZkHM0Kkk2A7ziyyH4+sb+Gkp8j7gvTRcowbQ9ex8SMk+T1S4LZ?=
 =?us-ascii?Q?QxoGnmL1o0AVpk1PkDlEKvmBo4XuIf/r6w8rqFDKuGVhrnT6AWdN5c28jeca?=
 =?us-ascii?Q?CKzwWFCzEW1oDo9SMi7448zr0yr1q92BAYrXZysmlJFd2bDO2vjUiMfcXXIn?=
 =?us-ascii?Q?NlgYuXjdub4jYFAg9/ECZGRQPeBrW2oDm/htMewttED+ZuZ+BoWTnj0MpGEX?=
 =?us-ascii?Q?qlg6QAd1yn9nHmskxUB8W2TMbmcdzMbtI6x+mSMxL3ngKiWe3JtZnsNMyxKQ?=
 =?us-ascii?Q?Oc1+/x9UKTLbzGCyvtQgVcZ8Wx4zkJDgs23fYWcLm4HD4AhxtS7fyXq+NeOC?=
 =?us-ascii?Q?gEszrLCbsmsyB+4APUxcO3pwFOFxs/hvX61nnFxeBSRPmgRXWx+HQsM1U6un?=
 =?us-ascii?Q?8EfMEr/ryU83kVNw/MyqhMfSnGIztrcM87zzQcd31tc+I5UyoPMSD6mA7ki5?=
 =?us-ascii?Q?0zeez1LsOzhKMus20vv5xpyvbZFxAXIWyNYwgDe7OrrJRMwW8SFdVD74NHRF?=
 =?us-ascii?Q?CuQ/i6MDnhh5YGROgCjReJra7zIihP9k6TNu3HQx2GmV9ZitGZn8dA8fDp93?=
 =?us-ascii?Q?PTs2aG/XaBOegDpNw4t7LRK8Wv7KQGTzqxien0kP5dpHAi4vF2fZV5zAjAob?=
 =?us-ascii?Q?+LQOzqM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9hLbsZQJZ1retykQDxxW+gnWkr8+dXTWxM82l7yKiCD1sfoCf3+bdYQsYVpg?=
 =?us-ascii?Q?L8GPdvrcT8LJXgiF1rYjthrSd5NocozTfpzsBAZ4GTIXxR5FdJb5v4evz2Pf?=
 =?us-ascii?Q?xkv4F1z8aWbhnhGqyXr5bQiDq8yvgn9BHdc4k5nJ5S7WG1/bEz8Wcwy+1M15?=
 =?us-ascii?Q?cPBqz0cScnE/RoeGI874duzWA9QcvU3eJzpnrqX66rt0mlAJ6f3Q5gCYlEzF?=
 =?us-ascii?Q?LwIykskGyGwW9r4KXIVKwwJ/O6djzWTsv1e8eDC3RGrybLqvULkgI+aBDE6U?=
 =?us-ascii?Q?+E7kuX+JJBxu8NatCH4okQUp9O4mHNESkTGecC5SXZ7n3tkEMs0qrB5VcTCi?=
 =?us-ascii?Q?x2ZeGXAMSyKrGvkP/tXx/q3rohPU+uQDZQ5szGgeo6P/1TUri7Nvxp9Xz7Zd?=
 =?us-ascii?Q?i8CTm8blPv1usQKnsaR5ZkLUfl3bajvuaWrQiFhwf+fCS13ZsKQ1bPweBIfQ?=
 =?us-ascii?Q?LoUXduMINpcFgE/Fch7vRWWWV+33BPBanQD4IT3ESTj6lkqj3bEuqerAUq9h?=
 =?us-ascii?Q?XJk0HZiOMN8gADGiqzSEBUz25/A9K7qKoX9vZapEKP8eVEdyQhgW0V7N8W22?=
 =?us-ascii?Q?Qiywrpcq2v/h0D0E3P7Zi2QzOOUqdMySVg6T0aqcOk2qyhJ7kXommqkeacCv?=
 =?us-ascii?Q?INpx/8ksprXF9EWIpIIeY348ttSDwd6ZECN+FKG4ms7LhDykuTitKshVPNid?=
 =?us-ascii?Q?vw63bKsL3WQ28S89laY3aHjS/L+zR4N2CExctw2iJUzBqFPztpa6uOLy5Y1n?=
 =?us-ascii?Q?ZxkYxSWSslLZLtypkm4NUCq4zZ9dW1eBBKrW0m9zZGYuH9HAi5v5cW7VTlHU?=
 =?us-ascii?Q?tUpYikhaXQ2kPaa+B+EWAc9+5QrD1o8ln4jOrtxGjRs+qJ4y6UbZmikV4H/a?=
 =?us-ascii?Q?fjDE7lmG4xqEjQCKwSVTcX/sZ5G7rEvCG7H8Hbn5fgW4h0T4hCXdIZWwe9lG?=
 =?us-ascii?Q?nLsy/rdaCxKEPQM8D96821lfuVzu27H7BXokeKrmWptYfG6eEzxusCs/gP5d?=
 =?us-ascii?Q?ym/sxAE8qQ8zxcYQSfsNhB3CvX1bJXpqabb5eNm/dBvq5DJvsXSL8B+ulIiB?=
 =?us-ascii?Q?LCtH03zCi6xzwInTRxgmJpA/pSmskIBLfMNlZTDHM8eUv8wDXFh/GuXhAQ65?=
 =?us-ascii?Q?AzwLjtvh0yYgaCgL3Qcxxm7Zk/JtQAJmunEQb+Gr0JQI6MFtA4xJMp07t09n?=
 =?us-ascii?Q?ZloEWP5K0aWCoYnaQEcckKRddb4UlIAGCuTOA7qZ/13bpb2bQJ59HLFi4EnO?=
 =?us-ascii?Q?9ggZEnGtmElw8ISv/7efwdI6RTq8KD7cld9UUKd2bXCGZuSKPLb8e6GhM2kE?=
 =?us-ascii?Q?qixysDGP58sCtXO18KYFmdmCMBNbdWfj1gS9xgkh8aBkHf60z4sk/nWUt98/?=
 =?us-ascii?Q?eXPKf3qKAC2FrzaAgbXGsB1C5Z5jNnFIZ/UW1SFT1rqnDI4EV661cpAoZNop?=
 =?us-ascii?Q?97eM0m42A4IJPOWujMVpB57mL94kC96+2kd9c43oDXYJqbgAyot5CIZMdI+Q?=
 =?us-ascii?Q?wqi8P9e1oSn70lzYU5lu8ha4FmiqP+Xp1HiOljkDLMNsJF/KXnJ0UJ8q2x6c?=
 =?us-ascii?Q?9KPJHW0UTMJLWxOvj0y3SMcdmP8XJHye+MX1iFvf4/sQHp21l/RcaD/0FcPQ?=
 =?us-ascii?Q?cA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a72cb86c-e062-42db-50a3-08dcf79ab8b7
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 21:51:47.7533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vW8+smeB8/42lCP40YpNZJSY3VBU2RBqaXGX/dpyQFDyuAN45+DwVWvhPqVOs59CXRmYArt6D3LoI3sj4eqfy8vhOignXmrY11vd8S7hhg4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6307
X-OriginatorOrg: intel.com

Kai Huang wrote:
> Currently, the 'struct tdmr_sys_info_tdmr' which includes TDMR related
> fields defines the PAMT entry sizes for TDX supported page sizes (4KB,
> 2MB and 1GB) as an array:
> 
> 	struct tdx_sys_info_tdmr {
> 		...
> 		u16 pamt_entry_sizes[TDX_PS_NR];
> 	};
> 
> PAMT entry sizes are needed when allocating PAMTs for each TDMR.  Using
> the array to contain PAMT entry sizes reduces the number of arguments
> that need to be passed when calling tdmr_set_up_pamt().  It also makes
> the code pattern like below clearer:
> 
> 	for (pgsz = TDX_PS_4K; pgsz < TDX_PS_NR; pgsz++) {
> 		pamt_size[pgsz] = tdmr_get_pamt_sz(tdmr, pgsz,
> 					pamt_entry_size[pgsz]);
> 		tdmr_pamt_size += pamt_size[pgsz];
> 	}
> 
> However, the auto-generated metadata reading code generates a structure
> member for each field.  The 'global_metadata.json' has a dedicated field
> for each PAMT entry size, and the new 'struct tdx_sys_info_tdmr' looks
> like:
> 
> 	struct tdx_sys_info_tdmr {
> 		...
> 		u16 pamt_4k_entry_size;
> 		u16 pamt_2m_entry_size;
> 		u16 pamt_1g_entry_size;
> 	};
> 
> To prepare to use the auto-generated code, make the existing 'struct
> tdx_sys_info_tdmr' look like the generated one.  But when passing to
> tdmrs_set_up_pamt_all(), build a local array of PAMT entry sizes from
> the structure so the code to allocate PAMTs can stay the same.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>

Makes sense to align with the autogenerated code to reduce maintenance/review
fatigue going forward.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

