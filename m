Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63B23F30E9
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233351AbhHTQFV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:05:21 -0400
Received: from mail-bn8nam12on2046.outbound.protection.outlook.com ([40.107.237.46]:12057
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235123AbhHTQDU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:03:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=diXJCqWeYf6JU6CrVUB8n4de1eJtdzec1MOvIZk3LhnDt5HaZ+A9ow2Ov18UkNjIt2uOycc9nh56ioIHJqm2JDGJgV1YIdcYtAxPLtJThSu/GD8V1NUgjXKBK2UwNXbt5OgUbBAq+xM+fDuc3caZMspTufaTqJHEQeKLDnX0t0qd6kMsCdYRSMCXOlOe8awsI0NuAHCavANG0ATyePJEJW2XNUTRSfRQFAQ2sJZCsEHHOU4akXU/hPNIen62vJE+EI9Me090qJbJ4KLR3mXmAskGhRztl3cVO/O9JcuPsscZ+oMt93wa3mAHn1ZNuGA9w/zYj/M1h3Y9dA3r7dZwXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FToI2YrXRrehyRiPEdYSZHUhoues+OdXNzpg7Ok4jrc=;
 b=FlRabT9Bu9fDrxRIbBnL7zYoszeOmhHvv4ZcZOxWxvNVgh5mG9KSkalnK8SwNPvjnVQ8uDlWA1fJE78lLaBhJz8EVQ7rHdGI4zjTdNH+1LTblc6AG8KOTW1B8/WhRZQupXnyCqaO8lRskKv2xOa2slgXFdCEx+WaJzTBpWB06lW2cGqxd0fJwduhKgk9mvYpH6z1kacoLgIAnCp7ZMwd19o22brVE7XQbwo2JZ0iWfGmSQvmU1ZoLhuYM7PKGqdGwAYUfk7J0Bqx2eqSXMuMz1EBZIdejuv8UAzLm7vvOmPEQjzuRfREWP6wKC8JZI7veuY17akgFAkfMnXz+dV4Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FToI2YrXRrehyRiPEdYSZHUhoues+OdXNzpg7Ok4jrc=;
 b=NOlmfZ0uv9xSPFw8gLmpvpVL9EKtG1xrN2ZE8sLohE/gQJoOTzUJpjXRsHqpI6vkpjJQOQj7jF4etjS4w45uQ4uQdzo+vzHlx91RcbYuk2ZaSV6xGPgLasm/EWeUP7brza7DWjtVJtuzYfmjlFzcta0SMw0LnvSy1azxbDhCa/0=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4509.namprd12.prod.outlook.com (2603:10b6:806:9e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 16:01:09 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 16:01:09 +0000
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
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 v5 40/45] KVM: x86: Export the kvm_zap_gfn_range() for the SNP use
Date:   Fri, 20 Aug 2021 10:59:13 -0500
Message-Id: <20210820155918.7518-41-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 16:00:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d91976f-9d26-412c-7ee1-08d963f3ab1e
X-MS-TrafficTypeDiagnostic: SA0PR12MB4509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45096C2F515C36F9BE32EF12E5C19@SA0PR12MB4509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yt0Cwl9qoESg5yBc37cTqii/arJMEH3ZDkQt17und2KHZFV0y5X0eGG1WiWLUGlYEyDcLk4k9UkXpz8rO3Vq6k7kxQ4aTZoMw704YD2zZdB7578I4rN+RN0Q4WEtBIs7O/o4+kHiTAvhHlpbD3nx2J3Ef3nqRKbJCJRPqC1rw3G8OD8zcET4hcCC2Kjc8W0l3t2MiizzlgHk5gzFQQYx5y1tb1GnnNH6VhdsyMr65FPmzWLqPMp7qST0fyjKpoipWDmHgOIQXTx8zjIzVPX5b5xBQDD/0Rx5izVg/VvHPhLZbvD7/Qpfz2mHvdFAizOxiArisVfGC+d7uxsTIGliQcbLEkRMYxxMwPM6M9Q4r2it+VAswEMGThiZbQVJ3Xf4u3zYJEnRzz4Nwqu/0c/39fefijKCUv9TgJjhgZwWK8JK6MrbK/htrBKYsYvUiyEj5r95Sw62aiAjdozqlh5b3gcIMwL4ho/9N4xMe5jq+P4gpLwHwOLd4DXiHfGy5NiacPDETDrjqjOuMUYzCC923t4iAJt7ofFBU/2U2aD1578l2mU+9dU0khx+J3Zmqv3rXEyoSPOTsKUNAPOM1JP9G69zmcW/ph6Noao9vSKelkTAUibk04tYLXZdkQb7kio2+eiGDkRelAYmnMg9HUCIeIiXlDaKYBAW829KxUQx0UIZFe0mnAPhYYKivhuvm4q7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(4326008)(36756003)(7416002)(44832011)(54906003)(316002)(66946007)(66556008)(66476007)(86362001)(7406005)(956004)(6486002)(2616005)(2906002)(83380400001)(38350700002)(38100700002)(186003)(5660300002)(8936002)(52116002)(1076003)(7696005)(8676002)(26005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9Nk3IgFQoM+gLCTEJzmI5sH9N1lVHBw2VmzYOvwcireX2eGCT96Gtwht5HOH?=
 =?us-ascii?Q?Q0pE91u5QaiDl8RlzFXhRodzBZbVoriwFhXwACZmT5M57kk9iwhgtfduYWI3?=
 =?us-ascii?Q?0vQlvtc11/kC/j5gaX+436waDotoXSFxd1YuvRKB6jRNbCoUXq6G5jXzhCnP?=
 =?us-ascii?Q?yQaGXl9Aw+v7rGb0OmvM6xIFrY/xOx7zhNwFr+FoW9frPuHlUrFyCl7eJwTD?=
 =?us-ascii?Q?JsCqAV8cG+wVKMeQaTUIVZ5BUMqnZ7V4I9FLOnY1rlohRz4cpW+G5kDX3ryA?=
 =?us-ascii?Q?pdD3AjzObgkR4fsGczbaIWczGLc+O6H8zekfB43jiF9ZeqTOi7TPN2EuqG5h?=
 =?us-ascii?Q?LQbzNYiJnrY6Bn8Kvpb7BzKOZJONgYD7S9NklG6r4JUJZCkw5ng3AxwC2UZp?=
 =?us-ascii?Q?5L/ecl3cmsIoaciXYfmTaNUOnkOwMD+9mItBZo3A/K4XLv7T/HY9yfOED7uB?=
 =?us-ascii?Q?pedItCwWwUQY45eIUFdNKGeaDXaJEM1uuAulQnzdRfPaZfF4zANWwIAwyRY+?=
 =?us-ascii?Q?hu2TwmYJ7w6kZoL9cSlyLw4ukHmUR+GIJmy7oQ05W2WmC8CG25JWUCt6uH7b?=
 =?us-ascii?Q?TDGBLqQzLS4M4plDR1fl9iMe15SvS2gvIPEESNUUrG4A/K31g80Jmk9A6OMC?=
 =?us-ascii?Q?p3t1+FCGLg2eEUUstrqEpNFefEtRCPwW/YCEl9ZI7ZRiCO2wTa+Z6YFwHvwZ?=
 =?us-ascii?Q?P4ixTVFIskwju4Om0bganUDpGcOXoue3k0eKbPxGsOoCU1ZiFXvlRc5ZKpSN?=
 =?us-ascii?Q?h2BGf7kTcgwcijsdRBU+WSnrmyZ9zaZxL/U2LCsTxeNa9uQVbLWOgKvJmw/T?=
 =?us-ascii?Q?emibU4EMESfVmuGQNQSKp1UcIWHi1Ikf9AvcwiHoZILajiDfPFQDgZHk25Wm?=
 =?us-ascii?Q?LsjorkQbONkmkna2IFqUjkpP089pi9UJYugCJoZPL8VeCFZWG/tRXOEg6VVT?=
 =?us-ascii?Q?M/1o6Y0TIi/Lw74S+c8/aQjWe57AtLkuMk6XL7EuDzoAGmZo2sIQTb+vS02j?=
 =?us-ascii?Q?BROuQ7jLwZ2UA+ORX1yeeTORxd1FiuKsWdcpH4BPEYGQLO3AubJBvZZwjSGf?=
 =?us-ascii?Q?+Z7BtkQkcV5OjJn1HcX7D6txTiPbDzToTlr6eyPybIXpNAn1EGWzb9wNjBNH?=
 =?us-ascii?Q?oyhtshUENB1Kxo5NOFw2I8U0++O+sEiAsaF9+eGbQyH0qdcqbDPsDndxxe0K?=
 =?us-ascii?Q?4W9lu6OL3bzv3kWCgzBj9Y/beV4PReVW6Vm0DwgyN+VrI7LiN5XQXMraf09C?=
 =?us-ascii?Q?hYRYuqzTrXsSkCaFzvowXMuUcJcd/6eTFo4uerigSZwd3TP2JH41jF+Cm5TZ?=
 =?us-ascii?Q?TCRhijE33kMPvCrTLrQhU0uq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d91976f-9d26-412c-7ee1-08d963f3ab1e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:45.0789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HPtRTYy3pv+LMFUQXqA/ILyuKmc8QzAbLrv2wP5rziatRIYtOMlnAq/z4yS+hUb0uFyuaw+RePCIrTMf6Vi0JQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4509
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
index 5ac1ff097e8c..8773c1f9e45e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1561,6 +1561,8 @@ void kvm_mmu_zap_all(struct kvm *kvm);
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen);
 unsigned long kvm_mmu_calculate_default_mmu_pages(struct kvm *kvm);
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long kvm_nr_mmu_pages);
+void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
+
 
 int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3);
 
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 7c4fac53183d..f767a52f9178 100644
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
index e660d832e235..56a7da49092d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5748,6 +5748,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 
 	return need_tlb_flush;
 }
+EXPORT_SYMBOL_GPL(kvm_zap_gfn_range);
 
 void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				   const struct kvm_memory_slot *memslot)
-- 
2.17.1

