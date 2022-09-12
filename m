Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC315B5341
	for <lists+kvm@lfdr.de>; Mon, 12 Sep 2022 06:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiILEab (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Sep 2022 00:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiILEa2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Sep 2022 00:30:28 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2AF1263D
        for <kvm@vger.kernel.org>; Sun, 11 Sep 2022 21:30:27 -0700 (PDT)
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28BFl5x6019399;
        Sun, 11 Sep 2022 21:11:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=SB6m/uVEdBBmQOg4jHUtj5dP/AoBax2FmBuxXyKcya8=;
 b=rwovNXd9Vs3F9lwEqgwEwNfMBpJO1rf8jWVWUQgZSrmyYZps2ZXTxNpFTc3UTpMemVGh
 +rL8iSCdZluRza9qS/vGIKHfXYfbO+eKbpMoDmppLPBFNvVmJ1HsMLVRjKKyNw85nvJ1
 SvQ3UBUCs7tm0utoG06b4QcrS29/M5lKOvcZ6/jGvwve9favOcS/S24tuUVMchr+M3Iv
 x5KS63/qb1tOgteDatHHN/Elezhqrr256NdbeK0siHasoutB/98ysFzPmeZCdyr0+uqw
 /8iWT4hHDaFPNTAASySptJmDqeC6AWVYE+S52z2N+IqNfoaAFdqjNJBaJ4eoPyiAjBVU xA== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3jgpg8ay8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 11 Sep 2022 21:11:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WwiESbkvNxsRg2EPA41726+oDP2+URnrO1k6XLc7XTRp3oOXpUKD+5HMP546yF3Z8Ad9/2P6ZbUXKeh9/sovpshLKeqrNOEWxomjCOjJJgMiulAiL9RUNLbI8HoMSKJKrbaIHgjSafqfyPdZgDuE/FD9LU23AQa1ecAo7kzCtHBioUoxVpolnk06SFe5CL1o4XjfWBARiy50st5PFH+y0BtuXC9lLbbPH9LAKDvbA/vMkzjZqyxe0WZFxJNy6aERtHiF13AssCSU7HcQ/xzdeMbxjb7Wiv1sE+w7fFJVZpr2Azt1Xo7GM2C6zQmKpNe61vSduAfiCBlaCtUKVwAfoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SB6m/uVEdBBmQOg4jHUtj5dP/AoBax2FmBuxXyKcya8=;
 b=BAsdQt7M4NFMmhcqVTJn4jcIPH2ThL4ldD2W4TLWNKPt0LWsZGbr/kZ0ceCZYghzwRm+BWS6eyZIrtl5u7luKCRvg5MoEJLO18TWgOGevMLiV4WczZmHqNCQxhKmtOvo2d8E4n2jdLMxCLGqjQEKSFhz/HEK0sn7eLS2jbPUmVUGNwPZdbbJRlw4x8k7mvn5CnwMSmQsPX6e4rn/VAl0OHXlFsupC9fElfSQp3rFUT7JNIw73K/+wtLeU6UXAS/+026q+OnhZhaXj7OZKwYaG6Ssn16d1ZjKu/nnL9d2gO3ESlbkXRf9cA+IJYNeOl2oaT0ZpLM9+5lO7yhi4+TJRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by CH3PR02MB9116.namprd02.prod.outlook.com (2603:10b6:610:144::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12; Mon, 12 Sep
 2022 04:11:12 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::bcdf:6d6f:e6e:b9cf]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::bcdf:6d6f:e6e:b9cf%7]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 04:11:12 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: [PATCH v5 2/5] KVM: x86: Dirty quota-based throttling of vcpus
Date:   Mon, 12 Sep 2022 04:09:26 +0000
Message-Id: <20220912040926.185481-3-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
In-Reply-To: <20220912040926.185481-1-shivam.kumar1@nutanix.com>
References: <20220912040926.185481-1-shivam.kumar1@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::35) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|CH3PR02MB9116:EE_
X-MS-Office365-Filtering-Correlation-Id: d64fac7c-8d7a-4d0c-113c-08da9474d460
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dcqp/nRzx+HHmy+EWZy5aqNod16weOBxkjIowI56VPoQCLlfX3WbTFa4+lYGRXVYrx6IvvC8Y+7f+F8SjXz3jpURkqp380m69+lKoC0B3bRJmnVVeUvmEjy7zLluWUYTaj3pcx4l3XdPKURao3ppz/X+hJ15fVg7wxeA0Hf5xryqk/qSTKgRGUYaT8xNo1Lhj9dZRRYA1/Dm3lp3mnVWug7Jw/YNNLmT5s3D9hHJEkAMh00DBBy4T5u+yvsGJklWESns+Xx21l7s2BTpF5CS1NtnjeXDxp6q5ZZuxA7dn/iu8Q+rGa3d/U0R8SECjavTwcq0VJG6zQfr3URDZNKteowQSG2tWi3o4aSyYnbobUP0rxI/lOd/aFxUnMO+ofjIv0J8/mtydhtY2wMzllGm4K0q4/tWZA7guYhRubhFBzFc+CFcT3A90wGC+UVsDWZ6pAGXeT/7hfADMl6nG0uyXYS8JcBmsZFj6yxTyz2GKDgl/+qasUseSMrubN4KN/+nl5ae9ZukMYUUFt67YexhDmpxnAZwOXCtrqoKfuPr24k39XolD5JO5vhvncvZaDpXMLKnvXkmzwm3BiUCGx5ZrzqmcT3/43+fm/FzeGzRL61cjC5dUO+i88FQQn6mVZRLrUjHvjA8Bgj4+JkVwwStY94K/dcXGVC9iKrfj5Ib+Q0MPUTJyyJw4J18nUT25UwNQ75IFbMsdKWaO9A7s/1IviETYbZY3U/BvfVNja5nQ0lKa+HBVumsnHbVECFc/1g6zduEyhOmA7uM3fSLIZTMrIuVEcqD5hfbT7vu8ScYwgc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(376002)(136003)(346002)(39850400004)(26005)(107886003)(6512007)(52116002)(41300700001)(54906003)(86362001)(6506007)(6666004)(478600001)(6486002)(2616005)(1076003)(186003)(38100700002)(83380400001)(2906002)(15650500001)(38350700002)(36756003)(5660300002)(8676002)(66946007)(4326008)(8936002)(66476007)(66556008)(316002)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s0irz+HC5qr/NmrW2B46FudCNvVV0rvsSWBQjFdBdQJYneO9/blYC6SS0lMG?=
 =?us-ascii?Q?DYwlpNgozOYI1CR3CLRcFBl5sG/3QszyT+/23hRd87E5wwkcPjqmPyXCvdgl?=
 =?us-ascii?Q?jqoCkZluWxxGx+QCTis6ls49zyfmPylXR3c1HRQxz9m/jn1SAMOb2cut+lkV?=
 =?us-ascii?Q?QW4WiSrcj2Ekyb7w/089cqmwqtenCqr1RSfPXKwaaIMPZJ6zbk0GVicuZdjy?=
 =?us-ascii?Q?SLtu1vWt19yyengWZ2uC22sev8gbR8nO+RFopTz78y/yAV2i1Ah9+CMFG7/u?=
 =?us-ascii?Q?dqf5ySFWf2nFMuWqk0PseUBoKTJQnzW+VPteJtLeh9HoCHuExDZblQaedpb1?=
 =?us-ascii?Q?0JC/JG3W2Ju5I7mvLy4WOvec7YdHa/QMrGzA5Z0pK21jcZjav9QckpRqCYqV?=
 =?us-ascii?Q?iKLigeDyp8ThyogAKgPlPL5fnmoUVTjcqyU9of94+t9A/iyZKvOCNqo3N9q4?=
 =?us-ascii?Q?GsE+VgpogW4Dg6RqhmZemUafAqxYAYSKKrai3mWv9YQ3eWWkHvsYbE04EHSL?=
 =?us-ascii?Q?h39T476zCi+blpPwZD3b4I1tJCeTb7xKq5c93CWtmoSRnnr1DpgkdMpfh6No?=
 =?us-ascii?Q?kiFRmARxaiYSjUTQgNt0fnwWsMmcoJIRERKRqrnm9qFAUTxGOVxuPAFyQ4rA?=
 =?us-ascii?Q?xcMesyNoWyVAe4g0OLa33Np+o39RSdSniIwykyizenDXUPhXQZD94S3dAS0A?=
 =?us-ascii?Q?Tm8QmosJG0htzFqljC1m+YiW8AhVmNVKEKtmddtjgKCWR/rGPHtu5e+cn6Ny?=
 =?us-ascii?Q?Bp5QmMl3Jqmqw1E5VmErYwkNPNpBeWRCj7Z9ooJ+n3dBqF91TdUwe0mLayQE?=
 =?us-ascii?Q?sjxlG8FQG4nCFSOPgnjwfhzwKsmq4Pk8yM9V3p8gbseU7nXehdrls0ueBhFl?=
 =?us-ascii?Q?cAtv7ysRNuSsGtiCa+qwcLLJtLFXJNZWwPSvnAqDQAbPJ8TLSLW246aiErZw?=
 =?us-ascii?Q?8mxfm1yuwUxohu46bvZnaa4ph8mlNq+eqINr39h5qAXo64sLRnYt+F+jwahM?=
 =?us-ascii?Q?04NHp0ssQw7BYRt3+VqVteFwS0pZ2HovwPmR8ICXhVmOXkVaC1vf2LjdfDOB?=
 =?us-ascii?Q?mtj6c8mWjyDV36CJJowvtCb+Y0t1kMYtkCJXNAmDeB8SQ/62ZkIPeGP+vzhC?=
 =?us-ascii?Q?i6ghXQOSjiKWvyAO/jnvb++idg9+LQa/v+7stGaxa+isJm3402oUZY6TaTAK?=
 =?us-ascii?Q?X/flwnBmtBynm0afleCvMuvxsLwGSOO7FueHU3//SMU6DCXOMemyGj3w06vc?=
 =?us-ascii?Q?qVyM/AEp0cU+W7lJ2p9fw8MXXvQd8ErFU4rxHDaQ/wDzNePCYCWGm5Gqj3m6?=
 =?us-ascii?Q?FVupEA6RB4ZngD6jHaCljYIsPZcbXD5j5PzceMu8fMwjxoQ/RLcbbLdUfYAT?=
 =?us-ascii?Q?ofda+GrcIcDcMHJymBQx/vwix0FXWwSL1nwTQBe8yqiKVAchnxAGGD6oX0bx?=
 =?us-ascii?Q?GTQVxToeRkTEYlpy/x1kmcGMxVxU3AA5nyGiMS45+RCuhI+vjZwGEvwnA7/P?=
 =?us-ascii?Q?UVAXLqx/fS3tATdJYU1YXJ6L4Ev/SZqof5/JP1dCVyKpJpLZoIVTeKlPLFCs?=
 =?us-ascii?Q?LjMGULIDqVVxBTeI7Ajr64atobKRW7c7JjaeEQZOpIYd7Q6jlv3ily1Cssj3?=
 =?us-ascii?Q?lw=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d64fac7c-8d7a-4d0c-113c-08da9474d460
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 04:11:12.8091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xj0Nam/epXHluIAbeehiOHDkQ5El5S7nDH/zbsuUT+cNp46DT3YvL+0LIN2wrpohEHEexznY0BuwdOazJuTADxa+S1BMLVpmxOJ75PLZjMw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR02MB9116
X-Proofpoint-ORIG-GUID: _Jaqj9wPGznULsABWjnFW7so5fr5oLte
X-Proofpoint-GUID: _Jaqj9wPGznULsABWjnFW7so5fr5oLte
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_02,2022-09-09_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Exit to userspace whenever the dirty quota is exhausted (i.e. dirty count
equals/exceeds dirty quota) to request more dirty quota.

Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
---
 arch/x86/kvm/mmu/spte.c | 4 ++--
 arch/x86/kvm/vmx/vmx.c  | 3 +++
 arch/x86/kvm/x86.c      | 9 +++++++++
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 2e08b2a45361..c0ed35abbf2d 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -228,9 +228,9 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		  "spte = 0x%llx, level = %d, rsvd bits = 0x%llx", spte, level,
 		  get_rsvd_bits(&vcpu->arch.mmu->shadow_zero_check, spte, level));
 
-	if ((spte & PT_WRITABLE_MASK) && kvm_slot_dirty_track_enabled(slot)) {
+	if (spte & PT_WRITABLE_MASK) {
 		/* Enforced by kvm_mmu_hugepage_adjust. */
-		WARN_ON(level > PG_LEVEL_4K);
+		WARN_ON(level > PG_LEVEL_4K && kvm_slot_dirty_track_enabled(slot));
 		mark_page_dirty_in_slot(vcpu->kvm, slot, gfn);
 	}
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d7f8331d6f7e..9499c7566479 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5750,6 +5750,9 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 		 */
 		if (__xfer_to_guest_mode_work_pending())
 			return 1;
+
+		if (!kvm_vcpu_check_dirty_quota(vcpu))
+			return 0;
 	}
 
 	return 1;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 205ebdc2b11b..0b1243b598c9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10362,6 +10362,15 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			r = 0;
 			goto out;
 		}
+		if (kvm_check_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu)) {
+			struct kvm_run *run = vcpu->run;
+
+			run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
+			run->dirty_quota_exit.count = vcpu->stat.generic.pages_dirtied;
+			run->dirty_quota_exit.quota = vcpu->dirty_quota;
+			r = 0;
+			goto out;
+		}
 
 		/*
 		 * KVM_REQ_HV_STIMER has to be processed after
-- 
2.22.3

