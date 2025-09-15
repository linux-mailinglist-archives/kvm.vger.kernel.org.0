Return-Path: <kvm+bounces-57523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AA16EB5731D
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 10:36:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 157D6188DAC5
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 08:37:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B60922EFD91;
	Mon, 15 Sep 2025 08:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nIoV22gJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2056.outbound.protection.outlook.com [40.107.93.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445242D5C7A;
	Mon, 15 Sep 2025 08:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757925385; cv=fail; b=N++Q2UbN4RXs/ymvbHdYq/ivI1Xrw+gKvMu1o9s5G7GB1qEa60pFoBtmt4P/aCz1KhHPunIgvExpr75FMWlMcQABXNusnEkZ5MlEUSApJcttH9rRh+teQoDFZl8JxjlNAb7kofsYNUz2bmlFzk3SisP4PPRWT4RvT4Apqn2+tlU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757925385; c=relaxed/simple;
	bh=rQzF3JqJiXp/H2bbsu3rCONTLF+DJh6Si5+DQnyhB/k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BzT8Ic54Gybr1v0eVkhgwc3mOe1yuFJVcT7XdKIyG1gVQw3rkU617JiIbSJ1HMnz9TtBJMPkWeseHokEHhrc89Afzj6t4rKgQOukVDEdzYxf2EMAdd0lX6+wCMQvrOAU3h6sc3lZ/Y+uHktffTNWcCLLYfxrSNn+0CGXnMiB7H4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nIoV22gJ; arc=fail smtp.client-ip=40.107.93.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KNpxQCZcgpRHz5XnbNdXdXcnCJN0IpD3m+9Icerz9Z/s1QfutyRYCBQcfNjyqqj6CSqJnw+TKAG+6qN7T3aSXSA5hfliA5ESGWP7qfOGU+Ev/flaXZQX4PclyNIzCZ5HMb3KN54LydVRROv0phHUz3CqdtsTUmvDJZNxeqFv5lnOrYvGNDwslXCUIxtRQqDB9VtNAq2xcyTQrtyNpjbs2fNhwb6GmpzgzTUQv9FPjH9qKWFQG7LCS4S8NM2Xf7KRlVHuDDybAQ2bXXYIsRuMp5v5xMguG/oG+up5urgSmA25YYcNay09m7CalxFHtwvTfAQWCzXLOH8XrfQpQmhxoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cQXI1DxuLEd0wzICWxJvj196WWFD+Qf/KmBOK3b8/v8=;
 b=nz7/hY4TlmBEBvFYJTk/zmrbRh7k6Mm1ldAqOjFTXRG8W4j8kjShaN/u8NlyVKX2mTNLj/VqFpkJLYhb7tZ27c3i+4GQEpHh82oq5ZUNGsstYK/FOiva+yb2X00hrzsGSJMKLTTGhXdHLHv38axR1AeNsoJF9v6SsLClvlJI7HU7AFVgoju5Qz1FURZwpBlVg9x5hTq0hzPRrheFCiKOFa0N3XTTpjpybWLz3uVr2Ude3gO8jGzh9jb0ErFl3f12SnxOSIZ7g2XXGK4D2f25mG805w47YQklmpLfMN8tUNkMb16ohdMg+m7IdlXQGVq2kKwHTvB6rdVysElBfd+Y7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cQXI1DxuLEd0wzICWxJvj196WWFD+Qf/KmBOK3b8/v8=;
 b=nIoV22gJJvcDUbUW+qDjq8TA7ibDq5G1BovH2TJ3ya3Ok7d7MnQf+2EQVJLSoyFgInuQYF1l8Ra0nN2zje55kLV8wq7ODSYk1hitEwMJ+xlAa9369EMWL8iOKBnqIERko7vWrncv935DOuIls34SgenQW/GQ4azaxA5x3IHoOLsn65WdZRd04aLbsEt7IrI2hgfut3FkbUZy823pCD5Zu8gK+vqPG4St+nleepgPWIoOFLkjcYNVBxrjunPhNDQjzxevIvTZ2y5AcZAnhyJ3VjHLTtpvrOyNEc9Z/N0xAV7tRvMXYdohKZaz9J8t2cQYVONDdHDouopJEiorvyz7Ww==
Received: from CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12)
 by CY5PR12MB6346.namprd12.prod.outlook.com (2603:10b6:930:21::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Mon, 15 Sep
 2025 08:36:21 +0000
Received: from CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::e8c:e992:7287:cb06]) by CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::e8c:e992:7287:cb06%5]) with mapi id 15.20.9115.018; Mon, 15 Sep 2025
 08:36:21 +0000
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
Subject: RE: [RFC 08/14] vfio/nvgrace-egm: Expose EGM region as char device
Thread-Topic: [RFC 08/14] vfio/nvgrace-egm: Expose EGM region as char device
Thread-Index: AQHcHVGaUNiYV4a/eka4xoAQaODDX7ST/J+A
Date: Mon, 15 Sep 2025 08:36:21 +0000
Message-ID:
 <CH3PR12MB754809550F8233828902396DAB15A@CH3PR12MB7548.namprd12.prod.outlook.com>
References: <20250904040828.319452-1-ankita@nvidia.com>
 <20250904040828.319452-9-ankita@nvidia.com>
In-Reply-To: <20250904040828.319452-9-ankita@nvidia.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR12MB7548:EE_|CY5PR12MB6346:EE_
x-ms-office365-filtering-correlation-id: 0080435a-6717-434e-7870-08ddf432f298
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7053199007|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?nFA5kQWPmY+q87U6o/83ttXjUbmtSpmqhK2IIycezNL++o2l5fkJGwavgaPU?=
 =?us-ascii?Q?HhB4zMhRaJZL75hnnPM9clzT2h3Fj+edbETHmcYYN0Thr8LqDf61qTiPkH88?=
 =?us-ascii?Q?LvIzbTYJhGMlFw1nsLpK3SxGwxEL+SGvyhKyO6icF0rbEfILejXutW62T5AF?=
 =?us-ascii?Q?1Gj4YQSZyJ48zycO432fFVQ40IjA4HOKyRBvSya2MzR5dD/nIzwA5/dlZUyq?=
 =?us-ascii?Q?jSZjF87O3tU2UFUHinOKsc9wPyOFNXOopSUY7y36FJwsJndYoBD+dXZyW+1T?=
 =?us-ascii?Q?QJk9l/Ilm5JUwXrqhHxE8EiPP6xiTG4Ff1i86yuhSjzwXcqcch/PNPL4uO4K?=
 =?us-ascii?Q?l1QjNRjALGdotapXzYb3sriWp7EsQGAlqKAOqpOd+Vqs54UdA6Jm4+d2Z7tZ?=
 =?us-ascii?Q?5Ic6PTbjc4g6/A0Fm2HcHCGLMW7uj7M18ucq5VxevApeL9tFsOtlyQohyyq8?=
 =?us-ascii?Q?LTEphYyMtplI/oVvJRithaHZ+R11WrN8EQD4nsH2vQwsOYooyHn8/jW84ckP?=
 =?us-ascii?Q?DbA11M88kRPFTHJTEs/cmMlWOsiQ1oPSf60fBJ+8/3bMMxHAf58puvOka4T7?=
 =?us-ascii?Q?6bTiZXO78lHZYlH0sEAeGMUNOhyMfY9PNFn1RZBou8P+EouELD4HWPjaNAz7?=
 =?us-ascii?Q?2PAD1kWEd8QziE36qFE6rP2fchqqXptIUAEs0UoUUvnvqeCduySoae1V6s1J?=
 =?us-ascii?Q?g4nHZK9uW4vZhGYpYOL+LYeAlx5X9DGewFCnPsqSKn9//aF0xuKabYRjuT/9?=
 =?us-ascii?Q?yVc9il3BjKyDAaLi70XqR+sCDYbhVoAMQSV7F/9+Cf/KwY8cpg2FQSf/1PUD?=
 =?us-ascii?Q?driu6H4oD7Yo06xAcytBSG9XmyJYR9xuHhM9f5xlBWzm57G8ud92JzdAYxs8?=
 =?us-ascii?Q?dXkR7IPPEWUYMG1Rd3iUKR0HQM9fDcp51Cud0l2Pm189jDsPv/IgW3ryrAXw?=
 =?us-ascii?Q?wsWYIXp+J/BcG6PkuZLk3GgvyaJ0QRe9rkBYP5V7YR/jsOFhqerT3TE6IeTb?=
 =?us-ascii?Q?VHFjc+20nFpfhrk+JRNXGurxWGRXTJthXV1WUUiL4dB5IiGfym31mzDwkPdZ?=
 =?us-ascii?Q?A06X1Z43LKm94eM7mMrwKV/xe76xSnKM8mz7MymLjOgI89Sd87e+3tKLiQeW?=
 =?us-ascii?Q?r6f1Kyvi53TL2yDqY3vYEw31qzF/oezJA5bBTKkL2zKu+6cg+Gj7YvYKoI/7?=
 =?us-ascii?Q?Be4S429iasKcyq3V6WnLlRwP1i61FIihydrX90Tg9TaGI+N8Ajh6iFTXtXUL?=
 =?us-ascii?Q?ziknVwwfemxkw1aiM59yMFEUdRSXFLOP/is30trmodLQtuW9JIy045siTtTT?=
 =?us-ascii?Q?yTbqCkGyaHZTYKzlgUsFTTRqV47kkSPLyleJe0bAj4rMa7tUA+5qP8EFgeBw?=
 =?us-ascii?Q?GoWb7u0raXrYV3rPjNvqmjdENRyhW8ClRswV+OBDLlDGn6EtPqDvDC5hmQ93?=
 =?us-ascii?Q?UQY3HxGbl/n9uTHFI3Ogjmc0yhY2e0fYbOutyTtyS4xH0yGSUUJ+Tc+xVlQk?=
 =?us-ascii?Q?xo9DmZWqIc+TeZQ=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7548.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?gDwXr8FUYpWtnkfz4PqxemSmBhzPQiFll2tDYU9oe6Kn354Ov8q19+9QJ77L?=
 =?us-ascii?Q?aSScpEfXwJIPcjKkWgSK1yura8uOTo3ddAB5lK+uUeUrD9+Ea9hYIN/vtjU3?=
 =?us-ascii?Q?DNyeHZCU/fjab5PkSRaFrz4CNsRoKnAl7pHEGxTAwYF0+ceEW8h6sZN2fX6f?=
 =?us-ascii?Q?p+voQ+VRqaLx/mk0qw++nXv8VbzSYfh3oqtANcgArJHd42gGupN2UyZbAAq/?=
 =?us-ascii?Q?ofow24redY5BVvJs4+WXRYWJHfu9RAxpE4WsOMiR0+ArI/GlD53MbWhbF4fK?=
 =?us-ascii?Q?wqO2g/L3j6qxpikDMxaikiFo18MOGOwLbeQ50Rx5favAk4ANPemb4ZibWqEf?=
 =?us-ascii?Q?aefOefUn9Kvdu3iOA1kWsoWQNNWkHqq49lUcpT1JIfOjhj2h62dhZiX5zgov?=
 =?us-ascii?Q?qilXzjlef9E0BItTP8tvsrEdaqGahINpc8H2veoLEAgqmTrLJodvOoigx4ek?=
 =?us-ascii?Q?AhvT/3+vOIXDQckngTSv6hnSiylqIXaFWDB5SEo/U6gynwJ2/1rtJ7V0Za2f?=
 =?us-ascii?Q?1IlStjXugWs+cttxZ5aMeIpO7oA2R1XM+nWFN9VRqGQ045+Bx+LA/hmzKxPZ?=
 =?us-ascii?Q?ZuAoWK/O4vSBE3m4olqBFSZa540oFNPZij05pcnQrdQtpzKxu9DZYBqQDuaR?=
 =?us-ascii?Q?BtZly/SeczcOXEd6HE1yNh24eQmxSwYSX9jwA78r/HTdugTS+qyAuXVXKgt6?=
 =?us-ascii?Q?LY/HaSHAS4piUQ0gmPy3IdOrDEIikrf5QaoW8Vd/95ZH4Ei9aMFhAjPYXCoi?=
 =?us-ascii?Q?EYV7sZcKaLTZEFlVq2Da6Ezn/t2iJFv4rQGAK+G3UJgM9SVL5PeEVYK1iQB6?=
 =?us-ascii?Q?lvQXPYh1GRTzLWIWw7G4g/Fn+BI5XP2hbmCqsj1toIdmgZLPOR50d4+TGm5f?=
 =?us-ascii?Q?QnkQON6DX8nkOuFQBR7gplND9zZYrFJbgivQTi1QZ18xIUaAOKGsPqZ1rX35?=
 =?us-ascii?Q?Lzj+cx/Q4SGafIKS6y+Knv6ccCYODdQ3sNxqSgsgMprAjUw0QzJaxSNsAxAq?=
 =?us-ascii?Q?qMNhv2uxw9lau7vW35UdAysEygLljE9i4ATM0KEErJbAezurzqM86nni5XW0?=
 =?us-ascii?Q?bREtgkVclLS9BCrz547Y8ZYzwawZokcMQYeLJHOHOlF7sNMKMOKibbALWHfB?=
 =?us-ascii?Q?IhTIoV+Ya8H0WAsVPSkDr1X3bW66z+h6a/LsflLCXVDo0fIRk13UmtkBtedU?=
 =?us-ascii?Q?ah3bp7EinuQ6yeqaYBc/IM9YVmOIbtrDeEmMkROEkoF8Fla8/zPiGIGQPQet?=
 =?us-ascii?Q?AyHTzPCkgdmLP7Ze/3nImEtoTUxX7zo3FUKK7n7u4Rj6Wv+ngbxQ+Mn/cdN+?=
 =?us-ascii?Q?uvLuPGCaFywq3e0gOp/85g+9tkQ/fB9nepGo2IQPQpxZSMMMTUhJpJ+bJDPj?=
 =?us-ascii?Q?kDb0skbz6nwmGSZLr+LQlvcnVMKj9aOTbfqdiiynkfnNqosS2Bg/OaaXlVyM?=
 =?us-ascii?Q?2pbrj2czXlNF2L56DQ6zj5lArXIsdZVsicvyXQgLCOQi0JWEq9+tTTF0BhUf?=
 =?us-ascii?Q?fEHdUKMnFbByaOWDXYLMkFSgopzlqrgU9pNF6xT+rd+2EM8136YsETNWWSUj?=
 =?us-ascii?Q?v5mngfg40XGKeiAwE2HdKtwGfFgSOOruAHrRN0FO?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0080435a-6717-434e-7870-08ddf432f298
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2025 08:36:21.1573
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 58DooCXIcRBTB9ywzWv2QF5WSfaZZpt16eJa/XhRPygjq3FhTjrqN7YkLvXRRKTQ4NPBc+2EZ/w1VnTjOqE0Ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6346



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
> <acurrid@nvidia.com>; Alistair Popple <apopple@nvidia.com>; John Hubbard
> <jhubbard@nvidia.com>; Dan Williams <danw@nvidia.com>; Anuj Aggarwal
> (SW-GPU) <anuaggarwal@nvidia.com>; Matt Ochs <mochs@nvidia.com>;
> Krishnakant Jaju <kjaju@nvidia.com>; Dheeraj Nigam <dnigam@nvidia.com>;
> kvm@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [RFC 08/14] vfio/nvgrace-egm: Expose EGM region as char device
>=20

[...]

>  static int egm_driver_probe(struct auxiliary_device *aux_dev,
>  			    const struct auxiliary_device_id *id)
>  {
> +	struct nvgrace_egm_dev *egm_dev =3D
> +		container_of(aux_dev, struct nvgrace_egm_dev, aux_dev);
> +	struct chardev *egm_chardev;
> +
> +	egm_chardev =3D setup_egm_chardev(egm_dev);
> +	if (!egm_chardev)
> +		return -EINVAL;
> +
> +	xa_store(&egm_chardevs, egm_dev->egmpxm, egm_chardev,
> GFP_KERNEL);

Nit: May be better to check ret for xa_store here.

Thanks,
Shameer

