Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E48838CA15
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 17:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237451AbhEUP3s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 11:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234421AbhEUP3q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 11:29:46 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6207C061574
        for <kvm@vger.kernel.org>; Fri, 21 May 2021 08:28:20 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 6so14477240pgk.5
        for <kvm@vger.kernel.org>; Fri, 21 May 2021 08:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=oPQ0WnpZS7sQjm0jySdRKiIFkASQYZuINbenVMidsQE=;
        b=kPraeU7i1keDTG3M4v8EV1gDxMm5N4/gL9Bu+jMvDUIOHHYosVCkIPSiT/7PRilvUj
         K3dHq/V+ahl8FL8qFNzlcovHvxxhWoX/YE45wEQsF1FvwdetZZEbkNbvBOAe8uRJF8G6
         y9ZgIwiXrl2zsi/oLMzxP9gfUR8/ZbVbAAajzlZdoS9At664CrzX1NCcxXFVuWblpQEW
         hq5k4PmeG8U+1d/yQa/XVsY5axZK3FDPCH2d2ZAJGCrM75OKaqEvRRs8wTmE5o5JB28u
         yxzNvm+KlKHXtMV0amfRNHNVNG/pY1p14gUjttgGIOJ9etzHBQonSuGwBkrmxXPmunsB
         x4XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=oPQ0WnpZS7sQjm0jySdRKiIFkASQYZuINbenVMidsQE=;
        b=aX7buNnqJ5vQfYECTfSgsDN4rMkXljcMT6J6d0JdBSO4ZLUzpPeQr1BRgI+NZSPm1r
         da0/Bz9qoDvPbDyaWeFAfP6CTMOaZ+8BDWJCYqFaLLKCDCZS1iG2/+nOMv+5y3qOTG3q
         nhdcN32MFF1cjn7+o9hYYALil6qzlff1HjxE80CYC70Cuk+lQ1tgSgPUSEpG7ukX3QAr
         MXKEE5x1CS6mpf6KIkOKrnRAYJR4aE2QVabfYd+f+v6LBjY9eshvex5kloyb2ib7fbd+
         SWiYFvB+rRxwhIasJ7EUZw90XsqKbqum5rqv5cTAst5ANKAsU9g8vV5OU8f7u+8+y35z
         u3Cg==
X-Gm-Message-State: AOAM533EtoY7ZitcM/M6q8ivS1mww/QqvTBBZEEv5/N2U4q/kmj1f28A
        TYr2NjdIo5MorRfzFmHexccto9ZKpccnRQ==
X-Google-Smtp-Source: ABdhPJyNwl4L0LAqQxcu4P2/JopvQN/kvMqdeiKhwquGCSmxH06eqIsAs2U0b3jaPXs8oKWMXOh7xw==
X-Received: by 2002:a63:338b:: with SMTP id z133mr10495627pgz.442.1621610900180;
        Fri, 21 May 2021 08:28:20 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id 13sm4737555pfz.91.2021.05.21.08.28.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 08:28:19 -0700 (PDT)
Date:   Fri, 21 May 2021 15:28:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/43] KVM: VMX: Set EDX at INIT with CPUID.0x1,
 Family-Model-Stepping
Message-ID: <YKfRj+I2Wa+t//lb@google.com>
References: <20210424004645.3950558-1-seanjc@google.com>
 <20210424004645.3950558-3-seanjc@google.com>
 <CAAeT=FyNo1CGvnamc3_J9EEQUn6WcdkMp50-QgmLYYVCFA2fZA@mail.gmail.com>
 <YKVdUtvSg7/I7Ses@google.com>
 <CAAeT=FxvS_hzcZbZQ_jQnWwX+xDT0SqQoHKELeviqu_QvvnbYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAeT=FxvS_hzcZbZQ_jQnWwX+xDT0SqQoHKELeviqu_QvvnbYg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 21, 2021, Reiji Watanabe wrote:
> On Wed, May 19, 2021 at 11:47 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Tue, May 18, 2021, Reiji Watanabe wrote:
> > > BTW, I would think having a default CPUID for CPUID.(EAX=0x1) would be better
> > > for consistency of a vCPU state for RESET.  I would think it doesn't matter
> > > practically anyway though.
> >
> > Probably, but that would require defining default values for all of CPUID.0x0 and
> > CPUID.0x1, which is a can of worms I'd rather not open.  E.g. vendor info, basic
> > feature set, APIC ID, etc... would all need default values.  On the other hand,
> > the EDX value stuffing predates CPUID, so using 0x600 isn't provably wrong, just
> > a bit anachronistic. :-)
> 
> I see... Then I don't think it's worth doing...
> Just out of curiosity, can't we simply use a vcpu_id for the APIC ID ?

That would mostly work, but theoretically we could overflow the 8 bit field
because max vCPUs is 288.  Thanks Larrabee.

  commit 682f732ecf7396e9d6fe24d44738966699fae6c0
  Author: Radim Krčmář <rkrcmar@redhat.com>
  Date:   Tue Jul 12 22:09:29 2016 +0200

    KVM: x86: bump MAX_VCPUS to 288

    288 is in high demand because of Knights Landing CPU.
    We cannot set the limit to 640k, because that would be wasting space.

> Also, can't we simply use the same values that KVM_GET_SUPPORTED_CPUID
> provides for other CPUID fields ?

Yes, that would mostly work.  It's certainly possible to have a moderately sane
default, but there's essentially zero benefit in doing so since practically
speaking all userspace VMMs will override CPUID anyways.  KVM could completely
default to the host CPUID, but again, it wouldn't provide any meaningful benefit,
while doing so would step on userspace's toes since KVM's approach is that KVM is
"just" an accelerator, while userspace defines the CPU model, devices, etc...
And it would also mean KVM has to start worrying about silly corner cases like
the max vCPUs thing.  That's why I say it's a can of worms :-)
