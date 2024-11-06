Return-Path: <kvm+bounces-30960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A59479BF046
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 15:30:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69C7D285A00
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 14:30:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EA292040B7;
	Wed,  6 Nov 2024 14:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cCB014Ev"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A661DEFD7
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 14:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730903359; cv=none; b=NK8uIlpTI+PRn9Tr3mqJz3n6qJDb6yNW4VYdKeroE4vnyYLP+kvWBx4jhYe2VysbWsJYoGdrcStcTacC3x9AAqvLZR5IKJdDYxmj/jgbdPQVlUB0/UJmkPTsVIuo6CTQ60Xpnr2dpk/ABU2TQzqbLrTBWRo3tW733JScYFptvvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730903359; c=relaxed/simple;
	bh=YQRPILUC8pxqFiXOJMl/jAfX7hkH7PV7OV37EcrGHiw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JlpjexsIGCaFL4DZx3y/FM+uctBeA7tv2F0gfaixA0nT40kwSRxAzZ+zUcLtneYzFjGlO/1bXdqUB3QL8e1D3XNk98FNePX7tJeayMA5lBVmVSQRmyrhMCmqL2F0UxSQ6uzJB7VuKT4RogerEywD4xeDGF9l18Nubt7qK+usEBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cCB014Ev; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2e2eb765285so8361993a91.1
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2024 06:29:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730903357; x=1731508157; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Tgkg1h6fJIChs1xp/Mp0C8zbhKIs+XwcnBA6dAqcGF0=;
        b=cCB014EvQ+6nF5NUTq34/5vPb6DOFrSzlh/mEzTWRv2EEbYbFzcOD43LiV/KVRipC+
         U9KZGCV3dDGkRAVdrRD6tJBlbRQL6UMA3g2tkpr3Gg9vyNXMyTKxx3jd3CNSCNi6CxdI
         O0kr+Q7SpD3dOcqK7XZ62Mf3NHdPqogOJwNcngFHr3Qvl4HjkTV1LlHw4i9G1sCGGr+u
         JGRU1PBQRXTc2IsefpeCKWkybOjV2uR3YWQJQv2t54U0jXt//AHA69AnMCPmKPwvA7LL
         CAKPPuv6YLO9fM+4WNtBw43KbJvYbYRaYDulIhjbcM2KVla1z4f3aOVl3hMcyVDqmMGf
         iS5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730903357; x=1731508157;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tgkg1h6fJIChs1xp/Mp0C8zbhKIs+XwcnBA6dAqcGF0=;
        b=MozRXO43qsxSlC4Jw6r03FNWnkCywJbaHcMfzxwxaynVbTL1cMITj+9QpG3zuEHd2y
         7qhqgJ5iKDP/BA2Nikhy4fCQlLyBrmXPEOKOd5SSfAHo+ZOQMdXeKSRy6Q2IFwqsceH5
         aZ1l27ppMXn/aQ2iSGkbuWk0rVs94J10INx3c9kpUOLEx3R2HWUUrDC2ohZRl9AyH8Ma
         Nz91CFlX1x/fNuwsR3z6j7kBNevh0RmbTOcM63c5v2T+rYWoCV6MhUMe1/MIHN77Q72J
         QvWIT1yy7bkm9GRe7L7kPE4IKErjmi3cqCzoAaGTbN2EWK0olI4e24CJq+zW8Df21BZs
         SzAw==
X-Forwarded-Encrypted: i=1; AJvYcCVCPEHnOdXb8frTCIQBg+vxrbTA+GsZYTuDMtBDQpUL4FdItzKuXmBg/5C/5HRF1jVYqX8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNPZbYECZXiXiKCoRPTnxRSjRDUbMkw5g/suzeeoA5O2U0Jtna
	srAnp48vZIaWAKAuBD/Ab3AMgenmH8vmLUR51/1IwVO8dsBVP4f3Yn9k3BhMzlj2aqw2YhnHSNM
	pVg==
X-Google-Smtp-Source: AGHT+IEome3VDcewPA1RuUuqmYyqWnEqRt40Bbv3VczeQeBrsEbbik49BwGwTAM8DguZ+ILjWAKYeIormzw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90b:288a:b0:2e9:47ad:c4f9 with SMTP id
 98e67ed59e1d1-2e94bdff721mr68311a91.0.1730903357492; Wed, 06 Nov 2024
 06:29:17 -0800 (PST)
Date: Wed, 6 Nov 2024 06:29:16 -0800
In-Reply-To: <20241106034031.503291-1-jsperbeck@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241106034031.503291-1-jsperbeck@google.com>
Message-ID: <Zyt9PPB5AGE73HHC@google.com>
Subject: Re: [PATCH] KVM: selftests: use X86_MEMTYPE_WB instead of VMX_BASIC_MEM_TYPE_WB
From: Sean Christopherson <seanjc@google.com>
To: John Sperbeck <jsperbeck@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 05, 2024, John Sperbeck wrote:
> In 08a7d2525511 ("tools arch x86: Sync the msr-index.h copy with the
> kernel sources"), VMX_BASIC_MEM_TYPE_WB was removed.  Use X86_MEMTYPE_WB
> instead.

Drat.  For all my talk about KVM selftests not caring about kernel headers, that's
obviously not entirely true.  Most of the selftests code is standalone, e.g. CR4
and xfeature bits are all manually defined.  But redefining the myriad MSR #defines
does seem like a complete waste of time and effort.

> Fixes: 08a7d2525511 ("tools arch x86: Sync the msr-index.h copy with the
> kernel sources")

Unnecessary newline, i.e. don't wrap metadata tags.

> Signed-off-by: John Sperbeck <jsperbeck@google.com>

Acked-by: Sean Christopherson <seanjc@google.com>

Paolo, can you grab this for 6.12-rc7?  And fixup the Fixes.  I'll mention this
again in the pull request I have planned for later today.

> ---
>  tools/testing/selftests/kvm/lib/x86_64/vmx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
> index 089b8925b6b2..d7ac122820bf 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
> @@ -200,7 +200,7 @@ static inline void init_vmcs_control_fields(struct vmx_pages *vmx)
>  	if (vmx->eptp_gpa) {
>  		uint64_t ept_paddr;
>  		struct eptPageTablePointer eptp = {
> -			.memory_type = VMX_BASIC_MEM_TYPE_WB,
> +			.memory_type = X86_MEMTYPE_WB,
>  			.page_walk_length = 3, /* + 1 */
>  			.ad_enabled = ept_vpid_cap_supported(VMX_EPT_VPID_CAP_AD_BITS),
>  			.address = vmx->eptp_gpa >> PAGE_SHIFT_4K,
> -- 
> 2.47.0.277.g8800431eea-goog
> 

