Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E804B4BD70B
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 08:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346303AbiBUHdK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 02:33:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiBUHcy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 02:32:54 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2064.outbound.protection.outlook.com [40.107.237.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A256355;
        Sun, 20 Feb 2022 23:32:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N8TbJqweJVJ0ucyHplQSY3BNsj5puk4UEsVbgWAHoHPSYF0dzOZBOOwJDvkcNrbM6TIyqL8Gdbb4oZSE1OMyRbfkuZuRU6Oo1IFs3buEXreTkXuJv5kOHwqHaGiaLaKWThWro/Casd6eiGcOZFmz36JfSBhAZO5y4nD/dsnccrBeqKRhfKDcViSygH+9+ukkCcx+0YzCwx7kgPMuqOJ0q5SYeaNvzA1wwpsLK20pyOHgZw05Vv/WLLoClCOl0JwipAXIxSTpkkED1M0b/XGHhPJJ/zaA3Z/I5C/45MU62vKxobSjcL/sEJleUD4HfsWDhCkBzSiF80SjVU0PrA3hKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dDWkpUfOgcVfm+d1/wNA4li7MRwaQAYXle7vejBKoIU=;
 b=NTlBoVOqXHZVBelfGJicnLxir1/UW8ugrVeQWBvvRsiNLy8Fp6/3nfSO5EDL401L9HUyVnyOYofaTg8sB9w1qx+/6cOsks0lgO2zcB92mrpi/MZlfUHttN0EWLZ/PgQEnszy5+GqCBt/peVZbFr+EnLGBhEh3LmHWMnSItJqHH6talVcihEpoumYQXkES+E0P0J5OGdiqxtLBprlyI318860QvwtrvZgfN3cvzqwPouSvQRePw4/pogT0whPeL3zlqKY1y/X4OYXXL5LUw4GpQ7qIbU7W8vAOifNC86px0dC6tSVofLhKK2kKcghJ1ZxTyuAD0nEJSHDh1B7tNa/Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dDWkpUfOgcVfm+d1/wNA4li7MRwaQAYXle7vejBKoIU=;
 b=CmBcRL5eVJ9vV9BlGX31ianoREOpocKV8Kcv6pToHxtwPtSyLs50k9YJxovo5+j7HWcXvR5JRpdcmDU0X3XA+KnpXbn6JkOQIrq6hWkycyvnMF/+qV2uxFZiuKABGOjHfSaIDBqbrzBqsp33hqXyh1M4zKKxx8aW+4kW819QPI4=
Received: from DM5PR2201CA0010.namprd22.prod.outlook.com (2603:10b6:4:14::20)
 by BYAPR12MB2933.namprd12.prod.outlook.com (2603:10b6:a03:138::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Mon, 21 Feb
 2022 07:32:28 +0000
Received: from DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:14:cafe::d1) by DM5PR2201CA0010.outlook.office365.com
 (2603:10b6:4:14::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18 via Frontend
 Transport; Mon, 21 Feb 2022 07:32:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT023.mail.protection.outlook.com (10.13.173.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4995.15 via Frontend Transport; Mon, 21 Feb 2022 07:32:28 +0000
Received: from BLR-5CG113396H.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Mon, 21 Feb
 2022 01:32:11 -0600
From:   Ravi Bangoria <ravi.bangoria@amd.com>
To:     <pbonzini@redhat.com>
CC:     <ravi.bangoria@amd.com>, <seanjc@google.com>,
        <jmattson@google.com>, <dave.hansen@linux.intel.com>,
        <peterz@infradead.org>, <alexander.shishkin@linux.intel.com>,
        <eranian@google.com>, <daviddunn@google.com>, <ak@linux.intel.com>,
        <kan.liang@linux.intel.com>, <like.xu.linux@gmail.com>,
        <x86@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kim.phillips@amd.com>,
        <santosh.shukla@amd.com>
Subject: [PATCH 0/3] KVM: x86/pmu: Segregate Intel and AMD specific logic
Date:   Mon, 21 Feb 2022 13:01:37 +0530
Message-ID: <20220221073140.10618-1-ravi.bangoria@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f487d10-c364-452b-7e4a-08d9f50c503e
X-MS-TrafficTypeDiagnostic: BYAPR12MB2933:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB2933DE0D57C55E1DA0B33D94E03A9@BYAPR12MB2933.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VKt+/IyFdHqUMP3FKD1dXOM/xGwDPiOCRnnNgAFE6uMiaDanNHF+AAvOc4ZrjF8wBSPHF7GF7EJvfsWStqWLFrLOR+4TYak0EcZXJQSH2ml7HEVsMlCEkQp4WrT9dXA3eg4vkY3YTfFgswmcWP4C4iIvixFMaIY7OnMkOPqOe5c9IEHirR8PFrgUTOnjdc03fcQTpq7MW2b78w08boWwTjd3SpZsubo5ZSARz60jLJ8Vf82ZQn6FpHnIpe2nPzL7AFBIzeghPMVFmcgUh0GW0h5jVqp68mIOWr5D6N4TCQxAYOHqE/rNHHcHbAWGd4TCYcJ3IjhqlyA6WbUdTi0NghIlAV+uy0KzfDatnFwycGqj4i3sHXp4jBKbqnLMTsxP0UIYiqRONxMTQ/4lcSVeyrdYnDCmzHYvjKarcwKj0QZtn6oet3TZnMpfZLcmDkhVqZ3zVLla+makq7JEjyT9qMCpvLTkDXIjfvn4sAMx4VzDSv/DKOkv5SoAj93ZZG6Tplclp75H+yfgQOv7GpFyXYHiIqcv6J5IAvOYH3hZB7SyqEU9B2WHlcT1qFRzFUcNn73HYBvB8f31urvQTJ+CStLO5ybsy0X4lwqiM8j/JrwHQqDM/T86uBtSnXZG3PfPYdBDt6wYd4FilwfBsn9e5nUh9a8N8tcZwLEVIMYN20ilK87ZZXsinBYRvhS1StbrpFlm7Vn5LFkUIefE4JSL2A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(7416002)(83380400001)(36860700001)(54906003)(47076005)(40460700003)(6916009)(316002)(336012)(81166007)(44832011)(426003)(2616005)(1076003)(2906002)(4326008)(36756003)(7696005)(508600001)(70206006)(356005)(5660300002)(8936002)(4744005)(186003)(82310400004)(86362001)(26005)(16526019)(70586007)(8676002)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 07:32:28.3383
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f487d10-c364-452b-7e4a-08d9f50c503e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2933
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use INTEL_ prefix for some Intel specific macros. Plus segregate
Intel and AMD specific logic in kvm code.

Patches prepared on top of kvm/master (710c476514313)

Ravi Bangoria (3):
  x86/pmu: Add INTEL_ prefix in some Intel specific macros
  x86/pmu: Replace X86_ALL_EVENT_FLAGS with INTEL_ALL_EVENT_FLAGS
  KVM: x86/pmu: Segregate Intel and AMD specific logic

 arch/x86/events/intel/core.c      | 14 +++----
 arch/x86/events/intel/ds.c        |  2 +-
 arch/x86/events/perf_event.h      | 34 ++++++++--------
 arch/x86/include/asm/perf_event.h | 14 +++----
 arch/x86/kvm/pmu.c                | 68 +++++++++++++++++++------------
 arch/x86/kvm/pmu.h                |  4 +-
 arch/x86/kvm/svm/pmu.c            |  6 ++-
 arch/x86/kvm/vmx/pmu_intel.c      |  6 +--
 8 files changed, 85 insertions(+), 63 deletions(-)

-- 
2.27.0

