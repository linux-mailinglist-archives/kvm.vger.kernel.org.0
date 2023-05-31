Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BAEC718F50
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 02:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbjFAABT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 20:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjFAABS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 20:01:18 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2082.outbound.protection.outlook.com [40.107.243.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26FB134;
        Wed, 31 May 2023 17:01:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PaYVZk90R+N2NabVblyaiC2/I7NmEZAqxu3vdOxpj3PD9PWBlrXtPp5cRa9q5KQvQtNS7cAve5gO6M9r9eG5yLrdl0ZXa0tTBAYPJVpHfOBMItJqt6CjhcY88qaEoFTcb+46fdRTmTVca9R17iZiu1+MO/xhEDkgDBGb2weQGHOTSuetRjSFIU10vgEb4PQVypnUq4IuJxtj2a27gYu7sN6a84ZT69VHgmbWUjBg7Pjuilfe+aCgnCV6YhCmRakr6NEwGfIoKxJLQUgUu1e0yM5NITnvmT3Om4ZQ5TVpuDoTa9rY1IA0NdlhNss3QuqojHvB9JvkM9u4H2rnAkp5PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ev9BfkfLysBc+vOsn8BGUTeqNXpnJny025lM8y87yB0=;
 b=MAfDvpijsdMqllcToZrb4+pQn/G4qaeToF+zuicO+q1lIu7NNpWNAWJFJ47u19dfy+14VUA8svg4yuoM4cD70SzUJHbBaummXF5hr1WcKVbSSm0svTed7miSTDUAk29Gr/K2LNiX/eMA1MkLTv9QKolZx4jU/rDZG7Fq30GyPY6CGIhQjTlS8MVhkharvc7ShiCutxGF36pfkaJn7LyyfyMkdOH9wLot6MFSawo9VMgMA06QNFk5UsEEWNcd0OzMISRjKtcck0kB+oaVTpJFCv63/lISNrktUeMRTGn3my2Ojd80FPeTuYGlUVkLrHW/FdJk9PTLCkXbqszBYBhr1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ev9BfkfLysBc+vOsn8BGUTeqNXpnJny025lM8y87yB0=;
 b=EZLS5Zkq/dYfpZm39lg1qhBYOXa8NBVTFYIWtsmHc87X5st3GrI4qP21BAXJKmS/cqrqhqfZXlqt+sQ6DHStNGrPRwopmSL3a9AZW0GJFTWXBIoTYnfV1r04cqIPvjA9vdcxp3pRIKVsfjmSChxnZf9BFn0y0x6oVigRYmuz0qrAdWFPN5M8EA6U4G1bI4EUCIgGw/8zQFw/7olL+VazvAJ65o3CIwUmgFpRWyRQ5mVw6cUgKe/+lJIxDi1XF7d2KF8+BGk3cRgJBbIhGoVegD3DFHXt3+StdO3R7f3i9aS0C5xLmxobPTXQ1oGq+9qsmID7l/MXwb2Sdhw+5fX/1Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by CH3PR12MB8512.namprd12.prod.outlook.com (2603:10b6:610:158::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Thu, 1 Jun
 2023 00:01:13 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::f6e4:71a5:4998:e6b2]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::f6e4:71a5:4998:e6b2%5]) with mapi id 15.20.6433.022; Thu, 1 Jun 2023
 00:01:13 +0000
References: <ZHXj/6Bjraxqk4YR@nvidia.com>
 <d2e591c1-eb43-377b-d396-8335f77acef6@arm.com>
 <ZHXxkUe4IZXUc1PV@nvidia.com>
 <89dba89c-cb49-f917-31e4-3eafd484f4b2@arm.com>
 <ZHYCygONW53/Byp3@nvidia.com> <ZHZuSDp6ioPqI272@google.com>
 <ZHaCAJI+OgIfDWSx@nvidia.com> <87v8g9qr2z.fsf@nvidia.com>
 <ZHaVsa3oXfXqE1Pu@nvidia.com> <87ilc9qkuc.fsf@nvidia.com>
 <ZHdn+FsH6BWcK7C4@nvidia.com>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Alistair Popple <apopple@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>, will@kernel.org,
        catalin.marinas@arm.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, nicolinc@nvidia.com,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        John Hubbard <jhubbard@nvidia.com>, zhi.wang.linux@gmail.com
Subject: Re: [PATCH 2/2] arm64: Notify on pte permission upgrades
Date:   Thu, 01 Jun 2023 09:56:22 +1000
In-reply-to: <ZHdn+FsH6BWcK7C4@nvidia.com>
Message-ID: <871qiwqce2.fsf@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0199.namprd05.prod.outlook.com
 (2603:10b6:a03:330::24) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|CH3PR12MB8512:EE_
X-MS-Office365-Filtering-Correlation-Id: bc0b7ea4-9bbe-4792-6a79-08db62334fb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: byXcOxvPmS5JW1dML9FB/hPJzW1Jua3cj2wFqEayXyabiL59ZAT1e5TZ4cliphls2pb5Uy7DYSE05zfhDFRMQ+h753BV13xTxIaBRfpv0x+IJwvdTVkGOob+zecGs6jcXXIJoJ0dTOv8/2+6ih9Z+RAmvCjGQxhIBrT2hAXnfmUnbm806PjaXMjkMgKEoNBAVPFfGhu1X9btfuioYCq5m3fMxv0Yj+UAE6jD+B6SNdxD+OWblJ0cFSsbrFNUMHvz8FSxxwi+El1xTMziuf/uKDgweCdieRa2mvl6SfZHiJAo0q8GwtP60U43N6U4253GKKbakhio0NCdsPu3Y3Lduj97uSx8iPLDZgQr0su3Eo92/HPzKT+YlDOb6LUdf8gmTyvNu3CcjPOvqSgKRyro9xG3hLl9HHjfi6BHmm0KTf+OMS9ZwLTGerx2DDLIPPq19MrQvBg0GK7Yu4Q3zDByN5K+QBZl+u0KOtfvn7Q/Zq5gczPYINWQL5weGsWPkbKxZRkIZojb2K8kaFI2Vk7gq9sGC4pRRrUiMZWo24Er5G0qDPmbtZGPdV2+ZIJ35yZ5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(136003)(376002)(39860400002)(346002)(451199021)(2616005)(186003)(38100700002)(41300700001)(83380400001)(6486002)(26005)(6506007)(6512007)(6666004)(478600001)(66946007)(37006003)(54906003)(66476007)(4326008)(6636002)(66556008)(316002)(8676002)(8936002)(6862004)(7416002)(5660300002)(36756003)(2906002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cqdQijX2GImQa/dLYeWaD5cf2Xjualj7bYBdSzwohs6hn2mz3tfLiCN15CSg?=
 =?us-ascii?Q?jl94xKvRRfV+RbjutiNxvMTNPFkrxceuXypQNBXjaNEbKK2LdZZiFUy0ZqvF?=
 =?us-ascii?Q?Gn1Zdw27ZPj9XW8oJ19Hv/5LdaLTlOI+fVHrcyV6YoQQ/TkoshJKg+do5ibq?=
 =?us-ascii?Q?1IqAhIVc+XJWgPanfPeJ74a8/7orDf4RJTNF0leRi/wxxeiPnIugQgbEEh9r?=
 =?us-ascii?Q?Kh+c9+eJOXYwtD/Cl9io7tUwKbeLG4hB3XmitO4w5U8I+8QS5txGXjJUylow?=
 =?us-ascii?Q?DOtQAnIQ3Lr0s6l4VR+ltpmxTZGUHQJSSUZQD+EHl2uJcLB4XEOYmZ7XeafC?=
 =?us-ascii?Q?5EgrOOB1bWQvAgowvjawYjxeFC22DnzppRQZuRpi5Nc5YkHI5vcUNrW5xlaM?=
 =?us-ascii?Q?ITN+mY6vgRsj9vhn+TjaMlWGoCaSHHGLf/CwnBUemnP43VJgAd5RhZL1nRGm?=
 =?us-ascii?Q?VJKvhZsls5Ldo3YCQL9NLs1OR8nH+PPgUPN4u0Q44DqRTK28HkrM7Dx3+Ce9?=
 =?us-ascii?Q?CkgZbZmROFl/GLBa5T3PcH691un6wJ/G5gn5qq49gEGAhxnnlVFsPApORZZg?=
 =?us-ascii?Q?MtCnr82Crf49Wya5DvNqsFxgs+BtiHlRFLEnEt+kLk2nXqXmJfEQS57rt3Qm?=
 =?us-ascii?Q?I73Szd73HH1QnNqVDirf3jBYaBtSsQcti02xP/MIbPU3BFbNj+vk3OP8DcXG?=
 =?us-ascii?Q?bieW5DbS2Sq3icf41RRDqpGUdLkQw5J2wJmZZJZ5HJWFfnEDfg4yEUzo1Hy6?=
 =?us-ascii?Q?eljhTKx+zvqrdo/1ViVrgLSiRIKOvK41y962FAbf1S423dojIlthsIsOSZCx?=
 =?us-ascii?Q?roTBKL5qS0Gfr8XcgPDhFs7fvF/d4Ys9TPLEpMMs+JhQLzmxMDWcrmB91Dtn?=
 =?us-ascii?Q?Akd6FpSEwkzLJWFJ4UccsyGQmgsO6cJnc8DCrHtVF0KO0AUMIJw4fSrD4Rc9?=
 =?us-ascii?Q?uMYaOTroEVYW+gr31iNIKEXZsyEAYp6/rx3e4HlnfRaRFFIfHaNcD5DFgR6D?=
 =?us-ascii?Q?dCKc1K5i8GLyLf2yAEFiHsFYmwwoLqzgxoKuNA2ySBaDr/KKOM0Z51iJqt6g?=
 =?us-ascii?Q?gD+idu8jlh+zF4+bk+6sUuSFUI+Z+ixWDI4Hvh43JWiH71ZyuCXh3ISHRO3x?=
 =?us-ascii?Q?7EnpMr65u3fuF0rVcbUNscHrwh70Q57uOZVv02079LEVrs2Oqr/h0EnWucj9?=
 =?us-ascii?Q?+ZmMthSjGf/tUzmH7tbDzaYUTB4UYjBYkN7feBrMBpgLhc5iJd8NgCfxJjSS?=
 =?us-ascii?Q?ULL8t4YEwus0tRF/9aAmJBwfPxqafV1XHvmjrMjxsNutUQu9ppa+sCYaTlIA?=
 =?us-ascii?Q?qREncwEL63shXy4X4/hAhq8TDaoDPMblOve1ffvFmZVNHqqpU3/96s3t/qoI?=
 =?us-ascii?Q?qCLU6KETHWTXC2fS5lOVYon7TT1Ah4/6puqgjdRAaQrJCNA2Zd/GENmSINOG?=
 =?us-ascii?Q?hoi/LhoxMU5HO2I490935bHeO3mAkTKk4d6nUsyXeUgl6mXwjZi9djKF3ZgB?=
 =?us-ascii?Q?7nmonOVLlnM6166D6I4ZJhjUInIyCBoricl7V5q7fdLMtciFGUGFBPKhKPp7?=
 =?us-ascii?Q?qGP5CYn7/LjBEosA4HH28Yp5LLp57GLI+q4/kmLH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc0b7ea4-9bbe-4792-6a79-08db62334fb6
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 00:01:12.5044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jq5sAN8wX9JiY/QPaZYwGvyNIBYbztQ7d3UwnIVGO1JY3o9xM/FgvXa4DPfR8vjs/3amDknfH9NL07fDUmBnpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8512
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Jason Gunthorpe <jgg@nvidia.com> writes:

> On Wed, May 31, 2023 at 12:46:06PM +1000, Alistair Popple wrote:
>> 
>> Jason Gunthorpe <jgg@nvidia.com> writes:
>> 
>> > On Wed, May 31, 2023 at 10:30:48AM +1000, Alistair Popple wrote:
>> >
>> >> So I'd rather keep the invalidate in ptep_set_access_flags(). Would
>> >> renaming invalidate_range() to invalidate_arch_secondary_tlb() along
>> >> with clearing up the documentation make that more acceptable, at least
>> >> in the short term?
>> >
>> > Then we need to go through removing kvm first I think.
>> 
>> Why? I don't think we need to hold up a fix for something that is an
>> issue today so we can rework a fix for an unrelated problem. 
>
> I'm nervous about affecting KVM's weird usage if we go in and start
> making changes. Getting rid of it first is much safer

Fair enough. In this case though I think we're safe because we won't be
affecting KVM's usage of it - my change only affects ARM64 and KVM only
really uses this on x86 via the arch-specific
kvm_arch_mmu_notifier_invalidate_range() definition.

>> > Yeah, I think I would call it invalidate_arch_secondary_tlb() and
>> > document it as being an arch specific set of invalidations that match
>> > the architected TLB maintenance requrements. And maybe we can check it
>> > more carefully to make it be called in less places. Like I'm not sure
>> > it is right to call it from invalidate_range_end under this new
>> > definition..
>> 
>> I will look at this in more depth, but this comment reminded me there is
>> already an issue with calling .invalidate_range() from
>> invalidate_range_end(). We have seen slow downs when unmapping unused
>> ranges because unmap_vmas() will call .invalidate_range() via
>> .invalidate_range_end() flooding the SMMU with invalidates even though
>> zap_pte_range() skipped it because the PTEs were pte_none.
>
> Yes, if the new API is specifically about synchronizing an architected
> TLB then really the call to the op should be done near the
> architectures TLB flush points, and not higher in the MM.
>
> ie any flush of the CPU tlb should mirror 1:1 to a flush of the IOMMU
> TLB, no broadinging or narrowing.
>
> It is a very clean defintion and we can leap directly to it once we
> get kvm out of the way.

Yes, no argument there.

> Jason

