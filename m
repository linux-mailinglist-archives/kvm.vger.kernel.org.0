Return-Path: <kvm+bounces-9141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2201985B603
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 09:54:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A4F081F21C62
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 08:54:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB251612CF;
	Tue, 20 Feb 2024 08:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PC3YSS1w"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2064.outbound.protection.outlook.com [40.107.94.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458C75F56F;
	Tue, 20 Feb 2024 08:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708419110; cv=fail; b=T4UebT0GtbyqjI8oE/u289sNWJxbX0rEd24Tvdo0GWHEPI5JRujQu/pAN2VuI6d1t6u6P4jjwYbzi8762OcZrV5iZGmxUpmblcX0ImivCMoiGN0PZMNKU26yndaGGp7VpA8TF4N4A7TP+HHckAPUbrCrYcv94pJlb0+EmbNH6/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708419110; c=relaxed/simple;
	bh=rXT2Im3ilDp1ODsYzdO8ZzBIdLOM/y80HStcypj46O8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IeQ8UlwkM3DU0FnVQgfnHUjiidH6nkfL92YVsDFRUPjdSPzG5bZO1YBtVLYnTK1wS2uTxyHM+R/agp2dggaFe3ctQjx5ELR2PeFEhNzaN/0rVcpPL+C/JfLCfc4rUPAtsykHAx5FoqMueDxFlDWccWKel5VL5r6bIlmKbdSS17s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PC3YSS1w; arc=fail smtp.client-ip=40.107.94.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ly2HuH6jBoyDn0I2demPXuRBC3pHCmg5YO5ov/Vdi+dkkWN6UWnVii1W/reaVATb0irsjkE44sy7P6Mq4RZn+4OE+2d2asa1mpPiAAVBNrrbFyodz6JhDxNQ4mhmhgTbgif88M44G/jPF6/dVUwY1QNOS/ydhqLs2qH1koCxK88okNC2gNl/2GQW2RZhEJlV15rzOXHZsM6Q3wnpfbWNCjaVsbux0jMDU3LittB16BSV/iuvwRoOPoHxf6/kzq25xGD0Tr8kQjk7uo37Mr77GWTz1G8eNJAW7R2ITNYVpxoq02Fh0tW+HlUPu9d9D1/YMMMU6thUXUTI9l37td7A6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rXT2Im3ilDp1ODsYzdO8ZzBIdLOM/y80HStcypj46O8=;
 b=lyaB2ts+PYJCVcZmHmzxNKwtOdLzK1mb9GKQkiFPx4K7V0zpcsuxMjN7IfDtFA9i1zzRZyDskToU+zdTkGyqoAXBnzXaqXn4rL2C8KuDg7+9GMXeu123Ua3cSFWu/PMtpFoAlhDMJV1zxdLY75z8rSRUGtnzAy3f68OI285qcFEFuJ+7+NGeGPVr3szxm1PvppPYTLmv1ZgB0dpGnDQTS8sLATaQBgg9+ZV2m8LhAwJ8Ziew2bJBmNl8ZWOYBm/nsl9mn2oA9vQfGd1kkufx/R11TVG6ai2JDbbaMZ3PIAJJTDYAac7R6bwSKD9kG+AwSOwGW8l3IBrsEqijvPqgTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rXT2Im3ilDp1ODsYzdO8ZzBIdLOM/y80HStcypj46O8=;
 b=PC3YSS1wkb2q55A43dXAnMeHr+xbEGPDV4Frqn/Ejn3Nz0d81r6+B+jMPBmsjeV0Y4qIO/zewzyeoAb0B+UXVDCwhtc46I9x8IS6f4L8PHNJ81Vg6eY5Ec98WDz/qgEq/rtrDj0a50V/O+ZazYJ4oe6/tH4vmi8LClTFNVgGk4VamtBtXWXl/XY6xqSGuPjnWeS47/c2eyyXndK4u5AETxkvN79sl+UYUo7sknnU0CoWoJgDlc5SXmKqHJgk/J+5OlT0BJw89N7A1nmsywOdHZCAo2E3osynMdcjcdOXe8VvGAnqhDB5u8ElqF4QK56qP1qlNtvmpHhJXEiAFeEjJg==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by SN7PR12MB7884.namprd12.prod.outlook.com (2603:10b6:806:343::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.19; Tue, 20 Feb
 2024 08:51:46 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::284c:211f:16dc:f7b2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::284c:211f:16dc:f7b2%5]) with mapi id 15.20.7316.016; Tue, 20 Feb 2024
 08:51:45 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Zhi Wang <zhiw@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
	"maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "james.morse@arm.com" <james.morse@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, "reinette.chatre@intel.com"
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
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "rananta@google.com"
	<rananta@google.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"david@redhat.com" <david@redhat.com>, "linus.walleij@linaro.org"
	<linus.walleij@linaro.org>, "bhe@redhat.com" <bhe@redhat.com>
CC: Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti
 Wankhede <kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)"
	<targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy Currid
	<ACurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John Hubbard
	<jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, Matt Ochs
	<mochs@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 2/4] mm: introduce new flag to indicate wc safe
Thread-Topic: [PATCH v8 2/4] mm: introduce new flag to indicate wc safe
Thread-Index: AQHaY86qDQVcMVySRkSmtPnSJvq8YrES5W+AgAAGuiQ=
Date: Tue, 20 Feb 2024 08:51:45 +0000
Message-ID:
 <SA1PR12MB71992963218C5753F346B3D7B0502@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20240220072926.6466-1-ankita@nvidia.com>
 <20240220072926.6466-3-ankita@nvidia.com>
 <bc5cdc2e-50d8-435a-8f9d-a0053a99598d@nvidia.com>
In-Reply-To: <bc5cdc2e-50d8-435a-8f9d-a0053a99598d@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|SN7PR12MB7884:EE_
x-ms-office365-filtering-correlation-id: 0006b57a-b45d-45f4-f41d-08dc31f12ab1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 JTDmyZJvxR6Govh18tlRyGtW3KyBZLOju3BeUyIceEP4pwC+X4mTH+5/ZLwIge3oEW4oRVEUlk8VlPecy4B1OGS4QGVRFCKZFvg5Mqg9AFs3yywuA7lOO9mmrSolUhrPc+M30YB6PIRjbJdTRyZVFiuZu9G4cSyHGsj/qswOc7zZaL+cLenjXt13nqbpPrBBos+BPRHIJFDKeL3FF/f7611Rl01uQduAbKIiFcDQt4mFwh+xZppzjfkI2Ti2u1567PbKdvRBil5J3H9bKQ6mdfmW1csl6JK/Gyqr3vi5NKOX74tSt0eioJncCxMTniqYh5eG2GZigNMQmmT2zmpz3+bfT7xX1cgHkL5w9Wd53EBXLB9JRN1/uTTRJIGidyNex2xXRCBN6t3WsGj/oQvhfdMwnJaFmvVD2R934nCTFxzi28iNuYOR5N7EGkvNWby4yyLJUbN/Kh+Ce/Mkkw0411kSawppDsHqMOhSD85wKhoFXQAMpkW0CyEEBA7/JdSWTtP2csQdfc/7JRGtPHSJ1CIDceB6G996+DpaBH7yVlM6YMlTWlMfx0AAqzWE2GI+kFE666+RrkSMbmIiscVm1bZJEa2FGRSDDb9QHZg4fG1akW+iYd+vDj0mXrKH4CXNoEfugypOuf6qt+qoT1d6zA==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(38070700009)(921011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?4dsgvqUHrqfAAjwpeyXNGmTeAzY/ybTTSFhabbkAEMNGmG0usHK3TBFD32?=
 =?iso-8859-1?Q?tKIkG7AD+w+tf9dUKURAbU57Qj0ZpeosOjJ9LM3wklT0Gz51wjimLlRZ2r?=
 =?iso-8859-1?Q?xTEkHMhUvqTZx7vTcxzfSRLB7CFFs0ygUZ2t/ygfZsQggtbXpfRQqHXH3L?=
 =?iso-8859-1?Q?MR15y/wQGfz18ScwjuVM3qfP51OQHCoaS5vyMYI0H4h6YcyOTGDIKmM/F0?=
 =?iso-8859-1?Q?x+fY8LGHuI0jby7lCYrmoDmVczg6phbYC7PJnKt/rt0vvWMKzptnOwZ2Fo?=
 =?iso-8859-1?Q?80fIu+YjH9/jhg2TWxnIDjsL+h9Mk8fFSmcQSB/8UKsOzk6oBSlwoPlh1+?=
 =?iso-8859-1?Q?XHQARXkIn51dMAmrm1YiPBDDbjQsixfX4RQNEyOocwmHAOnHAyQqiSvRhz?=
 =?iso-8859-1?Q?Mq8eUNN0g+uKsatnqwIzaMFX+sP5jzjUk/VBvWWhnv5BiU+7xewa/5AYRO?=
 =?iso-8859-1?Q?qbJX3hPQlsB9PGXUPr6mBIevaQoisZYG8RLsj2C83nOCawU8X48yJR8RXr?=
 =?iso-8859-1?Q?hjKq4VpK8C3Xqk29vzQJLsa30gs9w7/dVf3g5JGXYjOPqtrQ7EACvtyI/9?=
 =?iso-8859-1?Q?U8x99N6Snim8S3f4cCuWGnKniZ1szqx1QqmjspDHY265ZVNHA34HLkOjUA?=
 =?iso-8859-1?Q?62M4riC/prKKH64CInxjDvcvwp+x2YZTmWuE56P02NlhgtCPMYh6nVs956?=
 =?iso-8859-1?Q?M5Kl7EiULPleuqFfBeT/N4eH9sw+vA3MES6/NNLy1NQ/t0tMcqkO4Davif?=
 =?iso-8859-1?Q?UBsvugGvVFNr15yqKl7TBIaRMVhX4VE01mD0UEeP26ESxVO3OqyEFMcah4?=
 =?iso-8859-1?Q?h9RHDZY5TGlUgxQogFLjXlxxOdUApeYeNsF+ceS9b+h30xwIFg9FQkNBWR?=
 =?iso-8859-1?Q?qA6nhlbRwM1WpxKm0KG3EinXOPkyCmr9nR4O9YAiUL0EwZ66yqcNXQHdzG?=
 =?iso-8859-1?Q?/RRnHbpSTe80PIYwXRZM0JTFda1KG1B5mmMzhilT0OTrchaO2xR7bvxfHa?=
 =?iso-8859-1?Q?O3CpTlrq18HQu/wA0Yp0hiatA2CBy3igi+lbHofa9SMrA0At8pSOuulWmu?=
 =?iso-8859-1?Q?lj8vMxlm+IVqLQ0faSg7BjXqa/f6CghBU6odMA0u7V4FQse06DkvEe/Vpo?=
 =?iso-8859-1?Q?4mvFG3hI0mPJw8gRvIEHnaIBjlmo9o/PGEaDVUC5Nstb878kzqmkPjyjjz?=
 =?iso-8859-1?Q?BFwTktYTNuOvYeXiU2m6yuDpHip87kQd3NAEN7G98EIzUk4wUgjyle2M/1?=
 =?iso-8859-1?Q?w3w+v4cWv1q8C60D0KgtytXxijfuzVaM39FNQnMTTcNOB/TmamTM/Af314?=
 =?iso-8859-1?Q?jIGAcXBG4WL2fErdBPCh9ifU5SbrJVkHo0KxW5FRnNJ8pxInADkZHMXPa7?=
 =?iso-8859-1?Q?Xfi5B8U0r8GrhKLknUOjJeUkgg655Lk2Fyw9KsMzF0wnCHdy8BD8urEHzM?=
 =?iso-8859-1?Q?f+ReX8E5xrbsprB2x6WvWK+2X8fnRzDFZxQgo/vgATJFwlSoX72pRXQF++?=
 =?iso-8859-1?Q?5B83gwnou4pBu78Vfh511QVftWL4ZTbDTvkfywKCTJ4xHkSZ+S/eLMZJDq?=
 =?iso-8859-1?Q?Eli3LRLdeky3IKxa10imhP/dQA88qKA35BYDeov5o3mkkX76rFsSbR6WvG?=
 =?iso-8859-1?Q?iEMmZ4b+CSums=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0006b57a-b45d-45f4-f41d-08dc31f12ab1
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2024 08:51:45.2895
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yut0MWX5lFwiUaX1f1UzdMni2ozcRbJFDSyUzkMe+pf2b4fhB/a5zuci9VEwPfYz/QD3ic+zlGVZ55WaN+oV1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7884

>> To safely use VFIO in KVM the platform must guarantee full safety in the=
=0A=
>> guest where no action taken against a MMIO mapping can trigger an=0A=
>> uncontained failure. We belive that most VFIO PCI platforms support this=
=0A=
>=0A=
> A nit, let's use passive voice in the patch comment. Also belive is mostl=
y=0A=
> a typo.=0A=
=0A=
Sure, will do.=

