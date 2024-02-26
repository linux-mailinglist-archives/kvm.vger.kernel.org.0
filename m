Return-Path: <kvm+bounces-9608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 92D5E8667AC
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 02:58:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 236AF28139D
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 01:58:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2C67DF58;
	Mon, 26 Feb 2024 01:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lMAhpXDj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0624A817;
	Mon, 26 Feb 2024 01:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708912682; cv=fail; b=gNwE2Arkt3IvpH9xL6wGDko+3vFaubTPlsLNtdPI/7ci+fW06pqyJ0gmZPL28G04UzAz30szWzz7NLWidP4k12Iv+T9bO8PfZW090TF9vHuqmJIRQhR5Dxj4thiGf1J4Mtcmj+Xe/xFou80r1DompivM1S64ApdHQy3ZZsseJO0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708912682; c=relaxed/simple;
	bh=drRvedsPVYcY6GW3WzidXRyO0afJ5PUe7/2vSLJXtNo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rOMjUNCaO9NZV+1LphiiZ8f4b9h9+siKCMlbHCTpXKbRA+7rr3InNYHbDfrIGcYhxBFIItlP3U/xEdaS6Q6dfllh1ik/sG4Dusa7qIzJ3wbg+SvdWJyULt/Jy9YY+fMkjN8wm954nbebA/XZ3UgNFS7qQ6QXbgaHw3Md9uvfqB0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lMAhpXDj; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708912680; x=1740448680;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=drRvedsPVYcY6GW3WzidXRyO0afJ5PUe7/2vSLJXtNo=;
  b=lMAhpXDjQqN72zN7XE0jjtPxNXLfcuQHdC1mzxbNlAlXd+Bx5fpGklkj
   VgJbjeizYOI2CpOJ5v7G/GnO7dNRisys2mhTJIJphwXmup0VTykqPr2dv
   QdIU1M+6NJGol67H1beI+f3NZfDMuVbqS89ZvPwokOrcjEUxdZ9UMgRdy
   mpizNAS7Tunsj3AaqJS7jlcK657HZuJy76ssEHLXLxJCrCyP2Ua1X3jqW
   l2kxWi8n8quDLFB85N0PBa+62g4+BrJUZqhstTkth7z5SBXekuyd8yvtt
   ztuk6MMM5F9GKCUNTyaFLEovVdZsoQS2sKpuOPs9GlC2U7XGInwAb1dNI
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="6988819"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6988819"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2024 17:57:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="7010352"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Feb 2024 17:58:00 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 25 Feb 2024 17:57:58 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sun, 25 Feb 2024 17:57:58 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sun, 25 Feb 2024 17:57:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L1bfOkhYgIkUcYlwUDuBYvfDuV3n7tPxx4BZPgWteCs1BXri5vG7xgVsKvfAOparTn60+Y2+snOSpLzf4eNKN/zYc31fuJHEUC1uZdqKUH2K1whYXrKZ0cd/rhaKsr6TDxE+X8H7KVjlqTA7SjJwzOrW6jfnNdnRKQXj0OHPHlL1b+ntTm33XaMOJy2tap5HRpwBHWRXuDDciSMWW8dhDfBhznlvY8NBNG29YT83UOEvT3KacNQvNAzQQum3On3csbeP+30l3vbiw+9PFeg/wyIlQD2WrQZqRsBcEX6WWbTlNyB3iRpQKpIvatlX6gqD65Cl7WsnQYrPrm1h1JmAUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ksJTJ2VxErCIArebaMxa8Eq9tdhF8S/bUpqcCIlRl0=;
 b=fPqr6wxoOQMP3TMyEaHZqFQ27ZuG8+r4jYGN2gTpFOU82G3HeisjgZcbbF6bQMQJho0sS6mcT3iJWZSIxrfqnuFhzpBOWWNKDO2E6zpLUZ2lw1b0NuTri3gv/Rw+YdhK1wcNwg2Jj/+bn7eex1zalshzN62zRJmyNSxBJtyinqG0/2Hp/XPrVxMYkp3HXO6xKhkHpam8eO61cfMAzeVGUbhvbaBz3Ea3td+0GzeQug5u/qJE70eeYtp6okuNqCZWvJ4a+6d6wDisiD9w1OmKwVx4MRI9mp5K/Rdw9D2Qv3Vnvlxh9pq8L9PjBDD9AhVVFXsBIwg0TDQ8DHoXnv0B0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4820.namprd11.prod.outlook.com (2603:10b6:303:6f::8)
 by LV8PR11MB8677.namprd11.prod.outlook.com (2603:10b6:408:1fa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.20; Mon, 26 Feb
 2024 01:57:50 +0000
Received: from CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::65ce:9835:2c02:b61b]) by CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::65ce:9835:2c02:b61b%7]) with mapi id 15.20.7339.022; Mon, 26 Feb 2024
 01:57:49 +0000
Message-ID: <7e118d89-3b7a-4e13-b3de-2acfbf712ad5@intel.com>
Date: Mon, 26 Feb 2024 09:57:53 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] x86/cpu: fix invalid MTRR mask values for SEV or
 TME
Content-Language: en-US
To: Paolo Bonzini <pbonzini@redhat.com>, Dave Hansen <dave.hansen@intel.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, Zixi Chen
	<zixchen@redhat.com>, Adam Dunlap <acdunlap@google.com>, "Kirill A .
 Shutemov" <kirill.shutemov@linux.intel.com>, Xiaoyao Li
	<xiaoyao.li@intel.com>, Kai Huang <kai.huang@intel.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@kernel.org>, <x86@kernel.org>, <stable@vger.kernel.org>
References: <20240131230902.1867092-1-pbonzini@redhat.com>
 <2b5e6d68-007e-48bd-be61-9a354be2ccbf@intel.com>
 <CABgObfa_7ZAq1Kb9G=ehkzHfc5if3wnFi-kj3MZLE3oYLrArdQ@mail.gmail.com>
 <CABgObfbetwO=4whrCE+cFfCPJa0nsK=h6sQAaoamJH=UqaJqTg@mail.gmail.com>
 <CABgObfbUcG5NyKhLOnihWKNVM0OZ7zb9R=ADzq7mjbyOCg3tUw@mail.gmail.com>
 <eefbce80-18c5-42e7-8cde-3a352d5811de@intel.com>
 <CABgObfY=3msvJ2M-gHMqawcoaW5CDVDVxCO0jWi+6wrcrsEtAw@mail.gmail.com>
 <9c4ee2ca-007d-42f3-b23d-c8e67a103ad8@intel.com>
 <CABgObfYttER8yZBTReO+Cd5VqQCpEY9UdHH5E8BKuA1+2CsimA@mail.gmail.com>
From: Yin Fengwei <fengwei.yin@intel.com>
In-Reply-To: <CABgObfYttER8yZBTReO+Cd5VqQCpEY9UdHH5E8BKuA1+2CsimA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR06CA0013.apcprd06.prod.outlook.com
 (2603:1096:4:186::18) To CO1PR11MB4820.namprd11.prod.outlook.com
 (2603:10b6:303:6f::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4820:EE_|LV8PR11MB8677:EE_
X-MS-Office365-Filtering-Correlation-Id: 339b65d8-96c1-4a04-dab6-08dc366e5526
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QWY7njsHVML5iLys5SybHgjN1nj/tH3TdEbPm9g8YjX4W4UUqK4SrkwLkOp5b1zolnJ4NOJhN4EqAbHDwa9tKTaihyaSqyCCxl8Ji8oCmEK2v5ALuEXbqoc5GdeMUxQh79NaM90lM6oS649uTeaplBmj2WpiRnRlfENC7+r4iy9k9LZMHN0qjos35ocB3BPPQqmrXKUNkYJE+v+IYjC0ayoq+df62tBI5yS9A/fobkvT8gjGe2IcAPWpdkWaK5o0KexZQc0i9JRW5cm/pq5qBcyrfCekNs6RptrSWS3szGtdYQCKxtaAypJRKnMpTc/NEGVOWKhDRodOiCLVUhBySLRF3fdETBR20vxq3JEKbM+CUQBzPRpAqIfZtAB5xK19hsJhNt25yfyBal2bfg4cWdB1PtQQwKkHwa5vtzSlFGmoeeCXIRKYoEaFskSMX9q1VCuuAfjWbRU2dPhks/4/yx232L9JzxuuvRqTqSCjGNYqnGYs0v1oAL+lhZkO9ytbMhd6Xkfz72Qb/2IbmO5c/dPX/znCVEXD7fTqsOZKtuZ1+Xu49nT2aTqeDDbKdVrBXRqIVyg3A78cXzXujO9LErFcUbwSkEXp7RbdY+0qShbDGDpO4SVHa4IN4JJqXiLtxweidE7d3PHadThr6vf8EA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4820.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eGlrSlRNNVJaLy8wNUZ6ZGNXczNHWGR2MjlwdzAwdXNWb0MxOWd3UUVpdzh6?=
 =?utf-8?B?SW1jQlJVQ1I1aEkrMHNENi9oanAwemdwNytaSnBjblVOTGJWT1VmU0RINFh1?=
 =?utf-8?B?WlZ6M3VZNllyUlMxYTBYalhvZ3lsV1RNZ0licm9sRVpsK05rMU81anFxbWhK?=
 =?utf-8?B?bjc2ejcrNDNXbTRraTYvRXlIYnphYm1IancwbjJyTnFscGFDUUpXSUNHMStC?=
 =?utf-8?B?ZS8zRnZYdFJRMkhST3F4R204UjZERU53M29maVBsNmhzdWZKSWgyWXRZcEtE?=
 =?utf-8?B?dVA3STdzWmVVVWhrRFdKMmVyZ1hOUGtXZExsWGgxSGFvcUh2Vmx5eDk2cDll?=
 =?utf-8?B?d0JrY3YvWlpSRkFlUjhvSnFSWWZzNUxwVkEyQTAra1dEWDlXMXdPWlFRS3V5?=
 =?utf-8?B?UzV1cUlpTHQ3RkJDWFdoaVRZWS9XcHFibGhzeWdoa3kxc3lydnV4dGs3OVNH?=
 =?utf-8?B?dlVqRWJscVdheUJIOVUxZURMZDFMWWlYYnFQQWZHcHNxQVdqT1pCaFRsOHlp?=
 =?utf-8?B?ODZ1VklmY1VFdktidU1hMnd5VmlGb3pVbUhpQUtrTHhzNDhzZUxnL3lEOGZX?=
 =?utf-8?B?QUY0bDc4UFNHS3k5K05IZmRhYTZPT3ljeGFvOWRzSEt0UFl3bEZ6bVZtK3B2?=
 =?utf-8?B?Sm41WWN5YXhjYmg5bUhncTFJSmw3NGR6YTY3SkIrck9Mb295ZG9kdnlOcXRI?=
 =?utf-8?B?QytOM0VsdFRRdGJPYmhwcGo3dlBlMzNvTi9tcHNTWFIyMzEwdW1tYk5ZV2Zn?=
 =?utf-8?B?ay9odXNVRkdZZkRPcHRwdnhKOGFONVU3TldIdnIrS1NzTy9naHI4N2w5M1I5?=
 =?utf-8?B?cWNzbG5FRnIwajM1L3NUNVpzMkJrL2lKd3RkZG1GLzZ0ajkveEZlQlhjUU9G?=
 =?utf-8?B?b1ZSMnNYWmg1anE5MjdER0RPY3greGlTV1FHaGNaK0QyMjZXZXZNTGpraDZO?=
 =?utf-8?B?cXEyU2FuZUxvWnJoelpOSzROUW8xMytZSWZZaU1VZ1FocDVmUEhnNk5QcWFy?=
 =?utf-8?B?L2pscVR5UFlENXFNaWx4eFNjV2Q4Sk5iN0FPYjNBbmk4aDJRUFhiMzNwZVI1?=
 =?utf-8?B?MXRKUi9hRSszdVZKNmpXSWpMTnMrc01zbWhOUUdXOWZIVWFmZ1JtV1hBaTNG?=
 =?utf-8?B?K2wwRkxTL3NUR1RybUVpakxSdlBhMVU4TXhGL1VDSWVmN0xrRS9yNW4wVTho?=
 =?utf-8?B?M1R2QkF4REVwb3VqRDd0SXAreUI5MDVFbkpnN0lSMGkzMVptOU1mL0pIN3Fy?=
 =?utf-8?B?MmViN2dhWlZRNXBjTVBrYU8wRkF4djZjejhmaXNzTjhnZlM3OXhTb2p5MWtn?=
 =?utf-8?B?b0g4MjFrUHZhTEN0MFlKNUpuYk10ZnJwck85WkxMallmenFQb2JvNkJCOENH?=
 =?utf-8?B?RUhSWXdDZWZTUWc0WFNUTUgxWC9laml0dGVOb1Z4Ni9YUGxxTVlUUFhKZGxs?=
 =?utf-8?B?bzJzTzZRSUtWTWtNa1YwMXBhR3dMNHVIRGwyUDZBUndJY0RRc25PYVFUd0J3?=
 =?utf-8?B?amtVM0pGbVMrNDFkUkM1ZnFydUJiWTByT0xML0dKT01YRzZZdmw4TVd0clJU?=
 =?utf-8?B?TmorNm1NdzB6Vkk3dFdmWFlLWW9mUEw0YUtJTHF0eVBNVkVVY080OTYvK3Fu?=
 =?utf-8?B?VVNieUdzSE5EaE15cFNTajFob2tuODFYd0tpN3lKdTdCZnhiRXZQaGpzbkhG?=
 =?utf-8?B?SE1CcWdpOERlUDV5R0hjT0NIUnZXR0FUMEhER2M2elBrc2VlendIL1hzM0sy?=
 =?utf-8?B?NGhaVll4cGJ6Nm1NdHlZZ2ZKSmdqQnE4T2lCQ1g0dUlQUWtjUzEwSkY2L0k3?=
 =?utf-8?B?RUZUV0NtaFJxV2pmQm5sNFRmcEJzMjByaXEyUEx3eW5BUEM2RzNYalpzL3lH?=
 =?utf-8?B?WmZRNUVqTHhBTGNoT3dVRjJMUTJzUTVFSlVjVm5ySjZMemtMT0lvZW1pUDBX?=
 =?utf-8?B?UlNQZXJidllhSHhsK1VjczNNOFFKZG9Qa2dHVjNUdXE0d0lTUExVNTRvTnR4?=
 =?utf-8?B?blhlZHloeVVnNE5ac21WcThIUjV2M2V0M01wOVBTNlgybGp6TWNzQVJPZWF5?=
 =?utf-8?B?QWNrU3J1L0kySG04aEw2ZUJMTVYwT0RRekFXanBxTDBwQ25oNHZUb0o4T0t2?=
 =?utf-8?Q?FkkNfof7zb2bsPQh1b1xLtFnr?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 339b65d8-96c1-4a04-dab6-08dc366e5526
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4820.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 01:57:49.0923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: txis6wqiMqXn5t0k2Cpw5Cyvwtb8qRGRifEKhtoJeMXvufYYPzx3eJ3lhwBY2p5+HEQd2isa0QDpzOIORMaXKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8677
X-OriginatorOrg: intel.com


On 2/23/24 02:08, Paolo Bonzini wrote:
> On Thu, Feb 22, 2024 at 7:07 PM Dave Hansen <dave.hansen@intel.com> wrote:
>>> Ping, in the end are we applying these patches for either 6.8 or 6.9?
>>
>> Let me poke at them and see if we can stick them in x86/urgent early
>> next week.  They do fix an actual bug that's biting people, right?
> 
> Yes, I have gotten reports of {Sapphire,Emerald} Rapids machines that
> don't boot at all without either these patches or
> "disable_mtrr_cleanup".
We tried platform other than Sapphire and Emerald. This patchset can fix
boot issues on that platform also.


Regards
Yin, Fengwei

> 
> Paolo
> 
> 

