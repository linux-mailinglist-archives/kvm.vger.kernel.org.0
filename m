Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4D3347E07
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 17:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236750AbhCXQpF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 12:45:05 -0400
Received: from mail-dm6nam12on2040.outbound.protection.outlook.com ([40.107.243.40]:48321
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236578AbhCXQot (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 12:44:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K7c6T++51IzeXtfFCPf9Kp6OscytAjK+P21+rDHh166A80i93T9MKEdVE02N0QcNH4rYm7RL6Xd+1o56Ft9qThiQFPIs8NsgjI2ciY4xbluyFwBdRTw8YfFgKzgrldX48t5lEkA00mKHRzUqy4BZpytVCZStbJUXn5/VE/qbBAb1EXoBfqz1+Ye/zuJY2hIWBqQdSFMWTiRgU2vI2UertFWSws0bdALswxZYRbIWsi1naHGC8HjvlLfaVy4MMjbhVqTlJdsoMeuDcA0pWnJbL4xH0hJyBuhidw65kaFIetTjlcwTri2j8NhWlrnzhwgopPIofEz7jkeMss6WOI8OZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e566HnZdyqwgQx1ZTgwNyzGqJzwbMBkOq+Xny+ol1mg=;
 b=O7APUVL3DunFbdHywpbMcWxQMbAm2s+vo5mlFiiMr7XUbBHYxp/MfJhBGoabttbe2mJ+Gyc6sQWcRCOYocZYEfmopcDjE8iHU4HGlHi54mWJeHlIhId02dzzIdMfosNv68r7czrVT9tGl327gkD1UJgBro+J2SBIxhM4nN8ssMDypY4r/YTv89m/Mq3IQ4QWl6f+Ro/CM4et8zeFuoC/u+0xtIfMW9sLCGGlZBhDX+cE5qTmbGogpc+Ets+gmxJS6CbK0MzFS2JB8uH9dKTvIqEZ+q/3+DFE/6e5559yk5mUf2+O64NSl6t1PhhUx4cYzWigNyZGhUF3222aveJ2Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e566HnZdyqwgQx1ZTgwNyzGqJzwbMBkOq+Xny+ol1mg=;
 b=M/pRmcHw/nKvdz2l0n0Af5dmviTYIW1Nn1sjADAOUCyvMPgSq3spPkSIE8+nAsGEoMyjdwc2ms4de8vi8PmhBH1HZNEFd8Lw6Rh7RcMTw+9pSac3A2ZJaOIqAalvPbRWbcZvlVd873I4m2/PGallXfc3Xii9svID7xwOwSAGW4w=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4446.namprd12.prod.outlook.com (2603:10b6:806:71::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Wed, 24 Mar
 2021 16:44:46 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 16:44:46 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     ak@linux.intel.com, Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC Part1 PATCH 11/13] x86/kernel: validate rom memory before accessing when SEV-SNP is active
Date:   Wed, 24 Mar 2021 11:44:22 -0500
Message-Id: <20210324164424.28124-12-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210324164424.28124-1-brijesh.singh@amd.com>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0010.namprd11.prod.outlook.com
 (2603:10b6:806:d3::15) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0010.namprd11.prod.outlook.com (2603:10b6:806:d3::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Wed, 24 Mar 2021 16:44:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f2be7a25-868d-41b4-8fb0-08d8eee421ec
X-MS-TrafficTypeDiagnostic: SA0PR12MB4446:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4446FE9898A56CF3E248BB54E5639@SA0PR12MB4446.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +R6sUKtHFC9b3YiE133dmtjamRL5eCe9N/T4L+PHLd8qkn5rhh+pTB80nC5NvMiS7CLw+ywLOp6fU84andBzBko7KgaUwIZv2E0dbwmak12y8QWn7P6Fs+OEe1wkupmYI56G7X/nvnc4E5pCkVI9PKWlPFmhbmrc6VYX+PwTkS05I0Kknz8Tdj0RQ1BuoF74IyapZCcsbuIIvvkLA55SpVs9WbAMgWgReCkwNwgarF/vGx9phIUit833IwPqjnxRxThFYMAYZf+6SXmil21FNnmvao4N+h8O5t9wCH/GMVf703NzR9+19vzrBTth2HstcvTDzBNgXr8lggIUyowBEfcFqPlnDLm07ilo1IHrQR/yY2pH54RGpSnfRtqrM0abYtix4I3p2HN+XUvGiFQw0hrUsbmUgbzL6+s6DghRa3KLZPsxTBIvRcZS+8GjB2rs0Ovdql6UMCLsPdc8ceoAHSvPoU92If0Zjuosd8MooxLWJYr5fVmCAsplkINz6Pl5fij98qv1p9nsjvIJesr/bMQR0veXLPJWJTvfQPCnpvJeVn2n4R8BbNgtl2M4KhDNS5v+w2D4VKteDCRYC7GXNatlww2wb4Zxs2UAyFDNuEHwVgtdRPQXQNcSwJa/5UOuo5pOUKpXzH65jn3r06AeIN+8ii6/PLTuFqtKqzvVLnQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(366004)(136003)(396003)(376002)(8676002)(1076003)(4326008)(6666004)(38100700001)(8936002)(956004)(2616005)(5660300002)(186003)(66946007)(86362001)(44832011)(36756003)(15650500001)(7696005)(6486002)(7416002)(478600001)(66476007)(66556008)(52116002)(316002)(83380400001)(16526019)(2906002)(26005)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?fLYkr7ovBU3Ber/o43b+6uM2ADvTvGQBlXGEg19Ifqz91KvZbgJTlNDj6lNR?=
 =?us-ascii?Q?crOyBh+dr69uDK2bjod7yVbr6/2w+ay3hs6A+4HS729B/FBi3DOwT4CN07+p?=
 =?us-ascii?Q?O7+NEdJsXEZSVBfQa+TnkoF2Kke64NBPRRyHmeZsiwNhVXMB3QnlPXRH1JkU?=
 =?us-ascii?Q?HtkD0mRfTUMe10WE5w33RYR1pklOHcVT2Z5UAMAmwJKH2RKkqWT0JzAqvGfZ?=
 =?us-ascii?Q?8sd13uELXKTI79t+KFe1vXhVCckVO+gcpicu6/mArIG2/m4F8BlpmwJDbRw0?=
 =?us-ascii?Q?WJFRmtQxgDiFmotuPTP5Zl0mApuv7RCwC1tqmRhAqMQO+KSNL5vJATjqysbZ?=
 =?us-ascii?Q?eFUHmHjg9wqWeNg+X36X1YKSTmDSq+/S8rEfJ32pbIwgsch+y+x06oMCotSM?=
 =?us-ascii?Q?npRYm2+oRvjgXFHOXJSNYtyml4XQ+meuZu/2pFcgPR6pFznv7AOsl6ZiXrFe?=
 =?us-ascii?Q?l5rl4aE6lZdAPdX4OGpWWkkPj5KiokHAVTNyAZrzdknkrWd+FsHT1M7RsMMo?=
 =?us-ascii?Q?5VNcyJmkYXviYc4CQytCJzay+SG5ucMrLyFBQKNYrrG4M8XqQGcSm+HNlqEM?=
 =?us-ascii?Q?XYNwLzLLSszBftcBvmAqkHrvRe5fJ8g0ASkc9eNfu/q94U3ZxuT699reu/A2?=
 =?us-ascii?Q?N4ptLyps7GRCNs97zSl3vHYWRBON39J9cB8xLSR1AGmf0ld3Wz8OPofiVOT4?=
 =?us-ascii?Q?tETK0CNqEZgUjz9mDec8HnOomvSFIlyb1cKENPH1X+qbZtOWSkgPjOv66f5L?=
 =?us-ascii?Q?SNq7LZ18dkK1ofXkihpu/Xejxn/u9ZsRKS0Y3oXPLHCPzi7O8FbwIYECKqi+?=
 =?us-ascii?Q?1tqAoZt04sbJmImPNNFjunaxcacrMpjB7LjBw/jnFpcENvsp7FJtQ7t1ktAB?=
 =?us-ascii?Q?ZRV16whA79iZyCu5WeCGkxStbYfTpLizBz94UtErwHcwoTAT7GIKOZgHkike?=
 =?us-ascii?Q?mwxHqybHLqvEMpw2czi6hbJxTY0T1ototB49ohFuGKes9wwph0p7R/n0engu?=
 =?us-ascii?Q?ghBmOUUxRu3QS2XgOusY+bh9FpKU5yc2n66JKA2isN4T7hLy7nZUbWYJ8m7Y?=
 =?us-ascii?Q?DoNpHjsL55jJr4pSNA7B8xq1qVksFM9Ri/G8Ih68xXgrA7XmdhxJCny7XY5m?=
 =?us-ascii?Q?igMIfY0gTgOusrSHWkT+KLmhvWPrftw/USzYqp93lm5u2GvL7iI5EotjrXAM?=
 =?us-ascii?Q?3q3V6+When3HHiy+UJyNX8ito5x2PlFnyOKBoTtr8gBCuqq9zYVhejQlB0Yw?=
 =?us-ascii?Q?Xm14zhSiL/7nqNx1CEmP3OVcfvN+vSletPNMUsMd+GZ0r7MOyFBAe/+k+OUP?=
 =?us-ascii?Q?BrveD7bn4IacXChtWbrfZOvz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2be7a25-868d-41b4-8fb0-08d8eee421ec
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 16:44:46.3499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: brEqRRUhlbrcjtJkUmGeRm/2ebEwqYOe1g3J1+3Es2bLtXxYI+KnUWVauuaVWOL2U8zBgm/rfMdmZtMY2S90Yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4446
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The probe_roms() access the memory range (0xc0000 - 0x10000) to probe
various ROMs. The memory range is not part of the E820 system RAM
range. The memory range is mapped as private (i.e encrypted) in page
table.

When SEV-SNP is active, all the private memory must be validated before
the access. The ROM range was not part of E820 map, so the guest BIOS
did not validate it. An access to invalidated memory will cause a VC
exception. We don't have VC exception handler ready to validate the
memory on-demand. Lets validate the ROM memory region before it is
assessed.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kernel/probe_roms.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/kernel/probe_roms.c b/arch/x86/kernel/probe_roms.c
index 9e1def3744f2..65640b401b9c 100644
--- a/arch/x86/kernel/probe_roms.c
+++ b/arch/x86/kernel/probe_roms.c
@@ -21,6 +21,8 @@
 #include <asm/sections.h>
 #include <asm/io.h>
 #include <asm/setup_arch.h>
+#include <asm/mem_encrypt.h>
+#include <asm/sev-snp.h>
 
 static struct resource system_rom_resource = {
 	.name	= "System ROM",
@@ -202,6 +204,19 @@ void __init probe_roms(void)
 	unsigned char c;
 	int i;
 
+	/*
+	 * The ROM memory is not part of the E820 system RAM and is not prevalidated by the BIOS.
+	 * The kernel page table maps the ROM region as encrypted memory, the SEV-SNP requires
+	 * the all the encrypted memory must be validated before the access.
+	 */
+	if (sev_snp_active()) {
+		unsigned long n, paddr;
+
+		n = ((system_rom_resource.end + 1) - video_rom_resource.start) >> PAGE_SHIFT;
+		paddr = video_rom_resource.start;
+		early_snp_set_memory_private((unsigned long)__va(paddr), paddr, n);
+	}
+
 	/* video rom */
 	upper = adapter_rom_resources[0].start;
 	for (start = video_rom_resource.start; start < upper; start += 2048) {
-- 
2.17.1

