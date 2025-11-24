Return-Path: <kvm+bounces-64402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 325F2C81631
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 16:39:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 336F134297D
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 15:39:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AA26313E14;
	Mon, 24 Nov 2025 15:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Jz/vnWMq"
X-Original-To: kvm@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010040.outbound.protection.outlook.com [52.101.201.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939A43054CE;
	Mon, 24 Nov 2025 15:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763998789; cv=fail; b=VPRX9aSkNzai8024t0UJZvyW9/9lsMygZSmPhsgLcmr+Cnve3dRMnJ7aD2HYJ95V82sItpXKs6QyfpDt1JPu2gUvHnYT6fE4O7qxkJqwn9Xc1IkrUCEMr3OyOHpP7x+/+94+hwW+U586KLmgobrIyikrE3g0+ZB3CgMGkMqgjxI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763998789; c=relaxed/simple;
	bh=50KtnbseJxoj8RkJc1/8/mcIor+gFi6POgvd4eCtasU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tfHHjRmP5v+NU5fBvQytiFAyERRx9Pih4FktNTARjvPD8BzrKpF+3eUKAUBziZDpg+oCZVPJYMQiBKfEH4yOWMTR5pz8HHS+E355eA/wdnflbsLtDuvHo6BD4qfiFmGbJsw2cEugnFNjJIt4fA5LmMVkEtrDc2tuA3tA0zz81/Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Jz/vnWMq; arc=fail smtp.client-ip=52.101.201.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O8NSPA2oJCKdIlyOK5Bu9I6T5raccaiLesIg2lmpOXuLI3+wrjf19kxpV4HiD2WTd4AwxNDCCBBLRAZVbAP7RGxE+FytGYY8lsUu55WnnAZpxH6gqg7bnGwEAnKDwNzIfM9n9Oq0U5uAs6LzCMTssshpv9/jZGV/sOpD7313/POcuY7NEi/GaDqZUomS5qBJsmABZjvHEeKzxK7Oc0d7dO61XP9gx+4CzYzTEHCtzGTjAsaGGJ4Z8I0men+o9HocS28sGbhne1HmKM/DQP9Qi4N8Y++jCMuR4UK+hb8rgEyrcESnTSr+Qew+Zdf4A0DGitULgDysdkoDOZJw/uP67Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=50KtnbseJxoj8RkJc1/8/mcIor+gFi6POgvd4eCtasU=;
 b=V+u81ye5S0zclKoQvBqK1cZIlSoHmfscapzcQAKNTyzeO27KLQ6hvPNZzTWTvOdRAshQfeZaXA/U7tT7howA9ZQa07+huNfYVSn3XZ0ql6lDn2FV4/71zh35iBarAV48jAJ3G/CmDtLj4jK7XiBs8o6D5OQmGN6FiRN/4+nU8bnfPwqG15B/ooBQktB3sTU4+rzsEDEfMADjOGGQ/qU3fLAMPYkwlI/XbF8UtgjEmjCCmvU1emNh3agok4r1pC8D+w7WxDRf8AkS9Dg3HyjmJaNUYF8Ylp+SEW3kfSIl4Y3NuPpoJU4ASqYNcCfYsD5mGvGW2ICg1HcyV8DQbsst/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=50KtnbseJxoj8RkJc1/8/mcIor+gFi6POgvd4eCtasU=;
 b=Jz/vnWMqjWYFCVrTIjat0lmLUUqwHGQRa4rp5hxU63L7b5nMyMy1R+RrMSpJu8Czz8TUpH1hcX5t29yPQLuEy+0NNAoe/5GFpSHK9+8bvhwYwdLI9hvkai7EMkCu0ZgBQp7BVqcxnLbmUB3c23wgkEmQSsVFf7LFDDulFEPKL0Hxcsf7X4mjDMo+HN3ldFfO1YsNPEMLDut/fqAxYzsTMQY+xMsPDN3q5C+qIOqjbHeZxra3ijXhelWJ/FH1Rrku4CGprLx94yDgcoPDUcDeMQLCnyo0qVlyg+0ZZm8w9GpUnRORVRdShsmTRuHROgiiVCQ59vS/EngLD8nGIuwRFA==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by CH3PR12MB8306.namprd12.prod.outlook.com (2603:10b6:610:12c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 15:39:43 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::928c:89d8:e8d6:72dd]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::928c:89d8:e8d6:72dd%6]) with mapi id 15.20.9343.009; Mon, 24 Nov 2025
 15:39:43 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Alex Williamson <alex@shazbot.org>
CC: "jgg@ziepe.ca" <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, Shameer
 Kolothum <skolothumtho@nvidia.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, Aniket Agashe <aniketa@nvidia.com>, Vikram Sethi
	<vsethi@nvidia.com>, Matt Ochs <mochs@nvidia.com>, "Yunxiang.Li@amd.com"
	<Yunxiang.Li@amd.com>, "yi.l.liu@intel.com" <yi.l.liu@intel.com>,
	"zhangdongdong@eswincomputing.com" <zhangdongdong@eswincomputing.com>, Avihai
 Horon <avihaih@nvidia.com>, "bhelgaas@google.com" <bhelgaas@google.com>,
	"peterx@redhat.com" <peterx@redhat.com>, "pstanner@redhat.com"
	<pstanner@redhat.com>, Alistair Popple <apopple@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Neo Jia <cjia@nvidia.com>, Kirti Wankhede
	<kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>, Zhi
 Wang <zhiw@nvidia.com>, Dan Williams <danw@nvidia.com>, Dheeraj Nigam
	<dnigam@nvidia.com>, Krishnakant Jaju <kjaju@nvidia.com>
Subject: Re: [PATCH v5 5/7] vfio/nvgrace-gpu: split the code to wait for GPU
 ready
Thread-Topic: [PATCH v5 5/7] vfio/nvgrace-gpu: split the code to wait for GPU
 ready
Thread-Index: AQHcXTnXSSxQebA9G02TVYJzeLcEIbUB9LqAgAABL1w=
Date: Mon, 24 Nov 2025 15:39:43 +0000
Message-ID:
 <SA1PR12MB7199FB886E677BFF7B78143AB0D0A@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20251124115926.119027-1-ankita@nvidia.com>
	<20251124115926.119027-6-ankita@nvidia.com>
 <20251124083249.3316c6e9.alex@shazbot.org>
In-Reply-To: <20251124083249.3316c6e9.alex@shazbot.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|CH3PR12MB8306:EE_
x-ms-office365-filtering-correlation-id: 187d3596-e8b1-42da-dcbc-08de2b6fb063
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?mlita0x50KtlVjkwz2XeKb019If1bK3YfH/0OTO5VSXe/ibf4uYEeLN2if?=
 =?iso-8859-1?Q?oQjhetjxtiP7i28S5faqQwJ3ovyC6ql4TpRaq26UvgJV3lK3/cU7OzRCqn?=
 =?iso-8859-1?Q?B36sO5i8n4k91iqoLdHXAxXPCGrAdV5M3bjFrz7vwhs2BzboUDcvId88Wq?=
 =?iso-8859-1?Q?A2VlzRxFT7XjAyGyNVVpTxQAxMFQhPQRknjFIAEQo4DFsLfoDun7e7JfIA?=
 =?iso-8859-1?Q?WPfDG8e1yVjtml6/6JUQtc1kv/oBAOZmNSwBuZZi+O2MRSSjL/YkrXPx0W?=
 =?iso-8859-1?Q?dx82sRgYb1yXordI7wM5p3QffD7XZbkqKWG3qKuQ2oLdWZ4LZoD6wAvHFx?=
 =?iso-8859-1?Q?JRhkjv59/zP7zQnGN2DNl0laN5iDK2Z4yiperv/NWyUTY1+V4Ff3xf8rVn?=
 =?iso-8859-1?Q?/Ffi3AZPv2rZ7wKkWQS1z16k7ahBP5xXGuqXLi0Vp8Mb1+8RJ31sATynKG?=
 =?iso-8859-1?Q?zxRwKJlJ1z+IDYfzdsGGui24HtYmFPT3PIcqsFZHlPAyQ2beEfJ7C/5ZHB?=
 =?iso-8859-1?Q?Ij4CNt51U8QB8nCxRdhzTfli+hlB+F+iKb44reme+92AFP6GaR+pGkGzpe?=
 =?iso-8859-1?Q?o4HY7aEhNtHB3dgV8c9OYcH8s2nkiu4kg7DcV0ODSWiHtTA2wc5vccG8tt?=
 =?iso-8859-1?Q?tdUc/al7CW/tgvp6Xn4j7ANk9tzfAR1DCj31ONkS66qbJWhRGJfmAV0KH2?=
 =?iso-8859-1?Q?Pt4vlh6/gEVveNq5ac3W3z4DVeQ4ULy3RZ6mtk5cbCFTo4iQ2A71UWr1Zw?=
 =?iso-8859-1?Q?p8Uo+Dxp5s6UMM980OKzhGllbEC4wjd8kbcxMgDoF25yeZobOSFR3uRnhZ?=
 =?iso-8859-1?Q?kVle1UpjNqxsR6+EcmWenkEK62L0hdApZ/HTDNgsmtsTzwH1CKvM3z5v75?=
 =?iso-8859-1?Q?S3L9RXYx2Zae83ewOUgG77unBTq/p8jzu0IN96bmAVzOBosYn5rSwEV82R?=
 =?iso-8859-1?Q?6H589nuIbgv6nF6UGeYHRbZPjwaEWp6zSQvN2A9Vq27LMH4hz6jUZNViLC?=
 =?iso-8859-1?Q?oPhQXEu/4Ne72LE8fVxa7zT+pwVm/4lDqm7mJPrIsldyS1S2J0Eh1221iU?=
 =?iso-8859-1?Q?bv4C3LBwZyPgrY2WGxg8/CGcIPO1zaZlLMptgf3ecz8pRGDHoELO/Z5Ozx?=
 =?iso-8859-1?Q?GsUIBW4J8GHwd5NCKMYJ7AoDAV+vqxMc5C/WkEo6NdE+ET3xBcleCg88iX?=
 =?iso-8859-1?Q?tQQ50uh1EJ14um7NLr0eVdqnJ+LojSLOQYZvurqLvhYRAkxDY19jRU84XF?=
 =?iso-8859-1?Q?wa3DbqlEgOCBNLbPeb8qjiWqCIt20FTIHpWlFRZeTIcvKYXhPSe29W2wJy?=
 =?iso-8859-1?Q?oLeZZ0wdjV+CzSXZRJkqOaSDYY2QHaywsj/3rkntjGkEmG2vn3VE+KLtmS?=
 =?iso-8859-1?Q?3Y/RVY4cBupPayMiV67oYTxVDcSwmxMzTK/IG3te9svDPXYc99jMMyinJi?=
 =?iso-8859-1?Q?HBy6YijUYdziPoNISHm8yM91BbT9UBItCLTrVvo0n5iDS/Yz4doCioZN4u?=
 =?iso-8859-1?Q?DECDXKuK5Vp3thLRF5Fj8A3nowQz/tRFq0svgaFva/MZLxLKRTJajjsGyC?=
 =?iso-8859-1?Q?3QWpGyV5BRqWvRX13QxkortyTp9x?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?482EsSvkXsP3MchIj8FeTgUdexuB+etYwHsWuRDPOnja7dYYIGuhIPGQ9d?=
 =?iso-8859-1?Q?ese1kvELnSf1zJqP/hIQCzabdUe/KcueQiLQ295FSStJLCUaeJ57PlZJgt?=
 =?iso-8859-1?Q?05gfw6Sr4YD8x/1f1xhsGBe1eICe3EuQVTnaJoehs7QXDjtfBUP3uO1NkZ?=
 =?iso-8859-1?Q?6foRcdH2L4Vws3FAghwMQ1rbTXVGZ900KE3iYlt4Jt0MkJyH0hD8Sai1jL?=
 =?iso-8859-1?Q?ietjec2GvMj25LPyl+O2q4BYivrtn522yZbD9tp4OEoRNWGNNjd4hv3nrR?=
 =?iso-8859-1?Q?EMJoRLrQNYajZTIoZxmTsOw5Q+A76jFY117RqPbfsjd3BY8VPVrIGSPa7r?=
 =?iso-8859-1?Q?YLen5C9i/bYdTl/2N/hrDnUcHU47aKqj2W3X/SjsGhmAQ4/Bn2GejnboH9?=
 =?iso-8859-1?Q?/3I3qBAA5GfS5eLs7MuTIhGUcRNDSLpfRsokGiHXSZ54cT/E0iYM5649YC?=
 =?iso-8859-1?Q?gEpx8GfAy4zNz004RTedSwhFY13+RFBzQUYpAJAn5W2v5nP3XQBKOLwoqi?=
 =?iso-8859-1?Q?LbCoCWmOZr4S3BCRaYl7FzE6iVs+wnkANYHStlpWZWd4c1QJ7ObasfAKd7?=
 =?iso-8859-1?Q?o92ARUXs9oXnubbORkHi+RnDN1qOCeZ5lkcO9Mn9xop1G8WKRUEzPy8zpO?=
 =?iso-8859-1?Q?ASyNmXFtYl9BUqSmr55GfpzgEpH01jTWWhI4uguzLpnUXYZVJkrvZjcdfe?=
 =?iso-8859-1?Q?EF+kY7uuI3Yjd3f0oUwmZPBsoQbYH0HCwO828S3sez5CQZlIfXjhQwJcN/?=
 =?iso-8859-1?Q?398rJLN+O4Xggu6VphcjUusUv16PO7oOiLkzuUUgM/F2TRGTqrHk5q6nPf?=
 =?iso-8859-1?Q?dhuLNHxJbxXRPFJ4RKYcVMNfUNH4pKdZxO1mEMzuQknEI2Lcf/1wPnmGzt?=
 =?iso-8859-1?Q?TyjXAQWsJcbIlQD6Ty67OWBEuGuKwPWEL3YDfsb09qJIY7ay44vS1fOyGo?=
 =?iso-8859-1?Q?+dzRxxfonNwD7IqQq6cSwX/WGHpyhVig7kBCVqjOylMB3m1HioL+19/EhF?=
 =?iso-8859-1?Q?n7EHzk/sSem48CgA3WqbaTMZWwe01THgdyaRnRnoanKei410sHeoiVDkjr?=
 =?iso-8859-1?Q?rpGDmruDmT9f28Q7HFI25mRo6fslX3fAJ73x2+fIkO4jF6AyiRzf3Q6qBS?=
 =?iso-8859-1?Q?6BGZHZud/UKVn9sxWcPmstI21bA/jwqSkc5bwQulEdZZFL2DgPT+E6tNad?=
 =?iso-8859-1?Q?ZdRwQTL4Uwzagz+sznEk1L6eZmWnkOgK8EPA0CHe1jBJesAPT1dzPE7Pwf?=
 =?iso-8859-1?Q?URPw70zXqR1DANNoODkWzN4htIeDftrJ1jP/dwEvBWTK+tTM3a7UsS6xiO?=
 =?iso-8859-1?Q?j1qOkddwAV3naxj8JYnm0f4S+j32xcIl5MVdUh74jo6NuxsO+e/Gj23S3d?=
 =?iso-8859-1?Q?SwGHXBj4BK1P6SPlzIJGY8gU2tUSvlBHSsif5CajpiuyhYoX8jBS6UnpFv?=
 =?iso-8859-1?Q?yphWNpLoHRw8XmHqsZKx8GqlxLrLlvHwTeNq3qjbvCtYRUkhk5Tyg2ibX2?=
 =?iso-8859-1?Q?F7IwYprKOa2/4p3t7Wn/tie6fiUW0wDJzRmf4Cg+avSrkMitq1M7TWx9I0?=
 =?iso-8859-1?Q?G0MB0mrOiT167SjpDk9LfUGOdKh0P2+lBBCGaJF44t+D+iodgd8/CDLm5s?=
 =?iso-8859-1?Q?qL4ueM5HRCG/s=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 187d3596-e8b1-42da-dcbc-08de2b6fb063
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2025 15:39:43.3607
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a4trNCsOWrhEYAAZAuY/gUgvsgQ6JOFv7229SvXptH1tcrCXDD445T0WLqy5xhlAQzcJzhF93DUx0BP7TZfKQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8306

>> -=A0=A0=A0=A0 do {=0A=
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if ((ioread32(io + C2C_LINK_BAR0_O=
FFSET) =3D=3D STATUS_READY) &&=0A=
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (ioread32(io + HBM_TRA=
INING_BAR0_OFFSET) =3D=3D STATUS_READY)) {=0A=
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret =3D 0;=
=0A=
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto reg_c=
heck_exit;=0A=
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }=0A=
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 msleep(POLL_QUANTUM_MS);=0A=
>> -=A0=A0=A0=A0 } while (!time_after(jiffies, timeout));=0A=
>> +=A0=A0=A0=A0 ret =3D nvgrace_gpu_wait_device_ready(io);=0A=
>=0A=
> I think you're inadvertently fixing a bug here too.=A0 The ret=0A=
> initialization to -ETIME is immediately clobbered by=0A=
> pci_enable_device(), so exceeding the timeout would never generate an=0A=
> error.=A0 Now it will:=0A=
>=0A=
> Fixes: d85f69d520e6 ("vfio/nvgrace-gpu: Check the HBM training and C2C li=
nk status")=0A=
=0A=
Oh yeah. Will add this line in the commit message.=0A=
=0A=
> Also we should remove the ret initialization.=A0 Otherwise the series=0A=
> LGTM.=A0 Thanks,=0A=
>=0A=
> Alex=0A=
=0A=
Thank you very much for the review, Alex!=

