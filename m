Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 068E37192CC
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 07:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbjFAF4R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 01:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231488AbjFAFz7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 01:55:59 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E465BE54;
        Wed, 31 May 2023 22:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685598905; x=1717134905;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WVlsCmf2zPfDM7P8FFcYQuvp5wHH0kMW1WSDvkII2KU=;
  b=SIsYnxsZFVFYOMW9mnBDg9osVarCWRhlfHST+ZBMk/dBSjnlcDL0dcDU
   M2JrBZec2m/rIUz14YiXIxzghoQI2BNtMv/wCAyj61VLqBxnX3Q/3wNLf
   TAxBohdx7Ehe7H5WeIdYd+V8zyw2kRVoZfOZO2Uh+Q/DoqfDoMlB2igGq
   nMrTEoAkm7r6fkxyu870ETED5xG7Re60CIEqAjMLZVAAmIxO+ePN3aPpM
   AYb8oR8aHPveunaE5iwlNNh+BSyTA9UKqCYQu7L7ZRr12lEax6w0+vkHv
   5TjaljqCYwPWUvy6SgpilhqzV8ou74Grg+QcA5OXHduGVCdX6iUeT+j/P
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="358734778"
X-IronPort-AV: E=Sophos;i="6.00,209,1681196400"; 
   d="scan'208";a="358734778"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 22:55:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="953930601"
X-IronPort-AV: E=Sophos;i="6.00,209,1681196400"; 
   d="scan'208";a="953930601"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 31 May 2023 22:55:04 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 31 May 2023 22:55:03 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 31 May 2023 22:55:03 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 31 May 2023 22:55:03 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 31 May 2023 22:55:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FTSMe7XYlGGfdsAveZZarcL0VGvqvYIHNrIY4dc4TvDZv20KRQafqxzVFEfBKxQIrCAFyFlHE5R8oAj6w/y5pUukssO1txO0Kgd75jTYUV1Fu8IvetTnZHbv/rmypakfx1c0m/oqcqXTCLF+IX4I3dvHK6pU1CpAGmkTUvyamuZC7JxYZjd9ftOa9OsnQJ1MImcUAExyN4MFd8b6axT3Ca89mGyyRzMEEBHgCNAD0tT3uYWWw6FvN/8Bi69cfVqF1KK/PdMv1Kq6FqutALwZBetWSc9iZQkJINIeiMR7wyX8WgLWukPkjqgtEyV31CfKcVB48pAslHvcQCOkPLTe8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rQl8hizqObDhVVXAmSsQ7n/FtDpjOJOtiImn6720tno=;
 b=R1i0Ol10fslTYnDLJuyBaCwo8U4bnuDsdw1Hgj72NwzYaaNhZRGs9ZkJ2GtRCLUnKRoYhYm9Rbd5hpG91pm8zGTfQ5o2QBRBvkie8txMDH+3/RHdwzmr/aYOjSTEVDT9OwoWYi5cz0pgnXemvMpwG9m7iPwbMLKck94c84BA3b0ONrPqD2MHY7DcjzlZQIuvGlZxgxHmFufty7LMqJ3YskxMhIeqILiir/qI57ZJTTAhHuiYgzmxhwkQ0d0FX7jp61p6oe2+T8BQ09xmMoAA90FXXx7B1zX60pOzWPzC9kRMcvW75HkoheAgNq0TQJCBRL/e3+hckLgvohnzUs9bsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by BL1PR11MB6051.namprd11.prod.outlook.com (2603:10b6:208:393::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Thu, 1 Jun
 2023 05:55:00 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6433.024; Thu, 1 Jun 2023
 05:55:00 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: RE: [PATCH v6 10/10] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v6 10/10] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZjKSt5YzaYa3rmk2neLlrrfQXoq9p4OwAgAhcP0CAAnJMAIAA0i9g
Date:   Thu, 1 Jun 2023 05:55:00 +0000
Message-ID: <DS0PR11MB7529F8C9636AB2DBAF1FA5D4C3499@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230522115751.326947-1-yi.l.liu@intel.com>
        <20230522115751.326947-11-yi.l.liu@intel.com>
        <20230524141956.3655fab5.alex.williamson@redhat.com>
        <DS0PR11MB75298C069D298D29D9B7B459C34B9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230531112146.7950d01a.alex.williamson@redhat.com>
In-Reply-To: <20230531112146.7950d01a.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|BL1PR11MB6051:EE_
x-ms-office365-filtering-correlation-id: 28ddb810-69f5-49f3-7f50-08db6264bc70
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zd46z0g2mKSvpdGueW4OSEPZd66u0fbFsOs8gzME1glIfVKW9yIHJHcll+eHi3sPLsiZjldItyduOUZHJ2zFLuvuTNkIsjeT8nIYIoN/How6ay802tRRyc0AyVyJu0lx5OuCi6n6g80Y5ZRn6xFq+RuFTu8ygNJ6DwzwFN7eJHzTyIGpTHktl9Xx7Duk1OThWtzE7Pjl0GiUtAvyRr+oY1S1lWhlKN/APVFcPckFONEs/NQ7fn6UHYI1LrexmoU2J4oi0NA6FjM/7pJl5Tv+rW7+Ah0ZpZm+cqxhu1EO6OdX5uclc8H0Zj+8TBiazXshcaZ6+9VmuLzYjEnBTzEOtG1UpATbfBQp9aCiRvu+L4DGyXPp08SQuLlWppmVhdopt1TkP9NUPWE2XxceuQLq0NVP0l0dpvDeSUG0GAl242etr1drnQNmHMFE7EnZZxjLV/tt9Frk4t5xlYeOj5LehVSdg+qt0X8+Qn7dr6ri+x6aewf+Gric3xeNEDUBL5p3Wk65yyL33bJMj4dm+0kC3S5gCS2Ew6HB4huowFXOCgogRb7t5YbQ5EDh5APNPO3/svmVTh84zJAay2XEccl4m1iffx3P7YrZDYJukVssfU+QV3Rq0NnvWAQh+LCdV50vpAyY4p2ISvAmF881Mm3jwA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(396003)(366004)(346002)(376002)(451199021)(7696005)(71200400001)(478600001)(33656002)(6506007)(9686003)(83380400001)(86362001)(38070700005)(38100700002)(82960400001)(122000001)(26005)(186003)(55016003)(316002)(41300700001)(66946007)(76116006)(66556008)(66476007)(4326008)(52536014)(6916009)(64756008)(66446008)(7416002)(8676002)(2906002)(8936002)(5660300002)(54906003)(309714004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Qg97pKwOidkasKUjKaa3JtpcLjv6soroUzcj6IdK4++ji9cm3jzdK0zRBSbr?=
 =?us-ascii?Q?Eka4i/NexrrCS7hmaMk5Oh8ZdTeUIT4FkRo1MtoPLcmkcf/w25Jv/DRQJO7m?=
 =?us-ascii?Q?Nw8Qi7FqDhNzpJR6vMV4+EJ+9x8id04TdkQsoHVNC3GhNmasfb0kg/p3/7dX?=
 =?us-ascii?Q?B54aFRZ3YnvuQ5m0uHf6kmupCaKatBmq2l9CSQCbADKlWc6DUjkamotddrFo?=
 =?us-ascii?Q?DWAOFrisHji/m3uSSOk6uGIImhinGxCjYNP/stYqeiM/UCFAaPgmoblNivoE?=
 =?us-ascii?Q?hJE07w2o7D1+aJm+TM2cD5KdFX0Vg5jIsFExX6KYhFkcTGt7YM1PdMCVRzr4?=
 =?us-ascii?Q?g19CBJbYniffs40Wz1jzRGR34jU9ugXXnsVbe44jweQhmpyph+T9g6CtHQ3D?=
 =?us-ascii?Q?CEnkQiPD3WQHy70czsCzmelIMhAuV4EjjXIQvc6X4BqAFTCLLq9a12pSlSyN?=
 =?us-ascii?Q?VoAw4iM4uD4kEE2En/iFj09y/kEUzMgUoc+bzt9TNxpJPcififFwZ1ulYTjX?=
 =?us-ascii?Q?epRtRvfXI7qw8OfkIF8+kPkXQhVi44x7+MKZLAcZA4cTZT3aQKUhmp1HN3L/?=
 =?us-ascii?Q?8agu6tZklKw0F06iJuDiqA+wlybJMwLblrQxSofauTXVCQt/jIjhRSUJW/sf?=
 =?us-ascii?Q?SJ6aBFnqh39QZxfrqJqLuHoWFtAilf0bQd2m4iw/r8AM98RL6iIYNNYHrx3g?=
 =?us-ascii?Q?Jt2jTBV7ZmBeYo1tuEsroWr0gQW7LhwwwbGi0J1/IsPM8AMaz9wCx91nkMbE?=
 =?us-ascii?Q?2/1An9RpXmtIiJ0mXffIK0SGQhSXignKFrv9Uu3vO73wE3CDP2uiLIrn4BWp?=
 =?us-ascii?Q?0Wm/rlGj9l52veZJGRBNm+2Z7NhZ5rsYWztn7hgcriMJiGWtkAhUPKAPaadU?=
 =?us-ascii?Q?GFQz6nxMtdtUaTQIl54KEnrb4iaFmaoans2DBj0NnWF3nftlJS3YExtD6b+9?=
 =?us-ascii?Q?UpVArqJA6H2btAMMicy7Zt79By6+n7cNb4wCj3cbXJjq8vG9MIWYuk5cWpnN?=
 =?us-ascii?Q?YIZftJaongKCOnALzDWZIw6Sy0Q0Sy/uWzQO2LtOLBlzxy4XjqCSHONvWR43?=
 =?us-ascii?Q?U9+MOsKrLyZ1wst5cEKGMaPajJlKkr+FwSOJK/hvCciY+DJLS2ImsF4r6RTR?=
 =?us-ascii?Q?0U2x+FD0neP4Xf+7bEUtIgBqIvvv/7Cj9lfMgEM2WXzld4VZDfz++CBQJ1AD?=
 =?us-ascii?Q?Mc5i60piJPgZKEDHuITm/LOHBvdLME8FQCSKCl2lAwm5DRKVkiwK/z3/Ptyi?=
 =?us-ascii?Q?EOydfsYaX4TxXrefzY04SMjkmnLY8kikPzGdowTjYN2okkAF22MCpmYQztsR?=
 =?us-ascii?Q?ZMv34rygvIK3xae5CqQSQNIMuValZuBK+aeuY85MbS12jmJK/ffXVckDD9Ie?=
 =?us-ascii?Q?nr/oTZyh3fIfo+wNH6vuxx72HZrWNXTUfnBQbpnDyMQpo3S0LeIOgVFYvmgs?=
 =?us-ascii?Q?Tj2R87H4elLrM3Vl1qUmyeW1wozVTZ+K9BifBAY6y2A1eyk7NlPW7I/h3+wp?=
 =?us-ascii?Q?qbyFfwqnPi3lFBDC3r6E599qcQszaOirii9PDzwUhASKjK+qXXyOA872yGie?=
 =?us-ascii?Q?+aXEeD3+FSl0hEn96cbzvMzuuo++/dFkf7CmJb9U?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28ddb810-69f5-49f3-7f50-08db6264bc70
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2023 05:55:00.0339
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F4kvy1sW9KBm7KD76wqKbLSKIfvgiUsTsdENaoy9VCsVFWAXOG4f8liXZsC8qjzQbfhPLK2MAYP645XhDMEA8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6051
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

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, June 1, 2023 1:22 AM

> > Now, I intend to disallow it. If compat mode user binds the devices
> > to different containers, it shall be able to do hot reset as it can use
> > group fd to prove ownership. But if using the zero-length array, it
> > would be failed. So we may add below logic and remove the
> > vfio_device_cdev_opened() in vfio_pci_ioctl_pci_hot_reset_groups().
> >
> > vfio_pci_ioctl_pci_hot_reset()
> > {
> > ...
> > 	if (!!hdr.count =3D=3D !!vfio_device_cdev_opened(&vdev->vdev))
> > 		return -EINVAL;
> > 	if (hdr.count)
> > 		vfio_pci_ioctl_pci_hot_reset_groups(vdev, hdr.count, slot, arg);
> > 	return vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, NULL,
> > 					     vfio_iommufd_device_ictx(&vdev->vdev));
> > }
> >
> > >
> > > I thought it would be that this function is called with groups =3D=3D=
 NULL
> > > and therefore the vfio_dev_in_groups() test below fails, but I don't
> > > think that's true for a compat opened device.  Thanks,
> >
> > How about above logic?
>=20
> The double negating a function that already returns bool is a bit

Yes.

> excessive.  I might also move the test closer to the other parameter
> checking with a comment noting the null array interface is only for
> cdev opened devices.  Thanks,

Yes.

Regards,
Yi Liu
