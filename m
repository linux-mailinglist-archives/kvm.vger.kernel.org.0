Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9782D9440
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 09:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439388AbgLNIki (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 03:40:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439376AbgLNIki (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 03:40:38 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F021C0617B0
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 00:39:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=VctmGADBV2oNqqj9qmGt9AuHZHZ+OWdiMjFVlna6qhY=; b=jdnV0wgIXfDCb3ZRt9RmedqsKl
        +sEHjB0h39C8PNZ2hwX+uIzvN6yEPqErKaL+zOGFMiwk2pTEBWOusLz+2ZQz+Npho7DHcWmES2PU3
        36k/7szWcwS6V5nPgRpk8Rv2QeE4VL8VBWNVzH8PFPnGZpZzXHE1F7+Wgrr1Z3SZEQXKjuns3wYdp
        hx9FmDyvna1lHi/DKWX9GN00FfpMunH8L44YGT9FiNPCLbXhNwKBDdmEerq/BZBdZXb/kQw8xGQXk
        pynki/O8qQFrB+KgdmnyXRHLQHpA06djE02VRKxWUbZh6TsirEnosNuml/VenQwxVTtlsIRf8i97y
        3Z7zIdVA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kojNs-0006lR-QN; Mon, 14 Dec 2020 08:39:08 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kojNr-008Sxw-Oe; Mon, 14 Dec 2020 08:39:07 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com
Subject: [PATCH v3 10/17] KVM: x86/xen: update wallclock region
Date:   Mon, 14 Dec 2020 08:38:58 +0000
Message-Id: <20201214083905.2017260-11-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201214083905.2017260-1-dwmw2@infradead.org>
References: <20201214083905.2017260-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joao Martins <joao.m.martins@oracle.com>

Wallclock on Xen is written in the shared_info page.

To that purpose, export kvm_write_wall_clock() and pass on the GPA of
its location to populate the shared_info wall clock data.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/x86.c | 17 ++++++++++++-----
 arch/x86/kvm/x86.h |  1 +
 arch/x86/kvm/xen.c | 28 +++++++++++++++++++++++++++-
 3 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 975ef5d6dda1..64016443159c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1921,15 +1921,14 @@ static s64 get_kvmclock_base_ns(void)
 }
 #endif
 
-static void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock)
+void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock, int sec_hi_ofs)
 {
 	int version;
 	int r;
 	struct pvclock_wall_clock wc;
+	u32 wc_sec_hi;
 	u64 wall_nsec;
 
-	kvm->arch.wall_clock = wall_clock;
-
 	if (!wall_clock)
 		return;
 
@@ -1958,6 +1957,12 @@ static void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock)
 
 	kvm_write_guest(kvm, wall_clock, &wc, sizeof(wc));
 
+	if (sec_hi_ofs) {
+		wc_sec_hi = wall_nsec >> 32;
+		kvm_write_guest(kvm, wall_clock + sec_hi_ofs,
+				&wc_sec_hi, sizeof(wc_sec_hi));
+	}
+
 	version++;
 	kvm_write_guest(kvm, wall_clock, &version, sizeof(version));
 }
@@ -3115,13 +3120,15 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE2))
 			return 1;
 
-		kvm_write_wall_clock(vcpu->kvm, data);
+		vcpu->kvm->arch.wall_clock = data;
+		kvm_write_wall_clock(vcpu->kvm, data, 0);
 		break;
 	case MSR_KVM_WALL_CLOCK:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE))
 			return 1;
 
-		kvm_write_wall_clock(vcpu->kvm, data);
+		vcpu->kvm->arch.wall_clock = data;
+		kvm_write_wall_clock(vcpu->kvm, data, 0);
 		break;
 	case MSR_KVM_SYSTEM_TIME_NEW:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE2))
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index e7ca622a468f..cf8778410015 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -246,6 +246,7 @@ static inline bool kvm_vcpu_latch_init(struct kvm_vcpu *vcpu)
 	return is_smm(vcpu) || kvm_x86_ops.apic_init_signal_blocked(vcpu);
 }
 
+void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock, int sec_hi_ofs);
 void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);
 
 void kvm_write_tsc(struct kvm_vcpu *vcpu, struct msr_data *msr);
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 9dd9c42842b8..e5117a611737 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -19,14 +19,40 @@
 
 static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
 {
+	gpa_t gpa = gfn_to_gpa(gfn);
+	int wc_ofs, sec_hi_ofs;
 	int ret;
 
 	ret = kvm_gfn_to_hva_cache_init(kvm, &kvm->arch.xen.shinfo_cache,
-					gfn_to_gpa(gfn), PAGE_SIZE);
+					gpa, PAGE_SIZE);
 	if (ret)
 		return ret;
 
 	kvm->arch.xen.shinfo_set = true;
+
+	/* Paranoia checks on the 32-bit struct layout */
+	BUILD_BUG_ON(offsetof(struct compat_shared_info, wc) != 0x900);
+	BUILD_BUG_ON(offsetof(struct compat_shared_info, arch.wc_sec_hi) != 0x924);
+	BUILD_BUG_ON(offsetof(struct pvclock_vcpu_time_info, version) != 0);
+
+	/* 32-bit location by default */
+	wc_ofs = offsetof(struct compat_shared_info, wc);
+	sec_hi_ofs = offsetof(struct compat_shared_info, arch.wc_sec_hi);
+
+#ifdef CONFIG_X86_64
+	/* Paranoia checks on the 64-bit struct layout */
+	BUILD_BUG_ON(offsetof(struct shared_info, wc) != 0xc00);
+	BUILD_BUG_ON(offsetof(struct shared_info, wc_sec_hi) != 0xc0c);
+
+	if (kvm->arch.xen.long_mode) {
+		wc_ofs = offsetof(struct shared_info, wc);
+		sec_hi_ofs = offsetof(struct shared_info, wc_sec_hi);
+	}
+#endif
+
+	kvm_write_wall_clock(kvm, gpa + wc_ofs, sec_hi_ofs - wc_ofs);
+	kvm_make_all_cpus_request(kvm, KVM_REQ_MASTERCLOCK_UPDATE);
+
 	return 0;
 }
 
-- 
2.26.2

