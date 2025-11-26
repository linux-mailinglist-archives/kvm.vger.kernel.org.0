Return-Path: <kvm+bounces-64769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF3F0C8C372
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 23:28:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4EEA33ABB41
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 22:28:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7721F319875;
	Wed, 26 Nov 2025 22:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VacSGPUh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737762F0C46;
	Wed, 26 Nov 2025 22:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764196124; cv=fail; b=RgyDD2dxxFzQTjMtaUDQ4MQDFPNFr4Z80Z7rD+SM+Yz1jtxK4XoroG8pWXLgEOFfov7sJj2fdQmY1k/WvqjYBDdQ6c4KOzor3w+h8O3vcQaJ02Sg4TTpnQT5jKLchw0AOssg6H/KpMXhsR8nRBOGZpLgMRuL0UylFvsojsGPbTM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764196124; c=relaxed/simple;
	bh=OvwC3TAAe+8JzP4f1zCRJ06PXRmggDhgndyFzVZiDmU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kjndEaVhErKO6aptnyvn9RTCJcV4mZE+1y05EZLaiScCd0F79vpfh3nZK7UqCpYOFdPsDTdXAcktgNl2TNJXsISFrYZfmL3aWwk2iu+dl1xGtMsjItfBmetpmyj8P7le2uisxomRsDjONFLH2VTe7ZjWYf4i9IeJwYKCU5R5kXk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VacSGPUh; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764196121; x=1795732121;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OvwC3TAAe+8JzP4f1zCRJ06PXRmggDhgndyFzVZiDmU=;
  b=VacSGPUhZCYzXxtgnrfbkvfcsvx1p5/fSkcKArl090S7sKvp/dj2+lEx
   hntLN830DjYciwiLbtB6Y2nPSiypgGPJh6MFyWSBqgOUw9jOKFEqplc8n
   DAMWuioBp/gcu/eFG5SwDeHHjc7/4j/oy1gA28yebzXQl9zUUlag/5svR
   OyvixEne1pasH/xpI22ecK65C6DqO7SE3ZJmL6vU1SBPp7OTwL+dqW1Aa
   Dq35EuIpjsyWOCMSMgaqXSfVAJ8Z/7u9AvzTD1AnyUfyBrbzCOi+E4jYN
   DDfxFt5syeW43eLyODDm9e3X9GAxXPQTBit0pZs91RQV1fZM3ZmlX4yTY
   Q==;
X-CSE-ConnectionGUID: owMcXjnnT3Ke6OdA2lBfKw==
X-CSE-MsgGUID: kNMEaFXlReeiBn7Qxnp2VQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11625"; a="77716905"
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="77716905"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 14:28:40 -0800
X-CSE-ConnectionGUID: +APh2nyKQByMG5q/Ovykaw==
X-CSE-MsgGUID: AviGHSbrTTCe0B1TS8PN9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="193519952"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 14:28:41 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 26 Nov 2025 14:28:40 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 26 Nov 2025 14:28:40 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.54) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 26 Nov 2025 14:28:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=REJ2JnD9BzbQZvyivuyTn+AVW/+X9GkVKw1rlRX+9wnNdl0wLm3V1X8MFKf/YL83k6QreOcHkw9y2/wegKNpYFDjN/rHc4oleYN4LSQOVppHrMmArzW7ONdtVaeBlx5mdCZrb9B7UOD/hz6Fse4g8pBoZPffCwml+6JlxExLhv2ciaybfeeD7d81WTK8UVjVh2d0WEKxfpZqqwd4OLlG+RcR4JVZWyxBc1xuUHF+qnuTJT9x7CJ18EF9P6jm/vajctvbkDHC7ZkFujw6hxNP7NXCSLuqOXttqw7aeW5GOO7ehCE/kOXmyJND8ixzCgJyTG7LiQ/GRhxIhOH79zNt+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OvwC3TAAe+8JzP4f1zCRJ06PXRmggDhgndyFzVZiDmU=;
 b=k4fvZ6Ouj6epyiW+YYGi406T5XpK/D61l+m4hS98HIRA4otw81x1t7ndXna74YHIh5jOctm8BFUkdEhErzpbfjJA5+cX3NqGWCfLAb3SXbnHoYkRQklSVBzgwZmLQrK/zdBA0aANYE6XVypixOzitlTGFeAhTh+RJwnAl8dO2YPlOchF08A5rAqc9M2psC/B7DK77p0r6te5zITmOYXxaQW95/TY1B0lGIaJjXSRjFNVruNvNeqxNPPdNKs7kg+8AurFHuxfBeSSooWHz9zHnSB74JDJFAnSgThkUgGtFn+NDSkhwNBq0dBW0c/9Wlc/ypNZBXkcTZEyVwbf5PKC6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH8PR11MB7046.namprd11.prod.outlook.com (2603:10b6:510:216::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.18; Wed, 26 Nov
 2025 22:28:30 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 22:28:30 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"x86@kernel.org" <x86@kernel.org>
CC: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v4 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Thread-Topic: [PATCH v4 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Thread-Index: AQHcWoEIh3ODz6GbaUW93Yfuwe0KJ7UEMN+AgAFiGYA=
Date: Wed, 26 Nov 2025 22:28:30 +0000
Message-ID: <e34e8d1f039788fef8e993bee29b2b45bf8913ee.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-8-rick.p.edgecombe@intel.com>
	 <c345d734e111eb0c3a98dbc517ed25071852106b.camel@intel.com>
In-Reply-To: <c345d734e111eb0c3a98dbc517ed25071852106b.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH8PR11MB7046:EE_
x-ms-office365-filtering-correlation-id: 7d673cc2-a857-4546-f751-08de2d3b2084
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?L08vV04vMkZEWlpLaDRqMDdMYVBOdFpoS0RGUU9ES0FVMEVVdzBVZzJBbGpv?=
 =?utf-8?B?ZE1BYlVtS0ZIby95NFdLTTJOaDF3MVVvd0hoUFVxK2cya29ENzNock1sc05G?=
 =?utf-8?B?QVNIR3dJdlBWanVqMlNjNlQ5K25iZTBlVXFTakpGRE0xbUVPaTh1ZVB4NEFo?=
 =?utf-8?B?ZGcxTDlreld6K0pPblMzemRHcWZyNWp5QlpxZnpFV1RJT1JrZHg3b0M0OGdV?=
 =?utf-8?B?MklwRFdwZmFERTZVdy80STNKN2tlblNYVUJoQ3p6TW0vSkg3L1FIenR6SDRa?=
 =?utf-8?B?dDlZTXJMR2RGZ3o3YkxWYit2dkJPazJIdWNCcmRCc0JaQVpPZzZPV3JscEpj?=
 =?utf-8?B?Vi9GRkJmUzUwd2tSOExVRGNjcHdmTmpFSGFUYzhtMTZDMTJXT1N1RWpyVW1M?=
 =?utf-8?B?Q0NLMnJ3OVhYRnVWTGZ2aXB0NHA2T3h2Qkp1K0M2SmQxaU1tQkVYK0tETDFu?=
 =?utf-8?B?eVRnMExjU1N4VjNKbDJSSitZR0piL2ZsK09ETXhVY0N2WmV5SkM5UmVWeEpZ?=
 =?utf-8?B?L1NCb2dDazhrYytJcGhZWVhFWmdmYjdjNGlkYmo0YnE3NjV0bEFlYVdLT3RE?=
 =?utf-8?B?MVRHMWFocW1Ra3B5TElzeWRhcFc1dFVWQ3QzRGNRNTg1ZnFhaXZ5dDMwVUtz?=
 =?utf-8?B?ZFhyOG1LZmF6RjhQSXYrRWNGOWVKWFR3TERqM3pPSi9RVGxxdnN5ZmJ5M0pH?=
 =?utf-8?B?bVMzblVXV1I2dXFFZUNtQUdYdUpSMU8wcVg0NnhUTHRQOWNHVG53VmNIQXZs?=
 =?utf-8?B?cnp2d3Zzc3FxOTBrYVREeWs2aFZZN1NhQlBlWjVVcUh3MTRETjBMTW1ydW5a?=
 =?utf-8?B?SFF1QXJNYUsvbkgwQmE4eWs2SFIxY3hSdm1BOXk4aW1jZlBzRVVORThSWUta?=
 =?utf-8?B?U2hRTy9BMlVZWjlya2ljeG54bjkraW5YN3VIbEU1RzkybDlVbnJaRHgvTTRX?=
 =?utf-8?B?ZkxNc0MvOEpuQldWcHpFbkh6YXlNa2E4VjBvL3IrdWJLQXBPaGwzcGdoR21U?=
 =?utf-8?B?Z1lQWE9BMmVqR0tDWGFmMlZqSDNGZGxFRHBiUFVmai9oN1VtcUlzTTYweE5W?=
 =?utf-8?B?Y2dLK0kzYnpMUm5RVy9sMVRXNEhnQjY2ZnhNd29idTVKS0I5SEdNYi82UDBz?=
 =?utf-8?B?NXp0a3lyaFZFdXBmOEQ2RStaazIxVTBQUC9aRmI5aWI0Sjc4Nmd5L0lhS2N4?=
 =?utf-8?B?NnZ4Y3RFYklkZGErb21HcEE4QkhRRkhxZHJJc3UzK3BTL1NFOXp1UUdsMndx?=
 =?utf-8?B?MVZGeWhoWmIyVEZkZHZSM0FGY3YvL1lTdHdMWDlRMHlnVS9VZzJVaW9rOUNu?=
 =?utf-8?B?K2QwRjZjRThIb201d21NMHJIL3poNVB6cy84TStYYUJHdDRzKzhnNXdJTElI?=
 =?utf-8?B?VnZ4L2lmY3RUMlZkY0VDamdUNjUyRHN6NkN6M2haT3V5N1pVZHV3eUw4Uytx?=
 =?utf-8?B?bXNBOWRnMWgwQ3NIMmZlNzlxRUQ3UTNNKzk4TGZEellVVktNMnF3bms3WEtL?=
 =?utf-8?B?MHdHSzVOcmkwVDB1aDRWVWZvTGJOZGFuQkRETVZGR24weUx3eGswNmluckZw?=
 =?utf-8?B?bWNYY3RsMWZHdFl3bGlYQmtBclJLNTFmNUczQW43MW91MEtEcSsrUTZ1K1Bw?=
 =?utf-8?B?QklGT0x1NEgzWnpqZlBkUXBKamExRTRqMUVTWVU3ZFBzTnFGVlM4UmhNRHF6?=
 =?utf-8?B?SW1FMGVnUnpCZ3VNKzdvY094VVYvcmNIeTk5QzZFQ2FzTUtZeGRHRHM3cVhT?=
 =?utf-8?B?dk52TlR0a0dMU0RrZmVldWNZdHFkbjgxZ2JUOSt4MmRTWDlrREFabDJLdTFt?=
 =?utf-8?B?V2hDSVRMK2ZTWDhlRlRDRTdocWtta0h1ZE5MdTVmcnJ1aTlTbTFvUlJqMDFK?=
 =?utf-8?B?V2wyS0ErQUZmT3Awb0RmcmprcGwwSjZ1TTdjdTVub3NFQzVrY2VlODd4Z0g2?=
 =?utf-8?B?d1hXcFFPQnRzZTJNWFlQL1Aza25VT2NKbnFLWkNsWXNjQ0xtWHNxRnpVemNE?=
 =?utf-8?B?YnBSVWhPbnhCUTM0SkZGdkZUM0lNWXAwWFNWbGw3Z3lrWjFWVENqRDBNSDNt?=
 =?utf-8?B?ajNvNFloZnpvVXQwL2thMFZJa0ppQi9QbE9Odz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ek1sYXVvMkJqVndpMFN6eVhPbnZmWC9iNkx0a2diQWNrL2RhaTRkQUZ3TVhl?=
 =?utf-8?B?SEdQMnlRWE5EcG1xaTZsMFNFbDRuREpVL0FVNnZWTnRrdnZrT2kwZEtac2cv?=
 =?utf-8?B?d2VQa2kvYU5OREpBQlZPa2UyZVZJdjlLYzArSkdRVCt4UFZQbHd2ZjZFQisz?=
 =?utf-8?B?djljNWFDcFFqM25PNVU4SHZIOUR4cW1udUcvRDJJaGpMMzdyVnhCeFdUdklu?=
 =?utf-8?B?ZjQ5bENlZGx0a2NtbEtKRjVvMHVMRHBvQzMyL3g4YUhpQXJhY3dtV0VxTytl?=
 =?utf-8?B?SWMvYmZ3ZlNkdFRZVGFBN3p5MTFkODhQNVVYYktScytpMjNUTFVqd3kvYWlW?=
 =?utf-8?B?bUg4RmJ3c0hFa01lbkNvOHZ1Rk8xZ3l0Yllrenl3c0M5OTBjTWg1WGdzVEVr?=
 =?utf-8?B?aU5NOG1XbU5aTkFIeEhETHcyV3liUTdwUmhHU2FTV2lxek45Qm1VTXpzd25M?=
 =?utf-8?B?enluV0RmNXZvRnJCZDRISTFsdUgvLzlaSEdrUndYNG8wakVxUUtxTjc1dnAr?=
 =?utf-8?B?eityQkY4YVhtRnErUlRZQnM0WkhNZmhQemNvYk0rWWZFeEowUFQraXlaem80?=
 =?utf-8?B?cVlzSnZtd0ZkRGxTZUhha0tRd2tJeEZBVmhtSE5mS1JCYi9haVJaR3k5VEhT?=
 =?utf-8?B?RE9mTzlpZ05pVjRhempCOEZMc2pvZlFJcGRXVVpJeVYwckxyUnlrekJFV3pK?=
 =?utf-8?B?dzBBWkRqanNCejRJQkxWYVA4Z29oSmQzOVYwTFM0T0tzaUkydlhKYTVUc2Mx?=
 =?utf-8?B?WW5BRWY4Ym1tTWMvVDNNOUp5bGsvcWhCV21yUE96OGZYckRFdEtySmFib2ZN?=
 =?utf-8?B?cDk2OTNVbEZRV3N3bXJkV2YxemFKV1Q0N1cwdW9BVHdESU1DSjRjOXRGSE9y?=
 =?utf-8?B?VUhpbCtGUHcyZTRMcnhRK016bjR1N0RYNVZiTk1QM2J4c2NoM1lVNHZucERu?=
 =?utf-8?B?T2hIbFVwVlFhY0Z4RVBpMkRQdnphZDZFcCszWUgwZUw3R3dRam1VZG5yZkZB?=
 =?utf-8?B?T05KbGJqL2lLVDN5b1d4WnVPMHdmZUsvK01LeUN6d1JZWElxell0RzdaZ0JJ?=
 =?utf-8?B?ZzVOSWRHTUxtYUl6TmZRYTNvUEltY3F6cEZTVVI5Tnp1VmFsNEhNdG0vVXNN?=
 =?utf-8?B?UjRpUXk2dXVGY2tnL2djeUlZdTM3Kzlsc3p4RjZqU3phaVRsL0hDYUlhdU9i?=
 =?utf-8?B?b1JNZ0RwcHBYdHdkaTByWmNzOEYvQ2hndjN1S2NIYzZ6dGZ3SGdUenkxOHY5?=
 =?utf-8?B?YUxETWt3N01CakhCUEhPc05PMjlZV2RBTXNkdm83RWF0aE02ZU0rQ3AyakJw?=
 =?utf-8?B?b2VaaUdDYXg0NkRaWFdnNGROMzZBWmJqc3JvYlE3c3M4bTloVGFsUk9Jc3JJ?=
 =?utf-8?B?SVFXTnhmdklpV29DVGs4dEthL1grMlRkcHFuRHFRbjlCSjlhSm8xZ3hIcm5K?=
 =?utf-8?B?VnVIdW0rWnJMVzhXS1RvckF5M2N4S1hZV3VGN1RhMlpFdHVtdVZydHhudjBi?=
 =?utf-8?B?UzFYK0NadkFHc3lENWcvazJEWERqSk4rN1N0WTgvMWprOXNLWDY3ZHcvWklI?=
 =?utf-8?B?azFmU2R6ZnAyd05pY01zd2VKSm5CbXFlaXRKVkRyT2lsTTE3QVdPUllYdFhV?=
 =?utf-8?B?bFk2c3ZNUG0wRk9uNHhPakxtTG92NFA0bVBqK0swVHFTOXlNUU5MaWJxTkVP?=
 =?utf-8?B?WnFRNXJmNEdHcTNKVUtGNG4yNlhoVXkxS1ZJeC9yRkU4VUNFQmVaZnNIa0RF?=
 =?utf-8?B?WldYTmh5c3Z6VVRKUTd1RW9GaG11anNkRGxSa1ZEZmVCRjc5bTd4TzJSeDls?=
 =?utf-8?B?YXl6dGRrejVNQThhcUZZMS9lakpKbi81N09BenR3cFNKTFM3R05tM2REb2l1?=
 =?utf-8?B?NE5UOFNmeGZjeHNzMEdadUU4azJqWFpiVnR6MVhSYzdkRmJrUWtYRzFDc1pG?=
 =?utf-8?B?Smtnakkwd1hZQ3krUnIxVHJUZ3p6eUtDT0xQb2tHaXc1SkxDT252ZGpaRFM5?=
 =?utf-8?B?V1FaL3lSSGU5Umt1cHlPNVVZL2c4Z05hZlkxSEVKUmsxbFNQWVhNSVZWSFZa?=
 =?utf-8?B?REtaQVFZNFdrMXg4eFBVSWR2aENrQTRaMDdMNTVJckhjU3FIdVBzSlFtZENo?=
 =?utf-8?B?OWZVSHFJd01tUTNncm9GWHBVdkkyVUh4TXFTdlZBVE9ubE9HOUtsVXUvSTZ5?=
 =?utf-8?B?dmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A5D4244C00C2AD41B69B8A0A7A84C87A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d673cc2-a857-4546-f751-08de2d3b2084
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2025 22:28:30.4719
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MveKjjH7Lsw2bf2o3zt0DxLY7cRsdpnvhriA1AI9TnmAB/WuRwfztypSt/x9yN4/TkvWBp2XU81ipViMIh7tMH7VCsfSnxN1mPct97E42gk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7046
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTExLTI2IGF0IDAxOjIxICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+
IMKgfQ0KPiA+IMKgDQo+ID4gK3ZvaWQgdGR4X3F1aXJrX3Jlc2V0X3BhZ2Uoc3RydWN0IHBhZ2Ug
KnBhZ2UpOw0KPiA+ICsNCj4gPiDCoGludCB0ZHhfZ3Vlc3Rfa2V5aWRfYWxsb2Modm9pZCk7DQo+
ID4gwqB1MzIgdGR4X2dldF9ucl9ndWVzdF9rZXlpZHModm9pZCk7DQo+ID4gwqB2b2lkIHRkeF9n
dWVzdF9rZXlpZF9mcmVlKHVuc2lnbmVkIGludCBrZXlpZCk7DQo+ID4gwqANCj4gPiAtdm9pZCB0
ZHhfcXVpcmtfcmVzZXRfcGFnZShzdHJ1Y3QgcGFnZSAqcGFnZSk7DQo+IA0KPiBJIGRvbid0IHRo
aW5rIGl0J3MgbWFuZGF0b3J5IHRvIG1vdmUgdGhlIGRlY2xhcmF0aW9uIG9mDQo+IHRkeF9xdWly
a19yZXNldF9wYWdlKCk/DQoNClN1cmUsIEknbGwgZml4IGl0Lg0K

