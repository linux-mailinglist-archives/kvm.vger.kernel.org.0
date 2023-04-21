Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 533876EA4E8
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 09:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbjDUHgF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 03:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjDUHgD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 03:36:03 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90988139;
        Fri, 21 Apr 2023 00:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682062560; x=1713598560;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3VTlZXQMHRaiBlU2rdNWR6P0Y7XGlAZb+fRbzuAZQ4g=;
  b=gb2KpRYi9PDWtUJOHXpJFmxViL3ngQSoirmFSIwD8AktNqxluXTZNb5F
   0iNXLeV0JJ1HxA4he1PFnqtywNZN6KCUmgQAdVi9uhvGF8llMQ02sZKN/
   LoDWf8iuwwLX8xAoFhKGd4gprQSOz1mX1e3Dz3Z0LAbjg/3Il+y6dLhtj
   MDe6LmKpwE12noLKjkDTMKYFREBqL7H+FY5gSwcdHVm6tzFhSZUkrODQg
   /T/Kv8cGHgvmoINqT+S0blN9TEDdCPQdTSyF5lxYJfcqBh4LYNcxrSevK
   p8tc/k60ypp/VUmpCllA/SamJKsrtuRkzTTrozu2KQteL5bnjSfpuRcr3
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="326263878"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="326263878"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 00:36:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="938395328"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="938395328"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 21 Apr 2023 00:35:58 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 00:35:55 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 00:35:55 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 21 Apr 2023 00:35:55 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 21 Apr 2023 00:35:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XnX3JckgNMQZrPSWd+e4naJM6AUOFZu20Nj7QKZEI+DV4y0s6RvFBqihRdspr5+p0nuanMJwZ8bFrJuCeasidnfcEcckeC2Qk0RgMRtFcfM9CbDfKwm6cdCYprpdXtchWSoCusB3XehOkhYQjels05jn6pb0jFeQeVUh2zdFcwVa9eEx2XNpNHU1sdmPXe9gOPCOCIhi6oPqKNrIb9WsxWYL471esB1VRyEpaiEf4mdWFh34Ha+MkEjJ7+m9WkIchpDBfUB0GGQP1Va5xNnr+m0iOOZZD/Ib4TM9Ir/tOumfBeoJ6TeOmH+e7RXMVuvTsELGWuxkKsCAXGEu3U1Q/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3VTlZXQMHRaiBlU2rdNWR6P0Y7XGlAZb+fRbzuAZQ4g=;
 b=gaRQ86XHYPJg9oS3SXXRu6UXALATVaDxVTlL4iDGl4wkjK9mq0RoeWqXiI4GnG7rqIQmu9CX9H8wtRufzNScWF11EGol/52bnmkYD3YJIcy47I062OdD/ulDaSYgj9kZbn3dc9taFnOy5UnQ0kzf8RXA76pI01mnD4s0HotdhDOUoezC1RsAHXuw4UCluZfb4Xj9aYxzsF3Bbb8dxLPg7RsBIvA4jASZArT8sZdrAwiLjMyEmws/YVJlVWbPR+gpzv6d69fnMJUDXywfw07IFzmnfyhTxniNk/ep3IGwfI8GIUbnBum2+yzTy7bV6g9NlZOARIyohvwvq/ruYFH6IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB6142.namprd11.prod.outlook.com (2603:10b6:8:b2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 07:35:52 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%6]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 07:35:52 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Nicolin Chen <nicolinc@nvidia.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "robin.murphy@arm.com" <robin.murphy@arm.com>,
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
Thread-Index: AQHZc1yE16W9aY59DEuzMbzD2OIpT681YFcw
Date:   Fri, 21 Apr 2023 07:35:52 +0000
Message-ID: <BN9PR11MB52764ED59905104D3A5A68C08C609@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1681976394.git.nicolinc@nvidia.com>
In-Reply-To: <cover.1681976394.git.nicolinc@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB6142:EE_
x-ms-office365-filtering-correlation-id: 8fd078e0-7d8c-4ac1-198a-08db423b08fd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Trt3JLItw/aCZfOG96tvwtqaT+A/+BpFoGheFb4P+iRknlcKDDxl4ufRPofE/9icI5LOibAzqcXHsAoRpB7e9NcRXP67Qex0F/0BYWMxnt+hlT4pVgB6ue39plUJ/BHpgXoU/ibW7IgynilkB2uItHaTKnb+vxNHiw2AocBfnLKZZah1hKcAMgfSUwRjWDnzx6OZDIM2sypQmnXAa0nEiFlZuL8ysr4ejfrI3uoMasYoqLt7vS12R52Fv4M4qt0ueSkQC5eLhdV+kVKKpGhvY6ZlPq86vGEs0ylaxbLlXCwTV2ZdCMRv+m+r0ccUveQtVC2M2gu/YHqsapZ89gan1WI0UsTlNBiLb9rJTFMwEPRH0Q432i7wTzLmRmK3GvoP8OH5PxZbpqdkSOLfvgmPNQYkRehIb0rwAG89UDMvH/XVwLQnB8DPJat9F5ImmfKX9xSyGtLOnc6ahHfxwUkrmeZILe5MWpBK/VqTwA5c972AzklczMjeMCX9DDh5tSr759knHyFj3XJB7rL0UBnzI9ThuILbGJOjuvqg/bu8DFn1VVyszKPqHJAlyCXMo6dj9BxcwHp434mozWxffOIjpzJADFWionO/ReIqDRIkCI4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(376002)(346002)(366004)(39860400002)(451199021)(4326008)(110136005)(316002)(966005)(76116006)(66946007)(66476007)(66556008)(64756008)(66446008)(54906003)(33656002)(9686003)(26005)(6506007)(82960400001)(38100700002)(186003)(83380400001)(122000001)(55016003)(5660300002)(8676002)(41300700001)(8936002)(478600001)(7696005)(71200400001)(86362001)(38070700005)(7416002)(4744005)(52536014)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WtODdffgg2KdKHKDd5HaYxZQJfuRHmavf2v/8J4K2+pADQzR0ViiTYVrClT8?=
 =?us-ascii?Q?c7KpbKIh50r2MXYT+hn8XMMdQypxZl8Q5PIjLblzJa7SQSXxqecblwuEt3rN?=
 =?us-ascii?Q?l4yD1A8WQp0w6XOHQ/sEYO6/ffVons25tr6vzKLkN3npjIWjFwBuMRecNoY6?=
 =?us-ascii?Q?tG+Cfnk6t+5FAf9nM5ZEtpZOQxnY7k6THY4lW/VKKUVgfLo0A7bwi/AT4V9X?=
 =?us-ascii?Q?Wqi9LNLqNyDA+UITxzV+FECrH4zWXXQ7+vCRA6YSqOKmVggkQWZ/LtIruZIF?=
 =?us-ascii?Q?agdpJfow+tJjmv4EZCliy2fOPHSr0si7zKoTi36aFyL8bzlY84yF/qUlEfW4?=
 =?us-ascii?Q?Q6B1ASx8SrLMN9+CR9K161KsDC6hhP2rvf2vL31Tu2IQ3kbJ5XpCIAaTTE1F?=
 =?us-ascii?Q?2xG3VABEn4YIFjgWD9w8eA+upi/H9eKL0W22A/KHhfEUbZi9em7wBHTR5/zw?=
 =?us-ascii?Q?jU0X+GEZEd09ekqtrffWigA+gdO0BV8q0vcEOzQWjiECuVxDNXRmx1lwkU3u?=
 =?us-ascii?Q?rQXSwBTPid9qshiFH02v9AJFjrSEQ2gOXTwMXGNtJ4+qZGPWC/PXS2kMm+Yb?=
 =?us-ascii?Q?uvHSCaroHTWtZQGpB9c+jFF1AVEI+E0s7/2NR1elhFq+aIXBaJjHIV9aPIZP?=
 =?us-ascii?Q?6kiKMizgnVzZDGhyOfE+D84JTvtz8ZtuIHbJsT54O3itCT0uul7/bEDFslK3?=
 =?us-ascii?Q?5sBB0VTUFFxSHW/X9y7s3mD+l8fbNOkeIHmg6uqHvD5yM3aoQq243iZiYSi1?=
 =?us-ascii?Q?j76702y1Bc0pL3MGas9fh10K5UxUHC7NVbxcalq1UrwKyoEi+6CAYnYSa3+N?=
 =?us-ascii?Q?i/+l48xcD2lWdAPSX76xv4N76nMXNBtlU7KCi953EmAyxOtD+mfdzLSPyEK6?=
 =?us-ascii?Q?50BDIaB7iOs43qYrezQK5oq8brPuli0vq1QHxxvnT3AxXALcuN+4CiISIgBE?=
 =?us-ascii?Q?ehn/9fmKYZZxe3fDBTAPvxEzLXvD45O8oa9l3C2nbrVkeK2ZbbuhWKUosz7D?=
 =?us-ascii?Q?3JG5F78kj5RiQMPn8CrW4rEclTgVTjoh1KDRik8AoHngyUjpfQsXj4GiMUXR?=
 =?us-ascii?Q?BARXpb6floQ8hCylR4Qx0yPDxeOjF+//hABbgXkPhPDrRgznYZHY5Dxh1T0f?=
 =?us-ascii?Q?daoo+UyqepWURaCzdVHkKF1Weet59nNHjD0PM2QHUd91d1sHOCIleHdHg4fv?=
 =?us-ascii?Q?wXQ/DaoLy+Y74p+AXuV446XBQI0xZrCeyQ2/yZFC9etb/LoqomEDUol+cYIR?=
 =?us-ascii?Q?Q7Lj2zW8sdW3h3tiSLgGewOLQVEAUXdBAxvjNuA4es9p/vZZNAdOzAlqT5D9?=
 =?us-ascii?Q?G2sxeIQuzoExI4E7v0cOHEcTZMaZ6ly97OCU/ss+B8mCr8MiICmEsYHp72fy?=
 =?us-ascii?Q?So8xu4IwkB0dkH6BEYcML1gj7p1g5p8dI1TDMSM+aFqKRxzrcgTvkozrV/OT?=
 =?us-ascii?Q?AyHQ8YaApbXrhRmnXc6wZbXu3HiExz33iYNni34P0rrld6R5GVQYIeZm6D68?=
 =?us-ascii?Q?2E3e5juX67JATH8923cKGaTIaoTtdM515/ne9vIvP+pLAhLqSzzIQCJoUfWD?=
 =?us-ascii?Q?LSYkdnIhj95HetwdqEAQ8BH+HjFjQ2wVIGCo7ooP?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fd078e0-7d8c-4ac1-198a-08db423b08fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2023 07:35:52.3868
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z3jbiBkI/YPZ/LeGGjPBLC2lNz6pIiymqSU/kBwkh8CX02X5QUIe++DHisu0lISex7eHzBe0kNtO8pL6qEbEjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6142
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Thursday, April 20, 2023 3:48 PM
>=20
> This is a pair of new uAPI/ops for user space to set an iommu specific
> device data for a passthrough device. This is primarily used by SMMUv3
> driver for now, to link the vSID and the pSID of a device that's behind
> the SMMU. The link (lookup table) will be used to verify any ATC_INV
> command from the user space for that device, and then replace the SID
> field (virtual SID) with the corresponding physical SID.
>=20
> This series is available on Github:
> https://github.com/nicolinc/iommufd/commits/set_dev_data-rfc-v2
>=20
> Thanks!
> Nicolin
>=20

there is no changelog compared to v1.

Could you add some words why changing from passing the information
in an iommufd ioctl to bind_iommufd? My gut-feeling leans toward
the latter option...
