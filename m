Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05AFE6A4AB7
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 20:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbjB0TUe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 14:20:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbjB0TUc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 14:20:32 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2065.outbound.protection.outlook.com [40.107.93.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22D123327;
        Mon, 27 Feb 2023 11:20:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fDpeVdup8BRUcOm5cibKrOCSwJqsqvyeNHrjUIibujWl5NpgFqnMcw2v2Ne+znHLj1YdLKGpmTc8F/jDwJYn9ZMlYqoir833U9F1o6oBZMsGr4mCAITOfjUi1GAxD3bgndZCaet3kAaDfDPzvB+Tkb4+4QLHzQktdWrd/V5HjaygAQ50wtGzmhgBE5YTUMZgY4MWBTHN2WqloF28gkRteRCc+m0zZ3WIWUXi5aJqamoJnjuK4ESHrJz/ZJjL2vdX4gdEKDXNQ6y9DyrKUTE2U2bTPPJESLFcp8vZDfCyAaiaMKmQaIK2DyfTNhbY72tE7l6eMGliLjP22s/C5Dh+rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B9LOyk7hquz2Z9IYsNKyJLTY4JpWIUh36RfGxc4S5EY=;
 b=WaFDIlBMwc4ub/UmMSaImwKESm/47e8FQ0KqZfKvqyCwAUaeTZshEC6D2mN635HA8v7Iik+z9YxfJbjMCK/RIJHJWF0J57XBS9fhrd2/sKdE2hh9jJTXBStmV3Yz00RhNGKodG+V4xa3lkgXBU8chT4Rou0S5I8wcduf2BZDsbHcOvksDkHtJ7h6Pyvp3RftVPSmRdedBDnD0mJnuDDWYELjfXoDyQtEwLG3blPTELmreENA9EpExtc4jo4lRmiByDtwJVeWj+VFMSGLTQEReQSjsQQvuigkOrulASB3u/jrnejViggVN6T9Vwdz1aJGT3jgG08DRP0hYPdnmfdGhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B9LOyk7hquz2Z9IYsNKyJLTY4JpWIUh36RfGxc4S5EY=;
 b=lmUOthr+pKMRj4cwNbRNF618a3UuJEYpeDcJjxiq6JjXcNngqvdTyNUIme59wtwPLYf+Rnyc9Y+ITDags5TJeKUzfGORP9C6Mnauj3uJwMt/f7UT+KwAYHoZU3omsSSeYICOVntl6k2trKJramc4FpQOolurIQPVHhvRwW/7r17+OMZkkZA2MF1ac+TNXUl4p5T523NPXJCJFdPfZnXJQqoXevQOXrdKA6zvay6UmDmiRBqGFl6c035J/1hhFUjqY6f24nhKc0VfexqxNbEWuGycxUvtG17SLg2oJ7pyGV2JgKL3JHwHBTKM9EMQedJ5RFab/ufQxCQk0Rthkta63g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH2PR12MB4892.namprd12.prod.outlook.com (2603:10b6:610:65::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29; Mon, 27 Feb
 2023 19:20:30 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6134.029; Mon, 27 Feb 2023
 19:20:29 +0000
Date:   Mon, 27 Feb 2023 15:20:27 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com
Subject: Re: [PATCH v5 18/19] vfio: Compile group optionally
Message-ID: <Y/0Ce/D7KOmM+K3L@nvidia.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-19-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230227111135.61728-19-yi.l.liu@intel.com>
X-ClientProxiedBy: MN2PR11CA0030.namprd11.prod.outlook.com
 (2603:10b6:208:23b::35) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH2PR12MB4892:EE_
X-MS-Office365-Filtering-Correlation-Id: 906d7328-bb67-48aa-7a3e-08db18f7b016
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mck0DVAh5KREl/yVO8SCkD+tK8gWHaXuCTE12H6x8OjfBTWPt+lJVvZl9nWZkrjzO8/Yl2MYBHkVJZlY7RP2mDkIWmamJRj1IOSmh1FsNS2lBHHVyPE8aG2LquxIbCh9jxAH3T3p37VoI9GVQSfxX9xj9gMEfjvoHR2Aa0y7TklFOxZ5HAO1dCQYHLl/xlhvtc5COwVfiqU5DPbpKquzb/20L217kTfBEFX2zIZ9CqA/n2GiSCaktPzVQtGK42edqHbqlkrvYu6e2Ec3EtRXsk5uQTmoOr7WS6choxeBvLH2ap8WIA19I+bMzMk0MRSWwN+ubsQPKO7s15o3IeqXwTY5LzNEZhRwTCh47kpEY7i8u1abcggo2+PPIUqfmfbGafJLFcIr+mtV444oLXC6eaejU/Ee2X7UhezmYD0sWgc8BxKvS+lQb6N3c/0aaZKfHI/Ffc32o8Zbdac2pa0ipnXDMThEVBs45xI835V4VSeLg2Q/Ea2BqFNd4JhFwRfHdMHRu8lN0JBxoilnDv73g7fuDjqKJ2cHwi9J+IFcoPXhmII+0mZL9i6BeR67RhbkB5+72ZDgpPE44TeoQG6+OP0ppD1BO5TVArh/TEeJNmVKPFyTFolOnxNNNgzEKlShttn6ydGpW06QIrEKVao0wQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(366004)(396003)(39860400002)(376002)(451199018)(6512007)(26005)(186003)(6506007)(83380400001)(86362001)(36756003)(38100700002)(2616005)(66556008)(66476007)(66946007)(4326008)(6916009)(8676002)(2906002)(8936002)(4744005)(5660300002)(7416002)(316002)(6486002)(41300700001)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?efAfNVb6sxUpuZfIRO/sdvfrnAC5S2YYztacfOLcS3ignqkqaPJ/d85RExUT?=
 =?us-ascii?Q?+iy+4xSOif6BUdvc8BSIbft5c5TBJwuGnPvSVSjbIHiIr2TFV2PpBZyv0Uou?=
 =?us-ascii?Q?DlQnVaJy7FPgMCR2YxWhessNqnsUEkXwnFy/QGZBFjX3AkMp9vhjy8nmwywS?=
 =?us-ascii?Q?A8NLlOiJhXHVDQo0X/8DvX2Z/exxblYzRDCnStf8XflOesOF7jjjP/oaf1ib?=
 =?us-ascii?Q?ARy/2ksaLA43SyaJ4wFGIh8oJw9yor5Qhmymn8qX2iY5UsSR7RNxqfl2mFNn?=
 =?us-ascii?Q?Y0QPYee2beOPGrD3TLiATz/srEayM9aztxAv6O78ssQz3qLLIjhvrSIivYKQ?=
 =?us-ascii?Q?6TOZj/W921rR1HGYJqjaqwigAHlc6FY0ysVNB1wfk6dIM4rWUC3WTZu3Dr3t?=
 =?us-ascii?Q?pSwRWhx7x27B3FsrP7OR6L4e4rq2TARIw/4pbsnZqf/Fo/nFdPzTuVzBstbE?=
 =?us-ascii?Q?KvGEJuyeIe6ikRjVNS63H6IVZFVmjcwI6FqLGKypZSLbKGvhCg/Kl41eC7xU?=
 =?us-ascii?Q?E6KU9dR15V6DiyVIPe6ccf+ZUxdhIKVtl0V9p9RlGXX1U1Bn/hpVG5qOJAOM?=
 =?us-ascii?Q?xiT4GFkLRT1jaqUDJf+mfic7Bt5ShX8TcgZgZAWSNeRXgJPB6EuIkXVHJxtp?=
 =?us-ascii?Q?fwqCRiQJZua8Dmfir0WaSiCwae8z4bqJcSoTsHtBWDXeIMr5CLIDV6U5knTk?=
 =?us-ascii?Q?RSi96d4SNEpN0Oq6Kaq6jTGhY5TZ4UWnvdUtK3y7oXXHRF++VXGz9692lPnm?=
 =?us-ascii?Q?+Uaqc3+ytPIP09Q9R0JzN0F5WszUD9ZovaoPE8uVptGcWyt2/uNZiqFkBd6q?=
 =?us-ascii?Q?5mxj5iKVB4rVpnKAD3XUjTctqCRSlfCrCuaTvX6QVIjdk9JgxInXKQOho1WO?=
 =?us-ascii?Q?2e2UoPCw/CYv/ytqruvC8aOJsWQRUKchYL+Zr0ZPbtCCFbbDkgCrEa0VOc0h?=
 =?us-ascii?Q?6V2x7Ga5Once8FW9lRsoyRSz5+jp7tnOXoOfnwXzDY8vYxiy5pQAtGAllmFU?=
 =?us-ascii?Q?L8bNB1oQWNRNwE1MJa1EWDhFDqYHiMkB1gto747jLAFGlrIX9RpxI/LOiBPc?=
 =?us-ascii?Q?2wL9I+2JmkZkFn1TMGXl9S8SCgONBQS4VYp6murmcfiICswyxGHo5egzW/xn?=
 =?us-ascii?Q?DTwbS0Ae/isvynrJ9390QcV5PAqGXK668KSTBGlqIUtG7ndZ49tZX5xqhJqX?=
 =?us-ascii?Q?NhoZ7AZxFvFfrhxmcfZ+uRpWClK9l7E/d5AX0ZSvB2QI83XxBEwYR/klVZgP?=
 =?us-ascii?Q?C+UGd1bQs27Gvuurs3PGfdyQ/q+AydKuxeR4HQBwqYPEzdotF4DZBw2aGp7i?=
 =?us-ascii?Q?7eTiUDDWV20KTHF2BG2TwbCkBw1//INT4/Q9Vs9qIPmzKwvzHawgXIQJzpIF?=
 =?us-ascii?Q?tl1MNa+TKpFs5S+mDZ0hcAmj53JUSENm9JrwzvU/enGtTg/wro7ZkXMTd/cW?=
 =?us-ascii?Q?XdT7IGAHHAA7UVoPVa76T8Ll+IzOW13zKpCvLMNXJ5hKPPu0VCvbbliD00En?=
 =?us-ascii?Q?ZXNCL2TnrML5cqVUCKehitl7ytEoXypgCylc43o79ms42Hjdu39iSCI/6jSR?=
 =?us-ascii?Q?+jn3g95HCpsGlWi6vul6N4a7Hu48D3OFqmfuZozH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 906d7328-bb67-48aa-7a3e-08db18f7b016
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 19:20:29.5027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yP9DqwNvaHQxQLPAiunATGADRrUAYQK7zHqyCk2p05+A6a+ErM08jFSOb76xn9EN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4892
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 27, 2023 at 03:11:34AM -0800, Yi Liu wrote:

> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index ce390533cb30..d12384824656 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -43,7 +43,9 @@ struct vfio_device {
>  	 */
>  	const struct vfio_migration_ops *mig_ops;
>  	const struct vfio_log_ops *log_ops;
> +#if IS_ENABLED(CONFIG_VFIO_GROUP)
>  	struct vfio_group *group;
> +#endif
>  	struct vfio_device_set *dev_set;
>  	struct list_head dev_set_list;
>  	unsigned int migration_flags;
> @@ -58,8 +60,10 @@ struct vfio_device {
>  	refcount_t refcount;	/* user count on registered device*/
>  	unsigned int open_count;
>  	struct completion comp;
> +#if IS_ENABLED(CONFIG_VFIO_GROUP)
>  	struct list_head group_next;
>  	struct list_head iommu_entry;
> +#endif
>  	struct iommufd_access *iommufd_access;
>  	void (*put_kvm)(struct kvm *kvm);

I'd combine these for readability

Jason
