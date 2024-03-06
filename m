Return-Path: <kvm+bounces-11089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50364872C50
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 02:46:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB91C28BB6C
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 01:46:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A340879F4;
	Wed,  6 Mar 2024 01:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UkFxtyTJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2073.outbound.protection.outlook.com [40.107.220.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2262C2CA7;
	Wed,  6 Mar 2024 01:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709689603; cv=fail; b=fR+UOuXe0RB3KeW6XiPgoazrY/0QSmJLmSwn9lP4CRc4RSnTwwLpz6NvFGm0xw+XmB/mC6otpnF1E3vvY4avVots5DUFK3cqooqp3AnrrdXyxok+QGe8mYvZb3AXLqikXVJbjMCN6cJ08856jiTrqTGcVCBiNyNeDr2XeQCo7oU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709689603; c=relaxed/simple;
	bh=ZNR1L/zKPnC8uJW112JW0NEwNsWFjwnGnqemJTdDMNQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=g9lJ/UVHkL6Ek4P844Ii+FEVk9sB7todm3aOcnG51KervhOjiwOsN5rX92/2DjVGS11Rlf9bmNmtXGM8YsR+nAtLSFTGz/n1r4QoC4VZO250R1l/9e2Kwvd2uZgrchYgS/48MsCfazEMNsoJrkbtLpskZP9ef1/QMy/sV76OpKg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UkFxtyTJ; arc=fail smtp.client-ip=40.107.220.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IX19jhrDG813jqElzG5Eh2rEVSy/F4euTcD9Z83sdqfSMeHlYXPGt9ZWonEv3OA7mk3sgj151XvFwKcnswBZgtURctx1OegCWkEFlNGdKG+S45LzkMcPIOeeHLeiOXLSoHdobxBp+8Qh9GxS4ChR9x02Oj64TtORIPSp3imAIWc9KsL9IBODPh3ibbD5Mwp6q1inTO8JisIoDFUyDcBt0OZ3N0NqedP3olglPNS7pu5ICi4ZIYZdpuhde3GkqGTfZPkLbvjVkb3aQSfBgCxooHDAFIKl26AH2d9GEsbq2bujHCdHKOwpoC5+LAjUg7da32ie5rRDZjmrqhjeJAz3qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZNR1L/zKPnC8uJW112JW0NEwNsWFjwnGnqemJTdDMNQ=;
 b=XZNaS2QxuDBRVH97+Aujizk2uL5BoJkUc9CxYgk9Rqy/RuMVrWj8oqonlkWgb79R28O6sSOIvX2CmDMMPUFsux58iKCIl9a5ZU0W62EDpLgT0tNYxmuy5ncnct3rcYpD+/7y6DdQfnJp2pLYZShslxhh+zFO747RZj0gNp/Np2iJqNs13vQ85aPpEBZH2cBboaq/c+80Phey+MJMbtLfi+4qGTSMsivHf/5EsXhZfqnbJX1bvQzq74UitLy8+BoyCoshaGjVSMv4IsGFUm0p4RkCU1ZcRlAfGrEPJirXxwUkiy6/IzMvcQll0JxzbZ2IXfs3ar2/iGYFGratsGVkZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZNR1L/zKPnC8uJW112JW0NEwNsWFjwnGnqemJTdDMNQ=;
 b=UkFxtyTJ0JbsVEqusj68aaUuNjNr5C5xuWK7oobyaHvL+eKn2WNc91oYpf7GK0S9XstQfWxuXlew4+XwgmYS3hRUuLNDQivEl2+Kdwm0kq89YFZK9x70TMvk43muxz54nbOJu6q3LNTOEToQNBYL+INmHg5/kxKp6gNJNmLdELPMpUvpU8HpFx8M54XXmvcqwHlTvsbuA1tG83jTtmWkH68hk5miKCncKPoOaW2xYU5lPhRZuKHLdSo5KgJBd2oEeBIllzIKW+28jAGiAGMf//ebGJY62ksxtiQeqOwHeoRVto9DZrIuu9kOOD2m/33Rtbkz6MGEHXWQaKxGowp9EA==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by SA1PR12MB8742.namprd12.prod.outlook.com (2603:10b6:806:373::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.38; Wed, 6 Mar
 2024 01:46:39 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::284c:211f:16dc:f7b2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::284c:211f:16dc:f7b2%5]) with mapi id 15.20.7316.032; Wed, 6 Mar 2024
 01:46:38 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>, Oliver Upton
	<oliver.upton@linux.dev>
CC: Jason Gunthorpe <jgg@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, Aniket Agashe <aniketa@nvidia.com>, Neo Jia
	<cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy
 Currid <acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John
 Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, Rahul
 Rameshbabu <rrameshbabu@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, "Anuj
 Aggarwal (SW-GPU)" <anuaggarwal@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>
Subject: Re: [PATCH v2 1/1] vfio/nvgrace-gpu: Convey kvm to map device memory
 region as noncached
Thread-Topic: [PATCH v2 1/1] vfio/nvgrace-gpu: Convey kvm to map device memory
 region as noncached
Thread-Index: AQHaa0cN2WI85WCFtk20cXCANmaSKbEpzsIAgAApxtc=
Date: Wed, 6 Mar 2024 01:46:38 +0000
Message-ID:
 <SA1PR12MB71996264714B5EBE01ED7646B0212@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20240229193934.2417-1-ankita@nvidia.com>
 <20240305161256.09bda6c4.alex.williamson@redhat.com>
In-Reply-To: <20240305161256.09bda6c4.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|SA1PR12MB8742:EE_
x-ms-office365-filtering-correlation-id: 8bb309ad-dafb-4a42-afd7-08dc3d7f43ca
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 cHOvBpTvBBMY3XoyX/AFqFVFey1fiM8KPanZwz/dkIB8rojJexUPbYH/M4NhTt7Oc+FFiWFaSDccTLbxhQeyUIXs2ZssX+gTzfGo+m/z/GMeeTqs9RQIEMYFUen9Od0yspyDbwkgUxutlc6pDoy8TtDp4s7EGddPRldXV6dY0yCehreawyWeXm/iiB8T7f+1WYg36TD3dri6bBXbEdUMB9lNYCe/7HWniKx35G6Eb2IUEpbXF7zDE9Lr+O+HOBQ6Yjbl1oT+B0/gmU47iHu6mXFTV5EpbQu7Bt/S+a7YLnJY6aZFWktiWWabZf/H0nW49QWnKPtZJbFZWMihV4s1Ym42v5H54GlZHuv4U86wdUibLeHTEO3F0ER0eur9sLJiHZlYsed1K6i5xmGU0iNrR3KKWciq+rsWkLmwtedrJ6137QW3GezZOCbp0ZWvn4UemsTvuSND7J+3z20mQKD1hgiccRkzHG6GTaFKP+1xF6r8ctTSMdCsfo6/3NoyUKGqWqIPE/pN1CewPv7L7MSSXRbxexoehY57Yridlg107KkkqnyrYh52hASb934nLdzfoXXkC7Wq3wPNLFKD03xbhTG5wws1cht1tBPqlE+8owCF7USayDaA+fwoQULO8QNmVTUUnrxV8fjUb2kNHIuCu2CG9SyoY5VIOCHR0GZV6znocYtVauTscmK/c9AcBmNhSCm5uGoR50MtVY/zcqzU7yPkSkhuzx+xxIONRudm3ag=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?u6Fp0ix2nstzsDRFoqQZdi6Hy4zEGcbI5Ep3uIn+PX1RQpTssRR/W6Mbed?=
 =?iso-8859-1?Q?L+5tA0yCHd2B2eKhVuM0G9Yw0lGQCm4KzYQhRMOAyQLkE7JuydKuvkZUM6?=
 =?iso-8859-1?Q?OzC/njwMJrxM4wq1n62RnlSi1Sb/7yc3H9n2TvCqS3ta6H7LgHZAlL8DcD?=
 =?iso-8859-1?Q?h2LG5lnL5BHORzXEDw8n9eEZEGYkUUXUWNFY2BvQmmQKDBweE0dvcYMZeV?=
 =?iso-8859-1?Q?iawdQxzb5AtP3k2ajTBW7XhHegzOr14lUCA9JHvpn4MhEV+mYzudB4V2Y4?=
 =?iso-8859-1?Q?YFoBb3IftDmge61QJ590QN45vRzoZkGyFNLo3b3SG5m6nexT2eMSSwPY6m?=
 =?iso-8859-1?Q?sjbQ7jAMI7mjDLXQ+L5Z3Y+vt3lvHaxbY0Oe0aB/WwfJEZZYqePJEc6s0Q?=
 =?iso-8859-1?Q?QaZ7LIkap8eDCdDObC7x3+RqC25LElxJGdqrLxUIwsOWr3gdmxIpCyzG0q?=
 =?iso-8859-1?Q?3LWe5RCV9D0h2SisvAMMXvObklyhQwny0Qa/t3r9cgnY+QyEitsti4GnDX?=
 =?iso-8859-1?Q?8gsBZjmFsNO2yBQT8hzF6uqVhATKjQQgmFXmd8httdaegPVGwg7vYJeHJa?=
 =?iso-8859-1?Q?WT2klImcmVli9AI/UfMeGXJ+vpRujOspeDFzyKFLZO04nvkFRZ633tE0yy?=
 =?iso-8859-1?Q?762RoW40yENC3AlVYqNslNi1voBdoRhR7CSuIACiWlONKh72SU+rBRf81V?=
 =?iso-8859-1?Q?p2DGSq91vPwrGbD10tw5jluCRrDBu4y03m4G7iRWzoiTdo+P4dGaF5YBjw?=
 =?iso-8859-1?Q?Dr+q587jX8eKsNDJEu/FDmFt5ADOn0QilbNB5kRwIOsC4LOe7VVt2oxj9c?=
 =?iso-8859-1?Q?Bwha3bXiOyVwc1Fo50HPuv7ODtCChfwNdRr1qvm9lXgV7eJKxacYgWfBxa?=
 =?iso-8859-1?Q?Xh39X5XwkHF0xfW75Gtl8p4Pt0dfAx1LvaWDBhNIHOs/2Rs0YfBbWvgj7C?=
 =?iso-8859-1?Q?IA/gV2S+iRHH3+jdcg3lqcazx7g1BridpKTwMIeQribkNAZOmh5r4A3YZn?=
 =?iso-8859-1?Q?ADRPiPnZML0Fq7h+XlAiU/3GJkWbnEbweRr2GNx7AP7TPuDk8W5T2qmdqf?=
 =?iso-8859-1?Q?R/A5Y72hnVj4i+LYXKh7wub3UH8DI0XVeeoylvmfQN1Tyr4ETiSMh3KTA7?=
 =?iso-8859-1?Q?ZKfXcb7FwtI/z1MIuBhC1s83siuKjk9Y++zpnbs2/4Nm/NVNYFTmeyCm1T?=
 =?iso-8859-1?Q?yMUTc5HoEu4I5FIL3OeAvNt7MXNEIxG/RUgi13nw92ocOsvaxtO+3+7RLO?=
 =?iso-8859-1?Q?hpYSd9w6AZvZuI4GOxCss+/tXXM/jwfD9PzCjkd1xpAcAKt5eyvu1sNnll?=
 =?iso-8859-1?Q?qkLTYFFC3SVlWdMKlYkCnfVzVLsKwNdbxF1kvsoVDRpCfzVtlL5otZuhww?=
 =?iso-8859-1?Q?LJ4oDqEgoo5EQL8CcMPZhqNJ9lVhIeDdw3o3UT2S/cq9xjZqwfpRlt+0/M?=
 =?iso-8859-1?Q?EctlSFAnO4DRV7oYxROr51sc5rK1S1qMH7LG/EWQKS3+6760j2sC/nGapX?=
 =?iso-8859-1?Q?qzm4c+883b55KeBRzs3F6lnMQbKWU7ZTcVBmQskKHNXEX9p3tglN2EofhU?=
 =?iso-8859-1?Q?4h+YiMbCN+rsPf0nnU9l319rMikWC/OEqIMdQxaAd7qrYM4zD6sPaX74RR?=
 =?iso-8859-1?Q?FEcqLkmh4vuWQ=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bb309ad-dafb-4a42-afd7-08dc3d7f43ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2024 01:46:38.6670
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e5AFnjRgRyPFFQlqiLd02dCnbOWtdY+/Fnf4OB6D8+hMPikvxqwLUHyyFhkcJGX1Yl5DIYaYyNDBIauzauMKUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8742

>> To use VM_ALLOW_ANY_UNCACHED flag, the platform must guarantee that=0A=
>> no action taken on the MMIO mapping can trigger an uncontained=0A=
>> failure. The Grace Hopper satisfies this requirement. So set=0A=
>> the VM_ALLOW_ANY_UNCACHED flag in the VMA.=0A=
>>=0A=
>> Applied over next-20240227.=0A=
>> base-commit: 22ba90670a51=0A=
>>=0A=
>> Link: https://lore.kernel.org/all/20240220115055.23546-4-ankita@nvidia.c=
om/=A0[1]=0A=
>> Link: https://www.nvidia.com/en-in/technologies/multi-instance-gpu/=A0[2=
]=0A=
>> Link: https://developer.arm.com/documentation/ddi0487/latest/=A0section =
D8.5.5 [3]=0A=
>> Link: https://lore.kernel.org/all/20240224150546.368-1-ankita@nvidia.com=
/=A0[4]=0A=
>>=0A=
>> Cc: Alex Williamson <alex.williamson@redhat.com>=0A=
>> Cc: Kevin Tian <kevin.tian@intel.com>=0A=
>> Cc: Jason Gunthorpe <jgg@nvidia.com>=0A=
>> Cc: Vikram Sethi <vsethi@nvidia.com>=0A=
>> Cc: Zhi Wang <zhiw@nvidia.com>=0A=
>> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>=0A=
>> ---=0A=
>>=A0 drivers/vfio/pci/nvgrace-gpu/main.c | 11 ++++++++++-=0A=
>>=A0 1 file changed, 10 insertions(+), 1 deletion(-)=0A=
>=0A=
> Applied to vfio next branch for v6.9.=0A=
>=0A=
> Oliver, FYI I did merge the branch you provided in [1] for this, thanks=
=0A=
> for the foresight in providing that.=0A=
>=0A=
> Alex=0A=
>=0A=
> [1]https://lore.kernel.org/all/170899100569.1405597.5047894183843333522.b=
4-ty@linux.dev/=0A=
=0A=
Many thanks Alex, appreciate your help with this!=

