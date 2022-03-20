Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62EBF4E198D
	for <lists+kvm@lfdr.de>; Sun, 20 Mar 2022 04:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242895AbiCTDf6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Mar 2022 23:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbiCTDf4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Mar 2022 23:35:56 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 882D739BBF
        for <kvm@vger.kernel.org>; Sat, 19 Mar 2022 20:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647747274; x=1679283274;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=AFKo2Jz7MwV6q96uc7v6jUCK+NTVh/SC9WLZF9HGnpo=;
  b=UwX64kicnJsQTjZzpdbxLC1ufovjwT45y/vRVH3NxCl46Cmd2s8UIMdh
   278pnD5vd1OE4uQTvqK+skYS19c8IhFMC8zMTNChUkjoqkZGHSI/Ftmfw
   1Fe8oppYVeCF9hijW8pcxjSqFB5So74u43i+EA1QwZA41A6BfcoPFCyyv
   VOUUV6bz44FuHnlK7xRHt2kz+I9c7II5861wj7id287Bqnz4GlPYzgDx/
   mppnWZ2ReVm/mYHx9FMMZF2wyKlHaeGffi+r+OoVTY87Fqo+VbfrFdEpS
   7Ddz4tWkwYZJayA9fOVS1/QqxKqP8LWAJLf6xeUJOaeK8g24uKpWbH0oK
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10291"; a="237952779"
X-IronPort-AV: E=Sophos;i="5.90,195,1643702400"; 
   d="scan'208";a="237952779"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2022 20:34:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,195,1643702400"; 
   d="scan'208";a="499768368"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 19 Mar 2022 20:34:33 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 19 Mar 2022 20:34:33 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 19 Mar 2022 20:34:32 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Sat, 19 Mar 2022 20:34:32 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Sat, 19 Mar 2022 20:34:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D9CCD/5hYg6AccDmK3Yb37JZqZo1DWOdqzjj8weGije/a1JAT7l5QwhDB2VLJ5yao8Do4u2e4Kh9VchsYWEs9QAGc2Dm767iHoh6jNmqd6582Q64KxC1ZtSOZAVtNhyMBRTKivskpnVy3t4R11KviE7S9flfi6eemp/OR0XSZ4lYBBvlPbZMnCOUW3OQ/KrIMrJ0n+P8oX05oQHFEHuwNsTuw+/HkPVfMQnaatpaz6w8zOw9dOEaB1ggL6eon+ctW1bJ7eQRC+yi0JbCHGQm23k9Yst0P5fhmRlLl9m9VIRlE5O4Fh9gIZgGACaRWbkuBlSqH3UBF6jaqROzgKcH1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AFKo2Jz7MwV6q96uc7v6jUCK+NTVh/SC9WLZF9HGnpo=;
 b=S4t8UXeB1P+5Ef1WFjWXotjKLlVR48lYpcghEMOmYEGO1XiBVTI5JnxkgzfVXB2S6k7AcRyp7pBIgagXJSeNE1PeRttAS5Zn//ZIfQu8qunQBBLMceO/09SHEU13/lDzZeEuhMxb24dkEJAUyNSh97F60OCofIfCUMWjAe5XvNZ734IAozcJUxy8A0EpZ/6kDPBxZ/dR2Eljtgmd/NlKev1Fr4b/e/ICPRmrgt4JkHdwNLv7U2bDr56g3/ZmgQ2mwt5yPmzysj0X3YCL6immrZQOZDnWij0z37485CDKzEY0OIP6DJ0QccrWIdxb3E7RrtjQAEhhZzZeWyFX0bbEBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW5PR11MB5761.namprd11.prod.outlook.com (2603:10b6:303:195::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Sun, 20 Mar
 2022 03:34:30 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893%8]) with mapi id 15.20.5081.022; Sun, 20 Mar 2022
 03:34:30 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Thanos Makatos <thanos.makatos@nutanix.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "John Levon" <john.levon@nutanix.com>,
        "john.g.johnson@oracle.com" <john.g.johnson@oracle.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Eric Auger" <eric.auger@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: iommufd dirty page logging overview
Thread-Topic: iommufd dirty page logging overview
Thread-Index: Adg5jKKwvNkxolKnRPWJ5nYfZVngmwABAPgAAEWHdcAAB6sPAAAoLtSwAABPxRAAJv8uwA==
Date:   Sun, 20 Mar 2022 03:34:30 +0000
Message-ID: <BN9PR11MB5276CF40E2B50782FC20275F8C159@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <DM8PR02MB80050C48AF03C8772EB5988F8B119@DM8PR02MB8005.namprd02.prod.outlook.com>
 <20220316235044.GA388745@nvidia.com>
 <BN9PR11MB52765646E6837CE3BF5979988C139@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220318124108.GF11336@nvidia.com>  
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d8144ff3-e71c-402d-ad0f-08da0a228aed
x-ms-traffictypediagnostic: MW5PR11MB5761:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <MW5PR11MB5761C47AC4B27BF69F9C74CD8C159@MW5PR11MB5761.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 86y8cPZpqh29XpS7Zvs8sDzz66s5473vJ1dD7D7eaSVysZFCZKbCY6X+fpA1h7IqmhNVde01lCAiydCUPoQUu5Ifc0QJ2Zw/HlU8XLb1Wj7VMkc9TwEsTvhO2F8JzRL8qU9LwT5C65QVH8CnGS914FGXCeamQKVrY73em4ZmtM+noxPW/slbqBIuTCuG91NihEIUNSGIO7c4xzI464Y7xivrYON68kzy6Yatn0ZxPgt5Ub9WSc4Cne9X6kQVB8UrPlJlp9xyu8igwNf703UMK5bRRD74JcdV1dqqtL1yILEJKVkGoYUszATelRQnlm8rTaWJh8xGBcfXQPpEivtp82sU1WWmcL8UCcfwZWxp3YiCGZvuvCin1A7Bs4LTrrHf5r5vCuHnpTABRAJ2b/jlY5ctjSSMvCJOWEZ/vU5OMtu6BcvapEDDyxPlrYEpyALVSj0d+O9m3U4mWlbW/amMwHy/6xQbbhRT6JUaasjrvtzALSmG5ReRtQKpDAoDlggnQiSftFE4IDQe1YvytYcqAQe5AfoRP5Vc7UsEjY8jb2iIbovtka8H6zGUGGCMtv3To/KIWKC5gBqCvoyCe9tl3gQFUjxV5/tF87BjuGxpnqJhrIiSsH1TqmGH0ycDZl21OQAYH4t0z+90IPbUb0IWElUu5yZfOl4Mu5cuzEvBjOywXTaSmBgK3z8tnsFZ9aqUD4YhaJQx/16AQcfR0xJPe65B5PVDDWmiq06MYNH1yz+jgP4ronEgY4a+eoA5EPk0pYZxsCdwwi2Fgef4diBk3G1jLF59jKXrGQTIsx+woIo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(66476007)(66446008)(64756008)(76116006)(66946007)(8936002)(55016003)(4326008)(83380400001)(5660300002)(52536014)(54906003)(7416002)(508600001)(82960400001)(38100700002)(122000001)(316002)(2906002)(26005)(6916009)(186003)(38070700005)(107886003)(71200400001)(6506007)(7696005)(86362001)(8676002)(33656002)(9686003)(14143004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5z8hqWvq5YOyglwdsEscoqyg5Xk8avmxvRnc5/C6UPpg4nKQRoY2pR7N1chl?=
 =?us-ascii?Q?PTzBz+V2CEe7BMngDMpHMV+zw0kLbXjCMP7PEqHbCTMtib95ghiKFeXzAh99?=
 =?us-ascii?Q?uKt8RY/jNN8MOuQXtP/got674EoBFehMPhdV8z1tVskdMgGvV7Wl/rxaBVTO?=
 =?us-ascii?Q?RsUEv3nTR6ur7lFrJ72t6v4tyVs+Guwu3Xp5SJYke0EyOTSfuxfxno7qbg67?=
 =?us-ascii?Q?MfbeyzrMdyiWP6rhh32jUTuvyi7WeOCUxVLv6f9URDI7oMHvYRuAGnjg3e7b?=
 =?us-ascii?Q?G6hauDfzD7QLNM161DXfiNWLle3tNLUEGcFUHbuHKmVPWbT7zogM+SL2ZOcT?=
 =?us-ascii?Q?wy7CWCaVz3oAHDMv8d9EECJeRzaobkEPmJiwptdiLpJG+ol+u+1u9PPVwDp4?=
 =?us-ascii?Q?EBBhtiSmG7BH/aT+t6h7fsfyAs7mGSnEmMu6+LQsTACsOWAGuce4B3f0TBvk?=
 =?us-ascii?Q?jr5oIZH8jnTRb+xYNbAKTQtQpmTmO3n+r9/dlI1EVSmHP0evGyUA8lZDx20r?=
 =?us-ascii?Q?tO8T5kahk7J+pMUBJ1iNWcJiy3l3Yveiq8eqQqxBmZ6rdOdGF+qGt0w85Gua?=
 =?us-ascii?Q?9zAteqMwFkO5DjbNo6drXFila4rQwk9QAKFwf0c2zeyr7RUdNRO+YepFC/IA?=
 =?us-ascii?Q?jIYhsgTJtGeaGBFCu/eP/KpwWusb/alOikWkx1NDmZ1D7sZG87lQvpX5ZnXY?=
 =?us-ascii?Q?iiaNKMivtk7Sd7EP/KB9uSGp5YlvTED35JaxhNaZ3UjGRaYxKdNTPotZqByv?=
 =?us-ascii?Q?si01RxDZVFER2Xi0A3mBSlDtpAnSF9SaCykI1e2CQjFn4Wj86hae3PkSsOUt?=
 =?us-ascii?Q?o3NqDABBJieDvGdAnihZEiJAFoOUzMO+voEobDsmM7s0jFNLihVX6XODmCmq?=
 =?us-ascii?Q?A8ag12xOK+QE56quG4tnHyPsCpDrGDacrAMn7/M2QlFD6vl7sNdCfaXv01W2?=
 =?us-ascii?Q?7AGtUCgLAc4ToUPRR6EHTb/EeabPObYL5lTXGsJbMAc8BdzegrXLY9ZHKz0k?=
 =?us-ascii?Q?m32pfDzyN9kQv7jBBzrx/r+PgGtKVLwN/lc7G1rhBg88q7OGcEBc7u9BTCs1?=
 =?us-ascii?Q?DI3CsI6GseO78W4ZdI3Rb6i43yT8zt1ME/k1NkVmeAVsxvoYzwi/dd523MGK?=
 =?us-ascii?Q?AgIWvV9GzX7Tx7n8zmAlM8tvOwUdKUmEXlAoCT//chGmyUpzVgx32GHrU7g0?=
 =?us-ascii?Q?C6IsLZ8FMpFBCEV3D60GEA7w+7kxtIxTte+vr2q138pn75+VpdW1qyQ0422q?=
 =?us-ascii?Q?2IhTa+fHosertlP7cGfJORWHjwVMNK3RpvCCWHuTYXgO4alo/BPa8uC0XwX0?=
 =?us-ascii?Q?gCbiMM7JmInvFE199dyopOLSW3ZVNzuIngGjVWhVhr8yiSBBmytrfr1lUEuU?=
 =?us-ascii?Q?jpwsL8YHWHLc6+WgPbJazTsdaNVykmNaWNVDCoWdDkw/JTSfsLCgme/th4AR?=
 =?us-ascii?Q?X36FYY78iLleQT9ZQHB+xl4Rx+sLmB0U?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8144ff3-e71c-402d-ad0f-08da0a228aed
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2022 03:34:30.1095
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vDXdyhfn9Jo0KZDMzFnVYd+paynkMoesh8bJjSNAuIiXwfiqZuTAw10A7XRyT7dnQOFODmOo49iLyzirlL3tng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5761
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Tian, Kevin
> Sent: Saturday, March 19, 2022 4:15 PM
>=20
>=20
> Let me make it more specific by taking vIOMMU as an example.
> No nesting i.e. Qemu generates a merged mapping for GIOVA->HPA
> via iommufd.
>=20
> iommufd unmap is caused when emulating virtual iotlb invalidation
> request, *after* the guest iommu driver clears the guest I/O page
> table for the specified GIOVA range.
>=20
> The dirty bits recorded by the device is around the dma addresses
> programmed by the guest, i.e. GIOVA.
>=20
> Now if qemu pulls dirty bits from vfio device after iommufd unmap,
> how would qemu even know the corresponding PFN/VA for dirty
> GFNs given the guest I/O mapping has been cleared?
>=20

Thinking more the real problem is not related to *before* vs. *after*
thing. :/ If Qemu itself doesn't maintain a virtual iotlb (large enough
to duplicate all valid mappings in guest I/O page table) and ensure
the cached mappings for the unmapped range is not zapped before
the dirty bitmap for that range is digested, the whole dirty tracking
is just broken in this scenario no matter which approach is used and
whether bitmap is retrieved before or after the iommufd unmap,
given guest mappings for dirtied GIOVAs in the unmapped range
already disappear at that point thus the path to find GIOVA->GPA->HVA
is just broken.

I roughly recalled a gap in Qemu viotlb was discussed when dirty
bitmap was added to vfio unmap. At that time Qemu's viotlb was
like a normal iotlb i.e. only caching mappings due to walking guest
page table for emulating DMA from non-vfio devices in Qemu. That
is definitely inadequate for aforementioned purpose.

But I don't know whether this gap has been fixed now.

there is no such concern with dpdk or VM w/o vIOMMU since the
iova address space is managed by host userspace which has intrinsic
knowledge about IOVA<->HVA even after iommufd unmap.

this is also fine with hardware nesting. The hardware ensures all
stage-1 activities converged on the dirty bits of stage-2 IOPTEs.
So the userspace can just ignore stage-1 and just collects dirty=20
bitmap associated with stage-2.

Thanks
Kevin
