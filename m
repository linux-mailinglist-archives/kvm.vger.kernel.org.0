Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA69701130
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 23:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234709AbjELV3y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 17:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjELV3w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 17:29:52 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2078.outbound.protection.outlook.com [40.107.244.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C264B30C3
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 14:29:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FzJb94zPHwlDKCS07PNfpnA7oGL/r04Ax4uCJchRdoI+Td7dS/xTqM6K60fuhwTeX4eSutbSZ/xQdJ5uwH994fy/3mzYr1vHZAk47z8Gqti8ZdnuL1NwlHofWKUY4n/17z9WjevC6s/402qfmmtRyVnW3vuimzHjLZmXIVAcel+4BPM1NrGu4lnY5rsUb51pGuOfRTHiKMGPZKYARbBdZhxRrfdzyFSiBOKC4DONRYiwMbhIOzmg4f856eHkYeJafUk65hxLcu34cR3GZqmIF25Qu+92+W4rZzuU4vqqNa22XxqAp76/SLXeOsB+jLz6B1zdcoDt2ZS6Er1oQxvoEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ye8pLgNUUktz3ZyHLSe0O1Rlq7rnbt/rGWq9f8Ppgxk=;
 b=DtEmsdxXrhuQWR4MkbjDtr/Uu1nk2EKkAmcmOgdcS309wysoHCdr0asmPQS+SpyjIcnjJJwYXiWrdmYjvwE/05dPzP6ZWwkGgIBFM5XB94+mGZKYGxf8soWIcv74zxKkc/nkZYBlRvRQUIsGPm63V65UR9gE+yBve7vUEugZdDXNaPbsyUsoiXo+QUl/lmD4ImYostxmDenif8BekhgpVPOnke7saP9532MA8MHeiQ0i0lznXcf8PksAiJXX2izvZJ2PDFqDARvgynfwI38gAn5r2F4UO7iWcBF4Jj6L2wY+2cnwhbr8i/Udj3mZWoQzDN9JtDlsPh8GcOsreCzaXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ye8pLgNUUktz3ZyHLSe0O1Rlq7rnbt/rGWq9f8Ppgxk=;
 b=jU4VhjFMuK0TBhQcVM04Lba+veizH84sKZXxCptqfsFy6pAGGQ9wfM1HCzmD+yP/oPTKkZfELCmUIKbN5w8jEHTrtpEfWMwFDoNdDGBAi30s3kPQRPG3Y9vvXWUbzMKubR3X9vLoO86wkg2wCjqTtTnhfK/sTZ94Qjtv8i8Sn6y2nPsojuLGASUnmYiukHSvEWWQeFD0La9+JpZw5tyMTjHshzhDb46hqgarfsL9wLBIiPjYVWm5WFO5aB+jn8PTWO1/eezPzL5DORkivE37X2vJ9EVIuGOTB1SEjvEzDxj75mtTJZ76eugpqf6+zQ0fQLit7NkPbJeoUsyIENl0Qw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH0PR12MB5268.namprd12.prod.outlook.com (2603:10b6:610:d3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.22; Fri, 12 May
 2023 21:29:44 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6387.021; Fri, 12 May 2023
 21:29:43 +0000
Date:   Fri, 12 May 2023 18:29:41 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Qian Cai <cai@lca.pw>, Eric Farman <farman@linux.ibm.com>,
        Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v2 3/3] vfio: Make the group FD disassociate from the
 iommu_group
Message-ID: <ZF6vxfU0Si6lBK9u@nvidia.com>
References: <0-v2-15417f29324e+1c-vfio_group_disassociate_jgg@nvidia.com>
 <3-v2-15417f29324e+1c-vfio_group_disassociate_jgg@nvidia.com>
 <20230511165342.6fd5b04e.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511165342.6fd5b04e.alex.williamson@redhat.com>
X-ClientProxiedBy: MW4PR03CA0125.namprd03.prod.outlook.com
 (2603:10b6:303:8c::10) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH0PR12MB5268:EE_
X-MS-Office365-Filtering-Correlation-Id: fa69aa4c-a851-45d9-4d57-08db5330008f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: soIz1M8emLZwDXUNscKq4YkraL0Ctz3vvryxk/BxXl2YsVTKV1ARh+vHGRKCZuWD950O8JMVY/1eB0r29XAuT2ngOMqsv+XjpnutIiIKFUzN7hy+BeeNsh4CyUihmyncJM15Y6waq7BSxn76g2gFy6JFBJ7CS+KUC7sGOL30jwUzcGUpn+XyBQrvXPnpf8fDjMqUmL+YmSWvSHds21d6OylR/8/rssOEMxQwahDGXjHJ3j+8EAGv27ZRa8KBGPbqGk0OGUzwUN/xwr3ZkiXxqIh9WmVcspclWJEkDFmKiTt1wf+0H2s5yts7E+Q0+rivRLNYpsJ8NNMVK/wY31ZwzAFixXXPMsvBXVfrHQk8n6iCTGXsSkmYb9pehNwTdj0vTgM0nBEvi04KClboEYP3iWINur7ccWRzu31kSfaxou5f1U61CNzzDzVtOWoC10J5QjMkWxvA8FeCoPvbn677TwthXFd56T69ry21ry6C66gQud/4Mt78h+n4fUNBsFvar4m76u/O5qOavAISLp8LXcWG0VZXOgCBRGUsnRWN5ZtstRTvscwLnxNjYGd3oKJE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(39860400002)(376002)(136003)(396003)(451199021)(8936002)(54906003)(478600001)(7416002)(5660300002)(8676002)(36756003)(86362001)(2906002)(66946007)(6916009)(66476007)(66556008)(4326008)(316002)(38100700002)(41300700001)(186003)(6486002)(6512007)(2616005)(6506007)(83380400001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tUNczosKFdwQMyNaeCTHcVqKh6/iOaoqvILINGlyxZopWQMYHvSIm4YLJZgj?=
 =?us-ascii?Q?P6TByR6a+mRLz80dawI+8gk/9UGKl/nGnatcnCx7np+//2LIYRSYcIjR+TH3?=
 =?us-ascii?Q?UAHTuAm3uHKvWst6rs/XbIBtp09SCOIo4k1YN3Q+C+SfLNNVzIynAeGyb6D6?=
 =?us-ascii?Q?oSddsFqW0rXgPIQUQW5mNGM6OGiXNetTkbK3zClehaVE+AsSpwsedk8ah/1K?=
 =?us-ascii?Q?9gFoA8mJTum4IVf+OPvKkldserVkVich1zdcU1H0KQbv9fNUiNkNvpjmq8wS?=
 =?us-ascii?Q?DxSyTS6W0vI085Yo3tULpwb2+0GHAL1YAn75iqedVnKQjq3G6kKiQmlQtiOo?=
 =?us-ascii?Q?yKMpf5rLW2IeFfi/T7cgluODy+5wHoZT2fYcnKI5nRU1/BHBo5vGTxY14RqT?=
 =?us-ascii?Q?1LO2zzKR8D4pPf/6cUKyFPVpG8Fgscp1fOncE9z1OnW6IS8UQMR3W4+yD1xH?=
 =?us-ascii?Q?WbiHyzv+G5N8HQERxzfVdSPIfRtivtH3Tg7TDmKkrAL7OXdHeLGj4f/chGL8?=
 =?us-ascii?Q?Rc7VFOryyXtfYI9wPvK56Za8VcCI2F19yd0P+SZF0JsGcRfF3VLNJ7541iUm?=
 =?us-ascii?Q?cK6YnQ3b49qU+7/AuKG2uQOlDTXGFPSA9flBgatgRAMWSR94LJlrPr+ty45+?=
 =?us-ascii?Q?9BYWf0ltefwMCtzVKTJCkCLdvjPM34bBSaoQCfD2uIGw7oR2w/Xd2ScbmqCl?=
 =?us-ascii?Q?xHVogj9YOMvgB9GjXzB6YlzOVMd/dpg9s4aF8D8lumgetUiZ1v0cbx/12WAN?=
 =?us-ascii?Q?irf1jIdnF1TcqvBf6UqubnAqfo86888oBCyYLLIswxsgsbAH6rRQFd/VmeFK?=
 =?us-ascii?Q?HX9gAr53xPV/cgjurnfotfj998+qo3QqwLPTwbpZzqwSHTMFHLGEU9WF6P3r?=
 =?us-ascii?Q?rL9T2duUQ/VeK8JTUPCVSS+aU/3/AmxVAvA+zOU692ka7L8eSqzrvkzz1NHd?=
 =?us-ascii?Q?drKa4TYKXCoyYk+YBSs4kpvvd8PyfghHvmfkrW100TDNRq/cu7VWERWBOjrz?=
 =?us-ascii?Q?vWP5dsNIRQnf63oHw7uHj234ydxJLJCuwtprgBEWtZTOpPVcPruSIiP8d5A7?=
 =?us-ascii?Q?s/FrKkDYLm2U1P6HtcqMD69cdQq5utZLiqCp+zOPJR4JrRlF+oIx3/dvoiqq?=
 =?us-ascii?Q?HZc/hbpbBU5yZSHS61lHJejIqNUqOgfYyGpDD3DEl9hSgWoa7egsgmS/jTBR?=
 =?us-ascii?Q?J5xjoJXLG7JhFivJwi+Z267eRiIxzBxwHljHFW0yoBhOGlgMQlUl7igNpSOC?=
 =?us-ascii?Q?HrDKhj8+gF5JN2VT90/Lig8xGyCkvmmFF40uWli3NreobyW22Sx/7NQllLXW?=
 =?us-ascii?Q?QlJ5QqXMUD6v1tCnJUOkbPwfU9xAzP7YV5q4mpIGbVyaMzVkA1gRvXRtNlpX?=
 =?us-ascii?Q?+JlLVmbLO8nkVUaQlz9HzhXCBpL6ZFK49QbqFbfvT0up78/50x8y7JKD65G5?=
 =?us-ascii?Q?djlVxvFQ/ceuOvU9KEeEJLq2HPEzZGAnEBzDcyLYY4ReMZlgnHJkA8PK2l4g?=
 =?us-ascii?Q?VgYGNi1YMEOJ24uveEDVFbw2xCkXI4aqoXP0cdrM2YuK3cCnMotRpGpQ+LFo?=
 =?us-ascii?Q?ZHj6wQsmOA4d9GXVYDY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa69aa4c-a851-45d9-4d57-08db5330008f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 21:29:43.7661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dWEZyk49SbSWgOXTxQHX0vk1uqIv9QMj4pu82PiNS/OuWf/ziwZYx/CQhvDb4YAF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5268
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

On Thu, May 11, 2023 at 04:53:42PM -0600, Alex Williamson wrote:
> On Fri,  7 Oct 2022 11:04:41 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > Allow the vfio_group struct to exist with a NULL iommu_group pointer. When
> > the pointer is NULL the vfio_group users promise not to touch the
> > iommu_group. This allows a driver to be hot unplugged while userspace is
> > keeping the group FD open.
> > 
> > Remove all the code waiting for the group FD to close.
> > 
> > This fixes a userspace regression where we learned that virtnodedevd
> > leaves a group FD open even though the /dev/ node for it has been deleted
> > and all the drivers for it unplugged.
> > 
> > Fixes: ca5f21b25749 ("vfio: Follow a strict lifetime for struct iommu_group")
> > Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> > Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
> > Tested-by: Eric Farman <farman@linux.ibm.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/vfio/vfio.h      |  1 -
> >  drivers/vfio/vfio_main.c | 67 ++++++++++++++++++++++++++--------------
> >  2 files changed, 44 insertions(+), 24 deletions(-)
> 
> I'm not sure we're out of the woods on this one.  QE found a regression
> when unbinding a device assigned to a QEMU VM resulting in errors from
> VFIO_UNMAP_DMA and VFIO_GROUP_UNSET_CONTAINER.
> 
> When finalizing the vfio object in QEMU, it will first release the
> device and close the device fd before iterating the container address
> space to do unmaps and finally unset the container for the group.
> 
> Meanwhile the vfio-pci remove callback is sitting in
> vfio_device_put_registration() waiting for the device completion.  Once
> that occurs, it enters vfio_device_remove_group() where this patch
> removed the open file barrier that we can't have and also detaches the
> group from the container, destroying the container.  The unmaps from
> userspace were always redundant at this point since removing the last
> device from a container removes the mappings and de-privileges the
> container, but unmaps of nonexistent mappings didn't fail, nor did the
> unset container operations.

So it did this threaded which is why it didn't hang before?

> None of these are hard failures for QEMU, the regression is that we're
> logging new errors due to unintended changes to the API.  Do we need to
> gut the container but still keep the group-container association?

If it isn't creating a functional problem can we approach the logging
by doing something in qemu? ie not doing the unmaps after it closed
all the device FDs?

Otherwise I'd suggest that the container should not be unmapped when
the last device is closed?

Or turning unmap to be a NOP on a container with no devices?

Jason
