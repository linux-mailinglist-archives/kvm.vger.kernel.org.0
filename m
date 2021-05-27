Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A635539363C
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 21:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235065AbhE0TaJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 15:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234071AbhE0TaI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 May 2021 15:30:08 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3836FC061574
        for <kvm@vger.kernel.org>; Thu, 27 May 2021 12:28:34 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id g18so1374879pfr.2
        for <kvm@vger.kernel.org>; Thu, 27 May 2021 12:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/O5ZhuBU+E+S9yjOSjBJ2tbmDg0k5UnIlNPV88NbNt8=;
        b=LoaeLRZlDL3Zq3Zd/tewzbdTcRqd2FoIe2Ud3xVPjrou4mOgWkVGVhVv+yi2Etdq0C
         JmvQQYY24N5EwBAXiJxrehqSo7HmuxfEDwPgstNdh3QYHUmI53WoTnYGS36k877OfA+1
         saZWbIYrWK66PHlsX4RrzOiuMpPD5Oga7jHWPBI9zhOsxTAEVKF9Q3xkH700R4xEAMf4
         LBzjyqSkXjZfiriZXMgYeVAqg9AIJO754AwePcmLCuIb570ChLM5GaUbJ1iiE9TER7aF
         pCUezaNaivUZjPQJZlHlxFq6U/X0ENbEWroeJllH3T9JRGR5A7rBheWeMGaSD8HENDr8
         4Msw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/O5ZhuBU+E+S9yjOSjBJ2tbmDg0k5UnIlNPV88NbNt8=;
        b=awb3yJ35kt3nRL42BZd/YcLtAI/JcSwIX3zKf0PyMK2I5qCOI7zccMiRb8uzdJVPpK
         l7hJ9W2NgOLK6H1F5k4e1YfDOrU+SCXvRBIUMaDY1L0zr/dlC8twTKpoQ4DB0tk3LF1w
         U7NK/I5ZNbqOLxs3yf9frGubVTxdQItLbqR/Pfrlc5UgLGniWZiw/vAagR6mIlwTCREi
         4VALQv2xuSOoK99yI7Cmqny+F+CE7+29W5GzzixQ7TWJhKwmCtxBnN7n+/lOR7rFGnA7
         6UUqOTCp6/4Um460MrrphI2o+JnAu6HVT3p+u6hDQlZ21cNR1KP64JdHTutk/7/JCE2n
         aWDg==
X-Gm-Message-State: AOAM531nBmRN5neSYyZNXPl6ZvmBU1pNIKJyLLqNORls+QIrvOn7HhdX
        c+5ZC+2y+AH7rQWYtbgwNh4tIA==
X-Google-Smtp-Source: ABdhPJyxUO8wraNuT3RiXmkpiKZMNkAonQRla5oCtqEG/+FP940vF05hrfXq1ETZufBsWncVy5pwEw==
X-Received: by 2002:a05:6a00:88b:b029:2de:33b3:76c9 with SMTP id q11-20020a056a00088bb02902de33b376c9mr24401pfj.30.1622143713551;
        Thu, 27 May 2021 12:28:33 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id r4sm2404750pff.197.2021.05.27.12.28.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 12:28:32 -0700 (PDT)
Date:   Thu, 27 May 2021 19:28:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: X86: fix tlb_flush_guest()
Message-ID: <YK/y3QgSg+aYk9Z+@google.com>
References: <20210527023922.2017-1-jiangshanlai@gmail.com>
 <78ad9dff-9a20-c17f-cd8f-931090834133@redhat.com>
 <YK/FGYejaIu6EzSn@google.com>
 <YK/FbFzKhZEmI40C@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YK/FbFzKhZEmI40C@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 27, 2021, Sean Christopherson wrote:
> > KVM_REQ_MMU_RELOAD is overkill, nuking the shadow page tables will completely
> > offset the performance gains of the paravirtualized flush.

Argh, I take that back.  The PV KVM_VCPU_FLUSH_TLB flag doesn't distinguish
between flushing a specific mm and flushing the entire TLB.  The HyperV usage
(via KVM_REQ) also throws everything into a single bucket.  A full RELOAD still
isn't necessary as KVM just needs to sync all roots, not blast them away.  For
previous roots, KVM doesn't have a mechanism to defer the sync, so the immediate
fix will need to unload those roots.

And looking at KVM's other flows, __kvm_mmu_new_pgd() and kvm_set_cr3() are also
broken with respect to previous roots.  E.g. if the guest does a MOV CR3 that
flushes the entire TLB, followed by a MOV CR3 with PCID_NOFLUSH=1, KVM will fail
to sync the MMU on the second flush even though the guest can technically rely
on the first MOV CR3 to have synchronized any previous changes relative to the
fisrt MOV CR3.

Lai, if it's ok with you, I'll massage this patch as discussed and fold it into
a larger series to fix the other bugs and do additional cleanup/improvements.

> > I believe the minimal fix is:
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 81ab3b8f22e5..b0072063f9bf 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -3072,6 +3072,9 @@ static void kvm_vcpu_flush_tlb_all(struct kvm_vcpu *vcpu)
> >  static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
> >  {
> >         ++vcpu->stat.tlb_flush;
> > +
> > +       if (!tdp_enabled)
> > +               kvm_mmu_sync_roots(vcpu);
> >         static_call(kvm_x86_tlb_flush_guest)(vcpu);
> >  }
