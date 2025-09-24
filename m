Return-Path: <kvm+bounces-58614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C234B986EF
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 08:50:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ABAAC19C2D24
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 06:50:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06C84254849;
	Wed, 24 Sep 2025 06:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WkhRsP9U"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B381FDD;
	Wed, 24 Sep 2025 06:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758696615; cv=fail; b=uEG/b27vpD8CRAyK1cfHq7EjJoGSrTia8Ts8Ceb82gFv+0+Qs1RlOqwNykfpFEP6aDbqJ+l4q7S3sHZD+aVehwd8M3QMKZ+/Q9uJLuqAXHEIFpcNvmOI4M5rEeXeHp6cmSCsgJU2KCiU9dnhOR2xBEiz/E0vcJBB5h8PRHRcAj8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758696615; c=relaxed/simple;
	bh=jphSzEYBh5cjKZ+Y1ErYk1rsZQyXnw8X2AyQ4D81KUU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YhwmStPoRg9ilzxXxtleeMPbNdPd0q4WP64ZqjhWOfxqvkbL9XP/E1IeeqW/Y+9FMAHf7vuWtz3WgjlTrfB5VBkxznM+iI4rIbPeBAnFcBpXeEOAOko5Y+NFjOj03EFXQ9Sj5sqgDhl2h9ltm+ITO0EBZ7aYhvfAaUQign4IVFk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WkhRsP9U; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758696614; x=1790232614;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jphSzEYBh5cjKZ+Y1ErYk1rsZQyXnw8X2AyQ4D81KUU=;
  b=WkhRsP9UDDOutYyDkW4Mx/IQ1SHOD3m0lbEeMy6ELfRpinDYx0+e7kdV
   1M3CLvcvwzr1/3rYkpuwVbzuA7WNx6tDvk1ylRnYZVNjSjn/0nQyzMFbp
   gnzq8uLmaXMkD77hVOjgJ1yePxUuVTl7B6qU2Sh2K5WlyglIJPOrb+zNx
   ETh0b46MO7AGRPyejj5RkGycdDvh/hoAsl04mlYi/hMFytdWKr6c99D8I
   vTmGeB5zhw8Y2TDtaRphlDL/9usLObbsoK5BNmsl0/eJEQvuwW2VqfkB1
   0proxbWtp10QLGZ0YMp8EkufnXpa10lOp/XHfxa4Dut8zZr2oVD72wHxt
   w==;
X-CSE-ConnectionGUID: GngzQbs/TMC6kAqJWoIPVw==
X-CSE-MsgGUID: SeuJVljaTaujYtmUgor7XA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64792718"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64792718"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 23:50:14 -0700
X-CSE-ConnectionGUID: nYRT+/vyTcSEiILGUmr4Xg==
X-CSE-MsgGUID: s+B9NugwQTSVG7glmBGeRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,290,1751266800"; 
   d="scan'208";a="176563315"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 23:50:12 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 23 Sep 2025 23:50:12 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 23 Sep 2025 23:50:12 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.14) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 23 Sep 2025 23:50:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FDqb3O0EwTItN2i5FmlDCtI45vE98FUmOY+cPuunw6dZb7EmOqkVwMLfulLy2xSy9d4WleTogfF06KowllDuFAOYdOgZwngXo3Ae8DvQVkAcpIGkC+S5Qjx8mvqH/fzD0E3M5YZ8fJFPx8zDpkJnRpVE5O5CSNzZLEglSl1y4RFKHC6bE2/biJ9fZTeUSX2za48MINQVL77xwdn8joLSjc5/R2WRRMzKULMxq4GPJnPBuHbZ/UwSb1K056LLBTSJqOgiE+nF9qPUUi98W1qJ5I3A/yf0eP7HFHJqGCueHhmCS12QADvJENImzNDXW8rwwCfxG/qlQg3IOlTYbSpI2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jphSzEYBh5cjKZ+Y1ErYk1rsZQyXnw8X2AyQ4D81KUU=;
 b=Kaab+IIasfAZ9vMTd73nX4GVJu1TI+RVWPMSeBouHINJnglB311OizCN97RLvIMwGDBmABIdILlF/twcPFGLImUr3RHig3a5zyKNyBI8xf8UA23HjglVL6jQTDUGmMy89KQ9zrGhEXm2CYxKZ7tGmukr8rjDL08cs/lzZBJmwgDrtCoxDuq21r9VFIS0jkjZ7Sqi04BlrIOuscmp8jlp9pgaC/+krRQ+N5gQf3PY9ZkiOrcosyIp/wyi0ZgPNZmAF/NFat4/cD8A3izHzTtrfs+Qw457cA57A4rK046D114w2PrbnhhOB/f7bIpH5a8O2Orfe0jE+OB7Y/Ghfrznpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH0PR11MB5521.namprd11.prod.outlook.com (2603:10b6:610:d4::21)
 by CY8PR11MB7876.namprd11.prod.outlook.com (2603:10b6:930:7d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Wed, 24 Sep
 2025 06:50:09 +0000
Received: from CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::df20:b825:ae72:5814]) by CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::df20:b825:ae72:5814%4]) with mapi id 15.20.9160.008; Wed, 24 Sep 2025
 06:50:08 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Edgecombe, Rick
 P" <rick.p.edgecombe@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "kas@kernel.org" <kas@kernel.org>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 06/16] x86/virt/tdx: Improve PAMT refcounters
 allocation for sparse memory
Thread-Topic: [PATCH v3 06/16] x86/virt/tdx: Improve PAMT refcounters
 allocation for sparse memory
Thread-Index: AQHcKPM0s1whGFHeVUeSuikKt1/NBLSaGz4AgAZuegCAAWNMgA==
Date: Wed, 24 Sep 2025 06:50:08 +0000
Message-ID: <7ad102d6105b6244c32e0daebcdb2ac46a5dcc68.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
	 <20250918232224.2202592-7-rick.p.edgecombe@intel.com>
	 <f1018ab125eb18f431ddb3dd50501914b396ee2b.camel@intel.com>
	 <e455cb2c-a51c-494e-acc1-12743c4f4d3f@linux.intel.com>
In-Reply-To: <e455cb2c-a51c-494e-acc1-12743c4f4d3f@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR11MB5521:EE_|CY8PR11MB7876:EE_
x-ms-office365-filtering-correlation-id: 1ecdd413-2a89-45d3-d746-08ddfb369a20
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?bnR2VDV3L0NKVzhGdElMY3FxV0ZUS3hrY1RRd1FsdDUrNE91T2dUZEY1NVpE?=
 =?utf-8?B?dm1IamkwNXZzUlZhb0pMRzRzMGJEZHd1MmdCbGZud0lxYnJ3NExNeHYydEJo?=
 =?utf-8?B?eXQyT1p4UHkranFaTFZQR0hLMUVibW0xVzVwL3o3R283eVlFYmxVczREYW8r?=
 =?utf-8?B?NnhZWFl6bE5HRVFwcTB5MDR1WVNCTjNveFNMUjFBbG1HbVBDSEp5WGQzWVdn?=
 =?utf-8?B?WVQ0Mk9nN2Y0TDNPbitGNG1BVEhMTUNMTUdrdyt4ZlJXOC9ONXpFenFNc1Ba?=
 =?utf-8?B?b29UUEY1RVVmMzJHZVFMbWg4bEp1U0RZbC8vMEJhNU5aVkJOamhBQmtia1F4?=
 =?utf-8?B?RzhsaFJ4dGhWQVVrV3MvWE1ZSmpwRFNJVkJIOW14RkN5VzR5WlE0WWRPQklG?=
 =?utf-8?B?eVZzQXBKRXZZcU9MQm44OHorOHVYOEJzTHdoWjg1TXZCV2lYTUhIUFl3Y2N4?=
 =?utf-8?B?UEF2dVY4dnBJSHhqNzNIMTNtazRBbGNMZDRxSTBlUkRNRHFZNmJiVUtNa3JV?=
 =?utf-8?B?YlM2NlZYY2NsZlJCenRIbnNGUStmWTNJNGgybmE0RFRQT0N2V1MwOGFMTm5z?=
 =?utf-8?B?aWg1dEkzOGxmdkI4MVp0cFhUYjU2bHlqbjBVY2pTZlE0L1FRWFJXWW9vUHZl?=
 =?utf-8?B?SWNacXpwZnZaUmtjM1NGWU5QZDZmZ0YrSTJ3T0J3NHFnTTJIaXl4MEFYcER1?=
 =?utf-8?B?SVBpUWRMTTFFQ3g1dmJqSnFyNCtPRXBVTlNURUI3Zy9ReWVOaGM2aWlsMUR0?=
 =?utf-8?B?VGNZNzRPUUQ2RnlIajJBcE9KTS9Ta21NdEFGYlBCaTZSSkFFc3lDRnV6MW5W?=
 =?utf-8?B?Q01PR21wRzVRbUpIcjk2aXNpeHhFc0FqcXBoalErM3paZmpqZkwydzB0dUNa?=
 =?utf-8?B?TGJ4WTBFa1BkaTB3ZWhGcnhaaSs2OUpGYVU5NjRYTWRhT05vR2VZTGEzRFlU?=
 =?utf-8?B?RFVndWdKWVRIZWZFQXl3TFhJalF1MGhzd2RabnIrZi9UQU03THdiUTU1QWhO?=
 =?utf-8?B?c291Q214QlFDWS8xVktvODVyaXc0eDhPQndBVGtvWFlhRHR4Q041eWoxMFph?=
 =?utf-8?B?VXhTQlQ4RndIb3dabmFzTGQ2bVFLeWY0OGFXNGNoOGdoRWpNZEtWbDlGZFVZ?=
 =?utf-8?B?bHJVdDdlMzNScVNQRVBPTkU4NW1FeTJKTy9FWndnK1c4K1ZjL0ZmZnZvSmxX?=
 =?utf-8?B?SitiWk9wR2VjNk9RZmt2c1ZQMmJoTjVsd0VHbzg5dEJsMGNVMFhBaHRRcnNC?=
 =?utf-8?B?NGgyNHhpTC9DdWp4TG9lV0lGMXZnUTFNMHNweS9ma1F1MUFDQ25hbG0vQzZw?=
 =?utf-8?B?UEZnM0tNVmVBMEk5K3VEb2FKenlWc3o5YkNKeC8wbDkvMTNsRDVzcmVNWVNH?=
 =?utf-8?B?dzd5K010Y3Z2TWk5d1d0V3VPYXgzWW5vdWU1MnltNExFWW02WVVBQUlGL2Fm?=
 =?utf-8?B?VHlycVNaakZyajJtNzhsbFJqN01hb2JJTStxNmFsNEJHRDIzVmJmd1UxQ3Fo?=
 =?utf-8?B?bnJZNHduTStvWCt6RVJIeWViUmJOOXFoaGZldmRoYWtZZXBPbW15cXp0M2d5?=
 =?utf-8?B?WnZBNDgrRzgwMTdFNVRxUWMzeStCekQ3RjRUdWhmS3pRYWx0SEhKMDVpM1Zu?=
 =?utf-8?B?WGx1RDdkcGZIMTFVVjNDanpEenFGQU1ETWx5cVdjSGNaSW1ubjRwWDUvb0NQ?=
 =?utf-8?B?ZThyNElFVnM1WlRIQnVJZ1pKMVMxbHJXTmU4QzZDUnFGc1RobWpsK0NmOGZE?=
 =?utf-8?B?ZVZEMkxYdEdFUTl0WGxKUm1sYXVFcGFYUWt6NFVGU0JGM2l5NUllbDE5cWsx?=
 =?utf-8?B?Qzh1V01qWVV6SEUrRjhxalpxb0w1S1h6UWxPOXJwZXA2eWk1RFNaYk8wQ3FB?=
 =?utf-8?B?bFBocWFiMDc3dkdmR2NEclVwMkR2YmQzbjRUL1QvRXdhTE9oNzRFR1RWak45?=
 =?utf-8?B?MTJySzBKcXRXaFRaVStpelBqb21tUisyNklIMXQyeFB3NE9qcHFRd0NiMW5X?=
 =?utf-8?Q?+lNkPKufmXg+qaNBRh/X+sL8YunKdE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5521.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TzdSeXR0WVRiemFXOGVrNkozWkJzNHNGV0VCbmJWWm1WN1k4OXVLb2FIZDUx?=
 =?utf-8?B?YjdXMGJnTkFFZXRhMGJHQmtQc2hsM01mWDcvc3RjdWxjKzZ1VFVOQTFFc1oz?=
 =?utf-8?B?RHcwdDlKTFJqYkcvNkVQQUxuRjBqdE5tc1liOWZzU2l5aEJoUmc3ak5GVDk0?=
 =?utf-8?B?Z21lV0dpZ3pLTERHVDRLNkZnSC96Z0RzUGdYMmdkaVhoVVJ0aUlLNXJYbkRx?=
 =?utf-8?B?dG0zL0QrVlJZd3BLNDNndjBsbE9iYVFhbnB0a2lDU3RFNTh1ZFlBeFFGSVA3?=
 =?utf-8?B?SVN0YVk2cTBoLzd3dWd4UG5Fa2dORE1qZUhuSlhCSmpXcjVuY0ZlMUFydGRm?=
 =?utf-8?B?MytRYjNWc0hGeTRqMStMUG1TMDF4ZTd6aWxPMHUwUC9IOWk0N2w2dEcybTRY?=
 =?utf-8?B?WndVNUJzOWppL2l2RTByZkphYlppekNGdE1ManlkdHpLRXE4ZW5ZclcvREln?=
 =?utf-8?B?RHg1Zi9xak4xRWxjVmtsRWUxQVd6TU9pL2hxdWRyS0NxYkU5Wm5aNFhHWkhJ?=
 =?utf-8?B?VFp0aVA3YTBYMSttenliZ2NSNzVxN3pjV1hPS0p0ZlNTeGpKSys0R2xwUFJR?=
 =?utf-8?B?K3kvNHNwNE9mZGFJRHFWbjlKMC8wbUt3Sit1WWkwYk45bW1pMUsvWGFtR1RX?=
 =?utf-8?B?ZDlIaXhwMXlQd3RNN2MybHNTS3A2biszcGpPZlcrMFF6em9temdUV1NqeEk0?=
 =?utf-8?B?TlhnMFJmS3lYenJlTjNYZ3kvTU4xNVpuWXFhNlhCS2MrTVd6OG1zYXQzREJM?=
 =?utf-8?B?a05ESHQrdGFQWm5pL2ZobitlYVN2ekhLUldValVLTlZFQTRkeUdxZy9RdTFk?=
 =?utf-8?B?cjdpMnlDblMvUS85UmozTXhlcU9ic2gyd0pYQWxzdGYvU2JiRGNlOUJaYWJM?=
 =?utf-8?B?MnIyNVdoZXY3OHM2YUEzVVlhTm54eXczcE9sUHJYZGp5RWg4OGYvZWkvSjVX?=
 =?utf-8?B?QnVjMklWb1dmWmtoRHdEOGRBTFRxMzVnQytsM1pnemJSV1lCM2p2NG50UlVr?=
 =?utf-8?B?SlFRSlgwRzlrWG5wRk5OMHVjb0R6d2VPVUxrVTJ2L0V0UHorelNjWVM5V2w2?=
 =?utf-8?B?Z3RYUGYyNzJyZ0lISHd3cFFuNVd4Y1ZiQ2R6c1dvdWU2K05JUzB0ZTR2RFlI?=
 =?utf-8?B?ZFNLMlBKbTdjTWxPOGpVUWYzSGFseUI1TXZUWWo4eXBKbk1KVTVFcTdBZTZz?=
 =?utf-8?B?OUdnSWF6dUwvRUtoMHJFMGc0dzJzVWhtaHZLRjRMbEJXQWJtQTI0a3ZVTFB0?=
 =?utf-8?B?V2k2aWxkeXE4UmNjbDJHRU42SlpsTnV5WlpIdmhLVW8yQWdKRVVodGw2dkdB?=
 =?utf-8?B?TmFuaitYWWx3OUV0MTYrNCt1OWNDQ3Jha1ozR0t1cnYyQmx2OE1KOHIrbDZZ?=
 =?utf-8?B?b29iYlZ1OGdXYW1ORGpDSkUxR2VuaGtLU3ByVXRoSEpYUURtOEhnWmZqcGN2?=
 =?utf-8?B?cjhLanlHNG0wbE1FZ0pOblIwdFJsSDNGSlluRnlFeUhKcjZRdG1BWkRGMmZq?=
 =?utf-8?B?WCtkbmliUkdJZHJvc1NreGVsZDV4cXZHWmwxbWx3SFlaU054ZXMyTVU5MU41?=
 =?utf-8?B?YWs5b2lxKzZJUTlyQmk0cE03WlFEczBlSC9xdGVyTkdYZklXb285c1dGWEk4?=
 =?utf-8?B?Q2gySC9xdE55VS9TWlgwTlUvaDZXNXhmSVpFSDRoWlYvWndnMmpjUStwVUFy?=
 =?utf-8?B?KzJNOWMrSW1TclUza28yWm5LQUx3NFBJNDNzaVZBcEJMM0VxT3FCNGJicTVT?=
 =?utf-8?B?TEw3UWNqVXUvNkNEak1JQjdKVFZrMWFLN3A3Q28zWjhKZE5QZmY4dElabmsx?=
 =?utf-8?B?UDVqcThWRU9UWW9SN0NUMHhBT2ptOVlhZ3dvNndiSkFFZ2kxWXpDWDA3cjJE?=
 =?utf-8?B?bUpUdXUzZG8xbVNPVk5hckdWcXlnZEZGR0lPMnN3L0N1SVEwTnFXVDFnb29h?=
 =?utf-8?B?RGlzaFpaUzVLcXFxZjhldUpacmFHQlExa29tc3Y2Rm15eWZDOVpwb0NmNmNM?=
 =?utf-8?B?QWZ3MXJ6QmpWQUNIMklwNFp3cGJPWFFJYmFmNjBWdjVMdWFPenY1YWRBSXJP?=
 =?utf-8?B?Z1hnOUx4My9IeUQ1eXc1V2VjakNFUWQwRkJ1L3RJVmE3Qk43K2h6aVpmZEky?=
 =?utf-8?Q?4QcrWdjd9OHXsJa191j3k4DlN?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0B71F245182A8C42804E26165EAEE516@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5521.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ecdd413-2a89-45d3-d746-08ddfb369a20
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2025 06:50:08.9017
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wrUyBDvpb293hUaJ13JT3yMp5kPutgVBfZzSURYjR2WN9Kh12hT/4hKy4WiO9pCWQ48KrV6AXzFDh8uI/R+HsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7876
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA5LTIzIGF0IDE3OjM4ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+ID4g
PiArLyoNCj4gPiA+ICsgKiBBbGxvY2F0ZSBQQU1UIHJlZmVyZW5jZSBjb3VudGVycyBmb3IgdGhl
IGdpdmVuIFBGTiByYW5nZS4NCj4gPiA+ICsgKg0KPiA+ID4gKyAqIEl0IGNvbnN1bWVzIDJNaUIg
Zm9yIGV2ZXJ5IDFUaUIgb2YgcGh5c2ljYWwgbWVtb3J5Lg0KPiA+ID4gKyAqLw0KPiA+ID4gK3N0
YXRpYyBpbnQgYWxsb2NfcGFtdF9yZWZjb3VudCh1bnNpZ25lZCBsb25nIHN0YXJ0X3BmbiwgdW5z
aWduZWQgbG9uZyBlbmRfcGZuKQ0KPiA+ID4gK3sNCj4gPiA+ICsJdW5zaWduZWQgbG9uZyBzdGFy
dCwgZW5kOw0KPiA+ID4gKw0KPiA+ID4gKwlzdGFydCA9ICh1bnNpZ25lZCBsb25nKXRkeF9maW5k
X3BhbXRfcmVmY291bnQoUEZOX1BIWVMoc3RhcnRfcGZuKSk7DQo+ID4gPiArCWVuZMKgwqAgPSAo
dW5zaWduZWQgbG9uZyl0ZHhfZmluZF9wYW10X3JlZmNvdW50KFBGTl9QSFlTKGVuZF9wZm4gKyAx
KSk7DQo+ID4gKHNvcnJ5IGRpZG4ndCBub3RpY2UgdGhpcyBpbiBsYXN0IHZlcnNpb24pDQo+ID4g
DQo+ID4gSSBkb24ndCBxdWl0ZSBmb2xsb3cgd2h5IHdlIG5lZWQgImVuZF9wZm4gKyAxIiBpbnN0
ZWFkIG9mIGp1c3QgImVuZF9wZm4iPw0KPiA+IA0KPiA+IElJVUMgdGhpcyBjb3VsZCByZXN1bHQg
aW4gYW4gYWRkaXRpb25hbCAyTSByYW5nZSBiZWluZyBwb3B1bGF0ZWQNCj4gPiB1bm5lY2Vzc2Fy
aWx5IHdoZW4gdGhlIGVuZF9wZm4gaXMgMk0gYWxpZ25lZC4NCj4gDQo+IElJVUMsIHRoaXMgd2ls
bCBub3QgaGFwcGVuLg0KPiBUaGUgKzEgcGFnZSB3aWxsIGJlIGNvbnZlcnRlZCB0byA0S0IsIGFu
ZCB3aWxsIGJlIGlnbm9yZWQgc2luY2UgaW4NCj4gdGR4X2ZpbmRfcGFtdF9yZWZjb3VudCgpIHRo
ZSBhZGRyZXNzIGlzIGRpdmlkZWQgYnkgMk0uDQo+IA0KPiBUbyBoYW5kbGUgdGhlIGFkZHJlc3Mg
dW5hbGlnbmVkIHRvIDJNLCArNTExIHNob3VsZCBiZSB1c2VkIGluc3RlYWQgb2YgKzE/DQoNCk9L
LiBUaGFua3MgZm9yIGNhdGNoaW5nLiAgQnV0IEkgc3RpbGwgZG9uJ3QgZ2V0IHdoeSB3ZSBuZWVk
IGVuZF9wZm4gKyAxLg0KDQpBbHNvLCB3aGVuIGVuZF9wZm4gPT0gNTExLCB3b3VsZCB0aGlzIHJl
c3VsdCBpbiB0aGUgc2Vjb25kIHJlZmNvdW50IGJlaW5nDQpyZXR1cm5lZCBmb3IgdGhlIEBlbmQs
IHdoaWxlIHRoZSBpbnRlbnRpb24gc2hvdWxkIGJlIHRoZSBmaXJzdCByZWZjb3VudD8NCg0KRm9y
IGV4YW1wbGUsIGFzc3VtaW5nIHdlIGhhdmUgYSByYW5nZSBbMCwgMk0pLCB3ZSBvbmx5IG5lZWQg
b25lIHJlZmNvdW50Lg0KQW5kIHRoZSBQRk4gcmFuZ2UgKHdoaWNoIGNvbWVzIGZyb20gZm9yX2Vh
Y2hfbWVtX3Bmbl9yYW5nZSgpKSB3b3VsZCBiZToNCg0KICAgIHN0YXJ0X3BmbiA9PSAwDQogICAg
ZW5kX3BmbiAgID09IDUxMg0KDQpUaGlzIHdpbGwgcmVzdWx0cyBpbiBAc3RhcnQgcG9pbnRpbmcg
dG8gdGhlIGZpcnN0IHJlZmNvdW50IGFuZCBAZW5kDQpwb2ludGluZyB0byB0aGUgc2Vjb25kLCBJ
SVVDLg0KDQpTbyBpdCBzZWVtcyB3ZSBuZWVkOg0KDQogICAgc3RhcnQgPSAodW5zaWduZWQgbG9u
Zyl0ZHhfZmluZF9wYW10X3JlZmNvdW50KFBGTl9QSFlTKHN0YXJ0X3BmbikpOw0KICAgIGVuZCAg
ID0gKHVuc2lnbmVkIGxvbmcpdGR4X2ZpbmRfcGFtdF9yZWZjb3VudChQRk5fUEhZUyhlbmRfcGZu
KSAtIDEpKTsNCiAgICBzdGFydCA9IHJvdW5kX2Rvd24oc3RhcnQsIFBBR0VfU0laRSk7DQogICAg
ZW5kICAgPSByb3VuZF91cChlbmQsIFBBR0VfU0laRSk7DQoNCj8NCg==

