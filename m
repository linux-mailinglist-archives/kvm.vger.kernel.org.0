Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB6CB6BDDF2
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 02:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbjCQBGs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 21:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjCQBGr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 21:06:47 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A2593D092;
        Thu, 16 Mar 2023 18:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679015206; x=1710551206;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WgfdsNHZQCL9XIlUdu54JUjGMB6pRGH6beE5y7hT9G8=;
  b=FNIBRUiYeETuso63uos5t7l0V7/9Uxq60Yu4tWa6Y6BsjO+waYhhoScW
   Po6XMp196PjZ/mTb21hYdpyGSrtvnyJ4PUcXvAGFE5mDu7hTGoSFjrLpc
   UmA0ftt/35JatpIw1b2GHb1KXs5F9e0KEjELixdFjFwCuG2ExGDdspBfx
   uQrLsCYERKdRxOi4YV7ykPeH4EK5h8XoTnq1S5MwOfB7FqgHaUUhRkHEZ
   EWrNUwMeUYqdN89j8f+2wPKCXn62ZPPLNyAd+58AHw+FR0VPRIAAGeJv5
   CO+dJkhW3X0bW8MjHQ//D1i3ISGbHHdvENZM6UkOBk/urXb2YI/1rpuK6
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="318545948"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="318545948"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 18:06:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="823476351"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="823476351"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 16 Mar 2023 18:06:22 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 18:06:21 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 18:06:21 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 18:06:21 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 18:06:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F8Fn8LeFV6Bp0fiqyLxjLZXfAHR/WROQWYzmJm/7Xs+0xD2S8AzZI1I9yzLQ1uhqjAi5Aa0L9npb+UFpkbVkTUBSpwDDbdVJKPc66a0esOVM+d6P9bPD8T2cTNSmlvzWkpjih5/Pje6I9H/N3eHJiBsIk5mdZ5SG1wJFfF903ZTXwfLiotdg3m1VRyfAxLTXWxSYGNemINC0r8NiIXIRdRyTUgqnt1KdtYFCEJeqWo6uYNKE+WJDJ/RVaIMfyjgXxFb25xn3y76a39ckmv7WKIlhB/kffCJb4ontfpxAOo/yn0UvkRLs4YsUSTgdJ+SBi6rptIRo7Fn4yuH6C5NU7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WgfdsNHZQCL9XIlUdu54JUjGMB6pRGH6beE5y7hT9G8=;
 b=fouUhztmPklnRoFAtLeo05SFV7ymZ0N1amlz9ZVSA9uAqjMpKO5rXEQt811EiHGY7tGBbvm3WkahsFkzRY5Ew5modv+3dXGhlrPJNQTm5G4hO4aSr30z3LaZlON3YLtCe3A7lVn8O4XAs1VwOewr+bLs6ehkj035IsBWCd+KpzRKq4E++NGR0l6+Z0LWp4brMHwoDJ/Un9xyfD6lBnvsDqc3N5YuQ1cqP9gvZ19QnFhbElXQVlcQkeMfHqWf9NkYSosWlmdnfCCzaEIAl9fF2HksUiDaFMjCsoGz6caaUEF99nv2zMfOYO/ghzn9qJeNRvTPHYVzwmr4UrqyhkyRjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB6921.namprd11.prod.outlook.com (2603:10b6:806:2a8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Fri, 17 Mar
 2023 01:06:19 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 01:06:19 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v2 5/5] vfio: Check the presence for iommufd callbacks in
 __vfio_register_dev()
Thread-Topic: [PATCH v2 5/5] vfio: Check the presence for iommufd callbacks in
 __vfio_register_dev()
Thread-Index: AQHZWAEFud90LBy7OUmVtjXnU2IhsK7+KUJw
Date:   Fri, 17 Mar 2023 01:06:19 +0000
Message-ID: <BN9PR11MB527699DF365FEB579423479F8CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230316121526.5644-1-yi.l.liu@intel.com>
 <20230316121526.5644-6-yi.l.liu@intel.com>
In-Reply-To: <20230316121526.5644-6-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SN7PR11MB6921:EE_
x-ms-office365-filtering-correlation-id: c11bcdfa-d8f5-457e-bfe1-08db2683d10c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VMIOzQXUOTcCZdp9rC+qYwagaiIQKCB/00Do0SajJ1RGVEQs89G5MXsV0Gyb/UXoJVNRBqNpbFqqg8b7mXPSc0E5KcF76TKFOcxDZPUC9ZvlPBoTpidIV8VsClX5UkAHNS7SFT5qj3Fk2lxssM+cpyHNa4S2t6NHwYL5uTcdmuo0+jOHIBP4vLAsyuRz7OdDosCeNOEs55HtIy5GIyM4XLI6IFiWDUfO3Njvmqb2TaBu1aE2Duj6zju/0L8tmjExj+fVFw+0wq+RpiC+PNuPZ4chk+yHySWU7Kc3nOut5QXLC20mz1K9/fqHGp4oMeKINuuOWs+1fJiTWJ9YQC0VpHwCXYt7CxMRIxupCMZQVJpjyweKEHkManYAJaeEUtcrkluAE7tCl0+VHXp96PQcU+No/dO+RkDA1v83Bw1ojV6/3Vddd1lv32dK/34mr/zbNK4UtpmP1VsFlEgwFR/QuUVfhIDyhOSBCvds+BfyMu9GqkTSW3dC2jVml5tC6J7cN8WAx8eXN9/GPiYKi0m6VR7WjpFZnREeubA6matvDfdxzpoN1f2SBrmR7ESTYvUJ27ZjdT70RNybgWK+lLEeCnToGVgnGQ1CMW2Zj3GxqvNNR9WJodn+NR341c784T/52cXqq8ftG0eEaPSpeb+90vHAcIy3W1yfSdZeJjg7TlHd7hNS7DyTaASwTtFKSSeNInyEUBOTYnpSYkBRF+c2LA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(366004)(39860400002)(346002)(396003)(451199018)(41300700001)(4326008)(64756008)(66476007)(316002)(76116006)(66446008)(8676002)(66556008)(110136005)(54906003)(52536014)(8936002)(66946007)(2906002)(478600001)(5660300002)(122000001)(7416002)(4744005)(82960400001)(86362001)(71200400001)(38100700002)(7696005)(38070700005)(33656002)(186003)(55016003)(9686003)(26005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jQwWZahegFIY1eYt6FiPbSJ5gLQFd6mTJEcn7Ljn373Bf4vnVOQZCMtiRTsn?=
 =?us-ascii?Q?GNrMhbLCqohGIbXu7wHI6lrTSTP/0m3gtkO+pmmA9Ky3FOcnrZNkUdlG1CPB?=
 =?us-ascii?Q?tOqku2iP60LTVPVIDmIt6VVIBYKZLpqizlIajOIRbI+17ar6P6Pbd/4yrLpt?=
 =?us-ascii?Q?E8fGcOazPT/IwRm25su6LpCw+IXaUOLIxifSJnuE1vhtIs+Mv1s/axqi7ORb?=
 =?us-ascii?Q?wljC5z0cvtol+C7IQrHfOVZHPw2GG1tGHS1VkUBnSW8U+dkAqDYpGuu6/75A?=
 =?us-ascii?Q?HaCSzD+PGbtPQzsY0xz0hUSA/WesdVbPu+DXHx1pFtK4nrN76YBJ3/cuu8eg?=
 =?us-ascii?Q?7BkUBj2biYAkv7qjEcIjsCIORNwgoiKwTK45obmpJND+mWb1dyRS8+mNjC2U?=
 =?us-ascii?Q?JqPXd82t4kBNOmUWpWvFUcBGpw0wxx3o7UMVEhtbk2uVklJ1eItAYkaGmtiM?=
 =?us-ascii?Q?Y/gEESqOZA9bXl2CCRYIv3AAfaWv82ktsoudkhgcjbcoMQPN/ARbDjQGeutY?=
 =?us-ascii?Q?vsuHmYnca8Uqe96iQ/FqSokb+zHtwrvJOB3JBF0+5E2QG+ZciCkVTqkcL06G?=
 =?us-ascii?Q?404tgnbgfIuDnxg9/RGj1PXk7jfhyEY6zkaiDp1S74e+d9IrXN5OYbA1H7k/?=
 =?us-ascii?Q?2mQPjnMGR41Z6vc85NdWAyveAnNm5MYUVDh5do0YPxSzcT085+guUTacxgO3?=
 =?us-ascii?Q?H4BVmg+PAUw1zqVEb0ffuLc0vgZEakHfA6U63eE342Us4/dc4v4aMV1XNROK?=
 =?us-ascii?Q?geAffxoa8X1l/PL3eNEjxNEm/jzmoaW7mcgHFhLbbDfqAuteHgumSNvPNQyl?=
 =?us-ascii?Q?6eC5DEDP5Q7HbWmmlwhP6MjZDeAmxDOw9y+CDub0sAWdkJs53hTOMy/db1kM?=
 =?us-ascii?Q?PbcJpPrBsvOqLCoxqJevXum/GnlHj1I24F1sXiQDdz98K6F93zKVS+GH3iZu?=
 =?us-ascii?Q?nJ5PI4JZAh1H3gr9a3Uhi2sEHTSpCuUhKG5t+Vvd0NMTDFu51lBXS5//3boO?=
 =?us-ascii?Q?u01+NdsJWHpBPOx7FJdCIlwDChzy37SiIBL7PZOjRxcH/xTP4y3UPxht13QX?=
 =?us-ascii?Q?H/UWa4El2d0qvYOoPabOqO4x13Al6T3QG9FmwIP58/nXfGJQK2JCus3s2Av2?=
 =?us-ascii?Q?iqI4gO2urhGKrRgNAwUm+KYxYHItIpD218lvcIuHyfiWCHxkY30+KNlVRgVm?=
 =?us-ascii?Q?tcuQlqqqBtj+1R/vmEkdTa4F89k41XCRlarpQt9QnIMAJjrF8yb7g650gN24?=
 =?us-ascii?Q?q8jXENW0f33p57XUx9ppnmhR28wlIQX1D3zmlnbB6qddQaaOJNixzVr7bRgn?=
 =?us-ascii?Q?ldXPbLTyqnkhLxPWN+DDZMHKUicWKNJrRM4mcKdRUxY6G1RUxKQGeSIWYpQE?=
 =?us-ascii?Q?xX+5967aUXwjdBz+lUyqCEazIImAzMtpruCGriFVUY3JWEjE9gTiOr4KuMEK?=
 =?us-ascii?Q?AloBsAPn7lFQrrvJsr74HGry0dwxWTTYSYhcJ7J5IIn/UPeYPUjFFPnClx5J?=
 =?us-ascii?Q?QzyBnZ4HF6+xZ1FGhpk7qOHFPnKQ+BIdMB26Q0EZKAPwecxwDy+iUQAE5bj7?=
 =?us-ascii?Q?GH/PKDtZFeqs3n9KMUhy5Czu2b0b9oE4A385nGDl?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c11bcdfa-d8f5-457e-bfe1-08db2683d10c
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2023 01:06:19.2433
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aKH5HY9shZ3zNd9NSzNIlyfcRAwobE8Cl7/SQxiVEWw+pIcisqC1i5nzuHAC3sAVw3CHR45vxNuX6TBhq5QlJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6921
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Thursday, March 16, 2023 8:15 PM
>=20
> After making the no-DMA drivers (samples/vfio-mdev) providing iommufd
> callbacks, __vfio_register_dev() should check the presence of the iommufd
> callbacks if CONFIG_IOMMUFD is enabled.
>=20
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
