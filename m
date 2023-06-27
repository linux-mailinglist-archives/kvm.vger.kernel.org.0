Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C48EE74000C
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 17:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbjF0Ptn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 11:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbjF0Ptl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 11:49:41 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2085.outbound.protection.outlook.com [40.107.220.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306012D4B;
        Tue, 27 Jun 2023 08:49:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IYsD0tM0P0qCxEKskC2741QqUPnyaBzyP5AnN1EcSWI/CwoB5n8V4mRCU4szrWmZg6YGMhvfn9hlm9BWiOcc69E9XgEruWxxFo1Ee1fujuZjTomu7Xu9nHpnUf3BI/oi7JBctMWdqHRQO6oi5IujD9byB/BryS0JJZSwAeKKLoJ19NVbJXDIFQt83cLOsLR3wM1QunuJ2AjIo3uhLRdUyaIFWuCXqk1ls72O2F64J+OjCYIYSDkbVzBb1GQvtJmsvIopl9VHfE7lkAsbiJG9qKgDcU1lEPXfhkUyXR9cDapPaeZS3kguLPGuOdlubQcEkkIAEb3cASTNcHQ21QQUBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eFKHonJCyPeEuRqZGzk9iDGgNr3nbwmdEiMyoQjWyBI=;
 b=nfRpI2Wk4mMpSR6NfV41IKQ1rebEpc+bhblo04u+2JxPiorW5UzJJCCRLDrz+w1uudeArz2zVguv8zI5t09iq87vrTnqpT5oKTWbNbebAZfhb4+hUdvyY5y94NtY1jTA5Ow4wrBAIXoOXVNQmzK2m2tXOFOCDbkPZ8Dehs03VAeq9/mHlssL2J15zNOcJYzM2ig27CPpNNUh3R1aAoU2/merQfeB4/lV92ntsM5snlhld7CAUL3BS8RWtzWOPhTNt2InutYsFrcirBola0ts/cIo7NB5dPDgCPwsy6LN9uZyT2qkRmdSJxlBOr5vSLlGDFW1RimDRTUa+XVR7gA7GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eFKHonJCyPeEuRqZGzk9iDGgNr3nbwmdEiMyoQjWyBI=;
 b=l9f3ZZETCls+oIF0u2kvB8FzT/HRzN3TOmvGl4Huccmq1B1x4Wgtg7M10GY+Pr1C/6BbNgTEUwr6K0b38s8uDbGSC5osCQp/khGOXlQoa4tXYgkUYECuxWMEXb/8+0QKRK84x95yQ18bAnA0HvQaLeIjr/vnn1K1E7+RL8d3J8/paG8+XK2VayDlQq6bbrL576UeY9131N7I8XusByOZTobKL0Ojg1qvCqwb13GVC/7S7dS28jSqAa/1RZ5GanHKSKtDmqRns6+GWJMNEevhD7leRni8XazbRc8uLS6eCPobP/RDbMLPbMTHmvTalZ2w7hZ82+KLH8sGINC4L8OHEg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA3PR12MB8812.namprd12.prod.outlook.com (2603:10b6:806:312::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Tue, 27 Jun
 2023 15:49:36 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6521.024; Tue, 27 Jun 2023
 15:49:36 +0000
Date:   Tue, 27 Jun 2023 12:49:34 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] iommu: Prevent RESV_DIRECT devices from blocking
 domains
Message-ID: <ZJsFDtU5Zao0iET4@nvidia.com>
References: <20230607035145.343698-1-baolu.lu@linux.intel.com>
 <20230607035145.343698-2-baolu.lu@linux.intel.com>
 <5d0d6665-93e4-f61f-d700-008c0fcb4a2f@arm.com>
 <ZJBbJHevOa8mAdll@nvidia.com>
 <0c1aec7a-8724-0f49-bccb-6025f5863bb7@arm.com>
 <ZJB0jyMQpZXWVANP@nvidia.com>
 <BN9PR11MB5276478406FDC2119A8EBD568C27A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276478406FDC2119A8EBD568C27A@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL0PR02CA0066.namprd02.prod.outlook.com
 (2603:10b6:207:3d::43) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA3PR12MB8812:EE_
X-MS-Office365-Filtering-Correlation-Id: 995837e1-7023-4b1e-aef1-08db77261b96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RPvfaDgYQDQp+hpSNLQIF2QpiCvI0dFjJpvWmekK+rs5jKwzwci6Cc1ieNrRiXCarV6vsmcps8aqfNXk7Y+NQCbLlHnAXrAedaBdbwN55/a3QCJWUmsMZ+OE2tAxbvWjLvUqXgmV+shQCrj3fnJ9AzhPCuog+DVWYoJPD0hqlLAF/6pvyCLJYLqXZ+QA7xpShR9MGPgJglSacgU6eyPdHb8QX3XpaeT6rGAK5S9eLqZDIEfJFkYkfFFeZ2r5snBg4hy8uiBlsdKGKI3p2ZP1F1Kdk4Tt3LCO1mgfr5HTL/pPwb8wyXAp6GlaOaHhbxW6m3DZJLPSIWqggwoDnDjMjMObI7N8+58MPC6zUbXKfae0diOoHgIX+NeLnmllDVlgJq6sjDRh63RQZ2BMcr9+bPkXj3z9hCDrXeNr4ofF1KbRv9um9BvSlEAxWM6c6AN3UP+gepUW6y+WwwMjM4K/rFI7Dejq6NjXPxzaN0ZcJBp8XInJvFTgcdhuu0ID5Xixj7weav4vQx0e3l8s1v2hwN28nLN3S8Bwx4GrBy0QBYI48ZKBjTRgROvh7rIvYJyo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(396003)(376002)(366004)(136003)(451199021)(66899021)(36756003)(38100700002)(5660300002)(41300700001)(66476007)(6916009)(8936002)(8676002)(316002)(66556008)(66946007)(4326008)(86362001)(478600001)(6486002)(186003)(6506007)(6512007)(26005)(2906002)(54906003)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UWQZN8rLT/JbN/JQQkpWVXdj2Ji5bViG4J/p+M5JefmM+4IKxdC7fu55Ujxj?=
 =?us-ascii?Q?oppmbQiqx77KoJwymPAvMcJp/eP21TqPnF2SQ2Qm5l1XZTbkhGgtWaiob3di?=
 =?us-ascii?Q?kZUbPHLcLS1XYEptun9EIlEnzNGi0ZDg+zPT7t23045ODqg5EXRu6h4/0PWo?=
 =?us-ascii?Q?3DIfXUF6Spwvjdkg8yF7F8qRkbBcTa7dkB4YdUHX76MDhNis6mm/SX9L9i+V?=
 =?us-ascii?Q?4uOINrCzu+5Jj1kM/MxeIEUkPmmyNHE84407tnfbyr2aFVPKVk9QCUvW6Cgd?=
 =?us-ascii?Q?MVZ4Rg06O6E79BAjxnnr3F5VWf/7Prj2HSk0GBhQw9JmOFu5/fUBaV4rOVJo?=
 =?us-ascii?Q?ex//PIlVJuZMOzgE9qaEpxgjXnorFJIhbJmk+DFeqvNulA/yZHTK3T3QnlX0?=
 =?us-ascii?Q?9mfJfxJoWHFoEOP4mcydUfda0tx6FjLKpUG8gsEvj9bOImzwO9CTB3+tYWVG?=
 =?us-ascii?Q?YZfecjG0lZjBA42V+CwBsNiDUdCyGtPrHBImCztUuFIGx653J0CDs4hdmj50?=
 =?us-ascii?Q?RiGNxzL9Sxuou5xLJnlZckkjgOCFAvDrZErjRr0slEJsv4b5TN503IN8M3jB?=
 =?us-ascii?Q?H626cKfTcZg6EEPN0k9gTF6SNuT+HbVGB25Z1kZUBdL2y4S3r36rTHnMdjla?=
 =?us-ascii?Q?qr42uimXCyKnd72tEY338yN7ujAII2F5kABvJ4pZrG+P/nHCu/MwhGh7PjDm?=
 =?us-ascii?Q?JoeSD96wUg5mtyUzNQSfJF9NBFTA7ghH2W7n8WxAEAdzi+akCGCadDdOOuYF?=
 =?us-ascii?Q?J3qlj+JHDi4GGo6uUSdMjcIhcschoyK3Zlaxy3QQUPMa3sgOLHgm6ROY477Z?=
 =?us-ascii?Q?sHJLWZ9U6JE5qQvMUgxNMBOaZ5SF9n/tUU/sXVqkWv533m2xnrvnQkDJnuNv?=
 =?us-ascii?Q?eTwsJDKh4ZlDfGrnFrPd/nVygNEy3e73v35sLdJaOg/BwZAsjTEW/zDMIGL3?=
 =?us-ascii?Q?0E1R4pJ78noBxVQnLOMo8PM8NMAUxYVNqhCZ8QzoB76mOhogEwxgkzMv+Zhe?=
 =?us-ascii?Q?ufWdvcIQ9MiJbF6oXbH4owLgs0zq2SRWGYzi4Cnt4nH0mXblbb8qd+tGujay?=
 =?us-ascii?Q?KeDTje6AUhdgDo0lZVvWun5eo3eOxxfCLoonXfA8veH+1/4cSy5EmNik6A3W?=
 =?us-ascii?Q?XaQBqIHQTPGoLbL2jxURMINhfllHGHHNdEhubi/2J1YZrXkqCWjSvh1X/DFs?=
 =?us-ascii?Q?76P13pGUw98Xccgx9dhWami7gxVaXWaayBZ5vLqxtpOlGdl2E6J4255Yvp/3?=
 =?us-ascii?Q?gsGy8HboSy0DtwIPpUfdMyJt8LIOpZSDs4QqYlgtMVTUpRmcXfEYpKFHzXie?=
 =?us-ascii?Q?70skli+d9A5j4eVVP+ylcU1qmSWGJZ1xrE9sSa6h2L0hdiAhePNRHkkBZTD0?=
 =?us-ascii?Q?kmocIlpxMWo+w+N/ChAI9y2Fv87xQBlAuDwo02Fo+rz3dz7rNF9zB2lGggLA?=
 =?us-ascii?Q?l+DFhnLTdTjJdP5IfNlOYgG3EwQ7DOXpenjYE/fl+nKPv8imQtj9NVgRV6M5?=
 =?us-ascii?Q?L9MCrgmQ+IF/bMARWedFc2J+W4RsLLIpClOf7m28CwuX5S5M7QGe9K9AMZpT?=
 =?us-ascii?Q?UFANr+bPeDd6Fvfvv6mlCxWyVHBcJrt5zJJY+v1O?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 995837e1-7023-4b1e-aef1-08db77261b96
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2023 15:49:35.9814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JhWg1aI51NH8+TleAkXTxq7YPY6XSZ08jOMv9gkADgRmRux/NduIx7yBP9isYWnN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8812
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

On Tue, Jun 27, 2023 at 08:10:48AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Monday, June 19, 2023 11:30 PM
> > 
> > On Mon, Jun 19, 2023 at 03:20:30PM +0100, Robin Murphy wrote:
> > 
> > > so if the only time they're used is when the IOMMU driver has
> > > already had a catastrophic internal failure such that we decide to
> > > declare the device toasted and deliberately put it into an unusable
> > > state, blocking its reserved regions doesn't seem like a big deal.
> > 
> > I think we should discuss then when we get to actually implementing
> > the error recovery flow we want. I do like blocking in general for the
> > reasons you give, and that was my first plan.. But if the BIOS will
> > crash or something if we don't do the reserved region maps that isn't
> > so good either. IDK would like to hear from the people using this BIOS
> > feature.
> > 
> 
> The only devices with RMRR which I'm aware of on Intel platforms are
> GPU and USB. However they are all RESV_DIRECT_RELAXABLE type.
> 
> Here is one reference from the Xen hypervisor. It has a concept called
> quarantine domain (similar to blocking domain) when a device is
> de-assigned w/o an owner. The quarantine domain has no mappings
> except the ones identity-mapped for RMRR types. I'm not sure whether
> they observed real examples of RMRR devices which are not GPU/USB.

I guess, it seems a bit hard core, but we could spend the cost to
build such a domain during probe..

At least for our cases we already do expect that DMA is halted before
we start messing with the domains so identity may not be the same
issue as with Xen..

Jason
