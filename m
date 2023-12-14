Return-Path: <kvm+bounces-4516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6310813542
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 16:51:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D70E282A6B
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 15:51:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 559BE5D91C;
	Thu, 14 Dec 2023 15:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="seqv1rO6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2050.outbound.protection.outlook.com [40.107.94.50])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2D710F;
	Thu, 14 Dec 2023 07:51:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zc6chGE7doDynbdjbwMOknUj5fKklLeIVyC477mMdpJ2xvYgTpefuK9/rU5DXjNYDRariFMPnaNhR+QUVhZHcnvP0YFWJYDxU+elGg6ud0WUoIGIAUnPz1K7q4nj1YZ5ONKv3DEDnx+hyiFbUHGpfwY+xa+YN0Lboxd/Cy63hiHrzw68gm9Amo5MCpIynfCeksxfRj3pJMHHRJRh+UhbU3mSJ1zEi5Mvw19sm17bMA9FIAjBmC6yzI3v23qSyHcIl/fwJtMupvb0CgHIEnXnIje2hbAY59swxBOvDB2wl3N91rg2cVjFv/5RIdMEGmMAiTqcU83zEuz1TcFz0GT/3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xEBq1HfT/leCD4fAFQ1LaOdUiul0jqQkcEwwcmiZCvc=;
 b=E5d/QtqSWDQdTStKvsKQMQ3+ZX/XOZw6NZeZCDMCXkovJgQVw1pEWvkEpTosyNc0Ybvaqrat1lFqmyW7RmwQwmFnZJanKeUOZ+RuOMBhYTyJKHCVDaSTyV2++X7txJoxnx6mMLW1NoBJXbsqa68Yptw9RnMgGbJtQ96VCJBJ7yRpzZ9Hl9OP4WBVxz7hIea8t88gsrxYEXcqH51JMLrhdwRz2pptjFN73FfrFHS57o8w+rNa1d9WNqzgyZwhpGSTnbecz/p/ALw7huLKMvR+DqWTmcGD05jin/ONrOx/DzHAjsV2wufTlB4TgY6ipiyexjpZBKBIkdnBHDkZWd6eLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xEBq1HfT/leCD4fAFQ1LaOdUiul0jqQkcEwwcmiZCvc=;
 b=seqv1rO6UES9CjAE4WhtOrm7p4jesTGqUKydDBB7xipeB6vcrpnbuke7vi44PkPFESILGy9VV2baaXvQMxcfXLdaoFkNGlTyuLG5ZrCLYyZ+KuXHCo86Gr+xU0+Zid7vDYCkdqVrZUIF+JmMQq6krWj4PFCiCwGAyVZ88hQvUdBXjodAgUcO0nu+aYiC4Y9N4njMTRucnyOzdasSv9GVkIw1P+JNrZelANZcfNjQiKJjhVdsI247n2Vlr2vDTKdA/ZK/VJ19WoAcQk7Crmi0qRW7UgxMhCf6cq/9eamDg1PbMTwIkaNLB0bkT16VGRr2AD1le3b3rPbXO/dZeCYs+w==
Received: from DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13)
 by LV3PR12MB9440.namprd12.prod.outlook.com (2603:10b6:408:215::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.28; Thu, 14 Dec
 2023 15:51:27 +0000
Received: from DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258]) by DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258%5]) with mapi id 15.20.7091.028; Thu, 14 Dec 2023
 15:51:27 +0000
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "mst@redhat.com" <mst@redhat.com>
CC: "xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>, Parav Pandit
	<parav@nvidia.com>, Gal Pressman <gal@nvidia.com>, "eperezma@redhat.com"
	<eperezma@redhat.com>, "virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "si-wei.liu@oracle.com"
	<si-wei.liu@oracle.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"jasowang@redhat.com" <jasowang@redhat.com>, Saeed Mahameed
	<saeedm@nvidia.com>, "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH vhost v2 4/8] vdpa/mlx5: Mark vq addrs for modification in
 hw vq
Thread-Topic: [PATCH vhost v2 4/8] vdpa/mlx5: Mark vq addrs for modification
 in hw vq
Thread-Index: AQHaJ2ha4Gy9JBIWuEWZX8/WZ4ytmbCmEe0AgABJawCAAnvhAIAAAZuAgAAjJQA=
Date: Thu, 14 Dec 2023 15:51:27 +0000
Message-ID: <9a6465a3d6c8fde63643fbbdde60d5dd84b921d4.camel@nvidia.com>
References: <20231205104609.876194-1-dtatulea@nvidia.com>
	 <20231205104609.876194-5-dtatulea@nvidia.com>
	 <CAJaqyWeEY9LNTE8QEnJgLhgS7HiXr5gJEwwPBrC3RRBsAE4_7Q@mail.gmail.com>
	 <27312106-07b9-4719-970c-b8e1aed7c4eb@oracle.com>
	 <075cf7d1ada0ee4ee30d46b993a1fe21acfe9d92.camel@nvidia.com>
	 <20231214084526-mutt-send-email-mst@kernel.org>
In-Reply-To: <20231214084526-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.2 (3.50.2-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB5565:EE_|LV3PR12MB9440:EE_
x-ms-office365-filtering-correlation-id: 08e4fd38-7a6f-4cc9-ec76-08dbfcbc8821
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 bX4OL9yBlB+4A71BAZMxIN0xpA+JrlvZKla6lZK5DZVkwyc1Dz/qh+gApSLbOICvBmPaZPzJStnEhCIvx33SCAcIf017ismTGApN7xA1+1RkXhrIFdcKwGAedsjyudP+ej2WiHw5LeYNRDU6vovLjrrqK+nA745bTzV4C9NsRNqlsNLAAOyOzTQUGXCEX6mQr7qp3eY95BKdD8Eox6X1chf84/Odgn9Jqc2JOOrS0LRwc4W/L8Fg6maIm54oakRcfuI6aEqIpfeuq1IIobU7jWdlNjvJ7FeOE7a1mJ8Hl2vvWEWp4XnwUzG/MPQRJbEwynCSDlGmexrhvGTdcrK2wG+RS4B/iGTcYJo2ETMZG94uLnArj6N3Bk1XmKAqIP0CZwacTDeBrBR0JHd/83r1qA5CextS/Ib1QEj2kQG2g1IycDlmm6hffyK+1PpCx++jUPFbfWp4myI/YSVJHsXWqk5OcIazq9VCSNaaCi19lBE37PoYKWvY0a0o8+miLJvUZnb2G0wJgSSjNe+2kw0alSIOe2meqVHBS5wjnZ0/FQxk/e1s9bcNs2MTmeJV1bzwdJEleWfc60+r92EVRfvrPcJnrBzVSpR6suq4CEfEOY35X3ksyMlPXvcdRmt6jrwLdaEOj1CpG6TzwsLKdH9jxmkmlJnWM0ipmbdtrYvNJ+w=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5565.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(366004)(396003)(136003)(376002)(230922051799003)(451199024)(186009)(1800799012)(64100799003)(8936002)(6506007)(53546011)(6512007)(8676002)(4326008)(122000001)(38100700002)(86362001)(4001150100001)(5660300002)(66574015)(71200400001)(2616005)(38070700009)(316002)(64756008)(478600001)(76116006)(66946007)(66556008)(66476007)(66446008)(41300700001)(91956017)(6916009)(54906003)(36756003)(83380400001)(2906002)(6486002)(966005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bzY1UmNTZldWQkZIWHhVb2pIYWlTdHNkYVNra0N1N1pPZTZ2TkVlS1JreWx0?=
 =?utf-8?B?bmhleXMwVkZzZ09iRnM3WUl5OVNQSXN6Q3dPR1FVQ1ZPYURvY2VjMUppMVFX?=
 =?utf-8?B?NXpSMGliZS91aTJhcWgrdUcyNi85eGxnQnZTTzRhcHRmWXdBbWd3RGVDVmVE?=
 =?utf-8?B?YXp0eHBnTXo0WkxkVU5JNWtYUERJdmpMV2JXMHFKSGVhejExR3EwTCt1OW9u?=
 =?utf-8?B?TGhnZmthWjVhUkFFMVFYaU03eDAyblg5TVB1YnVncjZDdkZQWm5GM21KWmhz?=
 =?utf-8?B?MStmVGU2blhFQ3ExWUNaVkJDTnp6QTJVNHROeTVnYVFyZy9tQ0F5cVRUMlEz?=
 =?utf-8?B?bG04dUdzZnk1UkR3c1VFNUJUNzFKREs1NXhVYW5ZNjQyRVVMd2ozMUplRkpY?=
 =?utf-8?B?ZzFmTUdkZDNRYnlyVWZOTjd5NnJWbHNEMEdZMFU3bDJ5Zk5KS0NCeHZSVGN4?=
 =?utf-8?B?SHVYZFBud0xoM2dRYjVRbDBvOFZ0YkdxMmhxYjVrbnhpZ0NCVit5VitTcUY3?=
 =?utf-8?B?RXdaS0pLbHZuTENONzVMdWl6MHQwOWxTd0hLWGk4SGJ1VzFpYmRzMzNZR2Zw?=
 =?utf-8?B?TWU1QUhtSGwyZ1lZWjBaR0JvcFIyOXgxT3J1blVhRE5qbG44cm5DR3ZoNnBI?=
 =?utf-8?B?SXJLQU9jTEFtR2NrcWNxUWh1N2VHM3hhUGRqOSt1R3hRcTJBa3lMZVBjMm5h?=
 =?utf-8?B?cHJ4RVdYVFB4MGprS1hTYkh0dS9JOUdMTElkYnhTUWpSL0VodTdTZHZOSGE1?=
 =?utf-8?B?cTBjZEhpbmFqNmUwMnJOVUZhL010WUlYUUhOM0hHYXBIOFBhSVAwaE1JSVdI?=
 =?utf-8?B?cXFVWkdBaDFNTGFpVlVzSVh5Z3ZjY29yRGtKTVJSUlZscytvYTdDYWJuTmsz?=
 =?utf-8?B?K1ZiNVROdWhITDdXYjg0SmlRai9TcHVtTWtJaXN2VFdhOEdkdUpXRUxPZnRi?=
 =?utf-8?B?SU5XdS9ibGxVZk9uZWtYdVhScmZlU2RaT0h5QXFadEJpcXFnTlBmNjhLUWY0?=
 =?utf-8?B?WmZHQWdEYzFRRjNQdEpmQXJNTktJR3RuSktmUUR5d0ZmNXpUT3ArN2F0Z0x1?=
 =?utf-8?B?Vk1FZHpIc0JxVTQ1aXgrN3Nja0EwQzAvSXczZllIYVdHMjJnMTNhMlJCNjVY?=
 =?utf-8?B?bTlockVvTzhVNmZSK3E1OXZiV2dhenpPTmJyVzh0OWZlaWJwY0ZJcm1EN3Jq?=
 =?utf-8?B?TGtwaU4xMkp1ZEczKzZZUUcrcFdoUWhOanRua3YxZFVUY1dEOHlUd1ZRN2xi?=
 =?utf-8?B?bURpaTc1RFNVd2g1Rk00NEErK1N2a2pnMUU5OGlDeTJCbkpTYzZtK29vU1Jl?=
 =?utf-8?B?cnFYb0llQ3A5NjhNcHpFSC8zNThHd3RQaFpwczE0SFBZQmNFSUhtOE8yVWVl?=
 =?utf-8?B?R2FnOW9wR2ZwRHBROXFHNG9XQjFEZ0dWNnJxRVRWSi81VXZFVFRnY0Q5SnVr?=
 =?utf-8?B?czZ6VUVoMzRpVWxzblRGZXJ6T21sOUZmd0kxQXVpOTgwRVZJOXFxQ2ZyZ1Vk?=
 =?utf-8?B?K0xjcG9VRjZMZVhYb1FnUXJzeVJ1dWtzUjl3M0l1K0VoR25lSU9Wd0xHMzVu?=
 =?utf-8?B?L0NmOXJGeklWNk9pdHJaTmJ2RGFhZCtsMHBkSXg3allTK3FCam15TjRWM05P?=
 =?utf-8?B?QTN5RzBsOEVURjdxbnFMV295ZTlXenp5SUI2Tm9VMkRZeXhHRDhxU0xjSWgw?=
 =?utf-8?B?YmdueU1hRjUwcHBPTlh6eDVhTDVMOFZHWUcyNDlwWWlsZXNuWmt6RlVTbUJw?=
 =?utf-8?B?WXYxbnFMNE1iQ09JMFlNckR2TzZQeGFPZERVNUJYR2hSbTJUejRqc0NFemZk?=
 =?utf-8?B?N1NQN0ZWVXd2WHp6SThuTE5mU3I2ZHRzS1BJaFdxeWlId1hOcDIyVGpxbU9F?=
 =?utf-8?B?WjZaeWQ2eUJUTTFkckVHaGRiUWV3eUIxZFFEdUFWbWxSeDdOdzlHUGpEZEJl?=
 =?utf-8?B?RWsrTUpvQWU1Y3c5VzFzdWlyS084bm9ZeGJtY1V3YXRwS0pTakcrV0c4Tyt3?=
 =?utf-8?B?UER1VFo2KzVHR0xYUGZGNDNPV2swZThhTVliVWZaM2pQazA3RkdicVFjMDJp?=
 =?utf-8?B?SzI3a0ZKdHlNQitQaUtFU284WHFFc2pxemRrMWxnaVYydUJTcGlTWHNRTkhO?=
 =?utf-8?B?c01TNlhnUTVzbjlvMWNxcTdjNm9oSVFNbnhqM3NNQ3gzS0lJVEl4TjdLWmt5?=
 =?utf-8?Q?u5UjuqNwIiOPufEBnYnz1b9ok0+7uip1mJgVTZ09h7Cq?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F16C686F4BAC9446A0A61E01A4E15C9F@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 08e4fd38-7a6f-4cc9-ec76-08dbfcbc8821
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2023 15:51:27.0912
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Pc6G5jPhvfn38RE8NLWJ99/SNjrfQvw3jeCgWE7KGdGlaJQ1LsUex1qj29t3DvZH72AmyBwszs/6Ow2ufaUVaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9440

T24gVGh1LCAyMDIzLTEyLTE0IGF0IDA4OjQ1IC0wNTAwLCBNaWNoYWVsIFMuIFRzaXJraW4gd3Jv
dGU6DQo+IE9uIFRodSwgRGVjIDE0LCAyMDIzIGF0IDAxOjM5OjU1UE0gKzAwMDAsIERyYWdvcyBU
YXR1bGVhIHdyb3RlOg0KPiA+IE9uIFR1ZSwgMjAyMy0xMi0xMiBhdCAxNTo0NCAtMDgwMCwgU2kt
V2VpIExpdSB3cm90ZToNCj4gPiA+IA0KPiA+ID4gT24gMTIvMTIvMjAyMyAxMToyMSBBTSwgRXVn
ZW5pbyBQZXJleiBNYXJ0aW4gd3JvdGU6DQo+ID4gPiA+IE9uIFR1ZSwgRGVjIDUsIDIwMjMgYXQg
MTE6NDbigK9BTSBEcmFnb3MgVGF0dWxlYSA8ZHRhdHVsZWFAbnZpZGlhLmNvbT4gd3JvdGU6DQo+
ID4gPiA+ID4gQWRkcmVzc2VzIGdldCBzZXQgYnkgLnNldF92cV9hZGRyZXNzLiBodyB2cSBhZGRy
ZXNzZXMgd2lsbCBiZSB1cGRhdGVkIG9uDQo+ID4gPiA+ID4gbmV4dCBtb2RpZnlfdmlydHF1ZXVl
Lg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IERyYWdvcyBUYXR1bGVhIDxk
dGF0dWxlYUBudmlkaWEuY29tPg0KPiA+ID4gPiA+IFJldmlld2VkLWJ5OiBHYWwgUHJlc3NtYW4g
PGdhbEBudmlkaWEuY29tPg0KPiA+ID4gPiA+IEFja2VkLWJ5OiBFdWdlbmlvIFDDqXJleiA8ZXBl
cmV6bWFAcmVkaGF0LmNvbT4NCj4gPiA+ID4gSSdtIGtpbmQgb2Ygb2sgd2l0aCB0aGlzIHBhdGNo
IGFuZCB0aGUgbmV4dCBvbmUgYWJvdXQgc3RhdGUsIGJ1dCBJDQo+ID4gPiA+IGRpZG4ndCBhY2sg
dGhlbSBpbiB0aGUgcHJldmlvdXMgc2VyaWVzLg0KPiA+ID4gPiANCj4gPiA+ID4gTXkgbWFpbiBj
b25jZXJuIGlzIHRoYXQgaXQgaXMgbm90IHZhbGlkIHRvIGNoYW5nZSB0aGUgdnEgYWRkcmVzcyBh
ZnRlcg0KPiA+ID4gPiBEUklWRVJfT0sgaW4gVmlydElPLCB3aGljaCB2RFBBIGZvbGxvd3MuIE9u
bHkgbWVtb3J5IG1hcHMgYXJlIG9rIHRvDQo+ID4gPiA+IGNoYW5nZSBhdCB0aGlzIG1vbWVudC4g
SSdtIG5vdCBzdXJlIGFib3V0IHZxIHN0YXRlIGluIHZEUEEsIGJ1dCB2aG9zdA0KPiA+ID4gPiBm
b3JiaWRzIGNoYW5naW5nIGl0IHdpdGggYW4gYWN0aXZlIGJhY2tlbmQuDQo+ID4gPiA+IA0KPiA+
ID4gPiBTdXNwZW5kIGlzIG5vdCBkZWZpbmVkIGluIFZpcnRJTyBhdCB0aGlzIG1vbWVudCB0aG91
Z2gsIHNvIG1heWJlIGl0IGlzDQo+ID4gPiA+IG9rIHRvIGRlY2lkZSB0aGF0IGFsbCBvZiB0aGVz
ZSBwYXJhbWV0ZXJzIG1heSBjaGFuZ2UgZHVyaW5nIHN1c3BlbmQuDQo+ID4gPiA+IE1heWJlIHRo
ZSBiZXN0IHRoaW5nIGlzIHRvIHByb3RlY3QgdGhpcyB3aXRoIGEgdkRQQSBmZWF0dXJlIGZsYWcu
DQo+ID4gPiBJIHRoaW5rIHByb3RlY3Qgd2l0aCB2RFBBIGZlYXR1cmUgZmxhZyBjb3VsZCB3b3Jr
LCB3aGlsZSBvbiB0aGUgb3RoZXIgDQo+ID4gPiBoYW5kIHZEUEEgbWVhbnMgdmVuZG9yIHNwZWNp
ZmljIG9wdGltaXphdGlvbiBpcyBwb3NzaWJsZSBhcm91bmQgc3VzcGVuZCANCj4gPiA+IGFuZCBy
ZXN1bWUgKGluIGNhc2UgaXQgaGVscHMgcGVyZm9ybWFuY2UpLCB3aGljaCBkb2Vzbid0IGhhdmUg
dG8gYmUgDQo+ID4gPiBiYWNrZWQgYnkgdmlydGlvIHNwZWMuIFNhbWUgYXBwbGllcyB0byB2aG9z
dCB1c2VyIGJhY2tlbmQgZmVhdHVyZXMsIA0KPiA+ID4gdmFyaWF0aW9ucyB0aGVyZSB3ZXJlIG5v
dCBiYWNrZWQgYnkgc3BlYyBlaXRoZXIuIE9mIGNvdXJzZSwgd2Ugc2hvdWxkIA0KPiA+ID4gdHJ5
IGJlc3QgdG8gbWFrZSB0aGUgZGVmYXVsdCBiZWhhdmlvciBiYWNrd2FyZCBjb21wYXRpYmxlIHdp
dGggDQo+ID4gPiB2aXJ0aW8tYmFzZWQgYmFja2VuZCwgYnV0IHRoYXQgY2lyY2xlcyBiYWNrIHRv
IG5vIHN1c3BlbmQgZGVmaW5pdGlvbiBpbiANCj4gPiA+IHRoZSBjdXJyZW50IHZpcnRpbyBzcGVj
LCBmb3Igd2hpY2ggSSBob3BlIHdlIGRvbid0IGNlYXNlIGRldmVsb3BtZW50IG9uIA0KPiA+ID4g
dkRQQSBpbmRlZmluaXRlbHkuIEFmdGVyIGFsbCwgdGhlIHZpcnRpbyBiYXNlZCB2ZGFwIGJhY2tl
bmQgY2FuIHdlbGwgDQo+ID4gPiBkZWZpbmUgaXRzIG93biBmZWF0dXJlIGZsYWcgdG8gZGVzY3Jp
YmUgKG1pbm9yIGRpZmZlcmVuY2UgaW4pIHRoZSANCj4gPiA+IHN1c3BlbmQgYmVoYXZpb3IgYmFz
ZWQgb24gdGhlIGxhdGVyIHNwZWMgb25jZSBpdCBpcyBmb3JtZWQgaW4gZnV0dXJlLg0KPiA+ID4g
DQo+ID4gU28gd2hhdCBpcyB0aGUgd2F5IGZvcndhcmQgaGVyZT8gRnJvbSB3aGF0IEkgdW5kZXJz
dGFuZCB0aGUgb3B0aW9ucyBhcmU6DQo+ID4gDQo+ID4gMSkgQWRkIGEgdmRwYSBmZWF0dXJlIGZs
YWcgZm9yIGNoYW5naW5nIGRldmljZSBwcm9wZXJ0aWVzIHdoaWxlIHN1c3BlbmRlZC4NCj4gPiAN
Cj4gPiAyKSBEcm9wIHRoZXNlIDIgcGF0Y2hlcyBmcm9tIHRoZSBzZXJpZXMgZm9yIG5vdy4gTm90
IHN1cmUgaWYgdGhpcyBtYWtlcyBzZW5zZSBhcw0KPiA+IHRoaXMuIEJ1dCB0aGVuIFNpLVdlaSdz
IHFlbXUgZGV2aWNlIHN1c3BlbmQvcmVzdW1lIHBvYyBbMF0gdGhhdCBleGVyY2lzZXMgdGhpcw0K
PiA+IGNvZGUgd29uJ3Qgd29yayBhbnltb3JlLiBUaGlzIG1lYW5zIHRoZSBzZXJpZXMgd291bGQg
YmUgbGVzcyB3ZWxsIHRlc3RlZC4NCj4gPiANCj4gPiBBcmUgdGhlcmUgb3RoZXIgcG9zc2libGUg
b3B0aW9ucz8gV2hhdCBkbyB5b3UgdGhpbms/DQo+ID4gDQo+ID4gWzBdIGh0dHBzOi8vZ2l0aHVi
LmNvbS9zaXdsaXUta2VybmVsL3FlbXUvdHJlZS9zdnEtcmVzdW1lLXdpcA0KPiANCj4gSSBhbSBm
aW5lIHdpdGggZWl0aGVyIG9mIHRoZXNlLg0KPiANCkhvdyBhYm91dCBhbGxvd2luZyB0aGUgY2hh
bmdlIG9ubHkgdW5kZXIgdGhlIGZvbGxvd2luZyBjb25kaXRpb25zOg0KICB2aG9zdF92ZHBhX2Nh
bl9zdXNwZW5kICYmIHZob3N0X3ZkcGFfY2FuX3Jlc3VtZSAmJiAgDQpWSE9TVF9CQUNLRU5EX0Zf
RU5BQkxFX0FGVEVSX0RSSVZFUl9PSyBpcyBzZXQNCg0KPw0KDQpUaGFua3MsDQpEcmFnb3MNCg0K
PiA+IFRoYW5rcywNCj4gPiBEcmFnb3MNCj4gPiANCj4gPiA+IFJlZ2FyZHMsDQo+ID4gPiAtU2l3
ZWkNCj4gPiA+IA0KPiA+ID4gDQo+ID4gPiANCj4gPiA+ID4gDQo+ID4gPiA+IEphc29uLCB3aGF0
IGRvIHlvdSB0aGluaz8NCj4gPiA+ID4gDQo+ID4gPiA+IFRoYW5rcyENCj4gPiA+ID4gDQo+ID4g
PiA+ID4gLS0tDQo+ID4gPiA+ID4gICBkcml2ZXJzL3ZkcGEvbWx4NS9uZXQvbWx4NV92bmV0LmMg
IHwgOSArKysrKysrKysNCj4gPiA+ID4gPiAgIGluY2x1ZGUvbGludXgvbWx4NS9tbHg1X2lmY192
ZHBhLmggfCAxICsNCj4gPiA+ID4gPiAgIDIgZmlsZXMgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygr
KQ0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3ZkcGEvbWx4NS9u
ZXQvbWx4NV92bmV0LmMgYi9kcml2ZXJzL3ZkcGEvbWx4NS9uZXQvbWx4NV92bmV0LmMNCj4gPiA+
ID4gPiBpbmRleCBmOGYwODhjY2VkNTAuLjgwZTA2NmRlMDg2NiAxMDA2NDQNCj4gPiA+ID4gPiAt
LS0gYS9kcml2ZXJzL3ZkcGEvbWx4NS9uZXQvbWx4NV92bmV0LmMNCj4gPiA+ID4gPiArKysgYi9k
cml2ZXJzL3ZkcGEvbWx4NS9uZXQvbWx4NV92bmV0LmMNCj4gPiA+ID4gPiBAQCAtMTIwOSw2ICsx
MjA5LDcgQEAgc3RhdGljIGludCBtb2RpZnlfdmlydHF1ZXVlKHN0cnVjdCBtbHg1X3ZkcGFfbmV0
ICpuZGV2LA0KPiA+ID4gPiA+ICAgICAgICAgIGJvb2wgc3RhdGVfY2hhbmdlID0gZmFsc2U7DQo+
ID4gPiA+ID4gICAgICAgICAgdm9pZCAqb2JqX2NvbnRleHQ7DQo+ID4gPiA+ID4gICAgICAgICAg
dm9pZCAqY21kX2hkcjsNCj4gPiA+ID4gPiArICAgICAgIHZvaWQgKnZxX2N0eDsNCj4gPiA+ID4g
PiAgICAgICAgICB2b2lkICppbjsNCj4gPiA+ID4gPiAgICAgICAgICBpbnQgZXJyOw0KPiA+ID4g
PiA+IA0KPiA+ID4gPiA+IEBAIC0xMjMwLDYgKzEyMzEsNyBAQCBzdGF0aWMgaW50IG1vZGlmeV92
aXJ0cXVldWUoc3RydWN0IG1seDVfdmRwYV9uZXQgKm5kZXYsDQo+ID4gPiA+ID4gICAgICAgICAg
TUxYNV9TRVQoZ2VuZXJhbF9vYmpfaW5fY21kX2hkciwgY21kX2hkciwgdWlkLCBuZGV2LT5tdmRl
di5yZXMudWlkKTsNCj4gPiA+ID4gPiANCj4gPiA+ID4gPiAgICAgICAgICBvYmpfY29udGV4dCA9
IE1MWDVfQUREUl9PRihtb2RpZnlfdmlydGlvX25ldF9xX2luLCBpbiwgb2JqX2NvbnRleHQpOw0K
PiA+ID4gPiA+ICsgICAgICAgdnFfY3R4ID0gTUxYNV9BRERSX09GKHZpcnRpb19uZXRfcV9vYmpl
Y3QsIG9ial9jb250ZXh0LCB2aXJ0aW9fcV9jb250ZXh0KTsNCj4gPiA+ID4gPiANCj4gPiA+ID4g
PiAgICAgICAgICBpZiAobXZxLT5tb2RpZmllZF9maWVsZHMgJiBNTFg1X1ZJUlRRX01PRElGWV9N
QVNLX1NUQVRFKSB7DQo+ID4gPiA+ID4gICAgICAgICAgICAgICAgICBpZiAoIWlzX3ZhbGlkX3N0
YXRlX2NoYW5nZShtdnEtPmZ3X3N0YXRlLCBzdGF0ZSwgaXNfcmVzdW1hYmxlKG5kZXYpKSkgew0K
PiA+ID4gPiA+IEBAIC0xMjQxLDYgKzEyNDMsMTIgQEAgc3RhdGljIGludCBtb2RpZnlfdmlydHF1
ZXVlKHN0cnVjdCBtbHg1X3ZkcGFfbmV0ICpuZGV2LA0KPiA+ID4gPiA+ICAgICAgICAgICAgICAg
ICAgc3RhdGVfY2hhbmdlID0gdHJ1ZTsNCj4gPiA+ID4gPiAgICAgICAgICB9DQo+ID4gPiA+ID4g
DQo+ID4gPiA+ID4gKyAgICAgICBpZiAobXZxLT5tb2RpZmllZF9maWVsZHMgJiBNTFg1X1ZJUlRR
X01PRElGWV9NQVNLX1ZJUlRJT19RX0FERFJTKSB7DQo+ID4gPiA+ID4gKyAgICAgICAgICAgICAg
IE1MWDVfU0VUNjQodmlydGlvX3EsIHZxX2N0eCwgZGVzY19hZGRyLCBtdnEtPmRlc2NfYWRkcik7
DQo+ID4gPiA+ID4gKyAgICAgICAgICAgICAgIE1MWDVfU0VUNjQodmlydGlvX3EsIHZxX2N0eCwg
dXNlZF9hZGRyLCBtdnEtPmRldmljZV9hZGRyKTsNCj4gPiA+ID4gPiArICAgICAgICAgICAgICAg
TUxYNV9TRVQ2NCh2aXJ0aW9fcSwgdnFfY3R4LCBhdmFpbGFibGVfYWRkciwgbXZxLT5kcml2ZXJf
YWRkcik7DQo+ID4gPiA+ID4gKyAgICAgICB9DQo+ID4gPiA+ID4gKw0KPiA+ID4gPiA+ICAgICAg
ICAgIE1MWDVfU0VUNjQodmlydGlvX25ldF9xX29iamVjdCwgb2JqX2NvbnRleHQsIG1vZGlmeV9m
aWVsZF9zZWxlY3QsIG12cS0+bW9kaWZpZWRfZmllbGRzKTsNCj4gPiA+ID4gPiAgICAgICAgICBl
cnIgPSBtbHg1X2NtZF9leGVjKG5kZXYtPm12ZGV2Lm1kZXYsIGluLCBpbmxlbiwgb3V0LCBzaXpl
b2Yob3V0KSk7DQo+ID4gPiA+ID4gICAgICAgICAgaWYgKGVycikNCj4gPiA+ID4gPiBAQCAtMjIw
Miw2ICsyMjEwLDcgQEAgc3RhdGljIGludCBtbHg1X3ZkcGFfc2V0X3ZxX2FkZHJlc3Moc3RydWN0
IHZkcGFfZGV2aWNlICp2ZGV2LCB1MTYgaWR4LCB1NjQgZGVzY18NCj4gPiA+ID4gPiAgICAgICAg
ICBtdnEtPmRlc2NfYWRkciA9IGRlc2NfYXJlYTsNCj4gPiA+ID4gPiAgICAgICAgICBtdnEtPmRl
dmljZV9hZGRyID0gZGV2aWNlX2FyZWE7DQo+ID4gPiA+ID4gICAgICAgICAgbXZxLT5kcml2ZXJf
YWRkciA9IGRyaXZlcl9hcmVhOw0KPiA+ID4gPiA+ICsgICAgICAgbXZxLT5tb2RpZmllZF9maWVs
ZHMgfD0gTUxYNV9WSVJUUV9NT0RJRllfTUFTS19WSVJUSU9fUV9BRERSUzsNCj4gPiA+ID4gPiAg
ICAgICAgICByZXR1cm4gMDsNCj4gPiA+ID4gPiAgIH0NCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBk
aWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9tbHg1L21seDVfaWZjX3ZkcGEuaCBiL2luY2x1ZGUv
bGludXgvbWx4NS9tbHg1X2lmY192ZHBhLmgNCj4gPiA+ID4gPiBpbmRleCBiODZkNTFhODU1ZjYu
Ljk1OTRhYzQwNTc0MCAxMDA2NDQNCj4gPiA+ID4gPiAtLS0gYS9pbmNsdWRlL2xpbnV4L21seDUv
bWx4NV9pZmNfdmRwYS5oDQo+ID4gPiA+ID4gKysrIGIvaW5jbHVkZS9saW51eC9tbHg1L21seDVf
aWZjX3ZkcGEuaA0KPiA+ID4gPiA+IEBAIC0xNDUsNiArMTQ1LDcgQEAgZW51bSB7DQo+ID4gPiA+
ID4gICAgICAgICAgTUxYNV9WSVJUUV9NT0RJRllfTUFTS19TVEFURSAgICAgICAgICAgICAgICAg
ICAgPSAodTY0KTEgPDwgMCwNCj4gPiA+ID4gPiAgICAgICAgICBNTFg1X1ZJUlRRX01PRElGWV9N
QVNLX0RJUlRZX0JJVE1BUF9QQVJBTVMgICAgICA9ICh1NjQpMSA8PCAzLA0KPiA+ID4gPiA+ICAg
ICAgICAgIE1MWDVfVklSVFFfTU9ESUZZX01BU0tfRElSVFlfQklUTUFQX0RVTVBfRU5BQkxFID0g
KHU2NCkxIDw8IDQsDQo+ID4gPiA+ID4gKyAgICAgICBNTFg1X1ZJUlRRX01PRElGWV9NQVNLX1ZJ
UlRJT19RX0FERFJTICAgICAgICAgICA9ICh1NjQpMSA8PCA2LA0KPiA+ID4gPiA+ICAgICAgICAg
IE1MWDVfVklSVFFfTU9ESUZZX01BU0tfREVTQ19HUk9VUF9NS0VZICAgICAgICAgID0gKHU2NCkx
IDw8IDE0LA0KPiA+ID4gPiA+ICAgfTsNCj4gPiA+ID4gPiANCj4gPiA+ID4gPiAtLQ0KPiA+ID4g
PiA+IDIuNDIuMA0KPiA+ID4gPiA+IA0KPiA+ID4gDQo+ID4gDQo+IA0KDQo=

