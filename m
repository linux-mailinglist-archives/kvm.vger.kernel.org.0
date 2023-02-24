Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 046E96A1510
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 03:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjBXCsa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 21:48:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjBXCs0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 21:48:26 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE814199E3;
        Thu, 23 Feb 2023 18:48:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677206904; x=1708742904;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NaFrVg8Io4W2jSqY3VVk+RNotrRhLt0/x8k5hBFVz6Y=;
  b=fJbFYQG5tj9x6WYAFCxGYBcV5Z/K6B6ilQ2JT4+nfitdxueDm8CSEEzM
   3NxAVSIqHzXocbwNgk1oTPq03TAGyZ+yIwwbTvaEqGopMfXtcLrXSmDDg
   oJFtfwqBhVIsJ//op3WUnJzczL9SVmiTUAAd44RdMW9XPH+wY0ReiX/f6
   V8pckLaVtC3B9J00JA7s9cBek3zvJVr/ITz+LBlHyDoXth4GxzmD/vNxy
   iP8dUshvl/eNVYiGwfUDgCK/RtYMydgKVb8HZYRl4O7tuo5Rm036XSfDc
   YbzwoDaq9ScpWpn2UpBRjUp5VGKYW6tCtvoXtJumADvVFhnzA1d2C7jmt
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="334801832"
X-IronPort-AV: E=Sophos;i="5.97,322,1669104000"; 
   d="scan'208";a="334801832"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 18:48:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="741513749"
X-IronPort-AV: E=Sophos;i="5.97,322,1669104000"; 
   d="scan'208";a="741513749"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 23 Feb 2023 18:48:21 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 23 Feb 2023 18:48:20 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 23 Feb 2023 18:48:19 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 23 Feb 2023 18:48:19 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 23 Feb 2023 18:48:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bh9fDiMmzkQM4Syxt5O8sH1Yhdm9ONzkiJkkSvZE9HhCdz5fg6p9YCCZqpXn4Z9sttR/mpimv/tYcaqDcBuiFBmc9pwPlv6e/xK27ZI3DuxA6AKse4mfLvO4959klqk23JTjeypD0cDCB3mAEmLs1AqwgA5ZiAl4QeGevQNbbFJfS4lEObbRV9JzdJozGrnOk8uC9YB7KOgtLcl6xuUj7ei1U3rJ6flhfQ6kDn0Dhict6qhjq7CMLkoibB0xoy8JyV5hDMDOQtD/Bv27mHOcHH+X6wRgOu36alI3pRWykR4kwFuUKUAPQvGoSMXyECnWrEenY8EDBmT1q1m1tRXr9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NaFrVg8Io4W2jSqY3VVk+RNotrRhLt0/x8k5hBFVz6Y=;
 b=i/sMyAFsfuhDNu6pWj1+bB5FZyt4KiLKSWPy39eEIqIyu1qRQ5e0cVgEuRe5YdwH5Pdg6qyfC6BHSXf3AGKFpnsjAPTeHq6ETO4CbSQrTwKdjD89N4Ef+xV8LaatjrmfbVnftnZwuKiYl0+zvmv/uaR8I0Tso+VEUGVBsey3foei6Q3X1fWNwXk+e3AFYO3iopEBhxGMW7jnqr8TbDzu3/7WRKz7hcrifKyBxTzPkM0RCDP/2C8UxGOeA5goqabYzs7W79dPwaSIAlmgTcu7dY1A1KjO9lFqaAoHGRssbxFvITdZCOk0twyEJKMwjMzip7jf3OUAKRvw4LrJhIN6uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW4PR11MB6618.namprd11.prod.outlook.com (2603:10b6:303:1ec::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.24; Fri, 24 Feb
 2023 02:48:17 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6134.024; Fri, 24 Feb 2023
 02:48:17 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
Subject: RE: [PATCH v4 09/19] vfio/pci: Accept device fd for hot reset
Thread-Topic: [PATCH v4 09/19] vfio/pci: Accept device fd for hot reset
Thread-Index: AQHZRade4YzkLtsVl0WRYDgmHuz0/q7akQpAgABomgCAAD40AIAA70ywgABhHoCAANlkIIAABIeAgAACvVA=
Date:   Fri, 24 Feb 2023 02:48:17 +0000
Message-ID: <BN9PR11MB52767479FDC6F1CE16275B8D8CA89@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230221034812.138051-1-yi.l.liu@intel.com>
 <20230221034812.138051-10-yi.l.liu@intel.com>
 <BL1PR11MB5271D122329B6908BDE1F8328CAA9@BL1PR11MB5271.namprd11.prod.outlook.com>
 <DS0PR11MB7529B33D098225CFAAA7D63FC3AA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/ZOOClu8nXy2toX@nvidia.com>
 <BN9PR11MB52767915B9A5E509BC90E0888CAB9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y/dobS6gdSkxnPH7@nvidia.com>
 <BN9PR11MB5276C959AA31F8515002B6B48CA89@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y/gilafqe4Xm45jY@nvidia.com>
In-Reply-To: <Y/gilafqe4Xm45jY@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW4PR11MB6618:EE_
x-ms-office365-filtering-correlation-id: 9a50e87a-4e61-4242-8493-08db161194f7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S6KsbYnVGSwe7lmy2SenKEYpW3aOJem6COL9d1LRjyugHlJ2c/zNKAiZef6f80ZPVi0ffOmifw7QpVJtwCS9nlX8bukN48tfRJQBbneNE1TnS8GON3AQQAmR0x5/iZr+pRiR8Oi4ELLdkAeSSi2GG2jlsdaaioHtMmnx+Xno2TaIt5gGHijyDpXS0DYcnUDR94ejqG/NKqcrdvF/HINs4rISHENfb6XSZmMjabZuKetjd0SM+wzqtBw5Z6jYoZH5MDswkwM7u9qW+FW9HvwN+jfCCGB07IMQM6js4ThGYZQb27KeN9ABS0o5ZBvlSSzZGgP/7Wmunk0SZrfFUSy6h18/+Lcsyxy1hmtwAW7QFhJWSElHSHFT4kW1T2ZQgZ8uaQe1UF5KfnpbN9j7f7mqralLA7G/z4NAu74qqPeVZs+kJirWvihBWcxe/niS/vWofmxwiUoK2wHzZCZS1QYJJH57/VikhDxxq+fQ7l6jh99+JrTKghpcclTNn/pJHzqY8QZKBIc57hGoOwAjmKvgY3EKYTKtVPLSkcE8+TkSOvm9QVYsyykue/WYe8D5AdCAYGdUHdtAK/u1QcqilWts7doLSHAaAjAugTX2zfWwA+aE09nOcHunfMn1vJnMvSoiDI/0iq1/LMtD3RyCWB8GDOCnU8p3HqRRFaZtSxKzAAd3yE427pToei8fjl+GOkhoL9y4I9bZn5T53nbkYCbUlA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(346002)(376002)(136003)(39860400002)(451199018)(7696005)(55016003)(83380400001)(38070700005)(86362001)(38100700002)(82960400001)(33656002)(122000001)(6506007)(26005)(9686003)(186003)(316002)(52536014)(66946007)(76116006)(7416002)(8936002)(478600001)(4744005)(66446008)(64756008)(54906003)(66556008)(66476007)(5660300002)(8676002)(41300700001)(4326008)(6916009)(71200400001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OQbwhCx50shGzBrW6trQ1kZ+d+Y0GQ3GTDOy80GlyZx0LD6xoH0DIiqJZEsK?=
 =?us-ascii?Q?JzciNVc2Mahb3IzmBtv0nd3C7JjC5plmdSqMK0RXTJLuMWnIMMurTI4it9g9?=
 =?us-ascii?Q?ttNqdng7b9FnRlBuk8IMr+iEqtnbZyGX3mPd0uvtZAtkOMuJuGOb3TVKYJUF?=
 =?us-ascii?Q?K+oxQ0t3xzGJ4vXqbRgW+bHnmv4NFwGvj75F1HbD5w2v+ok1SI2Rn8B2gYsQ?=
 =?us-ascii?Q?6MubzKOxqTVhGp5P1G9d3ZFiJmJoCP7H85bCShQqyZ/UsjehwdIA8g5WWwmc?=
 =?us-ascii?Q?NuulZCJoOZrSv6aupKY6HMV+3meY/LnUjetI6tGy9F7klePMojn2wrGd/rP/?=
 =?us-ascii?Q?ORtis7I/sFVBb4vTTa8rBhN0sBve71K9gQQs8IIF+x70VUpKdhRRqYBPC1hZ?=
 =?us-ascii?Q?eLQJyon65R2UKa2/75klJUWzLjk+iKsI2Wje9JJEB1MBSoEpuSbA43R0YL3J?=
 =?us-ascii?Q?9uCGmUcMYVlgEzTX8HZUqAFmJDZUphqJDsHE6WlGwao3xmv9FCwx8tZ5c7SB?=
 =?us-ascii?Q?2KJz/tAiKqu5W25gqBQ5QoHQF9RIVqfT1o07gOgNKp8Cj99Lm5e8QTbfqsCc?=
 =?us-ascii?Q?Q9nfsCPsxIsKGoq1LLLc/rT3QkeYprC/i7Aow05pSAP5fFLrfr9I2VzDoA2W?=
 =?us-ascii?Q?AuRaSTZG+IQpjCq5G9R0rrLFTwuZ+ErxMC0LqK9AaSuUdDQJ6Xg7sj65rc6B?=
 =?us-ascii?Q?gv2AvRLfcL7mHTV9ou2nVyofK2d0vOtt1TwvTlFvs9tegoBhTKs2uSIp6gQ1?=
 =?us-ascii?Q?SgWKvH4+eeGGdT2NGlJyk2BdlremyGGTves6VusuxVB7Dysz+3ywvNiiCMzU?=
 =?us-ascii?Q?u9FGdgQA/8wGav46IjgXVXqnQsf3cyH/dgyJd4LvYgCAzFwH2ZBnxLzkiMqW?=
 =?us-ascii?Q?RLPKeY5aggpb98Om2jPqSXMGxLn0StLEqdUeiyjmzh4kQ0d+k+r0ZrFmSLFe?=
 =?us-ascii?Q?MU5wRCRH1jefsgfIa5TzGXqvkXdesGNR5ifCKUeq9UsAWILKJcGhuW6T0pg7?=
 =?us-ascii?Q?lOgfezdu8AVsCiphdTjnjcgk3lm/4+o+FmgPuE2h6nUA+jKZAkZoQ1/amWc1?=
 =?us-ascii?Q?6FgrWeAXg41F+m3lIYju4Zetim6h4ev61QkOIivrhiNI/85jeG2nCeLmwE9r?=
 =?us-ascii?Q?Dk13YJ3n14DvbCGUt+Cf4je2gMvwAlv9x5ZjZa0OoC51Zu8vXatwqRkxLMft?=
 =?us-ascii?Q?9LTkT/aKfVai9Cui/E4FYkna45bSOEaXvAFSPNeLOEHczhnXoLcZnsIbWtMk?=
 =?us-ascii?Q?HlYCcq84dBek+6uUHMcWMsffjFYOZxyLwMGSYVoTvtvihcFt+hSzS8v7d+g1?=
 =?us-ascii?Q?uGzRNhJGWdKB9vX55JFb3hQgFGifOxwGq7lffa9z2YuEiuLD6lRfgpbhHH+V?=
 =?us-ascii?Q?N/RPLpUobedo1dJvLgYtPg1d4NZd7Gj107C5GSwL9+yZ3BlVRJYCPU2BjZkI?=
 =?us-ascii?Q?vpFn2hCq1ZDHFdRC9fH4Ax7jwEX4Qm4jrRfkDKQRtNW2g3bkamJ8siY13gb2?=
 =?us-ascii?Q?/PaDT7ak3JXUduDDBfsZMuILMEvCvt2G7U45nyBQ+bj2FjLp60y+HOt6vwgo?=
 =?us-ascii?Q?FZ3JVysJ3QHDGNz8VeDsP5EJ2PklL6a/5hMIeEyO?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a50e87a-4e61-4242-8493-08db161194f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2023 02:48:17.2249
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ioN7DoCS95AOi5HySiyfqmt73FRSnrpT1Ig9UQjssZZok9OSYmYnhi/xhF/JzYltB9Ka02VZy4oiWb8S9dd/TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6618
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

> From: Jason Gunthorpe
> Sent: Friday, February 24, 2023 10:36 AM
>=20
> On Fri, Feb 24, 2023 at 02:21:33AM +0000, Tian, Kevin wrote:
>=20
> > Yi, while you are incorporating this change please also update the
> > uapi header. Rename 'group_fds[]' to 'fds[]' and add comment to
> > explain that it could be an array of group fds or a single iommufd.
>=20
> Upon reflection we can probably make it even simpler and just have a 0
> length fd array mean to use the iommufd the vfio_device is already
> associated with
>=20
> And the check for correctness can be simplified to simply see if each
> vfio_device in the dev_set is attached to the same iommufd ctx
> pointer instead of searching the xarray.

yes, this is simpler

>=20
> Would need to double check that the locking is OK but seems doable
>=20

Locking is fine since dev_set->lock is already held in the reset path.


