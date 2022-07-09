Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92A0656C995
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 15:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiGINm5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Jul 2022 09:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiGINm4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Jul 2022 09:42:56 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2072.outbound.protection.outlook.com [40.107.223.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706C7193C7;
        Sat,  9 Jul 2022 06:42:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j4O/tSQcrkAbLGPQ0E8vZen9XD9zqPppGg2tdTmM6I1MLM2YYBxqZechH8UCEjkwtpJVEWKj+ZaBltia3Ri/P4sL/10EJOe/7ZoT+LwMMPLIXXwmO1ytYKHqrqH+03pPDMuMqy384kzMJIrn9v95XM49i/oRGp1hkPZ6ae1/7DDtzRFaJ+/583Ns/7VtVZ1MuOo+fAqsdRkI2XU4MgOLvGyodKSRH/e3w/T1SqPqLz2V8BLNoWwPMxgNpEaD4apolF5rAZONw233/sBYNtZRAdkw2Xl8nG/DvQ70JnByUg+nLJohrn1F38SQNDN/RsvjpjOcxVnmgXs50fYXgArNdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qVnKZG8xQ34PdyQXkY2+hg6GVGYHlDHq+YID0I1e0Go=;
 b=FHhPuFx08HCmGQtdKCHS+eTs+FiLw2J4y83jpStseJ6y09ptpSYJIBDyv/JpCtVnvWNVEj5wCx3IIxre6CqmUCBJnKlrQaDN6oYXeLXSQ/N7YQigKD/OL5iffrAcdLJPjwdVl5z3taUo9a+rs0x/v843mPVJO7cBysOQ007GiJnHCYDGqD2mTj/RZrJ4IpnIEZjKFa2pBOxSTWIae3Wjydc1b1fvX79qtZ903+OGujdReda0N6b4/uqymn9z2+teNE+pvc49xbRea7fNE0X/Ky+AxZAGHgRPQYG5e0R852QMhqLJwrjEH0FR3/SbL9KA25vy0boUcIQQNEW9oX08Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qVnKZG8xQ34PdyQXkY2+hg6GVGYHlDHq+YID0I1e0Go=;
 b=ThPXDQK9uecRgw7RPI/qJH5p9RRBMh04tGi7rtNfhXg3sb2MNoVsRKiD5dJwC+sktll6cbaZyXk3oHWzdxa/5pXlGkijfzodraRPlzjd7TIxv9aZllzlp6QtSAi5otqPnw0v7uGyJzmKP8m+WdJb2ypfPtR44UmIdNh/nQ1E6CU=
Received: from DM6PR05CA0039.namprd05.prod.outlook.com (2603:10b6:5:335::8) by
 MWHPR1201MB0240.namprd12.prod.outlook.com (2603:10b6:301:58::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Sat, 9 Jul
 2022 13:42:49 +0000
Received: from DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:335:cafe::21) by DM6PR05CA0039.outlook.office365.com
 (2603:10b6:5:335::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14 via Frontend
 Transport; Sat, 9 Jul 2022 13:42:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT024.mail.protection.outlook.com (10.13.172.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5417.15 via Frontend Transport; Sat, 9 Jul 2022 13:42:49 +0000
Received: from BLR-5CG113396M.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Sat, 9 Jul
 2022 08:42:45 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Santosh.Shukla@amd.com>
Subject: [PATCHv2 0/7] Virtual NMI feature 
Date:   Sat, 9 Jul 2022 19:12:23 +0530
Message-ID: <20220709134230.2397-1-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 41be3a3e-8322-4009-1d1f-08da61b0ea04
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0240:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uBVHJ5ZVd4YusrFSxXX6ksUgiLPasgpEp+VgobgxMfy8bVNHhKFIt1fGVKFXJ9ucipqmFnN/lODp/dfVOF9KxddwhqeCOrZn0NSUD1cY1vUviO3ET+9OY8OnSBpLuaCpJ7ZpBX16RfdanpGv3Byq11PCN8MVYZZgJJNn6iDt6mwLlK3hZ0y6ieh/GAVCs6MMV9DQLzW1vHKvgpuibeRFFy5JgMkdDjQLvWBR86BN78bNl+vvnvGPNCOGXrfq3i5hCe+Cb0GOJSE13RSzUzukbWBrgTg321frNNacaxWpJwoqHw1lq8i2gr4sD1fT/TdWfJ5uoa0BTmr2+Lrud3Wkwx/YrFtDPnOGCHUXCo8jGgJJidJVcpabxb9wPrQt9S2puzYQbAESKRDoE6ajtu0x+8FpnByn4B8AhNzXe8DKy4shXlN+ZT8MywGYicAKMhuy9nW+h+l/Qr4W6tDPpqfpujfxrCH/uSVQ9EE5j4Pprm7YM/U4boqwkCAS41A7TbFCtcm97luysEDMvTm3SM8sa+UkQeiBxAVI9K9eGgbb/CQmbZyEVjF8UFbz4LcX5KhTlhIQRM4ONmOoLu1kzMwTGalKWyKKLgSQKcH40NBfLIndkfZOzE3oyXUTN6rnDu+Syd1sTXO034w7Liwd9xXd25EWDFz61GVuwzsDDShhg23+ItvwEwhomzjKwCbnzB28WUmrNbLUNSjPUm3KqyWIHEhMjzBVwBVKcWP65/QMihJZpoJzdkprlkY8e5aeQEf5W6StyyRs2Op2TNotMsfo6M+IbnVIqkHkzvp7YItwtEyl880Z5paDw9s6/wETVdU+VG4RADrrAV5KobhQcD+7aSgw+WN9ZUE8eZc3Y24rQaMpdCdcs3/q502pVeZp6WC6izwULuWxU7Imh0o4yDrNG/9TNy14iPFsbY+AM9m6CQ4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(396003)(376002)(39860400002)(46966006)(36840700001)(40470700004)(426003)(40480700001)(16526019)(8676002)(336012)(186003)(81166007)(6916009)(54906003)(83380400001)(70586007)(36756003)(47076005)(4326008)(36860700001)(70206006)(356005)(34020700004)(316002)(2616005)(40460700003)(44832011)(82740400003)(478600001)(6666004)(8936002)(7696005)(4743002)(41300700001)(2906002)(86362001)(1076003)(966005)(26005)(5660300002)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2022 13:42:49.3685
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 41be3a3e-8322-4009-1d1f-08da61b0ea04
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0240
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, NMI is delivered to the guest using the Event Injection
mechanism [1]. The Event Injection mechanism does not block the delivery
of subsequent NMIs. So the Hypervisor needs to track the NMI delivery
and its completion(by intercepting IRET) before sending a new NMI.

Virtual NMI (VNMI) allows the hypervisor to inject the NMI into the guest
w/o using Event Injection mechanism meaning not required to track the
guest NMI and intercepting the IRET. To achieve that,
VNMI feature provides virtualized NMI and NMI_MASK capability bits in
VMCB intr_control -
V_NMI(11) - Indicates whether a virtual NMI is pending in the guest.
V_NMI_MASK(12) - Indicates whether virtual NMI is masked in the guest.
V_NMI_ENABLE(26) - Enables the NMI virtualization feature for the guest.

When Hypervisor wants to inject NMI, it will set V_NMI bit, Processor will
clear the V_NMI bit and Set the V_NMI_MASK which means the Guest is
handling NMI, After the guest handled the NMI, The processor will clear
the V_NMI_MASK on the successful completion of IRET instruction
Or if VMEXIT occurs while delivering the virtual NMI.

To enable the VNMI capability, Hypervisor need to program
V_NMI_ENABLE bit 1.

The presence of this feature is indicated via the CPUID function
0x8000000A_EDX[25].

Testing -
* Used qemu's `inject_nmi` for testing.
* tested with and w/o AVIC case.
* tested with kvm-unit-test
* tested injecting NMI event from L1 to L2 guest (nested env).

v2:
01, 02 - added maxim reviwed-by.
03 - Added get_vnmi_vmcb API to return vmcb for l1 and l2.
04 - Moved vnmi check after is_guest_mode() in func svm_nmi_blocked().
05 - Added WARN_ON check for vnmi pending.
06 - Save the V_NMI_PENDING/MASK state in vmcb12 on vmexit.
07 - No change.


Thanks,
Santosh
[1] https://www.amd.com/system/files/TechDocs/40332.pdf - APM Vol2,
ch-15.20 - "Event Injection".

Santosh Shukla (7):
  x86/cpu: Add CPUID feature bit for VNMI
  KVM: SVM: Add VNMI bit definition
  KVM: SVM: Add VNMI support in get/set_nmi_mask
  KVM: SVM: Report NMI not allowed when Guest busy handling VNMI
  KVM: SVM: Add VNMI support in inject_nmi
  KVM: nSVM: implement nested VNMI
  KVM: SVM: Enable VNMI feature

 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/svm.h         |  7 ++++++
 arch/x86/kvm/svm/nested.c          | 16 +++++++++++-
 arch/x86/kvm/svm/svm.c             | 40 ++++++++++++++++++++++++++++--
 arch/x86/kvm/svm/svm.h             | 38 ++++++++++++++++++++++++++++
 5 files changed, 99 insertions(+), 3 deletions(-)

-- 
2.25.1

