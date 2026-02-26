Return-Path: <kvm+bounces-72059-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GGgpC/GFoGknkgQAu9opvQ
	(envelope-from <kvm+bounces-72059-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 18:42:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DD151ACAD5
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 18:42:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9535B37C718A
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:10:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2393C355F2D;
	Thu, 26 Feb 2026 17:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qn6rVEC9"
X-Original-To: kvm@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011026.outbound.protection.outlook.com [52.101.52.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA0633261A;
	Thu, 26 Feb 2026 17:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772125719; cv=fail; b=I1GFH/+453Ogw5mYFcQGTAW1h3sfBCGiTuPHByzKR/gFSfkJkcRlt+55IeFJtRRICIPZFDQjdvzG3NibFFjd5pR54AK26P/KFYhxVS9fewGSG9hHQkOzMNt5bwycwF0tEL7AT+JGIaHE9HFNm6IlD1rx4SDGTE0rVxAWk+ZVNRE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772125719; c=relaxed/simple;
	bh=dgbdcAf4VNvb5zoI5adLVI9UaLfGsbu/nqHzlH1HeMQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pyKoJDt0COEanlLIF1aaBKjNa7io4elKrHrA9JeaOcHp+46uNsl5bTIaHwcMVws+j3CmZgtYt1pBb+J+NsOQh6vAMuJh7n51nuLTebdK0KXz2yjwt+ZfubXLMwLmT7gwOOuMUdXAao/MWGdLhNWdQsYovnWnJdqoDxdrQPxpTzY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qn6rVEC9; arc=fail smtp.client-ip=52.101.52.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=co2nd1BcVJaChM8cYdWVj52+VoS2eYhHAEmmdnNZm1IrpcwYLSEVZy/C/Gg6FI0l6QOI4eNj1pRpobe25nCnxJK2G6T5WTRWKjW24slLxnFTK7KuTn9DZFNhDsSPg427Z6TqhOMHUYkwL4oet6ntdoWIMq0V7Sk7BhCyx2Hbl5WU6tJIsfvR2P0SbfY3Z1ZTHji6rP55uR+NvB2gZGC2crGPHhgSlNxdA2xL6/7J7sLScGpXonXPlKmCRVc1gCFVBeAed8hBRiB92H7tvWMWahSiWAS7hgHPpUNGjKiE8wd+9fhaLutAKpbNmUevGlBJHQMnIKziCaec7U8VBOpyKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rSbFpzDLguwTzv5A4dzmXWnPFOiKLdfArz0ssHvm1Wo=;
 b=Isquh/99qxknappPKO5AkEjlQd0YhJQlCfIP8eMHH03GM7hUbta/NRWgxqpK82r/Q4QVrmESYi4+KEU8fTT1ISIN0e1MxP8TDW7YjyB7dZZoUhcAgeO3sGDy4uvoGrqUvzOL3s6xqFzCautZv6avpc5ovh/W4q3fu9jcr0aFZ8rmWgcjobD4hjGvH6gUaIfreQZbwFEyozPqmJj3CIfnFg0OZ4oatzFp1YDmgSNj+MCObExPeSf4P+xKM7AvEB5dng7sVkEkOBlzFQE+kWefOPfmUTy5ml/z/ff4PpkODmKS5LBfxy7L6DdBFXDsNV7ts9pVcl0aGwXmrJw7iHr/Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rSbFpzDLguwTzv5A4dzmXWnPFOiKLdfArz0ssHvm1Wo=;
 b=qn6rVEC9aQ/vIxRc/5FgFgcHLeL16oVpkHGU0IuzYf1oYn4ZkQzptkWf27sRhkXNBTn92JrWBWHu+gGqfZDsre2Br4JBjWW9TMV7yuFZyY1YNVzEM2iZLpWXpmVS5chK+0+a47LA+KLUFT3tNNuGhP82vTzTDpGNytmDQ49sKymCaFCK5X0dza8O6OGhMbj/zM7GviexWzdG3as7l/pT9nLInt/v31cxLnWgw6StPdESi79TPFZrAE52k2M7dvbLMt+vVMiX0DST8YEC2HPgYyouJZBc84XlVrxk2GQKnBABee3OxqpXy+PTc8Kp0HuKQvcVV0HxAXVPXt7mciEe8Q==
Received: from CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12)
 by IA1PR12MB6258.namprd12.prod.outlook.com (2603:10b6:208:3e6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 17:08:34 +0000
Received: from CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de]) by CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de%5]) with mapi id 15.20.9654.007; Thu, 26 Feb 2026
 17:08:33 +0000
From: Shameer Kolothum Thodi <skolothumtho@nvidia.com>
To: Ankit Agrawal <ankita@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Jason
 Gunthorpe <jgg@nvidia.com>, Matt Ochs <mochs@nvidia.com>, "jgg@ziepe.ca"
	<jgg@ziepe.ca>, "alex@shazbot.org" <alex@shazbot.org>
CC: Neo Jia <cjia@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, Krishnakant Jaju
	<kjaju@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RFC v2 08/15] vfio/nvgrace-egm: Expose EGM region as char
 device
Thread-Topic: [PATCH RFC v2 08/15] vfio/nvgrace-egm: Expose EGM region as char
 device
Thread-Index: AQHcpNzeP2epdhNlu0W6COLmfyg0HbWVJz+g
Date: Thu, 26 Feb 2026 17:08:33 +0000
Message-ID:
 <CH3PR12MB7548DB218B272AF000EF0693AB72A@CH3PR12MB7548.namprd12.prod.outlook.com>
References: <20260223155514.152435-1-ankita@nvidia.com>
 <20260223155514.152435-9-ankita@nvidia.com>
In-Reply-To: <20260223155514.152435-9-ankita@nvidia.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR12MB7548:EE_|IA1PR12MB6258:EE_
x-ms-office365-filtering-correlation-id: f0eb637a-e38b-475e-087a-08de7559ac6d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021|7053199007;
x-microsoft-antispam-message-info:
 YaSNbnKOgv8By10G5ECzxCWIdaxFXh6MJlbVmFOnbm6uEhv0gSvITO9bIR/a6Itp/Ow4uOWqFNmYXUxqW1pxoJaAwVJ7oRWlAwsUCZXiToQroiF2fIejSPTbiSAPp+UADtjyy67v8/MTnYAKktQgqRZzR+ZquT8gTlr3RRNGcHzPmzaxDJmbLwFRWENF9Qybzi/LS96IfCuMQbG1sIPJwC0aVdFNc2t93nbHV4jUV8DaffnAz7RUQIsnSyeK2X1Dau3raIx3Od09ZVh6dgMZJiXLsr0Fp+267LyAm2nvmy+o5Va6yVzZDnSPDx3uPiqsC033n53JuSXZEWZakAKC4/F7W+hxXEE4O2DkH7cjkSjBlbfrk5lN6QaEho6jMssG4WJ8f8yRoI4Z14tyV6CwtgHiEsbfEGmQr/nE8qKh5cOa5uQy8yy9cIFyn3/fFg2cIZu4ZiB4h/nEJhJStrKpeFkqyIcOt8Aahel6V4rS51l1/4gGBUGnqwjKnK+EXIORgzOuqHQlo/aYozRW7Wk6Mt7lzq39k1xze/QuwZymsW8Lp3q48Zl6pWAS+bJAKeKENfCczHdcsuyhI/rm5BiMBeAy2ZZmWtgOkjBrtWnMOC2RiaTwl6i9u4sd17PGZOT2Et+TLUx0+9Qi7r1dUZK4iF8wV/A941Q5CM6kA2DGkerqdJuOxcfOlEg5kTsBc51pUTxwXoN3SOL6bAKkNYBFJBVTBXiP/TQRM/8B/rdB9/nidZnimwotJ3ZqBMRgT2c6xHYFJ3ArL+OEXsNqF2n8us1BgNmXQR818LUgk2kasZs=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7548.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?aYzya42h67j7VAB0GGxU+cCyOQq0JpD+MKvXzUqg9SL/LiP4qSe6Lz60gBxN?=
 =?us-ascii?Q?CSy7VS+Und6Dbnv+sbkYMoS+rZ1Bxr0LdAAZgFqOHYRI59WIWsfR6gXfZFLD?=
 =?us-ascii?Q?ETHWRHV+q86f0MHM9+cPCjgAv32T+8hoFYGE+Tm2T8w+Y+6vL2i2TO/KTG5A?=
 =?us-ascii?Q?ZJfu29K/dFhAz9oadj5hsCngg9UtQ6K9Y8HJazTBs2X9Y8Izf0x9eSB/i5ND?=
 =?us-ascii?Q?faYQchHPvhkWtavilc75FninxiTULHaXtN/C98Fm4hsjzm7qfG2Ch4RMSjx9?=
 =?us-ascii?Q?MHJ4LlQI0ujMyzhH8jxil07BFSA3nESDw1ieQua5pBDoJaR39tgNXLglnfUJ?=
 =?us-ascii?Q?+lxQb2w0XW//R5lrD6bFdXSdIX4BFQttreOJscNqdclwBEbrG46R9iv6JIGA?=
 =?us-ascii?Q?KuJQ3hO/CUF/f5HdIgPGRdsspGmpxYqxw1vrjbjHD/R8sjhbp98Hk5b20wl/?=
 =?us-ascii?Q?mMxiNbGuKuuWfVjGj4veX6FijN6PfKPw5xs+ms03JCHzP2Dx+T4Z60TI74It?=
 =?us-ascii?Q?SZTXD1c51sAn/fjiin0o3pVarJEtcVyRoqA/5JQjE5jnG8ZYW3A8pOnbXj7w?=
 =?us-ascii?Q?w1NLsnB/WlAEMQBt69wGAHRkQLhUgt0Mv5A4xUJxzzqMatprtSUvj19WVU18?=
 =?us-ascii?Q?PAlG6WtOKA3nwQpQZBXGBSVE5iYoWkKhgHF0EeqbhqCan6QGXZiBrVDls3ay?=
 =?us-ascii?Q?V9Rzu4WWDL4YUTRw32sgDUd9OV5SNQLANw2u2lQVtBf645zx3ttvolX/GfS+?=
 =?us-ascii?Q?pdLqQmDrZQjPLjrk0UB50XoJCvmp9gdJfbgUHSpu5xPhd9qzlQNP7C1Kc1n8?=
 =?us-ascii?Q?j29Mb1GvhMhSj8xXramspc/3BpMURCfjtJKTbF/uHSP8sgUQ0np8ymPVeWnI?=
 =?us-ascii?Q?sjTLCL3H4NCad5f0Yyk9RzS9VCeIOJVND5PtZwSb+vLKpo6C4auCvWKpmgLY?=
 =?us-ascii?Q?xw9MqoeHb2CyO2w1s6z5VNTMHVRat3fabF2e6G9oBqRLpEmF4gyTHBt43V4p?=
 =?us-ascii?Q?2IjURDQd1Sm0uM+sdhoIw9Xnkw3HjkTNHkhIz+U+dKH/8E2WabwmeAutt/zV?=
 =?us-ascii?Q?2vNuiqv/cvjlZalebMv03i6hdXiAJV6V9pmP5DbHmxr+vhLcop9W2ZLIJHYn?=
 =?us-ascii?Q?6MV8cohDXqNhDLVItq+0I6imrLGzapz8tLyhvz1NcQMp9zw5v0YhVm09bekn?=
 =?us-ascii?Q?Iudnta052wdb+X2s1p4FqNsEHbhe2mIQsA3XoMVW89mN9WgLci4rtOt8Npo6?=
 =?us-ascii?Q?st5/5X0bm/xs5ZBknKBhX5l0M1b37eGgOI+akGf6spzYc5CtAU3OeV2uSQW0?=
 =?us-ascii?Q?bNYF2h+xZ/M9g6bJKdra2igwPAKe1owNgxlflNBIbXZhv2wUkUtyAkg7M/Px?=
 =?us-ascii?Q?UydUDPtyaEs0zuZRtcSLoyhAOaaEtsJZIK0lFwjGz0rYRgV4/m5XCFA/fehH?=
 =?us-ascii?Q?3T0jAFp/vs9rMx7y74uDSF4Z4PKYFeKDDRJ5IKV6sz41Ywr4//UOzGRIk2jN?=
 =?us-ascii?Q?IiM8JluDpU86F1pjggDQOu5lrHSu6UHwAoWiZDrnL65CtxM2pKWTy3OwgYDM?=
 =?us-ascii?Q?xXatpLDJI1gm8huwLdpi4NlpOGJmxWacWhrHKfeBm1oIil+K7S/1N+RucOVj?=
 =?us-ascii?Q?e0fN0p+Hv/IOocyJNkFUSIrvnocO4qIubrUWu7IqiXZkpP8MgFeKXf1FKQC8?=
 =?us-ascii?Q?MqOg8UkDivhSXThiHeRu5mJuQThiKQhqhoyeXIYDtZ8oAosXqp6IWh3mNdO/?=
 =?us-ascii?Q?3ndw7KAsDQ=3D=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7548.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0eb637a-e38b-475e-087a-08de7559ac6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2026 17:08:33.7953
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g5ik+ZO2qnuoIUyGsUV9vXhtQgFo/v57LHX1GRzZuKJQ23z3oAwS2D58E3VVZQC5gTmRLhXzf5qbMHTX0xz1Iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6258
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72059-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[skolothumtho@nvidia.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:email,Nvidia.com:dkim,shazbot.org:email]
X-Rspamd-Queue-Id: 7DD151ACAD5
X-Rspamd-Action: no action



> -----Original Message-----
> From: Ankit Agrawal <ankita@nvidia.com>
> Sent: 23 February 2026 15:55
> To: Ankit Agrawal <ankita@nvidia.com>; Vikram Sethi <vsethi@nvidia.com>;
> Jason Gunthorpe <jgg@nvidia.com>; Matt Ochs <mochs@nvidia.com>;
> jgg@ziepe.ca; Shameer Kolothum Thodi <skolothumtho@nvidia.com>;
> alex@shazbot.org
> Cc: Neo Jia <cjia@nvidia.com>; Zhi Wang <zhiw@nvidia.com>; Krishnakant
> Jaju <kjaju@nvidia.com>; Yishai Hadas <yishaih@nvidia.com>;
> kevin.tian@intel.com; kvm@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH RFC v2 08/15] vfio/nvgrace-egm: Expose EGM region as char
> device
>=20
> From: Ankit Agrawal <ankita@nvidia.com>
>=20
> The EGM module expose the various EGM regions as a char device. A
> usermode app such as Qemu may mmap to the region and use as VM
> sysmem.
> Each EGM region is represented with a unique char device /dev/egmX
> bearing a distinct minor number.
>=20
> EGM module implements the mmap file_ops to manage the usermode app's
> VMA mapping to the EGM region. The appropriate region is determined
> from the minor number.
>=20
> Note that the EGM memory region is invisible to the host kernel as it
> is not present in the host EFI map. The host Linux MM thus cannot manage
> the memory, even though it is accessible on the host SPA. The EGM module
> thus use remap_pfn_range() to perform the VMA mapping to the EGM region.
>=20
> Suggested-by: Aniket Agashe <aniketa@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/egm.c | 99
> ++++++++++++++++++++++++++++++
>  1 file changed, 99 insertions(+)
>=20
> diff --git a/drivers/vfio/pci/nvgrace-gpu/egm.c b/drivers/vfio/pci/nvgrac=
e-
> gpu/egm.c
> index 6fd6302a004a..d7e4f61a241c 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/egm.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/egm.c
> @@ -10,15 +10,114 @@
>=20
>  static dev_t dev;
>  static struct class *class;
> +static DEFINE_XARRAY(egm_chardevs);
> +
> +struct chardev {
> +	struct device device;
> +	struct cdev cdev;
> +};
> +
> +static int nvgrace_egm_open(struct inode *inode, struct file *file)
> +{
> +	return 0;
> +}
> +
> +static int nvgrace_egm_release(struct inode *inode, struct file *file)
> +{
> +	return 0;
> +}
> +
> +static int nvgrace_egm_mmap(struct file *file, struct vm_area_struct *vm=
a)
> +{
> +	return 0;
> +}
> +
> +static const struct file_operations file_ops =3D {
> +	.owner =3D THIS_MODULE,
> +	.open =3D nvgrace_egm_open,
> +	.release =3D nvgrace_egm_release,
> +	.mmap =3D nvgrace_egm_mmap,
> +};
> +
> +static void egm_chardev_release(struct device *dev)
> +{
> +	struct chardev *egm_chardev =3D container_of(dev, struct chardev,
> device);
> +
> +	kfree(egm_chardev);
> +}
> +
> +static struct chardev *
> +setup_egm_chardev(struct nvgrace_egm_dev *egm_dev)
> +{
> +	struct chardev *egm_chardev;
> +	int ret;
> +
> +	egm_chardev =3D kzalloc(sizeof(*egm_chardev), GFP_KERNEL);
> +	if (!egm_chardev)
> +		goto create_err;

return NULL; instead and get rid of create_err.

> +
> +	device_initialize(&egm_chardev->device);
> +
> +	/*
> +	 * Use the proximity domain number as the device minor
> +	 * number. So the EGM corresponding to node X would be
> +	 * /dev/egmX.
> +	 */
> +	egm_chardev->device.devt =3D MKDEV(MAJOR(dev), egm_dev-
> >egmpxm);
> +	egm_chardev->device.class =3D class;
> +	egm_chardev->device.release =3D egm_chardev_release;
> +	egm_chardev->device.parent =3D &egm_dev->aux_dev.dev;
> +	cdev_init(&egm_chardev->cdev, &file_ops);
> +	egm_chardev->cdev.owner =3D THIS_MODULE;
> +
> +	ret =3D dev_set_name(&egm_chardev->device, "egm%lld", egm_dev-
> >egmpxm);
> +	if (ret)
> +		goto error_exit;
> +
> +	ret =3D cdev_device_add(&egm_chardev->cdev, &egm_chardev-
> >device);
> +	if (ret)
> +		goto error_exit;
> +
> +	return egm_chardev;
> +
> +error_exit:
> +	put_device(&egm_chardev->device);
> +create_err:
> +	return NULL;
> +}
> +
> +static void del_egm_chardev(struct chardev *egm_chardev)
> +{
> +	cdev_device_del(&egm_chardev->cdev, &egm_chardev->device);
> +	put_device(&egm_chardev->device);
> +}
>=20
>  static int egm_driver_probe(struct auxiliary_device *aux_dev,
>  			    const struct auxiliary_device_id *id)
>  {
> +	struct nvgrace_egm_dev *egm_dev =3D
> +		container_of(aux_dev, struct nvgrace_egm_dev, aux_dev);
> +	struct chardev *egm_chardev;
> +
> +	egm_chardev =3D setup_egm_chardev(egm_dev);
> +	if (!egm_chardev)
> +		return -EINVAL;
> +
> +	xa_store(&egm_chardevs, egm_dev->egmpxm, egm_chardev,
> GFP_KERNEL);
> +
>  	return 0;
>  }
>=20
>  static void egm_driver_remove(struct auxiliary_device *aux_dev)
>  {
> +	struct nvgrace_egm_dev *egm_dev =3D
> +		container_of(aux_dev, struct nvgrace_egm_dev, aux_dev);
> +	struct chardev *egm_chardev =3D xa_erase(&egm_chardevs, egm_dev-
> >egmpxm);
> +
> +	if (!egm_chardev)
> +		return;
> +
> +	del_egm_chardev(egm_chardev);

Is this safe if there is still a file in use e.g. QEMU has /dev/egm0 open.

Thanks,
Shameer

>  }
>=20
>  static const struct auxiliary_device_id egm_id_table[] =3D {
> --
> 2.34.1


