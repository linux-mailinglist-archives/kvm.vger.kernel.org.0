Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53C89406518
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 03:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbhIJBYb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 21:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239046AbhIJBXx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 21:23:53 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6629C0613F0
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 18:20:12 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id j6so107444pfa.4
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 18:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=l1BaiJ0gkfVc+LassnfOFyf+t5gSZ1M94cRU4Np2S3E=;
        b=lRZULPzquMYXgjWpDLxvVy0w2xSJmX+cTY5Vo1mT7JVv4iOOIHpuhallgZBWM3UV8Y
         g5zvaF+AXZmGPXoF994p9zbyTSrNg8eVjDoMXkbVaEsLKkQCyiKxoRk/O64LYQHWIoRX
         mLEMDAFihI3lvz0+x1U5zk/YbBx7jug7JGvgdOoUSm2BCSQT/gxzv3Cya28Z00vjvrxs
         NJFh8f7d2Hkk4j4eVYdvR47Z2FK8lHFIkp6oS+ZkEhFLzlhwYHMPgiiac2Q2vWK8KOcF
         BGRnQZc6E3IkALkdxl6TZ3cPslOydT7LcxHiZBq/0v4cW4nWvV5or2vXVLTwbyPd7NyD
         qGlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l1BaiJ0gkfVc+LassnfOFyf+t5gSZ1M94cRU4Np2S3E=;
        b=3OPIogLkb3f+gLOxkaCqfm8b843kHmDDXFVCz8mOYdtBxMMmHSsUbLS5Q77vt9upTz
         cfEhhzk+R7mJoUCXn2RrvbzK+XmYx82Nmcj58Pw5wCH85L4ubxOm3tEKthTpICYXAyOz
         jOupv1iWlDt46kkRM/So4wR7eBV8t8Gl9wFlp9CbYrXKaxgrY4WTWMz83NiFsB2vjLC/
         VzD+GMvLk9OL2Zf9EW90AcqtFgrX9n4TgMBKJSsPyTs7ZzAsejYt1wvNtjLfnYbr8zQz
         R95a7Uinw+1rVW07mff5wCfazaBUxgbv4lAwJ7TbmdNi7KN6tHd1sQNZ1qSutQHbjAIh
         N9cA==
X-Gm-Message-State: AOAM531q9VBCocSgYvveg++CyPf5xpXUujRJ6OuwxGENWc70y8QvHdaO
        g99ZV/KnNWHJ/0mV7ZODn/Ycyg==
X-Google-Smtp-Source: ABdhPJzHzyqGH27s4iQz3a74J/nl5ISKqP8M0YqLRj+/BKN0zmR4qpUN/S5JSa+y73tnLcrpAgSpTg==
X-Received: by 2002:a05:6a00:1789:b0:3f9:5ce1:9677 with SMTP id s9-20020a056a00178900b003f95ce19677mr5738445pfg.50.1631236812187;
        Thu, 09 Sep 2021 18:20:12 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id w24sm3381673pjh.30.2021.09.09.18.20.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 18:20:11 -0700 (PDT)
Date:   Fri, 10 Sep 2021 01:20:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3 V7] KVM, SEV: Add support for SEV-ES intra host
 migration
Message-ID: <YTqyx0J0Ik7wqx/+@google.com>
References: <20210902181751.252227-1-pgonda@google.com>
 <20210902181751.252227-3-pgonda@google.com>
 <YTqr4nuXYVFz81kD@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTqr4nuXYVFz81kD@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 10, 2021, Sean Christopherson wrote:
> On Thu, Sep 02, 2021, Peter Gonda wrote:
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index 8db666a362d4..fac21a82e4de 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -1545,6 +1545,59 @@ static void migrate_info_from(struct kvm_sev_info *dst,
> >  	list_replace_init(&src->regions_list, &dst->regions_list);
> >  }
> >  
> > +static int migrate_vmsa_from(struct kvm *dst, struct kvm *src)

Better to call this sev_es_migrate_from()...

> > +{
> > +	int i, num_vcpus;
> > +	struct kvm_vcpu *dst_vcpu, *src_vcpu;
> > +	struct vcpu_svm *dst_svm, *src_svm;
> > +

...because this should also clear kvm->es_active.  KVM_SEV_INIT isn't problematic
(as currently written) because the common sev_guest_init() explicitly writes es_active,
but I think a clever userspace could get an SEV ASID into an "ES" guest via
KVM_CAP_VM_COPY_ENC_CONTEXT_FROM, which requires its dst to be !SEV and thus
doesn't touch es_active.

Huh, that's a bug, svm_vm_copy_asid_from() should explicitly disallow copying the
ASID from an SEV-ES guest.  I'll send a patch for that.

Last thought, it's probably worth renaming migrate_info_from() to sev_migrate_from()
to pair with sev_es_migrate_from().
