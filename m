Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE2F97A0E84
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 21:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235225AbjINTvO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 15:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbjINTvN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 15:51:13 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2044.outbound.protection.outlook.com [40.107.92.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8B4D26B9;
        Thu, 14 Sep 2023 12:51:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UMNSlqGePFkovyEPROHLEWtdK1m68KRZtbNw0UmgMLsahmYmQSOtjMa8xuxj+N8Bm5oYMi83/ZeYh9ZN0xM2f2kb9vKvBtPRggD9SEd3FSZuX59vwqimoyjEl9qHVKh89U7CybovnVaRMU9osT8DrV0N+vprLxUDhTXaDa7VQTNL8cuypbYoKX9LaU2Fua8cNESoDYiUsOfH3Fs8LUSJXwrj+hb4uMOcPA1MQVXXCPWWKDFWcEpxIKu8c0t20b6N614RpkCoLYpsYTbKqYxRe9hz6HqA0cN6uN+h9KM5JfojD/fn6h96opkNCdVZylbLf78URs+96XvVNszA4FEMMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1WewHaQJRZuO/F2VVQBDDPJX3nc034Sd53GsFKl1Wvk=;
 b=mQ2NYYgXlMy+4GQHJVkGCd8hZSahPc4Sj3OHju05/Yr3hC6jCjY5XjDYAQvbDQJ/IojGcJU5Dt2PRwyBfEM5fe/7zVsAJHWvdf71nLQ2vK60noW2BK5cToKgxkjWWDEy6e4EWUJ8DTLm5naHrofvIo10miYPjVUIOdln0qx3vMBPQRbG7mCweYJRIE723/15s/jXrMuYAdZBfmFM2+YXGKml72rxqi6pgroTMT7ObmgAfLpeaiwCIxsEJTjWPA1ctQXzm0pGL5UiG3UbGbmu639GT5ayv7BCgUlxL5Zi5A/RltCAmQzwbCrUA4NFMNE7vZ2JP+dBWTTGWwgvRVO4pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1WewHaQJRZuO/F2VVQBDDPJX3nc034Sd53GsFKl1Wvk=;
 b=3hjZQJUNkjhetVdGUSQQQolM4skAmSdhtXOge1Zsji9Kt7ZY9bjCqRcObBtUAiIm814RFkHLMxrU90Cz71zwD1WRMrKDt0E1nS5mIfkqTu81s++D2JnW9ghUFg28/Fz3+LoZmU9DupBjuMJTgvoIMJKLv+dOTpMssbgJ2wi7oUI=
Received: from CY5P221CA0057.NAMP221.PROD.OUTLOOK.COM (2603:10b6:930:4::18) by
 BN9PR12MB5338.namprd12.prod.outlook.com (2603:10b6:408:103::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.20; Thu, 14 Sep
 2023 19:51:06 +0000
Received: from CY4PEPF0000EE3D.namprd03.prod.outlook.com
 (2603:10b6:930:4:cafe::9a) by CY5P221CA0057.outlook.office365.com
 (2603:10b6:930:4::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.21 via Frontend
 Transport; Thu, 14 Sep 2023 19:51:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE3D.mail.protection.outlook.com (10.167.242.17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6792.20 via Frontend Transport; Thu, 14 Sep 2023 19:51:06 +0000
Received: from tlendack-t1.amdoffice.net (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 14 Sep 2023 14:51:05 -0500
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Babu Moger <babu.moger@amd.com>
Subject: [PATCH 0/2] SEV-ES TSC_AUX virtualization fix and optimization
Date:   Thu, 14 Sep 2023 14:50:43 -0500
Message-ID: <cover.1694721045.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3D:EE_|BN9PR12MB5338:EE_
X-MS-Office365-Filtering-Correlation-Id: e1b5c6f8-5995-4817-290d-08dbb55bef3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AbuE/PZPBfiiPM/uyVLDyZWYatWtqh0yE9sEvAkKqdvLZ8NVLgYKpRWhNI8DuBla1CPTLRZWdtt2Kqv3v1iLO/N/s65cm9URozAh1ua74dXdRkfHuKmiK39RJtGTvBNDHpWIfcHv53kNXvjHKyL/IAlI6PQckrPvTUQ3aXSrZsZjApL2r0aLJb3J3J0tTuKwRCHeZm6uwkn045vtonnRhJlzPEJJssJFPj7JTd+TxDtBQTjF1IF46qSblT0AZS7sICHk38nYimshIfg8qSGh65S0tTSLz/v8oK2h1ehnGj3gsgUIDdGCY7WAY+9ygbiGQw02XYuPrBwyykUOa03AqKeclWUBYwgYvKddp5n/eX4saMWvDZQONngxdLTtdymtefr1PcmMKNM+IHvKtRHoSE74geinv5MxpCSCpr8yErd7LQjWYNKTPgPqxj/oZne8WJUqj3+Wln0kxl7zdBbDX2rS0osgsMge0bru8YhkfW85YcH3RoF6oornz9zAwJNRlER96KqwhDRk8Y3JBFmLoxDJD0KYA1Ie0cdYzmm7VTyo0kvfdfo4IgZJk3l4V4axaWS+v7kn4MX5RgGxDrTZjY5eUN6JHpYlEWk9NMfQEc1gcoreSMaTj3tEq3B/iXUt31x5bH9p53iVg1yoKmMaZhdct05G0DlhryPfTCmMi/hHaxriTiG8MtIH9ovS0R0dz8t8pvvFLrzvaEH82AMccfYC5yTVbvHNbpk9gfH1jG3PLOTnDvr9nLJJblvd4w4r
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(376002)(136003)(396003)(346002)(451199024)(186009)(82310400011)(1800799009)(40470700004)(46966006)(36840700001)(41300700001)(4326008)(8676002)(8936002)(110136005)(70586007)(5660300002)(316002)(70206006)(54906003)(4744005)(40460700003)(356005)(81166007)(47076005)(83380400001)(36860700001)(40480700001)(86362001)(26005)(2616005)(966005)(426003)(16526019)(336012)(2906002)(36756003)(478600001)(6666004)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2023 19:51:06.2402
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e1b5c6f8-5995-4817-290d-08dbb55bef3b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000EE3D.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5338
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series provides a fix to the TSC_AUX virtualization support
and an optimization to reduce the number of WRMSRs to TSC_AUX when
it is virtualized.

---

Patches based on https://git.kernel.org/pub/scm/virt/kvm/kvm.git master
and commit:
  7c7cce2cf7ee ("Merge tag 'kvmarm-fixes-6.6-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD")

Tom Lendacky (2):
  KVM: SVM: Fix TSC_AUX virtualization setup
  KVM: SVM: Do not use user return MSR support for virtualized TSC_AUX

 arch/x86/kvm/svm/sev.c | 41 ++++++++++++++++++++++++++++++++---------
 arch/x86/kvm/svm/svm.c | 29 +++++++++++++++++++----------
 arch/x86/kvm/svm/svm.h |  5 ++++-
 3 files changed, 55 insertions(+), 20 deletions(-)

-- 
2.41.0

