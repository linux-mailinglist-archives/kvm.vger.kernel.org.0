Return-Path: <kvm+bounces-11059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7792A87267E
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 19:25:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 049FD1F27EFB
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 18:25:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87268199BC;
	Tue,  5 Mar 2024 18:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="JVYZvRgU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D5918EA2
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 18:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709663118; cv=fail; b=etQXlSVmuXFlYGdKt7QWNTfsuG74fhwEfJ0nH/7gaFS8/C3XyVLpJltba20BYE4z4uadMwnymR4I0r2sf8Ygpm0QP7NOdt4KWTpo02x7FfJU9gcWoNKhuJSEO+x1C9ahjzDmqml3mNx4uLbEUgtnBsdTUhV23XgmF26xB3aC8R8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709663118; c=relaxed/simple;
	bh=0nj8J04BNav7jn7Npk08ShKZSBKB/fZ18R6dcimM4EE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=a/H0/zVOObxSvjAastfysRvE9lcaE6OZdSKlxN8oVs7QFikC/isM5Jbwnr0YqGdstSU2UWYROCPrVE2Nk1P0Nhf6RQQCPHNrBi2ycB9hraey32CQmn9XeNpyLNtGHP1mLyoUVfz3YHOPLZSzOOkwsRGlqXkGlZrrtG+BIxwsFhU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=JVYZvRgU; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 425EkXiY021830
	for <kvm@vger.kernel.org>; Tue, 5 Mar 2024 10:25:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-id :
 content-type : content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=0nj8J04BNav7jn7Npk08ShKZSBKB/fZ18R6dcimM4EE=;
 b=JVYZvRgUuoM1WBR3cT4pSlrajaBLx0H2Dj1AvCdOVS5OHd5qx1ks8+ybgSXTqzGA0b1H
 sPe/S/t7j6UjZ7CcI9pg0inhWDY9OBelQQTSjFiUmVQCnMXjB8vkktC4IPdvQcGkZ4yJ
 PQsf5Irj3gEF9ODgWqNn0qbA25OO2DYlz3ZfiWhQ3w4NEDpOGyJT6JSoezVi1T1dXN5F
 gE5TNUe01veARo+Noj1QOMIL8AhPDQD/FBc8sl03Z2NyZ1hyI5vfe0h6Wmr8b2P16fFE
 zwITYSsrcH54mVa34BBd1/JxtlLoSnBwqEowwVatriipXB04UHlw4cpaRCq2VfP0hqT6 zw== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3wp39qajy4-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 10:25:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QlxglXxep+emAVSbNeHPmJg18bWhIzWiAZeGgGTAW6Tad4EKaC3ctgSrb4QujqLsTwDrYx5sh12/tNLV1QbZOUSeiVzjGNxbw4X/okL1eZ9pgMEHmNnE2nGhVzg2nMUCAvG2SC4wwS0GsGix6da+sbWYcGhy0eShJaYsuz3o3QN6t4Jf0KBpviPukwOk5guoal0yarXPMX2fou8sGI4u5kMDcFIHP2ScIRVlMPOtd5YZ4MLGjY7ZZasGLIf+IE4Ub+EF/FR528DTu8GlNBI19YNzVM715Dsu7nsIr7F+B19TBtpu5n68MFUgPSmwoTYEDj5hN8mQtaD3HnKr7rGxiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HCPdFxQIb1W91vkghbLI5l9FKwX6HFy0TgwMdMOQP84=;
 b=IESXm09LEVOJpKRq70LburjfAFmFlS3wXjyHxFCoNd/eu81n16JsE6DDpLxObd9ppBAODslzMXddh5x1YXe/tOHTEaxIWtdv97rsFNdzoYbfmyNIQZ5335WFVzhAQkTlxJXPVrRrAgyCn4bgelnLvzjFX5c+soejJhL9KVnH8DOEjGZp2pXZ7ODEwGygOt3t28I/p0Fvt2FDjfCuID3SCScEVTZM7XDoCojfmBMJ5gtNhMzvF0j5f+Ejn3XgmgUn1VfHCQitx+qp34Gph4Fx6/iB8Jj8FaYsVBHwOnPw34REZk578vf4ybLM+cnzfB37mlkv6o/Ola2hd8eggVhiTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from LV2PR15MB5381.namprd15.prod.outlook.com (2603:10b6:408:17b::19)
 by PH0PR15MB5141.namprd15.prod.outlook.com (2603:10b6:510:14a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.39; Tue, 5 Mar
 2024 18:25:12 +0000
Received: from LV2PR15MB5381.namprd15.prod.outlook.com
 ([fe80::37d6:5fd8:7aab:f754]) by LV2PR15MB5381.namprd15.prod.outlook.com
 ([fe80::37d6:5fd8:7aab:f754%5]) with mapi id 15.20.7339.035; Tue, 5 Mar 2024
 18:25:12 +0000
From: Xu Liu <liuxu@meta.com>
To: Jim Mattson <jmattson@google.com>
CC: Xu Liu <liuxu@meta.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Alex
 Williamson <alex.williamson@redhat.com>,
        "qemu-devel@nongnu.org"
	<qemu-devel@nongnu.org>,
        "qemu-discuss@nongnu.org" <qemu-discuss@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: Why does the vmovdqu works for passthrough device but crashes for
 emulated device with "illegal operand" error (in x86_64 QEMU, -accel = kvm) ?
Thread-Topic: Why does the vmovdqu works for passthrough device but crashes
 for emulated device with "illegal operand" error (in x86_64 QEMU, -accel =
 kvm) ?
Thread-Index: AQHabo04wRtF8dyeXkm8NyRZGDdmMbEoZg2AgAASFQCAAP+jAA==
Date: Tue, 5 Mar 2024 18:25:12 +0000
Message-ID: <BD108C42-0382-4B17-B601-434A4BD038E7@fb.com>
References: <39E9DB13-5FA3-4D1A-A573-7D58BA83B35C@fb.com>
 <20240304145932.4e685a38.alex.williamson@redhat.com>
 <51e57a7c-c8a1-4a18-a08b-d2c8fd5b35b3@redhat.com>
 <383DC340-967F-454A-B298-C59B3F70B63C@fb.com>
 <CALMp9eRwTEMUy+u-03U8Y20ez5_nyD=XA6Hs=OJYN2Pe80ms9A@mail.gmail.com>
In-Reply-To: 
 <CALMp9eRwTEMUy+u-03U8Y20ez5_nyD=XA6Hs=OJYN2Pe80ms9A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR15MB5381:EE_|PH0PR15MB5141:EE_
x-ms-office365-filtering-correlation-id: 4e1f902f-16d8-43c5-b490-08dc3d4198fa
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 0egaB2GQrCFlvogX8Wq6vZCpILfEWaRF09OBhj/uqbjV6BiI0lgrxKy9lAYWDogYRiuWht4JE+rYpMjGZ3iBOmB7Hl07n6Ft7ruQTNp+ByJ9aYaykOBeKTX7L23B7Q8sZtALeu36pTvbmTOJjL5+HQN0sBcuFzAH1EUw623MAtT9eCj2VsUwmWEz5/kxSg3cDfd7ZLjNllwhQQTy6ICwSJdgyYeoGm2pGM5iLE9NxD+LT772YQpRkLUbkzz3K9f+iH3NZ5Vw2oFQBh7M5r4HAateS/nGvxk4/rtlFanywlc10bwEvxire5ESdEuphm7RaR5FI/GAC9k7td8Z3eRlVQejZWEpAKDkLwH5sCZgZqvEPfU962g356nFEjFPTMF4oyAbX8NsKS1uGYfsU4mjqAEvmNgPpahNTPGdQJP2zXQaN0xKr+AtmvCwMl0j+q9vidot0WWXXAOpiAVlmVaSuw8b8tO1KrxXzYiGBeGJ5KwFYlJJJuAzB/LUGzMFas3Mq/cyzCpEo9IHp3QQ9fR4YCNc+4hIDzotriHu3dLijJjmHuvT+uMJEQM/A1MFuXkc+MZx1ths7HxPW3eb/0TCmn+sTMO+2UX+KUqRmM66+DMtLa7MmLPc7PrjbpZXVwdu8tokASLnK559UfwcLn3QJdkaAScntQIhVxNbxEe0A20=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR15MB5381.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?UXZEQS9COEpjeUMzUU1aWWF1NUQrUDdnWCtLbldpSmhZaVNlUzJjQ3oxbkhB?=
 =?utf-8?B?SU5FSmVVK0JwVG1jWTBFYkpRQ04xcEVWRVVNaVZBMnZIRmlCczRRY2V4V2s1?=
 =?utf-8?B?bTA5RVBqT3l0S1R6S0xlTzNQVEpOYVVSVFg1LzUrQXVhWGdGVllmUWtHVEJ6?=
 =?utf-8?B?OHYrWllYdCtCQWs1cFBZWW1LbXEyVmk4emlVWmtBeE5UOEhjUUFoQkxuMmhz?=
 =?utf-8?B?RmY1ZmdVMUsrTUZxUWcwZG1YTW0wQUR5S0J3c1cyV1NJbVJMclR2SXBGYm5r?=
 =?utf-8?B?a1RLM0o4Snp3dmh5SFFKd0pMZTlsZkFQRW1Menc4c2lOTlU2YmxGOEhTYkJY?=
 =?utf-8?B?d3lOc0tOVEYzdHRCbnVhcFBkYzlndnlSTUdpYzRCcTVkRFF4WEx3Qi9DVWxx?=
 =?utf-8?B?NkpFZ0t0OHllZlhVdEJNU1FNKzVEenRZR3ZMTEg3WmNzRjdlZDRNbS8zeGI4?=
 =?utf-8?B?QlRSc0VpL1pGTXBwV01BNSs0dzIzU0krODBZbkdVcyt1U0pzM3pRK3NYaWVt?=
 =?utf-8?B?YVBTbDRCcURXRlFGOVk5WVVZZENrelBUcEJVa2VZT3p0LzZZVkJxUFVRcG85?=
 =?utf-8?B?Z1IzZWo5bTU3cU5CQXdxeUtXazluRFdZSmJBckFuRHBNYjVnNEk4T0l1bndN?=
 =?utf-8?B?Vy9xTzg5SzRuc3dCZnB5RHIvQSs2VU1HOUt3WnpxTEc1cEdURUQ5Vis3Z3VZ?=
 =?utf-8?B?bWVJV3JGTlJFQ0tReElBYXNxb3ZqWXNScjA3em40V25GWUdrUXdlc2dSL0Z0?=
 =?utf-8?B?QlNPL1ZVNUNQUFhZVU5FMXJxU2xxazBXRUUrNjJjQXlaN0FaMW0xUytsOFVG?=
 =?utf-8?B?ZCtWRlBpRW1nRDhvaVd0L0kwcjNIcTF0Nit6WWg0ejIzUTlsRXN1dUN4WXRC?=
 =?utf-8?B?UGFKdXV0NTcxd3BvR1E3M3RxTUFYai9qUzRHRWFnYzdvYnBSQWljUGUzV1RK?=
 =?utf-8?B?WjZYNi9qcHdNaTlxU2cyMXg4YTVSRXZ5MWRDRmtFRGlTZWJxS2tLQzYzWVJk?=
 =?utf-8?B?cFJXNGxEVGhHNmRReUk4RkxMK2JVTk1tQ1dJSVNWYmVQMFQ4SmtHZlBjOVp1?=
 =?utf-8?B?a004REFJMnp6TTlKUXZTUFNXS29acGRsbHdaNllycDVjdXpTbGgyd3RzQXRo?=
 =?utf-8?B?OXNLZHhNR3NhR0FleWdtb0taaVlaVzk4bzZrWHNiWWpFRnF0UWRzSWNKeFFI?=
 =?utf-8?B?ZVBVS0tSRFhra01JVDVQTEV5cjdIZytYL0RsMmVHMWZRN2tLc1hnaXRZaGpH?=
 =?utf-8?B?alVWVEFTU05PK2pCU2VDdjFjNC9DejFCWk5zUEt3UlJBblhnZ2JYbVcyODVX?=
 =?utf-8?B?Yk0xTm9sZDA5c0FNdHRJSHZEUFRWd3JEMHdLeVpXY3NSblcrZFNBV3NYeDVu?=
 =?utf-8?B?QUNuRWQxS1dHZWh4UWZQdDBZK3ZGOWdvTXN5RTFJSXl3akdQdTk2dVN5UVp2?=
 =?utf-8?B?Q3BML09uL0xMWFB2K1dmb2FpR2xFVFNNWlNKbnRYYVJXSmYvOFdFa1NvaU1r?=
 =?utf-8?B?ZWdxSzc3REtXbzc1WG5Xa1hPYUwwNXVOa3NudkJ5M21NMmFxVXJMaE1teThv?=
 =?utf-8?B?WHBFT1kwVjV4dGFyMGFrbGdQZFNZaUNhWkc3M2ZLQS83VUdhQm1jR2R0bjFE?=
 =?utf-8?B?VXQ5aVNIbDlTZzl5UUhMdEg0MGpxVDNhMXJGNDZmYnk4QmtEZHVkODdTZlFp?=
 =?utf-8?B?UUVkSVEzNVQ4eGVvQVRUTHRYcXJaT3Z1UW5RTzEvSmI0S1lPdTNjbHRJenFJ?=
 =?utf-8?B?K2x0b0hrTmExZFk4dTJETEIvUlJSTDZ6cjQ4Z2Z2RCtkZlcyam1VL3BjZ1E0?=
 =?utf-8?B?M1krL3lYaWRjTFZvM09Jd1hsUkNCK3Y0OFZOanVuelJCMlBEa2hQZnZnNk1I?=
 =?utf-8?B?ZlFZZWVzc1R1RHpDT2xCc2hPTVNIZmRYMDloU1RMNVMrMUQzQ200NDRLY1pW?=
 =?utf-8?B?cFlpb1dxYVJMOXluYmIxTWtCY3J2VFBQOUxXalBhMHdWRkIzNzJXTnVZY0Rw?=
 =?utf-8?B?WVAwcThyenlHK3NLN1ZTMHhxMjZXSzNhTGFQL0JWSnJNeGNxcVlqazRwUGNF?=
 =?utf-8?B?NXJORXhLdWJnNFBVZVh3WFduZmlZajRuKzBKYkt3UWFXN1ZaZ3Y0Y3NHUlRT?=
 =?utf-8?B?U3JFRWNlekQvKzJyOTY4Yzd0WWUzcXJ2UlNxK1ZuSjRobXNqS0NoOFp4L0lq?=
 =?utf-8?B?Wnc9PQ==?=
Content-ID: <35E4A5CB4417E84E87BEA2CF940C7B9B@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR15MB5381.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e1f902f-16d8-43c5-b490-08dc3d4198fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2024 18:25:12.8415
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AQdQ03k3wOzZH+GTlVPCbURazEEY7GOFyZttFwgnOtGVVfxe4PmKJXPTDDxnw/4t
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB5141
X-Proofpoint-GUID: ZyWzOBk8wP0GAql9GEUoQ48ky9HKaBnP
X-Proofpoint-ORIG-GUID: ZyWzOBk8wP0GAql9GEUoQ48ky9HKaBnP
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Proofpoint-UnRewURL: 2 URL's were un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-05_15,2024-03-05_01,2023-05-22_02

VGhhbmtzIEppbSENCg0KPiBPbiBNYXIgNCwgMjAyNCwgYXQgMTA6MTDigK9QTSwgSmltIE1hdHRz
b24gPGptYXR0c29uQGdvb2dsZS5jb20+IHdyb3RlOg0KPiANCj4gIS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS18DQo+ICBU
aGlzIE1lc3NhZ2UgSXMgRnJvbSBhbiBFeHRlcm5hbCBTZW5kZXINCj4gDQo+IHwtLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
IQ0KPiANCj4gT24gTW9uLCBNYXIgNCwgMjAyNCBhdCA2OjEx4oCvUE0gWHUgTGl1IDxsaXV4dUBt
ZXRhLmNvbT4gd3JvdGU6DQo+PiANCj4+IEhleSBBbGV4IGFuZCBQYW9sbywNCj4+IA0KPj4gSSBz
YXcgdGhlcmUgaXMgc29tZSBjb2RlIHJlbGF0ZWQgdG8gQVZYICBodHRwczovL2VsaXhpci5ib290
bGluLmNvbS9saW51eC9sYXRlc3Qvc291cmNlL2FyY2gveDg2L2t2bS9lbXVsYXRlLmMjTDY2OCAN
Cj4+IA0KPj4gRG9lcyB0aGF0IG1lYW4gaW4gc29tZSBzcGVjaWFsIGNhc2VzLCBrdm0gc3VwcG9y
dHMgQVZYIGluc3RydWN0aW9ucyA/DQo+PiBJIGRpZG7igJl0IHJlYWxseSBrbm93IHRoZSBiaWcg
cGljdHVyZSwgc28ganVzdCBndWVzcyB3aGF0IGl0IGlzIGRvaW5nIC4NCj4gDQo+IFRoZSBBdngg
Yml0IHdhcyBhZGRlZCBpbiBjb21taXQgMWMxMWIzNzY2OWE1ICgiS1ZNOiB4ODYgZW11bGF0b3I6
IGFkZA0KPiBzdXBwb3J0IGZvciB2ZWN0b3IgYWxpZ25tZW50IikuIEl0IGlzIG5vdCB1c2VkLg0K
PiANCj4+IFRoYW5rcywNCj4+IFh1DQo+PiANCj4+PiBPbiBNYXIgNCwgMjAyNCwgYXQgNjozOeKA
r1BNLCBQYW9sbyBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPiB3cm90ZToNCj4+PiANCj4+
PiAhLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLXwNCj4+PiBUaGlzIE1lc3NhZ2UgSXMgRnJvbSBhbiBFeHRlcm5hbCBTZW5k
ZXINCj4+PiANCj4+PiB8LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSENCj4+PiANCj4+PiBPbiAzLzQvMjQgMjI6NTksIEFs
ZXggV2lsbGlhbXNvbiB3cm90ZToNCj4+Pj4gU2luY2UgeW91J3JlIG5vdCBzZWVpbmcgYSBLVk1f
RVhJVF9NTUlPIEknZCBndWVzcyB0aGlzIGlzIG1vcmUgb2YgYSBLVk0NCj4+Pj4gaXNzdWUgdGhh
biBRRU1VIChDYyBrdm0gbGlzdCkuICBQb3NzaWJseSBLVk0gZG9lc24ndCBlbXVsYXRlIHZtb3Zk
cXUNCj4+Pj4gcmVsYXRpdmUgdG8gYW4gTU1JTyBhY2Nlc3MsIGJ1dCBob25lc3RseSBJJ20gbm90
IHBvc2l0aXZlIHRoYXQgQVZYDQo+Pj4+IGluc3RydWN0aW9ucyBhcmUgbWVhbnQgdG8gd29yayBv
biBNTUlPIHNwYWNlLiAgSSdsbCBsZXQgeDg2IEtWTSBleHBlcnRzDQo+Pj4+IG1vcmUgZmFtaWxp
YXIgd2l0aCBzcGVjaWZpYyBvcGNvZGUgc2VtYW50aWNzIHdlaWdoIGluIG9uIHRoYXQuDQo+Pj4g
DQo+Pj4gSW5kZWVkLCBLVk0ncyBpbnN0cnVjdGlvbiBlbXVsYXRvciBzdXBwb3J0cyBzb21lIFNT
RSBNT1YgaW5zdHJ1Y3Rpb25zIGJ1dCBub3QgdGhlIGNvcnJlc3BvbmRpbmcgQVZYIGluc3RydWN0
aW9ucy4NCj4+PiANCj4+PiBWZWN0b3IgaW5zdHJ1Y3Rpb25zIGhvd2V2ZXIgZG8gd29yayBvbiBN
TUlPIHNwYWNlLCBhbmQgdGhleSBhcmUgdXNlZCBvY2Nhc2lvbmFsbHkgZXNwZWNpYWxseSBpbiBj
b21iaW5hdGlvbiB3aXRoIHdyaXRlLWNvbWJpbmluZyBtZW1vcnkuICBTU0Ugc3VwcG9ydCB3YXMg
YWRkZWQgdG8gS1ZNIGJlY2F1c2Ugc29tZSBvcGVyYXRpbmcgc3lzdGVtcyB1c2VkIFNTRSBpbnN0
cnVjdGlvbnMgdG8gcmVhZCBhbmQgd3JpdGUgdG8gVlJBTS4gIEhvd2V2ZXIsIHNvIGZhciB3ZSd2
ZSBuZXZlciByZWNlaXZlZCBhbnkgcmVwb3J0cyBvZiBPU2VzIHVzaW5nIEFWWCBpbnN0cnVjdGlv
bnMgb24gZGV2aWNlcyB0aGF0IFFFTVUgY2FuIGVtdWxhdGUgKGFzIG9wcG9zZWQgdG8sIGZvciBl
eGFtcGxlLCBHUFUgVlJBTSB0aGF0IGlzIHBhc3NlZCB0aHJvdWdoKS4NCj4+PiANCj4+PiBUaGFu
a3MsDQo+Pj4gDQo+Pj4gUGFvbG8NCj4+PiANCj4+Pj4gSXMgeW91ciAicHJvZ3JhbSIganVzdCBk
b2luZyBhIG1lbWNweSgpIHdpdGggYW4gbW1hcCgpIG9mIHRoZSBQQ0kgQkFSDQo+Pj4+IGFjcXVp
cmVkIHRocm91Z2ggcGNpLXN5c2ZzIG9yIGEgdXNlcnNwYWNlIHZmaW8tcGNpIGRyaXZlciB3aXRo
aW4gdGhlDQo+Pj4+IGd1ZXN0Pw0KPj4+PiBJbiBRRU1VIDRhMmUyNDJiYmIzMCAoIm1lbW9yeTog
RG9uJ3QgdXNlIG1lbWNweSBmb3IgcmFtX2RldmljZQ0KPj4+PiByZWdpb25zIikgd2UgcmVzb2x2
ZWQgYW4gaXNzdWVbMV0gd2hlcmUgUUVNVSBpdHNlbGYgd2FzIGRvaW5nIGEgbWVtY3B5KCkNCj4+
Pj4gdG8gYXNzaWduZWQgZGV2aWNlIE1NSU8gc3BhY2UgcmVzdWx0aW5nIGluIGJyZWFraW5nIGZ1
bmN0aW9uYWxpdHkgb2YNCj4+Pj4gdGhlIGRldmljZS4gIElJUkMgbWVtY3B5KCkgd2FzIHVzaW5n
IGFuIFNTRSBpbnN0cnVjdGlvbiB0aGF0IGRpZG4ndA0KPj4+PiBmYXVsdCwgYnV0IGRpZG4ndCB3
b3JrIGNvcnJlY3RseSByZWxhdGl2ZSB0byBNTUlPIHNwYWNlIGVpdGhlci4NCj4+Pj4gU28gSSBh
bHNvIHdvdWxkbid0IHJ1bGUgb3V0IHRoYXQgdGhlIHByb2dyYW0gaXNuJ3QgaW5oZXJlbnRseQ0K
Pj4+PiBtaXNiZWhhdmluZyBieSB1c2luZyBtZW1jcHkoKSBhbmQgdGhlcmVieSBpZ25vcmluZyB0
aGUgbmF0dXJlIG9mIHRoZQ0KPj4+PiBkZXZpY2UgTU1JTyBhY2Nlc3Mgc2VtYW50aWNzLiAgVGhh
bmtzLA0KPj4+PiBBbGV4DQo+Pj4+IFsxXWh0dHBzOi8vYnVncy5sYXVuY2hwYWQubmV0L3FlbXUv
K2J1Zy8xMzg0ODkyDQo+Pj4gDQo+PiANCg0K

