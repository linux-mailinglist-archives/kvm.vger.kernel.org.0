Return-Path: <kvm+bounces-29091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5EF29A27EF
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 18:05:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F8EA2822C0
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 16:05:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 477AF1DEFD7;
	Thu, 17 Oct 2024 16:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NgHglzpn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D0C1DE2A6
	for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 16:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729181111; cv=none; b=rTM4+cwXDUN9hpqInBuAmOB5372H7tLcInbIUW+UatC3lMp8MNSyLDJrZh7ARm7TIMGQGWBgGpYzrws6ikJ1tRrjZvm3My6wf5Yu3qYy5p/71FuCTsub6eBsEtz+NslfX6hrruHzHysmzSTFGfHSVVcjGC4pddS5V01MZdeUrb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729181111; c=relaxed/simple;
	bh=7iSCUy4hsd7mlFixKAw5QSrayk3PCs1zC5I7vexFMBk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k0xpsX1U4VAd46GWA2rvyyG1LOZKPOX1Z64LfXczzl8/euzffTxlQJQs6PIieDXqvxqRHmrt+4QLJ0vDiohd2+Za/po4YyCbxtLwXEQBG6KXuu2nj66YSFX7BORjEVdtxA+gqNkMlLPbYZ56YecRULAVk9Zidbm3MGOXZ53xFs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NgHglzpn; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7e9b2d75d6dso843274a12.1
        for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 09:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729181109; x=1729785909; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uPGvpskT3qQS7A2X2wMCHyl1PllSmHhCFZoJsQqYtGE=;
        b=NgHglzpnPcgECbl64vItt0Ii+BbdB8ehHUTYLafIp3KvKJQMbRBfVIUIQJCHh6AXjj
         MH3ZvdVnxe3QcF0LuE3kc25fcN/ypKnF6SkXvJHaOsrEUyDYywj9WpXlHuRqi/mFPa/g
         mRmNHmHdtFjleFKiSKamxBrLu7P5IHSbh3Tby35p8LS/y2zdMQoUk1BUu+jR9XJsGddw
         SBxgSA9wcQ4NXz+tDT08dmJAxkZbrR/0KzGqzJy4PAzl6t8zdgTIAUyBJEHdbgyQ+unG
         LUtUUX979FhHYfIKLUysmLrgqpjAMmP6PKsNaKyAD/vF3hu7yMClVL4Hdz+zs/0ib1+M
         9Y+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729181109; x=1729785909;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uPGvpskT3qQS7A2X2wMCHyl1PllSmHhCFZoJsQqYtGE=;
        b=woHiUiWkIzNedccpV/CawGIx7/rPN1uxkIwgHCOvhk3oDe2OSnqNT3uV1yt4dxxggV
         vTAeUywKfi4m4rG+Wut49Dg/tpxkK/HJdBbYVyZEmndRRvk3y83iJvqOaSiCCEq8xybV
         VOGTpxvBttb8xTOMua40zdwIHZfbBjUNQhvdDdlI+N/m0wDrWr0QTr7NL8aaBhLrPf3I
         X92yNGMtQS/U8VdTTmLW2p76C9tQBNcZ2oNY1PsfIrbGWJHrjXDxKooehbD7pURZruwx
         Z4RMan3un9QIgIKwvmTnFakGwOLUmOErVIqt0n/+kJrwH2a2M49up8JMwpGw8q/lcbu7
         E/oA==
X-Forwarded-Encrypted: i=1; AJvYcCW88/2IOouEdJ9SOojD5wpibEcpSID29zsUSLhyi29Yggb+F1I4upLIWawpZ3tPrgVty8c=@vger.kernel.org
X-Gm-Message-State: AOJu0YzaIqtUR0xUWQ0dyIIxGMfzFkldmHPkuzPLe5MtwXum83puK5DJ
	80nk37XOWX00DNMC/bbXib/CkPUiZrqXiCs7dfXb1BcJk2Zcn+Yiso5AiQNug+2orZrqfE/GP9N
	u8g==
X-Google-Smtp-Source: AGHT+IEquI/dcGuvHtAD+d8/HkmmYalvr5Dpl8EjyXsUW0Mn0a/8F/NJjbLqp6zWRl9i1E0sX+PTajVAI8c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a63:f706:0:b0:7e6:c3f2:24d1 with SMTP id
 41be03b00d2f7-7eaa6c6493bmr8214a12.4.1729181109079; Thu, 17 Oct 2024 09:05:09
 -0700 (PDT)
Date: Thu, 17 Oct 2024 09:05:07 -0700
In-Reply-To: <ZxEQz6uGqNtNs5Ph@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <Zu0vvRyCyUaQ2S2a@google.com> <20241002124324.14360-1-mankku@gmail.com>
 <Zv1gbzT1KTYpNgY1@google.com> <Zv15trTQIBxxiSFy@google.com>
 <Zv2Ay9Y3TswTwW_B@google.com> <ZwezvcaZJOg7A9el@intel.com>
 <ZxAL6thxEH67CpW7@google.com> <ZxEQz6uGqNtNs5Ph@intel.com>
Message-ID: <ZxE1s6FWPkH07usG@google.com>
Subject: Re: [PATCH 1/1] KVM: nVMX: update VPPR on vmlaunch/vmresume
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: "Markku =?utf-8?Q?Ahvenj=C3=A4rvi?=" <mankku@gmail.com>, bp@alien8.de, dave.hansen@linux.intel.com, 
	hpa@zytor.com, janne.karhunen@gmail.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com, 
	tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Oct 17, 2024, Chao Gao wrote:
> >> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> >> index 5bb481aefcbc..d6a03c30f085 100644
> >> --- a/arch/x86/kvm/lapic.c
> >> +++ b/arch/x86/kvm/lapic.c
> >> @@ -800,6 +800,9 @@ static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
> >>  	if (!__apic_test_and_clear_vector(vec, apic->regs + APIC_ISR))
> >>  		return;
> >>  
> >> +	if (is_guest_mode(apic->vcpu))
> >
> >As above, I think this needs to be
> >
> >	if (is_guest_mode(apic->vcpu) && !nested_cpu_has_vid(get_vmcs12(vcpu)))
> >
> >because if virtual interrupt delivery is enabled, then EOIs are virtualized.
> >Which means that this needs to be handled in vmx_hwapic_isr_update().
> 
> I'm not sure if nested_cpu_has_vid() is necessary. My understanding is that
> when a bit in the vCPU's vISR is cleared, the vCPU's SVI (i.e., SVI in vmcs01)
> may be stale and so needs an update if vmcs01 isn't the active VMCS (i.e., the
> vCPU is in guest mode).
> 
> If L1 enables VID and EOIs from L2 are virtualized by KVM (L0), KVM shouldn't
> call this function in the first place. Because KVM should update the
> 'virt-APIC' page in VMCS12, rather than updating the vISR of the vCPU.

Ah, right.  And KVM handles that in nested_vmx_l1_wants_exit(), by forwarding all
APICv exits to L1:

	case EXIT_REASON_APIC_ACCESS:
	case EXIT_REASON_APIC_WRITE:
	case EXIT_REASON_EOI_INDUCED:
		/*
		 * The controls for "virtualize APIC accesses," "APIC-
		 * register virtualization," and "virtual-interrupt
		 * delivery" only come from vmcs12.
		 */
		return true;

