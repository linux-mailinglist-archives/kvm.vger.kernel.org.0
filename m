Return-Path: <kvm+bounces-24237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 67DE5952AD4
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 10:46:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC9571F22EF6
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 08:46:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B1AF1AE843;
	Thu, 15 Aug 2024 08:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IhuvzyuS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E6513D245
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 08:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723709761; cv=none; b=b58IkL4nusdBrnAPJpmPLW1yRPbKkPhhr6ui+xtmF7+gcJON6Cu2JZjHn4IAxoji96HK7C43hCq2CEnXf/tg4jRHBwSQ2a7NkEoWL2Bjk8YgUPxg3i18M76YLzhyOjuNf6FH1u+N7AynNimWuXdpBZT4GtfOOLn5cM8xCtvsa6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723709761; c=relaxed/simple;
	bh=It2n54/Wszz22dJy2yFkRqq3oHwCh6v6hF6ITpdTWaA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=h6yDqTMWFxYXHfUiLUeHmZUn02JGKxP0hFWX1kIpPxTubp+zKDow5Mw5l+BhPgIz0g42/ZqbjBDjY2Rjfa/NlchN9G6KjhMOLCWhHM533NBMTD/5M2vDbWK46osZVZMPD51Z3BC4JWm3diy3BHIeJdY48G82V1pZwcpFEnHvLfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IhuvzyuS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723709758;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6siwQRc65l8C/JRIpOzVH+/lh/N1bi7Q5Wrmcr0+NwY=;
	b=IhuvzyuSpylJsuXEmU1GoeMFuupKnqzLMsmmPzZMCoI91LcLIq9baHcZ9j+qCmUiuYxTdq
	HtzOLKMKyQqANVpTKZbTJoRmlhHimDmZ5jqJXHVDBfv3tXyP/2skp6bu9eCt8DdLn9ISe3
	4HxAsLzApOCP6iE/pggeoOKJlfxz0uc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-297-rgq3nb15NUmyY0F83FeGUA-1; Thu, 15 Aug 2024 04:15:57 -0400
X-MC-Unique: rgq3nb15NUmyY0F83FeGUA-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-428fc34f41bso3925945e9.3
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 01:15:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723709756; x=1724314556;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6siwQRc65l8C/JRIpOzVH+/lh/N1bi7Q5Wrmcr0+NwY=;
        b=BRFiODOysnv7lqQF0Ig8TBY5SujGQXQL+4BXYSLQJ3AlC+VsWHDEBPG2bZCO6uPjQ/
         xkxUwJd577jsUVaQfQavKufSbuhFiyjtq6jaiLT54Li/ZEQRrPPz8xJghl3o9kBeoDtG
         AEBop0zq+lnKzPmv7Tthrww3q3Iom0y3W6gIg2mawqy1TLbaWFvo51xpQEf89NNegXTc
         /6IxCv1A3O0JK8ePWzmt4Y/7nu3y2afqsKZIGPIsBll5vH0MV5ejxQdfVK0FO0JkldsR
         DzbMFCPSllxFHl5/Fptswt+q93958w1ZdTFMurKq83q2J0HemZNFxf9uaXkFToj7DBdI
         t3vQ==
X-Forwarded-Encrypted: i=1; AJvYcCWq22DjZTavcdZWUuznTBWNtHefZqNcwb1wdEoNvxsndYcl0ZmHy0FWz7ca6KV/ts7a0bH1XN4Q2E+qMggREOAaegfw
X-Gm-Message-State: AOJu0YwPSIF0oa5LSYWC2R9qgNegLWIe6OXs6YMiTdW2f2Glj3KjOYiB
	lHk8q7oyGILennrohckJwVPxChk1RfMdReuRvRVsOE+uNGhbufs742uIWe3CmfyNdtN+KYKEb4h
	ZR7PiCjE0iN8naB1XnFwJU2p1jgPxSEfqKJf65xTFh8seRJuDfg==
X-Received: by 2002:a05:600c:190e:b0:427:ff7a:79e with SMTP id 5b1f17b1804b1-429dd2393f0mr36254965e9.16.1723709755693;
        Thu, 15 Aug 2024 01:15:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEoCzTh17WSwxryGBjxZNK9ZCVO20bZbVHu6qlfgD4Z3joMLanQfxCiyYHbDAD7X7wJK27mdQ==
X-Received: by 2002:a05:600c:190e:b0:427:ff7a:79e with SMTP id 5b1f17b1804b1-429dd2393f0mr36254675e9.16.1723709755074;
        Thu, 15 Aug 2024 01:15:55 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429e7e1ca28sm11970905e9.44.2024.08.15.01.15.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2024 01:15:54 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Mirsad Todorovac <mtodorovac69@gmail.com>, kvm@vger.kernel.org, Paolo
 Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo
 Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] arch/x86/kvm/vmx/vmx_onhyperv.h:109:36: error:
 dereference of NULL =?utf-8?B?4oCYMOKAmQ==?=
In-Reply-To: <Zr0rEy0bO1ju_f1C@google.com>
References: <b44227c5-5af6-4243-8ed9-2b8cdc0e5325@gmail.com>
 <Zpq2Lqd5nFnA0VO-@google.com>
 <207a5c75-b6ad-4bfb-b436-07d4a3353003@gmail.com>
 <87a5i05nqj.fsf@redhat.com>
 <b20eded4-0663-49fb-ba88-5ff002a38a7f@gmail.com>
 <87plqbfq7o.fsf@redhat.com> <ZrzIVnkLqcbUKVDZ@google.com>
 <87mslff728.fsf@redhat.com> <Zr0rEy0bO1ju_f1C@google.com>
Date: Thu, 15 Aug 2024 10:15:53 +0200
Message-ID: <87h6bmfbgm.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sean Christopherson <seanjc@google.com> writes:

> On Wed, Aug 14, 2024, Vitaly Kuznetsov wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>> 
>> > On Wed, Aug 14, 2024, Vitaly Kuznetsov wrote:
>> >> What I meant is something along these lines (untested):
>> >> 
>> >> diff --git a/arch/x86/kvm/vmx/vmx_onhyperv.h b/arch/x86/kvm/vmx/vmx_onhyperv.h
>> >> index eb48153bfd73..e2d8c67d0cad 100644
>> >> --- a/arch/x86/kvm/vmx/vmx_onhyperv.h
>> >> +++ b/arch/x86/kvm/vmx/vmx_onhyperv.h
>> >> @@ -104,6 +104,14 @@ static inline void evmcs_load(u64 phys_addr)
>> >>         struct hv_vp_assist_page *vp_ap =
>> >>                 hv_get_vp_assist_page(smp_processor_id());
>> >>  
>> >> +       /*
>> >> +        * When enabling eVMCS, KVM verifies that every CPU has a valid hv_vp_assist_page()
>> >> +        * and aborts enabling the feature otherwise. CPU onlining path is also checked in
>> >> +        * vmx_hardware_enable(). With this, it is impossible to reach here with vp_ap == NULL
>> >> +        * but compilers may still complain.
>> >> +        */
>> >> +       BUG_ON(!vp_ap);
>> >
>> > A full BUG_ON() is overkill, and easily avoided.  If we want to add a sanity
>> > check here and do more than just WARN, then it's easy enough to plumb in @vcpu
>> > and make this a KVM_BUG_ON() so that the VM dies, i.e. so that KVM doesn't risk
>> > corrupting the guest somehow.
>> >
>> 
>> I'm still acting under the impression this is an absolutely impossible
>> situation :-)
>> 
>> AFAICS, we only call evmcs_load() from vmcs_load() but this one doesn't
>> have @vcpu/@kvm either and I wasn't sure it's worth the effort to do the
>> plumbing (or am I missing an easy way to go back from @vmcs to
>> @vcpu?). On the other hand, vmcs_load() should not be called that ofter
>> so if we prefer to have @vcpu there for some other reason -- why not.
>
> kvm_get_running_vcpu(), though I honestly purposely didn't suggest it earlier
> because I am not a fan of using kvm_get_running_vcpu() unless it's absolutely
> necessary.  But for this situation, I'd be fine with using it.

Ah, nice, so we don't even need the plumbing then I guess? Compile-tested only:

diff --git a/arch/x86/kvm/vmx/vmx_onhyperv.h b/arch/x86/kvm/vmx/vmx_onhyperv.h
index eb48153bfd73..318f5f95f211 100644
--- a/arch/x86/kvm/vmx/vmx_onhyperv.h
+++ b/arch/x86/kvm/vmx/vmx_onhyperv.h
@@ -104,6 +104,19 @@ static inline void evmcs_load(u64 phys_addr)
        struct hv_vp_assist_page *vp_ap =
                hv_get_vp_assist_page(smp_processor_id());
 
+       /*
+        * When enabling eVMCS, KVM verifies that every CPU has a valid hv_vp_assist_page()
+        * and aborts enabling the feature otherwise. CPU onlining path is also checked in
+        * vmx_hardware_enable(). With this, it is impossible to reach here with vp_ap == NULL
+        * but compilers may still complain.
+        */
+       if (!vp_ap) {
+               struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+
+               KVM_BUG_ON(1, vcpu->kvm);
+               return;
+       }
+
        if (current_evmcs->hv_enlightenments_control.nested_flush_hypercall)
                vp_ap->nested_control.features.directhypercall = 1;
        vp_ap->current_nested_vmcs = phys_addr;

(I hope we can't reach here with kvm_running_vcpu unset, can we?)

-- 
Vitaly


