Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C77362310C
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 18:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbiKIRGt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 12:06:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiKIRGr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 12:06:47 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35ECB3F
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 09:06:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=krq140sy3PhQXp9L+3k/hrEn3+PSktIsJ9BMDfty6wXso0oESWgjDHbvMJVZxQV3Aw/kSZF7CHeCPZxffYAWzB5Fr+tRsY7mXvJH9beTa43YKNMN3TsyXH05onM1YBg60gzhoYuNqLLuVjccK+TD0QhTIfy+vWmsXMVeyVWnWNh6Dw9T9xcqg67W6Ur4eFxNyrPSqDOT2Jpj+Y1bYNj1qGVdQR3ydUqekmKo9rAFYZUgJilUZiUl5HXMKd9a5Y/AIdyGjoc9ZrnGoVfow4CADYBe9HZZhnThazDkR2svpR3ON321v8yQVREUnzGme4eJcJxvMA5vofnj40tWC/Q1Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+uthLG9hkZVjCUTs7l+3g0nOocr/8/E9e1fop862X3k=;
 b=TPQ3uRP9oTc4RaU4KrAUjZt15+w9bNkqtGgyfiWdIrVPdU/24g/bs8/Ad6Tz8Ci67itXkNYbiNL4Vw5dpE/TT25XjFQ9JbfQJP0ZqY0Qwzw6pAqwErrk+zh0g3xMW26c9rv+Q/yJe2zG1G85+32qqWu6bJXsS1sQi3DJX4py0RgeReiW1BhZJPCHmtAdidAd7+nzhWSdG4ZsDEMJ8b+nnsaQv4ff6wyrcJ3n+nn1MDX3l9yrvtu6KFdOQmQ6SdudQbUaWC2FiNmF/iEiFlCC2YY9eAedQmB1l3NUgze8vphY4dWufHVci/FucBH2m8/0efkVjpLyVArbMTq9OtbMGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+uthLG9hkZVjCUTs7l+3g0nOocr/8/E9e1fop862X3k=;
 b=MCQi25ep16eaUoV8PEzVkxc8dzIeuDLmvRCO0qxN2BFxoZLRmOcPNm4hO7344yVTyCYXNrC0XwjlD9mydK3wFGTQ06wmHg6DLYjauJD/GFowS8ao7CER41GX8yWDV4JNLwoQ4tOAU68BWnIwi5h/YzcbBkrRoyF94r23cOHmM2HUqhtFxvHLEC6GTubGr9e5nmmkop9Bx6M3Y+/iDZSLe7QUVcqNczHXFap+aYZ1Nqrd894nndyFJj2D93Unxx7UGqwjVJdjNAwZWB/jzv4l8LapLlzdNvs/CnpFGJuCbaPaGhaWDZFmXP+9Ianc3Ld04CNEtQJ/KeJX7EOWn4Q/GA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW4PR12MB6827.namprd12.prod.outlook.com (2603:10b6:303:20b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Wed, 9 Nov
 2022 17:06:44 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%7]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 17:06:44 +0000
Date:   Wed, 9 Nov 2022 13:06:43 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     alex.williamson@redhat.com, kvm@vger.kernel.org,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        shayd@nvidia.com, maorg@nvidia.com, avihaih@nvidia.com,
        cohuck@redhat.com
Subject: Re: [PATCH vfio 01/13] vfio: Add an option to get migration data size
Message-ID: <Y2veI4vCSO1xUi/C@nvidia.com>
References: <20221106174630.25909-1-yishaih@nvidia.com>
 <20221106174630.25909-2-yishaih@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221106174630.25909-2-yishaih@nvidia.com>
X-ClientProxiedBy: BL0PR02CA0075.namprd02.prod.outlook.com
 (2603:10b6:208:51::16) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW4PR12MB6827:EE_
X-MS-Office365-Filtering-Correlation-Id: cf93c125-3463-4367-284a-08dac274c78a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wwEKpkBZ2oLOPzvQOq0AphCEZDCdgOSOeUMw7ob7usgKywZBQHvBQdgzgg+RWrv/BuIZAH3VwpEJKVKiyfawEdtAeRjg+ubU/uHUOX/Ika/sU6YGEkguNESO6YJwAOMp7WCXTh8TgIWEU5nkB/L9rBYB13gJ3tRysIlASUmz9en70FLb1VI8ZRutcjnsqkj3Q+ZU7KfHBZJrBfBLPjo40BJK2zHGG32guZPN4qCzvBzikUs40Z0anbLqt3ERbEJwTVX48nq+eo/cfxKqju3MQlHTdwokKzQddNknfoXLOcSH3G7fcjNIMkfufxPHRQi23gnZaCPt5CumEQj+iZp4wj3bEwbF55cTTJ5EkRQvIp21FqeMjW5hQ7aW+tZzB4dEDFH8WpI3K1xkg+KxaBjamndewlvhe/s4xXuTvIiiF87ze2hhwpEL+VjcKRkXEesYsi2QpleS57VGEAXhsNg1hU8qKkkF1cSTSEpuOiIThUjrC5B9dZCje7OzDNob+xjbcy1dOrQhGDcaTq2q+Kemg4sZLCrvLcyXRX13nga9Qi6gM7RuRTIRRAOr0Y0D/udAg39Uwdp40PB/pQSoRzfCqrTrme29m5IfbqxZiUYUDvMl7JySbPYqojMyu+JipA9uKxlDvg+sKq4vXlJrNdzo9kFTCpWG9dzBcU3qGXNN59DcI5ORXpsXCHGIZo5k0tOuLdxzk1pIjeeQC5m8NXs7tQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(366004)(376002)(346002)(39860400002)(451199015)(36756003)(86362001)(5660300002)(2906002)(6862004)(38100700002)(8936002)(6486002)(6506007)(37006003)(66946007)(6636002)(8676002)(4326008)(66556008)(316002)(41300700001)(6512007)(186003)(66476007)(26005)(83380400001)(2616005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2fl1TDh8MkETdnf8Mp+Ku9nuTxt72j6Nhu/f5/Kf09sBkv1AXyf2xnHc25w1?=
 =?us-ascii?Q?OQ0GEg/f0g9R8tx7v1fS9nYBfm1oQkL7//g/v5BSDoCfb5lavXddPFNkkLzh?=
 =?us-ascii?Q?kMeU1zqKtBk5jhuxkwIeDtrLn/y7Me1qPfZoUdAwzMccSCq9B7u6dBL8R5SA?=
 =?us-ascii?Q?hQBzgr3gPhHuIEa9iK93Qhea+mJ7uWy78zCAdOVbS2rnSPWUxV4Ea8Wax2yb?=
 =?us-ascii?Q?JoyqA/eMja+0Yeknv1dp9khO0h1LjjKn3FMEOzbIV8nk7x0eWIYrk9QS3p+s?=
 =?us-ascii?Q?c1Smjzg0x7Y/XnsPEs4mJGxAV3Ktzzwsv4AjBCEKoftp/FTKZh3lSNsSCbxw?=
 =?us-ascii?Q?XjkG3ntSJ9RAcnQQUon6SjkOalpwIpBvnJAEspRdcBe0VwEzIvMB3MdXdQRO?=
 =?us-ascii?Q?csCVDl7a/z6m2w8b4pJXL5fI8aZg5MvbnbaSXOevghaa1VzKGzsku5eFeew4?=
 =?us-ascii?Q?+3nS7SpYLjJvJWsZZRCtOSvxrFjfuRlYGcLZGgcOL0onzsL7Zs2HWHDHJMGa?=
 =?us-ascii?Q?hDqR4s4d7YsQmHD5VR89MPqyVIJ4jMY6DnomB3rhHcuVGuq8ypwei551EGyZ?=
 =?us-ascii?Q?hUWDeAsKMPC6B5BRNcj12Nvp1i7S1tsR+N8nOop7faLTP5k4UEq7t1PMjdO5?=
 =?us-ascii?Q?59bmAEufieW25MfuLIUcBAMAdwNhEe/QjaGO26XmfMaYQfgxeLLAW8L82ygr?=
 =?us-ascii?Q?ghDYyt/QDIkqTS0zmwXP3HaBugGAaH7gS7+oyfCKvHDCO+9k9/xAAgwwl0iG?=
 =?us-ascii?Q?qsUTq4EOcjEQteR1hfO0h1hKfFZjdb9+6Hz8fvK7re845zqOC7ONdn6encwA?=
 =?us-ascii?Q?PET4HW9Z9L2a9L5UBfxrfhlhSSeOr8A7Nz8+qoqmw+h4KjVZUDrhMhW+w//8?=
 =?us-ascii?Q?SOodNPIOJ82qQuk9VazkMXe3muEfdqxTwYGqLS8Bjpv+Dg2CGWrzMgM7J7a3?=
 =?us-ascii?Q?hPhz33Quc6IDbvs8y8qHiuDzcsFJ/tnsJ8LAmWlAGXK627kMfqgOQyOOtL5M?=
 =?us-ascii?Q?dEklpVDjtJeE7PmIO3KtbLvvTyvbYc9EXVBcLISdL6H0lVs6WkndtsW36M32?=
 =?us-ascii?Q?HgSTTqlVdKBLMVwVd28+i7Kvbh/d5bpR+uCMcFkD1fYrtuBlDzpMfzGpEpCv?=
 =?us-ascii?Q?qugM9ycZk+g7oQNJYR7Qd1x75IupmAepji0znKU7c3rM4WFg5ubEcoxuuoex?=
 =?us-ascii?Q?SDoY9ELBcBVXWLun5YWWbxFDc6JmzR2xjPoE7pwwuYrgl37dqwUtWbNFD7Hl?=
 =?us-ascii?Q?24D3gI7b+6JcgtpUfIupoczltCh4HYXeaMTJNM1WFQOJPvTaxe91sdTmr1QD?=
 =?us-ascii?Q?/kF+JrhMga3J3JwekUd0cK2k9x1XuqVV/2m+QihNHS5CO2Kns4tgLNEZozKc?=
 =?us-ascii?Q?1bfRQ4rEuWbntVFzzNDjgIJYzZ8B2cwXurzOKOoVbfn96WXB4zQF+GjXgtQb?=
 =?us-ascii?Q?rCchnlcIqTHzwpX3rpbfxKkIOdud1rSwCCeza1N0sMA4IiiohBpMtT1KliRj?=
 =?us-ascii?Q?+i61WTVmpaMqST8BtvaRF70kQ6UZLhxGC8/gxhyPIE5bxIDNJPoCoGd5NhW4?=
 =?us-ascii?Q?jRNaZu68aVpFLUZ2Vuk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf93c125-3463-4367-284a-08dac274c78a
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 17:06:44.7623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ekeOM5BNwHlkK2bl8tMM8W4xHV67dgkwKOcfI0/mGk1B1wv9j22MTbMYrYZjt9HY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6827
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 06, 2022 at 07:46:18PM +0200, Yishai Hadas wrote:
> Add an option to get migration data size by introducing a new migration
> feature named VFIO_DEVICE_FEATURE_MIG_DATA_SIZE.
> 
> Upon VFIO_DEVICE_FEATURE_GET the estimated data length that will be
> required to complete STOP_COPY is returned.
> 
> This option may better enable user space to consider before moving to
> STOP_COPY whether it can meet the downtime SLA based on the returned
> data.
> 
> The patch also includes the implementation for mlx5 and hisi for this
> new option to make it feature complete for the existing drivers in this
> area.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |  9 ++++++
>  drivers/vfio/pci/mlx5/main.c                  | 18 +++++++++++
>  drivers/vfio/pci/vfio_pci_core.c              |  3 +-
>  drivers/vfio/vfio_main.c                      | 32 +++++++++++++++++++
>  include/linux/vfio.h                          |  5 +++
>  include/uapi/linux/vfio.h                     | 13 ++++++++
>  6 files changed, 79 insertions(+), 1 deletion(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
