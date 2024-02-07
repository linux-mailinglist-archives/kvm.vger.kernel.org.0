Return-Path: <kvm+bounces-8188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 39F9684C2D8
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 03:58:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A02B91F23FF1
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 02:58:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE4B4FC02;
	Wed,  7 Feb 2024 02:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2ukTrgd4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61481DF78
	for <kvm@vger.kernel.org>; Wed,  7 Feb 2024 02:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707274706; cv=none; b=FEEhllAQAvNbzu2T/+WzlGI18TevKOXRxGX7TLeXlcV4RjWJ/RW/bvxgj1puHjL93QPjfDqNdpI7Lmamr6N5SPbVpasetib8iX2Zu/u2qCn202OeVPf6cNm7NIRJvMIWyfF51rVcB2XPbi07MX+Qc3Y4s/sBaMdcMVBx8kfBL8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707274706; c=relaxed/simple;
	bh=q0YTkLGeLiHeoMECfeW+UDyihdTziDFAXkK/gYfa6m8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FlEgKGJrzslQ8xNz0kRgOXHosAhy55eHGNvc8MoEHAEl/cTxhWCv6ELb2S18dbcw2YBGyI2ovxOlpRu7FpxDPtlFyhdLOdKS3f3ghnUF05y2/SpF6yr4BZBN5aiGx8H34KdzOBcurxV4EFC+XSq5frSolYcC6yQpd/EuJOhOaFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2ukTrgd4; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc7165d7ca3so222375276.2
        for <kvm@vger.kernel.org>; Tue, 06 Feb 2024 18:58:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707274704; x=1707879504; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=REgxJxxqnJ9hacBXQ6aXWZQE1YsmJHbedjyy3CiQK2A=;
        b=2ukTrgd4q81UHPu3MI9HusimapHQFjEo5lBjX5bWkjctL09MKKHCjDtmMdzWfNJi/J
         Q9dR+lqB2TfLA+GLQlO8wIFxHHxJB1apbcM50V6I5gVINxItxNlPOByGeu1Hs38HyKrf
         4GQcWpBNK/fd3jKPfiXl3njfThoMpv7/fWiCdLkaSbkrcjPJeXafmsfyQPj8ql56BH8a
         v5GbV8WVw1jHb3AQfeeiI23GvE60eOAbDjLufVUV2MEsqchIJ0Xn/wUgn0EL9vC51TcL
         8bUfK92X3uqdT+4r/MGH7YCZw/YXA44/ULLnKSGQiFPYxwgVmB/YI7DyzvY/7BqIUOO9
         JdTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707274704; x=1707879504;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=REgxJxxqnJ9hacBXQ6aXWZQE1YsmJHbedjyy3CiQK2A=;
        b=wwlSEGuSUS/Djh0MW09fUnVVEyT70pffniuj/BulbtK4FhstuPsuRHvoezEoRxjIvY
         6irSmECmKp9Cc89+qF9DvEcGTpDkthVMzQ59zsIMUe8OR+QbQj+MCjFcUlo2SQebIqpx
         g/mYOnA7ydQ7RVEDwsLCCoc7aFFYKEOLHnTMPk+Mnbtag80yaFWsU2Bej0EKoPB8Expw
         SIZac4Q/j77q48D56P7mXufCKQ2siYY66/bExgnoNy4cj07UZbl8B5JkbgsVNmuGUfKD
         0P10RJPxKFJxgbqgO9/1QzxVEEepY+Xrjcb8Xz2XXtcJsRVmiPbfZ7auKgtVHfD8mG04
         +i3w==
X-Gm-Message-State: AOJu0Yz1RyPRHbKAtflXRzT1WmdryrI2JiXopRF2A0lSk6aBsqsfNakT
	qgfo9kScwkMwWfUMwyKcc71mVaEgkfgMLAbPDT6t4SJVYuCzKhCPKtntKiT55xMHpH2+aCB+g4y
	ftQ==
X-Google-Smtp-Source: AGHT+IEJ5Usl1LXo6fL+Uxm5BQe0zL0MKFLw1o5ny+TWq6aF8Z1lvB2IftryIW8cs4diMDf/g1gm2NrvVjk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2310:b0:dc2:3a02:4fc8 with SMTP id
 do16-20020a056902231000b00dc23a024fc8mr146257ybb.6.1707274704457; Tue, 06 Feb
 2024 18:58:24 -0800 (PST)
Date: Tue, 6 Feb 2024 18:58:22 -0800
In-Reply-To: <19a1ac538e6cb1b479122df677909fb49fedbb28.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <f21ee3bd852761e7808240d4ecaec3013c649dc7.camel@infradead.org>
 <ZcJ9bXxU_Pthq_eh@google.com> <19a1ac538e6cb1b479122df677909fb49fedbb28.camel@infradead.org>
Message-ID: <ZcLxzrbvSs0jNeR4@google.com>
Subject: Re: [PATCH v3] KVM: x86: Use fast path for Xen timer delivery
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: kvm <kvm@vger.kernel.org>, Paul Durrant <paul@xen.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 06, 2024, David Woodhouse wrote:
> On Tue, 2024-02-06 at 10:41 -0800, Sean Christopherson wrote:
> >=20
> > This has an obvious-in-hindsight recursive deadlock bug.=C2=A0 If KVM a=
ctually needs
> > to inject a timer IRQ, and the fast path fails, i.e. the gpc is invalid=
,
> > kvm_xen_set_evtchn() will attempt to acquire xen.xen_lock, which is alr=
eady held
>=20
> Hm, right. In fact, kvm_xen_set_evtchn() shouldn't actually *need* the
> xen_lock in an ideal world; it's only taking it in order to work around
> the fact that the gfn_to_pfn_cache doesn't have its *own* self-
> sufficient locking. I have patches for that...
>=20
> I think the *simplest* of the "patches for that" approaches is just to
> use the gpc->refresh_lock to cover all activate, refresh and deactivate
> calls. I was waiting for Paul's series to land before sending that one,
> but I'll work on it today, and double-check my belief that we can then
> just drop xen_lock from kvm_xen_set_evtchn().

While I definitely want to get rid of arch.xen.xen_lock, I don't want to ad=
dress
the deadlock by relying on adding more locking to the gpc code.  I want a t=
eeny
tiny patch that is easy to review and backport.  Y'all are *proably* the on=
ly
folks that care about Xen emulation, but even so, that's not a valid reason=
 for
taking a roundabout way to fixing a deadlock.

Can't we simply not take xen_lock in kvm_xen_vcpu_get_attr()  It holds vcpu=
->mutex
so it's mutually exclusive with kvm_xen_vcpu_set_attr(), and I don't see an=
y other
flows other than vCPU destruction that deactivate (or change) the gpc.

And the worst case scenario is that if _userspace_ is being stupid, userspa=
ce gets
a stale GPA.

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 4b4e738c6f1b..50aa28b9ffc4 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -973,8 +973,6 @@ int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struct=
 kvm_xen_vcpu_attr *data)
 {
        int r =3D -ENOENT;
=20
-       mutex_lock(&vcpu->kvm->arch.xen.xen_lock);
-
        switch (data->type) {
        case KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO:
                if (vcpu->arch.xen.vcpu_info_cache.active)
@@ -1083,7 +1081,6 @@ int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, stru=
ct kvm_xen_vcpu_attr *data)
                break;
        }
=20
-       mutex_unlock(&vcpu->kvm->arch.xen.xen_lock);
        return r;
 }
=20
=20

If that seems to risky, we could go with an ugly and hacky, but conservativ=
e:

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 4b4e738c6f1b..456d05c5b18a 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1052,7 +1052,9 @@ int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, stru=
ct kvm_xen_vcpu_attr *data)
                 */
                if (vcpu->arch.xen.timer_expires) {
                        hrtimer_cancel(&vcpu->arch.xen.timer);
+                       mutex_unlock(&vcpu->kvm->arch.xen.xen_lock);
                        kvm_xen_inject_timer_irqs(vcpu);
+                       mutex_lock(&vcpu->kvm->arch.xen.xen_lock);
                }
=20
                data->u.timer.port =3D vcpu->arch.xen.timer_virq;


