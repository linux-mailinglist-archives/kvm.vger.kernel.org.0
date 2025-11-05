Return-Path: <kvm+bounces-62089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C5FBC36F03
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 18:08:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 520F76459D8
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 16:33:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86E78334C2B;
	Wed,  5 Nov 2025 16:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2JXTurZo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A0214F112
	for <kvm@vger.kernel.org>; Wed,  5 Nov 2025 16:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762360422; cv=none; b=r1BLArigkUyOkT8CJNtjqKiGraXDtlty0vwejmpNIZXNMe2YANlpfi26FeW+y75KYEIHqOruhA6HkNpUTr/gLaC8VGSGxkGx6vPfaE0qku5kCLQOm6QkADLIw6CbBg7J/dVytVnyOX+7DS2YxCVhDz1CB1vH5Tze5TYIIQecWhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762360422; c=relaxed/simple;
	bh=y8ahAV0PZEghI2naLgmQaNfd+dOSiqQChsbkdjIjE44=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pD0gMMZ4LvZlfsHwtOXhREgZfP0T2//efoASwz1QUR1xnNukCnqyNtbEb0xQKEISEyGTKSFKvbeEc3vqEU5JAizdUvbMk7T/g8wKCTu8zQRzMkbvK/HSuziMgWfd4qF9lSewM/VyGCZ+cVQ29FacXfKR7Cra+Sq7ficLDXF3hk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2JXTurZo; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33d75897745so406623a91.0
        for <kvm@vger.kernel.org>; Wed, 05 Nov 2025 08:33:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762360420; x=1762965220; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E+7k5zidXXcD+HatMzm349R3MQaUo0m1tgnERSfVu50=;
        b=2JXTurZoQ/1tr70rv09/BzfxoyaGkxBLmEf20pvVmOhs6OtUZI3kXqsxwQCIBcfWVU
         VCuhmWdVuYZM8qPCP2NzywF8J2pIWqyTMEdvVpqVBhdvxyRJKiDSDAPtSYaqjg8gDERU
         DFoa8By+4hJ3sDN5Hpne/4Ry1ymTIlYir7PHpwAAd9fjBNaG8AKJDlb08FQXBSeAkcRI
         Y7dx0ejnSLLBZ092mvmfZPDRsQTL7k7lc5ZGWBOsk4Zb5YjDQVHLq7R9QykqWv795B1i
         FAvJz3Wc0uQkQ3peLnnwSZX0FJV0kH2vYNOVP4vS0ZsILETmx4kYQONnHf2anhI58Nhg
         H67A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762360420; x=1762965220;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E+7k5zidXXcD+HatMzm349R3MQaUo0m1tgnERSfVu50=;
        b=YTVbTtRtt43xd1SXdIGqScnkgwLm03bartyqbG1AzQnsc7b+AarJvTAxPV93dNPOh5
         A56Qb79zb6vZZ2hsseyLKKzyfabR/ICcPxphLqLy3nTn9Oh64e51Wlv2KlSM8S2bvKrk
         hZl2IyGlPlzOXsNTS+sHWcq4gVakP8FvsQXhjC9vqfdlff6dwDgsNTLp06E5/9iDEiY1
         JtfmM1TIgfQG9mgiaXwBxZZLmeyY/DRbXkng4fg5++cZQwiMURUG2dtC2YvHt7532WP/
         /sYLfBCtE0UXWan1s0u/sKTY4sz9GQ0dvQNtBpmTCQNU/oBpHXYJthOLU3+075jJb6Ms
         7v6A==
X-Forwarded-Encrypted: i=1; AJvYcCXzqBNEYAvKhROb22c/EmJultMErC8vQKeu96JBPK8FIUObzw2w3BmOPRX4PrRLyqKQdbI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/LWmwJqu/7S8jeFGTHYP+1rr32DkT2+HxOxgPOoVR/znSUH+6
	7TOZkXjqHRukifYTXk9+oJQrXquoa+bKeLbAFtRiioozKECU2CZsWU11S0riwSlrstsAAdg7B8M
	4h3JrCw==
X-Google-Smtp-Source: AGHT+IHCE/7TNWD+0Bce75w45cojnDuYxEm5sQEcKUCO9oij2Cy9EVkqNqDCBx82s4XyrV0dcB8Ivh4jQnQ=
X-Received: from pjzs14.prod.google.com ([2002:a17:90b:70e:b0:33b:8aa1:75ed])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:350d:b0:33b:8ac4:1ac4
 with SMTP id 98e67ed59e1d1-341a7012c73mr4773216a91.35.1762360420430; Wed, 05
 Nov 2025 08:33:40 -0800 (PST)
Date: Wed, 5 Nov 2025 08:33:38 -0800
In-Reply-To: <cc6de4bfd9fbe0c7ac48b138681670d113d2475e.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250918162529.640943-1-jon@nutanix.com> <aNHE0U3qxEOniXqO@google.com>
 <7F944F65-4473-440A-9A2C-235C88672E36@nutanix.com> <B116CE75-43FD-41C4-BB3A-9B0A52FFD06B@nutanix.com>
 <aPvf5Y7qjewSVCom@google.com> <EFA9296F-14F7-4D78-9B7C-1D258FF0A97A@nutanix.com>
 <aQTxoX4lB_XtZM-w@google.com> <cc6de4bfd9fbe0c7ac48b138681670d113d2475e.camel@intel.com>
Message-ID: <aQt8Yoxea-goWrnR@google.com>
Subject: Re: [PATCH] KVM: x86: skip userspace IOAPIC EOI exit when Directed
 EOI is enabled
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "khushit.shah@nutanix.com" <khushit.shah@nutanix.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, 
	"bp@alien8.de" <bp@alien8.de>, Jon Kohler <jon@nutanix.com>, "hpa@zytor.com" <hpa@zytor.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 04, 2025, Kai Huang wrote:
> 
> [...]
> 
> 
> > KVM's bogus handling of Supress EOI Broad is problematic when the guest
> > relies on interrupts being masked in the I/O APIC until well after the
> > initial local APIC EOI.  E.g. Windows with Credential Guard enabled
> > handles interrupts in the following order:
> > 
> >  the interrupt in the following order:
> 
> This sentence is broken and is not needed.
> 
> >   1. Interrupt for L2 arrives.
> >   2. L1 APIC EOIs the interrupt.
> >   3. L1 resumes L2 and injects the interrupt.
> >   4. L2 EOIs after servicing.
> >   5. L1 performs the I/O APIC EOI.
> > 
> 
> [...]
> 
> > @@ -1517,6 +1518,18 @@ static void kvm_ioapic_send_eoi(struct kvm_lapic *apic, int vector)
> >  
> >  	/* Request a KVM exit to inform the userspace IOAPIC. */
> >  	if (irqchip_split(apic->vcpu->kvm)) {
> > +		/*
> > +		 * Don't exit to userspace if the guest has enabled Directed
> > +		 * EOI, a.k.a. Suppress EOI Broadcasts, in which case the local
> > +		 * APIC doesn't broadcast EOIs (the guest must EOI the target
> > +		 * I/O APIC(s) directly).  Ignore the suppression if userspace
> > +		 * has NOT disabled KVM's quirk (KVM advertised support for
> > +		 * Suppress EOI Broadcasts without actually suppressing EOIs).
> > +		 */
> > +		if ((kvm_lapic_get_reg(apic, APIC_SPIV) & APIC_SPIV_DIRECTED_EOI) &&
> > +		    apic->vcpu->kvm->arch.disable_suppress_eoi_broadcast_quirk)
> > +			return;
> > +
> 
> I found the name 'disable_suppress_eoi_broadcast_quick' is kinda confusing,
> since it can be interpreted in two ways:
> 
>  - the quirk is 'suppress_eoi_broadcast', and this boolean is to disable
>    this quirk.
>  - the quirk is 'disable_suppress_eoi_broadcast'.

I hear you, but all of KVM's quirks are phrased exactly like this:

  KVM_CAP_DISABLE_QUIRKS
  KVM_CAP_DISABLE_QUIRKS2
  KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK
  disable_slot_zap_quirk

> And in either case, the final meaning is KVM needs to "disable suppress EOI
> broadcast" when that boolean is true, 

No.  The flag says "Disable KVM's 'Suppress EOI-broadcast' Quirk", where the
quirk is that KVM always broadcasts even when broadcasts are supposed to be
suppressed.

> which in turn means KVM actually needs to "broadcast EOI" IIUC.  But the
> above check seems does the opposite.
> 
> Perhaps "ignore suppress EOI broadcast" in your previous version is better?

Hmm, I wanted to specifically call out that the behavior is a quirk.  At the
risk of being too verbose, maybe DISABLE_IGNORE_SUPPRESS_EOI_BROADCAST_QUIRK?

And then to keep line lengths sane, grab "kvm" locally so that we can end up with:

	/* Request a KVM exit to inform the userspace IOAPIC. */
	if (irqchip_split(kvm)) {
		/*
		 * Don't exit to userspace if the guest has enabled Directed
		 * EOI, a.k.a. Suppress EOI Broadcasts, in which case the local
		 * APIC doesn't broadcast EOIs (the guest must EOI the target
		 * I/O APIC(s) directly).  Ignore the suppression if userspace
		 * has NOT disabled KVM's quirk (KVM advertised support for
		 * Suppress EOI Broadcasts without actually suppressing EOIs).
		 */
		if ((kvm_lapic_get_reg(apic, APIC_SPIV) & APIC_SPIV_DIRECTED_EOI) &&
		    kvm->arch.disable_ignore_suppress_eoi_broadcast_quirk)
			return;

> Also, IIUC the quirk only applies to userspace IOAPIC, so is it better to
> include "split IRQCHIP" to the name?  Otherwise people may think it also
> applies to in-kernel IOAPIC.

Eh, I'd prefer to solve that through documentation and comments.  The name is
already brutally long.
 
> Btw, personally I also found "directed EOI" is more understandable than
> "suppress EOI broadcast".  How about using "directed EOI" in the code
> instead?  E.g.,
> 
>  s/disable_suppress_eoi_broadcast/disable_directed_eoi
>  s/KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST/KVM_X2APIC_DISABLE_DIRECTED_EOI
> 	
> It is shorter, and KVM is already using APIC_LVR_DIRECTED_EOI anyway.

It's also wrong.  Directed EOI is the I/O APIC feature, the local APIC (CPU)
feature is "Suppress EOI-broadcasts" or "EOI-broadcast suppression".  Conflating
those two features is largely what led to this mess in the first place, so I'd
strongly prefer not to bleed that confusion into KVM's uAPI.

