Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2542E0D16
	for <lists+kvm@lfdr.de>; Tue, 22 Dec 2020 17:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727550AbgLVQIf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Dec 2020 11:08:35 -0500
Received: from mail-eopbgr750070.outbound.protection.outlook.com ([40.107.75.70]:60504
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727432AbgLVQIf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Dec 2020 11:08:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V5sjH5gkcZGKkJ2D5P2mQzFLXbvVr7/pR4YJBoSjh7QEHydSYEeECPSHy8HGF5mx2Z0cbh9xcuzWumKGzIN0v1qP2snoab4C3XPhFgOZpkrU3yfoVv+ofaZhiQ/zK2nWSCy2qv0AxJgMVUm7E3+jDRT4T+ltES5W9kOXmqlIdy4cf3E5NeD+PhmOt0Urxm2QuHULV4NAPlS2JQyRqGC8wG5ul33Td2Ia2EjmJm332BtN71Gfe1M7nI2IJfKB3v1TJLtg64d7aVJwiQ6Cu6mHMu79yiyOaVZEkjHXOJh79GwfNEVvCIxy4AJ3b+lnbD8DXgcs2MlvtOqWHo0hup84Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zXVFCMp6IppeZHkGkS/wZbDL80PAuWxZ69/MDR0wuak=;
 b=WQpZWD+Ok7HE/KF82RFavc/mHjkdSa1lEWGxvZIl4Y/zo3n9/SjhQ0ThA4FvG86SdSvagryBIbpYfqBxYwq1py7+rQKpVWThStri8DiR3AJFMKBi1GYi31DwIQZf6DFGggmotS8oRMCcGJZ5oxldln9KBVnLPqtpYRbc8iKUiPXHqlIaWB91aiodYZj9j9svdBXx449WBeCXMlzalRsxy6lG2acXlrYcrlKW7mMZc8wFpfAtmAcZbbsz/shSZ2AysU703odIpju4unxFQ4KAwvh75aotF8uOwPpNvWT2D4ZPdqUFPud8VyIlyrEfEY6ZwbkdaVp8kRncMwNSqr3kPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zXVFCMp6IppeZHkGkS/wZbDL80PAuWxZ69/MDR0wuak=;
 b=sDS+T5rCTmUIfKJrwzmFTcrT5IImR+hBYEf849sOXi2lTh82Zue/dPB86RPBc9pDfifOqdG5Diam1RuzKASDkJW3d1xWddDq6nx6ChFZ1tKAmejwBcbOxcjZed5wBZdRptX7UA7ca7C9EbWvocWflo2wWUcH/mVdFEwNiKhl2GU=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2559.namprd12.prod.outlook.com (2603:10b6:802:29::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.29; Tue, 22 Dec
 2020 16:07:45 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff%5]) with mapi id 15.20.3676.033; Tue, 22 Dec 2020
 16:07:45 +0000
Subject: [kvm-unit-tests PATCH] x86: Add SPEC CTRL detection tests
From:   Babu Moger <babu.moger@amd.com>
To:     kvm@vger.kernel.org
Cc:     babu.moger@amd.com
Date:   Tue, 22 Dec 2020 10:07:28 -0600
Message-ID: <160865324865.19910.5159218511905134908.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR11CA0022.namprd11.prod.outlook.com
 (2603:10b6:806:6e::27) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SA9PR11CA0022.namprd11.prod.outlook.com (2603:10b6:806:6e::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.30 via Frontend Transport; Tue, 22 Dec 2020 16:07:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9bbcfcfc-cefc-42a3-4e77-08d8a693b824
X-MS-TrafficTypeDiagnostic: SN1PR12MB2559:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB25592C6C0163D26874E3175595DF0@SN1PR12MB2559.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1051;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HhIUM5AUOGEkgeHXdFfpiqlRI/R7LuWO0fc+m9mjSB82HE+pB/lOGVxzo9cqsEHHckjjBjtihU08hxlWT9emE0XmP4SoG2UIud7sI4qN5kxkYSRyvn/SeOOI4vTjg7NFC2/XYTErRzB4neXBD/Y4q7NarnFLGKrnaJNbLMcwwEeQhQViT8dJfYZFaK6kxvifUcUgKv2gOVA6rFEiSNBrMkQEXG/3Ut1CgVuCl+SChB3Pqq1B+4IawOY1+HlHkyHw/0o4aOJjd5b7MOfiis6WmCNJ+K2dM97CAtgL+G+ZdkNohqkYyM/XIyrEyaePeID6ngEVImL0CwzXktgfOMf5VotOXIwLSiePaMqdYVQAgYWenJGr2jpEReeI39r9Sa98vCwHTLUMImUf7MdiQFJviw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(376002)(366004)(396003)(39860400002)(346002)(136003)(52116002)(478600001)(33716001)(66946007)(6666004)(16576012)(86362001)(316002)(956004)(9686003)(8936002)(4326008)(8676002)(66476007)(6486002)(26005)(44832011)(5660300002)(2906002)(16526019)(6916009)(186003)(103116003)(66556008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WHJYYW5ITVcxUnQxV2RkZDJleU9nNm5OU2RkUVhTcUQreWVEQ0VsZ1p2czJh?=
 =?utf-8?B?M2J5WDdZMm5JQnI0MmNxREEzOEdCRVRsYWlDaGtwWkM3M2pFSENyekNQRlRM?=
 =?utf-8?B?T0JkYnBnRWVzVFR4UjQ3Tk90UTczdzZtbHNaMUpINC9WeUsyRzBFczR2UG1w?=
 =?utf-8?B?SWFQMVI3MkIvbm5KS3Yza25acGxXRnhIWC9EcnBPcEVJNmZ2ekNDL2xXSW93?=
 =?utf-8?B?ajNzdUtXWUowdVdMaytKeDJsV01jcjdyTmFybVR4N0xQZG5kMkFrMjNOMUpI?=
 =?utf-8?B?dkw3bTl2Q3EzaENOTUk0dTZkZWN0OVJicGVMZS80R2lQV3gvcWJWL0pHMlpk?=
 =?utf-8?B?RlEvSHk3YnkyWGd0NFZlUURNcVIyYVppZDZ5cmNCRHF2WUxRTHZTUkVDT1lw?=
 =?utf-8?B?QkJvQkM1YVZvMVhMSXdqWUtaSDRvNGtVa1Z3UjBibFV4VFcwdnNaU1g1MDVH?=
 =?utf-8?B?UDhiZTBnYjh0OHduaEJybXM3dUFDWEpnWHQvQlEzdktwZnBRWUVReGFORkpK?=
 =?utf-8?B?WGp6NUtKMHdURkQxQWw3a1VpNU9MdmJjeGtHN0toQ2xaNWx6ekFEZmxvM2RK?=
 =?utf-8?B?N0hzRnkrT1VMZDlHZVBmeWpkaForS0ttYTBsN0dQNURWNGxEcGdHT3VSNGMv?=
 =?utf-8?B?T1B3VDVtZVVVbGxLVmZHN0tVOFA3QUJvTkVXbDl5UGwwVUV2K1ZSbnhaNkN6?=
 =?utf-8?B?VDd4cDZJbUt2N0taRWVBaENHcU11L2ZZUU93Y0d4RE5FYWp0Q0VzeFpoYlpl?=
 =?utf-8?B?VVhrQ2g2eXlFR1l5VXdtdnVCbS9Gc0RvSDQ3eC9nTmZqc1hYODBJTHNKc01z?=
 =?utf-8?B?VXBSZWJFUVVFbzZVVW9jL0V1R1RYTGo1dGFaVkZld3R5UXBybE1GYWQvazBM?=
 =?utf-8?B?ZHNnRkZyK0hSdlM0blY4UTRXWFpST1NuQWplY0NNck91d1hCdVIrQzJ0RjlC?=
 =?utf-8?B?cmRZOSs1YlBBTkdvb2RQVUdldW9zaWFzSWcwQmprR0JFam9iQXJuaGZqU3lB?=
 =?utf-8?B?VTAwNWhDVTVESEorYWltUmlGNmZOYTlxUnZTNEFIaFdJZmZOam9FdUlYQXBX?=
 =?utf-8?B?Y1l5ek5FQTJHY2NBUTYzQjNXQmNDUDFRVVhTd1l6N2IzcVJjY3lNczNIcDNT?=
 =?utf-8?B?UVBNRUg4a3hab0ozcXMwMEFYSUV4VDVjajNZaWJIbmZsT1Y1eGtoRW41VnE0?=
 =?utf-8?B?VWNXeXRrTVBaY1RobVdjbUVBaWRRRzVoTzlUTnp2RDJTTEpNYTV1Y2pTV0g0?=
 =?utf-8?B?aEwwdThJd0JCTVFGckU3T2oxczVCOUJOejJHTTNxM3BSQWlXV1pXVWlhbXA3?=
 =?utf-8?Q?r28r78dCy6Y2aCR+MwmdAWisJLiPi4rcW2?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2020 16:07:45.2006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bbcfcfc-cefc-42a3-4e77-08d8a693b824
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2SQwuz7pLInCM1Mvo81a9LIsxAHN1bmwbucxxOBFNpanmNypIgtn0zR4+Qpkr+LW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2559
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Displays available SPEC CTRL settings on the host.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 lib/x86/processor.h |    6 ++++++
 x86/Makefile.x86_64 |    1 +
 x86/spec_ctrl.c     |   32 ++++++++++++++++++++++++++++++++
 x86/unittests.cfg   |    5 +++++
 4 files changed, 44 insertions(+)
 create mode 100644 x86/spec_ctrl.c

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 291d24b..fe55a77 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -158,7 +158,10 @@ static inline u8 cpuid_maxphyaddr(void)
 #define	X86_FEATURE_LA57		(CPUID(0x7, 0, ECX, 16))
 #define	X86_FEATURE_RDPID		(CPUID(0x7, 0, ECX, 22))
 #define	X86_FEATURE_SPEC_CTRL		(CPUID(0x7, 0, EDX, 26))
+#define	X86_FEATURE_STIBP		(CPUID(0x7, 0, EDX, 27))
 #define	X86_FEATURE_ARCH_CAPABILITIES	(CPUID(0x7, 0, EDX, 29))
+#define	X86_FEATURE_SSBD		(CPUID(0x7, 0, EDX, 31))
+
 #define	X86_FEATURE_NX			(CPUID(0x80000001, 0, EDX, 20))
 #define	X86_FEATURE_RDPRU		(CPUID(0x80000008, 0, EBX, 4))
 
@@ -168,6 +171,9 @@ static inline u8 cpuid_maxphyaddr(void)
 #define	X86_FEATURE_SVM			(CPUID(0x80000001, 0, ECX, 2))
 #define	X86_FEATURE_RDTSCP		(CPUID(0x80000001, 0, EDX, 27))
 #define	X86_FEATURE_AMD_IBPB		(CPUID(0x80000008, 0, EBX, 12))
+#define	X86_FEATURE_AMD_IBRS		(CPUID(0x80000008, 0, EBX, 14))
+#define	X86_FEATURE_AMD_STIBP		(CPUID(0x80000008, 0, EBX, 15))
+#define	X86_FEATURE_AMD_SSBD		(CPUID(0x80000008, 0, EBX, 24))
 #define	X86_FEATURE_NPT			(CPUID(0x8000000A, 0, EDX, 0))
 #define	X86_FEATURE_NRIPS		(CPUID(0x8000000A, 0, EDX, 3))
 
diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index af61d85..9d0c6fd 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -20,6 +20,7 @@ tests += $(TEST_DIR)/tscdeadline_latency.flat
 tests += $(TEST_DIR)/intel-iommu.flat
 tests += $(TEST_DIR)/vmware_backdoors.flat
 tests += $(TEST_DIR)/rdpru.flat
+tests += $(TEST_DIR)/spec_ctrl.flat
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
diff --git a/x86/spec_ctrl.c b/x86/spec_ctrl.c
new file mode 100644
index 0000000..4b26eda
--- /dev/null
+++ b/x86/spec_ctrl.c
@@ -0,0 +1,32 @@
+/* SPEC CTRL Tests */
+
+#include "libcflat.h"
+#include "processor.h"
+
+int main(int ac, char **av)
+{
+	if (this_cpu_has(X86_FEATURE_AMD_IBPB) ||
+	    this_cpu_has(X86_FEATURE_AMD_IBRS) ||
+	    this_cpu_has(X86_FEATURE_AMD_STIBP) ||
+            this_cpu_has(X86_FEATURE_AMD_SSBD)) {
+		if (this_cpu_has(X86_FEATURE_AMD_IBPB))
+			report(true, "X86_FEATURE_AMD_IBPB detected");
+		if (this_cpu_has(X86_FEATURE_AMD_IBRS))
+			report(true, "X86_FEATURE_AMD_IBRS detected");
+		if (this_cpu_has(X86_FEATURE_AMD_STIBP))
+			report(true, "X86_FEATURE_AMD_STIBP detected");
+		if (this_cpu_has(X86_FEATURE_AMD_SSBD))
+			report(true, "X86_FEATURE_AMD_SSBD detected");
+	} else if (this_cpu_has(X86_FEATURE_SPEC_CTRL) ||
+			this_cpu_has(X86_FEATURE_STIBP) ||
+			this_cpu_has(X86_FEATURE_SSBD)) {
+		if (this_cpu_has(X86_FEATURE_SPEC_CTRL))
+			report(true, "X86_FEATURE_SPEC_CTRL(IBRS and IBPB) detected");
+		if (this_cpu_has(X86_FEATURE_STIBP))
+			report(true, "X86_FEATURE_STIBP detected");
+		if (this_cpu_has(X86_FEATURE_SSBD))
+			report(true, "X86_FEATURE_SSBD detected");
+	}
+
+	return report_summary();
+}
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index b48c98b..2e3602b 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -246,6 +246,11 @@ file = rdpru.flat
 extra_params = -cpu host
 arch = x86_64
 
+[spec_ctrl]
+file = spec_ctrl.flat
+extra_params = -cpu host
+arch = x86_64
+
 [umip]
 file = umip.flat
 extra_params = -cpu qemu64,+umip

