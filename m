Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4001777AFE4
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 05:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232638AbjHNDLf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Aug 2023 23:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbjHNDL3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Aug 2023 23:11:29 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2138.outbound.protection.outlook.com [40.107.237.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA04A6;
        Sun, 13 Aug 2023 20:11:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j2jE3e3MdBKY+o4xbnV/CKGp+tKhUWF3+/AHOaO66Fe6/GCbUEnCVk8G4/6ZFsLBW5sDMhSkOUD2TJ3azcbayJrk0pSzYELe2bpnsWqVYfKHTGdyAr75k364cN/S/L1SJPsegTUiR5i2ieUlEUtGw92VQ5Rhh+A5UJnEvT8bz5wuzdOJ65ayd/w5C76Re5a641eXeEgMH1UQx6vwofrR3uEyy2ZeP01VmSzEtWTzoqrUmWpXatJoSZMYR2nBRSIAtLlykXm0QBxEYN9k1WHTSpSRVN+Y2TcOnZABPETk6R8sZr/YbJ1/2CM/GrOCcaWbeX+UcgzHDwWl73e0rppVQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mRDzB3aExq86YiQZ0pvp3QAv6QJHLKcJnBjY+XMJ5cE=;
 b=fOXM8rW/sPQdVbwqFmkSG85NgiZOvxYb1gdkX/PrrqaxZ5I5K7rwsiCEVxh+0vBa2g4G7LKIwJbYjtHVuExuDEjF/PIxGwgApVtuqqtbJs3vydrIaleneD/4YQ2fonJY6+hL517s4oicKP/1N6WePIiipCE3q/vNwb4Pdw3FpYQOqqaU7RINA+x+j4as7pFeVizRv2THmwjuH5n1qliFx5MqJW4Y2SHbZNbVDSmftRDgRnCmNdP6sBV/nMwA68b/evRt12dI0Mi0wfFrCcBcIyEqykq2jo1e576NoulXC+jYPscHmCHwKLNgY+OgMkhosBC606LI436Uq7lWcEKm+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mRDzB3aExq86YiQZ0pvp3QAv6QJHLKcJnBjY+XMJ5cE=;
 b=U8DbK9eRYcXVl5hLxROjhzdWF/t7tc34p4QPCjti10/tHUVAe082r2wWwZl74ujufFIrEfa1zA8AcbKNke79oWzjK25n1wkCIGoaqRoCSR5StGstStWjdI2bWd4lEy4SYlULM1V8Vldtrggxz4R6rpYvP0lMxbQ+3dd20agMXXc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 PH0PR01MB6501.prod.exchangelabs.com (2603:10b6:510:15::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6678.24; Mon, 14 Aug 2023 03:11:21 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::d62f:d774:15b0:4a40]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::d62f:d774:15b0:4a40%4]) with mapi id 15.20.6678.022; Mon, 14 Aug 2023
 03:11:21 +0000
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
Subject: [PATCH v3] KVM:arm64: reconfigurate the event filters for guest context
Date:   Mon, 14 Aug 2023 11:06:45 +0800
Message-Id: <20230814030645.11632-1-shijie@os.amperecomputing.com>
X-Mailer: git-send-email 2.39.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0118.namprd04.prod.outlook.com
 (2603:10b6:610:75::33) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR01MB6824:EE_|PH0PR01MB6501:EE_
X-MS-Office365-Filtering-Correlation-Id: a5f92c55-15d5-4890-c9be-08db9c742233
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 46UedWsdpBUlkwlLw0OWEa0VsFiQaerf8H9r1t8/zzriQpACKAGV/rg7wGrkQ8DbawoV9ybqObzBPqJr8HQGDP/BFsK+yZCF2TQLa3fqbmihcqJctBq48628mvzsTsvT1sTHypJ+/lD3Ocj7oqfGRHeA2D/3hyPnToS3YEpc84GAhKa8nrEK/uoV3ml7mALdYIYugVg5cHJUhgTrx6iZOjNwoo48iDflxenHbS662ih2Gc/A4unD4RbJoomAhma2+pwu2X4AKggPd0dAhO3gtddCvOi70e2KrtdoZLyn/F48rTowh3qO62DMPc4T8EQeo+LaeDEzqK39BHLsgIam8b8sHkn3a78KOlKKd2h0kpxI1mHBpxEWQutg16jm0qUnTRBz/cuzv4gbEtRYNzX/ITXd8GV/MkfeMWP+RpfuYGPxwQYjWdsyvbnlZKrxRwYCqOZm3kds+gy07kShQFn3UrUpmyLNQA/JYbzg4TH3cZScA6jgpIawjjbEOckNaKWJlTHpknLaDXaEQ1/2RkzGaMXfhqXBwpOZsW/zOz+iFK/ZA9cP8J/3KgcHHEwGRLfEbDpVCF3jnG1Hi74dNTElaemIMW8J6dkJhdXmkVisPm4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(39840400004)(346002)(376002)(136003)(396003)(366004)(186006)(1800799006)(451199021)(6512007)(6486002)(6666004)(52116002)(966005)(86362001)(38350700002)(38100700002)(83380400001)(26005)(6506007)(107886003)(1076003)(2906002)(478600001)(2616005)(8676002)(66556008)(66476007)(8936002)(5660300002)(7416002)(41300700001)(66946007)(316002)(4326008)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MSUAMzOsYMA2frSXAk91pODPzEBTPYbpRoBQi46UwbstKFQnOGORqDUw1ryJ?=
 =?us-ascii?Q?5Rp6LFz/0O3IsdvTPfPhxrpHrXH3JYjYkD0VIg+ffo3RGT3CSA/3VegcnCiQ?=
 =?us-ascii?Q?+aPlLotyEAA5KH/vf5KMIPyTJ0LYwGpEd7ReoDAKgQhHpSDlljhbXkIjGy2J?=
 =?us-ascii?Q?F704xtEIqF11EG6CO7etAbIsvlhYkfJYgtgFtz2TQSm2VvdSyJ6FkPzkMP80?=
 =?us-ascii?Q?Lfongfibx2dCdiCV084sae8B6qc1ko1RFID47Y37epDuQ3/ftPIi2KoOYKoz?=
 =?us-ascii?Q?VQ80d0OJz1GmthZdx5xSoue8zB4NijjOR4CusYFLrk9tNupdaVtIcdXYkg5C?=
 =?us-ascii?Q?8d5s7XieHdlAmdl8B9caOCWRELNopZrGGvECAAgwkvIQZ83xbEN2BQ+27cmY?=
 =?us-ascii?Q?LlCsuIWtikJoZJHAxKLnJblkMFEuMes2iRFWt0Ym3ULEwlNEpr/mYS7+QdmS?=
 =?us-ascii?Q?HSc8B4OTQ2UoxQ6xslZRIBvzSKGJlZQQdcn0ZXF7REg65OIgr4szCfhgSWHP?=
 =?us-ascii?Q?r45MeD+aQ3O3euqQ00pFiRJn/8ZUucWGy5vxw8CFyqXEc4J12pdElb5MXBkG?=
 =?us-ascii?Q?QURK9+JPRzfZ9c70XhDMhAirNWJdxx9UwTomEsRizZuszPCmf049q27r7vZS?=
 =?us-ascii?Q?3ZBlc2Crpk2a2qBzBCT4aywinEzvt6mFAChLffUKUHhSJ7wiykdQv1InANWI?=
 =?us-ascii?Q?LH3jXydIOKA7tcojh3bfCE54d2iqNZm4FG32PAAhB8XlZjAveWBsNxLlwKbg?=
 =?us-ascii?Q?icWHBbk4Odwf8eUdPHHS5zGE9MiWip9iHhdzhAf8yHs3JN0EgQkN1KZKtFdR?=
 =?us-ascii?Q?tmceJb7KYq25nWmrDwzMKxPBPAJF8dm8L1j2sDdm5lCHSrtPgo8MnoJvwdzA?=
 =?us-ascii?Q?LIkTCrpcH4ghzfCFHbbaOaoqYdr4vwaGR/Sx7kpHjIbiOq1ozCLPkh4LafOO?=
 =?us-ascii?Q?Nn5/y27gh5ijtkjN5adGko7wlvWGBFCag9fcyDia2wXZij+4rSVMt2CLKmaa?=
 =?us-ascii?Q?Zbsnqfe03zCWkB/WpZMiMfYS8WpwPzAqe5pto+EH/jnX6WnlOS+Hvu3M/0oh?=
 =?us-ascii?Q?613ztd9WgMaCo9H8ybGDYQUTJbsCpWdw2n75f6TYi6mnBjZcn6WaNuBLnCIJ?=
 =?us-ascii?Q?ybdDzOrzChySsIp2DKcc4AL7BIkKyaE+dbRd14HEPW6LLBDmgo2gb83Q5CED?=
 =?us-ascii?Q?qYSnuUG+llYpXeJzzom8F3JtRyyBvwF/0U8l3kSiS0LQu+NZUzgF/yKrvKyL?=
 =?us-ascii?Q?mTR+9ViiKZhdHRDENiCFLf6GV80FDd6tQpWAT/sU/pH2bGvYdK0N9SfjPatW?=
 =?us-ascii?Q?A0gkhLnY5Oqv2ImaDQE1nn/KvfTIQsBwDB9WIS9n7SuoX57u0/iLo0MomOa/?=
 =?us-ascii?Q?E+eAa+Hc0tnlcIF9QRAXYCp6VqyrwxPdQLC1gJyREHbcExdeqH8UC6T0kOMT?=
 =?us-ascii?Q?4wckoDEV7yKgLqDx55QXUQjMzu2Y6ggz/Iv/hts/w85j7tZv8m7WeMRMbqu5?=
 =?us-ascii?Q?51QJPujJHXvCVezjT/3cJZkokR7njazxigfjij07AKSLkNdqxdiClfnxurqw?=
 =?us-ascii?Q?UxleNf7WcDEOsAktpFBVInEuv8eCCmfYOKC2TZVVe64mBVW3R9doWr8MTKVH?=
 =?us-ascii?Q?3KnxtdfiOrYOkpyh5SAe8Sc=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5f92c55-15d5-4890-c9be-08db9c742233
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2023 03:11:21.5751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pC5O0TbSpMjRlha7tR6Q/l8R+eyN/XCPb4yT7k0V1ZZWk+acNaoj3lJpBplLk0G8OApDXYH+EMR4xpmvbexEtyRaAZIU9/Ghg95lx7QCeNv7oJZKjS8NSRLfQjirrtFJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB6501
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

1.) Background.
   1.1) In arm64, start a guest with Qemu which is running as a VMM of KVM,
        and bind the guest to core 33 and run program "a" in guest.
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
       	multiplexing in hrtimer:
	     perf_mux_hrtimer_restart() --> perf_rotate_context().

       If the hrtimer occurs when the host is running, it's fine.
       If the hrtimer occurs when the guest is running,
       the perf_rotate_context() will program the PMU with filters for
       host context. The KVM does not have a chance to restore
       PMU registers with kvm_vcpu_pmu_restore_guest().
       The PMU does not work correctly, so we got wrong result.

3.) About this patch.
	3.1) Add a week arch_perf_mux() for perf_mux_hrtimer_handler().
        3.2) In the arm64, implement the arch_perf_mux().
		Make a KVM_REQ_PMU_RESTORE_GUEST request if the
		perf multiplexing occurs in the guest context.

4.) Test result of this patch:
      #perf stat -e cycles:G,cycles:H -C 33 -d -d  -I 1000 sleep 1
            time             counts unit events
     1.001006400      3,298,348,656      cycles:G                                                                (70.03%)
     1.001006400          3,144,532      cycles:H                                                                (70.03%)
     1.001006400            941,149      L1-dcache-loads                                                         (70.03%)
     1.001006400             17,937      L1-dcache-load-misses            #    1.91% of all L1-dcache accesses   (70.03%)
     1.001006400    <not supported>      LLC-loads
     1.001006400    <not supported>      LLC-load-misses
     1.001006400          1,101,889      L1-icache-loads                                                         (70.03%)
     1.001006400            121,638      L1-icache-load-misses            #   11.04% of all L1-icache accesses   (70.03%)
     1.001006400          1,031,228      dTLB-loads                                                              (70.03%)
     1.001006400             26,952      dTLB-load-misses                 #    2.61% of all dTLB cache accesses  (69.93%)
     1.001006400          1,030,678      iTLB-loads                                                              (59.94%)
     1.001006400                338      iTLB-load-misses                 #    0.03% of all iTLB cache accesses  (59.94%)

    The result is correct. The "cycle:G" is nearly 3.3G now.

Signed-off-by: Huang Shijie <shijie@os.amperecomputing.com>
---

v1 --> v2:
	Do not change perf/core code, only change the ARM64 kvm code.
	v1: https://lkml.org/lkml/2023/8/8/1465

v2 --> v3:
	Disdurb the perf/core again.
	v2:http://lists.infradead.org/pipermail/linux-arm-kernel/2023-August/858427.html

---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/arm.c              | 18 ++++++++++++++++++
 include/linux/perf_event.h        |  2 ++
 kernel/events/core.c              |  5 +++++
 4 files changed, 26 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8b6096753740..151810445d79 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -49,6 +49,7 @@
 #define KVM_REQ_RELOAD_GICv4	KVM_ARCH_REQ(4)
 #define KVM_REQ_RELOAD_PMU	KVM_ARCH_REQ(5)
 #define KVM_REQ_SUSPEND		KVM_ARCH_REQ(6)
+#define KVM_REQ_PMU_RESTORE_GUEST	KVM_ARCH_REQ(7)
 
 #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
 				     KVM_DIRTY_LOG_INITIALLY_SET)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c2c14059f6a8..53d6555912d1 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -792,6 +792,9 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 			preempt_enable();
 		}
 
+		if (kvm_check_request(KVM_REQ_PMU_RESTORE_GUEST, vcpu))
+			kvm_vcpu_pmu_restore_guest(vcpu);
+
 		if (kvm_check_request(KVM_REQ_RELOAD_PMU, vcpu))
 			kvm_pmu_handle_pmcr(vcpu,
 					    __vcpu_sys_reg(vcpu, PMCR_EL0));
@@ -878,6 +881,21 @@ static int noinstr kvm_arm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+void arch_perf_mux(bool rotations)
+{
+	struct kvm_vcpu *vcpu;
+
+	if (!kvm_arm_support_pmu_v3() || !has_vhe())
+		return;
+
+	vcpu = kvm_get_running_vcpu();
+	if (!vcpu)
+		return;
+
+	if (rotations)
+		kvm_make_request(KVM_REQ_PMU_RESTORE_GUEST, vcpu);
+}
+
 /**
  * kvm_arch_vcpu_ioctl_run - the main VCPU run function to execute guest code
  * @vcpu:	The VCPU pointer
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 2166a69e3bf2..07ef1aa00226 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1860,6 +1860,8 @@ extern void arch_perf_update_userpage(struct perf_event *event,
 				      struct perf_event_mmap_page *userpg,
 				      u64 now);
 
+extern void arch_perf_mux(bool rotations);
+
 #ifdef CONFIG_MMU
 extern __weak u64 arch_perf_get_page_size(struct mm_struct *mm, unsigned long addr);
 #endif
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 6fd9272eec6e..eefb28198dd1 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1059,6 +1059,10 @@ static void perf_cgroup_switch(struct task_struct *task)
 }
 #endif
 
+void __weak arch_perf_mux(bool rotations)
+{
+}
+
 /*
  * set default to be dependent on timer tick just
  * like original code
@@ -1076,6 +1080,7 @@ static enum hrtimer_restart perf_mux_hrtimer_handler(struct hrtimer *hr)
 
 	cpc = container_of(hr, struct perf_cpu_pmu_context, hrtimer);
 	rotations = perf_rotate_context(cpc);
+	arch_perf_mux(rotations);
 
 	raw_spin_lock(&cpc->hrtimer_lock);
 	if (rotations)
-- 
2.39.2

