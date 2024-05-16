Return-Path: <kvm+bounces-17511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E34748C7083
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 04:58:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 121C71C20F56
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 02:58:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75BF34A2C;
	Thu, 16 May 2024 02:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S7CY88HK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5581877;
	Thu, 16 May 2024 02:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715828259; cv=fail; b=txFlDf7lbTim8TcBaglqE2FhByBZpccOtMoRo/Ef1IOMaHaaqyCUBEJA5K0jkTKJuRKnn3tSJmIbjkShHzs14AUy4A6Q3nkT2aq6G01OXSQfRTWEl2/IxZme4Zoc/386ZIkqD4HgNv6UTfneH9TowiClHedNDbaxo14kHx+sVv8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715828259; c=relaxed/simple;
	bh=0OATj/2nwBZJwMyA4JYhKIpPcHv9tdoIK12DLvV/Gw8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AgGTvz5d6IXSVP7LBoMCnE/EMOOzBTNmEjT/AhwYKuO0xlYMjnVMbDIjx370QT/Twof3cJgXhZ7wPsXee3JLKdJ6o/ta1vbAYAk4hhntzT8Qeo+lEFztdK93nuCey76VgECg/3eXIiVUpCko0HUTqzA8lmLzRHpeNljio8eb5gc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S7CY88HK; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715828258; x=1747364258;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0OATj/2nwBZJwMyA4JYhKIpPcHv9tdoIK12DLvV/Gw8=;
  b=S7CY88HKrqo3i+9oK9P066whKdNcyebtAFRsYzQBT374i21U549kV2F6
   haoxQIQC6YIeSUU/x2aGjXeBSaOomR+9tBdzJ+FDIY2ppfUTbIgcwEWVe
   hJjc53pK6uMqvl6TyofrhwcH/r4OzTv9CCTNYBh7psEE+rvO7/kphl5y8
   lYelWzszTqwLv6xVnFhlyG5SZV/2i29gItZJJAjysTCzrwmlKwcREaMoK
   jsOJ9mswPH2zEQ0bxxSFW+fU6vBmLIT5PckDpzpCB8k+ACJ8tGaJSraYA
   9CTWg49guw46BnGCDsAwJ6jnwGAUl76VCmZSmpnAWfiFP8LcRn//aFal7
   w==;
X-CSE-ConnectionGUID: o6arBFYbRR24sv9DizffZA==
X-CSE-MsgGUID: q/ssYvJNQ4uEBjXEpEvz2Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="15741528"
X-IronPort-AV: E=Sophos;i="6.08,163,1712646000"; 
   d="scan'208";a="15741528"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 19:57:37 -0700
X-CSE-ConnectionGUID: iL5q/SOmShGCGZKtQCVcrQ==
X-CSE-MsgGUID: jk/n4MHNRW61DBKwwBQmxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,163,1712646000"; 
   d="scan'208";a="31841120"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 19:57:37 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 19:57:36 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 15 May 2024 19:57:35 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 15 May 2024 19:57:35 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 19:57:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FB5s6mIhgrJDpfgcmbQECtk/wY4JyqGLWe5r1esrPXKdOnnOuwPbmBttGWL66E56etAtRZ2pGSWipW3eTqM0h7JAnrpqj7lm/Gr99uFBFUfAB1Q6c89Bo504MUo7neG2fWaYWSppPnItXTw4cqYMAbBIJw9/HEccnUD70EocfNshSni2N9rkS1k7yRFnNRALJVETSy7NqoWqveWan/Deas2Nk9S5wc6FLXawF6GT5XnLBMSaWddQxUuW2wD54LSQiIL4yh/Be7Quh9yAXvkiCRqvz51+TqFSm317hKAWvT71XXmHfVllUIi+u8M5CukQ9gziuYgUSwjBoeG2QKwy7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0OATj/2nwBZJwMyA4JYhKIpPcHv9tdoIK12DLvV/Gw8=;
 b=YehJhzT/qyy+c0lZameFpcQhvWP7dmBpvJGOuIHJdADe1q+D5iGFjU+pZtg5rutrMFNjH5QOZz6nZnQsWaRW8BT/JSzkvIfx2G/wo3zp+SNgSPyjAqQBPhtRG75fFl2Wy2Dpr4KpowD7sBczpkgKFWYljebO8LH84IIj/4/UXmag8aelD6tx7LShiMAtp0VOEiZczurAUdBmEbm+VEHUqDk6UGkqHG/Tczrz6bSMPNoy+72LG4NvjIiL7LW6sQrvSADb5eeEbCEycKyRUP7WvlFtzPvl7XM9RIujk9BCpWUiKzT+c9Gt9wOcUh+XcyjYn9dJGSfmpIUb4HSyfb6chg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ1PR11MB6251.namprd11.prod.outlook.com (2603:10b6:a03:458::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Thu, 16 May
 2024 02:57:32 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7587.028; Thu, 16 May 2024
 02:57:32 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "sagis@google.com"
	<sagis@google.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Aktas, Erdem"
	<erdemaktas@google.com>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Topic: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Index: AQHapmNTP3XGfqhyyEaM/KHu10XBU7GZCeQAgAAJxQCAAAs0AIAADfKA
Date: Thu, 16 May 2024 02:57:32 +0000
Message-ID: <588d801796415df61136ce457156d9ff3f2a2661.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-11-rick.p.edgecombe@intel.com>
	 <12afae41-906c-4bb7-956a-d73734c68010@intel.com>
	 <1d247b658f3e9b14cefcfcf7bca01a652d0845a0.camel@intel.com>
	 <a08779dc-056c-421c-a573-f0b1ba9da8ad@intel.com>
In-Reply-To: <a08779dc-056c-421c-a573-f0b1ba9da8ad@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ1PR11MB6251:EE_
x-ms-office365-filtering-correlation-id: 0e0ef853-fd3d-4eac-be96-08dc7553eebd
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?WHY4VU5IWGIvS0p0TDN4Z2xvYnVsN2NUVk8rSURnZWUzSThwV0N5UHErb2FY?=
 =?utf-8?B?ODVCeVJudnFTbHFVSlV6MVdTaWVyRDZFNy84S2RuaGw0aGVVT21HZVVYMkxk?=
 =?utf-8?B?ck9YK1doSjBYMzc1WHFUWEtnNlhKK285THBxenVmVDhPWFBvQ2xlTmxkcVUr?=
 =?utf-8?B?UjI5WXpRbVl2TkU3eGhwVitLeERvbnVENXY0STVZUW83Q0h6cHQ2WFFpSy9X?=
 =?utf-8?B?OTU2cmhNL1BRZklhTUpTOUk4bW1TTi9qNTZJdVU1SFRHUUhDUVJZU2kxdGNT?=
 =?utf-8?B?aW55UEw0NFp1L0JKbCtCcm9neGFHbGNQazhBbDFnWGhQNmtRQXVGK0grZkRq?=
 =?utf-8?B?VmZYSmNtUEJrRU5saWpYUlRZQWN4TVdGYUQxVlRpRUEzbXBlNGp2cDVnWFZ4?=
 =?utf-8?B?NG1JZTZDSjZndDNLNi9rbHpoanBKRzRkRm4zSUxEbnVXdnRnWjV5YklwV3dN?=
 =?utf-8?B?WldCK0RudDhUOFUzdThUY3o3dVhQQ3hrYkNVR25RamtVZlBRUjlhbEhyZ2I2?=
 =?utf-8?B?V2UrdFlKYWtsdEwwZXB1NE9jZXZnMXQ4bDlnNFNDUWFJRXJkZmgzWEpNSWl3?=
 =?utf-8?B?dU1keDdDUU81VEVvNkFYZmJEWjNmaCtrekk1TldsNXo3bWlYd2I0OXV5NGts?=
 =?utf-8?B?TndRQXNoYW1sSUNzL21HUVcwKzQ0cW0zdm9LRnlYaGRqS2hva0ZwOWZxdUlM?=
 =?utf-8?B?azBQbktYc1BrbjU1TmpXUTFSTTBQOHIwaGowRWFRSzFJU1RTSjFWYkpDRFVX?=
 =?utf-8?B?bStjUExRQW1zRk1aL0VWNVdWaGZybHlITmtQci9XcVpjdEdlek9QZFdIRGdQ?=
 =?utf-8?B?ME9zMUhiQWZzOWErc1dGektHNXhBaEZ4R25zVTk5U1dYdnRaZjMxVFl6T3ZP?=
 =?utf-8?B?cWY3ZGM5eDJtd00rMkticnZoVlpsMFAzejg3dGtFdjFxdFlKaFV6SmdxSjk0?=
 =?utf-8?B?ZmNLMUxXdi80VzF6NFErZE9tYmp6ZTlkR25EM29KNTRuTTE3ZTVtRUdxVTRt?=
 =?utf-8?B?K3p3RVVOTVM1SGUvUWNSblZ6S0pYN2h5TVJVQndDVXA4NkJuM2Fua2Zjb2Iw?=
 =?utf-8?B?b3VkVldJaS8vcG4xalpXSDRudjdhTjZKY3RqOFBldEdQTjdZY1Y5S2VHam1s?=
 =?utf-8?B?NTNpQUFnYWZPcW5lcm5SdzNXbkpkbEZkZ3lBMzh0N3RaQUw3UDk0aTNpeUlh?=
 =?utf-8?B?SFFxMHZJa3NQN09jZW1wKzhkOURhS3FGMmZNM0lLOFF5cUdYUzlpZUJKNWRD?=
 =?utf-8?B?UTJkcDFiMndxRlFSOUpyR3BjaG1kQkhCaDJuM1cwOWJtUmRGUkYvUnJQeURG?=
 =?utf-8?B?b09pajIvdTJNV1RGbjY0aFhNMDJmeWJybWlDa1hHbndYL2t5Y1BJdEwxQ2xs?=
 =?utf-8?B?VlVEVlprZUhPSXM1M0phVE8yWGtXTlVPUnVJZytDWlFBaXM5YklLd3pXY3dm?=
 =?utf-8?B?RnZzdExkd3hva0FZRGsra25BeWdCdVAyT1NkdXVLR29qMmpMMG8xY0dZQncx?=
 =?utf-8?B?NjR1T0dZcE8wdUp1a0JnK2FvR1gxK1lHclU2d0RFUWd5Ym5pUEdhT29rV0d2?=
 =?utf-8?B?cGt5SXJ3bUxPZ29aZ0hBOVE3dXBReDk2V1FON3I3T2dLYWp2UnozazlkNWlx?=
 =?utf-8?B?bjRaNFVJQUhFeDQ2TGdYc3RGc01FcjBhSlpzOGdiaGtGcExFYnRROHdnZkV3?=
 =?utf-8?B?azJmS0owais0VDNhQjJmdVQ0TDEzRGkzUGZ4d2YvV2tsT2psR2pxbUFOdjhs?=
 =?utf-8?B?WmFEbnVWNks0Qnd3T3hwK3NXeHJsVStvV0VETE40cllSZzRwUXdXelNNelZu?=
 =?utf-8?B?NVZoNU5BblRtekhhckZZUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VW5UMTVxekVSNG5RSEYwZG1nUnZRYWN0UHprNk9aVis1dVpzODVGSkdoU2Zz?=
 =?utf-8?B?MlFmdnNuNkVDa0Y0ajdJQk9vZy9xV0FFVFJXMzdUazNraHZpbmZWeEV6c3Rm?=
 =?utf-8?B?Rk9hK2JueitLTXd6djYwL1k2dzdVSGZpcVFqWHI5OUdLd3p3eTJud29ZWFR2?=
 =?utf-8?B?UC9qS1c3SUk4MFlCMUFXcGw2cHpPRk1TbVREOGpYaVlvdEFQTlNDVjNaekJP?=
 =?utf-8?B?dUpyL1JsOVcrZlNNNDBOVHllZXo2b0s0VGMweXF5S2d1a09VVitDNFVRaGhI?=
 =?utf-8?B?TGdEN3JiRlFSTzlhSGkwVCtSRUtwYTlPWGNmcW54c3RucEZ1UXQ1d3pGNUJu?=
 =?utf-8?B?T3Bib0NiVC80VzA2WWwrN2VFMGpETGtwcFZWSHRjK0JWcldRUHBRemtDM1JK?=
 =?utf-8?B?VG1sODlma29iRWEyRVN1OXhBWGxDSS91bGx4M3ZOeUJjbWlDSmJpMi95dWJM?=
 =?utf-8?B?SE1vRUZRT3lER1gySFBLNHdWQ2JnMmphSWFMT0VmMzVYWFJudHNTZ1RjYmht?=
 =?utf-8?B?cWdwT1k4TXdUSVU5OCtyZ1ZuQk5WY2IzVmJ5ZWd4dmJIWlJrVUNSY244SkJB?=
 =?utf-8?B?WkxaR1U5VmZvUFBEWld4TmsrSGlnM0xMQTA0Ujl5MGxwZ21GOW9teWRtaXMw?=
 =?utf-8?B?MXF2TFlpWEhPSDc5SS9ZcWFMRlo0K1pZcllpNlhpVWEzZ3AvWm5ZYlJ4QVdG?=
 =?utf-8?B?TEpWV1ZrRSs4YkJ3cEdRU1E2Mm53MEJaVU1VT1ZrY1JEeUM2clZvcmJyVUJU?=
 =?utf-8?B?OEtORzZadHRsdkllaDB4UDY1YUZlM0N0RUJrUVN0T2JramdOaXl1ZFBpQ0cy?=
 =?utf-8?B?WWtuakJkTEZQVHhxckk3UW1ZOHNpc3gvU05yZ1JBTFVCcTI1T2ZEV0xaQlky?=
 =?utf-8?B?a2Y3ZFBjeWpVcWhpRzIydTVURjFKTlQ1SXYxWlhrZWpHaEQxaHhzRVNNQUtK?=
 =?utf-8?B?cldiN1ByV2ZMcDBsaDQzU21lRmlLT2JRdUhyYlhQdCtBUjRlWllRRmE1ME4y?=
 =?utf-8?B?NEIrWFR6aTYyZ25RSkM3aVJVZE8yVktoeCs4c1lFV3ZqTVh3OGdld2tBZ3Iw?=
 =?utf-8?B?a0ZtaFRvWTh1VUloWWtkNkFxYzYrQkYyMWN4bnFpVlRUTmZtLytUREdHTFIw?=
 =?utf-8?B?aTFmdDdLWFFZYXVxVE9jNWFlZTNWTXh1ZXh6K0FDWTkrb2V3QmdGV0VmWmEz?=
 =?utf-8?B?ME1DbmpTTkhlb2tLNWxtNWI1cWp0VHdRcWRqaFNaK3NHdlNFZUQ4V0w2TGw4?=
 =?utf-8?B?L0FFMWJNVmt5OXMzVlRadmV1eTBGVkRGU2JwOHB3MndEN0FoQi8ySGFsZDVM?=
 =?utf-8?B?bzZOZGJCRlNVbzdlbnB6Ulg3c3dRU3ZuRlBPN1NHd3VGYVlOSDF6bks3aDZn?=
 =?utf-8?B?bFhYc3VmZ3NzcGFvQnBZRGlFbnB5UTJIMUt5QTM5Zm9RQWgxNVRRSVBTRWQ0?=
 =?utf-8?B?REtpQWVGMjNOZDQ3R0NFaGdlMkVEaG5aejVVS3d1d2lUOWFPUjZBQlkxNWpv?=
 =?utf-8?B?QkhiMnQ4SWhqVlUrZjBEZkY5U09TZ3JGa1hralh6c2tZb1o4UHFieHRXV2l2?=
 =?utf-8?B?a3pCbWtoMXlRNnZlL2k2MXNYT1J0cG8waXNxUUpIWnd4dlRXUXJOY0c2dzhz?=
 =?utf-8?B?YisydWNqLzlmdzVnUUlSVkg2OHpDL2hhTS9mRnlNOVhXMWRDMDdpeE00eWdK?=
 =?utf-8?B?ZklEVS8yc0hqZWs0TE5EcjZZT1BHMC9USEZMSjloSGxoemxCTEZsMXBETStM?=
 =?utf-8?B?WU9IV2p3Q2F5QkMwOS8zd1NYd0ZGMWFPOXNub25jL3M1K1g5U294amk4MndR?=
 =?utf-8?B?TVJjZTFRbnZFclZMdGVHV013SEtJT2ZoaDJYakNaZWVFTVlwQ2VHL3A4TmJr?=
 =?utf-8?B?cnJWd1h1eFJXN3R1UTRsSU0zY25ZY3NacUJYTFRURmhkMXFqeVBvajVpb2t3?=
 =?utf-8?B?QXJJNU56dkVKRVFjaHkvYy9GY014RmxkRU5lbUM1ZlhaOTBNQlQ5VDFYNVFm?=
 =?utf-8?B?ZFl3VndHRC93eTJMNEdCNmhXT0hCbXcrUFg0eGE3ZkdvNUlCa25qTmF5QURP?=
 =?utf-8?B?aHpmQ1I5TmV1ZkMxOWRRczg1a2ZwK0tYcVFwWWV0SFBWYW45RmsvNVBRYjVV?=
 =?utf-8?B?dktCNFN4bk1GdTRQc2VDakVueUhoR3ZLejhkOEViRklROUkxb0lOY2d1VzFI?=
 =?utf-8?Q?TGtsYWG/eAN9rXTFJlnYhts=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4A022F5C5B57ED41B0D9FC357755A6E5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e0ef853-fd3d-4eac-be96-08dc7553eebd
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2024 02:57:32.7848
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V8fUEudjUEIObogYrr1L7UF/gUAvhA3BY/hud0qohtZs9OuyFU647ZaD7NECpkUQuM+/R07AS9cMftDpRkGdqGD5EvERBnhj2xj5MGCdFGI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6251
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA1LTE2IGF0IDE0OjA3ICsxMjAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiAN
Cj4gSSBtZWFudCBpdCBzZWVtcyB3ZSBzaG91bGQganVzdCBzdHJpcCBzaGFyZWQgYml0IGF3YXkg
ZnJvbSB0aGUgR1BBIGluIA0KPiBoYW5kbGVfZXB0X3Zpb2xhdGlvbigpIGFuZCBwYXNzIGl0IGFz
ICdjcjJfb3JfZ3BhJyBoZXJlLCBzbyBmYXVsdC0+YWRkciANCj4gd29uJ3QgaGF2ZSB0aGUgc2hh
cmVkIGJpdC4NCj4gDQo+IERvIHlvdSBzZWUgYW55IHByb2JsZW0gb2YgZG9pbmcgc28/DQoNCldl
IHdvdWxkIG5lZWQgdG8gYWRkIGl0IGJhY2sgaW4gInJhd19nZm4iIGluIGt2bV90ZHBfbW11X21h
cCgpLg0KDQpJbiB0aGUgcGFzdCBJIGRpZCBzb21ldGhpbmcgbGlrZSB0aGUgcHJpdmF0ZS9zaGFy
ZWQgc3BsaXQsIGJ1dCBmb3IgZXhlY3V0ZS1vbmx5DQphbGlhc2VzIGFuZCBhIGZldyBvdGhlciB3
YWNreSB0aGluZ3MuDQoNCkl0IGFsc28gaGFkIGEgc3ludGhldGljIGVycm9yIGNvZGUuIEZvciBh
d2hpbGUgSSBoYWQgaXQgc28gR1BBIGhhZCBhbGlhcyBiaXRzDQooaS5lLiBzaGFyZWQgYml0KSBu
b3Qgc3RyaXBwZWQsIGxpa2UgVERYIGhhcyB0b2RheSwgYnV0IHRoZXJlIHdhcyBhbHdheXMgc29t
ZQ0KY29kZSB0aGF0IGdvdCBzdXJwcmlzZWQgYnkgdGhlIGV4dHJhIGJpdHMgaW4gdGhlIEdQQS4g
SSB3YW50IHRvIHNheSBpdCB3YXMgdGhlDQplbXVsYXRpb24gb2YgUEFFIG9yIHNvbWV0aGluZyBs
aWtlIHRoYXQgKGV4ZWN1dGUtb25seSBoYWQgdG8gc3VwcG9ydCBhbGwgdGhlDQpub3JtYWwgVk0g
c3R1ZmYpLg0KDQpTbyBpbiB0aGUgbGF0ZXIgcmV2aXNpb25zIEkgYWN0dWFsbHkgaGFkIGEgaGVs
cGVyIHRvIHRha2UgYSBHRk4gYW5kIFBGIGVycm9yDQpjb2RlIGFuZCBwdXQgdGhlIGFsaWFzIGJp
dHMgYmFjayBpbi4gVGhlbiBhbGlhcyBiaXRzIGdvdCBzdHJpcHBlZCBpbW1lZGlhdGVseQ0KYW5k
IGF0IHRoZSBzYW1lIHRpbWUgdGhlIHN5bnRoZXRpYyBlcnJvciBjb2RlIHdhcyBzZXQuIFNvbWV0
aGluZyBzaW1pbGFyIGNvdWxkDQpwcm9iYWJseSB3b3JrIHRvIHJlY3JlYXRlICJyYXdfZ2ZuIiBm
cm9tIGEgZmF1bHQuDQoNCklJUkMgKGFuZCBJIGNvdWxkIGVhc2lseSBiZSB3cm9uZyksIHdoZW4g
SSBkaXNjdXNzZWQgdGhpcyB3aXRoIFNlYW4gaGUgc2FpZCBURFgNCmRpZG4ndCBuZWVkIHRvIHN1
cHBvcnQgd2hhdGV2ZXIgaXNzdWUgSSB3YXMgd29ya2luZyBhcm91bmQsIGFuZCB0aGUgb3JpZ2lu
YWwNCnNvbHV0aW9uIHdhcyBzbGlnaHRseSBiZXR0ZXIgZm9yIFREWC4NCg0KSW4gYW55IGNhc2Us
IEkgZG91YnQgU2VhbiBpcyB3ZWRkZWQgdG8gYSByZW1hcmsgaGUgbWF5IG9yIG1heSBub3QgaGF2
ZSBtYWRlIGxvbmcNCmFnby4gQnV0IGxvb2tpbmcgYXQgdGhlIFREWCBjb2RlIHRvZGF5LCBpdCBk
b2Vzbid0IGZlZWwgdGhhdCBjb25mdXNpbmcgdG8gbWUuDQoNClNvIEknbSBub3QgYWdhaW5zdCBh
ZGRpbmcgdGhlIHNoYXJlZCBiaXRzIGJhY2sgaW4gbGF0ZXIsIGJ1dCBpdCBkb2Vzbid0IHNlZW0N
CnRoYXQgYmlnIG9mIGEgZ2FpbiB0byBtZS4gSXQgYWxzbyBoYXMga2luZCBvZiBiZWVuIHRyaWVk
IGJlZm9yZSBhIGxvbmcgdGltZSBhZ28uDQoNCj4gDQo+ID4gDQo+ID4gPiANCj4gPiA+ID4gwqAg
wqDCoMKgwqDCoMKgwqDCoH0NCj4gPiA+ID4gwqDCoMKgIA0KPiA+ID4gPiBkaWZmIC0tZ2l0IGEv
YXJjaC94ODYva3ZtL21tdS90ZHBfaXRlci5oIGIvYXJjaC94ODYva3ZtL21tdS90ZHBfaXRlci5o
DQo+ID4gPiA+IGluZGV4IGZhZTU1OTU1OWE4MC4uOGE2NGJjZWY5ZGViIDEwMDY0NA0KPiA+ID4g
PiAtLS0gYS9hcmNoL3g4Ni9rdm0vbW11L3RkcF9pdGVyLmgNCj4gPiA+ID4gKysrIGIvYXJjaC94
ODYva3ZtL21tdS90ZHBfaXRlci5oDQo+ID4gPiA+IEBAIC05MSw3ICs5MSw3IEBAIHN0cnVjdCB0
ZHBfaXRlciB7DQo+ID4gPiA+IMKgIMKgwqDCoMKgwqDCoMKgwqB0ZHBfcHRlcF90IHB0X3BhdGhb
UFQ2NF9ST09UX01BWF9MRVZFTF07DQo+ID4gPiA+IMKgIMKgwqDCoMKgwqDCoMKgwqAvKiBBIHBv
aW50ZXIgdG8gdGhlIGN1cnJlbnQgU1BURSAqLw0KPiA+ID4gPiDCoCDCoMKgwqDCoMKgwqDCoMKg
dGRwX3B0ZXBfdCBzcHRlcDsNCj4gPiA+ID4gLcKgwqDCoMKgwqDCoMKgLyogVGhlIGxvd2VzdCBH
Rk4gbWFwcGVkIGJ5IHRoZSBjdXJyZW50IFNQVEUgKi8NCj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKg
LyogVGhlIGxvd2VzdCBHRk4gKHNoYXJlZCBiaXRzIGluY2x1ZGVkKSBtYXBwZWQgYnkgdGhlIGN1
cnJlbnQNCj4gPiA+ID4gU1BURQ0KPiA+ID4gPiAqLw0KPiA+ID4gPiDCoCDCoMKgwqDCoMKgwqDC
oMKgZ2ZuX3QgZ2ZuOw0KPiA+ID4gDQo+ID4gPiBJTUhPIHdlIG5lZWQgbW9yZSBjbGFyaWZpY2F0
aW9uIG9mIHRoaXMgZGVzaWduLg0KPiA+IA0KPiA+IEhhdmUgeW91IHNlZW4gdGhlIGRvY3VtZW50
YXRpb24gcGF0Y2g/IFdoZXJlIGRvIHlvdSB0aGluayBpdCBzaG91bGQgYmU/IFlvdQ0KPiA+IG1l
YW4NCj4gPiBpbiB0aGUgdGRwX2l0ZXIgc3RydWN0Pw0KPiANCj4gTXkgdGhpbmtpbmc6DQo+IA0K
PiBDaGFuZ2Vsb2cgc2hvdWxkIGNsYXJpZnkgd2h5IGluY2x1ZGUgc2hhcmVkIGJpdCB0byAnZ2Zu
JyBpbiB0ZHBfaXRlci4NCj4gDQo+IEFuZCBoZXJlIGFyb3VuZCB0aGUgJ2dmbicgd2UgY2FuIGhh
dmUgc29tZSBzaW1wbGUgc2VudGVuY2UgdG8gZXhwbGFpbiANCj4gd2h5IHRvIGluY2x1ZGUgdGhl
IHNoYXJlZCBiaXQuDQoNCkRvZXNuJ3Qgc2VlbSB1bnJlYXNvbmFibGUuDQo=

