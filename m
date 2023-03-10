Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9156B4F86
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 18:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjCJRxR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 12:53:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjCJRxN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 12:53:13 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on20619.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8c::619])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B6713D4F;
        Fri, 10 Mar 2023 09:52:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h0S9M8IC4eu6F8e4JxcPZNfT0n8Ft7rw3OIP1RLiUOchzxma2jm7/SXcF1k3/qWJ670W4QBgwxxGFc9bdGzUEd5R33wjGH+r2NTCbDCGsiIor002RfM0xcwhpMcwP1m84hhbdDHC9anX+91mj/4SDsTgLxHnMQZUh6afQHHy5cjWoM2HySSFOxUOm83JjFzNiVBykAlAlKiKQVN7cOM1OOXtQEJv1iu/H5Tde66kSrXFNYaM461tr7M5jY4qWgewRzMzZElusjI/mdzZiu/gzRVDNfxHHTFHbv1V+BeqdnGCwcPAbcs43G3bNvsjOsX8GXwRew6W+eK0ljiIn6GnFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TbPVyr2xZtSM3X+C2luVQF3MdwMoNMCeUr1xg7x1esg=;
 b=Ydbjb9udqorFNjnsM35cksV7amo/q5lnSI29z00X9zLDLZ/h4DjCczqQRIQ/o9gNFMFWdfkQI1ddMkKV8HeTe0S6MOgjpiIo6YrDTp3PfV9gjerXFt96JbhLIWrB5hA922pXajH7xoyy+u/jwaUp+XXzP9mtmrgFTsyk4u7ut+/bpHe7Zpo7rAZA1XHl9meXBnxnKUZEbOxjh8GJqA7OLKZYI3CGrnLf5EyCn+/tFKYN3+rhkrPOvY2Q/bt37QoEhjZLodLZcjVZT8E31fAKKusx9NP5mZ6XWtZUPGkjGcsdtn1/+OlySe4YtZ9agZlp8pxTGga1L38EKePMD9tJUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TbPVyr2xZtSM3X+C2luVQF3MdwMoNMCeUr1xg7x1esg=;
 b=eto90OI6bpa/HXqegA+DVSG8EpfAYUIxY3cgJ5GFbN6PjGbHvruWqztNA94J8BciccV5Mywnnz6SCoWoiSDB/a27uJUFtKH3y6zm+YFQf5a/1TBPtGd4/r6x2pOSFvFZD8/7RCRdmt7mldJijrYQ0YGKPm47mCoKrvEQpsScNIlJkpS7UQc9/WAZGrWq1KF5dFBYJv7GJRuYtVZmmyfvMcbxHKnM/mFqzBtElsMEAhlG5rulDkn1ExF6e5TNxRjkvSbWFp9+ZBvaQb+dAg7cbNJL3l+J86RFb0GpVJslOn6iGF9KBo6iCoslWlXFswySDwMGfJBHGk/lTUsVsZdoqA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB7475.namprd12.prod.outlook.com (2603:10b6:a03:48d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 17:39:59 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.017; Fri, 10 Mar 2023
 17:39:59 +0000
Date:   Fri, 10 Mar 2023 13:39:57 -0400
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
Subject: Re: [PATCH v1 5/5] vfio: Check the presence for iommufd callbacks in
 __vfio_register_dev()
Message-ID: <ZAtrbaWqtngJkuKQ@nvidia.com>
References: <20230308131340.459224-1-yi.l.liu@intel.com>
 <20230308131340.459224-6-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308131340.459224-6-yi.l.liu@intel.com>
X-ClientProxiedBy: BY5PR16CA0001.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::14) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB7475:EE_
X-MS-Office365-Filtering-Correlation-Id: bf09a479-d382-44b2-5d78-08db218e78a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oy667LrIFoFFPpzVufAs3DUJJXa/7DmBY0IllJFdRYK+IdRtKhRrpaXixcI5htP/5VhrcwJCdeHD0GrMZQbmGkFpqbq2R34JUZdnWar3boo83OQeDMk39H/7Ah9gIvEgmDC5k6xk9tuZ3zbKBj8Ihu9HLKapix+0bw8AzGRIjnjoJI6FfNKyP7hPXsFHb9aDqfnlIZp/jDMuA/x121yaeq7xkJBmJ6cI97sXkfLTl7KaCUSyTgzYtPqq3LVJBwHYDYqn1aw3qtHpjhBEsqDIZ3fY154DVBsulFiP2cCbQWFlsX7gnljlljU7DIJCWFbfNyYirUw7GjxIjyOa5hTUQExedZVsAsZR4WgofkyFjmYA/ojk8lsR0e44I4CXTggd6SsNvB3P6DIcKrikR+xyd3bP15QMZfTym7jv5H845ZT5cfV9Y/Qp/cq2JdIkfrPuKqOgfFwOfSN789ZCJM6SPn2IjTX10Qv6LUb2Ja6SfEuPriXN9ABQcItk/wwNXXnJmILQU1Qt5nubp2xK1YmTq80XBu0r4Y/eGeHxmEHt036t5AlyBp9JjLvsWNHTGWtiIqEY10otRGFmt4tRxAw0Zbz32NeEJ1MEvPvaq99t76B/qBeUITOGYlJQz6Cn/hYHkNqbVw1ehLniVLN4RkP2Nw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(451199018)(36756003)(86362001)(38100700002)(83380400001)(8936002)(478600001)(6486002)(5660300002)(2906002)(7416002)(4744005)(6916009)(4326008)(8676002)(66556008)(66476007)(316002)(66946007)(41300700001)(186003)(2616005)(6512007)(6506007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?biyWdOeczFYigPtSOj/w0JHWTyQKHs/+zymGGxhBHxoUpnNJCiC/xSSj5yaf?=
 =?us-ascii?Q?Lz3voXoFUfFCuBQJLb8si/O5Hq8YG4OI73ENO6EEee/psktjP2CrhRmBTyXC?=
 =?us-ascii?Q?5rZF0sUfJpwt3JydS6u422ndlfotiRtqstf/6p5iKwyDihBMFDjya/fEYzvV?=
 =?us-ascii?Q?zDQFvoYJWL5KAJ+1NCN/oGMqwnVdjgIvIOSkDgsrmUXAS+O85kNCyU+BDcYQ?=
 =?us-ascii?Q?XcKxxaHacBvu2Iq13airK4ORIMA4B2U6SHWyK1jGp/rRCC0XKIw7jnoowGBH?=
 =?us-ascii?Q?MUUQJI0KWMVrbmOxJe2HXiPxj/UVkUPB6U9Wy47DdsFsfrt5sglWhsRolbPW?=
 =?us-ascii?Q?UU6GCmiYn0SOZTmQySdexjh5cbvWdYoM+mISbB8Ra4thKilq2tPsCo1bKLTp?=
 =?us-ascii?Q?eAU1iIDQ+qEcmbG/Lh4m7gtGsC6JTYhhTLD5heigHcTHOt2rbQcD6kct9on5?=
 =?us-ascii?Q?qo1DDzeuWnNuRQ5PUGk60fpXddkzbHIKoIyR9x1DAKUCXXmGDRUGW1mEyhw8?=
 =?us-ascii?Q?HwCoAlrTHmR6dp61PlhGyHrCuHWUnVKVpjfPv2tWtUy7D2137pZXSHHJkmIs?=
 =?us-ascii?Q?gmtcXBPOnbqw2YlNb6Zm3tprgZ0emD7YBT7nZ4aAfEBU2MxdiVzVYSvQ0jUe?=
 =?us-ascii?Q?J4hRus8ZLFIsXORNxHtasZTb7JDvLObgJAUOp+993SQaKjKTYf5/o67/Hlrv?=
 =?us-ascii?Q?sOHLMr8PPbMwq5pGlp8zWan6H7Wf2XdIkn+yetIbzmkTzc7aMwJkkltkoClE?=
 =?us-ascii?Q?VoCSVglrCvKt/UaNMlOj7dy7XTTBSeUC0x4vRNyLXxt2ZpRX7GNaD7o9aikV?=
 =?us-ascii?Q?ek9kASsrppH0Myw403CFrVLJ9gJyY0mRoWCLqo1YPaaudv7E/UsbU6SLqJmb?=
 =?us-ascii?Q?lnqnBtaaeV95V/35dpiz2zhuQBHG6JalpUuW3U83/kzDDvAk7oETPoER7icF?=
 =?us-ascii?Q?MHfIcYxDV4c3exfzbgbJOXtOhKPd4Zt7KczILUZfefWFTr4EVFCr75AUUj6m?=
 =?us-ascii?Q?IwDkUpE0mpBpaxF+KHeIX+wn1xwqG/q9c6huL8R3b0SaeECzeGGfzn3gwiJp?=
 =?us-ascii?Q?iwyz1Yy9nAha5637Ip34hMDbrlbF6jlPu36h2URBSJTXh3GzNQ2QUOvfMaEP?=
 =?us-ascii?Q?CYbx7FdU0Og+6QuNo4QbT4RDCPuE30ifQuGbvFtONYI99SbdCsGXChy0o5L5?=
 =?us-ascii?Q?YCZ7JGipMb874BM8bQLEeeLzOMtr6nhmN1NSMgTgRPMO73/n9CSgJ3y6tIeX?=
 =?us-ascii?Q?3/oS9GDdjfgOFJnNON4GOrY5zNoBpbbZvfDS64TIxBXmceMF/o13nwmInH7p?=
 =?us-ascii?Q?xYEckwic3/WVjyIzlyXJcG+BbY1t6lD5JZ29k2QFo3OuPnTERCBsq5P+N+Yg?=
 =?us-ascii?Q?LCfcCdSvwS1pKDtyPcz9mhOw2hzGqoQAGZNfq3GPVi/LYIjL5UsG8GO2Ote5?=
 =?us-ascii?Q?plg0AvbTVkxyqam4niacthwNyt+fHMJ13shY9uIZJeXSk7BhUOHHXDrnbt7q?=
 =?us-ascii?Q?btGx7d7rBOt5c0ZT0b7ulVetP+YGdY0Hs1UBNvRnYqFbKBy6DNTDsWWmEQ7l?=
 =?us-ascii?Q?AXOIe8b3z8gTucLVK5sat5qQIM0huxcjv2PziisN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf09a479-d382-44b2-5d78-08db218e78a5
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 17:39:59.8278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oxUzzHaWOcL0FI4JADFv+7SECscSAUa45h6Zwaur5bXISJWv8CPqXv/WnCqQGnZh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7475
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 08, 2023 at 05:13:40AM -0800, Yi Liu wrote:
> After making the no-DMA drivers (samples/vfio-mdev) providing iommufd
> callbacks, __vfio_register_dev() should check the presence of the iommufd
> callbacks if CONFIG_IOMMUFD is enabled.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/vfio_main.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Alex, when you take this can it please go on a branch that will also
have the cdev series?

Thanks,
Jason
