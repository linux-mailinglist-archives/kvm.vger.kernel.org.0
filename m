Return-Path: <kvm+bounces-64933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A1F7C91CB0
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 12:32:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 90452342667
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 11:32:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B36B30F52B;
	Fri, 28 Nov 2025 11:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eRVaU5WS";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="a4cxZ640"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D622306D54
	for <kvm@vger.kernel.org>; Fri, 28 Nov 2025 11:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764329533; cv=none; b=j3xXT9eS65BAlw0m5n/H/SzXSCYDbhyfFNgR4d3n8pqmCgaXgCWR3/tejlOelKTPYj1Asne/q3kALlU0myNR0qumo5nfuKdJSXOAdNZ0LQXquTuI3SfDNoMMVcvcOlBkLYC9ExahYDUVAvjS3C2DKfNNMDpuCKcoAyJv25YJrVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764329533; c=relaxed/simple;
	bh=PH9qCvIxP5Gd7Wg9ykwfGd0sVXYgzsKz06bqLv2zGpo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FUQsxEzUS2YdvJPfpmU7ys29H5u+ERfGf4LXOz+OaoA7XwPjvs4ewHVF3z8hcH256pOUFIPQ8gB4LB/mb8M3Imv/CcznnMk7WTiz8pwhTcZtlt0I6KNXNhnzY4H9ew2Ia+hr4IeNjW8en0uZy6xRT0amas+k/So+qK5V+2g6bDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eRVaU5WS; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=a4cxZ640; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764329530;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1Vcj5UK3urZHkUpSELefbaUtytPM/ccTzW6aPhYWxGI=;
	b=eRVaU5WS6frJc2hwg41S4W7NkOdml0hb3Sk/BcRyHpJlsBMjM2Ih53EHBnbXceUfifMYoJ
	oJAYU42UlhlQpJN+L/xYux1e8pR/zdoXRlh7P09e/YDJdwoxix868axc+emjTgo4BbA1L9
	G5nquiCbZXb2vuIMsvTVN4CWlN3FOwo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-592-SaLDu8ghNiOMI7UZf-jsYA-1; Fri, 28 Nov 2025 06:32:05 -0500
X-MC-Unique: SaLDu8ghNiOMI7UZf-jsYA-1
X-Mimecast-MFC-AGG-ID: SaLDu8ghNiOMI7UZf-jsYA_1764329524
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-477b8a667bcso17479955e9.2
        for <kvm@vger.kernel.org>; Fri, 28 Nov 2025 03:32:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764329524; x=1764934324; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Vcj5UK3urZHkUpSELefbaUtytPM/ccTzW6aPhYWxGI=;
        b=a4cxZ640qcbTkjNrWRwIAOmoousMgdTxKyMfppOdYm/K3Kb2N8wy4iT+gMMF/cNMRW
         qEpaxith++gW4YEOWuF4JT0aBW8nquW2sz3A/eG85jWBo6kCNWFV+2cPZvVSIH3pg3Vw
         1vOcOBy4b4LtFRq3qKuvtJ8NU68iTkIYAE+N87S4i2EO54zSUXeqDi3k9yQcOCqZgpOB
         MueSpJQYcIRkpuKN71luX0yXe9GAw3S1iTuw3scptuWdFrUv0aClRmmM6jfhI35nF6eP
         E1MrrZ0+sa0l+aYSeLTdJWhCc7y3oYUNYi5UkJy19uWT7UFM20t0oAE8oQgN/J/yj/H8
         wSdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764329524; x=1764934324;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1Vcj5UK3urZHkUpSELefbaUtytPM/ccTzW6aPhYWxGI=;
        b=g+Ka7Bh+Pww+4aMbHZiOKZt7H4O8I1VaUM8JiHEIKzNnwctL7Z+5lX7+A0M4Y4TRtX
         Cpm879fSc24H0nGvG1c1FWkZRGOQf3uUIwOhFzpADkFfMRclMdzWwLE5AxOU54E+WUUZ
         HTdBadz1YN1NGWdmCwMh3ZTbCy1L3mZu5nr6eC5ud4ScvRGxt/9IP96CQWndmwhqaIFV
         gFHK6W0hT1c0fv/Z+j/3aW3fnVUoNLGKcFTiQ0XHCkmsFvhoFPKo/z7dodYn3OoCk5u/
         fKfWISGlOnn7yeHnJCv4mr5E6VByUKiaRlwoqBUa3svOLEgUoRemzj6tEdahF8fSs/Jp
         wddg==
X-Forwarded-Encrypted: i=1; AJvYcCVDobv7jPAkz5MLbQrewy9qNyxHo96WssX1PgkG/I44Uzi33EFm9SoBQjvSvgrqII0PBsM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzH670gTb5dSCDcHqaarmP+1q7ZBqhV5nVVtUnh2Y+PdkPhwhuj
	vWFL/HDORtkRwrzSlJX29m101urUvqpceLrmuTIEgqwA1VfiFUAWxMXGxqLdaheFhKFqPJOBKwu
	JSAxTwoJ0dNvjLMurzZ3ndQ1MmQ2GssHyiYyhaNC+ZkvTBVJKS42Saw==
X-Gm-Gg: ASbGncvKvnZDsU9uCv3ffA0BzJOdKeHN4eAjhwv/EOQ9OphOmnWarx/iB6msDCJBVoQ
	ReEuxtus882wlIb9KxFFqCHuu+vjzLEoyJ3qZOc1jBopUhFOQYR2zM7FtUnY+5HkQng/C6hg0cC
	FZFO/KJAgssAhtoUd8DWwuI8zzWsoYcIfR0kRmTEfULt352cEDn/bFHIJVVVaylrdrih7C8u+kX
	tLiBsE4AzWkSTfUOEJfcDJlrZYWl3k0U99w4VVGQ9mIQsqOq1wXTVHvBiMFk2umPL7UMIUna1WO
	e2kth2UijYg31k2ke4KvD/d7bxDCwKeueV3tbs51zyzlCyNZhsSrlGui07JdQUXNGr7cTQ==
X-Received: by 2002:a05:600c:354e:b0:477:fcb:2256 with SMTP id 5b1f17b1804b1-47904b12eb0mr153976285e9.17.1764329524077;
        Fri, 28 Nov 2025 03:32:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEWkc4kOG4p3NtsM6z+yEwf0TGATNAUUXhu/bxP0XKAceBdDB2zOizod+FJpyGIilCUno76XA==
X-Received: by 2002:a05:600c:354e:b0:477:fcb:2256 with SMTP id 5b1f17b1804b1-47904b12eb0mr153975875e9.17.1764329523559;
        Fri, 28 Nov 2025 03:32:03 -0800 (PST)
Received: from imammedo ([213.175.46.86])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4791163e36csm77779385e9.9.2025.11.28.03.32.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 03:32:03 -0800 (PST)
Date: Fri, 28 Nov 2025 12:32:02 +0100
From: Igor Mammedov <imammedo@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
 mlevitsk@redhat.com
Subject: Re: [PATCH 5/5] KVM: x86: Defer runtime updates of dynamic CPUID
 bits until CPUID emulation
Message-ID: <20251128123202.68424a95@imammedo>
In-Reply-To: <20241211013302.1347853-6-seanjc@google.com>
References: <20241211013302.1347853-1-seanjc@google.com>
	<20241211013302.1347853-6-seanjc@google.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 10 Dec 2024 17:33:02 -0800
Sean Christopherson <seanjc@google.com> wrote:

Sean,

this patch broke vCPU hotplug (still broken with current master),
after repeated plug/unplug of the same vCPU in a loop, QEMU exits
due to error in vcpu initialization:

    r = kvm_vcpu_ioctl(cs, KVM_SET_CPUID2, &cpuid_data);                         
    if (r) {                                                                     
        goto fail;                                                               
    }

Reproducer (host in question is Haswell but it's been seen on other hosts as well):
for it to trigger the issue it must be Q35 machine with UEFI firmware
(the rest doesn't seem to matter)
===

#!/bin/sh

/tmp/qemu_build/qemu-system-x86_64 -M q35,pflash0=drive_ovmf_code,pflash1=drive_ovmf_vars \
    -m 16G -cpu host -smp 1,maxcpus=2 -enable-kvm \
    -blockdev node-name=file_ovmf_code,driver=file,filename=edk2-x86_64-secure-code.fd,auto-read-only=on,discard=unmap \
    -blockdev node-name=drive_ovmf_code,driver=raw,read-only=on,file=file_ovmf_code \
    -blockdev node-name=file_ovmf_vars,driver=file,filename=myOVMF_VARS.fd,auto-read-only=on,discard=unmap \
    -blockdev node-name=drive_ovmf_vars,driver=raw,read-only=off,file=file_ovmf_vars \
    -monitor unix:/tmp/monitor2,server,nowait -snapshot \
    ./rhel10-efi.qcow2 &

sleep 120

i=0
while [ $i -lt 3 ] 
do
	echo "====== The $(($i+1)) iterations ======"
	echo "info cpus" | nc -U /tmp/monitor2
	sleep 2
	echo "device_add host-x86_64-cpu,core-id=1,thread-id=0,socket-id=0,id=core1" | nc -U /tmp/monitor2
	sleep 6 
	echo "info cpus" | nc -U /tmp/monitor2
	sleep 2
	echo "device_del core1" | nc -U /tmp/monitor2
	sleep 6
	echo "info cpus" | nc -U /tmp/monitor2
	sleep 2
	((i++))
done

===


> Defer runtime CPUID updates until the next non-faulting CPUID emulation
> or KVM_GET_CPUID2, which are the only paths in KVM that consume the
> dynamic entries.  Deferring the updates is especially beneficial to
> nested VM-Enter/VM-Exit, as KVM will almost always detect multiple state
> changes, not to mention the updates don't need to be realized while L2 is
> active, as CPUID is a mandatory intercept on both Intel and AMD.
> 
> Deferring CPUID updates shaves several hundred cycles from nested VMX
> roundtrips, as measured from L2 executing CPUID in a tight loop:
> 
>   SKX 6850 => 6450
>   ICX 9000 => 8800
>   EMR 7900 => 7700
> 
> Alternatively, KVM could update only the CPUID leaves that are affected
> by the state change, e.g. update XSAVE info only if XCR0 or XSS changes,
> but that adds non-trivial complexity and doesn't solve the underlying
> problem of nested transitions potentially changing both XCR0 and XSS, on
> both nested VM-Enter and VM-Exit.
> 
> KVM could also skip updates entirely while L2 is active, because again
> CPUID is a mandatory intercept.  However, simply skipping updates if L2
> is active is *very* subtly dangerous and complex.  Most KVM updates are
> triggered by changes to the current vCPU state, which may be L2 state
> whereas performing updates only for L1 would requiring detecting changes
> to L1 state.  KVM would need to either track relevant L1 state, or defer
> runtime CPUID updates until the next nested VM-Exit.  The former is ugly
> and complex, while the latter comes with similar dangers to deferring all
> CPUID updates, and would only address the nested VM-Enter path.
> 
> To guard against using stale data, disallow querying dynamic CPUID feature
> bits, i.e. features that KVM updates at runtime, via a compile-time
> assertion in guest_cpu_cap_has().  Exempt MWAIT from the rule, as the
> MISC_ENABLE_NO_MWAIT means that MWAIT is _conditionally_ a dynamic CPUID
> feature.
> 
> Note, the rule could be enforced for MWAIT as well, e.g. by querying guest
> CPUID in kvm_emulate_monitor_mwait, but there's no obvious advtantage to
> doing so, and allowing MWAIT for guest_cpuid_has() opens up a different can
> of worms.  MONITOR/MWAIT can't be virtualized (for a reasonable definition),
> and the nature of the MWAIT_NEVER_UD_FAULTS and MISC_ENABLE_NO_MWAIT quirks
> means checking X86_FEATURE_MWAIT outside of kvm_emulate_monitor_mwait() is
> wrong for other reasons.
> 
> Beyond the aforementioned feature bits, the only other dynamic CPUID
> (sub)leaves are the XSAVE sizes, and similar to MWAIT, consuming those
> CPUID entries in KVM is all but guaranteed to be a bug.  The layout for an
> actual XSAVE buffer depends on the format (compacted or not) and
> potentially the features that are actually enabled.  E.g. see the logic in
> fpstate_clear_xstate_component() needed to poke into the guest's effective
> XSAVE state to clear MPX state on INIT.  KVM does consume
> CPUID.0xD.0.{EAX,EDX} in kvm_check_cpuid() and cpuid_get_supported_xcr0(),
> but not EBX, which is the only dynamic output register in the leaf.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/cpuid.c            | 12 ++++++++++--
>  arch/x86/kvm/cpuid.h            |  9 ++++++++-
>  arch/x86/kvm/lapic.c            |  2 +-
>  arch/x86/kvm/smm.c              |  2 +-
>  arch/x86/kvm/svm/sev.c          |  2 +-
>  arch/x86/kvm/svm/svm.c          |  2 +-
>  arch/x86/kvm/vmx/vmx.c          |  2 +-
>  arch/x86/kvm/x86.c              |  6 +++---
>  9 files changed, 27 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 81ce8cd5814a..23cc5c10060e 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -871,6 +871,7 @@ struct kvm_vcpu_arch {
>  
>  	int cpuid_nent;
>  	struct kvm_cpuid_entry2 *cpuid_entries;
> +	bool cpuid_dynamic_bits_dirty;
>  	bool is_amd_compatible;
>  
>  	/*
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 7f5fa6665969..54ba1a75b779 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -195,6 +195,7 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
>  }
>  
>  static u32 kvm_apply_cpuid_pv_features_quirk(struct kvm_vcpu *vcpu);
> +static void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu);
>  
>  /* Check whether the supplied CPUID data is equal to what is already set for the vCPU. */
>  static int kvm_cpuid_check_equal(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
> @@ -299,10 +300,12 @@ static __always_inline void kvm_update_feature_runtime(struct kvm_vcpu *vcpu,
>  	guest_cpu_cap_change(vcpu, x86_feature, has_feature);
>  }
>  
> -void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
> +static void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_cpuid_entry2 *best;
>  
> +	vcpu->arch.cpuid_dynamic_bits_dirty = false;
> +
>  	best = kvm_find_cpuid_entry(vcpu, 1);
>  	if (best) {
>  		kvm_update_feature_runtime(vcpu, best, X86_FEATURE_OSXSAVE,
> @@ -332,7 +335,6 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
>  		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
>  		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
>  }
> -EXPORT_SYMBOL_GPL(kvm_update_cpuid_runtime);
>  
>  static bool kvm_cpuid_has_hyperv(struct kvm_vcpu *vcpu)
>  {
> @@ -645,6 +647,9 @@ int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
>  	if (cpuid->nent < vcpu->arch.cpuid_nent)
>  		return -E2BIG;
>  
> +	if (vcpu->arch.cpuid_dynamic_bits_dirty)
> +		kvm_update_cpuid_runtime(vcpu);
> +
>  	if (copy_to_user(entries, vcpu->arch.cpuid_entries,
>  			 vcpu->arch.cpuid_nent * sizeof(struct kvm_cpuid_entry2)))
>  		return -EFAULT;
> @@ -1983,6 +1988,9 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
>  	struct kvm_cpuid_entry2 *entry;
>  	bool exact, used_max_basic = false;
>  
> +	if (vcpu->arch.cpuid_dynamic_bits_dirty)
> +		kvm_update_cpuid_runtime(vcpu);
> +
>  	entry = kvm_find_cpuid_entry_index(vcpu, function, index);
>  	exact = !!entry;
>  
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index 67d80aa72d50..d2884162a46a 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -11,7 +11,6 @@ extern u32 kvm_cpu_caps[NR_KVM_CPU_CAPS] __read_mostly;
>  void kvm_set_cpu_caps(void);
>  
>  void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu);
> -void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu);
>  struct kvm_cpuid_entry2 *kvm_find_cpuid_entry_index(struct kvm_vcpu *vcpu,
>  						    u32 function, u32 index);
>  struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
> @@ -232,6 +231,14 @@ static __always_inline bool guest_cpu_cap_has(struct kvm_vcpu *vcpu,
>  {
>  	unsigned int x86_leaf = __feature_leaf(x86_feature);
>  
> +	/*
> +	 * Except for MWAIT, querying dynamic feature bits is disallowed, so
> +	 * that KVM can defer runtime updates until the next CPUID emulation.
> +	 */
> +	BUILD_BUG_ON(x86_feature == X86_FEATURE_APIC ||
> +		     x86_feature == X86_FEATURE_OSXSAVE ||
> +		     x86_feature == X86_FEATURE_OSPKE);
> +
>  	return vcpu->arch.cpu_caps[x86_leaf] & __feature_bit(x86_feature);
>  }
>  
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index ae81ae27d534..cf74c87b8b3f 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2585,7 +2585,7 @@ static void __kvm_apic_set_base(struct kvm_vcpu *vcpu, u64 value)
>  	vcpu->arch.apic_base = value;
>  
>  	if ((old_value ^ value) & MSR_IA32_APICBASE_ENABLE)
> -		kvm_update_cpuid_runtime(vcpu);
> +		vcpu->arch.cpuid_dynamic_bits_dirty = true;
>  
>  	if (!apic)
>  		return;
> diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
> index e0ab7df27b66..699e551ec93b 100644
> --- a/arch/x86/kvm/smm.c
> +++ b/arch/x86/kvm/smm.c
> @@ -358,7 +358,7 @@ void enter_smm(struct kvm_vcpu *vcpu)
>  			goto error;
>  #endif
>  
> -	kvm_update_cpuid_runtime(vcpu);
> +	vcpu->arch.cpuid_dynamic_bits_dirty = true;
>  	kvm_mmu_reset_context(vcpu);
>  	return;
>  error:
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 09be12a44288..5e4581ed0ef1 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3274,7 +3274,7 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
>  
>  	if (kvm_ghcb_xcr0_is_valid(svm)) {
>  		vcpu->arch.xcr0 = ghcb_get_xcr0(ghcb);
> -		kvm_update_cpuid_runtime(vcpu);
> +		vcpu->arch.cpuid_dynamic_bits_dirty = true;
>  	}
>  
>  	/* Copy the GHCB exit information into the VMCB fields */
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 07911ddf1efe..6a350cee2f6c 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1936,7 +1936,7 @@ void svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>  	vmcb_mark_dirty(to_svm(vcpu)->vmcb, VMCB_CR);
>  
>  	if ((cr4 ^ old_cr4) & (X86_CR4_OSXSAVE | X86_CR4_PKE))
> -		kvm_update_cpuid_runtime(vcpu);
> +		vcpu->arch.cpuid_dynamic_bits_dirty = true;
>  }
>  
>  static void svm_set_segment(struct kvm_vcpu *vcpu,
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index cf872d8691b5..b5f3c5628bfd 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3516,7 +3516,7 @@ void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>  	vmcs_writel(GUEST_CR4, hw_cr4);
>  
>  	if ((cr4 ^ old_cr4) & (X86_CR4_OSXSAVE | X86_CR4_PKE))
> -		kvm_update_cpuid_runtime(vcpu);
> +		vcpu->arch.cpuid_dynamic_bits_dirty = true;
>  }
>  
>  void vmx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index dc8829712edd..10b7d8c01e4d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1264,7 +1264,7 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
>  	vcpu->arch.xcr0 = xcr0;
>  
>  	if ((xcr0 ^ old_xcr0) & XFEATURE_MASK_EXTEND)
> -		kvm_update_cpuid_runtime(vcpu);
> +		vcpu->arch.cpuid_dynamic_bits_dirty = true;
>  	return 0;
>  }
>  
> @@ -3899,7 +3899,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  			if (!guest_cpu_cap_has(vcpu, X86_FEATURE_XMM3))
>  				return 1;
>  			vcpu->arch.ia32_misc_enable_msr = data;
> -			kvm_update_cpuid_runtime(vcpu);
> +			vcpu->arch.cpuid_dynamic_bits_dirty = true;
>  		} else {
>  			vcpu->arch.ia32_misc_enable_msr = data;
>  		}
> @@ -3934,7 +3934,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		if (data & ~kvm_caps.supported_xss)
>  			return 1;
>  		vcpu->arch.ia32_xss = data;
> -		kvm_update_cpuid_runtime(vcpu);
> +		vcpu->arch.cpuid_dynamic_bits_dirty = true;
>  		break;
>  	case MSR_SMI_COUNT:
>  		if (!msr_info->host_initiated)


