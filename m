Return-Path: <kvm+bounces-35480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C0FAA1152A
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 00:15:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 271971882415
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 23:14:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82463223716;
	Tue, 14 Jan 2025 23:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sF+I94SG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2088.outbound.protection.outlook.com [40.107.220.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A507B216E08;
	Tue, 14 Jan 2025 23:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736896434; cv=fail; b=elUzMYyw8WZx72VgkgA0rhXxVeH3E1u/yU2hsgW3ge/IFdX1GfqFEiJJlrHzKSWPA1gfKFhEiy3LeW4WROv0AaTlV6ZfW8n7iAXMIpbiqcJ/ScoK91kC1p4rWZZL6EDM6FHty8P5rg4+PrBFEA3ELK/TdJ+Dj+Rr5aMJhX+2Sgc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736896434; c=relaxed/simple;
	bh=pkWJ24nqCR2MFDnmNGNvz6aRxHnlIUg2yiTOqPKbXbc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=q/F53flFxsh64l0XWtEkjQtCb6VjtNzhMe5VbajZ9uqbiLcKAJqG9scMo8Ypsd5Sp17/pVtOD/zOVW1LiILksQ489afO4IqqYoJyEaS0hoCssHKwIpKETzO+soPO5dYgLXNLRud0WJ5WUzVOGkprdGZEePJE2ueElRMO0/afNh4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sF+I94SG; arc=fail smtp.client-ip=40.107.220.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ORHR2r9qr16JfTnDlM1G/WvfHsQ1nNinrS1/Orl7oMgyc0OpkbJAB7ERmsAb+eMZZW1DbcRGF+bMBnfZ1QKyIUuYVnNg04HjmuFqc0CEaOhwktGTwMgSXHPlYbFPHIMEca8kWP1FZ4FzMLkWNvxYuHJFKIslbgfZQh4o60le/BDWsDBEOuRTVXKseYcFgdKnt4s7dP3VCtWRfaeN0i8xR6IFtAhNvjnob0UWpvaH4DpT8NAiuEWMlr2HaXouGnV4ATk1cFau5F6BGbTeCSOYnsilpMnMz0TNjHrlpWXIzLyKiYmkEJljXKfvk7DjOKE5ruWpFpiwjcpO35EV8pTZ2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N/OElr2KJMyP+Tiz656096UUQ4ozLsuNa6XyxBOYYLQ=;
 b=Hi5a7zBharlVGRNXb697gN+vvxgDjKph6U2VAzqC8qJeY41B2pab+WEfz21eiS/gu7OhZ1H7QhKNwTlfKWtaZ2vFHy09xivDItnqEOnV/03cGxxGZoLDvD+HbgVebpIebKfKxdhsRay2Jm0JSY89WYFAl1K4o059CRkFqe6v+RL0MV1B5pXtD6cWgnvbo4hYlQBysq5lSAx2nsrQZutRJViZ3CC1JKVTmY4ExvFwjz1W14xKCfKPmwuVZ7eczj/W1kBsy5UkaN9w2vZn2I7+b/iMmIkP8M3M2fE6xMVfjvSVSKOiGM5XqI60Yg4HPEKtUyHD+advWVTLMBVGkhKjJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N/OElr2KJMyP+Tiz656096UUQ4ozLsuNa6XyxBOYYLQ=;
 b=sF+I94SGWgkqe37sTHHePNmqRL7k5LpDCyAGg/ovrAZpaipkpazZwVSU3LxnC6feG09U+gJ5YNZc+s0ZPHg/6LwFG1lih5M3INWW5zjfgIFln6ruCQ9HkKufJBTOO0XyhYCPYaPnDXXkejheE3ntM/YYn+HOCOWZOzIAqSTfnX9fnvfBTUvNXKxEP3CUEsQmjRzEYU9Siwsz+kMLqsCIW+2Q4NK3QhkkhVc2L5o1U2iwfr9G2343spMXA/Zlh7iamuqitNEhXwO/jiUonhZzJM2Q8MyUVtiy+bnn4Ln0vzzaA8cmVxPZoqt26diFPTcWob5IRLDiuN72olS/NUcC2g==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by CY8PR12MB7537.namprd12.prod.outlook.com (2603:10b6:930:94::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.18; Tue, 14 Jan
 2025 23:13:49 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%5]) with mapi id 15.20.8356.010; Tue, 14 Jan 2025
 23:13:49 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>, David Hildenbrand <david@redhat.com>
CC: "maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "shahuang@redhat.com" <shahuang@redhat.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, Aniket Agashe
	<aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti Wankhede
	<kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>, Vikram
 Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>, Alistair Popple
	<apopple@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Dan Williams
	<danw@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	Uday Dhoke <udhoke@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>,
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
Thread-Index:
 AQHbObyY4gofHx3CJE6tGYAUqrUkhLLveBuAgBrLBoCAAxi2gIADd6/9gARpLICAAV1AAIAAA+OAgACbcik=
Date: Tue, 14 Jan 2025 23:13:48 +0000
Message-ID:
 <SA1PR12MB71998E1E70F3A03D5E30DE40B0182@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20241118131958.4609-1-ankita@nvidia.com>
 <20241118131958.4609-2-ankita@nvidia.com>
 <a2d95399-62ad-46d3-9e48-6fa90fd2c2f3@redhat.com>
 <20250106165159.GJ5556@nvidia.com>
 <f13622a2-6955-48d0-9793-fba6cea97a60@redhat.com>
 <SA1PR12MB7199E3C81FDC017820773DE0B01C2@SA1PR12MB7199.namprd12.prod.outlook.com>
 <20250113162749.GN5556@nvidia.com>
 <0743193c-80a0-4ef8-9cd7-cb732f3761ab@redhat.com>
 <20250114133145.GA5556@nvidia.com>
In-Reply-To: <20250114133145.GA5556@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|CY8PR12MB7537:EE_
x-ms-office365-filtering-correlation-id: 41c7b2dc-5dff-45dc-03fe-08dd34f11a48
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|7416014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?ZBed0v2vIPzrs8g0c5NiDCWMozB2qjXDU/RYS28ITJV4CyyNQULFEPTD4E?=
 =?iso-8859-1?Q?r9jIrTCM4rM3PHkDWR0JiV3PfRaQYWymV5nmwfpDL69RKKbYTBR+Op8VH+?=
 =?iso-8859-1?Q?2Ma82XGysbbuuZ6N3qAAkDw6B4KAGkl/L6UXIC5yMbwkBHxdkNl/md7kuh?=
 =?iso-8859-1?Q?sMLHqtOdNO3q3l+TJEzK6Ycm6IVzS93w+RuwjewgZHdLuIbpXF941lMIev?=
 =?iso-8859-1?Q?GxxXK53UrsdVpIYaoboP/b/GA/t7pUpP/NsqbYTNJKlrJrBnPROqB6iNAo?=
 =?iso-8859-1?Q?mbUCtO2lhyw9GaMZiQkL67DpicRhmcJl8iZ6AD5xNEuhx3f8jWFv0rEzLI?=
 =?iso-8859-1?Q?1HAfEX68HswVJ4kVhDEB9UH8xHxwZL+RgJkO0IvXAJBh4zj6eSp6uQsIjc?=
 =?iso-8859-1?Q?bRPLy0Cejj9fvGrktBR8cgiZGjepTpFOJGzttkcaKD1Vzj0PQPequLKuvv?=
 =?iso-8859-1?Q?/EaEGUBNJgTv/hAjyeti2R+tZ/JtiPjIFVZEdP0njGs5MiASWi8dN+yDac?=
 =?iso-8859-1?Q?OnBo5PBUPRrfPP2gA1iYRoq9je0lbDjbkCa7Tre7roEdyvYoHYsrjbtAiZ?=
 =?iso-8859-1?Q?P5FIOEX5JswXQPltAKReD2DJKTxZpDptyaTCfhZKY9RpFzF7Yv7cUCScnh?=
 =?iso-8859-1?Q?IJtA9TBwts9exjjbMCtKIh7mDz9V9Cwdc9Mf7SDCGaw9Rr2zwij+oQM9za?=
 =?iso-8859-1?Q?/xaTTY3iRXhOUBtpo092pbGxQMPld+FJLfaBHovN18I9GiiqNorqaH9GpJ?=
 =?iso-8859-1?Q?eOXu6J2cWpLxqRHZbTRcu5iKZiwrcO/vMJLFUckK497kkm0TFdofQQ1glP?=
 =?iso-8859-1?Q?/rfiNlmBbbme30WYS2O1EOsvfAWoSlvrzHh+VGpiYN6P9jzPF9u7ofdgS4?=
 =?iso-8859-1?Q?/X82xVV3k/VHbFNCeCSokR5biUK4acim6IyEO22nyVu4HlQ0L7iH24BlNO?=
 =?iso-8859-1?Q?YACUw2iFPBF09hr0pW0dlOokGaWFOIGua7C6wjGPk8w+UTjqh7zWsGs9nT?=
 =?iso-8859-1?Q?xlVWjHHrjLUxyT8IIUEN531UDU9DVjmDlWOKcPVYAp2zdR3EIc+HD0yOiZ?=
 =?iso-8859-1?Q?Ob+fuKgD3ou92Rr2EcYJqYRZIN+m5BesISVl5QgD4qwLoxT7rNW52datD+?=
 =?iso-8859-1?Q?gIEygB33iQbajbNc6lMjgmSWZD65NSFDT0RZ2p35Vp3CYaVAJ5gH+D3fuF?=
 =?iso-8859-1?Q?JtW1seRaLYTCgQD8AQOTHxkC+SG+PLEbjhKsSGbSDfDvF87fGBJEGB0Imf?=
 =?iso-8859-1?Q?02z8zO6BFhgFDPe01TvY9R7X/Ls4eNrY++BYnL16QYcQAZ2D8oRQWjNuwu?=
 =?iso-8859-1?Q?N1EdxGsU9XOjhc44RK3H3RIR9Tx9naoqrofE4MyMlNQKjoV7Xrsdgb38Ko?=
 =?iso-8859-1?Q?gwTMmQmFP/AzJV9WAhs3jngaVqQUV9dyrJdZlaDLVBdS+Ffvo64jDd+TzL?=
 =?iso-8859-1?Q?vbBsRxWRCXnRgBSfGkEZF26kF17NG1WxkFsb/6bGFQUWphvXzU0wF1lCzP?=
 =?iso-8859-1?Q?KnXa1thm7/KTxWlR4W/0bP?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?jXqbc3wPLefYe/82Zl4VfPGD9F3kvexTnro/LBZ6zpqifQJ3azpmRv7JCE?=
 =?iso-8859-1?Q?qyqTV9NxItNRtEeX5WDZilfvkDggsOuR6GsdDNa5aADfK6TwhklT/b63Id?=
 =?iso-8859-1?Q?pw26zLQ44F1UBvmOeN9ltEf6Rf2gmNGxNxC9NEBbEG2gMq/7NtDphPMZRD?=
 =?iso-8859-1?Q?90qMVY6q8rz/vXrLjlUEPi2nZqcoK8XLgavrMxYTdJd9cfZClZoJz+QDy9?=
 =?iso-8859-1?Q?IQ+ioHmS/uR38OKochRyxI5OHJiqoHqsyM6mnQriFSM/Gk+9kwEsj+Mlhj?=
 =?iso-8859-1?Q?82VJYuqYxHvaPsIm2qdigg7gLnrPGCVn5iw4lgdT/+BTcDmbB4A0iWHm4+?=
 =?iso-8859-1?Q?YiVVgelgrh/oB2DYvLwRc1ahAKVN5m+4TwYCThKQWcQv7A8IFl7QtDLGsW?=
 =?iso-8859-1?Q?QCvRkh0qkCuFcFUbrf65iDRCNOZhemXunW9uJjkkwtsVk7o443IFnzsddd?=
 =?iso-8859-1?Q?yON8+rwVvz/s8VpYEbGy9O4p9dc5kjn0OHZ0+nnkkZXITxTiGAbHwZcQow?=
 =?iso-8859-1?Q?FXbjOljH9TmvaHblrgP9vYPVLzn/e6n4qx5towqzV5fYT6nheOfIXObCJG?=
 =?iso-8859-1?Q?C/pK7N4HqJTArzl9m9pdZzOh54FPRCRHh0f4QdpEIrN9yXBObnWu+88PLe?=
 =?iso-8859-1?Q?zz6YpHKKJSsOI1tkDj/HoYNPInrJziiFc1oRmfu6tAciRO88x0dCmOlZkW?=
 =?iso-8859-1?Q?sgOHFOG3nfay9uZEZbCe+4jz1jIVzwcV7+uTI/jUFJNDITWpzmVueOW11q?=
 =?iso-8859-1?Q?tSj0N+MlNLDpm9ZFU+wNw8rfHx5GC5X6+lTgVHSDtI4rsV9OTjNL8+s7Oz?=
 =?iso-8859-1?Q?2kNqR83iFMWVJntA9GKn2WkV+Pr3Qx/XvkCUjI8FlbUaooxNwIochinL0S?=
 =?iso-8859-1?Q?s4HVgWE55GSAUoDjROAAdQMMTySQepcxSANSnJGmg3WEJEhFW3IwsyIAiF?=
 =?iso-8859-1?Q?Z55hF2hkry3QFV4kopjSznaMmTw5dv5vzgT765kBDw0qmzFdQHPdtTdjPm?=
 =?iso-8859-1?Q?Jd5AwY9+1GO+PP/Dx6ar9aLPFVvlwDQMsN8+ayFFQNpYrLbZ3Y5EZEbwvP?=
 =?iso-8859-1?Q?PTF0RQBZ8qcPhmsdTfsG5i67WFRuzXx2/pBWxUtE+zWmhPW1iycRsRn15U?=
 =?iso-8859-1?Q?foRRFfv8GJYQFQ7NCVvUdIT+yRV4DdahnUkuLxFixn3fINgLjCF4KvHumB?=
 =?iso-8859-1?Q?50tjzvGZk74J9Qf3AE/iARVsvHGsgMx01JPRTtMRpviN6JJWmH7TQ3kzq8?=
 =?iso-8859-1?Q?8dv399YeJxtHAtiWv3LEQFaG/2lCYHaYNbRr6TKNAsS1yT+V9w4z36Wog+?=
 =?iso-8859-1?Q?xulkaHufhjx8Cbcva7dG3F4MeEi2IWzwhlfUOacc83D7qeTo2rhyVEXsu6?=
 =?iso-8859-1?Q?M2ddPpGT2bWxHe5Wadnl6XNR9te4kBMevHV/yXdRs1U9cXTXuMK0lbKkv4?=
 =?iso-8859-1?Q?jxq3fmaiRZxPe0gOtlRXG7F54JH7wqJIEuzMY7HS/FutyC3hjbbhdEWTYz?=
 =?iso-8859-1?Q?Kadlkq/HAkL9sV4Qbxh4YR3FVcy1dzgY88BHyECVjgi/4Sw21jw7Jmd9/1?=
 =?iso-8859-1?Q?a+fgI58kCL+kRJPlnBG6I8u8H5aoJw+hSYU3Yro04Zcj2F08cGzfK+n38C?=
 =?iso-8859-1?Q?3AqoL3D0snPhQ=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 41c7b2dc-5dff-45dc-03fe-08dd34f11a48
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2025 23:13:48.8751
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DlyLZDylJOXjUQVW+WP4SNZt+IE8NtKvRrFhmiFskr6s0JoJn68op/vSMCqhTG+nTAktvMyLVBHOk3QZEIdnhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7537

Thanks for the responses.=0A=
=0A=
> Do we really want another weirdly defined VMA flag? I'd really like to=0A=
> avoid this.. =0A=
=0A=
I'd let Catalin chime in on this. My take of the reason for his suggestion =
is=0A=
that we want to reduce the affected configs to only the NVIDIA grace based=
=0A=
systems. The nvgrace-gpu module would be setting the flag and the=0A=
new codepath will only be applicable there. Or am I missing something here?=
=0A=
=0A=
=0A=
>>>>>> Likely you assume to never end up with COW VM_PFNMAP -- I think it's=
=0A=
>>>>>> possible when doing a MAP_PRIVATE /dev/mem mapping on systems that a=
llow=0A=
>>>>>> for mapping /dev/mem. Maybe one could just reject such cases (if KVM=
 PFN=0A=
>>>>>> lookup code not already rejects them, which might just be that case =
IIRC).=0A=
>>>>>=0A=
>>>>> At least VFIO enforces SHARED or it won't create the VMA.=0A=
>>>>>=0A=
>>>>> drivers/vfio/pci/vfio_pci_core.c:       if ((vma->vm_flags & VM_SHARE=
D) =3D=3D 0)=0A=
>>>>=0A=
>>>> That makes a lot of sense for VFIO.=0A=
>>>=0A=
>>> So, I suppose we don't need to check this? Specially if we only extend =
the=0A=
>>> changes to the following case:=0A=
>=0A=
> I would check if it is a VM_PFNMAP, and outright refuse any page if=0A=
> is_cow_mapping(vma->vm_flags) is true.=0A=
=0A=
So IIUC, I'll add the check to return -EINVAL for=0A=
(vma->vm_flags & VM_PFNMAP) && is_cow_mapping(vma->vm_flags)=0A=
=0A=
=0A=
>>> - type is VM_PFNMAP &&=0A=
>>> - user mapping is cacheable (MT_NORMAL or MT_NORMAL_TAGGED) &&=0A=
>>> - The suggested VM_FORCE_CACHED is set.=0A=
>>=0A=
>> Do we really want another weirdly defined VMA flag? I'd really like to=
=0A=
>> avoid this..=0A=
>=0A=
> Agreed.=0A=
> =0A=
> Can't we do a "this is a weird VM_PFNMAP thing, let's consult the VMA=0A=
> prot + whatever PFN information to find out if it is weird-device and=0A=
> how we could safely map it?"=0A=
=0A=
My understanding was that the new suggested flag VM_FORCE_CACHED=0A=
was essentially to represent "whatever PFN information to find out if it is=
=0A=
weird-device". Is there an alternate reliable check to figure this out?=0A=
=0A=
=0A=
> Ideally, we'd separate this logic from the "this is a normal VMA that=0A=
> doesn't need any such special casing", and even stop playing PFN games=0A=
> on these normal VMAs completely.=0A=
=0A=
Sorry David, it isn't clear to me what normal VMA mean here? I suppose you =
mean=0A=
the original KVM's non-nvgrace related code piece for MT_NORMAL memory?=0A=
=0A=
=0A=
>> I assume MTE does not apply at all to VM_PFNMAP, at least=0A=
>> arch_calc_vm_flag_bits() tells me that VM_MTE_ALLOWED should never get s=
et=0A=
>> there.=0A=
>=0A=
> As far as I know, it is completely platform specific what addresses MTE=
=0A=
> will work on. For instance, I would expect a MTE capable platform with=0A=
> CXL to want to make MTE work on the CXL memory too.=0A=
>=0A=
> However, given we have no way of discovery, limiting MTE to boot time=0A=
> system memory seems like the right thing to do for now - which we can=0A=
> achieve by forbidding it from VM_PFNMAP.=0A=
>=0A=
> Having VFIO add VM_MTE_ALLOWED someday might make sense if someone=0A=
> solves the discoverability problem.=0A=
=0A=
Currently in the patch we check the following. So Jason, is the suggestion =
that=0A=
we simply return error to forbid such condition if VM_PFNMAP is set?=0A=
+	else if (!mte_allowed && kvm_has_mte(kvm))=0A=
=0A=
- Ankit Agrawal=0A=

