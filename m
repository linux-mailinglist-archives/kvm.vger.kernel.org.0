Return-Path: <kvm+bounces-57517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 44D82B570C2
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 08:56:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A10401890305
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 06:57:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB4272C08A8;
	Mon, 15 Sep 2025 06:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EG8MRB40"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2072.outbound.protection.outlook.com [40.107.237.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8A52773FD;
	Mon, 15 Sep 2025 06:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757919392; cv=fail; b=nmBRabBuWzigSWpePE1t6wA1sMEpr35ZJenYV0H3SRK2a/Yob1CwncaFJnxNxLcN/TgBAgSegtecxb7Bf0273XXhOZABnEfxRZ8f7stMmQP0xrTpe3eEF1J+vP5DqsFYuRL15bussZoR00n0aOOF6inAmui8diu1E62x52OAF9M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757919392; c=relaxed/simple;
	bh=aXaLg3+APmZ7hwJv1ESJRTPvdxb+1LI9/l+4JS/4b08=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KWwz6Czcz7RWRWrFggxOC1WWccGwNZGHqP0vYSeuQdg1rfnovmvTqgs4QHHUTbkyZhah8dEy0uUcqkD0wsPX367yewFtHKR6DAuvv3a6hOqbqCZjKOFAiE8KNLPbslUB0V+kaFqx4FyfIypvaEWqpaS9MnZXxpEluLjcz3EErCc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EG8MRB40; arc=fail smtp.client-ip=40.107.237.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SdfrYbhGjDVpHUMvyr9wyOzLDwi9maezpFhc+EuirAY7du6x4LROJxKQTqKKiEYgtdpFyRo/kVMbJfVpijNPeTd4mMEGOTANWBZS4N4rAEZIVf0p9Y+WoqGa2R+yjCdMd3wolsGAnlx82+DkXNlZmElHvBEp25FIOGondOFbYSkj9WAlDBQN3sRotxjprlJuot0NCCIGd06wEuQbqVvMq1AJNmn9eeyAw0xMl8A9kBV1WljSjOvje0/uqw1sWRHCs1zCGISOdSZN3qQc4TfLx7X/tB64T3FqHLmtcKezsbN2ZRzDMRaNbqHcAof6ACnzQBzcRHictqaBPYVcZsfYnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d0NufkdpE09FsoBA75KMj7Qb22tCvK4jghLcWeTkihg=;
 b=lanPIrDIWpnjJ5tf0SjnvIY1TrmwmhGA0lzZbeY4Oed8D3rS+facUg9t8+YKZrxGnhT0EI/zUAuXiriDwnTrcbKuADOcKu6IaBvjadBPpYyISBcFnsUcmJTTZG6+r3tIyJ20cJE+O8Ma7BMIhBe0Lub/sL2p5QPqFpK/ztDuzQFJ2q+84ID/B48/30n9El/RaMtRj088pHF/rdq1BYMFxxiFc69hk10ba8TtR05LPEuLBctUAuuXcW4NW38xd3Glt8YK9lEvHeD0436tQVwY6HmqY/eYiPZJEzNLwAG6IFudLF/0rouRWVRqVLg9x4EgQ71sYvJotAKh6UZoK4UVtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d0NufkdpE09FsoBA75KMj7Qb22tCvK4jghLcWeTkihg=;
 b=EG8MRB40m3cZ5NYydkFDfNQIFoFwHTqD2/2PTsXLWoGhwysZUujPnRMbc9vZjge9LaloLiSy0U9eG10zwRT8S5J0UZ4nHaUBBC5/gJZgDK6yndgHgyKrVf6swi3Yof5x42R/95NuWVENnCg3suJvAFtXQLQaoCJs28ceIK8NH3QE1mkqBI6xXHjFjoFCflgpQkSQ6Fu8156QZOZlVAgDIyABpesKN/D0xMnKvx56JWX+7CnjX+lpvec47FvKJGR5kb0mjgH+sVFcscTOHQl1wI5aBVPifTkeTGGb6mJRBugOTWjlWMRvahOhAFYJqsGH9CjCDWfGefOx/+BHrJvebA==
Received: from CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12)
 by DS7PR12MB6165.namprd12.prod.outlook.com (2603:10b6:8:9a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Mon, 15 Sep
 2025 06:56:25 +0000
Received: from CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::e8c:e992:7287:cb06]) by CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::e8c:e992:7287:cb06%5]) with mapi id 15.20.9115.018; Mon, 15 Sep 2025
 06:56:25 +0000
From: Shameer Kolothum <skolothumtho@nvidia.com>
To: Ankit Agrawal <ankita@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, Yishai Hadas
	<yishaih@nvidia.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>, Zhi Wang <zhiw@nvidia.com>
CC: Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti
 Wankhede <kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)"
	<targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy Currid
	<ACurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John Hubbard
	<jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, "Anuj Aggarwal
 (SW-GPU)" <anuaggarwal@nvidia.com>, Matt Ochs <mochs@nvidia.com>, Krishnakant
 Jaju <kjaju@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [RFC 02/14] vfio/nvgrace-gpu: Create auxiliary device for EGM
Thread-Topic: [RFC 02/14] vfio/nvgrace-gpu: Create auxiliary device for EGM
Thread-Index: AQHcHVGaly2jWfR2NkOjJRt/rSkky7SPOJ3w
Date: Mon, 15 Sep 2025 06:56:25 +0000
Message-ID:
 <CH3PR12MB7548C11B99027293F56165C1AB15A@CH3PR12MB7548.namprd12.prod.outlook.com>
References: <20250904040828.319452-1-ankita@nvidia.com>
 <20250904040828.319452-3-ankita@nvidia.com>
In-Reply-To: <20250904040828.319452-3-ankita@nvidia.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR12MB7548:EE_|DS7PR12MB6165:EE_
x-ms-office365-filtering-correlation-id: aafb298d-92a2-4eea-6e45-08ddf424fcba
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021|7053199007;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?hqOb+HdvDkCxCGSMtuwrngBYY0XpBBoLnP3RTPYSFYoWA92jUjJ/U2qO/eJQ?=
 =?us-ascii?Q?aZHimamROhuhAWi4RIHoER7334jmK6nWi3SCrg44VHQoGfBYPW+6mfhVQ3H8?=
 =?us-ascii?Q?wlK5Mwv1/JdqhtKL+GhgDI38CCmyzenN/sxNtQucqSRRoJ5gngLhxaU4uK0I?=
 =?us-ascii?Q?MrASIvKX9lIbwdFgFfyyr5ysf/2LPMhQ1LqWV12w3s6wTQSrFJOBX5TCRrKx?=
 =?us-ascii?Q?ywGOo2LpeEnT7yZ34HRFHYVPRAUpi2uP5a5miyLNeSI6q2WYlq+lkvR1kgAr?=
 =?us-ascii?Q?eb5BANOAvJEDpfqWlvghDvvdiknfkgOmh5h1rd/sZ6Y7Sua/WSdTl+xQUF0L?=
 =?us-ascii?Q?S3gRCsEtWnQaM7NXc7enlO/6O4wfJrel5qPQXqw5cziJ4cw99UxJsf9T9emJ?=
 =?us-ascii?Q?8aVxqSueK25nOrvU7d14JbAr1vBmpnKs7BVFbfiNgrL3AZH1AgnwBVxRW0iL?=
 =?us-ascii?Q?xLLZBNPz6dPg38pDV2MXtwm7qEHk+0l4vSy9qi2Zod3l+Ne/tt4WRbKtuzQH?=
 =?us-ascii?Q?QWMgQvvlUG5KiyHyK9PuWovAusx9YmnZ065kOXNZFLkR/GLfY4g3YWPF8b68?=
 =?us-ascii?Q?R+r6awGltblA/u6kF2LWL1Y1WgXRxM7ewt60p2+HgLDRsQVS5ypi8jOACcml?=
 =?us-ascii?Q?VUwhLBsPvuGHQqg3KDBgqx2pf/9Lb0Xd2Zp3kEu+dt2QtEQUVNUQ+T+UnOLk?=
 =?us-ascii?Q?KmcGENAxbo32Gqqk8aPPGLPKWb9wVc+zVKriEx18fXylTonkVyOA8fJ53M6R?=
 =?us-ascii?Q?rNIk6klOahhrzhebN2pcWpzFtjxhZS59CZfxOUeV9v6/s37WV1rA5JgO4Hf0?=
 =?us-ascii?Q?Q6KojE77wEhvZHWrso8eYbYtYEpPCMStb9oQCeuICZ8H1Ljf7c/jLfJn0yFn?=
 =?us-ascii?Q?0w/G3vJkuwa3rgQ0nRITOEBdlWKtSeRuSGZWMFNHkFz9Mgvq3zpNRg6r/6DF?=
 =?us-ascii?Q?ejXzX9kZmjSvZ7N4SuGwLHfLWRQafM7hnNyb3I9oR7UVj9Zg8pET3tqiHV0H?=
 =?us-ascii?Q?NjRuU7+CyGNx6SK+WXsBGHPL+uAgrsKfeYb2ub0DpSI44KsbxG7CqOAFmKxe?=
 =?us-ascii?Q?5v8oR4vSOhRl+2vdVSK7rkidtzSHHN/Cp+5c6L5t5GVacjkA4iVyx/uFimjP?=
 =?us-ascii?Q?mVA+FW3bKGZVZ5+vlqGtLxeQadak6ylDIX7EfhdfHM+fRkUdkwDCaarLPQ2S?=
 =?us-ascii?Q?GEvEIezwtbhcAYiqnjyM80JudEGn99UNWR2OjVnaXxwxsEObj4WBuCCAHFy6?=
 =?us-ascii?Q?8/J8HIFU+C6a3wtnjIMmccj/+Zm1y/Moo6cWjdC/M68t1QjQUKFwRwlC6U6O?=
 =?us-ascii?Q?NujYjxeXE9RI+PyNAhOpGfzX/c0nIsmznFnhZtq9P+uhwClFgStdt5hkAySn?=
 =?us-ascii?Q?PmhsRaHt8N6JZOjeTvPET4w+Z8izFLVIeBcsY1c528QYx2gqnb2YN7lSuOO0?=
 =?us-ascii?Q?zl+Duw8me2oEBPzxDDHhT+ETmLqad5ppEc8CgxiQL5m/GrsNmWRafG93Aqy3?=
 =?us-ascii?Q?GfJIDiQAVw2SpWw=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7548.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?r3Q27jgKz1ma+TNdS26xpBRRU85n7AXwFpzBwPmQkTASxCeG1mJzAiROwPPd?=
 =?us-ascii?Q?k4931bDP2jpEm0x++QZDv553Cr/8aVM0VCCzryGs/0yd9AqjZs/gAORKClW9?=
 =?us-ascii?Q?kB8diHicBYmwzEQKhvncaeSydgYgxLAOC5kr15BFAR1cLo6bXyN9os85Oclv?=
 =?us-ascii?Q?lb3jQ7kQUFbHOwu2nB8jZNlrIkPpsLxPalPPTnPczv0abvLqs6sK5fjlP95g?=
 =?us-ascii?Q?zykp2b/a+4aBgYj/VF7l4TVQDc73RPQ8rUuXx2izgsl/olB5YoUkqNOs/Z9c?=
 =?us-ascii?Q?nKZJUDb9EQlRdD+gfYdhSuE8rd5DLIk/VRjiGdpWWV9sbO7Ej+McCTsUS9Fc?=
 =?us-ascii?Q?xeQn0Nqh9qRVTh67pXVwgBDIsMJWuyBHpyjUjx0OWLELP6YIJQLtXoTkV4BD?=
 =?us-ascii?Q?yRpuGItbwpGUoD16V5ELaNAaz5wFQKYFBOZaWXCE5tDyYOIhEZN577c+iVJF?=
 =?us-ascii?Q?FjhMMHVieKSPsmEKs9mROvxH9KjF64wPD4MEcCXfwoMZ4p+7CawO+dri94HX?=
 =?us-ascii?Q?r0h9hMS9hJTSOzhKO/tXZt8emdmPZMV+GdYBWj0/8vKnhuqGXpp4IHLigxoB?=
 =?us-ascii?Q?Ydpco0HK+GDJnNezza65tP0tQ07Nn9KP2w99XvqQmS9TDwSTcUGSaZR18BfM?=
 =?us-ascii?Q?rwbWzOuNBGxB4ysHEz3w9au+TPm3KaueJcOk47CLp6DydhDGrBIjLMM+eEws?=
 =?us-ascii?Q?edhqQvBZ0f4oTL/PEh0+aTIJdw9IPv72r/KO5mc/2KrL3nscCn/Au0fQNf/h?=
 =?us-ascii?Q?ff1zFfW2JzIs20j1iQg466r5kJFV4dtcpWgF2vjqrDUVkQ1Sdk+0Ep+fAqDt?=
 =?us-ascii?Q?N+umceBZDri/fIaJAZ46TJQ9NcUFtpBQewBMiBpMyL8d3tvqpm0ES9vwOWux?=
 =?us-ascii?Q?miPHJ2b8b3Mn8vh6fAtekhUsotoZQbAEsB6YvrvldnGMiy4FAQEOhrEmvPq0?=
 =?us-ascii?Q?jJoORMuLCtFk8mYjMUAFQXXp1IJJ3JAW914PRq1GoSkE5jXnc2ugqwpOAMMA?=
 =?us-ascii?Q?OstpsprcmCpWSU3JOmgnDxvBLj37AkAO/r+4edCzw5OvcGK6iemyEk7SvMnq?=
 =?us-ascii?Q?S0oEzkoLxLwAX8Z0arX9THjB3I7MTGE+L6PJEn/OIN17DqnoFdiiclEP6Vbp?=
 =?us-ascii?Q?ChgPwR7dVtVGgLkLdGzIOevUeFjrmCFY8GS7DKmyo9fPEq9qIfNBCUtV8+ng?=
 =?us-ascii?Q?dgNUgJ/4cTwdcF+5JpIi6Znuyxgs6RK+2ChUHwTS1goD0QOTGWr43FGf38F/?=
 =?us-ascii?Q?fpZjYjwvWr1FA5y6NBwenSdUzR79AVnwZmOxASzVruo0A5W/aC0H1g5yJ4jO?=
 =?us-ascii?Q?0WpsJy5/G/xXgWhGGIO80a4nsv3PJbDSMxiNSINFxKAlO71s4y6XuWfc8vTb?=
 =?us-ascii?Q?Sx+YhJhHwtKMU13XIcyeTp0ny+d/vvXhmYyoUaWuzSZSdSYmxFFNnORP3tB8?=
 =?us-ascii?Q?zSJGeruUcW6IpwdluEnEi8tPAw1BJ9gEPjogDgCoFg/sd+tX4Jv2EQXu1QJ7?=
 =?us-ascii?Q?s+NSAICUu4oVauVjs4GbalKd7JPsiqN7v7j//m4PGRMdTP8YO0Ci3pqL9+ZW?=
 =?us-ascii?Q?N77e0hCHZpc77EPKYybQf7NeGyhYNNYkVx8z6elD?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7548.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aafb298d-92a2-4eea-6e45-08ddf424fcba
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2025 06:56:25.2463
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +nCIWrBOdus7qZ11gdDK6+sTZ6sNOEui21D7wmY2Sy2t20q6YnUzBl2NXpJdlUXEayshXwOfsGiA9MBnrRboYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6165

Hi Ankit,

> -----Original Message-----
> From: Ankit Agrawal <ankita@nvidia.com>
> Sent: 04 September 2025 05:08
> To: Ankit Agrawal <ankita@nvidia.com>; Jason Gunthorpe <jgg@nvidia.com>;
> alex.williamson@redhat.com; Yishai Hadas <yishaih@nvidia.com>; Shameer
> Kolothum <skolothumtho@nvidia.com>; kevin.tian@intel.com;
> yi.l.liu@intel.com; Zhi Wang <zhiw@nvidia.com>
> Cc: Aniket Agashe <aniketa@nvidia.com>; Neo Jia <cjia@nvidia.com>; Kirti
> Wankhede <kwankhede@nvidia.com>; Tarun Gupta (SW-GPU)
> <targupta@nvidia.com>; Vikram Sethi <vsethi@nvidia.com>; Andy Currid
> <acurrid@nvidia.com>; Alistair Popple <apopple@nvidia.com>; John
> Hubbard <jhubbard@nvidia.com>; Dan Williams <danw@nvidia.com>; Anuj
> Aggarwal (SW-GPU) <anuaggarwal@nvidia.com>; Matt Ochs
> <mochs@nvidia.com>; Krishnakant Jaju <kjaju@nvidia.com>; Dheeraj Nigam
> <dnigam@nvidia.com>; kvm@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [RFC 02/14] vfio/nvgrace-gpu: Create auxiliary device for EGM
>=20
> From: Ankit Agrawal <ankita@nvidia.com>
>=20
> The Extended GPU Memory (EGM) feature enables the GPU access to
> the system memory across sockets and physical systems on the
> Grace Hopper and Grace Blackwell systems. When the feature is
> enabled through SBIOS, part of the system memory is made available
> to the GPU for access through EGM path.
>=20
> The EGM functionality is separate and largely independent from the
> core GPU device functionality. However, the EGM region information
> of base SPA and size is associated with the GPU on the ACPI tables.
> An architecture wih EGM represented as an auxiliary device suits well
> in this context.
>=20
> The parent GPU device creates an EGM auxiliary device to be managed
> independently by an auxiliary EGM driver. The EGM region information
> is kept as part of the shared struct nvgrace_egm_dev along with the
> auxiliary device handle.
>=20
> Each socket has a separate EGM region and hence a multi-socket system
> have multiple EGM regions. Each EGM region has a separate
> nvgrace_egm_dev
> and the nvgrace-gpu keeps the EGM regions as part of a list.
>=20
> Note that EGM is an optional feature enabled through SBIOS. The EGM
> properties are only populated in ACPI tables if the feature is enabled;
> they are absent otherwise. The absence of the properties is thus not
> considered fatal. The presence of improper set of values however are
> considered fatal.
>=20
> It is also noteworthy that there may also be multiple GPUs present per
> socket and have duplicate EGM region information with them. Make sure
> the duplicate data does not get added.
>=20
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  MAINTAINERS                            |  5 +-
>  drivers/vfio/pci/nvgrace-gpu/Makefile  |  2 +-
>  drivers/vfio/pci/nvgrace-gpu/egm_dev.c | 61 ++++++++++++++++++++++
>  drivers/vfio/pci/nvgrace-gpu/egm_dev.h | 17 +++++++
>  drivers/vfio/pci/nvgrace-gpu/main.c    | 70 +++++++++++++++++++++++++-
>  include/linux/nvgrace-egm.h            | 23 +++++++++
>  6 files changed, 175 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/vfio/pci/nvgrace-gpu/egm_dev.c
>  create mode 100644 drivers/vfio/pci/nvgrace-gpu/egm_dev.h
>  create mode 100644 include/linux/nvgrace-egm.h
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6dcfbd11efef..dd7df834b70b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -26471,7 +26471,10 @@ VFIO NVIDIA GRACE GPU DRIVER
>  M:	Ankit Agrawal <ankita@nvidia.com>
>  L:	kvm@vger.kernel.org
>  S:	Supported
> -F:	drivers/vfio/pci/nvgrace-gpu/
> +F:	drivers/vfio/pci/nvgrace-gpu/egm_dev.c
> +F:	drivers/vfio/pci/nvgrace-gpu/egm_dev.h
> +F:	drivers/vfio/pci/nvgrace-gpu/main.c
> +F:	include/linux/nvgrace-egm.h
>=20
>  VFIO PCI DEVICE SPECIFIC DRIVERS
>  R:	Jason Gunthorpe <jgg@nvidia.com>
> diff --git a/drivers/vfio/pci/nvgrace-gpu/Makefile b/drivers/vfio/pci/nvg=
race-
> gpu/Makefile
> index 3ca8c187897a..e72cc6739ef8 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/Makefile
> +++ b/drivers/vfio/pci/nvgrace-gpu/Makefile
> @@ -1,3 +1,3 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  obj-$(CONFIG_NVGRACE_GPU_VFIO_PCI) +=3D nvgrace-gpu-vfio-pci.o
> -nvgrace-gpu-vfio-pci-y :=3D main.o
> +nvgrace-gpu-vfio-pci-y :=3D main.o egm_dev.o
> diff --git a/drivers/vfio/pci/nvgrace-gpu/egm_dev.c b/drivers/vfio/pci/nv=
grace-
> gpu/egm_dev.c
> new file mode 100644
> index 000000000000..f4e27dadf1ef
> --- /dev/null
> +++ b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
> @@ -0,0 +1,61 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2025, NVIDIA CORPORATION & AFFILIATES. All rights reser=
ved
> + */
> +
> +#include <linux/vfio_pci_core.h>
> +#include "egm_dev.h"
> +
> +/*
> + * Determine if the EGM feature is enabled. If disabled, there
> + * will be no EGM properties populated in the ACPI tables and this
> + * fetch would fail.
> + */
> +int nvgrace_gpu_has_egm_property(struct pci_dev *pdev, u64 *pegmpxm)
> +{
> +	return device_property_read_u64(&pdev->dev, "nvidia,egm-pxm",
> +					pegmpxm);
> +}
> +
> +static void nvgrace_gpu_release_aux_device(struct device *device)
> +{
> +	struct auxiliary_device *aux_dev =3D container_of(device, struct
> auxiliary_device, dev);
> +	struct nvgrace_egm_dev *egm_dev =3D container_of(aux_dev, struct
> nvgrace_egm_dev, aux_dev);
> +
> +	kvfree(egm_dev);
> +}
> +
> +struct nvgrace_egm_dev *
> +nvgrace_gpu_create_aux_device(struct pci_dev *pdev, const char *name,
> +			      u64 egmpxm)
> +{
> +	struct nvgrace_egm_dev *egm_dev;
> +	int ret;
> +
> +	egm_dev =3D kvzalloc(sizeof(*egm_dev), GFP_KERNEL);

Do you really need this kvzalloc variant here?  Looks like kzalloc will do.

> +	if (!egm_dev)
> +		goto create_err;
> +
> +	egm_dev->egmpxm =3D egmpxm;
> +	egm_dev->aux_dev.id =3D egmpxm;
> +	egm_dev->aux_dev.name =3D name;
> +	egm_dev->aux_dev.dev.release =3D nvgrace_gpu_release_aux_device;
> +	egm_dev->aux_dev.dev.parent =3D &pdev->dev;
> +
> +	ret =3D auxiliary_device_init(&egm_dev->aux_dev);
> +	if (ret)
> +		goto free_dev;
> +
> +	ret =3D auxiliary_device_add(&egm_dev->aux_dev);
> +	if (ret) {
> +		auxiliary_device_uninit(&egm_dev->aux_dev);
> +		goto create_err;

Should be free_dev to free the mem allocated.

> +	}
> +
> +	return egm_dev;
> +
> +free_dev:
> +	kvfree(egm_dev);
> +create_err:
> +	return NULL;
> +}
> diff --git a/drivers/vfio/pci/nvgrace-gpu/egm_dev.h b/drivers/vfio/pci/nv=
grace-
> gpu/egm_dev.h
> new file mode 100644
> index 000000000000..c00f5288f4e7
> --- /dev/null
> +++ b/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
> @@ -0,0 +1,17 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (c) 2025, NVIDIA CORPORATION & AFFILIATES. All rights reser=
ved
> + */
> +
> +#ifndef EGM_DEV_H
> +#define EGM_DEV_H
> +
> +#include <linux/nvgrace-egm.h>
> +
> +int nvgrace_gpu_has_egm_property(struct pci_dev *pdev, u64 *pegmpxm);
> +
> +struct nvgrace_egm_dev *
> +nvgrace_gpu_create_aux_device(struct pci_dev *pdev, const char *name,
> +			      u64 egmphys);
> +
> +#endif /* EGM_DEV_H */
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgra=
ce-
> gpu/main.c
> index 72e7ac1fa309..2cf851492990 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -7,6 +7,8 @@
>  #include <linux/vfio_pci_core.h>
>  #include <linux/delay.h>
>  #include <linux/jiffies.h>
> +#include <linux/nvgrace-egm.h>
> +#include "egm_dev.h"
>=20
>  /*
>   * The device memory usable to the workloads running in the VM is cached
> @@ -60,6 +62,63 @@ struct nvgrace_gpu_pci_core_device {
>  	bool has_mig_hw_bug;
>  };
>=20
> +static struct list_head egm_dev_list;

Its not clear to me why is this list a global? Is the egm  not  per device?
May be a comment to explain this will be useful. Also do you need a lock
to protect it?

> +
> +static int nvgrace_gpu_create_egm_aux_device(struct pci_dev *pdev)
> +{
> +	struct nvgrace_egm_dev_entry *egm_entry;
> +	u64 egmpxm;
> +	int ret =3D 0;
> +
> +	/*
> +	 * EGM is an optional feature enabled in SBIOS. If disabled, there
> +	 * will be no EGM properties populated in the ACPI tables and this
> +	 * fetch would fail. Treat this failure as non-fatal and return
> +	 * early.
> +	 */
> +	if (nvgrace_gpu_has_egm_property(pdev, &egmpxm))
> +		goto exit;
> +
> +	egm_entry =3D kvzalloc(sizeof(*egm_entry), GFP_KERNEL);

Kzalloc() good enough?

Thanks,
Shameer

> +	if (!egm_entry)
> +		return -ENOMEM;
> +
> +	egm_entry->egm_dev =3D
> +		nvgrace_gpu_create_aux_device(pdev,
> NVGRACE_EGM_DEV_NAME,
> +					      egmpxm);
> +	if (!egm_entry->egm_dev) {
> +		kvfree(egm_entry);
> +		ret =3D -EINVAL;
> +		goto exit;
> +	}
> +
> +	list_add_tail(&egm_entry->list, &egm_dev_list);
> +
> +exit:
> +	return ret;
> +}
> +
> +static void nvgrace_gpu_destroy_egm_aux_device(struct pci_dev *pdev)
> +{
> +	struct nvgrace_egm_dev_entry *egm_entry, *temp_egm_entry;
> +	u64 egmpxm;
> +
> +	if (nvgrace_gpu_has_egm_property(pdev, &egmpxm))
> +		return;
> +
> +	list_for_each_entry_safe(egm_entry, temp_egm_entry,
> &egm_dev_list, list) {
> +		/*
> +		 * Free the EGM region corresponding to the input GPU
> +		 * device.
> +		 */
> +		if (egm_entry->egm_dev->egmpxm =3D=3D egmpxm) {
> +			auxiliary_device_destroy(&egm_entry->egm_dev-
> >aux_dev);
> +			list_del(&egm_entry->list);
> +			kvfree(egm_entry);
> +		}
> +	}
> +}
> +
>  static void nvgrace_gpu_init_fake_bar_emu_regs(struct vfio_device
> *core_vdev)
>  {
>  	struct nvgrace_gpu_pci_core_device *nvdev =3D
> @@ -965,14 +1024,20 @@ static int nvgrace_gpu_probe(struct pci_dev *pdev,
>  						    memphys, memlength);
>  		if (ret)
>  			goto out_put_vdev;
> +
> +		ret =3D nvgrace_gpu_create_egm_aux_device(pdev);
> +		if (ret)
> +			goto out_put_vdev;
>  	}
>=20
>  	ret =3D vfio_pci_core_register_device(&nvdev->core_device);
>  	if (ret)
> -		goto out_put_vdev;
> +		goto out_reg;
>=20
>  	return ret;
>=20
> +out_reg:
> +	nvgrace_gpu_destroy_egm_aux_device(pdev);
>  out_put_vdev:
>  	vfio_put_device(&nvdev->core_device.vdev);
>  	return ret;
> @@ -982,6 +1047,7 @@ static void nvgrace_gpu_remove(struct pci_dev
> *pdev)
>  {
>  	struct vfio_pci_core_device *core_device =3D dev_get_drvdata(&pdev-
> >dev);
>=20
> +	nvgrace_gpu_destroy_egm_aux_device(pdev);
>  	vfio_pci_core_unregister_device(core_device);
>  	vfio_put_device(&core_device->vdev);
>  }
> @@ -1011,6 +1077,8 @@ static struct pci_driver nvgrace_gpu_vfio_pci_drive=
r
> =3D {
>=20
>  static int __init nvgrace_gpu_vfio_pci_init(void)
>  {
> +	INIT_LIST_HEAD(&egm_dev_list);
> +
>  	return pci_register_driver(&nvgrace_gpu_vfio_pci_driver);
>  }
>  module_init(nvgrace_gpu_vfio_pci_init);
> diff --git a/include/linux/nvgrace-egm.h b/include/linux/nvgrace-egm.h
> new file mode 100644
> index 000000000000..9575d4ad4338
> --- /dev/null
> +++ b/include/linux/nvgrace-egm.h
> @@ -0,0 +1,23 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (c) 2025, NVIDIA CORPORATION & AFFILIATES. All rights reser=
ved
> + */
> +
> +#ifndef NVGRACE_EGM_H
> +#define NVGRACE_EGM_H
> +
> +#include <linux/auxiliary_bus.h>
> +
> +#define NVGRACE_EGM_DEV_NAME "egm"
> +
> +struct nvgrace_egm_dev {
> +	struct auxiliary_device aux_dev;
> +	u64 egmpxm;
> +};
> +
> +struct nvgrace_egm_dev_entry {
> +	struct list_head list;
> +	struct nvgrace_egm_dev *egm_dev;
> +};
> +
> +#endif /* NVGRACE_EGM_H */
> --
> 2.34.1


