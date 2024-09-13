Return-Path: <kvm+bounces-26842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 43A6D978698
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 19:23:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C42241F25D68
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 17:23:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 744CD823A9;
	Fri, 13 Sep 2024 17:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kMZUTS2n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4EABE68
	for <kvm@vger.kernel.org>; Fri, 13 Sep 2024 17:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726248184; cv=none; b=NPYx+UP/mQyrzgaU9Wq3QjPs/br5E4jHq91QM29oICyyIloAI8YEHpITcS7CHm3d31RxVp8/8ZbrgTB6iYQhZ5PW2V3wGmx9ZiP7eY6vxZKH6dPqmM7dcq53ZeuRExqNRTzJdWyAW09vRcF5ChsktWJeatWhMJgE/pJkxieNOiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726248184; c=relaxed/simple;
	bh=oRkocJSd/7+lOuq/Aj61DDshaRehSqcZE15uZ57g48M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=u+Z8669y8GOaMUKbfMNjMJ2Uf+/vAdhGDIwkYt0X+8jh3WXKpOvElbTRTwMSSBKJUPe3cEDEyn+fWJAKZi1fRusROy3oj5sEZecoFPgOd6+VH4qOQLCzuhFe6cnkzAhcVC2zetg151dlGAnkBXq6I+wZA3RQG4ZmizTDiE/w/cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kMZUTS2n; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7d235d55c41so1372009a12.0
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2024 10:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726248182; x=1726852982; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wT+cOzEvcG5FJbo1fU+OYHQAxhT9UkXErX1ndZGNr/0=;
        b=kMZUTS2nrYqiFEzzXSeKXPrrgobivB6i+IuOUagxPNzy+xuot1Qf80rplpq7KlSfU2
         mbWpzhzZcEkZe0FGGD6ZuNRHeDrk7+Z1Z15k2c8IM6kNn3mQ1m9uFDmNBfGuArrBVck4
         ggsUDVcLlsigN+lgZ067EJlk2ZMlFfhHjIogPipC0ezBVTDfbsIQPeEhnBm4K4lA/WCp
         GZM7tyMouWXdetSQ6Nm/XBqj81CDPgi4BTgGIubNhWh+NfzENEj6jJ+7iFmq5mnkzNgS
         onVZeR1q0+McTt3cY34A8UALW+rcro6Xg0N/BrwtpY0Qpkrd3DKmEdLfg6uwHMEfRgrg
         ilJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726248182; x=1726852982;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wT+cOzEvcG5FJbo1fU+OYHQAxhT9UkXErX1ndZGNr/0=;
        b=reHrgwDOfdaYvbVonZsdssXzZpdszVqhshTT1q8JfikBJBcUi17VEoNOEaXgaZ8RLV
         40kfh58J1G1CUwLeVLkYgpfS+N09R+46z4zkhYe1H8vdJ8UWb3dskxBPJVU1hLMtxruq
         K7imkmviDvVDf/BsrL3ch+zREl4adcv811cYfwIl3BBmUNKsXerIbERJJWV54+A2YvhR
         76szYW5NsuuhWqJTRwoYTHACEWQNumRGRxmhZI9NfXC1r+5IgwJx62azTukCL108nDkI
         m4F23AzRjAw47Vy5PE5YWQ8Izth3pxBPW6RvvpjIBOwR/ANDk9taqhjhcXpWI5QJ0qqs
         1BZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVLRptf8OhGeB5wnvxc5RE8x4yHXO3GS8Oj/Ev7JH4N19hWr2JCeYC77xipFmO3/vef6z0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrFbkMFB+D0IxibcxlFcbsGhc1IpxABMMp7BkecJ3vefuB97vr
	n5ltUN4//kHUI9XL2t8rb0YOuXzTDnCWRkR/VCUqgFkqJ5SPMTq0Pkb0ZWmhK6YsYguWu3luECw
	hmw==
X-Google-Smtp-Source: AGHT+IHw+cTGHlKYQRf5nJBmRxFXQ4dq11AW/LKUU4aY68mu8lAywm+kQXeXAdqpiw1qAoMzo6VA/cjdk8Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2302:b0:206:a6c5:d2a5 with SMTP id
 d9443c01a7336-20782bc1d2amr1943625ad.11.1726248181980; Fri, 13 Sep 2024
 10:23:01 -0700 (PDT)
Date: Fri, 13 Sep 2024 10:23:00 -0700
In-Reply-To: <ZuP5eNXFCljzRgWo@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <6449047b-2783-46e1-b2a9-2043d192824c@redhat.com>
 <b012360b4d14c0389bcb77fc8e9e5d739c6cc93d.camel@intel.com>
 <Zt9kmVe1nkjVjoEg@google.com> <1bbe3a78-8746-4db9-a96c-9dc5f1190f16@redhat.com>
 <ZuBQYvY6Ib4ZYBgx@google.com> <CABgObfayLGyWKERXkU+0gjeUg=Sp3r7GEQU=+13sUMpo36weWg@mail.gmail.com>
 <ZuBsTlbrlD6NHyv1@google.com> <655170f6a09ad892200cd033efe5498a26504fec.camel@intel.com>
 <ZuCE_KtmXNi0qePb@google.com> <ZuP5eNXFCljzRgWo@yzhao56-desk.sh.intel.com>
Message-ID: <ZuR09EqzU1WbQYGd@google.com>
Subject: Re: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with
 operand SEPT
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Yuan Yao <yuan.yao@intel.com>, Kai Huang <kai.huang@intel.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"dmatlack@google.com" <dmatlack@google.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Sep 13, 2024, Yan Zhao wrote:
> This is a lock status report of TDX module for current SEAMCALL retry issue
> based on code in TDX module public repo https://github.com/intel/tdx-module.git
> branch TDX_1.5.05.
> 
> TL;DR:
> - tdh_mem_track() can contend with tdh_vp_enter().
> - tdh_vp_enter() contends with tdh_mem*() when 0-stepping is suspected.

The zero-step logic seems to be the most problematic.  E.g. if KVM is trying to
install a page on behalf of two vCPUs, and KVM resumes the guest if it encounters
a FROZEN_SPTE when building the non-leaf SPTEs, then one of the vCPUs could
trigger the zero-step mitigation if the vCPU that "wins" and gets delayed for
whatever reason.

Since FROZEN_SPTE is essentially bit-spinlock with a reaaaaaly slow slow-path,
what if instead of resuming the guest if a page fault hits FROZEN_SPTE, KVM retries
the fault "locally", i.e. _without_ redoing tdh_vp_enter() to see if the vCPU still
hits the fault?

For non-TDX, resuming the guest and letting the vCPU retry the instruction is
desirable because in many cases, the winning task will install a valid mapping
before KVM can re-run the vCPU, i.e. the fault will be fixed before the
instruction is re-executed.  In the happy case, that provides optimal performance
as KVM doesn't introduce any extra delay/latency.

But for TDX, the math is different as the cost of a re-hitting a fault is much,
much higher, especially in light of the zero-step issues.

E.g. if the TDP MMU returns a unique error code for the frozen case, and
kvm_mmu_page_fault() is modified to return the raw return code instead of '1',
then the TDX EPT violation path can safely retry locally, similar to the do-while
loop in kvm_tdp_map_page().

The only part I don't like about this idea is having two "retry" return values,
which creates the potential for bugs due to checking one but not the other.

Hmm, that could be avoided by passing a bool pointer as an out-param to communicate
to the TDX S-EPT fault handler that the SPTE is frozen.  I think I like that
option better even though the out-param is a bit gross, because it makes it more
obvious that the "frozen_spte" is a special case that doesn't need attention for
most paths.

> - tdg_mem_page_accept() can contend with other tdh_mem*().
> 
> Proposal:
> - Return -EAGAIN directly in ops link_external_spt/set_external_spte when
>   tdh_mem_sept_add()/tdh_mem_page_aug() returns BUSY.

What is the result of returning -EAGAIN?  E.g. does KVM redo tdh_vp_enter()?

Also tdh_mem_sept_add() is strictly pre-finalize, correct?  I.e. should never
contend with tdg_mem_page_accept() because vCPUs can't yet be run.

Similarly, can tdh_mem_page_aug() actually contend with tdg_mem_page_accept()?
The page isn't yet mapped, so why would the guest be allowed to take a lock on
the S-EPT entry?

> - Kick off vCPUs at the beginning of page removal path, i.e. before the
>   tdh_mem_range_block().
>   Set a flag and disallow tdh_vp_enter() until tdh_mem_page_remove() is done.

This is easy enough to do via a request, e.g. see KVM_REQ_MCLOCK_INPROGRESS.

>   (one possible optimization:
>    since contention from tdh_vp_enter()/tdg_mem_page_accept should be rare,
>    do not kick off vCPUs in normal conditions.
>    When SEAMCALL BUSY happens, retry for once, kick off vCPUs and do not allow

Which SEAMCALL is this specifically?  tdh_mem_range_block()?

>    TD enter until page removal completes.)


Idea #1:
---
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b45258285c9c..8113c17bd2f6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4719,7 +4719,7 @@ static int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
                        return -EINTR;
                cond_resched();
                r = kvm_mmu_do_page_fault(vcpu, gpa, error_code, true, NULL, level);
-       } while (r == RET_PF_RETRY);
+       } while (r == RET_PF_RETRY || r == RET_PF_RETRY_FOZEN);
 
        if (r < 0)
                return r;
@@ -6129,7 +6129,7 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
                vcpu->stat.pf_spurious++;
 
        if (r != RET_PF_EMULATE)
-               return 1;
+               return r;
 
 emulate:
        return x86_emulate_instruction(vcpu, cr2_or_gpa, emulation_type, insn,
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 8d3fb3c8c213..690f03d7daae 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -256,12 +256,15 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
  * and of course kvm_mmu_do_page_fault().
  *
  * RET_PF_CONTINUE: So far, so good, keep handling the page fault.
+ * RET_PF_FIXED: The faulting entry has been fixed.
  * RET_PF_RETRY: let CPU fault again on the address.
+ * RET_PF_RETRY_FROZEN: One or more SPTEs related to the address is frozen.
+ *                     Let the CPU fault again on the address, or retry the
+ *                     fault "locally", i.e. without re-entering the guest.
  * RET_PF_EMULATE: mmio page fault, emulate the instruction directly.
  * RET_PF_WRITE_PROTECTED: the gfn is write-protected, either unprotected the
  *                         gfn and retry, or emulate the instruction directly.
  * RET_PF_INVALID: the spte is invalid, let the real page fault path update it.
- * RET_PF_FIXED: The faulting entry has been fixed.
  * RET_PF_SPURIOUS: The faulting entry was already fixed, e.g. by another vCPU.
  *
  * Any names added to this enum should be exported to userspace for use in
@@ -271,14 +274,18 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
  * on -errno return values.  Somewhat arbitrarily use '0' for CONTINUE, which
  * will allow for efficient machine code when checking for CONTINUE, e.g.
  * "TEST %rax, %rax, JNZ", as all "stop!" values are non-zero.
+ *
+ * Note #2, RET_PF_FIXED _must_ be '1', so that KVM's -errno/0/1 return code
+ * scheme, where 1==success, translates '1' to RET_PF_FIXED.
  */
 enum {
        RET_PF_CONTINUE = 0,
+       RET_PF_FIXED    = 1,
        RET_PF_RETRY,
+       RET_PF_RETRY_FROZEN,
        RET_PF_EMULATE,
        RET_PF_WRITE_PROTECTED,
        RET_PF_INVALID,
-       RET_PF_FIXED,
        RET_PF_SPURIOUS,
 };
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 5a475a6456d4..cbf9e46203f3 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1174,6 +1174,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
 retry:
        rcu_read_unlock();
+       if (ret == RET_PF_RETRY && is_frozen_spte(iter.old_spte))
+               return RET_PF_RETRY_FOZEN;
        return ret;
 }
 
---


Idea #2:
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/mmu/mmu.c          | 12 ++++++------
 arch/x86/kvm/mmu/mmu_internal.h | 15 ++++++++++++---
 arch/x86/kvm/mmu/tdp_mmu.c      |  1 +
 arch/x86/kvm/svm/svm.c          |  2 +-
 arch/x86/kvm/vmx/vmx.c          |  4 ++--
 6 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 46e0a466d7fb..200fecd1de88 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2183,7 +2183,7 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
 
 int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
-		       void *insn, int insn_len);
+		       void *insn, int insn_len, bool *frozen_spte);
 void kvm_mmu_print_sptes(struct kvm_vcpu *vcpu, gpa_t gpa, const char *msg);
 void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva);
 void kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b45258285c9c..207840a316d3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4283,7 +4283,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 		return;
 
 	r = kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, work->arch.error_code,
-				  true, NULL, NULL);
+				  true, NULL, NULL, NULL);
 
 	/*
 	 * Account fixed page faults, otherwise they'll never be counted, but
@@ -4627,7 +4627,7 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 		trace_kvm_page_fault(vcpu, fault_address, error_code);
 
 		r = kvm_mmu_page_fault(vcpu, fault_address, error_code, insn,
-				insn_len);
+				       insn_len, NULL);
 	} else if (flags & KVM_PV_REASON_PAGE_NOT_PRESENT) {
 		vcpu->arch.apf.host_apf_flags = 0;
 		local_irq_disable();
@@ -4718,7 +4718,7 @@ static int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
 		if (signal_pending(current))
 			return -EINTR;
 		cond_resched();
-		r = kvm_mmu_do_page_fault(vcpu, gpa, error_code, true, NULL, level);
+		r = kvm_mmu_do_page_fault(vcpu, gpa, error_code, true, NULL, level, NULL);
 	} while (r == RET_PF_RETRY);
 
 	if (r < 0)
@@ -6073,7 +6073,7 @@ static int kvm_mmu_write_protect_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 }
 
 int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
-		       void *insn, int insn_len)
+				void *insn, int insn_len, bool *frozen_spte)
 {
 	int r, emulation_type = EMULTYPE_PF;
 	bool direct = vcpu->arch.mmu->root_role.direct;
@@ -6109,7 +6109,7 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 		vcpu->stat.pf_taken++;
 
 		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa, error_code, false,
-					  &emulation_type, NULL);
+					  &emulation_type, NULL, frozen_spte);
 		if (KVM_BUG_ON(r == RET_PF_INVALID, vcpu->kvm))
 			return -EIO;
 	}
@@ -6129,7 +6129,7 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 		vcpu->stat.pf_spurious++;
 
 	if (r != RET_PF_EMULATE)
-		return 1;
+		return r;
 
 emulate:
 	return x86_emulate_instruction(vcpu, cr2_or_gpa, emulation_type, insn,
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 8d3fb3c8c213..5b1fc77695c1 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -247,6 +247,9 @@ struct kvm_page_fault {
 	 * is changing its own translation in the guest page tables.
 	 */
 	bool write_fault_to_shadow_pgtable;
+
+	/* Indicates the page fault needs to be retried due to a frozen SPTE. */
+	bool frozen_spte;
 };
 
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
@@ -256,12 +259,12 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
  * and of course kvm_mmu_do_page_fault().
  *
  * RET_PF_CONTINUE: So far, so good, keep handling the page fault.
+ * RET_PF_FIXED: The faulting entry has been fixed.
  * RET_PF_RETRY: let CPU fault again on the address.
  * RET_PF_EMULATE: mmio page fault, emulate the instruction directly.
  * RET_PF_WRITE_PROTECTED: the gfn is write-protected, either unprotected the
  *                         gfn and retry, or emulate the instruction directly.
  * RET_PF_INVALID: the spte is invalid, let the real page fault path update it.
- * RET_PF_FIXED: The faulting entry has been fixed.
  * RET_PF_SPURIOUS: The faulting entry was already fixed, e.g. by another vCPU.
  *
  * Any names added to this enum should be exported to userspace for use in
@@ -271,14 +274,17 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
  * on -errno return values.  Somewhat arbitrarily use '0' for CONTINUE, which
  * will allow for efficient machine code when checking for CONTINUE, e.g.
  * "TEST %rax, %rax, JNZ", as all "stop!" values are non-zero.
+ *
+ * Note #2, RET_PF_FIXED _must_ be '1', so that KVM's -errno/0/1 return code
+ * scheme, where 1==success, translates '1' to RET_PF_FIXED.
  */
 enum {
 	RET_PF_CONTINUE = 0,
+	RET_PF_FIXED    = 1,
 	RET_PF_RETRY,
 	RET_PF_EMULATE,
 	RET_PF_WRITE_PROTECTED,
 	RET_PF_INVALID,
-	RET_PF_FIXED,
 	RET_PF_SPURIOUS,
 };
 
@@ -292,7 +298,8 @@ static inline void kvm_mmu_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
 
 static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 					u64 err, bool prefetch,
-					int *emulation_type, u8 *level)
+					int *emulation_type, u8 *level,
+					bool *frozen_spte)
 {
 	struct kvm_page_fault fault = {
 		.addr = cr2_or_gpa,
@@ -341,6 +348,8 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		*emulation_type |= EMULTYPE_WRITE_PF_TO_SP;
 	if (level)
 		*level = fault.goal_level;
+	if (frozen_spte)
+		*frozen_spte = fault.frozen_spte;
 
 	return r;
 }
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 5a475a6456d4..e7fc5ea4b437 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1174,6 +1174,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
 retry:
 	rcu_read_unlock();
+	fault->frozen_spte = is_frozen_spte(iter.old_spte);
 	return ret;
 }
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 38723b0c435d..269de6a9eb13 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2075,7 +2075,7 @@ static int npf_interception(struct kvm_vcpu *vcpu)
 	rc = kvm_mmu_page_fault(vcpu, fault_address, error_code,
 				static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
 				svm->vmcb->control.insn_bytes : NULL,
-				svm->vmcb->control.insn_len);
+				svm->vmcb->control.insn_len, NULL);
 
 	if (rc > 0 && error_code & PFERR_GUEST_RMP_MASK)
 		sev_handle_rmp_fault(vcpu, fault_address, error_code);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 368acfebd476..fc2ff5d91a71 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5822,7 +5822,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 	if (unlikely(allow_smaller_maxphyaddr && !kvm_vcpu_is_legal_gpa(vcpu, gpa)))
 		return kvm_emulate_instruction(vcpu, 0);
 
-	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
+	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0, NULL);
 }
 
 static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
@@ -5843,7 +5843,7 @@ static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
 		return kvm_skip_emulated_instruction(vcpu);
 	}
 
-	return kvm_mmu_page_fault(vcpu, gpa, PFERR_RSVD_MASK, NULL, 0);
+	return kvm_mmu_page_fault(vcpu, gpa, PFERR_RSVD_MASK, NULL, 0, NULL);
 }
 
 static int handle_nmi_window(struct kvm_vcpu *vcpu)

base-commit: bc87a2b4b5508d247ed2c30cd2829969d168adfe
-- 


