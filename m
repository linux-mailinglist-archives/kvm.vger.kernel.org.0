Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5DC32C9432
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 01:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730939AbgLAArJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 19:47:09 -0500
Received: from mail-bn8nam12on2071.outbound.protection.outlook.com ([40.107.237.71]:20033
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726316AbgLAArI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 19:47:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QAdQ4wqLarmUB/jtW4hu4fAn/yoPMUCSAPguKo2pQbM0Am2X7TPykhPY+57gvZRYvxP+qsbBCYIxCSPraqYoe321bR2THIiK58bzLHsbXZ/mD3xebV/mQyQCljs5Ex5OC0SEiEW85dzgLywtH5DD+vP0fHHVuqpv8OB0h4+j/+yRx4U7vy+jPJYIRYF/Uv6xX6Zd5+L605va3VKasTYUm66TH5q2hCfeXURll+3m72EnBBe60qceGiLzrsSjWhJEaOmZWF7xET897DValooavUJTArC0S/Id7MkJQqqiFV/FvyWYVhIfIEZiEGatnuQ6b68y3tAhVpIAF7Zpl8i2oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=djYOIZIAe+UUpzeBZtr/RMxOzG5cL+NruPXwZsscQuI=;
 b=Sh1wW+KUQpAU0eOUUEo9DGxv066uQJ1i7ne8mAxPl3UNLMvaPpqvgZJ+zj92B3FjWH2YWsZVOBOQoz0nP8jrDYVGXKLE2JJg6r85N0ccIlkJOr/37iIOml8EPcrPjOxR0PxPeBnBfZ8byI8Cqi1e8h8pLC4FZfUi9ZvmjOfWUSXO3koCm9THKa3qclvUsIuB0huLtNdBr2MIfJxY16+iHJonpOSQttejG24WH3mireQSo2sEkouPZrjrP7Dt5wmBvPcL9O6FzpBqh4gSOWvsTPYDQPCUf47gYKeuNVFnyFKxuYf6BR83j8SAYrH502S+5mdlvxtoLu62F6BBsm4vfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=djYOIZIAe+UUpzeBZtr/RMxOzG5cL+NruPXwZsscQuI=;
 b=ACpLDEq+C++jhDTgzdp2Dldz5hJ5VJClvuC1ylXbZ9yejnW9olbiFpnVccgLCXO+FRi9kQymfSlFZAxZLV+Hq0THEt1f9r09en9TYsAhlkizZQmbYhD3YSLLlxDoRA0yPM1bkOx2A+J1SpjPlxHoKSTWADn/W3za6mQbQdvx0h8=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4573.namprd12.prod.outlook.com (2603:10b6:806:9c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22; Tue, 1 Dec
 2020 00:46:14 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3611.025; Tue, 1 Dec 2020
 00:46:14 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, brijesh.singh@amd.com,
        dovmurik@linux.vnet.ibm.com, tobin@ibm.com, jejb@linux.ibm.com,
        frankeh@us.ibm.com, dgilbert@redhat.com
Subject: [PATCH v2 1/9] KVM: x86: Add AMD SEV specific Hypercall3
Date:   Tue,  1 Dec 2020 00:45:35 +0000
Message-Id: <b6bc54ed6c8ae4444f3acf1ed4386010783ad386.1606782580.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1606782580.git.ashish.kalra@amd.com>
References: <cover.1606782580.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DS7PR03CA0097.namprd03.prod.outlook.com
 (2603:10b6:5:3b7::12) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DS7PR03CA0097.namprd03.prod.outlook.com (2603:10b6:5:3b7::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.26 via Frontend Transport; Tue, 1 Dec 2020 00:46:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b89d85f9-4c4d-45fa-8986-08d89592818e
X-MS-TrafficTypeDiagnostic: SA0PR12MB4573:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4573AA64664736C04FC65E188EF40@SA0PR12MB4573.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M+8tDGhh/qisGQzsVHvLuLkCd9GVg8ycvrmtM0HoUZwLTHx2TMjSJPvXtusS3dbTnQ/RjbmX5XcT8PRZOE3eJ/I4F/E3hH2L5QFjC+Z9tx6biQ3mc93b+mHWEZT4Nb9WWOjvji4rW6inj8qWUPSWh0EEayb8LI9JyNQyuzc273il+x4soOB2l91FmTL8WXF7eBQIZouiITvyDo6unbZ0oRGyVL9GG8V0SAUzgBmVRkEwQmLzNpBGxLRk46Wb1ca3Llk3W/jg2VLd5y6tVqFPr0ToDTCb7R8vMlWJFWMqaELNY0uIjMoTwHFpH+/NnzuBwexEx3oveHmVT27M0llw4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(136003)(396003)(39860400002)(478600001)(6486002)(7696005)(316002)(4326008)(956004)(6666004)(8676002)(186003)(16526019)(8936002)(52116002)(66946007)(5660300002)(7416002)(2616005)(86362001)(26005)(2906002)(36756003)(66556008)(6916009)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UHNBM1BGSTNkU2c1djU0L0kwbFc2bktvNVNvYVRrTDZoSHFYNEJucFozOXZ6?=
 =?utf-8?B?Sk16T1ZwOFVJY3pIQURMbVMrQUpRUkZqL0JDaFpWcUdlZ3RZSksvYVpOaDBB?=
 =?utf-8?B?QWhxcWppcnV2WTFhZW5aWEE1SXJmczB0aWlEM3E5S0p0UVZEakdjREpkV055?=
 =?utf-8?B?bm4xN3phRldWTldzV25YeldLUnhHTXNIYjhIZUdUK2diYUM3c2xkTVhrdkZY?=
 =?utf-8?B?L2FhTUQxRm1TbG1RM2x4Rzh3Skd4ZU9QQ3ZNSUhwcHQxT3BRM1JLVW5nRU0w?=
 =?utf-8?B?ajkwMGZlbEI5V24yaWVlOTBUSitGMFBSejJKTWNtVkpHTDNSU1BtdnJWM1Qr?=
 =?utf-8?B?Q1lNQXNzMUFDU0NjZ0lxczl2SzB3Y3VZSEU2YVVidjJzRXp4LzdaWXBzcE9u?=
 =?utf-8?B?a0VvZ0ZuSi95UkFyelpjZnVPRzlhdG1YYVh3Smo2NFM4aGpEY29NckJHWm9l?=
 =?utf-8?B?S1MzbzJhS1BHaUdselVEOW85Wmd4M1M0RjBtVFN6THFNOGpWWmpVajVJZ3Vz?=
 =?utf-8?B?RlhvOGsrc1JzR1BuWXZrMFkvK1hUVHZ1OXhDVjhaaGJNWVhReWxyMytMdjdD?=
 =?utf-8?B?bVBTQTBOS3NTdEJub0dNUHVJNVJhRmVGR0t3NldtNmpReTN0bTlaMG42NnBX?=
 =?utf-8?B?Y0syUk5pc0oxK2ExaUg3OGJ5eVVaNzNLTkFraklqU2MvVlQ4VnJvLzYwWWlH?=
 =?utf-8?B?TEpVZ1ZESFlyYTNYcURLQ05rY3A4bUVlUTAyWFBTcFZVbFdDWktKK1hOa2Qz?=
 =?utf-8?B?UjdrckRWdVNrVkVIUUxPV01DdHYwOWcwRGJsR3NYMVBwcHp2Yjg1OUxnUTlo?=
 =?utf-8?B?dSs4R3FXVXZxTis5MW9pSDBFdzdyc3QrUnBxSjJ6ZDh2TjVqd09ZYUxmSWx1?=
 =?utf-8?B?Z040bVVaNmxmcFVja2tuVUhkY042V0ZsaEJqekM4SjlFSk1iN1BBdHF0UUNC?=
 =?utf-8?B?bUcybGpKR2prdEplYVZlV1IrenhCblRsbDFHc28yN0lWUHdwcjFka1hEZEk1?=
 =?utf-8?B?S0R5bllsK3BtbjlGSVN0NkZ5Y2xuc3lpbkNUaU43TVVIS1NJdlVqY1FRQSs3?=
 =?utf-8?B?emRjM1ZiM0RoRnIvdUY0aUhhSDdxRTJOeXhpelhiVjFDN1VtQUdOZE1ET25F?=
 =?utf-8?B?OWZLTkd6d1RTSHlPMlBVTjhQZGZtaDVwZUpqbEhJbmRDQXFKOURieVpXOXZL?=
 =?utf-8?B?QmpLUDhuRDZtaUVFZnZwTDVnOGZpN0J3T3YxdnU5V25QRDE2NkFmN2VUalVy?=
 =?utf-8?B?a0o4cnpoQlhpMXpKRTl4bWFrOGxQWW0zNUZOcitsbnZ5OWFxMzhDa05PT08z?=
 =?utf-8?Q?qzfgE1BhObFBua10h9LOVEsI2JPHHmLZ3/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b89d85f9-4c4d-45fa-8986-08d89592818e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2020 00:46:14.5910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PVWFKuADWpkSrv7Xba8xSEOA9Cix+/6Q7ELMttiaS/3GYG64dARwPt5kh5Cn+vXbQwx0ISuRpSWFudmVtbie1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4573
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

