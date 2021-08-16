Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE5B3ED774
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 15:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240897AbhHPNdX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 09:33:23 -0400
Received: from mail-sn1anam02on2088.outbound.protection.outlook.com ([40.107.96.88]:24423
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240814AbhHPNbV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Aug 2021 09:31:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bN0SKOCjHILsG+Jz8RS3t0DZ5KSDAu1C1sRPmnbglla9mxaDdPEVpfLnp8HF1t0IBxMXxL4Pxczmxl5AYqo4sPQzWMpOYA31GjXN7Ujhv5AF7FQiiCUeCVmkgKGxclHnSJ4p+WNEbNQBk/LX9elVlDdoK9bYDhGhRIhQ2pu+TThfvcPKt55w11Ev1u1cG0EALpSZMYFwCdKrt/tGyPnAXVvQtrrwC4BJgLCx04+ZRuqtWWp0fN0PfbnjGQtcat2Ghli3orJGLe4SnLXKybux8pLZa+tMhuCnBqPk6SvDAEQVZSv66Hm/luxQNiWPY0lB2ALB0xkqHDB3qnZ3DnNpig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6NJHWFPiiOTXqSt1X8LsG79mN4N7qjiz7VOq14pKaks=;
 b=F0yXCThnXO3bKz4Z0CJNI4e71bgkVujrlydRpC/unwbSywcTyT+7ck89s148edcMx1Z7MPA6Y6mP0f/xr/+6+gxl5qfQvDkTkmGFr4x1YEX5Dp+ZsolEpqaycsFqnF4Hoc4jQyZrdohAgiI/6BMbnHCvtLJS/0qdk8695gZyIRzJ19DqsfQ1p8ltpkw8p3UBoTBxAH5ZWKkmT8LWDvxNnrLuKOCYn7qTFUiahLFKNWzCVhyuC8UkRnUDnOBTHa+m37oUJokF1t2OQCcuED2n3qZX8EHTX2JBhTKcuWeJzCxiEgo7c3oeqFbg29AD/YgIAC4dFcEC/fPYpz4ebFKOTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6NJHWFPiiOTXqSt1X8LsG79mN4N7qjiz7VOq14pKaks=;
 b=ahcMhiB+bV3MJUjHMV49ADNZEY9hOf+6vyCHMqjXtqnlbAF4aJOjAptVMJEd+KzQzj8mz/gu8CB6S7BAkFelY2Ibxhj+k03SH4XRkw8ZN/SCkqLTR/XQWPEYBmGAkJWUdJ8pamXYgEkIbM6kidCs3Wx0FLQ5VxXxfrO4bCDm1pA=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4495.namprd12.prod.outlook.com (2603:10b6:806:70::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Mon, 16 Aug
 2021 13:30:47 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73%7]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 13:30:47 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, ehabkost@redhat.com, mst@redhat.com,
        richard.henderson@linaro.org, jejb@linux.ibm.com, tobin@ibm.com,
        dovmurik@linux.vnet.ibm.com, frankeh@us.ibm.com,
        dgilbert@redhat.com, kvm@vger.kernel.org
Subject: [RFC PATCH 10/13] softmmu/cpu: Skip mirror vcpu's for pause, resume and synchronization.
Date:   Mon, 16 Aug 2021 13:30:36 +0000
Message-Id: <0b59d867e10238ff683c5724c71b471f4b683449.1629118207.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1629118207.git.ashish.kalra@amd.com>
References: <cover.1629118207.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0070.namprd11.prod.outlook.com
 (2603:10b6:806:d2::15) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA0PR11CA0070.namprd11.prod.outlook.com (2603:10b6:806:d2::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16 via Frontend Transport; Mon, 16 Aug 2021 13:30:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60703fe5-4bc5-4c12-adcf-08d960ba0e9d
X-MS-TrafficTypeDiagnostic: SA0PR12MB4495:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44957F40B3A28376F30B1D788EFD9@SA0PR12MB4495.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:962;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WKF+rM/8jY0GGReULcTQvcvcLcWEApH7S5Rud172VThM0/8kSqCe939gQ4FXWKxlrnp6D4tBaHNRQVCGnKE+TbSMDBzzRJe0t3NgAj0UCsTh6f8ri+zC+qhSrnZ1CibobGhrmLb1Z0mZsvYxyqd8qVLr+H/u4iUhn8msdkx+TaiadEgiQmux8SOynKechXNOLt6OtAeK5rZGHMI2FuIqhI4csfmtohd4WgDNzGa+CgeUEAk28XqRhe0+v5A/t+r+p0x3fWyP64zDF47hOIYVIzioNh7NPS55eBT4jLG1dskp5RrUdODuXnaUdL+M4oC9W5UoNsC++qyyaQDwoiIykbkGG9QuE82wpJ1stUe5r4PmB1+xPdE3S1u4OZPD246zsdZc2lZ8CrFs9EYzDYnpug4artcXoWwY1j78Tr+/xpZfYAEyW3TJ2Nf/sX3hONPIEizBkStAYxlT56/cCWV0wWIdBAiLLymb0cD20ZISqAmM3lHaXvTnsU98OVbSUm6veSxYVlQ7cVJLIhq1Wmf/Y4tQmler10G21cvnc2uiyzKyxTa8yYifxWl/mVA8b+fEiNCpVH+8+8XkzU+O+7+ZzFq12vfuy1yzuaS+8HW7a+LyhxU++7fCpQ6Gs4xUgJcLxybr8+EVUO0f9ogN+2BXYszwIYF8P4B8lLnNsAPw6S2kisJersmV32owcw7K9VjBSF/N0uK/B9eTVJmSqKV9/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(346002)(366004)(136003)(38350700002)(38100700002)(6486002)(6916009)(478600001)(26005)(7416002)(36756003)(8936002)(8676002)(2906002)(5660300002)(86362001)(7696005)(52116002)(6666004)(66946007)(66476007)(316002)(4326008)(83380400001)(956004)(186003)(2616005)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HcTwX3gv4zf5uqh/gp+5hTvimZSZ0z9KHHhnp1y5JYDpLqWWd5L7nzHPzHnC?=
 =?us-ascii?Q?CjG3k2hkn6W19nhXJ97xG0Tvj8Zd2KiZBmsK0JGuMKJ5pO4Hs9B0JijHSlZe?=
 =?us-ascii?Q?shjzH+a2k/+/P93OMayLoZJLQ+7isXzfZjyc1eb6I9xO3y3UfwDdnXUpeZTn?=
 =?us-ascii?Q?wqp4jmMp6g0f8a5/Zd63FxOOD6gPM7pXB51wm4nxUT/ylfdjGF9JcoUzfH3u?=
 =?us-ascii?Q?W/uDqdkg6OcpQCh+oYZxPWHmWrNlYFjoYwpot0xPLaOmXKcgGIh+PewrCVyN?=
 =?us-ascii?Q?8pUMQ5/M/RlePUxeaWFIJokRxRPiNkEUvSJubliirBDKjlckMANogGyEUZti?=
 =?us-ascii?Q?xbpnEu/gH4BZkeI9QWWBr27KItULRHnNuiAy7lVHXGHJ6HaZCqzTmutAZ1I6?=
 =?us-ascii?Q?UKBRJ9SAfp2Vw1dvucBy62sHqToRBi7upceRFGjrwOr/2KbjrbUltDkNjEea?=
 =?us-ascii?Q?riyyPJkeSfJBg+9PTO7Gua2uZWu5Z2RhSAFXWlfUQ51SH+CXJZ+vzUCmzThS?=
 =?us-ascii?Q?Mb2+wOswOCtGClGygB4D4Cg0hTd090IZnF4Z+OKKzjTMG8XOUUF73JPC5K8G?=
 =?us-ascii?Q?UmDwVZHG4gNAWn4aHsGlHmUZcqj5Td6HGvooQC0dDeg/JiqgRCVUpRFtnXTN?=
 =?us-ascii?Q?qlzbrNlChZKqZcjJ0oodTONXyIG3fNaBEZ0MHeQs0ypWbfumHq6eQVsbQUAr?=
 =?us-ascii?Q?DgCAGkZbEsPgOutIR5touZRKdn44ChyyeNCaZnIgjscztwTxKVz78g/K5djO?=
 =?us-ascii?Q?Vv5qGGi5bTZ7npJb8wLCb8GzdslNXoelBIWEPDfpNa277Yioje98v55IM5QR?=
 =?us-ascii?Q?IYbFrIerFsj3ABAXXoAdQ8PBbLH4NDv1/eBFK3bRSYjI/frCC7OqvPo4OJKj?=
 =?us-ascii?Q?vCaa8UiBFqPw0oLB/vPO6J/XFYY4bQcXwapM+iZij6VDmrjjg6MYZYpXhmr0?=
 =?us-ascii?Q?f5EvgnenLduhIIwqJvOyjmvo1J9H/SsuUhJoGDMzPQzJdqEriACGjkmxaWBs?=
 =?us-ascii?Q?7+R/HihdUIF/iNFJ8wmvYj42dAOfFmNwT2Vh+dxg6J1BDJcuFBZtUl8NY9Qs?=
 =?us-ascii?Q?41Z67pyv1LPpeYnpEzIoCIztpmcC6n0sKxbPp3zo1PQIgPxgsbAv82t1/D7C?=
 =?us-ascii?Q?Ey00xYPkgsuTTNnFbsN+ecEChytAp0oej3nkmHk6xpkIMvpRbgeFy5+5C9rq?=
 =?us-ascii?Q?CKcJuWLuA7kMYygyLf/IkfHB6hFneOTbOVNsCSl7Hz6xqe9CMnxO57rA+cWA?=
 =?us-ascii?Q?EDjfKwFsNbPehBANgurzM6RfSRM/tHNqGQM/9BUCVExNYr2AwHkyLxg12jzK?=
 =?us-ascii?Q?E1wfwcR9Um5qM2ZEsz/fHyF6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60703fe5-4bc5-4c12-adcf-08d960ba0e9d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2021 13:30:47.6933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MOHNv1tv0EQyVoc7JGFinVuJYWIKNumrRcen6xSrrrsky1I2YtACvwjSqaafaXuGVpHEUNoUpxKZG0NJFaBKdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4495
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Skip mirror vcpus's for vcpu pause, resume and synchronization
operations.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 softmmu/cpus.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/softmmu/cpus.c b/softmmu/cpus.c
index 071085f840..caed382669 100644
--- a/softmmu/cpus.c
+++ b/softmmu/cpus.c
@@ -101,6 +101,9 @@ bool all_cpu_threads_idle(void)
     CPUState *cpu;
 
     CPU_FOREACH(cpu) {
+        if (cpu->mirror_vcpu) {
+            continue;
+        }
         if (!cpu_thread_is_idle(cpu)) {
             return false;
         }
@@ -136,6 +139,9 @@ void cpu_synchronize_all_states(void)
     CPUState *cpu;
 
     CPU_FOREACH(cpu) {
+        if (cpu->mirror_vcpu) {
+            continue;
+        }
         cpu_synchronize_state(cpu);
     }
 }
@@ -145,6 +151,9 @@ void cpu_synchronize_all_post_reset(void)
     CPUState *cpu;
 
     CPU_FOREACH(cpu) {
+        if (cpu->mirror_vcpu) {
+            continue;
+        }
         cpu_synchronize_post_reset(cpu);
     }
 }
@@ -154,6 +163,9 @@ void cpu_synchronize_all_post_init(void)
     CPUState *cpu;
 
     CPU_FOREACH(cpu) {
+        if (cpu->mirror_vcpu) {
+            continue;
+        }
         cpu_synchronize_post_init(cpu);
     }
 }
@@ -163,6 +175,9 @@ void cpu_synchronize_all_pre_loadvm(void)
     CPUState *cpu;
 
     CPU_FOREACH(cpu) {
+        if (cpu->mirror_vcpu) {
+            continue;
+        }
         cpu_synchronize_pre_loadvm(cpu);
     }
 }
@@ -531,6 +546,9 @@ static bool all_vcpus_paused(void)
     CPUState *cpu;
 
     CPU_FOREACH(cpu) {
+        if (cpu->mirror_vcpu) {
+            continue;
+        }
         if (!cpu->stopped) {
             return false;
         }
@@ -545,6 +563,9 @@ void pause_all_vcpus(void)
 
     qemu_clock_enable(QEMU_CLOCK_VIRTUAL, false);
     CPU_FOREACH(cpu) {
+        if (cpu->mirror_vcpu) {
+            continue;
+        }
         if (qemu_cpu_is_self(cpu)) {
             qemu_cpu_stop(cpu, true);
         } else {
@@ -561,6 +582,9 @@ void pause_all_vcpus(void)
     while (!all_vcpus_paused()) {
         qemu_cond_wait(&qemu_pause_cond, &qemu_global_mutex);
         CPU_FOREACH(cpu) {
+            if (cpu->mirror_vcpu) {
+                continue;
+            }
             qemu_cpu_kick(cpu);
         }
     }
@@ -587,6 +611,9 @@ void resume_all_vcpus(void)
 
     qemu_clock_enable(QEMU_CLOCK_VIRTUAL, true);
     CPU_FOREACH(cpu) {
+        if (cpu->mirror_vcpu) {
+            continue;
+        }
         cpu_resume(cpu);
     }
 }
-- 
2.17.1

