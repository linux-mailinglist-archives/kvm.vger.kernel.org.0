Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBA54C1A94
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 19:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243748AbiBWSDR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 13:03:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241883AbiBWSDP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 13:03:15 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2089.outbound.protection.outlook.com [40.107.93.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F99635856;
        Wed, 23 Feb 2022 10:02:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mgBxJl9dzMJ31aEfSGEwDTheZq3rQAolVybqMgptU/Yyhhou9V8w48t/3zTQZZjyMDmgHj+j1xenKaJpdCcXWPBEaRcsmdbRko9ogKw+f+FotEHc4W0lN1O+kdo2WABa2iqFZKbCbp5kGyabqrerHbBqZYeZGIcQPktfNDAlad/KgaqmPXLQacZEORNEH1H962Un9eyl8oVDQLeXytnSX1RIiEsucIaIPeeRQIW8YjBvlozn5ErCeC2uu/oFRe7UWJUPmGIQKQIMNcm6rfcK52sgobd9dOLG6vReWcVAg56vNwSAA4WaasAZ8VFy6jjBhwc3L338jaIPDmUrjttS9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3g4AM9cByxCJ17rp5AHZ6bmXXTAvtmB0GIGSMl95+0Y=;
 b=epo6bKqVgNqC4CYLZoUwo/75L7jCWGr6TjZeY+oq/PH+c63cxPpvL1Qymqx9Aaclle8brVlMaTtQwCeUhOmsGKb3q1nXzHt7/4gebLd0Y35FCjy3B+NdpSoGcurtQdvxDif7nM/DK8toJjdgEL5ya0XSFWbUteCRCx0JOLnsCbCQvXILsF4QfnWrZdih2oXFXGlDS9Zx3i+Bz1dalQuOcRTxbnI4Ez6FKL9IEDrWy8K06vtu+4feNOtKSW88vqnDayjZdo0F0ZsTJZYrALFYxJI64YPw5wOW+heJnzUPywpbxztf7/+MC6e3SYO/iB+xXVBJ3rDjnHb0Bi6SlHLhkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3g4AM9cByxCJ17rp5AHZ6bmXXTAvtmB0GIGSMl95+0Y=;
 b=Ul8TIca+IfabmX6S5VeLRtL4sMPWOZsu38z+zir55F2O5tMCZKX1bqeRWc3SB69jFmCaywHU0wEUUbtVfSW1+xmYubP7D6PObli830hJPB7hGhMykdUHyGECxNRL/LMVVoj1qabl06Ng9O/+dTQBuzqxJUYF4JK1EvMArIJXx/sO+tmG2BkEx5F2Vwa6Ft4q9uJgSOtuPEujVff34tXYrJvzzr6erS56vltYvGjYEYUWtmHh/nmDt9lgqzXhiY6UU3wPSLYDth2zgZGNz5T92TMKA7dYmWpJaEku29ovRE4l2l+HgfiClDfAPCUseXY5qdv/jHOfWjty4ga/Wconxw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SA0PR12MB4542.namprd12.prod.outlook.com (2603:10b6:806:73::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Wed, 23 Feb
 2022 18:02:45 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.5017.022; Wed, 23 Feb 2022
 18:02:45 +0000
Date:   Wed, 23 Feb 2022 14:02:44 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 01/11] iommu: Add dma ownership management interfaces
Message-ID: <20220223180244.GA390403@nvidia.com>
References: <20220218005521.172832-1-baolu.lu@linux.intel.com>
 <20220218005521.172832-2-baolu.lu@linux.intel.com>
 <f830c268-daca-8e8f-a429-0c80496a7273@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f830c268-daca-8e8f-a429-0c80496a7273@arm.com>
X-ClientProxiedBy: MN2PR04CA0028.namprd04.prod.outlook.com
 (2603:10b6:208:d4::41) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6c71bf6-ba50-4fcb-a11a-08d9f6f6b1aa
X-MS-TrafficTypeDiagnostic: SA0PR12MB4542:EE_
X-Microsoft-Antispam-PRVS: <SA0PR12MB4542FCBEB5EB3D661EB7FDBDC23C9@SA0PR12MB4542.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TdMa0cgVZF5kEoZ3d/gR+bVUN72Xe6yLAKXP6xE9g4BsixzakpecCA4AS7ANOibneiRl70e8CjQx8Zk8PtbslXYqSd1t99N90vMMHVP+X+40dmk5E+mSBMDc6gpdWyxrufwXQvx/RHqMiWg9XKSK5dc7dLu19SDJP+hEOA/4cqYq6IaXRKJQZtb7Ff+5y5JCTKetAUSG3ADsrznPoiSa1ecWhIo9nz3t0apd9Jf9ScbafUItRH5f9IEuUWMBIMflR4idyF+cs1thSDsQO7U7vsh1JMmeDs0YIoWhbflMrjzFW+LymtIrSBigNQmyYVYAkHfBxNjbG7dZYtTdTggvWyMKkkymJz49K2iQsI51nTW1hxr85WVD2HZialVzLzF+kgqZNsp2HlNjvGUXi3+HxJqCH6IrVHk3Ch7PGR7fSODTOJeaACKUmubeyEqICfL7g9dvtqleerURHh9qrJakrccNZDl/wLhhOPBqQvG2wz2eW4g0ovcjLkqOiMQ3Oy7wMSteXkU7nMgJLaAkAVdr0tB9EFu/oPR3+7PyoNVwveUU7YjkpC3i9oTY2ja+CDmGRAfsxsOpfvXGIDXlZpvSyuBxNEJXUt+42SqjWnf6IA08yhLsfvwLk2WWMe85zEf2QbuoHT65oNHnHq5CybURRIo2PnLVAtBrG9YF2yjriz5SO/I3vTPIP0Qpr3NnHBXE9rXzafvDgWQHA7E9HhKnTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(4744005)(4326008)(6506007)(6512007)(5660300002)(86362001)(36756003)(508600001)(2616005)(2906002)(186003)(8936002)(7416002)(26005)(1076003)(316002)(33656002)(54906003)(6916009)(8676002)(66476007)(66946007)(66556008)(38100700002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ai/v6zAHKGrVbPy6v876WjOX4aJ3IHK+p/E59I5x3Q+GR9k+sV1mQy2KRRJz?=
 =?us-ascii?Q?fUBaEgFWzYQF6W+FiZznx9kKCeYuzh10feH9aC1jmN4Xf+OSKyLbzGkXLQxX?=
 =?us-ascii?Q?LL3Kc5Bkk/lFc8pJNkkoPjX7gzx0CFNQzl4VOwSQbvwU53mN+7T/KQaTx9NN?=
 =?us-ascii?Q?/R2WjY7QigocTJtsIVSwPA/AVccxjXdp45KH5tHPIW30SGGfU+jUZrz95o9D?=
 =?us-ascii?Q?zelQ6cgHvxUZOwTkXKNgkpT7sPMd5yBdd6VFe/SeT26ofi0XfsYQQmZCtWsC?=
 =?us-ascii?Q?aljv8TWiC+uI9wkEJNGzObRjckZNhiSaMM8WHUItuY6UxmfWsZcHYIrAtyAo?=
 =?us-ascii?Q?YWUiaAQvrbJj7bCTDmriX5Gcewv0zAKwb5vL4z97YPPxBlNmeiFBgUVFyNyA?=
 =?us-ascii?Q?NThFP8FlayLIxVoUPYgbm26ovirQvAFAEcR3uQGQoVz6qx7Wxi0n9j/9Vd6l?=
 =?us-ascii?Q?li9O/efbM5/+bK3/Ec3DKxUe0mMDBL0u+VbinoYXbahJtXEmBiNtMPsGF3EH?=
 =?us-ascii?Q?8xGyAq7Jm89gxOsArFE/wesVY8GHcSYLZdv2O3+U4JxBq8mwyHmcjV3ElPJW?=
 =?us-ascii?Q?I2+4/zZaxUXvA6cDpy7yG+2Znb04855e4lIX/QqkEIEdaeTQOeOGe2GlvTc4?=
 =?us-ascii?Q?OS0YtUmtA7+GS9Vs7jRHV0QzU+qjqqOIv7HQRYL7gWx8I/OA+MZ4Qfrn6J0s?=
 =?us-ascii?Q?lp2uZl9gGMgXJXpk3c30OK5vX19MQeSqSqhHA1sDv0g08pNVcK7Q1Vuntusj?=
 =?us-ascii?Q?JzWeOpF2UkuGgSEsHnt8baxN6LQb7K4T9HPK+kXbR4AKF4tf0zTRkFJ9wHI6?=
 =?us-ascii?Q?IT9BPIrWMzieBYaTb5SfEPfLWegkf2N6UNhHNxwG+95PLYDtCqKZqMjR26vn?=
 =?us-ascii?Q?ENsp1A0KNkQvGPk+NAl/0M8saU1rDJ2kyFOZSLDQJrQUZQKA40RYGONW/JCu?=
 =?us-ascii?Q?RIQjiedBGwpsA/oMu/BrA3UZYNCceDuqfasRWo6swThbsLAJSEce1Tjk8Sap?=
 =?us-ascii?Q?IcoLi1lijXedsbMjt/1wYxBFrgUhAI6jlmCmWv0jdKDql90fUFnu7d4VZ7vl?=
 =?us-ascii?Q?UhvL9EhhLV4399zCGLJ2aYyeDcRubfLgVIBWC2uaQl+Dit5ocXyDl516+sPb?=
 =?us-ascii?Q?ts3GINieePYDwiAmId4Y9PvqO4zynTkMd9MHtXGGbSbcK23h0sLPT9mypi1D?=
 =?us-ascii?Q?fVMupUtfGZLeyXYRQNvBemm0pdGLTLvTwOvKF5gTBLdXL0q1MofScNuqDn1I?=
 =?us-ascii?Q?lwMTkdUeucbR07Wm3CcfqxjYfvEPpgruh84DQj9DMi2oMM5ct/sHXNEF7cjo?=
 =?us-ascii?Q?LgHUgQHAp4a1UFKYK2K5gOdyUSfqNQ8ZaD0TR0X87jOm7AU2zYPGo3D3/Was?=
 =?us-ascii?Q?TSLA8zftohHCkU7Y6NjtqsE1iwu7SX76iZISiVDfHNiIuhamT/RHd3G7CXxW?=
 =?us-ascii?Q?59WrQAiqnwO/bZkzxdF0rBIN3rn4SToErl5004ubV3fLfx7egptQFEn3U8PE?=
 =?us-ascii?Q?Pp8/QPvERC+KIF3IDO2kDGWHy53AxDrNtkPEQnPUCCvCXwl4Uu1XXtw52NZi?=
 =?us-ascii?Q?S9aVpTXcLDjspvIba4w=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6c71bf6-ba50-4fcb-a11a-08d9f6f6b1aa
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 18:02:45.4022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GQYeKOi99G7AzSQ0D7uJzrzv7yhdogu1acN7H4FUe2/U3G84c8NSp5r6XLUTbPtX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4542
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 23, 2022 at 06:00:06PM +0000, Robin Murphy wrote:

> ...and equivalently just set owner_cnt directly to 0 here. I don't see a
> realistic use-case for any driver to claim the same group more than once,
> and allowing it in the API just feels like opening up various potential
> corners for things to get out of sync.

I am Ok if we toss it out to get this merged, as there is no in-kernel
user right now.

Something will have to come back for iommufd, but we can look at what
is best suited then.

Thanks,
Jason
