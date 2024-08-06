Return-Path: <kvm+bounces-23345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FD3D948DA9
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 13:29:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 92F6D1F253DA
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 11:29:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 883771C3797;
	Tue,  6 Aug 2024 11:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FKXw/ts5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF75B1C233C;
	Tue,  6 Aug 2024 11:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722943754; cv=fail; b=q3kmNfKvXiy+GEjTXzwtb7OxacjMbAK0ADFjOVi6UMTiEKTc0YELX/7yQULSyS4+G1Zll52rSxfWmekYtsNJ32QZ6Nr2CrCC3gUvXojYog+hooWdU0gdk8gYJtmwu4KABKPhqSfa56zmMb3Y7FBVerN8i1fJoIha4o35O8KGRxw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722943754; c=relaxed/simple;
	bh=PXPhTuhxvEO8FSHtDMxQO4ND+tw8iCu+UINR0FJGzSk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OUoNDYBjwQADL4jduXhNZ7YaUOq8QuKMVebMZOpE9BiNbzwiv7BTC69qqPb/jm0aSrxaqpjo2gkdQOnXjuPcHrYoqQU2HbL7qgeXeb3zY4d9+svujMmbirdOv9Cga8/HUc33X1VRZlgJgSXc4l6++FuAyCWSyBtlrUUUp2/uxec=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FKXw/ts5; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722943753; x=1754479753;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=PXPhTuhxvEO8FSHtDMxQO4ND+tw8iCu+UINR0FJGzSk=;
  b=FKXw/ts5v68iheOCdDvbcf1XQKRkOuten5uPUpGOeg0F9A0aBbhO/0lT
   wOI93+7QmyfSyTTuQa9k7mb5ZZUWHr/xRLNfgbSKKt3IrSBd2tYN8tBMF
   xixrOg/DStccbFvmH5mpqrJjqMc72BK/5rD+QcPwlK7+X2EXqBxrP77wY
   ZkAjXwVXee8AxVRgSESzNFscu5vuo8ycAQlF7IFikh+B5OdRnyRKpffiB
   s31BZjUvp2wajePmeRa/dreIq7TPSyeTOANmnLSVXd2RCUbCZdCfAa8bV
   VUhMIxJNgXxDq70ZOiNDPezEC2dQHuiqFZUHYImuE5iSG6a58/qsydmht
   Q==;
X-CSE-ConnectionGUID: 3Zdz1WSISZO/+N0lcFYuPQ==
X-CSE-MsgGUID: PfSN0Zt7SOiYOD1X1GlpPg==
X-IronPort-AV: E=McAfee;i="6700,10204,11155"; a="24717975"
X-IronPort-AV: E=Sophos;i="6.09,267,1716274800"; 
   d="scan'208";a="24717975"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2024 04:29:12 -0700
X-CSE-ConnectionGUID: 4blQNKpbQhWAOooMu4lJHQ==
X-CSE-MsgGUID: HufdbcFPRr6LrEG4KU4HGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,267,1716274800"; 
   d="scan'208";a="87106289"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Aug 2024 04:29:12 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 6 Aug 2024 04:29:11 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 6 Aug 2024 04:29:11 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 6 Aug 2024 04:29:11 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 6 Aug 2024 04:29:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BGgQrGQykcJFvImWEBSQmAuhJydLDZiv0JuWlm8XXJOWkh0QxCu0tpVukNPTmTI+w9n6JESsNuZO9VQTPA7m7cmcL3nmzHfZUqHKKXEjCDyd2L6TvkyNT4oWtT4TDDd4tocBJ2GWZVrj7t1DeLqFmnyZ42unU06Cy7RvuBB428CS/nzm4SOimcy8MHwG0ffK7yFHm8jXw6z1LPbgoDeiFiXM5263M0BF4/PzoVg3gUWMrcnJ/UYEaiGWs2pXWGMYgx+M2MjG5h5S2MB80GN7waN2mm7uAYxB168ETxQihmJCQXfnDGEJmmNn+wVjLgYvbxv0Auz6hvF9D1/2vFpP7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PXPhTuhxvEO8FSHtDMxQO4ND+tw8iCu+UINR0FJGzSk=;
 b=OzSXPOE4KBWZwrzWM1xwnQO9qaxz5+SUOdtyP+Hn9rDfQjMolJwtpH9YqeEut3I7aPKVzbzKY/9BVuKcW/hUDjXMmkEukFtU8do1nRUV7949TJIkvh2+vcK5Tary7iluadcSTOVGJWsXPZQ+tmBbvnVKyDnHpeZbYW0YEhofqo1HUR78y7IgucYSOxuNHUnpEQBvLFavIhh7YMAMmvl2Bq4cD2mOyEG/nJ8UIg4acz2yc70C3P8Q2/rhNBlLU3FS2PifovnXs3qrFa35A+bOf/YUxHwwBGcHRI2Pyt3yJO+4OmOlBgCGZ3u6PFXT7wHLmGayjmECsnvvxNYxWGgwqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB8776.namprd11.prod.outlook.com (2603:10b6:610:1c1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.26; Tue, 6 Aug
 2024 11:29:08 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7828.023; Tue, 6 Aug 2024
 11:29:07 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>
CC: "Gao, Chao" <chao.gao@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v2 07/10] x86/virt/tdx: Start to track all global metadata
 in one structure
Thread-Topic: [PATCH v2 07/10] x86/virt/tdx: Start to track all global
 metadata in one structure
Thread-Index: AQHa1/rLYpFfnPVKF0OxuzXPXSRTl7IZt+YAgAB/0oA=
Date: Tue, 6 Aug 2024 11:29:07 +0000
Message-ID: <62724437435e0cc6d5637ce7a4cb919b0b8bfea6.camel@intel.com>
References: <cover.1721186590.git.kai.huang@intel.com>
	 <3d75e730cc514adfc9ac3200da5abd4d5e5d1bad.1721186590.git.kai.huang@intel.com>
	 <66b19dc6ddbcf_4fc7294fd@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <66b19dc6ddbcf_4fc7294fd@dwillia2-xfh.jf.intel.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3 (3.52.3-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH3PR11MB8776:EE_
x-ms-office365-filtering-correlation-id: 0a5aa8bd-8c48-4296-ca3c-08dcb60afc18
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?QTJLUnhuYU5TUi9KUktJQUdxQVo5MWdlWmsyQ01rS2FFQ1BhVmplVjlENlJO?=
 =?utf-8?B?UnN2TlhZb0UyTHRlQzR5c1FLTU9yOXpGTDU1OTNGWVhRaFBCbm5uVTFLbTQ0?=
 =?utf-8?B?cHFDL1FpMlhGeTNSR2VQSTNKRDJ5ajQxZFczdEV4VjM5ZlNBRHNFQTU4ckdS?=
 =?utf-8?B?SlpUL2F5bFNvYjRDNldFTlRWZThUZFVQdlVhdjk4NEFVL1dhN2VmTDNyUWNH?=
 =?utf-8?B?ZXBRWEMrWlUrOGJzMGFWMUpjdGxtQjBYTWh0YnpkWWxVbkpKK0FndDVGYzQy?=
 =?utf-8?B?TFpsTDhuK3JjZ1NDSWttc2JCcGIxSGhXZ1VlbnRiSGE0SWlpRmo3Ym8yUDVE?=
 =?utf-8?B?cnRkTXFmM2FJYlQrR3A3cE1sZlFHZFc5aXFhcVpBMnR4Tzl4b3FHeUFsblBr?=
 =?utf-8?B?S0NOcUV2b1R5dDZ1RXFuQytvbnMrT3FrNHV3alAxdFhvTHNiWEVzTzF1ekRL?=
 =?utf-8?B?SEQ2QVJuQzZtNlhaTVNJZDNIbUJxY0dTZFA2N1JvbXNtZkVTK2NLYXl5ZHVj?=
 =?utf-8?B?MVpIb1RORDVPSHAwaHhCVkp5aDhoMDVMUGUrY2xGWUZCN2FnWU53UzRoUCti?=
 =?utf-8?B?cHlMNUk2QTZOK0hIQ295ZlMzRXN3Z095SzRueTYxbmVaSERET1BiRFJhNXRF?=
 =?utf-8?B?eEJVc040dlF2cEFYbEFMSWw4dWJycXhha1Q1WTRrc0tqa0FaSU9FZnJkSjA4?=
 =?utf-8?B?YVZhNmYrRnl0QlRXOXJGQW8va0xZNlRvYldEcXFhVkI5bHFXTWZKSUI5dGFH?=
 =?utf-8?B?WUU5VXVNaXUxbUNzTzBYa3dwNDJDOG1ZemxKc2RkK1dYcU1NVVBxTlRTVHdq?=
 =?utf-8?B?bkY4ZmVMT0lMcXBLbzJQYVdvNi9oTXp5UTh1RTVHaGI2VDRtSlBxa3NwMnpq?=
 =?utf-8?B?ZFFTczhZSWRSL0o4UDhobnJmVFIyLzVndUdsQW9SN05nQkZNMEF0NXFqVjFO?=
 =?utf-8?B?SHJCaDZVUWVzTVhPNzd3UUkydVhQM3pud0VyUS9ZNnpEOGhpeUpHK2djNU9W?=
 =?utf-8?B?VXVNZ29kKytZYm5uSmIzNU1QRWFrcGR2UDVxbVoxbmhHVjJmcW00STFpU1cr?=
 =?utf-8?B?RTZtWHVzQzZ0WStiYnRoc1VHeFd0TE1IcjhoU1dNSEMrQ3BpYjZSOTR4RWlo?=
 =?utf-8?B?a2I5bVZSM0U2czFVREEvdnB1dElGYVNENnNyM2I1OUppVkJua3Rvdy83TFZ6?=
 =?utf-8?B?OS9TV2NYdVBmZTEvenppWjVKV2lWbEZ6YVBUbEZzYnJoS3NrVVRYa2xtbWFS?=
 =?utf-8?B?N1hLcUQvVTl1MzRXVEJvb3R6Rko3aTBmV05KVkMwdHFaK3Z2eUUxSVdOWjl2?=
 =?utf-8?B?NWZ6OGhacGpRV3cwTUd2TVljdHVoNHNzUUVra2s5MG4wa3FpVVYySzFTNjJU?=
 =?utf-8?B?ZkJ2a2FvSWVFN2FnYWd1TThWTUVJYUVNdXhTcHlMV2U4TXM1UkpJTnZnSlM1?=
 =?utf-8?B?TEQzQWRTRnE1Z1pvRTlvMG4vWEZXVVQ4QTZVdy9lMDkzOWV0ZmtnVXczbXZY?=
 =?utf-8?B?MEdiWHE1RHpBN2xSdlpFeFMxVU04blpDejB3Z0FpNkpiK3VhcXNPTkJ4dy9j?=
 =?utf-8?B?WlJKbllVaWt5NTQ0NGJZMnNac3RXaTdIU21EeGp1U3pNc2UzVUg0ZnVLTzE0?=
 =?utf-8?B?VloxNkREeXY1Q0FPcjJTaytXMDhUWW5qVTc2MTNOUmxLTjRFMERSQ3dNQXRG?=
 =?utf-8?B?Nlk2N0FGMG5seTBUUmNmTVZqTGdqMzFLcEt6OXh2dXVzZytoR0hnV2dFZWdR?=
 =?utf-8?B?ZEQwSkovcnhoLzZIYVByL2hFM2pSakEwaWtWZ1hhd2Z2cG4rTVFQMjZKY0lt?=
 =?utf-8?B?SE1XeWR1ZFZUeHEvaWJYSTFzOWFsaVNVS2x3TGZMTG1teThzSitNcGwwMThY?=
 =?utf-8?B?RDBrdzhwWGRaVDI3d1drZ1lKWTQ1MGhZT05maDc0dDIyaWY3a0FwWk1mV3Fu?=
 =?utf-8?Q?rVeZfEvQ6qM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K2h4MlJyeFgzSklmcjhHOG84cXJOUmEzMXdPSGVGUE9Bb1B6Wk02NktVc2pp?=
 =?utf-8?B?WTIyN0t6dGZ0UGdyV0pNa3Z6UVU4Z3E0Znh6aStERnNJMFI2RWdxSDMwWmZV?=
 =?utf-8?B?WlJnZFU5ak9FUzMxS0FSZmgvZytzSHYzN29JSGFJNkk1b2xoOEJQdEpSK3lR?=
 =?utf-8?B?MlR1cmowR0FMN0ROUGZueUtzRkduSlVzby9obTFiZmxTS3RnS3hYL3JOeTdn?=
 =?utf-8?B?cWVLbjRZS2ZJWmF4ZTlXYUVJNGJwaFRBTDRyMlY2YXBwVVJmZEhrUSt3Ylc0?=
 =?utf-8?B?NDNtNnRYSVZJaDcvZ2xzZ0lDU05lb2p3YnplOWZyejFjRSs0Z2kxODNBbDN1?=
 =?utf-8?B?KzdtblIveXRPK2owTVNkU1IrMUE4VUE0Tnc0c3lyMjlMZ3ZDa0tIT08xd3Nw?=
 =?utf-8?B?TE9CQUZjVVFtVGVTSFRmL1FXbng4dktaenpKajU5aXBkUU9nQ2xkY0V2WmRk?=
 =?utf-8?B?OElBMEtSd2JrdEZrZ1FMSEZyd0VWNzZETzZaZ09TcFVFaVlmbFhtSHE0NXRv?=
 =?utf-8?B?U3VDeUpVSitZTHRycWM1OHNnMHA4NllSTEdMSVF6VW8zOFBIMVZqVWYzbW1l?=
 =?utf-8?B?dGZIRFNtL0VVWXhabnlTcXlBTmZUbk03czVTTVdVdUZaMldLYlhZN3RhaDZY?=
 =?utf-8?B?KzFFcmZSc2ZTUXpPNkJFQzB1Wk9FVXdkdjlDS1FGcU1rQkdXU0lueC9rOHdU?=
 =?utf-8?B?K09EMUR2eS9JSUFrMTAxVStDQU1PMDlMeUtEM20vTVhOOS9MQVVUcWxiM0JD?=
 =?utf-8?B?ekR1ajlvaG9Tb0NscHdyU1lwNC9ieTNHTW4yeWlIL2hNS01xUmJacEVuYkFo?=
 =?utf-8?B?VWZkTng2eXNSR0VndGxhbk1HekZjbHdrb3IyUHFCanBjZWlmUlVyQVc5ZlIy?=
 =?utf-8?B?bmtaQXUweDN1Ui93UUhpZFJvWFFtWkFoL2taVG9qVFZQWjBEb1FKamkvQm9s?=
 =?utf-8?B?YzAzVzJ4OWFMVW1TTTV1YnlkeTBKajJZLzRPWnJFSFpYVENwYWdYT3k4aFFo?=
 =?utf-8?B?OWc5UllBNHU1K29HRUlYRkY1UmJiTmFlbklIT1Rsc09tMXh4aGZmNXpGMkIy?=
 =?utf-8?B?VEpiOVJlb2RaZzZxKzVSc3BwNjVMa3UxTnRxODNFdEJPYi9YTnFDYzRQb0tC?=
 =?utf-8?B?TnVaSk1Id3R5UjhOMHFpUkl2U0g5TFhMWXZMbVRVNVdGdG5YUmtzWjNPVXlx?=
 =?utf-8?B?b3pmM2xNeDg3a1NXYS9rTkxnY2F2ZnVYZk4rZG82TXVhZ25uWmZ0Zk15Z3Bt?=
 =?utf-8?B?NHRJUklGQlpQM253MEhRKys0N3pnQ09iMXlLamRRRVA1bi8xWTlsTXJKaVQ1?=
 =?utf-8?B?ZExSQUxBYURwRkRhZlVXRXlkM2V6aDdzMmdEanhoUXd1dkJDcWpaN0ZVcm5y?=
 =?utf-8?B?ZUVUREZhb3lqR3czbzl1T3J1RnJMR1lNL2ZBUjR3UUE2T2drdzA3RHdrM2F0?=
 =?utf-8?B?ZENSVVc5QUpROEhGZE13SUxWdU1sUGZwWmRWZGR6dVhPSDkwOWtIUm9JVjZt?=
 =?utf-8?B?VUFmR3E2YjdYVkdpYmM2L2grZDR0ZEhWV3dnY1o4bng1NzY2WlBsNXFrZ0hF?=
 =?utf-8?B?N0F1Tk9RV3Y3SkltbkJEb0psWGdwZ1FnckZpVnBhR3U2RVRrT2FNWGR2M0xl?=
 =?utf-8?B?MTY3dGlwdFdGVHpjWGR6ZEtRT2hIUnhUbjBZZE5IaWxhZVlKY1lrRHZTdUJV?=
 =?utf-8?B?SUo0SGY3MW54SVM4RWQvSzFCUnVUaHBTbTNIWU9PZ3U4N0RlcUozOGN6U3FJ?=
 =?utf-8?B?eXExZlF3MEJaTEdjdWtCMGY3NWVjUTZvUEtObTBZWmNlcUZuT2ZmSm9lZE9q?=
 =?utf-8?B?NFplVjI2UkNVSHdyem5ucXk0dGU1OHlDQzNhS1d5eWdCL2QvK2RNMlBzTlRM?=
 =?utf-8?B?VEtHTkdseFdkRWxGNXBQNVliOVEybm14cUg3MlU0RGhGaDdwU1pSSS9CVlE1?=
 =?utf-8?B?RnRDb2hLVnBWSU12Zmd5ZUNGc2NFSmgreUZDcGgvdktwZGc4VnRtM09KZ0Vw?=
 =?utf-8?B?NHRYS1g0OUpiUVVITWVTNlkvcHRwZHZzWkFyYkZ5SFF6M3QrbE0xd1Uwd1BN?=
 =?utf-8?B?VzU3WHViQW8rTGxMS2FZdjN3Y0tEN3plbkt6VnNuUzJYTWZlam5zd01ib1p5?=
 =?utf-8?B?NXVTaWxMbThmL21mZjNON1F1NVp3Z2RxZ3A2NWxlaHVieVB3Q21BUytxeWZo?=
 =?utf-8?B?bVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FA3B5CFB89833E4EA1DCB35182096FBD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a5aa8bd-8c48-4296-ca3c-08dcb60afc18
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2024 11:29:07.4909
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vQ2wqj04oh8wssC7bsQrbDi3QDORzDgIe7uWy1yEd0DhyqjdZsWLKqHEeiLzivK1Fw3hicoGo3h/ADlnz5grAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8776
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA4LTA1IGF0IDIwOjUxIC0wNzAwLCBXaWxsaWFtcywgRGFuIEogd3JvdGU6
DQo+IEthaSBIdWFuZyB3cm90ZToNCj4gPiBUaGUgVERYIG1vZHVsZSBwcm92aWRlcyBhIHNldCBv
ZiAiZ2xvYmFsIG1ldGFkYXRhIGZpZWxkcyIuICBUaGV5IHJlcG9ydA0KPiA+IHRoaW5ncyBsaWtl
IFREWCBtb2R1bGUgdmVyc2lvbiwgc3VwcG9ydGVkIGZlYXR1cmVzLCBhbmQgZmllbGRzIHJlbGF0
ZWQNCj4gPiB0byBjcmVhdGUvcnVuIFREWCBndWVzdHMgYW5kIHNvIG9uLg0KPiA+IA0KPiA+IEN1
cnJlbnRseSB0aGUga2VybmVsIG9ubHkgcmVhZHMgIlREIE1lbW9yeSBSZWdpb24iIChURE1SKSBy
ZWxhdGVkIGZpZWxkcw0KPiA+IGZvciBtb2R1bGUgaW5pdGlhbGl6YXRpb24uICBUaGVyZSBhcmUg
aW1tZWRpYXRlIG5lZWRzIHdoaWNoIHJlcXVpcmUgdGhlDQo+ID4gVERYIG1vZHVsZSBpbml0aWFs
aXphdGlvbiB0byByZWFkIG1vcmUgZ2xvYmFsIG1ldGFkYXRhIGluY2x1ZGluZyBtb2R1bGUNCj4g
PiB2ZXJzaW9uLCBzdXBwb3J0ZWQgZmVhdHVyZXMgYW5kICJDb252ZXJ0aWJsZSBNZW1vcnkgUmVn
aW9ucyIgKENNUnMpLg0KPiA+IA0KPiA+IEFsc28sIEtWTSB3aWxsIG5lZWQgdG8gcmVhZCBtb3Jl
IG1ldGFkYXRhIGZpZWxkcyB0byBzdXBwb3J0IGJhc2VsaW5lIFREWA0KPiA+IGd1ZXN0cy4gIElu
IHRoZSBsb25nZXIgdGVybSwgb3RoZXIgVERYIGZlYXR1cmVzIGxpa2UgVERYIENvbm5lY3QgKHdo
aWNoDQo+ID4gc3VwcG9ydHMgYXNzaWduaW5nIHRydXN0ZWQgSU8gZGV2aWNlcyB0byBURFggZ3Vl
c3QpIG1heSBhbHNvIHJlcXVpcmUNCj4gPiBvdGhlciBrZXJuZWwgY29tcG9uZW50cyBzdWNoIGFz
IHBjaS92dC1kIHRvIGFjY2VzcyBnbG9iYWwgbWV0YWRhdGEuDQo+ID4gDQo+ID4gVG8gbWVldCBh
bGwgdGhvc2UgcmVxdWlyZW1lbnRzLCB0aGUgaWRlYSBpcyB0aGUgVERYIGhvc3QgY29yZS1rZXJu
ZWwgdG8NCj4gPiB0byBwcm92aWRlIGEgY2VudHJhbGl6ZWQsIGNhbm9uaWNhbCwgYW5kIHJlYWQt
b25seSBzdHJ1Y3R1cmUgZm9yIHRoZQ0KPiA+IGdsb2JhbCBtZXRhZGF0YSB0aGF0IGNvbWVzIG91
dCBmcm9tIHRoZSBURFggbW9kdWxlIGZvciBhbGwga2VybmVsDQo+ID4gY29tcG9uZW50cyB0byB1
c2UuDQo+ID4gDQo+ID4gQXMgdGhlIGZpcnN0IHN0ZXAsIGludHJvZHVjZSBhIG5ldyAnc3RydWN0
IHRkeF9zeXNpbmZvJyB0byB0cmFjayBhbGwNCj4gPiBnbG9iYWwgbWV0YWRhdGEgZmllbGRzLg0K
PiA+IA0KPiA+IFREWCBjYXRlZ29yaWVzIGdsb2JhbCBtZXRhZGF0YSBmaWVsZHMgaW50byBkaWZm
ZXJlbnQgIkNsYXNzImVzLiAgRS5nLiwNCj4gPiB0aGUgY3VycmVudCBURE1SIHJlbGF0ZWQgZmll
bGRzIGFyZSB1bmRlciBjbGFzcyAiVERNUiBJbmZvIi4gIEluc3RlYWQgb2YNCj4gPiBtYWtpbmcg
J3N0cnVjdCB0ZHhfc3lzaW5mbycgYSBwbGFpbiBzdHJ1Y3R1cmUgdG8gY29udGFpbiBhbGwgbWV0
YWRhdGENCj4gPiBmaWVsZHMsIG9yZ2FuaXplIHRoZW0gaW4gc21hbGxlciBzdHJ1Y3R1cmVzIGJh
c2VkIG9uIHRoZSAiQ2xhc3MiLg0KPiA+IA0KPiA+IFRoaXMgYWxsb3dzIHRob3NlIG1ldGFkYXRh
IGZpZWxkcyB0byBiZSB1c2VkIGluIGZpbmVyIGdyYW51bGFyaXR5IHRodXMNCj4gPiBtYWtlcyB0
aGUgY29kZSBtb3JlIGNsZWFyLiAgRS5nLiwgdGhlIGN1cnJlbnQgY29uc3RydWN0X3RkbXIoKSBj
YW4ganVzdA0KPiA+IHRha2UgdGhlIHN0cnVjdHVyZSB3aGljaCBjb250YWlucyAiVERNUiBJbmZv
IiBtZXRhZGF0YSBmaWVsZHMuDQo+ID4gDQo+ID4gU3RhcnQgd2l0aCBtb3ZpbmcgJ3N0cnVjdCB0
ZHhfdGRtcl9zeXNpbmZvJyB0byAnc3RydWN0IHRkeF9zeXNpbmZvJywgYW5kDQo+ID4gcmVuYW1l
ICdzdHJ1Y3QgdGR4X3RkbXJfc3lzaW5mbycgdG8gJ3N0cnVjdCB0ZHhfc3lzaW5mb190ZG1yX2lu
Zm8nIHRvDQo+ID4gbWFrZSBpdCBjb25zaXN0ZW50IHdpdGggdGhlICJjbGFzcyBuYW1lIi4NCj4g
DQo+IEhvdyBhYm91dCAnc3RydWN0IHRkeF9zeXNfaW5mbycgYW5kICdzdHJ1Y3QgdGR4X3N5c190
ZG1yX2luZm8nIHRvIGF2b2lkDQo+IGR1cGxpY2F0aW5nICdpbmZvJyBpbiB0aGUgc3ltYm9sIG5h
bWU/DQoNCkZpbmUgdG8gbWUuICBXaWxsIGRvLg0KDQo+IA0KPiBEbyBwdXJlIHJlbmFtZXMgaW5k
cGVuZGVudCBvZiBsb2dpYyBjaGFuZ2VzIHRvIG1ha2UgcGF0Y2hlcyBsaWtlDQo+IHRoaXMgZWFz
aWVyIHRvIHJlYWQuDQo+IA0KPiBJIHdvdWxkIGFsc28gbW92ZSB0aGUgcHVyZSByZW5hbWUgdG8g
dGhlIGZyb250IG9mIHRoZSBwYXRjaGVzIHNvIHRoZQ0KPiByZXZpZXdlciBzcGVuZHMgYXMgbWlu
aW1hbCBhbW91bnQgb2YgdGltZSB3aXRoIHRoZSBkZXByZWNhdGVkIG5hbWUgaW4NCj4gdGhlIHNl
dC4NCg0KT0suICBJJ2xsIHNwbGl0IG91dCB0aGUgcHVyZSByZW5hbWUgcGF0Y2ggYW5kIG1vdmUg
aXQgdG8gZWFybGllciBwbGFjZS4NCg0KDQpbLi4uXQ0KDQo+ID4gKw0KPiA+ICsvKiBDbGFzcyAi
VERNUiBJbmZvIiAqLw0KPiA+ICtzdHJ1Y3QgdGR4X3N5c2luZm9fdGRtcl9pbmZvIHsNCj4gPiAr
CXUxNiBtYXhfdGRtcnM7DQo+ID4gKwl1MTYgbWF4X3Jlc2VydmVkX3Blcl90ZG1yOw0KPiA+ICsJ
dTE2IHBhbXRfZW50cnlfc2l6ZVtURFhfUFNfTlJdOw0KPiA+ICt9Ow0KPiA+ICsNCj4gPiArc3Ry
dWN0IHRkeF9zeXNpbmZvIHsNCj4gPiArCXN0cnVjdCB0ZHhfc3lzaW5mb190ZG1yX2luZm8gdGRt
cl9pbmZvOw0KPiA+ICt9Ow0KPiANCj4gSSB3b3VsZCBqdXN0IGNhbGwgdGhpcyBtZW1iZXIgJ3Rk
bXInIHNpbmNlIHRoZSAnaW5mbycgaXMgYWxyZWFkeSBhcHBsaWVkDQo+IGJ5IGJlaW5nIGluIHRk
eF9zeXNfaW5mby4NCg0KWWVhaCBmaW5lIHRvIG1lLiAgVGhhbmtzLg0KDQo=

