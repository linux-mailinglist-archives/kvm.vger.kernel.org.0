Return-Path: <kvm+bounces-9269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CFAB285D02F
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 07:01:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E8CE81C23733
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 06:01:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E57039FEE;
	Wed, 21 Feb 2024 06:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dUAkKvBO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2076.outbound.protection.outlook.com [40.107.94.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D52125622;
	Wed, 21 Feb 2024 06:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708495278; cv=fail; b=IjqhwB6MTKtqdEcny+tYsBgok0VoTUw4diqLftDfggOJk0lvbAnUa0BAzDJPE8tPigDLJC3zxN4M7vSH4HtpeV3HNZ88h9YNP5ufXZZOMvE/ZpRT5RFGxzXDva9X29PoDH+GhXX/hgTDJENCHtvaFnoqnQCtQ+gsQ/f9QF3kXlw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708495278; c=relaxed/simple;
	bh=ZqtVFUECsj0fZuvs5R/NE9TJcBHBK9xEat3lvDnAs7w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ip9ZMk73D1Ejb1QXHH9w3/lmmyMsqUameSnV9hSeWgmIk2UxFT/J3GqY42ApsdW39peLkoK+46p/PCIZNM8Kt6DTwa6Mmh0U4eSALpx4arc42BtCTgQHza9rMjKPCRsTzfNHwQGfsmTCL872MRC7NrQSQSJb2dA23BBACm3bSzc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dUAkKvBO; arc=fail smtp.client-ip=40.107.94.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cYyCshMVumsEguwyPexNoj9RisKLJKmRnd5wKr1AShgSAw4K17MOE3X7pXJJt17IMbVlNgzLY4NZ7br7UlZkY3fgOL4l16BqMvECQnklL5BENfuS/yCRyyX8dUNgPoiPx4cklrKNXKqI7vlEt7XGyEnIViqKfKcDJVe3y5lH2m5Ylc9sHv614Jwb3Tb4N3xVte/Ee0dyXFO5MTcuwh82ZW8FsUEmlGQHXmfoh5imAA+39OBIBYF8BseMJLAUYBncdXIJJAEKtUVv1CpYUyme5tlA+GZMZsCfGjg71DGaONV/0DLMnGzvTrYrm91WNiSO8yz/onqXbywHuOHnpsHW3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZqtVFUECsj0fZuvs5R/NE9TJcBHBK9xEat3lvDnAs7w=;
 b=AZtSOng9I0D2Eq8Ji9yq1yzxdYE91AsTsHs5vmj5qCGr/ZGLggpZoZw0K1ky1GNASmHLJH5HMZug34Uv1SUnm58/0MohGV1eU8qXPJxLzx3jmRgON4lv4tBeXiH+KD4eJ9cNXitpMGL8HXAffnQKjsRdYbgig/DbiHzlaLTmulTzOovZq+yu6R0Uhv809WoWYIbTy9r+rdibRX0bWqU6IinramLeQX5v/Jpv80K7fMU3GAQC2CN0Q/Pmx85K41ahBWLblFCyqiu7fn5u4C7UvUGrG7secHXdSeJ8eqi+Q//t1pRZI4bPcBeiVd3X5uAMexR1CQ1x77SP8kumimpong==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZqtVFUECsj0fZuvs5R/NE9TJcBHBK9xEat3lvDnAs7w=;
 b=dUAkKvBOHckTUOk5IgLhJmEhF4CIxYKSkkB/0CXnP4Fht104kB0Xw0liKJpbUeOPzHedOo1D8zw5JWtvfognhjWW8H6GHiBXD9wjA9R5tPSUHnRRKWCNf23IAxWWqPntovUQEZtXrinWyk5gNBYNNk/DP80GS5aYTeIpDc2xw3kRENxVhFiKRVNz5Z6m5rGeeplQ90tXtq4aByZx23EFn5f3IPPZLsQxxmmca3IrvXwYQvqc95i0SPG+haZzNDsyYpG6kZhEC67W/bjdyGakjUR+XA0oOEgEXzlS/VDEqa61IylhGH2z6glaBFwcqEOgVnVq6/o+rmyvbbp7pzp4fQ==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by IA1PR12MB6602.namprd12.prod.outlook.com (2603:10b6:208:3a2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.19; Wed, 21 Feb
 2024 06:01:11 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::284c:211f:16dc:f7b2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::284c:211f:16dc:f7b2%5]) with mapi id 15.20.7316.018; Wed, 21 Feb 2024
 06:01:11 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Lorenzo Pieralisi <lpieralisi@kernel.org>
CC: Jason Gunthorpe <jgg@nvidia.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "james.morse@arm.com"
	<james.morse@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "reinette.chatre@intel.com"
	<reinette.chatre@intel.com>, "surenb@google.com" <surenb@google.com>,
	"stefanha@redhat.com" <stefanha@redhat.com>, "brauner@kernel.org"
	<brauner@kernel.org>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>, "mark.rutland@arm.com"
	<mark.rutland@arm.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"andreyknvl@gmail.com" <andreyknvl@gmail.com>, "wangjinchao@xfusion.com"
	<wangjinchao@xfusion.com>, "gshan@redhat.com" <gshan@redhat.com>,
	"shahuang@redhat.com" <shahuang@redhat.com>, "ricarkol@google.com"
	<ricarkol@google.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"rananta@google.com" <rananta@google.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "david@redhat.com" <david@redhat.com>,
	"linus.walleij@linaro.org" <linus.walleij@linaro.org>, "bhe@redhat.com"
	<bhe@redhat.com>, Aniket Agashe <aniketa@nvidia.com>, Neo Jia
	<cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy
 Currid <acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John
 Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, Matt Ochs
	<mochs@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 1/4] kvm: arm64: introduce new flag for non-cacheable
 IO memory
Thread-Topic: [PATCH v8 1/4] kvm: arm64: introduce new flag for non-cacheable
 IO memory
Thread-Index: AQHaY86h4Cva4mNx7U65b8+zrBQke7ETSjgAgAEELEw=
Date: Wed, 21 Feb 2024 06:01:10 +0000
Message-ID:
 <SA1PR12MB7199442B899E437A3ABA2950B0572@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20240220072926.6466-1-ankita@nvidia.com>
 <20240220072926.6466-2-ankita@nvidia.com> <ZdS2yl1kzZv/h+vH@lpieralisi>
In-Reply-To: <ZdS2yl1kzZv/h+vH@lpieralisi>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|IA1PR12MB6602:EE_
x-ms-office365-filtering-correlation-id: 40f7af05-db9f-4f18-7b65-08dc32a28101
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 1RjV579hTVJJdL7BpAqAkHImD1ZD4+cIJ44AO82cVwicumhssqF1D46tXZjlpn0OaWbWCwOWSwax+FQuuV/ezdYF7gWDG5o/mUIQkgFgorzNiEoLLtw3glu13Gy2QjDvmVuZKiRVSOAeOWaLHy9LbuM5+QYwwaxT9tMSokCeUJy0gy5RUFG6SlSCrLIHKVfgzZ/GQrs1ejs294vGDR7ReuERPWrQfjK+a18/hH1R0Giae6xVuRtl6nZ8Vf4Llnpy7+Zjh0n3JiYQodfkvpwmKZgQmLA2M2+nLFwhagA3mtStRcE5T7XpQs811kUlL/5wDkb7VrCURQLeRLwOYR6sPGSx8LPK6KN+3WdOTxmrUJgZr3dNPoETQJbfjVO5RafDBjH3quy3KghDxFnElIvCmhSB9Fvg4JKeUDXpOpzErLy647SIaqcDgR7uD9yXTwMUhy2D2Dl+hCaJzpoXQUijP1hEz+1h0/pRxAU6qoxMXyk+Q2IZPMybN8PtsrxAT2r93/VIDaHrx6f0yy3Oq93cRm6qEtGJy0IW4WxxQgiuettKq+lRVHNPAGDpSakNdPgQkgUu5d7hk95UsfOF8ZMzP5g9UyHGenf+YXgQ/Jb7ZAUx7oV3OYNfUUY1R2imMD7JKFWDfbuU4rF7zavtS59IGW4k0NjdhFTDdNIAy7UlTZ8=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?SPsbbAWLEgLefEwToRflsNbEi1raM/QEwk1qXJbEoqwnfeqwQpPTEfk49Q?=
 =?iso-8859-1?Q?bUyzwRFjiGdBGLYoqz+aD0h3xcPDj4ugapZz5DPyOo5HUk00ha3Hf7sHmB?=
 =?iso-8859-1?Q?21Z8RxsXhpifLC2ij1P6BVA2Bz7iFqZHLEh8YjkVPL1jcWq6yhWEBHsmBK?=
 =?iso-8859-1?Q?g/8h1r+p6h2WjWQLu7pLE7ngpGQL5wERhB5czAULsFu3LhzT5qmDsxvWqS?=
 =?iso-8859-1?Q?aqnj9ZUaFMY5iW9ju2ZiTsEsUkJzGuq+0Eh0wGQdu9ckVsnhmRtJBmVh0K?=
 =?iso-8859-1?Q?p5dft/nFSQOXJfEBG1JDbfdFS0Zl8lQa3nYLYDS5zZDDB7GTrBJG/9rScR?=
 =?iso-8859-1?Q?ET1I6cLMYt14Yo7YI6mAM08qK3E4iG1pLsW473Z9KjwHUiE1+s+o3ufFtW?=
 =?iso-8859-1?Q?QzBf4v57v1v466TjUXKz9yBpsVG/tVV5t1i75ryemqQz+K6iLTnSpFMVGs?=
 =?iso-8859-1?Q?ojBSG/9twVRtu33bzufWM93IXeb1W/U36/G1EAE8d+OOipfGN+3f2q49a+?=
 =?iso-8859-1?Q?qoqTKfTEmFqN/BgnX83cQ7NfbrXxZXI6mfvT/8fVW+zTpMDiqizk18b60b?=
 =?iso-8859-1?Q?1CSliK831jkg4UJcEWd3ctuYQBdZebPhiY2Oc8JZQi5Cj1JKiPTgkCPPzl?=
 =?iso-8859-1?Q?lA8GRQSSTchHJPMh1ETqZmht0Pam6mJv9CHNF9DB5TnmkKdZrKl3bSs3gk?=
 =?iso-8859-1?Q?cFmQJZvBPYgINduTTRoSo4Hd7ufuuotyhPAszs8tRHD5ch8NnqZvFonyYk?=
 =?iso-8859-1?Q?e5EwBFm6vYvt+JRXPQIhyGNLrWUA7qEFfHI02AkRaQt1F/hTYMzu3fCNm5?=
 =?iso-8859-1?Q?Fcgg9UzkbPXA8bcOnHt1pxg138vIA3AYI6vL4DZQAJBhHJU+fqkws9XB1S?=
 =?iso-8859-1?Q?/gvbJqrhBG81RuLFrqXzyRCmREVbYyM+qUB3PPDQWxAaZsKN/bttjxJJas?=
 =?iso-8859-1?Q?PUVijqBRop7RuYh2m2S471Knw6aJ7+IANOrZmNfMbRhXuplwZpDywWy9ZR?=
 =?iso-8859-1?Q?QW6YhDgF70ldCzb8GgcYpJxFsr3oPh5i5xjTEkZbEFLCVOrMbT0CXuMCU1?=
 =?iso-8859-1?Q?YFyr1KX5ZNpRr9DnE+gdoY40dETEEdRkZYwrFDD1cPYiY43QPrZWuPovPr?=
 =?iso-8859-1?Q?WQEjMve51c7gKZFQzjxCtxHwKVvizQu3Vk8ZReWurSa+KoqVxyvqwGgYPM?=
 =?iso-8859-1?Q?/EtyIb0BXY4ziPdkuSpdnkJ/FL94FAmiTEcvkjLAQs6YbvaTHO1IFnBKsU?=
 =?iso-8859-1?Q?c4VMUyF67uAKKuN8gYZtBRl1jtvJT9lbpH2NKtmBn2Txie+8NylKD04Dc9?=
 =?iso-8859-1?Q?Hb07fUXguql31iSDp6lrDKupHjU0ytKqmB/sdWMYZfmJrzRGTZKrMy8Twn?=
 =?iso-8859-1?Q?c7sLieKh1Vv0VgV7gk86g6fsIa99oUtiti2TknhWFZXfEwBoLM4S9EDpRH?=
 =?iso-8859-1?Q?AmNtV3sQagZi97FEVegT2BoMkWfhEzIEcxqGzpbzqwfXTijp8CsSkCJuUV?=
 =?iso-8859-1?Q?OFR1L0pgR3ZbobcLw3xKHcbKy6P3Ir4rKnTiDTJM4XMna48E/1gAEzrsn/?=
 =?iso-8859-1?Q?oIOLL9WeGLAxsjn4JpoMTTTk7rMrI9iS7TIVHyThro9b0DdcIKSrRISO/x?=
 =?iso-8859-1?Q?eSibB0nSrmTe4=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB7199.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40f7af05-db9f-4f18-7b65-08dc32a28101
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2024 06:01:10.9932
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D+BY+1z91zkKxgVJvTvaCYEKkEgBzidrrGXyfG1QVILVz6K8firvWTtze88zIFPSdHO0g15jfhTLSSTBfla8Kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6602

=0A=
>> Lastly, adapt the stage2 PTE property setter function=0A=
>> (stage2_set_prot_attr) to handle the NormalNC attribute.=0A=
>>=0A=
>> [1] section D8.5.5 - DDI0487J_a_a-profile_architecture_reference_manual.=
pdf=0A=
>> [2] section B2.8 - DDI0487J_a_a-profile_architecture_reference_manual.pd=
f=0A=
>> [3] sections 1.7.7.3/1.8.5.2/appendix C - DEN0029H_SBSA_7.1.pdf=0A=
>>=0A=
>=0A=
> A couple of Link: tags would not hurt in my opinion, lest we forget:=0A=
>=0A=
> Link: https://lore.kernel.org/r/20230907181459.18145-2-ankita@nvidia.com/=
=0A=
> Link: https://lore.kernel.org/r/20231205033015.10044-1-ankita@nvidia.com=
=0A=
=0A=
Agreed, will add.=

