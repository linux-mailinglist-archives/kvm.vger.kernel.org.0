Return-Path: <kvm+bounces-50837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A764AE9FBC
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 16:02:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F3C81175DC1
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 14:02:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4CF32E7645;
	Thu, 26 Jun 2025 14:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZJKSdpxA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956F828B3EE
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 14:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750946524; cv=none; b=VB6XWxEn5v7SI63tA25FrYEqomoiG7NjAzfh/rOP/2xcsAY9XGaUUCWbBnuz9iBmJ/1c+D1d9gGOKgLaFIxKJz9mkIU6MKqsvu9aUdu3WX2eSXayMHkooO5RGyGasRufh9kvwPKcuTuHCDNIhPtG7xp1FgI8RdPGAHlC+WApg0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750946524; c=relaxed/simple;
	bh=h0XSD/BWdf0Qvtb5azjopNJatE0mUQK8ebE7L+3nV2Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MAltYCwWMwBus/Hz/F8MkO+jfTcz43eDn9+Gxq5vlWuP+P24SFgWtL36tKzDcHeB8syIvSzOt30motdrPioRCaDEWAHN81T5qRUSA1izxG2esYt+KpAcTrFhx/Z2oEBwsNjct/Ostp52p70NNtkGfnLcA8JiLZ7IhwlUaCnMjk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZJKSdpxA; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-748f3d4c7e7so936102b3a.3
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 07:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750946522; x=1751551322; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fMo1zXBi4ABASxAn7/TUa/oHB3Dd2INFCXK5oGhevGw=;
        b=ZJKSdpxAxCpw9IBq2uuL4pV7rhGG4Hbe0Q63aiZkCpjQ6XJeN4kHx+WECc1e+5HjGt
         D/0uCj93VOfBRYqOLtww3P1iZndIswXk9sm/SNbQZGO5XV0TSkcjU+PP3gO/wF0dxK/e
         cJiksiAPqmzpnU9J7psr/ivn0kSQg17S6eBiV1CIfvaaPUaNqU8YsnZ5VFZjFeQr0eJg
         99bfFmj+ORHGtOuSrsp7nksGXMq14gFiVefOO5l0FkC8QSSfEJIRd+jWXuAJfcw8FSWr
         oLAc5R/1egZdhcjV6tKCDOte+HkuT46wfVpVe7gavLhTEsl9nHCIzcPgsbY1uLQJwZXB
         lXMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750946522; x=1751551322;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fMo1zXBi4ABASxAn7/TUa/oHB3Dd2INFCXK5oGhevGw=;
        b=erR79Vb3hGBS4oFip28Uk2cNMsIz5xH09E9PIWNyTVHOixz7jaUdP81TMaV2oZM1+j
         PR5eUSabTyZCX0lSzaAal3JA2E3u0pjm7Pq4LpX7teJ/WqLdb5S2uhIqM4XQOKTnnoTf
         ywyoZkcXqMIXzBL+MxbUpeXzmcz90Jee97AeMwiP49APxhbnpj4YIOePla3ROWOc1DbO
         7Ugj51kdQq5VSMOqDsqQY2BVwKs3Aablk00zIB3drqqOOikOwsfn3RHvC3AVFro4EcKw
         NT0vrGVjZ2nt3i5QSMuzy/YLGm60PXO0hNr15GeDbL+AvXWPrvP7ga0K9TrHI3S/Xe5c
         kyOg==
X-Forwarded-Encrypted: i=1; AJvYcCXEP7sFtnpoen3/kkfrGZK7u5CKxKVZqm36+MTnlxmEIPzEwUjkGM8m89cz2oTHmIc85Pg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCZbk16gTALJak2/K9XsBAUp0RjBmksEDdWWH3dlL/5qvQjtF8
	VXz/M+neP9fNrkQKtdQe8N3HKGw/8UbrXjnGjoeX7gl3dKl+0ci4OtyDYdtLEmoZ2sCZn+MO+bp
	//C7wVA==
X-Google-Smtp-Source: AGHT+IE0OwgFZSmj4Dy27VJpNnAoCNiBcct4nDUkJRChXD5EOM0LPAX9MmgV2AVIdkZFX/GLYU25c0jZ5wI=
X-Received: from pgbdm12.prod.google.com ([2002:a05:6a02:d8c:b0:b31:be7c:3c6b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:43a4:b0:1f3:418d:91b5
 with SMTP id adf61e73a8af0-2207f28b435mr12186153637.24.1750946521935; Thu, 26
 Jun 2025 07:02:01 -0700 (PDT)
Date: Thu, 26 Jun 2025 07:02:00 -0700
In-Reply-To: <20250626125720.3132623-1-alexandre.chartre@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250626125720.3132623-1-alexandre.chartre@oracle.com>
Message-ID: <aF1S2EIJWN47zLDG@google.com>
Subject: Re: [PATCH] kvm/x86: ARCH_CAPABILITIES should not be advertised on AMD
From: Sean Christopherson <seanjc@google.com>
To: Alexandre Chartre <alexandre.chartre@oracle.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, pbonzini@redhat.com, 
	xiaoyao.li@intel.com, x86@kernel.org, konrad.wilk@oracle.com, 
	boris.ostrovsky@oracle.com, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"

+Jim

For the scope, "KVM: x86:"

On Thu, Jun 26, 2025, Alexandre Chartre wrote:
> KVM emulates the ARCH_CAPABILITIES on x86 for both vmx and svm.
> However the IA32_ARCH_CAPABILITIES MSR is an Intel-specific MSR
> so it makes no sense to emulate it on AMD.
> 
> The AMD documentation specifies that this MSR is not defined on
> the AMD architecture. So emulating this MSR on AMD can even cause
> issues (like Windows BSOD) as the guest OS might not expect this
> MSR to exist on such architecture.
> 
> Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
> ---
> 
> A similar patch was submitted some years ago but it looks like it felt
> through the cracks:
> https://lore.kernel.org/kvm/20190307093143.77182-1-xiaoyao.li@linux.intel.com/

It didn't fall through the cracks, we deliberately elected to emulate the MSR in
common code so that KVM's advertised CPUID support would match KVM's emulation.

  On Thu, 2019-03-07 at 19:15 +0100, Paolo Bonzini wrote:
  > On 07/03/19 18:37, Sean Christopherson wrote:
  > > On Thu, Mar 07, 2019 at 05:31:43PM +0800, Xiaoyao Li wrote:
  > > > At present, we report F(ARCH_CAPABILITIES) for x86 arch(both vmx and svm)
  > > > unconditionally, but we only emulate this MSR in vmx. It will cause #GP
  > > > while guest kernel rdmsr(MSR_IA32_ARCH_CAPABILITIES) in an AMD host.
  > > > 
  > > > Since MSR IA32_ARCH_CAPABILITIES is an intel-specific MSR, it makes no
  > > > sense to emulate it in svm. Thus this patch chooses to only emulate it
  > > > for vmx, and moves the related handling to vmx related files.
  > > 
  > > What about emulating the MSR on an AMD host for testing purpsoes?  It
  > > might be a useful way for someone without Intel hardware to test spectre
  > > related flows.
  > > 
  > > In other words, an alternative to restricting emulation of the MSR to
  > > Intel CPUS would be to move MSR_IA32_ARCH_CAPABILITIES handling into
  > > kvm_{get,set}_msr_common().  Guest access to MSR_IA32_ARCH_CAPABILITIES
  > > is gated by X86_FEATURE_ARCH_CAPABILITIES in the guest's CPUID, e.g.
  > > RDMSR will naturally #GP fault if userspace passes through the host's
  > > CPUID on a non-Intel system.
  > 
  > This is also better because it wouldn't change the guest ABI for AMD
  > processors.  Dropping CPUID flags is generally not a good idea.
  > 
  > Paolo

I don't necessarily disagree about emulating ARCH_CAPABILITIES being pointless,
but Paolo's point about not changing ABI for existing setups still stands.  This
has been KVM's behavior for 6 years (since commit 0cf9135b773b ("KVM: x86: Emulate
MSR_IA32_ARCH_CAPABILITIES on AMD hosts"); 7 years, if we go back to when KVM
enumerated support without emulating the MSR (commit 1eaafe91a0df ("kvm: x86:
IA32_ARCH_CAPABILITIES is always supported").

And it's not like KVM is forcing userspace to enumerate support for
ARCH_CAPABILITIES, e.g. QEMU's named AMD configs don't enumerate support.  So
while I completely agree KVM's behavior is odd and annoying for userspace to deal
with, this is probably something that should be addressed in userspace.

> I am resurecting this change because some recent Windows updates (like OS Build
> 26100.4351) crashes on AMD KVM guests (BSOD with Stop code: UNSUPPORTED PROCESSOR)
> just because the ARCH_CAPABILITIES is available.
> 
> ---
>  arch/x86/kvm/svm/svm.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index ab9b947dbf4f..600d2029156e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5469,6 +5469,9 @@ static __init void svm_set_cpu_caps(void)
>  
>  	/* Don't advertise Bus Lock Detect to guest if SVM support is absent */
>  	kvm_cpu_cap_clear(X86_FEATURE_BUS_LOCK_DETECT);
> +
> +	/* Don't advertise ARCH_CAPABILITIES on AMD */
> +	kvm_cpu_cap_clear(X86_FEATURE_ARCH_CAPABILITIES);

Strictly speaking, I think we'd want to update svm_has_emulated_msr() as well.

>  }
>  
>  static __init int svm_hardware_setup(void)
> -- 
> 2.43.5
> 

