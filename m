Return-Path: <kvm+bounces-60432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7127FBEC5DE
	for <lists+kvm@lfdr.de>; Sat, 18 Oct 2025 04:46:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0AC385E3360
	for <lists+kvm@lfdr.de>; Sat, 18 Oct 2025 02:46:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 477B0271440;
	Sat, 18 Oct 2025 02:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iOjc7v3E"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C407F26CE25;
	Sat, 18 Oct 2025 02:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760755603; cv=fail; b=fMF2dtLSgBXuDCbEsf0OxdQz4tnBR8aAH9sDgxJCOqXClYZKgqXPvID4x5ncvbEi3mnSjsJEsiTHXWtwLUGQ1mhBzwDGcrvev0WcqUEBVOx2lpEZOpB4XfLXS2i/V2OJW7B45HwMEZ1oZq68jimXo9B8t+HeVMRgZQErcw5Dpx8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760755603; c=relaxed/simple;
	bh=PoxXnjO1qM1YcsGnIATMDbQ6B2CE5aSToQI82L2TZd8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tJFRAg8zmr6ZTqUaOD5S8PPlmEol48pdBDyf7qbnc6jEN4Okt5LljRybvPVCZOY+61/EcVD8QmY6a1Jkh/JbUAFGfBAzYzPka0hJy3i6gUL4S1a0QoS/4IGMPjmM8/ps+rmYLgOQGaJkQmZV2RW5tWZDjA/c5L8VlX1j4sOJF0A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iOjc7v3E; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760755602; x=1792291602;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=PoxXnjO1qM1YcsGnIATMDbQ6B2CE5aSToQI82L2TZd8=;
  b=iOjc7v3E8SBzm8zuQ3jheic01WaeUftn9oSNXneanGLD+xAKUYHO540Y
   k1uDOxpoxniBxn3hZVnaD8Sucfz64j6nxQ1n+ogOgBuKG4fRw/QkcJIE8
   XEsdQCrYO4Cvuil9CPPYkIvAwmauDi/rAvML581zcRIX2Z5KsEHdskLef
   LyV94/K6ukMMolo75ns3er2nHANbiqcDx0h1JXOjGoYrkn7aPnMUGnSOW
   0bn0q1W6mgs3YYKcxm6Xm55IQhp7bbZkv9LvQw4VOqxFcxPRXe50fC4LG
   mOwWS4ELNLNNqhI+cV5fncU6yvNQkr4lWJlgBt0cxvOXPRa/i1BOeesw/
   w==;
X-CSE-ConnectionGUID: L6vO57MYQ3uh9HtpfBZBOQ==
X-CSE-MsgGUID: H3+TVyqiTRWduWqPgZ7OFg==
X-IronPort-AV: E=McAfee;i="6800,10657,11585"; a="66837843"
X-IronPort-AV: E=Sophos;i="6.19,238,1754982000"; 
   d="scan'208";a="66837843"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 19:46:33 -0700
X-CSE-ConnectionGUID: lykJ2Ek6SN+BsH+7VVY9gw==
X-CSE-MsgGUID: LZVyFVQfT8aloarCaJorZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,238,1754982000"; 
   d="scan'208";a="187289259"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 19:45:41 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 17 Oct 2025 13:34:40 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 17 Oct 2025 13:34:40 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.54) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 17 Oct 2025 13:34:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zNBywVSZDYwrg9zmr6aXzFUrUlrlrYoSefJUnBNl9a89nJnBXE88JVQxAk1uyVS5V18PFrj+vrQfBFT/h+7dggOjH3obJ4Wz9Izi4Nf8MohQxNKILF3HlSeCrzk/Ayf+HNN8W0KBwLzQWmavYUjtq9/MQRGRpMN3/tvuwkdatt4cRYVCRDGfbz6GBUXaAduYvyXDREhQ3IURWYVYibCkty3E6+gPXDVHu6tt+dibA9kzMOjgbGIbgtINNDCRNz7K2IvkYQbZ7v+aJjn+AhC24jxxtS/s22G5DOvxiJ7/AHXesoWEYMEON/dAORij9JmeXJfx3rplRUyq+ajwWNlqSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PoxXnjO1qM1YcsGnIATMDbQ6B2CE5aSToQI82L2TZd8=;
 b=EF4L69S1E+D0BaxPdQduYC1t3ElEAE9tzkbmkjz+rc86lZzv+yLQ+g/rSr+0i0JHECy2DLMLjzYMEqW4zb1DTXr/h2H98dJ2G8T7t7YSC9UWPSdxvtp98qUfWtGTjxOq4sQuqg+Q4OEql8JbJs+43orzNyQGBisU2AHp4ucROMwU9Z364MwRiHAsfwfK704h8zJ72rz1SJFobjUIxvN4PRMznaNOaw//DpUEXNN9OtUeZH58ErvQ3sorJOsm3uIDXHs3Gc10iilW5WEMPnxzOfpoLvee6BkmB6YRw1K1b1pfSORm6gpYJCznGvkuCUcLc3hWis0fmIZo8lZwSqyKGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CY8PR11MB6892.namprd11.prod.outlook.com (2603:10b6:930:5b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.13; Fri, 17 Oct
 2025 20:34:38 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 20:34:38 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
Subject: Re: [PATCH v2 1/2] KVM: VMX: Inject #UD if guest tries to execute
 SEAMCALL or TDCALL
Thread-Topic: [PATCH v2 1/2] KVM: VMX: Inject #UD if guest tries to execute
 SEAMCALL or TDCALL
Thread-Index: AQHcPsnIDCY4Nspo7E6rq2esTUoC+bTGzVKA
Date: Fri, 17 Oct 2025 20:34:38 +0000
Message-ID: <5929bfbf30d4ee97086d1ba6ec3e9904567f28a1.camel@intel.com>
References: <20251016182148.69085-1-seanjc@google.com>
	 <20251016182148.69085-2-seanjc@google.com>
In-Reply-To: <20251016182148.69085-2-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CY8PR11MB6892:EE_
x-ms-office365-filtering-correlation-id: d341c077-7dd1-4470-7872-08de0dbc97ab
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?czlkT0dsZEl6L3N1RVJacUtYazlYWjd2Z2JudzF0S1RsQWxKVWJGTC9CUitJ?=
 =?utf-8?B?RStydy9Xdk9NRDIrOWhoZmd5d0F6M2hXNkdta1FXbFdPMm5Ba0pXcjdSZkxj?=
 =?utf-8?B?Q3JDQzAyR2VNMmthK1FXTkhqQ0FML1hkKzRuYmlVSWNTTDZ2eGpyNWVDMVBj?=
 =?utf-8?B?WEJzU3hJdURkZ3BDS09NdWVNVnpwM3NJMjgyOG5VanhEUlV6WFM2SXRlS1Zj?=
 =?utf-8?B?UlVmY2JDYmV2a3Z0a2ZRTUlzUXBhcjd2YmdIMDV2OGZ5ZWhRRllDT3ZPYWNF?=
 =?utf-8?B?SFhxR2o0cWtxWGE3bE9wRE9hdERBSnc3QkZYY3RxZ2dzRzB0YzJvd3BVbTda?=
 =?utf-8?B?TFMxZjJnQlF3MWI2YkVCcHMrLzdoZ0h5bDU0WEphTnQ0TDBHS2JXWmRIOEw3?=
 =?utf-8?B?T1BXNkZGV2ozNkNZOTJubU1MYzk4Yzh4OE51TkcyQlVMSUIyU1FCazRScE5t?=
 =?utf-8?B?RU9EMXYyWXh0UUxPSkorSWVpTWpTaXdwYStMdy81SW5GYks2SVRzd2VXVFZu?=
 =?utf-8?B?ZTgxTEJlemNjbFo0WE9NaVJidHQ5am4xSTlsR3gyWWgvWjlBZUYrbENmL05M?=
 =?utf-8?B?dnhrMTZGcDAxNHVGLytVYWN4MFhwVnBXbXNGSFZORTh5ZnJtSVROK2I2Y2dw?=
 =?utf-8?B?eWtmYkMxc2pSWk1aZmRlcHVjU1N0OWIxQzhib1ZueFJWTUUvVy9EWTVlckww?=
 =?utf-8?B?SWp1a2xFZm12SWFhenpKRnZwZCtzL0hybjhZTjlJeHMwcHl3R29pM2M2TzYv?=
 =?utf-8?B?b3ZMMS9WUkZCNU4ySHFYMGQycHV1QndmNHVPTXJLUTBHcTNIR1oyL2crNU5L?=
 =?utf-8?B?NXZ5a01CcThSSnZRL0ZmTkg4MFRvUVV4UTUvc3orcUNkT2QwZlVhVjJCeGE3?=
 =?utf-8?B?d0JFcHNMVmNvWnUweW5yZE9UbWxtTU01UzZjcG92NWRobFo3dGlxVVFpV1NY?=
 =?utf-8?B?azVFSFhGcStXa3pSNWVsYXNBNXAwbnE5bzlmWWJKNmlkWWI2b2h4REFCVlhX?=
 =?utf-8?B?dmJHeDRtNFY2a3ZzUlBUNkVkTmhiL2pvdDllNjBRLzVCN1FCbk1nWTlaS0N1?=
 =?utf-8?B?WStTMVJxVVVOSG9XQ3krMk1xOVBKU044TEtIZ2ZBUGZtK1JEeEdlck5BcHNM?=
 =?utf-8?B?d2h6by8xZTFGYm5QeDRFaUFOTU1STkU4ZnNuYWdCS2lmaFVNOWk2NllBek5M?=
 =?utf-8?B?UVBuVzg5NnVROGd3bUExU004MFE5R3Q5MUNlbFFnNmU2c0NDZjF0K2RHWU1v?=
 =?utf-8?B?WmtQMDN0cTExSTB0LzZsTmJteHJzUnBmeWl1MHgySmM5bjQrOHI5ZTFvRzly?=
 =?utf-8?B?aXp1eUJkOGg2NlI0QlBmRWVLbWlZK0xzWkxBVWFpNzl3MFc4UjZWOU9nanVu?=
 =?utf-8?B?bHprYzFRZ1NhaTVVOEN0NUxLOC9QWW1MTEh5YWsrdnFBeFc2RGQyM1dKTVA5?=
 =?utf-8?B?OUwxR2xYbWhraGpuZTMvTmtDT05HTE1UK3dZcXRGVGNrZ0N3Y3B1VTdoeVVI?=
 =?utf-8?B?YTJlY3BYZGRVSFg4Z3hlbmg0T1VHVUphbE1mekRIenJiSWZOZEJIWE1sTDg1?=
 =?utf-8?B?NHVNcjBwME8wYWdGcnluV1JiTXJPemdtU2JHTmJnS2hpSCsvQzhYSURHbFRz?=
 =?utf-8?B?bVZXVTVpRkJNclFzUms3VU80OTR2MzEzNVZFeHJRVjFGOVlPVXpXdlM5UFAw?=
 =?utf-8?B?OUNRajZ3Si83ZEJrL01XZXRCZk9mZzdhcU85dkk5R3EwLys3ODkwVDlTZmto?=
 =?utf-8?B?R0dDb1R3WlZqQXdKK1BTczBoTWsxQVZjTGl6cVJnVmhQck50ZDRaOTlBUzNL?=
 =?utf-8?B?VkREMU1nT0NXMjNOM25KRE5NUFltSjRDRUlWdFhvM2lBZkpMNDBSSENyS0Rk?=
 =?utf-8?B?MmxEVGRLM3NyMW9ncUgxRGNjRlZEUGdSNGtYUGNnaU5zUDZ5Ymh6RUVFRzRm?=
 =?utf-8?B?cXkzaFlKRHMzMkt5YXlHWDJXZHVUOThwVjZJenJUTUxGSTdwSDVYWklIRmdF?=
 =?utf-8?B?eno3amJxWjhwVkFEZEIvQnVxd2NtZDNadTNWVEJsQnVwQ0J1OG5mTG9nMzVq?=
 =?utf-8?Q?cAUe3+?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Tm1Qd2dJWnRhY2ZleVBENGxwNUg1VWdNOUJCdnZMRUltRDFvc1dJbXB0SzJo?=
 =?utf-8?B?aEhKVVQ0bWpkMlJIdnVJM1NXWkxjZ3g1WS9EUlRNaXN5N0hrQVY3SXFuVVVa?=
 =?utf-8?B?SWFjNUFla0I3clBKb2lNNFIrcjJPWTkydXRONGh1bXdMNS83R282cjZIRXha?=
 =?utf-8?B?a3RBZGtjUThjVThRL0JJRkhCN0dId1U4QlFlYm52eW54VHg0Z0VIVW9VQjlM?=
 =?utf-8?B?YWY1N21ubzEvYS9DU2tLck9sa0tBdFplMmJ3ak1XNnloT2dJaUZ1N0g3NWFG?=
 =?utf-8?B?dEJCNFE4R3Z1UDdnWFJ0cWZpRDNIWUVXTDFGc05WUk5IZjl3QnhiamJ2Sjh2?=
 =?utf-8?B?NUs1NUtkQVdXN1dybHlpd2wwenRFWUpHK0UyRmlNdldFMzh3WkRHbU93Tllu?=
 =?utf-8?B?WUJTR05UcC9aRStJWTRCbjhwSDV1QUFaSElYQW82NTFTZlltaGd1RkplZ0NT?=
 =?utf-8?B?MnZ6VEZCaU9hcE9pYzgwWUo0eFhRaFBDMDJvakV3Z0s2MHBCT2hpQnV2Q3U5?=
 =?utf-8?B?VUU5RVI1aEN5b25pUjB1STkwd0NKajlidWlPc2dJaXFnSlRRNExZYVpSdFlX?=
 =?utf-8?B?aFNjRUN1M09EK0Y2Y2ZVZzdrU1dUNVI0WmVUUk1JWG03V0pKWDN2ajJnYnRw?=
 =?utf-8?B?akZ4L2gwNUZpcERCWUlvblVGbmhaN3RyVUZzcnM5OHJvZnRDQU84cnZ2OVNX?=
 =?utf-8?B?OFI4cEVrbDFzcVFuaU9FaGV4NitBSjNWbngvYnV6RkgxOUxtL1BnOEZHa1Vj?=
 =?utf-8?B?UnJMMnBGK1FzQTIrSWlxOCtqRGxSZnRKRGZ3L3AzWEZ3S2VaZk4xaWNySFVQ?=
 =?utf-8?B?MDYvYXYvbTNHenA3TjdtVDBVWWpPQVNSOHVSSXhDOWFGNmxMczB0YitGL1B0?=
 =?utf-8?B?c3NsV3l2SUkrTFVDUEtNZWZyNk82b1JsdU1iOFhtckIzS296bmowemRLTGpU?=
 =?utf-8?B?UVJSQ3ZqVmM2WVdFZllYUjg2eVhjczRMOE5MQlFGSWtzbENyc0MyNmg4dnVB?=
 =?utf-8?B?cTUxM0FnL0J6aHp3OEpZaEd4NlpSMDlqczVLamRaa3pMSEdkMTlnQXlqM1hX?=
 =?utf-8?B?TTJickNaSHh6WVpyMVIzdmhzY2M2VFdIZ1d3YVFKeldyM1JuTDlRT1ZISG1p?=
 =?utf-8?B?R1RyWEZYdGVibmdibDZwbmUvTEFvNHdVTU54SFEzbVd4V0cxcHBZbXZ5SW5o?=
 =?utf-8?B?dkJteW5kUnlMeGk0dk9wQ1RoajUyWVVKZWhhVGpuRG5qaU0yZDNNbTlnTkR4?=
 =?utf-8?B?YWw5MXRmVTZMTVZENERhZlhmMHFRTzY0S0hPZGJXNWE4SXJ2ZnBZM2VGY1pS?=
 =?utf-8?B?WGJZSk5PVC9wWmdWMkRoYmxNRzdrSmNpTUhrRjFiU3I5TFAzMFQwT3JsRi9D?=
 =?utf-8?B?QjJEd0ZBYmF6RXBpQ1I4TnhRR0pVdmRwcWJlR1d6TFFvV05qaTdXU25VU252?=
 =?utf-8?B?Y1Q1aXZpSHlDSzQrUHRxZkxGN2NtVDZhQ0ZOV01neHB3RlpXM1hqNGZ4emhO?=
 =?utf-8?B?NUV5UkRGOTBUZDVuQVpiVkQ0cDdITkpGNlowL1RZRVhWV1dxRGlLWDJVR1NO?=
 =?utf-8?B?TWo0Z2xNN2E5RFMydlorbzM0MVhxbDVHb1ZjbW9ucVVIRTB5OTl1dFQxUHR3?=
 =?utf-8?B?ZlVaNlBTeFY3a2paRGdVU3oyNzBpUDVWUnJnaDlmOWZha0poR1cvSUFpNFZt?=
 =?utf-8?B?QXlaT0Vmb2RsVE1DZjRvUHZacGdab3lDU0hTRlMwTVpkU1NMd1R4VzVGRUY0?=
 =?utf-8?B?ZnIvM3pVT2hqSWR0SHEvRDlNQkMrbW1LYlpubVg1QXo3TFI4L2lXTjVwL0Zj?=
 =?utf-8?B?QWhJWEYraVF5WDhMY1lvdk5WZ1dQWEFqSWFRaUIvb1pCRFRVYW9rdGExbS9k?=
 =?utf-8?B?TDBRR29ydldLU0ZvMjJWZ1lZZGJqQ09uczZIaHVSdjlsWVRyYkd5dk44d2dU?=
 =?utf-8?B?Yk5USllBR0FGemU3SDBkTnNzLzgzU1FUWi9mUis1dkVyMG40a0UydG44SEtT?=
 =?utf-8?B?ekNtWENFUGhzQjNmY3VFUkE5WTVMVVRyRW1FbHJSbGE1ejZMZ0hjZ2dnWnFT?=
 =?utf-8?B?b3VZSlVSY1dSd0tmWVh5Z2Q4eU1lOGtxaDZNRk8xclFTTDhtby9qeFkyNmZT?=
 =?utf-8?Q?+EMCasvsD8jucbv10yBixmCh9?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1F045F2A605AD449AEECB555256DD5ED@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d341c077-7dd1-4470-7872-08de0dbc97ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2025 20:34:38.2278
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3Tyne/TTBxtiK95/UIY3lv+oqul2WSI33SD1yiY2C2z8QyYjDdM/DLPLSFGDWRWdEvkOnUCOc34Cern2H4h8eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6892
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTEwLTE2IGF0IDExOjIxIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBBZGQgVk1YIGV4aXQgaGFuZGxlcnMgZm9yIFNFQU1DQUxMIGFuZCBURENBTEwgdG8g
aW5qZWN0IGEgI1VEIGlmIGEgbm9uLVREDQo+IGd1ZXN0IGF0dGVtcHRzIHRvIGV4ZWN1dGUgU0VB
TUNBTEwgb3IgVERDQUxMLiAgTmVpdGhlciBTRUFNQ0FMTCBub3IgVERDQUxMDQo+IGlzIGdhdGVk
IGJ5IGFueSBzb2Z0d2FyZSBlbmFibGVtZW50IG90aGVyIHRoYW4gVk1YT04sIGFuZCBzbyB3aWxs
IGdlbmVyYXRlDQo+IGEgVk0tRXhpdCBpbnN0ZWFkIG9mIGUuZy4gYSBuYXRpdmUgI1VEIHdoZW4g
ZXhlY3V0ZWQgZnJvbSB0aGUgZ3Vlc3Qga2VybmVsLg0KPiANCj4gTm90ZSEgIE5vIHVucHJpdmls
ZWdlZCBEb1Mgb2YgdGhlIEwxIGtlcm5lbCBpcyBwb3NzaWJsZSBhcyBURENBTEwgYW5kDQo+IFNF
QU1DQUxMICNHUCBhdCBDUEwgPiAwLCBhbmQgdGhlIENQTCBjaGVjayBpcyBwZXJmb3JtZWQgcHJp
b3IgdG8gdGhlIFZNWA0KPiBub24tcm9vdCAoVk0tRXhpdCkgY2hlY2ssIGkuZS4gdXNlcnNwYWNl
IGNhbid0IGNyYXNoIHRoZSBWTS4gQW5kIGZvciBhDQo+IG5lc3RlZCBndWVzdCwgS1ZNIGZvcndh
cmRzIHVua25vd24gZXhpdHMgdG8gTDEsIGkuZS4gYW4gTDIga2VybmVsIGNhbg0KPiBjcmFzaCBp
dHNlbGYsIGJ1dCBub3QgTDEuDQo+IA0KPiBOb3RlICMyISAgVGhlIEludGVswq4gVHJ1c3QgRG9t
YWluIENQVSBBcmNoaXRlY3R1cmFsIEV4dGVuc2lvbnMgc3BlYydzDQo+IHBzZXVkb2NvZGUgc2hv
d3MgdGhlIENQTCA+IDAgY2hlY2sgZm9yIFNFQU1DQUxMIGNvbWluZyBfYWZ0ZXJfIHRoZSBWTS1F
eGl0LA0KPiBidXQgdGhhdCBhcHBlYXJzIHRvIGJlIGEgZG9jdW1lbnRhdGlvbiBidWcgKGxpa2Vs
eSBiZWNhdXNlIHRoZSBDUEwgPiAwDQo+IGNoZWNrIHdhcyBpbmNvcnJlY3RseSBidW5kbGVkIHdp
dGggb3RoZXIgbG93ZXItcHJpb3JpdHkgI0dQIGNoZWNrcykuDQo+IFRlc3Rpbmcgb24gU1BSIGFu
ZCBFTVIgc2hvd3MgdGhhdCB0aGUgQ1BMID4gMCBjaGVjayBpcyBwZXJmb3JtZWQgYmVmb3JlDQo+
IHRoZSBWTVggbm9uLXJvb3QgY2hlY2ssIGkuZS4gU0VBTUNBTEwgI0dQcyB3aGVuIGV4ZWN1dGVk
IGluIHVzZXJtb2RlLg0KPiANCj4gTm90ZSAjMyEgIFRoZSBhZm9yZW1lbnRpb25lZCBUcnVzdCBE
b21haW4gc3BlYyB1c2VzIGNvbmZ1c2luZyBwc2V1ZG9jb2RlDQo+IHRoYXQgc2F5cyB0aGF0IFNF
QU1DQUxMIHdpbGwgI1VEIGlmIGV4ZWN1dGVkICJpblNFQU0iLCBidXQgImluU0VBTSINCj4gc3Bl
Y2lmaWNhbGx5IG1lYW5zIGluIFNFQU0gUm9vdCBNb2RlLCBpLmUuIGluIHRoZSBURFgtTW9kdWxl
LiAgVGhlIGxvbmctDQo+IGZvcm0gZGVzY3JpcHRpb24gZXhwbGljaXRseSBzdGF0ZXMgdGhhdCBT
RUFNQ0FMTCBnZW5lcmF0ZXMgYW4gZXhpdCB3aGVuDQo+IGV4ZWN1dGVkIGluICJTRUFNIFZNWCBu
b24tcm9vdCBvcGVyYXRpb24iLiAgQnV0IHRoYXQncyBhIG1vb3QgcG9pbnQgYXMgdGhlDQo+IFRE
WC1Nb2R1bGUgaW5qZWN0cyAjVUQgaWYgdGhlIGd1ZXN0IGF0dGVtcHRzIHRvIGV4ZWN1dGUgU0VB
TUNBTEwsIGFzDQo+IGRvY3VtZW50ZWQgaW4gdGhlICJVbmNvbmRpdGlvbmFsbHkgQmxvY2tlZCBJ
bnN0cnVjdGlvbnMiIHNlY3Rpb24gb2YgdGhlDQo+IFREWC1Nb2R1bGUgYmFzZSBzcGVjaWZpY2F0
aW9uLg0KPiANCj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IEthaSBIdWFuZyA8
a2FpLmh1YW5nQGludGVsLmNvbT4NCj4gQ2M6IFhpYW95YW8gTGkgPHhpYW95YW8ubGlAaW50ZWwu
Y29tPg0KPiBDYzogUmljayBFZGdlY29tYmUgPHJpY2sucC5lZGdlY29tYmVAaW50ZWwuY29tPg0K
PiBDYzogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+DQo+IENjOiBCaW5i
aW4gV3UgPGJpbmJpbi53dUBsaW51eC5pbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFNlYW4g
Q2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiANCg0KUmV2aWV3ZWQtYnk6IEth
aSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCg==

