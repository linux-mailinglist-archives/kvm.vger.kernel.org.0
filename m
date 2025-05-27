Return-Path: <kvm+bounces-47784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 72740AC4CBA
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 13:08:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B892317D673
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 11:08:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB35325B1DC;
	Tue, 27 May 2025 11:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jPJVlSmg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E20E25A337;
	Tue, 27 May 2025 11:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748344065; cv=fail; b=rOKyAurWuBQgzYOQjScjVaiZhPgI7TM2+KUeWONVrjyMODroGbPigurkBN5NejUpBvHnPuVYKvTQwr3jU6UnafkAyW/CQ59TSNf02I2J5Dmrvh6aN9Ktl9ld6yJBDZZL0VCcyi+TF71azy6q3Sbfn6T5mT7bC9lTrHHYDJ+Mseg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748344065; c=relaxed/simple;
	bh=oQ7qN8mFRhkvQ8mlEo4sYrdHyclEOpUwXQ/VgnLWtlw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gJkEbKKGdAyDS1W11XdQH1dwD9R+zxA3jdjBQC74GfoUt0UjE5nrPk5ftz/xTC+n1ILHXUXu5I27dduORnvVvavaISdv+OzPt80g8ERMWIrFAbMRZr/Q1MnxI8mCx+pHq0ZjdqAfpIjXAc+9DK6AFh5ixgMTvHyQo/407yoO1ag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jPJVlSmg; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748344064; x=1779880064;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=oQ7qN8mFRhkvQ8mlEo4sYrdHyclEOpUwXQ/VgnLWtlw=;
  b=jPJVlSmgsRz493kFEwqgdJifXPFUk3PFsjpFz1nD/lTubzJUTv880aPa
   c3DLddthHNo/6Cjc+/a1E9/hVRpNmdUPTXPfWwoZzbrmeotuyjIJX6Hga
   mKiCf1kJ4tHeD6Bi66M7fX9AXQoWZhlMr2xPD2wGrykVt9+0U5MIHSBxh
   +F0c425Awxjb5ftZMdW/PmbtHTBEzqtTHlyiBaGatfh5t9yf178lDSb5k
   2tWTqNDUlGkP/7OblI1BDHCTGDnNZkImNOP8oiOGoqfoNGvT6pnUqjwCH
   gRx2/OXdt1BJa0OVhCSkxmuG5pm7R7ZnqKxuIHnDZ9aMKEqhwrNPe7d4k
   g==;
X-CSE-ConnectionGUID: l18PbBRITiKwjY9U2p5scA==
X-CSE-MsgGUID: ujCgNVmSTMWWCNr58XNEmA==
X-IronPort-AV: E=McAfee;i="6700,10204,11445"; a="61681405"
X-IronPort-AV: E=Sophos;i="6.15,318,1739865600"; 
   d="scan'208";a="61681405"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 04:07:43 -0700
X-CSE-ConnectionGUID: +rHfROxtQc2EgSyf/gZHnw==
X-CSE-MsgGUID: MQ4EzHSTSC6UhyDwVcPIqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,318,1739865600"; 
   d="scan'208";a="143385204"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 04:07:43 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 27 May 2025 04:07:42 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 27 May 2025 04:07:42 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.55) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 27 May 2025 04:07:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yH+swlBRVi//s/WB97KcoQuPa/9Czms5d2+R884k3Rndg6TKgKAaJZCw/1efW0Hjo0h2F5nr3Fk3JSurVbRCtskopOcxdct4Dp+QgDSLLSBSa7O/27DQythezyV5pISDM9GGcYi+Dpqf3S0raZ1+gdUgVr99o/7HxD+1uA4gXktmS7Jxy5G5AtmNHeprkiPETlG7UqvtcPys720a+HUdw+GzUDx13wAbfmmhSNTT3NtosgbS+oGu3HLBjk7JPOVOYImz5Qlq2SE6PZOir8eyhC/nI1Z4UE9lJ+FIp5z6O11REPpL86XCI5Zn9A48jV4+zEQXpey/xgz3XxAmpxMISw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oQ7qN8mFRhkvQ8mlEo4sYrdHyclEOpUwXQ/VgnLWtlw=;
 b=VsP21iHPHD6HpKxFICWDFBoAuQJnuMwXRfpd7LAgN6/1bXG58LNUIhgmOxAYwm9SKGsScdmc0mkd1M74Fpg22Lo6i2ukV96kVwW7+FJkDLOYj63MVDzbqpYKnouBDPxE+Z1btqNN8zNXkUfQsDAj9136YyjuUDXurSHh/jVxzZIzYulR9fMSFWa5gv4vmhmmU+v/jpRIfL4oEihIKYKx72PzuaPH2KVpP5ljsY90zDOOM3QwfJhdnorsbxisQR+Nx+Nh12TdAt2QcTezD5L4nrgLmu0QJm5TJPP3FcX5myesRQgL6ng1ybm71a93TvxedMUXLEleTVMN+ZlqgY8VRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DS0PR11MB7444.namprd11.prod.outlook.com (2603:10b6:8:146::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.21; Tue, 27 May
 2025 11:07:38 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8769.025; Tue, 27 May 2025
 11:07:38 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, lkp <lkp@intel.com>
Subject: Re: [PATCH] x86/tdx: mark tdh_vp_enter() as __flatten
Thread-Topic: [PATCH] x86/tdx: mark tdh_vp_enter() as __flatten
Thread-Index: AQHbzn8stz8coGrQ8EK4yIl/ulnPQrPlicSAgADIVQA=
Date: Tue, 27 May 2025 11:07:38 +0000
Message-ID: <3d257fce5c37e6bd73648614bfaabc26de95737f.camel@intel.com>
References: <20250526204523.562665-1-pbonzini@redhat.com>
	 <dba9b129a3d6407948f165b885f9c72975e3231b.camel@intel.com>
In-Reply-To: <dba9b129a3d6407948f165b885f9c72975e3231b.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.1 (3.56.1-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DS0PR11MB7444:EE_
x-ms-office365-filtering-correlation-id: c0c82ae8-5cba-40d0-47ad-08dd9d0eb16e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Q2V1MVZYYWYwb3J1Q25yNldtTXpiQk5qWVcvL0xVNUxDQ0IvM3JkZGc0NjJ5?=
 =?utf-8?B?RkpjOGhBZDIwSGwwVHluTkdXSnRwUVkwWE0rbHQ1cVZldVpmeTRWUnc4blBE?=
 =?utf-8?B?eVNJNFhQdEF4RUNVRXlVekVmclRtUnNqTWdlZ1ZqTDQ4NC9HbHY2QzZzZDln?=
 =?utf-8?B?UTNKbmwwbDFTQ3RaWFFCNVk3ZkoxWVRWRldXVmRFWmxtNjdKZU5Nb0dZODRG?=
 =?utf-8?B?aFYxRXN2eFQ3bWRCMlZ4YWJjd0FjY0dNN1RUTmdZRCthdEdEUklIR0RmRlZy?=
 =?utf-8?B?TE5adjlJTGZBbUsrSHlvc3cra3Q0QnI3dXArOUlCbmxTS3BqdXlFU0RJUTB1?=
 =?utf-8?B?UjNkYm1iTXl3WUtuU1FhMmw2WXhhbm1rcEVHSWRvREVuZTRRd2JmTGI2YVB4?=
 =?utf-8?B?VGhWeEgxRWppb0pTLzA2LzJROWpWUkxZSmRaLzFNRnNobUhrYXJuRDViejIx?=
 =?utf-8?B?VWNUVGlVSklQWWNVT1IrM0p3V0JoYUQ1MU1oZUliMFBqb2NrZXptUGFYUmtz?=
 =?utf-8?B?Vmt3b3ZZVHAvbWhScEhxUFBDRGR1eFdTYjNPcXRiTXBKWmFsbkw1ZDZEcnF3?=
 =?utf-8?B?NnN0VHBOL1JyUUUwdW9KcThFTXBQbVhPd3ZySzNKbE5uVVhFaGUrNEFCZzB2?=
 =?utf-8?B?SVNOTkRLbnIxYWNXWXpOK0ZpR0VaQndQZXNxQWxOUHdtaTc2M3RnbVJhSFAw?=
 =?utf-8?B?SlozaEpVUUIvWkNZcEJDT2xYRk1JdWV0QmppWGJ3b1NKM1FyUTQ5bC9hSysz?=
 =?utf-8?B?emNrSHNxVzJuRGR0eGVSVjRKaFQ1UUVzc090YTRyS2QyeHYvc0tDSk9sTGpC?=
 =?utf-8?B?UHZ4TkpDUWIxa0kvSjEyNmcyL20xdGE3R2w4TVQ0aDBCbEx5S1NkclJSU1pV?=
 =?utf-8?B?OW94b2RLK3NERUNSd0x1RFRWYTBRUmcwM2x5WDZldDVSMnpoekhnUU1uNjYx?=
 =?utf-8?B?clBycERSK0tTalBVald5bG9wV0MzRndhZHFFbHovQWxER250dXNyNVRxY0t4?=
 =?utf-8?B?cFE0bXUzaWxtSllMRDIxZ3FoYjMxdEgzcjRLVHlXUlQvMmN0RjQyMHQ3UWR1?=
 =?utf-8?B?Rm9kdnVVWWlTa1hyV2F5NUE2ZlZSK1U0UVJYQlpwRSt3Y3FRMFhibGNmaVh4?=
 =?utf-8?B?NjZuSkIveUhDL3czSFRKc0U4ZFNMaEtkNms2TkErSUFEMEZsdTNSMlNwUDBR?=
 =?utf-8?B?VWpWWWp0S3YvT01OV3VQbEc4TUJQYnNDUUl2UC9jTzJ0UWpQd0hsbmsvWmJI?=
 =?utf-8?B?SFVDNXc0TWw3alB2RlBDdXlBQk5pRFh5VkZ4WEN2ZmtDNzVYYTQzYnk5Ym1t?=
 =?utf-8?B?OXNQak5oTFlvSG00UllDWmdBRksyd21pR3NQR1o3S2lHU25lVjBqOURVSGdv?=
 =?utf-8?B?aU40VWgwV0I4eVNUTTdYK2Q4aW1OSnNHV0drVjZwNDJ0RU5iL2lDaEpOWnBW?=
 =?utf-8?B?R0xCSTFqOE5YL3VYdFFRVmQyZzJxVTFYeENvZVNROEgzYnpGeW5ORncvaXl4?=
 =?utf-8?B?aXRvem9QaFM0UUpjR0YySmlNN0dNUTVwMU11Q2wxYzRQaU5ZRFl5RFRLeDdH?=
 =?utf-8?B?MUwvdG1TQkdUK1NJZjQzOWM0ZmJrRFUxMlh1bzdIY1lLKzY4YzFaenREa09D?=
 =?utf-8?B?ZHdRb2RpS01rM0syak1vM0RKOHkvdHpJUHJ1NEwvSENTdmFFa0hiTE9Ub2Zt?=
 =?utf-8?B?UjZxVXA1dGF5Qm9JQnNYNkl0RC9MWEN2YjNhbzJuZGpDV3ZHelF1b3NkU1VX?=
 =?utf-8?B?ZytiVS9HWFpMTGlKeUhQKzdoR0xvbitOZ3dpWUlQdEF4Z1hBOVlYendBaHJV?=
 =?utf-8?B?bVp0TGdBN0ZrdjZqY1NsZk05SC9hUzh2d21YajM5RGxJTVZlcjRrYUx1Ylpm?=
 =?utf-8?B?Rk1jUjM4anFsRVhOY2o3b28xeU1MMUQ4RGFjdzhWdVVZQmZCZ3g2b2M0Njlp?=
 =?utf-8?B?cjEvcFdPTURZVS9FQ1NuMFFVWVZYc01QWnJoN1c1NGdPcmxRSW5oek8xL3RN?=
 =?utf-8?Q?totzZQcLf/ts0oB2Be7HFsbzSqy364=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N1AxOExEaitTa1lUQkdjMXVQckdrdS9vSlRsODFFa1dBZmFZaEk3bGhvd21y?=
 =?utf-8?B?Nk5SaGk4ZTJ3WFhsb2ZtYzFXTnlKdEpKczRpdXNkNTVvcEdRcDViZnlzUnFH?=
 =?utf-8?B?RXJKeTNuN2VtYlJ1L2Fyay9yUTBHQkozK1JTa2FwNlE1UDY5ZFpaNmYwNnJZ?=
 =?utf-8?B?TGhaenVjb3hmUUVEVndaQ3ZYczAvTGpLRTVORDFZdy9MUXc5V0JiWkttRDE0?=
 =?utf-8?B?WFNrSDFRcU9zUzdpdHVmNml0N0tza0Q1cVVZS1NNSlJYdEpkYmlwbDQ1amxT?=
 =?utf-8?B?WFJYbEFCSkFJUDdKcXUrWWEreTdTRFlaNmR1NVg3a3g4ZVFVL2hFbk1pZm5z?=
 =?utf-8?B?Z2F3QjJZeDN1T3ZxQVdKc1YwSCtHQ3dFa2NnR1BRMmRIeTU4RTljL1g2ZDky?=
 =?utf-8?B?YVRvcXZhbUlkOUpuT0tvcVV0L1NKQ0txRUR5KzdFQXJrV09EcFZnYzlFbS9a?=
 =?utf-8?B?a3pYYXpaU2tYVzZaZnFIT3E0SlZYMVhvRW9GbzEvZ3crWlNpVmhacUJtVU93?=
 =?utf-8?B?ZEU5cnZGNHRZMkxqTXdSM056L3BvaXcwMWtLWlprU29UNklXeVlBRzJTTXdG?=
 =?utf-8?B?aVg2TjFCc2FOM1N6WTNYaFQxRXJkMGJTV1ErTVVBcXBZZS9rSmZzTDNPR0Js?=
 =?utf-8?B?U3VWMm5nMkd1UjBQNDhwaGFnakphR3I5c24wMHhIRkVTSE5zak9PWFFwd0p0?=
 =?utf-8?B?d28rZDhzdjd0UWt0WDZOenJXK0FPbURHV0ptUVliTCtxN1lNR21ma1hzcm1I?=
 =?utf-8?B?M05mWTd0N3dlU2xEeWFYbWt2YnJ0dUVpWmh0UHExUkdxZGtSTTVydUZ6cElz?=
 =?utf-8?B?T2h4c3dyWkI0K1hvTnlYOFhwWFdlazU2T0ZrM0IzaFlrdDBKRlFLUzM5dXk5?=
 =?utf-8?B?alBsRmxmUGlod1VxcGlBWjBCWHc3YlVPTk1tWkw1anFqNVlaanRkMHZEay9W?=
 =?utf-8?B?NXkwM1B5ZGNNekVHNzR2ZGJUenJmNEhrRXFZTEYvWU1nZm5nSWRnR2Q5RDR2?=
 =?utf-8?B?UmxKenFkMU03M0tlZHRSc2ZmNzJySG4xelJFenFHMDNXc3pjT3NUb3htczFY?=
 =?utf-8?B?TjIyQXpnSWE4d1R4akc2b1VidGZJOTU2bzFhUnNjazlPOTkyR1FzLzBuSVVB?=
 =?utf-8?B?Zm5OUFZoYWp5ZEhiRmxTam5nenU2MDhzQ0VCK2lteE4xTnJSYms0UWlsQytS?=
 =?utf-8?B?azBxYW92cUEvUGxxOTFteWFaK0lrVkdJNWplWHh4a1lvK050VnN5Z29HbnA2?=
 =?utf-8?B?UlV1WmUrd1JTclJyQk1WbGNtWUhJMTR3T2Q5U3dzVWFqWDZHL0E4NjE0L0pF?=
 =?utf-8?B?NjMwR3dJMFRETTRPdG5ucjNCNTNyeGZNTDdjYWk4YXR1MVcwN0ZiRXVIeXhY?=
 =?utf-8?B?S3poOXRkdzBYai9hcWJlWkpLeXNONHA5Tm9sRm1mNnhjUnJqN04yZXVrajRO?=
 =?utf-8?B?NTNySnUrYXF3TE9HRGR6QStxbGtIR3ZNSzd3WURhdU40MDBqU2lXR2wvb1Yy?=
 =?utf-8?B?NTVQVVVBMDZuSlhaZlB6MnE4VjJPcVdOdjJCT3VRSnBGcEVCY255N1UwK2JB?=
 =?utf-8?B?Zk9pR0J1OGEzdUpHUnpRdVN4b1ZxWTBra21EMWNkMmZFTDM2Zk5Fck5UbWNB?=
 =?utf-8?B?MVEvTDgvU0tocEtxbUdHbXd6ZGVmUkFBbEJIemIyY3hwQ1Z0amxqOXhIem5y?=
 =?utf-8?B?S055UHNURno2N0hXWTd5LzZLbk5LMm1ib2dUOEZPKzdUNkFnL09KUnI3Vy90?=
 =?utf-8?B?WUNtd0VSYUFVUER3K1VkNGJ6SmN6NitweWxGSHhIUkMreDdNUVRSbDJUZ1BB?=
 =?utf-8?B?VlZ4SlBSZmlhUitEck1zMjUxSWpLV2lRVXQxY2VoZDQ3SjRjcnd4ZmlvbVlE?=
 =?utf-8?B?OVlNZHNxUmRDcUdOYnpKWVhkOE5yTFplUmhXMENYKy9BcFNWSEhGWTRraGFj?=
 =?utf-8?B?Y1NGQUdzUUI4YzhpRnBqRGRQVjZ5eFlwdzZZZ29zc0kzNEM2ZDJWd1dBY0hM?=
 =?utf-8?B?NjdCWGdEaFMvUExVUnNHNG1MWWMxQTlweWFodlQxSGs5TTF5Z1hzcHBEbnZ1?=
 =?utf-8?B?ZW1BaVFGUjZHd1RRMFFFVDgyb2NsMmp0eVNibmlFOWxOK1V3ODdBQzZkdkxS?=
 =?utf-8?Q?LfDxHKOQX+lVaXF9kBcKeXWsB?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8390B20AF2F8284594ED7AF095912193@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0c82ae8-5cba-40d0-47ad-08dd9d0eb16e
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2025 11:07:38.8203
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NZqw+629/mjalXA65/UjY8OnWFsTaoupowS+Y8U92nEASgW1RfBxylnoAZlNpYK8cjUW0dOouG1oX+oRJvfTFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7444
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA1LTI2IGF0IDIzOjEwICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBNb24sIDIwMjUtMDUtMjYgYXQgMTY6NDUgLTA0MDAsIFBhb2xvIEJvbnppbmkgd3JvdGU6DQo+
ID4gSW4gc29tZSBjYXNlcyB0ZHhfdGR2cHJfcGEoKSBpcyBub3QgZnVsbHkgaW5saW5lZCBpbnRv
IHRkaF92cF9lbnRlcigpLCB3aGljaA0KPiA+IGNhdXNlcyB0aGUgZm9sbG93aW5nIHdhcm5pbmc6
DQo+ID4gDQo+ID4gICB2bWxpbnV4Lm86IHdhcm5pbmc6IG9ianRvb2w6IHRkaF92cF9lbnRlcisw
eDg6IGNhbGwgdG8gdGR4X3RkdnByX3BhKCkgbGVhdmVzIC5ub2luc3RyLnRleHQgc2VjdGlvbg0K
PiA+IA0KPiA+IFRoaXMgaGFwcGVucyBpZiB0aGUgY29tcGlsZXIgY29uc2lkZXJzIHRkeF90ZHZw
cl9wYSgpIHRvIGJlICJsYXJnZSIsIGZvciBleGFtcGxlDQo+ID4gYmVjYXVzZSBDT05GSUdfU1BB
UlNFTUVNIGFkZHMgdHdvIGZ1bmN0aW9uIGNhbGxzIHRvIHBhZ2VfdG9fc2VjdGlvbigpIGFuZA0K
PiA+IF9fc2VjdGlvbl9tZW1fbWFwX2FkZHIoKToNCj4gPiANCj4gPiAoeyAgICAgIGNvbnN0IHN0
cnVjdCBwYWdlICpfX3BnID0gKHBnKTsgICAgICAgICAgICAgICAgICAgICAgICAgXA0KPiA+ICAg
ICAgICAgaW50IF9fc2VjID0gcGFnZV90b19zZWN0aW9uKF9fcGcpOyAgICAgICAgICAgICAgICAg
ICAgICBcDQo+ID4gICAgICAgICAodW5zaWduZWQgbG9uZykoX19wZyAtIF9fc2VjdGlvbl9tZW1f
bWFwX2FkZHIoX19ucl90b19zZWN0aW9uKF9fc2VjKSkpOw0KPiA+IFwNCj4gPiB9KQ0KPiANCj4g
SnVzdCBGWUkgdGhlIGFib3ZlIHdhcm5pbmcgY2FuIGFsc28gYmUgdHJpZ2dlcmVkIHdoZW4gQ09O
RklHX1NQQVJTRU1FTV9WTUVNTUFQPXkNCj4gKGFuZCBDT05GSUdfU1BBUlNFTUVNPXkgYXMgd2Vs
bCksIGluIHdoaWNoIGNhc2UgdGhlIF9fcGFnZV90b19wZm4oKSBpcyBzaW1wbHk6DQo+IA0KPiAg
ICNkZWZpbmUgX19wYWdlX3RvX3BmbihwYWdlKSAgICAgKHVuc2lnbmVkIGxvbmcpKChwYWdlKSAt
IHZtZW1tYXApDQo+IA0KPiBUaGUgZnVuY3Rpb24gY2FsbCB0byBwYWdlX3RvX3NlY3Rpb24oKSBh
bmQgX19zZWN0aW9uX21lbV9tYXBfYWRkcigpIG9ubHkgaGFwcGVucw0KPiB3aGVuIENPTkZJR19T
UEFSU0VNRU1fVk1FTU1BUD1uIHdoaWxlIENPTkZJR19TUEFSU0VNRU09eS4NCj4gDQoNClsuLi5d
DQoNCg0KPiANCj4gSSBkaWQgc29tZSB0ZXN0IGFuZCBjYW4gY29uZmlybSB0aGlzIHBhdGNoIGNh
biBzaWxlbmNlIHRoZSB3YXJuaW5nIG1lbnRpb25lZCBpbg0KPiB0aGUgY2hhbmdlbG9nLg0KPiAN
Cj4gSG93ZXZlciwgd2l0aCB0aGlzIHBhdGNoIGFwcGxpZWQsIEkgYWxzbyB0ZXN0ZWQgdGhlIGNh
c2UgdGhhdA0KPiBDT05GSUdfU1BBUlNFTUVNX1ZNRU1NQVA9biBhbmQgQ09ORklHX1NQQVJTRU1F
TT15IFsxXSwgYnV0IEkgc3RpbGwgZ290Og0KPiANCj4gdm1saW51eC5vOiB3YXJuaW5nOiBvYmp0
b29sOiB0ZGhfdnBfZW50ZXIrMHgxMDogY2FsbCB0byBwYWdlX3RvX3NlY3Rpb24oKSBsZWF2ZXMN
Cj4gLm5vaW5zdHIudGV4dCBzZWN0aW9uDQo+IA0KPiBOb3Qgc3VyZSB3aHksIGJ1dCBpdCBzZWVt
cyBfX2ZsYXR0ZW4gZmFpbGVkIHRvIHdvcmsgYXMgZXhwZWN0ZWQsIGFzIGxlYXN0DQo+IHJlY3Vy
c2l2ZWx5Lg0KPiANCg0KSSBmb3VuZCBhIHJlY2VudGx5IG1lcmdlZCBwYXRjaCBmcm9tIEtpcmls
bCBoYXMgbWFkZSBDT05GSUdfU1BBUlNFTUVNX1ZNRU1BUA0KYWx3YXlzIHRydWUgb24geDg2XzY0
Og0KDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sLzE3NDc0ODY4MzgwNC40MDYuMTE1MjE5
NDUzMjE0ODExOTE3NzEudGlwLWJvdDJAdGlwLWJvdDIvDQoNClNvIHdlIGRvbid0IG5lZWQgdG8g
d29ycnkgYWJvdXQgdGhlIGNhc2UgdGhhdCBDT05GSUdfU1BBUlNFTUVNX1ZNRU1NQVA9biBhbmQN
CkNPTkZJR19TUEFSU0VNRU09eS4NCg0KVGhlIGNoYW5nZWxvZyBjb3VsZCBiZSBzaW1wbGlmaWVk
L3VwZGF0ZWQgdGhvdWdoIEkgdGhpbmsgKHNpbmNlIHNlZW1zIHRoZXJlJ3Mgbm8NCm5lZWQgdG8g
bWVudGlvbiB0aGUgImxhcmdlIiBjYXNlIG5vdykuDQoNClNvOg0KDQpUZXN0ZWQtYnk6IEthaSBI
dWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCkFja2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFu
Z0BpbnRlbC5jb20+DQoNCg==

