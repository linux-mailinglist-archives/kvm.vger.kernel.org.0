Return-Path: <kvm+bounces-54628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E2770B25813
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 02:14:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9BC20623B1C
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 00:14:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45B9D11712;
	Thu, 14 Aug 2025 00:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ga5FugHi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0676A55;
	Thu, 14 Aug 2025 00:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755130485; cv=fail; b=mAkIiNBGRJ9zwZNhC/bMHP9HKmtxCAAFED4wwb6CteqiJ8TV3h5e9mIMp/GOsvhcDmbX3D/vUNncMQZjC3VtIZ4dVzbb+qIH9XGqMDQtVKU6GuHmpR2/HYgQ1nNZzp8/tyRWd4u6EU0JijDFBjH3KhAyQZWAb5TbaIUWRHiq7OU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755130485; c=relaxed/simple;
	bh=F5BbGXIE1VYHFmrrQBzWbZlGo4WRQvaee+5dcakgHIU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mfgPlS5CIBPAaGEScW246n/eWOXXoCM43xJN2BnNljNqfGkP8LiSCpua2nGj2ujOphMlW2KmUtRhquJRxDtBtII8/IoleiN40cNNNoljBBLON0rzyZcO9acNr0/8nl7z8RifoFw0YuZLDs8LWJ6c5raPJfKYxnC7tRc60eGdW/E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ga5FugHi; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755130484; x=1786666484;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=F5BbGXIE1VYHFmrrQBzWbZlGo4WRQvaee+5dcakgHIU=;
  b=ga5FugHiiLOESQC9qcBiZvdFad6jTSHCALySAO3cBFxhRHLkai5tvR9z
   kt9weH7mWhTxhoqOdqqb1SJI4qNHQIT1WFxt7PDiJ9vPVROBBBVzpquq6
   7AEs49erhZ0aX3L501M8lCom9TK7Nwyum6g91x9PZGmfVEhEI/8Cj46Zx
   UYunQX7vitwxj1sMveEcgOzBCZH65x2T4vwKg3t76L9/tnqgMgrnazlmp
   7G3Nt/5AoPbfosaYVLbOwT4s4arjiiv7ETal+vlQWz0QtSOM+LqwKaTY6
   YbW/pd9QiAilNaoVuNMGCTRCw3DUDY1XADXCbe5DrYR6MSs/AywzV97yJ
   Q==;
X-CSE-ConnectionGUID: zetOIU5vShuM4mzcxKpDxQ==
X-CSE-MsgGUID: 4RJC19uLS6K5OAHCtNKA0w==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="57508406"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="57508406"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 17:14:43 -0700
X-CSE-ConnectionGUID: Z2KwUXHVTVuyzYe6QOYiLg==
X-CSE-MsgGUID: Km0LtnCqTciA4fZBk1m9EA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="171067034"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 17:14:43 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 13 Aug 2025 17:14:42 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 13 Aug 2025 17:14:42 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.73)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 13 Aug 2025 17:14:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OHNtL96IaVNHrvIR8a/1jm2JsTNbm70mhtFiLKtsvHoTP0UqP9lIYIu/Ep/DxuZTP1iiX5eLuLqo5pqv2GzBK4FXk/Bs4wP7T2Ftm1B+bzy6Zwfj0O4fbV27iVwTX6zKlm6GnWkCebp6CfvgaQTgNa9X5tjxEW3/P5iot9jgedzcx4hBQkHGmY0kCWtpGyYpYOJf+NBjeKDUTK34ljSSmuwgfAGJpbSOv9aFNmfIawN2gpum5j/tNytAPGRg/oV/G5uAdLujqWwiwmYDu5QYSr4jTrldNTasHMOsLbrlgk9r4Xmuxq7ArdJVSucnJPUq7cOe5IukROHs/jGKJIkdGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F5BbGXIE1VYHFmrrQBzWbZlGo4WRQvaee+5dcakgHIU=;
 b=YTnIv89vevpEa81/0eo6q4kJk+2AfnAAYRChQiOz9GtQYGFzJOLotFiyL5nUDhlJ0nzd8tamfgJy46e9sIIeoQHTNNpCSEoYGTCaCtarteG8mUXldFonMqcxkCvqKC+nmfUg5cfUpjN6fJTxbObDIGjCmkLTvavFgnbgoWvegY22snsxfnPFi3lDXUjfmwuT5WoCHV/KhMq+xk6ogZzlxWzfbbYjduGWk4R2Z4jqbCyKgmdSTMRVHliz4xHj9tXRtJWyxfLXCTgDcAyP9+jcXgyHp77V3sbW8+6py+V1fivcreakE96SbeJPDxqdMip7G0qF5V2YE/GEmZGWoXYQgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA1PR11MB8831.namprd11.prod.outlook.com (2603:10b6:208:597::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Thu, 14 Aug
 2025 00:14:40 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 00:14:40 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>, "kas@kernel.org"
	<kas@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCHv2 00/12] TDX: Enable Dynamic PAMT
Thread-Topic: [PATCHv2 00/12] TDX: Enable Dynamic PAMT
Thread-Index: AQHb2XKrCJQDYmgN9EmkL7mVJaZZf7RZwqaAgAOdgICAAQwrgIAAOwMAgALtSQCAAA1HgIAADA+A
Date: Thu, 14 Aug 2025 00:14:40 +0000
Message-ID: <6bd46f35c7e9c027c8a4c713df7dc73e1d923f5b.camel@intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
	 <d432b8b7cfc413001c743805787990fe0860e780.camel@intel.com>
	 <sjhioktjzegjmyuaisde7ui7lsrhnolx6yjmikhhwlxxfba5bh@ss6igliiimas>
	 <c2a62badf190717a251d269a6905872b01e8e340.camel@intel.com>
	 <aJqgosNUjrCfH_WN@google.com>
	 <f38f55de6f4d454d0288eb7f04c8c621fb7b9508.camel@intel.com>
	 <d21a66fe-d2ce-46cc-b89e-b60b03eae3da@intel.com>
In-Reply-To: <d21a66fe-d2ce-46cc-b89e-b60b03eae3da@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA1PR11MB8831:EE_
x-ms-office365-filtering-correlation-id: 9eea15b8-e305-48d0-cdc7-08dddac78fe1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RWhrNXN6TDJYRlJpNFJsVnRHOUxpL1RsU3hzKytKRW9YN2pMZnluMVFSTmpB?=
 =?utf-8?B?V2kwTDBReCttUHBxTlFxTHBwODFkNUdTKzJOOFdiR2g0ZmJ5aEg5VjAyZG5n?=
 =?utf-8?B?eGEzU3dYV094ZERNYm9wNVFaVnJWMzVnTHl5cjJuV0J0SEZBZlEwd1Y3YmJV?=
 =?utf-8?B?MDlER3VEUS85R0cwSjZSeEFkNFIxUTRTbSttYWRxMkJTak5ycTZjR0V4OFI3?=
 =?utf-8?B?bS9yZzVlNlIvOWhTY1djdXhmRWVoMmcwUVBNM200RGNBdHBrM2paWFpTRnpx?=
 =?utf-8?B?YWVhYWJQYXBFTlk1eVZFSE5LdHJLOXFmZmlGNFF2WGtBK0pmNHNZeUUydVZn?=
 =?utf-8?B?Nm9DWHpnRmd3TWdla2F1dmdqNTlLZGpKZEE5dVJvMGtWRnk3Q3htZDNGUkZ6?=
 =?utf-8?B?cVRJN2dGK1BxbUVNbks5cGlPdWJKZVA1Znh2d1Y2M1FLdk5qb3VqdjBFVkNM?=
 =?utf-8?B?TU1RandvWVd4S0Z3TUg1TnVGOWZyVlR3OVdQdUNVZkFzRUpaNWo2VU9Gdmdm?=
 =?utf-8?B?NWkzWVVra3RiZzhqT1luZ0lHeWcvTGpiUXlLRERIaEs1aXRWRUhQNUhxV0FJ?=
 =?utf-8?B?NGdOZFNyOFdMTHVWUDRWMUhLRFRseDZNZk1nYWd6eE1FU2pENVlRNEcvb1NZ?=
 =?utf-8?B?Y0x2Y0trcWh3M0RXRlB6blNqcXY4dVhIc05RVkhTRE5tcnhCSFVFUjFBdGx0?=
 =?utf-8?B?eC9ENFpMc25oWUdUbXNmTHpXN1hFdG9LRG55M1RHUlZ3NVg0Y005bTRTckNG?=
 =?utf-8?B?Ny9QU1ZrbWdIQ245NmJtMmw0SEpvOWlES3RoY2pXOU1id2tRMVpCU0k4TVJC?=
 =?utf-8?B?Q1ppaXRtajVLckh1emxISzZXcUNXSXZIenorckVKZXZhd1Y0SHYzSzAvTjlP?=
 =?utf-8?B?bWhkTDk1OUdtbFFBcnU3UDBFdS90MWQ0a2hNVzQ1YTIrZWx1emJGSVN3b3pX?=
 =?utf-8?B?WmZkenNmL1ErWFFUa1hObkhxM2E3dkM5ZHByL3RDTFhodi82em9VV3FkT3Nu?=
 =?utf-8?B?dHg3Q2p5SGlkUHdWVWFvVFdCR2UwVTBhOEs2Tm5RZEhmZTJ1b0x0RzNPREN0?=
 =?utf-8?B?cVgwWEVGWE5uNHIvVHNzamMzTWhVYjlFQTJSa1pOaVd1T2Z4dE8yQWxBR2dL?=
 =?utf-8?B?VmZFYXNJd0RDc1J3bTIzNkpXekQxMk9PK21tVmRtcEc4MWlCcytYQUlFMmZa?=
 =?utf-8?B?cWNkc3lOeWNlWlNRSHppQmdFWEZ0R1JoUmpYSDYyU09xVE5DVTJ3RnlHUGpU?=
 =?utf-8?B?cG9OVjRCMldDcXczVE1rUUNPdWI2WWpFemRSNWNDTldJTkNDK3ZPT3o0MTln?=
 =?utf-8?B?M2Z6TzczZHlCREJoM2ptdytRbW91NEViQ1JRR3VVREt0YTJGS080NlU4VWVt?=
 =?utf-8?B?MjI3cGg0cEJCTUhmZlU2Z0JDNDQ0eEV4OE5HdmxkZ2tFVWk4a2xOdDlselF4?=
 =?utf-8?B?SUdvemRLa3JTYVY4eHlsQzJmRFlUaTBWbTFhK3lBUnNMSzh6RkdFTGN0RGRY?=
 =?utf-8?B?dFNWSjhnUUxkakNtNUlWUkttdTZpMmg4TWs4WTk3Q3dQWkppSDNWRFpXaWw0?=
 =?utf-8?B?UWRXUnlBWmdMckVnSGoxdFV3RnJQZEJWVVpmL3BOalUyaS9kb3JaVkVnQ0la?=
 =?utf-8?B?eEZoNmRMMWQ0VTJnWUdpNlJseE1KSlBRd2lxS3ZQbk05c2dBQXB0VGcxUXhN?=
 =?utf-8?B?Z2J1WGlyRkVzT3FRZHhQTFFaWGNQSkpWemFMOGI1NmFHT0U4U0ttNkZ0WTNI?=
 =?utf-8?B?cE1iM0l4T0RLdHVvbTF3ZG9nb2hJcmpHdG5NUjY3bnZob1NsdDhBaFNkOUNV?=
 =?utf-8?B?OGswNHBtMEJvVWphaFlSTmRRNThuYTY5cnRTTVRWUnVpSjZaNC9NRS9IUklW?=
 =?utf-8?B?ajdHd1MzeWJLTElGR2NGeDByVlk0ckpTMEMxb3dUUjdzV3Z3MENoTWRIUVg5?=
 =?utf-8?B?K3B4Y2lySWhPZ252SlJFVTVXWTlYdHYwVmJIQy9sQUQ3Tldsci9abWk2NTNK?=
 =?utf-8?B?SE1YdHRac0xRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ck5YZWxNSGFrWDU0Q1JGenVmRzlSYkhNU3A3WU9GQVlwbE5JU2w3WUtnTzJy?=
 =?utf-8?B?aWNmZXdqdTBET05lb3hBVGF5bGVEZjFySjFTYVN1NnY1UVdmb1NkOWJ5d29Z?=
 =?utf-8?B?SW1EaXFlNjRuWlo0WXFpUFNZaWtoajNMWkp4NDB6cnBkUFMzK3J1dy9YNVpz?=
 =?utf-8?B?L21FYks4K3pPTXpVbUtHeG1Mazg3MEkxRE9ESDU1Q3I4TTRRS1JUMHpydkE5?=
 =?utf-8?B?YVRUdm5WRnJTOUlvRndqQ0tWaFdxcHdQWGlNY1JUOW55c2RYOG9USHdWZUJt?=
 =?utf-8?B?TERwSWEvN2hnSURjclZEaXJHZTVudXRXdVZEMTlleDNoc29EL0I3eC93SFhl?=
 =?utf-8?B?TDdtTlZCN2FDcjArSEFyeXFqR0wrSEZyaGp6ZVk5QmNxM2p0alNsTW1iU283?=
 =?utf-8?B?V01GODlXdHBMYXpydG16b3ZHZWh4WFUreVBGMG9ESzFFeTQvZFNHUjNqM2pZ?=
 =?utf-8?B?dGpZdzdVUHVxazBHMHRsZU03cFlPYnVacjVsU1BDdmJ4NGw1TVZnd3BzTzMy?=
 =?utf-8?B?eUJId0M4SmtoN3BEOWhCNHdIQlRhVzJOZEdNUURhME1Iem5FSmZmNkpGY1ZV?=
 =?utf-8?B?VlhobUhTNFhlZUFicmNmRk5hTm1TZEdpWXVYTkJ4enRlVnhiUFI2VXdpS3dO?=
 =?utf-8?B?SDZPejA5NE1HQ1VtbXlFbDZtdTVqVTNWTHlKWFg0VzNwU21aVE5adE9YMTFN?=
 =?utf-8?B?OVdpVHZTRmV2OGtPZWk4WGZoNTE3WEhTTVNacDlYekxuSzMwcHJjRDVUMFZS?=
 =?utf-8?B?VFk3Wi9mZG1kdUF2bzUrVzNSOUlHYzRNM0JiZG5yTnkvUlZGaFp0ZU5WVHdh?=
 =?utf-8?B?YVBTWW8xR3g1amFUYU5Ibk9PYVVuSFhyaWJacC9jbTdRcDB2ZGh0OW05SFdk?=
 =?utf-8?B?YThFT3pxTFdMeSthT1NrRWU0UzFTSHVHbklYemxzenhweDFNQjI1S1g1R0hI?=
 =?utf-8?B?TitJcGVsNXVveFJWUlJVb09CN3crNlhTbEh6QjZSQlVnUDFXbHlRSzJMNGpH?=
 =?utf-8?B?b3QrMEVScVdPc2YvVHZJR3RVSDhUTEg0cXgvU2Irdy9sUm45MUdrNXlMdnZp?=
 =?utf-8?B?dDBrNVFXZ0JsNVJMQmcyNDlVTlZOMlJycnY2KzZYWCs5OEZWbExTT3o1Smds?=
 =?utf-8?B?djQvYjRCUWt4T3pTUE41dGczWG5TOE9ZR3oyZ2xLQ3d0NzNiaHdVdDA3L0tn?=
 =?utf-8?B?dzUrMDZobGxxdlUxN3U3RWFBaTFKbVBiczc1UmY2d01mVnpLcXI2c0RXeEpT?=
 =?utf-8?B?V2lQdDRPd2xZNmYrK0ZZZzBmQ2lwenlMaE9EdlB2MTZLOUo2T2Ewa2RWWFZH?=
 =?utf-8?B?WTZlVElBVk5FY0hRQmluazB6NUkrd3pCTkJ4M1hSY3hsZXFQSnZRYnF5VXky?=
 =?utf-8?B?TTA1TGQ3UlUrYnlRVEplL1pjQ1orc1pYeE92ZjFtMlE2dU5TU1NyQ1FXZGs2?=
 =?utf-8?B?SVQyS3NtTjdiNExENVp5am8xb3lVMHVZRzNtWGREZm9LREQ5UEpHcjZPWjh5?=
 =?utf-8?B?amlhRFV6TE1zMzdiZXEybGZuNHNPd1llcVpXTkh4UVl0WER0Wlk4ajdJSnBE?=
 =?utf-8?B?UUprbHJvU1RUcDZkZjlhdW5rc0RGeEJjVldjL1Y4UjZNQWtobk41M2Y4WHlw?=
 =?utf-8?B?bTI1K2xBckhITFBGanQyc1c5cHBYSVFQejdCUTVrOTFyU3FiVGY3S29DTGhS?=
 =?utf-8?B?NG9oNkxnb3lFWHFVVjU4blplYk1ZblJjN200b2E0OCs5V1NjUXNDamtrRCtm?=
 =?utf-8?B?UkxBbnRMTEliN0xrbmEzYXV6THJQQks0alk0d1h2U01iN0hGUUdneUg1S2J4?=
 =?utf-8?B?aDArbWVaODFQcHgzSkV3L2xJbkY2Wk5RMU5vejRpN2RPZWx2elRHS29ON3lj?=
 =?utf-8?B?dTJrQXZmUzBJeGtJbXJlYmw4NmJsbmlzZjdEMStaM0pCdGh0RjV1dTNCL0tF?=
 =?utf-8?B?NGxxS1ZxWWRRdi8zQ0hsRC9QMmJzcjJWTWh6cUluWUtzRkdWSWxOaHBWQm8v?=
 =?utf-8?B?Z0tOYWF2RU1ja3VYZ1lmTk5mZWJhWWVnbUZTOStSL3Z0eHVaRTJ4NDMrN1FM?=
 =?utf-8?B?NEtvUDVPYkdzaFpvcndYZ3YwblZWeDVOU0hGN21KSzFlMzh0anMzd0lydG1L?=
 =?utf-8?B?WkorYXAvR2ZET3JmVXZPaEFkU3lQUkthRXFOTnN2bld1LzNMR2E5QUZmWlQy?=
 =?utf-8?B?a0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <535014DF5A234645B28B3AF54F0AD3EF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eea15b8-e305-48d0-cdc7-08dddac78fe1
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2025 00:14:40.3571
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SGi3NZvLbCldkevXipjwJVjP8xbW/dOF0mJHxZGZBGykPZvPPoGYlI1PfxcNNx9aaNgya1FmDFWMQStoU4TBd9enVV5mbIsNOjnF7wmvYiw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8831
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA4LTEzIGF0IDE2OjMxIC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gOC8xMy8yNSAxNTo0MywgRWRnZWNvbWJlLCBSaWNrIFAgd3JvdGU6DQo+ID4gSSByZWRpZCB0
aGUgdGVzdC4gQm9vdCAxMCBURHMgd2l0aCAxNkdCIG9mIHJhbSwgcnVuIHVzZXJzcGFjZSB0byBm
YXVsdCBpbiBtZW1vcnkNCj4gPiBmcm9tIDQgdGhyZWFkcyB1bnRpbCBPT00sIHRoZW4gc2h1dGRv
d24uIFREcyB3ZXJlIHNwbGl0IGJldHdlZW4gdHdvIHNvY2tldHMuIEl0DQo+ID4gZW5kZWQgdXAg
d2l0aCAxMTM2IGNvbnRlbnRpb25zIG9mIHRoZSBnbG9iYWwgbG9jaywgNG1zIHdhaXRpbmcuDQo+
IA0KPiA0bXMgb3V0IG9mIGhvdyBtdWNoIENQVSB0aW1lPw0KDQpUaGUgd2hvbGUgdGVzdCB0b29r
IGFib3V0IDYwcyB3YWxsIHRpbWUgKG1pbnVzIHRoZSB0aW1lIG9mIHNvbWUgbWFudWFsIHN0ZXBz
KS4NCkknbGwgaGF2ZSB0byBhdXRvbWF0ZSBpdCBhIGJpdCBtb3JlLiBCdXQgNG1zIHNlZW1lZCBz
YWZlbHkgaW4gdGhlICJzbWFsbCINCmNhdGVnb3J5Lg0KDQo+IA0KPiBBbHNvLCBjb250ZW50aW9u
IGlzICpOT1QqIG5lY2Vzc2FyaWx5IGJhZCBoZXJlLiBPbmx5IF9mYWxzZV8gY29udGVudGlvbi4N
Cj4gDQo+IFRoZSB3aG9sZSBwb2ludCBvZiB0aGUgbG9jayBpcyB0byBlbnN1cmUgdGhhdCB0aGVy
ZSBhcmVuJ3QgdHdvIGRpZmZlcmVudA0KPiBDUFVzIHRyeWluZyB0byBkbyB0d28gZGlmZmVyZW50
IHRoaW5ncyB0byB0aGUgc2FtZSBQQU1UIHJhbmdlIGF0IHRoZQ0KPiBzYW1lIHRpbWUuDQo+IA0K
PiBJZiB0aGVyZSBhcmUsIG9uZSBvZiB0aGVtICpIQVMqIHRvIHdhaXQuIEl0IGNhbiB3YWl0IGxv
dHMgb2YgZGlmZmVyZW50DQo+IHdheXMsIGJ1dCBpdCBoYXMgdG8gd2FpdC4gVGhhdCB3YWl0IHdp
bGwgc2hvdyB1cCBhcyBzcGlubG9jayBjb250ZW50aW9uLg0KPiANCj4gRXZlbiBpZiB0aGUgZ2xv
YmFsIGxvY2sgd2VudCBhd2F5LCB0aGF0IDRtcyBvZiBzcGlubmluZyBtaWdodCBzdGlsbCBiZQ0K
PiB0aGVyZS4NCg0KSSBhc3N1bWVkIGl0IHdhcyBtb3N0bHkgcmVhbCBjb250ZW50aW9uIGJlY2F1
c2UgdGhlIHRoZSByZWZjb3VudCBjaGVjayBvdXRzaWRlDQp0aGUgbG9jayBzaG91bGQgcHJldmVu
dCB0aGUgbWFqb3JpdHkgb2YgInR3byB0aHJlYWRzIG9wZXJhdGluZyBvbiB0aGUgc2FtZSAyTUIN
CnJlZ2lvbiIgY29sbGlzaW9ucy4gVGhlIGNvZGUgaXMgcm91Z2hseToNCg0KMToNCiAgIGlmIChh
dG9taWNfaW5jX25vdF96ZXJvKDJtYl9wYW10X3JlZmNvdW50KSkNCglyZXR1cm4gPGl0J3MgbWFw
cGVkPjsNCjI6DQogICA8Z2xvYmFsIGxvY2s+DQogICBpZiAoYXRvbWljX3JlYWQoMm1iX3BhbXRf
cmVmY291bnQpICE9IDApIHsNCjM6DQoJYXRvbWljX2luYygybWJfcGFtdF9yZWZjb3VudCk7DQoJ
PGdsb2JhbCB1bmxvY2s+DQoJcmV0dXJuIDxpdCdzIG1hcHBlZD47DQogICB9DQogICA8c2VhbWNh
bGw+DQogICA8Z2xvYmFsIHVubG9jaz4NCjQ6DQoNCihzaW1pbGFyIHBhdHRlcm4gb24gdGhlIHVu
bWFwcGluZykNCg0KU28gaXQgd2lsbCBvbmx5IGJlIHZhbGlkIGNvbnRlbnRpb24gaWYgdHdvIHRo
cmVhZHMgdHJ5IHRvIGZhdWx0IGluIHRoZSAqc2FtZSogMk1CDQpEUEFNVCByZWdpb24gKmFuZCog
bG9zZSB0aGF0IHJhY2UgYXJvdW5kIDEtMywgYnV0IGludmFsaWQgY29udGVudGlvbiBpZiB0aHJl
YWRzIHRyeQ0KdG8gZXhlY3V0ZSAyLTQgYXQgdGhlIHNhbWUgdGltZSBmb3IgYW55IGRpZmZlcmVu
dCAyTUIgcmVnaW9ucy4NCg0KTGV0IG1lIGdvIHZlcmlmeS4NCg==

