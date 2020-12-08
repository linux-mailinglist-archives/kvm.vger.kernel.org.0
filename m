Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 794322D35E3
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 23:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730652AbgLHWHc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 17:07:32 -0500
Received: from mail-mw2nam12on2059.outbound.protection.outlook.com ([40.107.244.59]:19552
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729512AbgLHWHc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 17:07:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mW4ncGhUc2toQx1V49hUot87fWvOlOKWpItlMXPrACatLFK+1tA8xo2WmI8iQE2VYG1LXNR2q6Xhq0ytxEMYvJOLP1EuDLt8N3q5llZ1WDy3Qtbcc1htaf3T/amiRPWhAn8hR4kxgmElTOp2zhEO1uTcGUKv+bWSeRfEhyLfeYdrfJpmB0nZgYbPkysTouwrTw+KuNmdbvq2nw1b5Rs4WmhZWVqGUzVOkxzjZ5NSd6HdIjR0IRqrD3/6JELtH26OJlPcLlHCneeKdbIVfERM5DuKrUvfRAdo4+o1A2hpRQdNqvkdFROefq+BXPsmgYFDZmmNvisXz/WBIMsyTgFqkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=djYOIZIAe+UUpzeBZtr/RMxOzG5cL+NruPXwZsscQuI=;
 b=RlKs6ypQqmb8gkx95LRQ0pwbpueDC800d279T/5riOKrWn9Cr3OjwKN2MU/ix1UWqR1xecURpEB/xr6f0TE5D7iRWOz0y8+RXbG4aBToXTHHh4sFmnarxMVDyMN923D1lMel9lxP9Zzj7DCIJlNC/IoLgaERFO7OmOnONS7MspHJTYgNPJSU2xpeqlZ9XJG5dBBIdkA2PAQYNMJ0KQQvRuCOBHr9iD61NXo6mFZizVj6EqZ06CTLYZsFRTWLQFODIRKqld3Vv5ruNtyaD51U6NpEhoimawYtaeOMSdskgu+6gQCTycFNQwk+JkJlTnWFUi7XfprYEeqqMz64dnbRIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=djYOIZIAe+UUpzeBZtr/RMxOzG5cL+NruPXwZsscQuI=;
 b=BaK70AuuJBIxuywqMB1R77GsKHlgFHq0FThDU+TmNTSIUg5MU9871U8RTQQ/8EIm9EuvkgSAjLWAArDf/q8Ma1F6WivxBIyh8as7z8M0m48ktKDmn2+nUkCNAqauPdsq3Y4PARUW4kLL+QDSeyDUlBPR57qTImKFQwalouwbq1I=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4415.namprd12.prod.outlook.com (2603:10b6:806:70::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.23; Tue, 8 Dec
 2020 22:06:08 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 22:06:08 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v9 07/18] KVM: x86: Add AMD SEV specific Hypercall3
Date:   Tue,  8 Dec 2020 22:05:56 +0000
Message-Id: <f63b059819239d4667e4edf5901b06f5672d209e.1607460588.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1607460588.git.ashish.kalra@amd.com>
References: <cover.1607460588.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR05CA0032.namprd05.prod.outlook.com (2603:10b6:610::45)
 To SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by CH2PR05CA0032.namprd05.prod.outlook.com (2603:10b6:610::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.7 via Frontend Transport; Tue, 8 Dec 2020 22:06:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e384e82f-25bd-49d2-963f-08d89bc57747
X-MS-TrafficTypeDiagnostic: SA0PR12MB4415:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44157598110BB35F70C722488ECD0@SA0PR12MB4415.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ahEtrBOLmqHrXvkQ6npitCAdpB5kQ/lk9XqhRgyOZho+Sb54i83RTDnSRUIZEFA5hg117sVftjdLNJsBWRV7B5/2W8VslO2tU9DunF1ir+swjFqv1LDsPRE6wSBOsvHgf0kx2HDfIRfi3J/V5t6QOsm6mm75ct7xvZvfOMXEAGBujmPHY+5HBdQ32FNvKsNygRMSV7cQY5OobK3haxcj5VYCR28QvLAe/m51thvTCeYwZzFjRU/cOkCalI+eDbTFs6Z18SVEG9O1yBytt3RQ9eZyP5V+UZCngYwBkrJVMa+3kTXCsmCftcDYRlT0bETUpzfgksdQLXU8fmTs7/8MVCZvok6jshD3E3TFlBs3jECAf6PGxvtq84PgjL/K3QVV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(366004)(34490700003)(186003)(4326008)(86362001)(6916009)(7416002)(16526019)(6486002)(5660300002)(66556008)(8676002)(8936002)(508600001)(7696005)(52116002)(66946007)(956004)(36756003)(2906002)(6666004)(26005)(66476007)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dmhxSE1pc3d6Z1ZUWDBHODlCYWJZampSQnNvODZ1SWJIeFRZM2NIQktucCt5?=
 =?utf-8?B?NU0zQlRScTE0YWxmQWNJNUhMcFI5ZlhReTEya2NpTHBnbUJMQ0RFaXZURDJB?=
 =?utf-8?B?akpoRVBrOEorZkFFVDF3WTI0MWpjRndqUUY1Y0k3bVN2TUszemJvYUhkNnFp?=
 =?utf-8?B?QWZGRzMyRnpyVGlzd0FENkRNUExSZG5mWjJxS2lHWHkzeExtRnphdjBJTlVT?=
 =?utf-8?B?QnFTS29XSzRlZVJDQWVUNzdHZk83VHYySmtPS1ZkOGlvYkpUUUJZbWZXcGox?=
 =?utf-8?B?b0dsK2Y5WXZjakVROVVIbzZwMnV1UVpGbUcrZklWMEtJUWR3THdFRmNCWVFR?=
 =?utf-8?B?WlJCayszWEswUzM0SDM0YkNXTXZqOW9raUl3bFlTZVR0QmpZaFV5aDlLb0Yx?=
 =?utf-8?B?ZDlxRlVMRG4wUzJnM05WMURNQU1NRDR6cGtkWU9hR3JLeSthUzNEOFloUity?=
 =?utf-8?B?Y0pqclFvd0ZXTkJnMGQ5ZENTN21aTWVvamV2YWR6MUNPcThxNFZJeHF5bXd2?=
 =?utf-8?B?c01USGVockQ0cXQ2bU1RY1NzMFU2MjhZZzN4bXNuR0hKOEIyNitQWk1ZVUVx?=
 =?utf-8?B?WEN6ZVdyN1VrbFZDM1pqMVcyNFZEZi9sTDkxaGZhcEdaR2tJMUtldHY3RFM2?=
 =?utf-8?B?QVJ1NHA3aVlyVGJ2S0loMDFvU2xPOFpNNVNUYXFtTnlEM0NDbTFrL3ZCS2hV?=
 =?utf-8?B?OW9DTzBDQ3ROZVk0b3RydjJZQklMRFI3MGVoV2hCUEhXUG5neW9zSGk0NE1F?=
 =?utf-8?B?MVdsbTZFUDZnbjYzZ05WN21KT0l3VWE2N1o2M2I4Z0xaYXVGQTc1anpUM1VO?=
 =?utf-8?B?NTQ0VVFkcnUzSm56YkFnc3VTd1RMdFZydkhXSW9mUTEvRHMxWG5OeDdxMGtT?=
 =?utf-8?B?RDVxSjV0RDNtZVdnVmUxVzNENmNkN2ZCNkw2eDRiNkltZ2srUkY5MXpZWEEz?=
 =?utf-8?B?bFV6WDllWTZSMXN5SnZmZ3RXMTR2RWVweWlaL2VlMXNaZUI1dGpsWHJEenpT?=
 =?utf-8?B?V2dQdlRRNTN6T2JJMkNPdkdZQTEzRjJKdFlkZjFkUVJWc1ZYS3hoWDBZd0RG?=
 =?utf-8?B?MWRhem9RTUxnS09PNnZyY1BnVXczWTkxMEpTV2k4aCtDd1lzb3ZzaGhHWVZn?=
 =?utf-8?B?T1g5MFdSMXMyYnB1NXhPTkkwM0NKYkt4SGNXUnBVTjExVzhKTENsZVhFYlNX?=
 =?utf-8?B?bWhsVmcvNEl6QzVpcis4MFI5MzJOUUIvcGtVWlJUZzhxQS9Hc29mcm01STRz?=
 =?utf-8?B?ZDROUXh4ZUpld2ZZK0VsZUdHTUFEMlRXTVAvSUlFTVdnbjNVS3VCWllTYXli?=
 =?utf-8?Q?Zxly2htGDFI0t5jxyN2ifW/hrFFhEKFsFT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 22:06:08.3778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: e384e82f-25bd-49d2-963f-08d89bc57747
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iaoetLSuAU/0WX8LQRL2tSzULD2KdsRIUXM4cEaBR0FcYPMcy7xvsPN6rHVYYy5P1pO6n0ZuimbGKW2j0IZ/ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4415
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

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
index 338119852512..bc1b11d057fc 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -85,6 +85,18 @@ static inline long kvm_hypercall4(unsigned int nr, unsigned long p1,
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

