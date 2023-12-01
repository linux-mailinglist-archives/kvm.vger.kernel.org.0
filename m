Return-Path: <kvm+bounces-3088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AF008008CE
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 11:46:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 84EDCB21429
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 10:46:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD2A020B1C;
	Fri,  1 Dec 2023 10:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen.org header.i=@xen.org header.b="d6NBEYP0"
X-Original-To: kvm@vger.kernel.org
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C5110E5;
	Fri,  1 Dec 2023 02:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
	s=20200302mail; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-Id:Date:Subject:To:From;
	bh=wFdaNfSO3kHrtdA/nDJtCTrlH575cz0J84l58QN9+OU=; b=d6NBEYP0mST7ARp0cVbuoc07p2
	YzAjQQvJAKV5ODtHtFuEKZXdsW/oieEAI2nZ7FXcAT9PnCD5KrCHou6L3RNXtDMQ01oLoJG0CS++A
	mhMPng0hKPvGT6uFXHOXjVOh4aAdBvM+nCadD0bi/pO89VdnE4JfVIstxGL7KlPr1iZk=;
Received: from xenbits.xenproject.org ([104.239.192.120])
	by mail.xenproject.org with esmtp (Exim 4.92)
	(envelope-from <paul@xen.org>)
	id 1r911v-0005P6-3k; Fri, 01 Dec 2023 10:45:55 +0000
Received: from 54-240-197-231.amazon.com ([54.240.197.231] helo=REM-PW02S00X.ant.amazon.com)
	by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <paul@xen.org>)
	id 1r911u-0003dT-QB; Fri, 01 Dec 2023 10:45:55 +0000
From: Paul Durrant <paul@xen.org>
To: David Woodhouse <dwmw2@infradead.org>,
	Paul Durrant <paul@xen.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: xen: (re-)initialize shared_info if guest (32/64-bit) mode is set
Date: Fri,  1 Dec 2023 10:45:36 +0000
Message-Id: <20231201104536.947-3-paul@xen.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231201104536.947-1-paul@xen.org>
References: <20231201104536.947-1-paul@xen.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Paul Durrant <pdurrant@amazon.com>

If the shared_info PFN cache has already been initialized then the content
of the shared_info page needs to be (re-)initialized if the guest mode is
set. It is no lnger done when the PFN cache is activated.
Setting the guest mode is either done explicitly by the VMM via the
KVM_XEN_ATTR_TYPE_LONG_MODE attribute, or implicitly when the guest writes
the MSR to set up the hypercall page.

Signed-off-by: Paul Durrant <pdurrant@amazon.com>
---
 arch/x86/kvm/xen.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 7bead3f65e55..bfc8f6698cbc 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -624,8 +624,15 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		} else {
 			mutex_lock(&kvm->arch.xen.xen_lock);
 			kvm->arch.xen.long_mode = !!data->u.long_mode;
+
+			/*
+			 * If shared_info has already been initialized
+			 * then re-initialize it with the new width.
+			 */
+			r = kvm->arch.xen.shinfo_cache.active ?
+				kvm_xen_shared_info_init(kvm) : 0;
+
 			mutex_unlock(&kvm->arch.xen.xen_lock);
-			r = 0;
 		}
 		break;
 
@@ -657,9 +664,6 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		}
 		srcu_read_unlock(&kvm->srcu, idx);
 
-		if (!r && kvm->arch.xen.shinfo_cache.active)
-			r = kvm_xen_shared_info_init(kvm);
-
 		mutex_unlock(&kvm->arch.xen.xen_lock);
 		break;
 	}
@@ -1144,7 +1148,13 @@ int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
 	bool lm = is_long_mode(vcpu);
 
 	/* Latch long_mode for shared_info pages etc. */
-	vcpu->kvm->arch.xen.long_mode = lm;
+	kvm->arch.xen.long_mode = lm;
+
+	if (kvm->arch.xen.shinfo_cache.active &&
+	    kvm_xen_shared_info_init(kvm)) {
+		mutex_unlock(&kvm->arch.xen.xen_lock);
+		return 1;
+	}
 
 	/*
 	 * If Xen hypercall intercept is enabled, fill the hypercall
-- 
2.39.2


