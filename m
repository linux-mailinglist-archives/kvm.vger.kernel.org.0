Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35B5B791517
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 11:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233969AbjIDJw5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 05:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352716AbjIDJwy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 05:52:54 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26C3E42;
        Mon,  4 Sep 2023 02:52:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a/yREpdZSe5RywYRw6NBON8FXUSioksWni7Q7DmkrBD5rM8fcXSRPFj6srRgeZ1BJhlkk6gDH5XyxJzOZLdRDAckrI4VTPXdmFrVwciJLaRFdymwbqbw0S4L6guSRG2asgRewIbtMVhRW1nBkQoOfjfJ4lFKDkXttlrQRwGSdwuF8Qh31a77XhR0wa6rkO/Yg2k+0i8dB3b4Lu2pfxwFTybu8j4EVbIDJDkUPJrw9KSpIm9hNlYjwcbp12Cfc04p8NLu6TktGm8aCIHeTVheVuhfKebiba69RSUxXslTo80sPWqSxAWa6rO1u5WvNOoX0LVTtko0SRzU5uZD1+9YoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CDobOBKAeApBb/mD+aZiecWvk+pd3IrSwNvUEiaXEus=;
 b=RAHDvipFnlutEvXRh0Ko9zzde6CfvlE1m7XSePAjpc+eTm6k2wbl2E5AzcqZqVcOH9mGdAEo5P3jKz724Ttb3qsI9JpG0tkMQrA+71Mea1b+0RDthDdTDP8LnBLx5ppsOu7eoWfQv4q3XraOgQ5000QmwEon/fN8jqTXlmtedUfPcMZuGdAjGhxQz3PK2FrG7cznNIoT2aa5GdPjf7AUJER+aiS4mfGdG0VTylZtuAWR28ShPkurps/nbhJcGqYpKqm26hkIvPBNBGtiMcAPLKLN4QubE6vc+C3UlSpYH0vVD5ol3Y2/hEUVSh6LVUEKwmendCizDDqSwmoiFsKyPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CDobOBKAeApBb/mD+aZiecWvk+pd3IrSwNvUEiaXEus=;
 b=GPBlj2tEwuJ7az3dvAEUE3e4FwpA3T7kBkOVzkupbsljgYaPu+up5miGUyAvhvmsg7X+sZ4qa+s8qlY3nA0Yt/PnPs/FkSaguiEkL2+kBmcoAQ8cf9gO5CpPjAFw/nCWt6dd8s3tsvtsXabp3xynFLZ8/a7RkC22LT+5tyVkimo=
Received: from MW4PR04CA0319.namprd04.prod.outlook.com (2603:10b6:303:82::24)
 by CH2PR12MB5017.namprd12.prod.outlook.com (2603:10b6:610:36::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.32; Mon, 4 Sep
 2023 09:52:39 +0000
Received: from CO1PEPF000042A7.namprd03.prod.outlook.com
 (2603:10b6:303:82:cafe::d4) by MW4PR04CA0319.outlook.office365.com
 (2603:10b6:303:82::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33 via Frontend
 Transport; Mon, 4 Sep 2023 09:52:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000042A7.mail.protection.outlook.com (10.167.243.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6768.25 via Frontend Transport; Mon, 4 Sep 2023 09:52:38 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 4 Sep
 2023 04:52:33 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>
CC:     <linux-doc@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
        <x86@kernel.org>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <bp@alien8.de>, <santosh.shukla@amd.com>, <ravi.bangoria@amd.com>,
        <thomas.lendacky@amd.com>, <nikunj@amd.com>,
        <manali.shukla@amd.com>
Subject: [PATCH 00/13] Implement support for IBS virtualization
Date:   Mon, 4 Sep 2023 09:53:34 +0000
Message-ID: <20230904095347.14994-1-manali.shukla@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042A7:EE_|CH2PR12MB5017:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c1ab650-319e-41e5-514b-08dbad2cac93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MdaDIqKjot8iPe+x3r3i6xcv70l+x8Bh7cvO5Iq2/2vHBCwi7TF9Cc2kBXKtpODE4t/u0Kp2C56u39/cUF/Qj5PWxWaFrKfQAvvi+UEySjXhdMv3baxMgsIp5bZREpr4EG5ZxhM0D0m0wsofJmyz294fJIWLWXZjs0HB5gXHDdFuEc7uKWHM5dh/DsFgip2/wA7tbB8AtZLii3F3QAvdPnjOJ5u5dKdxNbb4KXUAMjd517JU4HZFf21gRz6zQx1OyacXXwhPOBsXbGiyeDJJf24NqbfnFRt2Gdu6G5+LE7oYPyoB7ugRQEFPjPZnYeSHDTLfyBmE53f2z3YTcZ44RMQhomLxWYc3sGev84LiabZDKCaDToxFMp7AYBhOJmkV7PkEYzyWRX0gc/2Xe9IErKGer8F9jdWsMizj7lSwAlQBl4Lhb0NPY6sZfy6CDkNRFK0fUYNyW54ItZhvu/S8VsUMopWGPREGkg7eTICAFO8XkEQgCIJkTo7hHRwlaHAsHShYXzXLarwf2SCtZBiW54E4tKIkAKtiYJ0YfG8XyGZR1Sa1b/zvgwR1pQhwpGUaoshGfhj8q3sp3jOQTmoS1nWB/IA0KCqTcz1icR2WaimLoxHx3p6DwRtl0cCuXGp2B00rEpr6k56kqYdfEuSU3dYJ+/8hMltzkKg+pTY+38Y0vbLBKaBNSAbMgbXycw8VNikpvcAat+63MUrgdt1j/w2o0z8NDEcjmEUYNX8cOfykinTJnZK0rPLCQY/vZaOmGE13LEEs0CtUnQK8nKwU8GXpkTlQy8z3Ev1lsXip4pg=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(136003)(346002)(39860400002)(186009)(82310400011)(1800799009)(451199024)(40470700004)(36840700001)(46966006)(40460700003)(16526019)(26005)(2616005)(7696005)(1076003)(47076005)(82740400003)(81166007)(356005)(36756003)(86362001)(36860700001)(426003)(336012)(83380400001)(40480700001)(44832011)(966005)(41300700001)(8936002)(316002)(54906003)(5660300002)(70206006)(70586007)(8676002)(110136005)(4326008)(2906002)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2023 09:52:38.7152
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c1ab650-319e-41e5-514b-08dbad2cac93
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF000042A7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5017
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support for IBS virtualization (VIBS). VIBS feature allows the
guest to collect IBS samples without exiting the guest.  There are
2 parts to it [1].
- Virtualizing the IBS register state.
- Ensuring the IBS interrupt is handled in the guest without exiting
  the hypervisor.

VIBS requires the use of AVIC or NMI virtualization for delivery of
a virtualized interrupt from IBS hardware in the guest [1].

While IBS collects data for IBS fetch/op block for the sampled
interval, VIBS hardware signals a VNMI, but the source of VNMI is
different in both AVIC enabled/disabled case.
- When AVIC is disabled, virtual NMI is HW accelerated.
- When AVIC is enabled, virtual NMI is accelerated via AVIC using
  Extended LVT.

The local interrupts are extended to include more LVT registers, to
allow additional interrupt sources, like instruction based sampling
etc. [3].

Note that, since IBS registers are swap type C [2], the hypervisor is
responsible for saving and restoring of IBS host state. Hypervisor
does so only when IBS is active on the host to avoid unnecessary
rdmsrs/wrmsrs. Hypervisor needs to disable host IBS before saving the
state and enter the guest. After a guest exit, the hypervisor needs to
restore host IBS state and re-enable IBS.

[1]: https://bugzilla.kernel.org/attachment.cgi?id=304653
     AMD64 Architecture Programmer’s Manual, Vol 2, Section 15.38
     Instruction-Based Sampling Virtualization.

[2]: https://bugzilla.kernel.org/attachment.cgi?id=304653
     AMD64 Architecture Programmer’s Manual, Vol 2, Appendix B Layout
     of VMCB, Table B-3 Swap Types.

[3]: https://bugzilla.kernel.org/attachment.cgi?id=304653
     AMD64 Architecture Programmer’s Manual, Vol 2, Section 16.4.5
     Extended Interrupts.

Testing done:
- Following tests were executed on guest
  sudo perf record -e ibs_op// -c 100000 -a
  sudo perf record -e ibs_op// -c 100000 -C 10
  sudo perf record -e ibs_op/cnt_ctl=1/ -c 100000 -a
  sudo perf record -e ibs_op/cnt_ctl=1/ -c 100000 -a --raw-samples
  sudo perf record -e ibs_op/cnt_ctl=1,l3missonly=1/ -c 100000 -a
  sudo perf record -e ibs_op/cnt_ctl=1/ -c 100000 -p 1234
  sudo perf record -e ibs_op/cnt_ctl=1/ -c 100000 -- ls
  sudo ./tools/perf/perf record -e ibs_op// -e ibs_fetch// -a --raw-samples -c 100000
  sudo perf report
  sudo perf script
  sudo perf report -D | grep -P "LdOp 1.*StOp 0" | wc -l
  sudo perf report -D | grep -P "LdOp 1.*StOp 0.*DcMiss 1" | wc -l
  sudo perf report -D | grep -P "LdOp 1.*StOp 0.*DcMiss 1.*L2Miss 1" | wc -l
  sudo perf report -D | grep -B1 -P "LdOp 1.*StOp 0.*DcMiss 1.*L2Miss 1" | grep -P "DataSrc ([02-9]|1[0-2])=" | wc -l

- Following Nested guests combinations were tested manually
  ----------------------------
  | Collected IBS Samples in |
  ----------------------------
  |   L0   |   L1   |   L2   |
  ----------------------------
  |   Y    |   Y    |   Y    |
  |   Y    |   Y    |   N    |
  |   Y    |   N    |   Y    |
  |   Y    |   N    |   N    |
  |   N    |   Y    |   Y    |
  |   N    |   Y    |   N    |
  |   N    |   N    |   Y    |
  ----------------------------

Qemu changes can be found at below location:
https://github.com/Kullu14/qemu/tree/qemu_vibs_branch

Qemu commandline to enable IBS virtualization: qemu-system-x86_64
-enable-kvm -cpu EPYC-Genoa,+svm,+ibs,+extapic,+extlvt,+vibs \ ..

base-commit: 3b2ac85b3d2954b583dc2039825ad76eda8516a9 (kvm_x86 misc)

On top of base commit,
https://lore.kernel.org/all/20230717041903.85480-1-manali.shukla@amd.com
patch is applied, then VIBS patch series is applied 

Manali Shukla (8):
  KVM: Add KVM_GET_LAPIC_W_EXTAPIC and KVM_SET_LAPIC_W_EXTAPIC for
    extapic
  KVM: x86/cpuid: Add a KVM-only leaf for IBS capabilities
  KVM: x86: Extend CPUID range to include new leaf
  perf/x86/amd: Add framework to save/restore host IBS state
  x86/cpufeatures: Add CPUID feature bit for VIBS in SEV-ES guest
  KVM: SVM: Add support for IBS virtualization for SEV-ES guests
  KVM: SVM: Enable IBS virtualization on non SEV-ES and SEV-ES guests
  KVM: x86: nSVM: Implement support for nested IBS virtualization

Santosh Shukla (5):
  x86/cpufeatures: Add CPUID feature bit for Extended LVT
  KVM: x86: Add emulation support for Extented LVT registers
  x86/cpufeatures: Add CPUID feature bit for virtualized IBS
  KVM: SVM: Extend VMCB area for virtualized IBS registers
  KVM: SVM: add support for IBS virtualization for non SEV-ES guests

 Documentation/virt/kvm/api.rst     |  23 ++++
 arch/x86/events/amd/Makefile       |   2 +-
 arch/x86/events/amd/ibs.c          |  23 ++++
 arch/x86/events/amd/vibs.c         | 101 ++++++++++++++
 arch/x86/include/asm/apicdef.h     |  14 ++
 arch/x86/include/asm/cpufeatures.h |   3 +
 arch/x86/include/asm/perf_event.h  |  27 ++++
 arch/x86/include/asm/svm.h         |  34 ++++-
 arch/x86/include/uapi/asm/kvm.h    |   5 +
 arch/x86/kvm/cpuid.c               |  11 ++
 arch/x86/kvm/governed_features.h   |   1 +
 arch/x86/kvm/lapic.c               |  78 ++++++++++-
 arch/x86/kvm/lapic.h               |   7 +-
 arch/x86/kvm/reverse_cpuid.h       |  15 +++
 arch/x86/kvm/svm/avic.c            |   4 +
 arch/x86/kvm/svm/nested.c          |  23 ++++
 arch/x86/kvm/svm/sev.c             |  10 ++
 arch/x86/kvm/svm/svm.c             | 207 +++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h             |   5 +-
 arch/x86/kvm/x86.c                 |  24 ++--
 include/uapi/linux/kvm.h           |  10 ++
 21 files changed, 603 insertions(+), 24 deletions(-)
 create mode 100644 arch/x86/events/amd/vibs.c

-- 
2.34.1

