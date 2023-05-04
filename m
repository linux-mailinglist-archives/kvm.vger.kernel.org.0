Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9066F6E83
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 17:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbjEDPBc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 11:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbjEDPBJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 11:01:09 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918D2901D
        for <kvm@vger.kernel.org>; Thu,  4 May 2023 08:00:38 -0700 (PDT)
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 344AIeVa002011;
        Thu, 4 May 2023 07:44:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=Rzg5Nhqb2jKetwF838WLE2AiKtBzw0eOXqjz8dAY4No=;
 b=nlBfvAmICDpF7m+3SRnCZ74HInPk7rl5BIlXVYSPYxBf3uSwnDFHPc9nzoRobYs1QPXg
 jpj+V3IaceCho/TBa8pM7VxOn4avmblNwoVvUDr7aPM0ep0Ui2wtiKrTrm+qoK60vuV8
 s7mvjppJa+kt1c4j7F3/o8a2gzSkncq8DbbdOGr5BBegzfuc1d+eXqD19cQe7FcJcznv
 /y2rSLCCFQ+v8qPzJIXXs8GNPgb7InDAawgDUc4g/pz/JE06c0GN5v8soiMYdOGvPmTV
 9/Xk4SVB+FzfMrn5F8gJj1AjmLVQXVIPzFhj0esIP+o3QsAvmtY9iddvA6sBw1WXqQ40 Uw== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3q92ajje2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 May 2023 07:44:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hgs5pfZHEjzNdLJ5mpz5pIPrvImlTQ7mqT1EQFgsKI6pc155o46Ud1rR4+hUTraFzyp7A1paY7sUYhmlrVaegKvzEwoqcQBvJxiFLYg1+/bhj/6rELbJtioWdMk7jUr0X12GZ+SeI67K6dRD4UE00NKa3tTfDwb6Z0Bz4obTeO9BcRwe/CKSjZZV7rgJFLS5mGyr6dWU/MKwOqXQdOKhwi1aAr7MCLDr0OgKy95YVzqvts8rBnXgQfojQu/Vtd65ATZ12xCNdn98BoXUtqFXRYf8btyO914yiOh5F8++JeB1GDceFwOjyywYput8bezws3x2iB7Yi8DMZNP/ECfAzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rzg5Nhqb2jKetwF838WLE2AiKtBzw0eOXqjz8dAY4No=;
 b=GqZ6jwOzwkYrXsxSfqbwnZMqx5G+SfzbFSBKCxYo4hBSo+/dtgGs4HszrQeZVsDuZIW1mWXjx0qp/UhnFVZ1uOMq2dojC7TJWZbvcOjailpg5WeyQTIJY/GyRNs0Ft4CaB0EvkMMx/DnoKvidOVfLfq0C4mEbqJvdvUaEu/98VV4sTJsQdTEXweXmv+fVSweFZ6ZAVm5dA2s86JWcXDRRE0NMP3XmuCep0DtU5i3R6SkI3nmMLmG8538s7QRr5IVRxBV+YhnJ1Irr4vDDqsE3qY3oOwuFGwVgteXH80M1z/M8EHAQdSA6oY3KF9/l3cSHu0mKG3x3fHDH8IYq+cxPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rzg5Nhqb2jKetwF838WLE2AiKtBzw0eOXqjz8dAY4No=;
 b=AMNSJKILH5sN/B0BF3dI/6fiRgYrh+2KhN6SBfbOzf7daaX+0iQVaea2RrlS65WESz8B7nOWHB4nHey0XqnKjPwC9QBAeaW/yeC/MTOl8zTR0iZh4WNyuQw7ArAWGGfOhNcATtOeQrRtN22V6i33YplydYysA0hClN6rfFpZIZ7OBuGrfvOpESTgpJ3fEkfY7aHsDIgZabJyEfN945cegc727EIVVW0EXtTm9+FtBxbtgVpVsepGQJ7Bh65c5ls/zZCyCelQh7UlJQEQ8IpotQYKWp4lWTwvSkZsRb8ch+8c2v5AkibpOrPU2kbyg0bCMVveuHz5MSRAXc96hz0a0Q==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by PH0PR02MB9383.namprd02.prod.outlook.com (2603:10b6:510:289::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22; Thu, 4 May
 2023 14:44:28 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::bef3:605f:19ff:568a]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::bef3:605f:19ff:568a%2]) with mapi id 15.20.6363.026; Thu, 4 May 2023
 14:44:28 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com,
        aravind.retnakaran@nutanix.com, david@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: [PATCH v9 1/3] KVM: Implement dirty quota-based throttling of vcpus
Date:   Thu,  4 May 2023 14:43:27 +0000
Message-Id: <20230504144328.139462-2-shivam.kumar1@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 478ba9bc-d545-4951-7534-08db4cae102a
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dwD7LBcCIz0w5bywlzeVElhArdu6cMmWEqxI4tOtG1+YHzAz16AXzu5C06Lf8aSUaiKCUq9uKJsQuQqVuyr1QbLBoMR7IqxtB9qPtTh2CqtAFz9d+NKlXuCDoVCYAju0SYRahxjSRDRg8a1IBrQBkNT9QLanzhlbj0KjhNrMWobTB4rEbHd/BEZhcO05S9cjntvy/1Q5GrTORcJOBzbsrMwTHi+Q27b+mzHoRa/2wVoYbfdfBHWcbcv9lo2fmZRpG4ckxhl3ivH/1ALSkbdCmkKJtvM8cotC/OGcz/KZar/OPj5sSb6oZz3+QvZ3Xb6Pz7NxQeG2q0VqQ1VZbgS9GQ1g+rYm1BOIEA6jHsjkBFazt9pX0xEz7LvHC81C5NTKvsSGHmif7c/9HteoCmJYLr1+AQ1C/Dx1eRPtVcAVK1hZuGcirO6ossdbiN+z0XHzQabz2ig3qshJ67Nw80LqjQQPBsM7GN3omYYw8q2s4Fb0b8Swpb/V33nwcZV1ZSQ79yfDYVcVk6HXWyxxxcI8/9N81ttpj6aHUqmwJQlhuE6UkBTf5ehQl8ncq4a9RL7RaXf2zmbIm6gBAu+LuRviJkWGrQ6Vl6RSyNdGy8UwuZA+GVmXwh2djZ2Fhn/JthzqvR+K3piA6JDSIdrIqBChO/6ujDwTZX3W6pbUGRhobkM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(376002)(396003)(366004)(346002)(451199021)(5660300002)(107886003)(36756003)(41300700001)(478600001)(316002)(66476007)(66556008)(66946007)(8936002)(4326008)(8676002)(38100700002)(52116002)(86362001)(38350700002)(6486002)(2616005)(186003)(54906003)(6506007)(83380400001)(6512007)(1076003)(26005)(2906002)(15650500001)(14143004)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ncIuHcFypOkYMLcC75mYQoE1Jr9zKlBmoM15Y4Vkk4VBDuDdJyn8pmDbhAvI?=
 =?us-ascii?Q?Q050fEingt4aH1VRD93Y4TXwLZX0xgxfRl/MlvWHWTrGI0BrJpfvN4iC+25K?=
 =?us-ascii?Q?wPcY1miryM7IPsvJ6xvTKLmMhh643C/ujxkcHgEY1sMycxP62sG0p3Geoe2D?=
 =?us-ascii?Q?DS1Pz6Abf1VdQv4dzLoeeE1CtYnh1JYk56VqUSp6HfFC4HtVK2B4JKkzH/lw?=
 =?us-ascii?Q?JVhdbZfA0BZy0esKILkZA8x94kM0+zEf0ThRbk/D3Q30qU6zdNRuqkTDDRTB?=
 =?us-ascii?Q?xTR4LIkgNoad1j05Fd+ayyVyJpjx18EMWM7cVMtC+F8ol1R7YuJ+OzZeN0c6?=
 =?us-ascii?Q?x/JB93b2qWzSY7LTDGVKlkd6+VBSuvesK94XB8xr9aSb7iPnqaFDIvDlQrxg?=
 =?us-ascii?Q?VUceRrQJDb/6Ccb6BSdh1VIA50GEiw5G//BIFfe2GYZTpKBxgacqb9aVTaZ4?=
 =?us-ascii?Q?6pyBoNwdlBU7tD83AOi6b/weQYCtLrzFerGG5BfxOtV6ICD5Z+X/JIriwyUX?=
 =?us-ascii?Q?NFVmYfpwSmPIw9uh5G1YaUxrS3xgftKI9JHWR4d40mcR4oX3FmLnIp3Hx33F?=
 =?us-ascii?Q?YSosyOyggjtR2QPgMziN2ASbaJHNtBdBvMTZ++yBVH528RFP8FAGGJkpMhGD?=
 =?us-ascii?Q?qcPSC/yVf/G8Ny8dyv1yCuSwqK94Nm0X3NqFNMnRZMRiLa9M+5yASJvUsr52?=
 =?us-ascii?Q?yEXs8puPWEnmTWjVbYFqHBbnA/pufp/aSPY2UgcL7kyUhG+9bxxg8XvMtcrv?=
 =?us-ascii?Q?QNBsrgM9s7fRrIw6c8C5tUMHj4J8lsUzfi+Dy21sXX9O1QoqfQj0SHEtj/VN?=
 =?us-ascii?Q?6J0kyFrUHKOtX3AeUD0u9CcVp989hXlEqrE2m59wTV27jGtNTi++IdTncXYP?=
 =?us-ascii?Q?/Ja0rmtpycxA4zVPW3/+n85oZ+7PdLKfzOXEBQ41zeY9sLXeDkKfb6WcnAr6?=
 =?us-ascii?Q?wIe6zrpu7WPdVIl6IFK0wy59HA7g2eQlJCFIeWabZSoV6gonlOXAqLvlMl0s?=
 =?us-ascii?Q?xosx8xew6B+Ql2+86jjdKQQmEikLahKl5BsOQ6wTFbRUuTsOrc2oydi1raW5?=
 =?us-ascii?Q?F7LcPys36Z3Hp8JzUQ4lkHCmI3G4n1cRCZ59yud1A+rZTO6nbLPAELEHkDfM?=
 =?us-ascii?Q?tnq7KDs3tlP7jCRmDUShljpJni1+pGMU0TBpcoTodo7VuuMIhZLy0RblOnn5?=
 =?us-ascii?Q?jQpHurs8o90sn28rs6ANc5NN3YCSMrY66IqkDdSu9vuJnvd/1hyBhfNoM43q?=
 =?us-ascii?Q?doCmZ2wia6eOi9bGAnQvjgtsx7LVOvurVFEvzya9/qNHAbxAJ7C92NzCd/+7?=
 =?us-ascii?Q?k1nNllygUQsAJmonPSqFYqDeqEgvJuY0WhciebCdki+4a45J4ZcnPTbp2HWg?=
 =?us-ascii?Q?alfN/JXV9+Sd/0s9cujsCz9CegpraQoOSBQ9iYpkAGKwNv3PzadhMy4X/iCO?=
 =?us-ascii?Q?fi328eHx12ow0Us9Ap04o4/vPeURj89rxMcGAssYX8so5mCgSzImA6p9jfVO?=
 =?us-ascii?Q?tq+iUyr8fX4RhKjJH7av/dmM37jg//Fkrdq2G/7yXWlbIopZBKdjGTuII/uN?=
 =?us-ascii?Q?etv/gCsOO8g5yPaio+hT3AuqbktOUwPnJbtbaqsT/XXb2bVojsptCEOx3D+A?=
 =?us-ascii?Q?Ow=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 478ba9bc-d545-4951-7534-08db4cae102a
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 14:44:28.3944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g/CSvIzBlvNxDyMzyLmXWKeVA2yEryF3eEyVB6wEhXU8fL4K9/9Ue4o4F4wTnzGVZXyUXt0pfnuVim7s5l1YmVJRgcnOErKsHoICi/dCSEY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB9383
X-Proofpoint-ORIG-GUID: ajmsy3SZAMKydedHanZI53DAHfXCpymP
X-Proofpoint-GUID: ajmsy3SZAMKydedHanZI53DAHfXCpymP
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

Define dirty_quota_bytes variable to track and throttle memory
dirtying for every vcpu. This variable stores the number of bytes the
vcpu is allowed to dirty. To dirty more, the vcpu needs to request
more quota by exiting to userspace.

Implement update_dirty_quota function which

i) Decreases dirty_quota_bytes by arch-specific page size whenever a
page is dirtied.
ii) Raises a KVM request KVM_REQ_DIRTY_QUOTA_EXIT whenever the dirty
quota is exhausted (i.e. dirty_quota_bytes <= 0).

Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
---
 Documentation/virt/kvm/api.rst | 17 +++++++++++++++++
 include/linux/kvm_host.h       |  5 +++++
 include/uapi/linux/kvm.h       |  8 ++++++++
 tools/include/uapi/linux/kvm.h |  1 +
 virt/kvm/Kconfig               |  3 +++
 virt/kvm/kvm_main.c            | 27 +++++++++++++++++++++++++++
 6 files changed, 61 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index add067793b90..8e435a16e369 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6752,6 +6752,23 @@ Please note that the kernel is allowed to use the kvm_run structure as the
 primary storage for certain register types. Therefore, the kernel may use the
 values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
 
+::
+
+	/*
+	 * Number of bytes the vCPU is allowed to dirty if KVM_CAP_DIRTY_QUOTA is
+	 * enabled. KVM_RUN exits with KVM_EXIT_DIRTY_QUOTA_EXHAUSTED if this quota
+	 * is exhausted, i.e. dirty_quota_bytes <= 0.
+	 */
+	long dirty_quota_bytes;
+
+Please note that enforcing the quota is best effort. Dirty quota is reduced by
+arch-specific page size when any guest page is dirtied. Also, the guest may dirty
+multiple pages before KVM can recheck the quota, e.g. when PML is enabled.
+
+::
+  };
+
+
 
 6. Capabilities that can be enabled on vCPUs
 ============================================
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0e571e973bc2..499c9ce60b2f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -167,6 +167,7 @@ static inline bool is_error_page(struct page *page)
 #define KVM_REQ_VM_DEAD			(1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_UNBLOCK			2
 #define KVM_REQ_DIRTY_RING_SOFT_FULL	3
+#define KVM_REQ_DIRTY_QUOTA_EXIT	4
 #define KVM_REQUEST_ARCH_BASE		8
 
 /*
@@ -801,6 +802,7 @@ struct kvm {
 	bool dirty_ring_with_bitmap;
 	bool vm_bugged;
 	bool vm_dead;
+	bool dirty_quota_enabled;
 
 #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
 	struct notifier_block pm_notifier;
@@ -1236,6 +1238,9 @@ struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
 bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn);
 bool kvm_vcpu_is_visible_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn);
+#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
+void update_dirty_quota(struct kvm *kvm, unsigned long page_size_bytes);
+#endif
 void mark_page_dirty_in_slot(struct kvm *kvm, const struct kvm_memory_slot *memslot, gfn_t gfn);
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 737318b1c1d9..f0fc898b8e4a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -264,6 +264,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_RISCV_SBI        35
 #define KVM_EXIT_RISCV_CSR        36
 #define KVM_EXIT_NOTIFY           37
+#define KVM_EXIT_DIRTY_QUOTA_EXHAUSTED 38
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -531,6 +532,12 @@ struct kvm_run {
 		struct kvm_sync_regs regs;
 		char padding[SYNC_REGS_SIZE_BYTES];
 	} s;
+	/*
+	 * Number of bytes the vCPU is allowed to dirty if KVM_CAP_DIRTY_QUOTA is
+	 * enabled. KVM_RUN exits with KVM_EXIT_DIRTY_QUOTA_EXHAUSTED if this quota
+	 * is exhausted, i.e. dirty_quota_bytes <= 0.
+	 */
+	long dirty_quota_bytes;
 };
 
 /* for KVM_REGISTER_COALESCED_MMIO / KVM_UNREGISTER_COALESCED_MMIO */
@@ -1190,6 +1197,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
 #define KVM_CAP_PMU_EVENT_MASKED_EVENTS 226
 #define KVM_CAP_COUNTER_OFFSET 227
+#define KVM_CAP_DIRTY_QUOTA 228
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 4003a166328c..6a0c1e674bc1 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1184,6 +1184,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 224
 #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
 #define KVM_CAP_PMU_EVENT_MASKED_EVENTS 226
+#define KVM_CAP_DIRTY_QUOTA 228
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index b74916de5183..ccaa332d88f9 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -19,6 +19,9 @@ config HAVE_KVM_IRQ_ROUTING
 config HAVE_KVM_DIRTY_RING
        bool
 
+config HAVE_KVM_DIRTY_QUOTA
+       bool
+
 # Only strongly ordered architectures can select this, as it doesn't
 # put any explicit constraint on userspace ordering. They can also
 # select the _ACQ_REL version.
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cb5c13eee193..dac78b72fe71 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3307,6 +3307,20 @@ int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len)
 }
 EXPORT_SYMBOL_GPL(kvm_clear_guest);
 
+#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
+void update_dirty_quota(struct kvm *kvm, unsigned long page_size_bytes)
+{
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+
+	if (!vcpu || (vcpu->kvm != kvm) || !READ_ONCE(kvm->dirty_quota_enabled))
+		return;
+
+	vcpu->run->dirty_quota_bytes -= page_size_bytes;
+	if (vcpu->run->dirty_quota_bytes <= 0)
+		kvm_make_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu);
+}
+#endif
+
 void mark_page_dirty_in_slot(struct kvm *kvm,
 			     const struct kvm_memory_slot *memslot,
 		 	     gfn_t gfn)
@@ -3337,6 +3351,9 @@ void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
 	struct kvm_memory_slot *memslot;
 
 	memslot = gfn_to_memslot(kvm, gfn);
+#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
+	update_dirty_quota(kvm, PAGE_SIZE);
+#endif
 	mark_page_dirty_in_slot(kvm, memslot, gfn);
 }
 EXPORT_SYMBOL_GPL(mark_page_dirty);
@@ -3346,6 +3363,9 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn)
 	struct kvm_memory_slot *memslot;
 
 	memslot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
+#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
+	update_dirty_quota(vcpu->kvm, PAGE_SIZE);
+#endif
 	mark_page_dirty_in_slot(vcpu->kvm, memslot, gfn);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_mark_page_dirty);
@@ -4526,6 +4546,8 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 	case KVM_CAP_BINARY_STATS_FD:
 	case KVM_CAP_SYSTEM_EVENT_DATA:
 		return 1;
+	case KVM_CAP_DIRTY_QUOTA:
+		return !!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_QUOTA);
 	default:
 		break;
 	}
@@ -4675,6 +4697,11 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
 
 		return r;
 	}
+#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
+	case KVM_CAP_DIRTY_QUOTA:
+		WRITE_ONCE(kvm->dirty_quota_enabled, cap->args[0]);
+		return 0;
+#endif
 	default:
 		return kvm_vm_ioctl_enable_cap(kvm, cap);
 	}
-- 
2.22.3

