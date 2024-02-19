Return-Path: <kvm+bounces-9001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B28EE859B26
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 04:49:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6995628222A
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 03:49:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7498679D1;
	Mon, 19 Feb 2024 03:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ri+vjoFz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2053.outbound.protection.outlook.com [40.107.93.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DB14417;
	Mon, 19 Feb 2024 03:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708314573; cv=fail; b=Cq21uigF7vQab6aw8WJBofGtOtgOmph4iE/z18l2vYzCs0blzFFctEBPL0eURQX9tzThx8cZObMTNFwH4BNIY52Q9u5lw/ds/X4aLcm0cavd3c3HRu0S23acpge8WSjDmHbK0AJr++Ca1mj9IbhQjCQpfI9zvvanebAshbvverQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708314573; c=relaxed/simple;
	bh=+Z+AnzbTHkHZdoN0lcp7WLea7TcuTNe7XhrDOODLCIA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UPlrzuyVHniCmWbylHBVXpZGCgYjpijcxN2TloBDEriwRsaJx/Jj2h0MUurytJXoXYDtkbNiz8lg+Nbp/5RTNED8XpLAszmzejiFN+GdQxu8BrqC21BvBnqfO1qVzUpN5TaYDZsPSqBjTU7n7n5PnNVUei17v30DfMZ8Z2E/X6Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ri+vjoFz; arc=fail smtp.client-ip=40.107.93.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LFGrQL7Q976576SdqW6czgZHdQG3CcN4JkCScp8ltWaOJeJEAmTIL1ykezkkcHs2/yPiVvpIvD+sOuL8PdP7sAA3paudMYowPTBXbCdfXHz3i3g8qHEIAyKpUtb1Qtkpc1D1444uVJ9jSqufPCdaLIvA21w2ReSUOsHUfySelsI6vCInho0WjoliLrTHAKXeLu0ackX+PyU6TNs72+4jx4kAipkbtOG+xbpJmMsi9JHDeaqXky7w9suwrVE4hYBWOoLXjhakHo/u/mzQHtj7QzBnwGoksHDM0zEK1culNxSZjXUh+eKZGGDW0fQ9wauMHyi7bV7ZTc9WSblDuFPj2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Z+AnzbTHkHZdoN0lcp7WLea7TcuTNe7XhrDOODLCIA=;
 b=KSegU2MZCjlx0eRGPvJD1K1k73jPnFtvacbYH5XsF6v6bE3gQIum619o+KI8MO4HZn4uBYlTnGm0o6BeRWTKx1ZPaT/DelfC9nlLB7HHSBpaHsH+GnjsLAhHacpFR7/SXDwosXLJ+6BDPdGEW5Cq/4sXIzCZD6DZWMH2v8EpoNS/t/6+Tzp1AcYNOL6KGsuGDddqFa1QQq3i9DjM3keSm80EGLlwZ9fKSsfzviA/0Jfmf1NSZE2Y2AcOVrjte77dCs1VYJjgNI9wkqi9slOVSZWJFuacowkMKcBXAU4PXyWfwO7zH7VDhg1FR+t94MzPMD6VM7YKgVAzJF8fwWv6VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Z+AnzbTHkHZdoN0lcp7WLea7TcuTNe7XhrDOODLCIA=;
 b=ri+vjoFzdb89HtOOtPKhuxv23T7bOwLmMsTxoceRP2C/TtFS8NIuvsYx/6Abx7x108ICDAtuUwMhDljm5INtTXYGkElIdDuiP1P06xBFq8Wk3ZKRuWixl+zzy8I9NR7GkavKiHMWtin+7MXrTzb9yau7mOenq5qIZUz1rUK0Qeo+Uw69/Y4bOkzg7B4yj1Yt19MJtUvvduIibY+NcHEq1pXMXuiRd2ifDYAmz59X84yn4dtbp18+RDVgWxKQdk8vxm7Yt+usFEWab98/S0H6uDuMckHfH1+gk8YFe1BnexLFJhoFmAkmpVFmGygd4Xaz2m/jPc+vv8rSeVcY37dcrA==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by DS0PR12MB8247.namprd12.prod.outlook.com (2603:10b6:8:f5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.19; Mon, 19 Feb
 2024 03:49:29 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::284c:211f:16dc:f7b2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::284c:211f:16dc:f7b2%5]) with mapi id 15.20.7316.016; Mon, 19 Feb 2024
 03:49:29 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Yishai Hadas <yishaih@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, "mst@redhat.com" <mst@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "jgg@ziepe.ca"
	<jgg@ziepe.ca>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>,
	"clg@redhat.com" <clg@redhat.com>, "satyanarayana.k.v.p@intel.com"
	<satyanarayana.k.v.p@intel.com>, "brett.creeley@amd.com"
	<brett.creeley@amd.com>, "horms@kernel.org" <horms@kernel.org>,
	"shannon.nelson@amd.com" <shannon.nelson@amd.com>
CC: Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti
 Wankhede <kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)"
	<targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy Currid
	<acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John Hubbard
	<jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, "Anuj Aggarwal
 (SW-GPU)" <anuaggarwal@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH v18 2/3] vfio/pci: rename and export range_intersect_range
Thread-Topic: [PATCH v18 2/3] vfio/pci: rename and export
 range_intersect_range
Thread-Index: AQHaYISFTIU6tqO1s0iZtuf3G8SCFLEQBP+AgAEG3Ew=
Date: Mon, 19 Feb 2024 03:49:29 +0000
Message-ID:
 <SA1PR12MB7199A58155EE789213139227B0512@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20240216030128.29154-1-ankita@nvidia.com>
 <20240216030128.29154-3-ankita@nvidia.com>
 <f5328e6f-170c-4984-9a5d-e81761fed8b1@nvidia.com>
In-Reply-To: <f5328e6f-170c-4984-9a5d-e81761fed8b1@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|DS0PR12MB8247:EE_
x-ms-office365-filtering-correlation-id: f071736d-629e-4449-0e3b-08dc30fdc646
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 Wh3y2B8O9shTyk+VjtpZ4wyMY9aWshQRii+bFsmu46OISSlOHjob2b6ebUiYOvHr7HiEmCZ4gbDF56Hvidyw7eOMWExTloKeVngI2xzXQEa4XVN5UIoK+GhWhdbSPyw1L1ITJxORoo+WYx5npHAdt/a2G9cNapg2rO+xLFeslvaa0PJ44a6QqhSTby2bEuunguoXCRMaIRfSc9CDQqxtU5nzLhOLYZmppEIU+7n0FXf9PiZwd+Mrkp8N44CtGkevlqAL8pgOas/N3GxF1we4iK3MvHz7VbuC4xUhRXBr605yZP5I5VLOV6cuhVwRWQ6XkRAun/1ZnN0qypbcjkLihCHpG+s6remlLC/pmHLXtyOCQyd7q41yPI5o6dZgCma1VLwCmYv2Uf7tNPCJokZk+7Dd/Pvz4T/ykU5bCrV4xnny5ED+ssuh8kv5VIcmbihrzyq0+6LYmVrk9eTJa85WuL6DUO+5Mgvh38DZv/62dOzRUvA+9vWP9Nh3j6jFNAqxfekNTFF5rq7bXuyaMLO+dRCgC2QcMqQaDW+9Q+WssF+b406Wlh0azD7UP1mqjjS2HpsrSQnjNI1N7qaz1MT4YI97oxW31geK08pidc0zu+lzkTBsax+laiOyR55L84np
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(366004)(346002)(396003)(39860400002)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(55016003)(5660300002)(8676002)(66476007)(91956017)(76116006)(66946007)(64756008)(8936002)(66446008)(52536014)(66556008)(4744005)(2906002)(7416002)(4326008)(110136005)(71200400001)(54906003)(38070700009)(316002)(9686003)(6506007)(7696005)(478600001)(26005)(921011)(33656002)(86362001)(122000001)(38100700002)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?qW1yNzHzkeFJWIrUA7T4LH4f8euWlCP6VzZrzZotct9ah1yneK6B9tAIWf?=
 =?iso-8859-1?Q?t2cg0DACiBFDfK36G2SserZLcPX8uqwbutiExNY7GbsP2+9PgAEb1GSQet?=
 =?iso-8859-1?Q?kG8x1tEhf+uPyJ1NZ0zpWiB59qe24pHuX8o1xtq0yg6tJbz9zrHKgiOSHb?=
 =?iso-8859-1?Q?MWdaZSBWm/r3FQl+ab3iCnGPd14xj79tng4wdsOLgYdLJZ89EAVNIOxkzy?=
 =?iso-8859-1?Q?iywETM7sDJI6FnFvlgPvdIaxuFoOsOLDc2b2j6gpyYd1jBQPiQH+TcUX82?=
 =?iso-8859-1?Q?1wg/++S2ekPCUbJkOdGmpsDQ2Oxud0oN8ZoBwIAGGqJgmRo0O6V1FuvYor?=
 =?iso-8859-1?Q?MzHy+S0keKc8N3A9cti4AzSFzO5dTAPGvquj5fCsL41mZcUx9tPBbwz8gC?=
 =?iso-8859-1?Q?o6LvDdYYDHdAlol9oamKNmmXuqLG4uRQHAvQpmWbrFUoshaA9XkFoubqam?=
 =?iso-8859-1?Q?CNkxv6CTkbzybYr/EwWFUVbG9CjZ2fQe0ckd0los9FuRfH6Ay2OEBRY2+9?=
 =?iso-8859-1?Q?QaPj1rmTDngmxFjTHfMdiGmW80v+CWgSLtBJTsB93nAiwrhJYfaZjHlvJ4?=
 =?iso-8859-1?Q?JifR/fYmTEqF7kn6TcmTiOKcFwifcmfNdpKxz8u8WzoEFVu5UO1WT8ji1w?=
 =?iso-8859-1?Q?LkLnVYLGP8UXSD27E+c0ZqhYmdkiI45Tp01j4q96lzoc87KvGxFfdkXo7s?=
 =?iso-8859-1?Q?gTnrPOOy40pDLXw8NYbN10QnfrK0mtUWSlychgwSO/+M4+hAbxxvk/hbsn?=
 =?iso-8859-1?Q?wf2xqGWQF/dmV74Rk/rua47nbnntjHc3Nxgm37gSX3NLFJg/ULbYfbdPtw?=
 =?iso-8859-1?Q?N4RIAhrZPi53bx5uaib8w+BeSuXgLEF9QRryvhJn/KZYGTGSbQOyHOxqBS?=
 =?iso-8859-1?Q?z4KQBJg+YEU9UHkCdq7VbWApYleRjt+LjsxQTSVJiMEBbj4XZpuiq2Ri1o?=
 =?iso-8859-1?Q?hN6q3QqYFtgjjTjqUuAF+Bn+52n9XpgOkZ9xSheWIF755TkQpElHs83weg?=
 =?iso-8859-1?Q?uZhGYcgIqZFO0XGtlg7oZ/hE+7E6BOyn0Qaoa6NM/xqe2Sr7J+FaXylkZJ?=
 =?iso-8859-1?Q?oYnGGoQJPKbXvpvMQbiZRCk02zc4zqRT+z0P6b027ZObhCTZUinE1bbHRF?=
 =?iso-8859-1?Q?riqGAq2QpZkb6H1SYelgNhwahneHAYKsQhnYHjebVU4w/uJgpr5UjyJzG0?=
 =?iso-8859-1?Q?AiO8k0dNBIhTGv4yDE4bazVbUmV2BG6N/zBKGaQHB7+wHYTcW+k4ucuode?=
 =?iso-8859-1?Q?zTL5llR+GYQgkhC1NpyFd8cxg/2WjlfoQwEfDmrio8BZC1NBGFDeHzOrIR?=
 =?iso-8859-1?Q?F9CXx4gVQVzRQtEW8yOhYXFiqIuoH8QfSPP5GZw9yTUXfU5+ge/Y5FXnOO?=
 =?iso-8859-1?Q?RFQMSVmXo4m/OEfmlSRCgWwn78c+jc/0HRZBDxurVoMclH7yG4LIoYXY8Y?=
 =?iso-8859-1?Q?ajbGja9W7KD60Ix6pSZebU3AKWlOb+Oi1i1aXB73m0XdIHbNsipFFTq+qy?=
 =?iso-8859-1?Q?swETCuxpZJKrRIwHyxalZq2EZ4gK3NLdmK8GLVcGItlBV3jPbWR4GnD3zL?=
 =?iso-8859-1?Q?oaloHZrKbbMI4ndPrVTxbT1HfNqnkEuwdO8G8sLVI10MQElTEfKlZcclH9?=
 =?iso-8859-1?Q?tyT9NBZGS+45Y=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f071736d-629e-4449-0e3b-08dc30fdc646
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2024 03:49:29.0916
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kIJZUBvUzVintv3WAfg59rvk/xXBJ4cmqM09F2axPMR/bxohJbvllR820A+HSPHawn3pYXlkmmTrivuvmcuEBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8247

>> +=0A=
>> +/**=0A=
>> + * vfio_pci_core_range_intersect_range() - Determine overlap between a =
buffer=0A=
>> + *=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 and register offset ranges.=0A=
>> + * @buf_start:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 start offset o=
f the buffer=0A=
>> + * @buf_cnt:=A0=A0=A0=A0=A0=A0=A0=A0 number of buffer bytes.=0A=
>=0A=
> You could drop the '.' at the end to be consistent with the other.=0A=
=0A=
Ok, will make it consistent.=0A=
=0A=
>> +bool vfio_pci_core_range_intersect_range(loff_t buf_start, size_t buf_c=
nt,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 loff_t reg_start, size_t reg_cnt=
,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 loff_t *buf_offset,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 size_t *intersect_count,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 size_t *register_offset);=0A=
>>=A0=A0 #define VFIO_IOWRITE_DECLATION(size) \=0A=
>>=A0=A0 int vfio_pci_core_iowrite##size(struct vfio_pci_core_device *vdev,=
=A0 \=0A=
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 boo=
l test_mem, u##size val, void __iomem *io);=0A=
>=0A=
> Reviewed-by: Yishai Hadas <yishaih@nvidia.com>=0A=
=0A=
Thanks=

