Return-Path: <kvm+bounces-3326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2919D80315E
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 12:18:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D3247280E9D
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 11:18:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9708422EEB;
	Mon,  4 Dec 2023 11:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="owl4kYEH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2067.outbound.protection.outlook.com [40.107.92.67])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 390ABF2;
	Mon,  4 Dec 2023 03:18:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N0OrbPyreJHsWfw9T9zLDKzKMG/vwmjLlq+HZoohj6EAKQulo/xPm9+jsUppkC/nkEbt3w1bNJrOVqpbFTIt4SkcscopnW7zaT8ENucxNg4K+vEHjskCuB+tXYZmCr2N/Mo4NAzQFx58/0GSDsZJ75BXS0yPfzEP+GelqHjRmPgD7vMnZv9BJJyVRfazRESfKHB5doT8LKhZLEsRhEeVXu1fFDACLh39V4TkhhH5ArNns6l6ZH9LJWJzj3ZrD+I2deJpLWnn+T/yTBbxtbYIh5SzUANjVJ7QM4UTmTHGogbpZSI4bzFWN6PnpW4Nl7xW0b2KiWihKMGbJm0lnQLIHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S+ajSa1ufEm+NgGsAHlGcfmzEM7d34qX7xxOqLGNc8U=;
 b=WdjtdgD5oejMrsFJkRNpAMftDwY9qDfqXzrb4BazqJo/WieD1rwARf0LUiUjRo4gR9JxwHxv/c4Lg2+Rzx2f+X0r4PyZqVgIUuiOrBJAnvvKWME0fnaBUYUFC1Rb7g1l4L5TknPhxA3EeSuMouvlA96iCMxK15J38Upk9zDi+gTldFtffIinWMq1TqCHL6yFDCfs4heWITcnFoTppUOo0KW/Z3UDnEVwvbUW5Zii6biFZwLz8En6WMwc/spFwBGRkzhWpWMuQSwChXwR75br3WUCQh5Zx5I/QR5xCZhMhcI/RZD54FjB5NmmLJtooFifgBz8Vij0eu429SFwulNseg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S+ajSa1ufEm+NgGsAHlGcfmzEM7d34qX7xxOqLGNc8U=;
 b=owl4kYEHM0eADqMjaIkpoXpN1V1UZ3otTd6bGrb6WDHhqyUjNQVRdHV3zUaX3G51G8NlI5Ui1DUKJhsBA3Pnp2meYElBVbwy8igQX1iUl090w95YSSf0w2ClpT1DYaLTbCJSUVi79fbVRJAOIxSMkS9rx7xFe9g4WgwD4r6u6ZhawTPFnlR0EWQqHqCbZJCa0q9Nrhvk+gnBMWn5AxWhX6jBwbXOIO9YyoOFgmytEC4rOtu+11EAc1c/hfA3ihlJJnfXh8a2RcSbbOQ/N4GSN3N38yB7eUb2DiVWiCei/pdzJ2rVKCgNrlE0k4/x+8P8oYvnxMH2gIaXVL/OkwXlxg==
Received: from DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13)
 by LV2PR12MB5989.namprd12.prod.outlook.com (2603:10b6:408:171::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.33; Mon, 4 Dec
 2023 11:18:08 +0000
Received: from DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258]) by DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258%5]) with mapi id 15.20.7046.033; Mon, 4 Dec 2023
 11:18:08 +0000
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
 AQHaJEQPCu8G+as30EOn77AjCdP4t7CWcwSAgAE9GACAABGOAIABFHyAgAAAeoCAAAXdAIAAHlcAgAADwIA=
Date: Mon, 4 Dec 2023 11:18:08 +0000
Message-ID: <5b6d62f205b34ea25441b14313bb632f15f0c428.camel@nvidia.com>
References: <20231201104857.665737-1-dtatulea@nvidia.com>
	 <20231202152523-mutt-send-email-mst@kernel.org>
	 <aff0361edcb0fd0c384bf297e71d25fb77570e15.camel@nvidia.com>
	 <20231203112324-mutt-send-email-mst@kernel.org>
	 <e088b2ac7a197352429d2f5382848907f98c1129.camel@nvidia.com>
	 <20231204035443-mutt-send-email-mst@kernel.org>
	 <b9f5c48788daa3ac335b589b2ad23ea8366c08ba.camel@nvidia.com>
	 <20231204060300-mutt-send-email-mst@kernel.org>
In-Reply-To: <20231204060300-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.1 (3.50.1-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB5565:EE_|LV2PR12MB5989:EE_
x-ms-office365-filtering-correlation-id: a615c4ad-a0f4-4324-374b-08dbf4bab198
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 o/x/xvPRY1/5Zs51+miTwLQQuSi71ZPxjIxd2r91EdPW3eU4Ma97MbTfgbbQU9693Ec90LeEJtWPpzl6cilQsnwWYsny0Sv7LAF/bOG65VZ4RU7vcJm8BWjWURV+5kp7+2/BRvacPI9/7s4mYA6ppJFASJzx+/ToMsPMhJ1z5EMa7CIhxuPSBhuasWPGyCq3uHpxU1qtzxyqG6GwOgbeKiPYbc8pUPjIWB3/ODATyAGhOUMf4D6ZvVkG5zmGfWEfEr23oUmnHLifdJo/qDyw6E2AeVUXdNj661/toMCVFGochnFHCUqydl3xcgLnx6QIl1rqE/y7II7SFrLLQpZVhLDoMEqtMqpTYjcppQscg/NHknDMp3buTbPl1DDE3Hhdg1umuMlcu2mIlhK1rFGDL1OfusmM2vWCCpZTOgm27rZcpp03Ic5/S6kkDXcaSZd8Zf1/DSqzXAs/Gyi9CNBAzEQcTka4GDbCxDVQSokZc61+h744kadIsdjvSywgPbkXOa7HM2yksSHRVkIE+i6D3E5Og3tc9/TGf0kPl1B7/gqidWQKF0J+XCCfL9RdjR2mkUNFzxG9RzdE883xsNuiaTXi1ZE5/nQI755V3M4aVhUHkOmtdaehvYbe/o/aMhc2cWSGPWIGkrDn3nKEQG0i0nR25P2FtYhlWwOuUgkPrz8=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5565.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(39860400002)(366004)(346002)(136003)(230922051799003)(64100799003)(451199024)(186009)(1800799012)(86362001)(36756003)(2906002)(5660300002)(41300700001)(38070700009)(6506007)(6512007)(2616005)(83380400001)(478600001)(71200400001)(966005)(6486002)(38100700002)(122000001)(91956017)(8936002)(76116006)(66446008)(66476007)(66556008)(66946007)(54906003)(6916009)(64756008)(316002)(8676002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?K2psdVRKQ1ROb1NZUTJOQ0plbjZJYVE5Nnk4L0J0ZUVmQS8wakFiUndxL1lq?=
 =?utf-8?B?VytqcTVYa0V1enpuYnlRSkFWVEJCSWE3Y2hpSnZnM1lqSjA4NVRHNlRzemcr?=
 =?utf-8?B?SVk2aFVLRFlHVm5oWndUZG5Xci95bFdIejVsM2dsR1VzOTFYVTRPaDFMbmtF?=
 =?utf-8?B?dmFMMXBJbDRuTGI1cXZQUWpWVlpVc0JtM00wVzNhd1hVWUs2Wkt6M3pXNGln?=
 =?utf-8?B?QWpMNUFkNTF4MDZpYldDYzJKcXluZkFlOUIzK3Fsb0QrMGRJNmhKMWVGWXdB?=
 =?utf-8?B?RE1LeDFqYWNjT2hPUW9kUlB3TVdic3pXbTg5QU8vdnQ1M3BrenI1bnlDamhm?=
 =?utf-8?B?VWNBWjA1bnRyajZwN29TTnlabXBBTXJLaDBhdVptTGVWcHkzODJJZVozTnZo?=
 =?utf-8?B?YmxodlB4Y1RwOVdOSVdyb1BhcGRHVnVpMHhkK2plcUI5V28vSkxLZzU1NktP?=
 =?utf-8?B?UjhJOUtwUHRZd0hGczJ1bnhLUFozNXJsQldzZlV4NXFhZEhnNXNpMmVUcHdk?=
 =?utf-8?B?d2ZOeEo4QVB2TjA2SmNBemZwMkZmKzJWejA2ZW8xS3FlSCtTYTJWejdQRzNR?=
 =?utf-8?B?OGRoUUdpdUsrT2dJajN2OC9Da2k4NFdPc0pXUGhNTHlCMkhvMTJEMHppZ0tt?=
 =?utf-8?B?empRdFczdzJteTk0ZXdyeHZXMjRkVDIyZ0NXaFF6MTV1bE9iVXBsdkRyR051?=
 =?utf-8?B?MG1oanBibE4xN0wvQU1ieEN1M1B2b2NqUURPdXk3ayt2L0c4NUljQ0VOTU9k?=
 =?utf-8?B?VkpnckhGMklmSjZhSjJmR1hFQzA4aG8rY2RMbUlxaTJadlpKVVBsZG9XcXNR?=
 =?utf-8?B?TTlXNlNqaDRaaDEvY1VaVmtjUkd2QnNXUzZhd3NTMnlEZm13QkZ3RnhnZk9u?=
 =?utf-8?B?YUYzMHEzTVNxeHU3SGw0eUNPbFB1b3V5dWdnallQRklTbExFNExxKzdmK244?=
 =?utf-8?B?M2NFdzBsVTJ5a0VwODR2b0pBSEl1V3hWczZ5bDl3Y3M1ZDhrMlNCajIweWR2?=
 =?utf-8?B?TFExdEowV0tXc1pBU1JHRk9RTXoxaHhZSlJIZ3VHVThNQ2c5amQzUXA1QU81?=
 =?utf-8?B?ZDdHT0VIdE5hSFlsYUkzUklNeGdrWnl1Y202a1pGckVjL3dDZVh2UVpxc0JR?=
 =?utf-8?B?WEtsb2JuZlR4dXIycXlCc2tEZHFyMUhwR3E4UzRVTXZkOUVMRklsT0pFbUpz?=
 =?utf-8?B?U1ZlT01meHU1U1lGQnhSMXBKcjRsTEpxWVlmalZ5NWVyTFhxMU9BM281Wlla?=
 =?utf-8?B?UzdPNlh4OGRMNGE3V3NzZVZuRmNQWGtPM2xoWDBydlN2OG5NNW5ZYUhFQktK?=
 =?utf-8?B?ejVBSlFHMVdoMGx6aTJFR3hoanJMMzRBMXRnZVFCc1RqT25xcmxIVVZ2RnVB?=
 =?utf-8?B?SjFrZnFBcGFxc0VGcSs0aEhUcDB1RDVkdU04aWp6UDVuRFZRdEttSXUwMUFE?=
 =?utf-8?B?d0FsZlRRczF5bUwxZng2WmJCdkhVaW1OZUpsSnloTG9Reis2M2ZNSWI0aHgv?=
 =?utf-8?B?bjdQdFU4OXltYWhqeEVGNHpjRTlHMDZmQzVESkZWd2RPbDh0MWtkb2hzaHV1?=
 =?utf-8?B?TG93RTNHUDF1Ym4rR2l2cWxsd0E2Ujc4RG9HYnBQVklPUVN4UzVqUjVWK2ho?=
 =?utf-8?B?Uzd3bC9RQ3MzOTZ6UEQzZWtHTXBoaFkwcFltQjhwdTZiUjQ3RUZaek9YdWw5?=
 =?utf-8?B?MUFWMnZGVjRXYzJibnhqZklGRng2Wkg1dThZR1ZTNCt3ZEZvYjRFU1NtYkFF?=
 =?utf-8?B?dE1MS1YwOEt5NVhkMWZuQ05BM3FFNXVMUXpad2I5cFE3M2VVME9acFgwcVdZ?=
 =?utf-8?B?MW0xRXZrUWZrZ3dvWWxmS2I2ZVg3T0FuYTVDbzAzci8rak5tYUNLTnVMalky?=
 =?utf-8?B?UFJESCs1NGdTdTJWL2orQlVwYWl1dEg3Vm83NFAxaHdtMkFOak1WSFFNQ2lJ?=
 =?utf-8?B?TWYxci92bHVlbExWTVJZT3JveVE4a3M4NStYL0h1NnhmVzdWeXAyeS94N3hn?=
 =?utf-8?B?Tkp3bDZpUGFUeEE2K0ZsYTRCVS9LdVRJcnZqaWxjcDAyT1MyZzNOc3J4RjNs?=
 =?utf-8?B?MmFIeEROb0lxS1FsM3RnZGQ3N3RSNEpaeW5GNkgyWHpTRUhKUEw1dVJ0TnZE?=
 =?utf-8?B?MW5BY0hTQ29kclZmT3FONU1GSmJXU3lkT3RDMnpmYmxVVEpxVnpSWnBEQWkv?=
 =?utf-8?Q?Q653+Wl7dWzpfz49SkuCvZ7Xxsz3QhW3+CcBR9wdgWjz?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3D0DBA85CDE17A48B84B6F5EA8753B45@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a615c4ad-a0f4-4324-374b-08dbf4bab198
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2023 11:18:08.3587
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4YfbZpFxds5mM9YOgHUsLHFd0blnQtYHAtUwhKd6X3AKPTy7dSDea/BuwbcYgVbcOEEguSgR99ol3h6kZRS4Rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5989

T24gTW9uLCAyMDIzLTEyLTA0IGF0IDA2OjA0IC0wNTAwLCBNaWNoYWVsIFMuIFRzaXJraW4gd3Jv
dGU6DQo+IE9uIE1vbiwgRGVjIDA0LCAyMDIzIGF0IDA5OjE2OjA3QU0gKzAwMDAsIERyYWdvcyBU
YXR1bGVhIHdyb3RlOg0KPiA+IE9uIE1vbiwgMjAyMy0xMi0wNCBhdCAwMzo1NSAtMDUwMCwgTWlj
aGFlbCBTLiBUc2lya2luIHdyb3RlOg0KPiA+ID4gT24gTW9uLCBEZWMgMDQsIDIwMjMgYXQgMDg6
NTM6MjZBTSArMDAwMCwgRHJhZ29zIFRhdHVsZWEgd3JvdGU6DQo+ID4gPiA+IE9uIFN1biwgMjAy
My0xMi0wMyBhdCAxMToyMyAtMDUwMCwgTWljaGFlbCBTLiBUc2lya2luIHdyb3RlOg0KPiA+ID4g
PiA+IE9uIFN1biwgRGVjIDAzLCAyMDIzIGF0IDAzOjIxOjAxUE0gKzAwMDAsIERyYWdvcyBUYXR1
bGVhIHdyb3RlOg0KPiA+ID4gPiA+ID4gT24gU2F0LCAyMDIzLTEyLTAyIGF0IDE1OjI2IC0wNTAw
LCBNaWNoYWVsIFMuIFRzaXJraW4gd3JvdGU6DQo+ID4gPiA+ID4gPiA+IE9uIEZyaSwgRGVjIDAx
LCAyMDIzIGF0IDEyOjQ4OjUwUE0gKzAyMDAsIERyYWdvcyBUYXR1bGVhIHdyb3RlOg0KPiA+ID4g
PiA+ID4gPiA+IEFkZCBzdXBwb3J0IGZvciByZXN1bWFibGUgdnFzIGluIHRoZSBkcml2ZXIuIFRo
aXMgaXMgYSBmaXJtd2FyZSBmZWF0dXJlDQo+ID4gPiA+ID4gPiA+ID4gdGhhdCBjYW4gYmUgdXNl
ZCBmb3IgdGhlIGZvbGxvd2luZyBiZW5lZml0czoNCj4gPiA+ID4gPiA+ID4gPiAtIEZ1bGwgZGV2
aWNlIC5zdXNwZW5kLy5yZXN1bWUuDQo+ID4gPiA+ID4gPiA+ID4gLSAuc2V0X21hcCBkb2Vzbid0
IG5lZWQgdG8gZGVzdHJveSBhbmQgY3JlYXRlIG5ldyB2cXMgYW55bW9yZSBqdXN0IHRvDQo+ID4g
PiA+ID4gPiA+ID4gICB1cGRhdGUgdGhlIG1hcC4gV2hlbiByZXN1bWFibGUgdnFzIGFyZSBzdXBw
b3J0ZWQgaXQgaXMgZW5vdWdoIHRvDQo+ID4gPiA+ID4gPiA+ID4gICBzdXNwZW5kIHRoZSB2cXMs
IHNldCB0aGUgbmV3IG1hcHMsIGFuZCB0aGVuIHJlc3VtZSB0aGUgdnFzLg0KPiA+ID4gPiA+ID4g
PiA+IA0KPiA+ID4gPiA+ID4gPiA+IFRoZSBmaXJzdCBwYXRjaCBleHBvc2VzIHRoZSByZWxldmFu
dCBiaXRzIGluIG1seDVfaWZjLmguIFRoYXQgbWVhbnMgaXQNCj4gPiA+ID4gPiA+ID4gPiBuZWVk
cyB0byBiZSBhcHBsaWVkIHRvIHRoZSBtbHg1LXZob3N0IHRyZWUgWzBdIGZpcnN0Lg0KPiA+ID4g
PiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gSSBkaWRuJ3QgZ2V0IHRoaXMuIFdoeSBkb2VzIHRoaXMg
bmVlZCB0byBnbyB0aHJvdWdoIHRoYXQgdHJlZT8NCj4gPiA+ID4gPiA+ID4gSXMgdGhlcmUgYSBk
ZXBlbmRlbmN5IG9uIHNvbWUgb3RoZXIgY29tbWl0IGZyb20gdGhhdCB0cmVlPw0KPiA+ID4gPiA+
ID4gPiANCj4gPiA+ID4gPiA+IFRvIGF2b2lkIG1lcmdlIGlzc3VlcyBpbiBMaW51cydzIHRyZWUg
aW4gbWx4NV9pZmMuaC4gVGhlIGlkZWEgaXMgdGhlIHNhbWUgYXMgZm9yDQo+ID4gPiA+ID4gPiB0
aGUgInZxIGRlc2NyaXB0b3IgbWFwcGluZ3MiIHBhdGNoc2V0IFsxXS4NCj4gPiA+ID4gPiA+IA0K
PiA+ID4gPiA+ID4gVGhhbmtzLA0KPiA+ID4gPiA+ID4gRHJhZ29zDQo+ID4gPiA+ID4gDQo+ID4g
PiA+ID4gQXJlIHRoZXJlIG90aGVyIGNoYW5nZXMgaW4gdGhhdCBhcmVhIHRoYXQgd2lsbCBjYXVz
ZSBub24tdHJpdmlhbCBtZXJnZQ0KPiA+ID4gPiA+IGNvbmZsaWN0cz8NCj4gPiA+ID4gPiANCj4g
PiA+ID4gVGhlcmUgYXJlIHBlbmRpbmcgY2hhbmdlcyBpbiBtbHg1X2lmYy5oIGZvciBuZXQtbmV4
dC4gSSBoYXZlbid0IHNlZW4gYW55IGNoYW5nZXMNCj4gPiA+ID4gYXJvdW5kIHRoZSB0b3VjaGVk
IHN0cnVjdHVyZSBidXQgSSB3b3VsZCBwcmVmZXIgbm90IHRvIHRha2UgYW55IHJpc2suDQo+ID4g
PiA+IA0KPiA+ID4gPiBUaGFua3MsDQo+ID4gPiA+IERyYWdvcw0KPiA+ID4gDQo+ID4gPiBUaGlz
IGlzIGV4YWN0bHkgd2hhdCBsaW51eC1uZXh0IGlzIGZvci4NCj4gPiA+IA0KPiA+IE5vdCBzdXJl
IHdoYXQgdGhlIHN1Z2dlc3Rpb24gaXMgaGVyZS4gSXMgaXQ6DQo+ID4gDQo+ID4gMSkgVG8gcG9z
dCBwYXRjaCAxLzcgdG8gbmV0LW5leHQ/IFRoZW4gd2UnZCBoYXZlIHRvIHdhaXQgZm9yIGEgZmV3
IHdlZWtzIHRvIG1ha2UNCj4gPiBzdXJlIHRoYXQgaXQgZ2V0cyBpbnRvIHRoZSBuZXh0IHRyZWUu
DQo+ID4gDQo+ID4gb3IgDQo+ID4gDQo+ID4gMikgVG8gYXBwbHkgaXQgaW50byB0aGUgdmhvc3Qg
dHJlZSBkaXJlY3RseT8gVGhlbiB3ZSBydW4gdGhlIHJpc2sgb2YgaGF2aW5nDQo+ID4gbWVyZ2Ug
aXNzdWVzLg0KPiA+IA0KPiA+IFRoZSAicHVsbCBmcm9tIGJyYW5jaCIgYXBwcm9hY2ggZm9yIGNy
b3NzIHN1YnN5c3RlbSBjaGFuZ2VzIHdhcyBzdWdnZXN0ZWQgYnkNCj4gPiBMaW51cyB0aGlzIG1l
cmdlIGlzc3VlLg0KPiA+IA0KPiA+IFswXQ0KPiA+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2Fs
bC9DQSs1NWFGeHhvTz1pN25lR0JSR1dfYWZIc1NaN0steDZmTU84di04cG8zTHNfRXcwUmdAbWFp
bC5nbWFpbC5jb20vDQo+ID4gDQo+ID4gVGhhbmtzLA0KPiA+IERyYWdvcw0KPiANCj4gSSB3aWxs
IHBhcmsgdGhpcyBpbiBteSB0cmVlIGZvciBub3cgc28gaXQgY2FuIGdldCB0ZXN0aW5nIGluIGxp
bnV4IG5leHQuDQo+IFdoZW4gaXQncyBhdmFpbGFibGUgaW4gc29tZSBvdGhlciB0cmVlIGFzIHdl
bGwsIGxldCBtZSBrbm93IGFuZA0KPiBJJ2xsIGZpZ3VyZSBpdCBvdXQuDQo+IA0KVGhhbmtzISBC
dXQgZG9uJ3QgcGFyayBpdCBqdXN0IHlldC4gSSB3b3VsZCBsaWtlIHRvIHNlbmQgYSB2MiBpbiB0
aGUgbmV4dCBmZXcNCmRheXMgdGhhdCBjb250YWlucyAyIG1vcmUgcGF0Y2hlcyBvbiB0b3AuIEkn
dmUgc2VudCB0aGUgdjEgZWFybHkgdG8gZ2V0IHJldmlld3MNCmZvciB0aGUgYnVsayBvZiB0aGUg
d29yay4gRm9yZ290IHRvIG1lbnRpb24gdGhhdCBpbiB0aGUgY292ZXIgbGV0dGVyLiBNeSBiYWQs
DQpzb3JyeS4NCg0KVGhhbmtzLA0KRHJhZ29zDQoNCg==

