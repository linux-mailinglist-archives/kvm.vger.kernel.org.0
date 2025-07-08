Return-Path: <kvm+bounces-51774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79948AFCDD5
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 16:38:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8BD03482637
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 14:37:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AE242DECB4;
	Tue,  8 Jul 2025 14:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Arum+Yy8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F5F223DDD
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 14:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751985434; cv=none; b=M9VK0JpXXALp7Q2KFgyrB3iIOVdYA2JKlWB1imaIgDow61Yzkvrpk4JH3ijo6++ojh+Znn1ggc0QQzdIWKcGshSqZbcaRQ8Xft+1R/YPx5BVAFwhxCpNOj3buVoXQ5fo+kt+aSsWbsHWWWnrpWXbyypcbk7Xl3a4LQN0pPKnpNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751985434; c=relaxed/simple;
	bh=kLDmLW0i8VTZ3UXPuyNLfg15+1/PDr9DpXKxRYPwAGc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AhVI+Yk6l2qZUbKUHT2AwqbM/RawAbCv9I9pFMDw85Bc2fduda5E2I5SwQIDvDxIm8axdlYBAgRZM6173SCZOvDFx5hB2Xc1u4ylSuD4ozKJ7x0MSfn93NsRIY7jNYQw65hBwN7rF7cVuU1FkcEdvftzT08BhY/z9GuZ9JtGZBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Arum+Yy8; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-23689228a7fso60473365ad.1
        for <kvm@vger.kernel.org>; Tue, 08 Jul 2025 07:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751985432; x=1752590232; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CSr9DnGC0U+Ld1MVeE/odpdQ4lfNnPFU9ZNv9t6sQpk=;
        b=Arum+Yy87asJgChhwKW0mtnB8f55Ioojnd+ay8qlCFlNFyAmoxtQcJNPb4rBaG6bI1
         QaZJoZkimefeMpO7lWMy0xZvt3ZNRpo/YZzpe35aebqdebCYvaJw1/BoSZAyEVq7fE7A
         Pw20KaGOryIX1N5kNiLI7AZfyBNaOFLoUliom8Jmowsdmz1w/M5FSNGoej2Sx3H68pgJ
         MCSzO5Dp6P75OgseXXfwPNQU76xS2MoJBhfioSnSAWDdSp46OJ7G6yDPBj3aUuFKtycc
         UBZpHtZG8oZOMptdXBjYBLpfGrIdHPwRUhS71sSq1NAXE60y+9GkVEQ4xOaSqnsxJ5gM
         z4ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751985432; x=1752590232;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CSr9DnGC0U+Ld1MVeE/odpdQ4lfNnPFU9ZNv9t6sQpk=;
        b=nLtjLu3K//zoWkhHMa8XkmL6HggF+TJDJL920wVBOz7sJnQ3GqHUhUOpEz1uWlo8g8
         ia/sDWMIVDQdKukTEoJ61ognO8HudN/7G4FQc4mk9/jLvxQ3yIA63GWp2nPIze+6gvcP
         AbTjg0XEW7l8S/t+tFhfFrel9++4DBlMJ0//8qJqs0vKm/0iy8zzYcJXOEFsErO2aHOv
         YrEDH1PyxYFPVeMLRDDe2DUq0+lobIbuEahrvbkivRuQiPmpB3wTRCDxMj41BxZ+eOO0
         eRNM6WsZ3v3o4VJgWCYpz9CRP6Cwh+8k9zrMck8byKmxkEOhYbkUkERV57kRe3NjZQWB
         xxug==
X-Forwarded-Encrypted: i=1; AJvYcCXFG6os1uktyWaoXGm6j6RJ99r7qiU4UjRsHC5Jw9E+8uuxRbpH+81PLjdqL1KvLtisO8o=@vger.kernel.org
X-Gm-Message-State: AOJu0YwptNJ4ry7S7gXVGRXit3GDpr5csIZ+KNOVmfFEFmb4vGWbta0K
	np+l9nxr45awGrdS4XirKiGEe0R5ryHthWIMMbgjjUgtPx4D84blttdN8cVrvAdCgjDFh2kvl1B
	Zu3W5HQ==
X-Google-Smtp-Source: AGHT+IHL5BLmNe8HQ8sUJcUtqOgA4+QupQWiYZFvsZZxYR10RLA26WOSa/tnxreZzc7IJ6XfjLE8If7qRsA=
X-Received: from plsl15.prod.google.com ([2002:a17:903:244f:b0:234:c2e4:1df6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:dac8:b0:236:363e:55d
 with SMTP id d9443c01a7336-23dd1d2eb19mr45240215ad.28.1751985432367; Tue, 08
 Jul 2025 07:37:12 -0700 (PDT)
Date: Tue, 8 Jul 2025 07:37:10 -0700
In-Reply-To: <20250707101029.927906-3-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250707101029.927906-1-nikunj@amd.com> <20250707101029.927906-3-nikunj@amd.com>
Message-ID: <aG0tFvoEXzUqRjnC@google.com>
Subject: Re: [PATCH v8 2/2] KVM: SVM: Enable Secure TSC for SNP guests
From: Sean Christopherson <seanjc@google.com>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, thomas.lendacky@amd.com, 
	santosh.shukla@amd.com, bp@alien8.de, isaku.yamahata@intel.com, 
	vaishali.thakkar@suse.com, kai.huang@intel.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Jul 07, 2025, Nikunj A Dadhania wrote:
> Introduce the read-only MSR GUEST_TSC_FREQ (0xc0010134) that returns
> guest's effective frequency in MHZ when Secure TSC is enabled for SNP
> guests. Disable interception of this MSR when Secure TSC is enabled. Note
> that GUEST_TSC_FREQ MSR is accessible only to the guest and not from the
> hypervisor context.

...

> @@ -4487,6 +4512,9 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
>  
>  	/* Can't intercept XSETBV, HV can't modify XCR0 directly */
>  	svm_clr_intercept(svm, INTERCEPT_XSETBV);
> +
> +	if (snp_secure_tsc_enabled(svm->vcpu.kvm))
> +		svm_disable_intercept_for_msr(&svm->vcpu, MSR_AMD64_GUEST_TSC_FREQ, MSR_TYPE_RW);

KVM shouldn't be disabling write interception for a read-only MSR.  And this
code belongs in sev_es_recalc_msr_intercepts().

