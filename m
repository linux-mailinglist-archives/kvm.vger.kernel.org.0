Return-Path: <kvm+bounces-22706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E0F894218C
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 22:25:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F0691C23E43
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 20:25:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4864918DF6D;
	Tue, 30 Jul 2024 20:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bnaI6vaV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F4C18A6D4
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 20:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722371093; cv=none; b=mVy/qn6TunRIMKF4gJROnJBb8pbSYwVR2n0J3+Y1N7R6OqS6E0bjaImhgxR7t8Qj08d/DQ+JoSi7674BHF4XftcAxphCIuVvQD8IIuPiR+qDBB5aV/WNWVXYMOocFcvXvfbWSseXm3lxYvm+ybT9db3INsltzWgrKqqeJzvDchc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722371093; c=relaxed/simple;
	bh=z7GWh0jTkNCHG+CucoLOogt/YnUgFnvIKYAlKOoO2gU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QAmItpFqSDyG/HONj/H8EyiGqRjdRpNaVAahFSxrc9g9pNHDkvhCqkH5mF6tMO8+5G/K064Cu3z4fIqgysa7bHX15n27VbtxDc8oX8BE3D0WpEnjV4h8b6VAs/PNghV2w8KHrdzn796ZDel4q1ZBGrSI7KI7zL80DO57fv2bhWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bnaI6vaV; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2cb5ba80e77so6192031a91.1
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 13:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722371091; x=1722975891; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7S3Oli6i7JzEF8SVo1JkM4Mpho9qGmQAiVdyShh3yxA=;
        b=bnaI6vaVgoSQZhI6xSFDA63Do2WIrkqSxndzYqvDzbgdl+TkkT8f9pJvRmtAvnw26W
         N71VnDK+GsvbYGczFfcmHxd0C+8Zz35zgzsZ68JwwI9TgtGntMIviQu6EjOu0b/ZnpLk
         HCYjLaIqj+VQYaXE7cBUnnWMtHmW+QpEKBLb1C3Yn9YrpVpu/jQgQHW5l9sAnXFHx1uv
         VB90IK+MPKg4sFzUrpbcyMHjb8m3EWymcSM3RvjThzHvjrNVIID8mCmLyEuAbUNQLDQN
         qG/f/8I1fQ1diVOEl/smNtwBIl1eOCS+6uX0C9cIHRWqK2tVHWfufyRTzFSkm3i6Dvt6
         Cb+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722371091; x=1722975891;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7S3Oli6i7JzEF8SVo1JkM4Mpho9qGmQAiVdyShh3yxA=;
        b=WUok1mgN2xa2n1oSu0aqh99eNi+2zXFDk/i/RCFxME10kr4H862bQ0kVGNW6RgfX/Y
         x4byND+QhNcqHOWPiuPd8+wvMcpwOiWFeP8l5mcwFpQk9+yWXjRi9ivpLVMNKmKrTGLH
         An/btMU/0DeRhhcC0yanPtNi1pKFI0v9xED9m9Jqoj1lHMai5xb75e7iiauqnaYDPncR
         +VU797OMouWLWlvTH6f3nbz2aI80b7fnPnWzQORUXke5T0fkjh4QsA7QJdjAjLI/w8+L
         nVF2xVY6cm7Au9CrEJQfvgOjyvHDpt3WtuxPhDkW7k2TkHvly6xd+A+ZcgyWWKdcXohd
         6jvQ==
X-Forwarded-Encrypted: i=1; AJvYcCX7Xt499vQ7/OtKJw1BwNv0XsHvgaDKRmXkmt6C6SuWzWnyKvGiv/Qv7Jp95+tcyZT1NWeQ5EOE/NgZPB1QBPSxXqht
X-Gm-Message-State: AOJu0YzZduDEEEUL7c/iT1qhrd17wIEcmQWyF6TxVpLw69JHpNOtq8Oa
	AnBL4x+uRMPVJIf+HTuEMmkonF54r2AJOZPNOt7zVMkwD5ayAZdQXpwiKouhXSveSWH7UWNnBEA
	JVQ==
X-Google-Smtp-Source: AGHT+IEPiHXtS314tlrQIAMbYrZnHsRms7BHYsbMaTjPiFclwHDMK7MPl03jGaRyUaHpVI56coh4fZoFV/g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:6803:b0:2c9:7d81:fb1f with SMTP id
 98e67ed59e1d1-2cf7e97a4d1mr361358a91.6.1722371090986; Tue, 30 Jul 2024
 13:24:50 -0700 (PDT)
Date: Tue, 30 Jul 2024 13:24:49 -0700
In-Reply-To: <Zqk5IqoQBnQbbuCK@AUS-L1-JOHALLEN.amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240730174751.15824-1-john.allen@amd.com> <ZqkqWTCa6GdeVykw@google.com>
 <Zqk5IqoQBnQbbuCK@AUS-L1-JOHALLEN.amd.com>
Message-ID: <ZqlMEehDfursUXSB@google.com>
Subject: Re: [PATCH] KVM: x86: Advertise SUCCOR and OVERFLOW_RECOV cpuid bits
From: Sean Christopherson <seanjc@google.com>
To: John Allen <john.allen@amd.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, thomas.lendacky@amd.com, 
	bp@alien8.de, mlevitsk@redhat.com, linux-kernel@vger.kernel.org, 
	x86@kernel.org, yazen.ghannam@amd.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 30, 2024, John Allen wrote:
> On Tue, Jul 30, 2024 at 11:00:57AM -0700, Sean Christopherson wrote:
> > On Tue, Jul 30, 2024, John Allen wrote:
> > > Handling deferred, uncorrected MCEs on AMD guests is now possible with
> > > additional support in qemu. Ensure that the SUCCOR and OVERFLOW_RECOV
> > > bits are advertised to the guest in KVM.
> > > 
> > > Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> > > Signed-off-by: John Allen <john.allen@amd.com>
> > > ---
> > >  arch/x86/kvm/cpuid.c   | 2 +-
> > >  arch/x86/kvm/svm/svm.c | 7 +++++++
> > >  2 files changed, 8 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > > index 2617be544480..4745098416c3 100644
> > > --- a/arch/x86/kvm/cpuid.c
> > > +++ b/arch/x86/kvm/cpuid.c
> > > @@ -1241,7 +1241,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
> > >  
> > >  		/* mask against host */
> > >  		entry->edx &= boot_cpu_data.x86_power;
> > > -		entry->eax = entry->ebx = entry->ecx = 0;
> > > +		entry->eax = entry->ecx = 0;
> > 
> > Needs an override to prevent reporting all of EBX to userspace.
> > 
> > 		cpuid_entry_override(entry, CPUID_8000_0007_EBX);
> 
> Right, I see what you mean. We just want to expose these specific bits
> and not all of EBX. I think with the patch as it is along with the
> change you suggest below, this should resolve this as the above case
> already has the cpuid_entry_override just above where it cuts off.

Heh, nope, it doesn't.  The existing override is for EDX, this needs one for EBX.

