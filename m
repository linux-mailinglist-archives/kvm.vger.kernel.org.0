Return-Path: <kvm+bounces-8569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B9BF851BA9
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 18:36:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD25E1F25006
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 17:36:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36F783F8E6;
	Mon, 12 Feb 2024 17:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oKdGKz0+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCE93D55F;
	Mon, 12 Feb 2024 17:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707759316; cv=fail; b=sV1GLRhI5XPG0yHBbCiNymVtaoi99oSLmzxep3HKwnQO2goZbPa3Wcx1RsKXaQrjS4QoK7gtWadsez7VZP7u8+yHIzj/48l1+rB5fj5x5veTqnRjuhMrE6EyUPFwFLfMOiE6s5FWNN6lTJ9JvYjHUOUtMzmKKUpFoAcZbfokxLo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707759316; c=relaxed/simple;
	bh=WMHrL96k2g8+ATXsz7jzwTP3GdsAvtMJDjJJ8H1XuLo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cLlVFdbXZFenjqik191wwRy3qWD8ZtxQFogtrMG+FMwoTuKyeSeoJzbOOClBKlwkU2FPsCaRzgnovzpi6AjMkBBOSgdXhKhOmuctylYmQC2s8NHWrQs4+8l+xuhRn6/tKkkHTtwHtLqA7oyqvNey8B5Q6qHS5y3LARIFVKevQ5c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oKdGKz0+; arc=fail smtp.client-ip=40.107.220.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eCsY7x+2ZU7jDG3blHUrRQjDGTo1E9yKu87qBwAFEub2mEBk/ET6EalV6JOFi8p+o3+Yk/Eit5CoCk4ZqRO7p07XAhZEQ5Juu1GAzw2aPhwSTrh9JNbIX7LMTNWBrQyfbs0BBLMQSvHMVn5hbJJ2iGFr5J3gWL2aGJZyJ2Q9HSI+w9ppkbh+UJq9JA4d7rYo8Zw+rnykoB9k41GC9EhilYSEdCVVqWU4c/9FOT8X7MjuFILpjQLcL1yRgOLxeFC21EU60HGYJCwOz6UYRiKtK1gkKED9S+uzZrUgyar0DBmLw3D+JT08I/YOMV49Ip17s32x9A+YkFDezOdgxOrKIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WMHrL96k2g8+ATXsz7jzwTP3GdsAvtMJDjJJ8H1XuLo=;
 b=R3gxrsBCFA6I3VlK9rIXzQv5u/bX3eO7DfCn0VuU7McrZgMfPSVbaKiCnLHPu8YQ/p+BT0nALWGDFJp7b21W4HJjXnKQDIAoqfiiYcwGujjDr/ejmVpiCa3+NMYJRIBNMVmTTdXth4IyERepooNAmADaWo5wEJ3LiIW5t5fomtnufMN03hCDa/ZfSLk7GdC8su7miJJ+be27qUYbc81hOVPvDAS10sDFcT59efkbFvLN+U0i+ofH2u4aK+tHui+guEsRwUMTG2OPnvrCtw41YcdARtlwnqwb8y+EIRQ689/ApAkZxoPRUw9eEFUPTAqouLmKuzyOMHyKsT3gTjM9DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WMHrL96k2g8+ATXsz7jzwTP3GdsAvtMJDjJJ8H1XuLo=;
 b=oKdGKz0+JK5V08nhCMZ0/2R1OnF59X757O4Y+e7kPGy3d/549kCXA9KrdinSbM6CxVaIbUmJlxuOiBenXCUi0THWcce2bedsrFDy9RjvcmrDk5d5U26AGEjMae/7MFxSUtkUFUNYIFO1uCCwb1ACpaKhJfP+5Rfe3mGoE6clwHhG8/WE7LcKBXj3S/UxVimbZh9DZjAG+pJ+XFogbFG4f4gSxqRx4IfE3P7wC3vwTcVgjuAswvMQwhmhJptK54wPOr8y4q2UiJNvaAYBZebHhL73O7kjp0uy8mRNrOaMm/RcsBXTkBkxj13TE6JjViWYIsH8l8DrbTA+0iALdsD8BQ==
Received: from MN2PR12MB4206.namprd12.prod.outlook.com (2603:10b6:208:1d5::18)
 by CH3PR12MB9145.namprd12.prod.outlook.com (2603:10b6:610:19b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.21; Mon, 12 Feb
 2024 17:35:10 +0000
Received: from MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::a45b:5d87:d755:2154]) by MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::a45b:5d87:d755:2154%4]) with mapi id 15.20.7292.018; Mon, 12 Feb 2024
 17:35:10 +0000
From: Kirti Wankhede <kwankhede@nvidia.com>
To: "Ricardo B. Marliere" <ricardo@marliere.net>, Alex Williamson
	<alex.williamson@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: RE: [PATCH] vfio: mdev: make mdev_bus_type const
Thread-Topic: [PATCH] vfio: mdev: make mdev_bus_type const
Thread-Index: AQHaWsmeVy2KA2IQd06liqfU2sJPZLEG/fGA
Date: Mon, 12 Feb 2024 17:35:10 +0000
Message-ID:
 <MN2PR12MB42064DF281EBAAE82852F2C4DC482@MN2PR12MB4206.namprd12.prod.outlook.com>
References: <20240208-bus_cleanup-vfio-v1-1-ed5da3019949@marliere.net>
In-Reply-To: <20240208-bus_cleanup-vfio-v1-1-ed5da3019949@marliere.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR12MB4206:EE_|CH3PR12MB9145:EE_
x-ms-office365-filtering-correlation-id: 1f62bc75-0a8d-43e0-c904-08dc2bf0f631
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 H5NqxvABQTUpf0jONxCvdCmT7AphskICdUmVqxDx57woQS7Sod3xCRduGOQN83ajKQFQqBwS0OK+M/AvWNr0BenGY+VFs8vK4IisNJZ3m2vN0H4L+xkvkZrbSAqMijl6hjp1rLGJEnsBLbsUzqBKImJKSDT8D3OXV9ZgJd+LPDbITGir9DsfJSL2dEj8lpYm2y2+WDk/hbYaQrF5TwJVC2XBNuX16Pdw25tjpwxWYQulLKOv6sAXzH68wwblS3dPhdrhnIgvEV+UOpzEB8V388oM0ErSoUOaLoQuBBDTY9CrSqbc96sxvl3Nrv1nlBpPZ63IcPecKj0eaK7zegIVIz0JFf9T+SBop0qMSqMR+PKiWoXCycBYglyRLsa7FXMi1nDyJ6uKv9OO5lYdhGAKE9DsPK2eLMbkFeFVLVSBLlTX3uFrc0qZubEOKJmbi0g3zGZMmU39VmXb7K5U4dSablRE1nDdEu6lw58iAgT69Dp1S8k8it1YOzEkMWh1OVewypSm9I4ElnZGSEVUpBD18Whi3puWQfI3mWug+F+8Eoi2/HX3vamJyQV8z/yHTwE0fIuOWx63+PPx4sEx+cTt9MsgMwSeE9tJB6/ezt1IqKrtKpnucqdkJunnN+z6KGxD
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4206.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(136003)(376002)(346002)(396003)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(55016003)(38070700009)(6506007)(7696005)(2906002)(9686003)(33656002)(86362001)(5660300002)(66946007)(38100700002)(122000001)(76116006)(83380400001)(478600001)(53546011)(54906003)(110136005)(71200400001)(316002)(4326008)(52536014)(64756008)(66446008)(66476007)(66556008)(8676002)(8936002)(41300700001)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WTI2LzgraTk3OExDNUhvTnNvQUs0bHJ4OU04eDVwcllYOFBOMDBuRGlpRVZr?=
 =?utf-8?B?UzV1QnhXVXNoUFhvelpoMmM0TWM3SnBDM0p2OHQ0UEdsY2tTc1hvUERCeUto?=
 =?utf-8?B?ei8yMmhlZnY2Nk5VWFMvL2MyNjdtTDZmejdMUU5KQUxQY2x2Smc1b240TVo3?=
 =?utf-8?B?bVQvV1pUdGkyVlJmVVYwSTJPRzYzNnQwdlh6dTVQb3JFMWNPc2MrcDNFWUdY?=
 =?utf-8?B?SHo1Y3RGQWlueDhDb1BNSmtZNWhXMEdpZEdhK2ErRE5LMzArSDJ0cFc2ekp3?=
 =?utf-8?B?dlZxamVKbG5RcERMRkRiZytuMktubG9NSlRHT3FVcXZkVjg1S2xRbk8ybDZ4?=
 =?utf-8?B?UUxzQWpEQ1J1YjRQU2loSGtva2toVkVnbFlmMndJSmd4YlpsbExERkxGZzY2?=
 =?utf-8?B?Qk1veDhYc0YyZGZMUWIreWFOV0I2Q2EvaFp6VWxVYXp5YTBWL2lGbUlRWEN5?=
 =?utf-8?B?Rkp3WXBaNGE4Vmx5ZVY3eGVGOHNvNEJhb0FKRXRXNlFNMitJdVZhWG5FK2U2?=
 =?utf-8?B?OHhVQ0JWWVRGZXgxWnFLTkVGb3V0ZGNRTHhxZXBDK2REaWc0anVlUTZkSng4?=
 =?utf-8?B?ZVp3akFHVUNwOS9ML0lwVGpPZ2UrM2lKM2RkR05yRXFsb1ZnN2x4bXQrM3JN?=
 =?utf-8?B?VkJTSzQ1STNjQjMwS2YwcWJUaTZRVGh5dDRhbTU0VnRMMnBSRFFFY01lVit3?=
 =?utf-8?B?bFpKNTZQejRHSkxwTG5xdWZWNFRQMWdsSnQ0cGRwRXdocXJqbDJqc2JUd2R5?=
 =?utf-8?B?ZDZFT09odVg1c1Nwd2l4SFV1dnU3RExSY0Z4NkdsOHBtOWZ5L1cvdGRaaVEv?=
 =?utf-8?B?R1FEWWJ4Tmo1ZytOVmcrQysxMGw4bzRDVzZWTTdpOG84UzcxTW14Y1YxMkFB?=
 =?utf-8?B?cXNzUCs2aDVLRTJRcVhTWDlEbEIrNitSRXlFRzlUZHVocGdlK1dKakpvUjFE?=
 =?utf-8?B?cG13djZ2YlBYRldEYjI3RmROTjdPeDdHYjkyaDhveHU2YzlzREVTS0xIQXB0?=
 =?utf-8?B?SFNGQWI2ak1hak9ScXUrdnJ4dVFWanJCNktyd295T3NPb3dzQlNzbmYwbDEx?=
 =?utf-8?B?K1BSTDdLYW9HL3VxNXhMMlhrTWhCS3Jla01LOU40cG03eWpCWHhJalFGWkpT?=
 =?utf-8?B?TzUwbmc3QktHZHZiU2NHcTBHZElGTjVkWGhNQzVIS3RCOGlJM2hHKzdGKzU3?=
 =?utf-8?B?UXp6K3VVOEh3RlBGMi9nVVFoUS9iZjhrMklqKy9aYVBwV0U5T1RRZmR6Mmxy?=
 =?utf-8?B?eDh2WmxCYWc0TEhhRTljNUtVMHhOZ2tsMnlSRVJtSmFvTEdHRm80cnZzMUQ3?=
 =?utf-8?B?Q0tYcGNYNWxrWXN0VTRROTJ4WEFKN3RxTGtmSTBBWkNQOW5TVzVRSEV6enRh?=
 =?utf-8?B?MWxCV3ZvWHhWKzFxdEQ3SFhjV25CN3ZYV2dTWnFGMkFZOVFRZlVHVE5idkp2?=
 =?utf-8?B?QXBUN2VwcVV6KzY4VVRlSk5BdlNaQndrZzdLM3hxb2NUdmZzQmxZTi9pZDdG?=
 =?utf-8?B?V1BGS3JjNldaT1FwZDErTE1rM0F0cE03K1FWREtMUmc4SzRZeG9DOFJrNk9E?=
 =?utf-8?B?TVlqZi91YkUzRWRYQXB2aUNjVzdkYlkvdlViRTAvaGdDOXVMYUlXYnN0S3hS?=
 =?utf-8?B?ZzQxTm16Y3JKWEhDeU5aN0FPajRjdTVoNFhnUUtBWk9reU41QjVKQmdtREND?=
 =?utf-8?B?NXBkN3lZZ0ZpWU9uZldocCtPNDdMb1lhZ2NGbWFaN0JoQ01OVjJ4N2RkaHUx?=
 =?utf-8?B?YWlFcm9vaTVWblJBejJpSkxTVisvZ3NZTmtrblRCNzU0SXlUMUllZjYxZUt4?=
 =?utf-8?B?bGdRSW44WGRQTm96SkNrMkJzaXVTc3dWaWs4VVJIQVp1RVR5ZGRMaWJrL1hS?=
 =?utf-8?B?dC80bHpMbzh6M3pObG5mOUhaVWVvb09PQnBGSzlmbEg5RjZHYTdUWHR4eHQ0?=
 =?utf-8?B?bzFUd2o4TnVRa1VMdTBNVlZ5Q1ZVaEg4K01WSnZna2VkWE9lVTZ3U1gvVzNJ?=
 =?utf-8?B?U0grMEJXNVY5VGc3UGpnRHRwK2lOdlNGRDUxZHltZEdxRThPVm50Z0h1S25y?=
 =?utf-8?B?UFNoTDExQU1sUzh6azdEWWMrYTRCbUhNK3EzTmZTY2k1S3NIN3RuQUxnaCsx?=
 =?utf-8?Q?UGpIwBFLVwcNdA463q9TNnd9p?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4206.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f62bc75-0a8d-43e0-c904-08dc2bf0f631
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2024 17:35:10.2274
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8krg7NrAC9R9NO2YfBJlFOMEFc6umWgno+zazeJQEaTpPiLTmcuYFzSKOF0ZQUtp7pj7HKQHPuCS81NVJGuCTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9145

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFJpY2FyZG8gQi4gTWFybGll
cmUgPHJpY2FyZG9AbWFybGllcmUubmV0Pg0KPiBTZW50OiBGcmlkYXksIEZlYnJ1YXJ5IDksIDIw
MjQgMTozMiBBTQ0KPiBUbzogS2lydGkgV2Fua2hlZGUgPGt3YW5raGVkZUBudmlkaWEuY29tPjsg
QWxleCBXaWxsaWFtc29uDQo+IDxhbGV4LndpbGxpYW1zb25AcmVkaGF0LmNvbT4NCj4gQ2M6IGt2
bUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IEdyZWcgS3Jv
YWgtSGFydG1hbg0KPiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+OyBSaWNhcmRvIEIuIE1h
cmxpZXJlIDxyaWNhcmRvQG1hcmxpZXJlLm5ldD4NCj4gU3ViamVjdDogW1BBVENIXSB2ZmlvOiBt
ZGV2OiBtYWtlIG1kZXZfYnVzX3R5cGUgY29uc3QNCj4gDQo+IE5vdyB0aGF0IHRoZSBkcml2ZXIg
Y29yZSBjYW4gcHJvcGVybHkgaGFuZGxlIGNvbnN0YW50IHN0cnVjdCBidXNfdHlwZSwNCj4gbW92
ZSB0aGUgbWRldl9idXNfdHlwZSB2YXJpYWJsZSB0byBiZSBhIGNvbnN0YW50IHN0cnVjdHVyZSBh
cyB3ZWxsLA0KPiBwbGFjaW5nIGl0IGludG8gcmVhZC1vbmx5IG1lbW9yeSB3aGljaCBjYW4gbm90
IGJlIG1vZGlmaWVkIGF0IHJ1bnRpbWUuDQo+IA0KPiBDYzogR3JlZyBLcm9haC1IYXJ0bWFuIDxn
cmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz4NCj4gU3VnZ2VzdGVkLWJ5OiBHcmVnIEtyb2FoLUhh
cnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPg0KPiBTaWduZWQtb2ZmLWJ5OiBSaWNh
cmRvIEIuIE1hcmxpZXJlIDxyaWNhcmRvQG1hcmxpZXJlLm5ldD4NCg0KUmV2aWV3ZWQtYnk6IEtp
cnRpIFdhbmtoZWRlIDxrd2Fua2hlZGVAbnZpZGlhLmNvbT4gDQoNCg0KPiAtLS0NCj4gIGRyaXZl
cnMvdmZpby9tZGV2L21kZXZfZHJpdmVyLmMgIHwgMiArLQ0KPiAgZHJpdmVycy92ZmlvL21kZXYv
bWRldl9wcml2YXRlLmggfCAyICstDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygr
KSwgMiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3ZmaW8vbWRldi9t
ZGV2X2RyaXZlci5jIGIvZHJpdmVycy92ZmlvL21kZXYvbWRldl9kcml2ZXIuYw0KPiBpbmRleCA3
ODI1ZDgzYTU1ZjguLmI5ODMyMjk2NmIzZSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy92ZmlvL21k
ZXYvbWRldl9kcml2ZXIuYw0KPiArKysgYi9kcml2ZXJzL3ZmaW8vbWRldi9tZGV2X2RyaXZlci5j
DQo+IEBAIC00MCw3ICs0MCw3IEBAIHN0YXRpYyBpbnQgbWRldl9tYXRjaChzdHJ1Y3QgZGV2aWNl
ICpkZXYsIHN0cnVjdA0KPiBkZXZpY2VfZHJpdmVyICpkcnYpDQo+ICAJcmV0dXJuIDA7DQo+ICB9
DQo+IA0KPiAtc3RydWN0IGJ1c190eXBlIG1kZXZfYnVzX3R5cGUgPSB7DQo+ICtjb25zdCBzdHJ1
Y3QgYnVzX3R5cGUgbWRldl9idXNfdHlwZSA9IHsNCj4gIAkubmFtZQkJPSAibWRldiIsDQo+ICAJ
LnByb2JlCQk9IG1kZXZfcHJvYmUsDQo+ICAJLnJlbW92ZQkJPSBtZGV2X3JlbW92ZSwNCj4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvdmZpby9tZGV2L21kZXZfcHJpdmF0ZS5oDQo+IGIvZHJpdmVycy92
ZmlvL21kZXYvbWRldl9wcml2YXRlLmgNCj4gaW5kZXggYWY0NTdiMjdmNjA3Li42M2ExMzE2YjA4
YjcgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvdmZpby9tZGV2L21kZXZfcHJpdmF0ZS5oDQo+ICsr
KyBiL2RyaXZlcnMvdmZpby9tZGV2L21kZXZfcHJpdmF0ZS5oDQo+IEBAIC0xMyw3ICsxMyw3IEBA
DQo+ICBpbnQgIG1kZXZfYnVzX3JlZ2lzdGVyKHZvaWQpOw0KPiAgdm9pZCBtZGV2X2J1c191bnJl
Z2lzdGVyKHZvaWQpOw0KPiANCj4gLWV4dGVybiBzdHJ1Y3QgYnVzX3R5cGUgbWRldl9idXNfdHlw
ZTsNCj4gK2V4dGVybiBjb25zdCBzdHJ1Y3QgYnVzX3R5cGUgbWRldl9idXNfdHlwZTsNCj4gIGV4
dGVybiBjb25zdCBzdHJ1Y3QgYXR0cmlidXRlX2dyb3VwICptZGV2X2RldmljZV9ncm91cHNbXTsN
Cj4gDQo+ICAjZGVmaW5lIHRvX21kZXZfdHlwZV9hdHRyKF9hdHRyKQlcDQo+IA0KPiAtLS0NCj4g
YmFzZS1jb21taXQ6IDc4ZjcwYzAyYmRiY2NiNWU5YjBiMGM3MjgxODVkNGFlYjcwNDRhY2UNCj4g
Y2hhbmdlLWlkOiAyMDI0MDIwOC1idXNfY2xlYW51cC12ZmlvLTc1YTYxODBiNWVmZQ0KPiANCj4g
QmVzdCByZWdhcmRzLA0KPiAtLQ0KPiBSaWNhcmRvIEIuIE1hcmxpZXJlIDxyaWNhcmRvQG1hcmxp
ZXJlLm5ldD4NCg0K

