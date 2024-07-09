Return-Path: <kvm+bounces-21148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A46A792AEEC
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 06:03:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 36A4A1F223F9
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 04:03:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA30B823A9;
	Tue,  9 Jul 2024 04:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kNy++1uo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2067.outbound.protection.outlook.com [40.107.94.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3503D38DFC;
	Tue,  9 Jul 2024 04:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720497822; cv=fail; b=NanUYAzb3+l1uWrGUTXfo1I4qbqbXjW9T+Ceu+avkfV91A6/o/LFTDwaS00E5F6//0w5p327dfuYFopH3eWnm75SILDXT9beeVcudmELB1nHb81meYCeHqFHSgJ/MKggpd74P6vWdE+V4qQ2ruCeiARr/jzS6zdiXX45nDablyA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720497822; c=relaxed/simple;
	bh=YbpDOkV/EkLab9rxFwHnwPUtkoDz+mVCqc51+AzZtQk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=to3CRJu+KH4+FC+8O57+qJ65EflBccmPu3MB4iVidmgqlyOyV2U5wHCl6fAFV2gi3/kOV9zQZhp9TfK7Cz4uS/7dPkoZ8B65o4i1+w/ypdj6LWJnv3W2j9Q6nwYRyAFdAFKRoSRZ0zbEWvCm4ei/Pk4QM4lMelj5w094P12EKVA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kNy++1uo; arc=fail smtp.client-ip=40.107.94.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fsoitht1PYUtvntuczYgxikHqa9PNtGVIVzL+Wx4wUAZf2z7zUtrl7bcB3WvdsdTMT7dkYPkSTxmaaCMN/Fccog8J12Vt0B9zpiinumu6UCIZbGTR/KVXOjGVKQLUQFYWZIwDgTSF+aEhTWsM0as5lgS+L+b3oCJSq/hcBBDnjgoifAo59wumcoDK8OZGfSkcli52dVx/93VoHaquluv3sfhVfjUTkDqGc/3MAucWclBNcXN81pv2REEsLmTFONvifyG98aaMhHt51utwVexo1tnDPSqjLEvSYX95wTXUrFtCSVMsB69AJ3Xc+jUk+mz7ge8csiMvK188AEzLa5pGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zICWso4Cih3PNM2A08l3tebJV+V8/TFPxPN2csRStok=;
 b=D34LlE/cyG5lFM4i7STuXRskNArYkgp9sT3KtMNpp0ITTOQwDRGoOLmUPUT561DYFWTL7+98Q27R+ycFyNXywU34Bojo1fzF8Wp6pcCVvQsVS7pj35fpL+0ans+CtcRi+co2NXqKTUCZmt/IdGW76R60f3Yv89UPQSXpJXjxZIE415az0PW+om1TQE29wHtY4ILKLaI0PI6jHwyeiACZsNe7rOsu4ziMn+FcTvmFNJcuNkkzMnKxkuFaspVXAB7/mfnXJh/V/qEquZQkX9OAKJY1ucI5WWp1dr46Ge2uapc1n3C5BukxiLwgLFWnBy3PGu+WsJHQ9z7oRg8mMexMdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zICWso4Cih3PNM2A08l3tebJV+V8/TFPxPN2csRStok=;
 b=kNy++1uoIKEryUBbjrIprQxJPgKj1bzRtTm4rcYAZIk/OEmqYozm6SX0CBVW3K9c9zFxJuZzG6lQZRdLMWqWmEtSDj7AK736xq0zUX2agBkxD+RJFW8IZcojNei54qZunwbq/hvhwbfw44jhldauSE/Q7SaOQLpwG++NQ+g3kWpIASB0LtMbtuP7QAVMUycvgHrV8twWbkINkFEvttPOjV1jOs30OWGdmPS2MqpwGb/of3XnuH/8E9cIr2yh8mV3i6cr8s23Xe9pW1f9cUzcjoBBBDesx0WVa/ZpnjUrOqkrgJDn70IY+tn4r4UTttWo1viLsj4BqPmYyvD+hq/H2g==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by CH3PR12MB9456.namprd12.prod.outlook.com (2603:10b6:610:1c2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.35; Tue, 9 Jul
 2024 04:03:38 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::361d:c9dd:4cf:7ffd]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::361d:c9dd:4cf:7ffd%4]) with mapi id 15.20.7741.033; Tue, 9 Jul 2024
 04:03:37 +0000
From: Parav Pandit <parav@nvidia.com>
To: Andrew Lunn <andrew@lunn.ch>, Cindy Lu <lulu@redhat.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, "mst@redhat.com" <mst@redhat.com>,
	"jasowang@redhat.com" <jasowang@redhat.com>, "sgarzare@redhat.com"
	<sgarzare@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH] vdpa/mlx5: Add the support of set mac address
Thread-Topic: [PATCH] vdpa/mlx5: Add the support of set mac address
Thread-Index: AQHa0QPrpfOx9JvEP0i0EeHt5OTSV7HtMEgAgACXH3A=
Date: Tue, 9 Jul 2024 04:03:37 +0000
Message-ID:
 <PH0PR12MB5481507DD48109352EB422FCDCDB2@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20240708065549.89422-1-lulu@redhat.com>
 <b680300d-d18d-45b8-848f-85824332c7ca@lunn.ch>
In-Reply-To: <b680300d-d18d-45b8-848f-85824332c7ca@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|CH3PR12MB9456:EE_
x-ms-office365-filtering-correlation-id: 463587e1-c9d6-4ee0-739f-08dc9fcc1c5c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?iHCxYbRH9TTI1r8AjTaH+mPKi1ZfXQiiRM/kqBeG+h8NRe5FxvG4EpsibTUf?=
 =?us-ascii?Q?r0zWpq76vsyK8ild7x7F0vBdp+wCnSNcBWCMQDRLlAevjJWi8MRsEycEiJUp?=
 =?us-ascii?Q?ODtfvWvv09cQQFGxIbuzq5E+eYBDNbNzH6FpO5AbvsOJLq2Zm9Ob4OTw+0gC?=
 =?us-ascii?Q?teIl2Wl+cz+1m/FuOYwUiaH1C0WJFlj/VPTGHRa0rXeKLcNrEqFq2GT5WkAW?=
 =?us-ascii?Q?UMMdGGa99PfLfxmHefLqqYs5WVG0zJqXxKpydxGFYRbcp5FSXOx8INhctqng?=
 =?us-ascii?Q?kh1IBoZoyIs13yj4ny5OP8zqvR87EVBk8qDRYZZxNC5ohEadCWbxdSuOLWVV?=
 =?us-ascii?Q?K6XuuaKGVBaY1yXrLhqpUHdvHTodYC9pG7cYNznEkfv5/X/AgUk7EIcVt9P3?=
 =?us-ascii?Q?wi/HPhW8TOEgtAgOY/4/OG4eN86mfg4o4qh2oN9WsAzL/pKA3vOo0PGohDg4?=
 =?us-ascii?Q?M6ZmRYibecbjn9h4jNWG8jA5/XD2WAdmjQA4C/lEcoQokyw5XNKfkLavx7eN?=
 =?us-ascii?Q?kUaDW7xji1iw9nnNy6fl4xrthDiumHQN0t5ZZk9bjYRaj87gA8U5fQxZLNtT?=
 =?us-ascii?Q?GvCnpnnRbQ59r+9ui0+K4kiYomDjRqvVDw5CVND61rZChj7Mz0r1o9NRTn6v?=
 =?us-ascii?Q?cANMKQiXN8dim63sYkzJycg5Xq1fyBFLTpeirqEmShWHQfCQnTFbscyGugj0?=
 =?us-ascii?Q?RYILsw3C4HLQDn56/jo3cQW0R88nC3sWlVEvN2X/V/7CIb9D/WGCvntYPmbp?=
 =?us-ascii?Q?D8/NgwLZEqjYq9CnIveTHQIXh8JFSzrXg3v+dPP4Tdc7Eq5JE1tKyqUp2d6w?=
 =?us-ascii?Q?eU+WqGq++f/2LRIeHPe+OdrBgq9RBAOYBXMdrJ/8yHolM1dvLMnLeVe1MLdo?=
 =?us-ascii?Q?rLovOJpG1aJpbt3nxiFkbbg0aY2gSfZe0Ts/2I3YvRP1qYThLlXuF1RAwjig?=
 =?us-ascii?Q?0ZAmpfCiE9KtPbzqWIdvRCoQ83VjzIZMBJC5iy05Z3QWUyOaV2LLdqOqVgrD?=
 =?us-ascii?Q?4U0GtNPJxNwy03gSswRtEBVRlJ43r153Sxhe+dunpxr9npn1MkhgKGaEgmLO?=
 =?us-ascii?Q?VlgDrZeJ3I0XjTnoWbP6IdrUaC6FKoRn47dQ5qbpKBP/9DPEZp0gIb48VzkW?=
 =?us-ascii?Q?2tjngy17kXeYFscSz9M9CHsFAZdZgFWBD38C6NxgK2ws7KKSxWPegSEql6HK?=
 =?us-ascii?Q?v+WC1933aDE8YbeObZTiZPGb2hXfdNseriSseTsmp7f7WoVvxILmcuUTY4yI?=
 =?us-ascii?Q?mXkNhPyxW/EVUWlzZrq45zJZST9f19YB6TyQF6Vy6lppyUkvptFmoRJU2Se5?=
 =?us-ascii?Q?PEDk1NpigMGTl4L0HtO21fT39bo/vtL1UIsFnL4b1eGJZT+7cxc3hxzC7WP/?=
 =?us-ascii?Q?/tK1dAe5aQy7rZZ67tTbBTyMND3TK6XZpGkY3+BbK2fHU/eliA=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?o8VK8twu3DYRSCjSBEaixmZc0UDgSigUYSfitXmxnXHS/gzfjefRCoCsYfOd?=
 =?us-ascii?Q?lRrOchtQMxDQLs7y4gPrn/Iux0xv9ir16geArBx2AxJRI/fQNZs9SpJzQCXG?=
 =?us-ascii?Q?cWr5XE5WUnMq4qsy+MrzzECLJyPTcYu13MLKTipltBm9XjoyF+XT9JNyiO9s?=
 =?us-ascii?Q?Z5XGLDtTVIin1EL4EviwBqrlam9y5KFtfUhVjETAiLxFYDv0glljjz0FajQ6?=
 =?us-ascii?Q?9kr/JlVrCkmeVoya9EIfVsP4GwXAlWnkTbjFcELdgYy086CYbufoNnhomelu?=
 =?us-ascii?Q?elqGg7BuCfcs/vwCc/KcBVRZQkyD//ant2yd7IFgFiy94eUVC4bcmsu/YFc5?=
 =?us-ascii?Q?RY+57Wgb4x3AFthHo5QRaPNoRShJB5BoQzbwg3yIIsKEu/DCqduNA10xuSKW?=
 =?us-ascii?Q?SDuoLTqi+xcIfs3fJxL1BqJht7vitSIXIYSxXIO69F0GUNJFjBoVHOAsUC5h?=
 =?us-ascii?Q?MiFqu0tB+7igCkVjVJrF5KvbPx8FHPK/XhRUfVPVJXcscTMp4IjZ5gr3NPF7?=
 =?us-ascii?Q?9N63c8e2TGDNYmDnroTJLI4/MF5KZDp9OhJb/9fYFIupeAZHwjbIjPTsVUsR?=
 =?us-ascii?Q?ax6uifHH/xaxgl8j2L8IpfxlMIZkdpqHPZQQm5jVCb2M8e3eULTjmoCeL4h/?=
 =?us-ascii?Q?VlCFDxOb1oO+WK5g52n9igh7PIbHHZN3qIcG5wZ1nwhtP1InbzwLFzQwMDiQ?=
 =?us-ascii?Q?y7XqWfUE08AC02Glr8AdMNh/QU9UPNSRgtcjn/avvTgio9lGqJtQ4vxjghKp?=
 =?us-ascii?Q?1enzyhzW+cq0Uwnv/8dh6Z+SiSHTdmOoYlwxurHdPphJTVFKL+oAEkMnfF55?=
 =?us-ascii?Q?wwaEAirbClDLmVsnrdNQCBUG/X3q3Z+0hOL/gFIT+6YcIIsCQSSUHk62cgc8?=
 =?us-ascii?Q?nKWJ/wjOa0pzS49JVQnzezSTIBjlUXFJUYDcw55uGij/N8Ma3gDAGwpKgPCg?=
 =?us-ascii?Q?AIOVJ+SSHzCXhJaQ8n+ZpWaA+cTr6YFZbOFavFhvR2ffAmuyF57uqKfM1MgV?=
 =?us-ascii?Q?8L+QoAP/xvPuBMZlQFmBxMM5fUAs3EnQy5oqvKHKZ0KlJvOUuMSEVVxN9P4g?=
 =?us-ascii?Q?L2GTFwd5mdAk5NEK4i7eOKCU5HIW09vGPX2TxkRbBu4HBF0GW5J+mg1PeidN?=
 =?us-ascii?Q?EJ/PL98SpOsp9EqbdBIMxZSknps0mhyQplitgJ2Ik8ARX4GWKbwOf95PI7CN?=
 =?us-ascii?Q?djfM840wGG+dSCE0uNZ/6oe7KX69d6qs+jTDKseOJ16ylYYdjwVaoQ3JxLH3?=
 =?us-ascii?Q?9EcAHVusrnb1iC/ITNGSpjFSZUvQxIpssuG5fQ61wyMx0/84ybHOXVintour?=
 =?us-ascii?Q?+zl7X2fVmXkYDBKF+E4ojnhsffWtjArL2DoXRvS7FfQpLyVX++RwxY1ZqWca?=
 =?us-ascii?Q?nIlJTiN1SeqkWfJ510LmOPWV1BU4z6CzzJ01rssx1yL8+Og8WUGUWbogmyKF?=
 =?us-ascii?Q?ASSlVzF7EGYAkFxDxkL6FuKqu0Y7mDqKWaYyBFvG2DivOnA3VzrB0f/TWWqR?=
 =?us-ascii?Q?wXcy58DE9xmANB6NOKTP7i5q7EI/iBIydg2VBjA2ZvgRpNxkQ3NnuWSaF7Cr?=
 =?us-ascii?Q?zccgYAmM7YzQOwTiIps=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 463587e1-c9d6-4ee0-739f-08dc9fcc1c5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2024 04:03:37.7517
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5dJ6LOZETvVJDSI/Xil+PliLrwadyIphlG4T3Axs0KXzyRKx7THAmSukidTBWXtSA/+gnMKofi6cHH3gcETT4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9456

Hi Andrew,

> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Tuesday, July 9, 2024 12:31 AM
> To: Cindy Lu <lulu@redhat.com>
> Cc: Dragos Tatulea <dtatulea@nvidia.com>; mst@redhat.com;
> jasowang@redhat.com; Parav Pandit <parav@nvidia.com>;
> sgarzare@redhat.com; netdev@vger.kernel.org; virtualization@lists.linux-
> foundation.org; linux-kernel@vger.kernel.org; kvm@vger.kernel.org
> Subject: Re: [PATCH] vdpa/mlx5: Add the support of set mac address
>=20
> On Mon, Jul 08, 2024 at 02:55:49PM +0800, Cindy Lu wrote:
> > Add the function to support setting the MAC address.
> > For vdpa/mlx5, the function will use mlx5_mpfs_add_mac to set the mac
> > address
> >
> > Tested in ConnectX-6 Dx device
> >
> > Signed-off-by: Cindy Lu <lulu@redhat.com>
> > ---
> >  drivers/vdpa/mlx5/net/mlx5_vnet.c | 23 +++++++++++++++++++++++
> >  1 file changed, 23 insertions(+)
> >
> > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > index 26ba7da6b410..f78701386690 100644
> > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > @@ -3616,10 +3616,33 @@ static void mlx5_vdpa_dev_del(struct
> vdpa_mgmt_dev *v_mdev, struct vdpa_device *
> >  	destroy_workqueue(wq);
> >  	mgtdev->ndev =3D NULL;
> >  }
> > +static int mlx5_vdpa_set_attr_mac(struct vdpa_mgmt_dev *v_mdev,
> > +				  struct vdpa_device *dev,
> > +				  const struct vdpa_dev_set_config
> *add_config) {
> > +	struct mlx5_vdpa_dev *mvdev =3D to_mvdev(dev);
> > +	struct mlx5_vdpa_net *ndev =3D to_mlx5_vdpa_ndev(mvdev);
> > +	struct mlx5_core_dev *mdev =3D mvdev->mdev;
> > +	struct virtio_net_config *config =3D &ndev->config;
> > +	int err;
> > +	struct mlx5_core_dev *pfmdev;
> > +
> > +	if (add_config->mask & (1 <<
> VDPA_ATTR_DEV_NET_CFG_MACADDR)) {
> > +		if (!is_zero_ether_addr(add_config->net.mac)) {
>=20
> Is the core happy to call into the driver without validating the MAC addr=
ess?
> Will the core pass the broadcast address? That is not zero. Or a multicas=
t
> address? Should every driver repeat the same validation, and probably get=
 it
> just as wrong?
>=20
>     Andrew
>=20
I will submit the patch to add the check in the vdpa core for mac address v=
alidation.

> ---
> pw-bot: cr

