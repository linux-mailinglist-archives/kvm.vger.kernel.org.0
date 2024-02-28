Return-Path: <kvm+bounces-10215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F02C86AB93
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 10:46:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2ED4B1C241DA
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 09:46:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90106381CB;
	Wed, 28 Feb 2024 09:46:07 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from CHN02-SH0-obe.outbound.protection.partner.outlook.cn (mail-sh0chn02on2124.outbound.protection.partner.outlook.cn [139.219.146.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39163771C
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 09:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.146.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709113567; cv=fail; b=upawzodNtf15OGkvIWSWaNIkm9BWyicywsiuS01VxvkTSFEAewNvRii4rc2QqYI/7ZakzePGV1TT2AxJRSy1jwz3j5KnN/bgzXydyYPhu134+6zDF7xkS7S9jNF577fFfjWcqs3LGxRfeTB2ANvs2HPM/RbK31KiPVAWq+B1zPo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709113567; c=relaxed/simple;
	bh=Tn6JjWb/p1TsX19eEIbjwCQCtn43QDrjAZXr/3AXASs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gp6upC/8yN75Pw3CYvnNGLzXOve/wkGAqxgGhGRPRYrFcn5KFUspOrezk6izAIuuiCUBDXLqioLbpL8BAd4ICGFMgo1DClNaqAEgLw1+QWDrueHAABamLgvJz3bE3z7x1WjllcVeNz0jZoh4j3+G2nGCwLGr5BaD9IFVI0d0mC8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.146.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FDwMTTR+hK1Buevuan0K2MgVU63rooQC3+upUuhKycXnjsLWDxIJxjKjdGJ61XL9mbHybnLXyeOEAMlmK/sKo9UMed79b00KSZwX/Cjif3Nxy6BOiYqxaG7saR286mdcd4UGo1IsnqHQhlSeB9JQVbgobNwxItQc7//27wPi2FAd9QyVe/vGlWh0y9KQNRkWHwMoY3CFqZ88l8UcRpNIPJ8O+9OLetNIxypLVQ/JDFn7cGx5Ku56N/vdgDDf9rzibznBU9MgTDWyMghZgO8yr9/VCQ06Jwy89AjqlA6bRMFsN/HplTK4673dsHGK2XaW81jwncn/RDLe4g7ww8xLEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hEXY382SLjpgk+SMEqO1Jnnclh9pnOZx/ib1bDc1Tj8=;
 b=T4REcM+uyCHzew/dqolCFdU1cdWFo/iIajMDFg8kTeUbXOTfUVVx6yw0YJx1yAbpC8iRf3rDqVfH0VhjHx7ntzsctTLwbJ9caogCPD5j9EtrXwFgCRTWUPqrfAwfuH43L/kx6Gq97JQ0sODVSchn4J3KCmBw+xVslzjhjuiXAoxDriS/epK0QdNYJM/hNzwRrMuO8FOtWCmnU9/1wKkdOS9JSIhEUzQu4m49S3EsrcN43LPeqE7a0JMjti+O9w95B6y5p87ShVruw8epmdLdObn6I8/N4Uv4G5rfjYEJ/5MeGKNw4SkqcxiiX9Hsahv1PtpmQQQ9l07OV1AZVvBD8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Received: from BJSPR01MB0561.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c211:f::16) by BJSPR01MB0595.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c211:e::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.34; Wed, 28 Feb
 2024 09:45:52 +0000
Received: from BJSPR01MB0561.CHNPR01.prod.partner.outlook.cn
 ([fe80::fcfa:931b:8b1d:6af5]) by
 BJSPR01MB0561.CHNPR01.prod.partner.outlook.cn ([fe80::fcfa:931b:8b1d:6af5%4])
 with mapi id 15.20.7316.037; Wed, 28 Feb 2024 09:45:52 +0000
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
Subject: RE: [RFC 6/8] i386/cpu: Update cache topology with machine's
 configuration
Thread-Topic: [RFC 6/8] i386/cpu: Update cache topology with machine's
 configuration
Thread-Index: AQHaY9zroLFH1odqwEKCZ7WWKO/azbEfjZXg
Date: Wed, 28 Feb 2024 09:45:51 +0000
Message-ID:
 <BJSPR01MB0561F3D87C67D4BCCA9E9C8D9C58A@BJSPR01MB0561.CHNPR01.prod.partner.outlook.cn>
References: <20240220092504.726064-1-zhao1.liu@linux.intel.com>
 <20240220092504.726064-7-zhao1.liu@linux.intel.com>
In-Reply-To: <20240220092504.726064-7-zhao1.liu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BJSPR01MB0561:EE_|BJSPR01MB0595:EE_
x-ms-office365-filtering-correlation-id: 4968ee3f-a099-4d8e-a6e6-08dc38420d35
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 PZIi23fnAUZujKPgDcG+czWL6v0aTZkRtInjGV7pzScVl+cUCDbvaPWVA41JUd1FQx5zn7qUbRPiw2S7nJ/m8kRCNj5Jqehp5DqtJAMXFnt15paV3bsccbzs0irgC3TPRH/DfUmAjvMdSSp3bGDc1mbOU9LlyopyPQGk5cmQoCer/XcztZ6yPD8t5GRWjU+M0s5g0wnyjKZxdYxtHQharmgWy3yVM84TNOUU16V1lWWoAObtc++AZqjOcl6Fdc2KhMkiFjuY8vR1JT5c6Pv0tPfmC+aRwYLo8GlojFMC1QP+9cvKjtH/MvSo24mouD+LrtXdbEbe9ZKeg336UvixIml6vKK9nWKGbsjLLlHdXF13wG3uLfI9RnZTmhDzkKrZLrM3/4ckbHep5a8biXAc3S9dH4g5OirDsMtSrqPGXkx9nOaM5CYRgfFOhNmTM7boLywazozR2aEAsfFL0v/tMItr1qoeeOhh4z0mfm8OMfPRIJ19v+en8ZNSjOE7yr1txbZLfFBAPkzIbclDY/AX/Qp1l6/zJRl51nRDftqKLWIQpVlX+M5kPuJNMOVkEflSDEmL0z11mfUoKbWvzj2AcoI0rcXaoXn09Rn0apQZf6txndubWy2KzC0pdhaDppWj7DSeS3vqRZ5VmjCvoytKvA==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BJSPR01MB0561.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230031)(921011)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?XrGMB2ylrdq/yH9Ln8raR92DE24tL/6/f+zDvs9zyyU6NXxsroOx+kQO3m?=
 =?iso-8859-1?Q?j786OQqql5oST6riqR+TEVEAnMzro/0pxIXV2qPQ9DKG+GevjQRng7T+M/?=
 =?iso-8859-1?Q?uoGzPuQsQjcvlriFLJPtn8mY8Zqol1O6sDAApJmL5dWkCX9/9ceUQBDuft?=
 =?iso-8859-1?Q?v2UAJEEcKwAkKLNuWjDvQL5jQwLlio4DxzoWLiRWOQric5x1wL2YYULwYS?=
 =?iso-8859-1?Q?D2uXvfBFTVg/NpyAJVNjyc/dCpRqE2a3fxv/1tN5LQavNfV6Ft+9jo6pom?=
 =?iso-8859-1?Q?Vji0xEQB6wgBxX7S9h4m71PFKuYO4EtQd/wYloIvFcnKs/vV5+qD93BPxJ?=
 =?iso-8859-1?Q?f3Wr/1sx++Glxetom74NLr4gn3JscXznEkilFQ7RT7IvqyzR4xo5OGXGmj?=
 =?iso-8859-1?Q?3/dcwNnRwghbPeECf1ziXDk8pHHrVGto9qKEbbB59yG+nQnD7GSxv7AHjD?=
 =?iso-8859-1?Q?Opeo3FITBJ2+VoD0L4woSYXbYNIVAiUMsu7tLvMXip+DJbdlEF+BwP28SV?=
 =?iso-8859-1?Q?kW5KakjSoSmCkdv8EdpL2bHA0xuMEklXc/c76s2w0WqwMZAk6GHOEMN6tC?=
 =?iso-8859-1?Q?Wk8NmKswiS3LIpa+nAUDrmxxEHrDJNjo32KjINMpCoagmXQU+zyCJcWU0z?=
 =?iso-8859-1?Q?V6h+xFu9OZiqb4QyLXTDgD5nlmTLwsbr3yyyh1nz8tRv2k3cLT7TjXkj7W?=
 =?iso-8859-1?Q?g2R5GgX9uCrN6pa5tzIlXIUoUdFqyt+uGyMPdCwKTirj+oShoUQ6YUtzV/?=
 =?iso-8859-1?Q?NykrnBFgMniNm+ga7BiD8lauquASnBiLiFt3YyltqcZI5G7FIUgsXEJgmy?=
 =?iso-8859-1?Q?rTuF13zlcG9LI+oS45k7fB74MnjeXYCsrPJkaDx+G+lh2/gxrSysUQdHv+?=
 =?iso-8859-1?Q?XVZ5kBmyECSixWPJc9lDxughyyMWO68JtEFpj8+1bMzHAdcKifzwz0G2Ad?=
 =?iso-8859-1?Q?dUpSqSBMrAgz/oPr/CV9UpiAKVOaDcr1mLOE30FtpaLBkrNAExKHUGJxXF?=
 =?iso-8859-1?Q?tQzd/a2yeJITMj97sQuwO7IMLuPh/Jh1vWrKu/MidEoguk6Ld+HgLxwJED?=
 =?iso-8859-1?Q?d/XqUMPCAh9I+oTHFRGqGjzDoy4E74pu/yJGGlmMY6VwwIqdT2Mlsj6wac?=
 =?iso-8859-1?Q?fDFdaT6rz/TjQSm0vGkzsZq6gwJuLhrzG9OKDaiWL2gaE9AJ1jIXtLST0w?=
 =?iso-8859-1?Q?FYpI1rn1qenidg462u7fL6pt19/h5rFLdwZ8AGUWOHCv6yZ3wINq8WbtIm?=
 =?iso-8859-1?Q?7bOKx2bBaYwAGgjlVTbNI29Ih/J8fPAhljkiSbf1UvPKFnZZ3dejT/ISZ9?=
 =?iso-8859-1?Q?8Qr9n32lymxuKcoSHZGXVcYc3HcMfXsH1ySmCnqi3/TridQBwTjpiqRRaD?=
 =?iso-8859-1?Q?1nvxu3loBUSi4M3aQQTjWsITQmQylOffe/92XVI8kGa2IxhBgCZ7DXkQ7g?=
 =?iso-8859-1?Q?0dPzbmndaJ8PRfOTpAFyDfB54aPgHLTdmdSRf0RDNyIxABI6osCPNFwM8d?=
 =?iso-8859-1?Q?PQAhbOHa5NHPXWeRO1lXIlWnHnBAxIDjhPgCJAYDxAXsD7ep9ZRItkot/O?=
 =?iso-8859-1?Q?TnhEs2UxOGMGYRTKpASJD5j7Y8wL1qAA18r5Z9jJz6renbhaGg3lt8AU9w?=
 =?iso-8859-1?Q?p1BhwXj5py9Z6bZPuKwMJ92osUPCGjReEbPVLTq9MqMgLcpXXMDbXU7lRG?=
 =?iso-8859-1?Q?VN2R3Y/8KT3rqFdAWMZGQm45oLfYrXKQD00Ggfh8EON3N3Fae0Acps5gkQ?=
 =?iso-8859-1?Q?XUOA=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 4968ee3f-a099-4d8e-a6e6-08dc38420d35
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2024 09:45:52.0085
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X/QtwJu+IsWAz4g23GI69A5xwMZdZn2rJllBdK/78t6gznGTohAWk4iUJeudGK5cSWHAI05LI4/N/K8UWFzKfGNd1P5M2n1kcIfQyurrAAI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BJSPR01MB0595



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
> Subject: [RFC 6/8] i386/cpu: Update cache topology with machine's configu=
ration
>=20
> From: Zhao Liu <zhao1.liu@intel.com>
>=20
> User will configure SMP cache topology via -smp.
>=20
> For this case, update the x86 CPUs' cache topology with user's
> configuration in MachineState.
>=20
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
>  target/i386/cpu.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>=20
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index d7cb0f1e49b4..4b5c551fe7f0 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -7582,6 +7582,27 @@ static void x86_cpu_realizefn(DeviceState *dev, Er=
ror **errp)
>=20
>  #ifndef CONFIG_USER_ONLY
>      MachineState *ms =3D MACHINE(qdev_get_machine());
> +
> +    if (ms->smp_cache.l1d !=3D CPU_TOPO_LEVEL_INVALID) {
> +        env->cache_info_cpuid4.l1d_cache->share_level =3D ms->smp_cache.=
l1d;
> +        env->cache_info_amd.l1d_cache->share_level =3D ms->smp_cache.l1d=
;
> +    }
> +
> +    if (ms->smp_cache.l1i !=3D CPU_TOPO_LEVEL_INVALID) {
> +        env->cache_info_cpuid4.l1i_cache->share_level =3D ms->smp_cache.=
l1i;
> +        env->cache_info_amd.l1i_cache->share_level =3D ms->smp_cache.l1i=
;
> +    }
> +
> +    if (ms->smp_cache.l2 !=3D CPU_TOPO_LEVEL_INVALID) {
> +        env->cache_info_cpuid4.l2_cache->share_level =3D ms->smp_cache.l=
2;
> +        env->cache_info_amd.l2_cache->share_level =3D ms->smp_cache.l2;
> +    }
> +
> +    if (ms->smp_cache.l3 !=3D CPU_TOPO_LEVEL_INVALID) {
> +        env->cache_info_cpuid4.l3_cache->share_level =3D ms->smp_cache.l=
3;
> +        env->cache_info_amd.l3_cache->share_level =3D ms->smp_cache.l3;
> +    }
> +
I think this block of code can be further optimized. Maybe we can create
a function called updateCacheShareLevel() that takes a cache pointer and
a share level as arguments. This function encapsulates the common
pattern of updating cache share levels for different caches. You can define
it like this:
void updateCacheShareLevel(XxxCacheInfo *cache, int shareLevel) {
    if (shareLevel !=3D CPU_TOPO_LEVEL_INVALID) {
        cache->share_level =3D shareLevel;
    }
}
>      qemu_register_reset(x86_cpu_machine_reset_cb, cpu);
>=20
>      if (cpu->env.features[FEAT_1_EDX] & CPUID_APIC || ms->smp.cpus > 1) =
{
> --
> 2.34.1


