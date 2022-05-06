Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD2551D705
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 13:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391503AbiEFLuP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 07:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391506AbiEFLuD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 07:50:03 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2052.outbound.protection.outlook.com [40.107.93.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8395D5E76C
        for <kvm@vger.kernel.org>; Fri,  6 May 2022 04:46:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EkUulEAuwQinLqmVyjsrk3gjnbJT7wUpJ+yUaloTxewrw9EVLMnCY+mpsQgUyrCCss/d3RTQl8JiGG/CyO3dBhqx/Y2iz9WQRIlg20U0DN2A/6vf/STju2DhnoVJPyZ0/ORvrWYpog8OwOyUA42bBpxX+4b+xomfv6ptOuazngHqM3xD7qz0Zghtrl8naq6IrVoZWv8AtWxhuJenaeaSNaHzHDTbDnSWaCSuqn8OLowgIN6gWB4Ms0enMDkuQoxTGsctvjRQcNDyQ3x6eqnhmbaldRAFWvoJrqJxNBw9v3PQbgK3xX2NR7R5BlufwI2qjdZwVHR6cJ6T6Q1khD0iUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IiSm58fcO0vtq2z/fWj8PJAKjlDNiUYlPBnSoaIpJ3E=;
 b=LuNv2mnaPFodkjfywXmgIM9UTU+eL6ZHYlJwn7gxdx112Q77tV03Ag9yk/lfSSMwv1kD/FtR47IyJCGs/oIsSL/sS13TEkgK2I5QCmCxsxVSahXczPtZ0xlDFKrN3GET+MJcpoIajGbsQO7L7wHRu7T5137J50n7P3dRnCDGPU/q0VIVgrNBvQeMxaw3pVCC4+z6hBz2XfDndvlgayqKG7j89npx8SCZWH4oS6vve9u3UwQW+kc1Gh/yAiqH3WELWA/XUoJzGeeIwXcS/gC//CBolBzz/FRJTUUKEax242n6/OWdfXqfKXwGIszd15hx5aJ2pBI3w31hmGD6qBvnLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IiSm58fcO0vtq2z/fWj8PJAKjlDNiUYlPBnSoaIpJ3E=;
 b=AliXr/kodjdYUmlq8p8bCXckaMqdQiN3Rba1FIA5YjQ50gzmhwL9WRmXCPpzUuPYEqFJE+43scYfARU7KVtG6GX0xqX7014KZlYlSC0llEQX4/ummZhFxqQS1wOvadKYHOH8cf5C56aD+lNbXj9ntoWEBHfp88UIOn1D1hWyQJNJVdlkgnqGo6hoUZg1/OQk7CYph0aX17J5XnXzLanjC+n5/eWAqD3HnWsBwgMATmm1bCjiKlb4aweeWKonoYAr8qCCN1Sdfpzcc6LusxbcpU3cGP6GWmIQucjYHZbIPTsK1tr8jWyTs1TseIyyB/QJPGlnDsubJgoyxMroODC2SQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN0PR12MB5811.namprd12.prod.outlook.com (2603:10b6:208:377::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Fri, 6 May
 2022 11:46:11 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.028; Fri, 6 May 2022
 11:46:10 +0000
Date:   Fri, 6 May 2022 08:46:08 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Martins, Joao" <joao.m.martins@oracle.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH RFC 00/19] IOMMUFD Dirty Tracking
Message-ID: <20220506114608.GZ49344@nvidia.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <BN9PR11MB5276F104A27ACD5F20BABC7F8CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <f5d1a20c-df6e-36b9-c336-dc0d06af67f3@oracle.com>
 <20220429123841.GV8364@nvidia.com>
 <BN9PR11MB5276DFBF612789265199200C8CC29@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220505140736.GQ49344@nvidia.com>
 <BN9PR11MB5276EACB65E108ECD4E206A38CC59@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276EACB65E108ECD4E206A38CC59@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR07CA0012.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::22) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c43cce3-0a06-4b3f-1858-08da2f56034a
X-MS-TrafficTypeDiagnostic: MN0PR12MB5811:EE_
X-Microsoft-Antispam-PRVS: <MN0PR12MB5811B1C43C7DEAC697BBC60FC2C59@MN0PR12MB5811.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hmTnP+HIovtytrBxljHNekVAePfDRsGugJx9JiMj+eejQFyPQ6fLcbFr3fdK4rUX5HLCluI+9AEKBe1aooOOyv31Cn9xX3vLHoQWJ2I8O18QV+mQqC1ELFegxOqnqZrCMZeqQgknKsXBody5M0fNsb9yMspjJDxkPUkaCSLeL1IXkqNibJW29xxrgi8/qPfSO/bjp2kB5+xeKyPMHP9p/XFnW+9Kmuh3lOJn+c79MujsahC67ah2RLqG5EXupNiXfmsnx9EiXB7sO1eLa3b9dxFF94ya5/mCYSIDmifBvlQFo0cQGJjWZHIMEtiMj/GwiAZQ33/+pW1S2T0JS2sigoAksH/mo97rIIqq6xodQEVz8o14qo9mCxAbLUpVW1Cji/CWGOkBEuRsORam1di5Sz9MjicUsGGhUZ9IeANQPP06WKOF364YRHwtucLNRuti4M01uyjusSuwzjf6qFhCk1jYqYj10JBr/9BUp+BmX6kkAw9igA59OnZYkmpj04RgKAoYend9YaN4LV27cowpyzLEUs5fgsbBwPNb7WUqA0tMxmbVDGcDNC6vPOyHJLMkvg4WtmetO7S3/r2hJW9B8VAxmqvoXUwDOO6WFC9OoV85LEDKglfyIhSOxF3MAdqnH5pi0tainDhUHOef19CBWzj9Zc3xfuVZEVe0lGnfPa3NVXKmRKa9WDn6mLPLQVaS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(1076003)(33656002)(6486002)(54906003)(2906002)(7416002)(83380400001)(36756003)(8936002)(5660300002)(2616005)(86362001)(66946007)(8676002)(6916009)(4326008)(66476007)(316002)(66556008)(6512007)(26005)(38100700002)(6506007)(508600001)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DXMERRAwxMfrt6hRkuTg+sR6h/GPmA3hrRlxAEX3JsImJb7gIRgwCk/j8ni5?=
 =?us-ascii?Q?9afwtIogntEPnq7yXBBq5SlWIsqQc9xsB4WC8cDG40ABoElX95velg07qF9G?=
 =?us-ascii?Q?tW8mFJPJtYk7xBTyZe8BRgJ45XWJCXF0X3Cp6rSds1AB1lI8HD/hTdg//JkV?=
 =?us-ascii?Q?jy09Vf2KqX9hQTuf8KYCmYwHPQJdlk9hBcyS9hsyEG71f2BNRV24jgM/DvR+?=
 =?us-ascii?Q?iFzFb/k69qGcxmvbp+2qeSg4q7poTaRAUKTANdiAMBpMerh8uGdTyHxuSwOP?=
 =?us-ascii?Q?Cs5i2+mGZapBBk/m0tlZgL8t+cByr5qRUxWLBPnOiqJnS2SY2rXHcm++JCY/?=
 =?us-ascii?Q?eUwW/oaNWXHyIbSoBV/VL2yw8Pe7s/sqbG4OXMVXRDKNCsxmu9NVQv0WhcBq?=
 =?us-ascii?Q?SfW5vsJFKjIxXxnrKNFGcro017FpRZ7DYKY/LlGLVpzfLwfMT2dnG07f+C5y?=
 =?us-ascii?Q?87JWyzLWlrIODjhm9yp94Zwi0+cRLakfr02jDrdIbCb+q39+x+EQlEnd+TkN?=
 =?us-ascii?Q?zcuWD/vO97d1C3/DQc431yeId5WnTjbi1bJen3wHsq4zEwR1zO3xl96S2vOR?=
 =?us-ascii?Q?quHXqLqgcaAFmvuoH5P9pVTtGhP0qYqiLA0b6KhwQWYIo8gbcrS42wAQAX+4?=
 =?us-ascii?Q?S8FV8DwukZYnLr85jL0fEUx8BM1KGHal/LEOYqEJlOeeAgLNyGFguem1+wEl?=
 =?us-ascii?Q?YrAgyeXUDdIUzd9gfsXDC7MqQ+JRP+YcheFY5SXH7QqJiB4tT0LegKLMSuzS?=
 =?us-ascii?Q?c0o1G9p85uZnsH0xD1YuCwB4UZlWnsNoz9ZPm7bd0BVmejmp8x0YT0mvCn8M?=
 =?us-ascii?Q?bGyVXBeOPsfpvO76pDO7fFDU8V/jXXK4wZrbVTrib4PorcNM6CLgoA3HaVsm?=
 =?us-ascii?Q?0yTPMKW1sGWYNPcSPMNrb0OTZvz0nmZYKtkUIpTAbR5i/pkXkg8DfSKGyN41?=
 =?us-ascii?Q?oJfj7tj36gc/4CchjqqfAkwZ4yo7S/33y6DWBeJ0Cf8VSFlDnQmnIBBrei/L?=
 =?us-ascii?Q?YGD/56zPex66rqAToMsEuWP5y/1NdHjyn5llmupBvYrSTinqR2QxJdkAsYkp?=
 =?us-ascii?Q?+HiUJO3wOVJEBSmNvlxFxLGnxamc6nMKuSLgkNL3Hnx/s77Of7Ey35SUV+nt?=
 =?us-ascii?Q?ccsaKoUJdmwfYTFgyRgtBFrIDaMjt/N3Ql4gVqYfHFQkk8SVF+49S6uhVdcX?=
 =?us-ascii?Q?nNMzwJFZP+0mlNSjdcmR6Hf2wtP7a4hAeibr4bOJF3xQ/IX5Ws/mJUks91qJ?=
 =?us-ascii?Q?IT+ZXH+/2TLCbXre89iLwRk43eSMQAxtMQ1B9iepZ3Ywcp0eLCIdaHUcYKOm?=
 =?us-ascii?Q?+g7UpHHTT73EE3fiyn5gaMYKqeOSL04JGocnjb3J2LNW1A5U2JJcn/r3WfqZ?=
 =?us-ascii?Q?upR11JtT45VxM6i49AvKAtqIPuJaPYRKWnS9QKc/ubUkljkyHJnvf+aW3U5A?=
 =?us-ascii?Q?ryYUm0/i6Ao2JG5d1waK3dtWcOUIvkbXhwRuovSAR3Iyq6Rgnzj5T8GH2KLT?=
 =?us-ascii?Q?/cV91Zr9qWKcu0dsEGtZVB5IEgv/iZMzBlXx/OEotn2+X2jo94Q3jsS/yRbP?=
 =?us-ascii?Q?JHHR6qKyVjXAkn+XOyXcrwN/7+5yd9LaA9FvVZmu7Di/gApVhtaUOXp3ziDi?=
 =?us-ascii?Q?+9dNXe6T8rZc7DPnN8LiYSlCjtX9wpi+/UlaEEuxcJe/mC4+vUGd2N45oz2m?=
 =?us-ascii?Q?p3I/rz5IiP5lo20xiOJ8xXGF2EPkqOsJHHJYwGwOHPX0IXm2FWIuPqGEWcmr?=
 =?us-ascii?Q?rmdU3JInpQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c43cce3-0a06-4b3f-1858-08da2f56034a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2022 11:46:10.1019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TAIf9ixCu7QN9JfvVOnKxS7HK0WyRMGPHipSRKdIpTALR5BZeZCwITCxeFIPWFFu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5811
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 06, 2022 at 03:51:40AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Thursday, May 5, 2022 10:08 PM
> > 
> > On Thu, May 05, 2022 at 07:40:37AM +0000, Tian, Kevin wrote:
> > 
> > > In concept this is an iommu property instead of a domain property.
> > 
> > Not really, domains shouldn't be changing behaviors once they are
> > created. If a domain supports dirty tracking and I attach a new device
> > then it still must support dirty tracking.
> 
> That sort of suggests that userspace should specify whether a domain
> supports dirty tracking when it's created. But how does userspace
> know that it should create the domain in this way in the first place? 
> live migration is triggered on demand and it may not happen in the
> lifetime of a VM.

The best you could do is to look at the devices being plugged in at VM
startup, and if they all support live migration then request dirty
tracking, otherwise don't.

However, tt costs nothing to have dirty tracking as long as all iommus
support it in the system - which seems to be the normal case today.

We should just always turn it on at this point. 

> and if the user always creates domain to allow dirty tracking by default,
> how does it know a failed attach is due to missing dirty tracking support
> by the IOMMU and then creates another domain which disables dirty
> tracking and retry-attach again?

The automatic logic is complicated for sure, if you had a device flag
it would have to figure it out that way

Jason
