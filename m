Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4266D3ED758
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 15:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240932AbhHPNbq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 09:31:46 -0400
Received: from mail-dm6nam12on2042.outbound.protection.outlook.com ([40.107.243.42]:46656
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241528AbhHPN3r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Aug 2021 09:29:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D2nD/y7SC/mrCPewxBJ7ECSGYAc85Fbo0QgOol86RHfSSuldrWPxtyqHR/ToDIdxQZTmImkDWG2Domt8Pih5OWdGquBVokOODoNlsVnGmU0hiCIglnCqO7MuiUC1q4gfhLt7jA7vgE5y8qRXp/nR6yTBfGZbKWIv73Lez4KXdLQzbwdrgLRAO3bYUQR6no1RbzyPj7YUzyKlXRXeHYoCjPNiCrMOONgW/GSUhZZ8jN+hnCZl87pNV4SMGZMkZJOPXze7iBFRbrIRvJq8QXsAqHKmbKy9CX5Hbmyjc9MOYjgnwUgz8ROAcCttWHLDdgMpl4ISVQJLNryn3T/dHhP3og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zeF0PyPYyeyXcMJOf5tpXQiylrY13tMzVY/RYEekCwk=;
 b=UIKpwQGbcktylAMZ9QaQMMjJokl9LRrzfAhDhWazK8ey6vriciaZWrDqZOYkOEZ/HZ9rzfO4FaeFlqT7TAtMEhGMY0YyStujmTlc86uBQMJ03T/XLrBOEWa4+ZjbzBfBORG0Ya2sbyJ1LAF27ouyNqC9OJ7X+l8VdKbY8UcypWWZE21TLkyn4ChLsFI2DOyxhjPAIb3G8Xw+vB9/rraQqLr+ua4xqVcwvUaWuQ/4JpQX7XcRgyDjj3lccWPeKIFv3Zc3+/2ybF8XIvahFFsf9XDLMsX5dlWOoMVhFQS5Q587NfskIpUabr1VmBMyJ/+rfdYxxMIetgzw+lLHUuat1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zeF0PyPYyeyXcMJOf5tpXQiylrY13tMzVY/RYEekCwk=;
 b=pC4C4656h7cKv5XEzlDQTfGdbB51Xy/S/57J1U3FdntLmVmdDLDTHVuIBf1dhaDGM1VbwXufE5+WokLWs9yHxx9crR9cBXVfoUbco/FaEdwi7fEpw5FgWzX25fInNJhJBGsahkbqCS5dzB0S7Vg3eA1PI7t5PYmAy/7zb5GsdgM=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2366.namprd12.prod.outlook.com (2603:10b6:802:25::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.19; Mon, 16 Aug
 2021 13:28:42 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73%7]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 13:28:42 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, ehabkost@redhat.com, mst@redhat.com,
        richard.henderson@linaro.org, jejb@linux.ibm.com, tobin@ibm.com,
        dovmurik@linux.vnet.ibm.com, frankeh@us.ibm.com,
        dgilbert@redhat.com, kvm@vger.kernel.org
Subject: [RFC PATCH 06/13] hw/i386: Set CPUState.mirror_vcpu=true for mirror vcpus
Date:   Mon, 16 Aug 2021 13:28:31 +0000
Message-Id: <8c04d77d3a5a60436aa2b77264b2b7d40b402497.1629118207.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1629118207.git.ashish.kalra@amd.com>
References: <cover.1629118207.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN2PR01CA0023.prod.exchangelabs.com (2603:10b6:804:2::33)
 To SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN2PR01CA0023.prod.exchangelabs.com (2603:10b6:804:2::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16 via Frontend Transport; Mon, 16 Aug 2021 13:28:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de6a6442-e4d7-4060-9588-08d960b9c3d5
X-MS-TrafficTypeDiagnostic: SN1PR12MB2366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB23662C55F94A2DB774066E398EFD9@SN1PR12MB2366.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +uY/ZVSckIG3ytvbPs+Rce8L5ci8+L+cbcbrXpOY942zDboafjyigp9eC23OoIFMGqk0NhkHFMPuR5NWR+/cl1D74P/TpkEDWKdbanPJo2hynFA8UgTpNPQIv82JW1c1VKF1dYhDbHMnwqsWahUapd+Yyp/fxBGNTK8TPI72SzbnJ7WxNvo7ObFgn2lsyKxkEac5DC+3ue1pi0cIhx52rolleIKgagPAWL889NQeg0SFNaBW/LvNkuQhr+90ljaeB0dmp0MgwY5aFVeWCaOhdgvEwlDyUAJZbibrUNmefe1U783RgLZPcZ3lBSVbVpN0hu9l22pj9RJM8FrwRiRKpy5bj2j180SqkWSj0frei02oUwK4lBmqYaiwfKKRRM51O7iP7Wfl5hF/BYJmz46Dsj5ZMf/eIdqK4sWfnYzwZ8BalFlbil3kwJIYePhJP6OLTQrVa5e5E0xe/4eswbotLJn5U6iG9pExfP5/dbgkm86+HnBiDC1dWvPEp9SdfucSNdHQRKSB1E38h+A63j2M0H668ulfOXk4qdhMucWY7k53P06z/bicNiVRTPNA9MdODS/vvShnz01eJ4jSvWXpML2/ddQ+8ePUeBWw2XZa4Q1SapUF35kuEUtYDqCLL9d3IaMgiE5lEA0quDZbVRCFU2zSZl2Nv4Wd2uav55PSek9Ln3h/CF1rhv7V7WJmqvDiF686f1Cjw91vT6EvyLtZyQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(7696005)(38350700002)(316002)(38100700002)(956004)(2616005)(6486002)(2906002)(6916009)(52116002)(26005)(5660300002)(508600001)(8936002)(36756003)(66476007)(4326008)(6666004)(66556008)(66946007)(186003)(86362001)(8676002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5IbKoteHIfvENzUsyi1usAvbshjOWEe/fEEPs+bd/rH0BNWU0gCeJ4CRYUtb?=
 =?us-ascii?Q?OJfzjMvLpLhkJmrQKay6wMKOTP+rVvYfUySbIUM58QFysTCUq/V2qRp5Mwpf?=
 =?us-ascii?Q?gbd1a2yFXIAahwhV+GPPnow6u/55s3+Vh7BejIQ7Nkuh/ulkMBLJh+K8AA4S?=
 =?us-ascii?Q?oBc8gAdt4UTugg0lY3YtaAnBei/fyZ2TGg2H1wIHv3fECYiSFatIlIF0w/v5?=
 =?us-ascii?Q?DB2SEg6IP/rGhwpFWaVY9N5EuISNOWFkfcnDhYpy0zdNohKQ0vkbXL3nu86k?=
 =?us-ascii?Q?kJBjlt/shzkOFH1wIGfLgAXMs8GqH5H7lNuVpM0ZVMB9BKxg6j4W3Uwp7VLl?=
 =?us-ascii?Q?HmxBPBjZLb5aol1sjyaKWGSq/nudwT60zR99e8LuZswrqvolBWbwAPzd1BUW?=
 =?us-ascii?Q?6ubymLPmEH246/bqShuMRjhTwP2BAn4GwyThsPAZAscb2juQMzCsFKdU0cpY?=
 =?us-ascii?Q?UHU1J6nvZ4o+gFvWQxszU8mDsS/bqqYD4WHK/vw265rlBurcfXiOgdOEtPnS?=
 =?us-ascii?Q?NuMI4KYHuTpWFiSnzeyRIJc6OH/YpYyql4aqqsv6J26dPsxiHJFIpkzfQ+cb?=
 =?us-ascii?Q?ZN1SOG7KZj2JnKJG6XXdR9unYnGLtpPITLGe7NOu/zO2dI6+hQUJsZgvoeVl?=
 =?us-ascii?Q?LwN4o6mkjBMVTWnpnBONOYwy+QbvZxF1T9UJpC2TQickjGxvqplNzR5F/kkz?=
 =?us-ascii?Q?Eoqw3ns7q5Rg0dazwIdjopZms77GM+aJBX8Wkt/bXuxYOHehk2Bz7/49nJLj?=
 =?us-ascii?Q?say3hyQ9jwzmG8QxUeak0hy94Vz698ZutovuDRsy7KvZuoO+nIcokeisOrhk?=
 =?us-ascii?Q?EafXLp8lL1FUTYNTP6C/NFLof0PHW5JdNvyXLtZxp15gOs9YFsqeZ0Z79VaT?=
 =?us-ascii?Q?JkEle8V8n0Q0iZNxdR4IoOV8Ay7UTOTtCdg1RVHNHDYIopiiKNAG9tYI66IL?=
 =?us-ascii?Q?dp7XeyjuC9xKukBsCz0OHLhvnK7QnH9zZBVTDzEHxlzdPbKIpvr1Kk6omkrT?=
 =?us-ascii?Q?RVyFM29V8MZX+FFk6XLUtCO4qnNxA6TUdowlMMToPj7BC3AvvAVZGbOog2Nq?=
 =?us-ascii?Q?xtod6AFYqSjRmjTXiTYunTFUooPLqbdchPH/D/qKojvlA5p+AmlKo3qubUXq?=
 =?us-ascii?Q?lgp3hA+OXuAoAHmRPnbAYZqKi9kgfEejEXqcA1i4TbBiQaZXvRYrt7Z3g98M?=
 =?us-ascii?Q?gRUUGLCvIyLMAEloCBzQUHLxED/hTVYWoFVr/dQ+QARktVqa2HzZ9YD6hHRP?=
 =?us-ascii?Q?TUeJ9ckBT0PbYMMhG6JgHxLxyksbZf2jWYE/h1KFRnAbl5FIlSvWZ6e5KiFz?=
 =?us-ascii?Q?efiEa+a31vCZ8/bxtMEyaV7v?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de6a6442-e4d7-4060-9588-08d960b9c3d5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2021 13:28:42.2225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZBu0UuKwRRWhTgkAJB1w9SgfqCjjaHU5pDlAoVLn9q1+bTUi7CcJVjA45Bo7SP+RkYo1nAT0IGcdME/aspbAFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2366
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Dov Murik <dovmurik@linux.vnet.ibm.com>

On x86 machines, when initializing the CPUState structs, set the
mirror_vcpu flag to true for mirror vcpus.

Signed-off-by: Dov Murik <dovmurik@linux.vnet.ibm.com>
Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 hw/i386/x86.c         | 9 +++++++--
 include/hw/i386/x86.h | 3 ++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index a0103cb0aa..67e2b331fc 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -101,13 +101,17 @@ uint32_t x86_cpu_apic_id_from_index(X86MachineState *x86ms,
 }
 
 
-void x86_cpu_new(X86MachineState *x86ms, int64_t apic_id, Error **errp)
+void x86_cpu_new(X86MachineState *x86ms, int64_t apic_id, bool mirror_vcpu,
+                 Error **errp)
 {
     Object *cpu = object_new(MACHINE(x86ms)->cpu_type);
 
     if (!object_property_set_uint(cpu, "apic-id", apic_id, errp)) {
         goto out;
     }
+    if (!object_property_set_bool(cpu, "mirror_vcpu", mirror_vcpu, errp)) {
+        goto out;
+    }
     qdev_realize(DEVICE(cpu), NULL, errp);
 
 out:
@@ -135,7 +139,8 @@ void x86_cpus_init(X86MachineState *x86ms, int default_cpu_version)
                                                       ms->smp.max_cpus - 1) + 1;
     possible_cpus = mc->possible_cpu_arch_ids(ms);
     for (i = 0; i < ms->smp.cpus; i++) {
-        x86_cpu_new(x86ms, possible_cpus->cpus[i].arch_id, &error_fatal);
+        x86_cpu_new(x86ms, possible_cpus->cpus[i].arch_id,
+                    possible_cpus->cpus[i].mirror_vcpu, &error_fatal);
     }
 }
 
diff --git a/include/hw/i386/x86.h b/include/hw/i386/x86.h
index 6e9244a82c..9206826c36 100644
--- a/include/hw/i386/x86.h
+++ b/include/hw/i386/x86.h
@@ -96,7 +96,8 @@ void init_topo_info(X86CPUTopoInfo *topo_info, const X86MachineState *x86ms);
 uint32_t x86_cpu_apic_id_from_index(X86MachineState *pcms,
                                     unsigned int cpu_index);
 
-void x86_cpu_new(X86MachineState *pcms, int64_t apic_id, Error **errp);
+void x86_cpu_new(X86MachineState *pcms, int64_t apic_id, bool mirror_vcpu,
+                 Error **errp);
 void x86_cpus_init(X86MachineState *pcms, int default_cpu_version);
 CpuInstanceProperties x86_cpu_index_to_props(MachineState *ms,
                                              unsigned cpu_index);
-- 
2.17.1

