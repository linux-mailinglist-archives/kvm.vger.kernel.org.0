Return-Path: <kvm+bounces-72072-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iJXXHhufoGlVlAQAu9opvQ
	(envelope-from <kvm+bounces-72072-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 20:29:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FECA1AE57B
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 20:29:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 1D22F30087F6
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 19:29:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DECB02D249E;
	Thu, 26 Feb 2026 19:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="h7PwIdWd"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010050.outbound.protection.outlook.com [52.101.61.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E4B44CF21;
	Thu, 26 Feb 2026 19:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772134164; cv=fail; b=Uj+miisTEHMDcv3fXYAGUOSLfqcBBnK1ByOWwoVF4WaZtagOsmuwzkA7fbZXtRROnrRyfsWgbG2+sTlPqvu4+z5ucw1G5zoF+9+Us+CjQteOrYsxXd6ezAFsS/SAHpBS+bc0WxEyZKTRzC7hQBVkOoSmopdWylkUDWoRtllWHCk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772134164; c=relaxed/simple;
	bh=QCH7mdGei3T8uGvGgfLd0FD92/S8V4GFYlF2VFBQR38=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sO2RuF/xWIFN8DQY7CdyTERV+tbJu9cbeiPTOnU1uEYkUu6viGTxd0qpY7GfbiSl03Z/tsqQYoIWUVXb0hAcrMMfHpw/0DJC/6QGP1DZezWfE4zg22m+OILwlDC5FITQ75nuPBAM21jjV3Lb13MhnUI02iGDlpAr80JHAfuAl9A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=h7PwIdWd; arc=fail smtp.client-ip=52.101.61.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UnWkGj2KqXzwoVW/LsjTx9Y+05RuWL7fTmhl+hlXhKIk2TOXSa1deN7OGDnYzKLYvxiAZYxaFZ0+jgnFnBF4pflgqbNT5ygR/P3FYsDFI6Y+qC6DF8dsHN9tkJPUK0w3JN8zKJn7jzStNt0RThKqj9OGLRD7WP7mk9e/VYmgUXltrKfNQUsw4O8lSGwNXUsoYRpzqMZUbnsxh25PkwCkehDqlXSmpB1D+mKVm0ZiSnGXb1dzLP7kV3uYUL/Mzngxo7lvzTi3uuGwfMySGMb7SRfz56yJKk1mw7gb74h+2Kgu/KKeROAuP/vXq3xAEAElc+OE0C+8GLcrKJ/5D8LLPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QCH7mdGei3T8uGvGgfLd0FD92/S8V4GFYlF2VFBQR38=;
 b=K3bncuwEWzr9oFo2uKyEBR8b/cRyQkcF/gcUw2sXz37u/AuLS8BOn1AaOniMLcUZLcYCBBE2qQ1ymZNm/t1wgWQvDCoBN8R0sgemDi4/xSFemINRlndX+ZKBvJv3Ve3wQVpAfczexk5gZ1qopBzrnywBiKztHu4HxwkZ+E/rZhfhwVUhr4TWsF3O0pNI1XILZZm+3HU/lJyPywkWK2h+DkZVZJxB8f2QtdZpV5NKfkrmKhkMTM14CXpaHGufkBSFFW87vaMYC/sXgGwNM4noHkrrAkZLNog99RfQF1jZiP9gTgalVYv+MXtgodY58picbc30rjueDJYubScMdgdBog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QCH7mdGei3T8uGvGgfLd0FD92/S8V4GFYlF2VFBQR38=;
 b=h7PwIdWdY73jzZdJXa8z7LY+H0eMJVoXTOXZZXUV/Gh7OV9dYtAtWwbNBsxGuwM1suR70O2i4BPWya5mAwM9i0Lxz8RwcrXqi/i0Atjo4AhCDvAk9f3DBloMJyPAgaXY7EKk32ifP0VLo48Cs3KtDOr8IC+YcKhE43NPZR1EHfsG9LMYXpzoiUKTf5IR36+xvlQ54m1DeibKwwGjgoTHn5XWD1kQXY0RrwAptiuI9ZVxBrb8vJMvpurMMnStSB4VEdRK+v7E55LOjpkGbR9qpoLHyJQuCqfHHyQpzTl3r+MsndL0L4AfetuiAph48JUMRCUF1Vs8/hAwfucTUTIzpA==
Received: from CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12)
 by BN7PPF0D942FA9A.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6c7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.19; Thu, 26 Feb
 2026 19:29:19 +0000
Received: from CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de]) by CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de%5]) with mapi id 15.20.9654.007; Thu, 26 Feb 2026
 19:29:19 +0000
From: Shameer Kolothum Thodi <skolothumtho@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Ankit Agrawal <ankita@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Matt
 Ochs <mochs@nvidia.com>, "alex@shazbot.org" <alex@shazbot.org>, Neo Jia
	<cjia@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, Krishnakant Jaju
	<kjaju@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RFC v2 10/15] vfio/nvgrace-egm: Clear Memory before
 handing out to VM
Thread-Topic: [PATCH RFC v2 10/15] vfio/nvgrace-egm: Clear Memory before
 handing out to VM
Thread-Index: AQHcpNzgjOBHgYQ9k0uXA/co5rrhHLWVSE7ggAART4CAAAf60A==
Date: Thu, 26 Feb 2026 19:29:19 +0000
Message-ID:
 <CH3PR12MB7548743B0502FC6BA53B8114AB72A@CH3PR12MB7548.namprd12.prod.outlook.com>
References: <20260223155514.152435-1-ankita@nvidia.com>
 <20260223155514.152435-11-ankita@nvidia.com>
 <CH3PR12MB754812AD77FF9E02B0AB2F1DAB72A@CH3PR12MB7548.namprd12.prod.outlook.com>
 <20260226185653.GG5933@nvidia.com>
In-Reply-To: <20260226185653.GG5933@nvidia.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR12MB7548:EE_|BN7PPF0D942FA9A:EE_
x-ms-office365-filtering-correlation-id: 67e9fa36-32e4-4138-b71e-08de756d564e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021|7053199007;
x-microsoft-antispam-message-info:
 quAVtcaO+YDEioTaNpOuHyrsvAsNPdn1vh/ixgs8h0TJI7gCY6WyxnQoL4tIYOYrlZus8xp3Vc4MD0Ee/1OAhGGLx8TXsQDFcQEVhluGMgNWhh3dzfFoJk9/WXsiwK2zOkBCK13kAWGc3qW+IcSwKDZMvzbnkj6G/sM4y8gSoqod443o+E2TDmhGrEiJpnFH5gINjsQt5+6L1kgxZqmrND3RGKeGqtxsykZUmH+y0e1cmGiE29mIqFXyiIaPpHX/eroRFcvttHdzucpLCdoYVrBp1frEt2+LrmrKayaxBblKS8CrKjVfosRbNqqzUN/UWbxWbkjktd4reGSAOzBcAkRhYK0eGOyeL15tVy7YdxYUFAAEcJ9ggHvFQjC9Esf+C6hmHqju5O+XiBMvX7ANhHnJP1BKbOyl6RjOlkDCTpgfuBgxgsSDelXYHwV2kgyAq4SngVyf3G8qus9l+OyxCDKuG2fxxpJuI3I4Z2C7j2UYbNZ85QgqnJKnA+GCEEGBo89Th4C1u20d3nwVwLg6KTJFkRGZHvjdI+a4est6woMK7oHWxbRgdomAv2Rj56dKMV8OT/u3Badj1y2M4drTKkr8F6kdeqIHiNoCuj8fZJ+6Hv5DL4SgpN0L+2y4bza5ans+meM02dcs80IAhhcK7lgx7GCbqHlb8pnhUPFrIutvb12UUs3TcaRtyc1sPjLVhcJPsBlDBJQDhb61Vd3j/bvinUhKM4rcm56tquzaLRawOzse2xqenw9WqpCAXLipvIDj6Wo5zyzYOm6pKfCVIRTJsLWmMKY2VMRvU850Eww=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7548.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?N00BqRyRU5rID4gxsu/ZGtYl/wGQJFvoC1BGllH1SN0CzhvMfLy0CZ6G480f?=
 =?us-ascii?Q?8XptLO5j+X0TLs+bY5D0lcBm59Ww10Uqd68c5Mz+ZwVfarzheWQ17o/Q+5i8?=
 =?us-ascii?Q?cbIdx0SA3QE3AX7qEyQmyPevYSrBBVaiKpE4Tkz8aO3zIaQQYTR3B5azOs67?=
 =?us-ascii?Q?rzIVepTBUG+wfA0sFSpF3ox0mLOU6H8vJN0PFGvhg8HxL7Wwi9MKgZwaDMFW?=
 =?us-ascii?Q?N4wyUboYHy/3/XF5F4DqRt9JscTjFDu7zKBIGoKW3Bhb/H1Y9umbGzUOmmC9?=
 =?us-ascii?Q?5J6lIDqqdQkn/Id4ArIIitOVeZ7wSYRTJ1na9RtB+PndHg0nZzTK5akgYRgP?=
 =?us-ascii?Q?8pRqypXbiXpPh0xcwSalUedWooqTUtzdtSBHISiWRRtxj/z/6dkY2ytTeoOY?=
 =?us-ascii?Q?YeehJJ0GLHu+PluAQbY5lExos5HJMYKLuDx8IsGWXQoK0FyZ7/so9Vb/m5Vj?=
 =?us-ascii?Q?s8fQufp2cbQ5HfOcn0CH2zIFt2+C9oj0oXoRKQ1ptZW+6OrQYCBk4n6FROek?=
 =?us-ascii?Q?RVQFzhYYwRiyk9SG9Aw+GVvhoJf88A8jO0zvvWU1FylrWWq57NHIlYvRyHfk?=
 =?us-ascii?Q?kdT+TrkYVM1rXOExJ6b0wGnU5HyTOnE3BBa0F57pmwHW3BADvi7oUvLg5ruL?=
 =?us-ascii?Q?K3PG3YdnDlwRxceGPWjWENWXyhL+dMlyf3PSmtJR3A1dyCz6wzHI361AOMHz?=
 =?us-ascii?Q?Uml8+fmHQs6X2q/33hPe0RjbE+HMBH6DIN1H9zQJrHB2Lb8IStBP4KNKfgh+?=
 =?us-ascii?Q?io1me7yQOyexG/GDdc0gxSFhDtREOa0R27k70wkTcntK+Zmsp30TQN41li/z?=
 =?us-ascii?Q?n0/rgZ5iE7dAztC58A7HN76XeBpV2fzVIrhYOZi5rLA7gNxlRGdReewbBGaA?=
 =?us-ascii?Q?/ayiO1YtXJ/2FKH/VbORSJWVtJroAUuwM2usudHGCmsrvYpWVqn4YNJAmqDf?=
 =?us-ascii?Q?LyGYEs0C3cGkRGLdfskhNU+m/b/bBt/ditB5uAHZCGrldPsfIuTL930L+UQQ?=
 =?us-ascii?Q?xWMClAv86nDy4T5kf+8PwKGSrYi7NNC9UIZcYN5KhOAGqzJgbwd4lcdMGnJm?=
 =?us-ascii?Q?k0XQCWgs5xbz/NaFJrYcxqo7h4UwhOIYKdtlGsflaC11fKWBhN7g0C0H/Qc0?=
 =?us-ascii?Q?d17vdNwnPo2z7oALBPUWpaMLwZw8x5ij0PEp6kbnW9iRW+EuJaMIwv1ba/ZC?=
 =?us-ascii?Q?0S5ERfu7gBn8CnOLS75aBWAnZ4Y/V0HILcweZXJgCjxbgLjkXsdaDKrgT3rQ?=
 =?us-ascii?Q?gYDLTfhNgpbin3Wni9SsepMwo1rKJ523+hcdhWxhkmBS+MxwRVgVblmVgdiV?=
 =?us-ascii?Q?Eg8XT+TX66vj7umbquFJLVDXClMJsd+N50vyX177XNa1yR8+NrMg9D2Zwcr+?=
 =?us-ascii?Q?VZTKRtld7hoJA7Xkn7CgL0Bc/qv+QGWoyfJnYT6lx5H5Z5DY0Oeod9qv0T3T?=
 =?us-ascii?Q?2BIm2ozQC3jKcsyTli8Ek5mLEs2uCEav3SHHhGaVydlpqwNudCHAwLWPdUE3?=
 =?us-ascii?Q?C0irRi2y72Bj8RE+GvQeuk8Nk8VsJUAuASETmBLiosV00rhgrdc74lHViyuj?=
 =?us-ascii?Q?ndLv9fxlebQwluTMu+ngT9aZr4KDT4CACV4mxobQ/jxAmnhDizqm2Gs5Tj0u?=
 =?us-ascii?Q?lbNPsOr+EyMZ7tq1sBvRh+fcI3Szw+o3fGuOu+y2BwEEjSZH/viq16Yaw4Ul?=
 =?us-ascii?Q?xldhSQddvnWgI+h5OZ1gpxa7WxeqtSWNF0eYFPQw2PqfD59Ydd13MJQ7pI9s?=
 =?us-ascii?Q?8k0GDKaoyQ=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 67e9fa36-32e4-4138-b71e-08de756d564e
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2026 19:29:19.2778
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gTZ5D+XllHDqeuQpcTk2aZoy/HOhgAFB0tj6op/Sn/fRuUgKeREviKbsiui3KiDZg4qQmN5w7mbA6SmTsO0LDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF0D942FA9A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72072-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,Nvidia.com:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,nvidia.com:email,CH3PR12MB7548.namprd12.prod.outlook.com:mid]
X-Rspamd-Queue-Id: 1FECA1AE57B
X-Rspamd-Action: no action



> -----Original Message-----
> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: 26 February 2026 18:57
> To: Shameer Kolothum Thodi <skolothumtho@nvidia.com>
> Cc: Ankit Agrawal <ankita@nvidia.com>; Vikram Sethi <vsethi@nvidia.com>;
> Matt Ochs <mochs@nvidia.com>; alex@shazbot.org; Neo Jia
> <cjia@nvidia.com>; Zhi Wang <zhiw@nvidia.com>; Krishnakant Jaju
> <kjaju@nvidia.com>; Yishai Hadas <yishaih@nvidia.com>;
> kevin.tian@intel.com; kvm@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH RFC v2 10/15] vfio/nvgrace-egm: Clear Memory before
> handing out to VM
>=20
> On Thu, Feb 26, 2026 at 06:15:33PM +0000, Shameer Kolothum Thodi wrote:
> > The mmap mapping stays alive and accessible in userspace even after
> > the close(). Since the release function decrements open_count on close(=
),
> > a second process could then call open() and wipe the mapping while it's
> > still live.
>=20
> fops release is not called until the mmap is closed too, the VMA holds
> a struct file pointer as well. close does not call release, close
> calls fput and fput calls release when the struct file refcount is 0.

Ah..I wasn't sure about the release not being called until mmap is closed
part. Thanks for that explanation.

Shameer


