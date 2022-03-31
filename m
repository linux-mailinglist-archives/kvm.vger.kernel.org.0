Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60A164EDA1C
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 14:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235005AbiCaNBY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 09:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbiCaNBX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 09:01:23 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2076.outbound.protection.outlook.com [40.107.95.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C2A194AAC
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 05:59:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QzJCOsAg5Pf8h6fS8oyoGT6NQBDIQ6J3N9OIssbWpN8nXt81g/XnRx2nUQDTlJjBBgqxTB9L75bi4lcbcnxXqniMPb09l0aMSi6E0yvXXqY9hl9En6ZyWE+BjEjS13lS3KOGJ+UYI85O4NCxJG5hRl9drR4rMfAQI2HN8zJzzVmXH78p8WVZxU9tW0eifOGZUAMw8bWZAjEazEfL6d2IDkBUGkmaX+0WJKAMgo4QNh9SLtJtRCYDt6cdwpV6Lb79a0IpkNLdO4maj1JaPbaaF8KqjHcE18UeCb3inEuddBVwSQzt4fRSxh605/dp0AB0CifihzWhEk7VlMOtSWfJAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E5cW1Hn1911/kh3V0tdFQVPftsIiVBRtJezswF0+MLI=;
 b=GdygjhqHeXQZleXfbaibFFfpmrnx6mMHMY0qpFBE+RoCu16fjByluyIeopoz9GA/PiLk9uWWeGf+TxCtf86XnZizrMbtfOlW/CFYQzscZR23AZphFZXLP9cqwx0wOgTgFHF9sNpwQ4JKi7YpSTopJ7WIWuqea2d28N0t+lMLzKgqmX6yZgtkJEHZbCQx0WZtPzY49XizMmiglL+7UNp25qbzQGtzxqPO9WMb3az9nah4gE34TWZE8jFx3oIh6K+ROpgZqIXcSNmAQvyvO4r2gADzArERlTNCaifv9Ob+nvgrd37a7o51+hzPWLSjI2sZJAFNESZctvSmec/kDHmx3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E5cW1Hn1911/kh3V0tdFQVPftsIiVBRtJezswF0+MLI=;
 b=OLzzN2dUyQ8EXgQsr4QRfmr3oRWATMEOEpBSy+SiotGsGGtgwZvm6re7iX8xmEzkc+RAIcR7diL6tIZ9i+FYxH0GVq+EarLlx2b7Mki57d6m6vSm5xb450XvVVbJCfgU/eGS8fopZXlxh8nEEGtl80aCwM/Ht109sjJC3QpEFqtJpgXNKredADuAtOWOZdPtn2kjpI067/BRmqcCQQCLw7PE92KokG0qQHOo14QsVMsGU9WMs8W26165cQY9kIZpj2YfsGXYeKXx7QwLAi45o8TibLDBFTY1goulmxSvB656eVOE/dfArjQBbh4FoOeFgrn+d8/oQac2HzF68jWPag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH2PR12MB4023.namprd12.prod.outlook.com (2603:10b6:610:14::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Thu, 31 Mar
 2022 12:59:34 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%5]) with mapi id 15.20.5123.021; Thu, 31 Mar 2022
 12:59:34 +0000
Date:   Thu, 31 Mar 2022 09:59:33 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC 08/12] iommufd: IOCTLs for the io_pagetable
Message-ID: <20220331125933.GH2120790@nvidia.com>
References: <8-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <cf303486-fd80-591c-f9a4-d39591c7d0b8@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf303486-fd80-591c-f9a4-d39591c7d0b8@intel.com>
X-ClientProxiedBy: BL0PR0102CA0008.prod.exchangelabs.com
 (2603:10b6:207:18::21) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d05aefb4-7e7d-4a96-12d5-08da13164e04
X-MS-TrafficTypeDiagnostic: CH2PR12MB4023:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB4023B806E54633B69F710C85C2E19@CH2PR12MB4023.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W/KB0ewFwaDcYtZMPx2ghwvignlxAe//mCoe/O4KJHlXegdlv0wfYFlgujYKrmlDjRM6UKTWKXkPm4YT08JNPtXO87t1jXvm0IiM5OWuF8OHdVFy1lb0bbZ6xD0vYmHfITtUtsHEyfWeejNWfF+FgFqyJ/X8p3Wkz6mpjWsCDDVdu1Ml6zmwaVzrhXKOVi0kzhC5DGAYKnNQZdEslMLXC7msAdCC20dGEwRKrmCaRjh13fvKlL82neDkHmNljsmGCdSTJ+MiME+31E2Ej48IAKNpLIJCgimR5/symDr3ZKh3BkhaFkc2VF1qpV9ELHECaqMasX2ZT1ErcSqgFcj63FEmO/aj6hctMXx6dt+6zAhj88xohN1ghEE31IvZC7kBgm5iJPO0Ivh1Dfiq/QUBrliC8XYC+bFSMsDSXNWFFYejFDPJ0P0qQQl0GdOCrr+6+rTZNQcd32FgSlikMzcHOHFdTFpgYWhn1q/tpy/xkkRf8BOSxXN7LqtFk5ODpGUKoUda9IE+9GwBeCHrCOpQH3N0fmbF1qH/yIza7gKgxJa6kopZ6du4i/sx+w/clM5C1LM0Bnmva3ixV1yE1Q9t285+PKcBlh3g2xlwBRLvtgXbQVShIc6vs3GU1Xgb+0WZtqKT3MWi8MuzDyBdHtSML6NQdDuUssjxIZ+chpJiMg6Rju++sVPU4JAyUB/c41NA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(54906003)(6916009)(33656002)(38100700002)(6506007)(66556008)(186003)(8676002)(5660300002)(1076003)(8936002)(4744005)(66946007)(7416002)(6486002)(26005)(66476007)(4326008)(2616005)(86362001)(508600001)(2906002)(83380400001)(6512007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/dtwiw7eroDyW/2ahCrwSrt0f7Ddx5qjBzAn/O8Xkuqi2V1nkb+NBuZ9yy2C?=
 =?us-ascii?Q?Gf+FaSk5uOMgFtmoK5Ue2ckezFo0zV/gVdnJfJMN1hbE/PSWwD2xdmlfHqpY?=
 =?us-ascii?Q?VxixratVw0UdDe1ci/3cvuh3o+8tdbdhhUUZDnf7k6Ch8fOiMKjMInAioKbK?=
 =?us-ascii?Q?HmlWBeBBwbtsPP0XPAIEBzzEMkqWejYyFOBdeCbQ1f0jhHcelkl6bzEYIf/6?=
 =?us-ascii?Q?BfrNF+XI99l4XbOGyZ2LQ078ulkQOK87OrPHJa/RT1qQ3Oyw4gFHvTDORDAu?=
 =?us-ascii?Q?jRyXQjU6bz2BAdA9Nh4kdvT6hnIck2nSQDyXuP7XvOQVNV3w3E7XxnMgbi/B?=
 =?us-ascii?Q?2GWQI9sBTggSlaHfAgI961IOn3W+zGdkPzII6ClCe9bVOrodd1ssURTHFlv6?=
 =?us-ascii?Q?5hCEK6g3y5e/14/HV3qdtodupIrw/BVeLSc6Zg5lWWNx1KSCzhocSUnpgRFp?=
 =?us-ascii?Q?DXVaQPHv7oj2QvuPPg0vfM66IkeU2fYRwxxkljFjhG9iFn/4wJKbOlTxnE5I?=
 =?us-ascii?Q?imcZHFRYmKr0WI34qKU1qvWer2fH1qzWpeOuCxTxckRhVn3SV8IcMk9hP7qk?=
 =?us-ascii?Q?0mEqGnpk0vNGLsy9v18RQl9FHcBfztTkcWeIxHiLPhNVWDGgP6BuG+EqK9J4?=
 =?us-ascii?Q?yO67Z41W9RQ3bOWHGLacl/H0QOHB1pi+6J0i/5qzb2xh5si4CtvqjjF1Yw3n?=
 =?us-ascii?Q?CT8ISPeXnP6cxjvz3ZD3ESxN3kBSSSLcvWK2a9NrH7YnsZQ3OLWlelTxatyM?=
 =?us-ascii?Q?znd8noxRObDPfxIWwDP5xJKUVQNd1/757Tvti8p9k7b0Jl0o3N5ai7XX9IAE?=
 =?us-ascii?Q?UhCayshInor4mOGrFBUpW1zQ/TjCJawtOYxrS443mBks3DBzj9d2EXFw9MFJ?=
 =?us-ascii?Q?ehsDFaMwxQIYGTQ3KvL6iDOBpLWUMQD7FvQdPWAZVwm5aHMt8jCFFE04WLhu?=
 =?us-ascii?Q?i1nsAaH8c0hDnqsfIXbp7bEriZbmr4OPslsHwu6lFQX4EqhLh2cU7PWc3Mgk?=
 =?us-ascii?Q?GOsoqyF8TjkQg9L8h+8ETHv1YhfsEwz3tNfgQV1gv3pZYJd7QUE7jm9b0HTv?=
 =?us-ascii?Q?OlvZOUOx/hzBd2kPWOV4NyTd7bJ6UOka6hYYW3mukL1JCJJ06pM4mxuNGpET?=
 =?us-ascii?Q?VxzcFPrVaIWtlWBZQKsVK015nTPwi3ts0CGQmLV06ssIPbRpFXJ15MKdSsn9?=
 =?us-ascii?Q?BSSqDRKO9lHBfZ2qoZ+BGgvVedx9Q7bfmxtSOc5HvcLMLr1SIGie5fHcDL2O?=
 =?us-ascii?Q?7W02dEazzrlU35mOmz8nhQKiLkKg0hQquFCN9ciOO0HN6YwEzLglfTAHez8t?=
 =?us-ascii?Q?ys4ipqPXQsRHGFAo076gDc6ReHNa703b80rMwjEi90gc8by+R1bEuIcFnCuB?=
 =?us-ascii?Q?hi66an3bM78TkH27edMvs2xGnVhykofq24esE4/t/dUguZEkwOTdpSzl+Qlb?=
 =?us-ascii?Q?TS98IP5LfxwbDaAEXm/D5kc7LWV/7sqQIjWJKCCKt0lM1WFe/+XMb5BnKCDT?=
 =?us-ascii?Q?OxQm8NJMuDO5ZcF3irUxhbhf6hBclp2YAW7yHdgkMYexsbXlfFPol05elVAY?=
 =?us-ascii?Q?8HY3NRnop/H2Ydr8Wxsy/+2laCX7ELz6eKZyBdimEGazzqKS5dsw7o4HvKms?=
 =?us-ascii?Q?Cv0F70XLmYW2HWtTCJdX5EUjKVRHO2wQ444gzaFnyCKT/xmClH9Pq2qgXt+i?=
 =?us-ascii?Q?v19wVkmoWi2APYi9GvAgVWq6hUYyp0mndCriajdedjmq5YrJVG/kY+mPZVk2?=
 =?us-ascii?Q?vzt4D10c9w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d05aefb4-7e7d-4a96-12d5-08da13164e04
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2022 12:59:34.7318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kKBboHjurZHENDcOMKmbdbBtIMEM7G+5SA1K1YxuR5m0PN4NXIekfQI95Uw4PTvt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4023
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 30, 2022 at 09:35:52PM +0800, Yi Liu wrote:

> > +/**
> > + * struct iommu_ioas_copy - ioctl(IOMMU_IOAS_COPY)
> > + * @size: sizeof(struct iommu_ioas_copy)
> > + * @flags: Combination of enum iommufd_ioas_map_flags
> > + * @dst_ioas_id: IOAS ID to change the mapping of
> > + * @src_ioas_id: IOAS ID to copy from
> 
> so the dst and src ioas_id are allocated via the same iommufd.
> right? just out of curious, do you think it is possible that
> the srs/dst ioas_ids are from different iommufds? In that case
> may need to add src/dst iommufd. It's not needed today, just to
> see if any blocker in kernel to support such copy. :-)

Yes, all IDs in all ioctls are within the scope of a single iommufd.

There should be no reason for a single application to open multiple
iommufds.

Jason
