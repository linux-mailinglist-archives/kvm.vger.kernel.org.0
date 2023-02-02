Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 146BB687443
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 05:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbjBBEHn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 23:07:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjBBEHl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 23:07:41 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3238A2111;
        Wed,  1 Feb 2023 20:07:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675310861; x=1706846861;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AqsMQys2bycNjOvUMRK+oAWmCGPaZNT2xwNCZSmbbKY=;
  b=WKrHgQO40aUzvKtQqb6ioEoBFJbl9dR2dIuz7qwjfcv0yY1EMorLVBP6
   fZ86dlntfaugspd8nlk0Y1ZhFl4qs68JC4u11vDkw4nj+AoUFVKF76Pbg
   q9w8PawTbzhuF+mFPJt4XXpZTXnj0+aHzFIoAwXDeo/4Qzw9uGOVxB4x6
   POkvfWcewXUPqOA5tykO5xcwrJ/aaoqokNCCZjXirBY0OIyTDefE60mHM
   p0TFmqAY43UoRyXdltVdUhE/Tru7BHGowcAF3EIg4QZBbYMmBfPzwaquy
   h36lObQP2k7Y7w20yNa1hl0l0zK70svvfkqzBZONkJife4ow8S3yGFvHO
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="328359892"
X-IronPort-AV: E=Sophos;i="5.97,266,1669104000"; 
   d="scan'208";a="328359892"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 20:07:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="642733427"
X-IronPort-AV: E=Sophos;i="5.97,266,1669104000"; 
   d="scan'208";a="642733427"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 01 Feb 2023 20:07:36 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 1 Feb 2023 20:07:31 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 1 Feb 2023 20:07:30 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 1 Feb 2023 20:07:30 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 1 Feb 2023 20:07:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P9UAIIobzTMvJgxchv4tjhOv1DFFplWfLEVblTAKywAQ3PwxIcO2WcdPgqfWlexmfOqd/QeqcOqOmprqP7tPBTQbBwB98F9vgGSCM9VJXaxQN3Ep2KHuzXKzwzMS5l/tyso41AMsc+l8RhQPeW+/I9JYZpIlgTSSKCU5tUKpCntqL0Xz85NYuxDOCRsNhVusNxgWoz58N9JuWGq/+YgrTlo2C/RY1Z7X/CpVTxFdzALHx8da5x536P9AFT2MezO28v9SuTXev9AP8f0+5ntgf6ZMkFjgebIhudRCxRIBK17FLsFgJnezxaMevZA4qNFM+5JMk8EpnyLC8giD6sV/gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oi8alQ7if8wPOIoS1yoW52n4tNMsknfrM5J9ntp9Yog=;
 b=OgB0NXqHn4wHGCqF1CYWQM+bSCue7dwbx+iJotYlXnIZJEEmi7ZzYENWczjFtgk8UhKjIJiVrUCyjLY8SSFefI4WVLbEU+kcCi9qk/KNl8kp6/DKQvcqtvuWcCiJvia+ou98W7/RD1g/RRlb7MhwfeNK0zdYs6sBuXSaIT9kr2TrNsPCZEqTUDdCAKlJSwigYikwlh/mG/xivXHf7qpr6Jo5x3EFQA5ylHr6GzfCCW17fJurjpbNFFGQXWlJ7VVbBnaeJcztjmWY9Q/8U9OvxColB9Ao+933ByTi38gwdrFoLB297fp8wlCuaTd7GlufTii4OlKnpu3myWPti78yMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH8PR11MB7000.namprd11.prod.outlook.com (2603:10b6:510:220::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.25; Thu, 2 Feb
 2023 04:07:26 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%8]) with mapi id 15.20.6064.027; Thu, 2 Feb 2023
 04:07:26 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
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
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] vfio: fix deadlock between group lock and kvm lock
Thread-Topic: [PATCH v2] vfio: fix deadlock between group lock and kvm lock
Thread-Index: AQHZNnJFiVrNVn+VRUK8FiGvi+QS2a66vJwAgABIgICAAAVb0A==
Date:   Thu, 2 Feb 2023 04:07:25 +0000
Message-ID: <BN9PR11MB527649C5C0120F73DC8835528CD69@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230201192010.42748-1-mjrosato@linux.ibm.com>
 <20230201162730.685b5332.alex.williamson@redhat.com>
 <DS0PR11MB75298437F96D08758DB92368C3D69@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB75298437F96D08758DB92368C3D69@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH8PR11MB7000:EE_
x-ms-office365-filtering-correlation-id: c9c65b95-b575-41b9-f9ab-08db04d2fe41
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xx4+eEs2tLvr6P0kAq8R2lhGnSZdYN7nC2PYOCCun/Dp9OdyYGUiNAVbQ593dPKX0sICG2uB3hbNI3fmxKICox9czphohTyOyVlVvrxF5lmMM+vpeWL5jStYOmyFXzNvr07FtOIq8jpBLRynAIvj6jYtWkPWiXElVNy+lD4lysh2rJ1ugFls9cQXeNqiXQgDo3LBzdXHBvi6qbimq+qoQjJN4o9pLd59ClGn0QXMVy/U7eFGYSUPhoSjj3gnCjP9LVA5sPm2Wp9rf8AHUluvvdenR2smb35EfESzKnoZeworvOKF73oSc80ZVsugYuksdBW9XfY6lNjNCzX/RXn3o9jG20F2zfeXD2dLw8kbvfzWFhVAEF2Dp+N14jHDfmgRxKSglbDcAO0a4n0V7YMeyYeg59D/RcumtNNPe2TkgRLqO0iRwAQK/gdoqkc3Td2gG3EpXNHLu1V+wwqa0ahePv5JhzRUKo2g+kXCKCwQVU/iyKDR0+42WHzwUBP+zcKg7gSpYUZKUmqrmreVOgAdCUSoCA4p3D7Sgsswn+xtr9GfWmE1XN+r67ScQQiHZaIGIn8pCNrdRJ/Z6R73NPMrnly7Swib4qNFkDUVCLagJBrMgbWl2Ly08cz/DVGf7tEgBaahRSVrAh2xlHCHRVG5jxHVdkicrs1tPuaKcIf4+Ru52xksGIM5QqwkaoLRwegdtMSmJ73bOs+6ixeUVYk2/w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(136003)(39860400002)(396003)(366004)(376002)(451199018)(66556008)(64756008)(66476007)(66946007)(76116006)(66446008)(83380400001)(41300700001)(122000001)(8676002)(110136005)(4326008)(8936002)(316002)(52536014)(7416002)(2906002)(4744005)(55016003)(71200400001)(33656002)(5660300002)(54906003)(6506007)(478600001)(86362001)(9686003)(26005)(38100700002)(38070700005)(186003)(7696005)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YT8/TspjEr9iGJLkJpthGmb37hVqAIKmnXhl7SJAIx5nb1XCOGgiY152rPTk?=
 =?us-ascii?Q?6CgxzDSwdozHv3+LTqcghq7rFGboLR2MYBfk9oHFir/fILVCh8gp5G6/zRKP?=
 =?us-ascii?Q?dLNwedc+NVtP9rmzNTlOW/UHNYk3VfUm2ouPUaVkfeKq6+n/PJ9GzbhpFp6j?=
 =?us-ascii?Q?tUeesfd18BFpJibxmfFmTxYZQgW1LvJVIbxHC0lpkcl1mwWDSWUkW+Tie4X9?=
 =?us-ascii?Q?DD7C6U+2qSA3FRFwlS7lxgT8z8hrhtJHvtGhnEe5HRse8brwS4dFPSxnKstn?=
 =?us-ascii?Q?/M+14mGsFrt3g2p1918cMRui5FzdyqmigmNt3kX81mLbK1SJsi0fHP0v+hi0?=
 =?us-ascii?Q?f1Gg6fvpssiEknWwoTa5HNKsg8USbSYmMoOUpS/909jlmFV+20gYjadiHyhT?=
 =?us-ascii?Q?MPvJlOmgBzac+I7NdcH91TeSiQdtTVo+NbA+onR2dZzIppTTzb0P7VFUkykF?=
 =?us-ascii?Q?7jfs+v6mFLSDPgs4HyJvXsyJ2L2GOajSLPpEhhiWaVMEB0u3b4s+VHwuFRzt?=
 =?us-ascii?Q?oXaCctbquTQ1VkPFbk7qPufqAo8DbowYN53O8mMbBNuWi9/ZgnHDpRHfhIwO?=
 =?us-ascii?Q?3CiXCzOmT9cHPsz/khu6kV2/sVHs+gzfBzNjgKcdIYm7xEehvd8lsRDmxQs5?=
 =?us-ascii?Q?ix1ShW9OxcPoIJyNVNKzL11b/xmW6SgCKBjV4WCROItyRrtsXtWSoEN4w/xk?=
 =?us-ascii?Q?gjqlmphOxFTJgxZYslnNhZ1T4oEKo7Brnew87pOh9s42SPBKPrtWjJUlYjtv?=
 =?us-ascii?Q?nc9oOSMtJRVd8vkAqknPhickXeEpT7qwWMGAmGK8d7fo7yVuDUV9RoHYH/Mt?=
 =?us-ascii?Q?GJCgtbU2btxdNpV7/XRbJOsV0GkGfRwdlVIIr9bCSX+H0uKItJAoSfF47bG6?=
 =?us-ascii?Q?ELw1OGng0zdZkEvPuPJTaPWEPJMpFi30WIn+RqlgKSWCa/NG0Kz9hIuBqiCL?=
 =?us-ascii?Q?W/YleKRW5Fv9zly+EoDmN0S8rMaCs7MnHqXMblQVX1XSfccdN5zZPEUfM6gh?=
 =?us-ascii?Q?reM7Zja51SNZhkmzAH8O9HaTmMBKzPhaHpGeQNiQN/3UpNPgx6mC4FaN0F+8?=
 =?us-ascii?Q?6xX0YueBjiKCkBjo66RgUujH+N8iIvgoQjCniKKFuvJDw/5Skq1lm+syS1Tl?=
 =?us-ascii?Q?tQAvc1kgOsNXVFSw3F8k+KOphHM0KVwkoo9YFYq2uMtGrtlLU7uQbc5oYIwo?=
 =?us-ascii?Q?q8nUJMq0OC/Kl1XTN8CN2Lz/q9B/X5wChvp0WxKiYhQgJy7zLctH2/wApp+h?=
 =?us-ascii?Q?fsJKtwpv8nc1GW6ciUvOKzIr0lqXqCS0hKAUEzU91UCMf6nq2Pb2J/086nPu?=
 =?us-ascii?Q?or0n2ivxpxqObl6TH2T6H3SOpEORAe6LuHO3MKeULQAOiaMWrjSqTKzUx3n6?=
 =?us-ascii?Q?UYqby6ZTGfNVJqHIoK5SlvaB29aZ3t7iXMSikHj46iK7deEmmKmTfp5KknGt?=
 =?us-ascii?Q?KA3uQbqd3NIxPCjABRZgRtdc8mUEOSgd+CQpFQkzhrl7A1MIxkyGGwaRevPd?=
 =?us-ascii?Q?ffAeHGSLZrLqd9PqLNIf+Ect+QsX6+2XrzN9t91BGPA/Pv4lnofGD29nT08O?=
 =?us-ascii?Q?tAjk5V/clX5s1J6E4SFaCJS/qF4kOeKIZMI8vj6b?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9c65b95-b575-41b9-f9ab-08db04d2fe41
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2023 04:07:25.8124
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vXwx3E9SaIC5py+8k056xFp89GgZko0nlFwSX2NAl7WbVTNc5T4XjkJDtFPHZROOE3ldnenrtZEAR9s7v57o3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7000
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Thursday, February 2, 2023 11:47 AM
> > >  	ret =3D vfio_device_open(device, device->group->iommufd,
> > >  			       device->group->kvm);
> >
> > We're using device->group->kvm outside of kvm_ref_lock here, it should
> > be using device->kvm.
>=20
> Existing code set device->kvm in the vfio_device_first_open() which is
> called by vfio_device_open(). After above change, seems not necessary
> to pass kvm pointer into the call chain. Isn't it?
>=20

Looks so.
