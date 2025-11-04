Return-Path: <kvm+bounces-61959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id AD877C305FE
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 10:56:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BAC144E6B0E
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 09:56:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB2CD3148D3;
	Tue,  4 Nov 2025 09:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ExR/zob7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A220281368;
	Tue,  4 Nov 2025 09:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762250150; cv=fail; b=HSv9VSBHivdYLZCDBaISLgJWd7c6WpHqSGT9C77Y5iYW2g9iYe4//jzYWoDR+5+EdOGV7n/tDpPW+dKTMkieN3RB9lIjNgQ7L04QMZ2McRIGa2KLkAlOM2w2a7mr3ngyj8AmHexUv+GJYS/o+xfeJEJE8WOI/b/1nP4bH5plSsQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762250150; c=relaxed/simple;
	bh=lY+69TF7psABS0sHCeS5Q4DbtfPvH42yq4PxJV6CBhI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LSjySs2PmP1JqknhsBfN9bD/pKAvqNhbd8W2dOhxBkozG+S/3ovq7RiuKKNfGmS0jClgEjJvzb0zm13l3aJ0tbfpAa1EP8B7BSJkYDHhbZVrRMpVGuBBkpMxM+G7mTb2vYcQFdC9Njpkc0uoI0QGZTOeKoVdrgOFVBVdH9C5srI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ExR/zob7; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762250149; x=1793786149;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lY+69TF7psABS0sHCeS5Q4DbtfPvH42yq4PxJV6CBhI=;
  b=ExR/zob7qfNrqSnv0nbCLU9CmGjYsjVaUVpa22yS4v/gg8G+PtfNt9aC
   h4NaF1zXDNWp6t9Qhzo4ZN+wdrCUJ1Rc7vyYEXx/kPcUSfD+qwfneawqj
   YhFB0ad0HqyDu3GqXdUM08G2fMy7U94Y9GnvEcLryM8PaYN4s5TgHH+NX
   FYyRMbKlyU95gKPMWbfO5g/G7kNTmX5WugFVQV4YHREkeHavdsXxs9k9Q
   +JCLHPUVvUIaK6Gl1BVFqEz49He/O+vrelwEsGFfTqZe37Zdp9idCnCFj
   rwIA6PEVb87P6rPQTFUZVfWPhqqD6de3exZOCDGv7TIRw/1hfLqO8wygG
   g==;
X-CSE-ConnectionGUID: 4nmAYP1sQgS6FBEfEJxGBw==
X-CSE-MsgGUID: LCyoIpMQRZCFH76RTLiMIw==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="64037205"
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="64037205"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 01:55:49 -0800
X-CSE-ConnectionGUID: Zcw/YzUoT3asJrBo2tArIQ==
X-CSE-MsgGUID: P6Yq2sa5QkC+bwF9JlPY9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="217759774"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 01:55:46 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 4 Nov 2025 01:55:44 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 4 Nov 2025 01:55:44 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.66) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 4 Nov 2025 01:55:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EUYQ5VssygG3vrxNmzpmeqIVcZCH5fgCJZSbDgb0bKMa48MKBswutlxFA7VQgm6l9WS5SIyOSX7f1W8L58k0ybdoBVUmvmec9AEAedW17r6HipCJuF3DbKZFsnt6690GM5C7r2wpbqS/0x44Ffa18IQgsQXPAopTtRXHIg1RkOrVAw03enveyQ++AFumRMORU6jmIUxfSrLD3uW9Yeh1a+d1P90bn/zQe4Btq2GJXfZVnK2ZnWEKr3d2BgwuyfIKC3XP0Of6OcBxV7xCrIm0+CrrqrqLLZBNK3BqlxmnD21mPH3JKtRX5l012ftlghj8S3V709z0FSzIKt7oHooF2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lY+69TF7psABS0sHCeS5Q4DbtfPvH42yq4PxJV6CBhI=;
 b=Wa7G1sX8ZjevFTXm8B+rtf67gp9AJkF0kctOwmjW8htqN5nNmhAKzO5w2cR+tpsufoRTOHBPDI0I9Z2jwRI7DGSI/Mwh9WnBhyFgftApahZpSd9xB9KUtAOJwqcuJAt4E5jw0XwSNZVxaJBrNC9I8NguB30jlUxOMSHr1WwIYlTAq0RReu0qUzih156WJsM9/WVzUJVfRypv3PfH0LAlYMkOB48yVKuEAOZTbBzV+ZvvDyqllcX41LD/UuP4xiOHh7yhFybX0NbddktCwwTJdvWoRkjMGQMkJjGMReTnp/6tK4nUR/Alts88nXHpVY2lQlKvJH9HYnrJ+/90EpBW7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DS0PR11MB8207.namprd11.prod.outlook.com (2603:10b6:8:164::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Tue, 4 Nov
 2025 09:55:36 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9298.006; Tue, 4 Nov 2025
 09:55:36 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "khushit.shah@nutanix.com" <khushit.shah@nutanix.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>, "Kohler,
 Jon" <jon@nutanix.com>, "hpa@zytor.com" <hpa@zytor.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "mingo@redhat.com"
	<mingo@redhat.com>
Subject: Re: [PATCH] KVM: x86: skip userspace IOAPIC EOI exit when Directed
 EOI is enabled
Thread-Topic: [PATCH] KVM: x86: skip userspace IOAPIC EOI exit when Directed
 EOI is enabled
Thread-Index: AQHcKLR2qfH/HOUBJUuLEhaZhzaNXbSfxJ6AgABfW4CAEG1ZAIAhZPWAgAqBMwCAAE6GgIAFyuaA
Date: Tue, 4 Nov 2025 09:55:36 +0000
Message-ID: <cc6de4bfd9fbe0c7ac48b138681670d113d2475e.camel@intel.com>
References: <20250918162529.640943-1-jon@nutanix.com>
	 <aNHE0U3qxEOniXqO@google.com>
	 <7F944F65-4473-440A-9A2C-235C88672E36@nutanix.com>
	 <B116CE75-43FD-41C4-BB3A-9B0A52FFD06B@nutanix.com>
	 <aPvf5Y7qjewSVCom@google.com>
	 <EFA9296F-14F7-4D78-9B7C-1D258FF0A97A@nutanix.com>
	 <aQTxoX4lB_XtZM-w@google.com>
In-Reply-To: <aQTxoX4lB_XtZM-w@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DS0PR11MB8207:EE_
x-ms-office365-filtering-correlation-id: 9d59656f-4924-49c7-4184-08de1b884db4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?Rk9DYVVlRm9WYmlKMmJiVHYwNFd2K3RkdGoxemQrYjJHaDV4TWQ0bDYySkFU?=
 =?utf-8?B?RG95cHVwRTR6QTV5dWFxMGF5bDFPd0FoaWw0TXJncWJWbCtoUEgvMkduWWVK?=
 =?utf-8?B?MWZqVlJhSDN1Z2JUbkhHUmQ5WVZnczdnSGt2QUZOK2JFVzg2UHd3ZXJmM3Fs?=
 =?utf-8?B?NEJjYXJubjhyWlVMTHo5RTI3cjJQTWFFQVl5N2Z1Q2duZGhuek5wVjlvSGhO?=
 =?utf-8?B?Sy9rbytoYXZLSDBvZEx2Q3p4MUZ1S1Z3cFBhNG5xai9sdklKTWRaNEV4cVlV?=
 =?utf-8?B?bm9NSThWZWVpWExTcmtYanFqcE03RzVUZFQwYzdrVWNJQjE4K0txd2JDMm94?=
 =?utf-8?B?VVFUdUNNM0ZBOEM5Qy9jVDlwWWt1dXJDU0VkNW5JNVk1K0lhRk54UlUyN2J4?=
 =?utf-8?B?NituNmRPWDZKeGdaYWxxeUlucno1YzUvUHU5Zm50Z1hsSDhmUnJjTUQvS0d5?=
 =?utf-8?B?QzFENzBTMWVlRCsybDBtZjg0RndvOWNFQWFpVlp0dzBpTk94dlpqQjJLZFZx?=
 =?utf-8?B?aDhlNlBhTU1uNWd4cFp0YS9sR2szb3hVNUJiM2crTDdEancrR2tLelZVN2Zn?=
 =?utf-8?B?TlhLSFQ2TTNBaGZ0NHdsNTB5VVU3TmhxU3JVa2g2ZTBhN1YxOFI4UVhacHdD?=
 =?utf-8?B?ZlFIc3QwTTM0dEJUd3BvYVNzSkNvY25VTUM1VmZhdncxT0hzSXkyM2pkUGwr?=
 =?utf-8?B?Z3IyOXVxcC8wa2N6WE1WQWZzS2VQOFJESXR3R3IxUWgybVBsR1JTRDlKRXpv?=
 =?utf-8?B?SSt5NzVaUUcyTzRwMnhIcWd5cHVWaGZpODN6T2VXRElGbHpXc2c1S3dyYWJh?=
 =?utf-8?B?ZCsveG1wN2RZdDVWWTVJdGhmL2lnMjhCOHpCWEF1MmtYS3FFWCtTVTdCVWJ6?=
 =?utf-8?B?UlJGUWJsNWdwYm5NWWhPSU9YQlNGYmJSU25jcm9ILytldDhMZUVHWUMvTnMx?=
 =?utf-8?B?bWJTNDBxbTViMUVjWEV5d2xwZUlqMUZXVVhqdHVVOFVSUnQ2a0F1K2U5b1pG?=
 =?utf-8?B?a0QzeFRHakQrc1J5SnlyK0p3Q25aa0lSMjhLMWQ2VWx2Y1RCdXE1d2RYVXNw?=
 =?utf-8?B?RCt3V3ZMekRpbDVMZU1WRE10YzUyamNpcWgrWmhQQTVrVG5xdnRwaVRFbjlH?=
 =?utf-8?B?NVJ0NEVONzI2REVjSzNiczVXU0lRbUMwejhsVFpKZy9mbDU5ckppTTl6Wld2?=
 =?utf-8?B?KzRnSXJ0Y1JZa3FFN2pPcUlESFZLSHBUMC92aGdoOVI0NGp3TnUxa0tETmdn?=
 =?utf-8?B?eTVVSkFGTnozRWZtdjJqdnd3RFR3VjFjVHB4ZEk5aWdaTFlSRVUzekcwczlD?=
 =?utf-8?B?MEZ4OFRLeWdlZWZhalNYQm9xS0srYWFXVmFwSk9rSGVPbHhlYmtadS9jTFBn?=
 =?utf-8?B?NDkvbjhFODU2WU9hUnU4eENyQU1td1RsMXY1OHJMcjdLUjVDNTFZOUtxL1Zy?=
 =?utf-8?B?eDBnalRBUjdXWCtnNWVMTTVhL1d4V0g1VWR0N3paSFd4Q3lxRHU1L1FEWUkz?=
 =?utf-8?B?YVpIN1ZiWWgvOEM5RnFaanArMm9qYkRaNlpTdWZYUm5tZUVBcXhMQkkvdFVV?=
 =?utf-8?B?Uzk1UVY0aC9pZktTbWM3RkQzK0FIQURyUFV2bHlXTzFFWGNFTmlWaXhIMHhX?=
 =?utf-8?B?YkRuVzJueE9kOUZZQTVEVzVTbGVoK2toSkF6Y2g1Q0hWTlZLMk80TFE2MXhJ?=
 =?utf-8?B?YU9PM1EycndMQU41WU10TUc3Mzh3Z00vUVJVRVNsMUI0VXExcUpWM3pPcmFr?=
 =?utf-8?B?OUNKU2JieFV1enlrUGs4VlFmQ3RCMVF5VWRjeElhWkgySG1pSVFNTi9oMG8z?=
 =?utf-8?B?OENzcEJOdERBd0V6b3JRN1M3OUMzWVRsa21mM2k1MTdrbHhGOUxWRSt2MDhz?=
 =?utf-8?B?WG9FQmxpWTRCdElkZnJBN1U0RFNXS01uU0FFb3hjZnBZYk1WZWdKUDdzaDZI?=
 =?utf-8?B?WEVsTk1HV3BoMStza0JOUGpoS2FCcHZ4QU83YkYyRXp2VngrS04zWEQ0c0JZ?=
 =?utf-8?B?U0pOMVVnV3NTV2xUbFcrZ2RyN09rN3ZlQlh3QXNpVVBYT3htOE9YTm5QRUJj?=
 =?utf-8?Q?pNXzTz?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QkRqbC9obDZiMkE5alVqUDEyNnloY2huTjJXcDdJSzhubGlxMC84ZnlMTGZm?=
 =?utf-8?B?ZFFLM0ZMak5OSitQWWdhanp6dzlZTkdLSXVkQjAvcnpDemNPOUJ5UGtVZU5N?=
 =?utf-8?B?OU9DT1VoMkUwQmlvS3Q0RFVWNDkvLzBXWkFJRnJhU1RyWG90OFBhc2lKTDZt?=
 =?utf-8?B?MjRpS1dLenI3cEFDVStWdnpReHRkUnNmV1ZYQW0ycFdNV1RMcTRZbWwwMlV4?=
 =?utf-8?B?bnltZXoySWw1dCs4aWlCYUhqVFM5cTRyeTBaU0VXUXd4alV6UU5ScCt0b0J1?=
 =?utf-8?B?OVBpOTlrT3FibTNweWpzR2NIUGQvRVpMZ3Z4RHhtbFp6akNkdmZmclIyUnI5?=
 =?utf-8?B?dEhNeDVQcStRZWZRaUdhVWVNSCtzT2wzWVI5VkpFYnFvRVlRdFVZZTU1Y1Vj?=
 =?utf-8?B?NHhPcWw4Q1ZsOVdhNXZSRkJYblhuNXB1UnlKcURscmJDcDAreC84YXdTazk4?=
 =?utf-8?B?eGYvTTFsU0k2WFZwTm9samJvdWxSSURxVnM2dEZWNlBCc2VjS1FodXNoZlFT?=
 =?utf-8?B?bElFTHQ5c0QwYmNsY0ZGYzFaR2NqOFYrZ2ZGWE95SUg3WWZUTzRIWFRnMmFM?=
 =?utf-8?B?dUluZnlPVCtva0JHTHVDamFpLzNBQk9kRGdvNDZ4YndKajRKeXNTWUgybDh3?=
 =?utf-8?B?WDFqZTBQSVFTdExjUjl0cGhJNTJjZU1RaHUxeVJSNTIzZFkxVTRodEJXc0pt?=
 =?utf-8?B?a3MzMXk0MmhEYmNMb2pDMkM3UU1DVzZuRjVJelJydzZnb3owZVMzQlNTeXNy?=
 =?utf-8?B?M3JSVVBFa29SQUk3RE9pQ05zTXpwM3lPUGtkZ2laaFJ1S0ZhTXhEa2RIQ3V6?=
 =?utf-8?B?ZTVTV3hlNjErYVZWYTZFN3ZmejZvRExubWJmR3JveWcrS0lGd1ZmVTFOT1RC?=
 =?utf-8?B?NmcwOEd3OTNSWDZEZFZkUHZQRWZwR1pZZ05Ma1VlSnlSNytpQVlxQmIyRUYw?=
 =?utf-8?B?R2QwVWdtcWdZRWRva2lHM0I1VDlWSi9HMGRQcHVZSC81UEZDM0ZNaWtaZFhj?=
 =?utf-8?B?SWpSZDArWmZRRmhXNFNMNS9DWVY1SVFRK2gvbFFYR1Y2bU5BUHozYWhmaFk2?=
 =?utf-8?B?SjJLT2l1V3dQTmczbkVvcStnbFdoT0hLb0pvUmpXQ3V2ZXJ6UC93c1RuUDhT?=
 =?utf-8?B?U1N1TU1VaWVpLzNRd2pVL2Y0aXN1eldXbHc5ci9XbGlPeDZmZ1pSaURZbDhC?=
 =?utf-8?B?NnFncjh5SVVCemRqRVhZa0tRMFVmeWZiOVd3Ukt4eVF0TFhTazFxK2hlQnZk?=
 =?utf-8?B?NzNOUkdYVG92Qk9VcklPdmdMemtvc3RDU0tIaXBoemRCVXJpWkprdklRNTA1?=
 =?utf-8?B?bitnOHZvWEFCcnBLcVR0M2c1eDdUQ0RsVjRkbVFqTE9ldzF1eTVTVWxKS3RZ?=
 =?utf-8?B?TUhpcDIvdG9PenphMDIwK2s2L3ZRR0R1MS8vUWw2WVZMV05LT1NDcWRaY3FZ?=
 =?utf-8?B?NzNzSVFXQXFHRGFUYjJua1QwbVg1b1dyK1pCM0N3K2hRRWJBcVZyWHEvWXpw?=
 =?utf-8?B?N2h2TGhacjlxRUVYclFUWXVKcDl0eGFVSXpwNVBxdm1zMzFTcHhkUU41SE9v?=
 =?utf-8?B?NTBCRy94bmFOMklyR2dpcy9UU2RYVGlrQUxWOHliUzgyRGVEK3pZcDhkMUdn?=
 =?utf-8?B?N0tkVm5EZCt2UEp0MkdRRlBHZXBRanhmNFg0a2pBV1VCS0VNZFAxV1Jiang4?=
 =?utf-8?B?RURESWRCV3JjLzJvVVZEOWJkSXBRRkJFQ2k1RG52WkRFaWF5MFRTSDYzMmZO?=
 =?utf-8?B?ZmJDdDlOeE90Y0krUDBjQjFSN0wrVGdlZlIzQ1MrMGtRSjhIVGdVbzFKemRo?=
 =?utf-8?B?c1BxSWRuRmY1VjV4VFNtSFFnbnlmU1ZRYmhjTzhhQ1dRV0hLMkhDSUdwcHY3?=
 =?utf-8?B?c2NWWVBYcnFta2J4dDZjUWg5U0c5eEh3bWZDRUNGeUQ5MCtqWXBlUHJ5eDRx?=
 =?utf-8?B?Z3RrRWxPNDJ5MDFPU0czN0NYQlhVcDBnK2NQeGQ2V2RDeXJ5WDlpRXg0eXJE?=
 =?utf-8?B?bmp1NlB5OHIwb0JpZTRWL1I1MFBhMnZ6UTRrQzh2b1hBeDFEU2tSSzFJcklZ?=
 =?utf-8?B?UmxvVFp5NVhQQnNkZVhCcnpIVmhpSEFINkdKVEFFK2poZzloQ21WWGJ6Unov?=
 =?utf-8?Q?jrnZGDtFgE6lDCkfgsiImF2kT?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9715FDE0667A7A4B95E8911F43488EAB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d59656f-4924-49c7-4184-08de1b884db4
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2025 09:55:36.6092
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YAUnMFtYZKnoeh6fFGyC0xu23aNSakU3cMmRBji1UA11sYj1jDuG0/LZ8hH8QTHrnhCMVel1tFin4fFAxUzThg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8207
X-OriginatorOrg: intel.com

DQpbLi4uXQ0KDQoNCj4gS1ZNJ3MgYm9ndXMgaGFuZGxpbmcgb2YgU3VwcmVzcyBFT0kgQnJvYWQg
aXMgcHJvYmxlbWF0aWMgd2hlbiB0aGUgZ3Vlc3QNCj4gcmVsaWVzIG9uIGludGVycnVwdHMgYmVp
bmcgbWFza2VkIGluIHRoZSBJL08gQVBJQyB1bnRpbCB3ZWxsIGFmdGVyIHRoZQ0KPiBpbml0aWFs
IGxvY2FsIEFQSUMgRU9JLiAgRS5nLiBXaW5kb3dzIHdpdGggQ3JlZGVudGlhbCBHdWFyZCBlbmFi
bGVkDQo+IGhhbmRsZXMgaW50ZXJydXB0cyBpbiB0aGUgZm9sbG93aW5nIG9yZGVyOg0KPiANCj4g
IHRoZSBpbnRlcnJ1cHQgaW4gdGhlIGZvbGxvd2luZyBvcmRlcjoNCg0KVGhpcyBzZW50ZW5jZSBp
cyBicm9rZW4gYW5kIGlzIG5vdCBuZWVkZWQuDQoNCj4gICAxLiBJbnRlcnJ1cHQgZm9yIEwyIGFy
cml2ZXMuDQo+ICAgMi4gTDEgQVBJQyBFT0lzIHRoZSBpbnRlcnJ1cHQuDQo+ICAgMy4gTDEgcmVz
dW1lcyBMMiBhbmQgaW5qZWN0cyB0aGUgaW50ZXJydXB0Lg0KPiAgIDQuIEwyIEVPSXMgYWZ0ZXIg
c2VydmljaW5nLg0KPiAgIDUuIEwxIHBlcmZvcm1zIHRoZSBJL08gQVBJQyBFT0kuDQo+IA0KDQpb
Li4uXQ0KDQo+IEBAIC0xNTE3LDYgKzE1MTgsMTggQEAgc3RhdGljIHZvaWQga3ZtX2lvYXBpY19z
ZW5kX2VvaShzdHJ1Y3Qga3ZtX2xhcGljICphcGljLCBpbnQgdmVjdG9yKQ0KPiAgDQo+ICAJLyog
UmVxdWVzdCBhIEtWTSBleGl0IHRvIGluZm9ybSB0aGUgdXNlcnNwYWNlIElPQVBJQy4gKi8NCj4g
IAlpZiAoaXJxY2hpcF9zcGxpdChhcGljLT52Y3B1LT5rdm0pKSB7DQo+ICsJCS8qDQo+ICsJCSAq
IERvbid0IGV4aXQgdG8gdXNlcnNwYWNlIGlmIHRoZSBndWVzdCBoYXMgZW5hYmxlZCBEaXJlY3Rl
ZA0KPiArCQkgKiBFT0ksIGEuay5hLiBTdXBwcmVzcyBFT0kgQnJvYWRjYXN0cywgaW4gd2hpY2gg
Y2FzZSB0aGUgbG9jYWwNCj4gKwkJICogQVBJQyBkb2Vzbid0IGJyb2FkY2FzdCBFT0lzICh0aGUg
Z3Vlc3QgbXVzdCBFT0kgdGhlIHRhcmdldA0KPiArCQkgKiBJL08gQVBJQyhzKSBkaXJlY3RseSku
ICBJZ25vcmUgdGhlIHN1cHByZXNzaW9uIGlmIHVzZXJzcGFjZQ0KPiArCQkgKiBoYXMgTk9UIGRp
c2FibGVkIEtWTSdzIHF1aXJrIChLVk0gYWR2ZXJ0aXNlZCBzdXBwb3J0IGZvcg0KPiArCQkgKiBT
dXBwcmVzcyBFT0kgQnJvYWRjYXN0cyB3aXRob3V0IGFjdHVhbGx5IHN1cHByZXNzaW5nIEVPSXMp
Lg0KPiArCQkgKi8NCj4gKwkJaWYgKChrdm1fbGFwaWNfZ2V0X3JlZyhhcGljLCBBUElDX1NQSVYp
ICYgQVBJQ19TUElWX0RJUkVDVEVEX0VPSSkgJiYNCj4gKwkJICAgIGFwaWMtPnZjcHUtPmt2bS0+
YXJjaC5kaXNhYmxlX3N1cHByZXNzX2VvaV9icm9hZGNhc3RfcXVpcmspDQo+ICsJCQlyZXR1cm47
DQo+ICsNCg0KSSBmb3VuZCB0aGUgbmFtZSAnZGlzYWJsZV9zdXBwcmVzc19lb2lfYnJvYWRjYXN0
X3F1aWNrJyBpcyBraW5kYSBjb25mdXNpbmcsDQpzaW5jZSBpdCBjYW4gYmUgaW50ZXJwcmV0ZWQg
aW4gdHdvIHdheXM6DQoNCiAtIHRoZSBxdWlyayBpcyAnc3VwcHJlc3NfZW9pX2Jyb2FkY2FzdCcs
IGFuZCB0aGlzIGJvb2xlYW4gaXMgdG8gZGlzYWJsZQ0KICAgdGhpcyBxdWlyay4NCiAtIHRoZSBx
dWlyayBpcyAnZGlzYWJsZV9zdXBwcmVzc19lb2lfYnJvYWRjYXN0Jy4NCg0KQW5kIGluIGVpdGhl
ciBjYXNlLCB0aGUgZmluYWwgbWVhbmluZyBpcyBLVk0gbmVlZHMgdG8gImRpc2FibGUgc3VwcHJl
c3MgRU9JDQpicm9hZGNhc3QiIHdoZW4gdGhhdCBib29sZWFuIGlzIHRydWUsIHdoaWNoIGluIHR1
cm4gbWVhbnMgS1ZNIGFjdHVhbGx5IG5lZWRzDQp0byAiYnJvYWRjYXN0IEVPSSIgSUlVQy4gIEJ1
dCB0aGUgYWJvdmUgY2hlY2sgc2VlbXMgZG9lcyB0aGUgb3Bwb3NpdGUuDQoNClBlcmhhcHMgImln
bm9yZSBzdXBwcmVzcyBFT0kgYnJvYWRjYXN0IiBpbiB5b3VyIHByZXZpb3VzIHZlcnNpb24gaXMg
YmV0dGVyPw0KDQpBbHNvLCBJSVVDIHRoZSBxdWlyayBvbmx5IGFwcGxpZXMgdG8gdXNlcnNwYWNl
IElPQVBJQywgc28gaXMgaXQgYmV0dGVyIHRvDQppbmNsdWRlICJzcGxpdCBJUlFDSElQIiB0byB0
aGUgbmFtZT8gIE90aGVyd2lzZSBwZW9wbGUgbWF5IHRoaW5rIGl0IGFsc28NCmFwcGxpZXMgdG8g
aW4ta2VybmVsIElPQVBJQy4NCg0KQnR3LCBwZXJzb25hbGx5IEkgYWxzbyBmb3VuZCAiZGlyZWN0
ZWQgRU9JIiBpcyBtb3JlIHVuZGVyc3RhbmRhYmxlIHRoYW4NCiJzdXBwcmVzcyBFT0kgYnJvYWRj
YXN0Ii4gIEhvdyBhYm91dCB1c2luZyAiZGlyZWN0ZWQgRU9JIiBpbiB0aGUgY29kZQ0KaW5zdGVh
ZD8gIEUuZy4sDQoNCiBzL2Rpc2FibGVfc3VwcHJlc3NfZW9pX2Jyb2FkY2FzdC9kaXNhYmxlX2Rp
cmVjdGVkX2VvaQ0KIHMvS1ZNX1gyQVBJQ19ESVNBQkxFX1NVUFBSRVNTX0VPSV9CUk9BRENBU1Qv
S1ZNX1gyQVBJQ19ESVNBQkxFX0RJUkVDVEVEX0VPSQ0KCQ0KSXQgaXMgc2hvcnRlciwgYW5kIEtW
TSBpcyBhbHJlYWR5IHVzaW5nIEFQSUNfTFZSX0RJUkVDVEVEX0VPSSBhbnl3YXkuDQo=

