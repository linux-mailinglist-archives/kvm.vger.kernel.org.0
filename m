Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2C5368845
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 22:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239429AbhDVUz7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 16:55:59 -0400
Received: from mail-mw2nam10on2083.outbound.protection.outlook.com ([40.107.94.83]:4386
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236851AbhDVUz6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 16:55:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ihYzj1KyF+R2qIlmdy+Cbn0r3XvoN/6UGy5Jh5PmRiWAWyaaQ5Tbh8GCbCQmk8y0T7xgtzfHri5zpYL8zZyDmn3Sk/UCunTFGbMNTx/u20dSe2USuADR66lGf9/veKNHSHn1M2PO1hm8JOY4hMVJzKVmv4hRalOGKs0UAG3V09LdMlRWqUYjck60lJ+O02dZDT+LRj2knWgUi2QMeIgv0yQdGVt7t5j4gqK/ojdny7XLPLTFKohg15UrUoLfy41jHJFhk9ZyaRjklSGXNFePMn/wbZpMiCO9gMk1t81ibKjVuZatChn78B6DhfVY0KrOBqftDcpRL3XwHr5KE56r1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=djYOIZIAe+UUpzeBZtr/RMxOzG5cL+NruPXwZsscQuI=;
 b=iUr+YNq2lGi2pVeDjwZUXD6aNHOaz84tJEA4ZB6ts3V4+PTMUrzNPqL1B2PF2azGVpeq8or+q1jtJw9/QnEQJ+SPTUWhU0HosJJkVOUkGq9d2iAbhCxqwAnlD5oIj/qm6UiI75D7w23yjUGojIKNMGHuzieLhviHjCm7dTePqY8WgAVdj7W2V9XPdOnih9kYgjaLkh+KkoPoLUJ8wElNR5l1bVc/IVLPImkyrWyA3Fnu9zmVTfMZLPHxJWSvrinrI1Xndy1t0L6n+xGnOCEGFo5sgDtKBTurhcag3PoA+eV9BqP6nJUBr8SRfvk4J9cxoIEyi+h+X4jBBAw80BDpeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=djYOIZIAe+UUpzeBZtr/RMxOzG5cL+NruPXwZsscQuI=;
 b=rty4HZjtL7o6H++9pS1E3JxG9eRKjgKk08oP3yCxRYUdJHZ0se0cV9tPgkww8fCr9gO+ax8NmTMcJJ2BR7ZNctEr3a76I0kVGn7C8OZ46oDHJMh6vLa/Ozf4/L2++O0+bmJNjLrEF+3G4nl5QP37Vrqi/oTw7o8mJMplUqq/dZs=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4510.namprd12.prod.outlook.com (2603:10b6:806:94::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Thu, 22 Apr
 2021 20:55:18 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%7]) with mapi id 15.20.4065.021; Thu, 22 Apr 2021
 20:55:18 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH 1/4] KVM: x86: Add AMD SEV specific Hypercall3
Date:   Thu, 22 Apr 2021 20:55:08 +0000
Message-Id: <c33adc91aa57df258821f78224c0a2b73591423a.1619124613.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1619124613.git.ashish.kalra@amd.com>
References: <cover.1619124613.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0601CA0019.namprd06.prod.outlook.com
 (2603:10b6:803:2f::29) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0601CA0019.namprd06.prod.outlook.com (2603:10b6:803:2f::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Thu, 22 Apr 2021 20:55:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a707d165-cdba-4cdc-a5c4-08d905d0efa0
X-MS-TrafficTypeDiagnostic: SA0PR12MB4510:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45106B092D0B7E83C013DB5B8E469@SA0PR12MB4510.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b+9nIYVDp0t5JD7gkDr9gOFY+McH20zJbHw8juyiHlftpA9d8VKZH1l5AqmO123IyIdzokAax4fF+se7edefGU5PQuEiYc164NmANgcNO2vEuPryCHoycB3hzfoxBxX18VQuz6iJWBAYz6wyjR2Eycph/Dh2lclH/EJjPu99ApWX6lLtsj+cjYJaaMVwRGEjt0y18M4eQQ1C0BzPg4DQKFHH8nSQOTi6wD9j5ppHyh61wn6unp0+3UKHAIxQUd0adChbQRqm2W56xSntphuOT3k74Xex7CBbrffJI2tyaCJpC7huc+NDQnNIWjDv7RP6QRIBPCT8ErdP2MM90kglNdu/Ch3tPfKlQEWE3pgZdOqPkWerOSMKdj0/WfhUru0033z88tnUrSKtExb0Pj+7XaspT4AuCFqARBdGwKhMfVe2dksInO6YChOkRB/Qz7nF/JKBKdnS3t7nBREXlBcZmIA78j+D4zsC9Ibu3CZmhifcNGp5DnCA1YAn3bNK/KkGLf79r18vYzg7tKenkn5mbie5Oybslu4niCIsfI6WksvyhIzmL2dP8t+Lziuhwr7jRW7DKQISskf9JwQLxLnGw6L2FdxggkOzFcma5o82+UmpgqnYO+sndoyZnz0gG2g+hlcwQJ4tW9PLTwka91flFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(39860400002)(366004)(346002)(6916009)(66476007)(36756003)(38100700002)(8936002)(956004)(5660300002)(38350700002)(4326008)(6486002)(26005)(16526019)(8676002)(478600001)(186003)(2616005)(7416002)(86362001)(2906002)(66946007)(52116002)(7696005)(316002)(6666004)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?R21rQnFhWUZrVUlTeTRhWVZHRlNZWmF0VWQ0MkRPaFZqc2NMN2N2SHZoVlly?=
 =?utf-8?B?Y0JBR0NlenBMM0Q3OTZnN3pWRnpFNVZESDk4b1E5a1FlVUVsaDNFeWNNSmUx?=
 =?utf-8?B?RVZzZ0VrSEJKS01iTzk4YVNObS90Z3B5Sis0RmtRcmN1UENEeURYdCtyMGNR?=
 =?utf-8?B?RVpCUXVyYStJU3BGOTdTZUhsSkZ4b1ZLcWJ5a3VMemRydUtnSE5NYmNwT3px?=
 =?utf-8?B?NkhQQWtBZVAzZi9SbXRGRm9PMXNnekIyRTdGdEM0L2NTb3VDdG9SakxxbTBB?=
 =?utf-8?B?SlhoNzROQVJ3VDZpOGVHWWpEenVrWlMxaGNPWnpxZTlxWElOQm9DTWNYZlZ2?=
 =?utf-8?B?eGJjMTZ5VDgyMUwwVkJKVEtxbTNiVjNiMFpqZnlzNmdOaU5EVjg0cWNUMDlL?=
 =?utf-8?B?d3FEZTV3Z3N2c2M4UmJYTm9zWkFCaUFDZCtWdHpieWhPWjB4aTJGTXVONEMr?=
 =?utf-8?B?bUFuTnJHRTd6bmRLaDdvWmhodVdwSmhhU0Q4NWJoQ1FpSkZpbXdhMk5tN2M0?=
 =?utf-8?B?b25jeVIzdk5zdlFKZHRpYllSdXJVaExMVGpmQml3RXVRKy9hTWdSYXBlZFBV?=
 =?utf-8?B?NjJQR2Y4WGtSdzJCMm5rK1MvUlptTS9LTUxUSnBUTDIzanVVSmN2bDVFcVgz?=
 =?utf-8?B?L1hQYWYybEMvMXQyYlUxR2JVdlc3Unl3U0VQNzJxaXNFWk5nbW8wYzZIOTZU?=
 =?utf-8?B?WlpWb2F6dCt1V0RBN1VYUWZ3cDFObTMwbUtkNWk3NlBrZU1TMXgwa2VIVVM2?=
 =?utf-8?B?QWZwVnVMNjNzb1NTK0NmS2NVSEZscThza3dmUXkxRmJUWjVyQTg2NlNZQTJn?=
 =?utf-8?B?MXFRK0VVRXFrU3FZRkJRMzNjYWxQZFArR013YUt2VGRka2x5ZFBGQ1hHOVpP?=
 =?utf-8?B?SFhDcU84WVBjVDNWWWtOK3FkRW44alVneW00MCtPVHZveDV0WFlMUTJmNldr?=
 =?utf-8?B?Vnl2bXR6MnQwTmNPbjhXYmlhaDZiUjB5WmN2L2FicHFHV1h0REhFb1dZeldY?=
 =?utf-8?B?M1RySml5dGZqaUVTL0prb0UwdmdBcW5LTm5teS9iNzl2K1ZpZzF2NHRCeXVU?=
 =?utf-8?B?cVJzUTZVenNLaXNWNmNUdkFZall2UGFDZFlZWG5iSXpCSnhIMkF1MFF4LzI1?=
 =?utf-8?B?VFBSNjBhRDB3U0NwSXRjaXZpSWJUME5ET2FaRm9mTGpCNWZqWGtqMmlsbG1j?=
 =?utf-8?B?ZTJoSlNxM1NNb284cldQNmw5SmNxdzlJWVNvd2RqSy9VVlRpWVBkaWtYaHVi?=
 =?utf-8?B?TnduZzVDNUxBUE51VlRMSmZFK2s2Y3VRNS9CVVBHUVJBcE1lalo1c0tHTmN3?=
 =?utf-8?B?U3ZoemR5TFhoc04rcGxONlRGUHZnNFhrOXN5Rk1kMUw5bVJaUi9GYTJOZ1pH?=
 =?utf-8?B?VEp1cDU2L1I2YVJPNDE4dVp2OGNnb1RTWVhPYzNkYWhEV3lzSVNVMDZxWVJ1?=
 =?utf-8?B?MGxkTnVoaytubVdYVmFOQU9GS0dXL21BaVd2Q2daV3ZBT2ZxbTgxMlpyaGoy?=
 =?utf-8?B?akEvUndxaFhJb0kwalF4SXE4dVdiRGlQaTBXU1lOVEVoUHl3YnM2dUh6Si83?=
 =?utf-8?B?UkdoRHdJdFR4NmNZaEpaSGN6QlpKdXd6YXBzS2dOaTdTRzM4cG9walJiSXIy?=
 =?utf-8?B?VGp0TzVTU3ArZkFUdEV5ZWRHZHFCcS92SGhaRFczRVpwd3FaRlJsVW55VFow?=
 =?utf-8?B?SGpjTGhCRnNGdjlxOWJmVWFHdk56V0dGY3RjVHFUMzdQbVhFd2cycWR4Ky8v?=
 =?utf-8?Q?XH3gfckEOG4JyvWdF0wMViy3zCF99AQD2fh7re/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a707d165-cdba-4cdc-a5c4-08d905d0efa0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 20:55:18.2514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D0qh8AaygUgNY91Y8mwP1dS7vLYDeW9SC8HHWvik6YxGQSNfMdLvxjjOxyq6luKw7WQXmHrkEY+XTZGLlw/7Sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4510
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

