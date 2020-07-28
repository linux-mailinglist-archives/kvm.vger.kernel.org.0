Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B295623163E
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 01:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730000AbgG1Xhw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 19:37:52 -0400
Received: from mail-dm6nam11on2075.outbound.protection.outlook.com ([40.107.223.75]:17537
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729867AbgG1Xhv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 19:37:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GR8jYUgSAuIWtTDRYIjd5jrUa7sce4Tn69ywJakXtXxKZjVHLhVIInbgVnTp3ju+eo1uR4U9BRLxvrmKGEeujsT5F3Jx46cSEaW1m75JgOCNghip3pRD0+DImwzI3lWPEovb4nOGGp+mXYDRSIxeHWclaYBlEkuaBznfGWXhbHCa+DyovQqvR2pJSLhy47T6HtF3POjq8H260SkNMDDFjGqSKPVR57RaulXCfftMiukpPrG+uqSbB6j4Uc19WJib+jOks+5+sFhSJLCKj5wB+3nqb2bwR+8VXxqNWZoV8tGJy7gscHwRA5SJWmcKCEk6p1pW4YO88R9kS0tiLuMcqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H4EFeKKKyp+uZry6Zt52hAXih2OeyLNA720/s7zMd2k=;
 b=Dm1CIjeq5bKKjTSh03sE0T9Df5vZuHt14gjxnguACM5dQCsNgngKJcs9n2RuzpczFIA8ry7L5ewqt8cw7Sq6zMnlmK5csCjESnvR77KdjXS96EC84UbgkTHuvX/wjlKoOOJCC5ipd2zZDmZu+kYPwijCM5YbStOP2Sn8cm6L7q1mcNfq04kjgGgrmlz5ubJZ2WUP8MJZsMBPlkOYZc5Las/FIvj51X5ggPABU4WSAjfVrExTcBtjidTBGK8TIUGGGv1/j5Kgw4wTF4hgL/23Z5T9QHd/ueFSohNwGGg8BaYtUDK1AjXTkfy9c6+9ad6Lub+hg1FjDT4zlObDK7aFlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H4EFeKKKyp+uZry6Zt52hAXih2OeyLNA720/s7zMd2k=;
 b=vux5U2ZFHngDgqdOTjpS+U7QMryYRSZPK22iWXWtnKzWICgrzKZ5y77ZghQUtiRjSNpi8v/rn5ZHBMnDAFF8hXqmsILW6hJfqNDp2eLZkMWqWMmTsgLQJIXgwafSjV9bhjX28DN8L4NSWoaVRuujiz7eFiSWWOQEG8q7FxrSeAs=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4445.namprd12.prod.outlook.com (2603:10b6:806:95::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21; Tue, 28 Jul
 2020 23:37:48 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c%6]) with mapi id 15.20.3216.033; Tue, 28 Jul 2020
 23:37:48 +0000
Subject: [PATCH v3 00/11] SVM cleanup and INVPCID support for the AMD guests
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     kvm@vger.kernel.org, joro@8bytes.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, tglx@linutronix.de
Date:   Tue, 28 Jul 2020 18:37:47 -0500
Message-ID: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0801CA0013.namprd08.prod.outlook.com
 (2603:10b6:803:29::23) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN4PR0801CA0013.namprd08.prod.outlook.com (2603:10b6:803:29::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16 via Frontend Transport; Tue, 28 Jul 2020 23:37:47 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f11b4c3e-db4a-4672-6c07-08d8334f3c66
X-MS-TrafficTypeDiagnostic: SA0PR12MB4445:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4445299A25E6966E960D378C95730@SA0PR12MB4445.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8wCrGyRtxUg+gpUVCIIzMZ/dIVzyrxsdCHbs0cOy1OwdkRU+32rvFOygMDyKq0A67RYzTZpusgtuQZW83+MPNgZ60nIKTqNYNsfYZaLP/I5TWN9p3CeDDrMoJhgzPPeHTFama64UoFDihLgrQoGlVFmvf28dM7geU/jDAscOdFJrZn88eDxrFFuxPyS0rxjsdZJM1aw1mRRSJLIK/7YD/QYl4RQCnnrIkabk+jxMc65njd6L4oQEVLvhODHrd102aJolB4vNRDFBPuoksVy1DFc7M3yOaL4X5U+Yk1h5HvVkCSue0MK26q32M0pbdPcACDZfH1LL9SBBlvupyRYczX/nn4zKay56nMYXYixzomlb6Pwh5aB2uKGptkggbCwh/Z47qiqJ48mlFIQdDTfXcg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(7916004)(39860400002)(396003)(366004)(136003)(346002)(376002)(33716001)(103116003)(52116002)(66946007)(956004)(86362001)(83380400001)(2906002)(316002)(4326008)(6486002)(8936002)(66476007)(66556008)(7416002)(5660300002)(44832011)(26005)(16576012)(966005)(16526019)(186003)(9686003)(478600001)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: LlVJxUAa80AL4M1gUfUvjQPB5JOCpC76FEb+3eVzNhFbd7iMsEqGMdIuoHfdlxZJZr/jP52JUf0B/6Ty/l38uBWuN72qg9ZSwqMeIYo1berG6yiNbLLltMiDibpW7JJkSVBh87IyUV/B2s8lwp7yetlr3mIWqdbF+cGC35HAfos0paSUBiRu9+m6Q9nnPNNwY0uJ7aBFM+ihw6SGWL81aVv2eA9o9eKgiKfR1oTHXNDrWKDTW9la04QQyg6acBwj6+2mJZaMLC2NAFSfg0ON3QxLIblX1RzHO2JfxWFqFEsoRANpyOD+VhrUOh5keVsxMNSJfjOSuhkM7blaG+AlqXET8GIpuJHjijGqGby9xHwTFjNAqe3fSpYaQT5zNe9WT7fNRqn6w86VoUEIlBPLhmVIej62F4+rDNw3XDbQJKg1ttBZYoa5a0hC3gTJJod/koIUMMnEPjrVm4z/W10pNyngMfIx3AdL4Exx+Ahv7Fs=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f11b4c3e-db4a-4672-6c07-08d8334f3c66
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 23:37:48.4421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RPmWtySNrIfKiySL0C0kddxXOsAUoWqw6r5/e62DxuUf9i2VnSl+lCY9Y1QqV9sF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4445
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following series adds the support for PCID/INVPCID on AMD guests.
While doing it re-structured the vmcb_control_area data structure to
combine all the intercept vectors into one 32 bit array. Makes it easy
for future additions.

INVPCID interceptions are added only when the guest is running with
shadow page table enabled. In this case the hypervisor needs to handle
the tlbflush based on the type of invpcid instruction.

For the guests with nested page table (NPT) support, the INVPCID feature
works as running it natively. KVM does not need to do any special handling.

AMD documentation for INVPCID feature is available at "AMD64 Architecture
Programmer’s Manual Volume 2: System Programming, Pub. 24593 Rev. 3.34(or later)"

The documentation can be obtained at the links below:
Link: https://www.amd.com/system/files/TechDocs/24593.pdf
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
---
v3:
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

Babu Moger (11):
      KVM: SVM: Introduce __set_intercept, __clr_intercept and __is_intercept
      KVM: SVM: Change intercept_cr to generic intercepts
      KVM: SVM: Change intercept_dr to generic intercepts
      KVM: SVM: Modify intercept_exceptions to generic intercepts
      KVM: SVM: Modify 64 bit intercept field to two 32 bit vectors
      KVM: SVM: Add new intercept vector in vmcb_control_area
      KVM: nSVM: Cleanup nested_state data structure
      KVM: SVM: Remove set_cr_intercept, clr_cr_intercept and is_cr_intercept
      KVM: SVM: Remove set_exception_intercept and clr_exception_intercept
      KVM: X86: Move handling of INVPCID types to x86
      KVM:SVM: Enable INVPCID feature on AMD


 arch/x86/include/asm/svm.h      |  117 ++++++++++++++++++++++---------
 arch/x86/include/uapi/asm/svm.h |    2 +
 arch/x86/kvm/svm/nested.c       |   66 ++++++++----------
 arch/x86/kvm/svm/svm.c          |  146 ++++++++++++++++++++++++++++-----------
 arch/x86/kvm/svm/svm.h          |   87 ++++++++---------------
 arch/x86/kvm/trace.h            |   21 ++++--
 arch/x86/kvm/vmx/vmx.c          |   62 -----------------
 arch/x86/kvm/x86.c              |   69 ++++++++++++++++++
 arch/x86/kvm/x86.h              |    3 +
 9 files changed, 335 insertions(+), 238 deletions(-)

--
