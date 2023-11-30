Return-Path: <kvm+bounces-2968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 21ECE7FF33E
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 16:11:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4505E1C20FCF
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 15:11:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8E8E51C55;
	Thu, 30 Nov 2023 15:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GuuVtE9U"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA3DF1B4
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 07:11:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701357107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tTb7/Brcw9eH7ls4rESUEPjpWAXCIT3tROznUXci3eY=;
	b=GuuVtE9U6Ojpe2mkS/g0KD8Yeq+r/+C8oFpmvZfJ5U1HamCP/KOLIPQnXMiFHqk+eGO2bN
	L2ySHZqRLT5jdE9R6nDKLoCzQGzBFJRrJNHeHLTwEADl2JK9Ngb0yE9iR45Aqg05CM3xA0
	yoEwLuwKPEb6KAk7IhUkCFcTDr8cP0g=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-94-_pkGI_1sNd6dzBQS8c9LrA-1; Thu, 30 Nov 2023 10:11:46 -0500
X-MC-Unique: _pkGI_1sNd6dzBQS8c9LrA-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-54af4ac76adso863913a12.1
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 07:11:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701357105; x=1701961905;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tTb7/Brcw9eH7ls4rESUEPjpWAXCIT3tROznUXci3eY=;
        b=iTPC5Ln1Qr2fDCoaZ+q/Ca6S6yMLNFd5vgTfgNAm6nPwf3nqORTsmuz8rJlE4q4myk
         OFNJODvREyF/KpN+yFuAacULLoXQzlDv0Myt7OGEYBJlm8iHLVQtxKIKwVtqYZFJflnC
         kZkFe7parJmdoxJJh6aqPc4AbMv+QR7v4m7v6t9Ej4pBNq2+PvO6WWuErtzPui95lTSF
         SM/kKq4l/gz2V+72ZgSE6iIBDDZEHMcINbKGD8RHTABXDzF/gWPO/8JCQnSLbSUT/E30
         zbFA/l3HmPpCPFUHVeMnvxheET4Lk7YnofChcfFuES2eTsYUXux9wEUffOr8RAH+xv2y
         fMGQ==
X-Gm-Message-State: AOJu0YwNg55ILLbGTtx55c49a1hql8myyytdEAKUaMMalyVA+1AstSaM
	TWyrTfkwYDr9E4acEcXzGgBXqpjsvcomHJ0+s88J9HoiCeTFZF74DtFYbNEgC1PnvfDbc7tt4pz
	T1n5Rw8vBc57A
X-Received: by 2002:a05:6402:b44:b0:54b:eae2:31f0 with SMTP id bx4-20020a0564020b4400b0054beae231f0mr2801932edb.38.1701357105107;
        Thu, 30 Nov 2023 07:11:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHcoQRjN9FDyRmd09UWPdOXNcjtgFl05hyoI4ljPOGLTZWlnuhzIwOGMzLfhGUcYX69PhiQWQ==
X-Received: by 2002:a05:6402:b44:b0:54b:eae2:31f0 with SMTP id bx4-20020a0564020b4400b0054beae231f0mr2801912edb.38.1701357104769;
        Thu, 30 Nov 2023 07:11:44 -0800 (PST)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id a7-20020aa7d907000000b0054b37719896sm637773edr.48.2023.11.30.07.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 07:11:44 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Maxim Levitsky
 <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/14] KVM: x86: Make Hyper-V emulation optional
In-Reply-To: <ZWfl3ahamXPPoIGB@google.com>
References: <20231025152406.1879274-1-vkuznets@redhat.com>
 <20231025152406.1879274-11-vkuznets@redhat.com>
 <ZWfl3ahamXPPoIGB@google.com>
Date: Thu, 30 Nov 2023 16:11:43 +0100
Message-ID: <87y1efmg28.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sean Christopherson <seanjc@google.com> writes:

...

>
>>  static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
>>  {
>> @@ -3552,11 +3563,13 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
>>  	if (!nested_vmx_check_permission(vcpu))
>>  		return 1;
>>  
>> +#ifdef CONFIG_KVM_HYPERV
>>  	evmptrld_status = nested_vmx_handle_enlightened_vmptrld(vcpu, launch);
>>  	if (evmptrld_status == EVMPTRLD_ERROR) {
>>  		kvm_queue_exception(vcpu, UD_VECTOR);
>>  		return 1;
>>  	}
>> +#endif
>>  
>>  	kvm_pmu_trigger_event(vcpu, PERF_COUNT_HW_BRANCH_INSTRUCTIONS);
>
> This fails to build with CONFIG_KVM_HYPERV=n && CONFIG_KVM_WERROR=y:
>
> arch/x86/kvm/vmx/nested.c:3577:9: error: variable 'evmptrld_status' is uninitialized when used here [-Werror,-Wuninitialized]
>         if (CC(evmptrld_status == EVMPTRLD_VMFAIL))
>                ^~~~~~~~~~~~~~~
>
> Sadly, simply wrapping with an #ifdef also fails because then evmptrld_status
> becomes unused.  I'd really prefer to avoid having to tag it __maybe_unused, and
> adding more #ifdef would also be ugly.  Any ideas?

A couple,

- we can try putting all eVMPTR logic under 'if (1)' just to create a
  block where we can define evmptrld_status. Not sure this is nicer than
  another #ifdef wrapping evmptrld_status and I'm not sure what to do
  with kvm_pmu_trigger_event() -- can it just go above
  nested_vmx_handle_enlightened_vmptrld()?

- we can add a helper, e.g. 'evmptr_is_vmfail()' and make it just return
  'false' when !CONFIG_KVM_HYPERV.

- rewrite this as a switch to avoid the need for having the local
  variable, (untested)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index c5ec0ef51ff7..b26ce7d596e9 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3553,22 +3553,23 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
        enum nvmx_vmentry_status status;
        struct vcpu_vmx *vmx = to_vmx(vcpu);
        u32 interrupt_shadow = vmx_get_interrupt_shadow(vcpu);
-       enum nested_evmptrld_status evmptrld_status;
 
        if (!nested_vmx_check_permission(vcpu))
                return 1;
 
-       evmptrld_status = nested_vmx_handle_enlightened_vmptrld(vcpu, launch);
-       if (evmptrld_status == EVMPTRLD_ERROR) {
+       switch (nested_vmx_handle_enlightened_vmptrld(vcpu, launch)) {
+       case EVMPTRLD_ERROR:
                kvm_queue_exception(vcpu, UD_VECTOR);
                return 1;
+       case EVMPTRLD_VMFAIL:
+               trace_kvm_nested_vmenter_failed("evmptrld_status", 0);
+               return nested_vmx_failInvalid(vcpu);
+       default:
+               break;
        }
 
        kvm_pmu_trigger_event(vcpu, PERF_COUNT_HW_BRANCH_INSTRUCTIONS);
 
-       if (CC(evmptrld_status == EVMPTRLD_VMFAIL))
-               return nested_vmx_failInvalid(vcpu);
-
        if (CC(!evmptr_is_valid(vmx->nested.hv_evmcs_vmptr) &&
               vmx->nested.current_vmptr == INVALID_GPA))
                return nested_vmx_failInvalid(vcpu);

Unfortunately, I had to open code CC() ;-(

Or maybe just another "#ifdef" is not so ugly after all? :-)

-- 
Vitaly


