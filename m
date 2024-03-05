Return-Path: <kvm+bounces-10846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CF6887135A
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 03:11:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7307289B51
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 02:11:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 266171B7E7;
	Tue,  5 Mar 2024 02:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="naqJ5jRe"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F8918EBF
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 02:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709604338; cv=fail; b=VjPPQa1rl6jHDEMoSfxYfICyu2Hjudchjv8KQE4grNyz24JpUsNJtfXZ/3F2pi/BZX1gZwL226W6blnOxGt4dWyUc0YesHUalpplb4JHzpsNFhMV9i1bX5Zd+cWJEfnKP4H/qvzgF2OsuhyYQqF/zhDYjbNUXXygi5nAGd2AR9A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709604338; c=relaxed/simple;
	bh=GL62BH6Sjls3C1TO7JJsaQdCfmBJwpM7yMXWP2P4c+o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SsDgQxb5Vx5GTgIdGjXWCoHI3nwdf69BZJ9DT6OB0baC+quB6yjbTxXR2nQhKB1ml2xNlaToTKLIeQytUqveVVGhEf8nXt+YTjDtbsHy2c32SWhXaA9elF5VFCULhYOzcPATnui8uixH5GiE3qOmqCor6mpv5FU9ZQ/55TcQviU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=naqJ5jRe; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 424N3SD3008573
	for <kvm@vger.kernel.org>; Mon, 4 Mar 2024 18:05:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-id :
 content-type : content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=GL62BH6Sjls3C1TO7JJsaQdCfmBJwpM7yMXWP2P4c+o=;
 b=naqJ5jRe7gQ1806gFJIcMz8LISBg8xqXcUJdceHFVu/QQ6Bef5wM7kuvFMqH+JKg7ZkZ
 NCXCLZraU2XAZ2pCheja5uq96W3HFLnV2HcZ9AV7dNNuO2CFnTM/5SkFkTdmLdWckzyF
 g4n2Ps2HZUDjDYq83teq2GAofVbG3Cl5K1lvhn4cp4ZpSxQ59h22QYA0nTWgW0GzIdZA
 PHtwEUz3XVi9Kk6WJF5UGplRgE4czbiKKkgnELPfUmzvlUaWvI29F/8hgzWUg2vuJsXR
 pCBuYfqvaTpdcYeIEPttc2Iz7o5/WqJdn62ATnBe/mwzzcL0BOxvPw15fbAedBs5uqn6 Xw== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3wndea53nd-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <kvm@vger.kernel.org>; Mon, 04 Mar 2024 18:05:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NgyvpAky4gu8LtDXJm3OeNka0I7ybyYSo8RuytWA7U1qbha+j6MM34ynZGaXuDDq3I1Dt5uzOjPJCIYvnccDim1lcuItl1u0JKo+uH0adjpGKwJVGTj8GKyU0Fe7i+zO5PtX2Kj+mE0vSFPtik+cCPtQIVVJSujcKwWqpe7mt3e762YrwhDssXOAkxcYgYKeGhZVetz+GICNjduUvIe4ZhSxjiYDP9gvRaoJuE0CfcnRozETEcHy1kHlPK2TQRz0LHKxMcySuWg0FAgTIe9cxy9XZ2Y8KmyC3/+T2ny46gkhiiwUMqBf4Lc0ai1c1poH7mAPjybifqbAPyusjVo0Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JbItViP9BzbLKupc3176qOh2wde4gZqdRMjHYGt/iow=;
 b=EoVQM3ERmB1s11obq5/goUCnbKc2KfBoPOmaePNMJuzr49Py72k8EbGJrCGMNiUX5MAVHPCWrftcF8SZYSi1nD+Q2VfqtAW20ResxGiU9Ik6p3nmDUUHZ0m2d7sBcRMzDOd3Qa1iOD71VLVtwQn9D0TUFfMDvraK+akKnEOTL6aQXKdCcHANDFV0MIXElfyaP051ZQngVNPIfiPbnaVlT+tVufindzOoXRvIjw0mNaPJs50YVnObiaFgrGZqAlg9P4RsszDfwR5CmDXBykXM0p4J0Vbq3hvXcharii+m3lY4c6beWWMniUL9qqc2vVUVWqa3de8Ip9cUY+cFI5W4aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from LV2PR15MB5381.namprd15.prod.outlook.com (2603:10b6:408:17b::19)
 by SJ0PR15MB5812.namprd15.prod.outlook.com (2603:10b6:a03:4e3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.38; Tue, 5 Mar
 2024 02:05:32 +0000
Received: from LV2PR15MB5381.namprd15.prod.outlook.com
 ([fe80::37d6:5fd8:7aab:f754]) by LV2PR15MB5381.namprd15.prod.outlook.com
 ([fe80::37d6:5fd8:7aab:f754%5]) with mapi id 15.20.7339.035; Tue, 5 Mar 2024
 02:05:32 +0000
From: Xu Liu <liuxu@meta.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Alex Williamson <alex.williamson@redhat.com>, Xu Liu <liuxu@meta.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-discuss@nongnu.org"
	<qemu-discuss@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: Why does the vmovdqu works for passthrough device but crashes for
 emulated device with "illegal operand" error (in x86_64 QEMU, -accel = kvm) ?
Thread-Topic: Why does the vmovdqu works for passthrough device but crashes
 for emulated device with "illegal operand" error (in x86_64 QEMU, -accel =
 kvm) ?
Thread-Index: AQHabo04wRtF8dyeXkm8NyRZGDdmMbEoZg2A
Date: Tue, 5 Mar 2024 02:05:32 +0000
Message-ID: <383DC340-967F-454A-B298-C59B3F70B63C@fb.com>
References: <39E9DB13-5FA3-4D1A-A573-7D58BA83B35C@fb.com>
 <20240304145932.4e685a38.alex.williamson@redhat.com>
 <51e57a7c-c8a1-4a18-a08b-d2c8fd5b35b3@redhat.com>
In-Reply-To: <51e57a7c-c8a1-4a18-a08b-d2c8fd5b35b3@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR15MB5381:EE_|SJ0PR15MB5812:EE_
x-ms-office365-filtering-correlation-id: 83353b0c-b4bc-422a-d3fc-08dc3cb8bcf8
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 Urb0e6iA10SByP4koDpW615zuDvwdB6mIqyXk8HQ48EyqJcU5gH1LfxPFTQRv66HCVKAN4ikcs1OQfA8uCoP5Iu0NBz++nLmxmNKHhtvluIUqKp0wum2xqv07Puf11GXjY2q75Gs+jpQDdEtyXcmq0kkyzUeXKvtSOT01LiY2Ti9vO0tCcUVOgWwbBWygCU/hHifG2MGmF5IkDiGdmRkd5QRkIASBJ9B/7PzHMiBKy6/89p1JblB0xhYKPuzIdAlK4Y0nB6zT4QEal9Bng9cXvAyBjsZ+JYb1APviPAh4YHeIc8Mq3pBfQGL18JefS+dYDbWWxOz49FKZpK+IJqRtn+ipw3TsNi5zhKYEVMt3R0QpXAWay5094U4GZ5kF0itpkmcRngHNUzNFfslz4dRi0NgDEQ96CeiJKkeW8UbGPop4T0bJE0BZOVKSQITrldfphUfBwR9DPEW5I58zPToSAtBrPxoKUEsxc9pbPkS1NyPknG+n86XkNUtlDtl3BO0DFy5vb3fjxOdTGjkOBvQ16qmlggUNK/XXKhvoKfIZTX8e10ksivQTd8vRF+g93p2+72IYQVw5WovnoZtwLKgI9qTk0lZEDJ1fJZOnk1ltTEkmNJSCpdIVgn5MumgbfNDhSIuiQLi0/+s1kT55BrAbZBluLGqYDYXD8HuDs8nDgA=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR15MB5381.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?S05VMnFxdk12TzM5aEFqZFZjVW5CczVRaTByaElCbjZjdjVmaUppamVjNlE4?=
 =?utf-8?B?V1MweGNrbGd5YmhIWG9UaEgveGMxSWpHWmQ5b3pUUmNuZXlFdlMybTh3L28y?=
 =?utf-8?B?K2dVVEhxV1Rpbm84UkI2dXNGa1E2Yi9tNTNyTGhJYVJwdmxaaUp4L1hUbUIz?=
 =?utf-8?B?SmpFZDVQbGZtc0VVVzlrU3B2SUJWNm54cXFZejNSdlNmdTUyRGtCNklITlA5?=
 =?utf-8?B?L29PeEFNSCtZQVN3NTRaVUFXYUpDL0VtZTBuRUlRWTdkMGFaZkc3dnBkOXh3?=
 =?utf-8?B?WDVRem9wWGw2VlhkaFdZakkxOUo1dFVRSXZ2cWthY1Rub2d2ZThPN200R1dG?=
 =?utf-8?B?NmNzK2Rwdittbk5DYkV3dWJvNGUzV0VUeThhMjM1SXhZTVVucXJ3WTY2TmdS?=
 =?utf-8?B?RnZpbzFjd2pQRUN6SEdQaWU0UVBsQkRuWWhNaWVzN1Y1TktGTUZ5TC8vT0hJ?=
 =?utf-8?B?UW9ZdzJUM2tmS0hOSWdpTGtNMjcza21ZNzUycit2TzVWLzUzZ1M4RkR3ZkpT?=
 =?utf-8?B?cm5RNVMwV3duVjhjN1Rla1R6ZFk2TW85SVlIbWRqTlRkczFYYTArTFRCcVVW?=
 =?utf-8?B?YXBjY0VyWEdrd2NXQkZxTDZyQXpzd3RVbmN1SC9oZ0ltZTkvdkl2YmcxOG5E?=
 =?utf-8?B?NTBrcGhjcjJEd0FST3pOTm1NWSsrdnh2aERGaEtYK3FpU0tTWGMwNGNXbXFt?=
 =?utf-8?B?TStNWlJCck5nRDZtblJwRkc1TVp3K3dvOVBHOWtBQkNQdFRNWDZFdnJXWEF0?=
 =?utf-8?B?dGhKTHM5djZuQTB6M3hvdmlSMmgreXVoR0pDZzZOdXZBQ242Z2NPbUhrTlln?=
 =?utf-8?B?UThkS2ljenFhclJ0L1EzaG9vaWZoSngya1Y2ZHl0WkZGTUU1SVpiUVNFdi9B?=
 =?utf-8?B?TW5iWmlkRWdBRmZZd1c2NlJGODgzang5ZWFMQ0NueHhFQTVKcTQ5QnlWd2RN?=
 =?utf-8?B?YkR0NXVaN2diL2VLNEJWTjE4K1ZyYWthbEJaWjkvaFNJd1h0SUdKeHVRQk5q?=
 =?utf-8?B?bkR1MVZ5YWdOWTI1akJYdnljR3d4cU4wTWlqWE5IaUd4aGo4MzRhT2tSRFRX?=
 =?utf-8?B?NjNEdmRRYXQ1S0RxWjZ4RzF6ZzN6Yk9oOXZLbFlpSlVvM1FleTZSY0ZUSUFN?=
 =?utf-8?B?QkhOaDdMNW1kSk1ieU5GUmNGNTZLK1N0OVpVUmpwbU55VlRjWEhROEIvUng2?=
 =?utf-8?B?cFFRbUxaMGRGRHFEMmdrNlIxNEVuQXVUZ3NvT2ZRM2xzdklobEFOdkd3dFVl?=
 =?utf-8?B?OEc3Wlhjc1hCdnhWR3JPQnhUTDdpVzlINENqUytYWWVXTjQ2MUdxLzNkNzBm?=
 =?utf-8?B?VDk4M05TUkVOSG4wWU1aSmZCbFViUGZZaXFRYkhkcjBVRkdOUUhrMk1IeE9n?=
 =?utf-8?B?VG8zZHA4SmIySktwZjhqTnBMTDJJSXN0ZXh4c2NwYkc1Q2R0UFZscGx5L1dy?=
 =?utf-8?B?aXJiaFZ4SVc4ZUx0V1F2engvNGRqNTNJOVpVKzd2QndQMEZwcFpQR2xJSnlK?=
 =?utf-8?B?a2NaYkZJc0pWSEp1WjJUSFlhazFCR3p6K0ZUUDZ3MWliK2ZQcDlYcFY3dlUr?=
 =?utf-8?B?Vk5EVGxTSzZ4WXI5Tlo4RGNiVzdoamNWeTRWeWhKV0E3akdOKzRscGh0aVR6?=
 =?utf-8?B?VHovVmhCVjV5QTBPaysxSDIzelRDVmxabmFjMjZ1MGlCZkFxR2hMQ0V2RmVK?=
 =?utf-8?B?QytuMHhCWGZqaFo1eEdHNHBETkQwZFQ3NTgxNGdIbzhhZ254WVBDbEdoZ2t1?=
 =?utf-8?B?bFk4WElWM1VNU2xlNFNwbFRyYzNCQ2tES1Y1N0RTYitlT3g3Yk9oY2IzSWps?=
 =?utf-8?B?YU05MmFRUnlUTi9Ib1BFbC9nR1Z0azRrN0xPSmNGNitNTzVQMXpvcHlxeTRU?=
 =?utf-8?B?MnhkeENqbnlQbkZINEt2d0VoUVltLzlCK1pGWXpzYTNScW9SdjJmWGdJcUdm?=
 =?utf-8?B?VEZsU0ZCaUllam4yN2FQNWpmTVlMZ1dpaitvUVlKdjE2N3VhOUlxbWNEb0I5?=
 =?utf-8?B?LzNZZ3dhQ2tja0J4ZXRPMDF6cmFwOGFZM09zeU5tVzFtOVF4U0k0M1lDc0t4?=
 =?utf-8?B?eUEvMzBHejcvZ0lQL1FoUVBFbDFxZVJkZVV5SmlrTGJPNzU5ZndsTGdLeS95?=
 =?utf-8?B?RE1rVU95MGViU2hOdU01MnFSK24rRkNCZ1RWdW9YM2grYVRkeDF2QWlyYWI0?=
 =?utf-8?B?aVE9PQ==?=
Content-ID: <E90F763F67B68D44B98FB2A375C7B750@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR15MB5381.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83353b0c-b4bc-422a-d3fc-08dc3cb8bcf8
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2024 02:05:32.1384
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sTUSQVBnt5OgRb4qvy0jqMcbd+Hlr2b7M54cNxgOrIDIgVgBRAxAtRvkRHSlyJkl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB5812
X-Proofpoint-ORIG-GUID: 33HM73sDKjn-lOsgt_evEL0nVX_azZAD
X-Proofpoint-GUID: 33HM73sDKjn-lOsgt_evEL0nVX_azZAD
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-04_20,2024-03-04_01,2023-05-22_02

SGV5IEFsZXggYW5kIFBhb2xvLA0KDQpJIHNhdyB0aGVyZSBpcyBzb21lIGNvZGUgcmVsYXRlZCB0
byBBVlggIGh0dHBzOi8vZWxpeGlyLmJvb3RsaW4uY29tL2xpbnV4L2xhdGVzdC9zb3VyY2UvYXJj
aC94ODYva3ZtL2VtdWxhdGUuYyNMNjY4DQoNCkRvZXMgdGhhdCBtZWFuIGluIHNvbWUgc3BlY2lh
bCBjYXNlcywga3ZtIHN1cHBvcnRzIEFWWCBpbnN0cnVjdGlvbnMgPw0KSSBkaWRu4oCZdCByZWFs
bHkga25vdyB0aGUgYmlnIHBpY3R1cmUsIHNvIGp1c3QgZ3Vlc3Mgd2hhdCBpdCBpcyBkb2luZyAu
DQoNClRoYW5rcywNClh1DQoNCj4gT24gTWFyIDQsIDIwMjQsIGF0IDY6MznigK9QTSwgUGFvbG8g
Qm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT4gd3JvdGU6DQo+IA0KPiAhLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLXwN
Cj4gVGhpcyBNZXNzYWdlIElzIEZyb20gYW4gRXh0ZXJuYWwgU2VuZGVyDQo+IA0KPiB8LS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLSENCj4gDQo+IE9uIDMvNC8yNCAyMjo1OSwgQWxleCBXaWxsaWFtc29uIHdyb3RlOg0KPj4g
U2luY2UgeW91J3JlIG5vdCBzZWVpbmcgYSBLVk1fRVhJVF9NTUlPIEknZCBndWVzcyB0aGlzIGlz
IG1vcmUgb2YgYSBLVk0NCj4+IGlzc3VlIHRoYW4gUUVNVSAoQ2Mga3ZtIGxpc3QpLiAgUG9zc2li
bHkgS1ZNIGRvZXNuJ3QgZW11bGF0ZSB2bW92ZHF1DQo+PiByZWxhdGl2ZSB0byBhbiBNTUlPIGFj
Y2VzcywgYnV0IGhvbmVzdGx5IEknbSBub3QgcG9zaXRpdmUgdGhhdCBBVlgNCj4+IGluc3RydWN0
aW9ucyBhcmUgbWVhbnQgdG8gd29yayBvbiBNTUlPIHNwYWNlLiAgSSdsbCBsZXQgeDg2IEtWTSBl
eHBlcnRzDQo+PiBtb3JlIGZhbWlsaWFyIHdpdGggc3BlY2lmaWMgb3Bjb2RlIHNlbWFudGljcyB3
ZWlnaCBpbiBvbiB0aGF0Lg0KPiANCj4gSW5kZWVkLCBLVk0ncyBpbnN0cnVjdGlvbiBlbXVsYXRv
ciBzdXBwb3J0cyBzb21lIFNTRSBNT1YgaW5zdHJ1Y3Rpb25zIGJ1dCBub3QgdGhlIGNvcnJlc3Bv
bmRpbmcgQVZYIGluc3RydWN0aW9ucy4NCj4gDQo+IFZlY3RvciBpbnN0cnVjdGlvbnMgaG93ZXZl
ciBkbyB3b3JrIG9uIE1NSU8gc3BhY2UsIGFuZCB0aGV5IGFyZSB1c2VkIG9jY2FzaW9uYWxseSBl
c3BlY2lhbGx5IGluIGNvbWJpbmF0aW9uIHdpdGggd3JpdGUtY29tYmluaW5nIG1lbW9yeS4gIFNT
RSBzdXBwb3J0IHdhcyBhZGRlZCB0byBLVk0gYmVjYXVzZSBzb21lIG9wZXJhdGluZyBzeXN0ZW1z
IHVzZWQgU1NFIGluc3RydWN0aW9ucyB0byByZWFkIGFuZCB3cml0ZSB0byBWUkFNLiAgSG93ZXZl
ciwgc28gZmFyIHdlJ3ZlIG5ldmVyIHJlY2VpdmVkIGFueSByZXBvcnRzIG9mIE9TZXMgdXNpbmcg
QVZYIGluc3RydWN0aW9ucyBvbiBkZXZpY2VzIHRoYXQgUUVNVSBjYW4gZW11bGF0ZSAoYXMgb3Bw
b3NlZCB0bywgZm9yIGV4YW1wbGUsIEdQVSBWUkFNIHRoYXQgaXMgcGFzc2VkIHRocm91Z2gpLg0K
PiANCj4gVGhhbmtzLA0KPiANCj4gUGFvbG8NCj4gDQo+PiBJcyB5b3VyICJwcm9ncmFtIiBqdXN0
IGRvaW5nIGEgbWVtY3B5KCkgd2l0aCBhbiBtbWFwKCkgb2YgdGhlIFBDSSBCQVINCj4+IGFjcXVp
cmVkIHRocm91Z2ggcGNpLXN5c2ZzIG9yIGEgdXNlcnNwYWNlIHZmaW8tcGNpIGRyaXZlciB3aXRo
aW4gdGhlDQo+PiBndWVzdD8NCj4+IEluIFFFTVUgNGEyZTI0MmJiYjMwICgibWVtb3J5OiBEb24n
dCB1c2UgbWVtY3B5IGZvciByYW1fZGV2aWNlDQo+PiByZWdpb25zIikgd2UgcmVzb2x2ZWQgYW4g
aXNzdWVbMV0gd2hlcmUgUUVNVSBpdHNlbGYgd2FzIGRvaW5nIGEgbWVtY3B5KCkNCj4+IHRvIGFz
c2lnbmVkIGRldmljZSBNTUlPIHNwYWNlIHJlc3VsdGluZyBpbiBicmVha2luZyBmdW5jdGlvbmFs
aXR5IG9mDQo+PiB0aGUgZGV2aWNlLiAgSUlSQyBtZW1jcHkoKSB3YXMgdXNpbmcgYW4gU1NFIGlu
c3RydWN0aW9uIHRoYXQgZGlkbid0DQo+PiBmYXVsdCwgYnV0IGRpZG4ndCB3b3JrIGNvcnJlY3Rs
eSByZWxhdGl2ZSB0byBNTUlPIHNwYWNlIGVpdGhlci4NCj4+IFNvIEkgYWxzbyB3b3VsZG4ndCBy
dWxlIG91dCB0aGF0IHRoZSBwcm9ncmFtIGlzbid0IGluaGVyZW50bHkNCj4+IG1pc2JlaGF2aW5n
IGJ5IHVzaW5nIG1lbWNweSgpIGFuZCB0aGVyZWJ5IGlnbm9yaW5nIHRoZSBuYXR1cmUgb2YgdGhl
DQo+PiBkZXZpY2UgTU1JTyBhY2Nlc3Mgc2VtYW50aWNzLiAgVGhhbmtzLA0KPj4gQWxleA0KPj4g
WzFdaHR0cHM6Ly9idWdzLmxhdW5jaHBhZC5uZXQvcWVtdS8rYnVnLzEzODQ4OTINCj4gDQoNCg==

