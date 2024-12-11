Return-Path: <kvm+bounces-33473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4541D9EC2C6
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 04:06:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79476282F09
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 03:05:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C33D1FE479;
	Wed, 11 Dec 2024 03:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hVPQ0INr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2050.outbound.protection.outlook.com [40.107.102.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956AF1FDE1E;
	Wed, 11 Dec 2024 03:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733886329; cv=fail; b=Jr3/hjIa630xPQ6c0AddKJS/NtO4P26yy/N8tKWZkTKcYvTuD5jaBSDuDQocmTRlUJwBMrAtx8EM75YuKE43tjhBgb1XtmkEc/23ajedT3cbMlXSOtVK5B3ahJmWHcgH+bbCB9E5WePbIjVEayXt7yqEq19BwQWQzIjZDRoNsyc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733886329; c=relaxed/simple;
	bh=xwzl7STzDOh7XQ66dZdBBOrsY/XyHDykKDeQaCR/vk8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WmuD0YOO3DpFmc1wCeOCymV6PEXOVK2b45Xim08y+tim/siyBnUQ4NCx2i/t/vEXyp/WvLfrKWCeR3JcOI6mIQiW7oyTOBYu8jOAx08/YnX4sJMHYvmrOWPS/Lnu5c0Hy4c5vDaR7pEtXlVJzUkQlTR+A9n+XOo11mjo3RUnKOk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hVPQ0INr; arc=fail smtp.client-ip=40.107.102.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ln6MHGHEARDd+L5kRHVaLuWnfpd8lrLUKLDoof05YGRuXtvQMIi6kcXmtxTb9CmxR311WtlTE93aTIDPVN/afgQa9LoWpvoPfuOgAj2u/QXUA382AuE8gfTWTKM0QTcwBqMHUgo88EHnGP0UbMPDT7L7NLKy58DsurziueKTSVQ4lMqHAi62DRZNldXZXez6Ux4AAjWrzNB5pxLFZ8Ef8rHalyg6BrMVBsPLrP/dPHtzig5dH3fGnH6lsGvpbJZKIDfDyIuf8fZx/Q3N9S81N2QXDsjLBK7tSIV6EoI69T4Z52jUHmRgpTfUVPL5cJE0MSma1z4kgyAqioxw/WffOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xwzl7STzDOh7XQ66dZdBBOrsY/XyHDykKDeQaCR/vk8=;
 b=ln7iNNCjwTa6wW7nFPXV8O7q37qmjns2xBIfbTEJKk9D82K/OqCsPBgOqynin+PpeblOnD1upAajdlQga740SqF7eSTG2ZjDWSKvANeJCLZEodM93e/Yt8iYyIHu+CANq4wzrL4zbxV/pyMZrdAUB6DvN+bgOKXBB4r9xGKEXemzVOmMbLzijJt0hHHUcswdVil3owF2u8DnxMWRrZqxrd7RIaEBA2tqqqDePys+3Rs1CAOoyfr4PnaVQ0VuEXYFFPrDcHi5JgWd9B+VVv005OL3rY5tATcGBOFzo0AGlErAnL5SEvxlvPr2LO5QIrHmCKbo44DlwN57Hy6VNJs+YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xwzl7STzDOh7XQ66dZdBBOrsY/XyHDykKDeQaCR/vk8=;
 b=hVPQ0INrJ5UY0do6juJc7Edpuj2uucMLizTEOSK0CdBu8OXz3/XjLwn62fQgireKme42hyfn6/xjz1YIHzHHOjq1/566ZuRFAtG8MKsxRt3sxsDLYjHRBzxe6K6Fy6mP5FlTCsOG4OzKipSjTU/A/m4a7odNqY9NRVoN/LtW3MOwr0Ki5BtTZJXQCxRqb4nzL5Ss6Tid+JP779v4koq7CfSMvnguW4ObY6gYSRoU6pSzDlZ6lwoI2RLTtvMeju0CYC5VoL+KmKDLC2841lzNeTmiOEIU+BFi20Vry3NLys909y1S5KYNJUdXo6rkfJKdXmctzcKo2GwLXrc/Lbn73A==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by CY8PR12MB8215.namprd12.prod.outlook.com (2603:10b6:930:77::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.17; Wed, 11 Dec
 2024 03:05:24 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%3]) with mapi id 15.20.8207.014; Wed, 11 Dec 2024
 03:05:23 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Donald Dutile
	<ddutile@redhat.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, Will Deacon <will@kernel.org>,
	"maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"shahuang@redhat.com" <shahuang@redhat.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, Aniket Agashe <aniketa@nvidia.com>, Neo Jia
	<cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy
 Currid <acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John
 Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, Zhi Wang
	<zhiw@nvidia.com>, Matt Ochs <mochs@nvidia.com>, Uday Dhoke
	<udhoke@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"sebastianene@google.com" <sebastianene@google.com>, "coltonlewis@google.com"
	<coltonlewis@google.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"gshan@redhat.com" <gshan@redhat.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 0/1] KVM: arm64: Map GPU memory with no struct pages
Thread-Topic: [PATCH v2 0/1] KVM: arm64: Map GPU memory with no struct pages
Thread-Index: AQHbObyXz5FE7VYSKUOn3d6sXZJ1xbLfpkUAgAAC6wCAABuNgIAAAzCAgAC2C9Q=
Date: Wed, 11 Dec 2024 03:05:23 +0000
Message-ID:
 <SA1PR12MB7199357D481FF766F958DD34B03E2@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20241118131958.4609-1-ankita@nvidia.com>
 <20241210140739.GC15607@willie-the-truck>
 <20241210141806.GI2347147@nvidia.com>
 <0723d890-1f90-463b-a814-9f7bb7e2200b@redhat.com> <Z1hnZ0H13Pst5sKF@arm.com>
In-Reply-To: <Z1hnZ0H13Pst5sKF@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|CY8PR12MB8215:EE_
x-ms-office365-filtering-correlation-id: 7a5fafe4-222c-432f-18d2-08dd1990a7c5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?WKv6NuzVT7yCuMbLGyf7mVnfYiJ+1SX0sgyxztwdKMfuY38Scxl6HCxrQy?=
 =?iso-8859-1?Q?qtdr3YzPCp+Y7csFamIXOsMHG8ZslvNf871Zzdaw8xh2X1Ujl3Eq2aT/FQ?=
 =?iso-8859-1?Q?LtsO1rtOj2FcBKyroRy2ccTYS9XTm0hZ3I26r0+ws9A+umhYbea+7wuabz?=
 =?iso-8859-1?Q?H6Dua7a204GrVaBveebL3epXsEGgzP+iqte5NCtJ2WgmHd6XaVev4VgmtW?=
 =?iso-8859-1?Q?3rfoO2GjBiDPbkkG5uVA0Qae89DX9GpX+wF7tXK5uHALmbp5e8Lh6K7jO+?=
 =?iso-8859-1?Q?DsKW4vGDAiGje+is6hfAAM4EPciLNyTTPusCGnWBIU8QMKA5vOXndeuWUx?=
 =?iso-8859-1?Q?3DN5uL8f07wXXoqgjdfmCpWAHJsAT7HyE5hqzC2ltZxtadyWGpoPk1rQya?=
 =?iso-8859-1?Q?VhO9QEFwGXfLglwdjRroul1R4qMXOnuAs+mgTjPoG3na0P2ze3EUeb1ABn?=
 =?iso-8859-1?Q?ShUIBA96x8M4eF/ab+3zB660dW2Xc0CpHcNFxTpvtDV7AL95yxGRrtBqDf?=
 =?iso-8859-1?Q?C8n3Ef6urSxhBEWhM7akjwzKiqx1Nae8AB2AJLOdvZtDWO8K7fwKaikLnC?=
 =?iso-8859-1?Q?+0LMH1G1nGdzVfYPen4VqrghGqecXTpnioR5/JpHJpXLbOD76Q9fXZwcrE?=
 =?iso-8859-1?Q?2RUrQkqKrVpS48m38Phg3uYk2euNTIESnDxFeAOZ5KEMhQIR5cXTkt/MyL?=
 =?iso-8859-1?Q?MdWs5tozjnVSsUkPsXh7Mzbjo2hdgNPuD/B0P8DppSqAET1MKmo9EdLrSU?=
 =?iso-8859-1?Q?VPfRbtIij78HRzdg8V4H4iWmngalZchCEsLT5R6lTe4kqQkb0xaK4d1AcH?=
 =?iso-8859-1?Q?pXf0xXeUzR+OD4sJngq/ag/jowpWofBp0/M9FnG6ANUE+Xdc0dNLPgykvx?=
 =?iso-8859-1?Q?RQ0BEzS8lV8TPv3dADCRk3nzZJIkSBjX5YPliWgoYWTbp10w7RXvYlPX6+?=
 =?iso-8859-1?Q?aMjdpv0g/FCBVq3lrNH3ICgfCn0BqdvIY0f8OQTPGZnatle+ywi4R7972Q?=
 =?iso-8859-1?Q?Vmt0xrdp9EpsowEhZKsdKB0KzkooUPsnluLiE9LHRJGKWi/rl0iTdtuZDU?=
 =?iso-8859-1?Q?ezxi/JPR8K2UH1k/prhkhyawm2fSb6jtWiS59yoNet+j+JEthGhW6VqX2T?=
 =?iso-8859-1?Q?93ZpByaRTHSHjV0vFz584J+nuNJRXkpRvsgdXU0UKnEYHYjOOOSJXX2//j?=
 =?iso-8859-1?Q?qMWkSJ+mvizhgGD7i1IKxLY582TFrJ1ljZ+TUobpw7ltHRDZ81p10MF+Vp?=
 =?iso-8859-1?Q?R6yy6CrW8AsKGMrLu9zNOjxjAFXQhXcSqT5fHe4qRJRh3+QjIHTSSJuzXi?=
 =?iso-8859-1?Q?8a4hOLWac82l0u0MZlJPxszPylDYslaknbZvIcxygfs9Woqa6cLQXLdaoa?=
 =?iso-8859-1?Q?PTGlMPSCn6xK5AGQWmEC8KTaLK1CNAsbrD7IWrLTWpDbeoJvChQuUTUGFJ?=
 =?iso-8859-1?Q?fv1U+R4Hts2YzERoKFgPVIAuZCqlUp+1hLvIww=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?dhCxVM9+MnpczTSZlH3m/a7CeHFugGMGrId1Bzr6JZ3UAsOg0+fbQMSUab?=
 =?iso-8859-1?Q?4erED1lZ15rIbi1tzPhDchJpA0Mss9UWtOwqSKuq4x/X4FdZIm74H7jQ9l?=
 =?iso-8859-1?Q?L3nCbVRPYV/bDq1Zg8ANMaARkc/0Y15qrKmqBVkxqh5vICSGJB4iFSk5T+?=
 =?iso-8859-1?Q?FL7r6Smwy1PF3z84BJ2200lR+hf8+d+im0KrIBESa2Nq+ZszKSmiLsIH+0?=
 =?iso-8859-1?Q?FJJmq8NI9yFSMzEJIFpVHyeXlGNXSA4+V3u3kNslMBmHhTJJYnZ2dGxQq0?=
 =?iso-8859-1?Q?b3wsjmfuJq1CnCazQUUFTY1Q65dmp8VKgQUdZjfXrAc6JB9wocd4jAKr74?=
 =?iso-8859-1?Q?brhhKQOK7II5scmcXC335QXpJcfjF0rTNMJTAF99GH9x65nZN82KGwzM1V?=
 =?iso-8859-1?Q?ILaeKPsbk+ZT/S56qDC/5/5Rd71DympsYaSkH6CnecfALa5nfhe5dT9Edd?=
 =?iso-8859-1?Q?svoAWF7Jb7eDqkaAjSJMJgmMAKsmFMm9+qSlyAoPaOMKCyIYW6FCOTneFm?=
 =?iso-8859-1?Q?oeeDRZ/+TF7Aak3sIdq6UlVVKIFojFkNFGAAkKYL9jF7L2xGUVcDMimWjP?=
 =?iso-8859-1?Q?xXbm6sWlFvSSh/TAFGHeCN8nKagD7uOtB0WsBoYanFpQzWCvAMRFs1UdCL?=
 =?iso-8859-1?Q?rzmdBEv1fw7vDj93ko15f/iHGi67r4kh4uYfTgxwi/+c9ncuToABq6I8Ft?=
 =?iso-8859-1?Q?XbIQJo3WeymUwzdh62BtmWvLFACgqqhLlY1rHQZwJmHChOLAJ7vgfI71QZ?=
 =?iso-8859-1?Q?DEe0n0rDb20bG2umokRV3r5hG871kT7N0K6gT44sC+e0wm6U+rPWC1qmf1?=
 =?iso-8859-1?Q?iDHEaY1zH4CvX68UBy2IalWNMdieHNKcyw4y0duRiEvIUv2OPswsEcF7MY?=
 =?iso-8859-1?Q?Yqo4CX2zi3UOqBsmx5HaOdhMf+sojXvrd8F9cloOqcLWEL3gPc7f1RnXvk?=
 =?iso-8859-1?Q?Ujts86QnBmDdFfu6OJ0QH13oKT/yfdaKaOzaLJc99W44ZgEAbZlncSLcAI?=
 =?iso-8859-1?Q?jDbUxs+BGdlGu50AmGNEncaf1rUnzlXePuhxcNXY6s+xGo+Ys526dCQwoR?=
 =?iso-8859-1?Q?L3B54Fa1crh2mgEGh/EEC0ne761tQjap21/3o4jfiB9CT5g/mCQSgf5kxw?=
 =?iso-8859-1?Q?RWokrV779LC5gUogQfzhM+WWjPVpUSL7zsF5H78SgiiiIYkJ5Uk6Tkz8Ad?=
 =?iso-8859-1?Q?UMxGI14+TT9ichdlTLHaoGXHKkgE6doLsME7NyFuM8b6yksTHnupaYyenB?=
 =?iso-8859-1?Q?SDh9KFeBrgKcsU3V7I14oTCd+Duf6Af1+RXmKZHPxwFvzlpmYycBdS1bBq?=
 =?iso-8859-1?Q?Di5uvkt2tMNq8dUjY/EFiUWyaMEQ7wHKg1n8ZagfbB7zsOX7xtyIOizIEL?=
 =?iso-8859-1?Q?vMQoXnwbVSQ9QSMqelcgD2SsMJNQ7c/yriYAfGSuJUARiO19z5CUvHphqn?=
 =?iso-8859-1?Q?44N156/CnG2DsEtYAQUvgxLw6tLiDm4zzXJQQNA0f/xM8tXJi2awGqyDv2?=
 =?iso-8859-1?Q?ozxYx3Mop8VYevmpd0Vj4+kZp4YnMuyKbMea/eyLY7yGleAjkUgrKHr5RI?=
 =?iso-8859-1?Q?oxIImayLj/iGcFOibDka9d6BPuJOtokMzHVBD5nHSCg94gaaw+OFeY70dj?=
 =?iso-8859-1?Q?Z6HUcOJe7Vmj4=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a5fafe4-222c-432f-18d2-08dd1990a7c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2024 03:05:23.6975
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t0L9g3di6WcvkfLkRozt4GUXU3+Ti0MKnrufOTzhpfSPxgCWqm7LbbPpghXl5q0uJmedj+aQid8okw7joN8riQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8215

> IOW, I'm looking for a complete, clear (set of) statement(s) that=0A=
> Ankit can implement to get this (requested) series moving forward,=0A=
> sooner than later; it's already been a year+ to get to this point, and=0A=
> I don't want further ambiguity/uncertainty to drag it out more than neede=
d.=0A=
=0A=
Yes, I'll be working on this series to get to conclusion. I'll fix the text=
 and=0A=
split the patch as suggested. Moreover, I'll see what Catalin has to say on=
=0A=
the MTE part. Based on that I'll resend the patch series.=0A=
=0A=
Thanks=0A=
Ankit=

