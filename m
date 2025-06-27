Return-Path: <kvm+bounces-50958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61A7EAEB1A0
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 10:51:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 393543B68F4
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 08:50:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB7F827EFF3;
	Fri, 27 Jun 2025 08:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="GdMd7GeR"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11020116.outbound.protection.outlook.com [52.101.193.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D68E27A45D;
	Fri, 27 Jun 2025 08:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.116
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751014250; cv=fail; b=r0jPIaSKppVUDf6Bzz8spSIrUY150/+Y0KwLP/vhiPT0JQTQf0JpbNosfwPSgHMo07ScmHaiIhoRrjHudoFYZDaQRQGTuQRSEKg7qQN/h9X6FmWHtGrZqiLJkyG+r0WOvQC4VWaDW/ylt5jRntF1W1bkBc/p3q9MC/2Y43UqjQw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751014250; c=relaxed/simple;
	bh=1RxfhHKbxfxap5wT2Nzshl0gHcpVfWgwr2Ud4K8+3ps=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cr6RHtWudlIQtJ6RD9kwj5tDZZVJ0RABZhm8Rzs36BLI7sFZkV8L00Qp5Vag9nhNtKcboqm/79vxaal6h3WnATJpBRRjOJiZiZUFii6F5BZcX6E2Ca1XFVWJfW6Gr0O6yEmXefjif2jwce+hl0k+G6036P6fiJ3uPfD484bAc3s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=GdMd7GeR; arc=fail smtp.client-ip=52.101.193.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L/C4pmGJELz+syom9KqO0/meLJB5Tj3WJBXRY5wkV0T2i3Dv9pz4PT8J1ToAKpV8N80CZbY7Q+MUo6OSLoDvZlbhXF+pikEH59nLPZjtWWX4qV+9MrykMttPcY1W1UwwaEwVMY39P08lugxKCZqxduY0cfip3dP4q2LNjMwqP0KPvnhr5m03GdQZyFcLDWPtC35ZBeXEtIRWKqsHTRL+u7WyIWVJhn02nIKGnTEENW44wuCgYq+IDcrW8lD6Tq1JvPSL6jOkebWbXR7Q8zr6brqvSc7+HwZ7bO/v2ntzQ7SDv9is5gc1CzeniUDVoxf6V2CjLhUyQF3i71WTXB1y9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1RxfhHKbxfxap5wT2Nzshl0gHcpVfWgwr2Ud4K8+3ps=;
 b=wl0r+Zpp4ParBYveDQOlD7TpIoZB/AuzIVaLaEDLGOtHvAHu1+tOIIfyz/1stn/knG1aUbbQdi4vdFnwlcNKQQTiBDEIbouGErDGWzvCn3vQk609T4Zs3uaPRKIq2E/QP8PpEr3GAysklb7O5LCHzk8NLKir4QGCb7p4OR5R85w7y3psXRCWDk+JVl21K0IcjAXXX/baCfysnvWFGFLzvnUUWsiegziJtAhD/RYOH+CxCdJtrpVqfNZNm31r/HF9kbgfsThhHwoX4O6f8U0Kr3UquvznE0VkiE8fgRohqwfDueRta6XSVU+0g9GUKbOF08+6la3fxmSNxes68gwnEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1RxfhHKbxfxap5wT2Nzshl0gHcpVfWgwr2Ud4K8+3ps=;
 b=GdMd7GeRV56gQdnZwB68PwfF24BW4bLxolanEYlSZJW22qIXYzNiLTr4hEzF+7IaPf597xvFWPMKw20lwKFz2FDy4HyPyQs3miP6Eh+J0C3+HRyOZZZGZDwykfRRgh/ZKnS3ROOxkp0PE3A3boLNt2696YROXJ4P+j4kSlvjx2U=
Received: from BL1PR21MB3115.namprd21.prod.outlook.com (2603:10b6:208:393::15)
 by LV9PR21MB4686.namprd21.prod.outlook.com (2603:10b6:408:2ed::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.11; Fri, 27 Jun
 2025 08:50:46 +0000
Received: from BL1PR21MB3115.namprd21.prod.outlook.com
 ([fe80::7a38:17a2:3054:8d79]) by BL1PR21MB3115.namprd21.prod.outlook.com
 ([fe80::7a38:17a2:3054:8d79%3]) with mapi id 15.20.8901.009; Fri, 27 Jun 2025
 08:50:46 +0000
From: Dexuan Cui <decui@microsoft.com>
To: Xuewei Niu <niuxuewei97@gmail.com>, "sgarzare@redhat.com"
	<sgarzare@redhat.com>
CC: "davem@davemloft.net" <davem@davemloft.net>, "fupan.lfp@antgroup.com"
	<fupan.lfp@antgroup.com>, Haiyang Zhang <haiyangz@microsoft.com>,
	"jasowang@redhat.com" <jasowang@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, KY Srinivasan <kys@microsoft.com>,
	"leonardi@redhat.com" <leonardi@redhat.com>, "linux-hyperv@vger.kernel.org"
	<linux-hyperv@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mst@redhat.com" <mst@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"niuxuewei.nxw@antgroup.com" <niuxuewei.nxw@antgroup.com>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "stefanha@redhat.com"
	<stefanha@redhat.com>, "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>, "wei.liu@kernel.org" <wei.liu@kernel.org>,
	"xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>
Subject: RE: [EXTERNAL] Re: [PATCH net-next v3 1/3] vsock: Add support for
 SIOCINQ ioctl
Thread-Topic: [EXTERNAL] Re: [PATCH net-next v3 1/3] vsock: Add support for
 SIOCINQ ioctl
Thread-Index: AQHb5ld+eVM5DgeyJkaZiqfinVY+c7QWs+ZQ
Date: Fri, 27 Jun 2025 08:50:46 +0000
Message-ID:
 <BL1PR21MB3115D30477067C46F5AC86C3BF45A@BL1PR21MB3115.namprd21.prod.outlook.com>
References: <wgyxcpcsnpsta65q4n7pekw2hbedrbzqgtevkzqaqkjrqfjlyo@6jod5pw75lyf>
 <20250626050219.1847316-1-niuxuewei.nxw@antgroup.com>
In-Reply-To: <20250626050219.1847316-1-niuxuewei.nxw@antgroup.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=78c73eb6-9d81-48ea-8aeb-7407a139a477;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2025-06-27T08:48:45Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR21MB3115:EE_|LV9PR21MB4686:EE_
x-ms-office365-filtering-correlation-id: 2cc79915-f41c-48c3-6d3f-08ddb557b535
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?1JtcrMP59tX7cSUaiLbXb4G6SH/lfzfzD1nbz72Hh6TQ9z3cJfQLkNWZrWhy?=
 =?us-ascii?Q?aLQm6xF5sITsAGcOfAaQ1uKD9XCmLFxwq9A6iuaVZvpqfRd92uLorSO5VFhq?=
 =?us-ascii?Q?1S6N7c0VCAIeVPmiM1RpyKGMLD/GzRPabw320nzuyK2kmT/dANd04cIww54p?=
 =?us-ascii?Q?t3Rg0f8W7BH0Pm+Oph7QiKuzWEnIO3VWzlguzN5fTVSGQUnSeo/Qd4Y6vRa7?=
 =?us-ascii?Q?0zUV9NZ8zyxmbEzAB4tHzYgZOY/Aw490YGQZo5bQ0lP9vpmN9y/U92TegOSa?=
 =?us-ascii?Q?iMQymxzIiWa74K6bzq4mow+Tu7CuxMf09ytcarfdrAC5kRfZAUPWmLJZ6gI2?=
 =?us-ascii?Q?a14Gb1ymwFS0UYShYCc51cHtMJIJfO/skX6M4ZO/NdNrjNGemX8yEXvmpx3Y?=
 =?us-ascii?Q?SZiqgA7/58169kT2m8AEQTrzVynYjjRvR+kcvBFFxrPtCKuMC8LnLPGmbXQI?=
 =?us-ascii?Q?7G6LwnxTMvX4wKSQriiZPvROf82jRCrNekf6LqLKGAsp7GYF6xgv8UmEH2Yp?=
 =?us-ascii?Q?8HeUXLh6kImRDzQ44q9DCDXMtMhLJo8teoARibJoyP0RgDIhqDuSjYR8eLLb?=
 =?us-ascii?Q?jQxYHC5MwSGnuAYsuNyrNdQMPbqOm/tFuuCg9+Y8YtFwkfLRWg4htR7yys/P?=
 =?us-ascii?Q?+IaC2C89WxS30eUc6niyeVPz5qxqP+QHAwbh/PzCqdiOPz464WLU7VFdtJ3h?=
 =?us-ascii?Q?h94gUwJWCqACXLc/xlLHmEK5J5xrgsWT5Ftxk9F0iSDHq8QMxhKq/sUBQ/n5?=
 =?us-ascii?Q?X9Ia1mHm+XACHh2LzbHSQRy7Cynk8nfsAD8h6DF4GATna2sOzoG2r4Xxa6uK?=
 =?us-ascii?Q?hQqBYthj31FQVmHC6F5szj72pBiCK2dd4LWgKAWxR++JhMFEUkN8h4GgHGvS?=
 =?us-ascii?Q?wCPh3fndUvon9faJZdPW/lR1ImyNy0vnPjckX+WTgzazZRjDV2AstQM5PZnj?=
 =?us-ascii?Q?ZnP7mGjP5XkoHZvvOk5vC7Dgi1+yWxfzisoIlkhTsXk/01UKVQiFOZpnsofd?=
 =?us-ascii?Q?w2D2M6nWW0H12381e5gfR6tHkgfVfXTeiwDXC5bqntS0Doqxa37pgL3KWuOu?=
 =?us-ascii?Q?siybZPJueiIEoQD+6+XFp/5Z6iwwJYiO0jn6P6pb3DglXN+zHLYZXlMfTctW?=
 =?us-ascii?Q?6UJB/WPs4Ghh18xs4L6caxBZ5xlFMnvNc3Nyxo39AgxbGL8pLW7RDWeLe+wH?=
 =?us-ascii?Q?PiC2JLqC9SizhNaWsHLb8d2G5KvdRocuc00tD6NGOAgEjGMuDAIx+EXBfKk7?=
 =?us-ascii?Q?qq4PYwnv9yAWGxMH49LvWMGNHNqCGZrum4TEKE2WVTIilXbd1b4FDL8UL6zk?=
 =?us-ascii?Q?91qusEHLF1X0Yynv/zsSUMFSkygu7BXMvmWN07KH3rgOkhbrzx2JQBbvjBcs?=
 =?us-ascii?Q?LeQs3Oo9xKpS/GUStQrzhFTHq3D9o9vDA078vlBekwkokRE1OrVHy2aK9ozV?=
 =?us-ascii?Q?ona6Ib0QtfI=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR21MB3115.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?/RwFjDdRX+xJkWnRS3hQMaPzU6L8WmV/1E8dFG2FR99Edbg64XsQ6IQPTX8d?=
 =?us-ascii?Q?LWGVwfHpRczG8NYbk4W56djn28MMp2Goxad3wIDeQYtIGup1mwsNw3A2OTH1?=
 =?us-ascii?Q?g3A4PLNhYQDW+X/HUZsl5K8rppjWColmAYQOGfb99BVNHV9usC1Y8AfQR2bj?=
 =?us-ascii?Q?81V2tjt4qEMueGr65sQ2RH/ckAwU70RoJR/H/OM8jTMSOvDNvPz2casYA7mj?=
 =?us-ascii?Q?cKXP9D2AGhsOkQF63PW74lMlDOip0n12S4qlhhXz6oFbuhJKfYQ8DgutPpg3?=
 =?us-ascii?Q?DSdwttZ3y1rBddpfL16Cb0j2qkLjxMzoSJE2hhfnKx+YF+/OINiddE8QGxvz?=
 =?us-ascii?Q?728Sml/vy8/AFZW4n1JEzBBJywpMaQ8skr/gESlsvDDA8wt1zfoHTtRZUFif?=
 =?us-ascii?Q?pxmYZCTZhb2ds4nhlLVMbUsJqP5MQCnBQ5cs4NvS105ACysSs6vF7hiNDNfC?=
 =?us-ascii?Q?sslrny+cv+HthCTfLM6ItJa6lhP+Ji7Z3wkJHDshKqRvuUZGl30ZdKfaOF2G?=
 =?us-ascii?Q?pq0idQA5TWE7fB87j4/yrFxIMTabcQY911Knkd0i14gm3Iz1ia2nOpQu/CFJ?=
 =?us-ascii?Q?5/tUXrn/9EwXTikg1TIiIcniZuJwTtBIKGnnbjEyeC6AnW+oz7vB22veck+P?=
 =?us-ascii?Q?K0SNKDBvDaVrMz+BuKVGMQDolk91sTsbCPk86YYTfIl5BufohY8KpNXCfUIE?=
 =?us-ascii?Q?q+dpO0SiPPcnxQ/3OZQOX3TkmCEnzoFAQSv0K4zf2kIK6htSPiAGDHT/diLg?=
 =?us-ascii?Q?48cd2EkSuV8fepV88Ceq4MW8BVK7EJuD7NLau6K/7Ez29PSwWIL5c9FE4ZVO?=
 =?us-ascii?Q?GyfgTLkZN1MzXO1fqqK5k8TEf9C4j8LWWiaxtzgh9a8DAZF/W27WH2K5Ef7I?=
 =?us-ascii?Q?ajt91YhHce4wPrhV2c/VyWvzL6GsUF+tugNCx88XZYIOxIBdbCZXmOuy+E5M?=
 =?us-ascii?Q?Eov53pxGoAkmVbXZslcrgP1K8ZLI78naXM7yRKbX9sbTnI1sJKxbVkqVrrrv?=
 =?us-ascii?Q?EkJ7txA0BzNPbbqYP7sLcm66VOnzFMDdsFOT825+MmF2zyabS0v1hcuFTvt/?=
 =?us-ascii?Q?m1FfJQjgiO9O9X4Q24tlqYMi3SORYcbh1xd/bumcP9Q++swwNn75i8IbFkNh?=
 =?us-ascii?Q?TehevbbQQJry4147TdHmuN6zoe9YF5EiNG+qTJAcQ3LOlbUFFieSxCr1bbKv?=
 =?us-ascii?Q?FS4znAt46il4XND/wUubxzBBkx1kBBuc8rYTyvpjU9Cd8EaILqLVimvdtd68?=
 =?us-ascii?Q?C9rJociPDAUh1C7CJVKenOaj3X0JXV9brABoLFhkVylIyezPL3wsEQMCD6dC?=
 =?us-ascii?Q?e1xOGFdI7+42pWBx5k44/dVv4ZvNY5rUdCE+o7KvivbyREbHzfGUh0q2A1/O?=
 =?us-ascii?Q?dz43kOPFcjvXKiAPs/tg5w5y2coN5pSFfIpqIBZNRJkQPQmpnff24xU1ZNpn?=
 =?us-ascii?Q?oOEDbPHSxxYXgDpOiN/6ATSAyzaxBFf+DbKFvY7TMJfQZ5EFs8KbaQEiSVdj?=
 =?us-ascii?Q?TIWz/SI3PaEz4RkwNIJwKjfuxT+Aa4Jsf8rH3FbXxVNPvcNM7+mwdD552B7A?=
 =?us-ascii?Q?RuavFRUM9SHYSm3x0tXQ9py0AaIFaLiCWoPAOOJh?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR21MB3115.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cc79915-f41c-48c3-6d3f-08ddb557b535
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2025 08:50:46.3326
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T+/fary8MojBnZkf3h0iJ3DjvTWatg0XP3MieWWY1bM7KzF19eJW3FadstQG1ASw9lzZIMKL6bXrlc47/cgrbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR21MB4686

> From: Xuewei Niu <niuxuewei97@gmail.com>
> Sent: Wednesday, June 25, 2025 10:02 PM
> > ...
> > Maybe when you have it tested, post it here as proper patch, and Xuewei
> > can include it in the next version of this series (of course with you a=
s
> > author, etc.). In this way will be easy to test/merge, since they are
> > related.
> >
> > @Xuewei @Dexuan Is it okay for you?
>=20
> Yeah, sounds good to me!
>=20
> Thanks,
> Xuewei

Hi Xuewei, Stefano, I posted the patch here:
https://lore.kernel.org/virtualization/1751013889-4951-1-git-send-email-dec=
ui@microsoft.com/T/#u

Xuewei, please help to re-post this patch with the next version of your pat=
chset.
Feel free to add your Signed-off-by, if you need.=20

Thanks,
Dexuan

