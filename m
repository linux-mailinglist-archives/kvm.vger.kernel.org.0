Return-Path: <kvm+bounces-42165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DB31A741DF
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 01:54:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 079A47A74EC
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 00:53:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA6B61C5D67;
	Fri, 28 Mar 2025 00:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fR+yeIZA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F0A158535
	for <kvm@vger.kernel.org>; Fri, 28 Mar 2025 00:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743123254; cv=fail; b=J8tv0q0ztlYi5W0KNuZSmLBcx6UGWX+6AAuHzqRRotGLQM0Zuk/zCtrnleA48IezSIz0GeA3qUKD/davEA0D6enJZBG1AexBNlDyY27t3CoZrgcPhVgxc46Y7gXozQg4ZAE9wOd7PzUVPK+zkqx/WuHmpvaFleI4lXdWzN6xDX8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743123254; c=relaxed/simple;
	bh=IB6t6MFvBk/U3ZaKF4Y8lKEGiatGHiMrqvaCjHwAxFc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gMsuQ88lx/3+txINykM6ZCMAbjd1TZs2EBZZTFRzywmaWiJJSAvCFPcItyvuwfCWtRIv3Nl7rx+OaXGke2rWfusTChnXBLlhhiadQLF5PfFmagLQrlwHz+GgoIGuJwaTMaxKVq9sfXJOcAVaiTbQSZ9S94XKV51rCZPn+QgJOHw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fR+yeIZA; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743123252; x=1774659252;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=IB6t6MFvBk/U3ZaKF4Y8lKEGiatGHiMrqvaCjHwAxFc=;
  b=fR+yeIZA3gbNrEDPB6pU1ZpFgq+xTbabAmPyqUmCaEtIZaCuPAwU6unc
   FteV8IkHjmN5RAx5fyAI+w7hFjV7ojFk+1gD1tXWuFspMlf9cYAYZTuDz
   xXZvY67gMat1XlGhfSTiiEuala7tJu9E6ZyRAKKqJXqAsJjHpB0H0Jcd9
   RuVcoGI9vlYPIUdaKqQQ7OP5fa8HoVoh2qJGkBkZTkzvMhQnaAzBBVW4T
   9y2W91kQqPS9k8LUc51vrKPKu/voL7Iy+QWP7mDp3g6/UdBLmkZTgD4CJ
   hi8kF+4zIGLjRi0+qIodRc8K7ouEL4S8U3dm3lTPPT1tAUx1DdXmaoEJZ
   w==;
X-CSE-ConnectionGUID: 7+xK4EvlSOWoo2Ww2HGGhw==
X-CSE-MsgGUID: LdSVOIHUR0CTsRhBLgAUXw==
X-IronPort-AV: E=McAfee;i="6700,10204,11385"; a="44369643"
X-IronPort-AV: E=Sophos;i="6.14,281,1736841600"; 
   d="scan'208";a="44369643"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2025 17:54:10 -0700
X-CSE-ConnectionGUID: XHN19j7kRauk9TgKDzva0A==
X-CSE-MsgGUID: EX3WMLesTdGCHtCt1zPX9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,281,1736841600"; 
   d="scan'208";a="125050099"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Mar 2025 17:54:10 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 27 Mar 2025 17:54:09 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 27 Mar 2025 17:54:09 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 27 Mar 2025 17:54:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C8/6Ov9pOm9djhYMRDFR7JoQlED8NIye0wtH2NHSjEW/1cgJyhiTqT586DULIQxJRtsaCy/ycQX1MPkmrIFnNIaYsQSaBKI8W7l8YEO6v3kqJbhY4gvbkfpPtUebhPW7vR3Xj2iJzhifYF0jh7+1ZhEh6E3KdMjS8lYpZWjiVMUJM0trFqd73U32ya/cXLf0lQGkaYuKyvTR3hx+nmqkud9LsNXHfjZrUtcft6F9b3yjYkARyMpPr4I8P1vui6umLtS805nNGqlcyM5Xs9GJSSoz2UX8uCWV1l2k2O7StbMG31CBoINneqRoThr/3CC7q1xSY6GuURfkr5dQqQEbeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H/fhy/BC/q/ByzDeLjGx88BjU+t/XWR06SLk/ygmIFQ=;
 b=IzyRU7ua57MaYNySvlsRtU6NUXlPCW8q2O7/jl8Yje4p+2KBwW5Wf/NxR3kKnbuXLWdYHFQw/imxS/s69RflAVu4KyC/Ff2iClf/CsDJbX8CYJnQf4VRciRGnbjfE1zXn6C2IVYn6Kv1ZsqimWQl9ohLLmU0ViRLOq9k3mPiycfoNU6I/vbDjFd7DKhAaMgE7NGkclTxQdhcEvbDl4DA1JUK0Xcn+PRSW90Pj82Eni9ZdxzqZGC0gqrW0eT97Ni004JXIJD6qmkOcSFKGgKCr8rIhSu2XEs9Bvl9iiTzyp/A8MoFQ3IOSeD3qEghQ+nppgyNxUa5BXGt+7CpyUNFqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH0PR11MB8086.namprd11.prod.outlook.com (2603:10b6:610:190::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.44; Fri, 28 Mar 2025 00:53:53 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8534.043; Fri, 28 Mar 2025
 00:53:52 +0000
Date: Fri, 28 Mar 2025 08:52:17 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>,
	<kvm@vger.kernel.org>, James Houghton <jthoughton@google.com>
Subject: Re: Lockdep failure due to 'wierd' per-cpu wakeup_vcpus_on_cpu_lock
 lock
Message-ID: <Z+Xywd85aTLAjJHa@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <e61d23ddc87cb45063637e0e5375cc4e09db18cd.camel@redhat.com>
 <Z9ruIETbibTgPvue@google.com>
 <CABgObfa1ApR6Pgk8UaxvU0giNeEfZ_u9o56Gx2Y2vSJPL-KwAQ@mail.gmail.com>
 <Z+U/W202ngjZxBOV@yzhao56-desk.sh.intel.com>
 <Z-XiNiQqhbwLmimp@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Z-XiNiQqhbwLmimp@google.com>
X-ClientProxiedBy: KL1PR01CA0055.apcprd01.prod.exchangelabs.com
 (2603:1096:820:5::19) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH0PR11MB8086:EE_
X-MS-Office365-Filtering-Correlation-Id: 316e47c1-10d4-4c8b-65b5-08dd6d930267
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?c0llenVhUHNUV0VqM2FjMEQwM3J2cmFuMUJrbmZoN2JoOVUzQ1pwMkROejFC?=
 =?utf-8?B?aEtkemU3V3VBcVVDd09WVGlkbDlNWml0cTdpc0g5c1YyaEJXbHVDWSs5Slls?=
 =?utf-8?B?d1VHeC9rYXQwckhiSFpVeDd4Nmx4cGJpbW9Kck5BTGVNTWdDdHRPcHdSYXJs?=
 =?utf-8?B?SXNRMFhyZXVpVElVMzdXYzdvZUo0QUxXeFN6QlRxb2ZkRkFSWHZySlFuU1R2?=
 =?utf-8?B?MmVzaVpuYy9HMjRZeTMxcG5uTkhoVitkZjAvWGpYeFkyS1RhSFdtWkV2MWZr?=
 =?utf-8?B?Vm81YmQvSTRhMWNqQ3Fodnh6eTZPakU2dkx0eWtzQ1gzOUdLR2p0SUVLdWsz?=
 =?utf-8?B?bjdrOCtleUhKK1lyWCtzODFRWVlLQmNwNnI2QThQUWh3bTJ4dTl5VUkvQmxM?=
 =?utf-8?B?OE9xMHprU2tYZnppRndVd3d5Z0taWmhEdUNmUGNKWldrM2dYRUNWVDltT2Fn?=
 =?utf-8?B?MFZsRkZBYzBmUmw1NFdWOHNwRjBML3FuV3pHc1BvcmY4U0tqZm5qcUNyZDFY?=
 =?utf-8?B?MU5UNVB1UnFvTTIzV3BUVGR6S0UzTFBxV3hkc1FoM0F5WDFqTG1STE45MXky?=
 =?utf-8?B?Tk9Vbk8wL0hvQ0lZQmxoc2hYRXE2M0VZU1MzQ3BzMUJneG9VWDVoZjliRVNX?=
 =?utf-8?B?Vng3V2VCbVgvRnF5Vkx6WlVWejRteDJBTWtnb3R5T29jc2tRQ1I5bnFRUzZD?=
 =?utf-8?B?UkRuTnJnY0MrZm9pZWUyZFNMQmlRYjJ5RVZUT0FjM2pONFBzVzcrRE9WcmdB?=
 =?utf-8?B?Q3NoTzVQWDZCNlhIdmFsYnhUUHQ3OTJUcGg5amRpY2FDYTRoc3dxUjBmY2tI?=
 =?utf-8?B?SDJnZDUzQTdkaUlsanczSndzWk5rMzBEdEN6cmYyd2R2MHJUSmhDbTNwa3NP?=
 =?utf-8?B?dlZZM2JPOFpDUXdidGlKRXI4YXVQZlJYaFhjZ0VFU3dpUHFvMkEvWE9MUjlp?=
 =?utf-8?B?SmluMTNiQTR0Zm1PSUpIU0t5QnJiOXM0UDNKY1YxTmdyRXpYVlNiS0pDRzEx?=
 =?utf-8?B?YWdJL3BFWU9nT1BhRVhOeHptdG5JdEtEOHdjZ1V2THBNOExrY2lsbVBzRVpa?=
 =?utf-8?B?WDZKV2xDSGpnVS83dU5FNGNvM1ZwNkcydVd3WEorYk56QnlzYmVKMFgrZ0NY?=
 =?utf-8?B?SEVKN2toK01BUFVCOHFtNThOTmFKb2ZZK0Z4NDBPNGVwT0JEWnJyeGRaRCs5?=
 =?utf-8?B?eFlrVzZ2UHNJZTFwWG9pVmNPOEx3NTJPbE5mTStScVp6dmxZSEk5Yk0vVy9V?=
 =?utf-8?B?TlV4aS9LbDB2dW13Y2xRcm1yeml5V04xOWFHTGIyRXlpSFpOMG9vMW5IRlRG?=
 =?utf-8?B?ZmZlSFgvYXRpY08ycktEQkZtMC9LdGlSZE1YOWlBUkxGNUY1ZjZQdkduRnJI?=
 =?utf-8?B?U3hsOVNRalNvWFNscnBsaWtUV2FaYk9vRTZ0T3FQWVlaaWh2RFJQSDJ4Vkdm?=
 =?utf-8?B?OHM2SExVZC9QRlJTVHhtK0h3TGdRbHFId0NrZ2wvWDZrZmduQnIxdWhFRFVi?=
 =?utf-8?B?NUt3VUlUVkREVDkvQ0YzY1JkMjFSOEM0UXNlMGk3R3NFWnVPKzM1Q0FOeC9H?=
 =?utf-8?B?WVMvZnNBeGlDNVdlZDdhQmdBNE9kaGRqT0ZTTnBqdmJCaVBmOEI1bi9BWXNO?=
 =?utf-8?B?TDJsSEM4SHQvM0dNQVlBZk53cUhmdHNoYTd4eVduOXlHQTJWSWpEb1dIZzB1?=
 =?utf-8?B?aHlTVVdZRXd2K2ZhV043L3BSbVUvSmJ1VXpHSWJ1MHJqKzFyZDUzSXhKdkhV?=
 =?utf-8?B?QmEvejBSZzIyNmxkeDZjZ2I1K3krcHJPZUdCV3UyWVdremRGQUJicjR6TThC?=
 =?utf-8?B?VjM0a2drbXJJM2dOd2tybnRodUFkdG16WnRvZ0krS1FmWUlXeHNjNklFUGph?=
 =?utf-8?Q?GTGYHR5ougf7h?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VXBQa0krSWM5YUxZdW5hWG42NEZhak5JemU1ZGYwcHVzWW9pOWlYVVVZRUt5?=
 =?utf-8?B?cVZGRWtpencwcjczY2FCNENhTkFNQ1o0Tm5qOWtIS2J4UDkydXYwZ1hIU2Z2?=
 =?utf-8?B?REZBUHNZc1Q5WUt2dTcrTFUwclZYVXpOWkY4cEQxbm91dkJEVTJ3RGw4dzhS?=
 =?utf-8?B?T2x4SjZNQWVzOVk2SUlYZXozMlUyL2xkeDZzekFpOGNlOUxQTTBBdG15NzZQ?=
 =?utf-8?B?aHNQNWc3WU1GaitpWU1aU0tubC9VVkVobjlkSC9jS3hIblZKSjU3ZXM4VGlL?=
 =?utf-8?B?UVEwelRrR0dMR2hoQzZOVlRYRG8yZ1Z3aWxNb0puaytjbEgxR0tIajBxRmxh?=
 =?utf-8?B?eDdxK3NmNkc1T2Eya0dvZ3pwMEVhVlBhdTVZcGdOZ3RacFNha0NFODBUR3ZL?=
 =?utf-8?B?YkpaNGUzL1pXNjJ2VkZWQTNPMXlVSlNvSS9HdVFlQU9QRDJ0TnVUTlNxbnIv?=
 =?utf-8?B?OUFZUjM5MjBEeWJQcXFPRmlyeUJTN3BUWjlBbzN3VDBtbUZXaVpGRFhsR1hL?=
 =?utf-8?B?WmVpVG1LQnpRNE1tVVRoY1laYjZBSTh5TE0vcW42ODF0a0J5QlUzY09nQ29l?=
 =?utf-8?B?dGdjWE9SOTA3eDdka1ZZaGExSzJqYVQ3NHRUWllMMFNmRlJzV0RjeldLd0JH?=
 =?utf-8?B?YUdEaEFEYVhEbDhIa2Q0ZFdEeXlWWG5TV2w1aU9RYnFwbTdqQWErVFpIRFEy?=
 =?utf-8?B?bFoxdmkvVXVsbk1PaVcyVzl1NDRZb1JPMkIzalVQU1UwUkZnZ0w5Sk16U1ZG?=
 =?utf-8?B?YW54WlRnUWFTbS8zZlhOdzgwWkx3VG8xeUdxSnNYNFVZWXFsb05XdzNrZk9x?=
 =?utf-8?B?eFpnVEFuREZLSnNVeGdHOEl4cGs4Q2R6QU1Nd3doeFpwYkNPTXpNSWI4K085?=
 =?utf-8?B?Snljb0JQU2pWK0ZjRlVlZU1GN0VrUWszVHVhaHdTTTI3bHdmZUZldDZKRFRW?=
 =?utf-8?B?aFlLb0ZmcjNJYzFZeUJTK2tNY2M3NStSajhrSHhiWERCQk91K2tEeXZNa0E4?=
 =?utf-8?B?QWFVWHVEZ09PQ1NaVWg5bkFNVjNUY25zOEdMck5zZE5icXo2bExIeWp6VEFn?=
 =?utf-8?B?Yk5OcmVVcDBZcmNGbzVBNGY1Qi9YNzhPaXNLSkNuZDVhOEU5UzM3a25kZmJ4?=
 =?utf-8?B?eEUzTWVGRWo2NXFtYnY0YnNtMGo4UUkxcWpjVzJpL1RKRWkzWG5xckFJeWdI?=
 =?utf-8?B?MmpSSERwUFVsaFZKYWsyQkZwc1RXYVg1eVZLM1h4LzIwNHkrdmNOcnJqUkRF?=
 =?utf-8?B?a1JOYkw2Tm1RUURTRUp6TCtWWmpWbTYrZDRoZDRhRnVWQ05iTEV2REx2MkE3?=
 =?utf-8?B?RHBoWmpoaDdlN2RiOWFlRUtMYkVmbVZDOWRPalNhU1NUZmtVa25wUHBRZEg2?=
 =?utf-8?B?eWRsLy8rNGxFQjZZckdjTUQydGNvc3FwTlRxcnM1em1vU1htb3h4L1ZrclNq?=
 =?utf-8?B?SVFJOFVXTjM2RE4xNk1VQnJudWRTVDN6MEU4ckhqTFM1VFI3K05yUTF0OEU3?=
 =?utf-8?B?elRlbW5FVlNlckl3ejREa1NHWVIxK0pFeHRFOU5KbExCd2NzVFlkTkFIOXJx?=
 =?utf-8?B?ZzV3Q2wwWm5pYkl6ZXZZc0xZMDRpbUlweXA0TjZLVTRiL01qa0VYdGpoSDA3?=
 =?utf-8?B?bXpadE13ODJtdmo1Sm8wUFZ6Rkd0VEhKV09YcXluQmwyYnorOEhyU3dmdm40?=
 =?utf-8?B?bDcxRU8yL3M2cU01T3dqRlk0SGhyckk3SjF6RStiSDJUaFZLSENzaEhQT0pI?=
 =?utf-8?B?NXVlMktyc0VocGxVRXJUcksybGEyVHpndDUzMGdzL1NQZ3Y0Wkxadk5hV1lw?=
 =?utf-8?B?V3VrRjRvcXFXVVB5cUtHZW9SejVhNFV4eDMrR1lwK254UVBkRVRSUFJWQ1hl?=
 =?utf-8?B?c0tlTnhpMVdFM1FINDFDRDdqSUlVR2tYOXcxdUdxY0VrcXgyL0hjUEN1UmxW?=
 =?utf-8?B?VEtBZys2dVl4V0I5L0VMa3ovcjNwT1IwNkRQZWZFYlZZbG9TVGZWU3ZvWC9I?=
 =?utf-8?B?QUhLeFRYRjFVbEdxL0F2dEV6MmpSOHNlOTJCa1loemk1V3hnRDJFZHNZTHJU?=
 =?utf-8?B?SU1TaUZQOWF5Q3prV1NkdEg0c3NLdkI4aHZTK2hIeXRKTXZyVkpNVVJMdVU4?=
 =?utf-8?Q?Ld8lJQvhPLtEv7wJRUtZuyH+k?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 316e47c1-10d4-4c8b-65b5-08dd6d930267
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2025 00:53:52.7847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZP7szXIoehpxPgoDZbViF1VxFpDEXg7DL+tqrEUq7r02WziYF9+cWtQ2fmyHD1xyKaGovprXnaV99zUWqwc5Yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8086
X-OriginatorOrg: intel.com

On Thu, Mar 27, 2025 at 04:41:42PM -0700, Sean Christopherson wrote:
> On Thu, Mar 27, 2025, Yan Zhao wrote:
> > On Fri, Mar 21, 2025 at 12:49:42PM +0100, Paolo Bonzini wrote:
> > > On Wed, Mar 19, 2025 at 5:17 PM Sean Christopherson <seanjc@google.com> wrote:
> > > > Yan posted a patch to fudge around the issue[*], I strongly objected (and still
> > > > object) to making a functional and confusing code change to fudge around a lockdep
> > > > false positive.
> > > 
> > > In that thread I had made another suggestion, which Yan also tried,
> > > which was to use subclasses:
> > > 
> > > - in the sched_out path, which cannot race with the others:
> > >   raw_spin_lock_nested(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu), 1);
> > >
> > > - in the irq and sched_in paths, which can race with each other:
> > >   raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
> > Hi Paolo, Sean, Maxim,
> > 
> > The sched_out path still may race with sched_in path. e.g.
> >     CPU 0                 CPU 1
> > -----------------     ---------------
> > vCPU 0 sched_out
> > vCPU 1 sched_in
> > vCPU 1 sched_out      vCPU 0 sched_in
> > 
> > vCPU 0 sched_in may race with vCPU 1 sched_out on CPU 0's wakeup list.
> > 
> > 
> > So, the situation is
> > sched_in, sched_out: race
> > sched_in, irq:       race
> > sched_out, irq: mutual exclusive, do not race
> > 
> > 
> > Hence, do you think below subclasses assignments reasonable?
> > irq: subclass 0
> > sched_out: subclass 1
> > sched_in: subclasses 0 and 1
> > 
> > As inspired by Sean's solution, I made below patch to inform lockdep that the
> > sched_in path involves both subclasses 0 and 1 by adding a line
> > "spin_acquire(&spinlock->dep_map, 1, 0, _RET_IP_)".
> > 
> > I like it because it accurately conveys the situation to lockdep :)
> 
> Me too :-)
Great!

> Can you give your SoB?  I wrote comments and a changelog to explain to myself
Sure. Thanks for helping on the comments and changelog :)
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>

> (yet again), what the problem is, and why it's a false positive.  I also want
> to change the local_irq_{save,restore}() into a lockdep assertion in a prep patch,
> because this and the self-IPI trick rely on IRQs being disabled until the task
> is fully scheduled out and the scheduler locks are dopped.
Fair enough.

