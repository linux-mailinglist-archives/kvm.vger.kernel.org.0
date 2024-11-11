Return-Path: <kvm+bounces-31517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 55E8B9C456D
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 19:57:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 01B361F22E7C
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 18:57:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9C661B86CF;
	Mon, 11 Nov 2024 18:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O2AZ9Adi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B422E1AB6CD
	for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 18:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731351363; cv=none; b=lAXot3kQcoRv5u96e463dTpDXHxzSH6MLLplyMI5xQZRClGBjCha/5ipopElzdu557BUcpNQzzbLe0Xzn1GOEd2x5SY91hn51st85V9xKSrVEvoRw07OYsJvhqPabnGn1dGJBdApP7LoOAX/W361SBJjwpMAVjD0alEG1ol8usE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731351363; c=relaxed/simple;
	bh=IzlA191a9sOuuFmY6lyNEPM6Jabl7789VNit+P8V6po=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DP7c2XNEgV7S2UQTFplTctNK8BeJj8FKEWR8+66NszNSMfLHpo7cM/IFwhbdLt9HYV+Gj8RR7+OhbntJbQQBgoRyi5t9vkhV3j76iKnYVeBHLoJ1wx5edekdoSyYpfaINY7pyhbflNmlEz2jor6b0W6M8G5apYxvYG56Cos8ZkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O2AZ9Adi; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2e2ca4fb175so5050924a91.3
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 10:56:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731351361; x=1731956161; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=enwYhWXEIuiTV/4/95gHLx0rhJypDLeqYQRs0TBOSwI=;
        b=O2AZ9Adi5KpMW7TjB8YDFuQqrTeASg0eoPMlYTKGQyPwmEOIUKPdhWTFgKSEhJQ3n3
         utRVC+gynAewU3E0bO7uynlVId/MgDp7WARdcE8SISlkRBMIlRN4ArfqAS03zs0h/sZx
         dLHSeDkDwNWXHYNaP66UFRfb4KFDsDfeRqA2sFlP8tsBw0DKCPQVdM+YDUD6VDvE35Vg
         u49J0zLk4u9OOlWRwMXth0rX2jjo2IV2ixZwWVRDm9/GgRZRGArrenEmbBtbVI8Qb5mL
         gc9EItbr5Cp9pnFYS/iAMPSCBQ80C+dV6xjYnwhAD/aaCM3PFCSpaePZAlGaqpiG1cZS
         aIFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731351361; x=1731956161;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=enwYhWXEIuiTV/4/95gHLx0rhJypDLeqYQRs0TBOSwI=;
        b=A5sDg2wPXfBYwZqdDs/B9u/7f55XqkverQRYOLEVQ+y/c8XF8wHQGUYE5mLBqDTZ5G
         RHUGLZg9Xuug6WMDrw/9zdyUCrFVFSnI0PF54AGwuso2Cx1LIdRCFWfutd5NP0MoD+cD
         V4JUzduKwwb8o7lrA3T+7MKJ7cWblHhhX1eDFavUdE9hm9zHRvvCx+3fbJo5NdM8ZG4O
         9r4h4ORikp3RMoTSAfcjU9NdDAP4wlZY+4XGsa0uIxT6xpcCaSNU68inOGQvC0mF2nGs
         4Q34YtFLvS0vQxgFAz9yyTGUsgxbTUem23N4OA8cYXW/SOmGQyZLr+Ke5OM/AJ4iBQSZ
         Wq0Q==
X-Forwarded-Encrypted: i=1; AJvYcCWwoy6i7F/sVjT/2y+EmvCLvla0lgW/B810TlUa+7PMyJSKUbx6ZIsINuzmF/v4atiwGS0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2uU7f19bIzNIrs1LfJfzn8sG8PPBZ/juDRYZhy8JMYljxs3J+
	aw38OO/yaWnjSVC8XQmW29b79ayX7ui9FnVrxd+K/nJX+p91hUULJPaJU4UGef2w0iScyxHvhnX
	b/w==
X-Google-Smtp-Source: AGHT+IEh6ifB12+o7Taest8u41nLOGFUh/dt/hht3n4wmwT2C1a8L6d290cW+MnMzxatdYpxjKvvorfGs1M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90b:5103:b0:2e2:da81:40c1 with SMTP id
 98e67ed59e1d1-2e9e4aaa353mr28a91.1.1731351360398; Mon, 11 Nov 2024 10:56:00
 -0800 (PST)
Date: Mon, 11 Nov 2024 10:55:59 -0800
In-Reply-To: <20241111183935.8550-1-advaitdhamorikar@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241111183935.8550-1-advaitdhamorikar@gmail.com>
Message-ID: <ZzJTPx1ca4JF8FU-@google.com>
Subject: Re: [PATCH-next] KVM: x86/tdp_mmu: Fix redundant u16 compared to 0
From: Sean Christopherson <seanjc@google.com>
To: Advait Dhamorikar <advaitdhamorikar@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, skhan@linuxfoundation.org, 
	anupnewsmail@gmail.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 12, 2024, Advait Dhamorikar wrote:
> An unsigned value can never be negative,
> so this test will always evaluate the same way.
> `_as_id` a u16 is compared to 0.

Please wrap changelogs at ~75 characters.

> Signed-off-by: Advait Dhamorikar <advaitdhamorikar@gmail.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 4508d868f1cd..b4e7b6a264d6 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -153,7 +153,7 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
>  	for (_root = tdp_mmu_next_root(_kvm, NULL, _only_valid);		\
>  	     ({ lockdep_assert_held(&(_kvm)->mmu_lock); }), _root;		\
>  	     _root = tdp_mmu_next_root(_kvm, _root, _only_valid))		\
> -		if (_as_id >= 0 && kvm_mmu_page_as_id(_root) != _as_id) {	\
> +		if (kvm_mmu_page_as_id(_root) != _as_id) {	\

NAK, the comparison is necessary as kvm_tdp_mmu_zap_leafs() deliberately invokes
for_each_valid_tdp_mmu_root_yield_safe() => __for_each_tdp_mmu_root_yield_safe()
with -1 to iterate over all address spaces.

And I don't want to drop the check for __for_each_tdp_mmu_root(), even though
there aren't any _current_ users that pass -1, as I want to keep the iterators
symmetrical.

