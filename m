Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED0097410EE
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 14:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbjF1MeA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 08:34:00 -0400
Received: from mail-mw2nam12on2043.outbound.protection.outlook.com ([40.107.244.43]:64993
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230152AbjF1Md6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 08:33:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=McS1KbmetCXqYq2UZan5+EwqxZTIAo1cU0NXdUWPWLgwb+q0VwGHV993ixpPqiJwg5C1dYvh4BjXEa/c+ZBYLyYMvlVMb9aVP0WrysYYrIqhbR2UK0nuvTmh2lSec1aARuLeB1hZmjPcJ8YWK/B2LQSZVjoVZHp/IrZ7mY7FFO73kzLrv2PAtXx+4qTxn92KVmLmylHAhLiObUb0W5bEnguaIWuJV3ZW8HxMsBAt9w2uLei3A6DeN4rOX4A+7SA3MR0grKXaRdL0cstDXRGJAva9PzqI5kjF7P9+ynTirCIkqfRP77Gx+n0e2zshMIlzytZCPWEx3SC+e0z1JmBiAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jr/vgXUb9UO5xVMjk0qQEQAaXFgToI9dmmbpxnyuHL4=;
 b=KdQ2WT/KUcUZ2J6KFhRT8cVec5ALHO/udEauU3QeCSuH18HZh1oY8WxdTZ23I8syn1dcWV58jLtHDaVpFh2wwNpYd63z03mu12T8fkjaK+1bnqxL58wj+f9eTjmqAZwF1DPEeAB9GNvI9crJLlC26xCe0J1htCZG/AuzBrhtlmi78KrnKIYKo805J/I2ydlzRahhvUPgdOH0uMEhjAIXOQmu5jc3VuqfIZn0Tqe52It+jV3sV8uRuYtJnMxp+ohtFy56NMEtrqgqQWzJDSL8Cffr93CZcd55zBFuH0op87/F5ICK43mUkCz1XjtUdfbBqS5qmXS2EecObpX3xZ3WuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jr/vgXUb9UO5xVMjk0qQEQAaXFgToI9dmmbpxnyuHL4=;
 b=m6rASH3OtJGiKAe1E1u1nygcX5OiIrEnApkaX40g4cu8M7okrPgkBJTdckNztBiN/2EAAAYfYmqVOpBep9WQJgnAlr/v/adbT/KbvXTZWBg8S70IPazBDaRkaE9PKwI2KgFfsUPayH1jM7tVUhfFeb+sXtaR1reGwr7A9Ii36dQH4BFcI4+5M4ciN+m0xQBmQbvm6UNlZfUcksIR8ker8tY71lthXIHY2+nP3TABnj8hlMWpUnhEOqHbhptzvvhjb0xqtPIKy3/F0BkkfPvhTaXPZpXcDCaqmKx5uCEGcG5N3QN/Mmq7P7Ak2EvrqlmmdDroa75PUsC8qbtzRodqcQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH0PR12MB8097.namprd12.prod.outlook.com (2603:10b6:510:295::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.44; Wed, 28 Jun
 2023 12:33:56 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6521.024; Wed, 28 Jun 2023
 12:33:56 +0000
Date:   Wed, 28 Jun 2023 09:33:54 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: Re: [PATCH v13 22/22] docs: vfio: Add vfio device cdev description
Message-ID: <ZJwosgmwFA+W/a3X@nvidia.com>
References: <20230616093946.68711-1-yi.l.liu@intel.com>
 <20230616093946.68711-23-yi.l.liu@intel.com>
 <20230621155406.437d3b4d.alex.williamson@redhat.com>
 <DS0PR11MB7529C5F9C31CE343AB66B0D4C327A@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZJsKXoK7SF359Tb2@nvidia.com>
 <DS0PR11MB75290D023CF2AF3D046EE6F6C324A@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DS0PR11MB75290D023CF2AF3D046EE6F6C324A@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR02CA0014.namprd02.prod.outlook.com
 (2603:10b6:208:fc::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH0PR12MB8097:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c84a2a5-9762-42f6-bdb8-08db77d3f074
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LIKvGDrMPOJuh/fs5eS3NjPdf8tV7L5VXu4NJGnRoCXpSevgDHf+qiymnLcF3RliR9yj1CT4iDa7p7qU1rjh/gs8LCxrrmwTlOQYckn2GSCQWAJVXlOj/oC1K0xfb6YmS7ekqAMO+NaMvNvODmhzCe/yWXywnoXzY6/IlbFekkuMY9rfvWKIQr8imAoGTGrBcibxebChKGZsRz7vN1My75+MTbDmylBNz98Gol8Av+2b0S3Wvll9ImtJUC7BDaPbSRdfCtac2K9M9twp9nzZ7OqNvosmOt4SbeVYKWFiXm0hMgbeYlPQrqPgJ55b09yyVF2Das9ksiSgnb/NvAyHkhbY/7GU8V7pCuO56CSRinr4OOIMen6FDB3R72uaUHG3oZfvb+Myp2Jy7HLmqUegJYbBiDeoCF+Cq/owSRDquPNvUBoGat52vcFP4wimEv3JLMDv88a3hAU/NPBXC/7rTGMhpY6jnBSkxGoTDNKX7HUC4R3ZOVPNapb8trhB86W+ZPtLzVzc1JNb4c3w94Z0soVdw03B0S76w3lQlwGfRcKiebJDRFDvjCm08u68GxG5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(136003)(39860400002)(396003)(346002)(451199021)(54906003)(7416002)(5660300002)(8676002)(8936002)(41300700001)(2906002)(6486002)(6916009)(316002)(36756003)(4326008)(66946007)(66476007)(66556008)(478600001)(86362001)(38100700002)(2616005)(6506007)(186003)(6512007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Tk9DNDdPS3JoNGJGZ2ZtSjdaSytDNTcrNHVSN3NNbVVsMUtnL09UM2VONjhN?=
 =?utf-8?B?L3FyNUhINitRYXNGaGQwZjNsS2ZmMDF5R2V5VjMxUUNDMDBVU2c2TUZUNFMz?=
 =?utf-8?B?Qlc3cDFFcjluazMzbGpQYXZKTE4zU1dGMllQbTVnYjlBdU1iamdFV3NQNTBs?=
 =?utf-8?B?S0ZDN0ZVUEdzSllabTlmNXNTeCtHVGN5S3hiMFk3OVNjOFB5VW03UWZVSHZ6?=
 =?utf-8?B?U0d6NGZhczdaODVjM0hzNHNOWUxoL0Z0blRINHd1U243bHUveTNTQzM4ckhZ?=
 =?utf-8?B?OTlnQVJBZU9KbDBNMTlHbFlvNi9Cb3M4eFdoUzdoV29Va1JjTXZZQlNhNmFs?=
 =?utf-8?B?Q2hQNFFzcG1VcS85MUUrdnFra1FIZTJlV21HdTFRTStyQUp1Sis3MlVwRys5?=
 =?utf-8?B?c3hNaGY3SmZTWnQzbm9MeWFDZzFyVUhkTWgrTFQvV1hJeGdEN3I0VWF2OGhK?=
 =?utf-8?B?WGF4VkgrQlNHVnlLTm51Qi9SMHJVNzZvellXd2NEVkNHMUtaN29hVmZUOER6?=
 =?utf-8?B?OCs1V3lBT0x5UjlvZWpyNk9vd3VxbVFrVU53dlVtaDA2eGZnUHhmZUdrSG0z?=
 =?utf-8?B?OHJQK09KdEFGenN2QTAxcTFuNVh6M0xLenVMQW84MUs1WHdWWE82WG9iTGY0?=
 =?utf-8?B?U25ZeUE5VGZPRmYvcG5NK1RSK2RHVUE2VGZuK09NbjRNZCtKZGdVUUh5dUJX?=
 =?utf-8?B?YWxVNE0yRXpiSVE0Z21EOFhmZ0ZRai95UVZqSlg0dHpHdjBtbW1EbkhJM1J1?=
 =?utf-8?B?MmR0OHg1TWR5azVlVlBlM1JhK1pZYWwxQlpYWDNsM3N2cStBd1pvZGxQNkE5?=
 =?utf-8?B?TlJQcDM2eHdTRSsvZzJKVzhBNnZKTWNtOXhPb3BvYlplRGxSbExIeEc4VHhx?=
 =?utf-8?B?S3Z0d1BJTDVoVlZJWE1vS2VSS1B1R2gyeUVsbHFVejZyODQxQjUzTFJmU1pU?=
 =?utf-8?B?Y1g0UEkrNlo2VndYeG0wMHQ3eXh3QzVvUzJFUVVCZkhyNm92WWoyTUZWV1or?=
 =?utf-8?B?dzF5bzBPdDdzZ0pWdk4xbXllcHVIUHdDQ1A1Zi9TZTQ1WkwrQlM4aDc5YjF4?=
 =?utf-8?B?aVhmSmw0d0dvMmsxTU15VndLY3Z1a1htWDRvaUpxenRPcFVTcnlOQjJWd3FN?=
 =?utf-8?B?dXhFNk04ZmVaNnpQM0VoNEovYWlPemxSMC94TjNkRUwyY0hWQzBTZ0VXRytm?=
 =?utf-8?B?UnFRUWNxQVFNdHBYb3Q4SkFuYVlUWW50ZkRVaFMyVmNZSTBHYS8wNURkZTJ3?=
 =?utf-8?B?MTl4Z0xlY3dHL0pWNHNVNXZxRjFzT0x1M29RR1ZkVGlseTFPNjNJSUZkQnlv?=
 =?utf-8?B?TTE0clRQeTRXN0xTS1ltSFowZjIwcGNxWmpyampUNENYSm0xbWU0cHZOSWlQ?=
 =?utf-8?B?OFNUL1lPbXo1TUFLR3BkemRobjZzMC9ZWXRxa2cwMGVNN08rRlgyOFUza1VX?=
 =?utf-8?B?QndLYytrUXdEQlF3aXdlTmg1bXNWRXpnNnlidW42ek8zSXArU1k1L3FoRmZY?=
 =?utf-8?B?OGJ2TUJjWmR1T00zSmR0dVlpRnh1cXgvbHR3Q3dpeWVwUkVMTW00UnlGOEpj?=
 =?utf-8?B?OU9yUmdia1AxTllEMEVFNDNQc3I5c2Zlb0pKUXFVMWVOekJwVGJrdkxQa2k1?=
 =?utf-8?B?Qnl4NnBtek8zUUVic2J2SHhYM1Y5bjc4UUlqakNRU2lYNWxxSk85QUxIV0Jx?=
 =?utf-8?B?dDhqSytlWVlaZ2U0SkZRcTNDYVhaUVdGTzlOcS9icWlZdjRZUlFLL2c2dHJx?=
 =?utf-8?B?Y3NXa1luUFgvTEdNNGZZY3VzdG8xWmRFTjF4S2Q2aWtNRmhaekNBTjlkeWRO?=
 =?utf-8?B?SFZQd29nMmEyNGpHRUJpTlM1QnZ6T2V2U2pRMXBSRnk0ZnZIM0YyUXNpR1Br?=
 =?utf-8?B?bGlxckpDa2RuSnhvLzdUT25HWmQ3UzFFVjBEU2c1Y04xbVdnb1RkY3lyNHJl?=
 =?utf-8?B?cVRURzlaVytZdVN6SVZpcGNFVzJsUERCUTdCb2lHanE5Vy9PTHZ6UERJVjNY?=
 =?utf-8?B?MElra0RWL2FBVkFsUHRnV3VhNWRxS01yZE96RDRxUmdlRXVNWjZXSlRjLzAw?=
 =?utf-8?B?ZnlOS2NxS2RtNVY3aWcwdlcvSjhQYi9jWC9FejBqMFJMU1B5Z1V1VXBDN1o4?=
 =?utf-8?Q?A0eo3dd6CaNIvanGsQV+lIpp/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c84a2a5-9762-42f6-bdb8-08db77d3f074
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2023 12:33:56.0829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dJulQlF01NPBv8D4nrt0jWgeiyswusWPxQOaAg+k1BBLCVjslFoLPd2e4+sONaNX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8097
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 28, 2023 at 12:56:40AM +0000, Liu, Yi L wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, June 28, 2023 12:12 AM
> > 
> > On Tue, Jun 27, 2023 at 08:54:33AM +0000, Liu, Yi L wrote:
> > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > Sent: Thursday, June 22, 2023 5:54 AM
> > > >
> > > > On Fri, 16 Jun 2023 02:39:46 -0700
> > > > Yi Liu <yi.l.liu@intel.com> wrote:
> > >
> > > > > +VFIO device cdev doesn't rely on VFIO group/container/iommu drivers.
> > > > > +Hence those modules can be fully compiled out in an environment
> > > > > +where no legacy VFIO application exists.
> > > > > +
> > > > > +So far SPAPR does not support IOMMUFD yet.  So it cannot support device
> > > > > +cdev either.
> > > >
> > > > Why isn´t this enforced via Kconfig?  At the vfio level we could simply
> > > > add the following in patch 17/:
> > > >
> > > > config VFIO_DEVICE_CDEV
> > > >         bool "Support for the VFIO cdev /dev/vfio/devices/vfioX"
> > > >         depends on IOMMUFD && !SPAPR_TCE_IOMMU
> > > >                            ^^^^^^^^^^^^^^^^^^^
> > > >
> 
> Proposal A.
> 
> > > > Or if Jason wants, IOMMUFD could depend on !SPAPR_TCE_IOMMU for now and
> > > > the existing Kconfig options would exclude it.  If we know it doesn't
> > > > work, let's not put the burden on the user to figure that out.  A
> > > > follow-up patch for this would be fine if there's no other reason to
> > > > respin the series.
> 
> Proposal B.
> 
> > >
> > > @Jason,
> > > How about your opinion? Seems reasonable to make IOMMUFD
> > > depend on !SPAPR_TCE_IOMMU. Is it?
> > 
> > The right kconfig would be to list all the iommu drivers that can
> > support iommufd and allow it to be selected if any of them are
> > enabled.
> > 
> > This seems too complex to bother with, so I like Alex's version above..
> 
> Sorry, I'm not quite clear. Alex has two proposals above (A and B). Which
> one do you mean? It looks like you prefer A. is it? :-)

A

Jason
