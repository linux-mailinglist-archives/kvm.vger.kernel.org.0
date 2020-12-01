Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1153C2C942E
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 01:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730801AbgLAAqX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 19:46:23 -0500
Received: from mail-bn8nam11on2085.outbound.protection.outlook.com ([40.107.236.85]:46025
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726316AbgLAAqW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 19:46:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PlObJkakEgRwY0TKc28IF1rPQCuecymDRlF7wYO5PSoFSrSXZuo9zIsU2OtVB44Qt6IV4qRh0SgZhwwCrKgT+r98qNPDz0giH/DQ0nVwYo5WzbUia48wzvEDZxx7q4Twn55h3z0U3Iu+Mc+det+0GQUgO0+GcxG+b/GFhkYtFY51XZkvt/4HM60b3FIbG0cJQUKjQ27Wt9x49KjyjRW40y7eaYVRjFqkAFUFm1Ks2a08GDig//1gfUVO6N46F+SRjQE2Y2UfpJJPFlJnwB5SUBi3hfqzq/WfKXVvMN227rd4DnkNFFBFLZn0IsYqyFjnHrHBosvEF38m39LPdw7nSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4lfoO3QA7skrQsdPAxz4gzne8UEC0DsVrNta4uQtUUg=;
 b=g3z5u2UTOsNEEmQ/Tnp47o5IKvBy5ELhMKaP7b16tk5+uOXKAnHw/IJhoIIJRerFLv48MUWyGF6x7cTrUIMXlVvc1+DdQLGbu3rZ9gdOfSGicP5SRJLCG1FCk98+AbP5dUOpTxBSsf7Rp2KVoyoomW5PTLfaK61IIw9onM2esivlefl56DGHokiIVyOB0VNWqlSfSDX6yDfYAvC5DWS98hMloiGEi8o0XAXqI4Ed8iKr+IO9n0Rts89diG4AoUgfZWF79jMVkEajXg5NjmTHEy7yxq3vnFvGCG1rdlW9RnAEmFfsOqb+UuM05rgfpnxdTBLOrdYbb0MYD1O+8i3U8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4lfoO3QA7skrQsdPAxz4gzne8UEC0DsVrNta4uQtUUg=;
 b=SUh+b2753uqOiYYjmNSCHMJUOCbmJtVZaRTPIbg/HjMZZJa3wceNZwLXZoxaqfGD5b8zXj/8BWYm9BKBgayEj5nCmwtknmkbLhpTMpQLE2j1mUT9duGX10bs0aUvFLVIvy278e5jjra1Q+ZOjpvP03ws8SOGvDF2zaqLf0YXe5A=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2832.namprd12.prod.outlook.com (2603:10b6:805:eb::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Tue, 1 Dec
 2020 00:45:28 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3611.025; Tue, 1 Dec 2020
 00:45:28 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, brijesh.singh@amd.com,
        dovmurik@linux.vnet.ibm.com, tobin@ibm.com, jejb@linux.ibm.com,
        frankeh@us.ibm.com, dgilbert@redhat.com
Subject: [PATCH v2 0/9] Add AMD SEV page encryption bitmap support.
Date:   Tue,  1 Dec 2020 00:45:16 +0000
Message-Id: <cover.1606782580.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR12CA0017.namprd12.prod.outlook.com (2603:10b6:4:1::27)
 To SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM5PR12CA0017.namprd12.prod.outlook.com (2603:10b6:4:1::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Tue, 1 Dec 2020 00:45:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b8922b2f-3dbf-4c88-0e69-08d895926626
X-MS-TrafficTypeDiagnostic: SN6PR12MB2832:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB28323E26652BD6F180E3E4938EF40@SN6PR12MB2832.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cfqcIhO6Iv6ZOYTKDoY9wLM4YU3Pd7JXwmpk40XGhNOn4gZqzrHK1gHgN44zo2dMJ7jlJh4Zg0Pn2dV6yHxfSHdkexfK7Wl32nXgSQmo4d4rThkSMoyCjKKdUkwq+NmTewedLV0sxBMvDHTVyDm5hUKd2p57XDPxTtMoDw+T+9OhyXAhLI3oWet6yHsq8cO8QjRv7IqrNY3oE1KVrYxA9pYdBvLQ+1cj6WzcgMJaKJjmkv5dtaUMeK4f8yElv0VPtmoTrDdGtmal0xN4ojIYk9CDIcMgaV+sav2EIgA6kp4hAI7PECOnpdHxT0sI/wkmx2iS4ajiiTdEEWnbn932ZGfcUFXhWcms/y8TyaDojqjCslYl3zbAG9DhnJ6Qbl/JOQrMa6eHf5C2Is9F998AOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(396003)(136003)(39860400002)(7416002)(16526019)(66946007)(6666004)(83380400001)(26005)(966005)(2906002)(66476007)(186003)(956004)(2616005)(316002)(7696005)(36756003)(52116002)(86362001)(4326008)(478600001)(6486002)(6916009)(5660300002)(8676002)(8936002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YkZxZGlnUDRDa3lvWGc1bVk0Z2haaVM0S1NqVkpOUS9MRk5MSXU1T2kvL1o5?=
 =?utf-8?B?WUlTNjN4cUtLYlFvSE91SC90d254Uyt1NnRXZ0ErRHJmSksvbEtHSVFkWTU3?=
 =?utf-8?B?RURKWWdTRHJaNldZZ3Vlb1NQS0xoTlFHTFk5bndLMEt2aXhqQzlhaGpiQVVT?=
 =?utf-8?B?eGNObHFsOXRqa1RqSE5FK0xaQUJnemtUaUkxdkFmdEVSMTNHYzN1ZnE4OFFS?=
 =?utf-8?B?VDRXTkdoMzY2ZDNvODVLaDgxYnliYWI4OWN5eG9RcTNwbGVDcTVaMDJmbWNJ?=
 =?utf-8?B?UjJsRzdUUXNBcnJjQVhTWlp1UDd4ZjN5dUlsenQ3aVBxVEVEV29KK2JZVE9a?=
 =?utf-8?B?Y2NPMmxiVFQ3R2NVVDJxVnplbGwrR2YwV0VpdVNMdlp3azRGTEVTV3g2SDJO?=
 =?utf-8?B?OFVsQ3hqYm1pRGtIMzZ4eUpYbjRaSzlaT05IZ1BIVmx3eDNHY1hTZitFbzVl?=
 =?utf-8?B?V0liZjhiSVcwSlArOHpTUUh2VnRweUEvK2g0QmVqdEV3NlhQcGlLcEV0VFND?=
 =?utf-8?B?NlhSUDhUS1pDRVloYm9KVFJKZWI4cVJjdzdkVk4yeG9kemFsZUIva0l5NVFG?=
 =?utf-8?B?cXpJOGdNMjFPMGFoOFVSVkFNenlnM1dTV0NWTzZPdjJ1MUJNSWRjdlZ3eVc2?=
 =?utf-8?B?QXJnak9hL0R1cWVTVk8rVFdYYytjVTMrY2xTSHpuTFlkQlcyRWZsT2VIcjFZ?=
 =?utf-8?B?WnNhY0N0TWNWQ0lPUnFSQ2FveWx6Q0FURzhYdWduS29rWnkxKzNEeTBXZEpx?=
 =?utf-8?B?dWdOT1lSM0VPUm1aY1VuM01CdTN5UE4wTjN3NGYwNkVqMEc4b09qOW9iaWxV?=
 =?utf-8?B?Nk4zWlgzQis2RHp2Z3M3ZUtCSHJDc3FZcms1V2lVWm5QY1J3ekZ1NTF1Qkox?=
 =?utf-8?B?NnpzRjdTYy9CUGM3ZWlUUUpVKzhDN3VOYlZnUDk1dnU3QXFTT05sUHVsTE1J?=
 =?utf-8?B?WlZWYkFab1JJbi9kQjY1dFVhSnN4ZFlodmpDUVBWVE9uQTNmTk5qY1RTaGFY?=
 =?utf-8?B?dDdHekdvR0xseWRpY3FxZmE2QlYzNjFLbno2aXpuWDdnbEcxaFNMWnpOUC9u?=
 =?utf-8?B?akhIWm9reFV0ZXpTUUZ5UzQ0TXV5eFVFTmlvRk1kekJSWHI5N1BHeTNQOUN6?=
 =?utf-8?B?a0t5VUxnSjVDYTk1VVk3c0NNc2pLZkJHdFF2SzRSWC9WMGx1U0NLZEliZjBM?=
 =?utf-8?B?MjYvWTRsL3lYV0ptK1dtbndZY210dCs4NHpyaUpLLzBHTUZPNTZZY3Y0RnhI?=
 =?utf-8?B?cUFXMEF0WGw3VXRqVlpoOGpRaVMzZUVpVXZONCtPMnRhR3lFUzQ3dS92T01D?=
 =?utf-8?Q?IrISHG/VGZpyi27i0tM3sfJL0RbqVfZGFA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8922b2f-3dbf-4c88-0e69-08d895926626
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2020 00:45:28.6428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6i/d2kZfCmOWYz0dfuTbechz9FwpLMdYqAhfp8Yj9R92bLc/SEAY++lx27AmIogotOx8xE7udo2xAByxIZjCew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2832
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
https://github.com/AMDESE/linux/tree/sev-page-encryption-bitmap-v2

Changes since v1:
 - Fix in sev_dbg_crypt() to release RCU read lock if hva_to_gfn() fails
   when bypassing DBG_DECRYPT API calls for unencrypted guest memory.
 - Comment fix for Patch 7/9. 

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
 arch/x86/kvm/svm/sev.c                | 321 ++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c                |   5 +
 arch/x86/kvm/svm/svm.h                |   7 +
 arch/x86/kvm/vmx/vmx.c                |   1 +
 arch/x86/kvm/x86.c                    |  35 +++
 arch/x86/mm/mem_encrypt.c             |  63 ++++-
 arch/x86/mm/pat/set_memory.c          |   7 +
 include/uapi/linux/kvm.h              |  13 ++
 include/uapi/linux/kvm_para.h         |   1 +
 19 files changed, 614 insertions(+), 1 deletion(-)

-- 
2.17.1

