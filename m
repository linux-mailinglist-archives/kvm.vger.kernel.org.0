Return-Path: <kvm+bounces-20800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C1DED91E0FC
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 15:40:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ECE231C2173A
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 13:40:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DB1015ECCE;
	Mon,  1 Jul 2024 13:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RLtLZwsI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2072.outbound.protection.outlook.com [40.107.212.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380BB1E49B;
	Mon,  1 Jul 2024 13:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719841226; cv=fail; b=OEo5hh0qUUBzrnLG2Z8ijcV/b1AELSEQdqfZHAfAVMQHe3IwTZrJMDq3dHbJtRgACr1huL7kxazTVPnobqjK1X7LN2B3pwvbavGu1x3/l/BnOw7ErgfoFgC+nsG3omNL3sKczVpye+C8t71MpJbz1uHCe1CXf7Jrxqm45Zgozf4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719841226; c=relaxed/simple;
	bh=48/iMQjs2m1+jzLsseb+m37M3aH5TT/cygqI0k4CdTw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uXQQbsGGGVe4ooNBJ6PesL7slkdSGsdD0nw6HaBL0u3a7dvZIxxYkyzzy+z34a7JrfvzI7I2tvrWNbxnI439qwvRbOAdgYiQAG08nX3Fk4oE63Odr21jaI7Ud5pu/uZ5O8WRNEkVs+gMw7gIVQ/2ievEkhOKg9ZZJsG9wxdEOB0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RLtLZwsI; arc=fail smtp.client-ip=40.107.212.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=exIfli7myhr/iYOFWCM+L9mX2WiVApTHmie9wlg37BCiohHqR/Y4i9zLkGXXS2Lvi98Hz7t3Zfgf9oKhBiyLfLS8X7OwlOFE36n7UEPeEOohZg2H3zDEeHpi+xooZ4XuwpvuwDy86IXe+sSZjqTnPQltGS7qX1+sT18lYMEFd0S+VbxZorzi1JioZHXWJ+4dSgRjhfMvEuPKiOQICYogsvLLxO78C7c0Qmc79NUkf4oPlP2YrEEzxQEjmNCZaAELgOEgmLKcI1o+8GBm0qnNZrPadtSatupvyQIKTb7uteB6e8tik3p6tRA7MzJAA5zEdqI36Yf4esKf7l3V/h4sZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=48/iMQjs2m1+jzLsseb+m37M3aH5TT/cygqI0k4CdTw=;
 b=iNqGoxw5Ncy9lT57ZGBWkw4PRsouRipPgID4b7LCuvA9aLfSu79KsPucZOPt6gEzgUuwnYdNom3vbADxIjWcqpKD8nzh7kywynTmD/0i5a96pwKgUnHIAkDja6n4VI5L5Ns2rcNSO5IwIW9AiZFpPTPvZp6OrFS0VladfK/wxGuKskBW78AXAZt/hp8PeaRF4HhmshRiU139CSezIWOkGBdrbNL31ALlEeVKNF+MVFV4kg9Iw4Gv1OMJ8qaXJBDiMxfpwJuywGlwZm5AklVkw0R0sQ7jXHXqjWstbyyFVuGv1mmR6nrR7Qw7Rii1q4IO+CPwCl0o0VxnD6+fOOounw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=48/iMQjs2m1+jzLsseb+m37M3aH5TT/cygqI0k4CdTw=;
 b=RLtLZwsILM/AZUgABsg8+v6pBaVQgRqZW5uqTT++S2KgTqNaaiEOY6uvshp41HwhisLTZ57oTTBK96UKT3vNSHcd6AMrH4iwp2H/vRucRf9oVphQfyWEycCAvGmwlcI8xb3SFAHIn5zy2c5YSgPw87UGq8p/UBVgtD6O/2Rv6qY=
Received: from DS7PR12MB5766.namprd12.prod.outlook.com (2603:10b6:8:75::12) by
 MN0PR12MB6128.namprd12.prod.outlook.com (2603:10b6:208:3c4::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7719.32; Mon, 1 Jul 2024 13:40:19 +0000
Received: from DS7PR12MB5766.namprd12.prod.outlook.com
 ([fe80::7546:1785:7a42:1d49]) by DS7PR12MB5766.namprd12.prod.outlook.com
 ([fe80::7546:1785:7a42:1d49%5]) with mapi id 15.20.7698.038; Mon, 1 Jul 2024
 13:40:19 +0000
From: "Kaplan, David" <David.Kaplan@amd.com>
To: Amit Shah <amit@kernel.org>, Jim Mattson <jmattson@google.com>, Sean
 Christopherson <seanjc@google.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "x86@kernel.org"
	<x86@kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com"
	<mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "Phillips, Kim" <kim.phillips@amd.com>
Subject: RE: [PATCH v2] KVM: SVM: let alternatives handle the cases when RSB
 filling is required
Thread-Topic: [PATCH v2] KVM: SVM: let alternatives handle the cases when RSB
 filling is required
Thread-Index: AQHax5u5lJEGrHbE2EmdK/7obF2N37HdW9OAgAAsXICABFOXAIAAC9gA
Date: Mon, 1 Jul 2024 13:40:19 +0000
Message-ID:
 <DS7PR12MB57665C3E8A7F0AF59E034B3C94D32@DS7PR12MB5766.namprd12.prod.outlook.com>
References: <20240626073719.5246-1-amit@kernel.org>
	 <Zn7gK9KZKxBwgVc_@google.com>
	 <CALMp9eSfZsGTngMSaWbFrdvMoWHyVK_SWf9W1Ps4BFdwAzae_g@mail.gmail.com>
 <52d965101127167388565ed1520e1f06d8492d3b.camel@kernel.org>
In-Reply-To: <52d965101127167388565ed1520e1f06d8492d3b.camel@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_ActionId=d9d3ea8e-8336-4834-9743-0125ab620c9f;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_ContentBits=0;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Enabled=true;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Method=Standard;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Name=AMD
 Internal Distribution
 Only;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SetDate=2024-07-01T13:34:37Z;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS7PR12MB5766:EE_|MN0PR12MB6128:EE_
x-ms-office365-filtering-correlation-id: 9b37f401-3baa-4bf5-43e6-08dc99d35954
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?aTZ6UzVPdXI2cVRnY0liK2tyYU5Zd0JiQktURGY4Z28rWXVDUTdwUXEzR25U?=
 =?utf-8?B?bTNzMXYxZ2dpSEpFZlJHL0VxL09TOEtaaFJqMU83dk5sRkszVlArOTFBL2Vy?=
 =?utf-8?B?TGlUUHA0SVd1aDNTa0dEZzdEdFI5a05XZFhJakNxemFZR09qV09CdEZ0aVAz?=
 =?utf-8?B?cEZLaiswOVhBekIrbFcrOTl2R0I3elY3eWtaODN4ZHVZTWY3ajRVMExmTGdO?=
 =?utf-8?B?c2IvL1IrRDBaTENNejYzNlY4bnRUeEF1azFJU2p4TloyK21aNUdIMDY5Q056?=
 =?utf-8?B?ajM0eFIvLytYM3VQekIwNzlJSFowSFdQV29WaitCS2V6UEhFb1JzQm5QVWRM?=
 =?utf-8?B?Z01Ic00xSzRHYWhuN1BraVZCZ0Jjam1FOFVHQWNTSUdpT3k5UlpiN0pzc2Jj?=
 =?utf-8?B?NlJuVW5TbG5NTU1BKy9tcDN6Qk5IU2l1Wjhta3dkNTJ2QksrUTNqZWxZR1Jn?=
 =?utf-8?B?NW5KdE9wT1hEQ2l1TTkzMy83bndDZGUrNzFiYTRVNTA3OUR4Q1VleDJLRmJB?=
 =?utf-8?B?c3B5VGpzMHY2NmlpRWJQUHpsaUJUNWxQQTBZRHpjWm5aT3JlQks5OGN1VUtE?=
 =?utf-8?B?QzlqbnFpR3ZpbU9IYlVYZXg1aGVoSVdhWUhRNFlUUkZFdFJidDlJRGU0SE1m?=
 =?utf-8?B?NW5KUjhaTDd0YkxzKzdRdUd3SGR2Q09QVjhzQU5tMzNRSmxxcVN3aHlNU3Js?=
 =?utf-8?B?SWFrdDUvK25TV2UyMmNGd213ai83NmxyUU5FY013aFcxQTdwcnYrYXBpeSta?=
 =?utf-8?B?VnQ3a2NHY0dYd3JUaktXMEJ5Q25iNlFTbThSMEk0eFdNWmJVVitGYmpZSEZ3?=
 =?utf-8?B?TVpkeFlVZ1BGLzdUb3gySjhmdGtxZEZDZWcyQm53OTJvUmE4V1lDOWU0Q1RZ?=
 =?utf-8?B?Ty9Yayt2L0wxQXFNeE5ISmZZY0k4T21renFZN1B6NHZpNHR6bXlPUTQ1ckxI?=
 =?utf-8?B?Z05RNkRYZXk0U09mTFB6eUtVQnA0N0dzdVdjcTQ0UmJ4V0J5S0VId0drRDZl?=
 =?utf-8?B?bnVjemZFakltK2dzUEc4ZEJPMUd2bkc3dUVaOVNEYWdsTEJpY3RweTVNTVd3?=
 =?utf-8?B?bDNoSkdmK0I3aW9IMlQ2cS8xS2tqbXQyREVESThIbkUxTXpIV1NOYStiVkVj?=
 =?utf-8?B?Zmxhb3BWd1ZNeVNkb2MrazVHaDRuZW5ENW9PZWdrVndkN2d0RCtsSXYwNDJh?=
 =?utf-8?B?MnE3Y3lPZXZnUXd0RUJubHVQNWVVYlJRNjVZRkxTNVd5bFVMTmtTelJmaHFt?=
 =?utf-8?B?SDFuTGFlWlIyWVRjcTVVQ1NLNm94Y3hLMkJNTlRMTnB4MnpyZ05reUxuS2Ni?=
 =?utf-8?B?UmJkUXVKTGp6eWgvUGl1ZHk1aVRSeWpud3QySHJrcDlvNW41bHRTWmRuSXE0?=
 =?utf-8?B?WWlnN3RjQ29iQXhqL29idFo4NzV4MzFjbnZveitzM0lnamltMSszM2l6OS91?=
 =?utf-8?B?ZXZaSFZ5R2p6UXkrVzVpY29SOU5XL1hIYzQzNWxrSk51V2dTSjdQWGlRN3Ji?=
 =?utf-8?B?QUNnajNFeTltSVZnUzN4b3BpREtsejlVRUgvUWhYd3VqaEtvekwveEp0Tlp2?=
 =?utf-8?B?MjViRjB2T1RZL1p0bnJacmRIdStza2h5T2tIWlkyTXQ2MzkrWUZTSjNLTUkx?=
 =?utf-8?B?eVFQZmM4bW1lelBNSmp3cUlKVFVvYzZFdGFSZ2JXaHRvU2NHOTdUSEdrKytE?=
 =?utf-8?B?MmZITHZod1RWQjVIVHpZSkRjZE8yQjRzNGdOQU5Qa25YR2hFTFE2R0dRblg1?=
 =?utf-8?B?Z2ZSUVFqK3JFVXczSHNYSjEvS0d4dEQ5RElkUnVOZkhaSEd4VloycHphSFow?=
 =?utf-8?Q?iQzT0fJVmAvGhmwN3wui/OCDTqcdKhxoUA+Xk=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB5766.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eWVuM1ZlZmRPdE5GUHFGTVY3aFA4RElqc1ZyajIwb1NLbXJoVmN1WnhjaHFF?=
 =?utf-8?B?VUNhOGhvdDQ3bUhQaTNrdllsWk5YYXlyOVhIWkVHT1hrdWpRWE5obFJMLzFn?=
 =?utf-8?B?SjN3alpEWFFnRTFlTzMzMXM4NXcra0J1UngwU1NoOG9TVjhEYnBJdkEvamw4?=
 =?utf-8?B?WlFDWW0zSllZRlpxVUNFcm5UR0xWcGovL20xeEZDZFR6SmJaS1J5Y0xsYnVn?=
 =?utf-8?B?THRtaDB3MVhubGFSYUpTQXVzL1FIa1dIbnN3dFE1T1d3MDROMXRFZ3RmN0dB?=
 =?utf-8?B?VThNUnhsUytnckFaYjl5OVdQSnlqYlJWbGFqSkRyUDV6VmdCTDFGQkFZVGVP?=
 =?utf-8?B?eGNLK0lrTGN5TThHSVZJWS8vd3B0WjVRb2tGSVlYZCtUQnJhU0VUYytmaVRu?=
 =?utf-8?B?aHQ4am11dWNrOVF3VEhlTHFSZTZLNkVVWlFNYm1iOXByVmJvMG9QQlRKdldT?=
 =?utf-8?B?MzJuOUpEeTIxbXl2NWs3UUN6eUp2ZC9jZXVPekY2Q29BUkp2YytsNzFDTVEr?=
 =?utf-8?B?eEJ0eEg1aE9OZVp6WldjQS9mRldaSTYrcHEyd2szUFZEdWF2d3VDanA5QXRn?=
 =?utf-8?B?NFA3dVRiSVZNVjN3MHdRUk9WV0JEczdlc1dRUVpvY2d6MTdKRlRpbm82U1d3?=
 =?utf-8?B?M0cwdWpNU3N1cXVnOU53Z2haZXJqY3V3cEVzMjFESkJOUmZ3ZXRublNyZnFp?=
 =?utf-8?B?NStVYXFQZVdtSEZtaDBCbjR6V1pjZ3RwMkppNW5vZndCQ2RRYk1SanZmV1FE?=
 =?utf-8?B?L0FhenhDN0lnNjMyeHF3ZFpjZkQzaFBOVzlZQ1A0L2NxTDZVZ3E5eHo2bzFZ?=
 =?utf-8?B?WlU3OUhTWHZ3c0cyUmFCdTQveExlNkF1M1kzeW8xemp4dXdCcis2QmQ2Mk9m?=
 =?utf-8?B?c1U4bXM3b0paVWZZbjdtVzlYWFFsUldSS01uQ0c4YS94T2lkZjR1Y3V6Tk9W?=
 =?utf-8?B?UkRsWGFYRUpTZlAzT1pRbGhnZml6aUhDTG9iZE5VZlF3SHVwazVmdHowYlBp?=
 =?utf-8?B?WjRtOGMyU3dqUnlQdEFESnFBTWM5RHlBVzhsV1lNdDUwTUpDUjdxcUIyQU9U?=
 =?utf-8?B?bFoxQzlpQ3VVdXkrVG5QaE5YeFgwbFZYUW1rellMdDdZSVF5Umx4d25ZbnVQ?=
 =?utf-8?B?NmIwNEJvSTh0Tnk4VVdoNTdTQWZSNG9ZRlNkOXMxWURGZWROdERRZW1MdGdt?=
 =?utf-8?B?WkpvZllmQlBrR3dxT1YrSFh4akVnckhtTlZRMTlqdFgwdHprZmlIZjFzckxu?=
 =?utf-8?B?UlhKd0o1ZVp6cDZiRy8zNXBSWVJRdEx5VHFLaEVHSXZBbXdqOEgzU2FGNE8v?=
 =?utf-8?B?ZEt0d3A0YTNuaU03cGU3RU1mVm9vMHRwdDRzVFo0WGM5VktmcjNvSG01RkhX?=
 =?utf-8?B?Tm5kWVZlK2lVeDlTanRTdm4yVTR0bFVEUzJLUnBOem5sY2ZYU2owZS9YR0Rm?=
 =?utf-8?B?MjlIWFpZOGMvVjMvMVdScTluYnV6ZUhmVnNmUjAvWWlhdHJOeXpoSTRmZS96?=
 =?utf-8?B?Z2o3MkJPS2EwNlEweTd1alJCUDVHc2QyM2d2MlpucTNFRU9pVUh1UE5JQTZm?=
 =?utf-8?B?L0VMOHRWODFLVmtXS0RHMDdhdUpyMG5ISThmdHlUUnZCRDUzUUxrUTNtQUs4?=
 =?utf-8?B?eWFZekhmWi9odlljT0FoNHNDd0t4TDdLcGR5QkJseXFydlZvc09pSG9adUta?=
 =?utf-8?B?cER1OEdGTTYzWndXRzdRNlQ3QmFQSWErclR3akxSOFdMK3A1SXUwTGEraC9y?=
 =?utf-8?B?QmJpTUxIMW1uS3dyS0l1RFU3aHhxS09aeDFrZzhQQ3Z0d0huTDBkcHdoNEU2?=
 =?utf-8?B?MWJEclJibkRKR0NGSXExTzB3c3pDZGxMSXRwYjU1R1pPNVoxOHJsR2xHOXlv?=
 =?utf-8?B?eHNJYU5pVVRFcUlOSGplZk9xRlJzYURXNEkxcWRLVE9NRUt1TWdJN0VVcVor?=
 =?utf-8?B?eWd0ZUxsdS9ZZm5LcDZ1ek96UVp1NitBTE9SNWc1LzVFOU5WR2RvYjNEUTUv?=
 =?utf-8?B?TXphRmtsdFp6MlpRdUJKYlRGS0thYWN4Um9IWlQyT1QxeG9Kd01PbTlEeFM1?=
 =?utf-8?B?KzR1KzA3cGI5UkJxZXRFdlZjVjBGOW41WXhsVHNjSXh5dHlheVUrU0dGUWNv?=
 =?utf-8?Q?1VNY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB5766.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b37f401-3baa-4bf5-43e6-08dc99d35954
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2024 13:40:19.5536
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a9qqV7ynZN4R9R1U5LvJTtPu1lKmQLjvA6pwT9QWiQmtARnu31Ef+Zj9X4NbeEsI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6128

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEFNRCBJbnRlcm5hbCBEaXN0cmlidXRpb24gT25seV0N
Cg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbWl0IFNoYWggPGFtaXRA
a2VybmVsLm9yZz4NCj4gU2VudDogTW9uZGF5LCBKdWx5IDEsIDIwMjQgNzo1MiBBTQ0KPiBUbzog
SmltIE1hdHRzb24gPGptYXR0c29uQGdvb2dsZS5jb20+OyBTZWFuIENocmlzdG9waGVyc29uDQo+
IDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gQ2M6IHBib256aW5pQHJlZGhhdC5jb207IHg4NkBrZXJu
ZWwub3JnOyBrdm1Admdlci5rZXJuZWwub3JnOyBsaW51eC0NCj4ga2VybmVsQHZnZXIua2VybmVs
Lm9yZzsgdGdseEBsaW51dHJvbml4LmRlOyBtaW5nb0ByZWRoYXQuY29tOw0KPiBicEBhbGllbjgu
ZGU7IGRhdmUuaGFuc2VuQGxpbnV4LmludGVsLmNvbTsgaHBhQHp5dG9yLmNvbTsgUGhpbGxpcHMs
IEtpbQ0KPiA8a2ltLnBoaWxsaXBzQGFtZC5jb20+OyBLYXBsYW4sIERhdmlkIDxEYXZpZC5LYXBs
YW5AYW1kLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2Ml0gS1ZNOiBTVk06IGxldCBhbHRl
cm5hdGl2ZXMgaGFuZGxlIHRoZSBjYXNlcyB3aGVuDQo+IFJTQiBmaWxsaW5nIGlzIHJlcXVpcmVk
DQo+DQo+IENhdXRpb246IFRoaXMgbWVzc2FnZSBvcmlnaW5hdGVkIGZyb20gYW4gRXh0ZXJuYWwg
U291cmNlLiBVc2UgcHJvcGVyDQo+IGNhdXRpb24gd2hlbiBvcGVuaW5nIGF0dGFjaG1lbnRzLCBj
bGlja2luZyBsaW5rcywgb3IgcmVzcG9uZGluZy4NCj4NCj4NCj4gT24gRnJpLCAyMDI0LTA2LTI4
IGF0IDExOjQ4IC0wNzAwLCBKaW0gTWF0dHNvbiB3cm90ZToNCj4gPiBPbiBGcmksIEp1biAyOCwg
MjAyNCBhdCA5OjA54oCvQU0gU2VhbiBDaHJpc3RvcGhlcnNvbg0KPiA+IDxzZWFuamNAZ29vZ2xl
LmNvbT4gd3JvdGU6DQo+ID4gPg0KPiA+ID4gT24gV2VkLCBKdW4gMjYsIDIwMjQsIEFtaXQgU2hh
aCB3cm90ZToNCj4gPiA+ID4gLS0tDQo+ID4gPiA+ICBhcmNoL3g4Ni9rdm0vc3ZtL3ZtZW50ZXIu
UyB8IDggKystLS0tLS0NCj4gPiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyks
IDYgZGVsZXRpb25zKC0pDQo+ID4gPiA+DQo+ID4gPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9r
dm0vc3ZtL3ZtZW50ZXIuUw0KPiA+ID4gPiBiL2FyY2gveDg2L2t2bS9zdm0vdm1lbnRlci5TIGlu
ZGV4IGEwYzhlYjM3ZDNlMS4uMmVkODBhZWEzYmIxDQo+ID4gPiA+IDEwMDY0NA0KPiA+ID4gPiAt
LS0gYS9hcmNoL3g4Ni9rdm0vc3ZtL3ZtZW50ZXIuUw0KPiA+ID4gPiArKysgYi9hcmNoL3g4Ni9r
dm0vc3ZtL3ZtZW50ZXIuUw0KPiA+ID4gPiBAQCAtMjA5LDEwICsyMDksOCBAQCBTWU1fRlVOQ19T
VEFSVChfX3N2bV92Y3B1X3J1bikNCj4gPiA+ID4gIDc6ICAgdm1sb2FkICVfQVNNX0FYDQo+ID4g
PiA+ICA4Og0KPiA+ID4gPg0KPiA+ID4gPiAtI2lmZGVmIENPTkZJR19NSVRJR0FUSU9OX1JFVFBP
TElORQ0KPiA+ID4gPiAgICAgICAvKiBJTVBPUlRBTlQ6IFN0dWZmIHRoZSBSU0IgaW1tZWRpYXRl
bHkgYWZ0ZXIgVk0tRXhpdCwNCj4gPiA+ID4gYmVmb3JlIFJFVCEgKi8NCj4gPiA+ID4gLSAgICAg
RklMTF9SRVRVUk5fQlVGRkVSICVfQVNNX0FYLCBSU0JfQ0xFQVJfTE9PUFMsDQo+ID4gPiA+IFg4
Nl9GRUFUVVJFX1JFVFBPTElORQ0KPiA+ID4gPiAtI2VuZGlmDQo+ID4gPiA+ICsgICAgIEZJTExf
UkVUVVJOX0JVRkZFUiAlX0FTTV9BWCwgUlNCX0NMRUFSX0xPT1BTLA0KPiA+ID4gPiBYODZfRkVB
VFVSRV9SU0JfVk1FWElUDQo+ID4gPg0KPiA+ID4gT3V0IG9mIGFuIGFidW5kYW5jZSBvZiBwYXJh
bm9pYSwgc2hvdWxkbid0IHRoaXMgYmU/DQo+ID4gPg0KPiA+ID4gICAgICAgICBGSUxMX1JFVFVS
Tl9CVUZGRVIgJV9BU01fQ1gsIFJTQl9DTEVBUl9MT09QUywNCj4gPiA+IFg4Nl9GRUFUVVJFX1JT
Ql9WTUVYSVQsXA0KPiA+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgWDg2X0ZFQVRVUkVf
UlNCX1ZNRVhJVF9MSVRFDQo+ID4gPg0KPiA+ID4gSG1tLCBidXQgaXQgbG9va3MgbGlrZSB0aGF0
IHdvdWxkIGluY29ycmVjdGx5IHRyaWdnZXIgdGhlICJsaXRlIg0KPiA+ID4gZmxhdm9yIGZvcg0K
PiA+ID4gZmFtaWxpZXMgMHhmIC0gMHgxMi4gIEkgYXNzdW1lIHRob3NlIG9sZCBDUFVzIGFyZW4n
dCBhZmZlY3RlZCBieQ0KPiA+ID4gd2hhdGV2ZXIgb24gZWFydGggRUlCUlNfUEJSU0IgaXMuDQo+
ID4gPg0KPiA+ID4gICAgICAgICAvKiBBTUQgRmFtaWx5IDB4ZiAtIDB4MTIgKi8NCj4gPiA+ICAg
ICAgICAgVlVMTldMX0FNRCgweDBmLCAgICAgICAgTk9fTUVMVERPV04gfCBOT19TU0IgfCBOT19M
MVRGIHwNCj4gPiA+IE5PX01EUyB8IE5PX1NXQVBHUyB8IE5PX0lUTEJfTVVMVElISVQgfCBOT19N
TUlPIHwgTk9fQkhJKSwNCj4gPiA+ICAgICAgICAgVlVMTldMX0FNRCgweDEwLCAgICAgICAgTk9f
TUVMVERPV04gfCBOT19TU0IgfCBOT19MMVRGIHwNCj4gPiA+IE5PX01EUyB8IE5PX1NXQVBHUyB8
IE5PX0lUTEJfTVVMVElISVQgfCBOT19NTUlPIHwgTk9fQkhJKSwNCj4gPiA+ICAgICAgICAgVlVM
TldMX0FNRCgweDExLCAgICAgICAgTk9fTUVMVERPV04gfCBOT19TU0IgfCBOT19MMVRGIHwNCj4g
PiA+IE5PX01EUyB8IE5PX1NXQVBHUyB8IE5PX0lUTEJfTVVMVElISVQgfCBOT19NTUlPIHwgTk9f
QkhJKSwNCj4gPiA+ICAgICAgICAgVlVMTldMX0FNRCgweDEyLCAgICAgICAgTk9fTUVMVERPV04g
fCBOT19TU0IgfCBOT19MMVRGIHwNCj4gPiA+IE5PX01EUyB8IE5PX1NXQVBHUyB8IE5PX0lUTEJf
TVVMVElISVQgfCBOT19NTUlPIHwgTk9fQkhJKSwNCj4gPiA+DQo+ID4gPiAgICAgICAgIC8qIEZB
TUlMWV9BTlkgbXVzdCBiZSBsYXN0LCBvdGhlcndpc2UgMHgwZiAtIDB4MTIgbWF0Y2hlcw0KPiA+
ID4gd29uJ3Qgd29yayAqLw0KPiA+ID4gICAgICAgICBWVUxOV0xfQU1EKFg4Nl9GQU1JTFlfQU5Z
LCAgICAgIE5PX01FTFRET1dOIHwgTk9fTDFURiB8DQo+ID4gPiBOT19NRFMgfCBOT19TV0FQR1Mg
fCBOT19JVExCX01VTFRJSElUIHwgTk9fTU1JTyB8DQo+IE5PX0VJQlJTX1BCUlNCIHwNCj4gPiA+
IE5PX0JISSksDQo+ID4gPiAgICAgICAgIFZVTE5XTF9IWUdPTihYODZfRkFNSUxZX0FOWSwgICAg
Tk9fTUVMVERPV04gfCBOT19MMVRGIHwNCj4gPiA+IE5PX01EUyB8IE5PX1NXQVBHUyB8IE5PX0lU
TEJfTVVMVElISVQgfCBOT19NTUlPIHwNCj4gTk9fRUlCUlNfUEJSU0IgfA0KPiA+ID4gTk9fQkhJ
KSwNCj4gPg0KPiA+IFlvdXIgYXNzdW1wdGlvbiBpcyBjb3JyZWN0LiBBcyBmb3Igd2h5IHRoZSBj
cHVfdnVsbl93aGl0ZWxpc3RbXQ0KPiA+IGRvZXNuJ3Qgc2F5IHNvIGV4cGxpY2l0bHksIHlvdSBu
ZWVkIHRvIHJlYWQgYmV0d2VlbiB0aGUgbGluZXMuLi4NCj4gPg0KPiA+ID4gICAgICAgIC8qDQo+
ID4gPiAgICAgICAgICogQU1EJ3MgQXV0b0lCUlMgaXMgZXF1aXZhbGVudCB0byBJbnRlbCdzIGVJ
QlJTIC0gdXNlIHRoZQ0KPiA+ID4gSW50ZWwgZmVhdHVyZQ0KPiA+ID4gICAgICAgICAqIGZsYWcg
YW5kIHByb3RlY3QgZnJvbSB2ZW5kb3Itc3BlY2lmaWMgYnVncyB2aWEgdGhlDQo+ID4gPiB3aGl0
ZWxpc3QuDQo+ID4gPiAgICAgICAgICoNCj4gPiA+ICAgICAgICAgKiBEb24ndCB1c2UgQXV0b0lC
UlMgd2hlbiBTTlAgaXMgZW5hYmxlZCBiZWNhdXNlIGl0IGRlZ3JhZGVzDQo+ID4gPiBob3N0DQo+
ID4gPiAgICAgICAgICogdXNlcnNwYWNlIGluZGlyZWN0IGJyYW5jaCBwZXJmb3JtYW5jZS4NCj4g
PiA+ICAgICAgICAgKi8NCj4gPiA+ICAgICAgICBpZiAoKHg4Nl9hcmNoX2NhcF9tc3IgJiBBUkNI
X0NBUF9JQlJTX0FMTCkgfHwNCj4gPiA+ICAgICAgICAgICAgKGNwdV9oYXMoYywgWDg2X0ZFQVRV
UkVfQVVUT0lCUlMpICYmDQo+ID4gPiAgICAgICAgICAgICAhY3B1X2ZlYXR1cmVfZW5hYmxlZChY
ODZfRkVBVFVSRV9TRVZfU05QKSkpIHsNCj4gPiA+ICAgICAgICAgICAgICAgIHNldHVwX2ZvcmNl
X2NwdV9jYXAoWDg2X0ZFQVRVUkVfSUJSU19FTkhBTkNFRCk7DQo+ID4gPiAgICAgICAgICAgICAg
ICBpZiAoIWNwdV9tYXRjaGVzKGNwdV92dWxuX3doaXRlbGlzdCwgTk9fRUlCUlNfUEJSU0IpDQo+
ID4gPiAmJg0KPiA+ID4gICAgICAgICAgICAgICAgICAgICEoeDg2X2FyY2hfY2FwX21zciAmIEFS
Q0hfQ0FQX1BCUlNCX05PKSkNCj4gPiA+ICAgICAgICAgICAgICAgICAgICAgICAgc2V0dXBfZm9y
Y2VfY3B1X2J1ZyhYODZfQlVHX0VJQlJTX1BCUlNCKTsNCj4gPiA+ICAgICAgICB9DQo+ID4NCj4g
PiBGYW1pbGllcyAwRkggdGhyb3VnaCAxMkggZG9uJ3QgaGF2ZSBFSUJSUyBvciBBdXRvSUJSUywg
c28gdGhlcmUncyBubw0KPiA+IGNwdV92dWxuX3doaXRlbGlzdFtdIGxvb2t1cC4gSGVuY2UsIG5v
IG5lZWQgdG8gc2V0IHRoZSBOT19FSUJSU19QQlJTQg0KPiA+IGJpdCwgZXZlbiBpZiBpdCBpcyBh
Y2N1cmF0ZS4NCj4NCj4gVGhlIGNvbW1pdCB0aGF0IGFkZHMgdGhlIFJTQl9WTUVYSVRfTElURSBm
ZWF0dXJlIGZsYWcgZG9lcyBkZXNjcmliZSB0aGUNCj4gYnVnIGluIGEgZ29vZCBhbW91bnQgb2Yg
ZGV0YWlsOg0KPg0KPiBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVs
L2dpdC90b3J2YWxkcy9saW51eC5naXQvY29tbWl0Lz9pDQo+IGQ9MmIxMjk5MzIyMDE2NzMxZDU2
ODA3YWE0OTI1NGE1ZWEzMDgwYjZiMw0KPg0KPiBJJ3ZlIG5vdCBzZWVuIGFueSBpbmRpY2F0aW9u
IHRoaXMgaXMgcmVxdWlyZWQgZm9yIEFNRCBDUFVzLg0KPg0KPiBEYXZpZCwgZG8geW91IGFncmVl
IHdlIGRvbid0IG5lZWQgdGhpcz8NCj4NCg0KSXQncyBub3QgcmVxdWlyZWQsIGFzIEFNRCBDUFVz
IGRvbid0IGhhdmUgdGhlIFBCUlNCIGlzc3VlIHdpdGggQXV0b0lCUlMuICBBbHRob3VnaCBJIHRo
aW5rIFNlYW4gd2FzIHRhbGtpbmcgYWJvdXQgYmVpbmcgZXh0cmEgcGFyYW5vaWQNCg0KLS1EYXZp
ZCBLYXBsYW4NCg==

