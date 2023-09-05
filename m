Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA060792824
	for <lists+kvm@lfdr.de>; Tue,  5 Sep 2023 18:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237007AbjIEQDn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 12:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344521AbjIEDr0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 23:47:26 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E00D1CC7;
        Mon,  4 Sep 2023 20:47:22 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 41be03b00d2f7-56b0c5a140dso1484741a12.0;
        Mon, 04 Sep 2023 20:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693885642; x=1694490442; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O40+8ZcyF7i45coCovtz7BFXegxRcC292Q0Q5Dn+068=;
        b=UNEAz0ryASFGK3+mwR2B4slOlayTG8YPeBJOZSw/XOXvLVm6nA30KsYN5C5+qZ3jXO
         3RJedxlf71fYzdYEMv1ro68Gz4tA5ohR7bmFwmaLKoNXRr4PfX7kHDZPJ448Jn+T7Emf
         HkWPOBIf6yzsm22c2YXrvLcnWlZNb9+x5pFNZl5LXbor14lvEHCm38EiULxX5xi8TN6n
         QxEaK9MoWAotkf4kaROwkdk9cb0eRqSM5HR7y4z1yLe0RZ8Pn9FxNE3dQHJ33R5g8CYF
         XQPmViKBXFVjQyml+wo+ku+I84ekrL8U9Vg+8oqfNc+1Q35B/r+8Iug2xm6LV/FLAf6k
         PbKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693885642; x=1694490442;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O40+8ZcyF7i45coCovtz7BFXegxRcC292Q0Q5Dn+068=;
        b=T3RppKk7YwDH+crTrUj2A80bVNEG4W+G/phY1XMAxj2U6wEKrknI3yp0OFV2DMUDr4
         oRHZcfWThF75yp9aySfZW70t2MtWztkdHOwjQ2pojReeYXnVdkxejx5AnFymQ0sE12ll
         D68RtLNkIqVnMoF3UWmzB8DD+ZJ6fUeMBP175cugokJSl0Aeqsq+HKWUg78BVGahFI1j
         iRqRZpxlRzyJ0pDTNEBX3f1Ms2gopNiPmvIKPpUk4YjPKLpM2PWFnkng73maHBDFbopo
         EB5cskZS0X03gHY72Ce8Kf6HvOHPZWwtkaozgja5vEMtPrAlham32vZxDu0oJBl74Q2Q
         3BdQ==
X-Gm-Message-State: AOJu0YxHiiGasvmp4ef0Hre7rx5hzMWjxep1DTQRpkrfBsIi/ieuX05R
        zLfslynRjcDm03p4ui87AMU=
X-Google-Smtp-Source: AGHT+IEHDknX4EX9DDLOfBiA3UM2b/sFsM4BT8HOvolzvMd/Prty+bK0zba/O+zHYBWzd7RqKOTaVg==
X-Received: by 2002:a05:6a21:788e:b0:132:2f7d:29ca with SMTP id bf14-20020a056a21788e00b001322f7d29camr15983402pzc.24.1693885642326;
        Mon, 04 Sep 2023 20:47:22 -0700 (PDT)
Received: from pwon.ozlabs.ibm.com ([129.41.57.2])
        by smtp.gmail.com with ESMTPSA id v23-20020aa78097000000b0063f0068cf6csm7994951pff.198.2023.09.04.20.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Sep 2023 20:47:21 -0700 (PDT)
From:   Jordan Niethe <jniethe5@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, npiggin@gmail.com,
        mikey@neuling.org, paulus@ozlabs.org, vaibhav@linux.ibm.com,
        sbhat@linux.ibm.com, gautam@linux.ibm.com,
        kconsul@linux.vnet.ibm.com, amachhiw@linux.vnet.ibm.com,
        David.Laight@ACULAB.COM, mpe@ellerman.id.au,
        Jordan Niethe <jniethe5@gmail.com>
Subject: [PATCH v4 01/11] KVM: PPC: Always use the GPR accessors
Date:   Tue,  5 Sep 2023 13:46:48 +1000
Message-Id: <20230905034658.82835-2-jniethe5@gmail.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230905034658.82835-1-jniethe5@gmail.com>
References: <20230905034658.82835-1-jniethe5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Always use the GPR accessor functions. This will be important later for
Nested APIv2 support which requires additional functionality for
accessing and modifying VCPU state.

Signed-off-by: Jordan Niethe <jniethe5@gmail.com>
---
v4:
  - Split into unique patch
---
 arch/powerpc/kvm/book3s_64_vio.c     | 4 ++--
 arch/powerpc/kvm/book3s_hv.c         | 8 ++++++--
 arch/powerpc/kvm/book3s_hv_builtin.c | 6 +++++-
 arch/powerpc/kvm/book3s_hv_rm_mmu.c  | 8 ++++----
 arch/powerpc/kvm/book3s_hv_rm_xics.c | 4 ++--
 arch/powerpc/kvm/book3s_xive.c       | 4 ++--
 6 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index 93b695b289e9..4ba048f272f2 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -786,12 +786,12 @@ long kvmppc_h_get_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
 	idx = (ioba >> stt->page_shift) - stt->offset;
 	page = stt->pages[idx / TCES_PER_PAGE];
 	if (!page) {
-		vcpu->arch.regs.gpr[4] = 0;
+		kvmppc_set_gpr(vcpu, 4, 0);
 		return H_SUCCESS;
 	}
 	tbl = (u64 *)page_address(page);
 
-	vcpu->arch.regs.gpr[4] = tbl[idx % TCES_PER_PAGE];
+	kvmppc_set_gpr(vcpu, 4, tbl[idx % TCES_PER_PAGE]);
 
 	return H_SUCCESS;
 }
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 130bafdb1430..4af5b68cf7f8 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1267,10 +1267,14 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
 			return RESUME_HOST;
 		break;
 #endif
-	case H_RANDOM:
-		if (!arch_get_random_seed_longs(&vcpu->arch.regs.gpr[4], 1))
+	case H_RANDOM: {
+		unsigned long rand;
+
+		if (!arch_get_random_seed_longs(&rand, 1))
 			ret = H_HARDWARE;
+		kvmppc_set_gpr(vcpu, 4, rand);
 		break;
+	}
 	case H_RPT_INVALIDATE:
 		ret = kvmppc_h_rpt_invalidate(vcpu, kvmppc_get_gpr(vcpu, 4),
 					      kvmppc_get_gpr(vcpu, 5),
diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
index 0f5b021fa559..f3afe194e616 100644
--- a/arch/powerpc/kvm/book3s_hv_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -182,9 +182,13 @@ EXPORT_SYMBOL_GPL(kvmppc_hwrng_present);
 
 long kvmppc_rm_h_random(struct kvm_vcpu *vcpu)
 {
+	unsigned long rand;
+
 	if (ppc_md.get_random_seed &&
-	    ppc_md.get_random_seed(&vcpu->arch.regs.gpr[4]))
+	    ppc_md.get_random_seed(&rand)) {
+		kvmppc_set_gpr(vcpu, 4, rand);
 		return H_SUCCESS;
+	}
 
 	return H_HARDWARE;
 }
diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
index 9182324dbef9..17cb75a127b0 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -776,8 +776,8 @@ long kvmppc_h_read(struct kvm_vcpu *vcpu, unsigned long flags,
 			r = rev[i].guest_rpte | (r & (HPTE_R_R | HPTE_R_C));
 			r &= ~HPTE_GR_RESERVED;
 		}
-		vcpu->arch.regs.gpr[4 + i * 2] = v;
-		vcpu->arch.regs.gpr[5 + i * 2] = r;
+		kvmppc_set_gpr(vcpu, 4 + i * 2, v);
+		kvmppc_set_gpr(vcpu, 5 + i * 2, r);
 	}
 	return H_SUCCESS;
 }
@@ -824,7 +824,7 @@ long kvmppc_h_clear_ref(struct kvm_vcpu *vcpu, unsigned long flags,
 			}
 		}
 	}
-	vcpu->arch.regs.gpr[4] = gr;
+	kvmppc_set_gpr(vcpu, 4, gr);
 	ret = H_SUCCESS;
  out:
 	unlock_hpte(hpte, v & ~HPTE_V_HVLOCK);
@@ -872,7 +872,7 @@ long kvmppc_h_clear_mod(struct kvm_vcpu *vcpu, unsigned long flags,
 			kvmppc_set_dirty_from_hpte(kvm, v, gr);
 		}
 	}
-	vcpu->arch.regs.gpr[4] = gr;
+	kvmppc_set_gpr(vcpu, 4, gr);
 	ret = H_SUCCESS;
  out:
 	unlock_hpte(hpte, v & ~HPTE_V_HVLOCK);
diff --git a/arch/powerpc/kvm/book3s_hv_rm_xics.c b/arch/powerpc/kvm/book3s_hv_rm_xics.c
index e165bfa842bf..e42984878503 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_xics.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_xics.c
@@ -481,7 +481,7 @@ static void icp_rm_down_cppr(struct kvmppc_xics *xics, struct kvmppc_icp *icp,
 
 unsigned long xics_rm_h_xirr_x(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.regs.gpr[5] = get_tb();
+	kvmppc_set_gpr(vcpu, 5, get_tb());
 	return xics_rm_h_xirr(vcpu);
 }
 
@@ -518,7 +518,7 @@ unsigned long xics_rm_h_xirr(struct kvm_vcpu *vcpu)
 	} while (!icp_rm_try_update(icp, old_state, new_state));
 
 	/* Return the result in GPR4 */
-	vcpu->arch.regs.gpr[4] = xirr;
+	kvmppc_set_gpr(vcpu, 4, xirr);
 
 	return check_too_hard(xics, icp);
 }
diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
index f4115819e738..48d11baf1f16 100644
--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -328,7 +328,7 @@ static unsigned long xive_vm_h_xirr(struct kvm_vcpu *vcpu)
 	 */
 
 	/* Return interrupt and old CPPR in GPR4 */
-	vcpu->arch.regs.gpr[4] = hirq | (old_cppr << 24);
+	kvmppc_set_gpr(vcpu, 4, hirq | (old_cppr << 24));
 
 	return H_SUCCESS;
 }
@@ -364,7 +364,7 @@ static unsigned long xive_vm_h_ipoll(struct kvm_vcpu *vcpu, unsigned long server
 	hirq = xive_vm_scan_interrupts(xc, pending, scan_poll);
 
 	/* Return interrupt and old CPPR in GPR4 */
-	vcpu->arch.regs.gpr[4] = hirq | (xc->cppr << 24);
+	kvmppc_set_gpr(vcpu, 4, hirq | (xc->cppr << 24));
 
 	return H_SUCCESS;
 }
-- 
2.39.3

