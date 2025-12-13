Return-Path: <kvm+bounces-65922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D078CBA4D5
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 05:53:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B841F30B0A40
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 04:53:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACF72279795;
	Sat, 13 Dec 2025 04:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="idxL6oXm"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012041.outbound.protection.outlook.com [52.101.43.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D1E17BB21;
	Sat, 13 Dec 2025 04:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765601582; cv=fail; b=Qt9nj6FBrvT7grfYFcL2vct0Wg4oHCkHcck522307ilq63kkaiHbKoMZuhgANtqnIVueXdW58ewu8uq6uvokafp/5kXBq8wOPu8vGt9P+qyXfAZceuZOktgtj5YZBKy87wjb2ZfrZSGq/3xCTxoo5tBGVSGLZFlPoyZEUhhtG60=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765601582; c=relaxed/simple;
	bh=q+HTCVOBo6TEXmDWrloiVInElaLaXqqfEDAwCDwhzJ8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=scvmpm/rfv0lTAs1YL9QYCQxmKyN5WgcFOqTry1mSC8a+3hYiwiaiI/j1O7HM4oliZ4AcO77f38xq/1cb4XsXBIgrvTesYSkNsxh8JL38v+ZGBRR5K6YkAOy+foZzUdtQpLmysTnKxd0NF8sXVU573SHNkbCuZAdCkydTa4VTzo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=idxL6oXm; arc=fail smtp.client-ip=52.101.43.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vLmtSNRaQ8FHY6vuNhzhFlMFY3Narw+u4y7OuNNxONZplYYxcCOnNrjRgJ9EbALxjenKjlPns12K85xIQE586uzQtuPrtPWaWMD9cF1XvLgWQZm9VgAupBF1Jooxl+e+8uywsPGDlmgRWq6U8tCqj09gw6QHwOa+1rwejdR4Ru/B685Nd/2nKf4sT6eiZQVipkPNIJC7V71jr4QSujxHj8vUeSiu+Oa4nlp86iuEhMf6/dImLSe70bRxS2dBbiEEud873CxSvoLWhcXjUBdKE2vlEDnxNmlLJOKGNOV3hgI1vqEcwhoglPGbNofdsS1qQNT4upAbk/+GurhR27FNeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q+HTCVOBo6TEXmDWrloiVInElaLaXqqfEDAwCDwhzJ8=;
 b=Lq+e/ih+r+PyQS8yeafAeVC3FGB8pENBqLLotKOh8iFN9jG892CCmwA49F7bAqcRhlP5XARMGjOZVSGrjUIPiZ5lQF5bjl1nzLdQopTUdn4uSsCn+XZtsNKqJmHX8E6dmRzNj7ymg8EYzU0S9RsT0ZelbStLLUZrm6HPK31SbCs/3cyKiyz+K0EpRnNSJO6AMTxQcXYluhZg5rzzDEWQCiEcWE7YXWYO9khRhpANSNtugrMHKRqG2uc9kH6CgZXKxR6tmr+jAZOzOmMFvMxsmlKoyewuAFNlF9siC6JgFcf/F4SuYz9I1if+ihlkbqoK6P3yC8Ip5tLt6FEwfr3dbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q+HTCVOBo6TEXmDWrloiVInElaLaXqqfEDAwCDwhzJ8=;
 b=idxL6oXmUhtYmiy2dC+wu70iaiAFXOpVh+2VARJZJTmiBsoJwwnjAjJPVZNWoCA3lIJeJrjnFcy9nu6a0sqZyPBKGQQ5336q2dthV0vwGpXAXvFQFO2ucknkaPxFJabBVPXqe3KyTf5yl0pkra547LuKsgtTOxG4RptfwpKeN3LeOanHzlhvL/wLL4xxuHGCetu8OJ+CnqKGVgMxGV0Xi7ajID/be/xxDFKlsDM4XOLoDwp4eRQKZH8Q0B/o3vGdIYz1w+gqCqz2JC5YYTN4+Z6c8SZBlBJVx+EZwM+RX+brM627+kzK4ocQL+GUwWcRzHx8kktnduIEuFwjkO70MA==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by SJ0PR12MB7066.namprd12.prod.outlook.com (2603:10b6:a03:4ae::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.12; Sat, 13 Dec
 2025 04:52:56 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::928c:89d8:e8d6:72dd]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::928c:89d8:e8d6:72dd%6]) with mapi id 15.20.9412.005; Sat, 13 Dec 2025
 04:52:56 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Alex Williamson <alex@shazbot.org>
CC: Vikram Sethi <vsethi@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>, Matt
 Ochs <mochs@nvidia.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, Shameer Kolothum
	<skolothumtho@nvidia.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
	"nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>, Neo Jia
	<cjia@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, Krishnakant Jaju
	<kjaju@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH v1 3/3] vfio/nvgrace-gpu: register device memory for
 poison handling
Thread-Topic: [PATCH v1 3/3] vfio/nvgrace-gpu: register device memory for
 poison handling
Thread-Index: AQHcamyq2Se5E0Bmd0uZgPLzFbZ8gbUerqKAgABUrDI=
Date: Sat, 13 Dec 2025 04:52:56 +0000
Message-ID:
 <SA1PR12MB7199E3B570F2E05183532E52B0AFA@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20251211070603.338701-1-ankita@nvidia.com>
	<20251211070603.338701-4-ankita@nvidia.com>
 <20251213084757.0e6089f7.alex@shazbot.org>
In-Reply-To: <20251213084757.0e6089f7.alex@shazbot.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|SJ0PR12MB7066:EE_
x-ms-office365-filtering-correlation-id: 4b1a2c11-e039-41b5-dc85-08de3a037b54
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?dJzO9ZdqIkG97nA3wPS84pv2i4cADqYmEKbq1wG2yOvO4XPpopX8OXAzaU?=
 =?iso-8859-1?Q?NPQGXTsyy+NTzXqslas498Ru3+6hwiX4g3DSXd0GQwSXqWZowwttTyZGr+?=
 =?iso-8859-1?Q?JUsGdU8Vq4ooxV0YT5ZiMsltmvfOj8p2omOcW+uw+Y8c6tuXDed2zRTBWF?=
 =?iso-8859-1?Q?bc+fc8hq+yuAh/RDjUcoCBJXtcScrXCYpYlSa0W9iwECn5QqQX27KI/C03?=
 =?iso-8859-1?Q?7/xmYnrK8+HDqj0RPxba1eI2YHaWB5BJyrv9JthurUtRR1b1LVQ/pD1Kbk?=
 =?iso-8859-1?Q?IjFbQ8bLLXEDmS0rvLOHaE6Oz+nKALco4OGI09ruSZYmPjFUn43Bvntl/t?=
 =?iso-8859-1?Q?BY2ATDkTZpa49COl4T/WTaJsZY0/9zQ8SHvjOgzq9zfMX+H8NliD7Ii579?=
 =?iso-8859-1?Q?ROGx/+PLxdYYVNWhYHypVa0wtJ21jTH0yGOKt2bd67b6oqTmYc+md8Ym0L?=
 =?iso-8859-1?Q?AvhGRR2gTGC8RmkBJtAzz+oiGtdUiDtpuKQDllilmhldFOvxy8aYmO2D0E?=
 =?iso-8859-1?Q?u8/60+MgGKw4PZGkOD4LdtesTs1KrAKKV+c3pVXqozW+r8zq6xzpMpUmlg?=
 =?iso-8859-1?Q?y2FqC2wJTc91ft4GX/x1O+0JizA3sm7hlTO8hoLCvvpMVxVgUs7xmClFc0?=
 =?iso-8859-1?Q?41shXp8WdbC5UiZXard05LBOhc9QXQN2KPJIEHgd0txQt4ZsfbSvLUlkJz?=
 =?iso-8859-1?Q?gQPfzK5ujJiQ18s8HuLq4fDsp0j2Ja+AwzlT8fZhqL/Uh7JDSp7Nli+RjF?=
 =?iso-8859-1?Q?z+28qcCIk2/ft9N2/VjfeqMw8b47yHDdQBPEETq99nFpJIS+wgHSLrkaLL?=
 =?iso-8859-1?Q?T7IeJWNzhBzqWLXY/B3b6L7ZOZ7mxBic1ImoZ/nBDVJm1zkmzu1beffoBj?=
 =?iso-8859-1?Q?/cpEHyWLWTHluGXsW6SolfzTr5LQ6WE3SotXvpV+qEBRFkOJLc/5gEA8cL?=
 =?iso-8859-1?Q?yfU/MCDulTmZbFsemDFdAem3WcVaOSMUTSpSWm5hhmR9qViCQLgG/CBUnr?=
 =?iso-8859-1?Q?873oQ16wIcs2zpqwnn/bzA41/3Uhk5pcXjVCWBoVAxqS6zHtqzDGEXYUiV?=
 =?iso-8859-1?Q?0FlE3uhvcWEyeuYJoTOaNi7JCioUiLAxm7RyQz0mRZgdYlYdOVagv1WEVp?=
 =?iso-8859-1?Q?Y0lF8z26Xkj47h4HmsL+tfl7ghaqWGaWba1TCXnCiYPNgMbzpXl7GZEdb7?=
 =?iso-8859-1?Q?Wym3zPR9962cBH3CSPJqMs+y4GLawuFpQ46pZ3NSxc3t9WPOGM4P2apmo6?=
 =?iso-8859-1?Q?4h+s21PSGgbld1spN7LV8vQZtKC+weSTGXmnNaqmMIkoN8QACQrqKX17yq?=
 =?iso-8859-1?Q?mABYQTjhQNCO4xA6DDeQ4Q1WfsqEDaNBBqRsJVNpDLw/QdX2JbDJkbfbtT?=
 =?iso-8859-1?Q?AqSNrhEYgA51LeZlp0VZrv5MopXN5uPpvFMPL2CtERYt4Mvl5eQmCBVJiF?=
 =?iso-8859-1?Q?g3nVD0jMBxrG1mfHO7anzEx0fo0WEhNqL0G8R9diytjz/tSDWyWh/OaM3N?=
 =?iso-8859-1?Q?e02MWpYLnIFbQdnDFCPceZulBexsx23qptBXPZJ2YznCC60+gyOHxKnnQG?=
 =?iso-8859-1?Q?gyK6GuJR/UAn5rDRNxxvFtExkkYX?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?q+qbhgOpuAUy2JULRXaPq5J2hruL8joZgaCmVcTAGoDdg4C89VSh/VzFIg?=
 =?iso-8859-1?Q?c661kTI3HXCJ5bkn3DRkcblwYxA/BMLNPVGCD+ovShhNEO66jP3pMVm3OF?=
 =?iso-8859-1?Q?Fm8iTYVc8rBX4EpvVkinGoIWJ6ZJLuVEbl7F5uAm0L/RFzlYJ5Aok3Qhce?=
 =?iso-8859-1?Q?7Q5VdgWQL7ihoeljQwmu7bhhmQ/PlEHDVs+p/0pE2Gw4/7MHOcnWSTllQH?=
 =?iso-8859-1?Q?r3zEBdmgXWBVhw1JnGPT/aUJFJa/MvKcfhkgKR494Zm3kBVKopANrhxIxB?=
 =?iso-8859-1?Q?PgYbbBHxqkIbxIC8C009rBzVW+yjjFedMNdxbk5GBcKIE70XoF8YRhVba6?=
 =?iso-8859-1?Q?Nxw5N0So4dZNY4Hq8dzSRBxO5asxHGkJHPnSkWqXEeKut7GFqHWW5a/10A?=
 =?iso-8859-1?Q?Euk8uQh8L83YWafLfauJe5IAGd0jck5+Z6XsFBLU4UpBcZTrB7EBlCfOxN?=
 =?iso-8859-1?Q?NP2id9qvFhuS0txGVvTRo9yyhLp4p9jtfR50hLqbcB2vTOy99mJNCo8bu9?=
 =?iso-8859-1?Q?DcKqBDzi1dfvnPRB8KF3JetWgNi6FaL5fFATOPzRu5FnB8D4TJNJQfJF3B?=
 =?iso-8859-1?Q?IUuN2KbO4ru8MxwhkvQcf4aPnGB58MTYoBDxlWzTf6OiP7QDHmzB7WKUoV?=
 =?iso-8859-1?Q?k5dSueUVTfb0AWLPa3gaceGYtUz0qJK9//n++ck1nOmc9V5Nz1zRc7jbpW?=
 =?iso-8859-1?Q?iAzcuC/exd5k/79231WEvUEdfzHrWZNJTFMhndTRVyoxU3/6FO2OGxxmL1?=
 =?iso-8859-1?Q?2ST/+PR6Vh6pOuIik0XWgvvfiBBE4tsF28QWLc5DZLBLUjW6UBQQqsiksW?=
 =?iso-8859-1?Q?fSrpzYuX6UP4dLSAukGBz3T4veO9LPseDo5YcKts20QCYpsVbn2LLrBYTc?=
 =?iso-8859-1?Q?5u67CCD0TmdrlbmBt4jb8hKNdkrgqgUqCasgsFfXtH4gQPnJtbJvfHd34I?=
 =?iso-8859-1?Q?t+NaOmNErjRNOtempx52dzuffZJFZ7zoMcuc6OxKL/M1dwQDRMd9Hhmzf/?=
 =?iso-8859-1?Q?TXwsKLugdu8wYdNct/1SOn/MEyyKq7G1m3dgdP7TI7fIHouksqWW8whM3P?=
 =?iso-8859-1?Q?p6VzD3WIBD3OGlYziTwDsoudPJn+t37/cMhiXWGBnW6JQqxGyGdUPaSuxO?=
 =?iso-8859-1?Q?UdspfzjEc5Z1QlvOa5QZQpsO9J8sZ6FhMm8RFwY/3FTIeYliPXSRzWrbKL?=
 =?iso-8859-1?Q?lVBh0cQP2nHn8BvNQeE7olNYogfCliWmUAweo74Fz/3KHKVgO09vfdX3yi?=
 =?iso-8859-1?Q?sGpD65GCny9n6TneTp/zN4XRAqU2mNnHrBBltyMbOOxSjK61IOXH2A43NF?=
 =?iso-8859-1?Q?k6dZM5fIlgktMBhawK5panqaxq1nXhxRlTsFCct9bKR4EyI6mhmIrUjPpt?=
 =?iso-8859-1?Q?hHiFndXYeosD7N2usDtMbnhHVG8tsJSCnlK8/+0JiAw6U+25+fro83LrIb?=
 =?iso-8859-1?Q?CSVQhYiZR+Bzkq7eDsw3FgCKboKKwmnQM/bnhzyyUIZpd5FZEmarjmeLTi?=
 =?iso-8859-1?Q?IHL5deVRxf+KBgLIyEgi9s8wyCHKOdz9V9oL/wD7kRgfqH5lSehQJW6Ws8?=
 =?iso-8859-1?Q?5HZbvPi2g5hCT4gjo+yhw+CXbM/mTTpzqng4hVkCBRmv8+gg/shslLBiSL?=
 =?iso-8859-1?Q?tHbUxhbe7sZOg=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b1a2c11-e039-41b5-dc85-08de3a037b54
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2025 04:52:56.1471
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KWfrWX6wrFZ91GsIkGM/BajdhEzSUuJFOxWH0Mmr9xi7t+n16XPoovYjv7hN0N7/Xeu6egnMJW2ALtfcZpdQ8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7066

Thanks for the review, Alex!=0A=
=0A=
Comments addressed in v2.=0A=
https://lore.kernel.org/all/20251213044708.3610-1-ankita@nvidia.com/=0A=

