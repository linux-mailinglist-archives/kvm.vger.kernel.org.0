Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 054E9330C1B
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 12:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbhCHLTE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 06:19:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35060 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231249AbhCHLSh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 06:18:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615202316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sX2u0fKm910piT7CsR195OYjWNvMHZma3Vxs4QtPxbQ=;
        b=aY3gNiUX2FC67YGgYc1XqF1jaqE65aO7T1OfioPSPf9T6Z3lDsR2bbl55uu6rUGIohOctE
        vli7+wSPWrxDJkoE+ff+VDhQAHpxZc/4GHnUhSkTB2gPf7Z5PF39JiLISC0Qvm3SPRlXet
        VmH2Uj1MACeZLNqtTV+8YCAovp+5ZGA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-8q35XOqSNkqYcP-ZldAc0w-1; Mon, 08 Mar 2021 06:18:33 -0500
X-MC-Unique: 8q35XOqSNkqYcP-ZldAc0w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 698BC1005D4D;
        Mon,  8 Mar 2021 11:18:31 +0000 (UTC)
Received: from starship (unknown [10.35.206.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 05DEB5D9CD;
        Mon,  8 Mar 2021 11:18:28 +0000 (UTC)
Message-ID: <106d2e650647408a901dfbec53f1b89cc36b2906.camel@redhat.com>
Subject: Re: [PATCH] KVM: SVM: Connect 'npt' module param to KVM's internal
 'npt_enabled'
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 08 Mar 2021 13:18:27 +0200
In-Reply-To: <20210305021637.3768573-1-seanjc@google.com>
References: <20210305021637.3768573-1-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-03-04 at 18:16 -0800, Sean Christopherson wrote:
> Directly connect the 'npt' param to the 'npt_enabled' variable so that
> runtime adjustments to npt_enabled are reflected in sysfs.  Move the
> !PAE restriction to a runtime check to ensure NPT is forced off if the
> host is using 2-level paging, and add a comment explicitly stating why
> NPT requires a 64-bit kernel or a kernel with PAE enabled.

Let me ask a small question for a personal itch.

Do you think it is feasable to allow the user to enable npt/ept per guest?
(the default should still of course come from npt module parameter)

This weekend I checked it a bit and I think that it shouldn't be hard
to do.

There are some old and broken OSes which can't work with npt=1
https://blog.stuffedcow.net/2015/08/win9x-tlb-invalidation-bug/
https://blog.stuffedcow.net/2015/08/pagewalk-coherence/

I won't be surprised if some other old OSes
are affected by this as well knowing from the above 
that on Intel the MMU speculates less and doesn't
break their assumptions up to today.
(This is tested to be true on my Kabylake laptop)

In addition to that, on semi-unrelated note,
our shadowing MMU also shows up the exact same issue since it
also caches translations in form of unsync MMU pages.

But I can (and did disable) this using a hack (see below)
and this finally made my win98 "hobby" guest actually work fine 
on AMD for me.

I am also thinking to make this "sync" mmu mode to be 
another module param (this can also be useful for debug,
see below)
What do you think?

On yet another semi-unrelated note,
A "sync" mmu mode affects another bug I am tracking,
but I don't yet understand why:

I found out that while windows 10 doesn't boot at all with 
disabled tdp on the host (npt/ept - I tested both) 
 the "sync" mmu mode does make it work.

I was also able to reproduce a crash on Linux 
(but only with nested migration loop)
Without "sync" mmu mode and without npt on the host.
With "sync" mmu mode it passed an overnight test of more 
that 1000 iterations.

For reference this is my "sync" mmu hack:

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index febe71935bb5a..1046d8c97702d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2608,7 +2608,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
        }
 
        set_spte_ret = set_spte(vcpu, sptep, pte_access, level, gfn, pfn,
-                               speculative, true, host_writable);
+                               speculative, false, host_writable);
        if (set_spte_ret & SET_SPTE_WRITE_PROTECTED_PT) {
                if (write_fault)
                        ret = RET_PF_EMULATE;


It is a hack since it only happens to work because we eventually
unprotect the guest mmu pages when we detect write flooding to them.
Still performance wise, my win98 guest works very well with this
(with npt=0 on host)

Best regards,
	Maxim Levitsky


> 
> Opportunistically switch the param to octal permissions.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/svm.c | 27 ++++++++++++++-------------
>  1 file changed, 14 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 54610270f66a..0ee74321461e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -115,13 +115,6 @@ static const struct svm_direct_access_msrs {
>  	{ .index = MSR_INVALID,				.always = false },
>  };
>  
> -/* enable NPT for AMD64 and X86 with PAE */
> -#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
> -bool npt_enabled = true;
> -#else
> -bool npt_enabled;
> -#endif
> -
>  /*
>   * These 2 parameters are used to config the controls for Pause-Loop Exiting:
>   * pause_filter_count: On processors that support Pause filtering(indicated
> @@ -170,9 +163,12 @@ module_param(pause_filter_count_shrink, ushort, 0444);
>  static unsigned short pause_filter_count_max = KVM_SVM_DEFAULT_PLE_WINDOW_MAX;
>  module_param(pause_filter_count_max, ushort, 0444);
>  
> -/* allow nested paging (virtualized MMU) for all guests */
> -static int npt = true;
> -module_param(npt, int, S_IRUGO);
> +/*
> + * Use nested page tables by default.  Note, NPT may get forced off by
> + * svm_hardware_setup() if it's unsupported by hardware or the host kernel.
> + */
> +bool npt_enabled = true;
> +module_param_named(npt, npt_enabled, bool, 0444);
>  
>  /* allow nested virtualization in KVM/SVM */
>  static int nested = true;
> @@ -988,12 +984,17 @@ static __init int svm_hardware_setup(void)
>  			goto err;
>  	}
>  
> +	/*
> +	 * KVM's MMU doesn't support using 2-level paging for itself, and thus
> +	 * NPT isn't supported if the host is using 2-level paging since host
> +	 * CR4 is unchanged on VMRUN.
> +	 */
> +	if (!IS_ENABLED(CONFIG_X86_64) && !IS_ENABLED(CONFIG_X86_PAE))
> +		npt_enabled = false;
> +
>  	if (!boot_cpu_has(X86_FEATURE_NPT))
>  		npt_enabled = false;
>  
> -	if (npt_enabled && !npt)
> -		npt_enabled = false;
> -
>  	kvm_configure_mmu(npt_enabled, get_max_npt_level(), PG_LEVEL_1G);
>  	pr_info("kvm: Nested Paging %sabled\n", npt_enabled ? "en" : "dis");
>  


