Return-Path: <kvm+bounces-47259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D3317ABF252
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 13:03:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4AA08C3DCF
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 11:02:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E5C125F79C;
	Wed, 21 May 2025 11:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kuka.com header.i=@kuka.com header.b="czm9ePVy"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013039.outbound.protection.outlook.com [52.101.72.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3271A3BD7;
	Wed, 21 May 2025 11:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747825370; cv=fail; b=TS5o/iYr2moh6ClCPDxBfCfdwpuzIAicnad0/4osPjgLgjfFnpShX3qoUqrnU8mckKdMrhf2GYJNl1svwUL0w190sGtC9mXMj5ZEPjwqsjyDFUtbbBEMqs/fIcPalBRZ8q1or7k9wHj7DJngrgleij8oHdJDU01zMbDP+VgTQkQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747825370; c=relaxed/simple;
	bh=Qew2gxsCZr+Ejc+Shkp0TaRSNvYnWXmsIYh/eaXWqv0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fZxaS95FCJj36hLkqFo/aUv94484HcZ7wBjWQQ/NejvZIDOi+1kmMQf3iZGg5aih5Gtj5aUTnE0AuffEluqLj5A1O8+XEyKQiBVZiiurqBbhi6EurWAq36XSymyXFhbM2vrcI5Ix8Soa8H4dgm7fETsbnhAE7G7yePkIu5KXCcM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kuka.com; spf=pass smtp.mailfrom=kuka.com; dkim=pass (2048-bit key) header.d=kuka.com header.i=@kuka.com header.b=czm9ePVy; arc=fail smtp.client-ip=52.101.72.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kuka.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kuka.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ofp5jc9hTaRqRK5lq1dL4Eiz7KOdXIUkcIrftwc6S/mE6eKgHjp30IBdYseQhtNKolRkD3yNB2CV4VibQbIUD9Oovwx+vF1ENSOzf7sBltn5W3V+BploBF7F5po/4GyhoY1mFicHefe4dWIdXjfPy4pHaZVcD3t7HJQN249DqeBiRKAdmhX95+h7z8jqoivHNtpqByN8dfJSJjj78P2bBHPq512llE5YhRpYazNtkze8m3kc8h+3KyF3OArYRt7rtuS0or/wZ1tMF1IdQXZ5nFvdJu71OK3CgbRMp3KgKxI2znnds1roITDtvnuh5ZCZenF0zzaw9SghnFmfMcMCtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qew2gxsCZr+Ejc+Shkp0TaRSNvYnWXmsIYh/eaXWqv0=;
 b=d9/dXC6hEmiFkaLTXME16I3sRAgsbfxDc2GpwuyHB+qtr28P8jBVFLPbKfDhU9ff+ePd4Qm+sFNVnXsProxpRLuPaQU1WvO1ajxQl1yxk9CBoAW2NN4o5plfopOSsohSsdDD97W9TY0fhT+lLRYj8vYSmWsEMqqTJSxNqnjq+3exMt9NFTB44ru+7qNFOGZDgcdHuX81Qi1s4eXyz4Sqso/d0jz0R3EGkd9rtoeLGN3rRdv4P9pBXa1iG2DFZi5mBe2i4FXA3anch3kZzQp60Koe+1OJe2DAgw6+UVC0kHxNZNarb+PVHtmk6Etk5ZQZ5H9JLr0hnrlAuIRlBGrJmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kuka.com; dmarc=pass action=none header.from=kuka.com;
 dkim=pass header.d=kuka.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kuka.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qew2gxsCZr+Ejc+Shkp0TaRSNvYnWXmsIYh/eaXWqv0=;
 b=czm9ePVyVMiO/KDhbMuf62sakRue8MtMHxKghX7lt0xGSm+qaWNM2h3V8AWniKmVYiN7+EQ3etN4p+c/MjjbcmNAKkFSMrtlVizqVfY8BKxg7x5QJURPAq/TsUFNDHDvZUBo87rLvXNonUL5hSgFeo2pS5hWuwdaAbzH/O+GmIt2UQvIigBz3AZRPbx6ugVZkTWKwPpbcJNDKyoFh9w4XADFhj/OFj/rD/hBO0CvPsUdC/BtZn9vOq2owm86MZBnBm1hIVWGkY4+0+V7TKd8VXmG1xLWMVdM/MbRP5yao2/J069wC+KxsjAhonOBXfw3wMNB4zqCKP4nf3HA9BLshQ==
Received: from VE1PR01MB5696.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:123::12) by DU2PR01MB8296.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:2d7::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.31; Wed, 21 May
 2025 11:02:45 +0000
Received: from VE1PR01MB5696.eurprd01.prod.exchangelabs.com
 ([fe80::ac38:4740:6a66:b5ba]) by VE1PR01MB5696.eurprd01.prod.exchangelabs.com
 ([fe80::ac38:4740:6a66:b5ba%5]) with mapi id 15.20.8746.030; Wed, 21 May 2025
 11:02:44 +0000
From: =?utf-7?B?SWduYWNpbyBNb3Jlbm8gR29ueitBT0UtbGV6?=
	<Ignacio.MorenoGonzalez@kuka.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton
	<akpm@linux-foundation.org>
CC: James Houghton <jthoughton@google.com>, Christian Borntraeger
	<borntraeger@linux.ibm.com>, Yang Shi <yang@os.amperecomputing.com>, David
 Hildenbrand <david@redhat.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Matthew Wilcox <willy@infradead.org>, Janosch Frank <frankja@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>, Sven Schnelle
	<svens@linux.ibm.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-s390@vger.kernel.org"
	<linux-s390@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] mm: madvise: make MADV_NOHUGEPAGE a no-op if !THP
Thread-Topic: [PATCH 0/2] mm: madvise: make MADV_NOHUGEPAGE a no-op if !THP
Thread-Index: AQHbxdYwMN4XfMZLVEO3IINdHmTLP7PaDR+AgALkEmM=
Date: Wed, 21 May 2025 11:02:44 +0000
Message-ID:
 <VE1PR01MB5696195C2DE01EA0D4EC5EDEF19EA@VE1PR01MB5696.eurprd01.prod.exchangelabs.com>
References: <cover.1747338438.git.lorenzo.stoakes@oracle.com>
 <bb9d43d6-9a66-46db-95c5-686d3cc89196@lucifer.local>
In-Reply-To: <bb9d43d6-9a66-46db-95c5-686d3cc89196@lucifer.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_1b46921f-d37c-4222-b9ef-5dad63b5080a_Enabled=True;MSIP_Label_1b46921f-d37c-4222-b9ef-5dad63b5080a_SiteId=5a5c4bcf-d285-44af-8f19-ca72d454f6f7;MSIP_Label_1b46921f-d37c-4222-b9ef-5dad63b5080a_SetDate=2025-05-21T10:54:04.060Z;MSIP_Label_1b46921f-d37c-4222-b9ef-5dad63b5080a_Name=Internal;MSIP_Label_1b46921f-d37c-4222-b9ef-5dad63b5080a_ContentBits=0;MSIP_Label_1b46921f-d37c-4222-b9ef-5dad63b5080a_Method=Standard;
undefined: 4195665
drawingcanvaselements: []
composetype: reply
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kuka.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VE1PR01MB5696:EE_|DU2PR01MB8296:EE_
x-ms-office365-filtering-correlation-id: 04ea2ca7-ad52-4bf4-bfc5-08dd985703bb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-7?B?Ky01clgzSVBQWmk0TzNZQ3JNOTVYWHphdnk4WWZKZ216SC9GZ2UySFRRd1o3?=
 =?utf-7?B?L2tQRWtDQS9lSkEvTnhJZVJmMDI5cVpZYk1Fd2htU2t6OWtTekdSbmVUMnZU?=
 =?utf-7?B?V0h1dzl0OWF4S3V2ZlZqblNXYks1Ky1qNnVBR0xKT0pscFdRT290T0lkeXJG?=
 =?utf-7?B?WG91TnhwSmR6UmRsNGpHYlo5WnFXY3dtMThwQistV1lSWlpDWFlmWnowNmRB?=
 =?utf-7?B?V3FFTzJuQ2kveFFwKy0yaXErLW5vNCstdkxGNkQ1cnkyaWI5dHRqY2VOZzlG?=
 =?utf-7?B?Z1pkQ0ZCT3lKb0NJQktvTWdvajhWdk8xZkNkd1JtTistS20wTUFmaUhVZjY3?=
 =?utf-7?B?eU9UazRrODFHZGJBVm9rZjMrLTZ0a29ZWUNnWDJuL21paHFEUGhTanhwWmtY?=
 =?utf-7?B?SlI0cGs1RldXdHVtejdySGhKdWFSOUkyaTExeGlJeFVVKy1WQVNoN3JDcDhq?=
 =?utf-7?B?RVlGc083VnhKaGlSSVdVRS9GLzVwNHBkRUxjL2NxT1didGRjTHNyVUg2V3F0?=
 =?utf-7?B?Z3AxZTJ2bTJJNjdwY2FiUTdrOENYYXRWRTI2dEI5SXFSZlBPMFR3aDY2NmFF?=
 =?utf-7?B?VCstdjJoT2lOZnQ0UWtlSXM5VjdIRWhCdzJJZFIyZW8rLU9iZTA4c1hKS2tx?=
 =?utf-7?B?c0UzQU0yZFhCb0t4ckhkM25pdnVPeEt5dFJvWmJwRXIzUlpxSmtTSGdPVjdl?=
 =?utf-7?B?UE1pZGlUMDYyei9ZWTFmNVdzZUxrTlZjY0dyN1hCTGtwcFRXRCstZjJvNEt1?=
 =?utf-7?B?ZWxMOXBrNllUbWFSY0dKL3dobzN1ajBScWhHTkJNQ2Y0MXZrNmFtVThSaUdB?=
 =?utf-7?B?OVM2eTNHUm82STI3bjY0SFlYcXZZL3M1Z2w2OFQyTG91ZWl1aGZrYlRQTGtO?=
 =?utf-7?B?aU1qby8wbnhYTnNlUXRTQlhZejdoYi9OV1l0dlVEeE1TZ1p4bnhxOE1jYnJt?=
 =?utf-7?B?UWpDalZaQ0FTcGQ0RmFFYnJuak1talJ5ckIyR21nNml5VThKRExJbnRvZzlE?=
 =?utf-7?B?d0lxUDJuLzJ4b0hZOGYrLVJkbXk2QVNTQi9jSzdEb1BrcnFHNUVmQ1VyMWJy?=
 =?utf-7?B?Y3NvNjBYTVRMZzQ1cm9DZ0ZsMXVnNEFDU1hKU0N2ZjgvNkMwSUdQbm5LOUcw?=
 =?utf-7?B?dkpibzhKQmE4S05lcWovMXFBRmROc2grLVR0YkxieXlQblBwTHMybVRFdjI1?=
 =?utf-7?B?S3BqcEdvTFRoTkdHSmR3YXE1TDY0VFFVKy1RaXg3YkdxaEM4ZW1lSEIzQlBl?=
 =?utf-7?B?RERyZ1Q2dTdkczJqcW13OEdmRHowKy1HVUlQMmpVOTFDV1RuQSstWXBQb0hp?=
 =?utf-7?B?a2cvUzlJS3Y2elAzbzFjNmdVcU9pT0RPbnNlNlVjdEZBbXQ5a0FFdW5HYVVv?=
 =?utf-7?B?RWVjZEVlYUpETFFGS0NGU2pRY3pmWGlJWnJ3NzRNQ3Z0eVdFazZxc0I5bEI=?=
 =?utf-7?B?Ky1oSXhYdHRiS1Fhd3p6VVJCYUNKbE5TYU9DUWN2amc5MTFTSnZYaDdvaHJE?=
 =?utf-7?B?MkptOUY4VEU5UFNwbXB2eWFZaDFGRnpuOW10Umh5QVhFa0krLXBhNGF0cFJO?=
 =?utf-7?B?bk9yWERsUjdUVjIvOVhoaG9Xc0JsZDN2UjY0alp1VUxsZHh4UnA4UVE5WFdE?=
 =?utf-7?B?MDFvOXpnUHRiOXMwUEJJcTV0TystQS8vdnU1bFR1TDk2dystWVFxUmgvd1dl?=
 =?utf-7?B?Q2k4NWhuc2Jma21ZT3VyRSstV0NIa1RaYTBuM3VLU2xVd2tTb2ppZ1dLaFo0?=
 =?utf-7?B?bWpYQ3hiL3QzaGZvTWJjQXBMdUVERjNXVWVZM0F6eXllQVNCMlB2MmY5MjRq?=
 =?utf-7?B?TUx5WkN0Y3k5MzJTT2YwWE9TTDN6eW9jTEZTTEk1blYxSEJiQU54LzN5ZlR6?=
 =?utf-7?B?QmpxSkhRVXQvOEpUL21sbnZxTmlYeU92NzFHS2NJUmI1VUZ0ckZJU1FpZ3ht?=
 =?utf-7?B?ZHlUUTVBMUZVZnAwQzdFVll1ZVZHSHQvNnNrQTdPMG1acmU3Slkvd2FRTnRk?=
 =?utf-7?B?Qmk0VjJYYWF6Q2lqUUZXOU94MHVTSWUrLTFQYWlQbzBnK0FEMEFQUS0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR01MB5696.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-7?B?dGNyYWxabUFud3RWbEljbVp0SVg5eHRIbEhyM2xCVm40RkdUSGpuZXVlekUx?=
 =?utf-7?B?SFpYZ2J5RTlvVGdIbTN5RW4zYVE2UjFJUjZWM1RnRTBON2hKRmZpenJqWXpV?=
 =?utf-7?B?bUdkZlZiNTdzYVdjMmxtNystUHRQaUp0d1hEOXl1VXVCU2Ezd25yRXVnODE1?=
 =?utf-7?B?YnNRNFZWMm9tbzZqKy1yYjVTRzNiNUF4UHJ0RTUvRGsrLS9obFFJck9DR3hB?=
 =?utf-7?B?OVFlYXlrS0JsVm5PTEU0WG16akZSUXYyRHRLRlJKbmdRczh0eWJhSENhcVJO?=
 =?utf-7?B?QVJOOW1nTWplYzhuZ1R2a2dWOWxyTFpmWHJTWkEvYUFDVkRuaTlZZU1RTmZL?=
 =?utf-7?B?b24zVkFmT3paQk1CeW1qOGYvVU05dUdTejgvYnJyREMwR3YvVUlvSFV1bmg0?=
 =?utf-7?B?Rmw1WDE3aW12amZjbGRaWVVlSDBQcGRodGRKS3l3S3FMZGpOaUJjWEVvSWxY?=
 =?utf-7?B?M3psUHYxSURGMjZLNjlFY0VzZWFJT1dDVkJUODFkbWY1Ym9zNGQwd1puaUxp?=
 =?utf-7?B?dVZqZDYwKy0wOEpCSmI4a2pMMy9kV09HaEd4dWF4bW95cXZxL2lzRFh3RHFu?=
 =?utf-7?B?ckg1TTBoWFEwbXFjSDlRanVQOUFweUl6TEd0VFJSSnpVRG13Szg2REEzVVlo?=
 =?utf-7?B?UU5NWnc2UVBRUXVTZFlka1pML05uYk83RCstNHZxYnhkM2hMdVBqeUdGU1Zl?=
 =?utf-7?B?MkxIb3hnT21HbThXaWtqR3J0TlRRN3k5YTNCSkFoKy0xNUlVd0VXT3NHaTFO?=
 =?utf-7?B?L1MxQnZaaU5vS0tzWmMzKy1PMGluRjVtZ0NXTXI1b3RqbSstV1hLZ0RlaEph?=
 =?utf-7?B?YzdLbTRvTVpVSWVlM2NQNlBmVklhWURDSXRHWEp2aTFsN2VwWXVDU0dja2o3?=
 =?utf-7?B?TVZzWFNyelUzWnBLdE00OEZsUUgrLUxyUVpYL1M0U2JkUVJpdHJaNFVMTEpI?=
 =?utf-7?B?emdWcHlDdEJGaHduTEpFWUs3OXlQaUpYd3hOTjZqVFd1eTZGODBQaGt3aDg0?=
 =?utf-7?B?cVQvL2FEWWhvbG9WTDZFUG5TWWNRVGRHSCstYjJBOGZGQ1RweXd5VVJLanc=?=
 =?utf-7?B?Ky1EMHQ3VlYyTXlLS25teXZWbystNVhNWnA3WG5RRnU2TGI3U2pQV2JCZXV2?=
 =?utf-7?B?b1BMZmhIVkZheDVjaG04NGZUWnRaRDRTOXBobXkrLWRDWnNkY1hZOExYSTUy?=
 =?utf-7?B?c3JzakkxZ3Uyd3VwZ3JtMmVXbS9rMk9Na0ZoVE42NkRBTEY0SEF5aDIyamRY?=
 =?utf-7?B?ZHhlaURoZ2RIY2hNRnRmd3BPcVBjY3R6RjRFWHBoUEhQTXBseXc3SUdBbEd1?=
 =?utf-7?B?elI1SW4va3NwRktMVjZXMkRyM1BsT2JQMGVGd0hjUistMVFnWDRycTUwMVhB?=
 =?utf-7?B?WFVUMHFtUmpJT1hoMDVsZDE4V2xEdXdDZW02NGorLTBiS0JQclluaWxIR05D?=
 =?utf-7?B?WEJERlFKVy9zaW5ocHB6Wm0yZUMyZ1RBdUowajkrLTcwNXVCN2FBcGRDL3Zn?=
 =?utf-7?B?aWFMWm9JT01tNURReDdVMUdMbGJ2eFE0aS9uMlJvRll5WSstM2htdXI0dVV0?=
 =?utf-7?B?c3BOZURCWjB6QnQ2TDM1ZUdvNXFtTHlmSGt3ckRYV3ZkbGU5MkpCU2FYLzdL?=
 =?utf-7?B?Y2ZVOTNLQnhKMS9ocTRRdGcrLTVzMTV2SDkvT1ovSy9LRWR0UVIrLWRGTSst?=
 =?utf-7?B?T05acHVKZFVBWmNHaktzdGZ3UUpsU2hEZS9pNi9BcCstUlhHTkJOSnJ2NkE0?=
 =?utf-7?B?Qmo5Qm9tck02RDVDWDRuSFhENGJNVU91d25jVFFZZWpwMkkxS21UUkZJbk5X?=
 =?utf-7?B?cFhNei83UGJxbGlZN2FzNVhnTGZCNTVaS0I3Q0I3QkdYVklxeVVjTXdYVGFy?=
 =?utf-7?B?cW9ya1ZRN283YTFLbnRKSGVlc0p2cFVSenlTNzFKYmhYYkVWL3dLQzFBS1Qx?=
 =?utf-7?B?NFlaNWozQWVtSlozSVl4YzZjTERIRmRyNjJ4NDdOcTNrVDRDT0N3cUQzWHVs?=
 =?utf-7?B?VkNJOXFEcS90Wi9pTUhDVTZjbkhhVExPZWFzVysteDVrdUVnejlwdTk3OUh3?=
 =?utf-7?B?RjV5R2drWktPZ2grLWNqRXBIeVArLTlHT2FwU0ZxTmJXWGpiMFY5R2Ezd3FX?=
 =?utf-7?B?eTRRR25IeWh2Y2k4Ky1JZUVoeGorLUxIcU55VTRZNTFuS1BxYnU1aTJHNzNq?=
 =?utf-7?B?MVB1V25zU2dpTGpZYTltVkpJM1VoY0loM1cxSkErQUQwQVBRLQ==?=
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: kuka.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VE1PR01MB5696.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04ea2ca7-ad52-4bf4-bfc5-08dd985703bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2025 11:02:44.8641
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5a5c4bcf-d285-44af-8f19-ca72d454f6f7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C5Vm4Efurf5cV3h7b4rJQzYCGE0NhYa/TB/7W6P1wMvbqOV3AprVE8xect53WkfIGr+1WEXekpQOHnE29dY2Dxn3d5cTfKS8/yhHKC2dR8w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR01MB8296


Internal
From: Lorenzo Stoakes +ADw-lorenzo.stoakes+AEA-oracle.com+AD4-
Sent: Monday, May 19, 2025 16:43

+AD4- I've tried to be especially helpful here to aid Ignacio in his early
+AD4- contributions, but I think it's best now (if you don't mind Igancio) =
for me
+AD4- to figure out a better solution after the merge window.

Sure, that's fine for me. Thanks+ACE-

