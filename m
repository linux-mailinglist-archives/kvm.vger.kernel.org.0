Return-Path: <kvm+bounces-11909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D59987CF96
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 15:57:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BB4591F23CF9
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 14:57:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEF223C6A3;
	Fri, 15 Mar 2024 14:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e0yiTy2w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53AE53B795
	for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 14:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710514623; cv=none; b=Y1CzUXQRkBPaiM8oZsvr7e2+KmBYU+wpNrw+pyLkO9MfE1hMx5/tr96xos5RRxixoyYXpN8a/XWg/FxywVF+Mz0D0rM//zea/JV9DYuIP01DcYGCtsCU04fdaFaImkhaqS5WuAoP4G8Bva23AcQLGpGC28HXHq+W+h39zqTluqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710514623; c=relaxed/simple;
	bh=DT/ViFBHsbj0Q/geQ6VrVlllozbe4AADDgj8K1dteyw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Q0JtpfwoQ4zxOXbGs6MR4rInJE6X+qXHyLF98t5ny1Nht2FnTOwrb9JH6DQ/IdEVUuM8+5quBve0unjbpkgCFbuNhit/dYBXtQvAAzhC2POQio28nFaj2whYJc8Zo63Mgsc11Ke0lXEA6pZJNUtv9CEhOh8ezcQcEpfS0mSSaSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e0yiTy2w; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dd1395fd1bfso3714792276.0
        for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 07:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710514621; x=1711119421; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+L6K4/F3ILROB130RWMthiAdNEjFhajcVE2ecg4ZLck=;
        b=e0yiTy2wg3LABxgRiGdDwCC02iGAEtF696CQvHuhTtQSEPKd85MRoYI0Q90N6FvJFw
         MvPnkxEu1R5SMqImtPMGyai/3vcM4HVMBBbcI/9UqsI5Jc6ZeuClA+ifKCoH7/3LdH+U
         1lvpCe02yGe5NlnBf6NM8isHkKDjeKDjj1dLmH29vl9ZJQhKivplXaMkJxXbvf4gVo0E
         ClYyStx7PvrHu9bks6bnitbdbstp5tu/Oa79tpsovlc2sjcaqjcIEvGhffmr3XogWkjK
         Jg9WyocVny66x9Eg4JMLd23JPJti85QyEfAMPtmsPGc7SP2SpqM0rMPRRCMekdC0iWWM
         wRzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710514621; x=1711119421;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+L6K4/F3ILROB130RWMthiAdNEjFhajcVE2ecg4ZLck=;
        b=Z30lI5TAreZWFqbKoqJEv7aRxojpZfCFxJd1CeDteAkOzT5/fMlRCKQnzeFUS8mUrF
         Kum6LsglONybJOEu/i2wPfXtrO7tlt7hBBKa/UeguY31+bfVVIxgsdloVRzvMFTa8jwT
         iV3C1VYBpS+wtlJiV81JZHtDP3T4IxbIRpkXZ1yy9ubDNP2Wkos0uFdzD/JU65kVeuv4
         CWa+HgkbJA8hZMor0r4o3RdbqZXxE00SORyGFMa/bUIRPTvEsDffIFFX2NyYPHryN9N2
         V5G8zHy/TfUkNxQ6buVknTQkh+p6jbameNdmYtyJqt4xP7J+uNQbQKpuPijRspC8eP3I
         adaA==
X-Forwarded-Encrypted: i=1; AJvYcCUtwjqj3eOcKkTPTt0Yo8D8M67PV4luRGLY5nNpHU2Uxsr/RTi5RarRjO2wlI32C2xJNwaPwm5ds0OQTvYKSNLhQJk9
X-Gm-Message-State: AOJu0YzGnoZRYxwdcNaN3HIMCJm/fFrJW0gYSeqnQYBc0K1ML5usBmbh
	bIcqCWxWfIepvJ2Cd3zYCGWzY8UeTTuoTtjyo6gmx1YG9hkQA/3D3G3NzrJjXxVaHMdruUsIhMo
	8nA==
X-Google-Smtp-Source: AGHT+IGTs8Mz3jfFYBRg1koL6FoVVmgByeTYj5l1v2JnAkIpqZuR/Ss5pmMujfr3s/OIjQg5cFM4ti24jkE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1b91:b0:dd1:390a:51e8 with SMTP id
 ei17-20020a0569021b9100b00dd1390a51e8mr1454996ybb.10.1710514621353; Fri, 15
 Mar 2024 07:57:01 -0700 (PDT)
Date: Fri, 15 Mar 2024 07:56:59 -0700
In-Reply-To: <20240314234850.js4gvwv7wh43v3y5@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240226190344.787149-1-pbonzini@redhat.com> <20240226190344.787149-11-pbonzini@redhat.com>
 <20240314024952.w6n6ol5hjzqayn2g@amd.com> <20240314220923.htmb4qix4ct5m5om@amd.com>
 <ZfOAm8HtAaazpc5O@google.com> <20240314234850.js4gvwv7wh43v3y5@amd.com>
Message-ID: <ZfRhu0GVjWeAAJMB@google.com>
Subject: Re: [PATCH v3 10/15] KVM: x86: add fields to struct kvm_arch for CoCo features
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	aik@amd.com, pankaj.gupta@amd.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Mar 14, 2024, Michael Roth wrote:
> On Thu, Mar 14, 2024 at 03:56:27PM -0700, Sean Christopherson wrote:
> > On Thu, Mar 14, 2024, Michael Roth wrote:
> > > On Wed, Mar 13, 2024 at 09:49:52PM -0500, Michael Roth wrote:
> > > > I've been trying to get SNP running on top of these patches and hit and
> > > > issue with these due to fpstate_set_confidential() being done during
> > > > svm_vcpu_create(), so when QEMU tries to sync FPU state prior to calling
> > > > SNP_LAUNCH_FINISH it errors out. I think the same would happen with
> > > > SEV-ES as well.
> > > > Maybe fpstate_set_confidential() should be relocated to SEV_LAUNCH_FINISH
> > > > site as part of these patches?
> > > 
> > > Talked to Tom a bit about this and that might not make much sense unless
> > > we actually want to add some code to sync that FPU state into the VMSA

Is manually copying required for register state?  If so, manually copying everything
seems like the way to go, otherwise we'll end up with a confusing ABI where a
rather arbitrary set of bits are (not) configurable by userspace.

> > > prior to encryption/measurement. Otherwise, it might as well be set to
> > > confidential as soon as vCPU is created.
> > > 
> > > And if userspace wants to write FPU register state that will not actually
> > > become part of the guest state, it probably does make sense to return an
> > > error for new VM types and leave it to userspace to deal with
> > > special-casing that vs. the other ioctls like SET_REGS/SREGS/etc.
> > 
> > Won't regs and sregs suffer the same fate?  That might not matter _today_ for
> > "real" VMs, but it would be a blocking issue for selftests, which need to stuff
> > state to jumpstart vCPUs.
> 
> SET_REGS/SREGS and the others only throw an error when
> vcpu->arch.guest_state_protected gets set, which doesn't happen until

Ah, I misread the diff and didn't see the existing check on fpstate_is_confidential().

Side topic, I could have sworn KVM didn't allocate the guest fpstate for SEV-ES,
but git blame says otherwise.  Avoiding that allocation would have been an argument
for immediately marking the fpstate confidential.

That said, any reason not to free the state when the fpstate is marked confidential?

> sev_launch_update_vmsa(). So in those cases userspace is still able to sync
> additional/non-reset state prior initial launch. It's just XSAVE/XSAVE2 that
> are a bit more restrictive because they check fpstate_is_confidential()
> instead, which gets set during vCPU creation.
> 
> Somewhat related, but just noticed that KVM_SET_FPU also relies on
> fpstate_is_confidential() but still silently returns 0 with this series.
> Seems like it should be handled the same way as XSAVE/XSAVE2, whatever we
> end up doing.

+1

Also, I think a less confusing and more robust way to deal with the new VM types
would be to condition only the return code on whether or not the VM has protected
state, e.g.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9d670a45aea4..0e245738d4c5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5606,10 +5606,6 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
 static int kvm_vcpu_ioctl_x86_get_xsave2(struct kvm_vcpu *vcpu,
                                         u8 *state, unsigned int size)
 {
-       if (vcpu->kvm->arch.has_protected_state &&
-           fpstate_is_confidential(&vcpu->arch.guest_fpu))
-               return -EINVAL;
-
        /*
         * Only copy state for features that are enabled for the guest.  The
         * state itself isn't problematic, but setting bits in the header for
@@ -5626,7 +5622,7 @@ static int kvm_vcpu_ioctl_x86_get_xsave2(struct kvm_vcpu *vcpu,
                             XFEATURE_MASK_FPSSE;
 
        if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
-               return 0;
+               return vcpu->kvm->arch.has_protected_state ? -EINVAL : 0;
 
        fpu_copy_guest_fpstate_to_uabi(&vcpu->arch.guest_fpu, state, size,
                                       supported_xcr0, vcpu->arch.pkru);

