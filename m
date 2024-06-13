Return-Path: <kvm+bounces-19594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EA1FB907885
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 18:44:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 69F7D1F214B4
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 16:44:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38967149C6A;
	Thu, 13 Jun 2024 16:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UTmvtuSy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544521487E2
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 16:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718297023; cv=none; b=tf7mhAxLIpZArA3Is58l79uAiS5/3huW0qz7aPSEMBKSBjrKpmcWT9TpJfQH+BYnUbZWwLSlVVQMufDzceueUZIH494FSQC4X0ueSvpG5r/LZJIFPs24F2BsE22pim6beuQSMaUwRm+pZqfevJ9HubXIO1u1KyvRFo2a2bCiUWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718297023; c=relaxed/simple;
	bh=Mez2tR7LHp61PQ+7LTtQTabYS9beKcDIfS/XBjc8Prg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jOljRtnXYuPiuqDzUNasMZR2VC4Ln2N5HSa/6mFFxBiY5BThMPn2xT87RPg66hcJiYzj5/YZr+BTdig/YmAt32VotFE4UEbkAsn/tA0C1wQX3E8ZkRBYdpqf//7eT3b/nFj2anukcPgaxVTGFCDij0aafpYiNP0gFw60Rmpubdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UTmvtuSy; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dff151b19f0so23457276.2
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 09:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718297020; x=1718901820; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bxjiAwnYIG7/luxCNc9XCi7cU7Sed/5iGmGsAhazkBY=;
        b=UTmvtuSyEysg7WUL3TFNRubIr5PQuSpKq2aeJNOk7tARaJRwE6FytWLmWYGZtjONDY
         tdXZpRiKf3r3dL6Yw/hVfRMvzTjkYxTbAFo7xeyBpHz2ckwcal1DAadOTC1P1xS7CPbW
         mVzKg/SZHlcrlgMwEWWX9TXA3sfWtGFoNgW/wk4ZrGWASbYhkSA/auDOtOJOW36jlwBV
         pmbxpxCoEoTGB+Kf61RL8yAfJUvEISQ/Rn673r1mgNG0GloLmLt5vcKdiBpzbtmL4gDQ
         m404kRMnIXhL6BtlRTGClBd7jWQd/6a8YP8Vz6N7AoE4TSD+aHKRCFWWPtzT4mMF4Nhl
         uHWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718297020; x=1718901820;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bxjiAwnYIG7/luxCNc9XCi7cU7Sed/5iGmGsAhazkBY=;
        b=aY1XpQ4Q1kc1/3KRnWFrj0xYiToE3r8foe16kPSFcNDRgbbCBsg32sHFTHNn+DEpbI
         YsJmHeuqyF7FezmHQE7SnO7XXe/CXSSchqRUe8UAucGHZ6yjgUnLgoHZqG//hOGVJ/vP
         x+oQfdjDIigXeAJ01fTqlTtRA3h49O7wxKJLSFmw4cppvZoXh9+uaowafEa+4RbuEwX6
         nIz8f0aOzcH5IENzYm5L13O1meaKWH3PKPlOIxMSyuBPhoOc2rqPG363BamRHcXURKis
         wweJZyG29cwH7gG7Hfqd9u0uOlKwZojxL5qv4kgBEU0a8jNaUhMDctPCsdd4P90bgm7H
         batw==
X-Forwarded-Encrypted: i=1; AJvYcCUxUPxU7Ns4VN9LT9owR7cKcnLOpOEN6HkmpgTOLDszVCFa3MuHVycC5ZjcPDDEhfeniPKQSzInFhT+7coI7rGhoMu9
X-Gm-Message-State: AOJu0YwzeGJTFgaIUQ8N0pKHEvM4UrDbPPSccjGVIRN6edZIprO4lRl+
	Z9pox72zSIjclCfXeu8I1aKX3Blyy9Ho9znhcf1BUXoPXApdfuE5X+Mb7ihlzVXww0sbnKDgeQO
	B1A==
X-Google-Smtp-Source: AGHT+IFKpKXtwVbLs4PzFwLiw9YWvLbNmcmB33v/EKY4vQAK4mBZLe56XhpTFNo1A0lAEiWi5fzJeut5/74=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:18d0:b0:dfe:ed69:7861 with SMTP id
 3f1490d57ef6-dff1535946emr370276.1.1718297020402; Thu, 13 Jun 2024 09:43:40
 -0700 (PDT)
Date: Thu, 13 Jun 2024 09:43:38 -0700
In-Reply-To: <20240613122803.1031511-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240613122803.1031511-1-maobibo@loongson.cn>
Message-ID: <Zmsg8ciwSp1a_864@google.com>
Subject: Re: [PATCH] KVM: Discard zero mask with function kvm_dirty_ring_reset
From: Sean Christopherson <seanjc@google.com>
To: Bibo Mao <maobibo@loongson.cn>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Jun 13, 2024, Bibo Mao wrote:
> Function kvm_reset_dirty_gfn may be called with parameters cur_slot /
> cur_offset / mask are all zero, it does not represent real dirty page.
> It is not necessary to clear dirty page in this condition. Also return
> value of macro __fls() is undefined if mask is zero which is called in
> funciton kvm_reset_dirty_gfn(). Here just discard it.
> 
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  virt/kvm/dirty_ring.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> index 86d267db87bb..05f4c1c40cc7 100644
> --- a/virt/kvm/dirty_ring.c
> +++ b/virt/kvm/dirty_ring.c
> @@ -147,14 +147,16 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
>  				continue;
>  			}
>  		}
> -		kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> +		if (mask)
> +			kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
>  		cur_slot = next_slot;
>  		cur_offset = next_offset;
>  		mask = 1;
>  		first_round = false;
>  	}
>  
> -	kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> +	if (mask)
> +		kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);

Given that mask must be checked before __fls(), just do:

diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index 86d267db87bb..7bc74969a819 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -55,6 +55,9 @@ static void kvm_reset_dirty_gfn(struct kvm *kvm, u32 slot, u64 offset, u64 mask)
        struct kvm_memory_slot *memslot;
        int as_id, id;
 
+       if (!mask)
+               return;
+
        as_id = slot >> 16;
        id = (u16)slot;

