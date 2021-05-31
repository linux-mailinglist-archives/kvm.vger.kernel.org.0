Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E382E3963B5
	for <lists+kvm@lfdr.de>; Mon, 31 May 2021 17:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234260AbhEaPbp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 11:31:45 -0400
Received: from mail-sn1anam02on2056.outbound.protection.outlook.com ([40.107.96.56]:43075
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234666AbhEaP2F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 May 2021 11:28:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kE03I8fVj2U2dGZDmg58ZxxnujesF7KWHW1k+xIXYpugN4NHtoEcv2eOxsaLBGEDKXlF8IrIDv/+zzDOXcRBShXjhGPZ3yhfgTR1V1sABaGU1ExO+L+1Ap+07AT/u2iKpkH6koWb8+WmyiTGHBv1uiwKuc8lB9TyKtTbj+cikFeIcGl6K+ucW6CKG6m43ueAi6AbUJOc7rj8fUMcOIT/QmF2yXKF5TZ94g3tVqowEIy8b1CTuDZ/mMzVnADgS0AANjShOjLk9wl8HOM0f64ar7hSsUx6LOCFNlVAjY68ibMSQXjTY2PZfJfLWgaDUKegD1PE3+pdE59pmGRjfDQ+Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e12wfyQToVaF5KAm9FchRcWx/cbqIZQNoiusyqXFdEE=;
 b=NxmUsSUxJFHodYv9znFTxb6wqVKlKNEO4bXQNQRP0bUPOQnoWMg/t27itn93buOVOarDxD3hVhHvg6bpyYvZzD8kgQp93VGoHUgdskTJgFT3/9mA2LSTNSNH5ogPe0fPgnDD9b23hUNohJNh3zipFsgMySh3w+8rrEKbJFoEvCtibi69qDNmVRLZLKpBriK/4VQsWsTaTvIHTY7fs6R8nAhgP3025Q3YGdc4xzcNH6PIFD8MFlqRsfAZOTcNyt6gvDjlcNs7C35R+hP8SetgcnmH4VJwjc2ET4qu/+aqOsXYxqwiFqaxX5FdBB6GKWR3rVAPmRZm5okglcYVodOkUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e12wfyQToVaF5KAm9FchRcWx/cbqIZQNoiusyqXFdEE=;
 b=VTRp7COvgRKrWJsiQ/Ee3HVaUXid5sTiH207VQ/BgpsoJSWCvrI2YGEcx9desPWHWv0J2V8Ao3CTInW4zYeSTdP+FmxTcTGyxvZgrpiaB4nnAbVHBDnMt530Q8J15qrF7mSlGUhJdcCKXb4KZuXq7SZv6c3mrK2O28WMaDGiPpaMVwQR5I1xcKp/SGrR3+KGnQhd+nIfzMchp8iZQiYrtakOPAberrSBxfn8Q0/SwGOPmwZPo2EMAOnpXROU4F/79c82rhVKMdA0OU6bBOq0NMqwATnShn903BOFtrz8MiJdFN03q/mE3w0i9r0Iz5S63W7VyoUB86Fu3dds8BsIGg==
Authentication-Results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5352.namprd12.prod.outlook.com (2603:10b6:208:314::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Mon, 31 May
 2021 15:24:48 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4173.030; Mon, 31 May 2021
 15:24:48 +0000
Date:   Mon, 31 May 2021 12:24:47 -0300
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
Subject: Re: [PATCH v6 05/20] vfio: mdev: common lib code for setting up
 Interrupt Message Store
Message-ID: <20210531152447.GT1002214@nvidia.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
 <162164277624.261970.7989190254803052804.stgit@djiang5-desk3.ch.intel.com>
 <87pmx73tfw.ffs@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pmx73tfw.ffs@nanos.tec.linutronix.de>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BLAPR03CA0106.namprd03.prod.outlook.com
 (2603:10b6:208:32a::21) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BLAPR03CA0106.namprd03.prod.outlook.com (2603:10b6:208:32a::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Mon, 31 May 2021 15:24:48 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lnjmZ-00H9sW-Cy; Mon, 31 May 2021 12:24:47 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 448df1cf-6419-4ec6-b480-08d924483a28
X-MS-TrafficTypeDiagnostic: BL1PR12MB5352:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB53520D7C39ED692F0CD0B7C6C23F9@BL1PR12MB5352.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6t8MZCFaoDGQLHF9zDxHPo2YSktL30+HzSnbnqlnjhRyaREpn85wbKXEeJCDWPxmjwESgfd/U/HZQyve1+arVNpM2rM+ntfrTXvv0F8eajbBlvl+ENSge56xi208Ee2gKdIvlx9gqmrTHCYZ9C4r8soMdYQRccaUvFFH80+yI1Ap9YuvM1mhxyRswWb34eBjaqQzKOk+jinsih79kmhFUuBM1bi+FynvI0GL7ZvDjbQi/E8pXfffBpq/sgu3d6b7OF6VY3db3sdM2dbBbuXoegPF4tuA+fSD6fMn2S7d4uPfJH+AqTXogV7AapDjEXh+MCnc3zZuRHziDL54ZBNu8RWqcgwbuC/XdwatjXk6QaFcG42rgShm4nTPrReMVVe1qWzhLBWCw53WfZ0D7KakiIrMmo3KEP7/4P1Ao+WECIGCEf53gdqbUmpPcoGGxVg4c/y2oUpj/NZYpghctbYBJLUNr7o163DCHyfLTltHuHhdyIdQybQ5AuZgSvdMq2DJ08jsJmujfWIU8+VWXakAWM2Gde5zmr54DY8WJvc685+ZwihL+mMwow4eyznl9VBkkJmcNf2hs+Hm2ajIwUI2wHsBu5AmqvAp9nHkL50NsXA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(396003)(346002)(376002)(136003)(4744005)(66476007)(8676002)(26005)(38100700002)(2616005)(1076003)(6916009)(86362001)(186003)(5660300002)(9746002)(316002)(426003)(66556008)(66946007)(9786002)(2906002)(4326008)(36756003)(478600001)(33656002)(8936002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?pl2H4uaLduWbjHXaZ9ZrFR1P8lBGTlcAG62l5cydljaCe8rMahHJWLrqDkpt?=
 =?us-ascii?Q?UcMSAlR/CQE2NEYyTDH3e0oPcywjE0BDy8w9N2WoZ5TChsTM+P6SKrLsxcYs?=
 =?us-ascii?Q?Mu2VeLAiV1n960adPvBzc2qYMGBONwTBZdlllw/iyiVMfW8i47aEn3/GL44q?=
 =?us-ascii?Q?GWlx5/gc3u558HkVLHj6Ef5UJHcCz4QcrN2NkHTJujccV7q8mzRhcGYVdMJc?=
 =?us-ascii?Q?4sIL/tm6N/v9FJywIYm7bWc2nB4x6ShdlKXGYKQ2rb2YUX7N8ZzgrzXb4rBV?=
 =?us-ascii?Q?FIlLOFx0vnqxivJl3rnHVqL+jBDqIJE93LHND37tSkFOYzY33DGtsk8871+I?=
 =?us-ascii?Q?eZNvwXlE8CxNy2z7ls6EOD80hF5h3gTCnx3I7aQbYwCejGichRncEGnAdG2L?=
 =?us-ascii?Q?fNKu/GxMjtW9SWPtetIqIcroSoU2B5FqLMZ9cgU0OQeKBJeDC1cDjBGUqFjm?=
 =?us-ascii?Q?Nh3MZgZoaeEti/DHIHXjx5laVedW18vO9kOq9oragKuTC5dcmx0Pq57Mo6wV?=
 =?us-ascii?Q?ffLrbjD7ZdV6yX1JUSxDxK9MoAdT90eGR1S9cihZIotgfz3NnorI+Omztdo2?=
 =?us-ascii?Q?PYahRWPOvCEQKtUQ6JR5Fbx1Yb0+YTxK4Sfm0zHPNTXvqULGOqAWqTxeyC3/?=
 =?us-ascii?Q?z8cbuA0jUZrjVFZlSHZcP/8T0ebTtXqFfXm69AImVd/Os9ML1Ek3gEWSEgr9?=
 =?us-ascii?Q?asYK+NR8E2il03LyqI/mLXLxz3JrDhkMxMYsC1VqjFdEpCAV2wrrPr4WVDpH?=
 =?us-ascii?Q?jlSiM1zt3mzqp8ksD0GyUgYTjyoPj9OAooe7V4ktZeEjV33pugBigU15EbwD?=
 =?us-ascii?Q?6cIxfSrVZjvk/Qn7LMuZlvKlcACHuW+7qqZmEi/FyZa/t5/yqDghf6CVGVnq?=
 =?us-ascii?Q?BVGLXKzPS/0eP/3NxpKXeh6qr+ysODBgnpFykk5OikSYZpC7qFS2BjeJYcJv?=
 =?us-ascii?Q?aouSmblQzxUjSCDnhiFT9nibC4eb7o5Uj4GHu8raeLj2dGyni34GhxqexZOq?=
 =?us-ascii?Q?Fo68FCEyf9Z2VOn+Exa/NLbEkXmA3KT9aQa5M4I5K6E3dWx+Bm9ZONzXcmoh?=
 =?us-ascii?Q?rcQk8VUaoKqSZ0hgqteySkeH0io9OtFf+7cSlo9lFc1cm38MKgK6NYeV4VHz?=
 =?us-ascii?Q?j2QGJ1rMPxMxSnmqgUjH6/W9Ijhz/uCn1yjxgB0c/JvAn5QA1SEDTrYzKCJg?=
 =?us-ascii?Q?MemzRk2+cHl9pg796+pbbR0TiLPjCUzEd2rpj6C3IicWax7AA7AM7v/Yy3I3?=
 =?us-ascii?Q?9xHz93RhI27cHlUm8cqZ+ZzsWrZ4PsqIl/Q3zIMxpD5AUqjs9nzM5KeX5yXb?=
 =?us-ascii?Q?Q7Al+t/Lmap6bAhfMqTTGg99?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 448df1cf-6419-4ec6-b480-08d924483a28
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2021 15:24:48.3021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vsV4zQbz08GlEN5HjmOz5/2KWJUjjJC1JoyRXriYlcYU8gXDymsfuWxV4/0TObHx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5352
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 31, 2021 at 03:48:35PM +0200, Thomas Gleixner wrote:

> What's unclear to me is under which circumstances does the IMS interrupt
> require a PASID.
> 
>    1) Always
>    2) Use case dependent

It is just a weird IDXD thing. The PASID is serving as some VM
identifier in that HW, somehow, AFAIK.

Jason
