Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C829B753DCD
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 16:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236113AbjGNOmR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 10:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235954AbjGNOmP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 10:42:15 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2045.outbound.protection.outlook.com [40.107.93.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D1810EA;
        Fri, 14 Jul 2023 07:42:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZEiNdgKuPXDh+76tsgsYr+4oooKQ8Iuj+lZWgEPujiQYkJ8O19Afnke6qnDIvLjoKc9TRPqoAwSwfWNhLzTml7tdhb3RalF6e4rDrgPylHkLBm1HobZNSr/zr1zo0MmVZ5cftRBtqAyZrc6N29F75yaWCysSNN0DJA1IL8EYiqPIm5DOqiV5/SiEV0HT1w3a9RK/XNPZjk8fRXqOJy0ycStkWdJIfxpl7WMUolxiwxWXNowRRNGM6dGpa8UQLONvxJteFKzSlXflD4kKJ7ilX2N2Bjz2jiWaUnR8ObstEZ6ra6NYvNJUMJvZtIznbwPSt8wns4FxHL1ZVWbqnuETwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e6vp84SY4HBh04Wt7SD2mbCn7cPC0LugiA1hEcK+/Xc=;
 b=cvEtP4eqwryZn7XtLv0+TL38hirqpxMFHJOL+cbuC7xnPcg799fOLa8S1n93I3dR1clZPE/cQGr+9xK2nef7NmQPg7jr/CtDfZbIDIR/uv0T53/QaYJFrOcFinKzguwcbQcuIb/MRTqqygHehzjl0CrygZHD2nKKCwhlxpLmC0WxUdHB8cXHxme+uMwYQSFTa9qIx+cFaX/NzKaWOUAPdWLBEKm0/Lr9v+6XUHVlHv/hiPaDcaySPzDIu6qJQ5GyQoGJcXtm97af6oF6Zu5KE83XD16ImLc2XBrkBTcRag3kOd7C5o4DsqhQS7R4aXdrN5+KqMg9gQgXU2Cjs97DHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e6vp84SY4HBh04Wt7SD2mbCn7cPC0LugiA1hEcK+/Xc=;
 b=cLwnL8elxvBt4eFUyzxwshOE+kXU3KNRVKCUzAUqgvSlYNgs46EXVwM/9PNHGNJ/AByTZidAT37B4n6GrK3nhzm81FONdRqhrCJvgU0pHwGZju21CS1QHllJ/aZfj1ABclDM/WhR5DHTltbZ7vATDumZ53evNmvB5+D9wdTeClC5ZRSRXoLNWu63rLiM6AkrWa3zQNEaP46Gu5aaDWWRRNkZzYjCNr5ONvWpWwSpn0EkKJBtYaQ3APp1eguxTW2HWWE0SMezp3srEKTZVkSPhZHMgr3+omJ+JXGD8uNxluEYZ+U7qSgfx+Y6gekg0qEN1zmaDs6z4Iroocsn1dVUlQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB6878.namprd12.prod.outlook.com (2603:10b6:a03:483::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.27; Fri, 14 Jul
 2023 14:42:11 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::69c1:5d87:c73c:cc55]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::69c1:5d87:c73c:cc55%4]) with mapi id 15.20.6565.028; Fri, 14 Jul 2023
 14:42:11 +0000
Date:   Fri, 14 Jul 2023 11:42:08 -0300
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
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com, zhenzhong.duan@intel.com,
        clegoate@redhat.com
Subject: Re: [PATCH v14 22/26] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <ZLFewHxO8DSelEml@nvidia.com>
References: <20230711025928.6438-1-yi.l.liu@intel.com>
 <20230711025928.6438-23-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230711025928.6438-23-yi.l.liu@intel.com>
X-ClientProxiedBy: SJ0PR03CA0180.namprd03.prod.outlook.com
 (2603:10b6:a03:338::35) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB6878:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a48047a-fc40-4578-bdab-08db847881d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iYiZPBjMwPdG4aCEsAV8a8kCFut5jwa2c10OXvb3HjCVbOXQpN2iR21GcAnSlYIXnDftK5IVcKAq0eHMrvaWMG7K2q//T//Ql53zD9WZzaV20yicyNdK8H27zhktOdwP/oCircXemWCZPXY/D+M4sFGJXte7ZAVQvxKKxUJilwNfqWUeCSo/MYA6IG7uEniJVGkfWgKFxsVoKQfdvR1q9VO6z0mVqZL+BxVu5fPh1oUXTXkG5b+31G2x9XuMtf5ZLEtQe2/3YdFzTfwLhdbeV5ApVfqt1xWAy7yt0Pf2kn6XPX4CfKDEXbllsRwmp45VzH4sbCbF3gw7fAbmGU8hHRsotgxBWHrt+pCr3yhmpi163jcbmeQBqYSQCwrH8KwCMPdJXgBl/HCyXKSGlHZafreq5lGGTUtW70g9DvU7zQABQVwgI0Q5Y62ZP7DQdIfv2TWlExlvH0hPujZ2Iuor1y2h5BC5DZh5KqgtC6vOfgMoON11Dc946OMmg3kQs9/FtdPN+NArRcVcyDPEZn1DKLMnY/nS3khxEsqinOdungzXtNH4gvdGiQNZwO+Jj/6X
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(366004)(39860400002)(376002)(451199021)(478600001)(4744005)(2906002)(38100700002)(7416002)(5660300002)(8676002)(2616005)(8936002)(186003)(6666004)(6486002)(86362001)(36756003)(6512007)(41300700001)(6506007)(26005)(316002)(66946007)(4326008)(6916009)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qZRPmeSYF4W1D3cRSqJd0RwZ8FKzaE3ZTPjtBk+u3OUcAkrRBOzkkiFf0qMJ?=
 =?us-ascii?Q?KQEUlXLtP3xKs4Z+UsOsej/uWvXsndIq2s8bgozGq1R/3v7ZHQDWVKl6NpjY?=
 =?us-ascii?Q?s6wpgqOLTEo7CEvasUs43qdJUOzpjC8oHTS2RQU1+k6R8BWnNR7B1fGPaMUq?=
 =?us-ascii?Q?pkmd3wEKHwid6yPr8BRfbUnWopOGhX8iL1Zk/zDfvB81BeNk+WcxnSD15YXj?=
 =?us-ascii?Q?dw5tdrWOOdSS4p47qQPaAwmzcZdFtsjO05dTxZjnT5dbYRe0TZIAIjhljEAj?=
 =?us-ascii?Q?YWgJ/E+UHx9jWfeHNvHSB2zRy+YB8Fmv2mPWKnvkR31QdT9ETCu5ioUJUj0T?=
 =?us-ascii?Q?0N1OR3/qJ4jWr2fqKASPqMhUGMJZxuk2BGDKq1SX66wG2f2DL7via9f/jSXy?=
 =?us-ascii?Q?oTm16uHq3Id/jZiu1rkEkWKbsutFlH4QbMkouFqqHzW2KZPTCkqpKzYDPKaA?=
 =?us-ascii?Q?Dekrf7lYefcT9Uom3GjN/me9QRSwZWuCCZOlwMFT6IAMIkXJQY6eKYosrCW5?=
 =?us-ascii?Q?lMF0YH4VX79oetiShZy1JDo8so/RncaB3sjLmE1hJDEGTuWyYE7p2iJ1e/0L?=
 =?us-ascii?Q?4rMp3SqelkxVe8CVVUjikLjGX9lkTABKITC/icWFvEHZfnwXbfK5czlF1Omy?=
 =?us-ascii?Q?ZH5Gz/6DpBpINZPmrTjbcxnZlDOPz6b4inAXIuvqnXTGSfvk/HYh+r7/M19q?=
 =?us-ascii?Q?Ucjpj6T2OU8wVKuj+S3d5cObNYz9UMk1DY7Nrzr2XrnVR0fcWGzmu9vIUlmh?=
 =?us-ascii?Q?tW7lnrPf1LbLIS385c79XxOZh5vhV7YEEYkdDzdBRnk8GWnFJ3HjQccwanRw?=
 =?us-ascii?Q?bbtM7OzYPTPTPYkukwa32WLykf/e8LYvbgSCdkGluxMbGLJDnz20/tvXoMkO?=
 =?us-ascii?Q?D2gdk6C2YQgYMy84By8xcatto8w32hiOVyhdbLSNSvI5yZ164Wv78gZxIm0Q?=
 =?us-ascii?Q?m84WzEJVPt0lWITSv7+BWtQdpuWo0uLDIg0MfE5U+pl2cjvGdJqmf7rIS0oD?=
 =?us-ascii?Q?ARm33fKNjbnwtkVfhkPrecTItoeeTdqaFo79GHJbiSDvrvCRURpQQsS87MHe?=
 =?us-ascii?Q?9dW8I8SaMZLMLhPo6nYRDjtCw/wH9GQCVX72TpRT4yJFHQw4kPMqS0TvylP7?=
 =?us-ascii?Q?USAPwax923qmF1uznrEF4RCgf+4F3bNxbGHCxZzMpy1+SjfF6WBkh5s1uLxW?=
 =?us-ascii?Q?/V0JvIQ1YZOFvrF8kS/8BQoINI9XNDbRE75T2gWZuyhemNTn0MTuLS5ERT9o?=
 =?us-ascii?Q?50U67iuNgbRCvmWE1lhosHRWfdjOOepIgElQGTdxCoUhR4jpQnm0PDwUCtX4?=
 =?us-ascii?Q?gn2ZEzVVPe0V6Zv1+j9uYDYfjJ5P7AtXSuIBtHoiW5d2qHeo9TeDB2rHGBoG?=
 =?us-ascii?Q?MKjWfeD36NvbYCepq2ebETjhWCV430eqk4liYIkZOm8ImpY6vlAMYRBSh7DS?=
 =?us-ascii?Q?JVwCnS03wCvN0gBDRuDQcr66XNJmNGIPeoUsxQ3k57Lo3bWSRRJW7L2x4Tbz?=
 =?us-ascii?Q?FPnZSCPoikiVCGkqnLstV5Pd5mApvXRNpqOruTfIA/jfsAM4QjVOMb07XJuB?=
 =?us-ascii?Q?fyFRWquzwKPxJQUPuhR0NSqG97Wcln6vaz7NpB42?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a48047a-fc40-4578-bdab-08db847881d8
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 14:42:11.4505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 36zWys78fb0XIN1asQ4szte8HpUkc4jqFff9nxNoXT7UPrsDDKC8cdvHszhH1cAN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6878
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 10, 2023 at 07:59:24PM -0700, Yi Liu wrote:

> +static inline long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
> +					      struct vfio_device_bind_iommufd __user *arg)
> +{
> +	return -EOPNOTSUPP;
> +}

This should be -ENOTTY

> @@ -1149,6 +1151,9 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
>  	void __user *uptr = (void __user *)arg;
>  	int ret;
>  
> +	if (cmd == VFIO_DEVICE_BIND_IOMMUFD)
> +		return vfio_df_ioctl_bind_iommufd(df, uptr);
> +

And this function has a mistake too:

	default:
		if (unlikely(!device->ops->ioctl))
			ret = -EINVAL;

Should also be -ENOTTY

All the implementations of the ops already return -ENOTTY

However, I think this is all slightly not quite right, the proper
return code is supposed to be ENOIOCTLCMD which vfs_ioctl() then
translates into ENOTTY for some reason..

It looks Ok otherwise

Jason
