Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36F344DA18F
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 18:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350721AbiCORv4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 13:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350662AbiCORvz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 13:51:55 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2071.outbound.protection.outlook.com [40.107.100.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF6A951301;
        Tue, 15 Mar 2022 10:50:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HvlM0YznE+rn/48vCygGw0UbF/27z2m+4J7mLH2qFL74QZMyuqjV9lQQLd9LF03CHSTkYMxaW+82euVwjsB6v9IkeCoMbR/JBmcDR5pu6lonuYLkWgZceW5vIN9QBGXcmod1W46/bZErI3oT9Xnm40w6EE4nvYU2y+Qo4c2lgotDurUhfpmuEmkOdwk1R+UR6vgr/v3dXfF2/i4VGWPVEDq7jwzIxSZ0cPmDF9+s+rSc5/SZlKvthWVEFC0OAlL3FDTfCEtIM7CuziT8c5kaVhBdWpISuF/GfJ8uLnDMJltfgTO0mT2Tmx/leKBrnFJ9yhWFNfjdXWHBxzc/vlyRTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5P1CYAqFz3lTC02e6frW2CdE9hLxqE/RH5gebK8exyc=;
 b=ZyfqPOUX+1Rrruau7GwnLz5WTxXbNmHHYtsAf70u8a9Gh9F41nFuHnOXLTH5NQi4n/eMN5/Gio1DAs+v1/fXIeHYZBloO3gkRInq6ByYWWdEh0fe89YXmr/otoxcBEPvOy97rr8Hu62ITm9p04OM2chDBVPFQBhsNmHIuDA9JH9R6R4tcr6z6436eM3He2j/pFZM7OGUQPmcg4yubom8ybn1nYiD+tWGoNkcMQ/5Yd00cUuonWflDQJgldqxp+RL9Umw4xjl5SB4x6IX7+/XIaJrkG9p3Ckict651xJSjbE5I0tU4OjW4eAUNl4HEUjxcAP+AOgKsZEhn82iUewVUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5P1CYAqFz3lTC02e6frW2CdE9hLxqE/RH5gebK8exyc=;
 b=AtYQ9newn5ke0qVH2J4TQY0gz7tpzfG7dII9Xb0a7EtauCLu6eR0o2bz0INjYavfL211njbXXBTxW6icdJ0Aijo0ebbJd5h1gEHNK/s57uTXIGBzPJ/jm9/2TpDIhQL+6VJU6hXY+PSu8FFDSpCJmawpKZ+m/NPML43O96c2WlhuwSLaNUTRb5BsZm4Flf4eX4KMqTC9aUhlDcS/y300vmgmDR9+yoj6xqgYBpBQP+Znnrin/jrv1bkSOK9AGjgL2b/TP9J+uC7kKJWHrwOSZcuplfDimOCZADc8PqcZwTf72EIkRoETJQ4kPtNAPpugHUJe6gksONOWcMjCuGxtxw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB3660.namprd12.prod.outlook.com (2603:10b6:5:1c3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Tue, 15 Mar
 2022 17:50:40 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28%4]) with mapi id 15.20.5061.029; Tue, 15 Mar 2022
 17:50:40 +0000
Date:   Tue, 15 Mar 2022 14:50:39 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        yishaih@nvidia.com, linux-doc@vger.kernel.org, corbet@lwn.net,
        hch@infradead.org
Subject: Re: [PATCH v4] vfio-pci: Provide reviewers and acceptance criteria
 for variant drivers
Message-ID: <20220315175039.GL11336@nvidia.com>
References: <164736509088.181560.2887686123582116702.stgit@omen>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164736509088.181560.2887686123582116702.stgit@omen>
X-ClientProxiedBy: MN2PR19CA0004.namprd19.prod.outlook.com
 (2603:10b6:208:178::17) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f9378c3-6e40-4455-3042-08da06ac51dd
X-MS-TrafficTypeDiagnostic: DM6PR12MB3660:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB366021C59E615A169DD3AC35C2109@DM6PR12MB3660.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zrXadGddDrQU7kI7Ws11FTYmFoU9ke5hSJkNd51DCytthEweK7PLrVPQUwtxwcbHNZMqd6vU5UnM1mrFEXszh6TQim6o5dpcIVf4S2Jr7mPgE1IFFkPajzwfs4GqXUAkU1xeMZs2LztFXLMjePLPO5RbPL0NRpPk1DJ0aT+V76ocBA0l5xc1xiqxWWJYTU+aAO4wuv50oFkMXUHSY/x0vgXAccwZITrq/dEndbxxETOHvDlu7d0R0y9A8VBHrBy4AqLWLVTdU7Trh8Q8wb7ePSMo32RmHbxWNXkMXmjfT02UVbRSqNwqv/fHPbl/vtrOboZYWHZPjZF3Oq/NsSnBCnhMV6AabOjEl/lqEfK79MDhBloVokk+sfqeDJVlBJOm/PonDFoZl94PJN5VHxyFVOi+N4P1i72v7FZ+Yc/uASh+Z4G0nGOtNy4cNR2Gb2TR6IWiXjOVVyJtCCvl2Rh5zSfQxiXzUAVXV41lmdt/mQVU5upDvapBGXlBxTSNo1nZaDb6iXRQKzpH76GHTk+KeK81XHrjrDDty+7hwUzqmUO361s+//9CgWtUAhdXYHO7SXQyDAEcbfcgTs0dp67JuV3FdW8MI9boyQwaqcp4yQ13k7x8CcHdIa7o0fPqTcR8RZoVYlcN49LCOBRlWY30pA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(316002)(33656002)(6916009)(6512007)(83380400001)(1076003)(2616005)(186003)(26005)(38100700002)(86362001)(5660300002)(508600001)(8676002)(4326008)(66556008)(66946007)(66476007)(8936002)(36756003)(6506007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?agPS09rsJ4YQFJEpOQic7O0SXZHgI3Gd4s46JU5qIs0CnjEi3SD1zBK6ppF3?=
 =?us-ascii?Q?D/DdYpLvGfYrhZH2MGOjhzR1eCXJdg1mI2ZtXMI0xPhwn4NW99/dAuptsnry?=
 =?us-ascii?Q?mD+yvxjbFS3TtJtRNan59FwTIA/NG91DkPFXownMoojwzBeBLHq8fl3dqIhR?=
 =?us-ascii?Q?Mmg6p0qnemwOEUfa+XsqnAGxlJxMfqaK7J6qui9+BqEbkZn4xAzB6sRAZ3d3?=
 =?us-ascii?Q?cNOQIdw9ZHelByPh83+kUPGA0gcYXVwdOkb1/97zqYOmGGSj2Jh6qZqd11mv?=
 =?us-ascii?Q?lcu7O/QudKeRPoi64zNk7MCf9g/pflsP3T+rMrulUIvWiq3Vg5EALAywDidK?=
 =?us-ascii?Q?Bmv7ogS6s4dXZItWf84FVIa/ZhUcUq1iYVwaFP0QDvYyNFi8QozZkP/gpnPU?=
 =?us-ascii?Q?gts8d09Nm5aU9rjLxmaBsh1q7y5szpQGHl5kEPoniP9M45RJLZdswxUDmIW5?=
 =?us-ascii?Q?r01oKQjMAhtC3CfQnSg62wcPnFxRTNPEE8XcT/iBgBA5q5VJfiwFU5v+uLO3?=
 =?us-ascii?Q?Uf92o9Wn4DWCh+hQx4AqlUQ6MqkLyJPsQJqpCqGGC1oHUvsgypCS+/5pCBjx?=
 =?us-ascii?Q?qYxYQ+4wZXGvn+KfbNt0g75pBCvVuGrS3jzxQ2oEQ38ssKbrb5volQH+qMy3?=
 =?us-ascii?Q?nL03cmSjJPUWIfqzLbV8/9ikUek3EK377fL3vcYvLLZx0uCkbU1Nti8WM7on?=
 =?us-ascii?Q?Eyap+Hd0sxPnB5heksCNRe6maTAtCktsBPYOjoeksmtcFvCm6oeh1LnHVCzQ?=
 =?us-ascii?Q?bC+pAR4uArLHFjcP9oSuGPofIryTcQv1JCXcIJyUT3Y9C0oHll8H1cRvo3lC?=
 =?us-ascii?Q?woT4I8It/aRcGOOoDGWKGGtALDlXHXYBexZxpsB1A0rT+kv0bjlnCRGAmI+9?=
 =?us-ascii?Q?TwK27FwSCpy8k0TVn6CYyzJj0eR/hDkGg0LjHntOCAIPUeDpf3b/60mUwDVt?=
 =?us-ascii?Q?ZPPhXPxuN8ix4TGrf934zcD1XAwyFTCSZi8xmivfimYRourzc3EBtPsmuva9?=
 =?us-ascii?Q?+7FxZGemlumf2WUi8HuWGbjy/fSwft/l9JSzpFKeC3uTkjbfVx/9GooFT3Fi?=
 =?us-ascii?Q?jqRLuGduocIy4WGRlkn/uWqLSQnjR55IycvlVvMTt7q4Y+p3135OY4EHQeSs?=
 =?us-ascii?Q?XU+VqUS//V19MyDnfh2oIDs6GxOKPczrQz9GSfZMzdT0zd+Dc+1cgzdDd7mG?=
 =?us-ascii?Q?HjrjtcFdG2xKiYV1cFvElxZsJbrcHpwL2AvOLnvmuxJhOJA67Rm1KuNI3Cxi?=
 =?us-ascii?Q?cRfaUBXHHHN/Kw4o8k0syQO0HNWfGu4POFe/4h8lvjjenwWPeA6PWNcRG0oz?=
 =?us-ascii?Q?dkFn3AWmvcLGMaLcJ9uI9QmTkJzEp7bUVqIjXwkWZfSownYfYh6PdBiZUAhY?=
 =?us-ascii?Q?6e/0csyhVqHGyA940CE+IYcdMVO5mcsG8LWLx3zSAy+RvRMnd12HM2Sagjbw?=
 =?us-ascii?Q?ogdv89xySatYv31YbuOv/dhMxJFMXamm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f9378c3-6e40-4455-3042-08da06ac51dd
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 17:50:40.6764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ro9aML2eNCcNTMbo4cqQVBwq/3t1xDKplh/NhnAk6hNdTTAEYLoSxbCQZuaZkFG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3660
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 15, 2022 at 11:29:57AM -0600, Alex Williamson wrote:
> Device specific extensions for devices exposed to userspace through
> the vfio-pci-core library open both new functionality and new risks.
> Here we attempt to provided formalized requirements and expectations
> to ensure that future drivers both collaborate in their interaction
> with existing host drivers, as well as receive additional reviews
> from community members with experience in this area.
> 
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Acked-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
> Acked-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> 
> v4:
> 
> Banish the word "vendor", replace with "device specific"
> Minor wording changes in docs file
> Add sign-offs from Kevin and Yishai
> 
> I'll drop Jason from reviewers if there's no positive approval
> after this round.

Sorry, you are looking for this?

Acked-by: Jason Gunthorpe <jgg@nvidia.com>

Thanks,
Jason
