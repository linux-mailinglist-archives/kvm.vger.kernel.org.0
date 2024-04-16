Return-Path: <kvm+bounces-14802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C1758A71EC
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 19:08:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 194B01F24187
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 17:08:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0905C1327E7;
	Tue, 16 Apr 2024 17:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XelVP2bB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343A112E1E8;
	Tue, 16 Apr 2024 17:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713287286; cv=fail; b=o1bS5gt6mN2O0mFeyidNNYYAsyCK5QmHYVFhHIX4dsb9SRgctykXQB4CahuvOpzsuZ0qXcMGTFKHN93huedfGnx2sBaX3N5u+irxfM8q1/8oZlXzdNjDyejiMujhy3Z3YroITs4/zF6xTdMLngnUih+0t5Wi4h8hc16UTERWgEg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713287286; c=relaxed/simple;
	bh=TfOpxQzArbhNslnulJcxXgZ5L30qmAUE1UcqvW4w1WQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PcOGsHXIGV4HbsJ/j4JMMj/80xUaN2HBdBONJrROhTH6/mTKm4g1fQCpsuvI8W0aoLni8jhc1nFdaJJlzxq6p1AnlJxz/BMxJeYDjI8nBp1M6wm25JPIYQvOi0U9/XptU+PmHFT1L/fs6tT9th9uyqV54Ym/i5Hv+anNnwRhnak=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XelVP2bB; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713287284; x=1744823284;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=TfOpxQzArbhNslnulJcxXgZ5L30qmAUE1UcqvW4w1WQ=;
  b=XelVP2bB/wc5oVDD1WVft7tRxAxHkrj2ihpiY23XiAF/nCY51yProBkK
   xaF3xMOp0OmfD3oq5kzMK6PdymzbiQqI/qWHHXex/lARe7VlV2D10vekj
   3sdJX8aKVB5YbYUccbhOfI8rEZ7hSFtxf0BsXUe0K++fb6i12wNQ0lWDb
   xmwK8f1BZi88vvUQ4VGsTCGpZQvvAc1NT8Ugqu2wXm9RDQUMz2+W9Ea0s
   g82QI5S9f0f7yLHoT+hxiZkdEnk2HwFUBpKc2/tShdeb9X3pevYwrm5Wo
   RVUZAGNhQ9CAYKVZ5Ugk3SzOVfZ/5vkemy/dMPQHlIacckOzgmR7hhZSv
   A==;
X-CSE-ConnectionGUID: vsQOsPA7S1q38Vk7CYNeyg==
X-CSE-MsgGUID: xki+jqvKTHac7QfKjPqZEw==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="8606469"
X-IronPort-AV: E=Sophos;i="6.07,206,1708416000"; 
   d="scan'208";a="8606469"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 10:08:03 -0700
X-CSE-ConnectionGUID: YszUdw1dSLGz4qGcd6m2cQ==
X-CSE-MsgGUID: B5Us25zeSYCVzw91NAmIow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,206,1708416000"; 
   d="scan'208";a="26899234"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Apr 2024 10:08:03 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 10:08:02 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 10:08:02 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Apr 2024 10:08:02 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Apr 2024 10:08:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fGjHMtO1CsEaC1L6DaQ7tNYzHf6RnD78dPvwSddBTWDoYejzGdRghARk/TQ1dJMpS1PYBYeDHLRRyCaBCxDl+h25Zb9eEqCI4wrqnBkfPI5Oou3PX5BB648G6JzzazUbSkzXMa/vm8Xut57HLLr0sEjlBnhT3RViXuh678o4W65BsMmYMGQ8CxciEpZGYhAvgQXtSTTABeKF3ECc/QVQNVtAm64eXWCc59/8p21wJZ0RIB3Eab5yjdkCd7lock+qy8C9Zi1HasxsfdejpIo3LKjMJSL32QH65mI7iCUqSRrEKzAhf2GMsRfcXjfx8rsf406ac0+RPt8Am9GWg3UixA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TfOpxQzArbhNslnulJcxXgZ5L30qmAUE1UcqvW4w1WQ=;
 b=ob5myGYe7/U7tgfG+gXLQmtPqqUmzocvPgNB5bFZWz/sShrUtI3Zx7zUV39f7bTWJKSMjLIpZW7s+JeZKSDgyKLqVnaeGyC5pWTYjr0Lj0gwyjTkZnaRXECSnR8bhpfPPg52LozuhvOrNuEbzN8P0v0Zr5XACTW5o9pUgk/QVu/ebWbUkq/1bl4gy/QT3HU232IzC1DNYiCHVFvIfrcZhhg7O6iDzbOdwneRrR/K3tXl1Yr94Mr1w6KN0JGwPBedMENt+c5u/U8o2NIH5Ocd4Ad8uVZYUfSkBKNLu5ZEG4Rksj1PWI0CXC7L7OIfNTyJ4vfNAZiLjaAsg9vxmGJXyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB8274.namprd11.prod.outlook.com (2603:10b6:510:1ad::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.29; Tue, 16 Apr
 2024 17:07:58 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7472.027; Tue, 16 Apr 2024
 17:07:58 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "jmattson@google.com" <jmattson@google.com>, "Gao, Chao"
	<chao.gao@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"vkuznets@redhat.com" <vkuznets@redhat.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Chatre, Reinette" <reinette.chatre@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V4 1/4] KVM: x86: hyper-v: Calculate APIC bus frequency
 for Hyper-V
Thread-Topic: [PATCH V4 1/4] KVM: x86: hyper-v: Calculate APIC bus frequency
 for Hyper-V
Thread-Index: AQHae64wrOFvUb4iF0eH0vM6CZoIzbFrSeSA
Date: Tue, 16 Apr 2024 17:07:58 +0000
Message-ID: <081f049fd8601ee81d9883797acafa006e7991c4.camel@intel.com>
References: <cover.1711035400.git.reinette.chatre@intel.com>
	 <d815921fff4c616c8b05bff0fb9377a171c8633b.1711035400.git.reinette.chatre@intel.com>
In-Reply-To: <d815921fff4c616c8b05bff0fb9377a171c8633b.1711035400.git.reinette.chatre@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB8274:EE_
x-ms-office365-filtering-correlation-id: 8a3ca35b-8133-4b15-4a9f-08dc5e37c426
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MADUZ27i3MUElC+DHB2Iz36IYHdFhMVK4Ep34cjabWsLDjxgeaPHHIQgzYyYd0wjXdLSgS6LKftZ44fI7a+tacRLpnz1R/bzsCjbFwFGLOj60tnfX+1UBemtGQzmPTZAQTTEvmeTHDKciwWnDSHUO+SKu3Kxc6ygvMG0jY7afRw1ooSJNblXQc23XxfKzsw2Khp2eSO3hLDRd0kEnY1wUzt+fZZyfsdE7OWjO9Y90rWXcZvVGh7FC6QqZw1WXzncAY4nniLgtr5/oKJEHpkF37intfVmhGKTGbbXor6D1oCaM+A2UiXAhGfsZmaO1wl74AU3A/cifZClmNuJfcGqu9b8wRdYH3Pemz9LstCSt8TB2aaLW9LDTANjA5iH6Y11bXA3QYHNwQ+nSAJ6CYzfGHhbEGB7iZOylBVNfWhMf5U8FzLlKiciumrA2aAWERKXUUa4rzjd7KawXxEUJqVDiAWtUlwe6gdSEHdGa2qmiqJ/pHlXfhhIR/VxY4qaId2dIYz/X95pGgAhlKYHdREKpoCpWFPdv5/F3yMVzorW/BTO/dW/JfOPrOImkm/nHUlq2A29chXMpuOp32tKBswlaWf+rAJUHoD0OcwA+R06I+egHaT9X2saflCRx151gKVKUD3RATrwYm9S4qmlGD5P7Aj7dCKaggGYEWqREyxT4mRWgErWaUNYIPZTCRXR7CX5zrnxd3g6z6Asja6RSf57OIBqxaiwiPgMGG1lUwBIutI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(921011)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RXY3TVlNQm1EL21BZVB0VElJYlFzYU9PeVBaL0ZYUW9iYUFGNzRwN3pMVHM1?=
 =?utf-8?B?YnNmZnpra0Y5dGN3T2dtSUdheWtTZ1NmWVcrbzVqTTB4RE4vWmV1TVF2SjBJ?=
 =?utf-8?B?RUdEYTh1WUxoL2Y2Wm5MTVB6RWpNZFEzenhlUWlNS3pUQmUyVHZjZDhZN01Y?=
 =?utf-8?B?T09RNlFHU3hUMkFPYjAybXg5NzFxTndaR2tTRmZORzdUVlRpSGNIdTFYa2pT?=
 =?utf-8?B?L3p5TEN3NEtKTzNpdVdLS0xralRDbUJMSCs0NHJnZklheXdYU3VyTWN4enM1?=
 =?utf-8?B?SGlEYytTL2loSFh4SGM4K0FkYXowQkdVL0xZY3dWeUxNcStMSjdPcThveEMw?=
 =?utf-8?B?cjdKOFdzRTB4NkVOMVUyWnJJUGNXd1VyWVQ3RE9LUlBrMWtoNlhLZE4rbWxH?=
 =?utf-8?B?QndWMVBPWEhNeUdzL1lrUmJFTnRocHlaWDhqOEtZcjZQNmNtanRaMjRrdk1P?=
 =?utf-8?B?YkprMHA2TFVadTk2RDVHQ2ZZME9va1N0MEZIVHhKYkNTSk1nSWkwTmJpRkw5?=
 =?utf-8?B?cHl2aHpnbDR3Q2tLZzlWRHl6WDVCYnE3VFVZYUZLRlM1MTh1V3hkVTFvT1c1?=
 =?utf-8?B?Zmd3VzF3WEtleEQrdEtqVnduYnJjMDVlcEFaNUQvcFc0cmZJa3dxV203ZS9G?=
 =?utf-8?B?SUJJNU9ia0ZOVXF2dWpXMWJJWHlhSWtkbGJzTEZHLzFqa1dRTERVVEJQWERQ?=
 =?utf-8?B?bEY5Mm9UZ3ZaVk1VN0FmMDFqOFA2eWJNc0FJODEweDBDNU5iUkNnSzNCdXRG?=
 =?utf-8?B?Wm1OT2ZWLzlBSktucU1UY1RLVUY2N25jeStSdGNQUVJ5WVo1ZzIxMEJUdXpU?=
 =?utf-8?B?dzJiRHVreEcvcU1BZmtoMlBReDQ0djMrTlY5TDQvN28yaDRjc2lwQVM5SXpC?=
 =?utf-8?B?REF4VUdIMHVsVWJjQml0RjZkaHR2REhaa1k2TWx0ZW5WcEE5ZTNmd2U2YWFE?=
 =?utf-8?B?UUV4aTE3UVRaUFFWS3VGM2c3eHpMK2M1Z0ppcGR5eVEwTjZMbzU0QkUxeXVr?=
 =?utf-8?B?M3RCZlp5S2JBc2pkdU9YNjc1U3RnSUw1L1hyblVhRDVmeTZKazhUUVQ1OU9G?=
 =?utf-8?B?cUtyMktVakcrRllCSjhkZ1VlRHZDOGpINTNKLzNHRmZmeDdobWFENDZpeE1j?=
 =?utf-8?B?L3dLMjV0V2g2S0gvR3ZINWJUcGMxZm1kK1BwSE55cHltVFZvNWhJZUE0MjQy?=
 =?utf-8?B?OFAzaHJnLytmd0ZuM2lJT3IxMi9EY2REWXY5di96MjVqYU9ubURTbGhMb3FJ?=
 =?utf-8?B?Snh4aDhaTy9tYmRqWlBBNStqaWRpZlZzaU9sN3NkdW5XaUtiaHc4T2lnbTZL?=
 =?utf-8?B?UDRDVFVWVVBNQlkybnhJZVh2YlNvb1dGWFF2Y01aa2NETXk0SnV5UEpGRlFZ?=
 =?utf-8?B?RkdsNHhHK0Z0UWdIVWNMaGJFell3UzN5QlBkZkNDOUIyVWU4Z0hTWGhGbFEz?=
 =?utf-8?B?NXRBWGhyZW1ZWGpMK1VEV25tb2pBdmt4U05leE1WTnljb0xEVmlYbko5THo0?=
 =?utf-8?B?MFJNRmo5NTRWUGk0eXcwZUtVekNNYUFTa1ZmUUFkNGpsbUVwWVJjWmpnQS9m?=
 =?utf-8?B?VkpkOFBhcTMvY3JTTEZZR1hpVnVQeTJCb0RnVWwrd3EvOU9vM3BzaW03ZmY3?=
 =?utf-8?B?WVAzbkg1V1RhVmVITmp2WkhIZTJvQ2dwdlArVStacndrYzh4Ym1KUUJ1K2o4?=
 =?utf-8?B?bExYb1MvSHFlUCsvdlVBK0VGZ3g1bzB4N0dhWDduTjltN2ZLU1cxdW56TVZx?=
 =?utf-8?B?ZW1GNWcvajFkbjd0YVMwTlBjdVlucVY3MkFScjMya2hpZjhuaUFIelIvd1F6?=
 =?utf-8?B?TERLODFLcXBHbDREYklqZ3pUQUxwSWtOczR3TWJNUmduRGg1RjVFYkJIWCtZ?=
 =?utf-8?B?QmxtTE5EdkxlTkpxcmVFbzVaRU1NbHN0OVpRN0ZNM2YrQjJBSEJzQ29zRTgw?=
 =?utf-8?B?cmROaGdObkZ1Z0UyNHNPeGt3YlB4VmNWMGhjbG1lM05mc0VZUGhIVWdqN2dE?=
 =?utf-8?B?aXo4MlhPZzYrdXc1cWdTU1lNYXpTYWRzQzlxZ1hsQnN4TzhFNXBaMDltaHp6?=
 =?utf-8?B?VFlQUWxqOExwNHJjM2lwNjJFOGlIRnJaME5OenJ4YXVNdWFzRGRGWGlTbnlv?=
 =?utf-8?B?ajhFak9OVjRZU2pOem1UNDBNaWNkaC92VkJJVHJkK0YwYm44d2dlb3RINVYr?=
 =?utf-8?Q?j4+VPGS4ramfbPL7vbYaCn4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C04BC33E76B30640977BAE68B15F51F5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a3ca35b-8133-4b15-4a9f-08dc5e37c426
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2024 17:07:58.6320
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DRJdpxRK7Y4yz1PgHzYc2XFiNyc2+9/PtAlrlNH51I+C7MJiRyX+HCMw774sHr5WAdr4jIQGwcZmHtgZWbviX5F2Xfq2x8ex7Dxpqfgqb6A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8274
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTAzLTIxIGF0IDA5OjM3IC0wNzAwLCBSZWluZXR0ZSBDaGF0cmUgd3JvdGU6
DQo+IEZyb206IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5jb20+DQo+IA0K
PiBSZW1vdmUgQVBJQ19CVVNfRlJFUVVFTkNZIGFuZCBjYWxjdWxhdGUgaXQgYmFzZWQgb24gbmFu
b3NlY29uZHMgcGVyIEFQSUMNCj4gYnVzIGN5Y2xlLsKgIEFQSUNfQlVTX0ZSRVFVRU5DWSBpcyB1
c2VkIG9ubHkgZm9yIEhWX1g2NF9NU1JfQVBJQ19GUkVRVUVOQ1kuDQo+IFRoZSBNU1IgaXMgbm90
IGZyZXF1ZW50bHkgcmVhZCwgY2FsY3VsYXRlIGl0IGV2ZXJ5IHRpbWUuDQo+IA0KPiBUaGVyZSBh
cmUgdHdvIGNvbnN0YW50cyByZWxhdGVkIHRvIHRoZSBBUElDIGJ1cyBmcmVxdWVuY3k6DQo+IEFQ
SUNfQlVTX0ZSRVFVRU5DWSBhbmQgQVBJQ19CVVNfQ1lDTEVfTlMuDQo+IE9ubHkgb25lIHZhbHVl
IGlzIHJlcXVpcmVkIGJlY2F1c2Ugb25lIGNhbiBiZSBjYWxjdWxhdGVkIGZyb20gdGhlIG90aGVy
Og0KPiDCoMKgIEFQSUNfQlVTX0NZQ0xFU19OUyA9IDEwMDAgKiAxMDAwICogMTAwMCAvIEFQSUNf
QlVTX0ZSRVFVRU5DWS4NCj4gDQo+IFJlbW92ZSBBUElDX0JVU19GUkVRVUVOQ1kgYW5kIGluc3Rl
YWQgY2FsY3VsYXRlIGl0IHdoZW4gbmVlZGVkLg0KPiBUaGlzIHByZXBhcmVzIGZvciBzdXBwb3J0
IG9mIGNvbmZpZ3VyYWJsZSBBUElDIGJ1cyBmcmVxdWVuY3kgYnkNCj4gcmVxdWlyaW5nIHRvIGNo
YW5nZSBvbmx5IGEgc2luZ2xlIHZhcmlhYmxlLg0KPiANCj4gU3VnZ2VzdGVkLWJ5OiBNYXhpbSBM
ZXZpdHNreSA8bWF4aW1sZXZpdHNreUBnbWFpbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IElzYWt1
IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5jb20+DQo+IFJldmlld2VkLWJ5OiBNYXhp
bSBMZXZpdHNreSA8bWF4aW1sZXZpdHNreUBnbWFpbC5jb20+DQo+IFJldmlld2VkLWJ5OiBYaWFv
eWFvIExpIDx4aWFveWFvLmxpQGludGVsLmNvbT4NCj4gW3JlaW5ldHRlOiByZXdvcmsgY2hhbmdl
bG9nXQ0KPiBTaWduZWQtb2ZmLWJ5OiBSZWluZXR0ZSBDaGF0cmUgPHJlaW5ldHRlLmNoYXRyZUBp
bnRlbC5jb20+DQoNClJldmlld2VkLWJ5OiBSaWNrIEVkZ2Vjb21iZSA8cmljay5wLmVkZ2Vjb21i
ZUBpbnRlbC5jb20+DQo=

