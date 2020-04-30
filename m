Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6844F1BF32E
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 10:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgD3InG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 04:43:06 -0400
Received: from mail-mw2nam10on2065.outbound.protection.outlook.com ([40.107.94.65]:30768
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726661AbgD3InG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 04:43:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O/zDqBU8A3kGYxaw0UcUFifkrPA2+m0SO85agWkED4o26C9PXpKVRyKPX3DnijZkTybnBvtn78nCNXCiynidORc44wnuAg4GT0VcZg7xptM5Jsg2Y/GeQ/g8gwTVV0KIxM+uBHGmVUQ95DoJywKgCuo53cXTe3Nh3X4VexsPmsQNTybU/ME60QTIBIDtqDCEamqiHzXwsjRKjuS9YITxoOJwDitgZFHI1PONl1/g5RVMxFlgbEaCI+1kyFavPS45PsisLYKVdlvFCVvBMxGHqxklprC1P9iQ2DcbH4HdFWx+z1AMQp3di4DGeJGJv/NIcNCHpt4Ta5/5SqHEb8kNFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kg80pzkz3epoBCgvmHD4sEajd/FQGSuBjGWFCCBN+lM=;
 b=ksMJB1jtlnNEy40yPTImUaBP33kQqO6CFc7RHnE0iTjYAt6VOKm2nMDJO8PFC4URLbxrNpV62q/kYnVxCPB93sS5kJ9F4Aippeia8yjBEN7Uvuma01myWahN4znSEda7hxOvYkwgZT0CFPupSgB921f6+3+Ox9zdV3+PkAADcJO5kyCk704+vs0RQUwpqSOKX5FEiXcUV9hNlIKWyeYy1UtWBYnKL3l+toggjSblDbJzlop2HV+SxCHDCEXdjJqCglwpdNqAZQjqSXxgSCUub0sBnv7EsqXAQUjH+6PBsaWaxiVLCIU6VJyPn0L4+qD5jCzsOgE2+6PGHP0axMJ7tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kg80pzkz3epoBCgvmHD4sEajd/FQGSuBjGWFCCBN+lM=;
 b=HUi1gnjvCHRZN5Ru4r/uKdfYUhLfqsjNA13GSjN2xIj58qKaSPvza+Zb0mO0P16qofkAF3Dxrl3Txl5Zt7Wo98gZHjtvdmYnzaj+jLtkncO757sJuCholdZM3fan5U4FI6kQ3Aucbm4wyjJb1Wby0jSKG+oK8BlPAsDtM4WMxug=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1883.namprd12.prod.outlook.com (2603:10b6:3:113::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.13; Thu, 30 Apr 2020 08:43:03 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 08:43:03 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v7 07/18] KVM: x86: Add AMD SEV specific Hypercall3
Date:   Thu, 30 Apr 2020 08:42:53 +0000
Message-Id: <abddc9cc1e6d5b3ba96bedef8f12d2bb4bf80176.1588234824.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588234824.git.ashish.kalra@amd.com>
References: <cover.1588234824.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM3PR12CA0116.namprd12.prod.outlook.com
 (2603:10b6:0:51::12) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM3PR12CA0116.namprd12.prod.outlook.com (2603:10b6:0:51::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 08:43:02 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c82908ea-3c68-4e77-1ea6-08d7ece27eb3
X-MS-TrafficTypeDiagnostic: DM5PR12MB1883:|DM5PR12MB1883:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB18832B2D41E97FF893CED45E8EAA0@DM5PR12MB1883.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-Forefront-PRVS: 0389EDA07F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(366004)(136003)(376002)(39860400002)(478600001)(86362001)(956004)(8936002)(26005)(2906002)(2616005)(6916009)(8676002)(36756003)(6486002)(7416002)(4326008)(16526019)(186003)(7696005)(66476007)(5660300002)(66946007)(6666004)(52116002)(66556008)(316002)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RwC0IcVQsAhLhb6DgkRVZXIvbv9J8AZ4qOfyLaMf5zHspS4HH/eld5leALr0JehMmDeRq9GvlAd+OiNlOFmEt3G8ywwzodQ1HXGHm6ksX8j3Ygy3UBO+RJWW1yeZE42RAfjSf6GkNN/0jV/Miac8WiHL1B1W2v+IjWd7Hp+/CdWLCi3dF6FU5jRpXJ9v7Q4a7oOzS0iy/hDvSEK9Z3YC6zA2y6v0Alf5FQY0930OAgkrZtkzzdJx29+qgLuM5F2rpTvp25grneBkAH6CaycjQy13ik26PtrzujWOSiPlb6Cf/no1oGl1Y50L2Y26ydncKUorkAppBSGRGaPxfTWAUUTWNQxUrjCn76rnnLPWhmX2uHrzoY9oRhla91ObaN5r0iYnrJPk0jxqO/Jvf7eLymTohuos20ui0vl64TjNmilnmLtYN/W2ygPBeGqoE8gci8zdcZctx300/D56RSjdDpaUNQ6xuF8KWwskxa1Y4Ls2QuDI+/5Jp0uep/evaRAJ
X-MS-Exchange-AntiSpam-MessageData: c/maZRnvK8uT3A1CWcwKtdFAbl5UJ19O4H4DVbu89jUlwhk0DnclbMwvfWolNKf70nfUgE93f70dnULcwM4ysheIwzfgZCqRblI1/OWzw6DGKlGbMO1pTxy0m4Q+DMOIyaKXfy+D/I8Ntrf4CLroxQdG0GKOIQuAmtgpdKKzEuNCNYiIGw1Ma3b7YhSEV2hKbyNMJSfgtpq+f8d7Ebw1xyq5/PSvYWiQ74xfuvtI96AonnEW3TCoQ/A3Ymojly4jNioa3BJ3u5em6jEKY8qSiWuAg7H4OB4AYSTkliYPSxkXXMg56JLjk8LuY8NNxWIUBXgljXGwAIl08t5u77pXpkLeDyi3001pGecPxypS0I+jQyUX2z3Tfc9PoeYbrlFc7z+hHxkuxb+YdgCjGMkV/IGQn+VYyIyQ/VZ5jcKhnwZ+d2IlfmzGp5Ff+TdwKWh350acNY7HuhpVL4xGK/mhq/OkTDDHfTafo5zK7O6sHR4mKluvdPtTAdO29AX4r5fNFq/EyhiIDilU8lbZ+L52hNDvqCzmGL7j0/J1o3jKunXBTocM/gzWyWLnPylvKxBFrmpJTBy+lrsQZAGSsZQh55UCYuI7/PWtV7XA4k+aIWPoGWdCua7DeCVDbNbaEKlgnFBPI9H0iv2kRnqPLlFwGAmhOhV7qiGLCLGzPT9kznE4rHsctA81WAe5sOjaHR+RCVuFNJLoNDSK9PhA0R7xtnh3odfY6Wik+b048DZeXRWfFlbOegq6QfuiIBIbrrbuyukLDdUkMVaXBZCzUwtfMQEm6y7bSW2X7L7P80C9tb4=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c82908ea-3c68-4e77-1ea6-08d7ece27eb3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 08:43:03.0935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7b9qMoAbKnd+MogI7J/rCW4RH7rLF6rMl9Wh/+t4CiUppX3ptHFkZcgan9kR9xF3wGoZtFf4dJY2Zvhv+PkyIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1883
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
Reviewed-by: Steve Rutherford <srutherford@google.com>
Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>
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

