Return-Path: <kvm+bounces-9204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9220C85C000
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 16:33:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 30F1F1F248A5
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 15:33:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0B2B7604E;
	Tue, 20 Feb 2024 15:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3cpdQCDy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7947602F
	for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 15:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708443225; cv=none; b=rPVCnW7/iZSfJZJb4UxGm2Arx+SZVMawQnbypDQ2xuMmyIrGan3NPgG/wunUOrRaic8C1PwpX18u31k7b9YBs0NtOly1TIw+NuuNfbIlI9IYSNgcuDQLAdH19lSnAgEKH4jZCGr0zzs6msZ82LcN3JTjUWpK02FfRA5jcFIHZ5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708443225; c=relaxed/simple;
	bh=7D7kf8p8aX2ZzflAMDnkhBwWgiUvsRg8uan55wPtdeo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=H0DUe3yxUVL51qhQhn8EkVgQs40VP7leL9rpRmit3zSWBWw60GEp7hhPxdIm1aTmbO0bZgjkqwEc5hlFWQKrBYWRp0NcJJuGY5mAwr34pLnvdCvpMWb1S35ZUZGrN2jmlUOdiQ8hBUAEYPJ2VWf7e634yWA2Bsp3JwckPm9j1/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3cpdQCDy; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-607e56f7200so45451757b3.2
        for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 07:33:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708443222; x=1709048022; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1fzOe/J4kuriO/maOGNH55dN19fVKQtEmyIcU4m9sns=;
        b=3cpdQCDyg0mp5DZW2QTFvCcek4NqeDX7/LxCgHwuElM503dUoBSO7gIT1zXFtIJoJk
         Eqrfn3tQlO17zTIzFUB5Da0CpBVfAvgOvjTuzPeLRyqGkd3rW5zKtdM6laTGO/dw3B5u
         EcKxClAj1BrDglpYlG9x8rSdRLTNcFa+vPjHpaDq2PG7n8LWl0/PRern/zFiBMyNvxsk
         hgWsLiCYmfUMjvmN5Hsedn3k1BFFML47uUqPRqS6ntAraoVtSVWuWqLXNCIKV0npv5vX
         2jVBdx7V5bsKNZ01R9eOsrIa5l7iHQ0RSqopNvC/mfGngYDFlJ/WDHPyyVZLo/g5VPHR
         u6bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708443222; x=1709048022;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1fzOe/J4kuriO/maOGNH55dN19fVKQtEmyIcU4m9sns=;
        b=vG00uL09i0nUfp2Y2hsAmQG7gNJykmTkWIWfR38HTBBivZQxOOhP41M5W8gERN29PW
         3SATv37POqoj7y9xbKvmx9FRewnByx+GXpU598WlJk+PKGQ6hSb3IUGSGE9BpHesh9oT
         4+UFIOi4kVv/cck8WDt4VPrJy7J58AIJfNoSC0LOJ7PIt73efotzSquBKZCG/yLTwRI5
         Hgm9tZOCiHStDvvVpgmWjhOzEYe41EOO7pVLA+7YWGJbr9VqMM7HhzCpddEagPUduE9a
         5Om8ZFXA7SHedshXUzmy6/Hoi3x56PCynvYCfquYIeG90t0X2yTRlfB8CwlafishLPiJ
         MfFA==
X-Forwarded-Encrypted: i=1; AJvYcCWzD7YAbv+WcxFEZPp2u/dPtxP11/9afi529xF04PaPrmH5hi64Mj019k07lSezi8CbX0KQVx/4ksWC81kRIjO8IZb3
X-Gm-Message-State: AOJu0Yw9X9x0FLqOSVsVSsVEa0tDJhKvknOhWA99tFKkvgGBiYQ5eppy
	0q3TAhk2/H+6zeiHRwC800ILrKTgMPD5G5mDiHrP5vlREKvHSz2ifM2AES+pOuJu7wslFBwv+TX
	+Cw==
X-Google-Smtp-Source: AGHT+IHV2QTvanF7VyH48/qvRHmtqg+UWhaoc+cyGK8cObSo3PadCiUndGKk4nt1DLGsJf5NFU55wseFcsE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4f83:0:b0:608:6c70:8d6 with SMTP id
 d125-20020a814f83000000b006086c7008d6mr178184ywb.2.1708443222505; Tue, 20 Feb
 2024 07:33:42 -0800 (PST)
Date: Tue, 20 Feb 2024 07:33:40 -0800
In-Reply-To: <20240220134800.40efe653@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240220134800.40efe653@canb.auug.org.au>
Message-ID: <ZdTGRQJIO0Te8zF8@google.com>
Subject: Re: linux-next: manual merge of the kvm-x86 tree with the kvm tree
From: Sean Christopherson <seanjc@google.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Linux Next Mailing List <linux-next@vger.kernel.org>, Paul Durrant <pdurrant@amazon.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 20, 2024, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the kvm-x86 tree got a conflict in:
> 
>   include/uapi/linux/kvm.h
> 
> between commit:
> 
>   bcac0477277e ("KVM: x86: move x86-specific structs to uapi/asm/kvm.h")
> 
> from the kvm tree and commits:
> 
>   01a871852b11 ("KVM: x86/xen: allow shared_info to be mapped by fixed HVA")
>   3a0c9c41959d ("KVM: x86/xen: allow vcpu_info to be mapped by fixed HVA")
> 
> from the kvm-x86 tree.

/facepalm

I asked Paolo for a topic branch specifically to avoid this conflict, and then
managed to forget about it.  I'll rebase the xen patches and force push.

