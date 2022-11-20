Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD2C46316FD
	for <lists+kvm@lfdr.de>; Sun, 20 Nov 2022 23:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbiKTW4A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Nov 2022 17:56:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiKTWz6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Nov 2022 17:55:58 -0500
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 117AA2AE35
        for <kvm@vger.kernel.org>; Sun, 20 Nov 2022 14:55:57 -0800 (PST)
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AKLaDQn022545;
        Sun, 20 Nov 2022 14:55:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=hhU+AsdFWs0s0SHFUrLpmcBvw6sle3VSS4hz5NPGUMY=;
 b=PlkHVAK1VEl5o+kYy+4UVmdl2U+M8erPS2f1GK+EWEXTHdozv4Nr0912CZ3/5UozW98B
 g3rWJi7LnEEt8x4IhqWC8buCskz5ztn6SsooeqMS+5kTcTeNN8/IhztYo5JXZpFcrLqc
 Rr4Tj2gyFsbjCr4qo7FR9VkemXGCE3vEfJAF58i2yzhCuExdrvN/GIyaL/G5eoPQNfbI
 +aE9lMqjtrJE+F3eumbTBOfQ3Sd8RhcTzj5j2SXUu4u7lTsE/Y99r9FfHB6150m1CrD1
 +vvzM3rl34SXeX4HFBlYIejZu97Pwm8SXNIiuKsS/MJIf2pNMdtnrirRDyqmGcC721mM vg== 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2048.outbound.protection.outlook.com [104.47.73.48])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3kxy3mjkqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 20 Nov 2022 14:55:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KsUwykk2vj51otQ5/NTbP55nrEVu7m13SPPlgtB/CiuDZv/znfBhC5pk/DAl1JCtcZ4smcsP97mOiMDscCv/qTtIH0wg9s1NFv0y+bhxSIyxJTPI1Z2sjO5iRJVf8sLNcX8l1lkAtDFXOZw7sL9amk/976aooq79T846evN8hzpnZNzYJsM9gPWNYPbGtPfrIATLmDR2ET7OeRR6l8j6cTTY+hZGpELMQl1TXQN8Exo4hKXkmysjJap9Cf1P+R0ZEVCDNpmwBKeQZFnmyRvpI+6kNAl6B47W6a8gQ8q23hjFBAt5+QQ86loILnEsqmM0xHRTKCoWkVvhHfZ8uGnwnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hhU+AsdFWs0s0SHFUrLpmcBvw6sle3VSS4hz5NPGUMY=;
 b=oMMtjVaEMqYV8/kGf0zBAi61zCzqV7rYmDRQeqlOJQs58DLCNGNrHOGF5YcJef/uu2ALLr2RK3lHUxL0UBBKTM1REAaEYCwAv22AIyaFRnUpuqHBfYIBVSpbplJHATit9C2nJV2U24tDOMhFbErP9bgqBOXJ3ZnaBxW45jWAPvQLWe5yhxsUxaqUHSCeR5p3RVtfU+75hfe4E5jl+uKfZ9Xu/0qhQJcrF57cfTMaRgsmUK9Z6Q2E0B4EXJbNKWALSIy0BHa1skCrqwYVrjixkaCE3Wm6z9gFu6RXLlFMeAlJjmWBwYNfhrQVj7knVhSljo7VbPoLrMl2qBTrrUjIYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hhU+AsdFWs0s0SHFUrLpmcBvw6sle3VSS4hz5NPGUMY=;
 b=eKlI+WqY4DrRkvRnIkLS8jToCG0xrGN0XfB1AILQy4eEGetYc3swI3ot+S5NDDxJ2kzOb0l0bOWbbcKEuiBhmuEEQErsyKIQWSz3oKB08SlJVYifM6NB9nrtxPC46AcMt52IvrVKYC7Eiq9IKINzmM64At9oXp7Xs16vbhpum1jjMzaoxDCLOLWcEKaUSDsJ7PVGqOzJ5LS0q3kR8yFtOjp7NR5Bx3vePZ4+afZa3Bhz6sPDkMuisAYBu5/xgxb1kZdDex9ehC9SbTntEypDGhEw/OR3kfwTek/ppjbcz6g44hBVdqD/dJ6S7kH5QabV5YzOOqlvdjYu269/PEvgBw==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by MN2PR02MB7008.namprd02.prod.outlook.com (2603:10b6:208:201::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Sun, 20 Nov
 2022 22:55:44 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8779:9a4f:69d6:a301]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8779:9a4f:69d6:a301%7]) with mapi id 15.20.5834.015; Sun, 20 Nov 2022
 22:55:43 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, peterx@redhat.com, david@redhat.com,
        quintela@redhat.com, dgilbert@redhat.com, kvm@vger.kernel.org,
        Shivam Kumar <shivam.kumar1@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: [RFC PATCH 1/1] Dirty quota-based throttling of vcpus
Date:   Sun, 20 Nov 2022 22:54:59 +0000
Message-Id: <20221120225458.144802-2-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
In-Reply-To: <20221120225458.144802-1-shivam.kumar1@nutanix.com>
References: <20221120225458.144802-1-shivam.kumar1@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0P220CA0016.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::23) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|MN2PR02MB7008:EE_
X-MS-Office365-Filtering-Correlation-Id: 86ebcee5-82a9-4e3a-6268-08dacb4a5a39
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rwUFy0YIjOyUoudcGwvWCUTdp6vlfXuHDzgf/ip6lw/ORMIXffSmt83QTBp2gfyqunP460vSTT4/RHLuAzI7dVPFAD1cfhSgGVNL38sgF4roIKT6jlv+BWTzTymm54PS1QieDC6lAcgu2C26o8ZLi2dYXDUPIfCwgIMbFA3fp1HxHkEYjFrhlI/hxv+DBYbE0H8sqTa5CoAdCP+7lVd9GA7sFtfyPUtjMq8RLwAEe5nzWGKIG+jsRA20DsnnOfcTD740DEkLx7YD2B7TTzAUNwfGszGoHryxzpcu0bGS5uSjhWBjdJ3mDsbCPABcoLnMraa0yXcri+R/wskeEk0uHGpM8MRqsOkJ4avCVo2+jfepHMD7xBiVwHTLR10jsiY61lbSGfwOikoqdCqxs6GApx3LpeDaxDlzD4sK8zW/tzH3z6K30HzNExjE+wVGdptiCVp7deuaZlO8XAbh0ghfkchmz2/NEoRX1iPwr/XcrOcxC/zBWqP4hiHTYnqFCp3KCgJBoqVzqyWwkfPxYn/q6eQvIz6uoK+5SNIWJ3n7uf8fMcnyzhNOjOCxuIkM3ThbB2IPks+MiEG/xkTTbSAPMbbrgQqfXkhxyixJr5a7mJUKfFi6522ZAX9faPpLhC83l+qdGFovXcwRzFpkg3jKxo0YXzkPiE8WZNrtU24myZd9XZjX9cHd/b7CZleFT/f3LgfwmzJPyk+eV72EBuJlwnwP2Kc0n6FzpjibSNbuNoU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(376002)(396003)(39850400004)(136003)(451199015)(6486002)(478600001)(52116002)(6506007)(107886003)(6666004)(6512007)(26005)(38350700002)(86362001)(316002)(38100700002)(6916009)(2906002)(83380400001)(66946007)(4326008)(66476007)(8676002)(66556008)(41300700001)(54906003)(1076003)(186003)(8936002)(2616005)(36756003)(5660300002)(30864003)(15650500001)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nlXzyo3/Hq4P6iLmRXvE6Zb3L+g1S8MOLq1wQm84K8h5ZofmgvfEKAtcyrJ2?=
 =?us-ascii?Q?nbmRKgHJWnM+VAlJbvlv4d4rwbV523dyxXGx7VwILoeUyM1IC0r1CTMbZbTr?=
 =?us-ascii?Q?APW+k5GRLnIOlSBQxXRnlnJJ9YDD9K7Qhh6TuA8LmIGWa88+voRuZn8RW1Yd?=
 =?us-ascii?Q?E8jodaSH4bzwWo7zdoyyCE389SxXO9WGRiywsQPvQDvSSRHtbPKHkI9ueChn?=
 =?us-ascii?Q?Q5bCh/OB8hRkWMi+f3h6ajfOSOS0og81qvNEl1va6QRwBiD5fHHMTbZM6/Rc?=
 =?us-ascii?Q?4j0wQhVLBXDlFYU5M8BrgXa9i0AoOFcdlGhnh7aozA2xJ9PPXIFeOWhEVkGJ?=
 =?us-ascii?Q?9PuXVNqhIHA/qHIiTzO31RKTrdEZGE56K6Ml3oM0mgemzP5YFLRvBjx0qti2?=
 =?us-ascii?Q?Uw78MTepRhkLkqv5Ci0Tqs3RPbbA5OhoE/dpZmQe4zInYPQI6zERQucTxk2T?=
 =?us-ascii?Q?r4OoHABYFAZud/xQ4IO+uty4rrQ5yQy/YLUrmhQu8uiY7f7D+NmRduqkw3T1?=
 =?us-ascii?Q?pnnQvQ9iF5wxfByTwszHY+WileETAANG/EZnJ43NZtaHJMsXd0coemLf+80k?=
 =?us-ascii?Q?T64toBEqH6xoZhUcHXbTTSGU5kj+WXMbSf7nBJYUq7k5PEM3Ri81bD5XXKV8?=
 =?us-ascii?Q?ghMNQTR5toMKNHTfwxqYh35VQD4M4UzHDuGfGCVrkm7Q0aUxac2LpoDzDkI9?=
 =?us-ascii?Q?fn9tsG8ZRC5gYy7A7lyPIy9+3NZLnyZdhoRTZFH9wDbNEfLM9H4G9JvovASV?=
 =?us-ascii?Q?1XXIDyN5riRJSVX17WjdqyJTsBBGNm+U001Lsb1Xgxzg3fkPNRp4UC1GTliC?=
 =?us-ascii?Q?7ZQ0KJEbZIBTDCF8kSRMyMo/zirh9gl2SC03Wr6zfkgqNY2zIKRdCxK797aU?=
 =?us-ascii?Q?OP0bipHzANhgZw0Zb6dmE5JZQH2klRigph9XMgpM/CVnk0F3Rzs/qgEjwTus?=
 =?us-ascii?Q?HQs8nEFgQuDxpSqwANzk+xaO64xMUjQr0NqZGzumaxTfu5g3GRe9zuQbzGdV?=
 =?us-ascii?Q?HJRUclQ+n96VDalOdZK765gF5u9n7FwSmWlxPxKUlEMMlTZZL0Gxk8iMS5Vh?=
 =?us-ascii?Q?5H1WsjlHbvbpfRVcCWpUlT28yVVEboIqEBQBnLv6FR8ZTOXAePEikDkgWp+w?=
 =?us-ascii?Q?q31ix3S+jIBepjWjZ+7lqjmmuhoKkKt6vuul+i5iBwHQ1kZ/tfpIohYvVkV8?=
 =?us-ascii?Q?y5dNRV43PUcUHqcwBIgUIohsqsANLAnaU+ME2qfL1X4ku5UGYZMqG+JLAM6u?=
 =?us-ascii?Q?ugf7nEZkfNyIKJFahPAaARmQ+6XChEWO4iVQpQmq+QRTsE6dDqkZbEYsPIJZ?=
 =?us-ascii?Q?UUBmgWUI6OoSHjIgFqDuC8neN68rX4/k9RM7v6TJFGNb2UJFLdAuISHODLC7?=
 =?us-ascii?Q?AkIHmIOb1XYQW10o6loYQDXraNZCksBzyee4OT7DvXx7YYSSwYchymN765n2?=
 =?us-ascii?Q?ZVsOVM0TtggzdMApmzfozWrCzs28iMmeTcEyMYBkqXxwFMwSdNFRFmxxC00x?=
 =?us-ascii?Q?elvT61Pb2au/ZdIqAIG+Lwyi5aGXaFkui6lKSzwMN0zKnZGvyA2bFHPa2LR7?=
 =?us-ascii?Q?1BCEME7ZvhpR8lXLvBGmlAh3jLw81o6aaiChd+0OQp7bpdZ1ZsebcvtCGfmL?=
 =?us-ascii?Q?Fg=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86ebcee5-82a9-4e3a-6268-08dacb4a5a39
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2022 22:55:42.9637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZFP+XHeFJ84lfTQ7cSKHKfTsA6ltRCofy76d2uLxDC4rhaT3QRGiBh71rzyGFvpwGrNePGYbDWqiSfFGbr3FE6Pu1iCQHaMktFHaMlpa1dI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR02MB7008
X-Proofpoint-GUID: 93pBqrbYZBjQthE_HOaDW64WsQd0H_LD
X-Proofpoint-ORIG-GUID: 93pBqrbYZBjQthE_HOaDW64WsQd0H_LD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-20_13,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduces a (new) throttling scheme where QEMU defines a limit on the dirty
rate of each vcpu of the VM. This limit is enfored on the vcpus in small
intervals (dirty quota intervals) by allowing the vcpus to dirty only as many
pages in these intervals as to maintain a dirty rate below the set limit.

Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
---
 accel/kvm/kvm-all.c       | 91 +++++++++++++++++++++++++++++++++++++++
 include/exec/memory.h     |  3 ++
 include/hw/core/cpu.h     |  5 +++
 include/sysemu/kvm_int.h  |  1 +
 linux-headers/linux/kvm.h |  9 ++++
 migration/migration.c     | 22 ++++++++++
 migration/migration.h     | 31 +++++++++++++
 softmmu/memory.c          | 64 +++++++++++++++++++++++++++
 8 files changed, 226 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index f99b0becd8..ea50605592 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -46,6 +46,8 @@
 #include "sysemu/hw_accel.h"
 #include "kvm-cpus.h"
 #include "sysemu/dirtylimit.h"
+#include "hw/core/cpu.h"
+#include "migration/migration.h"
 
 #include "hw/boards.h"
 #include "monitor/stats.h"
@@ -2463,6 +2465,8 @@ static int kvm_init(MachineState *ms)
         }
     }
 
+    s->dirty_quota_supported = kvm_vm_check_extension(s, KVM_CAP_DIRTY_QUOTA);
+
     /*
      * KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 is not needed when dirty ring is
      * enabled.  More importantly, KVM_DIRTY_LOG_INITIALLY_SET will assume no
@@ -2808,6 +2812,88 @@ static void kvm_eat_signals(CPUState *cpu)
     } while (sigismember(&chkset, SIG_IPI));
 }
 
+static void handle_dirty_quota_sleep(int64_t sleep_time)
+{
+    /* Do not throttle the vcpu more than the maximum throttle. */
+    sleep_time = MIN(sleep_time,
+                        DIRTY_QUOTA_MAX_THROTTLE * DIRTY_QUOTA_INTERVAL_SIZE);
+    /* Convert sleep time from nanoseconds to microseconds. */
+    g_usleep(sleep_time / 1000);
+}
+
+static uint64_t handle_dirty_quota_exhausted(
+                    CPUState *cpu, const uint64_t count, const uint64_t quota)
+{
+    MigrationState *s = migrate_get_current();
+    uint64_t time_to_sleep;
+    int64_t unclaimed_quota;
+    int64_t dirty_quota_overflow = (count - quota);
+    uint64_t dirty_rate_limit = qatomic_read(&s->per_vcpu_dirty_rate_limit);
+    uint64_t new_quota = (dirty_rate_limit * DIRTY_QUOTA_INTERVAL_SIZE) /
+                                                        NANOSECONDS_PER_SECOND;
+    uint64_t current_time = qemu_clock_get_ns(QEMU_CLOCK_REALTIME);
+
+    /* Penalize the vCPU if it dirtied more pages than it was allowed to. */
+    if (dirty_quota_overflow > 0) {
+        time_to_sleep = (dirty_quota_overflow * NANOSECONDS_PER_SECOND) /
+                                                            dirty_rate_limit;
+        cpu->dirty_quota_expiry_time = current_time + time_to_sleep;
+        return time_to_sleep;
+    }
+
+    /*
+     * If the current dirty quota interval hasn't ended, try using common quota
+     * if it is available, else sleep.
+     */
+    current_time = qemu_clock_get_ns(QEMU_CLOCK_REALTIME);
+    if (current_time < cpu->dirty_quota_expiry_time) {
+        qemu_spin_lock(&s->common_dirty_quota_lock);
+        if (s->common_dirty_quota > 0) {
+            s->common_dirty_quota -= new_quota;
+            qemu_spin_unlock(&s->common_dirty_quota_lock);
+            cpu->kvm_run->dirty_quota = count + new_quota;
+            return 0;
+        }
+
+        qemu_spin_unlock(&s->common_dirty_quota_lock);
+        current_time = qemu_clock_get_ns(QEMU_CLOCK_REALTIME);
+        /* If common quota isn't available, sleep for the remaining interval. */
+        if (current_time < cpu->dirty_quota_expiry_time) {
+            time_to_sleep = cpu->dirty_quota_expiry_time - current_time;
+            return time_to_sleep;
+        }
+    }
+
+    /*
+     * This is a fresh dirty quota interval. If the vcpu has not claimed its
+     * quota for the previous intervals, add them to the common quota.
+     */
+    current_time = qemu_clock_get_ns(QEMU_CLOCK_REALTIME);
+    unclaimed_quota = (current_time - cpu->dirty_quota_expiry_time) *
+                        dirty_rate_limit;
+    qemu_spin_lock(&s->common_dirty_quota_lock);
+    s->common_dirty_quota += unclaimed_quota;
+    qemu_spin_unlock(&s->common_dirty_quota_lock);
+
+    /*  Allocate the vcpu this new interval's dirty quota. */
+    cpu->kvm_run->dirty_quota = count + new_quota;
+    cpu->dirty_quota_expiry_time = current_time + DIRTY_QUOTA_INTERVAL_SIZE;
+    return 0;
+}
+
+
+static void handle_kvm_exit_dirty_quota_exhausted(CPUState *cpu,
+                                    const uint64_t count, const uint64_t quota)
+{
+    uint64_t time_to_sleep;
+    do {
+        time_to_sleep = handle_dirty_quota_exhausted(cpu, count, quota);
+        if (time_to_sleep > 0) {
+            handle_dirty_quota_sleep(time_to_sleep);
+        }
+    } while (time_to_sleep != 0);
+}
+
 int kvm_cpu_exec(CPUState *cpu)
 {
     struct kvm_run *run = cpu->kvm_run;
@@ -2943,6 +3029,11 @@ int kvm_cpu_exec(CPUState *cpu)
             dirtylimit_vcpu_execute(cpu);
             ret = 0;
             break;
+        case KVM_EXIT_DIRTY_QUOTA_EXHAUSTED:
+            handle_kvm_exit_dirty_quota_exhausted(cpu,
+                    run->dirty_quota_exit.count, run->dirty_quota_exit.quota);
+            ret = 0;
+            break;
         case KVM_EXIT_SYSTEM_EVENT:
             switch (run->system_event.type) {
             case KVM_SYSTEM_EVENT_SHUTDOWN:
diff --git a/include/exec/memory.h b/include/exec/memory.h
index 91f8a2395a..becd0144a0 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -3009,6 +3009,9 @@ bool ram_block_discard_is_disabled(void);
  */
 bool ram_block_discard_is_required(void);
 
+void dirty_quota_migration_start(void);
+void dirty_quota_migration_stop(void);
+
 #endif
 
 #endif
diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index 8830546121..7c5543849a 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -36,6 +36,9 @@
 typedef int (*WriteCoreDumpFunction)(const void *buf, size_t size,
                                      void *opaque);
 
+#define DIRTY_QUOTA_INTERVAL_SIZE 10000000
+#define DIRTY_QUOTA_MAX_THROTTLE .99
+
 /**
  * SECTION:cpu
  * @section_id: QEMU-cpu
@@ -443,6 +446,8 @@ struct CPUState {
 
     /* track IOMMUs whose translations we've cached in the TCG TLB */
     GArray *iommu_notifiers;
+
+    uint64_t dirty_quota_expiry_time;
 };
 
 typedef QTAILQ_HEAD(CPUTailQ, CPUState) CPUTailQ;
diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
index 3b4adcdc10..51e3df18c7 100644
--- a/include/sysemu/kvm_int.h
+++ b/include/sysemu/kvm_int.h
@@ -110,6 +110,7 @@ struct KVMState
     struct KVMDirtyRingReaper reaper;
     NotifyVmexitOption notify_vmexit;
     uint32_t notify_window;
+    bool dirty_quota_supported; /* Whether KVM supports dirty quota or not */
 };
 
 void kvm_memory_listener_register(KVMState *s, KVMMemoryListener *kml,
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index ebdafa576d..bc1d308afd 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -272,6 +272,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_RISCV_SBI        35
 #define KVM_EXIT_RISCV_CSR        36
 #define KVM_EXIT_NOTIFY           37
+#define KVM_EXIT_DIRTY_QUOTA_EXHAUSTED 38
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -508,6 +509,11 @@ struct kvm_run {
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
@@ -529,6 +535,8 @@ struct kvm_run {
 		struct kvm_sync_regs regs;
 		char padding[SYNC_REGS_SIZE_BYTES];
 	} s;
+
+	__u64 dirty_quota;
 };
 
 /* for KVM_REGISTER_COALESCED_MMIO / KVM_UNREGISTER_COALESCED_MMIO */
@@ -1175,6 +1183,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_DISABLE_NX_HUGE_PAGES 220
 #define KVM_CAP_S390_ZPCI_OP 221
 #define KVM_CAP_S390_CPU_TOPOLOGY 222
+#define KVM_CAP_DIRTY_QUOTA 224
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/migration/migration.c b/migration/migration.c
index 739bb683f3..b94f636f08 100644
--- a/migration/migration.c
+++ b/migration/migration.c
@@ -61,6 +61,8 @@
 #include "sysemu/cpus.h"
 #include "yank_functions.h"
 #include "sysemu/qtest.h"
+#include "hw/core/cpu.h"
+#include "sysemu/kvm_int.h"
 
 #define MAX_THROTTLE  (128 << 20)      /* Migration transfer speed throttling */
 
@@ -3685,8 +3687,11 @@ static void migration_update_counters(MigrationState *s,
                                       int64_t current_time)
 {
     uint64_t transferred, transferred_pages, time_spent;
+    uint64_t pages_transferred_since_last_update, time_spent_since_last_update;
     uint64_t current_bytes; /* bytes transferred since the beginning */
     double bandwidth;
+    CPUState *cpu;
+    uint32_t nr_cpus;
 
     if (current_time < s->iteration_start_time + BUFFER_DELAY) {
         return;
@@ -3706,6 +3711,23 @@ static void migration_update_counters(MigrationState *s,
     s->pages_per_second = (double) transferred_pages /
                              (((double) time_spent / 1000.0));
 
+    if (kvm_state->dirty_quota_supported) {
+        CPU_FOREACH(cpu) {
+            nr_cpus++;
+        }
+        pages_transferred_since_last_update = transferred_pages -
+                                    s->last_counters_update.transferred_pages;
+        time_spent_since_last_update = time_spent -
+                                    s->last_counters_update.time_spent;
+        qatomic_set(&s->per_vcpu_dirty_rate_limit,
+            ((double) pages_transferred_since_last_update) /
+            (((double) time_spent_since_last_update) / 1000.0) /
+            ((double) nr_cpus));
+
+        s->last_counters_update.transferred_pages = transferred_pages;
+        s->last_counters_update.time_spent = time_spent;
+    }
+
     /*
      * if we haven't sent anything, we don't want to
      * recalculate. 10000 is a small enough number for our purposes
diff --git a/migration/migration.h b/migration/migration.h
index cdad8aceaa..66c680b81c 100644
--- a/migration/migration.h
+++ b/migration/migration.h
@@ -249,6 +249,15 @@ struct MigrationState {
     uint64_t iteration_initial_bytes;
     /* time at the start of current iteration */
     int64_t iteration_start_time;
+
+    /* state related to last migration counters update */
+    struct {
+        /* time spent from the start of iteration till the last update */
+        uint64_t time_spent;
+        /* pages already sent in the current iteration till the last update */
+        uint64_t transferred_pages;
+    } last_counters_update;
+
     /*
      * The final stage happens when the remaining data is smaller than
      * this threshold; it's calculated from the requested downtime and
@@ -373,6 +382,28 @@ struct MigrationState {
      * This save hostname when out-going migration starts
      */
     char *hostname;
+
+    /*
+     * Dirty quota throttling tries to limit the dirty rate of the guest to some
+     * factor of network throughput. This factor is dirty_quota_throttle_ratio.
+     */
+    double dirty_quota_throttle_ratio;
+
+    /*
+     * For dirty quota throttling, this is the limit on the dirty rate of the
+     * vcpus. There maybe exceptions where this limit might be enforced losely
+     * to avoid overthrottling of the vcpus.
+     */
+    uint64_t per_vcpu_dirty_rate_limit;
+
+    /*
+     * If a vcpu doesn't claim its dirty quota for a given dirty quota interval,
+     * the unclaimed quota gets added to common quota.
+     * Common dirty quota can be claimed by any vcpu which has already used its
+     * individual dirty quota for the current dirty quota interval.
+     */
+    QemuSpin common_dirty_quota_lock;
+    int64_t common_dirty_quota;
 };
 
 void migrate_set_state(int *state, int old_state, int new_state);
diff --git a/softmmu/memory.c b/softmmu/memory.c
index bc0be3f62c..8f725a9b89 100644
--- a/softmmu/memory.c
+++ b/softmmu/memory.c
@@ -12,6 +12,7 @@
  * Contributions after 2012-01-13 are licensed under the terms of the
  * GNU GPL, version 2 or (at your option) any later version.
  */
+#include <linux/kvm.h>
 
 #include "qemu/osdep.h"
 #include "qemu/log.h"
@@ -34,6 +35,10 @@
 #include "hw/boards.h"
 #include "migration/vmstate.h"
 #include "exec/address-spaces.h"
+#include "hw/core/cpu.h"
+#include "exec/target_page.h"
+#include "migration/migration.h"
+#include "sysemu/kvm_int.h"
 
 //#define DEBUG_UNASSIGNED
 
@@ -2869,6 +2874,46 @@ static unsigned int postponed_stop_flags;
 static VMChangeStateEntry *vmstate_change;
 static void memory_global_dirty_log_stop_postponed_run(void);
 
+static void init_vcpu_dirty_quota(CPUState *cpu, run_on_cpu_data arg)
+{
+    uint64_t current_time = qemu_clock_get_ns(QEMU_CLOCK_REALTIME);
+    cpu->kvm_run->dirty_quota = 1;
+    cpu->dirty_quota_expiry_time = current_time;
+}
+
+void dirty_quota_migration_start(void)
+{
+    if (!kvm_state->dirty_quota_supported) {
+        return;
+    }
+
+    MigrationState *s = migrate_get_current();
+    /* Assuming initial bandwidth to be 128 MBps. */
+    double pages_per_second = (((double) 1e9) / 8.0) /
+                                    (double) qemu_target_page_size();
+    uint32_t nr_cpus;
+    CPUState *cpu;
+
+    CPU_FOREACH(cpu) {
+        nr_cpus++;
+    }
+    /*
+     * Currently we are hardcoding this to 2. There are plans to allow the user
+     * to manually select this ratio.
+     */
+    s->dirty_quota_throttle_ratio = 2;
+    qatomic_set(&s->per_vcpu_dirty_rate_limit,
+                pages_per_second / s->dirty_quota_throttle_ratio / nr_cpus);
+
+    qemu_spin_lock(&s->common_dirty_quota_lock);
+    s->common_dirty_quota = 0;
+    qemu_spin_unlock(&s->common_dirty_quota_lock);
+
+    CPU_FOREACH(cpu) {
+        run_on_cpu(cpu, init_vcpu_dirty_quota, RUN_ON_CPU_NULL);
+    }
+}
+
 void memory_global_dirty_log_start(unsigned int flags)
 {
     unsigned int old_flags;
@@ -2891,6 +2936,7 @@ void memory_global_dirty_log_start(unsigned int flags)
     trace_global_dirty_changed(global_dirty_tracking);
 
     if (!old_flags) {
+        dirty_quota_migration_start();
         MEMORY_LISTENER_CALL_GLOBAL(log_global_start, Forward);
         memory_region_transaction_begin();
         memory_region_update_pending = true;
@@ -2898,6 +2944,23 @@ void memory_global_dirty_log_start(unsigned int flags)
     }
 }
 
+static void reset_vcpu_dirty_quota(CPUState *cpu, run_on_cpu_data arg)
+{
+    cpu->kvm_run->dirty_quota = 0;
+}
+
+void dirty_quota_migration_stop(void)
+{
+    if (!kvm_state->dirty_quota_supported) {
+        return;
+    }
+
+    CPUState *cpu;
+    CPU_FOREACH(cpu) {
+        run_on_cpu(cpu, reset_vcpu_dirty_quota, RUN_ON_CPU_NULL);
+    }
+}
+
 static void memory_global_dirty_log_do_stop(unsigned int flags)
 {
     assert(flags && !(flags & (~GLOBAL_DIRTY_MASK)));
@@ -2907,6 +2970,7 @@ static void memory_global_dirty_log_do_stop(unsigned int flags)
     trace_global_dirty_changed(global_dirty_tracking);
 
     if (!global_dirty_tracking) {
+        dirty_quota_migration_stop();
         memory_region_transaction_begin();
         memory_region_update_pending = true;
         memory_region_transaction_commit();
-- 
2.22.3

