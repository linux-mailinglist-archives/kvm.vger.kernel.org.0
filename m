Return-Path: <kvm+bounces-70468-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id Ngu/H0EwhmmPKQQAu9opvQ
	(envelope-from <kvm+bounces-70468-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 19:17:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D60B7101B0B
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 19:17:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5FB4D30166FD
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 18:17:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE41232AAD6;
	Fri,  6 Feb 2026 18:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P0z9Ljh2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7AFC2F12BB
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 18:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770401852; cv=none; b=i7qY4DMtnbKz/UXci5Z1La7/3glw1JwdfYZ5SpY3IFEBlhzOODlRArdT4eMQMw/XeHHvW7e1ws6fjwlEa78ej5jQGT6hTVipLfweDcH25gJ6f4oHWGjspd8mZBvzhAg41jrQM5Wu3rLdGOaZjoIof82eS2Hj2jDTdhTDCrYEYF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770401852; c=relaxed/simple;
	bh=o9DVE8NnlcwxZ80p5OOZls7WtX2Ykerdk1S8OIhGkt4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=StdXzWaeS0yKjlIDJIMVMku1QRtnKgNgkA6qOzNpH/TqaT+yShONCy6Ucg7jvEq2APzJ6Rmti+9LnNuKnqTKYMhJBL9cpWZODJOsKGHeqiOfwW1elPcbl3gb3uBmo2WGqdtMpIoVWWlSiUNztnAunzV2fW9TQoxVBhLv9peOaL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P0z9Ljh2; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-352de7a89e1so1922482a91.1
        for <kvm@vger.kernel.org>; Fri, 06 Feb 2026 10:17:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770401851; x=1771006651; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CFM7idE3qyCCU0QQUYowTjRBvFMJAa3MGc8Bb8NjCyI=;
        b=P0z9Ljh2ep7gtd8MnTVzGoO0j6A9CUP7HuDcXT3HDIpQwvS2pYa5rUlH5mzpcH3ul2
         ubhJfHrThJ/CKRmZQ9Y9hTbhgcOh08dS0GQiWnfKRXzqS18/9cLiY17dlP2q3HsQlQ79
         zB+yXK5SyQ1vIyccc3o2o4XOFW8qsMpD5f1FuLbBiPsDh6HrAnm6+SGlnZ0igIEubLAK
         Dj5NqgUAqcFeOHuEndeAVO1rvNCkM8DWjL6M5uQtZC/0jrcq33KN64qrSRdrOzUskO4M
         HCc2a/GMfx11HBEjWFNnTttaBO12FIpM6Ro5IQlO1JwZJOxVp7hXTllMhC7mj/ZkcFRZ
         /0yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770401851; x=1771006651;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CFM7idE3qyCCU0QQUYowTjRBvFMJAa3MGc8Bb8NjCyI=;
        b=oHt7rQEUR+YZgW3gjbYdsETRoz1c1LUYWLSdKHXVD6AJPI0r+d9Jv6+GO+ZE1j+Jj3
         xBC/QYnxA/UPgCWEsLnOqT7VVWveK9sip8L4L65wr1qI3QztECvsL3m6yO8KUY3+SeVi
         cBz4b8QN//eregw7ToUJ34Tdu86U/bk/VW1lBQdurCp3nipUJAnuhrptKz1S9p4+XEav
         CydPQo20wvDWlHhIAG+Oak24zLT0F+wgdseg85J3wA97fgqmsbBtusG5UkzFdQmu6zHP
         Y0oBLu4PsVys5n4XJp2UjGfYXiFlOAW0vVsRpWvI81re/TBvgIGqz7jQM6/4oORwGTl+
         L4kA==
X-Forwarded-Encrypted: i=1; AJvYcCW+JhUF5S5JL9zN+9d5AX6QuFuZg/EHXGwoLokUuQyCLkJSx1UuwXXf8Gs7CA9uxVJMpI4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvOHychDzbVLKPic610hdWokAEn/3DmfxE+KT6t159vwsqzQyf
	/OjO+hdTpbQ+X8GGz2Nzx9srhurcelVOm2bbQ4IPi0zxF34E0n4CLFpqakTJFglKCni9yb75NWv
	9LWnCIw==
X-Received: from pjbhg13.prod.google.com ([2002:a17:90b:300d:b0:34a:b143:87d7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c12:b0:354:be2e:c056
 with SMTP id 98e67ed59e1d1-354be2ed154mr1164237a91.18.1770401851262; Fri, 06
 Feb 2026 10:17:31 -0800 (PST)
Date: Fri, 6 Feb 2026 10:17:29 -0800
In-Reply-To: <aYXvp1S7lg2sq4AS@blrnaveerao1>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260203190711.458413-1-seanjc@google.com> <20260203190711.458413-2-seanjc@google.com>
 <aYXvp1S7lg2sq4AS@blrnaveerao1>
Message-ID: <aYYwOTSIJsdafEvJ@google.com>
Subject: Re: [PATCH 1/2] KVM: SVM: Initialize AVIC VMCB fields if AVIC is
 enabled with in-kernel APIC
From: Sean Christopherson <seanjc@google.com>
To: Naveen N Rao <naveen@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70468-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D60B7101B0B
X-Rspamd-Action: no action

On Fri, Feb 06, 2026, Naveen N Rao wrote:
> On Tue, Feb 03, 2026 at 11:07:09AM -0800, Sean Christopherson wrote:
> > Initialize all per-vCPU AVIC control fields in the VMCB if AVIC is enabled
> > in KVM and the VM has an in-kernel local APIC, i.e. if it's _possible_ the
> > vCPU could activate AVIC at any point in its lifecycle.  Configuring the
> > VMCB if and only if AVIC is active "works" purely because of optimizations
> > in kvm_create_lapic() to speculatively set apicv_active if AVIC is enabled
> > *and* to defer updates until the first KVM_RUN.  In quotes because KVM
> 
> I think it will be good to clarify that two issues are being addressed 
> here (it wasn't clear to me to begin with):
> - One, described above, is about calling into avic_init_vmcb() 
>   regardless of the vCPU APICv status.
> - Two, described below is about using the vCPU APICv status for init and 
>   not consulting the VM-level APICv inhibit status.

Yeah, I was worried the changelog didn't capture the second one well, but I was
struggling to come up with wording.  How about this as a penultimate paragraph?

  Note!  Use the vCPU's current APICv status when initializing the VMCB,
  not the VM-level inhibit status.  The state of the VMCB *must* be kept
  consistent with the vCPU's APICv status at all times (KVM elides updates
  that are supposed be nops).  If the vCPU's APICv status isn't up-to-date
  with the VM-level status, then there is guaranteed to be a pending
  KVM_REQ_APICV_UPDATE, i.e. KVM will sync the vCPU with the VM before
  entering the guest.
 
> > likely won't do the right thing if kvm_apicv_activated() is false, i.e. if
> > a vCPU is created while APICv is inhibited at the VM level for whatever
> > reason.  E.g. if the inhibit is *removed* before KVM_REQ_APICV_UPDATE is
> > handled in KVM_RUN, then __kvm_vcpu_update_apicv() will elide calls to
> > vendor code due to seeing "apicv_active == activate".
> >
> > Cleaning up the initialization code will also allow fixing a bug where KVM
> > incorrectly leaves CR8 interception enabled when AVIC is activated without
> > creating a mess with respect to whether AVIC is activated or not.
> > 
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> Any reason not to add a Fixes: tag?

Purely that I couldn't pin down exactly what commit(s) to blame.  Well, that's a
bit of a lie.  If I'm being 100% truthful, I got as far as commit 67034bb9dd5e
and decided I didn't care enough to spend the effort to figure out whether or not
that commit was truly to blame :-)

> It looks like the below commits are to blame, but those are really old so I
> understand if you don't think this is useful:
> Fixes: 67034bb9dd5e ("KVM: SVM: Add irqchip_split() checks before enabling AVIC")
> Fixes: 6c3e4422dd20 ("svm: Add support for dynamic APICv")

LGTM, I'll tack them on.

> Other than that:
> Reviewed-by: Naveen N Rao (AMD) <naveen@kernel.org>

Thanks!  (Seriously, I really appreciate the in-depth reviews)

> > ---
> >  arch/x86/kvm/svm/avic.c | 2 +-
> >  arch/x86/kvm/svm/svm.c  | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > index f92214b1a938..44e07c27b190 100644
> > --- a/arch/x86/kvm/svm/avic.c
> > +++ b/arch/x86/kvm/svm/avic.c
> > @@ -368,7 +368,7 @@ void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
> >  	vmcb->control.avic_physical_id = __sme_set(__pa(kvm_svm->avic_physical_id_table));
> >  	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE;
> >  
> > -	if (kvm_apicv_activated(svm->vcpu.kvm))
> > +	if (kvm_vcpu_apicv_active(&svm->vcpu))
> >  		avic_activate_vmcb(svm);
> >  	else
> >  		avic_deactivate_vmcb(svm);
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 5f0136dbdde6..e8313fdc5465 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -1189,7 +1189,7 @@ static void init_vmcb(struct kvm_vcpu *vcpu, bool init_event)
> >  	if (guest_cpu_cap_has(vcpu, X86_FEATURE_ERAPS))
> >  		svm->vmcb->control.erap_ctl |= ERAP_CONTROL_ALLOW_LARGER_RAP;
> >  
> > -	if (kvm_vcpu_apicv_active(vcpu))
> > +	if (enable_apicv && irqchip_in_kernel(vcpu->kvm))
> >  		avic_init_vmcb(svm, vmcb);
> 
> Doesn't have to be done as part of this series, but I'm wondering if it 
> makes sense to turn this into a helper to clarify the intent and to make 
> it more obvious:

Hmm, yeah, though my only hesitation is the name.  For whatever reason, "possible"
makes me think "is APICv possible *right now*" (ignoring that I wrote exactly that
in the changelog).

What if we go with kvm_can_use_apicv()?  That would align with vmx_can_use_ipiv()
and vmx_can_use_vtd_pi(), which are pretty much identical in concept.

