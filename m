Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF357C4087
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 22:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbjJJUCx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 16:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjJJUCw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 16:02:52 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 815F193;
        Tue, 10 Oct 2023 13:02:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S5a0d/CnMh1dRpiCDFCixRm4MJGVP0llX3FMkSmaDOhb2yAMtyZk0kXDpr3jleDKvnKqKMEQ6VWbwHsFTQgfw3wgeIBsDBibNiZJzQqJdsu4wknSqFra+WXIHW7MC0RQcx5BooAAMIKhSASQm2vqaxPkBUHvzmhtxBdvdqMpwPo1/UwbgxaS/aLzPkrgHrHX+Mfu/G2gju9GxHWye5GLNWcGAGwceHYIeLgOSBWTo2jqGFDrzm3nzRnsBf+obYK01dNxUsGtwAMq2lm4BmJUYs5tcuwG5x9kml1uGx+NILA17tD4BgU3+/UoFj+usfNKaC3q6azVLzr/Nv+so1kFvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ls6w1wioc5qtCaNb0ITC9OLWtGU6drzQSkvecCKPCBQ=;
 b=YSbTBcgnpTwWLxQ+mq3v8p9FEzSAmAIM9Z9l+Luxwa2G8o6LoiI/FmdXFMCCiqBXFdfqJ+nPtX1rhHpXhQHgKZsmqzJJP6VcCsaOgg61m6B5V4kz2A5kElkmyBYy0iwc8rgW1JA/Y0mfzVxu+joxJXWwIk1vpQinS44HM82nmGxSnxHCRxni9OaGvJKwO7orjEs//fU5dzZt7eXVo6fdzspZKKaiki6w/WXJEZ4WwdhVFDSpk4TzNpp0lXI4bhGEIGg2thvNk+VAP3QHjjrbSL686d/gyZvvImvFuJIb+o7rEzVLH43/ar5Vn/MZJ1ZKeBNcEe/J3tLXTVffGK9m+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ls6w1wioc5qtCaNb0ITC9OLWtGU6drzQSkvecCKPCBQ=;
 b=DgbOYo+vCPyE+Iz5zEWhma+u26vVcbMQQijk29sy0s+DvfF5cfZPjEGFPdncIDnGzOg7pQR4CBkRNJu/+fvBqNCctjDJPsQZhSukFxw3HqlndBcvJy2lVm7yrb9db+j2ZmO4D+iPQ3HXJE42PWkWkp4701sO7+3MHb+K6ggeS4g=
Received: from CH0PR03CA0279.namprd03.prod.outlook.com (2603:10b6:610:e6::14)
 by DM4PR12MB6590.namprd12.prod.outlook.com (2603:10b6:8:8f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38; Tue, 10 Oct
 2023 20:02:48 +0000
Received: from DS2PEPF0000343B.namprd02.prod.outlook.com
 (2603:10b6:610:e6:cafe::8c) by CH0PR03CA0279.outlook.office365.com
 (2603:10b6:610:e6::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38 via Frontend
 Transport; Tue, 10 Oct 2023 20:02:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343B.mail.protection.outlook.com (10.167.18.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Tue, 10 Oct 2023 20:02:47 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Tue, 10 Oct
 2023 15:02:46 -0500
From:   John Allen <john.allen@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
        <seanjc@google.com>, <x86@kernel.org>, <thomas.lendacky@amd.com>,
        <bp@alien8.de>, John Allen <john.allen@amd.com>
Subject: [PATCH 0/9] SVM guest shadow stack support
Date:   Tue, 10 Oct 2023 20:02:11 +0000
Message-ID: <20231010200220.897953-1-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343B:EE_|DM4PR12MB6590:EE_
X-MS-Office365-Filtering-Correlation-Id: ebdb5c18-94d6-4889-2071-08dbc9cbe01d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8fneahThQwfvtJW+aAUNrPFaHSIZ0boLz5L3EG33mmbeVNbZ0jN3iMYc5OMaCTbTNHoO5SYUrJcKNJtcB/VUuqss1qpJhGqTUaJveKFRXo8uNSEh6e6yQHrUWz5MJFYxbr4WlAzRUiyz4dlCHGxYN0IWZJ1EKdoFCZLQ5qIVVy9pt7tK45UbQRSjhLP2SP7mzqZqg/+ulJxTOcSC5xPPSDOGQFrhwFAZ4dl/OE1izzwQJ8dolldlBkGei/C+RpD/g+4je0vpS2jK6M0mb8uTt1TBvzwZ7UJnIw1iYNlUpjR5Aq+QSA5nkL7xKb1cYxsIOTwaNwLN7kYZF1ZtXmkV62uXiPTjTSxGOc8+L7McxzAbd2GHtMnTDImU6Zfg+Mt+Znpn5IzNXQ4+ZlK4s2Z2nPGP9wgb8G/sVw9VAlGa5n+l30lWOPpT15V522PPkE8ECoZ1t8DTsOGiPygLecqy7jbPn77UBiZT4Fw35BOXrM7DxkZHrRYCw8eBqPhxq76Hm7xwfIolOWL4ZzCfwqO3Z9NvZjPXUbz1UEnshOicZkTh4NMRWC360Hyk4Z2v06wVluyXrnPleV7Z6UkSiNCiuuwB6Duv/dINYnvW9FAyc8GZME494Vd1AT1x5k5+oJIX9ufZ21Juo7V/OUbVJNRgb9Fbr2w233rDmRpbC8RIuNjuG6eR515RS3Bdaf8eY5q08yUrhUj9Onh1mT7SiB8+DA2VrjixQJeSfdP4H94ZSs8zkgOdmEcGMI6vS86RWEdOSJ7KrC8q9uu/+/b8wXm/ETcyILa2Vqh+G3DyYohUkzE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(346002)(39860400002)(136003)(376002)(230922051799003)(451199024)(82310400011)(64100799003)(1800799009)(186009)(40470700004)(36840700001)(46966006)(356005)(86362001)(81166007)(36756003)(41300700001)(40480700001)(6916009)(478600001)(2906002)(8936002)(44832011)(5660300002)(8676002)(966005)(6666004)(82740400003)(7696005)(4326008)(336012)(1076003)(2616005)(83380400001)(426003)(40460700003)(54906003)(70586007)(70206006)(316002)(16526019)(36860700001)(26005)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2023 20:02:47.7825
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ebdb5c18-94d6-4889-2071-08dbc9cbe01d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS2PEPF0000343B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6590
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD Zen3 and newer processors support shadow stack, a feature designed to
protect against ROP (return-oriented programming) attacks in which an attacker
manipulates return addresses on the call stack in order to execute arbitrary
code. To prevent this, shadow stacks can be allocated that are only used by
control transfer and return instructions. When a CALL instruction is issued, it
writes the return address to both the program stack and the shadow stack. When
the subsequent RET instruction is issued, it pops the return address from both
stacks and compares them. If the addresses don't match, a control-protection
exception is raised.

Shadow stack and a related feature, Indirect Branch Tracking (IBT), are
collectively referred to as Control-flow Enforcement Technology (CET). However,
current AMD processors only support shadow stack and not IBT.

This series adds support for shadow stack in SVM guests and builds upon
the support added in the CET guest support patch series [1]. Additional
patches are required to support shadow stack enabled guests in qemu [2].

[1]: CET guest support patches (v6)
https://lore.kernel.org/all/20230914063325.85503-1-weijiang.yang@intel.com/

[2]: CET qemu patches
https://lore.kernel.org/all/20230720111445.99509-1-weijiang.yang@intel.com/

RFC v3 series:
https://lore.kernel.org/all/20230817181820.15315-1-john.allen@amd.com/

---

RFC v2:
  - Rebased on v3 of the Intel CET virtualization series, dropping the
    patch that moved cet_is_msr_accessible to common code as that has
    been pulled into the Intel series.
  - Minor change removing curly brackets around if statement introduced
    in patch 6/6.
RFC v3:
  - Rebased on v5 of the Intel CET virtualization series.
  - Add patch changing the name of vmplX_ssp SEV-ES save area fields to
    plX_ssp.
  - Merge this series intended for KVM with the separate guest kernel
    patch (now patch 7/8).
  - Update MSR passthrough code to conditionally pass through shadow
    stack MSRS based on both host and guest support.
  - Don't save PL0_SSP, PL1_SSP, and PL2_SSP MSRs on SEV-ES VMRUN as
    these are currently unused.
v1:
  - Remove RFC tag from series
  - Rebase on v6 of the Intel CET virtualization series
  - Use KVM-governed feature to track SHSTK for SVM

John Allen (9):
  KVM: x86: SVM: Emulate reads and writes to shadow stack MSRs
  KVM: x86: SVM: Update dump_vmcb with shadow stack save area additions
  KVM: x86: SVM: Pass through shadow stack MSRs
  KVM: SVM: Rename vmplX_ssp -> plX_ssp
  KVM: SVM: Save shadow stack host state on VMRUN
  KVM: SVM: Add MSR_IA32_XSS to the GHCB for hypervisor kernel
  x86/sev-es: Include XSS value in GHCB CPUID request
  KVM: SVM: Use KVM-governed features to track SHSTK
  KVM: SVM: Add CET features to supported_xss

 arch/x86/include/asm/svm.h   |  9 +++---
 arch/x86/kernel/sev-shared.c | 15 ++++++++++
 arch/x86/kvm/svm/sev.c       | 21 ++++++++++++--
 arch/x86/kvm/svm/svm.c       | 54 ++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h       |  3 +-
 5 files changed, 95 insertions(+), 7 deletions(-)

-- 
2.40.1

