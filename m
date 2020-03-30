Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2051197211
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 03:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbgC3Bgf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Mar 2020 21:36:35 -0400
Received: from mail-eopbgr750077.outbound.protection.outlook.com ([40.107.75.77]:21057
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728176AbgC3Bgf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Mar 2020 21:36:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EMSb66hNYPOsYx6LsMXGtYoI0NJeC+i0/aMekiLoNjawUzcy+e8UgEnPPV6KMeCr0wcKMZN4xJiDm3pqxZYJzJSSUdF4oBDweltzhAMOezouiDauplQD1CftiYfaPl73/9FsknySurkrPiP8etiS54bc4pXKvCeSFIyikXDZkLN7zSznttayhr2tyX/RxAdDrxIz/u3/4KpnQhAAbqslKaDknpFNPuZD1s/XMMlkxygonReTSB9SrNK2LmPKXJKrfr6pNDyqlFzda8RQMGt5biJU+agvpx6KRlte5H9gBrgANOmMINDxD6+4jRkObEpP2BExFuT4Sh4B/cBW8qeHSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SwLWA9i8h3stz9l2IVcM8HURce+9OCTaQnNc0VFSdHs=;
 b=TRuRLd4SVoEwIbXi9Idh9fi2c6uCEV2o5d6eNf/iFXadVh+T/vovGXzKjiOL+hSXPoT55PJveMvzK6RproovnRybOPnZHD/KldTI+iY+q6Rkuk7UOeggnSJwSbyvOnWMcq7itk66VVxjwDBIk5+QadCLsTbX2Pn2qou8QvReVzYK9RSVe/+3qVNSJBUZYbD1klsvylUSEmt6UNXYmmOJF4x9ZBvBPFn2oO3uFHS+yClLLhAPjxqmw9HQsRm8EVLoPP81qOkrHB7sqsVJ3eK+xJ7m/s23zG72myhr/5pkgzfYZBIO3hf3ROgbMepGt+tEkhVqShG1cpOKsZVMTN6zOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SwLWA9i8h3stz9l2IVcM8HURce+9OCTaQnNc0VFSdHs=;
 b=RMdJnJeyjDhAf3L4oXub4aXOzV1rRpYwKqJE+dp4RcEx6LEYuJZKpgrn/EJVTPnznrPHgdK3RLNeksfvc15rPGNvqy8hLaGcyN8QP7ecQw4PDuLxu1EvzLshpMt220yjIJSfhf/ozwo98LqvTNfJkGDmYt8RHrPG9IRXVRcOzdU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1387.namprd12.prod.outlook.com (2603:10b6:3:6c::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.20; Mon, 30 Mar 2020 01:35:58 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 01:35:58 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, srutherford@google.com, luto@kernel.org,
        brijesh.singh@amd.com
Subject: [PATCH v5 07/14] KVM: x86: Add AMD SEV specific Hypercall3
Date:   Mon, 30 Mar 2020 01:35:48 +0000
Message-Id: <6dda7016ab64490ac3d8e74f461f9f3d0ee3fc88.1585531159.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1585531159.git.ashish.kalra@amd.com>
References: <cover.1585531159.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM5PR06CA0058.namprd06.prod.outlook.com
 (2603:10b6:3:37::20) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM5PR06CA0058.namprd06.prod.outlook.com (2603:10b6:3:37::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.18 via Frontend Transport; Mon, 30 Mar 2020 01:35:57 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 41ac7aea-5fbd-4aba-7db0-08d7d44ab233
X-MS-TrafficTypeDiagnostic: DM5PR12MB1387:|DM5PR12MB1387:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1387775531826A314CA7C0688ECB0@DM5PR12MB1387.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(186003)(66556008)(6666004)(66476007)(86362001)(6916009)(66946007)(316002)(4326008)(7696005)(52116002)(5660300002)(6486002)(16526019)(26005)(36756003)(478600001)(7416002)(81166006)(81156014)(8936002)(2616005)(8676002)(2906002)(956004)(136400200001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GuB3eHnoVP5143bM7kEXZK9KX3JfghUgkamiuDgkDQSFQ2wr9P2S3ri0rSAundpUtDo5p5KRmhb4c0elxOAbND05mtMXejo3Ks/uytSDyMAjH13Q7o7uDKchcgc+ODdYEJQeOUDTnX+MXqA1y34flr2qQxJUuwSZW+JuhEekoDIZIx0v1gDi/cw+/LGU6vgOLjnBIGKwNBA8HHx2eWeGri4tha6ojaBxWADK7soDzcuHr7kSsm+7g+qqleEGLR3r8PvKrnhofIIidczg1cYET0mbZN0aceIbhnPSDtNPZuIPRJe9Hlm0/CNphvJecz7aqg7AZbOwbbWUxiXucK7Yki/oK6c21A8JOMC2XtyphHmUvkzdi5iNeaez9brKwSphmyHTymzUHK3wL1JzUqTXCo4rn8f+fxBEnBEYgFZ8NfsDYd3GJzwu0ZeV0eqRajlxxhcgdu/db3bJBES5WAr02sbrVVrL5GC45BaB0AfrUtjL/aXd+tSGSi4mGR6SEsUR
X-MS-Exchange-AntiSpam-MessageData: v0I7+m00drJ3Ml2O4U5JxNOt8bHIaoo27XM9CArvCLsL+TeZhPOKWLxM0IVI6aLLKwaXjrWVs3p6gS3UJVho3MeAF0VcSd514GDn3odbM15QubJWbNtue3trQ+VC6hawO+ze8fh6RZnKz23in0M5IQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41ac7aea-5fbd-4aba-7db0-08d7d44ab233
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2020 01:35:58.0511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9VscI1GF2fKHg+0zFf7j5IppgdT47KzSsLfYry83WCd+NKmM22Oz2MtxVurDt9L9ow3mzXRLtQ8ZieKvmrRSCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1387
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <Brijesh.Singh@amd.com>

KVM hypercall framework relies on alternative framework to patch the
VMCALL -> VMMCALL on AMD platform. If a hypercall is made before
apply_alternative() is called then it defaults to VMCALL. The approach
works fine on non SEV guest. A VMCALL would causes #UD, and hypervisor
will be able to decode the instruction and do the right things. But
when SEV is active, guest memory is encrypted with guest key and
hypervisor will not be able to decode the instruction bytes.

Add SEV specific hypercall3, it unconditionally uses VMMCALL. The hypercall
will be used by the SEV guest to notify encrypted pages to the hypervisor.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Radim Krčmář" <rkrcmar@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/kvm_para.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 9b4df6eaa11a..6c09255633a4 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -84,6 +84,18 @@ static inline long kvm_hypercall4(unsigned int nr, unsigned long p1,
 	return ret;
 }
 
+static inline long kvm_sev_hypercall3(unsigned int nr, unsigned long p1,
+				      unsigned long p2, unsigned long p3)
+{
+	long ret;
+
+	asm volatile("vmmcall"
+		     : "=a"(ret)
+		     : "a"(nr), "b"(p1), "c"(p2), "d"(p3)
+		     : "memory");
+	return ret;
+}
+
 #ifdef CONFIG_KVM_GUEST
 bool kvm_para_available(void);
 unsigned int kvm_arch_para_features(void);
-- 
2.17.1

