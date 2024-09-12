Return-Path: <kvm+bounces-26750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF032976EE1
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 18:38:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C5B22828FC
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 16:38:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13A4F1B372E;
	Thu, 12 Sep 2024 16:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k5WJntOX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675EA199948;
	Thu, 12 Sep 2024 16:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726159130; cv=fail; b=JCNHu/BnIjH+xMyofrnIHaTtD95qJLlnNRX8eSNXFodTruuyUNHPs5R1UE+EKh6JVGSi8JO5imAerMqrldsGmHHbr6TgWfzJkpLVPWtIAIo11BanX7Ojw/5LqsySXMfPiUmoBY1qqD+Lj6qX1+wVmzgyRPbiAETMCoT7xDH4wy4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726159130; c=relaxed/simple;
	bh=wbd4KLsIxbHxGhdYqrR2qcCkg73Y/X1M0IqW/Hereow=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dND9mLV8sTLgUgRl088gKErzQdZINFwwNW5NzlkbaLSkBh9lAKpSES5KcoN+LQZKkAWmxxOLJJNbW4fC/JKRPXJNps+bF7zmOPN6hZt4PDct+pfIleToK9gNmogn5hJ0DdL+UF5yRD3PgU3x5V1Dy2R31QnDr5xGcMSOIUZjUeg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k5WJntOX; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726159128; x=1757695128;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wbd4KLsIxbHxGhdYqrR2qcCkg73Y/X1M0IqW/Hereow=;
  b=k5WJntOXsuPHA9WxxhA8Pcy9ZB0FSDXJFwON02CUFqDv9VhgQcmF0xtn
   GYIJj3f+c3RL7fNR6tJ70X/1vDAi0GUPrwJoCcgP9TsnBCw6HWrA/rsEA
   DGlgIi/OPNWh1skR6+o+suybIBZZ8XwAnj6YVlIL+3iBNgyWs6VA/V8Za
   5EQPHzLy6/NQrNpHMbdspfzPVgsb72cGTI7npdUaG4iaE5Ffy4TQVOEuD
   M22O+4AkI+NHAn/MJPfgDGiBUD38U10+nShZYh6cqozEqwDzdKfs0hAnx
   I4CBVEdPgQ0zE0Bzly/mLCoI+f/UGNKyD6IIHhfyY8k2fIRBJNp1JX5OF
   g==;
X-CSE-ConnectionGUID: oJYiV3k8RAyGfw+Z0iEKCQ==
X-CSE-MsgGUID: 95irUbPoRY6XBLPsF1Q4Gg==
X-IronPort-AV: E=McAfee;i="6700,10204,11193"; a="24904812"
X-IronPort-AV: E=Sophos;i="6.10,223,1719903600"; 
   d="scan'208";a="24904812"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2024 09:38:47 -0700
X-CSE-ConnectionGUID: FqDh8cg+RICkunkMhvuELA==
X-CSE-MsgGUID: ZItMzlLjSzSivzVAgX9hsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,223,1719903600"; 
   d="scan'208";a="68550411"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Sep 2024 09:38:47 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 12 Sep 2024 09:38:46 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 12 Sep 2024 09:38:46 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 12 Sep 2024 09:38:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fL3mVg4SxQIGYdr13QiCFmDJaoHnXJndoqAZKRsRbg68BWnK6SZ016KtQxnFi4LXgQ30piV6peZkBFbTHKUP0WBzGvVf9+KZbfkK3w/lYMk/Y1Rz0LY5mZb5MjZxJWy9+MOD0rjwXTlsGDEW/FmdAHH2Ags0g/GhTNvS1Sg40G3FMAmDTWhf7UEA8eek6P8RBUbGeFx6tpnLjm/HDdrw02rOpEgG6qskkmee5rZ9xB/E6QorOgXy6BceWdoRLbqIQw8ArhDH5x+lRhpmKgVIa5/CO15eK3NU1rbAyWK68bmWmisBJx0c3L+mAkh8ReijzFNRAM3joEVDBp07KOv5iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wbd4KLsIxbHxGhdYqrR2qcCkg73Y/X1M0IqW/Hereow=;
 b=WiJ3aTp/5gSHIsFDYz9C7xnmyXRWEq5hY9tIgGHvgI5/sRgNwctyY9fW2ThTK/yR8ck2gJllAbp+IwgqZobZxi7rPFWo1kn0dTmF8taae+EZqANtERNnRY06WonaUNy217xstIgvEJFQdyqgooIe1/SOQNIDOKwzr8uhG6JIDPSJh4JOlV/Nkm4vkJs9CGCpd+zBD+4gZ5y5O1IjMLKbUUH2NExa3IRKspKXcb4qhcXcmr1kRDEVyUpjnhuUsmiKWRXgJqG5/8HjxZWd60tHvz9ldYlxZROfRt/RDOOQG0ygQveo5Y7sCD6RHDWlucuwn0hasTcKRSP8A9krpXK9PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CO1PR11MB5187.namprd11.prod.outlook.com (2603:10b6:303:94::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.18; Thu, 12 Sep
 2024 16:38:44 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.7939.017; Thu, 12 Sep 2024
 16:38:43 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>
Subject: Re: [PATCH 25/25] KVM: x86: Add CPUID bits missing from
 KVM_GET_SUPPORTED_CPUID
Thread-Topic: [PATCH 25/25] KVM: x86: Add CPUID bits missing from
 KVM_GET_SUPPORTED_CPUID
Thread-Index: AQHa7QnThnZIMHm/AkW0hgwbYo+0yrJRemKAgAJ7zwCAAGp1gIAAEEkAgAAIOQCAABE5gA==
Date: Thu, 12 Sep 2024 16:38:43 +0000
Message-ID: <656b236701d3edd22f9139d346cb16b897dd775f.camel@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
	 <20240812224820.34826-26-rick.p.edgecombe@intel.com>
	 <05cf3e20-6508-48c3-9e4c-9f2a2a719012@redhat.com>
	 <cd236026-0bc9-424c-8d49-6bdc9daf5743@intel.com>
	 <CABgObfbyd-a_bD-3fKmF3jVgrTiCDa3SHmrmugRji8BB-vs5GA@mail.gmail.com>
	 <c2b1da5ac7641b1c9ff80dc288f0420e7aa43950.camel@intel.com>
	 <CABgObfaobJ=G18JO9Jx6-K2mhZ2saVyLY-tHOgab1cJupOe-0Q@mail.gmail.com>
In-Reply-To: <CABgObfaobJ=G18JO9Jx6-K2mhZ2saVyLY-tHOgab1cJupOe-0Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CO1PR11MB5187:EE_
x-ms-office365-filtering-correlation-id: 4debc9a8-2ed3-4881-cc71-08dcd3495dca
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?QWpPaS9GL1BxaXUyZEQvQzdhb0lpNW1SNUEzNG00TGRPOVVuNld1bSt0TlNS?=
 =?utf-8?B?RkptSWFUUzVPc1B3RWFxbFZoS05laHkxamhNVGlGY0xJSkdWdW5ieGhJbmFX?=
 =?utf-8?B?TU5UbDZZVmZrR0pPa2w4K1JCKys5VDBtcHE5NmpKK09BdVByUUpGYmp1b21k?=
 =?utf-8?B?T0IxMXc4QjNRVHZtY2hqbEdpMUtSWUhydHFxeEJXbUFISjUwZkxtbEUvbCtL?=
 =?utf-8?B?RmpOQk4ramlWSkhtR2YvOTVCOStDUkZzMzJacElsQlRsNC9vV2hmYkNSUVVo?=
 =?utf-8?B?U2I2UUVQOC94TlMxb1p4U01xUFNsYVpLY05mOUZ6djI3UWVuTjl6WEh3ZTNQ?=
 =?utf-8?B?RklOQlErUlpYeVBPTWpEcTh1dWFxcDVUeWE2YW56Q2xqM1FuSUtpTzZWZEdG?=
 =?utf-8?B?Mk8zQWVJMlZOQ1JRZmFBa2VYRWJoTHovdjhIRVRTNnNEZk5rSWp6NFpsUk9i?=
 =?utf-8?B?byt3R0x6THJxZGVoenNBMkhKNjFqMGxZUTh4ZjQwNHFha1pDaDVKZzlMVE45?=
 =?utf-8?B?aHJNci9BdndSdTlhWHpUN1VnNE9iRTFGNll1dDE4MkJUNG9vdVVGdFg0MUxr?=
 =?utf-8?B?K3QwVXlvdW5yaVl5YkNpN2JOUEI4OXJFRG0xQTIxcVk1RHBLQjRJZVVoazk2?=
 =?utf-8?B?d0M5Ykc1dzNLYjFpcUg0Q2dJY3J1aGJCaDVGZWtxMGtxU3hFVmJVT2dScVdx?=
 =?utf-8?B?ankwOXFITUhyY0dDYk0ycmdjUjBvYW5LU0taQWtMRHdRN2VITFVhWmpzNDQw?=
 =?utf-8?B?TnhOQTFncmQ3b21RTzhzR2hwV0JwODBPaEhkYUpxUmpFL0dIOFBYRlo1WThJ?=
 =?utf-8?B?UjFsVjQ3ZGlQcFZvN09mNEhyckdXa1FsLzM4SWluYXRMdTY2bWRQcUJicXc5?=
 =?utf-8?B?N3QwQmNRaHlJa2Vrd3VFekZxRWEzVFFlczlaM1RCUWNaKzBVWVRwdExDM2w1?=
 =?utf-8?B?MldLODNsWFpISmg1YjBlQUxwRXNEQkorVCtiQXgxWVhYRExNdTNSNmJYYXda?=
 =?utf-8?B?TEJJbmdlMUszTVNseEFmRkU0TG0zdEV6Zm1nVThRMFBLK0JRemltSkdiS2x1?=
 =?utf-8?B?enluS0dZMTA5MklNaHdwQloyZ25HNEVFNWhJODdzNFV0Z2Y0M2V0bXBuRFk3?=
 =?utf-8?B?Y2ZPeWI3WG5qS2VDUUw3T0taZGFPMTYxR09BZDJvbEVzdWRkdU1wNERhM3pX?=
 =?utf-8?B?THFMcjRqQnh3ZUNHUVFuZUlwT25SMUtJSjZGYlljaEpjWW1QWVNoK2N2eHFT?=
 =?utf-8?B?ZFF1V1NCYzNuOWtKTEYwNTJkRG5JdnZmWXpOalQzd29OWHYwa25kQzBoMDR2?=
 =?utf-8?B?M2huVkF3cHhYeHFsUlhlYWJTdFRjUDgxZ20rdndrL29vS0ZCaDMrMXQrc2d1?=
 =?utf-8?B?cHNNMW1nS2k2WGQzM2JzNXRTUmpFWUY1cW5HRU1nVTZlaTZGbmIrVEQrR00x?=
 =?utf-8?B?dEFIM2U3Sm82T0dldFgyaU91V0FmeUc2L0ErNEtPUUc2VlA1SkM3ek5kaHI3?=
 =?utf-8?B?L1I2QkxBSmk3OFpicFAwaHFOR3V0U09xbDEzZHBHN2xaTWRQYk1LTFVqdisr?=
 =?utf-8?B?Y0RBcnNNT2t5aFp2enRoTmVSY0d6SkVPMFMzRVFiUS91NS83VExPa1hDZWJn?=
 =?utf-8?B?aDBaYVBHdUw0Z1Zwa3BNblRqNFo1SSsrOVJ6Y3FMNk1lOUNXQjV0bVdubm1Y?=
 =?utf-8?B?eFVoS3RIb21VbUhzVlRpNGR3N2xIS2dBak4zSW8yeVp6T3ZxR3cxdi9RcVRK?=
 =?utf-8?B?b0F4WlgwS2l6eTRvNUt4Y0hKclNoU1hDMEJnM0NPL3duYTRSYy9qNmFmdUkr?=
 =?utf-8?B?RmM5THJBcWtNZ215WGVXVG9NaWZBVzVGQXZqUUVkUkg2UVdQQVc4dTdhUjJF?=
 =?utf-8?B?RGJsaUJhbFZvRzBpa0Y0bVZKUGNJT1IwS05vN1lXK0xtelE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YUVhV1pIVGtnWm9VTFlPdVBQMXBBWmVNenFNMGdCWHREYVU5K0IwQnpuRzRa?=
 =?utf-8?B?RWFOcG5xSERSek45ZERTb1lLU2pVZ2ZtdnlrRHU0NVdqRTVUelFEYnZaRjkx?=
 =?utf-8?B?S3prRXNyZW5KdmVPZzRGVjdtWStuUGRVSFhjUkpLQ0NjYjFQTTc1a0t6VHFT?=
 =?utf-8?B?UmJQODlxVnVFbytWbE9XaS94TlZpbGtEZi9qWkgyUUVISUJOenA2RWwxWjhD?=
 =?utf-8?B?VmlaUzFDWGxNR1ZpdCs4SjU0WXorT3hRUTJyT0dRaS9HN0c4RzhsZE4yUkM0?=
 =?utf-8?B?RllRNGhvZjBMbWoxTVJxMHB3WEZhd0Erbkw4Z2tJaEVkN0JyNHNYRWFvU25h?=
 =?utf-8?B?WmxINTR4emZpWGtyZjRlSTI1L05HZUYvWUJCR1VWdUFQb2VybEh6VG9PMHJI?=
 =?utf-8?B?V2lqdkFSb2crZXpEdExGVFM3b0piVEFqc2dTZ3h0ZHY5azFjTkRMZkQ0eVFS?=
 =?utf-8?B?b25YRkhZVEtPY1ZWeTZnUkhvSGVabnF6alAxK3ZxMFVJWHBjRG1LenJvNkNX?=
 =?utf-8?B?K0Z2b0NXNlpQaGU5dm05YXZTc2lrUXd4S0w3blROOExCZ2s5TllkWi9rc2RR?=
 =?utf-8?B?bko5OVZydEV3RjZUSkd5Rm9IbHBGYzh2RFdVTFlZcGM1VUpzem5oZUdpVThL?=
 =?utf-8?B?V0hobktWSG1CN2xHYjhsc1lHWHhlQk1EQzlDYnZYbGNEM1ZPd0VQbUNBMGtq?=
 =?utf-8?B?SUZaUEduUUhpZUZkYW04aldwaUx6NVFxd1kraUNKeWJwRGIrQ3FVdm14bnBF?=
 =?utf-8?B?UHhqMjRaNDV6UVpicUdyNHUrMS9jOTJ6MlRlSWJaQVkvNlMxN0o3b2x3dWxk?=
 =?utf-8?B?a0dXeWpkazQ4MFQ5U01oSnRRQTc0anNEL01BSi93RFNSb1ZTckY4a0crQzFO?=
 =?utf-8?B?ZCsxSmJBRlRlQXhxS09ZdFVJcjE4RVFTR0VMeGtjajROTExKQkYyUTVSSFJx?=
 =?utf-8?B?ZXpaTFgyaTZHMXRIbUtxZ21mdkJzR0hMTmVjeWpJMmJjLy95cnhyQ2c2QU1N?=
 =?utf-8?B?c09MYVpRS2t2WDQ1c0VCdHJ1b2NCK1ZTc0NDY25vaGNlMnNXRG9MbDliaEZz?=
 =?utf-8?B?V1FMNGRmYjV6bVJiM2FQNXAzSlFqZHBFbm5rN3M0WWhudlNRaUd1KzlGNDht?=
 =?utf-8?B?NnBzWUJtN0JVZHNHWGxYM2tNM1dJQnc1YWIyVmNyYXRKbi9ESWZlZ0hSSUtY?=
 =?utf-8?B?NjZtMW8yVzNUb1AvRmdDN3B1TEdGMGVIMEVrSGJKSzNhMXhZRERobEhnSDJ4?=
 =?utf-8?B?a3BDMDltVlpjSTkxcmxzYU9mRmxmRFdlYmdJT1dwWWhHY3FKdVpjYnMrMnJN?=
 =?utf-8?B?Q2tDaXFXK3J1V0srSnpMQWJLbVFIZUQrQm5VT1pjd0pRKzB6YUxQaE5ydEl4?=
 =?utf-8?B?SHo4NWVldGxwd3Fuck9kSXplK2haaGNoZzhDSUtZRDFVK2FncGRYNmxuU1E2?=
 =?utf-8?B?L1VDTUx3bDBXUmlYSk9PTEE4UlU0S3F6VkY4RzBEeVRTQmR1VXgzZzlrbHg0?=
 =?utf-8?B?QzVHOTZaRGttNnhER1RsdXZ0Ym9Ed2VpZk5hR2tXNENIUzdqZmFlbVBZWHpR?=
 =?utf-8?B?VHNSWHFRRlhQT1lYbUJrQlZtdHJGTmdUeG1aZTBwNUp4clVjWmcwR1ZvQi84?=
 =?utf-8?B?QUFEMlR4a1h5bkFjZG5PTURaV2NiOWFpVEVjbEVsSU9PV1loTGpNdGpYZ1BD?=
 =?utf-8?B?THIxSmNHamc0SWJBem44c3NUMTJySDlnQTY1STd0TE9IVGk4VXdIaGlja3M4?=
 =?utf-8?B?V0xnd0dxbTR1QTJLMEoyTXBpWWtnVnVXN1NNeEZJMnY4dnJQQndtcmhNcnlq?=
 =?utf-8?B?amVhR2NDdU4vVCtHZ2NzcU1qM2xKaEV0dG5BUmtsZlViRy84OU1IaWsrZXpt?=
 =?utf-8?B?TUhXRXpPUE0yK21OMlpBRCtsSXoyWk5QSTR6bWlqajI2K3RrbGhFSE9pbzZK?=
 =?utf-8?B?YUZKMCtFcDBESmszTjE2eXEzRDNicmRhb2FxSUVrT05GeHJ6QmVObG9CSlk5?=
 =?utf-8?B?TzJtMkc1dWU5Wkw0SnJoM09PS2FqdlFUWTg5YzEwbm54NExUNS8zZDdPSmF2?=
 =?utf-8?B?VlRqek5HVjV5dzdybTVOc2RYaHVYWVpGaWE0OEMyc2Z5MWFmWWFKQnU2VHNr?=
 =?utf-8?B?ZW93SDJNaG1EYUhUSkxZZWNTcGtQYTltaGJwZk9IcVdORVA1SlgySlBvS0pz?=
 =?utf-8?B?Y1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3FA61AC5E259444BAC068E6107251D80@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4debc9a8-2ed3-4881-cc71-08dcd3495dca
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2024 16:38:43.8845
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UVCMyEOXO9Rp5vWFpIh8uscW2blW6nyGLf89WnoGAFGbxh6n3AqS+GPpK/80oFjE7eVk4MGenN88t7M2ZhS5GjkQmDDrzhPWATtcWNNQwMA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5187
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA5LTEyIGF0IDE3OjM3ICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBZZXMsIHRoYXQncyBjb3JyZWN0Lg0KDQpUaGFua3MuDQoNCj4gDQo+ID4gV2UgY2FuJ3QgZ2V0
IHRoZSBuZWVkZWQgaW5mb3JtYXRpb24gKGZpeGVkIGJpdHMsIGV0YykgdG8gY3JlYXRlIGEgVERY
DQo+ID4gS1ZNX0dFVF9TVVBQT1JURURfQ1BVSUQgdG9kYXkgZnJvbSB0aGUgVERYIG1vZHVsZSwg
c28gd2Ugd291bGQgaGF2ZSB0bw0KPiA+IGVuY29kZSBpdA0KPiA+IGludG8gS1ZNLiBUaGlzIHdh
cyBOQUtlZCBieSBTZWFuIGF0IHNvbWUgcG9pbnQuIFdlIGhhdmUgc3RhcnRlZCBsb29raW5nIGlu
dG8NCj4gPiBleHBvc2luZyB0aGUgbmVlZGVkIGluZm8gaW4gdGhlIFREWCBtb2R1bGUsIGJ1dCBp
dCBpcyBqdXN0IHN0YXJ0aW5nLg0KPiANCj4gSSB0aGluayBhIGJhcmUgbWluaW11bSBvZiB0aGlz
IEFQSSBpcyBuZWVkZWQgKGFkZGluZyBIWVBFUlZJU09SLA0KPiBhbmQgbWFza2luZyBURFgtc3Vw
cG9ydGVkIGZlYXR1cmVzIGFnYWluc3Qgd2hhdCBLVk0gc3VwcG9ydHMpLg0KPiBJdCdzIHRvbyBt
dWNoIG9mIGEgZnVuZGFtZW50YWwgc3RlcCBpbiBLVk0ncyBjb25maWd1cmF0aW9uIEFQSS4NCg0K
T2sgc28gd2Ugd2FudCBLVk1fVERYX0NBUEFCSUxJVElFUyB0byBmaWx0ZXIgYml0cywgYnV0IG5v
dCBLVk1fVERYX0dFVF9DUFVJRC4NCg0KPiANCj4gSSBhbSBub3Qgc3VyZSBpZiB0aGVyZSBhcmUg
b3RoZXIgZml4ZWQtMSBiaXRzIHRoYW4gSFlQRVJWSVNPUiBhcyBvZg0KPiB0b2RheS7CoCBCdXQg
aW4gYW55IGNhc2UsIGlmIHRoZSBURFggbW9kdWxlIGJyZWFrcyBpdCB1bmlsYXRlcmFsbHkgYnkN
Cj4gYWRkaW5nIG1vcmUgZml4ZWQtMSBiaXRzLCB0aGF0J3MgYSBwcm9ibGVtIGZvciBJbnRlbCBu
b3QgZm9yIEtWTS4NCj4gDQo+IE9uIHRoZSBvdGhlciBoYW5kIGlzIEtWTV9URFhfQ0FQQUJJTElU
SUVTIGV2ZW4gbmVlZGVkP8KgIElmIHVzZXJzcGFjZQ0KPiBjYW4gcmVwbGFjZSB0aGF0IHdpdGgg
aGFyZGNvZGVkIGxvZ2ljIG9yIGluZm8gZnJvbSB0aGUgaW5mYW1vdXMgSlNPTg0KPiBmaWxlLCB0
aGF0IHdvdWxkIHdvcmsuDQoNClRoZSBkaXJlY3RseSBjb25maWd1cmFibGUgQ1BVSUQgYml0cyB3
aWxsIGdyb3cgb3ZlciB0aW1lLiBTbyBpZiB3ZSBkb24ndCBleHBvc2UNCnRoZSBzdXBwb3J0ZWQg
b25lcywgdXNlcnNwYWNlIHdpbGwgaGF2ZSB0byBndWVzcyB3aGljaCBvbmVzIGl0IGNhbiBzZXQg
YXQgdGhhdA0KcG9pbnQuDQoNCkJ1dCBhcyBsb25nIGFzIHRoZSBsaXN0IGRvZXNuJ3Qgc2hyaW5r
IHdlIGNvdWxkIGVuY29kZSB0aGUgZGlyZWN0bHkgY29uZmlndXJhYmxlDQpkYXRhIGluIHVzZXJz
cGFjZSBmb3Igbm93LCB0aGVuIGFkZCBhbiBBUEkgbGF0ZXIgd2hlbiB0aGUgbGlzdCBvZiBiaXRz
IGdyb3dzLiBJZg0KdGhlIEFQSSBpcyBub3QgcHJlc2VudCwgdXNlcnNwYWNlIGNhbiBhc3N1bWUg
aXQncyBvbmx5IHRoZSBvcmlnaW5hbCBsaXN0Lg0K

