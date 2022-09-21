Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 637205BF4DF
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 05:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbiIUDky (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 23:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiIUDkw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 23:40:52 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED0048E83
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 20:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663731651; x=1695267651;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OzT338LGfbOXpBBKnu08sftvL90tMwDfcqG1/WLVFVk=;
  b=N7uM8JPRYU0NsRiFBOiN0mk4ml3xM7JpN/XDMNacwk2Gbqf/1dA/Q04m
   QCwuFyOXpNKgftb5pbe02XHMGKJipfw7HIyzYNYQrNRkULYymjfWTE1XL
   pJuK/AusSKvkTbNv7Jb5zpU9z/mTToZRzptDVW4ANsnK2QQ+LZLzbdZnQ
   K9mIxzGKYUQRiGsvnKHia2n4PvNs2WM9a4TblsI2LzO/0Sqf5W6iAKCCn
   KvTjttbNuc5nzrG1vE11xQrmXrvn8NClHVhGs7G+pbJ7/bcxruAe0dCx0
   Df7u5/ceHejM/lurMn6UkDklQCMvCPVzNZBbV62JQN2ev1ljcRSmi3BPT
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10476"; a="361645094"
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="361645094"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2022 20:40:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="947966028"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP; 20 Sep 2022 20:40:50 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 20 Sep 2022 20:40:50 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 20 Sep 2022 20:40:49 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 20 Sep 2022 20:40:49 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 20 Sep 2022 20:40:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ad69DXM+5KqsuZso191voJz/DMpkcMMBabcMn0x8YiKCvukq5tOsxYJecvyR2/8383I+u0AM7a8EYq8cM5NixNJRIkIE5LIKHEv0MYcBEIPE46zZMXEfxPAIzXGgvDlDY1tyHW2gse5VOlJ9gOY53W68ri6i7/KZuHF5F1CwYynuZOK4kGBg4dupvGId97HtDUl9cj7HvwuEEV3jQeH1JaqiTVfqTnkEBlTas/W47SEAL2LMNodeA0tVXjDK6VyXHNQ8+TiMNpZ7md3WPNXbh7SmN+85GlIfDRjYVfEVHAq+EqcucEujjzAkx441qOC+lh8iWxJ6v24+uJETT+OWLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OzT338LGfbOXpBBKnu08sftvL90tMwDfcqG1/WLVFVk=;
 b=n73V1gKa+nzK5KcnP+hKfOFIahaxLkqyCUQsQ+zASVJJsbrRWcFa4UcS0rEsAdHKcYJ9LocVRgQQeCyGx56ZTiO8su2WJQMC7OnGSy4iNwt+BYs2ll56TjCOY54GrWVgyw61kMmDEfI9Vlghd4nRi4a6y11j5GyAuUSFBWitCmDLcOw4ik/+Grg4RIPCNBm181EYy/1PD/TQhles2TzTF4P38ntfPCdN+braTh5hDsvIYVelvQSq97YCJenuuwTdaR34cSU87KfQydnVPc+1hqoW8xWL1yZtrYuGyIZX5gXcCIkvPN4TYUkxPu1/6trTVyGuynFYeBTnDZN9MhBbPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB6381.namprd11.prod.outlook.com (2603:10b6:8:bd::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.16; Wed, 21 Sep
 2022 03:40:44 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7%6]) with mapi id 15.20.5632.019; Wed, 21 Sep 2022
 03:40:44 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "Rodel, Jorg" <jroedel@suse.de>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Niklas Schnelle" <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: RE: [PATCH RFC v2 00/13] IOMMUFD Generic interface
Thread-Topic: [PATCH RFC v2 00/13] IOMMUFD Generic interface
Thread-Index: AQHYvwaitkEm6TEO00KJwkFy6AT+ga3cqchwgAwxgwCAAH1+gA==
Date:   Wed, 21 Sep 2022 03:40:44 +0000
Message-ID: <BN9PR11MB527643C8E0FAE091968BE2D88C4F9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
 <BN9PR11MB527620E859FF60250E7F08A98C479@BN9PR11MB5276.namprd11.prod.outlook.com>
 <YyodnOJaYsimbDVK@nvidia.com>
In-Reply-To: <YyodnOJaYsimbDVK@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB6381:EE_
x-ms-office365-filtering-correlation-id: 5c01db57-a976-4b51-b0dd-08da9b83103e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xuWF06Yff8HFNNReHoe/IIFNkybRvBsKsEzpjESBwn5nlik0bsTBapYjgIfUtl0KzN1bcTFU3iCOw1SnD8x+/4sk4KpfLhxc1xUuMkou5RcDV/ET4KV+HkthAlX7kPFNd/T3QHWEa4YKyc/IwK7LzBEb5iC2YUG3OzkwyYteVOhAhUPCPAtQ+qroQ4UYiiBifBu4KEExDLLcKmpCBePbb4y0hG2p4a8TbMFDiT5UaBaNbsljYZ5LOSWs/zWarRvS0VGA8OW4RghGf+1Tcr97NkjFvJSkN4wS3FYBFUWPIqYBRHTXIeHuB4wdTtjtfW9CEvwq43rcwBQaV9+6YD/T0W6LVs8T2p4URynvC0OB16qD+FH+N59upXgorZwYv5iyNG+FfWjTaWPfMRVwdJEZyriRuoL3U+bZU7hsDqhV8SPIMC8KUvbLxMEtAnApKABWzHUw9sXotAQdUukQI7hHzDFaa3Mjdsw6AKX4v7+gD/b0kdt6Far/oEDp40xCC8XionRsMDkgoZ7iuGmeMvzvF7AVcqsIk2tzwTfiHcldLccewlGcF50cO5JuCRBAbY9HwlffT8ocJLzUxN/6ZEB6fCbVm3iLouFt9HHLJZ5Q8u3eUfU5S6HrpRPyN7PMI/S5WHlqLBTVqGCnV2meZzuOv5QsTSrbwxMuyKiCoWoapt0B+yy7CWx679yRGEHcHjbvT7zHzEhFp03Jq0ASQZsl7CjHThlhjxdvRct8bbf805gYth1OGCc/LvG62vfXqbX89fNcIjxmBZ5PTXHcaigFQJBnj45OvcyS7MvSr0RLxEU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(136003)(396003)(366004)(376002)(451199015)(5660300002)(86362001)(54906003)(38100700002)(66556008)(6916009)(8936002)(316002)(66946007)(52536014)(8676002)(38070700005)(66446008)(66476007)(64756008)(33656002)(76116006)(4326008)(122000001)(82960400001)(2906002)(7416002)(9686003)(26005)(7696005)(6506007)(55016003)(71200400001)(41300700001)(478600001)(186003)(41533002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QBQhBtSGGtiGdiV6D5ECSEYrHKsbNgR/67sOb8yWAyzL30L8Y8vl29pZ5zGN?=
 =?us-ascii?Q?+MD3RiLPXWeHX22I0+csCOC/jecKaiqLlxglAubC5Yi5r4znTAPXBwXH+yyV?=
 =?us-ascii?Q?13QGtkpIOk6AqBA6xjyIyIGAVSPGxdPMYhk4V2DGr4Q79qdFuRkpSloDJPh8?=
 =?us-ascii?Q?OQ0rsbBv2QB4a2tHEywxZsfkeICdvy2cjccp/iYC9Z2KVQsEsCAzdkIs3VMI?=
 =?us-ascii?Q?hUqz6zmBkkqh9pCA0T/9jw1k9Tbz1ig6ZSSScn/xRMnkS+AIiOxGHjV+wDuF?=
 =?us-ascii?Q?aGNncjR9Iet8hNJLESfy7PkFl2jZDTGu+xnRaCKuqivi0DXUiJlAeF3iRbe9?=
 =?us-ascii?Q?f8lPSvzXEe/wl5YHevtPeU0tCwqYcItXQxu8Ox3vy6IfzaIETFFC8J6iZiRO?=
 =?us-ascii?Q?cnWXND6YggVMNJJiXguOEM38Qpth0kSD1ZDWMMyTVT+WIU63PxMTInx24yhe?=
 =?us-ascii?Q?q0hcfppiZxw8aA5G+x9UHtB9LFG20orkc+Azh+JJq2Ma9TNQQHWZ6Gh3jMxv?=
 =?us-ascii?Q?pEqjWR3ibn6GpN1fcNY5xSCQ6Is8WXCQ6E9+NrmtW/eJX3Ohxrk2PKigTS0o?=
 =?us-ascii?Q?C62kG6hSsS3LGGETI02+VReszV3zjcOCkkItpK/9UXJeEXkIZ6WVgO6NGgqP?=
 =?us-ascii?Q?GMnyhIGMQea3pes7ADv29PGUmkXmmd+3moY9iFw6LpI7ycKTCokNB5hf8Xzp?=
 =?us-ascii?Q?LBk08cJ30nruaX6kKp8GFUEtGBK0yZsBWx5kXSNYBuPIo8fQP+tDH8tAm7+q?=
 =?us-ascii?Q?VCnSdFqUqQaEglbKkTpFTTTy3RFdgRT2GrdX01Egnmu01ePbGQ5Myn7RggNE?=
 =?us-ascii?Q?Y89FcUYxRP7jRrOPtwqXHZjEncUQKH70DY6wzllFSs9sQDy1lT5dCitxKh0b?=
 =?us-ascii?Q?UWT+0cgpdfzpUZEX/rAhsVlFneJii87UewddoUdtasON3Ve1N5Zbcu2C+CrO?=
 =?us-ascii?Q?l9nTqXNP3Nsv9UVFNZbXstkMeve6rvKv7yXxFUA/LEGgzKKAu7eTMarnb5m8?=
 =?us-ascii?Q?k+rMepbRcCAFdyzm6xlIyzRAF+823QaJrFdemEiaDuFhZHTBq8PF90Ouev6o?=
 =?us-ascii?Q?eD2F6QT9Wa1D9nE2puF2BQGV0v6raaaViqZKHzVaSDCeGc4yg3CpZeV4R2cE?=
 =?us-ascii?Q?7DfcN2TLvShFiEPpXnORfgpS+53Whe1iovu3VwNCq3UL7rpFmfkO6rq8MM85?=
 =?us-ascii?Q?XyGO3pCG8D+WbcgoAv2augVDW25uOsAzD5DWv46BQRUfrBuiGcUVRmQwHtIB?=
 =?us-ascii?Q?RuUFnjbi6jleTQ4ynI6I7fet7uX9vR6bdyeS7OkrG7yV3cZghFf8edH1Uw6/?=
 =?us-ascii?Q?6EYjVIt+cfW37+DL8XeWiV5hYGCdVDhpgmwD0twa1kRhPAjR7cagnB5n2k8C?=
 =?us-ascii?Q?61ZS7Xa0XlQH7+IQOtdiX61VunYuvLrIg0PBgL67V0ioiK5KZcZY1/rBrWQQ?=
 =?us-ascii?Q?1S9hmMjk5DOLwgdceXv6ftUo0Oan9kjVqk54HbmJExfBcJ3AkQWdM6RO9lbG?=
 =?us-ascii?Q?jvpRtVuql0FIWYCvKA+s8a59fal2437wNldqx70EtuAdOZiziPHqjn0CWlCL?=
 =?us-ascii?Q?T0b6pkZLq2ySS1azMY+2DeOUAXZ2pUh715KJGOM1?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c01db57-a976-4b51-b0dd-08da9b83103e
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2022 03:40:44.1442
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ANDXQHoszUog1TGO3iNXGUiw1zOSzOAn2Z5LAN0a3kpbqMPcHAurWyfVblzr54GJrtu5Mi1NauSAKzZrQbOl2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6381
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
> Sent: Wednesday, September 21, 2022 4:08 AM
>=20
> On Tue, Sep 13, 2022 at 02:05:13AM +0000, Tian, Kevin wrote:
> > A side open is about the maintenance model of iommufd.
> >
> > This series proposes to put its files under drivers/iommu/, while the
> > logic is relatively self-contained compared to other files in that dire=
ctory.
> >
> > Joerg, do you plan to do same level of review on this series as you did
> > for other iommu patches or prefer to a lighter model with trust on the
> > existing reviewers in this area (mostly VFIO folks, moving forward also
> > include vdpa, uacces, etc.)?
>=20
> From my view, I don't get the sense the Joerg is interested in
> maintaining this, so I was expecting to have to PR this to Linus on
> its own (with the VFIO bits) and a new group would carry it through
> the initial phases.

I'm fine with this model if it also matches Joerg's thought.

Then we need add a "X: drivers/iommu/iommufd" line under IOMMU
SUBSYSTEM in the MAINTAINERS file.

>=20
> However, I'm completely dead set against repeating past mistakes of
> merging half-finished code through one tree expecting some other tree
> will finish the work.
>=20
> This means new features like, say, dirty tracking, will need to come
> in one unit with: the iommufd uAPI, any new iommu_domain ops/api, at
> least one driver implementation and a functional selftest.
>=20
> Which means we will need to put in some work to avoid/manage
> conflicts inside the iommu drivers.
>=20

Completely agree.
