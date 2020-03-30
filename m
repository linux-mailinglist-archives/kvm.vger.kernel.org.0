Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A06C7197463
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 08:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729237AbgC3GWM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 02:22:12 -0400
Received: from mail-dm6nam12on2077.outbound.protection.outlook.com ([40.107.243.77]:20854
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728732AbgC3GWH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 02:22:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eED0YF4boYAprvUL2GKZQDbDp1GSyQXamSwXvPm/jdrzXNO4lhh8stkFJ78S0n9V9/WEREQMPNzNjHcQ1XrL6VeN4hmDzi9OIurQ4CVdR74LYozfn3cA7x1VsBtob9t7Js5je5fgXoU/9sDo81hU6aXIH7qwvde1+MhhShKxpC6oEbmaXddX9jKEP3T+XMiuuCA0dyE30TekSUpkUKnnQigZLbxEk9avPJFL4qqPnexcQFlpIexqvucEMLjGt8xSSschQnbK1q2OJEqayM0MK2I4XGOkNWCsrpEMOZ5u1PadTBP6cTUZlhTiB3AM/IBWttkPUGL2jxTTF+blgi4aaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SwLWA9i8h3stz9l2IVcM8HURce+9OCTaQnNc0VFSdHs=;
 b=C/a8soDZRsDscr7StfDiyxFJkNcgqz7/5kz0orPOxzx08iTFsy5CGOeR84sQAXimxvmWBXrfI4SYc3xhusQf9saJ71REJ9Cu9gBd+JMiuaGzlCF/OW1w3waDR0uW0JVD+iPEt/b1HWJVP7lpSEROs/0HVwoEpoc2xPoZuAtUjkCz9YVd4yBWAQYvkIwxXWpAn65F9IHAJwk7o3FW4baM+vTUlJ+yLAOmCsKJ7ziaWCABbwWFQNIR+XRtO2BsaFa+9E4LFh5vZZTpAQMc6YUwx6leyTIiTpWe1WNWQ+jRW3LJwu7Q69EsBSFrrhuywOWDi9n7mvdAZD4W9ft2DLEVdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SwLWA9i8h3stz9l2IVcM8HURce+9OCTaQnNc0VFSdHs=;
 b=PvmKbGrU3YuG+PLOjLlvyqfadK2chAnTb/YVNQiBlWQrWR4nGr7X9Jr4nKOXV0ikfKkIxQgzE2MbzOeq1Fw+VpoXuJQ8JfNWFY7FmekeqDz9Dri7nI5PKrn5oioO4VPAWMuAN0hN7VNSDaoKiFOJplaKwlfUQ6wU9mmeYI1sV2s=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1692.namprd12.prod.outlook.com (2603:10b6:4:5::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.18; Mon, 30 Mar 2020 06:22:02 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 06:22:01 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, srutherford@google.com, luto@kernel.org,
        brijesh.singh@amd.com
Subject: [PATCH v6 07/14] KVM: x86: Add AMD SEV specific Hypercall3
Date:   Mon, 30 Mar 2020 06:21:52 +0000
Message-Id: <6dda7016ab64490ac3d8e74f461f9f3d0ee3fc88.1585548051.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1585548051.git.ashish.kalra@amd.com>
References: <cover.1585548051.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM5PR19CA0047.namprd19.prod.outlook.com
 (2603:10b6:3:9a::33) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM5PR19CA0047.namprd19.prod.outlook.com (2603:10b6:3:9a::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Mon, 30 Mar 2020 06:22:01 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8bef975b-7efa-4050-43e1-08d7d472a8a7
X-MS-TrafficTypeDiagnostic: DM5PR12MB1692:|DM5PR12MB1692:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB16925428CD5A02CBBE5D72028ECB0@DM5PR12MB1692.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(136003)(366004)(39860400002)(396003)(376002)(66556008)(86362001)(66476007)(478600001)(2616005)(956004)(81166006)(52116002)(8676002)(81156014)(6916009)(7696005)(8936002)(5660300002)(6666004)(6486002)(16526019)(186003)(26005)(66946007)(316002)(7416002)(2906002)(4326008)(36756003)(136400200001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c8Rih4VQNfJYFX9X4joYNZIphEEy/7rVp5icGA9yaBmYrcGn8ATKzzohbRGnkr5MHyd9YxdFNtFPTgDKdfbOvlzf4GZZfa2xQyVuINj/pZjs1of70D/rjeo+nyjt1zDtvMTM0sU/EUB2mhqYudy6+8GSCssGAuGafmR/V7G/4C9uoGg7/Tw2MNcmroqjBwP7HgBjOCHoPbJPttlxHEdzC8gEZNQ6uUfa6GHvXanc6Ine3j+xcHaXR+8U0/1BldZd5MK0Zwnpr0odhOLtV/lBdJ0yIq0I2ZjfEb6rTT5U5dIQgtU+wQVQtNlRSNkl2xhWUQ4ctmWCF1+e+nkc6srCYbaIFVZQ3WlPRfQiNq3B9S477yPt/fWyTTdxOc1ci/lU/D5z0oLxnCZdme/2+a8OKThL+3UP9LKQMz/lHNIu3y+Ys24Dk9gJZoC+jmm25WyTFDQ29kxBXN2JRlYZKzeTNtl8EJt/eVNJ4Ea5hAH8RsdE5zsHCnEGyjssEWKYHKRP
X-MS-Exchange-AntiSpam-MessageData: aC71mIUoralzDqXHomRZFpOpbuWJGt9N9N3KA4Ct/RxfSneA6cr9TgizJBr5qJ9jXtX/IA+aVC/18nnq4X0oinYUqyP04mVUSwVcJyCOHlv5Lk0rymAZru9SU00goSbzwAd987FTjKplAfm8kqtKWQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bef975b-7efa-4050-43e1-08d7d472a8a7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2020 06:22:01.8368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SGqA/PiRpdHJ3holf+cNlkCH+bBhVxsVxmSqMNbAfqKeByxFYmiyMrE+6Yxooxq3BMSNB9xRNGzIpKTGLY0pJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1692
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

