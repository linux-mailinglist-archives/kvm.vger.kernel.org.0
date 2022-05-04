Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF31451ACA4
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 20:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355607AbiEDSZD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 14:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377184AbiEDSYp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 14:24:45 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2057.outbound.protection.outlook.com [40.107.102.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B52DA66E9
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 10:49:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VlFEThWEpM/piZ84snfNNZDAQk7DXP72IPxGb1M1MsvIZpNw7/UL+syVMFkaHnkscg4Os2s3G1+QBcHcjJn4u6mxHD26m8aRbCv7zJN+RZvaqPBp6VeZmmLVo6Z8L6TQ6Si4zPKBb9Ru80ZbRYQM4jqYxTrdAdQdBOj8pQ6ZVoSpTvwvnJn1HQpPJiDUP38HfGtnk8ojAzDmDrzkLm3dlA9Y97uEJ4QZJ+gkG9mpxFAEFPNm4V5eQPEjsj+B2iLfK9p9xqrnKQqH+xgMd2Y9CsBGvhajw6B7SgHMUjgXVUy0Lv7eKbqnM7Uu80FEuX1SqFjgpN3oVWcSQNha46mFfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6/msDaQBaxIRV+7Y3Aw7xsgX5IcidTFoqnVkJy1oDMM=;
 b=SnF685aWYZwKnN6wRM01mPtB70OJpL1FZ5gtatvqfv1iz+vkr+mpg2oJodkYEdB6FRnoR0QLbPJ7RI+FvzUu1SsG9KBlAmAVUaQz6JVeVhhmTFfSt5jnqTVEQdqdsqpEI5Nn1MOHaCai+i9SZwpQCGfzom5ozFsa9zg+pfXi5Rad2+YkjJRjNgKwJrGwoYJVElTYWwOK5fRSQTFe4g4maq5VmGP2FpMpIvHTRjhbgJn4OTCGs7QyW2HkHm/GWANdWhyFfSo+WHEDTFsxxytr9K+bE5ATFQCjKFo82WzrwaOt6J8GD2VOzWw6S9OyOwlwAE7q/jJl53mUqMTEdZ2bKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6/msDaQBaxIRV+7Y3Aw7xsgX5IcidTFoqnVkJy1oDMM=;
 b=m3ONcnRDpV6sv6lNl2rkYWMoLc/sWVPP3/6tbf/rAS41vQyK6O43+l1gZTGTW7PafN9rBJ6c6wBYfuVm34mpSDDMcLK1/v0ybj80eviD5y7wkhDdLvD/Edsa8398MUucpSCnxhiNb6PRHUrwxYrn3/KCZYDCn8G6J2dy7li/jbQi7zR/VjStqMtDW6CI+I5ph5hFOs36TshPVy0hMV53Kag3o1cMTercRhNUE1Xr4CVpbHfmRj8R9E9Ov02FoDx47EcJB+FIu4qau5qF/NV9QaIR5wtWtXYM2XpX+qnT8U/Go4B9Y6PoZAufFDwpzqza2usYXT6+X5fc/UqVXXwiFg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB4299.namprd12.prod.outlook.com (2603:10b6:5:223::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.12; Wed, 4 May
 2022 17:49:27 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 17:49:27 +0000
Date:   Wed, 4 May 2022 14:49:26 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        "Jason J. Herne" <jjherne@linux.ibm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>, kvm@vger.kernel.org,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH v3 0/7] Make the rest of the VFIO driver interface use
 vfio_device
Message-ID: <20220504174926.GA88353@nvidia.com>
References: <0-v3-e131a9b6b467+14b6-vfio_mdev_no_group_jgg@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v3-e131a9b6b467+14b6-vfio_mdev_no_group_jgg@nvidia.com>
X-ClientProxiedBy: MN2PR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:208:c0::23) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a29c95b-9840-45fc-fa81-08da2df66efc
X-MS-TrafficTypeDiagnostic: DM6PR12MB4299:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB42996C047E8384543FD9B1C8C2C39@DM6PR12MB4299.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dVf1HgA0qhgwFBwV/ET9fNzvtD2ZPSlt9CyuQwmgA7ofEybDtqZIyBQTwNiIIbd6vL3PFi6OxZI7z20KKa904vkyXc71Wke7YtoQFDDYILzDDLqJmukAyPkXmZawy0Lal9khfHBzDZEKSyzg08rKYzQ07F849ZP5tGIm0A++RWD8KxTLjHzUaNX6hLJ8qFm7o9mGYt16HCYkjkTr9Pblw/uZFUo2oP8iEEx3ZUAjMpslbSd1i+xVOPnzkZpdKU+5BK3rvUS1ijGIg+RHod910lDnj4SoAF4Sgp0rBsKtMOJ+UT1l7Kya1kfpNxqS1Qt5FHWuUh8zBge6IcrgD85K+cBT/YlymRC7EliV08SAur7kbpUZAvzAi1L/bH56xxprZtyVns3jt5LG4acLIhF7e5OjdvZkvNEXbNJnzWDObcbEAxIqP5k3idDyhiOJSjrIBqECfo5nSlrF9EYbdi5Ic4i+A0gsAJHfWn9H8X3OYvqi1uyQhfXlQSEDYaoRCLNz+RbfWSa/fW+smvKmAxQLaVBqZkFNqnUL7mWTuT9EA1o6vzbCijkfW8MvQ7ZILPhGazO1GFLeCSoes8+5FEdu1gVx5qq3Uv6ILl+rNVqZsqJKrOf1c29ePbLkkIm7cPOB2pXsaf8419yOFpGQ9T/YGbtn6GqYJ0s/ZhfLEyzKZurIxCnLbEquSM+j6q8DPvtee+jyYBYYobVLV2FhdFYdYkGm+l+m2003dyxHomIHwaoY9RSoQ9x5VaQAVDnNnBb5qs/N16wr1ZxoCDJcZ9UZMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(966005)(6486002)(36756003)(6916009)(26005)(6506007)(7416002)(86362001)(6512007)(33656002)(2616005)(186003)(5660300002)(54906003)(1076003)(8936002)(508600001)(8676002)(66476007)(66946007)(66556008)(4326008)(316002)(83380400001)(38100700002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NDmk2Q1mn8k9g3qM7bTJr1tHHb5dLQhaonHdN64vaiqnuf8nmxPxapdIDVZD?=
 =?us-ascii?Q?3EB8B0CUSsq99OnkBsZc3QnY9TFMzCZ/kPDOWh14kjitE39pZhgi254Q2KxZ?=
 =?us-ascii?Q?q3Q+xk/jqZIht2bXI6PSoZJx1iKjvt4YvfASWLsYxKN9T48O9IBW+6PilciC?=
 =?us-ascii?Q?qeG8YAgUM5Zyhe1V3xEofWPCGBJpc1RXexLQrmZhd5dPMskViOqNyU+7kdu2?=
 =?us-ascii?Q?KOLBNDxV7gedPsApcKLidZhHGeCLvKcVQ3qH8bfvj6aVUWElGBaK0+jyAy98?=
 =?us-ascii?Q?UZVW3fz7FBoXGeOXennNWKjjLHmFejZ/b5X1McgRD8WA2UBd/wcBjcYA/h9p?=
 =?us-ascii?Q?DKwEtiQqGXha8oGBjuYDgAf+eKaFA97ijxwGKe7NDpyJMmsS9pqZgOmVUWW3?=
 =?us-ascii?Q?cu+f4denqQwVyQisM+/tCUMd3FBZj1YQmGWSujAUnewXI83D/Vrdpj8Jg4ql?=
 =?us-ascii?Q?B/Ud50whhGw3dixRWE+2f65pA88tMQngp4GrtvS3iCMJMTG9JNwPqn24Yh/q?=
 =?us-ascii?Q?36bdzd6KILyU6IdKCSfXO1l977flfVJdeFx+sTEbSWU6fP1YE9rpvs6Y+GRr?=
 =?us-ascii?Q?7T4D0nRx3QVcEHzKTOlNVrwkW75QSwNtWze7Zl7Cj7HTQkXQJNqU97iBFCUK?=
 =?us-ascii?Q?35MLd3IjoYHCgYUX3eXR6xxq9H7xoYFNLYZ09kXEtshSm0Ee8ITanl+NQugX?=
 =?us-ascii?Q?hYCDdL5AYkPRGyMBbsY0k2tYUipD8zaglJ0rZswI0CrEjjd+72bR2R5DjkAo?=
 =?us-ascii?Q?gaWzUR8hONPL0PYmmbggqC5K+iMHRwrMapl66/nkT8zWQl5zsVQMvZig0ZdB?=
 =?us-ascii?Q?EV4/CuFKRMKE3mMvQbl+r1iez4pl9N9W1GheR4PF+YDCoBLjuxeXde99HhKf?=
 =?us-ascii?Q?sgD5s6PAPNVMJJjECIpa8fBouvxig9iPDXOtiwPpiv/fv6FJvjZZNLiHaPaB?=
 =?us-ascii?Q?hSj7mSsUO80lyWr6Q17o4J1Vl04CCI3FZ0wbIig1X5mxYfZJ9A0PevVk9Lke?=
 =?us-ascii?Q?hwtrcCIsJ+yMLOghO7mOb03v2TPqIdSpqBq5ppXVt/y8IsfGi0nJOifHZvih?=
 =?us-ascii?Q?L00qAQxgj74cuA8WWFO+Xy3zKZyPsivtwBY2rQen1e6E3HVmEE245zBxIQ7M?=
 =?us-ascii?Q?+3YKggzmAY4OJk9SclTiwWEwYiy6CYq4+LIUqz6BVmbXX790s6rCHY7uvtoq?=
 =?us-ascii?Q?EZyJy1M3JBp3C2umH6/iMbZjPN9wx+p84twgYV7ZPduGEHGRN2GA4BDcIoel?=
 =?us-ascii?Q?cmeKERv7horxAu7KrZIrLI8VX+9mVqvDDipdUOEHENnVMbgJQfk42jBRimZl?=
 =?us-ascii?Q?5mnL6KxmEVhlhE8jGQtP2qR1qqzQgZnOg2BDUSCs7oKuHu6Ohf2dBcwuo2lL?=
 =?us-ascii?Q?N3jYy2Gg8U1d1fWufvAOqPSS5VDT4oAPULQs8342dxm16tGIIrRQWmr1dHZK?=
 =?us-ascii?Q?uwdvoy9ku2Cln75Z6SV7rJxdKwOQRCm4ZgudBvBNt0SQgspom7Lx+c1VHaZc?=
 =?us-ascii?Q?6CnqshGVSihk2cfHOs4BPEAp12JxNVohKlVJdukecT70k6fVLwzr9+T4++Cc?=
 =?us-ascii?Q?8SibaVkVe0JUrJmkh8tQxhhecoWiR6H3LuDQrDj/+UIO/2DzTPqyURHaDx2c?=
 =?us-ascii?Q?x1vxaNoUod2WSNeJpKCBYvvut9Ewl+MPpFJX0D+PkjDwANgqy1IK5ZWgbO7t?=
 =?us-ascii?Q?1yMjjzfCOLv+IMg6EESY5lPG7S+sMNpor7JKJowGoE4FKeiK8mSaU3RePyW2?=
 =?us-ascii?Q?AymGqH70Pw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a29c95b-9840-45fc-fa81-08da2df66efc
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 17:49:27.4873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bQCQpR4vBDpgVpV/1j9ojRH5dDrYk8l/KH0fhhxx3JWbheZqMWvYP6hNsdIaDNHz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4299
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 02, 2022 at 02:31:30PM -0300, Jason Gunthorpe wrote:
> Prior series have transformed other parts of VFIO from working on struct
> device or struct vfio_group into working directly on struct
> vfio_device. Based on that work we now have vfio_device's readily
> available in all the drivers.
> 
> Update the rest of the driver facing API to use vfio_device as an input.
> 
> The following are switched from struct device to struct vfio_device:
>   vfio_register_notifier()
>   vfio_unregister_notifier()
>   vfio_pin_pages()
>   vfio_unpin_pages()
>   vfio_dma_rw()
> 
> The following group APIs are obsoleted and removed by just using struct
> vfio_device with the above:
>   vfio_group_pin_pages()
>   vfio_group_unpin_pages()
>   vfio_group_iommu_domain()
>   vfio_group_get_external_user_from_dev()
> 
> To retain the performance of the new device APIs relative to their group
> versions optimize how vfio_group_add_container_user() is used to avoid
> calling it when the driver must already guarantee the device is open and
> the container_users incrd.
> 
> The remaining exported VFIO group interfaces are only used by kvm, and are
> addressed by a parallel series.
> 
> This series is based on Christoph's gvt rework here:
> 
>  https://lore.kernel.org/all/5a8b9f48-2c32-8177-1c18-e3bd7bfde558@intel.com/
> 
> and so will need the PR merged first.
> 
> I have a followup series that needs this.
> 
> This is also part of the iommufd work - moving the driver facing interface
> to vfio_device provides a much cleaner path to integrate with iommufd.
> 
> v3:
>  - Based on VFIO's gvt/iommu merge
>  - Remove mention of mdev_legacy_get_vfio_device() from commit message
>  - Clarify commit message for vfio_dma_rw() conversion
>  - Talk about the open_count change in the commit message
>  - No code change
> v2: https://lore.kernel.org/r/0-v2-6011bde8e0a1+5f-vfio_mdev_no_group_jgg@nvidia.com
>  - Based on Christoph's series so mdev_legacy_get_vfio_device() is removed
>  - Reflow indenting
>  - Use vfio_assert_device_open() and WARN_ON_ONCE instead of open coding
>    the assertion
> v1: https://lore.kernel.org/r/0-v1-a8faf768d202+125dd-vfio_mdev_no_group_jgg@nvidia.com

Hi Alex,

This v3 is still good to go, it applies clean on top of the gvt series.

Thanks,
Jason
