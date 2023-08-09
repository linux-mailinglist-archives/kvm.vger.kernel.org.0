Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA08775080
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 03:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbjHIBpA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 21:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbjHIBo7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 21:44:59 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2094.outbound.protection.outlook.com [40.107.220.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A39F1982;
        Tue,  8 Aug 2023 18:44:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VdwyxeY5U9gHRkWaN5SI34MLTvlxR0VPdzE3sBCjjjvJV9e9ZsvfuPcYvKu78J6zSK5FH8m+MZLzmXvv8Ue11gv47jGkEFR2UeoyfTQwGMBhd3ZqoYA4Cm49B0BOb+bka6Iwjs0FUrkcPcZxTHs63gmsZx8qvrqMwND78/qlt97bPaBo88nHPfWjnu9c5pHz/1i/mcdcl3pPYQVilW6eu03dhXBnr7a1cPNiHWtNSwZNXU2ZYshsklQQKr99NfU0OMcRBK0NOqmSb9VS/uGJuF1qSQrrSQLQVIx0xtn6MXiOoB3aNdWqAymGvuCVb9Mb5LxLf6Ob1Csb5R7WoK5f7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v9jg819mhanbD2rclFVjTh61HzjMSpSIt9SvwBwyAwI=;
 b=Ww4IBuBRCdIcaqYNid4DJpsfTZ1PGA03MOtGJc4Kwmhggg3m1S1/DFkrxYMmfkLtPl6UVB7Yc5h18cA90NsHSFXG3PHod8TV/yE/Z+gyp8JKyAV8igqj2zkInnlXBmNIVDXyEbMxYuoyYrBnYhuu4Q/nYr12ybAavVloXc+wu4jsOc3ftVpSO/EbpnSseAHFyrlAi4AQDmDUAAJl/Dsy3e2VLNXhZBTIJgiJhLY1RXRviqYSaAB/DjBCNCnSpdLudTxpkkzikx8mzUMWsHsjqQ7qZ89mrjBuDYZeikLeoXDhBffLo4epFgHtWd1CKArGBgr1FhVAfT5t86AY7KPOnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v9jg819mhanbD2rclFVjTh61HzjMSpSIt9SvwBwyAwI=;
 b=K4mVPy2e293ndoebZgoAkSwCGyAT5dZDXWqMpqWQ/i/WOMXFhbGEBOtzg6MlsPrd495XCYlxjyt3lWJkgXoN1OkuZquWc/YR+0rN7TXSsJakzWu0K3IJhKmkGYvewI6rKu7IKxa/XJDBY9c2mxCKh5K18sq5WRpeke2iQX8hQyk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 PH0PR01MB8118.prod.exchangelabs.com (2603:10b6:510:29c::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6652.25; Wed, 9 Aug 2023 01:44:53 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::d62f:d774:15b0:4a40]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::d62f:d774:15b0:4a40%4]) with mapi id 15.20.6652.026; Wed, 9 Aug 2023
 01:44:52 +0000
From:   Huang Shijie <shijie@os.amperecomputing.com>
To:     maz@kernel.org
Cc:     oliver.upton@linux.dev, james.morse@arm.com,
        suzuki.poulose@arm.com, yuzenghui@huawei.com,
        catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com,
        peterz@infradead.org, ingo@redhat.com, acme@kernel.org,
        mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
        jolsa@kernel.org, namhyung@kernel.org, irogers@google.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, patches@amperecomputing.com,
        zwang@amperecomputing.com,
        Huang Shijie <shijie@os.amperecomputing.com>
Subject: [PATCH] perf/core: fix the bug in the event multiplexing
Date:   Wed,  9 Aug 2023 09:39:53 +0800
Message-Id: <20230809013953.7692-1-shijie@os.amperecomputing.com>
X-Mailer: git-send-email 2.39.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR08CA0013.namprd08.prod.outlook.com
 (2603:10b6:610:5a::23) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR01MB6824:EE_|PH0PR01MB8118:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a487444-e968-4013-b558-08db987a397d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tglo45JWWddTWQD06yjH232/bRukz0zfSrOACw6Coc3lqTwSvIz1Vjd/B4l/ITXxXf8WEeOdvPOc5kl7SPseJ/HLzb2wKawAXtRlKmNmBy2nt/NfLF0ZkYpKd7i2RO1FBMue7VojmUxuvJHocT9s2fswiGvGrseQ00q6anpc1kZIEelcb4zeSEDBQOadX88t4DbH5NhyLZAwVKDl56a4pB+XiYXj7p43jBzFJpmWPr6pQDpWGkT759wOBlPMtPfUR8BoCXKlNl8Vx4fkGc1mCAhQ/EOoTE717KRUCkq86W3QSr1Vx4gKa7O4N8hHLD06S+eUEGhSeSEoT4VLCHymJxxzRbZbJBdctrUca0F2tzseRRUi+gpJUm99PMqwKyfEUTEcxdWteX6gOqKE2VrB5nxXpLcmwv6FxtsJ2LhLXXSD1/zgFzGfWZivclc3NI9kpTXIXiDInt2qTkt+CVDRqoVQ/wfW334rcl3t/vJhCZ7Ynma9NcgTauZ+HCyuQrTzHZIIgzMwrGwn0V3PkZL0hbzed9W/mj+p7IN8wLAY3S7HGIHsRzKxuFqEzuW0qVBsBLyZluEzi5BOsXMP8v25jBDXkTBTrQDQQjFlgi9hiXLd/pU+TYXKIyrMaAyBDjPlkrsnR/Jf7MhKH3hPcxJCGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(396003)(366004)(39850400004)(186006)(451199021)(1800799006)(2616005)(52116002)(2906002)(86362001)(1076003)(6512007)(6486002)(478600001)(26005)(107886003)(6506007)(41300700001)(8936002)(4326008)(8676002)(66556008)(7416002)(66946007)(316002)(38350700002)(38100700002)(5660300002)(66476007)(6916009)(83380400001)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/yl5zHIoDSMhGOQiK2uyTd9uVzpe0Mqr9K+FBQubuQzSKpZbYeG9ChMZ5XLi?=
 =?us-ascii?Q?5VBT5AvNhXTsDllHj/sppide9TnMQ1FbXZwSv5lH+C4RsPbHmTyGAHvKRvY+?=
 =?us-ascii?Q?HJ6mbqZQTo59THuJbCd3GSfwRsWOVxb5EzSsE7f4UrbFYDqBbDZpA2rom24A?=
 =?us-ascii?Q?aD91vH1wNjn1GDS1qq/yQzfe5LoejYa0Gku4toudsLFoj2TwUwbb50c4pmuP?=
 =?us-ascii?Q?MHb+hAJKf51EmKH2Vh0omK8k6lQtmRVyE3BZEjy4USyVYfYUEnKjtheSg6sD?=
 =?us-ascii?Q?CSKU7Bq7QVI2Nh1hF0H9wZ2+xv87mLyhjQQf+Ifod4tyEka0W7bNecjvQO+/?=
 =?us-ascii?Q?bohN7AYbwYTRxV4Hi7IvQPw3Zif+smyFrn9gizVqFiKq/5/kAKIdi5H6KyS6?=
 =?us-ascii?Q?uexOiGMEdqubhroDW/O7eMyPb9KU3yZB7xhA2QSFk3KfurZLmD8sCmkiw4T2?=
 =?us-ascii?Q?sM9Va3BmSCnxkShPGQsFHqMCdH9F7sX+hLjntzPnfwtl0vUPtTIQJAD5Hilw?=
 =?us-ascii?Q?OKPceh1VKW4wKB0gR2O9LRm7olG1qP+5iWbWudH+UC2IcH//fjz+mAdUBQ5I?=
 =?us-ascii?Q?2PQsYA/kUrUFZPmZJ6QaiLEW7B/XmoDkFefjtg16QloMW71JtE6YabKjSUlH?=
 =?us-ascii?Q?LMy5HTjgtQ2reNvcRcE4EyUDx3wnWqHpWJRQ1q36/izW8HXXehvVSyunfyxl?=
 =?us-ascii?Q?2xuUliuipHLlJP9xKCGSjTyLRnWCxlDCPwRCeU4e/MoOVnpS5VIjmWhUdv8T?=
 =?us-ascii?Q?4dZd6YUCwpxALBdm46TqXzRaXU0CPH+H8XwmWMGhMeWRKi3ddi+o5AzDBv7H?=
 =?us-ascii?Q?uP0Pjl1MxxULJCyvjEfyYlo3jQBXBQL8GJaN//Pil3Ztu2t71uR3AFC7OgFg?=
 =?us-ascii?Q?sm+HC1FbK9G3t5n/L0doJg+oHkM/BwrepEx1bI/Hv47+ZnWHSntHKj+MceB5?=
 =?us-ascii?Q?yLVuNS8V5PX10mTxazTrM2862enPAOCIWj59CLyfzGMoL/F1+/clxIX7bUrc?=
 =?us-ascii?Q?ZrCD14ziBr1AnToqSo/RwrZtEUvAMmfzgJ4gNGFUC1VTeoCB31fZFG64cKIr?=
 =?us-ascii?Q?AHUVNAPoSInlaENzAY0AYBJuIDQiKUw2l4Pi2phzDe+1Har67Qegmua6sQMR?=
 =?us-ascii?Q?Wa2N/v2pgdwWalJ2aZmf8q5H18ay2zZWsqPWAbMo68b9dvO9iGgcNIdqZjY+?=
 =?us-ascii?Q?Y3rRpaDi9/Y5Jy+0EBTNTCRL1jKwzjrwBqFpvVp/ACFgW3KsaDYQQYCVFoCA?=
 =?us-ascii?Q?HKyAD3toGj774eDxPl70pCi7X1UnBsXAAtP2N/qSIJ6XFgFAeeJy3efyHLF4?=
 =?us-ascii?Q?XDn9YYLywzCYZmu6bixS6iQWlb20U+0EFsJ1uIlL2KDAzO9AnXaqr9lfE5dj?=
 =?us-ascii?Q?4GWmN5J7Fs0SxudjKy+jcmJky6xQtTwlhbFT3vGMjtZDH7PyBJydynna0UtM?=
 =?us-ascii?Q?T8ydmzMjVBrb0KuKtUuh7Sj7yEMnz7qzxLK86j0nh082qZZtaOeR7NhLDz42?=
 =?us-ascii?Q?kyDztckT2/ICs13fSqJ+skGfdyi8WCo7KH52EVkoVlvSABAdaWtcJeVW8P3N?=
 =?us-ascii?Q?bng5edOeQnBSRXXy8DFblkNBVM6RDAz+KlgFe005f9LWofI97sKwZ4IenqP4?=
 =?us-ascii?Q?iBYu18zJCkZaoPBT9qlGaUQ=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a487444-e968-4013-b558-08db987a397d
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2023 01:44:52.7626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3cA2jnJxtuh0IGxpxwcF9Vj8PMFbV4wo4NiBNS9cnq5cQlrAAFmGshitJ2gb7I/7cRJfbiKrBhzrfHLlaR2cqx+ME+ppQB3i/YlZyf2oFcP0b9oUfIFNzRUcr5N0SULc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB8118
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

1.) Background.
   1.1) In arm64, run a virtual guest with Qemu, and bind the guest
        to core 33 and run program "a" in guest.
        The code of "a" shows below:
   	----------------------------------------------------------
		#include <stdio.h>

		int main()
		{
			unsigned long i = 0;

			for (;;) {
				i++;
			}

			printf("i:%ld\n", i);
			return 0;
		}
   	----------------------------------------------------------

   1.2) Use the following perf command in host:
      #perf stat -e cycles:G,cycles:H -C 33 -I 1000 sleep 1
          #           time             counts unit events
               1.000817400      3,299,471,572      cycles:G
               1.000817400          3,240,586      cycles:H

       This result is correct, my cpu's frequency is 3.3G.

   1.3) Use the following perf command in host:
      #perf stat -e cycles:G,cycles:H -C 33 -d -d  -I 1000 sleep 1
            time             counts unit events
     1.000831480        153,634,097      cycles:G                                                                (70.03%)
     1.000831480      3,147,940,599      cycles:H                                                                (70.03%)
     1.000831480      1,143,598,527      L1-dcache-loads                                                         (70.03%)
     1.000831480              9,986      L1-dcache-load-misses            #    0.00% of all L1-dcache accesses   (70.03%)
     1.000831480    <not supported>      LLC-loads
     1.000831480    <not supported>      LLC-load-misses
     1.000831480        580,887,696      L1-icache-loads                                                         (70.03%)
     1.000831480             77,855      L1-icache-load-misses            #    0.01% of all L1-icache accesses   (70.03%)
     1.000831480      6,112,224,612      dTLB-loads                                                              (70.03%)
     1.000831480             16,222      dTLB-load-misses                 #    0.00% of all dTLB cache accesses  (69.94%)
     1.000831480        590,015,996      iTLB-loads                                                              (59.95%)
     1.000831480                505      iTLB-load-misses                 #    0.00% of all iTLB cache accesses  (59.95%)

       This result is wrong. The "cycle:G" should be nearly 3.3G.

2.) Root cause.
	There is only 7 counters in my arm64 platform:
	  (one cycle counter) + (6 normal counters)

	In 1.3 above, we will use 10 event counters.
	Since we only have 7 counters, the perf core will trigger
       	event multiplexing in hrtimer:
	     merge_sched_in() -->perf_mux_hrtimer_restart() -->
	     perf_rotate_context().

       In the perf_rotate_context(), it does not restore some PMU registers
       as context_switch() does.  In context_switch():
             kvm_sched_in()  --> kvm_vcpu_pmu_restore_guest()
             kvm_sched_out() --> kvm_vcpu_pmu_restore_host()

       So we got wrong result.

3.) About this patch.
        3.1) Add arch_perf_rotate_pmu_set()
        3.2) Add is_guest().
	     Check the context for hrtimer.
	3.3) In arm64's arch_perf_rotate_pmu_set(),
       	     set the PMU registers by the context.

4.) Test result of this patch:
      #perf stat -e cycles:G,cycles:H -C 33 -d -d  -I 1000 sleep 1
            time             counts unit events
     1.000817360      3,297,898,244      cycles:G                                                                (70.03%)
     1.000817360          2,719,941      cycles:H                                                                (70.03%)
     1.000817360            883,764      L1-dcache-loads                                                         (70.03%)
     1.000817360             17,517      L1-dcache-load-misses            #    1.98% of all L1-dcache accesses   (70.03%)
     1.000817360    <not supported>      LLC-loads
     1.000817360    <not supported>      LLC-load-misses
     1.000817360          1,033,816      L1-icache-loads                                                         (70.03%)
     1.000817360            103,839      L1-icache-load-misses            #   10.04% of all L1-icache accesses   (70.03%)
     1.000817360            982,401      dTLB-loads                                                              (70.03%)
     1.000817360             28,272      dTLB-load-misses                 #    2.88% of all dTLB cache accesses  (69.94%)
     1.000817360            972,072      iTLB-loads                                                              (59.95%)
     1.000817360                772      iTLB-load-misses                 #    0.08% of all iTLB cache accesses  (59.95%)

    The result is correct. The "cycle:G" is nearly 3.3G now.

Signed-off-by: Huang Shijie <shijie@os.amperecomputing.com>
---
 arch/arm64/kvm/pmu.c     | 8 ++++++++
 include/linux/kvm_host.h | 1 +
 kernel/events/core.c     | 5 +++++
 virt/kvm/kvm_main.c      | 9 +++++++++
 4 files changed, 23 insertions(+)

diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 121f1a14c829..a6815c3f0c4e 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -210,6 +210,14 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu)
 	kvm_vcpu_pmu_disable_el0(events_guest);
 }
 
+void arch_perf_rotate_pmu_set(void)
+{
+	if (is_guest())
+		kvm_vcpu_pmu_restore_guest(NULL);
+	else
+		kvm_vcpu_pmu_restore_host(NULL);
+}
+
 /*
  * With VHE, keep track of the PMUSERENR_EL0 value for the host EL0 on the pCPU
  * where PMUSERENR_EL0 for the guest is loaded, since PMUSERENR_EL0 is switched
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9d3ac7720da9..e350cbc8190f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -931,6 +931,7 @@ void kvm_destroy_vcpus(struct kvm *kvm);
 
 void vcpu_load(struct kvm_vcpu *vcpu);
 void vcpu_put(struct kvm_vcpu *vcpu);
+bool is_guest(void);
 
 #ifdef __KVM_HAVE_IOAPIC
 void kvm_arch_post_irq_ack_notifier_list_update(struct kvm *kvm);
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 6fd9272eec6e..fe78f9d17eba 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4229,6 +4229,10 @@ ctx_event_to_rotate(struct perf_event_pmu_context *pmu_ctx)
 	return event;
 }
 
+void __weak arch_perf_rotate_pmu_set(void)
+{
+}
+
 static bool perf_rotate_context(struct perf_cpu_pmu_context *cpc)
 {
 	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
@@ -4282,6 +4286,7 @@ static bool perf_rotate_context(struct perf_cpu_pmu_context *cpc)
 	if (task_event || (task_epc && cpu_event))
 		__pmu_ctx_sched_in(task_epc->ctx, pmu);
 
+	arch_perf_rotate_pmu_set();
 	perf_pmu_enable(pmu);
 	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index dfbaafbe3a00..a77d336552be 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -218,6 +218,15 @@ void vcpu_load(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(vcpu_load);
 
+/* Do we in the guest? */
+bool is_guest(void)
+{
+	struct kvm_vcpu *vcpu;
+
+	vcpu = __this_cpu_read(kvm_running_vcpu);
+	return !!vcpu;
+}
+
 void vcpu_put(struct kvm_vcpu *vcpu)
 {
 	preempt_disable();
-- 
2.39.2

