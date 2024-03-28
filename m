Return-Path: <kvm+bounces-13003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7886A88FDE1
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 12:15:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C9B51C2A277
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 11:15:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CAFB7D3E3;
	Thu, 28 Mar 2024 11:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fb+N38C4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8012754BCB;
	Thu, 28 Mar 2024 11:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711624496; cv=fail; b=O08rUJkQwQqhp15e5LcNR7vXt/o9glxrKh5QBZo76TqddEPVz8YIaAPAzcKvLEvkmoj/UzmDNVO0nbcxX015ABp3L2nEMENTjVfxbobvwPSR2WIpoL7Mxj/J+3ZyamBZeQYeHRlycTZdJnStp088Qfg7YSFX+sHMBuwrukXyoP8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711624496; c=relaxed/simple;
	bh=yN8T0VJrXynkEoB2GFI1t5YcQlrvPtCrtmYIzK6qaNU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XArvRiurV+QX818iiIeWzUPeEreU3GYUxHzXHj8NDeyOwOktApFF9dSUtLzoAGe2/1kjrnxZ9INbDrcysUzBr63x9TSRdzcJga5Ei1QWs7mvmX6NrYl7nDr3gxoK8HPLJSCGd9FjKEYG66efMa3F43hLd9pWoPp3SbfsXigiOK8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fb+N38C4; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711624494; x=1743160494;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=yN8T0VJrXynkEoB2GFI1t5YcQlrvPtCrtmYIzK6qaNU=;
  b=Fb+N38C4OQTpqPqa9ch3pD2srU0sifzZ+gi/pcyAAyD3GOuVkvXxGia3
   YF+dZ3LSrg+MI7C4AbRtlz5QpvEiJzDx4r2v8APCAfKvvJxdVlumqV5P4
   afYN3+10QOEeRUJS0jcul8/jwnYGhzGEVTVg5QipgAfdjqNfdzMoiAlk6
   cwfLKWEa7lJzTdVcPFku6XMEWoYdnwjBSHl6G9VuW7uE+aS0UQF71LktU
   k/Ekx7pjIZ2UcBi2q+vRPkm/xkCs/R5tBbNs2pGZobxIG6/4plbZRooqD
   RpWbbhE4vUlAf+ZX+MbHi6+vxcjv5FR5fceUlwkPnR3iWUpwbSCJJOLWC
   w==;
X-CSE-ConnectionGUID: SVwwUtGESNq9LJmgaHmXqA==
X-CSE-MsgGUID: T74bK+l/RHer3sUzPy+gMA==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="6632573"
X-IronPort-AV: E=Sophos;i="6.07,161,1708416000"; 
   d="scan'208";a="6632573"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 04:14:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,161,1708416000"; 
   d="scan'208";a="16492202"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Mar 2024 04:14:53 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 28 Mar 2024 04:14:53 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 28 Mar 2024 04:14:52 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 28 Mar 2024 04:14:52 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 28 Mar 2024 04:14:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C09znLSJq6Cx/jdl6I+bPWgbd+JTijb3dA9h3/WIUvl0vw5FRdLl7HeDsAxGuIswQ/dIZfOMngMh0A3PqwMr6SXEJXap6j7ThwN7E7lcVCWlGKMP0WfekiQRAm2/jopcEVPv8kiWn8fZoI0qsh1hIUulNwC20/Bl79pQ9gq8ES49OlnDqiZd+AlkpfqsXq2mPZRFUTDCanmLgkiqbqnaNTEn3U0A4Y/9IcPPzfDZpmV7h2SLI3g7wh0Ge8NeYOS4Ci4rwyWQ2XCHv1dvA35iXby8OslRevnlSmxeRRlRzMoXfW4PBvgypsAiDCBbqDfNamkZ/wt6NIzlOgy4Kh4tRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yN8T0VJrXynkEoB2GFI1t5YcQlrvPtCrtmYIzK6qaNU=;
 b=l2xeUBzjPpIqPvPQ07vCHB1cc/jxteT1SAVoxX4pbrKbfBdzPjGiCrRqMJpYKFQYBkxJzxL3mV7stvEmu92kF2EkB2Al23S2pa24mkkxfxqv6DoJJkHQl/eisKMU85lc0nTrDjXOwkn49415sGIILlg4n/ViMoFURkS93wlgANWSu/eeBBdy9lkdsIgPqtZwMQOBzAMUw2auVDYnNgRwGTiJqauqTm7qTBn03bae7uKAGjTh+OCGRwS5ySEoNwPk5k3DXoI581T3ku2NqCpW4DGzBrd4SEXZqfpR3IMtCICD82Svbsd5tsEHy0g+dPWSKhr04bjO9vHBIlYZcBnXAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH8PR11MB6803.namprd11.prod.outlook.com (2603:10b6:510:1cb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.11; Thu, 28 Mar
 2024 11:14:43 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.031; Thu, 28 Mar 2024
 11:14:42 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Yuan, Hang" <hang.yuan@intel.com>, "sean.j.christopherson@intel.com"
	<sean.j.christopherson@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v19 038/130] KVM: TDX: create/destroy VM structure
Thread-Topic: [PATCH v19 038/130] KVM: TDX: create/destroy VM structure
Thread-Index: AQHaaI2+d2CEUIDjsUCuhszN5EFGpLFJbQMAgAL1FoCAADFDAIAAPsEAgABfB4A=
Date: Thu, 28 Mar 2024 11:14:42 +0000
Message-ID: <65a1a35e0a3b9a6f0a123e50ec9ddb755f70da52.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <7a508f88e8c8b5199da85b7a9959882ddf390796.1708933498.git.isaku.yamahata@intel.com>
	 <a0627c0f-5c2d-4403-807f-fc800b43fd3b@intel.com>
	 <20240327225337.GF2444378@ls.amr.corp.intel.com>
	 <4d925a79-d3cf-4555-9c00-209be445310d@intel.com>
	 <20240328053432.GO2444378@ls.amr.corp.intel.com>
In-Reply-To: <20240328053432.GO2444378@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH8PR11MB6803:EE_
x-ms-office365-filtering-correlation-id: 5f57efce-ecc1-4ef2-4987-08dc4f184471
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DhTmczCKuvduh34rCARP/iXNwbISsn7uurrJ0LyR2W9tUnbcQ7oIGibNe5xJRgDyq3f5e6+7o3K5fVv+CZ/GNPPo7fVEOEpftvCMtOy3a2dN0MBfmgEvKpl9KEkH/kZPee2E9M6prhIX1eeQobZYJTZZRs4V48MEi+8/SoDVgadjtYXBRlgqrNP9ODbznsTYtRX7Hym9TU/rq4+WOYT10IIM+jqHDaLPn6nP9lqNsJD2wC3yIDsZ3HtmtzLyh/NR3GSBuCdZgP+Mfrokxp0MGTj+UwN/qsDHu1dkogsFcp5ItIyG4Xv9yDRsTOPCPE5cSFKv0ImQuXld61VW8n9zKzCutlFc1oN3o71pvwFd6veVznaXSy1HtJWOxoUAE/TgAIcJl+swqC+JTvPPjciWMIsYHGqcUeUA61TDRRqxma8Kgq6OhCaeTx71OLEEt9+PsAOEHF8CKiaruI1epHJg0X2iTNjWbTJU3ls1TcSp4i5K6z8SYlxtv7C1Or8Fs+0UDZUMvYlRDBSz5Bbz21/DL5HkAEM9hIS9aauq9KFeODDWevv3PJBX9lhZWeRQ4saUxi7E9mCWH4bG8WinxvdVSki4gh1rED/7jfoQVgyQL9xPclS7HLAnVCcRDiqu6IskKGpQ1nb/mPAKlhpRL3iHP6AfpDJMcgER5cmbiDB1PJw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UUMyNExDcWRhL2x1QXlXTDFodUJmY2loZHRYZ3RNOUs4VzBpLzBIT0w5cTRk?=
 =?utf-8?B?Zm92UGFEWXozT1hjM3RwQ2lDNmN1cE1VOHkxM2d6YS81NDhIdjdiaHR2dW5k?=
 =?utf-8?B?VGlTTm5qUWlacURDbFVMT2JVS3pDbGRsaDhtQ0swUEtjTmVyVnZMNjJDa3BN?=
 =?utf-8?B?ejczaXROcW8xc3Z4SS9KR294MlZQOFV0dnptdGU5RlVyU3g3UXk3d0o0dzRZ?=
 =?utf-8?B?VytrdTNsWFh2NlVUcjZHNzJ0bjJaYVdwazZsblFEeFVhdW1MMUdYMDZ6Tld2?=
 =?utf-8?B?UGpFTFBBb0VXN3BDOVJyVE9JUm9ERDlaLzlwYmUreUNuam83R0RTdTc5aDRZ?=
 =?utf-8?B?aFpiUEFud2VKNDVsTFJyQWNKVWpsaktVUkZqL3Y4cnpEblpyb1ZZemFhNGY3?=
 =?utf-8?B?MC9RaC9wTE1objlvNDIwcG53OWMvNGk5U0tEM3QvVXBpYkFGSW1wRXhRZFFv?=
 =?utf-8?B?eTV6VU1DU1k1RURiUWcySWlOdFlqV25GOW1QNVM1RzlGWnc0Sy9rbUFyYisw?=
 =?utf-8?B?VVRidzhJSUNGZ2dzNHJERDAvUm14RXVER1Z4eXdLQkNjbjE3UlRLLyt0cE9P?=
 =?utf-8?B?bVVNNEkwYXNhUmwxbFY1SXpvcVVNSlJiTGJ3OTJWTkw3b1NVZ1NHK3ZsZktI?=
 =?utf-8?B?QmtqR1Z2cmdVMUdkM2tvb1dxNDl0Nis4ZHdjN2xVWVM5YXdnWmVXS21sbEkw?=
 =?utf-8?B?cHJRM2gveWdtZHI2Yk54NG83L1Y0QVVUOTN5N2hJWldOWDBySDVNTjJUOVNM?=
 =?utf-8?B?L25BN0pOeWdzbkdKTlFXTkR2YVVvUENuQkIxaGJ4aHR4K1pDbzVKVm9tNlpy?=
 =?utf-8?B?Y2NTQ0lXczdCKzFRaC81NlNFQm5DclRyT25LeDFic3BGY3lxbEUydkpPektv?=
 =?utf-8?B?enFZVEUyTXRLSmRXamI2U1NBMll3d1kyeDZVWWp2emZSa1p6Q0VhNlhJWjFi?=
 =?utf-8?B?dEZyUXlNZ3FZSld1WkptUTZEdHVYQWhUdmFmNk55WHJPenBEVGRuM3hCenV6?=
 =?utf-8?B?UFkrUDhYY21MdU1pMzZqSThnZWNwNnFXOFQ2L20zZ1IzM3hrR1RMUFFHRVh1?=
 =?utf-8?B?YW4yVDB3eUdvTU9BWnh4aTRGdGcxbm1iR0ZKUnB0OHM2MnFhWHI0YSsweC9l?=
 =?utf-8?B?STVtVWhvN2JlbFAxM3pJQXZRQXFQSDh5Y1VSV0lpdDgwZERrMmNVQUZ3ZFBW?=
 =?utf-8?B?ODB0WEFCVmtabXVGSUZDSzg2V1NwcStReWdvc3paaUVxclFLZkhpUW13M2xt?=
 =?utf-8?B?dUV4N2pHN1dYVGdrdEFWaEhoM1haWGdWNk9IQ1NHMWQ3NUFjK0xxQ2h3WUUv?=
 =?utf-8?B?ZUhMckZMbndNWHltSHFUL2VWQnM0bHBxMytUVitQbUNRYmxnTVFoY1FIT3ZI?=
 =?utf-8?B?RXI4SkpJRSt6RnFKOEdocmI0OW5xME0zMjM3N1pwWEJDbVZFUzBydDlIUkxX?=
 =?utf-8?B?enV0dTdYbU9YT052U0tpWmJ0YlAvMmJubk5MRkNEZDBpRVR4YjI3bFRyMC9S?=
 =?utf-8?B?cmZ3ci84NTVzN0M4MVFZK3RVakFMQ3dyNVhSWjFnb3BLU2NVbkJwUnUrYUdJ?=
 =?utf-8?B?NGMrV2FiRVlHWFZnOHRWTXNBdU11QWxXK3FXTkgxNU5ORGY2V0tWa2lJd3VE?=
 =?utf-8?B?WnZtWmhodTltck03OHQzSXJEYXkxdjBJQktKZzlMWmIySkFnd1MrUllNZFQ5?=
 =?utf-8?B?MDl4STJ4MmNFbnlKVk1sbEdSZE14VTk4WDZtN1NieFJMQ3lIcEhVdUIxU2Jv?=
 =?utf-8?B?ODNpTHhBQmxIT3NHL0k5SUlMMXg5TW9hMHRKMlhnUVUyNVcwWC9DY0tKZE9D?=
 =?utf-8?B?RGcrTERTTnZYM29nUjlONGkrM3dDZWoxbEVHamRaOFBPZjVRSmIzQXROVGR5?=
 =?utf-8?B?R1lDV1MyaTMvazdFbXB2dUU1NGRsZWlJenh2Mk55cHFaYytwMVV4blNSczI1?=
 =?utf-8?B?eVp3aytKM1JqN3JUWW9tSGR0Wm1wWG9ydEhjajlIK1hTZ045Q3ZEdWlOVzdy?=
 =?utf-8?B?UUlNTEI5Sml5MXFvcDExaElkTWdJRGUwZDUyckdVMno4K1hlYVFiZnVYa2Z3?=
 =?utf-8?B?NmJUTEtLWFd3SHlJT3RrQ3RHamJQQ1lzVkttNWtFVWhBbkRGL29jZDd4N0lw?=
 =?utf-8?B?NEdCQitxMW9Pa1p1dWNkUENkMVdGRWdMdEVLRDVmSnNrVit2ZkMrU3dKY01P?=
 =?utf-8?B?RWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CB138B531BEBF144AF4D5E5BAFA83F3D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f57efce-ecc1-4ef2-4987-08dc4f184471
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2024 11:14:42.5128
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HDFx1q1HC9NxYBoF59sPOe0TBiA87frNoZ4E6DOnbqXQVJFpb4Mu2D3VZdqVqt4aHzOX6RlX2SmxjcaGOPZj0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6803
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTAzLTI3IGF0IDIyOjM0IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gT24gVGh1LCBNYXIgMjgsIDIwMjQgYXQgMDI6NDk6NTZQTSArMTMwMCwNCj4gIkh1YW5nLCBL
YWkiIDxrYWkuaHVhbmdAaW50ZWwuY29tPiB3cm90ZToNCj4gDQo+ID4gDQo+ID4gDQo+ID4gT24g
MjgvMDMvMjAyNCAxMTo1MyBhbSwgSXNha3UgWWFtYWhhdGEgd3JvdGU6DQo+ID4gPiBPbiBUdWUs
IE1hciAyNiwgMjAyNCBhdCAwMjo0Mzo1NFBNICsxMzAwLA0KPiA+ID4gIkh1YW5nLCBLYWkiIDxr
YWkuaHVhbmdAaW50ZWwuY29tPiB3cm90ZToNCj4gPiA+IA0KPiA+ID4gPiAuLi4gY29udGludWUg
dGhlIHByZXZpb3VzIHJldmlldyAuLi4NCj4gPiA+ID4gDQo+ID4gPiA+ID4gKw0KPiA+ID4gPiA+
ICtzdGF0aWMgdm9pZCB0ZHhfcmVjbGFpbV9jb250cm9sX3BhZ2UodW5zaWduZWQgbG9uZyB0ZF9w
YWdlX3BhKQ0KPiA+ID4gPiA+ICt7DQo+ID4gPiA+ID4gKwlXQVJOX09OX09OQ0UoIXRkX3BhZ2Vf
cGEpOw0KPiA+ID4gPiANCj4gPiA+ID4gIEZyb20gdGhlIG5hbWUgJ3RkX3BhZ2VfcGEnIHdlIGNh
bm5vdCB0ZWxsIHdoZXRoZXIgaXQgaXMgYSBjb250cm9sIHBhZ2UsIGJ1dA0KPiA+ID4gPiB0aGlz
IGZ1bmN0aW9uIGlzIG9ubHkgaW50ZW5kZWQgZm9yIGNvbnRyb2wgcGFnZSBBRkFJQ1QsIHNvIHBl
cmhhcHMgYSBtb3JlDQo+ID4gPiA+IHNwZWNpZmljIG5hbWUuDQo+ID4gPiA+IA0KPiA+ID4gPiA+
ICsNCj4gPiA+ID4gPiArCS8qDQo+ID4gPiA+ID4gKwkgKiBURENYIGFyZSBiZWluZyByZWNsYWlt
ZWQuICBURFggbW9kdWxlIG1hcHMgVERDWCB3aXRoIEhLSUQNCj4gPiA+ID4gDQo+ID4gPiA+ICJh
cmUiIC0+ICJpcyIuDQo+ID4gPiA+IA0KPiA+ID4gPiBBcmUgeW91IHN1cmUgaXQgaXMgVERDWCwg
YnV0IG5vdCBURENTPw0KPiA+ID4gPiANCj4gPiA+ID4gQUZBSUNUIFREQ1ggaXMgdGhlIGNvbnRy
b2wgc3RydWN0dXJlIGZvciAndmNwdScsIGJ1dCBoZXJlIHlvdSBhcmUgaGFuZGxpbmcNCj4gPiA+
ID4gdGhlIGNvbnRyb2wgc3RydWN0dXJlIGZvciB0aGUgVk0uDQo+ID4gPiANCj4gPiA+IFREQ1Ms
IFREVlBSLCBhbmQgVERDWC4gIFdpbGwgdXBkYXRlIHRoZSBjb21tZW50Lg0KPiA+IA0KPiA+IEJ1
dCBURENYLCBURFZQUiBhcmUgdmNwdS1zY29wZWQuICBEbyB5b3Ugd2FudCB0byBtZW50aW9uIHRo
ZW0gX2hlcmVfPw0KPiANCj4gU28gSSdsbCBtYWtlIHRoZSBwYXRjaCB0aGF0IGZyZWVzIFREVlBS
LCBURENYIHdpbGwgY2hhbmdlIHRoaXMgY29tbWVudC4NCj4gDQoNCkhtbS4uIExvb2tpbmcgYWdh
aW4sIEkgYW0gbm90IHN1cmUgd2h5IGRvIHdlIGV2ZW4gbmVlZA0KdGR4X3JlY2xhaW1fY29udHJv
bF9wYWdlKCk/DQoNCkl0IGJhc2ljYWxseSBkb2VzIHRkeF9yZWNsYWltX3BhZ2UoKSArIGZyZWVf
cGFnZSgpOg0KDQorc3RhdGljIHZvaWQgdGR4X3JlY2xhaW1fY29udHJvbF9wYWdlKHVuc2lnbmVk
IGxvbmcgdGRfcGFnZV9wYSkNCit7DQorCVdBUk5fT05fT05DRSghdGRfcGFnZV9wYSk7DQorDQor
CS8qDQorCSAqIFREQ1ggYXJlIGJlaW5nIHJlY2xhaW1lZC4gIFREWCBtb2R1bGUgbWFwcyBURENY
IHdpdGggSEtJRA0KKwkgKiBhc3NpZ25lZCB0byB0aGUgVEQuICBIZXJlIHRoZSBjYWNoZSBhc3Nv
Y2lhdGVkIHRvIHRoZSBURA0KKwkgKiB3YXMgYWxyZWFkeSBmbHVzaGVkIGJ5IFRESC5QSFlNRU0u
Q0FDSEUuV0IgYmVmb3JlIGhlcmUsIFNvDQorCSAqIGNhY2hlIGRvZXNuJ3QgbmVlZCB0byBiZSBm
bHVzaGVkIGFnYWluLg0KKwkgKi8NCisJaWYgKHRkeF9yZWNsYWltX3BhZ2UodGRfcGFnZV9wYSkp
DQorCQkvKg0KKwkJICogTGVhayB0aGUgcGFnZSBvbiBmYWlsdXJlOg0KKwkJICogdGR4X3JlY2xh
aW1fcGFnZSgpIHJldHVybnMgYW4gZXJyb3IgaWYgYW5kIG9ubHkgaWYgdGhlcmUncw0KYW4NCisJ
CSAqIHVuZXhwZWN0ZWQsIGZhdGFsIGVycm9yLCBlLmcuIGEgU0VBTUNBTEwgd2l0aCBiYWQgcGFy
YW1zLA0KKwkJICogaW5jb3JyZWN0IGNvbmN1cnJlbmN5IGluIEtWTSwgYSBURFggTW9kdWxlIGJ1
ZywgZXRjLg0KKwkJICogUmV0cnlpbmcgYXQgYSBsYXRlciBwb2ludCBpcyBoaWdobHkgdW5saWtl
bHkgdG8gYmUNCisJCSAqIHN1Y2Nlc3NmdWwuDQorCQkgKiBObyBsb2cgaGVyZSBhcyB0ZHhfcmVj
bGFpbV9wYWdlKCkgYWxyZWFkeSBkaWQuDQorCQkgKi8NCisJCXJldHVybjsNCisJZnJlZV9wYWdl
KCh1bnNpZ25lZCBsb25nKV9fdmEodGRfcGFnZV9wYSkpOw0KK30NCg0KQW5kIHdoeSBkbyB5b3Ug
bmVlZCBhIHNwZWNpYWwgZnVuY3Rpb24ganVzdCBmb3IgY29udHJvbCBwYWdlKHMpPw0KDQo+IA0K
PiA+IE90aGVyd2lzZSB5b3Ugd2lsbCBoYXZlIHRvIGV4cGxhaW4gdGhlbS4NCj4gPiANCj4gPiBb
Li4uXQ0KPiA+IA0KPiA+ID4gPiA+ICsNCj4gPiA+ID4gPiArdm9pZCB0ZHhfbW11X3JlbGVhc2Vf
aGtpZChzdHJ1Y3Qga3ZtICprdm0pDQo+ID4gPiA+ID4gK3sNCj4gPiA+ID4gPiArCWJvb2wgcGFj
a2FnZXNfYWxsb2NhdGVkLCB0YXJnZXRzX2FsbG9jYXRlZDsNCj4gPiA+ID4gPiArCXN0cnVjdCBr
dm1fdGR4ICprdm1fdGR4ID0gdG9fa3ZtX3RkeChrdm0pOw0KPiA+ID4gPiA+ICsJY3B1bWFza192
YXJfdCBwYWNrYWdlcywgdGFyZ2V0czsNCj4gPiA+ID4gPiArCXU2NCBlcnI7DQo+ID4gPiA+ID4g
KwlpbnQgaTsNCj4gPiA+ID4gPiArDQo+ID4gPiA+ID4gKwlpZiAoIWlzX2hraWRfYXNzaWduZWQo
a3ZtX3RkeCkpDQo+ID4gPiA+ID4gKwkJcmV0dXJuOw0KPiA+ID4gPiA+ICsNCj4gPiA+ID4gPiAr
CWlmICghaXNfdGRfY3JlYXRlZChrdm1fdGR4KSkgew0KPiA+ID4gPiA+ICsJCXRkeF9oa2lkX2Zy
ZWUoa3ZtX3RkeCk7DQo+ID4gPiA+ID4gKwkJcmV0dXJuOw0KPiA+ID4gPiA+ICsJfQ0KPiA+ID4g
PiANCj4gPiA+ID4gSSBsb3N0IHRyYWNraW5nIHdoYXQgZG9lcyAidGRfY3JlYXRlZCgpIiBtZWFu
Lg0KPiA+ID4gPiANCj4gPiA+ID4gSSBndWVzcyBpdCBtZWFuczogS2V5SUQgaGFzIGJlZW4gYWxs
b2NhdGVkIHRvIHRoZSBURFggZ3Vlc3QsIGJ1dCBub3QgeWV0DQo+ID4gPiA+IHByb2dyYW1tZWQv
Y29uZmlndXJlZC4NCj4gPiA+ID4gDQo+ID4gPiA+IFBlcmhhcHMgYWRkIGEgY29tbWVudCB0byBy
ZW1pbmQgdGhlIHJldmlld2VyPw0KPiA+ID4gDQo+ID4gPiBBcyBDaGFvIHN1Z2dlc3RlZCwgd2ls
bCBpbnRyb2R1Y2Ugc3RhdGUgbWFjaGluZSBmb3Igdm0gYW5kIHZjcHUuDQo+ID4gPiANCj4gPiA+
IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2bS9aZnZJOHQ3U2xmSXN4Ym1UQGNoYW8tZW1haWwv
DQo+ID4gDQo+ID4gQ291bGQgeW91IGVsYWJvcmF0ZSB3aGF0IHdpbGwgdGhlIHN0YXRlIG1hY2hp
bmUgbG9vayBsaWtlPw0KPiA+IA0KPiA+IEkgbmVlZCB0byB1bmRlcnN0YW5kIGl0Lg0KPiANCj4g
Tm90IHlldC4gQ2hhbyBvbmx5IHByb3Bvc2UgdG8gaW50cm9kdWNlIHN0YXRlIG1hY2hpbmUuIFJp
Z2h0IG5vdyBpdCdzIGp1c3QgYW4NCj4gaWRlYS4NCg0KVGhlbiB3aHkgc3RhdGUgbWFjaGluZSBp
cyBiZXR0ZXI/ICBJIGd1ZXNzIHdlIG5lZWQgc29tZSBjb25jcmV0ZSBleGFtcGxlIHRvIHRlbGwN
CndoaWNoIGlzIGJldHRlcj8NCg0KPiANCj4gDQo+ID4gPiBIb3cgYWJvdXQgdGhpcz8NCj4gPiA+
IA0KPiA+ID4gLyoNCj4gPiA+ICAgKiBXZSBuZWVkIHRocmVlIFNFQU1DQUxMcywgVERILk1ORy5W
UEZMVVNIRE9ORSgpLCBUREguUEhZTUVNLkNBQ0hFLldCKCksIGFuZA0KPiA+ID4gICAqIFRESC5N
TkcuS0VZLkZSRUVJRCgpIHRvIGZyZWUgdGhlIEhLSUQuDQo+ID4gPiAgICogT3RoZXIgdGhyZWFk
cyBjYW4gcmVtb3ZlIHBhZ2VzIGZyb20gVEQuICBXaGVuIHRoZSBIS0lEIGlzIGFzc2lnbmVkLCB3
ZSBuZWVkDQo+ID4gPiAgICogdG8gdXNlIFRESC5NRU0uU0VQVC5SRU1PVkUoKSBvciBUREguTUVN
LlBBR0UuUkVNT1ZFKCkuDQo+ID4gPiAgICogVERILlBIWU1FTS5QQUdFLlJFQ0xBSU0oKSBpcyBu
ZWVkZWQgd2hlbiB0aGUgSEtJRCBpcyBmcmVlLiAgR2V0IGxvY2sgdG8gbm90DQo+ID4gPiAgICog
cHJlc2VudCB0cmFuc2llbnQgc3RhdGUgb2YgSEtJRC4NCj4gPiA+ICAgKi8NCj4gPiANCj4gPiBD
b3VsZCB5b3UgZWxhYm9yYXRlIHdoeSBpdCBpcyBzdGlsbCBwb3NzaWJsZSB0byBoYXZlIG90aGVy
IHRocmVhZCByZW1vdmluZw0KPiA+IHBhZ2VzIGZyb20gVEQ/DQo+ID4gDQo+ID4gSSBhbSBwcm9i
YWJseSBtaXNzaW5nIHNvbWV0aGluZywgYnV0IHRoZSB0aGluZyBJIGRvbid0IHVuZGVyc3RhbmQg
aXMgd2h5DQo+ID4gdGhpcyBmdW5jdGlvbiBpcyB0cmlnZ2VyZWQgYnkgTU1VIHJlbGVhc2U/ICBB
bGwgdGhlIHRoaW5ncyBkb25lIGluIHRoaXMNCj4gPiBmdW5jdGlvbiBkb24ndCBzZWVtIHRvIGJl
IHJlbGF0ZWQgdG8gTU1VIGF0IGFsbC4NCj4gDQo+IFRoZSBLVk0gcmVsZWFzZXMgRVBUIHBhZ2Vz
IG9uIE1NVSBub3RpZmllciByZWxlYXNlLiAga3ZtX21tdV96YXBfYWxsKCkgZG9lcy4gSWYNCj4g
d2UgZm9sbG93IHRoYXQgd2F5LCBrdm1fbW11X3phcF9hbGwoKSB6YXBzIGFsbCB0aGUgU2VjdXJl
LUVQVHMgYnkNCj4gVERILk1FTS5TRVBULlJFTU9WRSgpIG9yIFRESC5NRU0uUEFHRS5SRU1PVkUo
KS4gIEJlY2F1c2UNCj4gVERILk1FTS57U0VQVCwgUEFHRX0uUkVNT1ZFKCkgaXMgc2xvdywgd2Ug
Y2FuIGZyZWUgSEtJRCBiZWZvcmUga3ZtX21tdV96YXBfYWxsKCkNCj4gdG8gdXNlIFRESC5QSFlN
RU0uUEFHRS5SRUNMQUlNKCkuDQoNCkNhbiB5b3UgZWxhYm9yYXRlIHdoeSBUREguTUVNLntTRVBU
LFBBR0V9LlJFTU9WRSBpcyBzbG93ZXIgdGhhbg0KVERILlBIWU1FTS5QQUdFLlJFQ0xBSU0oKT8N
Cg0KQW5kIGRvZXMgdGhlIGRpZmZlcmVuY2UgbWF0dGVyIGluIHByYWN0aWNlLCBpLmUuIGRpZCB5
b3Ugc2VlIHVzaW5nIHRoZSBmb3JtZXINCmhhdmluZyBub3RpY2VhYmxlIHBlcmZvcm1hbmNlIGRv
d25ncmFkZT8NCg0KPiANCj4gDQo+ID4gSUlVQywgYnkgcmVhY2hpbmcgaGVyZSwgeW91IG11c3Qg
YWxyZWFkeSBoYXZlIGRvbmUgVlBGTFVTSERPTkUsIHdoaWNoIHNob3VsZA0KPiA+IGJlIGNhbGxl
ZCB3aGVuIHlvdSBmcmVlIHZjcHU/DQo+IA0KPiBOb3QgbmVjZXNzYXJpbHkuDQoNCk9LLiAgSSBn
b3QgY29uZnVzZWQgYmV0d2VlbiBUREguVlAuRkxVU0ggYW5kIFRESC5NTkcuVlBGTFVTSERPTkUu
DQoNCj4gDQo+IA0KPiA+IEZyZWVpbmcgdmNwdXMgaXMgZG9uZSBpbg0KPiA+IGt2bV9hcmNoX2Rl
c3Ryb3lfdm0oKSwgd2hpY2ggaXMgX2FmdGVyXyBtbXVfbm90aWZpZXItPnJlbGVhc2UoKSwgaW4g
d2hpY2gNCj4gPiB0aGlzIHRkeF9tbXVfcmVsZWFzZV9rZXlpZCgpIGlzIGNhbGxlZD8NCj4gDQo+
IGd1ZXN0IG1lbWZkIGNvbXBsaWNhdGVzIHRoaW5ncy4gIFRoZSByYWNlIGlzIGJldHdlZW4gZ3Vl
c3QgbWVtZmQgcmVsZWFzZSBhbmQgbW11DQo+IG5vdGlmaWVyIHJlbGVhc2UuICBrdm1fYXJjaF9k
ZXN0cm95X3ZtKCkgaXMgY2FsbGVkIGFmdGVyIGNsb3NpbmcgYWxsIGt2bSBmZHMNCj4gaW5jbHVk
aW5nIGd1ZXN0IG1lbWZkLg0KPiANCj4gSGVyZSBpcyB0aGUgZXhhbXBsZS4gIExldCdzIHNheSwg
d2UgaGF2ZSBmZHMgZm9yIHZob3N0LCBndWVzdF9tZW1mZCwga3ZtIHZjcHUsDQo+IGFuZCBrdm0g
dm0uICBUaGUgcHJvY2VzcyBpcyBleGl0aW5nLiAgUGxlYXNlIG5vdGljZSB2aG9zdCBpbmNyZW1l
bnRzIHRoZQ0KPiByZWZlcmVuY2Ugb2YgdGhlIG1tdSB0byBhY2Nlc3MgZ3Vlc3QgKHNoYXJlZCkg
bWVtb3J5Lg0KPiANCj4gZXhpdF9tbWFwKCk6DQo+ICAgVXN1YWxseSBtbXUgbm90aWZpZXIgcmVs
ZWFzZSBpcyBmaXJlZC4gQnV0IG5vdCB5ZXQgYmVjYXVzZSBvZiB2aG9zdC4NCj4gDQo+IGV4aXRf
ZmlsZXMoKQ0KPiAgIGNsb3NlIHZob3N0IGZkLiB2aG9zdCBzdGFydHMgdGltZXIgdG8gaXNzdWUg
bW1wdXQoKS4NCg0KV2h5IGRvZXMgaXQgbmVlZCB0byBzdGFydCBhIHRpbWVyIHRvIGlzc3VlIG1t
cHV0KCksIGJ1dCBub3QgY2FsbCBtbXB1dCgpDQpkaXJlY3RseT8NCg0KPiANCj4gICBjbG9zZSBn
dWVzdF9tZW1mZC4gIGt2bV9nbWVtX3JlbGVhc2UoKSBjYWxscyBrdm1fbW11X3VubWFwX2dmbl9y
YW5nZSgpLg0KPiAgICAga3ZtX21tdV91bm1hcF9nZm5fcmFuZ2UoKSBldmVudHVhbGx5IHRoaXMg
Y2FsbHMgVERILk1FTS5TRVBULlJFTU9WRSgpDQo+ICAgICBhbmQgVERILk1FTS5QQUdFLlJFTU9W
RSgpLiAgVGhpcyB0YWtlcyB0aW1lIGJlY2F1c2UgaXQgcHJvY2Vzc2VzIHdob2xlDQo+ICAgICBn
dWVzdCBtZW1vcnkuIENhbGwga3ZtX3B1dF9rdm0oKSBhdCBsYXN0Lg0KPiANCj4gICBEdXJpbmcg
dW5tYXBwaW5nIG9uIGJlaGFsZiBvZiBndWVzdCBtZW1mZCwgdGhlIHRpbWVyIG9mIHZob3N0IGZp
cmVzIHRvIGNhbGwNCj4gICBtbXB1dCgpLiAgSXQgdHJpZ2dlcnMgbW11IG5vdGlmaWVyIHJlbGVh
c2UuDQo+IA0KPiAgIENsb3NlIGt2bSB2Y3B1cy92bS4gdGhleSBjYWxsIGt2bV9wdXRfa3ZtKCku
ICBUaGUgbGFzdCBvbmUgY2FsbHMNCj4gICBrdm1fZGVzdHJveV92bSgpLiAgDQo+IA0KPiBJdCdz
IGlkZWFsIHRvIGZyZWUgSEtJRCBmaXJzdCBmb3IgZWZmaWNpZW5jeS4gQnV0IEtWTSBkb2Vzbid0
IGhhdmUgY29udHJvbCBvbg0KPiB0aGUgb3JkZXIgb2YgZmRzLg0KDQpGaXJzdGx5LCB3aGF0IGtp
bmRhIHBlcmZvcm1hbmNlIGVmZmljaWVuY3kgZ2FpbiBhcmUgd2UgdGFsa2luZyBhYm91dD8NCg0K
V2UgY2Fubm90IHJlYWxseSB0ZWxsIHdoZXRoZXIgaXQgY2FuIGJlIGp1c3RpZmllZCB0byB1c2Ug
dHdvIGRpZmZlcmVudCBtZXRob2RzDQp0byB0ZWFyIGRvd24gU0VQVCBwYWdlIGJlY2F1c2Ugb2Yg
dGhpcy4NCg0KRXZlbiBpZiBpdCdzIHdvcnRoIHRvIGRvLCBpdCBpcyBhbiBvcHRpbWl6YXRpb24s
IHdoaWNoIGNhbi9zaG91bGQgYmUgZG9uZSBsYXRlcg0KYWZ0ZXIgeW91IGhhdmUgcHV0IGFsbCBi
dWlsZGluZyBibG9ja3MgdG9nZXRoZXIuDQoNClRoYXQgYmVpbmcgc2FpZCwgeW91IGFyZSBwdXR0
aW5nIHRvbyBtYW55IGxvZ2ljIGluIHRoaXMgcGF0Y2gsIGkuZS4sIGl0IGp1c3QNCmRvZXNuJ3Qg
bWFrZSBzZW5zZSB0byByZWxlYXNlIFREWCBrZXlJRCBpbiB0aGUgTU1VIGNvZGUgcGF0aCBpbiBf
dGhpc18gcGF0Y2guDQoNCj4gDQo+IA0KPiA+IEJ1dCBoZXJlIHdlIGFyZSBkZXBlbmRpbmcgdmNw
dXMgdG8gYmUgZnJlZWQgYmVmb3JlIHRkeF9tbXVfcmVsZWFzZV9oa2lkKCk/DQo+IA0KPiBOb3Qg
bmVjZXNzYXJpbHkuDQoNCkkgYW0gd29uZGVyaW5nIHdoZW4gaXMgVERILlZQLkZMVVNIIGRvbmU/
ICBTdXBwb3NlZGx5IGl0IHNob3VsZCBiZSBjYWxsZWQgd2hlbg0Kd2UgZnJlZSB2Y3B1cz8gIEJ1
dCBhZ2FpbiB0aGlzIG1lYW5zIHlvdSBuZWVkIHRvIGNhbGwgVERILk1ORy5WUEZMVVNIRE9ORQ0K
X2FmdGVyXyBmcmVlaW5nIHZjcHVzLiAgQW5kIHRoaXMgIGxvb2tzIGNvbmZsaWN0aW5nIGlmIHlv
dSBtYWtlDQp0ZHhfbW11X3JlbGVhc2Vfa2V5aWQoKSBiZWluZyBjYWxsZWQgZnJvbSBNTVUgbm90
aWZpZXIuDQo=

