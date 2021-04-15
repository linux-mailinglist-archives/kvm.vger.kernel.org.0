Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 353F4360F92
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 17:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234192AbhDOP4m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 11:56:42 -0400
Received: from mail-co1nam11on2062.outbound.protection.outlook.com ([40.107.220.62]:50656
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233939AbhDOP4l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 11:56:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fL/fEUEVOBjcIwaNsKNR2c4cPzD3yHsJwHRfAfSzHsaAD7cMiIj60YE8jF8XOXBgJSs6UGMewQ0HIeul+RYaVpoVbrltyeMn1dP+hKm8Be7E8aVPhu2Qu+aQ4PO23bcE/ywFan3XTMuJx2HuNUhkPdmSsrA1QOXV1vgkVHPcVAtMHFO+9dR/iA87yLvgEdfYecv8doOZ5jjO7hezyQ12HV/O64CGBvkOCYPiQZECl0I2TwURGciTpfp4ozQ/CZjWwIdDxhNwHnu/9BwbJ+ja8DAcuRNge3tQDoAuOtz6yyub8MN1LBQna4doftU15nNsAk3dUcuqlR/J6vZZzC5P4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CLNAo19buTg3Yb1D6/ZVJBYv5MP2n7HijI3gYDV3fvM=;
 b=llVe5D7hyGFYB/YuXzMlI0NnAsPU5U33JtafB16KX2mq/SvqaDbELOTiXMbC2BDA2pfiNhSHw+FaN3s0qKhuU0uyI5pcPqPHFM6BqCRVj/B1qZr+Z1rxStWaf0EOqJ7e5qgJrnUywG+RLti5UM1Xe6FiA91pJjB/cWhyJqoabbzlXEEH3Obe9ysFwllG5j3C78CgU6XMZ4AuHWd7J7HC8tizTnvfFB0zDoshTtGaieKPlm1nVRUzWjl5TJ9LDMsv2ZJbmgmi4TQJqB2/ATFnKYg6nWEq7RRJlhPkXx8ulqfnCZmqQxG4uOq7B1KcOZV+TAa0t/Z6bOeSi3z8iTF+GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CLNAo19buTg3Yb1D6/ZVJBYv5MP2n7HijI3gYDV3fvM=;
 b=EgGTsAAE/P+r81KC7TuYwZtPefk9D6K9Hz/FfkXlw96DmUf7OnIQ0jQj5euxXzEOQZ2EoT7sYiqOzZvln9Zg96AUSKMEOTV6dcs65bA5RGbpicbYvGA8/wGVAQyE+aUfAEy/ehOMkLDuwxCgeMLY1xIXQYIP6urWLW3fpabMdwc=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2766.namprd12.prod.outlook.com (2603:10b6:805:78::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Thu, 15 Apr
 2021 15:56:16 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4042.018; Thu, 15 Apr 2021
 15:56:16 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v13 07/12] KVM: x86: Add AMD SEV specific Hypercall3
Date:   Thu, 15 Apr 2021 15:56:05 +0000
Message-Id: <999bdd6f4e9e2d7f4bdc20cea9459182327f505b.1618498113.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1618498113.git.ashish.kalra@amd.com>
References: <cover.1618498113.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0197.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::22) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA0PR11CA0197.namprd11.prod.outlook.com (2603:10b6:806:1bc::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Thu, 15 Apr 2021 15:56:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea5ff5c7-5006-4b4b-627c-08d90027004c
X-MS-TrafficTypeDiagnostic: SN6PR12MB2766:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB27665882AF8CDD94CC46D8E38E4D9@SN6PR12MB2766.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AYgdXjuBhPJ88yjqf2kbusCtx48uHiybODb4oef3KnmqgLSd4PZaDIRE9D8tU21Pxo9XT96OGFfMyX9DuD/XZdYkYTD8P1TrutGs+ftUu02yfPVg7cYQw0wugpnXPmS/EJonAfHdyHmm2/OHRHbwAccJvuv/Nse7JSpunnE89Lh92G/J+h2Pcw0JKEPkikQ+yDArvGi8oOgXQXGpcM2fdWs0JZ7M0E0Sa0ONLa4P5FHZX9yNg3OGKhBHhRmcedp7Pnnyr7fco8ccoeNA21ibuXYcAA3rhYvacN7hEsG2M/D8Pi5nIZ/h6JRj1JqaxgX+XcDov3rBK9+nLmudWfhdhwOkN0VmgCrDNByoVUxNdiQITIHUmD5RZc1OdNpry8pnR4l8igQpmIUF/YhNoub+SRdnDqrtM3jYidrIbTKiFeeGBYv08SAM2ap4RJZWkkFHUtCdgCUeIauk5mXYiKiTbO1XndeweSI76Y2WoLhrBTu8ymQ3nBqLgah5tllVUpYbUi8K+DtfkLHxR3eyZIcuDs626HQyZ54webLcVeQS9shXOE/fznrTJ2LxPqiDoI9IVex0AoRmW8iCqvxoahzNUHCteE+UoK6fdn9uMecEhb8rPDhL6uVvWhaoVY25N/nR1H2AmTBdmNhraNy0mGQaQA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(346002)(366004)(396003)(2616005)(6666004)(8676002)(36756003)(4326008)(316002)(52116002)(8936002)(478600001)(956004)(6916009)(6486002)(38350700002)(26005)(5660300002)(2906002)(86362001)(16526019)(7416002)(38100700002)(66946007)(7696005)(66556008)(66476007)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SVRaTkVUckN2V3h1eTRnQzQ2MnAvdGRyTHQ1b05WejY3cjFKK0xzcklhT0p6?=
 =?utf-8?B?czlMc2Jad0FCTStJSzFCR0tmajBBVmNoTXl5aU8rL2wweWVpWlFCU2k1d2hG?=
 =?utf-8?B?WXV6Yjh1QncvTE15bFRmaEJ0N3M2RTBuMlpud0lDWUZlWjhuMk4wRmZQNUNX?=
 =?utf-8?B?UFBjSFJuQXJvWGZSK3RDM2VVUWxMZy9lQzRzVTAwRHlGY0pUdmpGSUZKVlZs?=
 =?utf-8?B?Z3gzaDhFYlZSS1BYRXM5OFk0NUJXRlNUMVVJMStFZnhxckhnZThid2hPc3By?=
 =?utf-8?B?Q0lta3FEaE9ZK0VTdTJidi81UEpiNy94RldxWFdubkszUGZQb0Y0UnBiSHE5?=
 =?utf-8?B?ZFBFdHdEK3hmVE5MaVp3T3d0cHFxNjFrbEthdmhUZjcvdjdvT0EzRFdlSmpp?=
 =?utf-8?B?K3BPRS83dWp6dW5qek0vN3MyVTBOMkNXZXhMcndFKzRUTlJ1d0IwYldvWHNO?=
 =?utf-8?B?TVBXR21TTjlBd0JWWmN5MjdYWkNWVnNKSUtVUEhsc01MRm03YUNFTFgvZHBD?=
 =?utf-8?B?TjVuM0syT0JTQUI2UUhiQkx1Y2hzNWVWQitndnUwMEk4TmNkZmlBQjJTZW9K?=
 =?utf-8?B?bnl0SXcyNXZ3dnhPOVVjUFdLTW42VDk4MEJkdWlzTkdlOXRNZHRoTHY0YjNm?=
 =?utf-8?B?VzkvQkV4SzNrY0RlbzYwTGdYYWlRUko5UHJtNmo0ZEwyNm9hMERFd3hIY1BW?=
 =?utf-8?B?Y0Zqai9rajZFdmg2OGhhdTNDNVYrYkpMVzZjdlI0cFVXV0lSOU5xdHY2WEdH?=
 =?utf-8?B?SEpwSS9xcHlnVzY4cWpOSHk3MWhyb1hJKzRETjNxMUdUQUlsVXlWUWtCc3JE?=
 =?utf-8?B?U1NKYXdDV0JCSVRQa0s1TERzYXZFd0ZORzJrdzZkdlRyMkFZeGVkVmQ4RzFG?=
 =?utf-8?B?Q3luaEFQWE9va1FKN3QxaFFyV1VxSTdVUU1RNEpELzQvcVJnS053TGZBNGh3?=
 =?utf-8?B?aGcxd3RJU3pGcjdzL0dWUUswVERQandSeTY5L25Gbi93RjlOQk5teHFCQ0Fy?=
 =?utf-8?B?REs0Smd3bUh2WkhhYmZlRWJmNXVTZzFhUGliQzZITXkwejRhdTdURzlLUTFM?=
 =?utf-8?B?ZU5jOUE1MXFkOWlNcGRRRW01NnN4bmRabzNyRmNRcmtpVThhSXM3N1dWTnpI?=
 =?utf-8?B?aEU2NHNleWNwVnk1ZEloSlNtN0J2STR1a0U5ekk0aVVBa0JwbDZXeVJoOXRo?=
 =?utf-8?B?SzByVnJwNjJKcytKZlBxTnF4dlFqSjRsL1JVK0lUU25MRS9pRXlsU3dLdzA1?=
 =?utf-8?B?aUlhRkZzenNZaHRPaTBWRlhhaWE1UDVWcVpESlkvM2xYTVBiUlFickh0dndw?=
 =?utf-8?B?N0lYQnVwZUEzZGI2SVB3NVVuck0xeU5YWnR3UUJPM0tBdDJDN2JIL2JHRldu?=
 =?utf-8?B?ZmFWa3ZzYStqNkU4Z05WZ1hlYVI5WXY5TUlGUVV6K1JiME5Uc2lCODVBWndp?=
 =?utf-8?B?UUorblo1Y3lPcTVPQ2Y1THZHV1BYdTBJRzIrOWZDNTBBSUZBdmF2R3MyUzZI?=
 =?utf-8?B?L0ZwZWRIWXBNVHhFUnB5Rk5nWG5lVDFwSTJvUnhjcHNPaDRrNnI5a0JYdWNX?=
 =?utf-8?B?RFpLSzVoeUJzNnNITVkyd3FJWWora2R3SWFSVldpcUs3RTlPclk2bS83amRY?=
 =?utf-8?B?TEJLa0FYWVlOUjMvTk5ZaFdEMDFzdk1WQ3JFRnh3VzNPQktPVG83R0JOM2c2?=
 =?utf-8?B?MHR0cWZYcnVwWVhmWW1UNmZySDFQN3pNYm91d2NxMmtDTTlPSGpUUmQ3S1JL?=
 =?utf-8?Q?caVXEwiM3VxGZ5uyW7jZ/oBbMeI3y0D2mThxuMp?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea5ff5c7-5006-4b4b-627c-08d90027004c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2021 15:56:15.9685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t2jRmwR48ASAwTQjEYAdYhTf7Ot6ObSJO2Q1hXxnxZqLyaGsL7M0IVFJIzGzMiwET/iEJLpr46i+wBgRfHkuBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2766
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

