Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9E676E27A
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 10:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233970AbjHCIIl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 04:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234466AbjHCIIH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 04:08:07 -0400
Received: from mgamail.intel.com (unknown [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F903C14;
        Thu,  3 Aug 2023 01:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691049619; x=1722585619;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tkQPq5ikxQbF1wPuS4wbR7iVr2TTwbkrCuI+oFHC6Cg=;
  b=ZvkuXifIBrA8Lnrpi2kdsM6upm9kh7KLN06Krvv3Pr0M3AcLN9AlxlUb
   clKyS9az7CcDPNOFFcfuck97QOyWHFajVok8I0FYUwA2fu9wXm+UtHosS
   GM/HOACZrWgaXTh65qaS42UIJY1y5Ar56Ff1fvZ73msyEy5Dw0K+7/qK4
   yyVPa94qF1YktsU/XX59REtpiIDnh/9+iODLa5DQa+rZe1yzv28eZ0Iau
   FcL/AuCqwAAvurgdOSI6XlLZ7B1N3d/xhyR8rUCC2E126V9MW9Z7Yv08y
   WDcbouWcjLG5Nm/ZyS/YHyNXhBf0yAI3+fHb7PSMZFw4xpNxE8A+BxGTw
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="369797325"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="369797325"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 01:00:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="764501552"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="764501552"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 03 Aug 2023 00:59:59 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 3 Aug 2023 00:59:59 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 3 Aug 2023 00:59:59 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 3 Aug 2023 00:59:59 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 3 Aug 2023 00:59:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G8JMeHTwCUiMqSI3T1oC3DSC4ZCosAyKker1UUQxa8wkRhDKFBhZU9VHEICLn4pBwMjPFqJlEJoKNykaJKfq294zyOzHWtpZDLcuvZ9xMKS0o7lp4w6moP/DEPt0ARftvsdt2nTAlRCEC8qbgoB1UY0YhhoTX5C04XpeqmubZxdAFPBwiY1VF708fM4qm4PVIUfyG2RiEH+j+0OM37IAmdsVD280DiFXGwFDwa3owiazJH0Q6nzPHiNFrDr2ulaA1TmusnImzTEPChwRkOGPBYpc6HvjE6ZuTct7xKM+eLvYvktQoT4W5wtl33gxJ5SCJtOWW4349moypx6JeiGCLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=80z3S4lg8hX0ZomMtz03JWZNB6dLZrOZoQ5PB+FhlcI=;
 b=LaxoeJ/9umteq5KQRR7b8IVDkYvae2iIM90Vj1bGYj5wqv1XWlsNSbN/hGdbHQwCD0+u3id+50rPIY2FbJ/ZXUgtFvV0RwZQRmiaguQB+z+tMU0L58yuDRnqmmwu2h/QvBVNyWDOCycpKFJEyhgDFCd5cmi34TjtsZpXSxnOb0wsBzJzlR6bYE1IDlCO3Jk3U7VkBGzJvumH8lwn5Dk1mfHxrtTQ7iciqyd9aTrrtASLTybQSO9BmzNL5EQRvYaOTu1p9UcNNgoZBlee9p+dxLuAJlIUWoxtKZHZufLSZVoqugKi5YifNJb5ZBLP/864fqLvffqBywnK4MKD+tqPdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB6881.namprd11.prod.outlook.com (2603:10b6:510:200::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.47; Thu, 3 Aug
 2023 07:59:56 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6652.020; Thu, 3 Aug 2023
 07:59:56 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Will Deacon" <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Jason Gunthorpe" <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 05/12] iommu: Change the return value of
 dev_iommu_get()
Thread-Topic: [PATCH v2 05/12] iommu: Change the return value of
 dev_iommu_get()
Thread-Index: AQHZwE5aOEc+6ikxPE+EMdq5oUz2zq/YPxrQ
Date:   Thu, 3 Aug 2023 07:59:56 +0000
Message-ID: <BN9PR11MB52769A468F912B7D395878ED8C08A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-6-baolu.lu@linux.intel.com>
In-Reply-To: <20230727054837.147050-6-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB6881:EE_
x-ms-office365-filtering-correlation-id: d6ccf6d1-01a6-4e01-3045-08db93f7a0b5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3eM/dCpW1ZqNx7arZ+jGrjwLF0YQ/u9ewsNkn3iNEKcWY7y58uicIGNi1YCSI1Vc5mXZH5MG4L/ObpiX1dfcousnyErK6VnB6SBDLeQPMdr74baAFaw1AHGAtehFu4tbZ1+0shltPfMNDCw3tu6UaEpBtRrYoRmXxnAOTeRWxUrLYNYENq30wTfpqqa342ou3pPWW3CyrdHXjVMRKHUOBjzHlanuJt6kK8FfENqX4QRJ3XP+q0rFx/BSDItyuLlGXNQX7+xUQLS505pIF6RlPZBfxgUFJ4qKPxC+2b/dZlL5wsjoL5a8s6XIbmPLjhG/nvaPcpO45wTIOX1+DCqt25xdPxe4astqNFlZeCbie3JV2ITbUERkPnKMAXCCRDFefKahGV26BRHXXj338Wn9ruys5OnpDLIyzUa9UNCfHm1S3AoAyMQMTCOTQmZqIh3dJ5XKF5fUn8B5faLLU1V1thuRgd1u/XT3p2VWY/4obb6PbaTHZZ0RFowl5X9zM4CHPdcEe/JKIxqbmY2l+A3a1Gkx17mjqMoQoS3zztWb+woun45aYRWrpoupXHItSvLEY786JfAQzpXpUsICDgG4+c/pgKxN00rpwhmrdohXvZ+vCZ/vkn28ErhEylnW+YrdprqHPjQX0onQQVmCuIEEtw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(346002)(39860400002)(376002)(366004)(451199021)(38070700005)(86362001)(33656002)(54906003)(478600001)(110136005)(55016003)(38100700002)(82960400001)(122000001)(6506007)(186003)(26005)(83380400001)(8676002)(8936002)(41300700001)(52536014)(966005)(9686003)(71200400001)(7696005)(316002)(66446008)(66476007)(66556008)(5660300002)(4326008)(7416002)(64756008)(66946007)(2906002)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Oke7+WQCg6AoFasdafDCQMqGXn//KL8mbJI+Cp/FkrzmhYuGuB9jXKZymZjs?=
 =?us-ascii?Q?DS+aQkG9FzbYKR2JlnEj4bhuEjPF68DAUAuobpewQWA/COM2Ug0r4b6BS6xg?=
 =?us-ascii?Q?rLvJrxcx/xEtbGMUCAwx1bPJt/Sll8/0q30bzyHPbP74X/yv8hVee2F3OCjz?=
 =?us-ascii?Q?8GrZh/C7iz3nTpHQnTqyy8H3u5RaLOD4SnPjLdR02sjExDz2uZ/YtxBJM+CX?=
 =?us-ascii?Q?f23BoakFUeQn3DDbvjm9Zr0r2h3cZbk1StiYCY4mgN9mtR9iNZudmCqjmNBq?=
 =?us-ascii?Q?zZo59bCu6Y4ySP4zlQ0vHetX7zsqFQ8sA3ahOR14mERj4Nsbqha3XjQNGF1C?=
 =?us-ascii?Q?jPLBHJwGl3GPNG/7x53jB9KKhkre0RRLsQGfD6skalbvQgA3q9O5lEygCm+2?=
 =?us-ascii?Q?b5IW3Q9jm7OAWUBuqWsKuHhorbON+GeKatzDrJgrXOk07t7Uca8V8DydSen8?=
 =?us-ascii?Q?IoDiUXepx+ByZpYA55pL3awTKt3eBjD76NqBUe2QlW4cHh5tQxgqJefjnRG2?=
 =?us-ascii?Q?6Bl2PhGopTRYLCnK/4QirN4TPtrpT9afuZaXay9SkhPQArlOAnDzujhSgMUx?=
 =?us-ascii?Q?rtb2XcUwSFLSD57vSae1HiM5AuxCNJHmCeU/42wS5gfo+53Y8Od2XswA9L/d?=
 =?us-ascii?Q?gZjBpOsT4qcwX8DQZxAwRSXJtJSE9eXcvxJzQRtYL9PjnaNGPeRaXpMd6P9O?=
 =?us-ascii?Q?15TjbfotfBcIaCxHKpm7VcsC2wkrzdq3cPMQq91Ohqi1Wr7v+0rtvpWxLx8/?=
 =?us-ascii?Q?OL2x90d3BGabAD3jU/o4aZWmsM+eNagC5vOy2uuIQrR03mLZeJaEuEnsnWmy?=
 =?us-ascii?Q?p57BU5LqBQgGyG0/5SOFSYI9M42NtmbX5pbpgxDw67vhc5DWDe/LVWuV8oge?=
 =?us-ascii?Q?8kwx4xoSlN9+OYlc88Vs3H4xTTAWq6veoi7AXZxfVFvpo58YXSJtho9jCbkh?=
 =?us-ascii?Q?Xs5Kat53eONIQ0F8aHridQHTEvleXYaZBaJtBHevxqq2pVtUEBl+/1canhJu?=
 =?us-ascii?Q?EKRUTfFJo3InBB4UcoVqLnhVUKvNmlNrk0L1k7TjLSP4NVhKGyUAb9ewtBD4?=
 =?us-ascii?Q?1Fh/Hk1mLr6f7nQhHPZlWzW0L0aB9lR9SmpG3tsytGztZXSnCSHbEEPlaHAJ?=
 =?us-ascii?Q?F5WfVp58osO59UhV5tk6uybK3N8cXgAoi2SN39zP37VFJOsxqV/picuQMEBF?=
 =?us-ascii?Q?TgdZmWpBZffc/LCQ2Z5Ql5yMD0+HCAhu2C9gLTlYUKEyX53cvDNapsy7JcSB?=
 =?us-ascii?Q?i0e6TYYH/m+S4r6AVd5q2BFh+R+N39pturGI37VHmhVILb5h5bGaJQktyqXG?=
 =?us-ascii?Q?zjUEkvxYFcjiYKtQ7CFg8B68t53whoQkHkzq+YRT54yekq3aqDwdv/murw61?=
 =?us-ascii?Q?MoCd8RQ3ZVXLQEdNQli8j2J9ma5Zww4hRrdPQNheQcYO4Pqxm3w9yI0WqLtl?=
 =?us-ascii?Q?o0xQoscSplBA1Q9ZOZuLHwvbwkT0bz5SyVw9jGxYNT3QlLiL9KacXRgQMXgT?=
 =?us-ascii?Q?U37/6DIfcYIfAQqUFje0W7wf1v0iYVQQWVdwfun0VjGSSCTuv9N65D/4MBnE?=
 =?us-ascii?Q?IBQ79q+wJbQNNDqr46IKdT9WJ3VkXw+JsvpL3k5O?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6ccf6d1-01a6-4e01-3045-08db93f7a0b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2023 07:59:56.5136
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Gt2/J1SwtRS0Yf5PWgm9iADwkjlsVxD8OChf+OUPQjyPOHPmBZNF46t4Ms4/5MnboR4HFc5UNVUu34PiByXaqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6881
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Thursday, July 27, 2023 1:49 PM
>=20
> Make dev_iommu_get() return 0 for success and error numbers for failure.
> This will make the code neat and readable. No functionality changes.
>=20
> Reviewed-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  drivers/iommu/iommu.c | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 00309f66153b..4ba3bb692993 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -290,20 +290,20 @@ void iommu_device_unregister(struct
> iommu_device *iommu)
>  }
>  EXPORT_SYMBOL_GPL(iommu_device_unregister);
>=20
> -static struct dev_iommu *dev_iommu_get(struct device *dev)
> +static int dev_iommu_get(struct device *dev)
>  {
>  	struct dev_iommu *param =3D dev->iommu;
>=20
>  	if (param)
> -		return param;
> +		return 0;
>=20
>  	param =3D kzalloc(sizeof(*param), GFP_KERNEL);
>  	if (!param)
> -		return NULL;
> +		return -ENOMEM;
>=20
>  	mutex_init(&param->lock);
>  	dev->iommu =3D param;
> -	return param;
> +	return 0;
>  }
>=20

Jason's series [1] has been queued. Time to refine according to
the discussion in [2].

[1] https://lore.kernel.org/linux-iommu/ZLFYXlSBZrlxFpHM@8bytes.org/
[2] https://lore.kernel.org/linux-iommu/c815fa2b-00df-91e1-8353-8258773957e=
4@linux.intel.com/
