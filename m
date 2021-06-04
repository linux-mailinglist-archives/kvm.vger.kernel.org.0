Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97CB839B5CC
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 11:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbhFDJWW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 05:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbhFDJWW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 05:22:22 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 347D0C061763
        for <kvm@vger.kernel.org>; Fri,  4 Jun 2021 02:20:36 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id x10so4340008plg.3
        for <kvm@vger.kernel.org>; Fri, 04 Jun 2021 02:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mBAEhjZZRv7Jcy7Zua0pi2TsECX3PFBDfNxkyFGsLO0=;
        b=GFzrB6mDdP8QDUkM5E2D3SpI1YuNW543kJ1Zx1kk0NuEJ9dY60dkreacgqq7B7HMEs
         uqcy1p2HaKtSeecuRPdMc+ZpGU/OEc3CdNONynbGrv/3vMYyT7bl4zUw0YUQ9/GOQcn/
         p9MzmRmMsJwpomp+rOKp0w+JG2E9nloY+xf18=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mBAEhjZZRv7Jcy7Zua0pi2TsECX3PFBDfNxkyFGsLO0=;
        b=GYf5xOBu3/+lelX/p8JKwJevsHmi/nxQw8IuxVvDjTpkn7F62DPIoG52VLgF+V8ACT
         8iEnzv3y+DdEx8hFl3sKQKH/AoB2cU9yRuKw0foYBvrPDhxoC8sZjMA7dj4H4vmKdKbC
         pLYdR88y+KN/36JSt8QWQvHzZD85ZpIN2MqkSZMMsf0swvedYGIlVjVL7ZZJoE2F0Fsv
         jMntE0GHmriszGaRCB9+sSWLQxkrbCOWxZ4dFp1fT3g2xcT2njYgtU3cSj++yvN5dcms
         qA3Mjlsbimctaupo2kzSBc3VoyZ4apmCoPAFGI0uXbYaXE+mCVw/IY1UpngjOcavNEeu
         3CJQ==
X-Gm-Message-State: AOAM532gGSrP6e1+Sx3xZY16pw3/Nh9mWR5ZcjSiOai1WYGYyTZmRJbh
        m+qcXXLC5iouMvdhtMN+a4Gyug==
X-Google-Smtp-Source: ABdhPJxqC/sFmH8NWFwbR+x7mytZyDKEx7TFmgf8/+UGv7fZox1XEZk3IYhTIOf3hSBOmUz/xertuQ==
X-Received: by 2002:a17:90b:607:: with SMTP id gb7mr3845129pjb.5.1622798435671;
        Fri, 04 Jun 2021 02:20:35 -0700 (PDT)
Received: from google.com ([2409:10:2e40:5100:36b:f5b6:c380:9ccf])
        by smtp.gmail.com with ESMTPSA id p19sm4236799pjv.21.2021.06.04.02.20.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 02:20:34 -0700 (PDT)
Date:   Fri, 4 Jun 2021 18:20:28 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Suleiman Souhlal <suleiman@google.com>, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [RFC][PATCH] kvm: add suspend pm-notifier
Message-ID: <YLnwXD5pPplTrmoZ@google.com>
References: <20210603164315.682994-1-senozhatsky@chromium.org>
 <87v96uyq2v.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v96uyq2v.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On (21/06/04 09:46), Marc Zyngier wrote:
[..]
> > +void kvm_arch_pm_notifier(struct kvm *kvm)
> > +{
> > +#ifdef CONFIG_PM
> > +	int c;
> > +
> > +	mutex_lock(&kvm->lock);
> > +	for (c = 0; c < kvm->created_vcpus; c++) {
> > +		struct kvm_vcpu *vcpu = kvm->vcpus[c];
> > +		int r;
> > +
> > +		if (!vcpu)
> > +			continue;
> 
> Wouldn't kvm_for_each_vcpu() avoid this kind of checks?

Right, that's what I do in v2, which I haven't posted yet.

[..]
> > +#include <linux/notifier.h>
> > +
> >  #ifndef KVM_MAX_VCPU_ID
> >  #define KVM_MAX_VCPU_ID KVM_MAX_VCPUS
> >  #endif
> > @@ -579,6 +581,10 @@ struct kvm {
> >  	pid_t userspace_pid;
> >  	unsigned int max_halt_poll_ns;
> >  	u32 dirty_ring_size;
> > +
> > +#ifdef CONFIG_PM
> > +	struct notifier_block pm_notifier;
> > +#endif
> 
> I'd certainly like to be able to opt out from this on architectures
> that do not implement anything useful in the PM callbacks.

Well on the other hand PM-callbacks are harmless on those archs, they
won't overload the __weak function.

> Please consider making this an independent config option that individual
> archs can buy into.

Sure, I can take a look into this, but how is this better than __weak
function? (that's a real question)

[..]
> > +#ifdef CONFIG_PM
> > +static int kvm_pm_notifier_call(struct notifier_block *bl,
> > +				unsigned long state,
> > +				void *unused)
> > +{
> > +	struct kvm *kvm = container_of(bl, struct kvm, pm_notifier);
> > +
> > +	switch (state) {
> > +	case PM_HIBERNATION_PREPARE:
> > +	case PM_SUSPEND_PREPARE:
> > +		kvm_arch_pm_notifier(kvm);
> 
> How about passing the state to the notifier callback? I'd expect it to
> be useful to do something on resume too.

For different states we can have different kvm_arch functions instead.
kvm_arch_pm_notifier() can be renamed to kvm_arch_suspend_notifier(),
so that we don't need to have `switch (state)` in every arch-code. Then
for resume/post resume states we can have kvm_arch_resume_notifier()
arch functions.

> > +		break;
> > +	}
> > +	return NOTIFY_DONE;
> > +}
> > +
> > +static void kvm_init_pm_notifier(struct kvm *kvm)
> > +{
> > +	kvm->pm_notifier.notifier_call = kvm_pm_notifier_call;
> > +	kvm->pm_notifier.priority = INT_MAX;
> 
> How is this priority determined?

Nothing magical here. I want this to be executed first, before we suspend
ftrace, RCU and the like. Besides KVM is usually the last one to register
its PM callbacks, so there can be something on the notifier list that
returns NOTIFY_STOP_MASK in front of KVM PM-notifier list entry.
