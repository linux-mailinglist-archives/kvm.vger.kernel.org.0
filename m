Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBFD65E6FF0
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 00:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbiIVWty (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 18:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiIVWtw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 18:49:52 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2378B36427
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 15:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663886990; x=1695422990;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=h4zqu9LdVB6NCsm8YjDH/wm7hQUq9wNqniNCBg0LUHg=;
  b=X07PE9bc8r3gyTLpAZzGSkkPEzPNez/XRoNDhU85397B+1oPYYraQlOM
   3ITHKXAI4zwCBtS6vUZGs+GzDvj+CchWIhfwwZURMQ3CxvKIkmdg/HqkR
   qKU2k5/WVKkdDj+1Ar19LJH/5d+pZ5Fb9coC+7UebeoYdmWoNCJEhOVFj
   jIvQZXKBjhlcW+0cEuHd3P1TEapiu/vyk9Y2aK6GogF9fsESu52YjXhIy
   xaMYCnXSEz58UAlKxErQORRVTVn0vodgN1wa1TwedCv0qa4wZsOTnHHTM
   3iCNAWr1aWu/GCJBaavQl7XWKT4Rn6XXDh0V6aSHDFR70sfVhZ0mSVlCl
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="326782221"
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="326782221"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 15:49:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="622299057"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 22 Sep 2022 15:49:49 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 15:49:49 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 15:49:48 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 22 Sep 2022 15:49:48 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 22 Sep 2022 15:49:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bnIr7sFERNWkawmB5WjM29tZJGeL/qujuaRGoC4xfSYxs2o87NbXancnrJHqxcWEONupT5r1/rrAeU008vKBfFWQvTN0mfZHKxiW1dorRsOju0J08JLecqgOUJ5rU8NbIRYW8bQnj8B8pYh5WT8CmQMnKZBBdNX3jryP9XtqB2Xlmsb1KqjONgqXqT0+iakRfAPS/vqlp2jA91g+HRI+duHpeQfyojSPu5xriEyFCtEPW1fir8Phh3ZXaD2nAzaTWg/mJG2xXtqXF4nG+ATd5R4Cth3wD2Bt201Vtb9EUIC20XoOkch7nJK4d+bB/aUg66bxccIy6SboVDQRX3Sp2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PR3Bkg+SyLM/JKlmOG6r0MU44EHoUkQeMiTMjlxJACc=;
 b=GEVn1hFzV8Z4KURfVe0ZyFkssOQre1Q2/OiE2yoksOmRTqsX9Z/VXfwyyIpY6VyKoGt2fkcMluTRUPRZQ/nWh0Zb7g4/+uY7gimObUyl+4yiCNjHUhei+li01qJnN+UBMR6dBHaT0+l81N1ssO/EVojmhTnF3sRHpDFkYqkTh0ioEHudCikn+39cGIXgULuSNrmSrbrL40ZAZ2cgpMJHUGKIoXTWZ7k8YSDN8en7U+LcOlnXWQrzdMN7ein0IPIgcwL+xA98dpURC8P88HhnkKoPQ6yOMSu4+h/ZGsSKHj7Skydbwr9uLWQcmiooJkyhKtYOINw1nUnzNfv3qYz9sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW5PR11MB5812.namprd11.prod.outlook.com (2603:10b6:303:193::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Thu, 22 Sep
 2022 22:49:46 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7%6]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 22:49:46 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v2 0/8] vfio: Split the container code into a clean layer
 and dedicated file
Thread-Topic: [PATCH v2 0/8] vfio: Split the container code into a clean layer
 and dedicated file
Thread-Index: AQHYzVMYoiPFNtBX1UGxTtdoLJ59/63ph1lQgAEbbACAAQ68AIAAA4KAgAAKTgCAAFEsIA==
Date:   Thu, 22 Sep 2022 22:49:46 +0000
Message-ID: <BN9PR11MB527624F41DC4F7CA21D526D78C4E9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-d7744ee9cf4f+33d-vfio_container_split_jgg@nvidia.com>
        <BN9PR11MB527613A28174EBE5450B4A218C4F9@BN9PR11MB5276.namprd11.prod.outlook.com>
        <Yyuzrqe8PocywMld@nvidia.com>
        <20220922110930.0beadbc3.alex.williamson@redhat.com>
        <YyyZuwjmeOxEjh7e@nvidia.com>
 <20220922115856.14361e1b.alex.williamson@redhat.com>
In-Reply-To: <20220922115856.14361e1b.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW5PR11MB5812:EE_
x-ms-office365-filtering-correlation-id: bc82d8df-4eb3-4fc2-3fae-08da9cecbf98
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sNcZUClN4OL5haTuOcVmdpPV+ZPiWPhCXerzhxurTKPensPChTp9R56yPs0+vylBdOq3PY36qL48t373Tw1xY99gGIGpbKRzOc/l2Zdq9Lk9rug0bDUsJxCtnwjqmVa1kUqGzXNn0e+ZyHbwXtrG9ypysRyw5VttvzOGznHwYMVQ2HAHRybqirWrVQHxmQeI71ZhXYlGbdTdZi209xjXK+RMURzaAcRSkjjewmn1QLbRT/D/fhfKUB6ZPa8vS4dHBjOcGcw0Cueri1PVVYvAD1bM2g7dvtDAdDJmjVBUGWVSSFgww0vEDO/aab3cumBq8xq7rqWnGFqWPkITwL3enQiv7sB7GW4zDY1O56NKFW34ZPmqd19Gf1HFh+2wDSwTSNuSjaFkB8TDs1X+gNTLQm3OPHKoD/2l75i2Kz1ZBJqXwcuXG0Hxw0+fsSwfnq7qrkj/dQ3a9hWKkjhY7CwsW+IjJqZyuMKub7geHPRA3BXoaRell2dyRasRC6mf2Xr+J0TH0OE+kkQDgGZCc4KZEBTzG0o7rruW5DMaik5m2KferTLZrjcfvM+4zpAIb2npW0OP8TvQZNSYWIJANcBOfJnniuWQtB2/PGA5F+WIK9/hjdPSjtm8GWNAnNoFo87Vta0e1Z2IKLyihHXJT39CWRKzmVlajvDDINyALIxz1u8kjkdYg7bdQ8Mpx36BqlnOQpmRWnAiEMJhr51zoUAlVZoD9ljHRQaGu4g5nTymRYp28X2cUDIetOucGhlyKnDmXwhcGc5/IkZhj2JgDQLJJg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(346002)(376002)(396003)(39860400002)(451199015)(122000001)(83380400001)(82960400001)(2906002)(186003)(38100700002)(5660300002)(52536014)(8936002)(41300700001)(6506007)(55016003)(26005)(38070700005)(4326008)(8676002)(110136005)(66446008)(66556008)(478600001)(66476007)(76116006)(71200400001)(66946007)(64756008)(33656002)(7696005)(9686003)(86362001)(54906003)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nlx0YPRCRD34TGbJZY/faa2jUR3f/kMcRp4PUGcG49rqmJ7oak/ECWYHPe7r?=
 =?us-ascii?Q?aC0xNEWFQZjaKHEcPfztlEHmihBRWQ4t88Ir+n3lWSlcNmKdP4/XGyIdrukv?=
 =?us-ascii?Q?E3yQTzOhLAtHmbCVWBs/MiyVZgohudGOpWKkuYeGgm4xnY6W/YC8l135XcJy?=
 =?us-ascii?Q?vovTIXndtOTd4OH8LP83WUOYZ1J51W6fFGGQc9N/q9GKg5+KKevfhhrUmTKe?=
 =?us-ascii?Q?xUu0qfNP5ps2aPTucRPqHgU25+pvcUm3FepThICNsGl4fruo84zZPsbGOABI?=
 =?us-ascii?Q?PpEaYh/zxvdJUrmZRMnlzHHac/OyIt++/RRaohEaFC2Kv2wmKviv3NfBrhEG?=
 =?us-ascii?Q?hvopyxCC2Fy79PzXCa+qFlnJ2LLnoiNwu1meL5/1OxaVUy9iaWdmhUBzOidj?=
 =?us-ascii?Q?iO8HUBZ8cRfNNPftTd7UWaULjHsTKPQnSuxtCruuNQ/s7Q4KFfAZm89lgpEx?=
 =?us-ascii?Q?oa0Om5M8G96QojTPzQUZCJIOp77OuURbpnNIAtXBXoGsGk2PJdsHGXgrOSTP?=
 =?us-ascii?Q?hWVPEbrMDdfmi/XsY2Kb92mG//EPbdNO7UqbO6dfL1V5f3hk2cHR5TKOc/vR?=
 =?us-ascii?Q?mq2tJvtV6WfQrWvri0F+FumkAb0rPXPLTQowuBYJO5G2DHUa2zwcx7rsmJxJ?=
 =?us-ascii?Q?9QuL7upS2CiiAYejn9Y/h0EaB+pVAcC8HwJvamH6caOaniUuwXhs8RSgmeLg?=
 =?us-ascii?Q?POuHWNPB/vBlGBqkX0CgBqo1dE0F+CDnTDXg60DDMi3Scvf3uQ0V4GcGYFip?=
 =?us-ascii?Q?GLi4WxzMYJ9tKGh01p0vXVJW6XWTBuWsRv2VY5eDQfFisGMO5E/xujIdNPbz?=
 =?us-ascii?Q?VB1n8Fo3q9qs0WMC5Jj9lgsU002gxCf1c6ibW2saUc1F+CJoTO16kfRNY1Ie?=
 =?us-ascii?Q?rukuIsPDTB3CREGxWkW7iwZdPV4+1njUXu43uAB60gj4MZS8BwbK637UklZh?=
 =?us-ascii?Q?ugdLtoDWlzSfeIGjKwzpCC6V9DvTaDgTV9vRsIeY06TRC+ITnuCrS7Mn62Ev?=
 =?us-ascii?Q?UN5SdK1HGEMGiFmCYdh3iH5YGpgH7aUJSC6jjm/FxTitdMZyzvdhqJQQOAB2?=
 =?us-ascii?Q?q8GlxTtlnt588asveD0xWl6g7tviDGCs0QL2efGv7tihKlfRigmDpwI2YhIc?=
 =?us-ascii?Q?FfGPEE3YN29XlSVFS+DR6o6w4II/1qh88thkMlwYzZzvVq/o57+IVsMcfbwT?=
 =?us-ascii?Q?kUMnP3JFeOC6JWu/5DOJ4Tw50fV5tJxcJGpjYhfpYarnaZeNTp76zJhC4EzH?=
 =?us-ascii?Q?mEfDevuKqaIr4+Brm+gGWa9dBVO/vYMiC1UuzWF6gRUOHficCtIg313k/u7m?=
 =?us-ascii?Q?EufmRxFuJmp881ze6ftkRsG5hkLd7T9eqQSq4Yfu9neFo0dt30Po6+2tYEoG?=
 =?us-ascii?Q?Dtg3qGUtr20Vwy5E0oTPDNqyt5Jbg85ClYN4YlIrfNKlEpxQZPIP+8sW/SB6?=
 =?us-ascii?Q?w0EUAoIaeIctIoNcjTf/hwLFu1/H2M/bO4859jpN6/A0Qgnj6lbbOsgB0tIg?=
 =?us-ascii?Q?+IEyeISJgFTYDXylzSDUx2nMMpu5AJSRM0/XRriqfS/0NPijBw7AKZx7soAf?=
 =?us-ascii?Q?It4T1bfdYwdD9tN5sXnRq//9kayuxOaqLYB0QEaW?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc82d8df-4eb3-4fc2-3fae-08da9cecbf98
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2022 22:49:46.6831
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4tPkhvtT639moYHvWyqKqr+D3mktDK/IXc5G8JNCz2yGz/n0X8nzSeW67ki+bdLsJUxUZCVAuOq0qVDcKcjuww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5812
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, September 23, 2022 1:59 AM
>=20
> On Thu, 22 Sep 2022 14:22:03 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
>=20
> > On Thu, Sep 22, 2022 at 11:09:30AM -0600, Alex Williamson wrote:
> > > On Wed, 21 Sep 2022 22:00:30 -0300
> > > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > >
> > > > On Wed, Sep 21, 2022 at 08:07:42AM +0000, Tian, Kevin wrote:
> > > > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > > > Sent: Wednesday, September 21, 2022 8:42 AM
> > > > > >  drivers/vfio/Makefile    |   1 +
> > > > > >  drivers/vfio/container.c | 680
> +++++++++++++++++++++++++++++++++++++
> > > > > >  drivers/vfio/vfio.h      |  56 ++++
> > > > > >  drivers/vfio/vfio_main.c | 708 ++-----------------------------=
--------
> > > > > >  4 files changed, 765 insertions(+), 680 deletions(-)
> > > > > >  create mode 100644 drivers/vfio/container.c
> > > > > >
> > > > > >
> > > > > > base-commit: 245898eb9275ce31942cff95d0bdc7412ad3d589
> > > > >
> > > > > it's not the latest vfio/next:
> > > >
> > > > Ah, I did the rebase before I left for lpc..
> > > >
> > > > There is a minor merge conflict with the stuff from the last week:
> > > >
> > > > diff --cc drivers/vfio/Makefile
> > > > index d67c604d0407ef,d5ae6921eb4ece..00000000000000
> > > > --- a/drivers/vfio/Makefile
> > > > +++ b/drivers/vfio/Makefile
> > > > @@@ -1,11 -1,10 +1,12 @@@
> > > >   # SPDX-License-Identifier: GPL-2.0
> > > >   vfio_virqfd-y :=3D virqfd.o
> > > >
> > > >  -vfio-y +=3D container.o
> > > >  -vfio-y +=3D vfio_main.o
> > > >  -
> > > >   obj-$(CONFIG_VFIO) +=3D vfio.o
> > > >  +
> > > >  +vfio-y +=3D vfio_main.o \
> > > >  +        iova_bitmap.o \
> > > > ++        container.o
> > > >  +
> > > >   obj-$(CONFIG_VFIO_VIRQFD) +=3D vfio_virqfd.o
> > > >   obj-$(CONFIG_VFIO_IOMMU_TYPE1) +=3D vfio_iommu_type1.o
> > > >   obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) +=3D vfio_iommu_spapr_tce.o
> > > >
> > > > Alex, let me know if you want me to respin it
> > >
> > > That's trivial, but you also have conflicts with Kevin's 'Tidy up
> > > vfio_device life cycle' series, which gets uglier than I'd like to
> > > fixup on commit.  Could one of you volunteer to rebase on the other?
> >
> > Sure, I'll rebase this one, can you pick up Kevin's so I have a stable =
target?
>=20
>=20
> Yup, you should see it in my next branch now.  Thanks,
>=20

Thank you both!
