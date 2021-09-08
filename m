Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5163403F2D
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 20:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350161AbhIHSnh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 14:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350029AbhIHSnf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 14:43:35 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21437C061757
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 11:42:27 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id n4so1855813plh.9
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 11:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ABvGIs5eX2JcG2RKOXdfPuOSsqXlbFksA1bqMpiHrKg=;
        b=gggg8QY83kYOHmlQFwrqwpTrxRQ37OKExGKYl+YcDgMR4e8uWIDSoRYCkqZwj+ddht
         zO23SG38AW+h3fnG5RPY72UcoFxK8l9NEIPJIfKiRfR3MlK7YJSeNR3br+isPCUUcmF9
         NvUUh8Y6VgCFCFuNiWn2L2OtxHjmecXPgNcqWVTwt8vNbTqo9iN7Oyw4uoOEKXVo8wsY
         C24bb9xHQJ9d2f1psLLQxW8qq/bcwWnjXjrnsqhRPbMeVP2VOjlzShjL5fDK4rprKmIR
         BlM6H+e3TxMX7aykAeiOxIPcrU5MTW4PB6oJSYCzVAe6mp8245j2H0vElw0rO1pqB+Yf
         K+IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ABvGIs5eX2JcG2RKOXdfPuOSsqXlbFksA1bqMpiHrKg=;
        b=DgIuwpgk+1WKYTTq2Sp0GSV82VgagpdLj+Z1BXL2wf5Ey5c21ak83hcR04SbivG6kk
         yx/KOQ5/vhKbfwyJMpNYwvG4ElEC6Qqs2g5Hc6I7DBHWmlooEcGxqdYb8eUpVL/m4GHH
         qfoHgzzkjdbbo4eLNivNUtGdWtbU7fo42a2XXaE3Ial2A6lok0KKmrIHDj3lToO6mnyr
         ikUN4hgpBkLXgVLqu60/ImkhMDrjT+uXzvQwi5TffLl8Vg4YA5rMZRZCVYo2mD9O5U6C
         P0G9HmMl97i6mTnVp8d6XGrS/e6eoTXWo79ezMSwstAupmPh2P3qyQK4yRjwUUbGRtkM
         rV/g==
X-Gm-Message-State: AOAM532FduPS1bcE6Pk4t2oS+oM25PiwzyCqZ0u6Y8Stkpopj/80aipo
        g/OWSGekNGL0h5DBbrhyNIokNg==
X-Google-Smtp-Source: ABdhPJy4e/vI56FcplVnGf0mW1f0p2XiKwuKf2Umtrz+2M+vgo8laMp7d1jaXTbTS/HdfYOrprWQZw==
X-Received: by 2002:a17:90b:1102:: with SMTP id gi2mr5638781pjb.43.1631126546438;
        Wed, 08 Sep 2021 11:42:26 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j4sm2924229pjc.46.2021.09.08.11.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 11:42:25 -0700 (PDT)
Date:   Wed, 8 Sep 2021 18:42:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Jiang Jiasheng <jiasheng@iscas.ac.cn>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        pbonzini@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, jarkko@kernel.org,
        dave.hansen@linux.intel.com
Subject: Re: [PATCH 4/4] KVM: X86: Potential 'index out of range' bug
Message-ID: <YTkEDoe8R5JJ77+B@google.com>
References: <1630655700-798374-1-git-send-email-jiasheng@iscas.ac.cn>
 <87czppnasv.fsf@vitty.brq.redhat.com>
 <YTI5SYVTJHiMdm+W@google.com>
 <87tuiy3qtc.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tuiy3qtc.fsf@vitty.brq.redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 06, 2021, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Fri, Sep 03, 2021, Vitaly Kuznetsov wrote:
> >> Jiang Jiasheng <jiasheng@iscas.ac.cn> writes:
> >> 
> >> > The kvm_get_vcpu() will call for the array_index_nospec()
> >> > with the value of atomic_read(&(v->kvm)->online_vcpus) as size,
> >> > and the value of constant '0' as index.
> >> > If the size is also '0', it will be unreasonabe
> >> > that the index is no less than the size.
> >> >
> >> 
> >> Can this really happen?
> >> 
> >> 'online_vcpus' is never decreased, it is increased with every
> >> kvm_vm_ioctl_create_vcpu() call when a new vCPU is created and is set to
> >> 0 when all vCPUs are destroyed (kvm_free_vcpus()).
> >> 
> >> kvm_guest_time_update() takes a vcpu as a parameter, this means that at
> >> least 1 vCPU is currently present so 'online_vcpus' just can't be zero.
> >
> > Agreed, but doing kvm_get_vcpu() is ugly and overkill.
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 86539c1686fa..cc1cb9a401cd 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -2969,7 +2969,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
> >                                        offsetof(struct compat_vcpu_info, time));
> >         if (vcpu->xen.vcpu_time_info_set)
> >                 kvm_setup_pvclock_page(v, &vcpu->xen.vcpu_time_info_cache, 0);
> > -       if (v == kvm_get_vcpu(v->kvm, 0))
> > +       if (!kvm_vcpu_get_idx(v))
> 
> Do we really need to keep kvm_vcpu_get_idx() around though? It has only
> 3 users, all in arch/x86/kvm/hyperv.[ch], and the inline simpy returns
> 'vcpu->vcpu_idx'.

Nope, looks like it's a holdover from before the introduction of vcpu_idx.  I'll
send a small series to jettison the wrapper and make the above change.

Thanks!
