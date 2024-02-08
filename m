Return-Path: <kvm+bounces-8296-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5731984DA3F
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 07:43:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B1871C2353F
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 06:43:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13696692FA;
	Thu,  8 Feb 2024 06:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ckTQ459q"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2074.outbound.protection.outlook.com [40.107.102.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1FA67E74;
	Thu,  8 Feb 2024 06:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707374587; cv=fail; b=hayFjqRjb/+i9zQkrdZjsKg0Fzr9PzI8/dYvCcMlTlVRyhCgAWKQR7PbO7fsd3noj1dq18xZhcYA5QbhUVIfMQJvyy1BWYrrE6BA0dEiiZUFtE3qZJ5/OvpfgRDK4HKHVZOv9153DAj4rDDHMkydt/8CBuQ+DWeYYrFZ1dGcuyY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707374587; c=relaxed/simple;
	bh=ws22PBKfD6C5RWLL3qYQbPRvpBTxZ2eLGQIjAs9T5Ok=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VGCWWqbSqm7HcXEGn0hayMUD2qCSz6LW7i2DU5X1G64ZVCOFcUn89BzClIpPLPVP9463CHeEc3A2Y0/zmDHFhc5Dz68oZKhzSa4Y3fNqIg7/m2+l8t1FpJkIR2LTpFVdCdpwNd2I+p6s8Zq5K1jaBw9B/jwXxi4lcAecV/EEQFE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ckTQ459q; arc=fail smtp.client-ip=40.107.102.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nt8sfHALHT23ikKD2ns8ZknjEL7ptiX7SEevDDK/tBLSj29kWXGi9aBPgDtFB5mjPYlih8lBKFJ5tXdbSZRdjR6lsqY40O3ZO2my1cqZnobu89MGWQi4yQOQwvF9hCauSuqSjQfVHxDwR/XElIl6eY2KLmkhgaK+x9JYZ6hjT+Eq1yCoTrEKJNas8pvwRRWGW5DCzIcOCpQ4t3rFE88awU/XkA5k3WjyXdoFTJrB45qxnewFfqlLGC3WeVXbBGLXQPGsfKlC+Bdh2GExyq+J7ZJHkVUihsF1BuKODS+5adTN5FkvqKCb19sRqsYl8d2kWzRbxAR7gE1IafWPlXvpoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ws22PBKfD6C5RWLL3qYQbPRvpBTxZ2eLGQIjAs9T5Ok=;
 b=hcTYjlWW1O3Tp8RHuHBKN/6PmJiCpq9tHjgNpAAOvAhKVf1qQDG9RdySxtcsjr6umIqqQhE7miARnF67qNL8cTh2UM61RbR7FgmXLjp+elUsl7eNUgbXgBG8/fsqn3o3yBumW4WKR6jdyakNjd2geLjMJicTqsTOpitdOGre9r24438FLT7ys9IDOmOVZA1+aqJMK+R2qnrpRI7UVpV9OI9NR1xUQIkZE9kVKrTCJih69IjOSgzHIeTEsYkE8MZLj5TsQPTC/9/AJfxOWtEuCq9563K8ceh6U/ZMP7jsS9XN+fMYAbLnTq0TddEn9gzHgAf7RXE7yxvb0ObiYJYNog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ws22PBKfD6C5RWLL3qYQbPRvpBTxZ2eLGQIjAs9T5Ok=;
 b=ckTQ459q7GYdYLA7OX/byshj3U6GtAVwhI5xskhFEoXrXyANzq/whG2aankcU/inpgCnnA8TyclO5A7ZrvfMxMCOfsj/gFowxTnDdnjA/hNMJigS+BG5qpHNK61c5VUB4hSMbBlaAFZnDjolGn2onNrXOUq5EGOuzCTrzLT2H97qoDTXS2vuLTPLa3B6/ceg51hEkUkvfO+KF/IRg2NowRvFquIfDgdzKE/WLnk4Ig8OoxiLqgchHFcPky0Kp38YiKM6vFWXMvr2PPMGcL9Ol5RaMM9nZ7XYue4m2PqMgBhsMff38QKs+SXuNeSdTGTKOGqYI7nP6ZeKFpG1K60vEw==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by CH3PR12MB8880.namprd12.prod.outlook.com (2603:10b6:610:17b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.16; Thu, 8 Feb
 2024 06:43:02 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::444d:2f33:a61b:3225]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::444d:2f33:a61b:3225%3]) with mapi id 15.20.7270.016; Thu, 8 Feb 2024
 06:43:02 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, Yishai Hadas
	<yishaih@nvidia.com>, "mst@redhat.com" <mst@redhat.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "clg@redhat.com" <clg@redhat.com>,
	"oleksandr@natalenko.name" <oleksandr@natalenko.name>, "K V P, Satyanarayana"
	<satyanarayana.k.v.p@intel.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "brett.creeley@amd.com" <brett.creeley@amd.com>,
	"horms@kernel.org" <horms@kernel.org>, Rahul Rameshbabu
	<rrameshbabu@nvidia.com>
CC: Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti
 Wankhede <kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)"
	<targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy Currid
	<acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John Hubbard
	<jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, "Anuj Aggarwal
 (SW-GPU)" <anuaggarwal@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH v17 2/3] vfio/pci: rename and export range_intesect_range
Thread-Topic: [PATCH v17 2/3] vfio/pci: rename and export range_intesect_range
Thread-Index: AQHaWIdTXGHHJJQjakCN6ZAFUePTD7D//GeAgAAGDvc=
Date: Thu, 8 Feb 2024 06:43:02 +0000
Message-ID:
 <SA1PR12MB7199AA9F83CE8E7F1E8B0022B0442@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20240205230123.18981-1-ankita@nvidia.com>
 <20240205230123.18981-3-ankita@nvidia.com>
 <BN9PR11MB5276BB50143B801E8F02D9958C442@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To:
 <BN9PR11MB5276BB50143B801E8F02D9958C442@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|CH3PR12MB8880:EE_
x-ms-office365-filtering-correlation-id: 1c365fdf-0c19-485c-1990-08dc2871329e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 42etadvtjpAl5I+d5npuV1EvCrsGeYxlL299yHrScZu/+4Wh7edJBOYDl3aSk3Ksdd/zoj7EXSSQcCjoVNAGZ92rX4JiCHhRhMdWpOOeAoExUpDvjHxn2IB6axCHVMBxqVyI2+eATGpaqyKdp0kCpY8waTpg+Bt1DYhVTMh1TxVOUdafVsGgyMqCB+acK9+Gwva9hmRKifdwmEr+NNYIebJ0kdwrGoRX/IU0unxDtpG2OgCzAQdsXB85JOj0mIKYob0PS7AKHLRe1ydEtpsLcAobeYqe6yi8z0B0Mkw2+DW0b6VaD/fphThlW1ZaE7Xx6QO7+RRlzmhK+CACX/7vWGUICXihinaLVP8TVr+FG8GKSetTqZ8EIKNAfNBHr1zB2SrC66yDlbhoHM4x3Kj7829imjv6ICZQmAPXvhFQ9795CAwblp/Ax1q+Sl7mGby9EvSDxO055Qgk5lmKYZV5EDO/ZUCM+GvSSFD7t65M5/s+m8V0GzFMqJWHMYuG3K4NXRZsHuLn8ONmadEWwnfJTmIqxycYuDqFNLYpD/cjWaxL72EYgj4xLJAf8OtmLEMhWQJAl7XizRSspMKtw4jHZPSTE9TPpooorTwrdbJYW2TADQOV9xQC5yg9Zlvv9+9t
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(346002)(376002)(136003)(39860400002)(230922051799003)(1800799012)(64100799003)(451199024)(186009)(921011)(55016003)(66899024)(33656002)(6636002)(478600001)(38070700009)(7696005)(6506007)(41300700001)(86362001)(122000001)(26005)(66446008)(76116006)(2906002)(5660300002)(4326008)(91956017)(8676002)(66556008)(64756008)(54906003)(9686003)(66476007)(71200400001)(110136005)(52536014)(8936002)(7416002)(38100700002)(66946007)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?FXtkQZARIIT2soSwqBgP9sk4/x7zMpvL7hcQUaLh2/AJUmSTazyEJNCi66?=
 =?iso-8859-1?Q?fq+wmEKh3COEonaLJ8QGmEZLQnrR7o7LBumMjnzCsp1LYrx69FtTsXFkzE?=
 =?iso-8859-1?Q?0teivCR1P/9sn+kTRaz2/byhofI6WyM5uk/SUCbo/zkJWnLwotrDYqBBmt?=
 =?iso-8859-1?Q?Eib0EFFuDv7WWFAQXaUWJ/Q1uVdEAH8Z+jQXnHw/alEUwXGIxr5zJ2/Kxy?=
 =?iso-8859-1?Q?MU/cUKJ9JLYQpmOViFQ5JEzxdtWcPcjH5w7/XRHbGFClEOfNYuAybv8SSJ?=
 =?iso-8859-1?Q?B5eBcbzyTSlP90I+UZk3vRNZJacgk3MbgCB7ZVUCJtta5yZrlUW5oxvv0K?=
 =?iso-8859-1?Q?K2dzbZ/ybMdtp3QrPA8AME8ZshxG22xUXJzzTB4VG8pmTVh6+zA+CGsDF2?=
 =?iso-8859-1?Q?7s0rClpjydI76ujWIGiBuNqOcV9ykCiHiwu6YLTJprLax5tWvfEQGFsKGe?=
 =?iso-8859-1?Q?eAzMqEmnFkIHrIHh3ceNSH4X/eU4dR6Rbx5uSKlVcEen1VPaygnU941Em4?=
 =?iso-8859-1?Q?hdQ9KQw111UJ4EPnyEpXHSCqCJekKE0j09ysWoVHLBtRQ0/O2NEDfphuHg?=
 =?iso-8859-1?Q?LOGBvT85eDaAx7icvZWM1SDNF+d+okOV6k/4P4LliIWMFwGUn6jVE0UuyU?=
 =?iso-8859-1?Q?ah2G+WPl1UJiRIWFfgP82LXAFLIzftBawVlf13YNvVZ/QQHz8A0KxL2VoU?=
 =?iso-8859-1?Q?0yL2VQpQTXIUU6ia6M8wmg/5sBbjWiGTi/PLTCLImd27t7Gcb9aUW1tbTU?=
 =?iso-8859-1?Q?Q+c9XjJeAifx1s2RqGxR7JsJMAh6/YR2k+Cvi8iIBU9S/T67gQMMGeHb9b?=
 =?iso-8859-1?Q?XmimddgxKk9Kjf4/TI2aO6ri08K0jke6vzafwqTiMpGzq0z5AqFUi+n7td?=
 =?iso-8859-1?Q?xgVOqcXHQb6s1x7E3ujooKqEYT9t1+Da5TiBdXVcrQshBDkUjaSFcNeFBw?=
 =?iso-8859-1?Q?xVTkIUEUtIv4c4++PZS0d33GccOaESv7dolb5p9xPCpFnsLYxdDVPjFOsa?=
 =?iso-8859-1?Q?nHDtXVURHDilSZYDPu8XSdWs1Ghqyjuwmy4qfmwgIS/dG8Gp1OEMzpF2He?=
 =?iso-8859-1?Q?7oxFXr8JgxNK+TiO0RBSk/Fd2NZ6Ffl9TUAYXovHyH9wEaBWOW0E9gfMa9?=
 =?iso-8859-1?Q?VKv28bkdK95/Uu2azl2QKmAxmrc+LqsAUnmaaUMyEiaSpXiMaUDybD4XDJ?=
 =?iso-8859-1?Q?4OV87+HYUM8ThB2nycK7sbjnmJuWayJelEyq03mgRzXnklQjD0I1K3H8IL?=
 =?iso-8859-1?Q?FQK7PYu4MGpin8SVIkjBgvBkyTvi3xg0J7/T/tnR3nCI10nTYO6etZ2ZlL?=
 =?iso-8859-1?Q?4KJAsILARA/H0dD7GfDl05CiGXjlbgigrC3S3qdw/1pXM8jen6k+FcQh8u?=
 =?iso-8859-1?Q?Vj3GYamOfjRiEUFvUUwNRfLKdZRxVnabosL4uju/fyuTt8D2zTLsu/Q7LS?=
 =?iso-8859-1?Q?6wQnQYMelNNQ8lKcDNMT8reL/ESFkvS23SUKxq/EG24AK6t8iw44MSrPML?=
 =?iso-8859-1?Q?4/4vk9RVbncSBS/fFh0xIlmFbjhwFVlfPQoMXNmKShEVqkGyFofXfHLgbw?=
 =?iso-8859-1?Q?RTdVw9tIhdbUjk6qOVPZ3HRfFbL/xK5cr+f334+pwG5zQ2IDaJe02Nz7PV?=
 =?iso-8859-1?Q?Y1v4NoUdiU5Ek=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c365fdf-0c19-485c-1990-08dc2871329e
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2024 06:43:02.4878
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ANEon/8bq049qnDdPUC69TRGo1DvR6NgdSoxmEY/P60KhYUWELkwBQmCpBqPx0n9D+xnqSEipZNCdWd/+4jZQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8880

Thanks Kevin.=0A=
=0A=
>> range_intesect_range determines an overlap between two ranges. If an=0A=
>=0A=
> s/intesect/intersect/=0A=
=0A=
Will fix the typo.=0A=
=0A=
>> + * vfio_pci_core_range_intersect_range() - Determine overlap between a=
=0A=
>> buffer=0A=
>> + *=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 and register offset ranges.=0A=
>> + * @range1_start:=A0=A0=A0 start offset of the buffer=0A=
>> + * @count1:=A0=A0=A0=A0=A0=A0 number of buffer bytes.=0A=
>> + * @range2_start:=A0=A0=A0 start register offset=0A=
>> + * @count2:=A0=A0=A0=A0=A0=A0 number of bytes of register=0A=
>> + * @start_offset:=A0=A0=A0 start offset of overlap start in the buffer=
=0A=
>> + * @intersect_count: number of overlapping bytes=0A=
>> + * @register_offset: start offset of overlap start in register=0A=
>> + *=0A=
>> + * The function determines an overlap between a register and a buffer.=
=0A=
>> + * range1 represents the buffer and range2 represents register.=0A=
>> + *=0A=
>> + * Returns: true if there is overlap, false if not.=0A=
>> + * The overlap start and range is returned through function args.=0A=
>> + */=0A=
>> +bool vfio_pci_core_range_intersect_range(loff_t range1_start, size_t co=
unt1,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 loff_t range2_start, size_t coun=
t2,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 loff_t *start_offset,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 size_t *intersect_count,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 size_t *register_offset)=0A=
>=0A=
> based on description it's probably clearer to rename:=0A=
>=0A=
> range1_start -> buf_start=0A=
> count1 -> buf_cnt=0A=
> range2_start -> reg_start=0A=
> count2 -> reg_cnt=0A=
> start_offset -> buf_offset=0A=
>=0A=
> but not big deal, so:=0A=
=0A=
Fine by me. Will rename them.=0A=
=0A=
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>=0A=
=0A=
Thanks!=

