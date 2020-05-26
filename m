Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 986361A070F
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 08:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgDGGNX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 02:13:23 -0400
Received: from mail-eopbgr760043.outbound.protection.outlook.com ([40.107.76.43]:9670
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725802AbgDGGNX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Apr 2020 02:13:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gnHHZ0DJJKNbViHKBgKcWig9nym4WeFl9OfvcTdHbosEjv++iKq/+jbzxDtVQKH7om35X0o2EXIW+aGgSd572nUn5aFse93DlY5G+RKu/s+PKOmc+cZCXxB1nfXHQEHeeOaoWH+UTauG9zGU+utY5vXyXmtYf9cbjhlaGmWmpXe+Esc/uqIHajY15klI1dK9iOCG7xJptYCz30jzoAovISqDE0qEudnGu5+18jto7d6wycjUR1LPykH9hqESRZb312q44yWo1wpX95XMnBXITLSgG2zeF1zvdBpi90tSRdRqjAhrFbuF0GDWrrVZH1W/UWD6deeaj9S4XhlWkAhNfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dg7ZqmOdtpnlk1OQiets3N5Y3HSftsSf1ihldmuggoQ=;
 b=nec/ST07CRFjo+xG57nVEWGSZaOZyZyMGtMdc6FieUDLhd33jZxNUkCKZY2Qxirq/z+S8XtYSkSsI0EpW+neIaYNzzWVon2C2fOZtLDPIKrLlOc4oqTPkiH88BtaQkySzrahliiMTg1AX49SELhU+FvX7JjiG/Qb96tSZGOwfhNdic7/4j/0fdHMHZu5g24WfO2yJ3s3tlEGbncpIqbXT0uNa+rlpEDADblz6hbXhmX53wrZQo7O+xDjtp/BldIsjNiMpnmnTH42CdpO2v+WnLiKCOGoit1LZK8hEF5R9XwB6rpA3rd3185Z0GqKYg/6jSw14/j2ZTyj4JIb9p6ARw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dg7ZqmOdtpnlk1OQiets3N5Y3HSftsSf1ihldmuggoQ=;
 b=pCGTwxkzg76JecwiwPDtWlfbcVs479jInPtotEEQaBbOnGW+mnIAwb9ocH/PUuIRrTxwwSB8s+ZxMFC0IEfYe5Xc3T8cAErwZzdRp6oEtxiVinzszUNWpULGvdUc6J2zKu430WIrmUs8WInW/eYaYuj9M+wXeaHPrd6fLSx/JC0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (2603:10b6:5:1c4::14)
 by DM6SPR01MB0036.namprd12.prod.outlook.com (2603:10b6:5:61::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15; Tue, 7 Apr
 2020 06:13:18 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::2d84:ed9d:cba4:dcfd]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::2d84:ed9d:cba4:dcfd%3]) with mapi id 15.20.2878.018; Tue, 7 Apr 2020
 06:13:18 +0000
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, joro@8bytes.org, jon.grimm@amd.com,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Alexander Graf <graf@amazon.com>
Subject: [PATCH] KVM: x86: Fixes posted interrupt check for IRQs delivery modes
Date:   Tue,  7 Apr 2020 01:13:09 -0500
Message-Id: <1586239989-58305-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: DM5PR21CA0037.namprd21.prod.outlook.com
 (2603:10b6:3:ed::23) To DM6PR12MB3865.namprd12.prod.outlook.com
 (2603:10b6:5:1c4::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ssuthiku-rhel7-ssp.amd.com (165.204.78.2) by DM5PR21CA0037.namprd21.prod.outlook.com (2603:10b6:3:ed::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.6 via Frontend Transport; Tue, 7 Apr 2020 06:13:17 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2c1ade45-3bd7-4a8f-41ee-08d7dabac3bc
X-MS-TrafficTypeDiagnostic: DM6SPR01MB0036:|DM6SPR01MB0036:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6SPR01MB00368BF3D5E1477B1A142214F3C30@DM6SPR01MB0036.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-Forefront-PRVS: 036614DD9C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3865.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(346002)(376002)(39860400002)(396003)(136003)(2906002)(956004)(8936002)(54906003)(5660300002)(81166006)(81156014)(316002)(36756003)(8676002)(44832011)(66946007)(6486002)(86362001)(66556008)(478600001)(2616005)(186003)(52116002)(7696005)(66476007)(26005)(6666004)(4326008)(16526019)(21314003);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GXNSa4tnlLTCGXhu9z+dOi3CaAO4BTCvTJ9SpTOfeHikfrXNwhnrXZyC+7y1S4pZONXi6iXchoOa8cHCjktjp3NzloDouEwJd2UNRsSjqysTn/rku6ikRy9UZ2MZa/zjf1d3yJjlSvAoaAmzre00BIxvJ7sqXq0Gl+1EXZJSUQWYiezRPbhfb2U5MxpDsjIUYQDySd1w0QgqAk0jqfAQjCFupHCnXLG+QB9CMhu/fVNEEFQdmG2Td56uflTaCbxZpyZBOmxI1YqdbqUyx6fyRWEJ3F+WNy3PJi/8AGiOSVKjM3aKayftN9tzBbP+UMYDTT0XOZ43BLWl5y8JN1PTS3dcru1N8OYZ+rJe/YMIf0BWSCii0DY/5Wp5KlBOrhTiEqLTIU+lp1P4Oplw/bzuDnVhsc6BLGwg5bIV9SEKJ1xc/RKgCCA3ruyUQymbvPHekLtS4Bxl9e4dMIciD9JVR/zqT2XIE1eW38zsw7CmeAk=
X-MS-Exchange-AntiSpam-MessageData: 3TwdOSKPhKyqR26FG4cqQRe/5hLHHPDNI+Y+H+OIn/znZvnUsmYpGz5DNwkVnbufDXzK5q8/34oLf+65VdKrlhO4SUDnJ+THQkkjK2iqNqErA6fbXAW98vYD4N95/l+5X+yqyD8SPxj4IZEEhPTXfA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c1ade45-3bd7-4a8f-41ee-08d7dabac3bc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2020 06:13:18.1500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EDc84LflynubXaR4UALvBYVSbl1nETR1hviNoH0G9LMvekeOypSoPkEY2Lsi8HWaKOlnE2A2g20m7CgLFyiaig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6SPR01MB0036
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Current logic incorrectly uses the enum ioapic_irq_destination_types
to check the posted interrupt destination types. However, the value was
set using APIC_DM_XXX macros, which are left-shifted by 8 bits.

Fixes by using the APIC_DM_FIXED and APIC_DM_LOWEST instead.

Fixes: (fdcf75621375 'KVM: x86: Disable posted interrupts for non-standard IRQs delivery modes')
Cc: Alexander Graf <graf@amazon.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/kvm_host.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 98959e8..f15e5b3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1664,8 +1664,8 @@ void kvm_set_msi_irq(struct kvm *kvm, struct kvm_kernel_irq_routing_entry *e,
 static inline bool kvm_irq_is_postable(struct kvm_lapic_irq *irq)
 {
 	/* We can only post Fixed and LowPrio IRQs */
-	return (irq->delivery_mode == dest_Fixed ||
-		irq->delivery_mode == dest_LowestPrio);
+	return (irq->delivery_mode == APIC_DM_FIXED ||
+		irq->delivery_mode == APIC_DM_LOWEST);
 }
 
 static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
-- 
1.8.3.1

