Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB0730DD81
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 16:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233508AbhBCPCz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 10:02:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233477AbhBCPCx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 10:02:53 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446E9C061353
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 07:01:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=o0XNMlZ8QvnKPSbkZJ+Gnv3UfO8Ype8g3H4dDlvcoLM=; b=CbBQY9zXV4orwFPL3EX6IihyDn
        JPaU6rXZxM+AkRjMGn85ih9wgniUR1CpurzHU4KQiOXalBZdXr3fKJyjPQdP9/4pqy168V5sOc6Ox
        uuUuaAZNU8nw15/ody1MJhC4MoZkJgSM+GhdlPpgfQZTSh8uPO8E4dCEQ0gWIXvtyLgFlVF1xK8jA
        /VFK0sexa3h9VGQoyQ/Z5In0Oiow9FhBUz+HuFWt4OpclbuGZ3B7yq7rjbf+F8YhHsbbw004SWKBi
        Tz2BFh8jhP2Sd+u2vtap9+HG8IjoBBKmgV6COeknE72Nxn9vlKc/uXM6m322KTVeiODD31hjG8dnI
        v3fABhlw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l7Jef-00H3zM-Sw; Wed, 03 Feb 2021 15:01:20 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l7Jef-003reu-FN; Wed, 03 Feb 2021 15:01:17 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
Subject: [PATCH v6 16/19] KVM: x86/xen: register vcpu time info region
Date:   Wed,  3 Feb 2021 15:01:11 +0000
Message-Id: <20210203150114.920335-17-dwmw2@infradead.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210203150114.920335-1-dwmw2@infradead.org>
References: <20210203150114.920335-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joao Martins <joao.m.martins@oracle.com>

Allow the Xen emulated guest the ability to register secondary
vcpu time information. On Xen guests this is used in order to be
mapped to userspace and hence allow vdso gettimeofday to work.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/x86.c              |  2 ++
 arch/x86/kvm/xen.c              | 18 ++++++++++++++++++
 include/uapi/linux/kvm.h        |  1 +
 4 files changed, 23 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 421d082d772d..cd65bd43fc5f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -524,7 +524,9 @@ struct kvm_vcpu_hv {
 struct kvm_vcpu_xen {
 	u64 hypercall_rip;
 	bool vcpu_info_set;
+	bool vcpu_time_info_set;
 	struct gfn_to_hva_cache vcpu_info_cache;
+	struct gfn_to_hva_cache vcpu_time_info_cache;
 };
 
 struct kvm_vcpu_arch {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 65d06d4426a2..8d849e8e9953 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2736,6 +2736,8 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	if (vcpu->xen.vcpu_info_set)
 		kvm_setup_pvclock_page(v, &vcpu->xen.vcpu_info_cache,
 				       offsetof(struct compat_vcpu_info, time));
+	if (vcpu->xen.vcpu_time_info_set)
+		kvm_setup_pvclock_page(v, &vcpu->xen.vcpu_time_info_cache, 0);
 	if (v == kvm_get_vcpu(v->kvm, 0))
 		kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
 	return 0;
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index c307f8b7a8a3..bd343222e740 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -141,6 +141,17 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 		}
 		break;
 
+	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO:
+		r = kvm_gfn_to_hva_cache_init(vcpu->kvm,
+					      &vcpu->arch.xen.vcpu_time_info_cache,
+					      data->u.gpa,
+					      sizeof(struct pvclock_vcpu_time_info));
+		if (!r) {
+			vcpu->arch.xen.vcpu_time_info_set = true;
+			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
+		}
+		break;
+
 	default:
 		break;
 	}
@@ -164,6 +175,13 @@ int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 		}
 		break;
 
+	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO:
+		if (vcpu->arch.xen.vcpu_time_info_set) {
+			data->u.gpa = vcpu->arch.xen.vcpu_time_info_cache.gpa;
+			r = 0;
+		}
+		break;
+
 	default:
 		break;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index a34a35a8f354..e00b15ba7b7e 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1618,6 +1618,7 @@ struct kvm_xen_vcpu_attr {
 };
 
 #define KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO	0x0
+#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO	0x1
 
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
-- 
2.29.2

