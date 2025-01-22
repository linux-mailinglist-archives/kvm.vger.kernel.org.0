Return-Path: <kvm+bounces-36278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E8F91A196C9
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 17:44:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 87DB07A26B3
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 16:43:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEAEA21518C;
	Wed, 22 Jan 2025 16:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W2w2ZQoS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E37215192
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 16:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737564210; cv=none; b=FYWxaiynmCR1At8Tiy8af4kQudYMWsws+2tK8fejVOwrh6iD5tR28zST/sH83qwkckCejaXuryAYo5QIFOEz25RbtP9GNLxv2L4hLyLOuDIgs+hAlA/eu4TKTQUbRgdUK74tXG4691enmg5KvJurQNnHtK4aNW+lcNug5q9QiRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737564210; c=relaxed/simple;
	bh=nFNvs5W/qHs8NbJzTv+9VtubwYt4otmZ0nMYx6Zu5fU=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ng6oNpirz/Rrlkdd2vT946O0c2c/RiBIpGe9ClhLpuSeXKId8aSVeqHeoLkTL420/jWMS+5svIGXM8Us1Dwe97RQG7au+HtOXNsIsNJ3dsI18FffzXB/mCBYBgUX+vfMF1DaTYjL10E5kaosUtdWzrU1SVyHUDUPv8AV6+J0ZZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W2w2ZQoS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737564207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gP0baBFoiq4g8/dSmAedFF4kBdcRSt2fdh27G5QkyRw=;
	b=W2w2ZQoS+u/iEKKdbTRuSGzhj77u4RkAeSqycvBMs6gkIjGqkslJ0ryPYNA6X9em8yPksK
	DaxgYAIC+wZVdbwjz1IBZSTk14SIUoEpYqons7/8uDIpOiqsMtk8QdgztIfD4gjLN618hp
	N9oLtp+eb41TyPE9Wef2tuySpyyec1k=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-irgEFAdKNsWKHPTxuEvYyQ-1; Wed, 22 Jan 2025 11:43:26 -0500
X-MC-Unique: irgEFAdKNsWKHPTxuEvYyQ-1
X-Mimecast-MFC-AGG-ID: irgEFAdKNsWKHPTxuEvYyQ
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-46792701b64so133234331cf.3
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 08:43:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737564206; x=1738169006;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gP0baBFoiq4g8/dSmAedFF4kBdcRSt2fdh27G5QkyRw=;
        b=iD/eWCjFzYq2bsXTlpAv9mPqmV+saPitw+Cq0TFe0pzGB1MI/wk+4T5NGezdwoewmS
         1j+/PO6Q6TeJPyg9VsTATbwNsebFIiYEWmJYoBb7Fo3TqWTrZvBnTU6z8mM3LTKK8LCh
         0AYPUZYuQtpMelZ1u99ZkE7N5U6MHSbWZpafhiFljRZa/LoSyi0tf8YY2Qc0M6YygF5i
         TMWIaLZsLaKKoOINgA59D+WcSnpOiFN3C2+xUyhREraUcuZ4xbxOVkWQjPQ4CPlH66Kh
         0cgNliUaf4Ietg0FBpRM0PpQ884rZM8xZjK2snVV6Lv+vU0Knf9W/FD1zYD0D0OyggJm
         nV+w==
X-Forwarded-Encrypted: i=1; AJvYcCU6KDU6ImKeHEmqjdBiwSc6NBnZe5F5VQC6TlByQ0E+JCY34WtzYEDByJgWIa0IttYYhrU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6j6fWgRz/97QaHtg5JlsebDyVDEjoniVqc9VOJPmhrT/BUDTP
	uWtqwe4zFL4p7KjsxRvygoceRtpgzvEAcPBlh32SdwNfDiFmaUy/CA9K8CSUy+AzmLqgt281Nwg
	ttfku4s0Y6rhl9inks0RHLJnjSTr7WeS7jxId4Z9GYRXEMTRFnkszkNaWsQ==
X-Gm-Gg: ASbGncsi//Q/lQpvpT9jzLFUqq3vR1NTTKta9LEWW5K/4R3WJC6z0rTZAZRj43w+Hr1
	3joOsUlujvxhJISh+mcKRN79NjFapI6e7AbP2YoFnKJVa2JodHdD3sRICgr9hcy0K2t5eIU7Z3f
	gyuxpNUnhw5Mbcpk2T3gKG22veMTmNfnsjMfcy4+twHwZemU9KyyAgrGTi2LqwUhkNWic4xMz1Y
	SHxF+J+Qeg6vQgPIw95XUFUCMevyTLxc2jJnTWQl+qGTz1sGh0oI8ktmzEvTXivf2tMrA==
X-Received: by 2002:a05:6214:3006:b0:6d8:68a1:b7aa with SMTP id 6a1803df08f44-6e1b222f202mr369516566d6.28.1737564205671;
        Wed, 22 Jan 2025 08:43:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHNosXfmrCHlrQvCywOeWXzuKBFz26tKShC77cA7JOkkN1dF+4WcPXS2EUE7FhFI3yfmSsmiw==
X-Received: by 2002:a05:6214:3006:b0:6d8:68a1:b7aa with SMTP id 6a1803df08f44-6e1b222f202mr369516256d6.28.1737564205368;
        Wed, 22 Jan 2025 08:43:25 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e1afcd38a0sm62363556d6.89.2025.01.22.08.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2025 08:43:24 -0800 (PST)
Message-ID: <93e33d01a81e548aedd78aca672fb89200c562de.camel@redhat.com>
Subject: Re: [Bug 218267] [Sapphire Rapids][Upstream]Boot up multiple
 Windows VMs hang
From: Maxim Levitsky <mlevitsk@redhat.com>
To: bugzilla-daemon@kernel.org, kvm@vger.kernel.org
Date: Wed, 22 Jan 2025 11:43:24 -0500
In-Reply-To: <bug-218267-28872-5V2mMZW0sp@https.bugzilla.kernel.org/>
References: <bug-218267-28872@https.bugzilla.kernel.org/>
	 <bug-218267-28872-5V2mMZW0sp@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2024-12-16 at 19:08 +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=218267
> 
> --- Comment #8 from Sean Christopherson (seanjc@google.com) ---
> Thanks Chao!
> 
> Until the ucode update is available, I think we can workaround the issue in KVM
> by clearing VECTORING_INFO_VALID_MASK _immediately_ after exit, i.e. before
> queueing the event for re-injection, if it should be impossible for the exit to
> have occurred while vectoring.  I'm not sure I want to carry something like
> this long-term since a ucode fix is imminent, but at the least it can hopefully
> unblock end users.
> 
> The below uses a fairly conservative list of exits (a false positive could be
> quite painful).  A slightly less conservative approach would be to also
> include:
> 
> case EXIT_REASON_EXTERNAL_INTERRUPT:
> case EXIT_REASON_TRIPLE_FAULT:
> case EXIT_REASON_INIT_SIGNAL:
> case EXIT_REASON_SIPI_SIGNAL:
> case EXIT_REASON_INTERRUPT_WINDOW:
> case EXIT_REASON_NMI_WINDOW:
> 
> as those exits should all be recognized only at instruction boundaries.
> 
> Compile tested only...
> 
> ---
>  arch/x86/kvm/vmx/vmx.c | 66 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 66 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 893366e53732..7240bd72b5f2 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -147,6 +147,9 @@ module_param_named(preemption_timer,
> enable_preemption_timer, bool, S_IRUGO);
>  extern bool __read_mostly allow_smaller_maxphyaddr;
>  module_param(allow_smaller_maxphyaddr, bool, S_IRUGO);
> 
> +static bool __ro_after_init enable_spr141_erratum_workaround = true;
> +module_param(enable_spr141_erratum_workaround, bool, S_IRUGO);
> +
>  #define KVM_VM_CR0_ALWAYS_OFF (X86_CR0_NW | X86_CR0_CD)
>  #define KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST X86_CR0_NE
>  #define KVM_VM_CR0_ALWAYS_ON                           \
> @@ -7163,8 +7166,67 @@ static void __vmx_complete_interrupts(struct kvm_vcpu
> *vcpu,
>         }
>  }
> 
> +static bool is_vectoring_on_exit_impossible(struct vcpu_vmx *vmx)
> +{
> +       switch (vmx->exit_reason.basic) {
> +       case EXIT_REASON_CPUID:
> +       case EXIT_REASON_HLT:
> +       case EXIT_REASON_INVD:
> +       case EXIT_REASON_INVLPG:
> +       case EXIT_REASON_RDPMC:
> +       case EXIT_REASON_RDTSC:
> +       case EXIT_REASON_VMCALL:
> +       case EXIT_REASON_VMCLEAR:
> +       case EXIT_REASON_VMLAUNCH:
> +       case EXIT_REASON_VMPTRLD:
> +       case EXIT_REASON_VMPTRST:
> +       case EXIT_REASON_VMREAD:
> +       case EXIT_REASON_VMRESUME:
> +       case EXIT_REASON_VMWRITE:
> +       case EXIT_REASON_VMOFF:
> +       case EXIT_REASON_VMON:
> +       case EXIT_REASON_CR_ACCESS:
> +       case EXIT_REASON_DR_ACCESS:
> +       case EXIT_REASON_IO_INSTRUCTION:
> +       case EXIT_REASON_MSR_READ:
> +       case EXIT_REASON_MSR_WRITE:
> +       case EXIT_REASON_MSR_LOAD_FAIL:
> +       case EXIT_REASON_MWAIT_INSTRUCTION:
> +       case EXIT_REASON_MONITOR_TRAP_FLAG:
> +       case EXIT_REASON_MONITOR_INSTRUCTION:
> +       case EXIT_REASON_PAUSE_INSTRUCTION:
> +       case EXIT_REASON_TPR_BELOW_THRESHOLD:
> +       case EXIT_REASON_GDTR_IDTR:
> +       case EXIT_REASON_LDTR_TR:
> +       case EXIT_REASON_INVEPT:
> +       case EXIT_REASON_RDTSCP:
> +       case EXIT_REASON_PREEMPTION_TIMER:
> +       case EXIT_REASON_INVVPID:
> +       case EXIT_REASON_WBINVD:
> +       case EXIT_REASON_XSETBV:
> +       case EXIT_REASON_APIC_WRITE:
> +       case EXIT_REASON_RDRAND:
> +       case EXIT_REASON_INVPCID:
> +       case EXIT_REASON_VMFUNC:
> +       case EXIT_REASON_ENCLS:
> +       case EXIT_REASON_RDSEED:
> +       case EXIT_REASON_XSAVES:
> +       case EXIT_REASON_XRSTORS:
> +       case EXIT_REASON_UMWAIT:
> +       case EXIT_REASON_TPAUSE:
> +               return true;
> +       }
> +
> +       return false;
> +}
> +
>  static void vmx_complete_interrupts(struct vcpu_vmx *vmx)
>  {
> +       if ((vmx->idt_vectoring_info & VECTORING_INFO_VALID_MASK) &&
> +           enable_spr141_erratum_workaround &&
> +           is_vectoring_on_exit_impossible(vmx))
> +               vmx->idt_vectoring_info &= ~VECTORING_INFO_VALID_MASK;
> +
>         __vmx_complete_interrupts(&vmx->vcpu, vmx->idt_vectoring_info,
>                                   VM_EXIT_INSTRUCTION_LEN,
>                                   IDT_VECTORING_ERROR_CODE);
> @@ -8487,6 +8549,10 @@ __init int vmx_hardware_setup(void)
>         if (!enable_apicv || !cpu_has_vmx_ipiv())
>                 enable_ipiv = false;
> 
> +       if (boot_cpu_data.x86_vfm != INTEL_SAPPHIRERAPIDS_X &&
> +           boot_cpu_data.x86_vfm != INTEL_EMERALDRAPIDS_X)
> +               enable_spr141_erratum_workaround = false;
> +
>         if (cpu_has_vmx_tsc_scaling())
>                 kvm_caps.has_tsc_control = true;
> 
> 
> base-commit: 50e5669285fc2586c9f946c1d2601451d77cb49e
> --
> 

Do we plan to move forward with this workaround or you think this is adds too much complexity to KVM?

Best regards,
	Maxim Levitsky




