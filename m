Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78D8C7C52CA
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 14:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234808AbjJKMAj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 08:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234835AbjJKMAb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 08:00:31 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2078.outbound.protection.outlook.com [40.107.223.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 093B7CF;
        Wed, 11 Oct 2023 05:00:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j7QydZPuxEAoTA96ixtbx2Vz8FBWj88f00kY6OYt+zPBbVCTxj+L67ZC55h7IN1TiGtd+bLy91LhNVKtih9GMkT9gFkXswvjVEzXuUHG+6XbOsw/RqoyP8IJW07uou1PprHjXDQUwyXDb/PQS7bTh3L/Q98vp3BW9oNi74ZehE2Zxld7Ee4Jx63Vzy7mybmuY0Bt7ErfZEwuCf+SW56EJmoIcv+T4WjVgh7RBd5wRnDc5JDskdjQFaoNsO7yXaQi8yXKwFEKiBQW2M8h/8MMjEh8R8vbb8z8TFO2MPyfbOLN/4yw5iDxUE9r/G5fouFUWsJ83SQzY7Gs3lmtsajPYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pPQO5x2FPxFurLunF5fiSa85nWKGQhtKZa0g9lYVrJo=;
 b=OMAv9Q9UQ6pfg64fCffYOc3eRjZFF0TuNOsHefkuDHMXrig09yr0pdKlDBSgT1t/lUX4zxnsFYvBMyljWAIf+p1NSeLdxdheJJI60yEPeMrEIgSno1KbLhO3H9jpORak+GBFJbjcGQR/iIOEKnJTgwVzHylzQcu3jfBGcqMdv6BEu/JnHYnz8t9YNzvyqSRZgBKePEngm7JIcVj0viqOFPt0Mz6cdzCt4YXwMllpMeEE19uA8m+2D/i+HjpLTUUUc0cdqLP8afOzNPPq5am5wanT+zCG7pdlSVe0Nls5jID+gbP7rxc+75BxfFApTH4BrWwKBzigBP5JZVHnk7ZN0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pPQO5x2FPxFurLunF5fiSa85nWKGQhtKZa0g9lYVrJo=;
 b=twvBm6Yx2NvnljWzjZanKjeZKWBKgyr5E4VzjDrdAL7dCxEovi703CQjMMMr7rbYnCIPM/L+TloUBpW8wjAQkYtIBmL7ETm7uwCDoyKbj/Zevnfswien9wUSMGIdfVT48InvFbFRKV+1iwlVJVjS4ri/a6sDKVvsQY2bpp/mwxCQ97n5Q5wrT/83ajiYWIq4DB0A6zp5/gUZ2+cIyUOUC0LA4VvlhQ2h4G/MSJIa9TD5bF/7CAcJ0PY+LoBzpvvRTmOoLdj6ILwQvnXXHZhvLtGJPV9D6KN0r24Dt2UQUWR1t1gSHMUXNRhgF3KE/pVVBzyTAlYnfSyIc35IfLwNsg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL1PR12MB5253.namprd12.prod.outlook.com (2603:10b6:208:30b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.43; Wed, 11 Oct
 2023 12:00:27 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6863.032; Wed, 11 Oct 2023
 12:00:27 +0000
Date:   Wed, 11 Oct 2023 09:00:26 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "ankita@nvidia.com" <ankita@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "aniketa@nvidia.com" <aniketa@nvidia.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "targupta@nvidia.com" <targupta@nvidia.com>,
        "vsethi@nvidia.com" <vsethi@nvidia.com>,
        "Currid, Andy" <acurrid@nvidia.com>,
        "apopple@nvidia.com" <apopple@nvidia.com>,
        "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
        "danw@nvidia.com" <danw@nvidia.com>,
        "anuaggarwal@nvidia.com" <anuaggarwal@nvidia.com>,
        "dnigam@nvidia.com" <dnigam@nvidia.com>,
        "udhoke@nvidia.com" <udhoke@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v11 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper
Message-ID: <20231011120026.GU3952@nvidia.com>
References: <20231007202254.30385-1-ankita@nvidia.com>
 <BN9PR11MB52762EE10CBBDF8AB98A53788CCDA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20231010113357.GG3952@nvidia.com>
 <BN9PR11MB5276ECF96BAC7F59C93B5E4A8CCCA@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276ECF96BAC7F59C93B5E4A8CCCA@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0232.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL1PR12MB5253:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f790291-4a47-486c-e5d8-08dbca51a89e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iBc3qOWWfqqmVivO8APKDGqTVOqtWxcNH6KQh/DfY5eTZDXq3sav37XIKyKNq4a6/svUEYuesEt9Fm28qqG4QOyKK1ZAzVLWZTuQnVIxbJC0Uuk/dKwaHj93krcTvvtn1wqxsmd9lWBuSJvzQXmC5nNLmIy8oZ78zuxAEow9jYWv3gJO69lVSb9nLR/h8vq/iehpBxAp6/fDjWC8Vj+wuhcvGf3euvBgUuq9oOc6BBlChYhQ9OXTbVbXZCvdNKMHyi7PCuWZuwDamnaKNA5khxKF5lpgKBsF7Vg/L1RJ6GZ2Yst7esX0ezNVnZAPz5NfLVDC5SEPpi8L8saeBY0YL+vNKASq6ems8L8V6Iudp/po4iPfQ1oLkBfWR4h2b7qWpmlbU5JQkqdKMiUXITnI6dO78KtQYfPbgzqlgqoMVCLHu02RVshKqNwHvuIA+afySDYtSWiMagnJSju4I3JzIxbQljMC+onEgbOC5XVqv1HYo3kyMx2bowshtL6U/4UQGgSTlRB+6ZFzk1Pm8A/odw+IQfb6AfwV+Z2Ew2FAkysJdIu7gPkUZrFDGaqUF5+N
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(396003)(376002)(346002)(366004)(230922051799003)(186009)(451199024)(1800799009)(64100799003)(26005)(478600001)(6486002)(86362001)(36756003)(6512007)(6506007)(33656002)(41300700001)(38100700002)(1076003)(5660300002)(66946007)(66556008)(66476007)(54906003)(6916009)(316002)(8676002)(8936002)(2906002)(4326008)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RmDtmNUqpyW0gqbl+rs902liNDV4+Z5F5QhblGxgC75GQs9GXANUinVki60Z?=
 =?us-ascii?Q?w7xgaHAaGjOJ5rVnIsKWkedth4UU5vWhFoQeqHFsZc4KrEepW+kxcet7mHOd?=
 =?us-ascii?Q?iOyGOobOyI8heCR+g60hN0/fUpAYSfit/dCLA4Yc5MPNFhpmJDUp1xCsf1d6?=
 =?us-ascii?Q?TEtEhbGa8XuupHSfyhxkCiT6o3Wo8v2+cU/CIKoW0UcDoAfmRDq+YJqY34Dx?=
 =?us-ascii?Q?badUfMKWV2wQO0lDjrYi5IguNgq/6NYDx/Pv9dQsWGi+WQEvMGPSrHLemn/9?=
 =?us-ascii?Q?wd2S/oev5UzzuUVQMc/C+gReE03/dIGuR2xylKvkWOSrmhc4mHpihGcqlTfF?=
 =?us-ascii?Q?tHDcNgdlZMlwbiA3ZsfFytSWtJP2mTKdw8of+5SY9ZYH1qS9jCGSpRvwu8pi?=
 =?us-ascii?Q?8bMB4Fd7bdMnaKbUeFqYBOCK4wRbM93XcIBE8YNpyQMre0eBU6HMLd8vZ3Vm?=
 =?us-ascii?Q?nIqQN9aesyLMDupbIFzd0ZbpofjSt7CejUt9OcpNu9MulTJNzcTw4LcbAkj3?=
 =?us-ascii?Q?w6FDSPHpXRarSsCobVa3VLvnunNqrmw8BskHQwlUSHjPQvdAA8aH4JRveBx3?=
 =?us-ascii?Q?m7WfqkvXzIkB/RcRpMgZVZAJZ//Ts5hxn806eiQ0cx+LX+FwxT3MCTF/NcAV?=
 =?us-ascii?Q?vyZfd+9vG6mCj3TKQQ9zA9iJXloHHI5/r6X7AuFseSoX57v5BtT61E0xFoNH?=
 =?us-ascii?Q?opSTSw1fKYyClT8KT7UFiFrUbLUxlEIUDtus3TGipRA1NkU5e4iYQkjN3ORt?=
 =?us-ascii?Q?qMttVeHYle3slrPhXtEBS6cx+uOQAQzOwSxE4LjJft627ReyYd4yM1HidHtV?=
 =?us-ascii?Q?lk6O8USJD9w09E9yESxhEzfsBtr9jF+rdHXEl1c8yaGYvAM20N9Muxpztxrt?=
 =?us-ascii?Q?q0aORChft6K1WPLVJn5xNcdYlPg5SPkezvWY1Mn7OhTxJrp0qA3LK6iUYP2I?=
 =?us-ascii?Q?ttK+S408dSkenTdhD2brdeuvp5g0lA1JorICYM5rm+bkF7NpCF+fIHA0Vg1G?=
 =?us-ascii?Q?9418MoBWPjRvaaRNVHBTaxddfZVg8w2lNGxpU3GGN3Bs+yG0t0mmZqNtBHTs?=
 =?us-ascii?Q?sQ68O7oNGIOadWkAuTeqZlrphsVj09Qlgewd1ClyYzM/uoWcy5hlKYKC7lkI?=
 =?us-ascii?Q?n+C3wTQ0UXP3wldG6+y0fX9p1nqvlYDqc9xIpiBFTelt1WJ3wgJs6BZf62vK?=
 =?us-ascii?Q?IdFRMcdYg5Ra1j409Fg1TZwsYJrAw2b7H+h2AN1tyIF1eejWCXzwSfdV/bYo?=
 =?us-ascii?Q?vj5cO0DSmNrROVCzLlMWgcMK2zkMuGZ6ZKXlQcH5QfmH6I9QIPROsVSXgrh+?=
 =?us-ascii?Q?eBgOR4lrJoLLeytMlrhKirQsVW6Mq4AZlcyA0TlBJwGwnBx8d9CRN5dOsbt2?=
 =?us-ascii?Q?xmPMCPzNCXsu69gbR9HhmhrrgWwbABB0xMkbVnviWSELCC6J1EhJOwv713XX?=
 =?us-ascii?Q?MKbuX3XGRc0oRwfA9hsImpcvCmaM3sErXAv9vsfYmXKp+QXsk72Lv+g5c3tm?=
 =?us-ascii?Q?gxLCJNNUO+IVagqzDzicRkOADdNkZK97CZ1ZnTyRGOAStJczHWjl4K1SXIkC?=
 =?us-ascii?Q?aJcrNBvXUwVQnK8Lq0ZuM5R9XnU/M74NliFOWVBY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f790291-4a47-486c-e5d8-08dbca51a89e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2023 12:00:27.5035
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HglA+x11zVZHJjYDT6EgeoPM01UbdYyp/+U3IIgkxVy8vxSRjBivGJL8vlmE0HVB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5253
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 11, 2023 at 02:00:30AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, October 10, 2023 7:34 PM
> > 
> > On Tue, Oct 10, 2023 at 08:42:13AM +0000, Tian, Kevin wrote:
> > > > From: ankita@nvidia.com <ankita@nvidia.com>
> > > > Sent: Sunday, October 8, 2023 4:23 AM
> > > >
> > > > PCI BAR are aligned to the power-of-2, but the actual memory on the
> > > > device may not. A read or write access to the physical address from the
> > > > last device PFN up to the next power-of-2 aligned physical address
> > > > results in reading ~0 and dropped writes.
> > > >
> > >
> > > my question to v10 was not answered. posted again:
> > 
> > The device FW knows and tells the VM.
> > 
> 
> This driver reads the size info from ACPI and records it as
> nvdev->memlength.

Yes, the ACPI tables have a copy of the size.

> But nvdev->memlength is not exposed to the userspace. How does the virtual
> FW acquires this knowledge and then report it to the VM?

It isn't virtual FW, I said device FW. The device itself knows how it
is configured and it can report details about the the memory
space. The VM just DMA's a RPC and asks it.

Jason
