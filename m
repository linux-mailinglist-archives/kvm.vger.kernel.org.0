Return-Path: <kvm+bounces-8298-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0236084DA93
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 08:13:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6DA5AB23EB8
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 07:13:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EFED69319;
	Thu,  8 Feb 2024 07:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LHlLSOcA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2046.outbound.protection.outlook.com [40.107.243.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF6D692EE;
	Thu,  8 Feb 2024 07:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707376382; cv=fail; b=Osy/dzKX3psuFXMFquVYPVKE7jocUkODnm9/3hwFYkWRBq+/K4Gha5zDUgZtO8NdANXuC7OmNLHvd8OSD/xNJRwk4K7iDub3dmlvlKGQgbCwGBlSVQh7i7CVNebrVMAGZ3FUPf/V3nHrVk+umqdUieSo1A4tR3IIwXMv43GKvsE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707376382; c=relaxed/simple;
	bh=VdUraDt8pHxtYbBYW8uy1h2bSp0nbNpOrZ98V8LFKBk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Nw0VBjxSuPl7HhGRRxXYKxIr2+GKpf4JoYlfQTWGuPOoZdGU2MuMA9Pfffh9ciwA1ZGu+4fM5YLXpnPWBRPXFhaZKNmxhScD5HF1kXm0yMkX852mFYtgOrvsBAU+LgwxfaZLKsRNA5/vbvSn0AInUx+tr8yn3njmDyTFUHTKmQk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LHlLSOcA; arc=fail smtp.client-ip=40.107.243.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O+Wpzpwf2t7k1sEoXICx6r7eSlqr3FeUmCTzP8G4hIfJar9U2xeMBcwqh6ssVT8dxX2Jxt+sM8W4c63BOdB7WfsbIX3M1t0BkQWpP2xVl84N5+sb3JZzBZNN+P9YZT15+SKpjYA69lA+T6knzFu01zFynzHn9ePHb5NODBcxjpM1mTeWUmqV7avPa5cQtiKyXhEC7f+dit1FdyOUapHwyK4WOyi4VD3LZAHTYhXi1H9I/fCHCUbBpvajasVcHisQkIfFxDeH8Ru8S3logoyFqfut4T7SpW/IvPucmQldXi44qXscuCwzqvSosDyvqG437fuUIF7/i+HAh/BJeouIeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VdUraDt8pHxtYbBYW8uy1h2bSp0nbNpOrZ98V8LFKBk=;
 b=XW6IWvkVTIbIKQGjau4Q2c52EWSdsGR/6MwblyFC0M3T/VXTA5l/piwXJloohem94V60+zGZyBMhk38mgoly82zTbRUGjIDrlNy6PzrnrSVGFdFH3tctlGKrluRnuVf2jQifNThXNklrKX7THbpwEOeyZjvw0WvGCANAJpbgTx6QlgcLNjXpDGg03LJ/0DghFQ4Jw7/2tup6yD4/4eyZSIPGvHs3fAlsC6RV2icCrwrYFxqAwJMG3UB59rBhxCL/GCYOVKRJzw5IxK8JuKTbWQp8/37jhgq97H5TuGlK1ASecsiCRLCrw/4rrDMzg0HOo1TOi6v5lIyOYJ2KVWEfsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VdUraDt8pHxtYbBYW8uy1h2bSp0nbNpOrZ98V8LFKBk=;
 b=LHlLSOcA7x6SziiwxE/k+HHbBXcoTJlHowPSq0rpHchqfCL2LHadhR5NLl6CTgkWxB9tfxJ6wyvypVd+qQXcz9Ya6Uv34A3UvhNf/0CBxImErD3azJuP14TXCvQl/xDlbgSY8fVCarv4XnadCESlTTxzpG1ibjIalQZWn0WKZ4yxnmzgQ8a27aCuu9Tx10CKs188HKkqurlfPqqiuQpk+HsYYFa5/9uZLTeNxrFhblZ683SR5tFiEZhw+a1cDpL7rVpAEq5dwavDgmqMPRdH+Ri/3e1rLVgpR8mqYLuiigil4N5rC+/r1pweTU1LQ7yUncs28Rz73cJnKdR6kFD+Kg==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by BY5PR12MB4951.namprd12.prod.outlook.com (2603:10b6:a03:1d2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.17; Thu, 8 Feb
 2024 07:12:57 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::444d:2f33:a61b:3225]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::444d:2f33:a61b:3225%3]) with mapi id 15.20.7270.016; Thu, 8 Feb 2024
 07:12:57 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>, Zhi Wang
	<zhi.wang.linux@gmail.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
	"mst@redhat.com" <mst@redhat.com>, "shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, "clg@redhat.com" <clg@redhat.com>,
	"oleksandr@natalenko.name" <oleksandr@natalenko.name>,
	"satyanarayana.k.v.p@intel.com" <satyanarayana.k.v.p@intel.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "brett.creeley@amd.com"
	<brett.creeley@amd.com>, "horms@kernel.org" <horms@kernel.org>, Rahul
 Rameshbabu <rrameshbabu@nvidia.com>, Aniket Agashe <aniketa@nvidia.com>, Neo
 Jia <cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
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
Thread-Index: AQHaWIdUHF93rAkYa0SGXKd0AMy8rLD/eesAgAAPggCAAHxaWA==
Date: Thu, 8 Feb 2024 07:12:57 +0000
Message-ID:
 <SA1PR12MB7199A9470EC2562C5BCC2FAFB0442@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20240205230123.18981-1-ankita@nvidia.com>
	<20240205230123.18981-4-ankita@nvidia.com>
	<20240208003210.000078ba.zhi.wang.linux@gmail.com>
 <20240207162740.1d713cf0.alex.williamson@redhat.com>
In-Reply-To: <20240207162740.1d713cf0.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|BY5PR12MB4951:EE_
x-ms-office365-filtering-correlation-id: abeb4aaf-5af0-453e-a1a9-08dc2875603c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 RVRvaMrU7qTgPtsxSNrNc30Ts6fbgEEfK0qxVTz8Mte9PFH97ZizZPW990LN+/9smDxLyLitzJ7sRQ5ztbyC4uX9IPl54eppk6zaGG/NuM5NnXLeTlL2keD1jeAbccFxIuXH+ykqs9yfdqIBvodOl7sFssgRwuxC+t/RifQPHeiNyY0W5hN9uiPUvVxcTmGfc6nHx58PoLmhHnnp9g71LMSFVM3Am81Tf0+wifTfr+ZIbucs1+7mzt8AwJI64CUY5ipV7SckNAagpR2PERRnpVI97o8ek9dKlmpt2pBp8WADAKq5q+BB26eiDG6shSs1n6l7Z5Cj75O7KODV67SaouN/ydVHDD2DUTUV0HCnnYz0cfaqak8DnrdZ9waW+iIfepzRUwB/elyDTTeKyrKXQ1wtZhBFzI3AYbQIrVZT88AdfO17c2zgLChzRWLerv7GUMk7hvImlcUB/WvC9H9Nh+i/5/TLvXBvmSnbu3ayN0d2bK+OMzmYCNyTr9NOtHU8jEIGVwYvR9mMZr3OEAh5trIUcOjSsCvGuBvhajmaTgYMOadPPWRaspUsD0wr2BLZWdCmCr5HIR52DMutjM5dg1c5mO3Ba3cNr8voX1hER75k7y+aMVwo4DV1UCOPV5Q6
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(396003)(346002)(376002)(39860400002)(230922051799003)(64100799003)(451199024)(186009)(1800799012)(8676002)(8936002)(54906003)(7696005)(110136005)(91956017)(478600001)(52536014)(66446008)(66946007)(66556008)(64756008)(55016003)(66476007)(76116006)(6506007)(7416002)(5660300002)(9686003)(2906002)(316002)(26005)(71200400001)(4326008)(83380400001)(38100700002)(122000001)(38070700009)(33656002)(41300700001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?slNbXK+iMzgy4r2QxyBngWuYpSyjy3l4DDIGFkzqHLQgtP414nCVMG1Vsr?=
 =?iso-8859-1?Q?f4yjWn8PNdNiUD2UoC+cxtCXUI/w3KhVx0+1cZ3Nc50iyFlDcDiEG/Nbs2?=
 =?iso-8859-1?Q?3lwNOfLeYrFALiE7OVF8sIdIHKiuzMHqK6ETtNdLBD+PlfcIhDJnLQFRdk?=
 =?iso-8859-1?Q?L2PEeMAIk7a2GaLToEdjrioKkfq3nRbe71R/BgcPJExtCeEkDZsTHWlOlK?=
 =?iso-8859-1?Q?jXKbTiC/dU7xPgaXheS5VteIh2c7SKgOHS//W00zzHd4Bt0PvmA3igTTuK?=
 =?iso-8859-1?Q?SnhVNjMyUwyiHdD+uK3uU3+I/DDJ+jdWIhw3CrSnYokZcR18kLwOdWY+EL?=
 =?iso-8859-1?Q?fOJ6U1m+r5k6W3yHs5Ev1PvTKe4kboY2/VN4ebPMzRjHnofbw/TMJp8Bw9?=
 =?iso-8859-1?Q?HAhV+elMFK1T4aJtCwGvlC5b1k5rfN0YiwdAO2giMprVHxdWaYakabJaNl?=
 =?iso-8859-1?Q?By57CJyef9kDihr0ZCH8pMy+ubEPX47WuteH1KXmkFerfy+1egqSzm9KTa?=
 =?iso-8859-1?Q?lnyj21n9hyzHLKAbDy+323d0tilw4g2JzrbhlhwYhaqbqM9Jxg6ZkGzdzf?=
 =?iso-8859-1?Q?KI8eB27QQ1MrxdK5r2HHqK8vQ1j9aQ6aSjCutXrkIp+THbWd+he9uSHtw4?=
 =?iso-8859-1?Q?pF9C2OK7zp4Rc6UbDMpwYUvOAVoW4ZSviy4B73pEWy645hBZFjUBVVxqOH?=
 =?iso-8859-1?Q?czpKxUDSC/if9XisyfsdhaglPN1w8U2l5Ugznx0AWqzR9zs8iAGHPyQjXh?=
 =?iso-8859-1?Q?vi1MFZIBVYTXhIFGIwvvkXESU23AgARgDPVRZU8sL0rKHeNddtvA3drp7n?=
 =?iso-8859-1?Q?YshuVbov4gIfL4cG65yf+qyohcX8jwyHTQ/YrKzO0PHhTUz5JVIpZM8Ffi?=
 =?iso-8859-1?Q?ynxajVvFmQUHiyip2br/F0URNCPLpUMNQLu+OWUtKPnPf6SRZQRy2wBbpI?=
 =?iso-8859-1?Q?DxV5On4alQAYPY5/YkNdTnX6DJ16aVbra8TLUVO0vYu7GOumqwm3oxw/AZ?=
 =?iso-8859-1?Q?PaDaz8yh731RnTCrf6IK55GF4NDYy5yFIXpARh73p1+lF6tzTsQ/sEcADW?=
 =?iso-8859-1?Q?oJJx7C+mV2Cn4qGNkryvEJcabVZO7fHyT9svH0ccnSB4oPUq+0XQffhUMV?=
 =?iso-8859-1?Q?9IV6ZoduIRgEmLf4ps+OBxGcjpDzDI0PaDQw708ScHiut0WvRCqGaHVxQb?=
 =?iso-8859-1?Q?/taHUT5n+G4BcGY3+JKT1hffvAB3b5FfyGtHREeA8P0vS5j8prR5inXi1Y?=
 =?iso-8859-1?Q?rhm2+p8d49XUhyIgxwkz76BRbk8qS/tX8Uf0xLN7FMe4dKNmq5ZigHpS+e?=
 =?iso-8859-1?Q?+RdcylH8lmdwNSf3/YghyTr7WggCmIxlqXKPbqDYKekuUXlDXexXxxhnoR?=
 =?iso-8859-1?Q?ffMVApKT7kECKoywqzBUlxY7WPtIlqlCxfUfVs7wWSbM6VBHSD7llDN/J2?=
 =?iso-8859-1?Q?yu7gKkbFFanxmIPAErTjt2GSgX8EId/1InLmmmR68CGSsT71NbhkIwRa2G?=
 =?iso-8859-1?Q?k4GiNAR9mKnlAxr/ZGdbU9+iE09QqSy57c/hqqVB0RKRVObQq4xhEwq94L?=
 =?iso-8859-1?Q?vldc+5h6TuVPFT3aQTn8jTPLAmpPouzK2bn3tGWTjcsdh8xS4hx1NmIENQ?=
 =?iso-8859-1?Q?shT+8cEtxcWgM=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: abeb4aaf-5af0-453e-a1a9-08dc2875603c
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2024 07:12:57.0491
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: khpESNKLiCYpZmk6gpKkmaqGfl2g0C09GvH1RDvNzmTYMafkhKB0vVqOs5trzUNGHekLae3C+25QIfqrYly5GQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4951

>> > +/* Memory size expected as non cached and reserved by the VM driver=
=0A=
>> > */ +#define RESMEM_SIZE 0x40000000=0A=
>> > +#define MEMBLK_SIZE 0x20000000=0A=
>> > +=0A=
>>=0A=
>> Maybe use SZ_* definitions in linux/size.h=0A=
>=0A=
> Good suggestion.=0A=
=0A=
Ack.=0A=
=0A=
>>=0A=
>> Better move this part to the place between vfio_pci_core_enable() and=0A=
>> vfio_pci_core_finish_enable() like others for respecting the expected=0A=
>> device initialization sequence of life cycle.=0A=
>>=0A=
>> It doesn't bite something right now, but think about when someone=0A=
>> changes the behavior of vfio_pci_core_finish_enable() in the future,=0A=
>> they have to propose a patch for this.=0A=
>=0A=
> Agree.=0A=
=0A=
Good point, will move it.=0A=
=0A=
>>=0A=
>> Wouldn't it be better to do the map in the open path?=0A=
>=0A=
> AIUI the device would typically be used exclusively through the mmap of=
=0A=
> these ranges, these mappings are only for pread/pwrite type accesses,=0A=
> so I think it makes sense to map them on demand.=0A=
=0A=
That's right, agree with Alex to keep it on-demand.=0A=
=0A=
=0A=
>> > +=A0=A0=A0 * Determine how many bytes to be actually read from the=0A=
>> > device memory.=0A=
>> > +=A0=A0=A0 * Read request beyond the actual device memory size is=0A=
>> > filled with ~0,=0A=
>> > +=A0=A0=A0 * while those beyond the actual reported size is skipped.=
=0A=
>> > +=A0=A0=A0 */=0A=
>> > +=A0=A0 if (offset >=3D memregion->memlength)=0A=
>> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 mem_count =3D 0;=0A=
>>=0A=
>> If mem_count =3D=3D 0, going through nvgrace_gpu_map_and_read() is not=
=0A=
>> necessary.=0A=
>=0A=
> Harmless, other than the possibly unnecessary call through to=0A=
> nvgrace_gpu_map_device_mem().=A0 Maybe both nvgrace_gpu_map_and_read()=0A=
> and nvgrace_gpu_map_and_write() could conditionally return 0 as their=0A=
> first operation when !mem_count.=A0 Thanks,=0A=
>=0A=
>Alex=0A=
=0A=
IMO, this seems like adding too much code to reduce the call length for a=
=0A=
very specific case. If there aren't any strong opinion on this, I'm plannin=
g to=0A=
leave this code as it is.=0A=

