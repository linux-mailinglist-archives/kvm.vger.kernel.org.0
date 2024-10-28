Return-Path: <kvm+bounces-29875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C9289B3827
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 18:49:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 96ED71F22F42
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 17:49:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 605E61DF75C;
	Mon, 28 Oct 2024 17:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VrRLaINo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2080.outbound.protection.outlook.com [40.107.236.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FAA1DEFFE
	for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 17:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730137624; cv=fail; b=rooqXQMz8vUnLnOvrv/LczVsuyB5cmkW/BAXjUUgOS7QI2BAlChKoCk/a2aQodWhblkQGKW+2sm9tnSWiEOR89lbMM1q3TqgWydN3c1Ua5jobBsN4+3du/r9eMikR7nf9EditnOttPs/PKCwma8IR+Ltvfkw2HhWVweasQWs40Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730137624; c=relaxed/simple;
	bh=ncQfRTa2y3N/So0I6nAuk4GkcxsYbA14tITF0h45AVY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=k3zDN7p0oBkvYgr72sn/o/MmnETnT6Xd01Gx5ILeDDRIzdkfWDakxEGYbolWeM8BH1gW0HwKvqty0q4ep/mbC6SJ7xsnd+avwX4YyhfIPbi3125IVaiS3xeWY45XEzUZ+uB+E0M6+Nao7iHxw2yfePhDuVVy8y+5pOJLAaza65o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VrRLaINo; arc=fail smtp.client-ip=40.107.236.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v9CJgIWIBad25JZeexUhHdM3z4PQnoNlbKt9c+/dFD2w1XhIweyfwJRb1MC4b36o1uWSrEtGcrInNvZE7fh5JcBaKCAruhg+QHEq/98XTkPTZTg6jPXtkI3HRbqP5MR2Ou0ihXkisgySMorpFUfKmjXuMdeXegZZXWDubepn9wfUA6aGgwQoZGjZEKOqNwmJJPnuIILOGNkWp7fH3ISVAwgybIjGTKpVp4E6H5B4JgPQrUtrvQFpGnv/oAiZSNdysE8DXcFKbZGpHda8ueHUnfSX0dd8yIv8eb/cLCCUnPthgCqA7vsuvKOzIVyGNs3xOGu87m1ZMQj39QSwoqLRIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MuSkJGoNqhVvuKVkAaoGQJ8AcxBp1PmC3DfsFDPu48Y=;
 b=BcPQUc2ajepUOUfCUjJ1e6DDAHXpioHtN0+jY8ZobMc/1KMqtTuFBfRBjSS62c3kI1NKZr6BTjKWZQoztjCBPhThWYUVSZoVDY/vynd6bG2xFeIp0zFTrHNWZ/I4fneiqaHfR44glH85BCurOEh8fq9FsjByDjy7jijahhs+lnuu+bcbaj/nZuxxka4sxabElTUehgjY4SpkrgD+o4/8xqTQie/fIXZ13JPJ/JC9eorZ9dMrsQS4QuaTdrZ49NGxnKdWxH4nr1cZzDVEBDf3tLrHC3tZ2dX+Lp/P9LuwcMf0SH/Tq1XSvcm/BPLUB45o3Ksmu94LckNM1TU/HUaqbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MuSkJGoNqhVvuKVkAaoGQJ8AcxBp1PmC3DfsFDPu48Y=;
 b=VrRLaINo+MnEmpmD0jjLCnU+3JC1KkUGTXwDNVeRLnQfdovzJGZL7kwFpwCBK8OEsocnlctfnudXRECJ82OouZXAOeGT/CvorG+lNuai4gVQrF9NGz4ydFATt2GCj/Y705u/UPuqIi6bpY29jTKiVwvpQlKAGGzqPNZae0ds7RQbAFAXVrl/1naHF7mr6+pokh/nW3yOuDqlyGPjS3cN3PuRU7jUZCVRFYBMNdG8CvD5RthEJAien7u8ElJlZHxay1lOqArnTRFHKJFVfQZQ4wFASXu1C+Xap+RzEO0igZOY+pfw827JSSqlhgLPvLawfCQ+JRUyOLoIBs250shsOA==
Received: from CY8PR12MB7195.namprd12.prod.outlook.com (2603:10b6:930:59::11)
 by BY5PR12MB4244.namprd12.prod.outlook.com (2603:10b6:a03:204::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.24; Mon, 28 Oct
 2024 17:46:58 +0000
Received: from CY8PR12MB7195.namprd12.prod.outlook.com
 ([fe80::c06c:905a:63f8:9cd]) by CY8PR12MB7195.namprd12.prod.outlook.com
 ([fe80::c06c:905a:63f8:9cd%6]) with mapi id 15.20.8093.018; Mon, 28 Oct 2024
 17:46:58 +0000
From: Parav Pandit <parav@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe
	<jgg@nvidia.com>
CC: Yishai Hadas <yishaih@nvidia.com>, "mst@redhat.com" <mst@redhat.com>,
	"jasowang@redhat.com" <jasowang@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, Feng Liu <feliu@nvidia.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, Leon Romanovsky <leonro@nvidia.com>, Maor
 Gottlieb <maorg@nvidia.com>
Subject: RE: [PATCH vfio 0/7] Enhances the vfio-virtio driver to support live
 migration
Thread-Topic: [PATCH vfio 0/7] Enhances the vfio-virtio driver to support live
 migration
Thread-Index: AQHbKFgwmMFKDidgeUS806gohYGFpbKcWAwAgAAC0wCAAAhuAIAACAsg
Date: Mon, 28 Oct 2024 17:46:57 +0000
Message-ID:
 <CY8PR12MB7195FCA5172D7829B1ABC773DC4A2@CY8PR12MB7195.namprd12.prod.outlook.com>
References: <20241027100751.219214-1-yishaih@nvidia.com>
	<20241028101348.37727579.alex.williamson@redhat.com>
	<20241028162354.GS6956@nvidia.com>
 <20241028105404.4858dcc2.alex.williamson@redhat.com>
In-Reply-To: <20241028105404.4858dcc2.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY8PR12MB7195:EE_|BY5PR12MB4244:EE_
x-ms-office365-filtering-correlation-id: a2b0fac8-d4a5-4ba7-fce9-08dcf778850a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?2s2irh5muw8LJexxeJjTBqLpvRPHVsIMeUItkGooqHMjmLBOxwYRaHk6CixO?=
 =?us-ascii?Q?NWDM8yA8CdbqU7vFbbsrRpz9GyKyg/wSa0w6kb8hqL4tDQ8LWnf8NyNngxYB?=
 =?us-ascii?Q?p1zpSWHwpIEMdQKmVRu46dTK77xqgclVqDaO6STq/tUZDlsKc+0vvgWkPxKl?=
 =?us-ascii?Q?cO+de+OghnlQWqdMXfZnJyS8ndmaWvbJz6RUmqOxtz9mt5fSjUeokHY0+cHf?=
 =?us-ascii?Q?MZDirwyPWkDbzqVpju2cWh9EOL7rOC9KL4cilu2Y/gzQ/ZeFfvXn/sU66RPo?=
 =?us-ascii?Q?nscNplvoWKtX31yrfi+YnV76Eoh8gpH6Mdnpl/uG+FiEEBUwW7stXppEKYtv?=
 =?us-ascii?Q?kxEXfgfjJRRpxyrqTE6DXiBB5j5Pnh1jEMaIHHStoQm3cbF5yvquz8wyPo8h?=
 =?us-ascii?Q?47OwdXyr7Uj9o6fRvosjrfIrGQwVEytNQ/E3X8eLvduwSIE3Hlici5GtOX5/?=
 =?us-ascii?Q?LFirfBqsC9OKGnUz214VaV3I4Ypgn8Vy8+CBD9wZQMH0w8AP8LtIp5d7hdlv?=
 =?us-ascii?Q?FbBHz7iqsojST4buObNXlLLwrBtabftTGGdJSHOb2Y1KidAiO1LrQEpPO7O7?=
 =?us-ascii?Q?OoR5voXiVIILOTiNTTEF5/ksvmzmlFFdeKCol/PhSldt1b8evGMWzylnUW0O?=
 =?us-ascii?Q?fNb4Zm3OayPl+0Wf8ngnu8aHYN+0vtkeAJT3ZjonRKXw3FehYJqlzsz4Sc31?=
 =?us-ascii?Q?tA5MyWrDTEJrWJvedOpPltLBWWgT5t9YS5TA993SpJspM72JRPN5DG6rW3cx?=
 =?us-ascii?Q?mmzTlIoQa4dIw4u1hi42OXMESFi69FnJ5hgM+HGyaLACJvcwi7muj2qkHkRG?=
 =?us-ascii?Q?mcn+/E2vw1Mh0HE3JNInQxAv8A1QFyxTS7vFdqQNBH293ijOVCfOBMNS4FVa?=
 =?us-ascii?Q?Mx2ol8EmGIJ1PeP1PuHC6Lw+PTtMIbqi1RV+a1Dw6SMKJ6Y9qedoygOgBTmU?=
 =?us-ascii?Q?DWzSWlToB9N0lOdaKQf8L+49lV2npEgdX6X4hyzbcnepY8CT64/3q4La3VUj?=
 =?us-ascii?Q?49an7T/NmSz3s8Tcwmr81X4rfT/+tq5duoQl8QGHMVU9KRJNUDLjwknrkKDU?=
 =?us-ascii?Q?I5/ObIrpHHgtTTvBEz9jHOgJUq/jc4kqozTnT9+Ai4EhZsPlzSthAulvFUn1?=
 =?us-ascii?Q?jbymjE7XiV+YAfanCL8bUjf2+t7RzGkCMVh9gQc2DG1DISv+icK8pyVu4vp9?=
 =?us-ascii?Q?2YFjLYQkQ9srv6oQGN3YNiRgEh21CgbFCTe/q3X8a1XdLf4XEyzH2WLhtlRh?=
 =?us-ascii?Q?oW+dLCexdsexCsERHIPvMVL3pP/H6bAHLrSgb8j77BlQ36yP1n0JTKRanveT?=
 =?us-ascii?Q?1d+R4Kn1idRMvMUJOnG32G87a1TtFu77lmVhMtXlTJFkCb5fPBoUqu9uiJ2+?=
 =?us-ascii?Q?08ac0t8saqtuMlG4Cyukgh/QG7iu?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB7195.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?OZ/nGCJS+OiY0dJ0Z4sv1swguGaN7HmzcDQkmDSWCsJ/Wtvz6CEYNWYxuySL?=
 =?us-ascii?Q?MiXAEdw6EjfC5hoBPdA2I0xfw+0a92uly6i0A/AVGZr0kuUO+ra715eO0hBm?=
 =?us-ascii?Q?5e/drPfGwuVyn0XwWcjTL9tjFslyTcTrnVWTp6LV9K281XyLArJsr4wxBPIm?=
 =?us-ascii?Q?ygbhlG+ADzGs3g2HYniNqqULHuJWa7HZhmCgs7+yeI9r9p0XJ+KVd6nOj+Sv?=
 =?us-ascii?Q?0XylJXdJnp9JYkQVhM1Yph2W1jBdq/B4fCwfYGaKOy3v31DVcujtCbHMRWXn?=
 =?us-ascii?Q?ydQ77HJyBFl1EbCgojtk57lMFFMepT5QRtj+I0sUhlvUy265x581kgzBSZsy?=
 =?us-ascii?Q?U8tKuvRsvGVEw8lbMVeol2sB/ndzM7t4LKwUQxVFK1oNTLvHRnyZRSHvTp0C?=
 =?us-ascii?Q?HXcIesrqqBDpX5I11LGajUXaK86ZxTZSWc6jViY/NIKjnvbCBeYDMWk1tDvG?=
 =?us-ascii?Q?q3+q7l+2blb/QKLhSAk8c70zySM47Mt8wioHZ6uUlal4imK9EQO7nnez0WQg?=
 =?us-ascii?Q?iqC0fQ/OiE3XSrEYkbt+ANuHotEqER8xsiBVUteZ4mLbpxsGU2Lfb4uEEyR+?=
 =?us-ascii?Q?eUpdfDqYWDBMCRSarSe37Jcx2uIrUxSvLt/xn3hXnGVCJEVxdGKc13Nzlay0?=
 =?us-ascii?Q?oNNq25k6Ab9FyEqyk/NnrWcw9Risg25JJm3tgEKdeFNIeLorfRvwLxk9DYKM?=
 =?us-ascii?Q?bNlceuAr1p3Ppre8tySWPXRiy3wIa7wcqhYpwIiOzr1A8h89xwxDPZ4Et7R4?=
 =?us-ascii?Q?rBQvHicwqFdG0Db4wPj5eSFEkeHmx99VRb2vfsOT6SIqE2DT9RGKZ22l7Gtr?=
 =?us-ascii?Q?EKozoMpLdMcJE5zjAY7+n+1BRI6nIap8A09PYUMBnWIz9mXRVtPkQukCCgLL?=
 =?us-ascii?Q?+VTGfi2NYjI3Hl58j7UIdWsZNVVK01enSEKMb5b+Wu+vjMW729XCQxyrlpqU?=
 =?us-ascii?Q?nU3gvB7mgXFIdSE1Yt7C5MDZfFpj30y6dkitPHUf/ZARe1PB2KbbrIyn+vD9?=
 =?us-ascii?Q?CyFrnmv5SrRur8Yy8z+dvp6cvFUsphrhuLHFEbEwnQYjecHKAald1FsLYGH2?=
 =?us-ascii?Q?fx0TfAA6ZdK1/ItbgCPRrgyddUeqGtv8eoGgmHPv5P6CDZZbiMqyvmCmXPna?=
 =?us-ascii?Q?/QPWMY0feRAuq7U84xN1a+ek+tqZutSUSYyEpJJBLrpOFm7IoIeV2YrdeeEa?=
 =?us-ascii?Q?TB5FwKBx9dvg9/rTgDIrJA771xVx0RrUCMfgRm3gF3ESoNxDh3tUUuhp3EjL?=
 =?us-ascii?Q?I94TNnYZ2iNDmSj0wVc4P5zP0aAYAtRqgv3W496HnHfPbK13BUzPVGUiaGeJ?=
 =?us-ascii?Q?fakvYCF278EBJYf2b6FGn9rEkq0y5SINkW5mh9eeGOQPyM4UOSv16ewwbIHJ?=
 =?us-ascii?Q?WuHPZXONrRMD+68ToqdzOcVeMIdcjBWTfKVsc5Qq2qGGw0foxCi/H5RHS4Rh?=
 =?us-ascii?Q?fLFrdBL05ZZA9/zQIsKiKepOB+WPNjeB/KhW3gAXOeOy/Qd6s6rj5cmUGRkV?=
 =?us-ascii?Q?ycA29QHKrcMIG+kbBTXLxQDIqlv0g8+RDLACK2bdnl/B15U+5US1fx7OWGGq?=
 =?us-ascii?Q?HU78wNwq7GRPA9GW8Fk=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a2b0fac8-d4a5-4ba7-fce9-08dcf778850a
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2024 17:46:57.9735
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fDhARjwHuwc9bMMrSB3ZLnaxZkoiBuzykLV8kBTAZ21G/ujuxF8j4ulQyVXkqIwVoEJqt2w18GEZ3dwJwy7EMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4244


> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Monday, October 28, 2024 10:24 PM
>=20
> On Mon, 28 Oct 2024 13:23:54 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
>=20
> > On Mon, Oct 28, 2024 at 10:13:48AM -0600, Alex Williamson wrote:
> >
> > > If the virtio spec doesn't support partial contexts, what makes it
> > > beneficial here?
> >
> > It stil lets the receiver 'warm up', like allocating memory and
> > approximately sizing things.
> >
> > > If it is beneficial, why is it beneficial to send initial data more t=
han
> > > once?
> >
> > I guess because it is allowed to change and the benefit is highest
> > when the pre copy data closely matches the final data..
>=20
> It would be useful to see actual data here.  For instance, what is the la=
tency
> advantage to allocating anything in the warm-up and what's the probabilit=
y
> that allocation is simply refreshed versus starting over?
>=20

Allocating everything during the warm-up phase, compared to no allocation, =
reduced the total VM downtime from 439 ms to 128 ms.
This was tested using two PCI VF hardware devices per VM.

The benefit comes from the device state staying mostly the same.

We tested with different configurations from 1 to 4 devices per VM, varied =
with vcpus and memory.
Also, more detailed test results are captured in Figure-2 on page 6 at [1].

The commit log for patch-7 should have captured the perf summary table for =
the value of the 7th patch.

Yishai,
If you are planning to send next revision, please add it.

> Re-sending the initial data up to some arbitrary cap sounds more like we'=
re
> making a policy decision in the driver to consume more migration bandwidt=
h
> for some unknown latency trade-off at stop-copy.  I wonder if that advant=
age
> disappears if the pre-copy data is at all stale relative to the current d=
evice
> state.  Thanks,
>=20

You're right. If the pre-copy data differs significantly from the current d=
evice state, the benefits might be lost.
However, this can also depend on the device's design. A more advanced devic=
e could apply a low-pass filter to avoid unnecessary refreshes.

> Alex

[1] https://netdevconf.info/0x18/docs/netdev-0x18-paper22-talk-paper.pdf

