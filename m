Return-Path: <kvm+bounces-63277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 566B0C5F971
	for <lists+kvm@lfdr.de>; Sat, 15 Nov 2025 00:34:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6B1DA4E7A6B
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 23:32:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E38B30C624;
	Fri, 14 Nov 2025 23:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C0X7QAkT";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="gHIavjnW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A9B30F53F
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 23:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763163136; cv=none; b=C3Ew8Yd71CKsspY7eSSrtU/LGZN7+oKPqP6WKjSH1U6tSRdh79Y98Hg9aWhuww4P1G3sjJid6GxwJw4xsDzVuX4Zl6S1UzsvkeISpkltKXM41LP8pNlu/5ybFTT0UcNObrhm44qsNMenooiKvyqr0iVHeXY0SeKyheqyHc0Nqu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763163136; c=relaxed/simple;
	bh=AbnGhiOXx7dGsbwYslsKjnRY8FJ95Mbk/ikoKAQApZU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G651kDqbr5zJrxcrUqAS0ThO/gWUn9+a1hXdKJY4wqH7UQf5JEQP8/R/RHoVU2dGm/FjFG2pB5R2qsoNIYGhuC5hR4kLnEnMSPfaDJ5h5Gsg2PLNkYMpBGRakLNNIw7CiA4TJTbwfOU/maFSFMkinmFqOMcmz3CcK11d4unHEz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C0X7QAkT; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=gHIavjnW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763163132;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/QYo7Ljqd9DNAGh5/P3lAIO/wCt6rj9fGqv6o3T6eUs=;
	b=C0X7QAkTMPUWS0h3mc+taP4dDkWu4cqz2APU6UG//7UmfIG+W6rkP3a2zTXvSue+eCzgVY
	l5HFvkSWPFK5pnrjXHUP1q4+n81O/TvL1bQ0X6l50WvAiBv9z/jjU4DWOmrGKrTs1KFV3f
	A3+Xl1qMe5A1A91coGLX4aAhzrneIW0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-274-mjDMpuhwNDWWDH__YA4HJQ-1; Fri, 14 Nov 2025 18:32:11 -0500
X-MC-Unique: mjDMpuhwNDWWDH__YA4HJQ-1
X-Mimecast-MFC-AGG-ID: mjDMpuhwNDWWDH__YA4HJQ_1763163130
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-429cd1d0d98so1649352f8f.3
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 15:32:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763163130; x=1763767930; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=/QYo7Ljqd9DNAGh5/P3lAIO/wCt6rj9fGqv6o3T6eUs=;
        b=gHIavjnWVJ62f4o/K2QzUptlA9Hh0wIUjAn1jYVVhEBd6TQ1AIaraco76J4nDr1vQT
         C5k1VcKKyJQLPeNEMsFYLGgQAbIMqpuiA1kAkuSQcHPxSC/ia+p5xBtUEuivZa8tmSvK
         jAIx4B5EpQVmsPh2irzvW0UxZGakwh52E9LFf8yoJVOnyPP/gayK98MtFoUBgztk3ap5
         a1Iw1wpib06GmNB+n7gYnEFmMzVQGNdeYzKBdrty+3CnPphGM3glFEQe6nHTossiW81h
         loYwV2iIKteEdyCCgjgOZJBJJy7vypE5JRTdFXiktnt+lda7ALqyk1Ufe6WF3U7o2y+e
         I8/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763163130; x=1763767930;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/QYo7Ljqd9DNAGh5/P3lAIO/wCt6rj9fGqv6o3T6eUs=;
        b=n5U70mxO9Xe1Ak8aOGFvY+x7mE1wIWxVkDxXYzPaPYbtPOp+nw+lxrcGq+P2GWIXrc
         ANfvFCMiVDWKWyiQoyaXUt/tLefkr+3gIkV3pHkWUkay6Qg0mBRkm5fHQAQYa5mW0sWd
         OdtvTuCxt66eIqpqpEzWM6ZJrvd5g5NZ5LhjKVdvNDmRAAm0BQzbmaEKmfflZ1D3Aji2
         OWd1xDX/EbU0uwfcSb+85EdkpAq31rbzoGGKwKu5sMyrC8uwTyZrhGnk3gNJtj7YRyTK
         RnZMTiRbqEfyCba56WI12ucID7wdwa1WhhPxikOwXwlrvP+gMeRWz/DbBlF50XYm2kaP
         IS8w==
X-Gm-Message-State: AOJu0YxKVEw5ykJ5Cv5KeGC7+hest8NKM0GuxdG2NTFHrM+FwxOOI7iN
	UJqxg3BQjKDFX01dQTaL9SwjTKg8FebQnthg4rUs7XSq+QG5PSOclCShldCvTfgSpS7ZbcNM14U
	r2zDs18WeBdtd0DpAQc6w/KCR4vCc5L7D4c81SMBSXQpT8xF9zC+IIQ==
X-Gm-Gg: ASbGncsdn7WWpe1KuVEacAlHxhoDRgp8biSMBwam/JI43qh8MI4ZGIpGZhs2OzyWU3g
	W4sifNUMn5QJU/ZyQoSDjrurteyy+JEy7ZL0uObf0Aeo1dK8XRneW2H4Zomq1V4T4dg9e7atLp5
	g9765NMmXgZHVwFrkc848BUrgMo4KD1il2QqUme0KRMsvjHa6qL2f9wFXzEIbFA9vXUd9J59aiA
	yGzS2wV549k9Ys2kgFNMdzCxVwt7+Oql/OrhMwvnqPBNoLO6gKJ4wb3xJk/2nuBPs6UwChHzM5a
	F1fmfIDd3Un1xXK8HXT1cw9t9LdIELpkl+a6DXK3assAmykp4rnOndb0w3PA5/963SahOVqRPb9
	qCQ/B0erC0cyL3DA6xI9QE2/jHF9DRC0nQ033e0N/yJJ0ZoyB85WkfNQuPxSB++0buoBsVqh1bW
	WqmKsm
X-Received: by 2002:a05:6000:40de:b0:429:8daa:c6b4 with SMTP id ffacd0b85a97d-42b593497d8mr4293945f8f.21.1763163129942;
        Fri, 14 Nov 2025 15:32:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHLD8BHdcVzHtD6TF4dLvyu5AHqRO8aq+/3QgGswkcNLf/IeBbf1T8H4P8a8bY7RmWd0txzCA==
X-Received: by 2002:a05:6000:40de:b0:429:8daa:c6b4 with SMTP id ffacd0b85a97d-42b593497d8mr4293924f8f.21.1763163129430;
        Fri, 14 Nov 2025 15:32:09 -0800 (PST)
Received: from [192.168.10.48] ([176.206.119.13])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-42b53f17291sm12635481f8f.32.2025.11.14.15.32.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Nov 2025 15:32:08 -0800 (PST)
Message-ID: <60f7c9b3-312f-41e2-ab47-c4361df1d825@redhat.com>
Date: Sat, 15 Nov 2025 00:32:04 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/9] KVM: SVM: Filter out 64-bit exit codes when invoking
 exit handlers on bare metal
To: Sean Christopherson <seanjc@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, "K. Y. Srinivasan"
 <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>,
 Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>
Cc: kvm@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
 Yosry Ahmed <yosry.ahmed@linux.dev>
References: <20251113225621.1688428-1-seanjc@google.com>
 <20251113225621.1688428-7-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20251113225621.1688428-7-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/13/25 23:56, Sean Christopherson wrote:
> Explicitly filter out 64-bit exit codes when invoking exit handlers, as
> svm_exit_handlers[] will never be sized with entries that use bits 63:32.
> 
> Processing the non-failing exit code as a 32-bit value will allow tracking
> exit_code as a single 64-bit value (which it is, architecturally).  This
> will also allow hardening KVM against Spectre-like attacks without needing
> to do silly things to avoid build failures on 32-bit kernels
> (array_index_nospec() rightly asserts that the index fits in an "unsigned
> long").
> 
> Omit the check when running as a VM, as KVM has historically failed to set
> bits 63:32 appropriately when synthesizing VM-Exits, i.e. KVM could get
> false positives when running as a VM on an older, broken KVM/kernel.  From
> a functional perspective, omitting the check is "fine", as any unwanted
> collision between e.g. VMEXIT_INVALID and a 32-bit exit code will be
> fatal to KVM-on-KVM regardless of what KVM-as-L1 does.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/svm.c | 18 ++++++++++++++++--
>   1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 202a4d8088a2..3b05476296d0 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3433,8 +3433,22 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
>   		sev_free_decrypted_vmsa(vcpu, save);
>   }
>   
> -int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 exit_code)
> +int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 __exit_code)
>   {
> +	u32 exit_code = __exit_code;
> +
> +	/*
> +	 * SVM uses negative values, i.e. 64-bit values, to indicate that VMRUN
> +	 * failed.  Report all such errors to userspace (note, VMEXIT_INVALID,
> +	 * a.k.a. SVM_EXIT_ERR, is special cased by svm_handle_exit()).  Skip
> +	 * the check when running as a VM, as KVM has historically left garbage
> +	 * in bits 63:32, i.e. running KVM-on-KVM would hit false positives if
> +	 * the underlying kernel is buggy.
> +	 */
> +	if (!cpu_feature_enabled(X86_FEATURE_HYPERVISOR) &&
> +	    (u64)exit_code != __exit_code)
> +		goto unexpected_vmexit;

I reviewed the series and it looks good, but with respect to this patch 
and patch 8, is it really worth it?  While there is a possibility that 
code 0x00000000ffffffff is used, or that any high 32-bit values other 
than all-zeros or all-ones are used, they'd be presumably enabled by 
some control bits in the VMCB or some paravirt thing in the hypervisor.

What really matters is that SEV-ES's kvm_get_cached_sw_exit_code() is 
reading the full 64 bits and discarding invalid codes before reaching 
svm_invoke_exit_handler().

I totally agree, of course, with passing __exit_code as u64 and adding a 
comment explaining what's going on with "u32 exit_code == (u32)__exit_code".

Paolo

>   #ifdef CONFIG_MITIGATION_RETPOLINE
>   	if (exit_code == SVM_EXIT_MSR)
>   		return msr_interception(vcpu);
> @@ -3461,7 +3475,7 @@ int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 exit_code)
>   
>   unexpected_vmexit:
>   	dump_vmcb(vcpu);
> -	kvm_prepare_unexpected_reason_exit(vcpu, exit_code);
> +	kvm_prepare_unexpected_reason_exit(vcpu, __exit_code);
>   	return 0;
>   }
>   


