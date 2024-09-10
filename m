Return-Path: <kvm+bounces-26317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A9C29973D8C
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 18:44:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0DC79B281C0
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 16:44:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A39DC1A0734;
	Tue, 10 Sep 2024 16:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UfQfqTn2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6631E18B467;
	Tue, 10 Sep 2024 16:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725986638; cv=fail; b=Bb8MMV5JqFpq7AKMLl3di9Fq7qAHYPNtNChVB/N7wVmCFrD78kPxkCb8gn0h88OeKQ7H78CaQ3hpWE8frV1K4OZRty76sMDomv9nGM6u7fEcRd8eiK8vl4/ReSHUwiojPvAjcpCB1IuxCq0uoFfSPHZvB9gWRaTePErIPQDIUg8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725986638; c=relaxed/simple;
	bh=AjoJYCIWhfrmKylMFrKOO4Jb6Lx3LFqAKXFr+myaEmg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CQM+9htfSFanp+FAJ24Nzldw2fqQzgl/fMPivuZCNGamLQ1QR8Isw10nF5QVAWYPNxm8K2btyvjUdPEFSsVyS+WjpZu+indlaB178NnewZEzQRKW+hpsycyQESr7QW6VVeCVFBj4LZ+QupMVK1N8j6y3iuzpZ7n4GjfVkQxYY3o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UfQfqTn2; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725986638; x=1757522638;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=AjoJYCIWhfrmKylMFrKOO4Jb6Lx3LFqAKXFr+myaEmg=;
  b=UfQfqTn2NaTKw0Ze+fC2izMxKbJofxMfQGgwh1jxtLGmSO190sWQwmMW
   bS17by/GjESdwiU9OVUWXeUe/zp5ekCmB0DWjY3JF366/E15PEhrhD4iy
   NJMc9jG5iph+bBjnmfgQ6LHy4JJ19SEkELT4gPyaQoeIf6e/wmAR7LFUj
   Edh1t2BvQSE1xJyadNBjCr+vAE4IvKW9w2vxI8PtF8B9HGfD6cG/ZX6W4
   61YM6BSoABO3hMSG9U3svcCggvM5v53I7rGjy4aYLWUoary0BET39LGaf
   6HZJvOGE9ziymAeUEwl3NO2Omk6EK2yqe/cYgYZtzIgeWu/dTOJC1PYP1
   Q==;
X-CSE-ConnectionGUID: M9WE/KS+SfO2fJJlvOCMDg==
X-CSE-MsgGUID: dnRmscuSRrm0xJBPxH6Ylg==
X-IronPort-AV: E=McAfee;i="6700,10204,11191"; a="27667693"
X-IronPort-AV: E=Sophos;i="6.10,217,1719903600"; 
   d="scan'208";a="27667693"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 09:43:55 -0700
X-CSE-ConnectionGUID: +dPhpS7bR/+1EEwO3YHCCA==
X-CSE-MsgGUID: yFX0uMELTHi7XpdXPWDYSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,217,1719903600"; 
   d="scan'208";a="71232860"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Sep 2024 09:43:54 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Sep 2024 09:43:54 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Sep 2024 09:43:53 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 10 Sep 2024 09:43:53 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 10 Sep 2024 09:43:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=El1ykuKMoo0e/6MF96O1wUs8g7giLxbNexfR2S/u4wzlCRVZXLUvdxz/9aKRljo3rqttH1oAQ1bXC7d1D6kTMTfIv0QvalGLK3JtN69ciFcJc89k5LAK786rB4AcDoqOiC5n2/usa9xFQFKYNwIs/S0h5PsVwZGrx0ZMXZk4nWL9/myWmMcobsolCx2bXcpuv/XzGfYuuXQ3SJO5ENcqhmdh7572NAXmmoLPkkI9B8wNEjbpnNRV5N7SY7pOmRqLluP8lblri54tcVsahVwgWJeN/68p/tskc7ypt8RsvS32a2qpkXPQNFumzOXxrVF/KNu5SxTqo1/S1dcaBh/nRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AjoJYCIWhfrmKylMFrKOO4Jb6Lx3LFqAKXFr+myaEmg=;
 b=cszclH8+3JrxyYZMZQO3nMwUZqY4+onfTdWQW0KeiOgLy/Z/Gd7wYeeUVCMZp7GbNq2LlBXw/F/xyUAtZwmhR9yg57y20tqzgiPQmUuCpDW/9nlqRw5rf/okzvQzwI6yaXGOocZLgmRLZqqjFGTw4ztAWedmQYlgEsjXQjx7h55BN+lfGpL+/styf75kW8b/YWDi5PM4hsRpNdnUsibcS9H6IJ7IefT+mat6wtxI/qrIuZ0aeUz+ssQ84wqgZh8Tf06NLxVJF+i5g9Ew/P8RPAE2OykCJLLyJ6iExWbRRNv4OGVyY5p7KnFgOQgThJ707ocHk5VMtupRfyAz/NZ6hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM6PR11MB4706.namprd11.prod.outlook.com (2603:10b6:5:2a5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24; Tue, 10 Sep
 2024 16:43:51 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.7939.017; Tue, 10 Sep 2024
 16:43:51 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/25] KVM: TDX: Add helper functions to allocate/free TDX
 private host key id
Thread-Topic: [PATCH 07/25] KVM: TDX: Add helper functions to allocate/free
 TDX private host key id
Thread-Index: AQHa7QnMV1ngoQ2e1UOkx4byFOQuTbJRYnsAgAADdQCAAAC1AIAAAIEA
Date: Tue, 10 Sep 2024 16:43:51 +0000
Message-ID: <38ecaf2b1a0cd590f67609c87a72743a07b1e464.camel@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
	 <20240812224820.34826-8-rick.p.edgecombe@intel.com>
	 <661e790f-7ed8-46ce-9f7c-9776de7127a8@redhat.com>
	 <e5dd31c924e8be70d817fe71e69d40053ae7f15a.camel@intel.com>
	 <99b3b6f1-f70a-4fa7-9ebf-0532bd0c8002@redhat.com>
In-Reply-To: <99b3b6f1-f70a-4fa7-9ebf-0532bd0c8002@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM6PR11MB4706:EE_
x-ms-office365-filtering-correlation-id: 536a1d2e-18e4-41f6-3ea5-08dcd1b7c00a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZklyM21XL0hoMW0rUHZMMDhrSHFtcHp4ZVpORG1Bbk9RSlNMemUreXpDYmRy?=
 =?utf-8?B?NnVtc0FrM2trQUdYa2dydjgrOFVTRkJ5THJ1a2R3dHpsSVFjWlRvZHcxOWFS?=
 =?utf-8?B?bGlKckMyOVFveFpSRDJtL3M3eHp5L1E1TVovNng0MmkzNXdMbkR6M1JpU3VB?=
 =?utf-8?B?by8zMEZ6SWgxU0VCc0FGN1B1dVJnT0NnNWhLYURXREZIRkgyR2U5YTB2Q0JJ?=
 =?utf-8?B?NVJ3V2RTMkFJWDBZN2lnTkdsSE9JN2M1ZEFmUFhaeXVWSVdEOXV2emZicGlJ?=
 =?utf-8?B?QUl3OHJmS3doZUlyOTljb00wbTNDM3ZTdXpmYzkwNkdWRE84RTJ5ZTBCU2g2?=
 =?utf-8?B?clpXMDdzUy9ZL0pueU9iVjNGM0JWLzhPNUJSdGVTeVJFUXAwTEl0UkMrNjJz?=
 =?utf-8?B?QUxwRDVhTk4raTM4QXVNeGRuVkdhd0Z3cWFITFJYVWhOc2l5NllLOFBnbWRV?=
 =?utf-8?B?YTd5TFhkWG9RVndMcVdtWDRjekdTeEJkSFljS25nSG81QklYWk5JQmRUMlN2?=
 =?utf-8?B?MndnazdST1lTeDBpMkhqVE8wSys1bVdjci8xcW1IVHlVQUlvbWNlMWIyOVVQ?=
 =?utf-8?B?SFJ4UFZ3clhoay9lZDZ1WG14TTBzS0RNbHhLQnZROCs5OEErU3djbGlpbUZE?=
 =?utf-8?B?U0ZBdXBxT3Mva3NlOEk1ZTk0Q2tIRjNxeFh2eDFSUlpzcU5wQktsM0VESTU0?=
 =?utf-8?B?Q2RSY2lJaDgyWHdSYTFRLzVaNWlVZzlNNThQU2pPRjMyZUtpa0lJQVZpaXhi?=
 =?utf-8?B?bHk2QllJMFhVTGRGR01mVXhIVkI5U2tRWlNwVjJFNHB0UjBjd0htME9XME04?=
 =?utf-8?B?Qlo4eStIYjlzVkxFRUoyenBQanJpM29VS01RdXpNTE14Zld5WVJBUFJPaVg0?=
 =?utf-8?B?OGFJTGhCMkFXendnY01uWmZaNS9ERmlJcEIxQUZmVjZrQkhHWEF2ZW1YM1Ux?=
 =?utf-8?B?VUUweThwZlJtUlNLeHFOM2hMY1VxVkhtUXJSNkRvL2psa2JLMFlGTGd1eld3?=
 =?utf-8?B?NFgvMU5tZVAyRWh3NXJhTDhJaUxlM1gydjh4ZDkzdllYdVIvaFZ4YW1lZzl2?=
 =?utf-8?B?UEdVWVd4bUNzRTFCK3F6NHB4QjRQTVYrWDA4bkV3bVB5VHNzYlIvMytNc2k1?=
 =?utf-8?B?aVg3Y1BqT2ZuU0JQZmhyN1NaVDZsZ1lieExCNWprR0JPRWxPVVREWXROaEFo?=
 =?utf-8?B?QldkeDVTcTRINnJYTUlVRkswWWMxcnJ6NXc4RFUreUlkaUZja0FZeEg4VEZt?=
 =?utf-8?B?bkdyeXFEME5kanF5dFhTaUFqcHVIdzlZdk4yVk1mQmp4TStKUHBnMnNtTXgx?=
 =?utf-8?B?aXpuNVpybG1qMjFLek5JRnBUSjJrZE1IYTU1SFZWaVpEZzRwdmR5MDdFeW9L?=
 =?utf-8?B?cUxZa3JOZmlHcXQxYTI5UE93N2h0YWV3SHVPUi9CTjcxR0F5bGRKU3JDZkF5?=
 =?utf-8?B?S3laK0J1NVJ5SXB4WFhyUm9WT0svN1dzN2djQjVpemNpTWx2R1M2YnYxdWM3?=
 =?utf-8?B?Q2pJOXFGRkJ4c1hObE9ZMjkrVUVWTFFSd3lYdnhETnhPSk9zYWJPZEk2T1NP?=
 =?utf-8?B?ZFBGUjk3NXZ3YXRKZXNQUDNjYy9kcE5XcEpVOHY5eGdmZ2lJOGlTcTlpcGc3?=
 =?utf-8?B?OHpueFNyWEhXWG9mUENtTGZ2MXJISTVnNlREb0RwbU0xbWp1M0FsRkhUVzBy?=
 =?utf-8?B?M0tHc25EUjNycXdGR2JzNU9XYU9kb1VrWlNBL0tKU1Z0cTFpckpkUnpCME9y?=
 =?utf-8?B?azhESlFEa0JPWnhLZlUrNklFSlhjZ3FDWTN0cEpnNGNLY3pUZVFoTHpKeDdS?=
 =?utf-8?B?LytIMXphUUFFS2VHTFkyNy82MnV5MlJPaG11a2wzbjZmRkE1Y3BWdm5yeWJ2?=
 =?utf-8?B?a1BJVTN6OFhOM3dxOENRTE9lbDVIcFRzR0dMOWZleHEwRGc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MDN0aS96bG1CTFBocCtuSWRxK3RVMmVzbjJpTkgrenBUYTQvREtEOVNoOXl3?=
 =?utf-8?B?MGtseDF3M0hLTWhmdXZjUTRTZW1iMnZuU0QrK0VNRWFFdXBVOElXNDg0S1pm?=
 =?utf-8?B?c1pBWVptN3J3a2lON1ZvelpSeUJyR2htOUtod2JLOFFDbDF5QUIrNTFKTlgr?=
 =?utf-8?B?QWUrMnJKRWNkOEpuOS91aTM0cXpMOXBPTlBTbFFqM21ST0lGKy9vTWMvSGtJ?=
 =?utf-8?B?L1EyQWh4bnNZTjdNZDh6Kys1QTNaTzlYanpTTklqcmJySnB5YTJJWUdKN3gr?=
 =?utf-8?B?YUU3aUNHZmxKc3RnTzdsSjRyUm1tRDl3NG50Uy83VmRBQit1VnIyRFlLdWdp?=
 =?utf-8?B?QVQ0dXpMcVprSXJHN1JaYlpSYVV0SGdtTWxzQ3VSRVdKVkxvanZFODRVaW1H?=
 =?utf-8?B?OVVJRGpFRFNCNFZyNUFubG5Bb2NTTEhqSkdFT0dIMHRqSWg2UlZCWWVGT3pQ?=
 =?utf-8?B?bWFKSGw5YUVQR0RqbHlyTEF5bWp6YThBbWg2ZUdmU2FtQlRhblkwVmlidWEy?=
 =?utf-8?B?alV2NTJFU09KZEU3alNmbE9jTTRNNEhrY0t2WWNHNER5U1JqbVpFSUYrZkYz?=
 =?utf-8?B?OUtzM0tNRm5SVzQ1RFlsQmg5OUNhbFRXZWwrdXRxTHJhbUtXOTJzZk11cGZv?=
 =?utf-8?B?c3Z1ek55emZSYzQ2ZHN0aC8vRFY2ZDdaS2x0N0hxZ1FNZ2pJeEZWd0h6MldO?=
 =?utf-8?B?N0UyZlg3RjdwYVZlWVdDNTUzVkllZ1RaK1RsVnNJL1RrYXI4RG9uNXpIbGpY?=
 =?utf-8?B?RHQzZkVyRktldjMwUy9aUjJZcXRCYlpFSzdyb2pWSEw1aklKRlhMd2E2UWZJ?=
 =?utf-8?B?YTA0dHBNUmhBSGZWSXpuekRLV3pUam81cDd0RE5jYkFlazgwUmsvOC9IeGF5?=
 =?utf-8?B?WW44ZUlkSUFuYWpCOWltNkR4TTNqVWZrTko3ck1jWHlWcXEzajh6NEFNaFRa?=
 =?utf-8?B?ODk3UUhMNWNVTnREVUlUdFNJOU1tMXVBK01hbEpIekpjb1B5WWkxeGE5b2dr?=
 =?utf-8?B?aVFZWExtb0liWFF5UU45TUo0djVXSi9VNUdDekdxNmpFT1dUdmJwcmpvcklk?=
 =?utf-8?B?azBSVllqcW1GRUNoVmwrbUxyRWI1VFJ0aUZxcnZES0pZbEhMeXVmMjlMU1cz?=
 =?utf-8?B?Q1NwT2VzSmxrK0trbEw1UmpDV1cxbnJ1MUM4eG1mQTBNb2Jlc3p5d3ZsNHdw?=
 =?utf-8?B?UVNiUG5IblRKM0ttNU5ZekgxWHpBdmdtRW10c0M2NVZZdEV5OGd2Q2RoQ0N3?=
 =?utf-8?B?a1J0TFhmTlJmLzlwU0wrUFpNQytjSE5vV3F0ejVDVzNFNy9lR0xyUitsVkgy?=
 =?utf-8?B?LzM5NmVLdzFzb2pleHh5TnZVTHdDRXhmVXRTSnNidjdRcDZFdm1xdnlmclVQ?=
 =?utf-8?B?ZjRkN0dadlp0aUd4dCtpZ3F2YWZoc0ZiczZVRHJEVXlSMDlqcjdQKzRub2Jk?=
 =?utf-8?B?OEVYd1VubTI0bHI2MGhDckFGczNYMXM0RFNTK3BDbk9uOTNCTE1IZDFHeU9I?=
 =?utf-8?B?aVV3V0E5VU9WaUVtZi9nUDFYRml1R1hZbGk1VzVHanpQMjRtM1IzQzhaZDB0?=
 =?utf-8?B?RjEyRkR2aXJ0dnQ3KzhhVWlJd1RseWhWcjc2REwwOFY4UUdGWUM4amYxSDN3?=
 =?utf-8?B?bzBTdXF1cGZWdjhRUE5rMFlNRzlxUVlUaTd6bzdNbVl1Y0tzLzdmVEZKU0VM?=
 =?utf-8?B?UlJBK2dsQVVoNW9YKzFsSE5iRWJVZHBJTjczdk16bzB6MDVCUlkxa1JkUXlu?=
 =?utf-8?B?VjE4UFNBY0VjRTBoeVJNVjVsVXFHUHBnbU9xY2xQNGVlUzRYV0VjY1k5bnox?=
 =?utf-8?B?OE9XcXN1U0srdHdtNDhXNFBFOGVsY2FocktCQW5zcU53OWZHV3N5bnk1Rnhh?=
 =?utf-8?B?cXlFUVhiUGRlOEVsMWIwQkVITk42ZktMTHdGSlNzL3VXemhWK3F4dlZjUnNF?=
 =?utf-8?B?OTJTa29mVXFTckNOM0N2OVBsdXJMNC9iQkN2aC9FcGNPOVFFSlpwSkxGN0FN?=
 =?utf-8?B?ZWlPVlg0eWlmdnFhTjgxc21UTkJCOThHM0RhWm1JWVFTQmJ2Y0k2ODA4SjE4?=
 =?utf-8?B?RW1JUXU1eDc0ZnF4UHFDS0ZtMW4zelhoeEtwMTR6djA5V04yWUwvV2cwSDFO?=
 =?utf-8?B?bHdaL0tqRTRNcjFOeGtNM25RUHZTWDBSV1NoN0RyRWtyZzdvUVFyaUdLaWt0?=
 =?utf-8?Q?LiwCPQs5yMJmCjcDiRJPHPA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ABD5EF1F656D3D43B646B9D17886DAAC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 536a1d2e-18e4-41f6-3ea5-08dcd1b7c00a
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2024 16:43:51.0469
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jA76HsqK+5ao+AsivOJB+i96gYOXcnc3bwdVEvoUhaDxwz03IzgHDyjUdwXkQhNEanZzcOQt01+h7qglyOD/pWdUQzB8ClV7x1YUYbMb68o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4706
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA5LTEwIGF0IDE4OjQyICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBZZXMsIEkgbWVhbnQgdGhpcyBpcyB0aGUgY29kZSBhbmQgaXQganVzdCBoYXMgdG8gYmUgbW92
ZWQgdG8gYXJjaC94ODYuIA0KPiBUaGUgb25seSBvdGhlciBmdW5jdGlvbiB0aGF0IGlzIG5lZWRl
ZCBpcyBhIHdyYXBwZXIgZm9yIGlkYV9pc19lbXB0eSgpLCANCj4gd2hpY2ggaXMgdXNlZCBpbiB0
ZHhfb2ZmbGluZV9jcHUoKToNCj4gDQo+IMKgwqDCoMKgwqDCoMKgwqAgLyogTm8gVEQgaXMgcnVu
bmluZy7CoCBBbGxvdyBhbnkgY3B1IHRvIGJlIG9mZmxpbmUuICovDQo+IMKgwqDCoMKgwqDCoMKg
wqAgaWYgKGlkYV9pc19lbXB0eSgmdGR4X2d1ZXN0X2tleWlkX3Bvb2wpKQ0KPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gMDsNCg0KT2gsIGdvb2QgcG9pbnQuDQo=

