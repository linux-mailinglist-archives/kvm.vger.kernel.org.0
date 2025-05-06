Return-Path: <kvm+bounces-45595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C61CAAC706
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 15:54:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 27E267AEA56
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 13:53:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E712B281363;
	Tue,  6 May 2025 13:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P0f7f0SU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FB927FD57
	for <kvm@vger.kernel.org>; Tue,  6 May 2025 13:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746539641; cv=none; b=Au00eOWK/+Il7iYh0trcxJWtV4uZ/i74KacmxtOkU0dMitLG0jBCiOMyrtxBDI9hxjzy1IFg5DjYbYxFCH+7gI+3K9noN+n5XGFoYjtbB9CzdLRnDfFcPZroJ6OYOhRssRFHdZ5tXrNmAPxnGV3ZwG22UCvVE55PTbiWljJyzPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746539641; c=relaxed/simple;
	bh=E0MBUYNrGvgPtAL3Tx7u0b3fFrGahJZFgt+I8HqEuHQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gxbV7tgcnXMDS7El8HIz0oPF76Ji52wymbQPSNhPrKN3iyFyv3aJ14YUnWvh8kVFiszi8ThmsEfi+/n3iHaQuUVCY7bYBbTH+HgZ3qhEoqKXpwdHVL5SD5s/efn4kha109uwl0rN9SAIDeGZp7TWKqk1k6wPdKEU5wE1tUU15iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P0f7f0SU; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30a59538b17so3053082a91.3
        for <kvm@vger.kernel.org>; Tue, 06 May 2025 06:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746539639; x=1747144439; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4mgKVk1+LFsbcw1jY+XDoGyAfQKN78O8ZSwvvMcxjVY=;
        b=P0f7f0SUoUXReXvEU6KXkqBYdGAgWlRfUSJj7TITpoHYvTIRDo0+VWtiaSo2yoiDmC
         wGRXuW76LLtatbPDQOK70T77SRNQqu8gZPG1dPi/GCMSPDFtHrhOz3td6Qk1jy73s7ET
         8mDEle5IB94zT2RoKRAh3kmOXlmbJ+TI46h+M3iWDWTQELvL5lrY+B+ynO4gkam9hiPO
         4O1Zcy/orlEjqaR969okNJ1E+MX6c7c8hKOqu5P3y7c8RBDksyJROlq4Mukk4vZYegfQ
         EpXf1ONr2I5uu6XnN15OVZEhFGgZuVeZOrbKNOEVo3lBVvz3Q6f2VapWVaLB7h7sFJyk
         d8/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746539639; x=1747144439;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4mgKVk1+LFsbcw1jY+XDoGyAfQKN78O8ZSwvvMcxjVY=;
        b=kbna3LOANIBjqBYPEE0qicfLms/qLL+9Gqs9s+WSiFh1koOXel0ZFQN+sE14+wDUAv
         +XsmTCUJG0Jl1+TmcoKGscRT1Q+Caf88pX6EBlJ6UcH3vrgwU4wGF9njEr3GkKfRbC4A
         oKhoL/TFeLGk7NLq2gTWkcFKczEkG0EhHT/AMrTFT+GohrkhEr8STLt43DwkSxIkxzX3
         dU9WK3FOdpSJ1vqiPIG+k4CVjeQg3vVam5u6V/Sf9WiCmxepjJCCmYWFr3WJg5Gzh7rF
         476muUqtZNPSGIXy/vRc3U0BuK6xx1TmymP9Abm+0VQBPcZ0OO+5GffNGvOCJCWLYevK
         Ch8Q==
X-Forwarded-Encrypted: i=1; AJvYcCXZlc11dztWve4NWlPYDiu9Zu5O9SBoJE1VEeykdsvEk9Lq311mMhLNiC6ru9iTvZeQChg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjY2w74p6z+AQYoC+n+LqJ0NA0fkzOsztYrbZ03zvDl+NXqyJI
	XGem1QOmwH+hKnBcPVFFL4karAG/3xNJ4Q8ALvXQJZMX6nkZKjDaVt6wPaGPyZnV9BzZt9wAu6z
	/MQ==
X-Google-Smtp-Source: AGHT+IGO1ZCu2E3J9DQSTbuCStxaXGcWf0OefdURtnN38ZAiX+JOfZJg+SVs+beWPtRWk/oQ9WoWHf6IzJc=
X-Received: from pjbsc5.prod.google.com ([2002:a17:90b:5105:b0:2fc:2c9c:880])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5704:b0:2fc:3264:3666
 with SMTP id 98e67ed59e1d1-30a4e6914cemr24620709a91.30.1746539639028; Tue, 06
 May 2025 06:53:59 -0700 (PDT)
Date: Tue, 6 May 2025 06:53:56 -0700
In-Reply-To: <20250506092015.1849-3-jgross@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250506092015.1849-1-jgross@suse.com> <20250506092015.1849-3-jgross@suse.com>
Message-ID: <aBoUdApwSgnr3r9V@google.com>
Subject: Re: [PATCH 2/6] x86/kvm: Rename the KVM private read_msr() function
From: Sean Christopherson <seanjc@google.com>
To: Juergen Gross <jgross@suse.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, 
	xin@zytor.com, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, May 06, 2025, Juergen Gross wrote:
> Avoid a name clash with a new general MSR access helper after a future
> MSR infrastructure rework by renaming the KVM specific read_msr() to
> kvm_read_msr().
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 2 +-
>  arch/x86/kvm/vmx/vmx.c          | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 9c971f846108..308f7020dc9d 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2275,7 +2275,7 @@ static inline void kvm_load_ldt(u16 sel)
>  }
>  
>  #ifdef CONFIG_X86_64
> -static inline unsigned long read_msr(unsigned long msr)

Ewwww.  Eww, eww, eww.  I forgot this thing existed.

Please just delete this and use rdmsrq() directly (or is it still rdmsrl()? at
this point?).

