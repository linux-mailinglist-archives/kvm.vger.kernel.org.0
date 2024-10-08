Return-Path: <kvm+bounces-28111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D0CB994091
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 10:08:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F1F511F25FA1
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 08:08:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A14CD2038A6;
	Tue,  8 Oct 2024 07:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GkUVTveo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2043.outbound.protection.outlook.com [40.107.243.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBE142AB1;
	Tue,  8 Oct 2024 07:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728372170; cv=fail; b=LZ0gGoyy1K/TRS7c4EXjssoaOTyhzq5ZpMZMUtahIECulFcyeOJr1AQSywsfYoW/sySQl0VzAGSzc8sfOQvwu3CfdgLMeFtLiuJ4LuvRARs9D2E51AsX/ZmVLnlhvTOcaZpXWqzfOcDB5iUqikLf2IrF1jnZlMCFMYmHsRSKPeI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728372170; c=relaxed/simple;
	bh=TH38NUixIa+c4L+5Sw8dIS8ahYqXpWDO2HLVj0B1pEE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ui1rn3tt5m0gfEkkf69O7TH/L0o+IJTsCgOZWBaklOQN5sXJY4T/ClcRHPS5PpbGECMFS4QxjHvGh9zbrXLwd4mYiSqBpxfj9iYmUXNbpi72BwU6a5IQPmtImZTn5irRLWHeHPLVAzgmEpkbrn1vl1NeN6gbzIMSw1/c9sxGNWo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GkUVTveo; arc=fail smtp.client-ip=40.107.243.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mynyJlBzhf4h5DnP+xvZfnik2Hvo3XcRfbVkiqeUaKETwArnyj2iON20CHaGEgzcbC9erR2BRKLObmbJ4FFZMYokPtMFUecsY0cRuf0oKvlUhO6jjonZYn67hYo6bdQ8nDFhMrKOYClv6hAdI4Rr8V6+lJMZlBu4g41uisTINamRooAuDmCtj1o0/7uy+Z84CnmLtz7aP8BG9Rdw+yLzICyZ3FjBCYPj0ry9KljdRzPV3RuJX4Nz3yWgn0j3cK+mN70B3Pb/uD7xjswAs8mPjjFY/Q9zBA4uDN/GN99ikv1FaOvWFE1mmxT0C//gwu/ce95Oss9o56NyAAj22FMG2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TH38NUixIa+c4L+5Sw8dIS8ahYqXpWDO2HLVj0B1pEE=;
 b=kQZ5esT/Fsa6N3HLPZOqVdtbibWnz9NqN3wBbpN1FZzj8iRciJD0wZ8XNtueRnIBKaxCbNSrA3qwd/qrArSer5fwh13F5grRw0A6xNWvjSUjpIU9q6KXBYR/CimTCrDYB0PTUx6bVs4YGJcGBjrlWaER3ZT/J1c4wzEAw/KFTRCNal/tiktX6+LgMRq3maSmP8iSUncDGGWGoTB1twnqlEZUu2SB1ojqfmvL7TgfAURUO2PxUQ7UxC33/ytBh2J0jg/kQC/KLeoVxCzFN8I+vzLc2SaBmjDTiJ6c3kx6TJiq92y7cGsxskEjGVkX4gMk04E9h+OI6IJwrtDvI77B2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TH38NUixIa+c4L+5Sw8dIS8ahYqXpWDO2HLVj0B1pEE=;
 b=GkUVTveoCxy33RuVbx6pTFQ+u1zwDOZCwGdGoJCR+ABLkUEC9M+KJddVlTtNDKmq7MCg28HiPzpNyU/q5jTjZkP0P5gx6D3kAa5pQOss8vtc/3eQWxkFE4nEeABLumXkxtVdNQLZoQzOlJnHs+1/1ZjcYhV7GPy/pInEHjfBco1WuqikaJeFeLmvejQ4O8Ij1aXO5D7EOgaaGaIACixcCpdB0MNDimjyKZW5duPd9QKXlto19x7+L+HD6HDnvsNZFw9fNON1ULF/ziq56DQHY3jXiZdiPZIjVdFmMiYMCAb59+5+QccFtTajCI9Y8pio+SqGG91B4g902dFHH6rWVg==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by DM4PR12MB7623.namprd12.prod.outlook.com (2603:10b6:8:108::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.23; Tue, 8 Oct
 2024 07:22:25 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%4]) with mapi id 15.20.8026.020; Tue, 8 Oct 2024
 07:22:25 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, Zhi Wang <zhiw@nvidia.com>, Aniket Agashe
	<aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti Wankhede
	<kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>, Vikram
 Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>, Alistair Popple
	<apopple@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Dan Williams
	<danw@nvidia.com>, "Anuj Aggarwal (SW-GPU)" <anuaggarwal@nvidia.com>, Matt
 Ochs <mochs@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 0/3] vfio/nvgrace-gpu: Enable grace blackwell boards
Thread-Topic: [PATCH v1 0/3] vfio/nvgrace-gpu: Enable grace blackwell boards
Thread-Index: AQHbF9pjAi8Jnph6QEiEFMHiFwbtvLJ7WA+AgAAe2kyAAFXCgIAApyHc
Date: Tue, 8 Oct 2024 07:22:24 +0000
Message-ID:
 <SA1PR12MB7199F0B2EC2A41E0CD724719B07E2@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20241006102722.3991-1-ankita@nvidia.com>
 <20241007081913.74b3deed.alex.williamson@redhat.com>
 <SA1PR12MB719900B3D33516703874CF11B07D2@SA1PR12MB7199.namprd12.prod.outlook.com>
 <20241007151635.49d8bc30.alex.williamson@redhat.com>
In-Reply-To: <20241007151635.49d8bc30.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|DM4PR12MB7623:EE_
x-ms-office365-filtering-correlation-id: 3465ed3c-052d-49d8-c800-08dce769f521
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?/t954myTyMr+xcrUtgS+zKM4n8HVN9SczzNwnoekPYbrhQXwjSZPHJ8VLB?=
 =?iso-8859-1?Q?9EA4TEFTojA4PCws/hQRslRgQbYp3777QRLCwLKTxwMzeV03oP0UTGbSs8?=
 =?iso-8859-1?Q?HxztVdjXFyF5c/6R/QLkNhnOHZ2Y/iOsPWBHwSykSnLhWIkVWdIioktkKL?=
 =?iso-8859-1?Q?dMC1ke5+V14rOmttUFgsVU74Ak6uZ4z6S1bQoRmD3CGSNLKNf4YMD6z27T?=
 =?iso-8859-1?Q?jKZ3OxN+ThFa4GP206d57Z9OAm/5Y3xmlEAJLiiXkyXqEh4VqZ33rmwWIn?=
 =?iso-8859-1?Q?19/xNLXHhBEQVIbSmPLE2koiV0PuXIh5hX+9DH1SEi3Vsil0nHcGoYBY7m?=
 =?iso-8859-1?Q?W80Ln2eGysDnDaGSv+mYjqSY5nD5Fz8RuJ/C3BnKVsSm62kzxyphHmRcy2?=
 =?iso-8859-1?Q?/zVCmMxdIy8d2FP9Ium2Ddusw2LUPusCbiK97tWqMKArmJpiCIEp6FeYNU?=
 =?iso-8859-1?Q?H59G3jK2ytR30YC1Ltw/iRwlb3aTIdZnElhoI0Q/CXqLX0Or5eoMdCu+YS?=
 =?iso-8859-1?Q?iS6gSZwv+xXyGnpD16LBIldF1uQreTA5ymt0Zoj8qsyOeRps7fBkKNrlFk?=
 =?iso-8859-1?Q?mVroLAOOsy4jjvBlmlUJnV+nY9rMXbP1pOJENBf3mTCpvn5pRGifibgzl6?=
 =?iso-8859-1?Q?poUmHpQ4++W9nw7Tt53qzWNl9CYN1+LdLuWJy7vAztwgOUT16jRPQaPKGG?=
 =?iso-8859-1?Q?xZMrZU12JB8M+vunJ3DzW08qhhGUPgDBah147Z+a+34x/HBb9gu9qF6Y76?=
 =?iso-8859-1?Q?vgeRJYsIEResWDU+NI5XclBRcCUlRwuOc5Wwmy+RLsSP2PUmER79hur4Jj?=
 =?iso-8859-1?Q?J5tD825jB6aN0GTQUeiaqo1eSWFT/CrvzGB5YD5SOp2YCec5ihYwqVXCVS?=
 =?iso-8859-1?Q?nJttZwlZHR1XYd9mN26t2iMJPBqDcnyd0gcBsZIxttQ3wmk6a/XVcCPorT?=
 =?iso-8859-1?Q?IHpJsw1Xb0HovAMM8XSs27A3C7H1pBPot5f94C1IUhSXjV3NB9P6i7xjOf?=
 =?iso-8859-1?Q?xqGuS7lo0Y8ASAn0/kWa8+B6O5KLPtV1rx9hZIdwOUijennTh/kvCgGO55?=
 =?iso-8859-1?Q?8J/T8MTtmKkwsBhkN/4ftV0WIzjkV7j9i7rjiCIPWOwMqbix888eYnmXH9?=
 =?iso-8859-1?Q?gzywIpCIUjZhYNWQBAUY+rOhW5hH+Yf9O37+dxYB0a9K0sAruxqSllfI1n?=
 =?iso-8859-1?Q?k066gnYnTOdMcpzN/kjdnkeL8s9C3dy+wo4jFQn7RwZmYoHdEsBN9TQwd3?=
 =?iso-8859-1?Q?iOUHKA4zPRWaww3dvlJVW+SaF9OY6dbuoFuZvRGV1pz6QqEePNMr/QgfHf?=
 =?iso-8859-1?Q?c4N9lKM50+oV/mHCSUKq3CtwgJ/Kwe0m89fooc+zIi2Fg3jlwq8D5Xu1bX?=
 =?iso-8859-1?Q?qzxKWTIYYfnZUjcOMY0BgaYev/Xaa02Q=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?nSmPh8TdOOd90rmyyfkAc9tf+GEYgKGUKEdOgLfB1OGSl90PFDBWurUv+d?=
 =?iso-8859-1?Q?D418wB6S8bStT0LimJ0Kskb8n0Pjubluhj/euoEnE/gZ/C+wgERkljZBZw?=
 =?iso-8859-1?Q?OPOBVVAq/QrAA1LZvbWlP8QeNw3K0EUd9aaBHhSRBBxBqU4MzB5RICcHKb?=
 =?iso-8859-1?Q?kopErTkohHz3cI2s25VenPPaav9T9LHR4CExBlNIpjnDnsakkLUEFafktj?=
 =?iso-8859-1?Q?bZUu1pTOV5qiCeinaU0yvNRla1vKYoBp4WWgwCtH5H4bVPkynTIq2x/OE3?=
 =?iso-8859-1?Q?6byxLtttmUeKCVwoizxJRCzBquZHpz5/CjVuMXaLut8EH+uwoMeR5ucjqG?=
 =?iso-8859-1?Q?erbL8GNyLCJhMqjmtzQ4ZcK2nBROFMCAA2xl3mmJ8IJfODxxDO6xHaCYpi?=
 =?iso-8859-1?Q?KvkHCZFRuAP0+PiNlMfSCmqJa7+Li/4MuHpaBShIyF/rHLg/rfbXL82fIi?=
 =?iso-8859-1?Q?4wDENs6xRALoWLVkowLvY88eabvXAbsZ/7FAT12oUKXrwsHs8wKz/nG3v4?=
 =?iso-8859-1?Q?xKLSU0iOYwf8j21AbL323JYNNcduJKD8+7b5Uzi6cV30zYq70g9JAVbIg2?=
 =?iso-8859-1?Q?QBacd+/aUKqy2IP+iMvpzisDqli+2VHRCO4FVyU1zGhy7I0DYQhW6Adibd?=
 =?iso-8859-1?Q?J065UC4Xyt61rrcVPxh1tvPqluvsDvF9nVcUn63inAQyKIifIi8jGv7fH8?=
 =?iso-8859-1?Q?2VczauVV4oudgecLWn7H5q8+5+FfgW9LnDipjSA14Op6B2fUIh9evCMCTk?=
 =?iso-8859-1?Q?6KilkzaTPh+qPYFtqDIGHIf94hOoZQOl23o/1Hx9c6TrZQMN4MRn4VPhAl?=
 =?iso-8859-1?Q?WSvjRV/xR3Ec2v1Li6H09RGssyZvMJFln+nADDKmZotFkcj6Om4g6aWQwM?=
 =?iso-8859-1?Q?dmbrRQ3SP4nXzd/zDMdz343sQLMHWj2WG9a9mVbrU3awAERvD5Ga4a3Eh2?=
 =?iso-8859-1?Q?U9oLl87j/Pep9rS0KCZkyGeQQC2gON8Ib015C15zwwwHRl2DDIgZN3kbM9?=
 =?iso-8859-1?Q?R/+39hfYkq44w6P0EVDErsZs+Z5J6pXYjAYd/EOKn63CUvgLttptoW7KHN?=
 =?iso-8859-1?Q?lpqKl0clDO8MstYLSKjpl7tY/R1ZX+IMecGHc9pJv03OATYhX4cIVnv5rL?=
 =?iso-8859-1?Q?l0HpRFfcN/QkY2SvN9MD1u/yQhTlE0NzK3JFenTfZvuG9OEekvXkPRXIiI?=
 =?iso-8859-1?Q?0FKjTswMofByB+sdDAXt4modBvgRGmPOiJsmAd0sTlwyyxlhMUbqvjblxE?=
 =?iso-8859-1?Q?I85Wk8jZIwWwCuenBzzkkJGznA4E/9FfAeSRo8gERJ7SZYNEuFmfV9ClqA?=
 =?iso-8859-1?Q?xznBke/7Ihkr3FqVMiugcTs3DAN2GR7Nuaaa2yLLmcLgq6dmDJSFYQuW8F?=
 =?iso-8859-1?Q?2IJUCokz0Vel7TOes2fTbLIFRCY9Q9FcN+zV4ll9Pq+E8l/77IkgPacvWn?=
 =?iso-8859-1?Q?VexUryQiMFqtNjeAyzXhzuz7s5LUymGKBd64DaYVm13TRhI2E2qqkGFm9B?=
 =?iso-8859-1?Q?cTM/0M6wMZIHS/ED9ju7shETh9kxr72xcvZucrS/3UiUpnbabB+/AswkAG?=
 =?iso-8859-1?Q?4qWG4iITJjHihIgmf+V9KY/t9MeqP5v7teEpABLs9tEVlyQGJ5+DEnxoFd?=
 =?iso-8859-1?Q?NXqhQ3iaHVjYY=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 3465ed3c-052d-49d8-c800-08dce769f521
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2024 07:22:24.9968
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WQmTtftmrZJ4so4AU6ELAMDVrfXxTVRWaprvHpScpqVbg+uBzbTuXQJVtU1k7rKrgy4kvtKGKjHyBvw/9Edxrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7623

>>=0A=
>> Hi Alex, the Qemu enablement changes for GH is already in Qemu 9.0.=0A=
>> This is the Generic initiator change that got merged:=0A=
>> https://lore.kernel.org/all/20240308145525.10886-1-ankita@nvidia.com/=0A=
>>=0A=
>> The missing pieces are actually in the kvm/kernel viz:=0A=
>> 1. KVM need to map the device memory as Normal. The KVM patch was=0A=
>> proposed here. This patch need refresh to address the suggestions:=0A=
>> https://lore.kernel.org/all/20230907181459.18145-2-ankita@nvidia.com/=0A=
>> 2. ECC handling series for the GPU device memory that is remap_pfn_range=
()=0A=
>> mapped: https://lore.kernel.org/all/20231123003513.24292-1-ankita@nvidia=
.com/=0A=
>>=0A=
>> With those changes, the GH would be functional with the Qemu 9.0.=0A=
>=0A=
> Sure, unless we note that those series were posted a year ago, which=0A=
> makes it much harder to claim that we're actively enabling upstream=0A=
> testing for this driver that we're now trying to extend to new=0A=
> hardware.=A0 Thanks,=0A=
>=0A=
> Alex=0A=
=0A=
Right, I am also working to implement the leftover items mentioned above.=
=0A=
The work to refresh the aforementioned items is ongoing and would be postin=
g=0A=
it shortly as well (starting with the KVM patch).=0A=

