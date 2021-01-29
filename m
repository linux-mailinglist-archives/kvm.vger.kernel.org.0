Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEA1308283
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 01:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbhA2AjK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 19:39:10 -0500
Received: from mail-mw2nam10on2052.outbound.protection.outlook.com ([40.107.94.52]:39681
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231387AbhA2Ah5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jan 2021 19:37:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LBKiDkDt1bMNL6gFOJ7acDvmgQc7ssDhaf317CLZJD4SqliseZbHfJXF17jK+TIfz1X3P1zclr9+kjgH109k0VQACKIY4km4eQig4obp0NbdYtJt/IMrTVT4e0yk6ik4jXWOybT07yHDKvxaDfmOjHAjW6E6047uPb45mhOKK4KbqhldGzSC3tSeQYkVfbp+zyU6f+ISs/JHs23PnOtZHIMRlnmnZ2nAwG5h0xgyulAnmnjEIfliqlBri5wx5+lxUqI0C2AQEHus06jncfZtHL7W5rEK6PhOO5I+LUwu03CHh6rka74ZdGukFhlEAbKi1LydHpGLr4DgomasKBen+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LroqR7U1lDdU3oQnauGVHLHLnWXk3xAM7TJ0lqnX5Qo=;
 b=cKvqhEQJg2s1ZAnMmlkOTBak6rsyWi1G2Ic9m3gIS3EmdD8p9oibv/nk0xH21Le+nhGxXXWpAN2UGABmGhjuR3W4EHA8ptrQ989UVM1Cb9xkJTMGu9hsZim9lVk/ThOjZGCdYFvu3NPri/h7S4EtFEBwfKmoiFme9N3f8X/uPVcOUlfxaaEfDsebx5YETuUTfLT+vjoIcH8GjqEfY9Uru0hoWYILlXmm3nDHQHJFlQl8tGd7XHK8f/Kqi6fBHoE6BPlnPCN0k8phrrE4+YPpnMNZylJ2pa2ky5C/UYmecgHwYkrppBUzad94e6n3sePTd2s1IydD3yZ3g1QRp2b1aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LroqR7U1lDdU3oQnauGVHLHLnWXk3xAM7TJ0lqnX5Qo=;
 b=t/uNLI5dfmhOBAXKKLQb7C+kuZNSPPEyK1IIu3hiLAs9+i0PD0YS89aAKNqYKZ6jv/GNqlR2IZf6TECsSJkn2IwjsnIy8NuzOoYly7OPDQBAVjyq2FwJejXCMc/4X+yGU/URVVWGPUcwt2L8N4yQEgXzeo4HIQ4qt0fZGeYbWxI=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2525.namprd12.prod.outlook.com (2603:10b6:802:29::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Fri, 29 Jan
 2021 00:36:20 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff%5]) with mapi id 15.20.3805.019; Fri, 29 Jan 2021
 00:36:20 +0000
Subject: [kvm-unit-tests PATCH v2 1/2] x86: Add SPEC CTRL detection tests
From:   Babu Moger <babu.moger@amd.com>
Cc:     kvm@vger.kernel.org
Date:   Thu, 28 Jan 2021 18:36:19 -0600
Message-ID: <161188057905.28708.10578820564970956832.stgit@bmoger-ubuntu>
In-Reply-To: <161188044937.28708.9182196001493811398.stgit@bmoger-ubuntu>
References: <161188044937.28708.9182196001493811398.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0052.namprd11.prod.outlook.com
 (2603:10b6:806:d0::27) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SA0PR11CA0052.namprd11.prod.outlook.com (2603:10b6:806:d0::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Fri, 29 Jan 2021 00:36:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e6e041d1-cbff-44fa-7c36-08d8c3ede5b1
X-MS-TrafficTypeDiagnostic: SN1PR12MB2525:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB25255EED357F61F8755948AE95B99@SN1PR12MB2525.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gb3WompLLSYOkYCz5cUpx2iNOIS9yYZSt7IuHVrIK/wmM8fjQRjRrYQdS30cp47TcSImj+xV1d3cMWWYWdOS8Ixuft8PXYawUpgAnb86B9m7dwj2B6dUmbpT72MfPfnbWNlso05I04utVmhBomA6LRv3+hYJChb268yDsSdcBhH5g36h2f6+B84FglXdS3AE1ehauizmcA/aRsIXLyc9iy67HOeRU0MhIDEflV6qHHed7KIsYix6LI2F+FKIU3B0MHKRX1A/q9c5Zon7XzbjnBkb4zsetZgg+o8mutHNYU1Kzt5EotSOWGsPLm8x6pYGqTfoIq40SXZiiiLJ80zmitExKT4DhHREOQtm6aMlQC/IOXasU1zpAH3HN/B+85Y4GPT2XSK6PUJ2sgBDaktDk501XsjnaezHpgLHTRU5oWntcZFDRpega5tJhEZQG9E1kaW9z5SNX9Ye0o7+nrT1J93oWjAfgMvVZWY+fkXPrqZP94T7stW8gRpy2bwyWa3vv+pQdgx+YJTVCzGmUdqrnA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(396003)(346002)(39860400002)(366004)(136003)(376002)(83380400001)(2906002)(103116003)(66946007)(8936002)(8676002)(52116002)(4326008)(86362001)(66476007)(66556008)(109986005)(186003)(6486002)(478600001)(16526019)(26005)(5660300002)(33716001)(44832011)(316002)(16576012)(9686003)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZHJyZGNWQ0ltMGpDY21wNzB6L1UrY1ZSTDhjWlFZN1VWWXR0RHBpWG5oZGNN?=
 =?utf-8?B?Y0xTVVNMRFFUQ09zbkh3dUlXd1k4azR5K2RNejlvN085NG1QRjE2UzRNS0Vl?=
 =?utf-8?B?NWpza2REdWx1Y09LeDZnNjlVUmJqMExsWkdqVldTa2JocE9SMnhZNlNLQjVq?=
 =?utf-8?B?Zys2RnEwa3ZDN0N4SlEySWxxUjh2eWdBRUdXOURSYXlZMlZoVEhMQnU2N2No?=
 =?utf-8?B?QUlZemd2M05wdDg2QkNWWmFPVUlUMHY5S0lPbG53Q3drRFNjYzV3Yzc2a040?=
 =?utf-8?B?V29uaUREVlZVR1VTbVZNYU5TU1MyRUJCclJNSGhCeGRiYXIrb2JFaWwvYW1W?=
 =?utf-8?B?SFR6TWJqbEk5blBHc1E3NDJnQUN0K21aRjFMZlhoOEZLOG1LdmY4UVUyVmpi?=
 =?utf-8?B?L1RsRllBQUlDc2VrZ3c3Q2MveWlKMkpFRnZXTFFCaG5MRDVJd0ZSNzloaXZo?=
 =?utf-8?B?RE5RNmtSbllySEE5bndIY2VhQ3RoNEsvTWRacGhSNmErTkQrOU96U0hJQjBD?=
 =?utf-8?B?d3kzMGgzbERzY3l4ZUxsSlpDa043U1FMV015dTU0dnRoTENJbWZmeFZFZGVK?=
 =?utf-8?B?cXg2T1Fac2x6Um11TG40eGNTWGVhMjJoWlRpMzJ2M1h6QXQwZ0FOTDRlTlEw?=
 =?utf-8?B?NlErNERFWUNqWkExVTdYcXdaR1duOXJmUFdTbkw5NGRQMjd6OWQvaEFac3ow?=
 =?utf-8?B?bEVwSlNRRmtrbGE1aHU3RitjcUlJNVZPV2ZqRmwxY21DaUxFREdVbHFBUGRR?=
 =?utf-8?B?QnJ5c1k1cExlRTVLVlRXQzlUUi9WTXlVdkp6eGdIdzh0akVTY0g1bUZTdnFu?=
 =?utf-8?B?VC9CSjFIczB4SXg5UXNzZEpia1dXYVY3TytHVkpudnozVGw5REdQclQvakgz?=
 =?utf-8?B?V3NoMFg3M2dEWHNFSDl1V09kT3lJYllOUE9YWGxGa2NKcGMwWEQya2xWZ1FM?=
 =?utf-8?B?VytmQW9wMUFXMHZFVjIrUzRVN3YxSTJZTVI4WE9PMFhFQUI5ZXdOek9GL3p4?=
 =?utf-8?B?UG1ldHhOaVVFSnpXM2s4SEZtTHpjOTkyS1BjUFlwRnQ5VUhKVnhQTk5xdUp0?=
 =?utf-8?B?Mm9iM3M0SWcyN1dkdHhDWDA4RjkvMGdZN0NZRC82QXloYm1QRjVpbW1uRUtR?=
 =?utf-8?B?Q3RmNUdyMDUwYTBEUzZoamIvalZLTWtyMkJjRjhKTnJ4dVh0aHpkS09JUWlm?=
 =?utf-8?B?aG1XWlY0YmNNOU5kaTdQTkZxTHlBNGdONEN0WlBLWmV0c0NteDZSaGZoNW1N?=
 =?utf-8?B?RWhoZ2kreklaRkVyaDVIMHpJZjV2ZGRaUW9uRlJLaVhnUW02eVJTTFVNVXc1?=
 =?utf-8?B?ZzFmQmgxbk9zQW1mSGZZbWJCd2lQZ3ppak9QcjZqY2F3Y1lMY054ZmJFSVho?=
 =?utf-8?B?MkdWTUJLbGkrRlYxUWVVVkFrcG96ODltcC92UnQvNFhzdVFqU3hUS2lMYVMy?=
 =?utf-8?Q?7G1WSPma?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6e041d1-cbff-44fa-7c36-08d8c3ede5b1
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2021 00:36:20.5192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AYRY3A05VyWaYpjbhg5WnBzlOvK0RVX5zcT9YrS3j5oJk9UVBEhbrEgGd5/MuAKf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2525
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Detect the available SPEC CTRL settings on the host.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 lib/x86/processor.h |    5 +++++
 x86/Makefile.x86_64 |    1 +
 x86/spec_ctrl.c     |   30 ++++++++++++++++++++++++++++++
 x86/unittests.cfg   |    5 +++++
 4 files changed, 41 insertions(+)
 create mode 100644 x86/spec_ctrl.c

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 87112bd..40caac1 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -159,7 +159,9 @@ static inline u8 cpuid_maxphyaddr(void)
 #define	X86_FEATURE_LA57		(CPUID(0x7, 0, ECX, 16))
 #define	X86_FEATURE_RDPID		(CPUID(0x7, 0, ECX, 22))
 #define	X86_FEATURE_SPEC_CTRL		(CPUID(0x7, 0, EDX, 26))
+#define X86_FEATURE_STIBP		(CPUID(0x7, 0, EDX, 27))
 #define	X86_FEATURE_ARCH_CAPABILITIES	(CPUID(0x7, 0, EDX, 29))
+#define X86_FEATURE_SSBD		(CPUID(0x7, 0, EDX, 31))
 #define	X86_FEATURE_PKS			(CPUID(0x7, 0, ECX, 31))
 #define	X86_FEATURE_NX			(CPUID(0x80000001, 0, EDX, 20))
 #define	X86_FEATURE_RDPRU		(CPUID(0x80000008, 0, EBX, 4))
@@ -170,6 +172,9 @@ static inline u8 cpuid_maxphyaddr(void)
 #define	X86_FEATURE_SVM			(CPUID(0x80000001, 0, ECX, 2))
 #define	X86_FEATURE_RDTSCP		(CPUID(0x80000001, 0, EDX, 27))
 #define	X86_FEATURE_AMD_IBPB		(CPUID(0x80000008, 0, EBX, 12))
+#define	X86_FEATURE_AMD_IBRS		(CPUID(0x80000008, 0, EBX, 14))
+#define	X86_FEATURE_AMD_STIBP		(CPUID(0x80000008, 0, EBX, 15))
+#define	X86_FEATURE_AMD_SSBD		(CPUID(0x80000008, 0, EBX, 24))
 #define	X86_FEATURE_NPT			(CPUID(0x8000000A, 0, EDX, 0))
 #define	X86_FEATURE_NRIPS		(CPUID(0x8000000A, 0, EDX, 3))
 
diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index 3a353df..79e4586 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -21,6 +21,7 @@ tests += $(TEST_DIR)/intel-iommu.flat
 tests += $(TEST_DIR)/vmware_backdoors.flat
 tests += $(TEST_DIR)/rdpru.flat
 tests += $(TEST_DIR)/pks.flat
+tests += $(TEST_DIR)/spec_ctrl.flat
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
diff --git a/x86/spec_ctrl.c b/x86/spec_ctrl.c
new file mode 100644
index 0000000..7359a9d
--- /dev/null
+++ b/x86/spec_ctrl.c
@@ -0,0 +1,30 @@
+/* SPEC CTRL Tests */
+
+#include "libcflat.h"
+#include "processor.h"
+
+int main(int ac, char **av)
+{
+	if (this_cpu_has(X86_FEATURE_AMD_IBPB))
+		report(true, "X86_FEATURE_AMD_IBPB detected");
+
+	if (this_cpu_has(X86_FEATURE_AMD_IBRS))
+		report(true, "X86_FEATURE_AMD_IBRS detected");
+
+	if (this_cpu_has(X86_FEATURE_AMD_STIBP))
+		report(true, "X86_FEATURE_AMD_STIBP detected");
+
+	if (this_cpu_has(X86_FEATURE_AMD_SSBD))
+		report(true, "X86_FEATURE_AMD_SSBD detected");
+
+	if (this_cpu_has(X86_FEATURE_SPEC_CTRL))
+		report(true, "X86_FEATURE_SPEC_CTRL(IBRS and IBPB) detected");
+
+	if (this_cpu_has(X86_FEATURE_STIBP))
+		report(true, "X86_FEATURE_STIBP detected");
+
+	if (this_cpu_has(X86_FEATURE_SSBD))
+		report(true, "X86_FEATURE_SSBD detected");
+
+	return report_summary();
+}
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 90e370f..b3c5320 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -251,6 +251,11 @@ file = rdpru.flat
 extra_params = -cpu max
 arch = x86_64
 
+[spec_ctrl]
+file = spec_ctrl.flat
+extra_params = -cpu host
+arch = x86_64
+
 [umip]
 file = umip.flat
 extra_params = -cpu qemu64,+umip

