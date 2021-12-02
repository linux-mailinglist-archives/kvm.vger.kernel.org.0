Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558B9466950
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 18:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354749AbhLBRp1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 12:45:27 -0500
Received: from mail-bn8nam08on2081.outbound.protection.outlook.com ([40.107.100.81]:54369
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1376441AbhLBRov (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Dec 2021 12:44:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K0dNrDFh98sf+pt3aizHLngGXeNsvyneW9JXLKnqdB4jgblWdqG7dugxJ7l369zxyyzxqNFmx+3tkoyB/DwtWI1IpznJAKKrGelMKBKuFGAaN6cDaEzB9eJOy5GzcRFIaustZ3peVOr0h0xFSOKk7Ia/3wV6OQDrdiky6RVk1K1Kic8MdClcHR+wxFSslRRG+5OdrJbpZQVkR8DggDdjlKTuna0h7tbKyzhoGOarp5WqrnwVYfzzoikuPHQaW7tbhmXrd+W94ErHpfNdSohsdar9TZZJJWMM9jZPjhu72jdqqkLIu9apnFfTdl8iTkH2wmx/ntnDUtJ1Pg/VpncXxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n1nt2P2Quj5cvAFxcbjvONBTEk3oHsIaWRMJR2KR5ik=;
 b=IDq46pwu6pwX474RWBRhCGdY08DHtqjUEC6kN9XUIbmYd48aDe4LqgBhzYeS5ZzgZsyQiXJ2Hw8DYrviP+gE2LYd3Sn/UQ+F6oT3HVbKRG59vUCD+OUKQPd5EQOld7jcd8YwdiBr9+18JBD4dHBO13/5GXsFFLmvlpupBOXgsJ23sFACb9ZfoVefMpZH5rskfkyjbRw8ASzJcDYyYuVMxGB3bFfuxZKEHqNSJhEYc/bgPiwaJUwRKL5ge/+DvTM2PSnRzsiiiFNNYJvbccHeFIm/RMlc1vPJOVvwiV+Do1fr9cFjpbvfXeablmonkuwvkj1LUC51WIGxwsMiFf+Y+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n1nt2P2Quj5cvAFxcbjvONBTEk3oHsIaWRMJR2KR5ik=;
 b=BRlPGw2KIOE/ZDroxYIvJTpp5JyrspxSIm9NfkDUcDvrvghVhV+uKFj93Sj/S67kEBUc21ZF9pVU0okYjWciGGbzbekrsoD8QtX2yeOf/wVauI15mMVHAuzXXn6DpRcYeIAmIZpHq5hIkGobjUTk3fGETu9PhpLY0N059SG/b9tXe6pXBovnICBuCp4TH9rtxb5W7RQFUStc/H2zX3NoBwMMjo9VxgjsKopo/zZlplni3VfFrCVTgmU0cSNCBMJsF7/02zBHmpnHMIN25FxtuYyZzNg2hgdd8HPUFQ298o7MtBX8Y+zYPmt79BJ1EHmngFFf0Y2ZxUOcZR+TdwLMFg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5380.namprd12.prod.outlook.com (2603:10b6:208:314::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Thu, 2 Dec
 2021 17:41:26 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11%5]) with mapi id 15.20.4755.016; Thu, 2 Dec 2021
 17:41:26 +0000
Date:   Thu, 2 Dec 2021 13:41:25 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC v2] vfio: Documentation for the migration region
Message-ID: <20211202174125.GR4670@nvidia.com>
References: <0-v2-45a95932a4c6+37-vfio_mig_doc_jgg@nvidia.com>
 <20211130102611.71394253.alex.williamson@redhat.com>
 <20211130185910.GD4670@nvidia.com>
 <20211130153541.131c9729.alex.williamson@redhat.com>
 <20211201031407.GG4670@nvidia.com>
 <20211201130314.69ed679c@omen>
 <20211201232502.GO4670@nvidia.com>
 <87tufrgcnz.fsf@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tufrgcnz.fsf@redhat.com>
X-ClientProxiedBy: BL0PR1501CA0029.namprd15.prod.outlook.com
 (2603:10b6:207:17::42) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL0PR1501CA0029.namprd15.prod.outlook.com (2603:10b6:207:17::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Thu, 2 Dec 2021 17:41:26 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1msq5F-0072NJ-2k; Thu, 02 Dec 2021 13:41:25 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e36cb96c-f384-4631-a5b3-08d9b5baf730
X-MS-TrafficTypeDiagnostic: BL1PR12MB5380:
X-Microsoft-Antispam-PRVS: <BL1PR12MB53809EBA8F3E713B548CF550C2699@BL1PR12MB5380.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0tlJdMOOocoL/T7ku0dfq743y0Xa/5mQQyJwY+ToNA+UDSK3ugDDGwz7SKgcYbJnXpcHz4SJKEPQOkEU/qxm5brXXl2nzBoBwngdzblTw0K3k/Ofl1WPoveVPI9AkfapdUSIl3eJKb0y5vIgJcnAtA0yGm2i+SIDv++L8XycI8um4bAugvMaqCBv+eEPt0Iw5z5VjHBRbymGw9V7vdLuseTegkjQ0EHSTmaoEkfH/BA019G673ZEbjQwALjWwGsq/7/pptzwMKIXvUfiF6l3J+ZB0j01UFsVvRPxHz2BylprE6FvjzXNL3GyaNv7Eflp+1vu2uRy7ly2Z4LVnQ3CvaNetpFpAJq+IhpJ0yOHIn3e+kxMV2Y4d+CHhzgvLRxKgozzWD6MMXfcgVeo4EgCxyX2QmbuHmjOsGt+gU4tj5dHpIcxumjFmXSnS7L2e+p8evR+NX9ljGs+VNIApLBW8TjBB2WJnJVmgGikjhQ2WYBVK3GOGIEcSsgSlkoub2CAL4awb69eiCHoCer3jP/mSiUVBmG/6AlVDKApAHpfK1d9sfDlCGN7CQcebWAaZ5zFlBxwWhR4H4tD2n1IzQSUplbz0tDnOi01f8pTv07dkAj1VtW5D6euIw+78X13BLrz+aW89Ml20t3QQyBHCeZVWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(5660300002)(2616005)(107886003)(110136005)(9746002)(54906003)(2906002)(508600001)(33656002)(86362001)(66476007)(8936002)(38100700002)(186003)(4326008)(1076003)(9786002)(26005)(8676002)(66946007)(36756003)(426003)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5dCu/Zz3qYicxmYXqw49hfSsvzD6n84Fr7cdkLeTwYsEUtKGyxhtiXzBf8XQ?=
 =?us-ascii?Q?GWc/OHql/QGk12oE2TvRpT7lRVx6KNdzJ+4AMCmoFlob+NcXLYPTRF54O9Id?=
 =?us-ascii?Q?bp3MB79DDabe+Mo2dMHbrzJOCiHeKe/P8IZscE0KO5srVVvZv97FSMAj3l7e?=
 =?us-ascii?Q?go3jgGbXjjHYmr3qFQcZCw+W51ES6qzHqCmI3FY3Yw8RI/+0QUWbgM6bzNnE?=
 =?us-ascii?Q?rgp18snjrNWnK8ULJ4bwPMtim7nKePzZCisdnejEpQCY0atTwTneT5kLWGtH?=
 =?us-ascii?Q?SD7dg1GK68wTpKTgYb1p68ouyQaXVtL9LGU5FLHlooWIOC38mqvIPy3qCQBH?=
 =?us-ascii?Q?V8245XiiMTnr06Pff1UrQcOYsCw0i1IMHPlCxds7lZnR6Z2uI1YTJRmHbBiM?=
 =?us-ascii?Q?0gmx0Y59hVqgKsYO8bW+PLBAfZ9vne9F5JEL6yf2StSaBXR9tHL9PSmIw4XA?=
 =?us-ascii?Q?KWbdqVBWGvaGUuismSkAC82MYJ49rfGIPnGFrTmvsAGFlMNIjqn7BqNek/0s?=
 =?us-ascii?Q?sGR0oeUw78EmFzIBPsFxPFKzvRUAgb2IYjksbWn1N0mhlxTTrrk/ho7yLIjp?=
 =?us-ascii?Q?4CB6H5Oyuck9bIy6WJQVIVjNDyKREpLk8xtZz7xIRPcMb5OUttH2a8bo67xI?=
 =?us-ascii?Q?H4cEROAyGadDlaV4qwY8hCpT2MxqIelTE9p3BCr4BeB3MFuK+piqeMhKfIKE?=
 =?us-ascii?Q?YTHCzoAgRK/xwGYMNIFlinSN6rQjS05WAnLWOOTMGI1FlkiC9b/VSXJ+kuGF?=
 =?us-ascii?Q?IDvv5yWd8eZALkqI3jZDqtRu6bK1Q0owfOOS0I17pHEEfSC0MgnC+d187G57?=
 =?us-ascii?Q?6zDWw/9eB9MrdH57MgJLZZCO3U0kLaikzl34QhQttE7ma8POzqPO7rvGeiBw?=
 =?us-ascii?Q?sIg2ukMUFXsKI6kLumq0r0lpF+ASaoDwOmNFQGef5l02+8K2pmdBUSG1HA0A?=
 =?us-ascii?Q?hkxtEhtUXaiPozRgeyTR2mcHpA1OGPdFe4YREiuQ3vsOjJKycAViNZ3LQUa0?=
 =?us-ascii?Q?rxqpKYMWLadkA1oTrWOYR6Q/1hCpTibKuduCe+h0iOKC3HndZGuux77cmMCT?=
 =?us-ascii?Q?RMDYAP340s8EAAX0f0atAV+zjaYQqCfVp8KxSpv7JnTtWdhs918UgyG/VKqk?=
 =?us-ascii?Q?sPxbgb0VgP2cwkWtHIxTJA3wNMPn8qzCZOcl6q9kBaLv+/JbfjOQ1tc9tHNG?=
 =?us-ascii?Q?/rIsFPSWwRqn8yNchtwxqH5hdQ4b51XqmRGMzdqgaQbAekpG1qIazdKApFNe?=
 =?us-ascii?Q?iBl9nqzdGTahkxEKbBGpsjh+RvHtbR1I8CyYTdmJUUtKwf5ntuumrE5UAYQt?=
 =?us-ascii?Q?1jkKdGp6f/n1lAFXjjc0bniXmwwlngDMVUSqSUuxt0LfsxpqeHeVi79nE2UM?=
 =?us-ascii?Q?TmhW/vxJzE48BcRbFJgsD0a6BqZxQ4Gaf2lhKznZTKoz7/H0PjTMLN11DLgU?=
 =?us-ascii?Q?8k3/Ll9gahNjwVl9cGGHR/LJhu1isExOYkdsUU/mMYvPXXXP+AqJ2w/pwe4P?=
 =?us-ascii?Q?KWUyvQnmFpj2aTFqoUs7mviGvtpMh5/VLmB8j/Zqg1uwi2u7kxvihfMXJAba?=
 =?us-ascii?Q?iOpg33OetYxezL0dhtA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e36cb96c-f384-4631-a5b3-08d9b5baf730
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2021 17:41:26.7059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S8DqUBPCGAblJrrrsnRgNGpT0F2R8CaZ6BqsNJ0T9WjUY1QCs2H/3PFjDDWnQL3+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5380
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 02, 2021 at 06:05:36PM +0100, Cornelia Huck wrote:
> On Wed, Dec 01 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Wed, Dec 01, 2021 at 01:03:14PM -0700, Alex Williamson wrote:
> >> But if this document is suggesting the mlx5/QEMU interpretation is the
> >> only valid interpretations for driver authors, those clarifications
> >> should be pushed back into the uAPI header.
> >
> > Can we go the other way and move more of the uAPI header text here?
> 
> Where should a userspace author look when they try to implement support
> for vfio migration? I think we need to answer that question first.
> 
> Maybe we should separate "these are the rules that an implementation
> must obey" from "here's a more verbose description of how things work,
> and how you can arrive at a working implementation". The former would go
> into the header, while the latter can go into this document. (The
> generated documentation can be linked from the header file.)

I think the usual kernel expectation now is to find userspace
information either in man pages or in the Documentation/ html pages?

The uapi header is fine to be a terse summary of what the ioctl does
and some important points, but I wouldn't try to write a spec for
anything complicated in a header file.

Maybe Jonathan has an advice?

Thanks,
Jason
