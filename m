Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 307D02B18C
	for <lists+kvm@lfdr.de>; Mon, 27 May 2019 11:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbfE0Jr1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 05:47:27 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33032 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbfE0Jr1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 May 2019 05:47:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Ksp3G9sH2zzACmF2AeSPcK5YcZQtsXat2Vj9aWQQG+U=; b=P48Ta44XCwnjYxzE2Szf95Vt9
        DEITVVm+74m8Bb8Gl3NWJwk4TRSHiqzI4me8sM/R8LN7Si+alfGfxq5Ygp+/unzlAUHOEAMaXGUUk
        HuL4VHeNUavV/GmCXeXB52W+sv/19DgYqb/qYohVl88jHxI3npQnEgYu3MKj6swbywgxOS6yN9Lk2
        ggd42AjgHwC1KtcbR/M+53ID/oVEZrZVSEO+zbA7krglgq0y/Y2vjIIbdMnDHz61fPgKs2Kwz9flF
        pKEVmgKQJoY1Duv4IfUKMWiH98YTo0yL5G35fvQZCvb64DP0UzpuggBmHVFsYvhrFV2pbQAE053Kx
        AIvf7QlvQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hVCDo-0006TR-FB; Mon, 27 May 2019 09:47:12 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 8B475202BF402; Mon, 27 May 2019 11:47:10 +0200 (CEST)
Date:   Mon, 27 May 2019 11:47:10 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Juergen Gross <jgross@suse.com>
Cc:     Nadav Amit <namit@vmware.com>, Ingo Molnar <mingo@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        linux-hyperv@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [RFC PATCH 5/6] x86/mm/tlb: Flush remote and local TLBs
 concurrently
Message-ID: <20190527094710.GU2623@hirez.programming.kicks-ass.net>
References: <20190525082203.6531-1-namit@vmware.com>
 <20190525082203.6531-6-namit@vmware.com>
 <08b21fb5-2226-7924-30e3-31e4adcfc0a3@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08b21fb5-2226-7924-30e3-31e4adcfc0a3@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 25, 2019 at 10:54:50AM +0200, Juergen Gross wrote:
> On 25/05/2019 10:22, Nadav Amit wrote:

> > diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
> > index 946f8f1f1efc..3a156e63c57d 100644
> > --- a/arch/x86/include/asm/paravirt_types.h
> > +++ b/arch/x86/include/asm/paravirt_types.h
> > @@ -211,6 +211,12 @@ struct pv_mmu_ops {
> >  	void (*flush_tlb_user)(void);
> >  	void (*flush_tlb_kernel)(void);
> >  	void (*flush_tlb_one_user)(unsigned long addr);
> > +	/*
> > +	 * flush_tlb_multi() is the preferred interface. When it is used,
> > +	 * flush_tlb_others() should return false.
> 
> This comment does not make sense. flush_tlb_others() return type is
> void.

I suspect that is an artifact from before the static_key; an attempt to
make the pv interface less awkward.

Something like the below would work for KVM I suspect, the others
(Hyper-V and Xen are more 'interesting').

---
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -580,7 +580,7 @@ static void __init kvm_apf_trap_init(voi
 
 static DEFINE_PER_CPU(cpumask_var_t, __pv_tlb_mask);
 
-static void kvm_flush_tlb_others(const struct cpumask *cpumask,
+static void kvm_flush_tlb_multi(const struct cpumask *cpumask,
 			const struct flush_tlb_info *info)
 {
 	u8 state;
@@ -594,6 +594,9 @@ static void kvm_flush_tlb_others(const s
 	 * queue flush_on_enter for pre-empted vCPUs
 	 */
 	for_each_cpu(cpu, flushmask) {
+		if (cpu == smp_processor_id())
+			continue;
+
 		src = &per_cpu(steal_time, cpu);
 		state = READ_ONCE(src->preempted);
 		if ((state & KVM_VCPU_PREEMPTED)) {
@@ -603,7 +606,7 @@ static void kvm_flush_tlb_others(const s
 		}
 	}
 
-	native_flush_tlb_others(flushmask, info);
+	native_flush_tlb_multi(flushmask, info);
 }
 
 static void __init kvm_guest_init(void)
@@ -628,9 +631,8 @@ static void __init kvm_guest_init(void)
 	if (kvm_para_has_feature(KVM_FEATURE_PV_TLB_FLUSH) &&
 	    !kvm_para_has_hint(KVM_HINTS_REALTIME) &&
 	    kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
-		pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
+		pv_ops.mmu.flush_tlb_multi = kvm_flush_tlb_multi;
 		pv_ops.mmu.tlb_remove_table = tlb_remove_table;
-		static_key_disable(&flush_tlb_multi_enabled.key);
 	}
 
 	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
