Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2188515B685
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 02:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729438AbgBMBR0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 20:17:26 -0500
Received: from mail-eopbgr690085.outbound.protection.outlook.com ([40.107.69.85]:13123
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729185AbgBMBR0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 20:17:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VHmJIBSJqBOyialXDCUgKawhWOUIkHljemhLa5p0J5uvaPNQoe9ENWB0A/IRszCOSvZSOrNVgfUAqqAY3HxHvt1g6DadV66VpJoQBFauwxY7PZhWy/7F3jLOJ2tye7l8XM8tTdwdpL+/vlCN/cakxnRy8bJFHlvz1EIY8NHB/O+nFpYnsDBcVQmeCa4ichjygYDKwq5Q6XpM7+zIyL4S9ArJ4gb8VAPt8slXRqDEgk9aVxQ08/viNy9HOZBKJ583qeZ0nWoq39XzDCNQyPNxMp0u90yLtKr10mzMFtQM7Ny5E2s8Co3WyOiiPt+r+RLEgWkE0Aztj1xi8dXn0qrcjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X+Iu2xmsUxsKWhuGI4SOjsMMel0pkApSe2TKFMkFuD0=;
 b=I9wFq2yHJXIrNvv/okv6GJbODXnA2zZVaJitzQ8BhN78a+7YZ1f/s8XMf0DQA7hBIEf9HMSx5bIkP1ZSBEUqW/LZqVahYyb45WUkRdgj09OvQw9FhqQUQfG696P3JM9BqCvuUwBfuEfx4qp8Q+4+Ve99UbS+SDqXIQFB2bV1vYD9V1izL6Nu6oEU1fEYaFySr9L7zj1CJm35P4yA244Kn6idAYaSPDmHy9wiVXn3G93xZ50GL+XKbe7wGTh29d6oythu/OFY8Yw2UhiKRAu9CTsi14Xvm8+dxlqYU20bSL5v/JMbj2m8rs9MeFziCZZUws5QUSOyp+29AechCht9YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X+Iu2xmsUxsKWhuGI4SOjsMMel0pkApSe2TKFMkFuD0=;
 b=OCtPmtJUNW8DTYRjrNWyn9aWo4f4QoP8ByUWBpqdlDtm995pGsfqzti0IhupRnBDrgyMMRt/dXn1QAkSPpzRqgwx5gj1KeETQPxKop8B3UV1UVxd38QHnftWlqx5tyA6JyTcg4OMO+TMmS0ELh+JLhBxGhBNBP/yRw61omskF3M=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from SN1PR12MB2528.namprd12.prod.outlook.com (52.132.196.33) by
 SN1PR12MB2366.namprd12.prod.outlook.com (52.132.194.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Thu, 13 Feb 2020 01:17:23 +0000
Received: from SN1PR12MB2528.namprd12.prod.outlook.com
 ([fe80::fd48:9921:dd63:c6e1]) by SN1PR12MB2528.namprd12.prod.outlook.com
 ([fe80::fd48:9921:dd63:c6e1%7]) with mapi id 15.20.2707.030; Thu, 13 Feb 2020
 01:17:23 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, rientjes@google.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/12] KVM: x86: Add AMD SEV specific Hypercall3
Date:   Thu, 13 Feb 2020 01:17:13 +0000
Message-Id: <c22d2c97411a5fac211eb54e98d05734b149a5fd.1581555616.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1581555616.git.ashish.kalra@amd.com>
References: <cover.1581555616.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR11CA0064.namprd11.prod.outlook.com
 (2603:10b6:5:14c::41) To SN1PR12MB2528.namprd12.prod.outlook.com
 (2603:10b6:802:28::33)
MIME-Version: 1.0
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM6PR11CA0064.namprd11.prod.outlook.com (2603:10b6:5:14c::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.23 via Frontend Transport; Thu, 13 Feb 2020 01:17:22 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 48ee5015-988a-4d3b-be5c-08d7b0227b12
X-MS-TrafficTypeDiagnostic: SN1PR12MB2366:|SN1PR12MB2366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB236669D48B809B8EBE0D49388E1A0@SN1PR12MB2366.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-Forefront-PRVS: 031257FE13
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(366004)(376002)(39860400002)(396003)(199004)(189003)(8936002)(5660300002)(66946007)(66476007)(66556008)(7416002)(2906002)(6916009)(6666004)(4326008)(7696005)(52116002)(316002)(36756003)(6486002)(86362001)(956004)(2616005)(81156014)(478600001)(8676002)(81166006)(26005)(16526019)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN1PR12MB2366;H:SN1PR12MB2528.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +MOnGHb5X09+LQNXc5SnbMAjvp/kaOaoEEkv2CbzOxMxqbQaI0kAtewLFbjm06iieu3/whamauXR6bryB4xLZaOlwsd2ukmPqIoWaKrAIaop78GwsWaO6vju18WkuQYsL5oecVeE9a4KGlthttGDxl0EmwjGYCHJVMN/8+0a9LX+dzHJNj5OHKUnrY50F+kzzfuIQIFxnXXj3RBFDr/xoD+QXvkqqCqnURY46x3o4Gh8rQodqNX1eVarpA3Z4EBYfjYnfWuYTogzrtill00IkIHI+VdSup+KEqd+vHXwLK3kCYKJkoWipmbqoTY34g8pdfzuPFsfhBBL2Ez6hJG3S3MHzRbqkBAlvYO0qxQRiKdrKW3BUUG4CUKN4XFRjWsMgE40MAj2r+RitlCGB6AGNiVprNsWMkof1yejizhtWHvfSGtsi2BXCZal7HRFzwKj
X-MS-Exchange-AntiSpam-MessageData: EYJCmYunl9xubg5LOdgzsnzgzKhDyHMiJ11E4kjq7l6NbkoOvSVpowqjFXmr3m+b+kUO3TWVcKXI3GJT/Go3ExNCPmO7Pp7XCPlV859wWzFwVVORWKR3fMF/FSMKWxy4fcZVvi2wuYw3n2RVQvUzLA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48ee5015-988a-4d3b-be5c-08d7b0227b12
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2020 01:17:23.7606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FaMAZnfsEHS+/z9hXFyxLiymz8CmXmbJYbpUe6c39f/lftCNCsU/Qtx921NIMK25f9RknIq2S5S3WURQNz8eJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2366
Sender: kvm-owner@vger.kernel.org
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

