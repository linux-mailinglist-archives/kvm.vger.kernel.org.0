Return-Path: <kvm+bounces-19795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 90C0C90B578
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 17:58:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E76EF281137
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 15:58:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4F66143863;
	Mon, 17 Jun 2024 15:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="LUuHkqYK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11olkn2070.outbound.protection.outlook.com [40.92.20.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423B6225AE;
	Mon, 17 Jun 2024 15:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.20.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718639167; cv=fail; b=ESMne/xIWF1lDx3LxkiQn/srmCWbT1ZEB9YBAyE8I8szdkkS1Tv43hlSm4D0nIA2uEIRM7k4/UKPO6RtMtPep9ftJNQLmCYMXJzZ6k73IBYQvkhFofvnanDonxqI9b7Yze7tZMBh8luKqPS6gLplJyetNvLSoKv+jq0CDxqn/Go=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718639167; c=relaxed/simple;
	bh=eFigkp1NP7gN1Bhof2QEPc1JG4bLUcmzIdEVK1LVljs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=m416Q253iPoXsb+TMakIc6I+KQjeIpYImZLZC0r5yuBmp0TKhyNy4+E1jWDnLhPRhnyZJqYxrpb9UZM3MY7Vo5ZfPEE7TfBduC3ficGHqlRZXXky0uVZnOvDN9aa8Gi6a/5XbQ+YjPp5kAhTOWXuRmKgJqMEfU5kzKb56Gp4a14=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=LUuHkqYK; arc=fail smtp.client-ip=40.92.20.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VUB4Q+O8pZlzBouf3FN01eWNbQrVQ4p0Qq6wkI6clZxH5bp+q+IosFCcsEwri2STFGxxYyw98mLjMYEBt6jbDMMqCfQ4hFQp8ZmIQjK5lssZInakfPIXWf+cu/qP0dYZIFo+1R1qXpQdOJjzAUV3+G320aIbBi+jdTR8XGWuM3hj0CMubrBnlZxlWko0ICO0Ulv/QJYCKJO9cidrI7iOAHvIvq9FVsLeHCk0K3ZpVkktOeqpAccBRRBiChp/pXbuAxc+1gv/kau0q0xmGWnDmphVxp0O6iu6UvnAo0W8pU1Vc+dM+9GCzA4F/2QUHn+8ylXo1+2GKSoVfHS49i3Fow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eFigkp1NP7gN1Bhof2QEPc1JG4bLUcmzIdEVK1LVljs=;
 b=bm2t53kphqPghUSpTrv7rZb/34uHbNyY7qxcXl3TDcPM5rtJZTDUnft5RxZyzr7idA8JaOu/MjXdUXUAXxL21JXyKq1mkZS4Pc0YtN4u+zBGSpyUB+Tj8nbHFszJsd/ZW+jmrTq78NjsI48OgJpfLmeEEO+d1BeXGQkGkGQGRS0OZAjCbtKhkBQYkVglnGSER2DCgTQXgv6lpJ/NNehpHt+LYMtfLro7c52bl334+H8HnTC3CmbKSSlBJ4nTV21c3/PmRP4y2M2gJhSGHIVeWQ0VENPoyVT4AVHMVCqyCuCEClg1AsXEspHXGLaHZb0hpD3M/oZVGQZbWPgc6llr2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eFigkp1NP7gN1Bhof2QEPc1JG4bLUcmzIdEVK1LVljs=;
 b=LUuHkqYK1bvQB3JmH4OgozLGbbFthlNwJDhAQTQ6nZAVIb86MCwtGzlg0WUV21X+a85kPrbpQWlICq1vLcpjUlxBgKNDq/Gkeo/6x7a984ggDxb73Ah94a8BjeQdt6GflqdHUgwsX861rxv4SSYi5QEY64XroB2kZXRndPQQBqOF2SUu1O/qUH1PTC+jVI8NS9mbjxWT4XO5a7K1tP1i5HzvKVP3joQppX0yvRtbS9sw11Bh/MAYStpWxSOV505DW7++3edqe2V+D2qZZiLWFdvp/bxIqKlH0FIRCw/9gJVu1oYh6ri1N8E6qPA0ro8auUsm+iCEGi370dTvFsacLg==
Received: from SN6PR02MB4157.namprd02.prod.outlook.com (2603:10b6:805:33::23)
 by SA3PR02MB9995.namprd02.prod.outlook.com (2603:10b6:806:381::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Mon, 17 Jun
 2024 15:46:02 +0000
Received: from SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df]) by SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df%2]) with mapi id 15.20.7677.024; Mon, 17 Jun 2024
 15:46:02 +0000
From: Michael Kelley <mhklinux@outlook.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>, Steven Price
	<steven.price@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>
CC: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, Oliver
 Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Joey Gouly <joey.gouly@arm.com>, Alexandru
 Elisei <alexandru.elisei@arm.com>, Christoffer Dall
	<christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, Ganapatrao
 Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: RE: [PATCH v3 10/14] arm64: Force device mappings to be non-secure
 shared
Thread-Topic: [PATCH v3 10/14] arm64: Force device mappings to be non-secure
 shared
Thread-Index: AQHatyuoktsEyvA+5U6nclVJ10j8LLHLXc9wgADAmwCAAA1L4A==
Date: Mon, 17 Jun 2024 15:46:01 +0000
Message-ID:
 <SN6PR02MB4157BFB2B921202BFC2F7B77D4CD2@SN6PR02MB4157.namprd02.prod.outlook.com>
References: <20240605093006.145492-1-steven.price@arm.com>
 <20240605093006.145492-11-steven.price@arm.com>
 <SN6PR02MB4157D26A6CE9B3B96032A1D1D4CD2@SN6PR02MB4157.namprd02.prod.outlook.com>
 <1dd92421-8eba-48db-99da-4390d9e19abd@arm.com>
In-Reply-To: <1dd92421-8eba-48db-99da-4390d9e19abd@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-tmn: [+2dK9+0aUi4QpVqXQCD+oxHuLvsKBsOa]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR02MB4157:EE_|SA3PR02MB9995:EE_
x-ms-office365-filtering-correlation-id: 86c54a93-4c1f-4cd4-5ac0-08dc8ee49733
x-microsoft-antispam:
 BCL:0;ARA:14566002|461199025|3412199022|440099025|102099029;
x-microsoft-antispam-message-info:
 /Rjf5+r5PSsPS3KCmrHEle7Ich5HOUROFwyHYee1CKGXoL8vIXcaOd7bx6P5L29A9W8eM4PisEBxBiK6dCa918pXc2jJtBZWs2ZWO15T9AhsgaAYriZlJwOi+tV/SXDEsEWqP4IhHXBu1uH9VMgUZ7vSBwJABnReo6bJv6L+3qf5kfToozex/65oE1udf5ilIcyeCTuvGGT2bDFcrKqzgugxREVVBRtO61JXdx8S8bTWrm10c33T6aNBpd6jf+XkECIAYdm4BYNjuyyTw8/++Uoveo5NZObA8s7eUe6gVI/OD8xd7ne3/uCG8kEa/dK1+yCm2A3+bjG8yayY2+oEJlyN+hwfHtS12HD/NNiJsRzu6cnucPDnrp5yzbQIpoWLCKSa2rC0lL2IYFsygyZcGBDNqeeCvRI6fA9kW/lDJjo7JFsIT/itteYFozdYgqDRaeInMXY1d/FCpN18rCM2AIBBZgR6qzF6ABqxn4pXcY5urXWRxLX1Abu9p1LC7HcQ++XPjD0ujKdyZGZE9hlWGkmP1VLfyd5DpApWcv8iuzt5EdAZ9OHMzicur3LU3nd/
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SzhadnIxUUpQejJIUGJaMU1YQUVxOUY5RFVtY0JxWjlxQ1hpdmUvVS9iUHNn?=
 =?utf-8?B?MTFPRHZWUXNTYXMwK2I0RkdwOXlSbzhEV3NoYy82SmFWNUtyTmptMmlRUXlx?=
 =?utf-8?B?cWVyMWplaTFJUDdhQXlFWFRSVUNpbjVJSkpublcwYXJteGhMekZqUXR2N2dO?=
 =?utf-8?B?ZGNYMjBTL01OWlc3QTBVdUtxTmJCODZIMWxGMlVnMWx5TFNjVm51TWo0OElY?=
 =?utf-8?B?bVRySmR0WmtXMkJhcnNJbFRoZFhHZklxNFU4eC9tYVduZXpPOWRGWGI5L1Za?=
 =?utf-8?B?cW1GblFiQWNoNGVEcTQ2THpLaGh6Y3d3K3BTMjUwSTlYeXpoVDhiRjFVYW9K?=
 =?utf-8?B?QllhdHFhV0dGOUVMUkt1R1JHVmJhMjdHMkduUnNhYlo1YzhwQUVJcVNYLzEv?=
 =?utf-8?B?SzlFaktMVEEvN1h1cEN0N3ZzeFNESysvcmxVSjlFQ2wxNHBhTFFFRDNoQzZH?=
 =?utf-8?B?WXpTWUI1TlVkbGx3NXhMcXV4UjQ5QkVNM0pyK084U2pGQkZXQTBFWVpXZm9O?=
 =?utf-8?B?WVgzSk4yYTg1NlNiY1lLZkFaaGl5TTFaZnJtcm1Kbm9PWE9rSnZjVUFtYVl6?=
 =?utf-8?B?akY2eC93NmNBNzZHYk00V2JBNUhUT0NXNjg1bGZYZjFoc1pZZ3J2bm42bTJk?=
 =?utf-8?B?TDlZTFE3QUdQR1UxWlNtd3N4bzNDRjJsUGlLeW44ekorNnZFZmJpWXlPZFY5?=
 =?utf-8?B?RGNGVDFqU0JDaDhYbktEZGNHM3IzMC90K1VUVWdremVKaFczNGJBRlR6eTRo?=
 =?utf-8?B?Qmwrd2xwdlh1eHAvYU0xY3hva1VxUTF3RTRhTDBXTU9wUXBtOENJbzZld1NN?=
 =?utf-8?B?YnRtWHVKU05sYWZ5M24wa0tNY1ZtYUVkNzR5N1lsdkRSZTBTRy9yWW8ydXhZ?=
 =?utf-8?B?MWlrYWp6ZC96UlBzQnduZU90OUtNZStNUW5Nd3lpaytmS0RrVkNEVkpjUDl6?=
 =?utf-8?B?ZmpPcHRTSENqOGFPaCtLZzM1OXlqcENFWTJ2NUgyN2hXMXNTMkRjQWttVGFM?=
 =?utf-8?B?dFNTcHF0UzlOcVBGNVNVd1FqN09INkVaMjlKSEFlQmZ3OEZYaEdWWkRxWEQw?=
 =?utf-8?B?U0dDR3k5MnRMMzRLdzFhcTZlK1pXalpSblJ3Y2NqdWJZTWN4N3l0L25CUnNE?=
 =?utf-8?B?RXF0TnpUSHFQTzBVZTZ5TnQ4RHRrY3laMXlYRThJV3V4dVJjcEE3V2ZaaEdu?=
 =?utf-8?B?ZVc3aE9hQ2NBVHcrQ3h1dzRzRHp0YSt2LzY4VjNLNjQzQWQxMDdMcWhHSTFY?=
 =?utf-8?B?QmRiLy9PNjZCaXdQcHhHWW9tZUdjUUdRSTJIMjVGM3pkQTJsQ1ZDQ1BSblRu?=
 =?utf-8?B?eTI5QXFBYzIvUzVteE5DSkdYL3ZLdkJPR3BDSXBiMkhGRVNXcHdWYk5ldjBt?=
 =?utf-8?B?dEN6Zkd6VnVHL04xYkZGNjhzemovL2JpQjJFL0Q3MTlRbWJIdjZyNWkxYlA4?=
 =?utf-8?B?ZytYditUTlBSbm05cVlDeFhjN0Z6Yjd3dnhDc3lTTDE3NmxITCtsRTZEYkRB?=
 =?utf-8?B?cWpkQVBNcVRYd2ZZRG1vMlF0Rkp0VlgzUjVxV3VNVFp1a09uSWxoQjhKS3lV?=
 =?utf-8?B?QkFCeXhKMW94ZHM3VFdOMGFzQ25WbWx3TmpuMWpiajhQdTBwbjVzSU5LdU80?=
 =?utf-8?Q?TQvYPF8NQ60+ahlHMxLR76npyCnVcfUMeTnwYMQ0Q2Z0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR02MB4157.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 86c54a93-4c1f-4cd4-5ac0-08dc8ee49733
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2024 15:46:01.9854
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR02MB9995

RnJvbTogU3V6dWtpIEsgUG91bG9zZSA8c3V6dWtpLnBvdWxvc2VAYXJtLmNvbT4gU2VudDogTW9u
ZGF5LCBKdW5lIDE3LCAyMDI0IDc6NTUgQU0NCj4gDQo+IE9uIDE3LzA2LzIwMjQgMDQ6MzMsIE1p
Y2hhZWwgS2VsbGV5IHdyb3RlOg0KPiA+IEZyb206IFN0ZXZlbiBQcmljZSA8c3RldmVuLnByaWNl
QGFybS5jb20+IFNlbnQ6IFdlZG5lc2RheSwgSnVuZSA1LCAyMDI0IDI6MzAgQU0NCj4gPj4NCj4g
Pj4gRnJvbTogU3V6dWtpIEsgUG91bG9zZSA8c3V6dWtpLnBvdWxvc2VAYXJtLmNvbT4NCj4gPj4N
Cj4gPj4gRGV2aWNlIG1hcHBpbmdzIChjdXJyZW50bHkpIG5lZWQgdG8gYmUgZW11bGF0ZWQgYnkg
dGhlIFZNTSBzbyBtdXN0IGJlDQo+ID4+IG1hcHBlZCBzaGFyZWQgd2l0aCB0aGUgaG9zdC4NCj4g
Pj4NCj4gPj4gU2lnbmVkLW9mZi1ieTogU3V6dWtpIEsgUG91bG9zZSA8c3V6dWtpLnBvdWxvc2VA
YXJtLmNvbT4NCj4gPj4gU2lnbmVkLW9mZi1ieTogU3RldmVuIFByaWNlIDxzdGV2ZW4ucHJpY2VA
YXJtLmNvbT4NCj4gPj4gLS0tDQo+ID4+ICAgYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9wZ3RhYmxl
LmggfCAyICstDQo+ID4+ICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0
aW9uKC0pDQo+ID4+DQo+ID4+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL3Bn
dGFibGUuaA0KPiBiL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20vcGd0YWJsZS5oDQo+ID4+IGluZGV4
IDExZDYxNGQ4MzMxNy4uYzk4NmZkZTI2MmMwIDEwMDY0NA0KPiA+PiAtLS0gYS9hcmNoL2FybTY0
L2luY2x1ZGUvYXNtL3BndGFibGUuaA0KPiA+PiArKysgYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNt
L3BndGFibGUuaA0KPiA+PiBAQCAtNjQ0LDcgKzY0NCw3IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBz
ZXRfcHVkX2F0KHN0cnVjdCBtbV9zdHJ1Y3QgKm1tLCB1bnNpZ25lZCBsb25nIGFkZHIsDQo+ID4+
ICAgI2RlZmluZSBwZ3Byb3Rfd3JpdGVjb21iaW5lKHByb3QpIFwNCj4gPj4gICAJX19wZ3Byb3Rf
bW9kaWZ5KHByb3QsIFBURV9BVFRSSU5EWF9NQVNLLCBQVEVfQVRUUklORFgoTVRfTk9STUFMX05D
KSB8IFBURV9QWE4gfCBQVEVfVVhOKQ0KPiA+PiAgICNkZWZpbmUgcGdwcm90X2RldmljZShwcm90
KSBcDQo+ID4+IC0JX19wZ3Byb3RfbW9kaWZ5KHByb3QsIFBURV9BVFRSSU5EWF9NQVNLLCBQVEVf
QVRUUklORFgoTVRfREVWSUNFX25HblJFKSB8IFBURV9QWE4gfCBQVEVfVVhOKQ0KPiA+PiArCV9f
cGdwcm90X21vZGlmeShwcm90LCBQVEVfQVRUUklORFhfTUFTSywgUFRFX0FUVFJJTkRYKE1UX0RF
VklDRV9uR25SRSkgfCBQVEVfUFhOIHwgUFRFX1VYTiB8IFBST1RfTlNfU0hBUkVEKQ0KPiA+PiAg
ICNkZWZpbmUgcGdwcm90X3RhZ2dlZChwcm90KSBcDQo+ID4+ICAgCV9fcGdwcm90X21vZGlmeShw
cm90LCBQVEVfQVRUUklORFhfTUFTSywgUFRFX0FUVFJJTkRYKE1UX05PUk1BTF9UQUdHRUQpKQ0K
PiA+PiAgICNkZWZpbmUgcGdwcm90X21ocAlwZ3Byb3RfdGFnZ2VkDQo+ID4NCj4gPiBJbiB2MiBv
ZiB0aGUgcGF0Y2hlcywgQ2F0YWxpbiByYWlzZWQgYSBxdWVzdGlvbiBhYm91dCB0aGUgbmVlZCBm
b3INCj4gPiBwZ3Byb3RfZGVjcnlwdGVkKCkuIFdoYXQgd2FzIGNvbmNsdWRlZD8gSXQgc3RpbGwg
bG9va3MgdG8gbWUgbGlrZQ0KPiA+IHBncHJvdF9kZWNyeXB0ZWQoKSBhbmQgcHJvdF9lbmNyeXB0
ZWQoKSBhcmUgbmVlZGVkLCBieQ0KPiA+IGRtYV9kaXJlY3RfbW1hcCgpIGFuZCByZW1hcF9vbGRt
ZW1fcGZuX3JhbmdlKCksIHJlc3BlY3RpdmVseS4NCj4gPiBBbHNvLCBhc3N1bWluZyBIeXBlci1W
IHN1cHBvcnRzIENDQSBhdCBzb21lIHBvaW50LCB0aGUgTGludXggZ3Vlc3QNCj4gPiBkcml2ZXJz
IGZvciBIeXBlci1WIG5lZWQgcGdwcm90X2RlY3J5cHRlZCgpIGluIGh2X3JpbmdidWZmZXJfaW5p
dCgpLg0KPiANCj4gUmlnaHQsIEkgdGhpbmsgd2UgY291bGQgc2ltcGx5IGRvIDoNCj4gDQo+IGRp
ZmYgLS1naXQgYS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL3BndGFibGUuaA0KPiBiL2FyY2gvYXJt
NjQvaW5jbHVkZS9hc20vcGd0YWJsZS5oDQo+IGluZGV4IGM5ODZmZGUyNjJjMC4uMWVkNDU4OTNk
MWU2IDEwMDY0NA0KPiAtLS0gYS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL3BndGFibGUuaA0KPiAr
KysgYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL3BndGFibGUuaA0KPiBAQCAtNjQ4LDYgKzY0OCwx
MCBAQCBzdGF0aWMgaW5saW5lIHZvaWQgc2V0X3B1ZF9hdChzdHJ1Y3QgbW1fc3RydWN0ICptbSwg
dW5zaWduZWQgbG9uZyBhZGRyLA0KPiAgICNkZWZpbmUgcGdwcm90X3RhZ2dlZChwcm90KSBcDQo+
ICAgICAgICAgIF9fcGdwcm90X21vZGlmeShwcm90LCBQVEVfQVRUUklORFhfTUFTSywgUFRFX0FU
VFJJTkRYKE1UX05PUk1BTF9UQUdHRUQpKQ0KPiAgICNkZWZpbmUgcGdwcm90X21ocCAgICAgcGdw
cm90X3RhZ2dlZA0KPiArDQo+ICsjZGVmaW5lIHBncHJvdF9kZWNyeXB0ZWQocHJvdCkgX19wZ3By
b3RfbW9kaWZ5KHByb3QsIFBST1RfTlNfU0hBUkVELCBQUk9UX05TX1NIQVJFRCkNCj4gKyNkZWZp
bmUgcGdwcm90X2VuY3J5cHRlZChwcm90KSAgX19wZ3Byb3RfbW9kaWZ5KHByb3QsIFBST1RfTlNf
U0hBUkVELCAwKQ0KPiArDQo+IA0KDQpZZXMsIGxvb2tzIHJpZ2h0IHRvIG1lLg0KDQpNaWNoYWVs
DQo=

