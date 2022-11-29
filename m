Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 636B063B818
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 03:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234973AbiK2CnV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 21:43:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234828AbiK2CnT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 21:43:19 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 169A21C918
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 18:43:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669689799; x=1701225799;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=w1/s09c7n/gVH6aPPANNQw3o6gIm2vVn03Nac9bmD3o=;
  b=dQZ8Z+pIrqm6J0C8lFg+dDE81YszqwU0t1P25p8hgj2C0qlfbD8XSn5M
   0s+orSeO9Bkk6mawwpH1TFmaSQGfMAQDjs0sMz1cnGnNgHAfvVcE/ZQeD
   AYvslPZF9b1mcIxw7Akj8jVpOFmKSLYI1YjAxCbuT2GtGI5kO9M+4cefO
   COhROLw+T8rqD4KOA1CWVqYLwGJ424PF4Y0mJJCpuv0rtnhkx1B2Rl1JV
   lMgQDS/TQPx46PS+AurnQsusqhqoNAlQbeSicle0fqvXDPOvVdze187BR
   XTawF8F+OJwMBIzNUVssjJMmP32/t6hGCKFrCxeruWFuZ3t2V2E0zHB6x
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="379267401"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="379267401"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 18:43:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="645729985"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="645729985"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 28 Nov 2022 18:43:18 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 18:43:17 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 18:43:16 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 18:43:16 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 18:43:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eTBegMF4KumNauJfF7liEl6Zlx7AYzN+JsfEN5Y6lq9PIbJlMDfQcNRC5oofMcTIPHD0JBH4NmoQgaAnkGa9EGKuovLFdlz97kuWMXts0AamgfQfIVVT/oxrXaXqB3LyKIvrEi966LJoVDJByEAXC5CnLSew+nJXlv//C8wHQkYrD8rsVXfXX77EvZxtAm8KHqr5NTs9kg4SipAcua/tv1WIdgtKhORmRHYm+hgiaIEnYgn5abbI/XcK1erR7I0EctuYmZEIkmEZxRJ7NNM9CDWCgqgCMwahTZTU2Eu1x0epgRGlIFlE8SygMPCoWix9yb4jg7S2f7umUNe32LbXAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rY1mh/nMMdHxwR6NNbGaxsYyXdFyLA16fB4Wg3ZZrac=;
 b=XJBW3y2ETgyqy0bcGcfLJABW5ni5q62rH0oiNmswJ1+8ZW5uvk4I/GwaqSSKhKCe6IdtmrlliQsqrLrLtGwrfGfjREDOKtyTGoo/6mjd0w+RZ6szxGhXGaFyGAO7VWdbTgIPMtCti52/IZDFQFHnam8dltuCYOouWgpfcDDgAGFRsKAypQ+wbpq4iaL0cG03GfZw+NCNwQ+/UJKMdRJ99EU/FQ8PI1C4TJJ7ZT3EOuJIpnMSIt4EdTMinIIw9YOLmug2T9G615hD3h5vWny09gz9SVFSEZCPGzkvzeH3oRQcCyHbAApOqlSVNTWSiQ0HKP6mJASgtO7oiIjYY3/jvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by SA0PR11MB4623.namprd11.prod.outlook.com (2603:10b6:806:95::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 02:43:14 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::7a7f:9d68:b0ec:1d04]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::7a7f:9d68:b0ec:1d04%9]) with mapi id 15.20.5857.021; Tue, 29 Nov 2022
 02:43:14 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>
Subject: RE: [iommufd 2/2] vfio/ap: validate iova during dma_unmap and trigger
 irq disable
Thread-Topic: [iommufd 2/2] vfio/ap: validate iova during dma_unmap and
 trigger irq disable
Thread-Index: AQHY/0JNDOImPJXOIkCz+4x7weUmDq5NqDwAgABiZgCABnZsAIAAUF0AgABoNzA=
Date:   Tue, 29 Nov 2022 02:43:14 +0000
Message-ID: <BL1PR11MB527190E7A635CBCFD185C1CE8C129@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <20221123134832.429589-1-yi.l.liu@intel.com>
 <20221123134832.429589-3-yi.l.liu@intel.com>
 <BN9PR11MB5276E07F9CB1A006FAC9E4098C0F9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y39qrCtw0d0dfbLt@nvidia.com>
 <eb75c2bc-8142-116d-6b03-7a79bf7aef77@linux.ibm.com>
 <Y4UZ6rlEIHGzP6pB@nvidia.com>
In-Reply-To: <Y4UZ6rlEIHGzP6pB@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|SA0PR11MB4623:EE_
x-ms-office365-filtering-correlation-id: f0ce93d8-dd24-4e50-c623-08dad1b37693
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s5N8XUQ6nw4FQIN4EKDVla/a7y/ag3/fOAgrTL5/dkNqi8TgTnVyi0W7koCD2WAlPYDlkzAwhFO9IGirDv/DfXipl2rTvhh5Skyoqc3gnTKrquhSxOwzLnVWqvIxmisvTRp8nuhqYhym8MM/aN832B7c08FTupX/TcndU9tgOiSXr1GsFXDvFzWtWGRkv+bJGXR7HM8MyvNvez9OVrb9KfkMztfmHCCbsaDqPKxcLekq26UWAyWK0kw0puMIHc3KGw5yv5JeI4w6XiTs2MVfmVxJgTqZpUkppJk98BNDLOkk22ivVf3rFNBuLija74ZPDQVFG/NA5GU+4WQfHUMiYiaH47tbOHyPte7R94iPOwhu+b3TEuJXS287f52Eypm8GWO/kDjCB+0kf9ziA7WZJpqO7S9ffpz5qrvaMP9Afnej7LWWydJEx7dWwLUI9zrCFw7NzYg9DQe/DPRSyv/4ks7W85+73HsVjjaZMavd4J08nyLCoHZMDzYN2OyhmBC9tWqvUr0/OKcyjJ2PxG9rNQbphb1GYxyhchMfXU/0/O4WaZIQgJpGTlN3BcYgTv2XJOdu9LHgGAfAemyTVUcNnAdrt2lojyelJAqWTWniCmcPQW9AkGQbajVx98WwpzFM2tYb9tCfFkdoJx6NTMLc61OynjYHh3cl0PiCM0mIzuJhqqrKZvMJgvciG3oyqtga2O9SzngJ56JlxVJCnHDD5g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(376002)(366004)(346002)(136003)(451199015)(8676002)(4326008)(15650500001)(2906002)(5660300002)(86362001)(33656002)(41300700001)(8936002)(52536014)(6506007)(7696005)(55016003)(83380400001)(9686003)(26005)(53546011)(186003)(54906003)(110136005)(316002)(66946007)(66476007)(76116006)(66556008)(38070700005)(66446008)(82960400001)(71200400001)(38100700002)(122000001)(478600001)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HI/MNGk4T5fXh6PKCsCEN3c3h3suA7nRzJo8+u1w93ESXoIgHpBcXdnfXzIO?=
 =?us-ascii?Q?1PsJ3ll8enu2r1lQaI0TvVWGTvkTzBtWeq/ddHC2hY80bUBsuxjFpjZOLYMS?=
 =?us-ascii?Q?l1nAcxxtuWQBPhFcraHrcwXQUT+BBjVawjzvOOBVEAaD44lKjGzt1yMcy+/+?=
 =?us-ascii?Q?DB4EZrVOU+AM8Tb/Sh76geULL6eUnNFG7j7rnmRCFIFYEXO+H9PunU1xmm5O?=
 =?us-ascii?Q?WomYuz63+VaZOCKABvFMN31wd1uDlukAXx568EUaZ75iJGx1+8hhu2eUm7Zy?=
 =?us-ascii?Q?78I/DOyphAGT6OECtEowNagz16tL5O7Cq191qzZtDEan4N9iNC/QLG6qsKHC?=
 =?us-ascii?Q?MBkcZ0d78R3/AA0CRe4YWgY5Se49TYFpGdV5ppRopVBjt/n4RENcpR6VZvzc?=
 =?us-ascii?Q?Fcs0+7R8Tkl60jYT0gHLQVaekDLQ24vc708qlmtiq+DPieeqrTG7YcDfun+5?=
 =?us-ascii?Q?4t1oJszC9wB8LesiXLT7EGsJ1mWQBJLmDlDyrPFFjSfvT8HVx4L1nkhLYz9y?=
 =?us-ascii?Q?4T9W4hUfFfBqqUhFYhCZqNAq1f5OrjoY9oEpGhnJDa4IidBSWMeziwpGky7X?=
 =?us-ascii?Q?QX6Yr76+wDX7ayfGoRl5UILVSwuAytFBFl3R7VyNxrzyk8K0SkTeqvCtV8KV?=
 =?us-ascii?Q?l6awqQmE7T+IR+fR96hPjHyArw/IKbCzufX6U0nLIr/1BZs633QkGicDsWfY?=
 =?us-ascii?Q?RDclwmC0733FRelf6D0TdfO1xbxfshtTzIvqPptSVrVGXy2tXDTqPCRTOk9n?=
 =?us-ascii?Q?3i0IzODEALbkIRPwBQL4W9+ydIK4+8Ruj9lB4Om3do310Pq/3RiMhomrPKrS?=
 =?us-ascii?Q?v7NkDDmgjHM0jHrcYt/INgYsMWXX9qQoE4nKfhKT9eiFhdAJAwOBnFT2qJ/4?=
 =?us-ascii?Q?zziANGZMAOOkPt8s29B5rd5IrlZG2SDZZIJHbVS74BAVMYAZkE7KP5aIH46s?=
 =?us-ascii?Q?AJWLQTwf/ovkqt0619+dPUTH96F1b5iODdT4Kl4qe/ZaOoDrKdsbDkR8xMfy?=
 =?us-ascii?Q?4ca/OcCsav6B45F9RwHjjWQpzS1UO+lrSXzfH9asTNek8A5vTu317+NrfuC+?=
 =?us-ascii?Q?iybE92HtMvEA9iH9JQLgoH1sfVhaiJJeheUj9yMRogW7U/8cE9xJZoyAhjM3?=
 =?us-ascii?Q?6gD6ql07k35WvOzSR9WyzLnsYAE4Sh+pC8FPijCAzhLhqHoPFiqVapmfA8Ns?=
 =?us-ascii?Q?PiNZpuYZ/QqiGXvH8QMB2rPrT5KpNCalCtymQxaehLSSNYvDJYzkCDdX/nJJ?=
 =?us-ascii?Q?EwW9iycunfUkabofpnXciFkBYZfi6mm1v6qSBN6wh1YribhXOQ6eYQYz9MWT?=
 =?us-ascii?Q?amHLt+G0CyE0D1mlRWOS/wjXJBvSvsiWgfz4xwpZhVNoQpzc/nVEFC779VwD?=
 =?us-ascii?Q?DhDAo78ymMc1YgeOAWhiyFL+f7+VRRAox45a/VDmzMMXeVO33lNajy7jOUDu?=
 =?us-ascii?Q?P4byvHSWA/60a4sUf5enDirDCmxfuD7dhmUTyeQ9v0BpqR5BvydG90iCVm5u?=
 =?us-ascii?Q?shCVgvktD349TJN+SOfBWmFQsycQloKfn6A0RfH96ygLMFuxah4p/sykzsun?=
 =?us-ascii?Q?YljfEDpy3LQcmBxB5P93WTc6yUs3rm/Is0fl6S2H?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0ce93d8-dd24-4e50-c623-08dad1b37693
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2022 02:43:14.4625
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wPv7AuYbhxo8hy2wCty83aazPAUvOdwvvMSWTm/1KbtbEsRa05H9PsRingcalimuQYRQFr+1FsKW9yeo4/0DdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4623
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
> Sent: Tuesday, November 29, 2022 4:28 AM
>=20
> On Mon, Nov 28, 2022 at 10:40:48AM -0500, Matthew Rosato wrote:
> > On 11/24/22 7:59 AM, Jason Gunthorpe wrote:
> > > The iova and length are the range being invalidated, the driver has n=
o
> > > control over them and length is probably multiple pages.
> > >
> > > But this test doesn't look right?
> > >
> > >    if (iova > q->saved_iova && q->saved_iova < iova + length)>
> > > Since the page was pinned we can assume iova and length are already
> > > PAGE_SIZE aligned.
> >
> > Yeah, I think that would be fine with a minor tweak to pick up q-
> >saved_iova at the very start of the iova range:
> >
> >    if (iova >=3D q->saved_iova && q->saved_iova < iova + length)
> >
>=20
> Yi can you update and repost this please?
>=20
> I don't know if we will get a rc8, but we must be prepared with a
> final branch by Friday in case not.
>=20

Just in case, Linus already said:
--
As a result, I'm now pretty sure that this is going to be one of those
"we'll have an extra week and I'll make an rc8" releases.
--
