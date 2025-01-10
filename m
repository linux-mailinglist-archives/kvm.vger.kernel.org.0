Return-Path: <kvm+bounces-35111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61FC3A09CC5
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 22:04:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5D9731682F0
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 21:04:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FE042080DA;
	Fri, 10 Jan 2025 21:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rB5Rx2Eb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2045.outbound.protection.outlook.com [40.107.92.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABEB124B25F;
	Fri, 10 Jan 2025 21:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736543051; cv=fail; b=fu5vdGZQtXHyZ8KIuY8u2IRzwmCcOnDKNy7cmlxniOQSwgdUEtpc2b9DcJ96lYM6OwRwV+NVX/XyaHYVG4/V10QA9l56IeL5EXTpPBjvrX0ME9DY5Mgy5cy/+MuwmSwbVGbQn9KCxpLrM31vw9x3bgNrTztqqdG/Nc3PHFluSkA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736543051; c=relaxed/simple;
	bh=DcDHt+iH8LMg+eXhtJ63HunM1FQy0MLLHA+JCCh54Zg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=E5ZIXiXVbjOb2ZUmLADGa0CjB4zxZyLoo9BRCWnoK3JZWmurc23PbUNTbGjxRf9lMuQVZvE07somTW6JjENWJY38F4HSD5UtQ0rpitPtuVD0M65jTrKO/hfAWpbKo0jMFoKLXOF6d9FXUjHMfaxvCCPY0L+UoNwhwLcCcSOnESk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rB5Rx2Eb; arc=fail smtp.client-ip=40.107.92.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h6k7CWckVZsJL5hHHxzTaNVjwSoS18F8BHEXhF5qCaZ3V29qniiGindxdMKbXyihwy3Mce1Yrb4fch7tCmKPwZVDt5yNvq/E730CdcXG4h6xAM2q18Wi3qMSb+nVuAtqchznkd4oD5G0y1zvrlamarKBEcp0ii7wS6iiTn9PlAU332dTqTfmq5Y+geDRRT6xNlgf7qevROnNqMD+YJ8eq/ziuzC2RS5KV98/JVkIwka5Xhw1/6TBQ4u6rIeCitxedoV+FUOk/bIsCXVd014SrB9fB7P3VqnJ61EiaLBIowFSK2mE5CsDSLMxCskhluukxGG2w0UdQu8XGWNyowSnbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DcDHt+iH8LMg+eXhtJ63HunM1FQy0MLLHA+JCCh54Zg=;
 b=FMMTPbk9sya6F1RyUQHrHQG5tFC4BdNU8nZxueMeZpL/IdOT0GH9MoJIYvoDu93zVdrb58sz99Fu3MJts/wQz0oQJSPqseq1R40kUHpZU2jJSX7XPtXpxftjQJ4ZhWotCmLlKL7CDUscCjwwzclGnDQd1pcEu9Fva629V5PggqliR3CySYnIWpTUc0idTSmpURdfMEibSi8yybr9/4LCjz3vA1b/wI0OF0GyN/3lZGnc2c5PoUx0J971XNkCR+Zq26sTGTx+AQiNl6bw+vhK7Wo47d+r1Bm6N1PdLaKcg64uRvSAhKG4XTjtZnCcEPz8IxifS/yWx9f1PSQ3smWqPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DcDHt+iH8LMg+eXhtJ63HunM1FQy0MLLHA+JCCh54Zg=;
 b=rB5Rx2EbNJLckdTAhgYP7RE0F+6msNkNrbKCk/xKVTlIoiSZPF7V3dmd8AdrLHQrPnXYCVlF7NdXY8uefGhe1v8Zb8jbcQVF0pVLU4RPXaXyUuMy5FMELALYPXqquTKlzNPuOqZmTb9z7ppzidg7aUM75lYyrPJbr/s/yeiElDOD0x4EMigWer2TMatAcKucCFK/nUyuDPmnZvby3t24Vvb8srZ+cBIGVMkWOEPnvehfXESAbxXvWhhrHB17ioj79nJtO4G6fXj4XgNwOhOBLIJsv93vAYogWJxXRFV9uVzXUJD4oEw1kOm4tuWjwbQ8qQEh+4PKzaV4kM1b9hi3VQ==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by DM6PR12MB4060.namprd12.prod.outlook.com (2603:10b6:5:216::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.14; Fri, 10 Jan
 2025 21:04:06 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%4]) with mapi id 15.20.8335.010; Fri, 10 Jan 2025
 21:04:06 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "joey.gouly@arm.com"
	<joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "will@kernel.org"
	<will@kernel.org>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"shahuang@redhat.com" <shahuang@redhat.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, Aniket Agashe <aniketa@nvidia.com>, Neo Jia
	<cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy
 Currid <acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John
 Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, Zhi Wang
	<zhiw@nvidia.com>, Matt Ochs <mochs@nvidia.com>, Uday Dhoke
	<udhoke@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"sebastianene@google.com" <sebastianene@google.com>, "coltonlewis@google.com"
	<coltonlewis@google.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"gshan@redhat.com" <gshan@redhat.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Thread-Topic: [PATCH v2 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Thread-Index: AQHbObyY4gofHx3CJE6tGYAUqrUkhLLhvSCAgC7sTkE=
Date: Fri, 10 Jan 2025 21:04:06 +0000
Message-ID:
 <SA1PR12MB7199AF5268C8384F9DAE3B50B01C2@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20241118131958.4609-1-ankita@nvidia.com>
 <20241118131958.4609-2-ankita@nvidia.com> <Z1oL1yZtdvGUIW9h@arm.com>
In-Reply-To: <Z1oL1yZtdvGUIW9h@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|DM6PR12MB4060:EE_
x-ms-office365-filtering-correlation-id: 8234d61a-4a62-4f34-c7e1-08dd31ba51c8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?nLUH98J6SAzXtOx7U8Sz3WdxRoijR2Lh407f/F2VT1rhMFjFmOFJfCDJKb?=
 =?iso-8859-1?Q?FO9wCDz+D42CTQMMr7eM38i+DmJVYGJ80ayXvOQctIusNT7a+h5cl+ZRcu?=
 =?iso-8859-1?Q?xHv6guqeeH2+St6HaZclNg2d7jCYNoNdC+ECxKeCqvY/2V+mons5u2/5PY?=
 =?iso-8859-1?Q?ECbjfH0ka5iuiQ2YlbQOt/u9JsSJQHH6wAG6+xB5YY/94MyNii6/qabZu+?=
 =?iso-8859-1?Q?62r4Y6SKkxFgw5wAXMzVbNizPs74UWI/SqPknZlI9y6BVodKE/cpuj55F1?=
 =?iso-8859-1?Q?wDGRbq63f3aN+jwJyzcj60c2LzR5jVhxyZ4GCvhB+7m/iNUJDVKPLaCaML?=
 =?iso-8859-1?Q?Y5T82y06YvIsgKviKMLOJYth/wWWUxcWDueA932KlgZAegxL1NAQrdYMTa?=
 =?iso-8859-1?Q?rPJMYRitMb+6etc2FPVs57bbii5qlRr+EiT9X+WZlQ7fIhsRqWMRy7Rigx?=
 =?iso-8859-1?Q?T+vKzGfPCLnvdCfpxQR3PFiE51lnc29Pv+mQDPpSIq/NKhNsUGgfytP/Lb?=
 =?iso-8859-1?Q?571zeBd83SMeu/VOlpcLi7ZKhosMN2hgj94LDvPXPXzBUDjUYe91cUitS1?=
 =?iso-8859-1?Q?5x8LqL1QEvhQUHdWKrB+Tg/BIIHkBmJ6YNC6hyC5vnQwWHJ0wglYbwHBEf?=
 =?iso-8859-1?Q?2RP5U/vIZy/AWhgsmZUMV1fpclaukQkKDgtzaTXnk0ZRYfspz4TysJH2Vq?=
 =?iso-8859-1?Q?tUFPbO3UDBg92LlaBQ8Y/VwjKZRGSdKxW9BA8Wg7LCldmxM90ZX6TPKPPb?=
 =?iso-8859-1?Q?cyGRuGfz7ZhlVTW5XRgboJz59UyW4XsqzyKup28UTNgu0TR++GzPiv7VQw?=
 =?iso-8859-1?Q?39F5+hpCJE7yD5/lrqAndSeyjqnKDclGkjGShKdwPV4vUHp41H8u/J3qaj?=
 =?iso-8859-1?Q?iR6IdoiZGatbKFKBny6ZhToT68aut/DOmbVso8wfZ44MBt6I6Fp8uWHTNw?=
 =?iso-8859-1?Q?I62MYWlUr3G/gu5F4YEmxx08B4dtGL3b47RtMWzeiiJb7jUGKKn8V4ekSf?=
 =?iso-8859-1?Q?QkaI3hqJH7iMWZLjkE0JghkKqrgu4YAvsySMHr2JmkDSGHhzjZG3OItp9C?=
 =?iso-8859-1?Q?Nrr0jhn3H586EpJmVnM0X0SSnRLqYW4sr31vCV7h/1SsOQJNZXJz+TUJIN?=
 =?iso-8859-1?Q?5Fbc2uv3ynn8zaLFiWgB5idLHRu3oYWUbF/pDL5ISJU4FnjY2Z5TxHl9/p?=
 =?iso-8859-1?Q?/XydCAFyxT/ZXnR7RA21/tmLaBip4ebXLGDe50nIdcOzrv7KBETKCkeDw6?=
 =?iso-8859-1?Q?M8NirgBtzJMWhYfdfRTjb/G/ylbJUDU0Hm9xlwH5cR/A/YpfmqGtvJ5FTP?=
 =?iso-8859-1?Q?pUKinyCD7t/QPU6X/00cBl/t15I05zTeh2eOeFwi0ZLR4ad84B0v4jmG4E?=
 =?iso-8859-1?Q?7BPAGu/glIb+yKZG8EpXPswyJmXOl0frun1zMYqKm2OwqHwDQvddLjQgnh?=
 =?iso-8859-1?Q?fjljKdPjcqhfwPMCLtq+i5SjyBheM/SQKiossN2Y879ZzK6q+4hOsSJLdG?=
 =?iso-8859-1?Q?Akjlt+9CS7EjrdlmYYMSd3?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?WtkAmijE2lkL94XPoLhZoXZ7OTXRFy2Ss+SfiF+AnwgVzKUHC/zh/w+8XC?=
 =?iso-8859-1?Q?63D/530B9CjNGZmwK038OD7dnS+cJaktoxAXlCYmzj0N4Sy8g6AA7jdoXX?=
 =?iso-8859-1?Q?fhxapjupiSe7TREixJWdIu29rFCNO2O3rTKgnjaYF90FJeuA+WMZebv1yv?=
 =?iso-8859-1?Q?JDd2nysfrlCM5ewwneuoJuHr8fp4oe3eu0N8AdEUV6KatwfZMN4CMPwD+I?=
 =?iso-8859-1?Q?eFZ3PhF3gugwWH6HxdKJHsuJCK7izqBjsC3j95dHna6OK4iLbm06Jw0Ukp?=
 =?iso-8859-1?Q?S1SG1z/cH24ScXaI20i3apf+I1aMK7KrZozadeEMxhK/+4LSmQHlIb7VMc?=
 =?iso-8859-1?Q?+lofUHhXOydj2XHOZgotwi1owF1bfoitoVHXRgLTrtQWxRJkoY2Dax15dE?=
 =?iso-8859-1?Q?qrOdcDN19NAemL8NnYKcupvws330zEadknd2BiSW5+E9+ROypyjh6Twc+a?=
 =?iso-8859-1?Q?7JIa/uFHwhNBn2z/uEY+5lDdbcIdgPuMUUnGSgjkO8nEhdA11cD/gnymIm?=
 =?iso-8859-1?Q?vYMmNc/5efHWWEccnMwwZOAjPwtAVpabmMKG6LJPEV0ia3ii+Izs06df0w?=
 =?iso-8859-1?Q?ZOSGED1dU+3tXTzbahCrHlVnwj9c4c2TY/wGfcwP3/9DALqt3nGO1tZAUg?=
 =?iso-8859-1?Q?olzW4N5+g5EaMWU+SnQlGbY0OY+RvnpWaKNvH+UBeay+uV9jMW+CbVgNRl?=
 =?iso-8859-1?Q?wlK0ENMgpqhj6OGyhywZTrTQJlDr7mlNpFqoTcl2bme+5gHj0RfnxPpeEJ?=
 =?iso-8859-1?Q?AMMlhM1eZ56RyAUktAEsER9UrWPuj4F6v2KfuPuVPNeh9cilPvdQt3dW9J?=
 =?iso-8859-1?Q?MyjDhJttZeRImeSt8BDO317+lUESbtzbxSMiQxZXWY7YQDIes/DCFnQee5?=
 =?iso-8859-1?Q?ONA9/HNg6U9fEAVcwNzw7CasR1tkDv/DDii/pts+2DMqNWxeKAGX0ord46?=
 =?iso-8859-1?Q?2SR1d4Q8k2JJetT9cFtbt/O0IkZLYRJ0v8JkxMwtiuG/FXBaLcNh109XUN?=
 =?iso-8859-1?Q?Ord0mDL9hEnW4oZZR60kpuSRsU6Pg1smUwEw/EhYztvQbTP9qr/SnRgHrQ?=
 =?iso-8859-1?Q?BqwNBgxaVz6mCR31aI30sNvW/gOG7mfiCVNRjYwgKHHZnuEuvfZNP78Nml?=
 =?iso-8859-1?Q?E9F4jYgelbjlrJ2/SH/1L4NGqzXBfaXOl2tr1f+9TWrzZAjzr8CtP3oAZE?=
 =?iso-8859-1?Q?3wrNGxMxlRSISbUOY1+yvFTHuE5tpYhuisyOh3eaUNg81Dsc1fOS//RWf5?=
 =?iso-8859-1?Q?Zbe9Ot/7YKzRJ2D2gFIntCr1ZiPIinfOmrfjrZEa+xR1NK0xqzzN+C2DiY?=
 =?iso-8859-1?Q?t1FK0zulVSeRJJZjfo6Z+B+29SsHouFcbf0dCJ+R3rjKbe7yPjXhzYvHJr?=
 =?iso-8859-1?Q?mP5/KEx6eLXqXiKhColf7jFyr0v4ObZvEL0N6AfPodGC3Y3j17H5Tk1942?=
 =?iso-8859-1?Q?X3Sz/iAGOdQQyHGZnb3hCPSOVFttWx0EkZ+YUHSf9o6cSDu3Sy6+cVYU9M?=
 =?iso-8859-1?Q?65boIY0uiRcEe0at7EWBFDmb0tbVmFF1USFN8youRFUJaRB778nZ8CZ+Ds?=
 =?iso-8859-1?Q?7m++BQA7NtA8xO0EWbu2T6PSozPd3YYESSHbi1NlFd4h1Uiad77eTuDcfa?=
 =?iso-8859-1?Q?dc64+vHWSzWPI=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8234d61a-4a62-4f34-c7e1-08dd31ba51c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2025 21:04:06.2072
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mw9RiQPGgjgHi4fgMRXuRMBokisKeAEkm8AKJ/jVPEIrGEDEmeGrCQLtJvSVb+ppiZRzVlEqzTgDZkRgZQjZ7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4060

Thanks Catalin for the review. Comments inline.=0A=
=0A=
> Please note that a pfn_valid() does not imply the memory is in the=0A=
> linear map, only that there's a struct page. Some cache maintenance you=
=0A=
> do later in the patch may fail. kvm_is_device_pfn() was changed by=0A=
> commit 873ba463914c ("arm64: decouple check whether pfn is in linear map=
=0A=
> from pfn_valid()"), see the log for some explanation.=0A=
=0A=
Thanks for the clarification. So, it appears that the original pfn_is_map_m=
emory()=0A=
need to be kept. I am getting the impression from the comments that we shou=
ld=0A=
only add the change to extend the cacheability for the very specific case t=
hat we=0A=
are trying to address. i.e. all of the following is true:=0A=
- type is VM_PFNMAP=0A=
- user mapping is cacheable (MT_NORMAL or MT_NORMAL_TAGGED)=0A=
- The suggested VM_FORCE_CACHED is set.=0A=
=0A=
>> Also take care of the following two cases that prevents the memory to=0A=
>> be safely mapped as cacheable:=0A=
>> 1. The VMA pgprot have VM_IO set alongwith MT_NORMAL or=0A=
>>=A0=A0=A0 MT_NORMAL_TAGGED. Although unexpected and wrong, presence of su=
ch=0A=
>>=A0=A0=A0 configuration cannot be ruled out.=0A=
>> 2. Configurations where VM_MTE_ALLOWED is not set and KVM_CAP_ARM_MTE=0A=
>>=A0=A0=A0 is enabled. Otherwise a malicious guest can enable MTE at stage=
 1=0A=
>>=A0=A0=A0 without the hypervisor being able to tell. This could cause ext=
ernal=0A=
>>=A0=A0=A0 aborts.=0A=
>=0A=
> A first point I'd make - we can simplify this a bit and only allow such=
=0A=
> configuration if FWB is present. Do you have a platform without FWB that=
=0A=
> needs such feature?=0A=
=0A=
No, we don't have a platform without FWB. So I'll check for FWB presence.=
=0A=
=0A=
> Another reason for the above is my second point - I don't like relying=0A=
> on the user mapping memory type for this (at some point we may have=0A=
> device pass-through without a VMM mapping). Can we use something like a=
=0A=
> new VM_FORCE_CACHED flag instead? There's precedent for this with=0A=
> VM_ALLOW_ANY_UNCACHED.=0A=
=0A=
Ack, this will help better control the affected configurations. I'll introd=
uce=0A=
this flag in the next version.=0A=
=0A=
>> Note when FWB is not enabled, the kernel expects to trivially do=0A=
>> cache management by flushing the memory by linearly converting a=0A=
>> kvm_pte to phys_addr to a KVA, see kvm_flush_dcache_to_poc(). This is=0A=
>> only possibile for struct page backed memory. Do not allow non-struct=0A=
>> page memory to be cachable without FWB.=0A=
>=0A=
> I want to be sure we actually have a real case for this for the !FWB=0A=
> case. One issue is that it introduces a mismatch between the VMM and the=
=0A=
> guest mappings I'd rather not have to have to deal with. Another is that=
=0A=
> we can't guarantee it is mapped in the kernel linear map, pfn_valid()=0A=
> does not imply this (I'll say this a few times through this patch).=0A=
=0A=
I am not aware of such case. I'll restrict the changes to FWB then.=0A=
=0A=
>> The device memory such as on the Grace Hopper systems is interchangeable=
=0A=
>> with DDR memory and retains its properties. Allow executable faults=0A=
>> on the memory determined as Normal cacheable.=0A=
>=0A=
> As Will said, please introduce the exec handling separately, it will be=
=0A=
> easier to follow the patches.=0A=
>=0A=
> The exec fault would require cache maintenance in certain conditions=0A=
> (depending on CTR_EL0.{DIC,IDC}). Since you introduce some conditions on=
=0A=
> pfn_valid() w.r.t. D-cache maintenance, I assume we have similar=0A=
> restrictions for I/D cache coherency.=0A=
=0A=
I suppose if we only do the change to extend to the aforementioned case=0A=
of the following being true, the check for exec fault could safely be as it=
 is=0A=
in the patch (albeit it has to be moved to a separate patch).=0A=
- type is VM_PFNMAP=0A=
- user mapping is cacheable (MT_NORMAL or MT_NORMAL_TAGGED)=0A=
- The suggested VM_FORCE_CACHED is set.=0A=
=0A=
>> +static bool mapping_type_normal_cacheable(unsigned long mt)=0A=
>> +{=0A=
>> +=A0=A0=A0=A0 return (mt =3D=3D MT_NORMAL || mt =3D=3D MT_NORMAL_TAGGED)=
;=0A=
>> +}=0A=
>=0A=
> Personally I'd not use this at all, maybe at most as a safety check and=
=0A=
> warn but I'd rather have an opt-in from the host driver (which could=0A=
> also ensure that the user mapping is cached).=0A=
=0A=
Understood, will make it part of the check as mentioned above.=0A=
=0A=
>> +=A0=A0=A0=A0=A0 * pfn_valid() indicates to the code if there is a struc=
t page, or=0A=
>> +=A0=A0=A0=A0=A0 * if the memory is in the kernel map. Any memory region=
 otherwise=0A=
>> +=A0=A0=A0=A0=A0 * is unsafe to be cacheable.=0A=
>> +=A0=A0=A0=A0=A0 */=0A=
>> +=A0=A0=A0=A0 if (!pfn_valid(pfn))=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 noncacheable =3D true;=0A=
>=0A=
> The assumptions here are wrong. pfn_valid() does not imply the memory is=
=0A=
> in the kernel map.=0A=
=0A=
Understood, thanks for the clarification.=0A=
=0A=
>> +=A0=A0=A0=A0 if (!mapping_type_normal_cacheable(mt)) {=0A=
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (vfio_allow_any_uc)=0A=
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 prot |=
=3D KVM_PGTABLE_PROT_NORMAL_NC;=0A=
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else=0A=
>> @@ -1684,6 +1725,20 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, =
phys_addr_t fault_ipa,=0A=
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 prot |=3D KVM_PGTABLE_PROT_X;=
=0A=
>>=A0=A0=A0=A0=A0=A0 }=0A=
>=0A=
> I'd leave the device check in place, maybe rename it to something else=0A=
> to distinguish from linear map memory (e.g. !pfn_is_map_memory()) and=0A=
> only deal with the attributes for this device pfn which could be Device,=
=0A=
> Normal-NC or Normal-WB depending on the presence of some VM_* flags.=0A=
> Deny execution in the first patch, introduce it subsequently.=0A=
=0A=
Ack.=0A=
=0A=
>> +=A0=A0=A0=A0 /*=0A=
>> +=A0=A0=A0=A0=A0 *=A0 When FWB is unsupported KVM needs to do cache flus=
hes=0A=
>> +=A0=A0=A0=A0=A0 *=A0 (via dcache_clean_inval_poc()) of the underlying m=
emory. This is=0A=
>> +=A0=A0=A0=A0=A0 *=A0 only possible if the memory is already mapped into=
 the kernel map=0A=
>> +=A0=A0=A0=A0=A0 *=A0 at the usual spot.=0A=
>> +=A0=A0=A0=A0=A0 *=0A=
>> +=A0=A0=A0=A0=A0 *=A0 Validate that there is a struct page for the PFN w=
hich maps=0A=
>> +=A0=A0=A0=A0=A0 *=A0 to the KVA that the flushing code expects.=0A=
>> +=A0=A0=A0=A0=A0 */=0A=
>> +=A0=A0=A0=A0 if (!stage2_has_fwb(pgt) && !(pfn_valid(pfn))) {=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret =3D -EINVAL;=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto out_unlock;=0A=
>> +=A0=A0=A0=A0 }=0A=
>=0A=
> Cache maintenance relies on memory being mapped. That's what=0A=
> memblock_is_map_memory() gives us. Hotplugged memory ends up in memblock=
=0A=
> as arm64 selects ARCH_KEEP_MEMBLOCK.=0A=
=0A=
Ok, so will replace the pfn_valid with pfn_is_map_memory. Did I get that ri=
ght?=0A=
=0A=
Apologies for being slow in getting back.=0A=
=0A=
- Ankit Agrawal=

