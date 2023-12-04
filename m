Return-Path: <kvm+bounces-3302-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BAB82802D9C
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 09:53:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB2791F2111B
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 08:53:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E458FC03;
	Mon,  4 Dec 2023 08:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kOdoAHeO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2086.outbound.protection.outlook.com [40.107.93.86])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E13A4;
	Mon,  4 Dec 2023 00:53:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QZv0HFwmNONvyljNG8RlF/L1As3o5RyjvF2MCXq/IHyZ1JMQ+F4RBQrKIdaef6oqDMn/adDYyBi5ci/QtEJnQAtUj1N/xdCV8GHaSLtKP/0FsZMaRg/GYqKJmH9Hfx20u/gWWv1zsfCRH9IxY0Ho1r0JrzwVvl5CyaoFI/gEefMvUGkTNCsLIhBivBHr9gE87Yjwkof9YSeDjiTtm4asIzbYFQw0I1Jxr+jNMUD1W9wB+hSDhW9vjAcVvFndXm/8toceGo6eQdcN6AuhhNfP9mIWkFsG49IFroYvWASZ4XKOdK4eulA0AGG4sRw/jkPtZIXwfuDZInXHX+VYuZPd4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EElg9TsShd+avpS21OKVEltkPhxI8O3ifQKHJNAn1JI=;
 b=GybcswYP0vp5Q3ZA7x7Ao9dRyQlPQ6xeuYFpdnT3zLbsQQF6P5C9xl/ILlEFQafUe3jlR2ZVzWDkL+wwJTYd71aPzdN3YSsZc6HkUE4dwH3daXtyG3LC+TCdECgTmGKs8T4tzcR6IfK0USy1oFaLOwWgaryPN5b4PK+g+XV2wjFTXSHVHb7CfK+scAlq7X+WqBPi68MRXWmD87qZGL8w6UklpxVhj+KrNePPlu1LnkKsUL+Rn1e2k8xZgHzuNbSx/NJnZh2Gb+jeJG1jVz1r1aC0M96KIm1s24UCNdF+euN2pJcEei/EoeK7Ki8GsWkCaJqjbcZKv8jz2MgY9dMmDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EElg9TsShd+avpS21OKVEltkPhxI8O3ifQKHJNAn1JI=;
 b=kOdoAHeOVlsPHBNrxcB0lx/POdnTHw2YUjvofAiBpZwMP0TUv0RPeRIeIbdE+Gt17TxRPYu0LwaUA8T0PE3voMqoO6d/tiq0rLcqFySl5Ovoo6euuuiEOKD5kMYG8o081Q6ooGmSHgMpizStV/oqIW0VytpGEBk9WBuPRPdbXAldLoH2oS+9p+jJmyrBs8xqzGE7ng4QXweSVVEshYT6JVILlstQ5za/iZHFf2Y1/0S5+UppIAsDjvgnPaAm/VjInLpZsZHWQQikkM+dHnx4ZRI4R2UT9/RlY6rsCzDLluarYahE+Gb+ijygpIO/QQANNmcvZNrceH8XtgtQLoaLxA==
Received: from DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13)
 by MW4PR12MB5641.namprd12.prod.outlook.com (2603:10b6:303:186::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.33; Mon, 4 Dec
 2023 08:53:26 +0000
Received: from DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258]) by DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258%5]) with mapi id 15.20.7046.033; Mon, 4 Dec 2023
 08:53:26 +0000
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "mst@redhat.com" <mst@redhat.com>
CC: "xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>, Parav Pandit
	<parav@nvidia.com>, "virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "eperezma@redhat.com"
	<eperezma@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "si-wei.liu@oracle.com"
	<si-wei.liu@oracle.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"jasowang@redhat.com" <jasowang@redhat.com>, Saeed Mahameed
	<saeedm@nvidia.com>, "galp@nvidia.com" <galp@nvidia.com>, "leon@kernel.org"
	<leon@kernel.org>
Subject: Re: [PATCH vhost 0/7] vdpa/mlx5: Add support for resumable vqs
Thread-Topic: [PATCH vhost 0/7] vdpa/mlx5: Add support for resumable vqs
Thread-Index: AQHaJEQPCu8G+as30EOn77AjCdP4t7CWcwSAgAE9GACAABGOAIABFHyA
Date: Mon, 4 Dec 2023 08:53:26 +0000
Message-ID: <e088b2ac7a197352429d2f5382848907f98c1129.camel@nvidia.com>
References: <20231201104857.665737-1-dtatulea@nvidia.com>
	 <20231202152523-mutt-send-email-mst@kernel.org>
	 <aff0361edcb0fd0c384bf297e71d25fb77570e15.camel@nvidia.com>
	 <20231203112324-mutt-send-email-mst@kernel.org>
In-Reply-To: <20231203112324-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.1 (3.50.1-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB5565:EE_|MW4PR12MB5641:EE_
x-ms-office365-filtering-correlation-id: e5736ed1-f3ec-4602-9a84-08dbf4a67a99
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 x4x+nXGSsMEvMCC7oE66jMtQaXucYCa1U1MY6mKGg5NouuywSgLqWwtm3NtQZ49T8fOPjElNTButBA4svZBG7+gF5CpM7Ch8xRcsVI3VLJiA6sjsghHc/5+g+o1UKLQeerl8JHrDJf0CiZ4BgYODfULt0FneVqiYdNXqbjaYdtg79BBQpZGaHqlRXwRv0veYWtJwg0y9KgAPEXG8K9lj8bpZ08g9i38t7/g1gDPQdSOWbrlUgC8l3To55nOjEcTOG5wzuMGB2+fDhDsBE982PR1aoGv1d4Jz2630EoBCBWcrDXbxxdY8wTP6CDSHEFEDJjuEipGRnk/lGAjsztrB3utTXwq9qemGkrpVECjUB/cd/CqL6f16Cu+3qiVMoNIcutM/UG8Mm8a2XM2N4rPDCsugvoyl0pbFPnlUqsPZDLTJGIt67SlPQUlnTsjxUMjmg0WNyX/Cc5yf2sjbMgXDNtkHX8VtdIIZ05AtyCee/GJLIu1oSYZUagJXZq3BWLL2RnD/1Uo4MqkDmR52+TfxrY+aHFK9hiDdC+1uQw1mEsf/MSmQCzE3Y+/8Z0/K1GLTP7Nqz+m3ookYXCoVlvBoZOLzJ/W8XO/sFuR0I2ZUyUuzQ9XgbkjKOBFBKcoKLf1ucoS0jkyZZnfNjyUkYcIyTkF6uyBp7tCZR5ZlW5z3Xrg=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5565.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(396003)(39860400002)(366004)(136003)(230922051799003)(64100799003)(1800799012)(186009)(451199024)(38070700009)(38100700002)(122000001)(2906002)(5660300002)(6512007)(83380400001)(6506007)(71200400001)(2616005)(76116006)(91956017)(478600001)(966005)(6486002)(36756003)(41300700001)(54906003)(64756008)(66446008)(66556008)(6916009)(316002)(66946007)(4326008)(8676002)(8936002)(66476007)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Um1nb2prM0FmWTdNaUJjRHNCTVNUZVczNkpveDBCS3pPNzlmWEVDMmZGUGZB?=
 =?utf-8?B?NE11ekZ6dHdWWVZTRUZ5QklDV09acmdNR1Jhek9oT0x2ZGhVRTRBcTNUQWl5?=
 =?utf-8?B?T0ovMXpEcXJucHVSV00wTGh4N1MwK1F6MmhSUHhpY0N4UDA5SFZkTUhKWDBi?=
 =?utf-8?B?eHNKd25wRUsybTc2dkMzTHF5NUhWcG1OS0tLYXYvUmVndEN4K3BnZVY5cUFh?=
 =?utf-8?B?c1hzbGgya0F4MEJxRHNzU0dMRm5XWStXTy9JLzgwRnFHczVscVlqNGM5bGFh?=
 =?utf-8?B?L2M2Q0xwKzYzbURlSDNMM1F0T0daQ3RuYUhObUZWM24xYVJqVFhHeEo1a1R0?=
 =?utf-8?B?QVdVRXExZjNBWXVyVE1zeTlGVVVJT0hTZ2gybTJRRzlxVCtRUERuNCtuV2RM?=
 =?utf-8?B?Qmg5NHRteU5hbWozSHRNMU5Yd3krQzRvaHlCUW82czJKZmYxQmxaZmorbTh0?=
 =?utf-8?B?S2R1YkptWFZnYnNOd3I4WXVMNWNkZ0ZZUk1lZDYzRjA1WmNnQk5naFdWYXpP?=
 =?utf-8?B?eGx2TW1WemwxNDNwbm9qOUZ4dldiOFV5NjNSTHljamo5RUhvdWNYbWFIY0RX?=
 =?utf-8?B?WE05YnJzVWtEOVFrbW5uMGRuVWFtYlUvSmQ2Z3NYd3VhRC8xUFJwZW9zSitK?=
 =?utf-8?B?RHVTR1g3MVZSUDVPNnc0cGpFczJHUzhVWGZ5elJtZE40d1pEMXZUUVJ1dFJ2?=
 =?utf-8?B?bTlIcytkTTdXRkk5QUZLNmgrU3Jxa0lBTlZhU0hBWkp4QlljYnJORkhqRUJv?=
 =?utf-8?B?Q3paR1VEVzUvRll4UnJqaXg2UHNYL1BwNFBFRDhuOVVQMjBOZS8yOXo2dFBO?=
 =?utf-8?B?anNOUnVEYTAyeE8yZ0xMb3BzYjJXbXVETVlFZnYwTnJRamF5T3Qvdkh0WFpi?=
 =?utf-8?B?N1hZUkR2VXB1cjBFTEFJNEMwekZKZ29TOWtOejBlelVzbWRxdENFWlN3MnZh?=
 =?utf-8?B?eDRubk9OdlN6ZHJSb3QzREJkbWJEdEl6SStGczFsWndzQWRPYlV0WmlKOXR3?=
 =?utf-8?B?c3N4VnR0Z3dKWDVWcDk5RDNJRHZpUE9hTWQ1SGJOdC9mLzFqZVV6TUt2U2dP?=
 =?utf-8?B?d092RjFRYWNERjlpV3c2OWJjTzVkdzRoV1plNHNTSjJmdEVYK1pBazRYUFhB?=
 =?utf-8?B?UUtBRUtvTUZ6QWF6bjRUc0FhWldObm5iQW9pV1EvaXRzNkJEU0VteUYxcjVO?=
 =?utf-8?B?YzhBb0F5bTg0S3JtZlE5STVQSHFTVE56d2xDSCtySHNhU1pyZENydUs1elhJ?=
 =?utf-8?B?eVdRNFh6eGpqNEpWOXlsTS9zZXZZRXd6WEtIZitzekh6U05wUjBKV21kUVIr?=
 =?utf-8?B?TU96R2loai9Gc0x3KzZ5a0R2OHE5VWZYSXpQTHBjRERUR2pUTzZUdEUvbitW?=
 =?utf-8?B?SUprMnA2MHhIeVl5eHpLa01SSkRQSlZBcG5KdmVkRWJ1YlZOOHNnc0hTU1ow?=
 =?utf-8?B?OU9RaEM5V2Juc2RjKzBBcFFaTFVhWlJ1R1BTTzBydDB1WUhRWUN6TEVhaXpF?=
 =?utf-8?B?STNidGpKL25WQkJ4SU84YWs2eGh3cXB2UVVtYWQwbE5ncTR2dHY4djJPWUcv?=
 =?utf-8?B?NVFNUFlTbUtlTE40QXRRakFHdlpWNUpidkRmU0YvNXVhbDJ3TFBzbDJPbm13?=
 =?utf-8?B?OHdOWFEzaFNBRHIzL3FoMXNQVTA5MXp3OW5COForeGFXSXNOV0Z1Nk4xM2dt?=
 =?utf-8?B?VkcwaUZlRWh6MEwzVlBTZUt4eW5NNjNpbUhOSWtBUDcrNVBiZldkaTNxN2wv?=
 =?utf-8?B?eXlmSVNTQ2VPeVorNnRzajY5T0RVMmhGWXhjb1M5NVh2ZENUb2hGekliTHpX?=
 =?utf-8?B?ckgweXl2VUlJeDhlM1VNK2RNUFV3a1psalNKcE45aWlwbEpVbS9lNTVOem5W?=
 =?utf-8?B?a3NwK05wNkNXcnI0TnVDSGttOUxxK3k2cjBhNVYvZjVlc1JFVFVBZWl3UFFr?=
 =?utf-8?B?K0JKcFJxZTJjVy9PQlZEd3FSdUxWUE1jU3Npa3lKQmFYWldCZzV5ME95S1lH?=
 =?utf-8?B?cDYyVkZ5OFVCU242OExvZ0sxZXRRU2YrMTVlczBGb2QwRGEyNTRWZXI5WlJr?=
 =?utf-8?B?OGtTc2FnWEJmYW9RTUxIVVAvcUpoVSt5NUhxMUZ5dHRuNHBtSDVJV1Z5QlI0?=
 =?utf-8?B?NXkxUHFUR3NrN3VmRDRCcTRBWEJLTytaWGwwZ1k5b21qRkYyZEdnSmFoUFJQ?=
 =?utf-8?Q?GugXZgGQJqepswJ5SlRzXpeDNVNccDKmaZ7Mae7aKaDL?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C0FF17F833DDAF4C89A2361452EE6821@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5565.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5736ed1-f3ec-4602-9a84-08dbf4a67a99
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2023 08:53:26.1318
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1CkJDu9JPyJKsYJlz65mV/+ZmM4WCt3DXzlFDoAV77exf/d2FQ9/BNkUa51ZhDmf5jDAYkM6R+eiYSbblJdbYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5641

T24gU3VuLCAyMDIzLTEyLTAzIGF0IDExOjIzIC0wNTAwLCBNaWNoYWVsIFMuIFRzaXJraW4gd3Jv
dGU6DQo+IE9uIFN1biwgRGVjIDAzLCAyMDIzIGF0IDAzOjIxOjAxUE0gKzAwMDAsIERyYWdvcyBU
YXR1bGVhIHdyb3RlOg0KPiA+IE9uIFNhdCwgMjAyMy0xMi0wMiBhdCAxNToyNiAtMDUwMCwgTWlj
aGFlbCBTLiBUc2lya2luIHdyb3RlOg0KPiA+ID4gT24gRnJpLCBEZWMgMDEsIDIwMjMgYXQgMTI6
NDg6NTBQTSArMDIwMCwgRHJhZ29zIFRhdHVsZWEgd3JvdGU6DQo+ID4gPiA+IEFkZCBzdXBwb3J0
IGZvciByZXN1bWFibGUgdnFzIGluIHRoZSBkcml2ZXIuIFRoaXMgaXMgYSBmaXJtd2FyZSBmZWF0
dXJlDQo+ID4gPiA+IHRoYXQgY2FuIGJlIHVzZWQgZm9yIHRoZSBmb2xsb3dpbmcgYmVuZWZpdHM6
DQo+ID4gPiA+IC0gRnVsbCBkZXZpY2UgLnN1c3BlbmQvLnJlc3VtZS4NCj4gPiA+ID4gLSAuc2V0
X21hcCBkb2Vzbid0IG5lZWQgdG8gZGVzdHJveSBhbmQgY3JlYXRlIG5ldyB2cXMgYW55bW9yZSBq
dXN0IHRvDQo+ID4gPiA+ICAgdXBkYXRlIHRoZSBtYXAuIFdoZW4gcmVzdW1hYmxlIHZxcyBhcmUg
c3VwcG9ydGVkIGl0IGlzIGVub3VnaCB0bw0KPiA+ID4gPiAgIHN1c3BlbmQgdGhlIHZxcywgc2V0
IHRoZSBuZXcgbWFwcywgYW5kIHRoZW4gcmVzdW1lIHRoZSB2cXMuDQo+ID4gPiA+IA0KPiA+ID4g
PiBUaGUgZmlyc3QgcGF0Y2ggZXhwb3NlcyB0aGUgcmVsZXZhbnQgYml0cyBpbiBtbHg1X2lmYy5o
LiBUaGF0IG1lYW5zIGl0DQo+ID4gPiA+IG5lZWRzIHRvIGJlIGFwcGxpZWQgdG8gdGhlIG1seDUt
dmhvc3QgdHJlZSBbMF0gZmlyc3QuDQo+ID4gPiANCj4gPiA+IEkgZGlkbid0IGdldCB0aGlzLiBX
aHkgZG9lcyB0aGlzIG5lZWQgdG8gZ28gdGhyb3VnaCB0aGF0IHRyZWU/DQo+ID4gPiBJcyB0aGVy
ZSBhIGRlcGVuZGVuY3kgb24gc29tZSBvdGhlciBjb21taXQgZnJvbSB0aGF0IHRyZWU/DQo+ID4g
PiANCj4gPiBUbyBhdm9pZCBtZXJnZSBpc3N1ZXMgaW4gTGludXMncyB0cmVlIGluIG1seDVfaWZj
LmguIFRoZSBpZGVhIGlzIHRoZSBzYW1lIGFzIGZvcg0KPiA+IHRoZSAidnEgZGVzY3JpcHRvciBt
YXBwaW5ncyIgcGF0Y2hzZXQgWzFdLg0KPiA+IA0KPiA+IFRoYW5rcywNCj4gPiBEcmFnb3MNCj4g
DQo+IEFyZSB0aGVyZSBvdGhlciBjaGFuZ2VzIGluIHRoYXQgYXJlYSB0aGF0IHdpbGwgY2F1c2Ug
bm9uLXRyaXZpYWwgbWVyZ2UNCj4gY29uZmxpY3RzPw0KPiANClRoZXJlIGFyZSBwZW5kaW5nIGNo
YW5nZXMgaW4gbWx4NV9pZmMuaCBmb3IgbmV0LW5leHQuIEkgaGF2ZW4ndCBzZWVuIGFueSBjaGFu
Z2VzDQphcm91bmQgdGhlIHRvdWNoZWQgc3RydWN0dXJlIGJ1dCBJIHdvdWxkIHByZWZlciBub3Qg
dG8gdGFrZSBhbnkgcmlzay4NCg0KVGhhbmtzLA0KRHJhZ29zDQoNCj4gPiA+ID4gT25jZSBhcHBs
aWVkDQo+ID4gPiA+IHRoZXJlLCB0aGUgY2hhbmdlIGhhcyB0byBiZSBwdWxsZWQgZnJvbSBtbHg1
LXZob3N0IGludG8gdGhlIHZob3N0IHRyZWUNCj4gPiA+ID4gYW5kIG9ubHkgdGhlbiB0aGUgcmVt
YWluaW5nIHBhdGNoZXMgY2FuIGJlIGFwcGxpZWQuIFNhbWUgZmxvdyBhcyB0aGUgdnENCj4gPiA+
ID4gZGVzY3JpcHRvciBtYXBwaW5ncyBwYXRjaHNldCBbMV0uDQo+ID4gPiA+IA0KPiA+ID4gPiBU
byBiZSBhYmxlIHRvIHVzZSByZXN1bWFibGUgdnFzIHByb3Blcmx5LCBzdXBwb3J0IGZvciBzZWxl
Y3RpdmVseSBtb2RpZnlpbmcNCj4gPiA+ID4gdnEgcGFyYW1ldGVycyB3YXMgbmVlZGVkLiBUaGlz
IGlzIHdoYXQgdGhlIG1pZGRsZSBwYXJ0IG9mIHRoZSBzZXJpZXMNCj4gPiA+ID4gY29uc2lzdHMg
b2YuDQo+ID4gPiA+IA0KPiA+ID4gPiBbMF0gaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2Nt
L2xpbnV4L2tlcm5lbC9naXQvbWVsbGFub3gvbGludXguZ2l0L2xvZy8/aD1tbHg1LXZob3N0DQo+
ID4gPiA+IFsxXSBodHRwczovL2xvcmUua2VybmVsLm9yZy92aXJ0dWFsaXphdGlvbi8yMDIzMTAx
ODE3MTQ1Ni4xNjI0MDMwLTItZHRhdHVsZWFAbnZpZGlhLmNvbS8NCj4gPiA+ID4gDQo+ID4gPiA+
IERyYWdvcyBUYXR1bGVhICg3KToNCj4gPiA+ID4gICB2ZHBhL21seDU6IEV4cG9zZSByZXN1bWFi
bGUgdnEgY2FwYWJpbGl0eQ0KPiA+ID4gPiAgIHZkcGEvbWx4NTogU3BsaXQgZnVuY3Rpb24gaW50
byBsb2NrZWQgYW5kIHVubG9ja2VkIHZhcmlhbnRzDQo+ID4gPiA+ICAgdmRwYS9tbHg1OiBBbGxv
dyBtb2RpZnlpbmcgbXVsdGlwbGUgdnEgZmllbGRzIGluIG9uZSBtb2RpZnkgY29tbWFuZA0KPiA+
ID4gPiAgIHZkcGEvbWx4NTogSW50cm9kdWNlIHBlciB2cSBhbmQgZGV2aWNlIHJlc3VtZQ0KPiA+
ID4gPiAgIHZkcGEvbWx4NTogTWFyayB2cSBhZGRycyBmb3IgbW9kaWZpY2F0aW9uIGluIGh3IHZx
DQo+ID4gPiA+ICAgdmRwYS9tbHg1OiBNYXJrIHZxIHN0YXRlIGZvciBtb2RpZmljYXRpb24gaW4g
aHcgdnENCj4gPiA+ID4gICB2ZHBhL21seDU6IFVzZSB2cSBzdXNwZW5kL3Jlc3VtZSBkdXJpbmcg
LnNldF9tYXANCj4gPiA+ID4gDQo+ID4gPiA+ICBkcml2ZXJzL3ZkcGEvbWx4NS9jb3JlL21yLmMg
ICAgICAgIHwgIDMxICsrKy0tLQ0KPiA+ID4gPiAgZHJpdmVycy92ZHBhL21seDUvbmV0L21seDVf
dm5ldC5jICB8IDE3MiArKysrKysrKysrKysrKysrKysrKysrKysrLS0tLQ0KPiA+ID4gPiAgaW5j
bHVkZS9saW51eC9tbHg1L21seDVfaWZjLmggICAgICB8ICAgMyArLQ0KPiA+ID4gPiAgaW5jbHVk
ZS9saW51eC9tbHg1L21seDVfaWZjX3ZkcGEuaCB8ICAgNCArDQo+ID4gPiA+ICA0IGZpbGVzIGNo
YW5nZWQsIDE3NCBpbnNlcnRpb25zKCspLCAzNiBkZWxldGlvbnMoLSkNCj4gPiA+ID4gDQo+ID4g
PiA+IC0tIA0KPiA+ID4gPiAyLjQyLjANCj4gPiA+IA0KPiA+IA0KPiANCg0K

