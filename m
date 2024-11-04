Return-Path: <kvm+bounces-30574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AA7589BC10C
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 23:43:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DBB371C21325
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 22:43:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 904051FDF89;
	Mon,  4 Nov 2024 22:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0/ga0r5E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462381FC3
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 22:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730760216; cv=none; b=jJgMl8Q1qXR1BdqDW9oJtwL4vDBHKg+RHZM7z3/QPqGeGzthwU5fgm/kxl3KT7922YIqKClLPTmg7wml+La1crc604sQtSYSn5cvvInSlF5p/MQtcZm7pDDKJpWzF+/zfJDjAWbwNFLXvK8VknX67UCPWaU2NWfki5M3/DujN0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730760216; c=relaxed/simple;
	bh=dBuFx1kas3MmeCLSh3pX1AAR5U67vWtV6d6/Sqj8lcY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qWffhjqSkG3gyLw74frZH+nefSuHIXeTKvOGPqil/3UUfQ25QWAflnk6IPyraPsbFOW1ZVhhZryI07nIcWCgnt1KQkyI/bOkyAw6zowJ3r0zcsdXCXO0KRQJe4WYKAYutY85tmNWw041pWCR2tnqkCAVI9O929rIGKH5rdwAbPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0/ga0r5E; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-20cc1fddb87so48391735ad.0
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2024 14:43:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730760214; x=1731365014; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ls6gLEGZJHNa8T853PAtOKqHMNuKb0zzrscI5tJvK7E=;
        b=0/ga0r5EQRBVvlUENvPmcmrFiFpFY1yG7N8grmCd6Ctp1YGkk1L47m9ppYlETeaKvx
         W5v9e7mxD5bFhpV2JyMyu2iLfhJ+cI3aeaZoVBd5nEccDt0v8ntaQRaE8Bwd3aD2wdu6
         PPoxK6GbIvKhWvA5SMimbzZ7KgK5Ffq6QKyzE7pO94SC6a6aOIEmZ2hgjKFiZH9x889L
         OZXGzhrsS34PmjY0pBiDaIjWMwqMr9bvEzSflLSKgjj4vBijg1lWIhgnQtj09gSPzUOF
         TcapOYR6ihuXMr+qumZ9fOFFZh9jVyar0Mx5YvBJaRPtHvDWl+SFW8Zu0Z4wNJs2QJiu
         Bedg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730760214; x=1731365014;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ls6gLEGZJHNa8T853PAtOKqHMNuKb0zzrscI5tJvK7E=;
        b=SrCJVZtSvRgSBSTKiDKJ8L4FvrIujdZwQF9pybAUWfepaf3Ib+yq/wRpmv5SOF0akN
         17UAyW1OAvLSS3BvjbhZdvG5NfEn3XYDbjans8ZYbYm68inV81xE0rA55paCGT0J9mOg
         CUL8k/QgD5562XBr6g351cj3pM81DDJ77WnLeFrHJT6n6TlH3lo1FlsuGaCI6OApuKhN
         yN6HcAXb2KaVVrg4l/nAed1XQqmwY7dmDYoKRTtx7JX/QZKTkXbx/EbKCDVfjnlY0p25
         7MlnMCFG5ziADvqHtK6S3Bys0TL5dW4G7Zhg7LYYLSKozoc1dOChKhMD4zFGT4HGNaxm
         Fj5Q==
X-Forwarded-Encrypted: i=1; AJvYcCVGeqt62mbir8QdDtTspzbQiWVrIYMkvk/h8tPK9uwwwehRXwhegJnpQYsDsHVDfZItyL4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzUlBtRqu2FAx38zmZEMm0iQC2I5c+Q13vJWzROH9/9fIiTuMUG
	SVo8CZdTEHBS2UwcbgyDoXeREt0spAq786BpjJOx0sOUtcryn9P17CgV8mX8hFyVXru0KLRLWV6
	z3Q==
X-Google-Smtp-Source: AGHT+IEOZzy++cNTt7i7Bx5tmChi1y4G9l1WKuA0Im1d0mKgOa5auUlJsLselILXuxd11jZmv25S3Gq4O8A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:902:fcc6:b0:20c:7d4c:64d1 with SMTP id
 d9443c01a7336-21103b326f0mr156315ad.5.1730760214612; Mon, 04 Nov 2024
 14:43:34 -0800 (PST)
Date: Mon, 4 Nov 2024 14:43:33 -0800
In-Reply-To: <Zyh3wsWVvP2V2fNQ@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241101192114.1810198-1-seanjc@google.com> <20241101192114.1810198-2-seanjc@google.com>
 <Zyh3wsWVvP2V2fNQ@intel.com>
Message-ID: <ZylOFcayR3lMZdGA@google.com>
Subject: Re: [PATCH 1/2] KVM: x86: Plumb in the vCPU to kvm_x86_ops.hwapic_isr_update()
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"Markku =?utf-8?Q?Ahvenj=C3=A4rvi?=" <mankku@gmail.com>, Janne Karhunen <janne.karhunen@gmail.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Nov 04, 2024, Chao Gao wrote:
> On Fri, Nov 01, 2024 at 12:21:13PM -0700, Sean Christopherson wrote:
> >Pass the target vCPU to the hwapic_isr_update() vendor hook so that VMX
> >can defer the update until after nested VM-Exit if an EOI for L1's vAPIC
> >occurs while L2 is active.
> >
> >No functional change intended.
> >
> >Cc: stable@vger.kernel.org
> >Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> Reviewed-by: Chao Gao <chao.gao@intel.com>
> 
> >---
> > arch/x86/include/asm/kvm_host.h |  2 +-
> > arch/x86/kvm/lapic.c            | 11 +++++------
> > arch/x86/kvm/vmx/vmx.c          |  2 +-
> > arch/x86/kvm/vmx/x86_ops.h      |  2 +-
> > 4 files changed, 8 insertions(+), 9 deletions(-)
> >
> >diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> >index 70c7ed0ef184..3f3de047cbfd 100644
> >--- a/arch/x86/include/asm/kvm_host.h
> >+++ b/arch/x86/include/asm/kvm_host.h
> >@@ -1734,7 +1734,7 @@ struct kvm_x86_ops {
> > 	bool allow_apicv_in_x2apic_without_x2apic_virtualization;
> > 	void (*refresh_apicv_exec_ctrl)(struct kvm_vcpu *vcpu);
> > 	void (*hwapic_irr_update)(struct kvm_vcpu *vcpu, int max_irr);
> >-	void (*hwapic_isr_update)(int isr);
> >+	void (*hwapic_isr_update)(struct kvm_vcpu *vcpu, int isr);
> > 	void (*load_eoi_exitmap)(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
> > 	void (*set_virtual_apic_mode)(struct kvm_vcpu *vcpu);
> > 	void (*set_apic_access_page_addr)(struct kvm_vcpu *vcpu);
> >diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> >index 65412640cfc7..5be2be44a188 100644
> >--- a/arch/x86/kvm/lapic.c
> >+++ b/arch/x86/kvm/lapic.c
> >@@ -763,7 +763,7 @@ static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
> > 	 * just set SVI.
> > 	 */
> > 	if (unlikely(apic->apicv_active))
> >-		kvm_x86_call(hwapic_isr_update)(vec);
> >+		kvm_x86_call(hwapic_isr_update)(apic->vcpu, vec);
> 
> Both branches need braces here. So, maybe take the opportunity to fix the
> coding style issue.

Very tempting, but since this is destined for stable, I'll go with a minimal patch
to reduce the odds of creating a conflict.

> > 	else {
> > 		++apic->isr_count;
> > 		BUG_ON(apic->isr_count > MAX_APIC_VECTOR);
> >@@ -808,7 +808,7 @@ static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
> > 	 * and must be left alone.
> > 	 */
> > 	if (unlikely(apic->apicv_active))
> >-		kvm_x86_call(hwapic_isr_update)(apic_find_highest_isr(apic));
> >+		kvm_x86_call(hwapic_isr_update)(apic->vcpu, apic_find_highest_isr(apic));

