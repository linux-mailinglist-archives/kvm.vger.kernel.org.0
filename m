Return-Path: <kvm+bounces-30188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68E589B7D59
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 15:54:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 281E8282798
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 14:54:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B356B1A2554;
	Thu, 31 Oct 2024 14:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ETnG2z+z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D15219D07E
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 14:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730386489; cv=none; b=mGNXUPq0VR5KFDUPM8cI32aRzd/qt9X48IdBB8eRW1Uqv+bm8BvDlwc1XvGN/dfKZMhHxRx6VQB7fL6MfB4lAIT/AFbLGSe1n4u+UeSw64U9ApN1vXTXxuWIVXgKcpGMQ+d1sK+uz7g70lVUzx40e7noPvLYFlOKYs720HaDOok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730386489; c=relaxed/simple;
	bh=u76E/r9UUDz07Xp+Cc41Iz6lKTQf6X2ghbnlQrd+UP0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sJCiv3jA5DO16jPTbeK/sTjS+LhQE3RDPrHUELG/qGNQ3P1Y2OCMRpKwlO4YxsrfzQVtMbuGt41dkRKU1Uf7KdTNPh3Onyj2bbTYbYf0REu7WK5C7SgNhX1WelcPUdvSfELO/GEdYqiOqefpUj0UA1MfELk3TZjFQCVv+o3bx9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ETnG2z+z; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e6101877abso18881107b3.0
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 07:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730386487; x=1730991287; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=I4jFjc6e8J1xLS02luzh6I4skNg/sOY8eZMTH8Z7NzE=;
        b=ETnG2z+z24PvJIPSnV7Va/C06flVorGJaidyIKKWb5KaKREG9TRn46MtmNKm1IyCEo
         XFk8EQPTd442FwlylIfIUqsnIYhErNUl2BggwqDrMY3ex8n+6a/2b663qsTh+JnHv2Sq
         n3FI5wiGK1U0R3dlku/Za0Z5qSheCBDssvpjPp75mwN2yGRj2x1Cw0VNrnOzhrvvba6J
         Z4K4tJKZv/O1WY10nUkrNePTVW0UcxRDmxBb4nS0NXyNqIX1bTTMlVOTRLqJk9YYRE3G
         KlrGMqkzAdCVRKdrjyOcudLLE1cwMVFQEg1C1JxcrEElIfTpcYncC8zzVrZYNlh0Cc7q
         tAVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730386487; x=1730991287;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I4jFjc6e8J1xLS02luzh6I4skNg/sOY8eZMTH8Z7NzE=;
        b=IvTEMRYEirMzAfy3mH+LZ2kIpIYzO0cumik8an9QIqfO7MLzxEV+kO84UowHk8rpku
         7aHJAeQ0JRMpoFmyB2IrKMeuw9dY132QJQSFIUBC1IbXt6cDV515qoXrX1/0w2167HEL
         GsyDra93VckQ5FfH9hLJjkoN14q3Z/Nq20stwfe+WzRlAlof3XjpyTG8H9aSnBt6e+q4
         URVHKIjHBpCMPpyeZxTyg/tlBZ2LtzIMCpO5oi4DaZcxMsjdP/63C8qDUGgULUtgFysj
         WBlB4rCwXdn2dcgNzyPJFwcLN3CkmXKA0lcNVHb5LxTJdsCbjaZ9qOZnynFsiqxRhJDe
         mySg==
X-Forwarded-Encrypted: i=1; AJvYcCWWJNUrIZko6zgUPT9DMf4u42HmHimT4bUsDNYELxxelTRq8aTd+Pbo3pGSuXuu5ilhbmM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvtC9v8qdm+tUiRWcfbRl7zEmkIE0fBoRXS6Mt7i6pyMxN5wRB
	FmvYUwAys1rmgn/3VXCMA+jwrFr01s2ADZ54d992nmL9t1+8Nelo31GGaaE1XHC7o0IpiIPhwyi
	6Gw==
X-Google-Smtp-Source: AGHT+IFEjTg3GcUU35aUT3dK0mgrxEOJsOyJ79AlQ4eiyt2SZQ54zCscuIHhjKiyu1sIAauYDAMKGjs8obg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:a1e9:0:b0:e30:b93a:b3e4 with SMTP id
 3f1490d57ef6-e33025549e4mr19276.4.1730386486681; Thu, 31 Oct 2024 07:54:46
 -0700 (PDT)
Date: Thu, 31 Oct 2024 07:54:45 -0700
In-Reply-To: <3f158732a66829faaeb527a94b8df78d6173befa.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240826022255.361406-1-binbin.wu@linux.intel.com>
 <20240826022255.361406-2-binbin.wu@linux.intel.com> <ZyKbxTWBZUdqRvca@google.com>
 <3f158732a66829faaeb527a94b8df78d6173befa.camel@intel.com>
Message-ID: <ZyLWMGcgj76YizSw@google.com>
Subject: Re: [PATCH v3 1/2] KVM: x86: Check hypercall's exit to userspace generically
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, 
	"yuan.yao@linux.intel.com" <yuan.yao@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Oct 31, 2024, Kai Huang wrote:
> > @@ -10111,12 +10111,21 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> >  	cpl = kvm_x86_call(get_cpl)(vcpu);
> >  
> >  	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl);
> > -	if (nr == KVM_HC_MAP_GPA_RANGE && !ret)
> > -		/* MAP_GPA tosses the request to the user space. */
> > +	if (!ret)
> >  		return 0;
> >  
> > -	if (!op_64_bit)
> > +	/*
> > +	 * KVM's ABI with the guest is that '0' is success, and any other value
> > +	 * is an error code.  Internally, '0' == exit to userspace (see above)
> > +	 * and '1' == success, as KVM's de facto standard return codes are that
> > +	 * plus -errno == failure.  Explicitly check for '1' as some PV error
> > +	 * codes are positive values.
> > +	 */
> > +	if (ret == 1)
> > +		ret = 0;
> > +	else if (!op_64_bit)
> >  		ret = (u32)ret;
> > +
> >  	kvm_rax_write(vcpu, ret);
> >  
> >  	return kvm_skip_emulated_instruction(vcpu);
> > 
> 
> It appears below two cases are not covered correctly?
> 
> #ifdef CONFIG_X86_64    
>         case KVM_HC_CLOCK_PAIRING:
>                 ret = kvm_pv_clock_pairing(vcpu, a0, a1);
>                 break;
> #endif
>         case KVM_HC_SEND_IPI:
>                 if (!guest_pv_has(vcpu, KVM_FEATURE_PV_SEND_IPI))
>                         break;
> 
>                 ret = kvm_pv_send_ipi(vcpu->kvm, a0, a1, a2, a3, op_64_bit);
>                 break; 
> 
> Looking at the code, seems at least for KVM_HC_CLOCK_PAIRING,
> kvm_pv_clock_pairing() returns 0 on success, and the upstream behaviour is not
> routing to userspace but writing 0 to vcpu's RAX and returning to guest.  With
> the change above, it immediately returns to userspace w/o writing 0 to RAX.
> 
> For KVM_HC_SEND_IPI, seems the upstream behaviour is the return value of
> kvm_pv_send_ipi() is always written to vcpu's RAX reg, and we always just go
> back to guest.  With your change, the behaviour will be changed to:
> 
>   1) when ret == 0, exit to userspace w/o writing  0 to vcpu's RAX,
>   2) when ret == 1, it is converted to 0 and then written to RAX.
> 
> This doesn't look like safe.

Drat, I managed to space on the cases that didn't explicit set '0'.  Hrm.

My other idea was have an out-param to separate the return code intended for KVM
from the return code intended for the guest.  I generally dislike out-params, but
trying to juggle a return value that multiplexes guest and host values seems like
an even worse idea.

Also completely untested...

---
 arch/x86/include/asm/kvm_host.h |  8 +++----
 arch/x86/kvm/x86.c              | 41 +++++++++++++++------------------
 2 files changed, 23 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6d9f763a7bb9..226df5c56811 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2179,10 +2179,10 @@ static inline void kvm_clear_apicv_inhibit(struct kvm *kvm,
 	kvm_set_or_clear_apicv_inhibit(kvm, reason, false);
 }
 
-unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
-				      unsigned long a0, unsigned long a1,
-				      unsigned long a2, unsigned long a3,
-				      int op_64_bit, int cpl);
+int __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
+			    unsigned long a0, unsigned long a1,
+			    unsigned long a2, unsigned long a3,
+			    int op_64_bit, int cpl, unsigned long *ret);
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
 
 int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e09daa3b157c..e9ae09f1b45b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9998,13 +9998,11 @@ static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
 	return kvm_skip_emulated_instruction(vcpu);
 }
 
-unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
-				      unsigned long a0, unsigned long a1,
-				      unsigned long a2, unsigned long a3,
-				      int op_64_bit, int cpl)
+int __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
+			    unsigned long a0, unsigned long a1,
+			    unsigned long a2, unsigned long a3,
+			    int op_64_bit, int cpl, unsigned long *ret)
 {
-	unsigned long ret;
-
 	trace_kvm_hypercall(nr, a0, a1, a2, a3);
 
 	if (!op_64_bit) {
@@ -10016,15 +10014,15 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
 	}
 
 	if (cpl) {
-		ret = -KVM_EPERM;
+		*ret = -KVM_EPERM;
 		goto out;
 	}
 
-	ret = -KVM_ENOSYS;
+	*ret = -KVM_ENOSYS;
 
 	switch (nr) {
 	case KVM_HC_VAPIC_POLL_IRQ:
-		ret = 0;
+		*ret = 0;
 		break;
 	case KVM_HC_KICK_CPU:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_PV_UNHALT))
@@ -10032,36 +10030,36 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
 
 		kvm_pv_kick_cpu_op(vcpu->kvm, a1);
 		kvm_sched_yield(vcpu, a1);
-		ret = 0;
+		*ret = 0;
 		break;
 #ifdef CONFIG_X86_64
 	case KVM_HC_CLOCK_PAIRING:
-		ret = kvm_pv_clock_pairing(vcpu, a0, a1);
+		*ret = kvm_pv_clock_pairing(vcpu, a0, a1);
 		break;
 #endif
 	case KVM_HC_SEND_IPI:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_PV_SEND_IPI))
 			break;
 
-		ret = kvm_pv_send_ipi(vcpu->kvm, a0, a1, a2, a3, op_64_bit);
+		*ret = kvm_pv_send_ipi(vcpu->kvm, a0, a1, a2, a3, op_64_bit);
 		break;
 	case KVM_HC_SCHED_YIELD:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_PV_SCHED_YIELD))
 			break;
 
 		kvm_sched_yield(vcpu, a0);
-		ret = 0;
+		*ret = 0;
 		break;
 	case KVM_HC_MAP_GPA_RANGE: {
 		u64 gpa = a0, npages = a1, attrs = a2;
 
-		ret = -KVM_ENOSYS;
+		*ret = -KVM_ENOSYS;
 		if (!user_exit_on_hypercall(vcpu->kvm, KVM_HC_MAP_GPA_RANGE))
 			break;
 
 		if (!PAGE_ALIGNED(gpa) || !npages ||
 		    gpa_to_gfn(gpa) + npages <= gpa_to_gfn(gpa)) {
-			ret = -KVM_EINVAL;
+			*ret = -KVM_EINVAL;
 			break;
 		}
 
@@ -10080,13 +10078,13 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
 		return 0;
 	}
 	default:
-		ret = -KVM_ENOSYS;
+		*ret = -KVM_ENOSYS;
 		break;
 	}
 
 out:
 	++vcpu->stat.hypercalls;
-	return ret;
+	return 1;
 }
 EXPORT_SYMBOL_GPL(__kvm_emulate_hypercall);
 
@@ -10094,7 +10092,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 {
 	unsigned long nr, a0, a1, a2, a3, ret;
 	int op_64_bit;
-	int cpl;
+	int cpl, r;
 
 	if (kvm_xen_hypercall_enabled(vcpu->kvm))
 		return kvm_xen_hypercall(vcpu);
@@ -10110,10 +10108,9 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 	op_64_bit = is_64_bit_hypercall(vcpu);
 	cpl = kvm_x86_call(get_cpl)(vcpu);
 
-	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl);
-	if (nr == KVM_HC_MAP_GPA_RANGE && !ret)
-		/* MAP_GPA tosses the request to the user space. */
-		return 0;
+	r = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl, &ret);
+	if (r <= r)
+		return r;
 
 	if (!op_64_bit)
 		ret = (u32)ret;

base-commit: 675248928970d33f7fc8ca9851a170c98f4f1c4f
-- 

