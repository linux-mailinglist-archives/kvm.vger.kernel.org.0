Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A41562EB9B
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 03:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240681AbiKRCFo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 21:05:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239454AbiKRCFm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 21:05:42 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D6B87A55
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 18:05:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668737141; x=1700273141;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2hHoz11M4fLXgzI1is8H1y13LJEtgw4/2QnS/lFVhHM=;
  b=gDEckPQBL4AeMVTO1Go14EESqRxsJmzIKDObO86/Y9kutux5rFvnU/Sc
   IqXO6Wv5hU/Lyfe8j4P2r2Ri1VVp8byMc01KkAb6OIsJk0ze9WK+6ND8a
   nWnaMV3jWQQXqcEr8eAFTPZmG6wRJKBSt2yp6xpdemj2j8w0hgisppBlB
   3gsCFb20qM9/FzQnWY25YFjqaocogNjVUCrzbd0e35agH+UAtP3J22SwD
   KUyAUFWq5zuse/Vnb7GLz5QJY/OeanDCDpJuEraaBJYiCC06gn+iURxGD
   fVDyJwc5oIhC/WmgyRRmKAJuvoQhshNE0SLzcEwFmEEBuxtPCcGVo/5+b
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="375163411"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="375163411"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 18:05:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="969108868"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="969108868"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 17 Nov 2022 18:05:40 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 17 Nov 2022 18:05:40 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 17 Nov 2022 18:05:40 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 17 Nov 2022 18:05:40 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 17 Nov 2022 18:05:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OG7rt1j+McnM1QDSK4z15k2zjNkMJjxSJRuOQ2mEzLnmhxC3d3SS+K3HzfE41EkODNznIf12SrFoltIGOw0TmQ4FHGvk+TirD2mpg7TQkbkDOWsnpD8AcCWnYqdCaGhkBrHUYyWsQa+Eo7+V5R44T2fPVTK+F5dbQh0VXieJuFvVAmbsXTGCjZoztzaVVHVhpItde9sdFGSFr1uJb/TdQBlvtIlQS0lycQkYy4ft8/lHEgiu6RA8mHuQePE4E4tm9sjT93RZnwXK9stIKlfGgfxAXQ/7R1lYusaqkiUTNWShu2f+g6nMyGuTxCTaWWhWRVWRPVnTpeZJDp5SPgeo/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2hHoz11M4fLXgzI1is8H1y13LJEtgw4/2QnS/lFVhHM=;
 b=QFVqWP40+atkEUaGnmrFaIovdsFwGZ+D/PK8SL1RJmQS6rYHIjiwR161J521rI01hFcrYn+bVCck57bw8zdxfgYW+51hHl7UJxD01ezObNdBPzagcj0RoekqWvVNafuHZeT0W7u6FCIbrOmWmSVAkn8nT/LhkQR7T5LasgUNbHBiGn4oxSxCOVqat8exb/0mXTufwvD+X08uV+CS2SgTihx0KmFPHs/3qQ4Ayvb9hA+FYNyzTR/0esK88gvx9m/NKVqBJNq+BoQISA93rqTknRO3MSkmfVO9kB3YP+W/DyN8bwJiDLlJT8ZI2LsFDE+Rl+Sf7vSqQfjawpBKbF0bKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM6PR11MB4724.namprd11.prod.outlook.com (2603:10b6:5:2ad::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.20; Fri, 18 Nov
 2022 02:05:37 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::9929:858c:3d20:9489]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::9929:858c:3d20:9489%4]) with mapi id 15.20.5813.019; Fri, 18 Nov 2022
 02:05:37 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yang, Lixiao" <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "He, Yu" <yu.he@intel.com>
Subject: RE: [PATCH v3 10/11] vfio: Make vfio_container optionally compiled
Thread-Topic: [PATCH v3 10/11] vfio: Make vfio_container optionally compiled
Thread-Index: AQHY+gA3gm/XcLOlrEqwDwOQi8lQyK5D8GoA
Date:   Fri, 18 Nov 2022 02:05:37 +0000
Message-ID: <BN9PR11MB527675C6E99F846D2D14C3BE8C099@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
 <10-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
In-Reply-To: <10-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM6PR11MB4724:EE_
x-ms-office365-filtering-correlation-id: 9fd921a1-166f-4517-916a-08dac90962d4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NjvoniPQZCf6EmPq3uZWmx4jFFLxePVAYrE5dzjXAZNqrO8nruSDgWdwf5rQDqj+xymKuLRImpSnLlfReGTkjxdYX/ELW0boP105/nImlt1PDTwS//DlzGuQbcWGNRV+dp8Yj3l8EOCQ5A75akMEDyebq9lyegaqnunnhcTlitnxGWnRsV5xSqBM2dJIw9PxbTtDPQ4zV7lKnyUSWM7V2RSUeuShCGEGz7rItHDK7frEoiWvXE/Zu+fUsbIZxsGp+IoFDQGcYe4i+bM6alCg4x2bmxBKWBtOqX1N8OK32M8YJxD2b2iAqS/kxKWts4DVEnT0CBr5orMqnPTvQbJWPo/H7oeYiXBQ4IMfwBX0U4uRKTC4vWTCa21hwMQqqymTBzbvmev+dumfpTXX9NdxU0XM/0yceDxrfq2WsnXqGTIl73k4FRjHIE2fuIksAE9wCeZdbkVytaBt8FHrBVVWN8frCQA6O+kz6ruwqBF5AiuKEQKmzmCk+/3lBJ2Hj5ylgRR8h6HF4jjAGX8sAUtMWqP39POBSrIj2QWY88BcwYlVbjDzDi3tNKbt9TIlajkMWxsZCvVmQ9YqvOzdg/9jpp/LnCvKboYiVBroXEKJKYvRKsZTsonPFj9v9Pd7TNFWPXBbyqNMkEdsyUk2phivyp/iEliVD0y9azcSCb8aFEoXpu5tAiKNOBQxmE514w3HZ0JuCi71n7Zty48hDk7kaA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(366004)(39860400002)(396003)(346002)(451199015)(71200400001)(478600001)(26005)(8676002)(66476007)(4326008)(66446008)(66946007)(64756008)(66556008)(9686003)(8936002)(52536014)(76116006)(33656002)(4744005)(5660300002)(186003)(6916009)(7696005)(6506007)(54906003)(316002)(2906002)(82960400001)(86362001)(55016003)(122000001)(41300700001)(38070700005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KjvD5iv3RKyPhWXYhyrpR6cpGpN8Iaq4ulpL8Wrk2ZY2HSILSih39w+VYpVK?=
 =?us-ascii?Q?IZICHicOuk1G0RC6548s8FujvucSRQWmvOgZIvkFbvdHLzLIOQGyXl5/QSPa?=
 =?us-ascii?Q?u3C0uMuaPrjtiLQ5/3GhWPUR/rKG3o3K21ihVPpl7J2llOiUvVUqpyZlnqkT?=
 =?us-ascii?Q?bWdVdX8Ti6Ggp8F04MeKSOYbawY2OX5bJZlROiz+qJU5VSV/t4E0w3hJCtgw?=
 =?us-ascii?Q?OOe3rbJILKYcr8aAw1F58K3BSYBCkBf5/2x0cIukoOESUPr6+bhCILq+Cyeo?=
 =?us-ascii?Q?qqFN2SrhXmEBHrYlcKrXaiGMTi8cfjGE5uTyXZXECEyfIHcY7/3kC5czEqU1?=
 =?us-ascii?Q?jlpDAptVQfPefrxQcHcRfZZnbwMjeLWTNYYhuwwMlqIj5unKn4htjq7mxb8w?=
 =?us-ascii?Q?bA4jT2e7he7oK8xZwCX6brgdGiFsVx5U4uSmIPg8JEyEyCFP09pTw0d/VJJs?=
 =?us-ascii?Q?sLrv98ZNxjy2qVQ38mpPVG7gWjwwpxnN4mqfo2AGP1gEV6zvisz+z0cPrlvc?=
 =?us-ascii?Q?yHgo9amh7j/8sPT1/YOhPJq1hn3xly0H0r62pLh+4aGqjFNGISlwoBk6YJRh?=
 =?us-ascii?Q?L/oV1L8ILcWA2Zwd1Hi/GwYXCmytmT2yoJjQQ5C7tbuABIWhDlPoBynUDV3c?=
 =?us-ascii?Q?qTtgDWs8tI+nS6/1Ah5A+68xIdcdt/Iuuk/AY8+lcJWO2aox9KLFmkJbeX2J?=
 =?us-ascii?Q?CW7OOueBk04e2FDHLuLUlqthQ/H1tqu4JgEnS/hv3/R4lS4QGzSOFE/zvC0I?=
 =?us-ascii?Q?sqCbTFasVLplxfW3rUUagQlr6WwvydcdxHq72oWgOatLCg+repKHsvNOjGC+?=
 =?us-ascii?Q?o6cYGjnlX+lC5Fks6rFTzkw3SyPiSgcONcXFN8hGAQlpG7xs4dhKdlNtY4VO?=
 =?us-ascii?Q?cXepBotY9szpjOfCsYZtj/TQm1+YePoADkb917xpLUNjHfi3Uofk42G352P2?=
 =?us-ascii?Q?lIRhIiMp97eUpdsLHs5YoEQADo8O5NpuwfHVKrsHX+Wf7pqdrAwNRZNplhJ3?=
 =?us-ascii?Q?urPtYzVab2K1k/aN9PRZpVko1iYvKL+oo78juQgwkQwLLxCkC9fYLhxcjP/y?=
 =?us-ascii?Q?gngWGgmxGcu7JqBrMnlBtmVQ2/bHrmRz5bbuTRC5X+QvTvf8mv3qczV9W5AF?=
 =?us-ascii?Q?GoU8gQ5toAfyiM5xeLSBdAvlzuAyhXSeGd0veTTAVRojeUjt21GssPAhrE3F?=
 =?us-ascii?Q?K98KdJ+8+iwyTqoBAM3ECsGgC7XBDymYzIrH/5XNR6kA0ertGfZ7Ylarz6rN?=
 =?us-ascii?Q?FEjZBXcW8trPnzcqbuYHaVb4YS/KwJpFWpuMxm4zf9Vwag7EOsDG64XZVWOJ?=
 =?us-ascii?Q?dMzH9QDQ5ezcGRdeYV9u4qhLJOmAzYowebitERk/sTVv2gS6LCXhaHZEHzJW?=
 =?us-ascii?Q?YNcpgeoff+eNw8LEXWsXNpTe7QPN59R82JeFsZnhGebT43nXzI4UlW86AXBC?=
 =?us-ascii?Q?SXca2NvKrPJh1jj9kuNPKJlAjT0MIO23O7lERwjynO3bOPb7xbQd/st4xF7h?=
 =?us-ascii?Q?VSYnOzbwlTTX1mZ9k1b5GUgS/Gy2lVDg+Lr4erG1ogVfr8t1XyNEgJjZds07?=
 =?us-ascii?Q?7zlYEB/J393idvma8YGk6HUmtPImNAuUns+0fl5c?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fd921a1-166f-4517-916a-08dac90962d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2022 02:05:37.6176
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HSsH+XwagpAYZ2Kc8XM8Pzt2wcGAFDniHfvV1yqhwIKGKE4GEK5CmEaEugAq1ovfuTS/r3BULJQrFqNTD3x+ZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4724
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, November 17, 2022 5:06 AM
>=20
> Add a kconfig CONFIG_VFIO_CONTAINER that controls compiling the
> container
> code. If 'n' then only iommufd will provide the container service. All th=
e
> support for vfio iommu drivers, including type1, will not be built.
>=20
> This allows a compilation check that no inappropriate dependencies betwee=
n
> the device/group and container have been created.
>=20
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Yi Liu <yi.l.liu@intel.com>
> Tested-by: Lixiao Yang <lixiao.yang@intel.com>
> Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Tested-by: Yu He <yu.he@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
