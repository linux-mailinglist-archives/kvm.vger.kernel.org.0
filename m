Return-Path: <kvm+bounces-19178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E3CA901F6F
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 12:31:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B322128290F
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 10:31:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56D1278C7D;
	Mon, 10 Jun 2024 10:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YmOT8PRY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B528A4CE04;
	Mon, 10 Jun 2024 10:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718015509; cv=fail; b=locFl3iPZcTq4W/Xgy7FckGJe71EEchg7ClVigh8SdQUhF4D5+bZI8a9BMO1tfLFxpJ5+fsd4xYWuteGcNABKM8sZ3ncKD/ha8mzmBCTnkrGOXx4t5QayflVhADD6z4Vfka7J/FOzg5TOL2ePTJ57t4xC4wWik0K5a+U9Nvd6+A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718015509; c=relaxed/simple;
	bh=02t1bPXYIMm8PqArDtf1KAb3rwoYHsabXbj6V8nfTqU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QIh5lzobDQv0NRmp0ibJehSH16y6XHW2Sc04fVs6AUsXmIeD26jbYj3gjZ6oPOqwrTaieOz6g4gY9dbLhb1b48OmXFHExKSK8p2Hf6eK7SqdpSAYeicX07Zkxz4WzVXNnVaXv1QhQsyA9fXCXStegq5lzsINpoLl8UAsKPwHMkg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YmOT8PRY; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718015508; x=1749551508;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=02t1bPXYIMm8PqArDtf1KAb3rwoYHsabXbj6V8nfTqU=;
  b=YmOT8PRYmSuIWBAj41m7HvIknOZOWR27pFIo4C7YBRXRmO4RcLyXdng+
   7JD3M/sOjTcE8TMPwclbf/dGCXhEg0ed3wDCP/sw8g5DnvYBhW02X8biT
   L1d+eT+SAnfl7RO6A89/Vf+0K4e079SZP9rD6cKuW4f+JBAdil1HnU+ZG
   X8M3ekr/FZCgUGkgTb/R/XvREr3mUbuRBKx8+KPvqjNAE9q2NlGsk/xHG
   PDbErRtzyb+ep5VJj0NOdqTD4xg7BRipbrqqkqnkEGa1e+QML4Fz+TsIp
   1SQjjUIixXC8xtheQwBSvEhj+FNP2+jJ47Olx5SM2+18vTOjV7HQ0qNez
   g==;
X-CSE-ConnectionGUID: OttJwpO9Q8miLRwVwOjf8g==
X-CSE-MsgGUID: oR2Xl2OTSjez4cfGt9bS/A==
X-IronPort-AV: E=McAfee;i="6600,9927,11098"; a="26079370"
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="26079370"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 03:31:48 -0700
X-CSE-ConnectionGUID: T7pXTdvMQfW/gjlDkOmbIA==
X-CSE-MsgGUID: iGdaRjTMS3CxNUvJjDZg/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="43597084"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Jun 2024 03:31:47 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 10 Jun 2024 03:31:46 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 10 Jun 2024 03:31:46 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 10 Jun 2024 03:31:46 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 10 Jun 2024 03:31:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JKkdFpnff4LWES9GpDkcQO1jZXjBPwCLMITcftXL458onB4J7jXTujVuSfthnJ/ZH2wF5eo4WaWj9mHTHVaBaApaqdS+abo3wpJOjHSUDPaG9eOEhqmz7LGI1szFRCyEaNYYumg4S9GchuOr7C2VeYwFz0LRIyxvHAU+gBqq5HFmbZunn7tx4qV1FavQpqpI/vwayFEE+SPRn8uNpn/EXNZrFC/lPM5L1dJS7RCK8FfmZZ7SsTVh+nWJTAULbw/FaqT6ryGlbRUtpL+jyCTvOdX+KvD4RS4EuRtdLSXI4ZTlsMPdEvqkbFojP3xDLtEwxxL1ZnxYzgOCsyn+R7kxVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=02t1bPXYIMm8PqArDtf1KAb3rwoYHsabXbj6V8nfTqU=;
 b=OiPHUMxCRdeXhwKMLFK6lqLS4wFa8YZFh+vAs6J34YMNJAm5WPv/Q8c9/br/lRGo+ImY3xIy5r/tmJos7VkqKj7vBGpu9mt9Ppw5hipMsBYm0wUCEPXpaRxYU4zpfAljayyj1GQqIpdHOP5B53TlS32ODlZRhaHBDy/I1CHzhrXXkG+dAPvruKqQwoO19w0q5449eEcDRnT677hRbtCmWmhEQqwSvNyLPGISxJorVf/HmLOqI7kTJ7nKTMkXNsQ29a2eGUmsBk0OY/fhhBKIfEzukr0oekmWGMF1cfj84mtzRPI+gXuR6anOYfZSNM+PNBJGjLM/OUWcrmZFCSmMUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB5248.namprd11.prod.outlook.com (2603:10b6:5:38b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Mon, 10 Jun
 2024 10:31:44 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7633.036; Mon, 10 Jun 2024
 10:31:44 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "luto@kernel.org" <luto@kernel.org>, "seanjc@google.com"
	<seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "bp@alien8.de" <bp@alien8.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Kang, Shan" <shan.kang@intel.com>,
	"jmattson@google.com" <jmattson@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Liu, Zhao1" <zhao1.liu@intel.com>, "Li,
 Xin3" <xin3.li@intel.com>
Subject: Re: [PATCH v8 01/10] x86/cpu: KVM: Add common defines for
 architectural memory types (PAT, MTRRs, etc.)
Thread-Topic: [PATCH v8 01/10] x86/cpu: KVM: Add common defines for
 architectural memory types (PAT, MTRRs, etc.)
Thread-Index: AQHat57V2vbv3m2B80+1c3fEI53CTbHA04cA
Date: Mon, 10 Jun 2024 10:31:44 +0000
Message-ID: <ce213573a9f0832c0946ea4bd5595de2b4ce73af.camel@intel.com>
References: <20240605231918.2915961-1-seanjc@google.com>
	 <20240605231918.2915961-2-seanjc@google.com>
In-Reply-To: <20240605231918.2915961-2-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB5248:EE_
x-ms-office365-filtering-correlation-id: 74087b36-e28f-4ade-57e9-08dc8938865b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|366007|7416005|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?cUwrbExmdjQyVTJXandldUU4RjMyODBtRC9sam81YXdHU1VGdldaVDBzaGpp?=
 =?utf-8?B?UFBISGJRMmNDKzA5Z0ZIUzZyMkJ4dE9RSGZxeEh6NmZaYXQzcUZaZGswbis3?=
 =?utf-8?B?aENNT2tTK2JJbjB1U05qVysva1h2c1VUa3luLzlUNDU2M1BhT3NFbVZPZFg4?=
 =?utf-8?B?V3M2Z25JVzA0ekQyNXNkNVV0emhqYjYxYzJyV3F5c3YxbVB4NWJ2VTQyZmYv?=
 =?utf-8?B?RlNJUjhzSEZpWGU3cERtT1dwblgrSjFyNTV5ZXAzZnpBNU5aaWhrVXZKQWxk?=
 =?utf-8?B?eVRQb0FIT3VTUG5Vd3NBMWt4QURTZGRYNGk4cmVYc0ZIdFBVMkhHMDk3djBz?=
 =?utf-8?B?TEdudnZBVjlYdFdac0RlRCs3bXE1UXFZVmpWNWZ1bnN1TkQvTlBsWnZkeWZ0?=
 =?utf-8?B?SmtwZThhcHA3dmQwUUlNM0VEdTV2d0ZIWlpLdXdwVTFQUlVUZS9vL3R5VmFH?=
 =?utf-8?B?RUVJRGhEenRmUUpuWmNtRFZGMHhKaTV1d2g2bisxdjY3YzdwNytqRWdNZzhV?=
 =?utf-8?B?L0I3UWpmQ2gzelBhVGd2dU0wS2dJYVNIR25UOEtqS1lISDdmT2d4c2xpY3pr?=
 =?utf-8?B?R3hZUlViMk5aSEhkZm02bUlHMHMvVy9PS3QycVVoSmY5UDk1QitvemdBMmEz?=
 =?utf-8?B?M2FyYWNEbVJFREJzM3dTb05JUVFVRkxLMUV1MWV6ZjlPN0RlQWZiKzBxZHo2?=
 =?utf-8?B?WTU1bHZxSm9TZjRKd3ZuNE5neW1nd3RjZllLMGY3V215SzZiWTBXeFlQY1ly?=
 =?utf-8?B?UXdFcG1IbkdRclgrWDhXTlQ2YmpvVjlGVkFaeTYxSGE0M1NDWTBKeGQya2F6?=
 =?utf-8?B?S1FnMXZ2a1BIUE44d1crbDNpVXFiV29qZy9WSzBHRDVJd2NNWnZTc3BQcFBU?=
 =?utf-8?B?ZHpXYVJ1eXUycGdiMWwrZ0tqVDR6bERGNGFXY2R4UHp5bEd3S1FEVzBkQU5w?=
 =?utf-8?B?ZkFLcnc5M3BWRzZuQlhZbDk5bXdoSWZ2SnJvOEVMWVZML2hXMm9scTNQT0tJ?=
 =?utf-8?B?WVBCcnhRZjMvUXVqVS8zUzB5RjllMWNFeG5mWkFYVVRwQzFOTXlEdFpaY29X?=
 =?utf-8?B?bzcwMGJWczhpb0xoTXIzc3lhY3NiQkpvSHZYVkxDNFAyaElLYmJDaVptd29s?=
 =?utf-8?B?blliUExJUEpSWjNDUWJSWHF0djN1NVNrOUpQcHNWRzFNOHJRaUNMeXZhZHY1?=
 =?utf-8?B?MkhJR25DTXVyRU1jd0NtaDdSU1NpeUlHcDErcE9XRGNydmtRcWFoQjJSNEFU?=
 =?utf-8?B?dUh5NTU5aVJ6WkZVZzYzaFdzQUc5eGVzYVc1S1JNc2ZiTlRSNWJkQ1FlaHVw?=
 =?utf-8?B?WEZkRXczdyt3QWJkNTlPNzYveXN2R1Aya0diUTFXTHZlbnpEOGFmVEVBRVcx?=
 =?utf-8?B?T0xrcUt1RmtkT1pEa1RRcXdWZG56dTlzeWY0b3ErcGN5VXcySitZSjM2TE9L?=
 =?utf-8?B?SHJqazZTS3pobGQ1MHdmNldtTm56V2hBS0FYWjc0VW9jcHBMTGNyQTU0UjZV?=
 =?utf-8?B?eFphRmVJcjJ6U1ZsU2hJWVBZU2FEemtpWlVJaXEzWXhFMHdyOTAyMEQzRHdU?=
 =?utf-8?B?TWVNR0JnQ3NlQlJrZFVHN2tFbTFTcS9udWJCQmVSZjc2L29KSGRta0VDRUdy?=
 =?utf-8?B?OVIzUkY4bmFmU09QYmFEQ0NBb0tuQU9jQ3lFVnk4TmZxSU1ETTJZajB0U00r?=
 =?utf-8?B?SWlhck1FM0VjNU5HbjJGYjNwNEUvMEFFZEFteDRlcEgrTDE0bHNOaDlRckNM?=
 =?utf-8?B?Zld2MGtqbTZxTFUzdWhub01sSVByQnQ4VTJ0WjBPYUFQNHNBY1hEV0EwUEda?=
 =?utf-8?Q?tSoMT1Xj2O2I5VQNRdPIagaWxr1Y+Lf/V+C/8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(7416005)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RUwzYnY2cTRKc2o5cGYxczdOVVI0ZTFzNDNTcWxZV0g2QmxCemRObEhzek1D?=
 =?utf-8?B?UFhLS21wOXhzSUdNcnp2KzRYbG5IUzRDYlVKWG4zS29QMFhpMW5tRnNUVFZ5?=
 =?utf-8?B?RUxiVnl5V01GQ25hRU9Sdm1PS29iK2prM1BaUmx1SWxFNWovWDlUS0k2VGFt?=
 =?utf-8?B?SkdveUp1MHBCQWFmS21Od3F6WDZTKzMrR0wxcTZneFEwcmNwalJTWUp3UVVt?=
 =?utf-8?B?ODB0RkY2SFZ4a0NVTlBVeHN4UnIyUW1KWUlIR2hUQVdmMU9zdGNMWGt5RnBo?=
 =?utf-8?B?QkxzclRnTVBPN09zL3ljRDBSM01Dckh1bzlSeUh4V1VYQXR0TlAwcFF5U282?=
 =?utf-8?B?dm1GR2g5VUZpSmdtdmZ2azV0RjlnT1NleWRYQXBWWUVKSW4vRjRWQ2xsdURL?=
 =?utf-8?B?M0FYcFduektTMEpQZHJ2d05BSFZDd3pjb0xkS2k3NGhMWnc5OFJXcHJDYmlr?=
 =?utf-8?B?czJOV1djSnJDRW9jUy92K283bmdrbG9ORGY1QlhwK0dBbHg2WkgwaGxHeDhS?=
 =?utf-8?B?cndhZXpGQlcwRGszcDB5cEJMQ2JIK1N4Y0piUWlUS3kzSHpnbXJPUzVzdFhr?=
 =?utf-8?B?VTl1elhSSi9uemp1MVg0Znc4TThqakh0RDJPQmNjMzhCMHk4bHQrNXAvMEJM?=
 =?utf-8?B?QmdCb2xMZFEvN3JrOFhaZlQyU3h4L0QzT01RMlcvdk1kSWlTRUNxUWl3NzNz?=
 =?utf-8?B?T205OHY4c0lya25XTmwxVTNMMmxtb1NwdVRtVkFIWkZYc3RYSU5VYkZJV2R1?=
 =?utf-8?B?dEI2Q2dSdTVTR05hVlhyb3lESFNmQ3FocGx2SlRZZE41a3lITjVoS1ZJQTBL?=
 =?utf-8?B?L2xwVENiZThlS1ZtM3ZXbU0xSCthdEpZUURTbk9wcWx1L1ArWkNTa1NpYUxI?=
 =?utf-8?B?Nk1DaHlrUVpFLzFFMDM5bW54eDRNQWNwaExkNW5JVDhoYVozSHdhdGFLdHFC?=
 =?utf-8?B?dk1vY3FiSi9Pa1pucG50d0FuZGNXQkI5a0paWHJsN2NGbkhaZzduL2dhVE00?=
 =?utf-8?B?VmNjN2owNkxLTFUxMjFCSjlDeFVuTzRCSUhrcUUvU0JDUUZNcy9SUkxuVThz?=
 =?utf-8?B?WHhrVCs4WjBCT2pNUXdyVmVWZVhSeFNzZ3A2a2tzdldoTnRZQTZXYmVmbWUy?=
 =?utf-8?B?MGlrcDFOTFRwajhXbU5jNXFTR1NMazliOEN6ZFErUVJ4Q0h6V0JDbTJ3YUo4?=
 =?utf-8?B?SUh4TnEwRWhTM1lzSnBWYXR2VlUwR1RybmZ5S0dleTQ4dThBamNCd3kzMFhZ?=
 =?utf-8?B?K0hjdnd0enZlUUhleXozSDVObmU3OGpBdnpnWlQ4dDhpYVlzUFFhMHNpSVZz?=
 =?utf-8?B?QytpQ1ZoaWFGQUJBV3h0UnFmT0hMY0N6c3BMMGhaS1g0Skx2ZVN6QzJEVStD?=
 =?utf-8?B?NXdQaDh2R29TbXdSVmoyVzBobXhVckd4NU1obW1PVnc0UldVVlpqeGlkbHFJ?=
 =?utf-8?B?Njg1RXc0bE5mU2ZoNCtHanlNaS90a1ZQczNhdVhVSVRxNi9Tay9IMm9IN3NV?=
 =?utf-8?B?T3dFUjRSN3ZsMENaeTJmankyUURFMDdEMzNXSElDcUplYlVPU0FQQTlPcXE5?=
 =?utf-8?B?dVRGSmVaNVlBcUZQTVU4bFk0L1FVTS9KUXRNKzU0NU5hVy9rb2d6N2xOMTBC?=
 =?utf-8?B?Tzd4WXI2b0NjOXJpUUZVRnl6ZmhSTnNhZ1g0SGMyUk1UdUgrcnA5OUtrZ0xX?=
 =?utf-8?B?MzdHaEY5blZVdlhDOUt6TXZ0ZWxlcXVPZExhK3Q2UHBhdG1JVE05VS83VUVq?=
 =?utf-8?B?K1NjMURpM2NDT3hwNFBHc1dWYkIyemxxZ3EyQ3MxL0ZsUnBpSHE2ZC81MlVo?=
 =?utf-8?B?M3pLVkd6SktxM2FLNlAvRUhiUlJJY0N5SHZrTVZLVEhBd3pPYnVSdDVKREdq?=
 =?utf-8?B?WTVGK0o1bG5EVFZvZlQraVkvTTFzY3ZNVWRTR0ZLNk9GZTIxTDNlc3p1SDJz?=
 =?utf-8?B?MU1JZWhmbzA3SlRkQWdQNFk3cmtDRXl5UmRNU2s4THdwbThnSHVJbVRFRzMz?=
 =?utf-8?B?YkhmczROcUtDeVU1MmxoZmlueDE1aE1SN09yOUdOQnQ0TndEd3dyQVVNdEdL?=
 =?utf-8?B?R1V6Y0dVaUUyUXNMRElaUXZqU3RnMWdtRmdzWUJsK3VoWm9UODh0V25xYUFR?=
 =?utf-8?Q?+8PCG1w2j34xvKuY+fel/ZE94?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F0CF75FEE5647E4D8E074EDCEC52CBB8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74087b36-e28f-4ade-57e9-08dc8938865b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2024 10:31:44.4585
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G8xYth6m63JIBGEQpzMsUQNvXML7GciFJTsy37C5nGsSkVaan6qVRSV7fS/vXHxZXTvGYh+KOXVtZS5t+7YqDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5248
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA2LTA1IGF0IDE2OjE5IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBBZGQgZGVmaW5lcyBmb3IgdGhlIGFyY2hpdGVjdHVyYWwgbWVtb3J5IHR5cGVzIHRo
YXQgY2FuIGJlIHNob3ZlZCBpbnRvDQo+IHZhcmlvdXMgTVNScyBhbmQgcmVnaXN0ZXJzLCBlLmcu
IE1UUlJzLCBQQVQsIFZNWCBjYXBhYmlsaXRpZXMgTVNScywgRVBUUHMsDQo+IGV0Yy4gIFdoaWxl
IG1vc3QgTVNScy9yZWdpc3RlcnMgc3VwcG9ydCBvbmx5IGEgc3Vic2V0IG9mIGFsbCBtZW1vcnkg
dHlwZXMsDQo+IHRoZSB2YWx1ZXMgdGhlbXNlbHZlcyBhcmUgYXJjaGl0ZWN0dXJhbCBhbmQgaWRl
bnRpY2FsIGFjcm9zcyBhbGwgdXNlcnMuDQo+IA0KPiBMZWF2ZSB0aGUgZ29vZnkgTVRSUl9UWVBF
XyogZGVmaW5pdGlvbnMgYXMtaXMgc2luY2UgdGhleSBhcmUgaW4gYSB1YXBpDQo+IGhlYWRlciwg
YnV0IGFkZCBjb21waWxlLXRpbWUgYXNzZXJ0aW9ucyB0byBjb25uZWN0IHRoZSBkb3RzIChhbmQg
c2FuaXR5DQo+IGNoZWNrIHRoYXQgdGhlIG1zci1pbmRleC5oIHZhbHVlcyBkaWRuJ3QgZ2V0IGZh
dC1maW5nZXJlZCkuDQo+IA0KPiBLZWVwIHRoZSBWTVhfRVBUUF9NVF8qIGRlZmluZXMgc28gdGhh
dCBpdCdzIHNsaWdodGx5IG1vcmUgb2J2aW91cyB0aGF0IHRoZQ0KPiBFUFRQIGhvbGRzIGEgc2lu
Z2xlIG1lbW9yeSB0eXBlIGluIDMgb2YgaXRzIDY0IGJpdHM7IHRob3NlIGJpdHMganVzdA0KPiBo
YXBwZW4gdG8gYmUgMjowLCBpLmUuIGRvbid0IG5lZWQgdG8gYmUgc2hpZnRlZC4NCj4gDQo+IE9w
cG9ydHVuaXN0aWNhbGx5IHVzZSBYODZfTUVNVFlQRV9XQiBpbnN0ZWFkIG9mIGFuIG9wZW4gY29k
ZWQgJzYnIGluDQo+IHNldHVwX3ZtY3NfY29uZmlnKCkuDQo+IA0KPiBObyBmdW5jdGlvbmFsIGNo
YW5nZSBpbnRlbmRlZC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24g
PHNlYW5qY0Bnb29nbGUuY29tPg0KPiANCg0KSWYgaXQgaGVscHMsDQoNCkFja2VkLWJ5OiBLYWkg
SHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQo=

