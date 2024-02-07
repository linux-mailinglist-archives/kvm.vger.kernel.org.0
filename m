Return-Path: <kvm+bounces-8195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E5EAF84C362
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 05:10:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2512A1C215EA
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 04:10:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6F6C11733;
	Wed,  7 Feb 2024 04:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SF8Qnkhd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C828D14AAD
	for <kvm@vger.kernel.org>; Wed,  7 Feb 2024 04:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707279015; cv=none; b=IzLUSlFzZWqLn0J8WcyC4UXk5x2p0nNUvR9/uUrTSV/kaUR+T+VBlUYlW3Jn9yQjLgBYNo9x3rYY/ncrqx1p6aMLC0dQBR2xTOBPiozHVj1Wgsdh9hRr7rJ1JOvBWeM24lYs/hvkjbAxkXJzXXrV0n406gq+Xp+Qva91f7GGliY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707279015; c=relaxed/simple;
	bh=GoYtXApYyZBo4VKeqb1AsTKENYpsyaUCglDP8GuS7kQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gpW8s+sfljyEphQZU6EZ7LUkjy6VicbP0Fx7xY3rwmVPAA6i4Jq8EccxIdKdbMXXzQjxR4BfGZ+jYi3hRMM/JTrJw1Ys9eH5CqUgNylsLc8H9qrmK0lZXFdNz+PcldrD/fmYk7wUpXanmRLgJLeSZhYEJdKRHsxBOY7BDucorek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SF8Qnkhd; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2962056d9e7so188760a91.0
        for <kvm@vger.kernel.org>; Tue, 06 Feb 2024 20:10:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707279012; x=1707883812; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ykLN7fs6qQRnuF8WSISkwVcQAWTyJrlW1o+moHfC85k=;
        b=SF8QnkhdmzPTdOrFesWrthVZBtR5tJkCM6a1G1aS4RwUlGEQ4b20Pyai4LwpRFZEDO
         gbEOvuVlz/MRpZJJnFJ8Y14uy8DBy1xXBNcixgUNsPHwR0c8U9QgwuzYRARv3SdKJkEJ
         G4ogiri+ow+sdLNpjI+GZf0jqlAMbKT4Xdd+P3FDWi4ftO6FTEagEdvcP1TVkBHDKoyj
         eTRBV2/y/ysc1M+lxWYKioQ3UiKFv8T8LYhfqG/EECEi77PtBhPBago1/6LkW65MaCEB
         YpHz8/1KXdv5sAI1vG91MYiVxcqC1cvEvNFtGSYRI90M8h+cSwh28uhh3ZCDvKQMfyLL
         Ru9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707279012; x=1707883812;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ykLN7fs6qQRnuF8WSISkwVcQAWTyJrlW1o+moHfC85k=;
        b=ZZKDb8tbUjU+9Hf+8r0ksAp8N+mcxg45qy4uVylX9HvTYDVSjSPQ5B6P/vWL1mZaFZ
         BySjNch1taohKV5j+yuxE8A8ORR9yL+mn+DxWptXMjvyDgvUnEpFJo0eVYVAgQDXvZEb
         37u9BCnx8zWnRJdtjGyDNb3eOsB1wcKCE/21uHP93kYcTFMHfksnSTVe2ExINFR3h8R9
         oKjPWNmI7AzsYt9tQyyo6eA3UBZXcpxQfXZGYrx9eWfRloZmFCxai3ZdPvyR9Q0BxKJ4
         Ef4IEgN8J7W2C73Lfa4E6TaAdjvd/5sy2QV4GOz4I+JvPTfAzgHx4PWk/FhhUyAvWS7J
         8/Pg==
X-Gm-Message-State: AOJu0Yyd6WJI0cX49jBxD8j9coPRrRAaZ5A2vDjCJYUsQSJfbmbI4XfX
	6mxOfjlguzE/uu54NGGeXQx2TufFsYTrylzl0xrrJmyDYUEA7oNOlaUaqy9U867kuWUVLwbuOY3
	a3A==
X-Google-Smtp-Source: AGHT+IH+x2hZr5hgrqRm9mwlhGTe1zHc/Sl0rpDh0FcM4XBSnVg/GkvyIkz7aXggcw04KlEwBYkQvLZXGzU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:50c8:b0:296:58cc:601f with SMTP id
 sb8-20020a17090b50c800b0029658cc601fmr51199pjb.9.1707279012122; Tue, 06 Feb
 2024 20:10:12 -0800 (PST)
Date: Tue, 6 Feb 2024 20:10:10 -0800
In-Reply-To: <20240115125707.1183-12-paul@xen.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240115125707.1183-1-paul@xen.org> <20240115125707.1183-12-paul@xen.org>
Message-ID: <ZcMCogbbVKuTIXWJ@google.com>
Subject: Re: [PATCH v12 11/20] KVM: xen: allow shared_info to be mapped by
 fixed HVA
From: Sean Christopherson <seanjc@google.com>
To: Paul Durrant <paul@xen.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, David Woodhouse <dwmw2@infradead.org>, Shuah Khan <shuah@kernel.org>, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 15, 2024, Paul Durrant wrote:
> @@ -638,20 +637,32 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
>  		}
>  		break;
>  
> -	case KVM_XEN_ATTR_TYPE_SHARED_INFO: {
> +	case KVM_XEN_ATTR_TYPE_SHARED_INFO:
> +	case KVM_XEN_ATTR_TYPE_SHARED_INFO_HVA: {
>  		int idx;
>  
>  		mutex_lock(&kvm->arch.xen.xen_lock);
>  
>  		idx = srcu_read_lock(&kvm->srcu);
>  
> -		if (data->u.shared_info.gfn == KVM_XEN_INVALID_GFN) {
> -			kvm_gpc_deactivate(&kvm->arch.xen.shinfo_cache);
> -			r = 0;
> +		if (data->type == KVM_XEN_ATTR_TYPE_SHARED_INFO) {
> +			if (data->u.shared_info.gfn == KVM_XEN_INVALID_GFN) {
> +				kvm_gpc_deactivate(&kvm->arch.xen.shinfo_cache);
> +				r = 0;
> +			} else {
> +				r = kvm_gpc_activate(&kvm->arch.xen.shinfo_cache,
> +						     gfn_to_gpa(data->u.shared_info.gfn),
> +						     PAGE_SIZE);
> +			}
>  		} else {
> -			r = kvm_gpc_activate(&kvm->arch.xen.shinfo_cache,
> -					     gfn_to_gpa(data->u.shared_info.gfn),
> -					     PAGE_SIZE);
> +			if (data->u.shared_info.hva == 0) {

I know I said I don't care about the KVM Xen ABI, but I still think using '0' as
"invalid" is ridiculous.

More importantly, this code needs to check that HVA is a userspace pointer.
Because __kvm_set_memory_region() performs the address checks, KVM assumes any
hva that it gets out of a memslot, i.e. from a gfn, is a safe userspace address.

kvm_is_error_hva() will catch most addresses, but I'm pretty sure there's still
a small window where userspace could use this to write kernel memory.

> +				kvm_gpc_deactivate(&kvm->arch.xen.shinfo_cache);
> +				r = 0;
> +			} else {
> +				r = kvm_gpc_activate_hva(&kvm->arch.xen.shinfo_cache,
> +							 data->u.shared_info.hva,
> +							 PAGE_SIZE);
> +			}

