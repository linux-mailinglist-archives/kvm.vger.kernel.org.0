Return-Path: <kvm+bounces-26093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BBEB970C9A
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 06:04:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D72B1C21B2E
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 04:04:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2533A1ACDF9;
	Mon,  9 Sep 2024 04:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FBdkREN4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2075.outbound.protection.outlook.com [40.107.96.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C001214A84;
	Mon,  9 Sep 2024 04:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725854640; cv=fail; b=uP7W1c6eDbxfp3SFTPSUTy/buAPDs1+b+fWheCeCRpeGWS51+uhOWB+z65Atr2rCopOQL1LqLV890r3nDFZ6y2tXj92lo8WsMP0s8B055UVVEawwa9DJf3vGIHnyQ9tK3/h/Au6ORrEcuZeKAACW9wKXaxNkcVK+T2l21i4HyyY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725854640; c=relaxed/simple;
	bh=kflKEJOHn8+g+mpKDaKMg6ZInElSNgwLe1Njw1FLGIQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Pvwpsvs+hYClQ63PtW6FeRJbJvMtc7eIBedzKbrxvqf2D/BbF2V3BA11XZryauOfim/Kk+Lj765afRmBKcOj3W5AthEr1U2t0ml4spiy7zdB/UiqdS7Lo0LnhSYIDgl/s9wgOgaDTlSB9aZ8aQjYlP5Y8fGMEQZWMY8KYCBBW4o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FBdkREN4; arc=fail smtp.client-ip=40.107.96.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aJcFWb+PJ1D4/uK6woFQ40BKFmNN8WQt8FcVUHNf2CzfYenKStQQsyQQJOCLRvLkOCv/IpFkZF+vPoaQbglE9HL6OFrpxwSeqvUCeJMQgJSzm+AD/eP6ZFMcHW+Ntd6/xhqu5Bxfbpt/394P9MZEkt1QddiY057a1we0+e1mBquoLcy3X7xWqvVJVVzzgIHKX5WLOj7Z0yRj+dHt7p7V/ixTXTGvFbrP5jpOu6SE1njfTgD4DPK4ZOb8HG+KjzLOx1qLh6ZC2kEZ8zeAlVMmjy0nT0OyU66WZslWjgVIwLDxHt899Dz3nvSo3rG3CMljPQh7k3vqm2SRFpBc2GfrmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kflKEJOHn8+g+mpKDaKMg6ZInElSNgwLe1Njw1FLGIQ=;
 b=slVSD4OeuNQ4ozfIQG0ketu8dxjayNV/R+RdXrcwVHbv+fjtsrO2fmf0ZnNd3l+qbpYnZy/kHzcL4kukcNFNl55pmdMD5vh8/+3JohS6fp9rb01Pfs9sYhOOwZ5F264yFonrkw2fWVN48tPbEkGXMo+6aALlOOu3Q7J8ya/K4Nc/N9+BYTJAXqbX3c0Bg8Rubm93L+G4K9MpaH4fLGvXAYuJZqHmsdpiklGP2qPQFZf8TwvCGrVtklOQzG/C+c9ZvV1qHuk/iVQ5I11LS4Wnwq6f8f757kgKAM17N2WF/Y4S7ncyXPgtAPLaskr8HjHCMcY2qltOsM1v0fcGAONRhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kflKEJOHn8+g+mpKDaKMg6ZInElSNgwLe1Njw1FLGIQ=;
 b=FBdkREN4naSTgatiINRMhl9TKQ0Yv9sJrOBXPzVyLSRT0VmF6wLLnAvzkhwDLNkiK2XHc4MUewjVgzHNDNCZoXX8KsFkKofoYz+gIYbKi758BW+M4y0b+/AsRhq8wjwm+ZxaiNPVqVvpv5raCc6I6aR1qXjyLQonXwSkl/0RhjgGgPQkXXlAkz/6e8tESwbywdqQxjdyGB+uKY3Hobgf69mghS180/4cC3FwgEuWz8lmpqHRK15mp7HvOOgi976nyiEC0TsEG6ax2B3n0zgAuPuQg/3CrRn/W4/NJpoPACnpzkr6iAKZSijrd17aEt3bkIF/3gbdcpj3VS/1iPk9lw==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by SN7PR12MB8001.namprd12.prod.outlook.com (2603:10b6:806:340::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.22; Mon, 9 Sep
 2024 04:03:55 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%4]) with mapi id 15.20.7918.024; Mon, 9 Sep 2024
 04:03:55 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Peter Xu <peterx@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>
CC: Gavin Shan <gshan@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>,
	"x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, Andrew
 Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, Dave
 Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
	Alistair Popple <apopple@nvidia.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Sean Christopherson
	<seanjc@google.com>, Oscar Salvador <osalvador@suse.de>, Jason Gunthorpe
	<jgg@nvidia.com>, Borislav Petkov <bp@alien8.de>, Zi Yan <ziy@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>, David Hildenbrand
	<david@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>, Will Deacon
	<will@kernel.org>, Kefeng Wang <wangkefeng.wang@huawei.com>, Alex Williamson
	<alex.williamson@redhat.com>
Subject: Re: [PATCH v2 00/19] mm: Support huge pfnmaps
Thread-Topic: [PATCH v2 00/19] mm: Support huge pfnmaps
Thread-Index: AQHa9/i4MxIUuFc0iEilM2ZdWpqZPrJO6Kux
Date: Mon, 9 Sep 2024 04:03:55 +0000
Message-ID:
 <SA1PR12MB7199DE6F9F63EEAD93F66249B0992@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20240826204353.2228736-1-peterx@redhat.com>
In-Reply-To: <20240826204353.2228736-1-peterx@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|SN7PR12MB8001:EE_
x-ms-office365-filtering-correlation-id: dc6ac940-b95f-4c0c-f7c8-08dcd0846c87
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?66h9wUI2Wi75SK6pBAt1JezTcueHK+5s3TSSuc1kS0Kjqxupzk6cTmc9nD?=
 =?iso-8859-1?Q?aUM39xhDuhO3QQ1ePySYrw2NM4Ne1i6ORHK9KvCriTOA2ASSLhTqVgPUPa?=
 =?iso-8859-1?Q?oXdmYA/5pLPJzHeC/AVtRh4Q5rdt0SIHU+wTRMGG03t75vC9POdn4UIn0F?=
 =?iso-8859-1?Q?tMaed4oQu5HFx84cj+CQRUZEG6AaqcKD73RPyVDi1s25m1d69X63ZDfUBQ?=
 =?iso-8859-1?Q?xqr2dgsx3AQ9yWUdo3H3xufjanPK9OVfeLIBLv5eUK4ql8AUunM2dCwdvP?=
 =?iso-8859-1?Q?3lo/kShnxT1X1SSBJ0GxHVm0kWWXgoe/RE04/q1NuMeeTX+r1uHJ93Y+Cb?=
 =?iso-8859-1?Q?HcODm+6GfRZuzjPCDpaYN5gaL98oQXpVkv8eFjG3jXSkBQZbWBFnlTiDp1?=
 =?iso-8859-1?Q?jUZlhGuIqXImjs7ddC3Y0u2PMyBha5ijxEumGPcA4HayH+QBKZKdAlPQRh?=
 =?iso-8859-1?Q?RujlJYekE0xlmh6ovyHY8oBRWNp0mh9aYvmWpiOVlqEmBBCbtrJURy5Fvu?=
 =?iso-8859-1?Q?03lZImCSFwHz+H7RqsGqGYnR23FNXyGCcY8WZN8d+pz48CfkE63pY3lFVZ?=
 =?iso-8859-1?Q?oIBUGGIqdh66ZGZf+ihIuoDTKbFL7hrKXqC/qBks31GND49Z6unTgsy9WR?=
 =?iso-8859-1?Q?R1BY/kih9zDVbtO8daXpw6Fjc8SaUv0QsstX81S96a3jqi5Rq5uhy5HJqA?=
 =?iso-8859-1?Q?APBOkcbWvLrw+gs4bp6NZ8XbL/vF7B+w9uqzJjlKNuJdX1UzqahYev0E6A?=
 =?iso-8859-1?Q?w06oveSe3MPaq6jvUxb+Vz/Vd5FrgESIEYwvXjsW6yJ1//9bvHH4ibMfuw?=
 =?iso-8859-1?Q?DfbyD8fxSDOhOq4Wste9+Wxs8BHE6/DN7mSmwqobOfplmMQaZJwqxwzpVA?=
 =?iso-8859-1?Q?RlVhuwqU7xceCDT2wRGN6Tmcnw2lnEP+/1z1bNvBHVDHkWpam9rySYX0qS?=
 =?iso-8859-1?Q?hMuOSULoEfi8YtLiKz/AnWoSrYkwk96rnqEy4+7rDx0S5tMZrggrziep98?=
 =?iso-8859-1?Q?XmQORlRaYl7IroqcuttPNAifrzC3v/8fR8XN/+1r/4h3kWjCWc41RAwrjn?=
 =?iso-8859-1?Q?Iw7kSqR0TCxt3P4ZLFGEfjQoAR2SMZJ9DGJmv22ZXWUOH/IsMrFqVdJ19S?=
 =?iso-8859-1?Q?z1mNSmw3VxNC2ja2t5lGrHe8qTILgCY+FWn9TuvwQwVCTj4pfeOWDaTkWk?=
 =?iso-8859-1?Q?us0FB3wGRWpSf5wTW5+CnLPWu4nOps2Fs616sym14QIZI7d+CjOrPcFqOv?=
 =?iso-8859-1?Q?bej84lp4lh3SeLrIYhUc6Wixhh9uesOPWiyURwWKxe+Wqev1NbNw7jmIzd?=
 =?iso-8859-1?Q?TioD1DDO6GEITX4s87p/S3ZhfiQRlqRpApYGZVmfrHtyV/nzjyZbxNJoSp?=
 =?iso-8859-1?Q?YRT13ebxpuPiHRA0xYBepzFizdodMp/poeygQo/ShVBWhsfrdTV0Kl0hlS?=
 =?iso-8859-1?Q?ORlcWp13rOTPusb4CSeEPZq90izTORS1zpP93A=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?26Lfwf78atWtwG1D85WyZCY/QQb8/QnNi4Xi57YZbrS/ESEqyUp0a+vlSs?=
 =?iso-8859-1?Q?zGdAvvtr3yWYqPf5fRMYPNOrZ9AM4XnM8+07i/JOd60sXr1Iu9yndi4f/Z?=
 =?iso-8859-1?Q?qTYf4LjQR7qs1rTG9zPTyjTcG9ThDEEXKhM4kNhVVXI1caOw8YmGumhcMh?=
 =?iso-8859-1?Q?HO+uzAqjpHfceTbATCrAPJyDSdca7nTRysyD34Ihoi4fiO55SGNKgU2xDX?=
 =?iso-8859-1?Q?Qx9rOlD17MUIIh+zimH6Q01x+OZNPk1yG79mzW28tIlex0neXqk2YAWom8?=
 =?iso-8859-1?Q?vzX7D+eL+9gHD9l1gTpKN40/rbtNxRBjCb1IPBeKH2+IjsFweeBW390Xga?=
 =?iso-8859-1?Q?ToMCoBD+syBOucAxuRzaqx3f8ApV0FNc/CCfYRGC8ZEc39baHHdNUab8XO?=
 =?iso-8859-1?Q?QYptvZZeaDw1kIKLQk96JMJOv6kFxwSwtJEwET4bsDgmFRZxYYEV6xEayr?=
 =?iso-8859-1?Q?NoGdT6xeJOJUcO0o3LtKn1X0W5ItYHD/lRievynEaD5WaORBGLdFelGBQI?=
 =?iso-8859-1?Q?2zbIJw/g0Jn+67wmBxUoFUN+LUK1Lah6KFlCS0phFB9ahQTgv6vIYwyEBG?=
 =?iso-8859-1?Q?nJNVxN8O/giu8V3lhvhtMp1nEsE8U0PrhcZOHXJm7VPAhF3FTvU+v2r0an?=
 =?iso-8859-1?Q?AH/t+oDXtZiZjxIF/bi+DrEG4PwrRhIOQbFQaUq6n/SIP+jFA52p/PC0O7?=
 =?iso-8859-1?Q?7mVG2E4e8G+hv/u5aatX65GtBEYIOkz91UXOQxI9mfAz2HfYNHgjDrMpo0?=
 =?iso-8859-1?Q?ctx89/YSTcM+jxPMtcGOLpGb/zLRtnquo4zqvkKDCZ2NVyyalOsaEhV3HK?=
 =?iso-8859-1?Q?ZRc3yA0pmBfEg9XpHlo90M+uSf5Ff71gfGZKP7fXKC8zO4NllNOwHVpEy2?=
 =?iso-8859-1?Q?/9u5inOurCseyq6TQJAGsYI8N71QByTDykeszQVfTKgs1/KiMcFpxlh787?=
 =?iso-8859-1?Q?qmfFSSljTFGG+OAryi/S6LSx1k61JKn0DZ43rDe15U94lYTwMcCH+qX8Sw?=
 =?iso-8859-1?Q?dhM44/l8CzS87MEec02Wk/Yq4xe8k02xe+RhtWlfMCEAyE03pW3IiXf37S?=
 =?iso-8859-1?Q?BRrhAKHE5RcJBA9JEJ3+UHThFtUXiV2TxMWWnm21J2yPWQ2SWVFzPJoZsl?=
 =?iso-8859-1?Q?tehyU+ft/0Y4+qcn/EjO5G7m2g4atYOyVrM5FnYM87mw5LN0YL9DMQKcRu?=
 =?iso-8859-1?Q?po2HnvAAwJDB3FLt4i1LDhqVRyfzPVgzQoLRyqdpA3FjuPb/Rja0APU3hf?=
 =?iso-8859-1?Q?YfN5GHgM01jtJlZANl6UbYd3nZe9GSGgW5h2IJD23VFsdH/YjkrpFYM6As?=
 =?iso-8859-1?Q?IyzoZ6JTyG9Vq6OjqwK2e19Ey6cLlm0GEbtk9n57SPR34efsPP1VTwaOR9?=
 =?iso-8859-1?Q?a1drE3JnknqNnxefAYPoSECgWNkMZ2MB5iXmmyb0tuI3dO633tVVijYVWe?=
 =?iso-8859-1?Q?OeEx8ljfBPplCnVL440ho+G/jA/zDOL2jUUrup9S64N3l9BbLuO1NIEXdM?=
 =?iso-8859-1?Q?vv+bYUAognJeYci72s0L2cZ46PRTkgn5TTEpxf9pLfJuK7D1eGdHc/0dDb?=
 =?iso-8859-1?Q?5nQGBqffouNppxLm8sJ3k8ujOi+ovWfB0KDPfQk4RIQjNIjn0vkUUc/QeM?=
 =?iso-8859-1?Q?TcG1VyiFwBgk8=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: dc6ac940-b95f-4c0c-f7c8-08dcd0846c87
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2024 04:03:55.4510
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9Zw1MULLuObL3rHf4/4nxaCi/HKraG6HOjhwgnAzO6k6rrli4TZ7lFUeJVXWxNEqqKuHKkZEkAn7wcnnaebdAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8001

> More architectures / More page sizes=0A=
> ------------------------------------=0A=
> =0A=
> Currently only x86_64 (2M+1G) and arm64 (2M) are supported.=A0 There seem=
s to=0A=
> have plan to support arm64 1G later on top of this series [2].=0A=
> =0A=
> Any arch will need to first support THP / THP_1G, then provide a special=
=0A=
> bit in pmds/puds to support huge pfnmaps.=0A=
=0A=
Just to confirm, would this also not support 512M for 64K pages on aarch64=
=0A=
with special PMD? Or am I missing something?=0A=
=0A=
> remap_pfn_range() support=0A=
> -------------------------=0A=
> =0A=
> Currently, remap_pfn_range() still only maps PTEs.=A0 With the new option=
,=0A=
> remap_pfn_range() can logically start to inject either PMDs or PUDs when=
=0A=
> the alignment requirements match on the VAs.=0A=
>=0A=
> When the support is there, it should be able to silently benefit all=0A=
> drivers that is using remap_pfn_range() in its mmap() handler on better T=
LB=0A=
> hit rate and overall faster MMIO accesses similar to processor on hugepag=
es.=0A=
=0A=
Does Peter or other folks know of an ongoing effort/patches to extend=0A=
remap_pfn_range() to use this?=0A=

