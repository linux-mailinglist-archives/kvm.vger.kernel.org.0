Return-Path: <kvm+bounces-23672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FFE794C9EE
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 07:56:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B4DC1C21C6F
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 05:56:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B947016C86A;
	Fri,  9 Aug 2024 05:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="wHaDAU1Z"
X-Original-To: kvm@vger.kernel.org
Received: from esa14.fujitsucc.c3s2.iphmx.com (esa14.fujitsucc.c3s2.iphmx.com [68.232.156.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569502905;
	Fri,  9 Aug 2024 05:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.156.101
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723182977; cv=fail; b=Zsep9OZQjubOLGs9YR4UVJWG6Gjyj0v0QtvMajbS3YUfMjhLvvQY8g8dxVA5oe1Ibczq2enq8QjwH9u2Fw88ttCZhax4A2hA+tnc0eABhGSjFClwvFldTb9IoVYA23AMWv9NwdS4H7ID8BnSOvcx86s4lU0yHy7nNvplGLOLlZU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723182977; c=relaxed/simple;
	bh=FLSUuiswoaaKCyRVt8q7a99tssXGMx8HkYeeRfHAbUQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qmxdqZqja0GK+UHnZTScglI8cuYRy/rBXECAykoiSmzjiFVSKn4Mu5KxcIFHNpPTnNb82YYBR9h0cVjXKwilZIKSTn3Ney/pR90aKhq2nu0MutL9lwOXqDejyGlH4+WD3OPQPYsh0yECSlry2N+iXY19JZZMHkEQzezZn6akop8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=wHaDAU1Z; arc=fail smtp.client-ip=68.232.156.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1723182976; x=1754718976;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FLSUuiswoaaKCyRVt8q7a99tssXGMx8HkYeeRfHAbUQ=;
  b=wHaDAU1ZPMRjsyTOV4yc5b03DlXDJDfXdo3TAhoO2hJ/Kmnb6McK7pR7
   ct4ZUdjoAHbH7mX9C0rK+kAAgZOzorwzbCqV3ub6WWoRKTgOhGUE+TfM3
   Urh42jMRGf5sphvxcnPwIR7lwUokJs4J6ytZmKEsQ7DpR1bsT7h+X9l7W
   4UFl21AtxqTztxp6uJrBxD8WsBHdEYr+Oa+6lrdTOia8yJB2ybZ5Qgreh
   ByUOdAg0UXlmjZhvEBi4KLa27NKS462WWaYi81HwySsuEaM2jDRsGIWtu
   sPWgU0vThYngCfINgN26dLNpQVY8NrJ586YaTEwkUqr6XOIexOXDz1PC5
   Q==;
X-CSE-ConnectionGUID: hoinAn2vRa27yi0Y6/DOnw==
X-CSE-MsgGUID: /68AGrjNQwS7KKoF4qALjg==
X-IronPort-AV: E=McAfee;i="6700,10204,11158"; a="127259705"
X-IronPort-AV: E=Sophos;i="6.09,275,1716217200"; 
   d="scan'208";a="127259705"
Received: from mail-japaneastazlp17010004.outbound.protection.outlook.com (HELO TY3P286CU002.outbound.protection.outlook.com) ([40.93.73.4])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2024 14:54:57 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wls+p5B6cf/ED+cdx0MntGUwWufZM0N0yQU/WTo1AnAfGNw8B872E3jKHJzuQgine/GflJR0sn2LCoHWGDd2vfIRWGae+m9eiltIW3E1J5xk6YAuwJgqVNBu1AcLNWsYE53rpwcNKbb+37Z5ShR+VCJ+JK7OA7QksrdWfptdWzGiW50Z1wMxb4fb3ukRoBxF+Pc01tAl+GwZwj27B/oPolar5MK9E0o2H18v4KVZ2vyMFfSF0hPjKoXfDUdLUtdFuYzaqhwNLAiY5Fh6a99ISx7YSErwG+4+pRXkfYzjH5Ef8ZvV+z0srToQLJ6U4onkCch5K/bHO9o2sW9LjYid+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WSJy2/TTCYHFqrx1O2lrLUMjfwM5yES7GMl1uV5f9o8=;
 b=aMIh2nlpQfw4Lev5U25b18br6K5Moh4p+KGb+uHqIrEyun4Zuld57nVlKzDkQ5lPwWSESQhgcD0JO2+x5iykSfQeFbsiMgcTwDGre1LUCr0mlVTdwqriHRbHgmai2Mwi4u4O7Tscu+fzu9xRIVxvWsIqU+xC+8vMYtc+YYkvEVX0Oa8YVUsNwzq7l2v2ZBH5TMSRkR8yD3R/TgXdfKWCqyLex+7ellEgFvvT3A4yz0/gLKU0wxU7LTIV+pnmBuwNw//lwp+bUdioleaaFV+wbwnT811JWxH/Z3P46kB7UB/vuVla7wSzDlLjEDUgoqK0G6YYjzIfIdKRBbQYEfJ7cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TY3PR01MB11148.jpnprd01.prod.outlook.com
 (2603:1096:400:3d4::10) by TYCPR01MB9523.jpnprd01.prod.outlook.com
 (2603:1096:400:193::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.26; Fri, 9 Aug
 2024 05:54:53 +0000
Received: from TY3PR01MB11148.jpnprd01.prod.outlook.com
 ([fe80::1c1d:87e4:ae79:4947]) by TY3PR01MB11148.jpnprd01.prod.outlook.com
 ([fe80::1c1d:87e4:ae79:4947%6]) with mapi id 15.20.7849.014; Fri, 9 Aug 2024
 05:54:52 +0000
From: "Tomohiro Misono (Fujitsu)" <misono.tomohiro@fujitsu.com>
To: 'Ankur Arora' <ankur.a.arora@oracle.com>, "linux-pm@vger.kernel.org"
	<linux-pm@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org"
	<will@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "wanpengli@tencent.com" <wanpengli@tencent.com>,
	"vkuznets@redhat.com" <vkuznets@redhat.com>, "rafael@kernel.org"
	<rafael@kernel.org>, "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
	"peterz@infradead.org" <peterz@infradead.org>, "arnd@arndb.de"
	<arnd@arndb.de>, "lenb@kernel.org" <lenb@kernel.org>, "mark.rutland@arm.com"
	<mark.rutland@arm.com>, "harisokn@amazon.com" <harisokn@amazon.com>,
	"mtosatti@redhat.com" <mtosatti@redhat.com>, "sudeep.holla@arm.com"
	<sudeep.holla@arm.com>, "cl@gentwo.org" <cl@gentwo.org>,
	"joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
	"boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
	"konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: RE: [PATCH v6 01/10] cpuidle/poll_state: poll via
 smp_cond_load_relaxed()
Thread-Topic: [PATCH v6 01/10] cpuidle/poll_state: poll via
 smp_cond_load_relaxed()
Thread-Index: AQHa35iPkyjwZ422xECkZAgTny56dbIegMaA
Date: Fri, 9 Aug 2024 05:54:26 +0000
Deferred-Delivery: Fri, 9 Aug 2024 05:54:26 +0000
Message-ID:
 <TY3PR01MB11148449A97A47AF875036994E5BA2@TY3PR01MB11148.jpnprd01.prod.outlook.com>
References: <20240726201332.626395-1-ankur.a.arora@oracle.com>
 <20240726201332.626395-2-ankur.a.arora@oracle.com>
In-Reply-To: <20240726201332.626395-2-ankur.a.arora@oracle.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_ActionId=91d32cef-a2d9-4e7d-9d2c-2d38ca97f0f5;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_ContentBits=0;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Enabled=true;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Method=Privileged;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Name=FUJITSU-PUBLIC?;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_SetDate=2024-08-09T05:50:12Z;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY3PR01MB11148:EE_|TYCPR01MB9523:EE_
x-ms-office365-filtering-correlation-id: 98e25f56-1df7-4075-7381-08dcb837c9de
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|7416014|1800799024|376014|1580799027|38070700018;
x-microsoft-antispam-message-info:
 =?iso-2022-jp?B?OHBFRFplZkxra0F6c05mRWxLUDNGZ2xUTy9lb1FuYzdySTU3T21uN2xI?=
 =?iso-2022-jp?B?U2VodGhaRXB4K1lIRHVya2xDVWw4TlorOXh1clA5NUpSUHVDTlNpY2tT?=
 =?iso-2022-jp?B?VHNROXQzaDd6ZXVUUHFqaXN1a3NVWUdIUTRYaE1Sd29JcXJXZngxeVoz?=
 =?iso-2022-jp?B?NXJVMzNrS1pZLzNBVXRveWpTTjdLRzRxa0hYOUZ5REtxY1ZHdUxsN1dI?=
 =?iso-2022-jp?B?WHpjUHZ6TlR1N0ZaRUxqYUEwU252TnN0VzhQRURzK2hieXZVK05acFh1?=
 =?iso-2022-jp?B?ZlB2dGJNeXBGenFHVW5oODVkS2ZPdlFSRnNqdHlPRnc2aHJTN2Vyd3o2?=
 =?iso-2022-jp?B?NnpNVDhpMGNNNzFXT3RxRzZoanRDVkFrM0ZBZmtPY25HM3QxekFpaXR4?=
 =?iso-2022-jp?B?OW5HZTEwbU9iM2ZYRGVEWFl0ZVB0QWJ5ZDlPSWVlc3N4WHNZbjJOTjVm?=
 =?iso-2022-jp?B?ZWFCYVlMNnZrTGYvb2J3SHNkNk9mWkU5YkhOU1hCR0h0U3FTU2xPZUxS?=
 =?iso-2022-jp?B?NGw3VHY4dThtZTFud0NaTzZsR3VGZG1IZ0Z5K0FVanZVS1RYTHovYW9F?=
 =?iso-2022-jp?B?UGVpbk43N2RaNFM5amtQd3IreHRjY1ErSnF5VlJHc1JMNnkxM2VkTnRu?=
 =?iso-2022-jp?B?bDRtL1J1VnhqaSsrM2I0aStlZk4vQi8yUmdXVDNiUXV6RkpSVC9YMDJC?=
 =?iso-2022-jp?B?Q2d6MXppUDk4ak81NjRIN2VxdU5zaEh5aDRZcm9PTFB1TDlVQ0szZ21k?=
 =?iso-2022-jp?B?QVZqbHBVZHBuRkNCanNja2NiaEtiMmF1T0RSZStWU3FzT2paL0dVbzJR?=
 =?iso-2022-jp?B?dXcvUW04ZG5ZVnpobzJUV0VSS1YvMUowOGg4WkVnRmlEY2taS0swak5K?=
 =?iso-2022-jp?B?L3ZIQVRDV0k1V0hkSjJadXMrcFY4SVlydFd4WVBSMkF1Qkcvb0k3WEFE?=
 =?iso-2022-jp?B?ZXM5elBIZEh2Ri9adUw1cE9SYTZ1eHFIQm85Ynl0bGNQOGp0czhXbkJm?=
 =?iso-2022-jp?B?RXJGYzZaZFpraW5ZcTVQbUxvbTBlZ21hTVpKcThuaFFRc0tTOFdEeTJr?=
 =?iso-2022-jp?B?SWN0NmJ3RXJsWnlxNXZpUVh6S2RFcmFFZStnWGlicUtIVlF1NFl6UkVI?=
 =?iso-2022-jp?B?VWVZTExKL05RRzltVzMvVWlhV29yOHhGOUkwWWd6SUNJUGF5VjhlNXZV?=
 =?iso-2022-jp?B?UGluTzJFS2w2WTZaNC9XV0FFYjdHTllJdDJKbmRWRm1OTEN4Z0hucUR6?=
 =?iso-2022-jp?B?WjBxenppMVFFazkxOXBBbytoS2FTM0tRdzJNcVFlRGdGT1F6QVVDMUwy?=
 =?iso-2022-jp?B?ai9WSkdqaFhib1N4WjEwc1ZoRDMzUHJhQm9UOWxCdnlpeTNjSndrOTBY?=
 =?iso-2022-jp?B?bHIwM1VoWmFoODg0VGlyTjZvb1RLUlpxWW9pZmYvVmJOdEhFVHJHVFVJ?=
 =?iso-2022-jp?B?bW9ETGNKV3dRekFxeW1nNXdJSVhJVVJRWi9UMElXMU9qdFlCWDMvQ3B0?=
 =?iso-2022-jp?B?ZDc3VEdLUmw1b25tZUNSd0pxT2NRc2ZKNmdqeXNMbzZUcS9OWFh3bHQ1?=
 =?iso-2022-jp?B?cDAzV2FIcE8zSTREOFdJNnVUd3NNSXo2QVF3M2xRa1pOS0RqQUd0M0dO?=
 =?iso-2022-jp?B?RHFIWHVUdEVtSXdYTXJmRE0waTR1aW9UZy84ZnJrVkN0Z0kwVjEvMXQw?=
 =?iso-2022-jp?B?ajhkU3NNY01SMVFsNmxZamdLR25kK2V2TDA4TXV3S0ROODhhUmNwMWQ2?=
 =?iso-2022-jp?B?SFZ0Q2RmT0tLSDJ1eEdDVURyL1BmVS9iQ3hUZFNNRGo3OWVRZU1teUZG?=
 =?iso-2022-jp?B?UTB2eGJNY3JIZlRPVGVGN09SZDJGN0xna3BXSTJiZWM2c3pwTDlqMGxh?=
 =?iso-2022-jp?B?Y21GQ1kveGkzYjN1eFVQcmVvSVZ1MUFpVTk5d0tVTithSTZyOFZ3TFJ4?=
 =?iso-2022-jp?B?KzZnWFMwVFhTNitnREFBbllHejZOVDRNS3hFOEhFdkxkRnBTR0NETDJE?=
 =?iso-2022-jp?B?M3hPTG1icXBwa1d4UzNYMzFpaW9pNE5JRGZLRVdjdGY0RVhYNit3OU5t?=
 =?iso-2022-jp?B?STl4MWNTYktKcHhGZkp3U0RhNno4NGc9?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY3PR01MB11148.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(1580799027)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?OW8zWWFVYWlGeDVsbWZRSHF0NlhKMkhGUkkwcnIrRGJ2VXNNd1pmd2R2?=
 =?iso-2022-jp?B?U2ppd0JiSUw3RzByQXVVQ0thcjZHSHBhVUtTQW9IM0I2MlFkNndYdGsv?=
 =?iso-2022-jp?B?WjljWmYvSHNaUFl1czR0SXJ3Q2lpOTRFMzBpREN1ZEFHRzRaMmxPUmVY?=
 =?iso-2022-jp?B?M3dpSjYzNkQzb2FyWUFaSnBRcWVkUU1qZlJ2SU5xMndBNDVhNk9GU3pY?=
 =?iso-2022-jp?B?eWlBTVlsdTFWalVZNTd1RnViTzBhMGc0ZXJvSGQ1VDhZZXZwYmU5eERk?=
 =?iso-2022-jp?B?UFVWM3FIdUpuM0xHa0JYMkwrazdrSHhoR1VkVy9FRHo1VHBRNXo2UTFj?=
 =?iso-2022-jp?B?Z1NyMU1yZDI0aHBaeUNYOXo2bGlnOHpjV1ZxV2FiYWJaRXNpcVAxeEJE?=
 =?iso-2022-jp?B?UEdKYlBaMGMybTcxNU1kZkNOQ05tYlRnS0N5RzdmS0FnTk5HYUJpaTFw?=
 =?iso-2022-jp?B?M3dHT0VFZjNPRzYvSDZXb29meDRRT2tpYmJJaEh0Q3FUVVZXejVsREZI?=
 =?iso-2022-jp?B?NGxFbnpvbzV2d2dYdlk3cjNxeEViMXQ4ZlI2QllFVzNMTjlNdmxMd2wx?=
 =?iso-2022-jp?B?a2p4ejRTZlZQam94L25kb21oTWlXbWRYK3QyZEl4OVVQemI3VnMxQmxs?=
 =?iso-2022-jp?B?eVB1ejF0azNadGdEZCtYWmRHZ2h3VHhocDQraVNhOTVuQWFETjIxL0NV?=
 =?iso-2022-jp?B?aU94V0lEazdrNStFVTQyUXh3eDlraTgvQTFIY1JIOGxqNytUeWQ1cVBn?=
 =?iso-2022-jp?B?aHBGdlBQNDBmQXVBSHRiUXduaDdpdDRFVUNuV3p5azRUaTVRVWtudmNE?=
 =?iso-2022-jp?B?TTY3UFRjZ0I0VWJEY2FkNnNZSUFRTjZWbXlEYTNXKzRVa0NCd0Z2YkFo?=
 =?iso-2022-jp?B?dTBKdXczc1B1eklvOHRxMjc3VjlKY0Z6OVVmaUFpd1dRMGdXSmVMZm1m?=
 =?iso-2022-jp?B?a0pHa1NtSTdxTnRZVUNWQ1BmNjlUL1JGZ1BOM2FjcGRLTnlwTzVsWG0w?=
 =?iso-2022-jp?B?ZWpvSkpDOGtscENwMFlxaWxCUnEwYml5VmpHQ1NjYTcydW1NNndvdjFH?=
 =?iso-2022-jp?B?d2ZVbUVSM1U1ZUVJSXFHZzY2VG8rL0lFT1JGWHlReXRyWEx3bmJ5Qlhi?=
 =?iso-2022-jp?B?YldmWUpZS2R1dEtibzBaaktoM2Z5ck02QUJ5OWZXaFliSW14d3I5VzdW?=
 =?iso-2022-jp?B?T2pEQXdibENpNWkwalMzdWxFU1ZDWktlc3pvY3N0WmNDVWwrZzNDdlhT?=
 =?iso-2022-jp?B?MStJZHBqMjIzak9KMG00NTI4eTJNbkFMNEx6ZzB4Y201OUhQYTVFcVli?=
 =?iso-2022-jp?B?S29YcmY0OE9jVkkvVVA1Yll5MHFqb2puMUZvaFQyai9rV2ZXL3ZjbXow?=
 =?iso-2022-jp?B?SzFueThJVGhzcFFOc2NGN05tTXZETDNBcmx2cGtvOHNwaWk1YnBnMjF5?=
 =?iso-2022-jp?B?Ni80TUpTazBrc3FLenNxZjlYc0FlLzlzL2wxZFB5WEh6ODBDQVRad1hw?=
 =?iso-2022-jp?B?SFdBaU5LMmVrdWZEY0NlQXBNNkh4WCsrbE9sem5ZMTJLcE5MbXdxUlBk?=
 =?iso-2022-jp?B?MXdBTGszcHM2OFZNQ0ZYMjhzM1E0SVBZU2JBQ0gwd3ZMdURYYklmRUx5?=
 =?iso-2022-jp?B?ZDlPRmhCb3M2ckdWRmFOZElQNE1uek5Ddk81eEhZb0xsK3dmMGZGUU5h?=
 =?iso-2022-jp?B?em9OWGFNTU1aL3pQUndsTm5kRlBqVStZODdOVm9aeU44ZEp2dTNGcGRv?=
 =?iso-2022-jp?B?UUQ5ZVlncnltQ0p0TlA5SFlaUEUrTFBBWUpJclBYeWgvQ0dQSmpDaE1i?=
 =?iso-2022-jp?B?aWltV2h3UzF4NjJmSDEwbi9ES3pqVkVGWTljc1ptalpwQmVPaGdsMEUx?=
 =?iso-2022-jp?B?K0RqNjBCYUE1RGdnM0tLaDNFRjA5UEM3THFsbWZnVllDYUNWbUgrQzlC?=
 =?iso-2022-jp?B?d1QzKzd6ZWdFdis0NzM4b3Jpa1ppOTVTSGk4TFVaanVXZjZ4V3BEL2Vh?=
 =?iso-2022-jp?B?eFRhTjlnWTlva1psV0g0RmdXRUJ0OVE1Yk5vYjBoZVA0US9xRnlrRUI2?=
 =?iso-2022-jp?B?V0ZWYWpyay92bnREc3RnelZxM3pJYWgwOUZMVHplSFBNK3ZpM2FXUFNS?=
 =?iso-2022-jp?B?V0w5Z0Yxb3RpdTk5Q25NeVZ5bjJxVG1WcElXWHZta04wbm5lMHpLMkJ6?=
 =?iso-2022-jp?B?ZlRWblJTYUZaVFBJSnpyRDYyV05Ob2FHVWJONUhBa0tEOVd1UXYzbmxN?=
 =?iso-2022-jp?B?TEtpVUNOK3FWd1d4VitCdm92NXQ3elNqOXJ1ZjE1bGM2TlBlMDg1KzM2?=
 =?iso-2022-jp?B?eHlvdjdmK2trMFptWWNpanh5NnV0Kzd0SXc9PQ==?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GLNjRBqVwFO6pVMGqP8r+7BRBin1NyeVJnYgvVbEdrsvpP5gwafx76zZFIezeZjMUNzG5F4wxAxzMnZqsiMXrlkQwYmc96xdqUCT9fSsPGRvs6RoeYfasqvcN4HX3ksYd/jWr2ffoiXydv2pEoU6qaUHG8c9T7wbW01UEvXEX+wAK+0kyCiFIbErK7vhTxRUjt89ODvqmp3h7rrc/JUDQIHWrNmKehfd1ADv2VlDYmbEZwe55lPZoPJtUlx4OXF+8C5q9R3EN2d79dwes4PwPhiTBHppXXcG83mu+YOlu/KVGJCCROH+SJb6bvGPnwfHNTaQ67u8h3zyLL2cOJ2XIuY1FdO3808/TRMtTnRmVu02pyGgED2wO8/DqWghU4kMCiYciyXF/AVKdJjfbOlayd1+FGK93w2AEhEVl89YM0PWsbma10mLzeMu3qjpUycoWRHEQnLXzpsFR6fx9RsFyiHl4jva7D0uxGAvNJuGdkL5nHNodgvKzfY6/qYjbRyucWM87gkDgZKmbURm3T5Xljdco6pUfEF2qsjJvx6Nh5WiylqnsvmI/Pgvs4FBBUo7gqmHc5aOKaiFA3VpEUVVl9rsCXkqpQkypJwh9BzbcGsMnIcC2zmupdIQ2hDCwHDB
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY3PR01MB11148.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98e25f56-1df7-4075-7381-08dcb837c9de
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2024 05:54:52.9031
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RgAN2pshIbA9HEiA0a+f7Zm55gYXf5Uiv6LNXUbNYf+4YmE/KczJ98oIkc+oR7Rsr9+2XccSqAV2qtPUIduYE076XcxiH2til2flvLgThQI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB9523

> Subject: [PATCH v6 01/10] cpuidle/poll_state: poll via smp_cond_load_rela=
xed()
>=20
> From: Mihai Carabas <mihai.carabas@oracle.com>
>=20
> The inner loop in poll_idle() polls up to POLL_IDLE_RELAX_COUNT times,
> checking to see if the thread has the TIF_NEED_RESCHED bit set. The
> loop exits once the condition is met, or if the poll time limit has
> been exceeded.
>=20
> To minimize the number of instructions executed each iteration, the
> time check is done only infrequently (once every POLL_IDLE_RELAX_COUNT
> iterations). In addition, each loop iteration executes cpu_relax()
> which on certain platforms provides a hint to the pipeline that the
> loop is busy-waiting, thus allowing the processor to reduce power
> consumption.
>=20
> However, cpu_relax() is defined optimally only on x86. On arm64, for
> instance, it is implemented as a YIELD which only serves a hint to the
> CPU that it prioritize a different hardware thread if one is available.
> arm64, however, does expose a more optimal polling mechanism via
> smp_cond_load_relaxed() which uses LDXR, WFE to wait until a store
> to a specified region.
>=20
> So restructure the loop, folding both checks in smp_cond_load_relaxed().
> Also, move the time check to the head of the loop allowing it to exit
> straight-away once TIF_NEED_RESCHED is set.
>=20
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
> ---
>  drivers/cpuidle/poll_state.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state.c
> index 9b6d90a72601..532e4ed19e0f 100644
> --- a/drivers/cpuidle/poll_state.c
> +++ b/drivers/cpuidle/poll_state.c
> @@ -21,21 +21,21 @@ static int __cpuidle poll_idle(struct cpuidle_device =
*dev,
>=20
>  	raw_local_irq_enable();
>  	if (!current_set_polling_and_test()) {
> -		unsigned int loop_count =3D 0;
> +		unsigned int loop_count;
>  		u64 limit;
>=20
>  		limit =3D cpuidle_poll_time(drv, dev);
>=20
>  		while (!need_resched()) {
> -			cpu_relax();
> -			if (loop_count++ < POLL_IDLE_RELAX_COUNT)
> -				continue;
> -
>  			loop_count =3D 0;
>  			if (local_clock_noinstr() - time_start > limit) {
>  				dev->poll_time_limit =3D true;
>  				break;
>  			}
> +
> +			smp_cond_load_relaxed(&current_thread_info()->flags,
> +					      VAL & _TIF_NEED_RESCHED ||
> +					      loop_count++ >=3D POLL_IDLE_RELAX_COUNT);
>  		}
>  	}
>  	raw_local_irq_disable();
> --
> 2.43.5

Reviewed-by: Misono Tomohiro <misono.tomohiro@fujitsu.com>

Regards,
Tomohiro

