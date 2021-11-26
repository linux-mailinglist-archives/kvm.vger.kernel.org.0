Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19E6D45EEBE
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 14:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239185AbhKZNLZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 08:11:25 -0500
Received: from mail-mw2nam10on2057.outbound.protection.outlook.com ([40.107.94.57]:34944
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236174AbhKZNJY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Nov 2021 08:09:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JIUZ37ARMdD8P/ieFaluOeQ5EF0blCnOjWZtUp4oobHVTNejDFAkHwY7VGa94+1KReiQUkPS6wz8tGf7ce/mv2tzlKKDA5TMdAQFmkgRaGenldGY/bmUOgkVlCe4idZVjnPZtgU47Psa5o+551kM48QDf2ptAgcqPtR1Q5TvBAc0w9lP98LamTEQq8DjS5mbH/9VlPlo3hX+BL3Z4iu+PjrvFOw3VjljjWSV/8UO7eeKP4NSvDwqOvVxlwjwsMrxNPKbvLycjGPcmhrBuasAob3ifpgXGvUkNCfVUuwqeyOeEKfLG5LjeauWAD3GsaaxUFsNyJDako0Mk52WDdu45g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0kwX9nuXy3RHRgTuFkSo+85YFRcucd1aOZ3HNteRDxY=;
 b=JInkpYKFIXN6tVZ/IiFcqBDFm9RkJeYqAm2XxL6T9mDViMxhZEKIe4E2l50Mph1jPneBWTX+MwWMudNE0NsT9JPXAnxoJVbwi4OmZyHJx0+BEbBFYuszJWcZrSrgB7Jg5uR5aCvNuEMbrRClIjHXkcustCGO3217qokXYcKDH+9TVjVh0uKA7SzH6dzJqJHTVvF1owoTkSsoHGgL1Kukjg1ffXU231UYbIHHV7SJ64y2yHt/YTq+HVMf1hIk0W8Ku4oLFHH7VbBH+H6I2QTw9RRNH0ViXosSounGMh8HS8LfTjcXtirjoQo1NW57BpSB20THGhBN1tPi6DiobxRD+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0kwX9nuXy3RHRgTuFkSo+85YFRcucd1aOZ3HNteRDxY=;
 b=QolPgefn2KlfAdw0fJPBUeaXRFR7DjlZ+ojgCdrtv+Z6oONKc+M6F45OO71+uuqgD3+P9Nnlvc0eoRF62cfCbSWNAhArfXKSijcfGGYAxI2jhXkMc9VakHHNDfbuQxRh4sf3rL7AyaMAaYHACdku9/pjO7FThHEYIxm+Ciz1fW3tNGv1A0r1v8HIenZx5EnCOxIBUYOUdO1Rr5O2Re/iAcd/HHxQFlRstMhRb/RSygluh51Q1a0VeNo+N6BQymLI1rcezakniISlw62sY8WEYWJMGXZos+lXBmb0KEYkGGzpHYs2wBuflePxcdMknBp4o0hCqQLdIHL/Tnbd0i1s7w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5029.namprd12.prod.outlook.com (2603:10b6:208:310::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24; Fri, 26 Nov
 2021 13:06:10 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909%8]) with mapi id 15.20.4734.023; Fri, 26 Nov 2021
 13:06:10 +0000
Date:   Fri, 26 Nov 2021 09:06:08 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC] vfio: Documentation for the migration region
Message-ID: <20211126130608.GR4670@nvidia.com>
References: <0-v1-0ec87874bede+123-vfio_mig_doc_jgg@nvidia.com>
 <87zgpvj6lp.fsf@redhat.com>
 <20211123165352.GA4670@nvidia.com>
 <87fsrljxwq.fsf@redhat.com>
 <20211124184020.GM4670@nvidia.com>
 <87a6hsju8v.fsf@redhat.com>
 <20211125161447.GN4670@nvidia.com>
 <87pmqnhy85.fsf@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pmqnhy85.fsf@redhat.com>
X-ClientProxiedBy: BL1PR13CA0430.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::15) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0430.namprd13.prod.outlook.com (2603:10b6:208:2c3::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.13 via Frontend Transport; Fri, 26 Nov 2021 13:06:09 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mqavY-0038qh-VX; Fri, 26 Nov 2021 09:06:08 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3c0850c-107d-4f77-e402-08d9b0dd840d
X-MS-TrafficTypeDiagnostic: BL1PR12MB5029:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5029B71FB7B431B8EE769193C2639@BL1PR12MB5029.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oiCHo+/ohR8GbaZy2ObShQBsP3ZG8QDvM/+tjKZ7qUjYdBG4+PA9V+howICDF6t27tWe9iqC4iEBCODwOfql7qL0RBfCYL+1XNPPyRGMbBbS5iuSCHInR7GUAv8GWZeq+HgC0YmDwKwfeTZXoX3CWafWmBho0YpAAKQ4BykuSh8pF6iQ00A0Wsv8oJ66gIrmSJZ7o6IGK30QOLh2mU4ptZWUyxD9H3jrbIqFAkrj/FO30JIM9CPGeCCyf29/52o+8C6SeYuOOkdrU2Dfl45G6iP4qj5iSO6805AJVTqjgXrVqTVptqWPASZBXfFnl0OHAHEBnORSyahiFaYFN4r7JsGzzUmtq+UT7DLn2VnoG6dJNHvbaVuV7P6eS6L6xtQpr2ESeveT91kYK6NFrcnOI37E7Wm4kDgl8aaHc39JMuVm3uLwLA1eVZaKEH3X7zmGcdz/YRBWNSB/6pajZ70rP0vnZZ2/NJzAz2pESB668pTQjeV0y7W4nGNrSrXweHT6cFEQ6plBdTxBGJDEi1Bixc7aGUJqrCuTkg0GCem2YJIDOGT8SYtX+4ELJLlLX4B1zcPNzrlfch13ogV1KavDnlkF4I00JuT59D/A5IfDyR1X7eifTgfQgrrORpyVn4QP8cFq2LLmQJjRJUBRAA+dDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(9746002)(66476007)(9786002)(316002)(36756003)(33656002)(38100700002)(4326008)(6916009)(8676002)(54906003)(66556008)(107886003)(5660300002)(508600001)(2906002)(8936002)(26005)(86362001)(426003)(83380400001)(186003)(2616005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?79xlp3zlc4rsAIv/sScQIT1LPpxtO/tvLFyrXa74A7NoGHcP1PEPVWUq5vMv?=
 =?us-ascii?Q?EFm+FnRwek0UK6VES17u69czyEtniXtNsFlzyJAsr0PzHo8zqC4gnm9KUSo7?=
 =?us-ascii?Q?uoiBWJhsrZVtEoTXg0rP1wEtnRsU3AOH2RN086cLUWfVuasIuWRY+x2Zagfx?=
 =?us-ascii?Q?G0+bzDqo9W11VGYWtOiFl9oNE7s6CI1gImOG30GYkSXdYVyoKrtICidoc9Ln?=
 =?us-ascii?Q?fThmkKG8Ai3RTn16I/F11CX5eDbUP2xY8SMcrLiLnSVcaD9G1SHIIe7UsFHg?=
 =?us-ascii?Q?AiTYjYFqPdBtDn9cLb7F4kjbSHdH3n3JGmAHPN5JMaOoSu8jwuKDuQWtBGbk?=
 =?us-ascii?Q?BKsAiyeQcdeIUqoyuLDqST+M1At7IR/fH+dO+QGyqlAeprjbpEJq3nTkPMgK?=
 =?us-ascii?Q?cWIej3hedl1i0U6NUEPSx6CJjOJBPmYIcKuoTfGFq8ThygOt+xYqXJhZA3bB?=
 =?us-ascii?Q?ccdK2ClkwvEbO4ZoV0lnQZUUd0YRGAhdQj+jXrZx4wbVHQj3R5vk/t8s/s3v?=
 =?us-ascii?Q?4INkerPRb/OnMjithCvzM19nKqVFV3c7743RiqP9s40wuyKKdDypuJ4h/voA?=
 =?us-ascii?Q?YmTHI7quVJwsNlSs7dutHr9NTtYa3ehmm5ge2o9xsvrEtD7moNsFzak2sOlA?=
 =?us-ascii?Q?3o0IbmGJVt9jHW75tHiQCol6T69oRkFJKtt/ma0rkzzwn7uUBJWMcrus9Tzx?=
 =?us-ascii?Q?UVHcMmxM4WH2DWhBFGKZLFogv9/vipSL5hjRtWr/xqlCA743Vz3C3kZ+PGOg?=
 =?us-ascii?Q?17oW8ggmUvn9ni0VH+9MgBCnIV8lNuAIzYPULeECasMP1AKVIatAXn9JFUEJ?=
 =?us-ascii?Q?2EvfFeHfOnnT3/PscptD0EJ0qtFy0oy7BHJsNZ1+Xv95ElBRvrc1itbcFeg5?=
 =?us-ascii?Q?gbZfDxSuGFLM7k45e7pFy0kX9uQy4NG517q9vlUpINk34tPyEkuE9eXKLUNK?=
 =?us-ascii?Q?IE9iyJfuj5aRKXj+HTWjyEfO6dfwF5OEv6pP+X5/0I93aPQXSlNqwmmkGzhJ?=
 =?us-ascii?Q?3lDyiInm2g5O1EwnrWMSDKI1E6R3MU6mE+wnxtZwyH35jScqUixt3LfqlU7E?=
 =?us-ascii?Q?/CPtB8JUd+ncvEIFiqJmQlDMX0HPJC3rztNi3Y85VkGiapmxSgrj42yzdfyp?=
 =?us-ascii?Q?eLuASD7DrCUe7egmspA9j2Ikn1hd4EG3gM8ymbndJPWs8oEWM3Yj7F7vPg8O?=
 =?us-ascii?Q?AAsMwIYH4xq3SaXH6Ifvm8Yqo9KAFZAC4RLangc5z7JLa/pa5PqDkwzt2EwE?=
 =?us-ascii?Q?muEn5Wvvv2N7QVV+MaaxzPNElWjg1KKjCySzoWh9OSi/W30hnpLz2M2rEpwA?=
 =?us-ascii?Q?wlD6qZZbkAsY6BacDh3XxedFjeetbd1xZcnKAtSLf6qVIfx6aFP2wpwdyM2p?=
 =?us-ascii?Q?UMxYzLHyyLWT8u7QFWby6lpSoQrxhnWJhoMr3uGpk83yDkhhKTtOWIvkG5EC?=
 =?us-ascii?Q?tQRDOjXs2872mr70Q5yEXdEhM0H2k5Qkqr4QJdREVn0vWNxb5Zc9aB68RS+X?=
 =?us-ascii?Q?80SrZGW/9ZT4t9ml/M+gTmvhIHKAMDEWD1J+Wihan3EzOvFPGtDvtzY2q1/i?=
 =?us-ascii?Q?P6SOXexiCSC8F/8Cyr8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3c0850c-107d-4f77-e402-08d9b0dd840d
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2021 13:06:10.0614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6aqj4qoQefvzHSqVIWgoYajrLKKycco+iwYH+XAzIf3QAx4M0SANcpGZiwSrMH6D
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5029
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 26, 2021 at 01:56:26PM +0100, Cornelia Huck wrote:
> On Thu, Nov 25 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Thu, Nov 25, 2021 at 01:27:12PM +0100, Cornelia Huck wrote:
> >> On Wed, Nov 24 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:
> >> 
> >> > On Wed, Nov 24, 2021 at 05:55:49PM +0100, Cornelia Huck wrote:
> >> 
> >> >> What I meant to say: If we give userspace the flexibility to operate
> >> >> this, we also must give different device types some flexibility. While
> >> >> subchannels will follow the general flow, they'll probably condense/omit
> >> >> some steps, as I/O is quite different to PCI there.
> >> >
> >> > I would say no - migration is general, no device type should get to
> >> > violate this spec.  Did you have something specific in mind? There is
> >> > very little PCI specific here already
> >> 
> >> I'm not really thinking about violating the spec, but more omitting
> >> things that do not really apply to the hardware. For example, it is
> >> really easy to shut up a subchannel, we don't really need to wait until
> >> nothing happens anymore, and it doesn't even have MMIO. 
> >
> > I've never really looked closely at the s390 mdev drivers..
> >
> > What does something like AP even do anyhow? The ioctl handler doesn't
> > do anything, there is no mmap hook, how does the VFIO userspace
> > interact with this thing?
> 
> For AP, the magic is in the hardware/firmware; the vfio parts are needed
> to configure what is exposed to a given guest, not for operation. Once
> it is up, the hardware will handle any instructions directly, the
> hypervisor will not see them. (Unfortunately, none of the details have
> public documentation.) I have no idea how this would play with migration.

That is kind of what I thought..

VFIO is all about exposing a device to userspace control, sounds like
the S390 drivers skipped that step.

KVM is all about taking what userspace can already control and giving
it to a guest, in an accelerated way.

Making a bypass where a KVM guest has more capability than the user
process because VFIO and KVM have been directly coupled completely
upends the whole logical model.

As we talked with Intel's wbinvd stuff you should have a mental model
where the VFIO userspace process can do anything the KVM guest can do
via ioctls on the mdev. KVM is just an accelerated way to do that same
stuff. Maybe S390 doesn't implement those ioctls, but they are
logically part of the model.

So, for the migration doc, imagine some non-accelerated KVM that was
intercepting the guest operations and calling the logical ioctls on
the mdev instead. When we talk about MMIO/PIO/etc it also includes
mdev operation ioctls too, and by extension any ioctl accelerated
inside KVM.

Jason
