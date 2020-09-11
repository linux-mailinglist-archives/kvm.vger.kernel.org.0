Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B242668B9
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 21:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725870AbgIKT2S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 15:28:18 -0400
Received: from mail-dm6nam10on2075.outbound.protection.outlook.com ([40.107.93.75]:49377
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725770AbgIKT15 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 15:27:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L8RXmlFGmDO867+sMOwu9c2NAdZRXkMEBIVq0YOYAAWCLSBvkFPo0DIwk01SxeKs/vBhErt3Rc4eluwSmBsDFYSoKOf9aPjkt7JEuNjuifqXQUn3CWsoDEPQwjXfXwqg/cbRymAN9+1Ie91rAKtrgtxazG1AoucDYoA4sBnd7/tskZISr7tKdopUyVvcg/XvK49bjrdcEc85JDEu3js4HUYNn953TzUtY9g/7m9KnnhDHmr4pkqAptcyUIMbU5txSVNb5VPj4TnTba/ZhOCvBBGFK4fQgYQzh75z9DhHP/G+SOw1l67DXFPrR9vdyq86SpVk1LyqcGuSpDDdLbBmqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zz6NqFPSSmfH/Hdvc/Tzl/msMmjB5Jmp7wlPS8FQC1w=;
 b=BxBREdQeuyFCcG+zfaPAp6AUOMmPIf0XOC8azUlHK/ocoe45n3JXuD2qqARqt6/g3unI3FiCefpNxJ/e2y0W8dFjL4ILYli7NVuXgKN60zxyW73szys/VsRK1AKA6F0TWcHKmjG4GtG+82cTbZg7jnYlWgWthYX+Vu0B7pYSzNEwt7XExRshlMd+znXQlMpgEVdlqkLE+Brd2wdaZqyU1eCCN4PaIXCJbqEBEBXRy/DwSUI+sHlJj7JH/SC5xgaDruxafS7RWkfn/PR4ugXModz6KPR2MkjFnLFa3YN/nT41MuK2o1m2Ixc7TvIuxoxXaEYwuwchC8o6r3I808T4yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zz6NqFPSSmfH/Hdvc/Tzl/msMmjB5Jmp7wlPS8FQC1w=;
 b=P7IkISjR7ttxThp+tdqaE7+1DtFrJ0SMRNooYzUtXKSmNyVKsRS9oFDFFfoIZ+EJ5rJSwTeXADqB9KD7as6CroQNE5uFjj5qoDq5WdiKI6S/cdLDHIQGMoD//M5hOrJ12BRvkiT9+Dn3zVEAozAVzhmBNS+mM8yTL1yMV7R6p44=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4543.namprd12.prod.outlook.com (2603:10b6:806:9d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Fri, 11 Sep
 2020 19:27:53 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d%4]) with mapi id 15.20.3370.017; Fri, 11 Sep 2020
 19:27:53 +0000
Subject: [PATCH v6 00/12] SVM cleanup and INVPCID feature support
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, babu.moger@amd.com,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, tglx@linutronix.de
Date:   Fri, 11 Sep 2020 14:27:51 -0500
Message-ID: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN2PR01CA0053.prod.exchangelabs.com (2603:10b6:800::21) To
 SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN2PR01CA0053.prod.exchangelabs.com (2603:10b6:800::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Fri, 11 Sep 2020 19:27:53 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0fd6d7fd-f7e6-49c9-d388-08d85688c76d
X-MS-TrafficTypeDiagnostic: SA0PR12MB4543:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB454345E4436A3E95DFDED6DC95240@SA0PR12MB4543.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wvdXdnRBALN9oIcSmtE1mw3tdqPlgIjNbtsi7e7crvDW6bVcF4oi6XRGTg/X4oQQGGzZMznLDS4DF3hxls9w+m3UDPRf9lrxPmoVdV9r1GqQcXt2LVHJbc6nZYd+8SgqRik6THgGolAmOjlOJB/GRTQTDuT5SENgfJdGTotMR6WbeHipFsMPs3yt+MVu5ZzwXTGTSQY4B5+lETs3rer5sbph2cK1U38pFT7b8Hc9bHT2+FINjTBlE6XGaTTVgzKB58s1OGuckGE/qJy9hGNDZC4LUHa501Y9tA/QNXyUdc0qspE2NH+STs6AKIFseacpdKcU+UHYIIc2aEjzWwKLJySYwSmwXf8bcujZ4BW9rAHntmuH547UQ8LzH7wUB3Hug0edQeYQwPDR+aJT6meaww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(376002)(136003)(346002)(366004)(39860400002)(396003)(2906002)(956004)(66946007)(66476007)(103116003)(8676002)(66556008)(52116002)(5660300002)(7416002)(9686003)(4326008)(966005)(8936002)(44832011)(186003)(16526019)(86362001)(33716001)(16576012)(6486002)(316002)(478600001)(26005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: nwRDIaJeOm598USSs2/9MnhxeZZZL+iygaesti+JUUVB953nUwgEPOi12IS7r1DdhHN8SKKyE+vSI/GJSMHNx9mTU0/UkONr6ujbgVgG1RBzjo24V/1vdi7oW+ZlnjSl2BMGbVidMSKq7l/7/MMFxy4MrRA4IHs7hcPAnpu1nP3023VOK9j0LkN+uT+G3HngcRMDhIDCVZ7GQxBBX4BzWTPIWYijegRpfLe2DK1H/Ddz+qNgOSqyqQx0TeFDp/pr3TY3v3goDYyiAF1u538jMcHi8ay4T2SK1p3iPlxGsycVrIBHENDxKqZkZ3lkeYpcO9jxpFOPw6V3ls7UfC9fx7yjUgZlaoJ+Xd5KcLSW12+yh+hazVRKj+SWsJ6skn1v173r9hjoshxSpLX6nRMGzKKoaPKoX/8DqBTND1byLg7XO/1ndl1yMyjt7lld3hzvMz4ddKidxWMqh/bUAGlFHaL/7w7Hn950aAmd+QsmwanGSbqNfmCqw1ocBrhY1s1y8OgJxnme7G3aML+vg3HAP2ZjtgZAzJGmXLF6ihrBsco9E+rC6cRIxXtJEOhPNccGflmgkLwcZRgv7HjrgRQA447DOWVqkIcwlBkwnVOxZP+iSgaalJ/M6KXWSy7rGEg21oiZb9b9tXkioch9XOMNXQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fd6d7fd-f7e6-49c9-d388-08d85688c76d
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2020 19:27:53.5868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y2ZtkrXZxembXBHbCCYD/b6gr0vlTCS3SyTTd+diUo8oci/EyVSFxbs2zY2ezl30
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4543
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

v6:
 One minor change in patch #04. Otherwise same as v5.
 Updated all the patches by Reviewed-by.

v5:
 https://lore.kernel.org/lkml/159846887637.18873.14677728679411578606.stgit@bmoger-ubuntu/
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
