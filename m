Return-Path: <kvm+bounces-8432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C745384F676
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 15:05:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3EAD3B222E6
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 14:05:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ACAF664A3;
	Fri,  9 Feb 2024 14:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kVB7zAJP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2044.outbound.protection.outlook.com [40.107.92.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0ED59169;
	Fri,  9 Feb 2024 14:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707487540; cv=fail; b=O7IHzzZ23fTOg8/OyJYDz4+KpINgrG6VVq1lCj/0WY/rb2QqF7qxwUksFtSkmC7zfBJcihbtt+pDKSyTti0aRaPbFq28UTt8gEyKSUlaeGMHjSD2SDLM4ya35i+zibKLuHDh8pFMCA5Xhi4KbphQNOcOnY7l12CWUcVZRx/M6AY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707487540; c=relaxed/simple;
	bh=VnaVAgshA1xZ1/RgmEZrF2afxeGxJx7M+PSzcz9nhG4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GGSEBQ+VOGqYUVtSKbkGgk9gr4dyHmJgIP2OrXwuYW4xMk8g7kPIeAX/z+TAREUQq2Oxi1RlryLM5mwkoFT2cHu/uzI9V6Xr/mWPSGb8UJ59XaIwOWo0EXAfHX5kSWE+Y2yi44V/th+WLgX+y22G0HNN4ozFzzpUCY3A7N0Rk9M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kVB7zAJP; arc=fail smtp.client-ip=40.107.92.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H+ANe1hV4AAi3f0VYiuwFBGcQfRSwJLpqytYBmhl1HwaWBkiG2TwunkA3fZFGgYTMU5T0/GzBMCDzXs7IJvcpeH4nQR476vcwO9sll7666aEETYxK/13Wf6u2Y6F5dAnI3RtHZM5cfJXmPAw57TQwRG7exGCaPqy/7P+bBxL/USuKpbfCbTaZt4iuwvsFmQfeWC8kG7N2lxcoTkbuaSoiWGxlXtUnnPeTgOWQe8kVf/M5SwFO1G12hfMy5oCGrrzPhBAnke2PDVPhs5IiIBFpn4k7xQcn00h1N6lIR3+4WgmAR6MJE7h0CpxljT2MGn2kDdEY0ZVYdElCF/P2/pRww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8uQNLn4OM8ezhV5TqT3ehCuqDqCjcuma6wUWcIdI+2o=;
 b=OZgQdkF1kCCUdt9GXW2r8GFIaIDAOy0PSPXea0PJWHXJpiGsn+i5p7CJz40BqZibLmsllGk9TB5PYliM5/H7VGvuSciftrBTwgQVmr3iPH5qD7VBP5WGepRwBtbrlm+vYj45XVNb4P6VtQffdEjPsv906ictvL3eKXOUdncTYrmoovdBGwNREa1yFXl7V889wgJQ38IE3WwKmY5vEmkQu0t7fnBd8pqDBJeX5/zJy1r4RNYMNrwPxSnjcoo/YoZ69N9azf7yFQnYEKpx0p5yTcJ6KkjNv+HxEQkyLojNPBNnjbx4rTWQMQL10ASuV6iCEAdmV+XX9DNwIf/3XWDUIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8uQNLn4OM8ezhV5TqT3ehCuqDqCjcuma6wUWcIdI+2o=;
 b=kVB7zAJPVLyGXthYUSHmivSoWw6q7zXbNoQGvhjp/0FpFoLP5aRdQCHjaVJflpGpWK9REw16XSE7r3Tf68ClAqWKOvF+MvS5++B8NG/MYPuflasNnSLjvKcBQIc2SKfo9rodH7UyEfgAgNeRpHRVWk/BYGu+wFpsGnFXHOUHgOvifFDfoReFxfArbKVLg92K7n4kYryD4g16/E48yCkbbeHRbdT5OjtcLmt5ahGLbwjNoKCSlVpNscEEKgbLQJ/4w2W2k20FlTbiq8VRDv0t4OVLJGPFtCIUIDm/8acGej+9f1ng8pE+4NscUAjsZhmpPEL/rQycRR57igeYFBlu+w==
Received: from MW4PR12MB7213.namprd12.prod.outlook.com (2603:10b6:303:22a::18)
 by DS0PR12MB7928.namprd12.prod.outlook.com (2603:10b6:8:14c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.15; Fri, 9 Feb
 2024 14:05:33 +0000
Received: from MW4PR12MB7213.namprd12.prod.outlook.com
 ([fe80::b68c:1caf:4ca5:b0a7]) by MW4PR12MB7213.namprd12.prod.outlook.com
 ([fe80::b68c:1caf:4ca5:b0a7%6]) with mapi id 15.20.7270.012; Fri, 9 Feb 2024
 14:05:33 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "james.morse@arm.com"
	<james.morse@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "reinette.chatre@intel.com"
	<reinette.chatre@intel.com>, "surenb@google.com" <surenb@google.com>,
	"stefanha@redhat.com" <stefanha@redhat.com>, "brauner@kernel.org"
	<brauner@kernel.org>, "will@kernel.org" <will@kernel.org>,
	"mark.rutland@arm.com" <mark.rutland@arm.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"andreyknvl@gmail.com" <andreyknvl@gmail.com>, "wangjinchao@xfusion.com"
	<wangjinchao@xfusion.com>, "gshan@redhat.com" <gshan@redhat.com>,
	"ricarkol@google.com" <ricarkol@google.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	"rananta@google.com" <rananta@google.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, Aniket Agashe <aniketa@nvidia.com>, Neo Jia
	<cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy
 Currid <acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John
 Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, Matt Ochs
	<mochs@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v6 3/4] kvm: arm64: set io memory s2 pte as normalnc for
 vfio pci device
Thread-Topic: [PATCH v6 3/4] kvm: arm64: set io memory s2 pte as normalnc for
 vfio pci device
Thread-Index: AQHaWgbqzxp12E+Dp0ie5adhqGIMC7EAiIsAgAGE4n0=
Date: Fri, 9 Feb 2024 14:05:32 +0000
Message-ID:
 <MW4PR12MB7213AB84261541A75F88FBFBB04B2@MW4PR12MB7213.namprd12.prod.outlook.com>
References: <20240207204652.22954-1-ankita@nvidia.com>
 <20240207204652.22954-4-ankita@nvidia.com> <ZcTqcqE69zkLZgQx@arm.com>
In-Reply-To: <ZcTqcqE69zkLZgQx@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR12MB7213:EE_|DS0PR12MB7928:EE_
x-ms-office365-filtering-correlation-id: caff373f-60c2-4853-2e5e-08dc29782e50
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 Ksprs2g/kKYxTjwbnOEXoE/BC6jU8W9P8eGEar53VCggClLgcKwCI5hwkV/3vOrBPAeWJKaEHjaz2y+HRRBaz3+52rQ88mtd8RoMbZkje5HxDyco3M/1U8BSDMlX/yvPjVAlpOIaYRlEISmXgpAcBwSulxRFo8Jf6CRjP9/QwPSCmfw6RJRs2q/zNL9ZJwbAVxWxO7ckzjdbmBhAI2q1uoMXT9HL5kSgyOB3fNnAbSctSS/RrjIxYGd1Ano+sbt0JYCNdStBjKYzU5lt4iWeZqavGSKMrQBw6flJi065jAoAFqa8eq2MTQgQD1BRUuGlxB7pEccIGDfVlYvefqA/w/vIkmiUWG2+xHI5VZP3Vt/HLJiu0EfZ2ecVYWRo9BEVs2HY0G7K/rhDM7Kf8EfRBMx1PrvIuIS954IsklnvRRTCz02c0Lwnx2/ad2I55blGD4DhLXp24GCHyPGWvcdS9HApNbAZht7TD1IEWxXJmFlvy5Guq0oPGHh9ZVmpnRsGWFRJt/zAP31VEno6m1iVF4hy04e1zdQfL1652mczya1j+TfoQCCR4onNxHjoJzKd9fwHTAd5pk1NGygy24nGfFUKfdDk2a3HF2xHf3163jTGmUsYvo6NE626VraugeJg
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR12MB7213.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(376002)(39860400002)(396003)(346002)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(52536014)(7416002)(2906002)(5660300002)(41300700001)(4744005)(38070700009)(55016003)(86362001)(122000001)(26005)(33656002)(9686003)(478600001)(7696005)(6506007)(38100700002)(71200400001)(76116006)(66476007)(66946007)(66556008)(66446008)(6916009)(8936002)(91956017)(316002)(54906003)(64756008)(4326008)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?jPxiGhFH+Hw9pmYRBwzdlAVCfcMhUKzEYqBWwzlhrfoErghK3YHN+CNOMv?=
 =?iso-8859-1?Q?J99q32N8BgtO/5Dbj10GnnGt+I3joJyf7Uq+Qzp0gnVCMgLQ85gaaNdqHW?=
 =?iso-8859-1?Q?FS2jPgNQtEpb3E2a8SbDCdDqIncqaxUly1pUYrx61OwE5XkYgqWhbK+Xoi?=
 =?iso-8859-1?Q?CM/R2MMwYLY2pLja3TyPORUNr3dO3AnILFOTX2TPH6ZMd3OVUb4/FcCa+n?=
 =?iso-8859-1?Q?UXnymplzpI10tBUUIeC4vx+XAolzBikWtcgsDtUN3jSaVzBekZ2VJHv9x0?=
 =?iso-8859-1?Q?hlu/i2Zy26tOY3Zouvrw7NYzDNc1ZZEL+PikxlRl8BgkZCC8GLEGt3EKIQ?=
 =?iso-8859-1?Q?/jerygSlrMEpbNlcwqCiAWaNn/0MAqopSdM1haBBXVQa2wUOqjboe+Qipj?=
 =?iso-8859-1?Q?EXzJ4m6Aw+BynJXhfMslGYheS9CTc/vKXYAAJTcrcQzHgy44ZqGI5djMLi?=
 =?iso-8859-1?Q?W2qGKYpcrljoYyoypMP0vKK4JIKVpHGZNrtXXIiUkebtPdcc9F+DupFKzk?=
 =?iso-8859-1?Q?SsxsJ7JmaDg8F7/R63SLnikdb8sn/OzsNpCq/xGIx41qWN/Lk7G88bsYhn?=
 =?iso-8859-1?Q?0aSvMbKsbuZPntBSVLA2JjbyqFUmQr5/Hu0YTbxLTrtDBK8dhMDyA1XxAl?=
 =?iso-8859-1?Q?lqi6sU6C6rq5CafcfjQbqjMzSrAdbewQbeMIR7rOVHgMD6Nzal8hjITQx/?=
 =?iso-8859-1?Q?yj0SHh6xkdSdVBTHqZDnMReK7DQPaTM3ofN15lqEsxjInwMqzv5EVDC7fk?=
 =?iso-8859-1?Q?wwr65ZPcz0PFVhWcd8xEhC2+Vy0L+pVf78PHup6yy1bRe4XKyfLrThlJP1?=
 =?iso-8859-1?Q?dqGVaDxO6nF9I7DGWKUh5Fr5Dgbiv6vr7aPVENa0aZbaZ0w/sCgMhWkoI/?=
 =?iso-8859-1?Q?hV0KMmuNd0jnn5TPt0/Y/P6ltR2ganUwt1g5lLticoEXK8/yw6RwqyIrmC?=
 =?iso-8859-1?Q?i945/PI+RXH6OZCo/MrAgF8+ZNd+yLa4GKJpGwX21lBcsL2yv4iNFZ2v/Z?=
 =?iso-8859-1?Q?rbUboZGJz45IJOVYuoMHJGn2v6wei6LnaZGUg0ZhxP6JQ0ucxymEQvJJBh?=
 =?iso-8859-1?Q?L9Ri9pXEowtaYDJLn2aMvj+5gJua5XoPT9zf0gFzzrI5psfiM38MtXuuTs?=
 =?iso-8859-1?Q?Aui3Ndsk+tQ86UB+g+C979Pmjv5J3Q3GUdKt9nUvRwuNoRMeMC1DR2vnxs?=
 =?iso-8859-1?Q?pr2nofFVn51O4xXKHSRbVnBUjPxnJW8k1xjSC0H3phPaUmOPFv/Lzl65fJ?=
 =?iso-8859-1?Q?JyhaCxSnm76GLAAs3NXE3PCtPMwGDIhulUJ6m3dHGiA3s9Z9JIujrl/tLM?=
 =?iso-8859-1?Q?AEbivdPO9fCGJgSIafRgSawN3Lhgc3ufpZRk+oMCkuhF6QwBhhO+PW7tN+?=
 =?iso-8859-1?Q?zWVidHO2bFshEAORsWl5Gi++opmgiOVEg9ihFdbZYnvxId9cUhWb5YytPi?=
 =?iso-8859-1?Q?VOnAvmMrmsDJEKM2b5Xv7hVCnflbR9ANbcapZz5dy7Zp7vwRkkPx8aS+rh?=
 =?iso-8859-1?Q?Q9Btd5wYVdaQqnR+rce/FbYd2WX24+T+vH2Vl8QBG+CZkfkI/dyC2bxQUU?=
 =?iso-8859-1?Q?8N05T6pLi88fkMI+rS0V8FcuDAcyl1yESad2nOmoadqWX1sBavO8LQrune?=
 =?iso-8859-1?Q?rLIg5LkBlaRjo=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR12MB7213.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: caff373f-60c2-4853-2e5e-08dc29782e50
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2024 14:05:32.9239
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B7dSH0bZftPm9hjnEx6BBnK8butiWhrwIUmQqmVSCjEWMdyX4IZqZeBHqIUULhjPUy4NE1pGVIvA7xG0aR+l3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7928

>> +		/*=0A=
>> +		 * To provide VM with the ability to get device IO memory=0A=
>> +		 * with NormalNC property, map device MMIO as NormalNC in S2.=0A=
>> +		 */=0A=
>=0A=
> nit: the comment doesn't provide anything of value, the logic is rather=
=0A=
> straightforward here.=0A=
=0A=
Sure, will remove it.=0A=
=0A=
>>=0A=
>> +=A0=A0=A0=A0 vfio_allow_wc =3D (vma->vm_flags & VM_VFIO_ALLOW_WC);=0A=
>=0A=
> Nitpick: no need for brackets, '=3D' has a pretty low precedence.=0A=
> =0A=
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>=0A=
=0A=
Will change it. Thanks for the review.=

