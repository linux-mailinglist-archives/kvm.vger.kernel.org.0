Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3817D7384F2
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 15:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232535AbjFUN1h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 09:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjFUN1e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 09:27:34 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2083.outbound.protection.outlook.com [40.107.244.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A47A1191;
        Wed, 21 Jun 2023 06:27:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P2jrIh+biNWOEn1KKLrEf3EOn93JyAS+nGEsOWdgxrUCKs8rxOpBdP8LE4zf2LdyFjQ4dK2/4sZ/2xcPuAwnTEXg1/dMA+yjBodvHEx34PJPELCxMl7VAIrP1cRO6A0vbY4jgtpFnebrhBp5G6lo4DjN0GLO+mlHtpPCbn6wkoLD7pg6c2CUczyT94gAUi9byXWNlIHbt06MjkvIqYzrD1vvBkNLptfZQOQVeZW6z3QS1DTWtVS3NGlqr/WonsXFnxef0xWZ3dSzddgndc0PSiImuWz32ZB9SXRspU2Bo0WODaiKeQQrgggYaZoMd/mD987xJcV8NRxQY/zezduE0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vjL3vZzj4mgdljtPilx0yTHUVFs9mp7ChmXFJzOVAms=;
 b=ai74gNLRCCk90WLJsDmN+DA0FTo+krrvzYLTljdq6p9VQd5nzMYq8KvPqNK7NZjtWrKpk2fJrXFfFjkaXKoLo8vtdKQQ52YoEap1RbklpACyaK+aSrcPYZNxFdHb1zY3jXET9g25NjUodEZPaRom2xtgJJu6imr0megTm/cl+65IvJuJAhzC9HI1dR7RbuAAMS6j7Mm/37AIA8lv1hpNbkgqLRq+fHYkdYa8ZfZV71mZr1cd9R3zn3zC/QWOUEOfVvucaG08uGo892QStqaJWB1HYH2PNMKSTVibKzZIDfYygptZXslxarkQ7eth/EWdc+HwErREEajOrp5CcqJx9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vjL3vZzj4mgdljtPilx0yTHUVFs9mp7ChmXFJzOVAms=;
 b=hr/49rRSet7FbvepxY0TTGyKC/kknXLp1cRLUuU4tlezgumoMFwV1tDiB0tz0DNzIcpX7RYFVjVpTnbjRFXhZmgLjaFUtG5UBxzydSkno1QR4pAiFgxNvH5wuU7gnC6VzfKn5+YEvvUxMMr9Udsl5E8Deh8txmv6zAsBSZ0VZaBU3wRdRWmP8siwuDePlr4OLfcUNJjeHg35tMr7uApcTtXPeyl9Plple8psvwfZbBaKGrJQu+NZqawq0CryX8aiIcXAobzUEaR3LR3svj5mscXfRmFFaBfBTOf56e7JWI7Fs68SbBQW6y1FY66XhF92JZ9Z+KpuSFx7nhHJ01ks6w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN0PR12MB6031.namprd12.prod.outlook.com (2603:10b6:208:3cd::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Wed, 21 Jun
 2023 13:27:31 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6500.031; Wed, 21 Jun 2023
 13:27:31 +0000
Date:   Wed, 21 Jun 2023 10:27:28 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Brett Creeley <brett.creeley@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: Re: [PATCH v10 vfio 4/7] vfio/pds: Add VFIO live migration support
Message-ID: <ZJL6wHiXHc1eBj/R@nvidia.com>
References: <20230602220318.15323-1-brett.creeley@amd.com>
 <20230602220318.15323-5-brett.creeley@amd.com>
 <BN9PR11MB5276511543775B852AD1C5A88C58A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZJBONrx5LOgpTr1U@nvidia.com>
 <BN9PR11MB5276DD9E2B791EE2C06046348C5CA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZJGcCF2hBGERGUBZ@nvidia.com>
 <BN9PR11MB52763F3D4F18DAB867D146458C5DA@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52763F3D4F18DAB867D146458C5DA@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BYAPR01CA0021.prod.exchangelabs.com (2603:10b6:a02:80::34)
 To LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN0PR12MB6031:EE_
X-MS-Office365-Filtering-Correlation-Id: 07ce200a-352e-4eea-e00d-08db725b43fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nsdeVNuUD47LZYfuwDkRREIiwCVsMbPna5y2MvEGAlfjs2baYW1E8Xj7nF3XLlPEHJDqpnpPbO7SO8uRgtDrIFbX/WKipdVdxVfEqVz8S2n2loKaVihFHzBktIj8SDXXikHW/O6gX8MHvOG68wzlHNshiEZhIdU18fR2LYI7DQ6hLLmXlAzjPNL+7q8jkDPztL0XxgNIVi99fcb45vgtcw3BAEWKgGn2H6to2jYFQPO9D/yo0bDoNlo2h3sVlYVvBwITsEZnHrB+r2mcYUPJtHGvLUlTmgBsBXRx6LI3SMz8QzzuSGxv7nVUFiNuP5+kJ6JTp0b+qL0IwsCeBjbDBYtBkTUfM2P13TBHwZQzlIyrjVG27PvFodj/fJEyZVxEg4PDXPrsfiWlCRE/fO84qLSpNdeBr/2rcCk3r0xNNnOZjZgqG+rUoOWTjQM+hc4O8+OwXHtOY5k8cxFR8rpyU2YfOQFeXAS+lEyUFUlgFg3/V/qP2xId8iJMyB6Z+cMdquER9MnkYHs/ABdLW+1NMfNTwWA+KzYS2SkeGhTY4xNbM2eQjFVMO/z2Ifr5K95F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(366004)(346002)(396003)(376002)(451199021)(38100700002)(4744005)(2906002)(36756003)(86362001)(2616005)(6506007)(6512007)(26005)(186003)(6486002)(6666004)(54906003)(478600001)(66946007)(66556008)(66476007)(6916009)(316002)(8676002)(8936002)(5660300002)(41300700001)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i/s3MzxfZtYUeeAPgV7BcZPwkXGitgI7oxIXpK+RFX+zd83HLh9cKNJX+D5V?=
 =?us-ascii?Q?x9hx+Z4mHtE1UNY8BPD+jigQcXQ/rzOvi4vDhqrCzqXnjTJ63EufNSVWObTE?=
 =?us-ascii?Q?yftBPyBBej2lvJmgjAs1SO0j+Q1ZMj8LeLNeScwHWiqjL+lA33cJ6riS59Rt?=
 =?us-ascii?Q?BVRoZo7aan6+senmKOcr1+v5gvKnfNmWa08trVP/rEtwuS1jtrlyJTE2Q5d6?=
 =?us-ascii?Q?KsqjRlMcxAX96MX3NBf/PgLYFKqDcU8p9N7eHlviTGKsPFa8DUXj/lq1HZyi?=
 =?us-ascii?Q?FS+ml2uv+8XOxtsymUVKS+/uiYHym/pomr8tbmlmSbx7oLB185EntDLNSRoR?=
 =?us-ascii?Q?EZNNysV9A65JLVPxDkA50xNkS+htCyE2a4iCJnoO5KQxulki50GA8JJpkNWy?=
 =?us-ascii?Q?pbHRL7anJ18HuF8s3fId5ZqHF5FP8Rd0+Cdv6UXv58xbcKXf3DxTmCls1Ck2?=
 =?us-ascii?Q?fAvdkIFkaJcoGZHgY9PP1qI4Lz3wfYTPAqDjMzN8h7borG2Bh96n21jCRkPv?=
 =?us-ascii?Q?RBLXT0ClbqS5iWle4226ZZ6wEXQIIf0zHUPA8ULpEqZrTKgXId5zjGXjvX5X?=
 =?us-ascii?Q?8bPyQCMlohnA+NGZmjk+Q2jOvrxedJCJKIDhjUqK8Sdk2/14RoYqb6/vyM79?=
 =?us-ascii?Q?gVbO+aSE6E7Bb4yR35EzpOuFWYWcZMazT95meqyHsL/JKLA+Wr7X7iubAiWw?=
 =?us-ascii?Q?unw/3F0Oxgs8UNr5TtvMPBt4VTavolKo8XCdP0jVT2p/Xl4ZxaBJjFR/6DvF?=
 =?us-ascii?Q?l351kRJ5b1HJO15pokpqXb9YZc8UZ6w3X51Z2n/QPEH6dkF+lCgqpqNkxvlf?=
 =?us-ascii?Q?4ibacn0+RoOd8gfSdXCmR2RxTQ5TYKRlImllTM6Xvucgz42B6+NO4uJRq2As?=
 =?us-ascii?Q?qBBLP1z5Wi93M3xr3k/YrIho8fuxVbaZ01jNax1ZLAsPnkDJptorRfP0O3Tt?=
 =?us-ascii?Q?xZSuR4CDbWPUlHFvm4tg4cEXXP8SygawbGYJv6tC5jBYv/BKVHVPEvWuFRU7?=
 =?us-ascii?Q?IJwQFng3uZV4FZZra1JvgwskXfVyS6F+31+YiQWCZLHz5c/XET/GbmD7hgWY?=
 =?us-ascii?Q?NLV+zlDBvB8IHkDsjF2yF6+Hw5ydIkrBXNR0o+mbRLR9Pdu4v4KwYhu3cOfh?=
 =?us-ascii?Q?vNtowRxZFEHh4RDxVEDO/4GorUU3RNkdptzCSuTWVFzfvKOFCIWrst0sKg6j?=
 =?us-ascii?Q?K2FJ3GBYBnFTWbKj7vtpzyPrjH4f3hHOKQfLYzDCqmkNbWLV193vRsGGB2QZ?=
 =?us-ascii?Q?eHlEST2aqGMjPu20kvYFpJ4U6JVFv1Gxr4/ZjhHVzUwE7ab6M0nKVzxCIQEN?=
 =?us-ascii?Q?u+SsbST1Z2og9emmjb1IY8LgGqWVXiUSs1gtsRwxH9E14N0Pz/cTwgvUTm2Q?=
 =?us-ascii?Q?qHClXmzA23YW0uaK07qeA5I8mxDaAoyLfSLimwK/ngAfjUuoMRKbSS7OdbE7?=
 =?us-ascii?Q?1Taztpj2xUQ9SycWeYsN6HM3+JzECEY03V0fQiKmOcMg9Jz9tlsPBJ0Hai+9?=
 =?us-ascii?Q?GjOjD2uHsQNtaubY81s2+BvqOOjkUTH2DcP5dSUPbquyk5ET5Bva8lF6rIz8?=
 =?us-ascii?Q?61I3ww8mJsAfd5XCxjkFF+apBQf/E8vcBc9teFC+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07ce200a-352e-4eea-e00d-08db725b43fd
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2023 13:27:31.3596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9tnKT557Vd5517eqQSPC/F2/D99qhcGOQN+udRaEkaVA8FdQ/03skug/VAp+b+LQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6031
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

On Wed, Jun 21, 2023 at 06:49:12AM +0000, Tian, Kevin wrote:

> What is the criteria for 'reasonable'? How does CSPs judge that such
> device can guarantee a *reliable* reasonable window so live migration
> can be enabled in the production environment?

The CSP needs to work with the device vendor to understand how it fits
into their system, I don't see how we can externalize this kind of
detail in a general way.
 
> I'm afraid that we are hiding a non-deterministic factor in current protocol.

Yes

> But still I don't think it's a good situation where the user has ZERO
> knowledge about the non-negligible time in the stopping path...

In any sane device design this will be a small period of time. These
timeouts should be to protect against a device that has gone wild.

Jason
