Return-Path: <kvm+bounces-8122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BA9C84BCC4
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 19:15:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F3782289536
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 18:15:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0EF61118A;
	Tue,  6 Feb 2024 18:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="on7mZFTL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA151DF56
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 18:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707243344; cv=none; b=C9oTuq0EBPJ09f2Y8GeZIHFoiVSZCNBi/6UNfhIL+RD6zG3hSemt9lYUYRd/Ddxy5A0USdCXGACPtysddj1FowyyM7tkekXit27hhQeiHYHE/4aXI/2iX0A8ZFmza2rtswZ954EowODDJeSyb8+Dr76HiH287hOeoa7jRdDSFHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707243344; c=relaxed/simple;
	bh=pg+A/X0gbzq+b1GNJy+AuaQVvIInNspwG8FTxmbwO9o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mId55aiwZrtbqLFqZt6RDaDNdwpubT2Ck/7MN4gErLALpRUeAikMC2ex/MCk1p++7RX6maakeuKXR4rsXjMR4wGJxIBk2c1RgjdGlJQxSIgstnE5BpKuTzt1/b2YQrXPN/K2Feet0M8LnGF+uI9KYHE55o9XwW8qnQTkT7sditU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=on7mZFTL; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a37721e42feso385234066b.2
        for <kvm@vger.kernel.org>; Tue, 06 Feb 2024 10:15:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1707243340; x=1707848140; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VUAEcL2vNvw2dV15h5Gci8Nd7MVi2WOPefcRANZoiaQ=;
        b=on7mZFTLhJbpsHaakHy1/4tmnXKzc/8nznzmSR9NhqPmDIC2EfuLL9HCXUWN8dAdMK
         /pPaqChrYviqYEEBPs69anHvXmCEGvYzkxmxtxrK1jnbpHbVa4oo6yyatRvn40RIS1hw
         EpjKmiNJwssxuqekhrusTS0SOkydHKk5ZRHE6V30oNpbCpcqjlCOeqDH2dtHeMvmeZjJ
         cNieZM96RM4hY/rldv70B9KU3fxMXSwK85QnAtkJpuFxKzro4d3qHjTF0C8LVJ5RTqSR
         uHjzvCMqUIW0ep6Lk++nfuZ5PpJuEDVVFsrwI4JqxsW06RuyTyIP13+BnQ77u9y926ZC
         SqRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707243340; x=1707848140;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VUAEcL2vNvw2dV15h5Gci8Nd7MVi2WOPefcRANZoiaQ=;
        b=Vew97ZIBvDu3Es+Ljr+JbNEVWwCNTDtX03vtXH6xY4oJ/Z+CdJ4xgKuGM5jt6wM/Kh
         H5JCrys4YLVkuKwZiIMHTGXj01MV/4it/FsZe6rUssshkoHeqzlzN4VdvW0rMr4ampy7
         bg+iPHHXvIQq4uN8V9JSeOFvmYQU5e3WSctvefQ5gDayoHO0OcGblUjGPPVj13bdstAL
         gV8V4jDUZh4bm2Jthoyr33MTqzMU/ulYYn9EUxdSOFJMdxMrlqZmop25erU+QDl4YFHT
         lIVki4844qGZlGjcDrwQZRZAtNbKQ2FCl/QfxlmtVKgNlLf/POHsj9SKCWhq96peGMY3
         rJZA==
X-Gm-Message-State: AOJu0Yx4GnefLIYoKIaqOvBJ2dZVKYBDYlqVclbzx7KPjZAQxAA+dDg9
	jW1P8JQgWixZPhVsi7S2JbQcflJCMDuWV0t7TVfWeLHyg/E8wyu9p7eWJFC7gbU=
X-Google-Smtp-Source: AGHT+IEX6QaUbGSEhCAibVbnYc5A2cH2iDsUX3c8wl5tc0BTXeAPiLYvlkYnfoDR90F+h/HX0ey+5Q==
X-Received: by 2002:a17:906:5398:b0:a38:2664:b65 with SMTP id g24-20020a170906539800b00a3826640b65mr1437645ejo.34.1707243339948;
        Tue, 06 Feb 2024 10:15:39 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCW9yPAU6wo9BbJABQn0bvKX8/Ky7QAE0GVqNhnhJes4qyS5ZMZKb1wWSyLl5IjpguMaf4rtFDVGIrWnfpP4S13VKsOo
Received: from ?IPV6:2003:f6:af18:9900:571f:d8fb:277e:99a5? (p200300f6af189900571fd8fb277e99a5.dip0.t-ipconnect.de. [2003:f6:af18:9900:571f:d8fb:277e:99a5])
        by smtp.gmail.com with ESMTPSA id a19-20020a17090640d300b00a379cc90bdesm1409814ejk.199.2024.02.06.10.15.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Feb 2024 10:15:39 -0800 (PST)
Message-ID: <86024ab8-0483-42a2-ab71-56c720b01b9e@grsecurity.net>
Date: Tue, 6 Feb 2024 19:15:38 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] KVM: x86: Simplify kvm_vcpu_ioctl_x86_get_debugregs()
Content-Language: en-US, de-DE
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20240203124522.592778-1-minipli@grsecurity.net>
 <20240203124522.592778-3-minipli@grsecurity.net>
 <ZcE8rXJiXFS6OFRR@google.com>
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 xsDNBF4u6F8BDAC1kCIyATzlCiDBMrbHoxLywJSUJT9pTbH9MIQIUW8K1m2Ney7a0MTKWQXp
 64/YTQNzekOmta1eZFQ3jqv+iSzfPR/xrDrOKSPrw710nVLC8WL993DrCfG9tm4z3faBPHjp
 zfXBIOuVxObXqhFGvH12vUAAgbPvCp9wwynS1QD6RNUNjnnAxh3SNMxLJbMofyyq5bWK/FVX
 897HLrg9bs12d9b48DkzAQYxcRUNfL9VZlKq1fRbMY9jAhXTV6lcgKxGEJAVqXqOxN8DgZdU
 aj7sMH8GKf3zqYLDvndTDgqqmQe/RF/hAYO+pg7yY1UXpXRlVWcWP7swp8OnfwcJ+PiuNc7E
 gyK2QEY3z5luqFfyQ7308bsawvQcFjiwg+0aPgWawJ422WG8bILV5ylC8y6xqYUeSKv/KTM1
 4zq2vq3Wow63Cd/qyWo6S4IVaEdfdGKVkUFn6FihJD/GxnDJkYJThwBYJpFAqJLj7FtDEiFz
 LXAkv0VBedKwHeBaOAVH6QEAEQEAAc0nTWF0aGlhcyBLcmF1c2UgPG1pbmlwbGlAZ3JzZWN1
 cml0eS5uZXQ+wsERBBMBCgA7AhsDBQsJCAcCBhUKCQgLAgQWAgMBAh4BAheAFiEEd7J359B9
 wKgGsB94J4hPxYYBGYYFAmBbH/cCGQEACgkQJ4hPxYYBGYaX/gv/WYhaehD88XjpEO+yC6x7
 bNWQbk7ea+m82fU2x/x6A9L4DN/BXIxqlONzk3ehvW3wt1hcHeF43q1M/z6IthtxSRi059RO
 SarzX3xfXC1pc5YMgCozgE0VRkxH4KXcijLyFFjanXe0HzlnmpIJB6zTT2jgI70q0FvbRpgc
 rs3VKSFb+yud17KSSN/ir1W2LZPK6er6actK03L92A+jaw+F8fJ9kJZfhWDbXNtEE0+94bMa
 cdDWTaZfy6XJviO3ymVe3vBnSDakVE0HwLyIKvfAEok+YzuSYm1Nbd2T0UxgSUZHYlrUUH0y
 tVxjEFyA+iJRSdm0rbAvzpwau5FOgxRQDa9GXH6ie6/ke2EuZc3STNS6EBciJm1qJ7xb2DTf
 SNyOiWdvop+eQZoznJJte931pxkRaGwV+JXDM10jGTfyV7KT9751xdn6b6QjQANTgNnGP3qs
 TO5oU3KukRHgDcivzp6CWb0X/WtKy0Y/54bTJvI0e5KsAz/0iwH19IB0vpYLzsDNBF4u6F8B
 DADwcu4TPgD5aRHLuyGtNUdhP9fqhXxUBA7MMeQIY1kLYshkleBpuOpgTO/ikkQiFdg13yIv
 q69q/feicsjaveIEe7hUI9lbWcB9HKgVXW3SCLXBMjhCGCNLsWQsw26gRxDy62UXRCTCT3iR
 qHP82dxPdNwXuOFG7IzoGBMm3vZbBeKn0pYYWz2MbTeyRHn+ZubNHqM0cv5gh0FWsQxrg1ss
 pnhcd+qgoynfuWAhrPD2YtNB7s1Vyfk3OzmL7DkSDI4+SzS56cnl9Q4mmnsVh9eyae74pv5w
 kJXy3grazD1lLp+Fq60Iilc09FtWKOg/2JlGD6ZreSnECLrawMPTnHQZEIBHx/VLsoyCFMmO
 5P6gU0a9sQWG3F2MLwjnQ5yDPS4IRvLB0aCu+zRfx6mz1zYbcVToVxQqWsz2HTqlP2ZE5cdy
 BGrQZUkKkNH7oQYXAQyZh42WJo6UFesaRAPc3KCOCFAsDXz19cc9l6uvHnSo/OAazf/RKtTE
 0xGB6mQN34UAEQEAAcLA9gQYAQoAIAIbDBYhBHeyd+fQfcCoBrAfeCeIT8WGARmGBQJeORkW
 AAoJECeIT8WGARmGXtgL/jM4NXaPxaIptPG6XnVWxhAocjk4GyoUx14nhqxHmFi84DmHUpMz
 8P0AEACQ8eJb3MwfkGIiauoBLGMX2NroXcBQTi8gwT/4u4Gsmtv6P27Isn0hrY7hu7AfgvnK
 owfBV796EQo4i26ZgfSPng6w7hzCR+6V2ypdzdW8xXZlvA1D+gLHr1VGFA/ZCXvVcN1lQvIo
 S9yXo17bgy+/Xxi2YZGXf9AZ9C+g/EvPgmKrUPuKi7ATNqloBaN7S2UBJH6nhv618bsPgPqR
 SV11brVF8s5yMiG67WsogYl/gC2XCj5qDVjQhs1uGgSc9LLVdiKHaTMuft5gSR9hS5sMb/cL
 zz3lozuC5nsm1nIbY62mR25Kikx7N6uL7TAZQWazURzVRe1xq2MqcF+18JTDdjzn53PEbg7L
 VeNDGqQ5lJk+rATW2VAy8zasP2/aqCPmSjlCogC6vgCot9mj+lmMkRUxspxCHDEms13K41tH
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <ZcE8rXJiXFS6OFRR@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 05.02.24 20:53, Sean Christopherson wrote:
> On Sat, Feb 03, 2024, Mathias Krause wrote:
>> Take 'dr6' from the arch part directly as already done for 'dr7'.
>> There's no need to take the clunky route via kvm_get_dr().
>>
>> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
>> ---
>>  arch/x86/kvm/x86.c | 5 +----
>>  1 file changed, 1 insertion(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 13ec948f3241..0f958dcf8458 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -5504,12 +5504,9 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
>>  static void kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
>>  					     struct kvm_debugregs *dbgregs)
>>  {
>> -	unsigned long val;
>> -
>>  	memset(dbgregs, 0, sizeof(*dbgregs));
>>  	memcpy(dbgregs->db, vcpu->arch.db, sizeof(vcpu->arch.db));
>> -	kvm_get_dr(vcpu, 6, &val);
>> -	dbgregs->dr6 = val;
>> +	dbgregs->dr6 = vcpu->arch.dr6;
> 
> Blech, kvm_get_dr() is so dumb, it takes an out parameter despite have a void
> return.

Jepp, that's why I tried to get rid of it.

>          I would rather fix that wart and go the other direction, i.e. make dr7
> go through kvm_get_dr().  This obviously isn't a fast path, so the extra CALL+RET
> is a non-issue.

Okay. I thought, as this is an indirect call which is slightly more
expensive under RETPOLINE, I'd go the other way and simply open-code the
access, as done a few lines below in kvm_vcpu_ioctl_x86_set_debugregs().

But I don't mind that hard. You just mentioned last year[1], this part
shouldn't be squashed into what became patch 3 in this series.

[1] https://lore.kernel.org/kvm/ZCxarzBknX6o7dcb@google.com/

>                  And if we wanted to fix that, e.g. for other paths that are
> slightly less slow, we should do so for all reads (and writes) to dr6 and dr7,
> e.g. provide dedicated APIs like we do for GPRs.
> 
> Alternatively, I would probably be ok just open coding all direct reads and writes
> to dr6 and dr7.  IIRC, at one point KVM was doing something meaningful in kvm_get_dr()
> for DR7 (which probably contributed to the weird API), but that's no longer the
> case.

Yeah, that special handling got simplified in commit 5679b803e44e ("KVM:
SVM: keep DR6 synchronized with vcpu->arch.dr6"). And yes, open-coding
the accesses would be my preferred option, as it's easier to read and
generates even less code. No need to have this indirection for a simple
member access.

> 
> Actually, it probably makes sense to do both, i.e. do the below, and then open
> code all direct accesses.  I think the odds of us needing wrappers around reading
> and writing guest DR6 and DR7 are quite low and there are enough existing open coded
> accesses that forcing them to convert would be awkward.
> 
> I'll send a small two patch series.
> 
> ---
> Subject: [PATCH] KVM: x86: Make kvm_get_dr() return a value, not use an out
>  parameter
> 
> TODO: writeme
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/kvm/emulate.c          | 17 ++++-------------
>  arch/x86/kvm/kvm_emulate.h      |  2 +-
>  arch/x86/kvm/smm.c              | 15 ++++-----------
>  arch/x86/kvm/svm/svm.c          |  7 ++-----
>  arch/x86/kvm/vmx/nested.c       |  2 +-
>  arch/x86/kvm/vmx/vmx.c          |  5 +----
>  arch/x86/kvm/x86.c              | 20 ++++++++------------
>  8 files changed, 22 insertions(+), 48 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index ad5319a503f0..464fa2197748 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2046,7 +2046,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3);
>  int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
>  int kvm_set_cr8(struct kvm_vcpu *vcpu, unsigned long cr8);
>  int kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val);
> -void kvm_get_dr(struct kvm_vcpu *vcpu, int dr, unsigned long *val);
> +unsigned long kvm_get_dr(struct kvm_vcpu *vcpu, int dr);
>  unsigned long kvm_get_cr8(struct kvm_vcpu *vcpu);
>  void kvm_lmsw(struct kvm_vcpu *vcpu, unsigned long msw);
>  int kvm_emulate_xsetbv(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 695ab5b6055c..33444627fcf4 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -3011,7 +3011,7 @@ static int emulator_do_task_switch(struct x86_emulate_ctxt *ctxt,
>  		ret = em_push(ctxt);
>  	}
>  
> -	ops->get_dr(ctxt, 7, &dr7);
> +	dr7 = ops->get_dr(ctxt, 7);
>  	ops->set_dr(ctxt, 7, dr7 & ~(DR_LOCAL_ENABLE_MASK | DR_LOCAL_SLOWDOWN));
>  
>  	return ret;
> @@ -3866,15 +3866,6 @@ static int check_cr_access(struct x86_emulate_ctxt *ctxt)
>  	return X86EMUL_CONTINUE;
>  }
>  
> -static int check_dr7_gd(struct x86_emulate_ctxt *ctxt)
> -{
> -	unsigned long dr7;
> -
> -	ctxt->ops->get_dr(ctxt, 7, &dr7);
> -
> -	return dr7 & DR7_GD;
> -}
> -
>  static int check_dr_read(struct x86_emulate_ctxt *ctxt)
>  {
>  	int dr = ctxt->modrm_reg;
> @@ -3887,10 +3878,10 @@ static int check_dr_read(struct x86_emulate_ctxt *ctxt)
>  	if ((cr4 & X86_CR4_DE) && (dr == 4 || dr == 5))
>  		return emulate_ud(ctxt);
>  
> -	if (check_dr7_gd(ctxt)) {
> +	if (ctxt->ops->get_dr(ctxt, 7) & DR7_GD) {
>  		ulong dr6;
>  
> -		ctxt->ops->get_dr(ctxt, 6, &dr6);
> +		dr6 = ctxt->ops->get_dr(ctxt, 6);
>  		dr6 &= ~DR_TRAP_BITS;
>  		dr6 |= DR6_BD | DR6_ACTIVE_LOW;
>  		ctxt->ops->set_dr(ctxt, 6, dr6);
> @@ -5449,7 +5440,7 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
>  		ctxt->dst.val = ops->get_cr(ctxt, ctxt->modrm_reg);
>  		break;
>  	case 0x21: /* mov from dr to reg */
> -		ops->get_dr(ctxt, ctxt->modrm_reg, &ctxt->dst.val);
> +		ctxt->dst.val = ops->get_dr(ctxt, ctxt->modrm_reg);
>  		break;
>  	case 0x40 ... 0x4f:	/* cmov */
>  		if (test_cc(ctxt->b, ctxt->eflags))
> diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
> index 4351149484fb..5382646162a3 100644
> --- a/arch/x86/kvm/kvm_emulate.h
> +++ b/arch/x86/kvm/kvm_emulate.h
> @@ -203,7 +203,7 @@ struct x86_emulate_ops {
>  	ulong (*get_cr)(struct x86_emulate_ctxt *ctxt, int cr);
>  	int (*set_cr)(struct x86_emulate_ctxt *ctxt, int cr, ulong val);
>  	int (*cpl)(struct x86_emulate_ctxt *ctxt);
> -	void (*get_dr)(struct x86_emulate_ctxt *ctxt, int dr, ulong *dest);
> +	ulong (*get_dr)(struct x86_emulate_ctxt *ctxt, int dr);
>  	int (*set_dr)(struct x86_emulate_ctxt *ctxt, int dr, ulong value);
>  	int (*set_msr_with_filter)(struct x86_emulate_ctxt *ctxt, u32 msr_index, u64 data);
>  	int (*get_msr_with_filter)(struct x86_emulate_ctxt *ctxt, u32 msr_index, u64 *pdata);
> diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
> index dc3d95fdca7d..f5a30d3a44a1 100644
> --- a/arch/x86/kvm/smm.c
> +++ b/arch/x86/kvm/smm.c
> @@ -184,7 +184,6 @@ static void enter_smm_save_state_32(struct kvm_vcpu *vcpu,
>  				    struct kvm_smram_state_32 *smram)
>  {
>  	struct desc_ptr dt;
> -	unsigned long val;
>  	int i;
>  
>  	smram->cr0     = kvm_read_cr0(vcpu);
> @@ -195,10 +194,8 @@ static void enter_smm_save_state_32(struct kvm_vcpu *vcpu,
>  	for (i = 0; i < 8; i++)
>  		smram->gprs[i] = kvm_register_read_raw(vcpu, i);
>  
> -	kvm_get_dr(vcpu, 6, &val);
> -	smram->dr6     = (u32)val;
> -	kvm_get_dr(vcpu, 7, &val);
> -	smram->dr7     = (u32)val;
> +	smram->dr6     = (u32)kvm_get_dr(vcpu, 6);
> +	smram->dr7     = (u32)kvm_get_dr(vcpu, 7);
>  
>  	enter_smm_save_seg_32(vcpu, &smram->tr, &smram->tr_sel, VCPU_SREG_TR);
>  	enter_smm_save_seg_32(vcpu, &smram->ldtr, &smram->ldtr_sel, VCPU_SREG_LDTR);
> @@ -231,7 +228,6 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu,
>  				    struct kvm_smram_state_64 *smram)
>  {
>  	struct desc_ptr dt;
> -	unsigned long val;
>  	int i;
>  
>  	for (i = 0; i < 16; i++)
> @@ -240,11 +236,8 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu,
>  	smram->rip    = kvm_rip_read(vcpu);
>  	smram->rflags = kvm_get_rflags(vcpu);
>  
> -
> -	kvm_get_dr(vcpu, 6, &val);
> -	smram->dr6 = val;
> -	kvm_get_dr(vcpu, 7, &val);
> -	smram->dr7 = val;
> +	smram->dr6 = kvm_get_dr(vcpu, 6);
> +	smram->dr7 = kvm_get_dr(vcpu, 7);;
>  
>  	smram->cr0 = kvm_read_cr0(vcpu);
>  	smram->cr3 = kvm_read_cr3(vcpu);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index e90b429c84f1..dda91f7cd71b 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2735,7 +2735,6 @@ static int dr_interception(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	int reg, dr;
> -	unsigned long val;
>  	int err = 0;
>  
>  	/*
> @@ -2763,11 +2762,9 @@ static int dr_interception(struct kvm_vcpu *vcpu)
>  	dr = svm->vmcb->control.exit_code - SVM_EXIT_READ_DR0;
>  	if (dr >= 16) { /* mov to DRn  */
>  		dr -= 16;
> -		val = kvm_register_read(vcpu, reg);
> -		err = kvm_set_dr(vcpu, dr, val);
> +		err = kvm_set_dr(vcpu, dr, kvm_register_read(vcpu, reg));
>  	} else {
> -		kvm_get_dr(vcpu, dr, &val);
> -		kvm_register_write(vcpu, reg, val);
> +		kvm_register_write(vcpu, reg, kvm_get_dr(vcpu, dr));
>  	}
>  
>  	return kvm_complete_insn_gp(vcpu, err);
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 994e014f8a50..28d1088a1770 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4433,7 +4433,7 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
>  		(vm_entry_controls_get(to_vmx(vcpu)) & VM_ENTRY_IA32E_MODE);
>  
>  	if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_DEBUG_CONTROLS)
> -		kvm_get_dr(vcpu, 7, (unsigned long *)&vmcs12->guest_dr7);
> +		vmcs12->guest_dr7 = kvm_get_dr(vcpu, 7);
>  
>  	if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_IA32_EFER)
>  		vmcs12->guest_ia32_efer = vcpu->arch.efer;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index e262bc2ba4e5..aa47433d0c9b 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5566,10 +5566,7 @@ static int handle_dr(struct kvm_vcpu *vcpu)
>  
>  	reg = DEBUG_REG_ACCESS_REG(exit_qualification);
>  	if (exit_qualification & TYPE_MOV_FROM_DR) {
> -		unsigned long val;
> -
> -		kvm_get_dr(vcpu, dr, &val);
> -		kvm_register_write(vcpu, reg, val);
> +		kvm_register_write(vcpu, reg, kvm_get_dr(vcpu, dr));
>  		err = 0;
>  	} else {
>  		err = kvm_set_dr(vcpu, dr, kvm_register_read(vcpu, reg));
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c339d9f95b4b..b2357009bbbe 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1399,21 +1399,21 @@ int kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
>  }
>  EXPORT_SYMBOL_GPL(kvm_set_dr);
>  
> -void kvm_get_dr(struct kvm_vcpu *vcpu, int dr, unsigned long *val)
> +unsigned long kvm_get_dr(struct kvm_vcpu *vcpu, int dr)
>  {
>  	size_t size = ARRAY_SIZE(vcpu->arch.db);
>  
>  	switch (dr) {
>  	case 0 ... 3:
> -		*val = vcpu->arch.db[array_index_nospec(dr, size)];
> +		return vcpu->arch.db[array_index_nospec(dr, size)];
>  		break;
>  	case 4:
>  	case 6:
> -		*val = vcpu->arch.dr6;
> +		return vcpu->arch.dr6;
>  		break;
>  	case 5:
>  	default: /* 7 */
> -		*val = vcpu->arch.dr7;
> +		return vcpu->arch.dr7;
>  		break;
>  	}
>  }
> @@ -5510,13 +5510,10 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
>  static void kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
>  					     struct kvm_debugregs *dbgregs)
>  {
> -	unsigned long val;
> -
>  	memset(dbgregs, 0, sizeof(*dbgregs));
>  	memcpy(dbgregs->db, vcpu->arch.db, sizeof(vcpu->arch.db));
> -	kvm_get_dr(vcpu, 6, &val);
> -	dbgregs->dr6 = val;
> -	dbgregs->dr7 = vcpu->arch.dr7;
> +	dbgregs->dr6 = kvm_get_dr(vcpu, 6);
> +	dbgregs->dr7 = kvm_get_dr(vcpu, 7);
>  }
>  
>  static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
> @@ -8165,10 +8162,9 @@ static void emulator_wbinvd(struct x86_emulate_ctxt *ctxt)
>  	kvm_emulate_wbinvd_noskip(emul_to_vcpu(ctxt));
>  }
>  
> -static void emulator_get_dr(struct x86_emulate_ctxt *ctxt, int dr,
> -			    unsigned long *dest)
> +static unsigned long emulator_get_dr(struct x86_emulate_ctxt *ctxt, int dr)
>  {
> -	kvm_get_dr(emul_to_vcpu(ctxt), dr, dest);
> +	return kvm_get_dr(emul_to_vcpu(ctxt), dr);
>  }
>  
>  static int emulator_set_dr(struct x86_emulate_ctxt *ctxt, int dr,
> 
> base-commit: 60eedcfceda9db46f1b333e5e1aa9359793f04fb

As this provides a saner API to kvm_set_dr(),
Acked-by: Mathias Krause <minipli@grsecurity.net>

