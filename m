Return-Path: <kvm+bounces-35842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A470A155D5
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 18:37:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C34CD188D930
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 17:37:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B0FD1A2541;
	Fri, 17 Jan 2025 17:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zCUofYgL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59932A95C
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 17:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737135408; cv=none; b=Eczf/thBVZOx8w5BZnszpMhhYAAN3PzYKqGNmsuFaFrAoykpQE52G6fli+aoYpMvpfEe0azvTERu2oGJ38j0gYWbZoSJJlek6rWwsq4ekIhRvalx5C4mONHVayj/E1101JbjC6ai5XOpvRZGA2ZfbseYgr8mvk5eigUj8hmNaws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737135408; c=relaxed/simple;
	bh=QBwKeN2Bq2CNE0zF7FaHpH3rztx/oNPKspqXSw64uEU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pd2zGG6XsxCb7/1WIl5p7myBrZeFxIam53phOmYpVUmb6LMrEr1PjQBm58PhDzDCKVWFL7tOPtwZl7pyLcWFzFjg0GtxVUbCu3ucImZ1H5jmxiw/LSoocz+a+yqDZZ0XzTN8B+DxJDFwcHnpALUmYOfpHMqJVlSwFOQYtAltlTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zCUofYgL; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f129f7717fso4652427a91.0
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 09:36:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737135406; x=1737740206; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YRfr6c2OOb+CwNJOPVVNgs0oQDVr3N04a+EaawYlXZ8=;
        b=zCUofYgLlWx7twfe/gYeRmUPyilXdL4C6mimgB6YuRWvpYvzF2Rjd+jgI6IRAeol0A
         4ZoW7bxOZPk904cWY6UktDl4G/nGH64y7X/2MsPtagibKM9JjqyZFHPy6A+bbacK++cC
         wYPle6rjtITzkHSV2/tyEoQpM3SgVU8gBT/fRWFZYTArgFZt2iVD0cE5KEhVfzDGy76m
         OMdofUrkzmMWuJQoGT1bXDWLzI513ApzNN5QRnETn6Sft19gaTniEYWhRqHU9BPia+/V
         /+lKde6huftZIAWdx2aulfmFYmgC1IxyL+TJNtoIks37S2pxmLaHqU3x3wpvHGHPGhrj
         zyVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737135406; x=1737740206;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YRfr6c2OOb+CwNJOPVVNgs0oQDVr3N04a+EaawYlXZ8=;
        b=d+2BUVBbl+SiLYFY2n9yqvj/56HXF3BSMMjgXnkW+vzCVK/a80RokYJAx23deHpAne
         dKbjM5KRJ1pASfhTflNT73EDCGO9AvyEXzWxSKqCJGfMiWrA4ybZ0efg7OUTDtOKWsbS
         zkZxmYcbGu+TrIo6bQQM/B5cC0zVcJAdX99VFgBr4nEuC2mwCc6uTH3U3JH/nq3lmOL+
         4TVuEU6pqef18RUJfpB66frxN771xqZdildjE6EL6m8DV5kPxaqAVMOdlon9OcLF1Qqu
         /d1i7FPmdm9x57e9HUrHucWLNjiWDOG5G0eSJ/fGbxvb41RJdkw+RFYpyAm4HD/s01RZ
         RFNA==
X-Forwarded-Encrypted: i=1; AJvYcCWLm83z7k9sctBdyB5L+bKOaxD8Hd/T8WUZtng89wsnrboBPFO88eDq5hs1uiuOWyKhWI8=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywhi0e/cruMT0AWLCrrIPUs/ZgV43lRuwuHJamB5qMPPeg3PzjV
	M+R2mGMPai6RfNt/uoITujmXPLWfzFV9KkVb5Qfg3/7vujGy4PBSwnnsZIJ3M5QHU+xsbWUZn8g
	RmA==
X-Google-Smtp-Source: AGHT+IGGs8LQpUxnevvozQKUPF97I/qKWdMA+oKhunNgVSModdZKEUVcGoAjf8+j8iPaYyIgj8mqnh9TmN8=
X-Received: from pjh8.prod.google.com ([2002:a17:90b:3f88:b0:2e5:5ffc:1c36])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4ed0:b0:2ee:c1d2:bc67
 with SMTP id 98e67ed59e1d1-2f782c99704mr5531429a91.16.1737135406699; Fri, 17
 Jan 2025 09:36:46 -0800 (PST)
Date: Fri, 17 Jan 2025 09:36:45 -0800
In-Reply-To: <87ikqd8krp.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250113222740.1481934-1-seanjc@google.com> <20250113222740.1481934-4-seanjc@google.com>
 <87ikqd8krp.fsf@redhat.com>
Message-ID: <Z4qVLU_hhwFHmic9@google.com>
Subject: Re: [PATCH 3/5] KVM: selftests: Explicitly free CPUID array at end of
 Hyper-V CPUID test
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dongjie Zou <zoudongjie@huawei.com>, stable@vger.kernel
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 17, 2025, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > Explicitly free the array of CPUID entries at the end of the Hyper-V CPUID
> > test, mainly in anticipation of moving management of the array into the
> > main test helper.
> >
> > Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
> > index 9a0fcc713350..09f9874d7705 100644
> > --- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
> > +++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
> > @@ -164,6 +164,7 @@ int main(int argc, char *argv[])
> >  
> >  	hv_cpuid_entries = kvm_get_supported_hv_cpuid();
> >  	test_hv_cpuid(hv_cpuid_entries, kvm_cpu_has(X86_FEATURE_VMX));
> > +	free((void *)hv_cpuid_entries);
> 
> vcpu_get_supported_hv_cpuid() allocates memory for the resulting array
> each time, however, kvm_get_supported_hv_cpuid() was designed after
> what's now kvm_get_supported_cpuid() (afair) so it has an optimization
> to ask KVM just once:
> 
>         static struct kvm_cpuid2 *cpuid;
>         int kvm_fd;
> 
>         if (cpuid)
>                 return cpuid;
> 
>         cpuid = allocate_kvm_cpuid2(MAX_NR_CPUID_ENTRIES);
>         kvm_fd = open_kvm_dev_path_or_exit();
> 	...
> 
> and it seems that if we free hv_cpuid_entries here, next time we call
> kvm_get_supported_hv_cpuid() an already freed memory will be returned.
> This doesn't matter in in this patch as we're about to quit anyway but
> with the next one in the series it becomes problematic.

Ow.  I totally missed that.  I'll drop this patch, and then adjust the next one
to do:

	/*
	 * Note, the CPUID array returned by the system-scoped helper is a one-
	 * time allocation, i.e. must not be freed.
	 */
	if (vcpu)
		free((void *)hv_cpuid_entries);


I'll post a v2 once I've actually tested.

Thanks!

