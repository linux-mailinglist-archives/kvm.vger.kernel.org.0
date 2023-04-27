Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 128316F0128
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 09:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242902AbjD0HCk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 03:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239605AbjD0HCi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 03:02:38 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FFDB449F;
        Thu, 27 Apr 2023 00:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682578957; x=1714114957;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vSPkuF6ksMNhvW/3jHVR7b4WZXAEXfiy1uur5HbZA/U=;
  b=naEOQNUyWFcAzI5YLZncqns9qFGHuXv5BR7wa2J4OF0eNI6R+IZAsfsL
   dfqpPPxEjoDYZg71FeVjlIzyXPGPnsy7ByLyeqh+PZ14scjiXNtA4q2SX
   yUxa4KSAT9flB/cJHX52jeT7+B1zX9LPcbXnZuse4my/rDNkHPqZLpe+z
   DyOsr4/Y4YRC7Uq2gFzoDXgIwFmlxjJh2SezggtIFVa8ZOhPsLsxWrPVG
   1FqMQEDhMQW2Ph11H/9h396LcMd88QppiQukvHtbsQzyEYbsDWw/HBimd
   tgKslYjV1vpJEp+Y+Aq0BZhLxOeOxrASAKe1ZV4N+lfCaf5I9DMTgDt81
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="433634735"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="433634735"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 00:02:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="805850314"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="805850314"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga002.fm.intel.com with ESMTP; 27 Apr 2023 00:02:36 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 27 Apr 2023 00:02:35 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 27 Apr 2023 00:02:32 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 27 Apr 2023 00:02:32 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 27 Apr 2023 00:02:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZfwgWqqYd0IcpeLPpZAuJOjb5stzs6sUKT/c6yiJ1Qdt0nPhicPSoeYCdTWF4DUw78X+8/BvZB3HZyCaOFr2alE3Te5vIjAIOYkGNnTOm5jtSIFfHdWm1XFCuAGIi67RR+5i6I5finVSLshLMpNKKvDDXRnVz3GbYAFNyA9NbYWKj9tgFVhEA76QBw3A2bj3u8jQnWAGvhhyQ/sfJOZEdDdeuqtwcLHyUGLMo+WzYk0HBWjaJR035eQjEmo4NcdNb5DququS/tTAAjmvhlEA+ubCdxnaj51gosnwHqxdEtCi8CPLb/OybfckfyIXqgIE7RrZycoHCeLCNlb5b9afEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OgxAJzO/WbMb/rq+c68Zu2UZmHvIMVmVJAmz7NoEmUY=;
 b=XBB5q28xoGGy0wW4Ja7emc2ZpPwHGxbK6BXBiI4FgExlAcZQagsqqIhUwtVpkm17dgv6QjrTdorXU7aGn3hifCQWcc6H4fihs2+A/MB2dh/hELkKkXfj/2isJ1JhLy567Ccl7Gjbgp2Wcv9ZdIzQXjsdo4YMh+zb1SGHeP0r5AliAXVJDMwFMrjvcY9H9b0vDB1DfrtEkp9vwi5d5OWZEtpbxvjP9uN36GoFACCVr4JCmxc/RvOuko9ZfOpTBI/ZIvK5v8x2IlZoUjV7zP4UTFActLziNpbH4zGVCia0kWwfScugTyjBsccKcOSBzNL24kcQY6Re1yLN9WGhTZ+LcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DM8PR11MB5573.namprd11.prod.outlook.com (2603:10b6:8:3b::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6340.21; Thu, 27 Apr 2023 07:02:30 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6340.021; Thu, 27 Apr 2023
 07:02:30 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: RE: [PATCH v4 9/9] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v4 9/9] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZeE8NMs2VKXFFVEeChj4nzOnsha8+uZAAgAACLoA=
Date:   Thu, 27 Apr 2023 07:02:30 +0000
Message-ID: <DS0PR11MB752981976C31C8315200FAF5C36A9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230426145419.450922-1-yi.l.liu@intel.com>
 <20230426145419.450922-10-yi.l.liu@intel.com>
 <BN9PR11MB5276451E0735E3057A9F4B628C6A9@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB5276451E0735E3057A9F4B628C6A9@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DM8PR11MB5573:EE_
x-ms-office365-filtering-correlation-id: e79c6ac8-6f23-42ca-8946-08db46ed5e2f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IiAg/0Poq1R0NjpUK9MJTo+9PKbcT5UIIngUdP2eQg1DVLBDyfeUHCdqeMPzSWRxBgOY+OudrqgYA1adeQKPCQde12AwnPuwCdZqf6Ca5B0RYlPqr7eXtcq3RUwJo3xwhSlHHMTPk/Kgmw+vIQ3XFbqONP7aM5io6wp/Evfdov1wHr9pIkaQiS6lC8ZtU80f72GMljkcX0gLTq1zSiJEAuPrXdicAkdrL3jaWqrX9Jy/enYdWsgReGcLig7pNSODZo1mOb6UvjkaaeeR6Ox27ZLZCVtQORZfQPenZXU7cNhv31d529igdk6CetQ7XefTsja0crTdbCCFxSw/uO7cn3hSC32sOqUIPTIVpAfHOMlHYkzXEgsT9n0YQMhjJzJ8R8QHMUp/o+EBKxbmIsmtkoYUGzvsaww4pOVQqA8DyX2cSxe0cAB11yvK+k0Mu3kLAtjq4eBzZ/zMFiXKmK7SttQjLkx5m7OL04S1RSQSsVcNqutKP3RXINH/8ZNYFznbftUlcOeneYzv3vpYwIfJydyvYH6DXnJuQy8y2J5Do2HyIn7GiahAxCXE8tYIfaUZBbpySuRiQvTxEXdik2QZuKRGsMiMYWCKekESMMC/YXrnlTfp7aF5mylWDqviQD3K
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(376002)(366004)(39860400002)(346002)(451199021)(54906003)(478600001)(7696005)(71200400001)(55016003)(26005)(6506007)(9686003)(66476007)(66446008)(66556008)(64756008)(41300700001)(4326008)(110136005)(316002)(82960400001)(186003)(66946007)(76116006)(5660300002)(7416002)(52536014)(8936002)(2906002)(4744005)(38100700002)(38070700005)(122000001)(86362001)(33656002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3HQ43rp7UZXf388BGHI9ua8AxpPVX4RnJYPCFkjHg8r6zE3SOyH/RMmKxbBW?=
 =?us-ascii?Q?e8FlTj927R1q8x7uR2TwUEmEb8nVPZHtoeH+XF6eOLw6LIjFi/7jLx2N+sbI?=
 =?us-ascii?Q?iKPnwdnqO1fsrCQOzK/xsqMi7Cl817tNPEE3mxG2ADKL21XOvQPKNYUqSFs8?=
 =?us-ascii?Q?lrhfJmI+cmKDQ37bUqujYM3MnxarJn96PauGs3mmyTlBZ6Y06Py5Ef90Mf71?=
 =?us-ascii?Q?UnJVWXdTOts6iVn/tD8EPrAl+NGtPd1280wZh30K8vWKPD8Z2LXckkqhZODb?=
 =?us-ascii?Q?w2PMf4ZK3gyEUM4sPwBD3kMSed35eNv09nP/8uy1dd+KYfQGTzVozigJkQL4?=
 =?us-ascii?Q?MULVZaZSyu5fMFiMK8RBsqmcCpCYjgP/x7zhoXYKsSzREPUxHD02X18a3NQG?=
 =?us-ascii?Q?pq15NMJBVwoTT+PKsUriu3c0KQcd/GwE53n3tTgPoBivtvcVZZXGtDVEGJPR?=
 =?us-ascii?Q?QUXti9G8kNHpux1NEAmEup7rWL9AK5GM6vZPfrTrvmVr2d9DMhb7UxXrpOlM?=
 =?us-ascii?Q?jFWb4oRppLhMsNDHEsyKSTg8TW0zjYsN+16NgIC66WQjj20+uM06CODan2hq?=
 =?us-ascii?Q?/CRpq5iXTfEa7m+WBcJR6j62ppAZ4H5U5f3mm2JI5oVhxRXQ6k5MhpcQHpaY?=
 =?us-ascii?Q?xVLPuw/1RuXcH5bxulsMZHP1IVxE/EVSOzPVdSQQkwVlBnH4wtuOobdhWG47?=
 =?us-ascii?Q?3qgnOJe6MmGSyJ9aj3/a6nm8lJ8ITz9DyvokNPDhv+M/abAorVPFcO7M60S4?=
 =?us-ascii?Q?GkoqrPCtbmEgvKUMWhzr3T5M2qwVT516LQ4MxmODcMMU++ExKPEaFkgOMKlR?=
 =?us-ascii?Q?rG5ED6WR0lxlfwF0qtQKkaN0CQ0VSZiep+wddoXxewxuO0KltHFcLuGT6gA0?=
 =?us-ascii?Q?jdUXN0sRmHGixru2yiK+koSDnEMRVErPOYAPjhgnn6ovWpf5GP+Ywo/ceOlp?=
 =?us-ascii?Q?xS/0SaMt6ATY/iyO4CVFia1ZPOCbxu2OlMxIFO59eV31qJQpE+L+wrvjl62X?=
 =?us-ascii?Q?FBqwrKnW+GEnUHL7I/0tdCpwNBoKbqOIo4gPDDJ6lUjNSoE0EfcxckCKGuI1?=
 =?us-ascii?Q?trNVfGhn+BzfpAhvyuoWRUmiCUvUHbb6Nddc166Q5kyZ91lugeQqJRERSRYl?=
 =?us-ascii?Q?YUfRrvJ+d2Ta/Ty89x2AFdiEEUMAolqwWSbaDtYlMcK/EQDlUNLdMtdps9Tk?=
 =?us-ascii?Q?cMeaKXc5dW2daZFCsZP+HPaG8hANvqcYS4xsIk8BSG2Kw4WysjnA2EVY+onA?=
 =?us-ascii?Q?edx7yDP+zFGIN/t7XiEkjEe7W6d+MLDZd60TW8mpLjfq2zDH2/wNkFdcLjbK?=
 =?us-ascii?Q?V4VPdkGg0et067Ahbm+evZpDTdYjCGwVRMtBFmZ8duwEZwLnQchHwAsgnJ++?=
 =?us-ascii?Q?5usT2NSDFjKtvcaSS7Dz9/YWCVZSRjUDieaLZpDVFegBSJs8aY/jlCHYu5uC?=
 =?us-ascii?Q?CV5EUxIhmf3zCel88h+vauiLLDAbX2NWLaUdTfih9z7IbiUFUi35yMoG2OPe?=
 =?us-ascii?Q?3D4u1hYEo0XGrWGGAGFHa0sFjDYn6dnv5TSuAhjf6Agc8iN/5dtxnrDMt6tY?=
 =?us-ascii?Q?RObhsWIGqFBVVGOZ4QoehFkcXFOzmTi/FHOW6gIM?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e79c6ac8-6f23-42ca-8946-08db46ed5e2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2023 07:02:30.3998
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AUrSV4ndNNv8ABZYeDJSnJlLRSZ6L52fC4TYJvmcqku9WtEDc6/rleVa2bad1niA81C6NXT1YDKYp+aV9pqNVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5573
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

> From: Tian, Kevin <kevin.tian@intel.com>
> Sent: Thursday, April 27, 2023 2:54 PM
>=20
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Wednesday, April 26, 2023 10:54 PM
> >
> > +static bool vfio_dev_in_iommufd_ctx(struct vfio_pci_core_device *vdev,
> > +				    struct iommufd_ctx *iommufd_ctx)
> > +{
> > +	struct iommufd_ctx *iommufd =3D vfio_iommufd_physical_ictx(&vdev-
> > >vdev);
> > +	struct iommu_group *iommu_group;
> > +
> > +	if (!iommufd_ctx)
> > +		return false;
> > +
> > +	if (iommufd =3D=3D iommufd_ctx)
> > +		return true;
> > +
> > +	iommu_group =3D iommu_group_get(vdev->vdev.dev);
> > +	if (!iommu_group)
> > +		return false;
> > +
> > +	/*
> > +	 * Try to check if any device within iommu_group is bound with
> > +	 * the input iommufd_ctx.
> > +	 */
> > +	return vfio_devset_iommufd_has_group(vdev->vdev.dev_set,
> > +					     iommufd_ctx, iommu_group);
>=20
> iommu_group is not put.

Oops. Yes.
