Return-Path: <kvm+bounces-19032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AA5328FF464
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 20:11:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 256581F251BB
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 18:11:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BDD0199382;
	Thu,  6 Jun 2024 18:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="wSHTyWQ0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728DF16FF26
	for <kvm@vger.kernel.org>; Thu,  6 Jun 2024 18:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717697508; cv=none; b=BKGhxDV5w/KtZNqM3kJMVEWeQrFWe/eI4M0Dr1KqfPfzEfDq8LiYMYSN4FMj41UyybsZsxuQupN2HbkSHtWWhiXT9cHBRlp+TW8qqDCrLz1CveKq5lo/KNEgcRSJVJ/ParpIm6D8FvEwUaA3IZBm+5Az0RZ/aPex5ztoZV/d8LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717697508; c=relaxed/simple;
	bh=tw5f0ihRtnPvvSMTJncRv3vftVqngxBM4EymCgXJwvI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PfZUy4GtUHZlXDQUKYVmOifADa8aGJb8iBPN2Wl2fngd3aazh7kBIotVCiCuL02zU/pyR/T36+Ujt5gSwX0/YvI+mw1yOukziJD+4HHqvOJarMsjhxv5tmg0oyJpgtnfpLPhmjeVP2kGRu9RY/gpSYiRdwHs0AyfdPe0egmndak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=wSHTyWQ0; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a6265d3ba8fso128704866b.0
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2024 11:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1717697505; x=1718302305; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=j4Clis/tjBpykOPcSvVgtELRUK5ht8moUPF942xv+zg=;
        b=wSHTyWQ0tGDftnZm0wLop9vgA0EqAyWWbAZegfDVnAS4dNH6z1zKbv+jouTCh66Htr
         9TXSdqcDVrQH6KeRS9GOpDO5S2cVi/2nxUoK5dZS3qllD0E0zY39mH5SoJL9Fk5L+r5D
         w7MRNUjjIPI6OJfxPhq/x2M3zd2lJYv1VygOb2TwEf83SnyUTXdFnPJ8+0gXVBXsqIO/
         yXsr9UwW4GubegMur+cCmL9VXZ7tMr/p9oCG93WXeu7FRbyihN1ZL+ztHf/xQJSA95+b
         5tHJ7QUHpCBneD4y14N6tlhdOV1Bk9zDrZASiLk1uNiraYk183ja0x+aQ2hPIYGeA/Q8
         MMXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717697505; x=1718302305;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j4Clis/tjBpykOPcSvVgtELRUK5ht8moUPF942xv+zg=;
        b=rxRapCDqy4hox/8Lx1FnWkve0jwFnF5HmVyTX0T9W2MLni4NV39zTDFXzHkdD0Anol
         7SumjA9ezCSGSHZOO4bHfAvjBgYxfXYt4j0lG2Nt4AhP/SyAzIrc1uSXQwFuPzLxPDI2
         gGisZz/ZtMt9oE/B8VBEEpM5uJwZO9Hu6Wa1DfhoffLD+sNGCHIlnw+KOpkIWQZEJcOj
         1o+rUUhPySnYgHZfgO5SE1pWpe9vq07pFbW+TMSv96oBXZmqBhWZwTXbMk+CCEUwBPxQ
         l+NpKNbWXmLnwamuTUWWJQmMi3iAoMnEtORrMfZ2vLnAaGwgPUwY+nSET0D7372Qfshb
         RcFA==
X-Forwarded-Encrypted: i=1; AJvYcCVbQ26kraDwuH+1KuyVrsrAY+ZrOetBtH+OPGzAUZZ9QzeOo4y5/yscJw5V3B7NN9D11IrpdB6O3q3ETp0AFIggOtDF
X-Gm-Message-State: AOJu0YxAE76rlLl16MIkyMYzU2Kx7AHWoEgf/Ho63DkA798Uz/7VJpXA
	mkVD6dOOpBqFz7FXBz2AnOXoA8AeivkXr5q4iHFUeapffCKEXTq0gUxW1wZYLWY=
X-Google-Smtp-Source: AGHT+IHojGd3CK47k9SjCqg75murJfLY9ma5GhaHVuJAH9RPAfOHSSBwwwcYYgDU5fUfQb5fFtUMIA==
X-Received: by 2002:a17:906:fd85:b0:a5c:fc25:2730 with SMTP id a640c23a62f3a-a6cd560faa1mr36132666b.4.1717697504430;
        Thu, 06 Jun 2024 11:11:44 -0700 (PDT)
Received: from ?IPV6:2003:f6:af22:bc00:4b8d:639a:480e:4db? (p200300f6af22bc004b8d639a480e04db.dip0.t-ipconnect.de. [2003:f6:af22:bc00:4b8d:639a:480e:4db])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6c80582335sm127005866b.39.2024.06.06.11.11.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Jun 2024 11:11:43 -0700 (PDT)
Message-ID: <516b4fd8-e1fd-43ec-a138-f670cc62a625@grsecurity.net>
Date: Thu, 6 Jun 2024 20:11:42 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: Reject overly excessive IDs in KVM_CREATE_VCPU
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 Emese Revfy <re.emese@gmail.com>, PaX Team <pageexec@freemail.hu>
References: <20240605220504.2941958-1-minipli@grsecurity.net>
 <20240605220504.2941958-2-minipli@grsecurity.net>
 <ZmDnQkNL5NYUmyMN@google.com>
 <0ef7c46b-669b-4f46-9bb8-b7904d4babea@grsecurity.net>
 <ZmHN3SUsnTXI_71J@google.com>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <ZmHN3SUsnTXI_71J@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 06.06.24 16:55, Sean Christopherson wrote:
> On Thu, Jun 06, 2024, Mathias Krause wrote:
>> On 06.06.24 00:31, Sean Christopherson wrote:
>>> On Thu, Jun 06, 2024, Mathias Krause wrote:
>>>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>>>> index 14841acb8b95..9f18fc42f018 100644
>>>> --- a/virt/kvm/kvm_main.c
>>>> +++ b/virt/kvm/kvm_main.c
>>>> @@ -4200,7 +4200,7 @@ static void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
>>>>  /*
>>>>   * Creates some virtual cpus.  Good luck creating more than one.
>>>>   */
>>>> -static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>>>> +static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
>>>
>>> Hmm, I don't love that KVM subtly relies on the KVM_MAX_VCPU_IDS check to guard
>>> against truncation when passing @id to kvm_arch_vcpu_precreate(), kvm_vcpu_init(),
>>> etc.  I doubt that it will ever be problematic, but it _looks_ like a bug.
>>
>> It's not subtle but very explicit. KVM_MAX_VCPU_IDS is a small positive
>> number, depending on some arch specific #define, but with x86 allowing
>> for the largest value of 4 * 4096. That value, for sure, cannot exceed
>> U32_MAX, so an explicit truncation isn't needed as the upper bits will
>> already be zero if the limit check passes.
>>
>> While subtile integer truncation is the bug that my patch is actually
>> fixing, it is for the *userland* facing part of it, as in clarifying the
>> ABI to work on "machine-sized words", i.e. a ulong, and doing the limit
>> checks on these.
>>
>> *In-kernel* APIs truncate / sign extend / mix signed/unsigned values all
>> the time. The kernel is full of these. Trying to "fix" them all is an
>> uphill battle not worth fighting, imho.
> 
> Oh, I'm not worry about something going wrong with the actual truncation.

Well, I do ;)

> 
> What I don't like is the primary in-kernal API, kvm_vm_ioctl_create_vcpu(), taking
> an unsigned long, but everything underneath converting that to an unsigned int,
> without much of anything to give the reader a clue that the truncation is
> deliberate.

Well, again, it's clear to me, at least. kvm_vm_ioctl_create_vcpu() is
the barrier from converting a userland provided "raw" value and checking
it to be within bounds that are sensible for in-kernel use. After that
check it's fine to use a more narrow type that still fits these bounds
and use that for in-kernel use.

The first part is _completely_ handled by the 'id >= KVM_MAX_VCPU_IDS'
test, as 'id' is still the "raw" value userland provided. Testing it
against KVM_MAX_VCPU_IDS does the "sensible for in-kernel use" check
and, on passing that check, allows to limit the storage type for 'id' to
the bounds of [0,KVM_MAX_VCPU_IDS) which fits within u32, unsigned int
or, as actually used for the vcpu_id member, an int.¹

> 
> Similarly, without the context of the changelog, it's not at all obvious why
> kvm_vm_ioctl_create_vcpu() takes an unsigned long.

Well, it's the ioctl() entry path. Passing on the UABI value shouldn't
be all that surprising. But I agree, a comment explaining the type- and
value handling to avoid early truncation thereof may not be such a bad idea.

> 
> E.g. x86 has another potentially more restrictive check on @id, and it looks
> quite odd to check @id against KVM_MAX_VCPU_IDS as an "unsigned long" in flow
> flow, but as an "unsigned int" in another.

Again, that's two distinct things, even if looking similar. The first
check against KVM_MAX_VCPU_IDS does actually two things:

1/ Ensure the full user ABI provided value (ulong) is sane and
2/ ensure it's within the hard limits KVM expects (fits unsigned int).

Now we do both with only a single compare and maybe that's what's so
hard to grasp -- that a single check can do both things. But why not
make use of simple things when we can do so?

Regarding x86's kvm_arch_vcpu_precreate(), it can use an 'unsigned int'
because the KVM_MAX_VCPU_IDS check ensured that the value of 'id' cannot
exceed that (limited) type. It's after the "UABI raw value" to "fits
kernel-internal type" conversion has happened, so using the narrower
type is just fine.

> 
> int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
> {
> 	if (kvm_check_tsc_unstable() && kvm->created_vcpus)
> 		pr_warn_once("SMP vm created on host with unstable TSC; "
> 			     "guest TSC will not be reliable\n");
> 
> 	if (!kvm->arch.max_vcpu_ids)
> 		kvm->arch.max_vcpu_ids = KVM_MAX_VCPU_IDS;
> 
> 	if (id >= kvm->arch.max_vcpu_ids)
> 		return -EINVAL;
> 

Above is completely fine, as this code only executes after the narrower
type bounds check.

>> I'd rather suggest to add a build time assert instead, as the existing
>> runtime check is sufficient (with my u32->ulong change). Something like
>> this:
>>
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -4200,12 +4200,13 @@ static void kvm_create_vcpu_debugfs(struct
>> kvm_vcpu *vcpu)
>>  /*
>>   * Creates some virtual cpus.  Good luck creating more than one.
>>   */
>> -static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>> +static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
>>  {
>>         int r;
>>         struct kvm_vcpu *vcpu;
>>         struct page *page;
>>
>> +       BUILD_BUG_ON(KVM_MAX_VCPU_IDS > INT_MAX);
> 
> This should be UINT_MAX, no?

No, I chose INT_MAX very intentional, as the underlying type of
'vcpu_id' is actually an int. Trying to store a value that's greater
than INT_MAX (but smaller than UINT_MAX) will make it negative and
that's definitely something we need to prevent as otherwise array
indexed accesses like in the IOAPIC code would try to access memory
before the allocated storage. Not good!

>                               Regardless, the "need" for an explicit BUILD_BUG_ON()
> is another reason I dislike relying on the KVM_MAX_VCPU_IDS check to detect
> truncation.

There's no "need" for the BUILD_BUG_ON(). It's just a cheap (compile
time only, no runtime "overhead") assert that the code won't allow
truncated values which may lead to follow-up bugs because of unintended
truncation. And, after all, you suggested something like that (a
truncation check) yourself. I just tried to provide it as something that
doesn't need the odd '__id' argument and an explicit truncation check
which would do the wrong thing if we would like to push KVM_MAX_VCPU_IDS
above UINT_MAX (failing only at runtime, not at compile time).

>              If @id is checked as a 32-bit value, and we somehow screw up and
> define KVM_MAX_VCPU_IDS to be a 64-bit value, clang will rightly complain that
> the check is useless, e.g. given "#define KVM_MAX_VCPU_ID_TEST	BIT(32)"
> 
> arch/x86/kvm/x86.c:12171:9: error: result of comparison of constant 4294967296 with
> expression of type 'unsigned int' is always false [-Werror,-Wtautological-constant-out-of-range-compare]
>         if (id > KVM_MAX_VCPU_ID_TEST)
>             ~~ ^ ~~~~~~~~~~~~~~~~~~~~
> 1 error generated.
  ^^^^^^^^^^^^^^^^^^
Perfect! So this breaks the build. How much better can we prevent this
bug from going unnoticed?

Same for the BUILD_BUG_ON(). I don't see how it is somehow hiding things
or making future changes silently fail. They won't. Neither will the x86
specific code compile, nor will the BUILD_BUG_ON() in
kvm_vm_ioctl_create_vcpu(). So what you're trying to say?...

> 
> 
>>         if (id >= KVM_MAX_VCPU_IDS)
>>                 return -EINVAL;
> 
> What if we do an explicit check before calling kvm_vm_ioctl_create_vcpu()?  That
> would avoid the weird __id param, and provide a convenient location to document
> exactly why KVM checks for truncation.

My version has no "weird __id param" ;) And, honestly, the current u32
argument type makes no sense either. It's neither the final type used
for 'vcpu_id' nor does it have to be explicitly 32 bits. So, IMHO, the
argument type should be fixed in any case and using the type that
preserves the UABI value just seems like a natural fit.

kvm_vm_ioctl() is "only" the command multiplexer, deferring concrete
implementation to the individual functions. It currently does no input
value sanity checks itself, beside some user copy error checks. So why
should KVM_CREATE_VCPU be special and have its truncation check be
outside of the handler function? It just scatters the code and hurts
readability, IMHO.

> 
> We could also move the "if (id >= KVM_MAX_VCPU_IDS)" check to kvm_vm_ioctl(),
> but I don't love that, because again IMO it makes the code less readable overall,
> loses clang's tuautological constant check, and the cost of the extra check against
> UINT_MAX is completely negligible.  
> 
> Though if I had to choose, I'd prefer moving the check to kvm_vm_ioctl() over
> taking an "unsigned long" in kvm_vm_ioctl_create_vcpu().

Looks like we disagree again. I'd always choose the ulong argument over
scattering the checks over multiple functions and possibly missing it if
a new call site appears.

> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 4965196cad58..8155146b16cd 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -5083,6 +5083,13 @@ static long kvm_vm_ioctl(struct file *filp,
>                 return -EIO;
>         switch (ioctl) {
>         case KVM_CREATE_VCPU:
> +               /*
> +                * KVM tracks vCPU ID as a 32-bit value, be kind to userspace
> +                * and reject too-large values instead of silently truncating.
> +                */
> +               if (arg > UINT_MAX)
> +                       return -EINVAL;

Unfortunately, that check is a tautology for 32 bit systems and wrong
for reasons I explained in the beginning of my Email. But we can move
the comment to kvm_vm_ioctl_create_vcpu() and explain the rational over
there (with taking an 'unsigned long id' argument):

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 14841acb8b95..b04e87f6568f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4200,12 +4200,20 @@ static void kvm_create_vcpu_debugfs(struct
kvm_vcpu *vcpu)
 /*
  * Creates some virtual cpus.  Good luck creating more than one.
  */
-static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
+static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 {
    int r;
    struct kvm_vcpu *vcpu;
    struct page *page;

+   /*
+    * KVM tracks vCPU IDs as 'int', be kind to userspace and reject
+    * too-large values instead of silently truncating.
+    *
+    * Also ensure we're not breaking this assumption by accidentally
+    * pushing KVM_MAX_VCPU_IDS above INT_MAX.
+    */
+   BUILD_BUG_ON(KVM_MAX_VCPU_IDS > INT_MAX);
    if (id >= KVM_MAX_VCPU_IDS)
        return -EINVAL;

> +
>                 r = kvm_vm_ioctl_create_vcpu(kvm, arg);
>                 break;
>         case KVM_ENABLE_CAP: {

Cheers,
Mathias

¹ IMHO, using 'int' for vcpu_id is actually *very* *wrong*, as it's used
as an index in certain constructs and having a signed type doesn't feel
right at all. But that's just a side matter, as, according to the checks
on the ioctl() path, the actual value of vcpu_id can never be negative.
So lets not distract.

