Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6DBB79F892
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 05:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234031AbjINDGo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 23:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234110AbjINDGn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 23:06:43 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35EE01BD2;
        Wed, 13 Sep 2023 20:06:39 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 41be03b00d2f7-577fb90bbebso99769a12.1;
        Wed, 13 Sep 2023 20:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694660798; x=1695265598; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=quAkYB9Enlr4JCakDFhG1NziT87Rmi15Sg8CUNN3A/Y=;
        b=FvPa43/qdX3GDdrvSaVjfnxAdWtjekhbAzNkXS59RLKzbO7w92RlXalbmkOB9Ocyi8
         3fIr43MN1fIt1wLORGH97O1ImHMoWkP6Towk4fpSgSHbdjcbVan8bga5H92vBUBgxoJE
         d647aNGwXPZmT/MksDSO7QmBWniaYo7znlmwc7WXGvMo4+tU/s/AGBD/Jc2UwQbj7G7d
         IhHSpJehoOSF0vrMC2ytfezPwK4xus0IIdSRmxFpZOuVNUypNWWh7GeXYW8xZWdIKCR7
         QiwMnEmyjRKaLkCFFN+wbQZ0+c1pyEds0lXl6Tfzz4UbWjFlDMaO2anhwizDI32eTSKg
         uebQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694660798; x=1695265598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=quAkYB9Enlr4JCakDFhG1NziT87Rmi15Sg8CUNN3A/Y=;
        b=eIkHgh2cw4jeUjSChKA53gbbnD/kTtF3CZKhi257zHu7Vx4GzGjXmILkHnyZws2x4U
         ICmEZE1RvcsVoKfEYuXMuKCybgmgj/HwtN7zK8lKFWEt2zuXguye2OTB/s0/SHQqe/n5
         wAJNM+pRnk0NGnNess8ALetpQE4kDWpy5qGPnrg+L4i0euKCP2XG8I3PVo6cqLJY+oFp
         vAZbsVRu/ERyRwRUAqOjD5K+ErWdxcOAR2Lpcuf3OMlI0vSTJlNVGTJANuZb4KfxZfiO
         fcB1JZlFH/8+5OMihjU792uIQjD5+EgIPY/qQhfDfN/RELIefpyPHG9dfhP8/zw5g4gA
         zmvg==
X-Gm-Message-State: AOJu0Yz1U+kl9iaYXGD+71A2zUYw83QGftzIHKQuo063zkfyJ9amyJkq
        S/rwP+7jmoSs2ljhi3yKjZ6E8fVOhm94XA==
X-Google-Smtp-Source: AGHT+IGSdqtsI0nvmOZOGcD9QXiTs5fRI904HY8of60Rh53yaCaqmiCW0hSZfUhwX0aZc6cKG54Fmw==
X-Received: by 2002:a05:6a20:f3a6:b0:14b:d28e:e947 with SMTP id qr38-20020a056a20f3a600b0014bd28ee947mr3944197pzb.48.1694660798565;
        Wed, 13 Sep 2023 20:06:38 -0700 (PDT)
Received: from pwon.ozlabs.ibm.com ([146.112.118.69])
        by smtp.gmail.com with ESMTPSA id w2-20020a170902904200b001b567bbe82dsm330521plz.150.2023.09.13.20.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Sep 2023 20:06:38 -0700 (PDT)
From:   Jordan Niethe <jniethe5@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, npiggin@gmail.com,
        mikey@neuling.org, paulus@ozlabs.org, vaibhav@linux.ibm.com,
        sbhat@linux.ibm.com, gautam@linux.ibm.com,
        kconsul@linux.vnet.ibm.com, amachhiw@linux.vnet.ibm.com,
        David.Laight@ACULAB.COM, mpe@ellerman.id.au, sachinp@linux.ibm.com,
        Jordan Niethe <jniethe5@gmail.com>
Subject: [PATCH v5 05/11] KVM: PPC: Use accessors for VCORE registers
Date:   Thu, 14 Sep 2023 13:05:54 +1000
Message-Id: <20230914030600.16993-6-jniethe5@gmail.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230914030600.16993-1-jniethe5@gmail.com>
References: <20230914030600.16993-1-jniethe5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce accessor generator macros for VCORE registers. Use the accessor
functions to replace direct accesses to this registers.

This will be important later for Nested APIv2 support which requires
additional functionality for accessing and modifying VCPU state.

Signed-off-by: Jordan Niethe <jniethe5@gmail.com>
---
v4:
  - Split to unique patch
  - Remove _hv suffix
  - Do not generate for setter arch_compat and lpcr
---
 arch/powerpc/include/asm/kvm_book3s.h | 25 ++++++++++++++++++++++++-
 arch/powerpc/kvm/book3s_hv.c          | 24 ++++++++++++------------
 arch/powerpc/kvm/book3s_hv_ras.c      |  4 ++--
 arch/powerpc/kvm/book3s_xive.c        |  4 +---
 4 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include/asm/kvm_book3s.h
index 1a220cd63227..4c6558d5fefe 100644
--- a/arch/powerpc/include/asm/kvm_book3s.h
+++ b/arch/powerpc/include/asm/kvm_book3s.h
@@ -483,6 +483,29 @@ KVMPPC_BOOK3S_VCPU_ACCESSOR(bescr, 64)
 KVMPPC_BOOK3S_VCPU_ACCESSOR(ic, 64)
 KVMPPC_BOOK3S_VCPU_ACCESSOR(vrsave, 64)
 
+
+#define KVMPPC_BOOK3S_VCORE_ACCESSOR_SET(reg, size)			\
+static inline void kvmppc_set_##reg(struct kvm_vcpu *vcpu, u##size val)	\
+{									\
+	vcpu->arch.vcore->reg = val;					\
+}
+
+#define KVMPPC_BOOK3S_VCORE_ACCESSOR_GET(reg, size)			\
+static inline u##size kvmppc_get_##reg(struct kvm_vcpu *vcpu)		\
+{									\
+	return vcpu->arch.vcore->reg;					\
+}
+
+#define KVMPPC_BOOK3S_VCORE_ACCESSOR(reg, size)				\
+	KVMPPC_BOOK3S_VCORE_ACCESSOR_SET(reg, size)			\
+	KVMPPC_BOOK3S_VCORE_ACCESSOR_GET(reg, size)			\
+
+
+KVMPPC_BOOK3S_VCORE_ACCESSOR(vtb, 64)
+KVMPPC_BOOK3S_VCORE_ACCESSOR(tb_offset, 64)
+KVMPPC_BOOK3S_VCORE_ACCESSOR_GET(arch_compat, 32)
+KVMPPC_BOOK3S_VCORE_ACCESSOR_GET(lpcr, 64)
+
 static inline u64 kvmppc_get_dec_expires(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.dec_expires;
@@ -496,7 +519,7 @@ static inline void kvmppc_set_dec_expires(struct kvm_vcpu *vcpu, u64 val)
 /* Expiry time of vcpu DEC relative to host TB */
 static inline u64 kvmppc_dec_expires_host_tb(struct kvm_vcpu *vcpu)
 {
-	return kvmppc_get_dec_expires(vcpu) - vcpu->arch.vcore->tb_offset;
+	return kvmppc_get_dec_expires(vcpu) - kvmppc_get_tb_offset(vcpu);
 }
 
 static inline bool is_kvmppc_resume_guest(int r)
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 27faecad1e3b..73d9a9eb376f 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -794,7 +794,7 @@ static void kvmppc_update_vpa_dispatch(struct kvm_vcpu *vcpu,
 
 	vpa->enqueue_dispatch_tb = cpu_to_be64(be64_to_cpu(vpa->enqueue_dispatch_tb) + stolen);
 
-	__kvmppc_create_dtl_entry(vcpu, vpa, vc->pcpu, now + vc->tb_offset, stolen);
+	__kvmppc_create_dtl_entry(vcpu, vpa, vc->pcpu, now + kvmppc_get_tb_offset(vcpu), stolen);
 
 	vcpu->arch.vpa.dirty = true;
 }
@@ -845,9 +845,9 @@ static bool kvmppc_doorbell_pending(struct kvm_vcpu *vcpu)
 
 static bool kvmppc_power8_compatible(struct kvm_vcpu *vcpu)
 {
-	if (vcpu->arch.vcore->arch_compat >= PVR_ARCH_207)
+	if (kvmppc_get_arch_compat(vcpu) >= PVR_ARCH_207)
 		return true;
-	if ((!vcpu->arch.vcore->arch_compat) &&
+	if ((!kvmppc_get_arch_compat(vcpu)) &&
 	    cpu_has_feature(CPU_FTR_ARCH_207S))
 		return true;
 	return false;
@@ -2283,7 +2283,7 @@ static int kvmppc_get_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 			*val = get_reg_val(id, vcpu->arch.vcore->dpdes);
 		break;
 	case KVM_REG_PPC_VTB:
-		*val = get_reg_val(id, vcpu->arch.vcore->vtb);
+		*val = get_reg_val(id, kvmppc_get_vtb(vcpu));
 		break;
 	case KVM_REG_PPC_DAWR:
 		*val = get_reg_val(id, vcpu->arch.dawr0);
@@ -2342,11 +2342,11 @@ static int kvmppc_get_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 		spin_unlock(&vcpu->arch.vpa_update_lock);
 		break;
 	case KVM_REG_PPC_TB_OFFSET:
-		*val = get_reg_val(id, vcpu->arch.vcore->tb_offset);
+		*val = get_reg_val(id, kvmppc_get_tb_offset(vcpu));
 		break;
 	case KVM_REG_PPC_LPCR:
 	case KVM_REG_PPC_LPCR_64:
-		*val = get_reg_val(id, vcpu->arch.vcore->lpcr);
+		*val = get_reg_val(id, kvmppc_get_lpcr(vcpu));
 		break;
 	case KVM_REG_PPC_PPR:
 		*val = get_reg_val(id, vcpu->arch.ppr);
@@ -2418,7 +2418,7 @@ static int kvmppc_get_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 		break;
 #endif
 	case KVM_REG_PPC_ARCH_COMPAT:
-		*val = get_reg_val(id, vcpu->arch.vcore->arch_compat);
+		*val = get_reg_val(id, kvmppc_get_arch_compat(vcpu));
 		break;
 	case KVM_REG_PPC_DEC_EXPIRY:
 		*val = get_reg_val(id, kvmppc_get_dec_expires(vcpu));
@@ -2523,7 +2523,7 @@ static int kvmppc_set_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 			vcpu->arch.vcore->dpdes = set_reg_val(id, *val);
 		break;
 	case KVM_REG_PPC_VTB:
-		vcpu->arch.vcore->vtb = set_reg_val(id, *val);
+		kvmppc_set_vtb(vcpu, set_reg_val(id, *val));
 		break;
 	case KVM_REG_PPC_DAWR:
 		vcpu->arch.dawr0 = set_reg_val(id, *val);
@@ -2606,10 +2606,11 @@ static int kvmppc_set_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 		 * decrementer, which is better than a large one that
 		 * causes a hang.
 		 */
+		kvmppc_set_tb_offset(vcpu, tb_offset);
 		if (!kvmppc_get_dec_expires(vcpu) && tb_offset)
 			kvmppc_set_dec_expires(vcpu, get_tb() + tb_offset);
 
-		vcpu->arch.vcore->tb_offset = tb_offset;
+		kvmppc_set_tb_offset(vcpu, tb_offset);
 		break;
 	}
 	case KVM_REG_PPC_LPCR:
@@ -4042,7 +4043,6 @@ static void vcpu_vpa_increment_dispatch(struct kvm_vcpu *vcpu)
 /* call our hypervisor to load up HV regs and go */
 static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpcr, u64 *tb)
 {
-	struct kvmppc_vcore *vc = vcpu->arch.vcore;
 	unsigned long host_psscr;
 	unsigned long msr;
 	struct hv_guest_state hvregs;
@@ -4122,7 +4122,7 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
 	if (!(lpcr & LPCR_LD)) /* Sign extend if not using large decrementer */
 		dec = (s32) dec;
 	*tb = mftb();
-	vcpu->arch.dec_expires = dec + (*tb + vc->tb_offset);
+	vcpu->arch.dec_expires = dec + (*tb + kvmppc_get_tb_offset(vcpu));
 
 	timer_rearm_host_dec(*tb);
 
@@ -4681,7 +4681,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	tb = mftb();
 
-	kvmppc_update_vpa_dispatch_p9(vcpu, vc, tb + vc->tb_offset);
+	kvmppc_update_vpa_dispatch_p9(vcpu, vc, tb + kvmppc_get_tb_offset(vcpu));
 
 	trace_kvm_guest_enter(vcpu);
 
diff --git a/arch/powerpc/kvm/book3s_hv_ras.c b/arch/powerpc/kvm/book3s_hv_ras.c
index 82be6d87514b..9012acadbca8 100644
--- a/arch/powerpc/kvm/book3s_hv_ras.c
+++ b/arch/powerpc/kvm/book3s_hv_ras.c
@@ -174,14 +174,14 @@ long kvmppc_p9_realmode_hmi_handler(struct kvm_vcpu *vcpu)
 		ppc_md.hmi_exception_early(NULL);
 
 out:
-	if (vc->tb_offset) {
+	if (kvmppc_get_tb_offset(vcpu)) {
 		u64 new_tb = mftb() + vc->tb_offset;
 		mtspr(SPRN_TBU40, new_tb);
 		if ((mftb() & 0xffffff) < (new_tb & 0xffffff)) {
 			new_tb += 0x1000000;
 			mtspr(SPRN_TBU40, new_tb);
 		}
-		vc->tb_offset_applied = vc->tb_offset;
+		vc->tb_offset_applied = kvmppc_get_tb_offset(vcpu);
 	}
 
 	return ret;
diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
index 48d11baf1f16..24d8378824a2 100644
--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -2779,8 +2779,6 @@ static int kvmppc_xive_create(struct kvm_device *dev, u32 type)
 
 int kvmppc_xive_xics_hcall(struct kvm_vcpu *vcpu, u32 req)
 {
-	struct kvmppc_vcore *vc = vcpu->arch.vcore;
-
 	/* The VM should have configured XICS mode before doing XICS hcalls. */
 	if (!kvmppc_xics_enabled(vcpu))
 		return H_TOO_HARD;
@@ -2799,7 +2797,7 @@ int kvmppc_xive_xics_hcall(struct kvm_vcpu *vcpu, u32 req)
 		return xive_vm_h_ipoll(vcpu, kvmppc_get_gpr(vcpu, 4));
 	case H_XIRR_X:
 		xive_vm_h_xirr(vcpu);
-		kvmppc_set_gpr(vcpu, 5, get_tb() + vc->tb_offset);
+		kvmppc_set_gpr(vcpu, 5, get_tb() + kvmppc_get_tb_offset(vcpu));
 		return H_SUCCESS;
 	}
 
-- 
2.39.3

