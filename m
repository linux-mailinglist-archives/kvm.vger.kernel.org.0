Return-Path: <kvm+bounces-17529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F3008C768D
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 14:36:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6F8F9B21B47
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 12:36:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E301146581;
	Thu, 16 May 2024 12:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="eck9mCF7"
X-Original-To: kvm@vger.kernel.org
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2066.outbound.protection.outlook.com [40.107.21.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F417B1E511;
	Thu, 16 May 2024 12:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.21.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715862980; cv=fail; b=CevbQgkoeXVNSLQpTtuNlJ3lhz1eZqU0ZrEA84hHvKPvzez1F1+OhiZ8oHL6juV7Zz2jIy6nNdRK4aolnjkX6zq7iDTJIiMriReezCUL5qE+do0lO7Hx6YMULvSKgCNi9d9yr3Hzxou+E+7CKKz4+yP4/RQwMh4vUn2EMQBOHD4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715862980; c=relaxed/simple;
	bh=SS2VZEhMVeNNmXVO8h+vS7khcN/HcODuYGNb2w4nVII=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NCFecYCoAt1/GXReOmt0460FaUMtB0xwx4wqODMvZ6sWpejKqFZkA/XZFW9M/Khlu2h7ahaaXmDaYUa1tIpvr2VlxX3UJRiodNJsavxtnvJmHMbVcZS3ViLEYpxwh1PmQn0Qs8zSq0wgctI2+wLpuU3CkP3JyWB3uv0No8urO/g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b=eck9mCF7; arc=fail smtp.client-ip=40.107.21.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DcIswR23km98LJwrGTUsKr2eG9GtsRucJ3c40Be0MnfK2V3lBtqX4Gns/lHlufXxgzKd7h2Bj1lUr9/6ka6NeZSAWVzDhZveDYimz+UKp6VPVFrhoHU9Y67X7CFW+JDelFw8I6KAbzCUj81SD7GseRE4PIhAWpq8zwMYJ1neK8mrEq5mwykjXDfdZY9FoC/MEOsHtMaiGgWmdLBmFSbSmBKX+karX4EnYjIq/p2x+z2Bjv8GzUwKrdcifZcE31WAOq/0+CwZMYuu8VMFSrkHJsyHXvg9ecqX/F8plIKnvLgvQw8JJF7UTpY43o8ykYqLtFBkBvqwy+Es0CdmtiFnxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ja95AnOuV+Z5fY8MsD6/NwB3w5GhiG2gKsA7dYQYCKs=;
 b=iDFh/ZoAcmq3wDhiyoOGRsnfDPTokCwGkhpYDqYkOaV6u1NqV04LpeCm7Cyvx0cw886c94Vb6H4oQlYEFEJo8I+w2ikfPeyiT8J5qOsHNZLdebCOr2VQUIYlIu8/4eO+e74Ym7tYbifTVXOUKTj+u37WGmGk0W+dScttAlAogpSfxjs3JCWXPaoi2cER0LGiU96nlTvtMskGXIWqGRJ3nmsIGIolCH4+W/6i8pydr2EhEy/76Fsh4zdzoJ5kbkRAyBtP0HKYDVUGJn2IxXxcQkOLXZrrw824QrW3LoldRbu/d1ZNOqtg0BCGXRygLgXGCMDBuixDQ+3v1fXJMApidw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ja95AnOuV+Z5fY8MsD6/NwB3w5GhiG2gKsA7dYQYCKs=;
 b=eck9mCF7fQC+3R7Rp927OxRFjlGCxJNH8gTShlyR+bpmoBpowhDnco0vTG5ql00eNqRNUXnIw0q+erAdcB8O3CfuuVv4Hlrda+Ld/YblV2ORjgYuew9ws3L/oJZEffRRoEnP0fRFJKpi2Us3ZBVZ8oMD7w6iAnsdOcoFuFfZj1A=
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com (2603:10a6:10:358::11)
 by DBBPR04MB7786.eurprd04.prod.outlook.com (2603:10a6:10:1e8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.27; Thu, 16 May
 2024 12:36:15 +0000
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::557f:6fcf:a5a7:981c]) by DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::557f:6fcf:a5a7:981c%6]) with mapi id 15.20.7587.026; Thu, 16 May 2024
 12:36:14 +0000
From: Peng Fan <peng.fan@nxp.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, "Peng Fan (OSS)"
	<peng.fan@oss.nxp.com>
CC: "jasowang@redhat.com" <jasowang@redhat.com>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "eperezma@redhat.com"
	<eperezma@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] vhost: use pr_err for vq_err
Thread-Topic: [PATCH] vhost: use pr_err for vq_err
Thread-Index: AQHap2PoJC/0KTnrWkOIs9fllb1Mi7GZy6QAgAAAj2A=
Date: Thu, 16 May 2024 12:36:14 +0000
Message-ID:
 <DU0PR04MB94172C1079F0EEF84631700688ED2@DU0PR04MB9417.eurprd04.prod.outlook.com>
References: <20240516074629.1785921-1-peng.fan@oss.nxp.com>
 <20240516083221-mutt-send-email-mst@kernel.org>
In-Reply-To: <20240516083221-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU0PR04MB9417:EE_|DBBPR04MB7786:EE_
x-ms-office365-filtering-correlation-id: 3dfda90d-9c82-4c9c-e2d1-08dc75a4c665
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|366007|376005|38070700009;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?L1qT7tebh6YGEH0dXrdI3UCE8P+gQ0fzI1b4TsUI7mKIIgRKy2ZmXuMiuB5t?=
 =?us-ascii?Q?UiWdTrigongn9sD9gak5+6n5T1x3shrjITnd19W5p754D1NyCCbn/F88QWhI?=
 =?us-ascii?Q?7d2NyPebwX2pdNLh0TBCDaQRnzYQpQ+IdQC/JNd4WnO8YNDMoRckmZjz56LV?=
 =?us-ascii?Q?z2KQIpu4cQbDNnDFyGjVf6ackzaxYM6pDtO6j8dyFkiqouOLazJ5n4zuEIKD?=
 =?us-ascii?Q?4GqaIXcxbfKZgFq7Bk6lcoX2LpVS29GEt1smpw58R6d9qe84a24DgodgHUzS?=
 =?us-ascii?Q?20whR6pKQYGvzgrbMec50uQtc2Fnti73LBX56LaPf+I3GZ4QYoGpGRWP4tkZ?=
 =?us-ascii?Q?WqmCDURlIWNBx4htvlqKlTjOvFrMTg8CJkE5eOIMeX2VCa1h8BgHH9is0Yyq?=
 =?us-ascii?Q?sDGMx3GZUQMTxvKhnSybzVOLsQrxUKtLjvxDt4i5p4tZFsqEfW2vCGhzJGys?=
 =?us-ascii?Q?cQKx2lkRyojQty1nMyCLMqTYWa6HiGNkJFmugvMN5DhltGdVEs0zG6SwrUwQ?=
 =?us-ascii?Q?DNzKtKA5CVTT9xQjl2ZlLtLdMNDT6jFyRqHlKUvNhqxTRMh0rQi7WufBTDky?=
 =?us-ascii?Q?6zqaA2S78YWkXJjOxkPdcEewwfPgBp9VGWrPzGk2hTAh7l3qOsp0+eclK1gW?=
 =?us-ascii?Q?wKlFBjZDq2Vf/AMLEl7n/MAIcbUinYxyqf+7yzSOREJcMbBunqvdZj8kvdog?=
 =?us-ascii?Q?NJFKzPNzpippZc6IFJoi/8PYE97fXVFVAioAI81w6Dotd3n16GCQqtWcvDkX?=
 =?us-ascii?Q?85QiyfIu9W51s9lMDyO3N4DCvPq1fZikDfJi2vf46jdz6AT9N6OnZz1n48ys?=
 =?us-ascii?Q?KGXKOKPx5OQ9MMi8287EfNXr06cFM/IZR7oc4vv1aTAQ0ToHu7VobDcXrFwv?=
 =?us-ascii?Q?yBCvTSmWYlnM4O0ynvdfpUG2ZhIn3sy2/3YJqrahb8EZAaoJ9iSh1xPj8jWJ?=
 =?us-ascii?Q?5lCEHOD+nY1hCSBTIaXEDhUMyAC6xmUuCCUnaM/Q/bXVniWCK+b6kdbZXgnL?=
 =?us-ascii?Q?tZfAM/HVI17CwpGNyefQxJJEC3YtV09OwJ/0cpEw/xt5+xJDeMOf62rGOs0d?=
 =?us-ascii?Q?Mu7YxT9ro9Aq+sqULqjcVagRY1y1NnaDdfw0jkwQYPYbmSKCRy7Qyri9vFc6?=
 =?us-ascii?Q?mCUm45OH+oOFvrBUvhcXcR2Rl8CtvGO8UKhim7PoUDt6MoYDLifU7BxMAhJj?=
 =?us-ascii?Q?PBDcRC/FTs9uNyVSEd+yvQwa1DnVBd1zpFcu1VpY8csgjzXuu+eBvUlUtFmc?=
 =?us-ascii?Q?NhtNMNpp32WOrqjN8dvfbR1Xmanhvjr8HkSgXF6/l0hZCO5tt48cEwFso3/l?=
 =?us-ascii?Q?ijKdAFtK3HroyJUbJUVSTkMOJKJkgrIrI2nY+oLsdmEIDw=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR04MB9417.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Q7pU6ICJ5hdFwyyjyDN+QzxqMgRw8hv4Cnmcp5rRgS8gskaWe5zhFHtA+FzT?=
 =?us-ascii?Q?D2uq4pOjLn0ErGCJqUpnQjAnCueb/arG9ezxjro5tMPgXcOdwf4dtP205Mqq?=
 =?us-ascii?Q?R4Fet9UmdymD98XFdOhBUqldmKK+4tgOHZNk5drY1o04DHVSv0BLaIE6Iyfy?=
 =?us-ascii?Q?2Wzvu9m5Al2J0/BFXNelFX15c2dgLZXBh0ibevjNYqG8b3oimpzFaj9TCxJi?=
 =?us-ascii?Q?kmFY/DKMsGHLf9vg+9F0PEMAwPhe26PJaP0sgV2XtSd3uFXep7/2+SHcaYWC?=
 =?us-ascii?Q?TMT0Q0/b5ZxpLnH/CCZiUiBc0R0dQfYDplYHyIce8yM2bxQN9/8wAXMMgHUU?=
 =?us-ascii?Q?bQ6Y2sqrKfHUmgTHVrOqJBml915dE48cBQpQQYm/zVWjz7YAWGKFh8L9xLi2?=
 =?us-ascii?Q?vIwtfUZqOTD/kAZAuH4fbZ+Zb9cHbYLry7Z32c0tEeuR2fGFuXMWXMkoEOf+?=
 =?us-ascii?Q?6xlhREJhy68ZLWoov64jxYV3kYlR5PrgXv0DZpn5/ukn72p2BHmj7RKXd1PA?=
 =?us-ascii?Q?72cYwxoWEzWBt8/4j/k9CH58pHM5pf4ZWWwsLgkh6+CDOCvZvz5gZqloTW3s?=
 =?us-ascii?Q?kiO23oreQoCwJhyy2Aypi/RbUG8GK1j4C23UuS/vU0LcUvbAQ/V0oz6jlX9q?=
 =?us-ascii?Q?R8I8FpufvwU3hm+lD4+lL+eNdN9yizFCwspdGot3hUqHUauMUd6ZnIDKqvTu?=
 =?us-ascii?Q?+F6LLWpMdL6wHP3DDgdGLwGFv79s0/wmrGXhKYEOgd2pdUiSprspo9o56t3H?=
 =?us-ascii?Q?yPR1EL2wYWnxa/9ADBIf+VOUnmZ5EUVfq1siMB9kB8wcjZuKH1sN3ypOULRa?=
 =?us-ascii?Q?SptnmVc0uj8hCDspiAOJZMQhapngWa8VBQF8G179lHdRc281ehtrNkeNwYwU?=
 =?us-ascii?Q?StIAGQOc0IgdRFhxfgXCbcE9Z1U6iZuIrsyyH6R+Bvp204HOYlKlmArX/yi6?=
 =?us-ascii?Q?6Sn9k9BBbowLG1MF6d8sCIVv+el+BX8yC5FvMB2j2UQmt2diVmN+PqgFFh6v?=
 =?us-ascii?Q?EB88jv/5DxE1GsgAnlntMJ7F5kzbeuvegsOwNpb5L9WW5eJTAPE2zpWFZIwL?=
 =?us-ascii?Q?mmT7mVkrJ7X7aA906jQMi6QF8a5NnCvOiWSyPng13diQ4X3d5ifTgHvffe+D?=
 =?us-ascii?Q?eIa2Od6B245o614VigWFrQJc4YPboFHBGag8NVkB5EQ4aX22gkMfak1BZt92?=
 =?us-ascii?Q?7c4WQiF8l8Q5PjhTG8fyocRhRpsIKmgD3xfXi3bz3Til0zJLai1tvwgpSUtC?=
 =?us-ascii?Q?lA1rleDc8Mv5e73/wbRxzMH/JElh2UBJFoiVnSbOBPLnx6PJw9H4fai9rRyE?=
 =?us-ascii?Q?0Rf/81hp7IVhwrqH4qZWFyNwp+0Fj7rmwiVyVc7O0ypmKn18ltlCAZcYzm6L?=
 =?us-ascii?Q?NTPjZC/AHhtNQ9+NKNmWmpd4DXGhzZIL7FNySr/HPdIdZ4A6h/KA1xSMSjen?=
 =?us-ascii?Q?xiQsFB8onWEARextWGcGe8vI1GSG1j3xF7+t85xKEgTJRbEDcyKNx5bzxsvE?=
 =?us-ascii?Q?akTy/gX3VjnsDTOIJUIVIVIrkRJhJNd3rWlp33eA5RwPo5iLViDnPHo5KsFh?=
 =?us-ascii?Q?jPrTy0EkJK3IKpg8dwE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DU0PR04MB9417.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dfda90d-9c82-4c9c-e2d1-08dc75a4c665
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2024 12:36:14.3331
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HTFrV/Iwl3DfjuFsI+Fptx80w++54/u0cAIXNbNUhQNXGxTwr2h5SwklLJD3cQ+EqF5/GqTKLV9+mHdOlbPutQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7786

> Subject: Re: [PATCH] vhost: use pr_err for vq_err
>=20
> On Thu, May 16, 2024 at 03:46:29PM +0800, Peng Fan (OSS) wrote:
> > From: Peng Fan <peng.fan@nxp.com>
> >
> > Use pr_err to print out error message without enabling DEBUG. This
> > could make people catch error easier.
> >
> > Signed-off-by: Peng Fan <peng.fan@nxp.com>
>=20
> This isn't appropriate: pr_err must not be triggerable by userspace. If y=
ou are
> debugging userspace, use a debugging kernel, it's that simple.

I see, then drop this patch.

Thanks,
Peng.
>=20
>=20
> > ---
> >  drivers/vhost/vhost.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h index
> > bb75a292d50c..0bff436d1ce9 100644
> > --- a/drivers/vhost/vhost.h
> > +++ b/drivers/vhost/vhost.h
> > @@ -248,7 +248,7 @@ void vhost_iotlb_map_free(struct vhost_iotlb *iotlb=
,
> >  			  struct vhost_iotlb_map *map);
> >
> >  #define vq_err(vq, fmt, ...) do {                                  \
> > -		pr_debug(pr_fmt(fmt), ##__VA_ARGS__);       \
> > +		pr_err(pr_fmt(fmt), ##__VA_ARGS__);       \
> >  		if ((vq)->error_ctx)                               \
> >  				eventfd_signal((vq)->error_ctx);\
> >  	} while (0)
> > --
> > 2.37.1


