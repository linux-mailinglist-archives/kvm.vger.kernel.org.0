Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33CC369F152
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 10:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbjBVJZ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 04:25:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjBVJZZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 04:25:25 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F8C82727;
        Wed, 22 Feb 2023 01:25:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677057925; x=1708593925;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TmMhDT/1pUNkmavVnaPB3xpwK69hY40agoIiK1aTXVs=;
  b=ju3OAWIXAMOGVIlY9LspVSncuIV2DI5VO93UkleClL1tSFwG23pH8JN3
   YpJG/XCnoDSlYovWpVh9jIVI9p+fJ9zQ0tx3P718wV4dGzvBLwxOJyXn5
   Haz6xQzQGZITVFRZVK5oaX3I8vxHy8gVST7P8zdWsmAOT6cqmZEjcMDxo
   r9U/+WqdRxmB6M4U8aoQauVF0HnMRZMZG6GzLsW6homsymU++V6L+Aa6B
   w8qfHrCwwUEilJZ/Sr29wITy0HQOm4/cnEMO/DGPeZkmBlE5OQste3H58
   wwXHQ3DgCqYzZvxTSinihf7TW1Lbg+2HF5QUz4qUjJTnb5bMF2TotztIg
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="321019364"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="321019364"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2023 01:25:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="621843414"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="621843414"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 22 Feb 2023 01:25:24 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 22 Feb 2023 01:25:23 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 22 Feb 2023 01:25:23 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 22 Feb 2023 01:25:23 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 22 Feb 2023 01:25:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CDLLRB2lE1mE6bkdFNG5LfOMomnLn8OSeusW6JfwfolcXVzD9X32LYelchEud0gi9nBK7vIjEfiTIU4XJRzdpKfD49EsRFFsXh5o2kuJLAHmtFKefrqjncvaPQl3GZmamvdNkBgFEI0EEnO8jv6a/T0UfP/VvTgbXM4CmiZtAd0ob5DoD3KQQBkAOvc6b6ihuSRWOpetoqre34yxAfrkLwbGfhpzW30D7tpsl6EyHkGSqLhPVKbRfEINECQ48pwQ6ox9CSVvz8igFha6EnlUv0WNqWYXlKdnXoO68rV5I951sd8/t3PF/pQWqRDw4l9JvaKxpKN+ksOOqW30JaIhdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VA+1wGXNWs/1xfhd7MqKNrssoi/eB7TxVjT1kOYcZTg=;
 b=Diuaqg4lRAgTifuoF8FMHHEt9lv18FjmJ7wqJ/8BYKAvL37o0mbMlrjNdIuTHM9S5Fmqw//D2kZRvcQipuAxHEHZQ8ufw6B5BJ7Ou6K5d2bgn3aOHFHCS69Hg0zn4JvtmNfR6EptJGyNKZCykOffsoRB8SCk/I7rJ1gvqzqMok0V9uT4cw/yRNbO7xPhdaXOs94Ebdb28F0Z/jJ/WWY2Pezf0qYYwGRMX9+enE9kh5bxTpNKD6+A1RTYBCaW4VhZOh7+wFDbhdLJqkmV2cw2qPqLpGIsyGLyW83oUeBijPA/YqvBs4/hWnBx5kv6OJIfO455AFh0svybts5VCJbVew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH7PR11MB6907.namprd11.prod.outlook.com (2603:10b6:510:203::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Wed, 22 Feb
 2023 09:25:21 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%6]) with mapi id 15.20.6134.019; Wed, 22 Feb 2023
 09:25:21 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] vfio: Fix NULL pointer dereference caused by
 uninitialized group->iommufd
Thread-Topic: [PATCH] vfio: Fix NULL pointer dereference caused by
 uninitialized group->iommufd
Thread-Index: AQHZRpWZMTeaNr6VsUGXmEyEo+8tAq7asO+Q
Date:   Wed, 22 Feb 2023 09:25:20 +0000
Message-ID: <DS0PR11MB7529F25EF35901D55F8FB4A9C3AA9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230222074938.13681-1-yan.y.zhao@intel.com>
In-Reply-To: <20230222074938.13681-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH7PR11MB6907:EE_
x-ms-office365-filtering-correlation-id: 89943e92-a751-4135-bca5-08db14b6b822
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hYxgZvEx4OojZKOzyMXRpUfvTky7Ytw3hMwkdZQDBm6KWpkgm1c9Muf7UznAMxgAqiTah3rsq/YgBFkUccWBmnSQq///c0b63SQETeKndekZn17HvhKT84XhSXeG2PKWge2DIjYZ50i1PqrVLQOgY7+JwrGa4/zXgXTd4utjdhrNsdmezckfJSfBp5iCsKIQ7rO6dT4dweCzEzFFCdO7EIEYoWZV/q1IluGuW4uzEKdma8TFE7dsY8grmM9dgr+HICZhgNRH/Ci/Oe1ehUVak7+LSvLq/DjUwH54Jr8iiMOBgwmOgfQk/u6kdP3gAHV+sS1Usz9ydrZ5SHDIs1kBwpt4yCzMAQAXdhQbFmwrxgydO13hbDT+tflLFdtlxd++R+OaTyo0/HBpnB+N8ADjx8ElctrTirS4pLIXRr/GOrxHv9aQ8peUIYNWvpxYd0g4ymo4DJQrJ00ebFYb0KjR/yC59qt+IsiqLFQKBQfEcwtUScbuL8nHIz63c8HiYB6tuHr0SbUTCTS8GzBBrW99FAolw+adUQC/yRESyR/HqzSyhPz2oMZtJWaLI8SOurUbA8YDv8DOYgJic+qxHz/31b8vMzvS103qcLrIKM9ZzyvdNNtb5rjWAeN87/ihJKe7948b9MsASckIMw1+V0ySC4Cse/IiY1895QNVp+ON+vP+inkQKZqHkFAAcIdqvqA2UsRrNgJsZYdtcQFm3bP19w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(136003)(376002)(346002)(39860400002)(451199018)(82960400001)(122000001)(38100700002)(71200400001)(6506007)(38070700005)(55016003)(26005)(186003)(54906003)(66476007)(9686003)(110136005)(4326008)(64756008)(6636002)(478600001)(316002)(8676002)(76116006)(66946007)(66556008)(2906002)(66446008)(83380400001)(52536014)(86362001)(5660300002)(8936002)(7696005)(33656002)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DJTc/UPGynCdE53TYEeDCHOm3ys7WArrS757lXJ8Ii2PtllPr8mW82S4JYZ0?=
 =?us-ascii?Q?EjmUQpCM5CyibxFKJcpSZkJpzkZgiFBfLTtj5RutXfv0IGDu4i6pzk4OE6G2?=
 =?us-ascii?Q?9Ho1IwGOy0uZPS9R2mCVFqjZFZ+3MG0Zl4+Pub5Jpgj2dX917sggYrm7PrEL?=
 =?us-ascii?Q?2fGm56K7TLlq77OqhO+1H3IRDo1Ey/g5zjlUIoP7SVf0DXKgH+OqtWZCwBce?=
 =?us-ascii?Q?u5IfpbK6Ey50ZB8HQ5fN/x3JsQbCvFfw/CQ0Xn9rZX1Vt2yaD0kr+8x10RJs?=
 =?us-ascii?Q?qZGJ3yLFbJ4w5YLX4s/Qgrdqa2lXYDhYu8RKPydX0vUnEDLXYchiU85JmrIt?=
 =?us-ascii?Q?cBDEQSEXChNIiw28axJeXTfdeAiCcLqo72F1PptTK2C/Ak49jPU15nCJEUqU?=
 =?us-ascii?Q?QE4lsLaoklQI19EER7EuZMgp3Emgzk4hUH3kunv94K8pgy4VILC/P76Q/mRt?=
 =?us-ascii?Q?rOXoD/caIlj/0KNaGGGqHT8sdk5zRt0R8QTSQPcT3K6kGvC7MAsyI6GIbb5f?=
 =?us-ascii?Q?W8OkUuqvIPX1kZTNn0IeGww38OCxAx6d4bTss2uU7KI6ixCMmOh/VEnSsfTU?=
 =?us-ascii?Q?h233BREvBpKhZ17IW0MqHCtLIUrpr9u8lELrRuFvOphgORpV3h7zlAru0V9n?=
 =?us-ascii?Q?3kJVqQT5UMsik4JCQ1Zyh2b5LfDjnagk2DbZJYExHLRHx5kDbd+EErOs80pJ?=
 =?us-ascii?Q?QKhcXFg2NKLtqhFzO6HiwpwGzQd//1JXIn/5dMEov5rjSpii1VkmFMBkhqaA?=
 =?us-ascii?Q?XZ4Fd+ZSRna/6dYd1Iyp6owNIZu4Wz+JtVhjwY2yLmxgPxvePBEjt3PXoUdt?=
 =?us-ascii?Q?wf0vNM3Wozp8U/6xqT7hsbpK1NLEt3lDm01AfBtnHtCfYg/Cy11roVt5uFit?=
 =?us-ascii?Q?fKjn1qci29m8i7pb4u9AVBJdkS2BNGxgOb/WOP5CRBb+/hixY5Daq1GKhzXi?=
 =?us-ascii?Q?gBnLB5TTBxfL1JFQ9EqDaMReacauQVdcQc3zNXkfT3NfbPE+ra9ZsmIocS6Z?=
 =?us-ascii?Q?fxxGxwtTOGjdAUuK0KGud0Xgn+rnVsv2ij4pevsuKShsIwvl0bTo/yLPKKv9?=
 =?us-ascii?Q?cYskb4of6ul0OSFEFhlYxxbHb9ldFvLXR/+X7GMR9Da3S8tYuUDnz/BJi9qz?=
 =?us-ascii?Q?CpHfDF1mtH13BhodHfjxASkplAw64P8Aks9bmxPRlZ6QNB4SLtVtTnGCu5jc?=
 =?us-ascii?Q?JmY2WRF416bszSDgMHeAabbntl/t6z/5a6maSVA4WJvBPvAQ39j7K7fnV3/1?=
 =?us-ascii?Q?E7TCKE115wBndMmjiMwZ9YT+bsvy+07dl1M6yrCVaq/JMSJQzjHEAicTIyQP?=
 =?us-ascii?Q?IsiBT/8n0K+pKDR1QoJWzTWQRTA880x9uz6JTh2wrL/rx+MfoXDCWoVWQguZ?=
 =?us-ascii?Q?ux8fkZYxTN8lbtL8k8nLtOrrxn1nRIUWrZ2dHGiyGd8r08Pot8jWG9RRBZvQ?=
 =?us-ascii?Q?wbZyWpen1QsAaE8aDppxhJiYmROeBIvDzkZBBXn9bheHlUDlqmA6182jRPwH?=
 =?us-ascii?Q?nZR17qn+v5nxJyJXwyKi8dR/KQjKWbJBMUzUJZdKch02pGl0zcciUf+jiEqf?=
 =?us-ascii?Q?YhUaWqgwEDi1CFfywkmb6y4QQXCcuokKLz4K5KdV?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89943e92-a751-4135-bca5-08db14b6b822
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2023 09:25:20.8162
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uSS06SBJSX+ERvaXrLmLHsB6EVRBJWeKoouJdIVBBAlmuo365bvaP2xy04nSyiRp9PmEl1r5tbELFvAcfnxu+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6907
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Zhao, Yan Y <yan.y.zhao@intel.com>
> Sent: Wednesday, February 22, 2023 3:50 PM
> group->iommufd is not initialized for the iommufd_ctx_put()
>=20
> [20018.331541] BUG: kernel NULL pointer dereference, address:
> 0000000000000000
> [20018.377508] RIP: 0010:iommufd_ctx_put+0x5/0x10 [iommufd]
> ...
> [20018.476483] Call Trace:
> [20018.479214]  <TASK>
> [20018.481555]  vfio_group_fops_unl_ioctl+0x506/0x690 [vfio]
> [20018.487586]  __x64_sys_ioctl+0x6a/0xb0
> [20018.491773]  ? trace_hardirqs_on+0xc5/0xe0
> [20018.496347]  do_syscall_64+0x67/0x90
> [20018.500340]  entry_SYSCALL_64_after_hwframe+0x4b/0xb5
>=20
> Fixes: 9eefba8002c2 ("vfio: Move vfio group specific code into group.c")
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>

Reviewed-by: Yi Liu <yi.l.liu@intel.com>

> ---
>  drivers/vfio/group.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index 57ebe5e1a7e6..8649f85f3be4 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -137,7 +137,7 @@ static int vfio_group_ioctl_set_container(struct
> vfio_group *group,
>=20
>  		ret =3D iommufd_vfio_compat_ioas_id(iommufd, &ioas_id);
>  		if (ret) {
> -			iommufd_ctx_put(group->iommufd);
> +			iommufd_ctx_put(iommufd);
>  			goto out_unlock;
>  		}
>=20
> --
> 2.17.1

