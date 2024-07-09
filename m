Return-Path: <kvm+bounces-21147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A666C92AEE4
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 05:59:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2825E1F2245A
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 03:59:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07F1512C474;
	Tue,  9 Jul 2024 03:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bY8+JguY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2047.outbound.protection.outlook.com [40.107.96.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462C440855;
	Tue,  9 Jul 2024 03:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720497576; cv=fail; b=S1TQsQdXwcjGMuBC/7GR4OgbHYBWT7gLrch5PtHJocsYVA0E/a6zv3m3ogc5BVj1TvKk3TkxSvrmdebojhMNB/RENcMDIhmksfHxU0yboxWH+SKkTV3gLCKdKF3aP97DNJTPSijd+v9lz30hj9OW0iiVFwa4ju7EDLFc5X2I+F0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720497576; c=relaxed/simple;
	bh=7O77MddLXyds9Ni+3QOQ35m39LKOR42DIgHwb4NFocA=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=as4DEZTlnJYjX5uimY/hmk01Yfj/je0gJKYLNuxjOBP1c3x53jH34eW0gwIqxqDGFeuPRXIwf0LLKLxSMelj3ZF/4BySS+FmxVVXZ2Ugnp8BpdSip/kImBPQFB4y7cOn1kgdhPWuuZnre+k+c8jVviZfI1vBY5f7YBQROp3ZvBw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bY8+JguY; arc=fail smtp.client-ip=40.107.96.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=at6Re1XWrvIIGJ/A+UOdaFQuW+ECntJ4H87i3ekcuPdz7Rb6Rq51sAxBj0aBGKhV1bywfTkrnHBMo30QUQek1g2rsAIwrpR6VUymD9KVGnU7RydMfMchJbUDuXQrC5uNi1RaoVW2zJAh97WFgfmS6Y7TqPGZXnHisTSjVDXkFRqZeF6K0gb0R29Si2qnYHdmASPzfws/rs4SadN3loFq2DyYXVd1FjqqYfFDAV4fcGGaOg8umyLHJLZ27WhwQyc8GQLAjzTcAq85NLjPORxsBquQL31NZA2q6ZE3jCRFAyZP98KoyM1GnFyN7c1RdRtKsxkp3hhUxZrWvLRhLNLG5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ssfiDNbN4oYv/qKavVBGJzFarFLpLaVrQS+LkTeaojI=;
 b=lZW38OQ7GY8lZvYsa4hfhkD4atFTSjwfrQT2ub6QY6iQvsLeVVRRme9rgXOsTEyX/sPIFeQWGbL9w3qTVdPA7vknDq56wtVN7xuO3dUMVPjReiZSUuQ9jz8SANABzgsPiXcuFyo70lVfUcLKlKdY+oY3esUe4dkF08yAEeTXNJGCHAG9GnYtvvLDFrcIN3Wt4oy3OQLsG0OWCIcBGYJIih4SGPnHdJeJyp4Xu5s84peHxxw4kuJuKJJWwJXgPcIT6N7mBr4AjkWT00gIc6GhRk+kHoaClyQhq2C/G1E3mOAyhpDFkXdvnOH7BPpShIbWhijIiQD1pJX0KC/DVzICbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ssfiDNbN4oYv/qKavVBGJzFarFLpLaVrQS+LkTeaojI=;
 b=bY8+JguYmDeFRHRk+0KKxNH82DcLkbWdJidnj6Tybl4TX469zaaxN6kR1SqTatCQpcNszAQWMG5nBKaUUDkdN4CpjWCN1f8wSLgxbDw7Y372fzvM32RazbgP5/CmtlT/8MgP2oiaLq9WMlzi08j4fnsjgx3NAw32FjjYBv46egRh67WoayQgxZyfeUyZv5d89ecr2L5JlmFKChoG09Vnh15Q02r7G857etZamTth1iM1znybTEACUeRCiFNmwT4Yb+0Y3u7yzCxKRcaHqIY0cutyyTPTTp10qyNxIyoVFIdUOVQhZgUiXr/ylDSBDjwJMnimOzXL2t0pDQLmq43ybw==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by SJ0PR12MB7082.namprd12.prod.outlook.com (2603:10b6:a03:4ae::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.35; Tue, 9 Jul
 2024 03:59:31 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::361d:c9dd:4cf:7ffd]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::361d:c9dd:4cf:7ffd%4]) with mapi id 15.20.7741.033; Tue, 9 Jul 2024
 03:59:31 +0000
From: Parav Pandit <parav@nvidia.com>
To: Cindy Lu <lulu@redhat.com>, Dragos Tatulea <dtatulea@nvidia.com>,
	"mst@redhat.com" <mst@redhat.com>, "jasowang@redhat.com"
	<jasowang@redhat.com>, "sgarzare@redhat.com" <sgarzare@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v3 0/2] vdpa: support set mac address from vdpa tool
Thread-Topic: [PATCH v3 0/2] vdpa: support set mac address from vdpa tool
Thread-Index: AQHa0QLfS7FXUVdqN0KzwFRlOGkqFbHtxbfw
Date: Tue, 9 Jul 2024 03:59:31 +0000
Message-ID:
 <PH0PR12MB5481AE2FD52AEE1C10411F3DDCDB2@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20240708064820.88955-1-lulu@redhat.com>
In-Reply-To: <20240708064820.88955-1-lulu@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|SJ0PR12MB7082:EE_
x-ms-office365-filtering-correlation-id: 6e1d1a75-5cfe-4670-6bad-08dc9fcb896c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?8Ka0/X6fxHdtlH9Grnq5++/2efZrslPqYIN/Iazn776AOiUOVtuiIeErCsLC?=
 =?us-ascii?Q?EZ9V43KkaSsAs3bkBsYBDK/gwE+mTJFAupGKu5hHTKLaGRJvE/2JVjzOXciS?=
 =?us-ascii?Q?cLnYqPINqbgt/9c2EQPCpn1WEXM7obAmqL8aRSgoourdpni3bsVYIoDGtshC?=
 =?us-ascii?Q?6ezrUFnT9qFWSX+IRRvG8NLRmxsjZSE1U22u0pOt2DliWO+LecJIW7MnBZTh?=
 =?us-ascii?Q?0aZcesXxy2TcSoju7lpEgyxbncapZCWrJd6ji8s5tsutyY/KZ0UN2hql+fol?=
 =?us-ascii?Q?rO/SDD/lXdWAcL8pJ54VAkBKKUBgD4hcLQ0fwn8PFbn6wFrYBcCKA4KpId5Q?=
 =?us-ascii?Q?OE2Fxkgl9FQ0bllgfaKyWKnMFc42JQHXc3NZE3Ol1NperbzSfVYu4qnU66+g?=
 =?us-ascii?Q?ePWtp/WRWAJOlN+VHePG0egOkrvhlaDXEmYP6qdJlOtaLEcNUY6RoCS8ANU8?=
 =?us-ascii?Q?h3boUbAx958OIuCAWtajNPCF5usDA9HAgAqs0bK5w3UJalKNc2rtF8dtKyN5?=
 =?us-ascii?Q?k24JLmjo1O5KEjPeR8ik9D9dQgn6JHPhutp7iGGFhVRQTvosG2tHck9nIqvX?=
 =?us-ascii?Q?TqAOrzmaDGCmTa89utcmSLx37hiktz+VCRF2G82os9QRdSjts3l12cAEatI3?=
 =?us-ascii?Q?5T26DmfRi3OM7mokT1vnuM/j8nOHV37CSQb6cbePQlajf0ZNqUkfuIxbdbK1?=
 =?us-ascii?Q?vr4aQqxJgkwPYfFG4RTHvD/OFfji4zw8iLq2kyp06vnTu63jLPB8zatnfGVI?=
 =?us-ascii?Q?U+EhC15WID103uAKDcBg/fFJBpDkVYiM7JFUE5CMOHVKFmaYMGe2I0p3Cul1?=
 =?us-ascii?Q?k3aiUnQysYZC1nV6nCgm7lRouviBW4yOafQXIyRK686E5pSfgLkxKktB776Q?=
 =?us-ascii?Q?rq5IjbHZrG4BvCl5IGWCG062Yg9NJFPMUbv11XPRODbEvYqZcX7JTLP0a1ho?=
 =?us-ascii?Q?QEqx+eNoVv9+m3VM2Sp3j7l1trIA7SpHEnrSrxwCz6KCNFhyA+PFEgpzxWwS?=
 =?us-ascii?Q?lPPgi3TXYbTLtEgdvNOykSw/FLF81IpGWrsgREutVwLnBuBF4PSER3A2YYAR?=
 =?us-ascii?Q?e1qO3QNFOeLTU/7pMNvjwg/1nFvX5r6plytjttF4xcNNMjK5aO1GR0GHweg4?=
 =?us-ascii?Q?3hA0nc5DaI34C0UvSOpBV8VwLaeidwDgyXDdA2y8fxBu7Px+C2SeDunniwo+?=
 =?us-ascii?Q?XYAdMadBVNDFK8FLh9s5tnYrO7ngQQLZWSbs81Dw4TgKBAZ/lBkr6EWuWaZZ?=
 =?us-ascii?Q?B/rGTn8DxX1vV8EJW6c3VLqJt8R7a5HLsO+ZKuJv+kXV6r+vtcv590fBgXVR?=
 =?us-ascii?Q?XtB6P89JVvzJTAudQzqvCY6++IKdvf21ksduiIkMZbDdOmYuJNFJXPi1/kqy?=
 =?us-ascii?Q?pUEo4aGeV7lqXW8GFrynKCOvECLhLC4Zlbp2spNpLdzpqGAVdw=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?4E0S+aURN/pVqvBJ9l77elgc/q+1VH8+TwbeECP8YT9n5d6ymNBtebKtUbVF?=
 =?us-ascii?Q?0Hobm0kn4T1SZSCuYzSRs2QgnL5eV50KV7/whq+gzxCSkTo26jivOvxYjBUJ?=
 =?us-ascii?Q?GkPjBCvBv73mtzEBeoYNY1LJsqvNg99rXA8zs92Nb+HvBEDhC2UFOFOOVSqY?=
 =?us-ascii?Q?/F1Kc1YSe7c0t2CgTp5+zGuLY2fH8/ELK3NVuMhjAmsG/BMOZPnzySKHHwVX?=
 =?us-ascii?Q?37yAgWNUOiNIPj+pp8RFMWMEz5/fY+wzE4QUb6lMc76WX77hwSQt9GzVu+Ci?=
 =?us-ascii?Q?GEAUftMkss0Ae6XflgYCWZOvf8eQrQezmL+YV0XL391PLwGoJoRRvqL2YmRV?=
 =?us-ascii?Q?RCidADFvQ7rDpwTRUA4pDmJ7pnKlUTcWJk1tTS2cyutDbaUZUozRmdEoAzL0?=
 =?us-ascii?Q?vlGFo+1lcK3oT5HO/hlqFdVif82u4jA9Y2Sxp5zxmLo+uIW+e3uERdAxrZcx?=
 =?us-ascii?Q?3KtMJ5b+qJmdzeMay0CbucKezbCBSDJehbUz5nSjP6vcn2xR14ICx1pGK+aE?=
 =?us-ascii?Q?5e/3vlD+rKbxqymxm+/Vg6eBMn0R8rQ6rDBr9qVnUv3kwVf9TllLjlv0SwQJ?=
 =?us-ascii?Q?ew3OAK1X3Y7zfLrjI7iE39EwtQwL85jNW5P+UYLeP6gMXpJnpi0J3mb91agp?=
 =?us-ascii?Q?RMWff4sRmNfC+wSOKMh6oQGiOUjRpr4XKztC3b5+De83d7cCngX7hf8tAD5/?=
 =?us-ascii?Q?4RM0gUvuJ+/hk5ovc0cN1r6kgML5+tJfpFoFhWU4vLEjOAcafiJLaFm2K2dR?=
 =?us-ascii?Q?iCjLnI3WAJEr1IapSyNanRNIAUgOXqlDws1XbIkz8Ihno/XUcqUi3JBwbY+6?=
 =?us-ascii?Q?a7fxr3S0E8rQ5LXOoB3iKHF5x9oZEz/hAHUb0OMLeQxNMJzVGQu5yV/avtC5?=
 =?us-ascii?Q?h8wa5rDXjKqLBkHSH5ONbkUTw3Z4zGsxVOF7HgM+qgqzxFofSIvZPAJhMaRj?=
 =?us-ascii?Q?fz2vZwrtFHpY4gacfwHakQp1t7g3809kZGo8abMTo3+EMieE4aZ2yMKJyQrr?=
 =?us-ascii?Q?M9uQci3BhrAJnstqzc+2sb8PBMsK+ca36fwrJNHsVDb4VGHyTtubBzsvETPw?=
 =?us-ascii?Q?YnQ0zv9dg4KbuHwmjrRUP5YGTy2JF9QPDeArAHsgQfhQZ6Pzt6qhmfOUS0P3?=
 =?us-ascii?Q?21XmOsH6jqPBqoX2oKrdBYoU3rUgnQLaBdsSyusRGxyFTCr73pwJyKcnlaUP?=
 =?us-ascii?Q?uLpv0GhJ8M7b9SwbDlwwi1GV+oEXtvbJgaWPqN2R6DMVQTmKrCSeW6HhRAxB?=
 =?us-ascii?Q?Tkw5+1heY7fshPHlRzmbw7RzfWno/qzvkhrBUUjTPwLFNWAg0iGxek69N72N?=
 =?us-ascii?Q?B1GHdy1YNVO+kCQyuiM01eHaPYUBYuXbp3SIO8mhtVjXbYiwU2qjdutFings?=
 =?us-ascii?Q?clOz244jjHjh9CYo09nMYSRl36748WIk30LSDLUStgn9l+B/dGhS0oq3LFt1?=
 =?us-ascii?Q?BBSm/q+yXAYdFEpSvlyxK278UCN1NGJRs0YCv5+E+AQMxCBybFWPNSzK9sGX?=
 =?us-ascii?Q?Sp78eZ7SRi0iweS/uXqDzonmmfdlC9kKQFbiDhtbY8d4tR+Z5/O/9vnuBx+C?=
 =?us-ascii?Q?Zd112Siim3Bo5vtOp0c=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e1d1a75-5cfe-4670-6bad-08dc9fcb896c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2024 03:59:31.2153
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jKfW44wxxdPadCsA7RENvZ0WJspnucZ8ZWJT2iicpEU3NmpMxaAM1XUJWx630j0JzcDL+cL72HARrZWuAeBiRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7082

Hi Cindy,

> From: Cindy Lu <lulu@redhat.com>
> Sent: Monday, July 8, 2024 12:17 PM
>=20
> Add support for setting the MAC address using the VDPA tool.
> This feature will allow setting the MAC address using the VDPA tool.
> For example, in vdpa_sim_net, the implementation sets the MAC address to
> the config space. However, for other drivers, they can implement their ow=
n
> function, not limited to the config space.
>=20
> Changelog v2
>  - Changed the function name to prevent misunderstanding
>  - Added check for blk device
>  - Addressed the comments
> Changelog v3
>  - Split the function of the net device from vdpa_nl_cmd_dev_attr_set_doi=
t
>  - Add a lock for the network device's dev_set_attr operation
>  - Address the comments
>=20
> Cindy Lu (2):
>   vdpa: support set mac address from vdpa tool
>   vdpa_sim_net: Add the support of set mac address
>=20
>  drivers/vdpa/vdpa.c                  | 81 ++++++++++++++++++++++++++++
>  drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 19 ++++++-
>  include/linux/vdpa.h                 |  9 ++++
>  include/uapi/linux/vdpa.h            |  1 +
>  4 files changed, 109 insertions(+), 1 deletion(-)
>=20
> --
> 2.45.0

Mlx5 device already allows setting the mac and mtu during the vdpa device c=
reation time.
Once the vdpa device is created, it binds to vdpa bus and other driver vhos=
t_vdpa etc bind to it.
So there was no good reason in the past to support explicit config after de=
vice add complicate the flow for synchronizing this.

The user who wants a device with new attributes, as well destroy and recrea=
te the vdpa device with new desired attributes.

vdpa_sim_net can also be extended for similar way when adding the vdpa devi=
ce.

Have you considered using the existing tool and kernel in place since 2021?
Such as commit d8ca2fa5be1.

An example of it is,=20
$ vdpa dev add name bar mgmtdev vdpasim_net mac 00:11:22:33:44:55 mtu 9000


