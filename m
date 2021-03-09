Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 544273325AD
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 13:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbhCIMqo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 07:46:44 -0500
Received: from mail-eopbgr770041.outbound.protection.outlook.com ([40.107.77.41]:3390
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229544AbhCIMqP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 07:46:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nzZ0PMx1lIXmNUkiKYymnyJoL8c48YAK0akPFHJQQdqROeK3bGQHtgyZpP3TVKjDzsZfoh5Eo2bRkmMKRkKkRotshDUpSdN+cVbrRoMoYTYGCafZ2vdOfwqal2GRjcxg/kDEDM/NhqWgKYDoQNPGEoZvqqcSt8tzCs6OmwalXf/KdHJ/+V84/SpA9V44LQsrdZqWzGSK3qtbGzvNgtu0UrNgkXqgPN1+yiwHUYUziGA7T7pNQhTIOIId06CcpZoiw0jKRUOovmioTQlvmRDjqsmSzXc53kDktgQBMPrsB0zoLUfxQq6dsLlvYChECfsfGeIiHFwC2MhqXkIsqraUTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sYpH1ne6ihC0NC7OJaGf1xZoRSJWxUnMgQ/tMmuIMks=;
 b=l8GDG2ybPy6uHYJ/UHxo+URfGfH65zEFUOj58LdgFUh3wYyphR5ez6Lx1UiONJ8lGtvRAauzBVl8FAoW4upU//UpwKD90MU9EdhRW4om9NzHJKqb/PYSgbnKfdTEaAmw2IEwqqgPLnkEmVVL2C9Jgfr0Jsfq/WHtgZ12aSmOTtzeip3HJ6QAofTd16uQyUTCjKjpvw/TAwov+A71ZGaS+mlkPDvhjSg5TXRPsx8c7kL3GKCGGH0s+MgAUS/0FN1xs884pcxoubB0cfLAc9RC6J8QwT2hEjkc6NFNLZuZdKWNrl1wbmcdEP6aCqPWBBnTEuHnX++D7z4BRBaAhfauxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sYpH1ne6ihC0NC7OJaGf1xZoRSJWxUnMgQ/tMmuIMks=;
 b=jxhMwG1GucZ6QY8vwkr5mndEqZVxBeElTUbsj1zgtrc4gZM9q1kUiUdonXuMhByWd2jgyym017uihM1osx42KjAPTONqW831xfdvrnhywsbv9GoQTuJVMX1DJjQSqH5lrXdbfQPwLtrMGx19FZGw+WO3OR5kRVlc6wCqGWrUNP42iknBGfZjdEjnw5FMhL4mGFFtREAgYkZBx9w8YaC9qO461ZXMJ/RqhGU9RAEbm3T/P0Xmp1zvrwAxzczFRj897bwh5kVyH2+havU0mDVKgKA/n1o0N82M0q/hHrOpMOUqEEUmfQmF0cprO+xUxal9ATZ73nFCyln1zveHu0baBg==
Authentication-Results: hisilicon.com; dkim=none (message not signed)
 header.d=none;hisilicon.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4012.namprd12.prod.outlook.com (2603:10b6:5:1cc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.28; Tue, 9 Mar
 2021 12:46:11 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.027; Tue, 9 Mar 2021
 12:46:11 +0000
Date:   Tue, 9 Mar 2021 08:46:09 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Zengtao (B)" <prime.zeng@hisilicon.com>
Cc:     Peter Xu <peterx@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Jann Horn <jannh@google.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>
Subject: Re: =?utf-8?B?562U5aSN?= =?utf-8?Q?=3A?= [PATCH] vfio/pci: make the
 vfio_pci_mmap_fault reentrant
Message-ID: <20210309124609.GG2356281@nvidia.com>
References: <1615201890-887-1-git-send-email-prime.zeng@hisilicon.com>
 <20210308132106.49da42e2@omen.home.shazbot.org>
 <20210308225626.GN397383@xz-x1>
 <6b98461600f74f2385b9096203fa3611@hisilicon.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b98461600f74f2385b9096203fa3611@hisilicon.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL1PR13CA0234.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::29) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0234.namprd13.prod.outlook.com (2603:10b6:208:2bf::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.23 via Frontend Transport; Tue, 9 Mar 2021 12:46:11 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lJbkX-00A439-8V; Tue, 09 Mar 2021 08:46:09 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff539f98-eefb-4a30-7474-08d8e2f9515d
X-MS-TrafficTypeDiagnostic: DM6PR12MB4012:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4012913D4752E987F82F8C44C2929@DM6PR12MB4012.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QkrlaYEtEUR0dNVgdu3IjTv9IM40FrKrOX0HTYoLDUv1WqQ+T/XqUmMFql6eoJI+WEKegFGEnLB+CStg28JS/lBQrnI4oWMcBFEAeq4v8CSEwkA6I/JC4TDm/QrKZnyINlbsPiUibMNTWW7CEXs/n/npRNks+pqNZOrokYLYffyxsWA/NjQkr3YDO+VFktCPwbZy/JuiQ41aig7ezyvJ99kMzO56oX7aiKCJX7kDgUMNZvR+I82r76tD421Vrc6txky7y0Bbjx9YLD0qlidzMM3YO9o912PSqYkkKf54RrwWEIl9l9fEXT2axjIGQFvKYHOiPMPnbSRtEe+FOkEDimp9yRwj3mkuiETgGMSWw5965QMXUm/1ZAqsXIqYjcZnVIBUAqwTeUn5icrgjGK2dq//4J01L6eawMpzTuxXPkdlEekRqaANHO1+mNkQJ9nrffNZhnkzJk0clTnPi02WzL8NEIIUgnG+8a2MYnSPOH84ifYmtfBKpZhG5m6FMCOLyL1mUceik+T6MIsdv+47sQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(39860400002)(376002)(396003)(8936002)(26005)(5660300002)(2616005)(66476007)(66556008)(33656002)(426003)(316002)(4326008)(478600001)(66946007)(7416002)(2906002)(224303003)(9746002)(1076003)(54906003)(186003)(86362001)(4744005)(36756003)(83380400001)(6916009)(9786002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?sQnm/gIvDX/jykutQCwQlUSx0cFQEbov1erPh1QqBqY9MMVYBpl0XXxJs/tR?=
 =?us-ascii?Q?nJkDLAG9uYckSqNEQpmRO4yOsWN+lKRDAwL60GtTrE1wuByYVFQo1n4lroBz?=
 =?us-ascii?Q?9xzIoXfEEekm1EKEjILm/c8e/4KtOt+Ry6Bml8uxcxr1BN2I8fu83JPB8gPf?=
 =?us-ascii?Q?LWefPtGdpClIZSUxkpv+9y9rlezWqDUPf0AWNdwrbzazwV+Iw7NyMpgDTRMZ?=
 =?us-ascii?Q?AFi2bcWw4KbSyYL4SWVvU1JDaZK2PvI7syrVnyVVmmBfIjbmVAVj++6LDQ4W?=
 =?us-ascii?Q?oWUuN9WEqmlDv0R9VRxM9oj+UhDFjgn6pf00Mlfk7KlYZi2E2Ny1Hwvv94Qd?=
 =?us-ascii?Q?4x+XUA4d/jslyQm++AcS5/VSSaDpLV+zsD0sIx3WzmKztRddmEiQT0bU3nov?=
 =?us-ascii?Q?U2bl7wh43U9dNq2WJcyUgOB2ZxZSKsjcMLY7f3AjbYphSbpoMCy0gDmPYCJF?=
 =?us-ascii?Q?JVbRuc583xwe10XgYjVyTsz1sEwbpTMQjbDHOg+/T7I4ikgFcD/Aol6WvToX?=
 =?us-ascii?Q?wXe+t1/7FceHzA/KoHZG3HfW/169pmMBCH35NZg0HfUhrP1EB7kB6Yw6oQXF?=
 =?us-ascii?Q?GVfPL97yy3RC1VUXjTRQNnUrUCC5Nz+PgzpNlp95IoRjpRgBhAfNGPMgdsCd?=
 =?us-ascii?Q?1im0EKxyK80ZiWBqeMCh4PqmtSzVdI3YEDny3gEXFJeCrx5gBPwkdCx3Jvqh?=
 =?us-ascii?Q?RFLEpimm2YnC/YuSzlxsmK3sxHhPqNhpTwUsR0H0kYc7pLfSS0d4XA0lOgHm?=
 =?us-ascii?Q?/V7lGOcXSM0reGsp8W+s0t/9aTd0TDMyyuZVFFyOsSdR2w9IFeXBVc2Eprmy?=
 =?us-ascii?Q?tlxZ0OCZ36eBdfbI99ZMHgje16ke5H3BtaYedTp52MWsambHi/bzeZJbUNPU?=
 =?us-ascii?Q?JCALMwDWaLhp6gp32yJQ9yjnKx2x1BMCKwEwMHFw3T17qGZipjrDUZK6f2Jw?=
 =?us-ascii?Q?fntPTT4fr4yuPbrEbPW1fNPu0mqqr4BQb+BDoIzf1ixIMSSyoj/y7dtJ+PNR?=
 =?us-ascii?Q?DtSyMmMnOI9rHk4+FEHXdKN+5ybXRYVhSAcWP4UROxZwN5Et5YcJ8fxbnJ4s?=
 =?us-ascii?Q?eTsp6YJm5+SvUvZJPx5X7c8zGfh9zaiaD6fw9CM6BAW5CtCumqWNFlvStoEz?=
 =?us-ascii?Q?rd2uLQaFwgZCpwO9wIWoL6g7Kg8zfQNbl4EXx+m1JIppCtRTtU5UnX8RwJC+?=
 =?us-ascii?Q?ISl+Xz42k3lKtsOCy7UOfFvvMahpqnhVOGBcgXJ3eTnjLxblMraIoVEvKr+Y?=
 =?us-ascii?Q?5SKmEKRPNgZ6GuxsUjS14JzxF/FqfE6HwLn0qusYWtq/LVamlpGvy0RIMgy6?=
 =?us-ascii?Q?BNFhI0fLDDH8UknDltoWzUIX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff539f98-eefb-4a30-7474-08d8e2f9515d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 12:46:11.5866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uofv1Ow3A7wx093EWS/nJWnzTguLqDnj6SiS3DFd8wxUwXIDhcmOitBBvrFtyUMf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4012
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 09, 2021 at 03:49:09AM +0000, Zengtao (B) wrote:
> Hi guys:
> 
> Thanks for the helpful comments, after rethinking the issue, I have proposed
>  the following change: 
> 1. follow_pte instead of follow_pfn.

Still no on follow_pfn, you don't need it once you use vmf_insert_pfn

> 2. vmf_insert_pfn loops instead of io_remap_pfn_range
> 3. proper undos when some call fails.
> 4. keep the bigger lock range to avoid unessary pte install. 

Why do we need locks at all here?

Jason
