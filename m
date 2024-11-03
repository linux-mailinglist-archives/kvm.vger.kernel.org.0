Return-Path: <kvm+bounces-30424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 585AF9BA5F8
	for <lists+kvm@lfdr.de>; Sun,  3 Nov 2024 15:39:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B60572818A6
	for <lists+kvm@lfdr.de>; Sun,  3 Nov 2024 14:39:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D489E1714CB;
	Sun,  3 Nov 2024 14:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nlFRhgfw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2069.outbound.protection.outlook.com [40.107.93.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3D016FF5F
	for <kvm@vger.kernel.org>; Sun,  3 Nov 2024 14:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730644751; cv=fail; b=GfugB1G/pspx709v+IWW+94Vb6E+v/noUUWim2KJxn4KBIN+L5/J/WeWPxfgwWOs4d6Od7DraYDNFqZo15m3/jilI8oLYEsKTazF98VtBaQj7agFab+gFJYpUJktThfxLXeFCfPVTG4ueiZcStZPqcgxbIMrVPvrdK59mWVNVYM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730644751; c=relaxed/simple;
	bh=994glwTw24j2yvA0isbVgcXqB406PG2Y9VxeopRQ0jM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Fe1x0kHPX6g+a5cObLUdmvn43MDMOJY/RYtRr+KBZTXGiFpjC/zG69d0qpLhKxeCAgEwdDK9MPMBmQD9uAfL1CXS+7T8f9bZI7nqZ53R3NZmKR8aIULHRzr8ZYDp12qM1rdUEK7/45VT/aSjzQmQ5VI7c1L7ur9OII0MK5bbnWg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nlFRhgfw; arc=fail smtp.client-ip=40.107.93.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gn2Yr2/55BgZaRbAc9WOcuePrgRKAwBl3J5FF7eGCMkejDz0YnmESN7ZWGfcmaiY1Fyqf5QX4T/y2OGGVahYk3ZrB1ojtEMvq94mhj57vMjKDnVV74DD1NvQmuLvq0IsxnNO78XRxxjLLMXYFYpCRoh0QP9ehvBgzshS+Wo7T90JjPA0C9zaqrTqrLbaumqV+Suyz1Ksuz2GIJCGC1Eq35orPm4f+6Fs4WXiZ5i+r2O3kI+msVfGW+UivwZg5ZFYkqF2XWyhO/1co3cUPlSvZ69/eOFgf39YdzETJoGM7UoHzQ2xKq4NWh3cDo5Hr6WPqxFAtR9URm36vhfepMgHXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mr7HbPQ2yMRruyWnn7SdKskRwMhGGF7deSZ44YMs6GY=;
 b=wOIRrBC4el4gJFqBbJhmtr12V3/OrVoN+swqV1x4Ynod0EiA14uV3fbymxiKBEUK15/86dysh8xpJiAjsWheFGHnnP9d/aL5Bx7uZKB1GFyAoNtF4B4wmlfuLbZqTQsVCIAhDfEyvrRkObQ7+GAgL8mCWRI6TYOzrqoHgWx5s6DDfK2K5AzjJ7zvN/kL2HFfqWTmjpcKxJEN4DBeWEuULfioXWl40BKxyY1vVtdV/Glqywy688cy5afNRJObjHq5tkkl3GOGWFI9KaV4tgEgt4E+55dFpKydzHi9glXa1dB0ZJIU+kJ9eNcTKcw/brX1jt6/Q8N+yCBlViJ6v2iqjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mr7HbPQ2yMRruyWnn7SdKskRwMhGGF7deSZ44YMs6GY=;
 b=nlFRhgfwcPpiqSkbuoX60Z6MNIozGAl0iOWIEovZ0Wi3K2bWv2voCEkjXSeFGoY98Zj6eTyMqGpj9b8pWmj9RAo7MK1OCRr/y7uuOU/y+HmUgArTTCiex51SuCOfvroD/aksWzYpH+WQScAZX7NFzIN8+dsmRtdZNZrPqxtk9DzC5tlbAob3Iu8gciXZd9V7As6WQubn7B8olj0xpMsImVGxcI7W5BAASxm1285GgovOmvt3j37+j9GvbuSEzW/tihmlPFwp3cezGv6GC74SMAkgtRCj6a/KLOobh0r9CG9oECs9GDEcMDYbmvaYtQeeZxODKftT39bopZf3/4HQqQ==
Received: from CY8PR12MB7195.namprd12.prod.outlook.com (2603:10b6:930:59::11)
 by CH3PR12MB8878.namprd12.prod.outlook.com (2603:10b6:610:17e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Sun, 3 Nov
 2024 14:38:55 +0000
Received: from CY8PR12MB7195.namprd12.prod.outlook.com
 ([fe80::c06c:905a:63f8:9cd]) by CY8PR12MB7195.namprd12.prod.outlook.com
 ([fe80::c06c:905a:63f8:9cd%6]) with mapi id 15.20.8114.028; Sun, 3 Nov 2024
 14:38:55 +0000
From: Parav Pandit <parav@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
	"mst@redhat.com" <mst@redhat.com>, "jasowang@redhat.com"
	<jasowang@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, Feng Liu <feliu@nvidia.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, Leon Romanovsky <leonro@nvidia.com>, Maor
 Gottlieb <maorg@nvidia.com>
Subject: RE: [PATCH vfio 0/7] Enhances the vfio-virtio driver to support live
 migration
Thread-Topic: [PATCH vfio 0/7] Enhances the vfio-virtio driver to support live
 migration
Thread-Index:
 AQHbKFgwmMFKDidgeUS806gohYGFpbKcWAwAgAAC0wCAAAhuAIAACAsggAHGLgCAAr86QIABs9YAgAMFipA=
Date: Sun, 3 Nov 2024 14:38:55 +0000
Message-ID:
 <CY8PR12MB71955EF583F601E8ECEE3C71DC502@CY8PR12MB7195.namprd12.prod.outlook.com>
References: <20241027100751.219214-1-yishaih@nvidia.com>
	<20241028101348.37727579.alex.williamson@redhat.com>
	<20241028162354.GS6956@nvidia.com>
	<20241028105404.4858dcc2.alex.williamson@redhat.com>
	<CY8PR12MB7195FCA5172D7829B1ABC773DC4A2@CY8PR12MB7195.namprd12.prod.outlook.com>
	<20241029142826.1b148685.alex.williamson@redhat.com>
	<CY8PR12MB719511470E1E0BAD06CFFBD2DC552@CY8PR12MB7195.namprd12.prod.outlook.com>
 <20241101102518.1bf2c6e6.alex.williamson@redhat.com>
In-Reply-To: <20241101102518.1bf2c6e6.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY8PR12MB7195:EE_|CH3PR12MB8878:EE_
x-ms-office365-filtering-correlation-id: dce81984-8253-4c0d-38c2-08dcfc153e77
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?tN2NgA8656aaqTi8AuAfuXej0HJ4K2JvcVGCvBMeQv8S6LRuHWJQqxuP/O1F?=
 =?us-ascii?Q?1gIEzL4p4K5vHFuME1pjA/q9SbK01WU7xO1fD+o5aYaY3OEWEFKgxeGHfJNg?=
 =?us-ascii?Q?j7I9WA9gpsgnDOtlEsLb4b2E/bFl1cXwiuXk1epEizjFVXx31AT9yDsRyMo9?=
 =?us-ascii?Q?tYTmdO5J3YmK0lIgsRaFgA6Tu08xmJWn3HnTrphHuFPvsxJ3+qe35R5N+fQj?=
 =?us-ascii?Q?G2B7N/R7+w1SSlpF+04gaQ1wElN1ATC5jtnkK2cBBMV7zYx68/HGqhV9wLKt?=
 =?us-ascii?Q?RuwOeYg8k4WARtx15yryn5GzdEyIjF3p+Rq9Pb4mWiLAJdhzM1v7THAk/YxJ?=
 =?us-ascii?Q?2llzQxV0R7MrWEAI73tCVnQ2qm4Dq1s1KBZj/WlGBObQHyUpXwP5Q+OMCRYD?=
 =?us-ascii?Q?9YPPSGqzF+m/jpZtpwtYSz3HFJmPza4VpiNBoNDEPq1X6JTvHWYYX+YlS+0e?=
 =?us-ascii?Q?OvF+n7scrS89nPiUDu2n4B4GgAU3G7NFdyMKJBvWM+wnBaFyqKCJV3I/4Cxg?=
 =?us-ascii?Q?JDi2hltJkkM6mRD4rzwOv3bj22AHPImro0nhK8+KeO/SEweOv2ILbhPzctvW?=
 =?us-ascii?Q?qgGzbUnwtfkjHY/xKG/gEsPJizSoqPRoN4fwd6GTsKyHvMudgDd86uV9vjW1?=
 =?us-ascii?Q?0z4eL2nwszIygeBAJ6u9way5x45ptBTnwLcnzwMfklwtwp3wspRL2NRnCkpm?=
 =?us-ascii?Q?B43aHVhD85IlRumPop/zE9KvR1fAZZ3vPBpxZwNkYK0SlPEreA86tEEAg6t/?=
 =?us-ascii?Q?PeMIWQvc36KEkK2bmfieP32bUYQov2Kz6eqJA3OcKEWN4LN3C+SK0h0cd7Am?=
 =?us-ascii?Q?WgwJkDF4l8kF4sqihigYBQ1DWf2U9jaL5jwOFvwgpyoq+FyLPxOWLBBsdNSl?=
 =?us-ascii?Q?USoSdQlv7Dd7r+cEPl+22TMWQgh9kbiPvWBhhsPQaijOx1Hhnn7Z6ECDqybH?=
 =?us-ascii?Q?QDtBpU0s0sPnlzzHzfaV9nfVQJR5LpwMtwM5i5TuoBuJML0pIKuQjw2tvvVh?=
 =?us-ascii?Q?P9fWXN6bdMsy+3QYPH9jNTwKCBVUDGQ+J6ooVXU4ojEgKKGsWjDtxoBqH/gs?=
 =?us-ascii?Q?bQCfb671ApFZ4zPyJLOSFcEt6df5xzCCl99fNKk6jfY6ML7sG+xmGUsETFCm?=
 =?us-ascii?Q?WtlvlHZeNqCXGZYSZNKOFS+uA2e+8paxVjWbq3yoH8d4vUSeIF5BlS/mM8jW?=
 =?us-ascii?Q?2E+JUXlqPZP1sV09KwH8axU2KCbQgsRIaaI2pLDPQxI6kDsn/3q37cw4DBgw?=
 =?us-ascii?Q?K+BOzalGtp4/xLG/5AS0/QRVvBEA5R2dLtOMG/Kaq69oe6ixpueGIw3Nnuw/?=
 =?us-ascii?Q?RriKhz66m3lHHUqtdoNeFMA8RDt+/xfjy0ancAIjktqNg8ZabvK2tv01FXGD?=
 =?us-ascii?Q?x8+CjWA=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB7195.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Lqi+3gspl3YlsKvAEm8aT6FFLkSw6WDWWau2Hm8uoiSZCpJcJCjX//ejLlVh?=
 =?us-ascii?Q?hTMqaMaqoq5Dh3xsgIHHynnh4TrFGU+RhOSZqJqjCKnjTv0LebfLfFkIW6fA?=
 =?us-ascii?Q?K2kI8tiaoMQG0HIDMPtFj24qDmuqkGXUhFOq2bRXic+6wn1dbE9ZYSt4/MLq?=
 =?us-ascii?Q?MorwSM/K+A7yqWI76LPJF4NYDmf4NWuSElWLbcP6WLThm1UdXpmBPmUDWH/j?=
 =?us-ascii?Q?HSaG6W3Gp8/9cqXFAxca6x+GslZ+lnbEjWHGQbl4FkkXpwFXkGiFPbD+OcLj?=
 =?us-ascii?Q?40JOmIfR2U+ybypGAYNuEkHM4B++zv2hKnkBEYF6mz9KWkeR30F8sJ5xJuhN?=
 =?us-ascii?Q?26s1+MhKuM1M1u3Ql291KH/H4TQIWbohpsaxfhQUZzyJSnLWLXg1bk1bEBO1?=
 =?us-ascii?Q?2oUDFX4neGkOBD+1klG9agv17dGY+eZ+gBGHLVenhmLF6nBX4nm4MUxd4QBu?=
 =?us-ascii?Q?kzl8xjNGhLNraOndRDWwjAXmaHvewx4D5rbDYIQC0hZKZ3ZJ7Ab+oQzMCSCp?=
 =?us-ascii?Q?1Y/xpdlEbSUz+thxP6Ff5ILH7jKM7PJmHWCyc0OoGzXEc8/iTRjNBo6ywTKj?=
 =?us-ascii?Q?dgRPZj8/55UXzuN18JhQ816TNUaAxoYWqIPD0Hlz8DD0fNerKAmhzJqNBVSb?=
 =?us-ascii?Q?11nuKnn9EPkVZf4Smpcc7+nNkoZEKpvN01XTeukjvNs0Uh+eG4EgJwL7SdRF?=
 =?us-ascii?Q?NoY1Qu+9TlAMA2nmpyNnFDz+5ZY33N9PPzozhb18P+PeDOSVtTGG4NTn/ovJ?=
 =?us-ascii?Q?Lt3qXG+atpmnu3jDYiTM6tBJWEbdW4ml50vQLmE1tm0OPAlrPloIQn5DxYDC?=
 =?us-ascii?Q?MDrEMb3TMQzxuGK2Q1iuNfMK2k5+pL9twIrT3k7ioBPuexmT2/8JMxO0cKLz?=
 =?us-ascii?Q?V5rzi972j5DOvVnXJIjQmhItFWuBetEqIQvThWkZMaihESdrk14NgRUpjO72?=
 =?us-ascii?Q?VCR9vv7dG9W2Ey5c/fdfDUX4ENYcVrgf6B9JdlMIXQG5zWK8PVdDQXSRdwTA?=
 =?us-ascii?Q?YAQyYh1jkyEU8RvwuOXCcUXmcfA9lakDOAXQHwz7nG/kP/gjjvgg4VKNzJDj?=
 =?us-ascii?Q?ByT02UUz8sWsmb3FzVeq+5TT7JZU/wHdzvp/LTGtfcn1Hr5ivI1R7N8eVS5v?=
 =?us-ascii?Q?cMh/AErBy06/Fv6oWTVBP2wS0ZNSeIvSfYKXclXcpjDxOvg2CBkLBddt2Kq6?=
 =?us-ascii?Q?B2/dCgXfAirj4sFrxpkr6EYHKX0xGaT3XEkvPaPYVO569iM4zOjvtN5UJ8lW?=
 =?us-ascii?Q?2u0jnIDzuZIHdQK526MveyuE5Gh4P6j/3xWD20B7OVUUdfQR3IToi2s+q3sy?=
 =?us-ascii?Q?8XRfcya4ZJOOH4EJjq4x2PAy5mXvC8uFvYHOdrSVa411T63PGf7/VphQg4uK?=
 =?us-ascii?Q?xsDXS0DL5zNdrbTQ9Oetvqfx+8MR6O32aIGwO4/7lJDfM2wpnqzvWjZev7DK?=
 =?us-ascii?Q?AIOV0uhItzhKsH9uRk1XbHVM1CEK9pje1dPi+BHXh5rLHdxZfInqNAjyA8ha?=
 =?us-ascii?Q?EPeBXH23PC9f4qi7dXxgs/0vaT6KBaiSga2+yzmySEUo2JDdZcr224e4wQHj?=
 =?us-ascii?Q?+QLFTQzwpiQ0r4sGCQ8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB7195.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dce81984-8253-4c0d-38c2-08dcfc153e77
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2024 14:38:55.1767
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VyA8BvrzmDNvdDZSgyCfBQwOq4dgWIR45de/h3REeSFtdpmiPhFAU1yzj49K+GK+aYKOHtzGSd0qhsG6OntpNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8878

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, November 1, 2024 9:55 PM
>=20
> On Thu, 31 Oct 2024 15:04:51 +0000
> Parav Pandit <parav@nvidia.com> wrote:
>=20
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Wednesday, October 30, 2024 1:58 AM
> > >
> > > On Mon, 28 Oct 2024 17:46:57 +0000
> > > Parav Pandit <parav@nvidia.com> wrote:
> > >
> > > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > > Sent: Monday, October 28, 2024 10:24 PM
> > > > >
> > > > > On Mon, 28 Oct 2024 13:23:54 -0300 Jason Gunthorpe
> > > > > <jgg@nvidia.com> wrote:
> > > > >
> > > > > > On Mon, Oct 28, 2024 at 10:13:48AM -0600, Alex Williamson wrote=
:
> > > > > >
> > > > > > > If the virtio spec doesn't support partial contexts, what
> > > > > > > makes it beneficial here?
> > > > > >
> > > > > > It stil lets the receiver 'warm up', like allocating memory
> > > > > > and approximately sizing things.
> > > > > >
> > > > > > > If it is beneficial, why is it beneficial to send initial
> > > > > > > data more than once?
> > > > > >
> > > > > > I guess because it is allowed to change and the benefit is
> > > > > > highest when the pre copy data closely matches the final data..
> > > > >
> > > > > It would be useful to see actual data here.  For instance, what
> > > > > is the latency advantage to allocating anything in the warm-up
> > > > > and what's the probability that allocation is simply refreshed
> > > > > versus starting
> > > over?
> > > > >
> > > >
> > > > Allocating everything during the warm-up phase, compared to no
> > > > allocation, reduced the total VM downtime from 439 ms to 128 ms.
> > > > This was tested using two PCI VF hardware devices per VM.
> > > >
> > > > The benefit comes from the device state staying mostly the same.
> > > >
> > > > We tested with different configurations from 1 to 4 devices per
> > > > VM, varied with vcpus and memory. Also, more detailed test results
> > > > are captured in Figure-2 on page 6 at [1].
> > >
> > > Those numbers seems to correspond to column 1 of Figure 2 in the
> > > referenced document, but that's looking only at downtime.
> > Yes.
> > What do you mean by only looking at the downtime?
>=20
> It's just a prelude to my interpretation that the paper is focusing mostl=
y on the
> benefits to downtime and downplaying the apparent longer overall migratio=
n
> time while rationalizing the effect on RAM migration downtime.
>=20
Now after the new debug we shared, we know the other areas too.

> > The intention was to measure the downtime in various configurations.
> > Do you mean, we should have looked at migration bandwidth, migration
> amount of data, migration time too?
> > If so, yes, some of them were not considered as the focus was on two
> things:
> > a. total VM downtime
> > b. total migration time
> >
> > But with recent tests, we looked at more things. Explained more below.
>=20
> Good.  Yes, there should be a more holistic approach, improving the thing=
 we
> intend to improve without degrading other aspects.
>=20
Yes.
> > > To me that chart
> > > seems to show a step function where there's ~400ms of downtime per
> > > device, which suggests we're serializing device resume in the
> > > stop-copy phase on the target without pre-copy.
> > >
> > Yes. even without serialization, when there is single device, same bott=
leneck
> can be observed.
> > And your orthogonal suggestion of using parallelism is very useful.
> > The paper captures this aspect in text on page 7 after the Table 2.
> >
> > > Figure 3 appears to look at total VM migration time, where pre-copy
> > > tends to show marginal improvements in smaller configurations, but
> > > up to 60% worse overall migration time as the vCPU, device, and VM
> memory size increase.
> > > The paper comes to the conclusion:
> > >
> > > 	It can be concluded that either of increasing the VM memory or
> > > 	device configuration has equal effect on the VM total migration
> > > 	time, but no effect on the VM downtime due to pre-copy
> > > 	enablement.
> > >
> > > Noting specifically "downtime" here ignores that the overall
> > > migration time actually got worse with pre-copy.
> > >
> > > Between columns 10 & 11 the device count is doubled.  With pre-copy
> > > enabled, the migration time increases by 135% while with pre-copy
> > > disabled we only only see a 113% increase.  Between columns 11 & 12
> > > the VM memory is further doubled.  This results in another 33%
> > > increase in migration time with pre-copy enabled and only a 3%
> > > increase with pre-copy disabled.  For the most part this entire
> > > figure shows that overall migration time with pre-copy enabled is
> > > either on par with or worse than the same with pre-copy disabled.
> > >
> > I will answer this part in more detail towards the end of the email.
> >
> > > We then move on to Tables 1 & 2, which are again back to
> > > specifically showing timing of operations related to downtime rather =
than
> overall
> > > migration time.
> > Yes, because the objective was to analyze the effects and improvements =
on
> downtime of various configurations of device, VM, pre-copy.
> >
> > > The notable thing here seems to be that we've amortized the 300ms
> > > per device load time across the pre-copy phase, leaving only 11ms
> > > per device contributing to downtime.
> > >
> > Correct.
> >
> > > However, the paper also goes into this tangent:
> > >
> > > 	Our observations indicate that enabling device-level pre-copy
> > > 	results in more pre-copy operations of the system RAM and
> > > 	device state. This leads to a 50% reduction in memory (RAM)
> > > 	copy time in the device pre-copy method in the micro-benchmark
> > > 	results, saving 100 milliseconds of downtime.
> > >
> > > I'd argue that this is an anti-feature.  A less generous
> > > interpretation is that pre-copy extended the migration time, likely
> > > resulting in more RAM transfer during pre-copy, potentially to the po=
int
> that the VM undershot its
> > > prescribed downtime.
> > VM downtime was close to the configured downtime, on slightly higher si=
de.
> >
> > > Further analysis should also look at the total data transferred for
> > > the migration and adherence to the configured VM downtime, rather
> > > than just the absolute downtime.
> > >
> > We did look the device side total data transferred to see how many iter=
ations
> of pre-copy done.
> >
> > > At the end of the paper, I think we come to the same conclusion
> > > shown in Figure 1, where device load seems to be serialized and
> > > therefore significantly limits scalability.  That could be
> > > parallelized, but even 300-400ms for loading all devices is still
> > > too much contribution to downtime.  I'd therefore agree that pre-load=
ing
> the device during pre-copy improves the scaling by an order
> > > of magnitude,
> > Yep.
> > > but it doesn't solve the scaling problem.
> > Yes, your suggestion is very valid.
> > Parallel operation from the qemu would make the downtime even smaller.
> > The paper also highlighted this in page 7 after Table-2.
> >
> > > Also, it should not
> > > come with the cost of drawing out pre-copy and thus the overall migra=
tion
> > > time to this extent.
> > Right. You pointed out rightly.
> > So we did several more tests in last 2 days for insights you provided.
> > And found an interesting outcome.
> >
> > In 30+ samples, we collected for each,
> > (a) pre-copy enabled and
> > (b) pre-copy disabled.
> >
> > This was done for column 10 and 11.
> >
> > The VM total migration time varied in range of 13 seconds to 60 seconds=
.
> > Most noticeably with pre-copy off also it varied in such large range.
> >
> > In the paper it was pure co-incidence that every time pre-copy=3Don had
> > higher migration time compared to pre-copy=3Don. This led us to
>=20
> Assuming typo here, =3Don vs =3Doff.
>=20
Correct it is pre-copy=3Doff.

> > misguide that pre-copy influenced the higher migration time.
> >
> > After some reason, we found the QEMU anomaly which was fixed/overcome
> > by the knob " avail-switchover-bandwidth". Basically the bandwidth
> > calculation was not accurate, due to which the migration time
> > fluctuated a lot. This problem and solution are described in [2].
> >
> > Following the solution_2,
> > We ran exact same tests of column 10 and 11, with "
> > avail-switchover-bandwidth" configured. With that for both the modes
> > pre-copy=3Don and off the total migration time stayed constant to 14-15
> > seconds.
> >
> > And this conclusion aligns with your analysis that "pre-copy should
> > not extent the migration time to this much". Great finding, proving
> > that figure_3 was incomplete in the paper.
>=20
> Great!  So with this the difference in downtime related to RAM migration =
in the
> trailing tables of the paper becomes negligible? =20
Yes.
> Is this using the originally
> proposed algorithm of migrating device data up to 128 consecutive times o=
r is
> it using rate-limiting of device data in pre-copy? =20
Both. Yishai has new rate limiting based algorithm which also has similar r=
esults.

> Any notable differences
> between those algorithms?
>=20
No significant differences.
Vfio level data transfer size is less now, as the frequency is reduced with=
 your suggested algorithm.

> > > The reduction in downtime related to RAM copy time should be
> > > evidence that the pre-copy behavior here has exceeded its scope and
> > > is interfering with the balance between pre- and post- copy
> > > elsewhere.
> > As I explained above, pre-copy did its job, it didn't interfere. It
> > was just not enough and right samples to analyze back then. Now it is
> > resolved. Thanks a lot for the direction.
>=20
> Glad we could arrive at a better understanding overall.  Thanks,
>=20
> Alex


