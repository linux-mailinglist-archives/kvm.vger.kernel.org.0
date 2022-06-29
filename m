Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8A0055F358
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 04:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiF2CVR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 22:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiF2CVQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 22:21:16 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB75286D8;
        Tue, 28 Jun 2022 19:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656469276; x=1688005276;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=Ta9jfhtUREV5gk9RUXwYrfWwh4Kj9nu8M1Y2fBs0WGc=;
  b=Fr74ZYzmjWE9s6k32QDQ6XQMNJdcRYeXYxvvy4QQToOB1+u+el+5H060
   8ZbD8P6Lozfm6YQg3MxMluVd0qPt6DdX7idE9xLxvgxe10dPwEIt1wlh1
   WPnZKHxyKnabLEfJUFqRMmP2RPHNgKpqhqWloM4U2FZpXO/Auc+zBliel
   mRD958w0ee/ptVbf5okaGHI/jHbw9kFrJYSkp9/nL2r28HC9p8Qcpvtd3
   ++CMmAwWWsSq7C404jd+SUVIecpd5zFeL59d6oH80pyZtg6rK8Qhw62gM
   Cu8WgYUFLUvXo7YJYgtEErlC7EOBU96qlspNvBI7Brw8i6XTBCwzcRI00
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="307388618"
X-IronPort-AV: E=Sophos;i="5.92,230,1650956400"; 
   d="scan'208";a="307388618"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 19:20:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,230,1650956400"; 
   d="scan'208";a="590520741"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga002.jf.intel.com with ESMTP; 28 Jun 2022 19:20:59 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 28 Jun 2022 19:20:58 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 28 Jun 2022 19:20:58 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 28 Jun 2022 19:20:58 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 28 Jun 2022 19:20:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WKxqhB9r/wfHztei73JSV0Rrvzyoq81s4cF+0qJXPYthyrr58iIZr5HVjMznPB9+TjAUKZkwO5Tna/yD93hspE/mlfRARtXuq2+E8KIBXKjDZZ9mXoRP0ar4YovI4USz9Jm3HZbP92S6gGms/wc+Ucatfw+dy3IMZDkv2pHdo0MYSK3g2aRaGZsOCOftlx92LMFF3Ckn5i1d1SyqME473NDi+8WxDJutdSRQXnLi/iDnpyCPpTUrwqa/s/DJ4EA+WvLa+Yk2wmBXHP1wgiVWOo4Voyrqyy9M0rPmP1x0dKpwCiKiEHGNiabdNZAn/aPui/d18Edd7SW7+ctKxizapw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rPjkkmg8jBZonGj1l3PLb6bUrfsrxg21yyqOxL+l+lw=;
 b=MkJPtrGNzlWQOQvL2+Gj3pO12PSpSIPzL9MY5NLFSYV6cG3rz+KQQ3RVQdwCGty47TLOycjqguGc6spd8ij/eDELeW+vpuo/cHHNNkWAY68LCcJGKHiLffsWmVTWsMgwgsbY1VkfLZn7zym03pSEBdgp7D0KVvjuLGvyHSmQdGK/dFYf4PixPcFR1TUum0/7nUf7+rWEzS0BuDYmmulwI0X/qZho1H3rsMfD4BslWgIxQfFp9rgQOJYaR/EjtszNZWMuvtoqRgL27/yv4efQzYtuWTJtH34vP+1Ip29MQ4y7oh28KXVhWkVKdRQyCIXvvUfuFPBlvlM57K2Idq+qiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM5PR11MB1289.namprd11.prod.outlook.com (2603:10b6:3:b::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5373.18; Wed, 29 Jun 2022 02:20:56 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5373.018; Wed, 29 Jun 2022
 02:20:56 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Rao, Lei" <lei.rao@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] vfio: Fix memory leaks in vfio_create_group()
Thread-Topic: [PATCH] vfio: Fix memory leaks in vfio_create_group()
Thread-Index: AQHYi1yqZSL2uZzE102Le0MZ/4TTjK1lpmAw
Date:   Wed, 29 Jun 2022 02:20:56 +0000
Message-ID: <BN9PR11MB5276C825E2BEEDCB6D33F8D38CBB9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220629020500.878300-1-lei.rao@intel.com>
In-Reply-To: <20220629020500.878300-1-lei.rao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b4b65ed-6346-4cd3-4cdd-08da5975ffab
x-ms-traffictypediagnostic: DM5PR11MB1289:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P+itXmxn2jiOCE0jPo+Bcpx77X1bfXWyO2doV9zyid+yLsMr/DQPCwXnC1A5RZK/Qk5Zcn76EbjRMFuYWqGODtpoceNlgpU91W6pO2AWWqgmBmpQ4kpQoTSVRWLZNuPrGb5EeGnNM+OnayyQwxy/RYzcMu4YzKS9HJuQuA5EkTRJ/mJTtrLUPnbpoc3tRuzvqtR3gvMrQFQNtYpafA5A7geYTYNumqwfM+RxhMQ5euC37FTwyBsuzbP8WGC7XcbNBws2f6OqkkpC3/50gUtycSPl4JxG3XNcy93W4N0tLh8CEOM3diXBPNlTdL93K1I0cPb/r3qCtNUJ0OoFOF364+peh7OcCiCyIJ1co5KR3/UDlPYs5F6HJwjOkWqq4fcVOFGJFKPEjxQqUmH3ONE8OL2LEVwDJ6R//7+TC8ahE+hNUCuAFVwDeMmdbd5DjsnuOKlMADqKJeHBX6WQ19GDsY6sNrezYp6gxbb9EgZUnMheaj6Yku3z+nNZKL+j6Uq9+HwwtEz4SZFOOT1NWf/8VcmxQKHjko9kajMGFc922K9tVVsBYe0YCfL9oeb5OqAq6x96rERaJpv22mvWTlF1a9x54K7V1f1eOlH40nrRErAU9zm5e6HQ4I0YFBRy7anV0Fa1tYrVag470EX+GMnO0RZOQvf6STy2a0bqO5Ep9gyi1NY0t5iHQYmPA9JjT0tseg670ZstLLmfHr6PtxBF0gYBMvzxm4awdKtArffWm4e6ITrEto7mJkeypoS51KzkykqOyIgMWOB1nKr36Aqa6HJti0nUWWnlzjEbyc/ch/4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(366004)(396003)(39860400002)(376002)(64756008)(8676002)(33656002)(66946007)(66476007)(66556008)(66446008)(38070700005)(52536014)(83380400001)(478600001)(186003)(9686003)(76116006)(316002)(71200400001)(55016003)(110136005)(86362001)(26005)(7696005)(38100700002)(82960400001)(122000001)(5660300002)(6506007)(2906002)(4744005)(8936002)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FycXXBtDZQX1KbeJXBaAk47NN2hD72wo6s1fLxBw2kQTiuTOhrIdVA2PBJPv?=
 =?us-ascii?Q?krZv62V5nvq7Vq5u3/t+pQ2qI1FB1giM3MqDAgThJuDHQwOK+U8rxw8uwoQx?=
 =?us-ascii?Q?TR+7lrXyjjVg1XHaipQHusc6meJSOiswDtB3eLDf5caihj5MAiJKzFAcrJF/?=
 =?us-ascii?Q?007n7TRz0kJ+TPwER3H6FIJdGi0PNnMUdX+zcKTKRVw3+V1cM7piC9zi0CXP?=
 =?us-ascii?Q?HEMEI3CiBAvi8jIf+0g7g4Y/YUc9+QyCqAvwIIJjfK3Pz59g4vj5Ybe8C5bD?=
 =?us-ascii?Q?hU1IIZL5Ob8Z0sCzzUfMRoQwFH+o1a+9xgT4OZ5Fnvn3VFxLWMwze7l+cY2z?=
 =?us-ascii?Q?AYyftbrHQC+1yRO/F5GPkJgS5jkwGvkc0UUzbQurFAg3EcQKz6OomMV+Gf28?=
 =?us-ascii?Q?ogw3+XoIMIv+mUncrVN5e0Bv5qvD07eTt/L0gZ75mpCCZR/I2T7b86khqcR6?=
 =?us-ascii?Q?LchvkvUxoEJIHJmWlodvIr2TKkucuDlD98/0lOSC03GLMFW4t/zZfiHOnzGj?=
 =?us-ascii?Q?EBIVRqwdISwRCz86CMsW6a1x+Fa0KJ2vMSq54yZjIsvMC+eIXhq7sH+6vmi0?=
 =?us-ascii?Q?+3XDjfsmj+ZDTbchagBLmCsCnzsglAJvkONIFdZpmYryEhwVNJBM8jlC6R24?=
 =?us-ascii?Q?klr5hD/BVpXjvJiw9cJzO9ccjgLa3NmBvDjzyAkA5/stbsv0UGNpNOAgOTMl?=
 =?us-ascii?Q?SQilrBGh5dy8/gxUfMDALYJP7nzdw0NoU55rFJY8f1QJLwczxEVlag4S0bq3?=
 =?us-ascii?Q?q4wQg8R2o+EOD5wzFkn8nkfWOKHbsbX3q/0kZTQIsYMPccT/S/0SUvs7aGSn?=
 =?us-ascii?Q?mI3Czm6siGftUsOze07i5kG8peDJI8BDXdJ/2q/wfnlJSnzAt5kG1e3fUw1u?=
 =?us-ascii?Q?uDx6A25qhjrLOK0gKdrJR4sKE/CiY76VTQMh9VRfpocK4cVD8LkTJJtj0rYU?=
 =?us-ascii?Q?ox0aNtQd5L2oqPPIfsTBaMicRlYOdnq+wyD3TYSRdHtWyGndSRsRtJizKsVC?=
 =?us-ascii?Q?xsIvU9DdHUb96KJEAg+r4O2SZr2c/kVo/sDHExxavKxiRq2gbpip0xQoZDD6?=
 =?us-ascii?Q?okb82jwTQTO8+/JVm17Pp10YW/y/5W7Ztloc1BRZLer0C3DlX8lyw2K7Xyi2?=
 =?us-ascii?Q?qwQMCusZm4XCtwUzHfUI8I03jY/9QfufqPAPRhUpZY52UxPOM7UONS+Helky?=
 =?us-ascii?Q?hD2IO9Razy7i9VESbUaRTK5Ole+Eb4NlkhbCctDgE9OJ6FYeS5ZFlhRtLWE5?=
 =?us-ascii?Q?VGUWdfjET8C/qATA+0oMjeKc0Z/9zB05P0namLkgbY3ZWwnMDj2pBE8Z0Nu5?=
 =?us-ascii?Q?XXsAlbkWRi/Bj1DjBAvjsK9ixaRRsZ7F560UM7SCdmaU/5puskibSwmMY3X1?=
 =?us-ascii?Q?G+Igw5kNTitcJ7KL9ZJkiLu7bS0TgfAxCCt2rUGl/wvPHBQohGaA5qoJ6KTp?=
 =?us-ascii?Q?i37pDr94UX2Pa7BH7QUGwJG7WysLUeAzjFwwQ8Bbg5LXQbq3PIqRaMjKwjMt?=
 =?us-ascii?Q?QB0hmXTg55jOv0R14viY8jfQLbuNpvzIL56SlH1lHnRy2lhOIhnXK3MLe0ZO?=
 =?us-ascii?Q?UMQAfoAyZ7iDgonl0DMFranRatxRXpPJLBcZ00D/?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b4b65ed-6346-4cd3-4cdd-08da5975ffab
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2022 02:20:56.1653
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uHcU3x+YdAVJCtgrHa+b4TUHC4Pn+yhBIf2jY270fNUk4ZtwoCH5PydEtpxl5GHgEnv/iT9o2rnHbj3nq64Mvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1289
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Rao, Lei <lei.rao@intel.com>
> Sent: Wednesday, June 29, 2022 10:05 AM
>=20
> If an error occurs after vfio_group_alloc(), we need to release the
> group.
>=20
> Signed-off-by: Lei Rao <lei.rao@intel.com>
> ---
>  drivers/vfio/vfio.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 61e71c1154be..2460aec44a6d 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -414,6 +414,7 @@ static struct vfio_group *vfio_create_group(struct
> iommu_group *iommu_group,
>  	mutex_unlock(&vfio.group_lock);
>  err_put:
>  	put_device(&group->dev);
> +	vfio_group_release(&group->dev);

this is called automatically by put_device().

>  	return ret;
>  }
>=20
> --
> 2.32.0

