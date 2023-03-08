Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBADA6AFFA3
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 08:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjCHH0k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 02:26:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjCHH0V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 02:26:21 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A27489547A;
        Tue,  7 Mar 2023 23:26:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678260379; x=1709796379;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4s0rQfXkO43AHW+wHoRqfqNxx3clVqxLoocDtQSozGo=;
  b=mL8M+2PWsmIhmK8P9WJCQXUWibQ+GHCYxsTExOfR+z8lbq5TpVvkMbEr
   fWpYGZVE3Av3GnAo9YWC/WO3mIB6rHLDy7F4+g17dMvICif+tRbluESE0
   Ebk0RlbtHaNOt2lK8x2XKA5WnqfANxOXHy6sK5+gereyQklNppYQWKYWO
   Dq6zc45k8bjWYZ/9qC/hULzX9ZhEj9lqTA6SHrt2XNk8+OPEzGKUx5ig8
   rJEj7onz+SOre25jjOd2rt2Cw9KLTAhFQEYVwTX7nGKvAx6Ccf5x0fvzI
   wDI1AmgTZtFcLlWk/lYN01BHdXoOCZxMOj7qs8GOaPeDNR2zDgFAb7Ov+
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="319914778"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="319914778"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 23:26:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="745810378"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="745810378"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 07 Mar 2023 23:26:18 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 7 Mar 2023 23:26:18 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 7 Mar 2023 23:26:17 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 7 Mar 2023 23:26:17 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 7 Mar 2023 23:26:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UjtkvlItu2YGoKzCdLLZ5q7bnesOFO9uJS0aMb0mYqwl2QUL7P8KsGhI9MwSnbi0ECVy/EcVBXwXpscSmuFvn0S8EJYysxNp4WjPMlEG2atw8Ni+5d1SUvIGQy9aV2KlpHdY8Y+wkHekvtwP0Ne92As0L799nfka5vTKugQ8LNXe7H5wq7rkYnMmTPk6qBEp2MGdPRrWa7/AE60FlC7DsnXvcsmMoVBHAZJUYA8qcrONobLTffTSQ4tshArkKfPI7lEi+KnORbQjq5YH4GTRXJxdveZUpHtyjAScSu+5rJhrPcBpvGfUiNSBnLTUU1AToPWGXWjvDBw9dw696/6HLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PKmPqaUIkQ/61EQ6A7Ag925VXcKXVKlQye04NplYgts=;
 b=KKXJQvBKjKmfSaN+R5D/kTC/GPOvwKlBrfVGjot3SYMv0xh9CBglFQE59zt3WOHMlYHfJa132imaOsVEQ309Kr1E5VYWc4zU9Y0lzLMm4UGvcDCG0Jdq2o7xii11YOBYpGGhkyH26y+Cb1jii9CoyJ1WVgrHoeO2n2wao70QhBZobkhAPRHpBqmIwT31ANEzqCHx8CSTe2QS5vRWUj1+NA86IwDfjVRHOA3LLqQ2XMpPQiBTYheaztw+kXyaLk6Xcjys7rrh/BIFFjKb0ffD/Of60LEQjwQTWc9yoMojqxEM9P+JGjofxtDw5KsYVFhc7KEDHbBayIgXEAZggJfJMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB6720.namprd11.prod.outlook.com (2603:10b6:a03:479::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Wed, 8 Mar
 2023 07:26:08 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6156.029; Wed, 8 Mar 2023
 07:26:08 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v5 09/19] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v5 09/19] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZSpxNc+z5kvMhjUKJQeU3VasOx67nBTMAgAA+rbCAAC27AIAAHWOAgAECO4CAALuIAIAEeeOAgADblcCAAKtwAIAADpYAgAEqwZA=
Date:   Wed, 8 Mar 2023 07:26:08 +0000
Message-ID: <BN9PR11MB527616204417D92A1BEB5FDA8CB49@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-10-yi.l.liu@intel.com>
 <DS0PR11MB75295B4B2578765C8B08AC7EC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB527688810514A262471E4BB78CB29@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZACX+Np/IY7ygqL5@nvidia.com>
 <DS0PR11MB7529531834C0A9F1D294A5CCC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276B825071A4819479079A68CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230303095542.2bfce5c2.alex.williamson@redhat.com>
 <ZAXny4NDDq42NUxE@nvidia.com>
 <BN9PR11MB52760ABC93BCE7FB53A131038CB79@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZAcvzvhkt9QhCmdi@nvidia.com>
 <DS0PR11MB7529A864CB1C149CF8B19E78C3B79@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB7529A864CB1C149CF8B19E78C3B79@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB6720:EE_
x-ms-office365-filtering-correlation-id: ffc5c37d-10d2-495f-3c6d-08db1fa662b3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +77A2ZGzepDfiJ5LHJL2vNiM+0aZiRJnZ+Pz2WABGAFKqxZUiuqhF1CdKaa4QEjYGF7veEjkbLGJMv+b5xtFXKmvcyMM5i4Jqafq/4nceUfDHlmdcd7VRqy4Z3KWumJTp0qPV5NhXYT9AT6N5DYantmvT3/Aj3uEACB/Q+YtDGbhMtejpKr1uBTdny9YGEvveTDBISMSFwIclsowDh/VjN2Mi3zMKbHfJhB84f4jSU+0q4pfGcmLoXqa08gNsh6c6avAVOTUi0S7q+oXf87okX3uppw9QBK0DTrcokUC1/QTJYiTJY3DInhapUVNDsSMqDTzkuJNn6rOQYRLz4ZimyaW+vC4D3Q5/9XpiZkSoTq7kGr2vPM1OTTudFpOTtfA5VO8+NECgEjKs48/qJ3WIjvBei20UrN5scnlR/9dbeRWO9BD8dhOUGFzaCtkyJiT2XB2coLGfYXaiOoJipoXLtX1dcaBNKURxKlV+3H6bSuzLQFUY0seGmdkX2iVde6zfyKTWSD7ZlDLYJEsmH0+27PbTkHFuxlhvSy4tR0qoBPCojg6GtmA+ja7P4zVmpksxfB0C2PN1k11qlgJ5o3jaJerCM/hmDybvFTVTfnRrJahipuWlNTID2U21cuuC7VZinXQMEIUhzxJf1Hv5rtuk5QNKJ3bLPGFbWASsFAoJUWkwFA6IQve2dKcrnKLDknYLp169EY/1pV5dedfGLSJNA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(376002)(136003)(346002)(396003)(451199018)(76116006)(86362001)(38070700005)(122000001)(82960400001)(38100700002)(33656002)(66446008)(4326008)(64756008)(7696005)(5660300002)(66556008)(7416002)(6506007)(66946007)(8936002)(41300700001)(2906002)(8676002)(66476007)(52536014)(9686003)(186003)(26005)(83380400001)(316002)(478600001)(54906003)(55016003)(71200400001)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uDOfaU4XpAh1Rl+OgQS+3bAQ1/PLwsB7GmIP0mb9gIWD2ribNjqW7xtjNt3D?=
 =?us-ascii?Q?SyYV2NCQgimAtFsHmLEWI0gAGjrFtomC1uI0d0cA6nb2U9u0u7ZLUPXAokq7?=
 =?us-ascii?Q?LquEA6iSFWAoMX46R6VGqi9+q+caFkxDSY9sUi0MNRc294xSwI8ebl120S6x?=
 =?us-ascii?Q?oWaMuTzxs+ftGJA7LBUs++ITS9JkyuSi3RDUiWx5vhpPJRabBHIOTAUU3t/g?=
 =?us-ascii?Q?dwkJywztcXk+FnhQNdHaC9iYNNGg1zmOQYBv6xmMetyjNtfT4iWBwl0bGNO+?=
 =?us-ascii?Q?eriuUKtgB7SELlOzaGi7IR+unvRYl2sO2BEIzB8yc8qeUuuKJ+Qc46R55DlC?=
 =?us-ascii?Q?IKEfPZGSEe7qq42zHEzcBgRWQ592HlSmq+dqF76UI8H3suUZRXZKAo+fj+jF?=
 =?us-ascii?Q?4chy92sGjjA13rfzJuX7Os24YnYU5GKYW6MAbfKuOhEaeFbIy59DKY+33+ZM?=
 =?us-ascii?Q?5jCCFnyFWvhc96xbaqgUIGShrnvm8TfmMmaxWHzKYuLexMivWw0Qn0LlYgs+?=
 =?us-ascii?Q?9oDUhCC47JV94mVPNjwn1LNI+91srk3Iwlf3tHyuJWI6Fogt/DS1jyslFb7m?=
 =?us-ascii?Q?Df8zDsSVYeGWPIwEI4Jpk1uA58QBTiumYeuiYsO8W9ICFPJl9MtmPN3kpOii?=
 =?us-ascii?Q?AXLb6b18W9dromQZSZTvNpYBQ0oIeE787TwtiThPSJANGx3/gIsu8qddw33q?=
 =?us-ascii?Q?eqS44jd/sW8IpEbH2y+rfg73nQPP0UPEO5T/mIBOy1os9W29wrCAf4SiMMzQ?=
 =?us-ascii?Q?7WyZvgv53XHMLiqycSXtGE+B80Z6SeE3PiHNkjsUkR0sZzKeplHVxXDeVN/T?=
 =?us-ascii?Q?5wlf2njl+dc5BkdvyeIztIJezt2QntqjEqpN7wnxEVgonUl8UMLyuVRJoAer?=
 =?us-ascii?Q?sdSYHCnaYmaSTnqNMPgvO+x1Hld9312Il3Evtzu1zAbsLafmI1UTBq9xJZBZ?=
 =?us-ascii?Q?uf+R4tNuuJk7vpTewEc6BrLxegqVBDyUtHSEr5k5p82GmWvo1KVwSYezwn/o?=
 =?us-ascii?Q?EKAPy7gVgN8Nzy/5oRyRL5a2JoCKUyGjxLx/FH3kOYaXgPwfG3QYb7gZyCRE?=
 =?us-ascii?Q?kKPRj+L7a2Sj56QEl2N5pVvzyNM1iKpJHTV4OjmCrI6y8XJr0ZeTZxIN1/It?=
 =?us-ascii?Q?MjCWOa9C+/vrXNRP/kcMIktHbu6UoT8KfUNVIjYZ24Wwa/eGQ1ZlYABe3YcE?=
 =?us-ascii?Q?OlNTpS5JzDPUmNWlVrnMEF4tzVCIV7YKjh583qVqbZWOCDMDe7Zi5cGiKgNy?=
 =?us-ascii?Q?oYB82eCHOWaHvnugvIOqMmSeQzgyrw6LZnBY2KxAwGmhI775JtlLNsi4JxMB?=
 =?us-ascii?Q?td/qBQu+sUf68a9ipaJCkWjOyNhKzHcCQOgA+BWTYRHNEKA10wyU7CnrQOVN?=
 =?us-ascii?Q?teDafDhybQp5vwdmB8Q0KeNJh3YF0Q4jzkebT0t7ns5bOm6fxhFvmxlLyHpA?=
 =?us-ascii?Q?6Ld0sK4qC1l6w9QN/du92gApHO4l24D7LlNX1PDRwhXfivXjvMdoUEa/5BQU?=
 =?us-ascii?Q?6sHQuViAGwFXliEAH/Y8axoZhm6nukoNF9/sxPGyRzooRMQ5/t6jQ5Qmk0q1?=
 =?us-ascii?Q?v5i6hd8cf4Y4MsKqaZFnoWr6Clt5tIH1pk7MS7XF?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffc5c37d-10d2-495f-3c6d-08db1fa662b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2023 07:26:08.3377
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jf8wEadeLr7PaMR0wQgHBmcoxN5avdr9I+B0S8OWEPY+DzV3s3TrUaJYjcGJsjBFRTFV6lQ701nlctr/6TcNgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6720
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Tuesday, March 7, 2023 9:29 PM
>=20
> >
> > I really prefer the 'use the iommufd option' still exist, it is so
> > much cleaner and easier for the actual users of this API. We've lost
> > the point by worrying about no iommu.
>=20
> Hmmm, so you are suggesting to have both the device fd approach
> and the zero-length array approach, let user to select the best way
> based on their wisdom. Is it? how about something like below in the
> uapi header.
>=20
> /**
>  * VFIO_DEVICE_PCI_HOT_RESET - _IOW(VFIO_TYPE, VFIO_BASE + 13,
>  *                                  struct vfio_pci_hot_reset)
>  *
>  * Userspace requests hot reset for the devices it uses.  Due to the
>  * underlying topology, multiple devices may be affected in the reset.
>  * The affected devices may have been opened by the user or by other
>  * users or not opened yet.  Only when all the affected devices are
>  * either opened by the current user or not opened by any user, should
>  * the reset request be allowed.  Otherwise, this request is expected
>  * to return error. group_fds array can accept either group fds or
>  * device fds.  Users using iommufd (valid fd), could also passing a
>  * zero-length group_fds array to indicate using the bound iommufd_ctx
>  * for ownership check to the affected devices that are opened.
>  *
>  * Return: 0 on success, -errno on failure.
>  */
> struct vfio_pci_hot_reset {
>         __u32   argsz;
>         __u32   flags;
>         __u32   count;
>         __s32   group_fds[];
> };
>=20

 * Userspace requests hot reset for the devices it uses.  Due to the
 * underlying topology, multiple devices can be affected in the reset
 * while some might be opened by another user. To avoid interference
 * the calling user must ensure all affected devices, if opened, are
 * owned by itself.
 *
 * The ownership can be proved in three ways:
 *   - An array of group fds
 *   - An array of device fds
 *   - A zero-length array
 *
 * In the last case all affected devices which are opened by this user must
 * have been bound to a same iommufd_ctx.

and with this change let's rename 'group_fds'  to 'fds'
