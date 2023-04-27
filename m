Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE90E6F0189
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 09:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242823AbjD0HVB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 03:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243341AbjD0HUt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 03:20:49 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B5D526F;
        Thu, 27 Apr 2023 00:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682580021; x=1714116021;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=55AVzB8vBZJKdFeVLkPLqcFyBVgqkvArAq7lfVtHTfI=;
  b=lxL+/yMFGncDdVZ4sEQFxwaX/LLlBxX8hko9LdN0+5zdgGxzKMyrpjfc
   tgxcfIM584EGU4lbtFnAaglGX+t2Z3ct0KzjKByKAyM3IBInzt6cewh6r
   4l8BppiX835ValMvQm5sUGnJa7xMRD14KyVoiHKh4oFtzEXwizgeiX41d
   +teoTRKgb2J+BpcHQXD8dlUq0EZh7eC/hj2EavMDK0RRyKhc44n2Eo1AR
   fbxj4GXWHgH+QhHZahLZDNppOoxOJ4ZMGFFqii0Lomrc9Qx6PFGJZVwC+
   P90DLgp0tF0i4Cu9uFuGXzoOG45rxnct1pIuNmmRT3NwfCOU5jC+cyR3O
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="347364284"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="347364284"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 00:15:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="758974780"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="758974780"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 27 Apr 2023 00:15:36 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 27 Apr 2023 00:15:35 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 27 Apr 2023 00:15:35 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 27 Apr 2023 00:15:35 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 27 Apr 2023 00:15:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=flUkaOdZvoSG1CXiC7sFqgjECtFahZ3zHQ+WdtMKSH6VBox8CIm6SjVlS0xCzHJApXk2ogi6ugo43uVsMs2Soy5Oenkgk+03LoHwCCJWW0k7FS92j1GuzY5fs+RZ4MMFikUBScGL5Sxi6FTmiGxWxJcWq2+uRdA/vM7Ri2jUysgj/nYRryzCK8y54DIkoG3z5RVV5CD4Te/syOjAMPqemg5gp3gCplc0mq1ZzVDfilMkmEu4euOslr3vHh5fYD+HcJ1wnsgpQXBh6ZcBAouLCMic6Ena99W9HuRojl/p7XO8nzkLCgu/khZkE8y1ad3rYePfrn4uqvAYHuM4i7FOmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AqmqGpF+qoJb7uUG25WDBqTBLAseou39St4v4PejtIY=;
 b=OPZWwWDmEimeMDTrl71vvJ2TkxsfE6Lm6W6KWQqtQ3kUwNSjM0Dp3mT23fsCVoTRS9sxoQRq1jdK6NS73IWn5CTi3UKpgYE6CpK012FtLI0/c2qlB8Uu30uTxJVm7TCSTg4+RpwR0VYlUi5GjKxKQjG0GtNwECQM+hidrhFXiPxDomBL5HUHuPU0fib+5ktQxfiFCEsDj7+Tvh8U0UsG0sCzZv1AkUlTpz5PsiE/gFSeqnrO2XfosJS4G0u4t2F3rm8ITxwNFEfTGuUnbNOK0Ympo/C/qQxyY9MyMq7z+lA7nP3gXvWS2i2pNOsOJ0W56+/FO72sxAZbo9VbnbxeAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA3PR11MB8120.namprd11.prod.outlook.com (2603:10b6:806:2f3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Thu, 27 Apr
 2023 07:15:32 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6340.021; Thu, 27 Apr 2023
 07:15:32 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RE: [PATCH v4 7/9] vfio-iommufd: Add helper to retrieve iommufd_ctx
 and devid for vfio_device
Thread-Topic: [PATCH v4 7/9] vfio-iommufd: Add helper to retrieve iommufd_ctx
 and devid for vfio_device
Thread-Index: AQHZeE8P72Ee3Ccf6EWlyqwD+oRkCa8+tyWAgAAGv2A=
Date:   Thu, 27 Apr 2023 07:15:31 +0000
Message-ID: <DS0PR11MB7529CA3460856AAB9CB60923C36A9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230426145419.450922-1-yi.l.liu@intel.com>
 <20230426145419.450922-8-yi.l.liu@intel.com>
 <BN9PR11MB5276819E5A0D37CD20300EE68C6A9@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB5276819E5A0D37CD20300EE68C6A9@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SA3PR11MB8120:EE_
x-ms-office365-filtering-correlation-id: cf4c2d7f-b0b1-41a5-d5f2-08db46ef3004
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gVGRAiwGc/S92on7Ul0BzZRlEtUapW8BAMJuwqVwM5nZcIozt2uE6bAukslwXmBdHi7OxC86URs8M7FXnVDcAf6h+aGPTJpGVtv8qYymMjCA4BWS2WjsOQt0hV8p5ort2nJVXM1h1SaA/vHIvnHXSvDDH2bXODnjCoJnMXR3fMvMgjuFeV3Goy7QGRKFPmabS9g1Sf6HJTA8C771ONxAdY205RHJZyUPLYzWkYTPi/hP5VCvEN1ZJdNDxjnrqmWO6+htm5N63Ri/67nVrXq+dNAypyKOiRxsdMkLPZ10aBb8xnDOwJboz2BrR9uMyb22SheU49d8ZjfbjQU41XCZH8qQL16JJ3sSUNypz173Q/NY5EDtJi5OiRXDa2IFpUkPkfhfjwiI9vO5WqDowhrw6osQnxaiILLKBsiZhSW4YjUXQQitIbvN51/8nGaNy1QPg1+eR8a4s9x2CzonsnAUCbtrQzJ50L0vIP2RefT4jJM+3+HVLJBVZ2L8ke9Z2XjYcM34ilWJaRpe5OjWEiYKdjFtTCEq3REh90OBmNd9kIqP0Q0hG9ku6PA9l/C3l1PAVMJ6Xx20DFH42rBWXWRMbG9qhmCqwHK4q+dIUpJhKWA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(366004)(376002)(136003)(346002)(451199021)(38100700002)(122000001)(41300700001)(2906002)(4744005)(52536014)(7416002)(8676002)(5660300002)(8936002)(38070700005)(33656002)(82960400001)(86362001)(83380400001)(4326008)(55016003)(966005)(478600001)(54906003)(110136005)(64756008)(66446008)(66476007)(66556008)(76116006)(66946007)(316002)(7696005)(6506007)(71200400001)(9686003)(186003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?z3AnT4eaatHpuJl1IUe+mWtIZkZcj+RnlNXbXdYCTBStKeL+FScCuNcW3Cz9?=
 =?us-ascii?Q?i1EdJ+rbM/dR8OxwNQP4Rc3j46FPQokWcGhJ28zTmwAOux1Q9hXcgjrypbfh?=
 =?us-ascii?Q?P7n/jh5+2LYPQw4dLO3T0FNGEpqOokXqIgEOAfhN0DVo049/yiEjeSUpE+GG?=
 =?us-ascii?Q?oedDjH7xmlH5Bc+TSdgrAuVLe7uXoug/Gvl9TnmgLsX2tEJlLtqPNRaKfbE6?=
 =?us-ascii?Q?7wz8/a3XhLx4YYQFDoxIFWuH+PMB4xHiAw/GtOCpa960fAhwZKQVco410NdI?=
 =?us-ascii?Q?gT8S7UatNIpuF2fziKogwTQGfdjfrEV0oSY0llZOTyuTsvY0n2wmm/OvFYy3?=
 =?us-ascii?Q?DxFqbMeaysVGDp/mxXvy7xKlKu1EyE7HoUG3YjQkytsUYDBgvXN851m41skl?=
 =?us-ascii?Q?zkKcLwo4QqK3huRvqdFjUwq7EVOFKqvBjbGDzJ1QES7lEqVsKfaLn56miWfn?=
 =?us-ascii?Q?lDEHWzgovSn47Im1x0qq0bqT+df8YOuNBC3Y/0l+e5Ee2INXcpMpmNATKGPq?=
 =?us-ascii?Q?tyzujiRRL1tdEFasX24oTjTDl9mWroqqtHPXYjuTMTW23VAQzP8M4xWLlyuy?=
 =?us-ascii?Q?5mHolUIrmpbm53odoGtMplR6GU0MvOiBNv/ZAhrIBP7LnOOPZIL5ZGfcyF5C?=
 =?us-ascii?Q?xG9DnIm1PP1XMHwe3Q2w+5RY70n6RNQByriHyrbPiDcERLPjjQRYsoMqgTSe?=
 =?us-ascii?Q?QWqrsnk8zaos6Lc4XznXtsxF0uGvDaQ50khzQUpP/kcbcrPHWgnOZ3iv0vbb?=
 =?us-ascii?Q?at8cBVBMP9ykQ6kiYhpN8m7Ocry6Jk/dI22bjRD39+dmEeczhDZyHioXkuaV?=
 =?us-ascii?Q?zNq337UE3hwAseP0Msdlxl4Vb5xI1NQ0cz2vqGi/+VjVS24t0lNuFDYeE3Tb?=
 =?us-ascii?Q?MCOXMQ+/OlvAzGolrDkClbrmp/tt/42rtb0ZBjlma20dan2UdlPNRLbtxkhz?=
 =?us-ascii?Q?F0taGXT+PnroXjE03Huf+j4lC/7xh9GtfKvb9F7IwPLNnIPoZd9exa8iq3mp?=
 =?us-ascii?Q?flUqwlvbtMyKayHmWzLQ7HVFbW2mUk+Yj5Sbdy8fHYyJyYNF70SiC9ZuFyGo?=
 =?us-ascii?Q?BTJu2isw4YyQbEJ8J3QjJw0v5j7bbbhe1xZy1vhzIhE8+u99LUl8WFQ07ZyL?=
 =?us-ascii?Q?MKiyjGpmrmEVpZ4WqsKUQ5Q0mGCP1T487W0HslfCjZPekmCHmGe4rnye9KY4?=
 =?us-ascii?Q?acc+tRNNOg6mzBb2UdOwuTuf4dspJyTZdsoGdrxL5d9B8NSsnox3bDbIfIg+?=
 =?us-ascii?Q?vBumUDrj5zJL+9eK72JocjadAdJc+CSXUPSZC7M9C9UK8ftjwvDpD9DDp/7r?=
 =?us-ascii?Q?TSqMGqkx11enhriV3l0bQLeYwkR1eDmmEqM4wYsemVc18dVlAQxKkcJnF71C?=
 =?us-ascii?Q?7oLpvw4qzfVH0pT5aFzxjI9XVcMECQ0+6ceSBjp12PjYazvLqNDqVLeLLRJ2?=
 =?us-ascii?Q?tJ24/rNDe7LdFSjMmxTcS+PVj0A19EyCAfVvKQ3Gp1K2tCVc2FSjhVkDwMMJ?=
 =?us-ascii?Q?JpkPmrd6XlCbLunITIo/7dAAnq4qSczKe9uOaYXp/BhwdiMsfmZPIX+BTW1j?=
 =?us-ascii?Q?I6DU1c1ZYKBz+2ddJ2w7lLxwKRQaq8Fc3rDpLKB9?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf4c2d7f-b0b1-41a5-d5f2-08db46ef3004
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2023 07:15:31.9307
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H+EDcPXTufTgEX8VOnF2/LSpAJ0JAYnSj45OfDKYMV+IfXU5/goSsHKzgmyYpG9XwSjxEkEkLqPbLgGSHlfeLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8120
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Tian, Kevin <kevin.tian@intel.com>
> Sent: Thursday, April 27, 2023 2:46 PM
>=20
> > From: Yi Liu
> > Sent: Wednesday, April 26, 2023 10:54 PM
> > +
> > +/*
> > + * Return devid for devices that have been bound with iommufd,
> > + * returns 0 if not bound yet.
> > + */
> > +u32 vfio_iommufd_physical_devid(struct vfio_device *vdev)
> > +{
> > +	if (WARN_ON(!vdev->iommufd_device && !vdev->iommufd_access))
> > +		return 0;
>=20
> is WARN_ON too restrictive?

This originated from a comment from Eric[1]. At that time, this helper is
void type, hence there is no message when there is no devid. Now, this retu=
rns
0 if the device is not bound. Maybe checking it in the caller and warn on
there?

[1] https://lore.kernel.org/kvm/702c2883-1d51-b609-1e99-337295e6e307@redhat=
.com/

Regards,
Yi Liu
