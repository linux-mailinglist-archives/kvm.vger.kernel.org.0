Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC3372D994
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 07:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238415AbjFMFx5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 01:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237495AbjFMFxt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 01:53:49 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E55F18E;
        Mon, 12 Jun 2023 22:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686635627; x=1718171627;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=piEg9HiUG9phlgTjXwD3XaCoBACdgToEB/jcHdoA7ys=;
  b=JxvfhmSJQq7MMycz2RjItXtHZ4Z1CiowOrCdkyY83G3F2JbTFtAP+lfU
   1OjTH5Gd1PnQZq9YIdmQBRsAZFUlr4nG3iUsYX9byuABppgyI6uudblRl
   9deWmrsxVe0PyFlqoXkP3eYGd6S/TkmDcaTD1XqAfRFQ1k+fsooKYSS9w
   tTCNfQod5qf7EQ5N/Bli42yuzcwNf+d5EFUdOgrIJcs85BF6HOo/yZeG9
   4p2GwgBkkj7UcBX+Gko0rCILgxy4HCbAUJH/xbaZMi0X/s3qdv4GeAGXq
   y/6Cq+tugfOGW/j34dI5736pYMN+hkVh3KaNrZ3luTSXZusMjU/L4s1e9
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="424118979"
X-IronPort-AV: E=Sophos;i="6.00,238,1681196400"; 
   d="scan'208";a="424118979"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 22:53:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="705666302"
X-IronPort-AV: E=Sophos;i="6.00,238,1681196400"; 
   d="scan'208";a="705666302"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 12 Jun 2023 22:53:45 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 22:53:45 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 22:53:44 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 12 Jun 2023 22:53:44 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 12 Jun 2023 22:53:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iWXLiVMhlXRsTvZIa/32NLk2gmdKApDMbWMASqdSh/Z5VMbldqY68Te+kd+P0+VqeNKDR6sKF8Nvt01JAYbtppAY25SYhYQ5EgfcSsPhUdh5E0rHBUngLd8sJtMhYm+MxR0bCh18iIAM81BENI2wI1IuZVKVPqZKWlsqycWfpisIzdtJjgFNRuDlNINqted9nur3sgdk//coUBbviaRxFHXMPZ2YZPnAcERns3oUn2vjftSDCJKzz5Pei4uuRRSd2R6/1E58FKJam3NJf6vJe2+nOPb0p3/RzhC0QEv4RV+YfCJUXE4SmVCTqTggbR1+RwK4r+QL6yoJjKZLuAguRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rJeEnRGdw4RlnaeszE22+fmZBz2eB9nwiE/g+WlRUpc=;
 b=KP0RgNs9w1qeDwqrpl78K3VUPqSBJ1llB5it6qh0vR2puXAd7IvphH1VJBm88b1LNxP532b/eHnsv6K0wFp650IN2enrT7UOO1D9gIXEUnfu7To/aaem9BmUvjgyw79hu/9zz+fCJYUxN8KbG91ZyoLe5kiW53V4xnPIapzMEv4X0oMb5PPLpI/PkqnEqhECFLx1GmWQMRJ5CyXKO+jhgHXr1kPFYoY0LRVq+Nf0hj+UFWrEXzjzU5jPf9B4CSgK6SP+s0NrRWKokhuvKe0tFWsCbw2Rf3rhQZSJ9l3vEop3+WzROXBWZk2Af7nw3hAM8NlEfpUmB+aRAPUx7nClEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CH3PR11MB8093.namprd11.prod.outlook.com (2603:10b6:610:139::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 13 Jun
 2023 05:53:42 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6455.045; Tue, 13 Jun 2023
 05:53:42 +0000
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
Subject: RE: [PATCH v12 21/24] vfio: Determine noiommu device in
 __vfio_register_dev()
Thread-Topic: [PATCH v12 21/24] vfio: Determine noiommu device in
 __vfio_register_dev()
Thread-Index: AQHZlUw5Bdx6t/Ptjk+i/O1PZ4IdNK+H07wAgAB3NRA=
Date:   Tue, 13 Jun 2023 05:53:42 +0000
Message-ID: <DS0PR11MB7529AE3701E154BF4C092E57C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
        <20230602121653.80017-22-yi.l.liu@intel.com>
 <20230612164228.65b500e0.alex.williamson@redhat.com>
In-Reply-To: <20230612164228.65b500e0.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|CH3PR11MB8093:EE_
x-ms-office365-filtering-correlation-id: e149ee9e-941a-4881-d0e3-08db6bd28af9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U7niYBROswOPFag8xnbGTf000SKM+YNXWnr6+0h9wiWFY1ovDwtkOCBn1S4JLkDGwrV9IJpdCOud6A/8PSo+4b0GD83mlPYW043M0Wi5JxBFWrYGcR6J+RVNQ41lWLzq+p1kI+WWBee/OzfrywpYtMCratHI4HrDHWuOeuQCwiwXNvbgtCmjeZ5qG0jqRGylbxUTSrzXBr9bRf0UdhjsPu6CBd8mf5OM9OBLrzzUIQV1PlI2mzJX5mLH4hWjVUX+iEXAkITY7e+4ew7+n2eeosPYdozAAfBgFK761EM64mEMufl1UyylD+YCQRkjrSKQvx8eKkXGyuIR4WHnvrtb2VCb2XIUMDWX9kQdU1RROj/E123D6SUh7GrUO1BEmRhtexw0xgnm6euEwxMwFCrmffJeji/6hyQvGgUhMh5B2ooFY8Mam3/cWHYpaniMKGoA09ZcG3Ut1/WX+87ivz9qHfFJ388IhLszbdKMLpiwNDCltfhL6QvymZUZw+tQm5OY1XmgC7YYgXNxRY1l278enrxyIQURFIGrqIxjQqqpw9kxYGGDdvHNM84gLjri9P0P+wUQ6CZFzE+SSRw1l1uXQan/y+7VgFekTAOqMFn2VDWmy5JHC0Yq0vadpAOxBGvh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(366004)(136003)(346002)(396003)(451199021)(6916009)(66476007)(4326008)(66946007)(478600001)(76116006)(2906002)(64756008)(8936002)(316002)(41300700001)(8676002)(5660300002)(66446008)(54906003)(66556008)(52536014)(7416002)(71200400001)(7696005)(9686003)(86362001)(26005)(6506007)(55016003)(122000001)(186003)(83380400001)(38100700002)(82960400001)(38070700005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yXGKcoWTNPkcSO7w2F1THqYCsQsa0TiAS0thsFi3KNnUJ3V9LjQRVJJxHTHL?=
 =?us-ascii?Q?pALg3V/17YnCEq5/AaTWL+NICKJT6qhwKE/O1JI99mI4wzcQjdFStvht3N79?=
 =?us-ascii?Q?OqkCe4lj14nXTK8Y2piQ0pC0BsDBhr7ob8dyM/XYI9UXTYXMcXZmu+7FfSay?=
 =?us-ascii?Q?IYq0KJKeTyGG4egWs6blb7L278XxwVrJXG4TrAZbnhsZdSmtkWCWV+sqt9+Z?=
 =?us-ascii?Q?FEolaN7HlwQ8tvQ3ylNPnZbB5pktEiFvvvYf8J52o88e3KF0ryQKWjee4O3u?=
 =?us-ascii?Q?KtUYriuO24MqrIr9NBwVp/2IYTnhs3vnx8gQVLnIoTC98K7RYpE2pfusekc7?=
 =?us-ascii?Q?SrS/NVVDSOSx+UZobdG3QGeZJkBllYExVgMK2vOQHRaME2Q2nyP2fhgjvyzJ?=
 =?us-ascii?Q?BhuY8GqexZ63oFweB94kW6/ATY2dG01IfXuEyMLEkMHSScw95iNtDk7OaAjD?=
 =?us-ascii?Q?jNCYKsmr8tN+Wizc74rjI9Zj/bdOe2HJET9Ad6oL9UFU42x3dj8IpmHF1ww6?=
 =?us-ascii?Q?zvSWzvizrmuZKdydJiIgR3RTXufBl5ob0MPhKL3Qui7E0s9UDRC/7PEcgmgY?=
 =?us-ascii?Q?dnfIY4/bJ1ic7326WJfEwmAFKsYnuGVoZHb+sJ9UieAgOPzyfrN0ZAOMfccY?=
 =?us-ascii?Q?hmlmO8JFonxEhqSMLJ3mZpMb7YnqPPIncfd0Sp+5wkEQdyr830S/FwRUzm/q?=
 =?us-ascii?Q?2Gkx5WFGBH6W+mtpuCKSyt9zJ+i80Ci25q8WfULHPoMJGnWf24Sxw0AtlUzU?=
 =?us-ascii?Q?Z9XCZcU06IzN/IxFiq9nb/PEv5UHJ1C+4+nVJgmaDG5uymQFFvMf0QfYy6sH?=
 =?us-ascii?Q?uEgSC3YNu2eoMXf1uEEYWFYr6avVacB7n03GKpszgE8HdWyVf55j8FJHVgca?=
 =?us-ascii?Q?8sIPl+RrZUNJuD62+uwk/um5afhxqLtt+gv0SbqJdH7iVRNfVtvNqUD6OvE3?=
 =?us-ascii?Q?6z9wfLnV8E8H6aiuw2CYLPEH6yt5BElzAVhGMKBmfDdlFdEUlEAzyB+Ce8x1?=
 =?us-ascii?Q?0HaR7cK4Xt7XPde/LOKg5joegLhXsKvEKHVVln0EksFlrQ4b0TfZjqHs0Opu?=
 =?us-ascii?Q?UyfraN5zAQ9+VC+EVaPCeSeJ5Whw5eK9YuADnaDEXmiDrNzO97Aczml1vYv0?=
 =?us-ascii?Q?ME2QGmP+0VMs6ODierrRNEusdYprHMud4s0oWxL5uoxV5hG31fjK9A+8Fpt9?=
 =?us-ascii?Q?f+jwah2vNNJf1cqlmgIZ4sIGW8AToPtNCBxgmh97Zp1jVCkbVU8XcjYtMSTe?=
 =?us-ascii?Q?E0IMKxT+hUm012d6cexmyIWB0k86DCLnLuxKQ+2cAHNCoX1vgE0OnRXHZRIQ?=
 =?us-ascii?Q?WCSa1UE1Jamn5HWnX6reBVp2zFa5/BtVmuRKMlqAsuS/w4e4rioSPZXEs4Z3?=
 =?us-ascii?Q?7CHoyuCxYLP7xiwiwTMkiW1189X21QucMA9BNk4ws44iofSzW5R5M9CbdDKj?=
 =?us-ascii?Q?bp9z8fLUoqogYvhL7SoCLl2Co2PqQxnoLTHb5jFUBB91Q/rhITN88zBRewGv?=
 =?us-ascii?Q?dWjGPQHDJKxVBJxCzF9TBXHfIrdEh9JRHCGgaNZKEB4adv0pmp1zgFu65x7F?=
 =?us-ascii?Q?vZO7QhhxDARJ9itNcO/3VcwQMFHC0yKomsCiNN0I?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e149ee9e-941a-4881-d0e3-08db6bd28af9
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2023 05:53:42.1418
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7rPnDtCSFZN+5fCOLP6Qbxb8Slnuuo6BVPSPy97aICgmY5oxY7cgBwM1bzgKsuMAgm67P7Ggq1wQTlR0EmpIDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8093
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, June 13, 2023 6:42 AM
>=20
> On Fri,  2 Jun 2023 05:16:50 -0700
> Yi Liu <yi.l.liu@intel.com> wrote:
>=20
> > This moves the noiommu device determination and noiommu taint out of
> > vfio_group_find_or_alloc(). noiommu device is determined in
> > __vfio_register_dev() and result is stored in flag vfio_device->noiommu=
,
> > the noiommu taint is added in the end of __vfio_register_dev().
> >
> > This is also a preparation for compiling out vfio_group infrastructure
> > as it makes the noiommu detection and taint common between the cdev pat=
h
> > and group path though cdev path does not support noiommu.
>=20
> Does this really still make sense?  The motivation for the change is
> really not clear without cdev support for noiommu.  Thanks,

I think it still makes sense. When CONFIG_VFIO_GROUP=3D=3Dn, the kernel
only supports cdev interface. If there is noiommu device, vfio should
fail the registration. So, the noiommu determination is still needed. But
I'd admit the taint might still be in the group code.

Regards,
Yi Liu

> Alex
>=20
> > Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/group.c     | 15 ---------------
> >  drivers/vfio/vfio_main.c | 31 ++++++++++++++++++++++++++++++-
> >  include/linux/vfio.h     |  1 +
> >  3 files changed, 31 insertions(+), 16 deletions(-)
> >
> > diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> > index 653b62f93474..64cdd0ea8825 100644
> > --- a/drivers/vfio/group.c
> > +++ b/drivers/vfio/group.c
> > @@ -668,21 +668,6 @@ static struct vfio_group *vfio_group_find_or_alloc=
(struct
> device *dev)
> >  	struct vfio_group *group;
> >
> >  	iommu_group =3D iommu_group_get(dev);
> > -	if (!iommu_group && vfio_noiommu) {
> > -		/*
> > -		 * With noiommu enabled, create an IOMMU group for devices that
> > -		 * don't already have one, implying no IOMMU hardware/driver
> > -		 * exists.  Taint the kernel because we're about to give a DMA
> > -		 * capable device to a user without IOMMU protection.
> > -		 */
> > -		group =3D vfio_noiommu_group_alloc(dev, VFIO_NO_IOMMU);
> > -		if (!IS_ERR(group)) {
> > -			add_taint(TAINT_USER, LOCKDEP_STILL_OK);
> > -			dev_warn(dev, "Adding kernel taint for vfio-noiommu group on
> device\n");
> > -		}
> > -		return group;
> > -	}
> > -
> >  	if (!iommu_group)
> >  		return ERR_PTR(-EINVAL);
> >
> > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > index 6d8f9b0f3637..00a699b9f76b 100644
> > --- a/drivers/vfio/vfio_main.c
> > +++ b/drivers/vfio/vfio_main.c
> > @@ -265,6 +265,18 @@ static int vfio_init_device(struct vfio_device *de=
vice, struct
> device *dev,
> >  	return ret;
> >  }
> >
> > +static int vfio_device_set_noiommu(struct vfio_device *device)
> > +{
> > +	struct iommu_group *iommu_group =3D iommu_group_get(device->dev);
> > +
> > +	if (!iommu_group && !vfio_noiommu)
> > +		return -EINVAL;
> > +
> > +	device->noiommu =3D !iommu_group;
> > +	iommu_group_put(iommu_group); /* Accepts NULL */
> > +	return 0;
> > +}
> > +
> >  static int __vfio_register_dev(struct vfio_device *device,
> >  			       enum vfio_group_type type)
> >  {
> > @@ -277,6 +289,13 @@ static int __vfio_register_dev(struct vfio_device =
*device,
> >  		     !device->ops->detach_ioas)))
> >  		return -EINVAL;
> >
> > +	/* Only physical devices can be noiommu device */
> > +	if (type =3D=3D VFIO_IOMMU) {
> > +		ret =3D vfio_device_set_noiommu(device);
> > +		if (ret)
> > +			return ret;
> > +	}
> > +
> >  	/*
> >  	 * If the driver doesn't specify a set then the device is added to a
> >  	 * singleton set just for itself.
> > @@ -288,7 +307,8 @@ static int __vfio_register_dev(struct vfio_device *=
device,
> >  	if (ret)
> >  		return ret;
> >
> > -	ret =3D vfio_device_set_group(device, type);
> > +	ret =3D vfio_device_set_group(device,
> > +				    device->noiommu ? VFIO_NO_IOMMU : type);
> >  	if (ret)
> >  		return ret;
> >
> > @@ -301,6 +321,15 @@ static int __vfio_register_dev(struct vfio_device =
*device,
> >
> >  	vfio_device_group_register(device);
> >
> > +	if (device->noiommu) {
> > +		/*
> > +		 * noiommu deivces have no IOMMU hardware/driver.  Taint the
> > +		 * kernel because we're about to give a DMA capable device to
> > +		 * a user without IOMMU protection.
> > +		 */
> > +		add_taint(TAINT_USER, LOCKDEP_STILL_OK);
> > +		dev_warn(device->dev, "Adding kernel taint for vfio-noiommu on
> device\n");
> > +	}
> >  	return 0;
> >  err_out:
> >  	vfio_device_remove_group(device);
> > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > index e80a8ac86e46..183e620009e7 100644
> > --- a/include/linux/vfio.h
> > +++ b/include/linux/vfio.h
> > @@ -67,6 +67,7 @@ struct vfio_device {
> >  	bool iommufd_attached;
> >  #endif
> >  	bool cdev_opened:1;
> > +	bool noiommu:1;
> >  };
> >
> >  /**

