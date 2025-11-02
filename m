Return-Path: <kvm+bounces-61764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D22DCC28ED5
	for <lists+kvm@lfdr.de>; Sun, 02 Nov 2025 12:59:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 751A418908EC
	for <lists+kvm@lfdr.de>; Sun,  2 Nov 2025 11:57:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E38F72DAFCB;
	Sun,  2 Nov 2025 11:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="S6up4bLv"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012056.outbound.protection.outlook.com [52.101.43.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7343F2D8768;
	Sun,  2 Nov 2025 11:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762084561; cv=fail; b=NPWOQu0wktIjw6V2FnX5wAPEj5lqx5RWsB7UIWclZkUDgPepv3gqJRKE/rP69leFS88Ytq1S72OTgDrt+3dVDM7rIajPL1aWCdm3R1m//OHdWqhYbvAMs4yS3CwPoBa2ejPH1NoEABTnglu/DIwU9rS0WUcfBZI1TX0aTPD+Z1Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762084561; c=relaxed/simple;
	bh=PuDdd0Q8zyqrZoQJ6pJc61hYLOQkagpe3idtOiW5+wA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dVP70113NBvfwK/vcQQWpEZiTK6t5lPX8b1CBJN/gzyP6uLKkTXZgjfhpO7oz+EyrITJsofJU4XEztPH6onHP4TCHFz4AnjvW/8ESWenfssnarrqKoJxqYGCGKcMJMTUz9sGyCnQwmlIEXb1IIqo2sfLbQAcdCGJkgEW1Gp5Py8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=S6up4bLv; arc=fail smtp.client-ip=52.101.43.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ssx93AMdtlDXd1/PDbkSH61tatsuv9L4MTf7IWbxxL0aEmZTcdyiQZ4e782hhxjh6Hy+mhwiauxjklcozecUnOJZrT7TmbEmYxu+cVBpylnoF3haIxW1RI3w2Kk7Gl/+iarCZn4PhyhNzNzqqNbrABF2JGL+VuKxc1cEEXqDFoAahuCca+htOs42I67pVTZHuiBPxly5ztwclO5kgHtRxya6o4ryeUigT0A4fBpPgBf9NdslC8WNZGUcUejEWC05DvZL8ANTn2oB+d/FuAmUdOmhp67nTwg70lxql2rmnxumcvWKZuQfJyt4dlTifMybkCGudSikt/hHpUkHYB9XpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PuDdd0Q8zyqrZoQJ6pJc61hYLOQkagpe3idtOiW5+wA=;
 b=NpIZhdk3srtUJg2lyLbAxIk3XAnQ6YFNrRZv3LFHMU7q88C17lFpUba9cyS7KtdU1IPA012TAGYsBMk+muwXRnFfRSCIE5/kSr5/Nhvnk6EkXdP2/dI/9s3MX6cYfPp/jd+0AA2EQ3BQhCwxrPqF9XmF9WV6h1YMUJs4rG5VZjKqRtnVTJDxFDydgpLnK6KpjjSHt+y6ei2RK19smvwHHtHlMk3lK27esVaRmxk7qMIRR6SZ2iKwqr9L97gFSk4nf4mlTW5dchbav/cemfTPr2HtNS8HnYJDFwrKCjqRDnEvyuqEj/FfAUSOZHdd4AuzhKhOmiiElyVQJ0lze8YtmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PuDdd0Q8zyqrZoQJ6pJc61hYLOQkagpe3idtOiW5+wA=;
 b=S6up4bLvGQREaLn4gko2g6C/Quay10pquJuiNgno0Hn/VI2zyWEa7Q24OKVswSf1azOvvVKTaxiQFsbdl6MJI9ywkMKq7voZTX1QYM32eNKgL9es9oDnjKvFjmdJQMTJpg9dBYgq3UEAiiJBOWp4qJSiAdtizHZolweg264EUF5MtQRYv+gxTZ8z3w9G0SXjQgjc7UPtU4/2P9xt4Zp0LdqInT8DPfskHXtWsaMZFkoyLdQWTc3kb8xq9//Y1faga0bIT44KOxeMGBBnJxbufJhmR8sWzF8pjzaQ/kmQkOHaNRp2g23H9xSU8TjZSC/D13wboCg024kda4MBnOUK1w==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by SA1PR12MB7293.namprd12.prod.outlook.com (2603:10b6:806:2b9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Sun, 2 Nov
 2025 11:55:57 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%7]) with mapi id 15.20.9275.013; Sun, 2 Nov 2025
 11:55:56 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Michal Hocko <mhocko@suse.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Aniket Agashe
	<aniketa@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Jason Gunthorpe
	<jgg@nvidia.com>, Matt Ochs <mochs@nvidia.com>, Shameer Kolothum
	<skolothumtho@nvidia.com>, "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
	"nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>, "david@redhat.com"
	<david@redhat.com>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
	"tony.luck@intel.com" <tony.luck@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"rafael@kernel.org" <rafael@kernel.org>, "guohanjun@huawei.com"
	<guohanjun@huawei.com>, "mchehab@kernel.org" <mchehab@kernel.org>,
	"lenb@kernel.org" <lenb@kernel.org>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, "alex@shazbot.org" <alex@shazbot.org>, Neo Jia
	<cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, Dheeraj Nigam
	<dnigam@nvidia.com>, Krishnakant Jaju <kjaju@nvidia.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-edac@vger.kernel.org"
	<linux-edac@vger.kernel.org>, "Jonathan.Cameron@huawei.com"
	<Jonathan.Cameron@huawei.com>, "ira.weiny@intel.com" <ira.weiny@intel.com>,
	"Smita.KoralahalliChannabasappa@amd.com"
	<Smita.KoralahalliChannabasappa@amd.com>, "u.kleine-koenig@baylibre.com"
	<u.kleine-koenig@baylibre.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 2/3] mm: handle poisoning of pfn without struct pages
Thread-Topic: [PATCH v4 2/3] mm: handle poisoning of pfn without struct pages
Thread-Index: AQHcRoOUWJnftWewAUixSPYj9sJbdrTWte8AgAHBIgOAA3w5AIADW2Zm
Date: Sun, 2 Nov 2025 11:55:56 +0000
Message-ID:
 <SA1PR12MB71998D21DD1852EB074A11ABB0C6A@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20251026141919.2261-1-ankita@nvidia.com>
 <20251026141919.2261-3-ankita@nvidia.com>
 <20251027172620.d764b8e0eab34abd427d7945@linux-foundation.org>
 <MW4PR12MB7213976611F767842380FB56B0FAA@MW4PR12MB7213.namprd12.prod.outlook.com>
 <aQRy4rafpvo-W-j6@tiehlicka>
In-Reply-To: <aQRy4rafpvo-W-j6@tiehlicka>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|SA1PR12MB7293:EE_
x-ms-office365-filtering-correlation-id: 61930f60-0af9-4cec-1377-08de1a06c85f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?wOuzUAAHHdGLzJ5yBinx+nuODCZz73blgEt4TlR/wM7ggqxAcCeloXclvN?=
 =?iso-8859-1?Q?tePA2wSAC3kuyBdLB/YuOkcn5gBafvFJiHlxKDcpna+ANvY07esvE74S/X?=
 =?iso-8859-1?Q?QHMst3mStWDxvQt9VkMeyjIYiTxK3SRVcXE5S06EaVFiNn8ZC5ptFOgOWX?=
 =?iso-8859-1?Q?YmppWIQLSX6WQTJFpW/XxgEQDhoei5mL6LP848E7OTijTbRu6CPsa1+tVq?=
 =?iso-8859-1?Q?19hg956r+dR57lGd1Sc5Tw9pdwwVHS6gddDEjF2i5QXPA7QJah+c8HJ1dw?=
 =?iso-8859-1?Q?97z3U/YK5OGqYyiG4q/tM8sFGztPufwjP+s1KrDP1nQQa3XznNgSgzrCiT?=
 =?iso-8859-1?Q?wTYl0AMFTFovJUCuqDo5b32aWFFlJr/4qjU0XeKjysjnZmndQxP6/5NXnB?=
 =?iso-8859-1?Q?idjo/VhegmqIfHKkyAhAVDM96BJA6dSq2ZCPVp8/1jhjakHLLn727RPwcL?=
 =?iso-8859-1?Q?ALXs2Hvm1y5h7FEZBBNW2xwqsffgHfofbtrApmZ7hCB40BGKwTxd7pZ0GA?=
 =?iso-8859-1?Q?Jl4rJ40y6wwFDBLzqqiykpM770gk58TQ0747mN7iiEE6VA4uZljEUIohwE?=
 =?iso-8859-1?Q?7qAIJ0H9WaIOx3Kt9lXN/Lizn1jK7W+pTojDQbujpCi1oBvg52td6irK1x?=
 =?iso-8859-1?Q?ATtLI4n3J91N4jOv8Qp0saNp84i1K+I5NRK927rZ+7+RAqiCq5s9Jjhoyr?=
 =?iso-8859-1?Q?fFTqOwn2iDkJ5L2I0e1sHjXSVLzsa7IlpSZ9mPQjnH6+LB8D97BSJW0sH2?=
 =?iso-8859-1?Q?t7Amm5gS+1s4JsPJ2lXr/Vz3NY0iUXElDVbgzUVynj5HgbACz9K/dn+aWN?=
 =?iso-8859-1?Q?/NoClsUss4Nl8S1m0PDVdrSJFx0AaXfYb82FOrehjXf6hVkq+WCLIm8jVn?=
 =?iso-8859-1?Q?XpKqmvitz36Kb5PAD+KedpsAtraeOKXnBk4dSr6pJc2T8e5Cp5bl+6bamP?=
 =?iso-8859-1?Q?EeTW+mrK3ZEHsgy5Vchk0s4h3UpjJOQv1JG4RGoF5OccC5BUWNHQcGl6XY?=
 =?iso-8859-1?Q?n97mrYYBxn9A1XT7/WJl5dvxa6vT1VAnFbXXUFPBqFsBQRneV+Ggn65CHo?=
 =?iso-8859-1?Q?TmSxknfRjwrVipLQtEy1p6XDmQIAKpWNJPigAHOLVPRtBihStUCi2Lah1R?=
 =?iso-8859-1?Q?yrKWvjE3I6e8DGtMwnbQgoXcnzbOcsShwMYATntXIP4l4jHoVYySaj8uuo?=
 =?iso-8859-1?Q?bgM6tJJns0XK1Bizv9MWfq7aOuzAjzYnp5dMhNk9l34xu0BA18tzczDEhi?=
 =?iso-8859-1?Q?M0wxp7Zyu4bH972hh5AzLSkKzK8i0rl70ripHfGHqjdWFAog9FENcsrENx?=
 =?iso-8859-1?Q?X0G0Sg8XZx3F1jQqRUYg6AUqFyucU8iqzic3o3ZBw8hLZHYj3Wx3qfKTag?=
 =?iso-8859-1?Q?k7KJ2LSNYfB4bg9NbtGXXa0AV6ort6259aJ9RGwnJ02phSmWBu2hbCpk1i?=
 =?iso-8859-1?Q?CNu4jjpPfAILCnKdcfiHEutUh37stQenqmNdlfAh148FJyNEJyFclW+a1+?=
 =?iso-8859-1?Q?yXeEMM+KAkpojMgJhPHEKpC1NaSDS6JNx/MI8hc5cnT3Bz3dGBPBEdyPUp?=
 =?iso-8859-1?Q?xXrTjM0PV8Rt+20HNyz5iV7UXYdo?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?YD8gFA5HipRQ+OaDg5qZDgfbz8MLB9FP+dztZq6+11c6SQl1C1kRb34e6o?=
 =?iso-8859-1?Q?Seilt0svRFcymAhUk/RVIuExWj0d2ai4WC6DVWFLcJBR3kjnsZlj/EuNla?=
 =?iso-8859-1?Q?PBipM4ZbXSIpQ2irZFfNByugLr1tgZFN9qafGAKFdds6H/C1XdvBbs4whj?=
 =?iso-8859-1?Q?UKAEK6RzkXlY8anrtU/dhABdYnccY6QPmE7ul9xHMUYhDYexNOlnq/ZW13?=
 =?iso-8859-1?Q?uaCMbqbxIbMlgNrbvq9HxG5MvL8+/94ARUesbDYAKHyLqSm5J+JaC9A74G?=
 =?iso-8859-1?Q?r6CvuhC0h58o1Z1+KipHeG59zltY1SAtjj0GMfnQ2JcvM5TvDB8J+9SzUv?=
 =?iso-8859-1?Q?/R7JtPkS5tDY2+ElRZ9OGuQh82cXVsawUgBNsweI2qK9bXZH9bwvmu0NaV?=
 =?iso-8859-1?Q?4Q7cgjF979aGWCXvDXQD9hvKk1ueQaWMXgGBBWZKYiRpophqeKAypTgiFS?=
 =?iso-8859-1?Q?nGpQRVlfdnoLpN7e8wABvS94+d75Y/igjf9ku/Ydc9XFecWaNPUTrWzVOh?=
 =?iso-8859-1?Q?J+OnT0KX+n053ytOHYexkj8yLmhCvPZD3SkHsXNFdBMfXAcXsjGRAQJDyH?=
 =?iso-8859-1?Q?lM2lBSSHY6OvdF0mDettduI7bqdLdkIeZ/lbHQuaKD6LU8aBFRAD4IOYRY?=
 =?iso-8859-1?Q?xs3IbIzqoTvfBrnJsVN49kHSbZd4oytHIWsbuRkKJOblRxypcLDZ0oio7o?=
 =?iso-8859-1?Q?bfLjDi9UUrKVs5OcqsEXwgv2PXQzNKZq4rCcAnmfbrrWBRE/IX306qzivw?=
 =?iso-8859-1?Q?y2qFKc8wQqmQadI7zo0Xc4zBzcz03DYwLxLhWGTN5ztLukInDDInZYa5lS?=
 =?iso-8859-1?Q?4unUkqiVcIe3dML+WbIWlr58tjbWLJ0URN0xOge9BvuxUk0q4/+9k0xIaD?=
 =?iso-8859-1?Q?eBQRvltbPzt5jY1jROhKP+tPKp07auTuVpfCteCtHmboBf5+wz52X+6zOt?=
 =?iso-8859-1?Q?itw909HsbbAPdRl/gul0r3QaLa2qJuVciFweByKCANFHafs4wKl6fBJNM8?=
 =?iso-8859-1?Q?EAp6+/gXwHDu0tgQGn/3J8swjlx8whoXgsqVQjO6QPHMftiOtYa6nw4ZSR?=
 =?iso-8859-1?Q?HvUStPt1GNcj3qk7jEk2gJXTEi5T2VbeOJtNZbOUDbgGK9hbhKHgLEAM1a?=
 =?iso-8859-1?Q?u0XRjGV9Rg0CVKknGIYKB84GmPchtUwpMrR/F1JcKr/o6CSnHiYmDdvp/0?=
 =?iso-8859-1?Q?Z5J+COkAnPh28kJiGILYapJ3vNHMKQ8QfSWuLNNcNQ42C2gMji8bwePDg6?=
 =?iso-8859-1?Q?o7QZOmAixCR/0k5XAnkFq4IKiQoRcsLDzD6q5nZYaLObleg6z3hibDeuU5?=
 =?iso-8859-1?Q?sTotD11VnuixmDT8BjIX78r1TLmy3Q6bh2qS1zS8DAeF49pODPGkAK3UQ/?=
 =?iso-8859-1?Q?mrbQE4pAqqrCLf5fMMCr0klpfAr2d1GC/WaETdwYAGa9K/0+6T70KkefKg?=
 =?iso-8859-1?Q?8Rs+ikprCwOCIXcRG1+x0VntEFTYu8OH4Zrzd+jluVt/2y3m06K6BL+QHH?=
 =?iso-8859-1?Q?HtOsV54edEkiCU/HnMD4y5SugxLZMBWEk5zUnceH4/Pbsl+Zu8hKGRgPB3?=
 =?iso-8859-1?Q?zkeaipkEt4BoaD+i2cO6dBZdBQYCuU92yasQmfnMWuT0xoG4JzGgLAeq42?=
 =?iso-8859-1?Q?iFrkuC1YKd6ps=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 61930f60-0af9-4cec-1377-08de1a06c85f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2025 11:55:56.6396
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tf+c+lzor0k9PMPetaszYbh0ppJaEcK6fGeqxG78k2NKJzlQCRmDbPwX3ZNBf3ErY5FHY4EZ6IWufGyRxcHzvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7293

>> >> +static void add_to_kill_pfn(struct task_struct *tsk,=0A=
>> >> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 struct vm_area_struct *vma,=0A=
>> >> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 struct list_head *to_kill,=0A=
>> >> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 unsigned long pfn)=0A=
>> >> +{=0A=
>> >> +=A0=A0=A0=A0 struct to_kill *tk;=0A=
>> >> +=0A=
>> >> +=A0=A0=A0=A0 tk =3D kmalloc(sizeof(*tk), GFP_ATOMIC);=0A=
>> >> +=A0=A0=A0=A0 if (!tk)=0A=
>> >> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return;=0A=
>> >=0A=
>> > This is unfortunate.=A0 GFP_ATOMIC is unreliable and we silently behav=
e=0A=
>> > as if it worked OK.=0A=
>>=0A=
>> Got it. I'll mark this as a failure case.=0A=
>=0A=
> why do you need to batch all processes and kill them at once? Can you=0A=
> just kill one by one?=0A=
=0A=
Hi Michal, I am trying to replicate what is being done today for non-PFNMAP=
=0A=
memory failure in __add_to_kill=0A=
(https://github.com/torvalds/linux/blob/master/mm/memory-failure.c#L376).=
=0A=
For this series, I am inclined to keep it uniform.=

