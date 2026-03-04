Return-Path: <kvm+bounces-72666-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6C9/Nob4p2mtmwAAu9opvQ
	(envelope-from <kvm+bounces-72666-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 10:16:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FDCB1FD6D1
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 10:16:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0AB0130F62D7
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 09:10:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7731394470;
	Wed,  4 Mar 2026 09:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YaHUJEf3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1C039184B
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 09:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772615400; cv=fail; b=Q5MBIMMtXxy3+fHMOef4xPJeM83PVkVln9pDL/oE4JykATMdOAhv2lDPM7YaRA0T4XLDpGAR42szeM1hW9LrUOUjBYv512A9hh8RWTVbh3EEXFOGauIgJ4UYYmyNSTI4Ft0bwcpGRMxcFUtsfUh3K/4xMAK8KrexIN8MKl6J52A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772615400; c=relaxed/simple;
	bh=6hGiOlf5eCXtwgAJo0ijYKokUM924Q0D1DS4xGz6cXQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BfD4pOVz5JWQ6zrkEPE+AIAD5jYZeDNKKYwqW5C5cN1IdQmehe+ML4HD85VvKvcGg5kfi/zU1KDO657RLEDDuAhj6d47yrd0U6NOem3wt7BGFve2XBkvZLbZnGy4pd2/+lL/QUafmdo7IHRWJPiOPbA43hkRzJC2lDUH0z/Y2bk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YaHUJEf3; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772615399; x=1804151399;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6hGiOlf5eCXtwgAJo0ijYKokUM924Q0D1DS4xGz6cXQ=;
  b=YaHUJEf3ntXevQC9SS5d05gNpXY2a1l2sSDOk3dakWIEz7RGaSza9ixb
   3yIq633Q2w9vJErKdIyIWEIyQKzf9E2zR53/ETRkZQS0j8UwJeKOe5KKT
   QCwwvTFbFsme4i+rahiUHpeosjt6UFMDjLpvy7zPVDWksetrJNpLaw0x7
   FbKIrDOjI9PxNpl7RPrBDkQChVyXlHxsdcN/KLmTXBwPD2yvm9zJUVbZJ
   p53qMon76AaCaHeDr1zpQsuI2GfnNMATFjizzKXq/L1UvQ4wtyFVyljKo
   Oo4JOIsR0h5ybP9RqEn/pS32giPM2vnmXpLCr3UoZkoRctYSrdxZSmWLX
   A==;
X-CSE-ConnectionGUID: fEjDs4ajQria3LSkMxUL1A==
X-CSE-MsgGUID: X4QkYO0eRA64rFaUcBHkBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11718"; a="73860503"
X-IronPort-AV: E=Sophos;i="6.21,323,1763452800"; 
   d="scan'208";a="73860503"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 01:09:59 -0800
X-CSE-ConnectionGUID: 2gZcrIBQQWW92sjmDpDa6Q==
X-CSE-MsgGUID: jT/5x5MgTCGAQ2hQHzJy9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,323,1763452800"; 
   d="scan'208";a="222447638"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 01:09:58 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 4 Mar 2026 01:09:57 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 4 Mar 2026 01:09:57 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.29) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 4 Mar 2026 01:09:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rIhAyvlwYu5PMYIn8dfmHCcv/wF9RDJlHMODMo5VSDAcBWQRFv9do8TfJC8vPDig/46ezcw1px9Soeo/yj4k17PvTHEKkE03TKC/lNmxgbCEvaPV4PQFyI9M4Oomwz/08EQXZNAF7LWiC852kZ2pZJQqW45edHK1njiTw0KWmw1K9fkBVWA1ECB3CfQ3ZqOPdvmP8uwmV6RjK10cgVpG0JPsFGUlPjNOM7+EH7apdisBi28Nx7/ZygAMusinKERIpb2eOVDPfrbB5eu2UQa0WTrrCNfI6C0JHUcsPBAchEzGo5atoYPrpm5N/+d6WM0ykMsYk+W4c0ig7D6Ysfy/YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u1x7m+5Ag60ej4cNzlwfJMniybcmtWxid3qVGEnXLJ4=;
 b=AF/1GDCrwDDEkqFlbVcg2b4a9G/VKlrEJL1EF3cPJPC5Dc8KVxzanhR1PHaHogrw5GvfRFquFJyjXPtiaIpp01VgVtejDEr38lwnk/hlRJT6k3qROcKlOJ7jO3pRvXPsS/QqtN9K+d0dcNiiXUeJfKCg7EEHkfZNEU6HCUnT4P95ThQXzVFQcqjc6PUNNgQDdDGowtGdunR/IBy8Th5SePWBsXImp875e+5ssS34OLXY/EQsBWFZs+jkxgF9WIIlHBKao90JuEymUqRlVO0nGKVSY7Ia/S5fD0KjQz7UTPD1LvwuAXqGPnCxSIVnZOqkD+S8O0COKtLYadYQeluDUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 CH3PR11MB8185.namprd11.prod.outlook.com (2603:10b6:610:159::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Wed, 4 Mar
 2026 09:09:55 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::8f1e:49f4:122c:c675]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::8f1e:49f4:122c:c675%4]) with mapi id 15.20.9678.016; Wed, 4 Mar 2026
 09:09:55 +0000
Message-ID: <7095d5e0-e6a0-46cf-aefd-44932a736b97@intel.com>
Date: Wed, 4 Mar 2026 17:09:46 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/15] kvm: replace RamDicardManager by the
 RamBlockAttribute
To: <marcandre.lureau@redhat.com>, <qemu-devel@nongnu.org>
CC: Ben Chaney <bchaney@akamai.com>, "Michael S. Tsirkin" <mst@redhat.com>,
	=?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Alex Williamson <alex@shazbot.org>, Fabiano Rosas
	<farosas@suse.de>, David Hildenbrand <david@kernel.org>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Peter Xu
	<peterx@redhat.com>, <kvm@vger.kernel.org>, Mark Kanda
	<mark.kanda@oracle.com>
References: <20260226140001.3622334-1-marcandre.lureau@redhat.com>
 <20260226140001.3622334-6-marcandre.lureau@redhat.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <20260226140001.3622334-6-marcandre.lureau@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0049.apcprd02.prod.outlook.com
 (2603:1096:4:54::13) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|CH3PR11MB8185:EE_
X-MS-Office365-Filtering-Correlation-Id: 60c926ac-e704-4e3d-abbe-08de79cdccf9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: qyPbZomtp5kgmo9KhWp033bFzmmnlnwVxzS/C40s0vtObBaVQCuxHIGyw239MOBGJ5d206XwxItJyAvcP28t/izoSCjfSKHzECqoUpVzL54cMwwpWbUB8bhwap9RRQQmQua2YsLt1TXHjwvuwse2M19uUJs4rp00ZudyArPurYj3TLObMfuAk0a6Kp9dFE94H1CqdG6c5xTW7l7PQTPMGLEj6QvP37jqMpNjQp5pDxSqK5uXfqzyq0lgY0a9InYp4EMj9onfXnU10TNvXQs6qXQ2gPu5qrUzZOEK8ua1xLCmIJCCCh6iCrZu14i5zsBNNrp5aYauxLnLkeTSJXkrGI3Q8h4cKhOudlgBDxOt6IJ2z6jJJ/Mti5oxnoTKeRYVjI2a0YxlVDCniIXV2aG5TS5Z1EUSVkss5oiSAli1ii3xG61NehPLVeTQnX2llT6a/iSkHXqKM2J8F+/cAs/tl+oG8c/7dTT8a4O+9JfXW7mcCOD5/5SXudA5p/pVbVY7yGWM4c5ZdzAsN7BZMJlefGCVio5nkcge6a87mOw1J+wBmj2ANCM0oW+AKxOycAGdzkFjbyZAY/fccPeOcMwq6/zLR8AdM3CoeiVkZ6Ch9ZUcIOP50LGGU8I9nGUqiKZhrwV72s0gYbY9mAuCsgFTwetBFF8vG3x2UoiJcDtwUddxoDjoP+3GnXmIwSsBMG5jvwg0Hqf+DCxGAkH9Dupc5wm8LRtFS6Ro6KJSXqTwy9g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WDdVNENFTFpEbEFKUUZLZ2dWZFhyaG40T21zbnZKdjlNZzRUWFZzUk4zWXk3?=
 =?utf-8?B?aVptTmNnTjZsWGtxYWFZVGtNd3BVTW12dW5SRWdJNzg5NzNkVkpSMUlWaktJ?=
 =?utf-8?B?eURGajV3RTRobUVIVS9sUy95dGEzSDgyZWNpN2ZYenVHVXZlTm9VYXlPTmIv?=
 =?utf-8?B?aUlaZWdZSUd0L1FlZzAxRWhHaHRaNVdCUk0vMlo1akdNUHVscXJIZWp1U3hX?=
 =?utf-8?B?QjZ0eGd1dHVCazVQUUh6NFlINTM5YzExN3M4eVpRclMxRGNFSVNxaUpENFlF?=
 =?utf-8?B?d2ROenpSOTYxaGtpR2g1cHpERC9jcTBPVHlJZUQ3VnZpWXdPeEwwcDcyOGJH?=
 =?utf-8?B?dWJmRWNna2daUjMvSmpNKzhVbVZPbGIyblZlVWU4RVMxTG5sTkNSQnpLZUln?=
 =?utf-8?B?SmkzaTQ2YVVYK2dYQjVxbzhvWk01STBmYlVLQ2VIY2R2U2w1QjhsVitkekZz?=
 =?utf-8?B?TllHNkRNc1c4VW8xdGZqUit1WFZ3dnZYU3A2QklmaFpMMDk1WGFJMlVVd1hL?=
 =?utf-8?B?UnBHQXRxTWxEaUdDUzhqS0RGV1FSNEZSN1ZZU05td3hjL3Fway9henNVbUNT?=
 =?utf-8?B?QVhYbS9QMmQ1NmE2WGQ5cEs4Q3JVS2lrRXZOVWFOMEdGa1REUjZWdm9FQnc1?=
 =?utf-8?B?b2FrTDNQY29EcFdYZzg1VUsrRVFOazN1RVUvblFmOGZhc2ZFaVgybGUwcjRR?=
 =?utf-8?B?dVI3dkdmOUxzeHVyWDI1dExYenVqc1FTZnRhRzRsUTd4YmFKTmZlY2hFdnN4?=
 =?utf-8?B?YytIdFFhajRUK3VFc3NsbjhTTEZUckJ6cFpINzRXOXp4K2tDMklKcUEvektN?=
 =?utf-8?B?WlNPMHFXUGZhUG9ZalJTbzl5RmlTRTdEb1JRcVpLVEFYVFBvYXpHK3lWS0Zw?=
 =?utf-8?B?UzRqUGx1dm5qTlljS0ZYL1daT0k2V1plbks1bWJNTUp3aGd0K1htSWFvNkRQ?=
 =?utf-8?B?NFYyeENLVVlMdG80M3NlV2ZaNDF6aG93aEdqM0RpVDlVVnNGUXRLMCtVMGNE?=
 =?utf-8?B?eG83S0RFK3NoOEVYT251MXhERSsrNk9Ia05aUXRCRFFMY29EdkxyQW9aUngv?=
 =?utf-8?B?OEJVaHdvdlBHOFdEam1EVkFWOWtCNk8yUXc2OGk5ZUx0OFJ1WS9WVTNncUdw?=
 =?utf-8?B?TzRiMlJUTzlBYlBkL1JheXl0THpldkUxTjBKNVFmRGtsdW95WU5IVlVIRE5X?=
 =?utf-8?B?d25POU5wVFFMYUx2aUxyQ1hhZGFjQzR5MEtKQzNUaUFLdWtjV2lyQVpoUTZa?=
 =?utf-8?B?Yi9Od1Nyd2lBeHRvT3N4N1ZETlErdXBEaVA3QlZaT0tUWml2NUt3YjVqaWNy?=
 =?utf-8?B?NmpXVXRVSEJjUWJ2dllsSm9FdmVyU1p1SGJuVXkrY0pSK0FWTTgybHF2V2ZV?=
 =?utf-8?B?OTdScENqL3F1UDFtMUQydDV0dWdCZGtSQTlHR3liTmRrbmlaMFlRcFpteHpV?=
 =?utf-8?B?WEl2bUdSNDRtYVpiTitIdjhNV0NxSjBCM2kwbkx0YUErcmF2OUlVWWV3Q2dq?=
 =?utf-8?B?YlI0YjdUWkswYmw5bExTbysyeUdtYXVPZ1lKUit2Ymg4NjFLVHRHd0RGU2hD?=
 =?utf-8?B?OTJmUTBaSVl3Q29tRlhJWnQ4dXlreDJrNUpTRTRIVmo4SWtHUHg2bE80NFpq?=
 =?utf-8?B?ZDIzRlcxdnhFei9kemFla0ZaS0d2eGJRcVpNb2d5Q3NpcEFpdE1VUFFSNmRp?=
 =?utf-8?B?UGJvNm5ydkR0WmxkSHJGb255N3JZQkRMN0J0SmUxcFlreWxEUE95d1h3TE1z?=
 =?utf-8?B?aTl0ZnJGcGZYMXZCVWVPeVd2SnY1MENKMGJZcjl0d0ZKR3R4TEcyMk1uQmFY?=
 =?utf-8?B?SHVmclh5OFBKTm01OG5PVXdLZkluN09OMHhjOEgyUzRPRWh5a2lwb1Judkhi?=
 =?utf-8?B?b0NLeVgxQVV2K2NNQkx0TFJhTjI5cEpiVDhQK0Jzc2NsMkxqVEJkK0VEdVlD?=
 =?utf-8?B?MDBUY1F6aTd1emtGWFpwY2gwUHhqOGpqVmpOcFZ2UmF5STh4MFlwN3J4R1M3?=
 =?utf-8?B?dkJuOWJoUUtXZXhwN2UwVStpR1EzbkxTM0lHRkUyL25XQ1RBTkQxMzdTMnZ1?=
 =?utf-8?B?Qjk4WE1IOTI4MGFnL3NXbTM4ZWM4T25wSEhkY2ZUdmhySmRVRmVJd0I2MUVR?=
 =?utf-8?B?Yk0wQkI5c2hnQUF4ZVdyQjhkUGhuT3Rkeld0OVZsTk1aelBZT1ZhNmNWLzEv?=
 =?utf-8?B?ZVBkNnZtMXh6WGVZbnkwblJPaHRVK2x4OGt2T0o4SDQyY3VmVVA5dzk0QUpa?=
 =?utf-8?B?Nlo5cVZ0dXhaSFVyRGswMjdUZW1xVURnNExqRVZoWDlyZUJuMUR5TW51eVB6?=
 =?utf-8?B?YURiVFZSU3BOYkV1UUwzVlRsQWRTdU82V0JoZkxPTFlsZDhkQzNiUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 60c926ac-e704-4e3d-abbe-08de79cdccf9
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2026 09:09:55.1578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OUTvPbSXQi90cRk6gUdaD8tkp2dKnyBGEEh1Pm2uPTx29LmapOocCQy//1OHpzXdP47lU6rOSrimMr/YY3EMNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8185
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 7FDCB1FD6D1
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72666-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,intel.com:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chenyi.qiang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action



On 2/26/2026 9:59 PM, marcandre.lureau@redhat.com wrote:
> From: Marc-André Lureau <marcandre.lureau@redhat.com>
> 
> No need to cast through the RamDiscardManager interface, use the
> RamBlock already retrieved. Makes it more direct and readable, and allow
> further refactoring to make RamDiscardManager an aggregator object in
> the following patches.
> 
> Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
> Reviewed-by: Cédric Le Goater <clg@redhat.com>

Reviewed-by: Chenyi Qiang <chenyi.qiang@intel.com>


