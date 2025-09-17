Return-Path: <kvm+bounces-57837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 08126B7E1C1
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 14:42:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2336B16876D
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 10:13:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3FF6350D7B;
	Wed, 17 Sep 2025 10:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b/mN26Sy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACAC42F3606
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 10:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758103998; cv=fail; b=urB4dctQ90zAu+glItxuouI6AzTUyQc1Fv8mj/Rs8pf1Cj0RSJOHui2j5opUoBya3scLYaeRKtn7Awr1xMXz3Dq3hre1vhX/7nlUbppn2hH4SPMli/AOJZgOXN+Vv4lVuw9QgK4J/i3JBhenzuepC8y5FgQLU4Fx2E5zRaRJjNY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758103998; c=relaxed/simple;
	bh=ikSwt5wsdwiHrFKpbEuwF0sLPG1GlrGmYw4QQjdac3I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FVojCvFSMSuatKxJF0G7vifZH7hTCf/zyPvptc7nQa6bXyjEkW8Jodz8Q8wRogP7vLwY0IoIJ38mWaYTQvIRtqLRos7A6HY39Se/tJ+/wTJYs8jRqJNEMlIFZHoH2mOABPCWg2ezxSjci5Rq4IALWPn60bNIJmJWnD6sz+pqBsE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b/mN26Sy; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758103997; x=1789639997;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ikSwt5wsdwiHrFKpbEuwF0sLPG1GlrGmYw4QQjdac3I=;
  b=b/mN26SyO95HnExNDjtAid6rkZysw0kcX0HdisSMRE3Wjntm84dmrbJP
   8BsR+6s+DJWrCW7YIT+8SGGi+DZ7U+JjpVGMlm7fnVOgkZj26u1dVDhQg
   bPKgh2TFn0ZdfmQlTNngZQCfD0ouDYQ27vBZyGAxalnC987I5Z1lJD/nM
   vKXixOtizecbm+yn6OEqS0S6Wsr41ikAYHxWmYOgGVYGqk7NE3cR99H5L
   JI7DnUJ3lOWgGzZWIF4fBDJ994RxxbmDyaorBoWIhyaqDJBasZj5KHlZq
   ZQGrgi6f++UALuz2+5rPrlCYEKWav5NJ7Ax0AP9lCGDjVxNz1FaZbiC4Q
   A==;
X-CSE-ConnectionGUID: nvnVIekIR5SzPRj0jS/+tA==
X-CSE-MsgGUID: MHqA7Ed6SHWT2SuM5RpQrA==
X-IronPort-AV: E=McAfee;i="6800,10657,11555"; a="64037892"
X-IronPort-AV: E=Sophos;i="6.18,271,1751266800"; 
   d="scan'208";a="64037892"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 03:13:14 -0700
X-CSE-ConnectionGUID: Lm56HT6HQ1K75t6sUcjcgA==
X-CSE-MsgGUID: OjypGun3TmKMSXb++Qvd6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,271,1751266800"; 
   d="scan'208";a="174812799"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 03:13:14 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 17 Sep 2025 03:13:13 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 17 Sep 2025 03:13:13 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.34) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 17 Sep 2025 03:13:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UT2LdCSTUdIC245NrGGSB7kDb3vpe3MYg9hCgAGOUHMVRWYK5fnwjjIoUTYTtbEmd3363QQsOrc/dj+PsfUopfGi0duJOXE2yznGgqqJ0Nm80bBqsJVeeTyrwXbVN1AF3xXa4iDQTuMshMy01Z5ZfpUap5o11Tnk1RZ+ha1JPJJlbJHlUySp5X+EQ79FdKYzT/tcVMkNicsFDdL2CGiosGt6KN8QmD/PWYF7eFIyaABF/npcNhhhUHas7Epi59zwuzjysU4TArTXWLmWJxxxQXRfqMtc38Q67phDC65ws+JRpvTMAauO/ejUw7lof5jrBs+Y64CyD6FZrixk0daldg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ikSwt5wsdwiHrFKpbEuwF0sLPG1GlrGmYw4QQjdac3I=;
 b=C3V4kuUszDHY9AyQrtZtQxnDqhvbSqZZL2LG3up+fbYPRI0ccVPFfok0svh1WX6X8QBJOUQGZKK289yH2qIj3pc8ZKYDVFyt+sMPZikNjJK4LVekytaaFFoZx6uKoyVOMX4yUFUihRBVIKYGPXInId9UNmIyaU6qPxA62YvdgO5j9tYFlFiEN9FI2Ejo8TEH1SG6MveIlbbSFMxjY09VI9rIK04lLgkoRyD413NFBUYa4n9DNbJAHiBBQ15ZwCmCbqMgv6SFslkgWXo419B00d7JXS8Sx9iU7g5KXAdlBGXec7MMV4PCZCxMl+Wr7RKrwu5woQybUZVUb2VnBrfqgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH3PPF4324011F4.namprd11.prod.outlook.com (2603:10b6:518:1::d1a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Wed, 17 Sep
 2025 10:13:05 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9115.022; Wed, 17 Sep 2025
 10:13:05 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "nikunj@amd.com" <nikunj@amd.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v2 2/4] KVM: x86: Move PML page to common vcpu arch
 structure
Thread-Topic: [PATCH v2 2/4] KVM: x86: Move PML page to common vcpu arch
 structure
Thread-Index: AQHcJh86omC9Nm5qh0mOG0q54ZAePrSVnKGAgAEeJoCAAHBHAA==
Date: Wed, 17 Sep 2025 10:13:05 +0000
Message-ID: <5e6c276181bdfab55de1e5cd5c0d723e76cfbbea.camel@intel.com>
References: <20250915085938.639049-1-nikunj@amd.com>
	 <20250915085938.639049-3-nikunj@amd.com>
	 <fa0e2f42a505756166f4676220eff553c00efb1e.camel@intel.com>
	 <80fd025b-fd3b-4cf1-bcab-20d5b403666a@amd.com>
In-Reply-To: <80fd025b-fd3b-4cf1-bcab-20d5b403666a@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH3PPF4324011F4:EE_
x-ms-office365-filtering-correlation-id: c67177b2-bfaf-454b-bbab-08ddf5d2cb15
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?UUMrTHdLazVKWGFQR2kzVVUwWHF0azd5dEN3SkdkaTUzUWFKcUgvMFN0YTQ2?=
 =?utf-8?B?YjM5bks0L0M2TUtOUytHSTN2SlRsenJHRWpCTDdGTjFnbzRLMVQ5ZW1sbjRG?=
 =?utf-8?B?NTdGV1ZsNS9CYUJMYjhwc3FWVkdsWkVvbVlsQ3F6Qkh4dTMza01zR015UENj?=
 =?utf-8?B?blZuNm1Kd1hmdm03bTJOZ01jbjA0U3hybHN3bk50LzNQOFhqcE9Ea2pKUVFp?=
 =?utf-8?B?MHlacU9URDlwTVR6YUgwYlViSk5SVG5lcXJwTEpYS1ZlR2tESUJlNG5vU2lj?=
 =?utf-8?B?VTFtZnl3dm5aL05PbWd3NkFFMXk3NEQyT29YLzl4MkpuRnZ4TU13VWljaSsr?=
 =?utf-8?B?Z1V2Vm56KzZwL1MwZEMzZGJnYkl4L0pJSisxZ3JxSXRZdGtEbmVET2pjOTVK?=
 =?utf-8?B?K3BDN1BNekxDRlF5VlJFMVZ0Yi9jTVVkQlU5aUVmYU45WWt4UEVUaWNjMGJy?=
 =?utf-8?B?MFhwc3VjVXY4OVBZdk9sYW9SeVRObFBydWIrYmxzY0dxaW4xT2UyWEJjaGJ4?=
 =?utf-8?B?M0UrLzA1UnZHd2NHd1lFZnV4V0ZyUTgyQWRDNEt2RzRrdDI5aFdhemJJandy?=
 =?utf-8?B?UGFNbWh1aXVKWE91WklCZzZEZkUvSS9jVXJzV3JFd2xBakVBUDFvbUNxKzVm?=
 =?utf-8?B?MCt5dGZydUZvYUpPR0JJdmhVNjFuTm5IOFZBUkpUVTY2K2tnSHJoWktsbGNR?=
 =?utf-8?B?ZWNYcnp0WWVwZG45ZzVOWkZndEJyd3EvbllaQjRjcUVMRXlTUVVxMXRUd3pD?=
 =?utf-8?B?WkJSaExYQU1jRTRCYlh3TlZva3dDdjhwSlhWbW5zbExiOHdLbmJveUxEUWgy?=
 =?utf-8?B?V1B3MWRPeTFySWhpUnljTkVSaUNERWlHRkxwdHdjejhBQkwzdWZRSU95QWNm?=
 =?utf-8?B?NkVIY0dmelorcDlwU2M5aHdDMjNsTVhDcDlMOUh0ZkxwM0dzMExWQXZGRlJZ?=
 =?utf-8?B?eVZnbDRvZjVwOG5KMjVDVkNyZHU0OWJSSHhKdHhyVS9uTEdaNHM1ZENYZEw4?=
 =?utf-8?B?d1R6cURvcmdPSWJsQkpWRTBKZDE3ZnIrY3NBUGJqc0FQK0E1bFNZRnVGajNY?=
 =?utf-8?B?azAyVjM4bWlVclU3ai8xL2l4dFJaNnJOdjRxMit3cFc4M1ltb3kwUDZZRnFK?=
 =?utf-8?B?Q1JCakNKOCtrMU9kQmZjMThBMnVOcjZJaXdFZEtITXo1aFFIUUIzbmZhZHdF?=
 =?utf-8?B?cFkxMWV6K1JSQjZTN1RuaEQyMGFUQS9iQ3RHVGxqa1lzcnBleWNpSVVVcGhX?=
 =?utf-8?B?Y1g3RXB6aVNweGRQWXVJdTA2SGNGMEJ3VDgzVHpRSlFwSjNUL3drSmV1aWww?=
 =?utf-8?B?eW9Bbm01aTBpamt3U09QaVloa2xPcWxvejlWYmtvNGhmbnc4czZtUEhJT3ht?=
 =?utf-8?B?TFVQRWhSeWZzQ0tHeVEzOUg5Y0R6Z09NeGwzbVBTL3RoS0pOMjRLaFhJdzc3?=
 =?utf-8?B?Y3BjRW5uUXRzZ0tlOElRZGxoc0FVQVFRREdhd04vN0lqWER2cGkvQ0pWRWQz?=
 =?utf-8?B?TkRzWG5STE8vODV1Tm8rU3lYUjVNWFpWc0dsMGtPNVpVZjdNeXllNzJuZmRD?=
 =?utf-8?B?Wmw3WUxKMFR2T2Zqa0F3dGx2WUdsM1d4ckdYZDNUUExpeGl6ZnFhRnliZ05o?=
 =?utf-8?B?eldlSXBxSHZ2T3ptUWVJZmNhajJjTnl1NWZ2cmNiNTRlQlFFczZWZGVoUnlG?=
 =?utf-8?B?bzdTRngxSDR6ZGpNLzN3V0lzSVJJSjZLTFB4SWg5aW9LZ3dpS1VWdU12cXZM?=
 =?utf-8?B?a1diMk5RMEVxRFZabG81cUpYRVUvTmszMzArdExCOUdOUDBOcktuRjAvcG5R?=
 =?utf-8?B?SEhJbkdKbHdnVTNCdDhJT09PWmpEOTRiMXVxeE5vRU95SGFxNzh6anFpMjgy?=
 =?utf-8?B?c0lQcll6dlF5VGFMMVo2ZVVBbUdMdjJoWlp4Z3lBUDAwekZFcmtpQTRBQ29K?=
 =?utf-8?B?Uk1wZks3ZU5zSEZzR0xKRTJXTlhzRlFOME0wdVlCRFBjTmc1TnZ2Q1grK2Nh?=
 =?utf-8?B?T1VuS0RYU3h3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SWp0OFpmVSswMW96OWpURU45bEp6eGRsd1cvaWdLWXNzSUVOaW4zOEpkNW5l?=
 =?utf-8?B?THBPWUE5ZGV6YkxwY0MzOEpoSG1DWFZtMkpUWHU3NXlmU1BIQUJsdllMSndI?=
 =?utf-8?B?YUNabFR0VWVKTUxYa1FoNThPNUkyVFZ0N0lRWVZPSU01YjNCQnVNTm05czZo?=
 =?utf-8?B?OGFJak8xdVlzQStHeDNRMVlvbVNnbS85Q21pcll5dkZVY2FWcHBSRzNnMys2?=
 =?utf-8?B?dWdtQVBxTVA2OGJ2cHRNUkE2V1l2S21GT2h6a2puNnNaQjhDcnVPU2lJb2Jr?=
 =?utf-8?B?dldJTDlTUjAveVVoQ0FldHh1bnR2b1pqYnRuUEk2MUc5b3VSQ3VXb09QRlg0?=
 =?utf-8?B?SXJqdytZbkVrMmNEczVJZjlTRHM4OTdteGpGVUZpOWpqWTZpQXJ4K21PTVlz?=
 =?utf-8?B?aWx2U1NWOWJSdXZyajlZMUQ1cmM2WGJkNDh4akcyQW9XdEd3UFlBZnVYbmI2?=
 =?utf-8?B?TXJQUFpCU0lhM3lCNzNYRE9FTkdEK2R1VDZCNjUzQ3p0VjlNajEzSFJXMnBz?=
 =?utf-8?B?K3JsN241U2UzL0ppWjUzWkJUOUg0TCt6YlRtZ2JRVkJUTHlOeGFEUFJXc25n?=
 =?utf-8?B?a0w4MGt3dExML1pVQXk5OG51aDdhWGg3MFoxQ1pLczR2ZllaLzdIMWNXWmxl?=
 =?utf-8?B?UE1nL2w2dVk5V2R3cmEzL3FML1c5MzZXdTlzQWxDMWxGSzdWRDFNbmNmOUlG?=
 =?utf-8?B?ZGNvM3hKaGxNaE45NDE2QVBpVWF5MlhJcmJUODJRTDRhM3YwWEVXLzRaQk9K?=
 =?utf-8?B?OHM4aUlrYnBZZG5tSnpUeHdmTFJZYVlPQTRhSnNTYStpRG9iQkFUTkcwWXow?=
 =?utf-8?B?SjhBUUJQdVp4N1MxK2s5dmhwVThmMXM4V0wvdktFNGRNa2xxdm9ibFR3VFkr?=
 =?utf-8?B?TVVhRkZsKyt4UWZtakU4ejh2cisrc0hjV01zYk00UzJZR1llUnloQ2FNa2RL?=
 =?utf-8?B?c2J0azZrR0V2MjZndFRLQWxacXU0Z1BMWFllLzA5OSsxWHVWdEc4a0c3dVoy?=
 =?utf-8?B?MjBnRXlZNTdWN2swOWJaNkpkdkJRK2xvaGxZTmNtVUlPaWt5aDFGSE5sVzFM?=
 =?utf-8?B?LzZhaTBqbm5DL1J6NjBWUTR2OFkvQytLTXF3aTBBOTJaNk52dHV0Nm9zTGtm?=
 =?utf-8?B?VXkxdWJzK2RLeEdHVHdpdjJZNFhRS3BuYmE5MExzc0pWbytuNmVKaUlKMktG?=
 =?utf-8?B?NmJtMEdHZlJKTlhBTWZOVUVFUkNOOTVPajg0T0QwRHN1eTBreXQ1NTArNkc3?=
 =?utf-8?B?eFh2ZEJJNytCdzFZL2dqUHJCTTFQcFllakMzUkZvcmFEZCtIVFJ2UC9XdXds?=
 =?utf-8?B?TFhkTGNpWjFPZm1EL2RzcWtZdmF5eDlvNC9ubkNTSlJkVDNsOE1LK2dxV1Nz?=
 =?utf-8?B?S0lOdDBHYmZSWEp4RVNnMTFIdlp3VWJtTTNLV0FvQTAzRnhXN05INS9nVWQ4?=
 =?utf-8?B?N005MWc5eHhUTU0rN0Ria2d2c1ZaYytPVXBsTWVxMXl1ait1Z1JGMkpaVDAw?=
 =?utf-8?B?ZTBneG9xQWZoWjZNdlFGazEwRzRwZWhyRERmekJISVlwNXlpZk1EWnhXdzZT?=
 =?utf-8?B?am14MFh3Q2pMTC8zMlNnTVk5eXc2dXRySDlyV3JZMEFXSE9lYm0xSThWUGUy?=
 =?utf-8?B?R3ZReTBweGdvaEhRb1J5OGpsRGE5RWdsWTNkSERzcUNDUW9VNUw4QTl2cVBI?=
 =?utf-8?B?Wm95MjFWRXM3WkhURUJERlJRZTZkWlpJaEU0RHZYaDhEMUM5dGJmQ3luTWxB?=
 =?utf-8?B?RDltVEVFdUZGQ1pGSWgxaUVqTTlEc0Q2VDJCckthd0lTRTNHY2k3UGhqYm8w?=
 =?utf-8?B?YXd2Wm5Ha20wSUhab0RjT2s1QUVrNzFQTkFZbE1QdktjaVVQY1pIRHVmWjNE?=
 =?utf-8?B?Uk1YamdUZ2M1MldidDdTZjFaWGJCM3RhY29PSkVYTW1SaU5qbVVrL1ZHdVQw?=
 =?utf-8?B?NEtoUG41UGRmY01FKy9iUFhuWG8ycW9LM0R3SC9vcDA3SS9JMXRsTkdiRm93?=
 =?utf-8?B?QS9YdGhKNUlZTmtCMVBldjVBZWJIbFV6eEcwQit6cUxHV0xxTk9sMnpVb25G?=
 =?utf-8?B?MGdOSkhvZHhYdXU1dENNMXZJb0RUMUN4R3R4aUZxU2JyVEZCazhKMWE5cUps?=
 =?utf-8?Q?VLiLrvRdCibxMIo500FLUo6QC?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <921923210C72574A93D45B899EB3A3A3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c67177b2-bfaf-454b-bbab-08ddf5d2cb15
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2025 10:13:05.5315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gbKNYPedrdDtdqkmEukrryBSjtrinI2ly3rNEUdrBIwgcisPm9CEGpzo+083U/FoOZPqvmap0gDrcCeNgqu4rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF4324011F4
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA5LTE3IGF0IDA5OjAxICswNTMwLCBOaWt1bmogQS4gRGFkaGFuaWEgd3Jv
dGU6DQo+IA0KPiBPbiA5LzE2LzIwMjUgMzo1NyBQTSwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBP
biBNb24sIDIwMjUtMDktMTUgYXQgMDg6NTkgKzAwMDAsIE5pa3VuaiBBIERhZGhhbmlhIHdyb3Rl
Og0KPiA+ID4gTW92ZSB0aGUgUE1MIHBhZ2UgZnJvbSBWTVgtc3BlY2lmaWMgdmNwdV92bXggc3Ry
dWN0dXJlIHRvIHRoZSBjb21tb24NCj4gPiA+IGt2bV92Y3B1X2FyY2ggc3RydWN0dXJlIHRvIHNo
YXJlIGl0IGJldHdlZW4gVk1YIGFuZCBTVk0gaW1wbGVtZW50YXRpb25zLg0KPiA+ID4gDQo+ID4g
PiBVcGRhdGUgYWxsIFZNWCByZWZlcmVuY2VzIGFjY29yZGluZ2x5LCBhbmQgc2ltcGxpZnkgdGhl
DQo+ID4gPiBrdm1fZmx1c2hfcG1sX2J1ZmZlcigpIGludGVyZmFjZSBieSByZW1vdmluZyB0aGUg
cGFnZSBwYXJhbWV0ZXIgc2luY2UgaXQNCj4gPiA+IGNhbiBub3cgYWNjZXNzIHRoZSBwYWdlIGRp
cmVjdGx5IGZyb20gdGhlIHZjcHUgc3RydWN0dXJlLg0KPiA+ID4gDQo+ID4gPiBObyBmdW5jdGlv
bmFsIGNoYW5nZSwgcmVzdHJ1Y3R1cmluZyB0byBwcmVwYXJlIGZvciBTVk0gUE1MIHN1cHBvcnQu
DQo+ID4gPiANCj4gPiA+IFN1Z2dlc3RlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwu
Y29tPg0KPiA+ID4gU2lnbmVkLW9mZi1ieTogTmlrdW5qIEEgRGFkaGFuaWEgPG5pa3VuakBhbWQu
Y29tPg0KPiA+IA0KPiA+IE5pdDogSU1ITyBpdCdzIGFsc28gYmV0dGVyIHRvIGV4cGxhaW4gd2h5
IHdlIG9ubHkgbW92ZWQgdGhlIFBNTCBidWZmZXINCj4gPiBwb2ludGVyIGJ1dCBub3QgdGhlIGNv
ZGUgd2hpY2ggYWxsb2NhdGVzL2ZyZWVzIHRoZSBQTUwgYnVmZmVyOg0KPiA+IA0KPiA+ICAgTW92
ZSB0aGUgUE1MIHBhZ2UgdG8geDg2IGNvbW1vbiBjb2RlIG9ubHkgd2l0aG91dCBtb3ZpbmcgdGhl
IFBNTCBwYWdlIA0KPiA+ICAgYWxsb2NhdGlvbiBjb2RlLCBzaW5jZSBmb3IgQU1EIHRoZSBQTUwg
YnVmZmVyIG11c3QgYmUgYWxsb2NhdGVkIHVzaW5nDQo+ID4gICBzbnBfc2FmZV9hbGxvY19wYWdl
KCkuDQo+IA0KPiBBY2sNCj4gDQoNCkJ0dywganVzdCBhc2tpbmc6IHdoeSBub3QganVzdCBtZXJn
aW5nIHRoaXMgcGF0Y2ggdG8gdGhlIGZpcnN0IHBhdGNoPw0KDQpJIGRvbid0IGhhdmUgc3Ryb25n
IHByZWZlcmVuY2UgYnV0IHNlZW1zIHBhdGNoIDEvMiBhcmUgY29ubmVjdGVkICh0aGV5DQpib3Ro
IG1vdmUgVk1YIHNwZWNpZmljIGNvZGUgdG8geDg2IGNvbW1vbiBmb3Igc2hhcmUpIGFuZCBjb3Vs
ZCBiZSBvbmUuDQo=

