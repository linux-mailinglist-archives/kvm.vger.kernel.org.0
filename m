Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5939523E546
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 02:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbgHGAq2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 20:46:28 -0400
Received: from mail-dm6nam12on2073.outbound.protection.outlook.com ([40.107.243.73]:24416
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726011AbgHGAq1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Aug 2020 20:46:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nsxoatNi18iZ7aLtV5xNZb0LNidlPTcATdTvqyLXMwb+UhxJYqgATkzbdxJWA2TJXrL5x4i8ZskKJhK67SMIRhWWC6Ng0D+rc8rVIhP9t1fUotKM4IvAMGMSHg2LGmSxWJr10ECGYicKPS9a0yp80RtCKy3pKf92SvrR6VgkLHGJ6zz7ztIJdtM7mEElyy1Rzhyr60rtCFxPSlXt5IK0QOQbuomKtHYJM5rks1QnOu6JVUvP46ty0J0W65H2NrrvcHJC+e749s33nZmWIaSH1M1QSiczwW/G5pqzE4SP1HknvrPybKNyT2y1h1QW7hzBNSz3Q8p4R7B3Jv42cBSXwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p7Fig27GH/SZKzuAM1l7HbKtV50j0Yv5t0+/zy87IIY=;
 b=LQ2n/g4fB0P2GIiz1SPSdECul1BUzKVF1EkVFkeNxMZDvdP5i25QrsARgB1YBoQGFdMGheX0LtAbPVuRYMZ7EXRa3tYnOlOlZaiXU/vq6+IaJFQpkNhrIBvVD7S+Z0uTmoahgeKF3Np9/5U534KmZ9ebCZa4IH5kbRnyRr+qQq32JVtH2ayd2xxIW6pnl8upyQlCf5xduY4aGPWkVajwihf+V/UYOtgiPNlT9nSEmGkA7N7NyFb7xemikXwq3kQh1Quu44ltlJMF5cGGgyzT5pDrY7yVnBt9Rx2IRp+T7Q9oqE8cDOSk0taDPezJZFrvLN08VVyqypcdg4VUVUWikg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p7Fig27GH/SZKzuAM1l7HbKtV50j0Yv5t0+/zy87IIY=;
 b=bd4tz29aWuGlXCxm34IAAnLdUmWiurLOm1vDCoiFe8BW0bJY92//mxzOdKA3sXMSe78E0hVVJVuruvE6bQ2vs1gQPtQWD0C5FQtbdm8DkEsQ0sPXGtLoxzfCzeCqYstzoCLgsxmEEn75NUte/0Te5ZMEsuKX16NPKm0GrOyeLrU=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4479.namprd12.prod.outlook.com (2603:10b6:806:95::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Fri, 7 Aug
 2020 00:46:23 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c%6]) with mapi id 15.20.3239.023; Fri, 7 Aug 2020
 00:46:23 +0000
Subject: [PATCH v4 00/12] SVM cleanup and INVPCID support for the AMD guests
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     kvm@vger.kernel.org, joro@8bytes.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, tglx@linutronix.de
Date:   Thu, 06 Aug 2020 19:46:20 -0500
Message-ID: <159676101387.12805.18038347880482984693.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0501CA0085.namprd05.prod.outlook.com
 (2603:10b6:803:22::23) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN4PR0501CA0085.namprd05.prod.outlook.com (2603:10b6:803:22::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.6 via Frontend Transport; Fri, 7 Aug 2020 00:46:21 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 73f4e03f-9959-464f-aa1e-08d83a6b4eb7
X-MS-TrafficTypeDiagnostic: SA0PR12MB4479:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4479D3D29ADBCFB11711230495490@SA0PR12MB4479.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3hBuPWcgDKx4nJb3hE01y6u03BMXfVpxGACzpaW5ImjTbHqabdTTTyoZdbhdr5UZ0L7BA9cO/UwuktLt1j/PYcaoYU2SeLZ8NdqTb80/NFCE8VM/QATw/rhBOMyeqSibPYXqR0Y/UwtXHq9sr8/+UQ6bVq6SH1LgryBZgftK2Nz0ZUnPOmEnqtE/A+D0D4g0mnqZeM/kB7uIMsViKI/5caQXY/Rk9GANaIVRyVQLwoxt6ZYx1pg8fkkF481C9cmjv6+A5cJPkh9yfX1wuCarUcq3Hw5Cf9P3dhEqLm00vuTeH0z+GEirkTsG8jDUbTRi+wLVJbB+ujoQPWhTCa9sHmnY8j9pGtr7JzwS9wEstUIMwWQqOeaMctN5o3ajJR4W1/hLP18yCpNruZIuBJqKnA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(7916004)(39860400002)(396003)(376002)(346002)(136003)(366004)(5660300002)(6486002)(52116002)(2906002)(16576012)(4326008)(83380400001)(7416002)(956004)(44832011)(33716001)(26005)(9686003)(8676002)(966005)(66476007)(66556008)(103116003)(66946007)(8936002)(86362001)(16526019)(186003)(478600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: wMIJw4ofRllnmiIXP+Jo3CqITajFeiX6wi4+MtTr2sErmOPs2JVYj1x5KNIDU0afRvqFxTLd7nwLVuMK/oCJN/a4yTafR98mOXf+xEgsLlGK3PfcYcnhO4xXtTe/rBFY9MH++ZO3pzLoLp7FZ1ylhbXqIIj6MrkIt22L+Sk18229cKne+v1Q/d9S+YTzfjaTp7dFbc4otavVKiOjHTWoyvbXu3t2vSukwYToQBPDcgVlsXszjfgLWL49f9/2+Blp0llH2YTWqJ5Tf6iN5LGWuZY4pUII0oTUeQgIZ3O2GdKpXVjR7PIVrt0XbfG3y4CpzjIlrqImNuqfUngOyoYRzirGKlOdqn+1brDwQqjx4kzPqAtnMWGb+lEiLyOZLMuV0QeqpJMt1xnWuHWRzJbr20wpAVawvCNugu8dBKsuAKraYPXfcDyVL87oweA7uT4V/mQUqFLYjd8tNzw3R/m42C0L8i4k8RhlEmG9eVfAJgJToaw4qNd5zoCf+/y6hBMB4Md8v5gUmDExC+5X3sJrMrImdokw6qPz9hZzxJ9Xx7/v9eBQMkA5EJt1IZY4o74J7sE+FhtZwVj3Pkldwr3KpoaSclNbBLU6JibLePANrOqhnaH5NkwcHr1VG49Fp9OB5lpfb0HgjKjxpuJ2hUMbAw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73f4e03f-9959-464f-aa1e-08d83a6b4eb7
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2020 00:46:23.0875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3/ZFI7xZ+YrqEir8Zik72grNSVoDypoV86Hv7/NDra/yytJiv3a+BGX1YIvJPsXY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4479
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
v4:
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
      KVM: SVM: Introduce vmcb_set_intercept, vmcb_clr_intercept and vmcb_is_intercept
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
