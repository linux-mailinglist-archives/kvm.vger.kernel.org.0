Return-Path: <kvm+bounces-73209-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2DU5Nt2Eq2n/dgEAu9opvQ
	(envelope-from <kvm+bounces-73209-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 02:52:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BD76229822
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 02:52:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0B23A3001078
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2026 01:52:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D86B3290BD;
	Sat,  7 Mar 2026 01:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MdTcTb1b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A2F3290B7
	for <kvm@vger.kernel.org>; Sat,  7 Mar 2026 01:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772848335; cv=none; b=JlNeRe3ntT0eHCtqNLfgL+/zz1fRs0AMzRdT1rg6RPBu5RW/CB3gZzDKB8ouKD5p41sO4UodwG35FkDNvVfQjWQgkcYe4p23JhSp6xQ0OaNJnzPGPT51foXrYxorpnUnWqkYWypSQedwlHsWA7c1NaGMiKzYoVOoqEEtredTGvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772848335; c=relaxed/simple;
	bh=9TdYo2hrAmXwNx2QzpsSdZDhIlxyPDORKhsBkkATOPk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CjrDzH7wIgU2dmi30racbhihoWuYYennC3lFH8LcRTfU8XRh6oHUp5Ea63v4GEl5uPHMWumYSSD72WjNucvvMq/0WzO69AXQ6ngQhtOkFQr9S/fxTUBHU6+F8VWDVWjc0SitYw3sZ5BzzmbTfd9W845tWx5u8BfCbDu5d1Mjj0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MdTcTb1b; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c503d6be76fso35665884a12.0
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 17:51:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772848317; x=1773453117; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=X8Y0ox6GXyJuz0HXLsf/EcxN0tNLkLTey5RZvxhe0co=;
        b=MdTcTb1bk+5pXMZdK4gOI52ANZKkrnKT6cTYABu/QZ2SMG6hHpRbLr2iC3fL3xvkFk
         fRBmZ2nk+x66QfGIg+FS2eBerROsfsGpdGhTkKJ1T+HWQgeFbj9PrRJUkdUMbohBhnNm
         akXHWL7MB3wMJ9tjvXbSoCbzV5yMMLTFnMfh3N4zP2PTNPV92YMY0oTZUmLm2PVA1r0M
         nvpcmTpyIdNJ5eUc4iT8ALCbCqR290jE/pgwmTagPViuWXtgCyzY8oLL5PASl4WvBkuW
         iY8O4ci+0uRAZfIt9RcCnSdpYFPH1QhZnnhQEG93hwsUY6rt3QCUXPCX+le0hon9FR8/
         Ethw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772848317; x=1773453117;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X8Y0ox6GXyJuz0HXLsf/EcxN0tNLkLTey5RZvxhe0co=;
        b=YQet1ZiwuvyTomYAYiplfVMK216X+Qtl+aYvKjL/2dMDvSN9o37JzJ0x3tnuLhZWbM
         mmvtW6zb5PbmAhGnalf0CHesKqb1wjFlI7vLTZ/EWzh//vi2CBDzxbFpTEVVTi7TQGfw
         g4dkbFMd6Xv7J/QyPFXkHsM1KadS08KvJIFZ3aQRVKlxOsfdT+n4tHFzHE4L7LYrGFOY
         DjvVVuTXoLQX0gQRwCSlF6YnJ0VfkEfN50UrpHILKiR49XC/xGFVc5HdhuExmB3WCW88
         5FN64S4Uy35oiRiLuhB1TYnJ60HL2mOOkqNxEm6XbZqcZ/CyJ8H59PkReZO0b5p2A1C1
         3BFg==
X-Forwarded-Encrypted: i=1; AJvYcCWbHh4BFPBsxtTclowqybJSsdarhtjN6WG/G8CAH8D97kNwRVjaCHgq5sVZp9Vef0yqe2s=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPEQCBeKdSYAf1wbGsWmEcChowbENzc4rjbsKLXVTFAXGKvUJa
	cTnAnrb5KiTdTnows9MwCq7uPevp0WPBEB0WjBe+4pCZDy59cuiP0ss5KWPvI1Wj2fnBoAyOhLT
	LWGNvZA==
X-Received: from pfbbj28.prod.google.com ([2002:a05:6a00:319c:b0:827:44d1:121d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3c8a:b0:829:86aa:e168
 with SMTP id d2e1a72fcca58-829a2d655a2mr3760934b3a.8.1772848317055; Fri, 06
 Mar 2026 17:51:57 -0800 (PST)
Date: Fri, 6 Mar 2026 17:51:55 -0800
In-Reply-To: <aaCfcwdA1E4V5qgE@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <d98692e2-d96b-4c36-8089-4bc1e5cc3d57@fortanix.com>
 <aZ9V_O5SGGKa-Vdn@google.com> <928a31e1-bb6f-44d4-b1de-654d6968fd55@fortanix.com>
 <aZ9Zs0laC2p5W-OL@google.com> <64a01647-2f99-44a8-a183-702d6eb6fd81@fortanix.com>
 <aaCfcwdA1E4V5qgE@google.com>
Message-ID: <aauEu5APj4Eaw73Q@google.com>
Subject: Re: [PATCH] KVM: SEV: Track SNP launch state and disallow invalid
 userspace interactions
From: Sean Christopherson <seanjc@google.com>
To: Jethro Beekman <jethro@fortanix.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 0BD76229822
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-73209-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-0.933];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action

On Thu, Feb 26, 2026, Sean Christopherson wrote:
> On Wed, Feb 25, 2026, Jethro Beekman wrote:
> > On 2026-02-25 12:21, Sean Christopherson wrote:
> > > On Wed, Feb 25, 2026, Jethro Beekman wrote:
> > >> On 2026-02-25 12:05, Sean Christopherson wrote:
> > >>> On Mon, Jan 19, 2026, Jethro Beekman wrote:
> > >>>> Calling any of the SNP_LAUNCH_ ioctls after SNP_LAUNCH_FINISH results in a
> > >>>> kernel page fault due to RMP violation. Track SNP launch state and exit early.
> > >>>
> > >>> What exactly trips the RMP #PF?  A backtrace would be especially helpful for
> > >>> posterity.
> > >>
> > >> Here's a backtrace for calling ioctl(KVM_SEV_SNP_LAUNCH_FINISH) twice. Note this is with a modified version of QEMU.
> > > 
> > >> RIP: 0010:sev_es_sync_vmsa+0x54/0x4c0 [kvm_amd]
> > >>  snp_launch_update_vmsa+0x19d/0x290 [kvm_amd]
> > >>  snp_launch_finish+0xb6/0x380 [kvm_amd]
> > >>  sev_mem_enc_ioctl+0x14e/0x720 [kvm_amd]
> > >>  kvm_arch_vm_ioctl+0x837/0xcf0 [kvm]
> > > 
> > > Ah, it's the VMSA that's being accessed.  Can't we just do?
> > > 
> > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > index 723f4452302a..1e40ae592c93 100644
> > > --- a/arch/x86/kvm/svm/sev.c
> > > +++ b/arch/x86/kvm/svm/sev.c
> > > @@ -882,6 +882,9 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
> > >         u8 *d;
> > >         int i;
> > >  
> > > +       if (vcpu->arch.guest_state_protected)
> > > +               return -EINVAL;
> > > +
> > >         /* Check some debug related fields before encrypting the VMSA */
> > >         if (svm->vcpu.guest_debug || (svm->vmcb->save.dr7 & ~DR7_FIXED_1))
> > >                 return -EINVAL;
> > 
> > I tried relying on guest_state_protected instead of creating new state but I
> > don't think it's sufficient. In particular, your proposal may fix
> > snp_launch_finish() 
> 
> But it does fix that case, correct?  I don't want to complicate one fix just
> because there are other bugs that are similar but yet distinct.
> 
> > but I don't believe this addresses the issues in snp_launch_update() and
> 
> Do you mean snp_launch_update_vmsa() here?  Or am I missing an interaction with
> vCPUs in snp_launch_update()?
> 
> > sev_vcpu_create().
> 
> There are a pile of SEV lifecycle and locking issues, i.e. this is just one of
> several flaws.  Fixing the locking has been on my todo list for a few months (we
> found some "fun" bugs with an internal run of syzkaller), and I'm finally getting
> to it.  Hopefully I'll post a series early next week.
> 
> Somewhat off the cuff, but I think the easiest way to close the race between
> KVM_CREATE_VCPU and KVM_SEV_SNP_LAUNCH_FINISH is to reject KVM_SEV_SNP_LAUNCH_FINISH
> if a vCPU is being created.  Or did I misunderstand the race you're pointing out?
> 
> Though unless there's a strong reason not to, I'd prefer to get greedy and block
> all of sev_mem_enc_ioctl(), e.g.

Circling back to this (writing changelogs), I don't think there's actually a
novel bug with respect to KVM_SEV_SNP_LAUNCH_FINISH racing with KVM_CREATE_VCPU.

kvm_for_each_vcpu() operates on online_vcpus, LAUNCH_FINISH (all SEV+ sub-ioctls)
holds kvm->mutex, and fully onlining a vCPU in kvm_vm_ioctl_create_vcpu() is done
under kvm->mutex.  So AFAICT, there's no difference between an in-progress vCPU
and a vCPU that is created entirely after LAUNCH_FINISH.

It's probably worth preventing as a hardening measure, but I don't think there's
an actual bug to be fixed.

