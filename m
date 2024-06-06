Return-Path: <kvm+bounces-18995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E25848FDF7A
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 09:21:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C2AB283450
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 07:21:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A082413BC30;
	Thu,  6 Jun 2024 07:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="HSS0B2KA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E348713C900
	for <kvm@vger.kernel.org>; Thu,  6 Jun 2024 07:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717658460; cv=none; b=dI+YT+EghB+94vzd6UsLwn+ojAHeGinqLrvhw+UpciXlW0nzSijfjbBLFCfbvMfRNIIoNglXBNUXpsVxRHM9AIlpyELJB96qkpkWb21zlSBWXt2HW802OY1+qRAD9KXcKlBBnNt8ixJF66IVs5N7A+RDK3wMvGZsFaQAg1OiSJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717658460; c=relaxed/simple;
	bh=mliXY5sIxBsMshC+ps+y8ArEmQKnT1810y+w/xufWe4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jjjxHVw/EVYu6hMHLk/Y7rzrLZkP/ZAlJgI0CE6+Hj/B156Cq61n7bmzdCxYr5xkYbbEc/VqT0xxfcdRmmCFW/GR0Qg8/Iqtotx24q/EMjkqrJoP1aipGwlaU9wSpByV3xp5bfUaO+hQ16eMZ3Cob9qIQPT/HB8uou4RSwrtB/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=HSS0B2KA; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a6c8537bfa0so18732566b.3
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2024 00:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1717658457; x=1718263257; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=0m+ab+gLKKaW9Mc4WMihPYHQB2Qad8u+hXpAjUNN8Gw=;
        b=HSS0B2KAvgNdVDh0X7YZvnf15ZcuGpsx8TJnE/bGTruYM951BISc+7BMpVjfVBCbba
         SG4BUdahvohHTEARBw+IVDJpEocHuItS9i2yN6n3fi2uH1mM6FAgXXkowRn+o8n2bHMg
         9pBJSf7fyTt+QFbsQPLli57qH/3+jxPyueoPPtdwZaQawp0EFKeSr4gMSKQAKubFGDZP
         n3Vf9ofYd6AN9NvKeZ7Als6agnvw7e4Je+5/9A7z8nCGgTZrylbA3UBp5RUHUfsJ1Mvu
         NQmPT3J8H7hTpg+V6kzoT38wkafIMuZQoxctv9oKDOjJ02oiQLl/bWF4dU5xpWOwMWXH
         5bSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717658457; x=1718263257;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0m+ab+gLKKaW9Mc4WMihPYHQB2Qad8u+hXpAjUNN8Gw=;
        b=sw8gDLrtSUv6sg3US4zcVk53iTOOFOB5MSkBqJ1v+u4azp2J3pWxez5Y4o7TW5WPsk
         bKQJFLrYDD1FHX5ftjL/z5Xcv4FSYi5Y+wQotbILFUZ4OIKBlRnF3UA/IC7mvxERDIuz
         Pg32gy7MvXJCy38C8+HyBaIQwlIstTHnsFLLVMWDeNkT+omV4Z8L0XNyCSRlxNvsTlia
         zRCtJK98TcE8KwRsn+secLJ2jS8kWGmtNcAIbHvJBk0VWBgHvGzlLZv4zUrRl4gcp0hG
         8aHnurXmgKDn09Ed8gJEv4Y8gknrYFK1xWHp1xdZG0baYIqQQQlsuq/0mO2jWyY2qCgc
         B8bA==
X-Forwarded-Encrypted: i=1; AJvYcCWlqjBKw+Qzw8tQBdTRrc1dCVfAICMCbSJA6nwBNBtbz+g7NjlaMY52/CqZ7ZYOS6CsjIODleH1uCsXlrfbN4UHa0IL
X-Gm-Message-State: AOJu0YzAouOctoMM9qEEuzH/VMYQ2tsvu7d7eceVMbbwCERy3PykONDD
	rb9uU/pwjUul+OtzgnhtF8WhCUhVKT3VFfbIHGb6eqwiLCYbyNmDgqOG9spJiPc=
X-Google-Smtp-Source: AGHT+IGPK/F3At6Fetg5ad1RbAV50hRoBuy7v0+srBAHf6k3VwugZy/3CvlGG4IkWqOcqoALwuGFgw==
X-Received: by 2002:a17:906:3146:b0:a6c:73fe:4aaa with SMTP id a640c23a62f3a-a6c73fe6444mr145393466b.7.1717658457033;
        Thu, 06 Jun 2024 00:20:57 -0700 (PDT)
Received: from ?IPV6:2003:f6:af22:bc00:4b8d:639a:480e:4db? (p200300f6af22bc004b8d639a480e04db.dip0.t-ipconnect.de. [2003:f6:af22:bc00:4b8d:639a:480e:4db])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57aae13faccsm598697a12.54.2024.06.06.00.20.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Jun 2024 00:20:56 -0700 (PDT)
Message-ID: <0ef7c46b-669b-4f46-9bb8-b7904d4babea@grsecurity.net>
Date: Thu, 6 Jun 2024 09:20:55 +0200
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
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <ZmDnQkNL5NYUmyMN@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 06.06.24 00:31, Sean Christopherson wrote:
> On Thu, Jun 06, 2024, Mathias Krause wrote:
>> If, on a 64 bit system, a vCPU ID is provided that has the upper 32 bits
>> set to a non-zero value, it may get accepted if the truncated to 32 bits
>> integer value is below KVM_MAX_VCPU_IDS and 'max_vcpus'. This feels very
>> wrong and triggered the reporting logic of PaX's SIZE_OVERFLOW plugin.
>>
>> Instead of silently truncating and accepting such values, pass the full
>> value to kvm_vm_ioctl_create_vcpu() and make the existing limit checks
>> return an error.
>>
>> Even if this is a userland ABI breaking change, no sane userland could
>> have ever relied on that behaviour.
>>
>> Reported-by: PaX's SIZE_OVERFLOW plugin running on grsecurity's syzkaller
>> Fixes: 6aa8b732ca01 ("[PATCH] kvm: userspace interface")
>> Cc: Emese Revfy <re.emese@gmail.com>
>> Cc: PaX Team <pageexec@freemail.hu>
>> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
>> ---
>>  virt/kvm/kvm_main.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 14841acb8b95..9f18fc42f018 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -4200,7 +4200,7 @@ static void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
>>  /*
>>   * Creates some virtual cpus.  Good luck creating more than one.
>>   */
>> -static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>> +static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
> 
> Hmm, I don't love that KVM subtly relies on the KVM_MAX_VCPU_IDS check to guard
> against truncation when passing @id to kvm_arch_vcpu_precreate(), kvm_vcpu_init(),
> etc.  I doubt that it will ever be problematic, but it _looks_ like a bug.

It's not subtle but very explicit. KVM_MAX_VCPU_IDS is a small positive
number, depending on some arch specific #define, but with x86 allowing
for the largest value of 4 * 4096. That value, for sure, cannot exceed
U32_MAX, so an explicit truncation isn't needed as the upper bits will
already be zero if the limit check passes.

While subtile integer truncation is the bug that my patch is actually
fixing, it is for the *userland* facing part of it, as in clarifying the
ABI to work on "machine-sized words", i.e. a ulong, and doing the limit
checks on these.

*In-kernel* APIs truncate / sign extend / mix signed/unsigned values all
the time. The kernel is full of these. Trying to "fix" them all is an
uphill battle not worth fighting, imho.

> 
> If we really care enough to fix this, my vote is for something like so:
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 4965196cad58..08adfdb2817e 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4200,13 +4200,14 @@ static void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
>  /*
>   * Creates some virtual cpus.  Good luck creating more than one.
>   */
> -static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
> +static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long __id)
>  {
>         int r;
>         struct kvm_vcpu *vcpu;
>         struct page *page;
> +       u32 id = __id;
>  
> -       if (id >= KVM_MAX_VCPU_IDS)
> +       if (id != __id || id >= KVM_MAX_VCPU_IDS)
>                 return -EINVAL;
>  
>         mutex_lock(&kvm->lock);

I'd rather suggest to add a build time assert instead, as the existing
runtime check is sufficient (with my u32->ulong change). Something like
this:

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4200,12 +4200,13 @@ static void kvm_create_vcpu_debugfs(struct
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

+       BUILD_BUG_ON(KVM_MAX_VCPU_IDS > INT_MAX);
        if (id >= KVM_MAX_VCPU_IDS)
                return -EINVAL;

Thanks,
Mathias

