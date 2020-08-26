Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 724F72537F9
	for <lists+kvm@lfdr.de>; Wed, 26 Aug 2020 21:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgHZTNt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Aug 2020 15:13:49 -0400
Received: from mail-eopbgr770071.outbound.protection.outlook.com ([40.107.77.71]:40778
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726191AbgHZTNs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Aug 2020 15:13:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pn+wPMPjT4h5A8oijsKTlgRe3fj+25d8se20bElm6DOL1eRUr71bZeZkwAufrVRxixMVhvRjKoRhGQypRMUR1yGu4cWgfL4bHwtEBTpzOMX2tftSUDSMM6p7TiIzFb556jA50NXIqx/ml/GEMQcnXMiDRRhO2qjhsEasEKGUGx/rVp2oz3D8hg82Qir3lQhZRe2O1pZFpeu6rkooK862sEuHQRbHaE9rAzied6Pfqq0u33zMoN/FWpTEX1Y6F9wDxVxYGr+aiWfEa/iVN4aMWIXmy4AqC0SPwABPAS7Y6+E4EYf0pVujEH8prVTWlb5MLK78BRBPnHU9sFXMQ+sulw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nh4OqxKc1FcR8uXcuV9gqsIFIqN6sczGPryFOBwIDNc=;
 b=DSGFK8jrZe4WcNHEIztpNgOGKNhy+AGBVAsanDH7qoL/c2biP2COvwNa9M+6Msf7irk/oxe5Uz6rZTU+ZbxCsmYqSUZ6JZkE1/n0Ek9rGnwoegPJJ9+X4J3zxp8QILXD1GJWPuU+mEpxPEq5B9Ibkoem4dhQ0z/C8xHvrEbSrR2x7Ng4zCgwbIzTV/H/pha2rxbtdo0hmDUKoyOYweNYI/9WHV3zSqulUKYb78zrqHPcFifWxhOOXjMST+oPO6Wc7SYB0w2uR++TVOgQNHgCdvdzzjekfbZIcRqoIzhlyauOKmUVXEmCidzQ7UufeF4gIxWZ+2tC0o9fAedOWYc7BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nh4OqxKc1FcR8uXcuV9gqsIFIqN6sczGPryFOBwIDNc=;
 b=oGdAwHLvf18ajDeoYdDivB6CjXPzmZRSsQZkS9fqqUH9W7WTBoeRE5BEbkZ+jUTikPePFNVNDOC1A2uLB03Fp4kXK2n9wCNFW9djBXPT3s3FyYTpodyfvymeHOVBk18AcKt3BMowWcUY/fYu7Xb5s4WgksNo76UTiz9a67cItEA=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2384.namprd12.prod.outlook.com (2603:10b6:802:25::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Wed, 26 Aug
 2020 19:13:45 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d%4]) with mapi id 15.20.3305.026; Wed, 26 Aug 2020
 19:13:45 +0000
Subject: [PATCH v5 00/12] SVM cleanup and INVPCID feature support
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, babu.moger@amd.com,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, tglx@linutronix.de
Date:   Wed, 26 Aug 2020 14:13:43 -0500
Message-ID: <159846887637.18873.14677728679411578606.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR21CA0026.namprd21.prod.outlook.com
 (2603:10b6:5:174::36) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by DM6PR21CA0026.namprd21.prod.outlook.com (2603:10b6:5:174::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.3 via Frontend Transport; Wed, 26 Aug 2020 19:13:44 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 512a4934-e640-4ff9-dc70-08d849f4272a
X-MS-TrafficTypeDiagnostic: SN1PR12MB2384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2384EF6FDA2832E7AEED94A495540@SN1PR12MB2384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tI3k6A/0ldOQNGM5AR5XY6dpFQjhdseOzAVQSC7A799F/DNYLU2NJXZdkDekHIVXuUsxenV4RkHcxJBRJocABXPWpRflsuoXvXqtAf0BMnuoSTaL99dAv2uCkdENOd3+jFbjUkX5XZkhiPCwPvj/7Wn7nxzf2PBHC4aHxqep/22RWnMmHxBlWRCk28D33IBpj/t8py5KaYGQ2RS7bAu0WofZGa3u5KLNKJA5yIE3OtrVRpPVSnhBvBoJaqNSr+1jHkf+bsTAP5i0JIiTZy1KAUvBwvpIsikXGsS8vkBAsyXw++WLmFzFRIL4irYilrpvqe5U7Y5Z2rTJmNBcg+QCAhKXtHZSwg2byb9jS+8yFuNqk22oC17PrCpEjNLwxIykvk/tDxSVfJMYL1/ovNJtdg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(346002)(366004)(136003)(376002)(396003)(39860400002)(103116003)(4326008)(186003)(966005)(66946007)(5660300002)(66476007)(66556008)(44832011)(86362001)(33716001)(9686003)(52116002)(7416002)(83380400001)(6486002)(8936002)(8676002)(16576012)(2906002)(316002)(26005)(478600001)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Lc22HPGXU4XNt6HBxBGLZGd2P0C8hY87wYVU0N3v4zGGHYDnt1ErVrjlCkWiVC/381PAypYTyZv2oigqaDKqJUVjCoqkhey5rK8JpHNLpvdon+knpshBClcGe/WMxZX0tWOyn/vdQp8014YvbPhjFalsesWS23+RqqaqtZD6jCmzo7vQ1AleWmPxLgRrtPX08pvf88RTKqeg80TRc4TGX5NvD3WT6L5wFWU7cDmyH+Rze6JY7DG1/O/+Vg2wlEj08xhvFxxKtUxN23A1MJvLXzE0hQQ8/RIdHBjtBdWslCcJj6llWTPqQR2aCMGbV8R0sk+0Bx2T56+OOpAOcNHDnYd4sosj1HLKPQJ+cAzVxSz0xHZ7kocktu0VxeEDbpeuIdmVMbtDxxTNga2rwMTt0G6VYBtlKG6SpNsPUy0j9FQ+0VkspVPsuDKO/xZmfCpRhXLQnsnBoP0Nt+rpKCNBFAcBM2Z7Oru4073BhKBh/UYvhzWQe7BnELtVa6ldLRBbeehOl2gaUkxGKc4JRNmJ+7wbudNTdWmLTLCPqoEQtTBCgih5uSP7l9Ech0BfKimI89HbiJLpSuKMGMh3MFjsKWHQ/ZaeV0LEQcQNTRPnH+2sUqSZIsXJ+wffjvG6bflwLKU/nnWCGSKvn0O4TkdUnw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 512a4934-e640-4ff9-dc70-08d849f4272a
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2020 19:13:45.2392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 56UM813fz+FsVPkG9dMnyVj7+nfxunPxds5TRoAyByUjOyJAw7gj+WmpFvW5JzF2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2384
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following series adds the support for PCID/INVPCID on AMD guests.
While doing it re-structured the vmcb_control_area data structure to
combine all the intercept vectors into one 32 bit array. Makes it easy
for future additions. Re-arranged few pcid related code to make it common
between SVM and VMX.

INVPCID interceptions are added only when the guest is running with shadow
page table enabled. In this case the hypervisor needs to handle the tlbflush
based on the type of invpcid instruction.

For the guests with nested page table (NPT) support, the INVPCID feature
works as running it natively. KVM does not need to do any special handling.

AMD documentation for INVPCID feature is available at "AMD64 Architecture
Programmer’s Manual Volume 2: System Programming, Pub. 24593 Rev. 3.34(or later)"

The documentation can be obtained at the links below:
Link: https://www.amd.com/system/files/TechDocs/24593.pdf
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
---
v5:
 All the changes are related to rebase.
 Aplies cleanly on mainline and kvm(master) tree. 
 Resending it to get some attention.

v4:
 https://lore.kernel.org/lkml/159676101387.12805.18038347880482984693.stgit@bmoger-ubuntu/
 1. Changed the functions __set_intercept/__clr_intercept/__is_intercept to
    to vmcb_set_intercept/vmcb_clr_intercept/vmcb_is_intercept by passing
    vmcb_control_area structure(Suggested by Paolo).
 2. Rearranged the commit 7a35e515a7055 ("KVM: VMX: Properly handle kvm_read/write_guest_virt*())
    to make it common across both SVM/VMX(Suggested by Jim Mattson).
 3. Took care of few other comments from Jim Mattson. Dropped "Reviewed-by"
    on few patches which I have changed since v3.

v3:
 https://lore.kernel.org/lkml/159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu/
 1. Addressing the comments from Jim Mattson. Follow the v2 link below
    for the context.
 2. Introduced the generic __set_intercept, __clr_intercept and is_intercept
    using native __set_bit, clear_bit and test_bit.
 3. Combined all the intercepts vectors into single 32 bit array.
 4. Removed set_intercept_cr, clr_intercept_cr, set_exception_intercepts,
    clr_exception_intercept etc. Used the generic set_intercept and
    clr_intercept where applicable.
 5. Tested both L1 guest and l2 nested guests. 

v2:
  https://lore.kernel.org/lkml/159234483706.6230.13753828995249423191.stgit@bmoger-ubuntu/
  - Taken care of few comments from Jim Mattson.
  - KVM interceptions added only when tdp is off. No interceptions
    when tdp is on.
  - Reverted the fault priority to original order in VMX. 
  
v1:
  https://lore.kernel.org/lkml/159191202523.31436.11959784252237488867.stgit@bmoger-ubuntu/

Babu Moger (12):
      KVM: SVM: Introduce vmcb_(set_intercept/clr_intercept/_is_intercept)
      KVM: SVM: Change intercept_cr to generic intercepts
      KVM: SVM: Change intercept_dr to generic intercepts
      KVM: SVM: Modify intercept_exceptions to generic intercepts
      KVM: SVM: Modify 64 bit intercept field to two 32 bit vectors
      KVM: SVM: Add new intercept vector in vmcb_control_area
      KVM: nSVM: Cleanup nested_state data structure
      KVM: SVM: Remove set_cr_intercept, clr_cr_intercept and is_cr_intercept
      KVM: SVM: Remove set_exception_intercept and clr_exception_intercept
      KVM: X86: Rename and move the function vmx_handle_memory_failure to x86.c
      KVM: X86: Move handling of INVPCID types to x86
      KVM:SVM: Enable INVPCID feature on AMD


 arch/x86/include/asm/svm.h      |  117 +++++++++++++++++++++++++----------
 arch/x86/include/uapi/asm/svm.h |    2 +
 arch/x86/kvm/svm/nested.c       |   66 +++++++++-----------
 arch/x86/kvm/svm/svm.c          |  131 ++++++++++++++++++++++++++-------------
 arch/x86/kvm/svm/svm.h          |   87 +++++++++-----------------
 arch/x86/kvm/trace.h            |   21 ++++--
 arch/x86/kvm/vmx/nested.c       |   12 ++--
 arch/x86/kvm/vmx/vmx.c          |   95 ----------------------------
 arch/x86/kvm/vmx/vmx.h          |    2 -
 arch/x86/kvm/x86.c              |  106 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h              |    3 +
 11 files changed, 364 insertions(+), 278 deletions(-)

--
Signature
