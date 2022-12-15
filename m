Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5CE64D75B
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 08:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiLOHkI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 02:40:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiLOHkC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 02:40:02 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F562CE38;
        Wed, 14 Dec 2022 23:40:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671090001; x=1702626001;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=f0UCXG1l2YMGQbQl9QQFGxa5gnuJtuvH3YtSHS2caLA=;
  b=mfIxqAdSG2gDKzU+EDSbfaSHsRR+91Pt1cySIcxDuvLeuwAomYlfIaHx
   MgA6Kftl+oCRevCuThayedsYw0mqqqHe1IyS7SDZ7/ixixIXWHCxMikmS
   fXN5vij7gXIsJaYmAmhQgmVamHZCQ4fMlPMfwfwZ9RtNkLwOFccNtnQoZ
   WD2I/jdnM22E5rYf925VmsnCQeXhQdFSQn0kLW99BY3WIpFKlyRfZU3bt
   5WMmsfPgBly3o0keeqQ6Z5iqL3XyWyBf4s6pE0o0feEHy66qoceEL1Yd1
   fsTRkscWepGIaZ7YiGNxYptzro/TeRgbve2OHm2XjAo7980b/DRcMKq9m
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="318655219"
X-IronPort-AV: E=Sophos;i="5.96,246,1665471600"; 
   d="scan'208";a="318655219"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 23:40:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="738002147"
X-IronPort-AV: E=Sophos;i="5.96,246,1665471600"; 
   d="scan'208";a="738002147"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Dec 2022 23:40:00 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 14 Dec 2022 23:40:00 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 14 Dec 2022 23:39:59 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 14 Dec 2022 23:39:59 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 14 Dec 2022 23:39:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KkShIlP301bbVEIPfPUPlH4O5G5liY93j5yMBkh5QmaOKZ3YvD0HIQoKdUVSbBEOapldQjMkUUdvcezAuzSH2u1K+98PTtL3ea5OCCQ2RVweSxwlKm17FKXVyE7Z+QeeYL9T3hSBHMgL/u29iOipOjNN6nVKC2MPHDAzO7V1ruLGFXvgFLAMDU9XvkCsFVYF2jnm4nVWdCE0/VemT4A0+HWhvRMLPr3OXAXLgEz2MIk0pwXojLVMRD3nBrbuN3aumHD/ZeHtuwL6Dt1mIXuKN4qnKR0LKgem0J2iEFOtOCPCzmSVOCDRqvHs7gSakBp8GN6+76e88QmuIwUBn2ufVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=339xxGD8rlWTwL7IPaIaZiOHQuwoHdDHf2jf9CtSSk0=;
 b=CvCdQMwzoYZGrOlgdAsX/cAiAmQJZKqoHPlJ0MS+P5pEZOlMcJ8PyvOUsV7ItK1WTmyDNXb2Qk1JjY9EaV+sr5Uhmqb3oMkt+H7dnJ6GMVDX78mUUEf/IyPU2bK267JG+kcJNFQD+F6jdxGKHrMvYpIuACShpXWL997DD5btYbQtiGY8fksUHO1oCZdMnQXA+yNr190ijVyj+mr+3mRKTpUPdHclnrgZ8Md7flDV3Toie/Kel5CHZ4Bi682Akj6Z54deOQXz3RtwpazieqPFk7QcgvHkLuoB3U9QeUqrwWcyI3qI09HwlXBNo6ILy/u61zDl9N8fcqXPxZdSdQfBMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5069.namprd11.prod.outlook.com (2603:10b6:a03:2ad::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 15 Dec
 2022 07:39:58 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c9ee:bc36:6cf4:c6fb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c9ee:bc36:6cf4:c6fb%5]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 07:39:58 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Lu Baolu" <baolu.lu@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "David Woodhouse" <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        "Heiko Carstens" <hca@linux.ibm.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>
CC:     Bharat Bhushan <bharat.bhushan@nxp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
Subject: RE: [PATCH iommufd v2 0/9] Remove IOMMU_CAP_INTR_REMAP
Thread-Topic: [PATCH iommufd v2 0/9] Remove IOMMU_CAP_INTR_REMAP
Thread-Index: AQHZDloGpwHpsGl010Covp/ElC4tIa5ulATA
Date:   Thu, 15 Dec 2022 07:39:57 +0000
Message-ID: <BN9PR11MB52765519422E7EAF87B0B08C8CE19@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-10ad79761833+40588-secure_msi_jgg@nvidia.com>
In-Reply-To: <0-v2-10ad79761833+40588-secure_msi_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB5069:EE_
x-ms-office365-filtering-correlation-id: 54f12f1e-bd6c-4068-8e9c-08dade6f90d5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AscIOTaYxeD5GtHs36UfMelB1vbWQd/tyOxQXOrfh7KcUOKdC/fxd6Gc78fxu8edcFolBA9vpL1ddC4O1mNRSFN2mPHwVvIVnO3KTE5g0WeXKceJq9NSAFjJ5vBs5OVppQ4Jpb7NRm+cKrLr/4vzI6DV/OpWA31Bi1TuATFE+iYXsYe8ixq+8UkpmQ0sdg/ZmY+NeTlheluRYHwRO/0JoJGyMzAuBkhpC5PgMg23KXq3PD8Q3jTAbeN3yHrqrDDwPAYYgi1QTQh4noNYzjZTZqmPIwvZLNII3+N+maGZGqrxPc/qA8LEuRvqlGnroLHCxy2mlI57CtAipoQQg7cfiKcgZFOKNtn26WntCYAjEOr9icpcGxrR9CXiAy+JqwNlpteBNQDAi1chWWxKS1EFHQsEYJGWR6iaF/mcYVCed3OzcwkOSNF0BEY1stEBm8/El9wMnqXyr9BC4QFsiueMmsZVQOx5USbZRUvckP8ZApdJ08EGxxWmO4Jh1kCgwY4S3xfD8fOKB2DItmv9DPRY2gnGZmrQdmR9lrXxtMM7Q1A8KHUY+G13tlHcWXxNOHNI30J0OmiUfu+lAasW4s33CKBsYdbI7N8kyhhTjmx4lK12TiW7gsc6D33BGENmuvJJuLFgoc+HR+zAOsT0fANc779qRmcbY5p2kLEN6pM2FhntNQBFDQ1Qozg/p2sZbNIpai+N2HoqiGR51iazBaEtnT3+KpRhjm2xpVPBZO9v4wg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(39860400002)(136003)(366004)(396003)(451199015)(76116006)(4326008)(66446008)(64756008)(66476007)(66556008)(7416002)(2906002)(4744005)(8676002)(66946007)(5660300002)(478600001)(52536014)(8936002)(41300700001)(86362001)(71200400001)(33656002)(9686003)(110136005)(26005)(54906003)(83380400001)(186003)(6506007)(7696005)(316002)(38100700002)(55016003)(82960400001)(122000001)(38070700005)(921005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5gQC8KStDxPx4siP0e1eb0MLso21izJ5wq8A/UHUqwn8qPh2q73Vo8KMdg0o?=
 =?us-ascii?Q?RKBFHTKtHB6qIhKIAnnbKBIIjBB8dVSp793Z2KAPqpbk1o6uOMV5Mzp7/XcT?=
 =?us-ascii?Q?0qVZPnY/heGsIBKtwIM8vKOV+cn9m19Ppm+VTrskhoAEl4OBi22NFmnqJw+5?=
 =?us-ascii?Q?dj8tjXnwpfaaskMUtXkgU9hGIGWCPaTPKEf/DlMetA9pVziOH/JKq9R+M483?=
 =?us-ascii?Q?9lVKnesSAf/r6iDG5/rXbw/bUt8KXPW9kZeNNn9uW4eBX2WG5/Ldzhpf91hi?=
 =?us-ascii?Q?g0Mi+yNW+bUlLQMoOCLGzlK8TO8aRv8ejBtA6r6QGJGx/yLSO4/wEo9zOG19?=
 =?us-ascii?Q?qf9KBz2KbdNIGsO0FizzdJLj5tqVY8gC5ixYdV6PIZjRaVqHNrYHwQk5M02H?=
 =?us-ascii?Q?Qteg2UpsVaNhVdGstUQTvHpndhnDuykj4/q6jMRU5Hi2k4ttpPoa63VDSHye?=
 =?us-ascii?Q?CSdxvcHfQOIBqLM+7IULSL7B3fsIzhQnkoIx7+oLQdazML/WjqbOI9q5yRNh?=
 =?us-ascii?Q?nAzNCkhPZWb6rYw2x0WHv5UI+SMzdWUhuKGv+vgJN118y/Drpv4TZIjzx94V?=
 =?us-ascii?Q?7U/+xv4bhj/iXos1Ia+kFu+wgqC3MigUvRYFJBhtXJ/+4pfpz92sKZqL9jqM?=
 =?us-ascii?Q?V4A4/iDxgp9tRTpSaeykThdOevckJyiZ8e6Kpt1iZCmqQPRHaB0uGy8aYYkW?=
 =?us-ascii?Q?AdWrbc5V4iPBmahS//GfnINQKudeJMHGJeppDxELVB+ERIprMyZxohBbrxCD?=
 =?us-ascii?Q?hnu1SOIeLEyNGFWGc8UKVvhLIauw4KgIzRbfWeRfDsC5odS7VndgoKIen/+v?=
 =?us-ascii?Q?oLwCbK1NElYQTdN0BiKWfs54Ac+YiHkoxn4CHnq5Ny92pQq3lD61nRIwM6U2?=
 =?us-ascii?Q?tp8eClVjs2ZKuM/vKaYxk2GM9543k7JGJxf5wAJ+63N/JT/uLjJB2TyFRm4Q?=
 =?us-ascii?Q?wtczxQTJ+Y+0me9MJzif4ftOgUA2uR6RS3sWUg//C3kdqSzhBwhLYBiQE9W5?=
 =?us-ascii?Q?ftu7+ArPu6ZGiAqlBQnZGLTG7x5fVD+Xtl2lfNJQOre5HDcCOtktZUjWAmc0?=
 =?us-ascii?Q?rrQUFgNu8dNXxkpGOzKDbHSGvfFuvrA6t/8Rbaz1dbWoi0zfClf41P1SrsoW?=
 =?us-ascii?Q?sLr0d9OZxjbj4i6IxBChYDZ/Xz2LrrA9dMUuPRuASexwiURKzPfblYyxkkSL?=
 =?us-ascii?Q?dgLEVYdR7dQ/iGJlcTl23R6r2y1hk66Z+PcnW+UDXSG9084NZaOhy+TGkSRp?=
 =?us-ascii?Q?txmznw8CLw7bdttF7dcmN4tpvIofhoT69Kxb+WyqE+GgkHayunBnuZYU/scu?=
 =?us-ascii?Q?38H/C7lEKEtaWBPrIFLdba+G3V2ZnQDqwN8FfdkEqh8+KeK8SSuVtLFajjUs?=
 =?us-ascii?Q?tJYDsPwF0sNVFAohzZemjed6OHv8+4Ig/I0wVMUk4GcSYdYb8d/580Qsb8Yw?=
 =?us-ascii?Q?b3ndwkt+aLSWGDP1cezbLlCRdW6hISXSZb0W/0Iv+ji9w9fkFK2C3M1O/qd2?=
 =?us-ascii?Q?CDEqnCv8b7wld0Fbn1DLpD06txlCsoSs45vS6dl/+EAsyUM/1fNHnOCll56G?=
 =?us-ascii?Q?sx4eQWJT/jT53v3r+Wo6nehhzqzkN/PCJbnapVF+?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54f12f1e-bd6c-4068-8e9c-08dade6f90d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2022 07:39:57.8528
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0yPKRa7njprWdtk3CQJwDrE8B8uIW4v5nITHBlzWJ0KXuSXPH638tpkVaEa41mbQratN3t1sQMnk11s5iXSJ9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5069
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, December 13, 2022 2:46 AM
>=20
> v2:
>  - Rename secure_msi to isolated_msi
>  - Add iommu_group_has_isolated_msi() as a core function to support
>    VFIO/iommufd. It checks that the group has a consisent isolated_msi
>    to catch driver bugs.
>  - Revise comment and commit messages for clarity
>  - Drop the VFIO iteration patch since iommu_group_has_isolated_msi() jus=
t
>    does it.
>  - Link to Matthew's discussion about S390 and explain it is less secure

Looks good to me:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
