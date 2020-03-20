Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0675118D38F
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 17:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbgCTQH1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 12:07:27 -0400
Received: from mail-mw2nam12on2055.outbound.protection.outlook.com ([40.107.244.55]:29205
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726801AbgCTQH1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 12:07:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MsQNDax5xu1dm77EI/fB1uAQwEwFdumaxqyJznNB0V0Kd1Xyf/14YgRxUX9hwEvv+VRfZPnQkKSFkUTJaEDJGWtlTlOQ0+xdV/lmrYa1YNw/KP/s/ig+f+q9Ga3evX/dx7Jxz7ZNYeimneV21yQcLsKVVq67d9c+aLqQZaAzmOSK6IGRZbh/i3JFX1314C7dIh6rCqGge9sZZAF8h9dGrqrJRDpmfktxkrJtR5A5juqMA76ZFrtb9kwcdwUMLTReN9NqKbRWptqcnksEhkzMuF1KzpwOGs+q8Xcrfu0dYBDPAvo6gW/S1lMGg/SO9sV4cO3kHxxpd7bA2WT9F63Klw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jcSUvjmPVj9MOMcNAcCDLYw3mDeUTIfAbz1UKrFI3qA=;
 b=CXUtdFAONT4YDOCnvWspuWBGvJCX1ooK6cg0TZZGlTLAeCEdh6VQbUouPd+jiB1DvylaIDq881tIzile4B6VeLPMVFxLQvWDcCFzJlrryXlfCxpcLLdp69WYRvdhhuh4ynLXtNTBxI6GqlK/vnLJXtL/gDDBBhQxRG+0WhP7MkeyM1ShnUcY+O8vgRfzbUYgJ27f45im+qxOAuoXZSdjIbfp2eNb/Q23TMp6WboO+6Ev3z2rv82eG4bY2quZdjuHWaKQYEnw4U6x88IBQD89VR+544sdh7GGXytgCIrBxKUsOdlQl6Vq0HDGFBtWZd18XPJrdO9MRxi6slIqckmA/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jcSUvjmPVj9MOMcNAcCDLYw3mDeUTIfAbz1UKrFI3qA=;
 b=aFVwLwZL946gHVMubM14TXpiE0auflm190KFCRw7Hq6lXgDzvigS5fV6Ah25I3NBvQ1gWH1wENRphkqac5IxjHgIjuC99ewBUYQTN57Ck9MvqEOPGvuats1Tuil3DtdQC/ropLOM3EH3btTHkSqwsp7EkLwV16IFUXxXiMGvnVQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (2603:10b6:5:15e::26)
 by DM6PR12MB4467.namprd12.prod.outlook.com (2603:10b6:5:2a8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.19; Fri, 20 Mar
 2020 16:07:22 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::f0f9:a88f:f840:2733]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::f0f9:a88f:f840:2733%7]) with mapi id 15.20.2814.025; Fri, 20 Mar 2020
 16:07:22 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH] KVM: SVM: Issue WBINVD after deactivating an SEV guest
Date:   Fri, 20 Mar 2020 11:07:07 -0500
Message-Id: <c8bf9087ca3711c5770bdeaafa3e45b717dc5ef4.1584720426.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: DM6PR14CA0045.namprd14.prod.outlook.com
 (2603:10b6:5:18f::22) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:15e::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM6PR14CA0045.namprd14.prod.outlook.com (2603:10b6:5:18f::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.19 via Frontend Transport; Fri, 20 Mar 2020 16:07:21 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5038347a-264c-4821-946f-08d7cce8c5ad
X-MS-TrafficTypeDiagnostic: DM6PR12MB4467:|DM6PR12MB4467:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB44679A0E04C7E1D40649C7DDECF50@DM6PR12MB4467.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 03484C0ABF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(366004)(39860400002)(136003)(346002)(199004)(956004)(81156014)(16526019)(86362001)(4326008)(8676002)(2906002)(81166006)(186003)(52116002)(26005)(7696005)(6486002)(54906003)(478600001)(8936002)(316002)(2616005)(5660300002)(66946007)(36756003)(66556008)(66476007)(6666004)(136400200001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB4467;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U9TykCzCiLrtdeeZPaZ0/b5Uoq3UmF/uQvCMZ9WWCswDO0hO6UHj/Xt/gYcf+beOsQNnFXb6fVnyx+Y/stw/JwKRkEi2xH9guO2mifnnXjBN0hvA5nzDAOc54rqcY6+nxMO8HTU1PazVafKAvgPnqqw3gLn+H0pH02O0rhoCh6HhJv6uyJm0VJku3JXc5+uipdUznConzXlEEGSBsjdb/FxJXo+oP8dZN3TXNBWapam0hrybawrNjoYA1u/JKknwseTWrY3sLygNsAa5LCMnYe6Vi5j+5e5n9Dev22tjySbsxXcsbZ++wn7g3iU2A0BYRoTqerP9LKrvHGzVgqNISaO9ov1+d5Y2FyiETv0yIoV0I861j/dzUNtE/ywSJL8oU7LbZGrg5jyRzQdK6cjo7KFtTYT8LJGBdnRFfa2Op1sBAdBwx9WgA2TJ+3/JEhOsBG/RIkQ9EDqrFuEg6UeVd7lNNoUEcVS9HDFMVFGA+FdlEySDCKxv0OKJnzKpa1/j
X-MS-Exchange-AntiSpam-MessageData: ndNwna2iAeNBTdImWrM/PBzUDDArBm/RhqgADL7/vAMpnrj6ETEQtOvS3jdFIWDuqW9XB1Nt7EHfxFlXWGRi/smWGlCAnD+vXrDd1qZyx7L0WJT+8bzu/vvr8HO+Cdjxz0tdu+AoZq3vEda8eAol6Q==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5038347a-264c-4821-946f-08d7cce8c5ad
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2020 16:07:21.9939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5eN2YB/iNTM327zoNYjYHXVGywiwZJtow16YYW1PyZHDyNJtvwN6hVURwGEgUSPUVDBhHw2yVgatvSQdJBYuiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4467
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, CLFLUSH is used to flush SEV guest memory before the guest is
terminated (or a memory hotplug region is removed). However, CLFLUSH is
not enough to ensure that SEV guest tagged data is flushed from the cache.

With 33af3a7ef9e6 ("KVM: SVM: Reduce WBINVD/DF_FLUSH invocations"), the
original WBINVD was removed. This then exposed crashes at random times
because of a cache flush race with a page that had both a hypervisor and
a guest tag in the cache.

Restore the WBINVD when destroying an SEV guest and add a WBINVD to the
svm_unregister_enc_region() function to ensure hotplug memory is flushed
when removed. The DF_FLUSH can still be avoided at this point.

Fixes: 33af3a7ef9e6 ("KVM: SVM: Reduce WBINVD/DF_FLUSH invocations")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 08568ae9f7a1..d54cdca9c140 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1980,14 +1980,6 @@ static void sev_clflush_pages(struct page *pages[], unsigned long npages)
 static void __unregister_enc_region_locked(struct kvm *kvm,
 					   struct enc_region *region)
 {
-	/*
-	 * The guest may change the memory encryption attribute from C=0 -> C=1
-	 * or vice versa for this memory range. Lets make sure caches are
-	 * flushed to ensure that guest data gets written into memory with
-	 * correct C-bit.
-	 */
-	sev_clflush_pages(region->pages, region->npages);
-
 	sev_unpin_memory(kvm, region->pages, region->npages);
 	list_del(&region->list);
 	kfree(region);
@@ -2004,6 +1996,13 @@ static void sev_vm_destroy(struct kvm *kvm)
 
 	mutex_lock(&kvm->lock);
 
+	/*
+	 * Ensure that all guest tagged cache entries are flushed before
+	 * releasing the pages back to the system for use. CLFLUSH will
+	 * not do this, so issue a WBINVD.
+	 */
+	wbinvd_on_all_cpus();
+
 	/*
 	 * if userspace was terminated before unregistering the memory regions
 	 * then lets unpin all the registered memory.
@@ -7247,6 +7246,13 @@ static int svm_unregister_enc_region(struct kvm *kvm,
 		goto failed;
 	}
 
+	/*
+	 * Ensure that all guest tagged cache entries are flushed before
+	 * releasing the pages back to the system for use. CLFLUSH will
+	 * not do this, so issue a WBINVD.
+	 */
+	wbinvd_on_all_cpus();
+
 	__unregister_enc_region_locked(kvm, region);
 
 	mutex_unlock(&kvm->lock);
-- 
2.17.1

