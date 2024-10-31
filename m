Return-Path: <kvm+bounces-30192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 508719B7DC2
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 16:06:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CB2711F21526
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 15:06:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45D041BD51B;
	Thu, 31 Oct 2024 15:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="r2sXOOA2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2079.outbound.protection.outlook.com [40.107.94.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDA51BD4E2
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 15:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730387098; cv=fail; b=MYQVLw/MeRZSjEI2PH/P26Ym8YkshSknmxAclrPfpVW3kRff/xwQkapxNde5REw9kU6kIIDX+q58xLTwY/gos9NNmwRwfT6qHO/HSTLjuqnixMzOUBiW2FvfjyeLEiA4G6NmUConpf9z5SOHRfy3ot01VavdcFXOSxWYwbCuISo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730387098; c=relaxed/simple;
	bh=RcqH4apqEnBqwml3SE6Z9s6kexwl+eHgVekWl/5K06o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=omn81Y8Dy6Aa6Zb7SakxDwknn7rAzbI0xJ2FZfRPdN1DrFkb2YW0shSmHpYNpaeBT4EEIbVDT9p1G3CIuU1748Thav+nrkAb6Z22rfUZuiZAGVc3n+m0H5aZ58Y7V0if8wFgX0dO8b6IoTgpsw+czJheb1Q12A9sRE06xv79lAI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=r2sXOOA2; arc=fail smtp.client-ip=40.107.94.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cv3fDXOnXRsUUIzjEDdtirtVuE3csHSLJMd208LI90dqgnHehheSm3EBwY+wtnAaWCo4noY3N/NgRax5EioDl3ECX5xMV1139KALMQlt/IPPtVqPRSpXd5NK7PRftvF/3yjCgkqwpyWjpYoPbt1/Q6ar75MuBN9E5Q6Bywq4nqkm3U2RlC1sEcZVkg1FypwGs47a1y8JlxAVKDAQ82A31bxmuqfumN2ezvFnv5rVWIuyZyG83kDNXhzywSw5UAywjQHZV6E8DuOa2WO8r4xwGXjIolJOHqkvUUX8QH/IGqBKyp947ypCiLHie3pcb+AzZaQtel/WG7y8SuKyAYrMWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fel64l8Z5UJL33tRrHiafdDzVLhTOB1QLCca+mWYEHA=;
 b=pzWYboF4Kx+xog1/wnBW6ybUbYh4r+iEc97Xhtxi69J1TLP1bkwhGazmltSkQxE1QRgDyaG0zK4vxfjv3fYR+v3c2/l7/1ZYoslNckFTV7Dgc7EWHocwu1BdtOgUz/uTFRO9LidwFoKjZZ0wUr8BSStlyGOqzgK/GUw1bOJftruy/GxoHgJ4H6565D3D7DKiyr7n2yUZGH6FqMzyxFW5bZxi8VBNl0pjQT+1WZ10uxOdlaajdapRdLFbRWEejWH56F8hINOp1Vufr/sZb/HkBoPtvzFwLKqh7DuHZTXK9zc05ByUgpbYTokKMFZDTC6fBFotRfmzWct9zMVk8rP2aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fel64l8Z5UJL33tRrHiafdDzVLhTOB1QLCca+mWYEHA=;
 b=r2sXOOA2WYdFnBjDqscGcHfsDElcGrEWg4g7I2irzkCDosZYShzfd4VmbroLabwM7VGnwQUUooHZukWllNkfduZypGMwKipdjFryD8ubrh/OFEXPpRCn2OV7hRIyGu/lUhV3ZZWpyrJ7663VhlJui3b4fZ4Ka/X1+JpyFWuD0LXltNUBjWMBueWPZlErkDV6IwX+NohjzBeI43n40TPbZFbGPfUal0tBwhb1JOTbne4et0QdR1kTkD21qoQ9QIzg/PfJE3omr8fx7eUxCXx/wa4cUmZPy1yU2qNgHlA/dzM+b9n3V4uXHkUc4dDpeKbUukuOv9GIo7oZ7gWtucAwCw==
Received: from CY8PR12MB7195.namprd12.prod.outlook.com (2603:10b6:930:59::11)
 by LV8PR12MB9206.namprd12.prod.outlook.com (2603:10b6:408:186::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.18; Thu, 31 Oct
 2024 15:04:51 +0000
Received: from CY8PR12MB7195.namprd12.prod.outlook.com
 ([fe80::c06c:905a:63f8:9cd]) by CY8PR12MB7195.namprd12.prod.outlook.com
 ([fe80::c06c:905a:63f8:9cd%6]) with mapi id 15.20.8093.027; Thu, 31 Oct 2024
 15:04:51 +0000
From: Parav Pandit <parav@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
	"mst@redhat.com" <mst@redhat.com>, "jasowang@redhat.com"
	<jasowang@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, Feng Liu <feliu@nvidia.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, Leon Romanovsky <leonro@nvidia.com>, Maor
 Gottlieb <maorg@nvidia.com>
Subject: RE: [PATCH vfio 0/7] Enhances the vfio-virtio driver to support live
 migration
Thread-Topic: [PATCH vfio 0/7] Enhances the vfio-virtio driver to support live
 migration
Thread-Index:
 AQHbKFgwmMFKDidgeUS806gohYGFpbKcWAwAgAAC0wCAAAhuAIAACAsggAHGLgCAAr86QA==
Date: Thu, 31 Oct 2024 15:04:51 +0000
Message-ID:
 <CY8PR12MB719511470E1E0BAD06CFFBD2DC552@CY8PR12MB7195.namprd12.prod.outlook.com>
References: <20241027100751.219214-1-yishaih@nvidia.com>
	<20241028101348.37727579.alex.williamson@redhat.com>
	<20241028162354.GS6956@nvidia.com>
	<20241028105404.4858dcc2.alex.williamson@redhat.com>
	<CY8PR12MB7195FCA5172D7829B1ABC773DC4A2@CY8PR12MB7195.namprd12.prod.outlook.com>
 <20241029142826.1b148685.alex.williamson@redhat.com>
In-Reply-To: <20241029142826.1b148685.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY8PR12MB7195:EE_|LV8PR12MB9206:EE_
x-ms-office365-filtering-correlation-id: e17bd24e-b499-400a-b0af-08dcf9bd5ee1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?lSp+LSgQ+yskRN2/0fjlkpmMkUzTw4HX+RJbaVIkba9er+MxLfUPtbggo2g6?=
 =?us-ascii?Q?n6TS/KKpK5ItA9XJan5VHa0GkddjfcWI4A6V1WB0u5bUBFuBoYZn8vIvr7Ou?=
 =?us-ascii?Q?zIrKK+ybCXiabtDtW+3NNvlw97pnaDQ59Q6eZLaZ1MZvrHYkeGhC9b3S5zuk?=
 =?us-ascii?Q?nPeX8RW3FIlrrg9R9n5OHQA7KW4c13zWUol/OzZlbiltxDPzCyV4hAmJXhxT?=
 =?us-ascii?Q?AhW8DJb2MvGk4ZNCB6oU/WYbyNodxMATVpWF+FAZnLYlo5kWR4Fc93Gfa9Hr?=
 =?us-ascii?Q?wv2P7nPZ8taJXL029GTZ/9/SSIzgzxB9BOk/i47ZwxvagpYjnATow7HKpW9w?=
 =?us-ascii?Q?KcijaecQ2U2/+0k+GOZ6iXlXYn5G8cm1s+YYN03aO2fn0LCdI5szzAQLz39i?=
 =?us-ascii?Q?BvBMo7cyao+tCJe3DhQAW9CyyQMbsQ5j/vO3OnvvEvtO+eO/JTqTuW7Ekw15?=
 =?us-ascii?Q?QSOcLh4XMie5/jYHl7WC9lzhPvGmML6pdFmmlxjYITUIR4LIV5NfqFF0dRro?=
 =?us-ascii?Q?+bQwcWiNm6vf8au1q+PGUH2/H/pVjdUKDenv2oEMkeUCpHhI00sFQZQoxKkV?=
 =?us-ascii?Q?2WdJno2Jk+ooTHEzpQaUBm2c5NgfZbIS55KZLNPSH47e5R51rtN7snJIp72b?=
 =?us-ascii?Q?FjDtmx9BbsIkrGU2oN8e6Fp++9nVy0Rcq93/Nm/Q0xpvyQl2thN/bzy1r1Of?=
 =?us-ascii?Q?aOwSSiE1oofVVheqCQ1LBvfeVffysaP7/zqtTIn4vYv+pkVaJbSfEPYBryZg?=
 =?us-ascii?Q?xgMLRVXShPRSsTIhR95pc22uw6SJfVL3rkB9FkS/pyi7raFFiM5eKx7/jJMC?=
 =?us-ascii?Q?MgMg2X4NTilmOli7r39EAsE/9KBBKEljBk4+/zxM6IY7slcU4DVlaEEfDZy9?=
 =?us-ascii?Q?Rslih5VvLU8yVrEIEvVNrqYuAxtsQ8wasgaJSjOfsBQC4j3d6heOGcDRi6Y1?=
 =?us-ascii?Q?RBPjiVCVN2dBaBJwsWCH40oXOj5rmlHzthuQgwINtBMWxArZGzQFjIkSSHiy?=
 =?us-ascii?Q?VrZvrfcIdpRgUf1qHo22bVocScV8qLlDcjUXiM6l5BBq63Zrww03NDC/EdbU?=
 =?us-ascii?Q?dMJjuc7ulrJfgR7mL1I7pEiol4VcaUtTDVsKiGYK1UQ3TMN6acbAB1ciVG0U?=
 =?us-ascii?Q?Hl5NSykpdgsS5JRA+VtfLUEz5IayP1izsfvmBbpm2B8N8kfUmPiyiRDr/AY7?=
 =?us-ascii?Q?8Kc9Pwdje2C2n67HhAyCrd7cwuW64C+foNqyvnY51RaliRU+RsIksO1BTWsp?=
 =?us-ascii?Q?S+oRZZ+7ApHdcDFD03QUFIPcAHEmxUwm6+qYLjTGDAT2fE2vYl/IND9Ce2co?=
 =?us-ascii?Q?pioXXZBpPYDPgq6u4D4et2xAaYYtYH+tuOdTvKMM1tkgZXm5fViRKR+75ezA?=
 =?us-ascii?Q?R7DWss04G8j0sejcGGX1uYvF05Gj?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB7195.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?RZF793dPXl0OgAGtD7u4RBJTT4XbsaGkryzzNSmT4lYMif2uJYxiP8jowco/?=
 =?us-ascii?Q?/9D62IppAwTNUlcVSmQZlU3EWm9Po+ZWjETwt5pL6lQ4ra/7ld5Oq51eANyi?=
 =?us-ascii?Q?+u8e+gdxZB/OEiO3t6tUMKkmT9f5Pa3NN/k5+X6f3C9f8efD8ZchyE9IxDMG?=
 =?us-ascii?Q?lRetNg5DrLLyYegbFOmNvfcGADTjJlXuxwP04T9usPHyjH1aRePNQ62g7ovw?=
 =?us-ascii?Q?KTh0+U6mH+zzjs5V+ffT6SJvCglGVX3ZYPK0w8xxhF4MpL4QQZXZZ3474Fio?=
 =?us-ascii?Q?ug30vMY8oN1pcAMC08101AYx8grF65NakmI/sY2G4OCNfR0VQ5dtZgTendgZ?=
 =?us-ascii?Q?S0dj2UPvcClKQOOunFmPmQ9+Uk81W5Nf+GtbMTHjGhJP5OlbaHRr10upoFAB?=
 =?us-ascii?Q?qpjQM/mMUC9e9o7TZkPDV/TUAk46fcfzpjXkKf511S8fT5kkhCQlaaNg54n3?=
 =?us-ascii?Q?RmebvXao43tfWPitDi+DgjsXvGH12s7H77SW1Yku75ipRLXkLJEZ2p9nw3VX?=
 =?us-ascii?Q?n5VZqRCB2YHfp5CsVC7PlvfbdS77/z5LXxhhFosdu4ozR6sZNhIKJYuCrJzc?=
 =?us-ascii?Q?HgR5OvNN0/aeS02P9qtAN/eOWpRUe0SKELZ2qKLOfjckMVDKdzYJE028R2Ms?=
 =?us-ascii?Q?KIMSxQVVg6mC+z4mhMGvlvUvCDv5TNR1zWswYqd+JxBynR/Oewv9OBjAIjvV?=
 =?us-ascii?Q?MJPUnf+dDwu5ayb6dm49erc0JxNm0NYXM/G4azTTCKeGICKIIBgDzFoM3O3P?=
 =?us-ascii?Q?UTVpCKS6av8USLY2lZfATIaySjmcZweUex7Hv3ImrHXjecJyuqI00rPmDLkk?=
 =?us-ascii?Q?UVjCsebpZx4OBgIcPGIe1h8UDvy9stc0UDe8MsFa5Is1kM9gHpUn7xHzHLHQ?=
 =?us-ascii?Q?xjQgVZTOFTap7ha5x4pJUJ/b1RvikgBki+qM2pJwZ0tbeCFQdzOsMFztWeL2?=
 =?us-ascii?Q?bnxUjruUfrkONkvwT7OxCaMM8D/KoNUiV7SNIhZ8XveePvj319KLTcas0Bn+?=
 =?us-ascii?Q?y6Q9h8lraaSp4Fa6Ff7vcjD57xbOnbfSd4fccBGPqmvOZ8ADTkqsygZHB2+K?=
 =?us-ascii?Q?crnWx5VQAyYq3+/NGBK966vm/pMxZkfuY7UmAYebxCQbi3nunZrNXgiGSveu?=
 =?us-ascii?Q?RZRnuT2RNhDPlMGMRyIfEtQduiL9T+o1eJjPJ/RpgpIwNuw4F8TBrQCrokDS?=
 =?us-ascii?Q?fAzX+XJRDJIrxXpQFMlBV8/01S6GcQZXILex/lcxYrhhVSafJ07pb/LCg271?=
 =?us-ascii?Q?TvPPhoQLLzRpItKUbPpriWtL3gkNB5/GgyUo9OaJ4wm9WM9PKythOuRY52oh?=
 =?us-ascii?Q?ZzUAcz4k3d4roWMY2pjtxArxoUPKwk1y/SjGQmLd4zRkserGeRjZUHuOPKvH?=
 =?us-ascii?Q?Ibmfn7jyr08mMNIxCOV3BfLb+Wk1FRAzkFwBM/tKGjNviXeBJSNdCKGHqRNY?=
 =?us-ascii?Q?KpwOPliB2R54J6s/+nPTiH+/NvsFzHuKLYJ6Ke7a3FxrJhtMQG2XfRJd8Kuy?=
 =?us-ascii?Q?OFLKGEqPNTXm2X5BgTexlPyXtosiCLEtYtfMJqAKWxnxNudMau59VuT3OZUx?=
 =?us-ascii?Q?r/fiQDTu8mowg6Cqu5k=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB7195.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e17bd24e-b499-400a-b0af-08dcf9bd5ee1
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2024 15:04:51.5351
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 98i92psv7zMWIT162noHvUGvItNvC2ixe6jmtQMe9kn46p/PNtdlMSH3JNr5S02Gu/RXzXzlU/+kWr8azGAgig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9206


> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Wednesday, October 30, 2024 1:58 AM
>=20
> On Mon, 28 Oct 2024 17:46:57 +0000
> Parav Pandit <parav@nvidia.com> wrote:
>=20
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Monday, October 28, 2024 10:24 PM
> > >
> > > On Mon, 28 Oct 2024 13:23:54 -0300
> > > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > >
> > > > On Mon, Oct 28, 2024 at 10:13:48AM -0600, Alex Williamson wrote:
> > > >
> > > > > If the virtio spec doesn't support partial contexts, what makes
> > > > > it beneficial here?
> > > >
> > > > It stil lets the receiver 'warm up', like allocating memory and
> > > > approximately sizing things.
> > > >
> > > > > If it is beneficial, why is it beneficial to send initial data
> > > > > more than once?
> > > >
> > > > I guess because it is allowed to change and the benefit is highest
> > > > when the pre copy data closely matches the final data..
> > >
> > > It would be useful to see actual data here.  For instance, what is
> > > the latency advantage to allocating anything in the warm-up and
> > > what's the probability that allocation is simply refreshed versus sta=
rting
> over?
> > >
> >
> > Allocating everything during the warm-up phase, compared to no
> > allocation, reduced the total VM downtime from 439 ms to 128 ms. This
> > was tested using two PCI VF hardware devices per VM.
> >
> > The benefit comes from the device state staying mostly the same.
> >
> > We tested with different configurations from 1 to 4 devices per VM,
> > varied with vcpus and memory. Also, more detailed test results are
> > captured in Figure-2 on page 6 at [1].
>=20
> Those numbers seems to correspond to column 1 of Figure 2 in the
> referenced document, but that's looking only at downtime. =20
Yes.
What do you mean by only looking at the downtime?
The intention was to measure the downtime in various configurations.
Do you mean, we should have looked at migration bandwidth, migration amount=
 of data, migration time too?
If so, yes, some of them were not considered as the focus was on two things=
:
a. total VM downtime
b. total migration time

But with recent tests, we looked at more things. Explained more below.

> To me that chart
> seems to show a step function where there's ~400ms of downtime per
> device, which suggests we're serializing device resume in the stop-copy
> phase on the target without pre-copy.
>
Yes. even without serialization, when there is single device, same bottlene=
ck can be observed.
And your orthogonal suggestion of using parallelism is very useful.
The paper captures this aspect in text on page 7 after the Table 2.

> Figure 3 appears to look at total VM migration time, where pre-copy tends=
 to
> show marginal improvements in smaller configurations, but up to 60% worse
> overall migration time as the vCPU, device, and VM memory size increase.
> The paper comes to the conclusion:
>=20
> 	It can be concluded that either of increasing the VM memory or
> 	device configuration has equal effect on the VM total migration
> 	time, but no effect on the VM downtime due to pre-copy
> 	enablement.
>=20
> Noting specifically "downtime" here ignores that the overall migration ti=
me
> actually got worse with pre-copy.
>=20
> Between columns 10 & 11 the device count is doubled.  With pre-copy
> enabled, the migration time increases by 135% while with pre-copy disable=
d
> we only only see a 113% increase.  Between columns 11 & 12 the VM
> memory is further doubled.  This results in another 33% increase in
> migration time with pre-copy enabled and only a 3% increase with pre-copy
> disabled.  For the most part this entire figure shows that overall migrat=
ion
> time with pre-copy enabled is either on par with or worse than the same
> with pre-copy disabled.
>
I will answer this part in more detail towards the end of the email.
=20
> We then move on to Tables 1 & 2, which are again back to specifically
> showing timing of operations related to downtime rather than overall
> migration time.=20
Yes, because the objective was to analyze the effects and improvements on d=
owntime of various configurations of device, VM, pre-copy.

> The notable thing here seems to be that we've amortized
> the 300ms per device load time across the pre-copy phase, leaving only 11=
ms
> per device contributing to downtime.
>=20
Correct.

> However, the paper also goes into this tangent:
>=20
> 	Our observations indicate that enabling device-level pre-copy
> 	results in more pre-copy operations of the system RAM and
> 	device state. This leads to a 50% reduction in memory (RAM)
> 	copy time in the device pre-copy method in the micro-benchmark
> 	results, saving 100 milliseconds of downtime.
>=20
> I'd argue that this is an anti-feature.  A less generous interpretation i=
s that
> pre-copy extended the migration time, likely resulting in more RAM transf=
er
> during pre-copy, potentially to the point that the VM undershot its
> prescribed downtime. =20
VM downtime was close to the configured downtime, on slightly higher side.

> Further analysis should also look at the total data
> transferred for the migration and adherence to the configured VM
> downtime, rather than just the absolute downtime.
>
We did look the device side total data transferred to see how many iteratio=
ns of pre-copy done.

> At the end of the paper, I think we come to the same conclusion shown in
> Figure 1, where device load seems to be serialized and therefore signific=
antly
> limits scalability.  That could be parallelized, but even 300-400ms for l=
oading
> all devices is still too much contribution to downtime.  I'd therefore ag=
ree
> that pre-loading the device during pre-copy improves the scaling by an or=
der
> of magnitude,=20
Yep.
> but it doesn't solve the scaling problem. =20
Yes, your suggestion is very valid.
Parallel operation from the qemu would make the downtime even smaller.
The paper also highlighted this in page 7 after Table-2.

> Also, it should not
> come with the cost of drawing out pre-copy and thus the overall migration
> time to this extent. =20
Right. You pointed out rightly.
So we did several more tests in last 2 days for insights you provided.
And found an interesting outcome.

In 30+ samples, we collected for each,=20
(a) pre-copy enabled and
(b) pre-copy disabled.

This was done for column 10 and 11.

The VM total migration time varied in range of 13 seconds to 60 seconds.
Most noticeably with pre-copy off also it varied in such large range.

In the paper it was pure co-incidence that every time pre-copy=3Don had hig=
her migration time compared to pre-copy=3Don.
This led us to misguide that pre-copy influenced the higher migration time.

After some reason, we found the QEMU anomaly which was fixed/overcome by th=
e knob " avail-switchover-bandwidth".
Basically the bandwidth calculation was not accurate, due to which the migr=
ation time fluctuated a lot.
This problem and solution are described in [2].

Following the solution_2,=20
We ran exact same tests of column 10 and 11, with " avail-switchover-bandwi=
dth" configured.
With that for both the modes pre-copy=3Don and off the total migration time=
 stayed constant to 14-15 seconds.

And this conclusion aligns with your analysis that "pre-copy should not ext=
ent the migration time to this much".
Great finding, proving that figure_3 was incomplete in the paper.

> The reduction in downtime related to RAM copy time
> should be evidence that the pre-copy behavior here has exceeded its scope
> and is interfering with the balance between pre- and post- copy elsewhere=
.
As I explained above, pre-copy did its job, it didn't interfere. It was jus=
t not enough and right samples to analyze back then.
Now it is resolved. Thanks a lot for the direction.

> Thanks,
>=20
> Alex
>=20
> >
> > [1]
> > https://netdevconf.info/0x18/docs/netdev-0x18-paper22-talk-paper.pdf
> >

[2] https://lore.kernel.org/qemu-devel/20231010221922.40638-1-peterx@redhat=
.com/

