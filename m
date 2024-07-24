Return-Path: <kvm+bounces-22197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 99A5393B67A
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 20:13:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EA3BDB2265E
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 18:13:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ABD215F3EF;
	Wed, 24 Jul 2024 18:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R4NQ/B8f"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D762D792
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 18:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721844801; cv=none; b=qVrD/0crPZgBttWqDlFtVoijirWbYyitoEDzBZN3rMvVUNSGCKtPteHktw0CuK8TtDGG+5qZs9kjxJ7TazMYtcJg2DOjjVmojNsJ1dqBTfZzltsGhx6XO968xfQfehhPk3FflRMnnMUi1pMithslsnWptD4/Qfge6qkAWaUZtO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721844801; c=relaxed/simple;
	bh=9lCrRvH7bCgy1LGtSJCV7fhoGThabQ9QHHGLvYCMW6s=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=L3naSg/u3M5Az0/vKXTy/sSFFvmBov6EaUj568JKkUwaCEvNzqDjio73opyOGnIUdEM3ej1GdkleuE91LBrnqkvrMulu5vMgqjKMwCjE3rNlqe9hlsROuCwA2CSgTh31Fnpe5StI/o3Zvu0rN1ejccjbpJ2pjCcD9iG1pJvI5ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R4NQ/B8f; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721844798;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l/BlWYtZiqrvhhOyFFImvY2g7dydV2xBTj36pWBJdp8=;
	b=R4NQ/B8fVq56far1tOWyCWCe/hIBjDC6rYorQuEgaL3VIn+UlTTFSjQvb3UOYgYq3qPLwc
	vZ8WBnoYmWxDmo642FC8Dqs+Lqhh7CA/BPCNymvYEK4lnW6jjRYwLWvE8CFSMmYV9OWz7v
	pPsY6BhLwbLdmLrHIJkxqqPyTEixNIk=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-396-MyGoalAiNsi2wZyJyJtrGg-1; Wed, 24 Jul 2024 14:13:17 -0400
X-MC-Unique: MyGoalAiNsi2wZyJyJtrGg-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6b5cec74f1dso981866d6.3
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 11:13:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721844796; x=1722449596;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=l/BlWYtZiqrvhhOyFFImvY2g7dydV2xBTj36pWBJdp8=;
        b=MHExgEAMHNsSpXri8Yjmj8avgAxszwCXX+nZNauUmpPe+csnPyekqbquHPLMyWr/0T
         bPzDfGXYvJB3UF8ERcArzQ75RrKASmfAMAGH95RZpCs9znV4Z01QmKCfy2XdGYBSSCUQ
         wi1qKXu68Ir1PFxVZQnTt7F2+ZiRjIyNfx8F1nBkHhO4phf9L011Z0ksGddVxPjJPNmn
         cPay8Mc2AJy/kbsBAC8wXVdzLkvZVqnHVWoGXiIlj5n+tdBWqtRuubsIqA74hesezfAP
         om/N4Z5hTqEtdpP/KZW/t4EiCnFSHEYdkI/LxrFwDkDebhZ6Ivp3Ovhg4ynGKbWNrUeX
         9tuA==
X-Forwarded-Encrypted: i=1; AJvYcCXSWeh7aU+PajTlz4ipRO+5JVS5auHaazprLWBHR5REghM1sT08pkLl+WTIlJHcpbdQKRtVTXbLsRepLvVBF46DWsSO
X-Gm-Message-State: AOJu0Yztr6tNOK38CHnClkyNRpbFZ/sCCFm0+92qBEmRAQEa3mzsKCYg
	DdnUKtbZAKP5f+ws9IZ30POB2AIJzdWOUym6yPneFCJx5sKo9UbW/7svCqbL3ios7WeYZPX6MGZ
	mZqvoteTdoIyzgVXrdFrTRD6dHlNdqy3ybfttMetrfvzpIXYLqSmn3RIdWQ==
X-Received: by 2002:ad4:5961:0:b0:6b5:6a1:f89a with SMTP id 6a1803df08f44-6bb3c9ceafbmr4715006d6.2.1721844796474;
        Wed, 24 Jul 2024 11:13:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFKOJBgxULB0ubdx3PBhF2TMO5Pol0a/r8NgYn1osM6y0mcFawCvDW69OKO0TeR2O32MzTQ1g==
X-Received: by 2002:ad4:5961:0:b0:6b5:6a1:f89a with SMTP id 6a1803df08f44-6bb3c9ceafbmr4714856d6.2.1721844796138;
        Wed, 24 Jul 2024 11:13:16 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b7ac7d995csm60534766d6.40.2024.07.24.11.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jul 2024 11:13:15 -0700 (PDT)
Message-ID: <323bf4cc39f3e4dd3b95e0e25de35a7c0c2e9d2d.camel@redhat.com>
Subject: Re: [PATCH v2] KVM: x86: Complain about an attempt to change the
 APIC base address
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Jim Mattson <jmattson@google.com>, Sean Christopherson
 <seanjc@google.com>,  Paolo Bonzini <pbonzini@redhat.com>,
 kvm@vger.kernel.org
Date: Wed, 24 Jul 2024 14:13:14 -0400
In-Reply-To: <CALMp9eSTsGaAcEKkJ+=vWD4aHC3e_iOA8nnwWhGQdfBj_nj3-A@mail.gmail.com>
References: <20240625235554.2576349-1-jmattson@google.com>
	 <CALMp9eSTsGaAcEKkJ+=vWD4aHC3e_iOA8nnwWhGQdfBj_nj3-A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 2024-07-24 at 11:05 -0700, Jim Mattson wrote:
> On Tue, Jun 25, 2024 at 4:56 PM Jim Mattson <jmattson@google.com> wrote:
> > KVM does not support changing the APIC's base address. Prior to commit
> > 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or
> > APIC base"), it emitted a rate-limited warning about this. Now, it's
> > just silently broken.
> > 
> > Use vcpu_unimpl() to complain about this unsupported operation. Even a
> > rate-limited error message is better than complete silence.
> > 
> > Fixes: 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base")
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > ---
> >  Changes in v2:
> >   * Changed format specifiers from "%#llx" to "%#x"
> >   * Cast apic->base_address to unsigned int for printing
> > 
> >  arch/x86/kvm/lapic.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index acd7d48100a1..43ac05d10b2e 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -2583,6 +2583,9 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
> > 
> >         if ((value & MSR_IA32_APICBASE_ENABLE) &&
> >              apic->base_address != APIC_DEFAULT_PHYS_BASE) {
> > +               vcpu_unimpl(vcpu, "APIC base %#x is not %#x",
> > +                           (unsigned int)apic->base_address,
> > +                           APIC_DEFAULT_PHYS_BASE);
> >                 kvm_set_apicv_inhibit(apic->vcpu->kvm,
> >                                       APICV_INHIBIT_REASON_APIC_BASE_MODIFIED);
> >         }
> > --
> > 2.45.2.741.gdbec12cfda-goog
> 
> Ping.
> 
I think that we talked about this once, that nobody looks at these dmesg warnings,
its just a way for a malicious guest to fill up the host log (yes rate limit helps,
but slowly you can still fill it up),
but if you think that this is valuable, I am not against putting it back.

I wonder....

What if we introduce a new KVM capability, say CAP_DISABLE_UNSUPPORTED_FEATURES,
and when enabled, outright crash the guest when it attempts things like changing APIC base,
APIC IDs, and other unsupported things like that?

Then we can make qemu set it by default, and if users have to use an unsupported feature,
they could always add a qemu flag that will disable this capability.

Best regards,
	Maxim Levitsky


