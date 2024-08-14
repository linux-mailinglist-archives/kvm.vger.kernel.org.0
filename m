Return-Path: <kvm+bounces-24160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 78555951EBE
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 17:38:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D4921F227EE
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 15:38:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD38D1B580B;
	Wed, 14 Aug 2024 15:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Th+u4Q2M"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C811B4C42
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 15:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723649927; cv=none; b=iMCzdA4ha3K/rOXRYtGZ2C0tA8OCTwjR7tg3PtKAw5VnXBE2GVqUkkUb0xePQoEn+b28OSE0fOdmy/jDt5/Zw1obJcwwd5SEyP4uKsMbEubYNUZLBs5lEU9rKKadsGc1z90nERQGLiqJaCxRfFw3dLlldQxVxc06Cf1wOzFcaO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723649927; c=relaxed/simple;
	bh=ZoPRwGV6+5ZCXltJco4xn5q57HOxugw7ILBN8Sr55hU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=YDxGT3EpoRDYQGoBbCw1UxxOyTUY5CDjhIycEfQxqBaQTHNkgbD5M65SqR3vpUciLeQYGLYGnuwu+x8CZ2ulh6hxIRCLaBvpg55JaNSHrcIBj8+8QnZjsOM/TAaDggF/3D+5HJOoiPDPSTgGfY410wCKObE4P7+yOmFKMUZvb3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Th+u4Q2M; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723649923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i0mN78AI6OH+5rESlWtNBfWAVjVg3g3wv0fs76AUNNE=;
	b=Th+u4Q2MlnfQEsp/KRD2wdJJiM5dzUvU4Flv2zkQieRkyIa8VuwSDSQjqd6ae3cQGqYvmT
	SnG+9TO40LqTqTBoQRv2W1aRRA1pg/QwlcmXdEGIju2LFwLXi3nzLg2kRe+unnBLaGr3Hz
	my8kxA4FBf1FIooN9ht3o6sJXIugxuc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-695-FkTD88dXNh2l8gFdhbItzA-1; Wed, 14 Aug 2024 11:38:42 -0400
X-MC-Unique: FkTD88dXNh2l8gFdhbItzA-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-428207daff2so46033695e9.0
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 08:38:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723649921; x=1724254721;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i0mN78AI6OH+5rESlWtNBfWAVjVg3g3wv0fs76AUNNE=;
        b=lMTS5G/E2Wxq4x9XQ9X37+deDzDvnICpYImdA6h8bL4ctndKMg99VqEDfSgKwbPedV
         5dewxrEmfuQb5hyH1Nj8gnA3F436K5gLz73CUotnRaN66dusHRKlEZ1AymR8NuddBOWC
         bVMy4afRb18z/zhi98R8DsrNr5wa50MNkY0UlbANnREHlQO3Dh5V33smocMDxJ5/Ak3B
         0MXWxfgl936L0zpWhJ+JhrRPGJiP2lecHIj9l6vOIIqbwPrY8PQuFefR9p9tvivM1sTB
         RrjZ4eT00PYFk+AQNbZaVSvzUoUSxDB0TqEn0CIuwVRtLgDA22PS05ILQzSR4Mx6XJyU
         aRzA==
X-Forwarded-Encrypted: i=1; AJvYcCUm59tkwq6wxIoPkKCIvI4JQLYkmZZLbq7FwH68ii997FLtMMj6NTGe/7pMZ9j1ZesYxAmi6q2ngFGwsRJYxOipfTkn
X-Gm-Message-State: AOJu0Yz34JANXLB9mGt0FvsjucMICVbBSkZNcfayfl5RkQAxwSKZIBE9
	5wz3GnLGjR8YF+1VRZ7vFylmA6iPiL2LdNL1MIK05Ev/ree45esOP7femGWgqA6fCOrAk7rU+mr
	Ervb9Rjj9v8GWHHC8GXvNMFJYU3+PbHoTfLEcu9m5SSS4cpHcSw==
X-Received: by 2002:a05:600c:1e23:b0:426:6e86:f82 with SMTP id 5b1f17b1804b1-429dd248517mr23328475e9.22.1723649921066;
        Wed, 14 Aug 2024 08:38:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGEWMPGp7i0MQzIzTAb1271vYV1dkuMqPnhA1T15TWPhCom5X/iJ3a44d0WDgW36QkR+Ea3VA==
X-Received: by 2002:a05:600c:1e23:b0:426:6e86:f82 with SMTP id 5b1f17b1804b1-429dd248517mr23328145e9.22.1723649920511;
        Wed, 14 Aug 2024 08:38:40 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429dec83d2asm23671175e9.0.2024.08.14.08.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 08:38:40 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Mirsad Todorovac <mtodorovac69@gmail.com>, kvm@vger.kernel.org, Paolo
 Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo
 Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] arch/x86/kvm/vmx/vmx_onhyperv.h:109:36: error:
 dereference of NULL =?utf-8?B?4oCYMOKAmQ==?=
In-Reply-To: <ZrzIVnkLqcbUKVDZ@google.com>
References: <b44227c5-5af6-4243-8ed9-2b8cdc0e5325@gmail.com>
 <Zpq2Lqd5nFnA0VO-@google.com>
 <207a5c75-b6ad-4bfb-b436-07d4a3353003@gmail.com>
 <87a5i05nqj.fsf@redhat.com>
 <b20eded4-0663-49fb-ba88-5ff002a38a7f@gmail.com>
 <87plqbfq7o.fsf@redhat.com> <ZrzIVnkLqcbUKVDZ@google.com>
Date: Wed, 14 Aug 2024 17:38:39 +0200
Message-ID: <87mslff728.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sean Christopherson <seanjc@google.com> writes:

> On Wed, Aug 14, 2024, Vitaly Kuznetsov wrote:
>> What I meant is something along these lines (untested):
>> 
>> diff --git a/arch/x86/kvm/vmx/vmx_onhyperv.h b/arch/x86/kvm/vmx/vmx_onhyperv.h
>> index eb48153bfd73..e2d8c67d0cad 100644
>> --- a/arch/x86/kvm/vmx/vmx_onhyperv.h
>> +++ b/arch/x86/kvm/vmx/vmx_onhyperv.h
>> @@ -104,6 +104,14 @@ static inline void evmcs_load(u64 phys_addr)
>>         struct hv_vp_assist_page *vp_ap =
>>                 hv_get_vp_assist_page(smp_processor_id());
>>  
>> +       /*
>> +        * When enabling eVMCS, KVM verifies that every CPU has a valid hv_vp_assist_page()
>> +        * and aborts enabling the feature otherwise. CPU onlining path is also checked in
>> +        * vmx_hardware_enable(). With this, it is impossible to reach here with vp_ap == NULL
>> +        * but compilers may still complain.
>> +        */
>> +       BUG_ON(!vp_ap);
>
> A full BUG_ON() is overkill, and easily avoided.  If we want to add a sanity
> check here and do more than just WARN, then it's easy enough to plumb in @vcpu
> and make this a KVM_BUG_ON() so that the VM dies, i.e. so that KVM doesn't risk
> corrupting the guest somehow.
>

I'm still acting under the impression this is an absolutely impossible
situation :-)

AFAICS, we only call evmcs_load() from vmcs_load() but this one doesn't
have @vcpu/@kvm either and I wasn't sure it's worth the effort to do the
plumbing (or am I missing an easy way to go back from @vmcs to
@vcpu?). On the other hand, vmcs_load() should not be called that ofter
so if we prefer to have @vcpu there for some other reason -- why not.

-- 
Vitaly


