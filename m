Return-Path: <kvm+bounces-18082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 90E0E8CDC50
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 23:47:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 22D6A1F24EB9
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 21:47:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 521D1127E24;
	Thu, 23 May 2024 21:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cD1IZ6w0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79AF6823AF;
	Thu, 23 May 2024 21:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716500848; cv=fail; b=fiLxHaB6Tn0jyR6BXHi/lih+wn6sQ8YMFU7yR5bb9wdNwGuxbAQkGwgOpEiLXxMKcA4PSUjuDCJ8tcRCsGzwKqHYRMLg6gFdhlj4Yt9lXaIs2zEaCQANNi8gpu5Bx4uDxkyIA7RLHEWw4s/PUEBXE14vSJ7+F1IPHzpF28l3mvo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716500848; c=relaxed/simple;
	bh=fsw88iUqC0CHxPlF5VcGwqGgV489iKnRrv9zAgKeA2o=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qk12xNT6CUfswmA/Kyh1Q1lztPoOPdJK+DauQd/nNzsBVdRPNQjuKkIBVkiPUNnGyXo0KCpmY2TDXlvimyNcXVR4gteSQPU+qpMpsdu412k7gTcmD+/EbYRnVztFxt/TwTf1a2ukm2cBuTZIFsMHkU8QUFaGqGP1/9ZBPf1EF2g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cD1IZ6w0; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716500846; x=1748036846;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fsw88iUqC0CHxPlF5VcGwqGgV489iKnRrv9zAgKeA2o=;
  b=cD1IZ6w0NtsxjUd6IkqQZDbTII38tCgzEBalFzzecTr0Y0hFE4jjW45D
   LnQvmPv2gx/RvpMCn7u4PRTRsMOG8IjEWl6K9PtyQAko2CSKobhU8aFCT
   8OpZlvz+DuqU59Ut+8U343NPQV91/gMAdJ0slN+nr/gjxbrN6AYZST3n7
   x1b7S5a5PJtx6MroBjy4Uzyx4sDZ+NXYh8oPVsKHUNvVnRMm+1x9DHJ7G
   ckbjYgU5GzbLIm4NWrsq9AXHJdfllz3sksIpV5yovbPYiwIRKnNDNYsVK
   n8xUWerYEQbO6pXZKdwHNkAjl69zokDSkK5Wbw0H83QSRTJE4WduYIzQh
   A==;
X-CSE-ConnectionGUID: 2VrM0CKtSxaY9mHZGOoT9Q==
X-CSE-MsgGUID: uQXyFRnPQNiNr8bldwVBTA==
X-IronPort-AV: E=McAfee;i="6600,9927,11081"; a="24262695"
X-IronPort-AV: E=Sophos;i="6.08,183,1712646000"; 
   d="scan'208";a="24262695"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2024 14:47:25 -0700
X-CSE-ConnectionGUID: +mIzxoe9S6yV+WCQUp8IFw==
X-CSE-MsgGUID: DRJGa0/4Rh6GKee4FoxKUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,183,1712646000"; 
   d="scan'208";a="71226357"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 May 2024 14:47:25 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 23 May 2024 14:47:24 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 23 May 2024 14:47:24 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 23 May 2024 14:47:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gJbPPB08UdxKh6XoRut40nwe7NYVjq3ENwB9p53+tCqPZ4OdX5k7ZMt1b7WMh70ctAGV5Uu0Uvxz12WNrEuHRpVk+wce9/jzA6/Y5hdLcPd/PHBqjBZOEWDJC7L6LW0j86QX2iR743e/y0Z2gCu3ufnjJf340itm55/lNH6s0T4WZb2led8NMdZjMtpAxqhZLP5NKqQSr5ga3WlpLeRhygln8hc1qfvDwWwuHE1a7gVFVXZ7HacD4pDkYKyL2zSoiBGV1frM2T6kE4HHFHTgkuoPF7uVBfI07N2ktvVxoXkv+95rCuyht3/loDba2gu7VS9XEYEZHYmCiYh9H/mcww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D3fUkg09tzTaHI6cYzuqAh2MJEFNFSGPm5TQ0O6KBU4=;
 b=TLbMpZL0hwR2hetpCf/cmROZxnWQdJwh/IfjnufjBYPMdMPvCP76SUFrb0cIzM2vZxY636NeKLMIv4cvVFP64POo6UQywcCvM87yI1y/g66BnDHtC1BWIMEWBmQu1r7FrPPHqIwtKm2s1y8nUBVcA+v07g8EJPaR0K3ODNcTHpxGDQfHPXRe1WA3RlMFB7C5bZME2RzVAJf8OuUC6VVe4YDKpvBqGPxnLG6EurdDzwQ5es9uwcJYLt3lKlzEszUhOqHRHcJOLId4/4dsrOPvdbQZUB7cPx6UZN0X3y/OrmlctNZjHXxnjw6ilO6Bf3sLlQtXJGdWq4dxAgzQN4yVfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB2535.namprd11.prod.outlook.com (2603:10b6:a02:be::32)
 by SN7PR11MB8282.namprd11.prod.outlook.com (2603:10b6:806:269::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.34; Thu, 23 May
 2024 21:47:21 +0000
Received: from BYAPR11MB2535.namprd11.prod.outlook.com
 ([fe80::391:2d89:2ce4:a1c7]) by BYAPR11MB2535.namprd11.prod.outlook.com
 ([fe80::391:2d89:2ce4:a1c7%5]) with mapi id 15.20.7587.035; Thu, 23 May 2024
 21:47:21 +0000
Message-ID: <8675abf2-00ca-4140-93be-8b45b04a5b7b@intel.com>
Date: Thu, 23 May 2024 14:47:17 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] vfio/pci: Support 8-byte PCI loads and stores
To: Gerd Bayer <gbayer@linux.ibm.com>, Alex Williamson
	<alex.williamson@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Niklas Schnelle
	<schnelle@linux.ibm.com>
CC: <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>, Ankit Agrawal
	<ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>, Halil Pasic
	<pasic@linux.ibm.com>, Julian Ruess <julianr@linux.ibm.com>, Ben Segal
	<bpsegal@us.ibm.com>
References: <20240522150651.1999584-1-gbayer@linux.ibm.com>
 <20240522150651.1999584-3-gbayer@linux.ibm.com>
 <2b6e91c2-a799-402f-9354-759fb6a5a271@intel.com>
 <b1ee705ee3309405273ed1914a4326b9b024edf8.camel@linux.ibm.com>
Content-Language: en-US
From: Ramesh Thomas <ramesh.thomas@intel.com>
In-Reply-To: <b1ee705ee3309405273ed1914a4326b9b024edf8.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0055.namprd04.prod.outlook.com
 (2603:10b6:303:6a::30) To BYAPR11MB2535.namprd11.prod.outlook.com
 (2603:10b6:a02:be::32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB2535:EE_|SN7PR11MB8282:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d8cebee-1356-4282-147c-08dc7b71ecfb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|7416005|376005|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?a0RFaHZvTnlNVlFJd1poZUVFcXRab1ZWVEgwSXIrUFpBQmYvejlpdGxaT3hi?=
 =?utf-8?B?NW1scjU5RzJkek1wSGtkRSs4V2tNUE1aV1lCMjB2L1JnSnlaWjdVSjVHd21m?=
 =?utf-8?B?VkhBUUVpRDVIWU1sU1BFMUI3Q1Zva1VHWWx4Y1k1SXlHYWI5aDJ5ZlYvaWk3?=
 =?utf-8?B?dDB6OUN5VVJhT094SGZTUi92eS9ab2p3Q2pWRkMxQ21YZnd3eC9mZmFLSXg1?=
 =?utf-8?B?SXFvcUF3anRjZVhyNDlRazc0ZkpBdmszU2tqZm9EajAwWXg3VEVlZDdYTXR1?=
 =?utf-8?B?ZGdRdC92S0V4U05MTFUyTHpjUzNJWXRjYWQ0bVZQVmtsMHM0c3phK1RxLzNi?=
 =?utf-8?B?K0h0alVsT0g2cVRUOHh4ZCtOUEFqWEkxR3hOM2FnbHBSWFN5SzV3K3JiNTZR?=
 =?utf-8?B?MGF6ZWNScER1alF6bXBNUWRTbVFjWngrUGFkRmkwVGZXMC9pQkJSazAxM2ZY?=
 =?utf-8?B?SG1UR0Frbm1FbmlOMlphWmhXSW5NUkw2cGVzNmJUQnhYdUsybExTTmxHaTha?=
 =?utf-8?B?SHZsa2N4dllSTTZ3NnNWb2toa1VIMVc0ZTRpclZydFhES3ZGa3FtZS9YL1Fs?=
 =?utf-8?B?eDhCTWNJMmtSMGF2ZUhyZWM5ZlVKZWVpZWtoZGtEVUZQY09GOHBqNnAvTWpB?=
 =?utf-8?B?aWliZy9XRXFkK01uTHZjY2FhRkdBVHRFN0ZlT0hTdTA4ZGlWeVVWZ1dTZjFS?=
 =?utf-8?B?TVNCeWMzYVNhK3N1dEJ5YWt0MlhQUTlETEtKaHU1RTBTRkR4YmtaMWFmQ1dv?=
 =?utf-8?B?bHdGT1U3YUZHa0N5dmVYL0srY3RycEhwaGlpVEhiMklMWUxpdkJtU3lOaUJK?=
 =?utf-8?B?QmY4d2lyK2F6TllyckIyKzdqTUhEUE9xRG1DWXg0SlA4ZkJIOTBmNVVDK3Ji?=
 =?utf-8?B?S2RiYU9vaXR3QUplT09qNGZBSENDRDJBMzZVSWdGejhUQ3YxUGZ5RCs4UFc1?=
 =?utf-8?B?UjlKNDZHRG1WbnJMd05hZXUvdWRBL2taQUpXcHU1VzRCUWdadUN6SWZrNlNu?=
 =?utf-8?B?d3B4T1RYdzg4WXBGNkdqaFpGUU0vTHd3dDhBcXFSeFc2R3FpOG9peUF0ODhQ?=
 =?utf-8?B?NjUvbUFMYXQreXRVeTV6SUtxMzk3TFlteGFSZUc0VG1UY21RV3lsYXlMUnll?=
 =?utf-8?B?bVo3S0FIa3pIMTRZRkJiM1AwTXBSNWx3RTRvWHd4U0pJNmd6MFRtcVIwY2Vs?=
 =?utf-8?B?SlE4YjJQQlN3MVZwQTJ5NUNoUEtsMmV2V1ZBeWwyUVIyOElTK3haK0ZKTGtR?=
 =?utf-8?B?MVVQUys2WWtGUjVubUt1RDRNNVEya3ROTWpoRXFMRnIyK3RNMnVsNzg1U2xD?=
 =?utf-8?B?ckRWKzhQSjJrT3hMdTBqWXRyZmRsZldSNUVZVmVUMG1DS2l1Z3RsT0REOGdI?=
 =?utf-8?B?SFNaWERhYUpzOU9TelJqMXpNUEtZVENUU241N3NBa2ljaVVKRTNOZ25pNUlJ?=
 =?utf-8?B?Ylpsd05kdVZlSnRlZ1lBcWE4MUs2Q0cwb1Zob091MnpFUEhiR3RqbksvSldO?=
 =?utf-8?B?MDI4b0RFUkpHUXJYT25LZFI2WERoaEx4UmN3QVN1b1pvdWJVZnlZYzdoK21R?=
 =?utf-8?B?SDNvMFlCbjQwMGl6YkJucWlCNXFUK1JKeFMxTmVBR0IxUXNZM2ZPMUdWWlhl?=
 =?utf-8?B?S2dicDVxcXJ5ZkhFckJTZUF6dUZYTDN2MkFwL0VjcDlPdlVqeS9OVy9JVTdw?=
 =?utf-8?B?bHQzT2cvcFhyR2Nia1VXT05rZkpnakhIRDhucS9MZzBjaDhTWis5TnVRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2535.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dldiNkQzUFlIWjNEUC9nUVNPeUluMVdoTGk5ZzlzakRCcE9kWi9xc1ZrVytn?=
 =?utf-8?B?dWJscWpZNGk1NFVhR2Vkcjh1VEhYTGpRR2hnTmwrWStFaEtBN3RHbjZJU2d3?=
 =?utf-8?B?T013aWFjaS9HWlBBdk9mczdzazFJL3JoSG43ZldpRDJSc1VhejFhc2tjKzg3?=
 =?utf-8?B?dkh6eEVITzJtQ1l4aFZlMVFQRUp6VmwzOHdmTW16QnFXUTNvWWpXcEpNdUhP?=
 =?utf-8?B?VDllalRwL3RIR2FOZmlmeFZiWENWNlNReHE3NkJ3di9KR3JLeFhZNUlJL2ZC?=
 =?utf-8?B?N1RLTWhPQzM1L0lCR2dtZHRMWEtjM3FUVUdEQ1JWNXQ0d09aYlZtd2RKNm9I?=
 =?utf-8?B?NHRBMjNFa0FKU2Y2L2FneFIyK2tGOXFHWFl2b0Mxc096ZEVPKzdMNGpmZ290?=
 =?utf-8?B?N2dkdGZnL0Z1dkdIUVRZaWh4bXZjWW5qYTJabE1ZV2RscXA4SktWUC9vQnQ4?=
 =?utf-8?B?a0h1TU5MOFhCaS83RXJ1MEYzS3QwTllGcm0wNDZNTXVzS1VwQkpGZ3ZzcUp0?=
 =?utf-8?B?YWE4c0lkUUNockxmOGZ4ZFpIUzhWQTJPLzQ0QjFUTGJCbDNsdVhaY3pZVjlQ?=
 =?utf-8?B?TWU0a0k1RVNBQS8zMnVkVDlZUnVXZjM4Wmh3TC84MXFEM0lXc1poaER3b2Va?=
 =?utf-8?B?QmNJUHZzbWhZZ1haRnlsWnYvbFM4WVVra1kvMm8zd1BYM3RlTUlEOUU5eVlr?=
 =?utf-8?B?eUt3WDNkbS8zMjRMREw0bmxiclRPRjY3bG0xNVF3NDdranRTZzVuYlVaTjAz?=
 =?utf-8?B?bmNvYWQvR2FNMzhQUXUwYWZzU3RlQ0U1VVZoUisxNlhSUENwdVoyY3BnTGY1?=
 =?utf-8?B?bHUxRDB5ck0zNGgrWDAxQmprYmZtWFRZSDJJUkRGVTNVSVBoMVdYemd3WHBG?=
 =?utf-8?B?WGlpSU5rL2J2Uk1NY2lxbXRKV3FFYmpaSjZqSnIwTCtzaVVSTkIzeVg2eW40?=
 =?utf-8?B?V3FFY0U5MnE0MTlSWFlJQnhhcHFLdGxJbVZnWU9JdDhwNG5uNlVKV2UrbzNi?=
 =?utf-8?B?dkpPdnB6RjlxNHhzTHhFUWliaGpBVHVaM1RINTJyVC94NGFySkFmQ3lkVXpK?=
 =?utf-8?B?N3JFU1FERThvQU05UGRyL3E2VXhNY09vU05laFJ6MGRoSXhNbmtnaUNHQ25W?=
 =?utf-8?B?b0llMHlBdHBYcTRLRkwwY2hzeVNCVmltM1N3RlNqMnNpRTh2Sm5NNVhEWFNP?=
 =?utf-8?B?NjdTUHB6WlhOSTdieFVTbGN4aGNYamFIOFYrR0xadmpXdnNYMklFUTlCdHlL?=
 =?utf-8?B?c0owRm52cU42YWlxSm1PVVBkTWg2Y0h5bVk0SEE0TGt1RUtxMmEwcS9FVGNx?=
 =?utf-8?B?UGh0bXg2eXExSU12YTRTUGF0aG1QNEsxMFJHWFJEczMxeWxvOEo0REMvM1FK?=
 =?utf-8?B?Q2pJeE1WcmxPQ2c1Y0lmU0Y4cTAxOEloZFZFdllaMi9xR283ZmYvUmF5K1Fa?=
 =?utf-8?B?a3hsZXVpQTEwMnRIWkRBMnBxbUlWdkZKVXE3ek1BenRuamE5bzNXSW1vaTNB?=
 =?utf-8?B?emgzdWN6TE9Ga1p6VlFwZ0psVGxrWlZKMmk0NjNzb3FSWHBPeUR4blJDd3Bq?=
 =?utf-8?B?d2o3L0xodlJXcE5ENUYwVVFpMEh6VUROSHUzWjd3R2syWTlRYjN0YzFpZVJI?=
 =?utf-8?B?T3Bpd24welNKTVFCNyt6bTlickVrUGxTbWQvTUxxcXBQN1dWSTZoL0VPSnkr?=
 =?utf-8?B?ZEFkVFRrT0VTajRISGNwaUR5NHh5Yk9pUUFLYlAxMi9maXArTUNJY2F1V2cz?=
 =?utf-8?B?alB1eUIwUnZtc3lvZzJjUVYyYVFFRVU1a2RLSXNwQTdZUDdvdWlidHhkcE5Q?=
 =?utf-8?B?b0loMU1CSU5oUkdPQ01oeTZnUFZGNWJiMytYc2dmZG15ZG1Rd2w0citUNFRO?=
 =?utf-8?B?b3BuRmEvSlRTdFdLM3AyME5va3EyRVgxT2hCeU4vcWRLQmhSVWVGRnNBSXR4?=
 =?utf-8?B?MEk2K1JjdEk5c3pxbFFmQnpldlArK3NGYXRDZWRsSTBtaFFIWFlIZ2owNS9a?=
 =?utf-8?B?aTgyYkJLYzhYTGt2TjllNHBua2RCaEh5TjZKcFpjVXU4SGlYTi92VEI0Wndm?=
 =?utf-8?B?V0NsN0NGUFoxb3c5TTMvbzZrZ0pwTThXalNqcVlTQlJuZmVzcmgraEswMHRt?=
 =?utf-8?Q?NXO/xuhnyFsScXsIiM7nxPIWZ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d8cebee-1356-4282-147c-08dc7b71ecfb
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2535.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2024 21:47:21.8318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gkr/O/VaRUWiPuR7NXB/miWJKgw9tYlhPWIQQTMikzd3jbSHGLAl+iOUDuAyWw51W3WUh8jcoyENceh8aScH/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8282
X-OriginatorOrg: intel.com

On 5/23/2024 8:01 AM, Gerd Bayer wrote:
> Hi Ramesh,
> 
> On Wed, 2024-05-22 at 16:38 -0700, Ramesh Thomas wrote:
>> The removal of the check for iowrite64 and ioread64 causes build
>> error because those macros don't get defined anywhere if
>> CONFIG_GENERIC_IOMAP is not defined. However, I do think the removal
>> of the checks is correct.
> 
> Wait, I believe it is the other way around. If your config *is*
> specifying CONFIG_GENERIC_IOMAP, lib/iomap.c will provide
> implementations for back-to-back 32bit operations to emulate 64bit
> accesses - and you have to "select" which of the two types of emulation
> (hi/lo or lo/hi order) get mapped onto ioread64(be) or iowrite64(be) by
> including linux/io-64-nonatomic-lo-hi.h (or -hi-lo.h).

Sorry, yes I meant to write they don't get defined anywhere in your code 
path if CONFIG_GENERIC_IOMAP *is defined*. The only place in your code 
path where iowrit64 and ioread64 get defined is in asm/io.h. Those 
definitions are surrounded by #ifndef CONFIG_GENERIC_IOMAP. 
CONFIG_GENERIC_IOMAP gets defined for x86.

> 
>> It is better to include linux/io-64-nonatomic-lo-hi.h which define
>> those macros mapping to generic implementations in lib/iomap.c. If
>> the architecture does not implement 64 bit rw functions
>> (readq/writeq), then  it does 32 bit back to back. I have sent a
>> patch with the change that includes the above header file. Please
>> review and include in this patch series if ok.
> 
> I did find your patch, thank you. I had a very hard time to find a
> kernel config that actually showed the unresolved symbols situation:
> Some 64bit MIPS config, that relied on GENERIC_IOMAP. And with your
> patch applied, I could compile successfully.
> Do you have an easier way steer a kernel config into this dead-end?

The generic implementation takes care of all conditions. I guess some 
build bot would report error on build failures. But checks like #ifdef 
iowrite64 would hide the missing definitions error.

> 
>> Thanks,
>> Ramesh
> 
> Frankly, I'd rather not make any assumptions in this rather generic
> vfio/pci layer about whether hi-lo or lo-hi is the right order to > emulate a 64bit access when the base architecture does not support
> 64bit accesses naturally. So, if CONFIG_64BIT is no guarantee that
> there's a definitive implementation of ioread64/iowrite64, I'd rather

There is already an assumption of the order in the current 
implementation regardless e.g. vfio_pci_core_do_io_rw(). If there is no 
iowrite64 found, the code does back to back 34 bit writes without 
checking for any particular order requirements.

io-64-nonatomic-lo-hi.h and io-64-nonatomic-hi-lo.h would define 
ioread64/iowrite64 only if they are not already defined in asm/io.h.

Also since there is a check for CONFIG_64BIT, most likely a 64 bit 
readq/writeq will get used in the lib/iomap.c implementations. I think 
we can pick either lo-hi or hi-lo for the unlikely 32 bit fall through 
when CONFIG_64BIT is defined.


> revert to make the conditional compiles depend on those definitions.
> 
> But maybe Alex has an opinion on this, too?
> 
> Thanks,
> Gerd
> 
> 


