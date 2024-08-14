Return-Path: <kvm+bounces-24201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D4ABF9524D4
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 23:33:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9226A2877B5
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 21:33:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBD461C7B9F;
	Wed, 14 Aug 2024 21:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O55Wkapa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256651C4607
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 21:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723671228; cv=none; b=H+ZVCpQnRAvAbfPLk6OQWTVMBfU4oo1jS8hu1KxRC6m9vsg3jmyyw8do2Ru3/QwxKiWm+1Lcktd3278mAk9fHQ2tiG3zJzmQ80DxlSGi5G1lLKcXfczFqEHjXMGKRvge7QauK7DDoOJhSz2JClF+DBsJjEU3Y3eO5QOWjqgWEBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723671228; c=relaxed/simple;
	bh=0JjqrbPwC03gv1AyevCkxjS8lmm3CFD82pbAPxmZF5Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jlA41TOfi2cCoPemQMlunPxv2Mx5LrOFx9J4HLOvWv4XFkH4kCE+BLuNIP9Rt3NLReEjqfcXC0Q0GxdmDTGHmXRQaSsjH/OaXuvPKshmE3D22wnAZ/iYPBRFEfJPfzJZ6TOXiUFZnIKn+esf429nU5iv3AE7qMCXuHlnBDBcxwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O55Wkapa; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2d3c89669a3so84170a91.3
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 14:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723671224; x=1724276024; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=q0g5NjtodTEAg1xeSolkAqdDfvHP56di0gLWfcl3NRU=;
        b=O55Wkapa6cPUEJ4kcca96cElJ4Qc7n7ysvY4tA0gomrLbR61cDZqxbjAdFoIbJhlUH
         dpgeUphrBsshLYZVggrSNchn09fzdV1n7bF9aUAfEJsDfjO5r8sEdIaylYdHpi89tQfV
         o8CjcjzSTkh0EbQh8K2ZuK3rfzON+S2An/b/7sHKiSn4oZh2VtujQI6ec/xRemA6Hilw
         YiLYMzA8MUysEvfkYr+MizNQ+Qv0SbuRIB9NL45jaN9avnF6I3iPIDuGPw5+Tv1j4afQ
         lgd94CxHocYiiTQg7Dygqj4KCWixJM1T6K/4iR4SGb2JjsaUGp9IVdw3nNEKeZuP/9rR
         KuoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723671224; x=1724276024;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q0g5NjtodTEAg1xeSolkAqdDfvHP56di0gLWfcl3NRU=;
        b=Oc03TndiBmIWHVrdu50wp6u20EWwRQp2szVXzozeJkyyNDhnT00FF9skxSbJnvDrgV
         UsCqjxGNnTw89xamNsyWCGo9Q9LC7ETHYQL0eYHSPId+XdQY3/V7wX4XWV3MPIOyWK6e
         VdtVdOFjXq44voWPOtqYjjjpxNhkIUzhxMT0jiUHpgFz5CbRDo8ZxUGGbg5MrKJ9vYR9
         7pZ0shofcBufOHvV65aQcHWynr6Q/onJ9CcDiCj1AjxwIUmlpMz/n7Q/8JedIfNytNt0
         kmuuUSP/ES9RNPuITMiyaLiwbn8dibjiIH4hdPqDX9CVCrxrUu9QkxZs05DVgYazq2Up
         TT+A==
X-Forwarded-Encrypted: i=1; AJvYcCWZy3KoR7frSTa3qKATXdMhEvIWSVIrRXcyli8/YxQm0wU3xrnHfXwa6RNk2H+kDPQ6l8+peG4G2OD8sB35TKD9NWDO
X-Gm-Message-State: AOJu0YxKvVdxJ640flS/lfdW0GU1o5Bu2yT/LI+vL+3U0erLHDWHvOyr
	F3d8DOZx4x+NMK+yGZ0awsRDEDsJ+tm1/VNYfYIxl9G+XL5wWcu46x9zB555tyeLRy5kpVvf+N7
	EXg==
X-Google-Smtp-Source: AGHT+IHMmJW+eZKzGIU+eHnNK46MXf2jqEOHghKxbPm48duoRJ7tzrlc2lv3bqiOWbip9fnyFn+oZyDwdxI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:7c49:b0:2c9:348a:8ef0 with SMTP id
 98e67ed59e1d1-2d3aab18fefmr18576a91.3.1723671224150; Wed, 14 Aug 2024
 14:33:44 -0700 (PDT)
Date: Wed, 14 Aug 2024 14:33:42 -0700
In-Reply-To: <20240814203345.2234-2-thorsten.blum@toblux.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240814203345.2234-2-thorsten.blum@toblux.com>
Message-ID: <Zr0itgdmn6LGDFsQ@google.com>
Subject: Re: [PATCH] KVM: x86: Optimize local variable in start_sw_tscdeadline()
From: Sean Christopherson <seanjc@google.com>
To: Thorsten Blum <thorsten.blum@toblux.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Aug 14, 2024, Thorsten Blum wrote:
> Change the data type of the local variable this_tsc_khz to u32 because
> virtual_tsc_khz is also declared as u32.

Heh, thought this looked familiar[*].  I'll plan on applying this for 6.12.

[*] https://lore.kernel.org/all/ZT_WBanoip8zhxis@google.com

> Since do_div() casts the divisor to u32 anyway, changing the data type
> of this_tsc_khz to u32 also removes the following Coccinelle/coccicheck
> warning reported by do_div.cocci:
> 
>   WARNING: do_div() does a 64-by-32 division, please consider using div64_ul instead
> 
> Compile-tested only.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
> ---
>  arch/x86/kvm/lapic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index a7172ba59ad2..40ff955c1859 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1946,7 +1946,7 @@ static void start_sw_tscdeadline(struct kvm_lapic *apic)
>  	u64 ns = 0;
>  	ktime_t expire;
>  	struct kvm_vcpu *vcpu = apic->vcpu;
> -	unsigned long this_tsc_khz = vcpu->arch.virtual_tsc_khz;
> +	u32 this_tsc_khz = vcpu->arch.virtual_tsc_khz;
>  	unsigned long flags;
>  	ktime_t now;
>  
> -- 
> 2.45.2
> 

