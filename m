Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCAB21F6F8D
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 23:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgFKVsd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 17:48:33 -0400
Received: from mail-co1nam11on2076.outbound.protection.outlook.com ([40.107.220.76]:56640
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725869AbgFKVsd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 17:48:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c+YqsmGquX//lh1RwyiCIc/sZE/pRZDCAZlbI274GHu2Rqdmbom/8pz6hGgdEPtUPcxe+uy+YaWRWMr6Wq9XzQV/WggqKLh2sbxwQt5oWevv/6q6JlEkcPyov2EtsRd7ErfYA4YJBw9JE81HrIvalS4IiVW5mWaxVIoOTg7/yIWU7EQbA/p99A1bM4/aEhfOEPgRMOsoibscAQoW6PPHTySxGeNdq3flv/vyuHw5/YvDRFxwaxzMMEHz8V/Sp/Udi81JOHyFqkr+fmVPZi0Lv0vSyyS2vSDn2G63OUesKV1H3ma6AYgPxD/op9j+gMqcsOQI3+qTksueDlCUuFXNBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ecAbjq9VTF3XrTXFvyqZkDKHIpSFuh8jbFK91mDPgN8=;
 b=mJNDGEDkobyLrwnJslc+rGI+RdeGXgnfSzbKndbXFFqZdeDuRA0DAOeL0Yk1YXO/ThLIpdZvKA/r9OECxh+yWjgITBAOGEhaW2s8c/y9ZTwT34UiYZcOTyGQ3WZURpG+fMPAtQOAK481wAxgvlv5+Qc5TM3B8GPTkrfy1kIpHSP1ebmdCMc7Ue6X0QQvQH63PcIM2XIC7NT6gGs7scnQwXklAUtHv3wCcE6pfF9hfv8Gn0Fedov86xO5/X+ZFVia379kVrBseeN6VxZ87mZ1yBKY99e3zm26XNkWIChp4pQ2PNgPaxFBcI0vaoQVLUZrDaaz1SFs5aWnhE2l7lxwdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ecAbjq9VTF3XrTXFvyqZkDKHIpSFuh8jbFK91mDPgN8=;
 b=e1CLXy0EKIYbt/fSd7SRPHRD+E4RHgJCCGnlLjYkXlzRmSL54u+S+errOzGABbrAxax5OVMpR9Iozez552MCj80uR9RtdASidrTpE6uxs+h+dGxA3R0Uvr6aErwtkRr2+9CR10ChLA+axv3Suf2avmoQGk4QY/Mtu5Nu68CHIQQ=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4589.namprd12.prod.outlook.com (2603:10b6:806:92::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18; Thu, 11 Jun
 2020 21:48:30 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2%3]) with mapi id 15.20.3088.021; Thu, 11 Jun 2020
 21:48:30 +0000
Subject: [PATCH 0/3] INVPCID support for the AMD guests
From:   Babu Moger <babu.moger@amd.com>
To:     wanpengli@tencent.com, joro@8bytes.org, x86@kernel.org,
        sean.j.christopherson@intel.com, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, pbonzini@redhat.com, vkuznets@redhat.com,
        tglx@linutronix.de, jmattson@google.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Thu, 11 Jun 2020 16:48:29 -0500
Message-ID: <159191202523.31436.11959784252237488867.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0501CA0155.namprd05.prod.outlook.com
 (2603:10b6:803:2c::33) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN4PR0501CA0155.namprd05.prod.outlook.com (2603:10b6:803:2c::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.10 via Frontend Transport; Thu, 11 Jun 2020 21:48:29 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 03a1b932-43d1-4a91-fdb0-08d80e512e2a
X-MS-TrafficTypeDiagnostic: SA0PR12MB4589:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4589B91CA6B930498E11B24E95800@SA0PR12MB4589.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0431F981D8
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 78s97p+L/nbBx3+grFSKbdN/7nR356rKiVVkxDvxbKoEAJCCK5DjXM8t7pbfFc8kgWHQ9i1kOUs5d7DTpHwcoN5zE8bLsP2p3Fd3Q8j39Z9ElhRxXxJc5Sp32QIHxlN+UKJKQGdMvkT2FqJAvajuB/EQNrPx+m1E1eIzWQQZUdIX29lYg8MWT8x5MW19DW1QKBXRklb6Lzx3GV3HvFulW/s+cu0gaum+7axbB0zrTRJnw9kA8+YQrP7md4LljLTryypm0seoJUMImI8V6zYFqhieBRWUXvZzqJMCEqPbliRYCckeQMJztgyQj2k2Vyf4bvZ9z6fzop55KO+qal3XxhfK+FbDTGpEpxgeAb4TsuProg0pVxVzs89ocbaB9aK67GJrDEbzmODONvTVU7JcqiZ0KxATh60ot140DWgisIw5k8JuTkaYHRR7SB4lY2FbFKa8pbUHHrmu+gHxFiUITw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(7916004)(4636009)(366004)(396003)(39860400002)(346002)(376002)(136003)(52116002)(33716001)(6486002)(16576012)(8936002)(2906002)(8676002)(16526019)(9686003)(7416002)(186003)(4326008)(316002)(478600001)(966005)(103116003)(44832011)(956004)(5660300002)(83380400001)(26005)(66476007)(66556008)(66946007)(86362001)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: CuU87wuiFbNr33VeQaNw0DrVlk+Aka0srMYMaIkTREuuWXiPAh6BuBPWbu2APfHLPOQiaiCVcjAPUBVZYT1AT+00plmZx2hPW17ecDzl8fxQ6lOIpe01fJu30T/JH5gJWYqufEGt8lTY047Nk9vGPnZ97xOAJOmJuPFB3Yufb2KgLkhZv+6SSTKmNQl6yEwcB721x/4ErK9WZEckNGBWV/ixV+A1iSMT9l3UZN6EPawh7aoQE4FK3Fwgbr9XRVDKxYCANPvylwU+c73zNYODWXb3EUAhljjP0n0oe+a3F17jUavTWd/ZU7VuyEMM6aYbVQOCaJ5VIra+Pjv7/7kLBanHcVtWdyOf6sE8DhbG+SDNB1r8J5e1zfum0BlMt/qqkkuy8Nvt9gQOGR7dGWZO3cI0mnUQ7PD5hHKO14NutlC6oCEiojkMbhV6YSPVou88GPpIxmCq8UVJRP5Vr5Q9Gm6Y708vI+IKaqtT39Hyosg=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03a1b932-43d1-4a91-fdb0-08d80e512e2a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2020 21:48:30.3883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i8E+UbEyHxwKw6uB3BKb/U909P3YRgemcXmuuaoA/fSdsDz91kunk//LTTkCo/L3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4589
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following series adds the support for PCID/INVPCID on AMD guests.

For the guests with nested page table (NPT) support, the INVPCID
feature works as running it natively. KVM does not need to do any
special handling in this case.

KVM interceptions are required in the following cases.
1. If the guest tries to disable the feature when the underlying
   hardware supports it. In this case hypervisor needs to report #UD.

2. When the guest is running with shadow page table enabled, in
   this case the hypervisor needs to handle the tlbflush based on the
   type of invpcid instruction type.

AMD documentation for INVPCID feature is available at "AMD64
Architecture Programmer’s Manual Volume 2: System Programming,
Pub. 24593 Rev. 3.34(or later)"

The documentation can be obtained at the links below:
Link: https://www.amd.com/system/files/TechDocs/24593.pdf
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
---

babu Moger (3):
      KVM: X86: Move handling of INVPCID types to x86
      KVM:SVM: Add extended intercept support
      KVM:SVM: Enable INVPCID feature on AMD


 arch/x86/include/asm/svm.h      |    7 +++
 arch/x86/include/uapi/asm/svm.h |    2 +
 arch/x86/kvm/svm/nested.c       |    6 ++-
 arch/x86/kvm/svm/svm.c          |   43 +++++++++++++++++++
 arch/x86/kvm/svm/svm.h          |   18 ++++++++
 arch/x86/kvm/trace.h            |   12 ++++-
 arch/x86/kvm/vmx/vmx.c          |   78 ----------------------------------
 arch/x86/kvm/x86.c              |   89 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h              |    2 +
 9 files changed, 174 insertions(+), 83 deletions(-)

--
