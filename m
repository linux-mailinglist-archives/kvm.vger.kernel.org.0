Return-Path: <kvm+bounces-2062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 888D87F1254
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 12:42:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4455A282630
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 11:42:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D4ED18025;
	Mon, 20 Nov 2023 11:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e5n7PDxS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C8DCCA
	for <kvm@vger.kernel.org>; Mon, 20 Nov 2023 03:42:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700480548;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ywZqg0MRB/SOqibE44rsexi3e6ZvTzo2NLgsXDnSvV0=;
	b=e5n7PDxSoKt2cE6RJ190fA1pUbRMotQAoyfbGkGWde6kS0Q179zArird9JPjdj1vEgFdPy
	3idJ/h3V7NL1ZnH0HwJxkWANPpTSmesO3H+peDIHaNxexpZww4aRyysVEbo/U8lzO1hd+J
	lmfvdXnp25TLUq8AOOFAi9096bFS/bw=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-159-K6xfsTPJNjmhN0tUDkumZQ-1; Mon, 20 Nov 2023 06:42:27 -0500
X-MC-Unique: K6xfsTPJNjmhN0tUDkumZQ-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2c5032ab59eso39862021fa.3
        for <kvm@vger.kernel.org>; Mon, 20 Nov 2023 03:42:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700480545; x=1701085345;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ywZqg0MRB/SOqibE44rsexi3e6ZvTzo2NLgsXDnSvV0=;
        b=w4GL9L363nZf1MWm0kztAuQloo5mZU9sBcmfR8bFZJY6QhKw1gSYLTalUuvpBRE8a5
         dLNxycVYwfY4DZbq88t1JaiqqNh689SzOoK4eyMf0drWU4jVkcvMxUQKHBaC1d7eUKJ7
         EpVoew6Kecb1TeMzKtFOs24hQ1+qsqUoAAlt03C7kSTr3m6IYv54QPDzuAQa43vPpD/+
         pU+SBx+6lmFIRi44r5qIYcBiJ727LU67KSLP1lVhnqRZRkh+322eHNBFA0i0Cn2BzGJ9
         YxrAT6Y36n7ZHggqmc6dFL3reA4SkilZAUxkaEJ8NrQErCGcVmGJiITy9/k+dyQpIQlm
         oFtQ==
X-Gm-Message-State: AOJu0YyMgy/r1uQ1ifSYTsuWcI2ExMadb2QDGdsdF//SMaYUOddwwQbi
	UkFXhgpCdbiitFt+YYOtDOVL1TWLMG9cxXosTNEGOlAe+I2SO4h/9CsRlWNh86NoiDfyrf5/aAw
	BMQ/fCkJe+Rpj0JFpE6iz
X-Received: by 2002:a05:651c:a10:b0:2bf:eccb:548 with SMTP id k16-20020a05651c0a1000b002bfeccb0548mr6186507ljq.0.1700480545636;
        Mon, 20 Nov 2023 03:42:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHjKQM/vOpMY9WYFl3GfILi46upwBqkgOLSeVIAoWAtIypyoBzfkhZr7UG5lapd2y3yGW6eDg==
X-Received: by 2002:a05:651c:a10:b0:2bf:eccb:548 with SMTP id k16-20020a05651c0a1000b002bfeccb0548mr6186489ljq.0.1700480545312;
        Mon, 20 Nov 2023 03:42:25 -0800 (PST)
Received: from starship ([77.137.131.4])
        by smtp.gmail.com with ESMTPSA id k42-20020a05600c1caa00b003feae747ff2sm17922471wms.35.2023.11.20.03.42.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Nov 2023 03:42:25 -0800 (PST)
Message-ID: <4eaec4f20dd463ae46418ebf460de43b15789950.camel@redhat.com>
Subject: Re: [PATCH 2/2] KVM: nSVM: Advertise support for flush-by-ASID
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Stefan Sterz
	 <s.sterz@proxmox.com>
Date: Mon, 20 Nov 2023 13:42:23 +0200
In-Reply-To: <20231018194104.1896415-3-seanjc@google.com>
References: <20231018194104.1896415-1-seanjc@google.com>
	 <20231018194104.1896415-3-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2023-10-18 at 12:41 -0700, Sean Christopherson wrote:
> Advertise support for FLUSHBYASID when nested SVM is enabled, as KVM can
> always emulate flushing TLB entries for a vmcb12 ASID, e.g. by running L2
> with a new, fresh ASID in vmcb02.  Some modern hypervisors, e.g. VMWare
> Workstation 17, require FLUSHBYASID support and will refuse to run if it's
> not present.
> 
> Punt on proper support, as "Honor L1's request to flush an ASID on nested
> VMRUN" is one of the TODO items in the (incomplete) list of issues that
> need to be addressed in order for KVM to NOT do a full TLB flush on every
> nested SVM transition (see nested_svm_transition_tlb_flush()).
> 
> Reported-by: Stefan Sterz <s.sterz@proxmox.com>
> Closes: https://lkml.kernel.org/r/b9915c9c-4cf6-051a-2d91-44cc6380f455%40proxmox.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/svm.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 1785de7dc98b..9cf7eef161ff 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5083,6 +5083,7 @@ static __init void svm_set_cpu_caps(void)
>  	if (nested) {
>  		kvm_cpu_cap_set(X86_FEATURE_SVM);
>  		kvm_cpu_cap_set(X86_FEATURE_VMCBCLEAN);
> +		kvm_cpu_cap_set(X86_FEATURE_FLUSHBYASID);
>  
>  		if (nrips)
>  			kvm_cpu_cap_set(X86_FEATURE_NRIPS);

Nitpick: if you think that this is worth it,
maybe we can add a comment here on why we can 'support' the flushbyasid feature?
in addition to the commit message.

Other than that:

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


