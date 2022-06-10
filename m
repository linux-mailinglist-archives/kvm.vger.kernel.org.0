Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04601545A6A
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 05:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbiFJDZu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 23:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232754AbiFJDZt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 23:25:49 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E5F259F46
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 20:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654831545; x=1686367545;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=39xGf/AlelBLkHtypp+aHcgXTcHlhlPlshe01qh0lWA=;
  b=e4cCW89av2PN5GgIDEDcF6sA/qul6rTLp6+a7LXQUBj84dkC7ns3NZy5
   gzonc0C/m7PvNRePWHPzfeFwgvRUs9Yi3SbFChOTjRRLqOKeeT1maLiDv
   STdljRpxiWEUcsNimoiJOyh0ldTZ4WlgviZGbfpZXKie2LfKNzNWNpFUK
   UUa7NbQMMjzYdwMpu7KOxFZSJr9wJT9XpezOPVnHawTwk4l12idIDqUls
   E5mtPNijNZY5Gl1pwpMHmTT7A5FBoEbQZLgUXcWhexa7Nvx4IPtDyf0uE
   eQjegmTGuwKaDJlO5uiY1S3akE24zYb1R550rBnuh+rB+XywUcdZ6pwbc
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10373"; a="277527468"
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="277527468"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 20:25:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="710723344"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP; 09 Jun 2022 20:25:44 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 9 Jun 2022 20:25:44 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 9 Jun 2022 20:25:43 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 9 Jun 2022 20:25:43 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 9 Jun 2022 20:25:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ABtvbi6oRQFteiIdPNBHTt9nFe6AEmAozkje0R/dU3QCx2dGK7pUis5yrYwWWx/HtNx2G0sPn9o/ck65iTE4U4FnJdSvByAiiADR2N4Xc/99L2wVnLFKgOPtoMfsahvtx21l2YU5fH5JLkjEMM/0zhtk5ZOXYRC8P2Bev1jZ/kprGmuOX4+eEoqJSuPQ2POAiqGJ2V2BUEj/KyO9fqbgWecdmzlB9ubFgQ4NnbffaQVnW2h/2vriR82wPQzrEOGhSazh6jPd8f6cWCnHemTUKLoJigN1fvZIWvKtg2HjFmJc0zmcuNWKH9H3R9YJuLO/6E93JAHSbfk4zBGERs1iUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xlkPdaOxl5TxzI4A5oc9m2dgwA7nnH+wrBwuskttQeQ=;
 b=EE0N4enKRAOWnE184hft1EP0qSKt+9HugXfJKtXVQDUb9K65kRl+IoXwgG6rsAf3zQMMFFDcSvpxFbugvtaazq2hrLs/zYqomHEYmIoAhrlejzy2jk6MKZuPTjbBySG2x0byaC/dgs19D0YtCFKnCM4hXaovxOd4hRC7hQYQLNNCwe7/GSUeNEUR0k9TRKHxC3FSXsjMVfGjy/wKPP5MyTMP6NSI5T9IvEPkZ2aX6OdRseOjVWe60fUUzDHt6fC1hk78MVTZqe0VmUyiyPoIrzkagzh2oiu1eEq/SK2F7rqylNhGV8DdiJA+flkxDZPpMOo9o/xaNgBj5RT7bwHYaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR11MB1586.namprd11.prod.outlook.com (2603:10b6:405:f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Fri, 10 Jun
 2022 03:25:41 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3583:afc6:2732:74b8]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3583:afc6:2732:74b8%4]) with mapi id 15.20.5332.013; Fri, 10 Jun 2022
 03:25:41 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Yishai Hadas <yishaih@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "liulongfang@huawei.com" <liulongfang@huawei.com>
Subject: RE: [PATCH vfio 1/2] vfio/mlx5: Protect mlx5vf_disable_fds() upon
 close device
Thread-Topic: [PATCH vfio 1/2] vfio/mlx5: Protect mlx5vf_disable_fds() upon
 close device
Thread-Index: AQHYeYOUpO8/QXWGLEmBnYR1DQ9ZVq1IAGKg
Date:   Fri, 10 Jun 2022 03:25:41 +0000
Message-ID: <BN9PR11MB5276A8728FE91072C8CA1A5B8CA69@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220606085619.7757-1-yishaih@nvidia.com>
 <20220606085619.7757-2-yishaih@nvidia.com>
In-Reply-To: <20220606085619.7757-2-yishaih@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 191abb2a-208c-47e2-ff09-08da4a90e5d0
x-ms-traffictypediagnostic: BN6PR11MB1586:EE_
x-microsoft-antispam-prvs: <BN6PR11MB1586B7DCEA48A8A4226E99A08CA69@BN6PR11MB1586.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u6jqrb+x5I7PMJQUvESNsr3T3pIoojcGZsTQjzaDXydOmeNWUOb5YoRTZYyPaI/U7QAwUyBIECpoFazYR00rR7zb+YJ2OMJwnNLGXb+qEEyogYmdf0v3H2Jt4Fx/YmsK3zHzEX+Ro47J4JiXoO4FPg8iNA3tueb5p8lhOZY5PEehYNDl/agWOsTwr/VILduN89bcB/46w1AV6+448hKxuLQ0/LHc1PaAVQVeHKWC7ZgfqhUbHJ5J9IH5MlCxrdSdjjVDRyR14+aMu/bNzc6kNV+SNl8nc+ZQVermmwwF7jEu1AWWRMOZPrNuNZVxHcuDlj5l5qoBl7xbsrR77dEp+CmVHnYOB1tMs7D7Id9dRT27dnXn/gU/SQAxJy2gF/sgv4khRnkV2OD6CAeqahm6ySq/V9J8ierMXv3RJRPIYWCGnzZnwaPwGQk/aUcS/hW4Mk6TmlXPWE0d1fXwkxURNfs7ohbFWlU5vPfsZHgX7FMoYqET2iZ3nC4swsGtWrfVqMZkzEBiK811Zkimin3gzPH/hNn3pZInnS1d7uva3DQW9xBEMva7xsI2Su25h10rp7rJiIwpLQuiG1P0XbbhMGOB1NjDAd0gCwAvQL8qgcZTa4RPaAKO+Ni4Nc98jf1TqvBTE0Lzr/ff8eaCFu3CCRrW6gyPa9zPEsUPNx/6ws9rwOte4xl/NpL2iT18lAmf7GYeypXZLatOmFXQIyQu9w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(76116006)(54906003)(316002)(26005)(64756008)(110136005)(186003)(66946007)(66556008)(66476007)(66446008)(38070700005)(6506007)(8676002)(7696005)(122000001)(4326008)(2906002)(38100700002)(82960400001)(86362001)(33656002)(508600001)(83380400001)(9686003)(55016003)(52536014)(5660300002)(71200400001)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Q4gIeGRUQV/UeNI3/RsCXOIo8bLRximUy5YchD0MzA06xEAIvwHCvo1w0m98?=
 =?us-ascii?Q?A4IVrAvcFx4AHBPjYyOAwaElRulz3n4NbsWEmdGPtlKarmP8XWptAiY8PRMC?=
 =?us-ascii?Q?IYdn4Z/kCbmXggq7jt/rc1ii5ZrtOOwUnKIb2chLLar8m64z2s7aietsh8hs?=
 =?us-ascii?Q?mbloIn4ol08KT1lwl1I0aqSidX5Du27yl1bZaJpATufMbBw10as+8HdBiZKx?=
 =?us-ascii?Q?g2ffQlo0viVVTIZUMVlv7rp2UaDyJ7AaroheacKCh1F1RRfpFh+0Fhji6mSt?=
 =?us-ascii?Q?fXaSE9xDO4H5nIC9pJ8nZ/DXw9Vewk4Tqw4G2Wq/iFvS2z0/5jXIlHGEG19o?=
 =?us-ascii?Q?IMituhkfA8qm4Gn4kyP/bUCN8LHqujRNqHB+BHX7hk/3UfDCa+VhihEQDkxb?=
 =?us-ascii?Q?UvSSZ3qOtmwKpZ8s8/j6xr3kVilTxozM+5Y7yRNcQbuKhTkUZpbYsrGKjg63?=
 =?us-ascii?Q?sOQxIAz0iNKaQ1vBEiDSYB8fyLW9HwPE+1fzJ5Q07wZ7xZcDtQKmjFRIN4V+?=
 =?us-ascii?Q?eJm+K5/l0w4FpyJXPMVSk4Xxc7ggCwUBJ91C6bC92R8rW26apeuTBlP/qqXq?=
 =?us-ascii?Q?xIM/1tLyM2t27KufZJ+HVzRzS3dmecmdtFz/l+e8ubVS+x4LQQcvNdUKUEVQ?=
 =?us-ascii?Q?Ts/MZOOFAI1Qfu94Qf16o4g0xsG1T+1cYthQfEDHxuY33W4UNWgRzpx0F8lP?=
 =?us-ascii?Q?tocaVdxiZRwPYyT6A3wxD3ARsRHaopR8Llz+KmsmUDgyGV9AHF64FjI2p+74?=
 =?us-ascii?Q?bIT13z67PSlYqJ8it0265p1dnF6Jr5uU++UYyh1mup1qPB18KVrig2XdzOj2?=
 =?us-ascii?Q?X9OW6kaWzBwj8kMf95zICEDhk/exu48S0NRtEkGIn7wNCmPEW5RPeRNTYfKq?=
 =?us-ascii?Q?kwL5fJ3qRxBDeqakCa7FeFSWufyR3LBvvNCiN/psMws+jCoXJPf1aCAynqjm?=
 =?us-ascii?Q?J4aE9QXHQHJrwsjWRhVocen4p4WhZdNmRNDLp/3twEtsChwDD4H5aL5cNOG2?=
 =?us-ascii?Q?G8pyn7l6AuYkpAs+Oh0q/L+daFQ46WkgSq8j1Rlkz3/Ex7hBv/Xk/xhazvlW?=
 =?us-ascii?Q?IJU5LLg9nJNTbVHxlAePyabKdyEA9oq2jqLeb2MvoXluWEnRkEB0u+EeMFnH?=
 =?us-ascii?Q?8RTRc8Bs2ZWRRlLZQOJmdZ3fp5fSsGAKNQG1WkORR+gEw6ysIh8nBLuPohMa?=
 =?us-ascii?Q?LboF9h3+3skBNcZxqZDHBiDppJM9IitAEObdsHQnlmUKq2zwmmIyjE6qZ1dm?=
 =?us-ascii?Q?M+EehN834JOnMhVySkq97VLd/rJW8KlyCCNYDZgTv7o1336VgRhWfHfpHKne?=
 =?us-ascii?Q?w7h3+qcgoVftBEGTUgEihwBHLQlF3eaXwuw4MnjcOXEOuEpnPKg2ZPqy+5Kw?=
 =?us-ascii?Q?TCUE7YpELSVxg03mYudM6TAYWxiQiwBq1V+1jJoBJipB5awJMoUgovcs9X0U?=
 =?us-ascii?Q?GIinYZYEmhBfF3q1Ifi2ApfgZVaL+opbosHqCMyvoJt9hiuf07W7BCRvaN3m?=
 =?us-ascii?Q?yUGnaEm3HUuYahAoqG5ABV51cmdDQzOCkhhiwV9a5sC/nSEfSFdfDab5ByPh?=
 =?us-ascii?Q?aifyLc1I+eC53dMSc3HLQXQyOvfuNAfScxo4KaEIbixkf56OGqzqubGUSNCL?=
 =?us-ascii?Q?f72L/coTg/XBOQ1TSbe9L5XPL6KI2Aob8lie0Wi+F75fBAzzfJcTm55pc20E?=
 =?us-ascii?Q?vgpA3CeeLhmkSN4c9XeKMqX/ZBB5nstNRZgfvEvj7WwFetkITmvwJLfbzeFr?=
 =?us-ascii?Q?HkzGZf/fWA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 191abb2a-208c-47e2-ff09-08da4a90e5d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2022 03:25:41.7146
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7eMLJ+cIkAhaWCmUbcHX6hx+R9XXl64i1CRCuO7Ad9n0++s8wE65mxT8Tki5sK0X0JD65lvqOH5f+kp2mvqogg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1586
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Yishai Hadas <yishaih@nvidia.com>
> Sent: Monday, June 6, 2022 4:56 PM
>=20
> Protect mlx5vf_disable_fds() upon close device to be called under the
> state mutex as done in all other places.
>=20
> This will prevent a race with any other flow which calls
> mlx5vf_disable_fds() as of health/recovery upon
> MLX5_PF_NOTIFY_DISABLE_VF event.
>=20
> Encapsulate this functionality in a separate function named
> mlx5vf_cmd_close_migratable() to consider migration caps and for further
> usage upon close device.
>=20
> Fixes: 6fadb021266d ("vfio/mlx5: Implement vfio_pci driver for mlx5 devic=
es")
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/pci/mlx5/cmd.c  | 10 ++++++++++
>  drivers/vfio/pci/mlx5/cmd.h  |  1 +
>  drivers/vfio/pci/mlx5/main.c |  2 +-
>  3 files changed, 12 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
> index 9b9f33ca270a..cdd0c667dc77 100644
> --- a/drivers/vfio/pci/mlx5/cmd.c
> +++ b/drivers/vfio/pci/mlx5/cmd.c
> @@ -88,6 +88,16 @@ static int mlx5fv_vf_event(struct notifier_block *nb,
>  	return 0;
>  }
>=20
> +void mlx5vf_cmd_close_migratable(struct mlx5vf_pci_core_device *mvdev)
> +{
> +	if (!mvdev->migrate_cap)
> +		return;
> +
> +	mutex_lock(&mvdev->state_mutex);
> +	mlx5vf_disable_fds(mvdev);
> +	mlx5vf_state_mutex_unlock(mvdev);
> +}
> +
>  void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device
> *mvdev)
>  {
>  	if (!mvdev->migrate_cap)
> diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
> index 6c3112fdd8b1..aa692d9ce656 100644
> --- a/drivers/vfio/pci/mlx5/cmd.h
> +++ b/drivers/vfio/pci/mlx5/cmd.h
> @@ -64,6 +64,7 @@ int mlx5vf_cmd_query_vhca_migration_state(struct
> mlx5vf_pci_core_device *mvdev,
>  					  size_t *state_size);
>  void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev);
>  void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device
> *mvdev);
> +void mlx5vf_cmd_close_migratable(struct mlx5vf_pci_core_device *mvdev);
>  int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
>  			       struct mlx5_vf_migration_file *migf);
>  int mlx5vf_cmd_load_vhca_state(struct mlx5vf_pci_core_device *mvdev,
> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> index 0558d0649ddb..d754990f0662 100644
> --- a/drivers/vfio/pci/mlx5/main.c
> +++ b/drivers/vfio/pci/mlx5/main.c
> @@ -570,7 +570,7 @@ static void mlx5vf_pci_close_device(struct
> vfio_device *core_vdev)
>  	struct mlx5vf_pci_core_device *mvdev =3D container_of(
>  		core_vdev, struct mlx5vf_pci_core_device, core_device.vdev);
>=20
> -	mlx5vf_disable_fds(mvdev);
> +	mlx5vf_cmd_close_migratable(mvdev);
>  	vfio_pci_core_close_device(core_vdev);
>  }
>=20
> --
> 2.18.1

