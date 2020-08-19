Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2B4524A2A3
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 17:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgHSPRk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 11:17:40 -0400
Received: from mail-bn7nam10on2044.outbound.protection.outlook.com ([40.107.92.44]:48186
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726894AbgHSPRT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 11:17:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SgYvMlTpXo3Zdt7iH1O78yenxFhS40Yr6XOLsU/wmgXPZhUGu6BCYYX2C6JWrblPxBuLMX7TnowC6V/CYVWE+1q98PXkv2mP9nsZYL5yPiokw8zvP+zMACD8lDk8L5Z2gtZQHWlwDeTajb5kdm0QqPBluBGsg5KKRlv7N+8HFPcgdaGO9UI77BExQyAnkfN64Du1rYcEbbwRn626sc9j5L6zR6io76HqRqooUxfRgd4BNnUTMDNzrs6mZZDkVWxz7cF50WvNKuSYgUvxfjfaT9V74xP73zP1iwS/bKMWc+pLgf8bW0qJnH/tY0Ghuwj3o2s4PXpY/G6AziI5rD0KRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZFKwKTr1cZPT09GMIL93Z0ukKNniqRmLsiDSLh8BJ/E=;
 b=j8/GZrJbo/OMSmlXAoNJB7ascSPiiU2eISXbRBEv9e+SmFc+5hRLahWzbcNF/JwJoJ+P9j1xLII1r+PrfBD5copIFbqx1TFo11yM/auNdbJOpoOACYki3YX5EqnN0/QUvQ0RQ4AH6ALm0JXmTtRQcJUJJgffTtXJ1TlTkh9MAYFhE3032QSaOtU5vUhQyIuO1aq2o+GZqmNnZnDMvweDXwlI8/9nLV+JRZpdkRoHqQb5pL0LMLuDKBJxDEW2rYtGWncW5soJg4psX6bQ6zkScdJBQjstLW9/jrrnisAZWwK0NpPxHRy0QZjPoHH75Bb5pHPDlyHt/gCNFt0kMnxaMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZFKwKTr1cZPT09GMIL93Z0ukKNniqRmLsiDSLh8BJ/E=;
 b=nZ1Pz+3w7nDXBzltJhgKwwVNY5A5B11dv3xfjQVyYQndmS/XyfklxnjLNz7zhBBEe2+8eLaWjYRMgT5b+PF0vphtxQ0Arg2mJLt+ZhqBHJScG17ot93ZqymZT4a0kqtAfsi/c8ySSflUJS/gY+T7susFAwmNCY8bqSAoQYgnBrg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 DM6PR12MB3227.namprd12.prod.outlook.com (2603:10b6:5:18d::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3305.24; Wed, 19 Aug 2020 15:16:59 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::15d7:c2da:d92a:2162]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::15d7:c2da:d92a:2162%11]) with mapi id 15.20.3283.028; Wed, 19 Aug
 2020 15:16:58 +0000
From:   eric van tassell <Eric.VanTassell@amd.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bp@alien8.de, hpa@zytor.com,
        mingo@redhat.com, jmattson@google.com, joro@8bytes.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org, rientjes@google.com, junaids@google.com,
        evantass@amd.com
Subject: [Patch v2 2/4] KVM:SVM: Implement pin_page support
Date:   Wed, 19 Aug 2020 10:17:40 -0500
Message-Id: <20200819151742.7892-3-Eric.VanTassell@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200819151742.7892-1-Eric.VanTassell@amd.com>
References: <20200819151742.7892-1-Eric.VanTassell@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: DM5PR19CA0045.namprd19.prod.outlook.com
 (2603:10b6:3:9a::31) To DM5PR12MB1307.namprd12.prod.outlook.com
 (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from evt-speedway-83bc.amd.com (165.204.78.2) by DM5PR19CA0045.namprd19.prod.outlook.com (2603:10b6:3:9a::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Wed, 19 Aug 2020 15:16:57 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5f22a8c5-2942-4058-8f9f-08d84452ea8d
X-MS-TrafficTypeDiagnostic: DM6PR12MB3227:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB322759B0E2A793F37EF0D787E75D0@DM6PR12MB3227.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vIb8Icni/FRFt12bcktDjauqC49muDWQPioTm3NeegfspZFMY+VEoYT85JLOuGi2F/BE1LUwmloz3qETubfyu3B1vpXm5sxri6F9tJlJmC6aqcRlcjfH2VIau4zD20bIoFplND53lRmwVfhxrZBEzhFcktzQswYhfLo/oZIX+gxrQgZxqezW8vu8UUF5wQ1jCyHNLloe2YPYJQo2SmJvYEREnhWC3fAQwyCtYo+SZ9zqkR3eulYhz3/SPXVZUzeXpvcudaFfzoG4A6BZ5Gn8J1oF7BuJ/Rx+zbrNCDjA157ezuSb/zHVQcxxhcEzPMlo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(396003)(366004)(39860400002)(66556008)(66476007)(8676002)(66946007)(26005)(86362001)(1076003)(5660300002)(478600001)(6486002)(36756003)(316002)(83380400001)(6666004)(7416002)(2906002)(8936002)(6916009)(4326008)(2616005)(7696005)(16526019)(52116002)(186003)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: P9P2rqwReD1+e81dfCh2GfH1EHIUkwcwSREnad2HW+eOuuYyjvHmFWtu5ELstD27rdDZCnVvROWX9My5xm+QatxZrvmXHpbEBgQjO6q6Ey2l8qmZqqxIlYq57p5Ym14czGvcymt0jKSYSBscOZDqhloJ4k4LchUesDJmgUdSKVCZ82EFR1njAsD9WQrRRIZ202lln9d+FSCXsWH0/P2iXz5UC+eztSDueWmbeOCPMc5keTw+hpjRrZVKsg3kOpUKP+mJjWcf5hZ1R9u3iZWSdf/BdvA3EDv5CX2tjCbk63APlE+wPZL6s4AfghYn9x6haj9Fg3mY6b1XB5E3Or++L2845JrvMgLify/Rry9dBziAQAzZokEnKiVLmtOEXhEVLACBJPqGmd+RuM5PJFL7a+XarJDdqaan8YRc/tL9T1rOTb7WMU+FSwiu5hPt57rVrLCokXX3Fn/ORYlejHePKGecUFxJNBWYFikBkminkHnfi2LNW4Zqb3AkfMtCDJgq6vBK+E8u+XA8VCwp5YqrfC8TqK1ff2OKktoVm/mF4KbhcZN+OfNDIcvWPO4EKX0eEjWvyiSHXMCrTCL1G71kCl1yEMWdFkT67NJxL7yLLTrQRUMhJgnzt2A3IBLowImHaaaZJzr1+u1jie6pdnYTww==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f22a8c5-2942-4058-8f9f-08d84452ea8d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2020 15:16:58.7597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: swbdO479WyydJKz9R2WOLnrMNe5AQeZaFe2IBHffuBqKJWr/sos1QDCTxpbgA/ov+Q89HmNELPSeHJ54TiIsrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3227
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Improve SEV guest startup time from O(n) to a constant by deferring
guest page pinning until the pages are used to satisfy nested page faults.

Implement the code to do the pinning (sev_get_page) and the notifier
sev_pin_page().

Track the pinned pages with xarray so they can be released during guest
termination.

Co-developed-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: eric van tassell <Eric.VanTassell@amd.com>
---
 arch/x86/kvm/svm/sev.c | 68 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c |  2 ++
 arch/x86/kvm/svm/svm.h |  3 ++
 3 files changed, 73 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f7f1f4ecf08e..8d56d1afb33e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -184,6 +184,8 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	sev->asid = asid;
 	INIT_LIST_HEAD(&sev->regions_list);
 
+	xa_init(&sev->pages_xarray);
+
 	return 0;
 
 e_free:
@@ -415,6 +417,43 @@ static unsigned long get_num_contig_pages(unsigned long idx,
 	return pages;
 }
 
+static int sev_get_page(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct xarray *xa = &sev->pages_xarray;
+	struct page *page = pfn_to_page(pfn);
+	int ret;
+
+	/* store page at index = gfn */
+	ret = xa_insert(xa, gfn, page, GFP_ATOMIC);
+	if (ret == -EBUSY) {
+		/*
+		 * If xa_insert returned -EBUSY, the  gfn was already associated
+		 * with a struct page *.
+		 */
+		struct page *cur_page;
+
+		cur_page = xa_load(xa, gfn);
+		/* If cur_page == page, no change is needed, so return 0 */
+		if (cur_page == page)
+			return 0;
+
+		/* Release the page that was stored at index = gfn */
+		put_page(cur_page);
+
+		/* Return result of attempting to store page at index = gfn */
+		ret = xa_err(xa_store(xa, gfn, page, GFP_ATOMIC));
+		WARN_ON(ret != 0);
+	}
+
+	if (ret)
+		return ret;
+
+	get_page(page);
+
+	return 0;
+}
+
 static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
 	unsigned long vaddr, vaddr_end, next_vaddr, npages, pages, size, i;
@@ -1085,6 +1124,8 @@ void sev_vm_destroy(struct kvm *kvm)
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct list_head *head = &sev->regions_list;
 	struct list_head *pos, *q;
+	XA_STATE(xas, &sev->pages_xarray, 0);
+	struct page *xa_page;
 
 	if (!sev_guest(kvm))
 		return;
@@ -1109,6 +1150,12 @@ void sev_vm_destroy(struct kvm *kvm)
 		}
 	}
 
+	/* Release each pinned page that SEV tracked in sev->pages_xarray. */
+	xas_for_each(&xas, xa_page, ULONG_MAX) {
+		put_page(xa_page);
+	}
+	xa_destroy(&sev->pages_xarray);
+
 	mutex_unlock(&kvm->lock);
 
 	sev_unbind_asid(kvm, sev->handle);
@@ -1193,3 +1240,24 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
 	svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
 	vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
 }
+
+int sev_pin_page(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn,
+		 int level, u64 *spte)
+{
+	int rc;
+
+	if (!sev_guest(vcpu->kvm))
+		return 0;
+
+	rc = sev_get_page(vcpu->kvm, gfn, pfn);
+	if (rc)
+		return rc;
+
+	/*
+	 * Flush any cached lines of the page being added since "ownership" of
+	 * it will be transferred from the host to an encrypted guest.
+	 */
+	clflush_cache_range(__va(pfn << PAGE_SHIFT), page_level_size(level));
+
+	return 0;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 535ad311ad02..adb308631416 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4130,6 +4130,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
 
 	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
+
+	.pin_page = sev_pin_page,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 121b198b51e9..278c46bc52aa 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -65,6 +65,7 @@ struct kvm_sev_info {
 	int fd;			/* SEV device fd */
 	unsigned long pages_locked; /* Number of pages locked */
 	struct list_head regions_list;  /* List of registered regions */
+	struct xarray pages_xarray; /* List of PFN locked */
 };
 
 struct kvm_svm {
@@ -488,5 +489,7 @@ int svm_unregister_enc_region(struct kvm *kvm,
 void pre_sev_run(struct vcpu_svm *svm, int cpu);
 int __init sev_hardware_setup(void);
 void sev_hardware_teardown(void);
+int sev_pin_page(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn,
+		 int level, u64 *spte);
 
 #endif
-- 
2.17.1

