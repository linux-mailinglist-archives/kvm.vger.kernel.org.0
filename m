Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55E547D05A1
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 01:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346711AbjJSX4y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 19:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235563AbjJSX4w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 19:56:52 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF89114
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 16:56:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D8eTb7MHjr4RHyvdnWMMxmAwYyJjC1xWQdGRhqX1clQxmCS9rFWybpF6xuvtVPHwanmWzdt093LMb/Qlt+V0J5WK/b6RybxkDcc6whEHcXhDnPDbusQAqqQWV2tot1g3bNvK6AoGzv7pQeFmtLW1NlFTsANy1HS3Noy6Fh5qTZDgPeDsJeJ+RlIrSjReVW7c+bkAhc8AKH+RmMXUyMUevYJvd78JfXI/C0RztMBaklnPIsi2Exu0qOU+BGsdtXadOEqXUwHDMWzJEBApq4qPFFlDCHlU6dxOx3gdbpUjJ/TV24jMBDXZ+Q5vI5Diovz3aB4YyoVfGOGd9t9OMITEOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1zDWoIybJAdjIWad9/R+VBGCYVzKjrADKU8Y+0WdEkA=;
 b=LEyOO9+qiqXwWwRUHMjSd0PF63f5pTclof87IdkT6orjkbR0ZeXH7FIh1Nv8nYULBUkcydJVFX3/anTDYr/L2dHI0lwwyMjkQ18TiQBsyTu+h2K+DeA0Zz8XUNRoEhc9tUmLEIBSDg7KtphgpA9ZugNqIrmALbhAqLXJ5OMwziNOkZpX4vFTnTHA4WFpjwypf+zcThEEk7LqBagkWmarImzNcZuR1NZKWNFLGmPwc54gnsiGXiduu49K4lq24N//tTmqivfClUBRpz2oI76RRFcwKARKoh2FvDUFEe871QH0HrL8baUSUSb2y3A/AbMsMMAz/KhgMFJbsCHc3iTi7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1zDWoIybJAdjIWad9/R+VBGCYVzKjrADKU8Y+0WdEkA=;
 b=BMouBoA96x/kq+GHfvUz6O7NQWVKds5MBMFhat31G3sXCmzH45UHEDqEgr7qA4d/E/e96ZH+2VLdCYB8I1VtJVQ6WdJsjD9HNXsqLdBDppS+nHNNp7+u5npERg2tXEzD3R7Te82dRX2CCT10/kiybgv3S/tVsRR7Locb6hj+Nk3M5bl8YwE5mb/06zpEzkpoAQdn3gYVKOEbBh8OssauDLlvP4076vgO2GIKlXbfEo/d6YKUB1QPbPqNX4EFX9YZtbBPD8CKWibrIArM09+B624yCKp7BuZY9HmjkhUkI0xEH4P/Wd6I9sKoM+qKbXNRp7/gS3/Edg9Qsvx8X9H4Sw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL1PR12MB5222.namprd12.prod.outlook.com (2603:10b6:208:31e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.25; Thu, 19 Oct
 2023 23:56:48 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Thu, 19 Oct 2023
 23:56:48 +0000
Date:   Thu, 19 Oct 2023 20:56:47 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v4 08/18] iommufd: Add capabilities to IOMMU_GET_HW_INFO
Message-ID: <20231019235647.GA3952@nvidia.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-9-joao.m.martins@oracle.com>
 <20231018224458.GM3952@nvidia.com>
 <2eaf1e9f-0c12-4306-9aab-2a63fb5b1079@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2eaf1e9f-0c12-4306-9aab-2a63fb5b1079@oracle.com>
X-ClientProxiedBy: BLAPR03CA0121.namprd03.prod.outlook.com
 (2603:10b6:208:32e::6) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL1PR12MB5222:EE_
X-MS-Office365-Filtering-Correlation-Id: 14c18ea6-9b0e-4785-a9c1-08dbd0ff0ed0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bYlFE8WonyFpaN87xqia0v+Ie6Jvp8NxuRM7eZOLZPopBEsn4XSTuSt/AVRfC3+mrwlhs5gHlfa/cbq8TN8PoIUEb3acg+E+MSiMmkQLO1NmGRWT4ENYqF97ECCQXvoU+2V1BDTSVxazGdtaJhTeTb2NFJ06U9vX7eEpoivLWTCKqGpFDQ/+pEB5fq33IczkiRU32doLO3FtOET1dJUHGlnrRzegUq3fXVGA3fWzZ3nCkxSv1jf8fZRhMPq/CzAE3U8YAoj6dHmMBCU8TVAxWrBF29+J31I+wabOLG+zxuggNq+3+0GvICvl2DZ1rbOXNtBKT3bKZtlZbk9u88moWVAXLUBSITXq5Pd5NGiAxxrVSRduI3RNIDsqsDescPABgHsqgjdg+DVLfkbyQHmW7RU23NCnvCWnt/XC0yqSS282n6EWoshjZWM5LNOLeHWaAOpJyvPFDD2mW/t1izFf64bhFQzXcawUFV2we8rtdiUh1MzYHN3jNJsb4PW0NlPXNoX0prFrjJ6cFBlYZSyIlJyZDPAsoT0J+vK49dg7lv3dfMrqMeKCOBsJGCxNFs7E
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(136003)(366004)(396003)(346002)(230922051799003)(186009)(64100799003)(1800799009)(451199024)(5660300002)(41300700001)(8676002)(4326008)(8936002)(2906002)(4744005)(7416002)(6506007)(6512007)(36756003)(38100700002)(26005)(2616005)(1076003)(6916009)(316002)(66556008)(66946007)(54906003)(478600001)(86362001)(66476007)(33656002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9rADYo1jgUhTPlczrLlboqPm+MWPT/tTSbRiBZypSj26mcpl90EwlKy9XiTA?=
 =?us-ascii?Q?G6IChFcQhgZEelSIr+WOMYnnBHm75oJssVwKw81zFn4ekhuvjagJ9xNavN/A?=
 =?us-ascii?Q?+0Rm1nO+6Povg31NTx+Df+xeNRvLBxebYyJTxefdcb9h6pYXVorw+/ENHSwX?=
 =?us-ascii?Q?37HHpyQz6gowsroBKR0F0Iao5KmqpD+cJ8uFj0SzmrMtJULoX/KibSoah5BU?=
 =?us-ascii?Q?qdbRMe5TTZ5y/r/9YSY2wKalrHT79OBw4osBHDty2TwFUTd02do3uKg1dnNG?=
 =?us-ascii?Q?0r8zaF87zCTqnL47BOhlBg/ZZZcUGtOhTN0PHfEO7glPHQuMzdwHvjduRkGr?=
 =?us-ascii?Q?b5ywVAoqxlaw9Hgp8myUduWF1pwDvmFLQNN9/xsHTjaiaYnPAe725NQXBKjE?=
 =?us-ascii?Q?vOzV0OjvSmITpBWQpVD9qWM4gmCsZJfQyj7f+nTDK46dtPlS/OyGUlyyGy1f?=
 =?us-ascii?Q?h7rr62WOP73bC2uOaZPiNH6YTcX2O5rYRxwnp7Hmj34w0HWGVvXmBmcMxFol?=
 =?us-ascii?Q?MHmIsudNiYBWcOHmeAvVaRLaHy/UVjvOKkIoEbLcdKYbhaL42jylwaE4FwrT?=
 =?us-ascii?Q?NtNg4Kc5uVXW2LItEhwzQ9EnXbkmDeS9sq9v+K5uP71Ckdx3yTYmEW6WTQ7u?=
 =?us-ascii?Q?X/S9/VN4eWOFy5sPdAfz3dgDPf/tr1Hd2jf4eQ7fIcVjGqd+KjkoUH75ZeDO?=
 =?us-ascii?Q?6Zxdpv5dbmoy7ZLNRtWteyBPClIR8LXfZHl5lMO3vO4BaUjfASEo2zQbTQdw?=
 =?us-ascii?Q?r9WAYaMzyWJWSTj+BN0LhzrNkP7uPsC0uRzYXw9bJoYMYgy7Gr6heI8RQ7Uk?=
 =?us-ascii?Q?PX0c9Sm6H7AI0QXxAOyCtMaEY6UbQgE9oCY+DAesJNISLgI57FEciN4fY/LP?=
 =?us-ascii?Q?OdissoHlleNohrZ//dzhe1VziSzsbMnQSK4TjbChSXApF3RqVdzejonq8Eqx?=
 =?us-ascii?Q?COzq14UYpfzSVZYOg6XJcmIpMQPAVr7jWabzDtvpO89qzEZ9RxvU8C499l52?=
 =?us-ascii?Q?lMXo6oKmdgeuc9FWhk7TxLUCipYmsbNAK9L5OdW1l2O+k9dWW/YbbpwkOEUO?=
 =?us-ascii?Q?RdpZOgLPO5bhc01KSg9e1gfGWTWZqpRyIxhlr62E2FtbECQygMLLODsY+C4D?=
 =?us-ascii?Q?rsz/EpGgWXQgrI2cX1qWjf414CaqGAHE6n/rN2udSfv5sBbeRk2qOLkqkJmw?=
 =?us-ascii?Q?U72kl+dhGmalqgaFKhoN7iKDD6cnTHqUcInus0AHXk0Jjl2fKCaH/q9AWyqX?=
 =?us-ascii?Q?zU9Hj605hm+j3nMhAiddrYuJ//nI/gmHTdq4k2UQWT9DYTA/aI8SjriwpICb?=
 =?us-ascii?Q?+1Z7QqQIo/rCasrrF0Bmt/ueDK3bojgqR0CAaS7hR4vsB8AA0ad6pIje/1yK?=
 =?us-ascii?Q?sG0IdcRk4XIC7c1aAULMqVuCAzNiIbrV6ogqK7R5+HyZ0WqxpP34KkVC6JdG?=
 =?us-ascii?Q?hg/2Gslm7giRe9YlPp7yHwee3/kXyh2PD+l7D9qGthBTRXc4YuO7DnnEO7o2?=
 =?us-ascii?Q?twtkNQUgEfd8L0WqIEzw+qpJA18qI6oU3BTFVC5KD0BOgwBc/IXqMoKYCwMc?=
 =?us-ascii?Q?rudjy/bd3W49m+snYOfFZmbp9jVRnAmgKMYKdXsL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14c18ea6-9b0e-4785-a9c1-08dbd0ff0ed0
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2023 23:56:48.8746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A/yPYC1Nau7pppwY00SUYU4plxB1T0sbZbd/HtTbwNfoAG0jMdCeiYv6sRuAtC89
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5222
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 19, 2023 at 10:55:57AM +0100, Joao Martins wrote:

> I added this below. It is relatively brief as I expect people to read what each
> of the API do. Unless I should be expanding in length here?
> 
> diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
> index ef8a1243eb57..43ed2f208503 100644
> --- a/include/uapi/linux/iommufd.h
> +++ b/include/uapi/linux/iommufd.h
> @@ -422,6 +422,12 @@ enum iommu_hw_info_type {
>  /**
>   * enum iommufd_hw_info_capabilities
>   * @IOMMU_CAP_DIRTY_TRACKING: IOMMU hardware support for dirty tracking
> + *                            If available, it means the following APIs
> + *                            are supported:
> + *
> + *                                   IOMMU_HWPT_GET_DIRTY_IOVA
> + *                                   IOMMU_HWPT_SET_DIRTY
> + *
>   */

That seems fine, thanks

Jason
