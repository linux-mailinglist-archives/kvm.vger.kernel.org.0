Return-Path: <kvm+bounces-48065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DE85AAC858C
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 01:55:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A354E1BC7AD1
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 23:56:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CF5224EA8D;
	Thu, 29 May 2025 23:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IaEcUDtz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1CE21B1AA;
	Thu, 29 May 2025 23:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748562945; cv=fail; b=nBZhA+AeuRNpnTra4B++6bjg4ftQmfjrpQmTUf+zzkxcTGYsWShr7YEP2q3LohzUn8ZxN0rhicBg6DA3g6xNwaryQ6z3x/u/pSO6rVfzUSevQZ+ElUpV5X12EsMqcPe9L6addhgnOM68tzYBvxSsW3N+J4CcGH1CKFAZeDeusBs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748562945; c=relaxed/simple;
	bh=pNBlzEzA20qPBcEm7ffAkEHL3LH82KAnkb52VXB8mNc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LYhoAWBf1CpEqoUl7+8Ytg/8VwWiO+1MlQbwjDxmKLMzMbfVrITs/ISjNoYxh8tjMtCDbIySzBaVA9+IPIDCb+yTuAbvHmHCx7T7gWSkQtH5sLgUJgpDgn+Oj3+cv/2zNuqNT285/x9ezwUf8OWUiuGsLe7a+evrS103wSdRA48=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IaEcUDtz; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748562944; x=1780098944;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=pNBlzEzA20qPBcEm7ffAkEHL3LH82KAnkb52VXB8mNc=;
  b=IaEcUDtzG0xVw7K2rkwHWFhz7BuvVtpu6E4x460EOq3nsb1O3pPTiXCP
   8UwDGhqv0nRWvYyERIRMpUk4CpssRfb5Ow0WK3lXqk1UF4JSQM9N+QO/T
   agsO1bTa4mKI0tQcjbN2P314kVYPc3h+L+yhFD249i+ovAXU6hYsQhGYm
   Z3y2gJJdFAJH/QZ9VFMe3eXjtIHV2X0INtmphwHl/PeH8Xh41lYytuPjl
   PsRqwRmHmXGYsTdhRyA4659KL+7DGbMqcAojx9pCM+bTxpeT5QaAUJSpj
   N3HH4kSoQB5Nf+4T0mJzm4SnA8zxm22JhBbkrqQfFgfGqC2VAVNwp28on
   Q==;
X-CSE-ConnectionGUID: uWN6rGxQRPqvTRgPW40o+g==
X-CSE-MsgGUID: 6US8B2/WTq60i4pdKRZUQA==
X-IronPort-AV: E=McAfee;i="6700,10204,11448"; a="50699704"
X-IronPort-AV: E=Sophos;i="6.16,194,1744095600"; 
   d="scan'208";a="50699704"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2025 16:55:41 -0700
X-CSE-ConnectionGUID: bpdcj1bKSta/Sipq7UtbAA==
X-CSE-MsgGUID: 0giS9qubSZOIsCxZFdzCQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,194,1744095600"; 
   d="scan'208";a="148575344"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2025 16:55:40 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 29 May 2025 16:55:40 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 29 May 2025 16:55:40 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.62) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Thu, 29 May 2025 16:55:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Laq0MIJEbSGNpampuvJnsdZ7Ee0Ohhqo+J6X4NYS8ctqyiL+wNd3jbDuNgsG+tLdUwRsiIS2ZgSgWyZrigjdg/sP8wi81Bv9giP4e2RXyiK/em3e9GMUy3jR/TYM77NzT1DO0J+DdUZ1lyIeISGTlHhyF0WJhyO8nrsarq9VF5XDoxXO5jUlt4dyXUgnTDEJqagWhUkha9dAa9rR0IhNozBnu5QyB1EfMtd29YwKBp/lczzLFsRwiC98VKZvtfMtL3F9TCtE3S7ITm08wRJaIgGAR2dYfv1oKiF8oUvrXJw++oN9keZVz7DGVKniWUYNXZRAfbXxwGRyaiuE+EAhbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pNBlzEzA20qPBcEm7ffAkEHL3LH82KAnkb52VXB8mNc=;
 b=J1iiWPz6qT8ufk8gb6gHHfVOSU5QUqb5lVtqOdxuc5A5X12tAbRdL/HP+TqT7HRIE7Twm48whSKK1Fd4votRTytyQ+hiSkO2cjy19gd2BoJ8p71A1EFb55GCOqGydjt7vAIMcEdQ41ySH789H98V32fjDObStuuc2d8ARka5lvKE/XlWbv0YeiyLFWTOoK08wHgaU/SZPIFaqsdLpB/V0Iu7nKtf87Hr4WiCxb4UPWt+kZ/8lW8DYJLLTuaaxWbdElLKdjx69xBjEnwHrVJUuaivX4OLaY4MegdNZBtQv/+ME1W6eCexDkvR1PMD3bfJixb4BoPQP5UL28HzLBraKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CO1PR11MB5169.namprd11.prod.outlook.com (2603:10b6:303:95::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.31; Thu, 29 May
 2025 23:55:11 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8769.029; Thu, 29 May 2025
 23:55:11 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "vkuznets@redhat.com" <vkuznets@redhat.com>
Subject: Re: [PATCH 11/15] KVM: x86: Add CONFIG_KVM_IOAPIC to allow disabling
 in-kernel I/O APIC
Thread-Topic: [PATCH 11/15] KVM: x86: Add CONFIG_KVM_IOAPIC to allow disabling
 in-kernel I/O APIC
Thread-Index: AQHbyRYxNH/GJBJvrUmF7CZUp+ur/rPpjuOAgAAAgICAACsbgIAAi6uAgAAEvoCAAA0fgA==
Date: Thu, 29 May 2025 23:55:10 +0000
Message-ID: <5d659b1e14ce4862dbb77ad97c6341fa149376ce.camel@intel.com>
References: <20250519232808.2745331-1-seanjc@google.com>
	 <20250519232808.2745331-12-seanjc@google.com>
	 <d131524927ffe1ec70300296343acdebd31c35b3.camel@intel.com>
	 <019c1023c26e827dc538f24d885ec9a8530ad4af.camel@intel.com>
	 <aDhvs1tXH6pv8MxN@google.com>
	 <58a580b0f3274f6a7bba8431b2a6e6fef152b237.camel@intel.com>
	 <aDjo16EcJiWx9Nfa@google.com>
In-Reply-To: <aDjo16EcJiWx9Nfa@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CO1PR11MB5169:EE_
x-ms-office365-filtering-correlation-id: 128b7b25-9eac-4337-4e41-08dd9f0c3f29
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TkoyeE9yMFZlcDNCbU5HM1paa3ZIekNZenc1dkxsclJTa2FqVE1PN2UzRzlY?=
 =?utf-8?B?bTluRWRJd1h2aGhtNzZYeXVkMmJTYktqYk1GTVhQVUdLYkYxazdLR2phU1Fu?=
 =?utf-8?B?S2NndmM1NGdVUXNaODFzMDdLKzNHeWJnMmlreWViVlRVbzR4OG1rVjRJeHdw?=
 =?utf-8?B?SjNPWGpETjRvV3NXbnNXZURRUy9xZUVHMnMwbW1jcHpCRjQ2dWhwLzBsVTFl?=
 =?utf-8?B?S0ZLYWZ3N3U2eEo0Vk5ISnd3WXF4ZENsUXN3NnlhZDgrYXdPd1J5Rnc3QmJY?=
 =?utf-8?B?OU9EcDQ2SHk1cVJkRlBWSXN1ZENvMXZXeHMydnZBTlpPQWZFazQydDRPaTdq?=
 =?utf-8?B?L01lMW9jYkc3TVZ2ZjJ0b1ozb0p0TUExR25nN3Qrcy9KSEdQMjhEblZka3Mv?=
 =?utf-8?B?VHVqWGhaNmZXdFA1SGw0aHBpeHpUMERCT0w4SHJObk5kZ3hjS0N6Y095d0Zh?=
 =?utf-8?B?akpHaXhrNWFpajFCcTJpSm84cUNFVWpFbkpacjdTdFZQbVZPMk9za2xUU25n?=
 =?utf-8?B?Z2FiSHRCeTdYU1M0S3lUR1IzYnpJZEJKbEFzeS95Z3p5dnVLU2k0Zno4d2Ur?=
 =?utf-8?B?QVBRTEp4ODByK3NUN09mUlh2TW5SanF0dlJRQXlSNzFQeDEvdzB4ZzJqaHUx?=
 =?utf-8?B?WHE3bHBsU3E3bWtkQ1pSMG9LVUZvcm83ZlE0ZGZHNTkwQzJ3TUV2NDRGdFhL?=
 =?utf-8?B?QzUwbVJFNGZUME1UYXlpb1BRWXBXQXE0VU1DaU1LWVFJNTFQUUV5S0gzTllR?=
 =?utf-8?B?K0FseTQrSmwxZks4Q001cDlOcGRGelNqQThFeU1uWC90NkNtRXAzNjFweCtI?=
 =?utf-8?B?TnhqUEhOTFI4QzQrU2FVWWlOODA3d2pxRUhrekd0K2l4b3lGaTFhUGdjR3Rj?=
 =?utf-8?B?V2E1M1ZVa21NZ0Z5M2txOEVuaVNkNC9VRVdtSldNTkljKzlxQkt0eE9LY05X?=
 =?utf-8?B?NjZSTFlzelV3djVna2Y3MFpxNndaNndKbE5tdkRRTldBUWRXU1dLdW5zdXdD?=
 =?utf-8?B?V1VpSUlIV29RVCtvM3l5cndHSXBnZzV4VFRjUFJzRXYrajVuSHJYZXFlTkQ4?=
 =?utf-8?B?RDBHRDhnTGVOTVRoS0hWejJONndKakxtS09RYnNwNWs2SC8vQjZubTd6cEQz?=
 =?utf-8?B?MGQ0ZW1zdUQ4dVV2R25RME11cCtKbGgzVGs4K0hpNkxaaHJyV2JrZFR6bElC?=
 =?utf-8?B?ZUhYbnZZbUIwcUxBTHBaWnFIeEZGVTVTWjgwbks4VVEveDNkQXpMZWtnTkNz?=
 =?utf-8?B?b0pra2ltODh2N2U4VDNYbVZoOFp5eGp5amZzWHozL3FUTVYyMEdUZXZqZ29O?=
 =?utf-8?B?b25iWHBXOGw2eFpkQTU1M2I1SDZkM3BQL211cTd0bXJvdHpKOTJWL2R2dWZH?=
 =?utf-8?B?RUpwMyswZTgwZnRnd0ZHc2dSdUhpVDRUNXBrQjNqU1RJWlptNzU4UUdXdTVh?=
 =?utf-8?B?TnBRRllTMHZDZ2FoU2hxeEFyNFFhdDZXQnVFQWI3dVI1aFlXRzJwV050K3gy?=
 =?utf-8?B?WEo2ZmdtZGNpblJ0NC9JbXZkVDdyZ2ZuUUFHWkxQVzIxaDlzWFU4UEZjNDNW?=
 =?utf-8?B?MTJHVVVNM3pJZlJDYU5tLzBsNk1kQmQ3cmkrWjR1UDF3dDVFRnk2MXA4RGZG?=
 =?utf-8?B?ejRjekF5bHNlS2N3VzIvcDVEWVdNdDdKYTVNcXFBWEJ3VGJWZFluWm9RZDJV?=
 =?utf-8?B?VHRPVVZPdW9zRmQwWTZQWFMzeHhhOFJ3YlV1MDAvUVBjUG54SUZWY1FNSEFY?=
 =?utf-8?B?cXoxdHhCYXlLR2dQUnBrQWZTOStvMHVlaDVjL0pEc1F0N3ljU0duQ1M3eXJ4?=
 =?utf-8?B?Q3dqMFhvQXVST2E1TUFrL203Ni90ZFVNTDlOVENKSnlNeUlabUZWS3Q2eFN3?=
 =?utf-8?B?aVhrejkyMStkaGgyWWNVa1VKWFF1czhjTTUzaVplK0dwckVkcEMyYjhoNDlj?=
 =?utf-8?B?OWdja2dVdjFnK0NML1hybjlBcTlvTk5hRjkwbDNoOXBEd0prbXBuQWlUY3pU?=
 =?utf-8?Q?NsFjVkHJ4YyQ0DAPN51k6g5ImUgl2E=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QVViMEcrenk4ejFLTHF4MWxtUVpUUFhySUdSMVFHV3ZuQ3N0UHFhRU40RkMz?=
 =?utf-8?B?dG9sQUYzKytjYkFUaDVvdE4zVDE1U0FNUlhoU1BOUkNGYU45S1VORUppM2Fl?=
 =?utf-8?B?MFJiU05LS1d4ejg3K2ltWkdvbWgwSTRueXpaTzNPaFB4Z0JhL044K3RiRysv?=
 =?utf-8?B?WXliSEVMOC9selA1OWV2YmtTR2sxTDRXTjFNdjhvQitRZk5uSU9nRDUvVHB6?=
 =?utf-8?B?aThDeVFUbVN3cXRkYXFPdG5aTDcvV3FnbUVyYnZnVjRJOXNFbSt0eWgzMDJn?=
 =?utf-8?B?Q1N5dVJYanhyNlNQUG15ZFJodE5rWmQzRmtVR2d3MTBtNzdFZERXYVdMbTQ2?=
 =?utf-8?B?dmZXVE5DQkw5eWNHV2Q2dUI2WE9EZlI5MFUrOVdpQ25IckQrSjRxRnZSZTg1?=
 =?utf-8?B?TkpHSWtKbmpKYjJoazBBZDhGemFPT1NsSFZKdnE2ZFZzQnNtck9nMm5MK2kx?=
 =?utf-8?B?NUUrbFd2S0xJQ0czRWlvQ01ZYk16WEsxZ3dOWndsamwxZG11SEdtazNseCs2?=
 =?utf-8?B?YTRjTWw5blVsd29VYVZGSm5oUGd2Z0dWb0N4ekhzR3FiVFM5QjJuKy9Rd1JN?=
 =?utf-8?B?R1dpMStNZjlxcG80L1lSaUg0dHM4S1RXM2xzNWlxcEVGRmNZK3RUVjBhbDdZ?=
 =?utf-8?B?V29HUlJ0KzZIMVEvVXp5eW1mRUlpZmlZTlFwSk81VTk5T0EvS2Q0ckJNWGZO?=
 =?utf-8?B?Rm1neDA0VFE5Mzk5ME5FcGZFMDJVQ3dkN0wyaW5nVUhKVGV0NWpHcDNrRXJL?=
 =?utf-8?B?Wml3b3dvVE5WZWZNQXBxc0ZWclNxakthZ0FCM08vZ3dsekJJTnQ5aHJvNjVh?=
 =?utf-8?B?UnZpOUU0TmFkZUNaSVlVUlVEZk4xaWYxNGVtcitnL3greDdDQ2d5ckcwdytk?=
 =?utf-8?B?ZjFhdncwUnA1RW83NExxd0loNkVTWFNXekJRL1hlMjFVTGE4RUhGYlVuV0lL?=
 =?utf-8?B?anVuOFl2aHU2TlpJWjJTY0dzQisrVHZSMzY3REo4ZmZ4UzZzcUwrZXdNYWty?=
 =?utf-8?B?a0M1VHlJSkhVMHZxUml3UVV3eWtkSEczak1xbWZqRmdRVEt3WWl4L1FiaVZ5?=
 =?utf-8?B?TGhOZWM4Z1BNMFBaSmtrNTEwUU9PSm5JclAwOXkvdW0rUkN3NVNScVRpT1du?=
 =?utf-8?B?ODVlMHl1alZIU1dTem4zTGtqQVNFenFYR1lqQTJ1NjZTZVpBenpIQmVidTR3?=
 =?utf-8?B?bWRWZmpVZlZ6enNlK0xlQTJGRHlPYXk5M01iaDc2WERVcldBNmViR2FIaTVs?=
 =?utf-8?B?KzRkYUJ5UHlFZC9lbm50MW5tcUlxakY0RXA2ODN6ZmQ1dkxHT2s5Nm5TTCtK?=
 =?utf-8?B?Q1BUR09EcGl3cHZKWS9MNGZNVE9vSzRFT3YwTFRXSHdLNWMreTlEcHNOa0J0?=
 =?utf-8?B?VFlxYTFVeVBIMWU0Nk9pQXZScFpmT0wzK1U0N3F5RkZoVW9xYzc4TWd6REdX?=
 =?utf-8?B?UWVxMzY0UXE1dU5uWVZDZytTWXRrbFRsemtCUUNpY3pEaHI5ZnRQZTdxZC9q?=
 =?utf-8?B?ZWtyaVBsYWdnTmVhRU1mZVZ2VXZCakZFQjhHYTA0V3JBZzFoV3FTVG1xWmli?=
 =?utf-8?B?RTN4RkEyMUtxTm9ZY2l1cFdVaCsvSFZxRTZNL2pYbXd1dGVUT0NBUHc2OFRB?=
 =?utf-8?B?cHdTL0JDa3RGczNtUmhndlUyMjBIQWprSVlvdEcraVRud0UzN3RKQXp0ZEU4?=
 =?utf-8?B?dnZIMEVDMDJvN1ZkZkNpRkFDVmRqdDArR3hsWlhEUUpCeFRMcUpoY1llZXJw?=
 =?utf-8?B?U1RPSlVWTmF2RHgxV25JaXNuRDFocFFLOXVFcWJwSDIvcUdqb2tGckp6K3hn?=
 =?utf-8?B?dWdpejdjQWdWVzNzL2RmL2k3azdlZTU1VkpXSldGZWVaWGZUU0wyYkM1bzR4?=
 =?utf-8?B?cmtLaCs1bkRYY1dzazY1NFEzNGhoNldWWHlhSFoyYlJ6Z3FVdmZid1ppY3FP?=
 =?utf-8?B?S1J1a3dmTFBkN0xwQlRvRG1zMVJRM0x4UFFHWFNpTGs1VlZqMGhOZ2o5YThq?=
 =?utf-8?B?a3RlUnY5dS9ZTlZ2a0NPWHRmeERaK0RtU3B6b1hsWG9XOTBCaDh2ZUZsWXZB?=
 =?utf-8?B?ckh1U2ZVQWFGZW1CZ2o3QVQ5TUMwOVRnN1RsTURZeG5hZFBFZThLTzlmRTZC?=
 =?utf-8?B?Q1BvVENiOUZGRHdOUmZaRVQ2ejlWamlrTk1HYTF0d3cxV3V6ZCtyelNaZ0dM?=
 =?utf-8?B?VXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D1235A8DE341C4E8763C7220D757B85@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 128b7b25-9eac-4337-4e41-08dd9f0c3f29
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2025 23:55:10.4135
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vvYbHBALrhXmekpsf7fXVdUxO/If8FrVS0ZEqG8/hoKJqOt3lJK9bivqf9NMyCXsemwalH+r153Jak3IdjPw2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5169
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA1LTI5IGF0IDE2OjA4IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIE1heSAyOSwgMjAyNSwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFRo
dSwgMjAyNS0wNS0yOSBhdCAwNzozMSAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+IE9uIFRodSwgTWF5IDI5LCAyMDI1LCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gPiA+IE9u
IFRodSwgMjAyNS0wNS0yOSBhdCAyMzo1NSArMTIwMCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+ID4g
PiA+IE9uIE1vbiwgMjAyNS0wNS0xOSBhdCAxNjoyOCAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNv
biB3cm90ZToNCj4gPiA+ID4gPiA+IEFkZCBhIEtjb25maWcgdG8gYWxsb3dpbmcgYnVpbGRpbmcg
S1ZNIHdpdGhvdXQgc3VwcG9ydCBmb3IgZW11bGF0aW5nIGFuDQo+ID4gPiA+ID4gCQkgICBeDQo+
ID4gPiA+ID4gCQkgICBhbGxvdw0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gSS9PIEFQSUMsIFBJ
QywgYW5kIFBJVCwgd2hpY2ggaXMgZGVzaXJhYmxlIGZvciBkZXBsb3ltZW50cyB0aGF0IGVmZmVj
dGl2ZWx5DQo+ID4gPiA+ID4gPiBkb24ndCBzdXBwb3J0IGEgZnVsbHkgaW4ta2VybmVsIElSUSBj
aGlwLCBpLmUuIG5ldmVyIGV4cGVjdCBhbnkgVk1NIHRvDQo+ID4gPiA+ID4gPiBjcmVhdGUgYW4g
aW4ta2VybmVsIEkvTyBBUElDLiDCoA0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IERvIHlvdSBoYXBw
ZW4gdG8ga25vdyB3aGF0IGRldmVsb3BtZW50cyBkb24ndCBzdXBwb3J0IGEgZnVsbCBpbi1rZXJu
ZWwgSVJRIGNoaXA/DQo+ID4gPiANCj4gPiA+IEdvb2dsZSBDbG91ZCwgZm9yIG9uZS4gIEkgc3Vz
cGVjdC9hc3N1bWUgbWFueS9tb3N0IENTUHMgZG9uJ3QgdXRpbGl6ZSBhbiBpbi1rZXJuZWwNCj4g
PiA+IEkvTyBBUElDLg0KPiA+ID4gDQo+ID4gPiA+ID4gRG8gdGhleSBvbmx5IHN1cHBvcnQgdXNl
cnNwYWNlIElSUSBjaGlwLCBvciBub3Qgc3VwcG9ydCBhbnkgSVJRIGNoaXAgYXQgYWxsPw0KPiA+
ID4gDQo+ID4gPiBUaGUgZm9ybWVyLCBvbmx5IHVzZXJzcGFjZSBJL08gQVBJQyAoYW5kIGFzc29j
aWF0ZWQgZGV2aWNlcyksIHRob3VnaCBzb21lIFZNDQo+ID4gPiBzaGFwZXMsIGUuZy4gVERYLCBk
b24ndCBwcm92aWRlIGFuIEkvTyBBUElDIG9yIFBJQy4NCj4gPiANCj4gPiBUaGFua3MgZm9yIHRo
ZSBpbmZvLg0KPiA+IA0KPiA+IEp1c3Qgd29uZGVyaW5nIHdoYXQncyB0aGUgYmVuZWZpdCBvZiB1
c2luZyB1c2Vyc3BhY2UgSVJRQ0hJUCBpbnN0ZWFkIG9mDQo+ID4gZW11bGF0aW5nIGluIHRoZSBr
ZXJuZWw/DQo+IA0KPiBSZWR1Y2VkIGtlcm5lbCBhdHRhY2sgc3VyZmFjZSAodGhpcyB3YXMgZXNw
ZWNpYWxseSB0cnVlIHllYXJzIGFnbywgYmVmb3JlIEtWTSdzDQo+IEkvTyBBUElDIGVtdWxhdGlv
biB3YXMgd2VsbC10ZXN0ZWQpIGFuZCBtb3JlIGZsZXhpYmlsaXR5IChlLmcuIHNoaXBwaW5nIHVz
ZXJzcGFjZQ0KPiBjaGFuZ2VzIGlzIHR5cGljYWxseSBlYXNpZXIgdGhhbiBzaGlwcGluZyBuZXcg
a2VybmVscy4gIEknbSBwcmV0dHkgc3VyZSB0aGVyZSdzDQo+IG9uZSBtb3JlIGJpZyBvbmUgdGhh
dCBJJ20gYmxhbmtpbmcgb24gYXQgdGhlIG1vbWVudC4NCg0KWWVhaCB0aG9zZSBtYWtlIHNlbnNl
LiAgSSB0aG91Z2h0IGl0IHdhcyBmcm9tIGZ1bmN0aW9uYWxpdHkvcGVyZm9ybWFuY2Uncw0KcGVy
c3BlY3RpdmUgYnV0IEkgd2FzIGF0IHdyb25nIGRpcmVjdGlvbi4NCg0KPiANCj4gPiBJIHRob3Vn
aHQgb25lIHNob3VsZCBlaXRoZXIgdXNlIGluLWtlcm5lbCBJUlFDSElQIG9yIGRvZXNuJ3QgdXNl
IGFueS4NCj4gPiANCj4gPiA+IA0KPiA+ID4gPiBGb3Jnb3QgdG8gYXNrOg0KPiA+ID4gPiANCj4g
PiA+ID4gU2luY2UgdGhpcyBuZXcgS2NvbmZpZyBvcHRpb24gaXMgbm90IG9ubHkgZm9yIElPQVBJ
QyBidXQgYWxzbyBpbmNsdWRlcyBQSUMgYW5kDQo+ID4gPiA+IFBJVCwgaXMgQ09ORklHX0tWTV9J
UlFDSElQIGEgYmV0dGVyIG5hbWU/DQo+ID4gPiANCj4gPiA+IEkgbXVjaCBwcmVmZXIgSU9BUElD
LCBiZWNhdXNlIElSUUNISVAgaXMgZmFyIHRvbyBhbWJpZ3VvdXMgYW5kIGNvbmZ1c2luZywgZS5n
Lg0KPiA+ID4ganVzdCBsb29rIGF0IEtWTSdzIGludGVybmFsIEFQSXMsIHdoZXJlIHRoZXNlOg0K
PiA+ID4gDQo+ID4gPiAgIGlycWNoaXBfaW5fa2VybmVsKCkNCj4gPiA+ICAgaXJxY2hpcF9rZXJu
ZWwoKQ0KPiA+ID4gDQo+ID4gPiBhcmUgbm90IGVxdWl2YWxlbnQuICBJbiBwcmFjdGljZSwgbm8g
bW9kZXJuIGd1ZXN0IGtlcm5lbCBpcyBnb2luZyB0byB1dGlsaXplIHRoZQ0KPiA+ID4gUElDLCBh
bmQgdGhlIFBJVCBpc24ndCBhbiBJUlEgY2hpcCwgaS5lLiBpc24ndCBzdHJpY3RseSBjb3ZlcmVk
IGJ5IElSUUNISVAgZWl0aGVyLg0KPiA+IA0KPiA+IFJpZ2h0Lg0KPiA+IA0KPiA+IE1heWJlIGl0
IGlzIHdvcnRoIHRvIGZ1cnRoZXIgaGF2ZSBkZWRpY2F0ZWQgS2NvbmZpZyBmb3IgUElDLCBQSVQg
YW5kIElPQVBJQz8NCj4gDQo+IE5haC4gIFBJQyBhbmQgSS9PIEFQSUMgY2FuJ3QgYmUgc3BsaXQg
KHdpdGhvdXQgbmV3IHVBUEkgYW5kIG5vbi10cml2aWFsIGNvbXBsZXhpdHkpLA0KDQpSaWdodC4g
IEkgZm9yZ290IHRoaXMuDQoNCj4gYW5kIEkgaGlnaGx5IGRvdWJ0IHRoZXJlIGlzIGFueSB1c2Ug
Y2FzZSB0aGF0IHdvdWxkIHdhbnQgYW4gaW4ta2VybmVsIEkvTyBBUElDDQo+IHdpdGggYSB1c2Vy
c3BhY2UgUElULiAgSS5lLiBpbiBwcmFjdGljZSwgdGhlIHRocmVlYWxtb3N0IGFsd2F5cyBjb21l
IGFzIGEgZ3JvdXA7DQo+IGVpdGhlciBhIHNldHVwIHdhbnRzIGFsbCwgb3IgYSBzZXR1cCB3YW50
cyBub25lLg0KDQpPSy4NCg0KPiANCj4gPiBCdXQgaG1tLCBJIGFtIG5vdCBzdXJlIHdoZXRoZXIg
ZW11bGF0aW5nIElPQVBJQyBoYXMgbW9yZSB2YWx1ZSB0aGFuIFBJQy4NCj4gDQo+IEFJVUksIGl0
J3Mgbm90IHJlYWxseSBhbiBlaXRoZXIgb3IsIHNpbmNlIG1vc3Qgc29mdHdhcmUgZXhwZWN0cyBi
b3RoIGFuIEkvTyBBUElDDQo+IGFuZCBQSUMuICBBbnkgcmVtb3RlbHkgbW9kZXJuIGtlcm5lbCB3
aWxsIGRlZmluaXRlbHkgcHJlZmVyIHRoZSBJL08gQVBJQywgYnV0IEkNCj4gZG9uJ3QgdGhpbmsg
aXQncyBzb21ldGhpbmcgdGhhdCBjYW4gYmUgZ3VhcmFudGVlZC4NCg0KT0sgOi0pDQoNCj4gDQo+
ID4gRm9yIG1vZGVybiBndWVzdHMgYWxsIGVtdWxhdGVkL2Fzc2lnbmVkIGRldmljZXMgc2hvdWxk
IGp1c3QgdXNlIE1TSS9NU0ktWD8NCj4gDQo+IE5vdCBhbGwgZW11bGF0ZWQgZGV2aWNlcywgc2lu
Y2Ugc29tZSBsZWdhY3kgaGFuZyBvZmYgdGhlIEkvTyBBUElDLCBpLmUuIGFyZW4ndA0KPiBjYXBh
YmxlIG9mIGdlbmVyYXRpbmcgTUlTcy4NCg0KWWVhaC4gIEkgdGhvdWdodCBpbiB0aG9zZSBkZXBs
b3ltZW50cyB0aGUgZ3Vlc3RzIHNob3VsZCBub3QgYmUgY29uZmlndXJlZCB0bw0KaGF2ZSB0aG9z
ZSBkZXZpY2VzLg0KDQo+IA0KPiA+ID4gU28gSSB0aGluay9ob3BlIHRoZSB2YXN0IG1ham9yaXR5
IG9mIHVzZXJzL3JlYWRlcnMgd2lsbCBiZSBhYmxlIHRvIGludHVpdCB0aGF0DQo+ID4gPiBDT05G
SUdfS1ZNX0lPQVBJQyBhbHNvIGNvdmVycyB0aGUgUElDIGFuZCBQSVQuDQo+ID4gDQo+ID4gU3Vy
ZS4NCj4gPiANCj4gPiBCdHcsIEkgYWxzbyBmaW5kIGlycWNoaXBfaW5fa2VybmVsKCkgYW5kIGly
cWNoaXBfa2VybmVsKCkgY29uZnVzaW5nLiAgSSBhbSBub3QNCj4gPiBzdXJlIHRoZSB2YWx1ZSBv
ZiBoYXZpbmcgaXJxY2hpcF9pbl9rZXJuZWwoKSBpbiBmYWN0LiAgVGhlIGd1ZXN0IHNob3VsZCBh
bHdheXMNCj4gPiBoYXZlIGFuIGluLWtlcm5lbCBBUElDIGZvciBtb2Rlcm4gZ3Vlc3RzLiAgSSBh
bSB3b25kZXJpbmcgd2hldGhlciB3ZSBjYW4gZ2V0IHJpZA0KPiA+IG9mIGl0IGNvbXBsZXRlbHkg
KHRoZSBsb2dpYyB3aWxsIGJlIGl0IGlzIGFsd2F5cyBiZSB0cnVlKSwgb3Igd2UgY2FuIGhhdmUg
YQ0KPiA+IEtjb25maWcgdG8gb25seSBidWlsZCBpdCB3aGVuIHVzZXIgdHJ1bHkgd2FudHMgaXQu
DQo+IA0KPiBGb3IgYmV0dGVyIG9yIHdvcnNlLCBhbiBpbi1rZXJuZWwgbG9jYWwgQVBJQyBpcyBz
dGlsbCBvcHRpb25hbC4gIEkgZG8gaG9wZS93YW50DQo+IHRvIG1ha2UgaXQgbWFuZGF0b3J5LCBi
dXQgdGhhdCdzIG5vdCBhIHNtYWxsIEFCSSBjaGFuZ2UuDQoNClJpZ2h0LiAgVGhlIEFCSSBjaGFu
Z2UgaXMgY29uY2Vybi4gIA0KDQpUaGFua3MgZm9yIGFsbCB0aGUgZXhwbGFuYXRpb24hDQo=

