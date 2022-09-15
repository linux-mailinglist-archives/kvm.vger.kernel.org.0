Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 803CD5B988E
	for <lists+kvm@lfdr.de>; Thu, 15 Sep 2022 12:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbiIOKLu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Sep 2022 06:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiIOKLr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Sep 2022 06:11:47 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 425C3402D1
        for <kvm@vger.kernel.org>; Thu, 15 Sep 2022 03:11:46 -0700 (PDT)
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28F2riI8022919;
        Thu, 15 Sep 2022 03:11:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=LsODNu59GdJ9q5LrpIHhoFfeD2kUXXL0jbHHXH21wh4=;
 b=qbDP/Kb8Y8L3Nb0JlgSUBXLlPGQB3b2A/LxfNdl+P4Zhsnz0GCB6BWOiQUKTHWyjNykO
 Yq3UROYQRDqKnboHBpCRLwaH2lL8dd51A+gpHmXxtB94s7MX9h5sZPOZgvWe5I6aN164
 QpAwJGsZeQXKYBqrckZ+DMb37akdEysXI/KFMEF+zC2G59xY/1FAp0qqu3VzM77ervfq
 rVC+LL59PpPz6P4oBfyE5BN7ne4huaykkRw8yBEQNt7/0+DUR9W3KcjsZivbNtjsYtKC
 4VOo12IpvE9T99myJf6kicbwp9B1NJUV/u0D/P6EQ33/WluVrr2rOCiySYBvpgQihqu4 Vw== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3jjy074aja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 03:11:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TFyx3UxtfbEMcfRRrNsMPpLE8pjcMnEzRHfUc6NIxQfFl6vuVmca+CHZQ6ZFpBlS4mRVmrBGFUbYeUZzbOg0jIZgkOQO4RAO2EaYoTW0kuH5fv8h+SCyd6hZljlfjbm7cmyCbjSifAagMsHpk7FAdtttR9CiZGsECZ/me8maGloN7F6YHY+aMlKXbgAawcIdkVkMaxfKQaGRU1CCP9mR+99/gz96k53wJs5Ge4JGtt+GqRNx5nxUH1gkC4gCay/gBg6Vw1qiIGLNtAdwuI9EtaH2b74/D9noljM1UIngTMKvhV5emGG2kWsiIeJ2NGA3fCjl1QEaz1xQ43nav1wNgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LsODNu59GdJ9q5LrpIHhoFfeD2kUXXL0jbHHXH21wh4=;
 b=YEBz5zgprOGV+LZWvdtrbYL/z4E4myCMtH+BuZc3R7fHN8Dt4EANq9Ck6h4Uau89KfVt1krb5Fv1t8mcjmU97lk7WEEOmnj5z3PGVJ56Pxu1OPfAtQVW6ru2PLKuPtsz664R8R+5y1NqG0M+lysuDuxk+LI5xlfMg0XpAxSpBN5OV/pU37PIdp8vuDmEeN2LvsTXZ9FfvNcybrRl8saJ92DPU0cDEocMeulzvkl7opaYphBrZh5lBg+1K9b5fVX6XZ+tetv0Z/+MzFax/h7wje6mRjEwuAdZsHjfeHQceox4ww6937aW5JyMbC3haZ0cUjQ/XzFx++6QbsKiiqpr4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by SA0PR02MB7370.namprd02.prod.outlook.com (2603:10b6:806:e0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.19; Thu, 15 Sep
 2022 10:11:27 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::bcdf:6d6f:e6e:b9cf]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::bcdf:6d6f:e6e:b9cf%8]) with mapi id 15.20.5632.015; Thu, 15 Sep 2022
 10:11:27 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: [PATCH v6 1/5] KVM: Implement dirty quota-based throttling of vcpus
Date:   Thu, 15 Sep 2022 10:10:46 +0000
Message-Id: <20220915101049.187325-2-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
In-Reply-To: <20220915101049.187325-1-shivam.kumar1@nutanix.com>
References: <20220915101049.187325-1-shivam.kumar1@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0235.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::30) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|SA0PR02MB7370:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ccf8aa4-609d-4673-2b8d-08da9702a72e
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WY0wXsOLt5KGgTvKCZvVAR41A7SiVW2OMGZVymXXSL1m/9k3hm4CdemdrVICLFR50FNuYCHw0pfav38biiE9dSUupEmlnjcXfXNfY6FMn4W8u3pg5kltDzbSS17W74DKZ40g04GFkVReW9cGwLFW6hjwgonVz5VCpNF2sH6uHou//Z8fxxTG/XtUjWhUjmBL39VRNFPtC26oftBzq5sA3iTOIAIatHj6SCJihV1z6jEX88t9Wu2YmaY3Avb8Cq5/YjJhSc/SlvIgIwkZJP2hkuTH41NSk9aDTxuAOLIDJBabiAH/QKRsVn+uMpRhmzHNwlLK0G3RRehqiym5lgjScmnKTIe/G/QOydwZn6h61ztppakQtwy9rzfWPmP74ev+S23pQUz8fyFnUXigFXXx0+gEGd1VqqGobb6heKvAhNRSWXpWYK10vA6M4uT2IcfKxGIrcqX1YAPNMO7fLlqrA7NrBNMgu3TaqvOmU/L/16wIif6vyXmqbsYoxEVIBJwQ2ToD0lr7wJYbBHEqo2OjXHC4P0n1oll+6ho0/I/FQMABGwLO44nQ9eFV/Jq3VKynA3LI7T4hKT+fHTMyb5ztBmpuvl4AX1vyJ9ReZlfHLvuhc7kaFaSqEOUU4XZNTAPKS2jkUhtSTcg0ELSen2moz1n6BqdDlXxf2E4EOZ/QQy5N4Dc3siTVsL8zb8N1oAekm1kmtmxLMlQulopcKlAGiQPoguzrdXw14AkWc7jHUy0VUd3YWNUZw6zMHi58KYxW1tWK3Z8oEv9R29/R371HW9IcSQbruP4QJgWvClU6x7ua4MO51KeWTcBHlJFe8+L9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(346002)(396003)(136003)(376002)(451199015)(6666004)(52116002)(107886003)(2906002)(38100700002)(41300700001)(66946007)(83380400001)(2616005)(966005)(186003)(6486002)(8936002)(6512007)(316002)(66556008)(478600001)(54906003)(6506007)(4326008)(5660300002)(86362001)(66476007)(8676002)(38350700002)(26005)(15650500001)(36756003)(1076003)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iUwourZk3TNztcVX00hgM95wMVbfc3TWbfhPBQmrB5WBhH03pCxuzPbmCjdq?=
 =?us-ascii?Q?miV+eRaerzkVioaTF56+mj+S/Chq19UE5bm61UkE8E21GpIyPNz79qNIznwv?=
 =?us-ascii?Q?o7yjwoyuMvn1CSNqhhuTkEGFtlIi0yg1eRBx5AOrmk+N4unavE++ZDv1c8v/?=
 =?us-ascii?Q?T6t1CuDeCG3l7WBtrb60KjoWFoo9phnNiekapxSepXE1Krl+9o8Wsze9tfRI?=
 =?us-ascii?Q?zfBGIwwg3pBlKyPKR8IJG/7KomiE2waGDYNaIA+rCSS2zdnc4NUNiBV6mYC9?=
 =?us-ascii?Q?Yive0Cn0SUIkfk2NIOvH93nZ3gBEvjKJZBv0DOaMsNf1fl4UqQvRADlx8EXy?=
 =?us-ascii?Q?b4jRGWjfXoby+l/5NpSTH9mqTKqDFfMFJ8+CrE+vT7M6a25n4IwpaWy70QnD?=
 =?us-ascii?Q?RcFQ4yHlPTrUDyNwQFec1FWS3eOk//uOWd9UPciyHmexbq9RuvKD39IvSbnT?=
 =?us-ascii?Q?2nAuPuE32Dq5OLEExP0Zp7SROlINRJYXwIiogGB7TImHXndrQJbmdAvA2tX5?=
 =?us-ascii?Q?ygziH1F/wUfWSx7BLC/W5/MFPg68GEwr5dU+rEpSDKGlhF6O72Urs4TyY4Pl?=
 =?us-ascii?Q?SVHuH7E/vcGPA1qRDMXW6FAe0dwo4ppRnClZX6NpCaz9R7J0FzKliL6pJA06?=
 =?us-ascii?Q?a7uZjDNuInaGNb3Gxl+fhSu+4FLYb+Rku3NBUWpIyCkMUvohlUJhO0Ld1kDY?=
 =?us-ascii?Q?oOOV3jrmHUhbRi9gTF7niLlOUS8Y/rmySNB9Mp0meZOIcvTHy1OUXoQE2ANE?=
 =?us-ascii?Q?PtlJbdnmiEWyqq6XaQ7w72I/EwKi9i2bI6d3KOLHR7PjshcZwCjTEQZS4xem?=
 =?us-ascii?Q?Jr0O1kepUOxehcrcrlFZwQVzUtmEB71HUv3bHOGyaL46/DBTlK7+QDKcSYKj?=
 =?us-ascii?Q?/cku59ipvjHE8bbRrzof9rDB9D7T/vTxWxbum93Ap60bddU78x4HsM6PUe39?=
 =?us-ascii?Q?K721nG4L0ElmIyApoIzs3Eq5csDZAFaOTaLYc291Y7mArxIPcPtri5PDzcyZ?=
 =?us-ascii?Q?T8UUwzoVk54m0qxXKqGyin5CfLSM3ZEO30E2yT9WgjlVzPhCbsHv7GfF0CcY?=
 =?us-ascii?Q?n1kP0kmkg9lAxrNrlSDwrO5g6lGdZ1JW2MmYXqM5w4xlxIbYlTOLbPI2XhF3?=
 =?us-ascii?Q?fbhvs1t88cdCtDP/F/4o/TR/bvSrPp1ajnOAdjuCa60/XPUZDxf5UIkTLuSt?=
 =?us-ascii?Q?LgbU2CNxlhubdYnnPUTIxWrrf8P0qzMh3BPUZECD8rmi+N1AfAEkjaRxrpFR?=
 =?us-ascii?Q?rj9ziuaI/fp1i6HCFDqxIV/EEFJXsmQpAu5/+KkmtM3f/EbLZ79vKC7uIxwG?=
 =?us-ascii?Q?1SjkkvzII7nycbdi8os2iINwaKrlW3S+Euo8EQVUz0aan1vOYA82Qjy7ZEYN?=
 =?us-ascii?Q?ooQyCFMM+oXyF5xvpgs8YY4MU4Pd6lU7GUrvBlTr8dFdss29YP7GRhKnBJzI?=
 =?us-ascii?Q?LeR4YCnyvRkZziJcm7cnrmkHTQWTXdlrB3abxjBGolfYakVfLOmHM1v5/Dm7?=
 =?us-ascii?Q?0gjPvEcgx82a9Uizydznp0HwL411Uc8R0hYt1EToihw6AzqdicD9K51QnzSj?=
 =?us-ascii?Q?sAeNOxooIJo54Et0ilZKUe0Md4CpL7h0U1xB2eZY8OjGYPf51X3P4FEv8coT?=
 =?us-ascii?Q?dg=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ccf8aa4-609d-4673-2b8d-08da9702a72e
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 10:11:27.8446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZEWpfHXnWjrt18bTSKKTZws//1NcTCG7OJO0vekn2/hrFWXWMaG4vu7YrqC4MB83fDEdBaBoVWS9LFQ05ikFd1vyS1fVv1TYWnJ//KFkesk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR02MB7370
X-Proofpoint-GUID: uSEve-juSIRLGfhtpS5pOeVU86bWeY-Y
X-Proofpoint-ORIG-GUID: uSEve-juSIRLGfhtpS5pOeVU86bWeY-Y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-15_06,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 Documentation/virt/kvm/api.rst | 35 ++++++++++++++++++++++++++++++++++
 include/linux/kvm_host.h       | 20 ++++++++++++++++++-
 include/linux/kvm_types.h      |  1 +
 include/uapi/linux/kvm.h       | 12 ++++++++++++
 virt/kvm/kvm_main.c            | 26 ++++++++++++++++++++++---
 5 files changed, 90 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index abd7c32126ce..97030a6a35b4 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6614,6 +6614,26 @@ array field represents return values. The userspace should update the return
 values of SBI call before resuming the VCPU. For more details on RISC-V SBI
 spec refer, https://github.com/riscv/riscv-sbi-doc.
 
+::
+
+		/* KVM_EXIT_DIRTY_QUOTA_EXHAUSTED */
+		struct {
+			__u64 count;
+			__u64 quota;
+		} dirty_quota_exit;
+
+If exit reason is KVM_EXIT_DIRTY_QUOTA_EXHAUSTED, it indicates that the VCPU has
+exhausted its dirty quota. The 'dirty_quota_exit' member of kvm_run structure
+makes the following information available to the userspace:
+    count: the current count of pages dirtied by the VCPU, can be
+    skewed based on the size of the pages accessed by each vCPU.
+    quota: the observed dirty quota just before the exit to userspace.
+
+The userspace can design a strategy to allocate the overall scope of dirtying
+for the VM among the vcpus. Based on the strategy and the current state of dirty
+quota throttling, the userspace can make a decision to either update (increase)
+the quota or to put the VCPU to sleep for some time.
+
 ::
 
     /* KVM_EXIT_NOTIFY */
@@ -6668,6 +6688,21 @@ values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
 
 ::
 
+	/*
+	 * Number of pages the vCPU is allowed to have dirtied over its entire
+	 * lifetime.  KVM_RUN exits with KVM_EXIT_DIRTY_QUOTA_EXHAUSTED if the quota
+	 * is reached/exceeded.
+	 */
+	__u64 dirty_quota;
+
+Please note that enforcing the quota is best effort, as the guest may dirty
+multiple pages before KVM can recheck the quota.  However, unless KVM is using
+a hardware-based dirty ring buffer, e.g. Intel's Page Modification Logging,
+KVM will detect quota exhaustion within a handful of dirtied pages.  If a
+hardware ring buffer is used, the overrun is bounded by the size of the buffer
+(512 entries for PML).
+
+::
   };
 
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f4519d3689e1..9acb28635d94 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -151,12 +151,13 @@ static inline bool is_error_page(struct page *page)
 #define KVM_REQUEST_NO_ACTION      BIT(10)
 /*
  * Architecture-independent vcpu->requests bit members
- * Bits 4-7 are reserved for more arch-independent bits.
+ * Bits 5-7 are reserved for more arch-independent bits.
  */
 #define KVM_REQ_TLB_FLUSH         (0 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_VM_DEAD           (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_UNBLOCK           2
 #define KVM_REQ_UNHALT            3
+#define KVM_REQ_DIRTY_QUOTA_EXIT  4
 #define KVM_REQUEST_ARCH_BASE     8
 
 /*
@@ -380,6 +381,8 @@ struct kvm_vcpu {
 	 */
 	struct kvm_memory_slot *last_used_slot;
 	u64 last_used_slot_gen;
+
+	u64 dirty_quota;
 };
 
 /*
@@ -542,6 +545,21 @@ static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
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
index 3ca3db020e0e..263a588f3cd3 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -118,6 +118,7 @@ struct kvm_vcpu_stat_generic {
 	u64 halt_poll_fail_hist[HALT_POLL_HIST_COUNT];
 	u64 halt_wait_hist[HALT_POLL_HIST_COUNT];
 	u64 blocking;
+	u64 pages_dirtied;
 };
 
 #define KVM_STATS_NAME_SIZE	48
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index eed0315a77a6..4c4a65b0f0a5 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -272,6 +272,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_RISCV_SBI        35
 #define KVM_EXIT_RISCV_CSR        36
 #define KVM_EXIT_NOTIFY           37
+#define KVM_EXIT_DIRTY_QUOTA_EXHAUSTED 38
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -510,6 +511,11 @@ struct kvm_run {
 #define KVM_NOTIFY_CONTEXT_INVALID	(1 << 0)
 			__u32 flags;
 		} notify;
+		/* KVM_EXIT_DIRTY_QUOTA_EXHAUSTED */
+		struct {
+			__u64 count;
+			__u64 quota;
+		} dirty_quota_exit;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -531,6 +537,12 @@ struct kvm_run {
 		struct kvm_sync_regs regs;
 		char padding[SYNC_REGS_SIZE_BYTES];
 	} s;
+	/*
+	 * Number of pages the vCPU is allowed to have dirtied over its entire
+	 * lifetime.  KVM_RUN exits with KVM_EXIT_DIRTY_QUOTA_EXHAUSTED if the
+	 * quota is reached/exceeded.
+	 */
+	__u64 dirty_quota;
 };
 
 /* for KVM_REGISTER_COALESCED_MMIO / KVM_UNREGISTER_COALESCED_MMIO */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 584a5bab3af3..f315af50037d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3298,18 +3298,36 @@ int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len)
 }
 EXPORT_SYMBOL_GPL(kvm_clear_guest);
 
+static void kvm_vcpu_is_dirty_quota_exhausted(struct kvm_vcpu *vcpu)
+{
+	u64 dirty_quota = READ_ONCE(vcpu->run->dirty_quota);
+
+	if (!dirty_quota || (vcpu->stat.generic.pages_dirtied < dirty_quota))
+		return;
+
+	/*
+	 * Snapshot the quota to report it to userspace.  The dirty count will be
+	 * captured when the request is processed.
+	 */
+	vcpu->dirty_quota = dirty_quota;
+	kvm_make_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu);
+}
+
 void mark_page_dirty_in_slot(struct kvm *kvm,
 			     const struct kvm_memory_slot *memslot,
 		 	     gfn_t gfn)
 {
 	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
-#ifdef CONFIG_HAVE_KVM_DIRTY_RING
 	if (WARN_ON_ONCE(!vcpu) || WARN_ON_ONCE(vcpu->kvm != kvm))
 		return;
-#endif
 
-	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
+	if (!memslot)
+		return;
+
+	WARN_ON_ONCE(!vcpu->stat.generic.pages_dirtied++);
+
+	if (kvm_slot_dirty_track_enabled(memslot)) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
 		u32 slot = (memslot->as_id << 16) | memslot->id;
 
@@ -3318,6 +3336,8 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
 					    slot, rel_gfn);
 		else
 			set_bit_le(rel_gfn, memslot->dirty_bitmap);
+
+		kvm_vcpu_is_dirty_quota_exhausted(vcpu);
 	}
 }
 EXPORT_SYMBOL_GPL(mark_page_dirty_in_slot);
-- 
2.22.3

