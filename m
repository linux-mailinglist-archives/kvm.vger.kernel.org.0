Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4B1A51ACF6
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 20:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377249AbiEDSie (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 14:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376938AbiEDSiV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 14:38:21 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34607237D6;
        Wed,  4 May 2022 11:28:34 -0700 (PDT)
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 244HRaF9016187;
        Wed, 4 May 2022 11:27:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=proofpoint20171006;
 bh=ayCume7tUY5SxwPCaFtQdoxD6L0q2t7pmL8tl4OsNdw=;
 b=wDobf7YTxVvKWahzU9iquVhAegx63ymbK90JskfMAZrUdGqjemozK9uuS7lTwLCgsoqp
 0auHyHwvEh6cRGZG3oZ00sdmzXuc/xNeokziuRV8PaBTyNenSNYhax+1iPNup0E3FoiD
 jWzOlU1idKLeyIFPMRoKaaoP/NQq91O/MbDFtwY6g9orm3mDFJayWEJ0lingHiT8oD+a
 79rGnmyBuTgeTpflttjNZrtJB9GfsVv7v1cWPBj4I0Pal8qnkaBOKNG8YeVLwX0ztBfS
 bqhjHrtu87tCtX4Fdo4ZXW6X/cUQWMjstsNy9ck9PtSAEwYXNSNZYeZ3ImICpZdfMV83 6Q== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3fs46gggku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 May 2022 11:27:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IRHUiPxmeoE0p1B6QYulCAWVHGpAK8G7/bn+bQdsMqR/gcAwRkuYfe7xDl9ZwEPpEMOkTirYZV4acbddFsgwzkdAcDoqHZIJOKKUDeYSTUYrv7sL8QCRh18YM4bMDkxTtZZ80nX4X+rZaKgJMBNmGuBg9qyUx04qZqYAjLfppKOKvXL+voGRGY1wl8hAPnPrufa5Qh0EmJ00EaHHGtrbA8AiUEpbNlftQWsFTPkgX54IZ8D88I5JNRY/Bf3WLWaaV+BlRNCaW6OEQ5N5Jd6963VK3kg3RgtU5MrNTsLQyfgsZbRcwseB0MKqtIbVTA9RqjiQ+/jzQD+8peS12BPJcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ayCume7tUY5SxwPCaFtQdoxD6L0q2t7pmL8tl4OsNdw=;
 b=BOayZNdMgdDfscO98F+Z2lnaQr8xyUCCwnmbGkV0GEXgE3BL+Z8ibFE918zEvzr3VxaK2tm1r0NXV1Q3hzA3l7PS7Y6WRHGgs6uMyD9/xTO9MtYWUjJqWQUF+WmqykjnO68sSwQdV5JwfNgf74lwrCOj+18r/kKz7szASf8mQL0me4Hx2pb+sQL1ordeyoE95Idz8JXiMv/d0UVs7+Ujmyfmbnq8LPrPbzE3l3vuvrgMA2JMWVHlV5Bp5JsyC+UWYhAAFfQ0AnGK+R118jh2eYk5TOAJ8ubbN4x7wpmSpEbMrmxZUA0/9bHM36DuDLkWrFOlNU60x+PV1ZmM3a+VFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by BN0PR02MB8030.namprd02.prod.outlook.com (2603:10b6:408:16d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Wed, 4 May
 2022 18:27:31 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f%5]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 18:27:31 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Jon Kohler <jon@nutanix.com>
Subject: [PATCH] KVM: X86: correct trace_kvm_pv_tlb_flush stats
Date:   Wed,  4 May 2022 14:27:07 -0400
Message-Id: <20220504182707.680-1-jon@nutanix.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0068.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::45) To BL0PR02MB4579.namprd02.prod.outlook.com
 (2603:10b6:208:4b::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69982b80-11d2-4f21-0301-08da2dfbc029
X-MS-TrafficTypeDiagnostic: BN0PR02MB8030:EE_
X-Microsoft-Antispam-PRVS: <BN0PR02MB8030C188122C946EA4DC9F66AFC39@BN0PR02MB8030.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QnxGtn0aGzO71BkHl/n/yhKME2B20/ZtNEdzfeLXGkCPm0y+bPD1rIKaG93PVJRuXV/XvlnRPrgZzxSuSq2vOrzXp+Hb5j8ACSVhhd2aGsH9SaCQB1uUCjSOPHS0bLzcVvlncg86sWlr1Z9mAKVcRkCWvgyefp5p3b3Hms1xMWxTaGLuvts9fHnvujpxJwSoFfblbX79aGyhxZj4BhHJ/aiBT96eh3REppAziYKmgphLNrr9xgqlmCAj2Lg79yo8z1DtTz85v0PlKR7spIwgAuaWUFfDq/gTWGTEH9LrWsfcycuxDvts8EoP1Y2vlMGQ5WnLc7vT8bz67WLwrSu1EENt759vX5DzjiU+ohBTItAmuuWAJKpnQumaQxBSwaFDcoWWijkHgAMQY1P9Bdlxs6CC3gTS9MeAd98tMGlyK+dmoVGwlV03bA1eN5IuRP46k0Cv5aCf4VvB+LdUpoIJ0Xa6ho2PYG1bgTPbpwXtaxJQz+h8u6DdpkGFsBwXpdh521HpWEi1UA4R0h/lQEtbcdIHerCPy361V7gSd9l9JJoH3ZSRg9xBf+KSa7etPTP5cH0L2vOS3+ssGm6YoVoxFonq2xGTu2z7A6Uz3vH6+MN9iLNrUubY/Btn2GiItcZ1vltlZD/7EWOC5RI+EKGQ4fptEV8x+inaS1tl8Z1gJNfAk7Bnu8TLbw1XrqwahTp7oRnDwH3Bm1BT4e9QD6w76w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(6486002)(38100700002)(2906002)(52116002)(921005)(6666004)(8936002)(6506007)(508600001)(86362001)(6512007)(1076003)(4326008)(110136005)(2616005)(186003)(5660300002)(316002)(7416002)(107886003)(66946007)(8676002)(83380400001)(66556008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3RcRWUqZ6mKOIZyFHHJxM1wr7pylLBU+UeOPTqcZRi8cL2AdKZSxg8rJ+c/U?=
 =?us-ascii?Q?dmgSI9l/RthE7KGiPLZbah1JZxDID7znjUk3S/ep+EyqVutxIB8fopjiSoMv?=
 =?us-ascii?Q?GCnt41ovRIG82uq7Q9lqRjwxfdGjXvGETFxKEbh63uStItaTq6+xi6tJJDKx?=
 =?us-ascii?Q?rvEH6tdty/QKJWtZBYO/RR7lCDLaECJRrsIL6NaeV6d14oyz02FhX12pi/pb?=
 =?us-ascii?Q?JYkkx340ESiOvUMWP0v5xoiAwyMVqjsJEv94A4eRiYyOJkz32Lf8Cp3S6BWS?=
 =?us-ascii?Q?6eR5MHH7QkSCxsZgPAjlXQ3rV3KgYjYuYCFabxYD2wtXXndBx2RUa7lU2jt0?=
 =?us-ascii?Q?W7x+W+r6Poq6NIgcb3wLtj0IBth1JcLWl+q2dSoUE8pk0DxaOZ2B5dquoJjs?=
 =?us-ascii?Q?NA7ZWWxVT4go9F+pLFyPdBTf0kFR/3hPgoVS+lNLXj7kp45t6cLDdhEhuOjr?=
 =?us-ascii?Q?qAt5ICw1eN3Su3PJGQ3uczNSFo+4KbR8MczMkjtNnIiNX2pA0XTsB16yvG2f?=
 =?us-ascii?Q?PJtH6mtKqQsBXAWB+6mNR6QejL8BusN+YvSPdvPoUgLM2+le1JWu7z2oeiSk?=
 =?us-ascii?Q?8uNpg3R6PBc1XHvltDPkm/h3uOQHqG/ZSEAvkh0XgnWtJO1SuLFLhggHASbM?=
 =?us-ascii?Q?9S0/X1zKNYvl8g6rWR7WR0XNpNIJbT9jfw2O5qN1MPg9LNFH5atmjISwqLH/?=
 =?us-ascii?Q?sm4VwCs89JPISyUPz/QDZ3bfG+yoXncOipmpFTmnqlJCTHCwwZp8hXXYSj2U?=
 =?us-ascii?Q?dyTWuw5Jwy2CMOdNHU2cmMZnEjdfeb27HbyXyzyymZpQbkJ3/zdAyTNzNrV4?=
 =?us-ascii?Q?vBQKTmDR0ddx2NbTMzjsgZkdYDQHhgGrNNPpW77+4yGodxQWCsHHWjyInoNq?=
 =?us-ascii?Q?RlRDxzwySPW4TnrIvl4SgRLPqjjSnutfi42bufxcHhEovZ690dHr5lodUCZr?=
 =?us-ascii?Q?9iV2YOMe2uF1W1r/YHLrsTLJFSPr19h3CUvZXxgbrmW1862lcv4s/RG7HaRj?=
 =?us-ascii?Q?6wGH7ruecgurtG5L6MIXVJzqBcIs8MaCMyvabn1juzRZKsKlA1zPHLzXiLof?=
 =?us-ascii?Q?Spt0wT/tad3E+P2BoSRaqf1R8piyDwgHm1uEmajTo8aj26xzLQDQ/6K3JFfI?=
 =?us-ascii?Q?4pIGwWvqjN+0cuWRcvgGEkAIE3U8o+ul5Sy6viVRaPOf/7y1nrNa4BR8iVRB?=
 =?us-ascii?Q?nFqB6VgDq+citIGg1VKrpQCV9RTFqx14uI4e0K0mau58TzAyPAWEGtvTGIeM?=
 =?us-ascii?Q?Pfi6qSXrU3xeVJtpfBMvbZfWfbmN/MbfL3+3oEuMDSUUd9wpElNbUOs2gcCw?=
 =?us-ascii?Q?E646CSEtMEBwxAeADG6fAM6vuXPS4ff24KFjKRHx5QMI5L3cMR3+taA2pIkM?=
 =?us-ascii?Q?g+tWG+fxc8sZrTHYG7DvMbLRn7EyU3pchL3TUb7Dn3MYgah5P58TD6OFfkx6?=
 =?us-ascii?Q?bLj8K9Vq6RdPh+FOfhRBt1snPzU9DGvXapuK3qfHsQ0Iw9cFPhFNWFwa3qHJ?=
 =?us-ascii?Q?kpCU6mRnIfc6NW3VhuLyO3Dj0u4lBDwZBLSJtPFSiiNc5EAyLCzer2xame6F?=
 =?us-ascii?Q?ErN0+W2jALWAttjmgZx6du3+HbNYmRUyvRIa7BaRGincU9tsbw0DSbTudFmV?=
 =?us-ascii?Q?1/F15tK/nSM3pQPpnvBYzAVpylnBOoHRRVQXFW17jEf0TzlZeVkw+2cIfQRy?=
 =?us-ascii?Q?99Ctdz8yLFNg03rDfiL4YYsxY8Yzc3DRk3qSac0XciY8ftqSa6wNHGC5rxnA?=
 =?us-ascii?Q?JMVbDRvY+rMsFQifv8HTw1WUrcCI1iRPSsgpVlDZ3al/5Lwxh8bn//17uGLv?=
X-MS-Exchange-AntiSpam-MessageData-1: Zr7yVzuKsTA1aOo4SSP7Y2hegjWefMNxY40t7PG3hpUNvd8iInfNNZV7
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69982b80-11d2-4f21-0301-08da2dfbc029
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 18:27:31.3894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LaUN4IgKcARFbaZ+GrAMu4VlqOLoZM6uLrFanrhejCJ9u9f5Ga4xLu0fRZDhAMoX28PtxcQJXy6rDDzZGzv4RC22dXvhyii7RPipegSod64=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR02MB8030
X-Proofpoint-GUID: U3A-P420u-siQDLWFQJts0_ZlYc8pqBg
X-Proofpoint-ORIG-GUID: U3A-P420u-siQDLWFQJts0_ZlYc8pqBg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-04_04,2022-05-04_02,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The trace point in record_steal_time() is above the conditional
that fires kvm_vcpu_flush_tlb_guest(), so even when we might
not be flushing tlb, we still record that we are.

Fix by nestling trace_kvm_pv_tlb_flush() under appropriate
conditional. This results in the stats for kvm:kvm_pv_tlb_flush,
as trivially observable by perf stat -e "kvm:*" -a sleep Xs, in
reporting the amount of times we actually do a pv tlb flush,
instead of just the amount of times we happen to call
record_steal_time().

Signed-off-by: Jon Kohler <jon@nutanix.com>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4790f0d7d40b..8d4e0e58ec34 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3410,9 +3410,9 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 
 		vcpu->arch.st.preempted = 0;
 
-		trace_kvm_pv_tlb_flush(vcpu->vcpu_id,
-				       st_preempted & KVM_VCPU_FLUSH_TLB);
 		if (st_preempted & KVM_VCPU_FLUSH_TLB)
+			trace_kvm_pv_tlb_flush(vcpu->vcpu_id,
+				st_preempted & KVM_VCPU_FLUSH_TLB);
 			kvm_vcpu_flush_tlb_guest(vcpu);
 
 		if (!user_access_begin(st, sizeof(*st)))
-- 
2.30.1 (Apple Git-130)

