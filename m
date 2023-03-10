Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67E216B38B9
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 09:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjCJIcP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 03:32:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbjCJIcI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 03:32:08 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF990E8CFB;
        Fri, 10 Mar 2023 00:32:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678437122; x=1709973122;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LM1drhabj4MkaPoMcL158NXTNB4RdBJXD51qOiJYsdY=;
  b=ZkDqe2aL+0qy9NiPkzeMaL92sCzY37j1ShUmC6oZZAWUHCuRIieOjszR
   naIq7QWEQNBen5WISFHedX7sdmgIhhy7youuI6eDZkoi52QOlqlOnQ6YM
   7qso256ZorzBOlm3TwdvJM01Nc5ZgVsxr+oU9awOzo81AZZi5sisxReF3
   Zwli6+Y+EtEHU1WtVl8N5aJWr26XVjom10jIp2+KPQZFPH5S9rHRz3nMM
   OmJcjn1691rceYVdddt7jfby8/cAYaqwDm8uOA0aGsCfaqLPz3gNYY7L3
   ro9+JZC7LQ6MziV5nLsnAUNfOCy/WvopNk74WHbLJUcFF4Qfp294iUgKn
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="316332292"
X-IronPort-AV: E=Sophos;i="5.98,249,1673942400"; 
   d="scan'208";a="316332292"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 00:32:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="1007041083"
X-IronPort-AV: E=Sophos;i="5.98,249,1673942400"; 
   d="scan'208";a="1007041083"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga005.fm.intel.com with ESMTP; 10 Mar 2023 00:32:01 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 10 Mar 2023 00:32:00 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 10 Mar 2023 00:32:00 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 10 Mar 2023 00:32:00 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 10 Mar 2023 00:32:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jxe5nzrgdloHPTPCX0OmyUgbavs9AZZc29mlIsuXIaLuSJkdI6YbP4TTXY0Wjyup3Xdt9t0cY9al3F6aMrbM4sLYV+R3tKXsDcyVPWCUFDLZgjLr+3+Ioc/YUdCYU21ZuNNJV/kGj/DcQ3GpIRjPou8ODOG32lYfWkM2NL074FZTbc4iC/MFy4fJKZoRCY4W5pWWzD+mCZpZayZf9DQBbsiqyQOIwGgLPF17LgpihLSM794ED/HgEohMJXwEu/PnwNP8MagQq4brf6nldl17NUokdi0Q2F+Sj1dY587MPVQ0vJejcVrE/WuLT6o/YpelAVCj5sPgIXt0vi0BcxFdEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LM1drhabj4MkaPoMcL158NXTNB4RdBJXD51qOiJYsdY=;
 b=RbuBxz3/eQbvsI5HJtieT+HZWhbpHezDUatho65EqwW8ZKjF2/+B7/aCZx/ONo8ztrIwSOvxnLl4dBKeckn6IaPkLnLxQ6u8La0ve09z0qP1kT26VU1P5RiSZvui4MD9W3IM1lFI8S+pa9fqwKuS52ZlEHZjGeo41IevLa59fh/fvh0UHDCtegQaZ+h4gvA1slfdW1sVnWmtbsj23UgB9rd7uwNj7ozoLofxueR3jljQVJEqUwtPPJFmKCrygPq5ikL+CnsO4/gkX9UTa1zdDYjCogEPNR6q3Dv04SWPxFbZAbiIVR6AJ9TCkoCktS6OmKSzwtbjsM6bZTTQz/ouBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB6448.namprd11.prod.outlook.com (2603:10b6:8:c3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Fri, 10 Mar
 2023 08:31:59 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6178.020; Fri, 10 Mar 2023
 08:31:59 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v6 17/24] vfio-iommufd: Make vfio_iommufd_bind()
 selectively return devid
Thread-Topic: [PATCH v6 17/24] vfio-iommufd: Make vfio_iommufd_bind()
 selectively return devid
Thread-Index: AQHZUcIKuk6IYHvSzE+nbHNPyFcQhK7zsbyg
Date:   Fri, 10 Mar 2023 08:31:59 +0000
Message-ID: <BN9PR11MB5276A4EAE39A587765150ED98CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
 <20230308132903.465159-18-yi.l.liu@intel.com>
In-Reply-To: <20230308132903.465159-18-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB6448:EE_
x-ms-office365-filtering-correlation-id: ad0df086-3cb3-4cb5-b5c6-08db2141ea4f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ma7mAQweYNfAtNmzfV8PiFg0CmyLXbDpVuq8RovzubSKjQkWiUDlsrFDxmkogjMdANp9Iti+KyzBwZiTCllitUxVDl92/UjLJ37m3VTi+9q8LMtrDOXwwO6VPQp7StD91zdWMQu4dnG9EB9UwsROwpLGWJQNi5RwbRbptwjMnYRhz7dq6BQag1VgInRfDEzn9kAkguk4Hjka6a6U6mXHaLDC3Qw8e1sHo2cXdZwBisxsWqF/5A6+cWO2u5kRUNZ8dFDd1RGxn1lbiExGl810KWi+Aa+lfQUnq+svEL9enJadCtEJmzBnsUNHS0oI8RfbO/IoIkQC6+vGibUL4xTne97Umnornzz85mqhWt14yVNa7eU6Ua+0ao7Qa7ApohjA/q5ofB0itZSlT7ATYzWECAZyuvhf+wsG6O/kMD/vkLzUMNhssA84vQPbopsennwkjD5atHepts6tH9T4aWwcNQM81htb1u6UABN8qxMYj26M2Qs+iwtw/5TfVzKQknyxEqpzKw+I+6XfpDTHy2iPEfD96WyZGz66MSTkarx4HofgKVwLDikeZ6ZUml+AwRjvp++rAIw2JGweFGwjchasp4uNQNdt3Lg/X6V3URBmZ8YN8n8KsXGDSqEHb2bmZbTMheuwMcMsXooBGcWK4O3wCy9P0JbzwYPtIohooNYSHEE6PLi0QiBH594SErBqxt+Vi18Rvr5bvzsQi6Gt2Rhs7w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(136003)(346002)(376002)(396003)(451199018)(82960400001)(66476007)(86362001)(122000001)(38100700002)(33656002)(7416002)(38070700005)(66446008)(66556008)(41300700001)(5660300002)(55016003)(71200400001)(4744005)(8676002)(66946007)(76116006)(64756008)(8936002)(4326008)(52536014)(7696005)(186003)(9686003)(26005)(6506007)(478600001)(54906003)(316002)(110136005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PXMipR58/e0ck/pJ/lsqaixge84tAN15yPFaSZUWE+r8T+RErTSGIsIeDZCQ?=
 =?us-ascii?Q?AvD6pFIhFPPzM9g57hfn5Fp0IKzsjqFoXMQptujCHIvV2GddpVOKjB6Rv/wW?=
 =?us-ascii?Q?Z1Lpm6TkqDtxEUk6SZ7O02fRuXWuLQb+ElFkX++omglEjdbHibcGCBde18a5?=
 =?us-ascii?Q?eDhN+w6y7DMyqk+9TA7X0N2cnTCJYPxdfU3oRWXOaVc95Dnl/XvDZWujKFwy?=
 =?us-ascii?Q?qn/dgAQ5LIsHbeAE6YdYK8mFhi9lPzVDvyl8lKfOcKswx+1saEDaWYS+AoXa?=
 =?us-ascii?Q?yvOw8rznUNT46sWRjzoHCGpf6vk8g0LBBBcbWli+yQv1eN3oWPSVuFpk6KdG?=
 =?us-ascii?Q?LJkyp+OuJSkM3VMTGFrz8IBA43KsH3Pxj2sLlAuK9AR4LDMi4sZxG27r4QxB?=
 =?us-ascii?Q?Fmig+XGmCA6Wuij5WXBs5PeFDdvU5Jw2N8MTXP8UpsQXdO1LkDsm7ImnDqsi?=
 =?us-ascii?Q?6Lp4YWheKintdK8LRBnn2IHbL+muMkAqQHTHI+aog5uArO49ulhYXQX6BmQX?=
 =?us-ascii?Q?cke0T3z89rvKmzQtKcnEXL2licE/h5oWEvbj/zocuOLzmbN2ZOuZcHKl54CI?=
 =?us-ascii?Q?EvrvOYsoPYkf+RG0hvIZ/42OMtVunJ8sOGoDBDfXD9ELUUnbyC3w3xAsXg1O?=
 =?us-ascii?Q?s8McRMozhdX2802hF373bJJQxrRDwnnujI0QRkzbrGOj5PgO4c2RahWc8T5o?=
 =?us-ascii?Q?2cHJOYzP+xc3QdiUJhBchpT5VsmaynjPPdP8LUsUtpPFAdNJ6CFse0nZp8fO?=
 =?us-ascii?Q?hLF3D+U6A840qY9ipAHeAntawoZTABwmwsXotmW0IUHT5UC9XgS0TG39cIEo?=
 =?us-ascii?Q?hgIoubqOziPwGwFpmFc4HyAz3R7M/H1+fQQShxVAHC5byXwQ9Ve970k3g7Az?=
 =?us-ascii?Q?BAJizSZvYsU/NBAJ0gSPdpLbFAvLDzAOapl7zNXQl/SpQ/DcCGgGtlourO51?=
 =?us-ascii?Q?UqCQ3zcSri3U12ND/vqt5fXvQ8J7o19YUbWAXaNLWf3F2NiyHKg1QHUjVnEf?=
 =?us-ascii?Q?R4qPdv5BBGOwuSiN8Rdd7Hgs1CFrdK7hTFa5/S3OyMc4l0u4Y/cv9hyZjf3h?=
 =?us-ascii?Q?Hl+AubDQoI5yQEjOT7iA6LDCeCO8GoyMlZXfawSXcSSLAvmpTmyMLXaK38dg?=
 =?us-ascii?Q?2nqnMEcFV+fmyAwSVhbI+I+AwyjIiOtrpG8UvsFzmLeIl57HfISgTX+nWI2a?=
 =?us-ascii?Q?D/ei68WvA/zMkz1WHGvWcYkSc8lYRaNqp0FGBbdoOMsCNLmq7jU8pWVTTer4?=
 =?us-ascii?Q?Y9e0vdZpL5Z8T5/3ENnaqvcy8ZAuWlFY5xz2qHrBtB1BF64b0rpCbZFIUNR4?=
 =?us-ascii?Q?BCjts8JUoCcIgTxwMn0AH/tlXYjWSTgDImZ4Yk/+p/FCdtvn48OXsJ4NsDup?=
 =?us-ascii?Q?qKfORPE3fep9tm4OmuFDpqOyJ0aHAMEiOh/UC6UduAgRwBd4r+F4zAYiuF3f?=
 =?us-ascii?Q?uy/bvhY1D7q8Vt/fO1RgCdigC0N+rV0Y4GrnM7PlHKf1LhIwE8o8BssyotzP?=
 =?us-ascii?Q?EeJTOUZfWoz/woVa34/r7SUfzpLXGeSwJg1CcoeVBCCrAUykO6DFBBOU5SvB?=
 =?us-ascii?Q?ljJeUeRBmzGULQy+bPLvbGMraBNwKM2F9H/tEOGm?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad0df086-3cb3-4cb5-b5c6-08db2141ea4f
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2023 08:31:59.0429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4X6oPkTMBEg2IZgMeBeNLfDpojKH7DfB4Fn21ZXaIU0N+MS6Cj5VxSHPtC/2LOpUbC8xM0u9MVAM2OOALK9xKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6448
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Wednesday, March 8, 2023 9:29 PM
>=20
> bind_iommufd() will generate an ID to represent this bond, it is needed
> by userspace for further usage. devid is stored in vfio_device_file to
> avoid passing devid pointer in multiple places.

after removing vfio_iommufd_bind() then the caller can directly get
the id when calling .bind_iommufd().
