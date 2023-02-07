Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD7368D938
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 14:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbjBGNXm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 08:23:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbjBGNXk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 08:23:40 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06957CA11
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 05:23:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675776220; x=1707312220;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6TYSedKs/sxgpOU/0IOzZHHEeUNpMXU7+SvHZTp8F5s=;
  b=iIv9h0BR+O/qJwuBwByQ02v38u1v7JfdF4RDPcDntTB9udPRVNbmG5bk
   W+uTFVGRQCVElGdmmbFi+5zeNCy/kJ9G+yusiJA7+junwfycuiexv1HjX
   08AYiXC99IBydXhfFPcFQAHZ2fUQbVN9Iet6WhVbmjG1PlS12cA8XG6M7
   zh9FT0NcElwlMrOsWS/564LmU3MGPf6+ArW9pp+YoJonMASz4cZjM529b
   PL1ID4lsJZl2QyUFeaP2o2nHPuKW/+GIoqx8DKE5pcBkjw+r1k+zpZ+C+
   ajBjehQkkjuBqC/UDB6R0QJ/f342hXD6HpTIFG+s9fIU8JWO05YEStTnR
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="328145013"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="328145013"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 05:23:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="668794442"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="668794442"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 07 Feb 2023 05:23:39 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 05:23:39 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 05:23:38 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 7 Feb 2023 05:23:38 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 7 Feb 2023 05:23:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jOunvPj8DX0pAtTVRO7zuXu3/1UBSIN9bL2FGov0gDi/7+K8clTZEWf5QQSOznknn5/r3yjPnUm9Weg6Fnm81MuD7TyLK42PbP/9I3zbO4EvUZGz1Z+2q/8IGgedYfsj2X1ACm4koqHJAlYVPUIVnru6AfR2EgPhXBlfzgpIcMsHaHRDnygeRNyPDYyvsGdN9m3/t0sXzUnvqDphf+gKWQyUsDjasW7aKSYno76h/58bxJ+9FZm9WGfYQkXLKkf/L4xLQda1zN4RyLqcusguQJ4cVXOpxDiUXl637L1j8+EGMuNbHeHiEyTB6GSjiA88Feka/z2R0OoSm6MFQ2f1Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N5ytLh+iLsGSFSR4dLkUNWT+W1P1s+l/UXz2JmpkBNY=;
 b=EP60LuCwxwr7KAl/v9F6WHa+a7UQ/Po64qrkixDhsehDKE1EtQ66wRW8y3vCsJYuZsimIH6YxkjF40msHuubSf56JLv3HX6kA3a93rDeRyaAxoDUVQF/XC/Np5tK4tGq7zX1ZSx8bGSYWDh3o5fhQNB8GPRYAbNGZWHCgPFow1PKuBUsG71JZSRItGU4cjrWqWK2G4Q/YflLP+1k5rVwSKtbWk+VMSl7NBYhm4V97U+zicPkrSnMiwsWeeuR+RiWGOlXZnnQZ7Yz1VvrqSPfhMjcYrBjA8lJH7JCh/bdGf/x027yStHbpvEEb6Ju3SAyuFG0XT33Kp4cbFhVuIDudQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA1PR11MB7039.namprd11.prod.outlook.com (2603:10b6:806:2b5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Tue, 7 Feb
 2023 13:23:35 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 13:23:35 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: RE: [PATCH 10/13] vfio: Make vfio_device_open() exclusive between
 group path and device cdev path
Thread-Topic: [PATCH 10/13] vfio: Make vfio_device_open() exclusive between
 group path and device cdev path
Thread-Index: AQHZKnqawLpQ51DKRkSs/ALC/dgVdq6mbRKAgBCCdhCABEMGcIACZfGAgAPY7eCAAF/tAIAAVAKAgAAKR0CAAJOnAIAA02sAgAAAXACAAAHQAIAAAFDQ
Date:   Tue, 7 Feb 2023 13:23:35 +0000
Message-ID: <DS0PR11MB7529FA831FCFEDC92B0ECBF2C3DB9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <DS0PR11MB752933F8C5D72473FE9FF5EEC3D39@DS0PR11MB7529.namprd11.prod.outlook.com>
 <DS0PR11MB752960717017DFE7D2FB3AFBC3D69@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y91HQUFrY5jbwoHF@nvidia.com>
 <DS0PR11MB75291EFC06C5877AF01270CFC3DA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB527617553145A90FD72A66958CDA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y+EYaTl4+BMZvJWn@nvidia.com>
 <DS0PR11MB75298BF1A29E894EBA1852D4C3DA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276FA68E8CAD6394A8887848CDB9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y+JOPhSXuzukMlXR@nvidia.com>
 <DS0PR11MB752996D3E24EBE565B97AEE4C3DB9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y+JQECl0mX4pjWgt@nvidia.com>
In-Reply-To: <Y+JQECl0mX4pjWgt@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SA1PR11MB7039:EE_
x-ms-office365-filtering-correlation-id: aeeba65c-f488-4480-0e3f-08db090e8440
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D+qZFHZKjrrZV13h7tOhYOo2mNePXzDEhpbQdf7Rs5HhjKB1I7m7EKd/2fMGNysagSYz2cCfVX6giySqje7xQnLoK4VXz1VuB4UzmEfypQdKiJht3k6uLfbA5BER8wO0n8uI6HyK/QrSqQHg9QrNQ/pafWWAohaU8EnLZoMhBXo6pg6TwjE+z/r5h8EUVZrMVbHmz3NHk8uSgn1Bm2aCRfDw4zyQqyLjl7lyVA/U8MIjBUp9qwJYG8WXNRCZZGMfwppZ4gxVhY/WH9VBjANGUJrzzSYpaw6Z0UbY690lOzAJuvXWPPwmgdA+zp+AmR4mcKg+5x00K4Dpz327LFgjspjT/dh90dZ5Od29gi2ie9PiWdV8dMLMR34jkTR6RhPaaJ+Xll//f0/lBR6vFBrIEKXJTF1PSp40BcthxNTH/r+6l+HzPRRRi1JzN3Qkb2+AaOI0yMKdfzoC0ECM3qpHNVBR1+J2EgM2Ot0KO2w2KXTQzyFMxqEJ9IoXdCSbgMjc0lOxCIX9ijpOBDbyyrbCSX9pBUemrwUoBrqLnvUHPHXa6W4p4O2nrWKQ2Q1hnpGmTNaF0sysNCtMsoTvQ+nqDy7q691eR4rb/zsPxsHSJ1TYNJNEpiD7QCLYXFcVwlIkp7gm0Otg8weVKIZgIVnaoCJIeHsPXFJUoiuUmlQqErMLPc5nMiLWgR2ja+8CnRWwdmLPn2ftbdCwhRiJDlJ4eQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(366004)(346002)(396003)(39860400002)(451199018)(66446008)(186003)(26005)(6506007)(41300700001)(66946007)(66556008)(64756008)(66476007)(9686003)(76116006)(8676002)(33656002)(86362001)(2906002)(52536014)(38070700005)(54906003)(71200400001)(4326008)(7696005)(6916009)(316002)(5660300002)(122000001)(8936002)(38100700002)(478600001)(55016003)(7416002)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wDUmTjQ5Yj0xf5kvmEyaolPM4E3gmTLACEah08qM5FRCbe8ugbVEJhRcB2lO?=
 =?us-ascii?Q?d0E07uTAMDlPgL8DLaYuao2sQWA68EJiGKgNprd0Ke2H8mLqQStpYvri6B9K?=
 =?us-ascii?Q?gQnEwTepPQ5+3WV4S04Cw7/Kj8ZNscxFUgMwLK6gZbhVJ+uJDcIMnino0txN?=
 =?us-ascii?Q?7Elgvo2q2vJVUbcmLRn/MsBoCuOSosQL7H0BVLRy9OiaUaDF1MXmGoBiPw4B?=
 =?us-ascii?Q?Y3z+fwbj3RJAy91UvavT3/9wIDcoLM9IFagaqiCMExRIYNhcNT3rY/WD8lRO?=
 =?us-ascii?Q?KIZf7OOUZIqsWZLCwZUzPm3ccgh76aUzBA6I57HqJNnB8cM1OmN7Hsl+PjDR?=
 =?us-ascii?Q?nKIdYQzFRZFnwzx4JUqp8Q32MyoAMo8k55NePJm5Poh5EHCrgc2F8P+KJbwc?=
 =?us-ascii?Q?wS1mDNhACLDWTqudAUa4HisUGWQCJlV8VIsfPsEaH1PQE8K9news2dp6aZvi?=
 =?us-ascii?Q?kHOJK54jaawClOTiIJ9/IS1gKqTnpVuZIxDpzzW3Gr/jFOoffVzw06t0xVKk?=
 =?us-ascii?Q?XP3zVAS127nQKdcgawdlh03FoqS33rf9mwOyzEmgustx+/cBEoEqX7ZSsHIL?=
 =?us-ascii?Q?KCSrWyd0p6w5G5CKAPbzcWsjlzcTB24vJG0AuW5NRzz82/IE37yhPM7TXvOY?=
 =?us-ascii?Q?AlrAK6CaEtQfF0rb8Byogzx+GEQR3wyk/0fJ414rpEdO4ONe31N79FbATGYv?=
 =?us-ascii?Q?guljqQW08EA2aK5LKNY2tJEEKkTxQUndXjgh5jiabT8L4PlHfREHjy48J1R6?=
 =?us-ascii?Q?wSj4SpKA2taOm2R4M3hFkUXgKGoGFcGi3Lb49+gILFdKdjOJb1stktUbroyQ?=
 =?us-ascii?Q?GeA0eqbtkHl5t34EFSJXxlffF8JJzZtodkrSAz9t8Ep5aMVcijCLahW3/SQa?=
 =?us-ascii?Q?eOVFuxoMZrwKw3kQHSThTG8onKAv49uhEZzjV6p4OVvTto6dpmitDaQE3jrF?=
 =?us-ascii?Q?JJSEEQhTNMaARaoC2cvU9thDTkLxKeBhg6WRJB/2JqoaHYVSD2HiKg/blIeu?=
 =?us-ascii?Q?dsCRJ7/qIh9OdTdMwno1Uiia3rqlM2ggtu+WEddsU6OfvOOtYsmypAvs/3Tz?=
 =?us-ascii?Q?27UPmlY7MTY6Zy/XZ1vsi/D/mLBT2dz//LHb5NdiB6tGIJtBI+pVuVYnC8a9?=
 =?us-ascii?Q?2L03wdE4H6TbMZQx8Eqk2hkAAoyWm5TSOBge3gZsnkXts3vFPJD0util0Tcl?=
 =?us-ascii?Q?ho+RXji8JCp6n7iDLXKjmuOTZP2emmRCLqyzRl7DtCBNz/X1D7dNoHBijKMv?=
 =?us-ascii?Q?OQjq/+gW/XdYfzVptwIfEbpe07Miqyox2D/DJJsPmjPJQv9SyJynMgBwRFN8?=
 =?us-ascii?Q?KO6G1o5uESQ58UtT9+kzmfzLA+DI08pLL3Zi1rqTmTWliemyi8qdvTceNWeb?=
 =?us-ascii?Q?wPUEET7H6xWjWMe1gTCZ277G1uzanCmX/il7aoD5ay91dqNFsGWbxXlkf05u?=
 =?us-ascii?Q?sJYexXhMu55PlhSqS1Fw5sa5ce532york1QkSdl1LJPQR53Rh4c5eO/2+tnv?=
 =?us-ascii?Q?RzPBCC7DQU+QKh4c1eA5GvrOsfM8MvM0zIML+ZBYOk0Jxv33tfzQUuRtIIFs?=
 =?us-ascii?Q?UPrcHvIBY3tfMdoS/2yKN8yig6Hqqcx045cB5NWF?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aeeba65c-f488-4480-0e3f-08db090e8440
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 13:23:35.5571
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GGAcHwUtuKCHZqv8ENa6Xq366MU+McO1i7MgFQPgewj7oYeZZJ/BVh2RfjheSHiJhE9G/NhIhp6CaUimMedmfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7039
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
> Sent: Tuesday, February 7, 2023 9:20 PM
>=20
> On Tue, Feb 07, 2023 at 01:19:10PM +0000, Liu, Yi L wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Tuesday, February 7, 2023 9:13 PM
> > >
> > > On Tue, Feb 07, 2023 at 12:35:48AM +0000, Tian, Kevin wrote:
> > > > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > > > Sent: Monday, February 6, 2023 11:51 PM
> > > > >
> > > > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > > > Sent: Monday, February 6, 2023 11:11 PM
> > > > > >
> > > > > > On Mon, Feb 06, 2023 at 10:09:52AM +0000, Tian, Kevin wrote:
> > > > > > > It's probably simpler if we always mark DMA owner with
> vfio_group
> > > > > > > for the group path, no matter vfio type1 or iommufd compat is
> used.
> > > > > > > This should avoid all the tricky corner cases between the two
> paths.
> > > > > >
> > > > > > Yes
> > > > >
> > > > > Then, we have two choices:
> > > > >
> > > > > 1) extend iommufd_device_bind() to allow a caller-specified DMA
> > > marker
> > > > > 2) claim DMA owner before calling iommufd_device_bind(), still
> need to
> > > > >      extend iommufd_device_bind() to accept a flag to bypass DMA
> > > owner
> > > > > claim
> > > > >
> > > > > which one would be better? or do we have a third choice?
> > > > >
> > > >
> > > > first one
> > >
> > > Why can't this all be handled in vfio??
> >
> > Are you preferring the second one? Surely VFIO can claim DMA owner
> > by itself. But it is the vfio iommufd compat mode, so it still needs to=
 call
> > iommufd_device_bind(). And it should bypass DMA owner claim since
> > it's already done.
>=20
> No, I mean why can't vfio just call iommufd exactly once regardless of
> what mode it is running in?

This seems to be moving the DMA owner claim out of iommufd_device_bind().
Is it? Then either group and cdev can claim DMA owner with their own DMA
marker.

Regards,
Yi Liu
