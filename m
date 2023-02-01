Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 819E3686621
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 13:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232087AbjBAMm7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 07:42:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbjBAMm5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 07:42:57 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C222A2108;
        Wed,  1 Feb 2023 04:42:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675255375; x=1706791375;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lf+2pXSq6CCdMWj17wZPH9hZ1TZAinWyzd8+y+fd4ZA=;
  b=MZK7wMBsFmLL60iS6y8Fq+3CMJcBHqC/dbcv5kCY4BkMNRl2pBMJ9ROR
   IVILX7n03m4pHDEvquce8rQ5y33YR0V6TiWVHCTMz9vZqCanhprRQtjB3
   9RYeeg3WZYPGzjhuNEad9D+0vARL9qtmnUrN+tJjjFns5oKKU77uj7s46
   7v1q7/NNPavWMk4dd5mikfoXb/BVzvMJ+t4TUeBgUcHmfmRZr08B+UCNq
   Q1YKlovkqcA7UCuXSiKSaVGi2BcZiJwM72jdtL3X2FbJmsC4hP0gihzJ7
   ctjlZLMLpK2Wg42xA7erHKBilgOjzrXgNc0pTM1mvE4aIoga7FiTd3lqz
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="390518564"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="390518564"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 04:42:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="773421108"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="773421108"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 01 Feb 2023 04:42:54 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 1 Feb 2023 04:42:53 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 1 Feb 2023 04:42:53 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 1 Feb 2023 04:42:53 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 1 Feb 2023 04:42:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RdOFBf2GD7vI5MB7VJzooOUoed/FEjmoYvWpNQo8SS3nEE+6KR/K+WejqgSP5n0YwVX22Ot50PDYlVOkcGmKzYuiCVq91zGkfsmcwUN5VqqpWa7fYCCxzY6u9WzBwoT+uyCQkVnrblhNNwTn5SQlWAR+Dy/4U4EcmRpvuM9teldfPyvaYlPXJhxL57OAgmvT4iZhqX11vInkarZ9ip7hGf/0ljoappUHRLSNwfLkaGjirSHl72LHA9ieJLMji8lFMy4cEaA3hnKMB/JH/LXFnPzSKDIwf8/JnVuvDWiLqzAXXDRtvRkcIDH3fURSFg29XXdmA0HHNSfx4nJUyn/Tug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vrXG3k+nmWij2IZfG45iLE2MgCS5GKkTOK4+HE1VsWs=;
 b=AKUAFqCxXXK9sMSqyJgsctxpdpr999JdyiNN7ucjTLCLkuQUjU5vmxndsTSkRFWF3sOyMyB+BfM57kxLeCIHPSN3m8LGNRohYFs8Asy6umvO7dWAkjCT7sYcCVlaJtOkAddy/GAWUR/adnHAaHWuY/YvBiHbIHJuOVDlT2HSuzIAnd7UDggiv/f6RoBFxIsJo9Vf6JsA0GZ9RbiANW7+9HwiHJv51DGtgGvlhikUcXJvegvtxuc746jvuvO6RaySQhEL0Qe75PfhN8x/vBo5aTbaFtU+KekSZmvtmmjJe7BH0i0NKzcz/CH+oTq0aVycmLS49/DeSMbkBDSJY00LIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by IA1PR11MB6467.namprd11.prod.outlook.com (2603:10b6:208:3a5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 12:42:46 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%4]) with mapi id 15.20.6064.024; Wed, 1 Feb 2023
 12:42:45 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "pmorel@linux.ibm.com" <pmorel@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "david@redhat.com" <david@redhat.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] vfio: fix deadlock between group lock and kvm lock
Thread-Topic: [PATCH] vfio: fix deadlock between group lock and kvm lock
Thread-Index: AQHZNa+RvE0EhcYo6EGu/ai3XoxXDK66Canw
Date:   Wed, 1 Feb 2023 12:42:45 +0000
Message-ID: <DS0PR11MB752972035A4CE4B2319A6C45C3D19@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230131200635.44227-1-mjrosato@linux.ibm.com>
In-Reply-To: <20230131200635.44227-1-mjrosato@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|IA1PR11MB6467:EE_
x-ms-office365-filtering-correlation-id: 99180ceb-b378-4bc3-47ab-08db0451d162
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A7VSZRCyc2QWCcBgH5MN0ywakuqLurHGyC+PgAPaGKNafh/HHdHeVqDG8WarfcBgu3WLoHaA2WVi5C6WyGvTJqcYDntF9uo2FQs3PXYfcdCpTLqkGVFGAzPZgQD7H1Jr965Tl+RyWrIOuGUbsL1Se2t1ghn7lfDZ0LdDjK09yULwegXglY1DpkLhgEU71GByS4QP4iycRcq7ldbpgQqdQxMdFYUZJFon6NjQTk+XoZeAulYARYMAFladBmSBYAyKfiNgQUebTmDy62zx8Wcjs20eL6/cn5L0mWSRdMvAB6ouFWJrHMgM+aor/hnh+zVqEq3GiGLZPRf3gJEwKefn7gG/iweKjecI8J2eVquqmmP9iakIhSv+AhSG+MPK+aVknahZYl9tujRvutAwAAuq0lkW6vhcnZ54uYoD7dGCEqkJFV2my0BVwctMAgYRcVsXWcmcL3bpPqcAducSnT7jvFzUdRulumF7kyn4bWKVWq3zjIjiQdsMRCHTQis2OHIOE/YGDCQsD6A14c+ZQtphz+i0L+siog6kkaweYglwdH9Oy+kid83obl5Tb2iZv87hTFI2OptlYpPpP7ItOeBjK/FJRwRnZMEdlxDa14y0MkfrhNqoIqHrIL+grhZQ5rafS3la/xD2Ct5VbbkYS3mfaTBP2GCWJryZfId+1yDz0c/1YhKm2foOgHepBhOAsbv7Vd3asvZhcMx0j+0URcFelQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(346002)(39850400004)(366004)(396003)(376002)(451199018)(41300700001)(478600001)(186003)(9686003)(38070700005)(86362001)(26005)(6506007)(66476007)(4326008)(66946007)(66446008)(66556008)(64756008)(76116006)(8676002)(316002)(8936002)(7416002)(54906003)(5660300002)(110136005)(71200400001)(33656002)(2906002)(52536014)(7696005)(55016003)(38100700002)(83380400001)(82960400001)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?J6BjtMuZu+XFUL75XZl70cAfovIOA/XipQ8K9UAJwcuNv3H8bn/2nlfN1FLH?=
 =?us-ascii?Q?ymbq5XISPgyxtdp3pEuhLbYB1Xh+1V/Aciiu//bC3jONi1ajeGEYL+oGltsq?=
 =?us-ascii?Q?2Ln8ieTEjI/iK4oJudgtFmetcnje1iQ2uT3WHf3nbi6/mLMkfWlUU/cLZKet?=
 =?us-ascii?Q?6tJCsFl32wUBuH5lZ5ZS2MK7QPp3TLhs367ZrzajkMfTyOr0cEJ3usJLjJ9W?=
 =?us-ascii?Q?Mtb0T/DR7k/4SGKiaPER0iOuqfl35GiCd3JnJgvPDQkseKG1DCUi+5U7RahA?=
 =?us-ascii?Q?qrXjDxGmDzYkW9mokAz8iFzICGc1RfkjMAhY8oR2PUIyrHIaVLJUhbTy6RSD?=
 =?us-ascii?Q?VxxgIgZJ+DD+zWuPfIPMFlnIMjaPxDho6Tc0RiL6zzLgmCCAp3Dw+KVkHJ7x?=
 =?us-ascii?Q?Y8h8xGmLMtRf8A4AIqLxHHqzup+xK37YsgfL6HVD3UV2MyN+cLedDcrq44RQ?=
 =?us-ascii?Q?CqqrG89ErFMPC32C55HVH3PY74OH/fdPRoW95AqCiSX+lP8zL3hcR28qYqqE?=
 =?us-ascii?Q?80zpnnwPshOxvSPwYQDmwEGH+JjHIMtD97QNINeSA1XvJrV1wl4nEVZ3IoOe?=
 =?us-ascii?Q?6NOfW7UmcpIzjHGoBmSkppUAN0VOTQ47CmV1voR8yCUl4fbb4Xc3moa73W84?=
 =?us-ascii?Q?LgPvc3lqTMqzcgpHaleJ4aGwxmJDpSa4yuUmxRdafaoqE/STKqTQz5jhxHXz?=
 =?us-ascii?Q?EtGvOMjIBZf1tygIw66424hW8GpRP4c4X7EXe9QjJmTAvlA+GNC4cwrslk7L?=
 =?us-ascii?Q?LmjEjEWjt/c9HEh1WmndcL4RQi8wfdeji7X+3wt6gaR2xKtyEqeu2n7eD7jx?=
 =?us-ascii?Q?9zNX2ORbDjCM9N0NJrgEoOty1YbbOAFh9xHakBpOZf25orJO1DhLjFUjvVsA?=
 =?us-ascii?Q?KAp1Si480Y9JOgql43ySJ6Nb7Crw3MKWz6MCQwZ4DeuIieBNwsN81AecD8nv?=
 =?us-ascii?Q?QVDLVldLoP+CRtEl8pKGn2pnrm2LdtQOVD+WYKoCj6qcxs9Sx8wqDYVqAlZA?=
 =?us-ascii?Q?xtW+RlKCZX6OnvarbWAB7OIsJ1gFY3i6wHLOXYoYqlaj5Ax+9U/HJmoNfUcS?=
 =?us-ascii?Q?XPzIlTl0NrFjvqWgkx9ZkiqpiV3OhcgggQXd2QZbHhIImOhbD+8hWyfcapVR?=
 =?us-ascii?Q?HnbeccimKCRv7RlNMoDVv9fMb4EOhEJmoAk0YqHX0vL3s7YH/ZNRRFRb4qJM?=
 =?us-ascii?Q?sBEgOELwOmbszNpdv91YuDHBrXK2v/jHVtnKSBqZTX50PATSQFNT//Q5yCxL?=
 =?us-ascii?Q?n/WpsMv2giZlo8cwysVdeMXM6OLqHZtqZIoaZ0H2bvz3zkGoJzm7W8SJRnQB?=
 =?us-ascii?Q?CmJg+higu97nX9xgLuKrjMgQ/rLDLtRmfQieuE0Vd3zuwB0OMbvsf1IcDfb0?=
 =?us-ascii?Q?dvxd8F0Z++cPZqeOo9Mg/g7FVQynDuOaAVjDokIqa42XgNq7cbb7eYeMrH0m?=
 =?us-ascii?Q?v+1mLnz7mEaMuQ+g4Xfz+ZLU6Tga/BR+1CQjOpuC7+AMkJjSchhJVBSl8N/x?=
 =?us-ascii?Q?hzGQ4+QHYBDX8TDk3s2/CguU0778lNPfqdchGdhd8iMm81gdGe87KXJlwzpU?=
 =?us-ascii?Q?ZZP9yF08MFULnzaO1n1zwY959pvjecCS+cs4hKLZ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99180ceb-b378-4bc3-47ab-08db0451d162
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2023 12:42:45.4642
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i2qt0y0kcs6iVrjUAEbWpZSbsHcaOy0ug1RJ8NSB6z12PBl+fj0/EuwlhBRSPLpdMUCwQL6fIpNOnR7Xxr6fLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6467
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Matthew Rosato <mjrosato@linux.ibm.com>
> Sent: Wednesday, February 1, 2023 4:07 AM
>=20
> After 51cdc8bc120e, we have another deadlock scenario between the
> kvm->lock and the vfio group_lock with two different codepaths acquiring
> the locks in different order.  Specifically in vfio_open_device, vfio
> holds the vfio group_lock when issuing device->ops->open_device but
> some
> drivers (like vfio-ap) need to acquire kvm->lock during their open_device
> routine;  Meanwhile, kvm_vfio_release will acquire the kvm->lock first
> before calling vfio_file_set_kvm which will acquire the vfio group_lock.
>=20
> To resolve this, let's remove the need for the vfio group_lock from the
> kvm_vfio_release codepath.  This is done by introducing a new spinlock to
> protect modifications to the vfio group kvm pointer, and acquiring a kvm
> ref from within vfio while holding this spinlock, with the reference held
> until the last close for the device in question.
>=20
> Fixes: 51cdc8bc120e ("kvm/vfio: Fix potential deadlock on vfio group_lock=
")
> Reported-by: Anthony Krowiak <akrowiak@linux.ibm.com>
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  drivers/vfio/group.c     | 14 +++----
>  drivers/vfio/vfio.h      |  5 ++-
>  drivers/vfio/vfio_main.c | 88
> ++++++++++++++++++++++++++++++++++++----
>  include/linux/vfio.h     |  2 +-
>  4 files changed, 88 insertions(+), 21 deletions(-)
>=20
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index bb24b2f0271e..8f67d33e0e8d 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -164,13 +164,7 @@ static int vfio_device_group_open(struct
> vfio_device *device)
>  		goto out_unlock;
>  	}
>=20
> -	/*
> -	 * Here we pass the KVM pointer with the group under the lock.  If
> the
> -	 * device driver will use it, it must obtain a reference and release it
> -	 * during close_device.
> -	 */
> -	ret =3D vfio_device_open(device, device->group->iommufd,
> -			       device->group->kvm);
> +	ret =3D vfio_device_open(device, device->group);
>=20
>  out_unlock:
>  	mutex_unlock(&device->group->group_lock);
> @@ -450,6 +444,7 @@ static struct vfio_group *vfio_group_alloc(struct
> iommu_group *iommu_group,
>=20
>  	refcount_set(&group->drivers, 1);
>  	mutex_init(&group->group_lock);
> +	spin_lock_init(&group->kvm_ref_lock);
>  	INIT_LIST_HEAD(&group->device_list);
>  	mutex_init(&group->device_lock);
>  	group->iommu_group =3D iommu_group;
> @@ -799,13 +794,14 @@
> EXPORT_SYMBOL_GPL(vfio_file_enforced_coherent);
>  void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
>  {
>  	struct vfio_group *group =3D file->private_data;
> +	unsigned long flags;
>=20
>  	if (!vfio_file_is_group(file))
>  		return;
>=20
> -	mutex_lock(&group->group_lock);
> +	spin_lock_irqsave(&group->kvm_ref_lock, flags);
>  	group->kvm =3D kvm;
> -	mutex_unlock(&group->group_lock);
> +	spin_unlock_irqrestore(&group->kvm_ref_lock, flags);
>  }
>  EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
>=20
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index f8219a438bfb..d153ad35de24 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -15,11 +15,11 @@ struct iommufd_ctx;
>  struct iommu_group;
>  struct vfio_device;
>  struct vfio_container;
> +struct vfio_group;
>=20
>  void vfio_device_put_registration(struct vfio_device *device);
>  bool vfio_device_try_get_registration(struct vfio_device *device);
> -int vfio_device_open(struct vfio_device *device,
> -		     struct iommufd_ctx *iommufd, struct kvm *kvm);
> +int vfio_device_open(struct vfio_device *device, struct vfio_group
> *group);
>  void vfio_device_close(struct vfio_device *device,
>  		       struct iommufd_ctx *iommufd);
>=20
> @@ -74,6 +74,7 @@ struct vfio_group {
>  	struct file			*opened_file;
>  	struct blocking_notifier_head	notifier;
>  	struct iommufd_ctx		*iommufd;
> +	spinlock_t			kvm_ref_lock;
>  };
>=20
>  int vfio_device_set_group(struct vfio_device *device,
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 5177bb061b17..b0defb0d0d87 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -16,6 +16,9 @@
>  #include <linux/fs.h>
>  #include <linux/idr.h>
>  #include <linux/iommu.h>
> +#ifdef CONFIG_HAVE_KVM
> +#include <linux/kvm_host.h>
> +#endif
>  #include <linux/list.h>
>  #include <linux/miscdevice.h>
>  #include <linux/module.h>
> @@ -344,9 +347,59 @@ static bool vfio_assert_device_open(struct
> vfio_device *device)
>  	return !WARN_ON_ONCE(!READ_ONCE(device->open_count));
>  }
>=20
> +#ifdef CONFIG_HAVE_KVM
> +static bool vfio_kvm_get_kvm_safe(struct vfio_device *device, struct kvm
> *kvm)
> +{
> +	void (*pfn)(struct kvm *kvm);
> +	bool (*fn)(struct kvm *kvm);
> +	bool ret;
> +
> +	pfn =3D symbol_get(kvm_put_kvm);
> +	if (WARN_ON(!pfn))
> +		return false;
> +
> +	fn =3D symbol_get(kvm_get_kvm_safe);
> +	if (WARN_ON(!fn)) {
> +		symbol_put(kvm_put_kvm);
> +		return false;
> +	}
> +
> +	ret =3D fn(kvm);
> +	if (ret)
> +		device->put_kvm =3D pfn;
> +	else
> +		symbol_put(kvm_put_kvm);
> +
> +	symbol_put(kvm_get_kvm_safe);
> +
> +	return ret;
> +}
> +
> +static void vfio_kvm_put_kvm(struct vfio_device *device)
> +{
> +	if (WARN_ON(!device->kvm || !device->put_kvm))
> +		return;
> +
> +	device->put_kvm(device->kvm);
> +	symbol_put(kvm_put_kvm);
> +}
> +
> +#else
> +static bool vfio_kvm_get_kvm_safe(struct vfio_device *device, struct kvm
> *kvm)
> +{
> +	return false;
> +}
> +
> +static void vfio_kvm_put_kvm(struct vfio_device *device)
> +{
> +}
> +#endif
> +
>  static int vfio_device_first_open(struct vfio_device *device,
> -				  struct iommufd_ctx *iommufd, struct kvm
> *kvm)
> +				  struct vfio_group *group)
>  {
> +	struct iommufd_ctx *iommufd =3D group->iommufd;
> +	unsigned long flags;
>  	int ret;
>=20
>  	lockdep_assert_held(&device->dev_set->lock);
> @@ -361,16 +414,30 @@ static int vfio_device_first_open(struct
> vfio_device *device,
>  	if (ret)
>  		goto err_module_put;
>=20
> -	device->kvm =3D kvm;
> +	/*
> +	 * Get the KVM pointer currently associated with the group, if there
> +	 * is one, and obtain a reference now that will be held until the
> +	 * open_count reaches 0.  Save the pointer in the device for use by
> +	 * drivers.
> +	 */
> +	spin_lock_irqsave(&group->kvm_ref_lock, flags);
> +	if (group->kvm && vfio_kvm_get_kvm_safe(device, group->kvm))
> +		device->kvm =3D group->kvm;
> +	spin_unlock_irqrestore(&group->kvm_ref_lock, flags);
> +
>  	if (device->ops->open_device) {
>  		ret =3D device->ops->open_device(device);
>  		if (ret)
> -			goto err_unuse_iommu;
> +			goto err_put_kvm;
>  	}
>  	return 0;
>=20
> -err_unuse_iommu:
> -	device->kvm =3D NULL;
> +err_put_kvm:
> +	if (device->kvm) {
> +		vfio_kvm_put_kvm(device);
> +		device->put_kvm =3D NULL;

Can "device->put_kvm =3D NULL;" be part of vfio_kvm_put_kvm()?

Regards,
Yi Liu
