Return-Path: <kvm+bounces-6461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 33A7B832414
	for <lists+kvm@lfdr.de>; Fri, 19 Jan 2024 05:35:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A512E1F22B8B
	for <lists+kvm@lfdr.de>; Fri, 19 Jan 2024 04:35:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 148094A08;
	Fri, 19 Jan 2024 04:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fTFbryR8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2070.outbound.protection.outlook.com [40.107.101.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A411378;
	Fri, 19 Jan 2024 04:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705638912; cv=fail; b=d4Vd2cnaAs4WU59aWspH4Qfu3ay72kcDX6qTrRswt29DoP/SjBRvEMfhrzDtOvH8LzDrNqHljXriD9iCnvtMLuu+UovGFYrH3ndM8etp+nmPNfe8F9d3egWqXGvnMnP0045BmxP0a0JzMzCoYy7Z5AAIpi9zE8vo/O+ekvLO7CE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705638912; c=relaxed/simple;
	bh=cJZCgYlrX4XXnjNpM13bMCiw3VaHcf3IQUywMuxeGpk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Hv01CfyYxFh1luDyIhJPKvEf5e9L2jMQxYD9L0TanbWFOqSeu8QsjZ9NgQabHTdOCpgtoIM5qZKeqomVkCqwjS+/TDi1+J1LXYbTnMHmYza1sKKB1516WxriCYhKDI0xcJS+pDC4Htt6aNsYZABkdQ2bVrFG/Y1lBPbdKuow6iU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fTFbryR8; arc=fail smtp.client-ip=40.107.101.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TzEtgbqP1v4l0GIM6KKLHdTzTYtrcJ+XzBscy/V/czuqsWhL0KCrP+D+NKxEQWPXhRmahodjQhqke+4xCd1HUxWx/HRQ8fVcTip59GtWUfTJEnlYVLOP2icL6jhk5iZDhkoa+CE/Cd/VHv71U6k4nLHu9UEEVl36wihSBCZl2aYk58iriqizeIlPTvx5Qb/Rcy+GXCeaGlhHEbEVPCkmJBdtPUYnxNufYy1Z97s6AdAOJn2zqgLcDlQ6zqkHFWlW9hIpC0Xt7Gb4CbrXtckCcSHMszcDMYiVVbQCPNIHUKtA1j+iSF8UfmlkoVHexhK0nUr6kNaOEN3v3b9VP9zuDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cJZCgYlrX4XXnjNpM13bMCiw3VaHcf3IQUywMuxeGpk=;
 b=RVtolS3O/K1NJ/F772tqQlAkKRFe7DU7bUmypCMdYX+jMMudkG+VGY1X/moHssc3Vh8QZ+h+vt6BEF769cJiopikCyDEkSt5w2lT815gaGpM/bG9A8yedM4MmnIDPqyfSAM0oPAdsJBPP4/gdBM8HtqOtRenuPM1xAsVzF4ByUJS3mHA1Rf2gdg75gkw8mA4liIxDGhIg2Ecvy8PST7NfMg+ThCsQirRssJaxbaPFsJ2mM0UPcS7+Enenc6qNHHqZYf0GbsiQrjkYR0uKqjgvb5NHb5hSHx1wyoFeHlU7udVQqmHWbNbA1yIxV76pHUEAVhxMmPBUgjbhR1oC3RCrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cJZCgYlrX4XXnjNpM13bMCiw3VaHcf3IQUywMuxeGpk=;
 b=fTFbryR8RbZSRlKANM6A+AYiYatqkONlYR1FTK6KEAk74+yf9KSI+cyJtkJv5tq6JHhL58j7skdFmkDWVuWwGasSwkVp//qfpj6CyXOsNY+5k5JvPbPXuULD49GfhWdJzARxtciIY3dnmVEfMvIO1CtHhkpAPBshmMADhlFGVuLsneCXG2JrK5trOYAzaHbqZIPRs4nEohvRX5g3oddPFMkD+drHmZ+g9nA+VJaJ/pJSumKv0b7Ta7OOobfvUsogv6rOdI2NxauaIMqRd22oH2FKd2DPjAp44HG+m3Q4D/tVj7rNW1lPo4CeRqleyTlU7kzMlUJWIuz7Xn1xn1paeA==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by MN2PR12MB4112.namprd12.prod.outlook.com (2603:10b6:208:19a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.24; Fri, 19 Jan
 2024 04:35:07 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::e23f:7791:dfd2:2a2d]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::e23f:7791:dfd2:2a2d%7]) with mapi id 15.20.7202.024; Fri, 19 Jan 2024
 04:35:07 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
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
Subject: Re: [PATCH v16 3/3] vfio/nvgrace-gpu: Add vfio pci variant module for
 grace hopper
Thread-Topic: [PATCH v16 3/3] vfio/nvgrace-gpu: Add vfio pci variant module
 for grace hopper
Thread-Index: AQHaR/gAEOL7lpwjh0CYcImo8660H7Detk6AgAG/dl+AABtv/w==
Date: Fri, 19 Jan 2024 04:35:07 +0000
Message-ID:
 <SA1PR12MB71994FAB7CCB7A39AB4190D4B0702@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20240115211516.635852-1-ankita@nvidia.com>
	<20240115211516.635852-4-ankita@nvidia.com>
 <20240117171311.40583fa7.alex.williamson@redhat.com>
 <SA1PR12MB719904680D5961E6F1806F12B0702@SA1PR12MB7199.namprd12.prod.outlook.com>
In-Reply-To:
 <SA1PR12MB719904680D5961E6F1806F12B0702@SA1PR12MB7199.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|MN2PR12MB4112:EE_
x-ms-office365-filtering-correlation-id: 7174f952-c56b-4c17-012a-08dc18a80364
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 HqAboMPgpSIevEnlmUMFnp0IMWiT/V6KzihUlDdKCt/d4ZWuzkqqsGMWRiKfjLm2kaspItOuduyX5RLzqF7SETwcix9QwDb92h3I/sQYGM1AbUcjk4KLHZizPymlcFc7hqSYjE9bFOX0EKCtlJSfsjDXtj3Yuixn6Q8eJhlM+wg7SQIdlqS4oOWsoMkUzFPAvE6v+VKSu0Jmy0chj3fQ1ttT5qSNdbo8M46XVwkwcoYdIutv75e2hBUotFJSH6veuTJbiBLhuvGxf+W4uaUG1i+riYraB6cUIjZgJJUDXLiRpJI3BwrYYbgdV5TSL8Rl68hwtm3jLPUBTeAHkQLzTTF7WJLtVtQXtFg/6bPiOaVE0FyQ3SwjvohXyJum4hDIK0VHtSLbz6umolZbpfg/tTPHXQ1yBnNMPRYpuPq5h/2IXRFPsezkF+ptIz/XLraeV5fG5o9/SbQ7cxzRsLWhFUkvQqhyr+Jh+ooenKIm2rgwn1qcnYr9EWO2yvcmV4Cn2yrjDK4h3N3EFqQXQ6RtjCkHbGn23TyLOzvZA2CyvAVXISUSnqYA2fAN0xzHHxh/9fwpNkHzdI6c36rSDyuNSbwy2KVg2VYqjl//onHCNYRiIKLkPR4+Cbad2pCBTHE1
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(396003)(346002)(376002)(136003)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(66446008)(66476007)(66946007)(76116006)(66556008)(54906003)(91956017)(6916009)(316002)(2906002)(64756008)(8936002)(52536014)(86362001)(122000001)(4326008)(8676002)(5660300002)(38100700002)(41300700001)(38070700009)(33656002)(478600001)(26005)(55016003)(7696005)(6506007)(4744005)(71200400001)(9686003)(2940100002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?xdXeowlJ3mA1XM6QZAzmG4EVbxbX8UC56Tbc0SICbDTcYvK/oFECLKSnW7?=
 =?iso-8859-1?Q?Y4qFg3Zkbd9jzu7G6c8Um4VXeMQUUWCuRUgp+ZADt6iX0HV7xZxLa4m1VB?=
 =?iso-8859-1?Q?+NhXEoy4QodiiMX83rKYwRMYDSGmH6ynrAVgNxHUK9SUW6FFg9StBnm6Xp?=
 =?iso-8859-1?Q?RuANLnoRL3cQyFojhPFgbtN3A7sslckcwXx78eSF05HJID2hJnTXqBxEYy?=
 =?iso-8859-1?Q?ZZmkt8B5XbQ9XM0tlSUmrWQJtbEA+zutZy0jMNr3csoEU4A5F9oLfpdCv2?=
 =?iso-8859-1?Q?cz8NEQh/zhs4KiV3Ic3NKsYz4K0KpElP0sJtDCbFd0GXsm6Qz/KvvySHd8?=
 =?iso-8859-1?Q?ebP1oNdTi4E7ttulcqzJkDn633guvsB8jkbNlchV7aXmR843eTb9Hmrv3E?=
 =?iso-8859-1?Q?tKYLyx5+8gG4ABrO/yvybrvNvTYSbKJRgSfRqa94z3KUAvIaUT/z7Doesx?=
 =?iso-8859-1?Q?DXhib62+QYuouIBn5ze69QVr8PS5Q4wrjCrerVYP5E7ypBwZBAcPAVEoFk?=
 =?iso-8859-1?Q?9ws1UQQkW9F+RG1tYW9ONR0ua5Ma4RNALHSFQcovc2dJQoYO1wOxG9ELyV?=
 =?iso-8859-1?Q?3/I3WtE6eJB1CABhoZIj2qJKGFnavvyztF/5hUddvXDOgJ1JqkRWVmfeN5?=
 =?iso-8859-1?Q?zSiUcRvNRDpM9ZYoBKWphqc+WxVh66P8M9dDMxqSgsgZUne0nvfjIHSCdH?=
 =?iso-8859-1?Q?zVv7cneP1xkI6cyTAR3SXBF6MYfcGLCaSyTAxMx9wm9viLGQ9jd8gEIaq3?=
 =?iso-8859-1?Q?hIAmdvzLen9bPy782szOWKDOqEaRZ/sNnWz8UyADOkX2p6tzOhieNxuU4S?=
 =?iso-8859-1?Q?Vy53cfu8mn5gEWtb5fNal/GhoEUem0kR+otYkEyrXu2Q9XVf0IMYGZ7lM1?=
 =?iso-8859-1?Q?JsM5ydT8h/k2ocPk1gusu0Nbi4bIxy+0obH1rWxj7praQ8i3qPOr4PFnWt?=
 =?iso-8859-1?Q?1H5KbKFCNCGR+db4bvcHxxbXldJAjh7WQU6o0MJwuTTt+ihdw/D8NewDso?=
 =?iso-8859-1?Q?Bful2yC9ibmYFXTB6X3LJa81wNnAEcU9+J0elI/RmFysTA1uVBTkeIWlcp?=
 =?iso-8859-1?Q?PTXJlx4pd7w0qVFsTaU+M+V/sqRc67Ec2LJGTFxkYf9Z2vioGmSze9K5GM?=
 =?iso-8859-1?Q?6WkXZHUiYRz1qEia2nGbJRxPnPAnUxHpTJLs5qwexjQZViyLntSEQcKmyW?=
 =?iso-8859-1?Q?2FXOqYoIiulBrEgpObtSULmdgdpiJtjp0huguFCqnZ7zrAXIc76v368AHD?=
 =?iso-8859-1?Q?1SmY5JXDzMZ/GnIlN98H7sN3kM+dd2ldQF8iljvZwvTjjjNnKXWenooktz?=
 =?iso-8859-1?Q?Yzdr0PHfKHHHfFQ7/XqEglCiB9nv82NaACHAWfPnJbKBTwrXjjtmg9GwYJ?=
 =?iso-8859-1?Q?xzng/8XhO7tDYpCPCWqTnRH5LdiaoF2lDlwld4sljh54Ct4oa6prUmEq2X?=
 =?iso-8859-1?Q?wDniLHA2mBtqE8/vhI60r4iWLAE1wm861J+A4duMzCphP5i8YlSkGNueTD?=
 =?iso-8859-1?Q?KjuVENfHiNMdYcimNJPTTcqcRqEBYWcPcdLqzczmUII/wEN8ZxTzyG7L1j?=
 =?iso-8859-1?Q?sQrdW8Dr2AnKmGrYFgITMRG9umYtptvFlYR0LOua29HnN+GwqlpRmRmNDT?=
 =?iso-8859-1?Q?a3GEd4l4j2408=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 7174f952-c56b-4c17-012a-08dc18a80364
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2024 04:35:07.0173
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: icaBPQjNCywg3c9X6c4lenHnxi+HQKzZk0Hl3QlZlaQaB+/2D+a0QcqppqwSZbEYUztUKXeXKyFfMsvJVKvddw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4112

>>> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>=0A=
>>> Signed-off-by: Aniket Agashe <aniketa@nvidia.com>=0A=
>>> Tested-by: Ankit Agrawal <ankita@nvidia.com>=0A=
>>=0A=
>> Dunno about others, but I sure hope and assume the author tests ;)=0A=
>> Sometimes I'm proven wrong.=0A=
>=0A=
> Yeah, does not hurt to keep it then I suppose. :)=0A=
=0A=
Sorry I misread the comment. I'll remove the Tested-by as it is=0A=
redundant with Signed-off-by.=

