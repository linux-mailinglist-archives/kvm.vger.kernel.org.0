Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB49E680FB3
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 14:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236600AbjA3N4F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 08:56:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236608AbjA3N4D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 08:56:03 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F310A38EBF
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 05:56:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675086961; x=1706622961;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+CGoSFluR879Glwif1RjxOD2Pu9Df3ApEa/OQL98Z0M=;
  b=HOWuOgUBiHICbaWkPxXA/CsmMWUDpUbVRk0Gi068nN91hknRA2V392ld
   g+IRCJrWi3zJBftrSTDHyMu9VRwgwq3M2XUAECectP78vJrH4ymoWoyab
   X72WvYW6NerbPOja/Zmd/1PwHCRnFsmktetXqGidU/kqLglPbb/TRtSHx
   0kB+DkIymsNzKn+FnZhIJegH18bylGctywPa4ca9ZC9xirjXjnxtN/4s7
   z7IluCcSTC7qQobLld1BGKyjgs+xX4fYWWLIKQfLkhzRN0MzIiTZtpYcl
   aUmRZNc2I4BliKtKH565lLMu1dwokm9PW4yxAvm1x+ostZdMFdaj7kF+e
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="326225694"
X-IronPort-AV: E=Sophos;i="5.97,258,1669104000"; 
   d="scan'208";a="326225694"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 05:55:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="837976920"
X-IronPort-AV: E=Sophos;i="5.97,258,1669104000"; 
   d="scan'208";a="837976920"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 30 Jan 2023 05:55:19 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 05:55:18 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 05:55:18 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 30 Jan 2023 05:55:18 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.44) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 30 Jan 2023 05:55:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=je21pm3WiQ7eIUVynK0t6y/Lmzz18NqwskR+BIYNW+BcEIWqyCsrEifO/mtFU4rfjEN0TDhBcm1hAL7oTwcQEguES+nmUytJJDiz1+RZOw5j/TO1ep+a4chwPdKgrBjL92VdWWGGwicreWsCa2XUbzHoTdcN/hnGCP9gAj2gmzUA9gL2xHSnC/PPQEbf/fh2i9HjnsR6IiNU5JcCyQoeYQvygg1mJQZTcR13J9Wtqn6KHTqIgasDO9w/OnyvG+njB2nL0Aru9jAXiPAhGTX2YQgyfgzgwkN+rMIukVOzcZRQ1gGdSxiCn9tT66/mwkx96Yd3S2BOa+FZX4bLK0g72w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OoCjXL0iPcYphlrjfyZNqHJHyQlaJn/+nj1+cxnGYYE=;
 b=Jv5XUC3fVsYo1PjwwbO6+qvyvOKEpzwUVyk2SYt5MvCcAZbAm3bqTLDx92l8RToDetLqpnQxyaB9yOj4y82zQzLFXjmxCDBV8nSmHuEmhAIJ80U5JiJH4ZwF8TMrLrOZgUzY1H7jPGhz8T9DvEJrznmsUIMgRTnWgTNfIYX1Yxskn7c6LGbXdfC5xcQGmXXVdm5QfmynYMqC8de3nEEL7a0682FfQM/F8anFgp/Ki10CGqUC2ISEmo56oqfEKkHLKXc9OOsafIubKlKPcs5zpEJZK1mryej4Vna/M5EvyRcF+QmT3b3kELb8sP4tvqCd3s0eakuMcda8SbQ3fGkmsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DM4PR11MB5325.namprd11.prod.outlook.com (2603:10b6:5:390::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 13:55:16 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 13:55:16 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: RE: [PATCH 09/13] vfio: Add infrastructure for bind_iommufd and
 attach
Thread-Topic: [PATCH 09/13] vfio: Add infrastructure for bind_iommufd and
 attach
Thread-Index: AQHZKnqY260TmmopQU2QvQkLUHfEK66mYAQAgBCvKRA=
Date:   Mon, 30 Jan 2023 13:55:16 +0000
Message-ID: <DS0PR11MB7529D84BD0B3D069DED17296C3D39@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
        <20230117134942.101112-10-yi.l.liu@intel.com>
 <20230119160514.0642cc21.alex.williamson@redhat.com>
In-Reply-To: <20230119160514.0642cc21.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DM4PR11MB5325:EE_
x-ms-office365-filtering-correlation-id: 83b79a96-e9ee-4325-d616-08db02c99e11
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4DaZ0NQQJAD6/uIIq3brDzne5JT2MRkNwPTIO6uraFZCw4/6notfQjJhF9GHWDZETunwFBSRsx5k4QtM+2jWwSsPCD7iawMMcS1jAvqWm0CY76PO5eGDZQBn6OUtwZdjuMm5gEtlzfsJfbckster9bSiwDAdd9PtyLxCAFY22AjETpRg7+PDZcfubzrdeBkg5uAiezO6ptsVSoqiOKgcvXVB3fFC4laHhuTYavHrB+pwwnteNJYYT0nmcTUjprLgDuXOb7MubskINWY//WGKWWqh3Efs2ub0UBZnjfScghth1j8CS+Ngl0dgLsbULeeEHWquUK79I2KHxE3m71mnu3RXzftSzHQaXAVSLfSruO1a09vkidbyA7wQQ4D2W8Nd6nNEUUEuH1IvnCvPjaoon1SY6SeOLIh8Owz/K4kz5KheRtKIx0VRKkjMJi4taSfXvxJtJ+HLjOitjzFPBQuB3g8tt7tdyAVoMDuezoPVOAT/U0dBPig6bJgZCqskCQOqggfmnh52WoHOG/VSDCy2kmuAqTMTIvmhhvBUuPhtdbk3ORGZ3KtFH4Cx4hfTkcD7zxGgJ3VeAG9QRhZj0aEJ1MDRsUSJ8cA3j5jwlxhe4J3Za5vkstKogx64HdJP667EtQ/oQ/3jgJIL829t87IbbN+5kEoObakTsbxmpzj2+3ohl0/XzRP4ZlzHEPPDlfz/m4NvO5is9Y/8ImzQ+G5SRqN32NlnnSTmCLc2hhv0+pg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(366004)(346002)(396003)(136003)(451199018)(8936002)(41300700001)(86362001)(5660300002)(52536014)(38070700005)(7416002)(83380400001)(82960400001)(33656002)(55016003)(54906003)(122000001)(316002)(66556008)(66476007)(66946007)(38100700002)(64756008)(6916009)(66446008)(4326008)(76116006)(8676002)(26005)(9686003)(186003)(6506007)(7696005)(71200400001)(478600001)(2906002)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?t5R3mVnyntVgmHCNTQVFmtY5yMLwgu5pyfs3MPPZFi2jvSMPlelPqiCW82U/?=
 =?us-ascii?Q?o4kHUurBNl9LSgs9m/FrpU/2EvaFArFpIZG5sX6DfJNQK7j+Y6qvPj8FpD4L?=
 =?us-ascii?Q?OIhSc/Y84AN7j57A+JpITCv9uXqCc9iMp/RUN/CS86l3WZzqU1wRSTLXy54w?=
 =?us-ascii?Q?6Xh+42eiM4KqyefVAKOTKdR+5egOuAd5ltf9YOVr+iPKrEltrGhjpXZYr2Yo?=
 =?us-ascii?Q?DO94Ocpc1yZpjckGt6kXpfAeZLgolimGAvTVLlqcpuOZaeMjLSwW4X2qrOaG?=
 =?us-ascii?Q?GzLOFmvBoiAMwqU89KeEoMXwCmvacm6YJWyv9xsxZ/doG1N+a1ZgiHVGCocj?=
 =?us-ascii?Q?trRWK9ondr/SBV/sSyUqDy5Ydu3YmFzdqs76U8we9f4Moj7GspnF06lvAtPf?=
 =?us-ascii?Q?WzACfXtF28JTMUS2zles0HMb0Qlw+mnsRWN625ZoM/7mfeb+cQcP3aPLSSi+?=
 =?us-ascii?Q?RBsVnp15owThVQrJGATL1b7dqqKRVCCWggfhXlwDVDdo5eAL4qmos6YQyfV6?=
 =?us-ascii?Q?IlAH35cCKGs23fiw8lhecgHjxu0oRQIK7vx3SheDmt/eRsPwKhf27G24LiPn?=
 =?us-ascii?Q?+MjkefzbAePCU/sTNxyBYAcLZYLIazfanywVNbHhGXRV10hFTvUXpF1azLud?=
 =?us-ascii?Q?sq23YyxTCpeyoNW+7r6+y6Z1U3Zs6RINO1ranT3ewFy9F6D6NA+RICPdlXjt?=
 =?us-ascii?Q?dKl90Ub5Ci0NFxqeJnpUmUemfNEg6umItDpOTMbFN930bJ9qNWbdaa1gNR2K?=
 =?us-ascii?Q?nDxnCWHBZrHtobe9rSj3ZxaoLD+zRbAtE1/imuTVCEMR/FVUXi2UgbxWSTV7?=
 =?us-ascii?Q?RmGPDu9W/WEoq8wZbRHQOGAmMJmL5DSUXLrTLhZuijlUIllNRZjggu2GyeBn?=
 =?us-ascii?Q?PfrUmJo0glxCZRHZtL8ZgbBNZ38pwOCSjDAaLST+Ny5N8mqekIHCWjuy1N7G?=
 =?us-ascii?Q?Wi5pn4/Ss4TR0tDq1GvUkDQwbckS1AfP1i/yq29fbjS991niTdEtTT+imT1c?=
 =?us-ascii?Q?uljSeIhGuaXG5LAXMyWv35qIz5inWT51xiyJaUFkm9gUwZmwbAf+E2NMPcGn?=
 =?us-ascii?Q?nE2tvTmHCBg7zLb3yi0+3wmBrSGjiZ2ldTOAbnB7cpatEYLjpGNHJ4J5r9t+?=
 =?us-ascii?Q?L4uiMoSaEuarPb49l4+6GyuCYqPHeT/791kjK/N8OprO3l1dtbb/hACVCof1?=
 =?us-ascii?Q?PhG9WfWbm4zVFmW8okvjrPVbsszRB/mddCnaHuIb7yHSfJ+v0sYEclaOmpGj?=
 =?us-ascii?Q?svnhBKqZ7qoFLEvAxjYRUBQrynKGsQe/wLl2RpvOaLqWkY4h1kM/ACWV9rus?=
 =?us-ascii?Q?tH5/sdG7lTrxJJBu/w12kD2Pacs36NTeyW0EC2cxlpfhcLC41+bmJGuDHBv+?=
 =?us-ascii?Q?Hy2qoo5KqZKlT02lxVkobL+lYs1wWJOuZqgMQdRxgoErkwy30IkOD+zY8a72?=
 =?us-ascii?Q?oMSImxbxsB/KVKciROjKyJk05QGz7uspqsotMOP0hcHMiB3QCP2KUdwdytys?=
 =?us-ascii?Q?8SJcnXxvVpvDFnBsC5lp/8GdFMvj/B6vAV+AccRk8P9mociRjNiVnbK78Rol?=
 =?us-ascii?Q?xuwCzh5t+0o7B4KFnS8J6UqFmPZzAKGJ3FJPObnH?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83b79a96-e9ee-4325-d616-08db02c99e11
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2023 13:55:16.6395
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KfCGXwsGt3CFvaFRFwaYkQeMZhezvEm6uGsILws0t3rSYX9oMnGvs/e7Yt+eiXQwKR/PbRlo9UNhIaVZKb2M8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5325
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, January 20, 2023 7:05 AM
> On Tue, 17 Jan 2023 05:49:38 -0800
> Yi Liu <yi.l.liu@intel.com> wrote:
>=20
> > This prepares to add ioctls for device cdev fd. This infrastructure inc=
ludes:
> >     - add vfio_iommufd_attach() to support iommufd pgtable attach after
> >       bind_iommufd. A NULL pt_id indicates detach.
> >     - let vfio_iommufd_bind() to accept pt_id, e.g. the comapt_ioas_id =
in
> the
> >       legacy group path, and also return back dev_id if caller requires=
 it.
> >
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/group.c     | 12 +++++-
> >  drivers/vfio/iommufd.c   | 79 ++++++++++++++++++++++++++++++------
> ----
> >  drivers/vfio/vfio.h      | 15 ++++++--
> >  drivers/vfio/vfio_main.c | 10 +++--
> >  4 files changed, 88 insertions(+), 28 deletions(-)
> >
> > diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> > index 7200304663e5..9484bb1c54a9 100644
> > --- a/drivers/vfio/group.c
> > +++ b/drivers/vfio/group.c
> > @@ -157,6 +157,8 @@ static int vfio_group_ioctl_set_container(struct
> vfio_group *group,
> >  static int vfio_device_group_open(struct vfio_device_file *df)
> >  {
> >  	struct vfio_device *device =3D df->device;
> > +	u32 ioas_id;
> > +	u32 *pt_id =3D NULL;
> >  	int ret;
> >
> >  	mutex_lock(&device->group->group_lock);
> > @@ -165,6 +167,14 @@ static int vfio_device_group_open(struct
> vfio_device_file *df)
> >  		goto err_unlock_group;
> >  	}
> >
> > +	if (device->group->iommufd) {
> > +		ret =3D iommufd_vfio_compat_ioas_id(device->group-
> >iommufd,
> > +						  &ioas_id);
> > +		if (ret)
> > +			goto err_unlock_group;
> > +		pt_id =3D &ioas_id;
> > +	}
> > +
> >  	mutex_lock(&device->dev_set->lock);
> >  	/*
> >  	 * Here we pass the KVM pointer with the group under the lock.  If
> the
> > @@ -174,7 +184,7 @@ static int vfio_device_group_open(struct
> vfio_device_file *df)
> >  	df->kvm =3D device->group->kvm;
> >  	df->iommufd =3D device->group->iommufd;
> >
> > -	ret =3D vfio_device_open(df);
> > +	ret =3D vfio_device_open(df, NULL, pt_id);
> >  	if (ret)
> >  		goto err_unlock_device;
> >  	mutex_unlock(&device->dev_set->lock);
> > diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
> > index 4f82a6fa7c6c..412644fdbf16 100644
> > --- a/drivers/vfio/iommufd.c
> > +++ b/drivers/vfio/iommufd.c
> > @@ -10,9 +10,17 @@
> >  MODULE_IMPORT_NS(IOMMUFD);
> >  MODULE_IMPORT_NS(IOMMUFD_VFIO);
> >
> > -int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx
> *ictx)
> > +/* @pt_id =3D=3D NULL implies detach */
> > +int vfio_iommufd_attach(struct vfio_device *vdev, u32 *pt_id)
> > +{
> > +	lockdep_assert_held(&vdev->dev_set->lock);
> > +
> > +	return vdev->ops->attach_ioas(vdev, pt_id);
> > +}
>=20
>=20
> I find this patch pretty confusing, I think it's rooted in all these
> multiplexed interfaces, which extend all the way out to userspace with
> a magic, reserved page table ID to detach a device from an IOAS.  It
> seems like it would be simpler to make a 'detach' API, a detach_ioas
> callback on the vfio_device_ops, and certainly not an
> vfio_iommufd_attach() function that does a detach provided the correct
> args while also introducing a __vfio_iommufd_detach() function.

Sure. Will change it.

>=20
> This series is also missing an update to
> Documentation/driver-api/vfio.rst, which is already behind relative to
> the iommufd interfaces.  Thanks,

Yeah, the vfio.rst is already a bit out-of-date. Will try to update it as w=
ell.

Regards,
Yi Liu
