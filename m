Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB6BD68B56D
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 07:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjBFGGC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 01:06:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjBFGGA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 01:06:00 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2075.outbound.protection.outlook.com [40.107.220.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA08115CB7;
        Sun,  5 Feb 2023 22:05:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P7C2PWo2wPRTx4EzX5+BK8XHsy+oEAnuBhJY0hWtF0+abYj6+Toaatiie0ZV2fH8h/FQq6anmbHxI87t7/FxU/ZPWS3heDj3fGtrEwWqA/h6O9dEcF/5PvB9l6GJxYK2mAwbGRKYNbd0X1ObuaEsQF+8WffXb7YvpXjYbQTHWnZHfGRm1MO3eqPPWaMR6STnnJJGQI/OWD6OeoCi+/+ditknOwq9vm75o1hSmjkeuA1+qJH64lb0VAjAkn+vfJz19sVdy/cCrzeJwa1c8/Q+gOd6F8hlUjr2tL8+paWH+MC5M3ktmntXjf5ScQhYUdXo/DSW4b7gGiMudN1ZFBKdhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O68SHyCE2lCLQjd3HOqsi5ztI1D0/EwYpE5COY+eFWo=;
 b=cEeY+7IgDC2x3PQqZgRD0YJi/TXe3sikfXuVCtQ6z378KlAd2pc/AnERw/kEmxuRSfSikmu+rD3WnJV8TB8SzGg319w2dP1bb0d/sGKFS5LU+0zZ09Szayog1bpSPWvIZgWnn3RyOmm/v3BfVI7GJ73dcVN9cLLrlZiL47ktxDRn5TQjM4b0Mc9Z0j1fduotGusM7w3JQr5mCdV1pYB9guYWsbVIfYA6CCvFOVOaUFTJYZHvs0rVDqmPwRtrbkymYT20Oqi2PAViJYPdD1vkcclfYoymEJ+fG19i/Tjh6x8adUi9bvjFiH7h/o08D9I60s3DXDLjfRmc4DORzQAvtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O68SHyCE2lCLQjd3HOqsi5ztI1D0/EwYpE5COY+eFWo=;
 b=qvX46DhaDUpHCIThEpjU2zVWHazTkRVOYvIIV1FUBeoKiS2HcBbmNSqCwlqZvfIFs58z48ZQfGWcNwYUjbKgc+R9Fb1go9s0zaEbsTE/RwZ5YCPxTAe6IoCm70J0mp0fHnkKDxG3FjBmjT1+hcrbjc+K4bN8mDlrMDt0D2XsE28=
Received: from DM6PR03CA0089.namprd03.prod.outlook.com (2603:10b6:5:333::22)
 by LV2PR12MB5992.namprd12.prod.outlook.com (2603:10b6:408:14e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.29; Mon, 6 Feb
 2023 06:05:56 +0000
Received: from DM6NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:333:cafe::64) by DM6PR03CA0089.outlook.office365.com
 (2603:10b6:5:333::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34 via Frontend
 Transport; Mon, 6 Feb 2023 06:05:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT044.mail.protection.outlook.com (10.13.173.185) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.25 via Frontend Transport; Mon, 6 Feb 2023 06:05:56 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 6 Feb
 2023 00:05:49 -0600
From:   Manali Shukla <manali.shukla@amd.com>
To:     <linux-kernel@vger.kernel.org>
CC:     <peterz@infradead.org>, <mingo@redhat.com>, <acme@kernel.org>,
        <jolsa@kernel.org>, <namhyung@kernel.org>, <tglx@linutronix.de>,
        <bp@alien8.de>, <dave.hansen@linux.intel.com>, <seanjc@google.com>,
        <pbonzini@redhat.com>, <jpoimboe@kernel.org>,
        <pawan.kumar.gupta@linux.intel.com>, <babu.moger@amd.com>,
        <sandipan.das@amd.com>, <jmattson@google.com>,
        <thomas.lendacky@amd.com>, <nikunj@amd.com>,
        <ravi.bangoria@amd.com>, <eranian@google.com>,
        <irogers@google.com>, <kvm@vger.kernel.org>, <x86@kernel.org>,
        <linux-perf-users@vger.kernel.org>, <manali.shukla@amd.com>
Subject: [RFC PATCH kernel 0/2] PreventHostIBS feature for SEV-ES and SNP guests
Date:   Mon, 6 Feb 2023 06:05:43 +0000
Message-ID: <20230206060545.628502-1-manali.shukla@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT044:EE_|LV2PR12MB5992:EE_
X-MS-Office365-Filtering-Correlation-Id: 60104523-b530-424d-7135-08db08083601
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rwx950G/xX/c6oE8Nfe7LtcewYb+scongiVqtal+8RQdyJd94IiEIGKYBlx4mYKPF4z3OaZIIihIV+QWwI1dc4RfjUCHgixhCF7AFlvbvkfUYLRSY0LitnsAVmXbAeI6Gsu1PI5jtP1m45QtX72o+mCs71Mz5LVmvkTbvAeIWwODl2JG2vYN5VS7GSektOBx4Al5ZqD2WasWQz+Hv6ZSmF/pQ4Flc/wDaNz8CnuL24u47CTKtNpHg9eTXx1FqvBW9aviA6jDP4QBP03iZCvndW7AQVWmKWQvuFuLaMLqONNYkHOonQWqaua8gA+ffaRWl89KXk3xVQGMJleQvV2Vt3xzhvo8BpZOpFR0YumLB1XR8ywepvI4NsX7nsiUk/nwhNC5X52+yY1s3mTd+6ca9uGRk/IKphybiZz6tl3XDFg20WDQqXT/H4Ue+cKTJs/MMUqXY4OS0ljlqasu2WcAnS+aKvHsmoWiXl283Y31etnV9aMCpYx/Vy6IEF1TbqKPjp7Dp4RN01Fjur0aq0RrkgrkaPEj5pjUM2P3PtObaEu01aVoNrFhFfEjeoIkkUiFssAITTeH/Z9i/fBXPqF4LLXUaXmv+Wj4WyNHbxgANHQIIuxPuy6tDX3k6YkveXih+EHG8hoM3bE927zsObF7596KB0sTVijJCd5IPzfoAe1W4IsWfDq8L2mQoemHK3q2VOR1Av57DYarhC21PAqwEBCDDk+rKuPguldfU52achE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(136003)(376002)(346002)(451199018)(46966006)(40470700004)(36840700001)(36756003)(478600001)(26005)(2906002)(186003)(1076003)(16526019)(6916009)(41300700001)(44832011)(8676002)(8936002)(6666004)(70206006)(4326008)(70586007)(7696005)(54906003)(7416002)(82740400003)(316002)(5660300002)(2616005)(82310400005)(40460700003)(40480700001)(83380400001)(356005)(86362001)(81166007)(47076005)(426003)(336012)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 06:05:56.1100
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60104523-b530-424d-7135-08db08083601
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5992
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adds support for PreventHostIBS feature for SEV-ES and SNP guests.
Currently, the hypervisor is able to inspect instruction based samples
from the guest and gather execution information.  With enablement of
PreventHostIBS feature, SEV-ES and SNP guests may choose to disallow
use of instruction based sampling by the hypervisor in order to limit
the information gathered about their execution.  (More information in
Section 15.36.17 APM Volume 2)

While implementing this feature, unknown NMIs were being seen. On
further investigation, a race was found effecting the IBS FETCH/OP
MSR.

ENABLE bit and VALID bit for IBS_FETCH_CTL are contained in the same
MSR and same is the case with IBS_OP_CTL.

Consider the following scenario:
- The IBS MSR which has ENABLE bit set and VALID bit clear is read.
- During the process of clearing the ENABLE bit and writing the IBS
  MSR to disable IBS, an IBS event can occur that sets the VALID bit.
- The write operation on IBS MSR can clear the newly set VALID bit.
- Since this situation is occurring in the CLGI/STGI window
  (PreventHostIBS window), the actual NMI is not taken.
- Once VMRUN is issued, it will exit with VMEXIT_NMI and as soon as
  STGI is executed, the pending NMI will trigger.
- The IBS NMI handler checks for the VALID bit to determine if the NMI
  is generated because of IBS.
- Since VALID bit is now clear, it doesn't recognize that an IBS event
  is occurred which in turn generates the dazed and confused unknown
  NMI messages.

Per-cpu ibs_flags which indicates whether PreventHostIBS window is
active/inactive are added to avoid the above mentioned race.

An active PreventHostIBS window is set before calling VMRUN and
cleared after STGI. PreventHostIBS window check is added to
perf_ibs_handle_irq(), to avoid unknown NMIs and treat them as handled
when window is active.

There are 2 patches in this series.
1) Add amd_prevent_hostibs_window() function to set per-cpu ibs_flags
based on an active/inactive PreventHostIBS window.
2) Enable PreventHostIBS for SEV-ES and SNP guests.

Testing done:
- Executed program symbols in guest are not captured in host when
  PreventHostIBS feature is enabled.
- Generated 1000+ NMIs using cpuid command, no unknown NMIs are seen
  after enablement of PreventHostIBS feature.

Qemu commandline to enable PreventHostIBS on guest.

qemu-system-x86_64 -enable-kvm -cpu EPYC-v4,+nohostibs \ ..

Manali Shukla (2):
  perf/x86/amd: Add amd_prevent_hostibs_window() to set per-cpu
    ibs_flags
  KVM: SEV: PreventHostIBS enablement for SEV-ES and SNP guest

 arch/x86/events/amd/ibs.c          | 64 ++++++++++++++++++++++++++++++
 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/perf_event.h  | 20 ++++++++++
 arch/x86/kvm/svm/sev.c             | 10 +++++
 arch/x86/kvm/svm/svm.c             | 39 +++++++++++++++++-
 arch/x86/kvm/svm/svm.h             |  1 +
 6 files changed, 133 insertions(+), 2 deletions(-)

-- 
2.34.1

