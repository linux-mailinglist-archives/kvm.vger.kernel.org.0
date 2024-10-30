Return-Path: <kvm+bounces-30075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D0FE9B6C22
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 19:31:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6FA061C212ED
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 18:31:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 906AB1CC152;
	Wed, 30 Oct 2024 18:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WtwL+E2H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0B5199EB0
	for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 18:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730313067; cv=none; b=cPcrpWRNcUy2ObaKV9tHVHyWLpMNOAFYFODPCofjlXj0KAbMiJuERcxwmaELJBoaZvPW0spnA6F2o68R5XCOubg8HvwGrUdIFow7iUmxsArwuiYvOGHyA0fShWhbfeoAzIAw9zBPQ4M22AnxKjn1rpSdtShKfrIFarbqA3zvC4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730313067; c=relaxed/simple;
	bh=f4Hh7vN94Nq9D8h5k+Qg45iUuRjY2qYGN0SVWvkYIAg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Jsn0xTV2RcSz+aC1XCW8B+T6qZonBkum3O7Tr1NspI/txUVUJthBHwPCd9ducD5VUs/T9BQBFehXtFZve6V5JsTmzCtAgNPKbn617hDDO20JPAwWepcGGi6oi7taMT1HQyew2RiiGlfpZu52KMSTsXpmlqBnkOZo5sbhLERb5sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WtwL+E2H; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e30b8fd4ca1so233292276.3
        for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 11:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730313064; x=1730917864; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=50yPfM6OH510xCsxuN9NczYJt5kzLejuCnsg8xqGZ6s=;
        b=WtwL+E2HmQ2jDNllJLJasfbDb0FLos/2J4p4/RJCYlts9/Q1uec1sBmCWaeyWqZPKR
         TjC6NLnf4HD0EJJcZaokBel5OU6esq2v8u93QWVl1NhTsA7zt7Z8V1VAtX2WN1fzHR46
         OjIDBjzwrH8IRskFhylQ7bWeHZO+N/7bHa4TzoP0hBdvp8AliRtlNb//igcowLXUTyam
         dwF4Iu7hA1RUQD2PQzmxBWY5GnWYCuuHxnf76vtk0Pp6E19Nu/tXZ7UxmY7NIuPKidX4
         KSuiK14brlNdf96pjabm9vVmWqoYBsxmwDuZ5pHAhoxj3jyFg8XG2VyrmDOiGKFv4zQ4
         tXIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730313064; x=1730917864;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=50yPfM6OH510xCsxuN9NczYJt5kzLejuCnsg8xqGZ6s=;
        b=FFLNhrVUsYHpeNT6zX5SWFUtpX9lJTE/rwVb/dKJSaQUWpyKDNm4AmwuTAuyH43YYM
         QFdUQiGJMAYo0cuqk7W4E5m45RSBTClUBFbQ9SDMkZumm1EVhHlVwh5fiTrSZxkXfAn9
         Njkaj1m3mzzt9XMEx7spWSjuAyfTnlcaKurTea7XtXHEJrQClbj9Rp/nemneOUdNz3Br
         EwzouF4qtJVrMvjNk8T6+gZKyja/Dw3yOxL2HkOGbDt2OsYOuPIadc9vgBcLFM6KEB/d
         avQ+gGKoByZOVAJemQ1KOiW9P7djqOrF1mp2D8LuCp+hB8GwI5zD4PPZsLaifEJcA2aK
         1SeQ==
X-Forwarded-Encrypted: i=1; AJvYcCX26x+fdrqwwdJ2MEt7LaPfBhnotwkg9w1CEdg2ueAAmiLHjwf1Wi9zTgDSfFm03Th6dCE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6ZHUDO2uUUKq7aBhCEmSrWzTHHrJrbZNkdR2oqM87w49yUtcI
	5HVwJPcb6ujITj5zlOOjHDAUpDMWwJhIuOItC+/rWl0VjrUbUa9GFs2a4uqEbPajvobb3yQRNnA
	ZOw==
X-Google-Smtp-Source: AGHT+IGW5u3xFoj/h+E5iifP/nLVx40EYSCLbJjRQfF/WkwvKCfEc/UlpTcS1r/wS3YYzc8sxq8qbSqwDxc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6902:181e:b0:e28:fdfc:b788 with SMTP id
 3f1490d57ef6-e30cf4d455bmr2894276.9.1730313064088; Wed, 30 Oct 2024 11:31:04
 -0700 (PDT)
Date: Wed, 30 Oct 2024 11:31:02 -0700
In-Reply-To: <20241023124527.1092810-1-alexyonghe@tencent.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241023124527.1092810-1-alexyonghe@tencent.com>
Message-ID: <ZyJ7ZsP4RaRfcFQF@google.com>
Subject: Re: [PATCH] KVM: x86: Try to enable irr_pending state with disabled APICv
From: Sean Christopherson <seanjc@google.com>
To: Yong He <zhuangel570@gmail.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, wanpengli@tencent.com, 
	alexyonghe@tencent.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 23, 2024, Yong He wrote:
> From: Yong He <alexyonghe@tencent.com>
> 
> Try to enable irr_pending when set APIC state, if there is
> pending interrupt in IRR with disabled APICv.
> 
> In save/restore VM scenery with disabled APICv. Qemu/CloudHypervisor
> always send signals to stop running vcpu threads, then save
> entire VM state, including APIC state. There may be a pending
> timer interrupt in the saved APIC IRR that is injected before
> vcpu_run return. But when restoring the VM, since APICv is
> disabled, irr_pending is disabled by default, so this may cause
> the timer interrupt in the IRR to be suspended for a long time,
> until the next interrupt comes.
> 
> Signed-off-by: Yong He <alexyonghe@tencent.com>
> ---
>  arch/x86/kvm/lapic.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 2098dc689088..7373f649958b 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -3099,6 +3099,10 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
>  						apic_find_highest_irr(apic));
>  		kvm_x86_call(hwapic_isr_update)(apic_find_highest_isr(apic));
>  	}
> +
> +	/* Search the IRR and enable irr_pending state with disabled APICv*/
> +	if (!enable_apicv && apic_search_irr(apic) != -1)

This can/should be an "else" from the above "if (apic->apicv_active)".  I also
think KVM can safely clear irr_pending in this case, which is also why irr_pending
isn't handling in kvm_apic_update_apicv().  When APICv is disabled (inhibited) at
runtime, an IRQ may be in-flight, i.e. apic_search_irr() can get a false negative.

But when stuffing APIC state, I don't see how that can happen.  So this?

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 65412640cfc7..deb73aea2c06 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -3086,6 +3086,15 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
                kvm_x86_call(hwapic_irr_update)(vcpu,
                                                apic_find_highest_irr(apic));
                kvm_x86_call(hwapic_isr_update)(apic_find_highest_isr(apic));
+       } else {
+               /*
+                * Note, kvm_apic_update_apicv() is responsible for updating
+                * isr_count and highest_isr_cache.  irr_pending is somewhat
+                * special because it mustn't be cleared when APICv is disabled
+                * at runtime, and only state restore can cause an IRR bit to
+                * be set without also refreshing irr_pending.
+                */
+               apic->irr_pending = apic_search_irr(apic) != -1;
        }
        kvm_make_request(KVM_REQ_EVENT, vcpu);
        if (ioapic_in_kernel(vcpu->kvm))

> +		apic->irr_pending = true;
>  	kvm_make_request(KVM_REQ_EVENT, vcpu);
>  	if (ioapic_in_kernel(vcpu->kvm))
>  		kvm_rtc_eoi_tracking_restore_one(vcpu);
> -- 
> 2.43.5
> 

