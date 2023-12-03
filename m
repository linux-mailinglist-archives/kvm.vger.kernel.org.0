Return-Path: <kvm+bounces-3271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A0E880251B
	for <lists+kvm@lfdr.de>; Sun,  3 Dec 2023 16:21:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9668C1C208F1
	for <lists+kvm@lfdr.de>; Sun,  3 Dec 2023 15:21:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E26C154B1;
	Sun,  3 Dec 2023 15:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ifp9G+9V"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2087.outbound.protection.outlook.com [40.107.92.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8643C2;
	Sun,  3 Dec 2023 07:21:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cWZ6SaifYFGKOw803GLP3RFzHu+cydLVXR0VNg/Ha05YI8u93kakGg40B03rMpoduekE490XIBIK0VkDTlkRKNHbB9TptjpSOoeMoslOudZt9oImrevLlHBZ47qaltsp5NPNE2zHY99S5SLGDYhu2Z0Tl5hnuf/7ffgwEgmXsly4hYHPZ/RbLyWp60W9NjLg9jwqaNbXODhh9HelY12yagB/F4CO3Ub7kqC6cZ3YNiRB91kv+uZeEwQCN65qDK87BRE9xKQ0Y+HaebOBEQ9t1r/Yk2gVJRKjxzAiM2kNzfd91ZeWQ5OSfzpCNbzDgInwQmSbDz9pMpkRkmEI/ArEog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6AHd97A1txVHMmTjbj7tBjwGnZJgi9w4ZfY/jft6JOE=;
 b=VeWJeG55M1cWMUAu/Wy9p2Qv/CgZMvw733w/UzCXqxlkg07mSQl8yp6frpGtwPVWP6P+OLNOncdJfzRywWxEi/WE5NQ0XHMT875CtInGABof/l/lNFISQTn46b6lLi5Z3Zq6mq+jQVsWP8j39zu6zAoWGUFzvxVudJHNC9jIOgH1wO5easyESFkkyldC+TPlBqQopXpGxyKB0xzwQO0z7r7BE3xkHJ1joyKp8c+Kh+/4FCkrUXyLvFKycudMCUVUCxx/zRSa3rwMRYeJUqM8D4eIzGCEBepBo0eyCI+ahPgqnLfWnSPkaWXzRyxXhUaTFlEG/4XLfsvE7DXj0eXNhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6AHd97A1txVHMmTjbj7tBjwGnZJgi9w4ZfY/jft6JOE=;
 b=Ifp9G+9VflqEXEqhj0v5KcSLUeC+/0jds6H1J3oKr1lLrXUhT/GLfSwwPXw8CyAEqqCC0BAkwDizLeFo33DP0AoWjFqUOxpS6b9jh5inztSIgjbKhDXMHX87e6fu1pirg0ZXsRcKCNi/mYVAghBmPBMatMO5CVzZbrQ6/1UW6WCTeM7g80v1VwgsvqrLWOplV8eFZF/m3oTv3mvJeVA8Wd9KmgKmUJTCk1fxjXkjj6RTY/M9Pr/rQTO9ljSfUDkBfc8dDq/ZY2ju/MwwmIDEvngLfj8/8YZ72ExNzHMf/Nj2i+PsERBIkds2WqVaYl978yuqx/gs2iQidSLyWFgHgA==
Received: from DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13)
 by PH8PR12MB6939.namprd12.prod.outlook.com (2603:10b6:510:1be::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.32; Sun, 3 Dec
 2023 15:21:02 +0000
Received: from DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258]) by DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258%5]) with mapi id 15.20.7046.032; Sun, 3 Dec 2023
 15:21:01 +0000
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
Thread-Index: AQHaJEQPCu8G+as30EOn77AjCdP4t7CWcwSAgAE9GAA=
Date: Sun, 3 Dec 2023 15:21:01 +0000
Message-ID: <aff0361edcb0fd0c384bf297e71d25fb77570e15.camel@nvidia.com>
References: <20231201104857.665737-1-dtatulea@nvidia.com>
	 <20231202152523-mutt-send-email-mst@kernel.org>
In-Reply-To: <20231202152523-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.1 (3.50.1-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB5565:EE_|PH8PR12MB6939:EE_
x-ms-office365-filtering-correlation-id: 84a25e94-b87a-4aaa-3a9a-08dbf4137572
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 +OGGnvWpCT7s0zuDeNvuXAxRQsF1KDQSd6x6w4f4GPuDWW4RRcx20ZWZ27hst7unJiepQHyGZR+m+SZWHKaweAB1OB57guRA4IrE9wYZhcdjahImZp0EZrAuavbFk1trA7QQR+C/nUev0qO2tN3EY4GtLOCypcQYMI/xKFzde8QE4JJ2fI+vIVgskNixcem1VxSlSDTpV2ctLKel7PsSWdctKN5bSfpIdiy9OsDhl2O1XMUXXAGA0/BqnZRWNhtKvl6DQQOIU0XWHvBO8m+S6CFvaW83Sy0bS/8m8bJc6Po/nU77zMNcM4utTrUA0NR+4hmoHryqm2DsfRVIZCILrpsH1ln5R8XyEfK7UKnIViZBovScxFXx4NChBZuVBBf56DI559HLeAxukmNqAXuSPrIPzTt0h+QMUe1xcXf3I782CoGb+lPkwjvdEmYKTunwOBtVPSjyb4Bo8EMSDj7lnZJQMC668Gq2JDgSTubpbBqvxBP759WWvvCNwUjSx+gS+ERKIbsDzIctr4MQobVkPUTWzqzlFZErMgKJ8NtebfOBOE9/x70+ofZZ0AdVgmd2gRqMrJbdOaAbL1FM/LurrGKDFWNqT9EOn8ulKS/3jC6+9JjguHDZGBCKKaKLDZjmE+g5ytYGempThKgqCdcytFUQ1HbmbbPGVopGURZ2YQg=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5565.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(376002)(39860400002)(396003)(136003)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(478600001)(966005)(6486002)(83380400001)(71200400001)(6506007)(6512007)(36756003)(2616005)(316002)(91956017)(6916009)(66476007)(66446008)(64756008)(54906003)(76116006)(66946007)(66556008)(122000001)(38100700002)(5660300002)(4326008)(86362001)(2906002)(8936002)(8676002)(41300700001)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TXhWTGlPMkY2YzdzY0lKWDVTTW1uUlhQVGxudm9mMG1PS0VIRHVPNUpJNXBa?=
 =?utf-8?B?cWNIZGFRMVBCMjdHcHN3VDN1NVFjK2Fob202cU5BUUFBU0ZRUVFsemxyaFdw?=
 =?utf-8?B?SjlnSUp1cUpRYm52dUQySWY1T2FtaG5IekRUV0xuVlFmL3VSQXdLeDV5ejBx?=
 =?utf-8?B?TTN1NEJ2NkpDZmVrcWQzbnRWZVZmeGRjTytDViszdm5WUEorSjAycUhIazFh?=
 =?utf-8?B?RXZwdEMvMzA3VTljRGVMKzh3UzBMZnd3WHdTRDR1K281UCtOcW9pTllWa3pq?=
 =?utf-8?B?dzd5RHViWUpyS3FOVUN5N3ZTQjR5aFp1cnl5Q0hNU0hBNFl5SUFZTVBJMmlD?=
 =?utf-8?B?QUd0OExIbnUyQTVVWStDSHZ6UmV1YU04S1VhTWNxYnNITmxscWFxZjBYZXdH?=
 =?utf-8?B?OHZvQWJpWEk1L1hpMWYxUmpKU0dmWm1IZFB3WW1jN0YvZkcxV29pcHRneThT?=
 =?utf-8?B?Sm1jeXl0eSsrRldKek8zYVFqWnhRNzVPdml3S1hvYndVc0JMUXNoaFZoYWh2?=
 =?utf-8?B?S1VQZU5GUjVueXR6N1lyOFN4Q2poNGNtak90UDJzS1kvOHU0RTVZZ0JvQ2ti?=
 =?utf-8?B?a2t4U3F4VC9nSVdlUy8wOUxiY3JiWCtCSVE3d3gyd3ZLaDRmaDh3ZkhvY0tR?=
 =?utf-8?B?a21md0FnaVNXSUlMcksydWczM0V3M3lBZDRZZmRKemNhc0pWdEFQRk43WFJH?=
 =?utf-8?B?OWNXcW4wV3RLN1JTTHpCeERSb0ZTNkE2N21pTFI3YjgrdklwRVJmQXBPcTlH?=
 =?utf-8?B?cjkyTTdsN3NYQmR4Q2ZiY3hSUDRzTENOd2hqblJ3Q2F0YnZrSVFCWDJ0QTBC?=
 =?utf-8?B?MHpkTDJsQlI5Y2h1VXYveGRrQ0xEOUM3cExHbE5JckVnNy81VEJZbTE2M0hE?=
 =?utf-8?B?cjVWdWNhaTFWc3Q3enkvYW1EUWFsR0JIdDI1Ym91dlhzeFpqTmNValRpVSs5?=
 =?utf-8?B?d0FEb2F0YlNydTZCK3FXbHRSbWYyU25pVC9vb0hPai9VU3k2d0VzUzAwTVVt?=
 =?utf-8?B?QkdySEVMSVZDRnNzZU5UUHMvdW12eE5JelNqOUQ4a3JoV2EwZHJNbnozdlJ5?=
 =?utf-8?B?NjRJeGNSSVE2OXE2ZXNtZHZyQTBjRGhwbWp6NzB3djdEM1MzZUVJQmNaT0I5?=
 =?utf-8?B?d2x1Y0wvK3BDYkxyUEhNd0pzeW4xT0dmRHRjOUFNR2l4bHdvTEQ5UnhLWUxq?=
 =?utf-8?B?WWcrd1RCMVdiQjhLNG9mQnIxVGdSWlcwVHhuZzJ4OUhEUmNMdmJpcGt3d1Fv?=
 =?utf-8?B?N1laSmcwY1diYkMvOE9vTHQ0VVhSOXdjY1UrZVA2S1VXcGRlS1NTdEQxTEZD?=
 =?utf-8?B?SEl2RWFhRWU5ajJwcnNQRnFONTNoYXc2QnMrdFZzQk5mODJ4RmtZTjdtY1E5?=
 =?utf-8?B?WCtTMjAzYVJ4eWdBc3JUN2Z6TnFoK1BhRVpwVmZDSCs2Uy91NWU5eFNNTG9C?=
 =?utf-8?B?bU1PY3I0ek5xeHNTRmtYeHBGMHV4Z3VBT2NqaUYxMmZjR0R5QUFINi82L2tw?=
 =?utf-8?B?L05ydndQbDhhVTRXc3pVZENFNmtMRmJ1eGc4bDJweXZsVVEzak9TNTZyQXNR?=
 =?utf-8?B?LzZZVmt1NWpROERzTENCM2VZUE5YN0t2UWFZZXUrUWNSTjZuc0h5bkhTRnUr?=
 =?utf-8?B?YkRYdFZBY3RkblEzS09GTDJHNDNackhjdnIzdG5hTlBMTTZSdmVIVzNPUnRX?=
 =?utf-8?B?N1hmZDI4N2p0QVFlb2RtNlVtWFRURXY5NXZYUHFnaU42U1dqU2swUVhLUnh4?=
 =?utf-8?B?SngzejNYOG5mVCs1YnRmNklmZThCUjdkSFZLbTRQaDJiazJ5T3hZMFpTQkRz?=
 =?utf-8?B?K1BHKzM2ZE9UZEtiZm5GZzU2V2syVkZLVjVQblM3REVmL0oya29YNU5YTVVE?=
 =?utf-8?B?M1JkSnJZWGdra1BRekNjSFlKMTROMHl0ME5LVS9INVFWN01Pa2JUellKdkRX?=
 =?utf-8?B?dFV4QzlRTlkyam9zKzhBcXU3SHpjc1M0SG5tSzFkVnRMOG10VmdCd1paNGlY?=
 =?utf-8?B?aHo4TUs0NDVhWnFyMXdDVmRuNWsvb0NIMlF0NFhwWmdTNDZ4MnJ1cjUvYmpQ?=
 =?utf-8?B?SG45Vmg1cDRacGZMMzhlK3diUlMwUTJGRTk0K1NKVS9PKyszSzJuRnZIaGxZ?=
 =?utf-8?B?aUpFa25ZTlkwemdIUTlqczQvdFZKYm9rZENwUjgxNHNXcGNUS2RTVk0ydzRv?=
 =?utf-8?Q?ZBMMeU7lBfslOXFpfG62Jr08mIDBOLID0hZlAqL7tchE?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DC3013D1F09FB0458FC3D2996511782A@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 84a25e94-b87a-4aaa-3a9a-08dbf4137572
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2023 15:21:01.4713
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PeQupeSVssou6k4gkpFquqWcmfJd2KsBuc2Uq+IX1BEzeH16BAcJ9ZzPULLfRdax+4zwngPXhiE6hWFJxbRE3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6939

T24gU2F0LCAyMDIzLTEyLTAyIGF0IDE1OjI2IC0wNTAwLCBNaWNoYWVsIFMuIFRzaXJraW4gd3Jv
dGU6DQo+IE9uIEZyaSwgRGVjIDAxLCAyMDIzIGF0IDEyOjQ4OjUwUE0gKzAyMDAsIERyYWdvcyBU
YXR1bGVhIHdyb3RlOg0KPiA+IEFkZCBzdXBwb3J0IGZvciByZXN1bWFibGUgdnFzIGluIHRoZSBk
cml2ZXIuIFRoaXMgaXMgYSBmaXJtd2FyZSBmZWF0dXJlDQo+ID4gdGhhdCBjYW4gYmUgdXNlZCBm
b3IgdGhlIGZvbGxvd2luZyBiZW5lZml0czoNCj4gPiAtIEZ1bGwgZGV2aWNlIC5zdXNwZW5kLy5y
ZXN1bWUuDQo+ID4gLSAuc2V0X21hcCBkb2Vzbid0IG5lZWQgdG8gZGVzdHJveSBhbmQgY3JlYXRl
IG5ldyB2cXMgYW55bW9yZSBqdXN0IHRvDQo+ID4gICB1cGRhdGUgdGhlIG1hcC4gV2hlbiByZXN1
bWFibGUgdnFzIGFyZSBzdXBwb3J0ZWQgaXQgaXMgZW5vdWdoIHRvDQo+ID4gICBzdXNwZW5kIHRo
ZSB2cXMsIHNldCB0aGUgbmV3IG1hcHMsIGFuZCB0aGVuIHJlc3VtZSB0aGUgdnFzLg0KPiA+IA0K
PiA+IFRoZSBmaXJzdCBwYXRjaCBleHBvc2VzIHRoZSByZWxldmFudCBiaXRzIGluIG1seDVfaWZj
LmguIFRoYXQgbWVhbnMgaXQNCj4gPiBuZWVkcyB0byBiZSBhcHBsaWVkIHRvIHRoZSBtbHg1LXZo
b3N0IHRyZWUgWzBdIGZpcnN0Lg0KPiANCj4gSSBkaWRuJ3QgZ2V0IHRoaXMuIFdoeSBkb2VzIHRo
aXMgbmVlZCB0byBnbyB0aHJvdWdoIHRoYXQgdHJlZT8NCj4gSXMgdGhlcmUgYSBkZXBlbmRlbmN5
IG9uIHNvbWUgb3RoZXIgY29tbWl0IGZyb20gdGhhdCB0cmVlPw0KPiANClRvIGF2b2lkIG1lcmdl
IGlzc3VlcyBpbiBMaW51cydzIHRyZWUgaW4gbWx4NV9pZmMuaC4gVGhlIGlkZWEgaXMgdGhlIHNh
bWUgYXMgZm9yDQp0aGUgInZxIGRlc2NyaXB0b3IgbWFwcGluZ3MiIHBhdGNoc2V0IFsxXS4NCg0K
VGhhbmtzLA0KRHJhZ29zDQoNCj4gPiBPbmNlIGFwcGxpZWQNCj4gPiB0aGVyZSwgdGhlIGNoYW5n
ZSBoYXMgdG8gYmUgcHVsbGVkIGZyb20gbWx4NS12aG9zdCBpbnRvIHRoZSB2aG9zdCB0cmVlDQo+
ID4gYW5kIG9ubHkgdGhlbiB0aGUgcmVtYWluaW5nIHBhdGNoZXMgY2FuIGJlIGFwcGxpZWQuIFNh
bWUgZmxvdyBhcyB0aGUgdnENCj4gPiBkZXNjcmlwdG9yIG1hcHBpbmdzIHBhdGNoc2V0IFsxXS4N
Cj4gPiANCj4gPiBUbyBiZSBhYmxlIHRvIHVzZSByZXN1bWFibGUgdnFzIHByb3Blcmx5LCBzdXBw
b3J0IGZvciBzZWxlY3RpdmVseSBtb2RpZnlpbmcNCj4gPiB2cSBwYXJhbWV0ZXJzIHdhcyBuZWVk
ZWQuIFRoaXMgaXMgd2hhdCB0aGUgbWlkZGxlIHBhcnQgb2YgdGhlIHNlcmllcw0KPiA+IGNvbnNp
c3RzIG9mLg0KPiA+IA0KPiA+IFswXSBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGlu
dXgva2VybmVsL2dpdC9tZWxsYW5veC9saW51eC5naXQvbG9nLz9oPW1seDUtdmhvc3QNCj4gPiBb
MV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvdmlydHVhbGl6YXRpb24vMjAyMzEwMTgxNzE0NTYu
MTYyNDAzMC0yLWR0YXR1bGVhQG52aWRpYS5jb20vDQo+ID4gDQo+ID4gRHJhZ29zIFRhdHVsZWEg
KDcpOg0KPiA+ICAgdmRwYS9tbHg1OiBFeHBvc2UgcmVzdW1hYmxlIHZxIGNhcGFiaWxpdHkNCj4g
PiAgIHZkcGEvbWx4NTogU3BsaXQgZnVuY3Rpb24gaW50byBsb2NrZWQgYW5kIHVubG9ja2VkIHZh
cmlhbnRzDQo+ID4gICB2ZHBhL21seDU6IEFsbG93IG1vZGlmeWluZyBtdWx0aXBsZSB2cSBmaWVs
ZHMgaW4gb25lIG1vZGlmeSBjb21tYW5kDQo+ID4gICB2ZHBhL21seDU6IEludHJvZHVjZSBwZXIg
dnEgYW5kIGRldmljZSByZXN1bWUNCj4gPiAgIHZkcGEvbWx4NTogTWFyayB2cSBhZGRycyBmb3Ig
bW9kaWZpY2F0aW9uIGluIGh3IHZxDQo+ID4gICB2ZHBhL21seDU6IE1hcmsgdnEgc3RhdGUgZm9y
IG1vZGlmaWNhdGlvbiBpbiBodyB2cQ0KPiA+ICAgdmRwYS9tbHg1OiBVc2UgdnEgc3VzcGVuZC9y
ZXN1bWUgZHVyaW5nIC5zZXRfbWFwDQo+ID4gDQo+ID4gIGRyaXZlcnMvdmRwYS9tbHg1L2NvcmUv
bXIuYyAgICAgICAgfCAgMzEgKysrLS0tDQo+ID4gIGRyaXZlcnMvdmRwYS9tbHg1L25ldC9tbHg1
X3ZuZXQuYyAgfCAxNzIgKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0NCj4gPiAgaW5jbHVk
ZS9saW51eC9tbHg1L21seDVfaWZjLmggICAgICB8ICAgMyArLQ0KPiA+ICBpbmNsdWRlL2xpbnV4
L21seDUvbWx4NV9pZmNfdmRwYS5oIHwgICA0ICsNCj4gPiAgNCBmaWxlcyBjaGFuZ2VkLCAxNzQg
aW5zZXJ0aW9ucygrKSwgMzYgZGVsZXRpb25zKC0pDQo+ID4gDQo+ID4gLS0gDQo+ID4gMi40Mi4w
DQo+IA0KDQo=

