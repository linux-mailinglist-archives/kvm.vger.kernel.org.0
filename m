Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73C3A36F9E6
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbhD3MR6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:17:58 -0400
Received: from mail-dm6nam10on2049.outbound.protection.outlook.com ([40.107.93.49]:15328
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232125AbhD3MRy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:17:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gaQX1ZAUydEebxLThY5vQxJYihS3EuLgfNfC/pBdQTZZxX1NI+4FGWcqEXmidurrkzQt1BQKn7+JdrT6toJDJs/mXCWw/5F9SFh7TCrUkSoYfuaNZZA70JcqAp2s1jq2KJPEzcw++9mrnGioZPl0ErVXNFVunrML4ijheChY51A4sokaBhp3pCYjyal+bQZtMXIWtHVr61mVzjRoKeXWqa4+XxvAm8WiCb2mwq1YSv6/a8p4vp35FwIMaDqbzo8zvV06o22XODMexFhSI9xo9GCHznFyU5DXMHF51urIm50HS0FJgg1wpDEldre0YnT4OdBmJ4KGCvTqUsK1zWB9AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wQpuiwLdMfJYiivQvigGB5VtDe315f0d+gl7yidM63Y=;
 b=HL8fRTRby/2Y+mor4aHei5F3zTMZit89UO1qQzEKJkm4hOzn3bNgSMclfOI85tqDuRjLfXCoi/fgCv4MjdAY32Lg3e3S3HRECX5wDhikRwTRmItiounUnsXt/3aproq2PdwXiYYBcZkM9TizO72oRI7ZL2PP51HYiFN5mH5nCKPNgNpiE5MMC2tz1LB38sDQDF5H81+7LtoMSCD5OzeAmv9poMM9FxwSJYNBjeFbssmBm+k/nydRj6Y+trp91ilxovI8GX1DHSzviA0jLotucO62yUF3EAsOzyIfXB0norE+cOn29Z3aTpnQ6v7oQ3iXGnxFqL+WpzqH2W+E3gL+8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wQpuiwLdMfJYiivQvigGB5VtDe315f0d+gl7yidM63Y=;
 b=PQc+ka+FBtd/m6V8G1DRai2ubCvuuLo3yeEC956jGYPwBcXemJaWenzJ9p9Y14Q4iwc1BN7ntjyQDbbu4T4unjdf0B/110pm1BMMXOSPIo9oY0d334EciJ081DPo1YubX/NI0sbhMDDfX2kuVfTjiXbbLXZIvbZJK8ZghY8/xXM=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2640.namprd12.prod.outlook.com (2603:10b6:805:6c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Fri, 30 Apr
 2021 12:17:01 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:17:01 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part1 RFC v2 12/20] x86/compressed: Register GHCB memory when SEV-SNP is active
Date:   Fri, 30 Apr 2021 07:16:08 -0500
Message-Id: <20210430121616.2295-13-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210430121616.2295-1-brijesh.singh@amd.com>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0401CA0021.namprd04.prod.outlook.com
 (2603:10b6:803:21::31) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0401CA0021.namprd04.prod.outlook.com (2603:10b6:803:21::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Fri, 30 Apr 2021 12:16:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed337953-4134-4d3b-fd9a-08d90bd1d8cf
X-MS-TrafficTypeDiagnostic: SN6PR12MB2640:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB264050257A8D7DF295BD709DE55E9@SN6PR12MB2640.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hfLj1UY4mQZkBHhdjAcJlc1IqSSXuCMhQ4QD7xMy/bDDFIspkwVChWaBPTe8CCy6krofyJ7Bsp6+S0th5g4b9InVmI1dWSVF6wZxQZJryN9sSX/kc60Mlo47S6Y1fJ5PWX3iEFl9VaIjz8nISBfRdif12v+UjbKnT7rnHleVd3O+gvhn93QOgsagOz/D1sIZaZbEVmx6VaTqKpeoEDwCuYPOY6AjllEsb0nmAmY/P1H9d4KvfGGCD0JIe85lH5Flg3ahfBJlhNYyI6hSG7dw7L3G0HDuAykTaAOQAx0brhKrq+08C6NHccVZhJDDC2xFPsrMm/iOY5fEpZTQGdDG33esFc6FyqUzu7HTPfmkLVHXFNxJB6s8bYMeXo/C8bM+CX5tTlmLCtyGgK3XX8ZCa1rrrvIIR8evIv6d/8vPmZufL5MrwYdq0O/KMVaGYJ6bou3cdB0GNEHeUpCCj9hV3ryrWicM//sGJcb6a+5CvWB+AaNBzNpL8T79gt6SLZPxMENfn3yqpOjYGjnywl9ow3C3FVVzE4y41N/Az+/EvmAYKQPw1xdmhLMjah3csqKCcJnhk8XzHkQT9gwaY+lTBIWKL2cLIv8xgRFMCVIaKWJVABH6zRdgNqmD5LaQsBNGU5VRvoBwUI2cw1sjUmJKhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(376002)(366004)(396003)(6666004)(52116002)(7416002)(316002)(16526019)(2906002)(36756003)(186003)(26005)(38100700002)(38350700002)(66556008)(66946007)(5660300002)(1076003)(66476007)(4326008)(6486002)(86362001)(8936002)(956004)(44832011)(2616005)(8676002)(7696005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?bCg4mMVDJw5l4ioNgf2jmZft2RVOnlqi2HD6/U+neDQMLVfOixundiIZ0sGN?=
 =?us-ascii?Q?d4tzWAKz5zITQ0KAbnnobIpaq92ycHJQ7eajIeuluegxqJll1Z3i2UJ02zF3?=
 =?us-ascii?Q?jho/f6TCfgrcDUH7Zq74iCqGXrpK4Wxv84CvVZ70Kqu0EpYGEItkahcZsVlQ?=
 =?us-ascii?Q?+AhPQqNvH9JELRM+W8gCfZuA2uWudYZpJ6p0U9sUCdvOGKpoFMEK60pWPozB?=
 =?us-ascii?Q?tudcYxmFg6pKKHXoZSR07hsVIICR1wTAzAqVTnWyt9aSNZJhJKMzAWFW1QHL?=
 =?us-ascii?Q?r5l3Ss9Nbx4bJnVURaaSxQKEJLLz+Jo649kQ9PGLIKxnd3myUkUN2bgaFUsh?=
 =?us-ascii?Q?SW9iZJufSOuO3FIDC7g+Q0VGHHPs6chupLTo0YG+Kkn6Xsk3mH6dsbZRoFLp?=
 =?us-ascii?Q?z9QitoL5ZbpcHJBRze6oTRgxFaH+QW9dFMAQS8O8cgLnYjIFpM2EbA7+h30G?=
 =?us-ascii?Q?+YaD4+cxSlHIVPOqgXDRX64wA04BzrDDyUqa23XDf9ATT727BqHOPtWGLM5S?=
 =?us-ascii?Q?TZKgMBUG7OCi9h9RZtXc/lZgQ/ZVPGcMYXDomYp2n4AF9rTcHhGyjFqzYARL?=
 =?us-ascii?Q?Y9PWQvfGp2C81carL1gEv8vgnAr6ZhWgPNrFmyB1MTNrcoYh7kg7pwtuv26G?=
 =?us-ascii?Q?RZsOICNnDThYxsdiYNe3f2efhpgTzpWOvGR05xMzmSvd6tETGqsui778KbRq?=
 =?us-ascii?Q?x2Qgx9JZXX3uOPezgAjyeomcUUTtyFgODl3AcGTWI8yY/b54M7Aw6aUNw+5j?=
 =?us-ascii?Q?w4suNT/j0hITVy9M/99ziUagTEUeWrb6UhkPksiDj5v7S+H0cVUY0AvYc6Hc?=
 =?us-ascii?Q?/WWBMRAmSJARP/2vxcha7zXOkbhD2ePpxyZ1bHDio/lrSxzdYoXIay6pmig0?=
 =?us-ascii?Q?ct6FyRLDQLqWvbKuaZH0P9kXU0YLhh9auHk1AcEKeeTl1OnjHsNHd7po1XQQ?=
 =?us-ascii?Q?NohSp9gkIUq3m0s2mEc6wT9Qivotv3FvQfCJIZmf5UwyjsqCU+RHQvkSuAvz?=
 =?us-ascii?Q?BIZvNP9gE5VJICj++nOic96j1qEA6nXIn+mpeShTOjaPO2CwrPJlQqVQ3BlQ?=
 =?us-ascii?Q?C3AfhPY2up2D4HfWDFUmCZ/s2N4dcNsoC3H+9PRY02GI+WhjOuPjC0Q7CshI?=
 =?us-ascii?Q?8eelaEzmVP+bJUCCba0Bbg+VwcWPLT+7+eGS4D50YWpd9wmDc1yS1GG+WGlR?=
 =?us-ascii?Q?NYoEK4B3XOl3iVFoYf1GOgU1RmqC+ejkAYxugl/WiSvrEDlfGun5aB4e6X77?=
 =?us-ascii?Q?Xl5xfTzvUg/reNTmhf03BQxFkRg5YAWThEIDx9lq8mmbFLrKYqEfRbYtyaWl?=
 =?us-ascii?Q?RwS0GgbJYhitLS0hf0OzpH8e?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed337953-4134-4d3b-fd9a-08d90bd1d8cf
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:16:56.4914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r109YRyF15Of1inGT6QCuuSPu5UXNiUP4G2QARgTO6bEEEh6XpKaCbl4GYm5wOnnN7p3X1t/q5z+SNEqrMZKwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2640
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SEV-SNP guest is required to perform GHCB GPA registration. This is
because the hypervisor may prefer that a guest use a consistent and/or
specific GPA for the GHCB associated with a vCPU. For more information,
see the GHCB specification.

If hypervisor can not work with the guest provided GPA then terminate the
guest boot.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/boot/compressed/sev.c    |  4 ++++
 arch/x86/include/asm/sev-common.h | 12 ++++++++++++
 arch/x86/kernel/sev-shared.c      | 16 ++++++++++++++++
 3 files changed, 32 insertions(+)

diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index 4f215d0c9f76..07b9529d7d95 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -206,6 +206,10 @@ static bool early_setup_sev_es(void)
 	/* Initialize lookup tables for the instruction decoder */
 	inat_init_tables();
 
+	/* SEV-SNP guest requires the GHCB GPA must be registered */
+	if (sev_snp_enabled())
+		snp_register_ghcb(__pa(&boot_ghcb_page));
+
 	return true;
 }
 
diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 733fca403ae5..7487d4768ef0 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -88,6 +88,18 @@
 #define GHCB_MSR_PSC_RSVD_MASK		0xfffffULL
 #define GHCB_MSR_PSC_RESP_VAL(val)	((val) >> GHCB_MSR_PSC_ERROR_POS)
 
+/* GHCB GPA Register */
+#define GHCB_MSR_GPA_REG_REQ		0x012
+#define GHCB_MSR_GPA_REG_VALUE_POS	12
+#define GHCB_MSR_GPA_REG_VALUE_MASK	0xfffffffffffffULL
+#define GHCB_MSR_GPA_REQ_VAL(v)		\
+		(((v) << GHCB_MSR_GPA_REG_VALUE_POS) | GHCB_MSR_GPA_REG_REQ)
+
+#define GHCB_MSR_GPA_REG_RESP		0x013
+#define GHCB_MSR_GPA_REG_RESP_VAL(v)	((v) >> GHCB_MSR_GPA_REG_VALUE_POS)
+#define GHCB_MSR_GPA_REG_ERROR		0xfffffffffffffULL
+#define GHCB_MSR_GPA_INVALID		~0ULL
+
 /* SNP Page State Change NAE event */
 #define VMGEXIT_PSC_MAX_ENTRY		253
 #define VMGEXIT_PSC_INVALID_HEADER	0x100000001
diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
index 085d3d724bc8..140c5bc07fc2 100644
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -81,6 +81,22 @@ static bool ghcb_get_hv_features(void)
 	return true;
 }
 
+static void snp_register_ghcb(unsigned long paddr)
+{
+	unsigned long pfn = paddr >> PAGE_SHIFT;
+	u64 val;
+
+	sev_es_wr_ghcb_msr(GHCB_MSR_GPA_REQ_VAL(pfn));
+	VMGEXIT();
+
+	val = sev_es_rd_ghcb_msr();
+
+	/* If the response GPA is not ours then abort the guest */
+	if ((GHCB_RESP_CODE(val) != GHCB_MSR_GPA_REG_RESP) ||
+	    (GHCB_MSR_GPA_REG_RESP_VAL(val) != pfn))
+		sev_es_terminate(1, GHCB_TERM_REGISTER);
+}
+
 static bool sev_es_negotiate_protocol(void)
 {
 	u64 val;
-- 
2.17.1

