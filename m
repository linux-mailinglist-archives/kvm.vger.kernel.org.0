Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6EA706B06
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 16:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbjEQO0B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 10:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjEQOZ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 10:25:59 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2043.outbound.protection.outlook.com [40.107.237.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259CC131;
        Wed, 17 May 2023 07:25:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AMSHJv2jYvo7rQjWBB9Ng8zQMZvaR/e6tP4pitmM19Dx6KeMU9yL3e3iMKxARoJEK/F5l/IcuR+YggqDLd0s30xktJIQ7j4qBUJDkJqabKWuqzOg+LmPeY3hNXBSykqKpMYE/lADP5yq1tqFUu5hZLClx4+VusgBRfvPOqYt+CCW7b1x70EudOWFkscXSiZyQ9hbLNb+2Cs5hoy0LzJdw61q8lMYrXF0doGyLoSJAKfu4ePXwt1cCi3eJlqvQ7ynPZdf1pGV0Gxk4QhP5CUWbvtigIHpiFnA+/ymUTlkuFECA7O4tQO2WvkzrB6ZLcv0n8Hmj/UVSXOR2JuW0yxG7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yh8tdUsHJFWhmuCkZ0Km+9N9qbLjAglqN+8cw4cW43U=;
 b=lpIKwsp6P2z9lr9qdPsDdj9wt4rtxABRu8lB+vCvaTg2CH98llRyH8y9poz9Px3vV7TCwK95HqWY2weNjUc3mN+s0QaNnfPzj4s6cmTUY4ldN0oUv5yr7fys6pZ/hVdERte6MenqaubKlceNnlWBXPbQsk7H8sP1DCTh0YoTS2f0sc0WLZfqkb26xM6ld946l3VfvlCGuNRK07BNTsnJyTYsQA2CHuJJ7mn6yBtWTJtDpRL62AR18u+VXFbpe93Bp+mblcIL5ap+NS45hkxvlAqqoTMj6xRzXQU0HL8cSlK5VlTqxN4kIj0P8enCL7afJjacQXUgPVHIBdqNAiHfhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yh8tdUsHJFWhmuCkZ0Km+9N9qbLjAglqN+8cw4cW43U=;
 b=lKJkBDSTVkA1aST8HRYS8rMSGrp2bMmEF91YLRJYGPR/IRaTrcscTxr4rF1jNhXSkzsIMwjRo9kUghSqvmG96s4Oc9EOHXuxG0b8ydKdJBrUC2R+ALmYJ9A9P9i+biAkZ3umhsxSTUJLyh0z96xqeoxBXP6pEzRpi1BofdrEv5iAXEs14vGeMbWDe8gomcHqdWaNHR+zbVFqEE05STZE44ocmdGngPo/XHOoXnah6TqPtMUWnz8yMzalHMnd9H74/I7oe5HvXWJPVK+fFvtdj0pdpU5pAWu7iy6OZ/V04DzPhr9H4vHlFMFUbCK67qj/pjoz6/kInsfKuzK6N2Z3ag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5056.namprd12.prod.outlook.com (2603:10b6:5:38b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Wed, 17 May
 2023 14:25:56 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6411.017; Wed, 17 May 2023
 14:25:56 +0000
Date:   Wed, 17 May 2023 11:25:54 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        kevin.tian@intel.com, alex.williamson@redhat.com,
        tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5 00/11] vfio/pci: Support dynamic allocation of MSI-X
 interrupts
Message-ID: <ZGTj8oD4VW15eo6K@nvidia.com>
References: <cover.1683740667.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1683740667.git.reinette.chatre@intel.com>
X-ClientProxiedBy: BL1PR13CA0280.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::15) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5056:EE_
X-MS-Office365-Filtering-Correlation-Id: 03f0a710-ca9c-40e0-183b-08db56e2a06f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zmJLVaW+c8XAT1LEcvquMeAQuvmyzEIxbDyMfVX2syZk6e1/hbV9z0bk9s4em8KD37LuFVHkqLzCkFURlrTkKFGTOlj4nZtWe0meb7S1NUiSTsUQOXtN4fMQ7urnA1qNDjnk0sYU7YR6FzDkNL8m+TWlwkA5gUgQhnGGn/niiIQEasQpOO9U8H54pMQfwQH13OfdWEzTeeVp38JMrWZjlyZ5E0nkEEJciuqtSef3xAGNyY7Qtb8kQZXNw/gfqrH3nP8qUUoYDAVxHua43rBck4C3O6En+UGk+vTpdgeIV3kJ7hbmRZYSHpeun9n2cW7XVlEiWNf4Zzl3Tk0uojYw5swDyBFvNwN6wsumfCFyjC5nrOq9U7ZR/eWm0RXUtK1cPP5fHSARboFp/IFCyovVzq3Kt2/0lnr47deRbiR/7N9nqACag4jMpyIVvkIpYp7UtnEpnlMahRdSvL2amAfTEJAoIyrYO67Y+xAp+wIJKGpIHLd4LyawN/RIH9ONTKkX1qKPqCKxAfyeIyAFdEUVZHUirN9JqrtJrJ0t57rwn/HUf3E3WUp8wotCxnFZu47N
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(346002)(39860400002)(396003)(136003)(451199021)(4326008)(478600001)(316002)(7416002)(8936002)(2906002)(6916009)(41300700001)(66476007)(66556008)(66946007)(8676002)(5660300002)(6486002)(6512007)(26005)(6506007)(186003)(83380400001)(36756003)(2616005)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lL5Dro+KxwBMpaDVgqARQZeNkenG4/uX4ALKv3wnsM6RXFu5lbNDkFdXp8Ig?=
 =?us-ascii?Q?Fmbs4bwmOq0hl4B9pM+fBC2hN233odd6QVS8Lv6xSpHL9IngeDpVme6uuhNn?=
 =?us-ascii?Q?UKlBKBpssKVsL9fsApf1u1qBk8+NC4I5/PqOvKs7esmpL1LyV346Uh2I2W12?=
 =?us-ascii?Q?dXJqjHfEkhrfIgfv5a56m2AP8PSQ6LNWj/CuaxjQ1F958y4+g2sMnmE6F3GG?=
 =?us-ascii?Q?e7p3dhxW5sxYbvyfJ38Gs2Jcpmq7P0oKK6dEOogILUQVn8H5KtfVcsaykDIR?=
 =?us-ascii?Q?Ln2FRcDEvQ9q6KDznmcstoNDDvqw6ameyzmIajRHZE0IXVSzwCxhe+5qmn4H?=
 =?us-ascii?Q?+soSy01tGeAOW5Ahraiw96/vHr8sa2UoeOsvZLzSGdO4/W2RhNi71Wq8sPPG?=
 =?us-ascii?Q?m8iI+aJYPSL0DRY/0vikPFT/BruesXKfoMkUs0FBieY89foR4+qnrXe5g0c3?=
 =?us-ascii?Q?7xUZijJor+G3vfQ0bDmg2WbOvxS+EYNxeggSL1Y3AOLMrc3EMVeTZ541wXNE?=
 =?us-ascii?Q?a+hHp0EedKsvFtgI4wBqh4kNBlTZIC6HOsDcvSjNsZASnlvtF50NUUNIhT+k?=
 =?us-ascii?Q?cLfrY1EDjKGusTx14bJsGYSsNeo+Swj9AQrkjkGC3bwazKhISIkYL01xdf2m?=
 =?us-ascii?Q?ispRNzLLI3wD2H0yGBAFbgEQAIBSsb8nIKxxr4PWUqs6sWlDDVJQX5hOF1oZ?=
 =?us-ascii?Q?SPtfe2DgcExbAziUQbN9f8w1XcjEwQvArMyKut0/VB4VyZepSJyr2FeFjzMy?=
 =?us-ascii?Q?dd7GanJBb3CZ3qWOIkRw7mqziUOF8go0raN8f1hMHyw+FOVHew97F44OIewJ?=
 =?us-ascii?Q?TtXhtROn+NTv6a22SOI2M7RzwWNr414/rTGlQ9DvU0IBrDL8HfE+q/1s02kj?=
 =?us-ascii?Q?6e71LbEecSyy4p3S9TQJs8OMWREay1quFMu5d06F6Jt8TOtJIe+VEQTesunx?=
 =?us-ascii?Q?zvzxXLZcirwjohXU1xMc0jwUeyUNCPUsyCtI5ubOKJ098r5cpZHd0ORUEXpW?=
 =?us-ascii?Q?hkDuSI+2gSe4KenVziNTKOCWTWezWKJF3soiEL25ZC+wygZXDD5ZggzCsH9P?=
 =?us-ascii?Q?tm1FJoG7gkTBS76U5XSUKCMYq7tmWfpGChoazUJuGiCFJg76za1w00TdtuLE?=
 =?us-ascii?Q?m9Uaq7TOXsucjZJ/BZozL9/HLe8LPvZa1wHiuH0OBU354ZBbUDK5U0z+pDMO?=
 =?us-ascii?Q?Fl5/GzgDuTe4X8kkPnWpxZ+s6tCCC9/5vvhR+Zm+VbVaFKzAUot1UleorV9M?=
 =?us-ascii?Q?ev/75MWoRan9zfmJp5wUdCtMFKwNkcBbolNGjtoUo5o8nB8o+usexq7Orau4?=
 =?us-ascii?Q?ctqKCzMlrM4pAVnx5uymAmJ6d3xJtKNtTTGksDSK06ozJmRXSF2ROTZ/UlCj?=
 =?us-ascii?Q?uUf8WdIfBJTpG8x8w3U7AV35t695C+GSVN1zihN5cgdd2ZLRPb6ZaLhDDE/7?=
 =?us-ascii?Q?V5qngvEUSt7hBMMfnmJ4ClHHXEvzsi1F6tDDPhRvqU3DxATLHU6bkKz9Z6gu?=
 =?us-ascii?Q?F1d/LhHWphR8O44YgA1Ncci+l/WydRMeZc9cwXvihLZcjhCSy6FZcev5UFy3?=
 =?us-ascii?Q?7oDIcTl73keHSLPw8ultr/gGypTMfds45J6j3Tv6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03f0a710-ca9c-40e0-183b-08db56e2a06f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 14:25:55.8567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IDg3gf2vngdcrOfswsCrgwPsRgawy/VQb9jXXAPLABTazJVXKWtoxDCOvAY0pYGw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5056
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

On Thu, May 11, 2023 at 08:44:27AM -0700, Reinette Chatre wrote:
> 
> Qemu allocates interrupts incrementally at the time the guest unmasks an
> interrupt, for example each time a Linux guest runs request_irq().
> 
> Dynamic allocation of MSI-X interrupts was not possible until v6.2 [1].
> This prompted Qemu to, when allocating a new interrupt, first release all
> previously allocated interrupts (including disable of MSI-X) followed
> by re-allocation of all interrupts that includes the new interrupt.
> Please see [2] for a detailed discussion about this issue.
> 
> Releasing and re-allocating interrupts may be acceptable if all
> interrupts are unmasked during device initialization. If unmasking of
> interrupts occur during runtime this may result in lost interrupts.
> For example, consider an accelerator device with multiple work queues,
> each work queue having a dedicated interrupt. A work queue can be
> enabled at any time with its associated interrupt unmasked while other
> work queues are already active. Having all interrupts released and MSI-X
> disabled to enable the new work queue will impact active work queues.
> 
> This series builds on the recent interrupt sub-system core changes
> that added support for dynamic MSI-X allocation after initial MSI-X
> enabling.
> 
> Add support for dynamic MSI-X allocation to vfio-pci. A flag
> indicating lack of support for dynamic allocation already exist:
> VFIO_IRQ_INFO_NORESIZE and has always been set for MSI and MSI-X. With
> support for dynamic MSI-X the flag is cleared for MSI-X when supported,
> enabling Qemu to modify its behavior.
> 
> Any feedback is appreciated

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
