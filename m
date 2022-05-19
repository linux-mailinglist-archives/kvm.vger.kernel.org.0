Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3D752D29B
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 14:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233256AbiESMgF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 08:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236758AbiESMft (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 08:35:49 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2069.outbound.protection.outlook.com [40.107.92.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5840612D
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 05:35:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y/V3vkvsU05/wnVjBbQrdM78hev88/6aGiKMoNPpj1R+ji/3iUpwficAUJFPgjLZxI8aj6E0r2DsFpv1BdvcB/auzAVx43IPlHKhIw/dPlTs93HdVFcM6VnHgab0G+l7D+EsByL7T+1obdRBZtDh6Fr/hFgG3CJOQ+OPsMHXGionZ3DICYFCnJDOMXSxWolkhlHIOgyrtcp/sKAyeoUSEet2MgohzhXRJjkvUR1yIZR5RbDeGqbOyZ8fIZHEZqi8F/hqH0koSZJi1VSDiQMPn7weAxl0otL3DXV9HG9XvjzjBtG0Rp/UFFpDe6I2LPUqJXU3T02FVgKS7KClB0MDcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N7Im2YwymKg1Z320cWQBSyUWTpOcn7mpdmWxhreCgMM=;
 b=ONctDoBGu4+QYij1IfHQhaFHrTedIzR6iZhAmx/ka1At78ABA8Og9W/WEzmV6iu2B0kJDtm9ccrgKWKFqwq6+8YDJTeFSKdXRPvtQeCLLOPrkV/8l4yVzBilv+CPXPqVb9Bw1xmlfUKf1agp27aAp+oyL3BMcHyTXdlp9E9vESo+/J+ebV5dBBATtwIKZPwnGR9uWLxRafsyQXWbe/bl/iom+ArxucM9UHmhzOVtznbwtuz/T/YXN+JAibAWAyrt5J+w7ylHU/bN04FCcLtFUV0u0EpszAqQTC6XXWmI0DEYr+Ltvjtyppx+VqO9/e9unb6+DnmQqaqNmTnymFt+uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N7Im2YwymKg1Z320cWQBSyUWTpOcn7mpdmWxhreCgMM=;
 b=UHwIwRBnWS0WlohbWE9bH0Cfzze90XS8/uSmJmoZiuZYQz0pg8VYpa0mflGNuQxmamN3fRZj/2pDN/z0242un/sYbI3qpYWY55GZIISRi1cASR+8pd/VwwvW4AxvVLxJx7vUOCpFnkUz9WPJe/FRgf3Fs1h+hmpa6N3kLnC1yXzfCX4EqAZADCuB9BJb5oZ1im6cE6361XHO0DXybXMNyMDYB2MwLkzEe6nx4owvVhAfh+g3ZFQ5sigd0jZAztRfw+4423n7NygwbuqtIUGQrLhB9b0VXWefxj9oQFpST29XSATVh9+WjmVCONAGburmPtzGFI1S9aHqpDcbh9HgEg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BY5PR12MB4194.namprd12.prod.outlook.com (2603:10b6:a03:210::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13; Thu, 19 May
 2022 12:35:41 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%7]) with mapi id 15.20.5273.014; Thu, 19 May 2022
 12:35:41 +0000
Date:   Thu, 19 May 2022 09:35:40 -0300
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
Subject: Re: [PATCH RFC 10/12] iommufd: Add kAPI toward external drivers
Message-ID: <20220519123540.GY1343366@nvidia.com>
References: <10-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <5aab6dbf-df12-34f1-4135-857174fbe083@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5aab6dbf-df12-34f1-4135-857174fbe083@intel.com>
X-ClientProxiedBy: BL1P221CA0006.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::22) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b80d2074-f158-4c5d-5817-08da399415f7
X-MS-TrafficTypeDiagnostic: BY5PR12MB4194:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB419458D0E2A734A3BE066576C2D09@BY5PR12MB4194.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4ghSX7+7rGOV1vPAV3rvvlEQQeRNz5S3lRGN+rqaGUWShIHYdfColvtfD9B8Vzzt1l/+BsOnyUfOowYzbfa/eRiMna65oRiCYBNaLAK2KE4Vm7VASOVO0zSOTGYOx7M0daYTQ1u5sA42u9xrVipiRGzWLqC1r19JSw5JjmTUezzmno10Djk50NqU2V/emQ+EcpXmxixnvpdEOcId9jD8dix2+07FTDP852T5ERso6Wm0oF5TYG9QDNm5rHKU/uOnfal0eea/7T1NaGndKdbM5Bkmnij9kbkP/WvrIa7Q/d2Mr9PBbDJxLI8qtjNtPF+97CM+nkUNjsGsQjTHMjYxylrQJ1liqdSvgLZlOIXWm0DafWU+AWP6xk4TDt/Nqh6M5Ve+WH6O8COPzaEmixjVzCf5j6uzN/2judoZmamDIKqiYu4c3ER7lH2o6PU6kVKaxnhkWtRcXiylz1cRYzo6ss29JIfU/PnvtPKdBobRWSxkXSdIyZj+OY2701tl503WXBCHlhNq3IBBe80w5YSZwWHYGodi/YUUYnK9Ouvv0C/gJov3KqgVwySs2EhYy+w+uHl8wIBTzg/N4k93b4d8hTkVR7BvFLCPU2CARbMVeykXzrzW8lL4sNkEKQdgHOki5q83tpXgOp1u8SHx2zk8EA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(4326008)(316002)(8936002)(6916009)(54906003)(66556008)(66946007)(66476007)(5660300002)(8676002)(33656002)(6486002)(36756003)(7416002)(508600001)(6512007)(2906002)(186003)(53546011)(6506007)(2616005)(26005)(38100700002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8+9BUG01eb1FzKu/m5ojC88mO1wiAkSQLSFIisjPSglruc6s3cF+vLkg2pm4?=
 =?us-ascii?Q?90xZqpytmzIZmbm4wMXggo6AnFl0aeIjBR6VO/cWjWEDtWifQxUYhIrftr0b?=
 =?us-ascii?Q?uPrbeS9XPykzuxNnQA69bkKrw4Vdr4pO3WeMSR2gGrl4UMf9njJvG67utQ7K?=
 =?us-ascii?Q?HDdd16F7MNtFV7cOunYJq32W90BE2fSlrRebhz19d8uXyMjQ+PSyllHMGfXd?=
 =?us-ascii?Q?3jRJAJW/8Hkrk4+qYnSr1upqJERHkJ5j2yrGbVc8gXagNvM/BUMa9NdCC+Is?=
 =?us-ascii?Q?OINcm1r0DIPwzSz9xCFJTqF07zYFM238JtzRcLsoYJPhZ8WLdmqvzmZrKwJe?=
 =?us-ascii?Q?u2udDEc5cVwpOMSRGDX9wXdEv4Syx4BPwqdZXByLOiA5IjHXohaGLITErelB?=
 =?us-ascii?Q?vj43a8cMaMl0tY1vyH2idvWLLzgo6WVtIw/haP27H3jcubYtvglF9ofgHEwQ?=
 =?us-ascii?Q?vOYTNXLOs3m+kkW+LUMHCDWhRklQnYH6a305hZKRxVOLMNFgwmN4awNt4V/Z?=
 =?us-ascii?Q?mPOHLUecsM2aJyIpBHdEiDSQzF9upLKsknKzncHeMJkRoFdIxQcvyi0VqkX8?=
 =?us-ascii?Q?9PT3LAnA7Kfcrd5gpas0dbyN9nK+OF4X7NeSAdSOtnCnAnOilU2jSIBd1srW?=
 =?us-ascii?Q?PGHosytjjsfXh5CKd060/7AQpILF6nrzYzBKbbSs9Y6QF0t9oCOwnw6Roe0o?=
 =?us-ascii?Q?yBbGtTrTiZz1k4oqdljhLqmlBtSOQYarEoQujNtIXw/l3I/OBxzLOrTDSZUU?=
 =?us-ascii?Q?7L5LxiAusOGf0orDFd2vwNqqE4g0DKpJ7VYHad3fmBHo5xVMI9S74fO0NRai?=
 =?us-ascii?Q?RUqJxqmwR9y4KP5wO6o/F/G7Vo/cXiN552tGHpvcYhrY57j8cnbQwOkhUBzi?=
 =?us-ascii?Q?4RG4xjNZ+oFFq8ZV8VOtEfIPDX0LfeWsSb708dTsG6SyiAVBP5jpp6yINgTI?=
 =?us-ascii?Q?bNMg7Ss24gbIJVYmFeYR7cvJaf0W+xoe8PLJs7sVrFuLH9LpHblB5ZxgOkLB?=
 =?us-ascii?Q?dSIvEqwiSkpVoXAG4HS5Jb1sLeLXSFItr7kEHznsYify4Az0HTi6Obb1LdSK?=
 =?us-ascii?Q?iP5UMgn0ryeCtwHcuGr6/p6bFN34ftsVM7yD0v9pMQoKEkuagwiQSNKg6+H8?=
 =?us-ascii?Q?XZLC+E7A7TEllse3eeT3vbUXWctZLo/JJd1BAndPP674VLlB1noB+49Bfzb8?=
 =?us-ascii?Q?hP9e820PqPWjcSLvqBsh8Ad3iTFLKRNzbH1GuTaIfRBZxvjaOLMva1nJ6bl+?=
 =?us-ascii?Q?2IcZFQymr4vRwNIFF4o59ErJuxCB6t5P407aojsp9jwN1JeIFIg0pIE8rCs4?=
 =?us-ascii?Q?6oafHQ7qjmx1NjeQYGFdXcEPkdYlZ1wO/iq+MA66rG/2TojxNXZg1V60pzXY?=
 =?us-ascii?Q?aElncM0rUhOu4VxSQu4mX7gdr86k3ElnKKksdL5TIa2Fjqv8ZOC1Zcz9dt8t?=
 =?us-ascii?Q?SXHr24qfhmHXI5KqO4qAgFhHOPh6f0zww9OOekfr9RqVlfqhcSVNDNda0kEj?=
 =?us-ascii?Q?sE3G8Wj11CcNsokRKjs5KkpQ6XDtGgsX7uRuVN5UM10auZabzxk4dfOeY5+d?=
 =?us-ascii?Q?9ZLHjEK6PsVIOMxVM7bdYHsbNMfptRT0pjlVOIjTG1jccAHLbYqSCixwxrRO?=
 =?us-ascii?Q?BxmBzefizIB0bSsMK8TeRtamkil+IOGxIEKuYEPPvqYne1HgVK9f7wXJfz3o?=
 =?us-ascii?Q?JhtDksfYWimEvCOfjbwoVqJarTe+R5INvx9haD9iAHuk9tqkNlViaARwq5ML?=
 =?us-ascii?Q?SVZg63S3QQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b80d2074-f158-4c5d-5817-08da399415f7
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 12:35:41.3758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k8ayqFZAIBagaLw/N8P2zxmVCa3BUps+60b3FW7xew5LO2FdJmqusrkRK3j+WUQs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4194
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 19, 2022 at 05:45:06PM +0800, Yi Liu wrote:
> Hi Jason,
> 
> On 2022/3/19 01:27, Jason Gunthorpe wrote:
> 
> > +/**
> > + * iommufd_device_attach - Connect a device to an iommu_domain
> > + * @idev: device to attach
> > + * @pt_id: Input a IOMMUFD_OBJ_IOAS, or IOMMUFD_OBJ_HW_PAGETABLE
> > + *         Output the IOMMUFD_OBJ_HW_PAGETABLE ID
> > + * @flags: Optional flags
> > + *
> > + * This connects the device to an iommu_domain, either automatically or manually
> > + * selected. Once this completes the device could do DMA.
> > + *
> > + * The caller should return the resulting pt_id back to userspace.
> > + * This function is undone by calling iommufd_device_detach().
> > + */
> > +int iommufd_device_attach(struct iommufd_device *idev, u32 *pt_id,
> > +			  unsigned int flags)
> > +{

> Just double check here.
> This API doesn't prevent caller from calling this API multiple times with
> the same @idev and @pt_id. right? Note that idev has only one device_item
> list head. If caller does do multiple callings, then there should be
> problem. right? If so, this API assumes caller should take care of it and
> not do such bad function call. Is this the design here?

Yes, caller must ensure strict pairing, we don't have an assertion to
check it.

Jason
