Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E358F73E073
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 15:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjFZNUr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 09:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbjFZNUp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 09:20:45 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2054.outbound.protection.outlook.com [40.107.93.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341F510D;
        Mon, 26 Jun 2023 06:20:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AG3pSyXHn+lYm0HRi7F+JkDBTG0UCE5I3lCIBxNPxvegSShnoDl4PW+vvQc2RfVLBsVP6xXPK+/dxUv0WaO+4POqTV9814r4HVZGcle8v5v/khOHnDcqP9VPGO/P9gICxuq9tN28LhMeo2M05qw8o3ROdno3uxt9c1ktLB81FNq1D1THfEp7O/o06NwVcTPROl29Lqv3VU3YHkIbvv67KqxZxVm8yJk3HnJYMuC/Dt6e348YpnOt6RFyiLx0SthW2d1BbYUrfhfTKdnPSL8jcu0/3wDfHJZyZibSqO5Oz1bJNtgDN0WlxnDwcV7CMLw9DNryXrdBY4cCKFUvTPdAzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rsh4oaAkbBtckLdvpMJaEk4uK1oXGGAmXvPgxsS2R28=;
 b=UsQdS7h1TOJok7mSpWoo5Lf3yjg09Z3EyAya0QhLXdakopnFBjEjgymXe7cjQ7tpq0tJdgpYSqdeMzJ0nHzMhQYjj+xDGBIGLlFMfwIh+EAAGNFjeNZX5k+cppOF1mLMh6b3DDk8aUrqdJcAyjxF2h10I4thdz2KUMrak/xIn2lHJ33+Qax32daQ5sG9u7RMcDyM2lqsaxwKqShxCcfmCLo3SPXN8uucgVsaClMzy02Kr56EPj4MULGWTtVO6Ppo98OZgvptXHIuDJ0xekW43emEZf/cq4u4mw8AEym9O6E1hxW2QCRG2yeJG2vhuNbSgu3EuTr78UFOeInxovF8RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rsh4oaAkbBtckLdvpMJaEk4uK1oXGGAmXvPgxsS2R28=;
 b=LljlQkODrO9l6Uwb8K5QmT8c1COTbVCqiJSzvhyhamyw+vjlKeZGrAzOLE4bwf4L9LRWwtaLqIMM3BOMFT3V8tsJoqtmBo0XVkFaPyKcPlpE/LD0ncW+fn0Ud7LWHdza94lKQhgvfQF1Nxrp0X8ISuS9mlkOq2wUUyQ7+L/7PY3leMA8YX1gWlW70W0PRX+WTXcsysQUgWkrRY2J3n+7rHlttMRULx4GgiO3YAcGobOSxH0rJPsl/uQTwAlpcry38M53qFNySmgL7DOtNAzx/o71ax/iHC1I3s2C5UMNADIdndxmXhLbNjS9JzJ6PAD6fwljGpkEQp/2Px4Lu7v9Jg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA3PR12MB9091.namprd12.prod.outlook.com (2603:10b6:806:395::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Mon, 26 Jun
 2023 13:20:42 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6521.024; Mon, 26 Jun 2023
 13:20:42 +0000
Date:   Mon, 26 Jun 2023 10:20:40 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
Cc:     linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
        kvm@vger.kernel.org, joro@8bytes.org, robin.murphy@arm.com,
        yi.l.liu@intel.com, alex.williamson@redhat.com,
        nicolinc@nvidia.com, baolu.lu@linux.intel.com,
        eric.auger@redhat.com, pandoh@google.com, kumaranand@google.com,
        jon.grimm@amd.com, santosh.shukla@amd.com, vasant.hegde@amd.com,
        jay.chen@amd.com, joseph.chung@amd.com
Subject: Re: [RFC PATCH 00/21] iommu/amd: Introduce support for HW
 accelerated vIOMMU w/ nested page table
Message-ID: <ZJmQqLd5MVZpobrG@nvidia.com>
References: <20230621235508.113949-1-suravee.suthikulpanit@amd.com>
 <ZJRQseaYkTJGHNsk@nvidia.com>
 <7364628b-54b6-b7e3-b272-8f91198679f9@amd.com>
 <ZJWF3oVvdj4OQmTf@nvidia.com>
 <b3c85550-a7f6-a0d9-74a4-f98c8251b80e@amd.com>
 <ZJYjOor3TKSeIo7F@nvidia.com>
 <ac4570c8-609b-03c3-c320-3dbe7432a8ed@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac4570c8-609b-03c3-c320-3dbe7432a8ed@amd.com>
X-ClientProxiedBy: BL1PR13CA0359.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::34) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA3PR12MB9091:EE_
X-MS-Office365-Filtering-Correlation-Id: f42b73eb-3368-4fa6-5b92-08db7648240b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n5kEknxRU01amKC72mDhoT2jTVbfwqWfQCtOW+okszdNBrIVQeZiUz8BpeYWWkGaKQCSXkkROVYESXBG37W2GdznJdPTwZd1elzKRMPULOPRXblpAY6u/SvX471WG4OD1rZYmjqHRR34XVIRu1Hcisa1yQpyXE8AbhOlheBeGkNuvvGH95T5tul88oLhN0f5LNdOhbnfY81Soo42TzygyKnA/C1kt6+bxdHud8CcqIdbo3eondVZGywP8SbXZ1lH63QjIGGQgYUvuxrueO2qwhBFaHUQRyui9LxXOYdv+cVfH7gXMe++OCPYCo4na2+CkdV+VEnaIgXNIys++NcSkiLPFNOmBPuJyvLsrs/g7/9rZoOjZFjxHjx3cjJwFX/Hic+T4nZdiXuRNWt2CkokLVsZ+AmNqe7qzr8jmt6KkwN2+TP+rIzpY5ouj2lpwPet5+2StIfvdbe2unZ//LqPGjsJCkHVbozZNFqlajI7jXsdUjiLjrqj71H9E9OqT0uenwYiwsFh52YSfvgs05kL9U0YeK26rFjX6aHsZlfosTIcJ1s2BmlwmnrL3op17+rV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(376002)(136003)(346002)(396003)(451199021)(2906002)(6486002)(38100700002)(2616005)(83380400001)(6512007)(6506007)(186003)(26005)(41300700001)(86362001)(478600001)(66946007)(66556008)(66476007)(316002)(4326008)(6916009)(8936002)(36756003)(7416002)(8676002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YD5UTXv96Iw3NizaXsxF+vIXDOldHU2AgsytSisUM0f3JHqZOIcM2OFfJVSj?=
 =?us-ascii?Q?zb2edj5mU06dVh70soGwpMbJiurhnJeLpzLlqjvqUZvK5fshR1s6ciU4tzwc?=
 =?us-ascii?Q?iTr4hUV0MpBhpRzsmcf5vN3EG9gC1OQXKPFmG/CUZC9zWS1cyLLPoROfDOGK?=
 =?us-ascii?Q?4+K+4N6Z2xeVhEyfllGkxI5Y6e/JRi4CsCw5J9TVbkjCFvwwhiO7q/+KrtTP?=
 =?us-ascii?Q?pnImtEXmx6iP4LKnMZfCxulPJ34voDORGK9+HJ2fw+mFJYm3nFz8mFfzlB5N?=
 =?us-ascii?Q?TIvYBzNAAa0tF2SIkgaWdLR8RRNS06e4B23eZ31zlrYboM4dT2oX2iRyctSU?=
 =?us-ascii?Q?wpoEkBs6j5O1fc8voS9kragkXHPtTNUHgeQ6Z/UlYQrBZGzigFqGk70Vl53O?=
 =?us-ascii?Q?xA41J2Vx1T0Gn2FXEFl6kgZTnbjNEuBoDIdSDBPuU2jMBsbeXn5hk1Tu7Mga?=
 =?us-ascii?Q?Az+ItcdD+5g2G5IWwdmoNC0Cp7Ut6rQvUo0pvbgxC3FAoSH5rDM1lnOns5c5?=
 =?us-ascii?Q?XjLY+KKgGN/u+KNY99IYbdCsW7RrEM90o3kLBE2P4HTgtjZjGBkzWpb3h+U4?=
 =?us-ascii?Q?R24fIjMnqVSqXokqhPRfA/diYlXLz4IZKt20de6Y6B5qkOKSsvjl17edltpt?=
 =?us-ascii?Q?ZTRTVUg8d16W3bnM+rTfDbuuJelMRtjqEru0onAavN+MCHwHKNhRXCZHAXaJ?=
 =?us-ascii?Q?X8M2qAFTp8vcUFDAZQOgundwAkcfYepHxXm7KXjVD06xLX2bizDR84wZhbDw?=
 =?us-ascii?Q?rUrSXSMzEeMbPkIyp4YcTPlws/FT6GPimdjIy3/hPbDdPQZFBuw7DTJhF06Y?=
 =?us-ascii?Q?pBRRjJrrIh/yw8KXUq1Xq2e1mD0PkiKpXKF9Wy8bQbwyRAZcaOk77hd0Ji1b?=
 =?us-ascii?Q?OgWB8DnnblPAmpD2ZDwepsTUhv7RM5wlMfUIorhdUPNpXkDgUnGc/K66o5Wv?=
 =?us-ascii?Q?S+3orWFklmrwFW2niEFzqWuAmwyewbcMraub5AhV3GNl9Wr5m7zZjHsJWEyR?=
 =?us-ascii?Q?RNJFd5jLzjFMarLyuoD1zvyT03XiHt1fVPucT+GTIc6gcPHfJ4ukjAJg/gJY?=
 =?us-ascii?Q?TcpfYieOCJlz/XymKZkVarBh5Z47GV/3lTaTbuEPZRZmXdF4STzPXsWKQ0lC?=
 =?us-ascii?Q?oZPt6ucDyEwuQA51nMBqPiz6QMT621yUmy+ZKkpA1eVcxndvkLjA48jylh/k?=
 =?us-ascii?Q?GMErD3MXJLBwzWcZyRHjK7rMs5eQlpSu+26QJ3CZkETpBtAguF3CBzuCfdpf?=
 =?us-ascii?Q?lX/4ptSVnBsFk4dO62Rzcffc9NuI0PHTe9shdDyPQyzDL0t+5/kPS7fKhC+1?=
 =?us-ascii?Q?5U/BjM2V2vSUXDhM98ET3VrTCTEE/hg9cvzcn48BM5seRYsiKDh0j0NPLvP1?=
 =?us-ascii?Q?vpVKeGdwVraaCnRyEZGScLv2OYPtCrHSOd4QESY08jEk9xjFuq/IlMoKw+OR?=
 =?us-ascii?Q?3FCkOO5gFZBCGJubdS8iw/D2CvhLSM25dyAYKlZxnlxmEJ+IPRBiDsdClAgd?=
 =?us-ascii?Q?JTQ6QV2YvNJNULVeaMnMjhmWKzGJgPsIwd3z/Z1BXCML0SWdK+anYEqq4lWh?=
 =?us-ascii?Q?Q916S5KfaB53nbuyO7YOrJlNLYRwF40u/Ge0D2Or?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f42b73eb-3368-4fa6-5b92-08db7648240b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2023 13:20:41.9883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n9JbyfaBj2PZ5d0B7gEEEwO92VeajdDPvpnO5fCzeFQGjAnJIHchuJF82cnfs0qe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9091
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 23, 2023 at 07:08:54PM -0700, Suthikulpanit, Suravee wrote:
> > > The IOMMU hardware use the PAS for storing Guest IOMMU information such as
> > > Guest MMIOs, DevID Mapping Table, DomID Mapping Table, and Guest
> > > Command/Event/PPR logs.
> > 
> > Why does it have to be in kernel memory?
> > 
> > Why not store the whole thing in user mapped memory and have the VMM
> > manipulate it directly?
> 
> The Guest MMIO, CmdBuf Dirty Status, are allocated per IOMMU instance. So,
> these data structure cannot be allocated by VMM. 

Yes, that is unfortunate so much stuff here wasn't 4k aligned so it
could be mapped sensibly. It doesn't really make any sense to have a
giant repeated register map that still has to be hypervisor trapped, a
command queue would have been more logical :(

> In this case, the IOMMUFD_CMD_MMIO_ACCESS might still be needed.

It seems this is unavoidable, but it needs a clearer name and purpose.

But more importantly we don't really have any object to hang this off
of - we don't have the notion of a "VM" in iommufd right now.

We had sort of been handwaving that maybe the entire FD is a "VM" and
maybe that works for some scenarios, but I don't think it works for
what you need, especially if you consider multi-instance.

So, it is good that you brought this series right now as I think it
needs harmonizing with what ARM needs to do, and this is the more
complex version of the two.

> The DomID and DevID mapping tables are allocated per-VM:
>   * DomID Mapping Table (512 KB contiguous memory)
>   * DevID Mapping Table (1 MB contiguous memory)

But these can be mapped into that IPA space at 4k granularity?
They just need contiguous IOVA? So the VMM could provide this memory
and we don't need calls to manipulate it?

> Let's say we can use IOMMU_SET_DEV_DATA to communicate the memory address of
> Dom/DevID Mapping tables to IOMMU driver to pin and map in the PAS IOMMU
> page table. Then, this might work. Does that go along the line of what you
> are thinking (mainly to try to avoid introducing additional ioctl)?

I think it makes more sense if memory that is logically part of the
VMM is mmap'd to the VMM. Since we have the general design of passing
user pointers and pinning them it makes some sense. You could do the
same trick as your IPA space and use a IPA IOAS plus an access to set
this all up.

This has the same issue as above, it needs some formal VM object, as
fundamentally you are asking the driver to allocate a limited resource
on a specific IOMMU instance and then link that to other actions.

Jason
