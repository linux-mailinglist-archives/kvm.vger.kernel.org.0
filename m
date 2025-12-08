Return-Path: <kvm+bounces-65515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C35ABCAE55B
	for <lists+kvm@lfdr.de>; Mon, 08 Dec 2025 23:37:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A775C3072E11
	for <lists+kvm@lfdr.de>; Mon,  8 Dec 2025 22:37:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 322F02F0C78;
	Mon,  8 Dec 2025 22:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BqmOJnui"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5E72264BB
	for <kvm@vger.kernel.org>; Mon,  8 Dec 2025 22:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765233445; cv=none; b=LP+WzjqybaaR4sZQ7ZSp3hRkxAANEifxwGFipJm7AMGeldSmN4jDCAxxLGe9ZrNMEUb68BcGUEI0HIdrXACP77zxHwzugJeHS4eRMNxvbxa1tN6zH7AD2Gw10nQHyjMhcobtRT9NHRQSHQL5JBOr5AUoUzH31AEMGKjIwKecOQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765233445; c=relaxed/simple;
	bh=eGduI9DLSzdLa234BL9qvzXvNvoR51S4eNInhks2FrY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ifN8OQtjFavtAThLcxg0x24NFsAI2O/P2RFS51+7LuqVGdOuBq0vxzCM1wB1WHxC1XUFyC+/EAJg4nWyGUBzJEjGMytP19I/XPyozuruszKgrTWRGqQB8irKzGfibZLnqgW0/aJWZrD2t6WpPZFtb9F6lAwxOsZVUV/RTktd8sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BqmOJnui; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-343e262230eso5712619a91.2
        for <kvm@vger.kernel.org>; Mon, 08 Dec 2025 14:37:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765233443; x=1765838243; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BRQX8LLoXNonSM0jC0nd5loT2xtDYX8H+moX8AQ4KO0=;
        b=BqmOJnui38kkFCqQw4mznCqckaomlhS/SYUMvcQMieUZIPNv9EjS+wAuu2XGwpz5u0
         kF7Ni3cTobZFW5jYr1De/wMJr767DMyU7/jgJMl7nztlsxup4FsoXT6+XsqzLF9ppWAE
         sn34PJcK6sYM+2/iqPlC/G53H6ULqd0Z35OcBuW6XSOj/DX2akIzvTPKmLEmgeVyFBx3
         J3zaFlhBz8yRF1WaGodcmCjVVB4TKxju0YYwSB+sNUP8oNdtIIM3qoum1Mvh3tOWJXpq
         +/vCK2311hOfOU2ZCpOkjxWuQp9nJCI2fU/jHm89JpliA1YR+LBf5GDxO500WhFlhCQ0
         AtYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765233443; x=1765838243;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BRQX8LLoXNonSM0jC0nd5loT2xtDYX8H+moX8AQ4KO0=;
        b=YUVFnLlLHgjMnoyG6n1sUKAjgos/Qk+5+EjEZZ10I572uy/FXoEZCPoMSp+Ah+Q4Dn
         hDGfH8r01qSn4AagJeH6Zz/7QTcnNjxl58OaoGGGuSElXGc2XeT+L5GJkPpWc7iA1QvS
         xqZwG/xl1zT5zPK9w2wfHyqZQFGz1XUzatTJOm12zscqh9ezHwEny3lPFaY6Bnm0i8xk
         udr43lGOeURqko/cCOo8yWFB6UgWOOKhOYRE7Ed5Hyfi9SySRKGMhYrL9vonh4pK5vtl
         tNYcuamiQc4ZjmYm7ks6/yQTz85B8t2jmv8NHRubSFJXNJ+94t85XW9YQ6UpTQTzcJMS
         EXvQ==
X-Forwarded-Encrypted: i=1; AJvYcCUlfa0ODclGrsivSftAR+ratMuicX31xaALfnPvLLTsxco04fc9EqousgJAkmWSu+/QUmA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+ajTFNU675UP85I1g5xMBWLEDHa2DkQ1iXPP+cno0nYeqrDvL
	8xrMx88vEb16KHWJqG4jymOWuyd8/pVJn2HARdBruUSAuUMDMLvfjbeAxAEETDzdFe8Z38mwG/C
	r/YFwVw==
X-Google-Smtp-Source: AGHT+IG7dILCLrNlbkj3XRzQSNcyJ22dVjHPSSIbcvJVvaK6QeGz0Jbil9m1JwmPiFVWP0jKbHsNmWWtcms=
X-Received: from pjbgc22.prod.google.com ([2002:a17:90b:3116:b0:343:4124:2e82])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5388:b0:349:7f0a:381b
 with SMTP id 98e67ed59e1d1-349a24dcff1mr7439336a91.8.1765233443098; Mon, 08
 Dec 2025 14:37:23 -0800 (PST)
Date: Mon, 8 Dec 2025 14:37:21 -0800
In-Reply-To: <20251026201911.505204-20-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251026201911.505204-1-xin@zytor.com> <20251026201911.505204-20-xin@zytor.com>
Message-ID: <aTdTIWND0d_pyefu@google.com>
Subject: Re: [PATCH v9 19/22] KVM: nVMX: Handle FRED VMCS fields in nested VMX context
From: Sean Christopherson <seanjc@google.com>
To: "Xin Li (Intel)" <xin@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, luto@kernel.org, 
	peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com, 
	hch@infradead.org, sohil.mehta@intel.com
Content-Type: text/plain; charset="us-ascii"

On Sun, Oct 26, 2025, Xin Li (Intel) wrote:
> diff --git a/arch/x86/kvm/vmx/vmcs_shadow_fields.h b/arch/x86/kvm/vmx/vmcs_shadow_fields.h
> index cad128d1657b..da338327c2b3 100644
> --- a/arch/x86/kvm/vmx/vmcs_shadow_fields.h
> +++ b/arch/x86/kvm/vmx/vmcs_shadow_fields.h
> @@ -74,6 +74,10 @@ SHADOW_FIELD_RW(HOST_GS_BASE, host_gs_base)
>  /* 64-bit */
>  SHADOW_FIELD_RO(GUEST_PHYSICAL_ADDRESS, guest_physical_address)
>  SHADOW_FIELD_RO(GUEST_PHYSICAL_ADDRESS_HIGH, guest_physical_address)
> +SHADOW_FIELD_RO(ORIGINAL_EVENT_DATA, original_event_data)
> +SHADOW_FIELD_RO(ORIGINAL_EVENT_DATA_HIGH, original_event_data)
> +SHADOW_FIELD_RW(INJECTED_EVENT_DATA, injected_event_data)
> +SHADOW_FIELD_RW(INJECTED_EVENT_DATA_HIGH, injected_event_data)

Please add shadow fields in a separate patch, with sufficient explain to justify
why KVM needs to enable VMCS shadowing for the fields (it's purely a performance
optimazation).


