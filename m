Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0650236F9EB
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232454AbhD3MSI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:18:08 -0400
Received: from mail-dm6nam10on2049.outbound.protection.outlook.com ([40.107.93.49]:15328
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232280AbhD3MR4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:17:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ud+Qqn4m2q9wiGR9G36AlyyQ/6QtoKNZIqx/drpMFOP50rITL6vr97Z5HegXpF6vS/+iAKqUbqvyswpGURCgiIhKX2EMWhZJr2jfUBNBnggOL3TH6Kr1pX5bN+ZlvFNHcFQsSR6zRu6k/s78O8uvN5gR1pqEHqZ66syXEud+OKP0bG4YIfqHCxpLziOKYxTKF1Y7KN6FKA01PWzFK3G4srLYNRQVGV2vxluyiH/7Gbx5SFTJ0LP/oPnZjXnPwlr9OL32cJK4swBOo+l+B3Y+Cx574Z+cJeehkTXrIlzGdbellAPs7BqDAXWx34vVfa/JfL+wf8WWy+Sq8csMJoPy3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v0rfvJ7o1K+3Q7drpLS5ezsU0Cf1EqtBIR1BTIor6Bg=;
 b=LVi9Nwc+ygAgDbbY34CsQd7NX0HkI6oIBm/R3NZi9MvVh9sXfvzCs3DsFtQhHPnrfQJnCqJHppj8mGamDYxOLf5toebyOXw0Tafmq4ZAiBfaCRsS4A6qptoe6HnF2Ww0GYfEXq+0rDiC8Vrb1IaA1bCsZGIzd7AX+hv3zMTNFz5claWBxJZddhS+XZSD7KVG+zKb5wqAD5NyrNzaq4wAfYaIeC4zWmiC2nh3vBYl+Z4GA/8srqLhYf4DEb3YbgLYclmxG99yBQFGgRGF9xpTcQIb3Dll7x2zYVMBH9KkfPstnhP1RYUQgcaw31SnA7sWEcB1MQOgsy0t/pq5/iMlfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v0rfvJ7o1K+3Q7drpLS5ezsU0Cf1EqtBIR1BTIor6Bg=;
 b=ZxG8Oztj2HjtgUIjsfASfLQt36fLVliR8rRexAaJrmFkSe27skSTCaAFYyoOlfB9WHIsg/WEqATdWABXdfouIbLNld+Y9dbTSOPLB5pWCwjSjEovm7KjWPicgbIciUCJrTWDZkeipXf4C9xW/t4QNbEnWX2I6p1GO5QMq1F6nxU=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2640.namprd12.prod.outlook.com (2603:10b6:805:6c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Fri, 30 Apr
 2021 12:17:02 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:17:02 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part1 RFC v2 13/20] x86/sev: Register GHCB memory when SEV-SNP is active
Date:   Fri, 30 Apr 2021 07:16:09 -0500
Message-Id: <20210430121616.2295-14-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0401CA0021.namprd04.prod.outlook.com (2603:10b6:803:21::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Fri, 30 Apr 2021 12:16:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd7d1bc6-729f-4d58-2e4a-08d90bd1d93d
X-MS-TrafficTypeDiagnostic: SN6PR12MB2640:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB26407C699AC9D59023A0176DE55E9@SN6PR12MB2640.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J0Ht+AwBBe9M3lQLMnhlNgC/gFKqcdH9zzVQKsj5UHLCRFRx8GRMuXLFiKTgUmZLdhrL89sWfWZdBfpCQ9Vd+xpqw2N6aIZEK8n8JiG80pj2Tfn+mm8dS1wRFM3xyLx1rPx9U/j2nGEVQcFajhEAg9GzlTSYZUrRT1ozjBBe4gLxhUMCZutt/soYoqcuvvFY+F/ekzd3DUIhW1+HzbB9vCfJdWPY8xbmd5fONWqWqDQgiyTNh3HUOSWjvdXEm1ED+qC0V157NQv6nXaNMpanO6IoCXHlbTHLoUV+liu1GI8TILsD2DmRbcNfPelL3g1QABubUWxCXfN9W0nZDlfeSd9tmRzOKyJ1XfWSt7EDJbxlw/YMWEIsPU8DUrCidx8VFCftUfJzhuFRiz9bl2HxQXkOf4Ohr9cq7HZPgojoWcLmSr52eomdcm0H1Ub6tyFEaXgU7uv9W+2vlz0D4qnK7+27J5jy+DRPVdgrobmNegYfLr/T1qFooiNezYqPSzufIERzsjFgwBkrHfLkI7EgpWKuNiovVjvq/vuBiWAEFX9iplcK1se7o1bgfbWbDRqRWe4K0Fp+8OzvZAqVNBb4rV+IF2c/IyI41wXg68RgEYrcZwBMZrqnzHxsHw4ZVQHcfYf15hGN8KW3SzCm/MmpJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(376002)(366004)(396003)(6666004)(52116002)(7416002)(316002)(16526019)(2906002)(36756003)(186003)(26005)(38100700002)(38350700002)(66556008)(66946007)(5660300002)(1076003)(66476007)(4326008)(6486002)(86362001)(8936002)(956004)(44832011)(2616005)(8676002)(7696005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?KdMFeG7nw1dp9TXurs6tIp3ZYKNC9ut7v1IXo5TRpgvlI7m+YX0ZsJwsc2H4?=
 =?us-ascii?Q?wph6vaV46C+oab1V/XtsQLnXamP+8mnvunJTubf50Iy9cp2b9QTB0g3CIxyG?=
 =?us-ascii?Q?QSqExEnv87Wnsv5a+GnPBjL7ZZN4DWz3FPkq7BSKClt9IielLx9XtBC2dq/k?=
 =?us-ascii?Q?TBzGibgIpAvOGzq8cnWMZu35lMpe0lgoayIiZC6u13WbjZOE+28U1AhN0dtY?=
 =?us-ascii?Q?Wtw3I/gTfFK1uc6Tmq6Pc1TZHChAny6S/6sOAe/eWcOl7AQTdrcEHvAOZK0L?=
 =?us-ascii?Q?ao2PggKkp0ZnXg8noVYcnPa8hTGyUzv22UeiwwFiOrAPRFG64uPDwQAFfKl7?=
 =?us-ascii?Q?5lNJ9kDBsSTBFiLaNjsce4HmRucIN9PCXAJBkgUqJn9z+3L7GQfwDVp12Hag?=
 =?us-ascii?Q?w1Pfzqklds9vT+5pcQuS6UwStfa2qUrx6E6DGIiJ/+CJ6JwAE6xv3l2RnXXF?=
 =?us-ascii?Q?O4FTsk+gF2QwVNvgKP625H24v5j4xEnL1K8hj9BThNJZDrV0KVaSXHoKAqBz?=
 =?us-ascii?Q?U3dxjhEfRr7ib0teQhji+qn1i1W6WqHARx8xmdosmz7HxEANDcd1EbMYIZcW?=
 =?us-ascii?Q?9NXOPNglyKgvKXjoTq+NjKa6pwaqZgTxsnOt5kwgxIsHiVvXRiiQnWApOJhd?=
 =?us-ascii?Q?dp4Hq616vM85IAU3zofX0qKWAWtyAKtOP1ienLeDlC1x/kDJM6Vy1VCmiVYu?=
 =?us-ascii?Q?mq7YnG/snsgLZxxsg/LmS56tTYCkYF8ENbb5TPVEoShuVxbBEIwAz2y8otR8?=
 =?us-ascii?Q?TjOMQsSRNASN9C9EqUbtuChnVsi7PnD44EL5EBUu009pLjGy06ztsIvg4WiV?=
 =?us-ascii?Q?71Q9xJqzCZQAbwkK1cKLpnKdQSwZipoOl0hIihjHNH/r6q0NSTCq1MEAZqYN?=
 =?us-ascii?Q?5srMD9fPWUK5n7oWPxj75IotYaz9CubMDpSyEECnRxn2jMpyorH8Aqhc35ni?=
 =?us-ascii?Q?HPA/sVvjRIwyGy+A3QkeKb4r7MVLamh5tz0bEH9TMOM3GrY1HCctpXubAWHT?=
 =?us-ascii?Q?E9TxYFtVddM8stQL3zYvcXwRXes8q7o2jIHU7VuAQVceiApUQkw1wQB36K5g?=
 =?us-ascii?Q?hKMpy9fMItB9C/lMcutuAcHrocjmLepdUUCc0bJ/6Db5gb9R0YlQH+TN3RJ6?=
 =?us-ascii?Q?xSe6EV89t1OxS4gdvklFUV2zWKTAo1qnqApNBAg1kd0NJPRkAizpoM0DkqX2?=
 =?us-ascii?Q?PhWSihREzipcRqGNryrX8xMhzh/YKdWzUYeytfdmK0ZadDc1XbZ2F+2fnatm?=
 =?us-ascii?Q?H2/9UAI2DcGCt8eGNXBnQBAxd97K0RsZ3h1RNLRrAFYiuWDb6zjq0RqyL6nd?=
 =?us-ascii?Q?QehVbODE79Ua3meCKYiONkMa?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd7d1bc6-729f-4d58-2e4a-08d90bd1d93d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:16:57.1940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jfQTKHSF6EV+Zl2lkah6Tx3kn5crWFJjv32GQiyKThg2w/BsVnRRxqk6ZYbFKZ7CIX95d5/oTF/b9CNCauQdwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2640
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SEV-SNP guest is required to perform GHCB GPA registration. This is
because the hypervisor may prefer that a guest use a consistent and/or
specific GPA for the GHCB associated with a vCPU. For more information,
see the GHCB specification section GHCB GPA Registration.

During the boot, init_ghcb() allocates a per-cpu GHCB page. On very first
VC exception, the exception handler switch to using the per-cpu GHCB page
allocated during the init_ghcb(). The GHCB page must be registered in
the current vcpu context.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kernel/sev.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 8c8c939a1754..e6819f170ec4 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -88,6 +88,13 @@ struct sev_es_runtime_data {
 	 * is currently unsupported in SEV-ES guests.
 	 */
 	unsigned long dr7;
+
+	/*
+	 * SEV-SNP requires that the GHCB must be registered before using it.
+	 * The flag below will indicate whether the GHCB is registered, if its
+	 * not registered then sev_es_get_ghcb() will perform the registration.
+	 */
+	bool snp_ghcb_registered;
 };
 
 struct ghcb_state {
@@ -100,6 +107,9 @@ DEFINE_STATIC_KEY_FALSE(sev_es_enable_key);
 /* Needed in vc_early_forward_exception */
 void do_early_exception(struct pt_regs *regs, int trapnr);
 
+/* Defined in sev-shared.c */
+static void snp_register_ghcb(unsigned long paddr);
+
 static void __init setup_vc_stacks(int cpu)
 {
 	struct sev_es_runtime_data *data;
@@ -218,6 +228,12 @@ static __always_inline struct ghcb *sev_es_get_ghcb(struct ghcb_state *state)
 		data->ghcb_active = true;
 	}
 
+	/* SEV-SNP guest requires that GHCB must be registered before using it. */
+	if (sev_snp_active() && !data->snp_ghcb_registered) {
+		snp_register_ghcb(__pa(ghcb));
+		data->snp_ghcb_registered = true;
+	}
+
 	return ghcb;
 }
 
@@ -622,6 +638,10 @@ static bool __init sev_es_setup_ghcb(void)
 	/* Alright - Make the boot-ghcb public */
 	boot_ghcb = &boot_ghcb_page;
 
+	/* SEV-SNP guest requires that GHCB GPA must be registered */
+	if (sev_snp_active())
+		snp_register_ghcb(__pa(&boot_ghcb_page));
+
 	return true;
 }
 
@@ -711,6 +731,7 @@ static void __init init_ghcb(int cpu)
 
 	data->ghcb_active = false;
 	data->backup_ghcb_active = false;
+	data->snp_ghcb_registered = false;
 }
 
 void __init sev_es_init_vc_handling(void)
-- 
2.17.1

