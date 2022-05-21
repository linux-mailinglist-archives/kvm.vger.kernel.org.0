Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3226952FF62
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 22:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345356AbiEUUbK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 May 2022 16:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345777AbiEUUbA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 May 2022 16:31:00 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A6BE01D
        for <kvm@vger.kernel.org>; Sat, 21 May 2022 13:30:54 -0700 (PDT)
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24LBP5tQ019024;
        Sat, 21 May 2022 13:30:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=zFeKGVAiz/bAbgKGBfPzVyn68FWsyXaNHNJZULGfkLg=;
 b=Bb2N+1Klkmpi+GGAEBLvurxPQ6UrcPMWu5yzKH08XP+6NXYyjp/Mm7Uqsj5CBtNbWf4b
 0ruZjFdFmGjfuPvsudNrUYyV8AqcWAYR60rgGYKs8tUhX2tQjYRVs8hJqa0V7ZToj2Ar
 ER772l12SgE42Kq6HE6K/rtNnnUNTKGwImExP0qyt17u3HIZK+9RwJxqTkIvxegF0Cm8
 MAHOd1SvmBjE/pxHCyIHfP/eaRkOFX93eLU9ddbTGqbxwAUO5dwjmgBlm/u4NqJmmf7M
 AO5Zil9uJG62XbQltiIOGzEP04+Dm0e0BSx1jgTIEJy05cVmnrvvgADw45H/GQgurp8q ug== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3g6y5e8gpn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 21 May 2022 13:30:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kSyn9HQj0lFx5NKqhrg7nX20HiuttD1o9l/gjarjJUhT3RYk1lgVt6sCzwVEHj/ADX3Xjy6Da73zntHmTeokRJfPbAdrQdd6kRkb3/jLquQRO5J5+596wEGSlMktszV7A773O+ovLh3jU7azUvcAODJs4FZLkhqzDh8ftk2tQxys6LTQRQaaYcPH18LeMFBBSApNuBzEnsaOXHr0d1wLwlYwrXPDpcZHiiF/9HdJQP11VvKLwVjNZEe47usnfCMvFAKsyEmlNqq3M+y/P7kMYs5ih1KA7DJ8mfZT2+AGymaVoWApIp84mmNwNzLW351xZ34pn5D0+8oOfpwwm6HZyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zFeKGVAiz/bAbgKGBfPzVyn68FWsyXaNHNJZULGfkLg=;
 b=J34BX+izasNA9/6TPdLX6ffMbi1wP34Mi8Um/i/wcY3Y21brXa7IaP4Gd+OakYOrtyT9MPhMbKdvMGFVJEdjwI+vH0zC95fQvraDJis/kO2SP168q4tDPX8CRB6s5e5MrLJPJX6V/MHuIQTEKAUtwFIucocbdubsR1NZbBR3rs8HjtEDaOcMizTA1Ucsos+2SfJbl0M4lGL8SJjB71rYNBfboTiHTzXY25kmVqUAR2PHldih7xzogrEMAXDezbOceNwrSKCh5DXRDXIxqEW9XW0XSD5W0I3Vnl79/DkCD345f+tI0LPG5jAVcaiYz9nU18H3QlMWMIX2fUl2eM/ekA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by SN6PR02MB4319.namprd02.prod.outlook.com (2603:10b6:805:ac::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.19; Sat, 21 May
 2022 20:30:34 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::6819:797c:706f:9a01]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::6819:797c:706f:9a01%6]) with mapi id 15.20.5273.021; Sat, 21 May 2022
 20:30:34 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: [PATCH v4 1/4] KVM: Implement dirty quota-based throttling of vcpus
Date:   Sat, 21 May 2022 20:29:36 +0000
Message-Id: <20220521202937.184189-2-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
In-Reply-To: <20220521202937.184189-1-shivam.kumar1@nutanix.com>
References: <20220521202937.184189-1-shivam.kumar1@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0064.namprd05.prod.outlook.com
 (2603:10b6:a03:332::9) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10c4c8b0-d38f-4359-022d-08da3b68c1f0
X-MS-TrafficTypeDiagnostic: SN6PR02MB4319:EE_
X-Microsoft-Antispam-PRVS: <SN6PR02MB43199383D12A1975BD688706B3D29@SN6PR02MB4319.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t/ZSkaJeDJiU85gMteRqtF+W4Q9qZB7anQRonfrhaxgkpn0J9VsPM+ss3Mn9B8Iz7Wur3P50ODbv2yib7y2gSifOZweJRY+MhLk9l0IHCUhnDcKWghemwe24+I3pFaEifaOAXTUe0EvR055jW8+YVMsBMYdcvssC6NrIF5CtQLDWk6Lv8cvwj0x8qFhAPJmcakECwG4faXNpzByqAmgDQ+6v7VRphoKx2bSYteEIA1ozSlRV6cfGttmlEXSmGWcLiljioUoRMFWwPYJ/3L0+2ufiH6qYJrCMr+6tQNGQUuw1b/5JmgUDWRuU0qxaD0+7rJ9iapuPleQ4aLbQqjM/cD/YmUeYx+cKqkiYfax1s4HommBd6HKPCkUQ3BIBabZyjZlfrUNwK/hcy6XgZhuKe8j+x5xCb+CWiMi9Inm4p+14ExQmnkzc4oHRRk88zohYOyc/0NjdvyplVAsr/cV5cF2Be+Zue82bzWKBlxwOJUOFq6Wm4VHXiNhEF4KDjKyoI4xmYtRm97CsDTNuxbOA4PksEdtL+YhBvCsxyT5/WHklPjy5NQ2ImiMPBHuknXxJ70GOp0atxscX323M6zdMv5uNnpyXYuzwyN48jVaDOJ/MhPsDV9ftXhrXzvRZ7HighdAXY/mCzEehUyY7ZvnXk9h+e0cQdv7EjsLPlgKA2oxpSW4TeG8PtxK9XRijBvTrL/yA1l+FATaeQZOK7ZgCYvf6F/00fycp+07KOjWIs05pjkTrs0jgTPtCUmKs0cBYPLjSiUcDZngXpn3r1dWb1IfujOjEyE7pNL51PgVuyms=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(15650500001)(52116002)(66476007)(66946007)(66556008)(2906002)(8936002)(5660300002)(508600001)(4326008)(966005)(6486002)(36756003)(86362001)(8676002)(6506007)(6512007)(316002)(54906003)(1076003)(83380400001)(107886003)(186003)(38100700002)(38350700002)(26005)(2616005)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LkEklDZVDb/57Va7MyIbhaKT8BjAN1fTpbJim+um9GlCvYF9hltXWV/WH3In?=
 =?us-ascii?Q?1hWRAejiDAT6oVs5/mH9K8G3WrvLUNxj3fJF9/oPennPDIHMdzVQkhTjqj7K?=
 =?us-ascii?Q?2x/k7C1USXawhtkV5oaHlLyPc9mEsJAYeN+pzNnoK5MqKqKBxk3//CHBHWcw?=
 =?us-ascii?Q?fzH5v7Xi43LTaA6FT3XRUteKAfzOQKB7N9at8EcfSo+3KG4swXEQYhaG3Dfo?=
 =?us-ascii?Q?Bxf088q4o68zTK/47e82X3AvNWCb5orXbT3BcSd1plN1+i6drH5hWaRVo59z?=
 =?us-ascii?Q?7AfOh3Xe9CJyCW+AUmgTUdWbJ7goHZdhHne9tsOs5/coxQCgz0m91zuE/r9K?=
 =?us-ascii?Q?qTf9+Sr6r/Pll7mPzpzBJlyNI94faaaqIJcCzvPqWM22WBZiOjC99yMUSOfV?=
 =?us-ascii?Q?SMK8SZQ+FcrtsDjOeYspkoQohF00lYKnNbNlzkvaewXJjRPLm4Qwj1MEojIi?=
 =?us-ascii?Q?vDPpCLPezR7HCox00hddm8cJtchiWt8nd06lR6W8ZME2DXncK1vENTy3paLt?=
 =?us-ascii?Q?gk54U5+5DyXISQotn9wecpxaTuCTLzgECPsvvmmuzyTMwjlWsCPpDdLSDApM?=
 =?us-ascii?Q?U1RO8MiNMPSKhfOFPK6GTDplUfgqZ5SO58Vzutsw/zqn1gIqFILf5dpj6nQK?=
 =?us-ascii?Q?lDzftKCxQr46XnxM6WN3SqPiPxq/iGsbpavsmA9TWohTYtNdi2gt7hzV3/He?=
 =?us-ascii?Q?UjLz2CtwX1z4gHC2rBTtfc+92kXa6dP4aa+RG9604cWZYhi5pecpo6uiFNXN?=
 =?us-ascii?Q?ES5945zPYh2yoJxDXwaojYTvi446wY6rTJQKq8bzdAWi28B8/N4DvcwiKhek?=
 =?us-ascii?Q?lyC68RWtZTOU+5/U19fpBCg33fb2OX96AFvm5pi3I1kWuYXbNsLAxmT3gjLy?=
 =?us-ascii?Q?Ewzbffb2tZ1l3tG7lIShwJRmxPfgdMeCzWhQOqjJF1IrgkRdpWTtrwKyxAs4?=
 =?us-ascii?Q?K2ZjZjTcVXzMtuREdVHYjustosUNzP62GH1jlzn84xFC7S3ZK+0SES2QVZDX?=
 =?us-ascii?Q?SHMKlWLzqruLzAXP7euALxlssvACRSloTIbHOWoN8NITJZGdDpwIie+VV5xb?=
 =?us-ascii?Q?gk0j6vwQ5qUQe/jd/TfXKv4sswlxzv0Jf3/1/AtdMcIoqPoXEvyJzC2Qe2WY?=
 =?us-ascii?Q?BHviDw0XA7Jh8kz8Stx6D7p+oXBxTTT7mcKjC71Sc1gUdQ32UUKfquc3XLX5?=
 =?us-ascii?Q?U8glKUDHcOSFxvSXJavgZXoV7x/WWWvvfAaqutXGo6WamLtygoA+2/+GlncE?=
 =?us-ascii?Q?WhRP7Gf3p/phPhEia2CYer9BtZ0/w6iM/r7aUNtAd3vvXCPZV7Cfcg6EdFVG?=
 =?us-ascii?Q?aJyNTLI3h00rONSCKR5lPk2cLDOfIjDlh7tEaM9glVTA1lW65pBPx1RCFKdV?=
 =?us-ascii?Q?5RsRga3LcshZOXi+/dZydXxgSz7z+wiX/GB8GNHPuc6dwu4aFZAYb4y7q1UL?=
 =?us-ascii?Q?qlrEEKNydn4Xqm+0mI6rqLrqcu767EYT0Ynsba+6jY/A9LP7y0n7N50hGoXR?=
 =?us-ascii?Q?EYENvSobJTIE6wRKEimqT+gn+R1bL1UoeIHPnC2yNVUnHaDn7XDWjPD2wOAV?=
 =?us-ascii?Q?AI60cmjABo02dfbJ5g+WSszTF7S8+G8mgoz0wrtDvHEmks/XA75+zA5mMQQ9?=
 =?us-ascii?Q?4c8TmiTAtQHpzsq8OGjHB54ZrwWqgAgiQ916sv9s6EFbxSwn7+VVD240TO3f?=
 =?us-ascii?Q?OKFjfdCn0sQnORVaAXRAdZTF2PDseuM6teQlwwRUAKoDq9c2YfQYe59pSr27?=
 =?us-ascii?Q?Iz1xZvrZwc3gEQh7ljjt7WZNyE++2l4=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10c4c8b0-d38f-4359-022d-08da3b68c1f0
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2022 20:30:34.4434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iyvzDchcnSTaJiODdDMBWydsE5zgDkFEnVAaeQcbCVp2fUtCUrbxCtDYDcll+Gm2SjflYJtaCEcLBu5Ipjsro/jjiCiiTktcDJmQBG1S0ak=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB4319
X-Proofpoint-GUID: Tnmr7fB66SFzuSeesQYnmIN8gM7b6kU2
X-Proofpoint-ORIG-GUID: Tnmr7fB66SFzuSeesQYnmIN8gM7b6kU2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-21_06,2022-05-20_02,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define variables to track and throttle memory dirtying for every vcpu.

dirty_count:    Number of pages the vcpu has dirtied since its creation,
                while dirty logging is enabled.
dirty_quota:    Number of pages the vcpu is allowed to dirty. To dirty
                more, it needs to request more quota by exiting to
                userspace.

Implement the flow for throttling based on dirty quota.

i) Increment dirty_count for the vcpu whenever it dirties a page.
ii) Exit to userspace whenever the dirty quota is exhausted (i.e. dirty
count equals/exceeds dirty quota) to request more dirty quota.

Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
---
 Documentation/virt/kvm/api.rst | 32 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/spte.c        |  4 ++--
 arch/x86/kvm/vmx/vmx.c         |  3 +++
 arch/x86/kvm/x86.c             |  4 ++++
 include/linux/kvm_host.h       | 15 +++++++++++++++
 include/linux/kvm_types.h      |  1 +
 include/uapi/linux/kvm.h       | 12 ++++++++++++
 virt/kvm/kvm_main.c            |  7 ++++++-
 8 files changed, 75 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 9f3172376ec3..a9317ed31d06 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6125,6 +6125,24 @@ array field represents return values. The userspace should update the return
 values of SBI call before resuming the VCPU. For more details on RISC-V SBI
 spec refer, https://github.com/riscv/riscv-sbi-doc.
 
+::
+
+		/* KVM_EXIT_DIRTY_QUOTA_EXHAUSTED */
+		struct {
+			__u64 count;
+			__u64 quota;
+		} dirty_quota_exit;
+If exit reason is KVM_EXIT_DIRTY_QUOTA_EXHAUSTED, it indicates that the VCPU has
+exhausted its dirty quota. The 'dirty_quota_exit' member of kvm_run structure
+makes the following information available to the userspace:
+	'count' field: the current count of pages dirtied by the VCPU, can be
+        skewed based on the size of the pages accessed by each vCPU.
+	'quota' field: the observed dirty quota just before the exit to userspace.
+The userspace can design a strategy to allocate the overall scope of dirtying
+for the VM among the vcpus. Based on the strategy and the current state of dirty
+quota throttling, the userspace can make a decision to either update (increase)
+the quota or to put the VCPU to sleep for some time.
+
 ::
 
 		/* Fix the size of the union. */
@@ -6159,6 +6177,20 @@ values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
 
 ::
 
+	/*
+	 * Number of pages the vCPU is allowed to have dirtied over its entire
+	 * lifetime.  KVM_RUN exits with KVM_EXIT_DIRTY_QUOTA_EXHAUSTED if the quota
+	 * is reached/exceeded.
+	 */
+	__u64 dirty_quota;
+Please note that enforcing the quota is best effort, as the guest may dirty
+multiple pages before KVM can recheck the quota.  However, unless KVM is using
+a hardware-based dirty ring buffer, e.g. Intel's Page Modification Logging,
+KVM will detect quota exhaustion within a handful of dirtied page.  If a
+hardware ring buffer is used, the overrun is bounded by the size of the buffer
+(512 entries for PML).
+
+::
   };
 
 
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 73cfe62fdad1..01f0d2a04796 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -182,9 +182,9 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
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
index b730d799c26e..5cbe4992692a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5507,6 +5507,9 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 		 */
 		if (__xfer_to_guest_mode_work_pending())
 			return 1;
+
+		if (!kvm_vcpu_check_dirty_quota(vcpu))
+			return 0;
 	}
 
 	return 1;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eb4029660bd9..0b35b8cc0274 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10257,6 +10257,10 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 	vcpu->arch.l1tf_flush_l1d = true;
 
 	for (;;) {
+		r = kvm_vcpu_check_dirty_quota(vcpu);
+		if (!r)
+			break;
+
 		if (kvm_vcpu_running(vcpu)) {
 			r = vcpu_enter_guest(vcpu);
 		} else {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f11039944c08..ca1ac970a6cf 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -530,6 +530,21 @@ static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
 	return cmpxchg(&vcpu->mode, IN_GUEST_MODE, EXITING_GUEST_MODE);
 }
 
+static inline int kvm_vcpu_check_dirty_quota(struct kvm_vcpu *vcpu)
+{
+	struct kvm_run *run = vcpu->run;
+	u64 dirty_quota = READ_ONCE(run->dirty_quota);
+	u64 pages_dirtied = vcpu->stat.generic.pages_dirtied;
+
+	if (!dirty_quota || (pages_dirtied < dirty_quota))
+		return 1;
+
+	run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
+	run->dirty_quota_exit.count = pages_dirtied;
+	run->dirty_quota_exit.quota = dirty_quota;
+	return 0;
+}
+
 /*
  * Some of the bitops functions do not support too long bitmaps.
  * This number must be determined not to exceed such limits.
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index dceac12c1ce5..7f42486b0405 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -106,6 +106,7 @@ struct kvm_vcpu_stat_generic {
 	u64 halt_poll_fail_hist[HALT_POLL_HIST_COUNT];
 	u64 halt_wait_hist[HALT_POLL_HIST_COUNT];
 	u64 blocking;
+	u64 pages_dirtied;
 };
 
 #define KVM_STATS_NAME_SIZE	48
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 507ee1f2aa96..1d9531efe1fb 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -270,6 +270,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_X86_BUS_LOCK     33
 #define KVM_EXIT_XEN              34
 #define KVM_EXIT_RISCV_SBI        35
+#define KVM_EXIT_DIRTY_QUOTA_EXHAUSTED 36
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -487,6 +488,11 @@ struct kvm_run {
 			unsigned long args[6];
 			unsigned long ret[2];
 		} riscv_sbi;
+		/* KVM_EXIT_DIRTY_QUOTA_EXHAUSTED */
+		struct {
+			__u64 count;
+			__u64 quota;
+		} dirty_quota_exit;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -508,6 +514,12 @@ struct kvm_run {
 		struct kvm_sync_regs regs;
 		char padding[SYNC_REGS_SIZE_BYTES];
 	} s;
+	/*
+	 * Number of pages the vCPU is allowed to have dirtied over its entire
+	 * liftime.  KVM_RUN exits with KVM_EXIT_DIRTY_QUOTA_EXHAUSTED if the
+	 * quota is reached/exceeded.
+	 */
+	__u64 dirty_quota;
 };
 
 /* for KVM_REGISTER_COALESCED_MMIO / KVM_UNREGISTER_COALESCED_MMIO */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0afc016cc54d..041ab464405d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3163,7 +3163,12 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
 		return;
 #endif
 
-	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
+	if (!memslot)
+		return;
+
+	vcpu->stat.generic.pages_dirtied++;
+
+	if (kvm_slot_dirty_track_enabled(memslot)) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
 		u32 slot = (memslot->as_id << 16) | memslot->id;
 
-- 
2.22.3

