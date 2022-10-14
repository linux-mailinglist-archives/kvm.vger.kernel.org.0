Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B94D85FE83B
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 06:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiJNEv7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 00:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiJNEv4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 00:51:56 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2084.outbound.protection.outlook.com [40.107.93.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC52169118;
        Thu, 13 Oct 2022 21:51:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kG5Rf7Jui7M/Pk4HHbwcRjl05WbBwlw8rG/fIE/pvavVUvC3euIEeUGGBRUAclojvyNhC0b64OY7jdt0YXYm1KGWguMaSTA4jsmyZLs76LlZSBq8WpWq5CWoeiHCPisejfZ+eswHp5ZUdOyid5nZOhDI674ZV98q9w6l6i95sL2G9fdmqSu7UE2GT5oLVNnUKQr/kzLxvfOtrg2uHpRS1JarSzIr6vWuxjmLitdGcLGzzqpxNfepTa8y3WDjaoC1zS0I0VQyBbX3K6sX2rmbvfWt7tRB+kfEeMJ71Aj9mcHpU4m7KzhzGPQYyTtAzNYHEhHcazcx4EMNq4jPtAp5Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1vy66B0XxIa7jFSWe6aeDpLm7WddeznfaAftGLAmB9A=;
 b=Jxwk8vur9k869lFMw67SWZXp32/+fm3MaRDc3Pq9S+Kk9k4EhPplziFoqG63t15EWDohsMsjxuugTx3Ccd8DDkt9ly74N7mKiTjO5E/kHZEz3QumVjvgeGThzKV+VID6ouHoH0YqEP5tcQHmJ+sk9wJ3I5XudjMCMiHfXfeSwUhpcFnM6ljQLNjeWoOgXFWTvrw2v/zVDnovaz4s+LAJAuT/hv3kO9Vh9ObxRTQCS3sYeJCUX9GiH8o8NwTtnlA/CuMs721XiaBxbc9Jhp85qvyzakTUvAvnigNIgDegsC3IZeg38MPqxYUpfR+SkE7JBxAU2c+Awypff4h6AiA7rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1vy66B0XxIa7jFSWe6aeDpLm7WddeznfaAftGLAmB9A=;
 b=qejITBBNH5Zfx5q3CgI2mQrdUJY2mlUxT06kWVokkmQov6X5hlkH8Npy+n0WntdjcsBAvA9HEf2NTUT1sAWOZhtl2VntGKSRXrn/xymMNoj1hqsxn9Mew3DpYGtatCgZ1hKgLpf3Uou2EJoBjhmyq/gy5Yu9fbqimxg7dzxxeAY=
Received: from DM6PR12MB3082.namprd12.prod.outlook.com (2603:10b6:5:11b::12)
 by IA1PR12MB6650.namprd12.prod.outlook.com (2603:10b6:208:3a1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Fri, 14 Oct
 2022 04:51:51 +0000
Received: from DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::377f:69eb:dcb:3ea8]) by DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::377f:69eb:dcb:3ea8%6]) with mapi id 15.20.5723.026; Fri, 14 Oct 2022
 04:51:51 +0000
From:   "Gupta, Nipun" <Nipun.Gupta@amd.com>
To:     "Gupta, Nipun" <Nipun.Gupta@amd.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Gupta, Puneet (DCG-ENG)" <puneet.gupta@amd.com>,
        "song.bao.hua@hisilicon.com" <song.bao.hua@hisilicon.com>,
        "mchehab+huawei@kernel.org" <mchehab+huawei@kernel.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jeffrey.l.hugo@gmail.com" <jeffrey.l.hugo@gmail.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "Michael.Srba@seznam.cz" <Michael.Srba@seznam.cz>,
        "mani@kernel.org" <mani@kernel.org>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>, "jgg@nvidia.com" <jgg@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "okaya@kernel.org" <okaya@kernel.org>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "Radovanovic, Aleksandar" <aleksandar.radovanovic@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
Subject: RE: [RFC PATCH v4 3/8] iommu/arm-smmu-v3: support ops registration
 for CDX bus
Thread-Topic: [RFC PATCH v4 3/8] iommu/arm-smmu-v3: support ops registration
 for CDX bus
Thread-Index: AQHY34dTQC9mGlmp3UOx5Opq013mC64NUdeg
Date:   Fri, 14 Oct 2022 04:51:51 +0000
Message-ID: <DM6PR12MB30824E232253ED0355CA776DE8249@DM6PR12MB3082.namprd12.prod.outlook.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20221014044049.2557085-1-nipun.gupta@amd.com>
 <20221014044049.2557085-4-nipun.gupta@amd.com>
In-Reply-To: <20221014044049.2557085-4-nipun.gupta@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-10-14T04:51:47Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=e370cb75-f5d0-4a97-83c0-cb9388ae3eec;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB3082:EE_|IA1PR12MB6650:EE_
x-ms-office365-filtering-correlation-id: a04f178d-1acd-444b-182b-08daad9fcf62
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U0fqWtwXWsBXCcY/poPCsvhovA6niFQtW9GKFAnHvdomkK4p8+ZGRCQQBbWsvdIN8WyuI8FOAo31wbKKobD/mO7gn64P+mAQa9pSk+ziFVPguDkN2pMEuKDAoTI4/xB3/AsvIsdTUE/nP41DncY5dNMgfxIRcs0Gys6x3oBOFX3xI/fFdOzRxjZsh38NEXRGA3kcPehmq8EKoVDfkt4GAiJjc7lluNYwDl1BI4LdF66alET6Fm5gmGT+4IubQKaG2HsZrlEhWoH1TiZFG5K6XxaZ/mVcLDI+7U+h6Kw5LPEomWQzml8sJMhEkLQfPS7jZ2uP6DBUjkaWUHRGjojKCSasuupiYYZC3OdQyos0F7VjzI/UPd0ePGjcj1jd29kJvA7BTmuykQxZYqLv0PefsJB/NOsSdtVaX5HR1tfzbYrXa/v4NOigOKZzU2R/n23dabGamA27ob52ENRm5NG2XmGgd1nKUaXfwZ34eVotdDf6ujWDICxrm8xafF3Fg2egpg5P903sSZVQ186CVlFU/Vxckqpg1IdX3sQOtirraHJtRDw2EqORe/GzIKCsrT0FjlJvZ+rxKH0jCXerbzCfMUblWFgxYVzhHzRibzi80SQk1GQ8eYeN+GYQsFV0ST3jCtYjsqCLXDOvtX9OqsDEtMAX6yndn8CCf4pI/dmSO627VXIw85+7aR4Gu3CjOovv36O6doRgaHkSYU7Q0/sq4cfDAMz9CeImfrrahxSu+reo1fvdkPTnvLdjSS2xFYEAeolM3H4SVsXX9P/4Z3PIMEUv0zp9Eaf3lnhRIx540j7uzx4h4XutgDio1s2voF78
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3082.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(136003)(39860400002)(376002)(366004)(451199015)(9686003)(186003)(26005)(4326008)(55016003)(2906002)(122000001)(53546011)(52536014)(66476007)(316002)(8936002)(33656002)(86362001)(54906003)(64756008)(66446008)(76116006)(66946007)(66556008)(8676002)(38100700002)(110136005)(7696005)(478600001)(6506007)(7406005)(71200400001)(7416002)(5660300002)(38070700005)(921005)(966005)(41300700001)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4Q2xu4lYTjojZ6iAy2vGf6z1v0QH9W0Z5rPo+fLDvYQ8bSDdAr7eY0m0tbBc?=
 =?us-ascii?Q?Xuv1hmM1lEQ9Bhrm8b6M2G34f/svm6aX45MJYVzms8/R2y3lAHAOXnMJUDoA?=
 =?us-ascii?Q?oXUGUT/xXqx/b0ioYxRHiGc1w6nPprcHxFc9DI0WXvsM6Gm7564IfK6hrX9T?=
 =?us-ascii?Q?4lxf31MKljTFzB6MpZakPRnH9E+r5Om2++x/SkdptF5tw1zP1M5H3H35DGND?=
 =?us-ascii?Q?2m5xxZDLSveV0acpEZN/udLCErctp3qXYQqofwa7uPq2rrsWpsWUATf+OITe?=
 =?us-ascii?Q?lGqCgP8khNPg0wENzCClD89KJuWT+OiWTFeeTdflSzoC3sbJltQQpMac7yaj?=
 =?us-ascii?Q?k2eDclo9mBMCjo0PBuuk9C3BBzwKXFrXY4SIgkIL0b4zqSyhgD6eRX5sP4KZ?=
 =?us-ascii?Q?lBUF5c/TmWuYIFUhmJpEXJuBVYM5qKZsg9Li3/xxbJZlVQwiV+ksPM/Nzt74?=
 =?us-ascii?Q?ohm2yqMorqVIuc7zNCgcrZh3oN3d0hyFJcY523NZlaGAAwVrbBN68PBrus/O?=
 =?us-ascii?Q?y5fGXCEGef/wNrhoVoeWVEfw+eJdcQTnv5T3egeE5BhqWbDFqSnHDHOcASZw?=
 =?us-ascii?Q?u6rBKnEAddsDkE4IxI1/FYIDH07d8hbHyWbDJEq97KifXJ3317YZcGF9RzhO?=
 =?us-ascii?Q?7qs0hCEc/eds+4PcBZLHq9Hx0JDtofK/kgktn9XL9/4jrws1L8ur6py3MisY?=
 =?us-ascii?Q?Mf04bZ09017nRaYoxgzcNsBPR9XdANWDTU+6XF+aEQ4TWT5HLwjOvUQyhyvP?=
 =?us-ascii?Q?g4QiTi9IERRCOT7QuPdnk+I2L8HdQlx2933v11/35WLoFUvpbyI7+EBe2k+G?=
 =?us-ascii?Q?o9eKB07Jt+VOOCl37GGkfznLlr1RUCUeYczNtTWWfEIp5eraz9D1CNjQke59?=
 =?us-ascii?Q?xlPYBpEIxgTCLRhvUS74PwedKLIF/JbDiY66/GcEhooE6LwC/uEbbE9lTwEV?=
 =?us-ascii?Q?9VjVGKR4fo3Jb3vx/oALSU+OFlaWCmso0zMUhXlAOQ8QvmPxE/5QNf8VnTOn?=
 =?us-ascii?Q?EA5kSHu8iLGPm/11P8rhpgEIgYDD4A3x4JqoT58qB0ty3h7p3hjBca/YX4oc?=
 =?us-ascii?Q?6sgzNWGxlOyO9hU5oQIQet1dN+fsHU+vVHhSyULA+tFWVi/z2KtK7E3aGY9G?=
 =?us-ascii?Q?/IM73VAUZKcqbNaa9PWOLe8BKjDUA8aGB33Vg7pNjN8PkkLuK1q6oGvgJ6/W?=
 =?us-ascii?Q?a+xJnlTUjSPQSbuzu0Q1o4P/gv6Yxbki/0E1bTB5BMjWeIz0i+1fP5tRNmff?=
 =?us-ascii?Q?bnsrPTcCCoTdGyNS2f+1V0TCPAlrxGPCSJDKhohd2rH23UpfFiNpBHXLPWfE?=
 =?us-ascii?Q?R73afdmOq96sHNBTHTz8ZuSWrs5ob3YHVGq5he3TaJHZd0psGXIdrVaWDlNH?=
 =?us-ascii?Q?6MyWAUkeOipJuQhAprev9BbC1uL9VMuG2aUCMS+eaB4bTKZbAmJFvgt13aW3?=
 =?us-ascii?Q?yRjBdbWDPFm1JqsGoefLnjJUoygXGbNfuE/wcieU6JptQpz7wQuA2H5z27Yi?=
 =?us-ascii?Q?ojI61MZX09F1lfMh4T/hxuxbK4YBVDZk8ei2EVGAJ8VYxFqIQWY8KHW2arey?=
 =?us-ascii?Q?hrrA43eo0PQGGlI+/bg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3082.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a04f178d-1acd-444b-182b-08daad9fcf62
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2022 04:51:51.6908
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eWvdsgOc/P09qk2AQYWYyA+MGEHw1UYBM2GydtJmERS0N/L/j8GGJ3QzaRTzvCQ2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6650
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[AMD Official Use Only - General]

This patch will be rebased on top of https://lore.kernel.org/linux-iommu/co=
ver.1660572783.git.robin.murphy@arm.com/T/#t
in next respin.

Regards,
Nipun

> -----Original Message-----
> From: Nipun Gupta <nipun.gupta@amd.com>
> Sent: Friday, October 14, 2022 10:11 AM
> To: robh+dt@kernel.org; krzysztof.kozlowski+dt@linaro.org;
> gregkh@linuxfoundation.org; rafael@kernel.org; eric.auger@redhat.com;
> alex.williamson@redhat.com; cohuck@redhat.com; Gupta, Puneet (DCG-ENG)
> <puneet.gupta@amd.com>; song.bao.hua@hisilicon.com;
> mchehab+huawei@kernel.org; maz@kernel.org; f.fainelli@gmail.com;
> jeffrey.l.hugo@gmail.com; saravanak@google.com; Michael.Srba@seznam.cz;
> mani@kernel.org; yishaih@nvidia.com; jgg@ziepe.ca; jgg@nvidia.com;
> robin.murphy@arm.com; will@kernel.org; joro@8bytes.org;
> masahiroy@kernel.org; ndesaulniers@google.com; linux-arm-
> kernel@lists.infradead.org; linux-kbuild@vger.kernel.org; linux-
> kernel@vger.kernel.org; devicetree@vger.kernel.org; kvm@vger.kernel.org
> Cc: okaya@kernel.org; Anand, Harpreet <harpreet.anand@amd.com>; Agarwal,
> Nikhil <nikhil.agarwal@amd.com>; Simek, Michal <michal.simek@amd.com>;
> Radovanovic, Aleksandar <aleksandar.radovanovic@amd.com>; git (AMD-Xilinx=
)
> <git@amd.com>; Gupta, Nipun <Nipun.Gupta@amd.com>
> Subject: [RFC PATCH v4 3/8] iommu/arm-smmu-v3: support ops registration f=
or
> CDX bus
>=20
> With new CDX bus supported for AMD FPGA devices on ARM
> platform, the bus requires registration for the SMMU v3
> driver.
>=20
> Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index d32b02336411..8ec9f2baf12d 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -29,6 +29,7 @@
>  #include <linux/platform_device.h>
>=20
>  #include <linux/amba/bus.h>
> +#include <linux/cdx/cdx_bus.h>
>=20
>  #include "arm-smmu-v3.h"
>  #include "../../iommu-sva-lib.h"
> @@ -3690,16 +3691,27 @@ static int arm_smmu_set_bus_ops(struct
> iommu_ops *ops)
>  		if (err)
>  			goto err_reset_pci_ops;
>  	}
> +#endif
> +#ifdef CONFIG_CDX_BUS
> +	if (cdx_bus_type.iommu_ops !=3D ops) {
> +		err =3D bus_set_iommu(&cdx_bus_type, ops);
> +		if (err)
> +			goto err_reset_amba_ops;
> +	}
>  #endif
>  	if (platform_bus_type.iommu_ops !=3D ops) {
>  		err =3D bus_set_iommu(&platform_bus_type, ops);
>  		if (err)
> -			goto err_reset_amba_ops;
> +			goto err_reset_cdx_ops;
>  	}
>=20
>  	return 0;
>=20
> -err_reset_amba_ops:
> +err_reset_cdx_ops:
> +#ifdef CONFIG_CDX_BUS
> +	bus_set_iommu(&cdx_bus_type, NULL);
> +#endif
> +err_reset_amba_ops: __maybe_unused;
>  #ifdef CONFIG_ARM_AMBA
>  	bus_set_iommu(&amba_bustype, NULL);
>  #endif
> --
> 2.25.1
