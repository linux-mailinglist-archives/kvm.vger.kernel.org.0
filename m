Return-Path: <kvm+bounces-22192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DAC5A93B661
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 20:01:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 48181B24321
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 18:01:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0295B15FA74;
	Wed, 24 Jul 2024 18:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HVlJuLUP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999E0155A24
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 18:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721844089; cv=none; b=hlPZQu2ZEOdrnNZKI6H91mpVb3Zj+15SKa+wOTtwC5TWnmPUXdkIRsWND68OfClaIfQE+2XqRDFt/xrfw2g2nFdLZAZozYwNhpidhvvutq8yIEqGZpSmJiquUL69LRbB5P47NNgZSHX9/kR5s0U2LpzPeM/l+89K6zWvfoLsnAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721844089; c=relaxed/simple;
	bh=3VdI533cM0GYa0F0eqG4xmGRwz9R3pizNgZoCPbtiZI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IrcCAmb8XkvvJA0XpcyKHl9BKvTT4m69UmjS5ttBN7IXBbad1IrPWWq3H6Pbla+YpHGeqQMj1Hp/k5xGKTxNN6rZ0dlS/TXnYWyO2FDQ+qmoumTK32NEVrV6D+zZ2aJT/MK73CO9eq4QIHGZqfJMCbdIGcH+o7wgDd0M4LqMOUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HVlJuLUP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721844086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8AFBNfkPiZvcok8Os84J2ZL7F5lZOCn0nkvyNcvoYq0=;
	b=HVlJuLUP7QrPLxbeKzZWsuL1FX9aD2nIxyQp3lfLWY8fqmZdTFW4oHms5Fno17A9hCJIJ5
	iIFPr4863eUZ03v5zOHz0I+NcRt5/Q7p457+ZJXV2RlueVvWasXAkj5CoFp01Q8C0sJ6m/
	bwX8VbbpRSxi9uwEmZ4vgAHmKDke9WU=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-363-W2d-Tt_iNFOoRae98PApwA-1; Wed, 24 Jul 2024 14:01:25 -0400
X-MC-Unique: W2d-Tt_iNFOoRae98PApwA-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6b7a4ba59bdso1358966d6.0
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 11:01:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721844084; x=1722448884;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8AFBNfkPiZvcok8Os84J2ZL7F5lZOCn0nkvyNcvoYq0=;
        b=iIHBxTGJGrw2NAnKHhFdLLi0m7k4sKBP6lgm+2uCpaXdWHUbda4eS4LtVkfmUsjwV2
         7izuOnx/xbfuWJ14Z7pqYKrukpTA4mGwFa+22qztQxM+fG/DX3nHlJQ8Ti71ZckvIUlp
         ydY2syjjGg4ObjUSd6weh+8R90IDltKDyWqLr/hXFWPSgHx77HOKCgXMWHacBg3j519G
         O0j1XZBYmQkJbsfDUqfTms0wNVJHrk5tvLmnUGU7SHoQ3NeE7BHoop3VtkgCE/8TttOz
         pfz8oYajfP9lqP9/Vpwrk0UBKpzwDN6Y5NaZulm3EWCiUz+7JpkCNVftJ6S7shd3ojWt
         VqNw==
X-Forwarded-Encrypted: i=1; AJvYcCVRRybdkUq7s0F333LPpfXXtvGYkGi78mpeaSDrbe9ueO/qtHLKdrSAeb/wkre8OAoOgsY503IXhsMwqixXlZPOi1EZ
X-Gm-Message-State: AOJu0YxLFLKZINBjMjW2lPw7Gu0s634vhESyefw/n7EpqakHrZWBnsz4
	T6G0MaXrV+GN6eOuGJC/rc1PEfUccP1auKsa94hWgDk7YsBdnAn+bWkjDzyokVkRde8WFPLz1Rz
	YzfrMIWunwuIT1SYGvH1Qx9sXOw2cd7w3gQP36d47zNHDdvxgww==
X-Received: by 2002:a05:6214:c2f:b0:6b5:8f73:acf6 with SMTP id 6a1803df08f44-6bb3cabeddemr4963086d6.39.1721844084451;
        Wed, 24 Jul 2024 11:01:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEQj/idDGZAuP12zbzSd4PjMkEgd04ezy28B9LetbpCxrEfRPJ6QHjNE4Ba8T+6jNMgbGCK6g==
X-Received: by 2002:a05:6214:c2f:b0:6b5:8f73:acf6 with SMTP id 6a1803df08f44-6bb3cabeddemr4962326d6.39.1721844083686;
        Wed, 24 Jul 2024 11:01:23 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b7ac7bd503sm60129426d6.14.2024.07.24.11.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jul 2024 11:01:22 -0700 (PDT)
Message-ID: <f9b2f9e949a982e07c9ea5ead316ab3809e40543.camel@redhat.com>
Subject: Re: [PATCH v2 40/49] KVM: x86: Initialize guest cpu_caps based on
 KVM support
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov
 <vkuznets@redhat.com>,  kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>,
 Oliver Upton <oliver.upton@linux.dev>, Binbin Wu
 <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>,
 Robert Hoo <robert.hoo.linux@gmail.com>
Date: Wed, 24 Jul 2024 14:01:21 -0400
In-Reply-To: <Zox_4OoDmGDHOaSA@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-41-seanjc@google.com>
	 <030c973172dcf3a24256ddc8ddc5e9ef57ecabcb.camel@redhat.com>
	 <Zox_4OoDmGDHOaSA@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2024-07-08 at 17:10 -0700, Sean Christopherson wrote:
> On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> > On Fri, 2024-05-17 at 10:39 -0700, Sean Christopherson wrote:
> > > @@ -421,6 +423,7 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> > >  	 */
> > >  	for (i = 0; i < NR_KVM_CPU_CAPS; i++) {
> > >  		const struct cpuid_reg cpuid = reverse_cpuid[i];
> > > +		struct kvm_cpuid_entry2 emulated;
> > >  
> > >  		if (!cpuid.function)
> > >  			continue;
> > > @@ -429,7 +432,16 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> > >  		if (!entry)
> > >  			continue;
> > >  
> > > -		vcpu->arch.cpu_caps[i] = cpuid_get_reg_unsafe(entry, cpuid.reg);
> > > +		cpuid_func_emulated(&emulated, cpuid.function);
> > > +
> > > +		/*
> > > +		 * A vCPU has a feature if it's supported by KVM and is enabled
> > > +		 * in guest CPUID.  Note, this includes features that are
> > > +		 * supported by KVM but aren't advertised to userspace!
> > > +		 */
> > > +		vcpu->arch.cpu_caps[i] = kvm_cpu_caps[i] | kvm_vmm_cpu_caps[i] |
> > > +					 cpuid_get_reg_unsafe(&emulated, cpuid.reg);
> > > +		vcpu->arch.cpu_caps[i] &= cpuid_get_reg_unsafe(entry, cpuid.reg);
> > 
> > Hi,
> > 
> > I have an idea. What if we get rid of kvm_vmm_cpu_caps, and instead advertise the
> > MWAIT in KVM_GET_EMULATED_CPUID?
> > 
> > MWAIT is sort of emulated as NOP after all, plus features in KVM_GET_EMULATED_CPUID are
> > sort of 'emulated inefficiently' and you can say that NOP is an inefficient emulation
> > of MWAIT sort of.
> 
> Heh, sort of indeed.  I really don't want to advertise MWAIT to userspace in any
> capacity beyond KVM_CAP_X86_DISABLE_EXITS, because advertising MWAIT to VMs when
> MONITOR/MWAIT exiting is enabled is actively harmful, to both host and guest.

Assuming that the only purpose of the KVM_GET_EMULATED_CPUID is to allow the guest
to use a feature if it really insists, there should be no harm, but yes, I understand
your concert here.

> 
> KVM also doesn't emulate them on #UD, unlike MOVBE, which would make the API even
> more confusing than it already is.
This is even bigger justification for not doing this.


> 
> > It just feels to me that kvm_vmm_cpu_caps, is somewhat an overkill, and its name is
> > somewhat confusing.
> 
> Yeah, I don't love it either, but trying to handle MWAIT as a one-off was even
> uglier.  One option would be to piggyback cpuid_func_emulated(), but add a param
> to have it fill MWAIT only for KVM's internal purposes.  That'd essentially be
> the same as a one-off in kvm_vcpu_after_set_cpuid(), but less ugly.
> 
> I'd say it comes down to whether or not we expect to have more features that KVM
> "supports", but doesn't advertise to userspace.  If we do, then I think adding
> VMM_F() is the way to go.  If we expect MWAIT to be the only feature that gets
> this treatment, then I'm ok if we bastardize cpuid_func_emulated().
> 
> And I think/hope that MWAIT will be a one-off.  Emulating it as a nop was a
> mistake and has since been quirked, and I like to think we (eventually) learn
> from our mistakes.
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 0e64a6332052..dbc3f6ce9203 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -448,7 +448,7 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>                 if (!entry)
>                         continue;
>  
> -               cpuid_func_emulated(&emulated, cpuid.function);
> +               cpuid_func_emulated(&emulated, cpuid.function, false);
>  
>                 /*
>                  * A vCPU has a feature if it's supported by KVM and is enabled
> @@ -1034,7 +1034,8 @@ static struct kvm_cpuid_entry2 *do_host_cpuid(struct kvm_cpuid_array *array,
>         return entry;
>  }
>  
> -static int cpuid_func_emulated(struct kvm_cpuid_entry2 *entry, u32 func)
> +static int cpuid_func_emulated(struct kvm_cpuid_entry2 *entry, u32 func,
> +                              bool only_advertised)

I'll say, lets call this boolean, 'include_partially_emulated', 
(basically features that kvm emulates but only partially,
and thus doesn't advertise, aka mwait)

and then it doesn't look that bad, assuming that comes with a comment.




>  {
>         memset(entry, 0, sizeof(*entry));
>  
> @@ -1048,6 +1049,9 @@ static int cpuid_func_emulated(struct kvm_cpuid_entry2 *entry, u32 func)
>                 return 1;
>         case 1:
>                 entry->ecx = F(MOVBE);
> +               /* comment goes here. */
> +               if (!only_advertised)

And here 

	if(include_partially_emulated) ...


It sort of even self-documents nature of mwait emulation.

> +                       entry->ecx |= F(MWAIT);
>                 return 1;
>         case 7:
>                 entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
> @@ -1065,7 +1069,7 @@ static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
>         if (array->nent >= array->maxnent)
>                 return -E2BIG;
>  
> -       array->nent += cpuid_func_emulated(&array->entries[array->nent], func);
> +       array->nent += cpuid_func_emulated(&array->entries[array->nent], func, true);
>         return 0;
>  }
> 

Best regards,
	Maxim Levitsky



