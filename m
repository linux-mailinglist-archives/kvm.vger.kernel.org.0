Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD2D5502138
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 06:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348782AbiDOEYW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 00:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236647AbiDOEYU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 00:24:20 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA1559BAC0
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 21:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649996513; x=1681532513;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tHGTP5W0iU9FRV4W+HRbmFV35E/pLFZRJooDkyZUFnk=;
  b=Ks5ujD6+qf4EnzlvBlZL+eQRtd8Z+8VCglrSREg/eUkOFlpLmnFbz/KZ
   Agvg8/YJM4neR9aBJ2nlMe7FZoRhxgKJMF9oVjNGAW7wVEhC6UkNg4LYf
   E/R/R0tDfPSle0G9Lus6nUYVScWJuBhw4SACaZUv1K0eQeohCaN0jJMSv
   LuMHijhwxsu1aXF597xQ6o88ghm/BJW2yCIc0Pn6GOfNdc++h7dno+fn4
   uo64ouRUIZvR5QCkIreFIxnVGV148jao8NfEAouqPf59TT3mnyZiHExMq
   yotSf+Xfq8TSfgvOX2g8rEVhNyCsI1Q8+vnD8uPCzddHBH2j6FYb8hp6v
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10317"; a="261935229"
X-IronPort-AV: E=Sophos;i="5.90,261,1643702400"; 
   d="scan'208";a="261935229"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2022 21:21:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,261,1643702400"; 
   d="scan'208";a="552997855"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP; 14 Apr 2022 21:21:48 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 14 Apr 2022 21:21:48 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 14 Apr 2022 21:21:47 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 14 Apr 2022 21:21:47 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 14 Apr 2022 21:21:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BF8AaOdEz6FfSwDp3Vwij3rHiB7NVLXLksar1Ug2gT4OBEkne4qepsMju0QsYngTk49l6roas22vUZTrH5nWZ5Vka0nDoziwnQsxEy5nV3nAvh7QnQJPEPM5T+yRcFtL4/mOtIL1Biu0xpbynpxFnHUPQKR+O4KGfZgw5KuVKSYqcw2EFYI+8FjJxHcy9OtlVGpJh8RRM1Kcwo0o/rdYqVS/ZjXF4XflPLE+f5HQjMsTO/wrKeussqywhzxll2YFrbbBzk+FKNd4EoE3DaKT6XTQb4dGJXSG/WkRWCY9jorF27Qgbb634bQcbgaDTVZVs8JIU39tNYp4S64JV29xlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tHGTP5W0iU9FRV4W+HRbmFV35E/pLFZRJooDkyZUFnk=;
 b=E/CGLQKDaoLIjylXdNZlNSigOiKwuC2q9LO9bhaRj/kq4WGORd4ZEp4sz50j5zmQRFrB/Cp1Y4OK1Ni4xK6W+CY0od2/lMzvD6ClmphxL2sWfbXTq5qlLh6tIe5hDjDaYdenNH4cCMu2SEgJ4JtN7KKlRBXJiqulIg6pXikDrHsy2dsxCS+/yJHQljyohNS2Z3zIaS5ZFHM0HyCgPqa13FKi0QV5PgwyihiKfOWGRzePCyBA+aT3fedC3kqD9lZSNNggGAG5S/80Iw8i7NwM/1F30nTSuVskmqu9+mGXU0KYRG+mYocxEx5b003BSFAIVFkk8Jc7jNo2YraDabdO7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM6PR11MB4249.namprd11.prod.outlook.com (2603:10b6:5:1d9::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 15 Apr
 2022 04:21:45 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e%8]) with mapi id 15.20.5164.018; Fri, 15 Apr 2022
 04:21:45 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH 09/10] kvm/vfio: Remove vfio_group from kvm
Thread-Topic: [PATCH 09/10] kvm/vfio: Remove vfio_group from kvm
Thread-Index: AQHYUC/7oxrMq/lk40i2DwOU5MPLw6zwX1Uw
Date:   Fri, 15 Apr 2022 04:21:45 +0000
Message-ID: <BN9PR11MB5276994F15C8A13C33C600118CEE9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <9-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
In-Reply-To: <9-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6fc48514-9a72-4f8d-ec16-08da1e9773d8
x-ms-traffictypediagnostic: DM6PR11MB4249:EE_
x-microsoft-antispam-prvs: <DM6PR11MB42495035BE7240C7CDE7F35D8CEE9@DM6PR11MB4249.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mb3frZ0j1NaVTDgjWm1HRL7VBTcQpf5OgVGdnIamGgvrf40XqCvsEJRw4te60PkYzZQTGPXSR0QClsrBn0j0k4DS6aa1aVYl2QsBGTFAJpsOzQ1VKF6tA0RSMVutZMOkwrrmvSK6ftzzw+gqyfTHx384Dmpz729KcdyfGUFOstJG/CB+4RYFpg2NkiyPTD5OoE01i+43jfigsZWyC81jLFu2zqP6VxZLy8PV7tKOmhMTScnuzAUteGW4mgR/f3xEjsrTYIQnmVUixHlelFwvglCv3Up0a/v+sC7eC5bxTyQRf5u19ctSDPukxnr4gFPBEm75+TF7elTWgRs0NTsyX1yMb/IyEjJ9liMLDaWJSpMp9ZgUTfNVRZEEFezaa20hZfrQz6X1KXfK3yBcUJCLT7GF8yZaDpGF0kDyYxqLSD2UVI+VXQb4I4JrOT2GVsFl5XWW+tOZYlNRCG1eHK2pycJBfdBfeKcnoHa53csHq0vTRfvWSAec0BGMB4pveY4cQa/W/Y8jdhkYEGmClBqHb7YaACsC2SPbC8VlX6rQIrVqaOLCBS8kkSHQRKNxMrCel161wU8n03znjVKXbA9U11why6GAR7fzJp1EXHj/zapvCddAnI1FBFj6fg+1J/zBGNT9+n0vpTfV2sNM6kMZ9cPCibE1AOITrtWHueuionfL/OeLEtXYe1sOP4eC43WPgoY7d7X7zKA7v5pn45cyOQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(8936002)(186003)(107886003)(2906002)(71200400001)(82960400001)(5660300002)(7696005)(508600001)(52536014)(4744005)(122000001)(66446008)(66946007)(64756008)(316002)(66556008)(55016003)(4326008)(76116006)(83380400001)(38070700005)(38100700002)(66476007)(110136005)(54906003)(26005)(9686003)(86362001)(8676002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?f/rN6b4RLLpFbGinLtyCnSHtkdJr6MAN8qsKuTwQ460XEyjd/1gk2Q2LLfu6?=
 =?us-ascii?Q?AFWGhnF/LMTyjtcr9KjhZuzOURh6WIemBwCm30Y0XtOepwegmcmA2RsLT9eW?=
 =?us-ascii?Q?NS/bq5aqdCZqRW/btXO+CMPeCOcn9HFluQ20hP4IahQFGB8n1kfmZ6BQEBTT?=
 =?us-ascii?Q?ssPYPbzYjksAzuX+IleDCP8I7w3V3KnPKFB/oE7KNfSr5L8QWYf5zkUjNYfb?=
 =?us-ascii?Q?Uo0H/u6hBGtAnP159C0Rbub1eljcPGI8HccqkJmw9jcF3zc85DzqrEMyL1oU?=
 =?us-ascii?Q?ChkaqGcgxu4fewguXo5i9+x/968/4VZPOV38ojctnRTJqmVFLdsAcAbk7YGS?=
 =?us-ascii?Q?k9TxTm9egUhbBayynqU9NbNH1vag0mj4VMibsoy5KeRDHihNNlzCcin1wCI/?=
 =?us-ascii?Q?zeyx8UmedOJmNp7PaN7wc4WZ9zHiRpEt2wR/3enXha1+JDxbwYdOSOmYlfBt?=
 =?us-ascii?Q?OTlj9G2is+e4zYJQKKTgRlxB5wVGHhAnk1M2YofiwX0eEyCkC2rAmOrSGSbz?=
 =?us-ascii?Q?MUljqp5nTxSz757/3lYKL0pmG5DlyyA3k/vFe+dGio8HtsP8DwFtSltJzqZe?=
 =?us-ascii?Q?A0/o3WfclVjdbKftHSFuv2I0UjcFavM/0XFIZ70GvUzLwLxLnKH0YljL5eGM?=
 =?us-ascii?Q?SX3DbNugpfYw07r1AGZLpJ2lv+2ho+bElRUZ+mU+oHM19aH0o+ZJ30QCQjsa?=
 =?us-ascii?Q?vV5zFr1JTv4sw9Gc6y9oETFkFDWSy7HuqTc/V9/AO6nXpSuyi7jIw76vb7St?=
 =?us-ascii?Q?T5mdfeZbnZf0jP1rmq+Lc1AEia4VIlEmexJfQkC69uMaXcuoKAvh5gmk4/4E?=
 =?us-ascii?Q?sye1Exnfws1WBDYKzrUbaAUam9YFkjLujdrrGSNcRYH4fuPoLY+5vCS7WtgO?=
 =?us-ascii?Q?oN4DOL0XMqddpvIhRSOLiHVXG/qA7B6FHwZJ1HHMSy7Ptt+XOuHpRtsCYYH5?=
 =?us-ascii?Q?SSf4WFCZizTmKH7hPKR255Kb215bhOzgKve9VdFjoSYsaBKd38sDXUz7H5g0?=
 =?us-ascii?Q?oW4a9sg6UrYBXjoNJMjiJYblEOEDvGhg5OgAnpz7gqFfwtxmt2rnZ0kzITnZ?=
 =?us-ascii?Q?/d5ezVvu8fnXMC2JRcGabzOzk0ZTUU4kIeWQ1L3CtUGLL8hbuzTocac8kGu8?=
 =?us-ascii?Q?e8qeQRBv4ntPgOrihr5SIZoCGt7ZODOrIfyGP1GnqU30Rib0svIjD4d2OvC1?=
 =?us-ascii?Q?q2JpUPfkhBy36cXejrj17IPXHzPqGk1AxyneJobC0iePRT7gObNOe4YysUzH?=
 =?us-ascii?Q?BOAoMC0Tfp9Te/tAaCqZYKAj8/UkrMKXTtBlT24hRWl/DfZBA58+EByM2Ul1?=
 =?us-ascii?Q?h0PMk2nNUIoRp7OwUIyl/lzVQgBPvNT18LZXCWo+mwXr7bjTgUcbOxWk+ade?=
 =?us-ascii?Q?aXwrVZFw4c9FY/rPsiEcROjCRv/ItpqrcL9oJk66zbQTaEOaZwKXjBQ3Em8A?=
 =?us-ascii?Q?tfcP34i49PThSDL/8RsbGeQwcOoDsVU0fuR4WyE2yjZYUK+8IMaFkAwWWG5C?=
 =?us-ascii?Q?Je/y+QPA93rNcMA7TDOo1zrUtFsdAK0VXMzT6QeUkMbw7DhZwE/hQN3LGBye?=
 =?us-ascii?Q?axU6h1Zk1k8fd4Jq0dSdrIhMFUcjvXCzVoyAgvkRoajdVrHqNWG4zr3Y2Wv0?=
 =?us-ascii?Q?OEdqMd5kwXp8N44tnNUT2P0sSbFRrl5A72ex5Z08rMMqZ20pig6o/AufQUsj?=
 =?us-ascii?Q?UrTD7bhdM85/xFBxAFo3lXB9yXugxfXI0qXis1ScDaSRsaMlEICgM5j3jKGY?=
 =?us-ascii?Q?1WDwbLv5kg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fc48514-9a72-4f8d-ec16-08da1e9773d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 04:21:45.7588
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zgQU/9hCAoYRUUUxuzXLi8b8nKxzkOCk4OuX6ghad3rCLOkbZEANe74WfuSqs7txIBJOaSlM4CkSELNCG+U4Dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4249
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, April 15, 2022 2:46 AM
>=20
> None of the VFIO APIs take in the vfio_group anymore, so we can remove it
> completely.
>=20
> This has a subtle side effect on the enforced coherency tracking. The
> vfio_group_get_external_user() was holding on to the container_users whic=
h
> would prevent the iommu_domain and thus the enforced coherency value
> from
> changing while the group is registered with kvm.
>=20
> It changes the security proof slightly into 'user must hold a group FD
> that has a device that cannot enforce DMA coherence'. As opening the grou=
p
> FD, not attaching the container, is the privileged operation this doesn't
> change the security properties much.

If we allow vfio_file_enforced_coherent() to return error then the security
proof can be sustained? In this case kvm can simply reject adding a group
which is opened but not attached to a container.=20

Thanks
Kevin
