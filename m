Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB9B5B9894
	for <lists+kvm@lfdr.de>; Thu, 15 Sep 2022 12:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbiIOKNI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Sep 2022 06:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiIOKNG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Sep 2022 06:13:06 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BAE07B7BB
        for <kvm@vger.kernel.org>; Thu, 15 Sep 2022 03:13:05 -0700 (PDT)
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28F4R7cV016296;
        Thu, 15 Sep 2022 03:12:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=2ruFcqmhurpAOnfoBpr0QPVZrCJT/wNpd0j3CjSIO1k=;
 b=dEIsNvqbAod7CHh2KrCj5C1EiwYNcEZzeahBZIiZhFd/TWo3H04LOx4QIEMJa8J6xXZX
 xoLEVt1b3Mk+yRFjDnEC3sI3aHYpGlfo8wLgJMtuQzQjU6ooFl+Mju7fL99FetsT8Rnz
 cQE7FHmrYLIP9roBdIZQu1pgb5BJCygfGV8XmSY4ZmFN8OoaJM3PbFFVggW6M8Q2ph/u
 8jWOzjUyU7PWfDdv5FNa0oIUSdnakjwpvRzkg38S+szvtizaLCuAQtR03hf/Pb7ldltY
 e22oMTYwQehIbpPepOGV1NRSapV9la/gbdkMvPYlFeSwPBGphoxwH2pVFAugFWwUrJd9 CA== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3jjy0tc8df-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 03:12:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W7HLfrCbx1HEvCPL3HYckA82PJ9XVJLu+EqIMkGHjyi8PZWozYr+oO7Qe5mgJDIkoeqgZZw07nEUv+2E5aVu2zP1DOkdrF8wxvmnO4+NQU5NCsM7s8lOcUNW0dUcZgLKraHBBw9RcqbLdnIrOd9qYIupOTVfIqNoEheEl6zyCtRxnZoEmeIwEtW/ECWeSNd+ola2/wBExZULolGXTvuZBJBlctiDa3HXfZTgUZjopMRkR7rJxF1KG2Bvfdf5/xd8O4Pg4L640sP1nlLJH4tPVRh1WefNkiTlYc0rHdaez1G+jy1YvZ4J0K/Jhxt7bcy5vagk5cnJo3XyDtgtcUMnkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2ruFcqmhurpAOnfoBpr0QPVZrCJT/wNpd0j3CjSIO1k=;
 b=Vgnt/DaJQCR2vghNBkYjlGBZnjRNEbqEuWq6J64imK+jm637SbQflxdWbXJ25j4e8/FMPKsJ7gLvmieGiqpdxB1/14++oTyT8kW6QW2nSJRpQJ9iqS5fFU/zDREGuo+IYDhM4YWTdqsGXKWelhnE3ZB7COYDPUMvaeFL8jZMuAz1x7tT9GWPbw31vAlNzu39HaBt4LBw8CMQVYMwsULw/CzjqcXjtQxhiXlVtO4/VlikLG63yFPtnq4vmq13dNDE46hK9Xzj+zoXWc1C16cj1hAsXM2pq8ocmSWrjVaU3Hes4yWvomcHeJri6/2U0rykiLiV8PW5aln31/4NSufO5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by SA0PR02MB7370.namprd02.prod.outlook.com (2603:10b6:806:e0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.19; Thu, 15 Sep
 2022 10:12:52 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::bcdf:6d6f:e6e:b9cf]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::bcdf:6d6f:e6e:b9cf%8]) with mapi id 15.20.5632.015; Thu, 15 Sep 2022
 10:12:52 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: [PATCH v6 5/5] KVM: selftests: Add selftests for dirty quota throttling
Date:   Thu, 15 Sep 2022 10:10:54 +0000
Message-Id: <20220915101049.187325-6-shivam.kumar1@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: c5835724-b54c-4586-b218-08da9702d970
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tzYj5TMrB2Wv/HLNOhdewnk6CQ2u6CNmLmEZJdyeV7rorQhruhHZ9bxMP/oxKisdFl0R/r29TNWR9GvhnwRv0j5lYRVAjGo30BZbsymo+RWoOGG1nBkPeEdsWT150uYns4pxs5Iwc8hdUxVriTrl90C83t71KEfZ3BM1MA2MvENpJGuB4icLxHxLIIauJIw6Zx0hoyTFiMNMh9gU1p0hnC7MkXszjl9JGwEllOrH1Ch8pVVFZcxcXI2YAnWrqw8qw66hIjFVcy7haroCrOBJLj/BB+UjgzpqqIqRiXu+Ac98i2mTeKLoPvhU3lN4lTsOtgimqPozuXCv9XxABnxWoGjcZZoGKRN85n4sI+tYAQZLhrsTbS3fr2wI1esWcmaYMhoysfSCUsbSAUC3iXjp/7E1L48HhSayKcak4nuUOPLUE39qQvAxlZTW3qLqohYvMEvvKzQYRBuOFjl4vkibsuxb+/69f6ZpDdjE98qT2JsVAFbeFLgVurquWHTPOPg913VKIhR3xgMmvjOprlN6cTywErOWOjdeObQ7vtl8X2R+4fSrf3EtoeOmMCUlkH/Bwut386iyDCUSdS/ZY5/HITakz6O0tOA0ImI2FVIDrZVr/mlrh5z4quPy6AYAYnNiQswYfoHAS16l2D3ldNZVItTypV+gtpYwGVWRiX9s/arwkguG4cXoGQEabaHdbGGXryiaETD6eL6n+uJG+CbNFVlNrjS89xf9I9IhLoCcPXMmvlHLBgdYTS2lO+4z3x90EeHBtyLrLv3H+rpq/UktPIxQxHiSc9s1SD2S0VIrCP8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(346002)(396003)(136003)(376002)(451199015)(52116002)(107886003)(2906002)(38100700002)(41300700001)(66946007)(83380400001)(2616005)(186003)(6486002)(8936002)(6512007)(316002)(66556008)(478600001)(54906003)(6506007)(4326008)(5660300002)(86362001)(66476007)(8676002)(38350700002)(26005)(15650500001)(36756003)(1076003)(45080400002)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9bFDcFUwEAep5H+pF8X5BkZfUsvvftUlWMLEJorjUaGgU8bl5RlzzjXd7nKG?=
 =?us-ascii?Q?raWMKcLwWq/yifgvdb+PLxVD73PkSpnJjS99g5UQkVGgjK4QK4Z9yX3lkS7b?=
 =?us-ascii?Q?pSNDX9viK/lqYst/qamxPd8ZBkYmgewH54gNJwPsB1d5OnEFgdL6X81ig1mV?=
 =?us-ascii?Q?O+o1E7e7YTT6ujhs5Yrt2feKuaPsNFRwnoyCHp5Uc9Z0FBkER4Y1mqXl801q?=
 =?us-ascii?Q?revyzC3jbtUmK5ioVHgM1VlqKP6eM/1kgAM1bybV/XzuiNXwaAlnlHK8qUZ4?=
 =?us-ascii?Q?vUaLbWUbCjikofcBlbZNcCLT8WwfTZ1qP6dwPv6msJlEous14ZCXHkibD4WH?=
 =?us-ascii?Q?mGAEC3nGckTr1SF1t1RYVPI3DthvVVxPIG1vZfJL4f1y9940H5OqkXDEfBzw?=
 =?us-ascii?Q?Z8q5issEfciKurTYCQIIw4ucPJYPDJwupACQY83DwE1XxGlm9Y66QxDYYjWZ?=
 =?us-ascii?Q?GHuocBS+1rfdxxUeRFxwnw11l5BP3K5CUdCJVniFr9uB3iCUC+ht0vPTiMx8?=
 =?us-ascii?Q?l4fVNAqzlwj4vjve2abed3Xm7LV8H/BqnQt7Xx0Fp3xPbMgwCH4oDjWdw3NC?=
 =?us-ascii?Q?4BVN1kxqqtDUsHl0BaWe9zkGHCaM5DdNB/NG+WAfc7Ri42tkQoBdSlijLlO4?=
 =?us-ascii?Q?tjMNAQN9qG0DEt6pYCAjdtpoOHk53SG3YSDgQOQQNdXn0zFr4O2QqWoz6mvL?=
 =?us-ascii?Q?6dUePBVtY+CwfRSRwvO3ddrRpM0kKrK+PnCrSQ/39izin9s1oLL7a5Oxc/0V?=
 =?us-ascii?Q?/Vb37vWWjhW3qQqWMCQ7059VNPAnBUzSx4/072kYg2C/8Ryk8z4s03rg3hDv?=
 =?us-ascii?Q?dlQX+FZaYrAxxEVClCJab0El4UyRC4RIgWZyYGNTQ5c4ofkCoVrvmgTagw35?=
 =?us-ascii?Q?+frpsUgbq5iQ15lezz5eHCmUZvVsjy+/2fG39sAkZUhaDVe1KReOeKrC7Rie?=
 =?us-ascii?Q?uLg9+f6ODgd/bVnZ6sJ/1E4RFFdUW14aisXVuAo6AgpqGP+f1ZnlZH9yJNl8?=
 =?us-ascii?Q?+RNK/2nSHjU9/24plUvfFFjZd5GK8X9lB/H90uMoWdGXYlvR4PwSDSrjaYvO?=
 =?us-ascii?Q?xvvWUeOzzGap1HvjzVPnEPOS3ivSO9pvv843KeYdodTmzNlaf2irY9FhtK0P?=
 =?us-ascii?Q?FMhuv+0bX1WgazEfh+4UQudr4pcV9J56A+fWMerw/kgAUWWIPsZRBFhZ9AIk?=
 =?us-ascii?Q?qzgfHiF79MQcXOMIXnVJiIOxkU4BY3k6h7rXBB910yQWTckwLlOhF80A767T?=
 =?us-ascii?Q?JR0Q53qJhP2yeCF1imK2+TWmH6WMK3Cwz20D1mCn+zvuhI+8u7C8+G2c3kfK?=
 =?us-ascii?Q?KuPVJ6S0ceFczkgMCya58yunyge4OQJY6B85shRwxZd9P3unKNgXvQhjw1sI?=
 =?us-ascii?Q?UcVOJRAoNYAxXBzxc5ZPnKDnZWJsegNjt9hby8/UBbPRjfqgA7HcCWbdUXZW?=
 =?us-ascii?Q?RFM90Dx8EQmQSTMSM4zMTx5j0QKcp8Sc2pND4DRWYRHz51vsmsJRnwPGQDIa?=
 =?us-ascii?Q?6XIyG4h3SOFDrxiKlxo6/aXSiL2nWY0VMJfc1b5KCOpphldaWb0wMSAz1hSm?=
 =?us-ascii?Q?M34KzzlveCeYtzjkiFkLCR9wJhoJYLc0eBSSzK3Qg4eszkw0MCKl9mCE/8Ab?=
 =?us-ascii?Q?Qg=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5835724-b54c-4586-b218-08da9702d970
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 10:12:52.1835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WIw3kSvT+LSLzUWtrhVhiu36kqprmiapamsQGJh064h3UMSKSr0AuLCUxzvP5Z0JFsdTioTFrUL9PUjbNiHnQrgvK58p51jKbNMwXHfAZco=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR02MB7370
X-Proofpoint-ORIG-GUID: 2ijBEhSl69MmAs-JOGskva1oaYOA-2--
X-Proofpoint-GUID: 2ijBEhSl69MmAs-JOGskva1oaYOA-2--
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

Add selftests for dirty quota throttling with an optional -d parameter
to configure by what value dirty quota should be incremented after
each dirty quota exit. With very small intervals, a smaller value of
dirty quota can ensure that the dirty quota exit code is tested. A zero
value disables dirty quota throttling and thus dirty logging, without
dirty quota throttling, can be tested.

Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c  | 33 +++++++++++++++--
 .../selftests/kvm/include/kvm_util_base.h     |  4 +++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 36 +++++++++++++++++++
 3 files changed, 71 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 9c883c94d478..81c46eff7e1d 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -63,6 +63,8 @@
 
 #define SIG_IPI SIGUSR1
 
+#define TEST_DIRTY_QUOTA_INCREMENT		8
+
 /*
  * Guest/Host shared variables. Ensure addr_gva2hva() and/or
  * sync_global_to/from_guest() are used when accessing from
@@ -189,6 +191,7 @@ static enum log_mode_t host_log_mode_option = LOG_MODE_ALL;
 static enum log_mode_t host_log_mode;
 static pthread_t vcpu_thread;
 static uint32_t test_dirty_ring_count = TEST_DIRTY_RING_COUNT;
+static uint64_t test_dirty_quota_increment = TEST_DIRTY_QUOTA_INCREMENT;
 
 static void vcpu_kick(void)
 {
@@ -208,6 +211,13 @@ static void sem_wait_until(sem_t *sem)
 	while (ret == -1 && errno == EINTR);
 }
 
+static void set_dirty_quota(struct kvm_vm *vm, uint64_t dirty_quota)
+{
+	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+
+	vcpu_set_dirty_quota(run, dirty_quota);
+}
+
 static bool clear_log_supported(void)
 {
 	return kvm_has_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
@@ -255,7 +265,11 @@ static void default_after_vcpu_run(struct kvm_vcpu *vcpu, int ret, int err)
 	TEST_ASSERT(ret == 0 || (ret == -1 && err == EINTR),
 		    "vcpu run failed: errno=%d", err);
 
-	TEST_ASSERT(get_ucall(vcpu, NULL) == UCALL_SYNC,
+	if (test_dirty_quota_increment &&
+		run->exit_reason == KVM_EXIT_DIRTY_QUOTA_EXHAUSTED)
+		vcpu_handle_dirty_quota_exit(run, test_dirty_quota_increment);
+	else
+		TEST_ASSERT(get_ucall(vcpu, NULL) == UCALL_SYNC,
 		    "Invalid guest sync status: exit_reason=%s\n",
 		    exit_reason_str(run->exit_reason));
 
@@ -372,6 +386,9 @@ static void dirty_ring_after_vcpu_run(struct kvm_vcpu *vcpu, int ret, int err)
 	if (get_ucall(vcpu, NULL) == UCALL_SYNC) {
 		/* We should allow this to continue */
 		;
+	} else if (test_dirty_quota_increment &&
+		run->exit_reason == KVM_EXIT_DIRTY_QUOTA_EXHAUSTED) {
+		vcpu_handle_dirty_quota_exit(run, test_dirty_quota_increment);
 	} else if (run->exit_reason == KVM_EXIT_DIRTY_RING_FULL ||
 		   (ret == -1 && err == EINTR)) {
 		/* Update the flag first before pause */
@@ -762,6 +779,10 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	sync_global_to_guest(vm, guest_test_virt_mem);
 	sync_global_to_guest(vm, guest_num_pages);
 
+	/* Initialise dirty quota */
+	if (test_dirty_quota_increment)
+		set_dirty_quota(vm, test_dirty_quota_increment);
+
 	/* Start the iterations */
 	iteration = 1;
 	sync_global_to_guest(vm, iteration);
@@ -803,6 +824,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	/* Tell the vcpu thread to quit */
 	host_quit = true;
 	log_mode_before_vcpu_join();
+	/* Terminate dirty quota throttling */
+	if (test_dirty_quota_increment)
+		set_dirty_quota(vm, 0);
 	pthread_join(vcpu_thread, NULL);
 
 	pr_info("Total bits checked: dirty (%"PRIu64"), clear (%"PRIu64"), "
@@ -824,6 +848,8 @@ static void help(char *name)
 	printf(" -c: specify dirty ring size, in number of entries\n");
 	printf("     (only useful for dirty-ring test; default: %"PRIu32")\n",
 	       TEST_DIRTY_RING_COUNT);
+	printf(" -q: specify incemental dirty quota (default: %"PRIu32")\n",
+	       TEST_DIRTY_QUOTA_INCREMENT);
 	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
 	       TEST_HOST_LOOP_N);
 	printf(" -I: specify interval in ms (default: %"PRIu64" ms)\n",
@@ -852,11 +878,14 @@ int main(int argc, char *argv[])
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "c:hi:I:p:m:M:")) != -1) {
+	while ((opt = getopt(argc, argv, "c:q:hi:I:p:m:M:")) != -1) {
 		switch (opt) {
 		case 'c':
 			test_dirty_ring_count = strtol(optarg, NULL, 10);
 			break;
+		case 'q':
+			test_dirty_quota_increment = strtol(optarg, NULL, 10);
+			break;
 		case 'i':
 			p.iterations = strtol(optarg, NULL, 10);
 			break;
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 24fde97f6121..68be66b9ac67 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -834,4 +834,8 @@ static inline int __vm_disable_nx_huge_pages(struct kvm_vm *vm)
 	return __vm_enable_cap(vm, KVM_CAP_VM_DISABLE_NX_HUGE_PAGES, 0);
 }
 
+void vcpu_set_dirty_quota(struct kvm_run *run, uint64_t dirty_quota);
+void vcpu_handle_dirty_quota_exit(struct kvm_run *run,
+			uint64_t test_dirty_quota_increment);
+
 #endif /* SELFTEST_KVM_UTIL_BASE_H */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9889fe0d8919..4c7bd9807d0b 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -18,6 +18,7 @@
 #include <linux/kernel.h>
 
 #define KVM_UTIL_MIN_PFN	2
+#define PML_BUFFER_SIZE	512
 
 static int vcpu_mmap_sz(void);
 
@@ -1703,6 +1704,7 @@ static struct exit_reason {
 	{KVM_EXIT_X86_RDMSR, "RDMSR"},
 	{KVM_EXIT_X86_WRMSR, "WRMSR"},
 	{KVM_EXIT_XEN, "XEN"},
+	{KVM_EXIT_DIRTY_QUOTA_EXHAUSTED, "DIRTY_QUOTA_EXHAUSTED"},
 #ifdef KVM_EXIT_MEMORY_NOT_PRESENT
 	{KVM_EXIT_MEMORY_NOT_PRESENT, "MEMORY_NOT_PRESENT"},
 #endif
@@ -1979,3 +1981,37 @@ void __vm_get_stat(struct kvm_vm *vm, const char *stat_name, uint64_t *data,
 		break;
 	}
 }
+
+void vcpu_set_dirty_quota(struct kvm_run *run, uint64_t dirty_quota)
+{
+	run->dirty_quota = dirty_quota;
+
+	if (dirty_quota)
+		pr_info("Dirty quota throttling enabled with initial quota %"PRIu64"\n",
+			dirty_quota);
+	else
+		pr_info("Dirty quota throttling disabled\n");
+}
+
+void vcpu_handle_dirty_quota_exit(struct kvm_run *run,
+			uint64_t test_dirty_quota_increment)
+{
+	uint64_t quota = run->dirty_quota_exit.quota;
+	uint64_t count = run->dirty_quota_exit.count;
+
+	/*
+	 * Due to PML, number of pages dirtied by the vcpu can exceed its dirty
+	 * quota by PML buffer size.
+	 */
+	TEST_ASSERT(count <= quota + PML_BUFFER_SIZE, "Invalid number of pages
+		dirtied: count=%"PRIu64", quota=%"PRIu64"\n", count, quota);
+
+	TEST_ASSERT(count >= quota, "Dirty quota exit happened with quota yet to
+		be exhausted: count=%"PRIu64", quota=%"PRIu64"\n", count, quota);
+
+	if (count > quota)
+		pr_info("Dirty quota exit with unequal quota and count:
+			count=%"PRIu64", quota=%"PRIu64"\n", count, quota);
+
+	run->dirty_quota = count + test_dirty_quota_increment;
+}
-- 
2.22.3

