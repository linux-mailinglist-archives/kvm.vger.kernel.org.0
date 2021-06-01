Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9A2A397311
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 14:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233837AbhFAMR5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 08:17:57 -0400
Received: from mail-bn8nam12on2052.outbound.protection.outlook.com ([40.107.237.52]:23254
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231219AbhFAMR4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 08:17:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fLCv/Sovi9qgj0HhL4LwEZV4GCV43N4O/AqIHsalvFLNkV6egjfl5GGa+26Bx1iLPBoP83AnwZHAb91GBoPio/isNwVEHp2msMfRPTgUV7wPK1Zyk1GUoaWcy7MNH1POPVmIq7JDEvVstWvjX72cpA1Q8XlIhsQpbb1lvgT9RhQm/IX20+68irFX7Gja9MWW16X/u5BHopwl/XIVQOwGGthv9M4/7yMYzoV39keniCm1Hp9Sdvz17DpiCwilV23277h8+gfuwyQK1j0FF4PhcGRgilpW+z18iB9HQnf63uAtJ9BATOeO+gt4Ap4ERocTb3GuGz/KHAwsUdqVqPxgbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tELnOz9gOZgoqkNPefnS2UcgqXew9TNx6yEtBgyNbe4=;
 b=hBuAFc8RPnwUOYjB0BydVzVO/QqtsgViDGNZro9gPbgdJbjlqbBNlmxEX1Du8RhmSaXmZuPttX/nuIJAqeC2oSJE2QtE+DT+ZKRXBooaMEgAVqnwKkUIYCasn3+zbSPajXMbG/JyqUssNgG9HSnMeQb1yYhWp5U7HXNI/zD0WV3+tJcYlDMfX8KlcVkZike9mZ87SiLHeuslH7HaudhKfZ9PBzD36/MauTIAW6PRrN16O91O4ZgzhuHIcudHwCSfWzFIJQKNed+sxiGhLgZ1+8IUq0JQyKs8Jkb4HsahgpmuPvfrk3Hj2c56mxX3BlsG8cXYao1sNMmMvjt0LLFEaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tELnOz9gOZgoqkNPefnS2UcgqXew9TNx6yEtBgyNbe4=;
 b=QUnwi+Nmafy5t08GAT/C351u8iEFziXr/gZM91xR28+P/banrR9F65XDmGnnWO5WB9wdcrLYom9QHvjxf9dUhIP9ZQb3wgyadjmiNxR8NdWJUOooEbbaCZXqrW5BUjGsFRTQF1T17Ka0PzVSl24Z84xADza6Kjh3VNvP3TAPjE4cldKPfDGDGRpID9ra9rsjq03DVlFwwQD+8ww3sSvX9Gk3UXdbfA+fDWhmco7SLc/EeNwGg3VIHtBJqNDIF+9eJHX1pOPM6zW9p2lH7bTGY9azwzEM+iA+pHVn0uRhPlb0F46oVkTx8xXxknGzwQ3VkjXF+L7jC5CvLWKp8PIvfg==
Authentication-Results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5240.namprd12.prod.outlook.com (2603:10b6:208:319::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Tue, 1 Jun
 2021 12:16:13 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4173.030; Tue, 1 Jun 2021
 12:16:13 +0000
Date:   Tue, 1 Jun 2021 09:16:12 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Dave Jiang <dave.jiang@intel.com>, alex.williamson@redhat.com,
        kwankhede@nvidia.com, vkoul@kernel.org, megha.dey@intel.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, dan.j.williams@intel.com,
        eric.auger@redhat.com, pbonzini@redhat.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v6 15/20] vfio/mdev: idxd: ims domain setup for the vdcm
Message-ID: <20210601121612.GH1002214@nvidia.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
 <162164283796.261970.11020270418798826121.stgit@djiang5-desk3.ch.intel.com>
 <20210523235023.GL1002214@nvidia.com>
 <87mtsb3sth.ffs@nanos.tec.linutronix.de>
 <20210531165754.GV1002214@nvidia.com>
 <875yyy31cl.ffs@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875yyy31cl.ffs@nanos.tec.linutronix.de>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BLAPR03CA0129.namprd03.prod.outlook.com
 (2603:10b6:208:32e::14) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BLAPR03CA0129.namprd03.prod.outlook.com (2603:10b6:208:32e::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22 via Frontend Transport; Tue, 1 Jun 2021 12:16:13 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lo3Jc-00HRVM-CM; Tue, 01 Jun 2021 09:16:12 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a6994371-ef89-422f-8139-08d924f70c4a
X-MS-TrafficTypeDiagnostic: BL1PR12MB5240:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB52400C2DF7D16DED5BC984F1C23E9@BL1PR12MB5240.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wd6rzb1dIWu36eRNDFrNPG6bD/uzeVEvDDuuipb4dU9sbUH9B0AFS8hxeyI8zeOQ2PrrJ6ImfJZPw3PUYqzB/e8kyoFlRUTIk/lbAMGCC2l7Ud1d+GIt6CuqAU0E6BXnCsrGZdKNKz2P2x325HA4sfr1ZQbNtZoSs0jvhWkaYBgHJedfRABF9/LJ6HUSIwVglTziMZWfL0Eku48OtcV764wKZnaVMjLlFDW6G4hUc1n5rCQjOu8d3NMksnGmDZpWsuwtQ09PemK8aAz3R/sfaMXGLz+Ss8gxh3LU4dheq6WjltHgmtSqgJmLpXHnWik+C/Yine2cXBYv8I6cAqSuALXVIjUyWKZA71+sI8+Zc4PqKxrLEDOfcIamWA+aDx5sBlJ5QbhzYRn8u3FAe11sAYg1An2ZMnmUpSWDAwEhbY7J+cVr1J7Ih/B0XYdQb8RAt0miV+kHDMpru2aO5qcmMap4DaCFiv4s+nzUfKN7xEWYqYQT6TsLd23PBs/NDpt8+AedJ9OSPfXbToItx9pxCBr/zQMU2R9CMZkXsZ4T3elsdoXBWJeMSuQEEw+Cr0lfvf/t+tqYIdx2YuMiRayXhWVYgytuSwqybIO+Lgl3tBPbvCaqNMtqQe8enASKFkAgN61ZBqcmwHoRqTGEcInM89KrEtikH6wmCD9O5KpPFIZVyR5bclVq+XVcU7yvriVgTUllZu3qCc/QjzTRPMeigw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(346002)(39860400002)(366004)(966005)(478600001)(8676002)(5660300002)(8936002)(426003)(186003)(66476007)(86362001)(2906002)(1076003)(66946007)(2616005)(6916009)(316002)(38100700002)(4326008)(26005)(9786002)(83380400001)(7416002)(9746002)(36756003)(33656002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7kG+g6cB25bwUsEMoqad+0/y3rZoHv6518FGLM/WHJrFzSb154oW3UqTXRij?=
 =?us-ascii?Q?Xnd3AbeiRsWzUYul9q4n249U3E6vlkOoosVMo9/LJq59hN+15quEgCgkVYHb?=
 =?us-ascii?Q?snSy/znHFbdzS9C5hzwfbfvcjPRTzEGvaAHAoVQgNbjLdx7vDg0kT/T31jFG?=
 =?us-ascii?Q?DXHoZEM21lbpJSWN8F6csK9iKOf5f2lNyzHtIOsh0J6a5UFUkArcxaLM3/xf?=
 =?us-ascii?Q?L6mvsabvX/th87malEJCPOhdEIkBBFNUi2eoZlBkcbf8bcXiCglOXvTCf4QG?=
 =?us-ascii?Q?jNssVzequIhgia4BThI8brE1eaxWpGtJmTMSrvMF/b/xoFP9n8lOI8iKeQI/?=
 =?us-ascii?Q?bVdpYrBJFyUvYoJYb5BIOssler8PEj3f4wvw/FQW6basRAxVCB1Mj4YEGVqA?=
 =?us-ascii?Q?mN02dAFwS1vuQjYQ3J0XruZYtEOdP203OQPM4BSamuesK9oqojnFRj3IAtxE?=
 =?us-ascii?Q?JL8eakK/aAJoBBo6EByMn1qaZlE35bcm7Y8gOWFhDo6kxCvMFb+8mfmUZGAV?=
 =?us-ascii?Q?QdKbtQoQb3CPHiz/vV/4n1jnjM/AgJS0X3tVNA4022BpTYszbXH+73YGeGgh?=
 =?us-ascii?Q?6djBZ4BXoz4GJ907h9Alor63MZRlwIdRku3Boq+5uosJJe5JlofrPbSJZZOl?=
 =?us-ascii?Q?s8P1kZyI0Q12n+/qIM5cEJEJWOqwS+NWQ7gNvoxoXl4m49JpYx2ViAfYF8fj?=
 =?us-ascii?Q?oXxr5XLETlxbHvPAY8z7zUF4Ye/oJ5XPC5FNFOt59yzzAOu2Os8/F+m0GNjg?=
 =?us-ascii?Q?cwDVb3TWL5htSOiBJ5D05swNQ7m5wdMcjwQdD5oaXXf+UtOzk+IWE9cfEJV0?=
 =?us-ascii?Q?Iw7n0t8VksSQxa6s6Q6Qa4RR0zPLCyhfsrmMA+JVg/pWIv86eOIkDgXK5a2+?=
 =?us-ascii?Q?KKHcHiFoKw1oNzg/KFzQkZMgZkhAuXMrFKqCf7C1i+oe9OMnQVNdktlYY0C5?=
 =?us-ascii?Q?KzWpKhiOE838476jMbrKlwSUbbHQAUviLHg5s6F+1wVRC4ZLCOgu8JuJGabd?=
 =?us-ascii?Q?ekKXLOATJb09ASNkb/laj+LNkPlRC25FzNuIHeJOQ2d0fJbljHG3+hWTarb1?=
 =?us-ascii?Q?HPHKvnsWjGew30IAAC3SJljF99bfAUIEotk0iR0bYyJye3219k6nzAh7IFlj?=
 =?us-ascii?Q?TFAt6VNHiXjnlLaDEMtOH4xty8j5vyM8iwwXFMJDd9bsaO9wAg+fTtuw+hXd?=
 =?us-ascii?Q?fCHzinhvARYbllQJfqSNeSoEn7s3ETnbRl2AzagzwQPPqRhMsn7P0NKMQpco?=
 =?us-ascii?Q?aazMOSMkyi3Q6MXLieQDWJlNKVtOZVYQOxwJCuCVft1iILOyGFFhUlyzPTiG?=
 =?us-ascii?Q?pXOU6dcvtWgt9exdmlJ9YDmG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6994371-ef89-422f-8139-08d924f70c4a
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2021 12:16:13.4135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VJxAgPfA6btE0E1F3cBsRDlkQdY73Klr7WrtfruSC9ct2Jg484hkNIIdlLJRWZl9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5240
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 01, 2021 at 01:55:22AM +0200, Thomas Gleixner wrote:
> On Mon, May 31 2021 at 13:57, Jason Gunthorpe wrote:
> > On Mon, May 31, 2021 at 04:02:02PM +0200, Thomas Gleixner wrote:
> >> > I'm quite surprised that every mdev doesn't create its own ims_domain
> >> > in its probe function.
> >> 
> >> What for?
> >
> > IDXD wouldn't need it, but proper IMS HW with no bound of number of
> > vectors can't provide a ims_info.max_slots value here.
> 
> There is no need to do so:
> 
>      https://lore.kernel.org/r/20200826112335.202234502@linutronix.de
> 
> which has the IMS_MSI_QUEUE variant at which you looked at and said:
> 
>  "I haven't looked through everything in detail, but this does look like
>   it is good for the mlx5 devices."
> 
> ims_info.max_slots is a property of the IMS_MSI_ARRAY and does not make
> any restrictions on other storage.

Ok, it has been a while since then

> >> That depends on how IMS is implemented. The IDXD variant has a fixed
> >> sized message store which is shared between all subdevices, so yet
> >> another domain would not provide any value.
> >
> > Right, IDXD would have been perfectly happy to use the normal MSI-X
> > table from what I can see.
> 
> Again. No, it's a storage size problem and regular MSI-X does not
> support auxiliary data.

I mean the IDXD HW could have been designed with a normal format MSI-X
table and a side table with the PASID.

> Ergo, the proper thing to do is to fix this ID storage problem (PASID,
> VM_ID or whatever) at the proper place, i.e. store it in struct device
> (which is associated to that mdev) and let the individual drivers handle
> it as they require.

If the struct device defines all the details of how to place the IRQ
into the HW, including what HW table to use, then it seems like it
could work.

I don't clearly remember all the details anymore so lets look at how
non-IDXD devices might work when HW actually comes.

Jason
