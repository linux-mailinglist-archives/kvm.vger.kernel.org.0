Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9282562C5E
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 09:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234394AbiGAHKy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 03:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbiGAHKw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 03:10:52 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D76568A1F;
        Fri,  1 Jul 2022 00:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656659452; x=1688195452;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7xdf4ZnjzdWZ1FqcK8UcEN6070uZyJmegHGwZbPOlGY=;
  b=Zk+ie9LGxBpXzNo7XdjLjxXL9v0axVn2OyAyfdFFz1b5xBC4W5unbQl4
   tYf7gQh3nR2rWUEepXsDI8UjLN+GqUTjjkXiEPDqBn0Al0ZnlLLwfw3Ae
   3/OmkiP07J0oCDDiVQAmMzEQTcMgFoGwPbC8GatH7C3uAM+iqcfcJwVUe
   dVrvnSmhs9VSSGqMJeoankdSfJYI5yOAe00b0kagax2qycFkb11W29Ibd
   D2RnH+B6DhIOOR/zHgvicVNLymJZeZ9poF2AB6KBNznxIwgV92KW/87+I
   UySwXKoi1wTTJS00NKJEdcvpGuVVzAEINhchuB3i2JAy0TqByNAFefQG3
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="281336636"
X-IronPort-AV: E=Sophos;i="5.92,236,1650956400"; 
   d="scan'208";a="281336636"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2022 00:10:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,236,1650956400"; 
   d="scan'208";a="541634686"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 01 Jul 2022 00:10:48 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 1 Jul 2022 00:10:48 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 1 Jul 2022 00:10:47 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 1 Jul 2022 00:10:47 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.44) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 1 Jul 2022 00:10:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N7q6NJADq5WVDwue58mvj1gZDO4ZXAkClAnU1761GuR3/DsicgA48v/VrsvY1ltxsquuNbAKrSUdni1vF7JNWczEIQ0eePDd4PKXM/m3BoqHS6qd5X8OQ+vJYnAQXk6iuFrxJ+YFrW6mZ8MB834onwUSWOFxF/3Nt4UNQjjJ/CUmwt703gQRr0d9PRgHk6zlPCHGpSPqtnsrk69WQQZcPtRlXlUzILhEib/qElS+029VDKPwxKwEJqkcJBVPjrsHYifeiwSgSAKolJWYv2VEPD+Z2xcDR8G7jtkgO+Kki+OL7IFvvZs/ure/OJLSX8T34ykZusB1aSOrZxC8ygPf4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7xdf4ZnjzdWZ1FqcK8UcEN6070uZyJmegHGwZbPOlGY=;
 b=i5ROzc3AkO/POGfPl+BvRq2HAzXov9efPmgeuhA3axE8PRDgYGRobWeIld/2fYY09qGUk6funLuLPhdOWbCtMoCDU4r+XsBQbiI4kAYpJv7Ba2rHLxkiWPrpT84XRCOGm72KdJKWlYO9dK+Hvv5VkWKuZgRxy/ySGZ539Y2pxSipos4SCGOsQhBbxD7t2IZ3H8jeakGOXqZSAmZ+9i5whcvSAtwHAfGU/lGKUJBQICYKxLHTAH0//AA5OSNEbvymAV01Cfec4qY5tQ8OgcIkKIfzCuvjNETYwlU60mKADfbx0Ju9pGD+F1veUQ6Whm0lAasj4uq6yub3B3+7E9mY6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5894.namprd11.prod.outlook.com (2603:10b6:a03:42a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Fri, 1 Jul
 2022 07:10:45 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5395.015; Fri, 1 Jul 2022
 07:10:45 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Robin Murphy <robin.murphy@arm.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "Rodel, Jorg" <jroedel@suse.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        "Alex Williamson" <alex.williamson@redhat.com>,
        "kvm-ppc@vger.kernel.org" <kvm-ppc@vger.kernel.org>,
        Nicolin Chen <nicolinc@nvidia.com>
Subject: RE: [RFC PATCH kernel] vfio: Skip checking for
 IOMMU_CAP_CACHE_COHERENCY on POWER and more
Thread-Topic: [RFC PATCH kernel] vfio: Skip checking for
 IOMMU_CAP_CACHE_COHERENCY on POWER and more
Thread-Index: AQHYjRJW3CSa5JgkkEy1u1YUe1sfEa1pEyjQ
Date:   Fri, 1 Jul 2022 07:10:45 +0000
Message-ID: <BN9PR11MB527622E1CD94C59829D5CF398CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220701061751.1955857-1-aik@ozlabs.ru>
In-Reply-To: <20220701061751.1955857-1-aik@ozlabs.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f268cece-246b-4425-f48f-08da5b30d11d
x-ms-traffictypediagnostic: SJ0PR11MB5894:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OvzJ/qJG/5c0oicMvuMUryfWNeXKhNTENT1sG9X+FhpYrqBcWou8U6uvMxEEGsOjB5AMRJO+3ziquoQDn7jMoBv5mCixJVmHpNdH3XxWq92hMYsk8MGQP3Utq2BhlqzorNan/PfbPUputLV0/EqtpNCI8Q9pbIEvQ5xhGY9tDtVKX72WMQ3kEQ4qQVHoRpGJZaAoT/CkFpcHi9MJ5hCuC1dEYKaZ1wSrAAPPdVrelWomtODTblsYRQ0LI9zlVcPRqiRxtymdO1srGSmlE3pw/zu/v+p4ANht5V5vsoLEWJi7WFBoGs+Vzp5L9ppur8xYWu/V9xfathm3iN6BhqqNE/ZGt8581ySFtnN9pU9rmK8meGc2kp6U646pO6V4BloyPgXhLIH+SjAYLlN1VmAg1Zt5VoW6j90CZm2ziLwdYUs+i7hgbB4U9XNwVvFXOt05pYc99wKGdA47MARjJzuEXb526DjL2MqEoSmj0YfYU55Re3Ia7qtbGyV6bTpNb+bttaQV+j7G08atx0zDeX7nF2mwJbEulhNpGyt1YlQbRZdasveeYBbka+u5aVK7TPzOD1iiEjgd2PCj39yCAO9ee8czgcXMTIvz7YG55XKDvqmbz4L+t5AOhkLA6Y2XqUfrnw/ifAILI/zg1G9GY9KWbxN/eLqBuNJj7TI6UCpGYgpZzlOnpfq9JZGFqZap4Q10yq9ozo8NW/FKVgKKE5cGCY5+BGx0FfP+cXi9aHGMnTugGY8nn6XGVsgilw9l7IIyjVNrPJMcKkhGQQHOgY4D9Sw/VhTSl3hFml5zFQk5YsA2yXy24noK203XxHZ1nLKX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(39860400002)(346002)(376002)(136003)(396003)(66476007)(66556008)(66446008)(64756008)(4326008)(8676002)(66946007)(76116006)(316002)(55016003)(54906003)(110136005)(8936002)(5660300002)(83380400001)(478600001)(71200400001)(9686003)(41300700001)(52536014)(26005)(33656002)(6506007)(7696005)(186003)(122000001)(2906002)(38070700005)(82960400001)(38100700002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?J/NM/zoZcVEVqYnxB9f2INDBrOBxaJY5e3H8AepTG5C5WDttJKuDilWnCLbl?=
 =?us-ascii?Q?ast5f0dFu5yLoCAqB1gzd6wikqn9THZFuwSFKHnXDvKBJSaeBpDdSvcFH5RT?=
 =?us-ascii?Q?8VKU/Lo3HzfW5tR4n14myP8/C/NhebMzXyRbWIQ3hWXqOCcM2YdUYHXbbF9I?=
 =?us-ascii?Q?V1g1Z7f2NkH4bEZ5D2naKjdeKuGhcFyskcMUjaHJuuKctw756U9OvMEV7AVJ?=
 =?us-ascii?Q?KrH27qtFS4xwIXecsrV2UrjbjZt+z6WXqg6lTSsUVS0/85EGpweQBYPbqOnP?=
 =?us-ascii?Q?tiP4iZU9feaQ0bjBaGHKObHeQ+WR6NvLOJLuLY+zBmKMllIawxNlQ7+xDoZy?=
 =?us-ascii?Q?t6aKezPtW3MsPfXnQ1nsoxfgn1hWfGYKUwkG7qivbcmwtOMvZdTYAP7gaQQW?=
 =?us-ascii?Q?5nyIs/LTn8hNMqr31nMKtpDFBtK+D+XJCGV7Jp/Ml1YQ8HZgLCnRqFz9YDeJ?=
 =?us-ascii?Q?AQkdkPk5lJM+0BuQiqZMwomcrDrLqMEHHW9BoH3Crq1W1MQ8uoNmoAc2GVHi?=
 =?us-ascii?Q?EB7nEpTraGtYFUnMsqErkTQVghvDUpOCsm4f8OCYY1vGyUUnwE1Db9KU2VD+?=
 =?us-ascii?Q?+1Ofy/3gWR2z/yGaTnum4dS0Png0I9AyvPjvaOAhuiddxtyNh+3+vp+SAD4q?=
 =?us-ascii?Q?BsEDxaoAVZAZZCiUkE3+c4NpP3xZAK1h0TP8otNTk4noqA/K0eJ/tecCB8bO?=
 =?us-ascii?Q?GjxrRIjaMCiXvw6ePQtLyxKzgI0fQOKXZlk/eTZlCJrCg9TLbxcl48V0mSbQ?=
 =?us-ascii?Q?pIGfFsq21NZm8i7ED6rzle/YuSdVyEFdBb5k9icCBzlEJ/JbwILzJ5+bhjTa?=
 =?us-ascii?Q?rxtkCMc6N22oiQJr7h2hELDsSKRR42878HH+oi4ctlazUl5y1PAqFAQ3t48k?=
 =?us-ascii?Q?PTxqrQQxc+7qAAQZ2BSXHQd1zGxr4NGI1OoI2V7fHgvazfYmh2WtA55Q4LJz?=
 =?us-ascii?Q?uQ4uFK95TvpDMl0n2AyEFXT49Rqf4ekrLpUfY8nj80uzzqAEHv6tK0eTczQT?=
 =?us-ascii?Q?sI0PI0Ve9ZkGY36IbeJDQBXpsvzfr7ufwF03iBUOOgVEcfuPu9m+4oK+EKse?=
 =?us-ascii?Q?VNaTOfxWnVPhmDdYr2g+c2JHwje7CCFlyVjSqbp79adxekZv2SUJ1/kQZYxi?=
 =?us-ascii?Q?hX6CBIDPsoccZWN5hqS9eNMvYmP0dSXJsCO3y+6YkamF9Jg2Q6lQlDqZJNrs?=
 =?us-ascii?Q?osSUYb1r8lThTXWk73/0P/Ik8+CUovQ3gUFrjb3Yq1MZp+wvraeOkd1eWh5v?=
 =?us-ascii?Q?sfIV65qjO/v9xx0+a8BjD+Smr/NQ61ITTj5rHeKcMbNa/XOVpuy3JVL8BUYt?=
 =?us-ascii?Q?2AT5PmNV+QQ9uMucvKRxeaiZLrpartdiwDrfagU5JxZ+V6hYPySy4JLXe+ni?=
 =?us-ascii?Q?woDoFXV6KbH5xdp0Qe1E8ZPAYFIr+LFEch77yHm7VOussqh5AxpuAT2ONWg/?=
 =?us-ascii?Q?36M7gr3MiXl+CmC6fbthTo6rFR4CGSrhJ+0VkSHQEHvHtxI+xjSRmj8Ka0Bn?=
 =?us-ascii?Q?bzVrBx2fNo1eI1+UM0+0WJKMj8y4MoGs/mMgmn+yEt4letA23LC/wYB+G41v?=
 =?us-ascii?Q?ldRF+Cfnf9wWSpK6COMHc5FiQq3AtDE9u+Di2XDL?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f268cece-246b-4425-f48f-08da5b30d11d
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2022 07:10:45.0836
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q8TyCgva20MY+xLK2QT0qWLX87qz6WOK6xYJFDw7bjUkhm2cmhfr5LsA2DOkccph21NfzanC30Md8ME7JYAJow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5894
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alexey Kardashevskiy <aik@ozlabs.ru>
> Sent: Friday, July 1, 2022 2:18 PM
>=20
> VFIO on POWER does not implement iommu_ops and therefore
> iommu_capable()
> always returns false and __iommu_group_alloc_blocking_domain() always
> fails.
>=20
> iommu_group_claim_dma_owner() in setting container fails for the same
> reason - it cannot allocate a domain.
>=20
> This skips the check for platforms supporting VFIO without implementing
> iommu_ops which to my best knowledge is POWER only.
>=20
> This also allows setting container in absence of iommu_ops.
>=20
> Fixes: 70693f470848 ("vfio: Set DMA ownership for VFIO devices")
> Fixes: e8ae0e140c05 ("vfio: Require that devices support DMA cache
> coherence")
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---
>=20
> Not quite sure what the proper small fix is and implementing iommu_ops
> on POWER is not going to happen any time soon or ever :-/

I'm not sure how others feel about checking bus->iommu_ops outside
of iommu subsystem. This sounds a bit non-modular to me and it's not
obvious from the caller side why lacking of iommu_ops implies the two
relevant APIs are not usable.

Simply returning success when bus->iommu_ops=3D=3DNULL in the two
APIs is also problematic in concept.

Probably what we really require is an indicator to the caller that the
related operations are irrelevant hence can be skipped when=20
called on a particular iommu driver. This reminds me whether
 -EMEDIUMTYPE can be leveraged here.=20

Nicolin introduced it in another series for detecting incompatible
domain attach. This errno is not currently used in iommu subsystem
and introduced as a benign error so the caller can check it to retry
another domain.

Similarly we may return -EMEDIUMTYPE when iommu_ops is NULL in
iommu_capable() and iommu_group_claim_dma_owner() then vfio
can safely move forward when this error is returned.

Thanks
Kevin
