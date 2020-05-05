Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0B71C62D1
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 23:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729274AbgEEVQ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 17:16:58 -0400
Received: from mail-dm6nam12on2065.outbound.protection.outlook.com ([40.107.243.65]:43774
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728569AbgEEVQ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 17:16:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CR0liGIWRCSPN5+q0OZSR6lau9JCxcSEWGLU8DPzPf5HW9Je99HsGTmKt1JWoPnUgVYu0eMHuAa1X2yFR5S/hONyA6gSmgiR2AI1joHHl5oryC6tC1KmWzmdN/pOCZFmsz8okcnjU0zslWwC5gl9rhKaoxyf9w48ne634Saaze5S/a/8GeMZk12X6rVCRktnx+drk2f+phbvCwzztzlDfIrpgzGD+EnxnAK92wKjc1OZjQevj8r0/CqY6SttUHVGiA4qfk5xx8zQizfKN7wfWoo/K9cFgHGhxSqUXUUrao+ax6ZKUtd7WaftolKez0W7ifQ6ywhe8i85nIatpYUT5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kg80pzkz3epoBCgvmHD4sEajd/FQGSuBjGWFCCBN+lM=;
 b=NPJPbWuTlcngTvQXTSvXPWg2gCyvXyOnfyFe7Ck23jne6A5Kh0BAe+n1wxRVgQH9R9o+I5DVIScrpBdLDYBJCngrmc2xFr+WYxWsVlrn9eMVK6f38y9Xe+wUanoAYGwZH9ue7TPhwbf2mH7VZ+oSYj3ukJBP4mILuB+cGrv47a5IaeH8cLsK9yE3D7+KZ+drODZXnIyFJ//ITDXp0q0bRiRtcBcaHhZjJOfQIljfJPh/e7mnCQKAKFRKUG1M1TixQ4BAkiNSx1bTPne3hm36r0vg21XKK1sDscZJ/y9St331zTFlkKkj5E/z5JYYnY0A/9JC8bTg9zEe+Y5Yu0DbLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kg80pzkz3epoBCgvmHD4sEajd/FQGSuBjGWFCCBN+lM=;
 b=KIIbsHZFbEPEOfK/kDTkKF3qW/U6yj5MwaOAC+rkDNCLxZkbTwjyU7R+X3gMYBjIVQoevvClD2NEYDGagvw7HEeaV1XWr3HdoYS8E0ugaYWKRroy4DV1f0NZCIE531HUBiWoASBomxsYy6NPlG7JYWT7WHW3UgwJaiw8Lj41N1E=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB2518.namprd12.prod.outlook.com (2603:10b6:4:b0::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.20; Tue, 5 May 2020 21:16:55 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb%3]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 21:16:55 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, Thomas.Lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v8 07/18] KVM: x86: Add AMD SEV specific Hypercall3
Date:   Tue,  5 May 2020 21:16:45 +0000
Message-Id: <e302190848bc0d0c289c57ae817cf9042fd2490b.1588711355.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588711355.git.ashish.kalra@amd.com>
References: <cover.1588711355.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM5PR22CA0008.namprd22.prod.outlook.com
 (2603:10b6:3:101::18) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM5PR22CA0008.namprd22.prod.outlook.com (2603:10b6:3:101::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27 via Frontend Transport; Tue, 5 May 2020 21:16:54 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4f43e34f-4027-4235-ed46-08d7f139a318
X-MS-TrafficTypeDiagnostic: DM5PR12MB2518:|DM5PR12MB2518:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB2518541645B0AB75DD4491EB8EA70@DM5PR12MB2518.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BgnMc5k5A/hGat7oq3Mj1xmCtGFjJeqcKJCq41u0fNT5CTaud/A38kPBiCISqnBt96QvjMH0qlUs1P6R4AeaBKFN0ZkgqQSpTcBbjLDn58ooL+22+slVAa08um+Hs+lHw0qZHTqk9nggb91Dn1BicPPg7lfpl0AJJFQf34/KC3Dcoj+fjQuByJEDtrIIeKoByP1znJrZ9aguAUneaezJYMODPmnr8FbXvxT8t6T52ltaC5l25IUZcdaFQBdeQrFM4iOMIa8NYGETPmljpA/1N7crccpN+HQHfPsOqzEj5bjpEeDrlJdQnrWNfSsk2dDPedM6fcwLEk36AD9Gij23jw6GiabS0sjKWPAolZSKIPS9rZnaxeuvoNIB9j2bSpEAbg/32lOjfR8N1hjDjmXCdwAqJiZcDFCl4O+DDLI0pJcunYi/1Jd1jE/qDuu3YZqt5pzEPzt7cY2zsdWHYuspzAJuXXGBW2wavFmSRN1+akws4GHqT5XMPZiwO/iZKDVsyrvxS53RVsUUUQp2wSGsWIZVIVK8lqEKK0jE7uSsV/v+YvIrpdlqjuu/z8Wj5gKe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(33430700001)(6916009)(26005)(36756003)(956004)(16526019)(478600001)(6486002)(2906002)(5660300002)(6666004)(2616005)(186003)(66476007)(7416002)(52116002)(8936002)(86362001)(7696005)(8676002)(66556008)(66946007)(4326008)(33440700001)(316002)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: xgN2zlBJCDAvUg5C9vo4wD4QFH6rkqOoIMbS2k+lww5/mDfXTXF7m/6Uz3Kxw2kEMKNVq+njotNDxDb5gEXWG2bZcREisv3msRVmoK7lbm3FnuDkBG9j+reTC6oAY7pcywfi6sgdtyHv6ajLxAM6loIBCGZWOvNYcQ2xXXnu3Jzj87E61tExm+KcGLo3vsiQ76gQ5HJ2LzzFiizDLtHWnCEk+wwH02pM4U9+VGVDBlORilLA6Ws7tvTn8uH6tJYOVgAmIcuLhh/ER+D4UQPvIylcHrVGKpOn7NnQCRRhaM8yKIA9n3bOsA1YDoYceTa2QGrLV38Qhp6gdTk50J8tPtpy+pg5GbWeT5qpF3FkfA7kGFIfAgkA1/qc9JB0RELAKXid6OVeYrBUddqrcE89CZs/dFkZQ0dO9ZklVDHJ4gdVmRgaHSm5URY2BQ1GD6C/A371hut/L6iy/E4EprLCZcOdm99Hx9jNMbgqGFcOPx9woRmbItumW6K7AphmCkrp1BJzSzIhs6TxP95JUE1syWV5hXIpKdNTcXMNrF5l5O8W3um1M/kCBzEsvVJHrWLbT788AJwTmtxt6qY1KaGqaA/FPVtBU8cqTcBND0ysEzB6LNYEhedHc+/zzkXA9G3vpDWBDXX1XOvcXqS9n0oaTtQS9F3Up7GNMR0jbPLv36MqKGPL9xsWipXhxzrSR34CCmMM9Hj4hNauGZke9IkQ7fTO+ETYb8IZl50HPfqRtpbr0/bYaEKnPddRvYokH+PEd0Q0W0xa0dRG9N6NpM96/zaO4JfBO2Thqsa4m3bh/ZU=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f43e34f-4027-4235-ed46-08d7f139a318
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 21:16:55.0493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tw6h/dm3CvHUXgHpnp8WINeZEuSslUku3JgOIFOBoqvQ3eqJoJYaKCSsu6usoaHHkwbGM+tKFnoI2Hy/7dJA2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2518
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

