Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6B8C6F6E90
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 17:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbjEDPEF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 11:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbjEDPEA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 11:04:00 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE222C3
        for <kvm@vger.kernel.org>; Thu,  4 May 2023 08:03:56 -0700 (PDT)
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 344AId3G002006;
        Thu, 4 May 2023 07:44:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=Pit/0v08XEtz7UrRvzsc+jL0tOSpDZzChH6nGG9Y3Fw=;
 b=TOQqJ41DvlQ/hQh/u9/oW2JA7+7DKSVF5/zOfnftWmOlXFID01gBF/ggOGwoLkXiQDBa
 nZblUHVaJ3aroUthb6hv8u2L+Li2HEHCRCPrlTcw6reP+PlkBgzeBKVDifDNVKg94z/A
 uRjiDOxUsLUSLa1t3WrCZLgKudJTs64bc9poXIIWNFhivV3ju7E7c8TiAa7A7BCpl/m4
 Hw9Oqkl/wznRvbF41fJjDYhD6xL1SmvlNbfZwBI+h1np/u++F/qzFzYmFZyTPhvvJtlv
 9Tnu/y5+G8yCxtBH7foKyu33VBUMftrFOid5X2F3NWbdhbvI4yMvLS150KS8DnRrJn/n Kg== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3q92ajje30-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 May 2023 07:44:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WbWSOw58Kh9I0hbhKoRnfRoZC2jHYPcE0snqkasx1PbzeAYe1qPVWGRQ/FJm4kSQIhHu12/05vNaprEALf2ppaBB7MtfnRd/Hc6QQe4LaY9hDEIO99cRq2dlOZ0T4m0cOdK5PPmJXFaFdnuF4zuN88Gg9jy5zMlcb6tWVNC61NcJRitLRBw3Is443zMYNNsM3XWijkM7+G9Xbr5GBVYjcOIy1U0vV8LyobUmvjJIf83fD0HP0Xme7yTxC2ms5wGHEiOggb6Hjsft8FyFF/zRgyAL8aphg01vUnKOJgFOZW2ouUaFx6G6eivvG4aB44h5vrulExYQAPEH9WfFFAb+3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pit/0v08XEtz7UrRvzsc+jL0tOSpDZzChH6nGG9Y3Fw=;
 b=TfgcmG60Eu1wSL3bfjXo0SyhnSDS1G+3MV9u0E/62AKJdj9pZNnYPa8aXDikkMNDakvf0LfZpj6jejOtigoVDbXI8cIkEWI1vsqCPNm0+1i9fHh9wyoz96wQ9b1jZbAjt3rVlYf5u/vH4Vx0kvdfowXSC0HcPZJ1zmqMMT5Xtf4+jBd1jdAba8Fbi9c7PtsU1tPG3oSI1VyjQybV38Tjh5FU9fogziq6DwXEJ3Yl9KEQSNXA9Lzmfb5D44BJclObHeQbut3IQJkuQOjorSYTzcYUUQko4411vIW2oESFmEZG/YgwLCPZe/3h2iJBdAAxXpG0zU4hi6WbWtGeaLjyCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pit/0v08XEtz7UrRvzsc+jL0tOSpDZzChH6nGG9Y3Fw=;
 b=YiDhctUjFsMlJXsoySqo2NLm5UVmQ9FZyUqzdFh47i2cepFPr6Qx5ik7NNIDn8yVkc2TLWzvsp1V6O2E6O8OY4VBN9GyLXO4XPamy7i3vl/9wnWjznA3QVv5K28aD8NdcgxlFo/OrNZJ9uAu/jzxWzIscl91AkAWIv1AqawZjzQ2lsAk7aMOwh2jBMleUvyBxIUcPx/yzp07XrBXReeVVKF7Vkj4f7RXrYHmEICDir/dGpS0S34SyDObrfpqhZeaiIYyx4UyM8mmIeBOqKC1iDz2ENrJ8Qny2/F1vtmtscFqCREAI5XZl5l5KqbENBtpWFwZk4jFwrz6t6DDOOoObw==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by PH0PR02MB9383.namprd02.prod.outlook.com (2603:10b6:510:289::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22; Thu, 4 May
 2023 14:44:48 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::bef3:605f:19ff:568a]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::bef3:605f:19ff:568a%2]) with mapi id 15.20.6363.026; Thu, 4 May 2023
 14:44:48 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com,
        aravind.retnakaran@nutanix.com, david@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: [PATCH v9 2/3] KVM: x86: Dirty quota-based throttling of vcpus
Date:   Thu,  4 May 2023 14:43:29 +0000
Message-Id: <20230504144328.139462-3-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
In-Reply-To: <20230504144328.139462-1-shivam.kumar1@nutanix.com>
References: <20230504144328.139462-1-shivam.kumar1@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0274.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::9) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|PH0PR02MB9383:EE_
X-MS-Office365-Filtering-Correlation-Id: a8b3b873-ce53-4649-ee8e-08db4cae1c04
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BQNLgwCsJ+9tb4lrD0UQtPTV78AlQe30Kavoi+Pbfr9tUTcE/qCRLgZUdBlYkFCrK3MXrnCPieNYubE7ip9OGknrQqL0PzAIwRPxLJ44SP4XuelW8iexMx4L5W3DN+9uLXIqrR3H6WvWqrVQsEVvVE27mEOPst3nYvieUZHONwSLl0veMQzMS8XwdsQQh9eg1hhx7zysTIKmzf5cm8uEz76InjlGshxQt2sdhpEl46bpcwQPQkheZJYaa79FzmCoI0YBAo0ybqndSALuewOmHkRab5CZgA+MnE5a84Nm/aklTZncJtjWLe3nbaoh+v0c/JkQKgLKHCQm6rzvJICIEHPdkb89WU9x60CjAEaIEkH6LHa3qOXEEdU72f8oLwsmnWfstoE6ZCuvOX06y4yYohyP9hriG5RdXP0ztognqi917BTvFIPqYcHlbgBp8nA3y5Yj9wAMFJrxIFLwFiV/DJzIC2OXRs+f4GIHfbq3dsaDdlGrtw2KSoFtUDoVuvkXLb5pgfF5ZxTJlyKQiYAERVNB/8dLbFGtYKqNsvbyPb1btwsc0U4oscEtJIU9bQ8kUc0xZBtf51GAWqVUbj9zO7ewYUbreU2gnGDykQXPyVzEQP3Wk8YIuRAdr8KwV0P+HMSNB75mabyly1KGCj3rJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(376002)(396003)(366004)(346002)(451199021)(5660300002)(107886003)(36756003)(6666004)(41300700001)(478600001)(316002)(66476007)(66556008)(66946007)(8936002)(4326008)(8676002)(38100700002)(52116002)(86362001)(38350700002)(6486002)(2616005)(186003)(54906003)(6506007)(83380400001)(6512007)(1076003)(26005)(2906002)(15650500001)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4UYRehG+ItRDBcF6awFJkRK+F2MPSJ7vXYXpBVs8VH6lWW1fFI7QijMQvEmY?=
 =?us-ascii?Q?iNB4bl9RsOIHxPp6BVha4AFUPKohLoWG3+EKSC9D3HoTspRNUL9DpCrKf00j?=
 =?us-ascii?Q?HI+wD+fcQL3iKAJcsSKdgv7MjGAjravJNRDtCQ8VTAATbyS4/nL5geTCCtph?=
 =?us-ascii?Q?fU48c00I5qUV8ego2v8RCbkfLArqu9GIdztiIc1NucSOllMwE4Aj+eOwANF+?=
 =?us-ascii?Q?Yn63yNmvI4vEMQFN+44CSDAaOJ2CsU4HAqC/+ldS9tLAjnw1JFSZLM8cqdN3?=
 =?us-ascii?Q?kT56sRAAAaoHX8BNZ8Zm94IXgW69khlARV++6jKeiON0hWOjGGUmpz1PnJFo?=
 =?us-ascii?Q?w2W96ODsSf/FXcHY4N50j7vqVd0WWtNzlN8sbaB9MMYaw/hH2I3IiXRVBIpP?=
 =?us-ascii?Q?1El7KqBODsA3WdXggLxomrHYT7TiIq4yU+EHUXmMyPphxy7tBj+ly9rWYwUv?=
 =?us-ascii?Q?ra22VW4GgAv+p5W1DB8CD+rHi1eHMnum9uBxC7JX8S6KCh8ZruFKKrCfczEK?=
 =?us-ascii?Q?7I9cK5QOf51vEybcDVK+6W/u76rjKak0GfN7Nw7+ryAmFnLOP+LjO/eAcSkN?=
 =?us-ascii?Q?c1LOx/NQE2XAoBG+P3Mho76l/DzvMGIGEFqo5Y2inmpF5Zos7vXTtSG2MhB0?=
 =?us-ascii?Q?hTP6x4S5DVNoI8xct9wputGsIuotzW6Rz6cj7FCwqbjW+MSRs7Pr7kr67RYL?=
 =?us-ascii?Q?qM6Cy43g31Ja62OssyO5OehxdTUfTyFp97DVNF8PWjXjZWPq43z4y39hbzLN?=
 =?us-ascii?Q?YcDbyoGCFhNL/vWjf0fm6987uQuU/MYjJud0LVNff8Cb5NIQKvMjd4K0SkHY?=
 =?us-ascii?Q?kcPfZwJW2RWQhdogqxhf8soqkOfQEVxC7Ws/Sw1ddrYnd4b6X24Q2ksDEJ7V?=
 =?us-ascii?Q?NuXPQcKZbL7OwFVD3oaTyxLjV8ldzLR4zRJmxeWsJQQzUKAn5dkesQIqeqFi?=
 =?us-ascii?Q?KKLLg8XJNVjyTmjfm2+81XCTQqH3YI1OzHAR1VxBsEKdNUQXhNgDd4WymYBN?=
 =?us-ascii?Q?tD4jl4gPM9FccIr8ww2jdlIw5/MkQVwyLeVb9IoEv+ACezmAB0OvT2sruP2U?=
 =?us-ascii?Q?Z3sRK7hRPFlt3q8zSyUz1K2696C/GFsw8MmY5nTgw+GX7p0B71ggu39UEKdi?=
 =?us-ascii?Q?oCsrqXOkNbQ2pM6XFh/AKGeI3zC/Bh1cXJJT+Zv+1DGsxS/8ArSw75Ab1vCg?=
 =?us-ascii?Q?9Ymz+e0i34cmunC9AadNoxjy7vGEFZ3EY3G7fkyGd2V9F6M7jkrhUV6RUUaa?=
 =?us-ascii?Q?3JktbiksKbajN5fUAV/9ZjdXME/FMmYZku0FN0VogPmGh7Dc/K/FrTd9HP2P?=
 =?us-ascii?Q?MFsUIzRvAGBbHAbiKKsXm7vlBQbT2uPKFGoGxBKcpikcrq0E06z298KaU6jB?=
 =?us-ascii?Q?2M6yl976/VdvHEUOqq3HmeH18jNQsfEZ9znuZkdGL1HxOtC9AKWC9rmHxBu6?=
 =?us-ascii?Q?C39odiEbO9F5/WtZroW7odBT5+jEWbhEuwO3fRJqXfgNLTD5apJnqdmS/hhI?=
 =?us-ascii?Q?vbnFEpEK+l0nHeJ2LTDbyLqkDnaQ/KmcFupqSsVDEs6i1Q207IsFx5w1LRF7?=
 =?us-ascii?Q?aFyp2+GkhAnwJ2hTFqWSt34KZW4o1NPgL0hdNsQ6zYzvjoaOAWdwMEDSqDMG?=
 =?us-ascii?Q?Zg=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8b3b873-ce53-4649-ee8e-08db4cae1c04
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 14:44:48.2838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mZI+q2N3R/uGqxbI1ffajvHs0d3fw066XIHazP5hU7ECEFcRQbg/K3AJ1BRxI14FtC6FM221AzeC8jjeaVn+55z1Ktvla/Cng/kgY+vM42U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB9383
X-Proofpoint-ORIG-GUID: IGVWb1xkrdXmr5ABEQr3bNJy6w4_2_wQ
X-Proofpoint-GUID: IGVWb1xkrdXmr5ABEQr3bNJy6w4_2_wQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-04_09,2023-05-04_01,2023-02-09_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Call update_dirty_quota whenever a page is marked dirty with
appropriate arch-specific page size. Process the KVM request
KVM_REQ_DIRTY_QUOTA_EXIT (raised by update_dirty_quota) to exit to
userspace with exit reason KVM_EXIT_DIRTY_QUOTA_EXHAUSTED.

Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
---
 arch/x86/kvm/Kconfig    | 1 +
 arch/x86/kvm/mmu/mmu.c  | 6 +++++-
 arch/x86/kvm/mmu/spte.c | 1 +
 arch/x86/kvm/vmx/vmx.c  | 3 +++
 arch/x86/kvm/x86.c      | 9 ++++++++-
 arch/x86/kvm/xen.c      | 6 +++++-
 6 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 89ca7f4c1464..bb18fb912293 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -47,6 +47,7 @@ config KVM
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_VFIO
 	select INTERVAL_TREE
+	select HAVE_KVM_DIRTY_QUOTA
 	select HAVE_KVM_PM_NOTIFIER if PM
 	select KVM_GENERIC_HARDWARE_ENABLING
 	help
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c8961f45e3b1..f9788fbc32ae 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3401,8 +3401,12 @@ static bool fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu,
 	if (!try_cmpxchg64(sptep, &old_spte, new_spte))
 		return false;
 
-	if (is_writable_pte(new_spte) && !is_writable_pte(old_spte))
+	if (is_writable_pte(new_spte) && !is_writable_pte(old_spte)) {
+		struct kvm_mmu_page *sp = sptep_to_sp(sptep);
+
+		update_dirty_quota(vcpu->kvm, (1L << SPTE_LEVEL_SHIFT(sp->role.level)));
 		mark_page_dirty_in_slot(vcpu->kvm, fault->slot, fault->gfn);
+	}
 
 	return true;
 }
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index cf2c6426a6fc..5930af8a3de2 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -243,6 +243,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	if ((spte & PT_WRITABLE_MASK) && kvm_slot_dirty_track_enabled(slot)) {
 		/* Enforced by kvm_mmu_hugepage_adjust. */
 		WARN_ON(level > PG_LEVEL_4K);
+		update_dirty_quota(vcpu->kvm, (1L << SPTE_LEVEL_SHIFT(level)));
 		mark_page_dirty_in_slot(vcpu->kvm, slot, gfn);
 	}
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 44fb619803b8..732541ea446b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5834,6 +5834,9 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 		 */
 		if (__xfer_to_guest_mode_work_pending())
 			return 1;
+
+		if (kvm_test_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu))
+			return 1;
 	}
 
 	return 1;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ceb7c5e9cf9e..5d6016906a88 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3125,6 +3125,7 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
 
 	guest_hv_clock->version = ++vcpu->hv_clock.version;
 
+	update_dirty_quota(v->kvm, PAGE_SIZE);
 	mark_page_dirty_in_slot(v->kvm, gpc->memslot, gpc->gpa >> PAGE_SHIFT);
 	read_unlock_irqrestore(&gpc->lock, flags);
 
@@ -3599,6 +3600,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
  out:
 	user_access_end();
  dirty:
+	update_dirty_quota(vcpu->kvm, PAGE_SIZE);
 	mark_page_dirty_in_slot(vcpu->kvm, ghc->memslot, gpa_to_gfn(ghc->gpa));
 }
 
@@ -4878,6 +4880,7 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 	if (!copy_to_user_nofault(&st->preempted, &preempted, sizeof(preempted)))
 		vcpu->arch.st.preempted = KVM_VCPU_PREEMPTED;
 
+	update_dirty_quota(vcpu->kvm, PAGE_SIZE);
 	mark_page_dirty_in_slot(vcpu->kvm, ghc->memslot, gpa_to_gfn(ghc->gpa));
 }
 
@@ -10608,7 +10611,11 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			r = 0;
 			goto out;
 		}
-
+		if (kvm_check_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu)) {
+			vcpu->run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
+			r = 0;
+			goto out;
+		}
 		/*
 		 * KVM_REQ_HV_STIMER has to be processed after
 		 * KVM_REQ_CLOCK_UPDATE, because Hyper-V SynIC timers
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 40edf4d1974c..202118f66063 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -435,9 +435,12 @@ static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
 
 	read_unlock_irqrestore(&gpc1->lock, flags);
 
+	update_dirty_quota(v->kvm, PAGE_SIZE);
 	mark_page_dirty_in_slot(v->kvm, gpc1->memslot, gpc1->gpa >> PAGE_SHIFT);
-	if (user_len2)
+	if (user_len2) {
+		update_dirty_quota(v->kvm, PAGE_SIZE);
 		mark_page_dirty_in_slot(v->kvm, gpc2->memslot, gpc2->gpa >> PAGE_SHIFT);
+	}
 }
 
 void kvm_xen_update_runstate(struct kvm_vcpu *v, int state)
@@ -549,6 +552,7 @@ void kvm_xen_inject_pending_events(struct kvm_vcpu *v)
 	if (v->arch.xen.upcall_vector)
 		kvm_xen_inject_vcpu_vector(v);
 
+	update_dirty_quota(v->kvm, PAGE_SIZE);
 	mark_page_dirty_in_slot(v->kvm, gpc->memslot, gpc->gpa >> PAGE_SHIFT);
 }
 
-- 
2.22.3

