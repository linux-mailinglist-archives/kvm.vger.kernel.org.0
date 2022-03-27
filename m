Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFC434E8500
	for <lists+kvm@lfdr.de>; Sun, 27 Mar 2022 04:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232631AbiC0CeH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 26 Mar 2022 22:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbiC0CeG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 26 Mar 2022 22:34:06 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3925025C
        for <kvm@vger.kernel.org>; Sat, 26 Mar 2022 19:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648348348; x=1679884348;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=9JxJb0Cyy+SfcFtCalqP1vijbMFfX4nejPshEh5/EtA=;
  b=Vz0XJMJEGEujzmutcVsox4DiF8pC3RtzPAk1IhW9p54V+vMdWHmkJdZZ
   RYgpOtph32F641gM39JMxaFXb26tQ1oFWNK24TPd2cLKDjT8ltXof2QOY
   hwhJVRNPq9pu18qTR6J02zcOPGaz2yL3EH+rZCoVusSvldUWORX1Rvxb/
   k73uJorWRZdaTXDYKOdgGLrVXv4VBdlemg6wgfrxe2LUX3p9EoWxoWWTl
   w0iIyQIKuVWZKBfrcQQ0KpS0ZsLdw3ghtEEa3JTqEdF4nF/C+Cj9O7bdB
   +X6cp3Oa96rPjl4cPYUoXjiLp9zKOB5sZPn9BkhP/GzAabTxM4gizBxng
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10298"; a="345255365"
X-IronPort-AV: E=Sophos;i="5.90,214,1643702400"; 
   d="scan'208";a="345255365"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2022 19:32:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,214,1643702400"; 
   d="scan'208";a="545515813"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga007.jf.intel.com with ESMTP; 26 Mar 2022 19:32:26 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Sat, 26 Mar 2022 19:32:26 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Sat, 26 Mar 2022 19:32:26 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Sat, 26 Mar 2022 19:32:26 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Sat, 26 Mar 2022 19:32:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jFI+jwgyQtB0z2zljr8HQDUMj17ah8m4fAgf6zPOFZI7pqtkWtfegaL9z+D3pToWG9Z+PhiL8ZM8JVb7nd0DRyNq8WAzftlWdCb8NbrzUuTjMqdz+GjEQAuCZ1dlBPjkpadUB0EHmsyjfGjM8nVp93SmKq3v/Tt/EF2FjybZz07hQ/bZxDwUDCgGRyYtCe88IgXrWy5BmA2V7UAfsXmYLG+MWxjIJzJmaULFvSIBmUTXA3vwJV9Igc8djs11xqPhOsP7KUWEs3NY0EkyglcZQ2XW4RBjR/Zw5nSLoppGhsJb67vSPfdSzfKsz5+VNgrL3hKfxTBs8s8kmtYrlXTXMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9JxJb0Cyy+SfcFtCalqP1vijbMFfX4nejPshEh5/EtA=;
 b=ZZdXIGMit2bcI5itU55nlI7C73QB6KUBHghLbpekYMxc42zq3ftoFuNXIesoQrcmjTcNzB+7FFDMAiK3dhJmn2i15aKgTo3XiyFSYdfl2BlDTq4HocA566CXrfsStilhhH4WdEqGekvmqVdSDBN3g9mPR5bp9vfeFkKDnifi9e1mbdCHLz2ZuVLqqcr6i6vBSJu35lBb1sQbfDdIqC06a9b8dlysAjL450EwKA46CkzwEFY8VQ4Cbw2/MGWB2vF3TWOM/LuCk/wGLDlZGsWpFSjhStVhZPwmxDFOFx4CD2Zf2WOCzcazy+unuKRsP+aZ9JXygPo6dGKv8zoK6NmP3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM6PR11MB2618.namprd11.prod.outlook.com (2603:10b6:5:c0::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.22; Sun, 27 Mar
 2022 02:32:24 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4df7:2fc6:c7cf:ffa0]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4df7:2fc6:c7cf:ffa0%4]) with mapi id 15.20.5102.022; Sun, 27 Mar 2022
 02:32:24 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH RFC 08/12] iommufd: IOCTLs for the io_pagetable
Thread-Topic: [PATCH RFC 08/12] iommufd: IOCTLs for the io_pagetable
Thread-Index: AQHYOu2GUDY5OA7cJEqND2xJuT5HJqzNXYEAgAAGtoCAAAhqAIAACEAAgAAnNgCAAIPcQIAAdUoAgADP8YCAAypRgA==
Date:   Sun, 27 Mar 2022 02:32:23 +0000
Message-ID: <BN9PR11MB52760D5905410D0907B6260B8C1C9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <8-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <20220323131038.3b5cb95b.alex.williamson@redhat.com>
 <20220323193439.GS11336@nvidia.com>
 <20220323140446.097fd8cc.alex.williamson@redhat.com>
 <20220323203418.GT11336@nvidia.com> <20220323225438.GA1228113@nvidia.com>
 <BN9PR11MB5276EB80AFCC3003955A46248C199@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220324134622.GB1184709@nvidia.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 53b8e68b-51fc-471c-3551-08da0f9a06d4
x-ms-traffictypediagnostic: DM6PR11MB2618:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DM6PR11MB26187B0A429C087A8FA508818C1C9@DM6PR11MB2618.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xe5eN2FOryXLfGlSqtoizvyv2I7aM5Vy5GcO5ZP7MMhie4fqXGREmsGT9pSg+Drv1N1mzg5NEJQXOThT7WSlF+IYW/V6PjFtSfaVqO5yHaWGPQZTZOPXE8JqYC+j7BHmTdJ26KzkW4TGe/GhFQD/fb/CwZZ23ytazwmeDO+t7H4rRP6dejqETCabQjg+sQR9BgD/0uF6PRRgOcDxMtxQ1t/6F0qsIMlmvmaon0+kocvtqlKlTQUARF5BTn4hBi+qUZK+vDP/yazBvv50PjOZ2QrVXJoMpejtZi4HgpkD85kkxBf3/duUiawVeUOXbvD4ST8L0urBgfqCNeVKQJvFixUv6t8yghGeDjJ8P7C/2Oc00XrgGfXJWagd5lbJfeP64Tg8HoPQLABI8ya2lG5v0i9bn7Wlwdgpqj9CyBJiEHGooPmDK3r3y02/5QXLd+TVdc8g9V0eV5YV0w3pti4GxLwwg/CqPUibmv6axOrLEerlFhbq9Lux8QhNIhqItENhwEzMvp9AKwaIbQxm0cE7vycg2GKtGkMFfKfK+FtSQAQzzRjSUSnOShAA8K7m7VLUsM80+xaiPE03JOWBg3IX58TECz8PNzVakdSiXcplAiRjELeAZzGqMdddCPPZwv3zKz5H74GHpDHRQvNZoVKuKrKDl1Dl0qRxE1V+dzqG2egaofrFfTmksUVYbCKFpHVauccQtIB7Xo94PySZIClAqGK5wtmU7ueneM42wcA+zvz4q82OocwLIvBuHrFPrIyTf01PZsAaxayt5fcZ/ZTdxep4F45fuoiouP8V/y5eOgs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(71200400001)(76116006)(8676002)(66476007)(82960400001)(122000001)(66556008)(5660300002)(4326008)(38100700002)(7416002)(2906002)(66446008)(64756008)(66946007)(6916009)(54906003)(316002)(38070700005)(33656002)(8936002)(26005)(508600001)(86362001)(186003)(83380400001)(966005)(55016003)(52536014)(6506007)(7696005)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nFB3Nbpt2IzT7Nw5NMf43VpjCBXUJysmxCzyNZZqvowYgj2ZLVvZM1dGR1k0?=
 =?us-ascii?Q?v5lcgq9cEJmldlFORYB+LmYZc0TOacmPoCQxg2UImzu/7qd8x5TZugkQs1p5?=
 =?us-ascii?Q?2Pzb5VVU9Hrvl/l5nx9CMamLSZ/FeM8Zrfe/gBLeipZuyUX8udED2zPZpCEd?=
 =?us-ascii?Q?Z3oU5AXMQ7M4d84pmi6/PjJDdgA2o2VZ2f6rr7el2cmOmS9a/DFRMbwoOcsJ?=
 =?us-ascii?Q?ONRiyrawEq6v7eyPecHWUSIvJ++Pz7nQA58eLvaGLDLEg5dZ44+NMQhLbtWX?=
 =?us-ascii?Q?PEy3D7m/uJ88JUgULAOzahQUKEJ0C5O1W3jocs+f63hu7nNYeKTYf7yunl/r?=
 =?us-ascii?Q?9Vg61nm2FKvHSdoAAxbtKOmRaFCvFpKIpqCzo3h+GT2UGyae+Wu2BmQRuifO?=
 =?us-ascii?Q?BWjSiJFSrL+xROe6g8I4tfGZb9hFs9qOItGfgvbN5sZ6L2DX29NIgFfYxMer?=
 =?us-ascii?Q?DB0o/68W9nli1TS1ns6G+jjjXpTGjoHf2Wl4GLyF+RE5KD81ElOz+jE9I1/X?=
 =?us-ascii?Q?Ctc7RdKYqkZSg2WJhmmOEX6TXIml9jxehvlnhhdsmmfxF/Tj49CHNKGK7oH7?=
 =?us-ascii?Q?6hUz8m0LBeuOKD3e1Vu1vcVzkdwt4WqMQo8WGXv8kuTkEgVmVPqZUxk5E3ok?=
 =?us-ascii?Q?CoDr2X/qna+NjC+46poKhqV6qqy7QkZHpR3eV7u1quPo69YyOOvh6NY4nv7q?=
 =?us-ascii?Q?wWzsz6GJ1EP9/yytC/nzLp4Lw5OX7RWV0ArhAdKboHo3aKMdaUTK4ig4MC/S?=
 =?us-ascii?Q?U7OePtqYHVingiztR0zqoT56GEJd5ms3ukyaKhR0hKBDCEc+WIUznnQHCt0s?=
 =?us-ascii?Q?uPafuy7VfOyF+r9UfD9FXI9oxJwO9lDtf4vUFq2brbnq9TZmqya3C/1LjPc/?=
 =?us-ascii?Q?cxExAYbPJEOSH/L02EU8f/dnX3gCwbwRVJWvv+9t3ewrZCwG+DM7hubJ7IoE?=
 =?us-ascii?Q?XAgeoxkxG57O/NGX/7WtYfhlKZPgnvWG50lWmwOEJmBbUAyYKecsAzJKLyuS?=
 =?us-ascii?Q?obPEmHo3B7uzI8hbx9VWjmghQjT6X8knVcRFtrhPPX+boc4boxzsdRg9lfPc?=
 =?us-ascii?Q?IQIQAi8egr3wmlOd8y+VkhPK3W7IbHYPPJt/gJy9HZkkEXdKqYTw6kL1uE/V?=
 =?us-ascii?Q?5v4n66X2KgoY8FIBlS8sp/0dwrUHjL2FKdDjG0+Ecki377FFbt8DRbVEwY+3?=
 =?us-ascii?Q?5efa18GRyhwbI5SeYxtdImPkA5bwpYuU3FJLX+meYRW29d+xXqr21Bo6vg4p?=
 =?us-ascii?Q?dhVMdSfA4ZxK86DaHD3OnehPxjbCjFa8aHi9GD5+ietsDOT6wP+trTMflOLH?=
 =?us-ascii?Q?1c7yL/WVzUTJ3zXVs/toIoUh1IYFynJrGllfpnPoYE6SkosJJIFopG4jD/NV?=
 =?us-ascii?Q?K4nXZbXtzhfUDSh+3j0FTTpV3h3X7/9bm03/yOXVuIpUzoD6wFAvN6Nsk27L?=
 =?us-ascii?Q?/xPyukBhz9LDlv+E3ffqrQqowSIErLDA7Z3TkqSLNj1gn34uaLkjr9s0QR8M?=
 =?us-ascii?Q?kL3jE7v1XjHNX0+X2axDr7L0rDCl3gv1gVoFYUupDt67HOVTXzivfxX/Hm9x?=
 =?us-ascii?Q?pb+kZgfY6dnQd9VCMKXrPxrF7ed9mpOW3fdFv9xWrsfbgyt7qblSCkWkReHZ?=
 =?us-ascii?Q?mKPCmuak/UVC72+iLhRYRHFdxpMSPZWmcntnpMxP9ceRnrAiYoYwrjMk8cSj?=
 =?us-ascii?Q?ZYYxO7Om5qlfj6KSuSkP7PjYjkHKyZSxN2+8zY7oIDVTrAZJujbs7TiJSGMV?=
 =?us-ascii?Q?xrPJnO6ENw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53b8e68b-51fc-471c-3551-08da0f9a06d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2022 02:32:23.9204
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l/nzG67H9WvpbM9T/eu77EesdFGdE3cypemu4M/nDwDxrzpnfOtDNSaYHzbThJMihLskxFXtA4mBaSku7cLF4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2618
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Tian, Kevin
> Sent: Friday, March 25, 2022 10:16 AM
>=20
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Thursday, March 24, 2022 9:46 PM
> >
> > On Thu, Mar 24, 2022 at 07:25:03AM +0000, Tian, Kevin wrote:
> >
> > > Based on that here is a quick tweak of the force-snoop part (not
> compiled).
> >
> > I liked your previous idea better, that IOMMU_CAP_CACHE_COHERENCY
> > started out OK but got weird. So lets fix it back to the way it was.
> >
> > How about this:
> >
> > https://github.com/jgunthorpe/linux/commits/intel_no_snoop
> >
> > b11c19a4b34c2a iommu: Move the Intel no-snoop control off of
> > IOMMU_CACHE
> > 5263947f9d5f36 vfio: Require that device support DMA cache coherence
> > eab4b381c64a30 iommu: Restore IOMMU_CAP_CACHE_COHERENCY to its
> > original meaning
> > 2752e12bed48f6 iommu: Replace uses of
> IOMMU_CAP_CACHE_COHERENCY
> > with dev_is_dma_coherent()
> >
> > If you like it could you take it from here?
> >
>=20
> this looks good to me except that the 2nd patch (eab4b381) should be
> the last one otherwise it affects bisect. and in that case the subject
> would be simply about removing the capability instead of restoring...
>=20
> let me find a box to verify it.
>=20

My colleague (Terrence) has the environment and helped verify it.

He will give his tested-by after you send out the formal series.

Thanks
Kevin
