Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF7305A40DE
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 04:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiH2CCQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Aug 2022 22:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiH2CCP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Aug 2022 22:02:15 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA48714D20
        for <kvm@vger.kernel.org>; Sun, 28 Aug 2022 19:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661738534; x=1693274534;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ua4o6LfRV45ePHhX+3Pg/cc0xuhJOJOyd0zq5GExaAs=;
  b=SyYKd1vWL6MLpB46bkkyqROVAMt53RfUQYdE1EoWwtXxyvoTnUZn3cEW
   DFcR0zmn5NCFjWRGTMfENrb/cXx/aKoC5SsQ+yArLx+PnewDYz5lVLvij
   wC6DF8Sv082MY9ZLzOlSKgdqNwMrS7Ozmta7WCrCuoa6AcBAb3q3kjNPE
   LnQ8DohnB0JHOF3bqzn4WMLKqiRw+p2S5keVwU2uSqOxIPKnKqrUKJx3d
   kzx+xCRdh1F4n54WF8t2vl+osYGx4sj3o0BuUT3AUuXCw99Of9b4ANdQg
   20LdlBkXkV2KX8zwznQWvKx4/8f7amOLaxpuX/H7jkY/A3H/rJddObURH
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10453"; a="293533117"
X-IronPort-AV: E=Sophos;i="5.93,271,1654585200"; 
   d="scan'208";a="293533117"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2022 19:02:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,271,1654585200"; 
   d="scan'208";a="714686326"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 28 Aug 2022 19:02:14 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 28 Aug 2022 19:02:14 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 28 Aug 2022 19:02:13 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 28 Aug 2022 19:02:13 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.48) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sun, 28 Aug 2022 19:02:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LP4J24FgWRlhc2A5nbaMTTpLSqRG+TKP9XMm3YES9zXgGrpLY5d690Si2U1TGLSnJOdTA1jInGggCoUG6cuigfTtNp7RkrykbK/6hgcUO3J4TnrSY5bDWKjBzsg87VT93eQdSiCHRr+uODMwpZj0Pw9H2v6E5DuyWBKBSk5+DtUjzMD52mEyZbdR2Yk/P53J9yHNnjX9aCEOUTuJotoPezTlNh9fboiSi5ATqtck/CFGH4zEIMZ7ivbpKTd1ok3Qt8vYB7BYsbHd9KPa6PjTG9BLWwHYO1RyE3eT0hj+yy7u/3On1vV6RdCxTdVdUnoUV1yUj/objs+VMdVraS6PVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YbmczKqh8dngQ9SoyX0tvaL5RZ5ZKBnMvcToRKaQ+yg=;
 b=EGCwpEIORsLHuhjy9CjrJ8FHvJU+6FkeL1JC2JqP1V/a+kZacd9jFeUS9noa9DLlre3RugQ6kqvKziN0CPxfXAdCoiqXFF9f0pjtzr8dh2/3dEJ7Obr/y819M/+ij1SgPXMDorKG1vPtc08/lUajhAKi6tW6NN2+mKn2uFasYcH/0V40oqowe6jSafQBHmEi/3OlG/iANPegddhGZOqJvq7/DJNj9TrS4Y1Cmg6x+yWZcPpc1dpQmE5CIzZX+fdcjbRx4leWlKCV/81vgFljBLcymQMc0JwgnQpf3FdEUE81DZ60FwdRSlC9kTtmTtLXDD8ZCRDmTtXDmcJqqQiP1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB5996.namprd11.prod.outlook.com (2603:10b6:8:5f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Mon, 29 Aug
 2022 02:02:11 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3432:5d61:f039:aae6]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3432:5d61:f039:aae6%4]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 02:02:11 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH v2] vfio: Remove vfio_group dev_counter
Thread-Topic: [PATCH v2] vfio: Remove vfio_group dev_counter
Thread-Index: AQHYsaRGGwFgE99eLU+zfxszxAHdM626W62AgADs9gCAAG4C4IABiaIAgAfjHKA=
Date:   Mon, 29 Aug 2022 02:02:11 +0000
Message-ID: <BN9PR11MB5276F94844CFD7C1B10E46748C769@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-d4374a7bf0c9+c4-vfio_dev_counter_jgg@nvidia.com>
 <BN9PR11MB5276281FEDA2BC42DF67885E8C719@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220822123532.49dd0e0e.alex.williamson@redhat.com>
 <BN9PR11MB5276323D5F9515E42CDBCDBD8C709@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220824003808.GE4090@nvidia.com>
In-Reply-To: <20220824003808.GE4090@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cea9ef7c-5d54-45b6-2996-08da89627c7a
x-ms-traffictypediagnostic: DM4PR11MB5996:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S22C4RUqksbiyW3BjpIxyMy5Yz9hR7gAPXqk3oebLvA8o+85g4PHCWJnW9qCb0B+nJn+5R5jXaCP3RyHybPwYroeR+VWTxsAHomZ9/alEC9ntss+t61S6fQ7aP38qRBkpmeZlBh+0dEXcL3wK7J/frPYVnFIMhzSVHH18DDXctHmWuKixZBcVhLJxaXN1zGpJYOaxs4teXlOeW2PL29M/5yj0asz4JITmiQxzQwX7Oq53YNwWkYmVvLAs/YCFRm24CVD+T3lyi60LoaIuAZL5xhLVowL7/HbaQTXke2oP4PmqRuauXZXVL4KeVoD4Wjr78TLuIQ037OCcZXniMw/jnZfaNYfKxAuEY9+Nb7uLB8us6Ej7Crllm4tsafopyfdfRWbkNwayv9TtyJB04rMq6UsHXOGtRWCLUWyNo9BWyVSBn0PKTH050Uhaf7vKPw3dn/EEdCjHWZpzIN77MVeVE6sP9tfwSQmDMHKQyicWVM5dxR8LPnN3j9CfzjI71f/MyUUR1iGvoLdt9to72kiKAmomNHsSNTQ3zEPofOMuzBCxv3b3BK0aABPgOZ5Q8mRKO3DmdKYbBxr1UYP6KrKUBvXtYbVzi3VlYOi1pCm+xTTHa5N0jbR1yRWBq6BvDcxfQH/FUeUnJMtiSmto6xkaXVWTRhVuO550FrJMQo+dFBdWua8J6vURRs9ZYEGVoSv7v+OUy0B7EPNCjLj/V/uYDZCS2PLADEVOGO7fyGW38iDoYlTnKQjgox2ISSDOj8F2BCRiVnAx/lEhFIOAZOz+w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(136003)(39860400002)(366004)(376002)(122000001)(55016003)(38070700005)(82960400001)(86362001)(38100700002)(8676002)(4326008)(66946007)(66476007)(66556008)(64756008)(66446008)(478600001)(41300700001)(8936002)(5660300002)(76116006)(52536014)(54906003)(6916009)(316002)(71200400001)(186003)(26005)(83380400001)(2906002)(7696005)(6506007)(107886003)(33656002)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rD+nGJxpk2Tn5N1OIEUXchzwJ251Hy3nE58YvAdrXhz6bqafWrxK3YnwInM1?=
 =?us-ascii?Q?6vZa780q0Ch5Vw22uBbx4du5XPYdIhKE2V3x8/2qLB04F581YRoN7IoPVx7C?=
 =?us-ascii?Q?PKDTxugXJcxmZomDyg6sHama99gPyuAJ0ywp9PoP4Xe+Bg3jnKggPL1g2szz?=
 =?us-ascii?Q?5jA78fY9CgPgilKkjVzs/FjH5q069w6Q9WEP2RmK1r7BulurSshP69jKwoCz?=
 =?us-ascii?Q?LwIpJg+e1FlepTGzAT20+AUV07+MlKoDSkkgvttirFvKcADVKHgnnQIe+Zbl?=
 =?us-ascii?Q?3HgmedgU6J8C5wamWUGcIBJEWob5527cJ6ubFhr1XmRP5bd6NzLnUutcLUmr?=
 =?us-ascii?Q?H7MAj+fjQTGWAALf35bWxRFnxk7IshJftjEy0j6r8fON9LhSiZgDRZV2OIPX?=
 =?us-ascii?Q?1bK9nWPXif17olCtEhnC7yfTNTHLD53Gp46EuZkCs6IBu5PZD4Q/G+054D5L?=
 =?us-ascii?Q?Pjlh/Ep7nq7/UcgVzwXvH/kB4wI/zs8vcwngRpAN8juYJzm00WxAL0QcAf2K?=
 =?us-ascii?Q?5U+MJD7pb3AinW7EIrhHSnWbv3y1TMMOM4/I6fsFxKRny6qC7/EAhPViUmrI?=
 =?us-ascii?Q?S7BZ9l6gpTIniIhHp6rv1FYjyTgTJVDeVHH4iLRTo+5H0o5EiolU/S0II9ax?=
 =?us-ascii?Q?j5RCjoQ8npUfFgo36uJCtMV0x/nK75fxD0dHmMKD8OKl2zDjsgVTm7oyrv5b?=
 =?us-ascii?Q?bKBMuN5D73qfXqVAZRFc/UNweC2EE8TZLab3UnXocfYepynRm+AjTSgSSlvC?=
 =?us-ascii?Q?bysI/PWhGxmezkQllwi20BAjV0LaCYHDd+szMDDi5BQFNGzUlV4C99QH2qn+?=
 =?us-ascii?Q?2nlYvhR0+QXPsIXPaI2Uz6Jjcs08NQ2szs+YqcaE70y7GX3yn+JAUe3gtts8?=
 =?us-ascii?Q?69NX9OOsVrBzo+fHGGp0hfbV9vhIjMCvC8ca7rB+Xw3IXs/RPcqUq0Vkd/uO?=
 =?us-ascii?Q?EA4EDexfFlaoHh0aXPmAeY2mdnv7VaV8vaxTPInBlUHcw1FGEsTxO+O8IZr9?=
 =?us-ascii?Q?oPi6+mnzO9I1PWV7o7ma53Y5tWaP4ucDgrcQTMOOHv5Z5icp72ltfvOnjOPR?=
 =?us-ascii?Q?OHRydUjeKsPhIQIXoRnbCk0NBQWsdAlFQR6v7D70oG1Z9BxA1TEw8LCpVXJ8?=
 =?us-ascii?Q?nFH39/MZEFsugQHKLfLUdxImuUODJ98fNpYmWpiiWAMb2kyopEiApTDMeY9j?=
 =?us-ascii?Q?Up8/objZ2OjDBrKrte6R/wTb21r4EMWvKVV3kJ4X29XWpSNIih+Qix570opP?=
 =?us-ascii?Q?wv/ahfXnbrzvMOTLwkLQSVRrYEBby6NjCqc/4volcqX733pr2JwUesZZ7ajY?=
 =?us-ascii?Q?oX+qzl6HvPS19OLGmKvoK2kmI7WDrxlgpemPm/0SZk1K3v4PIyqMSmNZ3kxp?=
 =?us-ascii?Q?PrBL524DF2z8EnzHZCDoZkjuLUYifRmz6j7cglYAK7PT9fgJJZA7W306HsxA?=
 =?us-ascii?Q?z4/L1j08u1hsCw/BN8hRcb1tjFqDPbrl5cJQ36HU6NI4hRfSsJlnKgQFGOeQ?=
 =?us-ascii?Q?XFOsS+rzAm7fOR0SOuOLWfs/cLsj3YT3PY/oluRAAa/XHeWd1thZ8/E/gP5f?=
 =?us-ascii?Q?YLXjTGl3IqV56XrC97BJFJJGzunLB2Y5QEQGKxAT?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cea9ef7c-5d54-45b6-2996-08da89627c7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2022 02:02:11.4372
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OVX9f65nF19v3ARX1EzVx/VSy4/djmmaC0c2jfl1kJ7/SK+UEpn2lj9IjN5hk7jl6ZwH3chwcBOgszjHBzKvqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5996
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, August 24, 2022 8:38 AM
>=20
> On Tue, Aug 23, 2022 at 01:31:11AM +0000, Tian, Kevin wrote:
>=20
> > > In fact I do recall such discussions.  An IOMMU backed mdev (defunct)
> > > or vfio-pci variant driver could gratuitously pin pages in order to
> > > limit the dirty page scope.  We don't have anything in-tree that reli=
es
> > > on this.  It also seems we're heading more in the direction of device
> > > level DMA dirty tracking as Yishai proposes in the series for mlx5.
> > > These interfaces are far more efficient for this use case, but perhap=
s
> > > you have another use case in mind where we couldn't use the dma_rw
> > > interface?
> >
> > One potential scenario is when I/O page fault is supported VFIO can
> > enable on-demand paging in stage-2 mappings. In case a device cannot
> > tolerate faults in all paths then a variant driver could use this inter=
face
> > to pin down structures which don't expect faults.
>=20
> If this need arises, and I've had discussions about such things in the
> past, it makes more sense to have a proper API to inhibit faulting of
> a sub-range in what would have otherwise be a faultable iommu_domain.
>=20
> Inhibiting faulting might be the same underlying code as pinning, but
> I would prefer we don't co-mingle these very different concepts at the
> device driver level.
>=20
> > IMHO if functionally this function only works for emulated case then we
> > should add code to detect and fail if it's called otherwise.
>=20
> Today it only works correctly for the emulated case because only the
> emulated case will be guarenteed to have a singleton group.
>=20
> It *might* work for other cases, but not generally. In the general
> case a physical device driver may be faced with multi-device groups
> and it shouldn't fail.
>=20
> So, I would prefer to comment it like this and if someone comes with a
> driver that wants to use it in some other way they have to address
> these problems so it works generally and correctly. I don't want to
> write more code to protect against something that auditing tells us
> doesn't happen today.
>=20

With all the discussions in this thread I'm fine adding a comment
like this (though not my preference which is not strong either):

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
