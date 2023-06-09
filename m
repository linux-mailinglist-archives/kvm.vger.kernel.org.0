Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2BBE728FA8
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 08:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237064AbjFIGKN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 02:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbjFIGKJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 02:10:09 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2078.outbound.protection.outlook.com [40.107.237.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E40330D6;
        Thu,  8 Jun 2023 23:10:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i/KYyYNwfSyk7bW7KQUGy6cB6wzLs0AwZCPd7gOxxTao5XGreHYW8QERHykn1hOa5TPCSwOHwsCqu467V5D2EZuDeUN9E+zGjzvIkzKkix5qDKURKlgLORkd9h3F3+8+XMXLW0EEKGtlyN7yqt+uoZ/NZVWRuuVSfQrhlbFeHlT1r5LV42TNlSgfra5OOVEDWyD0vF/SQfSBpbcAyQXELiU/yfvPts/TCk4zALsNr+5DUwGzxQOQACyh2K0+baO/sA6J5aq0RUni4cMHQHjpK6+/Y7lBdAZ15G5pCzQd4aJzpkWXFdvnuRIqpSAk76vQUNHVnZQ9Bk6OZF/IND6xLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VJ9nHKf0XI91Pm0FPGeUNa7F3CwOdBlY/wzvilPxZLk=;
 b=RX6nDJMx/CZQK/wuhDQvGKNoPCKMFbkGS5jFsW2j8gNN9grRIIeJApC9UVEOSsVIpWAoowBYbrfKM5tdSfsUXw6yryWJY4u0vMfXbryid2kCt6muHrMvHAdtJPMe3qe4Nag3jBuTe1PznOxOGGLPU9wF8uR5MCVc3GOSlJTDJkcIf/gwMTUfXAKEO1OuganBqvrHQnAHhqNl/RNKJbEsEghQ9d/RFuHenzKbLuQLx6nSc66EGNqYCLYxBdJoTZpSOQ3fCLPEDdIhU0e1iXMZtw8GPm8iNU7Gv0yLaWpsdLRJLEnvd0jlUS4iZhLDSgoxMDrAjW5jmvSJ6orttxp0cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VJ9nHKf0XI91Pm0FPGeUNa7F3CwOdBlY/wzvilPxZLk=;
 b=RTm7d3uS08Ba0HFRxGWZVzfmaBPUpLkfRci/Aa94GxGfj9jaCeth97J31LNhsnbBpVqza1PU9JDB5ALTtJhtzS4+MA4mC6yewEX1MGi2N5Kf0ewEPsFVDeUtqvYzF1yFFJs+RFLjVRFr9qMBcKzdjcAh0BsW1rT2dlfulMiZgfm3jesTIeqTdO639ZcR6GHr7CpOtV1TT+g9iW+mn1kYHf6DH/0t38ee6j12O157ll94os/RnQjc11xrYg2jrqzphUw7aPY1ERUoA08FvwzC6Mbv9rgZHqxErYQ/YieGg1aueczKvMZA/KcZsCz45CaQB2GuTvl/QivuiuzPA7QgNw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by BN9PR12MB5049.namprd12.prod.outlook.com (2603:10b6:408:132::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Fri, 9 Jun
 2023 06:10:04 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::4854:668:e67e:b61d]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::4854:668:e67e:b61d%3]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 06:10:03 +0000
References: <3cece716fc09724793aa832e755abfc9d70a8bb3.1684892404.git-series.apopple@nvidia.com>
 <5d8e1f752051173d2d1b5c3e14b54eb3506ed3ef.1684892404.git-series.apopple@nvidia.com>
 <ZHKaBQt8623s9+VK@nvidia.com> <87pm6ii6qi.fsf@nvidia.com>
 <ZHXj/6Bjraxqk4YR@nvidia.com>
 <d2e591c1-eb43-377b-d396-8335f77acef6@arm.com>
 <ZHXxkUe4IZXUc1PV@nvidia.com>
 <89dba89c-cb49-f917-31e4-3eafd484f4b2@arm.com>
 <ZHYCygONW53/Byp3@nvidia.com> <ZHZuSDp6ioPqI272@google.com>
 <ZHaCAJI+OgIfDWSx@nvidia.com> <87v8g9qr2z.fsf@nvidia.com>
 <31cdd164783fefad4c9ef4a6d33c1e0094405d0f03added523a82dd9febdf15f@mu.id>
 <87pm65wfmk.fsf@nvidia.com>
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
Date:   Fri, 09 Jun 2023 16:05:05 +1000
In-reply-to: <87pm65wfmk.fsf@nvidia.com>
Message-ID: <87h6rhw4i0.fsf@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0142.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::27) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|BN9PR12MB5049:EE_
X-MS-Office365-Filtering-Correlation-Id: 33ceaef3-f42e-437b-d108-08db68b029d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: izfs5vgmRodhD0KtXFC5WfUgWLR49fyHGjawfBEujQxjizupgbrdrTWzQLDQd3w4OXiJ+6OOfebBwWhLfPwbb7dpztStlLUQlQFTg0gLNX4Otp3wgTYlhvIPPf/x/PEqlv9DoIaFI9fNysSETZYFjnzVMC0sWAmicflymNS2CPcRfFxXZdZl7fZVULCPh/nF2LPEMfEILMrWlbhWC1V053QR4jLzwYUN4EXrcztnHrDXT++0mocN9T5rLrIGYN54TRqTSy4Ltg/eJzCOEoAfHSAVUyaNr1zT85Gwh/bwdfFvLXz49C0fVVnV6bO7Qo9R9R5TA4S8u8uAacT0K1UMDnCmF01Z4OiAd0Yxxf9Z6TxER0DuAS1bzysFeq6hG/vl8+aGHa87cmlrZSJbnZIE3qRe1baud9RNLAJV4InsWd57ZA8j9vznflSwUCObZj4EDOkGCuvctfOGI02l7hzuIS9wR22YPMjXmQxXC3hUxm22Ji/ebssaGLIQsMB6DIjCEfWHWu2RJ/QGivXYMfc2DprOF6s9i5TIQP9M2Lfvh/OYKjJnLUeJL2sYUvXYGxfx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(366004)(346002)(136003)(396003)(451199021)(6506007)(6512007)(26005)(7416002)(83380400001)(37006003)(86362001)(36756003)(186003)(2906002)(316002)(8676002)(8936002)(41300700001)(2616005)(6862004)(5660300002)(30864003)(4326008)(38100700002)(66556008)(66946007)(54906003)(6636002)(66476007)(478600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9bP06nRyRHOK6oIEQbAMtPmk36T8Jv6O90x3EuPWo6sk7j4pSjwQYrN9qQl/?=
 =?us-ascii?Q?O3vifkUmgMuPfG8lwDvcCGOO/CpH/GIE4A7nPnXiFJLp7Y4ohJWjVQ4w2BRc?=
 =?us-ascii?Q?ZSOuWTI8cvvS3FiI5auJ7AohZanQbGmJw53xRlXtBZDXESszvhTk3glDCCHz?=
 =?us-ascii?Q?PPClKPmnFx44vbSLEF6aX3Pp099eWEq3zYjdKZ+XQCb7geAosfPET0fz/0Bk?=
 =?us-ascii?Q?Rbcm57oVGEMh1qpPYCt7fpV73QIbHB75rcP69wXrPHemgQCCcu0OeOmwxwTI?=
 =?us-ascii?Q?wB8qlzQSuTMR09RukrlWxyKBVFGBgVSN7d8CVLGlFknzxZJHG63tOZNeQSyl?=
 =?us-ascii?Q?5loZMNoYE/vvBA+nuoIm2mVC71wFZzxWHcSS9xiWT059G+fuQkHFhhTuOWQ5?=
 =?us-ascii?Q?EwZeU5wXJAKfyGAEFwOtiNFAVaIVzAE6G+BR8fL8U3uDfwyQwyDSJIi/74yi?=
 =?us-ascii?Q?oEgSl7fWhBNIJRa+r0eW5Heh4P/Q/mSZWDXz6TmqeJNerxVdF0RIf46fGX3W?=
 =?us-ascii?Q?qNllb3QVkmy2SZPrqygi7jJGdv0IJmJ2bTVpw8ILqm7yMQ77Zw1Sk+2kUtY4?=
 =?us-ascii?Q?VsWnlro228dYeAfMHaJGIXaxKZXeJR/G5XBpcSbHuC+9aDcrZ5sdCMbzg9fx?=
 =?us-ascii?Q?JKEe9MlHP71YBSTsAgllxmsg/Y5jx7jKRgt6AiUIQEICb/ekgKldUaWrPLwk?=
 =?us-ascii?Q?6OoYGFQpgoNRnN8ClQvSmmD0xbsQqfI63Sgub3AauS6WJCCgimQNotBjx7rp?=
 =?us-ascii?Q?DDOThFBsOfc+Z/RjL4smCT0SjIM7lOzJ5LAxjV+B+Ru/RHAqvb4nn2ZCvJia?=
 =?us-ascii?Q?93WfG0zuvtMtnjJ6aeUXb+rEXJVFyOCaVagRjm+r47RbTQVFpT9vm3LHS8TG?=
 =?us-ascii?Q?NqIfyrI0Tvyx4wYYMZujMPZg2HC3UgR/u5yUcFG3v6Yq/C86SLiFEyxPOI2l?=
 =?us-ascii?Q?tU4PzHCU+/hFJPI5rn1YIiNHp1sTXE55MV0V4uwtwBTH87nQDMJ6f51WWNYY?=
 =?us-ascii?Q?uvDam1QyINwNZWzYLtfFKUWH0+hv4s4M4HB/JyDFzF27o14ZQsBFkcDC2NcB?=
 =?us-ascii?Q?lx0sSA/m5IFii4Y5cTBBEWxAB/O2PQ6tMMXQMVnlIZEtltq1RkQAPvvp5jXP?=
 =?us-ascii?Q?2lXxJ4pwJ/Q32gjcwJwtYI4ZM09JuHKwdTFD75NVRaKJfGeD/L5UwdPBnvUo?=
 =?us-ascii?Q?67f4v/yfyxGzcB7fCmUMxMN9SS1R3ZsNxdbD6ttAwGDUCRhIEu5mUAxYu/TN?=
 =?us-ascii?Q?eaysPs7IqnFz4rzA+v5y3FKOCY6Hw4lBoA/9KjR6u9h+nymXpH3aeD0wm7Da?=
 =?us-ascii?Q?iIvHY+88mQgJNBDY4bCi9gkjwwm5na9+nWI9G2LpXBMUDPXd9/WSHm6z5dzZ?=
 =?us-ascii?Q?mEeLNQTUpkrioQcYFqDmS2DIawNzPosEhoaGVbO82YSzRmzMwWnCS5gAyuwQ?=
 =?us-ascii?Q?NJ2NzrltfTsE7czmaIOcV/EVYLK9s8Hhtf3Rkl+w8sMm8Kkq1VmkH6z2VCbo?=
 =?us-ascii?Q?RFj6mCLccFMtEnYiQ1qUcRxqdhB7/VmCaTSwzZcv2NyS894Htdhlu3P2+tKX?=
 =?us-ascii?Q?ciN1EQ/PpDMkaggZgPsuXTFN1nvAxymbCSeB7FX5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33ceaef3-f42e-437b-d108-08db68b029d5
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 06:10:03.0137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hYWfPMGBryj4pKZ08D8NNLCNt/BteJRXJpbEilcZ2qu3PjR/ZlKpiL5pGrDwBue89MqTXuvm0ebRIhYdaaV1cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5049
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Alistair Popple <apopple@nvidia.com> writes:

> Alistair Popple <apopple@nvidia.com> writes:
>
>> Alistair Popple <apopple@nvidia.com> writes:
>>
>>>> On Tue, May 30, 2023 at 02:44:40PM -0700, Sean Christopherson wrote:
>>>>> > KVM already has locking for invalidate_start/end - it has to check
>>>>> > mmu_notifier_retry_cache() with the sequence numbers/etc around when
>>>>> > it does does hva_to_pfn()
>>>>> > 
>>>>> > The bug is that the kvm_vcpu_reload_apic_access_page() path is
>>>>> > ignoring this locking so it ignores in-progress range
>>>>> > invalidations. It should spin until the invalidation clears like other
>>>>> > places in KVM.
>>>>> > 
>>>>> > The comment is kind of misleading because drivers shouldn't be abusing
>>>>> > the iommu centric invalidate_range() thing to fix missing locking in
>>>>> > start/end users. :\
>>>>> > 
>>>>> > So if KVM could be fixed up we could make invalidate_range defined to
>>>>> > be an arch specific callback to synchronize the iommu TLB.
>>>>> 
>>>>> And maybe rename invalidate_range() and/or invalidate_range_{start,end}() to make
>>>>> it super obvious that they are intended for two different purposes?  E.g. instead
>>>>> of invalidate_range(), something like invalidate_secondary_tlbs().
>>>>
>>>> Yeah, I think I would call it invalidate_arch_secondary_tlb() and
>>>> document it as being an arch specific set of invalidations that match
>>>> the architected TLB maintenance requrements. And maybe we can check it
>>>> more carefully to make it be called in less places. Like I'm not sure
>>>> it is right to call it from invalidate_range_end under this new
>>>> definition..
>>>
>>> I'd be happy to look at that, although it sounds like Sean already is.
>
> Thanks Sean for getting the KVM fix posted so quickly. I'm looking into
> doing the rename now.
>
> Do we want to do more than a simple rename and tidy up of callers
> though? What I'm thinking is introducing something like an IOMMU/TLB
> specific variant of notifiers (eg. struct tlb_notifier) which has the
> invalidate_secondary_tlbs() callback in say struct tlb_notifier_ops
> rather than leaving that in the mmu_notifier_ops.
>
> Implementation wise we'd reuse most of the mmu_notifier code, but it
> would help make the two different uses of notifiers clearer. Thoughts?

So something like the below incomplete patch (against v6.2) which would
introduce a new struct tlb_notifier and associated ops. The change isn't
huge, but does result in some churn and another layer of indirection in
mmu_notifier.c. Otherwise we can just rename the callback.

--- 

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index a5a63b1c947e..c300cd435609 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -14,7 +14,7 @@
 #include "../../io-pgtable-arm.h"
 
 struct arm_smmu_mmu_notifier {
-	struct mmu_notifier		mn;
+	struct tlb_notifier		mn;
 	struct arm_smmu_ctx_desc	*cd;
 	bool				cleared;
 	refcount_t			refs;
@@ -186,7 +186,7 @@ static void arm_smmu_free_shared_cd(struct arm_smmu_ctx_desc *cd)
 	}
 }
 
-static void arm_smmu_mm_invalidate_range(struct mmu_notifier *mn,
+static void arm_smmu_mm_invalidate_range(struct tlb_notifier *mn,
 					 struct mm_struct *mm,
 					 unsigned long start, unsigned long end)
 {
@@ -207,7 +207,7 @@ static void arm_smmu_mm_invalidate_range(struct mmu_notifier *mn,
 	arm_smmu_atc_inv_domain(smmu_domain, mm->pasid, start, size);
 }
 
-static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
+static void arm_smmu_mm_release(struct tlb_notifier *mn, struct mm_struct *mm)
 {
 	struct arm_smmu_mmu_notifier *smmu_mn = mn_to_smmu(mn);
 	struct arm_smmu_domain *smmu_domain = smmu_mn->domain;
@@ -231,15 +231,15 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 	mutex_unlock(&sva_lock);
 }
 
-static void arm_smmu_mmu_notifier_free(struct mmu_notifier *mn)
+static void arm_smmu_mmu_notifier_free(struct tlb_notifier *mn)
 {
 	kfree(mn_to_smmu(mn));
 }
 
-static const struct mmu_notifier_ops arm_smmu_mmu_notifier_ops = {
-	.invalidate_range	= arm_smmu_mm_invalidate_range,
-	.release		= arm_smmu_mm_release,
-	.free_notifier		= arm_smmu_mmu_notifier_free,
+static const struct tlb_notifier_ops arm_smmu_tlb_notifier_ops = {
+	.invalidate_secondary_tlbs = arm_smmu_mm_invalidate_range,
+	.release		   = arm_smmu_mm_release,
+	.free_notifier		   = arm_smmu_mmu_notifier_free,
 };
 
 /* Allocate or get existing MMU notifier for this {domain, mm} pair */
@@ -252,7 +252,7 @@ arm_smmu_mmu_notifier_get(struct arm_smmu_domain *smmu_domain,
 	struct arm_smmu_mmu_notifier *smmu_mn;
 
 	list_for_each_entry(smmu_mn, &smmu_domain->mmu_notifiers, list) {
-		if (smmu_mn->mn.mm == mm) {
+		if (smmu_mn->mn.mm_notifier_chain.mm == mm) {
 			refcount_inc(&smmu_mn->refs);
 			return smmu_mn;
 		}
@@ -271,9 +271,9 @@ arm_smmu_mmu_notifier_get(struct arm_smmu_domain *smmu_domain,
 	refcount_set(&smmu_mn->refs, 1);
 	smmu_mn->cd = cd;
 	smmu_mn->domain = smmu_domain;
-	smmu_mn->mn.ops = &arm_smmu_mmu_notifier_ops;
+	smmu_mn->mn.ops = &arm_smmu_tlb_notifier_ops;
 
-	ret = mmu_notifier_register(&smmu_mn->mn, mm);
+	ret = tlb_notifier_register(&smmu_mn->mn, mm);
 	if (ret) {
 		kfree(smmu_mn);
 		goto err_free_cd;
@@ -288,7 +288,7 @@ arm_smmu_mmu_notifier_get(struct arm_smmu_domain *smmu_domain,
 
 err_put_notifier:
 	/* Frees smmu_mn */
-	mmu_notifier_put(&smmu_mn->mn);
+	tlb_notifier_put(&smmu_mn->mn);
 err_free_cd:
 	arm_smmu_free_shared_cd(cd);
 	return ERR_PTR(ret);
@@ -296,7 +296,7 @@ arm_smmu_mmu_notifier_get(struct arm_smmu_domain *smmu_domain,
 
 static void arm_smmu_mmu_notifier_put(struct arm_smmu_mmu_notifier *smmu_mn)
 {
-	struct mm_struct *mm = smmu_mn->mn.mm;
+	struct mm_struct *mm = smmu_mn->mn.mm_notifier_chain.mm;
 	struct arm_smmu_ctx_desc *cd = smmu_mn->cd;
 	struct arm_smmu_domain *smmu_domain = smmu_mn->domain;
 
@@ -316,7 +316,7 @@ static void arm_smmu_mmu_notifier_put(struct arm_smmu_mmu_notifier *smmu_mn)
 	}
 
 	/* Frees smmu_mn */
-	mmu_notifier_put(&smmu_mn->mn);
+	tlb_notifier_put(&smmu_mn->mn);
 	arm_smmu_free_shared_cd(cd);
 }
 
diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index d6c06e140277..157571497b28 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -13,6 +13,7 @@ struct mmu_notifier_subscriptions;
 struct mmu_notifier;
 struct mmu_notifier_range;
 struct mmu_interval_notifier;
+struct mm_notifier_chain;
 
 /**
  * enum mmu_notifier_event - reason for the mmu notifier callback
@@ -61,6 +62,18 @@ enum mmu_notifier_event {
 
 #define MMU_NOTIFIER_RANGE_BLOCKABLE (1 << 0)
 
+struct tlb_notifier;
+struct tlb_notifier_ops {
+	void (*invalidate_secondary_tlbs)(struct tlb_notifier *subscription,
+					struct mm_struct *mm,
+					unsigned long start,
+					unsigned long end);
+
+	void (*free_notifier)(struct tlb_notifier *subscription);
+	void (*release)(struct tlb_notifier *subscription,
+			struct mm_struct *mm);
+};
+
 struct mmu_notifier_ops {
 	/*
 	 * Called either by mmu_notifier_unregister or when the mm is
@@ -186,29 +199,6 @@ struct mmu_notifier_ops {
 	void (*invalidate_range_end)(struct mmu_notifier *subscription,
 				     const struct mmu_notifier_range *range);
 
-	/*
-	 * invalidate_range() is either called between
-	 * invalidate_range_start() and invalidate_range_end() when the
-	 * VM has to free pages that where unmapped, but before the
-	 * pages are actually freed, or outside of _start()/_end() when
-	 * a (remote) TLB is necessary.
-	 *
-	 * If invalidate_range() is used to manage a non-CPU TLB with
-	 * shared page-tables, it not necessary to implement the
-	 * invalidate_range_start()/end() notifiers, as
-	 * invalidate_range() already catches the points in time when an
-	 * external TLB range needs to be flushed. For more in depth
-	 * discussion on this see Documentation/mm/mmu_notifier.rst
-	 *
-	 * Note that this function might be called with just a sub-range
-	 * of what was passed to invalidate_range_start()/end(), if
-	 * called between those functions.
-	 */
-	void (*invalidate_range)(struct mmu_notifier *subscription,
-				 struct mm_struct *mm,
-				 unsigned long start,
-				 unsigned long end);
-
 	/*
 	 * These callbacks are used with the get/put interface to manage the
 	 * lifetime of the mmu_notifier memory. alloc_notifier() returns a new
@@ -234,14 +224,23 @@ struct mmu_notifier_ops {
  * 2. One of the reverse map locks is held (i_mmap_rwsem or anon_vma->rwsem).
  * 3. No other concurrent thread can access the list (release)
  */
-struct mmu_notifier {
+struct mm_notifier_chain {
 	struct hlist_node hlist;
-	const struct mmu_notifier_ops *ops;
 	struct mm_struct *mm;
 	struct rcu_head rcu;
 	unsigned int users;
 };
 
+struct mmu_notifier {
+	const struct mmu_notifier_ops *ops;
+	struct mm_notifier_chain mm_notifier_chain;
+};
+
+struct tlb_notifier {
+	const struct tlb_notifier_ops *ops;
+	struct mm_notifier_chain mm_notifier_chain;
+};
+
 /**
  * struct mmu_interval_notifier_ops
  * @invalidate: Upon return the caller must stop using any SPTEs within this
@@ -283,6 +282,10 @@ static inline int mm_has_notifiers(struct mm_struct *mm)
 	return unlikely(mm->notifier_subscriptions);
 }
 
+int tlb_notifier_register(struct tlb_notifier *subscription,
+			struct mm_struct *mm);
+void tlb_notifier_put(struct tlb_notifier *subscription);
+
 struct mmu_notifier *mmu_notifier_get_locked(const struct mmu_notifier_ops *ops,
 					     struct mm_struct *mm);
 static inline struct mmu_notifier *
diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index f45ff1b7626a..cdc3a373a225 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -47,6 +47,16 @@ struct mmu_notifier_subscriptions {
 	struct hlist_head deferred_list;
 };
 
+struct mmu_notifier *mmu_notifier_from_chain(struct mm_notifier_chain *chain)
+{
+	return container_of(chain, struct mmu_notifier, mm_notifier_chain);
+}
+
+struct tlb_notifier *tlb_notifier_from_chain(struct mm_notifier_chain *chain)
+{
+	return container_of(chain, struct tlb_notifier, mm_notifier_chain);
+}
+
 /*
  * This is a collision-retry read-side/write-side 'lock', a lot like a
  * seqcount, however this allows multiple write-sides to hold it at
@@ -299,7 +309,7 @@ static void mn_itree_release(struct mmu_notifier_subscriptions *subscriptions,
 static void mn_hlist_release(struct mmu_notifier_subscriptions *subscriptions,
 			     struct mm_struct *mm)
 {
-	struct mmu_notifier *subscription;
+	struct mm_notifier_chain *chain;
 	int id;
 
 	/*
@@ -307,8 +317,10 @@ static void mn_hlist_release(struct mmu_notifier_subscriptions *subscriptions,
 	 * ->release returns.
 	 */
 	id = srcu_read_lock(&srcu);
-	hlist_for_each_entry_rcu(subscription, &subscriptions->list, hlist,
-				 srcu_read_lock_held(&srcu))
+	hlist_for_each_entry_rcu(chain, &subscriptions->list, hlist,
+				srcu_read_lock_held(&srcu)) {
+		struct mmu_notifier *subscription =
+			mmu_notifier_from_chain(chain);
 		/*
 		 * If ->release runs before mmu_notifier_unregister it must be
 		 * handled, as it's the only way for the driver to flush all
@@ -317,18 +329,19 @@ static void mn_hlist_release(struct mmu_notifier_subscriptions *subscriptions,
 		 */
 		if (subscription->ops->release)
 			subscription->ops->release(subscription, mm);
+	}
 
 	spin_lock(&subscriptions->lock);
 	while (unlikely(!hlist_empty(&subscriptions->list))) {
-		subscription = hlist_entry(subscriptions->list.first,
-					   struct mmu_notifier, hlist);
+		chain = hlist_entry(subscriptions->list.first,
+					   struct mm_notifier_chain, hlist);
 		/*
 		 * We arrived before mmu_notifier_unregister so
 		 * mmu_notifier_unregister will do nothing other than to wait
 		 * for ->release to finish and for mmu_notifier_unregister to
 		 * return.
 		 */
-		hlist_del_init_rcu(&subscription->hlist);
+		hlist_del_init_rcu(&chain->hlist);
 	}
 	spin_unlock(&subscriptions->lock);
 	srcu_read_unlock(&srcu, id);
@@ -366,13 +379,15 @@ int __mmu_notifier_clear_flush_young(struct mm_struct *mm,
 					unsigned long start,
 					unsigned long end)
 {
-	struct mmu_notifier *subscription;
+	struct mm_notifier_chain *chain;
 	int young = 0, id;
 
 	id = srcu_read_lock(&srcu);
-	hlist_for_each_entry_rcu(subscription,
+	hlist_for_each_entry_rcu(chain,
 				 &mm->notifier_subscriptions->list, hlist,
 				 srcu_read_lock_held(&srcu)) {
+		struct mmu_notifier *subscription =
+			mmu_notifier_from_chain(chain);
 		if (subscription->ops->clear_flush_young)
 			young |= subscription->ops->clear_flush_young(
 				subscription, mm, start, end);
@@ -386,13 +401,15 @@ int __mmu_notifier_clear_young(struct mm_struct *mm,
 			       unsigned long start,
 			       unsigned long end)
 {
-	struct mmu_notifier *subscription;
+	struct mm_notifier_chain *chain;
 	int young = 0, id;
 
 	id = srcu_read_lock(&srcu);
-	hlist_for_each_entry_rcu(subscription,
+	hlist_for_each_entry_rcu(chain,
 				 &mm->notifier_subscriptions->list, hlist,
 				 srcu_read_lock_held(&srcu)) {
+		struct mmu_notifier *subscription =
+			mmu_notifier_from_chain(chain);
 		if (subscription->ops->clear_young)
 			young |= subscription->ops->clear_young(subscription,
 								mm, start, end);
@@ -405,13 +422,15 @@ int __mmu_notifier_clear_young(struct mm_struct *mm,
 int __mmu_notifier_test_young(struct mm_struct *mm,
 			      unsigned long address)
 {
-	struct mmu_notifier *subscription;
+	struct mm_notifier_chain *chain;
 	int young = 0, id;
 
 	id = srcu_read_lock(&srcu);
-	hlist_for_each_entry_rcu(subscription,
+	hlist_for_each_entry_rcu(chain,
 				 &mm->notifier_subscriptions->list, hlist,
 				 srcu_read_lock_held(&srcu)) {
+		struct mmu_notifier *subscription =
+			mmu_notifier_from_chain(chain);
 		if (subscription->ops->test_young) {
 			young = subscription->ops->test_young(subscription, mm,
 							      address);
@@ -427,13 +446,15 @@ int __mmu_notifier_test_young(struct mm_struct *mm,
 void __mmu_notifier_change_pte(struct mm_struct *mm, unsigned long address,
 			       pte_t pte)
 {
-	struct mmu_notifier *subscription;
+	struct mm_notifier_chain *chain;
 	int id;
 
 	id = srcu_read_lock(&srcu);
-	hlist_for_each_entry_rcu(subscription,
+	hlist_for_each_entry_rcu(chain,
 				 &mm->notifier_subscriptions->list, hlist,
 				 srcu_read_lock_held(&srcu)) {
+		struct mmu_notifier *subscription =
+			mmu_notifier_from_chain(chain);
 		if (subscription->ops->change_pte)
 			subscription->ops->change_pte(subscription, mm, address,
 						      pte);
@@ -476,13 +497,15 @@ static int mn_hlist_invalidate_range_start(
 	struct mmu_notifier_subscriptions *subscriptions,
 	struct mmu_notifier_range *range)
 {
-	struct mmu_notifier *subscription;
+	struct mm_notifier_chain *chain;
 	int ret = 0;
 	int id;
 
 	id = srcu_read_lock(&srcu);
-	hlist_for_each_entry_rcu(subscription, &subscriptions->list, hlist,
+	hlist_for_each_entry_rcu(chain, &subscriptions->list, hlist,
 				 srcu_read_lock_held(&srcu)) {
+		struct mmu_notifier *subscription =
+			mmu_notifier_from_chain(chain);
 		const struct mmu_notifier_ops *ops = subscription->ops;
 
 		if (ops->invalidate_range_start) {
@@ -519,8 +542,10 @@ static int mn_hlist_invalidate_range_start(
 		 * notifiers and one or more failed start, any that succeeded
 		 * start are expecting their end to be called.  Do so now.
 		 */
-		hlist_for_each_entry_rcu(subscription, &subscriptions->list,
+		hlist_for_each_entry_rcu(chain, &subscriptions->list,
 					 hlist, srcu_read_lock_held(&srcu)) {
+			struct mmu_notifier *subscription =
+				mmu_notifier_from_chain(chain);
 			if (!subscription->ops->invalidate_range_end)
 				continue;
 
@@ -553,35 +578,20 @@ static void
 mn_hlist_invalidate_end(struct mmu_notifier_subscriptions *subscriptions,
 			struct mmu_notifier_range *range, bool only_end)
 {
-	struct mmu_notifier *subscription;
+	struct mm_notifier_chain *chain;
 	int id;
 
 	id = srcu_read_lock(&srcu);
-	hlist_for_each_entry_rcu(subscription, &subscriptions->list, hlist,
+	hlist_for_each_entry_rcu(chain, &subscriptions->list, hlist,
 				 srcu_read_lock_held(&srcu)) {
-		/*
-		 * Call invalidate_range here too to avoid the need for the
-		 * subsystem of having to register an invalidate_range_end
-		 * call-back when there is invalidate_range already. Usually a
-		 * subsystem registers either invalidate_range_start()/end() or
-		 * invalidate_range(), so this will be no additional overhead
-		 * (besides the pointer check).
-		 *
-		 * We skip call to invalidate_range() if we know it is safe ie
-		 * call site use mmu_notifier_invalidate_range_only_end() which
-		 * is safe to do when we know that a call to invalidate_range()
-		 * already happen under page table lock.
-		 */
-		if (!only_end && subscription->ops->invalidate_range)
-			subscription->ops->invalidate_range(subscription,
-							    range->mm,
-							    range->start,
-							    range->end);
-		if (subscription->ops->invalidate_range_end) {
+		struct mmu_notifier *subscription =
+			mmu_notifier_from_chain(chain);
+		const struct mmu_notifier_ops *ops = subscription->ops;
+
+		if (ops->invalidate_range_end) {
 			if (!mmu_notifier_range_blockable(range))
 				non_block_start();
-			subscription->ops->invalidate_range_end(subscription,
-								range);
+			ops->invalidate_range_end(subscription, range);
 			if (!mmu_notifier_range_blockable(range))
 				non_block_end();
 		}
@@ -607,27 +617,24 @@ void __mmu_notifier_invalidate_range_end(struct mmu_notifier_range *range,
 void __mmu_notifier_invalidate_range(struct mm_struct *mm,
 				  unsigned long start, unsigned long end)
 {
-	struct mmu_notifier *subscription;
+	struct mm_notifier_chain *chain;
 	int id;
 
 	id = srcu_read_lock(&srcu);
-	hlist_for_each_entry_rcu(subscription,
+	hlist_for_each_entry_rcu(chain,
 				 &mm->notifier_subscriptions->list, hlist,
 				 srcu_read_lock_held(&srcu)) {
-		if (subscription->ops->invalidate_range)
-			subscription->ops->invalidate_range(subscription, mm,
-							    start, end);
+		struct tlb_notifier *subscription =
+			tlb_notifier_from_chain(chain);
+		if (subscription->ops->invalidate_secondary_tlbs)
+			subscription->ops->invalidate_secondary_tlbs(subscription,
+								mm, start, end);
 	}
 	srcu_read_unlock(&srcu, id);
 }
 
-/*
- * Same as mmu_notifier_register but here the caller must hold the mmap_lock in
- * write mode. A NULL mn signals the notifier is being registered for itree
- * mode.
- */
-int __mmu_notifier_register(struct mmu_notifier *subscription,
-			    struct mm_struct *mm)
+int __mm_notifier_chain_register(struct mm_notifier_chain *chain,
+				struct mm_struct *mm)
 {
 	struct mmu_notifier_subscriptions *subscriptions = NULL;
 	int ret;
@@ -677,14 +684,14 @@ int __mmu_notifier_register(struct mmu_notifier *subscription,
 	if (subscriptions)
 		smp_store_release(&mm->notifier_subscriptions, subscriptions);
 
-	if (subscription) {
+	if (chain) {
 		/* Pairs with the mmdrop in mmu_notifier_unregister_* */
 		mmgrab(mm);
-		subscription->mm = mm;
-		subscription->users = 1;
+		chain->mm = mm;
+		chain->users = 1;
 
 		spin_lock(&mm->notifier_subscriptions->lock);
-		hlist_add_head_rcu(&subscription->hlist,
+		hlist_add_head_rcu(&chain->hlist,
 				   &mm->notifier_subscriptions->list);
 		spin_unlock(&mm->notifier_subscriptions->lock);
 	} else
@@ -698,6 +705,18 @@ int __mmu_notifier_register(struct mmu_notifier *subscription,
 	kfree(subscriptions);
 	return ret;
 }
+
+/*
+ * Same as mmu_notifier_register but here the caller must hold the mmap_lock in
+ * write mode. A NULL mn signals the notifier is being registered for itree
+ * mode.
+ */
+int __mmu_notifier_register(struct mmu_notifier *subscription,
+			    struct mm_struct *mm)
+{
+	return __mm_notifier_chain_register(&subscription->mm_notifier_chain,
+					mm);
+}
 EXPORT_SYMBOL_GPL(__mmu_notifier_register);
 
 /**
@@ -731,20 +750,34 @@ int mmu_notifier_register(struct mmu_notifier *subscription,
 }
 EXPORT_SYMBOL_GPL(mmu_notifier_register);
 
+int tlb_notifier_register(struct tlb_notifier *subscription,
+			struct mm_struct *mm)
+{
+	int ret;
+
+	mmap_write_lock(mm);
+	ret = __mm_notifier_chain_register(&subscription->mm_notifier_chain, mm);
+	mmap_write_unlock(mm);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tlb_notifier_register);
+
 static struct mmu_notifier *
 find_get_mmu_notifier(struct mm_struct *mm, const struct mmu_notifier_ops *ops)
 {
-	struct mmu_notifier *subscription;
+	struct mm_notifier_chain *chain;
 
 	spin_lock(&mm->notifier_subscriptions->lock);
-	hlist_for_each_entry_rcu(subscription,
+	hlist_for_each_entry_rcu(chain,
 				 &mm->notifier_subscriptions->list, hlist,
 				 lockdep_is_held(&mm->notifier_subscriptions->lock)) {
+		struct mmu_notifier *subscription =
+			mmu_notifier_from_chain(chain);
 		if (subscription->ops != ops)
 			continue;
 
-		if (likely(subscription->users != UINT_MAX))
-			subscription->users++;
+		if (likely(chain->users != UINT_MAX))
+			chain->users++;
 		else
 			subscription = ERR_PTR(-EOVERFLOW);
 		spin_unlock(&mm->notifier_subscriptions->lock);
@@ -822,7 +855,7 @@ void mmu_notifier_unregister(struct mmu_notifier *subscription,
 {
 	BUG_ON(atomic_read(&mm->mm_count) <= 0);
 
-	if (!hlist_unhashed(&subscription->hlist)) {
+	if (!hlist_unhashed(&subscription->mm_notifier_chain.hlist)) {
 		/*
 		 * SRCU here will force exit_mmap to wait for ->release to
 		 * finish before freeing the pages.
@@ -843,7 +876,7 @@ void mmu_notifier_unregister(struct mmu_notifier *subscription,
 		 * Can not use list_del_rcu() since __mmu_notifier_release
 		 * can delete it before we hold the lock.
 		 */
-		hlist_del_init_rcu(&subscription->hlist);
+		hlist_del_init_rcu(&subscription->mm_notifier_chain.hlist);
 		spin_unlock(&mm->notifier_subscriptions->lock);
 	}
 
@@ -861,15 +894,34 @@ EXPORT_SYMBOL_GPL(mmu_notifier_unregister);
 
 static void mmu_notifier_free_rcu(struct rcu_head *rcu)
 {
-	struct mmu_notifier *subscription =
-		container_of(rcu, struct mmu_notifier, rcu);
-	struct mm_struct *mm = subscription->mm;
+	struct mm_notifier_chain *chain =
+		container_of(rcu, struct mm_notifier_chain, rcu);
+	struct mm_struct *mm = chain->mm;
+	struct mmu_notifier *subscription = mmu_notifier_from_chain(chain);
 
 	subscription->ops->free_notifier(subscription);
 	/* Pairs with the get in __mmu_notifier_register() */
 	mmdrop(mm);
 }
 
+void mm_notifier_chain_put(struct mm_notifier_chain *chain)
+{
+	struct mm_struct *mm = chain->mm;
+
+	spin_lock(&mm->notifier_subscriptions->lock);
+	if (WARN_ON(!chain->users) ||
+		--chain->users)
+		goto out_unlock;
+	hlist_del_init_rcu(&chain->hlist);
+	spin_unlock(&mm->notifier_subscriptions->lock);
+
+	call_srcu(&srcu, &chain->rcu, mmu_notifier_free_rcu);
+	return;
+
+out_unlock:
+	spin_unlock(&mm->notifier_subscriptions->lock);
+}
+
 /**
  * mmu_notifier_put - Release the reference on the notifier
  * @subscription: The notifier to act on
@@ -894,22 +946,16 @@ static void mmu_notifier_free_rcu(struct rcu_head *rcu)
  */
 void mmu_notifier_put(struct mmu_notifier *subscription)
 {
-	struct mm_struct *mm = subscription->mm;
-
-	spin_lock(&mm->notifier_subscriptions->lock);
-	if (WARN_ON(!subscription->users) || --subscription->users)
-		goto out_unlock;
-	hlist_del_init_rcu(&subscription->hlist);
-	spin_unlock(&mm->notifier_subscriptions->lock);
-
-	call_srcu(&srcu, &subscription->rcu, mmu_notifier_free_rcu);
-	return;
-
-out_unlock:
-	spin_unlock(&mm->notifier_subscriptions->lock);
+	mm_notifier_chain_put(&subscription->mm_notifier_chain);
 }
 EXPORT_SYMBOL_GPL(mmu_notifier_put);
 
+void tlb_notifier_put(struct tlb_notifier *subscription)
+{
+	mm_notifier_chain_put(&subscription->mm_notifier_chain);
+}
+EXPORT_SYMBOL_GPL(tlb_notifier_put);
+
 static int __mmu_interval_notifier_insert(
 	struct mmu_interval_notifier *interval_sub, struct mm_struct *mm,
 	struct mmu_notifier_subscriptions *subscriptions, unsigned long start,
