Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF35467582A
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 16:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbjATPJp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 10:09:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231282AbjATPJl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 10:09:41 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2849D88C4
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 07:09:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674227380; x=1705763380;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tSwHjKSng/hUGGZ/JBDGv4R8/A+K8y9ry9vIVOZ3KPk=;
  b=F4S0ihpDzFURaPkrruIHFMAJO0UVDd90zEwEseeoOLCL9/dYps7uI1Wv
   6F6UyaUAfqvWHc5z3SxIStCxvREUNakrwtYXOw6P6pLYc3gOb1tvH43rY
   xmR62CeEWPVM2KRaFClN4ZT9Cyp4zz+O1vRW19AWlIsQi/Px0MK823Qix
   p0oci+NLI3QcP/eccxkMBiHFLOU02irrFKPwRyeRlgxEjiKkwNfXKMb8b
   TbB86oVpkppEqgqLxhGJXwrouzySV1xvl8Md77ZwJo8S9i6ndViGqrJec
   uYNvPL6O1iDuDRNaiqcd5ANPgNoqMvqdWv5iyDuzOA5vgJz2dPOHyMcVr
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="325634108"
X-IronPort-AV: E=Sophos;i="5.97,232,1669104000"; 
   d="scan'208";a="325634108"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2023 07:09:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="729142250"
X-IronPort-AV: E=Sophos;i="5.97,232,1669104000"; 
   d="scan'208";a="729142250"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 20 Jan 2023 07:09:39 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 07:09:39 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 07:09:38 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 20 Jan 2023 07:09:38 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 20 Jan 2023 07:09:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QM9cCTrULM2fWG+b/sjGjfd1mttHR0Y8jSpyDXd9R7tes7EnwLRKsnSiHcrtosrscxHQYIuG1BLSs7YoBByaOrikcn2BZKSbcGF5vL3BlRmkBplFR6IwLUQocVxriAI+3fbnXV3kcvfqQBlmNx4EM8f8iYVH/1Q3Ilbp1x1Ci4uTMqeudEI9BGdrzoZ7tGTt6F6cQOWafVXcdeFjHCRO6M6PXdYHQUT0W8ncMTeIJKvsUlV3KJCY0ej9xF6YA53GNCJgsgCF/H80NxTqEDIChJBcvvFpGJLT6Wu8MKtvLR63YtsArIipDU1K6LGlnlaxQiNdRSzbniDjcxfjWHwoUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tSwHjKSng/hUGGZ/JBDGv4R8/A+K8y9ry9vIVOZ3KPk=;
 b=js3O7vnIN+UEHF732w3LhJRGP4GL5DHY10/PHDZOWKjI2Uviodxoqn396cMWnhrhgBll11H8C+4P4zvinNLqgeex7y6lgRsu4Grd/wXriQ7vLa2KRX3HpxkoOa4IWl1PU63dId4uEzb5M/cdiOPvyWY0tLvjuyC1HcKusrLGeUjaRmRT+e143O3UoghjPTFd1ixGbP9tM4CG6Vhs1hNT5IlXnu227KkC6phQD7/4Cb8qXM6gkwIMJdEYayDQijc6FmRGcajEh+cZYrWlezaumrs7H8YowxiTS5zTA7/4XJuWu7nuHxT3fbKugnOKhJPnmgxKUVxvcf3RR2K57GzX7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Fri, 20 Jan
 2023 15:09:36 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6002.027; Fri, 20 Jan 2023
 15:09:36 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: RE: [PATCH 05/13] kvm/vfio: Provide struct kvm_device_ops::release()
 insted of ::destroy()
Thread-Topic: [PATCH 05/13] kvm/vfio: Provide struct kvm_device_ops::release()
 insted of ::destroy()
Thread-Index: AQHZKnqZqWxc/vWNRUWu7aJW7tOztq6mHXaAgAE2HMCAAA/pgIAABu7w
Date:   Fri, 20 Jan 2023 15:09:36 +0000
Message-ID: <DS0PR11MB752955307C6C30D92938C914C3C59@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-6-yi.l.liu@intel.com> <Y8mU1R0lPl1T5koj@nvidia.com>
 <DS0PR11MB752914C92FEFC0DB5278D8D1C3C59@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y8qmUa5RORED9Wd/@nvidia.com>
In-Reply-To: <Y8qmUa5RORED9Wd/@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH0PR11MB5832:EE_
x-ms-office365-filtering-correlation-id: 5d909980-081b-49e9-445f-08dafaf85847
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: frJ8p0nAl2Amx1h5OB0wr14PDgt/GaMtLKKoJxosAE/xnsrsCuKd/nAvhHU/aB6i+mnfECxNnibU6jZSi3Wiuy7yzWNDKIx7FJ7onrPF4EZz8+wsX/C4D/sHUzLXLRsdQPALnPie0D8+k8RtwKa9mFMfGV0hKnT9l7XE5c6g19ruBD+j+eujcTyh1M1F6C3BHiwvfKY1j3bNnmRwcgdTVxnU0qiGSyFZtUcVpa+2/Y4CxhstKuGv2wDPNG+Cj1s3I3p+eCU8LLmQwErtbU1HHgwPAtyZwrKu72MLUh/g0PhYwS9Qp8ItCRYWa5WMR7RlkAXfd9GnBJ84FI4zgKtFjrMUfJYAEOGxEa79UmkLHAbcfJf/YQGJtlcflxdcByAxeAflnezv9cn1oyOfWpLjNTvmHLWg4pVW6QU+l+q3dkCoXnbotMY/vLE0g5jVey7Ec2xqdokfybhQk1xnNmNYOMGPaPZB2bSf9UoYWFgYf1YHMfWhN/un75fHzBA+VHZlp/qDo/ERbT1zDYtmDlCdkGCqQhUvCR8mDqpiPPRnHTpfDFv+nSfkX0cEdn3qlnmiUNNtRBWqsFmuobpHe5OPRw19O4ntUZaqNXudgSINeWblmSLjGtM2NBCi1l9vLAbm0z8dDpkcwLEYrD0HbjUkmUjiOwYiYRji78Lbfh+82PPznahSApVQo6hAFxA3EzVVR85cdsZzvzVX2p9vhlZoTk/2EtkwQdwb4qa1cALQ0Sk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(366004)(39860400002)(136003)(376002)(451199015)(38100700002)(122000001)(38070700005)(33656002)(55016003)(86362001)(82960400001)(7696005)(71200400001)(9686003)(186003)(6506007)(26005)(478600001)(966005)(4744005)(5660300002)(7416002)(2906002)(66446008)(52536014)(66556008)(66946007)(8676002)(64756008)(4326008)(8936002)(76116006)(66476007)(41300700001)(6916009)(316002)(54906003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HGyAunB1MDqSvUD7w6wnJnXeYuR266hzENMvLVjqhpqnabZm/JOA0xKlLF/o?=
 =?us-ascii?Q?maHgXtDV1huX0o5+LA+ZX7po+o+RFh1B2uPhfYC65wx7y74rXxKAtV4Wv3Dk?=
 =?us-ascii?Q?eixo0Wu4lQn9MljVzpZe4rJpJSZRE2v2wqpI/hZggpcx6wMAY67BBH2B6vha?=
 =?us-ascii?Q?PLh05csDvlRllMSyjNYRtrSusUcD1FhzLD54t4R+NBBkzHJsFrITUWuqDgsi?=
 =?us-ascii?Q?TyMw6hWm9Qg9XaavZtUqv24wFsdXvShcjB2vxTpZph9Q1DND+sLUxqFqvnR2?=
 =?us-ascii?Q?kP7FYoWwnWDitEMqi+qiWik/IEudQGem2pxuS2ibmF82ZaBzKufNke13MCfy?=
 =?us-ascii?Q?d/yXolj7l27ObMRRvJXutqSGPXKh7XtxhAzHnSeC5Vuj9gfXznZxQGiJ8lBE?=
 =?us-ascii?Q?4gofKoROOYFKtebTV/cZj7/Tay5cj55nNHsLlEGT5elTm9zDSorAMtg2IcCz?=
 =?us-ascii?Q?iW2lDxjDApAlP0TvyyNiQb0YVL3oD/3vGJVwvyJK/GlFNHdZ1cwljVfQ52R2?=
 =?us-ascii?Q?wKEMf45FP7cVJD4QwyykfwAeVpbzSMffTClf0eAGiRw1nagA7N4BjNZyN2Zq?=
 =?us-ascii?Q?7vx6EummOw8VgGA2xbN3fceTz7ObTRUET+yrZVPpkSui/RLaZqtbo3mP2fRu?=
 =?us-ascii?Q?2v74q6XJjIzwIp7ijtRv7dw0h67eGVFXFNJaJjLcAxFFDyMPB/muK+UruUUA?=
 =?us-ascii?Q?3Nl9cjEW3MyzH0L7KQIndQrJPDx0Re/eadnjqDMeujpKkJY6EWMktfUUgu2D?=
 =?us-ascii?Q?VjEjbIoqcm3G1PNSZkVtxPxoz7EUIPS+vTK+IH/4YDZ2fweGe1ktWLSxOW5j?=
 =?us-ascii?Q?7RAwH563Fdo6uAOe9acJme4dBI3iX2fSDbH1P0+FpqNrXdEnJXfSmF5NVPDE?=
 =?us-ascii?Q?4Os7mtiOFwD2EUR2QQdBzlw3FmU2iEC+CsogoeuXGD8VumqE/UwF0+SxnikY?=
 =?us-ascii?Q?QEFVjqMwjWP2L7w5NRn65M16+p148jwUFldLh7ccYw5AtC3Mgj6uckWfmf6T?=
 =?us-ascii?Q?rDXotaDKwWAZR8I0bwDd8PKyvuuUovGg5vrRV5A3tOQOGPXdRJgarXRTEK6D?=
 =?us-ascii?Q?dZ+XyFSfiKfXgdoKKJOEKZyFFNKYxK096jj/1aTlQfZHIv3ZU7Q012NrCH02?=
 =?us-ascii?Q?CpYlAYhxRLuVe6wWal2imuvEpVegaGl9J6QSAwNr2VXaAR8W8EtF54E4ban3?=
 =?us-ascii?Q?FrBsAgBenZf8s34QK6fc/TwmV/i2e4YdxXSXvfCXwN9axnzeo/TMOXl3BwO6?=
 =?us-ascii?Q?dqgRxAsRktKtKOLPZyL7xU7OYE0I+NXRjoC/TTMqKn9zrYlasGql0c1s+j/t?=
 =?us-ascii?Q?OCSVPiz6l5xPFQ19OKsaF5fakgd9MY5X+Yl1HneiSKvxtNk/5qQFEjR8hRdh?=
 =?us-ascii?Q?phSBsG64i/GsGNeusMQdakAkpM7iJVLouLvmpcUu7wmx106QGs5nm3VPu/Cy?=
 =?us-ascii?Q?3D27lTo6kyjFPpBwHvPBPhoxC4XZMn/EVcVd7Jkjzs9KJwODDCYvcpWpB1cQ?=
 =?us-ascii?Q?DGJwpkKi/BcR1Ayeb7dfMXkWxIvpRm67SxWTiKIFidU+yrgLFBaHoK/2bJwb?=
 =?us-ascii?Q?5Q95qXrNV5m/laTD7PWrK35P6lTJglqaiKD1cEzy?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d909980-081b-49e9-445f-08dafaf85847
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2023 15:09:36.5607
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vwNFDz+W1dfwlth1Ccc/zhLEsa34F0hbI4Ei9DU6hByflxGxBag3VKADOyOe34hRcVADuMGpO2LDOMFD7BsWnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5832
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
> Sent: Friday, January 20, 2023 10:34 PM
>=20
> On Fri, Jan 20, 2023 at 02:00:26PM +0000, Liu, Yi L wrote:
> > Say in the same time, we have thread B closes device, it will hold
> > group_lock first and then calls kvm_put_kvm() which is the last
> > reference, then it would loop the kvm-device list. Currently, it is
> > not holding kvm_lock. But it also manipulating the kvm-device list,
> > should it hold kvm_lock?
>=20
> No. When using refcounts if the refcount is 0 it guarantees there are
> no other threads that can possibly touch this memory, so any locks
> internal to the memory are not required.

Ok. The patch has been sent out standalone.

https://lore.kernel.org/kvm/20230114000351.115444-1-mjrosato@linux.ibm.com/=
T/#u

Regards,
Yi Liu
