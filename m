Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC0DC730663
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 19:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236057AbjFNRzi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 13:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234908AbjFNRze (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 13:55:34 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515DA2118;
        Wed, 14 Jun 2023 10:55:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OVTbA/Qtj9np/o0i9Hj+kLQJsS0L2qiqKGwo6tFq6gAEFEP44mFhTYg/NT/YHPgYCyTz9RV1YQt8A3Li1glgNSb0Ej6p3w8HhXDemANAd/6mUYek6i+wV1RB5+Q7R6aQ9lH4LPOc+bAYtRIdeZvwYzk15rOEMJllkraDUKS0wPyk1ljeeZE9FaIcRA64HpNQvYkaAggEXYTiqH8J5R81oXpRryThnTg9C6Tt0YMlAe2f2NZ+tlV1Xf4dX/WkCJ2op32DBQfhNBcLqjEe+BOt/zCenlgfTunEKqsnU5QMHGZc4Sd/jztcv9tk1kg7cvshEdG1NpCGM2MaOkE4mDlDSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z5B5/55sXuLbiVDrW0vS2YFxx2YaYaB0t7QHro5b+dk=;
 b=LMjSqX6xbulwsQkqStQxErRxCkVCKH0zMLdbNNszNdvJ+7roGbkacEkQpSa/5LhHbEVjO23gwqWRO2EQV2kI4iaECTI03PHwsKKTeCkGqq2FURkDg4aavv4hhNa3gOmnRHyPZhJfU8k6tqZ2O6JtnQbZzncBMYTuSiRfM3EKYiLo6YdzH2/kzGPFoWzcEjlAikcb5WpFeULcrlNcqaqaSm8BrKHfVD1LJ+Kvpe//P9uX8GtsRPUFoyZ8S92hK25jr5LCY2FlvMUbvYS/EBy70ztEr4hq2ILdl5vX7ln2X28fItTk0nKJYjspD7AOvFcWwiiz49UzM3LC6BtotOPcNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z5B5/55sXuLbiVDrW0vS2YFxx2YaYaB0t7QHro5b+dk=;
 b=gSI5KYwBu0mZsyF7QvzlY/fKdKI3ehmAZhKhSSGbwQ6WeJnLLBwpLXB2MWo8+06bVmxbAxcrV/IdPBuZDFrpKPu0NEq2XDFz33tUJC/knyoqI4W3Q13llpILdOWe/AoGSEGQ3qEZ64Lt0JBJwNmuchAGmAMOvy9iBsoTphmwdLqLJco0vN9Ewd3yUQ5qqx3K4+ZJZz98yx1KwWSUvLPehsTe6FmWMbrFdEyzDFMvffES7o0QxmJVyCwzc13QYNTg8w1w2kgKNPQYDYu2PIhazRrMxnZaCS8EJMahZ8yUNKm31BdtEDk+jNOyrjhjHpO2Q0N4izHUP+Z0pIMWZWe/lA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW6PR12MB8759.namprd12.prod.outlook.com (2603:10b6:303:243::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.39; Wed, 14 Jun
 2023 17:55:30 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6477.037; Wed, 14 Jun 2023
 17:55:30 +0000
Date:   Wed, 14 Jun 2023 14:55:28 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     ankita@nvidia.com, aniketa@nvidia.com, cjia@nvidia.com,
        kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
        acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
        danw@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Message-ID: <ZIn/EHnCg444LJ3i@nvidia.com>
References: <ZH9RfXhbuED2IUgJ@nvidia.com>
 <20230606110510.0f87952c.alex.williamson@redhat.com>
 <ZH9p+giEs6bCYfw8@nvidia.com>
 <20230606121348.670229ff.alex.williamson@redhat.com>
 <ZH+DdVIyZ6hHCDaK@nvidia.com>
 <20230606153057.4cbc36a0.alex.williamson@redhat.com>
 <ZH/LzyF/uttviRnQ@nvidia.com>
 <20230607122303.5d25c973.alex.williamson@redhat.com>
 <ZIh+wXFrls7StWzc@nvidia.com>
 <20230613132402.2765b6cb.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613132402.2765b6cb.alex.williamson@redhat.com>
X-ClientProxiedBy: CH2PR15CA0007.namprd15.prod.outlook.com
 (2603:10b6:610:51::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW6PR12MB8759:EE_
X-MS-Office365-Filtering-Correlation-Id: 0318705e-d9d6-49e5-03bc-08db6d008aca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /+uxCqWE6HCrOWLuQSx5O6t3Ojt0UYvtcQMJZ3KWx/HE6p0B/vSzkFGA22M5psvN9XiemNUIfvOveH1OyQepVil8Q1TyAzwuJtYYIFj9sqLk7C/q1/HYqd06byz+BxJPpq+dhrgRnfp9cFDJqSa6Pa6GRjq8hTrHWIDuo9MkLQjxPdw0LeL0RM08LU+0FeO1hFcM8ZRaqr+2IXgBB2DXw5/4qAKZD1XHHxZxX6yi9TGNynTF7A04qFlsKg3FIokP6ko4kzH5izv01eH5Iy4ZPZrfvXITjSn2LcK3M3e5iIk+fNMc7pvghCXVHqyywjJh7y97D2eJ35lfqIr5p6gThOZnImtKmesWdQuaE2IA0zjVwnGwhPvaTeX2ooJ8EDWbS59bU5jiDhsAsLlZy+Yy5O82VHWJ0C0qWW5yLTI2LbjmDWCu25t/WbKHUEyHjpFXIKFrC261vGXWtPRtLq51NLa6N4XhWuZYoTEaBG4WKz+NhTkMIlx/xIHvnBnhHiJYPzYGV4ck1gayvoPSJqyR9rCf+STQ1qcN6HqBe1425nR4MLNEuaTGBY3/RsbULztP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(39860400002)(346002)(396003)(366004)(451199021)(66556008)(66476007)(66946007)(8676002)(8936002)(36756003)(4326008)(6916009)(5660300002)(478600001)(6486002)(41300700001)(316002)(38100700002)(86362001)(6512007)(6506007)(186003)(83380400001)(26005)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1c8jgCOj2bNa4ATuAH3VJePKcBG8VyQrm5AGeN+lxWNKMQJ3886RtT0KG57l?=
 =?us-ascii?Q?jMABoajuV4DLbwKfiFDVm+0ReN7vxbPsmwJmFtBq6VM++5vsKrAWcHOXEbn4?=
 =?us-ascii?Q?x0Fpg7T92vTs6NR0GSlKdzqYZGQuYUg3E1TlwiQrRi8hGuX02KLOdppZeZaQ?=
 =?us-ascii?Q?1sRt+zj8ofYRa0DLCS1bUgpbEZ7HUP170U1O86GwYiZNudV49FLGK7jCf6d5?=
 =?us-ascii?Q?/HxYB/JhugfVnSExAgngAvp+BV051gArOqz1ciHo/5W6m795O6ndYhaM6q9Z?=
 =?us-ascii?Q?yF+wvJw7WDmXgtO0EM72CCBtilB8Ebs7+49y34vQPoc2O6Yr3tQOWFibH/18?=
 =?us-ascii?Q?YK1MMKnTDXocJPCH4Px7QnNbJD8f5pJXmEWlQywQSvgH1j9MpAPcO/axHfyN?=
 =?us-ascii?Q?gGFnmltsyOVSNTR0yACPygtTu6qxWaTZWufSe7RBmXodbY1OqowEUJqDfDKX?=
 =?us-ascii?Q?Zmef9B5nKgMSWIKHffzZAT8+XK62nLP9VDh5TXZDxxWK+ayWONe0MRyhZYh8?=
 =?us-ascii?Q?jYz7FcqyVrvBT9taupK2awE+YTOUxGXz+LVt+R09RAToeiP3iYYB2yrBTcj3?=
 =?us-ascii?Q?73kquo+3SUqmyksC4uuMg0pbC/7Er6ztORnZUbiB//YGroOyQBZlT7eUF7Po?=
 =?us-ascii?Q?GnzFeePKsRLw/EyxcO6JfBrA1n90/TaIALHwdYZTr6qXIa5H2hF3nfxy8+jK?=
 =?us-ascii?Q?8sc9WtjeZDeCp4hmig32H0pK2rYXbc3Gpwxe4WZP0Y7FYu17RFMNxc1g4FE5?=
 =?us-ascii?Q?8+VQhFqtlCAlpMzWJ+tODBhzkJSVa9zwImMpYbz7T38XMpUMJP37zbXCIAq3?=
 =?us-ascii?Q?gM62yBRR5gXJvXRf6yNK9SdSY+wM/MkIaficQqvFVAHzE6Z8wA2vL/ezZOhR?=
 =?us-ascii?Q?t6+I+hykWZaw0GqjHRvdFPqmDYv5lV2X+XoZt6G4y4U1WYIxaM4LMYx5oQ6k?=
 =?us-ascii?Q?JshvPoYxTPJnxUFjImXlo85OcHnwf89IbVz59hIBQOB3tr43yKfV+3mAxIeM?=
 =?us-ascii?Q?pEzSpFV9I/fv0VlBvbx2AIeCjKJGgDHtRB/Q8w5KorsEWnhcbeGMNd3llOlT?=
 =?us-ascii?Q?rry5epG5Vb9NUjcQUrSqGbQdFe61vAqVjXiXbXYkUwKxmIoiLaEaSSHzVySu?=
 =?us-ascii?Q?P7rIsoxovZeOp+Y8+zS6glaVY1atcH6EWvEf1m7q9wCBk4XcDFLwoaqzct1t?=
 =?us-ascii?Q?oA2ve4k33xWC0dSwKR8zhl0Om6rX4+ZHQ324+l1PyzaJIcQ/EhBwkfCBoz4c?=
 =?us-ascii?Q?lqur9TBfRdDtkr2fLkRazW3ny1cmyzIRdVbgv0YOSV5mlsOJ4EVEDdyXVTM+?=
 =?us-ascii?Q?Zog8uDoGX+lzHik/dAnHSUb4qhmE0cm066mHy4FpnL304g8lUcPIyPpHSv2h?=
 =?us-ascii?Q?O+OV++YE1uEhQ4wLHJ11s4BhwSFS5tdbc4NUy0QO6O1RSeibBBTLh5qGfQra?=
 =?us-ascii?Q?dkO0XCRPqh8K4ke621I7Lgr0pRsqt3FRjQUUqEJ+zA7yo/bcRMIZ60hvN9xU?=
 =?us-ascii?Q?zxhjc66qZ4cedPRnaIC2aa6fKp87LJgjijEKWbsW7OntYIlBNrniv58FhHcD?=
 =?us-ascii?Q?DFeffv0rR9EIbMz5VggDtCu5Xiz1kDE9+fbrnOYT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0318705e-d9d6-49e5-03bc-08db6d008aca
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 17:55:30.0852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I80cHue56gIszUCdJgytVhCYIyy1fzKejDsIeGHNRPdvd9KBa4zpvj/zXt8h4kwK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8759
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

On Tue, Jun 13, 2023 at 01:24:02PM -0600, Alex Williamson wrote:

> I'd even forgotten about the sparse mmap solution here, that's even
> better than trying to do something clever with the mmap.

Okay, Ankit please try this, it sounds good

> > You may be right, I think this patch is trying to make things
> > automatic for user, but a dedicated machine type might make more
> > sense.
> 
> Juan and I discussed this with Ankit last week, there are a lot of down
> sides with another machine type, but the automatic manipulation of the
> machine is still problematic.  Another option we have is to use QEMU
> command line options for each feature.  For example we already support
> NUMA VM configurations and loading command line ACPI tables, hopefully
> also associating devices to nodes.  Do we end up with just a
> configuration spec for the VM to satisfy the in-guest drivers?
> Potentially guest driver requirements may changes over time, so a hard
> coded recipe built-in to QEMU might not be the best solution anyway.

Let's have those discussions settle then, I know there are a few
different ideas here people are looking at.

> I think NVIDIA might have an interest in enabling Atomic Ops support in
> VMs as well, so please comment in the series thread if there are
> concerns here or if anyone can definitively says that another guest OS
> we might care about does cache root port capability bits.  Thanks,

I expect we do - I haven't heard of atomic ops specifically yet
though.

We just did a big exercise on relaxed ordering which is similarly
troubled.

Here we deciced to just not use the VM's config space at all. The
device itself knows if it can do relaxed ordering and it just reports
this directly to the driver.

In many ways I would prefer to do the same for atomic.. I haven't
checked fully but I think we do this anyhow as you can see mlx5 simply
tries to enable PCI atomics but doesn't appear to do anything with the
result of it. I expect the actual success/fail is looped back through
the device interface itself.

So, for mlx5, it probably already works in most real cases. Passing a
PF might not work I guess.

It is not a satisfying answer from a VMM design perspective..

Some qemu command line to say what root ports with what atomic caps to
create seems like a reasonable thing to do.

Jason
