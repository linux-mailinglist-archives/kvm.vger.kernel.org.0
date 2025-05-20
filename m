Return-Path: <kvm+bounces-47097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7662FABD3B3
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 11:43:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 03DCF1B656FC
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 09:44:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA8EF267F55;
	Tue, 20 May 2025 09:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PXAnO82F"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B86E268C4B;
	Tue, 20 May 2025 09:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747734214; cv=fail; b=CIrXKbIC/AddBtAkqVGmjRNzM8iA5tz30qBRO7LejMPCBde2JFsrKvcHretwkMn3ZnHoYpJwF5WUhwJJYobPV1i+vK2J223MyW2mUiVWaJFoQZNTa4pq1ESRw3KT9jtIkwFTiEpkGXcDuYv7P/xBonYGNcz6kdSNA3T7ZyXBgFc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747734214; c=relaxed/simple;
	bh=3F/fJRvcpX2D3pqqMsYxI7KsOYKFtSTZdz7n7J5w/FQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WsEe5zjOz0DWAQJgzW+Lr+U0y7NHilODigf7/gw4CZJcoiuGtOgA+UrlBsgVNBKp/ekF4Vto89UlHQBJmrLJd66LEiHYDdhqQTncc444W96EFnKLYdaxML8AZu62JWa2dvZVgTaGEP/YUfMKvj+xMC2x3eT8dDTBnTPJ8FnhEXs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PXAnO82F; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747734212; x=1779270212;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=3F/fJRvcpX2D3pqqMsYxI7KsOYKFtSTZdz7n7J5w/FQ=;
  b=PXAnO82FyDoPYZjmRGHxJG3sAoHkniRjQmnRT0Yx+fficdl8GnbzV8YQ
   WQkefW7kkt/wR8AMGDX9iXXXouKroggjbrhF6GY41eqWM1THWIlkqqDcj
   dgbDAZG/xlPazUBKIaOlpgvjdERp2yUtz74DxU+qVAdvz9ESm9Bm/YZcE
   agafXEdicx2tviIb65DyOLjTCI6YYCBuAYmDD/rB/61afZa1U8WrQS06I
   6S3mGq1sa5ceadqRa8Rkv8NaxLcWzQ8Gx87RJkAl3YpygeZRj2iVu1oiP
   hAGFIvJAUIWzSZzjnB6s9aUdpv0HJoJYyC8uUwPs+NTElH3R6Bs5+U6V8
   w==;
X-CSE-ConnectionGUID: UmHEGkczTsqVx6OFLwHGgg==
X-CSE-MsgGUID: 7051njLwToWUB366ryb80w==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="49759543"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="49759543"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 02:43:30 -0700
X-CSE-ConnectionGUID: uXEJ0mIDQcKwjh3FJCISQg==
X-CSE-MsgGUID: HXRxxs4yTIe4fm25z180Eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="140059081"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 02:43:30 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 20 May 2025 02:43:29 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 20 May 2025 02:43:29 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 20 May 2025 02:43:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=euIAemj2sfarDlgLTI4hPvtzw0Qt5T0R7caUinDE6A8gUSzYIiCTXiP3CU8oL/YqKr0qXHVXwuw/lGBpwVsA+wRsIAMR9ryLM8Y80Sj/PQfwXpyMVWlFnnoJW1KxJ7AKsUt1pFuSjo0kACJk9uM0/VqaK2EneYpSQV+ZfHBOP9+wQb2MS6LGk33BPGiPCvIeMcYjtXiT2Po9j/amp3w5XHPjXEXklW/lmuN21vWQkVUCBvomMDwHpnJnDOwkh52QRJlkjeg1LT4C/Uu8IvSUaNxduZZo8Se8ddvYVTIKqz0tou0rwzAxGV87qOQ9mZFPQBvKBMz7el0sixMHTPUo3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1fAf7S0vAisxogdJPrRWCsDvhTUlOpWWu2JVmxwvW34=;
 b=a3JoJxBwzziHuWaoMjwuZrhdk3Rlor4pMpQRBYSfmSQEaKHKwMOijQvg+k9klA8n2FmeJa+bCKaP9J9pOVgEjTz1pTYz5wSh59i9m5ccJf99qjfSRfjHg5/0ezxx11DsuKKehacbP8aduy2hkFTCs8gclAOYMUzGmQsgCMS7aFlpluSjjoyJ2C5MFFIPYnO20OyMB7ZRiQNiiRskmvaANsJ5KBMLylzCtygBTm6qo4VGVY/WBNui6yzCR6naKZ83Lmy1fBoHJ5c1aGqc05k+CvGlBNV8t/+xTHBMBSGcUww9vu/BtfahuXBNECOfjw8wi8bwPiHdSRLTB+g4GY+GPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH3PPF25FF87461.namprd11.prod.outlook.com (2603:10b6:518:1::d10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.31; Tue, 20 May
 2025 09:43:08 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%2]) with mapi id 15.20.8746.030; Tue, 20 May 2025
 09:43:08 +0000
Date: Tue, 20 May 2025 17:40:56 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@intel.com>, <tabba@google.com>, <ackerleytng@google.com>,
	<quic_eberman@quicinc.com>, <michael.roth@amd.com>, <david@redhat.com>,
	<vannapurve@google.com>, <vbabka@suse.cz>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <pgonda@google.com>, <zhiquan1.li@intel.com>,
	<fan.du@intel.com>, <jun.miao@intel.com>, <ira.weiny@intel.com>,
	<isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH 14/21] KVM: x86/tdp_mmu: Invoke split_external_spt
 hook with exclusive mmu_lock
Message-ID: <aCxOKIGgcxDlg+Fn@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030744.435-1-yan.y.zhao@intel.com>
 <1e1b26b5-2f42-4451-b9a4-69f9805ea05a@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1e1b26b5-2f42-4451-b9a4-69f9805ea05a@linux.intel.com>
X-ClientProxiedBy: SI2P153CA0013.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::12) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH3PPF25FF87461:EE_
X-MS-Office365-Filtering-Correlation-Id: f2a12111-0593-4679-480c-08dd9782ba31
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?vYUh4NU1W6GZFOSHXnwggnz9UfnCjWhF9PqFmTV9I57i0hchLhEDfzAEb7CL?=
 =?us-ascii?Q?rbeQSuQdtofdGAbebIwnWl5Woisim623qF38NvYKeMVzOAYMO2h6+eu/PcSG?=
 =?us-ascii?Q?eKiKQz6zdVgsh8ro/Sp0JUxg5oKNSMIW9HKiTKick7MGYe/docOZAi+YFZ5y?=
 =?us-ascii?Q?Bi8+zpmeKKR4ivcg49HB2NK4IjAlJvteLCqTVeKQEBMUvITo59/IzgAjS+uP?=
 =?us-ascii?Q?KLddWzZnqndiVPwWk2DzwCUu2UcqwlvDRNgCtIPIdGbdY5ISso/9f0Uj4Y8f?=
 =?us-ascii?Q?ZmuSAXegH1nHh4kTX9NkgU+SqrUUBxqO1FVPkeM2cX/8SW22O8IWvG6V0mmq?=
 =?us-ascii?Q?VI3cAyUK8ZihaLnm2z5PzziNX0aMEz6OeZWvYGOFv33L5xivMnAvTILOdvkp?=
 =?us-ascii?Q?NFeYiCIco/eGbLLmPUTbcb9wrX6MBZioXzL/hdd34F6vJ8ho7Bvo8MYNHpP2?=
 =?us-ascii?Q?C5M+clQAGLbKYOBlW75X58VDG8NeBZAw/iB7YprEqHb/MfzDNkvFmoBH2dQF?=
 =?us-ascii?Q?aL5W9wN1Qm2ziTO//a/1bpOjT1L/GbJF+Q05dV3yvbQ29QcrMZ5MXJkTdQka?=
 =?us-ascii?Q?Yw3jr6LEnb6mnAeYS2h5JSfDRzw9/y0njNUaXGvLFlRfYVS+Y1Ai57ulbM7J?=
 =?us-ascii?Q?iOSq6ExZouJ//XPES6f+P5jiTcAeikbTf9jW5DQEMkWKHxjSrJlaCqWOVKGZ?=
 =?us-ascii?Q?qysUYSw0AaxKwQW5dt6lhBHmfr2/p4o1nJ0iicK0+SIO+LwgD7uzSyWO+4h3?=
 =?us-ascii?Q?J1erPau2tU4THsCjyGMAgn/LfJqjIN8B7eN9Hz0rSAyeHiA83jtpZQ+TPz3m?=
 =?us-ascii?Q?elGM/zVAeHPAUzcVCAZQajrKZfycROclExP3K6/AZzSqL56uwJzUNzAnuBli?=
 =?us-ascii?Q?S4xqjeT8HLA5XZq3YsdSdXpd7Wo/Re4EVbtEBQpN7BbvRFcQ/u5TJVIBbT6I?=
 =?us-ascii?Q?PGH5cYASTijRqPkSn+L9rUjQjW5YdUQjweryqA9KsGttolYeEkaZX1iu85/A?=
 =?us-ascii?Q?dHyLresZ2zjXkNgF+PuDZxQnEYqMI0TLuPiuH0v0yYhh1NrctJ45IytnZ/J5?=
 =?us-ascii?Q?ipDY8ThfmSw+lQ2X1IHJTXxCRtX6ZlMuHbhqck3CPiBBnH1AEIXzbd+BugAE?=
 =?us-ascii?Q?xnKZhzbt7JT9bbDVA0hoxnjO78GLdVhJ8hLlEdATEfaRlOG5U/TDj3rVSzCR?=
 =?us-ascii?Q?yx9bkhzTPAY16Q36mW1TiiWC9VBMB02et4WRYTVBD+o9s2X7qoyrZSXJ5qDd?=
 =?us-ascii?Q?xL0HdbFyKHBP4FsHIH96zG9pIGGQVXdqRLT9tNGkJpjqVodBFtnU2HEzZ+V/?=
 =?us-ascii?Q?JquL7tw3flyAcI7ooR5/MLRNK7XvvJ3lkOnSTfWKTyiWbPU+bSPpUgozopOQ?=
 =?us-ascii?Q?lKQC8SfbLtpxWrTdK3FxIhyIvGGxdo8YC6emtjSMp42LVsSqd+02fGaq17lF?=
 =?us-ascii?Q?BZ7nsTc+PgY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y21E0awGkRUhTqepuY/WuHQ8QOi1jI5yM8VnKvWEgWQWs07mncHXtN3qzNKw?=
 =?us-ascii?Q?TsQyHA2ergzJpmWaL0OAA8lGwESfOlPBUpAnR+xj3Q8Iy+vZOHga+SDprERb?=
 =?us-ascii?Q?OmSvZSItSfA9z9PMwiJnHScP+VjPqTWwrr5Lg9DtFq3rKyRqo8w6QZyP9i3J?=
 =?us-ascii?Q?X7XjUvvBUj0giP6lrWQwOz+iUp9FPMkU++eWTLxHhSCYtXoL57PZ150xn+hu?=
 =?us-ascii?Q?t/RY454UqRBSYItgjgevgL4tQOP0Q44WfMc3PlFk1tveIKkr/qsmfKQLYwk7?=
 =?us-ascii?Q?O8PP/15unzrcGnY1e5bMaB1N4AB5Txfr60SS85rrOrkKTtmMbfONX5OBN69w?=
 =?us-ascii?Q?J9BaSQ9st5GmP/kPzl6PkpzPNFLr4uyZ0OiwJO/shzLZ7oYTA6TZoZx4z/Mq?=
 =?us-ascii?Q?FksVwemOQcFJBGna/SRRu0a3OdHhiplw/4YcZCnGQTi2CjIlKwHXMKCSHcRA?=
 =?us-ascii?Q?K1qC00STGKA4rCLhiYc0UzqDRwU9D82XEG3UeYpBU+ovANh0A8hWgqwmNHzw?=
 =?us-ascii?Q?Si8tVll5/peE6NvFDZNrvImNdUiccfMjYABCu4k74MSHN60Z5nUhiWLiXLRN?=
 =?us-ascii?Q?RoXouC9wp9HOohojnMdHHDX7f5i/x06omp7PRZx65mbqq9kDmgPBr8IWSaMv?=
 =?us-ascii?Q?6XLW3T26srOM90h7qQcgxuHTBIBa/BgkK9XLWZNaSO6uXCK9y/YczVivll5/?=
 =?us-ascii?Q?P2l1S24/0ATSpiEB0UJeG3YSN9lC2jXYvLbcfTrBptaMrvYRTvydC+CoKnFW?=
 =?us-ascii?Q?fPSUCtmSY18hQlQ4MQOs0t+qO+CTvateC5SML62rwidOGkz/JAHj7ndIikGC?=
 =?us-ascii?Q?mEZlAUqkbOxGx921o0K2IpcPe2pncdvHzOXDoQt+qMNJJakhWsZhCuXuvNXm?=
 =?us-ascii?Q?yPBt+wpx2sRxQ/TjMyOc7+PR636qZ8Nk43j9pRE5iW9LB+l3OoXSrc7JCdWO?=
 =?us-ascii?Q?KzWINSqXemH35UV6ASdU+ir/4atrZBcnWpKhl5sw28/sG03/h7x7wb5uD1o+?=
 =?us-ascii?Q?YIt07otKo4GVhvEMr8m32WCdhrnWSCGRpfpg1sOX4hFS0npYPUk3JZNpsGlf?=
 =?us-ascii?Q?AQSgKl+83x2uM5dJINdPxtNGNKgatdXujYaUEonGV2guISmeJ7t4/EyMqDYV?=
 =?us-ascii?Q?Aq4YboMgN5nClhLEeAXL6wEybZzEQTwpbOvM+T9JNNszVfT8xwVmEcINKDl0?=
 =?us-ascii?Q?+HsCUu1V67zYcgaODyzcVkgtzhocKIXULO9033co1i7xrAVpBsu94RXx36gc?=
 =?us-ascii?Q?acPdxRTeFQGbzpWl1rCfvZIrt+R9sz+9tdV8w0HwxOh3vwoqsZ4YyDxJ/ova?=
 =?us-ascii?Q?BiZXFyo+hxVg5aB/MieJbbONezMmKR1j7mAT6er4YL70BIa5sCa4j7wTG38R?=
 =?us-ascii?Q?eswN3WTdpADxMfSErOzrWdJlfIAOs9t2mKsgudnt5vEdBA+wFxqy4Qij0/tw?=
 =?us-ascii?Q?SC/iEnAfPzDKCG8KvDbwpD0g8dL2aDik72H62t/hnzvmUwARQLA4/6rBZ5Cu?=
 =?us-ascii?Q?OGR6OUz8GDgd8pTeIR5xu3bmP/VygIExhUoyao3N8tQq4D15NzYV/eoU3zxf?=
 =?us-ascii?Q?rSJ+s0UFMdHYxoSu2T52zXgn0hMT5Ec4X/w0mq2g?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f2a12111-0593-4679-480c-08dd9782ba31
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2025 09:43:08.3158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8pBo+Ovu2GGfO40ln8wfzFHoByc0XbIt0jfmJyz5ekRfRabwpdK1LH3JhNeaC/h1I/GUSbE7fUmBz92YMcwWcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF25FF87461
X-OriginatorOrg: intel.com

On Tue, May 20, 2025 at 01:40:46PM +0800, Binbin Wu wrote:
> 
> 
> On 4/24/2025 11:07 AM, Yan Zhao wrote:
> [...]
> > +static int split_external_spt(struct kvm *kvm, gfn_t gfn, u64 old_spte,
> > +			      u64 new_spte, int level)
> > +{
> > +	void *external_spt = get_external_spt(gfn, new_spte, level);
> > +	int ret;
> > +
> > +	KVM_BUG_ON(!external_spt, kvm);
> > +
> > +	ret = static_call(kvm_x86_split_external_spt)(kvm, gfn, level, external_spt);
> Better to use kvm_x86_call() instead of static_call().
Will do. Thanks!

> > +	KVM_BUG_ON(ret, kvm);
> > +
> > +	return ret;
> > +}
> >   /**
> >    * handle_removed_pt() - handle a page table removed from the TDP structure
> >    *
> > @@ -764,13 +778,13 @@ static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
> >   	handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
> > -	/*
> > -	 * Users that do non-atomic setting of PTEs don't operate on mirror
> > -	 * roots, so don't handle it and bug the VM if it's seen.
> > -	 */
> >   	if (is_mirror_sptep(sptep)) {
> > -		KVM_BUG_ON(is_shadow_present_pte(new_spte), kvm);
> > -		remove_external_spte(kvm, gfn, old_spte, level);
> > +		if (!is_shadow_present_pte(new_spte))
> > +			remove_external_spte(kvm, gfn, old_spte, level);
> > +		else if (is_last_spte(old_spte, level) && !is_last_spte(new_spte, level))
> > +			split_external_spt(kvm, gfn, old_spte, new_spte, level);
> > +		else
> > +			KVM_BUG_ON(1, kvm);
> >   	}
> >   	return old_spte;
> 

