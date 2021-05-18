Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA0D338814F
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 22:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236538AbhERUZG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 16:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236397AbhERUZG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 16:25:06 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6D5C06175F
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 13:23:47 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id b13-20020a17090a8c8db029015cd97baea9so2328876pjo.0
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 13:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yfdC9MEFNEaHgaQGSz7w95epIWVLZWnSDFN+a7r21Fc=;
        b=G624B0FUpxD2VDJtkGQ6d5UsyqFf+SBfNBxc1MwrEdRGX0Vn+uRdHMutZTSFZY+eSw
         wpbXB8g0u0hQRR6wVHn7OMK8fuEIM9e8XR+uVxDbWLnjK6VDApDXj34aKfFOdE3qRbzP
         rR0ieRntsugS3as9T1zXf4lMSCZNwYGcDA1AQNupZhaBplXwtEpdE8nQlSvSBPIU6t5U
         4d0Wcf4NYCkaXC2lQePwIQilMuFlylYi7As4oCKqDAG2QiaB6sWH9KZ/QoL6SKEyw1c4
         oXx23p2ECBSYar69X+iu+lbtWdp3IVHZ6qsVtORrxGLbMqHpyn/bF35eVkBnmSZNKwNi
         zbKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yfdC9MEFNEaHgaQGSz7w95epIWVLZWnSDFN+a7r21Fc=;
        b=QNm6bFFXsmLYFfnO3ZqPQKpalAdtc3YMzvgWmsP3RA6KHnasJ6uY2Gf+7ibKFxbbkn
         PcnOXSXEyAbY+WiYKeUNoy2Zpy0qfRWR2DjblI9DyAlpyoZBuGOsl4Ss0LlB9xc5AQW4
         wEU8AEmEY0bhj2UFnc3sGm/LDNWuzJVN8BPMvxjlGyEtkP2seiMgG1BLFywkjG/J+5JO
         xNHivvKTDGr1ZKCbJLiMoES0fYHz6G20b0wiwcdIOage/sNUIiA5Q4rlGTRMyuTxC7Ir
         pznDkZuE0v81kjAYrkHVyGorUoHj7xcXAjQ4QzqINOtEnEJt6QDDNDx/ANUjNFzfpben
         SMBg==
X-Gm-Message-State: AOAM5323MZRr9WkYpTNy5LKVerLU2mZnOXLVGExlAIIdLrdKe2zVuqvG
        nB1+JzqxQ2gA5WOzqEYxqhRlVA==
X-Google-Smtp-Source: ABdhPJxL5bZ2lIk+WLm4cKEqzVy/igHjT7SLviPr/5B6ZKoHBnQgNC5bFWEXQ+ivIObSuOGN5grV+g==
X-Received: by 2002:a17:90a:5d93:: with SMTP id t19mr7294307pji.116.1621369426302;
        Tue, 18 May 2021 13:23:46 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id y13sm8198630pgp.16.2021.05.18.13.23.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 13:23:45 -0700 (PDT)
Date:   Tue, 18 May 2021 20:23:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/43] KVM: x86: Properly reset MMU context at vCPU
 RESET/INIT
Message-ID: <YKQiTlDG1sZ4Zd2E@google.com>
References: <20210424004645.3950558-1-seanjc@google.com>
 <20210424004645.3950558-7-seanjc@google.com>
 <CAAeT=FzS0bP_7_wz6G6cL8-7pudTD7fhavLCVsOE0KnPXf99dQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeT=FzS0bP_7_wz6G6cL8-7pudTD7fhavLCVsOE0KnPXf99dQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 17, 2021, Reiji Watanabe wrote:
> >  void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> >  {
> > +       unsigned long old_cr0 = kvm_read_cr0(vcpu);
> > +       unsigned long old_cr4 = kvm_read_cr4(vcpu);
> > +
> >         kvm_lapic_reset(vcpu, init_event);
> >
> >         vcpu->arch.hflags = 0;
> > @@ -10483,6 +10485,10 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> >         vcpu->arch.ia32_xss = 0;
> >
> >         static_call(kvm_x86_vcpu_reset)(vcpu, init_event);
> > +
> > +       if (kvm_cr0_mmu_role_changed(old_cr0, kvm_read_cr0(vcpu)) ||
> > +           kvm_cr4_mmu_role_changed(old_cr4, kvm_read_cr4(vcpu)))
> > +               kvm_mmu_reset_context(vcpu);
> >  }
> 
> I'm wondering if kvm_vcpu_reset() should call kvm_mmu_reset_context()
> for a change in EFER.NX as well.

Oooh.  So there _should_ be no need.   Paging has to be enabled for EFER.NX to
be relevant, and INIT toggles CR0.PG 1=>0 if paging was enabled and so is
guaranteed to trigger a context reset.  And we do want to skip the context reset,
e.g. INIT-SIPI-SIPI when the vCPU has paging disabled should continue using the
same MMU.

But, kvm_calc_mmu_role_common() neglects to ignore NX if CR0.PG=0, and so the
MMU role will be stale if INIT clears EFER.NX without forcing a context reset.
However, that's benign from a functionality perspective because the context
itself correctly incorporates CR0.PG, it's only the role that's borked.  I.e.
KVM will fail to reuse a page/context due to the spurious role.nxe, but the
permission checks are always be correct.

I'll add a comment here and send a patch to fix the role calculation.
