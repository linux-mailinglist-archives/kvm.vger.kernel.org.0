Return-Path: <kvm+bounces-64453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54B0BC83237
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 03:52:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 14A343ADDC1
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 02:52:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39E0B1DE894;
	Tue, 25 Nov 2025 02:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="h/MG5/Ou"
X-Original-To: kvm@vger.kernel.org
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011058.outbound.protection.outlook.com [40.107.208.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B35318DB2A;
	Tue, 25 Nov 2025 02:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764039156; cv=fail; b=iiWnB1331Gd2U/CO3hGUO/I71XblHNWvNBUyfc25/n5lE3pzPiGQs/r0Z1Zb0JtNvX7rQWIkxraAOPRyhNoj+UlUzNmuyRUxCiKFcCRWqXp9JMEOC86bdnrKtMLzw7wDSUEU/gYVeoNvsdjijGvbmYb+NenPAgXzQMtN3i+nhKk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764039156; c=relaxed/simple;
	bh=ZYZ3HMc31bh/fBphx3LnGb/FRI+Ih6DpAnM+hCZO4rI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OOP9dKa0dTBlubWcEROuoX3KXVV9AwJmdlveWLIlto4ltCDlfFLJYKV0ergY2V49GmJUxBN8s4PfMpKBnJHzmPcRTWXXhkW0NPLNnkd3rsuSoFWYjgtOpOrfFs2Em9wRqncDDY14yR747m2yn26+TEIhSxjiJw+qY4LbtBJ2PlE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=h/MG5/Ou; arc=fail smtp.client-ip=40.107.208.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wvL120XayebxSZyAS+gRiO/YAzTd630O/YsH4CmIB6uc8L6Cwi3jiLhHhe9y2NupRkBPGwn6Eqa0e/WJJF4eGftiHs1ysnA+XXq9p9kXdAZYtURefAyE8gkLXY3cpUI0ls/MT9u+3gMyb4Wrt3P8mBM2qEYzAU8iBC5RWmfJMmpNihI8EDuRS5ymBBsPBJaBPl6pymiKOvOB7Jsop6PzQq5vdFa7/98ks+cU5n8SKguCmulj9vM2EAafm9CYEegh+WQxdETeiYxLU6Qq46svEcljsksxMjKC+hc38d+V4vkdlgyZMprTE/xsrvF0AQjG8YOUp8qPq68PXdDhEBZ2xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZYZ3HMc31bh/fBphx3LnGb/FRI+Ih6DpAnM+hCZO4rI=;
 b=wZ0ez8r2JiaAziFNxO89pmlmAOVPZw/D5LIWe9jhdjzGn4cA29SM5++hjxDyCqYSgZPtOnktK8E7P87SD6kgRvCuBhxXNClNbR/DoAud1zTKj9alWzAn/Dkbh8BtiIZbwA1lyHXMkF58RRcXFLCQta8D5QZWwmBIFcOM3oSV11p56x19YdcyHWxHqwPgDJsDPMyiebInkavXSi89z4vZPfu+lwNKggbJuA/i3nWe47XmZwiiDsW9hNrqiGAwDM65MF4T75TIxuAgRzdtkSpf5QuX9fWwjDunr8PjBxRBBzfAUGTo63uns9QgNXP8d+ClfZYOwNCjop+J4Xxw3l1yow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZYZ3HMc31bh/fBphx3LnGb/FRI+Ih6DpAnM+hCZO4rI=;
 b=h/MG5/Ou57HuU+Wf0dRmzvGGILq5PgFk1ubDc/vnWvKLihzTO/zmPvSVFgaMn42CYINNyTp1/JCLgWma7sgnrif+9jb3nrb8janGX0ARd/NbKMtKoZAxloW+qnMNtmceAaEHvp/p7LLLsV99+2XSXG3PzdD0oBULpUcKwjEVVXtygSuc3krcHSRUlJE/rf+zGX7HsGtMa0GRZxschinmyp+6gyNaWv8HmRkIwhxlMZZQf968llYX53R6SqaW7V3FHDk4XfsQ1oIGVeVsi/tlhQldcSangd8oAy0hK2OPRcF2tu2ZXuh+iXUGBjBUGdAwyrhTmFnoCTwT9+DUzsc0qQ==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by MN2PR12MB4256.namprd12.prod.outlook.com (2603:10b6:208:1d2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Tue, 25 Nov
 2025 02:52:31 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::928c:89d8:e8d6:72dd]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::928c:89d8:e8d6:72dd%6]) with mapi id 15.20.9343.009; Tue, 25 Nov 2025
 02:52:31 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: Yishai Hadas <yishaih@nvidia.com>, Shameer Kolothum
	<skolothumtho@nvidia.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"alex@shazbot.org" <alex@shazbot.org>, Aniket Agashe <aniketa@nvidia.com>,
	Vikram Sethi <vsethi@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"Yunxiang.Li@amd.com" <Yunxiang.Li@amd.com>, "yi.l.liu@intel.com"
	<yi.l.liu@intel.com>, "zhangdongdong@eswincomputing.com"
	<zhangdongdong@eswincomputing.com>, Avihai Horon <avihaih@nvidia.com>,
	"bhelgaas@google.com" <bhelgaas@google.com>, "peterx@redhat.com"
	<peterx@redhat.com>, "pstanner@redhat.com" <pstanner@redhat.com>, Alistair
 Popple <apopple@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Neo Jia
	<cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, Dan Williams
	<danw@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>, Krishnakant Jaju
	<kjaju@nvidia.com>
Subject: Re: [PATCH v5 6/7] vfio/nvgrace-gpu: Inform devmem unmapped after
 reset
Thread-Topic: [PATCH v5 6/7] vfio/nvgrace-gpu: Inform devmem unmapped after
 reset
Thread-Index: AQHcXTnTJQlxrXGxYkisgsv3MT9Rb7UCIoYAgACNSzs=
Date: Tue, 25 Nov 2025 02:52:31 +0000
Message-ID:
 <SA1PR12MB7199CC7BB5B0C3576D251004B0D1A@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20251124115926.119027-1-ankita@nvidia.com>
 <20251124115926.119027-7-ankita@nvidia.com>
 <20251124181644.GW233636@ziepe.ca>
In-Reply-To: <20251124181644.GW233636@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|MN2PR12MB4256:EE_
x-ms-office365-filtering-correlation-id: 4853947f-2f1e-410e-8e12-08de2bcdad9f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?paQhbMMJxdqJtSJan2C1uu1XpPboZozc4GiMwUZSGZe6npBDU3e65Orz4x?=
 =?iso-8859-1?Q?1UICt8cw57cf9kuFgkivBvgdFxSIEzJBvEbczukks1VFO954BMXDTBB6b5?=
 =?iso-8859-1?Q?NCmd8+RfR/kWVeuvuZ69Up8+u9KscEMB85dNrZiqH8D2FTYFFl840LR0Xk?=
 =?iso-8859-1?Q?DBnbceK0QuOEUo2+/jUgcGJpN/CSUvrMuWfFnFLYSpCzoXXMF5IOcsf18V?=
 =?iso-8859-1?Q?gWDRKa1mwSP0DClppGm/IgHGYDbTNci201zNl9UpxNg1CyyKn8GvK7PCe3?=
 =?iso-8859-1?Q?yin1yawe4i/rJ4kPMfN8LJxUskM/radzEwciK8QlywHd63b0NdhIjbV0ww?=
 =?iso-8859-1?Q?vqoHgyFO3r3st9rXV6tdN5QYOU/sZByyohnxYU4i6tfEA8yBX0kwenpGrx?=
 =?iso-8859-1?Q?7vhIkRJMHJQYMIoK+/7kuzHp2yI3o7OeLJMXuaZgZwP/b6Kwk5nNLdTUHi?=
 =?iso-8859-1?Q?H6EtVbFkuKVNjiAXUx8jQCEuIAFRoKlWcBLfp36S5YydRJqINGJaFhpPZi?=
 =?iso-8859-1?Q?nHAqnKpdqoyFanFTzH6gelu+ZsZsd5DPoi6kKvLll1F+592UtC6Vl3h994?=
 =?iso-8859-1?Q?dfWvkeVZrLWFHPxrFfkJUA2DGn447NqKYdu6e9++IdE00jyw7jlKSlvxYf?=
 =?iso-8859-1?Q?ZJZeI7Z02BYyTqYRv5gNIiJv5+opOa8nKsX6ncsICzbG9K/RBPdLREJoe3?=
 =?iso-8859-1?Q?RcFKzJd5CqZRcWjZr1jR66Adla7EvF+tMZPkspuAWnwH81Nfq3omIrsS/V?=
 =?iso-8859-1?Q?wQHRBRv59PKSVlQJU4HCdUpPCriFTn8wIWMdVMNXgtBJpPTwvPazlTpSKK?=
 =?iso-8859-1?Q?yCkRdCyuvsTY7I+zJdAgP7+h6B4TlqlAJ35RpvvFkyjHU6BZI0KEuQkAqT?=
 =?iso-8859-1?Q?OTintMYIBX4r4IxDseSbyYGeAQW41zmvDFwOHzFe9OOsoR9YRDz5wprEJC?=
 =?iso-8859-1?Q?jw55Fq7xwk3xMaYCKtX90PM6Qhg5n5FCNlBh5Ko5X9kZAeL6ik0KGvwqMy?=
 =?iso-8859-1?Q?8E24nROYYDKLE04GbTg9S9QZvzwnqYWHxFTpjgJxbIr7xLka6MmkAEl1n5?=
 =?iso-8859-1?Q?0nnzP5ykJM7ffTDbrm0fQcHBLN9Bkzam6PmNvJcfz2E79KBZxlk9eBYStL?=
 =?iso-8859-1?Q?QYNxdpprQB5B8Zqf8r8HZRFmpIqc0053TXb2v/EiMjgX2RktqUSKmYOnZw?=
 =?iso-8859-1?Q?h28Lap3y7QXQ8iwlaVYV6sdRjaRrl+/BoRPiCUkm83WFvZMlQuT9pRaSvH?=
 =?iso-8859-1?Q?qobD0Xab3/4sm3kV0+sLWYX1wtolTETH7w0HgiHfwa9cP3Z20wMB42Q+fO?=
 =?iso-8859-1?Q?ggoD2YuOy6ETQC32YMjz3NyFBQ6oQWAtcAVFg8aDW/geKVWQOsBnBimmqN?=
 =?iso-8859-1?Q?xP85sFiUEz/Fb3ZtanxS+m1WANgtnVp+JsUItgPRA816kGRVPK80rZHisL?=
 =?iso-8859-1?Q?Pni3sVa9ek9diZEta9frGkIYE7YT2JkPLOtSIkhfgOkXaFlYdHk9hcdL05?=
 =?iso-8859-1?Q?Pr/C5HSqoWSvw6uqPE1xPj505/7wy1arsGZNUS75eOALUquXaKHVFDfwrA?=
 =?iso-8859-1?Q?u8LTOByP4KSTcb0gK4gv1fR9ZJG5?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?ynjxoIJGTxLC4ZYmdKmAiiZCDFSbWvg4tFtTgTLuuUdy7nfZUwcGUdSy2D?=
 =?iso-8859-1?Q?x582VyF44Pf9fFl5x4HrWWGg0MyjrEPWmJzSO0mgq1ziqtqTZndRbmx0LK?=
 =?iso-8859-1?Q?2Tqm3sLBt8K+QvwSQbJXBRianN4XHLYQJjoXCbQYjDSfhfYTfvVYjqe271?=
 =?iso-8859-1?Q?4uLza7iq8PRM53uNIi7NzF3zraHKDQtOj7dVHdFK4EBkPWAHON0BzaJlCV?=
 =?iso-8859-1?Q?eCVWkaAoCe0YPDexDS4AWc45ct0VfWnis9rmOAMRGmeNsTwRuadHg+S6R5?=
 =?iso-8859-1?Q?Pza0Bfg83Yl3IVI1nqOix2NFx9jaB8djmkSLzIvx9eLWAsnM6wCtct6AdP?=
 =?iso-8859-1?Q?0/u6bkiOh+6X4QEDCM+ipdGDt/vovuPB6MIuECpi5xGPt45fXVy5HctmCJ?=
 =?iso-8859-1?Q?Fy+YlOdXP9ncEEvenHciN0bS9V2GeWkGJ97MdqOsuEZcZwsiuPG2qh1Mh3?=
 =?iso-8859-1?Q?/8CLIsui0FpTYwPvmCiOcvezbWKzphKyuMP3im8R27IRBh9av3KNRELIgh?=
 =?iso-8859-1?Q?mCz/A8TTteAuoiJaS+FKUH3MC/tOqGwpHUk6oQuPq31Fjgj8JFqtUgpOar?=
 =?iso-8859-1?Q?TTGtXv8qK0cNZwpTKXTzHiDK5wXnGkZ9g4H4XYhXrHb6ExmoSHnIUS7tcJ?=
 =?iso-8859-1?Q?TF+Xoy2d5cY9+G1F9cOc6cHrY3x/HpO9TrcEpyuPWKxDE8tCg9rg2jdiJ4?=
 =?iso-8859-1?Q?YDxb86rnq0Bj/DI838Jlw+e8Og6au2iqvhZH9/re7nXpdgAm6DPYj+lbgn?=
 =?iso-8859-1?Q?bByTLE/xu9WnrKtGHIdDhWSN3QDPLsyu9DN8NUXDkA13DlLzeGAEXFOnat?=
 =?iso-8859-1?Q?cZC0oAUBxZ9/GJgTR3DFr3lj6zWTUWRWjk4siCPKFaXebBPZc3SRsEsh5l?=
 =?iso-8859-1?Q?CAME7k21pllMjoumiYBoPPIflXyz0IOHRYObuKJcS4rZ2pkbGtcFQaSHbH?=
 =?iso-8859-1?Q?EhVzqAUI2q6XRnyC3vHIhuDn71Q5qn7E4ZiTfq8VwTsmNbzghekSL/QXeX?=
 =?iso-8859-1?Q?R/9KX3FBeJ/qOSbAkBp1ec0sYFwkHebX0UyqkpVj09qe5Vrbog3zhhcJOF?=
 =?iso-8859-1?Q?IUmR629cHCTsDsvJefaXZehU/R7Y60sTv7U6LA6cv5BnbRz6t8UKxDHAR6?=
 =?iso-8859-1?Q?0iljDZdzbAxLhVQ7XF6zDwuOnLsZFxORu+kReUHCXUfua/J5jnd0Xn1H/t?=
 =?iso-8859-1?Q?9pJImUHRaE+GnbevisCWjnhWwMm+IgXzMI815G/Q/pstJTsiGj/B8TU8nC?=
 =?iso-8859-1?Q?ivGMBpoRacqlWsuX82mJLswmiqVDxTG5DcGFGyMKVqDDVj0xI78usjYmdH?=
 =?iso-8859-1?Q?nFtdGCYTVmTiHEZpTpk0N80yj/YeCi4PJAaFcScuIBm+0oAJspDAHvJMTR?=
 =?iso-8859-1?Q?GG8XbWe73BktMgmrhCdKvvqNaC4//5FXjkQDtkSIOfTSO8thVlj2bCZv5T?=
 =?iso-8859-1?Q?owqAQv0eTX8N6jI+SUN54PfHx7hKUSrZJmffHq8BUeDy/5IiZFGrWMLwBG?=
 =?iso-8859-1?Q?JxSMyLaQnZFl+RUolOMnB/GGFJGHPuzFi37GORwDZ5UkFmkFsprU6H5Jy5?=
 =?iso-8859-1?Q?N1id8Jk7VvG5S/pNv63q1s5/HFNKZg3+66/5Rk274rugRuEO47G2dkLR9D?=
 =?iso-8859-1?Q?3j0eT81mdgqmr+Qzlt+OCdmERYWLBuxUOQ?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 4853947f-2f1e-410e-8e12-08de2bcdad9f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2025 02:52:31.3421
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iJVJrOdqCMv0hg3Ox4hhLNq0oReZOWa9IY2w5kiDnQR0muPQc9p4cqAlp5ttsjAEg28USrYoqUCkaDnJsz58+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4256

>> +static void nvgrace_gpu_vfio_pci_reset_done(struct pci_dev *pdev)=0A=
>> +{=0A=
>> +=A0=A0=A0=A0 struct vfio_pci_core_device *core_device =3D dev_get_drvda=
ta(&pdev->dev);=0A=
>> +=A0=A0=A0=A0 struct nvgrace_gpu_pci_core_device *nvdev =3D=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 container_of(core_device, struct n=
vgrace_gpu_pci_core_device,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 core_device);=0A=
>> +=0A=
>> +=A0=A0=A0=A0 lockdep_assert_held_write(&core_device->memory_lock);=0A=
>> +=0A=
>> +=A0=A0=A0=A0 nvdev->reset_done =3D true;=0A=
>> +}=0A=
>=0A=
> Seems surprising/wrong at least needs a comment. What on earth is=0A=
> ensuring that lockdep within a PCI callback??=0A=
=0A=
Yeah, I noticed that even on vfio_pci_core_enable in the open, the lock=0A=
isn't taken. I'll remove it.=

