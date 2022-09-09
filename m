Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 001995B3AB9
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 16:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbiIIOb6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 10:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiIIOb5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 10:31:57 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2050.outbound.protection.outlook.com [40.107.94.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7580EE9176;
        Fri,  9 Sep 2022 07:31:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S6IWQWZJIxbpmyB+wTF2iuhAna+RCg/NAnhG/UCwQCBpZ+Euf0ubPZnl+Gfc9fKyD+YDgrrwHFqx+zXhYuYh7EzHlUN5pDCcED6K/L+JjFGbFD6z7FNnVhjF5f767CwyNQv9/iLfFRQtxgE7qZl7dzAC+pVRTie4KtbvJQO5xNoPnMKlKoBI7Js9lpJfH/yXzwrJBRiiffMyfxUwVmrdgLxn7CNmUMp6zPDnhqJuif8KZ4AHISdvepUS5CGDD+axbNnpwS7MMAh5EzAoSHoRH/lpClcXqF2R+JlHjsdG8AomB7d/IVsVfA/SNNbLgZlJ6d8wiyF1vALl2NN2scz53A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yezuEf+Ud/SikEbk8JCpZ7ELBoq0y5ntME4qS+ozsxg=;
 b=KIUTRSaUw2H5Cc0d6oRsM/kaNHwceKmineGTxpB9QZP4C99WUIxXi1l0WBQ6HRNk+o7N6Bo2Hdx2W+UWKqzIP1y5jvb1A+b7gnOeB15CYAAWf6QDvDxbi0bk+UTsnTOAfScM26ksSlRdwe1G/r0UVNQ7yHoBE6FYBVGQ/YKXjQBLpHs2o+cWiCxVaKrTeGtppMOHJxvNvGJRNg1OtEy+K2fju9lg9xNy2wP8B+tSZHNjnnjVUf+g5YWs5e/CTcRQnbNogbMRBF5wywAPZxjuEIF5dA2nFGkAUsHhRc4qBTd5ysOcYqUAtWJkR5BKOoKdx0BKDtLLIoGLwUUyCT0r1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yezuEf+Ud/SikEbk8JCpZ7ELBoq0y5ntME4qS+ozsxg=;
 b=qtyO982GyTvso4jOf9SHmU/IRwf+xCBWHiZX0n8GNUCoByCi5ALhLzzhql4j6z1KrX+Ukr1z+G4XUHiSE+BVU2vLhwFXBhbmnJl4m+orcxZU2QHLR6DJhGml9g36eXG0OehGcpgEJ4XdNYjC+DJXZ0B3fbhMZ+VYMJDzX0r1efEbO0vSncZ8gmexwGJQN1s0+tdGsHP48E3QCcyYuiNo1Ji5vewI8VuDPu/LoVT5KWl45ZdLfBHAKrbWVdQBsKMQp7nZi2x+ubmY/Xmzk9fc4Xn/iZXU7quTcT/iInriKppxOkjbr6EQ+eP1NRYAxhD5HCiw4iiHj1jCB+/K9yl8Fw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM4PR12MB6277.namprd12.prod.outlook.com (2603:10b6:8:a5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12; Fri, 9 Sep
 2022 14:31:53 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5612.019; Fri, 9 Sep 2022
 14:31:51 +0000
Date:   Fri, 9 Sep 2022 11:31:49 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] VFIO fix for v6.0-rc5
Message-ID: <YxtOVURw00Dtm3rT@nvidia.com>
References: <20220909045225.3a572a57.alex.williamson@redhat.com>
 <CAHk-=wj3rrkPvPJB_u4qoHK4=PVUuBHKB67f_oZO62EE22pNPQ@mail.gmail.com>
 <20220909060832.17f6607f.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909060832.17f6607f.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR07CA0003.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::13) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|DM4PR12MB6277:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ff4144d-dc07-46c4-66d9-08da927008d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nuquaZMEoWYDMhQ1NhMuPQ9+NfB008L40SqlLyJ7Zdgdk1N4VGoCA/xU0wA5RdDyAPa9FnXZtj+VgmQ0Mf14svs5B8buh08keIXP/cFLb4bbgbrh3O9iXwkbHxyW6VWdHZ7jXKbY8Jz44pb2MTZ9eJxhHCKRbRB6A3H6yjOqjwTYLeT1sDQUdXJL3aaISyylVYcsCkZRw9AiIs33KDS3KGei/cO+k7+4XJ5b8nDkuAg6sogej93+o+Gk2taGcK/UUk25weXcOjcKZ7gmKy5M1EqaJrVkZRxR5PzszwN/SkVVXPemM0Alwnfwkr3e4lZYzp91ej9K/hfkuyc+iSQWimMu3w5Q4gc2oTfpFoAa4ZIm3S7JyPr1M5c7R84fcwtYAiNUGp1lb5q6j4cVoF04iLawqFNPgff+gGmvAWkLMNAe2mpbEFiHDE5hY1m3U+IzuGSA8xv5o0NT/dDWLMND6cfTkYSnnzXgE2v/lCjnU1rNzT9/aLLLZWldFYoCUInVbxm54EJNYSzqDr7jGHGHjnI5bW/fkEUZgWpR/5JDHmGhSId8kzeQK3sBOOBhFdBiLRKX2WZoTaboWTo7ZFIpcL4ZRTwlnngV+mt4KWSfa9YDmknbVBO+281Oy/vHpDujBHeqIPbRoXCUpqdLTQE5apEOeJgrdtQk8n/+ocQbvTdHed3UdwgDTHgX1g1nOHLdi+GXsrgfZml4SMBgDVEKKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(396003)(136003)(346002)(39860400002)(6512007)(6916009)(54906003)(53546011)(6506007)(26005)(38100700002)(36756003)(316002)(5660300002)(2616005)(186003)(2906002)(6486002)(4326008)(8936002)(86362001)(66476007)(8676002)(83380400001)(66946007)(66556008)(41300700001)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EqeYVG5L2t/i48IMvVakV0PwktWDrtZtoKuAzq3Abvv5SH4rp3gEK+O7t9fv?=
 =?us-ascii?Q?ARNgfyqJpLqxZ1kEaKKP0q035fLvK9h+ygNXkLxxjTONQ9jOB+dTdiQpYdUE?=
 =?us-ascii?Q?ChT9lVHX2pU2YFS03tGqqk5I3wtyKAD1ZdZwM2PEftYH8UjhZu4km5id6QNd?=
 =?us-ascii?Q?TsKvlwqtfeRZs39O82n741jzjMidWTeUNzO7VjPGO38p6plTy+aCO2VElVbe?=
 =?us-ascii?Q?6SQSJM/dxwlcLuzLatCxNBYTr28dRpVBEv2H0Do9IA+Y/FP0LWdbvCu3K6kL?=
 =?us-ascii?Q?IKFvRPnsz044l1td1AA8KnTTMLlG08OXT/hDrEitWtoMnwXJq8VZYGGiRCzB?=
 =?us-ascii?Q?hjZlY+apM8lZdetZ03GUPBM9Dqbce20/PXzkccxPSFPTg+IF1mVwKjBm+5e+?=
 =?us-ascii?Q?u5Wi/gvFJT1TK3PEc1vOEuK1TNfYnl7UG1iKUoGvRR/xIJCnmBVaczOby/ay?=
 =?us-ascii?Q?yjoiDe5YW/MRophtFBqDtQaPIV9UQ0Aw+YuLToectuF2UXgoo4QG5O1AgfCE?=
 =?us-ascii?Q?T4ANKR5TfDxxN3lzIaUrDnzG23l1phGXw5jLVNYDsR5h6JYrxCtdumTvjce/?=
 =?us-ascii?Q?IeXmgwhUIXyv7B5xTAbtP7KH/II67g2/zaQGJEOeITFTvChir8ndKw6Pxcsv?=
 =?us-ascii?Q?LkBiw2xbSvBM493qqtqN3WiotoLVshiuABP9erVi7BN55uIT89SCQB6Ck4eU?=
 =?us-ascii?Q?wFID9HoP3UqBKlIXyTcbNCL+t2zBQQh9vXhswaBrMBaqXOu9Y1zisb/7Ip0L?=
 =?us-ascii?Q?zXLUsNwkoDJEm2SrvkjfNq22B8mPjqurPwVYLGPHn13REjUUvHlhYS1VRMQV?=
 =?us-ascii?Q?08cAa2XCf2x4Dd5qoVGSi3ZuquBRpoaMwX+2GFhatQLNw/4JlX09juxb40Rc?=
 =?us-ascii?Q?lr/te32/Rz+NctPkk8xy5Vw1eAVOryyCN6zR95BX5UYFm6LLsSCdt8KrzPl8?=
 =?us-ascii?Q?Mq3S8x8+6Kf62STm/vSi2rJKed7m0EEt3A/lnQeGD7X+jk6RmFpEbOiSfIVB?=
 =?us-ascii?Q?a5Mz/lw+s7L5oozWqnVTclb5y4pAaMn3Lkw8MFAYuwON55qfloxz2W5oepxE?=
 =?us-ascii?Q?NagjXPmSB4AOuXqZYHBXyjnjwBvueB+WkCkMd3grDmwl5wNXT54zjazpQV0L?=
 =?us-ascii?Q?eDsi0HfzdmiguPwPUbr3zrB6OscRPFcGR/gkY8yNA/zZV8zOJrOVXlW9qlA9?=
 =?us-ascii?Q?vr0CLLTUbGdHTqSiUeZPYCRo3PbGg9WOJy4SSXWllhOsLiQTmzZA10CmqeHT?=
 =?us-ascii?Q?VIct7HUMY/p/SWmx4UQ4fVLiwurU6+RJu16iUs+4O7O09QbE6k6U3aUQQOXw?=
 =?us-ascii?Q?7hGq2FdGIAMIZG8DHv//Xzm8WfIcl9teEqBxCy/1WRWMK0UMBezejIjl72Rx?=
 =?us-ascii?Q?Svw3Pf7tuiyPN6KYg5HLr3uVx2P12nU+qXMNcEY739n+SL2GPerCyjdTOL26?=
 =?us-ascii?Q?6sXZ7/ZaxZmUEgqjQrTLFHq0C90dIP3cJDH23x6yAUXYfEpf1ch/Dqf/oQYw?=
 =?us-ascii?Q?kDpwhWRRfsXSNVBy9hJrNkVVc0k0XgamsTjGyxQoyLHC5cfH1R7pjXPIzc1Y?=
 =?us-ascii?Q?rzrjT3z6YV6NOFRcIT0L9nDK2zWklu1OVWyqKH+u?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ff4144d-dc07-46c4-66d9-08da927008d9
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2022 14:31:51.1004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TdKMDBu5fXxsfbSOtdYz57HryYAyoD34ntGl/fgZ4ZEiQf5y0Rx+cixDB7RIaAbL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6277
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 09, 2022 at 06:08:32AM -0600, Alex Williamson wrote:
> On Fri, 9 Sep 2022 07:53:17 -0400
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Fri, Sep 9, 2022 at 6:52 AM Alex Williamson
> > <alex.williamson@redhat.com> wrote:
> > >
> > > VFIO fix for v6.0-rc5
> > >
> > >  - Fix zero page refcount leak (Alex Williamson)  
> > 
> > Ugh. This is disgusting.
> > 
> > Don't get me wrong - I've pulled this, but I think there's some deeper
> > problem that made this patch required.

The basic issue is that VFIO is using the reserved page as an
indication that pin_user_pages_remote() didn't process the page and
instead VFIO's bad follow_pfn() path was used.

It really shouldn't be working like this, which path was used to
obtain the PFN should be recorded independently. VFIO just doesn't
have a datastructure to accommodate it.

Aside from that, most longterm users don't ever even see the zero page
because that typically creates that GUP incoherence we've talked about
alot. The ugly FOLL_FORCE prevents it from happening. VFIO doesn't do
this either so it suffers the incoherence bug along with exposure to
the zero pages :(

David will fix the FOLL_FORCE issue and this will almost go away.

We had a long thread about this and discussed fixing it by simply
setting FOLL_FORCE as other pin_user_page users do. This reached an
interesting point that I'm curious on your view about ABI stability.

It is related to mlock accounting. When vfio pins pages it accounts
for them in mlock. Alex says there are users that set a mlock
limit. VFIO has this historical bug where it doesn't account for every
page it is asked to pin in mlock, eg it ignores the zero page. So, if
we change how GUP or VFIO does page pinning in a way that increases
its mlock charge is this an ABI break?

On one hand users with an very strict limit may find their environment
requires a limit increase after a kernel upgrade. So it fails the
'everything keeps working after kernel upgrade' test.

On the other hand, treating these sorts of limits as ABI means that a
lot of internal stuff is suddenly ABI - eg with a memory cgroup is
increasing the charge on GFP_KERNEL_ACCOUNT also ABI breaking? That
seems unworkable.

Thanks,
Jason
