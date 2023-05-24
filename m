Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F54170EB42
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 04:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239030AbjEXCU4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 22:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232036AbjEXCUx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 22:20:53 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE15C1;
        Tue, 23 May 2023 19:20:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OLtJen15ElKQeiJgoOP0PhY900fSW4WMCokv4dQi5jeEil41YSU31IZxFX/OHkX3wGe7RYOGvAjQ11SlTQJHEhGMMxMAHZFfn0uigLIUsA50O60prAfy4Xr4MJFNVW9PNrY/pItvdmlK+gYFk7Burhs6f5MrrvDVJDjkvwlIEExIRFEAzZfJ7TGP3m5kwW7UJrOeT5ZlRiJhSSBPR17cHhUVVaAcC1yDt9J3epQXDmXptGEeT6NjqHcJOQhG7Q0v7wG3kkW7YZOf3a0SkIIRhTtZ30qOfbSAACt+FBtPUPQ/9TNL7nIpBPoyV53IPJzwUo6G/an0hDpHAi5fMOTtWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+gfRDeGfbuWIv2RbzH+D/3zaf0Mm8zXkaSKBe4oj6j4=;
 b=T+sSyAoNVc2Mk2TOc8df1anKTOMqni30bIBUJsIn+gvSBsaUPwc03GaY86tdthjbiw4tCyPD5F5ukGeeGEZqC1sYnd1MtVexfUnrVA3kT+SVZSk8rFCRB5dEFbJyKYM0VrPFB/qz2Nlz2E8p5M2+tmzioZSR8gVs73Sqdx45Q9JlGFV9Wrgsuzlfn6nj6l2CZI96/7EQlzjZ8s7Z+obT59ZhJTWbrtBJ/IzSZdX+O0ObzfiP7LeOI3UW9rLBv6+ka8ql3hpoURctzqA1f7o/mZ5le97N/3FfE8hyHhbbSOTz+EEnD6qjzTJ28fj/O0ZgHRjcwlkFMKfF06IKxIlP7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+gfRDeGfbuWIv2RbzH+D/3zaf0Mm8zXkaSKBe4oj6j4=;
 b=DIc302CIrXowv15kH3BWr1snlQrJZ9UScqpx2w7zD2MgZYiUJqtwpUPhG0cDNiKxCPcD7wS0dxNDDvfN9kfCacPe0fGMxlaV/KSiJFCGmzReHTz+R5bYbTDFz82PQgVVgmNyyCnQvNfrx/IThM816pXFtOstfDLrRNtNyVIjDui+OlbRWFNVJjSkvreqhnWKt6kyHtcDqQRTNw/ecxMD6X4inB2f6BrODrMvlJM7rY5ZxRXCFpZpm6T2BpTKiaoZjgKj+KeyNilvK6GFNx7tyVev4VaB9CE+/yts9nJXzwpbO/nciKflQu9hLEuNN2hGX5SDHFz2d0sDRLp8V4QFSA==
Received: from DS7PR03CA0018.namprd03.prod.outlook.com (2603:10b6:5:3b8::23)
 by PH8PR12MB8607.namprd12.prod.outlook.com (2603:10b6:510:1cf::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Wed, 24 May
 2023 02:20:49 +0000
Received: from DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b8:cafe::26) by DS7PR03CA0018.outlook.office365.com
 (2603:10b6:5:3b8::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.30 via Frontend
 Transport; Wed, 24 May 2023 02:20:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT059.mail.protection.outlook.com (10.13.172.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.30 via Frontend Transport; Wed, 24 May 2023 02:20:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 23 May 2023
 19:20:32 -0700
Received: from [10.110.48.28] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 23 May
 2023 19:20:32 -0700
Message-ID: <cb706d3f-1fa8-2047-e65c-e1dc1fa6821f@nvidia.com>
Date:   Tue, 23 May 2023 19:20:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 1/2] mmu_notifiers: Restore documentation for
 .invalidate_range()
Content-Language: en-US
To:     Alistair Popple <apopple@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>, <will@kernel.org>,
        <catalin.marinas@arm.com>, David Rientjes <rientjes@google.com>
CC:     <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <robin.murphy@arm.com>, <nicolinc@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <jgg@nvidia.com>, <zhi.wang.linux@gmail.com>,
        Sean Christopherson <seanjc@google.com>
References: <3cece716fc09724793aa832e755abfc9d70a8bb3.1684892404.git-series.apopple@nvidia.com>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <3cece716fc09724793aa832e755abfc9d70a8bb3.1684892404.git-series.apopple@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT059:EE_|PH8PR12MB8607:EE_
X-MS-Office365-Filtering-Correlation-Id: ae10a83b-453c-4668-657a-08db5bfd7d5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TRTtVu/oxk3K2W7rTB+o2KIs0FJGFNW4x0espHOYMqAq1DluvjxG4aLK3NkELNvXAY8CCPm4WH+ZpDOXJ3nQ3IP9jOknBWZLjryhqeNjUIDvrWYS4qLdZhA2ZM/qBpL3ee+5lrL+uGzm8uqHDlXmYEGbHETSUguiYKVtROn6h2mH9Qj3K1g2aNWC2Y/Srx6HUjQs8MkHEPZ4Z4s1dWuamLQHZVcc/2dfrr8xobEDIlcMQ3B+40ScRYYxozHe634wiAQQZ1vWtgtnoQcHU1uUf7CE3N0OTrxPAi+23qgMuluQ4l6mdfZuKsODed98oirsjDZu6idBgtANP315Sm72HYvg6TNp3GXrj6yzWETkzraevp/FxcsrBRLgRaYgpwPPo5I47WzHPNjdDyzKqSglK7yvapHpEn8UibDJA4qeBUYgzrs8QvEt/l/xc+mZHWVJJMWOsC8doYRv0nQRsSGHZQf5vg5usouShGCEp8OElc6GkYQ1ksAa2P7xSwtJ1jzzMcfgR5woarCU5sHzyBbvFn66HMxtw5YkP8oAsTKVMwvo0aHilyf9BW0eRitauBNBzwB2m0fZh7aDcGnwqNJBDor6J0fWw64Z99F38THVERp1OPaQ7auB7NMTQUUYa4AWZF9I+1Doivk8B7ILJo+rVNgiBu4lzmH1LZW8JMMgOF9aep4tzGZXJt9eoRLlzv5V+ygErzcpEffq/nhGG9R4y9NwpeQHtp3aDiK9NHbNIN5tH2D9/AoK0wC2G93/jNewx2H1q9uyy3/pVld40WZmB8MpA2Lj5i+3F9KSK3W0x+fuDBFF7RM2gThq2D/lSWG9SZdr0gczT6qjWMIcq/Da7w==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(39860400002)(346002)(136003)(451199021)(36840700001)(40470700004)(46966006)(16576012)(31696002)(70586007)(70206006)(41300700001)(86362001)(31686004)(5660300002)(316002)(4326008)(36860700001)(2616005)(336012)(426003)(82310400005)(47076005)(36756003)(8676002)(8936002)(83380400001)(7416002)(2906002)(54906003)(110136005)(478600001)(16526019)(356005)(7636003)(53546011)(82740400003)(40480700001)(26005)(186003)(40460700003)(966005)(142923001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 02:20:48.9621
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ae10a83b-453c-4668-657a-08db5bfd7d5d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8607
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/23/23 18:47, Alistair Popple wrote:
> The .invalidate_range() callback is called by
> mmu_notifier_invalidate_range() which is often called while holding
> the ptl spin-lock. Therefore any implementations of this callback must
> not sleep. This was originally documented when the call back was added
> in commit 0f0a327fa12c ("mmu_notifier: add the callback for
> mmu_notifier_invalidate_range()") but appears to have been

Thanks for digging into this. I expect that you're on the right
track, I'm just wondering about something still:

> inadvertently removed by commit 5ff7091f5a2c ("mm, mmu_notifier:
> annotate mmu notifiers with blockable invalidate callbacks").

Was it really inadvertent, though? The initial patch proposed said this:

"Also remove a bogus comment about invalidate_range() always being called
under the ptl spinlock." [1]

I've added David Rientjes to CC.

I almost think we should rename the callback to something with
"non blocking" or similar in the name. It not great to have to
do this much research to figure out the intent. And it still feels
backwards.


[1] https://lore.kernel.org/all/alpine.DEB.2.10.1801091339570.240101@chino.kir.corp.google.com/T/#u


> 
> Restore the comment to make it clear that .invalidate_range()
> callbacks may not sleep.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> ---
>   include/linux/mmu_notifier.h | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
> index 64a3e05..447d757 100644
> --- a/include/linux/mmu_notifier.h
> +++ b/include/linux/mmu_notifier.h
> @@ -200,6 +200,9 @@ struct mmu_notifier_ops {
>   	 * external TLB range needs to be flushed. For more in depth
>   	 * discussion on this see Documentation/mm/mmu_notifier.rst
>   	 *
> +	 * The invalidate_range() function is called under the ptl
> +	 * spin-lock and not allowed to sleep.
> +	 *
>   	 * Note that this function might be called with just a sub-range
>   	 * of what was passed to invalidate_range_start()/end(), if
>   	 * called between those functions.
> 
> base-commit: 44c026a73be8038f03dbdeef028b642880cf1511

Hooray for --base! :)


thanks,
-- 
John Hubbard
NVIDIA

