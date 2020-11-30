Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B6D2C9291
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 00:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387791AbgK3Xb5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 18:31:57 -0500
Received: from mail-bn8nam11on2043.outbound.protection.outlook.com ([40.107.236.43]:57696
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725933AbgK3Xb4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 18:31:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cWkyfufRgKy85e16iQR6BDNP1thiMcF8uUOaEfhNzPBQb8M1V/tj+VPGmIrULB1LF+FfiNxnr7m+IIHPTvLm4LkKuTPRB8PN6rLss9BNLdrQrNkuQDD3Affmq9zbbqVmONlaV3dDTf8oHogZnzSHvVxlE+OY88HpjnmP0u17HWxjVFlIVQSzjzjMb3VKyf1bX0sW1kmg/VZQIQyztmi3t3TKQrYJA/EqCzsQvQPQ9IeP7QU7tZzHAId9dJizLO65Tt85oHLdfRn0cjBATsPTbjLybC3L7Ddz8zj4pH+1fkDx0tD6tR/Z+h28g+gwFHXbMpVwAxniDh6eWdRyKevIYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GPs10stIlZDQFkdrdo7I/cuF4hbgyuOhSYX1t/LOwxE=;
 b=jF37PxbTrUVkQhF3d2eWeFct7g8MKlbC7lBw4dk1hAAzdIDxu98RcA0MU1oL77l3OTDC7WdDrJigmOdncCVrA/Um2cYzq6nxFmPajucvru7p2f8s6jHo6w86yBbV5wwLS3fideOv9JEf4lgiT7/3SfetnNVz1y/DG45MrnLVQ/wSxctqSjYVXUXpNA++Kz56OxLFxrHfHm/dUfzbzoo9RJtjqyYabBXu/fiEv4dkjF6x1G61Nynr0GrO1UmjMlPTb8jSTAht9dTrCFCfgZe7oXMcW1a5PhSgNhvWtM1dpFF7gq9g9/Ip0rXUrR+xoesLk6FM8KEyk5yBWH3dD2VmNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GPs10stIlZDQFkdrdo7I/cuF4hbgyuOhSYX1t/LOwxE=;
 b=UUcRMSruS6IsSTseeWHA5YBMZEet14AK+XZzoyInAhndIC/GtfP1Uuxr5NA/Vu7W5S8Me6DJ2jBHTYVKIgcx7MdhgnLL+1tQSCEDqNx9SdU8f/eOJeqPFFs31u8r2u4ldjb/gC5aq3kjxNXlp7GAIu0tHexOAFtGQ3otj1kAUp0=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4509.namprd12.prod.outlook.com (2603:10b6:806:9e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Mon, 30 Nov
 2020 23:31:00 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3611.025; Mon, 30 Nov 2020
 23:31:00 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        brijesh.singh@amd.com, dovmurik@linux.vnet.ibm.com, tobin@ibm.com,
        jejb@linux.ibm.com, frankeh@us.ibm.com, dgilbert@redhat.com
Subject: [PATCH 0/9] Add AMD SEV page encryption bitmap support.
Date:   Mon, 30 Nov 2020 23:30:50 +0000
Message-Id: <cover.1606633738.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR13CA0188.namprd13.prod.outlook.com
 (2603:10b6:806:26::13) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA9PR13CA0188.namprd13.prod.outlook.com (2603:10b6:806:26::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.9 via Frontend Transport; Mon, 30 Nov 2020 23:30:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d23fd190-8b85-413f-5716-08d89587fec2
X-MS-TrafficTypeDiagnostic: SA0PR12MB4509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4509865E460EF15EB35AA2038EF50@SA0PR12MB4509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SmIaleHRq16X80Rd8tDeN64/TQXhHogN0c03Alw9orD5ug4g23AKdOpqerroabGclpc8//DxrXjhr3/YuHHvtf5dCJWkQn0NdTr2aIFBNWEFGbUOHWfnlcX4bnLfKxEPKpY69B7RAWhkV6dBYMaxpl1bB2hn1qkxUXsJhB0pNSmlswO8rDbEys52ADRMNW2boUNEuwfGifnRFWF+5tOLiB1eyTQGf4jib0QRBNkEhVTbuCdEP0RXVt+cHaFiHSWq+ftG+B8AZ4+QaQ86JV3jY8qGwu71zehEU9pcj8n9SS0i4ooEx9KXwXlMFJfefFhbO3F5KlGA6ghOshQ4ou+toGjgnRqPZKFSLUaVY3jMANAh+6wcNnDSdDfseYRt5sZZizMOgPQmQepqy4duOjKWpw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(26005)(83380400001)(956004)(5660300002)(16526019)(7416002)(4326008)(86362001)(2616005)(186003)(316002)(966005)(7696005)(6916009)(2906002)(8936002)(6486002)(52116002)(8676002)(66946007)(478600001)(6666004)(66476007)(66556008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ic9Dy2lxaktl5cUl+BAkm4N9Uyu7r/1Y8sutVc7TaCEu7brTl5JO7tm7ZSLNkjOwcsgE+BAW4MpXFhaLJo8duuxuvRZyP5f76xfutIriCY2v3ePc8wo+IWTXXvIxO0aO9oyFqhEBbKa/OAbu462fnEaUp1J+crQK/YXFn6r6exrFeGMadifx03PdgIvBRcPdkCtlFCJ1QpwAUvV3P2d78cOuGQExVc0jIBKQ9fgCXJlkVi7x+tfSuUovJvDLsq2VnJGRraW1k8A01q56JCeZQJCEBuDVVAiPaGijlzVI8kZBlvg51LxTRB/AsiK6I13Y7Wgz+GNht9fapflOigiTxU1aCKJewcu4PVu8L/MyEUaS4fENNOoY/4k6E4ikSDDa0V75Yr9+RaSOntUf3rqc5+tRvBg6zShB8HBSlfzhbUoHFFXzlaxpyKiKzJEbNTuV8pjLOUxMhgLQzE4w7DUyjcDNtiglU384DVl7dlqQUHQcqS7Zd0H4U4ILT/S5lAKuNfWAaofzwa9nO6ieh0acBnfH7oZ6kRTTqjN2+QlDNrrnmaeiNK2+TDD/V0n3klJhXCVzIOQg/gpp9sCxF9oSUQ93DNHQdn826ADP5QolF93RxAYjWBechEQitdUSADPzwMYtPwElFTLyKT3mlWC3faKyxEBYDskHx9A3mRdEs54/2KCcQ46eDN+JyA6SFqkJ0h9Kqibeg3NGhAZL6RNT6AJts0HZaQY0I9VB86LL3iCCF47DvslYfKwmSAPjpRtH
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d23fd190-8b85-413f-5716-08d89587fec2
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2020 23:31:00.2376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o7j3TcUnr0rqmnPewEXIw0V17isJIWj9kxY/5AseSnkMcZtFGU6yOfYakVtY0JS0sV2NId4GglnCsi3rq7T6Cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4509
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

The series add support for AMD SEV page encryption bitmap.

SEV guest VMs have the concept of private and shared memory. Private memory
is encrypted with the guest-specific key, while shared memory may be encrypted
with hypervisor key. The patch series introduces a new hypercall.
The guest OS can use this hypercall to notify the page encryption status.

The patch adds new ioctls KVM_{SET,GET}_PAGE_ENC_BITMAP. The ioctl can be used
by qemu to get the page encryption bitmap. Qemu can consult this bitmap
during guest live migration / page migration and/or guest debugging to know
whether the page is encrypted.

The page encryption bitmap support is required for SEV guest live migration,
guest page migration and guest debugging.

The patch-set also adds support for bypassing unencrypted guest memory
regions for DBG_DECRYPT API calls, guest memory region encryption status
in sev_dbg_decrypt() is now referenced using the page encryption bitmap.

A branch containing these patches is available here:
https://github.com/AMDESE/linux/tree/sev-page-encryption-bitmap-v1

Ashish Kalra (4):
  KVM: SVM: Add support for static allocation of unified Page Encryption
    Bitmap.
  KVM: x86: Mark _bss_decrypted section variables as decrypted in page
    encryption bitmap.
  KVM: x86: Add kexec support for SEV page encryption bitmap.
  KVM: SVM: Bypass DBG_DECRYPT API calls for unecrypted guest memory.

Brijesh Singh (5):
  KVM: x86: Add AMD SEV specific Hypercall3
  KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
  KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP ioctl
  mm: x86: Invoke hypercall when page encryption status is changed.
  KVM: x86: Introduce KVM_SET_PAGE_ENC_BITMAP ioctl

 Documentation/virt/kvm/api.rst        |  71 ++++++
 Documentation/virt/kvm/hypercalls.rst |  15 ++
 arch/x86/include/asm/kvm_host.h       |   7 +
 arch/x86/include/asm/kvm_para.h       |  12 +
 arch/x86/include/asm/mem_encrypt.h    |   4 +
 arch/x86/include/asm/paravirt.h       |  10 +
 arch/x86/include/asm/paravirt_types.h |   2 +
 arch/x86/kernel/kvm.c                 |  28 +++
 arch/x86/kernel/kvmclock.c            |  12 +
 arch/x86/kernel/paravirt.c            |   1 +
 arch/x86/kvm/svm/sev.c                | 319 ++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c                |   5 +
 arch/x86/kvm/svm/svm.h                |   7 +
 arch/x86/kvm/vmx/vmx.c                |   1 +
 arch/x86/kvm/x86.c                    |  35 +++
 arch/x86/mm/mem_encrypt.c             |  63 ++++-
 arch/x86/mm/pat/set_memory.c          |   7 +
 include/uapi/linux/kvm.h              |  13 ++
 include/uapi/linux/kvm_para.h         |   1 +
 19 files changed, 612 insertions(+), 1 deletion(-)

-- 
2.17.1

