Return-Path: <kvm+bounces-33861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EC9509F31F2
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 14:48:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A0781884B34
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 13:48:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFEAC204F88;
	Mon, 16 Dec 2024 13:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hzGJNBAS"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2078.outbound.protection.outlook.com [40.107.223.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ADD529CA
	for <kvm@vger.kernel.org>; Mon, 16 Dec 2024 13:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734356928; cv=fail; b=mwG60MkPjMX0WJMR7Fv39XzOuo1P37EFW1VUBGEqPNOipjcWCYDafHkUvLtAPV1QSueEgKiRIhaIWM6KBlNoi3Hot2LeyBzatZOVFsYO2St7l3mzkW+e3M+B66NnuHVNssp5v7P4OXQccX1z0d2yIx2tuiGmK1K8DSnes8ZCwjY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734356928; c=relaxed/simple;
	bh=wsApo+YlN2IK1Qe9AYfZ6bmqUTZa6KmiDFsXN400jGI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=l1JAMwljMkkdP7BWtW5uc8e/BdASAOyrFw3pHtgu5BKKewaPyoL22tlZRQNRyPkXbmNNHPGCpl+oC9FCfVB38g2NHWevQsOLc33NWhvUEZIzkBGtTfyGeR5BGW7wI6ZfQVwp4yhpVAWzqwXF/GjS4O4I7dbWLUpXowYhGiBhqwo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hzGJNBAS; arc=fail smtp.client-ip=40.107.223.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a+yIjM4A2iSsqRYqtJURC+0BlBmFdg8wXlhfQjZhKovMGTYVoEuqCGZGPyHt3LsrqW59Wdn8pNW0HXLbg9HShhNhwGnIYZF0Gk6bC9VpBUee5M96MtFFfUrUy/WJkNAs4Nwuq0s56HAMzjsWGZ7GiHRKHEvSua49/vrww6XHMN/5AI94NPEHGRfYx7OkGKXCF4Qz+aIdT036S9mDVgHaErpcaPOEoAGNiF5wE/QT+xkXvqCe96tquJg5Z6piKB1zdM8w9BFJbEfzXEJ2iyMDH9yhVzSndwaFl0yXgLoBILkexOGCo1RKVFvd//QHR9f9ni9t/UR0z5002uhNd3gP6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WXm57eXbbk6dob6LUYMebQkAzfX6sSqQjWSLWHm2dZ0=;
 b=S0NxyxLPnZt6P3NM0DcJuT7lzX6jIAyRs0jJQLcFP21OZZFxpdHowcVT+RDajuhV6fqKmjfyaxz10Oq01X4k7ljVR8VaIXqNqBKzNdckT9efq0ZiLgumzrkziTlI7yOD+PODb6B13caIsmzOFu1uRKXaX3M2/bv0yO4vn2gbb+rB/2/t2xMVIz0dmRTv3ZKyHFSCrkbbiE5mZAyyc9xnt55M5Zn8Huw4QHYFtWImtcDXAvXwOA80HJmRFIogWi+jWwV/Vxc1asze9CAgzmVT7yAxyYf/oU4cxxlIobcUDBbht3qFAGEwscm/8mXrh5K6JDu3jSKZdvGTTfv8KGoStQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WXm57eXbbk6dob6LUYMebQkAzfX6sSqQjWSLWHm2dZ0=;
 b=hzGJNBASSMftKXUsIHt5l7WHkPG8d29j/Ag9qmASQYRriouRQpODbb2ASZfBykRiJ3gThqeOpZhdedTeJHDzek4+r7jUFaEoA7H2ILOojRl+3smW1+TdlN7PTYzuP4nW4EtphHcRn5sleawTkjJ7rb7X2wJtgc07kFEqt2QdXEM=
Received: from SA1PR12MB8599.namprd12.prod.outlook.com (2603:10b6:806:254::7)
 by SA1PR12MB8920.namprd12.prod.outlook.com (2603:10b6:806:38e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.20; Mon, 16 Dec
 2024 13:48:44 +0000
Received: from SA1PR12MB8599.namprd12.prod.outlook.com
 ([fe80::25da:4b98:9743:616b]) by SA1PR12MB8599.namprd12.prod.outlook.com
 ([fe80::25da:4b98:9743:616b%6]) with mapi id 15.20.8251.015; Mon, 16 Dec 2024
 13:48:43 +0000
From: "Li, Yunxiang (Teddy)" <Yunxiang.Li@amd.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, "yishaih@nvidia.com" <yishaih@nvidia.com>,
	"ankita@nvidia.com" <ankita@nvidia.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>
Subject: RE: [PATCH 2/3] vfio/pci: refactor vfio_pci_bar_rw
Thread-Topic: [PATCH 2/3] vfio/pci: refactor vfio_pci_bar_rw
Thread-Index: AQHbTNeRcKv+pvbQ+U6127pTRfvCw7LjOZgAgAAlHoA=
Date: Mon, 16 Dec 2024 13:48:43 +0000
Message-ID:
 <SA1PR12MB859934EF026ED5B9B0DD0A88ED3B2@SA1PR12MB8599.namprd12.prod.outlook.com>
References: <20241212205050.5737-1-Yunxiang.Li@amd.com>
	<20241212205050.5737-2-Yunxiang.Li@amd.com>
 <20241212160030.18b376fa.alex.williamson@redhat.com>
In-Reply-To: <20241212160030.18b376fa.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_ActionId=d7ea6080-c66f-4d54-8ee5-a0609b053dd5;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_ContentBits=0;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Enabled=true;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Method=Privileged;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Name=Open
 Source;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SetDate=2024-12-13T01:13:43Z;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB8599:EE_|SA1PR12MB8920:EE_
x-ms-office365-filtering-correlation-id: 42a05e53-e1b8-4226-e924-08dd1dd85b2f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?g0OBWx0qJ5R7PPjXrSomOaLAJXklGsqJ4ZCqo2xMFnZ4k3hcihETORafHOUs?=
 =?us-ascii?Q?tsvZjPJfJivpObIPxejPmJnq0jHiQRGf2+yhQE2ErCCpoak2iYfofZlnNmO2?=
 =?us-ascii?Q?Esp9e7Qri/Reh3iJyPlNsd51riUIZmuaa/oQpBMhMS+aLdLKdZRokFE6rGoY?=
 =?us-ascii?Q?UeUMrwo01N8SfA/a10WxNOAUMA8a7HtMWymUXvlaRKZuEUbzyWHf5hDa+MtV?=
 =?us-ascii?Q?lkpYqXU/ttwC/CS+VdPFoGVNF79zppSgbR+2CVMuGhnSTiu8/6kjzH4G5Kq0?=
 =?us-ascii?Q?Po0Ur2Ao4hL75IbKk0MpigElItjJ2DcjADVgXaAxBahZjD2fjKby0vmYMxt4?=
 =?us-ascii?Q?ICg5w32lljfEyLworgKgrKHICBVVcRMWNIvzI5cpoD7BNwoDBqDLqCpLYE4U?=
 =?us-ascii?Q?HzgaGRphKuZeatPSHDJ8F8sglkfHDS6zgs5Q8k23doeGsyM+J2Jm0luMCQiN?=
 =?us-ascii?Q?aeKETD15YB9+2IetR+ywJjuKUBbsMWK7gAFcTsWK8MpD/1KTWpJ3HhDXgr4C?=
 =?us-ascii?Q?MGLwIGSyG4a2m/Ph6CBwRw7XhmvEX3As4xb+EIkZE//wW/EggnsOdG8T9FG9?=
 =?us-ascii?Q?mza0mkJU1tvR/ucAFFd6ywVxjqn8qgGUCV344YSErjl7MAUXhMPl0OK54A80?=
 =?us-ascii?Q?OWpJv9PruJGLvveHCiP+3duEmRW1Hl2Tb7jPC0UqgX4ABRkIc2fEOyhtxZkc?=
 =?us-ascii?Q?u0CJVdLaouayvw3BJxyH9soR+9K3B+gEWqOSUBaHz2Kn87usMAeXCcS6bAYq?=
 =?us-ascii?Q?kzGTJZtRiPNbAzA+rjolu2tQs8DknD72NaWGxzreVco93yb0hp7mJKhOnxbf?=
 =?us-ascii?Q?doEWj3VOi22P86etPUS+p9/+gKpVV++fAfSQN9WzAGmTCyvof58zNEio3KZH?=
 =?us-ascii?Q?+RrDnfyk5hMl5sAJf/YagKyLqpyLMHt1uNhlGQChK3DxfN4Y+0YRe4+Iz3MM?=
 =?us-ascii?Q?h9tBT9AnYRe/wpuKtv2N4zbZ4aVZzIn3P8mYYOdolPb5VDM6RQoScVt+hDxT?=
 =?us-ascii?Q?2mLyHfSRBM2u5II2crlXvc4zcmI3tnafzM+wRUo6iO4Ka77uy7gWa3t8GtKD?=
 =?us-ascii?Q?vUz+YS9aDin62AXVtU+HRHGIAilfaVmHNXUi91+XlqYzzotddb0N3HkIOYIp?=
 =?us-ascii?Q?8BvglbBmvPZd5rzeyTZpperhDUlveL71biTWDj1NCecYJiHh5I4Qt6AU/UoJ?=
 =?us-ascii?Q?69YhLpRRhezcLZMt8p/4/5ZI/eCmozXJZIiNS2eATN9JjlB8WJGg+wOn9fGX?=
 =?us-ascii?Q?xaTdbGm/xku1FZdKntU8lw5CFSeLoaH2Cvcpc0eok/SmLLDmr12kX/RkkX+c?=
 =?us-ascii?Q?pHXTG04doZyIwbivQvUdMRLnQ9uV0hL2d7x5RubJYq/Tc/wrZQ0bJxrhzEWg?=
 =?us-ascii?Q?cFO8wyzyViAKoD8dCFskc88zGx35/SKsT3aOO/6Jd8WvLs/rMyL6EBM2rUqh?=
 =?us-ascii?Q?WcvMWEuzwEavJBI88ie4lYiNfTCtUMa7?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB8599.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?m13nGw9lHaUUoMxmFzHgQNupKDnwCcEQEWWe6ukKGdrxhH15t7It59niTnZk?=
 =?us-ascii?Q?ifcpTPPxYyJTRhUydjS3vsE7fXQ2qcGd7ZGP6D0jeO1SKRX6hvmiRbmtXWmy?=
 =?us-ascii?Q?riZOtO7OSe4AnjlSrxC1v6UxBZacArAe19zSv2tfWM0VZX8mbwUFy+FR/hwv?=
 =?us-ascii?Q?Hnb5d9pbv3vSOWUi44JgK7IpW/6vHcgyaNSWvAf+dv3CdchxwlFABtqSbGXX?=
 =?us-ascii?Q?Ve8LsH0RxJoWzD3WELKi+mZbc1Y45Pf0nFKafReJ/9bpnAdv69F00WPlOKiM?=
 =?us-ascii?Q?Dx/WTvIfeJhTtxK2RRzJvynl9z0PvCZCXLsHoY5y4VNDL4PZsdC3OyQtrgSz?=
 =?us-ascii?Q?HrSFEW3tz+MuirGWzgvzaVYdIYk8lm+XgUT1Fnkc90TSFeG5Z2ou0XOgHt+h?=
 =?us-ascii?Q?bQkdVnpxC2hqMCxmRUdJBtpzh5qgW+MO27j8KcIEtk0LvYlljldbMbD6DpE2?=
 =?us-ascii?Q?crOS+P3ePdyaxCqqC5902Of4VKggKPQOeEBzKA7rmF5YUtJX2DraH9IxFn4C?=
 =?us-ascii?Q?DpEB90gEqZgt3+f/Y/JOwl6uQ07QeilGlVzar5OeZ2XATrsZzVo7s6wVLxbA?=
 =?us-ascii?Q?6o4N7vfQGf2SJbeQmRL5P9kClwb8leA5eSnSBmxW0oMS8CbxfHQWvhhJS5SK?=
 =?us-ascii?Q?nsFwM7s2UDOBXJh1hcdExqXw/DVUQpZKWFBoPh11kwrU79iQdVKPtCSk/trS?=
 =?us-ascii?Q?/9i0pZOMgZP9l4Iiscm1wJ1SkOIpSsEFmRvSXExiJ0q2DkPWw1O2xiKvmmyY?=
 =?us-ascii?Q?puaIfV9TYq484d8UaIifiLBXmnsbMYUW/w2Ro32Y+Nwvp98ID8cBy3D0NP2o?=
 =?us-ascii?Q?AO2cbKSb9tbFQ2M+EodfO5DQKgmVzvcKsDc3gwYcFyc3Ce8uyNy9BoNJ6pf+?=
 =?us-ascii?Q?qtkUkXTcE3N9iqrRRdlK9Ec5PYjFSQ1BZZE0T+HbHvxFUlrGQjHiRLWEyUrt?=
 =?us-ascii?Q?hVeFVIo/fc1mF5mMOVQ9z6PIDm3W5DO1TLArkZJgr3uyaY0EqO+buGNI2RwB?=
 =?us-ascii?Q?EDk6RxcJD18lvvuXYukIrrqg4pwtWgxpDb1yhxVhIWiJvFfsIMOCXTlxcS3W?=
 =?us-ascii?Q?4TsuiczGLBaEaqrC0TXEVotzj+54aIHSGcJVEkr7HICCGrSZtqijOd9Lrk/0?=
 =?us-ascii?Q?LzOhksbLPbmTPRPMyGlaZhBzs96a3M4i+xgsl35Z7zBVzi38KPSEQ90RuOZW?=
 =?us-ascii?Q?oGOJVezBiICS2gj4DzjiZyBJfqDL1HY1zr2jsGrOr5hLy/hWBrARQy9JJvpr?=
 =?us-ascii?Q?gOa3SAsQS0s8jNkougbWTuaFRUFI247H+5F1wHEKxSylPXVF+iE7DMkQ2iez?=
 =?us-ascii?Q?vmestiSmR6unU5JH1BDr8jZ9KBw3NLdLtpnZ1EOFWekZuvhq4wWK5mID+VLi?=
 =?us-ascii?Q?QZn2QRWQDfYneYZnUmEhwqcl4eAuA+kb9GU3qoXlCF3kXPw2fBToI77/WTa/?=
 =?us-ascii?Q?l/cujE7dc7Pm5JgAWHeMm2fYqPEaHFrpoLi4gWxqo/rkTBZXAQ/jJhdccRgM?=
 =?us-ascii?Q?9wCCzqRUchvpPaZ9XQo739oGnUM3VJQ0A4SWgXx4LlF8tECxwmKdqlfzPW4O?=
 =?us-ascii?Q?0u3W6XM0+uZC5u4r9Qk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB8599.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42a05e53-e1b8-4226-e924-08dd1dd85b2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2024 13:48:43.6196
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LlqqpQFy5S/pCy40yDfCFJXMSaqTkFy6FTHwUxoClUr7ZP3Wi9AzsD7i5icfJG1O4wZSTLuplaluDmrXqJMVYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8920

[Public]

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, December 12, 2024 18:01
>
> On Thu, 12 Dec 2024 15:50:49 -0500
> Yunxiang Li <Yunxiang.Li@amd.com> wrote:
>
> > In the next patch the logic for reading ROM will get more complicated,
> > so decouple the ROM path from the normal path. Also check that for ROM
> > write is not allowed.
>
> This is already enforced by the caller.  Vague references to the next pat=
ch don't
> make a lot of sense once commits are in the tree, this should describe wh=
at you're
> preparing for.
>
> >
> > Signed-off-by: Yunxiang Li <Yunxiang.Li@amd.com>
> > ---
> >  drivers/vfio/pci/vfio_pci_rdwr.c | 47
> > ++++++++++++++++----------------
> >  1 file changed, 24 insertions(+), 23 deletions(-)
> >
> > diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c
> > b/drivers/vfio/pci/vfio_pci_rdwr.c
> > index a1eeacad82120..4bed9fd5af50f 100644
> > --- a/drivers/vfio/pci/vfio_pci_rdwr.c
> > +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
> > @@ -236,10 +236,9 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_devic=
e
> *vdev, char __user *buf,
> >     struct pci_dev *pdev =3D vdev->pdev;
> >     loff_t pos =3D *ppos & VFIO_PCI_OFFSET_MASK;
> >     int bar =3D VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> > -   size_t x_start =3D 0, x_end =3D 0;
> > +   size_t x_start, x_end;
> >     resource_size_t end;
> >     void __iomem *io;
> > -   struct resource *res =3D &vdev->pdev->resource[bar];
> >     ssize_t done;
> >
> >     if (pci_resource_start(pdev, bar))
> > @@ -253,41 +252,43 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_devi=
ce
> *vdev, char __user *buf,
> >     count =3D min(count, (size_t)(end - pos));
> >
> >     if (bar =3D=3D PCI_ROM_RESOURCE) {
> > +           if (iswrite)
> > +                   return -EINVAL;
> >             /*
> >              * The ROM can fill less space than the BAR, so we start th=
e
> >              * excluded range at the end of the actual ROM.  This makes
> >              * filling large ROM BARs much faster.
> >              */
> >             io =3D pci_map_rom(pdev, &x_start);
> > -           if (!io) {
> > -                   done =3D -ENOMEM;
> > -                   goto out;
> > -           }
> > +           if (!io)
> > +                   return -ENOMEM;
> >             x_end =3D end;
> > +
> > +           done =3D vfio_pci_core_do_io_rw(vdev, 1, io, buf, pos,
> > +                                         count, x_start, x_end, 0);
> > +
> > +           pci_unmap_rom(pdev, io);
> >     } else {
> > -           int ret =3D vfio_pci_core_setup_barmap(vdev, bar);
> > -           if (ret) {
> > -                   done =3D ret;
> > -                   goto out;
> > -           }
> > +           done =3D vfio_pci_core_setup_barmap(vdev, bar);
> > +           if (done)
> > +                   return done;
> >
> >             io =3D vdev->barmap[bar];
> > -   }
> >
> > -   if (bar =3D=3D vdev->msix_bar) {
> > -           x_start =3D vdev->msix_offset;
> > -           x_end =3D vdev->msix_offset + vdev->msix_size;
> > -   }
> > +           if (bar =3D=3D vdev->msix_bar) {
> > +                   x_start =3D vdev->msix_offset;
> > +                   x_end =3D vdev->msix_offset + vdev->msix_size;
> > +           } else {
> > +                   x_start =3D 0;
> > +                   x_end =3D 0;
> > +           }
>
> There's a lot of semantic preference noise that obscures what you're actu=
ally trying
> to accomplish here, effectively this has only refactored the code to have=
 separate
> calls to ..do_io_rw() for the ROM vs other case and therefore pushed the =
unmap
> into the ROM case, introducing various new exit paths.

Yes, the primary goal was to move the resource allocation and cleanup into =
one clause, otherwise there would be duplicated nested if clauses at the en=
d just for cleanup. I didn't realize the caller was checking for write like=
 that and then calling into this. It seems like it make more sense to have =
different helper functions, something like this. The two code path don't re=
ally have much in common other than they call do_io_rw at the end.

        case VFIO_PCI_ROM_REGION_INDEX:
                if (iswrite)
                        return -EINVAL;
                return vfio_pci_rom_read(vdev, buf, count, ppos);

        case VFIO_PCI_BAR0_REGION_INDEX ... VFIO_PCI_BAR5_REGION_INDEX:
                return vfio_pci_bar_rw(vdev, buf, count, ppos, iswrite);

> >
> > -   done =3D vfio_pci_core_do_io_rw(vdev, res->flags & IORESOURCE_MEM,
> io, buf, pos,
> > +           done =3D vfio_pci_core_do_io_rw(vdev, pci_resource_flags(pd=
ev, bar)
> &
> > +IORESOURCE_MEM, io, buf, pos,
>
> The line is too long already, now it's indented further and the wrapping =
needs to be
> adjusted.
>
> >                                   count, x_start, x_end, iswrite);
> > -
> > -   if (done >=3D 0)
> > -           *ppos +=3D done;
> > -
> > -   if (bar =3D=3D PCI_ROM_RESOURCE)
> > -           pci_unmap_rom(pdev, io);
> > +   }
> >  out:
>
> Both goto's to this label were removed above, none added.  Thanks,
>
> Alex
>
> > +   if (done > 0)
> > +           *ppos +=3D done;
> >     return done;
> >  }
> >


