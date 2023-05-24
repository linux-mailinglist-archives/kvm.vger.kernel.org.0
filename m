Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D89E70ECA4
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 06:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238926AbjEXErJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 00:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238735AbjEXErH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 00:47:07 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5BD512B;
        Tue, 23 May 2023 21:47:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IQbOybavJJusUIZ/DYqXqNyH563N/b+7Vs5Vk0vYzmwSNlHLCL74fLMUsix2zVv53LWE/a90H9sGHdmle3nhYqt8yuJ7fBZm/abOfQus9howFEbLifJIaFBDzYoCTMglXr4nxEdjdMM/lcJPAZVIQzvKVNYkywA1WnKDZST3eNDgGxRdz1u99LaKwRx/fJNt0YmmpRPgJw5YJ4tPl0axe6yKVNdOGbZ+qjNBpjROT13VqaDxbRhj9VqzWZRWZ5wnXU+M8B5/h3pUp/Rh0/RAMJ3GpBXnkLNvpGsTT6cmTYn4H2WJMuM5i6QMuHkSsXepbHGxnRgXMvP6Z0/BLoPt8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vkykwE2M0wDJ9SoLV3ajnoQJtxDmokSPFWYTFj6ZpcY=;
 b=cHxZmO9FdK6CRYm73ceack05Y345eYrNbq8p9igjEJHeS/O8rk1FbvnhJqfx+MhGqCq4w+dCOkPcvXrh7kKb1i4GDj+UK6qZlm62TGoDJxIXuO+rqYMwjY6IOko4xsyplc7Ml2w3+dhfk/cjBrbfQd8F0zOxJ49P1C3pTdDLDGlC2xHo4xRmEyEZ1roAN5DQjyz15NaV4A6xAVGk6/hNBov99/p6TWYq2aERLaRv4n626BWXkdaE1GjDW+bki0O54vKXfjji7avBZFjaF6wfEXFTWiNX1HP2EsmmPtMH5rkMJaTCkmD5FTb/+620XGoAiEydW9d8jC6hMlMLTbQM/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vkykwE2M0wDJ9SoLV3ajnoQJtxDmokSPFWYTFj6ZpcY=;
 b=TyTSV+zPOLz05xW2oHIoW1reFs4BxHPbItZTCXoM8zCIzFGMy5vn0bG31gQZ0X/h51ED097bEiNwIuueJB+Z/xWIvw7g5SDNbvNfM73C7R3iyGAU4smlBsPjhCoXDoAN/DFlO9s3XUggzGdjwsjLvNaIhVd1RmuZq7rSuuz1F9cPfVy2rauoHRmPjofEtUP/uo6llVg6kMl2g8sb06igychK1uDzTK8pAzBsjB3/jdrnLY5gD1y4FTcjvLCG09VHemLFOL4IwZaChlGFZ6H02eKxbJVqumtQBiZV/u1X8nBVagJ0KjQwXQUdNHmssG7DGQYxuLXcHPAafUMaDYzJ3w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3179.namprd12.prod.outlook.com (2603:10b6:5:183::18)
 by BL1PR12MB5047.namprd12.prod.outlook.com (2603:10b6:208:31a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Wed, 24 May
 2023 04:47:02 +0000
Received: from DM6PR12MB3179.namprd12.prod.outlook.com
 ([fe80::dc79:d410:23d3:f718]) by DM6PR12MB3179.namprd12.prod.outlook.com
 ([fe80::dc79:d410:23d3:f718%5]) with mapi id 15.20.6411.028; Wed, 24 May 2023
 04:47:02 +0000
References: <3cece716fc09724793aa832e755abfc9d70a8bb3.1684892404.git-series.apopple@nvidia.com>
 <cb706d3f-1fa8-2047-e65c-e1dc1fa6821f@nvidia.com>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Alistair Popple <apopple@nvidia.com>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, will@kernel.org,
        catalin.marinas@arm.com, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        robin.murphy@arm.com, nicolinc@nvidia.com,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        jgg@nvidia.com, zhi.wang.linux@gmail.com,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 1/2] mmu_notifiers: Restore documentation for
 .invalidate_range()
Date:   Wed, 24 May 2023 14:45:01 +1000
In-reply-to: <cb706d3f-1fa8-2047-e65c-e1dc1fa6821f@nvidia.com>
Message-ID: <87lehe72v4.fsf@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: SYBPR01CA0059.ausprd01.prod.outlook.com
 (2603:10c6:10:2::23) To DM6PR12MB3179.namprd12.prod.outlook.com
 (2603:10b6:5:183::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3179:EE_|BL1PR12MB5047:EE_
X-MS-Office365-Filtering-Correlation-Id: 929d97f7-9df6-4a75-9f2b-08db5c11eac3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jg+kNb3UoRRaZyj/OjDgRJWTH1PmXairzCjZAeba68tIolfuNFKfkVbMomdM+jExi19LppVpxdzeqSonp7z031jiVWVDp5XX/ObsfZB74ZplxeLxhj7Jmr5KRvhD3222NZOuqTRZKLKNu7TrEsBboAdBlFIyzF1zGcMSxRE4ZmZddIRcPvp8xHKkB72KENaO8kbJPv5ylB5WXW5FIFl8mVGrEDozKUwh1c+hwFcNcZSDK16QGbCKg5b0BX6J7pvQCBc2Zijd8aS7L4GG1kUGHPlz6WcpBdAiuVE9Ej7tw6vtkAlhzhxaXof8MOrjzuG2OSIZyhJmiHIYuB46rfaQCasDMOQg6x2uty6Paj7e0dKOO0n51k+Rqj9evrnAzObLdm8nZn2AvEo8y2lVZe1w0ZeDsyTVyVIYrikegIpnZ8leKMWFBFMnHWwi/26KG8cznvn92jFQEDezcqd24ZUM4ZYBon3+80W9mISkUzqgyAnFthNJzrJlVG4t5atoOxnxblROduZDn0YOqp571I8IE9E+rww2B8IS5nYfOMmoGLIWD/lKAFM3cR4XHHTlubTrJSlHNf3jfaXOXI0NFQYMfOJHgFn4Kqg7hpt8eCMSNyRdsyBdPI3UCDrFnzoVBSw+n6HGGsvxZgmqDczq8oTYGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(451199021)(66556008)(66476007)(66946007)(4326008)(6636002)(6486002)(41300700001)(37006003)(966005)(316002)(54906003)(5660300002)(8936002)(8676002)(6862004)(478600001)(86362001)(38100700002)(26005)(6506007)(6512007)(7416002)(186003)(53546011)(83380400001)(2906002)(2616005)(36756003)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IJQ5GsZKIz53XXgZ9vRm5Lce8cvWJWUWLcj7phrt5zyqEjEGpSZ7jLpWdyuD?=
 =?us-ascii?Q?WACl6SJb9FUEAD1HPz92xNjqc7NhdPn1fUNM9lUtMm3KL4yDs2Lb7AbW8agG?=
 =?us-ascii?Q?4FVAxZz+9E3IXE7jg+GtakQbzWdFVnywTD0WQy5uE+cfCF4iZzexL2/4l7a1?=
 =?us-ascii?Q?kz1jp5ddifBdN4j7BXPf0ip8VwGoYN/JiK5GQ+dHVNEQsLSu2QIxjw7jKHui?=
 =?us-ascii?Q?jM0NKQ0AX9E/Ifaytd59bzcES6xun/mY596zvEwWcKgJgGJaJ/P+XUvX6QT/?=
 =?us-ascii?Q?yWNg8WhkSg3DS7PQYyrBNPj8n1LvaANAYSJQVCdfMnCZMz6YWmHnsQjHWKuI?=
 =?us-ascii?Q?uQlJ3lEd54JDCRfHjaOdpWlSnkmP+N3AVgutOGIZfQSa+61R9IlNplyuswKO?=
 =?us-ascii?Q?pswtltKVuaiohTspXYtmWGPeK5AW0NbR9FKKN+LxCstWgw79lKa8KKmwhebU?=
 =?us-ascii?Q?TewIUz5fJQbQnK2BfpCz0jsrhzPRNfTDKMhGzof5ChnMk4ekhMG4B3i5k8yp?=
 =?us-ascii?Q?rK0n22OgUcCl3XV7Wl6DV1I2uNjEUMPbqWpLpMvzXKO8NONys+0J6oHhYaqI?=
 =?us-ascii?Q?VyTJTMvDTLkzTZwTe0iP7atiRTWl59UhZbdkv1S6dpegfH1omRoGx3eZpCBD?=
 =?us-ascii?Q?nQ67+H6jgIapvQemZO8zqMyAW0mtLetsPFKGnkxQmZA0nT5Y7rRZTI/XSklW?=
 =?us-ascii?Q?phJBprItoBfQpfv7E6eKxdqaa5COI5vy9RnmL09kz2sCCR4F3oLnpQAbCdkU?=
 =?us-ascii?Q?46GQwCRoOpD78VmHfyzGgovQGQp7BBei0tD/nJK8uL2LrxGFaNeg9bZFQG25?=
 =?us-ascii?Q?7TZG6P0543RgMEM1tiSp5D72x1/GWKpwHZXliqQ0+flO9SPHSjxsu0sXwdnf?=
 =?us-ascii?Q?az5LhBSeS3nlkUvN80EyKA+rLwlcgMdOGCGMgGsk7lrtrqID7+gVztfrfZet?=
 =?us-ascii?Q?8ZEiaqHZZEUJoZngGT7DvtDJbzut71sV4d289Pb7+fDRCmzq7M4I5ainl4sw?=
 =?us-ascii?Q?YI0qh0fBlwWa7Ugjx5k586tEAYd2tZxXiEDlLOERT5fmCtILOZ7SXJfOF1xx?=
 =?us-ascii?Q?DK5kKIY8anmOOOQtf2dRuJxMB3Falg9NlWe/NodztH3aOPf1Q7+gWh3nfZLC?=
 =?us-ascii?Q?acbB53O3rHHMDKmgsTPoFfmhpc8cJIUnmTy/63r46hb0+jwMCzH8tdufoBIk?=
 =?us-ascii?Q?a/zhNh6IQpWilcXONTOmHeZtaUmbrX8BDgEp9DnE2Snd0PiNoFAfwPFC8NZ4?=
 =?us-ascii?Q?aVs4mXT6+18O1Yxrjb9knuJYaNejFFMVjs0kEf/odapevyyxIwMGKdXrdcP/?=
 =?us-ascii?Q?CfAjn4xBD/gzJCDff9snd5j9AkI+XId26s+ahb9Jh2OzLeUXbCNITjs1m2Hs?=
 =?us-ascii?Q?OW4aOn0+qEWXMx16SERfwitBzfjF/7L1mJj/ymw7kg+NqBdSGDPho8149Z7q?=
 =?us-ascii?Q?67YEB1IQ9jmeUdJf0e499YU+5jJQlPpyWG6GnaEZ7tqF9s5okiCGS44o/1Q8?=
 =?us-ascii?Q?tuUEWhxYjq/XuyARsPAbz+SrdrLpWhbUdLnBdYCB3AQ5hbCL/kknOHV8Inmq?=
 =?us-ascii?Q?gXEUo9+4X118z28/nINLn09a01gS5DF0CVsAPP5Y?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 929d97f7-9df6-4a75-9f2b-08db5c11eac3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 04:47:02.7332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A6R9BXcMn8VKFQIwNUn0kITBhNOwgLE5Il0B3IoBF1evupIYxs8VCvLEY/BLi9maY+pFLaU4LEaAffJovjnJkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5047
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


John Hubbard <jhubbard@nvidia.com> writes:

> On 5/23/23 18:47, Alistair Popple wrote:
>> The .invalidate_range() callback is called by
>> mmu_notifier_invalidate_range() which is often called while holding
>> the ptl spin-lock. Therefore any implementations of this callback must
>> not sleep. This was originally documented when the call back was added
>> in commit 0f0a327fa12c ("mmu_notifier: add the callback for
>> mmu_notifier_invalidate_range()") but appears to have been
>
> Thanks for digging into this. I expect that you're on the right
> track, I'm just wondering about something still:
>
>> inadvertently removed by commit 5ff7091f5a2c ("mm, mmu_notifier:
>> annotate mmu notifiers with blockable invalidate callbacks").
>
> Was it really inadvertent, though? The initial patch proposed said this:
>
> "Also remove a bogus comment about invalidate_range() always being called
> under the ptl spinlock." [1]

Perhaps it was imprecise, inaccurate or incorrect. I'm not entirely sure
but wanted to give benefit of doubt. The point is the commit log doesn't
describe the patch correctly. It claims there was "a bogus comment about
invalidate_range() *always* being called under the ptl spinlock". That's
not correct - the comment which it actually removed (and which is added
back here) simply says it is called under the ptl and not allow to
sleep.

Nothing in that series changed that. I suppose if you wanted to be
really explicit the comment could read:

	 * The invalidate_range() function may be called under the ptl
	 * spin-lock and is therefore not allowed to sleep.

But I don't mind either way, both clearly communicate the important
point which is it can't sleep and AFICT that has always been the case.

> I've added David Rientjes to CC.

Thanks, I had meant to add them to cc myself.

> I almost think we should rename the callback to something with
> "non blocking" or similar in the name. It not great to have to
> do this much research to figure out the intent. And it still feels
> backwards.

Hopefully the comments reduce the amount of research required and
nothing can replace reading the documentation/comment for a subsystem
prior to implementing the required callbacks, etc anyway.

I don't think adding _non_blocking to the end of function names is
particularly helpful though unless it's to differentiate between
different versions of the same thing. In this case there's no _blocking
version so it would just add confusion IMHO.

> [1] https://lore.kernel.org/all/alpine.DEB.2.10.1801091339570.240101@chino.kir.corp.google.com/T/#u
>
>
>> Restore the comment to make it clear that .invalidate_range()
>> callbacks may not sleep.
>> Signed-off-by: Alistair Popple <apopple@nvidia.com>
>> ---
>>   include/linux/mmu_notifier.h | 3 +++
>>   1 file changed, 3 insertions(+)
>> diff --git a/include/linux/mmu_notifier.h
>> b/include/linux/mmu_notifier.h
>> index 64a3e05..447d757 100644
>> --- a/include/linux/mmu_notifier.h
>> +++ b/include/linux/mmu_notifier.h
>> @@ -200,6 +200,9 @@ struct mmu_notifier_ops {
>>   	 * external TLB range needs to be flushed. For more in depth
>>   	 * discussion on this see Documentation/mm/mmu_notifier.rst
>>   	 *
>> +	 * The invalidate_range() function is called under the ptl
>> +	 * spin-lock and not allowed to sleep.
>> +	 *
>>   	 * Note that this function might be called with just a sub-range
>>   	 * of what was passed to invalidate_range_start()/end(), if
>>   	 * called between those functions.
>> base-commit: 44c026a73be8038f03dbdeef028b642880cf1511
>
> Hooray for --base! :)

Heh. I usually use git-series to generate the patches which adds --base
automatically but I occasionally don't when sending a single patch fix
and end up forgetting it.

> thanks,

