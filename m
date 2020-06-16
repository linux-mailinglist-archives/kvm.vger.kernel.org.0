Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65C5D1FC14F
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 00:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbgFPWDh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 18:03:37 -0400
Received: from mail-mw2nam12on2054.outbound.protection.outlook.com ([40.107.244.54]:8672
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725901AbgFPWDg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 18:03:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XxPRaytk1dl+tywJR/gPwab/F+lBcPU2gRw4LOed7c0E73CI3s16cX2Bgo740Qrkj56dKtUkRCYakuG+tzW0+BokAdFzDS9eiRIFuPD7UXw7Ev2J4OKT9E29tFX/ApvObwJSu3lmdZcCuFFspbmfhiUoLW4KR8DiwkxmXTE57K32uSrYUip9hcmo6gKmZIyo+euogPZtj9VjxRpbsqA5rDidTZ+Ivc9YoFtTs0ke016AZfqkNlCuS/fLXpkiafL8am19ozGat2QrSSHFdYlXEOT1SqoOcmAJ0F8fdHW+utyhmdw+ZLzsrq6FfuURga/6SCAvkw4bI074OoPSbWEnag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UJtnPHwqrwsPthAoJRJfVCpS5cTAILQJ6MpaOqbjKME=;
 b=n/Tqygc+qw22Klb+xCnferPzqI2r+4/iC7Q+YKSTdng8Q0Sbvxq16jdWiERp5HbpZXVF4DdUFzFzNJ6F6eYZvNhqf/uCnYPXCS7z9H1drqm3yeCHsLhh4sQX5xfjt6eTLAqxnFZh518uoj72+EdJseFGyQNk/KkfUXzgTG/YlmBNpENUmd9Clp4SClhymSZ83pf5/0tWxumqlX5t348GQ703YnWSXIpDGA4JGyRBPD+jZoPtRBhvIyNGbiGka5P1uI9iWXY9U2aTo0Ry6gXGHZ++HD/TXG8723ZBJxEPK8L6RKCFlp6NfjpXfPJk1fRKWc5ZT0ezzUvJv6sw5ZPzew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UJtnPHwqrwsPthAoJRJfVCpS5cTAILQJ6MpaOqbjKME=;
 b=g3G5ILDcGm4XTY4k416yz5coVUmTHVjtxNn5K+svc9Jr2iJPbrgKqy95coNAkzcf9a0/pE7RSo3BsRHGxebV/gKnzid2fger/SjQZfikr+sGc2nZTWwHvNdhIOsolUHU5cvQ+MtlJUgsIz3tCnhsgS4CgXpv6x2fETNSUIVqOeE=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN6PR12MB2622.namprd12.prod.outlook.com (2603:10b6:805:72::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18; Tue, 16 Jun
 2020 22:03:32 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2%3]) with mapi id 15.20.3088.029; Tue, 16 Jun 2020
 22:03:31 +0000
Subject: [PATCH v2 0/3] INVPCID support for the AMD guests
From:   Babu Moger <babu.moger@amd.com>
To:     wanpengli@tencent.com, joro@8bytes.org, x86@kernel.org,
        sean.j.christopherson@intel.com, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, pbonzini@redhat.com, vkuznets@redhat.com,
        tglx@linutronix.de, jmattson@google.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Tue, 16 Jun 2020 17:03:29 -0500
Message-ID: <159234483706.6230.13753828995249423191.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM5PR04CA0072.namprd04.prod.outlook.com
 (2603:10b6:3:ef::34) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by DM5PR04CA0072.namprd04.prod.outlook.com (2603:10b6:3:ef::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21 via Frontend Transport; Tue, 16 Jun 2020 22:03:30 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f1f4adb1-2d81-4be5-9984-08d812411b5e
X-MS-TrafficTypeDiagnostic: SN6PR12MB2622:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2622FF7E36867C7F74637479959D0@SN6PR12MB2622.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 04362AC73B
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uoUzP+oP559/HakRXlW2/GW91fQzxGl57qS3EdxXsysTfe3r69tYOXkprnvOdbGWto8FIzD5vVjXH2AptYYs0zYL0dTFWZpVeLkrjEHUGV+VPTVbv5OEFSBkC8NHLMF4iNstP0Z7GwyqM/fesl6ZjLxPr8AN4KMvmUs0TEJwcyJGdMIJFSvyrA96cdEc7mtai9XJ8Hrvzb/DwDkddzBUE7yetuKDf7UuHslWny9kgRdnGBSoSYP8nubN6X/ROVHhk9pC79f8wSgBIKv9/VtQnrO2QDwIZuE83kKuKhtMcWBJ98gPuvcM3+ORT+v32PJqJxvYuLBQBSvcmtvEygMMH5MI1K48QOJ9n9y6oyeai/O7nyb2bDMlVj3glQ5CaClaXBaTEgFRLapkCaE3nwDnZJdMOa9rQMDsc0FELG9hlzYUuCwP9Q3dZekXy+9VzaRH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(7916004)(366004)(39860400002)(136003)(396003)(376002)(346002)(7416002)(8676002)(83380400001)(478600001)(5660300002)(16576012)(966005)(8936002)(186003)(4326008)(103116003)(16526019)(2906002)(316002)(26005)(66476007)(66946007)(66556008)(956004)(33716001)(6486002)(9686003)(44832011)(52116002)(86362001)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 1+wtB8g7g/LKTQ3pFouINuKeHxL/vqnm7fgRXMfoU3eXup4IVzEswuhV+skJ4F/rYYNmIXG9OLQXRgjANTfjgBZ6r26anJtchMMjX9F5ISCYHbu2f2bzFnK6IKx53bBeDi82uasr2FMpxUQn0TiZlTW/AfPb3ViQsTiz9+wS2MsoOo7E213/trclvpVHwwynDLIZxqn1DM9PvPFddxQvM3VGUDO0vqwf2ErRYb7Oy7T4wcQNhHEsSKlP7gJz1Z+enOqpHFddC6C5iWhYa3ELuCKlJYD/1Q/t+aS0RUKcQsrDGJ5OxydIMvkHKg6/YZV52rB1jx9zY2SsCu9H3GTQj3AjCOpP3G35QmNplLEFkXPSVccQDWu8SPlmdBCO/wkDX5lFjrTSOhcALGZihAt9C7hACTrV0ZVOrQSx88wh4IwLMlm0fvqczQEZuEK32wjcwArIVJQbsBaDm49D2TZz/KGLSUBzY3fw9BDeiPOB+cc=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1f4adb1-2d81-4be5-9984-08d812411b5e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2020 22:03:31.6922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bv8F+ISttHuDZHkqvj2CEsAKABIORlF6VBmzyk+A6OjWDlsLpJvZfQ8APTg6J1D1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2622
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following series adds the support for PCID/INVPCID on AMD guests.

For the guests with nested page table (NPT) support, the INVPCID
feature works as running it natively. KVM does not need to do any
special handling in this case.

INVPCID interceptions are added only when the guest is running with
shadow page table enabled. In this case the hypervisor needs to
handle the tlbflush based on the type of invpcid instruction type.

AMD documentation for INVPCID feature is available at "AMD64
Architecture Programmer’s Manual Volume 2: System Programming,
Pub. 24593 Rev. 3.34(or later)"

The documentation can be obtained at the links below:
Link: https://www.amd.com/system/files/TechDocs/24593.pdf
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
---
v2:
  - Taken care of few comments from Jim Mattson.
  - KVM interceptions added only when tdp is off. No interceptions
    when tdp is on.
  - Reverted the fault priority to original order.sed the 
  
v1:
  https://lore.kernel.org/lkml/159191202523.31436.11959784252237488867.stgit@bmoger-ubuntu/

Babu Moger (3):
      KVM: X86: Move handling of INVPCID types to x86
      KVM:SVM: Add extended intercept support
      KVM:SVM: Enable INVPCID feature on AMD


 arch/x86/include/asm/svm.h      |    7 +++
 arch/x86/include/uapi/asm/svm.h |    2 +
 arch/x86/kvm/svm/nested.c       |    6 ++-
 arch/x86/kvm/svm/svm.c          |   55 +++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h          |   18 +++++++++
 arch/x86/kvm/trace.h            |   12 ++++--
 arch/x86/kvm/vmx/vmx.c          |   68 ----------------------------------
 arch/x86/kvm/x86.c              |   79 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h              |    3 +
 9 files changed, 176 insertions(+), 74 deletions(-)

--
Signature
