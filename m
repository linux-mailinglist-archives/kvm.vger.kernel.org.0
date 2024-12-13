Return-Path: <kvm+bounces-33722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B65D9F0A22
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 11:54:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F40CC188CDFB
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 10:54:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DEC01C3C0F;
	Fri, 13 Dec 2024 10:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LsRap7bg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FA21C3BEE
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 10:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734087242; cv=none; b=jX7S78Z36EHY/V81F2ryiKsWKO3XsKEUwLJ/CtLXhkiC7sHijbUeV+rXWAJGtPzc/MDBepnSNQNMR/Ov9kh3K39Tej1B33oBO7+aWBgfDvS2Qi5QMVYImfmx0wQKOBf7nfrZekldwO3Ztg33QmlG7d6knxmcRTpRo8/9bxC3HYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734087242; c=relaxed/simple;
	bh=okqpacIbcOlbR8x92errleYPqAKmSIoPXXz7pzDyyqI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=aDuUJXPyy3ko6TlbDqGZndaaI3obh06s3nMIs4QYEXLNXRI7McuWe0poJqSO+EYIe8Pl4JcHeNso1W1VSQG0E/cj9+vpACpY/VDMHaQNOUPhMZijbbzzUmr1HW9QhEywo4/hm7WSY040vngSoofL2fqad/l4vysd71b+5uN0cv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LsRap7bg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734087238;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tZP36RlbgyjCPid9qIB9xpaONyqLFu9PuB4d/BcSVyY=;
	b=LsRap7bgoSHcgHTV4oLkKdWtl2Ym8iIwWt5OOyJOBnobwgAMey7ZYnyy4am7/9W6nI1ucV
	55wsvAENP7WLm7W/IXpeedhuu6RsTWjZ0vLpFo71ZVrZ9WYCBkUaCdN+cJcRsLSJZxfpiT
	RwQBpK3pp0hK3TJ/fxV+/bvXYim3ajI=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-8-YaCI1KXrOnSgjFzCdZJLAA-1; Fri, 13 Dec 2024 05:53:57 -0500
X-MC-Unique: YaCI1KXrOnSgjFzCdZJLAA-1
X-Mimecast-MFC-AGG-ID: YaCI1KXrOnSgjFzCdZJLAA
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-aa691c09772so35397466b.1
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 02:53:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734087236; x=1734692036;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tZP36RlbgyjCPid9qIB9xpaONyqLFu9PuB4d/BcSVyY=;
        b=hSETeNd21gcHrYyZDU/0ZAqhsc7rmHPPAa+fEISPHVELrXV5IzkJSTQCOw8JME8kMU
         fvcJWO92Jht/oUaGyAa3U5C3JGIZI3rQgUjJ+SKDUr1KOi9Q7ls40yVT6XB8pSyqg5C7
         spF4OmeZGI7X/TcAcm9yd2ICB6E9FvduzeVlzWKPnC1+GU/z63+Xwa/1AckcOjrcEDVf
         X3NWD3Ro3u/RRSU9Twsrncf8wEGCfG8DXkpmfTUWNQG9/wmnVXYVxkRd7tgmnj2/fclG
         60BffaR7lFGJwVMdNzM7UW2KAmp1jU97fL0ZNI5uMAWmZqnG19nOeBKNSjEQD2WWHBhy
         bMNQ==
X-Gm-Message-State: AOJu0Yw5Hx51kvPu7fYUdWhGYS2qDoKy74h8NQSfTm3iOlMm7cIL1OJo
	5uWyVc24KD23r1uUBpLLktSvmnWNTp3prY6/Fo5Pl8awk+4EKo1YcvtRPL0RjkHdL/CcHNhK0sS
	PidAeRdBd84dClL07wGAgGH22qwI6FcffKm1Fu9heA5cLT9r+Pg==
X-Gm-Gg: ASbGnct/ZlWtZm5CIyyqBrFjsrOPtTHXZiQ0rIbl9K+B/OnXUnpPvLpQ2ay9U9jJJ7B
	gI+Ms1lz+AzGT/dha7wH+Tt60bi4LPIXEB2S524SzfuKGT7sW4Znll3vPvrnd8gAESXLx9aaO8I
	ux5dMvne5Tq+qnh2EOLbLlz7+pDtDE/tiXybWgDelRklwfULUKsTHdPs2+5zjIa/kpaP5HnR6oW
	YCO2o4imr6B+l+mZuCieFTCQ0VneT3IsdrgNeGztHFuOgDTG8s=
X-Received: by 2002:a17:907:7853:b0:aa6:762e:8c20 with SMTP id a640c23a62f3a-aab77e96883mr225245566b.43.1734087236008;
        Fri, 13 Dec 2024 02:53:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHpmtuh+bOXDCMGt5rVmLOBisZQNKYOnKYDf15tmo1bduSNwY/0Lm8b87Kpa+9sghGVqcOKLg==
X-Received: by 2002:a17:907:7853:b0:aa6:762e:8c20 with SMTP id a640c23a62f3a-aab77e96883mr225242366b.43.1734087235662;
        Fri, 13 Dec 2024 02:53:55 -0800 (PST)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa69f639f59sm513076066b.193.2024.12.13.02.53.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2024 02:53:55 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, Jarkko
 Sakkinen <jarkko@kernel.org>
Cc: kvm@vger.kernel.org, linux-sgx@vger.kernel.org,
 linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, Hou
 Wenlong <houwenlong.hwl@antgroup.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>,
 Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang
 <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Subject: Re: [PATCH v3 01/57] KVM: x86: Use feature_bit() to clear
 CONSTANT_TSC when emulating CPUID
In-Reply-To: <20241128013424.4096668-2-seanjc@google.com>
References: <20241128013424.4096668-1-seanjc@google.com>
 <20241128013424.4096668-2-seanjc@google.com>
Date: Fri, 13 Dec 2024 11:53:54 +0100
Message-ID: <87ed2bsvjx.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sean Christopherson <seanjc@google.com> writes:

> When clearing CONSTANT_TSC during CPUID emulation due to a Hyper-V quirk,
> use feature_bit() instead of SF() to ensure the bit is actually cleared.
> SF() evaluates to zero if the _host_ doesn't support the feature.  I.e.
> KVM could keep the bit set if userspace advertised CONSTANT_TSC despite
> it not being supported in hardware.

FWIW, I would strongly discourage such setups, all sorts of weird hangs
will likely be observed with Windows guests if TSC rate actually
changes.

>
> Note, translating from a scattered feature to a the hardware version is
> done by __feature_translate(), not SF().  The sole purpose of SF() is to
> check kernel support for the scattered feature, *before* translation.
>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 097bdc022d0f..776f24408fa3 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1630,7 +1630,7 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
>  				*ebx &= ~(F(RTM) | F(HLE));
>  		} else if (function == 0x80000007) {
>  			if (kvm_hv_invtsc_suppressed(vcpu))
> -				*edx &= ~SF(CONSTANT_TSC);
> +				*edx &= ~feature_bit(CONSTANT_TSC);
>  		}
>  	} else {
>  		*eax = *ebx = *ecx = *edx = 0;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly


