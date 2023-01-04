Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5BE765DDD2
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 21:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240105AbjADUrm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 15:47:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjADUrl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 15:47:41 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2072.outbound.protection.outlook.com [40.107.94.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB1613EB1
        for <kvm@vger.kernel.org>; Wed,  4 Jan 2023 12:47:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iD/hqnFi4L92Zt+uoqo1MWmMeXczhYGZGYv1jsr46ZJfY2DfCwaktUrsZMN8RpRdHEG6GFLMrwjWzLRy7XyejCcBCxV87md/QUHi0KM6KwZrBL4hCQoOZAnUMO+dUgyMBTbLS24twNR0ZaVi8YgSAM0ZEqc80pYzNldvsXgBSz8RiBdk90xYzISq39ZaHrVot9QUm5wFgNe26vaMWwAqezM9eYnkStJjNicYltIx2Y3kik/C4Mqa/GZhajBj2UgmLMI+EyxmCEKsKlRey9IGExj9uLrByRqXloYkRw+KDuYmN/bNk7rLD8WSDF3L8XYtFjFmebcMiDhYCvKfyWJw/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3D9khfa7cjDxzJxSfulaWmKKoD0taoiYwwnvbLuo2J8=;
 b=cDqPythVozig0ZYrQ0JAXK2rZ1zoFFFkwjJbRhh33qfy9QtHbMmHMH10TLw+2LEGNxdDSVFwu7utqxAMSZyQ+3LVwmANtQqtpL3v976cxQtRYs3rR9PVQPCK9EcqH6X9JENEFeZ+3DuW7/hiRvbhFJ5fqFIqj9Hxz9I/04HfrCUwnVDQozhUwPHsOPH+OFgT1aWBPgGNwQO0iMPO/WrR8AURzbuR+Uv2Sx+mntz3rtE5fckvODTkDQBU3/5Q8BpcA1ow1FlkHNeAxDjlI+SW1qGfOApOeFAYkMnYZgT9UL4S5naZ7WwPi+7GIFDk81YWB0okRW1yxTXM85ng951Hag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3D9khfa7cjDxzJxSfulaWmKKoD0taoiYwwnvbLuo2J8=;
 b=IxClvEsL4aAtKv0MLjXdxKARwgzNJ4IiV/BB77wNUWu9bg8uPsD8Zk1Wa0oxZhj3M8n9EXlyFpuH9FAgiqXDRpJATXMevEnZTN1YaKcppAJB4tzu7XwOJzCqzTfxdQ2+9gbElkteS2t/M7IoAVPN5yLPuPkulJX93Mx3VYGh8P8B1Vy/jxNlNY7yLJfc3vA3W4sCxQxxfV+X135VjCdKTOnUteZq1yVWPfVG+JM1mDwOroSU6/Q9cniBQqVlR+vjnZJ67i7TVVNb8YWOMre7NzoVWG3TAUChA0Ix2SZLMYYfCje97K0000cdr7LKaC0LXvzZUB/xrywtO686Jv/gtg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BN9PR12MB5308.namprd12.prod.outlook.com (2603:10b6:408:105::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Wed, 4 Jan
 2023 20:47:37 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5944.019; Wed, 4 Jan 2023
 20:47:37 +0000
Date:   Wed, 4 Jan 2023 16:47:36 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com,
        cohuck@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
        kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com
Subject: Re: [RFC 07/12] vfio: Block device access via device fd until device
 is opened
Message-ID: <Y7Xl6AxA9w7IgsZ5@nvidia.com>
References: <20221219084718.9342-1-yi.l.liu@intel.com>
 <20221219084718.9342-8-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221219084718.9342-8-yi.l.liu@intel.com>
X-ClientProxiedBy: MN2PR16CA0016.namprd16.prod.outlook.com
 (2603:10b6:208:134::29) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BN9PR12MB5308:EE_
X-MS-Office365-Filtering-Correlation-Id: 191f4d97-c6af-4b67-e51c-08daee94ea0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bhJz3AIIvGgYshNs8aYz8kDB6tUtpIJ4oH/dGB9oMErZzYNoFtSq+U4AgB9zuUIcJFfmC724U1fzxXV81iD9WKNpzrdJA+0ZT63Oac0IvV6p0jIAtNAzCxpNuH0dsO59QAS8MYe4IvBB9I39SAgT+LpQpNMTCn38iUdj1jbdb88niEZNwmxr7dyJFASGjNUBBZZmY6cBfA2Jj3VDRj+WM688i47XHJkVefs888iOzzNa0I2UO7NEJqaFRUN126JUMRbtsF2r+5Jw67ambezfnvrXJu6xTCJix7PHAYaeDSaIJ2vDFtnRazoejrUdrNyINCuV9bcRs+FteJcgjqk+Q7RsNzfQdvrQmGnPBPEr6HpMdVwOLcrFlFlrx3arwN7I9uEHpPkVc0qa95rNXXfUKG7nQzek875yuW6gE6wfG3mCgPc0clWjmkfTBnbl4VobqoVZKoNyuAGjG8crlr45p/3AAE8EsI7eBE+au4BN1CbST5xnoVJBEgmVj6w8FPWgEhpkF6glV/g4pNti0fLiCH/UDWJCZ5OVEesQMtMCTs/YIAJiCMSqi1QmM0SvGAfJEaf/Y2gMn5o7zLn/cmGwTeKgl/GQoP65FwMHNrCDpTWgs6zvzP6wC6o7dDtXEj0nQHHJYf8VlNgVOMvYqY9fog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(346002)(39860400002)(366004)(376002)(451199015)(7416002)(26005)(186003)(6512007)(83380400001)(8936002)(6486002)(478600001)(6506007)(6916009)(316002)(66476007)(2616005)(66946007)(66556008)(8676002)(4326008)(41300700001)(36756003)(4744005)(5660300002)(2906002)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TgZZzdT1U8xaHOJ+HPwmm58cWqQpBARWq8nvrZ0OEquF3waiFFb4yWm3blpi?=
 =?us-ascii?Q?9HFkGPLLSI92VeY2FLH9LuITzlgjDpNnmXuziBmQvYpATmcMDPsLpP3yK23M?=
 =?us-ascii?Q?C/O1dcyh7mKVtonmW7pT6naddAllV83yH+9OHVKQlbcG2vnVTlNw5i30ORk4?=
 =?us-ascii?Q?o3eViR6oytK9hil4ApPWlpcXMvA0n5txvuGXTaMECDtO1hT5SYqnw3j8kuKc?=
 =?us-ascii?Q?8PDowqjBxUO1Q8a5g2tjuNIAWjyJE07MyP60YEgs0tVps3qVgtQPPHOWHLdL?=
 =?us-ascii?Q?Fm0D/qhGv9gl4FV18PkI076bUuS40jr6/s1e8DPFpwlCdJPEN8OPijDl21iU?=
 =?us-ascii?Q?/wpuKR1s5GqJhl3T+JMnZa3yHmAnqO1LH/sgTdcznpatC+PtoknPYi+Ynpy/?=
 =?us-ascii?Q?AvKUOtUJ5mOtjK9SJvzgruF1iFkf0Xo7NG0RsjPmm/hkvfBEGdwJRkm8bflW?=
 =?us-ascii?Q?Um4tlciPT/jyL8WWEM+rSdfaQaSTq3Wl7O6iYWYgnSVfXVqzGykcGnPxg4Oc?=
 =?us-ascii?Q?V0xZkWbQQnSYXg1fgZ67gIHbj0xuMBgyxm9ZqvjgIycpaTmObuatQcCbf/5n?=
 =?us-ascii?Q?S5B4oYvZgkjMmKqCu/u6Fz3hjezplrvN5fdn8z03b8mdJbeA6PNxlmsOWDNf?=
 =?us-ascii?Q?iYyEqf0FcQXCWnq2FwIKxsBaYUdx9bJDw9gcVVRkxh15vkawJDpyta6bfFEe?=
 =?us-ascii?Q?mgH0cjMs2vYZLgrnj1Lsz9iD8qFJLasf8qON873/fY891ZtP4laOEV0h4t2g?=
 =?us-ascii?Q?PBldjSZuoQmGscQVLHjJzT4lKLZEok+6++do3b4mWuBWLtIhrWxyUt2TRg5g?=
 =?us-ascii?Q?ro/ZNjhXGOCnomv8qg+CDBrrwquoAPJ54X4eFeZido+Do0lL05RwquuOXYYk?=
 =?us-ascii?Q?nfR9wl66DysRxPDsZ78/he6LsxfycS8XEtCnQa04apuUTaLNFHKOIKURccoJ?=
 =?us-ascii?Q?15ZVusf9fKRIC4ANnMQEuhWtK826OIEuPCEsupth14Pm5IyXRWne2BExdjBu?=
 =?us-ascii?Q?us2uTed95qEFYYkfBAr+Uf+Zystvg43mBVmx7Z5HGgvWHRNnSZCmby48SAfy?=
 =?us-ascii?Q?d4WYzfgUM4f4QcIjaKbD/zOJKq9viwN+otVjacDA0+qNL2Xp4mAANWMxWW7k?=
 =?us-ascii?Q?sqxZsP3jAiKbP9NI1ifKINnRjwXiTgXJrDaaxK4FVMX6C7dqhM00zvz9CjGP?=
 =?us-ascii?Q?gzK7Afl1c6kDgTIsxbAGO4s1yKB11tUtEDy+3ofOdoQgxQHS29Y7Irm0IhAW?=
 =?us-ascii?Q?dS+oJyl5pZYUkIuLinvNBs29xjul7I13KYpBHThXITj+9lRJN7yndtmbHAtH?=
 =?us-ascii?Q?N1EOaDpVmbtQE73Pqn2Ykhro1cqMCMIFvknrIcJmgCeGq0lEZIH7ICFySFwa?=
 =?us-ascii?Q?Ah6T7XuYXpXcXs3o7GbFQBBTZKVYbobXmpGpdbcvJDpwhN+oaC2wfrHtla5E?=
 =?us-ascii?Q?tUkmJ/rd+VbD9jc4fmKWKMSyJDYV4cJMbIYAzN7ZZIF9q3eVAqai/6HPDe8i?=
 =?us-ascii?Q?FFGwAEQE76SG4+xncG3iEQECWQ9ekeyN91lP28ZO1S3E5QAItt6JFAAmeBo+?=
 =?us-ascii?Q?/t+6aO6s7uNvdSfGZUC5BIo7aq5OGDmMXfxzwSAa?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 191f4d97-c6af-4b67-e51c-08daee94ea0b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2023 20:47:37.7127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qbp8kB/eHeTmNcLsuRBEoGCMdBVbCvkGIwHTtNXJibfocnmi39srH2j41MI7MsC8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5308
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 19, 2022 at 12:47:13AM -0800, Yi Liu wrote:

> @@ -452,6 +457,11 @@ void vfio_device_close(struct vfio_device_file *df)
>  	struct vfio_device *device = df->device;
>  
>  	mutex_lock(&device->dev_set->lock);
> +	/*
> +	 * Paired with smp_load_acquire() in vfio_device_fops::ioctl/
> +	 * read/write/mmap
> +	 */
> +	smp_store_release(&df->access_granted, false);

Storing false makes no sense, it can't do anything, this function
should only be called if we are in a release function so we know that
there can't be concurrent access to access_granted.

Jason
