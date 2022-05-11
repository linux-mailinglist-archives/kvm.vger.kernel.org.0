Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 503745240F9
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 01:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349347AbiEKXYQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 19:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349544AbiEKXYJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 19:24:09 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE58C1B57B4
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 16:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652311406; x=1683847406;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=B7+8GP1fBiVY1nHmBg9knr5BPQkWqSPY1Mg+Wn7Yios=;
  b=VfL1739dGqP0TWH2I6fKg6gmJAETbruKO2ZCgtOK5Iffuv0ZnhicPfS+
   QE/x35gnwp11tCwQYBTpShcg3aSOrUdaZC46thEeiK0KkZmAHS6Xsd1zB
   Oi0w3dJSv5Xw955RWc16rx6J0Zrc5N68PzCIy7I1vjmDJXf85zxWcRCN7
   LJhVKrq8egObByJdekrPBYArBF0eTrPI4MbqDznN5w1IcT7F+yeLYJ8Rz
   sA4/wP2ZiKP60bs6JMASJJAloOviNt2fvLtSdNsffXi6H00kX7iA/3le0
   JWoy23fZBZ6LMHW5tHleeqbc3hjIg2bVWGFPxZxjSTdE1VgMOky4tbpV6
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="332876604"
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="332876604"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 16:23:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="711689395"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga001.fm.intel.com with ESMTP; 11 May 2022 16:23:26 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 11 May 2022 16:23:25 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 11 May 2022 16:23:25 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 11 May 2022 16:23:25 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.48) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 11 May 2022 16:23:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PzRw0oW39wYtfvWRen08yz9HOmut0AirKgCi6exirS33BAYUo/Kc5lCRt2A4szcQIAE+H9tFlH/xSGFc1oCWIei9iaLgtJg5uM+hjtSx1vT4u+FEnXnwzFFfWdJpDoru4X2w0ludAJgGUzvgUPtj+XCcfpkszEFFUCt2eAP9/5clHDkG/X6IL695j8NfZ4TFXyM4rjvQzHsoZQROgNLKybuNJFSw/2NGFnLrgrZhINV5Q6kFLzH+uKY55HS9B6OHN3YGekkiqe4dqATwQcmCFyd6MGZPQJta77L/tknRxlfzLfHfcj7dIfjJkAnP1+CeCqW4sd0Kkw5sbhSghsEOUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cztpgz8SPQ9RMj9JS2QNn6u9fw2YtH5eiZUhuYjnOko=;
 b=HiPnavWmP7XFgCDV00NQeksCycMJwqg1/is6ENSyjJqv0iiFif0DtuL3kO8ecC2cn7sbFZbiwxBQJNOHVZVaNtmEhdDKBkFmsOkSYypO885jkKzE9MeM7cAL9C2up90Cgpv6LcPCr1dP0dK9ofPRRbVrhk5mjxSXyr0Dl9tyucdlc0YwDJ/nREDGNWxtFELQdDkG4RsQq8H5adz7GvMsV/GsXMqnMwdLNGRs+PqvHSHfUsC88axWLp2C9t57CO567ZcSBUlaxcSHqYkbJFIf3FdU76KKWGmqjQcrnoTYPlwI0ZK/cdOHFvwjM6HChlWn86xXmmMn94Z31YBMhdJFbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM8PR11MB5653.namprd11.prod.outlook.com (2603:10b6:8:25::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.13; Wed, 11 May 2022 23:23:22 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb%2]) with mapi id 15.20.5250.013; Wed, 11 May 2022
 23:23:22 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     David Gibson <david@gibson.dropbear.id.au>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "Chaitanya Kulkarni" <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Daniel Jordan" <daniel.m.jordan@oracle.com>,
        Eric Auger <eric.auger@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "Jason Wang" <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        "Shameerali Kolothum Thodi" <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: RE: [PATCH RFC 11/12] iommufd: vfio container FD ioctl compatibility
Thread-Topic: [PATCH RFC 11/12] iommufd: vfio container FD ioctl compatibility
Thread-Index: AQHYOu2EhhTTZTsn5EqajxaIjlC6M6zNmzGAgAAclACAAWiFgIA2iT0AgAAE2ICAAP5AAIAAbGoAgARd/oCABXnXAIAArI2AgAB77oCABEVaAIAAhciAgAEgKgCAAMXWgIAAgm9wgADmkgCAAHFq4A==
Date:   Wed, 11 May 2022 23:23:22 +0000
Message-ID: <BN9PR11MB52766D38F834E7F3A92B766C8CC89@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220429124838.GW8364@nvidia.com> <Ym+IfTvdD2zS6j4G@yekko>
 <20220505190728.GV49344@nvidia.com> <YnSxL5KxwJvQzd2Q@yekko>
 <20220506124837.GB49344@nvidia.com> <YniuUMCBjy0BaJC6@yekko>
 <20220509140041.GK49344@nvidia.com> <YnoQREfceIoLATDA@yekko>
 <20220510190009.GO49344@nvidia.com>
 <BN9PR11MB52765D95C6172ABE43E236A38CC89@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220511163214.GC49344@nvidia.com>
In-Reply-To: <20220511163214.GC49344@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e13fb14a-b02d-4fea-2387-08da33a53d9c
x-ms-traffictypediagnostic: DM8PR11MB5653:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DM8PR11MB5653029A3D8168FBBA864BEA8CC89@DM8PR11MB5653.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KJofO6OuIgzfH8FY88gTM/emkP/ER5x/zLz+6CoKnLEeaRwEQLkurR9OMF0TH7E29jhZthrSBeB8yckPuzTIHpyq1aWVgP0wQ0WFdFB5HeDwMLcPZjQaQZGXHdj47+rNbM1flh+SzyQ65XT4QNp2SghVlkHcZC8wp9Es519KGNZrREO4+ntrDfe0To48nnC10u28nbxSmER2AjKDhAOHoTT/cfwlciC8Grnn47xsE7JHz4eunUOtCOIGSSw/U5j5NMBnhgRcbZ+FwNoLWB/+kSyK3c8w2tgmS+paVPFlgBsXiGnfngoW4e6+1+p1sA2mgAxa+UykApfm0LZt3QYYbnNi74uJOCsunoCB1OzR/doWNQ/XY0bgVhJJ7AZUzGHft8AULFGyfDrIZ++1bv+4OFfLLO2P1fYHMT2zQmtQKTGHux/7Dzha5zCoNh3aBccGgOEoIKGv14s4kR2XubfWdBkILEvVQh84pOYu1KJMejM8safzcRueWH2/4LMvkB4zEuJ64hcZ9d5kZl7zKcMSrX1fJZ+KYWRiivT3OTs3NHtpiTe32jaozgJJ1mV22AluA5YdumqgpNoYQ1bVUwnFC0q3DPCvlz/yLGO9X8TrjOyzToNIBUXhUNXhYYgrhzuUkih2PWsKt16mgNZ/mI5WLPKxS1rodm3x9NC4S0N9qQ53WghCGAHknPcAeYDO4xYKglMPvTJSPQC46oUPzyWi6w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38070700005)(83380400001)(38100700002)(82960400001)(122000001)(6506007)(7696005)(54906003)(186003)(6916009)(52536014)(8936002)(5660300002)(26005)(66556008)(76116006)(7416002)(66946007)(66476007)(2906002)(64756008)(9686003)(316002)(66446008)(8676002)(4326008)(33656002)(86362001)(55016003)(508600001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PBpgPABbEzbgMIJwiTDTwSix/f8c3QILvujhK1jf7ZS5I4TfWnzinE6AK7eM?=
 =?us-ascii?Q?JPWpxVxEwiU+sYxDqQuYUFUSxoqddo+SXv5jnqpc6Q7wbKelnlFTZqa3IFI5?=
 =?us-ascii?Q?mUbcBduoIbtGHYGl5IiU2iUI+vgarDS0kzwm1Sr6EOaCbJSXzPPDaQ9uC23v?=
 =?us-ascii?Q?/whfTCY3RjEBoNlZy/tpsrMy8pvxGJ5vAYdSFQcyZZN7A/exLGSbhkkD4p/Q?=
 =?us-ascii?Q?d9KGc8J9SiIW/8uTtPK1vDCAodN62uD4Tfee/tmi3ZmH/RTMSI6xhsc/DihQ?=
 =?us-ascii?Q?s84hvZLUp4ILImKtASYhKWko7khUyCUlbqCzkabJ9CQI1cBJcq2LzQA6lzkm?=
 =?us-ascii?Q?SCwZ5ecfQ0ndaDnqV7+t5D/niHSNdhBj7383EsTSH+gYYtxLkDMD+SlrQTbj?=
 =?us-ascii?Q?NdA30H0f01tbrHaGEkoN7X8YlAn2kvzyZHPsDbyx6YJF+Pyf7aaeul4h3M2M?=
 =?us-ascii?Q?7hE2bXhkCv6rRhU/bGk8HU+ZqAIxI+59/Z/MkSjLtXgh3la/R1EtXevP43WO?=
 =?us-ascii?Q?kjZWErZ2XSrGTntAnIfDKRKns0RufCu2RSjxVKtqMvDY66HEQXfSWvGoWllB?=
 =?us-ascii?Q?bglFdv4HzIjk3sKMxzdV6hcEZDU5RSYGV6VrrWYFKXCfUTJfVgJmDfjkGaKj?=
 =?us-ascii?Q?eQb8VZbDSukLZv5cDHP1jEX3Vr3bjb0aM6Pw1N5N0SnGSM6a8a2M6fcIrvFT?=
 =?us-ascii?Q?HnnWLR1OtoLO0plaN+4vv3D0ixstObdS6Y73cUtC9Fc2AqUDtw865AKmKf8A?=
 =?us-ascii?Q?iv8IN+7CAdTVL4vJwgoHrGfTD67b13DNKhBUo+8tqK8Tx+i2Fa95zoYHf1Yo?=
 =?us-ascii?Q?CT774dNtrdGiqsqXZDzHqNfZYdf7ooIOzRaFj/ipqhZDfaYMHacTUKY/7biX?=
 =?us-ascii?Q?wlkNa6GVDbiYfsbyB7oFwzsTqR0IlHrWP9vdS4HdnEw/JkH9juLDXGTcrPI0?=
 =?us-ascii?Q?1KnDY4tUUpsR0vXfzUPpVplZlfftNK1xiNLjUUU8KKR3Q7souJb4eLkpxpP6?=
 =?us-ascii?Q?NKpWVkk3u1JbFnJQY1LpTLdKU2vEmMscGMDa7bNCDO+3OVF62UjKll8mpZp0?=
 =?us-ascii?Q?91tvlls6oCBJs3075gc5TjmtVlNQopRy8LYKTFX0doKNuSWUfBVoo44WLR0d?=
 =?us-ascii?Q?/bUVyEZ0soliqKyCpwcKMvY0bP2/YuHxLvSHVQrQDRF1o9q4KJ3OpdkYEumR?=
 =?us-ascii?Q?1syHN3O83JzdAambevopqNvOIifgZ3I+jXDzaNm940FnGKMKJrRauVSQ7xmi?=
 =?us-ascii?Q?6pwrY+omUjHFCJGCGFc6kFJc8sdTHSM6//uBqPfWD3XGWfSyMeHM2HPy9du8?=
 =?us-ascii?Q?YP5cPEp/Egv2QdD4NC9gF5IEhKHAV43GZW2SjyFHiTjWikl74hx7/wvfvLBX?=
 =?us-ascii?Q?/X7PpmmVnYtCbuwLtEWUxBCMKIHQ/QHjlYqJIteK3aqAumaegs9qct49HXyd?=
 =?us-ascii?Q?fJSviqelJegAzzNtk8DdmkyBBCKLoYovQltzMmp9/uFPRE1Gd4j1I+1sxocA?=
 =?us-ascii?Q?1SdOGbzVOKmyL7qZwq2kWDQhpySfyzmXdXQM6b8n5dHWRc3L/xd+HHqmkK3V?=
 =?us-ascii?Q?BGIAvu0lpXU5WYyae3P7yKaeY71vFbzwucjaCbB2II9go43k6XYNk2SnRmf8?=
 =?us-ascii?Q?7PqbGgdneHN0/7x0m92gCJWUFqwqwvPd/2t6I0flBAzk+iSURPHvOmzQKofA?=
 =?us-ascii?Q?kaGy4FZM2AMJVli6e23/HczfUsNjcIxw7/nvdrKkfR2zSFwg4fFjjIm262NH?=
 =?us-ascii?Q?nqVcZOqmXA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e13fb14a-b02d-4fea-2387-08da33a53d9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2022 23:23:22.2140
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pMe0Tbbgdo+Axy9dKtFVVnP7eiWWmNAilNuX1mI9G3RzBdl7Gu9and6M6x2nT2Z7h7WM+X5ukd2zIAwwB5BKOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5653
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, May 12, 2022 12:32 AM
>=20
> On Wed, May 11, 2022 at 03:15:22AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Wednesday, May 11, 2022 3:00 AM
> > >
> > > On Tue, May 10, 2022 at 05:12:04PM +1000, David Gibson wrote:
> > > > Ok... here's a revised version of my proposal which I think address=
es
> > > > your concerns and simplfies things.
> > > >
> > > > - No new operations, but IOAS_MAP gets some new flags (and
> IOAS_COPY
> > > >   will probably need matching changes)
> > > >
> > > > - By default the IOVA given to IOAS_MAP is a hint only, and the IOV=
A
> > > >   is chosen by the kernel within the aperture(s).  This is closer t=
o
> > > >   how mmap() operates, and DPDK and similar shouldn't care about
> > > >   having specific IOVAs, even at the individual mapping level.
> > > >
> > > > - IOAS_MAP gets an IOMAP_FIXED flag, analagous to mmap()'s
> MAP_FIXED,
> > > >   for when you really do want to control the IOVA (qemu, maybe some
> > > >   special userspace driver cases)
> > >
> > > We already did both of these, the flag is called
> > > IOMMU_IOAS_MAP_FIXED_IOVA - if it is not specified then kernel will
> > > select the IOVA internally.
> > >
> > > > - ATTACH will fail if the new device would shrink the aperture to
> > > >   exclude any already established mappings (I assume this is alread=
y
> > > >   the case)
> > >
> > > Yes
> > >
> > > > - IOAS_MAP gets an IOMAP_RESERVE flag, which operates a bit like a
> > > >   PROT_NONE mmap().  It reserves that IOVA space, so other (non-
> FIXED)
> > > >   MAPs won't use it, but doesn't actually put anything into the IO
> > > >   pagetables.
> > > >     - Like a regular mapping, ATTACHes that are incompatible with a=
n
> > > >       IOMAP_RESERVEed region will fail
> > > >     - An IOMAP_RESERVEed area can be overmapped with an
> IOMAP_FIXED
> > > >       mapping
> > >
> > > Yeah, this seems OK, I'm thinking a new API might make sense because
> > > you don't really want mmap replacement semantics but a permanent
> > > record of what IOVA must always be valid.
> > >
> > > IOMMU_IOA_REQUIRE_IOVA perhaps, similar signature to
> > > IOMMUFD_CMD_IOAS_IOVA_RANGES:
> > >
> > > struct iommu_ioas_require_iova {
> > >         __u32 size;
> > >         __u32 ioas_id;
> > >         __u32 num_iovas;
> > >         __u32 __reserved;
> > >         struct iommu_required_iovas {
> > >                 __aligned_u64 start;
> > >                 __aligned_u64 last;
> > >         } required_iovas[];
> > > };
> >
> > As a permanent record do we want to enforce that once the required
> > range list is set all FIXED and non-FIXED allocations must be within th=
e
> > list of ranges?
>=20
> No, I would just use this as a guarntee that going forward any
> get_ranges will always return ranges that cover the listed required
> ranges. Ie any narrowing of the ranges will be refused.
>=20
> map/unmap should only be restricted to the get_ranges output.
>=20
> Wouldn't burn CPU cycles to nanny userspace here.

fair enough.

>=20
> > If yes we can take the end of the last range as the max size of the iov=
a
> > address space to optimize the page table layout.
>=20
> I think this API should not interact with the driver. Its only job is
> to prevent devices from attaching that would narrow the ranges.
>=20
> If we also use it to adjust the aperture of the created iommu_domain
> then it looses its usefullness as guard since something like qemu
> would have to leave room for hotplug as well.
>=20
> I suppose optimizing the created iommu_domains should be some other
> API, with a different set of ranges and the '# of bytes of IOVA' hint
> as well.

make sense.

>=20
> > > > For (unoptimized) qemu it would be:
> > > >
> > > > 1. Create IOAS
> > > > 2. IOAS_MAP(IOMAP_FIXED|IOMAP_RESERVE) the valid IOVA regions of
> > > the
> > > >    guest platform
> > > > 3. ATTACH devices (this will fail if they're not compatible with th=
e
> > > >    reserved IOVA regions)
> > > > 4. Boot the guest
> >
> > I suppose above is only the sample flow for PPC vIOMMU. For non-PPC
> > vIOMMUs regular mappings are required before booting the guest and
> > reservation might be done but not mandatory (at least not what current
> > Qemu vfio can afford as it simply replays valid ranges in the CPU addre=
ss
> > space).
>=20
> I think qemu can always do it, it feels like it would simplify error
> cases around aperture mismatches.
>=20

It could, but require more changes in Qemu to define required ranges
in platform logic and then convey it from Qemu address space to VFIO.
I view it as an optimization hence not necessarily to be done immediately.

Thanks
Kevin
