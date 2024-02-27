Return-Path: <kvm+bounces-10032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B63D1868B22
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 09:46:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F9E22841F9
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 08:46:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18F48135A6A;
	Tue, 27 Feb 2024 08:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JP1qypM0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2084.outbound.protection.outlook.com [40.107.102.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58267133424;
	Tue, 27 Feb 2024 08:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709023543; cv=fail; b=fsZQcptpkAURPytgQkofDhx9Wb03qrjWZ5Nipc2vALiNs3qwzQQ7do4Kgr6bxjLFxFDwvD+bqyL/s8V+IWkOmUrzPvH9/37ISK3yb19FrHpOQ6SVeuaA8EVqc7VJqM3Ti1lnyk19Njqcj0oVv768yJlZIQDq5QdrYlkU1GnyHG8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709023543; c=relaxed/simple;
	bh=dTuhx1q8zHzaIJNM3dGqfLK0armnPXZmOkeGA1zLY/Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ftJPZPGoVkm4Jo75tcnF13INQMJr+YuTzRGkT4P/lpku+7wEfYWU6n9zP8wqaOIdThgtPaMv7SURILhpV2wTJsaq+tuKTvoRDUsVWHLS7leN9Ka7w9omCvNrtOVwTLn4uKjuCFMtfQKrHsvz2qLAqS32yxqnmu8UPztuu15/Yuo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JP1qypM0; arc=fail smtp.client-ip=40.107.102.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GRz4WSqlkteRAXBBqnMEywtr7wVecfBMb+IbWfzVdr3eGuLXEIu4l0ErKYoXl4jge4N8IiqN+I/PpIRa95p/OLtDpgi5o3Kjy0doIx3hrIUNn0q4Jo4cILpXja0XWzQwIkBGTBQpbvj29zl113DWWqXCI35VLKj8BlEiHU/3NYEKVq8EtOX/P/esuV45pYJUFO4PTrE1EIE1Jzeh+iyddXOBEanSUwyKWBwod8tVlWVfRdY22qLIm+YbwIctOu3ibV+fLYEz3wdDWw72Uh1YE2Y4aYGwt39Rpx9x/RbzIz633gYpzaqKluxXRhpENq4KAEMcf2Gcy4uPnHjzF4XUxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dTuhx1q8zHzaIJNM3dGqfLK0armnPXZmOkeGA1zLY/Y=;
 b=Fg2pKf2wuBZscEB3v7dK+TXxGYi/ZCSXIrUMXfcj4wwoXevHXvS4mQ7YxFuzm2/80/wTrKyyQt73z2mAueK3rSDtATazkktF8bkA6W1MTVT8P9Q/eNmKBwymzUKy5zHa2yH0eQmbOAZRgM98o6hU6USO8NugqsjMOcqKfGGIrwOSgIGG/2GBs8HT3LOP+yNaJiBM8hQ9sMOT6N79sH7IcWmclsLNAdg5Mz5Drq9Xo/oILj5Ns8zIyerY7knLuioT6AnYNgf86yEI5uVzxEcu8MyxvE8EckbTNUXGYqBaDGcrEHWg/1sIOexsKweMvwCsKYfPtVbsfdOjz9TQxshW8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dTuhx1q8zHzaIJNM3dGqfLK0armnPXZmOkeGA1zLY/Y=;
 b=JP1qypM0Pkpz7WEXlTyKrYl3O53KXhMBfU6RDlgJGluxBdknp0Kpq8tTr4kIO8a5cM+j8/2NjPlIIWQ6n70bZT+h69DlRy9v8+4En87/bdI1OZGIPDFFF+QEFItF2sXWCI9ey+QcMs+yTVMuelYbRNEpFDSNlnsbUXpdci4h7bFwaOm4WNVOFn9VQTRRrQ16yRf1VAjlYCuujukF1E7A2d7M/O0x/nYRd+h96UBPa2pvZxMwBzlhFly5UA4FPC8cOFNY7XdTotdoFcUQUP6NtE2JX6e+z7XAWD9mHmVoesd2pxT2Rpn/ugYIztH7FP4HYJcBni4q+q3MHm01stATBA==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by DS7PR12MB6071.namprd12.prod.outlook.com (2603:10b6:8:9d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.36; Tue, 27 Feb
 2024 08:45:38 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::284c:211f:16dc:f7b2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::284c:211f:16dc:f7b2%5]) with mapi id 15.20.7316.032; Tue, 27 Feb 2024
 08:45:38 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Oliver Upton <oliver.upton@linux.dev>, "wangjinchao@xfusion.com"
	<wangjinchao@xfusion.com>, "shahuang@redhat.com" <shahuang@redhat.com>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "stefanha@redhat.com" <stefanha@redhat.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>, "david@redhat.com"
	<david@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, "gshan@redhat.com" <gshan@redhat.com>,
	"brauner@kernel.org" <brauner@kernel.org>, "rananta@google.com"
	<rananta@google.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "suzuki.poulose@arm.com"
	<suzuki.poulose@arm.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"surenb@google.com" <surenb@google.com>, "ricarkol@google.com"
	<ricarkol@google.com>, "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
	"james.morse@arm.com" <james.morse@arm.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "will@kernel.org" <will@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "maz@kernel.org"
	<maz@kernel.org>, "bhe@redhat.com" <bhe@redhat.com>,
	"reinette.chatre@intel.com" <reinette.chatre@intel.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "andreyknvl@gmail.com"
	<andreyknvl@gmail.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"mark.rutland@arm.com" <mark.rutland@arm.com>
CC: Dan Williams <danw@nvidia.com>, Andy Currid <acurrid@nvidia.com>, Alistair
 Popple <apopple@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Aniket Agashe
	<aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, Zhi Wang
	<zhiw@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, Vikram Sethi
	<vsethi@nvidia.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "Tarun Gupta (SW-GPU)"
	<targupta@nvidia.com>
Subject: Re: [PATCH v9 0/4] KVM: arm64: Allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Thread-Topic: [PATCH v9 0/4] KVM: arm64: Allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Thread-Index: AQHaZzMEm+T/CCvzwkOvE3ojID9DN7EdTV0AgACUxr8=
Date: Tue, 27 Feb 2024 08:45:38 +0000
Message-ID:
 <SA1PR12MB71992A7E86741878935DC385B0592@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20240224150546.368-1-ankita@nvidia.com>
 <170899100569.1405597.5047894183843333522.b4-ty@linux.dev>
In-Reply-To: <170899100569.1405597.5047894183843333522.b4-ty@linux.dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|DS7PR12MB6071:EE_
x-ms-office365-filtering-correlation-id: e30c4d13-bdf7-4614-f75b-08dc377078b2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 SdagqvIo+DTLuXgEG1Cp/N6wf4c47NyMxdctuMwlTntk5Ct/cPRdDvX4bZluJyiJTPQjyhEZe1D++BypmWYj1ifq0QER3dKZR8u36PqDPSiZa7dwu3wwRXyC4/ZbjFNGuDT5kWuSaFtq7nMJACAxOmUKr9ZHiIlYHaRQCWvvvag5cBhfBwJFi2QF/z8gxEPqpkTR8t0nkljgbtRnxv2jYqQXCczZp2pQcXBUHBfz2hoEkiGBe84Uys04khLjjs/8TCNRcSbyi2YrQn+xElEe0Ivg4X+h3NoR/uG/RlJ+iep1YQe32gYZMsp5mHS/1GJoLzpxv+yEsuz+13VN+XchYy9OcMkIB/T9Riaq67b5WsHsUnK7tsDynUnJ8WQviHvMjGZEjBlgHwFHMZvhsbURZvj1MMBoaIfqcu22ra2rc5lby0Js2bON/G1iFvE18Q6DLhrJE2isgK0nLCMAK1MlVtGioxmBGARIyPV6jGC5Gl2//ha9TbIx2Gj0mV24BFLxFPO3BTgvJsmK6uplZ0VGMbK1PuBmSOGHKlzzkmOyZO9MJnZAQ71a643z6oM7AGHz+1UYhzu+05MpNg9p0ryiKRaIkh8woOcjcCxe3XzsyOYxqmVnqu5tx/oh1LG2MiT5vNnODRyafujgGjlob5YjzXc2E7D6g2+gDI1d+qmyYE/sqjzi/jSaeeteNshPPNlxDIK+G196DpWk5UzaPFAilHMRJFfVtRJLkJm0SC9pIXzb2ktRO0vF1VSngC9CAjCM12GxXrDWGEynNsBrCjbMZQ==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(38070700009)(921011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?jPmbaFzJlLXW7xp8ap6bVFVZzSdRsUSRPP3dDYjdW3MOa1K5o3AoQQc2Lx?=
 =?iso-8859-1?Q?dMu1QDcE0dIpmOU+JfuOSEmk3XYfACjvVT30grGBryxP616hJRCgmOehqq?=
 =?iso-8859-1?Q?QMkJbZsGBhfRfkyIqhQIC/L6dMnzXJ22dErXOOFrYn6C0TYn2fcDsWfNTq?=
 =?iso-8859-1?Q?4M1NUsolSl6HH4YpZ74zp15j+uN7ybEZBiB3Xz7PzLq4FeajgXVi+OtlBG?=
 =?iso-8859-1?Q?BbOZyh/5y6ZguQYwTLkdhwGJxypCe2nbMNWaT9wYlsHXtpNVL8UbuwN638?=
 =?iso-8859-1?Q?mQ8Z0IqKstgp7dAVV42s1kmUrmfSPmJVYsS76oDusR51YVvR+onSNdp8lX?=
 =?iso-8859-1?Q?4+RiIAYFsqsQNNtL89a5PtIaQHxM5Eof+e9tfSmXeF3aePXoa+9SEWYPi3?=
 =?iso-8859-1?Q?tC84d0nwrVYDlCZmx0yrIfZ4LWzGo1MYTtG2ekQZ6OVn+riDvDxt7JlY13?=
 =?iso-8859-1?Q?BAQT1EIBkDJDLcMBFLTWhcj8AoGuYNSi210muXnWkcCVYCgOhDrCZT2i/Y?=
 =?iso-8859-1?Q?+dAPDYzdP9pUCKnxi9aqKHbOyav51lA0qtEDD7x1clUW8QoagbfX+50lg/?=
 =?iso-8859-1?Q?Iob1iRNTXIvYx19rCJ9RBFufaqCenWulT2G0SzMrEFgHMCfTZvyDK5yuAC?=
 =?iso-8859-1?Q?8EIJaWTW1c+u0Ohrgzf1SjZzeUpHzTAQLksujvpobRWK1g4s6TUBChwk+X?=
 =?iso-8859-1?Q?SKqK5e+2ZitYnS9NsqRv7Ir4Jt6UVWWd3/jhatvuKJO4F2DOnCvQOxqaL/?=
 =?iso-8859-1?Q?bOIMMtJgkPPDpRK5ElvRMYHtXR6fNsK+DgbQ5yilbOFFT2FQBUrMviX0Wy?=
 =?iso-8859-1?Q?H2u/Ue0uGBFIrz/iQE7x9KlCE9oMWwm7RCW/XSoX8RcMMH5a6BAwDBvoGh?=
 =?iso-8859-1?Q?5GpGWtTzYwEt0nmAloqCaRvZjHPVRkoH3WheGd0EPOmkDpSaLV/CoHmADl?=
 =?iso-8859-1?Q?AULE+h0JvLNgA79ynqrMWszZthHYtTTK6U2aILRCMDsUrVWBu/8m5zfRQ3?=
 =?iso-8859-1?Q?K2uyXPXaJAZm5sxzePalnkguOpf76yjyxVk/QCOd6ksJsNcCLsv21FS2Up?=
 =?iso-8859-1?Q?jycwiA4Etm3gDauZRVXv/gp0Z5kPBXe5tYZU/FoDSlMFII1wAvBL0REwUu?=
 =?iso-8859-1?Q?1rK8pRwl1OoAOkITk39kyRmWk0nCfuzx31BeO133NDVARdcOm+MCPVpxa8?=
 =?iso-8859-1?Q?T43pUVYrfPppY7K4OXMVDsBKV0l8kZ0wEJ4WQJHs7M1wtrLx8nnSBI1xSO?=
 =?iso-8859-1?Q?d1rYXh0g/D034PmubdrGQ/cUccEoHSWTxyjtrZS3jM+UeQkYRZRNSdOTfX?=
 =?iso-8859-1?Q?VfKIATJYzd5P2OXTj4o0iooNCtln8FOHb+ecQuCdH/65BidfeGdBQjYKPW?=
 =?iso-8859-1?Q?4HRjjHL2Qz96phYLpmcsJ482bzOPkjLqU3D0Hbk7Ex/p1GwBntCOuMAYYv?=
 =?iso-8859-1?Q?oYkhJgerevUkFBLONd8WYQkREHrc7pbInQkT+Rn1NPA0C+dAIZN44D8hXP?=
 =?iso-8859-1?Q?WTnBFfS6t1SWN6Xkjv2bVNnhI7a0M1gvyjeIpDXfMDOhJ7b7DM932UfHna?=
 =?iso-8859-1?Q?fQuM4LYDd2Qo7gqHlwp2DNPlN4lNUlwHSlCyvBeF5kUWKWQswja0VdWhxD?=
 =?iso-8859-1?Q?INrRmNyzLh+MQ=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e30c4d13-bdf7-4614-f75b-08dc377078b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Feb 2024 08:45:38.0612
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lQFSU47ktH0KdpJe/gh8C7AAO7HIdH8c8DuYddqtypTyFKZE/itXRW6rkPwQ3ELLwITYIzz/ZqGBsbtEEhCDPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6071

>>=0A=
>> Currently, KVM for ARM64 maps at stage 2 memory that is considered devic=
e=0A=
>> with DEVICE_nGnRE memory attributes; this setting overrides (per=0A=
>> ARM architecture [1]) any device MMIO mapping present at stage 1,=0A=
>> resulting in a set-up whereby a guest operating system cannot=0A=
>> determine device MMIO mapping memory attributes on its own but=0A=
>> it is always overridden by the KVM stage 2 default.=0A=
>>=0A=
>> [...]=0A=
>=0A=
> High time to get this cooking in -next. Looks like there aren't any=0A=
> conflicts w/ VFIO, but if that changes I've pushed a topic branch to:=0A=
>=0A=
>=A0 https://git.kernel.org/pub/scm/linux/kernel/git/oupton/linux.git/log/?=
h=3Dkvm-arm64/vfio-normal-nc=0A=
>=0A=
> Applied to kvmarm/next, thanks!=0A=
=0A=
Thanks Oliver for your efforts. Pardon my naivety, but what would the=0A=
sequence of steps that this series go through next before landing in an=0A=
rc branch? Also, what is the earliest branch this is supposed to land=0A=
assuming all goes well?=0A=
=0A=
>=0A=
> [1/4] KVM: arm64: Introduce new flag for non-cacheable IO memory=0A=
>=A0=A0=A0=A0=A0 https://git.kernel.org/kvmarm/kvmarm/c/c034ec84e879=0A=
> [2/4] mm: Introduce new flag to indicate wc safe=0A=
>=A0=A0=A0=A0=A0 https://git.kernel.org/kvmarm/kvmarm/c/5c656fcdd6c6=0A=
> [3/4] KVM: arm64: Set io memory s2 pte as normalnc for vfio pci device=0A=
>=A0=A0=A0=A0=A0 https://git.kernel.org/kvmarm/kvmarm/c/8c47ce3e1d2c=0A=
> [4/4] vfio: Convey kvm that the vfio-pci device is wc safe=0A=
>=A0=A0=A0=A0=A0 https://git.kernel.org/kvmarm/kvmarm/c/a39d3a966a09=0A=

