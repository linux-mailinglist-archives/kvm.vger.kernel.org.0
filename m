Return-Path: <kvm+bounces-70670-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gL2BIkFjiml6JwAAu9opvQ
	(envelope-from <kvm+bounces-70670-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 23:44:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AA9761152C8
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 23:44:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2C0E83006D4A
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 22:44:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9B61317708;
	Mon,  9 Feb 2026 22:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0jpCZ02K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50FA163
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 22:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770677050; cv=none; b=nXxoFd4pSO4CIbWov2hp3UGhrZN7KkuBBE4pSc1Z9AlBkEUdE47mdupkjnz09SP3+sV1GI3yUPjXHgf6MPXKCdORWEO8XEM5TXanes/4WqqVcDlqGqK5u7qv2cg9vTA9GdFTu9sHLtdgaICeTOD83x4hjNyRE998YBmgzmvsBIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770677050; c=relaxed/simple;
	bh=zWxiZJzGj9w/FwWNuWuEIWHGT8CC9AJy642cr1BpNdI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mrOBb4Wi2u5UY6jrkfmSF58O0fQXe8TqOWR/lreya157Asm0Kn3+piN8tRCg4ygV/OFJamdZ74dpgmImEJt23fJTWVZreAYWoHU3aoG5jkFmCLjIO/mHtgds8lOzqFACmr24QGyEJQ/C7wLoYGlCqNEATH0AREQrqz65xYA/3Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0jpCZ02K; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c337cde7e40so162699a12.1
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 14:44:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770677048; x=1771281848; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FPO/fWm5jQP9a1ozWUx55PdnqkVaeN/hr74kjnPGk60=;
        b=0jpCZ02KJkk2b/rr01PiYe2Hh1BSqj9kt1EmVfJmwaqiE3oEUuKYZlQIlJjV9vTQru
         CbVijld0tgqUtM1xaZJPMl7/4F5LAXv2B3Ug9J8GdGApnBc6fmDrJ7Z/htU5U7tt5jRi
         kA4pggUoe1FaCC6PLDDZCiVodI15MXstt3Pt5MbBKw//lFM46KeuHS5jTic20tny2ln7
         aaMz1Uyq+Q3GlGoPnRACVXTvTOZsTuZn15zMsFteqQHMMBn04VaBBFUEgNriF1ODo9AG
         SAMWqywU5TTbirkj1dKri4S4/Kr+MyD205Et7x5oIEz0yBtstC5ZPz1uUVwNCGh/qL7n
         D5fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770677048; x=1771281848;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FPO/fWm5jQP9a1ozWUx55PdnqkVaeN/hr74kjnPGk60=;
        b=Rdsl8ubDdIj49lKz4qeaQaU4NYkv/+r6h8avcTgxxm9FQdBiOwQ7bIMqow2AWTJ573
         Mh0OpMyMmQ7UMuSEytu/XkMrCDR+cvgWNCjJ9avTQKpMd204MYa6+2i2gdjcZrTjHC2c
         7Iq7IkYfeCfBcPnAVaCLBcauccrdERn509YADOGHwwEfYxDB3i/FmDZtGOw0sh9gz3Wi
         eu+Kml6RpnvH7+qppvuzogMtY1gsybIspbYx3DohsUaQHHY9dKJVrWoo99BcdHbVI7TI
         viGT7Wd59X0ZPyZZlPfTOoY475OM8E167o1+5YYVGPy7RgVR7WIGoqS6/2PXmc6HIx17
         LS6A==
X-Forwarded-Encrypted: i=1; AJvYcCWpZGrh8f9yC8J9Cqdjqdv9uGf38rpDkNaJDsvQVup1Uf7+4LJ9umekMU4ZIvfoB2hF/ok=@vger.kernel.org
X-Gm-Message-State: AOJu0YwO92OaiJMEBF8SxpJGj0jpoC8y6Cqo5Aufj0i461Tw5oCfowL6
	/ycGOnypDziKifokpy7PrrWNL0iAIZHJeAkw77tKw3pbRoKX8WLHQB2AH9DyH3EBa/u1ShMeTP8
	6pX+LwQ==
X-Received: from pgam8.prod.google.com ([2002:a05:6a02:2b48:b0:c65:c4d1:9d34])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:e598:b0:38d:f745:4d5f
 with SMTP id adf61e73a8af0-393ad002eafmr11865271637.24.1770677048064; Mon, 09
 Feb 2026 14:44:08 -0800 (PST)
Date: Mon, 9 Feb 2026 14:44:06 -0800
In-Reply-To: <c753636171f82c3b6d64e7734be3a70c60775546.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com> <20260129011517.3545883-21-seanjc@google.com>
 <aYW5CbUvZrLogsWF@yzhao56-desk.sh.intel.com> <aYYCOiMvWfSJR1AL@google.com> <c753636171f82c3b6d64e7734be3a70c60775546.camel@intel.com>
Message-ID: <aYpjNrtGmogNzqwT@google.com>
Subject: Re: [RFC PATCH v5 20/45] KVM: x86/mmu: Allocate/free S-EPT pages
 using tdx_{alloc,free}_control_page()
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: Yan Y Zhao <yan.y.zhao@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com" <ackerleytng@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"sagis@google.com" <sagis@google.com>, "tglx@kernel.org" <tglx@kernel.org>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, 
	Vishal Annapurve <vannapurve@google.com>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70670-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[19];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: AA9761152C8
X-Rspamd-Action: no action

On Mon, Feb 09, 2026, Kai Huang wrote:
> > Option #2 would be to immediately free the page in tdx_sept_reclaim_private_sp(),
> > so that pages that freed via handle_removed_pt() don't defer freeing the S-EPT
> > page table (which, IIUC, is safe since the TDX-Module forces TLB flushes and exits).
> > 
> > I really, really don't like this option (if it even works).
> > 
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index ae7b9beb3249..4726011ad624 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -2014,7 +2014,15 @@ static void tdx_sept_reclaim_private_sp(struct kvm *kvm, gfn_t gfn,
> >          */
> >         if (KVM_BUG_ON(is_hkid_assigned(to_kvm_tdx(kvm)), kvm) ||
> >             tdx_reclaim_page(virt_to_page(sp->external_spt)))
> > -               sp->external_spt = NULL;
> > +               goto out;
> > +
> > +       /*
> > +        * Immediately free the control page, as the TDX subsystem doesn't
> > +        * support freeing pages from RCU callbacks.
> > +        */
> > +       tdx_free_control_page((unsigned long)sp->external_spt);
> > +out:
> > +       sp->external_spt = NULL;
> >  }
> >  
> >  void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
> 
> I don't think this is so bad, given we already have a bunch of
> 
> 	is_mirror_sp(sp)
> 		kvm_x86_call(xx_external_spt)(..);
> 
> in TDP MMU code?
> 
> I suppose this won't make a lot of difference, but does below make you
> slightly happier?

Heh, slightly, but I still don't love it :-D

> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 3181406c5e0b..3588265098a8 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -55,8 +55,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
>  
>  static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
>  {
> -       if (sp->external_spt)
> -               kvm_x86_call(free_external_sp)((unsigned long)sp-
> >external_spt);
> +       WARN_ON_ONCE(sp->external_spt);

Doesn't work, because sp->external_spt will be non-NULL when KVM is freeing
unused pages in tdp_mmu_split_huge_pages_root() and kvm_tdp_mmu_map().  That's
solvable, but it's part of the asymmetry I don't love.  AFAICT, unless we do
something truly awful, there's no way to avoid having common KVM free unused
S-EPT pages.

That said, while I don't love the asymmetry, it's not a deal breaker, especially
if we make the asymmetry super obvious and cleanly delineated.  Specifically, if
we differentiate between freeing unused page tables and freeing used (linked at
any point) page tables.

This would also allow us to address the naming than Yan doesn't like around
reclaim_external_sp(), because we could have both free_external_sp() and
free_unused_external_spt(), where the lack of "unused" gives the reader a hint
that there's interesting work to be done for in-use external page tables.

This won't apply cleanly due to other fixups.  It's also at:

  https://github.com/sean-jc/linux.git x86/tdx_huge_sept

---
 arch/x86/include/asm/kvm-x86-ops.h |  8 ++++----
 arch/x86/include/asm/kvm_host.h    | 10 +++++-----
 arch/x86/kvm/mmu/mmu.c             |  4 ++--
 arch/x86/kvm/mmu/tdp_mmu.c         | 27 +++++++++++++++++----------
 arch/x86/kvm/vmx/tdx.c             | 22 +++++++++++++++-------
 5 files changed, 43 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 87826176fa8d..9593d8d97f6b 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -94,11 +94,11 @@ KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
 KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
 KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
 KVM_X86_OP(load_mmu_pgd)
-KVM_X86_OP_OPTIONAL(alloc_external_sp)
-KVM_X86_OP_OPTIONAL(free_external_sp)
-KVM_X86_OP_OPTIONAL_RET0(set_external_spte)
-KVM_X86_OP_OPTIONAL(reclaim_external_sp)
+KVM_X86_OP_OPTIONAL_RET0(alloc_external_spt)
+KVM_X86_OP_OPTIONAL(free_external_spt)
+KVM_X86_OP_OPTIONAL(free_unused_external_spt)
 KVM_X86_OP_OPTIONAL_RET0(topup_private_mapping_cache)
+KVM_X86_OP_OPTIONAL_RET0(set_external_spte)
 KVM_X86_OP(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
 KVM_X86_OP(get_l2_tsc_multiplier)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7ff72c04d575..5fc25508548b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1855,13 +1855,13 @@ struct kvm_x86_ops {
 	 * and to propagate changes in mirror page tables to the external page
 	 * tables.
 	 */
-	unsigned long (*alloc_external_sp)(gfp_t gfp);
-	void (*free_external_sp)(unsigned long addr);
+	unsigned long (*alloc_external_spt)(gfp_t gfp);
+	void (*free_external_spt)(struct kvm *kvm, gfn_t gfn,
+				  struct kvm_mmu_page *sp);
+	void (*free_unused_external_spt)(unsigned long external_spt);
+	int (*topup_private_mapping_cache)(struct kvm *kvm, struct kvm_vcpu *vcpu);
 	int (*set_external_spte)(struct kvm *kvm, gfn_t gfn, u64 old_spte,
 				 u64 new_spte, enum pg_level level);
-	void (*reclaim_external_sp)(struct kvm *kvm, gfn_t gfn,
-				    struct kvm_mmu_page *sp);
-	int (*topup_private_mapping_cache)(struct kvm *kvm, struct kvm_vcpu *vcpu);
 
 	bool (*has_wbinvd_exit)(void);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6a911aec075b..2ad417ac6e1f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6714,8 +6714,8 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 	if (!vcpu->arch.mmu_shadow_page_cache.init_value)
 		vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
 
-	vcpu->arch.mmu_external_spt_cache.page_get = kvm_x86_ops.alloc_external_sp;
-	vcpu->arch.mmu_external_spt_cache.page_free = kvm_x86_ops.free_external_sp;
+	vcpu->arch.mmu_external_spt_cache.page_get = kvm_x86_ops.alloc_external_spt;
+	vcpu->arch.mmu_external_spt_cache.page_free = kvm_x86_ops.free_unused_external_spt;
 
 	vcpu->arch.mmu = &vcpu->arch.root_mmu;
 	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index b7c13316181b..d43db86b12a7 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -53,12 +53,18 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 	rcu_barrier();
 }
 
-static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
+static void __tdp_mmu_free_sp(struct kvm_mmu_page *sp)
+{
+	free_page((unsigned long)sp->spt);
+	kmem_cache_free(mmu_page_header_cache, sp);
+}
+
+static void tdp_mmu_free_unused_sp(struct kvm_mmu_page *sp)
 {
 	if (sp->external_spt)
-		kvm_x86_call(free_external_sp)((unsigned long)sp->external_spt);
-	free_page((unsigned long)sp->spt);
-	kmem_cache_free(mmu_page_header_cache, sp);
+		kvm_x86_call(free_unused_external_spt)((unsigned long)sp->external_spt);
+
+	__tdp_mmu_free_sp(sp);
 }
 
 /*
@@ -74,7 +80,8 @@ static void tdp_mmu_free_sp_rcu_callback(struct rcu_head *head)
 	struct kvm_mmu_page *sp = container_of(head, struct kvm_mmu_page,
 					       rcu_head);
 
-	tdp_mmu_free_sp(sp);
+	WARN_ON_ONCE(sp->external_spt);
+	__tdp_mmu_free_sp(sp);
 }
 
 void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
@@ -458,7 +465,7 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 	}
 
 	if (is_mirror_sp(sp))
-		kvm_x86_call(reclaim_external_sp)(kvm, base_gfn, sp);
+		kvm_x86_call(free_external_spt)(kvm, base_gfn, sp);
 
 	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
 }
@@ -1266,7 +1273,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		 * failed, e.g. because a different task modified the SPTE.
 		 */
 		if (r) {
-			tdp_mmu_free_sp(sp);
+			tdp_mmu_free_unused_sp(sp);
 			goto retry;
 		}
 
@@ -1461,7 +1468,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 		goto err_spt;
 
 	if (is_mirror_sp) {
-		sp->external_spt = (void *)kvm_x86_call(alloc_external_sp)(GFP_KERNEL_ACCOUNT);
+		sp->external_spt = (void *)kvm_x86_call(alloc_external_spt)(GFP_KERNEL_ACCOUNT);
 		if (!sp->external_spt)
 			goto err_external_spt;
 
@@ -1472,7 +1479,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 	return sp;
 
 err_external_split:
-	kvm_x86_call(free_external_sp)((unsigned long)sp->external_spt);
+	kvm_x86_call(free_unused_external_spt)((unsigned long)sp->external_spt);
 err_external_spt:
 	free_page((unsigned long)sp->spt);
 err_spt:
@@ -1594,7 +1601,7 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 	 * installs its own sp in place of the last sp we tried to split.
 	 */
 	if (sp)
-		tdp_mmu_free_sp(sp);
+		tdp_mmu_free_unused_sp(sp);
 
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 957fa59e9a65..aae7af26fe02 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1994,8 +1994,8 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
 	return tdx_sept_map_leaf_spte(kvm, gfn, new_spte, level);
 }
 
-static void tdx_sept_reclaim_private_sp(struct kvm *kvm, gfn_t gfn,
-					struct kvm_mmu_page *sp)
+static void tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
+				      struct kvm_mmu_page *sp)
 {
 	/*
 	 * KVM doesn't (yet) zap page table pages in mirror page table while
@@ -2013,7 +2013,16 @@ static void tdx_sept_reclaim_private_sp(struct kvm *kvm, gfn_t gfn,
 	 */
 	if (KVM_BUG_ON(is_hkid_assigned(to_kvm_tdx(kvm)), kvm) ||
 	    tdx_reclaim_page(virt_to_page(sp->external_spt)))
-		sp->external_spt = NULL;
+		goto out;
+
+	/*
+	 * Immediately free the S-EPT page as the TDX subsystem doesn't support
+	 * freeing pages from RCU callbacks, and more importantly because
+	 * TDH.PHYMEM.PAGE.RECLAIM ensures there are no outstanding readers.
+	 */
+	tdx_free_control_page((unsigned long)sp->external_spt);
+out:
+	sp->external_spt = NULL;
 }
 
 void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
@@ -3874,11 +3883,10 @@ void __init tdx_hardware_setup(void)
 	 * initialize the page (using the guest's encryption key), and (b) need
 	 * to use a custom allocator to be compatible with Dynamic PAMT.
 	 */
-	vt_x86_ops.alloc_external_sp = tdx_alloc_control_page;
-	vt_x86_ops.free_external_sp = tdx_free_control_page;
-
+	vt_x86_ops.alloc_external_spt = tdx_alloc_control_page;
+	vt_x86_ops.free_unused_external_spt = tdx_free_control_page;
+	vt_x86_ops.free_external_spt = tdx_sept_free_private_spt;
 	vt_x86_ops.set_external_spte = tdx_sept_set_private_spte;
-	vt_x86_ops.reclaim_external_sp = tdx_sept_reclaim_private_sp;
 
 	vt_x86_ops.gmem_convert = tdx_gmem_convert;
 

base-commit: 0191132f233a66b5cb1ae9a09c18c6d6669c284a
--

