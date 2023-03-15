Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B70636BA878
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 07:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbjCOGxG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 02:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbjCOGxE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 02:53:04 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 533DA664FB;
        Tue, 14 Mar 2023 23:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678863157; x=1710399157;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=o7GDuCcvWrD1ye8LraIcmxWMjdWDxE+gS1FLNLx1fIE=;
  b=mPlYP1SJlqF8Uz3JPpgxux6ZzuRYXmp79tpX+1151FK39eTXgHS/tD91
   Egb5nl/9CpAw4CIx3oFwpp8rdq6yWuEVFHGSPPvNve4Nw6A4YP2c8+5yS
   39ITNNgE52s8UuJ+tp5iU15lZrrMrt0zAspnQbpx9FlcsUAhnxVIp5AS+
   VFIgVAtx+Cy+t/eGAWegqBOGmLFGQ5sHzvAgZo1ViXvJS08bxt6UNPsvV
   z9616CeH1BW7JmEVAQfMEmhy34Kb3dLO7tm6VSJPPyomez+bGsT2KpX+g
   v7OxqaRbh1PU1eeMXh1urkdjeL/e0q1FvfxSItr9X2Zvpl1+TDy/Tu4Xy
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="335113779"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="335113779"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 23:51:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="1008716985"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="1008716985"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 14 Mar 2023 23:51:06 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 23:51:06 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 23:51:06 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 23:51:06 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 14 Mar 2023 23:51:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=is/oy0hNrAmtkmPkqHPnobRCaZcuqhPtkgL9rNTo8wCz8TZUyryzXTJcrjY5bNl67o3+58QtIyVOhEkd0HFBArCLECjjOBHPPAq4De/ynz2L4yvsY1L/anRsQdEhT2U6GamTn05MY5EtozAbOS9wDRBfynURWotOLpvRgJyHRB8xZ/u2kG9jlniYfTojJUlEipQl+VGE/vxShCH2fn7XGTiOuPT9Bo7GZK6Mddzph54EcIOMceU9vjrBlUq5PUpdPa4b57Jw8eACydMapNdk0hvNSl5yX0Vns3I8iaRt0CrS6QNr6N0lqqLeJoHcTelmPk7mKykgaVmfiHFmXwsQPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o7GDuCcvWrD1ye8LraIcmxWMjdWDxE+gS1FLNLx1fIE=;
 b=EGX2Ik4BZqGsdk0g/o/Cyc1cgOu0QzslimWCwVlQXZpvJIrPHJ1XpWZka6/fFNh2WnmUMwWpf4yUp8bCB8czK19OzDs3a8DZfM2Xej06LlE+bySueKcANWAV+xJwpndQGejvLP/Mk+74C6Wb1EgvM75KTsg3BErfT/hVW2dvTrt1g8LFY0D7c1X1hF973NXQqukZyJrL2xGe2W+W+3KI6KI9wbXQk9DE1snE/Ca387OO+/tgu96AYI/w/auIvG22frNIsVRDSjRCZixkyD2bfeV5lPQcSLD/HRqeWQe0wMe/hUFJNS//xmGHxp4J7GZQA1ilLLP4DV5HJDf13y6dIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CO1PR11MB5138.namprd11.prod.outlook.com (2603:10b6:303:94::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Wed, 15 Mar
 2023 06:50:53 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%9]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 06:50:53 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Nicolin Chen <nicolinc@nvidia.com>
CC:     "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RE: [PATCH v1 1/5] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Thread-Topic: [PATCH v1 1/5] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Thread-Index: AQHZUb/VKrDPi02EE0KOkFVtC1WCVq70SikAgAWuFwCAAReSgIAAVgYwgAAGiICAAAEI4A==
Date:   Wed, 15 Mar 2023 06:50:53 +0000
Message-ID: <BN9PR11MB52765D7977F987960072482E8CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230308131340.459224-1-yi.l.liu@intel.com>
 <20230308131340.459224-2-yi.l.liu@intel.com> <ZAtqlnCk7uccR5E7@nvidia.com>
 <ZBAuXo166M+z8b3z@Asurada-Nvidia> <ZBEY49XtiFUImfe4@Asurada-Nvidia>
 <BN9PR11MB5276738DC59AC1B4A66AB3C38CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBFmh2iAqGGb8CjK@Asurada-Nvidia>
In-Reply-To: <ZBFmh2iAqGGb8CjK@Asurada-Nvidia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CO1PR11MB5138:EE_
x-ms-office365-filtering-correlation-id: 425334b1-d7b8-4d67-505d-08db25219f06
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TZ6Sfd6WHca3bY/ZSjzIYOSt1uoZjzQlywi1QHLE+XsZfE4RzaBqyeo7RXnXDUD3/0tZURl3T4cegx3GYDNyXtA9VOWF0ojOvRW8zaNo1pPGBzV/vKwxzcNPK/4ENuxGWKLHZRIH8ndYwPMKOJQQjWyrzwsujbuPBy5v6wB2vhTW+mViTQuAsKtJVJBHX11PW6cbMNEHgMqXiOAFjoHNb1XgnnG4+tGRj2rKqY70y0O5b4oEDxXF/tSThwki9T4lyVWX6/CwEb32FjNCZWAA9zXLNdnlqvGRw0k7fp1MsPegAurrm2LWTVxb1QYwnB6YVFaUVaud+UNh5Xbe0GsEqxUTVlb06uO7IioNBzdTEPkQXqzw4s8bAwm0sLB6qXL3HMRflvAGzFLN9GzhG+fcxoGETpYSOJpSjS76xJ9w67y07ZyCTv2yHB/5PbhUO200uFX+xd1JAp0uLFE5xIpgjSt3HyzmpNCEzWxGiWj05e9+2MIPc4xi3Jl5J8cLc8Le8lzwnUrIbRR1mMRfuq1xlJw3XwF0AKMQ4Esz6J8J/RyXS/hhoFAOq3wRUunHt973WqWPApTYK5wiNAg5L2J1+mge/Vvl1mx2nNOAZX2ZnaIJbLkl3DfKGPGiQxM4/lOPRzqgidoyRwsjOu6cxdmNep4RHEn2UV8mH9RAJxm3XgbmWtm3cEbTN+1gJrlGWbNDH7wnsaf4vwJGSJZYMdcCTg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(346002)(136003)(39860400002)(396003)(376002)(451199018)(41300700001)(478600001)(7416002)(52536014)(8936002)(5660300002)(2906002)(38100700002)(86362001)(38070700005)(33656002)(122000001)(82960400001)(7696005)(66946007)(8676002)(66556008)(71200400001)(66446008)(76116006)(64756008)(66476007)(6916009)(55016003)(4326008)(54906003)(26005)(83380400001)(316002)(9686003)(186003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MKfR3n9swbAdY9bemvhi5lOGa+l4pPzN98w+YAnX/2wq6I7cfki/k6hhcNQf?=
 =?us-ascii?Q?VmrJ6u0n5vN5JWVWd3IuXN+gncK4y+2+u6UsuA1bCHXVwzKkOiUs6aCMovOS?=
 =?us-ascii?Q?dSA5AhM879gMnhLmIFhfOAviCSMPe+LSmvmVMxmjxcWP5/1+qv+PzRKPrDkL?=
 =?us-ascii?Q?YaiHQ8UKAq5OLMmB0uonOwTZgEJtnuz/Xun4AltOK52BfNwhpgnsZwA/N/Jj?=
 =?us-ascii?Q?H+N6Gdb8n2szf8bx3XZkwMzLVx9ZIngaQolSseiiBs0jzVTadn1W/T9bj1c9?=
 =?us-ascii?Q?G7ori/MVUoPpuW2r+X4V+2iIPfpmOEzZWZT+0fv2AVIeHaqH0WXolDPv0V6i?=
 =?us-ascii?Q?rB5mTNI2dVBifYZCB3n8njUv8ai7qHAhTpeGSuk/97ckErtHnkZbutbpD6wI?=
 =?us-ascii?Q?B0uAUTIOW3G6UNiooKFKWP9/4Boe+YoP57OIob+fgNaYafNR/4aGLvTaDGoP?=
 =?us-ascii?Q?j2UI5NICqJXvOEghnp7UtcHwhyr5vCso3jitgcCtlHFOEDUaeJcT9FcQjMGd?=
 =?us-ascii?Q?rX0VaC2fiqYfw88VnMSxOvWKL6zgDM4RLuNGzmglWWAf+NBrwzeMO0Yfbg61?=
 =?us-ascii?Q?TcpshENdfPLdE1UKoiHDZoQb4hNu9bqA2qgIuFB5wrQE1pq5WTDOWt1AMQr9?=
 =?us-ascii?Q?kLh/kGymsPTnsyAPYT1sqehOGTWNtzTq0cC96LSi5vVInddH7RIUdIQnO+Zs?=
 =?us-ascii?Q?/tpNU0Pz5RmlLU78eiBr79UgfF4KpUQqRSTP0jT14O7T0/PgdcgsVjNB8TsU?=
 =?us-ascii?Q?dcXuI0HUodReNmgxzCO+jbHoVedi1ZrCvEi1m6TCOpLI4KbUkr4K28la1uSl?=
 =?us-ascii?Q?GhNk14AqEckNp55EQhSmbkHLhM+87Mk+t+AIqjNrr+gVVngI5Vrl6eo2zfuq?=
 =?us-ascii?Q?ibcdl4jPLZgPtbcyRMSx1StBK7FS5NPAPcrkRgH2pj0maIdAQx1271G7hOEm?=
 =?us-ascii?Q?kzN9Ay3d4FEiVXSPFgu5LWYoWXxiUa7OhBSWOTEzbT/FoF/3jotkgF0IeaUD?=
 =?us-ascii?Q?VZiCViOTBuLy1t59JL7O7KaIkwhn/2PPDVGxbsGbVG6tJJPowRiHe/7hHCFq?=
 =?us-ascii?Q?7dAZIPNCDil4nEv27Nj6g5/t2NEeIRJR/IxsIHXKSlg0DI7v1iQtwnvCeCQz?=
 =?us-ascii?Q?eUrQYOmmlzZRuFkjg7iASeqUsAT+jnMutx4Tjx/iejWraQjX3fTd3VrGSYSk?=
 =?us-ascii?Q?XxnfN5LEIs1Q8BuA41VBjFFOFOkT768DR8YhNcFMlkQqXiflsizFUpnnOHiK?=
 =?us-ascii?Q?pbCTqUNRmD/BlNC41M/oXzZ/cLyMISvJscR5SiVlOjgGQoMvIp/gH1FZNmbE?=
 =?us-ascii?Q?zO8fGgqDUePHx73eBu88J38y+ZTBEpf0568TGGSfMBlN7ywsMZSw7KFNbezO?=
 =?us-ascii?Q?lqJGubccmuG+/IW7e5xNjIghTW8n0AmHr9jf4QBK2TNyc9yomptcId9NVPPB?=
 =?us-ascii?Q?Y6ejUwKu6v7u9Ns5/w/PLpyT1rK+PjH0rnYCMqOCS462Phhin4mjbS9W5IfE?=
 =?us-ascii?Q?KuVp7DauUcgeTBTf8Q9JvJFDuYdJ5cz9P4k/+wsYPk1XhMbKcTHm7Uuugb+w?=
 =?us-ascii?Q?mQAYih1FNa4bKWpldiYn4GbTJPt7rmAxXmvDFiVs?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 425334b1-d7b8-4d67-505d-08db25219f06
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 06:50:53.5040
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0/feCRYvt37VMqy21duAmMWwhujX0OtX+ZHXtLsxZclr1GCwKbPjP0A4udo9AA8ttu5vH7tFyEpvPEdEgGRPRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5138
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Nicolin Chen
> Sent: Wednesday, March 15, 2023 2:33 PM
>=20
> On Wed, Mar 15, 2023 at 06:15:23AM +0000, Tian, Kevin wrote:
> > External email: Use caution opening links or attachments
> >
> >
> > > From: Nicolin Chen <nicolinc@nvidia.com>
> > > Sent: Wednesday, March 15, 2023 9:01 AM
> > >
> > > Hi Jason/Kevin,
> > >
> > > >
> > > > Perhaps we can have iommufd_access_attach/detach in this series
> > > > along with a vfio_iommufd_emulated_detach_ioas, and the locking
> > > > will come with another patch in replace series?
> > >
> > > I recall that we previously concluded that the unbind() is safe
> > > to go without doing access->ops->unmap, because close_device()
> > > would be called prior to the unbind().
> > >
> > > But, to add the vfio_iommufd_emulated_detach_ioas() in the cdev
> > > series, we'd need the access->ops->unmap call, and the locking
> > > and "ioas_unpin" too in the detach and attach APIs, right?
> >
> > yes. We need locking since detach can happen any time with
> > cdev while driver is conducting pinning.
>=20
> So, this preparatory series will add a pair of simple attach()
> and detach() APIs. Then the cdev series will add the locking
> and the ioas_unpin stuff as a rework of the detach() API.
>=20
> > > I tried a bit of some update, across this series, cdev series,
> > > and the replace series. Though we might be able to simplify a
> > > bit of this patch/series, yet it doesn't seem to simplify the
> > > changes overall, particularly in the following cdev series for
> > > having an unmap() call and the locking.
> > >
> > > Then the replace API would mostly overlap with the attach API,
> > > by only having an additional detach(), which means actually we
> > > only need an iommufd_access_attach API to cover both cases...
> >
> > there is a subtle difference. to match the physical path:
> >
> > for attach we expect the existing access->ioas is either NULL or
> > same as the new ioas.
> >
> > for replace access->ioas must exist.
> >
> > they need different condition checks.
>=20
> I think they can be something mingled... the sample code that
> I sent previously could take care of those conditions. But, I
> am also thinking a bit that maybe attach() does not need the
> locking? I can do a separate replace() function in this case.
>=20

w/o locking then you need smp_store_release() and its pair.

anyway it's not in perf critical path. Keeping lock for attach
is simpler and safe.

