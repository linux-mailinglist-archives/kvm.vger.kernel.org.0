Return-Path: <kvm+bounces-50751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF6EFAE8FB9
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 22:59:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 54CA55A3F0D
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 20:59:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22BC2211A19;
	Wed, 25 Jun 2025 20:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z3VHynKM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8870F20E00B;
	Wed, 25 Jun 2025 20:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750885165; cv=fail; b=aUoqBPQgLrbxcPg5psnlrd9SGsOS4IsJAoFSlrUpssOjZxGmAksgZtlihtkrLJLgoLl5LTMDX8s3d7wS0zPdpeX8GnmGCnic7DcQ8HDE13Uh2T7MiT3yj6V1bgTWcsr8UtsBnRo5zUF1xcmtlm+iZFLavOBXIVzfSPxG2iXuBv0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750885165; c=relaxed/simple;
	bh=dhqaseJYvT5k46/pzUauGJ7//kfNQEZ34bn3D3guVgY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dx9DVm7LNabXUSohYcRyvuj28+DQlEs+BzYPz8wYXTu6zg26dh1WZ+jKZ7E0z+/9e25qmE98F0Xhc4QEIIQjuOuICGqno6sK/xdmqtZW0s3izgNqyc8GQKF6TkoKTUXOSvQc90MHVPLW76VuP5Y7KycdyvFrBTg05UKi5GncGwM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z3VHynKM; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750885163; x=1782421163;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=dhqaseJYvT5k46/pzUauGJ7//kfNQEZ34bn3D3guVgY=;
  b=Z3VHynKM9mcrUHf++R/8YO7UNnyH3bdZoSrhRAzxpR61gsCYHyfDGmMI
   3up0E8K0z6Cb38cORudmTHFj1+xQRjv3CAOwQi2s5qAi7wS3V7tBcl/bE
   g5JcO4A5IZ0ynq3AaMbFb3p12UM2ud02BLCWbiyIDYs8ZdzTa9aFgW9zm
   yYcey9wTfeRNRMEtUkwiP28mk/AXTOtWidbUJ/F6B5xeVQYjZ18UMWKGv
   q/gKNjh3BW12B12GOVxUt9tpZj/5CChPidxkqDFzS/lBz7Z1hxNlqTaig
   8rPtuteAnbs94KlSz4W4lAhY4HxOIwHxE4F7U2vCckHdd8wPEwv989ODi
   g==;
X-CSE-ConnectionGUID: xZTV7iLWRwKzrc2NeeeeiA==
X-CSE-MsgGUID: uFzI130uQtuK4YhawsbcIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="78602755"
X-IronPort-AV: E=Sophos;i="6.16,265,1744095600"; 
   d="scan'208";a="78602755"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 13:59:22 -0700
X-CSE-ConnectionGUID: owJH2WPcQy6CIxM8aKSGOQ==
X-CSE-MsgGUID: Yz3+3m3nTiq10X/phtszyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,265,1744095600"; 
   d="scan'208";a="156899989"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 13:59:16 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 13:59:14 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 25 Jun 2025 13:59:14 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.52)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 13:59:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ulgjMu5lFV3MbI490nZta1BHZh+6raIM4DK/nri3oDC9vztovgsGC0fu3VuPEW08sm46M1MT8Ke/TrNLiOmzgRFbiAu6GuvtIb7JxS6MgHtSHVEXoMXvjO9jnKN1C+g7w9C9F6EBu3F9/yDvtCVcwGApTpns+2lsez0CcfIOqPpYo8fIXFY4i2ou3U4YGimqnlB87daFOUB07SABo7Wi8rR2csC+dXKxI6Uc4VeB8X6sb/epDyQv23oQklKpkKmpTsagPVa4XesHbm2yMH+bV3hG8zynd7LKeiyv2bFlUZKGPbPMt57kPufF5NHZVgZAOOLlQyoTht3WjQoLy3wAmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dhqaseJYvT5k46/pzUauGJ7//kfNQEZ34bn3D3guVgY=;
 b=huSlsaaOjYkaWpi8GtNuVNMHnPzje+Nf0YMYrr7kfPQYFBAzt7vXrk/62KHzwQYmoB02gJfP3rahCW4L4CAeiSaXn2z7Zj9nrWmiQrK6Mc9/9sPuYNbh+nOeFl3y2pzhni3cjvYA5REOeuK+K8wm+Xdzf7K/VZMllzh87vKEL0e/u1Zl8ym84Kg4n3BuG5NGoP9dQRWTZX3yhr8wMmgWt9EdO8wuVNBTMIY/LFeL7GfYnpb5J169EvpDiT2TVLrAJkjbV9H0e602ftn0rFs0mLj+z2de65/oNdnjH74Wh0ENZG0Ty6vfVU3rJTTmGGwN9IA+XzaLmJtLZX4wgOR1eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH0PR11MB8144.namprd11.prod.outlook.com (2603:10b6:610:18d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Wed, 25 Jun
 2025 20:58:45 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8857.025; Wed, 25 Jun 2025
 20:58:45 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "Huang,
 Kai" <kai.huang@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 01/12] x86/tdx: Consolidate TDX error handling
Thread-Topic: [PATCHv2 01/12] x86/tdx: Consolidate TDX error handling
Thread-Index: AQHb2XKrlmf/Zzss+E+nUDEbBxD0tLQUQqeAgAAyUwA=
Date: Wed, 25 Jun 2025 20:58:45 +0000
Message-ID: <d897ab70d48be4508a8a9086de1ff3953041e063.camel@intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
	 <20250609191340.2051741-2-kirill.shutemov@linux.intel.com>
	 <5cfb2e09-7ecb-4144-9122-c11152b18b5e@intel.com>
In-Reply-To: <5cfb2e09-7ecb-4144-9122-c11152b18b5e@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH0PR11MB8144:EE_
x-ms-office365-filtering-correlation-id: 9faa43f4-0011-479d-6de4-08ddb42b1334
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RnlkSXFrbEc4ZTkrLzlVUEc3N3dvQ1Vacks5eFp3Qmd0ODRwWkNRK25EOXEr?=
 =?utf-8?B?SUdjbFBNWEVlYXRvZ1h6ajlnQ1YxUmptSXgzbHZRT00ybXpLYlBqbkVheTYz?=
 =?utf-8?B?RU4zODVCSEFlZEFsSW5PRWdsbk9JQ3A5ZlVKVjRhb0tEYkpiWFhyYnJ3aXdD?=
 =?utf-8?B?RllHaUVuNTl0dHhYT1lBWFhpaVVldmZkZ09xYU5PbDlER05oM0RJdFMxbTlL?=
 =?utf-8?B?NTJoQXNWYkV4MUFSVmtrNGk0SzBYTE1mUWNiaTFCZTNpUklRRTB1MVNGV0t3?=
 =?utf-8?B?REhVTFBpV29kVk5xaGRudUtyQkdteTNBN3BJRTlLKzNlNHEzNnZmU2tJdE1S?=
 =?utf-8?B?bVI2Wk9mdCt0RnFEMzRIWTc0SCtLL2ltbEptZmhiTzVuMzFHOG5ZQUJtc2dm?=
 =?utf-8?B?Z0hOL2RIWGFKRTV5M01mdkd3RXZqYlBxZ1BCRklTSjZvMGt0NmY0YVhTWk1G?=
 =?utf-8?B?S1VEYmVKSmJDbm9CMWxVbnNVTlFoRHFaZVNSR0NqNWtpY0NpQ2FDeDNzWEc2?=
 =?utf-8?B?M1gwbkN2bTl4dXRvQTFrVTNocE4vL241TVl0My82dWg0WGZ5MnNMYXZIYXZB?=
 =?utf-8?B?Wk1PK1FtazROaUovSHkzN2VCSmx0Qk9mT0NrOWVYb2Y3eVlwb1BpL3lYMzJk?=
 =?utf-8?B?eldKK0QvcUlzVmJkVFNKdng3VXFsQ2p2N2xRTjR6bCszMTdYTlJpNE5RZU5B?=
 =?utf-8?B?a0g0TUx3OWhvQ2FPa0JsYTFyRkZWckJwNi9jNGF4eTBLSy9hT1JLMHdkQ0Zo?=
 =?utf-8?B?dHNPVHo1eEVJZVpZY1pXSy9WWXc0VHM2bFcyWkFtb0NQY1Fhclp6R29XclFq?=
 =?utf-8?B?MC9XV2lIOSt3SzlQcXAzNmVZbnlmOGFOWHAwcFdqL0tqbjR4UldtSUc4alk2?=
 =?utf-8?B?YXJzTlV0SFpVZlJhd3hSSnpWMCtFWUZDYzdtdFlNL0ErUXVGM1hBTUljYk4y?=
 =?utf-8?B?VzlHaU02bUtzS0lIaHVINkM4YlZqVWdBa2RyYU56SEIrd3F0MzB4cjcrU3hl?=
 =?utf-8?B?QUgraENNMHBxYzRGZXRDQS9PT2QyNk1NcXhORmZGTzdvdUJCYUJPZkFmN09S?=
 =?utf-8?B?WHBueUd0dngvejE4SGFjV1dNYmZlV3V2Z1FWWXN2M25yVFY5UmppalVaS2d6?=
 =?utf-8?B?TU02K2VrdHRBa3pFWGNBT2FGSTE2bVBRTmlSbkllQ2ptVUhqNFNMWWRaeHRl?=
 =?utf-8?B?c2h6NVl5NkFHSm9Ua3Z6UDFLU0VBd1FaWnN0T0V3Z1kxMHV3ejFRSGtHRkx1?=
 =?utf-8?B?VGIrK3NYbVdad3BxdDZVUXZyS1MyTlY4L3lFUVN1VEloZjl5ZDJSTkFJUldO?=
 =?utf-8?B?V1YyM0lNWnZJKzdOeElyTlFZMEgxU0J3blZOaThXV3J4bHlsWDR0aGdrTHJX?=
 =?utf-8?B?Z2h3WnFKSFpQRUJxTVkvdTZNSm5KeW5hTE1FV2Z1WHc2aDF2czJLa1B5ajR0?=
 =?utf-8?B?Y3h1b29iMWtWdFNnckpwVmRrcWhvTXdtVXYydjB4TFN6aEZHaWNGL3JYWUtN?=
 =?utf-8?B?Y04vV1hRcC9XMVNIZlo2Q0hGdXprVVBMRmxSdlptTnJqZUhIREhQOTBkMjhI?=
 =?utf-8?B?endVQ0VhQWZadnRHNzJGci9GVFNEdVltUnI1endURGZyWHdTWXJCTmYzR3R6?=
 =?utf-8?B?N2NlRTg2SHhKeGFIRWczTkx5MkJjNVRwR3gySlRDRDRxUk1tOHVvdUdwaHB0?=
 =?utf-8?B?UUZIUVhwOWlNWnI2T3lNb1BheUxzTmtWdWh0L0JnOGNPbklVdlkvT1JCVXNw?=
 =?utf-8?B?M3BRZ2xKeS9VamIrQytJYTRENXBIaXNnM08xYVg5eXdBV2crb1paaGhWTkVR?=
 =?utf-8?B?RWcvc1dtc3BheEFneGZHRGN6WGtPWWMxS1JheUtqN29uaFR3QlR1aW1zYlYy?=
 =?utf-8?B?T0JaR0RXR2crSmxISkVscWdJcklRYktOMEJWSS9WYjYwQlNnV084clBNc2NZ?=
 =?utf-8?B?dGNIM3Z1WFJmaWJwSEVVdjBrOHNyUUR5TXIvbkR4VTBqRlEvOEE4RjMvR0ND?=
 =?utf-8?Q?0yxWnMY6dTijqUzOztxbFlVULbFVkE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WVB3RHFuUldoV0tEZGFBYlZtb0p5Q1FiNDVoLzcxZC9WZVVXVHdIZ2JmWDdT?=
 =?utf-8?B?TUg1Y0JobHFOSnJ6UmJsUThzWlJhQjFWcUNGRU1WQUUrSFhlelI2aFJlTktB?=
 =?utf-8?B?ZHhrUExQUitQNWU1L3NTZHlzZ1VlNXBWOVNwRmFaTndsaWNDUm5xNCtLVkF1?=
 =?utf-8?B?L2Q2alZCS3FwMHJmRlNVNFlaVTZNRXpjRm02aDdlWnFEMUVnWHRLc2NWWmhC?=
 =?utf-8?B?NHNacVZjRnRMMzJvQXN4NXNnLzlwbGQ1TXY5Wng5TmFZR3lMVmkyR0JTcm43?=
 =?utf-8?B?R3dlcnNqcmRzL0dycXlVaUdaNkR5bzhERnpjU3NHeWhSQW10NUNrVGl4Wjg0?=
 =?utf-8?B?S1pURFNjbEYvNHNDcTJwNHNjNk9EcVlhb0Y2UmV5MURNeVVSTU1penkvMVVJ?=
 =?utf-8?B?SHBuWWJpMVdRM3VWZnNmQTkyM0p6Y2VMb2NmcHl4MGN4V3RJd0lnZDBHR3ZE?=
 =?utf-8?B?SFpXOHQ0VE5VeXgzRHhXckQxby8vTjJHMVFiTXNzRWJHUXJyeHo3K2hvK2Y0?=
 =?utf-8?B?T2xRbWc0V2FHUms0RXpOc0JQWXpOY1FqRlprTUxDZ1lKcHY2U1J3OGtlZ0RM?=
 =?utf-8?B?aFI1bGsxMlJWZ1hWUXlIdkpJbWszUmZxaXRmYU5ITUR4NDlOOENOaUlDblh0?=
 =?utf-8?B?NTh2ODlEc2x4ZklESk1OWUFXUmFKakhsWjAvL1FuSUV2NG9qVEQ3Y0ZjUEUx?=
 =?utf-8?B?UDA5VTBWRjVmeTRVYW5xekVzR0xvRjhsb3MvUzNrWm01NTZ1ZHJaQkJ5dkc3?=
 =?utf-8?B?SzZ2TmpDT1VMZ1FaQm1QWmU5YVI0aFIxa0ljcWQzOWFnUjRaY0Y1TlF2a1I2?=
 =?utf-8?B?dzFLYXZ4NjExcmxnN3UvbWhmYnBjWW1rS2tySEgzWGlOUW9KWWRpN0taNnVm?=
 =?utf-8?B?eStsZkRibVZ0ZlgxK24xVkkwQnBHSGhaSDArQmN4bzhQeXU4V1U2MTRScFNi?=
 =?utf-8?B?V0k4dm9BNDU4R0gvOVJ4a243NC9HRENMNTY0ZkRVVCs2bll3d3ZXVFNQUk1o?=
 =?utf-8?B?YnBCTWQ5L21KOGZJNTRkc0JyaWwrVktQbkpjNEY0TTBHdFI2OVBWNEZuK0h3?=
 =?utf-8?B?SGJZdFRwMUJ2NHFDRGVyK3ViOVIybzNYN1JjdkhiUk5aZHl4RytNV3lHczhy?=
 =?utf-8?B?NjRrVFdCUUdST0R3Y0xQWXZKS0JLMG9KejN5UzRDZWJWN29yRGxKL0h4Nnhr?=
 =?utf-8?B?TlZqZ1JQSlZZK01VSnkrVXI0SWxQY3JjME9tT2ZCM3dkVzJsV2FiWkdtUnA0?=
 =?utf-8?B?bDNMeW9XcUNmNWI2N2QwcHd1NVFFRDM1Qnp0ZEhnR3MyTnArTEVyTU9pWGow?=
 =?utf-8?B?bnF1UlFEd1pTVlVGS3dnNGxGaWJOTUNDdWJLMGZOaXFNQmVpbEswZ3ZWQWto?=
 =?utf-8?B?dW9JWGpjY2FReWd1NnoycG1wNTh6eUNqSDNieUdnVkM2bGdkVVpzMFoyWTJR?=
 =?utf-8?B?a1h2MmcrYnZCNWxTUlNQMHNvSzg4RnNGV3ZvSnlsY1U5RjdFRjljaGdBajM1?=
 =?utf-8?B?OHdDdmg2TjhOR1dGNFV5U2RyM0VnUHczdUFCNXNXa00rNGIyMWROYmlkZkJo?=
 =?utf-8?B?ZFdZK0hjeklaYlFxOFJ1QjBvMGI5VVdpYVVqM0VKM2JZSVdLTFphd2U4TmVN?=
 =?utf-8?B?eVkzWUNDaGVlVitpUEw2aGtFaHdpUE9wUlZuVVhCT3dkbHRaUVorMGlKK0tM?=
 =?utf-8?B?bWdyUmpsaGZBYndnc0YwTnF2VmtTck9UUTlqV1dIR0NVUWJtTlJQcWcvZFBs?=
 =?utf-8?B?aWs4UXM5SGNDY2FVTmZGRkhVd00raHk4d1REckdnRjNYMlIrampCUlZTZ2VD?=
 =?utf-8?B?eTcyT3R6UzRnYktjZjd6LzliNEloZUZydlZqMlMwcW9vN2xvbTdHTlo2M1dL?=
 =?utf-8?B?cEVIa2lhRm5VTkJOclBQVGxXYkNBZmJGQlZYR3B2Tmo2WmtZUTh6ZEQ1RjNN?=
 =?utf-8?B?VVpwa0N1MVFqU2M2WHFuRDljTFF1RlduYVpCM0pmTTdadTdWNVpmVldQNE9B?=
 =?utf-8?B?bG0rWWRLQ0FCcTRkR1h2Z0VXVndsclNPcC9wcGIrT3JvQ0lWWWVzOFZwbTh0?=
 =?utf-8?B?cU5CMGo4dGZVS1pLNUc5K3NZdHpLaG9SYmxKWTFRTjBLWGpoa09SaXhBM2Nz?=
 =?utf-8?B?UUtsS0JCaUszNWtHM29DREtrSGlSZ25BYU55YjdCMlNHY2RvWFNlWE1maVZw?=
 =?utf-8?Q?fYCCZg2B2A3zw1DuWSoGLLU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E64245C50270524FBC47417D5B96ECE5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9faa43f4-0011-479d-6de4-08ddb42b1334
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2025 20:58:45.4711
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I1NRxikeAdukuaGlZNBoGmggg4FXrW/HBl0Nd1iI4ocKD1QXtWOeAtnJf5nTCaeToyHCf81MagMwsIajelrv7fz53gmtaKnBGgBO4MI8LwE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8144
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA2LTI1IGF0IDEwOjU4IC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
PiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jDQo+ID4gKysrIGIvYXJjaC94ODYva3ZtL3Zt
eC90ZHguYw0KPiA+IEBAIC0yMDIsMTIgKzIwMiw2IEBAIHN0YXRpYyBERUZJTkVfTVVURVgodGR4
X2xvY2spOw0KPiA+IMKgIA0KPiA+IMKgIHN0YXRpYyBhdG9taWNfdCBucl9jb25maWd1cmVkX2hr
aWQ7DQo+ID4gwqAgDQo+ID4gLXN0YXRpYyBib29sIHRkeF9vcGVyYW5kX2J1c3kodTY0IGVycikN
Cj4gPiAtew0KPiA+IC0JcmV0dXJuIChlcnIgJiBURFhfU0VBTUNBTExfU1RBVFVTX01BU0spID09
IFREWF9PUEVSQU5EX0JVU1k7DQo+ID4gLX0NCj4gPiAtDQo+ID4gLQ0KPiANCj4gSXNha3UsIHRo
aXMgb25lIHdhcyB5b3VycyAoYWxvbmcgd2l0aCB0aGUgd2hpdGVzcGFjZSBkYW1hZ2UpLiBXaGF0
IGRvDQo+IHlvdSB0aGluayBvZiB0aGlzIHBhdGNoPw0KDQpJIHRoaW5rIHRoaXMgYWN0dWFsbHkg
Z290IGFkZGVkIGJ5IFBhb2xvLCBzdWdnZXN0ZWQgYnkgQmluYmluLiBJIGxpa2UgdGhlc2UNCmFk
ZGVkIGhlbHBlcnMgYSBsb3QuIEtWTSBjb2RlIGlzIG9mdGVuIG9wZW4gY29kZWQgZm9yIGJpdHdp
c2Ugc3R1ZmYsIGJ1dCBzaW5jZQ0KUGFvbG8gYWRkZWQgdGR4X29wZXJhbmRfYnVzeSgpLCBJIGxp
a2UgdGhlIGlkZWEgb2YgZm9sbG93aW5nIHRoZSBwYXR0ZXJuIG1vcmUNCmJyb2FkbHkuIEknbSBv
biB0aGUgZmVuY2UgYWJvdXQgdGR4X3N0YXR1cygpIHRob3VnaC4NCg==

