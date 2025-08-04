Return-Path: <kvm+bounces-53906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D0AF2B1A243
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 14:53:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C95D87B011B
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 12:50:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FC2526D4CA;
	Mon,  4 Aug 2025 12:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H+inw+zo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2C126C3A4;
	Mon,  4 Aug 2025 12:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754311728; cv=fail; b=NwdzMTzQZUOkdZ6DUPHtUJlwVqTSsXXGYUK4Ap/NEJdeP5bJ8JRGn3S1Ix6uJkaLq8rSN9Co3urk5nYPPJLoHbahWP0/0WjrTWHh/VwNAD5VniB8NKmhZAIR1Ycgk5R5h7CF3dnoavSk0NMEdxnOWQmL2YKgLVaxfXl5WXtOvXk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754311728; c=relaxed/simple;
	bh=A/BReHi0wY+NpB422jomUJQDJtwUFFbFwiSk3Uy3dHM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fE8pgUIrAAQT9IkFlPjzwdGg2h5Cgk9wCBwa+4zFibycVjD9xDhWoRIZAq6aVp3Yi0zPVPWVE/mf4/DRcc+xEofV1eL6JvSWcp+uYy68OwxEqoJMcruA++y+VSZhRN5/ZET2Z7MU0th9zwajYzM9Q2B7OAvl5JXF7RH2EHqjm7U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H+inw+zo; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754311727; x=1785847727;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=A/BReHi0wY+NpB422jomUJQDJtwUFFbFwiSk3Uy3dHM=;
  b=H+inw+zo0WJHrPb63FkXQHuVXCa9WnCCa/yFsi3FZ7a2PdOlkdjyhB0K
   YTQX8PiiHRs7Hjdc/Adm7KS90R441aR75DukJRpBlcTMGbIGYp2vc0fwH
   3BIuzpO67XaRDmeDAXJraCussxn8lr+jOLxWkcjimwiPuthBzfG8qECaB
   twuDwJHswg7URMyTC4aIlPY5TWaLZ2jg0fMhYtl67NdS2yrEpfkd4uTHE
   ixUM7pZowZGDWBEwlOigWHu+ESE9q5XSeyVh/hawUONqa+hTuHlAbLHCO
   ha0pYSR2HysLPanD6tzEEN2ws9QQo7tJtE95QIMOA5mRvWXI8zV9MD2Rf
   A==;
X-CSE-ConnectionGUID: ZRErGucTTxGVQ7YL5BLP1g==
X-CSE-MsgGUID: b+U4mU/sTkKz1/4jqqLmrQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11511"; a="67151298"
X-IronPort-AV: E=Sophos;i="6.17,258,1747724400"; 
   d="scan'208";a="67151298"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 05:48:46 -0700
X-CSE-ConnectionGUID: SkCgK2bxTWCsYp8gE964Vg==
X-CSE-MsgGUID: igBi35RuTq+yME88wsVpQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,258,1747724400"; 
   d="scan'208";a="194988154"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 05:48:46 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 4 Aug 2025 05:48:45 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 4 Aug 2025 05:48:45 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.53) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 4 Aug 2025 05:48:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JIctwe/XisqYQnKC35Y1/lTTJmeGO03ELsS/QT8Hz8E6HiUlcLr4u6mcAiz5Gam4e6+e1JSoKK9ExG/wkyR3g+FrNTMnklbLCTLBVssRJjtS3E4WbWOW8HoCwg49Ccz3EIWx6HG3SD35OMwJYILT5mIwkGUzujPRr8AE7CdQvJWob6f5HYFN280IScllBIelbx7GAfp1xh6M9ASgl3I7sb5dOf3KRk6rQ9KQobMLCF9pSkXWUHY5K0lIin6tVmjhqDBQRr2ytB6EV0AKf1kPwzpTMtLmf6nhfVJabYO5NKUbufzaYkeBlUWEcE+C1CAoq4Ajno2XVWGTprnq3JN3UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A/BReHi0wY+NpB422jomUJQDJtwUFFbFwiSk3Uy3dHM=;
 b=Jx3tshSwaGQTHh/U2yRUWLeRSZX2ljQ43boQEGj2eq6MjN8T334zVXsnbeM64C18uxzM11HXYirgdJ5fC0/RNV/YKqQ/2kp2z5N0H5WeVSEUCpXVX6qHG0Ff1q1S7fvnOj8z+0UKPLKfhDqojjkStZN58qpTrwLbA7NfdPQU9BO4OZT6oYSa1CF0hWFk54Kh2L/0n7hwSil+n9kkggl94q0WP6LXRXRcTDneIiTQT2u9dOhaHUXsgstqpVDFdMJ7Fg/eS4x3QpboKFAnR3HUC/E2bsllmSHKEqJYyN+1v94dD6brxiJKYqGK7szVwa49ir01kcrFIOynlX/EuctGVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SA1PR11MB6992.namprd11.prod.outlook.com (2603:10b6:806:2b6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.14; Mon, 4 Aug
 2025 12:48:42 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8989.017; Mon, 4 Aug 2025
 12:48:42 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "ashish.kalra@amd.com"
	<ashish.kalra@amd.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "dwmw@amazon.co.uk"
	<dwmw@amazon.co.uk>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"sagis@google.com" <sagis@google.com>, "Chen, Farrah"
	<farrah.chen@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, "Williams,
 Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v5 7/7] KVM: TDX: Explicitly do WBINVD when no more TDX
 SEAMCALLs
Thread-Topic: [PATCH v5 7/7] KVM: TDX: Explicitly do WBINVD when no more TDX
 SEAMCALLs
Thread-Index: AQHb/7MOR889ZY71CkeJQC7E1tlzFbRNfc8AgAT+/oA=
Date: Mon, 4 Aug 2025 12:48:42 +0000
Message-ID: <44f6227778731f4e9b705320846879369ea27d96.camel@intel.com>
References: <cover.1753679792.git.kai.huang@intel.com>
	 <c29f7a3348a95f687c83ac965ebc92ff5f253e87.1753679792.git.kai.huang@intel.com>
	 <aIx7Qlpi1Y/VsRVY@intel.com>
In-Reply-To: <aIx7Qlpi1Y/VsRVY@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SA1PR11MB6992:EE_
x-ms-office365-filtering-correlation-id: 68106ea9-3641-4b67-ec82-08ddd3553e1e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cEFKWkJrazBscG9DM3ZYaklJYXFqMzFKMHE5YjdiNTB0M2FNWDU5dFBxQ044?=
 =?utf-8?B?L2kxblM0K3RPaW0vSEJFT1FyUm9jZGFIQ1E1VUxDWEpCeWMzbjMrangwcjcx?=
 =?utf-8?B?UDNvbE45azBFMzJjWGVld2ttWHp5Y2d1YjBXQmphOW1RTXNPc1pSNWJIdm4z?=
 =?utf-8?B?OXovYzV2NS9HODFJNGhBUGN3OGhtbEFjNzdIQ1AxUldVQVpuN0hCcEhsMEFX?=
 =?utf-8?B?V3VYUjIyelpZS3BzUWY2ck1tdjBQMlRCeUZIVXVTTkhUcWM4QThmbnZoV1pz?=
 =?utf-8?B?ZHhZMmZTZ1hoNjVvRjRaYUk1bHdIT0JVeVBsK3RPU1pwYnQ4a0R3ZUVlckJq?=
 =?utf-8?B?ZjlyUlJjbXIxRTdOUXhaN2VodXZvUjVDYjN5VE9seXpZQkhnWG9qM3lJSHdM?=
 =?utf-8?B?S1Z5bU90NXhLeHpUWm91dzhPUzZSd0NsM0ZvaFNNRjZtNkRuV1Z6QXlpcmVP?=
 =?utf-8?B?WUhUN2k2RFpYV3Jvc2FtVEY4T1F3bmFuV0EwUmIzeGlUd3pIQmpHa1VNOGkz?=
 =?utf-8?B?UkQwMml2ZXFSNmIyS3NKQWRDOFF6Q1p5WnVLYjh4bWxWaE5heVQyaDR6WEZ1?=
 =?utf-8?B?YTNmRFQxc3ZzR2gxRnJoWGpjaVIrYnd4OUxIUHJrNjUrb0dEWldQQWZ6K25Q?=
 =?utf-8?B?engxV0o2NGlUYlhSQjQ2Q2NoQWMydkpEdFA0SDRWL2h3NVFTOGFJd1ZCdC9G?=
 =?utf-8?B?OGVtcnFWa1lJWUYvUnpGa1I0U2xlbnV0amFIZEJheDhNZjF2em1rWS84cmdN?=
 =?utf-8?B?Y0JxUVh0bTRUUlNsd3drbW9HUUJqa2IwL3Rnd1ZRK1l5RnI1ei9kWHp2MU1G?=
 =?utf-8?B?cUFSQzB3LzhXNDZRYVR3UWVVaXlJTFlRM05TM01PQnJ5L3RZa1Jhbm5KL2xP?=
 =?utf-8?B?MG9EaWJrMjlMU2EwcmdGN2lhSnZuWk1lMys4NlZUZ0F4ejBNZUdubERNeFJk?=
 =?utf-8?B?cVIvem1EKzNKN2hUZzY1Y0V0QWVaNXBNeVdGZENsZE5md0x3KzRBQkZYNVYv?=
 =?utf-8?B?bzVCQUMvYWR2a2pmK1ZZOXd3NStqRWFDczYra0ZKOE9ENmErU0MxNWprZFRI?=
 =?utf-8?B?eFd2UkZBZE1aZFJmOTJibTVsYTRUMmk5WGo3djluREZLbTA3NHpsNVFUWXhs?=
 =?utf-8?B?M0NQZEpuMmVVZG8zdHhlS2U1Vzg3YUkwV09ySWI0U2lRTEthVDkvNjdja2pC?=
 =?utf-8?B?a2lISDlVUkxYdmRRYW1CMWkvQm9OMk1MdlpjVnpwWnU1TUxsenAvdmxmSWxn?=
 =?utf-8?B?aEFGd3hLSjFHYnp4WGNaNytCWlNIemlxa2dMMjlBU0hySmFIZnVNMFliZ3h5?=
 =?utf-8?B?YXQ4czZBajZqZFVpakdKMzBNVWtHVXo1dUtjZmM2dkdVdW5TWW93bHpDWWFu?=
 =?utf-8?B?S1hwWXR2T0VVK05hUVpiYU5BK1pGOHIrVFpMa24rRGpTVit6SWxodSszZGUr?=
 =?utf-8?B?cVZPQ3lmOFh0SEtrL3R2bURpenhrTlFsUXd0M2FmNUo2MnEzNWdkOFRBTzdU?=
 =?utf-8?B?cEFxKzRkVGp3K0xFVy9oK1FvQmRuS0x2S0ZlNWh5RGtFZEpIWFFEdmdNRXRD?=
 =?utf-8?B?REhkbjlKaHI1dUhhcGlVS2RGKzVjelZpYzZMZDNXWlJPeEFCNVNwbnN3MUwr?=
 =?utf-8?B?V09wSS96Y2FjUU84VENFV09HTExoNVhIOHF2bm9YSnRpVG5xU0VxWmxGSEZU?=
 =?utf-8?B?YW1XS3J5UTdOZnIrTmc5c09GeUZlaDhQWlhOS2JyOG9FcHI4SmhtbnkzZVlr?=
 =?utf-8?B?WnNXUnBHOFdNZnJHSlpKb0d1SzFrUjlCT1B4S0RtS0V5cFdTd0tXVWtNV3ha?=
 =?utf-8?B?S3VJQzhHRGZHTVkyNW5TWkJ4R0N4YUhxSlhRUHlHUzNCa1ZqSkZlbitNQ3da?=
 =?utf-8?B?d2p5V0JSQ2lXT1dUYmhMdFVBRUZWRmhudkRRWHl0bUZvZjN1cUJhTG5DcG9h?=
 =?utf-8?B?by9nRjIvMlpkZEp5WlhCdGtLTW9VaDlaRk9pWW1uaXBnRDZ2dTY3MTUvZ3NH?=
 =?utf-8?Q?hPk9HcnM4QRok3wwgkTAzMF8g2q1wk=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MFJ5TGt5SUtPT2RMdC9KSGhoOW1PbkVFUU1reEEzSy9IWWgwaGRtN1U4RXV5?=
 =?utf-8?B?dkx0ZWQvczI0bGpGL0hqRjZmZHcwa0JzMzV4V1RkVFdYY1FXS1V3aUFRbVFP?=
 =?utf-8?B?SVVlYUQ3QVVsVHdKK0FqeW9rckRyRFlYY3hCRmNuYlNSUWNwZGJkU0xZWFNz?=
 =?utf-8?B?b3RpT3NscFlKVjVFaWpQTDhFSDJISzkyKzB6MHloWEVGRURTWDk3dm5DNUg5?=
 =?utf-8?B?MVltenAxWS9rdjUxZnJScVBvcGZxa1pHeHUxNy8rbVJIU0FYWDRuc1drRzhv?=
 =?utf-8?B?cGZaaXhqMndCUDVVQnMxazBsTEppVFczVVFWSlJ5N3JhMkV2b0ovS1hhWHJ1?=
 =?utf-8?B?UVhHaGVjOWdSV3lkSWpYOVVBN3dHYlp6dGxhRkZ2SXRHcGZIWWtsUTJObmhp?=
 =?utf-8?B?c2lhRU1wTllxQm9FWjcxSmI4aEV3cUwvNG16REY2NVZwdkRFVkI0aExXTU9C?=
 =?utf-8?B?UVZIODZOK0R4c1ZYR2loYXA3WDlPVE8rTFpnRTkzc1k2dFduTWtKb1JxNTdO?=
 =?utf-8?B?WjI3MGw4MXhGUTRpTGNQcmNlOTFqNGZtVERZNUFpVk5UWlN3RkRNa0tnYTJp?=
 =?utf-8?B?WFVyZGhpVTE2ZDh6MDZEMW1sdlF4UVBPZVZXcWlza3oySmpURWNqNzZXTGhw?=
 =?utf-8?B?a1lhSVVnMUs5NGk3d0JxWWJnTTNyemxsL1pTUDJOUDg0cFlSR2JVZVR3QlJs?=
 =?utf-8?B?akpqTWo5Z29vZlROUWs5VHUyamczZVY3cHFia1ZoTmVOa3h6dmsxdzh0eUVq?=
 =?utf-8?B?MDBDWG9hRm9LZmpDckhJU1dyTGZiQ2dCeDhwYjJ0YkNXWDBYTGh6NVVVcmJ6?=
 =?utf-8?B?TCsrSUpMNzd0WnBUbmpOejJRK3AvMDg0OGtaUFNwWVpOUEpXemd5REo2QWJU?=
 =?utf-8?B?cTVCc0NCb2wwVUxPdjVodUgwdG04Y28yYWhZdi9CdThBNDQxUklRU3J1T0VH?=
 =?utf-8?B?QXhQd1BLM2dZeFZvWFl1cmRUaGt4REFzUmROUGltVHVjQzluYlBZT01JQmxu?=
 =?utf-8?B?QU0yM040ZU5xRWdRNVM5M1FpeGNEcE9ueTc4bE5ZSXNCNWZOc2c2YjRodFpX?=
 =?utf-8?B?M3Iwa3YrVzMwK21WTmdzZ3FrZ2ZoaUhFU091aUVTUFUyTzRJVURuQ00yUzBq?=
 =?utf-8?B?Y2FxcUNNVWRTVTdLeU9BYmsyd1hhTlNGN3UvcW9ZQTVQVW05cEh6MVk3Tys1?=
 =?utf-8?B?VzlIZ3R3S0I1WEJuUDNBeU1QWjhxOGx4d2lEYng1TEhiUVVUQnVJNmpISGc1?=
 =?utf-8?B?bXlwS2U4ZFZxMGhOcjIyL21VTk9PbUlWTmJ3OVpzRlNwOHpiRXlnaVFvSmpz?=
 =?utf-8?B?T2hMNldHRjkvN2xTZ21ickVucmNwYVhWV3FlNlFYUkN1Z2hZMEZhakIyREZo?=
 =?utf-8?B?TGh6b1VvUWlvaFZpOWJ1RTdOaDZ1WE9QQlk3K291L1lBbjFnT0RubjFKVFQx?=
 =?utf-8?B?V0pZeTN5U082MGlmc2hMQ0piZkdEd3dPRVpYUFY2d0w2cW01WnBLTVNaR3ZK?=
 =?utf-8?B?VDdMaWRqMURweEtYbVpib1IxTFg4bjZwM0gza1VyTG1PQkZtZWRCZzlRbXpk?=
 =?utf-8?B?VFFhNHBuK1kxRXNyaUtITGJ3aU9GbFE3cGIrKy9pc3d4M0RkZkRXM2xxVkRD?=
 =?utf-8?B?bXI2RFdnNkh1SWpoRnNxdjU0allQb2orUTgwaTdvMllFbExTM3ZvdExqZU1i?=
 =?utf-8?B?MzVlSkM0MlRaY3BJVUdNU2NieVBFUmgzMnRsbE91WDF4Nkh0ZWJJc3VEaEJq?=
 =?utf-8?B?WjVHbEp0S1ZXc1B5OXh0bk5PWXdIMkt5UFFpRk5MSGIwMWdtQkhTMWJIWUMz?=
 =?utf-8?B?MHpOU2pYWnAzZnRXV050b1V0ZlFHOFpKTDBIWTV2OHVRVlYyNGVLdS9aam8r?=
 =?utf-8?B?NVJCZFhYdmRJeHlSY0hDNTEycmZVYXhoM21yMVV1a1N0ZzlyMWlpVWF6TXpT?=
 =?utf-8?B?ZnlPWVlKbVAvbzk5Qm9rVzNmcmFFaTZlRnIvcmxMNzV3WDlDZzRudmwvUzZN?=
 =?utf-8?B?KytoOHB1THJPRnJIb0l5VU5pRUkyWlJxU1NMdzhWK200cU42b0F0SGxKVkhk?=
 =?utf-8?B?a2NUd2xndmphbUxrbWxuQVIwMUROc2VGSVQvVXNSSnNzcC9IOHdhMXNxUEdu?=
 =?utf-8?Q?VmbCp6D9kSbpeI8X7OeGY997G?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <447D93A38F9F5148BAD91A4238FB226C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68106ea9-3641-4b67-ec82-08ddd3553e1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2025 12:48:42.4351
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: abtZDSFEc0xl2wbrMAcYPHxDPTl5TkzW0hx1xSZjiE0pT24Jx3h/G6Scm7U/rKxd8oNvdht6cBkKtYhLjC0W6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6992
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA4LTAxIGF0IDE2OjMwICswODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gT24g
VHVlLCBKdWwgMjksIDIwMjUgYXQgMTI6Mjg6NDFBTSArMTIwMCwgS2FpIEh1YW5nIHdyb3RlOg0K
PiA+IE9uIFREWCBwbGF0Zm9ybXMsIGR1cmluZyBrZXhlYywgdGhlIGtlcm5lbCBuZWVkcyB0byBt
YWtlIHN1cmUgdGhlcmUgYXJlDQo+ID4gbm8gZGlydHkgY2FjaGVsaW5lcyBvZiBURFggcHJpdmF0
ZSBtZW1vcnkgYmVmb3JlIGJvb3RpbmcgdG8gdGhlIG5ldw0KPiA+IGtlcm5lbCB0byBhdm9pZCBz
aWxlbnQgbWVtb3J5IGNvcnJ1cHRpb24gdG8gdGhlIG5ldyBrZXJuZWwuDQo+ID4gDQo+ID4gRHVy
aW5nIGtleGVjLCB0aGUga2V4ZWMtaW5nIENQVSBmaXJzdGx5IGludm9rZXMgbmF0aXZlX3N0b3Bf
b3RoZXJfY3B1cygpDQo+ID4gdG8gc3RvcCBhbGwgcmVtb3RlIENQVXMgYmVmb3JlIGJvb3Rpbmcg
dG8gdGhlIG5ldyBrZXJuZWwuICBUaGUgcmVtb3RlDQo+ID4gQ1BVcyB3aWxsIHRoZW4gZXhlY3V0
ZSBzdG9wX3RoaXNfY3B1KCkgdG8gc3RvcCB0aGVtc2VsdmVzLg0KPiA+IA0KPiA+IFRoZSBrZXJu
ZWwgaGFzIGEgcGVyY3B1IGJvb2xlYW4gdG8gaW5kaWNhdGUgd2hldGhlciB0aGUgY2FjaGUgb2Yg
YSBDUFUNCj4gPiBtYXkgYmUgaW4gaW5jb2hlcmVudCBzdGF0ZS4gIEluIHN0b3BfdGhpc19jcHUo
KSwgdGhlIGtlcm5lbCBkb2VzIFdCSU5WRA0KPiA+IGlmIHRoYXQgcGVyY3B1IGJvb2xlYW4gaXMg
dHJ1ZS4NCj4gPiANCj4gPiBURFggdHVybnMgb24gdGhhdCBwZXJjcHUgYm9vbGVhbiBvbiBhIENQ
VSB3aGVuIHRoZSBrZXJuZWwgZG9lcyBTRUFNQ0FMTC4NCj4gPiBUaGlzIG1ha2VzIHN1cmUgdGhl
IGNhY2hlcyB3aWxsIGJlIGZsdXNoZWQgZHVyaW5nIGtleGVjLg0KPiA+IA0KPiA+IEhvd2V2ZXIs
IHRoZSBuYXRpdmVfc3RvcF9vdGhlcl9jcHVzKCkgYW5kIHN0b3BfdGhpc19jcHUoKSBoYXZlIGEg
InJhY2UiDQo+ID4gd2hpY2ggaXMgZXh0cmVtZWx5IHJhcmUgdG8gaGFwcGVuIGJ1dCBjb3VsZCBj
YXVzZSB0aGUgc3lzdGVtIHRvIGhhbmcuDQo+ID4gDQo+ID4gU3BlY2lmaWNhbGx5LCB0aGUgbmF0
aXZlX3N0b3Bfb3RoZXJfY3B1cygpIGZpcnN0bHkgc2VuZHMgbm9ybWFsIHJlYm9vdA0KPiA+IElQ
SSB0byByZW1vdGUgQ1BVcyBhbmQgd2FpdHMgb25lIHNlY29uZCBmb3IgdGhlbSB0byBzdG9wLiAg
SWYgdGhhdCB0aW1lcw0KPiA+IG91dCwgbmF0aXZlX3N0b3Bfb3RoZXJfY3B1cygpIHRoZW4gc2Vu
ZHMgTk1JcyB0byByZW1vdGUgQ1BVcyB0byBzdG9wDQo+ID4gdGhlbS4NCj4gPiANCj4gPiBUaGUg
YWZvcmVtZW50aW9uZWQgcmFjZSBoYXBwZW5zIHdoZW4gTk1JcyBhcmUgc2VudC4gIERvaW5nIFdC
SU5WRCBpbg0KPiA+IHN0b3BfdGhpc19jcHUoKSBtYWtlcyBlYWNoIENQVSB0YWtlIGxvbmdlciB0
aW1lIHRvIHN0b3AgYW5kIGluY3JlYXNlcw0KPiA+IHRoZSBjaGFuY2Ugb2YgdGhlIHJhY2UgaGFw
cGVuaW5nLg0KPiA+IA0KPiA+IEV4cGxpY2l0bHkgZmx1c2ggY2FjaGUgaW4gdGR4X2Rpc2FibGVf
dmlydHVhbGl6YXRpb25fY3B1KCkgYWZ0ZXIgd2hpY2gNCj4gPiBubyBtb3JlIFREWCBhY3Rpdml0
eSBjYW4gaGFwcGVuIG9uIHRoaXMgY3B1LiAgVGhpcyBtb3ZlcyB0aGUgV0JJTlZEIHRvDQo+ID4g
YW4gZWFybGllciBzdGFnZSB0aGFuIHN0b3BfdGhpc19jcHVzKCksIGF2b2lkaW5nIGEgcG9zc2li
bHkgbGVuZ3RoeQ0KPiA+IG9wZXJhdGlvbiBhdCBhIHRpbWUgd2hlcmUgaXQgY291bGQgY2F1c2Ug
dGhpcyByYWNlLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5n
QGludGVsLmNvbT4NCj4gPiBBY2tlZC1ieTogUGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0
LmNvbT4NCj4gPiBUZXN0ZWQtYnk6IEZhcnJhaCBDaGVuIDxmYXJyYWguY2hlbkBpbnRlbC5jb20+
DQo+ID4gUmV2aWV3ZWQtYnk6IEJpbmJpbiBXdSA8YmluYmluLnd1QGxpbnV4LmludGVsLmNvbT4N
Cj4gDQo+IEZsdXNoaW5nIGNhY2hlIGFmdGVyIGRpc2FibGluZyB2aXJ0dWFsaXphdGlvbiBsb29r
cyBjbGVhbi4gU28sDQo+IA0KPiBSZXZpZXdlZC1ieTogQ2hhbyBHYW8gPGNoYW8uZ2FvQGludGVs
LmNvbT4NCg0KVGhhbmtzIGZvciB0aGUgcmV2aWV3IChmb3IgdGhpcyBhbmQgcGF0Y2ggMykhDQo=

