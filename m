Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4FE6DDB52
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 14:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbjDKM5r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 08:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbjDKM5o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 08:57:44 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20601.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::601])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D588E3596;
        Tue, 11 Apr 2023 05:57:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QOg0g+UCIKeaMDjGLz1NjF+DtIrh/v6zcltUKLqaigruQtjpNx3fCj2kRbzG6uvxPCC/DD/LM8Us5k/twI1KySMBeBlY24l9tLfdxAr7jBWeLVZAbCeD14ZSty6x/S3yeVTybLs8K773UE2werxjEdDCAzZXfQTypw0mAPRwodySnC5fdmi1UdZahPeYxtY2BtaLisn2sxA+Uvo3MJ6GBfspRndDM92+7Mam1LdvLQS0+ThGG9GYIwfpUvAkpFnZrl2McqxfxWatoronoKmPlYXv2WbIs4rcUCgQsq2oFnxEpXfQ6blnxhjgKGyyGhw5Kc5BYqSEalv+9+ynLiyZlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6akHvPytSWW+T1d0qLMeSDSVBA8yqoukOe7DUFGoOzs=;
 b=R3VijdX0HhZvTrudobEigwH+SeIydZwoUjTxrzS+zyIYHJDTo0alv9uQyrU5j0H9RIwX1A9zKC3I+VTTGcwh4fa029OaSZLEI5iUJ9up/Kc4LwsYBcwHB8L+4F0YaXOjzFxuvFqGRn7YzaEmuwgN1A+e/oFZDJEEvTv39W1X76tTeoJ8tVVDkYxp5aqaaZSgNrOygg+cFLpGL2XFZQ+YlXGG5zWfKX9LqUXIGjPILM0OeoMJYxRznwjUwFITVqGpzLnslZYbGz5DR6WuB2sfOse0BETEQGaXV6s4TVCu1ZxB3i9qzTnH0PAucU7f+dYRyruT79JGDySFRFaIKC1mVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6akHvPytSWW+T1d0qLMeSDSVBA8yqoukOe7DUFGoOzs=;
 b=rJmZzFycVdR/dwGo2U16wu2hf91/DlKy1IKmv4D+VnHIdo4fsY6HalC8bT928GUR7Ng7URKjwQsD4yzs4PlA1PdW7ThzhAAFB1zApt2VcCnXFJEPpYkyfzF+zjK6WsAFLwHrGFaPV27z7cW5ny7/AkRhYZ/aKz/4hB7sARdxUU8=
Received: from MW4PR03CA0080.namprd03.prod.outlook.com (2603:10b6:303:b6::25)
 by CH3PR12MB8329.namprd12.prod.outlook.com (2603:10b6:610:12e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 12:57:39 +0000
Received: from CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::4c) by MW4PR03CA0080.outlook.office365.com
 (2603:10b6:303:b6::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.39 via Frontend
 Transport; Tue, 11 Apr 2023 12:57:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT035.mail.protection.outlook.com (10.13.175.36) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.28 via Frontend Transport; Tue, 11 Apr 2023 12:57:39 +0000
Received: from aiemdeew.1.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 11 Apr
 2023 07:57:33 -0500
From:   Alexey Kardashevskiy <aik@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        "Pankaj Gupta" <pankaj.gupta@amd.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        "Santosh Shukla" <santosh.shukla@amd.com>,
        Carlos Bilbao <carlos.bilbao@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>
Subject: [PATCH kernel v5 0/6] KVM: SEV: Enable AMD SEV-ES DebugSwap
Date:   Tue, 11 Apr 2023 22:57:12 +1000
Message-ID: <20230411125718.2297768-1-aik@amd.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT035:EE_|CH3PR12MB8329:EE_
X-MS-Office365-Filtering-Correlation-Id: 72847b36-fcfb-4f98-f263-08db3a8c54d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /v1pQIrbYePh9p0Wm4J1RCGw2CVC1kyTT3WcaV/H+E3lzfxaM1+7zfPNmFLC3kf5J9R/0/97iMlq5Iqd1g7hBqV7T/4hW7Q8VRhmD5H6Hi3RZ8AC2JE7anfq3NhWi6iGxzRft8q8bPGRbBVTdoGqC1Sh2i7OUiveT9QWauyPqvnJ/zVDnNjUonaSS9kqlbmiQ0JXUYCBnxwwxer64phvdIg92pRNXb3twyCb0lr+nSJRREf7zdib6FSod3MgVhXfO7hGt2dcz6wESxmk/a80AeaJ37HGc5fDiJvG6XOIh81VmmDUw8u7A5qzZ1l6qTdqtj4o+U99V1UxH+oCabJHalKOPxbslicc+tsW2lQ5iwTNtNtvNe+t7nU501//xIVvuuHxx1oCfmsK5NT6wZdF6l4Ho6N+bjWQyvlhurKxq95/tYDmlPI4Tv2fABPNcCEmMo1J65zDvoXbXyqA47UZYXWHOswJ+UxaBq9PvVKXr5CwSmAm5qojwwUCSu6rPCh7qYIK2NQ7rWApIJhQaJBFef3xZ8mIL6JvKYdMM7d3B05q9pZ2HHEqUVEfBQWyIReKMbWlo6JWE+gXLweWcTi6cgTob3TBVsWmhHwLIOC7rboojPbLbBYDxq0D5baQNeoJ6ByO2ouR0wjuPfnlu5LWp19K4A+rG3FxFfgVVkxtdIfXNXhJUMa8oYNxLrXfRclOxckt4JIfFARvaLwy5dJTMh63syfH7WE0RRi+KW2W54k=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(396003)(39860400002)(346002)(451199021)(36840700001)(46966006)(40470700004)(6666004)(478600001)(40460700003)(40480700001)(47076005)(83380400001)(36756003)(82740400003)(81166007)(356005)(2616005)(36860700001)(426003)(16526019)(2906002)(966005)(336012)(316002)(1076003)(54906003)(26005)(186003)(41300700001)(8676002)(4326008)(82310400005)(8936002)(6916009)(5660300002)(70586007)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 12:57:39.4372
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 72847b36-fcfb-4f98-f263-08db3a8c54d1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8329
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is to use another AMD SEV-ES hardware assisted register swap,
more detail in 5/6. In the process it's been suggested to fix other
things, here is the attempt, with the great help of amders.

The previous conversation is here:
https://lore.kernel.org/r/20230203051459.1354589-1-aik@amd.com

This is based on sha1
f91f9332d782 Ingo Molnar "Merge branch into tip/master: 'x86/tdx'".

Please comment. Thanks.



Alexey Kardashevskiy (6):
  KVM: SEV: move set_dr_intercepts/clr_dr_intercepts from the header
  KVM: SEV: Move SEV's GP_VECTOR intercept setup to SEV
  KVM: SEV-ES: explicitly disable debug
  KVM: SVM/SEV/SEV-ES: Rework intercepts
  KVM: SEV: Enable data breakpoints in SEV-ES
  x86/sev: Do not handle #VC for DR7 read/write

 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/svm.h         |  1 +
 arch/x86/kvm/svm/svm.h             | 42 ---------------
 arch/x86/boot/compressed/sev.c     |  2 +-
 arch/x86/kernel/sev.c              |  6 +++
 arch/x86/kvm/svm/sev.c             | 54 +++++++++++++++++++-
 arch/x86/kvm/svm/svm.c             | 48 +++++++++++++++--
 7 files changed, 105 insertions(+), 49 deletions(-)

-- 
2.39.1

