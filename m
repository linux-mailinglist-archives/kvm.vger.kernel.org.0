Return-Path: <kvm+bounces-34205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA0FB9F8A5F
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 04:05:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 663947A11FC
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 03:05:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9B8B2943F;
	Fri, 20 Dec 2024 03:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VOcoEnes"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D99B6F06B
	for <kvm@vger.kernel.org>; Fri, 20 Dec 2024 03:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734663905; cv=fail; b=Ees8e4Z/l4QyHhjpueyfL31m9EldFQ885RRnUu7+J3HZFJwqDUXk3A2sBb3e9NXELnmjIly4Tzja2msxutb/IPF0lU3Tqrap/kfo/clKHJ6oh3rDmkMz09HhXDbT6P5Yu3yIHSrZ6VphWxMjx6rym09jtvmSZIWrPcnutfJJcpk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734663905; c=relaxed/simple;
	bh=hxFKvu65TlXLVA4psYeiWGFh0kqCjWelTweDXU2ToZo=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ubuwn4JS6juSzSDNPtHdklmTfNP1h5iOu6huRiRJWy0nqCj5DjOG/KnNSQJrj2e9SHV1TcRtEF/Oihejpc+sybhCDkrqkKjB5odfmap9HRVKkY6jFgww6ts9Bf4UixEeziD2W5u9dttvjLF/XPnozEoIOxKb3SZheJW8pQOkskA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VOcoEnes; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734663905; x=1766199905;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=hxFKvu65TlXLVA4psYeiWGFh0kqCjWelTweDXU2ToZo=;
  b=VOcoEnesBiDvrbjLus17eG5vwqrMcUbVVzm6SuTDhGuh60y2o9hT79g4
   QPQ+RgWllVuOgqFriIZSiNKi9tdYD1wDuDpcASLMBAMX8W3YepPawlmWh
   9+eiC1lrcJZqitTT+gfCXwaJxCYVJSNBBWam/2i4/ClkSg5n9Bnuf+KU+
   efhswCLlY9HoS2qSKp+ZbCRp/cfSmZdf2jzJuP2NcGIurBjJ73TIHI9//
   g/DQ1Ofe3wga1Ry3VRzZEUT9jZpiViD8x7SCyPwgyhmNqhyEuuJJCQhuZ
   s9W4ze6lgJXcmik6PaAGGPTWiKaGIrCw0M43KaPKdSiDluN+gj/+ln2xx
   A==;
X-CSE-ConnectionGUID: g6UPol0BR5yaOiLXzJfotg==
X-CSE-MsgGUID: Vg0rB+GdQkC8+JTWoHeXSg==
X-IronPort-AV: E=McAfee;i="6700,10204,11291"; a="35354077"
X-IronPort-AV: E=Sophos;i="6.12,249,1728975600"; 
   d="scan'208";a="35354077"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2024 19:05:02 -0800
X-CSE-ConnectionGUID: LSmkDkfaRBOx7UN5MakP6g==
X-CSE-MsgGUID: 46ZwUL9US7ar0z3hGwfgQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,249,1728975600"; 
   d="scan'208";a="103371199"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Dec 2024 19:05:01 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 19 Dec 2024 19:05:00 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 19 Dec 2024 19:05:00 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 19 Dec 2024 19:04:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yZMlAheCAXlGMGzHCjxPs1s6OvEnOhENHiG1VkIgqnYMX3RUVRTP3e/5iu2z0+7ByLGi1h+DX8pXB8gGA4vxdmAc78DMDhTZWU1IFCrjSzsOGIZkbC2qpns4idQxLCRBGh1KP6zp7PC37F1DRAxVx/LqJ73hj71U3DBzLR/F9ldWpwToxxF5PAXy7+Yb7XINbub4Rar7GyYGxin+42xv/PKLMF26cWfX2XvyTrBYyBasF4exmFt0IPjEpXyJ7xnLtnsVRFEG9F9tSOR+A0wjF4Y93ZrYuGHbuZuA5E5KY0pbLiV3i4mSBi98gQkw461eHmwAz4yxnz63kJmoOghIww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hxFKvu65TlXLVA4psYeiWGFh0kqCjWelTweDXU2ToZo=;
 b=vFR/c5N8O/D7xhDjxat92v1qyWCR0PXHZiRfGeUtUFW+F4u/0NP5vg7IbI9lXd8YF5grbQv1bO17lzAmO648HQNhwQw8w63OUPlMK4Xrg0tsLF68kdraXArTPuANBrRI0FbZvtnHQSKp7a2XtlELFBljAiFqzXoQsByHhbC7uC/2HhTAfD+UKaYoUu+ASJTXjagYqAjIDw5FcT/20s4U4QX6CBxEyOf9lWq5tBdGOeUi8NAiuKqvp7OO/2QlCTbtf7ZnPdMA9UxhW3jP+ME/jRs7HdFaVnww2uRhLeKH9fDcCtGIr8CIhK4Ovb0kpiaWoLNIhuADpE0NG6SmdVX81A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB7494.namprd11.prod.outlook.com (2603:10b6:510:283::18)
 by SA2PR11MB5131.namprd11.prod.outlook.com (2603:10b6:806:116::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.16; Fri, 20 Dec
 2024 03:04:37 +0000
Received: from PH0PR11MB7494.namprd11.prod.outlook.com
 ([fe80::353f:c8a8:2933:d288]) by PH0PR11MB7494.namprd11.prod.outlook.com
 ([fe80::353f:c8a8:2933:d288%7]) with mapi id 15.20.8272.013; Fri, 20 Dec 2024
 03:04:37 +0000
From: "Chen, Farrah" <farrah.chen@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"Hunter, Adrian" <adrian.hunter@intel.com>, "Lindgren, Tony"
	<tony.lindgren@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>
Subject: kvm-coco-queue regression test report
Thread-Topic: kvm-coco-queue regression test report
Thread-Index: AdtShJzbhWp7BnzRQWGuKi+hmX9CaQ==
Date: Fri, 20 Dec 2024 03:04:37 +0000
Message-ID: <PH0PR11MB74940D6990698A7A93DEB1B5EF072@PH0PR11MB7494.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB7494:EE_|SA2PR11MB5131:EE_
x-ms-office365-filtering-correlation-id: 0736080e-0477-4dee-0559-08dd20a309fd
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?26pNp0RgwD9pNQkrLI9cbwntg3xuz8nB/Zbh8CQV9RP68+uH65Bm/MY32kOx?=
 =?us-ascii?Q?m9hVHLl4/bRIs3XDU0JHfj2izTj1DgrTcJhJz3SeSfbYK4Y/N3N54dKRMPKK?=
 =?us-ascii?Q?LnsAD2ti40pOkMvwijyUc0eQOG/Vx6h07+DohJnula0qy6QsJSNt1TBxIcoL?=
 =?us-ascii?Q?nDPun+nhWCshkfQCvEGxIdF1ddaWYaErzV0UjT9nKppwHFveMIkKQ0w4AGfW?=
 =?us-ascii?Q?6Ii0ir0KcnOt8H8XdroSyIosADb1qNXmlFYqCLckP0G4o7wBehmIpVYv8lXK?=
 =?us-ascii?Q?TwOsPS3J9/QSGYsMg1C1gJm4T4VBiSV2JhCC5fLBNXo4MMMBXli+EIcnfUPc?=
 =?us-ascii?Q?OEm6QbbEImPGdkor0RRIKrB7i32HV4qc4ZAXAqvYlaMG85a5f6RnGQ16AAfJ?=
 =?us-ascii?Q?Hh2s+WSgxMMsu+9a8Am4JYOYKp+HRZr4wob+zB3bLyXFSbSRG+i+4p0UlZhx?=
 =?us-ascii?Q?kQZQQlHHLxnUC+c5fdmtyd67P87qm6tFRCP99uHH8FftYp1MN5P8w4kCRfjS?=
 =?us-ascii?Q?BKWAK22cEWp8FSJS1zrsQ23gGrL/IdsFxkbq42INQnJ1k0FjIz1XbAAtr0xS?=
 =?us-ascii?Q?Euhhy6YKDN2kJ0Lp85loxl8rd/SvgSqYZG+qFFgoI4/LF2Cn1x23UzmctIKY?=
 =?us-ascii?Q?lxPFZaQV+7z6CPL7BZeP7BUR9zapDLkbXIENYosnlKB+l+JH0xx7t0UaX2kF?=
 =?us-ascii?Q?LHmNEmVdCTKVZ1So1qCK/j5Up/VNgz5hYJKSyXkov4ovwfWcOXgPwt9Ep6Z8?=
 =?us-ascii?Q?kR7pTlBF0ahAZlIKHcBDPAyqcNErE6xyMhaQRdO1stDA/NI4N9wxAcciUCwK?=
 =?us-ascii?Q?sziQoNDKxm0hHZbn0dVxeQhy66SGQEpZj3oNcLG9aJlMr59Lz/cDpx1GaLiA?=
 =?us-ascii?Q?kwr3a+/SYp9pkz9ZMu0fJUdWRg1b/Ki8v3X6zBN/i8z0GVFPIRCseTK7mcAe?=
 =?us-ascii?Q?Vw/5br1siHgZtSOOqYEgX2U9DChQOy20AnHUz5wIi1Ricd33oZZCeomB0RVp?=
 =?us-ascii?Q?PMfnt5SbsYP91A7UkmZ0dleeBNGfKam6D5AacB/216MpbALO6wUiSgij8pC9?=
 =?us-ascii?Q?dX84E+dmriaOZ5bduecOGAfhoBSZUz11EvHqRC19bJ72QacZdgfhzG0MKpd9?=
 =?us-ascii?Q?EDVaX4oW8ehKae+Bv/C6fv8QN6SSNkr4fs67aY2ZU1RAaRtOweg6Pf67fAJ/?=
 =?us-ascii?Q?+Yx56pz9o1e1CQ1iC9tn9VPncPQxtGusHjliH/szmC+14T7VTwMqvWGHuzbt?=
 =?us-ascii?Q?AUEfEWPwS+0AuGz3ZRDOQZaI/p7M6FOe05w+6YbCg/I5lrMwCJVjB+mr55WD?=
 =?us-ascii?Q?PanqkzfB/KHo5KdlNwDJyP8jH87WpcLOhVikzBytOE0+HOJmEoYB6M921poZ?=
 =?us-ascii?Q?uFpKKQztnqvCY3Rxv0oZURDuiZhsEQcXH4H1trRYom9zzBkqhicI7yGb5gWP?=
 =?us-ascii?Q?QLdknxFg2IZx2E854HtzU7iy2vA6McqDY97W7Sz/dQKxoe2uyIQemg=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7494.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/6Fns4PwBCrtssjjS/tuJtXjXMv/2iDil2zLLCaEaatK3AUhQz9yWKjHTa5L?=
 =?us-ascii?Q?uaEtzxcRECSF+Vsv4Ifh9+LiJkR7LMOcepRa6ISXhQ5+/isIPF15YgMr31HQ?=
 =?us-ascii?Q?hBRoXwPTFOJXRnq0sBjkbfOiQKznwLzkzhHm3oC+uhHryi4J1sapCizAaUdd?=
 =?us-ascii?Q?bsWEPUOUDToPPZ2bXN6DelkWGZ4ust7Cb8cZ8a4j6svUSeXHhjGmGzokBXqI?=
 =?us-ascii?Q?Yp3BO2eMI6dxb5zedTK1nEwYydEqe87hWOJnU+0Ch/HriiFGfYSl9MwJczNC?=
 =?us-ascii?Q?o6GGinDQn/OkpMCHTG4GlSgCMUc4L97slaqH4kIEFocTRnu5TzpuLwAFZIdj?=
 =?us-ascii?Q?7I/B26RcLeFxBw2h687f1WYANCL13gcFbhzIa7R9dmW6Dw0OwOl8+/6vFyY2?=
 =?us-ascii?Q?uVa2ebmTtGuj8qKcY7jQjL5vOixVKVBlEhfe3ThKdXVZJcweK2LX4UG1K+Rw?=
 =?us-ascii?Q?NWMZAdqU6NXgt3fPiP3N6sILIOUye6ryCf+UkeR5bTricF2RVlbDi4Tv0mNd?=
 =?us-ascii?Q?usZOuHk4pyLYu0Ce+Lp8rpriHLFtf2hkPY392XL63CWFBpjHeF410FFZdSFU?=
 =?us-ascii?Q?ijSsUxpdIrTcA/CTtANQ1ZxT/8Uqg6S3SuoNsFNpKCHeuD1E0A7TNPa47oG2?=
 =?us-ascii?Q?2EKc7Xea5cFpwkl88UXobeS8wAFvG6kLn5sPCGtirEbXjIJS1yIHlHDY5Jce?=
 =?us-ascii?Q?CEAfKkTf3hVXzDV+gnLPwNvRp9qtWHaO6/ShNkGQfv+I5lt5SuAXvBx/XXfm?=
 =?us-ascii?Q?1ames4r35ZBzVGUejj1LCnr6VpOIcqu9PN8xHORJCh5XOd4d6LoGliA1UOWH?=
 =?us-ascii?Q?mSYSAQXllxGbM4U8/cltslStcjaoX5pqg9vpYStyamoE21U2QYW+12Pm0SLv?=
 =?us-ascii?Q?QNWuCOpSCGRxAAQ57dTfT8aD52kd/oUWQ+0D0NTdCu0H1B3xquPJomTkOP94?=
 =?us-ascii?Q?vsxLYTKPQsd0JCQrk1+dNg/bg540hCVOOwclUWuE9RDFaU1IqRJypTQoo3WV?=
 =?us-ascii?Q?o7i8LzrMBmphZxR5vx39mLijaTrNXbtdN5bvd8FbJgu4iFXjcHSN2gdN5fT/?=
 =?us-ascii?Q?5Ycvs7Y6TgpE91sG0YXeUBIyQ9n611Ays+GUhKH9ofzgs9abbZuGYt/qbPRE?=
 =?us-ascii?Q?tGrBTCeLRLGIDoG6KmjA43544gvtAcljHo6RDcThhN5oTPBNSJAYT+FbZDTQ?=
 =?us-ascii?Q?vwYlGmzeD4jh6l1iQHf7CTHAvavZ/pEaqElcYDmqY+RAqTWpvyCaKN5EBWo/?=
 =?us-ascii?Q?g3ytHZj+l/P+Dj/LkZqJhN5S65QdCZ1/iGSSYsi7RhidSMBLzgc/axa2f7y8?=
 =?us-ascii?Q?VstdG+91QJdmw9TCSTRWsYsIE5rp1qc7IMrkN8IQ1+hSTgo54+nnUma4j4nf?=
 =?us-ascii?Q?vwtesXqcCnYZStfBeW0WIpPu6Pa1aZVzpSGaxqFDCA6wBAIq7MxfpPGCu27g?=
 =?us-ascii?Q?XSfeJ6tSfF+pR/oYrMiFY5SR3fiogsdVW9yk5ZICrrpEKOD1vCd/5nGaXFYK?=
 =?us-ascii?Q?V65Ts5tHLZhitCxAN5kzpVjVt3ZuRmfxE7/SjC2Mzo4zVnx/Lafpsl59xBdK?=
 =?us-ascii?Q?ejkHsk/bx7gWya/94OVJ401o60j/S7gocE7iIcly?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7494.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0736080e-0477-4dee-0559-08dd20a309fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2024 03:04:37.5237
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5oH4/XLxtUyK9OEkBt0b7PhqZly7rFHJ7Vichyqb0Y5vV6sW/sSGHCOKX4iaa1JIv9q/Ot7giTyQJlIfxnaLag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5131
X-OriginatorOrg: intel.com

Hi

I work with the developers on upstream TDX support. Now that the TDX suppor=
t
in kvm-coco-queue is getting more mature, we thought it's the time to do
regression test on normal VM and it might be useful to start sharing the
results of our testing on the list. This is in addition to the normal suite
of automated tests that run in our CI.

Except the issue[0] which was already reported on upstream KVM, no other ne=
w
issues were hit, especially no known regression bugs in the "MMU part 1",
"VM/vCPU creation" or "MMU part 2" patches.

Details
--------------------------
Test Environment
CPU: Sapphire Rapids/Emerald Rapids
OVMF: https://github.com/tianocore/edk2/commit/cf8241faccc176dd857e5d42e84f=
3a2f0fc8d16c
Host/Guest Kernel: https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=
=3Dkvm-coco-queue
QEMU: https://github.com/intel-staging/qemu-tdx/tree/tdx-qemu-upstream-v6.1=
-fix_kvm_hypercall_return_value

Tested features or cases:
- Basic boot
- Boot multiple VMs
- Boot various distros(including Windows)
- Boot VM with huge resource/complex cpu topology
- Stress boot
- Memory hotplug/unplug, memory with NX hugepage on
- Memory workload in high/low memory VMs with NX hugepage on
- Device passthrough(NIC)
- Live migration
- Nested
- Intel key instructions
- 5 level paging
- Bus lock debug exception
- PMU/vPMU
- SGX
- Workload(kernel build) in VM

[0]
https://bugzilla.kernel.org/show_bug.cgi?id=3D219588

Best Regards
Fan

