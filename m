Return-Path: <kvm+bounces-52888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 40AFCB0A40E
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 14:19:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D1911694A9
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 12:19:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09E1D2D9794;
	Fri, 18 Jul 2025 12:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kBfO6nd2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7613F1E49F;
	Fri, 18 Jul 2025 12:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752841183; cv=fail; b=D1cK3cDzTKEv+zSIkd3xQPsb0zrKg3gcgEz6gsED+AzSs7+njksXeHYOuXvdIXvDOA5cLQ+oy5LyliRgmV7Lq74iRi+PKldl5q6pvn+mJohhpyqpwomUcxGSVnM0tvRf39hE4m6kMLoPHiwEuklqDXfRYQ+VMrLjSUNptKEOXR8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752841183; c=relaxed/simple;
	bh=P0m0kX/QCqIHFVeJBUP62XWl/sCp5rsR42yX/OVeww0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=e+idt3xfx4gNTTtL4ila+rYbr/i5BYLaWj5AZ/itRphqdhIM0liHK732eJtw/3Ued2qJWPTx/X6AjuMw7HbKT/nm4a6IWKhKoMEaO4yTUM29kJv6WoUFK+gMdpgCMbTd+JJNKN5dnLwPbgbmKM1oWCfRVGxsGf4nGgObj9oDmjM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kBfO6nd2; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752841181; x=1784377181;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=P0m0kX/QCqIHFVeJBUP62XWl/sCp5rsR42yX/OVeww0=;
  b=kBfO6nd2bkHKqqaJeSatdficnctHff6Vk4Y2PMwRFSAIw8XysaRYPfoW
   sy3EU26vcO6UORt6DzlRTE0pLc5CQdjltJ73+GCQh9kRHK9V4ZyiqlEqO
   Fj+yegDWs5Wcvfv2cBY+uVKX+Hvb2JBm091iW9UDbHbvKisGcnWO6aMhW
   t/rCKa2TXTcEP4T+zGkwlDAUZfu4DUkCbWc2PDGd+r2Soz6DINX4cLFGC
   Ai03siDNT+gUSE6o+/EBw2lS2JGpNNdVcFuDsVW+yGm4hPqaT9/RQcNDS
   q3GEvEf2cVVO1213PsWo+pqbUN8Fx4Vy9lrW/OOmK3XbFhuDSd4+PUvWy
   A==;
X-CSE-ConnectionGUID: SuALMuxvSuGrN7kojaf9mw==
X-CSE-MsgGUID: 71/O+bAkQterdDNyx/gnGA==
X-IronPort-AV: E=McAfee;i="6800,10657,11496"; a="66582356"
X-IronPort-AV: E=Sophos;i="6.16,321,1744095600"; 
   d="scan'208";a="66582356"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2025 05:19:40 -0700
X-CSE-ConnectionGUID: PK7N0hi0R8ujDwosK94FhQ==
X-CSE-MsgGUID: Nz1+ZqvhSoyAeUSVI4lMlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,321,1744095600"; 
   d="scan'208";a="195176824"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2025 05:19:41 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 18 Jul 2025 05:19:40 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 18 Jul 2025 05:19:40 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.65)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 18 Jul 2025 05:19:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xxniUztO+4G2v5IeNslTNp+CyKQGb6T2YO8qbIcMORzd0d6IH8UpIxyXY2BbDuXI/GoyX0pBc3oT0jTjtWBWqluUASnCSTib1f90QnV7s04Uo5oHbBJkMmU95OFLX+gDi/OTjyqB3IEdLYoIwoZf8r2edHCpqPe4qWnxwoFjFlwuPF635bF0TWGbJGGEstCpKwM7HHCoFDTBcrSfjwCtAIKlqeMrunbXWFKZkR/24nNc124xsVTR6Vc45nCB9MCq42ZDPH2FhkkYwGVnzGKUzmXZsw6egQUlf9TmRHWBLk+gHkPWGotsjOa+bqrr/TXM5V+UY+alpKqbI/joKI6esA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JdminyjoRWEBZoQWpX2sAzPe9S8JVlU0eyUh0hvbcXQ=;
 b=R6cJoI+d+3eQh7T8/XmS/cZ5huZUXWZtjthb9b2Rbz3FVFIjQ8Tm6FL0sp4fiMpv97xxFji/DQXLBhpZe6WCfuoh4Gye0eRfKQbCBhIY6HJXX+xSiW/mcHq8gXTp+XVN5s7MA3Afln2VfuyW5LOAZPJ9Hd0M4u9ZFNL7sFGFSVZ/c2RhGWLXPivG8SV4obyG8Rt/bkeTJfq0voDPC87/GNh6bLtu/+E19P1dseZdjoK/Z3tyKxQ+PudchJM01BRr+SfNBFKd9zg5N+EXaEh50Lx25FP9VkVKM0ezCm5LIrsxb17gsz2mOE0xlqyDwHsxyMWAuFSg2b3l1o62ZJgj/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CO1PR11MB4945.namprd11.prod.outlook.com (2603:10b6:303:9c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.39; Fri, 18 Jul
 2025 12:19:21 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8943.027; Fri, 18 Jul 2025
 12:19:21 +0000
Date: Fri, 18 Jul 2025 20:19:09 +0800
From: Chao Gao <chao.gao@intel.com>
To: Jason Wang <jasowang@redhat.com>
CC: Cindy Lu <lulu@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "Vitaly
 Kuznetsov" <vkuznets@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "maintainer:X86 ARCHITECTURE (32-BIT AND
 64-BIT)" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, "Peter Zijlstra
 (Intel)" <peterz@infradead.org>, "Kirill A. Shutemov" <kas@kernel.org>, "Xin
 Li (Intel)" <xin@zytor.com>, Rik van Riel <riel@surriel.com>, "Ahmed S.
 Darwish" <darwi@linutronix.de>, "open list:KVM PARAVIRT (KVM/paravirt)"
	<kvm@vger.kernel.org>, "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] kvm: x86: implement PV send_IPI method
Message-ID: <aHo7vRrul0aQqrpK@intel.com>
References: <20250718062429.238723-1-lulu@redhat.com>
 <CACGkMEv0yHC7P1CLeB8A1VumWtTF4Bw4eY2_njnPMwT75-EJkg@mail.gmail.com>
 <aHopXN73dHW/uKaT@intel.com>
 <CACGkMEvNaKgF7bOPUahaYMi6n2vijAXwFvAhQ22LecZGSC-_bg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEvNaKgF7bOPUahaYMi6n2vijAXwFvAhQ22LecZGSC-_bg@mail.gmail.com>
X-ClientProxiedBy: SG2PR04CA0182.apcprd04.prod.outlook.com
 (2603:1096:4:14::20) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CO1PR11MB4945:EE_
X-MS-Office365-Filtering-Correlation-Id: 0df90934-636d-49b5-8e79-08ddc5f5534b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YlAwZExtSVFHcUQ3SHpYU1RMTWFjVmR2V1hXQWNiY01mWit0NlBpL1VCdXA0?=
 =?utf-8?B?Vkc0MGdVcUhDQnlDWTNTOHA2TWF6UzVtcWFEUHJVQkFlMzN1bGlXcXZONGhj?=
 =?utf-8?B?NnVVZXh3L1ZKM1RZMVFNR2R5VkVwTFFIRk1sRTk5R1BxREl4YVN4M1VhVEFF?=
 =?utf-8?B?V2g2RlRUL3R2M0NaSjRTMi8xK2N1dlhyMCtKUCtKQU9kVXdQcHRVdkxYT0l6?=
 =?utf-8?B?c041UGc3c2YyTFhwYmRPeHpKTXh4UVZyRGd0cWJOMnVHSG1PUEpPUytyYnlJ?=
 =?utf-8?B?V0ZXL2lPUi80YTVvbVZ4aVd5cGtNcFpaUzJIZHZKM09zSkNhY1RFRVRDVFZk?=
 =?utf-8?B?am5pdGhVaEpqeHB5VnVRU1JOaTMxWEN2VnBDYWxFaEdjcHo1bkNQa2dqSk8r?=
 =?utf-8?B?M2JnN204NUVhNlRyb0dVVVY3UkFPcjFObHRIZlVGU01UV0dpeTJIbkJhTnZr?=
 =?utf-8?B?WVpOUmFwbjU1TTAyUmRmTjU1NEpTRnRhQlVXR29lakQ0SkV1bkl2V05Hdjk5?=
 =?utf-8?B?KzBjcFpLa0dVMW9wQnkzdkpYMUJFcmZNRU1PdHhWUzNJbUNXVkJCY1FYSDB2?=
 =?utf-8?B?M1QzTjBRd2lobVVkZ3hyWnZvaDZIdGVXbG5MTjB1THhOZXBuQmJGWkZCb2dw?=
 =?utf-8?B?NzlsUTVkaFN6bmlHd3lTc3VKU3Y1RjVOVmZJS2VRZzdTQ29mUGwwaE1XbmVE?=
 =?utf-8?B?N3FtTWtzWEVyRzA2R0xNZjlwR01LRG1kMTlvTDdsWUJlUE93L3FkV2NnL3R3?=
 =?utf-8?B?U0kzVGpCM29LZVQzZXhKbTRVZCtNd24zZmFUYlMvQVI1RkorTGRMNm14aUt5?=
 =?utf-8?B?SUl6VTVwajl5ZXB2M0xHbE54RHByN256WVlwR09Ma0U5UmhyVzY3MHM0QW1G?=
 =?utf-8?B?SVA0NmpWN1NPVStWVkZVZ0lZMm9oS01TZm5RTWp1UVdFVlFxb1dLdmdRdDhz?=
 =?utf-8?B?cEkrWVZ4TUNHdVRYcVZNTHd5M3FsREpQOUZEenkzY2hYZU1DdmhpL3lmbG9P?=
 =?utf-8?B?Zlp5VTJxRVI4OTBpOVhNL3ljcDMrUHQzUSsyVUxjTkpyOWZ6ZjVBRVB5WVM1?=
 =?utf-8?B?eVdaU3R6MjJiNGVEcTdXNFJtZkNBdmkwaSt1YkxpZTEybytOVkpRcUMxYmV2?=
 =?utf-8?B?VGQzYUpyZ2FUTTlzQVB5SysxRnU1NDZTL1BDb29jVXNjS2lQUGd3K0JMM0Vk?=
 =?utf-8?B?WW9DbXc0Y1B3M3N2dG04RlNrSVg1bU50Vkl5eFlDS2tkTUFxMmlTTyt4QTAw?=
 =?utf-8?B?NFVPQVRPeHBZZFJjQzhMVVJoL3MrL0d0N2hVL0NMVEYzREtST2NjTnUwZkVk?=
 =?utf-8?B?OUpVU0RFMFBRYmZzZXpENGhNYjVMeFFmVnliQVZ6ZS9Db3VOZ3V1aG1SdDl0?=
 =?utf-8?B?Y2krMkc0Y0YyVVN5UEhHQW83aysvMlBsZkIvTGNFc0N6QTJZUXF6cEduelFy?=
 =?utf-8?B?TGtNNkt2QWZXK2tGT1dYZlk3bFRGMWJIMlJEbmxQd2padVRsNzlxejRZWXhT?=
 =?utf-8?B?NEY4d2l6NkZtRGhFSklycnVSZFM0NjYrTTBPRnZlNHI1QzhGTk9oenVlQWhk?=
 =?utf-8?B?c1VudFFSd016UytYZjJsZWV1T3Y5Qnp5cWZWbmNYUE0vUFhEeGI2NkZZZXZ4?=
 =?utf-8?B?bGhzOTdkWFFhZVpXVXl5RmVVVE16aEZjWjF3RVlCeWptL2o3YnFnMlJrYVcw?=
 =?utf-8?B?Slh1aXVsNmRTNU4xanRjaGZtYmN4VXFoUEhzUTE3OVhBTUdIQmpPZDJuVkx6?=
 =?utf-8?B?L3JEaDhDaXg0MGNIbm5kOWIwY3gzQWY5clNER2ppYzBvdWFOcWh1VGdWZmFL?=
 =?utf-8?B?eWRCbGFCQXlJUXJCNEZUYldsT21TZm9zbVBST3BPSWFsak5ZLzZMa3pBTTFN?=
 =?utf-8?B?a0lqTnlOVjVZc053N05uZ3dqMkdNdWJFSFBLbEVHbjZmaitYSWpGUGMySng2?=
 =?utf-8?Q?y79s7VTdnSY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K3hrQ21IUzJxeEV3MzJ6Z1hFbEVlUkY3d0N5UkNsdXY1dEtxdGlySjJ1Vmkw?=
 =?utf-8?B?VmJzcStMSjdmRnkxYjVnU3NVTlRXUGZOWTV1bURHL2FBMWhyaW1SbG5oL1cx?=
 =?utf-8?B?V3RLZ0IyWk9PYTZzV0UyR3dldEdCOFNGQlpRcE9wWU1QS3RYSXprZFZPUGJl?=
 =?utf-8?B?WDRrUEF4LzJ2OVhEUXd4Rk05NHVBNTE5M1Y1Y0Q4c25MUzhIMm5memx4K2F6?=
 =?utf-8?B?MC9GS1NGR1FqU21VRk9nSDNVdytHNERveHp2R1k2d0QrV0liUGNzaVFJM3A2?=
 =?utf-8?B?OTJ0Sm03bzZzaGxBQTV0RjYwYkJKbDFmd0hlTmJGVFBKblZjdVFVNnI1TTZZ?=
 =?utf-8?B?QTR2RkJwMkNpR2lBcUVEbENmV1BUemRQdlByMjNqVjNFeUg1VUFJNDdSZjFR?=
 =?utf-8?B?emxtVHdrVnhmVkFzeVRmTlN5N3VRT29OZHkvbkRSakNLOGQ2aHk0aFJvZFdk?=
 =?utf-8?B?Qmh4NjdEWEtnSW0vZFkrNVVGaFMreDUxbmVKcEN0Zzh2c1BsRmlHUlNqMURw?=
 =?utf-8?B?MzF2RStyd3FrM2ppdnc0QjJFTDRvSzZaY0FPTXdVUlNwSUVwSjhqbnNGdWhj?=
 =?utf-8?B?NWp5U3dwOGR4L2xRVHdVdGFFaHR5Q0o0Wnh2c3N3MTdOdnhycE9PMTgvK3RI?=
 =?utf-8?B?czFBdVFZNWRCTFN5L05YT01pKzFYemhMOU5NWnRkb2tCMktacDcwMWJ5UWor?=
 =?utf-8?B?UmFGRng0dm4vSGFlNzdiOEgrem8xMlB3N2FFNU5uM2YzSGE5L0J6R1c4eDdC?=
 =?utf-8?B?K2N6NElLdy9xY2pwbkZEL2ZGOW03aVBIa0NmVk9pVldLcTczajRNeVZXT01o?=
 =?utf-8?B?bW9HaHR4ZmpxNkw5dWQra0ZCOHd3ejR6WXpBM2tmL1ArRUdlUU54YnhhWTdr?=
 =?utf-8?B?WHN5ZDM5UkJvQkorWjVxTm4vVXRITWpXSnU3dTdFUkVsK2cyRXJQUDFLVGdP?=
 =?utf-8?B?VzdlUUZFcHRHY1Q1Y0FYOHh1NG1ZYUY4MUlkUnVOTnBXMjFQcWlOemRBSHVX?=
 =?utf-8?B?STRSMGw4aUtWUjJUSENaN1FtbXBFMHJMS3luNWJBcU01M0tzanhwQXM1ajdq?=
 =?utf-8?B?SkJDWlJWVFZCSGorSGFLQVZ4cWVQZ1NKczNqT3hsQiswaXhRTWRwMktQWUhw?=
 =?utf-8?B?TkJUd1g4SS83clYxNGY1MzdtQmJnSFJMTmdXQ0ZNVjhjRVNKNXNrdzJYZEdZ?=
 =?utf-8?B?RzBsb2cyUjNkR2RENUFGMTJURHdnRkhieVlVS2ZvTUNJbTkxMHNqOVpuUk40?=
 =?utf-8?B?OHhoMnk0Q3BXYjdITnphbVY5Q0lVR2diRTludXpwOG4zeTZiQTdoZFZHejkw?=
 =?utf-8?B?SVJKaSszemFtdFZaekdmd2VPbG1iTEF6Vkk4NU9IVU03bE9YaGRVVGpxWW5l?=
 =?utf-8?B?ZEZwWXNsbHFUUkxiNmRWR0tvd2xhNW1URS9sd1FVdFRmM2Z6UXZrdWpCNUVn?=
 =?utf-8?B?dEJTZ053cUdkY3hVSG9QR3c5ZWlSSnpWb3lnVWt2blNUbHZud21sYkhjZ2tq?=
 =?utf-8?B?c2hzbWdDWEE5RnU1YWRuT2ViaEw5Y0dsUEk1RXNUYnlhbFdVcTVmNVFjNHd1?=
 =?utf-8?B?aXFwSFpvOXhrbGlBRVY4bi9QYk5YS1lXN2lCUlY4SnRrakNFOTR1VWdieTFH?=
 =?utf-8?B?TTA5dENDZW9rN3JJbVZadWlzU0p5b0tIMEhlSXZGVXB3Z05oR2dmU0FZWjFu?=
 =?utf-8?B?OFNkeUVWZTdocW9pYTV6dU9HbU1GQTFUMTdIMkxwSHl1VEdmamU2OVBidzcv?=
 =?utf-8?B?L09IQ3VLbElqVFUyaG1jckQyckN3QlpRcjNsOFNCT3M4YXo0SXhEM0NjRkJH?=
 =?utf-8?B?OUlVUGdnZUQrekg1N1FCYjh3c25rRHhzYjVPUVVkT0ZRQ0UwMW1VdEVrS3Zy?=
 =?utf-8?B?QkNmVnVPTUZQNko1aSt0dWdXZG1tNXZLaERLRzVOeDFlT2dtT1pwZVppcWdq?=
 =?utf-8?B?RHZaVGw2QWZzWnB4RXdkN0JZNHNVQXNQTmVaQ3FQWkhEbDdhYzdnWGRwdVVj?=
 =?utf-8?B?UStqbVBTRDlMU3gzc042NlE2cGFSRDNPNTBiY1B4SElkOUZQL0xaRDlkZkg4?=
 =?utf-8?B?NGx6QUdnVmsxMXZPU0tWcFpxcytha3c2Nkp4UGVuc0lnNWoySkU0UGZSQjkw?=
 =?utf-8?Q?2VOzqz40iUoBAf3IQ8j7WR0C/?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0df90934-636d-49b5-8e79-08ddc5f5534b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2025 12:19:21.4051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l989ZlV0JVrNLeHii+/4jxa5aMQTdK94KCy3orXKGhJ4Qr+P2x0Ny0ZyLY+4qofQKcOyYTZ5eYkRVtTyQ5evwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4945
X-OriginatorOrg: intel.com

On Fri, Jul 18, 2025 at 07:15:37PM +0800, Jason Wang wrote:
>On Fri, Jul 18, 2025 at 7:01 PM Chao Gao <chao.gao@intel.com> wrote:
>>
>> On Fri, Jul 18, 2025 at 03:52:30PM +0800, Jason Wang wrote:
>> >On Fri, Jul 18, 2025 at 2:25 PM Cindy Lu <lulu@redhat.com> wrote:
>> >>
>> >> From: Jason Wang <jasowang@redhat.com>
>> >>
>> >> We used to have PV version of send_IPI_mask and
>> >> send_IPI_mask_allbutself. This patch implements PV send_IPI method to
>> >> reduce the number of vmexits.
>>
>> It won't reduce the number of VM-exits; in fact, it may increase them on CPUs
>> that support IPI virtualization.
>
>Sure, but I wonder if it reduces the vmexits when there's no APICV or
>L2 VM. I thought it can reduce the 2 vmexits to 1?

Even without APICv, there is just 1 vmexit due to APIC write (xAPIC mode)
or MSR write (x2APIC mode).

>
>>
>> With IPI virtualization enabled, *unicast* and physical-addressing IPIs won't
>> cause a VM-exit.
>
>Right.
>
>> Instead, the microcode posts interrupts directly to the target
>> vCPU. The PV version always causes a VM-exit.
>
>Yes, but it applies to all PV IPI I think.

For multi-cast IPIs, a single hypercall (PV IPI) outperforms multiple ICR
writes, even when IPI virtualization is enabled.

>
>>
>> >>
>> >> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> >> Tested-by: Cindy Lu <lulu@redhat.com>
>> >
>> >I think a question here is are we able to see performance improvement
>> >in any kind of setup?
>>
>> It may result in a negative performance impact.
>
>Userspace can check and enable PV IPI for the case where it suits.

Yeah, we need to identify the cases. One example may be for TDX guests, using
a PV approach (TDVMCALL) can avoid the #VE cost.

>
>For example, HyperV did something like:
>
>void __init hv_apic_init(void)
>{
>  if (ms_hyperv.hints & HV_X64_CLUSTER_IPI_RECOMMENDED) {
>                pr_info("Hyper-V: Using IPI hypercalls\n");
>                /*
>                 * Set the IPI entry points.
>                 */
>                orig_apic = *apic;
>
>                apic_update_callback(send_IPI, hv_send_ipi);
>                apic_update_callback(send_IPI_mask, hv_send_ipi_mask);
>                apic_update_callback(send_IPI_mask_allbutself,
>hv_send_ipi_mask_allbutself);
>                apic_update_callback(send_IPI_allbutself,
>hv_send_ipi_allbutself);
>                apic_update_callback(send_IPI_all, hv_send_ipi_all);
>                apic_update_callback(send_IPI_self, hv_send_ipi_self);
>}
>
>send_IPI_mask is there.
>
>Thanks
>
>>
>> >
>> >Thanks
>> >
>> >
>>
>

