Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8982B6749C1
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 04:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbjATDLl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 22:11:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjATDLj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 22:11:39 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2045.outbound.protection.outlook.com [40.107.93.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 180BA6581;
        Thu, 19 Jan 2023 19:11:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XBoNE+RdS/BL8Lpw53PbXWbtjsCbZ8RiTbxuhFzyHXdnZA9HWvsFhUNj1L/8+0aYtfjJAHqQrZPKt/SpKfYBR5PTq3Br79C2n/bA5y5C1Tn+Z42vOvOkUpACayY+LGpNU8WcsyzrILKN7w40PwfaS1tMSMU+571kt9hFWaymOgt2sw9Gpi+XfB58XijhFvjBmj4U0VK8IGRD/GzxtFYGo7zX2BoB6WlubKMWp4xv/1fET+apLiaQsnJR4ULp5ll3LX8JfQ6cIW9ccUgzBSSvN6fyN45ISHUieVUS2xhLcUaIEuQt6NAJW6i4b3my61Cg4YT1JcHAIekFnQTRB+xfqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BX6aBKsx0I4JiZKX8Cnpb+AF2mOc17X+hprsy/pXyuQ=;
 b=DUHPV0rbDNwvM78oaK/koM6L218yRSmiC/cvvtIbQEAAcvO9HgySUFxaQABVhOoA5wyxJ315dWCZBzl+YFAMLW8p6sjhE8S4KOZf3Zsj9YSEomigV5gVm6DAwn0WTLbbl/ymO7k1fQz0H8biCoUzK5JKQBD5CfYVG2MViLeoIJ5EKvN1CEiQtUDAk3auWL7NJMOfHS+GrZbMj5Kf+a1ETFtPM1ytkEWF8R0mrlYOqF+nUES4ExHrf+17oXu1VL/42WGG9lv2GdDQ3c+Y+qpGiN9NNeQOGbye9X/NX8yXEVnVzuCVLlOQNFYLIR7sudEbDRYxrTi4KkmfILLBokxElA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BX6aBKsx0I4JiZKX8Cnpb+AF2mOc17X+hprsy/pXyuQ=;
 b=bXtQmIEKNOZ7FFM0OFXqK55Ug6cQDJUeoKHoQomKb7V6kec00iJeefX2RaPv3LgijQL2pfCzNIoMgekZB6458RgxdRvHch/q66O+mn309L4nQwBDAHvjF/tcSH/3oXxCrjOxRgfRjckLfuoTso/7iZxl3hhGR8P/BYa+qm1ODrs=
Received: from DM6PR21CA0001.namprd21.prod.outlook.com (2603:10b6:5:174::11)
 by DM4PR12MB6040.namprd12.prod.outlook.com (2603:10b6:8:af::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27; Fri, 20 Jan
 2023 03:11:35 +0000
Received: from DM6NAM11FT111.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:174:cafe::9b) by DM6PR21CA0001.outlook.office365.com
 (2603:10b6:5:174::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.6 via Frontend
 Transport; Fri, 20 Jan 2023 03:11:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT111.mail.protection.outlook.com (10.13.173.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6023.16 via Frontend Transport; Fri, 20 Jan 2023 03:11:35 +0000
Received: from aiemdeew.1.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 21:11:22 -0600
From:   Alexey Kardashevskiy <aik@amd.com>
To:     Alexey Kardashevskiy <aik@amd.com>
CC:     <kvm@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, Yury Norov <yury.norov@gmail.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sean Christopherson" <seanjc@google.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Kees Cook <keescook@chromium.org>,
        Juergen Gross <jgross@suse.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH kernel v3 0/3] KVM: SEV: Enable AMD SEV-ES DebugSwap
Date:   Fri, 20 Jan 2023 14:10:44 +1100
Message-ID: <20230120031047.628097-1-aik@amd.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT111:EE_|DM4PR12MB6040:EE_
X-MS-Office365-Filtering-Correlation-Id: a484c77c-d076-40cf-fc5f-08dafa9409ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wGSRDRlj5ajM+qYpkw9L1OJYLjpQR1DM3NqD7RbF94g79yaznqkki9l1FwLbDVPAL6ajB8SFDvUW9u0aiaFQvgVGxkXg5aZ9j5aivw5nhrn4jCn7JIdZgQWBCAPeZ+DjtyftR4+wm7s+FstNP2elfYwVMlFZIWdeVoiXS5Lmxua2rYOO8HgVgGl8Fhy+BBCqiLvvhg5qog9/suwwCJN1A/1ZlAqCCePiv9iF57h5A3QW5mZ7FSKHDxP/g7yNlDT4Y9NUN17DFa0z+JW1tlJc+sEo7HrbMDECWJcuttUpCeWAySJtvKLsr2pg5ebV4RbXQ1zQ2oIv/F9MDzUSj4erOijj3aY/6LQbjfT1v+4x4lbxMsos64+Q7BwjI9Q/sY2xwGARLIE5rg6dK0RoAGoB399wlowTm1Cdq0LvwGHKei5WN95HZSs0veqAor6J5UBPyyLeMs7XWjlPlJr48S9Q4tHXxLGWRwj79IZagjzcZ4x9FV7nmBSySGXGdwnsOm+6OVbas7d2ckZgBVSS4FzF9gIq6ckcidRiB1geHSkFzDJwBVjEPzChc11ZgmLi0L3LAeJ5iiedjUaI+Y4+rlwfQ9J+r9c4i4RmQ0oXYuPR6J9VUgQd0yMVAFnRaw1cpPHA6gjoa6TtZkxe1mrnf/VSv4TrarWwBdtzL0q3Bu2aYRXe8Nxr+/6k1ZKaeQ2yY6WpByvWtDv+3uhNDL56TbEEUOfGLw4h4jkuwe6l8na68nZzGtJ7SCGWqU9xhlw0HWJhGy1INB4AJX0heSjN6lBjAw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(39860400002)(136003)(451199015)(40470700004)(36840700001)(46966006)(1076003)(41300700001)(2616005)(36756003)(7416002)(5660300002)(336012)(8936002)(6862004)(316002)(37006003)(70586007)(7049001)(70206006)(8676002)(4326008)(26005)(16526019)(186003)(82740400003)(82310400005)(356005)(81166007)(2906002)(83380400001)(40460700003)(47076005)(36860700001)(426003)(6200100001)(40480700001)(478600001)(6666004)(966005)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 03:11:35.5440
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a484c77c-d076-40cf-fc5f-08dafa9409ff
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT111.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6040
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is to use another AMD SEV-ES hardware assisted register swap,
more detail in 2/3. The patches are fairly independend but required in
this order.

The previous conversation is here:
https://lore.kernel.org/all/20221209043804.942352-1-aik@amd.com/

This is based on sha1
195df42eb64d Ingo Molnar "Merge branch into tip/master: 'x86/platform'"
in order to have recently added X86_FEATURE_NO_NESTED_DATA_BP cpu
feature.

Please comment. Thanks.



Alexey Kardashevskiy (3):
  x86/amd: Cache debug register values in percpu variables
  KVM: SEV: Enable data breakpoints in SEV-ES
  x86/sev: Do not handle #VC for DR7 read/write

 arch/x86/include/asm/debugreg.h        |  9 +++-
 arch/x86/include/asm/msr-index.h       |  1 +
 arch/x86/include/asm/svm.h             |  1 +
 arch/x86/kvm/svm/svm.h                 | 16 +++++--
 tools/arch/x86/include/asm/msr-index.h |  1 +
 arch/x86/kernel/cpu/amd.c              | 47 ++++++++++++++------
 arch/x86/kernel/hw_breakpoint.c        |  4 +-
 arch/x86/kernel/sev.c                  |  6 +++
 arch/x86/kvm/svm/sev.c                 | 29 ++++++++++++
 arch/x86/kvm/svm/svm.c                 |  3 +-
 10 files changed, 94 insertions(+), 23 deletions(-)

-- 
2.38.1

