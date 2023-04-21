Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BADAA6EA591
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 10:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbjDUIIk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 04:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjDUIIg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 04:08:36 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB3A4EDF;
        Fri, 21 Apr 2023 01:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682064516; x=1713600516;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=srj2mJhIwr2Mxk2afVp/OFH55pACnk+AejnQXKaRrTo=;
  b=Rm72SJvNsOAGCsaNIZkCFisoTsArfciS/8IKEWsV1gGzEHOuebIl4U5N
   R8ihyU7dIR5y5B8spfsX8CiprxgFHPUY1uNuoLbb2CyPWPCtCNZH9asvo
   /xfZ7BNpJWCLI3Q3Wl9xSoahq+3xlE8/wNV+A6F+31jil43B22nrgFYMc
   BtgdwcVwArHyUnvgEE5cBOSifTplPp2oNWRsAFAg1AmljGFVSF5ZbuI41
   Uak6VVu0Uhn7eMN0P+tLsOa2t2NHcUd7+vSHngS/1VUdrHmYt+Dr8q9Bk
   Wd8UvAxZ+wmhPtoqjxTCNyj21Nbkf90RAtaJJ99qVciCQOKZ9O86E/AO+
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="325542738"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="325542738"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 01:08:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="816343885"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="816343885"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 21 Apr 2023 01:08:35 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 01:08:34 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 01:08:34 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 21 Apr 2023 01:08:34 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 21 Apr 2023 01:08:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MBZDAEsCLQjYXsbX3NZ00NUBO2bCoLXRq9yemPDul2m5fGXinTL9ZTk0xhr4xvDdbtAdPtP4vieYB1TSLn1OZEqAkcYSO2B+XvAcLWDsaAx+Mppjxewo5uKYxlluxaB+U4reBZofMqSLUCmpF1736lJ2c3QYSKvmnaJp7VWjyTT9DRcwdLbsiB7dR1uQGUealU2uFfIn49ct1gbPXN77Ke3U42IFHUiTTk9C50pltP+jM5Z8aYtAi5t5EEd3n1jYkm1/yCYFnguikJTY8yuCXIkZKWzgNvtF19qxOLCqBBhc5LbTaPivTRWX2he99Uwl+T4C/pYPyZ0IEna5b0bdyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Ljxv73v88fOl72NwgdNhCKX1LVM14bJP1CtcLSvugU=;
 b=Pyme3qsj0IDTyZDO1mepEVXRGSOIX5XUlCU3zd9SIlW+e/4hOMR8R1+MJYyO/OC7ls6xL+M+UGU6m0z6PH33TroNnZvMMPG7xkzgWp1xz06AM7gfvdAm3XFqbmCZnC1BYjd9zG3jesDv4xHiT+VdAHIp6PnmFEpb14Fzv9OWpI3YRN7Gkfj7u3tTepqxBGUMkMu8ba9B2qm3+8ypHmXRnjRbdWx8xIs4iBIexlg3B87Q3ddgwEsLJH3Z3GM6YiXdJq8ymVKwvgZ9jZMCvYadDS2lJEg0q2m3gI4pW7RPEg2xewzXwFte46pzhVyW4rHr7YaOESXV+soOOQpUtl7GPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB7901.namprd11.prod.outlook.com (2603:10b6:8:f4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 08:07:21 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%6]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 08:07:20 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Nicolin Chen <nicolinc@nvidia.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "will@kernel.org" <will@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RFC v2 0/3] Add set_dev_data and unset_dev_data support
Thread-Topic: [PATCH RFC v2 0/3] Add set_dev_data and unset_dev_data support
Thread-Index: AQHZc1yE16W9aY59DEuzMbzD2OIpT681YFcwgAACUQCAAADWIIAAAzuAgAACDyA=
Date:   Fri, 21 Apr 2023 08:07:19 +0000
Message-ID: <BN9PR11MB527693075725A13DB9EE18678C609@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1681976394.git.nicolinc@nvidia.com>
 <BN9PR11MB52764ED59905104D3A5A68C08C609@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZEI+LBkEeNZdJyTB@Asurada-Nvidia>
 <BN9PR11MB5276C39E256CD4B922435E1C8C609@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZEJBldGXBNGEy9tV@Asurada-Nvidia>
In-Reply-To: <ZEJBldGXBNGEy9tV@Asurada-Nvidia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB7901:EE_
x-ms-office365-filtering-correlation-id: feb861c9-4589-4e7a-2ba9-08db423f6e0e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SvW8mVGSHxH2Zzvg+VkqNxeCQRk8y7mhThMabFQelElbCHrijKkiL8QicxGfPrHefWx8HYn0kz356CIPrWyK/BUVHLWnSqpRXwQyXMaQ2xMyEVseFlul+B3/MsVvIHgE1neLbib8LxkzqgOeyupcTIOGsF4D+YHgwKw3O3UvKzfR8fphECfxocG7uX60u+eIEmG6B1iMYcEvVJyW5lWkCqXzYKlovTnmQ9qj+RQ6oXaiALnPCukp3+p4J9oaSfLEXwhMLZHLKUZPEUuW/gIpmgFZA5GcPZ7oXoe8R9dB+gGWT7eg66sjVVfYmvi552r9kSYA0j9CHQqhbOYE05POR5CQYlh/eJP3fjvcWlMoMcXNpnFDbN6DMo1HiMNqUumnN9b9T5JJyCT0yp3c5rIuXQzM+oVik+KiUrrryJKMaQuXNgHrUIdUeAQepDLUip47rGn21VPvCZ+uQdxG1nPRF9AUR3WQSYaivy/+zGWROB61UG9o+wjO1QC1bSZfuxS023l0eonBxzhIUwD4tFaWY8SuTR6g6nLv2u/irxXsTXzwPeBcuzWayocfnASGpDuBgw6/HeDHIJ8YqdvvoNYTw8kpXj2qeRggr9Co2Sq8KYF1H9EPfqJSIEuh+rdI1QlDWrBSKjL+eeiZq4g4n/T3Hg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(396003)(376002)(346002)(366004)(451199021)(38100700002)(55016003)(26005)(122000001)(6506007)(82960400001)(186003)(38070700005)(9686003)(83380400001)(8936002)(52536014)(8676002)(2906002)(5660300002)(33656002)(86362001)(54906003)(66946007)(41300700001)(71200400001)(7696005)(66556008)(478600001)(66446008)(4326008)(6916009)(76116006)(966005)(64756008)(66476007)(316002)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Gh00vXbR+WICx+AwQ/ClnYGQVHPpeQL7uNcU6tSFbTyXxzXlG4ScMDo6KLCS?=
 =?us-ascii?Q?kkCAS38DI/SC8x9ecZhwvjzvctq5JT9INHLk9yrLnvK8g7HlC4ZFIEgFYW4n?=
 =?us-ascii?Q?09NulEp+bs2rQ1/pYtuP3wNyuSnS09BTfN23xCkvnRKzLX1/UqR5uFgNGFof?=
 =?us-ascii?Q?kVbDolnoTdZ4uvaPWl6qZdJJaqO4T5hdf4+kgp+ddO6SnOvKtB1Ep6GHnUWe?=
 =?us-ascii?Q?yL2OgPlOh0yqaHpwZVH2WaU1FtBBYAEVsOUmEEMGdtCqyt3FbjBlYyYFjSud?=
 =?us-ascii?Q?A5TeImrGs0XchiwJasU2G+WaLceHVPqvz5e/HEuTNIRqNXHJr6Y8n4DKuoDW?=
 =?us-ascii?Q?VnutDl0zox+dqIpr0Y4FowwBXY3a6cRKZ0V4jYJgB4gQrrfb9YwUEJs5WHux?=
 =?us-ascii?Q?B7yNsuXuXDUqQyGjpVaHKu8+t9fnAiB5KAr7phSYh6h5YMb5k9W6B0cfxdz5?=
 =?us-ascii?Q?GjLebtQ4sPmNAymNJXNYjPvGp2UchqXormiDd61ra7fhrWbrFZzSuW2bcfdD?=
 =?us-ascii?Q?iMjQT8zeVsDHQGBjlnYWwjb3Q7FTdx/+mYypkgD7aF/vNnzASQRYBi4Gvfaf?=
 =?us-ascii?Q?VWVBdpHSGEnsAypREcTmY5ic5g7NUpC/CP7vwDqMe8F7/CS5OVlvRouDsNH9?=
 =?us-ascii?Q?tDNh4yw+7FwgrPHXClWlcCnHMQg1uvZA3TfVto67bIfmkfSZi4Aypv5QExyg?=
 =?us-ascii?Q?EM4VKydWAmWR884JEJxRLb10x6vC8zdVYgenktWiiSAIcrey5tiuVN/wmfwM?=
 =?us-ascii?Q?ZR2gCD62Ln1PM/AwvWXO8m0y/qlJEYw4bMh0kEGW+iohdWJ4cOzApPCqGYMa?=
 =?us-ascii?Q?Sj+jiAtTP/vF603L6fZyoR2a2dq4xNcaGAGsj0/Xzcp4iQ1G6/sLP2X4kjmN?=
 =?us-ascii?Q?g46KeUqOIRQS5yfTP54mnAyNFOPLKQiMoTz13NLMGEuTKqBNj4JnI1AOug3d?=
 =?us-ascii?Q?hXFA7rzOZTEYyUjTyy/pcSQNcxcPu9ocXI5xdig3xZz/BcQ7iRNjATS7XTnA?=
 =?us-ascii?Q?J/tZRIhNe5LVUhScRXluXb2niQQlR0+c3/fpSoikbK4NwQCDOLk6ecD51hbe?=
 =?us-ascii?Q?k7zd1euOC72aIMxFa/z8nsMXBLynFZG9eMYkkr6oByvz+CwUjLWWvv0+jXtL?=
 =?us-ascii?Q?oFAW2aYWcqhr0tTcbaiV0fktDO2WD7/cKIwoOy3jzuLRumFtyAHTPDzHlhxj?=
 =?us-ascii?Q?78JrOkjRWq8mE1FJhk+wCyU23SMQM0PL7AIOf9yqfBuxHVTl8IMhDDLux+Ou?=
 =?us-ascii?Q?P1cSyWbwrlZXKQm4zhmXeqFU9DDVVfWZwOIEgZmzyz5Ozc5gSMuRtH+LRona?=
 =?us-ascii?Q?F04GWqFRQzv1TK0eTWkDNtU3HyIsKBk+NlhQxe48ivOPeMU6i2RYJo10wQZD?=
 =?us-ascii?Q?U0vXDEsFt72+EpZ2yFGRhE55HaQacYoys+ZB812gkBSlxqiIHivHc5g/M4s5?=
 =?us-ascii?Q?QODmkDoadkTkYYN2V3fDE4ZkyQhfWK+Hm6NHQVXw9jPXL6WmLlSPi1994ZwF?=
 =?us-ascii?Q?efXJ5N1BpzXBzyBTcmPUGgm3Flj5H8iPOKhcNd0wEo9BStyzuzW/eok8J/qx?=
 =?us-ascii?Q?hep7pCnEdqbvNMtwHG8x37QWnqKfIjCycRvHJ67z?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: feb861c9-4589-4e7a-2ba9-08db423f6e0e
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2023 08:07:19.9611
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0nGHjnIiU2d7riqlGho0LAaS4t2x6jFE/vMLuNfDU3iICMIb9YogvfOImO/hR5DbuWR0XpCUefxeeMTf2d9SCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7901
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Friday, April 21, 2023 3:56 PM
>=20
> On Fri, Apr 21, 2023 at 07:47:13AM +0000, Tian, Kevin wrote:
>=20
> > > It is in the commit message of the cover-letter though:
> > >
> https://github.com/nicolinc/iommufd/commit/5e17d270bfca2a5e3e7401d4b
> > > f58ae53eb7a8a55
> > > --------------------------------------------------------
> > > Changelog
> > > v2:
> > >  * Integrated the uAPI into VFIO_DEVICE_BIND_IOMMUFD call
> > >  * Renamed the previous set_rid_user to set_dev_data, to decouple fro=
m
> > >    the PCI regime.
> > > v1:
> > >  https://lore.kernel.org/all/cover.1680762112.git.nicolinc@nvidia.com=
/
> > > --------------------------------------------------------
> > >
> > > > Could you add some words why changing from passing the information
> > > > in an iommufd ioctl to bind_iommufd? My gut-feeling leans toward
> > > > the latter option...
> > >
> > > Yea. Jason told me to decouple it from PCI. And merge it into
> > > a general uAPI. So I picked the BIND ioctl.
> > >
> >
> > 'decouple it from PCI' is kind of covered by renaming set_rid
> > to set_data. but I didn't get why this has to be merged with another
> > uAPI. Once iommufd_device is created we could have separate
> > ioctls to poke its attributes individually. What'd be broken if this
> > is not done at BIND time?
>=20
> Oh, sorry. He didn't literally told me to merge, but commented
> "make sense" at my proposal of reusing BIND. So, I don't think
> adding to the BIND is a must here.
>=20
> The BIND is done in vfio_realize() where the RID (dev_data) is
> available also. And the new uAPI in my v1 actually gets called
> near the BIND. So, I feel we may just do it once? I am open to
> a better idea.
>=20

IMHO if this can be done within iommufd then that should be
the choice. vfio doesn't need to know this data at all and doing
so means vdpa or a 3rd driver also needs to implement similar=20
logic in their uAPI...
