Return-Path: <kvm+bounces-21931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AE878937958
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 16:48:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A2B3282D1C
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 14:48:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91500143745;
	Fri, 19 Jul 2024 14:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QtuHxAHY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3072E128812;
	Fri, 19 Jul 2024 14:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721400483; cv=fail; b=Vw2ILPfYqyQ4MXXjjKxBo7Vd+US0+p8pWyN1TdZaAO+Bb9cdlL4GduSMulg0YsuCGiVKXp28Q5QrtMV5vlc1kITER/e9COLmg1VRXJHOHKPGarwVitHRT9La0uNHuzbHFjLf1rvGOk4NqJnzOehByos1Zv5PyiZADlkWSTGiqCc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721400483; c=relaxed/simple;
	bh=hzJeoN/XDVq95sGqfCV3YI5jtWl0PZRO+2biKWuodTY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=B2Qslkh+VwAtyDKpmRsWWIR6JPBExTyGdH2nR68sCqjqp1yuLtVphiutegQiYwdM92xFiX9bMfaCIiKdwCmHYQ1keyj59VfuX+EHh4DJe1iVUJQV57Lz4M71L54YZ1Ivgup4pBQ68ak/Cht3iqKk7z9HayflH258+dRatAU7fg8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QtuHxAHY; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721400482; x=1752936482;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hzJeoN/XDVq95sGqfCV3YI5jtWl0PZRO+2biKWuodTY=;
  b=QtuHxAHYA2mKRfPjeRZORpz5/HWTuiaSXwJ8v5e4MVaouhj3YNSeoR63
   Xvbzw+HFqmOiddyty/KVjmqRWwGtXf98hm7h0beO/5EbM/RybCTsW/a+5
   hlbBnly4w2vzeH4z9Df6kdga5TdSLXloZHzcEUcyqVTxjtbRv50f3Ip32
   HRId7/j/DWEI/oOp9o8iO1GONP6fcGFfzNdsBn8Z0UrxFepYqdtVkRcoD
   jC5TN/sQeqXMxuN49FEbAYN0O3dx5cA1z3As5bYB6DIkrYTq23R63xGo9
   KAFbwGE8rfPVbXci/YIkA4eQ1MfQ0kpFXs41PXwjuTeLgQMvaGVo/KP6l
   A==;
X-CSE-ConnectionGUID: gSo9PynDTvunMfbS5+bjjA==
X-CSE-MsgGUID: NsUpUSUhR0un1Op7pOIzvg==
X-IronPort-AV: E=McAfee;i="6700,10204,11138"; a="19131224"
X-IronPort-AV: E=Sophos;i="6.09,220,1716274800"; 
   d="scan'208";a="19131224"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2024 07:48:01 -0700
X-CSE-ConnectionGUID: 6c4IfDrwR4yc+uS+nWHKNA==
X-CSE-MsgGUID: DAy+4QkYS9+olAv3y5jl0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,220,1716274800"; 
   d="scan'208";a="51416634"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Jul 2024 07:48:01 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 19 Jul 2024 07:48:00 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 19 Jul 2024 07:48:00 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 19 Jul 2024 07:47:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WG++Ywiwonx8mqg7RqKOUevwDemqzPJ5AgEiG8trDRbjul93LTbYA6jpWQ466AefQmVU0RWyUsSFWdwMcxn2PdblzdfBM2aSbvneJ2DfXcnHZ1JrAQ2+dFityMkv19EE7W9xTc+C2sw3tExbBIU70g28SFqdFDpl1kM7ZrUWRguLTH2zHvbBneeOCct3VKx8+IAmjDhFSJkPE1xLqEggCFyBf19S+UC2/ML/dR9OooLABT2GqwtgFiXf+D7jAhyXRC1gap7xw3m47715kWrTGugw2iDZfrBcSDFswfPmS76Us+Sh6YR2MGkE19SnLMZ+CipoujSHBl+WKEeZletWjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hzJeoN/XDVq95sGqfCV3YI5jtWl0PZRO+2biKWuodTY=;
 b=JvWFZRPz8Qtk+7s71WRcXkeIGbzr/8jbVzimsowO+yzeap41xO6lNTiwZEpMYoFbq1xZw4tCjhR9Wv9bK1ceZwwguTLYgpFs69brq2ErCXFtPdVVfTOiS6jjfNm7l1qanp2p8pbXP9i5JsGyTQVPaeGQWC8ny+U922ToBSUWoi6b13FMJss2jj0lxUYFlteLUfUTq3+3D6c+glM99WyDLkYnmvjR2mL0xMBQ6nHCy3AVfAzh8xCBvHg37qKezDhYoH+gzzT5/5Qjc3BOD4Dan8YIsKwB8d7WaeAcLuD41L15P4wKtSZzlXsswc7yl0cD3ylbydU96sJQO1zpTeqE8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 BL1PR11MB5317.namprd11.prod.outlook.com (2603:10b6:208:309::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.16; Fri, 19 Jul
 2024 14:47:57 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::2dd5:1312:cd85:e1e]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::2dd5:1312:cd85:e1e%3]) with mapi id 15.20.7762.027; Fri, 19 Jul 2024
 14:47:57 +0000
From: "Wang, Wei W" <wei.w.wang@intel.com>
To: James Houghton <jthoughton@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, Oliver
 Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Sean
 Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, Axel
 Rasmussen <axelrasmussen@google.com>, "David Matlack" <dmatlack@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, Peter Xu <peterx@redhat.com>
Subject: RE: [RFC PATCH 00/18] KVM: Post-copy live migration for guest_memfd
Thread-Topic: [RFC PATCH 00/18] KVM: Post-copy live migration for guest_memfd
Thread-Index: AQHa0yLrMREFiNTQzkGMfF5XFxrB97H3dEtwgAIrioCAAIlR8IABjtGAgAIkZOA=
Date: Fri, 19 Jul 2024 14:47:57 +0000
Message-ID: <DS0PR11MB6373FC422044CE3542754D8BDCAD2@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20240710234222.2333120-1-jthoughton@google.com>
 <DS0PR11MB637397059B5DAE2AA7B819BCDCA12@DS0PR11MB6373.namprd11.prod.outlook.com>
 <CADrL8HUv+RvazbOyx+NJ1oNd8FdMGd_T61Kjtia1cqJsN=WiOA@mail.gmail.com>
 <DS0PR11MB63735DAF7F168405D120A5C6DCA32@DS0PR11MB6373.namprd11.prod.outlook.com>
 <CADrL8HWM-DX48GudKuc-N5KizZCqy-RvppejzktmtHS62VbaeA@mail.gmail.com>
In-Reply-To: <CADrL8HWM-DX48GudKuc-N5KizZCqy-RvppejzktmtHS62VbaeA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|BL1PR11MB5317:EE_
x-ms-office365-filtering-correlation-id: 6ba064f3-7d4f-4e45-618b-08dca801c73f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TUpkMDVNRGdxc216WDlSSWpDUTZQL0V0V05xcm56K1I4V2hraVdrY3NCYjF4?=
 =?utf-8?B?eFMvNm1xMUt0QXROVS8yUmZBenFwVUg4b3V6bHFtdXQ0Vjk3RXhPZE40N2p1?=
 =?utf-8?B?SGFYaTdGMU5YYlc1RjlzUUQvdkM3VkhOcjhPS1BrcVNPMTZqMHpRUi8xWS9E?=
 =?utf-8?B?RkVUZkNzRGgxblpkb1RqNVY0RHJicVNjVzZnMjRJcnI4SHB2bG41SXh0cWI0?=
 =?utf-8?B?dHJtSk9McWlScW5KQVlET2pWM0oyWlQzSUJGVGowbDJhQmQ2VnNEWDQ4VDJ2?=
 =?utf-8?B?WEY0aDNTVDNkeFhXRW9TMVRpcW9hcmdMVk9CelNIL0hGOVM2VVRLQ3FIUU1u?=
 =?utf-8?B?cVZPR3pWRDYway9rcXlWUTJHNlM5V2JGcG1CY0s5TWRRRU5mUkRwZi92RmRR?=
 =?utf-8?B?c1hMcjFvOHlKZ090aDNLcW93citBbmZ3WldHclRSNGhkckVvVTBqbnI1b2tG?=
 =?utf-8?B?RzRiK24rWm9qTm05Z0FNV1M5VXJ2SGhRYzhaWHNjbU5LeXlkR3B0aEpYTDRo?=
 =?utf-8?B?MWorMHdocW01VUMyZ2RNelpkbVpJeU1nbDc3TWVSSnZoOURBMVV6TVJOSThj?=
 =?utf-8?B?Z1IxejRhUmR2dVFsUGJFT1U5SG41YXhkMDNyVURKdkFRMnNZclZwWmlGQVY5?=
 =?utf-8?B?eUJraEhTRUVIdWFjTWhkaHNHeThqdnljekhWblJyYnZDSG5WMVFtcjdEeWo3?=
 =?utf-8?B?dHN3Qmc2aCtCT2NJcThzUEhBcDZMc2g4NDFEVzA0Z1RRczdMWGhmdXZsVFBO?=
 =?utf-8?B?SnI4aWNXY1kvYk0zUU5SOW9KVmRKU0xKQVo2cjdpK2Y2WkhPbTA3UU01dUFM?=
 =?utf-8?B?VUVBSUZGTGNvM05vd29ZQWZxR0J3KzNjd1N3azI1azlOcWdVMFE5ek5sN3Rt?=
 =?utf-8?B?eEFOcXd4MVMzSE5KYmYwbUFBRkZlRENsUUt4NG14RFdCNnh2ZitVd1JtTWE0?=
 =?utf-8?B?V25IZmNjZktZL0k1RDB5cFNMYmxiazhUNTNwU3ZJd3VwLzdBSmtYUUU2S3Ns?=
 =?utf-8?B?Mk5mN0ZsSWp2SzVDSzVZTUhqcEczSlBJQkc5MXBSMVVhUVJjYlpjaVVQL2pG?=
 =?utf-8?B?MENwcjR0cUs0aFhKNjdXTDJ3cFlWOFN6U2ZpOTNOeEdXT1VpQTAxcktOcnFJ?=
 =?utf-8?B?RUFQU2E2OEIzaE1FYngwSVV1ek1JL2x5c1RqUTZPbHlReGJ4V05JRVFEOUpy?=
 =?utf-8?B?TDFVbnl6U1ZsUHFYWkwvTmp5OXN6S3JZUVVzYUgydTNJRytDUjBPbUZoaEVK?=
 =?utf-8?B?NzVPaUtXcjFQaWhLUzFvR05DRGFaUUpWbnJFUUFUb0wzQ2FrQUM2NVpGRS9n?=
 =?utf-8?B?VEw0TElBY2FpaURFaU5aL3dSTkwyZ1ZQM1Rvb0R0WmM0cjNwWm9tOHdYaG1I?=
 =?utf-8?B?am9XUTJ3UkdTc0VJdWJqRk1nejB1R0pzZkVtM3VIYmlGcXRrQTRjbmRMaCtj?=
 =?utf-8?B?RSttU3pNTWQ2WU4yeEhvanREdUR2NjNyekw4M25iTytKWm5WNTlXanJzbktH?=
 =?utf-8?B?N0t4T2diR1hqWEhSNW5ZZlNPT014TENpRzBrbUFVTWcrcmlwbTd4VDVzYnFy?=
 =?utf-8?B?cEJPMDk3aHAwcTFOUjhURFg3UjZDbXJmU0g5aEtnTnYyUm5IUi9xUEl0S0JZ?=
 =?utf-8?B?L1k3QUZEc2Y5ekxuTWEveEJ3MW1zRU1FcHZnS0FhTEs0ZHdLQ3JndUpiWWI0?=
 =?utf-8?B?WFpFcjRqSzcxbzlGckt3UllkUk9BN1lpNVV6M3ppTThhbHRaMFVZeE9LL0p0?=
 =?utf-8?B?elZqKzF3OGw0VG5SMWFDMnFrN2ZTa3p6NUJJWlRXbXpGTFV3MEpvVkhHWFdv?=
 =?utf-8?Q?Mjp7zy81VP/jbBzroGq67Jyt7h+FoeZaT0z4I=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UFJ0aDd1SG1LV3AzTUdPZTRuRnBZN2xud0pZazJ4cDk0dXE3bXZHeGxrQ1Fm?=
 =?utf-8?B?VDlHNDhvK081U25IRGdQZ2N5SEVlN1VIKzZhc3NCRmx3RjJDa2E3M1VoNUw1?=
 =?utf-8?B?WU9ONlg3amdxTzhLUVQ2OGo4Yk14SEZGY1o4OW8zYk1JRDJnOW9mVW1DU3JY?=
 =?utf-8?B?MjVHdXk5ck04b0lIK3VaMkdzS2dhSzFEQ3pIMUZXZmJmR2wzcjdiejdiYTBn?=
 =?utf-8?B?cjExOW9ERUNNVWlCRlQ4d08yanB4Q2tlVGRURktoRmV0bW9JOUZXOEZUL2k5?=
 =?utf-8?B?U1dOWkJmZ0lQMHNjbVpHWG1Pa0JIR25sRm14VU5pUVZJQTV3M2Y4UktxMzdB?=
 =?utf-8?B?ZkFpS1F3MGE3MGE2TWdEbFdrYW4rZlJmZkFqSVRJSGhmNFdZb0ROaHpPOHcv?=
 =?utf-8?B?R05Sb0NXU3BnZlNEQ3JQWnJyR09OYXVBWlduNWNYMFExSmhVSllYRVBIWEFE?=
 =?utf-8?B?RlRWS3ZRYzd3Yktmb1BBOUhaSGtnVGNlN1Zrb09yN2g0aG9yekxRU2ZWeDlt?=
 =?utf-8?B?S2lWZUtSYTM5M3lzZERLVTAyVUU2dnhUZU1SeTMwbzMrTFM3UUlSbytEUUJn?=
 =?utf-8?B?aHJlVWl1NlVxWVJGKzBQc3pqWkRvM3BSb09zRmtjQVlPaFRVb3AvRkFvR2k0?=
 =?utf-8?B?ZzZCMVZiTW5IR1B5T2RsYk8wRVhVUEtta1I5a1NidkZWdUdZVkhIU3lDcjc4?=
 =?utf-8?B?M2lpU3NpQzBLU3lMNXEreVkyV3JtbGFMSUg4MERjNjYxM0ZvaFRyUFJyRGJa?=
 =?utf-8?B?RWlYOVpFYVcva3IzVEI5SThiaThCaDVQMzlxRjZwZHVaZEI1MmRMcDV6UXJt?=
 =?utf-8?B?VTNFZ1puSXQ1VVhVOGhqclhHZjVZNXZDMkJCSHNWYWwzVWVNU3VaVlBvSHBq?=
 =?utf-8?B?a1RkV1pKSkErd0U3c2hCV2FkdXIwNjlKdnhOQ2h4SlovU3I4ZTk2WWNCVkpp?=
 =?utf-8?B?dUYyeGZkc2VoaXhoaFoxbmRRZHVFVnhKQms5YkhURXVzUWpJdU8vUGorSzVR?=
 =?utf-8?B?Vzg4Q0s3eUFCQXorNHpjYm5EVTFhVzROWjYwQlRicGhYSzF3b0Exb2hBNm0w?=
 =?utf-8?B?MkRUaVdOc29GQkhURGJpMW1FMkF1eURNQ2VCa212WDdPNUhsQ2hJRGR3NDNQ?=
 =?utf-8?B?U2dTay9qV2JpdGJqeWtkL0RoWlZza1ROZUxGRWpUZkI1dzFrZUtqcXpHVWdC?=
 =?utf-8?B?cXlMYzg4dnhDczJ6ZndMNi90NEdXYzg2b3RPVXFQdUh2TERrNHRUZy9vaVZs?=
 =?utf-8?B?Q2dqVU4vVDhFaFVrRFpLOGJ5VzZQVHJ3bHUvL1Q2dVN3cFdHNHBBd2loWU9m?=
 =?utf-8?B?OEVCYTRqYXVTbjR2Uld1N3c0aGpwenBJZUdlU0pGNjM5L2liMUpNTGFJQ3py?=
 =?utf-8?B?WDFDdisxcjZXS0RlTVFmcVB0dWV3ZlphY20vT3k3WWxHT2g3dGxSb0V0NTIy?=
 =?utf-8?B?Z25PZDhKNXFPR0M0V2Vob3pPYUZEYUQrckhsZzQvZUNnbitXQ0pxN0ZYSWZO?=
 =?utf-8?B?OGpNMlJTSVFVc0c0clJ5enJZM0h3SnN0QWJEdGE2NHFKYkw0RU9SRlVkT3B4?=
 =?utf-8?B?a0krVWZHRHo5bW9JQVdlRHVlWWRUQkhBNzRtRmlUSkZBWjd0dHNuT0RLTlYr?=
 =?utf-8?B?UFljbENGYmZKbDNabGJlOXpIcU5hRGpXVExha2kzTnE5Vk4wYVF4VjdkOGNu?=
 =?utf-8?B?a2d1cWNiT0wrNFZxS29NRzFDMWhXZlZDYXNadS9kWHVvR2twbFZkVUNHV1Mv?=
 =?utf-8?B?WFNucHF2SEljbkRjci91RkxJUHRDWlF4RG5DRy9UM2w1L0JxVlRwK2UrbVZV?=
 =?utf-8?B?LzZKZWNlOTlDTWVWNkpaOXB2Nk9Yd1I1VlFvQ00ra2xFbXo3Q1oxQlpESWs4?=
 =?utf-8?B?MDFkNG5rdXZlR201V3krWlBKbjl4NXpkTG5UdFI2OWcrNHB4L2dRbzhHSWkv?=
 =?utf-8?B?aHh0ZXFsRjh6dTVYM01UTExGdUNQbldLTXhCTVEwUzhBaHcwVTJCTzRNTjFZ?=
 =?utf-8?B?SFRBVE4xeFdvSW1SODJKZk1UNzRZcGFkTEV5bm5udWkwNkdXSHF1K2NldG1t?=
 =?utf-8?B?YUc2alVPUWFuSWsvSkh6NTZscVpveWVwbCtqMnlJRGorcS9KWFJmRzl1ek1C?=
 =?utf-8?Q?+62KFJ2RBSdBVJZSrZjSEvM6N?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ba064f3-7d4f-4e45-618b-08dca801c73f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2024 14:47:57.0834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9bo4H/pWmA97NmzY3lcy4MfdbHE3DGm9tIbb+LYppLxE7qTaNDEP1gumbY7A012LFnF6sJWTXGdaoKknrpJzxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5317
X-OriginatorOrg: intel.com

T24gVGh1cnNkYXksIEp1bHkgMTgsIDIwMjQgOTowOSBBTSwgSmFtZXMgSG91Z2h0b24gd3JvdGU6
DQo+IE9uIFdlZCwgSnVsIDE3LCAyMDI0IGF0IDg6MDPigK9BTSBXYW5nLCBXZWkgVyA8d2VpLncu
d2FuZ0BpbnRlbC5jb20+DQo+IHdyb3RlOg0KPiA+DQo+ID4gT24gV2VkbmVzZGF5LCBKdWx5IDE3
LCAyMDI0IDE6MTAgQU0sIEphbWVzIEhvdWdodG9uIHdyb3RlOg0KPiA+ID4gWW91J3JlIHJpZ2h0
IHRoYXQsIHRvZGF5LCBpbmNsdWRpbmcgc3VwcG9ydCBmb3IgZ3Vlc3QtcHJpdmF0ZSBtZW1vcnkN
Cj4gPiA+ICpvbmx5KiBpbmRlZWQgc2ltcGxpZmllcyB0aGluZ3MgKG5vIGFzeW5jIHVzZXJmYXVs
dHMpLiBJIHRoaW5rIHlvdXINCj4gPiA+IHN0cmF0ZWd5IGZvciBpbXBsZW1lbnRpbmcgcG9zdC1j
b3B5IHdvdWxkIHdvcmsgKHNvLCBzaGFyZWQtPnByaXZhdGUNCj4gPiA+IGNvbnZlcnNpb24gZmF1
bHRzIGZvciB2Q1BVIGFjY2Vzc2VzIHRvIHByaXZhdGUgbWVtb3J5LCBhbmQgdXNlcmZhdWx0ZmQg
Zm9yDQo+IGV2ZXJ5dGhpbmcgZWxzZSkuDQo+ID4NCj4gPiBZZXMsIGl0IHdvcmtzIGFuZCBoYXMg
YmVlbiB1c2VkIGZvciBvdXIgaW50ZXJuYWwgdGVzdHMuDQo+ID4NCj4gPiA+DQo+ID4gPiBJJ20g
bm90IDEwMCUgc3VyZSB3aGF0IHNob3VsZCBoYXBwZW4gaW4gdGhlIGNhc2Ugb2YgYSBub24tdkNQ
VQ0KPiA+ID4gYWNjZXNzIHRvIHNob3VsZC1iZS1wcml2YXRlIG1lbW9yeTsgdG9kYXkgaXQgc2Vl
bXMgbGlrZSBLVk0ganVzdA0KPiA+ID4gcHJvdmlkZXMgdGhlIHNoYXJlZCB2ZXJzaW9uIG9mIHRo
ZSBwYWdlLCBzbyBjb252ZW50aW9uYWwgdXNlIG9mDQo+ID4gPiB1c2VyZmF1bHRmZCBzaG91bGRu
J3QgYnJlYWsgYW55dGhpbmcuDQo+ID4NCj4gPiBUaGlzIHNlZW1zIHRvIGJlIHRoZSB0cnVzdGVk
IElPIHVzYWdlIChub3QgYXdhcmUgb2Ygb3RoZXIgdXNhZ2VzLA0KPiA+IGVtdWxhdGVkIGRldmlj
ZSBiYWNrZW5kcywgc3VjaCBhcyB2aG9zdCwgd29yayB3aXRoIHNoYXJlZCBwYWdlcykuDQo+ID4g
TWlncmF0aW9uIHN1cHBvcnQgZm9yIHRydXN0ZWQgZGV2aWNlIHBhc3N0aHJvdWdoIGRvZXNuJ3Qg
c2VlbSB0byBiZQ0KPiA+IGFyY2hpdGVjdHVyYWxseSByZWFkeSB5ZXQuIEVzcGVjaWFsbHkgZm9y
IHBvc3Rjb3B5LCBBRkFJSywgZXZlbiB0aGUNCj4gPiBsZWdhY3kgVk0gY2FzZSBsYWNrcyB0aGUg
c3VwcG9ydCBmb3IgZGV2aWNlIHBhc3N0aHJvdWdoIChub3Qgc3VyZSBpZiB5b3UndmUNCj4gbWFk
ZSBpdCBpbnRlcm5hbGx5KS4gU28gaXQgc2VlbXMgdG9vIGVhcmx5IHRvIGRpc2N1c3MgdGhpcyBp
biBkZXRhaWwuDQo+IA0KPiBXZSBkb24ndCBtaWdyYXRlIFZNcyB3aXRoIHBhc3N0aHJvdWdoIGRl
dmljZXMuDQo+IA0KPiBJIHN0aWxsIHRoaW5rIHRoZSB3YXkgS1ZNIGhhbmRsZXMgbm9uLXZDUFUg
YWNjZXNzZXMgdG8gcHJpdmF0ZSBtZW1vcnkgaXMNCj4gd3Jvbmc6IHN1cmVseSBpdCBpcyBhbiBl
cnJvciwgeWV0IHdlIHNpbXBseSBwcm92aWRlIHRoZSBzaGFyZWQgdmVyc2lvbiBvZiB0aGUNCj4g
cGFnZS4gKnNocnVnKg0KPiANCj4gPg0KPiA+ID4NCj4gPiA+IEJ1dCBldmVudHVhbGx5IGd1ZXN0
X21lbWZkIGl0c2VsZiB3aWxsIHN1cHBvcnQgInNoYXJlZCIgbWVtb3J5LA0KPiA+DQo+ID4gT0ss
IEkgdGhvdWdodCBvZiB0aGlzLiBOb3Qgc3VyZSBob3cgZmVhc2libGUgaXQgd291bGQgYmUgdG8g
ZXh0ZW5kDQo+ID4gZ21lbSBmb3Igc2hhcmVkIG1lbW9yeS4gSSB0aGluayBxdWVzdGlvbnMgbGlr
ZSBiZWxvdyBuZWVkIHRvIGJlDQo+IGludmVzdGlnYXRlZDoNCj4gDQo+IEFuIFJGQyBmb3IgaXQg
Z290IHBvc3RlZCByZWNlbnRseVsxXS4gOikNCj4gDQo+ID4gIzEgd2hhdCBhcmUgdGhlIHRhbmdp
YmxlIGJlbmVmaXRzIG9mIGdtZW0gYmFzZWQgc2hhcmVkIG1lbW9yeSwgY29tcGFyZWQNCj4gdG8g
dGhlDQo+ID4gICAgICBsZWdhY3kgc2hhcmVkIG1lbW9yeSB0aGF0IHdlIGhhdmUgbm93Pw0KPiAN
Cj4gRm9yIFsxXSwgdW5tYXBwaW5nIGd1ZXN0IG1lbW9yeSBmcm9tIHRoZSBkaXJlY3QgbWFwLg0K
PiANCj4gPiAjMiBUaGVyZSB3b3VsZCBiZSBzb21lIGdhcHMgdG8gbWFrZSBnbWVtIHVzYWJsZSBm
b3Igc2hhcmVkIHBhZ2VzLiBGb3INCj4gPiAgICAgICBleGFtcGxlLCB3b3VsZCBpdCBzdXBwb3J0
IHVzZXJzcGFjZSB0byBtYXAgKHdpdGhvdXQgc2VjdXJpdHkgY29uY2VybnMpPw0KPiANCj4gQXQg
bGVhc3QgaW4gWzFdLCB1c2Vyc3BhY2Ugd291bGQgYmUgYWJsZSB0byBtbWFwIGl0LCBidXQgS1ZN
IHdvdWxkIHN0aWxsIG5vdCBiZQ0KPiBhYmxlIHRvIEdVUCBpdCAoaW5zdGVhZCBnb2luZyB0aHJv
dWdoIHRoZSBub3JtYWwgZ3Vlc3RfbWVtZmQgcGF0aCkuDQo+IA0KPiA+ICMzIGlmIGdtZW0gZ2V0
cyBleHRlbmRlZCB0byBiZSBzb21ldGhpbmcgbGlrZSBodWdldGxiIChlLmcuIDFHQiksIHdvdWxk
IGl0DQo+IHJlc3VsdA0KPiA+ICAgICAgaW4gdGhlIHNhbWUgaXNzdWUgYXMgaHVnZXRsYj8NCj4g
DQo+IEdvb2QgcXVlc3Rpb24uIEF0IHRoZSBlbmQgb2YgdGhlIGRheSwgdGhlIHByb2JsZW0gaXMg
dGhhdCBHVVAgcmVsaWVzIG9uIGhvc3QNCj4gbW0gcGFnZSB0YWJsZSBtYXBwaW5ncywgYW5kIEh1
Z2VUTEIgY2FuJ3QgbWFwIHRoaW5ncyB3aXRoIFBBR0VfU0laRSBQVEVzLg0KPiANCj4gQXQgbGVh
c3QgYXMgb2YgWzFdLCBnaXZlbiB0aGF0IEtWTSBkb2Vzbid0IEdVUCBndWVzdF9tZW1mZCBtZW1v
cnksIHdlIGRvbid0DQo+IHJlbHkgb24gdGhlIGhvc3QgbW0gcGFnZSB0YWJsZSBsYXlvdXQsIHNv
IHdlIGRvbid0IGhhdmUgdGhlIHNhbWUgcHJvYmxlbS4NCj4gDQo+IEZvciBWTU1zIHRoYXQgd2Fu
dCB0byBjYXRjaCB1c2Vyc3BhY2UgKG9yIG5vbi1HVVAga2VybmVsKSBhY2Nlc3NlcyB2aWEgYQ0K
PiBndWVzdF9tZW1mZCBWTUEsIHRoZW4gaXQncyBwb3NzaWJsZSBpdCBoYXMgdGhlIHNhbWUgaXNz
dWUuIEJ1dCBmb3IgVk1NcyB0aGF0DQo+IGRvbid0IGNhcmUgdG8gY2F0Y2ggdGhlc2Uga2luZHMg
b2YgYWNjZXNzZXMgKHRoZSBraW5kIG9mIHVzZXIgdGhhdCB3b3VsZCB1c2UNCj4gS1ZNIFVzZXJm
YXVsdCB0byBpbXBsZW1lbnQgcG9zdC1jb3B5KSwgaXQgZG9lc24ndCBtYXR0ZXIuDQo+IA0KPiBb
MV06IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2bS8yMDI0MDcwOTEzMjA0MS4zNjI1NTAxLTEt
DQo+IHJveXBhdEBhbWF6b24uY28udWsvDQoNCkFoLCBJIG92ZXJsb29rZWQgdGhpcyBzZXJpZXMs
IHRoYW5rcyBmb3IgdGhlIHJlbWluZGVyLg0KTGV0IG1lIGNoZWNrIHRoZSBkZXRhaWxzIGZpcnN0
LiANCg==

