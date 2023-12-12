Return-Path: <kvm+bounces-4233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0794A80F719
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 20:44:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1664282060
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 19:44:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BFF363589;
	Tue, 12 Dec 2023 19:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Kdv7SYP1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2050.outbound.protection.outlook.com [40.107.102.50])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 260A49C;
	Tue, 12 Dec 2023 11:44:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Aryd77CV1636k1PmJkonFhgOzFHEV8hJ8d8aCd/7BIISJRJ6Z7G3o2g9QHv1Oe02dA79PiRbJM9uVOEH+DZCiif1VIHjlwy+XL/ADnb0de3FL78feXM1+cWu0Vc2JtLNtpQS8z6sVq04dnZSAh4+gMbp6L1hcSs4iAdPaXQX6FxZVDWrJAE7LyZwG4qgKrBcO5ux84kqft14X8PdE0GalxOKU4BOawAZe2gOfYz1IImCAykt825ksVRF/Pxu4plmZoipTjOvWFnHfUuBTGfPJdXdx1if0SEWcScy86fpsSggT1lpkJsKgDRebKdaIzqGsrrZhs0LSjDidrTuPtEBBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YokdHGPCK0aJJzld6E/LOqWBz1AXXqpZoBRs9hUCejw=;
 b=XaLYaCs8XOfT/aNLKQZ/PQ+jdUIwAeOYwVmypgSCyzcRB8RI3U9UW9EnG+sp1DL2dhsGtKQQ5usJqivHL3+p+psSlOI69WdJIcaHy/xVeUdtBeuTxxnFvqaQJMdrO/6szFax+GApsNc8q/fidtOWnxWsrVP51PD2qcEE4p98HFhXpbvz8KeoCQQRAzXobmb5HpdK0HUttzQSqDUMUj7zlO2z5Y47FkCwjcIIwjsl+Q4+s1Y+rzWLpDAq76dtiy+e96WX/5Ov3zRxUbtLtSRYvg9+DgukF7TleufY3O+cx87DfaxXgdpq5SFZhHYfG7RFdoiDGYuVvtQCjokiJUCnAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YokdHGPCK0aJJzld6E/LOqWBz1AXXqpZoBRs9hUCejw=;
 b=Kdv7SYP1hf8bbyHa20zgRwWyuklWEmGSRxPYK+9p4fN9v91V7RCWjaYT2GOu3IkSabp1GcrB93Dg40la9+mggRv9FFNZ30Jm7O0AIBKrUfdBNZzOu5W5gfSMjNlDRyPhGdvUuPJDqt2YPAOlAbBTwqORzCQ9ms+iMv7eXIupYlXD5ORyC9MOQuGBbm14k1oBCcH/moQvAWVDEYc73V1FhCbw7regetBcNC7RXSOJQcbASwoQ9nDcJIw5CjUOV42RLMtIRJ+9SHSVat/PtSwGEvx7wqEsH8u5fHVz28k6Wa+yFKQPCTMav1COSdIMn1YmYu+o+KFfOKaWXITl/1ySsA==
Received: from DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13)
 by SN7PR12MB7298.namprd12.prod.outlook.com (2603:10b6:806:2ae::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.32; Tue, 12 Dec
 2023 19:44:04 +0000
Received: from DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258]) by DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258%5]) with mapi id 15.20.7091.022; Tue, 12 Dec 2023
 19:44:03 +0000
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "eperezma@redhat.com" <eperezma@redhat.com>
CC: "xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>, Parav Pandit
	<parav@nvidia.com>, Gal Pressman <gal@nvidia.com>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "si-wei.liu@oracle.com"
	<si-wei.liu@oracle.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"mst@redhat.com" <mst@redhat.com>, Saeed Mahameed <saeedm@nvidia.com>,
	"jasowang@redhat.com" <jasowang@redhat.com>, "leon@kernel.org"
	<leon@kernel.org>
Subject: Re: [PATCH vhost v2 4/8] vdpa/mlx5: Mark vq addrs for modification in
 hw vq
Thread-Topic: [PATCH vhost v2 4/8] vdpa/mlx5: Mark vq addrs for modification
 in hw vq
Thread-Index: AQHaJ2ha4Gy9JBIWuEWZX8/WZ4ytmbCmEe0AgAAGXwA=
Date: Tue, 12 Dec 2023 19:44:03 +0000
Message-ID: <0eb3ba6fa53f599e3ad99fcb1a1140d2086b4df8.camel@nvidia.com>
References: <20231205104609.876194-1-dtatulea@nvidia.com>
	 <20231205104609.876194-5-dtatulea@nvidia.com>
	 <CAJaqyWeEY9LNTE8QEnJgLhgS7HiXr5gJEwwPBrC3RRBsAE4_7Q@mail.gmail.com>
In-Reply-To:
 <CAJaqyWeEY9LNTE8QEnJgLhgS7HiXr5gJEwwPBrC3RRBsAE4_7Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.2 (3.50.2-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB5565:EE_|SN7PR12MB7298:EE_
x-ms-office365-filtering-correlation-id: c434d15d-02b1-4864-caf8-08dbfb4ab1c4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 QPUNZsIIL2nuLoL0YJd/PBLfiPrG87UBU8AFyoqQu8B+8dhFQN/jJca8P4oiE4WUAIY1w7QJb5R44wP9Z8AiyQOGcBhD1dqO7ro52sySCAK4HEVlGWVqSXkaUKae4BjYjD8crpENdf+sabo1ClXWTBn8v12jWIe/W7dzG9V4b5m+2//5HA0GmS87d1wldBWhPLM9rijTLtCv01UjawytW3c/uOOCjutmnHmkJTEWKSldjVBGECEntUBc07fIgD5fwh+d3t5Kx8NSHU7YRaKcywJdBM38pRkmN0h+vcrLU+DwRKekKHK0da7eob1FRe66ObTReZOZ5RraI1Hhsg4mUDziSJ6lE27Lvc27Iq8w0li6UFw5kfpCZ3lhPy/algmFac0PJpAS+HvYH/f1sMXauUoxTwOOFPr0GudXumut4CSkvEL+K7uHlvzx51REyrIFGpTu+EIX541gaAa2h2TmnU6YLSkCpx1OpxV06ldKV/g5K9CyOUaU+HbF7H6LUkjI5qn8l8w48YQDy31xS8N9JfshIsXBJ0wXvmc4e1lbt/Q/1YJLc/mJzyNSFTpJobAsrLNFUI/bGQuqoqOhs949f2MwzAvkZzYq/SAH73AgptdMaa5fi0wAMessIE/U5OKz
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5565.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(346002)(396003)(376002)(136003)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(6506007)(6512007)(5660300002)(2616005)(36756003)(53546011)(64756008)(38070700009)(4001150100001)(6486002)(66946007)(66476007)(66556008)(76116006)(54906003)(6916009)(91956017)(66574015)(66446008)(2906002)(83380400001)(86362001)(478600001)(41300700001)(4326008)(8936002)(8676002)(122000001)(316002)(38100700002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bzZmanpCQzJaRWk1b1ZTUitFclhtZEwzYjFOMFZMUnNpaXBsUjAzL2xwRFJL?=
 =?utf-8?B?Y0h0SndXQk5SZUVUYk5FaUFCRUVNb3kxc3hIb0lSQlVtWHlsTDJFOFFqRkhj?=
 =?utf-8?B?bGR3SmppaUJ3RjNJUTZER2xMckJkT1BCWkF1Ulkya1JyTEo5TXpzTkZjUlg0?=
 =?utf-8?B?TW1veXRLZEErZ3RjVjNKZ05uRnRBMG5BOWZmNDR3cVltaFd3VkdXSnNweklL?=
 =?utf-8?B?WUlycm9YdUR2NWYzRnlBRTIyZFJlMFdORWJnWDVGendPa0dtRDNaZ1Q3ZE9q?=
 =?utf-8?B?RXFJampqTzh4b09sVVcvZGY1bzBqem5VMWg2V1QxYXFITk9jK1Q4Z0I1M1Rm?=
 =?utf-8?B?aytocjBtd3A0bitCQlErMWRjSUZpSE5nU0thNUY3WU9jbjBad09ZZ3pGcTBz?=
 =?utf-8?B?NGRhOGxTNlI5eXU1a2tGdCs5ZHJ5QVMyQVNVd2NuUERVS2ZEZmV3cVRCenhN?=
 =?utf-8?B?R2lIcnJKb0RqQ0xRdFVSamg2c29kbzIzeU53ZzRRcWZobEhCdU5pdlJLd3FY?=
 =?utf-8?B?SEV4MGNuaUtzR0tFUXdlUGx2WFhHL3NLaXhUQTk4bG5KbTVMbjJyUkVOTVl0?=
 =?utf-8?B?M1BLTGNhTkJvcjJCWnZYdVg2enlFK3dXMkJkcWRPTGJDdlRwZnllU2podzE4?=
 =?utf-8?B?ZytmOEtaUkVkZWJvcm1JNFN6MmlBVTdxcEhCcWh5SHRFOWR2NTdzcHR5TERD?=
 =?utf-8?B?NkNzZTg5OUplZnNOeERNaXlQd3BlZEJyMmpJOEZmVVhEWWgxL3BXT2hiQk1J?=
 =?utf-8?B?bzNNeXFIY2ZtZTRYQ3hTMlVOVkgwb2RBY1h4M1ZFZE1UdWxSZGNGNFRSTVhP?=
 =?utf-8?B?bmdrK2ZWdEhJU21OY3ExbDl6d0czUjEwL1QrZ0NKRkQ2SWlUNmRneTJhdFRh?=
 =?utf-8?B?TzQ1NTd5ZUdGZzBqNmRQTklBdFVGUmtlZUFidExRRlp2T2libEFPMzMzTmha?=
 =?utf-8?B?SStKcTRuQlR5R3kwcnR4UHFBV2pFODRNR1hTYk9sUVlyeUh5enRMNzEvdHVu?=
 =?utf-8?B?VW9pblFQdUdudXZFVXNHelh4L1JTQVd1OEdTV2dna0FEMmg1aTBzbDhpK2px?=
 =?utf-8?B?T2YyTDJaQ1pwU0IzNzQrUnYvWHg0MG5PcllCYmxtdlhOTEpTVTlWYWVpZVVw?=
 =?utf-8?B?Q1dWamwydW9WUlQvOGtqUmJ1M21EK2NTTVRObXpKT0dsYnlrUVRxVXFnTXE5?=
 =?utf-8?B?Qmcrd2owM1R1MGJXWWFkRWFDSUFQRkhnWVdzZE8xUzhOWnR6OFh6NGN0Q1JI?=
 =?utf-8?B?dnpTUXUxTFZyUTVESGpLTVdvUXNDQndYRHpFdTFKWVAyNTFrNlVralJ6dmpx?=
 =?utf-8?B?emlwbG5XbThScDlXaUlLQkZySTlSTzlXL2JFL0NUcnRFT3hnbEZMYkVValJ2?=
 =?utf-8?B?TTV4QkZwNTNnZGVOM1ZzU0xPaXlPR09HSHZxKzlUQ2t5WklDQWxRYUZrWStF?=
 =?utf-8?B?Q2l2T28wNVl3TGtaTW92Vkt4bGJCKzJlVytEd0dCL1FGdmJuUjhJMjF5RW9J?=
 =?utf-8?B?cUN6dXdyZjQ3WU5taEVJNGNuYzVoWmdBQ1RqOUN4MTkxTGNEZnpZcjdDWGxw?=
 =?utf-8?B?ZFY0UjZLU0VraWpFQjRhSllGVTJsWUd5d0xTWEJvMFZYOWJFVlhLamhCS0dr?=
 =?utf-8?B?SDlOL1o4MUF1NzhwZC82VEdYTzlOdGFCMWxGUkNpRFhjOC9vTkZXYkV1TXBq?=
 =?utf-8?B?RWk4Z20wZWNuY2psOTc5M3N6VGh3TjVlelNTeFQvdFUySTM1UXVjbjQxRjdD?=
 =?utf-8?B?eUZydXEvd05aMDc5QjdpbWZxWktHRFl3d0pST3kxdTFHTmg3YUJvU3c5NklC?=
 =?utf-8?B?NllyeTZXcEVXOWpEdFlXWFhldk55ekphM1R2dzBoNFdOZEFUMUFtdDRkQWMw?=
 =?utf-8?B?cEtEejVnWnRIWFhtNGlBTEpHei9RZkplb0VxMWFIVjZFRjFYbFl3YWljdElk?=
 =?utf-8?B?QTZUa1BjSTdKNzFwZXpSeVZHS3hYd3p0NXRjbFFleXlIOEZBejBJNXkvb2hY?=
 =?utf-8?B?Z084Z1ZMTlliRVM0NUFRcnhGd1NUSWVxOWkxSDRVNHhHUHQ3UnVON054WlpK?=
 =?utf-8?B?RUxLcFVucFVra3FCOHkvQURhMzBxMW8xRE96bG5ab1M5TUlFMWtYRmRpRERC?=
 =?utf-8?B?UWdlZ21jbGkzbElsU01INElSdER5MjZHSzBGdjZ6OFY2SGFxc2NlYldRcCtq?=
 =?utf-8?B?VjBsZm9WYzJOVkZSUDF2WUNXSDdjbW1uWnROVTRsalJGVDZ0YktHZW5NVUlp?=
 =?utf-8?B?TmlQa0JibndXc1lzeFkxbStTamJ3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <19CDCA6C83E0C44A9AF1DC6C64507541@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c434d15d-02b1-4864-caf8-08dbfb4ab1c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2023 19:44:03.1504
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i/de6rxYyZkx+IOheah+V+IQZLKfLeVz8xRVINem68wpKAhTZRlVIe00jPAMHzGwiE9ufSKtW8jbDw0NBDHGnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7298

T24gVHVlLCAyMDIzLTEyLTEyIGF0IDIwOjIxICswMTAwLCBFdWdlbmlvIFBlcmV6IE1hcnRpbiB3
cm90ZToNCj4gT24gVHVlLCBEZWMgNSwgMjAyMyBhdCAxMTo0NuKAr0FNIERyYWdvcyBUYXR1bGVh
IDxkdGF0dWxlYUBudmlkaWEuY29tPiB3cm90ZToNCj4gPiANCj4gPiBBZGRyZXNzZXMgZ2V0IHNl
dCBieSAuc2V0X3ZxX2FkZHJlc3MuIGh3IHZxIGFkZHJlc3NlcyB3aWxsIGJlIHVwZGF0ZWQgb24N
Cj4gPiBuZXh0IG1vZGlmeV92aXJ0cXVldWUuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogRHJh
Z29zIFRhdHVsZWEgPGR0YXR1bGVhQG52aWRpYS5jb20+DQo+ID4gUmV2aWV3ZWQtYnk6IEdhbCBQ
cmVzc21hbiA8Z2FsQG52aWRpYS5jb20+DQo+ID4gQWNrZWQtYnk6IEV1Z2VuaW8gUMOpcmV6IDxl
cGVyZXptYUByZWRoYXQuY29tPg0KPiANCj4gSSdtIGtpbmQgb2Ygb2sgd2l0aCB0aGlzIHBhdGNo
IGFuZCB0aGUgbmV4dCBvbmUgYWJvdXQgc3RhdGUsIGJ1dCBJDQo+IGRpZG4ndCBhY2sgdGhlbSBp
biB0aGUgcHJldmlvdXMgc2VyaWVzLg0KPiANClNvcnJ5IGFib3V0IHRoZSBBY2sgbWlzcGxhY2Vt
ZW50LiBJIGdvdCBjb25mdXNlZC4NCg0KPiBNeSBtYWluIGNvbmNlcm4gaXMgdGhhdCBpdCBpcyBu
b3QgdmFsaWQgdG8gY2hhbmdlIHRoZSB2cSBhZGRyZXNzIGFmdGVyDQo+IERSSVZFUl9PSyBpbiBW
aXJ0SU8sIHdoaWNoIHZEUEEgZm9sbG93cy4gT25seSBtZW1vcnkgbWFwcyBhcmUgb2sgdG8NCj4g
Y2hhbmdlIGF0IHRoaXMgbW9tZW50LiBJJ20gbm90IHN1cmUgYWJvdXQgdnEgc3RhdGUgaW4gdkRQ
QSwgYnV0IHZob3N0DQo+IGZvcmJpZHMgY2hhbmdpbmcgaXQgd2l0aCBhbiBhY3RpdmUgYmFja2Vu
ZC4NCj4gDQo+IFN1c3BlbmQgaXMgbm90IGRlZmluZWQgaW4gVmlydElPIGF0IHRoaXMgbW9tZW50
IHRob3VnaCwgc28gbWF5YmUgaXQgaXMNCj4gb2sgdG8gZGVjaWRlIHRoYXQgYWxsIG9mIHRoZXNl
IHBhcmFtZXRlcnMgbWF5IGNoYW5nZSBkdXJpbmcgc3VzcGVuZC4NCj4gTWF5YmUgdGhlIGJlc3Qg
dGhpbmcgaXMgdG8gcHJvdGVjdCB0aGlzIHdpdGggYSB2RFBBIGZlYXR1cmUgZmxhZy4NCj4gDQo+
IEphc29uLCB3aGF0IGRvIHlvdSB0aGluaz8NCj4gDQo+IFRoYW5rcyENCj4gDQo+ID4gLS0tDQo+
ID4gIGRyaXZlcnMvdmRwYS9tbHg1L25ldC9tbHg1X3ZuZXQuYyAgfCA5ICsrKysrKysrKw0KPiA+
ICBpbmNsdWRlL2xpbnV4L21seDUvbWx4NV9pZmNfdmRwYS5oIHwgMSArDQo+ID4gIDIgZmlsZXMg
Y2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygrKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L3ZkcGEvbWx4NS9uZXQvbWx4NV92bmV0LmMgYi9kcml2ZXJzL3ZkcGEvbWx4NS9uZXQvbWx4NV92
bmV0LmMNCj4gPiBpbmRleCBmOGYwODhjY2VkNTAuLjgwZTA2NmRlMDg2NiAxMDA2NDQNCj4gPiAt
LS0gYS9kcml2ZXJzL3ZkcGEvbWx4NS9uZXQvbWx4NV92bmV0LmMNCj4gPiArKysgYi9kcml2ZXJz
L3ZkcGEvbWx4NS9uZXQvbWx4NV92bmV0LmMNCj4gPiBAQCAtMTIwOSw2ICsxMjA5LDcgQEAgc3Rh
dGljIGludCBtb2RpZnlfdmlydHF1ZXVlKHN0cnVjdCBtbHg1X3ZkcGFfbmV0ICpuZGV2LA0KPiA+
ICAgICAgICAgYm9vbCBzdGF0ZV9jaGFuZ2UgPSBmYWxzZTsNCj4gPiAgICAgICAgIHZvaWQgKm9i
al9jb250ZXh0Ow0KPiA+ICAgICAgICAgdm9pZCAqY21kX2hkcjsNCj4gPiArICAgICAgIHZvaWQg
KnZxX2N0eDsNCj4gPiAgICAgICAgIHZvaWQgKmluOw0KPiA+ICAgICAgICAgaW50IGVycjsNCj4g
PiANCj4gPiBAQCAtMTIzMCw2ICsxMjMxLDcgQEAgc3RhdGljIGludCBtb2RpZnlfdmlydHF1ZXVl
KHN0cnVjdCBtbHg1X3ZkcGFfbmV0ICpuZGV2LA0KPiA+ICAgICAgICAgTUxYNV9TRVQoZ2VuZXJh
bF9vYmpfaW5fY21kX2hkciwgY21kX2hkciwgdWlkLCBuZGV2LT5tdmRldi5yZXMudWlkKTsNCj4g
PiANCj4gPiAgICAgICAgIG9ial9jb250ZXh0ID0gTUxYNV9BRERSX09GKG1vZGlmeV92aXJ0aW9f
bmV0X3FfaW4sIGluLCBvYmpfY29udGV4dCk7DQo+ID4gKyAgICAgICB2cV9jdHggPSBNTFg1X0FE
RFJfT0YodmlydGlvX25ldF9xX29iamVjdCwgb2JqX2NvbnRleHQsIHZpcnRpb19xX2NvbnRleHQp
Ow0KPiA+IA0KPiA+ICAgICAgICAgaWYgKG12cS0+bW9kaWZpZWRfZmllbGRzICYgTUxYNV9WSVJU
UV9NT0RJRllfTUFTS19TVEFURSkgew0KPiA+ICAgICAgICAgICAgICAgICBpZiAoIWlzX3ZhbGlk
X3N0YXRlX2NoYW5nZShtdnEtPmZ3X3N0YXRlLCBzdGF0ZSwgaXNfcmVzdW1hYmxlKG5kZXYpKSkg
ew0KPiA+IEBAIC0xMjQxLDYgKzEyNDMsMTIgQEAgc3RhdGljIGludCBtb2RpZnlfdmlydHF1ZXVl
KHN0cnVjdCBtbHg1X3ZkcGFfbmV0ICpuZGV2LA0KPiA+ICAgICAgICAgICAgICAgICBzdGF0ZV9j
aGFuZ2UgPSB0cnVlOw0KPiA+ICAgICAgICAgfQ0KPiA+IA0KPiA+ICsgICAgICAgaWYgKG12cS0+
bW9kaWZpZWRfZmllbGRzICYgTUxYNV9WSVJUUV9NT0RJRllfTUFTS19WSVJUSU9fUV9BRERSUykg
ew0KPiA+ICsgICAgICAgICAgICAgICBNTFg1X1NFVDY0KHZpcnRpb19xLCB2cV9jdHgsIGRlc2Nf
YWRkciwgbXZxLT5kZXNjX2FkZHIpOw0KPiA+ICsgICAgICAgICAgICAgICBNTFg1X1NFVDY0KHZp
cnRpb19xLCB2cV9jdHgsIHVzZWRfYWRkciwgbXZxLT5kZXZpY2VfYWRkcik7DQo+ID4gKyAgICAg
ICAgICAgICAgIE1MWDVfU0VUNjQodmlydGlvX3EsIHZxX2N0eCwgYXZhaWxhYmxlX2FkZHIsIG12
cS0+ZHJpdmVyX2FkZHIpOw0KPiA+ICsgICAgICAgfQ0KPiA+ICsNCj4gPiAgICAgICAgIE1MWDVf
U0VUNjQodmlydGlvX25ldF9xX29iamVjdCwgb2JqX2NvbnRleHQsIG1vZGlmeV9maWVsZF9zZWxl
Y3QsIG12cS0+bW9kaWZpZWRfZmllbGRzKTsNCj4gPiAgICAgICAgIGVyciA9IG1seDVfY21kX2V4
ZWMobmRldi0+bXZkZXYubWRldiwgaW4sIGlubGVuLCBvdXQsIHNpemVvZihvdXQpKTsNCj4gPiAg
ICAgICAgIGlmIChlcnIpDQo+ID4gQEAgLTIyMDIsNiArMjIxMCw3IEBAIHN0YXRpYyBpbnQgbWx4
NV92ZHBhX3NldF92cV9hZGRyZXNzKHN0cnVjdCB2ZHBhX2RldmljZSAqdmRldiwgdTE2IGlkeCwg
dTY0IGRlc2NfDQo+ID4gICAgICAgICBtdnEtPmRlc2NfYWRkciA9IGRlc2NfYXJlYTsNCj4gPiAg
ICAgICAgIG12cS0+ZGV2aWNlX2FkZHIgPSBkZXZpY2VfYXJlYTsNCj4gPiAgICAgICAgIG12cS0+
ZHJpdmVyX2FkZHIgPSBkcml2ZXJfYXJlYTsNCj4gPiArICAgICAgIG12cS0+bW9kaWZpZWRfZmll
bGRzIHw9IE1MWDVfVklSVFFfTU9ESUZZX01BU0tfVklSVElPX1FfQUREUlM7DQo+ID4gICAgICAg
ICByZXR1cm4gMDsNCj4gPiAgfQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4
L21seDUvbWx4NV9pZmNfdmRwYS5oIGIvaW5jbHVkZS9saW51eC9tbHg1L21seDVfaWZjX3ZkcGEu
aA0KPiA+IGluZGV4IGI4NmQ1MWE4NTVmNi4uOTU5NGFjNDA1NzQwIDEwMDY0NA0KPiA+IC0tLSBh
L2luY2x1ZGUvbGludXgvbWx4NS9tbHg1X2lmY192ZHBhLmgNCj4gPiArKysgYi9pbmNsdWRlL2xp
bnV4L21seDUvbWx4NV9pZmNfdmRwYS5oDQo+ID4gQEAgLTE0NSw2ICsxNDUsNyBAQCBlbnVtIHsN
Cj4gPiAgICAgICAgIE1MWDVfVklSVFFfTU9ESUZZX01BU0tfU1RBVEUgICAgICAgICAgICAgICAg
ICAgID0gKHU2NCkxIDw8IDAsDQo+ID4gICAgICAgICBNTFg1X1ZJUlRRX01PRElGWV9NQVNLX0RJ
UlRZX0JJVE1BUF9QQVJBTVMgICAgICA9ICh1NjQpMSA8PCAzLA0KPiA+ICAgICAgICAgTUxYNV9W
SVJUUV9NT0RJRllfTUFTS19ESVJUWV9CSVRNQVBfRFVNUF9FTkFCTEUgPSAodTY0KTEgPDwgNCwN
Cj4gPiArICAgICAgIE1MWDVfVklSVFFfTU9ESUZZX01BU0tfVklSVElPX1FfQUREUlMgICAgICAg
ICAgID0gKHU2NCkxIDw8IDYsDQo+ID4gICAgICAgICBNTFg1X1ZJUlRRX01PRElGWV9NQVNLX0RF
U0NfR1JPVVBfTUtFWSAgICAgICAgICA9ICh1NjQpMSA8PCAxNCwNCj4gPiAgfTsNCj4gPiANCj4g
PiAtLQ0KPiA+IDIuNDIuMA0KPiA+IA0KPiANCg0K

