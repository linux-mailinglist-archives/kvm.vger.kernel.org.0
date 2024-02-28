Return-Path: <kvm+bounces-10216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F6FE86ABAE
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 10:53:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 556DD289A66
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 09:53:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99DFA36136;
	Wed, 28 Feb 2024 09:53:49 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2101.outbound.protection.partner.outlook.cn [139.219.17.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D224360AE
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 09:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.17.101
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709114029; cv=fail; b=XDiRL1iV4Rn1ayg/W7th+Jj6G1j6DopAUbqRHSXM4c97WMNg0Q42WqZtC4PATgYXeNsJBfX0DkdY+7HerDTES+v9tExOX7K8pSreieYg/NDPXXm8Ku22fypUvuxDejYxcnR8PnG+X8kdYBvyk13A9Urq/u4QYhLEZoKSLUgQt9o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709114029; c=relaxed/simple;
	bh=P7TtvKzWCI4C+rUAk6lYWK+deWhAe+Zv7JCooycjtJM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=h86xRRoTSwVJWg/cqfWC8cYOXxP0MpQyJOxv6wtjQFrl2RLTJyVGWwZ9+m6AB7sA4fgM3RupEzFO260PWnfBYk9scaRJoZkN7aB/l5MYRm1VhH4wH3U0QsJF3HB6n4k4+hIxTropKWEIapIo5pH749ZP+rsIa9mIvuJoyHda/7A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.17.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NAOanX4SiKtU59R8axV97k0mOp5/Y2whKwZOLtXJz+yTDW8LH1PGJ4zaUtKyJCHR/qPZcBw/sibVFlhAPEz4RX7B9pUbG7y071citjpKfYCwkeTXwavLlMMdiQZS8+uOOqN5+UPoOgAGVxcTLzK4yAX2bIeVVHW2UG1nTaJXAbIIk67HxPxbextAZCrsKGibpSslF8PSeowZM/EGksJwD1XJMpg2OfNrhE5NkDyr+KwAcMVqCkaZJ6SWyNOj4klkJ1ldLnGWkEP5SiWw6s79Nf95wCn6/IM3ChbB71ZVHjqM7fBNiqeFVlSJBbjIM/oZxR/QfzKN2jjq6P/YCy802Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O421G9rJ28NM3BxN8/yBdzp39i/5/NN1JkYjN0peHcI=;
 b=SGHGOoM5i5NwKIAOixh+Q9J3Nnjf6r/U4+tF792i3MH8jq0Qwq2sNhKcMO263rBr2d7mLqMx/KxT6TrjxiRwy52sShP2GHHZZAiPzcydT2DyIKx3k3DHkc7P7/yeWDb0Iict7fng46zI8xHqVD9C2nL+mfae1mNTDjshC70QxtrC7+n7AW5NOHkEvjbGOKi4Fx1mEdcBftZW2hgocsaL2MdrAvduQbsq+UyZnEFGHqeQN2m9kHZBmzKAtVQa/iFune6oSqG42kbT3a00KSIPSV41t5itaGil6zFlyhD/7WP8uSiNxgdgYhl1hjRZ6kr59LFQIB0FgBTgMMrqVVgT2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Received: from BJSPR01MB0561.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c211:f::16) by BJSPR01MB0738.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c211:1c::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.34; Wed, 28 Feb
 2024 09:53:41 +0000
Received: from BJSPR01MB0561.CHNPR01.prod.partner.outlook.cn
 ([fe80::fcfa:931b:8b1d:6af5]) by
 BJSPR01MB0561.CHNPR01.prod.partner.outlook.cn ([fe80::fcfa:931b:8b1d:6af5%4])
 with mapi id 15.20.7316.037; Wed, 28 Feb 2024 09:53:41 +0000
From: JeeHeng Sia <jeeheng.sia@starfivetech.com>
To: Zhao Liu <zhao1.liu@linux.intel.com>,
	=?iso-8859-1?Q?Daniel_P_=2E_Berrang=E9?= <berrange@redhat.com>, Eduardo
 Habkost <eduardo@habkost.net>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?iso-8859-1?Q?Philippe_Mathieu-Daud=E9?= <philmd@linaro.org>, Yanan Wang
	<wangyanan55@huawei.com>, "Michael S . Tsirkin" <mst@redhat.com>, Paolo
 Bonzini <pbonzini@redhat.com>, Richard Henderson
	<richard.henderson@linaro.org>, Eric Blake <eblake@redhat.com>, Markus
 Armbruster <armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
	=?iso-8859-1?Q?Alex_Benn=E9e?= <alex.bennee@linaro.org>, Peter Maydell
	<peter.maydell@linaro.org>, Jonathan Cameron <Jonathan.Cameron@huawei.com>
CC: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "qemu-riscv@nongnu.org" <qemu-riscv@nongnu.org>,
	"qemu-arm@nongnu.org" <qemu-arm@nongnu.org>, Zhenyu Wang
	<zhenyu.z.wang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, Yongwei Ma
	<yongwei.ma@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: RE: [RFC 2/8] hw/core: Move CPU topology enumeration into
 arch-agnostic file
Thread-Topic: [RFC 2/8] hw/core: Move CPU topology enumeration into
 arch-agnostic file
Thread-Index: AQHaY9zgA6WlslRpbEqlf9JnTtpZtrEfj37A
Date: Wed, 28 Feb 2024 09:53:41 +0000
Message-ID:
 <BJSPR01MB05614B900DA2E93AE9F8E0BE9C58A@BJSPR01MB0561.CHNPR01.prod.partner.outlook.cn>
References: <20240220092504.726064-1-zhao1.liu@linux.intel.com>
 <20240220092504.726064-3-zhao1.liu@linux.intel.com>
In-Reply-To: <20240220092504.726064-3-zhao1.liu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BJSPR01MB0561:EE_|BJSPR01MB0738:EE_
x-ms-office365-filtering-correlation-id: f45306b8-3f87-48b3-8064-08dc38432535
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 p+f1L5tzNsFOlteLg0BfxSdTn2IBjv5cPfdGoaaEXFCF5C8ca/yfyJo6rMkL1fzimacE7X0A+e5Q/qNY7VbfYDuRerHncFyYF5bvZAwSvcN89lpH4BzWK68ud/JzePxBnBvU7hX2quRRZFbc//ZRt9Hj5Pz2Dtpv+t+TPrJbBRo32aRFXbZ/LON1HRDio7W1zVJwdbibveWUuQRVu3kioxc9W0J4FaWWMlo0T34Jp53RTBEDOgqHhA1mpP3JR0i86qItJ5oho+HVhd1yTwjJSnbhSioV/GsRJ/Ace+n3Rtf8kdDkPvKnyWF0MXJF9rzgUCJ52Pdfgdg4STXYHaYV2fWXalFM3O3NBTlbLqgPtiMZ2OABzmJjgItjKRW6L1Y08Nmy23fenBqWk5dzjKaHhKRaPBx/u06aq+IEuR4uCNBVQf6c6SVXI7o0fPaQkpVleCyEjzQ9rQGtbetFIKWUF0PhEb5C3M/YNK76Fe97n1UTjXFfR7J1zqrwHv5gSlXMRxxf9xMReLTVKbYEnjSwEN79bglhJRmJzuGAOR+/xOaQ7gYX1mNNmdszDF/atGzdhO7B2sj9ag6m3VKlCHr3OODbVQtomwJbvntEzRv3bF9uq/SLPiWVrirhGEicxnOe7SG28NfXcVBuS0oPgdHS4g==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BJSPR01MB0561.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230031)(38070700009)(921011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?fbTX74lBQGH/L/sLPBC2r0PF8+5TeYFbU4WnJtX9hdkexYW4KwTnokCNDc?=
 =?iso-8859-1?Q?NrL/8NRHzfnWLd2t6d29aaaDSszuMBsdAruDhWiVQHmk1R3R8cAQuyB29k?=
 =?iso-8859-1?Q?QUQupP+p42Q70yHOkhmQE+HnYyp1VcMz/fqMNvObHvDH4EqJH3Ow3JR5hJ?=
 =?iso-8859-1?Q?NZhUiG9OH2AE6Sq70fwxjuM86JJEQD8ryBaJbjI6QOWT3ZAcF6N/LtA65U?=
 =?iso-8859-1?Q?A05o53/mtMmL0CgHXi/fIPOLp+MmNE8l9+i1gxqRmWprAPJOKUWmLSlmCb?=
 =?iso-8859-1?Q?io7qRDwG0ULE6LqtUPv7Rp4MRbmdunGZ9PrSfIo8JAPoKdhhW9qiiXUhh5?=
 =?iso-8859-1?Q?GMqpVDZbcuwoNHVGrh1d6gouOyJ4zHDA3O0i8LvhmOUDsexdsnZ3/dz5AM?=
 =?iso-8859-1?Q?7+ZJR5X1KNlMRRmS1+nqe3tTfkWlZpQOvdDebw/JL/xWMDAfx8zb0b4yGT?=
 =?iso-8859-1?Q?JVJ5s70hjc3MqT4oNDSiHCe5Vtu2Fhj6oJpBBYT2JGPW0mllpPi/Jl2fUq?=
 =?iso-8859-1?Q?YNAtOgEGTC3yDW2P/IfJY9LjfUPCu3aIgJRc2nsKva7KGZzrTVscSedOOb?=
 =?iso-8859-1?Q?GWSdy+KUVFKQ9IjLukwnVX5P207ySjWySYgXjx39ClTyO5LixVUf+0+zwN?=
 =?iso-8859-1?Q?Pld8RUtm0O0RFTHzvri5BbCODb4X/eV3Er3ZIzTERpE4wyFJR2IJSF+vNH?=
 =?iso-8859-1?Q?PB5Q8MFIpjYJFHk+Saus03PR1Rrp/VxXg8dR9LbD1nfW0h0gXvI5crRp3E?=
 =?iso-8859-1?Q?nh4Lsi1kztPJwvadGbD3lapDTDz4ytuW8RaRCTmj975CGK/cXEZsPg6sB1?=
 =?iso-8859-1?Q?AJSkfFY/yMR7LyNKktlOVTIrq2PE4XYHp0P333JrqW/BIdslT/dO3h+e62?=
 =?iso-8859-1?Q?thDtM2Vr5/GHGOb5jgG851lVUGicyt38BMpnprgfi/eAPRQcNwiyEoVoE9?=
 =?iso-8859-1?Q?7Nh5sT0qyt8YJ/7ocscRXlg4Av0pqULsETSxofLORz6ly/NVBJXbPjgViZ?=
 =?iso-8859-1?Q?WbiZ9cFxTvEtoO8CF4Pay/87q4beA8rJeD4PVCNQImTh9pePlcVitTEYY8?=
 =?iso-8859-1?Q?T6x+sCJYGQjAtCmQLjvzcCtMShlbBuD4fyaXKS8Su6O9uZyevqDgV9UYWV?=
 =?iso-8859-1?Q?EbFDH2H+nExqDUux5eJiyesxUVVJQjPRzSKpPdOO+ugT1Onyg3V9pTZ4v0?=
 =?iso-8859-1?Q?LR05mE/9B4MyrQ07LfMJ4htLvLsffbTOZ3f9UYG8Lq6y19hWois0/JjNeq?=
 =?iso-8859-1?Q?Hn+d/mJRsRZ1zKSvg5gz57km6WCFOmclYilnynY0Ua1psBam3ekM+L5mNZ?=
 =?iso-8859-1?Q?JVE4v2P6mfs538YQF98/WnlBkSG7ot25onJIa8vtrUwfXnEyJl6kkJI/rN?=
 =?iso-8859-1?Q?0PGA0C8HVOjfTFlcxZbjeIrwlUuUiGGka4sMoyiE/s6x8IufSuODcx507X?=
 =?iso-8859-1?Q?aK/AEIFmJVcRy49efvRbk1lf0KYOs0wzy51kFalgLWcogcS9cXZsKOnwEo?=
 =?iso-8859-1?Q?bHx8AxFYcz65QdH8gIJRqgDqtjXe2I3golY+/Qis7vqlVRUBE1rGef2Rd3?=
 =?iso-8859-1?Q?D+cXp1WvEKPjkBoGLQ0LiEmKSkvm4G8RBQxq8uhUy/Qr7KmswCY7gSbl9T?=
 =?iso-8859-1?Q?La3oj6nRmbzQL/Mg8rjrB5a+Ub1R2A8IwZqy7SM6U1j6cIRr+KGrn6wF6I?=
 =?iso-8859-1?Q?f/BZ/X3V7mRQTD6VffhdN/hKCwo5+9an0b07yX33SIpWUyxNDeMQ21DJcO?=
 =?iso-8859-1?Q?s98w=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BJSPR01MB0561.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-Network-Message-Id: f45306b8-3f87-48b3-8064-08dc38432535
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2024 09:53:41.7578
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d/7C7diEDPW3asfBBQ7ne806nhTNz0bjcvMhsRT7AhSvS+sQlaF0FHcGc9uB26rFsc42AumBUQ9zhKmd7RE1HOuwf2N8pNRyr5VYN/AStX4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BJSPR01MB0738



> -----Original Message-----
> From: Zhao Liu <zhao1.liu@linux.intel.com>
> Sent: Tuesday, February 20, 2024 5:25 PM
> To: Daniel P . Berrang=E9 <berrange@redhat.com>; Eduardo Habkost <eduardo=
@habkost.net>; Marcel Apfelbaum
> <marcel.apfelbaum@gmail.com>; Philippe Mathieu-Daud=E9 <philmd@linaro.org=
>; Yanan Wang <wangyanan55@huawei.com>;
> Michael S . Tsirkin <mst@redhat.com>; Paolo Bonzini <pbonzini@redhat.com>=
; Richard Henderson <richard.henderson@linaro.org>;
> Eric Blake <eblake@redhat.com>; Markus Armbruster <armbru@redhat.com>; Ma=
rcelo Tosatti <mtosatti@redhat.com>; Alex Benn=E9e
> <alex.bennee@linaro.org>; Peter Maydell <peter.maydell@linaro.org>; Jonat=
han Cameron <Jonathan.Cameron@huawei.com>;
> JeeHeng Sia <jeeheng.sia@starfivetech.com>
> Cc: qemu-devel@nongnu.org; kvm@vger.kernel.org; qemu-riscv@nongnu.org; qe=
mu-arm@nongnu.org; Zhenyu Wang
> <zhenyu.z.wang@intel.com>; Dapeng Mi <dapeng1.mi@linux.intel.com>; Yongwe=
i Ma <yongwei.ma@intel.com>; Zhao Liu
> <zhao1.liu@intel.com>
> Subject: [RFC 2/8] hw/core: Move CPU topology enumeration into arch-agnos=
tic file
>=20
> From: Zhao Liu <zhao1.liu@intel.com>
>=20
> Cache topology needs to be defined based on CPU topology levels. Thus,
> move CPU topology enumeration into a common header.
>=20
> To match the general topology naming style, rename CPU_TOPO_LEVEL_SMT
> and CPU_TOPO_LEVEL_PACKAGE to CPU_TOPO_LEVEL_THREAD and
> CPU_TOPO_LEVEL_SOCKET.
>=20
> Also, enumerate additional topology levels for non-i386 arches, and add
> helpers for topology enumeration and string conversion.
>=20
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
>  MAINTAINERS                    |  2 ++
>  hw/core/cpu-topology.c         | 56 ++++++++++++++++++++++++++++++++++
>  hw/core/meson.build            |  1 +
>  include/hw/core/cpu-topology.h | 40 ++++++++++++++++++++++++
>  include/hw/i386/topology.h     | 18 +----------
>  target/i386/cpu.c              | 24 +++++++--------
>  target/i386/cpu.h              |  2 +-
>  tests/unit/meson.build         |  3 +-
>  8 files changed, 115 insertions(+), 31 deletions(-)
>  create mode 100644 hw/core/cpu-topology.c
>  create mode 100644 include/hw/core/cpu-topology.h
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7d61fb93194b..4b1cce938915 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1871,6 +1871,7 @@ R: Yanan Wang <wangyanan55@huawei.com>
>  S: Supported
>  F: hw/core/cpu-common.c
>  F: hw/core/cpu-sysemu.c
> +F: hw/core/cpu-topology.c
>  F: hw/core/machine-qmp-cmds.c
>  F: hw/core/machine.c
>  F: hw/core/machine-smp.c
> @@ -1882,6 +1883,7 @@ F: qapi/machine-common.json
>  F: qapi/machine-target.json
>  F: include/hw/boards.h
>  F: include/hw/core/cpu.h
> +F: include/hw/core/cpu-topology.h
>  F: include/hw/cpu/cluster.h
>  F: include/sysemu/numa.h
>  F: tests/unit/test-smp-parse.c
> diff --git a/hw/core/cpu-topology.c b/hw/core/cpu-topology.c
> new file mode 100644
> index 000000000000..ca1361d13c16
> --- /dev/null
> +++ b/hw/core/cpu-topology.c
> @@ -0,0 +1,56 @@
> +/*
> + * QEMU CPU Topology Representation
> + *
> + * Copyright (c) 2024 Intel Corporation
> + * Author: Zhao Liu <zhao1.liu@intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License,
> + * or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include "qemu/osdep.h"
> +#include "hw/core/cpu-topology.h"
> +
> +typedef struct CPUTopoInfo {
> +    const char *name;
> +} CPUTopoInfo;
> +
> +CPUTopoInfo cpu_topo_descriptors[] =3D {
> +    [CPU_TOPO_LEVEL_INVALID] =3D { .name =3D "invalid", },
> +    [CPU_TOPO_LEVEL_THREAD]  =3D { .name =3D "thread",  },
> +    [CPU_TOPO_LEVEL_CORE]    =3D { .name =3D "core",    },
> +    [CPU_TOPO_LEVEL_MODULE]  =3D { .name =3D "module",  },
> +    [CPU_TOPO_LEVEL_CLUSTER] =3D { .name =3D "cluster", },
> +    [CPU_TOPO_LEVEL_DIE]     =3D { .name =3D "die",     },
> +    [CPU_TOPO_LEVEL_SOCKET]  =3D { .name =3D "socket",  },
> +    [CPU_TOPO_LEVEL_BOOK]    =3D { .name =3D "book",    },
> +    [CPU_TOPO_LEVEL_DRAWER]  =3D { .name =3D "drawer",  },
> +    [CPU_TOPO_LEVEL_MAX]     =3D { .name =3D NULL,      },
> +};
> +
> +const char *cpu_topo_to_string(CPUTopoLevel topo)
> +{
> +    return cpu_topo_descriptors[topo].name;
> +}
> +
> +CPUTopoLevel string_to_cpu_topo(char *str)
Can use const char *str.
> +{
> +    for (int i =3D 0; i < ARRAY_SIZE(cpu_topo_descriptors); i++) {
> +        CPUTopoInfo *info =3D &cpu_topo_descriptors[i];
> +
> +        if (!strcmp(info->name, str)) {
Suggest to use strncmp instead.
> +            return (CPUTopoLevel)i;
> +        }
> +    }
> +    return CPU_TOPO_LEVEL_MAX;
> +}
> diff --git a/hw/core/meson.build b/hw/core/meson.build
> index 67dad04de559..3b1d5ffab3e3 100644
> --- a/hw/core/meson.build
> +++ b/hw/core/meson.build
> @@ -23,6 +23,7 @@ else
>  endif
>=20
>  common_ss.add(files('cpu-common.c'))
> +common_ss.add(files('cpu-topology.c'))
>  common_ss.add(files('machine-smp.c'))
>  system_ss.add(when: 'CONFIG_FITLOADER', if_true: files('loader-fit.c'))
>  system_ss.add(when: 'CONFIG_GENERIC_LOADER', if_true: files('generic-loa=
der.c'))
> diff --git a/include/hw/core/cpu-topology.h b/include/hw/core/cpu-topolog=
y.h
> new file mode 100644
> index 000000000000..cc6ca186ce3f
> --- /dev/null
> +++ b/include/hw/core/cpu-topology.h
> @@ -0,0 +1,40 @@
> +/*
> + * QEMU CPU Topology Representation Header
> + *
> + * Copyright (c) 2024 Intel Corporation
> + * Author: Zhao Liu <zhao1.liu@intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License,
> + * or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifndef CPU_TOPOLOGY_H
> +#define CPU_TOPOLOGY_H
> +
> +typedef enum CPUTopoLevel {
> +    CPU_TOPO_LEVEL_INVALID,
> +    CPU_TOPO_LEVEL_THREAD,
> +    CPU_TOPO_LEVEL_CORE,
> +    CPU_TOPO_LEVEL_MODULE,
> +    CPU_TOPO_LEVEL_CLUSTER,
> +    CPU_TOPO_LEVEL_DIE,
> +    CPU_TOPO_LEVEL_SOCKET,
> +    CPU_TOPO_LEVEL_BOOK,
> +    CPU_TOPO_LEVEL_DRAWER,
> +    CPU_TOPO_LEVEL_MAX,
> +} CPUTopoLevel;
> +
> +const char *cpu_topo_to_string(CPUTopoLevel topo);
> +CPUTopoLevel string_to_cpu_topo(char *str);
> +
> +#endif /* CPU_TOPOLOGY_H */
> diff --git a/include/hw/i386/topology.h b/include/hw/i386/topology.h
> index dff49fce1154..c6ff75f23991 100644
> --- a/include/hw/i386/topology.h
> +++ b/include/hw/i386/topology.h
> @@ -39,7 +39,7 @@
>   *  CPUID Fn8000_0008_ECX[ApicIdCoreIdSize[3:0]] is set to apicid_core_w=
idth().
>   */
>=20
> -
> +#include "hw/core/cpu-topology.h"
>  #include "qemu/bitops.h"
>=20
>  /*
> @@ -62,22 +62,6 @@ typedef struct X86CPUTopoInfo {
>      unsigned threads_per_core;
>  } X86CPUTopoInfo;
>=20
> -/*
> - * CPUTopoLevel is the general i386 topology hierarchical representation=
,
> - * ordered by increasing hierarchical relationship.
> - * Its enumeration value is not bound to the type value of Intel (CPUID[=
0x1F])
> - * or AMD (CPUID[0x80000026]).
> - */
> -enum CPUTopoLevel {
> -    CPU_TOPO_LEVEL_INVALID,
> -    CPU_TOPO_LEVEL_SMT,
> -    CPU_TOPO_LEVEL_CORE,
> -    CPU_TOPO_LEVEL_MODULE,
> -    CPU_TOPO_LEVEL_DIE,
> -    CPU_TOPO_LEVEL_PACKAGE,
> -    CPU_TOPO_LEVEL_MAX,
> -};
> -
>  /* Return the bit width needed for 'count' IDs */
>  static unsigned apicid_bitwidth_for_count(unsigned count)
>  {
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index ac0a10abd45f..725d7e70182d 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -247,7 +247,7 @@ static uint32_t max_thread_ids_for_cache(X86CPUTopoIn=
fo *topo_info,
>      case CPU_TOPO_LEVEL_DIE:
>          num_ids =3D 1 << apicid_die_offset(topo_info);
>          break;
> -    case CPU_TOPO_LEVEL_PACKAGE:
> +    case CPU_TOPO_LEVEL_SOCKET:
>          num_ids =3D 1 << apicid_pkg_offset(topo_info);
>          break;
>      default:
> @@ -304,7 +304,7 @@ static uint32_t num_threads_by_topo_level(X86CPUTopoI=
nfo *topo_info,
>                                            enum CPUTopoLevel topo_level)
>  {
>      switch (topo_level) {
> -    case CPU_TOPO_LEVEL_SMT:
> +    case CPU_TOPO_LEVEL_THREAD:
>          return 1;
Just wondering why 'return 1' is used directly for the thread, but not
for the rest?
>      case CPU_TOPO_LEVEL_CORE:
>          return topo_info->threads_per_core;
> @@ -313,7 +313,7 @@ static uint32_t num_threads_by_topo_level(X86CPUTopoI=
nfo *topo_info,
>      case CPU_TOPO_LEVEL_DIE:
>          return topo_info->threads_per_core * topo_info->cores_per_module=
 *
>                 topo_info->modules_per_die;
> -    case CPU_TOPO_LEVEL_PACKAGE:
> +    case CPU_TOPO_LEVEL_SOCKET:
>          return topo_info->threads_per_core * topo_info->cores_per_module=
 *
>                 topo_info->modules_per_die * topo_info->dies_per_pkg;
>      default:
> @@ -326,7 +326,7 @@ static uint32_t apicid_offset_by_topo_level(X86CPUTop=
oInfo *topo_info,
>                                              enum CPUTopoLevel topo_level=
)
>  {
>      switch (topo_level) {
> -    case CPU_TOPO_LEVEL_SMT:
> +    case CPU_TOPO_LEVEL_THREAD:
>          return 0;
>      case CPU_TOPO_LEVEL_CORE:
>          return apicid_core_offset(topo_info);
> @@ -334,7 +334,7 @@ static uint32_t apicid_offset_by_topo_level(X86CPUTop=
oInfo *topo_info,
>          return apicid_module_offset(topo_info);
>      case CPU_TOPO_LEVEL_DIE:
>          return apicid_die_offset(topo_info);
> -    case CPU_TOPO_LEVEL_PACKAGE:
> +    case CPU_TOPO_LEVEL_SOCKET:
>          return apicid_pkg_offset(topo_info);
>      default:
>          g_assert_not_reached();
> @@ -347,7 +347,7 @@ static uint32_t cpuid1f_topo_type(enum CPUTopoLevel t=
opo_level)
>      switch (topo_level) {
>      case CPU_TOPO_LEVEL_INVALID:
>          return CPUID_1F_ECX_TOPO_LEVEL_INVALID;
> -    case CPU_TOPO_LEVEL_SMT:
> +    case CPU_TOPO_LEVEL_THREAD:
>          return CPUID_1F_ECX_TOPO_LEVEL_SMT;
>      case CPU_TOPO_LEVEL_CORE:
>          return CPUID_1F_ECX_TOPO_LEVEL_CORE;
> @@ -380,7 +380,7 @@ static void encode_topo_cpuid1f(CPUX86State *env, uin=
t32_t count,
>      level =3D CPU_TOPO_LEVEL_INVALID;
>      for (int i =3D 0; i <=3D count; i++) {
>          level =3D find_next_bit(env->avail_cpu_topo,
> -                              CPU_TOPO_LEVEL_PACKAGE,
> +                              CPU_TOPO_LEVEL_SOCKET,
>                                level + 1);
>=20
>          /*
> @@ -388,7 +388,7 @@ static void encode_topo_cpuid1f(CPUX86State *env, uin=
t32_t count,
>           * and it just encode the invalid level (all fields are 0)
>           * into the last subleaf of 0x1f.
>           */
> -        if (level =3D=3D CPU_TOPO_LEVEL_PACKAGE) {
> +        if (level =3D=3D CPU_TOPO_LEVEL_SOCKET) {
>              level =3D CPU_TOPO_LEVEL_INVALID;
>              break;
>          }
> @@ -401,7 +401,7 @@ static void encode_topo_cpuid1f(CPUX86State *env, uin=
t32_t count,
>          unsigned long next_level;
>=20
>          next_level =3D find_next_bit(env->avail_cpu_topo,
> -                                   CPU_TOPO_LEVEL_PACKAGE,
> +                                   CPU_TOPO_LEVEL_SOCKET,
>                                     level + 1);
>          num_threads_next_level =3D num_threads_by_topo_level(topo_info,
>                                                             next_level);
> @@ -6290,7 +6290,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index=
, uint32_t count,
>=20
>                      /* Share the cache at package level. */
>                      *eax |=3D max_thread_ids_for_cache(&topo_info,
> -                                CPU_TOPO_LEVEL_PACKAGE) << 14;
> +                                CPU_TOPO_LEVEL_SOCKET) << 14;
>                  }
>              }
>          } else if (cpu->vendor_cpuid_only && IS_AMD_CPU(env)) {
> @@ -7756,9 +7756,9 @@ static void x86_cpu_init_default_topo(X86CPU *cpu)
>      env->nr_dies =3D 1;
>=20
>      /* SMT, core and package levels are set by default. */
> -    set_bit(CPU_TOPO_LEVEL_SMT, env->avail_cpu_topo);
> +    set_bit(CPU_TOPO_LEVEL_THREAD, env->avail_cpu_topo);
>      set_bit(CPU_TOPO_LEVEL_CORE, env->avail_cpu_topo);
> -    set_bit(CPU_TOPO_LEVEL_PACKAGE, env->avail_cpu_topo);
> +    set_bit(CPU_TOPO_LEVEL_SOCKET, env->avail_cpu_topo);
>  }
>=20
>  static void x86_cpu_initfn(Object *obj)
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 4b4cc70c8859..fcbf278b49e6 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -1596,7 +1596,7 @@ typedef struct CPUCacheInfo {
>       * Used to encode CPUID[4].EAX[bits 25:14] or
>       * CPUID[0x8000001D].EAX[bits 25:14].
>       */
> -    enum CPUTopoLevel share_level;
> +    CPUTopoLevel share_level;
>  } CPUCacheInfo;
>=20
>=20
> diff --git a/tests/unit/meson.build b/tests/unit/meson.build
> index cae925c13259..4fe0aaff3a5e 100644
> --- a/tests/unit/meson.build
> +++ b/tests/unit/meson.build
> @@ -138,7 +138,8 @@ if have_system
>      'test-util-sockets': ['socket-helpers.c'],
>      'test-base64': [],
>      'test-bufferiszero': [],
> -    'test-smp-parse': [qom, meson.project_source_root() / 'hw/core/machi=
ne-smp.c'],
> +    'test-smp-parse': [qom, meson.project_source_root() / 'hw/core/machi=
ne-smp.c',
> +                       meson.project_source_root() / 'hw/core/cpu-topolo=
gy.c'],
>      'test-vmstate': [migration, io],
>      'test-yank': ['socket-helpers.c', qom, io, chardev]
>    }
> --
> 2.34.1


