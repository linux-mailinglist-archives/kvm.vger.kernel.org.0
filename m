Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFE47986EA
	for <lists+kvm@lfdr.de>; Fri,  8 Sep 2023 14:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241705AbjIHMQL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 08:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjIHMQK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 08:16:10 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2066.outbound.protection.outlook.com [40.107.237.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 643B51BEA;
        Fri,  8 Sep 2023 05:16:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DoIwzxBxBieGvZEg0yNglxrB91mEwZobhMdzfoMA0Eh7JzzICa47Q5q5/Q+q3cJ2WG5NB2NZMUS1dhO9exRRITbSuqZxMhZl0Cb+PvUmdLNyaGufqmK+qgIMPvTPYblUbqYACaNNyiVOJX9+G46lCJL8xvh0lSe5rRcQ3M11i76OhT1rByS16YvDxX2yJbH1yA4AWVp9e82IOg2lpkxvwhfaHSv3Bx1SzbMI63mJdxVGtx6Km+EYrmQRdfOhz9Wt5wYN78JvWHYVm1D4pNtFAhUxaOWTwn0dqKTo2rLcLMnz7scEu1F9lIBqeUzmcBq27Gk9TJzDlKz4YcWW/NVGkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8LjjnE355v0J9U2+nTOkwqc+/S6kOyUR7WAhgYVn8Yg=;
 b=JzGDJersAnPmHSSZmPwUN1uG7gPZ+O0AhpxNbiR449Q7AHDZvSo+r5J9l9AIHRK+3GfhFQLIQI8bZgHN4mXyWauoUnpcYCBqCULcMYPP0s9DkywbWtA2PnTsrViBI2TtfJYozpT8zwMp0xONseLDUNE5imU7E9UvO7A9duPZx2ZDAIYBEd06XpzhSjcYkQONHHOJtMFmZYu5SOACh1L9I/xPtQDTeSsRUdKSmL7jCJSCJUG4dfwyGHcQkqf+mXGx252sCg/jtqXPq4dHO+mKsa4xK67bM6MQVPKLIj7KExi95HO67Juy7g3D/zjgMMs+Tf98pj9I/nNkKJr681Iv6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8LjjnE355v0J9U2+nTOkwqc+/S6kOyUR7WAhgYVn8Yg=;
 b=Gjrmeac7mqp6lOx0aOMJSXI+qlkmx+ekH0u+Otr5IXK4M82xga4fMKB0bGLiBqHtZidRDhqEJlXkQciIkn7UL00i8eulsxkujBLRK0OLtggEvg0BJfDL6m10ppK7migGh0jZYda0NyMklOi07PTYOVnCrPlHyzbCW6kL1IJDtJxWmu/zJfkMC2uuAdJhKamw//LYDT7qn/Ofwue1Qro4Bztek1Xs9ryW9gEgEwxC2WS93vBxnLiuqrTIkUp9JmKqpOVJsbGlPmi+6YUK4WrefsLM/xKah85K//yl44J70LqF7t75EPZsoiC7cd3t86CA9XcL3XTZja1W5JzH0sMP2Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW4PR12MB5625.namprd12.prod.outlook.com (2603:10b6:303:168::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.34; Fri, 8 Sep
 2023 12:16:00 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073%5]) with mapi id 15.20.6745.035; Fri, 8 Sep 2023
 12:16:00 +0000
Date:   Fri, 8 Sep 2023 09:15:59 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Alex Williamson <alex.williamson@redhat.com>, ankita@nvidia.com,
        yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        kevin.tian@intel.com, aniketa@nvidia.com, cjia@nvidia.com,
        kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
        acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
        danw@nvidia.com, anuaggarwal@nvidia.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Message-ID: <ZPsQf9pGrSnbFI8p@nvidia.com>
References: <20230825124138.9088-1-ankita@nvidia.com>
 <20230907135546.70239f1b.alex.williamson@redhat.com>
 <ZPpsIU3vAcfFh2e6@nvidia.com>
 <20230907220410.31c6c2ab.alex.williamson@redhat.com>
 <ZPrgXAfJvlDLsWqb@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZPrgXAfJvlDLsWqb@infradead.org>
X-ClientProxiedBy: MN2PR06CA0023.namprd06.prod.outlook.com
 (2603:10b6:208:23d::28) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW4PR12MB5625:EE_
X-MS-Office365-Filtering-Correlation-Id: 939952cf-5ead-4fdb-72c8-08dbb0655d24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JB2e0qNkVxMvlIH6eQOuPgjdrxXRDQcaNv6PgPL7WjbsgGP05ofRc/tzl0DtYVjGkVFEzCaSlYbtVE6e0hECbvT1KKwL914TNIUVVXRZ1GlbCPO6HkFIJ5wvuQvQ3/wlfzh77ZiKz4xHprVtCJ4vp3XQm/wFmZEFYDFfbyQpUkrr99mpMav5xqVfNnwsLbBW6xnKFhu6V94Pc8zBC9S1Q1Gxatx5yLCFKdILwTh4/zWZW3ibSMeZZo1GDfYKK9lrDz1vnb2MGK+ES4Rh8mradi7RWHz4gz7n7mSzaB6IUugZI+vRfapj247KuO0BAdcQFeHsPSpkYXz+hXI7ojSwSVVDS4qB7XRZ+FPHYeb2qNITC6BTu9jfKewv7ozBGYwOqO6EODNYX8AdndOoS8V3YObndLUx3Tfkw+hkn1Me3oESTkvo+ZMekmg0qBhJdBrw6WBL/q4twr47X5zTGx3FHlqhK3bcQ679qoJxAup2Wa7flqV+1LcExjI5XkdS/rs1oZvkfEKkAxSNqAgummGzG7dgGxYwWwu/OYV+iz3dRhBL6Qp4aQZYcnPlL3mfDhcB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(346002)(376002)(366004)(39860400002)(1800799009)(451199024)(186009)(6486002)(6512007)(6506007)(36756003)(86362001)(38100700002)(66946007)(2906002)(26005)(478600001)(316002)(4326008)(2616005)(5660300002)(8936002)(8676002)(6916009)(66476007)(66556008)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0VW68KWoX9lvoQkG7wUIWtfWlOfvFCSq5fSDe41iKOTaC1b5w3EABqMTKlUd?=
 =?us-ascii?Q?CHOLwLhjcmeK11F44JAn8wCKX3uyaUlEfYoKdz56IGrCqqDGLEf6sOOaCRHL?=
 =?us-ascii?Q?7yvoIUMz8grm45psXUzeTprSAmYONdNZ7w58VnYavNW3zO1TKArvgtvm+9Ns?=
 =?us-ascii?Q?DC61OQnPbJ8StoDF48ciOX7x6SmcVKNpe9bzsu9R3kWjfU7uINPp6OTMAPJ4?=
 =?us-ascii?Q?jGIpbkWflw9pt1K57nBRSYmLiol6ujxLyfipk1ZOWlTP77a/wa720TdOpGty?=
 =?us-ascii?Q?9MkUcVLKjDGbTiweJdHR4SmlXRPn1rAEeNwer5VzHN1ftP8L+Zg01KEBU8/A?=
 =?us-ascii?Q?MRHvckGG5WO8bRxjw+xiSvCvoUeDwHX/0NZpORPxmSlUZTziG9LSePR6F1D9?=
 =?us-ascii?Q?KAnb0zNMthzbhcDoS/lLbH5gfrEuZ7FmEe8Z/h/dI2hpaNRDqVXCU+4dThLp?=
 =?us-ascii?Q?3XWEmAETss1Ptsq4LSXBKLMbuqPKlAwb9hrrLwIb5XLGrEzPDQYpkWrk7FO7?=
 =?us-ascii?Q?Jh0fWxpLAXfe3kb+XZEDVLNrWV1hsjQIDGc5uUuQs5r4tacR0xs9QvXkj/s6?=
 =?us-ascii?Q?xTAj92rllA+GCo8vB5tQS/DY5wrwXPauxzZkzM4CmR/iUxs+6gGJ4iu+2YIB?=
 =?us-ascii?Q?vysPEGxdyx7Pxmckwqsle9eonq4lENeFQM3SGBXhch06xmETBQ4imq8aTVaE?=
 =?us-ascii?Q?FYKH7jDcSNI1C5/Lqc4Cvw9Fyi+DcWUcFYdASx1WJVNrf5Jip1Hs/Ucj3o8H?=
 =?us-ascii?Q?9uHqviyaJae/bGrHNAThl5az7lLQbnfFjGEJ7qncMxEdupBYZrTWgKMj2OFT?=
 =?us-ascii?Q?ykvzKBAl9VYDUImYY6UZldXzdO/bOqWn0Nz7C68vnmpb0QtWD1kNCHTj1kt3?=
 =?us-ascii?Q?gJTNXPC1jy59jp1rhvPQvy3p/EXRANzMKxRJu8mF4olXdanopgTCG4jvhpiy?=
 =?us-ascii?Q?X6KBfKklSisc7xq7AKU8yWxlURapi6e2vJJ4RobVhYVeT7OfcvEY2UzPEArA?=
 =?us-ascii?Q?MlqdymbFnNoxaz1jKyRRFi3n+McZ0KXDj2obL87sH1DFMqMgYZfGoC7An4L7?=
 =?us-ascii?Q?15y/3blsIZs0dCrINfe5AVipXjYrtjQg12hHANYkK/+JHG8e0ulTTfNsIxeA?=
 =?us-ascii?Q?10DP43y8QJ1TybIwQ+eGKWgVHccUo8apZqudP5bV9HUGW5tUYcxi7VFawoeQ?=
 =?us-ascii?Q?kIWDric2AJ8u8LCaFMr0v02iN5i8cjP8Xh6Tt1Oq+/RXCzsaVkW4DHDLCZZ+?=
 =?us-ascii?Q?xrrOX+r0rbDkf2BPGhlWL9a82Xe7c7wUtnEqjhidURLVPhBbAtDYwfG2UrXC?=
 =?us-ascii?Q?DWrx3S4QwOcYOCfrnAd3TcVk4DrpeaIRVklRDspmicCedejB1J7lIx9hPsdy?=
 =?us-ascii?Q?Pd/R8SgoYAvXP6z80ycXMGTZHC+/ZLCz3ayFWSr+LNDwThB37QiTKlGCNXUq?=
 =?us-ascii?Q?IYqwW6c228vUpMKXZtZh0KFCXsU6PXeWIi1q5MY3TK42d2hRSQA6S4sy5BUR?=
 =?us-ascii?Q?UUitLJZ/TXLrzhVexbz7nE84xfYxqriIHJQj9XVMrFrj0dUyJvl0hKK7QRAG?=
 =?us-ascii?Q?vkVjpdyxLhLo7GYoVXgOlmOxVzNrL4eeBalu98HH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 939952cf-5ead-4fdb-72c8-08dbb0655d24
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2023 12:16:00.5666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 74tHvHqKVF7I0I1Ma22kGwLVJp4uISuduAQ8aafVWSa2i5CXQZeX04TqFacXAw6l
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5625
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 08, 2023 at 01:50:36AM -0700, Christoph Hellwig wrote:
> On Thu, Sep 07, 2023 at 10:04:10PM -0600, Alex Williamson wrote:
> > > I think it really depends on what the qemu side wants to do..
> >
> > Ok, I thought you had been one of the proponents of the fake BAR
> > approach as more resembling CXL.  

Yes, I do prefer this because it is ultimately simpler on the qemu and
VM side. This ACPI tinkering is not nice.

> > Do we need to reevaluate that the tinkering with the VM machine
> > topology and firmware tables would better align to a device
> > specific region that QEMU inserts into the VM address space so
> > that bare metal and virtual machine versions of this device look
> > more similar?  Thanks,

> Yes, providing something to a VM that doesn't look anything like the
> underlying hardware feels pretty strange.

I don't see the goal as perfect emulation of the real HW.

Aiming for minimally disruptive to the ecosystem to support this
quirky pre-CXL HW.

Perfect emulation would need a unique VFIO uAPI and more complex qemu
changes, and it really brings nothing of value.

Jason
