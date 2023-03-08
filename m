Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D15B6B00A5
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 09:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbjCHIQW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 03:16:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjCHIQU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 03:16:20 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AEAF55504;
        Wed,  8 Mar 2023 00:16:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678263379; x=1709799379;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ctXLdKZFdbwaTKDV2qQydgmNLjF2afjvxsWfPpE+9S4=;
  b=mpmaf3rJgwpzDEr1HqZ0XyqItSvA25k+qhlTQ2gFQ76O0b1Bqd1Zpn5N
   wTf1YylvvSeCdtzf3eM0PhmF4fbkMWSBp7QgpxTyTJaA8mWQgbQLh52Et
   mjX0ZPI6MaGSRa5F1qxPf1w9vwP9+9Qj6Ckm8DDhbee53x3F+G4TsAlgE
   jYNQchaxOF4mVpqKSLT7GVsfjpUPKAjdXNEtxapK6iiu3r4iz3tyY+EsB
   DaRvUUZt9JXiZ1xlyoHvyLn4bqcfF68Y+4MyJcTGMsG+4BSx6lZk0n+mm
   r3VMlHDlRsBZaaxUDm51OKbxyYiPvvkArT3UqoE241m7YPagMxNcnJB+D
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="336114184"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="336114184"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2023 00:15:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="654260240"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="654260240"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 08 Mar 2023 00:15:54 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 8 Mar 2023 00:15:54 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 8 Mar 2023 00:15:54 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 8 Mar 2023 00:15:54 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 8 Mar 2023 00:15:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oMV2cBjMeGVYk4wx/at3ZUaQw8KRvNu9/5buby3BOWUjLCwmBySeD6HOCAw81FAHqMP8No76oqBltqOnDlAt2nG4HLNrQw643kk27OpzptUsS/6vlY3zvFYR51fUy7SfjkF9iE0N8RgkdTSmVkKNeoTw4/nczMFx0UBHOc1A0DAI1vMXKqaIqVy6bOwOKc2+VjHF7TSD71hg0Ce5IqsmOrH6y85bKzOVnPZgDxLTG+eGkF7WqjAM4pMbme/MyDbb5BQVQ4bR5lJZk6bk3hY0w6gLC/Ap8XVq6Qe9nLHfJeffMvo9Fg7zC0B+A8kXZyJq8GCgDDqhoK97dbLHkkoMVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wf7rBXrCKg7utoCqk46Q3PSF58W4007cBUDcAKTAE2I=;
 b=mPHJavE3Fg1D86kMlZ5oDmuSZJ7aQx1TexQq13rjWQA348ntjKTcVj3ncBAa/VJZdEtKcYmMMFEDzBle36PnRxfnAy5VGJt1LvIqxoBk5PQ5J8og4+DpCyRoI6NkXqJvV7PLVi5gxsnBXeMXPKP2h2U9ZWq2YopmMqUqqzSFWPBIE5MIy5ubXltU6o/uK9a71DRb4Vboxf8a1U63h4hHeW8iPI5bMyop5vOzIoqvmgK/rnAWBrjIggJsVzkUcaoB6vJvRmOfktVIjtStPclNdUws4oQkcjNvJJqDU0EyEanpgCwizFTQIJhsDQ46ZGA+HuC5J8X9mlXgyQuv+jqDsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SN7PR11MB6678.namprd11.prod.outlook.com (2603:10b6:806:26a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Wed, 8 Mar
 2023 08:15:47 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6156.029; Wed, 8 Mar 2023
 08:15:47 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v5 09/19] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v5 09/19] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZSpxNz0d7VXviIEytrFhyB5GUvK7m/3jggABFoQCAACyCAIAAGw8ggAETHYCAAKz6AIAEeeOAgADd5oCAAKkfAIAACTyQgAEyYgCAAATW0IAAAz8AgAAAarCAAAT2AIAAABiQ
Date:   Wed, 8 Mar 2023 08:15:46 +0000
Message-ID: <DS0PR11MB75298A8C6E8FED5D90899870C3B49@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-10-yi.l.liu@intel.com>
 <DS0PR11MB75295B4B2578765C8B08AC7EC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB527688810514A262471E4BB78CB29@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZACX+Np/IY7ygqL5@nvidia.com>
 <DS0PR11MB7529531834C0A9F1D294A5CCC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276B825071A4819479079A68CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230303095542.2bfce5c2.alex.williamson@redhat.com>
 <ZAXny4NDDq42NUxE@nvidia.com>
 <BN9PR11MB52760ABC93BCE7FB53A131038CB79@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZAcvzvhkt9QhCmdi@nvidia.com>
 <DS0PR11MB7529A864CB1C149CF8B19E78C3B79@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB527616204417D92A1BEB5FDA8CB49@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB75298BD3EB872C938F86C96AC3B49@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB527659E9DF1849873ED089DE8CB49@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB75291E848C663CEF67B1781EC3B49@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB52767FCB0A7B838B7D78D92A8CB49@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB52767FCB0A7B838B7D78D92A8CB49@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SN7PR11MB6678:EE_
x-ms-office365-filtering-correlation-id: 7b6f932f-41a8-4bb5-f2c6-08db1fad5207
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F8+Q4Co26dJJCCZdapoN1/FQb+hzBBLweLrrKL0sOiLwNaRiHcGXCp3w0YNj4c6k2XObYuxDdOOPXb4IDqJJHrU4O0y4xbhl4Raw+YxzH1owP0Wrwzh0IkpsQ+ZnAJsLmoa7eRjL1tURO35Uv5RhpNiXxpCatmSM7xoAFxGM+DliWDxzPRVDkLFoHRXP3W2k/ofAWet4ode20giDeAGlGZoYIFiRPZZnUMcqBuP3Mw/Mz37gLBMEhclufa8QIChjHw8VdOIDOWXgydZbHdqy0L8AI41HOqKR/AfKKSFjEdQciDnCzjvhiaX5pDQQYU+O0R1pb3UH+Gs6QKDPFSUn6Y+j/QQEm1sEbK71IqtFKEFBXHco424qrm5oFX72DL2nf5f0U9TCIheAhLJ7XPNNN2ptEOhuKy/KPYUEiMTVQjREt3dSC+ct/0H0KZuKqnwctddfP9j20yy7QvrzjzIiVrX8A4SI2Df4OrcndczGsBjQwMA7ZrxTdq4/vj5fuFPO4uAusGGgQD6RaTv4cRz0oXTIHe1PgLwe/1nL4YcTd9/C52e8HjqRwU/i1wTAQzoQ0hJDUrTqQttgCgDFprMoJL+9fLCB7ajB82QVOXN9RCu7HBKLCmEWIbCi24hzUbbstfYawc0Xmy0C9l6WCBKLN0kduOFrW4owhwpjP0fp2r4YW6C73Vc74nTyPw9QC0D84ORMnfMUrlTfv2RI8v0gZw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(136003)(39860400002)(366004)(346002)(451199018)(33656002)(316002)(54906003)(110136005)(2906002)(7416002)(478600001)(7696005)(66446008)(5660300002)(8936002)(64756008)(66946007)(66556008)(8676002)(66476007)(4326008)(41300700001)(52536014)(76116006)(122000001)(186003)(82960400001)(38070700005)(55016003)(38100700002)(86362001)(6506007)(71200400001)(26005)(9686003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mYlUH3qzrIdYTY9APDtKPDM39w07tKeDNW68Dqn/qfA7J6LhVLU0EGJGtu18?=
 =?us-ascii?Q?kWKD+bWyeoa0DX1xhSSNDUAV1MF2I9IDju0TMsUEQe3b0dns+X3SASMRLP5P?=
 =?us-ascii?Q?dwMSKZhC0696oqAS9eTynfEh7fxiDANl8IUjkA10vrVlD/XFBs5opiLhPJyd?=
 =?us-ascii?Q?76yFMwtvPmbcQgYAAWuu8NK2Nq/4RTF92KTTDfhUHK0UcOQ5DwaCkZSlKmbr?=
 =?us-ascii?Q?HzgEfp+PHHQsG9RjKHrWjf057v/YVNV5cDlXfHM3GRR9jpO/U25MSiHP8GVg?=
 =?us-ascii?Q?WWNRcEeSr1xjU5ZSGk7M7HEXYAVEZ78O1JMUMtphY7mUJ4SR/hVXF7pZhEwt?=
 =?us-ascii?Q?8JjR0fwUzfZa0nfrAwSWKmX2COfOfz/00hgH81e/6W8vc2LALZ1Qrcx02iJz?=
 =?us-ascii?Q?hb2yP6UzVx3oEmjYJNs4O0+hOwb1rnU0ar85+DYa10Enf94zTmLlUS8HXjGL?=
 =?us-ascii?Q?JgeSkGrxxrn+EbCsXd8WU8/on6sabusKZCU/WzdLPmRio4hNsMhYCLE6SKBi?=
 =?us-ascii?Q?rapOjMHbhVbo2I+sLRud51hxfi+JrbcpR69FXFRGOAe26Pu4SfmQfLlHJk/X?=
 =?us-ascii?Q?sl3r8JVNvUYcDNf/wjVKiuxk5efbHl01JLI3xUAfmctMtyCTnmnvZ56fDAwX?=
 =?us-ascii?Q?SRUui9GdYuarY6pGm6oIaQz0knebph8YNE3yxvEMYon1jue9hSh0VxAW48oR?=
 =?us-ascii?Q?SDUc4uw9ic1EwJ4C85tiBWXc7oFuMfgT52xNZwFOz0J4ewupPuiyCafZnJg2?=
 =?us-ascii?Q?mtn5VP4Z86bzQXY5z571u80e+wvS0g5S4dy4A6MA6X3vGx9h5WXQPR9vSaZ/?=
 =?us-ascii?Q?DRCe7hjClOmTzS9adWcWgwLgB0y865TY63SFYu44MLzNDodXbzfbrLhzdVB+?=
 =?us-ascii?Q?SbBqYroMP6wujjfWCP2iLk7UvkZKeYzpsc2ODmfNA6Rle6TiUOzerbBajbAy?=
 =?us-ascii?Q?ufjTp+xXyPCEFcorJUkTrrfpMZimP+JoAmuwZQkOUDAJdE7JXg502FXAXlPu?=
 =?us-ascii?Q?Hqv0gv3ZZjeTLV5813DR+CevUMGwWJ2hd7eYphBVRgSpHQZouXazS3Y58Ee5?=
 =?us-ascii?Q?BshBOkwZ8PQXBMskLwYV72b7RCHgTLnXTgGdAsnUaQvUi8u6NU/G2Nts9zO/?=
 =?us-ascii?Q?YZas9Z2OS1Nxl2AFMkKv7Tm3LnWXx81B01QgVmfYIhuKjq5j/4cnzTLRiG/r?=
 =?us-ascii?Q?uaiX/0Teplf3hjR6YHO6OI623FfRNXI6bzgoYaXzuJArQrr3yD1srWRY2IKJ?=
 =?us-ascii?Q?iWmPx3WYSN/vbi/lvId3aEPpdL3uzRWO6lEmUo6rxq3y6yumm6IMp6Z6xuqE?=
 =?us-ascii?Q?sd6wnw8rc2/5EL3PKJiVTmqrFw7WE5yKPT+r5lOXiP63c98PX+gwqxBhinnQ?=
 =?us-ascii?Q?V5D0Nj7blHYBm1eUdOWTbMHTdnZNPq6j9DJSdtnvM3yINKujV7KVOtqkx9Zv?=
 =?us-ascii?Q?sBb5IYwg1rdLm9aH8F6UULECfeVSQpC5fDlt0b2wVIX5Qw4fQkFxRkGiGUnw?=
 =?us-ascii?Q?6aNS8PQ4DJo0LnJK/HlogtF7SziYz533B7e4xW8hgvMV8x2S6a+2OpYK/CaB?=
 =?us-ascii?Q?Pm5n6JUYBWbLcGd/uBMrZuhetBVrvV3J38RBCpKv?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b6f932f-41a8-4bb5-f2c6-08db1fad5207
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2023 08:15:46.8956
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OTXPmkJn06DFYWbRR6DiJbh9AZX10IGssTHbAyQ6LGLZo/AKtCDc3OmBtoSa0YzBTwEQOuEoKjF1/7u2rKmDpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6678
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Tian, Kevin <kevin.tian@intel.com>
> Sent: Wednesday, March 8, 2023 4:14 PM
>=20
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Wednesday, March 8, 2023 4:01 PM
> >
> > > From: Tian, Kevin <kevin.tian@intel.com>
> > > Sent: Wednesday, March 8, 2023 3:55 PM
> > >
> > > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > > Sent: Wednesday, March 8, 2023 3:47 PM
> > > >
> > > > > From: Tian, Kevin <kevin.tian@intel.com>
> > > > > Sent: Wednesday, March 8, 2023 3:26 PM
> > > > >
> > > > > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > > > > Sent: Tuesday, March 7, 2023 9:29 PM
> > > > > >
> > > > > > >
> > > > > > > I really prefer the 'use the iommufd option' still exist, it =
is so
> > > > > > > much cleaner and easier for the actual users of this API. We'=
ve
> lost
> > > > > > > the point by worrying about no iommu.
> > > > > >
> > > > > > Hmmm, so you are suggesting to have both the device fd approach
> > > > > > and the zero-length array approach, let user to select the best=
 way
> > > > > > based on their wisdom. Is it? how about something like below in
> the
> > > > > > uapi header.
> > > > > >
> > > > > > /**
> > > > > >  * VFIO_DEVICE_PCI_HOT_RESET - _IOW(VFIO_TYPE, VFIO_BASE +
> 13,
> > > > > >  *                                  struct vfio_pci_hot_reset)
> > > > > >  *
> > > > > >  * Userspace requests hot reset for the devices it uses.  Due t=
o the
> > > > > >  * underlying topology, multiple devices may be affected in the
> reset.
> > > > > >  * The affected devices may have been opened by the user or by
> > > other
> > > > > >  * users or not opened yet.  Only when all the affected devices=
 are
> > > > > >  * either opened by the current user or not opened by any user,
> > > should
> > > > > >  * the reset request be allowed.  Otherwise, this request is
> expected
> > > > > >  * to return error. group_fds array can accept either group fds=
 or
> > > > > >  * device fds.  Users using iommufd (valid fd), could also pass=
ing a
> > > > > >  * zero-length group_fds array to indicate using the bound
> > > iommufd_ctx
> > > > > >  * for ownership check to the affected devices that are opened.
> > > > > >  *
> > > > > >  * Return: 0 on success, -errno on failure.
> > > > > >  */
> > > > > > struct vfio_pci_hot_reset {
> > > > > >         __u32   argsz;
> > > > > >         __u32   flags;
> > > > > >         __u32   count;
> > > > > >         __s32   group_fds[];
> > > > > > };
> > > > > >
> > > > >
> > > > >  * Userspace requests hot reset for the devices it uses.  Due to =
the
> > > > >  * underlying topology, multiple devices can be affected in the r=
eset
> > > > >  * while some might be opened by another user. To avoid
> interference
> > > > >  * the calling user must ensure all affected devices, if opened, =
are
> > > > >  * owned by itself.
> > > > >  *
> > > > >  * The ownership can be proved in three ways:
> > > > >  *   - An array of group fds
> > > > >  *   - An array of device fds
> > > > >  *   - A zero-length array
> > > > >  *
> > > > Thanks.
> > > > >  * In the last case all affected devices which are opened by this=
 user
> > > must
> > > > >  * have been bound to a same iommufd_ctx.
> > > >
> > > > I think we only allow it when this iommufd_ctx is valid. Is it? To
> > > > user, it means device should be bound to a positive iommufd.
> > >
> > > I didn't get it. Do we have a iommufd_ctx created but marked as
> > > invalid?
> >
> > I mean iommufd_ctx=3D=3DNULL. If a negative iommufd is provided,
> > then kernel side only has a NULL iommufd_ctx. If so, the ownership
> > check just fail if it uses iommufd_ctx for ownership proof.
>=20
> it's fine. iommufd_ctx check doesn't work with noiommu.
>=20
> User should use device fd if involving noiommu.

Yes, this is my point. This zero-length array approach is only
available for devices that are bound to positive iommufd.
