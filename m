Return-Path: <kvm+bounces-8333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E63B84DF7E
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 12:14:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BADC6281F7C
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 11:13:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19F8F6E2D1;
	Thu,  8 Feb 2024 11:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mu8dI+P0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2050.outbound.protection.outlook.com [40.107.94.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0A61E527;
	Thu,  8 Feb 2024 11:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707390830; cv=fail; b=Imr4OD6DUASsXqnDwBqTZJeUjkVueTTo/bDz6Q613RCJOBDpZSBaIjkKFFYdEdxrn406A0sjYCgI/gHKP47kqM80g0DssfIWqwx1rk70XNzr9doJfwFFVRaC1xRwZyRuatKTUoLtwYSPLjVptyo/jB1T6UrdaRUZgQJ+jeDn3zs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707390830; c=relaxed/simple;
	bh=dHObtsaVeZR81v3QfzgEjxtPBZ7oU/M33DAdUz7DfQY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tpZ7n9LelYIPzgOwy/Wr2bWMAL2MsphSJBlzv7JZKznkO9lic5chAWgiAbSA1wrq7bg7CUErMugkz6sWNSWcM8x+z08coDe2W/QVjaK1/+ug6wpb82gCp4REfcL3RJsoSWp29xdvfpi8NB53FxizI9kVO25PfDk1gFW0mgKpWpk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mu8dI+P0; arc=fail smtp.client-ip=40.107.94.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=frRmZ2AbbgRcRbGUeEPnrzd1wZdaiWfyHXH4/1pREDpE2sC4AzIgrBMRuQqqctLk7A1lNl5+4L+/r89/to9Pb4M5CaaSCdinlVGKqWAzCPvGaQXJ5WiyiMiMHp3OZ3yD4ZlFnVDvPELXbZJJjVhnRF3mVBIQeibgLxfVy6d57wrs7ljM2fxU6BBy+84vSqFdxRxvSmV+xeEnBi3Uq8aLhHxtTzX4urxR3DzIjRTe6J8PWETR3JL7EmLWxiNsN/fW0LrtZV+EhSOvqiwFbE7bE2RF94hNvgk9zWo1y+CpEH8JmEMkiNSQj5JPD1dbjDC5zl2DRIYdxS2JzNRQ4gSUuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dHObtsaVeZR81v3QfzgEjxtPBZ7oU/M33DAdUz7DfQY=;
 b=G43xqHCa6QpFSgJt7+WPn2YaXIuMO0GwZegRrkq72VoqQX2Z9r9FHCcJMDT9vGxS8i/nM8KLoKXBTJQxLiyP9/f3pm0fNPRxe4CZ3M+hyu01SqneTrn5L15j+eIOnHQX537C4O3LxEsQaDS5ArlPyZgWTGTj28Vj/5u+aH2soxP10ajamPncDexoflNnd9AUIVe4U0csTcgum+QAHIWA9zmi3vYsMFw7lV/88yM9DjY195aQIltNjrQRM0LrHh9gZ06zKEnXCnhSXZRjCtYkaojPptmECV89rCriU9JG7TDnaTrVFpBnwE2ZjzX9ZWRCC1adW35owgb3yFbSra4CAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dHObtsaVeZR81v3QfzgEjxtPBZ7oU/M33DAdUz7DfQY=;
 b=mu8dI+P0E0/zs6EWwZp4zjusRyHn4zQ9tLWTjhEvouHLSqpg218gcomEsCkFkkWnNt1D1IIJ1CCNsIET+WFn6+EyPe+GpsSwlYzTdn3Vl8Le+N+SjE0B7+R7GqUpVFTWV2D1InGuct901n3LiSYkf2LGCQ7E67FLGJKyAK3MmXd/hgIJJaqULPdoA+pDpq170vgALEKddxBf479/Yd5QJOl+6S+eRY9ZH/4Wiojk4rmPiAF/aoY2eOBQA6pvaLLbuXHNqz3SEVpHN1pPXbu+Mnr8WT2iSCEiKbMuMKJTFT/YeMa/yIhQa6LgAxsRxyX4DzzVyNbC+e4hGODlNuK0eA==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by DM6PR12MB4943.namprd12.prod.outlook.com (2603:10b6:5:1bc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.16; Thu, 8 Feb
 2024 11:13:45 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::444d:2f33:a61b:3225]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::444d:2f33:a61b:3225%3]) with mapi id 15.20.7270.016; Thu, 8 Feb 2024
 11:13:45 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>, Alex Williamson
	<alex.williamson@redhat.com>, Zhi Wang <zhi.wang.linux@gmail.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
	"mst@redhat.com" <mst@redhat.com>, "shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "clg@redhat.com" <clg@redhat.com>,
	"oleksandr@natalenko.name" <oleksandr@natalenko.name>, "K V P, Satyanarayana"
	<satyanarayana.k.v.p@intel.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "brett.creeley@amd.com" <brett.creeley@amd.com>,
	"horms@kernel.org" <horms@kernel.org>, Rahul Rameshbabu
	<rrameshbabu@nvidia.com>, Aniket Agashe <aniketa@nvidia.com>, Neo Jia
	<cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy
 Currid <acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John
 Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, "Anuj Aggarwal
 (SW-GPU)" <anuaggarwal@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH v17 3/3] vfio/nvgrace-gpu: Add vfio pci variant module for
 grace hopper
Thread-Topic: [PATCH v17 3/3] vfio/nvgrace-gpu: Add vfio pci variant module
 for grace hopper
Thread-Index: AQHaWIdUHF93rAkYa0SGXKd0AMy8rLD/eesAgAAPggCAAHxaWIAACBUAgABAhJ8=
Date: Thu, 8 Feb 2024 11:13:45 +0000
Message-ID:
 <SA1PR12MB7199F11211952B27803D7194B0442@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20240205230123.18981-1-ankita@nvidia.com>
	<20240205230123.18981-4-ankita@nvidia.com>
	<20240208003210.000078ba.zhi.wang.linux@gmail.com>
 <20240207162740.1d713cf0.alex.williamson@redhat.com>
 <SA1PR12MB7199A9470EC2562C5BCC2FAFB0442@SA1PR12MB7199.namprd12.prod.outlook.com>
 <BN9PR11MB527640ADE99D92210977E7CA8C442@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To:
 <BN9PR11MB527640ADE99D92210977E7CA8C442@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|DM6PR12MB4943:EE_
x-ms-office365-filtering-correlation-id: fcb854af-e06d-4a06-0195-08dc289703f0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 mvOAPqfDqAYx+2sp7e6XB5PLUjGYJQkHMTODuf5Hgu7WJWameHGPIy1AlzTYssxo80bYgdIj8ignwWK7vYG/v9MIABqCLr80YLdzMq3+QLP74a3JmmOxouijn/vp7RmErzSEBYOvEmZtECc7N2UshBHnckBM9TWMvNQAuKXV158z6brfP/oeyh0pOcDREFIPuyna0qWvLeWsyeTK7vhUBV6rBai+f5lYYY8LZyBFPSRkKOShSSgoeEN2ETIgXYPloodG7WkAvKERVnRWaz007ALEW5RNWUnaMg3BTW7EQXnLKINMo76SEJLekgfOP70zfaEJ/9k+uqKahM7AhGsto+Snkzx5DEmb5hL3X5ifp7N77f+LVxV+cPXsOB59AKOe1+E0kG1IVh2RJrWBx+Hy5d8uYRYwXuEwcXsKPgPfSBgAyjGBBNSoiFboMCuKugCzK/gv9cRtTFYHb+XMVaxq58hpabDnPaEFr1yXhIYt0zlohYDv+BC2A5mBYibTSrp3RUA9xlNgvNy4xlJv+s8QzDZFQg11Iv7v1D5yfiVsyAlo+Fw+F1jqMzVDg320GGR7xTfNI8+N6zKgoIinUK9k8rnvPhBduUHcRVLHeTQsixc=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(136003)(39860400002)(366004)(396003)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(71200400001)(26005)(41300700001)(55016003)(54906003)(38100700002)(38070700009)(316002)(7696005)(9686003)(122000001)(478600001)(6506007)(8936002)(64756008)(91956017)(7416002)(2906002)(33656002)(5660300002)(66476007)(66556008)(66946007)(86362001)(110136005)(8676002)(76116006)(4326008)(4744005)(52536014)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?uzoB5o/jGIcfQymgz67pxQVh7/WBmDU3KixdxvFtjS9XGyhhAtbac2UrTc?=
 =?iso-8859-1?Q?laa2rJqaZRpTfumEg5hminmUZAllK5P3LruDdruzvXu/6ldbX7/dQ7XPBj?=
 =?iso-8859-1?Q?gQ2aEGWEQA+HuqHrXAwGVF6HnEFbDK0ZAr6J4r8krTTuLVEOtK56y2ljG/?=
 =?iso-8859-1?Q?GbaQJcVoxR8AXlM2DIeA5qnhdloOvFT6nIgoCSPi/p/ly1TzZ8VC9u22b+?=
 =?iso-8859-1?Q?bHZODGv0V9weqT+Z+IZKtlV81MwZjP7dC98zzdMplfJa0z91BjP3ZCBzHA?=
 =?iso-8859-1?Q?6oypmudBJzpMVfxA+eMQy67oqcAWb6zK7JEKXVjxuzFaBX6IisVJPJfyC4?=
 =?iso-8859-1?Q?+jly1+IHp5H2qZZ6LdGZh1XjHRujSB1TjoznAoToSRDKPra0SnncnqFf3A?=
 =?iso-8859-1?Q?/p8TJHFBZwpoq2PcEDQWGEfsd7DgvrgNpydoSA9Fue9t148uMm2KNVcn76?=
 =?iso-8859-1?Q?lWluzIykIS+T+ErwKa3IU0zyrqIDyEQOV6nbYufZX0rIqC2FmPl85VGP9Z?=
 =?iso-8859-1?Q?CaXDH/7ymACYSIPr3vZe6eGmmp31BhnXwq/+24hCg+220/LskYHMwdKzyh?=
 =?iso-8859-1?Q?W2QRY4RFg+a3VRW/QxMqHgADwMwm0RVKLqhZRVifUJuiU7g+infw4l4Xr+?=
 =?iso-8859-1?Q?3Yu2SfksndneLhLNl18FNQYqnDjQxjp0VrgtAmeaD7Bf3J/sGR4MZjnJUV?=
 =?iso-8859-1?Q?2wWTkCMqM6gHxIpPjLfC8dsNxO+txFxqweJ/hQYjV1Sg8IbABPfXzSN6/H?=
 =?iso-8859-1?Q?VnX5/gHxIn642X8kWJKs9wMFZ6k+3RaonzNY1sI9ETgqmwpCzfFb8i5BCF?=
 =?iso-8859-1?Q?xg7EHrfEjyBXrNJz5cI606XEotAi+zWLWIxFLpevEoylaFh4Wlu1FRHFHk?=
 =?iso-8859-1?Q?D2mEI311ob5nV/+mdby4nAcWp9njrJR/QdGD+RU6kYpy279iaa8lQ3BLoK?=
 =?iso-8859-1?Q?R6U5H4tDDLaGC6Xr5TzBPjnI1lIHjx3pfFPexQvSlsJsq0HNqnC1q5kX7W?=
 =?iso-8859-1?Q?3LysyJEHolRKod5jOuJzjmWOb/DfkviZLcsd5dmm4zxz0CiHkEreqkwONQ?=
 =?iso-8859-1?Q?YAqH6ALA1HJQSHnv4tfezUuitaoWsCesNswVcK4OoXcWu1MWymsOgcu1r8?=
 =?iso-8859-1?Q?N0Px+dInr+KWkEVgR0o/pQeVB8XsACcpgVXtlwOFB3JlutWhZpYI22VMy/?=
 =?iso-8859-1?Q?NYLsi7LbikJHYsMybJ6LwkIbLpJjmdKUJbpBvNUAE4BE87T6EGlFdfhdEv?=
 =?iso-8859-1?Q?OwmHQG+43ZHr0aD/zLb64XQE1ZwsV0JEttCtQ+GHpcuoAFnvHNznUwrx93?=
 =?iso-8859-1?Q?ldiMMcER+8lWlzphUaRhkRIX++B44dpPPSuu0IH5IyrtQTr0slzwfExHvj?=
 =?iso-8859-1?Q?80djjtntdQbwvkIbLAxY6/H5L5lhhPN5QLsmkDELCiGALWCuJY5mLOzXvu?=
 =?iso-8859-1?Q?guxFKFV023VAjJFiBPBQ1zNY9axKFqd5cdLJIe787nu9UtU4cyZB02VvFX?=
 =?iso-8859-1?Q?v55xuwt0PegBUy7cf/rElBHuXEDPWhM9kTRAnFbUXENt9ZSB48PgTgmgwa?=
 =?iso-8859-1?Q?dppoUcMlzhHW+HsjWZHh25qNmr7aizbQPL8UB+wXpXA8Q/HHnkSDlXRJaf?=
 =?iso-8859-1?Q?m1qwQnBR1gpZs=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: fcb854af-e06d-4a06-0195-08dc289703f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2024 11:13:45.0875
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ehHnZDppmdrBhHCxCBCa5AtwaJLkNh0YLm+d1oTkOq2JShaNDl0gF16F57FPe2yXXkiClTRC4VkXeEeOqvRJOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4943

>> >>=0A=
>> >> If mem_count =3D=3D 0, going through nvgrace_gpu_map_and_read() is no=
t=0A=
>> >> necessary.=0A=
>> >=0A=
>> > Harmless, other than the possibly unnecessary call through to=0A=
>> > nvgrace_gpu_map_device_mem().=A0 Maybe both=0A=
>> nvgrace_gpu_map_and_read()=0A=
>> > and nvgrace_gpu_map_and_write() could conditionally return 0 as their=
=0A=
>> > first operation when !mem_count.=A0 Thanks,=0A=
>> >=0A=
>> >Alex=0A=
>>=0A=
>> IMO, this seems like adding too much code to reduce the call length for =
a=0A=
>> very specific case. If there aren't any strong opinion on this, I'm plan=
ning to=0A=
>> leave this code as it is.=0A=
>=0A=
> a slight difference. if mem_count=3D=3D0 the result should always succeed=
=0A=
> no matter nvgrace_gpu_map_device_mem() succeeds or not. Of course=0A=
> if it fails it's already a big problem probably nobody cares about the su=
btle=0A=
> difference when reading non-exist range.=0A=
>=0A=
> but regarding to readability it's still clearer:=0A=
>=0A=
> if (mem_count)=0A=
>=A0=A0=A0=A0=A0=A0=A0 nvgrace_gpu_map_and_read();=0A=
=0A=
Makes sense. I'll change it.=

