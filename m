Return-Path: <kvm+bounces-4572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 34A12814A1B
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 15:11:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E011E285343
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 14:11:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEB7D2FE3F;
	Fri, 15 Dec 2023 14:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CdZmKUUi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2080.outbound.protection.outlook.com [40.107.100.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA69E2C690;
	Fri, 15 Dec 2023 14:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gTrDaHbVZ9M9ZMX4RBBY0yNccoFCJoy2/5oGebDYK236xBZRXCn65uKsQO5FGlhOG0SRe1g04a9hGRei5mzTwZw3lR8hYQcP8NxlGsKG8/FcY3VW5Qavgw7daJk4x9psTwbrsd7p91RJy38mz05O0hx1aV4D3K7K5J7DmfwurYNGbFPIUJ+EGiGWzpPxXmzXYMnfCbnRTB+iLg+leiwoyOtpk5l68r55GePAhKqUlJsT2MloKgrGxla9eQAYk3bB0INYbZYjCToeBGW8BZLnnx6KyxAxt+1xKqNSd5geb6XR+zKURndwrHdvxOFaiIV8zYDd2GwXVjxGl9Mh0fMCNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h3bDamNp7w9RhGYX2eG3i6r44AqHUHgDiEZAOdTMFpk=;
 b=WaPZgvG9N4DGapZIe4a0rF0YqnZtk6bw1TT0rrVVf7+duYG2YkpeTbTQjkahBXeLkPigoxbPbrKJi6wwQsOqlfpXf9I2Jh7IroDpPNPN1n+V8Ufh3vY23Q3ijR1GG1O4ZkoNRX3c7ekFWqiHeJJw22npp/F27rq/QnotH41yqtZuJFwgJNdQ5KtE0PB1RGIG04MKonjgO/rdWWRXlowmgPid0s0yzNk6Qjvw+rwf04pQym8YVpmkOkT0MiSe0PwVQ1s+TyauDgYWJqjUKaiN4/dEQqnYkHMIgYJ/xz0b5AR5NfuVFbRnUPkqxeuJ+NnXj5dH1jJIbGfCJrmYsKdG5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h3bDamNp7w9RhGYX2eG3i6r44AqHUHgDiEZAOdTMFpk=;
 b=CdZmKUUi18mQnYGhPzB8U/O2d7fWssWj4LTXc55EKIbe6iPn2DLwvn20e/bTYZ78DGEU2H0hN4WyCqyg5RrmaeLAGP55TMVR4PDvvbXYuY75lcXyHhwPRmxBqY4LY5hbTMYVBDyuUm6AK07ozo09CCzn3z6Ane1JUxczlLHzXql+oBJysXxBEJyWDqUjdWgKJCO+zeIwJhX/ZdpbCt5YXIJG/mCaCWl1Jhjkf8kjEI5GfxIELprd98m5pIlIJN5dGgLPgfKoMhsYKZlhlSbDmtOeXNic61UniPUuyECIb0BLpnkaLr8zpKjgvGwbD+3b1S0Ul13H1G+nfhnJmK8uHA==
Received: from DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13)
 by MN2PR12MB4270.namprd12.prod.outlook.com (2603:10b6:208:1d9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.32; Fri, 15 Dec
 2023 14:10:51 +0000
Received: from DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258]) by DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258%5]) with mapi id 15.20.7091.030; Fri, 15 Dec 2023
 14:10:51 +0000
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "eperezma@redhat.com"
	<eperezma@redhat.com>, Gal Pressman <gal@nvidia.com>, "si-wei.liu@oracle.com"
	<si-wei.liu@oracle.com>, "mst@redhat.com" <mst@redhat.com>, "leon@kernel.org"
	<leon@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, "jasowang@redhat.com"
	<jasowang@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Parav Pandit
	<parav@nvidia.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "xuanzhuo@linux.alibaba.com"
	<xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost v3 0/6] vdpa/mlx5: Add support for resumable vqs
Thread-Topic: [PATCH vhost v3 0/6] vdpa/mlx5: Add support for resumable vqs
Thread-Index: AQHaL19NytSBM0QiS0K5X9wVZSQk7bCqYkQA
Date: Fri, 15 Dec 2023 14:10:51 +0000
Message-ID: <53cc19f4c6a1f5984b56e03c5bc105d9685be103.camel@nvidia.com>
References: <20231215140146.95816-1-dtatulea@nvidia.com>
In-Reply-To: <20231215140146.95816-1-dtatulea@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.2 (3.50.2-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB5565:EE_|MN2PR12MB4270:EE_
x-ms-office365-filtering-correlation-id: e680ad96-7f41-4182-72ee-08dbfd77a4ee
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 RvhCQ8qejRZiuaTtT/hlnt2QBC+/9m6jLkVGaHtYNaI9n+pVDSR5wrAGUKvqU9DhcnOdd14WpEmkgBR7P2737TxO5Ht3oHWsqK6i529VlD4IFqA3AgubjL7qvJ4avZGDQX7GGIkIXJkEtfyZGN7pIqwjSPd2eP2CnzwgxrxQAW0MTK69p18a6xl6s9SY9kV5mRc7bqhkdkw2CGTuQ0rI/gSZ5eD11+scluTaSohKmW3DYknh/VfGuqWjBhU9zvG3dUVHCsP9/HV/Lwf+7SzpDJfuKR92Kpfc0ZQrsWgpJmej2PHN3MuOhFPYgqNfFCIuusyh5HMaVeNB4XWjzxqCuS5tTTlkASsY8Ez5e0ApQtc3LIS2yIaMQwMxPnpD1dwO3uZxJo80/eoM0EC93tNtBMsSIuM995ROoz29lkRBPehLawUrA5m+ROgEjs0knZnKl7b3iGJk9Ap6iV1/SurfIoV4/Q/TR2pdIfGiwC4rzC72wN7iswNp6ZtgwbhdTURx+T0O1AoYFWvjpGZ+9PUJPmShgh6tUOSyI9jrkGVmVIsBCavEPqOD8vCVPvzXTeFHZ3Z0AdiKcJUtJPKqRIbMT2WdWeLza9p6Rb+erx7oQjKCl7mk/rvSd8mIabLE7NBkFc6tpQLlbhh5qj4KaHlsC2O0cWZLyFom8P0zefycwHU=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5565.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(376002)(346002)(39860400002)(136003)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(122000001)(38100700002)(2616005)(83380400001)(71200400001)(36756003)(86362001)(38070700009)(6506007)(6512007)(478600001)(316002)(110136005)(66946007)(66556008)(66476007)(66446008)(64756008)(54906003)(91956017)(76116006)(4001150100001)(2906002)(8936002)(4326008)(8676002)(5660300002)(41300700001)(966005)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?c0dRd3pWUEMrT2YzU0NpY0g4ajBrZjBFNFNSWFVsamZhbUxzUVd0eHppQ0lL?=
 =?utf-8?B?ZzNybkpTelE0bWlZdjRyQW54a2RkRzVkeHM5K1Q3N0FqOFJFcGJtSmMzd2Js?=
 =?utf-8?B?M04zdjVURmpoZTJIaXpmRzM2QnVaSkNjcVNwdjQ2VzcydFlmSjN5ckI1STRX?=
 =?utf-8?B?RWRnSklVSmpGVjNNOUZVME5GK2U2TEZpYkxHOUc3VUpMV00walAzRjV2a2FY?=
 =?utf-8?B?cEhWVXBBQzgzMXlYY2h2SndycUxSWjhLUHUzSkVVWmhFUjVlZVZFRmJrUVlj?=
 =?utf-8?B?bU13VHRYNVZiYkdLTVkza0JEY3JxT0R3cUNNTENwemQ3UVFLK29Ka0ZiWUR1?=
 =?utf-8?B?ZFN5b3RuVTR5cGFvTldzWFczWkJ4bGtPbjVGUTFsSXJIYXlkY0FTSXo5dTZh?=
 =?utf-8?B?Vm1PMUw5MlZvU2RXSXVNdmlJekwvM0JtTytBV0loUnJUVWgxMzRoVkRRYTZt?=
 =?utf-8?B?NGZCRXN4MHN5Uy9jWFFveUZYZE9aU3lQTWhmV3N5WklvS2dFNm1PUVhUaFBt?=
 =?utf-8?B?OXFJRExxMndWSGpwVkczSmhmS1FXRTNadWYxaXMwaWxSS3lBNHBoVGhUejI1?=
 =?utf-8?B?ZXNUT2NiMFFUU0FwU3JnVHpiYnZuSzQxeEhGWnEzWFRDcHVadjhJV1c0SXV2?=
 =?utf-8?B?bzZHTUYwa1JXMG5td0s4OFhMUzd3SkhBaFY4RkxTeHB1OW01RE1PYmdGdmE3?=
 =?utf-8?B?N0xISmcvQXRmNHF6TEgzVTVLcis1NE1YaXcwUG82OXVrUWtaKzJyRzRmTjdB?=
 =?utf-8?B?K3owVm03UVlCd1B4bXFpTEZaUVF4S0xHSmZTeU44WTRsbi82T0toQ0dzNGVp?=
 =?utf-8?B?L0Z2VTA1eEp6WG5xSzZDWC8vNU5FdVlUMTMwcjd0Q3UvUFg2WS9MbHFIVE5L?=
 =?utf-8?B?Vk5YcVR5ckIva0VObjRWaWFubTdwTi9QeVdqc2taN0FOU2pKc2M0dUdSZHdr?=
 =?utf-8?B?dVhsZUE2ZlZGcElsb3pSN0NqQUViYjVYZUJLOSsrS2QxTnJhbEtTUHR2ai93?=
 =?utf-8?B?U3JJbGRlK2t5bHZYZHlvQjVrT3hkb1FYWTFaUm5HdVh2U0pzOUMxYkdzVGdQ?=
 =?utf-8?B?M1N1VWorNjM1RW5reWRPSmwrTHNTdEs3eVdGRXI1MVVyb2k3a2hnVEUxMkFJ?=
 =?utf-8?B?WWp5ZU51LzBwTmpiNHNOVWdjajIzTTZKd1hPRFUyeDI2Ky9sVWNyZE1uV3VN?=
 =?utf-8?B?ZEkvOE5Ja1crb3BFamNtVm1yYlpmd3NVNmpTQTVJSFZTcGxxdzF3RnlPcG5z?=
 =?utf-8?B?YVJnYWNQY1ZBNDRTN0Y4YkJpREdrK1hOR2pFQ3o4c3ZqY2ZZWk82WHl0VjRw?=
 =?utf-8?B?ZndFSGQwbU1tRURqK1ludTBYZmJBM0ViVWJleUFkUWxZK3VVNndTayttUjFu?=
 =?utf-8?B?UUM3dmpEbGx2ZDZFcnlGK01kYWZSMDRGUUxCQ1VSVDFoQ05IakIxdkZBaHp3?=
 =?utf-8?B?QmdLMHZxMjk3ckRrVTROU0hiRXRFUGVRV0tlUElvZ2gvRkZLYWtySU9qVzJT?=
 =?utf-8?B?ckhHM29sWkd1VCtNaTZPQnhtcUlRSFBkdFFOcFlDVUp4bUNHdExTWkxmSTF3?=
 =?utf-8?B?cy9Dc3pJVE82LzBvMVdoYzllWXFob3I3RGk3UW5IS3hRZldBWEo5TEFZMEFK?=
 =?utf-8?B?RGdTZGoxRmVnY1F4ZGhuVlhIY1UzVFZ0YUUzcnlxOERRWWpJMk5rSDFraXhr?=
 =?utf-8?B?U1RYTnFtMFNNYzU2am9uVVNxNFBvZTFES0xIOVlUY1paNUFFOGdZUE8wdmY2?=
 =?utf-8?B?cWRNVWxKdGhxQ1BaVit5cDdmbWRJVm9vakVEZHNwOWNXeHhKNy83RVZUQXI1?=
 =?utf-8?B?MnhPZWdYNnZHTC9KRHdRSjZXbDJxY0xXWWVOa1JxUEQrYjZVa2hPcDJ5KzhY?=
 =?utf-8?B?MlYyeDZmREJydndPTFBhK0liRHdDa2p1RDFuYnRvOVcyKy81ZTlmKzk5eXBt?=
 =?utf-8?B?bHhtVURUQzZ5NWtjcXlKVm90bkloQXFhUUpzZmwvZVNsdFZTSkNXaUNOZU5x?=
 =?utf-8?B?RDVFRThNT3pwUTN5WjNHZHd1VWVaZUQxeERLYnorbWcxUmpCSGJJajIxZG5p?=
 =?utf-8?B?clJGZHQ4dEliQkJBdmxBUmI4L0dTMWRSVUo3ODlTMkdwTU04dUE5ckFEOXN2?=
 =?utf-8?B?bjFGOE1RR0JTQlZnZjA2WjhHendVWXNCbWtmekVNc09qdmpXeUMzcm1ZWUJS?=
 =?utf-8?Q?2Yhta/1+QgjqfNIrK0SUPKZ5p0mxb0hmE/X/uTBEtqA4?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <341398C1F3280040BB1D346C956E4EEF@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e680ad96-7f41-4182-72ee-08dbfd77a4ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2023 14:10:51.2866
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EfriQGk5hSerGyePn252PWjYiARpEabzPOWzlylLEN7FFbF3nMS/LrDBkuu48McFLDtLSUyKTrMZECaQq6iG8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4270

T24gRnJpLCAyMDIzLTEyLTE1IGF0IDE2OjAxICswMjAwLCBEcmFnb3MgVGF0dWxlYSB3cm90ZToN
Cj4gQWRkIHN1cHBvcnQgZm9yIHJlc3VtYWJsZSB2cXMgaW4gdGhlIGRyaXZlci4gVGhpcyBpcyBh
IGZpcm13YXJlIGZlYXR1cmUNCj4gdGhhdCBjYW4gYmUgdXNlZCBmb3IgdGhlIGZvbGxvd2luZyBi
ZW5lZml0czoNCj4gLSBGdWxsIGRldmljZSAuc3VzcGVuZC8ucmVzdW1lLg0KPiAtIC5zZXRfbWFw
IGRvZXNuJ3QgbmVlZCB0byBkZXN0cm95IGFuZCBjcmVhdGUgbmV3IHZxcyBhbnltb3JlIGp1c3Qg
dG8NCj4gICB1cGRhdGUgdGhlIG1hcC4gV2hlbiByZXN1bWFibGUgdnFzIGFyZSBzdXBwb3J0ZWQg
aXQgaXMgZW5vdWdoIHRvDQo+ICAgc3VzcGVuZCB0aGUgdnFzLCBzZXQgdGhlIG5ldyBtYXBzLCBh
bmQgdGhlbiByZXN1bWUgdGhlIHZxcy4NCj4gDQo+IFRoZSBmaXJzdCBwYXRjaCBleHBvc2VzIHRo
ZSByZWxldmFudCBiaXRzIGluIG1seDVfaWZjLmguIFRoYXQgbWVhbnMgaXQNCj4gbmVlZHMgdG8g
YmUgYXBwbGllZCB0byB0aGUgbWx4NS12aG9zdCB0cmVlIFswXSBmaXJzdC4gT25jZSBhcHBsaWVk
DQo+IHRoZXJlLCB0aGUgY2hhbmdlIGhhcyB0byBiZSBwdWxsZWQgZnJvbSBtbHg1LXZob3N0IGlu
dG8gdGhlIHZob3N0IHRyZWUNCj4gYW5kIG9ubHkgdGhlbiB0aGUgcmVtYWluaW5nIHBhdGNoZXMg
Y2FuIGJlIGFwcGxpZWQuIFNhbWUgZmxvdyBhcyB0aGUgdnENCj4gZGVzY3JpcHRvciBtYXBwaW5n
cyBwYXRjaHNldCBbMV0uDQo+IA0KPiBUaGUgc2Vjb25kIHBhcnQgYWRkcyBzdXBwb3J0IGZvciBy
ZXN1bWFibGUgdnFzIGluIHRoZSBmb3JtIG9mIGEgZGV2aWNlIC5yZXN1bWUNCj4gb3BlcmF0aW9u
IGJ1dCBhbHNvIGZvciB0aGUgLnNldF9tYXAgY2FsbCAoc3VzcGVuZC9yZXN1bWUgZGV2aWNlIGlu
c3RlYWQNCj4gb2YgcmUtY3JlYXRpbmcgdnFzIHdpdGggbmV3IG1hcHBpbmdzKS4NCj4gDQo+IFRo
ZSBsYXN0IHBhcnQgb2YgdGhlIHNlcmllcyBpbnRyb2R1Y2VzIHJlZmVyZW5jZSBjb3VudGluZyBm
b3IgbXJzIHdoaWNoDQo+IGlzIG5lY2Vzc2FyeSB0byBhdm9pZCBmcmVlaW5nIG1rZXlzIHRvbyBl
YXJseSBvciBsZWFraW5nIHRoZW0uDQo+IA0KPiAqIENoYW5nZXMgaW4gdjM6DQo+IC0gRHJvcHBl
ZCBwYXRjaGVzIHRoYXQgYWxsb3dlZCB2cSBtb2RpZmljYXRpb24gb2Ygc3RhdGUgYW5kIGFkZHJl
c3Nlcw0KPiAgIHdoZW4gc3RhdGUgaXMgRFJJVkVSX09LLiBUaGlzIGlzIG5vdCBhbGxvd2VkIGJ5
IHRoZSBzdGFuZGFyZC4NCj4gICBTaG91bGQgYmUgcmUtYWRkZWQgdW5kZXIgYSB2ZHBhIGZlYXR1
cmUgZmxhZy4NCj4gDQo+ICogQ2hhbmdlcyBpbiB2MjoNCj4gLSBBZGRlZCBtciByZWZjb3VudGlu
ZyBwYXRjaGVzLg0KPiAtIERlbGV0ZWQgdW5uZWNlc3NhcnkgcGF0Y2g6ICJ2ZHBhL21seDU6IFNw
bGl0IGZ1bmN0aW9uIGludG8gbG9ja2VkIGFuZA0KPiAgIHVubG9ja2VkIHZhcmlhbnRzIg0KPiAt
IFNtYWxsIHByaW50IGltcHJvdmVtZW50IGluICJJbnRyb2R1Y2UgcGVyIHZxIGFuZCBkZXZpY2Ug
cmVzdW1lIg0KPiAgIHBhdGNoLg0KPiAtIFBhdGNoIDEvNyBoYXMgYmVlbiBhcHBsaWVkIHRvIG1s
eDUtdmhvc3QgYnJhbmNoLg0KPiANCj4gWzBdIGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3Nj
bS9saW51eC9rZXJuZWwvZ2l0L21lbGxhbm94L2xpbnV4LmdpdC9sb2cvP2g9bWx4NS12aG9zdA0K
PiBbMV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvdmlydHVhbGl6YXRpb24vMjAyMzEwMTgxNzE0
NTYuMTYyNDAzMC0yLWR0YXR1bGVhQG52aWRpYS5jb20vDQo+IA0KPiANCj4gRHJhZ29zIFRhdHVs
ZWEgKDYpOg0KPiAgIHZkcGEvbWx4NTogRXhwb3NlIHJlc3VtYWJsZSB2cSBjYXBhYmlsaXR5DQo+
ICAgdmRwYS9tbHg1OiBBbGxvdyBtb2RpZnlpbmcgbXVsdGlwbGUgdnEgZmllbGRzIGluIG9uZSBt
b2RpZnkgY29tbWFuZA0KPiAgIHZkcGEvbWx4NTogSW50cm9kdWNlIHBlciB2cSBhbmQgZGV2aWNl
IHJlc3VtZQ0KPiAgIHZkcGEvbWx4NTogVXNlIHZxIHN1c3BlbmQvcmVzdW1lIGR1cmluZyAuc2V0
X21hcA0KPiAgIHZkcGEvbWx4NTogSW50cm9kdWNlIHJlZmVyZW5jZSBjb3VudGluZyB0byBtcnMN
Cj4gICB2ZHBhL21seDU6IEFkZCBta2V5IGxlYWsgZGV0ZWN0aW9uDQo+IA0KPiAgZHJpdmVycy92
ZHBhL21seDUvY29yZS9tbHg1X3ZkcGEuaCB8ICAxMCArLQ0KPiAgZHJpdmVycy92ZHBhL21seDUv
Y29yZS9tci5jICAgICAgICB8ICA2OSArKysrKysrLS0tDQo+ICBkcml2ZXJzL3ZkcGEvbWx4NS9u
ZXQvbWx4NV92bmV0LmMgIHwgMTk0ICsrKysrKysrKysrKysrKysrKysrKysrKystLS0tDQo+ICBp
bmNsdWRlL2xpbnV4L21seDUvbWx4NV9pZmMuaCAgICAgIHwgICAzICstDQo+ICBpbmNsdWRlL2xp
bnV4L21seDUvbWx4NV9pZmNfdmRwYS5oIHwgICAxICsNCj4gIDUgZmlsZXMgY2hhbmdlZCwgMjM5
IGluc2VydGlvbnMoKyksIDM4IGRlbGV0aW9ucygtKQ0KPiANCg0KUGxlYXNlIGRpc3JlZ2FyZCB0
aGlzIHZlcnNpb24uIEkgd2lsbCBzZW5kIGEgdjQuIFNvcnJ5IGFib3V0IHRoZSBub2lzZS4NCg==

