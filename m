Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1F1406508
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 03:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234750AbhIJBXD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 21:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231868AbhIJBW7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 21:22:59 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C748FC0698D6
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 18:12:40 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id j1so283222pjv.3
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 18:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uVOCS25mxvjBZ7GClAgZG2jOvpBEyDT5oWpJ4su1Yt0=;
        b=de/KxNe+EOHGeJ83TPp3H465bkg1HK9EVB2o1dpG4Iweuobaf5S23Z/tmwKRyGCUwF
         hsDQbLEk9Lq9p1hCSNh1uONQRtnygBLOdlRdb3wRNe07D0X8G6TzVoN01vqeF0IBebdH
         xPBCopRxx/tA3DCHTKIRULdAS+P+r1E9732rExTvVGNCKAL9eNwfeVZqTvzMuHxe9Ook
         KJX3WdXIg9rI0WJxmr6cm5KbuXMlvJhlcE8duAKulN3TxS7yC+f/UZO5PyfjXDQSS8ZC
         shv23XJR+zsX8LpcPWOxJ32MAXvtB16IWSGCIxm1H9yADYaumBKX9zkizDMQKjR9uAHz
         80sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uVOCS25mxvjBZ7GClAgZG2jOvpBEyDT5oWpJ4su1Yt0=;
        b=rrqAfA8O1fg23zY51p5k9TZojZBQtHPKZy2haqI08hbuP4r2hr4hKTQu8okOOE264F
         HApKm68fWJWbJpWVr0dleilm8ZAQWPUHMOANfrfjsJchSVH27zlO7KCfzBTU4ykJFrQF
         VkIxDCd7wOMYVBNI+eGLnfTCPUmGj+2Enb31El/uC+5UCVkwP4NB8nkwYLT9C5wt5XHJ
         6s7fwuLp5w+q9y+BoLAtkxC1gR6LJ+b8q1wX0R0URY8cl40ND+soLtW+RUyQeM3S/uY7
         dEcOxx4rxP/2uV6YTSyiaODyJ+rpAvbspkHg7f3Pv+Qxu8MZrTegTM1iEyc/y4jaUFFC
         zxiQ==
X-Gm-Message-State: AOAM532lPuuFqxBIxGDw3z+JvJwz8F9MTjCAagXzcOGp/DB697Pv/msx
        lrgLkBbjaUBcCPhLqDE7PYw79A==
X-Google-Smtp-Source: ABdhPJyc0QiINKvWbWZq746qOMozDTpBT10Tb6tAjhwfvQj5xHDA5QLN9YlMi2NrjpBfPN1M7S/75Q==
X-Received: by 2002:a17:902:c389:b0:13a:56c8:6696 with SMTP id g9-20020a170902c38900b0013a56c86696mr5260115plg.70.1631236360033;
        Thu, 09 Sep 2021 18:12:40 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t28sm3429475pfe.144.2021.09.09.18.12.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 18:12:39 -0700 (PDT)
Date:   Fri, 10 Sep 2021 01:12:35 +0000
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
Subject: Re: [PATCH 1/3 V7] KVM, SEV: Add support for SEV intra host migration
Message-ID: <YTqxA23XRryWfCuA@google.com>
References: <20210902181751.252227-1-pgonda@google.com>
 <20210902181751.252227-2-pgonda@google.com>
 <YTqirwnu0rOcfDCq@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTqirwnu0rOcfDCq@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 10, 2021, Sean Christopherson wrote:
> Ooh, this brings up a potential shortcoming of requiring @dst to be SEV-enabled.
> If every SEV{-ES} ASID is allocated, then there won't be an available ASID to
> (temporarily) allocate for the intra-host migration.  But that temporary ASID
> isn't actually necessary, i.e. there's no reason intra-host migration should fail
> if all ASIDs are in-use.

...

> So I think the only option is to take vcpu->mutex for all vCPUs in both @src and
> @dst.  Adding that after acquiring kvm->lock in svm_sev_lock_for_migration()
> should Just Work.  Unless userspace is misbehaving, the lock won't be contended
> since all vCPUs need to be quiesced, though it's probably worth using the
> mutex_lock_killable() variant just to be safe.

Circling back to this after looking at the SEV-ES support, I think the vCPUs in
the source VM need to be reset via kvm_vcpu_reset(vcpu, false).  I doubt there's
a use case for actually doing anything with the vCPU, but leaving it runnable
without purging state makes me nervous.

Alternative #1 would be to mark vCPUs as dead in some way so as to prevent doing
anything useful with the vCPU.

Alternative #2 would be to "kill" the source VM by setting kvm->vm_bugged to
prevent all ioctls().

The downside to preventing future ioctls() is that this would need to be the
very last step of migration.  Not sure if that's problematic?
