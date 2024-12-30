Return-Path: <kvm+bounces-34409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D8BE9FE592
	for <lists+kvm@lfdr.de>; Mon, 30 Dec 2024 12:15:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E90ED3A22DB
	for <lists+kvm@lfdr.de>; Mon, 30 Dec 2024 11:15:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A55E1A7ADD;
	Mon, 30 Dec 2024 11:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Ptc9l48z"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59B02594BB;
	Mon, 30 Dec 2024 11:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735557318; cv=none; b=GoFiDKHXUjwyZCu4T6TehEzPksP7DJTLvWL67XkOHKBCYuujn3FRtSvlKMwEkGLIeL7K0Ao0lZIk9h6NfqJ5HTBoK8a2ZEt1IHcTmHRkJE1rBJthmxi7Fl4HDBgFibKraHe886i0S9E//TKMfsmYbwIAEheArykl6nmeb034ugg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735557318; c=relaxed/simple;
	bh=rESYI4E0hG6V+qz1lVj/ETyHW/hbboGNas0IysUHG0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hvXACAnW4v+KuT2e9IHqday28VCaT2+Zk5YSJongFKIrlB82CUMOm414D5+dOUfD6iy0c0wyvQplf5m/pWADqX5WJ/G8vxD82RAVBvLJK3PpgGq8MnjXOhuYUML8xh/N8Xe7Vun3kmRH2uvnPttK/afDU6EpcVuPljmuC9wOcWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Ptc9l48z; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 6E58140E02C1;
	Mon, 30 Dec 2024 11:15:13 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id kRfvsqAmQ8kO; Mon, 30 Dec 2024 11:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1735557309; bh=fhpeqpLevvt7f+j18oYOAVbDvwS05XQNhKOJwaf76ic=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ptc9l48zXw34QfWsw/RnscuP3Thpk+GGL2VMq6dRMbsqZFitcWs2qb1kpWhlZWqGy
	 7jM2XOOL0a2CFtNRVclglRYfR8+cZnhQVPptM7up+b+Ic1e64LHKoLbdEswht3fuLh
	 7lNmwRas5WS81LFaCDEBIToYuC2UcxY31bMEBLmy5zbRZknLhgLlvVSbICixmZwGlb
	 JnHCUz4niChAZCwLcLQUjY1qAuMWpB7Ji4Ha4B7KHH0Ch1BtQHQnXvNZfVc+qBW9xV
	 Wx3qBgzrgAZgcP1s3u/lKyJOKVliRiWRXH34KnNLgpdKbXn2inL1ZI8kmmpLa0TtRL
	 9GInoLQhHe3XDEQafjiZDAYtvVmRFwmdU1YJK0lSyayiC3gzDEOqshJ0NN4rvvtes3
	 a7TYMJeEyxN1bDYFXjwX5LsqMzQ8hkeJCVdY43rcqiWCxrrXw79Xvs08WWaJDRKoQ1
	 NAAn51TlzEmbWfyOC/L+4g5wl7sgdrrkKW6oGPfPYIdOTRvq1+QrXtzlW59WCb09T7
	 z34YGpu12eSno2Et8xsFC7rpxThqvFK5nK6l59gOUM9QxM3ohw87fuK7/r38HXOZnu
	 h8mTB4NdGOaTnIU5qg9nuQwHtHPc97YKYlQarr0A0QphV5yL19jzOH2HD6OnnI5xkl
	 Mdwq07tWi9N/DzO9xzFR18mk=
Received: from zn.tnic (pd953008e.dip0.t-ipconnect.de [217.83.0.142])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8BC8640E02C0;
	Mon, 30 Dec 2024 11:15:01 +0000 (UTC)
Date: Mon, 30 Dec 2024 12:14:56 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Borislav Petkov <bp@kernel.org>, X86 ML <x86@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	KVM <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] x86/bugs: KVM: Add support for SRSO_MSR_FIX
Message-ID: <20241230111456.GBZ3KAsLTrVs77UmxL@fat_crate.local>
References: <20241202120416.6054-1-bp@kernel.org>
 <20241202120416.6054-4-bp@kernel.org>
 <Z1oR3qxjr8hHbTpN@google.com>
 <20241216173142.GDZ2Bj_uPBG3TTPYd_@fat_crate.local>
 <Z2B2oZ0VEtguyeDX@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z2B2oZ0VEtguyeDX@google.com>

On Mon, Dec 16, 2024 at 10:51:13AM -0800, Sean Christopherson wrote:
> @@ -1547,6 +1542,11 @@ static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>             (!boot_cpu_has(X86_FEATURE_V_TSC_AUX) || !sev_es_guest(vcpu->kvm)))
>                 kvm_set_user_return_msr(tsc_aux_uret_slot, svm->tsc_aux, -1ull);
>  
> +       if (cpu_feature_enabled(X86_FEATURE_SRSO_MSR_FIX))
> +               kvm_set_user_return_msr(zen4_bp_cfg_uret_slot,
> +                                       MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT,
> +                                       MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);

I think this needs to be:

       if (cpu_feature_enabled(X86_FEATURE_SRSO_MSR_FIX))
               kvm_set_user_return_msr(zen4_bp_cfg_uret_slot,
                                        BIT_ULL(MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT),
                                        BIT_ULL(MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT));

I.e., value and mask are both the 4th bit: (1 << 4)

>         svm->guest_state_loaded = true;
>  }
>  
> @@ -5313,6 +5313,14 @@ static __init int svm_hardware_setup(void)
>  
>         tsc_aux_uret_slot = kvm_add_user_return_msr(MSR_TSC_AUX);
>  
> +       if (cpu_feature_enabled(X86_FEATURE_SRSO_MSR_FIX)) {
> +               zen4_bp_cfg_uret_slot = kvm_add_user_return_msr(MSR_ZEN4_BP_CFG);
> +               if (WARN_ON_ONCE(zen4_bp_cfg_uret_slot) < 0) {
> +                       r = -EIO;
> +                       goto err;
> +               }

And this needs to be:

       if (cpu_feature_enabled(X86_FEATURE_SRSO_MSR_FIX)) {
               zen4_bp_cfg_uret_slot = kvm_add_user_return_msr(MSR_ZEN4_BP_CFG);
               if (WARN_ON_ONCE(zen4_bp_cfg_uret_slot < 0)) {
                       r = -EIO;
                       goto err;
               }
       }


Note the WARN_ON_ONCE bracketing. But I know you're doing this on purpose - to
see if I'm paying attention and not taking your patch blindly :-P

With that fixed, this approach still doesn't look sane to me: before I start
the guest I have all SPEC_REDUCE bits correctly clear:

# rdmsr -a 0xc001102e | uniq -c 
    128 420000

... start a guest, shut it down cleanly, qemu exits properly...

# rdmsr -a 0xc001102e | uniq -c 
      1 420010
      6 420000
      1 420010
      3 420000
      1 420010
      3 420000
      1 420010
      1 420000
      1 420010
      6 420000
      1 420010
      1 420000
      1 420010
      6 420000
      1 420010
      5 420000
      1 420010
     18 420000
      1 420010
      5 420000
      1 420010
      6 420000
      1 420010
      3 420000
      1 420010
      3 420000
      1 420010
      1 420000
      1 420010
      6 420000
      1 420010
      1 420000
      1 420010
      6 420000
      1 420010
      5 420000
      1 420010
     18 420000
      1 420010
      5 420000

so SPEC_REDUCE remains set on some cores. Not good since I'm not running VMs
anymore.

# rmmod kvm_amd kvm
# rdmsr -a 0xc001102e | uniq -c 
    128 420000

that looks more like it.

Also, this user-return MSR toggling does show up higher in the profile:

   4.31%  qemu-system-x86  [kvm]                    [k] 0x000000000000d23f
   2.44%  qemu-system-x86  [kernel.kallsyms]        [k] read_tsc
   1.66%  qemu-system-x86  [kernel.kallsyms]        [k] native_write_msr
   1.50%  qemu-system-x86  [kernel.kallsyms]        [k] native_write_msr_safe

vs

   1.01%  qemu-system-x86  [kernel.kallsyms]        [k] native_write_msr
   0.81%  qemu-system-x86  [kernel.kallsyms]        [k] native_write_msr_safe

so it really is noticeable.

So I wanna say, let's do the below and be done with it. My expectation is that
this won't be needed in the future anymore either so it'll be a noop on most
machines...

---
@@ -609,6 +609,9 @@ static void svm_disable_virtualization_cpu(void)
        kvm_cpu_svm_disable();
 
        amd_pmu_disable_virt();
+
+       if (cpu_feature_enabled(X86_FEATURE_SRSO_MSR_FIX))
+               msr_clear_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
 }
 
 static int svm_enable_virtualization_cpu(void)
@@ -686,6 +689,9 @@ static int svm_enable_virtualization_cpu(void)
                rdmsr(MSR_TSC_AUX, sev_es_host_save_area(sd)->tsc_aux, msr_hi);
        }
 
+       if (cpu_feature_enabled(X86_FEATURE_SRSO_MSR_FIX))
+               msr_set_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
+
        return 0;
 }
 
-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

