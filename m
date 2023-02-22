Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90E5969EF8A
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 08:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbjBVHoT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 02:44:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjBVHoR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 02:44:17 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EBD41B556;
        Tue, 21 Feb 2023 23:44:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677051856; x=1708587856;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XsLXYjtpLNAHlw6vo12psZLTNbI9DTurdZ+fgvJ2IqU=;
  b=QVvgl+Jiw0YYu5litwJZP9PXXHfBXUMll2MXz3CbZjgPtYPcb5Gerd1U
   CGEi8sbRz/V8ZoqEPa5bn7n6G5eZsIjh0d9qeKqb23dsFBU6gXKn4x0IK
   TbyWGZbECk1m6wuLvP4w6Jqgq4BJCWkyKH94cYzNs2fmSHzFDd96lMDwe
   SRPNIbw+m9rPsVhwZLUuO1fskTXXoiocjDeyVZlJbwh2TYzIHLCp0luAo
   60JtTmLWMK6dByC6D5OoC3eRLea3VoRo7ba75w/ryjp7YStu0kY+qdGzW
   EVg8h8s4aOM2l9UkkbCAkk9mxrsRfl7/GHKbovgcgsS8lDOcXMLeIU5v1
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="360339834"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="360339834"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 23:44:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="917477707"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="917477707"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 21 Feb 2023 23:44:15 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 21 Feb 2023 23:44:15 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 21 Feb 2023 23:44:15 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 21 Feb 2023 23:44:15 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 21 Feb 2023 23:44:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b1BVaw0/fEeQX45hOtXTez44Q61fCBwkAbatogACnEksIQTBo0d9+jJFqBJLt0MyRt5/MehjdjgLw/KLpRDmfIlEzt2P1cowg175xj6KoPXLQR+y5br0T6ttKa1G2m4XF7ECbbEf9n5L8SPJLCGVviJOWn5m4DqUU6NXAIFBgG1zdgFEUGUMCjpa5UmbbRzARa0PykPCQkRa3TePWIZpApXE99k/y2so/nZjjLgsjdifbn315YINHZTy1pYfjmc/lY6bVHtKvmPXH0CUz2DmzJ6A5GhiyEYz8KRKLiNIzdZJWr9PGuFm9db9+ttFVxDlluW1gUgxMTLkfJCjPf+91w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kDXcP9cKHGtFGMiRRq3FAgTPMXP8quchXbbHyIvBVgA=;
 b=SFi2TS4gWtcQTAbb8m93gLEM2dYvV/uCN0rXnQxlosQT7eZtky+gBdc7IrBX7kLCxnIeSlT1R7DTXNkjZCSUkidc7jDxSAE+L5Pjp0RB6ZceZDIaRY3NHwmeKCQ8SCY03ho+bD/dpFxUc5ENqrHeF/nO6kQ9wMweHM+p3jzc5Tt/tkcOlhbPgNNrG/rnYOBAFsgW4bcnDMODUl60MzZKdMZLbBC2s8qhwPqk6Fqq5ZEVXCd6kquKpbdq5y+gi6QxcyIzW8uhnbim6suikn84co9ziId8muNTnfVlY2AUeES+U8Ebxo8/kyNI2vi2Oxvqc6DSgpl4sf5LN1zDwJJaGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CY5PR11MB6137.namprd11.prod.outlook.com (2603:10b6:930:2b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Wed, 22 Feb
 2023 07:44:13 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%6]) with mapi id 15.20.6134.019; Wed, 22 Feb 2023
 07:44:13 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
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
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v4 16/19] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Topic: [PATCH v4 16/19] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Index: AQHZRadlPoyJ97Lj9Ei0xbUhG/v/kK7alloAgAAAs5A=
Date:   Wed, 22 Feb 2023 07:44:12 +0000
Message-ID: <DS0PR11MB7529D04D2EB9B5C69C306C16C3AA9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230221034812.138051-1-yi.l.liu@intel.com>
 <20230221034812.138051-17-yi.l.liu@intel.com>
 <BL1PR11MB5271AB3735F7A783C2871DB88CAA9@BL1PR11MB5271.namprd11.prod.outlook.com>
In-Reply-To: <BL1PR11MB5271AB3735F7A783C2871DB88CAA9@BL1PR11MB5271.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|CY5PR11MB6137:EE_
x-ms-office365-filtering-correlation-id: 20e11d6a-08af-44d0-8381-08db14a89755
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pN+OArjAYxhQ8PSN9xJ/LLNdVi2Jv/bRV+YPP9GqLhBSnO1gxEhsHW5QS2KPozk9cZT6+eTYrY4IJyni4reTb/5grVAOhMGB3xDco30v6Z1g3aSae1lp7kSLtQ5zL0m1DAzNQowPGJuVlbvc4v1hMEu7nOdJYBlsbxMNltiy+iqcpB2QOyl99i0kFbO8XBwBz/qZ0kKJNul63OPmHY9JhhoG7xt9uSW7kZjTCVucgATpj0xHSMS1pnEYetbs/8/aVHcx7yjjLkUq+JXwN5oqtwyxdOEBRuyx51+rm5y5lR+NHqXgJuZHTEj15KTjujrTRrNzybVLdH187TOmoV5al2x0z3NtlJK6qAERYhIkeOGyAWpRuUgkiS0fAK02qiTt9TV9rRtO8CQJYTy3Zwe2v58nAmIJ/GD38b/TBIbNS9WZfwLnt4TWPsxEQeTTs6V6GMS8Of13fUCSBSGLbyqTC2Oeeg7lGO0twU8yCMIHqwqgbz4VWl8TDuw6gfExQUQ25/H6oJD4IlPvLldcLV4C8uZxPrEDbVNLEr1s/YSHAGgpXwjQbcu3yx49Hm4McJ737QkSbKGn5TXHUhOhg188DhsZ4GRCVrYWXN1ai3o2vLw066OVBYfxy0rKhuZpJMv8e4QumCIHgYRlA+xVGgIyT6WdVZDvdleBbOUEJjhWc8sCQkfDYfL6hIHUWBN1rn4HWcBrTwNPFnGzxuOIcoCKow==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(396003)(136003)(366004)(376002)(451199018)(7696005)(5660300002)(7416002)(71200400001)(6506007)(9686003)(26005)(186003)(54906003)(110136005)(478600001)(316002)(83380400001)(38070700005)(64756008)(8676002)(4326008)(66446008)(55016003)(8936002)(41300700001)(52536014)(66556008)(66476007)(76116006)(33656002)(66946007)(4744005)(122000001)(38100700002)(86362001)(82960400001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CEu8zSt0TSTKC5EBhiXLPO9XskiiGkICgNDzrHSNKGprFeNPspJt2sEmCBUI?=
 =?us-ascii?Q?8VoxoZ1DSingJh/L2nzrV+yzlqajebJRCYCOeESh6MqoYCDFTKJia9onF8YM?=
 =?us-ascii?Q?OjxcTs7L38blPGoG5gPvm+lGNKahXtHUul9QMkGtiu/2VQxLxNhMSu0Oh5E8?=
 =?us-ascii?Q?x+7RAngQItyti0lMa2gN8E4W8kF7kc3scp2AJ5qWCEokA4+VMVJC1A8HDwtZ?=
 =?us-ascii?Q?0hRwKNkaRQney7qRiGqBtHlYOG/xdHAWVPP3Y72NqcESZ9gixWWAva1WwPhD?=
 =?us-ascii?Q?E/Ar9zQjT/fXnYZsAQY6xlms2VMtEQ8q+VvWC4T6sAgYtMVEW+0kZQcwQPdz?=
 =?us-ascii?Q?Gcda0my138XuCDpLMzxxNmxu5T6uKIKCrt6X8AYQt8FVi46/2jF4jHPlR+E4?=
 =?us-ascii?Q?Xusni5jPTOqexGq5MDQqPvyiqA6a5097vLmnKCqRc3H2N1b6bSmOcMsvwAr+?=
 =?us-ascii?Q?6TfQ7Koz2iaSIEiasqx6+VtM4i0efQyx7ZzBRf1r4XSWnROSTBbX/xVZel2Q?=
 =?us-ascii?Q?rGaA50hXtj9FPf3bMjzYeCNVfPayy8t+Sb+6K23fjrCrMrjP0ETnSxUljpUU?=
 =?us-ascii?Q?Xm/QV0jUrNtdA5xqtV49wgQzVx6FRTQatR5bsheeQcwAbp6ee/BPKR6B3RE4?=
 =?us-ascii?Q?0POIpfrnST7PdPHNvLfW6tfCF9dITuUGTZ4FYoUUlGxQ5QtxsH53/G2eIATG?=
 =?us-ascii?Q?9G7N787TFNEmalez85ZQEoFNFtr+FRMAf98UmZ8Y4bqgaOLwC31xn8BKwP/s?=
 =?us-ascii?Q?gYaPlrTDFha9/LfA5KUL/Bi9kl84EDs/MOh9PviM3kUwmvmwM6B4gOUjgNrn?=
 =?us-ascii?Q?lEw0Ux5O+oK0HZb6aPjiqRyCD0lObJy4VQ7kHeHayiYKbEPj0QeMFfI90dYt?=
 =?us-ascii?Q?82DFpoXfqgKXle89qrfu8SXDgRqKofNSbfHu3iqABwCdYcwHOYI33nczG8O1?=
 =?us-ascii?Q?JkpMiJHGE7PJtnzchvX/4ON4/wOj/QYx0uBBm2zVAxiceY/mX/MQldd1VQhq?=
 =?us-ascii?Q?uBNNFDTtb1TZRBQOUqBhtdJ+UpZ1NJv2KmzkaoxVhO+qhmgLDCd+KgvWw3XK?=
 =?us-ascii?Q?F06AjxN77YiZgTLAzp56YAeGOrOC7v1egXO6BY1jK0Nk2OSUt4rVG8gCGQY2?=
 =?us-ascii?Q?/lQYnFNtQZrWjCW6wKpQFXALkJzsIPzd0OpygMqig8M34R5vfPU0qNn/COuL?=
 =?us-ascii?Q?LB6ymbeQIvvEOwFh7PP4ScCKEGBSIowTrw30imMy5YjaWXjzhZ/mfkMAGzvN?=
 =?us-ascii?Q?maDUmJAlxC25dJSpr/DgN+dIrL++iFFF1bx/OuWjDbvpBVquAfrMEnQgri7h?=
 =?us-ascii?Q?Sc/6NRUrXKlglnbabsa+tO0FhpeM+pzOaxVCZp3W2YnjQA4R2ZLOCXySNjad?=
 =?us-ascii?Q?+qOBdUUqRCA7XpIKvOjXhjHraHxuApFGfLU5fpnF+p1Vi3Z19t5oC0sgLwb4?=
 =?us-ascii?Q?WwBq1eKGv1UGNDToOd+/ZiqlMk5zy1hBZkTGiJC+eiJdxEEJF5TqQtNz+dQD?=
 =?us-ascii?Q?egFHsicxQAYcjLdCz9tPxeWZ40SCDsWRlaeCQr4GcyDPEj1YBv6+vgzf2rNk?=
 =?us-ascii?Q?IBIZf/r7CLb22ia0AaZakgPV8Cww80LIpjjfHcvr?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20e11d6a-08af-44d0-8381-08db14a89755
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2023 07:44:12.8926
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8hdQmtYRcrq3hYJMe2JBBncvv9PDhCYwDOB2sYNb4pj+rTKOy5qJlXDlRHSPFAMFINN2/z26umwz/ibnObgFXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6137
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

> From: Tian, Kevin <kevin.tian@intel.com>
> Sent: Wednesday, February 22, 2023 3:40 PM
>=20
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Tuesday, February 21, 2023 11:48 AM
> >
> > +
> > +void vfio_device_cdev_close(struct vfio_device_file *df)
> > +{
> > +	struct vfio_device *device =3D df->device;
> > +
> > +	mutex_lock(&device->dev_set->lock);
> > +	if (!smp_load_acquire(&df->access_granted)) {
>=20
> there is no contention with another one changing this flag at this
> point so directly accessing it is fine.

make sense.=20

> but actually should check device->open_count as v3 does. Otherwise
> the last error on copy_to_user() in ioctl_bind_iommufd() simply returns
> here given df->access_granted hasn't been set but .open_device()
> has been completed.

If copy_to_user() failed, vfio_device_close() would be called in the
error path. Then this close function just returns.

Regards,
Yi Liu
