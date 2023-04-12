Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 393F36DF1AE
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 12:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbjDLKJm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 06:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbjDLKJj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 06:09:39 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ABDE30CB;
        Wed, 12 Apr 2023 03:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681294177; x=1712830177;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=z3mMZtK/0wiAsFh3rSro9DUgp5Y5tVGVPoslnp/qp3c=;
  b=LlmmVhRj15dwHtH7Zp4ge+RX8uYK4fs9AwDktf09HBCEYzTN98Wt+FHy
   lp1pIRmADdNEWXL323G1B2XIAidioZZODFLPAm6QFcxDaOhPDMMBwlsHz
   uARTZD7AmgbwiSGN2e2rP1Uk/UBuOA04J7HbwYdymErakYcsyEuGJG59N
   chAS7Jkj1DSJE3+AGIDZEgrhYQ4eapXF1odQtOQRNe6Tzwn6pYL/sMW9e
   9c3ev8TcEgWiPQSjgLjO7WeRAUwuX+nQY9O6fWRkmXe/f9Op94YOHmvxE
   mUxzfDmes/1Du3TfIkjgklqF+3UMGRD5IyBXQbOivPw1OxqSnHdxTTS55
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="408994370"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="408994370"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 03:09:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="778246730"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="778246730"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Apr 2023 03:09:35 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 03:09:35 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 03:09:35 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 03:09:35 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 03:09:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F4OX1gk3Ec3Je+xVxJFVCQV403mdIQ5p64dXQ46D4algX7lva4K6S/Y+zsNU9bGpqjRofS0q8VWLrYNJjMIkspXExxGPRQv8AjqokFhG37ufUKA38DLt1RVKBkiWxncNPClUVlJ0v79PeNpwcG6ewN3VpgMeulGndu4g5aYJ20SUt3Hv1I2wqm4kuA2IBeIjvmqQnhfTs8XCx3P8QvEDkfkChdrEoQH4HmrGFBh5ZX59ZT03Cz06O4WJvf6r4LzmcEGezFOB6eAjpwAR7UqG1/pVQIf3JXO1SuYqfY4CPEHY+J/wW16di6spQrmxZCutaMDcIJrlgi8Ax7P6ZFpSGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8y8Hs9v76wqlVRlzONdRRkgxtI+nO9QSud2SMTSWL/g=;
 b=B4KPeSJum2Ee52eIHYspJHUROKK+z140/4c2LLbkT946Uk+mkJ4h3YaQEQGHF+Iu6vIi0OpZCve1K5AhUKSF4ps5UcWgZSxWOc4soikURct/uI+Y9Uv2mv2cEkg0mllqFRGMEYaaTsCGiU6mkP5lq7wmiBa3pi2wzHaZtla7y95zSyDrTSqnYhurQLkCG/YUE6exMdXkxl6C5MBWTqAtG0dUANcCh4zl6a9dDYbedO19NupxCoRt7xxTQI03h2/lIIUpt9NImEwsGDy5c0O3DEFiJc9vT3wrZIPTz6BwocHqLVbrP5strPHUXOUaiBa/YJPI5NehjHA2vCOHYOc72w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS0PR11MB7532.namprd11.prod.outlook.com (2603:10b6:8:147::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34; Wed, 12 Apr
 2023 10:09:33 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de%5]) with mapi id 15.20.6277.036; Wed, 12 Apr 2023
 10:09:33 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
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
Subject: RE: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Topic: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Index: AQHZZKiCMJJkpNrujkKpjX0h05Zqwa8cqG8AgAAcMGCAACibgIAAAyuAgAAEPICAAAjLgIAAGeKAgAAG7oCAAAf9gIAAO30AgACaIeCAAJxQgIAHkI0AgAApuICAABWEgIAAGNKAgAA3aoCAACJEAIAApXVA
Date:   Wed, 12 Apr 2023 10:09:32 +0000
Message-ID: <DS0PR11MB7529E75A0868B338F5AFD014C39B9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <ZC3KJUxJa0O0M+9O@nvidia.com>
 <20230405134945.29e967be.alex.williamson@redhat.com>
 <ZC4CwH2ouTfZ9DNN@nvidia.com>
 <DS0PR11MB75292DA91ED15AE94A85EB3DC3919@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230406115347.7af28448.alex.williamson@redhat.com>
 <ZDVfqpOCnImKr//m@nvidia.com>
 <20230411095417.240bac39.alex.williamson@redhat.com>
 <20230411111117.0766ad52.alex.williamson@redhat.com>
 <ZDWph7g0hcbJHU1B@nvidia.com>
 <20230411155827.3489400a.alex.williamson@redhat.com>
 <ZDX0wtcvZuS4uxmG@nvidia.com>
In-Reply-To: <ZDX0wtcvZuS4uxmG@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DS0PR11MB7532:EE_
x-ms-office365-filtering-correlation-id: b2ad503b-1433-4d14-6779-08db3b3e0310
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zs8GTCrom5m1hCAPPHSn70VJlIh/S1bFsz5wg2RUw43+S4DB3n3bxQ70M8Vz8XdILUtDWVEgLC8BOAlEM6+8v4wHBN6aUROBJu9mqNqmmFf6e1BdWyR4pdIlVuCbNen8rfgo14u9WH2oaVQT6ByLXWTmf2zQFGfFNOxI768UO9Xq2zWGSlzxJX/H9Ztp9pKhi6OVLfrgccKGZeowS61ivx6q6C1NvYxQSPEC3Fcp4k7atDDSh2JlH61uMdj3lrp9vK9YBay3vlcRs0K9KuRlQxxoh6+EFpL40DY/Lv1x/6cUhCn03SfcnGKlWvHYe5UWXcSavmF7AY6gJ0peAbfLAZuZn+LEPJjnPfXO7v+4YE5rfvEb33/e07PB705xaTgjmcoP6M8mqBuzZGSPsXr/Ry+BMfQtFikCBNhD5PuTwnLlnELiRNdBi7ZTvJD4W0UD5kpBxCbFWU9QknYwYswg/bK81Znduskt1mMlad6byKWWJt0grODMP5eZYbJvnjlGwZpg/PB9XLZnVLoKpE/8XZvooxFN5RqaOtZGI9nUt2t6B6qQN1UABfSEWWOC59C6TP3PLZcXkQzroOwHqe7cCOPTH84O0cJRywaw8IXXTrfqgoNZYXWefMpn6hZoNdSv
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(39860400002)(346002)(376002)(366004)(451199021)(5660300002)(8676002)(8936002)(110136005)(316002)(7696005)(478600001)(55016003)(86362001)(54906003)(71200400001)(7416002)(33656002)(52536014)(66899021)(2906002)(4326008)(64756008)(66446008)(83380400001)(26005)(76116006)(66946007)(66556008)(122000001)(186003)(38100700002)(66476007)(41300700001)(9686003)(82960400001)(6506007)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HyWYkjySBE5ZqlTDWhbpZW2JNiNN1y8MTp+l/s9EFdUTqX+8eRQz0xJlcE1W?=
 =?us-ascii?Q?tXfHQxf8Im7ceJIgWlkVW+miUl6dgao/+ALZzzpYxS6ic1bLecwounCQRw6u?=
 =?us-ascii?Q?H//KesR8X+A6zMYDVDW5RUdgvC2jQDoVZCr4rO5OgdEiBI/kQXLmao1GOdzo?=
 =?us-ascii?Q?id6nJ+qc5nGJuUpv5REpJKhN7gfA6YGiM6WtWu2EvBEWcFaJh7YLL1ySG6nI?=
 =?us-ascii?Q?7jRbIrpnJgercx8JKhtgERB9O+La77i/NVr+m74gyK6Nzy2fuSH0Zn+to/kU?=
 =?us-ascii?Q?0JScN7WAyW5pOK92/nPcILhCcTrvk+dRchnz5iZmWxn3//YQ8DHVvByK++YJ?=
 =?us-ascii?Q?TabRgPqWfoRVb4+AB48MJy6d9vwRsIq3x8QNFfFEKpvQIq2NTzzEzvS33EHq?=
 =?us-ascii?Q?F4SknLscuPSFCrRoCXqAOaWfS6grn/jY2K9WJm7uL0Wkm3UWYAMn8RX87l66?=
 =?us-ascii?Q?rrT/MMt8HLzpWifxA0qI8hQLmphkGD5T2/Qjff7gMaSU4sQrHH1uGX7is7/q?=
 =?us-ascii?Q?B0eJdS1lR/EVuVqgw2B95E8xywn0tx+BIQ6VFc6EaLf38et4A3CIOr/Yn7u3?=
 =?us-ascii?Q?8tDT1EryfZSY1H1t2JZ+W0Kcj3+QzV+TOFEDScIf60bT6IWwjQH7jno4xZl5?=
 =?us-ascii?Q?4TtFtRnwSpS7MydO9WKcFvI3A0SZm962xgMQxCDxDpe5CBXhuxSP8ErZxFQo?=
 =?us-ascii?Q?SxCIGq4ULEoX0063iwfJPpri8DXRP6VWsVi7O1XYCuPg9ScrscScAwAgaEIs?=
 =?us-ascii?Q?E/4XoPnru/IQA3b8flehdTCL8q+xMmO/x1vO0EDwhtNd+THmAJThAPJQyXB0?=
 =?us-ascii?Q?ZJWEVzQ328RX+mc9APiZLgSrNondqbq1N89Z1+r3x3HzAnnEO+sH/jz6hgDt?=
 =?us-ascii?Q?xzL3zPR0vlRWCKJrOQBv+K6uGOf6ZEenBEbmQFdZ/PQt9InmLw4qcpskUPTR?=
 =?us-ascii?Q?oTjwihgRA2M6IUL4jMynpjHsJt3IlondcrSM6VoX4ZrYl1CP/Qt2FirKeKTJ?=
 =?us-ascii?Q?Igumt4PaCCluwbU2JuU5GZwshnzXQn2tQtHLQ+jt2db5Xsx+no4i4s0fIM/R?=
 =?us-ascii?Q?778fTdki2yiXkekFJ/F8WtnsDcs1hobIj9bU8E0s7jAg0qMcarWjPh6OrvHF?=
 =?us-ascii?Q?QdYJAn6A+ELIN/YRPyDKVEOVxC+6rAZ7Lgzgh175jvmBHIqtGTwFft9e2vK5?=
 =?us-ascii?Q?ujzuedQmntgGHvykQGnD22acDhes23KBG33w0Ut6ll0WbiQ1gedMPAWWXsM4?=
 =?us-ascii?Q?ZgxqUDDdyH+fm8wo6HvIeFz9jBYPljr2FQc5Me9R+a1xxS/ahsPkMzBHbFr9?=
 =?us-ascii?Q?VaEuHZ6IAhgLycPcUrsJgN6aFdiKmoxV3KZ0BSU+SveF+u78DMt+r18AK0Lz?=
 =?us-ascii?Q?eeHFb6UCPlbhnh6KNtSPIbgzcypNy29wbkcVu9BoHag2aEyU5xatoC8AZtEc?=
 =?us-ascii?Q?ihtpyk+i37m2oSYTLLZlwDCBD6j6yMJRK4CmW3So+3Y2ljhfYrlWgtYS2lLm?=
 =?us-ascii?Q?YKcshf0cbhU8Jb1YdeBNYJ0/SQOFNadp98U0QLJDx12agXhz1F9bbXl+IUOW?=
 =?us-ascii?Q?rRJc3EJzWsuGB1QcR8K4dArDfvwtrq4csjCuGzR6?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2ad503b-1433-4d14-6779-08db3b3e0310
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2023 10:09:32.8402
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9x7XvD4KaRh3JTN8wVkY8z0jL2xgr+Zx88Wb0mvpoT1ji/GbVLfEIBdEc0cWr1XZlPSeCcFLSbw4xezlPu21Eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7532
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, April 12, 2023 8:01 AM
>=20
> On Tue, Apr 11, 2023 at 03:58:27PM -0600, Alex Williamson wrote:
>=20
> > > Management tools already need to understand dev_set if they want to
> > > offer reliable reset support to the VMs. Same as today.
> >
> > I don't think that's true. Our primary hot-reset use case is GPUs and
> > subordinate functions, where the isolation and reset scope are often
> > sufficiently similar to make hot-reset possible, regardless whether
> > all the functions are assigned to a VM.  I don't think you'll find any
> > management tools that takes reset scope into account otherwise.
>=20
> When I think of "reliable reset support" I think of the management
> tool offering a checkbox that says "ensure PCI function reset
> availability" and if checked it will not launch the VM without a
> working reset.
>=20
> If the user configures a set of VFIO devices and then hopes they get
> working reset, that is fine, but doesn't require any reporting of
> reset groups, or iommu groups to the management layer to work.
>=20
> > > > As I understand the proposal, QEMU now gets to attempt to
> > > > claim ownership of the dev_set, so it opportunistically extends its
> > > > ownership and may block other users from the affected devices.
> > >
> > > We can decide the policy for the kernel to accept a claim. I suggeste=
d
> > > below "same as today" - it must hold all the groups within the
> > > iommufd_ctx.
> >
> > It must hold all the groups [that the user doesn't know about because
> > it's not a formal part of the cdev API] within the iommufd_ctx?
>=20
> You keep going back to this, but I maintain userspace doesn't
> care. qemu is given a list of VFIO devices to use, all it wants to
> know is if it is allowed to use reset or not. Why should it need to
> know groups and group_ids to get that binary signal out of the kernel?
>=20
> > > The simplest option for no-iommu is to require it to pass in every
> > > device fd to the reset ioctl.
> >
> > Which ironically is exactly how it ends up working today, each no-iommu
> > device has a fake IOMMU group, so every affected device (group) needs
> > to be provided.
>=20
> Sure, that is probably the way forward for no-iommu. Not that anyone
> uses it..
>=20
> The kicker is we don't force the user to generate a de-duplicated list
> of devices FDs, one per group, just because.
>=20
> > > I want to re-focus on the basics of what cdev is supposed to be doing=
,
> > > because several of the idea you suggested seem against this direction=
:
> > >
> > >  - cdev does not have, and cannot rely on vfio_groups. We enforce thi=
s
> > >    by compiling all the vfio_group infrastructure out. iommu_groups
> > >    continue to exist.
> > >
> > >    So converting a cdev to a vfio_group is not an allowed operation.
> >
> > My only statements in this respect were towards the notion that IOMMU
> > groups continue to exist.  I'm well aware of the desire to deprecate
> > and remove vfio groups.
>=20
> Yes
>=20
> > >  - no-iommu should not have iommu_groups. We enforce this by compilin=
g
> > >    out all the no-iommu vfio_group infrastructure.
> >
> > This is not logically inferred from the above if IOMMU groups continue
> > to exist and continue to be a basis for describing DMA ownership as
> > well as "reset groups"
>=20
> It is not ment to flow out of the above, it is a seperate statement. I
> want the iommu_group mechanism to stop being abused outside the iommu
> core code. The only thing that should be creating groups is an
> attached iommu driver operating under ops->device_group().
>=20
> VFIO needed this to support mdev and no-iommu. We already have mdev
> free of iommu_groups, I would like no-iommu to also be free of it too,
> we are very close.
>=20
> That would leave POWER as the only abuser of the
> iommu_group_add_device() API, and it is only doing it because it
> hasn't got a proper iommu driver implementation yet. It turns out
> their abuse is mislocked and maybe racy to boot :(
>=20
> > >  - cdev APIs should ideally not require the user to know the group_id=
,
> > >    we should try hard to design APIs to avoid this.
> >
> > This is a nuance, group_id vs group, where it's been previously
> > discussed that users will need to continue to know the boundaries of a
> > group for the purpose of DMA isolation and potentially IOAS
> > independence should cdev/iommufd choose to tackle those topics.
>=20
> Yes, group_id is a value we have no specific use for and would require
> userspace to keep seperate track of. I'd prefer to rely on dev_id as
> much as possible instead.
>=20
> > What is the actual proposal here?
>=20
> I don't know anymore, you don't seem to like this direction either...
>=20
> > You've said that hot-reset works if the iommufd_ctx has
> > representation from each affected group, the INFO ioctl remains as
> > it is, which suggests that it's reporting group ID and BDF, yet only
> > sysfs tells the user the relation between a vfio cdev and a group
> > and we're trying to enable a pass-by-fd model for cdev where the
> > user has no reference to a sysfs node for the device.  Show me how
> > these pieces fit together.
>=20
> I prefer the version where INFO2 returns the dev_id, but info can work
> if we do the BDF cap like you suggested to Yi
>=20
> > OTOH, if we say IOMMU groups continue to exist [agreed], every vfio
> > device has an IOMMU group
>=20
> I don't desire every VFIO device to have an iommu_group. I want VFIO
> devices with real IOMMU drivers to have an iommu_group. mdev and
> no-iommu should not. I don't want to add them back into the design
> just so INFO has a value to return.
>=20
> I'd rather give no-iommu a dummy dev_id in iommufdctx then give it an
> iommu_group...
>=20
> I see this problem as a few basic requirements from a qemu-like
> application:
>=20
>  1) Does the configuration I was given support reset right now?
>  2) Will the configuration I was given support reset for the duration
>     of my execution?
>  3) What groups of the devices I already have open does the reset
>     effect?
>  4) For debugging, report to the user the full list of devices in the
>     reset group, in a way that relates back to sysfs.
>  5) Away to trigger a reset on a group of devices
>=20
> #1/#2 is the API I suggested here. Ask the kernel if the current
> configuration works, and ask it to keep it working.
>=20
> #3 is either INFO and a CAP for BDF or INFO2 reporting dev_id
>=20
> #4 is either INFO and print the BDFs or INFO2 reporting the struct
> vfio_device IDR # (eg /sys/class/vfio/vfioXXX/).

I hope we can have a clear statement on the _INFO or INFO2 usage.
Today, per QEMU's implementation, the output of _INFO is used to:

1) do a self-check to see if all the affected groups are opened by the
    current user before it can invoke hot-reset.
2) figure out the devices that are already opened by the user. QEMU
    needs to save the state of such devices as the device may already
    been in use. If so, its state should be saved and restored prior/post
    the hot-reset.

Seems like we are relaxing the self-check as it may be done by locking
the reset group. is it?

> #5 is adjusting the FD list in existing RESET ioctl. Remove the need
> for userspace to specify a minimal exact list of FDs means userspace
> doesn't need the information to figure out what that list actually
> is. Pass a 0 length list and use iommufdctx.

If the reset group is locked, seems no need to check iommufdctx.

Thanks,
Yi Liu

