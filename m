Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEEFE5B5342
	for <lists+kvm@lfdr.de>; Mon, 12 Sep 2022 06:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiILEcu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Sep 2022 00:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiILEct (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Sep 2022 00:32:49 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289F323143
        for <kvm@vger.kernel.org>; Sun, 11 Sep 2022 21:32:45 -0700 (PDT)
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28B8COR8024335;
        Sun, 11 Sep 2022 21:10:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=h2o/I5BfPfLUVYPl+IpVZ58ZRC+Pd/XhXm778JDjros=;
 b=M+eZtMLpb2D/t0B0cGHdoMUjaWy/5NQXEiTzqzoWftZ3X4mfHswMyQbkdbAk+n1cEZND
 j3WYVrmEtxJMt8YvFm4KSuDXuBu1OJmuqkEDep34Jtmr18frsDXEyjpEXuGVKvhqSoxl
 mOAr/AZ2QZAWGvL0xy1XHi18CGWkYvkYsWVD72RUl/5NxH0CHtzrLYndS2kU3iyXbiZF
 wvaL6TlEHm3QE2WLmP1b5nqzRFtcqpI671YWLtyKNbnh69u7mJ6C9xyLX4EOy43p58FP
 PBuYwsv3UWYIjcQHSx6YhL+/Zlc5VtHX62xrePtIC6Tj/ClDrQN0hFZlb3jE4GgbFEY3 Ww== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3jgpwtjwgw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 11 Sep 2022 21:10:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a03++9WIRC0MGMxA4XwIJ0GlSapv34JH7NtX1cmwVBDwpso2oSClCTyaXzdsoFXT0NYQTuiBylcU1S8z17iP147LsIjMjyjNjBwL6x7/xMQXFXuD2ynkek+RPy9I/jgI++mH4cY5zg9UtTWnZahvRA+V12lHejq9TZSkUI42NRfS+g4xFdjcVsshJnonl5i4NtthYW6xx/IIlmpEMwsu9ADip3PCrpqQp1X3oB8BkIqjvUMrcDRZubtxnuBOoAttYO+Ezf3nODpdufkj2C5pdjbPTfS43q6J4d3hYuRBTBtuKwAr1+EfGoZA+GXviaNspONn7i6LXaaGfubOgZyzig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h2o/I5BfPfLUVYPl+IpVZ58ZRC+Pd/XhXm778JDjros=;
 b=In4NU5xljb9CJdildL3OAzVbJdOIXc4aVjv8resMBoZIKhhJEj5tqtN3n6utzTtUNaMKulTYyywEuk7jTAE7xiRUZkzHCCn+yUhTx6p+iSyYlh5x71RTvZWzFjmB4eye83NHk9RIq1BouNpahjGY3B7CRt2ouXdN3aDuOukp5/v2chQG7AgHHYdG7xjEI0DizfxHS9u3lf6ZbR90GwPyIsr/8Xza46+LAi4elNmT7vaQYaD2vaJ9Pp5jXiqNA6J64bpYBZA7orxqci5efSLofSDlGgR2LrgExafUv6lylzzX3r/oCneIPllc2walNnJnuDpPU8idrFYsHYlqFGXDYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by CH3PR02MB9116.namprd02.prod.outlook.com (2603:10b6:610:144::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12; Mon, 12 Sep
 2022 04:10:45 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::bcdf:6d6f:e6e:b9cf]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::bcdf:6d6f:e6e:b9cf%7]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 04:10:45 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: [PATCH v5 1/5] KVM: Implement dirty quota-based throttling of vcpus
Date:   Mon, 12 Sep 2022 04:09:24 +0000
Message-Id: <20220912040926.185481-2-shivam.kumar1@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 5c4577bb-aa5e-456d-c32e-08da9474c432
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hz4lAvoHzGbWqUlCjQrm1Si6dIRs6FMNErUQh+8hxGvs2z1RwjCMMKRaHrq9VgkzE1qviq/+gM0078dfOoPqMuKgpU/qCErlhH8vH2NmyomHucpMkenZRBJNn6ikvszpjntWOPr1Cq1OJPsQLQl9dnFILG+ODkFPCVMSAUwpFAEEc8CkOoXigCdesbzA8bdS6pu4X5eiecwz27mCVB7Alr2NCigAt2JRfyKMy7yYlEuBlIs5DiSsFFVdEX47w4doAVmvzVaP1I+pKCPbO8N4q4VN2U6ZqFutUmaubbnXrfUBv51HlRECo97/gI26QJq7x0pNRAq/qUyxAcH66nZfOl03zPMLAvToTvGaKppHq+GSQ4oHJXTHnEd6e56SaZiURWhUJhd+1+kB0W1gbejMQOM33Vokf2ZBOtuem2lfPeBgO9B5ivDRPVIHI3Lqm44jICIAx4qFMxOu4ze2fxQITtjJusouVpLljUcyHyjciNY05snFY3xVnQ/ZBPZ5rXX6pTa9JxT/dL+CNlTAUQ6BsWpKC/pak9ceoytpXXjrKeYp60mxboWe0twOr4B1gjlqJR9A3Ntg9DB+wbYCukvN34xd+1rGcBUsAy8SUBVm9zGIPlL149CroSX6qrZGfxzfRcxoEF6DxuIVRCtwTIQkI1LfaQHtgt+3Nld6W/+AUPJPpXoc5wOOu3H2IS8VWtYioGbspDllxjS9OJa18gjAETM6tf/5uJH8iamJy1PSIlxrPb7wzX5QDGSVUSqhf/EJuxd21YDCdSSBOwXrcV9tm+rpLPoSMytL4cd1c/K6edMpQbKQWBpmWbqG4tbwzmzc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(376002)(136003)(346002)(39850400004)(26005)(107886003)(6512007)(52116002)(41300700001)(54906003)(86362001)(6506007)(6666004)(478600001)(966005)(6486002)(2616005)(1076003)(186003)(38100700002)(83380400001)(2906002)(15650500001)(38350700002)(36756003)(5660300002)(8676002)(66946007)(4326008)(8936002)(66476007)(66556008)(316002)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jmTmEMzaiH+TB9m5OIITAyWnYwH1GBr2FL7VHzW2AQAbJDW6WxSL+uN52nqB?=
 =?us-ascii?Q?d8vEF2B5X4R5IExG7gLYf9wT2AVcHRxH6P3oKaMlGiHC8AlIEWy4Q9HBzZTX?=
 =?us-ascii?Q?En4wTZtv1v7mz7Gwq5uqLjSfjMPa4bszguT3+Ln8xLG5BYyfPI2ui6wvEroM?=
 =?us-ascii?Q?9+Hxg/wV7qdi0JhFUPmZytUDFNfbLH45P4qFJBOSrG1ik3Lcvon9b1aUa5DL?=
 =?us-ascii?Q?+tynwf6ortuLZ+14eTPpDhHFrbNXuz+p8f/80Sx71w+UyNro4ehH1Ah52tkf?=
 =?us-ascii?Q?U7zJAydXHzYMVV06UXgGgBDhA1MJ4Xxffp2F15gdXz6wEqaWKh8eG9A1jKHF?=
 =?us-ascii?Q?fme3DId1vDOXC6eKDD7RXyTRXFuomcU4EoCv6xDeBOmmjOza3wky2KFwbjcK?=
 =?us-ascii?Q?MvxdymESh8HAC/HSLr84bGgZ4uNJoA1JvoMNRI7GX+n86WCe+AAotO4Ic2yd?=
 =?us-ascii?Q?odiIX7wd3O1it6fVYKhuhr9cLiHWe6l7M4NOrVIapf6Ky4tRFf9mqteo0+sM?=
 =?us-ascii?Q?F+LorxdO/Js2L9uxpg1l/JMgByry26irf+vDK27BtDRmj5ZMfqyD2VRT+VK2?=
 =?us-ascii?Q?fQRbkIqbnUlaEp7v8F4Henw2KawpqTr9y7VSO7gVPe1Bmw0Z4KFUel0fbN8x?=
 =?us-ascii?Q?r0It0cNpnB/K5RW9QwCaA1x5nti83zbeLM0AGqimQU7RAKH4zqIvzJ90mrIv?=
 =?us-ascii?Q?MjIf25RQKZxsErlBqOqyZCjnmskA+QtcsY23Ok1eeIgSvAZAs2H4hMcsua0F?=
 =?us-ascii?Q?kwv/N0U+Zr2lxrj3eEkrX2+F9RKi8COdQIenKbZdLUl2wSLiiRg0HyPfxCjm?=
 =?us-ascii?Q?ahJne1oeWBDCNKDMuDnpxOdqwZNRvVWH4BgMcFkEjMxj00LN3xw4mX2bNjdS?=
 =?us-ascii?Q?Yluqu2HTCQCuSUS6ZcnO15URDBcHPcj3eV3Z3E+cPvds0u61zlAEjxfqXrxw?=
 =?us-ascii?Q?UKaJDC9Yjn0DTDwTGqNpZJZ9y3gB/iuQZRUfGTN3FzzJ77OHtbhJP6qMK4YP?=
 =?us-ascii?Q?7n0yYRsC/+Mr0Q9WqsUnc2FgZ078SoRGF2Aumy714eff1T8Wp2UV2jeB/0Z5?=
 =?us-ascii?Q?eAXsO/DmP61wH+qJJtEv5IsVhYBizYp1hDLsutS16dQRSJaT42PeZWHFtXlD?=
 =?us-ascii?Q?p/uHJtbBCP5eTFdhhUJImqRJTXUFnFPdMw4pTSRIBzjPrkpc9ll5gbgWFZ6J?=
 =?us-ascii?Q?RX8YXuN+ue4ixmpsY44xDwucO7I1ywqHgrK/pkvf8ia7bF1HFP/YOpxcgsl2?=
 =?us-ascii?Q?LnMqVnJvEmLyklTCi+uHu6ye1TVx2fFwGgkqPwH0PXIEfH+RPQBfyWDtkpYj?=
 =?us-ascii?Q?m7DAywbedf0Tw6kB8SrtE6+Bk1mLISDh+tI8+ZCpwUfHksCtNALE15FQ0/rW?=
 =?us-ascii?Q?5fpj9UtJoEYug640y33BNzJ9rktFQX+7DUpn4E7NKdw2ypzNuOCgqcy41C86?=
 =?us-ascii?Q?sysRHiVlWUDSj4O+jK81SzW0AGDqoET056RDVI+fusaETo8q2Tm4zA4NBUE2?=
 =?us-ascii?Q?HnZJwvBZPxlvBZ9yxNeAC1zYx0AyDuKLOLt/DwAgvWb6bHI3cIEHhb1ja7/R?=
 =?us-ascii?Q?GdZ97HwBVCySwr6xFL8UwhJvjzhXiCO+JMLVy9jyAGcCc8PJFwyT7VQe5Puh?=
 =?us-ascii?Q?4w=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c4577bb-aa5e-456d-c32e-08da9474c432
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 04:10:45.6373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /UZwVIJxX+Ir4vOnY6IjQncKY5d/jM/dXzbIfp/X/Wqxcvtv2kJwcRL4xuSrxNkNnZYzCcydKyWOEO7wIpLRPoHiU/4/cw7WSviluiIoVdM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR02MB9116
X-Proofpoint-ORIG-GUID: 4o1N-R8fjMErZsK--8eAQ0yGweOCaz_Z
X-Proofpoint-GUID: 4o1N-R8fjMErZsK--8eAQ0yGweOCaz_Z
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
 include/linux/kvm_host.h       | 20 +++++++++++++++++++-
 include/linux/kvm_types.h      |  1 +
 include/uapi/linux/kvm.h       | 12 ++++++++++++
 virt/kvm/kvm_main.c            | 26 +++++++++++++++++++++++---
 5 files changed, 87 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index abd7c32126ce..2d7f63aa6ef3 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6614,6 +6614,24 @@ array field represents return values. The userspace should update the return
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
 
     /* KVM_EXIT_NOTIFY */
@@ -6668,6 +6686,20 @@ values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
 
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

