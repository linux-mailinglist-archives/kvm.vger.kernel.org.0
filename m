Return-Path: <kvm+bounces-10208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 20A4386A814
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 06:38:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9C6291F244E6
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 05:38:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB41221344;
	Wed, 28 Feb 2024 05:38:42 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2119.outbound.protection.partner.outlook.cn [139.219.17.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F571D6AA
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 05:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.17.119
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709098722; cv=fail; b=bhPjy/fO+eXgPk3tXDihXXXQ83wV/BywWdcOhUSgP6VnugwCS3sMKU0EYitymQM0L/IhIxtEDYuDBU615ySe0mxxq2ZBxxvhmxjPaZ0ghh+R0knSP73QG2sb8MTxgKMeilkO8pAI60cySizaTNhDPWtzxG/vAaHT4t/YEPCzrZM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709098722; c=relaxed/simple;
	bh=Rb0qj8dwXIZdQpqiboU7cxJMecfZjU5LxtQ7xIxMIOE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Dh4OujH0ZrmWNJlCdM4rnFjDpDdE062kU5JfVgeBYbe2T5R2kg/Wh61OQP12qmHkhgSxiGeIbyGDl2UM3RA5ol/N6ANRMCwAJ0WB2NcqXojYqoGIH7Vwu00PMRqmzsOeEBjCTOcwavdMEO1mfLEBnnkVjv4C/0KNvMj0WLjypA4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.17.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tj1DXh7P6xnCyu2pN9PSvb7azskVEAtKHLHOoNDs6garnoTwUjljCWjj1QqAuDyvfEqdhC2GqM//u/xdvCcSt3Rk/D70D35DtMRdHqxK1kwLXt+6bdNMz1Jdg7JgbVD+bHhXD6jwdJWpgZT/e2XHlZANm/Ms85lmjNBtWcQ5r1636j2CCCmPYrjA8B0ZNgyRIeS76A+CJyRcbtS1WMIxfP0jLBqcZksS04fn2w4n0W7Pn87tp69+0tbFcK3iZRD9WduwEB3OowTnJ7uLAkM42m8RsMu1LI2i7NYh1O231+XDln3qHgzRN7SxQ3n3FTPsDMmyw08Bo2WwZWucQ8vo7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=331EN18HP6VLDxxJfGhy5X7zvzfJ0YCmP2yi+OnRANQ=;
 b=G3718lqXylUCK2Vx4JYR5Tk9E4EmYS7SnX5yeJ7yLcVK9eXFhQ9LuOEgEEavLsZjmVBdOD17uylz4Zwb/woU24YK1fHaPRIc5SBliohYJmjzmgVsSXflrIcuTT7giJsuCTH69U+ivHLsBbB2NNt/B9KOTcfQaULY60EoMWulwGUjVaIYBfJ4od0fMK+hTTKxBe2KJq3p4BpEcSPZlS3gjgLBz4NlKbh3dzbbq5dBv8cH558zfHCx9K/TS1iev5WqgotLG7LR4ubn2eUUc7h+NLg/5pwFqQv2rPet+zSRY3I2sg2e9daYS9jm5MY9iZHKRqeJURP47XTZp6RrHCK5Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Received: from BJSPR01MB0561.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c211:f::16) by BJSPR01MB0660.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c211:1f::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.45; Wed, 28 Feb
 2024 05:38:32 +0000
Received: from BJSPR01MB0561.CHNPR01.prod.partner.outlook.cn
 ([fe80::fcfa:931b:8b1d:6af5]) by
 BJSPR01MB0561.CHNPR01.prod.partner.outlook.cn ([fe80::fcfa:931b:8b1d:6af5%4])
 with mapi id 15.20.7316.037; Wed, 28 Feb 2024 05:38:33 +0000
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
Subject: RE: [RFC 4/8] hw/core: Add cache topology options in -smp
Thread-Topic: [RFC 4/8] hw/core: Add cache topology options in -smp
Thread-Index: AQHaY9zhac1dKVm9KUeTp1HqzZbrarEfSC7g
Date: Wed, 28 Feb 2024 05:38:33 +0000
Message-ID:
 <BJSPR01MB05618A7D409C2DE3E408345C9C58A@BJSPR01MB0561.CHNPR01.prod.partner.outlook.cn>
References: <20240220092504.726064-1-zhao1.liu@linux.intel.com>
 <20240220092504.726064-5-zhao1.liu@linux.intel.com>
In-Reply-To: <20240220092504.726064-5-zhao1.liu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BJSPR01MB0561:EE_|BJSPR01MB0660:EE_
x-ms-office365-filtering-correlation-id: ef73f824-358b-461e-f815-08dc381f8082
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 4OHnog0gJpMs5X7qooXax/QOlFy900m9uQ/KbdET1l5gSKChPfYUMwoAorVlaDANSHgcG+KYBoicIu1+yUdhYuJnJBJsndzpF0E/bk6rNyeJEnGUYEQVNslHOXierOZGeFZvvtxswXoAbtz1iYY8si3XGyaPBUXybDNINGaJLfls1d5czt6/08xWX2tYxObGbNZ3a7y1qlQYrxC/1UzjdMggUH6xSeT3otrPbVOWji9awpN7oTlVPvcHzqGTxFapnj/v7fLXScw3/ZLUZSiHwKCKHjUH1ALc0y6OT7OLIfu2n9A1VdXLrWoYyl8JNrOGyDsCe+tnkwI8vh+2CEGh0C44J10h200tGjgGHXv2qVt8N2ClccgeZJyap4OfcoBLNFiXKhoGmztz91swnLv4VT+F8Z+utdbRn4tl3xuuEzJCFbzAE1rG67AFbqhDfrzmxvSpT+Rjlx27dC9eAWCAo2jisQTT9iQzJa+Xj8kLTSn9UMMGSuZ3SSRaOPWm/ZYvB6a/2DyYH+WTVEBg1EmAuvWtYA6WTFzCew5cWUSfV923yYZP5vN/hQq0tYx5STxVUmMWs7RzdAPfQ1bOivMscXtR0zkkomOszD8K3fAiETWJacReHIQKj8NiQAah66KBuqSRZlJIkpo5C4ahTjc3gA==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BJSPR01MB0561.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230031)(38070700009)(921011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?wgns+GdTjLvBmhQwaj224Za7m//rAdioTwDhXGCvJKOv36mNhckcFneCwr?=
 =?iso-8859-1?Q?fdMVDc+XggLWHxPqZMlt/MdP0SOd2V7j0RM0rN76UkwxlETo2pkgLbaL6i?=
 =?iso-8859-1?Q?HnN+qBmHQxw8QdQ3LIuR/Y2Uy6Pg5eXwOfSKiBaDt61tUKS3zXvE1AKFBb?=
 =?iso-8859-1?Q?StXFLvbcNZzeYutJ8dkYm5tX7qCmw2m5IBG2wlmmL3nxAF8FEOdJNUawfO?=
 =?iso-8859-1?Q?nT5yalhnGSvEtz2iYozZ6UPCefhjZQZ9fAoGFgh3NZveOtDIMewlYs8XNG?=
 =?iso-8859-1?Q?buqql8msqGFvXh7CVmwY+G8FTGrbmUu2l6+cP0xgLx7MIJvopAgszSa+EI?=
 =?iso-8859-1?Q?Y8tlei07V4nAo56Oap7ubgNg7/t9dHcUC4jWBn5XObw4RlV4/bg9gb3Rew?=
 =?iso-8859-1?Q?xOsjPcmigiMe8KQDF7L4zOI8NW5r4vLPdc9IBFpMEIGZnYnVoDLEKymDVW?=
 =?iso-8859-1?Q?fCaWIworJsX78vnP/2jV1Ujs/ST6hI5aemokQTTlaKz+KOSNnRbfz92XiO?=
 =?iso-8859-1?Q?YFY1in1MkXoVbG4CsCm+PwTB73zE5vYHr0xDYeXmV6aSoBNvH1+hez4RTD?=
 =?iso-8859-1?Q?1wLn0hMS8brlHwHReWWI48uceFds4JfBCZSh/8U4lVEt/HmPcRs0PljEzK?=
 =?iso-8859-1?Q?0CwEZNKvz+HTPClShZgl9sDz/C44TmpBuZymFijr98to+zQceRpZbthwlJ?=
 =?iso-8859-1?Q?xhOvEZUHXBQ6aGmdkmHFZjylZaE3b9sljrDI80qyVNto8YcXTqWs3+45n5?=
 =?iso-8859-1?Q?XEAYkZ/cGUBnNjNOpM8doGrR58SYpz00Zefjwqb3vionH+PQq10pro5Idz?=
 =?iso-8859-1?Q?cEfMsBAmWoSOvyeO93vsXS3We9txmv9H5LZ060lLDoRjUIy4AGGeySjj5A?=
 =?iso-8859-1?Q?4+Lg65nqybkFZYogRMPuJGvX1awHuGl0B/JeNrjpqouDARJ9enZRuvi9i4?=
 =?iso-8859-1?Q?qATDssgAeo6zjTpGCai2UvJjY0VAEfsIqjx9dbUVFZIK/Z9wsS9GUuGKQQ?=
 =?iso-8859-1?Q?utgB0jR02MtPvKm1rTJDxFxvoI98nR+Fii0w5cogB/qppR2d5hAYjz4VVL?=
 =?iso-8859-1?Q?qxKgrxutcgSA6pvWmJviiuceWwX/T0ElQ2WhQUA2d2ZmV78xaDCd29LEEp?=
 =?iso-8859-1?Q?/NzXIYmhO+yEfu643mCbc1B+0ruIIpaez+xH43uHaBRcpH3HebAJWpcPqS?=
 =?iso-8859-1?Q?Xq4ks8dQRBV0algy85YMybcKdfpYeuCGAK4vLQyYaYLbVVmrkxwc8ovwWf?=
 =?iso-8859-1?Q?67vjwKY7Xh+P3CLm1mwpLHBP/JwGngRxQdisRSYtfQoDg2ohkkexteOAgj?=
 =?iso-8859-1?Q?eBmb2gePjS5QfC0d/cZqIcwRENWpmJDkTCTSjOuT5usd0Z0ojvmcXbCXxl?=
 =?iso-8859-1?Q?FPm/iLExBZNNSzOwA/o//x/cvDGwcpJVKRaakJlsa34N4Y0CE83NEs6puC?=
 =?iso-8859-1?Q?7Nhxo1cKZsCXdF02KCs0HAgdDsXxldMN/SMwWS/CdzjazeJbbYGgkJD5uL?=
 =?iso-8859-1?Q?wIm8bfs1Y2ZHVVMM47BdvdteX4cyYsCW6sjf0ggYY/5SypeBC8zHkWrfrc?=
 =?iso-8859-1?Q?ipuCFMP5YcJcIfKu9xkb1KCvXb8eqdT9e/bh0yrC6QY426VkskYq0HqJPJ?=
 =?iso-8859-1?Q?h47BBP00Sm4SLPUgiT4jL/z5vApDuDwfcHgQA29z7XrC4Ifwy/YhJrTQ?=
 =?iso-8859-1?Q?=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ef73f824-358b-461e-f815-08dc381f8082
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2024 05:38:33.0515
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9LJKKtIeHJBuRWnhtyG3Zc4nyvm0UypDZpz8A11nCOEYRS5pVeFwjpRC4EVLZyA624TaL6MBP36VR+wRjHFrdh9F+MV1B50lgLL68wMijTQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BJSPR01MB0660



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
> Subject: [RFC 4/8] hw/core: Add cache topology options in -smp
>=20
> From: Zhao Liu <zhao1.liu@intel.com>
>=20
> Add "l1d-cache", "l1i-cache". "l2-cache", and "l3-cache" options in
> -smp to define the cache topology for SMP system.
>=20
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
>  hw/core/machine-smp.c | 128 ++++++++++++++++++++++++++++++++++++++++++
>  hw/core/machine.c     |   4 ++
>  qapi/machine.json     |  14 ++++-
>  system/vl.c           |  15 +++++
>  4 files changed, 160 insertions(+), 1 deletion(-)
>=20
> diff --git a/hw/core/machine-smp.c b/hw/core/machine-smp.c
> index 8a8296b0d05b..2cbd19f4aa57 100644
> --- a/hw/core/machine-smp.c
> +++ b/hw/core/machine-smp.c
> @@ -61,6 +61,132 @@ static char *cpu_hierarchy_to_string(MachineState *ms=
)
>      return g_string_free(s, false);
>  }
>=20
> +static bool machine_check_topo_support(MachineState *ms,
> +                                       CPUTopoLevel topo)
> +{
> +    MachineClass *mc =3D MACHINE_GET_CLASS(ms);
> +
> +    if (topo =3D=3D CPU_TOPO_LEVEL_MODULE && !mc->smp_props.modules_supp=
orted) {
> +        return false;
> +    }
> +
> +    if (topo =3D=3D CPU_TOPO_LEVEL_CLUSTER && !mc->smp_props.clusters_su=
pported) {
> +        return false;
> +    }
> +
> +    if (topo =3D=3D CPU_TOPO_LEVEL_DIE && !mc->smp_props.dies_supported)=
 {
> +        return false;
> +    }
> +
> +    if (topo =3D=3D CPU_TOPO_LEVEL_BOOK && !mc->smp_props.books_supporte=
d) {
> +        return false;
> +    }
> +
> +    if (topo =3D=3D CPU_TOPO_LEVEL_DRAWER && !mc->smp_props.drawers_supp=
orted) {
> +        return false;
> +    }
> +
> +    return true;
> +}
> +
> +static int smp_cache_string_to_topology(MachineState *ms,
> +                                        char *topo_str,
> +                                        CPUTopoLevel *topo,
> +                                        Error **errp)
> +{
> +    *topo =3D string_to_cpu_topo(topo_str);
> +
> +    if (*topo =3D=3D CPU_TOPO_LEVEL_MAX || *topo =3D=3D CPU_TOPO_LEVEL_I=
NVALID) {
> +        error_setg(errp, "Invalid cache topology level: %s. The cache "
> +                   "topology should match the CPU topology level", topo_=
str);
> +        return -1;
> +    }
> +
> +    if (!machine_check_topo_support(ms, *topo)) {
> +        error_setg(errp, "Invalid cache topology level: %s. The topology=
 "
> +                   "level is not supported by this machine", topo_str);
> +        return -1;
> +    }
> +
> +    return 0;
> +}
> +
> +static void machine_parse_smp_cache_config(MachineState *ms,
> +                                           const SMPConfiguration *confi=
g,
> +                                           Error **errp)
> +{
> +    MachineClass *mc =3D MACHINE_GET_CLASS(ms);
> +
> +    if (config->l1d_cache) {
> +        if (!mc->smp_props.l1_separated_cache_supported) {
> +            error_setg(errp, "L1 D-cache topology not "
> +                       "supported by this machine");
> +            return;
> +        }
> +
> +        if (smp_cache_string_to_topology(ms, config->l1d_cache,
> +            &ms->smp_cache.l1d, errp)) {
> +            return;
> +        }
> +    }
> +
> +    if (config->l1i_cache) {
> +        if (!mc->smp_props.l1_separated_cache_supported) {
> +            error_setg(errp, "L1 I-cache topology not "
> +                       "supported by this machine");
> +            return;
> +        }
> +
> +        if (smp_cache_string_to_topology(ms, config->l1i_cache,
> +            &ms->smp_cache.l1i, errp)) {
> +            return;
> +        }
> +    }
> +
> +    if (config->l2_cache) {
> +        if (!mc->smp_props.l2_unified_cache_supported) {
> +            error_setg(errp, "L2 cache topology not "
> +                       "supported by this machine");
> +            return;
> +        }
> +
> +        if (smp_cache_string_to_topology(ms, config->l2_cache,
> +            &ms->smp_cache.l2, errp)) {
> +            return;
> +        }
> +
> +        if (ms->smp_cache.l1d > ms->smp_cache.l2 ||
> +            ms->smp_cache.l1i > ms->smp_cache.l2) {
> +            error_setg(errp, "Invalid L2 cache topology. "
> +                       "L2 cache topology level should not be "
> +                       "lower than L1 D-cache/L1 I-cache");
> +            return;
> +        }
> +    }
> +
> +    if (config->l3_cache) {
> +        if (!mc->smp_props.l2_unified_cache_supported) {
> +            error_setg(errp, "L3 cache topology not "
> +                       "supported by this machine");
> +            return;
> +        }
> +
> +        if (smp_cache_string_to_topology(ms, config->l3_cache,
> +            &ms->smp_cache.l3, errp)) {
> +            return;
> +        }
> +
> +        if (ms->smp_cache.l1d > ms->smp_cache.l3 ||
> +            ms->smp_cache.l1i > ms->smp_cache.l3 ||
> +            ms->smp_cache.l2 > ms->smp_cache.l3) {
> +            error_setg(errp, "Invalid L3 cache topology. "
> +                       "L3 cache topology level should not be "
> +                       "lower than L1 D-cache/L1 I-cache/L2 cache");
> +            return;
> +        }
> +    }
> +}
> +
>  /*
>   * machine_parse_smp_config: Generic function used to parse the given
>   *                           SMP configuration
> @@ -249,6 +375,8 @@ void machine_parse_smp_config(MachineState *ms,
>                     mc->name, mc->max_cpus);
>          return;
>      }
> +
> +    machine_parse_smp_cache_config(ms, config, errp);
>  }
>=20
>  unsigned int machine_topo_get_cores_per_socket(const MachineState *ms)
> diff --git a/hw/core/machine.c b/hw/core/machine.c
> index 426f71770a84..cb5173927b0d 100644
> --- a/hw/core/machine.c
> +++ b/hw/core/machine.c
> @@ -886,6 +886,10 @@ static void machine_get_smp(Object *obj, Visitor *v,=
 const char *name,
>          .has_cores =3D true, .cores =3D ms->smp.cores,
>          .has_threads =3D true, .threads =3D ms->smp.threads,
>          .has_maxcpus =3D true, .maxcpus =3D ms->smp.max_cpus,
> +        .l1d_cache =3D g_strdup(cpu_topo_to_string(ms->smp_cache.l1d)),
> +        .l1i_cache =3D g_strdup(cpu_topo_to_string(ms->smp_cache.l1i)),
> +        .l2_cache =3D g_strdup(cpu_topo_to_string(ms->smp_cache.l2)),
> +        .l3_cache =3D g_strdup(cpu_topo_to_string(ms->smp_cache.l3)),
Let's standardize the code by adding the 'has_' prefix.
>      };
>=20
>      if (!visit_type_SMPConfiguration(v, name, &config, &error_abort)) {
> diff --git a/qapi/machine.json b/qapi/machine.json
> index d0e7f1f615f3..0a923ac38803 100644
> --- a/qapi/machine.json
> +++ b/qapi/machine.json
> @@ -1650,6 +1650,14 @@
>  #
>  # @threads: number of threads per core
>  #
> +# @l1d-cache: topology hierarchy of L1 data cache (since 9.0)
> +#
> +# @l1i-cache: topology hierarchy of L1 instruction cache (since 9.0)
> +#
> +# @l2-cache: topology hierarchy of L2 unified cache (since 9.0)
> +#
> +# @l3-cache: topology hierarchy of L3 unified cache (since 9.0)
> +#
>  # Since: 6.1
>  ##
>  { 'struct': 'SMPConfiguration', 'data': {
> @@ -1662,7 +1670,11 @@
>       '*modules': 'int',
>       '*cores': 'int',
>       '*threads': 'int',
> -     '*maxcpus': 'int' } }
> +     '*maxcpus': 'int',
> +     '*l1d-cache': 'str',
> +     '*l1i-cache': 'str',
> +     '*l2-cache': 'str',
> +     '*l3-cache': 'str' } }
>=20
>  ##
>  # @x-query-irq:
> diff --git a/system/vl.c b/system/vl.c
> index a82555ae1558..ac95e5ddb656 100644
> --- a/system/vl.c
> +++ b/system/vl.c
> @@ -741,6 +741,9 @@ static QemuOptsList qemu_smp_opts =3D {
>          }, {
>              .name =3D "clusters",
>              .type =3D QEMU_OPT_NUMBER,
> +        }, {
> +            .name =3D "modules",
> +            .type =3D QEMU_OPT_NUMBER,
>          }, {
>              .name =3D "cores",
>              .type =3D QEMU_OPT_NUMBER,
> @@ -750,6 +753,18 @@ static QemuOptsList qemu_smp_opts =3D {
>          }, {
>              .name =3D "maxcpus",
>              .type =3D QEMU_OPT_NUMBER,
> +        }, {
> +            .name =3D "l1d-cache",
> +            .type =3D QEMU_OPT_STRING,
> +        }, {
> +            .name =3D "l1i-cache",
> +            .type =3D QEMU_OPT_STRING,
> +        }, {
> +            .name =3D "l2-cache",
> +            .type =3D QEMU_OPT_STRING,
> +        }, {
> +            .name =3D "l3-cache",
> +            .type =3D QEMU_OPT_STRING,
>          },
>          { /*End of list */ }
>      },
> --
> 2.34.1


