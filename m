Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41AFA9C945
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 08:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729730AbfHZGVv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 02:21:51 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40270 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729549AbfHZGVv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 02:21:51 -0400
Received: by mail-pg1-f193.google.com with SMTP id w10so9946975pgj.7;
        Sun, 25 Aug 2019 23:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ww3CH/EuPfUm7MGkzsIwMIKZd9a9WdHhMfxGdgaXqRQ=;
        b=pPktC0j3L57wdrGa7AnXryx6j7RhCYxT3JvQxQRm3u53ap1tD5quFTVmJp02goEFiL
         hIqiozzXBrx3VtlEJc0QunjmeoFv3GNYStCIXm3ivSM6p85YWJM9QoIkaT/6eHDMXhAd
         VQg4mCrwaU8w7HBYd2lxV9sxxXVf6AZz5djLHtLU2GSazG00xCkjPSAh6gM5LWeHbTGr
         +UQoC1QsN34+at3S6EIJIZyb+MHTNAt2ls6bcxAqNqQ9scMsXSTUfHVeDxQIqEVKX9SM
         wK5NBJv9KkU546t6ZAajxosXhyq2BGtaZXtxB4eDYcoGDuxDz0dTjRRuM2HCgcOX4rLO
         NJeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ww3CH/EuPfUm7MGkzsIwMIKZd9a9WdHhMfxGdgaXqRQ=;
        b=SuTST+B4M7kdVXV472tpphd9Cmj15UHbnvNF9Sy0emb6hWmfq5nZZSaDrsXuJViPMj
         zcg2v3+Oiuy5Xp7+MZH0Mqenf0wX47t/GM1atSgytMfbF0IK+ODu4+sEzYxEmoo8cSgA
         E3COrxo5sAvOddojrhrdTtbmIzNsHzOBwPFvNylFXzWeZk/XdT3IUmtr9bZByFvz5+xR
         u1LQSlEstwJ2pLok8yrbFe7Gletbd9d7xnziCk0LPNS0iUVqo7UJN6holNn19VRfYTSo
         Ffp/KGGK1UpmsflEmzEUcRP1L5sEkImUokR25ljrV6dYLEANCd9C/N6J+qw9/4PRq32a
         +6RA==
X-Gm-Message-State: APjAAAW33v7Az0IbiOaLFQMDEcrHSvMp6ZqnoOVH/S7HDFr3WOFCyRVA
        s9BoUx4OCjh/MVt4zau6GWenl8Ap3GQ=
X-Google-Smtp-Source: APXvYqyOGdXrwian48YpvjrkF82AbzYe/XPzFNVleVxrN6uZwe2ifMEfwqwusOE1VhWTzrdITQerAg==
X-Received: by 2002:a65:6448:: with SMTP id s8mr11364707pgv.223.1566800510060;
        Sun, 25 Aug 2019 23:21:50 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id f7sm10030353pfd.43.2019.08.25.23.21.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 25 Aug 2019 23:21:49 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     paulus@ozlabs.org, kvm@vger.kernel.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Subject: [PATCH 14/23] KVM: PPC: Book3S HV: Nested: Context switch slb for nested hpt guest
Date:   Mon, 26 Aug 2019 16:21:00 +1000
Message-Id: <20190826062109.7573-15-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20190826062109.7573-1-sjitindarsingh@gmail.com>
References: <20190826062109.7573-1-sjitindarsingh@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A version 2 of the H_ENTER_NESTED hcall was added with an argument to
specify the slb entries which should be used to run the nested guest.

Add support for this version of the hcall structures to
kvmhv_enter_nested_guest() and context switch the slb when the nested
guest being run is a hpt (hash page table) guest.

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_nested.c | 84 ++++++++++++++++++++++++++++++++++---
 1 file changed, 79 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 82690eafee77..883f8896ed60 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -104,6 +104,28 @@ static void byteswap_hv_regs(struct hv_guest_state *hr)
 	hr->ppr = swab64(hr->ppr);
 }
 
+static void byteswap_guest_slb(struct guest_slb *slbp)
+{
+	int i;
+
+	for (i = 0; i < 64; i++) {
+		slbp->slb[i].esid = swab64(slbp->slb[i].esid);
+		slbp->slb[i].vsid = swab64(slbp->slb[i].vsid);
+		slbp->slb[i].orige = swab64(slbp->slb[i].orige);
+		slbp->slb[i].origv = swab64(slbp->slb[i].origv);
+		slbp->slb[i].valid = swab32(slbp->slb[i].valid);
+		slbp->slb[i].Ks = swab32(slbp->slb[i].Ks);
+		slbp->slb[i].Kp = swab32(slbp->slb[i].Kp);
+		slbp->slb[i].nx = swab32(slbp->slb[i].nx);
+		slbp->slb[i].large = swab32(slbp->slb[i].large);
+		slbp->slb[i].tb = swab32(slbp->slb[i].tb);
+		slbp->slb[i].class = swab32(slbp->slb[i].class);
+		/* base_page_size is u8 thus no need to byteswap */
+	}
+	slbp->slb_max = swab64(slbp->slb_max);
+	slbp->slb_nr = swab64(slbp->slb_nr);
+}
+
 static void save_hv_return_state(struct kvm_vcpu *vcpu, int trap,
 				 struct hv_guest_state *hr)
 {
@@ -238,12 +260,13 @@ static void kvmhv_nested_mmio_needed(struct kvm_vcpu *vcpu, u64 regs_ptr)
 
 long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 {
-	long int err, r;
+	long int err, r, ret = H_SUCCESS;
 	struct kvm_nested_guest *l2;
 	struct pt_regs l2_regs, saved_l1_regs;
 	struct hv_guest_state l2_hv, saved_l1_hv;
+	struct guest_slb *l2_slb = NULL, *saved_l1_slb = NULL;
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
-	u64 hv_ptr, regs_ptr;
+	u64 hv_ptr, regs_ptr, slb_ptr = 0UL;
 	u64 hdec_exp;
 	s64 delta_purr, delta_spurr, delta_ic, delta_vtb;
 	u64 mask;
@@ -261,7 +284,9 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 		return H_PARAMETER;
 	if (kvmppc_need_byteswap(vcpu))
 		byteswap_hv_regs(&l2_hv);
-	if (l2_hv.version != 1)
+	/* Do we support the guest version of the argument structures */
+	if ((l2_hv.version > HV_GUEST_STATE_MAX_VERSION) ||
+			(l2_hv.version < HV_GUEST_STATE_MIN_VERSION))
 		return H_P2;
 
 	regs_ptr = kvmppc_get_gpr(vcpu, 5);
@@ -296,6 +321,9 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 			return H_PARAMETER;
 	} else {
 		return H_PARAMETER;
+		/* must be at least V2 to support hpt guest */
+		if (l2_hv.version < 2)
+			return H_PARAMETER;
 		/* hpt doesn't support gtse or uprt and required vpm */
 		if ((l2_hv.lpcr & LPCR_HR) || (l2_hv.lpcr & LPCR_GTSE) ||
 					      (l2_hv.lpcr & LPCR_UPRT) ||
@@ -307,6 +335,26 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	vcpu->arch.regs.msr = vcpu->arch.shregs.msr;
 	saved_l1_regs = vcpu->arch.regs;
 	kvmhv_save_hv_regs(vcpu, &saved_l1_hv);
+	/* if running hpt then context switch the slb in the vcpu struct */
+	if (!radix) {
+		slb_ptr = kvmppc_get_gpr(vcpu, 6);
+		l2_slb = kzalloc(sizeof(*l2_slb), GFP_KERNEL);
+		saved_l1_slb = kzalloc(sizeof(*saved_l1_slb), GFP_KERNEL);
+
+		if ((!l2_slb) || (!saved_l1_slb)) {
+			ret = H_HARDWARE;
+			goto out_free;
+		}
+		err = kvm_vcpu_read_guest(vcpu, slb_ptr, l2_slb,
+					  sizeof(struct guest_slb));
+		if (err) {
+			ret = H_PARAMETER;
+			goto out_free;
+		}
+		if (kvmppc_need_byteswap(vcpu))
+			byteswap_guest_slb(l2_slb);
+		kvmhv_save_guest_slb(vcpu, saved_l1_slb);
+	}
 
 	/* convert TB values/offsets to host (L0) values */
 	hdec_exp = l2_hv.hdec_expiry - vc->tb_offset;
@@ -323,6 +371,8 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	lpcr = (vc->lpcr & ~mask) | (l2_hv.lpcr & mask);
 	sanitise_hv_regs(vcpu, &l2_hv);
 	restore_hv_regs(vcpu, &l2_hv);
+	if (!radix)
+		kvmhv_restore_guest_slb(vcpu, l2_slb);
 
 	vcpu->arch.ret = RESUME_GUEST;
 	vcpu->arch.trap = 0;
@@ -332,8 +382,11 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 			r = RESUME_HOST;
 			break;
 		}
-		r = kvmhv_run_single_vcpu(vcpu->arch.kvm_run, vcpu, hdec_exp,
-					  lpcr);
+		if (radix)
+			r = kvmhv_run_single_vcpu(vcpu->arch.kvm_run, vcpu,
+						  hdec_exp, lpcr);
+		else
+			r = RESUME_HOST; /* XXX TODO hpt entry path */
 	} while (is_kvmppc_resume_guest(r));
 
 	/* save L2 state for return */
@@ -344,6 +397,8 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	delta_ic = vcpu->arch.ic - l2_hv.ic;
 	delta_vtb = vc->vtb - l2_hv.vtb;
 	save_hv_return_state(vcpu, vcpu->arch.trap, &l2_hv);
+	if (!radix)
+		kvmhv_save_guest_slb(vcpu, l2_slb);
 
 	/* restore L1 state */
 	vcpu->arch.nested = NULL;
@@ -354,6 +409,8 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 		vcpu->arch.shregs.msr |= MSR_TS_S;
 	vc->tb_offset = saved_l1_hv.tb_offset;
 	restore_hv_regs(vcpu, &saved_l1_hv);
+	if (!radix)
+		kvmhv_restore_guest_slb(vcpu, saved_l1_slb);
 	vcpu->arch.purr += delta_purr;
 	vcpu->arch.spurr += delta_spurr;
 	vcpu->arch.ic += delta_ic;
@@ -363,9 +420,21 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 
 	/* copy l2_hv_state and regs back to guest */
 	if (kvmppc_need_byteswap(vcpu)) {
+		if (!radix)
+			byteswap_guest_slb(l2_slb);
 		byteswap_hv_regs(&l2_hv);
 		byteswap_pt_regs(&l2_regs);
 	}
+	if (!radix) {
+		err = kvm_vcpu_write_guest(vcpu, slb_ptr, l2_slb,
+					   sizeof(struct guest_slb));
+		if (err) {
+			ret = H_AUTHORITY;
+			goto out_free;
+		}
+		kfree(l2_slb);
+		kfree(saved_l1_slb);
+	}
 	err = kvm_vcpu_write_guest(vcpu, hv_ptr, &l2_hv,
 				   sizeof(struct hv_guest_state));
 	if (err)
@@ -384,6 +453,11 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	}
 
 	return vcpu->arch.trap;
+
+out_free:
+	kfree(l2_slb);
+	kfree(saved_l1_slb);
+	return ret;
 }
 
 long kvmhv_nested_init(void)
-- 
2.13.6

