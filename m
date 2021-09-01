Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 179163FD554
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 10:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243072AbhIAI2S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 04:28:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33243 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242922AbhIAI2S (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Sep 2021 04:28:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630484839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ovcjyG7IDaOy6ifWW+v+m6prcD2wZaK5/tKOHaPCRA8=;
        b=HgJJqzg2OBdcKqXX7FOkcNExTFCpactQB3NctE7Wl+wLtLEfheEPW8+F6urTaYiV4ffOKv
        c+nJtKZAJfExOBtoef+q+Uice04n1LKd0rmSfMwEp4yNc83UKpYA0xEQZXwwisIA21EmuD
        7nfPi7nP/gpvAxmTwmZYQ65VCiYBzEQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-sG-KxLjBN9u5rsaG3jj5JQ-1; Wed, 01 Sep 2021 04:27:18 -0400
X-MC-Unique: sG-KxLjBN9u5rsaG3jj5JQ-1
Received: by mail-wm1-f72.google.com with SMTP id u14-20020a7bcb0e0000b0290248831d46e4so740390wmj.6
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 01:27:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ovcjyG7IDaOy6ifWW+v+m6prcD2wZaK5/tKOHaPCRA8=;
        b=SIthQ8G9++Yx6Wf6w5JC+X78v+SLkv9tJyZ0ThbJ6v4KLSUZYJpKspMawxGRO/4Dr7
         xg8jpziAJmLGSGHTBzOJsQ26EdnnyC/L9LxOCzLZWySXI/0MqnxALqr8jHytrhVmV6MU
         tpM1WGhhXEADAXJ2e4IsS7Ts0lcf0tRiCkMfdw1XOP7qCQXnrDq+yCp+WphmM+Dv0hwC
         G9sWWsxRt1P/X5wjf482XArip8AKYw5AdIvyCMpJQPAz2DYPLvVkM995Ljt0vgOSqUM1
         1UTjV2CC4CaPSvANEPrkEB0dcf0CtACNtdiofZaSfRYIsAdb5wj5QhnotH2je5Zfqsck
         aNjQ==
X-Gm-Message-State: AOAM530jO1BzO8A/KRmmP9PT1WWmPIE0b2jGRqdtWpN2AhhNFxr4q2EO
        Vz+wY1EO68VOa9RPsLuZo6M0iI3GxpRctK2WTFkHzPEu4VgrP3wTAO491XMSADnozZuOCTg9mMu
        VqR6K5ASoTtUa
X-Received: by 2002:a7b:c4cb:: with SMTP id g11mr8411412wmk.80.1630484836985;
        Wed, 01 Sep 2021 01:27:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwVHVGo8/2yaFqDLnkSXohfmFINaCXjLS/UevTrlJwzmeSr3ztn2rVI0RS4UIxlE57pxWngTg==
X-Received: by 2002:a7b:c4cb:: with SMTP id g11mr8411397wmk.80.1630484836753;
        Wed, 01 Sep 2021 01:27:16 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id u5sm20249739wrr.94.2021.09.01.01.27.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 01:27:16 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+200c08e88ae818f849ce@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/3] Revert "KVM: x86: mmu: Add guest physical address
 check in translate_gpa()"
In-Reply-To: <20210831164224.1119728-2-seanjc@google.com>
References: <20210831164224.1119728-1-seanjc@google.com>
 <20210831164224.1119728-2-seanjc@google.com>
Date:   Wed, 01 Sep 2021 10:27:15 +0200
Message-ID: <87pmtsog4c.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> Revert a misguided illegal GPA check when "translating" a non-nested GPA.
> The check is woefully incomplete as it does not fill in @exception as
> expected by all callers, which leads to KVM attempting to inject a bogus
> exception, potentially exposing kernel stack information in the process.
>
>  WARNING: CPU: 0 PID: 8469 at arch/x86/kvm/x86.c:525 exception_type+0x98/0xb0 arch/x86/kvm/x86.c:525
>  CPU: 1 PID: 8469 Comm: syz-executor531 Not tainted 5.14.0-rc7-syzkaller #0
>  RIP: 0010:exception_type+0x98/0xb0 arch/x86/kvm/x86.c:525
>  Call Trace:
>   x86_emulate_instruction+0xef6/0x1460 arch/x86/kvm/x86.c:7853
>   kvm_mmu_page_fault+0x2f0/0x1810 arch/x86/kvm/mmu/mmu.c:5199
>   handle_ept_misconfig+0xdf/0x3e0 arch/x86/kvm/vmx/vmx.c:5336
>   __vmx_handle_exit arch/x86/kvm/vmx/vmx.c:6021 [inline]
>   vmx_handle_exit+0x336/0x1800 arch/x86/kvm/vmx/vmx.c:6038
>   vcpu_enter_guest+0x2a1c/0x4430 arch/x86/kvm/x86.c:9712
>   vcpu_run arch/x86/kvm/x86.c:9779 [inline]
>   kvm_arch_vcpu_ioctl_run+0x47d/0x1b20 arch/x86/kvm/x86.c:10010
>   kvm_vcpu_ioctl+0x49e/0xe50 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3652
>
> The bug has escaped notice because practically speaking the GPA check is
> useless.  The GPA check in question only comes into play when KVM is
> walking guest page tables (or "translating" CR3), and KVM already handles
> illegal GPA checks by setting reserved bits in rsvd_bits_mask for each
> PxE, or in the case of CR3 for loading PTDPTRs, manually checks for an
> illegal CR3.  This particular failure doesn't hit the existing reserved
> bits checks because syzbot sets guest.MAXPHYADDR=1, and IA32 architecture
> simply doesn't allow for such an absurd MAXPHADDR, e.g. 32-bit paging

"MAXPHYADDR"

> doesn't define any reserved PA bits checks, which KVM emulates by only
> incorporating the reserved PA bits into the "high" bits, i.e. bits 63:32.
>
> Simply remove the bogus check.  There is zero meaningful value and no
> architectural justification for supporting guest.MAXPHYADDR < 32, and
> properly filling the exception would introduce non-trivial complexity.
>
> This reverts commit ec7771ab471ba6a945350353617e2e3385d0e013.
>
> Fixes: ec7771ab471b ("KVM: x86: mmu: Add guest physical address check in translate_gpa()")
> Cc: stable@vger.kernel.org
> Reported-by: syzbot+200c08e88ae818f849ce@syzkaller.appspotmail.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 6 ------
>  1 file changed, 6 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 4853c033e6ce..4b7908187d05 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -334,12 +334,6 @@ static bool check_mmio_spte(struct kvm_vcpu *vcpu, u64 spte)
>  static gpa_t translate_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access,
>                                    struct x86_exception *exception)
>  {
> -	/* Check if guest physical address doesn't exceed guest maximum */
> -	if (kvm_vcpu_is_illegal_gpa(vcpu, gpa)) {
> -		exception->error_code |= PFERR_RSVD_MASK;
> -		return UNMAPPED_GVA;
> -	}
> -
>          return gpa;
>  }

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

I'm, however, wondering if it would also make sense to forbid setting
nonsensical MAXPHYADDR, something like (compile-only tested):

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index fe03bd978761..42e71ac8ff31 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -73,25 +73,6 @@ static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
 	return NULL;
 }
 
-static int kvm_check_cpuid(struct kvm_cpuid_entry2 *entries, int nent)
-{
-	struct kvm_cpuid_entry2 *best;
-
-	/*
-	 * The existing code assumes virtual address is 48-bit or 57-bit in the
-	 * canonical address checks; exit if it is ever changed.
-	 */
-	best = cpuid_entry2_find(entries, nent, 0x80000008, 0);
-	if (best) {
-		int vaddr_bits = (best->eax & 0xff00) >> 8;
-
-		if (vaddr_bits != 48 && vaddr_bits != 57 && vaddr_bits != 0)
-			return -EINVAL;
-	}
-
-	return 0;
-}
-
 void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
@@ -208,20 +189,48 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	kvm_mmu_after_set_cpuid(vcpu);
 }
 
-int cpuid_query_maxphyaddr(struct kvm_vcpu *vcpu)
+static int __cpuid_query_maxphyaddr(struct kvm_cpuid_entry2 *entries, int nent)
 {
 	struct kvm_cpuid_entry2 *best;
 
-	best = kvm_find_cpuid_entry(vcpu, 0x80000000, 0);
+	best = cpuid_entry2_find(entries, nent, 0x80000000, 0);
 	if (!best || best->eax < 0x80000008)
 		goto not_found;
-	best = kvm_find_cpuid_entry(vcpu, 0x80000008, 0);
+	best = cpuid_entry2_find(entries, nent, 0x80000008, 0);
 	if (best)
 		return best->eax & 0xff;
 not_found:
 	return 36;
 }
 
+int cpuid_query_maxphyaddr(struct kvm_vcpu *vcpu)
+{
+	return __cpuid_query_maxphyaddr(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
+}
+
+static int kvm_check_cpuid(struct kvm_cpuid_entry2 *entries, int nent)
+{
+	struct kvm_cpuid_entry2 *best;
+
+	/* guest.MAXPHYADDR < 32 is completely nonsensical */
+	if (__cpuid_query_maxphyaddr(entries, nent) < 32)
+		return -EINVAL;
+
+	/*
+	 * The existing code assumes virtual address is 48-bit or 57-bit in the
+	 * canonical address checks; exit if it is ever changed.
+	 */
+	best = cpuid_entry2_find(entries, nent, 0x80000008, 0);
+	if (best) {
+		int vaddr_bits = (best->eax & 0xff00) >> 8;
+
+		if (vaddr_bits != 48 && vaddr_bits != 57 && vaddr_bits != 0)
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
 /*
  * This "raw" version returns the reserved GPA bits without any adjustments for
  * encryption technologies that usurp bits.  The raw mask should be used if and

-- 
Vitaly

