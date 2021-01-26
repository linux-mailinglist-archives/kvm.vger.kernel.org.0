Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4D93044A3
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 18:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389353AbhAZRHP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 12:07:15 -0500
Received: from mail-bn8nam11on2050.outbound.protection.outlook.com ([40.107.236.50]:25316
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729376AbhAZITm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 03:19:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZHGRr9a449dUDhA85ISROZxHRmzBabyyoQStxQ1LSkeVfGUaMwEmnUQwCU5tA/6QFMIOp+YG55i45ZhF3vaujTuk6bIPErwdP1djMekBKWqJoYG7t8sNhk1ku5rfN0cOAIpPlkFYe2WYeafn7VxZQcCfldrX5OMkdfsQn/Jn11DKFs1CInAtgqEdu7ldR/HWaGuX++wyl69375JyBN1rsJQvfrhnd4AjJqJZ7p6z7cmUEhKlqDj6OIDoyYgqDt7wFCrK4KQcSPayH9u5vZPRrhNBMMZWhPPg9yQQcJiBvUcDH3k24Mh8iaRjtumIUqFjTyhOVgoPTmW+vl8jAgGIkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0+XvnNVxf6+PJbYtD2Ictziv1gP4qGG0LtehOIgkW/s=;
 b=TJnr1GwymtYD/Td+gew4TDYgU/P0ojHN7oB35j29GyYarQ3yITFAIC8AbbbPgqWVU8hjqAe8d0Vgechcci1sW70DRpFpgDvLL4ONSQq1kzQH9CSGTIrnDZw5FoNkKOLBB0VOiZfUY8Tip9c8F2DQKtXgoZwcEbzrMvZg7Aho8v/BEpZ7LpyknthIsZ3B6xsEoLS5OsL8Spk4rWvDuQ398Gi7Jiirum0JQ3uFwDSGFuNbtBICkk2MsVr3lNPkCm30yvppkqivai/pYSybJAHa1GDoLghVl4brs5qBQbcizMSjmVCJT/ExlRKVTm6ru1t+JRhI/oi0ydTiUhd3j/GLOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0+XvnNVxf6+PJbYtD2Ictziv1gP4qGG0LtehOIgkW/s=;
 b=1Eblz/m7ZHraS+a8MHIyfS9ydHXg/JphiHSjY1mdAqccPJWmt68mE1fAcSdg9fg0O/NKwgKmVpkcYbZMb5Vx+VAUjoGVNJYkhj09wscfcVjFdnXkNsuRKMa+hko4ZWRwyvXesAM8fYH50yYfw4ctbgUSPZ/ql7WVLUW8mcndtZk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1494.namprd12.prod.outlook.com (2603:10b6:910:f::22)
 by CY4PR1201MB0214.namprd12.prod.outlook.com (2603:10b6:910:25::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Tue, 26 Jan
 2021 08:18:44 +0000
Received: from CY4PR12MB1494.namprd12.prod.outlook.com
 ([fe80::25d2:a078:e7b:a819]) by CY4PR12MB1494.namprd12.prod.outlook.com
 ([fe80::25d2:a078:e7b:a819%11]) with mapi id 15.20.3784.017; Tue, 26 Jan 2021
 08:18:44 +0000
From:   Wei Huang <wei.huang2@amd.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, mlevitsk@redhat.com, seanjc@google.com,
        joro@8bytes.org, bp@alien8.de, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, jmattson@google.com,
        wanpengli@tencent.com, bsd@redhat.com, dgilbert@redhat.com,
        luto@amacapital.net, wei.huang2@amd.com
Subject: [PATCH v3 0/4] Handle #GP for SVM execution instructions
Date:   Tue, 26 Jan 2021 03:18:27 -0500
Message-Id: <20210126081831.570253-1-wei.huang2@amd.com>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [66.187.233.206]
X-ClientProxiedBy: MN2PR22CA0023.namprd22.prod.outlook.com
 (2603:10b6:208:238::28) To CY4PR12MB1494.namprd12.prod.outlook.com
 (2603:10b6:910:f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from amd-daytona-06.khw1.lab.eng.bos.redhat.com (66.187.233.206) by MN2PR22CA0023.namprd22.prod.outlook.com (2603:10b6:208:238::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Tue, 26 Jan 2021 08:18:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c3bda52b-5a0e-4c47-9bd0-08d8c1d2ff41
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0214:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB02142F402596DAE207B15C14CFBC0@CY4PR1201MB0214.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HLe0WBl/u5H+uVnlgpSWrAwQIu2otTJ94ThGijzmlH/DMEqrO1Z+9TALEaBlecyRYu/Tae7QUPCJltAV+5ne9qhEWvrV4RqEd09pQeqP/MErCKPBeVUtDFqeYeZMQU3y4EhH3PxrCsIh7M/T1KaqlvKwTQWYNxEcyfPLB8Jh2j/KvBt5LfYMygvWpHL5R4dtlAFUuNXAWSg/FkgbBJPFKVdfmCjoUoqQ4JyTi0MSO7u9V4rA3e/zDqNgwkZ6RH/Ma5qQncTB23Du1uNd4GhB2b5LA74oIzM0W9PiOnpAYBXRSYodK8HTr58Nx/8SqS89eFMMutzvWDfIZiAgEC69Eefskcg01Zg3mpaAylh+uM49gQSZeL1Y3QaloQkYznARJ1tIIVrS45slKkJdvHo/CQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1494.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(376002)(396003)(136003)(36756003)(66556008)(6486002)(8676002)(66476007)(66946007)(52116002)(86362001)(5660300002)(6512007)(2906002)(956004)(186003)(26005)(16526019)(478600001)(6666004)(83380400001)(8936002)(4326008)(6916009)(316002)(6506007)(7416002)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?W7YTHMLZpNo/S9FPPnGD2qR97phjgYrvoIY/2Gza0qQlXra9rQrRuh1zmxZh?=
 =?us-ascii?Q?PmDMLZrCylc2dY5+6jb7iptwiJ4b4G5CgIM5Fypyw50ycpbPw3kE1ghu4Azl?=
 =?us-ascii?Q?0cjjdzctT+15uIzdfBQGDolKxZ25apEyrH7RWH6kv5M5s+DpGa9wdUuaBiJo?=
 =?us-ascii?Q?xt9A/CwCqbhluqQTePYgvEDNp3Vq3N1rldtKwIkrbUK08pFZLEtjLcw7JFNs?=
 =?us-ascii?Q?TzLYXckSWC1qn5XQYCVtDvRAdbHmt7QTiC8N89mt7pXfdIjPb2pO3fF/+hH1?=
 =?us-ascii?Q?Oaq+Rm5nBLRnBdj1vwhDtegmWXUqIPp6AEFZtfSUlke5jZ0OCQxwH0yFnogo?=
 =?us-ascii?Q?JWaSgC9khC+s/bJskGWnUgfoblaaCcoWoFCt2Ap/T7GSMTs7Qs3cWJxv4t1g?=
 =?us-ascii?Q?UCyTX9dUw00OI+2to27k5WYx0ngM7h/NGXYV1NWnMBi0bn+k7qQttLNTo5vF?=
 =?us-ascii?Q?9KMCFPSCxek428BMSSXSFhJJRw2zPMIWTQ18ZnelIqZW3us8vRDRP/3jeEwP?=
 =?us-ascii?Q?LrWTN3cIJS65TVniNy34IyBSWQEJPD9OKUzIgj1Z/NuTL44CuwZIFM29CnEd?=
 =?us-ascii?Q?dC7BWvBYyTUeVRakzm4SWZB0AK70iu5PePDeRqD4D8CJPx5C1l523RHAoKCf?=
 =?us-ascii?Q?J8C1PFIao/BWouNZRFT/dKRavHLkjd003ydfgleqpybnnHK/rj2JS6/YqlFO?=
 =?us-ascii?Q?HERaHURZ2Jac//RU3+JXwiXsWzCELRJbT8RypOyrDAaSj0CWFxQnUxMth9Nc?=
 =?us-ascii?Q?jgXHsOidq7VVgf2ErXL5VXd6G9aqjZP8UfymsKa9w+Lv2cTw3W5OSP9dYFLp?=
 =?us-ascii?Q?WTvKYs4O5r07Rl6Zo2Fpd+mqEIebOFDEysKhqfjCtyPEawBJd8b64cwbBYT3?=
 =?us-ascii?Q?NDrgOBltMEeG+4/VCMHUkW11KH7i/7q4fKkkfcJ+9cdxmhqLmKGrXizKBnNL?=
 =?us-ascii?Q?tj9t46Hp0AiIDJGjsvPP2wKKwJQ0cJDgs1k+pkD+cryRLwEKwsKSImjDhE/A?=
 =?us-ascii?Q?hhaE4aGcIybWzu84C+VM5btlcJ+Y7/NXYZ3Z0pq9VpcFe6vAOoc0Zm826K6V?=
 =?us-ascii?Q?/ffieWtk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3bda52b-5a0e-4c47-9bd0-08d8c1d2ff41
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1494.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2021 08:18:44.4996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R80YpHLyvECw/mIuhhm0FzMOJR9buFRq8qVxDdxadJzteVQz3zC6FJflVPqwLKMp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0214
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While running SVM related instructions (VMRUN/VMSAVE/VMLOAD), some AMD
CPUs check EAX against reserved memory regions (e.g. SMM memory on host)
before checking VMCB's instruction intercept. If EAX falls into such
memory areas, #GP is triggered before #VMEXIT. This causes unexpected #GP
under nested virtualization. To solve this problem, this patchset makes
KVM trap #GP and emulate these SVM instuctions accordingly.

Also newer AMD CPUs will change this behavior by triggering #VMEXIT
before #GP. This change is indicated by CPUID_0x8000000A_EDX[28]. Under
this circumstance, #GP interception is not required. This patchset supports
the new feature.

This patchset has been verified with vmrun_errata_test and vmware_backdoor
tests of kvm_unit_test on the following configs. Also it was verified that
vmware_backdoor can be turned on under nested on nested.
  * Current CPU: nested, nested on nested
  * New CPU with X86_FEATURE_SVME_ADDR_CHK: nested, nested on nested

v2->v3:
  * Change the decode function name to x86_decode_emulated_instruction()
  * Add a new variable, svm_gp_erratum_intercept, to control interception
  * Turn on VM's X86_FEATURE_SVME_ADDR_CHK feature in svm_set_cpu_caps()
  * Fix instruction emulation for vmware_backdoor under nested-on-nested
  * Minor comment fixes

v1->v2:
  * Factor out instruction decode for sharing
  * Re-org gp_interception() handling for both #GP and vmware_backdoor
  * Use kvm_cpu_cap for X86_FEATURE_SVME_ADDR_CHK feature support
  * Add nested on nested support

Thanks,
-Wei

Wei Huang (4):
  KVM: x86: Factor out x86 instruction emulation with decoding
  KVM: SVM: Add emulation support for #GP triggered by SVM instructions
  KVM: SVM: Add support for SVM instruction address check change
  KVM: SVM: Support #GP handling for the case of nested on nested

 arch/x86/include/asm/cpufeatures.h |   1 +
 arch/x86/kvm/svm/svm.c             | 128 +++++++++++++++++++++++++----
 arch/x86/kvm/x86.c                 |  62 ++++++++------
 arch/x86/kvm/x86.h                 |   2 +
 4 files changed, 152 insertions(+), 41 deletions(-)

-- 
2.27.0

