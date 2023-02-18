Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04BBA69B7D1
	for <lists+kvm@lfdr.de>; Sat, 18 Feb 2023 03:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjBRCz2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 21:55:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjBRCz0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 21:55:26 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30ABC6ABC6;
        Fri, 17 Feb 2023 18:55:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676688925; x=1708224925;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KJFii5RIdiXuklZPei54cB/wcgtGBgIelPLVoC2CnwQ=;
  b=aYd//tbw6wjZWsZ3u2WJqGGmSzvykqtGTxLj5Nc+SYXEwciYeK2O1mJt
   Ws7RIWey2zD/awyt2JlvuMfueO56vs3RRPPvlpufZSoK10/2Gt0d9wHTa
   Z+XuomlNRUmpnSGV9CpWf6P/ldIgm6JS82y/MOpjM/lKIPyU753Grmq5I
   PQsUn7UBfB3r/T7pB9J70bB5GToir6Xzw3DJDil06Iyni47TOzBZr9XjR
   GzeKbG1uW1Q5v7zEPnp3sJDG7iFqeIczNJp2YNdJSTKR4FjGjF1EI74NL
   SMNc58ngFy1iRBQ12D3JObIAffe2KSoUu6jNv0oDZeRZ6nXw2iueb0rTf
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="333496006"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="333496006"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2023 18:55:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="672795322"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="672795322"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 17 Feb 2023 18:54:31 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 17 Feb 2023 18:54:31 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 17 Feb 2023 18:54:30 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 17 Feb 2023 18:54:30 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 17 Feb 2023 18:54:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O+kxr2RGjk3fKVu9E/ChNCBNo31a4ix2gIE0IpWbnmQuTGXSd4gjnZRBGNdWVjQAXhtIgAFuZpfa53XhCa/texiyEKmXDVTdaskYtZshV+UwxS4wjFLD0+I5DVpnlBa0t8fGt4fYfCzIckIZ2hqZjAJbt6uZBqmhrLa0RT58Z41cxiDLqdz+eXVvkN3UNM2XWUmBz8uS6iEtKmWsrQRvE8knfL+ls/3/JGg4EZJgW7vUvO/M0LC4WSMjs9WJFk5XI+WHfUjtMolyVz4A7GCa0Gz+04EDG1IHu1+IrznebYFsdjb8MkGtoJL+SXb8KFzpAyW1IsxqXaCmIBLUUvlnIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KJFii5RIdiXuklZPei54cB/wcgtGBgIelPLVoC2CnwQ=;
 b=OUgqwm60DKHe0EkCidP9nwP5jVdmk7cVLkRzLQW4DBYhDNcC3Nu8Chmdq/6OvT2EGc7G62i3/TGqTW1AnY7sJgfiIcFR1yy4ZvpdliUXI3ox23SL1+hyLc1RC+hXSaaYDj8sT6b6kklCCZrtKjGSqiaQvusIekhrhyCfIcBvkW637RNz+W+BEDRtLizMGBgTuGQZozjXSGt6WNqlTTIiM9owVQ22IRK8ZTgxGmBg4KLczdzCoS8dRrt5BZ55C8+9kHzPXlEG1lZY6OKpjN4LR+g39FWrufCWpHnSbKT8HVSOivyQnGoD77a7VlEEhO+6BUDawZoeFggFIkKF7p7QPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH0PR11MB4840.namprd11.prod.outlook.com (2603:10b6:510:43::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.17; Sat, 18 Feb
 2023 02:54:29 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%4]) with mapi id 15.20.6111.013; Sat, 18 Feb 2023
 02:54:28 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: RE: [PATCH v3 03/15] vfio: Accept vfio device file in the driver
 facing kAPI
Thread-Topic: [PATCH v3 03/15] vfio: Accept vfio device file in the driver
 facing kAPI
Thread-Index: AQHZP73OQ1XOEaarRU+iobEkUB6WaK7NioEAgAAlR2CAAFaKgIAE9K9QgABXFQCAALaFcA==
Date:   Sat, 18 Feb 2023 02:54:28 +0000
Message-ID: <DS0PR11MB75299F7B2D34AD8A0633B54DC3A69@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
 <20230213151348.56451-4-yi.l.liu@intel.com> <Y+rLKvCMivND0izd@nvidia.com>
 <DS0PR11MB7529B43C7D357D8A0C2438C7C3A29@DS0PR11MB7529.namprd11.prod.outlook.com>
 <DS0PR11MB7529028251B2DFF28A3CCD00C3A29@DS0PR11MB7529.namprd11.prod.outlook.com>
 <DS0PR11MB75293D6F394CA6F255D05159C3A19@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y++kVGvMDfOrNf5b@nvidia.com>
In-Reply-To: <Y++kVGvMDfOrNf5b@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH0PR11MB4840:EE_
x-ms-office365-filtering-correlation-id: a124ecbe-14a2-4661-7978-08db115b73ec
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: whpoh+IktRSN+WJx8HZNAygtLoUdGrnh0hhBm+JVRecHq7hA4w5cS+I+brYhCOwMof7jPbPf+/1gTQs3axXiIQFI7Uu9rCGEulEb3o2SfwanWRDclpiAx580a3IBNOI3cz7ubJprujhfnXZ3DvplDejec4Rmrd9a3Hmdx1e8OupTYSrn6GI0A6nk+NDDhwcYTFSQ1//p72lCMD+RA0j88TOZNWkF6pDMsdqEQ1CTRZbJr2eidsmNLkRKSnpgcUgKEbkrdZQsMmUO1KozBY9nKhB5irmiR95IIZgvPp7MbX7uBLxAZC+25I3cuI1ArsRMdcHlaMHAFiih7xVm8zL/mkyqabwrKvwRcjCE9/9VDvNSD3pRWP33AiEUqR3KCM7K0yoPnGfTueObvoGQm1eLKGBsiYNbU7z8qsBvZEjTY8tgHcSiDt2VcOVeyLBGaSmC8pLGgrxQcBNI1hBO3Ker7B4dcs59n+r7MFSkIfYK+ZOUua2iUeHRsTwIUpPCBZoD6bClwATSCdWraUCuZcqEzadx74AFCB7JpJ0FqmZpFgjCYFjo00GG9BjiNOgZxvPV0jY5NasSlf8zW/2XKzSVt7oBmrUDe9vAzeV2iIMEInDBGELODmC5QGGF/ZG6mvehs2Rig5Vgg2nQt+zKW+a2qXSbMFA+iJi+2LnIjEyksDCpa6sOT1/6jLz4yE2GUzFlQMeP/xJryBCpRT/Yniz2jg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(376002)(396003)(39860400002)(346002)(451199018)(9686003)(41300700001)(66446008)(64756008)(66556008)(8676002)(76116006)(316002)(66946007)(66476007)(4326008)(8936002)(5660300002)(7416002)(6916009)(83380400001)(52536014)(26005)(54906003)(478600001)(186003)(71200400001)(7696005)(4744005)(6506007)(33656002)(55016003)(38070700005)(82960400001)(86362001)(2906002)(122000001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0BhPv+Kvme76aQ3kcw8+LKXZ7blqg4TZM9Q4nW1ogDMQv8Dititosa1mYB5E?=
 =?us-ascii?Q?jT8RmieWgHC1mpjQfoYUmAN9tsdnt+47H3zY077vpoTdayQ5Q+BWvtZMwGqb?=
 =?us-ascii?Q?/90n40GJH9zLh+u40TeblJpDA/vObojkR1HlZ5NjwRGpv3a6hfyBidaWDQgg?=
 =?us-ascii?Q?iUEMKADpW23Vj+yWGrygC4+WoBdPsojKZhDXLUXnv9IXsD8vqjMH17vexT2B?=
 =?us-ascii?Q?U+tCbLC48RLcICe7rOHNypCd5z06T3ipZaAGN8oFqwnWFH94oWp6iiGY67bl?=
 =?us-ascii?Q?dyF0yRCWaxhvetZ4GDlt8Ro2EwHKQIyMbm9oH0JkwL+Sz7Yu3hBcCpI0bcNR?=
 =?us-ascii?Q?/WIaG3msI4qwjS0v+fBdnH07tEwMYwvLya0dtTQWNrchrzJXBhDLZ0YhGl0J?=
 =?us-ascii?Q?V2WhT+8+Jae3OAPF1dirrA7zpXO6efv/5ERb48Ty5RE141xMYpae7MfsiWN5?=
 =?us-ascii?Q?H9DbiPHpcQrK/goCqUyTXUXDEjutFLG7QGWom2GnSsuwJG1c3iQZhW7T9w/e?=
 =?us-ascii?Q?QZdmg9z4tKjgdFRsRw+JHAozazdvl4ZFfMPW1aqVYPlJN7iZHahIcS/HLF4B?=
 =?us-ascii?Q?K4T4ZmTdR5ENSiiu99uCXa9pNiFZCfG7Sx8XL08zqiH5YQOCTH4OqzWsOeQA?=
 =?us-ascii?Q?YQ3MX1WodEu68+NqsWAEeC/9JrxCFpMiKBZjJjXYBzj7QweoC7EhntFllT2P?=
 =?us-ascii?Q?bC7xw+38Abpv9nF+3lz/obQfPlJO07tt2c2W7vKQ57d59++l/lYeoo6v5Wou?=
 =?us-ascii?Q?6OwHePT2ACxAYGu5C7a0FjBJFt25NQ6RprS7ovIHMWnUk85OEpXdgOJB0uZP?=
 =?us-ascii?Q?dbDJ79mLPa/nNzW+nDlJMTzjVruEV9aQS/8EtsEr2JJxMU6KX5kyVPNIXdfX?=
 =?us-ascii?Q?lde8aunPzF61fe6YqKFSdVwXZG2wXzO4SNne+zWc0OCQdcUa23ohLTxjb1Cq?=
 =?us-ascii?Q?psLi0WJc7cnFjRx7ZTQJ1Ht2q0n0gL3SgdDYoyfXQpEIegqMalLHWGCpiu2l?=
 =?us-ascii?Q?0akfMIZmN/2gOH9bhJnWpPQ/lGoElxdrol6QM78WFDlhAA9IVl3dD1Hxakre?=
 =?us-ascii?Q?PDXFqfu7f3g5ge3v2jb5sAHawnBVk1QrdvuqGB5aHoXQzWcbQGq7PK8BWppo?=
 =?us-ascii?Q?hwj1QpP2zN5NbxmpU01hqwHlh+7iIIZCCQtivEFIs2DS6OsnCzvoKLy/cYuM?=
 =?us-ascii?Q?W8O1RzirbR3WL43ZPmx+yo+UXYjvzE51l7E6s8dJWvcq8qSvGWb/4+6+6t/r?=
 =?us-ascii?Q?THsxYb6K8Sub7S9vTtH+azCWCWNHIcESnB3JRmnS0mKS1RCH+5io1eImTe4D?=
 =?us-ascii?Q?4uNmuyW5+FXTVS3mzhuZESVpaD8cV5fmg3QS/FGOLVyrlXWpQ68l3kXOKjI9?=
 =?us-ascii?Q?1hf8myCEGmM1PKD9xeu3suBCgHpv1tp1RQIcQCVO4Nk7UQYvk7kUY/OxXCH2?=
 =?us-ascii?Q?VzZ7thFm5Rrs6YpQG0NzSr2QtH4KTaA1R+WBEqBrAKrubZYBHGuvd2CR/Kzp?=
 =?us-ascii?Q?o9jkkg54rVxH9d5KShW5Xxj7F6wXznCJhJZQCsGzj+x+G5r9wnW4qn2wDH5+?=
 =?us-ascii?Q?THYgK6dkSG/qxqL2IyVJfSJ9A9GW5MLbBPESfMnm?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a124ecbe-14a2-4661-7978-08db115b73ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2023 02:54:28.7005
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: th5KZi/ZfP1dl14z0TeEnYPCcl0xAsjFb/lbphK8/CqgEMdHGViAmhmIbvqw0BwELKWyGqTVzAUrN2mM42Y6PQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4840
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

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, February 17, 2023 11:59 PM
>=20
> On Fri, Feb 17, 2023 at 10:55:08AM +0000, Liu, Yi L wrote:
>=20
> > One more thinking on this. For a single device, my above reply is true.
> > The device should have been fully-opened when its
> GET_PCI_HOT_RESET_INFO
> > and HOT_RESET path have been unblocked. However, when there are
> > multiple devices that have been affected by the hotreset. User may only
> > have one device that is fully opened while others are not yet. In such =
case,
> > existing vfio_file_is_valid() is not enough. Shall we have another API =
for
> > this purpose? E.g. if it's cdev fd, then the new API return true only w=
hen
> > the device is fully opened. Any suggestion here?
>=20
> I think what I heard is you need two APIs, one for pci and one for KVM
> and the PCI one requires binding to succeed.

Yes.

One is vfio_file_is_valid() - for KVM
Another one is vfio_file_device_opened() - for PCI.

Regards,
Yi Liu
