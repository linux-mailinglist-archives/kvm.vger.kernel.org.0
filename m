Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 464684DE6E2
	for <lists+kvm@lfdr.de>; Sat, 19 Mar 2022 08:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242446AbiCSH4N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Mar 2022 03:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236778AbiCSH4L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Mar 2022 03:56:11 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31612E51A0
        for <kvm@vger.kernel.org>; Sat, 19 Mar 2022 00:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647676490; x=1679212490;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kb/8QMZALy4TulD5zTDofUMTXbNX5ap1wTxUnojwcTs=;
  b=AV9ETw9r1R1peBZ+ysCEIUQtre121l5ob6/ZkUKjMhkW8rHtCHVYUDLr
   9uhvl+DP8TZF/aTBu1fekV+MsxkTc6BaSYUHs+ABps+5at3Er0bSVF6+W
   Ewd4/n7PN45zojYyVkQNF5aXjBnqg4Mf07VFhz3jG0RsWbCgRcgio8aP+
   WPQmw32Z71GQFYXVeJG6aft6Lcalk58V5o6VISjQNcheDyvKmRvNmgH0w
   uwKw1L7QdcTTAkgsRAJdXQZgz898gt7LJPARIdZp3yvNDtzU0r15OllRL
   e/cKoXhFXwtVR8Rb96XWehhdQhL1QHrVHBj1HNiK3Z29jkbMseWMw4tfP
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10290"; a="237228281"
X-IronPort-AV: E=Sophos;i="5.90,194,1643702400"; 
   d="scan'208";a="237228281"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2022 00:54:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,194,1643702400"; 
   d="scan'208";a="691595568"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga001.fm.intel.com with ESMTP; 19 Mar 2022 00:54:50 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 19 Mar 2022 00:54:50 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 19 Mar 2022 00:54:49 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Sat, 19 Mar 2022 00:54:49 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Sat, 19 Mar 2022 00:54:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GNnITFSGjr2HChOHVDmeDxqdF+wPtAXKfAV6pARDvceU5SAZbR6eqMoBvw7FVDYGs9fOoIotVYvxEMkkPGdB0xRami+LZ+zyz6Z8MZxBk+IT8gkBlXpObSdSvOAXQC1H8A4YPIk+HMD2zI0cS5l7dOzTzHaXiaX2la9yHev+iWMBwPPu4rEhCNLEapWb2XEMvb+vDj05lYUEcRcwDFNDCRVtcGbtndJu4IcAp1WWt/rAfJ1lxy8cuDfKheHb2NHshX43fz/TxYplZOz31PQN7AX10IO4T16HRV2jBAnWyqZvu+qQVBG2jFXWUinjTggg2iCJQ3/cRqVvIP+XnTP+6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ll8uCXY2VqrWTqs+T/xCD964ILt3SIFUEv0qr5w0Qto=;
 b=WvL0bZgHIirrBdOkT/h/pRgOp+2dkukvvKHZLESopXm+OB5eRq+Pd/0xNfxjzyf2/fq6HLx2rvYFyEBSepOtfxpNKtT7LpYgcnp+yFNaY9R7IoROidNSYE/x9MLWJ4EDZeSBU5NrjAlujOaDqGgSyQVyjzo42kkOFlsNU7OC0oeroskCwWDMUS4cw+JcD8+09jpKLOBamQjX3o7InAAxAxFwPSzCLOK35jupXO1t0DIN/y08hCki3c0qlOGcss9ZTyuHTPwVt2b/JyliDhWcbSmIbePk9iYqLP5BL+XrqZ/ro7/dw00oVdRpVIU7M8CIErcXsMZ6gRgdDEdCm/vuzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY4PR11MB1494.namprd11.prod.outlook.com (2603:10b6:910:6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Sat, 19 Mar
 2022 07:54:46 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893%8]) with mapi id 15.20.5081.019; Sat, 19 Mar 2022
 07:54:46 +0000
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
Thread-Index: Adg5jKKwvNkxolKnRPWJ5nYfZVngmwABAPgAAEWHdcAAB6sPAAAoLtSw
Date:   Sat, 19 Mar 2022 07:54:46 +0000
Message-ID: <BN9PR11MB5276DB30D0EF5CA08C97A36F8C149@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <DM8PR02MB80050C48AF03C8772EB5988F8B119@DM8PR02MB8005.namprd02.prod.outlook.com>
 <20220316235044.GA388745@nvidia.com>
 <BN9PR11MB52765646E6837CE3BF5979988C139@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220318124108.GF11336@nvidia.com>
In-Reply-To: <20220318124108.GF11336@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 644493c4-2e88-4bb9-b285-08da097dbc8f
x-ms-traffictypediagnostic: CY4PR11MB1494:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <CY4PR11MB14947866C9975F160EF3219D8C149@CY4PR11MB1494.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Vvye+lRYTNYU9BOszniA8jsfY91J/CwSTtzrqneBKTTbVGds8X1Ndox0VAC97WrrlFDGTDLSsC8rFz5tvYBsCYqqSk7BuByUErxFfjYRR3IXoHeWEFziTl9Ru07DCuMvnbG5OavVvf0M++GYeovSesnCq5rN1X1orAGR6+dyYhY6bFHxCc0Y9Ka1KhVh5tNm3/mxgoeXlmb7v/dtRgt43UXN/klaGfBjleH2Aa8Sx0UnheSYJO2GpNLyYzZ+VpcY3sqcqQUFFMQBp40VN37UlnocZNLgXMNxEdVVDWJZocGgg1G7M1ateXRI5UDQV7vD3ePzsSFyFs72e/HBTksoPqTyjd3M9h/WFndhfEMxl4oJg43Q91sYuf8VLjh6d6Wtqc/ZrnI5rwaWvwJTNa7AP1748GrmDgrjxq0S75Jp7ix9hWxZcf5/Dzqmty1MLZanW6h+KeWF7LxQ5c40iFq92DYpCktjnaOQTe8tRakSrFP2ecjHKMsTjVOooZ6InRknZucaXNSv1LZVQinKeRFl1+Z8MqrTMDdfm9c5McMfvyrgzFXcdXEBGYiibNNt+D60PDMTHLs2zbL334JEol9a2eNbUnJ+Xp+cboTsxgvM9BfOmY/9Jg0/E/FdRlN7gC/8bHc9mU+xDCkPxta3d2SCLR+Q7U6l8Ds+ttgbL5O15XrQK51uIQwSgchQRHcug70oyuZth7MO3xhk1VsAk6QtXUO9wmDmUiPGpbvr2ms7F14=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(8676002)(66476007)(4326008)(66446008)(64756008)(76116006)(66946007)(86362001)(38100700002)(508600001)(9686003)(71200400001)(26005)(7696005)(186003)(55016003)(38070700005)(6506007)(33656002)(54906003)(8936002)(5660300002)(52536014)(7416002)(122000001)(107886003)(2906002)(6916009)(83380400001)(316002)(82960400001)(14143004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qo85aKANBqJ8GEcssXWk6VQJrwBJHxA+f5+u1QvM8u7p09LGFgA86S95TEBt?=
 =?us-ascii?Q?MG4KMw191QMgjWd9f6kX3ZeXZFr490AZcsh9D8lzLtpeNxMuwCO5sRYmy47L?=
 =?us-ascii?Q?remTR0u0B2w5IOSicX/AlO9QmwBUgnnNoKpfIFnCFg3RXvBF65SFz3ilOP/1?=
 =?us-ascii?Q?nFlafvXiqoVfd7X1lOsNyhDrmzwaOd1DhOEcYQD8cNAGX8YgaQdVdiTdpCzQ?=
 =?us-ascii?Q?beWhYQUs8ePsbxw9oH9MW8Xx5/kgImjfmv+fMsUL71y6Gut5622JiE/v1MtL?=
 =?us-ascii?Q?jVPiDQR2OfOgC9OLepHqgGaKv8yrKPFXCAwFL8p9vgYzHU3n/btRtl/lH558?=
 =?us-ascii?Q?Q1+9g4ClAJIGmv/qi9W0CVgRJd7F355HIgyODqcWB1Mn1mdcfGtYzTC4rDTt?=
 =?us-ascii?Q?Z/G5tQfnMmd/wygxRVqnYsSYDH7ZkvFqDkvHkmXe1LAwx/4N1UlM3LaKL1Mo?=
 =?us-ascii?Q?fljfyu2g5yM7pI/4VwT11AnU7FkUXIqq6LniiyOl4ryznZ/BIaunqJLg7y1d?=
 =?us-ascii?Q?7/kJ7jS6/qqnciyxJGqKQuYJTbit0YTtFwJm41ccFp275k3pn0Ev2Ii5XmCr?=
 =?us-ascii?Q?kKTZmu2Y4AgSmLDJlICDJuHTy6XD5j0MdLL0KxT7SPCQlYs/mvbV5eSyg/65?=
 =?us-ascii?Q?CU6CIJt5xnhNtRW4tZoxMzzmSIZ9DKKyLIB/fftBJSCnbJDgCEuK/JXGBRZT?=
 =?us-ascii?Q?SK4t7ENagGHsCLbZwDNcoyRnHwSBIv/bowxe0ur2XtDh2wVeLpi7VhwA//iq?=
 =?us-ascii?Q?x3FSDXWy8b6ZSkriKydn4sVS1swxMx0BCmoHNnlYPz22qD8cCFt4u1MpkdaS?=
 =?us-ascii?Q?fSM+mGWgS4X3kRywj2E6+fttWiveEiSnFL2mlDX+cP02EpWEmOghVv6SGt6Z?=
 =?us-ascii?Q?V/Fil2Pmk/YxaAz6ArBxdOKgG4GoWOu3rotnd+CPnkZIw/xzUZAhaznTGd8R?=
 =?us-ascii?Q?3QEuNHmp3TPkyqh1qjUVvUt5fqvgguEGkM7FFA9kgGSSqqJ3VRnTYvVXj/Di?=
 =?us-ascii?Q?qcDtsDXI+4qaQs3afOxLWmFQnf1KPf9b16XTSxm9ObK5WL7+RawJIUVuayxJ?=
 =?us-ascii?Q?yLAR9ZwrvvZCKS3tXjFe5VIfgfVoY85R6FVzUoDjiSLysOZJQJUiQJM7DRgz?=
 =?us-ascii?Q?eB5sy8dr4kS47MbO+gTR1OyY7v8v9CcLm7i9o68dvhgGwpVwUQttiTy6+Eks?=
 =?us-ascii?Q?6PzjoB3vE8sW2HDhwQBhy+VMCOO4/mVX9pdFi7ql+5jNCH1F32Y5BwyBr0qa?=
 =?us-ascii?Q?pxgOeAE+jhfhRbzJdJraQR/M+R02Yb25WIUDJotVL1/AdB8VM4VhuyebKmMw?=
 =?us-ascii?Q?M4jOlpXFW5GzNT3vi5Xa9QByZpG+jXkcw6MDkHx/Vgon4JtFV/uS6y9L0sDL?=
 =?us-ascii?Q?4YyF3jjrXNWNrYiiA6yIs/6XhRSuYRrl+HsyJEHy/JMqVK2KP80ce3D3kH51?=
 =?us-ascii?Q?OWoajmZUult3darMnkPMQBK7ecQwQfkY?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 644493c4-2e88-4bb9-b285-08da097dbc8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2022 07:54:46.4505
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xk4n2It9tQFpugckC4cLQW7UEi69zOCrr1Ntve/XYYQTOL35uQ4h1Dz1JbjgG5YB2CQeKNA2537g0WFqAkVlYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1494
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, March 18, 2022 8:41 PM
>=20
> On Fri, Mar 18, 2022 at 09:23:49AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Thursday, March 17, 2022 7:51 AM
> > >
> > > > there a rough idea of how the new dirty page logging will look like=
?
> > > > Is this already explained in the email threads an I missed it?
> > >
> > > I'm hoping to get something to show in the next few weeks, but what
> > > I've talked about previously is to have two things:
> > >
> > > 1) Control and reporting of dirty tracking via the system IOMMU
> > >    through the iommu_domain interface exposed by iommufd
> > >
> > > 2) Control and reporting of dirty tracking via a VFIO migration
> > >    capable device's internal tracking through a VFIO_DEVICE_FEATURE
> > >    interface similar to the v2 migration interface
> > >
> > > The two APIs would be semantically very similar but target different
> > > HW blocks. Userspace would be in charge to decide which dirty tracker
> > > to use and how to configure it.
> > >
> >
> > for the 2nd option I suppose userspace is expected to retrieve
> > dirty bits via VFIO_DEVICE_FEATURE before every iommufd
> > unmap operation in precopy phase, just like why we need return
> > the dirty bitmap to userspace in iommufd unmap interface in
> > the 1st option. Correct?
>=20
> It would have to be after unmap, not before
>=20

why? after unmap a dirty GPA page in the unmapped range is
meaningless to userspace since there is no backing PFN for that
GPA.

Thanks
Kevin
