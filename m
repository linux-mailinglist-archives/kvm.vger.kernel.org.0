Return-Path: <kvm+bounces-9000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D972859B23
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 04:48:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE6AE282308
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 03:48:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67C474C7B;
	Mon, 19 Feb 2024 03:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="paMZCARr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2077.outbound.protection.outlook.com [40.107.93.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0DFA440E;
	Mon, 19 Feb 2024 03:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708314485; cv=fail; b=f0C4XuNU4ef7jckKg2Y2CkPvM6xMB1vu46c8R+aRym68Fho32KP4Va3GqC5sbjUCAlVOTfV7MvxlLCYPA7H+DWTsspg7khPUGlMOF8x++bLATY5Fag9hCi8ioT98sA5HPWVJwZZSiv1kPX12F7+SIV9j8NuT8i6fbRqIS0OP5No=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708314485; c=relaxed/simple;
	bh=j1J247qFOokNqTIriD8wGKCjgRS0xJocMVEuwamfiGY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sQcg/D5U4B2EK/fa+ILIxDO0aGYKRis4Kbyw2YrYN40BSuSd7YWoA7uLRxRdboZ5eJNs4V211s5L+117IHxlbk8AV2Rzlz9Q6+yHknbW5dme5jm/QNlLRGrBgknnMgyc84f2KO0OCUZpB2rwVQDdsnBNYuaoi+NwAjYbmyBrxo4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=paMZCARr; arc=fail smtp.client-ip=40.107.93.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Osgqe5AjCbL5wVfiyakI981j4WcF7j1YijEjPs9917lP46wB1wgChkK2Crl0bd9cnmClhYPEx+cNQm8pB/V2xjiZUdToN8dZwHmVHuBji5sJAehuS6e1pevlIbGQdkNKLIBbIBtQtR7Hdh5YUmDvEcxWwN6pUz1gyG727gwapzzlJr3efnjWldmMpRmKzcBsopNdU/edqrGf8XB44FHi8gTJWjDCJ8rpu3bZLIecqyg6A7sASekV+RP3ueewKK+Vt4dAEn95cKajdHmlwa5vgzQ+/qCtlzkk7Wl3MCWvn7du+h3NtAsoxq589EVU5BqRJPdiF6zgwc01yDtzmlUXBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j1J247qFOokNqTIriD8wGKCjgRS0xJocMVEuwamfiGY=;
 b=V1B6cpUOJ5DKeOSbB5nf+FzxH5ty+N8aHYV5adjAF0a9lWm7x90+yPm5APTmoVqg4EPUQM0g0B5O49UhMdtwQ2aEvykg98Q8p4odyYWmrcdQGctceGrdccWW70zUtqLqaDFK2Y/6l3f2Im6RNITM2UyQY9oT2E8tGR5UqEDt5aPUoo9Ta19rXhPGr/YmCxqd6n+Yf7DMObSpgb7rmnPMrWUFxWcM9JBofAP0F5uOcFzYnQrQh+l5m+zPtIG98+HfHM4P8UiYBN29+PaVlwlT3Lj5jnNLuHew2snegeKO4GP+DsagfWMK6WlEO9YiMYE3F/edefa8nwbwRwKtZu6hoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j1J247qFOokNqTIriD8wGKCjgRS0xJocMVEuwamfiGY=;
 b=paMZCARrd36Bqiq6lKuDwwLf0FjF9HuFxVKFufq2x6Kp4KV0efT6bH35IKhzAwqOrYT+YjHdfPdeGMwXROM83wUc99s2htwALwtCfwny/c35mTHfG8Zhr0fapCLPcEd2FVEHDTysGR3642H4iV25fMSwmn7z28gMwqLfYCCzJJuYN8wnnMb8C06c+NzNpC/uHPZFM7S7/ZBFAGS2CCEzf1IIXmrlk0wF9e191sYqEu7BnfGpwRr5D+1dbW2f8oezNFzKHsP8t6JYDN5T3PXtEojgmjd5g7yFJxiuOlh2isQkmExF+865mr9UN2bkMwdhVxWATb1hFfJ7Ws1MRmmK3A==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by DS0PR12MB8247.namprd12.prod.outlook.com (2603:10b6:8:f5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.19; Mon, 19 Feb
 2024 03:48:01 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::284c:211f:16dc:f7b2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::284c:211f:16dc:f7b2%5]) with mapi id 15.20.7316.016; Mon, 19 Feb 2024
 03:48:00 +0000
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
Subject: Re: [PATCH v18 3/3] vfio/nvgrace-gpu: Add vfio pci variant module for
 grace hopper
Thread-Topic: [PATCH v18 3/3] vfio/nvgrace-gpu: Add vfio pci variant module
 for grace hopper
Thread-Index: AQHaYISKEq7ts7f4oEyo6sBByW/RK7EQEAQAgAD3SjQ=
Date: Mon, 19 Feb 2024 03:48:00 +0000
Message-ID:
 <SA1PR12MB719956FA6354BD78709D6836B0512@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20240216030128.29154-1-ankita@nvidia.com>
 <20240216030128.29154-4-ankita@nvidia.com>
 <692a111c-f0a7-4e0a-af6a-2590d6a1ffa7@nvidia.com>
In-Reply-To: <692a111c-f0a7-4e0a-af6a-2590d6a1ffa7@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|DS0PR12MB8247:EE_
x-ms-office365-filtering-correlation-id: 2fcb7b49-006b-408a-2bbc-08dc30fd91b3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 ok8RPLtvBcwh7NyIXAwY1Urrf0vFGAnT/PHKOGg4eaJGi112PYOaIhgpTK1EamdaoE3SFw6NeyTCosy8YeZ5KyCODybTeX7MKVQXKIpx5SwvtoucwGKDUScTpka6qFuwOyPD+Shka1Si6T+9UciFX3BM5ST+TcFVVmKB/PI8LlE5HwY30UPPUu4d2Rwc/VS4Ay1qTSwFt5ZYkAxVJP5pUKdT4AsmWe0lABRLu4a39Pl4yg/Odl0QBxVmMrcbjAnCfexAO+p+MIl2fCWoDKSDRuE5dg51L7gEPOZyNh4YhNvmNgeWsJ9GqlEab4IH3Ym4pADFwt7pioQDuXoerg/JTsiSpQ+DVdaLU+9MjSvoHnY+MhkBElZWL6UIWc9eeNxiUTP04aySWPsgBJWqKDQmuSALDf1t0qYcots7m8sdaV9mw4JL8btu4GP4NjUtacR0IxRsUdPLsSFN+ZUmbgBkKHBqDB+DxT6OEhXTjjGdMifSkIjstVEQVEq8Q2JP2atHYkW3BENdKY6rMg0Wcegi0LIBKxyzVAzf8ea9NoCUfdCW8QmA7WlPIOjA/hUniMdoyxRwtcKpsK5NPqj1tj5htRwW9Xb8wBYfd8RK2WYgExnSVP9yiZkovQQQ1b/gj8kcMFxFP69Lg+lUj4b1cHZnEA==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(366004)(346002)(396003)(39860400002)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(55016003)(5660300002)(8676002)(66476007)(91956017)(76116006)(66946007)(64756008)(8936002)(66446008)(52536014)(66556008)(2906002)(7416002)(4326008)(110136005)(71200400001)(54906003)(38070700009)(316002)(9686003)(6506007)(7696005)(478600001)(26005)(921011)(33656002)(86362001)(83380400001)(122000001)(38100700002)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?eisAmHOKtpg0jclsg2iB2P2lF+fX3rgA91fr3Z4N6uwGxx40kiP4ayMBeZ?=
 =?iso-8859-1?Q?DDtntd8xJEtbnahPRRQUKnNI6+shyplymneDGZTiKdh3/PFewYMVUzCtKy?=
 =?iso-8859-1?Q?hMYg5G/p5/rPmArXQt8s8lVfOhCoBsS1vjIzblU5lWuQcdjkocj448+5ES?=
 =?iso-8859-1?Q?6Y57fsRizJPtVCdh0+6B8njYbIMrT/Ee6j/FAF2z3lRFkiJ7bIhV18uzlr?=
 =?iso-8859-1?Q?V9RU2u/4hvpf2ZgQerjBHMSefa5hSMVauMpn07QW4y7Lg69Q+LbgNRBatu?=
 =?iso-8859-1?Q?gttfJt1gWvfIhOqh7NzjyG2Zf0e4bq/1NP8UK9AFB4+9nTrVf9XJ99qnSk?=
 =?iso-8859-1?Q?qVU4EF01WTFAD/gWGOGsCsTfWD45V+itJ6eqAPbmY2QII5gQ+MAAcbyRYM?=
 =?iso-8859-1?Q?hKp+ZuxEO2fNWc8ZPLgwJ3AhwQtsiBswp9DRncR8Hz77pcpZJTya2f90Pk?=
 =?iso-8859-1?Q?sl/BF1L3Sswmz3QHVTQjneA9oHzR0woR4HYy7K2kHuPz5yqyJLgfmkfPuH?=
 =?iso-8859-1?Q?+D/Rt5a8LQWi/N0iL6PJjLKrbiMoiUnAdolN6izKKA3I9cloggNWJdQ8cB?=
 =?iso-8859-1?Q?0C4aDyP/wpfEPGoxClA3R6ohMEuAwfJOU7qFwGUOo/DwYYxcnf0k0+4x4Z?=
 =?iso-8859-1?Q?zbY1j2AO4t/jDUD6V7qBV+/0ycCsIKpq1U51gNNGBEuuAv2vD4alHDy/vk?=
 =?iso-8859-1?Q?WJoe/whqrTTSEjckOeLEjEqVBJ2HcIF3ALpR5iLsx8q5MvbWC2/jXOYBLR?=
 =?iso-8859-1?Q?W/olJHmpzY3r7suH1JjwdBuhC98vZ/Tjp8as+DAVQNVBoHTqNcJge0hqoa?=
 =?iso-8859-1?Q?7OV+vzw875QsIvVUIeAODOxjuyfF6Os7Tokp1QTDFkl6cjFe5btjuD6U74?=
 =?iso-8859-1?Q?Q+zkFc3CRcAJeLYErJiU1Tg4WVv7VZIb8j+bVkN7SY2tTcUxpmMuuSIGdt?=
 =?iso-8859-1?Q?9qHCwAd8MfOHmCPxppmIO4FWNouWj8+YGPqfCoLsTMrAkCmKBigLtvEOY1?=
 =?iso-8859-1?Q?LFAUcEAHVoEB79rLSG8HLwE/MrOfhbSB4YLbcQOQ01sXhHovmmfnWEu4da?=
 =?iso-8859-1?Q?z4s/KWwSYEtxNYWgK11CY+6saqewdqQMT2LohTEGpl9yDFCxx8rogijjN6?=
 =?iso-8859-1?Q?rhMk4TGDjTzrwT7Kq/DAjMf1s6/aE1yF7PEtEgjkQ0OJfGRMwVmxoYOmDs?=
 =?iso-8859-1?Q?Yr9u8nVY/vhr2QoWjk7lMzCTdiDrPjwtDZNeRGCjfX/srMd0yM0cGxuB9V?=
 =?iso-8859-1?Q?KX/HxvDGrNt2YvPMxPpr33KpWZt4AF5HtxPZiMJPSz5gPOs1wHHnj9ZsaL?=
 =?iso-8859-1?Q?7XgSKgnZzWIpJZ8URV/JcKgXComW0hVlXMoGUAsJGrWs9j8HLiYFC2mbIn?=
 =?iso-8859-1?Q?b6udomPQQrm0fGA5S8T07QyoL11yTbMK+J/zigPit42xsQI6afuZW2kgFu?=
 =?iso-8859-1?Q?2Bk/VdLqKhzA0EwqFvS8kt4Z9pSEFPy8uxpaefqbYv/5xJY47VYErt69rr?=
 =?iso-8859-1?Q?Zspsp0/15oeTL3eJY6wie0amDuEcpzr5KY+XrDy3PZ+Le+hujEOZ40jSaI?=
 =?iso-8859-1?Q?uaO3FMavKHkcIWED3TO+8dkSSIBxXHehkayJeFSLNVfqZWHCVBB80yv8i1?=
 =?iso-8859-1?Q?hbPeRA2QXb/Ls=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fcb7b49-006b-408a-2bbc-08dc30fd91b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2024 03:48:00.8470
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yz3bMQSqcYRL89gswnCAugQBR2RSg8bsK4wWt0nAJuFkMCymb2LV06QNKhBDLAKHTi9pPw5R3q3pcLwUiZfX8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8247

Thanks Kevin and Yishai for the reviews. Comments inline.=0A=
=0A=
>> +static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 struct vm_area_struct *vma)=0A=
>> +{=0A=
>> +=A0=A0=A0=A0 struct nvgrace_gpu_pci_core_device *nvdev =3D=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 container_of(core_vdev, struct nvg=
race_gpu_pci_core_device,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 core_device.vdev);=0A=
>=0A=
> No need for a new line here.=0A=
=0A=
Ack.=0A=
=0A=
>> +static ssize_t=0A=
>> +nvgrace_gpu_read_mem(struct nvgrace_gpu_pci_core_device *nvdev,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 char __user *buf, s=
ize_t count, loff_t *ppos)=0A=
>> +{=0A=
>> +=A0=A0=A0=A0 u64 offset =3D *ppos & VFIO_PCI_OFFSET_MASK;=0A=
>> +=A0=A0=A0=A0 unsigned int index =3D VFIO_PCI_OFFSET_TO_INDEX(*ppos);=0A=
>> +=A0=A0=A0=A0 struct mem_region *memregion;=0A=
>> +=A0=A0=A0=A0 size_t mem_count, i;=0A=
>> +=A0=A0=A0=A0 u8 val =3D 0xFF;=0A=
>> +=A0=A0=A0=A0 int ret;=0A=
>> +=0A=
>> +=A0=A0=A0=A0 memregion =3D nvgrace_gpu_memregion(index, nvdev);=0A=
>> +=A0=A0=A0=A0 if (!memregion)=0A=
>=0A=
> Can that happen ? it was just tested by the caller.=0A=
=0A=
Ok, I can remove it. Will put a comment instead that this has been checked.=
=0A=
=0A=
>> +=A0=A0=A0=A0 /*=0A=
>> +=A0=A0=A0=A0=A0 * Determine how many bytes to be actually read from the=
 device memory.=0A=
>> +=A0=A0=A0=A0=A0 * Read request beyond the actual device memory size is =
filled with ~0,=0A=
>> +=A0=A0=A0=A0=A0 * while those beyond the actual reported size is skippe=
d.=0A=
>> +=A0=A0=A0=A0=A0 */=0A=
>> +=A0=A0=A0=A0 if (offset >=3D memregion->memlength)=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 mem_count =3D 0;=0A=
>> +=A0=A0=A0=A0 else=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 mem_count =3D min(count, memregion=
->memlength - (size_t)offset);=0A=
>> +=0A=
>> +=A0=A0=A0=A0 ret =3D nvgrace_gpu_map_and_read(nvdev, buf, mem_count, pp=
os);=0A=
>> +=A0=A0=A0=A0 if (ret)=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return ret;=0A=
>> +=0A=
>> +=A0=A0=A0=A0 /*=0A=
>> +=A0=A0=A0=A0=A0 * Only the device memory present on the hardware is map=
ped, which may=0A=
>> +=A0=A0=A0=A0=A0 * not be power-of-2 aligned. A read to an offset beyond=
 the device memory=0A=
>> +=A0=A0=A0=A0=A0 * size is filled with ~0.=0A=
>> +=A0=A0=A0=A0=A0 */=0A=
>> +=A0=A0=A0=A0 for (i =3D mem_count; i < count; i++)=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 put_user(val, (unsigned char __use=
r *)(buf + i));=0A=
>=0A=
> Did you condier a failure here ?=0A=
=0A=
Yeah, that has to be checked here. Will make the change in the next post.=
=0A=
=0A=
>> +/*=0A=
>> + * Write count bytes to the device memory at a given offset. The actual=
 device=0A=
>> + * memory size (available) may not be a power-of-2. So the driver fakes=
 the=0A=
>> + * size to a power-of-2 (reported) when exposing to a user space driver=
.=0A=
>> + *=0A=
>> + * Writes extending beyond the reported size are truncated; writes star=
ting=0A=
>> + * beyond the reported size generate -EINVAL.=0A=
>> + */=0A=
>> +static ssize_t=0A=
>> +nvgrace_gpu_write_mem(struct nvgrace_gpu_pci_core_device *nvdev,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 size_t count, lo=
ff_t *ppos, const char __user *buf)=0A=
>> +{=0A=
>> +=A0=A0=A0=A0 unsigned int index =3D VFIO_PCI_OFFSET_TO_INDEX(*ppos);=0A=
>> +=A0=A0=A0=A0 u64 offset =3D *ppos & VFIO_PCI_OFFSET_MASK;=0A=
>> +=A0=A0=A0=A0 struct mem_region *memregion;=0A=
>> +=A0=A0=A0=A0 size_t mem_count;=0A=
>> +=A0=A0=A0=A0 int ret =3D 0;=0A=
>> +=0A=
>> +=A0=A0=A0=A0 memregion =3D nvgrace_gpu_memregion(index, nvdev);=0A=
>> +=A0=A0=A0=A0 if (!memregion)=0A=
>=0A=
> Same as the above note in nvgrace_gpu_read_mem().=0A=
=0A=
Ack.=0A=
=0A=
>> +static const struct vfio_device_ops nvgrace_gpu_pci_ops =3D {=0A=
>> +=A0=A0=A0=A0 .name=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D "nvgrace-gpu-vfio-=
pci",=0A=
>> +=A0=A0=A0=A0 .init=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D vfio_pci_core_init=
_dev,=0A=
>> +=A0=A0=A0=A0 .release=A0=A0=A0=A0=A0=A0=A0 =3D vfio_pci_core_release_de=
v,=0A=
>> +=A0=A0=A0=A0 .open_device=A0=A0=A0 =3D nvgrace_gpu_open_device,=0A=
>> +=A0=A0=A0=A0 .close_device=A0=A0 =3D nvgrace_gpu_close_device,=0A=
>> +=A0=A0=A0=A0 .ioctl=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D nvgrace_gpu_ioctl,=
=0A=
>> +=A0=A0=A0=A0 .read=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D nvgrace_gpu_read,=
=0A=
>> +=A0=A0=A0=A0 .write=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D nvgrace_gpu_write,=
=0A=
>> +=A0=A0=A0=A0 .mmap=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D nvgrace_gpu_mmap,=
=0A=
>> +=A0=A0=A0=A0 .request=A0=A0=A0=A0=A0=A0=A0 =3D vfio_pci_core_request,=
=0A=
>> +=A0=A0=A0=A0 .match=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D vfio_pci_core_match,=
=0A=
>> +=A0=A0=A0=A0 .bind_iommufd=A0=A0 =3D vfio_iommufd_physical_bind,=0A=
>> +=A0=A0=A0=A0 .unbind_iommufd =3D vfio_iommufd_physical_unbind,=0A=
>> +=A0=A0=A0=A0 .attach_ioas=A0=A0=A0 =3D vfio_iommufd_physical_attach_ioa=
s,=0A=
>> +=A0=A0=A0=A0 .detach_ioas=A0=A0=A0 =3D vfio_iommufd_physical_detach_ioa=
s,=0A=
>> +};=0A=
>> +=0A=
>> +static const struct vfio_device_ops nvgrace_gpu_pci_core_ops =3D {=0A=
>> +=A0=A0=A0=A0 .name=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D "nvgrace-gpu-vfio-=
pci-core",=0A=
>> +=A0=A0=A0=A0 .init=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D vfio_pci_core_init=
_dev,=0A=
>> +=A0=A0=A0=A0 .release=A0=A0=A0=A0=A0=A0=A0 =3D vfio_pci_core_release_de=
v,=0A=
>> +=A0=A0=A0=A0 .open_device=A0=A0=A0 =3D nvgrace_gpu_open_device,=0A=
>> +=A0=A0=A0=A0 .close_device=A0=A0 =3D vfio_pci_core_close_device,=0A=
>> +=A0=A0=A0=A0 .ioctl=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D vfio_pci_core_ioctl,=
=0A=
>> +=A0=A0=A0=A0 .device_feature =3D vfio_pci_core_ioctl_feature,=0A=
>=0A=
> This entry is missing above as part of nvgrace_gpu_pci_ops.=0A=
Yes. Will add.=0A=
>> +=A0=A0=A0=A0 .read=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D vfio_pci_core_read=
,=0A=
>> +=A0=A0=A0=A0 .write=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D vfio_pci_core_write,=
=0A=
>> +=A0=A0=A0=A0 .mmap=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D vfio_pci_core_mmap=
,=0A=
>> +=A0=A0=A0=A0 .request=A0=A0=A0=A0=A0=A0=A0 =3D vfio_pci_core_request,=
=0A=
>> +=A0=A0=A0=A0 .match=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D vfio_pci_core_match,=
=0A=
>> +=A0=A0=A0=A0 .bind_iommufd=A0=A0 =3D vfio_iommufd_physical_bind,=0A=
>> +=A0=A0=A0=A0 .unbind_iommufd =3D vfio_iommufd_physical_unbind,=0A=
>> +=A0=A0=A0=A0 .attach_ioas=A0=A0=A0 =3D vfio_iommufd_physical_attach_ioa=
s,=0A=
>> +=A0=A0=A0=A0 .detach_ioas=A0=A0=A0 =3D vfio_iommufd_physical_detach_ioa=
s,=0A=
>> +};=0A=
>> +=0A=
>> +static struct=0A=
>> +nvgrace_gpu_pci_core_device *nvgrace_gpu_drvdata(struct pci_dev *pdev)=
=0A=
>> +{=0A=
>> +=A0=A0=A0=A0 struct vfio_pci_core_device *core_device =3D dev_get_drvda=
ta(&pdev->dev);=0A=
>> +=0A=
>> +=A0=A0=A0=A0 return container_of(core_device, struct nvgrace_gpu_pci_co=
re_device,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 core_device);=0A=
>> +}=0A=
>=0A=
> The above function is called only once.=0A=
> You could just inline its first line (i.e. struct vfio_pci_core_device=0A=
> *core_device =3D dev_get_drvdata(&pdev->dev); and drop it.=0A=
=0A=
True, will fix.=0A=
=0A=
>> +=0A=
>> +=A0=A0=A0=A0 /*=0A=
>> +=A0=A0=A0=A0=A0 * The USEMEM part of the device memory has to be MEMBLK=
_SIZE=0A=
>> +=A0=A0=A0=A0=A0 * aligned. This is a hardwired ABI value between the GP=
U FW and=0A=
>> +=A0=A0=A0=A0=A0 * VFIO driver. The VM device driver is also aware of it=
 and make=0A=
>> +=A0=A0=A0=A0=A0 * use of the value for its calculation to determine USE=
MEM size.=0A=
>> +=A0=A0=A0=A0=A0 */=0A=
>> +=A0=A0=A0=A0 nvdev->usemem.memlength =3D round_down(nvdev->usemem.memle=
ngth,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 MEMBLK_SIZE);=0A=
>> +=A0=A0=A0=A0 if ((check_add_overflow(nvdev->usemem.memphys,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 nvdev->usemem.memlength,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 &nvdev->resmem.memphys)) ||=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0 (check_sub_overflow(memlength, nvdev->usemem.m=
emlength,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 &nvdev->resmem.memlength))) {=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret =3D -EOVERFLOW;=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto done;=0A=
>> +=A0=A0=A0=A0 }=0A=
>> +=0A=
>> +=A0=A0=A0=A0 if (nvdev->usemem.memlength =3D=3D 0) {=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret =3D -EINVAL;=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto done;=0A=
>> +=A0=A0=A0=A0 }=0A=
>> +=0A=
>=0A=
> Couldn't that check be done earlier in this function ?=0A=
=0A=
Yes, will move it.=0A=
=0A=
>> +=0A=
>> +MODULE_LICENSE("GPL");=0A=
>> +MODULE_AUTHOR("Ankit Agrawal <ankita@nvidia.com>");=0A=
>> +MODULE_AUTHOR("Aniket Agashe <aniketa@nvidia.com>");=0A=
>> +MODULE_DESCRIPTION("VFIO NVGRACE GPU PF - User Level driver for NVIDIA =
devices with CPU coherently accessible device memory");=0A=
>=0A=
> I'm not in the full details here, however, the construction of the=0A=
> variant driver looks OK, so:=0A=
>=0A=
> Reviewed-by: Yishai Hadas <yishaih@nvidia.com>=0A=
=0A=
Thanks.=

