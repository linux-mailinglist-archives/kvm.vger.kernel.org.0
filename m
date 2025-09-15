Return-Path: <kvm+bounces-57518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 45F31B57110
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 09:19:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC4773BA9CF
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 07:19:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C14CB2D46A1;
	Mon, 15 Sep 2025 07:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pvtVRMjN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2073.outbound.protection.outlook.com [40.107.220.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9BE1A2C04;
	Mon, 15 Sep 2025 07:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757920750; cv=fail; b=XWc3qkDD0mjlBqGPPnpxbSSHHfvKI0r2PbT4Lii7dickUUlswJlVEFKfdDGdqKu3A/VwCm6sen7FyVK0dqTj3/plkvgUT7rR3zcf+6rYUjSXw0DRHWh4p8RBJ5ERod3cOz7Ya56gLm6Z7NMguRiVlj7xhVrIQ/hSnjyWq8Qe4iI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757920750; c=relaxed/simple;
	bh=D4uREIWMafidInRTmkhjWjm2iYziDj1gBK+VNHCjwSA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NZYJx5fJEDYqiucwW+l3vq4YFKwjKRvEp7x7TgBCylJc9eoVMfdAKOlbFKZcEJrBdyucGeWK+O3u0oSJmodZEmDdGM076t5owb4QfBb1uF7pUrKFvwGKxJsgRDoFKJF6Qn7FUz0mkpX1fsP9eqAgEhxNxfixmw5e5xZ7J97eQ7o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pvtVRMjN; arc=fail smtp.client-ip=40.107.220.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VDQRsSISQ/MS5frhSkHXTWT//3KDaLn/JGPW15BmYpH3D8aBOqwRED3AqVPO6UDM/6MrTcaK3o5yKYkTh5+SjSxcMTBdxvKwDqeInYzxbbhDSoikPmvngFUJ49e3LJZ9uS9SfRmh93xl8US1y7wbJvLXLTNFXjlZGbDka2WLg0G3pHYB2HjUOMXK9bXZDT5MiHy1uj9q006+kQyHKpT774b/iCUizzX0EkVDJSaFFBtJFdQ77tdtOdU/2JDFXtbrc/SQ2PbSAcsrz0wKxbq/3Te73CqwNkqn+2dRKKtfDEjQThOMOZWratkbx92PB4Pbuwz0rJmW1cVHKEsDvw+2xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qNpquk401HpwNEJw5sI42vsVIaCh9HHHA0IbQjT9XLo=;
 b=QOxsuWeJbrrSkoDQS74ClX0fEmPdUX80FvjRnlVSLPvaCgLbeHmfHzMRvhCWxuBqQlNFYpy48WUeTvi16Fo0hATMf+P13iPKmcFoYt8hD6jmzleAGb2vlX72iXYQODmU9TNLRBSVnsjjfBnVs5Za9C3uGD+Xt3Qg85yOBIdjycnIVFOw+CEGy2I4BAMPNc1Ek/pEfnPVmj7ngrZ93G7eRAYKGCRnH622m/zTLzCmHtAVLIkLFrddKHQrbPNqwPWWXSxN69fQOyITU6BcV0t1COjshNBk/J5mHurhrzYo1qBiYx4sEdVpaUTq6Dv7zA9zThM2UYIX28OE7AoUwnIX7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qNpquk401HpwNEJw5sI42vsVIaCh9HHHA0IbQjT9XLo=;
 b=pvtVRMjNbVaG57F7vo5h3kcZ9WYRPKdAo37efD0GWn4HD7FvbJOJMD0rkQrBC/jjr9ef9gBBu/47SNcR4mFuW23GAa3j/llz6SWTqD/tUaNFknHhz+uO5V9tltzjGraO70JssxrFQPgESQw/KPFEuYeXQaBRLt89ZrdYopa1J9WaeLc4AnpDeTeXnVwqIjgjyGHqV0wZhCM2qnQPq5vShafWC/orit5RkehY3bo5Dg05EeD9LFiCZmhk6fTyAfEKANFx0Y8MJIoZv21nWdrZ+BfNRwTZ5xgZ32jxe32POYrnvYA/Q6I/kG4iCeRJJ8Jivq3LwsDfz/l04nztmnbndg==
Received: from CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12)
 by MW4PR12MB7466.namprd12.prod.outlook.com (2603:10b6:303:212::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Mon, 15 Sep
 2025 07:19:05 +0000
Received: from CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::e8c:e992:7287:cb06]) by CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::e8c:e992:7287:cb06%5]) with mapi id 15.20.9115.018; Mon, 15 Sep 2025
 07:19:05 +0000
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
Subject: RE: [RFC 03/14] vfio/nvgrace-gpu: track GPUs associated with the EGM
 regions
Thread-Topic: [RFC 03/14] vfio/nvgrace-gpu: track GPUs associated with the EGM
 regions
Thread-Index: AQHcHVGYn6v2+i3hEkeP5sxSA9wJcrSPVEAQ
Date: Mon, 15 Sep 2025 07:19:05 +0000
Message-ID:
 <CH3PR12MB754883467A6D4C4A45F9842AAB15A@CH3PR12MB7548.namprd12.prod.outlook.com>
References: <20250904040828.319452-1-ankita@nvidia.com>
 <20250904040828.319452-4-ankita@nvidia.com>
In-Reply-To: <20250904040828.319452-4-ankita@nvidia.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR12MB7548:EE_|MW4PR12MB7466:EE_
x-ms-office365-filtering-correlation-id: c80ae895-29f9-498c-6c75-08ddf42827ab
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7053199007|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?JH6wWLl5A/4WBgJcrj+rrQSZhvs5O4Df5yv5Pa8FPqktBOSkMriXTv1wiaTE?=
 =?us-ascii?Q?0nkkiGKSshVPfKLnHZ7DawchQenLNZDeSp+XGv/8SnjoAT9Akxwlv0ECebwB?=
 =?us-ascii?Q?iYN4lBCnaVQ4DSvpCnoH1/G75GXmAqKQgg+cBQ+rX1AjytqyOliA+/lvNrHL?=
 =?us-ascii?Q?pdq6oxl6kNvo0GwVekahD6VsfNRcKo0swg1vf9BUZRumok1w4uQAK96OL5FV?=
 =?us-ascii?Q?4a+0ulRJOd0z+Kkq1HXP0fwBBeZDUdLh/jCt/MvoMWWNwQIoiekLdLolIWsX?=
 =?us-ascii?Q?zoo7VvwGAwY3xzFLuvm/iwOn9VySOW7g4KGile18A+MXbkBPLmHKDMJCGC29?=
 =?us-ascii?Q?tY//ZA79jpG6EYEbt27fQLxVT6EXjXRkQaPjsTqcjidD+fyxCJJvG3/oBXy4?=
 =?us-ascii?Q?c4LbxunjSMFHrbrWCOVq4IwqH5ie6sL4BWu864uKye8J9NhM5/QIgIQC4cXh?=
 =?us-ascii?Q?TEAPhD9LLO51EbG/w9MibIvxmLqll/78WE1r0UlRWRPOMuHa3N639WYGeBYN?=
 =?us-ascii?Q?gt35Srx+y/qCg2NU3ivGGXKBedcs7RfV7P5ju9GTeIC1KswX/DD8zaT4Hmxo?=
 =?us-ascii?Q?MCZtcwMwVeW5PG16lLBhc3Yl28thM9JzCJqEiFwmNPASSNPdnS4FqfkMqzKg?=
 =?us-ascii?Q?THWG/36UzYo03yuMPcp9mW5wQpVrvIs+FAYQsZlq/d4oETS6Fkb1AyxzJfJS?=
 =?us-ascii?Q?qh1wMAE/mpQBIYfMiCpmex82AcEAMFjjNQm09/fVhXzC2NUy6i4I3URxsvHy?=
 =?us-ascii?Q?hVCUX5lC7TIn1q2QycKvP7kDqAkAjNuGjc/wzzlLeAqkXCiRhjHuxy8c8zuD?=
 =?us-ascii?Q?lojcivd8aCKvDQbQY3smRKLZMKxkaJUCBHD4R7kcNi/HRWkmm87/DcU28AZA?=
 =?us-ascii?Q?jcj6TtgtktZM+qbonzDjltirAZ15FtJsic99UknYaqhFeFHHQALMY3O3JSiH?=
 =?us-ascii?Q?FE/JeB1WHAcqgoYrvTmViycAltM+7+eo59XPAp+C2IQjjHgHDSn4qZox5+mj?=
 =?us-ascii?Q?7EM2NEQgOjXxazBm/+dorYRMtK9R9xW5RcmHjVtqkCgRWXDWxNAquJEQBjKG?=
 =?us-ascii?Q?4zEqpBkJbDWZeY+Z5DsJ5CtB7mn49OhFB0YRkj2gycFvX8whGBVOYM14pknW?=
 =?us-ascii?Q?dWiRoGMEie0keYg2Y2n+MOldlwWUZqvoGzfznhPapidVdwuLX8fVKpgFkZXl?=
 =?us-ascii?Q?O+KzFmVMvay+RBeHbT939Vp++t6sS11kqMfyD4XAbW+iXBjPGq5EurHV8qWF?=
 =?us-ascii?Q?hGhQo5JBboN/KRIN7KLS4HSQqP8yWhpbtYrhzCI3SoJpQizx/K3QKSEZP4Po?=
 =?us-ascii?Q?rJAakTgKFqKfMrSB1x+nYdGEZezbhVOb9RzfoVyy4Hl6x/7paVR7wnj2l5eA?=
 =?us-ascii?Q?nuNjWhE7I8TC0Atk+3d4kakfpWeo8AdAF1oNiNAG98B0WzpScFc4zs/wtrxl?=
 =?us-ascii?Q?FraZQIqQDP3nfFeAHhfUh7nS/6V4xGFWu6SYO64bjlWl0Ipo0Qm4PYEh23aD?=
 =?us-ascii?Q?GyeK+kWvjN10q0o=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7548.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?JmNYwWDuVwkVk3GjsSjC3uoODg1GUrHOOky+JB84HXH08NgwVZnbNGYMrfar?=
 =?us-ascii?Q?TZTePk8c9Gynj6g/SFrevwXY++TqxkNJGMMVJlY+kEGNJhP2XFxBep1PkKQr?=
 =?us-ascii?Q?jyd5YXL/cxgJ3ymE8sQVnhs7F1lTDLqf7vfQCe4ueM9yjW6yaZBFYJgiAu+P?=
 =?us-ascii?Q?2J8TO2DH1Q9kPPZNXpmbqnR5q+cYoe1kTtodx07Ih/zu2Sk/gpQCwK26EBsL?=
 =?us-ascii?Q?Xt9WUtoVx36e33B8ErEl1RtyLzs1bRzsHtq1D4iTaDwtxkvUh4vtgeHRbdUH?=
 =?us-ascii?Q?n4TiLGv3p85eM/qESKil+A4iCSMqJ0AytthcrL8KeGTc4YSATECh8IMFG7eH?=
 =?us-ascii?Q?UW7fDEMcFnqVwPDAuMdzTMQPudtGPKIigdhIS2JtT/MZ40uNHw/ExUNUdDyo?=
 =?us-ascii?Q?p67DSFFCmJNLvwmBOrB/G4TJWAUM6Wfs/qq0lMoa3JkPPFzwt8534qH544dQ?=
 =?us-ascii?Q?ZjAfh/mfzQazYr6zbH6CUKm2qOfnwn/K3xBaj9Ixo/iL28ohzAJqWuiwPBGI?=
 =?us-ascii?Q?dicxixD7BvWsXS6p55PpR/Dp9QNGXbI61Hyn9dnOKG1da40W8ZNFmpEJ+1lW?=
 =?us-ascii?Q?veCTlSyf6xIUyebrVqeTrH6otefWrF72Dew2pj6ugO5/tfv4EzpEaGjSvPSV?=
 =?us-ascii?Q?i+8+FhvLZCrsiSQNLCwmXPk4Y4cQu8m6tO6WyRJaqdHmgS7gIlXGM3qmgQ1f?=
 =?us-ascii?Q?QwQmvPlhoNsp0gsVsSZeOlWJ6lvmB7qCkIjQhhL3/xeZ9vr082zjVS7Uq24G?=
 =?us-ascii?Q?yJhG0sLC7SZ9gq69OZHq9/MYwI3XUKwzOEz8xz/nI6lhcAQeT19M27jQ3NZE?=
 =?us-ascii?Q?Ifj7dw99K3YHriR/CaSVVcBlO/Ujl67HHVJFZw7DigXKE0RtjMuobJ+k8RrU?=
 =?us-ascii?Q?cXslUrOK/waW0Z5hUtqVyM2207MuBkPuATYSpH6yTWADfyPQFyB6tOuTfzLB?=
 =?us-ascii?Q?aBMpaeIftEGPb7kqwGZWOkpVkZ/Z8j5G+pxaK5l9y50O4jZujZJV0JcX59cn?=
 =?us-ascii?Q?aDNd8rVdfOB9htunK5CEbcBMEnDy/StO10vUnQ4UFXkOJutU0WUncLJKlHH/?=
 =?us-ascii?Q?o0uNYAIe4PNAi5x8k2FhgaGjFjtN89+ayoA65EsIqxwzcdYpvGfgsOTQOlbI?=
 =?us-ascii?Q?TRTKjH8+wkzc7B3St7mXwSOTenJgs+ZFfefKmH3Uk+Y6VYMrgKK9U0A21yTv?=
 =?us-ascii?Q?iHVVXqgT+hVYndrppfZ/Ng3slPRcoJgDBw7pjiqE8khfeWNjyLvE1vm+0JSz?=
 =?us-ascii?Q?gciIuErRjfGi7ACd6FgNggkZma6wmkaDKeyEN9s6eZc9P1corZNI8TgGwp2i?=
 =?us-ascii?Q?dXdbGMIF57IbHi4zYodx+xgUYrglEWf0rqsMG/i1G7sGaxNZT+2Q5IH93hpA?=
 =?us-ascii?Q?/mjmCaL429AlyJWVHH/rNIxu75WI03yNBL75tFoEzwfHOhjK7fXl3Eq0vFE7?=
 =?us-ascii?Q?BxZUQ+8HL31RvCuwA7FQYs53QIxx+bpsT5+AXtJwQ2RWMfpNU2DHYeUbnlMh?=
 =?us-ascii?Q?mM9wBW3ppeB3BQhvoklBesvZJVkp62LIdk8+J5YGyOU15sX391Y0N+GFDtAU?=
 =?us-ascii?Q?EZ7KQKq57riPwApQU0+DM8cfLvxSkm4H+2uez8Ww?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c80ae895-29f9-498c-6c75-08ddf42827ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2025 07:19:05.7388
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1ByM7nK1GltBO4b3OF1kNS8h0Y6uvEf4Y2bUYGRCLMsxbEQFpeI2V8r53dygWERsGDhwFC2FhaUym2aqKCJTRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7466



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
> Subject: [RFC 03/14] vfio/nvgrace-gpu: track GPUs associated with the EGM
> regions
>=20
> From: Ankit Agrawal <ankita@nvidia.com>
>=20
> Grace Blackwell systems could have multiple GPUs on a socket and
> thus are associated with the corresponding EGM region for that
> socket. Track the GPUs as a list.
>=20
> On the device probe, the device pci_dev struct is added to a
> linked list of the appropriate EGM region.
>=20
> Similarly on device remove, the pci_dev struct for the GPU
> is removed from the EGM region.
>=20
> Since the GPUs on a socket have the same EGM region, they have
> the have the same set of EGM region information. Skip the EGM
> region information fetch if already done through a differnt
> GPU on the same socket.

Ok. This is probably why you are keeping egm_dev_list as global.

>=20
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/egm_dev.c | 29 ++++++++++++++++++++++
>  drivers/vfio/pci/nvgrace-gpu/egm_dev.h |  4 +++
>  drivers/vfio/pci/nvgrace-gpu/main.c    | 34 +++++++++++++++++++++++---
>  include/linux/nvgrace-egm.h            |  6 +++++
>  4 files changed, 70 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
> b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
> index f4e27dadf1ef..28cfd29eda56 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
> @@ -17,6 +17,33 @@ int nvgrace_gpu_has_egm_property(struct pci_dev
> *pdev, u64 *pegmpxm)
>  					pegmpxm);
>  }
>=20
> +int add_gpu(struct nvgrace_egm_dev *egm_dev, struct pci_dev *pdev)
> +{
> +	struct gpu_node *node;
> +
> +	node =3D kvzalloc(sizeof(*node), GFP_KERNEL);
> +	if (!node)
> +		return -ENOMEM;
> +
> +	node->pdev =3D pdev;
> +
> +	list_add_tail(&node->list, &egm_dev->gpus);
> +
> +	return 0;
> +}
> +
> +void remove_gpu(struct nvgrace_egm_dev *egm_dev, struct pci_dev *pdev)
> +{
> +	struct gpu_node *node, *tmp;
> +
> +	list_for_each_entry_safe(node, tmp, &egm_dev->gpus, list) {
> +		if (node->pdev =3D=3D pdev) {
> +			list_del(&node->list);
> +			kvfree(node);
> +		}
> +	}
> +}
> +
>  static void nvgrace_gpu_release_aux_device(struct device *device)
>  {
>  	struct auxiliary_device *aux_dev =3D container_of(device, struct
> auxiliary_device, dev);
> @@ -37,6 +64,8 @@ nvgrace_gpu_create_aux_device(struct pci_dev *pdev,
> const char *name,
>  		goto create_err;
>=20
>  	egm_dev->egmpxm =3D egmpxm;
> +	INIT_LIST_HEAD(&egm_dev->gpus);
> +
>  	egm_dev->aux_dev.id =3D egmpxm;
>  	egm_dev->aux_dev.name =3D name;
>  	egm_dev->aux_dev.dev.release =3D nvgrace_gpu_release_aux_device;
> diff --git a/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
> b/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
> index c00f5288f4e7..1635753c9e50 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
> +++ b/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
> @@ -10,6 +10,10 @@
>=20
>  int nvgrace_gpu_has_egm_property(struct pci_dev *pdev, u64 *pegmpxm);
>=20
> +int add_gpu(struct nvgrace_egm_dev *egm_dev, struct pci_dev *pdev);
> +
> +void remove_gpu(struct nvgrace_egm_dev *egm_dev, struct pci_dev *pdev);
> +
>  struct nvgrace_egm_dev *
>  nvgrace_gpu_create_aux_device(struct pci_dev *pdev, const char *name,
>  			      u64 egmphys);
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgra=
ce-
> gpu/main.c
> index 2cf851492990..436f0ac17332 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -66,9 +66,10 @@ static struct list_head egm_dev_list;
>=20
>  static int nvgrace_gpu_create_egm_aux_device(struct pci_dev *pdev)
>  {
> -	struct nvgrace_egm_dev_entry *egm_entry;
> +	struct nvgrace_egm_dev_entry *egm_entry =3D NULL;
>  	u64 egmpxm;
>  	int ret =3D 0;
> +	bool is_new_region =3D false;
>=20
>  	/*
>  	 * EGM is an optional feature enabled in SBIOS. If disabled, there
> @@ -79,6 +80,19 @@ static int nvgrace_gpu_create_egm_aux_device(struct
> pci_dev *pdev)
>  	if (nvgrace_gpu_has_egm_property(pdev, &egmpxm))
>  		goto exit;
>=20
> +	list_for_each_entry(egm_entry, &egm_dev_list, list) {
> +		/*
> +		 * A system could have multiple GPUs associated with an
> +		 * EGM region and will have the same set of EGM region
> +		 * information. Skip the EGM region information fetch if
> +		 * already done through a differnt GPU on the same socket.
> +		 */
> +		if (egm_entry->egm_dev->egmpxm =3D=3D egmpxm)
> +			goto add_gpu;
> +	}
> +
> +	is_new_region =3D true;
> +
>  	egm_entry =3D kvzalloc(sizeof(*egm_entry), GFP_KERNEL);
>  	if (!egm_entry)
>  		return -ENOMEM;
> @@ -87,13 +101,23 @@ static int
> nvgrace_gpu_create_egm_aux_device(struct pci_dev *pdev)
>  		nvgrace_gpu_create_aux_device(pdev,
> NVGRACE_EGM_DEV_NAME,
>  					      egmpxm);
>  	if (!egm_entry->egm_dev) {
> -		kvfree(egm_entry);
>  		ret =3D -EINVAL;
> +		goto free_egm_entry;
> +	}
> +
> +add_gpu:
> +	ret =3D add_gpu(egm_entry->egm_dev, pdev);
> +	if (!ret) {
> +		if (is_new_region)
> +			list_add_tail(&egm_entry->list, &egm_dev_list);
>  		goto exit;
>  	}
>=20
> -	list_add_tail(&egm_entry->list, &egm_dev_list);
> +	if (is_new_region)
> +		auxiliary_device_destroy(&egm_entry->egm_dev->aux_dev);

Maybe it is easier to read if you flip the ret check above.
Something like below,

add_gpu:
        ret =3D add_gpu(egm_entry->egm_dev, pdev);
        if (ret) {
                goto free_dev;
        }

        if (is_new_region)
                list_add_tail(&egm_entry->list, &egm_dev_list);
        return 0;

free_dev:
        if (is_new_region)
                auxiliary_device_destroy(&egm_entry->egm_dev->aux_dev);
....

Thanks,
Shameer

>=20
> +free_egm_entry:
> +	kvfree(egm_entry);
>  exit:
>  	return ret;
>  }
> @@ -112,6 +136,10 @@ static void
> nvgrace_gpu_destroy_egm_aux_device(struct pci_dev *pdev)
>  		 * device.
>  		 */
>  		if (egm_entry->egm_dev->egmpxm =3D=3D egmpxm) {
> +			remove_gpu(egm_entry->egm_dev, pdev);
> +			if (!list_empty(&egm_entry->egm_dev->gpus))
> +				break;
> +
>  			auxiliary_device_destroy(&egm_entry->egm_dev-
> >aux_dev);
>  			list_del(&egm_entry->list);
>  			kvfree(egm_entry);
> diff --git a/include/linux/nvgrace-egm.h b/include/linux/nvgrace-egm.h
> index 9575d4ad4338..e42494a2b1a6 100644
> --- a/include/linux/nvgrace-egm.h
> +++ b/include/linux/nvgrace-egm.h
> @@ -10,9 +10,15 @@
>=20
>  #define NVGRACE_EGM_DEV_NAME "egm"
>=20
> +struct gpu_node {
> +	struct list_head list;
> +	struct pci_dev *pdev;
> +};
> +
>  struct nvgrace_egm_dev {
>  	struct auxiliary_device aux_dev;
>  	u64 egmpxm;
> +	struct list_head gpus;
>  };
>=20
>  struct nvgrace_egm_dev_entry {
> --
> 2.34.1


