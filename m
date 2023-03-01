Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 779736A6DA4
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 14:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbjCAN7E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 08:59:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjCAN7C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 08:59:02 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00192A6F0;
        Wed,  1 Mar 2023 05:58:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677679129; x=1709215129;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=a21POoD++ZUfjLV5td6CSwZ5jf6LialyxwgnOuqf3wk=;
  b=BilJJvOqH1w86R9u+wRzPegHo0zyeSlRX6DkSqgHrdIaMm/Jxi/OzA1/
   HCqgfB1AZ3Qg8hIcMdr5wYAR5kZseOsD30u3GVDFPlMZRoHDBeepbfbZ3
   B3uL55YbbVW9ZAhX/toTZ1/SZTW6JQMX/7PmZBXcm6cdb4v3rDohtkv9y
   xsVAVXLui4OfjMZBb549xMrQyWfit3yGt8Xb9I2Hox7N0T9PPJOJqCEjZ
   LoxxnIC3a0G4fFDIFezT18mqybACyED3ffnEfU7CkNy7Q3S5Ho8U5PbwA
   W+aWIjRi84TmoEHseRqL8JTc6R5ME192F/6MHzGzcJ9Cgce4Ma5EgqNY4
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="333140402"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="333140402"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 05:58:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="920245336"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="920245336"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 01 Mar 2023 05:58:48 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 1 Mar 2023 05:58:48 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 1 Mar 2023 05:58:47 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 1 Mar 2023 05:58:47 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 1 Mar 2023 05:58:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EZ8fDoZQb4NzI/gH3RLSSYG/vrJ1dIRlApc8EYXqb88dqzgJhxZsIx5P+eArQx3dIMQQttpvStudVR3Ii1ErDkMTrXJkxF2b5Dz6PIBBgaMNmW44+FzLv2zYU1S1p9td6EwXox7EScCUD4vMcwSCK6pzV2/hHcBHpXZ1ny8OlnQQ+ChF5Iq+1rkTa/jgrOr/bRCjnW6kkcr7xy/zlYz5meU//l3zXyHvNkPjbVCSXilStNClNJs1wXaj8tBJ2JPRGvRgqD3Fymx/UgJ9rq/9XLUtwp4sd3vlaBoW+68b4KDYTXF08gBhFBwNOjYv76xAK50Yhr9sG7a2rIlAhrrjGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vKj0vKJv0TGtsvFj7naTDymruc+P9nhrLZ/ahi2xokg=;
 b=b4l34KJ/8+Kt0vReIrtDCiMcc7Q/tGWqLHCYzX/IU2oTT2XCFvjQbsmPR/v8V21yWlgGfE3riII39G8t2k1IIomd80/HGN+gIhuDf+NFS/6u7JQkNmm4qiV1+pTs5wsvTfMXoaXQVPqu3kNJ29jmRP1NG3nGF6MN6qm5caJdrd5ucbrEGzphFsuioFB1S18m1EwImXI/vRap1vm6ngBvS2A5KKKizF2bvnsBp72cDwuLe+JUGH+WD/JsYAsR0bWzp9nvUdwufYalwniQSWmbk68U5b4TFxA7UP/iPEFZWD/BZLQWOwyu4X9gTCumT1UX4in6J4J/t+RIeh7/LWTxqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by BN0PR11MB5696.namprd11.prod.outlook.com (2603:10b6:408:14b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29; Wed, 1 Mar
 2023 13:58:45 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6134.030; Wed, 1 Mar 2023
 13:58:45 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v5 14/19] vfio: Make vfio_device_open() single open for
 device cdev path
Thread-Topic: [PATCH v5 14/19] vfio: Make vfio_device_open() single open for
 device cdev path
Thread-Index: AQHZSpxLzIf6/b1XXkagijJzcXNiyK7jI/gAgACJkpCAAJ8KAIABqdHQ
Date:   Wed, 1 Mar 2023 13:58:45 +0000
Message-ID: <DS0PR11MB752978D65EB98E45EC00D69EC3AD9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-15-yi.l.liu@intel.com> <Y/z72jEID0QHgaLl@nvidia.com>
 <DS0PR11MB7529F1D9FE0F751E45363606C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/30qnOdKLeBjpGv@nvidia.com>
In-Reply-To: <Y/30qnOdKLeBjpGv@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|BN0PR11MB5696:EE_
x-ms-office365-filtering-correlation-id: b5b3de79-cba0-4b13-ee26-08db1a5d12bf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WtsLRV0asOPLsCcNbcvvXcFqJG+FLqbLuG5PXf+cGnV2QyUpdewTWSi8eiV6GGBxdX1fNDyDFK06Cr6tHHatbUwkvayYDMRXk3tDO4R+2Vo2mmxjtUe7XcJlaHWzxqKaohqDe83a4HniumAm291LhbwxyaEymw8ADvnFz9Ek6hGULTuHWSmSZwQjEnHJaaGHhLGmkRnLfv+yE6/Bwaty19hUalos/cF+/JcZqUWqFhQb+E1Tb6w4jlXaGtp2gwDUVRB6J9V2+KkUqWOhZjwXB0tcGNzyV8dmuu2jtg5E6lK3pdz9zx1F6cGDGCWR45HatY3RE2GIUsLp7konIs4tlgoTiy9s9ESVuirLGtSF1ahwWoiUd5cnM0rKtBjtWCItDQLVsAYQQAaIMsXMDXbohWJL+z0Xpn1cBfaK3HQoRQvUX2InRDbJwPkJqCyknqpFBwSLSOVC0i/Dcb47XoTqnBGM3itEhVX9kndaPNrbiArPCnbq1KlCb4rGHnNed48KW4h6DxeHOTblRUsoV21nxS1A/1etpkB8fLR1Ser9+kEEcuiymGvOd9ocm/ypCRHaDaN+LI9BmMu3BzHPqo1RH1omMxZRS8fJEJy6YPuqY+t4dnL+BVnl39pshnvFLx7Ga5b4gF8KF1qy0NnFlp/gla5JHlxyYs8GI8gwKjB1heBlaz4Jw2+aqN3+XfrFlkryz4S0uIuBNo+NG/73IvSyYQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(346002)(396003)(136003)(376002)(39860400002)(451199018)(7416002)(5660300002)(33656002)(478600001)(83380400001)(6506007)(7696005)(26005)(186003)(71200400001)(9686003)(4326008)(66946007)(76116006)(66446008)(66556008)(8676002)(64756008)(41300700001)(86362001)(52536014)(66476007)(55016003)(6916009)(122000001)(38100700002)(54906003)(8936002)(38070700005)(2906002)(316002)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FJYASw70zvQo2IFYJVu1iTakuVw5crO5Ld2ZPyMGgICMVOirVUPSfTQ/luCb?=
 =?us-ascii?Q?0A591jBbgGTJvqZAwkl3NJc/Z0j8ISt8xN4foFbtM5ZGxJj/CpAmeRN+YKur?=
 =?us-ascii?Q?dolMBNiqAm0YTAi3vuofOcAXlzV0+nC0IY2DvzzuYQ4IMH8kGrzPaIdJJXxN?=
 =?us-ascii?Q?NDgBt/rTSc+s4bQN8DqcuS6Cn4+yFIYK+zS02FpKsrl4g27tFd3Z+Xmuyoup?=
 =?us-ascii?Q?+0NKgiaM470TYzXjFeFcbnvTRUWnmBCHEOiv93A17JqXJ73OmZ4yoGileqv0?=
 =?us-ascii?Q?mR7sArdqNYrtxi7xCYNtM6D1SS3x1WwY5/fHqHpAylo4pKignT49qVTCQW4t?=
 =?us-ascii?Q?u5A5SHOqzQ6sug0N5H33QcsLOE7ZsJnBxKL1/2+e3FaFajyla72fT27wjihG?=
 =?us-ascii?Q?LfvK1ehv8xIouWcqCYMIHJ1AH+dSZ9Bl4SeVZ95sNFsfVqgnoIEcOaLc1PUn?=
 =?us-ascii?Q?lY3TAKiUJ+iSiEYGjPp35hcK9pA7WKpzYEcGsmJA/ov/rRJCNc2P3si0yd+h?=
 =?us-ascii?Q?USgW65uqgP8HY0rXzN3JRxjvyNkIF6cGA9u7KP/LOo4EltsIUivX+Y95F8pW?=
 =?us-ascii?Q?QJNZC4zFwFfpgbUsM3PtC/9xAWgtE8zSnuWx5alN33RaOBV7A8lA8tUrbBqX?=
 =?us-ascii?Q?aNYOOm2qkbIuPmRLvrQi3IUutvmcY9/jso/DBVfKi/ApAo1gFkot2dcKHev7?=
 =?us-ascii?Q?YoLV+kKh26yGBC9pcT9wvc9tk/LfBtuTJBiJNPHqGYwGP9YGt0Cs6g1PLhEk?=
 =?us-ascii?Q?dQtv5CweWaQip1X6RlyB3W1RFfO7Zl2WYpGTdfyRK4em21ai6SD55WiAzekS?=
 =?us-ascii?Q?C9ux9tMzQVUqMZBFe+icOZ8qiiq0+kp/2rQTkCBDb5VoDAE4mYsxL9IUS5nF?=
 =?us-ascii?Q?sd6UqR/Yc0OR3mkygazmpbnp1fsu53Bh/5SbOjpWm+nm+Scc7BFBC5EgHU51?=
 =?us-ascii?Q?sE33VJkDBP1tWUZ1oxwu5LqguNts9L29BXdFUH5C+NCKTRybpZ+8qfFaAhgI?=
 =?us-ascii?Q?5jOjQegKIeBDPxc4KPL4wVIyvMSjsPez70wJWGRT3Cb9nxbA7HhoV6n9qr1B?=
 =?us-ascii?Q?RnhdDD4lybVpynrM87WgttrENH2VgZEuiV1AIeVU6QKj8Wir7B0F1igCaOVb?=
 =?us-ascii?Q?pwTr81wJpI2D5u/0BnO7OvZnameAyg7zDJ3q+EBHam7cNRd/hNrHhmwpqFQB?=
 =?us-ascii?Q?wdKPht3/FynpHIMEfS2A2wBNVYXiAFxqH+CN54Zj9C8hUMx9tkaPTCHajgHV?=
 =?us-ascii?Q?1Q0djByPZw/1OfAM9y6084GjF6xcbWIqA+wNBUVn2VcoBaTq0QaZUfGfQLeK?=
 =?us-ascii?Q?4QsV3qbgjovbZWzSaK35v/7MJjbjlWymMMcVFkD4eIWYzs5fq2aiFipvzC7t?=
 =?us-ascii?Q?1Fw29ReTazd7dQN+68imrF2irbfeiTfeONwwlPLHKrTRb5f9vDAjGc+30G4e?=
 =?us-ascii?Q?gP2BEhGtqgXMTGBMYjrQS9MtVMNstsmc/pksV4Fk3JWyAh4NK/YphG3Y1PmO?=
 =?us-ascii?Q?NlQ5zYe/TX5lfsVw/MRkFe+77Dw6NiR0jhEF8bW4TatmkdEc7miWncEPG9D/?=
 =?us-ascii?Q?VOKrNl8oRDjLOvrCVbTxE3UGzmPvX78b751GgaG1?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5b3de79-cba0-4b13-ee26-08db1a5d12bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2023 13:58:45.1436
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lHqduHsNjTWw8O9KhYhBvjEB0G1Mh1cntI/DzipOcigipaOAK1Z4GH2UpMiT1gjKidF5Z++6L30CuWoM8iM8Qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR11MB5696
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, February 28, 2023 8:34 PM
>=20
> On Tue, Feb 28, 2023 at 03:11:34AM +0000, Liu, Yi L wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Tuesday, February 28, 2023 2:52 AM
> > >
> > > On Mon, Feb 27, 2023 at 03:11:30AM -0800, Yi Liu wrote:
> > > > @@ -535,7 +542,8 @@ static int vfio_device_fops_release(struct
> inode
> > > *inode, struct file *filep)
> > > >  	struct vfio_device_file *df =3D filep->private_data;
> > > >  	struct vfio_device *device =3D df->device;
> > > >
> > > > -	vfio_device_group_close(df);
> > > > +	if (!df->is_cdev_device)
> > > > +		vfio_device_group_close(df);
> > >
> > > This hunk should go in another patch
> >
> > Patch 15 or 16? Which one is your preference? To me, I guess patch
> > 15 is better since the user may open cdev fds after it. But its release
> > op should not call vfio_device_group_close();
>=20
> It should go with the patch that allows creating the struct file
> withotu calling vfio_device_group_open()

Sure. I moved it to the patch which adds cdev as this patch starts to
have df->is_cdev_device =3D=3D 1.

Regards,
Yi Liu
