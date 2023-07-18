Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC39758321
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 18:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbjGRQ6d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 12:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233984AbjGRQ6O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 12:58:14 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2065.outbound.protection.outlook.com [40.107.102.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680951FD3;
        Tue, 18 Jul 2023 09:56:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n3odeXWxu79JXTLwTxLR2CpDj4NuuNz7akrt2yE4PfX+RAqG7whGQvVajTevzMmv6dF57BYaNjdXt4rNUK4edobVVs494qQevNiFGbZKZABX7F0U2sjTMWb0Zx4fBwbvr/LBbbo/VY5HrVW44oR4zsDlsrx2soAfVTPAZsKMvf9stDyn66DuPMHxBNyLjtXLui4yWR2LP8qAeH/3vIvBFOV8f12VrPnh8gPetwgmptcW6RrqsmwpUO3xgikR3fhiTBgeC4rvO859QKbI8xwSxvUq9zig+FZuMPVLHLekcm//n0+AZFin5+f5iAbzh/EbTINCN7F0FXt4Ce2DC0N/Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aDB74Td3AQrwdyvDy58AOzyvvj0O7nfVzsp32sIA4Io=;
 b=Y+YeVaC8W+Tzf83wA+fBwdaKOvRq8KsJM8m4n4kdkF9/gvaGk5wh9obPl1bnyOaWsJ8dFmmcKksUP8orQg7a3kacbvXDo1QbJoDL1BPJhDLm2XxNjc1JeapY45Hvkg2wleoTLrz0u2k1lS/edjMW+4NwctN4XNyCoUn1Tu6CzzYmKsOf6CrVLxNiUqBrb303ThZenGOJTSWgLnAJ3Of8700hO8QosJ1dKjnsZiA1FVI+lul3s7w+P5u61KqDB6R7CkEh01Nnlhl9a9nEDN9klbAPDGeX3G4Gam543Qm7FqJ/Iq6biAfw5QKXSRVlIT2tEgJ5LtTL8pE676yUch4qCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aDB74Td3AQrwdyvDy58AOzyvvj0O7nfVzsp32sIA4Io=;
 b=M0hdrLuWapDiKpsxS6HlvRRptazxcLM2mbse1zcNEDCIKaw7Bbq/PANfUJUgwfea8fWYH47ut2akAv0UycoqlULYLwpKSRRPGFav55/F9P7Td33I8JzsRC8xNLUZaPoCnzcGSydOj7+QejTKl4onsQRBgEfBLsozHf9i0d4qzcPrs9Kn4aUB6NEbK+5jPaOFEc4TEaRZAo3PWRK4mssMCJGMqRWT/1Ew9nZrQnp2EbwCuwxvv9GNdLUXfL/SG2EVRAUksg/dERbLJY4HBNI+vT1Vtc7aJfuIo/hD7GVbcZJYpDFTP67Qz/U/J2bzhSHfF+CLCak8Cbj6tgEaeEihUw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ2PR12MB9139.namprd12.prod.outlook.com (2603:10b6:a03:564::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.31; Tue, 18 Jul
 2023 16:55:53 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1%6]) with mapi id 15.20.6588.031; Tue, 18 Jul 2023
 16:55:53 +0000
Date:   Tue, 18 Jul 2023 13:55:51 -0300
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
Subject: Re: [PATCH v15 20/26] iommufd: Add iommufd_ctx_from_fd()
Message-ID: <ZLbEFwY/e+g6jlzd@nvidia.com>
References: <20230718135551.6592-1-yi.l.liu@intel.com>
 <20230718135551.6592-21-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230718135551.6592-21-yi.l.liu@intel.com>
X-ClientProxiedBy: BYAPR11CA0037.namprd11.prod.outlook.com
 (2603:10b6:a03:80::14) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ2PR12MB9139:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bab9a0d-cfbb-48c7-c655-08db87afd90c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B2VteJR2Zy9Wdb9fM1KXWBw0gPWnZrUND1VdItbR8CnlNhM3sCPDjJS/5gl8v31s/pAR9k7yegjJnkKqAVRFZ0ZacKTxBVQmJ797FgOPik6UeTsXVrJvXv8S7MLYMsAtILuPgUqhc8VIf2W7p22aGbHHRxansQVnPmxoMXA6GCmnsZZD1QE3wgUxVtsG+LUY+tQ52Kh6lUBcXQArb74tT2yVaoLJ4nuNutPAcdqNdfBF3Y5aTbElqvnHtBfmaau65haoUoVpl+utmfKgExZ6hKen4uHc70jiL/0/kb+ZtIOM/y4bgyyGQik5gNcIshfGIW5vlP8IxCoAihLG1UX7+tvm5SlAgEC+xEpEx6Wh31sgRvmsGRpt7yML78SrJ+Sr/HdNFagH8LpAiKOLap9D33QIv5uNtCi/y9lQWDEpiaNEJ7tqAySWvvBPohZlPZXkn9P/5iHp5Qiz73umgj5AGRDS/90YowNBe3DK4nMY97IiYEOuEcbFP2KjJNHii06LdhIhqh/cTTv5QcJdcRUOlp+eg6lvjyut8K/X3DLaegkjLhIjB4VSkJwm8D46VKro
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(346002)(376002)(396003)(136003)(451199021)(7416002)(86362001)(36756003)(4744005)(2906002)(2616005)(186003)(6512007)(83380400001)(6506007)(26005)(38100700002)(6486002)(478600001)(316002)(66556008)(66946007)(66476007)(5660300002)(4326008)(6916009)(41300700001)(8936002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sMWsdOCOB8IEbcN57rvcrbxRjOPH3xzjaRXTxUd3wo7CxaQe53tbcwUs6HgJ?=
 =?us-ascii?Q?IYh6eYmgbjDirm5afcPorAKpML8/4gGy9HwTGVuqePjS3it7SGDk+joZ/zZW?=
 =?us-ascii?Q?P3PlHrc0FQNMx38zbH+4TTBkaVah6DC6Si+4zr6w3WJUaBY2vrWM2LfPtyWa?=
 =?us-ascii?Q?2w/RoBYrgnILo2lKl8BugyCUiC0JFko3+mdNGwK8fBKQqZwCapAqy98Lo+vc?=
 =?us-ascii?Q?e6kcCYpqC0Kac7SqOGlDEmLNCA22ksW8WWNId6p3vCB0n4mKBl5eK6VTe+c7?=
 =?us-ascii?Q?jDQcJcGwPm0YGi9St3sS+gWImq/er/LpuJeZYJWDUbINDqlM3C2EQgS2RrrG?=
 =?us-ascii?Q?b/EsPof3iuvAs0aVihpUBQ6X73txPBSSliMDtVnMhVs91B/lMGn1thAtL7+Z?=
 =?us-ascii?Q?73ZHu9W3FTzbTrSqs0g/Utfsh8tVpGyyUw3CYlAikv2gH7g/N/hJxlK6+a5y?=
 =?us-ascii?Q?6AfdqXG3EwxzckTgcae5mY08wcMEdxlrFo2r5lxwFQply8T2tqyyNNEBTnge?=
 =?us-ascii?Q?lN7QbVGOZb+wttsktaRLbOJ0EZSh1KNVKQa0TcsWAs8U1tVSNszSiv5enrH2?=
 =?us-ascii?Q?I7m6QXTA/xZuCh7rL8yfSsw8jMPnn5IxzY3nKbf6ubQ2elHGP7oWBl5sOB7C?=
 =?us-ascii?Q?U0h2xMpQKgHh0+zoZOjwOkl0Vp5NOZ7MDTEs4K2hVSwdmjOraZt7Zkx8DXbd?=
 =?us-ascii?Q?YuBKz/QPjOCrmATYuucQpRATCZIAp5XBe2wrR/RdFk4w3vTs9NMepQTpdjff?=
 =?us-ascii?Q?RgbJ98rhJ6iKMwbWPYfsFxyNcMrRcH1YJywkgpiUnjdHF2ou90oEi27JDOpz?=
 =?us-ascii?Q?iJ90T1S2cu7xIhMyy91z6gQPryiqvp/G1slXWFgpKEXjUM5k/10AyNI0JhgK?=
 =?us-ascii?Q?FM7IQVFtAYXohWg3SShlJMSHQNCezkQPTPOOZcJ50l8ObtGEi1y33KULLsbJ?=
 =?us-ascii?Q?frCkQowAz/7Sot4r0WGocegNet9yezq7hnpwc4TIOPN5v4SGPNfME0lse6Ed?=
 =?us-ascii?Q?2+xghCo8q8m6XJnkRSqh4HmX93FToFmoXeRoaMrHenf9qhMJwipiDwbU8ju4?=
 =?us-ascii?Q?8Q85FcSiNmk+/W8H00LGny7MM+atJhDaB6gNyZzX+isenzN74RtW0Y77RcxS?=
 =?us-ascii?Q?r59+DiUtIRKWi0IafiRqR8giz9ABfE2pPT2WvbdcYiE/AzLB7l8m1GfapiIO?=
 =?us-ascii?Q?5PjkrJu32FvrJ6xdx3/PuaW7gfBgaXQYZ8CwDGMi2tqNWiwYkS54FSpHpjkZ?=
 =?us-ascii?Q?hjhsDfmJuSOmuwKcfCxJZTQiRsym0IhKIbM1dY9ZNqzhiEruiwM2cBOp4thd?=
 =?us-ascii?Q?2fksJQzYROFQOhKAqR97hcSGr5dC3Vs64MiqGfUvQU/XhYUaHTYVfKKnn3Dw?=
 =?us-ascii?Q?1qnFXMSIakXNzU3Fxd1oRfDhZqVEzCF6AH+IWItIFtpn7KJjxEz6juFG4YnF?=
 =?us-ascii?Q?Rck8m9xglJbazXk7tF0SLQphPJAq7h8NlmFaKcUn6GhnnY0Sas+FU9+LcwJI?=
 =?us-ascii?Q?BgXx3ukjLKeW6+w+TG3jf3HBV940OH5NYQ6rEkVZkf9im+Lo+F3Q9otGffzY?=
 =?us-ascii?Q?wox81lI6lG3LGJXcl+nU0a53aTDo0kN2+Y6n+mvY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bab9a0d-cfbb-48c7-c655-08db87afd90c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2023 16:55:53.5082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wmqYyvbe7k1FVmUoYamUdokyZm2AOW6YJSBd+3MVHUJzwodvVCnH+TC7P3CLW5zK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9139
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 18, 2023 at 06:55:45AM -0700, Yi Liu wrote:
> It's common to get a reference to the iommufd context from a given file
> descriptor. So adds an API for it. Existing users of this API are compiled
> only when IOMMUFD is enabled, so no need to have a stub for the IOMMUFD
> disabled case.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/iommu/iommufd/main.c | 24 ++++++++++++++++++++++++
>  include/linux/iommufd.h      |  1 +
>  2 files changed, 25 insertions(+)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
