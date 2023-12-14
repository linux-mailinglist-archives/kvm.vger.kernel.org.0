Return-Path: <kvm+bounces-4496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E60FB8131C9
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 14:40:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9A25C28337F
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 13:40:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D866B56B72;
	Thu, 14 Dec 2023 13:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XBuaKgD1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2052.outbound.protection.outlook.com [40.107.243.52])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C174C111;
	Thu, 14 Dec 2023 05:39:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kRuLqEzBXZ93O12UVYTjsd4OIVl4fJOidfDBECIllCprs2/wmrFxajppCUmke0tP4Slfy8C4HAVXrVGEadJpYA1Ck+KO6vNDcrASat1KlMObOhsmp+YBEWqV+cxk1zB8GSOtGruJ8L2R047XCB/AhwbXK3+uHbMlHpsBewO/bpYei+Op7/uaHLOP3ASO2PO8rNyEESU6w4Hpn/OzqCMOM1dZdGY8xo13/3ugMlsURBDxUN5pV3Cg3UQ2PcA1A83mkDHW0t7l85VSLQXp8uaufUonuYq+XsvsrNQO0Ri6H4dofaHEn/riecqeydl6QeRav6oqW07vgRFZr0eytj5nYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QYOzu3QyRJuCdHjBRHMNnBPnwx96ylJZ4FtHos1u718=;
 b=Y1uPefHzLeSzxdw8zng1vTrZAYf37CI7vBXHtSxSO02pgaL2CFkzn4Tiz+8I8lklSfBteqmH1V7mUr9bLrTMKhPOtoEVtJgHS3mBHfi3vpnwqkapuFwBF+zSrd3IF33DooB5aW//cFWYcN+CpzK7Ew973TRTwNf+oj+Aw7vwYCyZHtyoWeywddcnfcqyjAkS9o8O8w3/NSALC0iX7GHYxtXmMK9uagODEvqAGlIeg+71BwnM5O3ePguKu1N65go7N1iWqim9m7UTZhMWOhSrkd6ZGvG0Imo0FsKHyCBziMFuDSJ5RytuXTx6quS1KpTajTneKX+4YwdVzRDmX5nzpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QYOzu3QyRJuCdHjBRHMNnBPnwx96ylJZ4FtHos1u718=;
 b=XBuaKgD1Po3N9WKun0Qyb0MrHIo1RiH9z3tWhytSuklbM7j70aqlzvEJGkkY858LRIZrLE2pccb0KA7gFn86UrisdwZeUadXTMd9ys/eYTp3hI/ZE073KqYRmfFf5Zbs2PfMyF7SWJi2BPJUQPhUmeWuNp9PL0q/JHlxFl15QQV29HJnyiAYYF8HrjV5dH5pCgQ+bjRamjPOnSTnCM1OHYWUv62tyOhOLUCZ+a+bKV66PKLo5VglXORZC2wNWKORNMfKtn5TrDOgwjhMcgVouIdjcK2M6m3sJwi0Zh4BUBs5izLZb4W5TM1CYHM3lORtN/rran1YNMIwnODGlcsPnA==
Received: from DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13)
 by DS0PR12MB8575.namprd12.prod.outlook.com (2603:10b6:8:164::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.28; Thu, 14 Dec
 2023 13:39:55 +0000
Received: from DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258]) by DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258%5]) with mapi id 15.20.7091.028; Thu, 14 Dec 2023
 13:39:55 +0000
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "si-wei.liu@oracle.com" <si-wei.liu@oracle.com>, "eperezma@redhat.com"
	<eperezma@redhat.com>
CC: "xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>, Parav Pandit
	<parav@nvidia.com>, "virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, Gal Pressman <gal@nvidia.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "mst@redhat.com"
	<mst@redhat.com>, Saeed Mahameed <saeedm@nvidia.com>, "jasowang@redhat.com"
	<jasowang@redhat.com>, "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH vhost v2 4/8] vdpa/mlx5: Mark vq addrs for modification in
 hw vq
Thread-Topic: [PATCH vhost v2 4/8] vdpa/mlx5: Mark vq addrs for modification
 in hw vq
Thread-Index: AQHaJ2ha4Gy9JBIWuEWZX8/WZ4ytmbCmEe0AgABJawCAAnvhAA==
Date: Thu, 14 Dec 2023 13:39:55 +0000
Message-ID: <075cf7d1ada0ee4ee30d46b993a1fe21acfe9d92.camel@nvidia.com>
References: <20231205104609.876194-1-dtatulea@nvidia.com>
	 <20231205104609.876194-5-dtatulea@nvidia.com>
	 <CAJaqyWeEY9LNTE8QEnJgLhgS7HiXr5gJEwwPBrC3RRBsAE4_7Q@mail.gmail.com>
	 <27312106-07b9-4719-970c-b8e1aed7c4eb@oracle.com>
In-Reply-To: <27312106-07b9-4719-970c-b8e1aed7c4eb@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.2 (3.50.2-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB5565:EE_|DS0PR12MB8575:EE_
x-ms-office365-filtering-correlation-id: 77adcfa2-d7f3-47f0-3059-08dbfcaa2879
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 bzMq49DjloIreN7VllG8PLdocfbyIIlpZwubi45UqiG2UihWCsrKymzfKHLwb91pq2mrRBXJJwNmeaPxfXeF+ozry5MppQxIaDId9MZymbwEkOFvx3oALnPX2R9xLW96FhIi9UyK6pEVp0peCw0zCN/64De9xT8lDyGm0ZyrmNYNiCnXi4NPu6oo2hWoqyAHmgsPpzzFLtZBEeHXotGefKfFpeyKZfisSTBNinvMFdYbsFmeYrN3sehZN6GWoLZEA9qqfsXtTPdfXABMKM+OdCeDENwXXYHcWqvDt6B/kEkE280ZneWBZJ+6Qc8LRH6VUQACy1ptsM3Rt5V13X9SZMXnc8r8A3Hwz5oP5A4BvPNepA/+vPGbqSf5Ke1x1NDb4Ks2WsZXkieUgjlBO8w6O1Faa1z+5FSj8H5JLyd8eKneNcYwvfeUu7lq+IZe4NMKj3nDptEo1RsynNhSF00PHRKDwT7hPCt0vtsj6y85S7A09wEueg6QkU6HqaHweEnu1MoKWkux1heKnValQt3ApRpunSv1rsB2cShkrH9a+w2x3dusc31xP8C9FSSvRGkZ+hZwwUJh+k8nMmHfm112eEgW4C6lwchdBm3UyIcdpozYuAs80xY5LBRuJqr0xJM9jyAJNFxEnHlOWry5bCJRJzf25GXxOYSXyqpZLK5d2YE=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5565.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(396003)(136003)(366004)(346002)(230922051799003)(186009)(1800799012)(64100799003)(451199024)(4326008)(8676002)(8936002)(316002)(83380400001)(36756003)(38100700002)(41300700001)(86362001)(38070700009)(4001150100001)(2906002)(122000001)(5660300002)(2616005)(54906003)(966005)(6486002)(478600001)(6506007)(53546011)(6512007)(71200400001)(91956017)(66574015)(110136005)(66446008)(66946007)(66556008)(64756008)(66476007)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aVNDcysveHpPK3p1Mjl6cStLMEJET1BMMGpTc2Y2R2dlYzJnT1hKSzl3RlBR?=
 =?utf-8?B?UmthSGxYbVVWS2dORUN2U3duWWJRc3pUUldpaW15WU9OK2hVaFdpZGtCRDd3?=
 =?utf-8?B?Rlp3UktUSHdZUzFyQ3BMUzZDbStwOWFDNHdXL0NUejB1YjN3Q1hqeUtZVFdX?=
 =?utf-8?B?R2dobDQwMGNFWjhvQkV3QUZBb0U1U0Z6MFpZL1BCQy9sR1R5NzJoYVdmVVFS?=
 =?utf-8?B?ZmFIWDJ5V3E4OFR2NkZQbmY3eFMyZGNIeWE1RkNkVEJNZ1RYNXR1ZEJPYnI1?=
 =?utf-8?B?NDVTYzRKYnVEZEpGdmJCaFppZkhJSWkxejVzc3VJbTF4TDdac25BUFRXUXBs?=
 =?utf-8?B?S1k4T2drckwyaVdLL0lScHFwYmVpeFEzYW5jNUFFUVRzUHBHS05ob1RWYlVm?=
 =?utf-8?B?UFhzSS8vRjFLcUVxaWxnN1o4YmJCTmdTRWZ5c0tST1paVTV1V2U4SkFPZlI1?=
 =?utf-8?B?U2ZpSnpDQ0lUWnhjWkpVTEwvekRaTFdiOHp4bWtEaFhnWG1XY2xkQjlia0Vs?=
 =?utf-8?B?UklGekJiaTdjNTAvRklmQXFlai9RaTZ2dWUrT2hrS0V6bk5hTWVKdkkxUUJi?=
 =?utf-8?B?ZXZldTh2aEl1TkpKcUh1S0gxZ1c1SnJ5Rkl5YzcxTTg1WE5WT2s4dnUxZ3ZF?=
 =?utf-8?B?VGMwZ0JGSnh2cXhMSnp3TU1SNUo5M0Ivckl5c0FmOEEyN205aVdXMUx5bVpQ?=
 =?utf-8?B?ZlFvdi8wUXhXWlZGbUZjNHlpMmdpaXAvZGx4N2VySWd1L2hQNkJDRml1MnJx?=
 =?utf-8?B?RU5rYzJOTEkrK2lzRXFzSXdER1RVNnV0anlUNTlHaDBscmpNSWdiV3ZObEkw?=
 =?utf-8?B?bjE3c0NIQWZkVVpoY3BubHR0eDlCSFA3U1lkbUVMQ1lxR1RwalRQWWFUcVI5?=
 =?utf-8?B?NkRwd2xuZUl5WVFtTXVPTkVOOVoycnlCZ2loOHpaZ05wS01rWmRZbjR3QnVF?=
 =?utf-8?B?cUFVTkRJTERMKzFocFZFZ05qU1B4MUVpSEdXVWZ5ZzhkR1psOEViK0h3amZm?=
 =?utf-8?B?OXZYMDFydzhqVUlHYzFxeHllU3N1YXNIbDdwaW5pRjFEMng2UVFMd0NZMXd5?=
 =?utf-8?B?NXdydG52dWJ2K1dteGJQeVVBa2d4eThVTW9ZQ3FqKzlzaXN5dUVPOVhPcTJ6?=
 =?utf-8?B?WTZGTzNFSkNaL0M3NzhDamV4dldoWHNzZk0rcHc3NzhIblQwVk9MeklDeE1W?=
 =?utf-8?B?bzE5b1Q3dmVieHJxUTdmbE85UW9pdjladHBadlJodENiOUREbnJCSVlOREMz?=
 =?utf-8?B?aUhFTmpvKzdRVWFuUGZzSmJoak4wYjRoWlNRVEErZytZQWo5RlpuTVh4Y0pi?=
 =?utf-8?B?dTJsMFY0NHByMVZIS3hTSXl3K3k1M1IrOExQZVMrZFhLNTBoaGY2ZlJ3K29I?=
 =?utf-8?B?MGF6M1hPTmNYVTYwRGRwVktXdWwxM2d4c1RXYTdzbGZFdVNPdXk2MEFEKzdn?=
 =?utf-8?B?QmNQZE43VXlyTitQdWVHYXM1UXhNb3dPK05nOSthaEpGSTFvRWVyY3hEWUNl?=
 =?utf-8?B?WVI3NDFTM0l3Q2dGQU1hZFcvbnluYkx3SEFjc1YybHg2eVRWL0RtNFlyL05F?=
 =?utf-8?B?VFZsdExpc3BoRk8yZ2p0eXRNblQ3eERLYVVMdVRWMWxCZUN6RTVOcVMveEFv?=
 =?utf-8?B?UDNsS01nMmtRVGJzaFp4OGhGOGF5Ylo5R01TVysxcjcySHc4ckRpak96bUFT?=
 =?utf-8?B?MzYyNmRMVCtFNGlFZThwSXNtUTFhcGNmYThMZnEzeVpWSE1DQjNLWnlUQ2hk?=
 =?utf-8?B?MU8zWEk4NWNZUEw4bzNCUmdlYXVkMjQxOFZpYXUyTTlqbm5JckUxRzk4NVl2?=
 =?utf-8?B?OXVGY1Z6WUp2RnF6bzRuNWVHdkorL0hCUmZhSGpiZUt6aktnK3ZlQ2xiblNr?=
 =?utf-8?B?bG9KODMveTJkWWUvQkJIdHdhRmQ1YWQxMmVnamNWVmp3QloyR1RCWGg1NXc0?=
 =?utf-8?B?VlVuOUVMRjhtM0RobHl2a3FGWm1vTWludFoyeHVQZER0RlBBTFlMRnNtV1I2?=
 =?utf-8?B?MTVuZGhrdVZIdmMvUStHMVBhaHdoaldnTU14WmlkSklac2tOcEJQRVJIcG5p?=
 =?utf-8?B?ZG5ZSjdmaVlWZ3RJVXprZzZaWEVFOHZ0RnkxMG1VU2FOOVdNbGlDdy96ZS8z?=
 =?utf-8?B?SjMxYStzQnVoZDNueHRHR0lRL25oa2wvNVRxZlNqTk94TldYRHdhZC9XSjdK?=
 =?utf-8?Q?XPZfwX824AKXY24zwLrw75JgopwgQtf8It1k8z6TquaX?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E7682AFA95003E49BDE717DADDD612B8@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 77adcfa2-d7f3-47f0-3059-08dbfcaa2879
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2023 13:39:55.6598
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f9O2qlCIJp/KVeiu6Qhnj+1JnQEmusIl/bDeG82h791FOROPBIDMNf2aIGGhBNMPpfqTZNG53VIQQdMtcemnOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8575

T24gVHVlLCAyMDIzLTEyLTEyIGF0IDE1OjQ0IC0wODAwLCBTaS1XZWkgTGl1IHdyb3RlOg0KPiAN
Cj4gT24gMTIvMTIvMjAyMyAxMToyMSBBTSwgRXVnZW5pbyBQZXJleiBNYXJ0aW4gd3JvdGU6DQo+
ID4gT24gVHVlLCBEZWMgNSwgMjAyMyBhdCAxMTo0NuKAr0FNIERyYWdvcyBUYXR1bGVhIDxkdGF0
dWxlYUBudmlkaWEuY29tPiB3cm90ZToNCj4gPiA+IEFkZHJlc3NlcyBnZXQgc2V0IGJ5IC5zZXRf
dnFfYWRkcmVzcy4gaHcgdnEgYWRkcmVzc2VzIHdpbGwgYmUgdXBkYXRlZCBvbg0KPiA+ID4gbmV4
dCBtb2RpZnlfdmlydHF1ZXVlLg0KPiA+ID4gDQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBEcmFnb3Mg
VGF0dWxlYSA8ZHRhdHVsZWFAbnZpZGlhLmNvbT4NCj4gPiA+IFJldmlld2VkLWJ5OiBHYWwgUHJl
c3NtYW4gPGdhbEBudmlkaWEuY29tPg0KPiA+ID4gQWNrZWQtYnk6IEV1Z2VuaW8gUMOpcmV6IDxl
cGVyZXptYUByZWRoYXQuY29tPg0KPiA+IEknbSBraW5kIG9mIG9rIHdpdGggdGhpcyBwYXRjaCBh
bmQgdGhlIG5leHQgb25lIGFib3V0IHN0YXRlLCBidXQgSQ0KPiA+IGRpZG4ndCBhY2sgdGhlbSBp
biB0aGUgcHJldmlvdXMgc2VyaWVzLg0KPiA+IA0KPiA+IE15IG1haW4gY29uY2VybiBpcyB0aGF0
IGl0IGlzIG5vdCB2YWxpZCB0byBjaGFuZ2UgdGhlIHZxIGFkZHJlc3MgYWZ0ZXINCj4gPiBEUklW
RVJfT0sgaW4gVmlydElPLCB3aGljaCB2RFBBIGZvbGxvd3MuIE9ubHkgbWVtb3J5IG1hcHMgYXJl
IG9rIHRvDQo+ID4gY2hhbmdlIGF0IHRoaXMgbW9tZW50LiBJJ20gbm90IHN1cmUgYWJvdXQgdnEg
c3RhdGUgaW4gdkRQQSwgYnV0IHZob3N0DQo+ID4gZm9yYmlkcyBjaGFuZ2luZyBpdCB3aXRoIGFu
IGFjdGl2ZSBiYWNrZW5kLg0KPiA+IA0KPiA+IFN1c3BlbmQgaXMgbm90IGRlZmluZWQgaW4gVmly
dElPIGF0IHRoaXMgbW9tZW50IHRob3VnaCwgc28gbWF5YmUgaXQgaXMNCj4gPiBvayB0byBkZWNp
ZGUgdGhhdCBhbGwgb2YgdGhlc2UgcGFyYW1ldGVycyBtYXkgY2hhbmdlIGR1cmluZyBzdXNwZW5k
Lg0KPiA+IE1heWJlIHRoZSBiZXN0IHRoaW5nIGlzIHRvIHByb3RlY3QgdGhpcyB3aXRoIGEgdkRQ
QSBmZWF0dXJlIGZsYWcuDQo+IEkgdGhpbmsgcHJvdGVjdCB3aXRoIHZEUEEgZmVhdHVyZSBmbGFn
IGNvdWxkIHdvcmssIHdoaWxlIG9uIHRoZSBvdGhlciANCj4gaGFuZCB2RFBBIG1lYW5zIHZlbmRv
ciBzcGVjaWZpYyBvcHRpbWl6YXRpb24gaXMgcG9zc2libGUgYXJvdW5kIHN1c3BlbmQgDQo+IGFu
ZCByZXN1bWUgKGluIGNhc2UgaXQgaGVscHMgcGVyZm9ybWFuY2UpLCB3aGljaCBkb2Vzbid0IGhh
dmUgdG8gYmUgDQo+IGJhY2tlZCBieSB2aXJ0aW8gc3BlYy4gU2FtZSBhcHBsaWVzIHRvIHZob3N0
IHVzZXIgYmFja2VuZCBmZWF0dXJlcywgDQo+IHZhcmlhdGlvbnMgdGhlcmUgd2VyZSBub3QgYmFj
a2VkIGJ5IHNwZWMgZWl0aGVyLiBPZiBjb3Vyc2UsIHdlIHNob3VsZCANCj4gdHJ5IGJlc3QgdG8g
bWFrZSB0aGUgZGVmYXVsdCBiZWhhdmlvciBiYWNrd2FyZCBjb21wYXRpYmxlIHdpdGggDQo+IHZp
cnRpby1iYXNlZCBiYWNrZW5kLCBidXQgdGhhdCBjaXJjbGVzIGJhY2sgdG8gbm8gc3VzcGVuZCBk
ZWZpbml0aW9uIGluIA0KPiB0aGUgY3VycmVudCB2aXJ0aW8gc3BlYywgZm9yIHdoaWNoIEkgaG9w
ZSB3ZSBkb24ndCBjZWFzZSBkZXZlbG9wbWVudCBvbiANCj4gdkRQQSBpbmRlZmluaXRlbHkuIEFm
dGVyIGFsbCwgdGhlIHZpcnRpbyBiYXNlZCB2ZGFwIGJhY2tlbmQgY2FuIHdlbGwgDQo+IGRlZmlu
ZSBpdHMgb3duIGZlYXR1cmUgZmxhZyB0byBkZXNjcmliZSAobWlub3IgZGlmZmVyZW5jZSBpbikg
dGhlIA0KPiBzdXNwZW5kIGJlaGF2aW9yIGJhc2VkIG9uIHRoZSBsYXRlciBzcGVjIG9uY2UgaXQg
aXMgZm9ybWVkIGluIGZ1dHVyZS4NCj4gDQpTbyB3aGF0IGlzIHRoZSB3YXkgZm9yd2FyZCBoZXJl
PyBGcm9tIHdoYXQgSSB1bmRlcnN0YW5kIHRoZSBvcHRpb25zIGFyZToNCg0KMSkgQWRkIGEgdmRw
YSBmZWF0dXJlIGZsYWcgZm9yIGNoYW5naW5nIGRldmljZSBwcm9wZXJ0aWVzIHdoaWxlIHN1c3Bl
bmRlZC4NCg0KMikgRHJvcCB0aGVzZSAyIHBhdGNoZXMgZnJvbSB0aGUgc2VyaWVzIGZvciBub3cu
IE5vdCBzdXJlIGlmIHRoaXMgbWFrZXMgc2Vuc2UgYXMNCnRoaXMuIEJ1dCB0aGVuIFNpLVdlaSdz
IHFlbXUgZGV2aWNlIHN1c3BlbmQvcmVzdW1lIHBvYyBbMF0gdGhhdCBleGVyY2lzZXMgdGhpcw0K
Y29kZSB3b24ndCB3b3JrIGFueW1vcmUuIFRoaXMgbWVhbnMgdGhlIHNlcmllcyB3b3VsZCBiZSBs
ZXNzIHdlbGwgdGVzdGVkLg0KDQpBcmUgdGhlcmUgb3RoZXIgcG9zc2libGUgb3B0aW9ucz8gV2hh
dCBkbyB5b3UgdGhpbms/DQoNClswXSBodHRwczovL2dpdGh1Yi5jb20vc2l3bGl1LWtlcm5lbC9x
ZW11L3RyZWUvc3ZxLXJlc3VtZS13aXANCg0KVGhhbmtzLA0KRHJhZ29zDQoNCj4gUmVnYXJkcywN
Cj4gLVNpd2VpDQo+IA0KPiANCj4gDQo+ID4gDQo+ID4gSmFzb24sIHdoYXQgZG8geW91IHRoaW5r
Pw0KPiA+IA0KPiA+IFRoYW5rcyENCj4gPiANCj4gPiA+IC0tLQ0KPiA+ID4gICBkcml2ZXJzL3Zk
cGEvbWx4NS9uZXQvbWx4NV92bmV0LmMgIHwgOSArKysrKysrKysNCj4gPiA+ICAgaW5jbHVkZS9s
aW51eC9tbHg1L21seDVfaWZjX3ZkcGEuaCB8IDEgKw0KPiA+ID4gICAyIGZpbGVzIGNoYW5nZWQs
IDEwIGluc2VydGlvbnMoKykNCj4gPiA+IA0KPiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmRw
YS9tbHg1L25ldC9tbHg1X3ZuZXQuYyBiL2RyaXZlcnMvdmRwYS9tbHg1L25ldC9tbHg1X3ZuZXQu
Yw0KPiA+ID4gaW5kZXggZjhmMDg4Y2NlZDUwLi44MGUwNjZkZTA4NjYgMTAwNjQ0DQo+ID4gPiAt
LS0gYS9kcml2ZXJzL3ZkcGEvbWx4NS9uZXQvbWx4NV92bmV0LmMNCj4gPiA+ICsrKyBiL2RyaXZl
cnMvdmRwYS9tbHg1L25ldC9tbHg1X3ZuZXQuYw0KPiA+ID4gQEAgLTEyMDksNiArMTIwOSw3IEBA
IHN0YXRpYyBpbnQgbW9kaWZ5X3ZpcnRxdWV1ZShzdHJ1Y3QgbWx4NV92ZHBhX25ldCAqbmRldiwN
Cj4gPiA+ICAgICAgICAgIGJvb2wgc3RhdGVfY2hhbmdlID0gZmFsc2U7DQo+ID4gPiAgICAgICAg
ICB2b2lkICpvYmpfY29udGV4dDsNCj4gPiA+ICAgICAgICAgIHZvaWQgKmNtZF9oZHI7DQo+ID4g
PiArICAgICAgIHZvaWQgKnZxX2N0eDsNCj4gPiA+ICAgICAgICAgIHZvaWQgKmluOw0KPiA+ID4g
ICAgICAgICAgaW50IGVycjsNCj4gPiA+IA0KPiA+ID4gQEAgLTEyMzAsNiArMTIzMSw3IEBAIHN0
YXRpYyBpbnQgbW9kaWZ5X3ZpcnRxdWV1ZShzdHJ1Y3QgbWx4NV92ZHBhX25ldCAqbmRldiwNCj4g
PiA+ICAgICAgICAgIE1MWDVfU0VUKGdlbmVyYWxfb2JqX2luX2NtZF9oZHIsIGNtZF9oZHIsIHVp
ZCwgbmRldi0+bXZkZXYucmVzLnVpZCk7DQo+ID4gPiANCj4gPiA+ICAgICAgICAgIG9ial9jb250
ZXh0ID0gTUxYNV9BRERSX09GKG1vZGlmeV92aXJ0aW9fbmV0X3FfaW4sIGluLCBvYmpfY29udGV4
dCk7DQo+ID4gPiArICAgICAgIHZxX2N0eCA9IE1MWDVfQUREUl9PRih2aXJ0aW9fbmV0X3Ffb2Jq
ZWN0LCBvYmpfY29udGV4dCwgdmlydGlvX3FfY29udGV4dCk7DQo+ID4gPiANCj4gPiA+ICAgICAg
ICAgIGlmIChtdnEtPm1vZGlmaWVkX2ZpZWxkcyAmIE1MWDVfVklSVFFfTU9ESUZZX01BU0tfU1RB
VEUpIHsNCj4gPiA+ICAgICAgICAgICAgICAgICAgaWYgKCFpc192YWxpZF9zdGF0ZV9jaGFuZ2Uo
bXZxLT5md19zdGF0ZSwgc3RhdGUsIGlzX3Jlc3VtYWJsZShuZGV2KSkpIHsNCj4gPiA+IEBAIC0x
MjQxLDYgKzEyNDMsMTIgQEAgc3RhdGljIGludCBtb2RpZnlfdmlydHF1ZXVlKHN0cnVjdCBtbHg1
X3ZkcGFfbmV0ICpuZGV2LA0KPiA+ID4gICAgICAgICAgICAgICAgICBzdGF0ZV9jaGFuZ2UgPSB0
cnVlOw0KPiA+ID4gICAgICAgICAgfQ0KPiA+ID4gDQo+ID4gPiArICAgICAgIGlmIChtdnEtPm1v
ZGlmaWVkX2ZpZWxkcyAmIE1MWDVfVklSVFFfTU9ESUZZX01BU0tfVklSVElPX1FfQUREUlMpIHsN
Cj4gPiA+ICsgICAgICAgICAgICAgICBNTFg1X1NFVDY0KHZpcnRpb19xLCB2cV9jdHgsIGRlc2Nf
YWRkciwgbXZxLT5kZXNjX2FkZHIpOw0KPiA+ID4gKyAgICAgICAgICAgICAgIE1MWDVfU0VUNjQo
dmlydGlvX3EsIHZxX2N0eCwgdXNlZF9hZGRyLCBtdnEtPmRldmljZV9hZGRyKTsNCj4gPiA+ICsg
ICAgICAgICAgICAgICBNTFg1X1NFVDY0KHZpcnRpb19xLCB2cV9jdHgsIGF2YWlsYWJsZV9hZGRy
LCBtdnEtPmRyaXZlcl9hZGRyKTsNCj4gPiA+ICsgICAgICAgfQ0KPiA+ID4gKw0KPiA+ID4gICAg
ICAgICAgTUxYNV9TRVQ2NCh2aXJ0aW9fbmV0X3Ffb2JqZWN0LCBvYmpfY29udGV4dCwgbW9kaWZ5
X2ZpZWxkX3NlbGVjdCwgbXZxLT5tb2RpZmllZF9maWVsZHMpOw0KPiA+ID4gICAgICAgICAgZXJy
ID0gbWx4NV9jbWRfZXhlYyhuZGV2LT5tdmRldi5tZGV2LCBpbiwgaW5sZW4sIG91dCwgc2l6ZW9m
KG91dCkpOw0KPiA+ID4gICAgICAgICAgaWYgKGVycikNCj4gPiA+IEBAIC0yMjAyLDYgKzIyMTAs
NyBAQCBzdGF0aWMgaW50IG1seDVfdmRwYV9zZXRfdnFfYWRkcmVzcyhzdHJ1Y3QgdmRwYV9kZXZp
Y2UgKnZkZXYsIHUxNiBpZHgsIHU2NCBkZXNjXw0KPiA+ID4gICAgICAgICAgbXZxLT5kZXNjX2Fk
ZHIgPSBkZXNjX2FyZWE7DQo+ID4gPiAgICAgICAgICBtdnEtPmRldmljZV9hZGRyID0gZGV2aWNl
X2FyZWE7DQo+ID4gPiAgICAgICAgICBtdnEtPmRyaXZlcl9hZGRyID0gZHJpdmVyX2FyZWE7DQo+
ID4gPiArICAgICAgIG12cS0+bW9kaWZpZWRfZmllbGRzIHw9IE1MWDVfVklSVFFfTU9ESUZZX01B
U0tfVklSVElPX1FfQUREUlM7DQo+ID4gPiAgICAgICAgICByZXR1cm4gMDsNCj4gPiA+ICAgfQ0K
PiA+ID4gDQo+ID4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9tbHg1L21seDVfaWZjX3Zk
cGEuaCBiL2luY2x1ZGUvbGludXgvbWx4NS9tbHg1X2lmY192ZHBhLmgNCj4gPiA+IGluZGV4IGI4
NmQ1MWE4NTVmNi4uOTU5NGFjNDA1NzQwIDEwMDY0NA0KPiA+ID4gLS0tIGEvaW5jbHVkZS9saW51
eC9tbHg1L21seDVfaWZjX3ZkcGEuaA0KPiA+ID4gKysrIGIvaW5jbHVkZS9saW51eC9tbHg1L21s
eDVfaWZjX3ZkcGEuaA0KPiA+ID4gQEAgLTE0NSw2ICsxNDUsNyBAQCBlbnVtIHsNCj4gPiA+ICAg
ICAgICAgIE1MWDVfVklSVFFfTU9ESUZZX01BU0tfU1RBVEUgICAgICAgICAgICAgICAgICAgID0g
KHU2NCkxIDw8IDAsDQo+ID4gPiAgICAgICAgICBNTFg1X1ZJUlRRX01PRElGWV9NQVNLX0RJUlRZ
X0JJVE1BUF9QQVJBTVMgICAgICA9ICh1NjQpMSA8PCAzLA0KPiA+ID4gICAgICAgICAgTUxYNV9W
SVJUUV9NT0RJRllfTUFTS19ESVJUWV9CSVRNQVBfRFVNUF9FTkFCTEUgPSAodTY0KTEgPDwgNCwN
Cj4gPiA+ICsgICAgICAgTUxYNV9WSVJUUV9NT0RJRllfTUFTS19WSVJUSU9fUV9BRERSUyAgICAg
ICAgICAgPSAodTY0KTEgPDwgNiwNCj4gPiA+ICAgICAgICAgIE1MWDVfVklSVFFfTU9ESUZZX01B
U0tfREVTQ19HUk9VUF9NS0VZICAgICAgICAgID0gKHU2NCkxIDw8IDE0LA0KPiA+ID4gICB9Ow0K
PiA+ID4gDQo+ID4gPiAtLQ0KPiA+ID4gMi40Mi4wDQo+ID4gPiANCj4gDQoNCg==

