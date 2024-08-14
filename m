Return-Path: <kvm+bounces-24088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EFCFD95128D
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 04:36:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D0EF1C2225B
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 02:36:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02B94381D4;
	Wed, 14 Aug 2024 02:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KYJPxURy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA9837171;
	Wed, 14 Aug 2024 02:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723603007; cv=fail; b=AF9fDT8vr41NAxqRTPu+JUpXLA6SU6Wmvuu1KiwoE6R9HEN4zRd1F2J1Lvm5at0Fnlo51nIqfJKSrEl6aCVAx63IQ/GR8vDgsvx+/Z634Poc3sXNSYknMGJUIicHCIk8vKSs4Uj3eqjgTz/78CxZupNnLPd1eMiRxBZrJyn3euU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723603007; c=relaxed/simple;
	bh=wTIF9DAoPuTlnklOFbsrFrN4Otn/49X/CrWINVaFFNU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sQIWtAcRHiJSFYvCm1Olxu90/grGX4o2d1Xg5c3DG549OhD7lJPOqZry42YrP9sIDFdBFG+xL1hnzZDeHwemgwk0RdGbeA+p0sVdOSemjUt1q+nKCmzbxXEsEZTm4W3gI0p4ApuFFjxxhqQLgAXP4dJZo8UIt0eZOqipnGJd/cY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KYJPxURy; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723603006; x=1755139006;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wTIF9DAoPuTlnklOFbsrFrN4Otn/49X/CrWINVaFFNU=;
  b=KYJPxURylJTyGUHedmSNcigmnPaU2XEqyE7Z6RFMAcz1sXHuSbLLI5KI
   Ce1dZZJw6uuqAo1/4f5VpEP600rnZi/vc5ejaKSXZ1ZUZt8hHTsOA6AqI
   bFS0gteD/PR9zTRD1Na3MY6kzxvIm+c0F2tLqd7hcHlsHb7o8jdYpTMPL
   FIrgzk3jUDw7sH4Z7KQp6nJLb9adX0U7XY4hsQHiRDHJ89sh+I25YnGtc
   slJdijC9fgC7QLisVyaG90JjdLqAwzyhhrpifcFRlDS0+bTX5Q7rkhOzj
   GaodTHqJSVocpbCv5czE2fMyEYlHwE1sZCMZZA9H+eIkoTZD44Z3RhJDa
   g==;
X-CSE-ConnectionGUID: e2LNL+khSCuMl/mQUeIc1w==
X-CSE-MsgGUID: Pr6AF4NrSmqKW5KgOMCGgw==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="33206524"
X-IronPort-AV: E=Sophos;i="6.09,287,1716274800"; 
   d="scan'208";a="33206524"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 19:36:45 -0700
X-CSE-ConnectionGUID: RDvkiWLMRgW/FmpbbmZPpw==
X-CSE-MsgGUID: 6m0z5ZcBQcKxfcxe392WEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,287,1716274800"; 
   d="scan'208";a="63795560"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Aug 2024 19:36:45 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 13 Aug 2024 19:36:44 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 13 Aug 2024 19:36:44 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 13 Aug 2024 19:36:44 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 13 Aug 2024 19:36:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ed1dtYSMbam0Ei9n8sUWWLeruVqHLYxnwREJrYW5BYarmubbRgGJ+vRTMD3HzMpF6rNaS+nb4001jXYf0Ezg6Zd/te2RlHCm1fHXIZZiKc7PqLPW8C1CmDJ7JfMuwrvFe0lRtNFKVSsCekkolUjatxGOLv0e2lnjU0eqxJ20eN1r3wVdC/zF+Zsk1KmpTquHzALnzh82JCHcz70gFfL6YDqAAyyZEa68VV5wGs8OecMlmtmR6yAyY6E5xyimGt6NyevAjudYNwL8z1s2hfCxXluTNjJEyc72d0YSil+Bk5/Lxx8qx9KNcPmz5amgyc80wNroxpJNa5wy3BaRVWiXog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FFhygg7OOoll10RWm1Uspx9/UFnTXVbBUaFkOZfFVEw=;
 b=kWV0FJHQ45M4bjOgkr6LZOKRgefo7D0SbmcjPtJ5kwTFNcGKbhIKjjyA9Zu1ShuLjrh3tc1rhQ9G2b30iozFNsxn6l3oZlIoIvAiUpQxCGb4h5cSzj/o6RsFKQzsC3w8EYMpMmzi9Py7NfDYyNbyCcu4Who0WIr/LjBfX0LbxL0HXb6/gDYxqtW4ydeqm3eO/KXiN8UgSYnJLjsJNq13GCxVtmRV3AhbDqOcP8x3hFs4vCwR5+j/V4NHfLI5+ldEdxRd5ynnS5oaCvaFuEPOTlgz7S0ZCTeSKGMm9dsy5aw9lB+00eNhkNm+ua+GxAMnH6J0vdUslL/lyhEf6hmMPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB6420.namprd11.prod.outlook.com (2603:10b6:208:3a8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.29; Wed, 14 Aug
 2024 02:36:41 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7828.030; Wed, 14 Aug 2024
 02:36:41 +0000
Message-ID: <6de48ba0-2e63-4559-a6b9-1b75ab5d712d@intel.com>
Date: Wed, 14 Aug 2024 14:36:32 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] KVM: x86: Check hypercall's exit to userspace
 generically
To: Sean Christopherson <seanjc@google.com>, Isaku Yamahata
	<isaku.yamahata@intel.com>
CC: Binbin Wu <binbin.wu@linux.intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
	<rick.p.edgecombe@intel.com>, <michael.roth@amd.com>
References: <20240813051256.2246612-1-binbin.wu@linux.intel.com>
 <20240813051256.2246612-2-binbin.wu@linux.intel.com>
 <ZrucyCn8rfTrKeNE@ls.amr.corp.intel.com>
 <b58771a0-352e-4478-b57d-11fa2569f084@intel.com>
 <Zrv/60HrjlPCaXsi@ls.amr.corp.intel.com> <ZrwI-927_7cBxYT1@google.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <ZrwI-927_7cBxYT1@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0034.prod.exchangelabs.com (2603:10b6:a02:80::47)
 To BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|IA1PR11MB6420:EE_
X-MS-Office365-Filtering-Correlation-Id: 5331f956-9769-42e7-1423-08dcbc09ee00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SElGKzZuMEYyS3NrNjNDNzBYdjJ5a01UUE9QbytiOXhZWVJKcnd2aHZkU3Bz?=
 =?utf-8?B?aHRjSk9QNjBOeW9nVzJsUGgzMCt5OGovM3EwQnhjbGxwK25kQklTbTMvSzVE?=
 =?utf-8?B?V3JuS0VsTTNTNGsrZXQrNU9tSDViY3hkZ2EzMk5jYmRWakQzRWl0NHRHdnhX?=
 =?utf-8?B?dkZFOUYvVFVvNVNqNWZ4bjNKbk1qQVprMmJTdmRDblVFTm9CWnpZdldKTzRs?=
 =?utf-8?B?Sit0NW80R0xIVnNQUC9teEtIelhJTTBTT0dwU0VtTHhmUER4bE1ScFd6d24r?=
 =?utf-8?B?WG1TWmtUMGxOR1NIS0tKTVpUVFR6UTZsT0tGa2Q3RG5sWjdXTUR6cGtHSlhs?=
 =?utf-8?B?ZkVKWE5scXRCYnJ5OWFQMUhVV3lDdGtiVUVhYWpLVFpnQk42a0srSG5NTWpE?=
 =?utf-8?B?SW9GSWlHQ3h4M3BQU2o0WDh6MVorakhnYTBNMGhaUkF6YVN6Mk9YZ0tZMDNq?=
 =?utf-8?B?dW5hTXlMVGVCT05scFNmRmhjOWF5aUVxeFJOQ2RKT2xZcnhYZlZsM3ZlMkVX?=
 =?utf-8?B?NFdvakFCcEpQYkdyYWdUYmt3akxYTmUwOVRCN3FQam9lamRBSWdGeG01RklS?=
 =?utf-8?B?MjI1NFozT3NwWmZhMUkvZWs1TE9pRUFFMm10UkVlRDdNVHJzODluemhQYXdG?=
 =?utf-8?B?VjJKVkRZK1lRL1NmemNoVTNOVXl5Q21ENlRYNGw3ajJ6OS9WdmZKcFNUV2xH?=
 =?utf-8?B?YlhacWNzZUhHOTBsZHdIbG9DRko2dThYKzFUK1VObEoxbGRvNzIyZHNkVjFs?=
 =?utf-8?B?NmIxOGZXek9BYUlYdDBUOUVvaHRoL3pkLzdSTWJhcG1VL3ZodUpCekluT3N0?=
 =?utf-8?B?WjJUV0x5aWtuUVU2S0JqWDRuaEFFTWZ5UWg3MWpUUFc1Y2VRRnJXcUUxbjZp?=
 =?utf-8?B?b0wrZVBNcWR5TUxpMEcxV0NVeG9DaVRVbFJOL1hpNFJYUWtlb21kMkNqYTBF?=
 =?utf-8?B?bVdtYS80YnJwYXl5cUQ3M3RZWGJQb05ZSXViaDYvM1VhclBRTW1LUVNPcVdr?=
 =?utf-8?B?QXFCT0hiNFYzYy92YlJ3MUx2M2J5eWM4MXhudnl4NTQvKzJDM0RHbzV5S2lS?=
 =?utf-8?B?MmVFMS9BNlluM3lYWW9ibjZ0N282WTFpUnhzeVdwRlNOK2xqemN2Q0ZrS1Nx?=
 =?utf-8?B?R1lSK0VRbFdKcTlRSUJsYWZWek85NU9EaFNJQStjelMwTnN1RXhHNjFDZWtM?=
 =?utf-8?B?MkdzMUdjcElrRk5KaE4vOUFUY0tEOXFJa2oxNGphQ0xyV2ZSOENybE9KQzZR?=
 =?utf-8?B?MnlaYkxzZ1AvaGswdHJGSlo4bHlJMisyM2lEeVFEOGw4TUN6TXJmeTh3WjRy?=
 =?utf-8?B?WERYMHl5SUdNNEx0L29zamtUWDZMZEJ1NnhLOS9DM29pL0p6R2FIcEk0SGgz?=
 =?utf-8?B?SkZMRTBwREZRUkpqZWxTUS8xNEJFR2hwcFZTZ1FCVGhadkNXSW5ReDFHK3dH?=
 =?utf-8?B?Z2w5bzZaTFAwc0NTd3VZcnZnUXltQWZNUGZsdFNJejdablpaNXVoYzRrR1Zh?=
 =?utf-8?B?SGpoLzZyNm5DN2pNUG1aNGNJOEpKUXZKMjlTeDlOaC9MM2d0K2pNTlhmeGNs?=
 =?utf-8?B?TEJ4TU5vM1hrTWhlT3o2TjJ0QkIwZGkzZzhMR2V6L0lQSlExcXZPSkFNak9Q?=
 =?utf-8?B?K200UkhIbURTY3pMMEhqRy9WMEpoQVMxZnZXS2ZDZ3pWOUJXMGFQejJmMEhn?=
 =?utf-8?B?SFlMZzBvRU1SK3VCTUM0VTYyYjVkZHM3RC9BTkRjLzdGbzlibXc2WHgwSyt2?=
 =?utf-8?B?MUQxVjRmSmRMQXdLK096OS9GZFVybjNVdmRtOXRxZElCc0xNcVNhTjc1ZzlP?=
 =?utf-8?B?aE9USDNLdzFPVzRFbzl6QT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NnA0bUdRVW5QRFUzWTQvbWFuQzNuT3lYbG9CUU96Tk9ua0diSElLbGVPTXZQ?=
 =?utf-8?B?TDdQK0dBdUVqZGdlUjdKT0lhRExHaU5Zd0NMUTN5TzJMeUZ0bkg2RDNqQlhj?=
 =?utf-8?B?ZjFmRmtwL08xTWhQd1ppRE8zSmlCdzA0UVFDZHNJQjJuZGZ6QUpHTitzbHVk?=
 =?utf-8?B?LzNQOTVLTjVtd3UvVlNTSnArakxpSUwvUjlrOHYrS2ZXMkZZbmxvMWtTaS95?=
 =?utf-8?B?VDFuTlpGOE10K3p4VjBjVElmTzZFVEpFdnBidlJhdDAvZzEyWmRNSTNmUkdU?=
 =?utf-8?B?MmwxODc3NVVBelFaR0wySmNKR0Roa2NadEVIU2xvbjZETjE2akh2MWdPc3No?=
 =?utf-8?B?c1Nhd2xZNzNXUzRwN2MraEV1ZXRKNjNMek5aNlBNOG9Sd1BoaURqbnhiYVZH?=
 =?utf-8?B?NmUwbm5tZ1l0dEZnbzdxZENkUDRFa0w3SFlnM1NmSFkvWXBCZkJTSnlCRmxo?=
 =?utf-8?B?ZmJhN0FEL2NKTjlIQ2FlcGxLNER4Zk52bzB2Mzdpc2ZNT3J6bGU0bHV0VDRQ?=
 =?utf-8?B?bnJLbkIxTE1IM0oxN2NZbWcvaTVHL3pDQTVtVHdhSVpjKzZPUzZtRjhVUks4?=
 =?utf-8?B?MTBqdDgvVmxMUk02TzhtQnFqanRJVWhFQk91NU1kWUx5akhhZFFweFNnbFhB?=
 =?utf-8?B?eDE5Vlh1R09ydXB2Zk0xNnYzTUpaK3UyTlBjS044WEExSVZVdldYQTNrZGVa?=
 =?utf-8?B?cnplNGh6UUxDdjYrSWhReEQ4TWNLMnhlL2l4elZoV2RNTjBmSVp1M05DSGJQ?=
 =?utf-8?B?NU5ValBWcTBjT1pnUmdiV2R6N3ZhYmNkUVIzaDI0R3ZBVktPdFEvVEZmL21V?=
 =?utf-8?B?a1g1ZHlzQUdJR05TZlpEUUZ4bWc1RURENEtMdHBLelgzalFKOTJ1bkRqdGZ2?=
 =?utf-8?B?L0JJNENnZkJuaU1mYzhOdFVMVWZRQjlvRXZMemNBMno3RldPeUx5UUpmZjQ2?=
 =?utf-8?B?d1Jqem9VLzFwdVdUcThhVTlmWjdHMVhzUUNveWk3VHczTWErVmQ5U2RlVzRq?=
 =?utf-8?B?OXorUFl6OXlVWkJ3T0pFY2NrTUlYU3B1alFNWVpqSzhzcXp1UW1rL09DNVdl?=
 =?utf-8?B?NHovVDFUVktUUklaWlAzT1V3Q05kQkY0V2paL1BkcGQrZW4yVFE5Q01mdWhS?=
 =?utf-8?B?dE1rSWZua2Zoa1dYMzJOd0s3enc1NHBGb2JDM3M1WGFRcjluQUFHcjExSk4z?=
 =?utf-8?B?NmU3YTducWlpc25MRGNrTytCQmFpaHVId2tZdWE2QXNJL1ZHTndxQkl6NGFF?=
 =?utf-8?B?RzRUbGZOU0djT2dJQkI0QXFicWdOWDFNWDN0ZUNNVUhYakdnWC93ZVBVaFcw?=
 =?utf-8?B?OFJsaUxjdFVJTmc3dHVTbFRsWm0xb25NZ3VTeEh4NHc0RWRjZXdnU3loTzl6?=
 =?utf-8?B?S3NOM1RicWc4WndwN2tkaXBvbWZZNHRKODZIdnp2cVVLUlJNdzRVZVpTRnNv?=
 =?utf-8?B?TFBKLzJTbFJYRE9PalNpZXppZGV5NE4yK21DQzZaa1V3NXg2ZUxpN3RxMk5a?=
 =?utf-8?B?TDNLNjVldVdyTklaUWlRVm96TEs0WmhOdkpQN3ZDUWdMVHY3OXFvLzdLQktC?=
 =?utf-8?B?d3lkcTlHVHNHUzNKRFBEcjhYd0M5a2h2Q0ttRTNxL0Qrc2VqWm5BWDJGL1Bl?=
 =?utf-8?B?NEwvOVVKcFlhRG9jcElzM1E0b0IxUmVxWmMwZzZSOW5CM0IzeGx6eVVRVE03?=
 =?utf-8?B?ejRDNVVncWE0TlFNNGdjZWZxcEphWWJ4K3V4STZkVkNoRzQvTTFsb2FZeW93?=
 =?utf-8?B?S1ZnamJiMUpoUUo5NXdEK2JETW5nUE5yUm1ZdjJhZWVjOEJqM3BWTXZFSVdh?=
 =?utf-8?B?OVVGVjc3bE82cHF6OTMyTC96cWJlQWZNWTJpQy9JKzZFNmE2dW8zelIvQkRP?=
 =?utf-8?B?RzdJbUVvVW01UXREanVrRGVZVlRlbUJKR0N2VytUSW9vK1dFb01PSzRDU0hZ?=
 =?utf-8?B?WDREWXlqR2xTelp0ckNwNHVCZHNySzNNYm94OFp1OEZrdXBqYWgxR1o2a05L?=
 =?utf-8?B?TG4zazluWmpmekJyMXo2RXNSV3dKazlYWGtmWDBhNHB3ZWI1dzhtR2g3UU9G?=
 =?utf-8?B?bjV3MUdpaUVTK0JjcDhwY0Z3TVlWQUpHbXA2ZmdYcXJiU2h0aEw0QzlIcDJm?=
 =?utf-8?Q?4X/PAzWMPs1OeGLTGzpA20IMK?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5331f956-9769-42e7-1423-08dcbc09ee00
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 02:36:41.4212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tx0+O726Q8MYw02XSQvn7qVkpGsihE8vya9othW86NhgsmuA535ztpmkDDc85NrN/s/DKvj9ZwsQaTkLaR62Lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6420
X-OriginatorOrg: intel.com


>>>>> +{
>>>>> +	if(WARN_ON_ONCE(hc_nr >= sizeof(kvm->arch.hypercall_exit_enabled) * 8))
>>>>> +		return false;
>>>>
>>>> Is this to detect potential bug? Maybe
>>>> BUILD_BUG_ON(__builtin_constant_p(hc_nr) &&
>>>>                !(BIT(hc_nr) & KVM_EXIT_HYPERCALL_VALID_MASK));
>>>> Overkill?
>>>
>>> I don't think this is the correct way to use __builtin_constant_p(), i.e. it
>>> doesn't make sense to use __builtin_constant_p() in BUILD_BUG_ON().
> 
> KVM does use __builtin_constant_p() to effectively disable some assertions when
> it's allowed (by KVM's arbitrary rules) to pass in a non-constant value.  E.g.
> see all the vmcs_checkNN() helpers.  If we didn't waive the assertion for values
> that aren't constant at compile-time, all of the segmentation code would need to
> be unwound into switch statements.

Yeah I saw vmcs_checkNN(), but I think __builtin_constant_p() makes 
sense for vmcs_checkNN()s because they are widely called.  But 
is_kvm_hc_exit_enabled() doesn't seem so.  But no hard opinion here.  As 
you said, it's kinda overkill (or abused to use) but zero-generated code.

> 
> But for things like guest_cpuid_has(), the rule is that the input must be a
> compile-time constant.
> 
>>> IIUC you need some build time guarantee here, but __builtin_constant_p() can
>>> return false, in which case the above BUILD_BUG_ON() does nothing, which
>>> defeats the purpose.
>>
>> It depends on what we'd like to detect.  BUILT_BUG_ON(__builtin_constant_p())
>> can detect the usage in the patch 2/2,
>> is_kvm_hc_exit_enabled(vcpu->kvm, KVM_HC_MAP_GPA_RANGE).  The potential
>> future use of is_kvm_hc_exit_enabled(, KVM_HC_MAP_future_hypercall).
>>
>> Although this version doesn't help for the one in kvm_emulate_hypercall(),
>> !ret check is done first to avoid WARN_ON_ONCE() to hit here.
>>
>> Maybe we can just drop this WARN_ON_ONCE().
> 
> Yeah, I think it makes sense to drop the WARN, otherwise I suspect we'll end up
> dancing around the helper just to avoid the warning.

Agreed, given @nr is from guest.

