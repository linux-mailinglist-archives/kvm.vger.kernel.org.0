Return-Path: <kvm+bounces-3304-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B913C802E4F
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 10:16:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6DF39280DE0
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 09:16:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EACB414F9C;
	Mon,  4 Dec 2023 09:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="a2xFUF7i"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42832D6;
	Mon,  4 Dec 2023 01:16:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IWGumiaIrnpCHd8iPF/F9JNjWq3BQIA36SIP1AaacDFVR4RElm+jptYfEHeTjiqKX8vgTIR26sjc8877bWj0XsmcgUVdnVYazaLzc0C19gLfqYumFe/oHONoAqwFtLz4mlsY/vxjwQZBvIwup98k2ycxS85PBdPdoc7vZ8BDHWQ8FwxnJOJWKTuPFmihKh2XZR63kHHPFiQQfS2YMrFUzQ/sgZ7+CqpY15eDPnkyXO94RGEYcOGeTOHB8pKcr0NQD4T98C+7lldeqBREXOo63gutfc8YueTuyh09qjh3V4g5e8aW69n9S+TViK++1oXUOfk4q2JuUA80LV5U39Nj6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5J7hoJvVIXXM3Kem3VTvmuW4naESX7n8z1yv9BIgURY=;
 b=TvoVQMUqLDjtBWPhhPBKQy+c4ppEjr9BZVqq1FR4b6aDMlIGwj4yneVDB24igXSVUYhMjgJ80wWJ91g0liWL+ZmlhvyLNG5YExP1LeOlQMCFQKZGEOXGEqXZlPIvdFu7bkVMSDZtCv1JqZb5DPRN97bXxx7GqVcguOxfgCmGzyY1bqAYN4OYy1gWNxl36UoBJ8xyGWBA8ALkGSBfyGQEFIb0fB+3XAAYP+mtQBeKz8j6FnPNVBTibLCq9/Yl9f1vYY4xor+I/Wjy1ADNezFay++MxaZRKzDxKzvdX3BvXX4hNQJ/SNlf39MdDGDHW8go+5HAZ77kTXfiBYSEsnrKaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5J7hoJvVIXXM3Kem3VTvmuW4naESX7n8z1yv9BIgURY=;
 b=a2xFUF7iMb6YBI1Jwd/kXbzW5hoQHXVT7LKfzjd0dwJHUrqUNn8ihwbsYsD26RangFKgrgorjjuE8StUv2wxSwWk7y+DDa/7BzSMe4MdM7ib2TReZBC7AwpmN7heq/wnrlDxluaJzij+pwm3eFMUU4sOttgIHZD7ilL+4D8U2EAwBUsHqtFBMgUpkp9kgt25sCop8AWwDbAGHsmfy4mbszM2kISMLdZin++MQ/kGqESczIr06GR9UoWxjITkgQ+IiF8MkAd1tnCk3setBUnHhaXgV8eRIU9/yCUlyEwdlJ4fp19f8NBth+JmCcDoXqCXIYXdX/apl42n/3xfznqsSQ==
Received: from DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13)
 by IA0PR12MB8713.namprd12.prod.outlook.com (2603:10b6:208:48e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.33; Mon, 4 Dec
 2023 09:16:07 +0000
Received: from DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258]) by DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258%5]) with mapi id 15.20.7046.033; Mon, 4 Dec 2023
 09:16:07 +0000
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
Thread-Index:
 AQHaJEQPCu8G+as30EOn77AjCdP4t7CWcwSAgAE9GACAABGOAIABFHyAgAAAeoCAAAXdAA==
Date: Mon, 4 Dec 2023 09:16:07 +0000
Message-ID: <b9f5c48788daa3ac335b589b2ad23ea8366c08ba.camel@nvidia.com>
References: <20231201104857.665737-1-dtatulea@nvidia.com>
	 <20231202152523-mutt-send-email-mst@kernel.org>
	 <aff0361edcb0fd0c384bf297e71d25fb77570e15.camel@nvidia.com>
	 <20231203112324-mutt-send-email-mst@kernel.org>
	 <e088b2ac7a197352429d2f5382848907f98c1129.camel@nvidia.com>
	 <20231204035443-mutt-send-email-mst@kernel.org>
In-Reply-To: <20231204035443-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.1 (3.50.1-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB5565:EE_|IA0PR12MB8713:EE_
x-ms-office365-filtering-correlation-id: 43b4e517-9185-4ad7-0117-08dbf4a9a604
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 CjxSdlBJdSywkWgCzo68H6i17DNFmVNjbajMEmRcAhxCcUkduq1JXjiWeADfGbt7y1rN45Xxa7+COsIy3pdScJlm+UDkvMweC59nBMKTh/PxrBEofxXZEYsHxUM2CQNslvkXxhxM7LPjWA2d5+Ooo0XS0RKkHviGXfF+/aW+sjjr+WzDddZoBQd2b2gyivwm4rAjpDtcTLIJrk4XZmjPIKioWtusAOIekL9PEcGfbNq7+uqRaSGSqZpWTAPSceiQlasLVVKFKJwT17lQnjqY1ux53l2LfKIE+WZlswVYlwvWEauXcFcn3xfHwf32OebHUqeCnldie2X3rQLGqpPeGNQ6sA82mgPVsiAzhWxMqgNuHDGiMlVLXIqLQrLvYAMJkFk0Mx1vcVYQOXlmuGHreGB0rAaWlSpYSSAlwGYDFGVrbCfLJIEyaSYs/a16gZCTunMLYEGiOwC1OADzTiPKZHI8onMo6O7boW2rA/mP3rdpb1QHx659KZ4sKxmVTv7QGnKMVe9gRYK8ksGckspN+L3R7gvm2ImfqBJ2S5WX1iV1jWEczHHuZ4vQkOpgL8PiXEzQvDHrDfMdsstlsMAGhDpKJL/OEtUY+bz8j0b8Fn7HFyWaw3w9aj5QyUcD6ByqkBRCNq3ER5tXVxxbjuYbH1hExZowYqkQ3a8P4CbpGGDhJpMb6Mc1Q23ImVG64qRV87OyxCv4HAPmoKhLCGTsYQ==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5565.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(366004)(39860400002)(376002)(346002)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(6916009)(66556008)(66446008)(64756008)(54906003)(316002)(86362001)(8936002)(8676002)(4326008)(66946007)(66476007)(6486002)(966005)(478600001)(91956017)(76116006)(41300700001)(36756003)(5660300002)(2906002)(122000001)(38100700002)(2616005)(6506007)(71200400001)(6512007)(83380400001)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VHlmcWswUFQ5YW5nZTFEZGhmeS9XNXRuK041cEc3Umd2NHRrTlljYjVIL3RM?=
 =?utf-8?B?L2dXOEltYnRWY0JYc0c1OEpZMGFpWitCU2dnUThVcCsyQWg3d1lEeVRZbHdq?=
 =?utf-8?B?YXoyVVVNZjQ2RXh4NlhMQXFGTUdzNDhrMzR1Nk9NVkJlWnhNdEVTcDB1U0ZK?=
 =?utf-8?B?cWlaMHYrdGNSRkU5YU5YWEpsRkRQaGV0OFFuNEE2MGdyN05EVVhwa3UrSitt?=
 =?utf-8?B?MWFSalcvb0dHVGZ6ZU1EbjBQSnI3dVQybERBQlZrQUFvRUlFNWRDV3VFL2h1?=
 =?utf-8?B?UVRlKzlTaXRNc1RuRUNaVlJqazF2RnRaN3hrS0FWYWxNMUZnS2ltMWErYi94?=
 =?utf-8?B?aU9QVk1ZaDZOUy9qUnhZWTNPZng1dkVoMHpPVWZUeUdjNktwMlY4Ryt5eGJI?=
 =?utf-8?B?VHEwOHhJTi9CNjB2Z0ErVUg0SCtqU3YrMUZSYUdiQ0VsS0lYNWEwZUE2b2d2?=
 =?utf-8?B?cmtRMkVPSzg2R0hXSWZLZXdiREViMEFoMGNSWVdIMjBONTFXYXRVM2g1L3c1?=
 =?utf-8?B?R2FXNGxIMFRicU9wWkxzQnVOc3ZyKzdLRVk4MFdZRVU4d2pUUkUxcGxMOHJY?=
 =?utf-8?B?c3ZFeWdlUElyZzcxd01BeWEvTUdVa2pwTnQ4ZVpUV01TRVNPcmo1czJSd0Fo?=
 =?utf-8?B?VGswdUlkODZoZGMyRnhRQVB5L3dlRGJRbFRqSHBwbUpUWkpQNzdtZUF2b1l6?=
 =?utf-8?B?bWlGaEw4N1lSZncvcmMwRUkzYk5JUEJOOHdwcnM2TmtTSWt0d0lKaXN0Tk5r?=
 =?utf-8?B?cEZQZCt3QmVKOVIxOStySDBvYzVCMzg1S2IxTnZEamFFbWdhMXQvZFZIdUFp?=
 =?utf-8?B?QUg3T0xvek0xN3ZRRTRzcmdFVmRiRGdKRXFuRXZRWmU1Z3BoLzdsSmxueE5F?=
 =?utf-8?B?b3hRT3l3bDFVZkw3cExvazNoOEVoZVgyWkNxR25RYmhoRkFLTWI1T3RKUWtQ?=
 =?utf-8?B?UmVQcE96WnhiQ3pyNzlYMHBNRjVxSXhOWmpzSTRMbmE3cksrQXhwaVVvbmdo?=
 =?utf-8?B?VlJ1RkdjOE9LdjYwLzg4Z3VKd1l6ZlJYT1Aya1J1RmNXeWkrWWlnZjlzd0FS?=
 =?utf-8?B?VkxBc1NlbmxxYmUwTmFINmZyZXFWVTcrZ3dQcUpyYlNkYWR6TjRFcFRHcnMw?=
 =?utf-8?B?bWdZcDBjV0ZBYWNOYXJHWjdsbTVqamhqaWVSUmhTcU9DRm14Y2tSdGwvby9j?=
 =?utf-8?B?U2hhblN0WllKZlVJaUxNN2FDbzByRXlabXJjT2R5eVZOUTNyajVVdEovUlQ4?=
 =?utf-8?B?OVpiTTdEczNCTnRHWXlnZFhOQ0JWcG9EQzZPdkJ0ZnplTFd6RFV1MmdCVFY1?=
 =?utf-8?B?cm1ZM0FJSVhVTEt3K29Zdm5YbE15Y3Rody9QL0lXdnBXK2RsTG8xc3lWS1Rp?=
 =?utf-8?B?a2FNMzRwNFMyU3RTZGF3Z3FFUXhTMkNHQy9HbTc5TnEvTTEvTDd3OVQwU1FO?=
 =?utf-8?B?V3ZTZXRDYTNWSTFPblgwQkJYS2twYUR3Rk5tRG9XTlRXTExDeWRyQ2VqV1BP?=
 =?utf-8?B?Z045dXk5MzZlUHlFUXpUdFlhUFA5Wk1aVGRQS2p0dkExbG5BQ1Jpa1JLU3dW?=
 =?utf-8?B?R0VSTkhnMXN6UDh6b3A3clVUVkkyNXhZUFFqK0xteFJ5blN4S3N4anNzQTJ5?=
 =?utf-8?B?SCtXcmVScW12TW9rLytLY2V1OHdYc0hoV203cTBUWTEyOFFGQktFUkVudm15?=
 =?utf-8?B?T293YlZSRU95LytPNWRWTEl1ampQK0ZhendFekk4OGdsQktpL1J6bnhISjMz?=
 =?utf-8?B?c25mcWttWS9ibjNPYVBJY2lrb04ybEw4QmpGbnVvVVJUSUU5NUdJWStMalo1?=
 =?utf-8?B?SjVzbzFrVG9Ldnl2ajA0aGp5R2ZSZXJpeTdoNGg0NXhxREdUaitkYm4zUGhv?=
 =?utf-8?B?NFZpLzFiU3QzSnJBZTZTdThNNlN3dHQwM0VrMVJ2V3FxU0NYY1pYOEptNTVv?=
 =?utf-8?B?NHBZWWQxNmsvanVOYitHT294M2t4Nk41d3QwVkk1Q0RSQmM5ZVBNVnpkV3do?=
 =?utf-8?B?R3N5VnhmSzJtdkI2NDRFdDg1QWU0YTVaQXRXSTRWVXpsTk5mZ3M5N08wY2gz?=
 =?utf-8?B?VWlWVURmM3hSTUlqYSt2c21qcWFVTnEyMXhxdVZ2cVdzMHlVZWdDSDcvNyt5?=
 =?utf-8?B?cy9IUnJTZ1BDVzh2bFMwd0h1dERzLy8zTml2L2o2L09XMTJabUFXcnlBNlE3?=
 =?utf-8?Q?2zfSe7ZSD327Xy/esSlsZmRFQVn96f7MgTxlzWRqFwXO?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <102422B11A949046A1215669BFBA2DA6@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 43b4e517-9185-4ad7-0117-08dbf4a9a604
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2023 09:16:07.4449
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kCLmFnXJviyFtXjEeIzQ2OE2cUBG3wDyCHnz/GalsEDDL75tpc4yKyJSsuZk4wd9A7APL1gw6UwqgzGDK5sUOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8713

T24gTW9uLCAyMDIzLTEyLTA0IGF0IDAzOjU1IC0wNTAwLCBNaWNoYWVsIFMuIFRzaXJraW4gd3Jv
dGU6DQo+IE9uIE1vbiwgRGVjIDA0LCAyMDIzIGF0IDA4OjUzOjI2QU0gKzAwMDAsIERyYWdvcyBU
YXR1bGVhIHdyb3RlOg0KPiA+IE9uIFN1biwgMjAyMy0xMi0wMyBhdCAxMToyMyAtMDUwMCwgTWlj
aGFlbCBTLiBUc2lya2luIHdyb3RlOg0KPiA+ID4gT24gU3VuLCBEZWMgMDMsIDIwMjMgYXQgMDM6
MjE6MDFQTSArMDAwMCwgRHJhZ29zIFRhdHVsZWEgd3JvdGU6DQo+ID4gPiA+IE9uIFNhdCwgMjAy
My0xMi0wMiBhdCAxNToyNiAtMDUwMCwgTWljaGFlbCBTLiBUc2lya2luIHdyb3RlOg0KPiA+ID4g
PiA+IE9uIEZyaSwgRGVjIDAxLCAyMDIzIGF0IDEyOjQ4OjUwUE0gKzAyMDAsIERyYWdvcyBUYXR1
bGVhIHdyb3RlOg0KPiA+ID4gPiA+ID4gQWRkIHN1cHBvcnQgZm9yIHJlc3VtYWJsZSB2cXMgaW4g
dGhlIGRyaXZlci4gVGhpcyBpcyBhIGZpcm13YXJlIGZlYXR1cmUNCj4gPiA+ID4gPiA+IHRoYXQg
Y2FuIGJlIHVzZWQgZm9yIHRoZSBmb2xsb3dpbmcgYmVuZWZpdHM6DQo+ID4gPiA+ID4gPiAtIEZ1
bGwgZGV2aWNlIC5zdXNwZW5kLy5yZXN1bWUuDQo+ID4gPiA+ID4gPiAtIC5zZXRfbWFwIGRvZXNu
J3QgbmVlZCB0byBkZXN0cm95IGFuZCBjcmVhdGUgbmV3IHZxcyBhbnltb3JlIGp1c3QgdG8NCj4g
PiA+ID4gPiA+ICAgdXBkYXRlIHRoZSBtYXAuIFdoZW4gcmVzdW1hYmxlIHZxcyBhcmUgc3VwcG9y
dGVkIGl0IGlzIGVub3VnaCB0bw0KPiA+ID4gPiA+ID4gICBzdXNwZW5kIHRoZSB2cXMsIHNldCB0
aGUgbmV3IG1hcHMsIGFuZCB0aGVuIHJlc3VtZSB0aGUgdnFzLg0KPiA+ID4gPiA+ID4gDQo+ID4g
PiA+ID4gPiBUaGUgZmlyc3QgcGF0Y2ggZXhwb3NlcyB0aGUgcmVsZXZhbnQgYml0cyBpbiBtbHg1
X2lmYy5oLiBUaGF0IG1lYW5zIGl0DQo+ID4gPiA+ID4gPiBuZWVkcyB0byBiZSBhcHBsaWVkIHRv
IHRoZSBtbHg1LXZob3N0IHRyZWUgWzBdIGZpcnN0Lg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IEkg
ZGlkbid0IGdldCB0aGlzLiBXaHkgZG9lcyB0aGlzIG5lZWQgdG8gZ28gdGhyb3VnaCB0aGF0IHRy
ZWU/DQo+ID4gPiA+ID4gSXMgdGhlcmUgYSBkZXBlbmRlbmN5IG9uIHNvbWUgb3RoZXIgY29tbWl0
IGZyb20gdGhhdCB0cmVlPw0KPiA+ID4gPiA+IA0KPiA+ID4gPiBUbyBhdm9pZCBtZXJnZSBpc3N1
ZXMgaW4gTGludXMncyB0cmVlIGluIG1seDVfaWZjLmguIFRoZSBpZGVhIGlzIHRoZSBzYW1lIGFz
IGZvcg0KPiA+ID4gPiB0aGUgInZxIGRlc2NyaXB0b3IgbWFwcGluZ3MiIHBhdGNoc2V0IFsxXS4N
Cj4gPiA+ID4gDQo+ID4gPiA+IFRoYW5rcywNCj4gPiA+ID4gRHJhZ29zDQo+ID4gPiANCj4gPiA+
IEFyZSB0aGVyZSBvdGhlciBjaGFuZ2VzIGluIHRoYXQgYXJlYSB0aGF0IHdpbGwgY2F1c2Ugbm9u
LXRyaXZpYWwgbWVyZ2UNCj4gPiA+IGNvbmZsaWN0cz8NCj4gPiA+IA0KPiA+IFRoZXJlIGFyZSBw
ZW5kaW5nIGNoYW5nZXMgaW4gbWx4NV9pZmMuaCBmb3IgbmV0LW5leHQuIEkgaGF2ZW4ndCBzZWVu
IGFueSBjaGFuZ2VzDQo+ID4gYXJvdW5kIHRoZSB0b3VjaGVkIHN0cnVjdHVyZSBidXQgSSB3b3Vs
ZCBwcmVmZXIgbm90IHRvIHRha2UgYW55IHJpc2suDQo+ID4gDQo+ID4gVGhhbmtzLA0KPiA+IERy
YWdvcw0KPiANCj4gVGhpcyBpcyBleGFjdGx5IHdoYXQgbGludXgtbmV4dCBpcyBmb3IuDQo+IA0K
Tm90IHN1cmUgd2hhdCB0aGUgc3VnZ2VzdGlvbiBpcyBoZXJlLiBJcyBpdDoNCg0KMSkgVG8gcG9z
dCBwYXRjaCAxLzcgdG8gbmV0LW5leHQ/IFRoZW4gd2UnZCBoYXZlIHRvIHdhaXQgZm9yIGEgZmV3
IHdlZWtzIHRvIG1ha2UNCnN1cmUgdGhhdCBpdCBnZXRzIGludG8gdGhlIG5leHQgdHJlZS4NCg0K
b3IgDQoNCjIpIFRvIGFwcGx5IGl0IGludG8gdGhlIHZob3N0IHRyZWUgZGlyZWN0bHk/IFRoZW4g
d2UgcnVuIHRoZSByaXNrIG9mIGhhdmluZw0KbWVyZ2UgaXNzdWVzLg0KDQpUaGUgInB1bGwgZnJv
bSBicmFuY2giIGFwcHJvYWNoIGZvciBjcm9zcyBzdWJzeXN0ZW0gY2hhbmdlcyB3YXMgc3VnZ2Vz
dGVkIGJ5DQpMaW51cyB0aGlzIG1lcmdlIGlzc3VlLg0KDQpbMF0NCmh0dHBzOi8vbG9yZS5rZXJu
ZWwub3JnL2FsbC9DQSs1NWFGeHhvTz1pN25lR0JSR1dfYWZIc1NaN0steDZmTU84di04cG8zTHNf
RXcwUmdAbWFpbC5nbWFpbC5jb20vDQoNClRoYW5rcywNCkRyYWdvcw0KPiANCj4gPiA+ID4gPiA+
IE9uY2UgYXBwbGllZA0KPiA+ID4gPiA+ID4gdGhlcmUsIHRoZSBjaGFuZ2UgaGFzIHRvIGJlIHB1
bGxlZCBmcm9tIG1seDUtdmhvc3QgaW50byB0aGUgdmhvc3QgdHJlZQ0KPiA+ID4gPiA+ID4gYW5k
IG9ubHkgdGhlbiB0aGUgcmVtYWluaW5nIHBhdGNoZXMgY2FuIGJlIGFwcGxpZWQuIFNhbWUgZmxv
dyBhcyB0aGUgdnENCj4gPiA+ID4gPiA+IGRlc2NyaXB0b3IgbWFwcGluZ3MgcGF0Y2hzZXQgWzFd
Lg0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBUbyBiZSBhYmxlIHRvIHVzZSByZXN1bWFibGUg
dnFzIHByb3Blcmx5LCBzdXBwb3J0IGZvciBzZWxlY3RpdmVseSBtb2RpZnlpbmcNCj4gPiA+ID4g
PiA+IHZxIHBhcmFtZXRlcnMgd2FzIG5lZWRlZC4gVGhpcyBpcyB3aGF0IHRoZSBtaWRkbGUgcGFy
dCBvZiB0aGUgc2VyaWVzDQo+ID4gPiA+ID4gPiBjb25zaXN0cyBvZi4NCj4gPiA+ID4gPiA+IA0K
PiA+ID4gPiA+ID4gWzBdIGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJu
ZWwvZ2l0L21lbGxhbm94L2xpbnV4LmdpdC9sb2cvP2g9bWx4NS12aG9zdA0KPiA+ID4gPiA+ID4g
WzFdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3ZpcnR1YWxpemF0aW9uLzIwMjMxMDE4MTcxNDU2
LjE2MjQwMzAtMi1kdGF0dWxlYUBudmlkaWEuY29tLw0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4g
PiBEcmFnb3MgVGF0dWxlYSAoNyk6DQo+ID4gPiA+ID4gPiAgIHZkcGEvbWx4NTogRXhwb3NlIHJl
c3VtYWJsZSB2cSBjYXBhYmlsaXR5DQo+ID4gPiA+ID4gPiAgIHZkcGEvbWx4NTogU3BsaXQgZnVu
Y3Rpb24gaW50byBsb2NrZWQgYW5kIHVubG9ja2VkIHZhcmlhbnRzDQo+ID4gPiA+ID4gPiAgIHZk
cGEvbWx4NTogQWxsb3cgbW9kaWZ5aW5nIG11bHRpcGxlIHZxIGZpZWxkcyBpbiBvbmUgbW9kaWZ5
IGNvbW1hbmQNCj4gPiA+ID4gPiA+ICAgdmRwYS9tbHg1OiBJbnRyb2R1Y2UgcGVyIHZxIGFuZCBk
ZXZpY2UgcmVzdW1lDQo+ID4gPiA+ID4gPiAgIHZkcGEvbWx4NTogTWFyayB2cSBhZGRycyBmb3Ig
bW9kaWZpY2F0aW9uIGluIGh3IHZxDQo+ID4gPiA+ID4gPiAgIHZkcGEvbWx4NTogTWFyayB2cSBz
dGF0ZSBmb3IgbW9kaWZpY2F0aW9uIGluIGh3IHZxDQo+ID4gPiA+ID4gPiAgIHZkcGEvbWx4NTog
VXNlIHZxIHN1c3BlbmQvcmVzdW1lIGR1cmluZyAuc2V0X21hcA0KPiA+ID4gPiA+ID4gDQo+ID4g
PiA+ID4gPiAgZHJpdmVycy92ZHBhL21seDUvY29yZS9tci5jICAgICAgICB8ICAzMSArKystLS0N
Cj4gPiA+ID4gPiA+ICBkcml2ZXJzL3ZkcGEvbWx4NS9uZXQvbWx4NV92bmV0LmMgIHwgMTcyICsr
KysrKysrKysrKysrKysrKysrKysrKystLS0tDQo+ID4gPiA+ID4gPiAgaW5jbHVkZS9saW51eC9t
bHg1L21seDVfaWZjLmggICAgICB8ICAgMyArLQ0KPiA+ID4gPiA+ID4gIGluY2x1ZGUvbGludXgv
bWx4NS9tbHg1X2lmY192ZHBhLmggfCAgIDQgKw0KPiA+ID4gPiA+ID4gIDQgZmlsZXMgY2hhbmdl
ZCwgMTc0IGluc2VydGlvbnMoKyksIDM2IGRlbGV0aW9ucygtKQ0KPiA+ID4gPiA+ID4gDQo+ID4g
PiA+ID4gPiAtLSANCj4gPiA+ID4gPiA+IDIuNDIuMA0KPiA+ID4gPiA+IA0KPiA+ID4gPiANCj4g
PiA+IA0KPiA+IA0KPiANCg0K

