Return-Path: <kvm+bounces-8297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 66C0E84DA56
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 07:48:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CD2FE1F21588
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 06:48:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 459BD67E74;
	Thu,  8 Feb 2024 06:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DtM3FnPQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2063.outbound.protection.outlook.com [40.107.102.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D8A5FEE3;
	Thu,  8 Feb 2024 06:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707374879; cv=fail; b=h2aKKYsDMmeAJvi7ybPUDdcejjeOeVF5wpxY9pJNq0EvHV92BBKcuxn3tjGbIYfAwOFcfeIbBsMdi4TYv5Q+K49K+lorAYcGraEZSvcBsyN/kctTKvACZd2PcZllzY0gnDkMYGB9s23rsJlurNpgrD5nG+8c/9RcyDefExQZDHw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707374879; c=relaxed/simple;
	bh=C3TQKwOhB14h59LhbAQzI+fhQEWkLYGpKO3HpfGUK7E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XLm9XY3kuSBvQNszZMemTW6sCPQa7hCferjqS4uUm+snW91dRlxNFLZG6m7u3PLk1EcCm/CIsdTFXuGD3fkc+AamdyIpzDVoWqH4lS5gvuoH7X6py9/JCIXyPbka7KJB8fkPDsElSU2crBDXa/KYVMZYemes/PdI1RXXLf74yXA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DtM3FnPQ; arc=fail smtp.client-ip=40.107.102.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LGu7ljJltkTYFb/byDGfr4nwdO5d08xbs8y0NdZBhrghG9RPknO6L1m10Rea1+HEmcEufER2uGPOhsL1PzguIK1G/WBAejVFm9cOwhVQq2ZYAE67OHPpT4+YF8piAZq8AxQ+ll6nRtgVddiTpuV9D28e7sYzGd6Nd0oFPQZXOk4/2hf070pAhcXgJlaxbODq8+iB4IJmLWHzXs36tpYOfoX/1vwGeb1u59nKYi/S+A5PMJitM6HChpm73IHeluj0ZN1PvXu/WyeYPZknEZbHPdQUlQCBSfsqoza/RtMpVpqwaKQPJTgiAvkcGItxqs/hxsjqnV/IUhoP/BU/aKUyVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C3TQKwOhB14h59LhbAQzI+fhQEWkLYGpKO3HpfGUK7E=;
 b=PVmzZNqn/APxHkMr2/iMTdUOqWWriKaXBEINjja5JZTpYumpshrdeffDaDZgDhoOyVr9bAvWe+tnSxgpqLnUBXTXkHoF8HhnKjzt+s6Rn0vK+c0MaM3HX+FFI3UwjNMWPCGonv7gln+bHaCV4iAatDMsTLAc1/k7CSdtKyJqwVvrxEvOS50FeFbQ7jC2VWGb68ea01A3scBh1LPzHdn0jOi8DOhaCTMFixe5/r6y6ZxtqZC2lTw74KjycSD+SKFL7wqyGNwytSFJ6WHOcJvpCmYCjTAmsFvhe9eCdkRdWSSG7ZddL2hXapz9GuQK29N+DXI3z8ZghGjtdZXBJOSCjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C3TQKwOhB14h59LhbAQzI+fhQEWkLYGpKO3HpfGUK7E=;
 b=DtM3FnPQK4qib5uNT9OQDihjbw4glvERPMH+VRKWWkog1slZkEV4V/PafpH+FN6SXHQtrVN8zIYP7A3kgMy1HINzclQMXqTSeDkq4fTi1K6lZgUJGnFu4iCy1tiUku8efS2Yha1F53yJImvAn6wOsILSO93XXofzcm0fOfhI2LubcwiKzVI0GIjfBtRxXMDT0uI70Op+/B3Eh+ro5jk5DvrAUhQYxi294wFxNy/gAVpvz5EWfVA+Ko8oF3AUbVUD5X1CAF1TsDP7xKOm/Qmf1fG8ZlsKJdpyVmF6+M1WneUPrZRk0l8a+vS+JwiAtYFCuC5cVSMJM7E50sNmdW44vw==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by CH3PR12MB8880.namprd12.prod.outlook.com (2603:10b6:610:17b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.16; Thu, 8 Feb
 2024 06:47:55 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::444d:2f33:a61b:3225]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::444d:2f33:a61b:3225%3]) with mapi id 15.20.7270.016; Thu, 8 Feb 2024
 06:47:54 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
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
Thread-Index: AQHaWIdUHF93rAkYa0SGXKd0AMy8rLD/iziAgAB4KN0=
Date: Thu, 8 Feb 2024 06:47:54 +0000
Message-ID:
 <SA1PR12MB7199A493DECBFBA4C1575210B0442@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20240205230123.18981-1-ankita@nvidia.com>
	<20240205230123.18981-4-ankita@nvidia.com>
 <20240207163405.38cdcc4f.alex.williamson@redhat.com>
In-Reply-To: <20240207163405.38cdcc4f.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|CH3PR12MB8880:EE_
x-ms-office365-filtering-correlation-id: 953faf86-6305-4ec5-d99f-08dc2871e0de
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 Yz0+dWqGR1N9pwBjnhFT2TLkp322rwO32uXbmaVui9U9tQV2K4KZT+08of3ZLMPCESfPxHx/G+ZXepy3u3xSKDOIivKs68fZcg5TBCCIuMwmy9CyZWoEGxNUkSyQz8UScfh+2nOex5j4MrcHYeZ37k9mvooi12s/Wsp1MC/I+aHF9LKQNVy8D2tBarvQfBnqpDYSysk5poMLLvANO/yv53HZIW9uNABzsiAew472f12Yll9z81svMUgwYrUOf2IY184x3XKAizG2FafDpxx7EtMKLskXtOszRhpOY+VJ8rIYlYcMC0zAcgT8lSLv8z0ZnwQKVOjzHlt1GlmWoGLBt8wQhsl35nT/tFr+utwAW9eqWvHhEkbV8uXcVFefkBgVMZHqRpidKlaoal6Zj8lQrfz6HfovEPvWz4XElK+/EOqVFsnxTYvH6VMNhj0k+VAZU8XJYoYDF7pY/nK2e70iHMANK9xp47vOX6tWMF7KflZxjEOWRwkAN4BWES6pffPmMSROhvDHgI3Jpd6djF4LYSftecJxHAdKRvWzQizUbphVN7venZV4vJn2ILshwzYOyQ7+wZgi3ENdidw8OCcWXicPCjgaDplGLmWvLarB5IuTMyAuem41XEmnCBO/RALL6XuBX1nqy13mwOFQp1kyWRcMSjfYG9zW+wXH1nskVcY=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(346002)(376002)(136003)(39860400002)(230922051799003)(1800799012)(64100799003)(451199024)(186009)(55016003)(33656002)(478600001)(38070700009)(7696005)(6506007)(41300700001)(86362001)(122000001)(26005)(66446008)(76116006)(2906002)(5660300002)(4326008)(91956017)(8676002)(66556008)(64756008)(54906003)(6916009)(9686003)(66476007)(71200400001)(52536014)(8936002)(7416002)(38100700002)(66946007)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?OWO62f3f0ApBA/eMZfLtQm575LDf6IlCYGwTK++eRp95YBis/JaAQsr5gY?=
 =?iso-8859-1?Q?i1x6hX/OQ/QvKFzS3rCzTlZ594NgQadWsNVsm8cOO/QNxH4jmIFrqdytIb?=
 =?iso-8859-1?Q?+4/cj8KNdGu/H18gYQZkSgk/uBF3oo0H+fPih8C2r3AMmvdmaO3euXt5sK?=
 =?iso-8859-1?Q?hiXARUle7Uqi5xuJYQFl6RJaH0yOD+kdCskewpWbcrL9ERC93OP00CXzL8?=
 =?iso-8859-1?Q?oVCDxXH43ZV3J6LUVsYyi7cfAnHsqALYSblbAlLIEB99ICCelzc0Dtkz6/?=
 =?iso-8859-1?Q?NmrAbsgBWka7NqySICp5q1bJ0R9ZORTkUcZYcG4DrHAi0u729Tklqwps2B?=
 =?iso-8859-1?Q?AIxEKcocXV7WWlaTm5UMLT2Z2Ae/kNnPB6PmeCaB4LKzkkZR6kFIlFF/cu?=
 =?iso-8859-1?Q?3w+UlhnTYmWOMAtY/AWuUjGEqO8BLqhRDQEkBHWXBJoTU/5BG4ui4+mc8t?=
 =?iso-8859-1?Q?Nppn0yVjBHMfkCdmDmLH+h+1MqYjw1XRW/wvrx+0EhlgVguCAKfSg6dMdi?=
 =?iso-8859-1?Q?JmMXL1fMIwFoey3dKwwtlfLZwspZcKAXcly644/fhy59VUMyvgY7k+hI+Q?=
 =?iso-8859-1?Q?lrnVuGJeszQfxHhLB+BDbuFAzWufq5Ta6iomUaZjkDNJzza/hA8e3DNRDV?=
 =?iso-8859-1?Q?xXOBs1QQSYF+IxBBOI0KgNnPb5YtBWgIukY+a/q1Br6j6zlYy+BNcPfgpZ?=
 =?iso-8859-1?Q?usmUc5czjNLi5/8zY/ac/AgJvmFUNMbCYfD7M9VcRqkeLUnquSSej7qLFS?=
 =?iso-8859-1?Q?jAvrDixj+5gcP6GYrelJnUV9yvc4yMK0IwzK6zp9jkkX2uzWqtJljwnQrF?=
 =?iso-8859-1?Q?JJNW5YVKXbcsV+ym4IUbcdwjjbQFyRtZL/FeLuG2Rv+ovyzzwRAts4uKL8?=
 =?iso-8859-1?Q?y+3jcj8mJ83FfWa8+ZcSznGE3smHxxyxtS042eRwdel+IJK5uHd33zgmNF?=
 =?iso-8859-1?Q?uZrmWbAa1L/y0oPex1sIV8g3C2gttwphWMHLqntNWlu0wWL4wWtsCZc2vX?=
 =?iso-8859-1?Q?eTmxL7BEyWfc7fePlgaPBpcjE4+9Ep28dInJKU1lAr7KDVOYR7lTvre3s3?=
 =?iso-8859-1?Q?LARcXBKfa3NpMGfLpNY21s9Q7W4Jc2wWnFLD660zo11V1+S5IB3sMGDuwm?=
 =?iso-8859-1?Q?bvqbXalot+/Y0U9IlshXYBuiWsY5oCRY2so2HKgv7MSAeyLHGa9AS+fnFG?=
 =?iso-8859-1?Q?eN9CX2mQLcN9wyvqPKmmuVAW70TiFYKYO3pkRr8XhKLKUU1FVWuSTFpPE9?=
 =?iso-8859-1?Q?zUi5E77YtmD7NoEv8itzy2B8lA+qpnQpYVN7Qy5Wg+Tq6IvZxEIjSkklLx?=
 =?iso-8859-1?Q?Usm9NHh5eF43vOKR8mc957y+xKA2SPaoULZFBoS5GHDe9KhLOkKpatQfli?=
 =?iso-8859-1?Q?sUGoAzn6lj8voCEg6MlPSTfv+LrRm6TVzGTWCONM9uwWtBijG4ySl6x/bg?=
 =?iso-8859-1?Q?HH/3Vwo1/i1TRxl8uOntwYk59asnMWNlK5krBUqszMyHWScvh9D4xacobe?=
 =?iso-8859-1?Q?/IiReSeh0TFm0j5SQESyTDysm7Qd6WaO0vBIowLBG04K1WaEBP6bD1Rob/?=
 =?iso-8859-1?Q?t+GXyZQ0t7j41QEzHPoIblqW2QpFraHdLhLxC9UXdKQS1UrZ+RiI790VDl?=
 =?iso-8859-1?Q?cSXRdxEXNA2EA=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 953faf86-6305-4ec5-d99f-08dc2871e0de
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2024 06:47:54.8348
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r9NPeRXyPpRE/gJRd+sZaIhqGfCDJ+bYntRuADyMRSBLhbaimbzW0LTVlK5j32bVVcf0nUQ7ruy5Av79eqnRiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8880

>> diff --git a/MAINTAINERS b/MAINTAINERS=0A=
>> index 8999497011a2..529ec8966f58 100644=0A=
>> --- a/MAINTAINERS=0A=
>> +++ b/MAINTAINERS=0A=
>> @@ -23103,6 +23103,12 @@ L:=A0=A0 kvm@vger.kernel.org=0A=
>>=A0 S:=A0=A0 Maintained=0A=
>>=A0 F:=A0=A0 drivers/vfio/platform/=0A=
>>=0A=
>> +VFIO NVIDIA GRACE GPU DRIVER=0A=
>> +M:=A0=A0 Ankit Agrawal <ankita@nvidia.com>=0A=
>> +L:=A0=A0 kvm@vger.kernel.org=0A=
>> +S:=A0=A0 Supported=0A=
>> +F:=A0=A0 drivers/vfio/pci/nvgrace-gpu/=0A=
>> +=0A=
>=0A=
> Entries should be alphabetical.=A0 This will end up colliding with [1] so=
=0A=
> I'll plan to fix it either way.=0A=
=0A=
I will make the change to put it at the right place.=0A=
=0A=
=0A=
> Otherwise just a couple optional comments from me below.=A0 I see Zhi als=
o=0A=
> has a few good comments.=A0 I'd suggest soliciting a review from the othe=
r=0A=
> variant driver reviewers for this version and maybe we can make v18 the=
=0A=
> final version.=A0 Thanks,=0A=
>=0A=
> Alex=0A=
> =0A=
> [1]https://lore.kernel.org/all/20240205235427.2103714-1-alex.williamson@r=
edhat.com/=0A=
=0A=
Great!=0A=
=0A=
=0A=
>> +static ssize_t=0A=
>> +nvgrace_gpu_write_config_emu(struct vfio_device *core_vdev,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 const char __user *buf, size_t count, loff_t *ppos)=0A=
>> +{=0A=
>> +=A0=A0=A0=A0 struct nvgrace_gpu_vfio_pci_core_device *nvdev =3D=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 container_of(core_vdev, struct nvg=
race_gpu_vfio_pci_core_device,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 core_device.vdev);=0A=
>> +=A0=A0=A0=A0 u64 pos =3D *ppos & VFIO_PCI_OFFSET_MASK;=0A=
>> +=A0=A0=A0=A0 size_t register_offset;=0A=
>> +=A0=A0=A0=A0 loff_t copy_offset;=0A=
>> +=A0=A0=A0=A0 size_t copy_count;=0A=
>> +=A0=A0=A0=A0 struct mem_region *memregion =3D NULL;=0A=
>=0A=
> Nit, consistency and reverse Christmas tree variable declaration would=0A=
> suggest pushing this up in the list, but it's not strictly required.=0A=
=0A=
Ack, I'll make the change.=0A=
=0A=
=0A=
>> +=A0=A0=A0=A0 if (index =3D=3D USEMEM_REGION_INDEX && !memregion->memadd=
r) {=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 memregion->memaddr =3D memremap(me=
mregion->memphys,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 memregion->memlen=
gth,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 MEMREMAP_WB);=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!memregion->memaddr)=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret =3D -E=
NOMEM;=0A=
>> +=A0=A0=A0=A0 } else if (index =3D=3D RESMEM_REGION_INDEX && !memregion-=
>ioaddr) {=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 memregion->ioaddr =3D ioremap_wc(m=
emregion->memphys,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 memregion->mem=
length);=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!memregion->ioaddr)=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret =3D -E=
NOMEM;=0A=
>> +=A0=A0=A0=A0 }=0A=
>=0A=
> As .memaddr and .ioaddr are a union we can consolidate the NULL test.=0A=
=0A=
Ok, will do that.=0A=

