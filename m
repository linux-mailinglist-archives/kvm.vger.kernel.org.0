Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 445295ADE10
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 05:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbiIFDf4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 23:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiIFDfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 23:35:53 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D724749B42
        for <kvm@vger.kernel.org>; Mon,  5 Sep 2022 20:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662435351; x=1693971351;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Xc9VigR1jG4kgYBFw58s7I1h3Lm82PVzAFt2cufipvE=;
  b=ddZb0C7xQdmWi37xLw+5wHDjp2NH180GZx7l8MnjgeUAnaE+aWpxtMJ2
   8kvLXKa3S+eGVAwJYYBzSRDr9BjjCBR2NiwHfc+sE4UHy/Yh4V9ffRumE
   4d+F/7ZK9UzQB1Mh91NclKu+A7n0GDlqcCItzHEzlF2S+OVvItYqya6rg
   yrDSKsfio8o+TECEzv5TrGkhqVn/ORP8vNMI5Dq9T4EvXKkyD1Rjxkrt4
   MAscc2ffstuPtYZq5KRG8Fws9E/ZxuJfXIhU/LNuWlS5g8QQ44TMgm39v
   P+9GQbl4gGXMZl/D85TMeQcGuaeYiRU9qbruDHs2hCiOBYM1uFUHiWitT
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10461"; a="283488826"
X-IronPort-AV: E=Sophos;i="5.93,293,1654585200"; 
   d="scan'208";a="283488826"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2022 20:35:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,293,1654585200"; 
   d="scan'208";a="564943000"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 05 Sep 2022 20:35:51 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 5 Sep 2022 20:35:50 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 5 Sep 2022 20:35:50 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 5 Sep 2022 20:35:50 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 5 Sep 2022 20:35:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L5KiVlaUr0J8nmR78BSBjc4vCyhYVdPN714X1ikJaE0iUwdBWqB+U2DsXBtkToHHv7x+r60jlKfckv+jdsP5rOIQEQEooak6I96m7hrajPspiokTVZdVk7xHc/Y/f6AfZ00f4uLR7djEjx8reAuEmHg5YNAtfCpa44Q9RCEwRaTvOqSAS9NEvJY1H4t/M2LlAUqE8uwTN/QNgBrnIUBGccqZ6wrNHxkybnsguef/WbTiZtrg6oa3WBHZVqe1/EqZ4JaLTSPvNEfQWvH4eLX5OC3S3NYN8+6Hg5P3t57ehTLSYc4K0BzCyIzdPB0pLP0L5bBwahGlbWpD+XH1wAtUzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VTDAkWe0+YbNDKEJe72HGUVWKMvPMuqsT69p1TWBIUU=;
 b=W3sW8FFY+g/I0NmDN5QXR7Cies2LY8KQeAdRMG5D973vow1Ts3dO9F9E2THeu3twsoSJZJkG6HlMw455WJKHsL+kFCT4nJ3QoX+yy7BSo1M01NCmqaM5Ui2iF5i9fUYycErOZ8AtB89PWL7AvBxVl9jgF8apd/WOx029IIgz5zL8Ym+p1ghw7JEGc+P7dhLRwB4pu9py1HmqNPbWwmAhXJ5mfhvLAwskYd3vXRHbk8zOmwYkm0iCywRexEsAzLpXLV2zCR6T3nXgTGrdtTbNhcJKP2/XsA9L6jywbV/txRzRpgaseNUsgLXKzPBzfLQ2SoKuJOy6JgKVviS2Arzl8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA0PR11MB4735.namprd11.prod.outlook.com (2603:10b6:806:92::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Tue, 6 Sep
 2022 03:35:49 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7%5]) with mapi id 15.20.5588.018; Tue, 6 Sep 2022
 03:35:49 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 2/8] vfio: Rename __vfio_group_unset_container()
Thread-Topic: [PATCH 2/8] vfio: Rename __vfio_group_unset_container()
Thread-Index: AQHYvNVSThnzW9KUGEadAxVOclcPZK3IsYPwgAKavoCAADaQcIAAtycAgAAdYgCABW63gA==
Date:   Tue, 6 Sep 2022 03:35:48 +0000
Message-ID: <BN9PR11MB5276FCB0DCB4E741CCCD48318C7E9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
 <2-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
 <BN9PR11MB52767A4CCD5C7B0E70F0BA2C8C789@BN9PR11MB5276.namprd11.prod.outlook.com>
 <YxFOPUaab8DZH9v8@nvidia.com>
 <BN9PR11MB5276122C4CBAACB295DD15E78C7A9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220902083934.7e6f6438.alex.williamson@redhat.com>
 <YxIuTF0qfy8c3cDj@nvidia.com>
In-Reply-To: <YxIuTF0qfy8c3cDj@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e4fa2975-d4b9-41d7-f29e-08da8fb8e417
x-ms-traffictypediagnostic: SA0PR11MB4735:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rBmkEc1H3rAOJS+co3IOS1P+DuSZhamwuoZgWyBywAz+laxb28MhL5S282WwF1AeeLFcFEMLMCDKPdGywViQ7rABC4bH65Z9CNSdNYHb+HRfJau9N+8VjTwArUqYykc82q1Z1cvIHFJvnJw+eWurDR6tCFR06jc7K4A6//RbjZ7b2jUoH3IIrVys3GD4F10SAbSgzRspMugK7Agi7gAqOsJgK1hOpwUZdy9qy7D0zGR6TsiDv/BuVs5aFtKv+IbmuCKoChq7NKc+/Hs7SvLWMfQ6WzmOJAl6MoY2DY4zk7JEc3QF6Zypf7UUNVpv/qwoQ9O5CZcodaqqXsN76JSWAjrP3fnkWk1ANyEBtzZAlsK8u0CB1zTrc19X/QRqMBPEGbk7duVaBpeqe4dbxq6eWPTfu26+cRN7LlOpeEqJBMHzECa+F5XhIaveIKHwEzKsKwDPbIPFYP6XPOThJJJ7FvyAVz0QPq0Ny5Kp2HfAiYZ0Xe3fKix6wmvRRToUWtUZH+hAEVOE3p6y3UckGuQj7QaXBj1eZfBm+HrZW7XvVOahWhxYkCzk5kPpbTPtlxjRP90GY9mH1lzlRKMxO+Y6uAIy/bRxm7IIiiySAifNH7TictPYD0TYJstZSkgU0YuFcyWTADfkX4n5L5+wfpTycsq72xEpnjtwFfBVlX7H0eH7cjLWiBnpEBdPEr/230/4ci6vWqsV6QzKMJMx4Far1Yanq1CqxbbRGMCJ59VPE3EyflyeLw1AXboQHJ9/LZCwYF/TThK1J/wB/4azRmOELWXgkX0OXBvqAfaAWuCd4Q8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(376002)(39860400002)(346002)(136003)(6506007)(26005)(7696005)(9686003)(71200400001)(41300700001)(478600001)(83380400001)(2906002)(5660300002)(52536014)(8936002)(55016003)(110136005)(54906003)(186003)(66556008)(66476007)(66446008)(64756008)(66946007)(4326008)(76116006)(8676002)(122000001)(86362001)(38100700002)(38070700005)(82960400001)(33656002)(316002)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gS/XdR2VY2wj9P+v22IFg8NbVlM5dev8KlpsgEkO8gmK+tUPsx+SaqN/nGEd?=
 =?us-ascii?Q?1Fx64dOxD1EjxMSPiFyiONs9fkq3glWZBSMmTuGcrgGe0WTgQGdpZd4x9ZNP?=
 =?us-ascii?Q?C2uHlUGvedSvgiOljAg6zNAy5CKCwMB40Vy/urPpKNoDi3xYUeQsSiSxjOTE?=
 =?us-ascii?Q?0ehvNP05TpEBFQ2vEtURX5H6DpaElfcgovQLpcykWK8LddDxclL0y/GKxkJi?=
 =?us-ascii?Q?wO9JSDyX79utN/uSHaTvYfxVsO8iGniNnwdl0TLAfLl+fZL/i1wXuMsRweKm?=
 =?us-ascii?Q?1sn+FTQCtUd0tPPwjaB5mToRT4+7+ZaE6WNowTeiaotlrVrscZPfdk+/dEh4?=
 =?us-ascii?Q?4pm12vSgjz1TXmfViekHPBPo+/Lf8zjrTDy8B7ZvyfFpm7CpmqoirEAtYX7T?=
 =?us-ascii?Q?kKog63i5DgDI4CGnHvPbdleFDVIPyqTjyApvg4x5EzK2WXqTDmxGuLTUIml1?=
 =?us-ascii?Q?5+L0kxBocIsVHMsi/N3RlH05vHEeRI//ABMJDPSSZ2DuVsm+olChrxc7ZTpk?=
 =?us-ascii?Q?O6PHBxo/4x50htZRVb/kZFvUQSarg4W0xcPlax1SzpTvHrb8BgHwgczW74eU?=
 =?us-ascii?Q?FklGcjxKJ5TZS3Ypr+rrwPUoPFTO+DJqS2j/GPBTQlHWS24C0RfwYHV+Ichf?=
 =?us-ascii?Q?ZnND27zBrSHE0IlGl2TEh17XtrvJScsqNm+T9vRAIruQ5oiytoecsWG79r2p?=
 =?us-ascii?Q?odoROoGRUYFZknLrN8ZQxXw9VKoQxH/V9zrbfpjNEnyK01KVXGW4Xv5N6jzu?=
 =?us-ascii?Q?so9yDCgzKeTUaaZgudePDXxh4u0m/4DogWMIkPL4Ww8JlokAL3ZFtSvy7jLb?=
 =?us-ascii?Q?PFfagdpYkZQRTzhtDrtwOd34/Uv3nSVIEIKSKIJmG5YqV5aSyICQNSDQvOt+?=
 =?us-ascii?Q?6sRYV9ck+ylxUMYIDnfwNtBFQYn2X0FPfiA4E2oW4EMTaXExoxpvdSuchpbv?=
 =?us-ascii?Q?MIdIlXua30banDXKunASdKfuPtvCb+5Tsm0n2oxLp0X8CO0AQzFdaX6wm53c?=
 =?us-ascii?Q?76ePn1DpHRIWz6vqJTpQQ5f2IlIyrEcepkSvYM3/nVMyvsYRyppR8dGsYzv9?=
 =?us-ascii?Q?g67GjKFttFbQIwb/xMYVwtK1rO2Ufddmmq6/YR2TkvZCmg3ZCer74Vat7FOS?=
 =?us-ascii?Q?QhhwTfSMNbo2sQ5sn6TwioHOo5lY+Ly+dR5gHOYKsZX3MgjxI9f/fT9PPMDP?=
 =?us-ascii?Q?nvpbbdeyxACgHQn39j3Q2rKYaqQNe9nWr4VR/+jezHh876JjD3JG0mka70ep?=
 =?us-ascii?Q?waKhvVYYj4oFt+qQbTNu5mJ0D+MrgJ+vcF/CthmNwqWfwtfsIcd2e4wcDT3y?=
 =?us-ascii?Q?odHrE8qIFlxQL4lfXHc/8pbOZbMWsnS8bEBNUZ8oos/o0Px5qV17z1CZWqNo?=
 =?us-ascii?Q?eycy6mhkITLULhM+WKKdnapeH2IaB9tYKGMI6ijtGO5fk2fjv4iudJ4j8XzJ?=
 =?us-ascii?Q?pVm71g13ls/gyuOFLj/oSTXfNJBPJ2LnJtqyaISsNwOMjYnWGgdTnPNycDwG?=
 =?us-ascii?Q?i0+rjaQdpShxy8k0x7eZiWSyGIGUG9u5vg7WiBWXhYUhbbEkgpnzhVfsAkiI?=
 =?us-ascii?Q?FhFtUCpAqbhkwcBHWJsyxcgNqPT4zrRSBMlueVsV?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4fa2975-d4b9-41d7-f29e-08da8fb8e417
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2022 03:35:48.9562
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4fM/jXuipqk4hAOMlkghQrvDiS2kIWidlIYrYvqKIeSae7cdevPt7IN8ebYQYOSzwXCGaTARJPLaEZP01e1yQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4735
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, September 3, 2022 12:25 AM
>=20
> On Fri, Sep 02, 2022 at 08:39:34AM -0600, Alex Williamson wrote:
> > On Fri, 2 Sep 2022 03:51:01 +0000
> > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> >
> > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > Sent: Friday, September 2, 2022 8:29 AM
> > > >
> > > > On Wed, Aug 31, 2022 at 08:46:30AM +0000, Tian, Kevin wrote:
> > > > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > > > Sent: Wednesday, August 31, 2022 9:02 AM
> > > > > >
> > > > > > To vfio_container_detatch_group(). This function is really a
> container
> > > > > > function.
> > > > > >
> > > > > > Fold the WARN_ON() into it as a precondition assertion.
> > > > > >
> > > > > > A following patch will move the vfio_container functions to the=
ir
> own .c
> > > > > > file.
> > > > > >
> > > > > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > > > > ---
> > > > > >  drivers/vfio/vfio_main.c | 11 +++++------
> > > > > >  1 file changed, 5 insertions(+), 6 deletions(-)
> > > > > >
> > > > > > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.=
c
> > > > > > index bfa6119ba47337..e145c87f208f3a 100644
> > > > > > --- a/drivers/vfio/vfio_main.c
> > > > > > +++ b/drivers/vfio/vfio_main.c
> > > > > > @@ -928,12 +928,13 @@ static const struct file_operations
> vfio_fops =3D {
> > > > > >  /*
> > > > > >   * VFIO Group fd, /dev/vfio/$GROUP
> > > > > >   */
> > > > > > -static void __vfio_group_unset_container(struct vfio_group *gr=
oup)
> > > > > > +static void vfio_container_detatch_group(struct vfio_group *gr=
oup)
> > > > >
> > > > > s/detatch/detach/
> > > >
> > > > Oops
> > > >
> > > > > Given it's a vfio_container function is it better to have a conta=
iner
> pointer
> > > > > as the first parameter, i.e.:
> > > > >
> > > > > static void vfio_container_detatch_group(struct vfio_container
> *container,
> > > > > 		struct vfio_group *group)
> > > >
> > > > Ah, I'm not so sure, it seems weird to make the caller do
> > > > group->container then pass the group in as well.
> > > >
> > > > This call assumes the container is the container of the group, it
> > > > doesn't work in situations where that isn't true.
> > >
> > > Yes, this is a valid interpretation on doing this way.
> > >
> > > Other places e.g. iommu_detach_group(domain, group) go the other way
> > > even if internally domain is not used at all. I kind of leave that pa=
ttern
> > > in mind thus raised this comment. But not a strong opinion.
> > >
> > > >
> > > > It is kind of weird layering in a way, arguably we should have the
> > > > current group stored in the container if we want things to work tha=
t
> > > > way, but that is a big change and not that wortwhile I think.
> > > >
> > > > Patch 7 is pretty much the same, it doesn't work right unless the
> > > > container and device are already matched
> > > >
> > >
> > > If Alex won't have a different preference and with the typo fixed,
> >
> > I don't get it, if a group is detaching itself from a container, why
> > isn't it vfio_group_detach_container().  Given our naming scheme,
> > vfio_container_detach_group() absolutely implies the args Kevin
> > suggests, even if they're redundant.  vfio_foo_* functions should
> > operate on a a vfio_foo object.
>=20
> Look at the overall picture. This series moves struct vfio_container
> into a .c file and then pulls all of the code that relies on it into
> the c file too.
>=20
> With our current function layout that results in these cut points:
>=20
> struct vfio_container *vfio_container_from_file(struct file *filep);
> int vfio_container_use(struct vfio_group *group);
> void vfio_container_unuse(struct vfio_group *group);
> int vfio_container_attach_group(struct vfio_container *container,
> 				struct vfio_group *group);
> void vfio_container_detach_group(struct vfio_group *group);
> void vfio_container_register_device(struct vfio_device *device);
> void vfio_container_unregister_device(struct vfio_device *device);
> long vfio_container_ioctl_check_extension(struct vfio_container *containe=
r,
> 					  unsigned long arg);
> int vfio_container_pin_pages(struct vfio_device *device, dma_addr_t iova,
> 			     int npage, int prot, struct page **pages);
> void vfio_container_unpin_pages(struct vfio_device *device, dma_addr_t
> iova,
> 				int npage);
> int vfio_container_dma_rw(struct vfio_device *device, dma_addr_t iova,
> 			  void *data, size_t len, bool write);
>=20
> Notice almost none of them use container as a function argument. The
> container is always implied by another object that is linked to the
> container.
>=20
> Yet these are undeniably all container functions because they are only
> necessary when the container code is actually being used. Every one of
> this functions is bypassed if iommmufd is used. I even have a patch
> that just replaces them all with nops if container and type 1 is
> compiled out.
>=20
> So, this presents two possiblities for naming. Either we call
> everything in container.c vfio_container because it is primarily
> related to the container.c *system*, or we label each function
> according to OOP via the first argument type (vfio_XX_YY_container
> perhaps) and still place them in container.c.
>=20
> Keep in mind I have plans to see a group.c and rename vfio_main.c to
> device.c, so having a vfio_group or vfio_device function in
> container.c seems to get confusing.

IMHO I don't see a big difference between two naming options if the
first parameter is kept as group or device object.

>=20
> In other words, I prefer to think of the group of functions above as
> the exported API of the vfio container system (ie container.c) - not in
> terms of an OOP modeling of a vfio_container object.
>=20

After reading above IMHO the OOP modeling wins a bit as far as
readability is concerned. Probably just my personal preference
but having most vfio_maintaier_xxx() helpers w/o explicitly providing
a vfio_maintainer object does affect my reading of related code.

At least vfio_XX_YY_container makes me feel better if we want to
avoid duplicating a vfio_maintainer object, e.g.:

struct vfio_container *vfio_container_from_file(struct file *filep);
int vfio_group_use_container(struct vfio_group *group);
void vfio_group_unuse_container(struct vfio_group *group);
int vfio_group_attach_container(struct vfio_group *group,
				vfio_container *container);
void vfio_group_detach_container(struct vfio_group *group);
void vfio_device_register_container(struct vfio_device *device);
void vfio_device_unregister_container(struct vfio_device *device);
long vfio_container_ioctl_check_extension(struct vfio_container *container,
					  unsigned long arg);
int vfio_pin_pages_container(struct vfio_device *device, dma_addr_t iova,
			     int npage, int prot, struct page **pages);
void vfio_unpin_pages_container(struct vfio_device *device, dma_addr_t
iova,
				int npage);
int vfio_dma_rw_container(struct vfio_device *device, dma_addr_t iova,
			  void *data, size_t len, bool write);

They are all container related. So although the first parameter is not
container we put them in container.c as the last word in the function
name is container.

Thanks
Kevin
