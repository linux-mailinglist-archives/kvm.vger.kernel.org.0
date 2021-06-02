Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9D5E398C53
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 16:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbhFBORe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 10:17:34 -0400
Received: from mail-bn8nam12on2053.outbound.protection.outlook.com ([40.107.237.53]:10945
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231906AbhFBOPa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 10:15:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NL5ebzugTnu1zo5h4aZi6PAuNEWELYbz2g/2SQYVOrk7SSR5JI0RBPoKcQmDdL0mfmTEVzL6nlEm3Slp/eq1PX48bKnvYZgeza7Mprjtn5HE+mFqUV1IQTAl+i8gVYG4qp63eYRG1f6bIVFnn2VdQA2cT7VQhFkFAC6owioyr4o0APphbQYudJwM9ICDhrk0IXM++EwEjEEUwPnUIc3+N/284tKR10an6LIO/Ko2auMZb0GbjCeGJY/ZNxVEPdJt29ovrYVtlBQx9wLVrtUhqt5/S3MSP46H5MR6ZTUn6fg8L4aAr+LTbJJ8HijBNPCSrybaCjeQ373wRTVS451gcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=amc345V0ABYnWmTuzWs5XId5+/6yv4cUgrvfJJyi0mk=;
 b=kzxKmexNo/NYdQ130Z4WZNUbKd7Kl3vrpEyUqSkQJiVEbGITy+pkyNzsA0qn1JDi2sSravUDp3dazf+ODlnSbw+dOIRKrz4NRhx+yveTCP2aj/pZo+BamzkTAb3Rn13aCMmJxWKF/uHnx9Oyc3DY5DT5UaXVftvwI77BJPgEtUHobl5l4a4TDAtnbUb7tjC2R+4NGCEIgHbxG/sxM0n3jgTB+YqCDtGzMKSIvnIkL7/o0vhpUi2FgHIYP0yDKZMcHHVQcTZ7bNLrCXmSak3Rgvfa+ZWhWethqkTmibO+o6ysapLVIy9G8B1Klq/+fuikNz1PUpdOyrO4QglSoKmklQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=amc345V0ABYnWmTuzWs5XId5+/6yv4cUgrvfJJyi0mk=;
 b=aaWDW4R1GPn46l0IHHVVXwMAX15jBo80y2X30dOEmgArgyikU0iTLmFTLMl1FsL8W55xbipYeIclGsb+Tl9kW9BXTly5suQMggWKgBzqd95yRq9xjc7iglL7ILyWfdHg9KgK02STvNffkndsAmhBZSyd1hM0oFMdjrDhMXY7dLs=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4574.namprd12.prod.outlook.com (2603:10b6:806:94::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 2 Jun
 2021 14:12:39 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 14:12:39 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>, tony.luck@intel.com,
        npmccallum@redhat.com, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v3 33/37] KVM: X86: Export the kvm_zap_gfn_range() for the SNP use
Date:   Wed,  2 Jun 2021 09:10:53 -0500
Message-Id: <20210602141057.27107-34-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210602141057.27107-1-brijesh.singh@amd.com>
References: <20210602141057.27107-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0056.namprd11.prod.outlook.com
 (2603:10b6:806:d0::31) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0056.namprd11.prod.outlook.com (2603:10b6:806:d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 14:12:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 809a9246-b86a-4dbf-295d-08d925d069ee
X-MS-TrafficTypeDiagnostic: SA0PR12MB4574:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4574984843BFE85206162141E53D9@SA0PR12MB4574.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UEbKIGTWZvDIY4UrzbuASNP51O3jU5QlTTAAdKyHKTTZoVU5wMqsfE1AfPi94hXgcuR0+9gtfAPREExC63Tx9mRZ6qjF9qcOjVVR2WgZE7wUPWsNIATkwQ6yhZuCvYvQ6k30ueNAx5lqbDul8Mf2GZ6miwHpjl/FLhAWrO/EZDmgh+I+HwZX15k3ju2p9KYnLDABfAN2nTgOuLQOdhlQr+4iT/cAfnbSv6qZTBNOVyyZtSmVFmGIJa3PZ4EG2DQS1euitDiOeZinvwb+Huchb6tqMoPzouh9wqvY46IQkO06dStK5xacE1glsnrq0K3Enf1PTKGa8JyUODWYTOGOF29y0hBBvUbDerCFXBEEXqv0C6AJLeh1rSuzBmsqRgExYEq+cksiEMAeuUCSRuMmueQCq8GA7uhYvrt9ZC4QVjXgfL/64V07iOiX+7eCKoyA8fPgnwIs17Xcsy+jqzHkcz0LzbCtIDhAHb6tGgIw+08C2nRgo27P/xW8PPtSX4x1VybeW9x8OjBWjan/wvcox+RcIWCNSFxMXO+NAqEygYtCxJF1SC10z4PqlGP/mEDnuL2eCeleVq8uDklaepQuCDAubD9OCa00H0nKYvym5KalAxcMUqYIPSpH80aVS1ShIF525JHID+qRvBRwYq7JyQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(86362001)(8936002)(7696005)(52116002)(956004)(478600001)(2616005)(66476007)(66946007)(2906002)(26005)(186003)(16526019)(7416002)(4326008)(1076003)(316002)(6666004)(38100700002)(38350700002)(66556008)(44832011)(83380400001)(8676002)(5660300002)(6486002)(54906003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?bstt14rqnUMAcyEdFCScnwLh+Moxevg6CBWKOAXmuxkdDOjb8lTvfr4qLWep?=
 =?us-ascii?Q?coyTvBkKAGs9/c0FG7CElslRtI4c7UZWPu4kQh/S89bRcfui9eZ1PGSVTO8G?=
 =?us-ascii?Q?WP+zK0xEVkl3Yoni45e1I3/5UwwEtl8beyYUxxVtv4pWTT+IlCoftqDLrcV6?=
 =?us-ascii?Q?dyKTrE1XD5HatN1gpTbBNPrdCeFvOEnLt1947jHcKcTqcxaH+UaXbNQx/DJ0?=
 =?us-ascii?Q?+Yl58S6vgCBNL5LBEPPIsiQ6velkHQbY+CHoXZgMj8EQK9s7bu5v4lKcU38k?=
 =?us-ascii?Q?3fo0I0DEGHDv197sqd47Sa3azG+CLdgDZieWzpPIyjxeRFLonC2kC8cPqynF?=
 =?us-ascii?Q?VSNJlfR4W9R8A9Jk5mFDeor6zP1fdZsc3/qYcgIGucm6YRvelCa8fLxXianq?=
 =?us-ascii?Q?dbNgjA3Sc/CtRO8ydGAVLYOCchmioy4ofH01XM4J0H9b2r6U30+FFeLQ2A5V?=
 =?us-ascii?Q?Q5/g8jw6RYyZzW9aiVomvOlmvxznzniz7WksOqLmBnGN73lDEVr4FCxU2s/e?=
 =?us-ascii?Q?+DIth89Iv/oe8Iih2Gb+kZmmY5WEt/YwCdZfVSx1U06xOd2cqJgjUMffZqWP?=
 =?us-ascii?Q?wSyG+r0IU4C3j6HSpxa0wwrB0DsMloN8hLlu2lPVuoKIaokMuvlQx5ZFng8a?=
 =?us-ascii?Q?nkYOFZRi4cHwmrf20nNH1mF0v1BJ2rHJBXhW4cS2ao7QZH5CbdddDQjYAaEa?=
 =?us-ascii?Q?phszoodliiNP8aWpsMAwieB3NBs/ge89MLTQiLrvEeheykbuAAl8hJsMUHU5?=
 =?us-ascii?Q?RtWxakbi9mA86WDFFYqrVofGoeMjlXLp9fXEjjo536gEVVskZX/2xy5McESM?=
 =?us-ascii?Q?uQW2mvC0Bq9+0AVoxVeJo0Kr03A0lYp74kc2wWXsrUigzwNrO6KuAAVNx0Ik?=
 =?us-ascii?Q?vcWwdT46wEIz6fux6HH9OmmSMiPNJoMcpN2a1/aPzmFS/MIQel4iC0LXcXU6?=
 =?us-ascii?Q?riYKGLSpnhgGEBxkfxyKsKvat6o9KowCYeJhjT3nEKAMnNPygObM/JqMxEAa?=
 =?us-ascii?Q?mJBKnsM4JrUxRLZ2kM7mXDZL44gLDO8ckZ3LnmDpnP6N7KAL9a0CV+eZinwt?=
 =?us-ascii?Q?kk1MydNODQlW5wSyDkX+8ds1oXWRRatxAoQgiLjkuxn2LNFDJ9fgOPoVJhde?=
 =?us-ascii?Q?qX0/beoQDy+Sm5OMMwUvzmLSLt9bastWcxMfrpQ0QtQSP+cRU4M7kj2Dvk6d?=
 =?us-ascii?Q?Dc94Bm02mrH7t1TT772NozMPvSryngbbyQ6umMQRgn6YTk+9xzfz8bjNn4fR?=
 =?us-ascii?Q?Lj8Mb97uJ9ASjUOkUFYvqYrhrRnZgBGEc6KspSaMQgzJjqzqJLCi4UUtQ5ye?=
 =?us-ascii?Q?FfTMkqD8JeyQhVXr0vpH0wlH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 809a9246-b86a-4dbf-295d-08d925d069ee
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 14:12:11.6073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vmBKTPoW/KyDJwI3VH6Udw3D/ipsW4FRm0eFjZBkXybxm7XbxhpYEASvHDJN4FS9RnEZRijcdJ6LD00YXeJF+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4574
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While resolving the RMP page fault, we may run into cases where the page
level between the RMP entry and TDP does not match and the 2M RMP entry
must be split into 4K RMP entries. Or a 2M TDP page need to be broken
into multiple of 4K pages.

To keep the RMP and TDP page level in sync, we will zap the gfn range
after splitting the pages in the RMP entry. The zap should force the
TDP to gets rebuilt with the new page level.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/kvm/mmu.h              | 2 --
 arch/x86/kvm/mmu/mmu.c          | 1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 678992e9966a..46323af09995 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1490,6 +1490,8 @@ void kvm_mmu_zap_all(struct kvm *kvm);
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen);
 unsigned long kvm_mmu_calculate_default_mmu_pages(struct kvm *kvm);
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long kvm_nr_mmu_pages);
+void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
+
 
 int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3);
 bool pdptrs_changed(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 147e76ab1536..eec62011bb2e 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -228,8 +228,6 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	return -(u32)fault & errcode;
 }
 
-void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
-
 int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
 
 int kvm_mmu_post_init_vm(struct kvm *kvm);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4abc0dc49d55..e60f54455cdc 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5657,6 +5657,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 
 	return need_tlb_flush;
 }
+EXPORT_SYMBOL_GPL(kvm_zap_gfn_range);
 
 void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				   const struct kvm_memory_slot *memslot)
-- 
2.17.1

