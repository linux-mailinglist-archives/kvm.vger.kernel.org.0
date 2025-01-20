Return-Path: <kvm+bounces-36021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E5B7A16EC2
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 15:49:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 963F61880994
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 14:49:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 997521E411C;
	Mon, 20 Jan 2025 14:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QdR7moei"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA0B1E3DD3
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 14:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737384553; cv=none; b=riweaqTGNF6HvZzPjIEecjUj6zjXuwSyrp5YdFLMgoKtRhIWez8yqKX3bd5tdGO9F3CxYJEzINOgIh+ufgu4fU+jTFj+okSuXu/Rib6OjfY/xyW3T9st17IaZO8jstlw3aKT2yL5EaawqIBIXrtWnm/VFtA/nKT+0hM0hgHkdtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737384553; c=relaxed/simple;
	bh=97VgZ9NoSF4UZ5T0NiQTXmNeNQczFmf/vzKxnh+EYp8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ELPVT7vk9b736wcLcgBVpg8CX7n71ujez67iuXGugRhadFjRI/gGWKLF40KgDjA0ozRPmuqZ9aOzyeBZhTjJGJiJoLLTz5dbcc804n+1FK815mxadWIu8K70dCvlHfmac2AUa/4+xpHVykEbzKix3cLKCCVsmayfnZ+bkATaji4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QdR7moei; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737384551;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4P+fb643O89fnX7RFAR9mtJaP74zPr0dFsGYSLFpk5M=;
	b=QdR7moeizVqm5hLhAeo8wH8gHuyB7aY5vSykvRoxX7OQo6gZdD2bK5pBchdE8bQeJFrJ+m
	ubNqXWm9g7oAcn3iiOPqdXCYWCVGrbeLru7Z4oS4vCK5tvssBb/RT/cz1m7PphzT9jxIr6
	htwy8SSLflJc3gfY36BsI8Ci4E171zM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-504-9hn7uwd9P7yEePQuxpXO8g-1; Mon, 20 Jan 2025 09:49:09 -0500
X-MC-Unique: 9hn7uwd9P7yEePQuxpXO8g-1
X-Mimecast-MFC-AGG-ID: 9hn7uwd9P7yEePQuxpXO8g
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3860bc1d4f1so2943294f8f.2
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 06:49:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737384548; x=1737989348;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4P+fb643O89fnX7RFAR9mtJaP74zPr0dFsGYSLFpk5M=;
        b=nikWBrYj/hK+FJlvkrcTmQRVo/Dc03vr8F/uqY8QglPkrQh1703wi7dXWc46z0ObNR
         vHvs978Hh+vdYmTUSxCz4ATYONEyYv/bEQEhY7x7hwiDLzl+MyKKmjyWda0U6i2l2Xhv
         Pz5Kjf8EP/U4+PIMKpGoNrptLEbhrhUmNdjmlDGR/OZDwtvKqgXgRsJ05luHvwJOuczs
         izQE4Vf3DYwQ4QuvqidiTk9X2Dibh+OFNYoYb7O16y/9exmAgqjdQJXPGfylY0jtPLuC
         valSLmec+NfbZjPX/y1y3iLwkfXuQ7XpL02cfO5LRr3MAXpU0iJHDADDpGtbrqaBr7ql
         F7+w==
X-Gm-Message-State: AOJu0Yx6XUH9W8MP+HENoFDLHYIKMuCGVrTbZgCwE20ZuxjbWa4VZFtq
	uL79Hj3XHsg0dTpkWOIynJxoVqD0Yr33UNGmmao9+D25ll3AO45czu4eTjkKEGWhMhWNUSN2bhy
	rCW2e3RUzSL7rl0B86caHqmD+dEksvcMyrDorujC/F3l9isELqw==
X-Gm-Gg: ASbGncsWQ13xgoJiIx0eZ6a7MbU8wMal5SbNI94wgT6LcLdiGWLyS9VUhasnfCA2R4s
	BhVftyKjVoaXZbHO609JjMc+HpCMFWLB9z3gEOsjUKtjvq20upcrrkA4eBIcP7lwIlF8Dg9fK4C
	PPhcgDoukS9QR6ZKmgC8K1i+S449R5n9rgh0JXWIyBWRh5xekqUjkK5ZR1nIYHdfhqR/1SzJOzq
	TBQT5S6sYABsolEpd5ULJXVsLYf3BmH38AhKOjYQBQn1zusT+nYrnC4P4uvESFM
X-Received: by 2002:a5d:4845:0:b0:386:857:cc54 with SMTP id ffacd0b85a97d-38bf5679b17mr9506995f8f.9.1737384548579;
        Mon, 20 Jan 2025 06:49:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF7Xb6EfEx+VXZHCbB8PiN72WuCFAku8/mV3FWjy0SkkiH+AeBrYjkPr7K7Eqr7QXG6qPKkhg==
X-Received: by 2002:a5d:4845:0:b0:386:857:cc54 with SMTP id ffacd0b85a97d-38bf5679b17mr9506969f8f.9.1737384548154;
        Mon, 20 Jan 2025 06:49:08 -0800 (PST)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf327e213sm10562551f8f.81.2025.01.20.06.49.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2025 06:49:07 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Sean Christopherson
 <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, David Woodhouse
 <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com, Paul Durrant
 <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>
Subject: Re: [PATCH 09/10] KVM: x86: Setup Hyper-V TSC page before Xen PV
 clocks (during clock update)
In-Reply-To: <20250118005552.2626804-10-seanjc@google.com>
References: <20250118005552.2626804-1-seanjc@google.com>
 <20250118005552.2626804-10-seanjc@google.com>
Date: Mon, 20 Jan 2025 15:49:06 +0100
Message-ID: <8734hd8rrx.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sean Christopherson <seanjc@google.com> writes:

> When updating paravirtual clocks, setup the Hyper-V TSC page before
> Xen PV clocks.  This will allow dropping xen_pvclock_tsc_unstable in favor
> of simply clearing PVCLOCK_TSC_STABLE_BIT in the reference flags.
>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9eabd70891dd..c68e7f7ba69d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3280,6 +3280,8 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>  		hv_clock.flags &= ~PVCLOCK_GUEST_STOPPED;
>  	}
>  
> +	kvm_hv_setup_tsc_page(v->kvm, &hv_clock);
> +
>  #ifdef CONFIG_KVM_XEN
>  	if (vcpu->xen.vcpu_info_cache.active)
>  		kvm_setup_guest_pvclock(&hv_clock, v, &vcpu->xen.vcpu_info_cache,
> @@ -3289,7 +3291,6 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>  		kvm_setup_guest_pvclock(&hv_clock, v, &vcpu->xen.vcpu_time_info_cache, 0,
>  					xen_pvclock_tsc_unstable);
>  #endif
> -	kvm_hv_setup_tsc_page(v->kvm, &hv_clock);
>  	return 0;
>  }

"No functional change detected".

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

(What I'm wondering is if (from mostly theoretical PoV) it's OK to pass
*some* of the PV clocks as stable and some as unstable to the same
guest, i.e. if it would make sense to disable Hyper-V TSC page when
KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE too. I don't know if anyone
combines Xen and Hyper-V emulation capabilities for the same guest on
KVM though.)

-- 
Vitaly


