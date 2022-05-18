Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8B8652B959
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 14:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235996AbiERL66 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 07:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235943AbiERL65 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 07:58:57 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2072.outbound.protection.outlook.com [40.107.102.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC9186A04B;
        Wed, 18 May 2022 04:58:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JYYOpLWBKkZVTypcoLD+OtBu6O1w6zb9WCzJUVkthMPKtYPJUcQT3H2mOWkZo68cU9x0WVPyp0l9SP6wWgCo6oeyJ075n0YB3Nxx/ysKHb+cyB9BPBQZhRg32bBF4qSCLcpcCXv2wa8ovaF0BV7J9y7PwTnPCbehG7TqDabBztY2S6eRjjG3tewtUKkGEM0BOWCXC+0p8rk4wchpoY8DkTa9v4LqY71piowl4fnfttFYPDAtWzHU5fCplmTPQ9Fb5kHHsD4mi14/OpfR/47+nX7/7uMStjIt7RNY/cxOyr1dvuHUPnfMk/ced++uOHTxiRd7ZvoUDvE5QL9nmG8JuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qZf2nxQQgH/P9Ft9cVmHIBBAPkjqpKJXTd0wBQT0IMA=;
 b=VdYt1vCUkr+XpBJ2mIg2gC/WeY3LN6Na8jmd5mr1DoAhFNzEIJJ1FpwijXdh34skF8wSg/WHOeq5jIU+ywQeaMVafuXjNb8fO3I2DPWTQkfC4sDPsKyZZj1FG2V7OjXeD1wiJBJyLtNdavh/iuZ1Huye5jhaUXNSQ1QjNzAsJEZOxiQlSqaCWO9VnqHoCw9ucAQAvZEavih9RGpG9pwIxMa/9shuLy+Sn8hV5w/J8Pidb/hBXNaBZCCe7Y4HjZoEyKUBa4JFuK0ne/zi5JILXw9G3Fzeq281rZAoWGUy2yB6FfhViKCrBGvrwqD2rc6F45w2th/0mH/pD5ysbhs+1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qZf2nxQQgH/P9Ft9cVmHIBBAPkjqpKJXTd0wBQT0IMA=;
 b=NTmyvYJz3qETzQrhV6yskc2IP7xuJ5fbWaE7clslSGTw3ZsF7OOFaBan490SmQ+cvk9Ski4xtVFUn/q/qLVLfBePUjqE2+NUPC2pteUfUcpxm6l4N0hfp6Lu5ePMXUw0qUryQ8szxL1JGH7Z5DINpnrhBW0TB1KQeDzYIOfj4D3hONnGGON1MQRxlt1a4oJibkOf+8oEGIU6T5iiViZYNnSMXi7DSHq+P7IahX+qhffJMouHFM4LrjDkhq3heYo2FYkwx/w+flr9QAB/sJBOgLRRQ/oQsY0OchzhW8QAPTVpt7p++1tBrkl1OawVU2IuvtOTFFDwO3vQECCtNQkeJg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CO6PR12MB5442.namprd12.prod.outlook.com (2603:10b6:5:35b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Wed, 18 May
 2022 11:58:54 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%7]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 11:58:54 +0000
Date:   Wed, 18 May 2022 08:58:52 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        alex.williamson@redhat.com, cohuck@redhat.com,
        borntraeger@linux.ibm.com, jjherne@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] vfio: remove VFIO_GROUP_NOTIFY_SET_KVM
Message-ID: <20220518115852.GG1343366@nvidia.com>
References: <20220517180851.166538-1-mjrosato@linux.ibm.com>
 <20220517180851.166538-2-mjrosato@linux.ibm.com>
 <20220517185643.GY1343366@nvidia.com>
 <YoSivTU7nivO9FMD@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoSivTU7nivO9FMD@infradead.org>
X-ClientProxiedBy: MN2PR20CA0034.namprd20.prod.outlook.com
 (2603:10b6:208:e8::47) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e26ac32-5394-43a1-0f2f-08da38c5c80a
X-MS-TrafficTypeDiagnostic: CO6PR12MB5442:EE_
X-Microsoft-Antispam-PRVS: <CO6PR12MB5442863BF5EA5BD5F7BF8D15C2D19@CO6PR12MB5442.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QHdLnPFMkBbDUqA5XISUFDXVBtSgVVLBthDahgcvorUlEOR0Hl5r35U0dbhS24qLJ4s9CHX7BqL6iFVKws/9d9gdY9Gx9M1KJYoB8MBSW+xW6fRMG1X76X/i/71CMaO94JcDBthBXd2ox9/rnvfJrelfQiVpkho71Qtc7IHtP5OrFRcMvIpOtofowe8TEY9O3jfX1w4nqHc25Vv758t2egiXD3USVH6FJpqJYALKYnClOoGO+NGhmz2KrzrdC7rIcphMuP7zbyco1ELb7yRDcnKxp6SWWwDoqJDxzvs2RClWkS+4ExOcD6gUeDQtoBd7mNT38376PfB32FUoXzhl6YLEOXu9i4uBJ6s5qbHwnKQdcQvid8BC7KXXuwLIztnEGJdgGjIBk5Gi6j4DDbej7UNpRlrp5cskm7EC7e7n9O3GRKjpf9+Rsup7Hm34lQaNSv2XPba0W1xJka8nQV4X8cAXu4Ux3NCkip7MK0svz8JymQA0nKuuIvJ17Bv5K+f5HEZfblZFYrhqcK43wqAKsu1f7f5hFM5qGuawhbuXckmf7X31GBe3X5vduDFQjJMQ0vMdFZeeMebBEaOQAK1rQM8BvMtm5XqVJtnneV/obfY4UKoohNp6RebrQBKQXJM3LlDUdi6WL1TDvstpSor74g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(66946007)(66556008)(1076003)(2616005)(33656002)(38100700002)(186003)(8676002)(2906002)(6916009)(66476007)(5660300002)(508600001)(36756003)(8936002)(4744005)(7416002)(6512007)(6486002)(86362001)(4326008)(26005)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5FfdLZdlYjppZcUzT6IjMvGiAxwjld+W526QBK4EsX9M8pZtCy+63E1zAgNZ?=
 =?us-ascii?Q?0wcjI7qsGEKyuGLaGw2E3QC6HksU6FKh2cP3nDX/8VuroFxKXfg7+dBtEBYc?=
 =?us-ascii?Q?TAZva2XaX4pzLC7Tlp1NI5Snn3wSFc0G6HFfGvkxTMU4QCSK1Zfjc35kKIsi?=
 =?us-ascii?Q?h246hl3HDtMKzDffe0j8YvcBG2VtdLQdJ6UNuTm+r0bj3qzdOIb/Tv2iBlRp?=
 =?us-ascii?Q?YCUcIas/cEL7ok1tTTJO4UpoWIhZ78tMaE+HsrV6rFBZ7sKc9d3FGkdADbkM?=
 =?us-ascii?Q?P8ez8mOKh7JIhKIQ6Ebt7R9GP1zIxCZZiasqUo2t78hatRxFUbD9+b+ieXP8?=
 =?us-ascii?Q?gqhdBCT+nL6M5BQrqSiDjR8xgyZLrFAzSg07w8WU3Dbn8vIwh0DdT4EaMdqU?=
 =?us-ascii?Q?A7cwYzYeheAHHt/QImvpMghzsKPFX/sDLS/yohOsXZnig0k9+3D2bRcHjHlH?=
 =?us-ascii?Q?iGEsAKeJpY3Jac9Jp9/Pr6YKYoZJLixtQ5iJ5ptKS2y3JEk8FCj3/x0zDeU8?=
 =?us-ascii?Q?MlEgmq/XT/EhLxoD5ELN3nBWuBjlYOxo6SSZnwJUYdw/kgVSoqO4De1/AEn6?=
 =?us-ascii?Q?jXSfhAN705mWp8W8E+a77mxSartm/WRR++/Rgn+Sudy5xDGZFEzlJF4YgnkG?=
 =?us-ascii?Q?OVU0qa98uW0E1qlt2fA42GkJvJwvm1DyEg7VBREz1CtHnrOFbzUfg8iRaCAl?=
 =?us-ascii?Q?E7+J5lEj7CW09sBeIyVKa3/qLAXEKEI3ER2Ro35Gd98RLQuM9regitBi0/Pt?=
 =?us-ascii?Q?brzYUn4iFA/rPuIRLuhotG4xDe85uOjk+KVxErfeG663LcCbfjUedGXKtMDY?=
 =?us-ascii?Q?udo1Fxs6QQXvhwdvG8VOZUKyIGjEnOaFMWg4Wi7SrLkOmF+F3ZzSzhZLLNwd?=
 =?us-ascii?Q?rclIv0shdAXYUZBhwKcvZ9tgnBtpXL0X9OFk+0fzQvlsUqGhArTx5zc8evgM?=
 =?us-ascii?Q?QAhgRFn0wz9PTz4UzonM8SXGI0pXSGLCpoSRPUFuiIUPSSPOy5T+0Hk9igEO?=
 =?us-ascii?Q?OW/zRFS3yFqch+kwvfcUcH3BfKSgQ7+YWP0ZBO1OqgmZ8WONIfDi7iAWlg3d?=
 =?us-ascii?Q?/P6gw2KRrOVZWlDZiD49iZGKxzvjUg0vNqlWWPDLCXmx9jCo6pv0nEub+wT4?=
 =?us-ascii?Q?fOtb82nedLt/e70hNxAKSgZhheEK6oS/9Z6xQYXLDu6P+V5gXLfe/OkQFQiI?=
 =?us-ascii?Q?e7S2J72tnhoqzcduqOj5U23M3WR5NG/Jiizc+If3PWYG1m7cy3PB/GQ4fACn?=
 =?us-ascii?Q?YMcFAHyn/xlFJdXWTWSmrJ2YnqtXDW10+P6+SmBWI0WOjsN5iKGbeTmmzkhp?=
 =?us-ascii?Q?ri7FNNHMqTuLzgaI4aR/6kdGWaObcNmgJkm6v0IzIKZF8ETswfaGkYB9NziQ?=
 =?us-ascii?Q?1YNq8zxsroigwUr37qFdK+obLOPQRem9tNE5kk8Ut6lWUqSYBtkpQS0vFswg?=
 =?us-ascii?Q?h6YqGkJHoTwP0KIAk5agKZ6A5yAuGBSK4WyktX2uhduLLZ23Jq3XcCu0vQ3Z?=
 =?us-ascii?Q?n2gfpR6U3atCMQrs8F08B7rQtBcZ0JvudY+CIcTQ7Ode+ZOWcEVPwR9vU9td?=
 =?us-ascii?Q?Dyuye8vDJHaH6F3qcK+8+SuMijTaXdOIwFDKaV2fAXmA95dHsiuE5SJGWy2o?=
 =?us-ascii?Q?2THbxNVEw3/bRMkdFFpjt7sO62pyN651vk1rT3Y1KeujcPWWfNyajrilmLF7?=
 =?us-ascii?Q?Ha2v1nHhAz4PSZ2iTzSLIuaWXNmocGEM9UGAJURDcGl3zqEzUStMrw9za6lU?=
 =?us-ascii?Q?4yC/JA7j1w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e26ac32-5394-43a1-0f2f-08da38c5c80a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 11:58:54.4192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3bMOsCQhA1OmSAe7QkEgBDhhA5o8dD0cyysPejy7Ax4C1upCXOu1noR7ExoVxbhn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5442
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 18, 2022 at 12:39:41AM -0700, Christoph Hellwig wrote:
> >  	if (device->ops->flags & VFIO_DEVICE_NEEDS_KVM)
> >  	{
> 
> Nit: this is not the normal brace placement.
> 
> But what is you diff against anyway?  The one Matthew sent did away
> with the VFIO_DEVICE_NEEDS_KVM flags, which does the wrong thing for
> zpci, so it can't be that..

Against what I sent before, I did this before Matthew sent his

> Also if we want to do major code movement, it really needs to go into
> a separate patch or patches, as the combinations of all these moves
> with actual code changes is almost unreadable.

Sure, just checking how things could look at this point

Matthew's version first followed by the code motion is probably a good
approach.

Jason
