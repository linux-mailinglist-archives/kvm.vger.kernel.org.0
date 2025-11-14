Return-Path: <kvm+bounces-63176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 52A2CC5B635
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 06:29:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A0506352F86
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 05:28:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 052DB2D663E;
	Fri, 14 Nov 2025 05:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="um5g3Doh"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazolkn19012051.outbound.protection.outlook.com [52.103.2.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A3024679C;
	Fri, 14 Nov 2025 05:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.2.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763098081; cv=fail; b=I5+G0qbzHpGQ7cHAmc0xIksYRlMqZRUU6S0NVaBWzU4c1Bug8YAMZxR7B8QTCFdhldeP2Upmsr1CarvFKIFVWyf7S5O9aWuCy5925xQm9ie5sIZBymktaAFBrpkgPfySmuLEri0T+lhaVfNHgbOHlDXTLgbSQ8BABxZTMTKBQ6w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763098081; c=relaxed/simple;
	bh=/eEZdMhyiz35lSPoBA2V/8/sgwpqTvQ9qZLXKVYTKQw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mxJG6680wMEPvwhDA4eRSaJEQBTyBYtuvwvczy3Fu2BHH5vPrqObIb7fHuROb62iXw1SVqy28h1wNvH98VqrQP1xEA8N8kLMIYdODAJDQf/ADLWCb7yCVHaieIkbBX7A510JqcYnvIReDbtIh7jtFGOHUdmkXGl0MwRrqvxphz8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=um5g3Doh; arc=fail smtp.client-ip=52.103.2.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GqCOO+oO0kAy+Jq0vxGaCeD90JTDYf++iKC8gsV4hQFaaya/xxTNHHLSpnQRYm1he/RzfY3VGmr7Bf91Rezb9c2SmiA51DgcVQ61Nh5EgijeM5tWXxejyLPzPC6ZAziOz7DMIcjWpyxcB2wfR0C04/q5eQ2AqXZ6xDFjkFU7An3dPu586UAlKQa0W7Z30DYboi2/KXWiolGtCeFypaxBVcs1DrCan7ex05/DLouGTcl1eHydVf7l5SZpunmVL1ggisCBfe32QR7TcDrthXWmlgz4KZEqzWZdIrMSXH2edBzWohdTY2rHVsFPXr03E43Al5u97nl48Tj8FqttUQCXLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/eEZdMhyiz35lSPoBA2V/8/sgwpqTvQ9qZLXKVYTKQw=;
 b=D+SgJMZBoN8aQe303pPFKwgR5eg4ClvK3smlBLITl2NQMKvmalHQK/0GGoQQuTjLX0pQVabUksKD7zJMgZtpqodG6lFJiWFXUBPJBgi+qxWwR6HIEa0Y/ySov6yoBesQzJCo/XG0QRsasAgWNAoEX5h8WG6LgHi/BqXSTLpROk+Ru8Yr03Qu4Hp/rWvQIxGLtVaiW4xo087QjtrTCkowZAEm6fnI/QBK9zA/EXIMzzaD2r2EnZz6V4QlBqm78Sls3VKu/vYRvZAwiIUnb1w3g4VCj12kDrIZPHfVniO6etzLDTN420zM4dheA/e9ut9l5XkUK2e7YE6pjZsf5aKmIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/eEZdMhyiz35lSPoBA2V/8/sgwpqTvQ9qZLXKVYTKQw=;
 b=um5g3DohIe9xUBrJzC9TK5ipfUHW6jJ4ml6EZzqeAaJh8HSdFWPp9XnzCYtCC2ziL9YPm+Fm1ERvbe3yDgA8UeqvDgJskwGxM472iCP2/979WX0faOkIe27ZpY4gbtTjuviHwlEdjmioYZfX+CE+xfUVyBSPkuhohVcnOn7/VKDyxDgIdV+fRjS9SXMIpubQGeKwcV3UaIpLowFcpryi4yZpWx2kuDURIwNEHvQbkMCor6M68bqSxUFSyLzuyPmrEMYvTrSlq/oNjv30B4gCtxvXABQzzV++QI2ll5ScU2xrxk6K3t7E6EIXgXo+DJ8ZIqL6qDQ7NENAzM7qkb7zjA==
Received: from SN6PR02MB4157.namprd02.prod.outlook.com (2603:10b6:805:33::23)
 by CH4PR02MB10657.namprd02.prod.outlook.com (2603:10b6:610:242::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Fri, 14 Nov
 2025 05:26:44 +0000
Received: from SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df]) by SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df%2]) with mapi id 15.20.9320.013; Fri, 14 Nov 2025
 05:26:44 +0000
From: Michael Kelley <mhklinux@outlook.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, "K. Y.
 Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei
 Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, Nuno Das Neves
	<nunodasneves@linux.microsoft.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jim Mattson
	<jmattson@google.com>, Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: RE: [PATCH 7/9] KVM: SVM: Treat exit_code as an unsigned 64-bit value
 through all of KVM
Thread-Topic: [PATCH 7/9] KVM: SVM: Treat exit_code as an unsigned 64-bit
 value through all of KVM
Thread-Index: AQHcVPEVSw/PVx8pfkaBm5b0agRei7TxoehA
Date: Fri, 14 Nov 2025 05:26:44 +0000
Message-ID:
 <SN6PR02MB4157AF057CC8539AD47F6D66D4CAA@SN6PR02MB4157.namprd02.prod.outlook.com>
References: <20251113225621.1688428-1-seanjc@google.com>
 <20251113225621.1688428-8-seanjc@google.com>
In-Reply-To: <20251113225621.1688428-8-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR02MB4157:EE_|CH4PR02MB10657:EE_
x-ms-office365-filtering-correlation-id: fc7c7c9e-672b-484e-f143-08de233e662b
x-microsoft-antispam:
 BCL:0;ARA:14566002|8022599003|31061999003|15080799012|12121999013|461199028|8060799015|19110799012|8062599012|13091999003|102099032|3412199025|440099028;
x-microsoft-antispam-message-info:
 =?utf-8?B?VTNZT1RERzU1eXE0R3VpMml3R0tXM1RQWFA4dzdmM28wU1VjY0lJRFFGVytj?=
 =?utf-8?B?OUNOUUYxVzBTYXdoaS80Y296dkpRYnRGbXRjdWlVVkJ5WEhkK2xJODFZdTdx?=
 =?utf-8?B?dkhvay91U1k4SFNXNnVFY0VPUlhaZFpvRWdFdm5MUU5sWE91N0F6aVVEbUN2?=
 =?utf-8?B?c0ErZFpKcFhSRm0yZUJhcFMwQS9pMkI2d255OUVENTNjeDNmNkQyRFN2cS9p?=
 =?utf-8?B?S0g4NkVKdXR4WXA4OXhWM2hHM010ZzRVUWh4WmFJVS8rbmlYQzNpc292TFFw?=
 =?utf-8?B?V3h4d0FTcHdGbTMvUllJazlWeGoybmh3aTBhNTlNcTMva21XTUUrNGpoYUp3?=
 =?utf-8?B?dkM1RFB3Y1U3dzQ2TEdhQTg4T29TdmJnY1d1UGNrMUVTVmkwSkpUT1VndFVP?=
 =?utf-8?B?Mk9jWnlYVmI3c3BiK2htWDF1eXpZazNydDJPQkVIdjM2c1dpY25vZnpEV1VE?=
 =?utf-8?B?Q0FTcmtMRlMvNjRHMnJ3NVhld0I3OVpaWDIzejRMaTRnQUFrMFlLVG44M2Yr?=
 =?utf-8?B?WmRrY0hraTF3bGo5ZFJiWkdBV0pBdlVmcHpGRUluVTVVYXZiZ0RWY2lHbVli?=
 =?utf-8?B?NzY1cEVZeWtZOXdHSXZQUTNWQ0ZkVHpDNXFicS92TjdPQ0ZxdG9ENEx6VUNX?=
 =?utf-8?B?ZThoVjU0ZDE2dG54SHA2RWdWcW5EcmRkWitpa3J5OHJDQjJpTVZpM29SUUU0?=
 =?utf-8?B?VEZpMWJzUWNudzNna3RUTDNmYnZOT2NtQTd6TU9DODN1eUxKN0RJQStuSHhj?=
 =?utf-8?B?YlZYSmg5ZTJacmNiZzZEeHZmd3gzbWZnV3BQU3VKMkRjTngwWkN5VSs5MVRP?=
 =?utf-8?B?dnBvNzNpaEJONGZoNDdNUW9JUUpFY0lZcmpteE1USTl6Q1Z3elcxelBoL1dR?=
 =?utf-8?B?QjZteDJCVnBYdEhrUjBSbm55RGM0K005aGQwR3JUbDBmaU9lTDdiOHhXbTky?=
 =?utf-8?B?MUx5MXNWNjdwczNQSS9icEpkazhVVlI2aHk4UldrZW5CYnh4VjlTN29ZTDYx?=
 =?utf-8?B?aFNYME90ZWg4dkx4SEhmakZKSWVwc3lUT0hTUS81aGFNbS8vNVZkR29lcjRp?=
 =?utf-8?B?SGZ1cHlwT0FiTjFYSGNhY3hjbDh2ZXdsUkpwcTZkT09XTzZQU2ViaU1SZVhm?=
 =?utf-8?B?QmFOUjJDU25nQUhrUUV5U0JPQWpLaEp2SkJ6ZlhjS3R0dVgyR1lBRk1ZYWY0?=
 =?utf-8?B?MmZZU2d6S3d4dGY4d1YvVzNvVGxpYW82bXNoS2dENEljQ0NXSkR2TVlVVlpI?=
 =?utf-8?B?SHpGcG5kbDJ0NGJOYTVYZzQ0RUtid2FPeE5FNlE3RmVsd3U3K1IyV0NUdStV?=
 =?utf-8?B?aHhoVTdQZ3ZiVEo0MEt1VGF0SDVSMVNMZXgxSkZYTGRrKzZTYndKR2pCbmFr?=
 =?utf-8?B?NlRwU0JhUEZYWEJOSzRSTVhCWXVlb3JiOVFlZEh5NnlpV1k0cjhmZ2VtL3F4?=
 =?utf-8?B?aXJlckNTZSs3eUp6UHdTcCtUTWE5MUlyVlNyemxHSjdqUlhlZ0tmUDFFckND?=
 =?utf-8?B?WEljWGh1Qk5oSHRMNjIwNFUvejRnV3o3UFpMbVN4QU5KSVpKUERDTUIyTGEx?=
 =?utf-8?B?VERUclV6M1NjNlpCOTNueG85dzd6dnF6SXRpWElacmJjSmVZN2o1VkJjaUxN?=
 =?utf-8?B?SnlWQzdWWCtWL3F6V2lHdWlQZVkrS2c9PQ==?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MEVTUkswelcxNVo4bGlzYS9lUm9GZVFLcHRGRFpWK0l2WW54L0IwalVseFk0?=
 =?utf-8?B?K09pZVZ3S0U1UC9hTUc0bjJQUFNHYVNPQXVaOWJTaGU0Tm5nQkx0QUVhWnlE?=
 =?utf-8?B?MHhuam9ZRWlGYzJic20rZTJ0K0VSWW5UVW1zRVFQcDRTc0N5ak5sN0JsRjhE?=
 =?utf-8?B?UkpoVEo4YzZOOTdLYi9EekxIZXFRTXY4UjV5blZIUUpRZTM2ZXI3ei9vUEl5?=
 =?utf-8?B?cmZVZ1hXQzJ3VUdvd2c4aDlUbTAzWGhNTjNBbVBBVFprSHVHajUzbXhUWFlV?=
 =?utf-8?B?alNMT0UxRFd5aGJpUGRhdHo2Uk9ycG9ReHVXZEYxdytTelR1UDh5NXB2OTJG?=
 =?utf-8?B?UmNwWVBSMkRqRkpkYzd0Y0tYOWpnZTQrUEVRVUw2TjZXMTBJb3hWMExIcFF6?=
 =?utf-8?B?ZUJTdm1nOXBrS1FnZ3lTUUVxWGFPMkh3K0UrVTBCZWN2MnQzWmRMUGpEN1dF?=
 =?utf-8?B?T2lrYUxjZ0tGaFl2cng4VUFSQURDT1JWRnJhaEtCb2NvMTgzSFNyQTJsdWUy?=
 =?utf-8?B?SjEzYmV0STVYSi9qUkpSK3lIWDBPMGdJeTErTittdTNxTFVrOVpVdWVCbmNU?=
 =?utf-8?B?aDE2ZVJ1MnBEcmxQU2EwUFVRN1B3dCs1SXF6eGFSNFE5S0JqZlNhblNidEtM?=
 =?utf-8?B?T2FRUlk2SGFUclpHNXRTNlBDZk5aSFdSZ3JZaDViZDZIYkQyYTRPVEFsazFw?=
 =?utf-8?B?Q3NYb3QwVlZHZjVuVGQvM04rSExrUzZFVU1PczJCd0xxZ2d5dTl6elVoaklU?=
 =?utf-8?B?d0Yya0crQXljY1FkWjJHaEp4U1M1UXNGZHNxU3U5WFhjVDRMR2dkdTJjSlg2?=
 =?utf-8?B?alI0WUhpSVQrUktKY2xwN1RTUDlldmlWMTlFQmFHek0xQjJycmhOUXBVNVRP?=
 =?utf-8?B?dFAwZ080d3d4ZzEvbVlXMEtTakxaOG4wRGxqMHI1anZZbHA5UndMUzRGQ1ZI?=
 =?utf-8?B?VEpiTmJNNGVYZzF2OEdxUDJlNUlId0JnS3hlaEFRbFFaZnVGNkFlQ3JZMHVy?=
 =?utf-8?B?eVBBRVB0ZlFwUFF1ZUc5TC9GbmhUZWd4M1UyNnNZMks0ckpQSzRuNlh2LzBE?=
 =?utf-8?B?QUhDRGtpbmlwNlg0bWRaU1k0QzZFODBDa0ppZGxpUDdMOWxCdll5RnE5dHhX?=
 =?utf-8?B?QjM1S3dOSFowM3hsNzhQVnRKakdWUDE2clgvMlN5OE1VQ2t3SEtPYWdjeGhX?=
 =?utf-8?B?UUJYVUxBc0Y3bmNNRXZnSW5HWlZ1WjBCSG5CSHJ0N283eUhmVVlMaXNtOG02?=
 =?utf-8?B?eXNDRCszV2ZsSjBkZTlWcXpmcEhQQ2FSSFZMS1phbk9OUmFNdHpKTldua0h2?=
 =?utf-8?B?RjBKT01VQW5IblJMdGhsVTdnRXRZQjdZK1dUYS9kZjFBNGtndE04SVdHRGo1?=
 =?utf-8?B?NFFzSCtVOEkycUFzc1UreW1LU2NzQWpqUGJ1UFVFYldJcXJjZWIyUndPRG9I?=
 =?utf-8?B?RVpCQmhPN0FHQWt1cENlblJFZkNMOS9IeXZhNzNDb2RLdXZJY3dMOXpRd2pi?=
 =?utf-8?B?dG1JRzhQSEVjMHpHRk1tYUF0TUt3NCs5ekhVSkVaQXdiVzRBckR4U0owd3Y1?=
 =?utf-8?B?b0tQZHdyM2N5SUxiNkZkekU0WU81K3lGd09aVGkwNUhGRTVFdUVsOU1PR2dE?=
 =?utf-8?Q?v5Ht7RmRh6bDx4iVLn7PjOSzECr0XEYJepUSQ4IclvMw=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: fc7c7c9e-672b-484e-f143-08de233e662b
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2025 05:26:44.1861
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR02MB10657

RnJvbTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+IFNlbnQ6IFRodXJz
ZGF5LCBOb3ZlbWJlciAxMywgMjAyNSAyOjU2IFBNDQo+IA0KDQpBZGRpbmcgTWljcm9zb2Z0J3Mg
TnVubyBEYXMgTmV2ZXMgdG8gdGhlICJUbzoiIGxpbmUgc2luY2UgaGUNCm9yaWdpbmF0ZWQgdGhl
IHdvcmsgdG8ga2VlcCB0aGUgTGludXggaGVhZGVycyBzdWNoIGFzIGh2Z2RrLmggaW4NCnN5bmMg
d2l0aCB0aGUgV2luZG93cyBjb3VudGVycGFydHMgZnJvbSB3aGljaCB0aGV5IG9yaWdpbmF0ZS4N
Cg0KPiBGaXggS1ZNJ3MgbG9uZy1zdGFuZGluZyBidWdneSBoYW5kbGluZyBvZiBTVk0ncyBleGl0
X2NvZGUgYXMgYSAzMi1iaXQNCj4gdmFsdWUuICBQZXIgdGhlIEFQTSBhbmQgWGVuIGNvbW1pdCBk
MWJkMTU3ZmJjICgiQmlnIG1lcmdlIHRoZSBIVk0NCj4gZnVsbC12aXJ0dWFsaXNhdGlvbiBhYnN0
cmFjdGlvbnMuIikgKHdoaWNoIGlzIGFyZ3VhYmx5IG1vcmUgdHJ1c3R3b3J0aHkNCj4gdGhhbiBL
Vk0pLCBvZmZzZXQgMHg3MCBpcyBhIHNpbmdsZSA2NC1iaXQgdmFsdWU6DQo+IA0KPiAgIDA3MGgg
NjM6MCBFWElUQ09ERQ0KPiANCj4gVHJhY2sgZXhpdF9jb2RlIGFzIGEgc2luZ2xlIHU2NCB0byBw
cmV2ZW50IHJlaW50cm9kdWNpbmcgYnVncyB3aGVyZSBLVk0NCj4gbmVnbGVjdHMgdG8gY29ycmVj
dGx5IHNldCBiaXRzIDYzOjMyLg0KPiANCj4gRml4ZXM6IDZhYThiNzMyY2EwMSAoIltQQVRDSF0g
a3ZtOiB1c2Vyc3BhY2UgaW50ZXJmYWNlIikNCj4gQ2M6IEppbSBNYXR0c29uIDxqbWF0dHNvbkBn
b29nbGUuY29tPg0KPiBDYzogWW9zcnkgQWhtZWQgPHlvc3J5LmFobWVkQGxpbnV4LmRldj4NCj4g
U2lnbmVkLW9mZi1ieTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQo+
IC0tLQ0KPiAgYXJjaC94ODYvaW5jbHVkZS9hc20vc3ZtLmggICAgICB8ICAzICstLQ0KPiAgYXJj
aC94ODYvaW5jbHVkZS91YXBpL2FzbS9zdm0uaCB8IDMyICsrKysrKysrKysrKysrLS0tLS0tLS0t
LS0tLS0tDQo+ICBhcmNoL3g4Ni9rdm0vc3ZtL2h5cGVydi5jICAgICAgIHwgIDEgLQ0KPiAgYXJj
aC94ODYva3ZtL3N2bS9uZXN0ZWQuYyAgICAgICB8IDEzICsrKy0tLS0tLS0tLQ0KPiAgYXJjaC94
ODYva3ZtL3N2bS9zZXYuYyAgICAgICAgICB8IDM2ICsrKysrKysrKysrLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLQ0KPiAgYXJjaC94ODYva3ZtL3N2bS9zdm0uYyAgICAgICAgICB8ICA3ICsrLS0tLS0N
Cj4gIGFyY2gveDg2L2t2bS9zdm0vc3ZtLmggICAgICAgICAgfCAgNCArLS0tDQo+ICBhcmNoL3g4
Ni9rdm0vdHJhY2UuaCAgICAgICAgICAgIHwgIDIgKy0NCj4gIGluY2x1ZGUvaHlwZXJ2L2h2Z2Rr
LmggICAgICAgICAgfCAgMiArLQ0KPiAgOSBmaWxlcyBjaGFuZ2VkLCAzNyBpbnNlcnRpb25zKCsp
LCA2MyBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2Fz
bS9zdm0uaCBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3N2bS5oDQo+IGluZGV4IGU2OWI2ZDBkZWRj
Zi4uNjZiMjJjZmZlZGZjIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9zdm0u
aA0KPiArKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9zdm0uaA0KPiBAQCAtMTM2LDggKzEzNiw3
IEBAIHN0cnVjdCBfX2F0dHJpYnV0ZV9fICgoX19wYWNrZWRfXykpIHZtY2JfY29udHJvbF9hcmVh
IHsNCj4gIAl1MzIgaW50X3ZlY3RvcjsNCj4gIAl1MzIgaW50X3N0YXRlOw0KPiAgCXU4IHJlc2Vy
dmVkXzNbNF07DQo+IC0JdTMyIGV4aXRfY29kZTsNCj4gLQl1MzIgZXhpdF9jb2RlX2hpOw0KPiAr
CXU2NCBleGl0X2NvZGU7DQo+ICAJdTY0IGV4aXRfaW5mb18xOw0KPiAgCXU2NCBleGl0X2luZm9f
MjsNCj4gIAl1MzIgZXhpdF9pbnRfaW5mbzsNCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1
ZGUvdWFwaS9hc20vc3ZtLmggYi9hcmNoL3g4Ni9pbmNsdWRlL3VhcGkvYXNtL3N2bS5oDQo+IGlu
ZGV4IDY1MGUzMjU2ZWE3ZC4uMDEwYTQ1YzlmNjE0IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9p
bmNsdWRlL3VhcGkvYXNtL3N2bS5oDQo+ICsrKyBiL2FyY2gveDg2L2luY2x1ZGUvdWFwaS9hc20v
c3ZtLmgNCj4gQEAgLTEwMywzOCArMTAzLDM4IEBADQo+ICAjZGVmaW5lIFNWTV9FWElUX1ZNR0VY
SVQgICAgICAgMHg0MDMNCj4gDQo+ICAvKiBTRVYtRVMgc29mdHdhcmUtZGVmaW5lZCBWTUdFWElU
IGV2ZW50cyAqLw0KPiAtI2RlZmluZSBTVk1fVk1HRVhJVF9NTUlPX1JFQUQJCQkweDgwMDAwMDAx
DQo+IC0jZGVmaW5lIFNWTV9WTUdFWElUX01NSU9fV1JJVEUJCQkweDgwMDAwMDAyDQo+IC0jZGVm
aW5lIFNWTV9WTUdFWElUX05NSV9DT01QTEVURQkJMHg4MDAwMDAwMw0KPiAtI2RlZmluZSBTVk1f
Vk1HRVhJVF9BUF9ITFRfTE9PUAkJCTB4ODAwMDAwMDQNCj4gLSNkZWZpbmUgU1ZNX1ZNR0VYSVRf
QVBfSlVNUF9UQUJMRQkJMHg4MDAwMDAwNQ0KPiArI2RlZmluZSBTVk1fVk1HRVhJVF9NTUlPX1JF
QUQJCQkweDgwMDAwMDAxdWxsDQo+ICsjZGVmaW5lIFNWTV9WTUdFWElUX01NSU9fV1JJVEUJCQkw
eDgwMDAwMDAydWxsDQo+ICsjZGVmaW5lIFNWTV9WTUdFWElUX05NSV9DT01QTEVURQkJMHg4MDAw
MDAwM3VsbA0KPiArI2RlZmluZSBTVk1fVk1HRVhJVF9BUF9ITFRfTE9PUAkJCTB4ODAwMDAwMDR1
bGwNCj4gKyNkZWZpbmUgU1ZNX1ZNR0VYSVRfQVBfSlVNUF9UQUJMRQkJMHg4MDAwMDAwNXVsbA0K
PiAgI2RlZmluZSBTVk1fVk1HRVhJVF9TRVRfQVBfSlVNUF9UQUJMRQkJMA0KPiAgI2RlZmluZSBT
Vk1fVk1HRVhJVF9HRVRfQVBfSlVNUF9UQUJMRQkJMQ0KPiAtI2RlZmluZSBTVk1fVk1HRVhJVF9Q
U0MJCQkJMHg4MDAwMDAxMA0KPiAtI2RlZmluZSBTVk1fVk1HRVhJVF9HVUVTVF9SRVFVRVNUCQkw
eDgwMDAwMDExDQo+IC0jZGVmaW5lIFNWTV9WTUdFWElUX0VYVF9HVUVTVF9SRVFVRVNUCQkweDgw
MDAwMDEyDQo+IC0jZGVmaW5lIFNWTV9WTUdFWElUX0FQX0NSRUFUSU9OCQkJMHg4MDAwMDAxMw0K
PiArI2RlZmluZSBTVk1fVk1HRVhJVF9QU0MJCQkJMHg4MDAwMDAxMHVsbA0KPiArI2RlZmluZSBT
Vk1fVk1HRVhJVF9HVUVTVF9SRVFVRVNUCQkweDgwMDAwMDExdWxsDQo+ICsjZGVmaW5lIFNWTV9W
TUdFWElUX0VYVF9HVUVTVF9SRVFVRVNUCQkweDgwMDAwMDEydWxsDQo+ICsjZGVmaW5lIFNWTV9W
TUdFWElUX0FQX0NSRUFUSU9OCQkJMHg4MDAwMDAxM3VsbA0KPiAgI2RlZmluZSBTVk1fVk1HRVhJ
VF9BUF9DUkVBVEVfT05fSU5JVAkJMA0KPiAgI2RlZmluZSBTVk1fVk1HRVhJVF9BUF9DUkVBVEUJ
CQkxDQo+ICAjZGVmaW5lIFNWTV9WTUdFWElUX0FQX0RFU1RST1kJCQkyDQo+IC0jZGVmaW5lIFNW
TV9WTUdFWElUX1NOUF9SVU5fVk1QTAkJMHg4MDAwMDAxOA0KPiAtI2RlZmluZSBTVk1fVk1HRVhJ
VF9TQVZJQwkJCTB4ODAwMDAwMWENCj4gKyNkZWZpbmUgU1ZNX1ZNR0VYSVRfU05QX1JVTl9WTVBM
CQkweDgwMDAwMDE4dWxsDQo+ICsjZGVmaW5lIFNWTV9WTUdFWElUX1NBVklDCQkJMHg4MDAwMDAx
YXVsbA0KPiAgI2RlZmluZSBTVk1fVk1HRVhJVF9TQVZJQ19SRUdJU1RFUl9HUEEJCTANCj4gICNk
ZWZpbmUgU1ZNX1ZNR0VYSVRfU0FWSUNfVU5SRUdJU1RFUl9HUEEJMQ0KPiAgI2RlZmluZSBTVk1f
Vk1HRVhJVF9TQVZJQ19TRUxGX0dQQQkJfjBVTEwNCj4gLSNkZWZpbmUgU1ZNX1ZNR0VYSVRfSFZf
RkVBVFVSRVMJCQkweDgwMDBmZmZkDQo+IC0jZGVmaW5lIFNWTV9WTUdFWElUX1RFUk1fUkVRVUVT
VAkJMHg4MDAwZmZmZQ0KPiArI2RlZmluZSBTVk1fVk1HRVhJVF9IVl9GRUFUVVJFUwkJCTB4ODAw
MGZmZmR1bGwNCj4gKyNkZWZpbmUgU1ZNX1ZNR0VYSVRfVEVSTV9SRVFVRVNUCQkweDgwMDBmZmZl
dWxsDQo+ICAjZGVmaW5lIFNWTV9WTUdFWElUX1RFUk1fUkVBU09OKHJlYXNvbl9zZXQsIHJlYXNv
bl9jb2RlKQlcDQo+ICAJLyogU1dfRVhJVElORk8xWzM6MF0gKi8JCQkJCVwNCj4gIAkoKCgoKHU2
NClyZWFzb25fc2V0KSAmIDB4ZikpIHwJCQkJXA0KPiAgCS8qIFNXX0VYSVRJTkZPMVsxMTo0XSAq
LwkJCQlcDQo+ICAJKCgoKHU2NClyZWFzb25fY29kZSkgJiAweGZmKSA8PCA0KSkNCj4gLSNkZWZp
bmUgU1ZNX1ZNR0VYSVRfVU5TVVBQT1JURURfRVZFTlQJCTB4ODAwMGZmZmYNCj4gKyNkZWZpbmUg
U1ZNX1ZNR0VYSVRfVU5TVVBQT1JURURfRVZFTlQJCTB4ODAwMGZmZmZ1bGwNCj4gDQo+ICAvKiBF
eGl0IGNvZGUgcmVzZXJ2ZWQgZm9yIGh5cGVydmlzb3Ivc29mdHdhcmUgdXNlICovDQo+IC0jZGVm
aW5lIFNWTV9FWElUX1NXCQkJCTB4ZjAwMDAwMDANCj4gKyNkZWZpbmUgU1ZNX0VYSVRfU1cJCQkJ
MHhmMDAwMDAwMHVsbA0KPiANCj4gLSNkZWZpbmUgU1ZNX0VYSVRfRVJSICAgICAgICAgICAtMQ0K
PiArI2RlZmluZSBTVk1fRVhJVF9FUlIgICAgICAgICAgIC0xdWxsDQo+IA0KDQpbc25pcF0NCg0K
PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9oeXBlcnYvaHZnZGsuaCBiL2luY2x1ZGUvaHlwZXJ2L2h2
Z2RrLmgNCj4gaW5kZXggZGQ2ZDQ5MzllYTI5Li41NmI2OTU4NzNhNzIgMTAwNjQ0DQo+IC0tLSBh
L2luY2x1ZGUvaHlwZXJ2L2h2Z2RrLmgNCj4gKysrIGIvaW5jbHVkZS9oeXBlcnYvaHZnZGsuaA0K
PiBAQCAtMjgxLDcgKzI4MSw3IEBAIHN0cnVjdCBodl92bWNiX2VubGlnaHRlbm1lbnRzIHsNCj4g
ICNkZWZpbmUgSFZfVk1DQl9ORVNURURfRU5MSUdIVEVOTUVOVFMJCTMxDQo+IA0KPiAgLyogU3lu
dGhldGljIFZNLUV4aXQgKi8NCj4gLSNkZWZpbmUgSFZfU1ZNX0VYSVRDT0RFX0VOTAkJCTB4ZjAw
MDAwMDANCj4gKyNkZWZpbmUgSFZfU1ZNX0VYSVRDT0RFX0VOTAkJCTB4ZjAwMDAwMDB1DQoNCklz
IHRoZXJlIGEgcmVhc29uIGZvciBtYWtpbmcgdGhpcyBIeXBlci1WIGNvZGUganVzdCAidSIsIHdo
aWxlDQptYWtpbmcgdGhlIFNWTV9WTUdFWElUXyogdmFsdWVzICJ1bGwiPyBJIGRvbid0IHRoaW5r
DQoidSIgdnMuICJ1bGwiIHNob3VsZG4ndCBtYWtlIGFueSBkaWZmZXJlbmNlIHdoZW4gYXNzaWdu
aW5nIHRvIGENCnU2NCwgYnV0IHRoZSBpbmNvbnNpc3RlbmN5IHBpcXVlZCBteSBpbnRlcmVzdCAu
Li4uDQoNCk1pY2hhZWwNCg==

