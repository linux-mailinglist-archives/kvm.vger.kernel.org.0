Return-Path: <kvm+bounces-3705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 863B98073AE
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 16:28:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 16C15B20FBB
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 15:28:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F23993FE4F;
	Wed,  6 Dec 2023 15:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YKOLXWIF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF238F
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 07:28:30 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5d8d3271ff5so49402117b3.2
        for <kvm@vger.kernel.org>; Wed, 06 Dec 2023 07:28:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701876510; x=1702481310; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q2Zk7LZFkJrqbk98V8qcnIqi5db7rirsasYPy61AijE=;
        b=YKOLXWIFIRiBKaH4Nr3rJHxku9fJ2hb1gCUL68PYSOMyDWDYrhsoJ5pCNbwgrmnHW6
         ahtohyPU9NM0ELYq2cezRwV2m7xSdv5Kdw2Be39hh/fDDv6edOU4lStbHE2CEtsGv7h2
         E77jaSu3/kvnMs+Qw70Wgwn0aMW7SnxhWJYDVrg3MYXhprsLzveQ1Azz/amcnLuKB7Po
         6OtOpFkUjmxg+qCVYBeZ+AS09GqHFd1iPWXgMCGNMCmsg+uG5J9UQ4NOh3sRZi/D930P
         V3arcdAETiCRyyNO4gIi0H81XKOAVUhUGlRHNXWiz898wHcUZME3YIY9mzkqU5lJfLoe
         m1kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701876510; x=1702481310;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q2Zk7LZFkJrqbk98V8qcnIqi5db7rirsasYPy61AijE=;
        b=X7QBvX9Odc5XVmo5EFp4MrXk1T5TP66cycNKen7JLSizkzTXo+xagulE137Qpc/NVX
         ueOI8g1SRiEbNrH+x8rII2JOSCfzdmUehh2y9BQ2+1Gtfrao1posssDESmxR79C3vpe3
         tP4kWux34Nfbpz6ISr/6E5i35fdmcJ+FgSE/QXs+NLAOKFgTNtIqrFXfvW70+VYogbf4
         f49QBThjGEqNShJrgQfsGyMbPXFNPdxiW9bhP5suZhOZpoBYQFtWh8Kd0a38+HyG1KQA
         uS536wAuJMpbwVrHbuH6gzgFNPpxENF4FJybrZkRtJKcEs2fx7RfjltdUz00iKSZp1eE
         b7jQ==
X-Gm-Message-State: AOJu0YwqnyET4ht2gz/ORgXg6e0iq9LP2WPkLGQRIYoo7LG1J4F9znIa
	zb0GSuz/lxrL1Edina85/sXwqcZFkno=
X-Google-Smtp-Source: AGHT+IFnWI9xL9aTBjbg9z4+Pw1EUfUFqpzKbyS+o+ev4AIyx+D9gzcJ65XKQcdPUhki3CM5Txy45imdEOo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:3209:b0:5d1:104a:acb5 with SMTP id
 ff9-20020a05690c320900b005d1104aacb5mr14428ywb.2.1701876510028; Wed, 06 Dec
 2023 07:28:30 -0800 (PST)
Date: Wed, 6 Dec 2023 07:28:28 -0800
In-Reply-To: <20231205234956.1156210-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231205234956.1156210-1-michael.roth@amd.com>
Message-ID: <ZXCTHJPerz6l9sPw@google.com>
Subject: Re: [PATCH] KVM: SEV: Fix handling of EFER_LMA bit when SEV-ES is enabled
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Dec 05, 2023, Michael Roth wrote:
> In general, activating long mode involves setting the EFER_LME bit in
> the EFER register and then enabling the X86_CR0_PG bit in the CR0
> register. At this point, the EFER_LMA bit will be set automatically by
> hardware.
> 
> In the case of SVM/SEV guests where writes to CR0 are intercepted, it's
> necessary for the host to set EFER_LMA on behalf of the guest since
> hardware does not see the actual CR0 write.
> 
> In the case of SEV-ES guests where writes to CR0 are trapped instead of
> intercepted, the hardware *does* see/record the write to CR0 before
> exiting and passing the value on to the host, so as part of enabling
> SEV-ES support commit f1c6366e3043 ("KVM: SVM: Add required changes to
> support intercepts under SEV-ES") dropped special handling of the
> EFER_LMA bit with the understanding that it would be set automatically.
> 
> However, since the guest never explicitly sets the EFER_LMA bit, the
> host never becomes aware that it has been set. This becomes problematic
> when userspace tries to get/set the EFER values via
> KVM_GET_SREGS/KVM_SET_SREGS, since the EFER contents tracked by the host
> will be missing the EFER_LMA bit, and when userspace attempts to pass
> the EFER value back via KVM_SET_SREGS it will fail a sanity check that
> asserts that EFER_LMA should always be set when X86_CR0_PG and EFER_LME
> are set.
> 
> Fix this by always inferring the value of EFER_LMA based on X86_CR0_PG
> and EFER_LME, regardless of whether or not SEV-ES is enabled.

Blech.  This is a hack to fix even worse hacks.  KVM ignores CR0/CR4/EFER values
that are set via KVM_SET_SREGS, i.e. KVM is rejecting an EFER value that it will
never consume, which is ridiculous.  And the fact that you're not trying to have
KVM actually set state further strengthens my assertion that tracking CR0/CR4/EFER
in KVM is pointless necessary for SEV-ES+ guests[1].

This also fixes the _source_, which makes it far less useful, e.g. live migrating
to fixed version of KVM won't work.

So my very strong preference is to first skip the kvm_is_valid_sregs() check, and
then in a follow-up series disable the CR0/CR4/EFER traps and probably use maximal
(according to the guest's capabilities) "defaults" for CR0/CR4/EFER (and I suppose
XCR0 and XSS too), i.e. assume the vCPU is in 64-bit mode with everything enabled.

My understanding is that SVM_VMGEXIT_AP_CREATION is going to force KVM to assume
maximal state anyways since KVM will have no way of verifying what state is actually
shoved into the VMSA, i.e. emulating INIT is wildly broken[2].

Side topic, Peter suspected that KVM _does_ need to let userspace set CR8 since
that's not captured in the VMSA[3].

[1] https://lore.kernel.org/all/YJla8vpwqCxqgS8C@google.com
[2] https://lore.kernel.org/all/20231016132819.1002933-38-michael.roth@amd.com
[3] https://lore.kernel.org/all/CAMkAt6oL9tfF5rvP0htbQNDPr50Zk41Q4KP-dM0N+SJ7xmsWvw@mail.gmail.com

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2c924075f6f1..6fb2b913009e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11620,7 +11620,8 @@ static int __set_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs,
        int idx;
        struct desc_ptr dt;
 
-       if (!kvm_is_valid_sregs(vcpu, sregs))
+       if (!vcpu->arch.guest_state_protected &&
+           !kvm_is_valid_sregs(vcpu, sregs))
                return -EINVAL;
 
        apic_base_msr.data = sregs->apic_base;

