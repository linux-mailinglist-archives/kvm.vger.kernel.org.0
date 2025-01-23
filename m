Return-Path: <kvm+bounces-36356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CA65A1A4D2
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 14:24:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 681513AB3C6
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 13:24:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9185020F99B;
	Thu, 23 Jan 2025 13:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dOUBbn+i"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F0520F07B
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 13:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737638669; cv=none; b=bVP9zKanXfgWYsceGCSWyE7SvJ4SeImUcN8446Fwkjfq4q1h1Hrc5/4Nqns/WHAO8tRIaCfEn9kJSy1hkx8a4YnWspAu231mxVPm2wSxCA4DGeVf/Q3bVkbX3F0pgVp6niJaB0kVXi1O5b2h5jP4RsWHy6IV12zLypy7KLhOry8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737638669; c=relaxed/simple;
	bh=IDHLqKrQSkokRQiv4vniWa+Hheh6dE9l+++Q4FF1s+U=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=PZ2d4mqpGVEk+A6u/HGXRB6kn7F6K5OVb+XSIOr4TGc1W7y/J0vDxifbF2uLgVxrXksDAtZQBXHz/Jg68XEwFcllBWLhB7fdc2zlS898QiFai0CpLrikP/dCW/xEnV042WLYUHSj8jN8kQfh7yOitDfgfD3EnHwcDWrHxfUg5IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dOUBbn+i; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737638665;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+2P7LG54VpcftUmxtZvCJfOrW+8I7zw3M+tnUe6zFTs=;
	b=dOUBbn+i+R7KOx/hxseg0vXBRyANavu3AzK4/bxExdHlj0Xm7OytaBp6Ghtzv0Ma8Ycly7
	D/q3gjuI4qjn8jkh/pNMDc8npBSrF9MNdkIXeGLrhQq6bifkCzpSZHJX/tbWfmq6cHrprT
	iR0FK+VWxIOVCbVBpKPeXK9VN0CVu3s=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-HK_qveMnMYiQlinSbYDOfg-1; Thu, 23 Jan 2025 08:24:24 -0500
X-MC-Unique: HK_qveMnMYiQlinSbYDOfg-1
X-Mimecast-MFC-AGG-ID: HK_qveMnMYiQlinSbYDOfg
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3862b364578so1004260f8f.1
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 05:24:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737638663; x=1738243463;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+2P7LG54VpcftUmxtZvCJfOrW+8I7zw3M+tnUe6zFTs=;
        b=fkOnrXlscyJGZjkee2SiewBRpItXib7XePGDD27waqiUHwGXAOd1GGLFKNATKNTFzK
         AMwQIe0BFstcgd/ormF+7wTou0KoZNozmEyiQz95+986HMMvDWM6jhK5ziGuBCUZ2fC4
         aSklCinIHGA2dLFb2ZTHoGLEZ8dVst+APEHRRJbbd/m2rjwpFmCYvY5vzyi448ZvxlYO
         aqV3uN/sv6nJpLHLb3hIR28tURecmyURdaxDXPjWbsQnmyMzXnIckP7ACUupI3UjC72I
         PWKV50ET1o29U/Qe9+GVp7LMYhEOEV1yX6LoOtJqIdg8F4slEg18XAF9mttNQ15JyDfo
         7Mug==
X-Forwarded-Encrypted: i=1; AJvYcCWHov3F9rS3Upa+I/bnDuj/c0llSeHd1mp0FDaOd1uZbYbIqZa1fGZZPTS717Zo14gS0lw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIWmFiCAtyzKZpFVmyQazkHQvUtcYla8yp8dj4OVLZ5IoLekMt
	cL78W6GE8VK5lDovwnKSVB5G1vt9MGEEa1n/+ChjOJNIC2KbhLeBkp6Jh1O3uvTEKRHu/Fje9oB
	cMbky/DtYsntXN4Iz0ut8PavU2GCHvM3Fk0//59zQO8ohlggQTQ==
X-Gm-Gg: ASbGnctT6rlQstoTvi8kFgjq6cksHOTksskyidMquOyu7jrgrqk1j7If+x65Dv0L67h
	XwKPFCk3eJEKpVvVRQi3g/OVjV0Js3Ml1ZfEcsTMy8lgAPHGCnDPUNauWOBVtRut3RvawDgM39j
	STYW4R5oa+IRTqoZCA9Q6K9r80zHS9Eps5FntSdxH4myW1zODXl9f4O2bjce8ZFGpLI5jxQmn0l
	5H3CDdbjqLylH+LXkbfQzuwhxDCriLnDkVQZkFEf3UL60/pkAv3Mcei4vZjCBg8
X-Received: by 2002:a05:600c:4e56:b0:435:edb0:5d27 with SMTP id 5b1f17b1804b1-438b885311bmr32959865e9.9.1737638663250;
        Thu, 23 Jan 2025 05:24:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEGZ8fgl/2JqYhurHCQIe5je3m7D0H/ohAnxMmCKbNiMrEty2wJfWZnNkcxEfQf3dINzx5brg==
X-Received: by 2002:a05:600c:4e56:b0:435:edb0:5d27 with SMTP id 5b1f17b1804b1-438b885311bmr32959595e9.9.1737638662848;
        Thu, 23 Jan 2025 05:24:22 -0800 (PST)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438b31c6fbasm61091735e9.33.2025.01.23.05.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2025 05:24:19 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Fred Griffoul <fgriffo@amazon.co.uk>, kvm@vger.kernel.org, Paolo Bonzini
 <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>, David Woodhouse <dwmw2@infradead.org>, Paul Durrant
 <paul@xen.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Update Xen-specific CPUID leaves during mangling
In-Reply-To: <Z5GXxOr3FHz_53Pj@google.com>
References: <20250122161612.20981-1-fgriffo@amazon.co.uk>
 <87tt9q7orq.fsf@redhat.com> <Z5GXxOr3FHz_53Pj@google.com>
Date: Thu, 23 Jan 2025 14:24:12 +0100
Message-ID: <87frl97jer.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sean Christopherson <seanjc@google.com> writes:

> On Wed, Jan 22, 2025, Vitaly Kuznetsov wrote:
>> > Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
>> > ---
>> >  arch/x86/kvm/cpuid.c | 1 +
>> >  arch/x86/kvm/xen.c   | 5 +++++
>> >  arch/x86/kvm/xen.h   | 5 +++++
>> >  3 files changed, 11 insertions(+)
>> >
>> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> > index edef30359c19..432d8e9e1bab 100644
>> > --- a/arch/x86/kvm/cpuid.c
>> > +++ b/arch/x86/kvm/cpuid.c
>> > @@ -212,6 +212,7 @@ static int kvm_cpuid_check_equal(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2
>> >  	 */
>> >  	kvm_update_cpuid_runtime(vcpu);
>> >  	kvm_apply_cpuid_pv_features_quirk(vcpu);
>> > +	kvm_xen_update_cpuid_runtime(vcpu);
>> 
>> This one is weird as we update it in runtime (kvm_guest_time_update())
>> and values may change when we e.g. migrate the guest. First, I do not
>> understand how the guest is supposed to notice the change as CPUID data
>> is normally considered static.
>
> I don't think it does.  Linux-as-a-guest reads the info once during boot (see
> xen_tsc_safe_clocksource()), and if and only if the TSC is constant and non-stop,
> i.e. iff the values won't change.  

Right, the values shouldn't change on the same host. What I was thinking
is what happens when we migrate the guest to another
host. kvm_guest_time_update() is going to be called and we will get
something different (maybe just slightly different, but still) in Xen
TSC CPUIDs. The guest, however, is likely not going to notice at all.

>
>>  Second, I do not see how the VMM is
>> supposed to track it as if it tries to supply some different data for
>> these Xen leaves, kvm_cpuid_check_equal() will still fail.
>> 
>> Would it make more sense to just ignore these Xen CPUID leaves with TSC
>> information when we do the comparison?
>
> Another alternative would be to modify the register output in kvm_cpuid().  Given
> that Linux reads the info once during boot, and presumably other guests do the
> same, runtime "patching" wouldn't incur meaningful overhead.  And there are no
> feature bits that KVM cares about, i.e. no reason KVM's view needs to be correct.

True, CPUID reading time should not be performance critical.

-- 
Vitaly


