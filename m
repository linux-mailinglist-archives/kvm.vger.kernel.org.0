Return-Path: <kvm+bounces-48675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AA522AD0A04
	for <lists+kvm@lfdr.de>; Sat,  7 Jun 2025 00:42:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6AD4C179F55
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 22:42:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4671D23A9BD;
	Fri,  6 Jun 2025 22:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4HKdiKyb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC1E233156
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 22:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749249717; cv=none; b=aSpPQx1szvfMoF+s9iqowX/waHJ43F3Fkxq3jqCHYRoo/J5Dg2vyaggE4iRybHGhByka+9gFwZ5x5TxNfvp3Ot3f9TTszyKYTJ9/JGenjfN7gUETtSJSUpQinNSGl0/xkob89EQ+D6ya/wE8szJX0MZVGovbS2+Thy8s6STx7jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749249717; c=relaxed/simple;
	bh=AfFvJzb4MQFPYprIsT1kp3eEJ8Mfo2gMrav1f09J9ik=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=awvYODynJUq+/vCfDxMDKXFem9J9UmFppQQSzhpZEEaunKAa6viCZQGGdW+xtaL6FIg91dxLR7ZSwRGYcxzzunOWqfB5gchGzL+LjPQaDDlGNJEAXH/yfHFnFrkK5oOQxFqUcpmvYJHl/I2hF0HZX7Kaw+b3Wuy4gbbuHTUa5p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4HKdiKyb; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3132c1942a1so3251755a91.2
        for <kvm@vger.kernel.org>; Fri, 06 Jun 2025 15:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749249715; x=1749854515; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bYoTu+bMCHUoVpZNp96TkhxLozCIXTPEx6r4fnUaXIg=;
        b=4HKdiKyboPoVWF5v1OR06ngT8lv8GrqGq2GlKjS3KswHZ5FNMMjSYOGgM71LQHHFkS
         kGjWApSgpXKz9afOB5Gy+ie1gfrbod9azd0yaY9wXobbbCzljrxEmh6q1SJTbvuz7YJZ
         QrV2W0feGD1s5GH2NjDdUK/NeIuXgD543W4v4xZG9+9uS49c/c9Vs65EsNCBxzd+WkzF
         Nde6Sq9nvsOfvq/Z3dUl3QeCzcbeZmXMti649hzXJEXOhw6Tk7Z0rz7U7VtXdwSUOJfU
         mDzfA9U+c/JMTkoagXr3njuxW93umCh5LOBFl5Rrevq2PWqmGX1NBDXFGDZqPmTOLgeN
         OCHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749249715; x=1749854515;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bYoTu+bMCHUoVpZNp96TkhxLozCIXTPEx6r4fnUaXIg=;
        b=a+bftw6jVnWjma83oK88Ej8r3CbcL9DZNM3l9hUAK60fCbXStrCux3jlo+A5wodNFB
         n3iff/9Xwh6SVgX2I3Cz9Cm24C3pF+M64EdC7sGG5D6Um3fEJJPy++PbhWHi21AxLfZL
         2OIFhGH8i8STDf5s9Hd0PhtWyknAqbBgjDJRYfJ6DmFa3jXRjuiKuyANkPuObbRy2ZCb
         tE1C9SwG84VBcWZn3IZM9pt9jKBN+GmyXZ0TqmzqGBShOKnnu0UQ9iL8IjHfuntV9k2u
         FzH3ruF77/p4/N1Yyu8IJrEDuZCw57nLxFsCTr3dCb9/rzGt6azkLtZ4mXafPGyNWE15
         YKsw==
X-Forwarded-Encrypted: i=1; AJvYcCXoiEAf5pRgnwXcBALzbqR4gQV/jxCtG948FpsDdEOnbVR0t1goTO4Fdzs8AghzSJwaZuI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4yLYzAGWkw1zwYuzPk0lL1epm1MycvkLp4GxR6xg58/zvcOCh
	7giGDA5UcMPFKlUrl3css6ga2qxylXZ9ZvXW1HS5U9CpazmtvYHMDA99dJSQtV/vxBPpKW2t9Cj
	iLVCmpw==
X-Google-Smtp-Source: AGHT+IHypEL2f87RRyk8KcwnXrUV1xs9cPNm7T9Zs+gygo3vvDD6Q8p5T967Pdv+Sm6z+/JiXtJkkspYdKQ=
X-Received: from pjbqo14.prod.google.com ([2002:a17:90b:3dce:b0:2ff:84e6:b2bd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:520a:b0:313:28f1:fc33
 with SMTP id 98e67ed59e1d1-313472fb0ddmr8343577a91.10.1749249715474; Fri, 06
 Jun 2025 15:41:55 -0700 (PDT)
Date: Fri, 6 Jun 2025 15:41:54 -0700
In-Reply-To: <20250401161106.790710-27-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250401161106.790710-1-pbonzini@redhat.com> <20250401161106.790710-27-pbonzini@redhat.com>
Message-ID: <aENushMhwV_csfU_@google.com>
Subject: Re: [PATCH 26/29] KVM: x86: enable up to 16 planes
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, roy.hopkins@suse.com, 
	thomas.lendacky@amd.com, ashish.kalra@amd.com, michael.roth@amd.com, 
	jroedel@suse.de, nsaenz@amazon.com, anelkz@amazon.de, 
	James.Bottomley@hansenpartnership.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 01, 2025, Paolo Bonzini wrote:
> Allow up to 16 VM planes, it's a nice round number.
> 
> FIXME: online_vcpus is used by x86 code that deals with TSC synchronization.
> Maybe kvmclock should be moved to planex.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 3 +++
>  arch/x86/kvm/x86.c              | 6 ++++++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 0344e8bed319..d0cb177b6f52 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2339,6 +2339,8 @@ enum {
>  # define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, 0)
>  #endif
>  
> +#define KVM_MAX_VCPU_PLANES	16

I'm pretty sure x86 can't support 16 planes.  "union kvm_mmu_page_role" needs
to incorporate the plane, otherwise per-plane memory attributes will won't work.
And adding four bits to the plane would theoretically put us in danger of
overflowing gfn_write_track (in practice, I highly, highly doubt that can happen).

Why not start with 4 planes?  Or even 2?  Expanding the number of planes should
be much easier than contracting.  Based on the VTL and VMPL roadmaps, 4 planes
will probably be enough for many years to come.

