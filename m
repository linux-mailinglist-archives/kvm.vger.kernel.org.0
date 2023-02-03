Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55A2668A351
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 20:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233096AbjBCT67 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 14:58:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbjBCT66 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 14:58:58 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2063.outbound.protection.outlook.com [40.107.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC48A7793
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 11:58:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S7q36ALImAvKXUspGth2YrkzQjdzy6IgJZ5dTNj8fmoYNh7buenP7amByekB+1HhjVHgZF8Lw88jHToAfmWh/MutPRMH3LiWSCYJEHeaiY54aiifA3AHz+ZdPbFsEf5HS6NZLTC0RacA2hCW+MYlc01ckPeZ9cFJWAyOn2J/HumqDPcypRxRFiNizRq4gBAuPrQRwPpD0UvAy9Q3Va7ns2J6iu6gN4YNcq/kZ1VlTRtAZ3N//DVZEZC8Gh4O7SQOMg/G5Q+au+fRYs7kjVpHIo3fzXxgqsOeLtvKNWZ6JNm2SE50ybQaNANcQWF30PP63xi1sykZSiig/BDv0YYbOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J5LLEnwlo1nGACEhHe9M9yhNmuJ4oW/no+6X7diQ8+Y=;
 b=WCn7+R2VXksIxjrmEHTxzTfP7q6Tk48I7dMWwpzwDxxijE7+V+lXYnhUkcHyiVRO/d5xAv7WpoIFwrs5/o8cyTIijqofl45GrxXeQaJ/2k3yBfC54C7FqYooLROH/y4285xMCOr2tlAu8UhE1S7DiUxDQH15wQ47f8DvPjAUF6v3WyPHE3sV490soflksTnUv+dY7/7Cn7l2lgwpJbhsmQhXxEtgDqhakM8jKunA8XDqs3oa0+b4/ViCwu8PxEpsVYkeDiuNMsINrNK7LBJ4ODSyJHiz7ec0cnwRNDTRSEW0rCpHP6tiTsYcVguH2fS1BsbuefmrD30Ssm3exZA3yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J5LLEnwlo1nGACEhHe9M9yhNmuJ4oW/no+6X7diQ8+Y=;
 b=OqqRYIoyZaPv5KLLy++wXY69FlZcN1mcc0WSWVFGNM/ngXkP1kwAiZ6475px3MZZ85z0MDLWFL30x812Psavw+tL0jqb7t49XRmvsnIbS5csKsdmWOcgA7c5xYBVFEEGZg+hm9sjzfh9XffFIImx9aA8eS2tkGXHOchUrJg6Pza/jkXZdKx144nYP0uDZwRNqRvk+VtjHUV4yVX1eRciDXtc6kl+ozDPYF0usLK4zGF7XyPL42/Ux8PIs9FaTPsVTg27iIV5VimOa5GTXXaJSGdaLrTUNGRk5lzGCntbi18LoumTcNj1joeE4hCYZKFyPMjg0qFMoH4kEx3mq/vq+g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB6554.namprd12.prod.outlook.com (2603:10b6:208:3a2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Fri, 3 Feb
 2023 19:58:54 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6064.031; Fri, 3 Feb 2023
 19:58:54 +0000
Date:   Fri, 3 Feb 2023 15:58:53 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v3] vfio: Support VFIO_NOIOMMU with iommufd
Message-ID: <Y91nfbTtnB7FTeHh@nvidia.com>
References: <0-v3-480cd64a16f7+1ad0-iommufd_noiommu_jgg@nvidia.com>
 <Y9gMZmvFDOW5LaWv@nvidia.com>
 <20230130122901.5baff572.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130122901.5baff572.alex.williamson@redhat.com>
X-ClientProxiedBy: BLAPR05CA0039.namprd05.prod.outlook.com
 (2603:10b6:208:335::20) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB6554:EE_
X-MS-Office365-Filtering-Correlation-Id: 0843bf6a-7a9f-4aa9-b1cf-08db062113c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aHAhCxCjD8JSDgb6NGYISkN3fHDlcOLMdLpCWMGuvAfVLKf4O5UY0lRJN4+qSIUw1XqmY69IOuL07Bxx/RY1+Zh/l1ZIizKP4mctdnD/+Q9jagqmy3wCAZaWk6ofJijd2lCUJT5Z9CoGSVlwS/WLHcx2LFdD5xcpyDrfyj+17uB/vAYfqsIWRkY27erHJ1ZoHFHYdcTUmapOf8FoX/PvJ59Qph0W2Bt3nRfl3r/QTMg7B6yai9LoTaxub9CQZl0mkTZqVY+yq/CgeG5Wht8Axr5XvZTovRLe0iI8TODiuCxfv1SI8zGKLydeW/YE7i9RynHkRP5+hkwz3Rb4LXVlYZo/elcrIJYdlVahxFRPH6iBshjGXPPgBtvMaEd59ijslNuCdFiV6tTnlx/TA+wu+kl70uhe1GNqNqMbzdAn1RkGSuSn8HliPnVMwTD6y92CsYQzM0sbtxIRhLejLkem0WNsT1aWMqszViLU5+CZHv3iqVBkVlNAy/y0toULaiJ3YVE1YeIGhab8AUeYLCkCyouKqhEh3sph+pDLB718/KxeUr0cK8oimnhJr6iV3z0z+wPfrdNbreVdHE9klN9Aes/9SvUL8PHxVuXtUG/FdwESbra29UB2oLep1Kzspc/9fdz6jNnpqmL0r6+w7+jJ5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(376002)(366004)(136003)(39860400002)(451199018)(478600001)(41300700001)(6486002)(8936002)(4326008)(6512007)(316002)(54906003)(36756003)(6506007)(26005)(186003)(8676002)(2616005)(66476007)(66556008)(6916009)(66946007)(38100700002)(5660300002)(86362001)(2906002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+TlsSgjHGCjkmqF5bQsjBi3HNLwXfXQngqeexz9r+e+ijmrzuFuf0mOL1A63?=
 =?us-ascii?Q?9Aj6yCF/iANySYjVJu/TzoxyMPRABgWl+Y0HesTUd1YgOLPX3XXpSPrJnu3+?=
 =?us-ascii?Q?hn9xKxyjJVbysDNTOgssCfgSesQ1Wg/XyiB+tVUFTcwGjz3fiOO87nXF+U3M?=
 =?us-ascii?Q?tqjL/V9KFz53TeEC08wv5SxxFTUPX2lG34iEf9tNZ+CvyzdBqyAtEyg1WCB6?=
 =?us-ascii?Q?JiMB3nZH818RMclkVg13BlIF6W6r/2hdEuHOUvmQdzBfw22qoN6qmVF2eACo?=
 =?us-ascii?Q?IWKNVgbow3zkGe+yU6Age2Rjq4PN7RbbeydtBfZvb/8oN+CzizYfp+U8LbZ2?=
 =?us-ascii?Q?4tm05jq+Xy4tP8ygnAFi7fFs4TZrJHBg9HD2UjF6FG4qhYRYiDqoktIWB+3a?=
 =?us-ascii?Q?rY+EX3DHrX0l75+RQbglNQ7kLbqlZJqhv5DwuR/vEubLCwXUhawdUx5fnnOD?=
 =?us-ascii?Q?8+HQ2imdFkpZdgljAoGsZ6h/WLM7KKv4dN83ChigfdQKjRul6w2qwI2BbSMD?=
 =?us-ascii?Q?7MUzo0MZ1jfafN2dHMbRUrnuWdpjl7juR/AuJlFZGRuBl+WWk+iKT4DQKF4L?=
 =?us-ascii?Q?jCI2lwPblLlixWDRtfIRzZwYQV5ID63ebzDDI+Fp86tFUS5H556nf35Efr0C?=
 =?us-ascii?Q?PsdvoXz/vPhrQ2MSpf2Oisr7gINtucaeA4Fk0OB4E5Y1r97utNg27Gjf7Nh4?=
 =?us-ascii?Q?o/xcELVnWpKoLADFLORoxcW98bCUbnVIxOzuytWQK8hf2gH73RQzRpBIqYpL?=
 =?us-ascii?Q?1nQTnBUxTeRT3eMYj5PnxQq/VIerZyyuoGtyu35uPfaqBCPy60i0x0iZgXrJ?=
 =?us-ascii?Q?lqwqeJF05g8YwN67t7Kx7atdiBtF/AsV4smwx2uYdITf/Fb/0V4mzrZSkPDg?=
 =?us-ascii?Q?AriJZoavPEAgrJkaUThoHE14pVE0u3oFFKARGJtz/CxeRQ+6r2ZQCXxWnwhj?=
 =?us-ascii?Q?Clx1OZ8vcrClNAM0ebyTb2JHW6jdEj1fw8+K9L5vewfcwdhHcKI+vwtQN086?=
 =?us-ascii?Q?vQS3ey1JGyrEfEH7x+TwuJpmZw1MLvDTNWwCHhjnnzfZiF8iJVsVvr8tz7Gx?=
 =?us-ascii?Q?9PzjuYy4mt6pSlulSyuZ8b14baDES9BZ3lDJG02W4raWZLAOXOBAmseRzTow?=
 =?us-ascii?Q?CyFKm94gL6t1cdUmgRPeONBwZNZFCyqd8gbXikuLAZG/VJi8INOV6+StM6ka?=
 =?us-ascii?Q?FaCaR7IfK9/Wa7MEuMq0g9uOv0k8wuvy9rpaYeK+j4tdS2xFtnEaG1YobwC/?=
 =?us-ascii?Q?1ZHiPsT/gjb7RJQoxdFUiSIIqv/6VeaHTRWUZZc8gaYFSpMb6SicNkLyEXAg?=
 =?us-ascii?Q?SAcGT/vztNEElYjaj5YNL41jRRciCPONuuqeyRdfRMugA7vztk/5fySrYE6v?=
 =?us-ascii?Q?gKCh2cN9j9PDM3J2HvUo9npjqpJPbZPf+BBE+Z84vjElFiM9K28uCykuXsaf?=
 =?us-ascii?Q?YvXH6XkPdOHqpy4jkx/CeOEGm5CZCsdKA6bQPBMoTIJVgfzVT0tlTpmWRDfh?=
 =?us-ascii?Q?OJleYI6HiIdnPPOAlWOnNR8slaq11NUkhnbc7M/hM8aQAYSMVqk/1Zrd1iuT?=
 =?us-ascii?Q?B6r5I9c3b283IRHTIEqfvX57aflwm0x70GMN6nUn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0843bf6a-7a9f-4aa9-b1cf-08db062113c7
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 19:58:54.0317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z6ybIeCQJ6kygrifRvcFW4Myc/LVBqPMftFh9DfJwVqNP9r/rHP2p6DkYlqJN4aN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6554
X-Spam-Status: No, score=-1.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,TRACKER_ID
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 30, 2023 at 12:29:01PM -0700, Alex Williamson wrote:

> > > Alex, if you are good with this can you ack it and I'll send you a PR. Yi will
> > > need to rebase his series on top of it.  
> > 
> > Alex are we OK?
> 
> Sure.
> 
> Acked-by: Alex Williamson <alex.williamson@redhat.com>
> 

Ok, I put it on a branch in the iommufd git

The cdev patches should be rebased on top, and if we get to merging
them this cycle you can pull it

Commit

c9a397cee9f5c93a7f48e18038b14057044db6ba

Thanks,
Jason
