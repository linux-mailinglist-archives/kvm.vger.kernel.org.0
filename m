Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1AC33D69EF
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 01:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbhGZW0v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 18:26:51 -0400
Received: from mail-mw2nam08on2085.outbound.protection.outlook.com ([40.107.101.85]:50785
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233491AbhGZW0u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jul 2021 18:26:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F/y9wZdVPK0j8a2Aq03+Eak9L4of7/rjqft5RU97cg0Yfy6tyUcNOhsbPbDWiL+Q0qJXJpu0OXQkMBw8U21rBPMkZgP698A8NG7ZRQp3JjuCsdZHdPQn1A6ErK4jVoLnRlZVknsbROTvol0pv5jFYg0bGAHm3Dm/RuvRUaoPhHhCmh9Gx/MMH+JWAS+FcuJAfGI+9jaohMoZcYpQdj/9h04KMbVoEKkJ22Kagl4xw3Qli6WsUqfYDtJR7hb488a2lmKE5rWHBDjgNWN04HmpLWKfpLpyTZUvYH4WzPx3CTQyIrEbQE8vXm6QfoVBp90GshtmJj6GnoEm0+nZPzLFUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UKU6qfuQfDBauFjBZYJyp4X+SpR2ZDtH3w6cWb3L9sY=;
 b=m6K+pIjn0aQCiip4aELc3TIL/PgZMSSDW6eN/886LXiu1HmI0+mKgoDyBYYKM2re13gT6a+Mh4Kh2mQy/S6uiEWsXO/WhZVTCRC4He3/jUuvd2lagB+MZwy3HT03qEIAvNgxkm2Vlwv0oTADEQebF1AYnG8L1d9aLPOPXMv5UI8bSejzOAufBjcOB6liEhG3B1jQ7LznSBlnFyB/NlVe8qly5agOT6NxHMUvCXmKJQs4K7wCIFDQaekqqRrxIRgX4wHsYCePjXdHyyA7+szGM4boRWJKgXBX9Xx4KglifhcUFAvo5ZCASkGA8NrsnekUhNU2t5M4g7y+lUmHFe6kPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UKU6qfuQfDBauFjBZYJyp4X+SpR2ZDtH3w6cWb3L9sY=;
 b=na5UoiIevhy3ipWdHQ5hvvw1PJOuYzd7IuYpUa06gbPu4GVAtPL7oj5SdMXF++ndNfY7UAmTQC2Dk6tkbYRgA0c0dZiOQhA6ymUElDSodcqzDUJY5Z3Jf49HN42QXD7k0mlW/PNaPZJ5JSsY13up1ZykzMvSnx13i/XpQTfUErLM2NNR63ZqCnQZL81FuCxY5CnRCbwbekwoLOYSf5XAcnke4VmStdA6PZ32IRi2bWOcthIJqMcnY95NOVURGO6YxTL6XQSPgAIflF1thl8vwhuoLVudLE4LHAz5wm4vtLIjaM+PzLCjtKmfZ3TcmfzNrhsUYvZGU7APuqgOLYebWw==
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5110.namprd12.prod.outlook.com (2603:10b6:208:312::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24; Mon, 26 Jul
 2021 23:07:17 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482%4]) with mapi id 15.20.4352.031; Mon, 26 Jul 2021
 23:07:17 +0000
Date:   Mon, 26 Jul 2021 20:07:16 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] vfio/mdev: don't warn if ->request is not set
Message-ID: <20210726230716.GC1721383@nvidia.com>
References: <20210726143524.155779-1-hch@lst.de>
 <20210726143524.155779-3-hch@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726143524.155779-3-hch@lst.de>
X-ClientProxiedBy: MN2PR15CA0030.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::43) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR15CA0030.namprd15.prod.outlook.com (2603:10b6:208:1b4::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend Transport; Mon, 26 Jul 2021 23:07:17 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1m89gq-008qdC-LD; Mon, 26 Jul 2021 20:07:16 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d884121-ba37-4b44-2340-08d9508a1d44
X-MS-TrafficTypeDiagnostic: BL1PR12MB5110:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5110314CD216C14698CA3935C2E89@BL1PR12MB5110.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3SDGZV/k91MBBjBhel0FlNJWXnUjM4T2cPFvVoDnwWHoNKElc+t5mnX++kbzCCM2QpYSGTjxWbMZtxwa74vhTq59r0Ft5rp0vZksu7n+bF8CSlh+hdBp0Ktlt52oP6ZdKizHRcIo9bTcHMJF5GzvkeF4IUdANezLKcO5yqh4JeoAseatMs0zw/okrkpN+cMvZmQ76bOGkhVn9CkoHqN0xtYo93uFy0Q60R6fJryQXqaSOWRvAxqZl28bStT1Uzm3595ntdJOaDQovFww6nJQMAv5DYwbhSjh05YCTCRbkE0QiXKfIzghLWFq2TClAPgN0N440WGwk9REE/uSjX5rYdSwuZ1oAptduWyxN34GZHKBQjY08uOE98Pz2NdF7UO/Yy+T9aoCognuKizCJdVeQ/AEW6PhxKGrSEXIvaIGlSe6HnmTPMrDHt/ddOs4jmcmW8Pse2VoU/ja65S5Gnw6LP6JYpGZOjz30f0Ld5zGUU36wXJuYQKP0tfhga/LVEKcXDE4gIs5cZgyknB5adNBsA92SEgqFqhOESggin4/5cXSMf+n2obVwVB54vP4Da2GCB5uFu/ifoBW7pgri6aQtJ5rHYDRyNa6o2QIhIuWrBhcUlQq/EDqpvJXcIvqtu/N72BfqxxD2F3J+hd93sgb/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(366004)(346002)(396003)(8676002)(38100700002)(33656002)(1076003)(8936002)(426003)(86362001)(54906003)(66476007)(66556008)(66946007)(478600001)(83380400001)(9746002)(186003)(4326008)(4744005)(9786002)(26005)(6916009)(2616005)(36756003)(2906002)(316002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u2JNglhS7svwijVQrUz7t1YVtsG4sx29Zkg4U4uDQsxidD28UHQhGwRroSJQ?=
 =?us-ascii?Q?hZiOgekDUYqY6cLwkGYKSNxqvA775cHiSqv/Du8tS7LCXdZtJLVMZ48uAH2l?=
 =?us-ascii?Q?latUwW686Bw56bul3PChHV4MpSWRlweAoS/UfmmLuAxE1CF/V/IzNC/cjEMp?=
 =?us-ascii?Q?4vHAgyW+OJiJoXDtXjX2yHXKodSZ9dSo7TB1uTH+E30Fdehitwinu8PzXLVr?=
 =?us-ascii?Q?g1CLvlXMSpxkMNE0SkN453V7rOwbKt65CCerv1JPyY4GpoYSDmaQeTC3uobR?=
 =?us-ascii?Q?dCmAskMh7ppnqhG7Gz4RHbGSg8112Y+iHMpNX60iy0TstaF2JRSoMQ3/csKY?=
 =?us-ascii?Q?HVZrCKZbBgC6v7Saw45y2+nsgIIhhf2zt/jYdR9TI76qvwCN9HnJLEDBOxo1?=
 =?us-ascii?Q?cjhM/w8b18mygvr/iKWEJz/llX2yCa30YqEepBb56/jgucC0OUqkAA2NKtL3?=
 =?us-ascii?Q?+Uhbaj01fq1vtI1+c/KsTh31BVt2nBGjC4tA0TjcV8blLsIGYjKCBwZ9JWTw?=
 =?us-ascii?Q?SqAytYA00pbiHpbarnN9oI3rUMp/VIvOWcd/3L/+2ZVwwoVJwCs3qM1icc0h?=
 =?us-ascii?Q?D1TNfzcUFkD0muexV2tt0v2hWEdfloMO+KOQN6dhM53nu0y2fi0N6rXv5DsY?=
 =?us-ascii?Q?QO3g4ZxakqhhWuDjujUAd4fc3aiCTgaa9KY+c2PfTwOEKh9MwaFx6WIW19I9?=
 =?us-ascii?Q?kcOpQajqm2Vuxd0MJ42zPfp+aAjOQmsxMmv/rytULmVEmRhiYT8d+7+xWhhO?=
 =?us-ascii?Q?xGEMv1+RRtzL4wOYGWYqMWKaobGPEjr9z0+pA/wAlX47gB+JZIyKePixLgX2?=
 =?us-ascii?Q?yOUXZzGHKb/1J8Mnj7UqM1w8M3JKBg+ZfO1aaMSRqE13KuyKtNZUITN1IBwS?=
 =?us-ascii?Q?Xg+lHY5EPL8XoZJJDpgwNro+5NqQTtirzs42cneLvwCtCrOf7Mv0Cw9ecqlf?=
 =?us-ascii?Q?ih61M0qEVX+1pkVpjGh5Z5XmeZh1By1F+TGLR4gdAl1j3mvJLUvLvbhniT+L?=
 =?us-ascii?Q?iUblRJXtKICTaQ83SD6zADYFfPx9OhAeQi+GqiH+dTVk3pyu+o+npCvpdO9a?=
 =?us-ascii?Q?gyAvVMyu9KUZ+iIr58ZXmzqjW1qFCjs8P9gnjEgvCDmYoYjk/UUuZirQ4KZg?=
 =?us-ascii?Q?uxyf6uJUu7zEkIrGS3QXGWYvmmQb3VWgZuZCByHz/CitZy+z8qNnZ+pzZ9xQ?=
 =?us-ascii?Q?hi9KYKR6PlTsuUC3tqoBTW5JX3ji2n/8xfDwthXndIXl/2ajDQsGg80c0GPS?=
 =?us-ascii?Q?W1qcPnQxIMYsPWkUMNbWOnhKddD0P5I2JEETFqUtclWDGiQ4EIdGQzSdAibQ?=
 =?us-ascii?Q?e14ksCWVw6SjPjTxDrnbdPp3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d884121-ba37-4b44-2340-08d9508a1d44
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2021 23:07:17.7613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sk96pC3eJ/WLU6gMmz2x4JS+E+825rrvC+uvnNZ4ncUTYnOJ8J+R5VwPRjJkqGnc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5110
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 26, 2021 at 04:35:24PM +0200, Christoph Hellwig wrote:
> Only a single driver actually sets the ->request method, so don't print
> a scary warning if it isn't.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/vfio/mdev/mdev_core.c | 4 ----
>  1 file changed, 4 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

