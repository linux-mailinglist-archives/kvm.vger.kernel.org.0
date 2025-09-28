Return-Path: <kvm+bounces-58930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 180F0BA6596
	for <lists+kvm@lfdr.de>; Sun, 28 Sep 2025 03:35:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5A463ADA5E
	for <lists+kvm@lfdr.de>; Sun, 28 Sep 2025 01:35:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D2A1245010;
	Sun, 28 Sep 2025 01:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AfVtPPAh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A72D1B4F08;
	Sun, 28 Sep 2025 01:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759023329; cv=fail; b=plTmtp9Cx8ga5U9cFFxUwfWRZbzcprJTxpihbpGzZaYDVojghuMPBDP6Fivng2c56blaUBSYxo2Gz8OhhgeZLr2UooaugClMrVyhDVneWFVYgmt7BpUzdAZ/EMiT+4J4mkQoCZkC72TvwaPZH/0ieZGRutNoTmVNupnyk450bs0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759023329; c=relaxed/simple;
	bh=rJMl0CpuzMk4VPtKTIpVgIZqN3rmVMfkRrxYsKEw/Dw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XeMzaEjYux/Vze4GnwTPv1HaCSTCuP7xL7p7QfM9Us12xRtpHCKfClNd+yS4NGrHHEItc7A4I52+gL6r0FFYqLez1TbRbDnUSYD8Qy2sKi5cnP9aF72yjuwexn8gRWe0FsTY6Jto9HQEIO5gZsvIn6gBhxHnR4na8ragSc7d0SU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AfVtPPAh; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759023328; x=1790559328;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=rJMl0CpuzMk4VPtKTIpVgIZqN3rmVMfkRrxYsKEw/Dw=;
  b=AfVtPPAhWTlBUZI4FiDoASn9sWYxKeD87yUqS7EPKzBUWHvCyQjk9A6m
   8Fcb3GSlAGA60SmTbgi+OQqmwg6u7ts6NIH+LlPKcVPrClXeZ90Bjh1Ps
   E/ZGTnMZfCs8bzT8dG1UU/n1tclXSRw/sjhP6BFDAHvK6IWQmeBiQuM2E
   8ieTLZal4/btCz4ARyWNzBkLgJRfTIY1ERgMU+g2m0+dnKXrBUAMaYEqc
   wkfi1iQSA+UjEVnLqfK1mmI+w0FYQD7x+mZ7sR1AArtzvYTXqlSIUXxBw
   CjH0NV9GaXZVgLvRtOhoatnZUHmPYSWZoKlK5gkafpTyQ7H1MGwngjH0c
   g==;
X-CSE-ConnectionGUID: ixrfRsu9SECPyH1BvtcopQ==
X-CSE-MsgGUID: iEcbbsmYQ0S32r5JbPQsIg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="61356959"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61356959"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2025 18:35:27 -0700
X-CSE-ConnectionGUID: 9OJXhvpzQLeRcK/vE1qv2A==
X-CSE-MsgGUID: bqppzz9zT4asG6Qaoy+LnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,298,1751266800"; 
   d="scan'208";a="177747571"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2025 18:35:27 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sat, 27 Sep 2025 18:35:26 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Sat, 27 Sep 2025 18:35:26 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.44)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sat, 27 Sep 2025 18:35:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WxtYyobT4xfMelyBsctWiL0JfmoA9ZPKrQ6PJ62vIExzjRGLogWcxJzdEvhtKmCQjttWYsR1q2d38Xb0q8n3gGzba8jKu6hhvSWd6/B2GX5mnPerHYJOrtOb7R8U8xNRnyskACyES7N5AeWiAoZpHMHW8qs6hVCYR8WYtiQB716i02OIx2zNP6yl1bzkbJDXQgubXia57X+cSah1C5MhWLHHctWprMNTeg63PgcKIROyjBC7SF7NTO7dBBUEJ9keBdAyWOPS3KVmwuHEsxIZlX9os5C7fwSgFXyNQ/mbMIiOckdzrJb8/7kD21NneWyRVcvR+YPj21g6CXH59PaMzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bxA8XoY+Fgc9KT6IwDXV93Q5DXx0ROxilvwruSyOvz8=;
 b=JoskOBr8JRFyEq/Uyx5XiZkX0q4dMHM7qK3GSf/WcsmvDPoV51Kw2L/BRb/MISKJGNA0xWHfXZSd6ZrQWVCv6rIEK9qT2sBLqqo0K0KfhAelizSz0RebZVLIPw7uqJFHRt2xUA/9VslqURQzsnvM/l0cRlKjtSJfEDW43h1T3A/5dMBRC81h9YtNdjH1Fd49xdN7zKmvei71ZK6VABR1nDgOeVhqE9yBMHbH0k9EaKd7/6bmyh3ua8uHKNa3PyPSKVq8FO1Fu6m/R4WzTvEZx7NO44bLRCd19gIq0rECprvpgOKCSRLyXjrK0AQbof/hpe5z4GRMJD+gxl4hWPGwmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS4PPFABF58482A.namprd11.prod.outlook.com (2603:10b6:f:fc02::45) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.15; Sun, 28 Sep
 2025 01:35:23 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9160.014; Sun, 28 Sep 2025
 01:35:23 +0000
Date: Sun, 28 Sep 2025 09:34:14 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "Gao, Chao" <chao.gao@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>,
	"kas@kernel.org" <kas@kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Huang, Kai" <kai.huang@intel.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 00/16] TDX: Enable Dynamic PAMT
Message-ID: <aNiQlgY5fkz4mY0l@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
 <aNX6V6OSIwly1hu4@yzhao56-desk.sh.intel.com>
 <8f772a23-ea7f-40eb-8852-49f5e3e16c15@intel.com>
 <2b951e427c3f3f06fc310d151b7c9e960c32ec3f.camel@intel.com>
 <7927271c-61e6-4f90-9127-c855a92fe766@intel.com>
 <2fc6595ba9b2b3dc59a251fbac33daa73a107a92.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2fc6595ba9b2b3dc59a251fbac33daa73a107a92.camel@intel.com>
X-ClientProxiedBy: KL1PR01CA0059.apcprd01.prod.exchangelabs.com
 (2603:1096:820:5::23) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS4PPFABF58482A:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e238bfa-7880-4f85-7485-08ddfe2f4b11
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?glZ27Y7rK5RYwjfU4gfA+rgAbJWUyczzcysfZEZD3DiIY7fBSxUpw5Ecp+fA?=
 =?us-ascii?Q?4s7xhtoMr8mbEA3V/onz8edxl1TOE8M+81ST5eZYKAK0jLqTRC66DtWsm67t?=
 =?us-ascii?Q?ZpC2gTb+zsGr2FhHMCfsyLW+kHu3gMBlkvSgtYscWQcyGHVj61nHq7ZjklyY?=
 =?us-ascii?Q?bLfR4oaUgdTmG23h2REbowH2x97qHcoIB7IC6xF5IcXdX27EmSWeV/Y0qOKK?=
 =?us-ascii?Q?x4XiPIKdbPXfc1/w1r/WL/X0TbkIXyT96U0UO+8TQ5GLUXjvbcQ/4QB34Meo?=
 =?us-ascii?Q?xrS1h/eYsKH+ZHTQv3P7P/U16HbMYcLitz8V6MKd0JWtERPxb//5dM7a1acA?=
 =?us-ascii?Q?mcyxOlEuL0ap0jie91XxwWK2uyiRLKeKFwzgP4BAsXDtqbcDglXJ29JPNdlp?=
 =?us-ascii?Q?bcVQ5ncvfZgbWN3RDh/S5vDs/JkK1K6r2fajmMMYGNB8baduJ4gjI+D+kQRx?=
 =?us-ascii?Q?w4t0WI2xcWVp25BiDiVayLgifAZq2/j3LTvQnc/6+u1kAxoc0XntWwkg7/Se?=
 =?us-ascii?Q?PgRjUECB+cEexgfQGhdPDoh9RHg19CY8SWQ1LXFq54k1dhfP+POHs/6WpwEa?=
 =?us-ascii?Q?d054AMifRUTXHZSoyNKq1jn0yukYNI53WiOoE/Xmc3h6z1k5IRdSRO27PH2O?=
 =?us-ascii?Q?cmLUrEMtpdQ5cad5KCzTcZeyw1n/RaZ8Z7WhP3qG5SDacwxqIF8uYPxggipD?=
 =?us-ascii?Q?W0BOfGn7ZLL4SrzjKn2apD4d5b3Bowo28h1SkaSKFQEACmXa+Y6/U8ysJQsR?=
 =?us-ascii?Q?K5WdlAAEY7zQ1zp4JHk75Kq8I4fdaXR1ObZ0rt4dqHPBIiku/uYl5k59fEoq?=
 =?us-ascii?Q?LAXkJU4a921wqmxreJI6OD7tIC2DeKA0W9bkuoSsYyoLdT+rC76JxRtgnX6O?=
 =?us-ascii?Q?cNiZ3B5cFxuYsm5qwLylHQATEHwrJ4U9XP2xUd1T0C+PPDjzYk+Kon0tT2Ly?=
 =?us-ascii?Q?yE2BqqeC5i2gY0raB/2Q17TKyjdiaMoymEdJSTesKmzvJupcTfEku5DkqFLo?=
 =?us-ascii?Q?XXB7atYmQK/QnXRF7JXnseAqUQ66grKUYLhezf3HcBE6OPTIhMHeP6cPKvfd?=
 =?us-ascii?Q?XrLv7+nqboSii9gDe5wtsqfJK7ljt069CAMiI4sQZ2eQ598ME/12MI0ZDvko?=
 =?us-ascii?Q?bPHIygx2Y3PFQPkjOT159qmEp0UBHpX3nbuvYHcD1QZP97QcmiSNit0RXfg/?=
 =?us-ascii?Q?qBmTac9U6EDqAp58/wFxFBpRZ7bVT+3lD1BX7afSHlO/OW63R6vpiUMA9+uV?=
 =?us-ascii?Q?uUOsDGRlIOGm9rKT9C1PqGHeLyI5rLkirUEUGlKuqLs7qDoSJagZVeFYjtbt?=
 =?us-ascii?Q?VYFcbJB+LqqY+3JWTjfMJGhRNme6yWc2otB2QXb9X2mvrDTfhO1GJvaKB2UN?=
 =?us-ascii?Q?DEYBI5j9xn1+4/pKt/srqzsi3NvUJQ6CxRS7+zef3iDPxjwcD5VFoAVKqgaa?=
 =?us-ascii?Q?NI+E+XDKI+jy7W6zWbQFNoa7vL+8S3Jz?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VGiByVDjdLT/iZOh+SEP+yyB6FlUaepwVswMxH1gG4jOoDPCet6sf1L2EO+J?=
 =?us-ascii?Q?KlVO69UejWgDVZlEk8KwN/+CUU4X/ikjKyYbBOp9FSGV8IWJIQBsOnmi4d0/?=
 =?us-ascii?Q?G93e3WJ5x/Bn/nHWtfyK64VCH8/T54z8iyMauABuNeSG6vwcBayxDnIjRpP1?=
 =?us-ascii?Q?Xm/WhcmIlH+HbwbaN4vKFoor3GN6PX8bLpZyjzdinH0KYAPbjrL15IDN+5GR?=
 =?us-ascii?Q?wtIk4vNukEY3fzj4wRD7aOJZdzsTRhky2O2aZyf0KJBp3vpZcGk4KKL2+Jkx?=
 =?us-ascii?Q?s6oLcT2xjJgRFyA2a5EFHFIhjKWBaFvHO8yqnsH8xkVZNv6Ii0lpiQ0UeDdd?=
 =?us-ascii?Q?NBfvZnlP6qXQ33KdB+yZVFCUTmYd7PLtTgpbqvuo+tA0pctTAU5pSU2tcSxf?=
 =?us-ascii?Q?lQ/csLEiJyEOGdQS2FeZcWCceH7j7knhPHGMKEQelgvyNjazRnFtHSFA6KzM?=
 =?us-ascii?Q?bSaXHfpMrPpaEajtHEyUWUvrdrskb+rI9e/VMOUhxaxA49hCqW/jkiLy+ahD?=
 =?us-ascii?Q?pZGxNTDgNNQsunGAsgt9pxAiYcVui3enfUqXTMSLf8yvVWtqcOJOUzDFPnFP?=
 =?us-ascii?Q?085sUWJJh9P6qBBoo9KhjiwADHBnbVtxT5fjCd/OCmqf3WGX6ZU030Dq1IJm?=
 =?us-ascii?Q?KHPqfD1J6fpbTEMfjAbrDoVIgvK9Ci+MF1Qpyhke7bmGFU0P8vH4+v1BwW1h?=
 =?us-ascii?Q?4jwebk8nd+nZwkCsGOJOmE3CrAb/n6m3kLOzSk/QmflEZI3XRT/DoMr9Uz9S?=
 =?us-ascii?Q?SlqvLUcZ4oD8+88m5U6ua7de1KqwjCx6CX9g9Nkt8065AH1P/kElpYKhsdxT?=
 =?us-ascii?Q?g+afNg8iqrt26TRn5rRHuGSnuBjJhgYl53h5cMYmH19FQTPMqgA/ASHkRPkP?=
 =?us-ascii?Q?W/FbBei4rVjpgIrACPjY1dAFnIjSZEBRefIJwZ/Px9T/QtVwz63JRsEWqwe6?=
 =?us-ascii?Q?lSvau421InghtWqn9mOif+Z6q+uA+ZZ9QMnuSOtmRygUoUODcrycZbFHjkXC?=
 =?us-ascii?Q?hSjCu7cIB9+THD5V8jRQ/FjBmqnwtoH6eLc8s+iCVRpj3jbybYxJmlAcqyht?=
 =?us-ascii?Q?zbl/nuuwoySxZKHEhJnwHEdS7LK8VXZU12C8/1L1PYsBjT4bHeVyIOEkbrIc?=
 =?us-ascii?Q?z332MZgMl5XC1eiBV6WJalZRMLbTVYDd98aSWChWJ59FNrCp+76+E2cWUum/?=
 =?us-ascii?Q?7/7CoqVso2blT8HKbumr8NKKWAXfvncOgSH7dxxZgGRu22XZ36LhDcJLqdGB?=
 =?us-ascii?Q?FpU7nvdW4kLwpNOyz5hLBvsUtxsCP31b9GZN+TX6zBJFRVKpm6KohDoo+hn8?=
 =?us-ascii?Q?uefu4ik0SdVXsDL6Bg5xK7GTbzYjgxYKQn5MzrmW3zhHIdvqjq+ij237TTkO?=
 =?us-ascii?Q?vd3DX5lSCzoJ2s6eY31NYH6A3LpkjlQEiFWVeKBVvvTwwBKaPDenkjWksSju?=
 =?us-ascii?Q?g2OHSl5bgQECNiM3FkFUeIt1DM81x9+G7y6uGMBJwSaQHq0w/TWQrW57jR3C?=
 =?us-ascii?Q?eSpHFOr5PlSBqf/11U19nSFkNnCYI+clSCd6sWZO7xqm0gfQSVthQCMMk1/T?=
 =?us-ascii?Q?SAdzBRwjjbQJkrR0wCk4ATQo8jpVqkKjmv6GbWui?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e238bfa-7880-4f85-7485-08ddfe2f4b11
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2025 01:35:23.4070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BJ/IgXgQufHM/1uBy3CflJEQn8ziyXUG0ebnzWfOEkZdk5FO7cZ075eU3Qnd8zV6G9Jk8vChzL1yhBk+0LLk1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFABF58482A
X-OriginatorOrg: intel.com

On Sat, Sep 27, 2025 at 03:00:31AM +0800, Edgecombe, Rick P wrote:
> On Fri, 2025-09-26 at 09:11 -0700, Dave Hansen wrote:
> > If it can't return failure then the _only_ other option is to spin.
> > Right?
> 
> Yea, but you could spin around the SEAMCALL or you could spin on
> duplicate locks on the kernel side before making the SEAMCALL. Or put
> more generally, you could prevent contention before you make the
> SEACMALL. KVM does this also by kicking vCPUs out of the TDX module via
> IPI in other cases.
> 
> > 
> > I understand the reluctance to have such a nasty spin loop. But other
> > than reworking the KVM code to do the retries at a higher level,
> 
> Re-working KVM code would be tough, although teaching KVM to fail zap
> calls has come up before for TDX/gmem interactions. It was looked at
> and decided to be too complex. Now I guess the benefit side of the
> equation changes a little bit, but doing it only for TDX might still be
> a bridge to far.
> 
> Unless anyone is holding onto another usage that might want this?
> 
> >  is there another option?
> 
> I don't see why we can't just duplicate the locking in a more matching
> way on the kernel side. Before the plan to someday drop the global lock
> if needed, was to switch to 2MB granular locks to match the TDX
> module's exclusive lock internal behavior.
> 
> What Yan is basically pointing out is that there are shared locks that
> are also taken on different ranges that could possibly contend with the
> exclusive one that we are duplicating on the kernel side.
> 
> So the problem is not fundamental to the approach I think. We just took
> a shortcut by ignoring the shared locks. For line-of-sight to a path to
> remove the global lock someday, I think we could make the 2MB granular
> locks be reader/writer to match the TDX module. Then around the
> SEAMCALLs that take these locks, we could take them on the kernel side
> in the right order for whichever SEAMCALL we are making.
Not sure if that would work.

In the following scenario, where
(a) adds PAMT pages B1, xx1 for A1's 2MB physical range.
(b) adds PAMT pages A2, xx2 for B2's 2MB physical range.

A1, B2 are not from the same 2MB physical range,
A1, A2 are from the same 2MB physical range.
B1, B2 are from the same 2MB physical range.
Physical addresses of xx1, xx2 are irrelevant.


    CPU 0                                     CPU 1
    ---------------------------------         -----------------------------
    write_lock(&rwlock-of-range-A1);          write_lock(&rwlock-of-range-B2);
    read_lock(&rwlock-of-range-B1);           read_lock(&rwlock-of-range-A2);
    ...                                       ...
(a) TDH.PHYMEM.PAMT.ADD(A1, B1, xx1)      (b) TDH.PHYMEM.PAMT.ADD(B2, A2, xx2)
    ...                                       ...
    read_unlock(&rwlock-of-range-B1);         read_unlock(&rwlock-of-range-A2);
    write_unlock(&rwlock-of-range-A1);        write_unlock(&rwlock-of-range-B2);


To match the reader/writer locks in the TDX module, it looks like we may
encounter an AB-BA lock issue.

Do you have any suggestions for a better approach?

e.g., could the PAMT pages be allocated from a dedicated pool that ensures they
reside in different 2MB ranges from guest private pages and TD control pages?

> And that would only be the plan if we wanted to improve scalability
> someday without changing the TDX module.
 

