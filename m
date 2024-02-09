Return-Path: <kvm+bounces-8423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 114E384F22B
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 10:20:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 34F9E1C226CD
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 09:20:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 253BB66B2C;
	Fri,  9 Feb 2024 09:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QcRarz/P"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2089.outbound.protection.outlook.com [40.107.93.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BCC5523B;
	Fri,  9 Feb 2024 09:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707470430; cv=fail; b=tWCQvjBYGsBUyPaEi3TUtyD7v2dXuJoCrI3R3BT+bpjvK8pGFtaXX/+2qf8+EfZjnZ1L68uqTKBD8AFBdoErsR43ZJnMqj01NqgZeilTKHRUkWBHFWxAb+M99FrgN0pgB+V0XQ0zgAof3OSD+nGEXViCjnvMNZxePkvrXH54xMc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707470430; c=relaxed/simple;
	bh=T4mAGfTLO6qHT5QWKLOh4in85ovmC5yhROhWUlYQkms=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=twP57TYNodFkQ3DG8dzFtNs+KeiKhLWoOnFIv6pgSlqFvH2x/m9REbI0ejyU2qPVV5JtEyYBy+cuZAGoaRaJvVR8cOHPd6xp6h6ngD11rrfk68yM4t334fxdP1+PVx1h/YchRja/XUnuHHUfZHhcwYqGEXSAeRkniHfxROG2RCs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QcRarz/P; arc=fail smtp.client-ip=40.107.93.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HaTpp9r59s6bCtkuoyXjrmPC3i7QApHnnP1pv1eidjQlRFXj3AZLEU8RFO+w8WSZJ1Biu/E9KSL6HokbbTPnO/HFwGgHH0KRyuKzLQyuT6ic7UDIVoacEQNq5Bmkypd0Sz5O1wC2qTWfQJHlJI950iSJTiXYg88fxvn+u6XEeBr3KTMZQNx4QwEXFdgCg7uQ27mwNJSDz+fcBaY/1+YTB9/gzgJtnV6uwrueawWzPUbncebl6n0h95Op9rbUpsIEhu2zll5jg16AXSp2fHd6vE8a9WOFsrAPYrapA2+JVo9Ihuqi9SuSk6k4DtKZ/Sed90+EXBCwS7FYK6meb664GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T4mAGfTLO6qHT5QWKLOh4in85ovmC5yhROhWUlYQkms=;
 b=T5CofJ8D1feA5hGUzLC7eX6cdUpRgg8+yrLc+wNHfyFgyItyx4kvrhjOLeJ6qpuT/UlnRs9qDkOymOIndFrtGgR0bZs5N/dR6+4h735pS/5XvcrLo3uceks9gzAvqFjVxi9iRorKrS1OT7py3zG2KBhHkTBbdEyWPJXopeKdSiyYoRCqdnfoavwOCMON6OgbiSTNXFU8y8YopMrFA4FmLQoGCrXTV1miCoiryey6jZmS4MCKsKDBOgY+VXhiKYvdQRt4FpQfplpy/viqvVV2glmVKmrP0nnDRP5OKJbCmlvdRhjfLRZC8p10P1LaigAOEfvrttvdpz1Us2ChHlv7fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T4mAGfTLO6qHT5QWKLOh4in85ovmC5yhROhWUlYQkms=;
 b=QcRarz/PPoDwcsZrQFN07WCDvwWPAN9xZ/9CIA5Vj5j/M+VXwqEbNJhxH2ZIi4/9a+ay0RbXDZK6FcJt3GRIPRyu4s+vp1diHrSTWsXAr8tYkXsZu/wUHkSxWrAz31ND5pGmlnjS3rKYp1ToEHNQ3OyTuO7W0lbSQwRbE9rD7fzY5792SGr7mHV/JPkJVaMEtMg9BMFmtBjZhqEDzN/nZYPUBV+s1xSWjXV46I76X/xCWcKV4NI1d7YXhYsD2i42ZwiCPMzL30UmqRCMNPbR1/aJZvKUapshuzee2fFsMtJ3MNyF3FeYdgS/AieEihP4g7Llr/me7SW8Os5OoROu+g==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by PH7PR12MB8156.namprd12.prod.outlook.com (2603:10b6:510:2b5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.16; Fri, 9 Feb
 2024 09:20:23 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::444d:2f33:a61b:3225]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::444d:2f33:a61b:3225%3]) with mapi id 15.20.7270.016; Fri, 9 Feb 2024
 09:20:22 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, Yishai Hadas
	<yishaih@nvidia.com>, "mst@redhat.com" <mst@redhat.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "clg@redhat.com" <clg@redhat.com>,
	"oleksandr@natalenko.name" <oleksandr@natalenko.name>, "K V P, Satyanarayana"
	<satyanarayana.k.v.p@intel.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "brett.creeley@amd.com" <brett.creeley@amd.com>,
	"horms@kernel.org" <horms@kernel.org>, Rahul Rameshbabu
	<rrameshbabu@nvidia.com>
CC: Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti
 Wankhede <kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)"
	<targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy Currid
	<acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John Hubbard
	<jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, "Anuj Aggarwal
 (SW-GPU)" <anuaggarwal@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH v17 3/3] vfio/nvgrace-gpu: Add vfio pci variant module for
 grace hopper
Thread-Topic: [PATCH v17 3/3] vfio/nvgrace-gpu: Add vfio pci variant module
 for grace hopper
Thread-Index: AQHaWIdUHF93rAkYa0SGXKd0AMy8rLEAC8WAgAGxpSU=
Date: Fri, 9 Feb 2024 09:20:22 +0000
Message-ID:
 <SA1PR12MB71996EBCA4142458E8BEE367B04B2@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20240205230123.18981-1-ankita@nvidia.com>
 <20240205230123.18981-4-ankita@nvidia.com>
 <BN9PR11MB527666B48A975B7F4304837C8C442@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To:
 <BN9PR11MB527666B48A975B7F4304837C8C442@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|PH7PR12MB8156:EE_
x-ms-office365-filtering-correlation-id: 5ef5bb4a-a041-4564-3a38-08dc295057c6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 xHpYaIBHvvEaDaZLjcizaDsCa2NLtwTco9fm+7MGaDY2kAUA8+GSPQRwoYv3Hsiqih2Sdnhii/gXRmBYaxhgfqepgzTZEZp7yRXZRUEYi2JfIBUHPiuiuY8n+TJ0TFTseBk89bu+9Dh50gSKvn1h12kfjVLumybCck7uOGJWM7kv6YXpJUXfajZVQ8IKnyiUBpzRDoDK/NI2CKPCh88BUjPoiA99xQ74UWM8ugDS9fuRtk96er71NYBP8yf31lo/Z/2/jYkvkl3xsSVfQnNGM4K+5oE+qOS+dJ94rCND119X12CzKMJS0vsOYfV/eJwA69yYm3VUE6khFE/4KHPxPYzSl+/KcKpbE62Uojql2SAD83oIE2F7cJ+eLY0KUEKAX7YgHlSiF+yEBIPjVcOCSF9YPqXCUfvxKiK4hNW8VuCSkoWdFJNb4gd1LncNetx2FWVi0I2R1A1lY7M+Rsg90e0l1swUp0YPcYYlR0CZ5bjP1YVfr5lIPqcOYd9E7DuCJX+3L08dyAukChQwQcZ1UiXNYC9Z3OXmwWQrwtbMA2CysrnVw/xMeHqu2qs17uTyma6urLkmWz8y3v5Ul6moB4GIJ/LCmE1PObi8y8MgZisMLjtumxujTKtE2EH0O1LHMUeSbe+pRyHCGVSQ7JAKlLYwohqhVz/yBAhU0MOOeXE=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(366004)(136003)(376002)(39860400002)(230922051799003)(451199024)(186009)(1800799012)(64100799003)(38070700009)(6506007)(83380400001)(26005)(6636002)(54906003)(122000001)(4326008)(76116006)(38100700002)(110136005)(64756008)(52536014)(5660300002)(66556008)(7696005)(66446008)(8936002)(316002)(7416002)(66946007)(66476007)(71200400001)(8676002)(91956017)(478600001)(86362001)(9686003)(41300700001)(33656002)(921011)(84970400001)(2906002)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?vrWVcAkVyYonTsiot8Pz2412yXjrigCfAqTbWrW3bk+EmE5TqAHlaerHkM?=
 =?iso-8859-1?Q?VY2wVgj9PH0saJLNlrMEeKE+JwuQbCtELP42HlIUFDqGH18p7fDctAVrnT?=
 =?iso-8859-1?Q?aWD1Kpg/lrsHtoyt8oqZz14cCtDAPlRrHEhz4drpC4fAiIUV5zWN43SKq7?=
 =?iso-8859-1?Q?WC9Ozb1rVmnKqdaybCxX/HJGPXTA4bOWsunFJ+ahinDVGb9g+YA1EO69y7?=
 =?iso-8859-1?Q?u8UBvetA9m8Q0f+M0TBwjVege+XTlpxT0gDVmt5ffx2FSTpkVnEJeQtJWx?=
 =?iso-8859-1?Q?iNkLzxyOM6l1KBqS3p1cnW74ZVbLU8HG+lzUjabKcaPGmkjKZBFkEyd7p3?=
 =?iso-8859-1?Q?jN/bk/eyRcnUqEtfHUZ9gdL/59F81o2VgUM6tWSfGdzVw5sPD3g5Yy0KeI?=
 =?iso-8859-1?Q?S0a5VgmWbEey+gOE4YHTVEErIUcbV6GbtQU+rH3R1tWBO2qyJQbYjRpccU?=
 =?iso-8859-1?Q?uEG5N6hNmE6ugsUUf1dqpXpA4ryyroOhxutGVz09htU1dxFrZ/nWepQq17?=
 =?iso-8859-1?Q?0l3b/n68y30DqDxVU5Xo9dyz/yyKpWeeEcIXM7ett0TcvEIZF1KDWwrUx1?=
 =?iso-8859-1?Q?Q7BAL/arj+k10R30KIhygovli4qdYyWIk84FnNvAWR58DMlaeY/4VtHULl?=
 =?iso-8859-1?Q?7lNtAHmhgBKJViVbroPgBFG2cDhSkBQO1iV8U+T8oQAxv/PvF1jPc6srqr?=
 =?iso-8859-1?Q?PN5Mx5VWqDkaL+pB0pNl1oRsvtoMweVc1clnTeFzaffzKfNvultVjbPYZn?=
 =?iso-8859-1?Q?T3iwWqKVJt47InfH1JljaCeLU0eIpMgQIX2E3LfRVhrPFyW7Y94AVUi61X?=
 =?iso-8859-1?Q?l3XRuhfO02dHAC+cEP4upqUHHaK/S3mSUnuc4SnYaGWBsayjdw4RFM5AKR?=
 =?iso-8859-1?Q?dmzhk0TG7eCg9sVZoJWjHwMpJgOrIupYOeOzM7IRBfB48qhoWLcKlPlXM2?=
 =?iso-8859-1?Q?WCoxNN7KkrM7opUsN5hYMPuJ0NADKtc2ZrOoyKG1llIfGIFxf6GPHDbe9S?=
 =?iso-8859-1?Q?OqokmpFStZVO+YAmdZRGdc00h+uNJrZYdgVd1nhuizIisdGsomSHODmvNS?=
 =?iso-8859-1?Q?ouQIZT7tfrYuQgO1jPxQOBzE0fB+rCswCUU/mbg2yZGvKeXOEHmMNxGQeY?=
 =?iso-8859-1?Q?41hdMomO9WCvP4TUSoR542ylbKHndXPMXnNio47DtxarWMW3GHUmBsexB3?=
 =?iso-8859-1?Q?71I69vxU8U8v2lYOEz7cQZ42UqJX584zWpwYFKYttnj0bpl2p8njxkPj+V?=
 =?iso-8859-1?Q?nHWqURZkUNjmbW6J7LsglbS2p5KjPR863qOIhM8dCcAVdGBWohC9feUADd?=
 =?iso-8859-1?Q?faPlifFxRRVgrRiQTpRBoCUKUVvLvdHEbpa+8L5xax5bXqkDSJQoupLd+l?=
 =?iso-8859-1?Q?twOJFHNLdzgV+UKJhnFdViivt8/GCiXVjz3WqKEMD72W/DdI2DpnxeG6gO?=
 =?iso-8859-1?Q?syucCROqpoJMlqBS3kf5fvmMxjxZ/W8X8k/g2VgSrzpCVmKCsbD2Fc1QoY?=
 =?iso-8859-1?Q?QqhVzbsQgEVcak5NriLSLqHMSebpprzYG9w7o3vlRZC0/Om5VZpdfIsMOd?=
 =?iso-8859-1?Q?LcydjsapDFvdJyftpBuIDsRlnajfx1o1swRCv6P4t2clo71eZ+tEZQTp0B?=
 =?iso-8859-1?Q?2WFdX1i5JCicY=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ef5bb4a-a041-4564-3a38-08dc295057c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2024 09:20:22.6052
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B3ARmU0wgYrjKyUdapuh38WBZtzNAQd3I5udEtyVqrNbPFBbLrjmxbPdmJeX946UbdU/N0d+z6i+6bSNmhgSAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8156

Thanks Kevin for the review. Comments inline.=0A=
=0A=
>>=0A=
>> Note that the usemem memory is added by the VM Nvidia device driver [5]=
=0A=
>> to the VM kernel as memblocks. Hence make the usable memory size=0A=
>> memblock=0A=
>> aligned.=0A=
>=0A=
> Is memblock size defined in spec or purely a guest implementation choice?=
=0A=
=0A=
The MEMBLOCK value is a hardwired and a constant ABI value between the GPU=
=0A=
FW and VFIO driver.=0A=
=0A=
>>=0A=
>> If the bare metal properties are not present, the driver registers the=
=0A=
>> vfio-pci-core function pointers.=0A=
>=0A=
> so if qemu doesn't generate such property the variant driver running=0A=
> inside guest will always go to use core functions and guest vfio userspac=
e=0A=
> will observe both resmem and usemem bars. But then there is nothing=0A=
> in field to prohibit mapping resmem bar as cacheable.=0A=
>=0A=
> should this driver check the presence of either ACPI property or=0A=
> resmem/usemem bars to enable variant function pointers?=0A=
=0A=
Maybe I am missing something here; but if the ACPI property is absent,=0A=
the real physical BARs present on the device will be exposed by the=0A=
vfio-pci-core functions to the VM. So I think if the variant driver is ran=
=0A=
within the VM, it should not see the fake usemem and resmem BARs.=0A=
=0A=
>> +config NVGRACE_GPU_VFIO_PCI=0A=
>> +=A0=A0=A0=A0 tristate "VFIO support for the GPU in the NVIDIA Grace Hop=
per=0A=
>> Superchip"=0A=
>> +=A0=A0=A0=A0 depends on ARM64 || (COMPILE_TEST && 64BIT)=0A=
>> +=A0=A0=A0=A0 select VFIO_PCI_CORE=0A=
>> +=A0=A0=A0=A0 help=0A=
>> +=A0=A0=A0=A0=A0=A0 VFIO support for the GPU in the NVIDIA Grace Hopper =
Superchip is=0A=
>> +=A0=A0=A0=A0=A0=A0 required to assign the GPU device using KVM/qemu/etc=
.=0A=
>=0A=
> "assign the GPU device to userspace"=0A=
=0A=
Ack, will make the change.=0A=
=0A=
>> +=0A=
>> +/* Memory size expected as non cached and reserved by the VM driver */=
=0A=
>> +#define RESMEM_SIZE 0x40000000=0A=
>> +#define MEMBLK_SIZE 0x20000000=0A=
>=0A=
> also add a comment for MEMBLK_SIZE=0A=
=0A=
Yes.=0A=
=0A=
>> +=0A=
>> +struct nvgrace_gpu_vfio_pci_core_device {=0A=
>=0A=
> will nvgrace refer to a non-gpu device? if not probably all prefixes with=
=0A=
> 'nvgrace_gpu' can be simplified to 'nvgrace'.=0A=
=0A=
nvgrace_gpu indicates the GPU associated with grace CPU here. That is a=0A=
one of the reason behind keeping the nomenclature as nvgrace_gpu. Calling=
=0A=
it nvgrace may not be apt as it is a CPU.=0A=
=0A=
> btw following other variant drivers 'vfio' can be removed too.=0A=
=0A=
Ack.=0A=
=0A=
>> +=0A=
>> +/*=0A=
>> + * Both the usable (usemem) and the reserved (resmem) device memory=0A=
>> region=0A=
>> + * are 64b fake BARs in the VM. These fake BARs must respond=0A=
>=0A=
> s/VM/device/=0A=
=0A=
I can make it clearer to something like "64b fake device BARs in the VM".=
=0A=
=0A=
>> +=A0=A0=A0=A0 int ret;=0A=
>> +=0A=
>> +=A0=A0=A0=A0 ret =3D vfio_pci_core_read(core_vdev, buf, count, ppos);=
=0A=
>> +=A0=A0=A0=A0 if (ret < 0)=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return ret;=0A=
>=0A=
> here if core_read succeeds *ppos has been updated...=0A=
=0A=
Thanks for pointing that out, will fix the code handling *ppos.=0A=
=0A=
>> + * Read the data from the device memory (mapped either through ioremap=
=0A=
>> + * or memremap) into the user buffer.=0A=
>> + */=0A=
>> +static int=0A=
>> +nvgrace_gpu_map_and_read(struct nvgrace_gpu_vfio_pci_core_device=0A=
>> *nvdev,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 char __=
user *buf, size_t mem_count, loff_t *ppos)=0A=
>> +{=0A=
>> +=A0=A0=A0=A0 unsigned int index =3D VFIO_PCI_OFFSET_TO_INDEX(*ppos);=0A=
>> +=A0=A0=A0=A0 u64 offset =3D *ppos & VFIO_PCI_OFFSET_MASK;=0A=
>> +=A0=A0=A0=A0 int ret;=0A=
>> +=0A=
>> +=A0=A0=A0=A0 /*=0A=
>> +=A0=A0=A0=A0=A0 * Handle read on the BAR regions. Map to the target dev=
ice memory=0A=
>> +=A0=A0=A0=A0=A0 * physical address and copy to the request read buffer.=
=0A=
>> +=A0=A0=A0=A0=A0 */=0A=
>=0A=
> duplicate with the earlier comment for the function.=0A=
=0A=
Ack.=0A=
=0A=
>> +/*=0A=
>> + * Read count bytes from the device memory at an offset. The actual dev=
ice=0A=
>> + * memory size (available) may not be a power-of-2. So the driver fakes=
=0A=
>> + * the size to a power-of-2 (reported) when exposing to a user space dr=
iver.=0A=
>> + *=0A=
>> + * Reads extending beyond the reported size are truncated; reads starti=
ng=0A=
>> + * beyond the reported size generate -EINVAL; reads extending beyond th=
e=0A=
>> + * actual device size is filled with ~0.=0A=
>=0A=
> slightly clearer to order the description: read starting beyond reported=
=0A=
> size, then read extending beyond device size, and read extending beyond=
=0A=
> reported size.=0A=
=0A=
Yes, will make the change.=0A=
=0A=
>> +=A0=A0=A0=A0=A0 * exposing the rest (termed as usable memory and repres=
ented=0A=
>> using usemem)=0A=
>> +=A0=A0=A0=A0=A0 * as cacheable 64b BAR (region 4 and 5).=0A=
>> +=A0=A0=A0=A0=A0 *=0A=
>> +=A0=A0=A0=A0=A0 *=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 devmem (mem=
length)=0A=
>> +=A0=A0=A0=A0=A0 * |-------------------------------------------------|=
=0A=
>> +=A0=A0=A0=A0=A0 * |=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 |=0A=
>> +=A0=A0=A0=A0=A0 * usemem.phys/memphys=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 resmem.phys=0A=
>=0A=
> there is no usemem.phys and resmem.phys=0A=
=0A=
Silly miss. Will fix that.=0A=
=0A=
>> +=A0=A0=A0=A0=A0 */=0A=
>> +=A0=A0=A0=A0 nvdev->usemem.memphys =3D memphys;=0A=
>> +=0A=
>> +=A0=A0=A0=A0 /*=0A=
>> +=A0=A0=A0=A0=A0 * The device memory exposed to the VM is added to the k=
ernel by=0A=
>> the=0A=
>> +=A0=A0=A0=A0=A0 * VM driver module in chunks of memory block size. Only=
 the usable=0A=
>> +=A0=A0=A0=A0=A0 * memory (usemem) is added to the kernel for usage by t=
he VM=0A=
>> +=A0=A0=A0=A0=A0 * workloads. Make the usable memory size memblock align=
ed.=0A=
>> +=A0=A0=A0=A0=A0 */=0A=
>=0A=
> If memblock size is defined by hw spec then say so.=0A=
> otherwise this sounds a broken contract if it's a guest-decided value.=0A=
=0A=
Answered above. Will update the comment to mention that.=0A=
=0A=
>> +=A0=A0=A0=A0 if (check_sub_overflow(memlength, RESMEM_SIZE,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 &nvdev->usemem.memlength)) {=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret =3D -EOVERFLOW;=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto done;=0A=
>> +=A0=A0=A0=A0 }=0A=
>=0A=
> does resmem require 1G-aligned?=0A=
=0A=
No, the requirement is it to be 1G+. No alignment restrictions there.=0A=
=0A=
> if usemem.memlength becomes 0 then should return error too.=0A=
=0A=
I suppose you mean if it becomes 0 after the subtraction above. We are=0A=
checking for the 0 size in the host ACPI table otherwise.=

