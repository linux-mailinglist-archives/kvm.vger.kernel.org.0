Return-Path: <kvm+bounces-64023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 00D9DC76C7D
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 01:35:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 052BF294A4
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:35:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB7CA26158C;
	Fri, 21 Nov 2025 00:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cQiUfifF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B4533985
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 00:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763685322; cv=none; b=Ds/Q36T1Y/Ers/MCokrMNlD2snQKibUHKWm3zWsK82GGKkAGY95I81fSewgJkSmFO79w0bHIeXiGG7BdMkVTz061cdVhBBKSPFTAZnsH48u+8lvORDkTsPtY5H0eyNO7RbcHEZyglckGQ0PW86dpTELcSn1PE4V90QtTj3k7GSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763685322; c=relaxed/simple;
	bh=3OChlrmQKATxVpYpuB+oz/ry9O2xVPknjT8fb666zsQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GRkV5CmKuPf/ipAwuqs73qVt1/n1q0TnQlPWTjGBQ4ZP38+rwx2wjCcynYUVhX0i3EIYiebp6xopWjTT0DlKQC3vEq1ErYdVTSJfLw7JJ91eT3EMufe2CI09mBYzlnxrIA2EQ7wwVhTDLCyfY6l/G1BCNtG1RQhAucqNkhb3TQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cQiUfifF; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-297df52c960so43235085ad.1
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 16:35:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763685320; x=1764290120; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cHLDZszmr1TnFL0JXaFkeoodC4elnYIqQNnTDiuHk4M=;
        b=cQiUfifFiRfglklHqjeHO+rreKtUXzA5XLVLeH0pfzLStshTHFxU905y9P1IWkSj+W
         Eo47isAQP19ynNwARyJgMb11/A1U6xaTj/vjkMwe4WzGt1FtWIG4Q8YdcrJCjpwTCw0l
         FFEf/9kAFK6VdiWPeq5FAlV1t8cK3Xq1wcqV89vfhSvxDw4GS/uWf9Vo/E8mE7UxVjpb
         ZNcfVrYlerKf+kpI9O5x4FlYveIqDBAL15ULciCw1y4iJPWVJII4igcNX6m2tfcYK7Ca
         x194st4h3XYxFQYbw8fsQSTqZFgvmIBW6v6UKxmBwjuGxv6AoqQNTjnZWBGoKfGzYtVf
         iUyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763685320; x=1764290120;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cHLDZszmr1TnFL0JXaFkeoodC4elnYIqQNnTDiuHk4M=;
        b=Q2HfCX9D7kJS4IjB1mNRJhF/Nrs4n+nh/pyXaHmpH+nurnvS9Z7c0oaqcWE+YNrlUE
         xdVXH3jWiLmExrutATKwcAjFoe7sM9lXl4+Qny8VC0By08npoGmwQ5czrGsyyI4wPxNE
         leXUsjZMMC0WxS7Uqay2GHpvG1X9q/Xwtv2jPNrpM9itM479k9hwyfFZSV9cYnOgqZWd
         ZrppOelNNaxoWpoFOBIKei7PL8jFTVyYgSHUd7Fe/meZmjLOgcX5Wqx8I5/kACFptH5W
         BmoVb7CvOhYqQ0W//QvZ7GPcep8GuIpLejTyHrKUF2kRypnj0ROnJPLufEzvvMkZ8oB5
         7g1w==
X-Forwarded-Encrypted: i=1; AJvYcCVVibKZPm/PGRNHKm7Be1v0+fJXPmLw2aw3lH1eN8BEIOMudLD892J9JpCZe9Ldwyhppv4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHb2KAajWVzsT3AwbMKoYqE6MhgllODuyfniBw9Lu59dlamXB2
	IDL/kQoxLsv7sscdreJ1PJda4+qTUBk+hcppgJK8C4ZB2HrJh2xv+3D/5BcpZWAO6Y6oZvrd9cd
	kFK/gkw==
X-Google-Smtp-Source: AGHT+IHPHoFCt0OdGLSJm5S3SSaQjefM37ka4yIBV1HYsyIu1JyRdfUA1VLCBXD1D2PGR5lTfTIjhoJ7N5E=
X-Received: from pjod1.prod.google.com ([2002:a17:90a:8d81:b0:33b:b692:47b0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:907:b0:295:6122:5c42
 with SMTP id d9443c01a7336-29b6becc972mr6327525ad.24.1763685320008; Thu, 20
 Nov 2025 16:35:20 -0800 (PST)
Date: Thu, 20 Nov 2025 16:35:18 -0800
In-Reply-To: <20251110033232.12538-7-kernellwp@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251110033232.12538-1-kernellwp@gmail.com> <20251110033232.12538-7-kernellwp@gmail.com>
Message-ID: <aR-zxrYATZ4rZZjn@google.com>
Subject: Re: [PATCH 06/10] KVM: Fix last_boosted_vcpu index assignment bug
From: Sean Christopherson <seanjc@google.com>
To: Wanpeng Li <kernellwp@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Paolo Bonzini <pbonzini@redhat.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Juri Lelli <juri.lelli@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Wanpeng Li <wanpengli@tencent.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Nov 10, 2025, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> From: Wanpeng Li <wanpengli@tencent.com>

Something might be off in your email scripts.  Speaking of email, mostly as an
FYI, your @tencent email was bouncing as of last year, and prompted commit
b018589013d6 ("MAINTAINERS: Drop Wanpeng Li as a Reviewer for KVM Paravirt support").

> In kvm_vcpu_on_spin(), the loop counter 'i' is incorrectly written to
> last_boosted_vcpu instead of the actual vCPU index 'idx'. This causes
> last_boosted_vcpu to store the loop iteration count rather than the
> vCPU index, leading to incorrect round-robin behavior in subsequent
> directed yield operations.
> 
> Fix this by using 'idx' instead of 'i' in the assignment.

Fixes: 7e513617da71 ("KVM: Rework core loop of kvm_vcpu_on_spin() to use a single for-loop")
Cc: stable@vger.kernel.org
Reviewed-by: Sean Christopherson <seanjc@google.com>

Please, please don't bury fixes like this in a large-ish series, especially in a
series that's going to be quite contentious and thus likely to linger on-list for
quite some time.  It's pretty much dumb luck on my end that I saw this.

That said, thank you for fixing my goof :-)

Paolo, do you want to grab this for 6.19?  Or just wait for 6.20?

> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  virt/kvm/kvm_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index b7a0ae2a7b20..cde1eddbaa91 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4026,7 +4026,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
>  
>  		yielded = kvm_vcpu_yield_to(vcpu);
>  		if (yielded > 0) {
> -			WRITE_ONCE(kvm->last_boosted_vcpu, i);
> +			WRITE_ONCE(kvm->last_boosted_vcpu, idx);
>  			break;
>  		} else if (yielded < 0 && !--try) {
>  			break;
> -- 
> 2.43.0
> 

