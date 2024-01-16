Return-Path: <kvm+bounces-6310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2101482E94F
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 06:59:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4675A285563
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 05:59:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A11310A01;
	Tue, 16 Jan 2024 05:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NMkkKK01"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3F3E553;
	Tue, 16 Jan 2024 05:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CDLKKz9pNITrMIPa+2VyDISpVSnkRjB51uzJTmpdUpDg0c7Ve3ZHpkEwXRpd8i4Q40d85vIV/1aIbdFKxZr21l/fpe1hwKl6kYwTXxB6FqD/JMktbgq3bR//Ii758Zzl/aDCSCZFaXyR3y8jO/2om0wBm+/728ErCVlBKK51aVs/GfXR5U+hu6MmiX8JYbcf9eFZhvamcvxacYnfOMQtwVQgs7LhoqTdAfPz+MeYAS4ZcaolRX5g6DjTTFKNZq9mW62PN9CdU5KFMBRM5jEt7yQDyULFxO3qAsAOPuSGK3Yx7k0pSY6Z5ovdyakf2clDV/3hKbbqLQX5eUwAOK7xzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pC8/3/nbXXUfFM0vZHae5VQ44SB8Ier6yIW32iWXTLo=;
 b=QmOXtpHVKLBKm8WUCBnWmkNuh2tV/ndSoGnt00ZiHH533ZgJu/Ke3uIT5LT+zl0LTVyCbKIpSe5gTMCQT5WJURerDkuXe+OcA7Mo2xCUj4SzFPjCjlPBOiZ9l4iposJdzVH0L7FmvvENvxvEXJ5mLBCzx170KNGTD0jQwwWGAMKF+13Z1vLgT9Ay1E/zYFpiNHkSVfRRYyO/9CP2IMgJjIUZyhC1bNGyW5tBa6tRnr81K4qD3pL/Nq0be72xbMq7sEJoLVFlcQYogR6q79hmwQ9kAjVF04PFimz1GOr1lpxQGeWHl2Z0w9HAyVTme9lUy0sPItEheyx2rac8c4PeQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pC8/3/nbXXUfFM0vZHae5VQ44SB8Ier6yIW32iWXTLo=;
 b=NMkkKK01bvWW5vJSr98V551dsBxqczkf0bZySTVsRaqLETFWisl8d9OZWag3lQesQ6hgMH2t/HQsRrr5+f2LLaYaI+bXMOkQXpzrDogPb84HdoUBHVlUdOI4r/BwL/NWw1VsUbMflU2y0ib12Air1Z95tFtYa9/NI3zqVisWnYXyHMwT+Y+WCw6zBcDAHAAq0dHwnlbCd9kP9VtiKv0tm8EygApgbxjaAKJCv+g0r97tqOtjNTPPTzgfrBx7C7LpsQMazJA8DSX1z4lkiu9CRuBgf3OSw/zAV7l7Y1JlYM5Xo6atqqvIaedJKsNUnymekw6lBDdE/iff5s0REw05tg==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by DS0PR12MB6462.namprd12.prod.outlook.com (2603:10b6:8:c6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.17; Tue, 16 Jan
 2024 05:58:53 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::e23f:7791:dfd2:2a2d]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::e23f:7791:dfd2:2a2d%7]) with mapi id 15.20.7181.022; Tue, 16 Jan 2024
 05:58:53 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Rahul Rameshbabu <rrameshbabu@nvidia.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, Yishai Hadas <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>,
	"brett.creeley@amd.com" <brett.creeley@amd.com>, "horms@kernel.org"
	<horms@kernel.org>, Aniket Agashe <aniketa@nvidia.com>, Neo Jia
	<cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy
 Currid <acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John
 Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, "Anuj Aggarwal
 (SW-GPU)" <anuaggarwal@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v16 2/3] vfio/pci: implement range_intesect_range to
 determine range overlap
Thread-Topic: [PATCH v16 2/3] vfio/pci: implement range_intesect_range to
 determine range overlap
Thread-Index: AQHaR/f+hq/WnUlfoUWt4169ze8Rb7Db5z2AgAAKxGQ=
Date: Tue, 16 Jan 2024 05:58:53 +0000
Message-ID:
 <SA1PR12MB7199C84CE3DD81F17E8A03E0B0732@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20240115211516.635852-1-ankita@nvidia.com>
 <20240115211516.635852-3-ankita@nvidia.com> <871qahzw8m.fsf@nvidia.com>
In-Reply-To: <871qahzw8m.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|DS0PR12MB6462:EE_
x-ms-office365-filtering-correlation-id: 5d26d8b7-4294-49ca-1f7b-08dc165837fc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 KjD6ZjhIx5Bq30fZNuPxPh4ouBGMxIzPoGRrcoEgwOE1exiO6m0FTE4wj1uV9IkdDYi7RH/PKVhAvY3O/NqMK77dV1ujvgpAVqrdPv0MiDWNl5NRgL2t3sCIbnbUF1gS87kwkSK8aywkYquWoHWkyBl2i2awxSRX+0e5w1bETgk74MuJ72ZDX+p9ttdqK6zo4syFnt9yN6hqOCiUbKIJnRuyLUlb6C9jSYYzdz/P931xKZibKIrVVZ34lY4DbT2tDPSd8MbwVuwZpXMK/FHXhrCqzL+59T7DtVHsSIduYN2pU1P41Ceyi1CPh203TBvJRAJy32yzwVh1zovKF/oxn4om+txkotvhHHVIfv9S9PIe6h4BWiVG6urvOb0mQkNAfSTDaiKbysiHiNaYpDQsWkoORT2WkUB4X7V/r2YT5WL2e3+zo5+mC2OkJZiZ5dozhK06f6wM6K5sri4K0U1VaFplZyMGxEW3hyB7K5GuX27Nv9aSucHm9nqbYjQdEVIxkh6vJcP1jbZgEjwcuqig5IEuQ3pzImTRaMzwuMmqWbeAGEWLLXv7kMJ0NkGTFVYwN173SMUAi6pywnYwrB6c/aKbG06O4L6XVg6+5Ol/qeBGaIFHf00y4Ij1zpemQaN/
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(366004)(376002)(346002)(39860400002)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(71200400001)(26005)(7696005)(478600001)(9686003)(6506007)(91956017)(76116006)(4744005)(5660300002)(41300700001)(2906002)(4326008)(66446008)(66556008)(66946007)(52536014)(6862004)(54906003)(64756008)(6636002)(8936002)(316002)(66476007)(8676002)(86362001)(38100700002)(38070700009)(122000001)(33656002)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?NWnxVsd9a2O7bjAEdTutyis+J5quu5K5pd4baDU9g5SdvSajvLi/iK1TEC?=
 =?iso-8859-1?Q?kXmKP037PoDezabrPtlo19NXL8mjF/9IUPYOYy/Xc/lFXxX99w7NsL89b9?=
 =?iso-8859-1?Q?0eIbYfxFeTIEiM7dJW8K0jg5KviuwFRLfgT+b6xIB9F45DIvjuaIPKeez2?=
 =?iso-8859-1?Q?tSZ+R6JNNPK7zMT8jbBDuW+W5AcbzJHNoefKqW3S1dZ7OCUXjgvMz3ZwUr?=
 =?iso-8859-1?Q?mQiAO/zKF/Q+mIJVJDqvwCD7tqLketDqsGdqmDlqz0/e5PVNDHRp1mrIda?=
 =?iso-8859-1?Q?S4M58O++dc3Zbv5WGSxKkJ8tHHCA9SXr1Ud2kAo6LIwrY0P3Qoy4L7VBJA?=
 =?iso-8859-1?Q?PM6zGei3/yK61PShJLTgZM49+zcyppg3olDXULxzO48eciw+LpZk5vAldE?=
 =?iso-8859-1?Q?vyinWrCU0XbBJ5CUEdxD1qkzEeWAN2u04J5BGz0WgeP2tmvne+jujW4UeD?=
 =?iso-8859-1?Q?s5Ewn00narx+LTvojx7gzlDh7IVrrDZ1fVGbcBa2n+kRm+wWUE0ojNVvwx?=
 =?iso-8859-1?Q?dks8o367oTHRSVpvc8V4NUjY9JNHSi3FvoGm7++aK1QjuC2+hUPtG1T8Ci?=
 =?iso-8859-1?Q?Rw6th60odaODPAPiCmI8i5nxqi0PWRyQwPvh4vg7OhBDnCB17ObqaxIA75?=
 =?iso-8859-1?Q?i9O6TYfTV0KkkgEaHxWkfiGBTJAuMcFDGPdmxvSA/knJHtZzWfjVuWhWvm?=
 =?iso-8859-1?Q?ztF/BhUYl7GFDJ9BzmgR0e3wrQaVM+PoZofjo7jZ/OLw6y8dyCnVwBWeI6?=
 =?iso-8859-1?Q?v5R6DICTtzYSD2Dmp86n60JnP+6/vgjYnQ0k/7UYcZwNZ0IZ26JX0m+paq?=
 =?iso-8859-1?Q?bgp0iSyCLkfZazdS3+rBHHWt1W9821eQf6Q0d6MyV8eLynakD7rlWvh/+G?=
 =?iso-8859-1?Q?kUT3T1512r2ggkSkh7+ZGvAdSagKxb+h4GUJUW7X3EkTLK0ZEK156N1aw5?=
 =?iso-8859-1?Q?2xatT6ignMKgLRE8C4flrDuKgKItDmkruxOHPMPsYeUOyeT48ezE82kj6r?=
 =?iso-8859-1?Q?PegBbo/tk/Vs75TLhmQeEP3wtYSIsxwo/Hx//MY/NOF9sDaSs7MuiuJ00d?=
 =?iso-8859-1?Q?eKD2enk5QnT1Vny20mQGNzY/NKiCOb6E7++CS+NalaOINxVd+idhiAgxqR?=
 =?iso-8859-1?Q?X1G5dymNR5CAEklJps5n450iGjKu/kXjzjwhJcnyxSv9iTtojXFHEXEWJU?=
 =?iso-8859-1?Q?O9zn5DYiTRKUquDhgnk6Ou6Tamvc0JEN0Y8jxM835Y9B81qTt82HdDtubE?=
 =?iso-8859-1?Q?e0Bd7+7AO/aE0U9G8sMfPEOiFzqHcZTzBn0EnHcBOqD61QEsfgU7fh9D+w?=
 =?iso-8859-1?Q?4mpoLGTMoWxV2ZuCyPc5li/3rYt/TTjvllPM/Kg7XNQMxfhI/lpXcbQB3v?=
 =?iso-8859-1?Q?+a5dBrZH2AoHGcb9s2cIbjS6e9gi9zJt7wX71SkgB5h3O8D/xBSCPeRGPy?=
 =?iso-8859-1?Q?QU6c04D3bUcM5e+UQZvIHov61EzeT7GZ5XvynwVI1H05IRCWYKZCXmHO+y?=
 =?iso-8859-1?Q?p9nQLtLDwGMnvtpS6hpu+uueZK4zsmQ0AtwAevjZ2CeJOB2GZhP7oxZjAG?=
 =?iso-8859-1?Q?0ifTs7iG4iD7ltg1eE8hqOQdSFR+dNlbOmtEAhYkxEKndeyWpFTPe9gU6X?=
 =?iso-8859-1?Q?3U9ueEcDeQMkM=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d26d8b7-4294-49ca-1f7b-08dc165837fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2024 05:58:53.1788
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pq3wqHUdNr1RtTWCnpoh8QZxAAen8XlrJ+JzoWE2XET6WfUSPmZt/69XxQh00w8caOAzqy0lbX0M77E5++lkCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6462

>> +}=0A=
>> +EXPORT_SYMBOL_GPL(range_intersect_range);=0A=
>=0A=
> If this function is being exported, shouldn't the function name follow=0A=
> the pattern of having the vfio_pci_core_* prefix like the rest of the=0A=
> symbols exported in this file. Something like=0A=
> vfio_pci_core_range_intersect_range?=0A=
=0A=
Yes, that would be apt. Will make the change.=

