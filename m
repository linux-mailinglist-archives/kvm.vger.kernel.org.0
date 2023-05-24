Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE9770ECD7
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 07:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236013AbjEXFE3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 01:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239193AbjEXFEZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 01:04:25 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2070.outbound.protection.outlook.com [40.107.244.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73631B5;
        Tue, 23 May 2023 22:04:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nXjWAa8mUMQILB6XBWQfwqZu/QeQ9kt3V3jbcAf+i56As/bei6jK7WpyLrQ1WZMg/rydbZ5MbzELndR0g0AQy4w/Y2RT/OjN4OcM3iOOOtb2h7GkKJwLUBhyTkqweVsPKag8pz9T4ipVofVECmRa9ZikRzveR6eU0rfk//wyalYLQkIyF2ePwTaTDp4UBO5kbE6SU8XhzBCCqqH0Dmk83QH8XMq1BYJIBsZkGwVg+O7CpkKyvlF8oc6kiJGPh0Czkw+oT6vwhwERxh6aOgEVVW0spHAdg69AbsxHRsnaeRgUapw8bB86HvohoYqFf/od1aNDWfGqaeBtHzFPsk77iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fCRcoXi/Beeqvmzl7HjYXsewwEwMG6bjDuqxqCysnW0=;
 b=LuPyPJS+F+bs26I4G9VlCFycH5B6PXUbH0NjAVWHFc4yAaT/swAqbVUc6r2vmMaJc4ODk/w0fxL7DCQmtopVtPoQAzmzz0CLVBebdjOQtsQq2MYeBEEW2KE7r02dFgRPe9hlLsGPHJ73HRN6mPi/LpYpobWWheso5QQ5AI9CKr0pCWmIU1q6nrwZ59cbTKPfL9BJ73HrxomEnVOy5dpnubG7ua26AMv5GiZtXEwCqaC7eXdMREw1zgigmZ3iQy3NeEyuNgdmleHz9PPRE54W/DBp6G6ZMDcoica1c6s5/x5BuA+dkwmxviSuJxOKRGvY+ohy14Trb+leTp8/wa0zgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fCRcoXi/Beeqvmzl7HjYXsewwEwMG6bjDuqxqCysnW0=;
 b=Abbwr9lktthFngDICve01heP/hWngSMTZrZuO8et9WUWaD9CzFeDefpI8NvM9Zuy6LVIWbP5/EeGzuV/w4CsPtb0hRfv7MlzwnFZhTejrSNTUYxCX/dC1+ccuLwas9AbRPYO1GMLeTLERYt6jOm9v2M3HDmSqch5bMFcKUfJ6O7SKr6RPwTz/f/pSTDcSaSIhmBpKlNJ1stTmhiZtNFnRUgGsnxykTHCf77eKXOTRjI6j9wfOYo7+0XLWoolv1UhCDyFbft04Qgs3Q1EMHwXjzkkcwFc+JFcV5o9/4MJbpp/dqnENs83AefEw4AJem8Sgo5YR66N+cOxvEG8m99/5A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3179.namprd12.prod.outlook.com (2603:10b6:5:183::18)
 by SJ0PR12MB6783.namprd12.prod.outlook.com (2603:10b6:a03:44e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Wed, 24 May
 2023 05:04:20 +0000
Received: from DM6PR12MB3179.namprd12.prod.outlook.com
 ([fe80::dc79:d410:23d3:f718]) by DM6PR12MB3179.namprd12.prod.outlook.com
 ([fe80::dc79:d410:23d3:f718%5]) with mapi id 15.20.6411.028; Wed, 24 May 2023
 05:04:19 +0000
References: <3cece716fc09724793aa832e755abfc9d70a8bb3.1684892404.git-series.apopple@nvidia.com>
 <20230524114859.000016e3.zhi.wang.linux@gmail.com>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Alistair Popple <apopple@nvidia.com>
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, will@kernel.org,
        catalin.marinas@arm.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, robin.murphy@arm.com,
        nicolinc@nvidia.com, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, jgg@nvidia.com,
        John Hubbard <jhubbard@nvidia.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 1/2] mmu_notifiers: Restore documentation for
 .invalidate_range()
Date:   Wed, 24 May 2023 14:57:23 +1000
In-reply-to: <20230524114859.000016e3.zhi.wang.linux@gmail.com>
Message-ID: <87cz2q722b.fsf@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: SY4P282CA0010.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:a0::20) To DM6PR12MB3179.namprd12.prod.outlook.com
 (2603:10b6:5:183::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3179:EE_|SJ0PR12MB6783:EE_
X-MS-Office365-Filtering-Correlation-Id: 184c9ab2-596a-4cd3-d6e5-08db5c1454db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Yc7QLT09UGmPx/YonO/l/s4BjddwaEwONZniOB8eg56JSjL0xNk8OFfadM3XyhUEv6GL+Eho/ZkVCGp4LwkOcOgGzqnKCEjxoTmLFRElyPUSFBGWvb0QCAd+W9tPSqsprGFJPJOetc8rtAqqZhZXUzEet2SOFsNUiVlSTHVWyLSxFiiEnXGkOEVHHVRbCjqMZlNiC49nLjjuoftR5tekjYY+kVA6xjYTkVp3wNFJlWtLf/WT8fpfLZ4NNcYUhjS1lL/da1BKeDKaobV7CpMGz/L24X10bFnBb7MzVE7Oji+iVgU/DuBuM3lH7pghA2BMYvXxNqPia7st8R8RjwpGfVaNairZoMTuCa7nFGSlNRr+M1JekTqs71SzqqENCv2N2ucE0pnuQ/PzaaHBvx/XWdBtV0WyVbnGaC1oLJVhlreTqJiHSvmjv8GVCAwIGENaZ/74lxbn4nxmUm0VrHhMdqd/wHBGlYBGvBFGQ//J+2WhyCfQ7YaIFcfTOBymSopq5PFkXscL4gUl0HeH97Il3zjE9hlFP+4ZqZFgbbLY4GQcAu0kodwCfH9bBeXkMLh+g7TC5T9QS4XpFUyo3PDc4DehTUep7X1z/910pIaG1nJLx8LoFNkXTxJxnbx48kisgwD6UIOkKvvfF7t+llH/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(346002)(376002)(396003)(39860400002)(451199021)(38100700002)(66946007)(66556008)(66476007)(6916009)(478600001)(6486002)(41300700001)(6666004)(54906003)(966005)(316002)(4326008)(86362001)(8676002)(5660300002)(8936002)(7416002)(26005)(6512007)(186003)(6506007)(83380400001)(2906002)(2616005)(36756003)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yOYsF5BWupeksSCI+ZbJ+igeKpX9oxfj9lWYgi3w0oec8F1LlaGHLLiMC70K?=
 =?us-ascii?Q?LOZFBAkPSajSoGe1W3nfKzySSuhpUb0Nn94Hri9pX3TOyt3dkgm7vtmVr4RT?=
 =?us-ascii?Q?xcsk9ezb9nnXXcKuzj7WOz9cZsqh5XfEALA4QOkX3iU4UARFZWvcmF0dMvCv?=
 =?us-ascii?Q?j/nNwDk7Dwu2xjCVRs4NObi7kFYwtSTq/9YVoUilImUmvMDG1nXjSPOl5Bw4?=
 =?us-ascii?Q?JGJfdJ9SFEMSpacU2TO0A0T/f/kuvCNUMgmZJW/VKnPgi8AcM4HFyOnUsiBn?=
 =?us-ascii?Q?zrcEOHjVr9taFtevtcdgcUmU/OkrK1xRW26DRtXFb0PxVXbqiYBs6GEM2vtB?=
 =?us-ascii?Q?ftE1aA+KeXmGFsWX8yjxCMFDnWTXv32QFSvEEiMpvB7MBXjjQAdVAzWi/eLh?=
 =?us-ascii?Q?UuqSwUxoZhIHIKeXxEprw/DVgxvTRro1xTYTvWjDF6vVGtCWAGv4bYy487HK?=
 =?us-ascii?Q?lRVOflsW8vt4ImIvLCir+/F0LW8483PRtcMv2H/RTOri1KtuGQs2GmC4xlUQ?=
 =?us-ascii?Q?Ucx8tMW0p4VVdLd669NWrSDNmpN9BdHWsh6GvUgR/QRCQI+uk21cE7Utx1db?=
 =?us-ascii?Q?kVJfU88sbm5tJpftxiYIUIK8q/fv3rzhAei90hwgTOnJDxqBQa6x90BSeI65?=
 =?us-ascii?Q?uclaRyVONTWvjsWtcwXipcsDDJsbuuynSyrLDnd9bh+o8P34NM31Rrgr+Dv4?=
 =?us-ascii?Q?aCgoiia5C9wZOEgMp2gTBA92IzAf6zgGJzwVk4xUydPC9dSVYISkYLkLUYGL?=
 =?us-ascii?Q?eTimNkvO384q0Bp2V6M8DzXsbhEGoWn7mKvZe5+GXcMRJfChuQKlPb9OWaRi?=
 =?us-ascii?Q?6w7Fng6ciq++lkDf6CBwRXzZuu7ksdj1CP6x/2GWgu3bubcuFOOKhb4TEk9G?=
 =?us-ascii?Q?xgVk7j9gbtdQaW6x9bmtKUH3A94Vf1QrPDqpypct3z+vWB+YMiQZzJvsD4hI?=
 =?us-ascii?Q?OqdblljmRNyBRRZulIBYZrXVqv3HzKYHLeVO7PtIi72qCVI1TJbwtp4SbQLL?=
 =?us-ascii?Q?or1tJXnWsajSSybl27p4jJjcO9pbWbkaX0NJSvOALb57erR+gGdtq0LVuICM?=
 =?us-ascii?Q?IeFKS8jjvccwhCbCWta80zJ9ELq4KI2J1VPuUJtWnvqfEJfIRK9pNnr1VrGR?=
 =?us-ascii?Q?rbqk1RAlmxhlZoGZ0eWo2+EC7819NJUXHa/E99TqlJ7zB1bGYqxiexgdPIE4?=
 =?us-ascii?Q?tHRPjgRQdr9nvoygotRhJoBNeWSgQ9mgfJAkuLsK4da5g6isbsWD32smFNB4?=
 =?us-ascii?Q?N+fhoyoO5fRcm/oN3kOtEV2um1kbokSgwMDumMrxH04xn+oO9MEmnpBJfJ3r?=
 =?us-ascii?Q?7MvkG7FSM+Wd3JsuwCSx/ER2ZnVggHRaQOnEWzQAttKXXu9/sEHmQdi89Lnw?=
 =?us-ascii?Q?JYm1Z+uxD35TN4Spay4B4Qmbo91RxW/v0U5jAAlJZoFupzavWOQhaN5CRxo1?=
 =?us-ascii?Q?+NKWqbi8qjJTMy8zkS92/bdTcfOPaT8A0/uJR3OV2+eGTUcTWFLAlr/JCIL7?=
 =?us-ascii?Q?pawVnnvTaM7tpuXNW0GOgF4xkCDt4y0h9L5RAfPjamqWkqfQvX3B7tstXFPF?=
 =?us-ascii?Q?b4lHSPrZcQKx1pvgPo63TDsz59+m2UAD20z+kqho?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 184c9ab2-596a-4cd3-d6e5-08db5c1454db
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 05:04:19.7911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zio5neu1NSxTjDC8dOz1kUZ15DQoiwQEFSLenE3pChrO9E8VgXCTpNAy2tL37paF4y+xP4gICNNRNVJnK1B4MQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6783
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Zhi Wang <zhi.wang.linux@gmail.com> writes:

> On Wed, 24 May 2023 11:47:28 +1000
> Alistair Popple <apopple@nvidia.com> wrote:
>
> It is actually commit 4e15a073a168 ("Revert "mm, mmu_notifier:
> annotate mmu notifiers with blockable invalidate callbacks"")'s problem.
> It tries to revert commit 5ff7091f5a2c but forgets to get back this
> piece of comment.

See my response to John [1]. I don't think it was entirely correct to
remove the comment in the first place but I haven't reviewed that whole
series given it got mostly reverted so I'm probably missing something.

The important thing is the comment is put back and that it was and still
is true. There is enough history in the commit message for people to dig
through how it happened if it's of interest, but commit 4e15a073a168
seems like a reasonble enough thing to put as a Fixes tag so will add
that.

[1] - https://lore.kernel.org/linux-mm/87lehe72v4.fsf@nvidia.com/

> It would be better to have a Fixes tag in the commit message.
>
>> The .invalidate_range() callback is called by
>> mmu_notifier_invalidate_range() which is often called while holding
>> the ptl spin-lock. Therefore any implementations of this callback must
>> not sleep. This was originally documented when the call back was added
>> in commit 0f0a327fa12c ("mmu_notifier: add the callback for
>> mmu_notifier_invalidate_range()") but appears to have been
>> inadvertently removed by commit 5ff7091f5a2c ("mm, mmu_notifier:
>> annotate mmu notifiers with blockable invalidate callbacks").
>> 
>> Restore the comment to make it clear that .invalidate_range()
>> callbacks may not sleep.
>> 
>> Signed-off-by: Alistair Popple <apopple@nvidia.com>
>> ---
>>  include/linux/mmu_notifier.h | 3 +++
>>  1 file changed, 3 insertions(+)
>> 
>> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
>> index 64a3e05..447d757 100644
>> --- a/include/linux/mmu_notifier.h
>> +++ b/include/linux/mmu_notifier.h
>> @@ -200,6 +200,9 @@ struct mmu_notifier_ops {
>>  	 * external TLB range needs to be flushed. For more in depth
>>  	 * discussion on this see Documentation/mm/mmu_notifier.rst
>>  	 *
>> +	 * The invalidate_range() function is called under the ptl
>> +	 * spin-lock and not allowed to sleep.
>> +	 *
>>  	 * Note that this function might be called with just a sub-range
>>  	 * of what was passed to invalidate_range_start()/end(), if
>>  	 * called between those functions.
>> 
>> base-commit: 44c026a73be8038f03dbdeef028b642880cf1511

