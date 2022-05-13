Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6CF5525E76
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 11:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378705AbiEMJIN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 05:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358383AbiEMJIM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 05:08:12 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1980015351B
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 02:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652432891; x=1683968891;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=l9j9vY41rqAS8ea45zSTZcUPRC087L99u9OHZlqBj0c=;
  b=Dk5MqSKjs5Vb6yHCEHEkLXouTXkaL/mEu/7JO5fWsHW7cKmDEIOisRXs
   NNgdhsVWcO9LND0Yuo3O5TXjiALBJjmTGzV0oE2+PsInB40GgM0ymiDIY
   OJsHXz4VRUc2DJiMsYfxXHQmKl0rvuw0wLPbcrc7dtxFEzbobv2sr7zbp
   n76+dwDcmpvywlL7yOy81ItG1zR/nyh2F0Fj2Z7XEMhnSirRW0sNXeraz
   afXdZ8WM7LseuS3Q9bkGnIEwrKQud+mWsbWjUMwYP5EO7JfhXgPR2eX6E
   DMmnhEDw8ZA2C6uuLFRvcDBSk20RdzQcdqok1qD4llOsD9kuy51hF60a4
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="330857758"
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="330857758"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 02:08:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="637221746"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 13 May 2022 02:08:10 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 13 May 2022 02:08:10 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 13 May 2022 02:08:09 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 13 May 2022 02:08:09 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 13 May 2022 02:08:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S42tk/JU4BWrcyLqVH+YyjztfoX4QHWx/+bvw+U+JbApcHhiMBgOU2inhJdJAHKFrvBytiqpQSu85+Arxk6ZYjNeaMPGv7dVbECbx0Gt1J04sMU/kM1EKCdY9JWOe2BqFKv8wsdDCU6y68DdzsuwtOdbE/O7teASgvhzwmMl69Nl/hBBx+vuHeNcjVu1twXFesp6/vpFoHUw4T5q6HPOvr2KWtYk/6hUcqBp72MCy2PjJ8nzvkHaZufANBaIn7VA1+aBcTI7+4LN/HJgk1xilJNsk4IUntAaOt0zlFgEq0H67yCwlJ2/CVewWYJs3ObqunuAnoskyWgn8Y/xKuknWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mTGBkcnDlgezT0qtn5UBc8zTvyegMmJMoEwZMCPQZXE=;
 b=ciPp0xAVjqkd2sNDz38XXWmyR43D9+v3ywUY5wa8FhJ2roZJHBbi54j9zDPQjTopASfo8+wbVkwumdir/zqC0w7tuRuwJ6hZdb2zDcpGo6O6lb4k+DZSvTQ4eZw6jfMAouAygqs3CcJTvoSbpmF91ZEpx3b5B9qKscF5nRtLA+xWob811sxWUqu9c5uPIUOuBbl9ukCUrqkm/q5xuKDXTWGkFcWWr7wLhNDlJxUCc/QhGoNuJ8aJfuhudmtX2iLooftHVXG7sH7oqzEaEbZ7oD6JEg6p9AfMuK9xM7hIgDwamPmosHfFjg77QKrcl8uPR5tIWgwcLVh5or+tsaebzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MWHPR1101MB2255.namprd11.prod.outlook.com (2603:10b6:301:5b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Fri, 13 May
 2022 09:08:07 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb%2]) with mapi id 15.20.5250.013; Fri, 13 May 2022
 09:08:06 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Xiao Guangrong <guangrong.xiao@linux.intel.com>,
        Jike Song <jike.song@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: RE: [PATCH 1/6] vfio: Add missing locking for struct vfio_group::kvm
Thread-Topic: [PATCH 1/6] vfio: Add missing locking for struct vfio_group::kvm
Thread-Index: AQHYYN/UaAaR95tQpUeiJ4BO+57YKq0cjrhw
Date:   Fri, 13 May 2022 09:08:06 +0000
Message-ID: <BN9PR11MB5276C75E8FDB277D5BD6A42C8CCA9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
 <1-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
In-Reply-To: <1-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0580de92-b2f5-4011-167b-08da34c01815
x-ms-traffictypediagnostic: MWHPR1101MB2255:EE_
x-microsoft-antispam-prvs: <MWHPR1101MB225542A92F7E0FB1115D7DD88CCA9@MWHPR1101MB2255.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KTUOBsqBdxfosWcmBSXW1pWI0/35R3fy5Vtkp5rfWMbgdkLHrihKSdXrJMvKavcXRcVKN2mkMJEBhgsItKtJCUk05R9L9HEZ0P8gnbQbuX2tRPn1GCFQdlEtHHw0GpVk9XHjax1qEe7RGiVnMShaivIXswtp6Vi0dwTpUNzX+E4enAnjSwfwOS8IRyG7ROMgIFQBIbZyPvwleEsx69vGMKtG9xd14HNpQN5r+LMlWmDdu6BtPw7QYg6Tln2MtBsU9iqWY7a2ZDPRZa0dpZzuOyoHw0OIzmetQQm90/OYfkzYtz3zZfzdpeZ0A5A4/zjkGaL5KsFykzWv6GrnjJc5mUmQ2Inl6HWcIwoWANAeTT4L81J7prnE9kEurLvh10L0sbR+ENiTgjVrtc+lmzPCLngitZE+uQ51v4l2QIL6keprZvJvS4SJQIHyMK7z21arjpBFMMrYPTx/FU8SuH8RMPKzwRV9qd4ML2i4kf+IJ+dyPtHnPjbGpvkfeHhGedTdFVXQm7IDvUOuLoy5SbrogrygE6hnZHwvsrzLILEkt72SdtJMsxh3I+TezCaS+72rLB2Bn9wsdAMOAHFRKptdVIE5tHx3pbE6Zu7HP6Z0xoMv52tLjLWBqtiPzMcKuArWdWOGGnLLX4nnIryBN+hHdOoPYkKZ56WquXIlNKTvFw16FZiM6n82fR8vI3IqJMlXw24rYDDd7WHH4SJ+QtzlIA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(122000001)(110136005)(83380400001)(8936002)(52536014)(38070700005)(38100700002)(55016003)(316002)(86362001)(4326008)(66476007)(186003)(82960400001)(76116006)(2906002)(66556008)(66446008)(64756008)(5660300002)(7696005)(71200400001)(33656002)(508600001)(6506007)(26005)(8676002)(9686003)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cBL/lo5WJjjKLkJIu3QtUZDQk9uT9yRYgfenxAHHBEHudiAdCCtBnxjLjMpv?=
 =?us-ascii?Q?BCv39Hb+sVuWCZFx9dP6b7yFaNOooFFySvonB7wZUeZfSV7g92Aip57JB7zh?=
 =?us-ascii?Q?30JUY6EsCJoSzqecpAB0J+TssY1aYFdQOcvuRWl5MilZ9b52zb81V3d5LNVV?=
 =?us-ascii?Q?MOh/+7u3Pc8NoMr/Ddh7QZ6q4XOyTdH3/OsGKGSNFiEkTfDn9kk0/OfgScvh?=
 =?us-ascii?Q?gzpy5R/i+vAUijCWFAaxURQWaGk3GqAnhv4i1fJrsF2agn9wmJaU4rQVW7Gn?=
 =?us-ascii?Q?9qL6q+U+b7aM22RxA01WFJn6jGVkuJ1TcppuHqni+c5Cfce0TexxDUk1uPTQ?=
 =?us-ascii?Q?eWeYGQRkGgjlU9loB6lN3cuBgDtt2KFApLpDaMK4gIqbwUYzDD/cFa/ytL2s?=
 =?us-ascii?Q?VpPN1T4XVkpeKAWDhS0ajW3k3+Vn5MaQdMzdjzDPaCI6CeldFIbVLonuDTyp?=
 =?us-ascii?Q?MRkaJTCG4tuyTsohIi8Qz8C1OPu1xtV4WyX1q1nOMmG/rbi7Am/5r0xPOifC?=
 =?us-ascii?Q?gWQklSDCI9VpF/woL5A3NWti8/RqzrmJUxC0OE3U33yP9WQlTo3yTJpu8TwL?=
 =?us-ascii?Q?54dyq/34/R5iMqXMFS3oNOfVa0gLQQZsoqRp3KV1+sGHsJGmhtNek4wDn78Q?=
 =?us-ascii?Q?Wf1ex1GA4t7N5MUgWrRyAVHT9jCgLKxryPqFsBzmXZ9Cx1N+ReCDwzmYGT6d?=
 =?us-ascii?Q?38edJ8wrDAeZ/aaIp7cd3pnBZjf/wl24vB5eGjzBpFQ1pv5dsskjLmXl6Eii?=
 =?us-ascii?Q?EdAtOsAXhA390MA5U7Tke8dlRIIT6z5/w9vlGvCNFGFAfblKs49Cou5PS+pu?=
 =?us-ascii?Q?3VrbSpLmVYjkAkWO9ZnY7gWdadqqP2WRKTODUJFs556V38bADkATNJvR6nNe?=
 =?us-ascii?Q?6879klOmVKI+NBul54TdSkTZ91f3xBe5ILuXwJKsw5xLCiIyrwoDJsvcazMN?=
 =?us-ascii?Q?eBE0f7wzIUyol+Tcjd7X97aHfon1q5mIDPTC0+g0BMj6N47u+eCD/LEIsOuX?=
 =?us-ascii?Q?tr4TbQybsklXPDEQbR9HiZuiu7S3NwduATGSlfucY872/HM8aIUL5VDQZ28D?=
 =?us-ascii?Q?5qghLWHHqA1PtNZH/L53xIi6zhbqWgOr2GGIdZPMbjdm7eRyaUhdq2ZqdRFY?=
 =?us-ascii?Q?fW7O52bThz7UPZGq3eqXkkz1X0VnoUpkYzEnB+P8URhXtoGvvq6I67c/hwlc?=
 =?us-ascii?Q?6/M7210aIJc7/kKzeHBn9ZgWxNW1Gn96tUR0GJKsVy1Ip/rR1bbAn3AVSEvd?=
 =?us-ascii?Q?rLCGXdR5+DWfCKMWdcSos97XtX2S0Cl+1qpNBPlsUcWeW7AKUwknU7qjF/f/?=
 =?us-ascii?Q?vddCrj9Za27Ax297DoV4ESwBY66AhQsXnxVRgN18oNCweqklrB2tnhvMLLA1?=
 =?us-ascii?Q?ztaKzlB+jWCEVZe/SJi7MojlVwfkRK9dHQBl7E7/zjASOCvmEFRS2pmSrNjn?=
 =?us-ascii?Q?0aF2m7qfBmWYGIJ3bENQrCv26N2uO1LTTt9h3841DJ/xTjgbDq4OXQNfiEeB?=
 =?us-ascii?Q?Svc4AZoUyrmsYtHJvOFHVdxXeIYX3vgbM03mS3Tm8FpZV7C1dtXvxJWb6MYJ?=
 =?us-ascii?Q?lq/+9OUlh4NL2hHFNAr+0KxjKL3hU5IbawB7+KTsV1KmOU5Nm8pPPwM0s7Sn?=
 =?us-ascii?Q?pKnCYrTOGnka4NcMw9dOGxPglHDAjgDHKMeT+LBzvGcc2GbbGoWeSZAxGIcv?=
 =?us-ascii?Q?OpMSD8t3vtKdYXmuGaAKxelGtyOgzwcojPkLKWKRO9F7bGhjO7Q5ylWNJjbJ?=
 =?us-ascii?Q?SaUi7nBhFA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0580de92-b2f5-4011-167b-08da34c01815
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2022 09:08:06.8278
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 12VEe5hwrStljLVwbQ29UJs98TlKICJN4OmwrayRbEc/qobDm7DblHA5BuUR9++VjTRG3G0GmqdW1YKpnnw6Tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2255
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, May 6, 2022 8:25 AM
>=20
> Without locking userspace can trigger a UAF by racing
> KVM_DEV_VFIO_GROUP_DEL with VFIO_GROUP_GET_DEVICE_FD:
>=20
>               CPU1                               CPU2
> 					    ioctl(KVM_DEV_VFIO_GROUP_DEL)
>  ioctl(VFIO_GROUP_GET_DEVICE_FD)
>     vfio_group_get_device_fd
>      open_device()
>       intel_vgpu_open_device()
>         vfio_register_notifier()
> 	 vfio_register_group_notifier()
> 	   blocking_notifier_call_chain(&group->notifier,
>                VFIO_GROUP_NOTIFY_SET_KVM, group->kvm);
>=20
> 					      set_kvm()
> 						group->kvm =3D NULL
> 					    close()
> 					     kfree(kvm)
>=20
>              intel_vgpu_group_notifier()
>                 vdev->kvm =3D data
>     [..]
>         kvmgt_guest_init()
>          kvm_get_kvm(info->kvm);
> 	    // UAF!
>=20

this doesn't match the latest code since kvmgt_guest_init() has
been removed.

With the new code UAF will occur in an earlier place:

	ret =3D -ESRCH;
	if (!vgpu->kvm || vgpu->kvm->mm !=3D current->mm) {
		gvt_vgpu_err("KVM is required to use Intel vGPU\n");
		goto undo_register;
	}

	...
	kvm_get_kvm(vgpu->kvm);

> Add a simple rwsem in the group to protect the kvm while the notifier is
> using it.
>=20
> Note this doesn't fix the race internal to i915 where userspace can
> trigger two VFIO_GROUP_NOTIFY_SET_KVM's before we reach
> kvmgt_guest_init()
> and trigger this same UAF.
>=20
> Fixes: ccd46dbae77d ("vfio: support notifier chain in vfio_group")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

with above flow updated:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/vfio.c | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index e6ea3981bc7c4a..0477df3a50a3d6 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -77,6 +77,7 @@ struct vfio_group {
>  	wait_queue_head_t		container_q;
>  	enum vfio_group_type		type;
>  	unsigned int			dev_counter;
> +	struct rw_semaphore		group_rwsem;
>  	struct kvm			*kvm;
>  	struct blocking_notifier_head	notifier;
>  };
> @@ -361,6 +362,7 @@ static struct vfio_group *vfio_group_alloc(struct
> iommu_group *iommu_group,
>  	group->cdev.owner =3D THIS_MODULE;
>=20
>  	refcount_set(&group->users, 1);
> +	init_rwsem(&group->group_rwsem);
>  	INIT_LIST_HEAD(&group->device_list);
>  	mutex_init(&group->device_lock);
>  	init_waitqueue_head(&group->container_q);
> @@ -1714,9 +1716,11 @@ void vfio_file_set_kvm(struct file *file, struct k=
vm
> *kvm)
>  	if (file->f_op !=3D &vfio_group_fops)
>  		return;
>=20
> +	down_write(&group->group_rwsem);
>  	group->kvm =3D kvm;
>  	blocking_notifier_call_chain(&group->notifier,
>  				     VFIO_GROUP_NOTIFY_SET_KVM, kvm);
> +	up_write(&group->group_rwsem);
>  }
>  EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
>=20
> @@ -2024,15 +2028,22 @@ static int vfio_register_group_notifier(struct
> vfio_group *group,
>  		return -EINVAL;
>=20
>  	ret =3D blocking_notifier_chain_register(&group->notifier, nb);
> +	if (ret)
> +		return ret;
>=20
>  	/*
>  	 * The attaching of kvm and vfio_group might already happen, so
>  	 * here we replay once upon registration.
>  	 */
> -	if (!ret && set_kvm && group->kvm)
> -		blocking_notifier_call_chain(&group->notifier,
> -					VFIO_GROUP_NOTIFY_SET_KVM,
> group->kvm);
> -	return ret;
> +	if (set_kvm) {
> +		down_read(&group->group_rwsem);
> +		if (group->kvm)
> +			blocking_notifier_call_chain(&group->notifier,
> +
> VFIO_GROUP_NOTIFY_SET_KVM,
> +						     group->kvm);
> +		up_read(&group->group_rwsem);
> +	}
> +	return 0;
>  }
>=20
>  int vfio_register_notifier(struct vfio_device *device,
> --
> 2.36.0

