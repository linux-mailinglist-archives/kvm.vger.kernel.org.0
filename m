Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5D6365FDE
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 20:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbhDTS6w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 14:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233617AbhDTS6v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 14:58:51 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F5ACC06174A
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 11:58:19 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id s22so6180884pgk.6
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 11:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Dumd2r/K9Sw9nYE5iGaCSFQrfi8eJyI9jzR8OFcyNs0=;
        b=dhQ8hD6pdHTFPDLk9tAbpzz+y4UMGx6CPFX86yiePUSSBEE3NFEbBE/hD0ROuKdOE9
         HL63eLqLVhAUXCmcPaO9sqM8UPwPiQp4fgTeNMdwodgyzWO/9ZCvR+mVXAdNroxx3KNh
         Nh+wzjyJ8X9Qx8HnXgar+kCHXFDgehw+HTZz4sa0vSymZLr85ck3s5AG8cymPJYWArrz
         zrKgoWUadXKyc/RE25qqDO5MhYW0fZ0TT6DANnx3nZ7tBhikQUoWDmZOreRLiOcyyL/0
         h0T5vkUN/SI1XehWa0ZvnQ2z/mSUFpNtECwydXbxeisDETW51Vr7Tg95dYTJ4NE9JcNV
         7HjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Dumd2r/K9Sw9nYE5iGaCSFQrfi8eJyI9jzR8OFcyNs0=;
        b=RgJWXRxJdEE5ecs0fRTUgk3DjBRwifxfNRq8lEHA3qmrnuznoNlFyir7cL3RFvsF/P
         bDLHBfKx30M8p49s7N99IofDyOGFBOxiQd0WpbyBq74Yvq36/gX1qZGvzBJEm08SHzdJ
         gRggwf74DT62/xXca5t8zM8yxXFio3Ucs9VmuPFsmgXNYdWP/RrHcUzCCmGEu0J+qtf+
         c+drcGoRzgnmXngOFttSEItY32PoT6HlfRvTXB6S7y1IZERgh062J7moHvPJkI6HTN4H
         dY+G2WGU6FikN3YIPtSfEIgxQXNGOepqbe6KYc9worL/rNOhaclnHEpbd9NCw22ef5B0
         PPxA==
X-Gm-Message-State: AOAM533cKxeLfzzq/2orijbq3cPIR005GBxVGgK4oC3APW3efCalTAT6
        0SWq2Kes3v2/Ly294XQn/bSz3w==
X-Google-Smtp-Source: ABdhPJwRsI+tawjouWGAzyH6SSv5oqWGKBHPEcwrsMPDjT/MQchsA48YHJEmLsRissgp7NjOoAV/Sw==
X-Received: by 2002:a05:6a00:248f:b029:244:7ae0:ba2c with SMTP id c15-20020a056a00248fb02902447ae0ba2cmr26783242pfv.49.1618945098917;
        Tue, 20 Apr 2021 11:58:18 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id gz11sm2288762pjb.34.2021.04.20.11.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 11:58:18 -0700 (PDT)
Date:   Tue, 20 Apr 2021 18:58:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, srutherford@google.com, joro@8bytes.org,
        brijesh.singh@amd.com, thomas.lendacky@amd.com,
        venu.busireddy@oracle.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>,
        x86@kernel.org
Subject: Re: [PATCH 0/3] KVM: x86: guest interface for SEV live migration
Message-ID: <YH8kRs8KGmLaJ6EN@google.com>
References: <20210420112006.741541-1-pbonzini@redhat.com>
 <YH8P26OibEfxvJAu@google.com>
 <20210420181124.GA12798@ashkalra_ubuntu_server>
 <YH8gKcxE+dfulftQ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YH8gKcxE+dfulftQ@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 20, 2021, Sean Christopherson wrote:
> On Tue, Apr 20, 2021, Ashish Kalra wrote:
> > On Tue, Apr 20, 2021 at 05:31:07PM +0000, Sean Christopherson wrote:
> > > On Tue, Apr 20, 2021, Paolo Bonzini wrote:
> > > > +	case KVM_HC_PAGE_ENC_STATUS: {
> > > > +		u64 gpa = a0, npages = a1, enc = a2;
> > > > +
> > > > +		ret = -KVM_ENOSYS;
> > > > +		if (!vcpu->kvm->arch.hypercall_exit_enabled)
> > > 
> > > I don't follow, why does the hypercall need to be gated by a capability?  What
> > > would break if this were changed to?
> > > 
> > > 		if (!guest_pv_has(vcpu, KVM_FEATURE_HC_PAGE_ENC_STATUS))
> > > 
> > 
> > But, the above indicates host support for page_enc_status_hc, so we want
> > to ensure that host supports and has enabled support for the hypercall
> > exit, i.e., hypercall has been enabled.
> 
> I still don't see how parroting back KVM_GET_SUPPORTED_CPUID, i.e. "unintentionally"
> setting KVM_FEATURE_HC_PAGE_ENC_STATUS, would break anything.  Sure, the guest
> does unnecessary hypercalls, but they're eaten by KVM.  On the flip side, gating
> the hypercall on the capability, and especially only the capability, creates
> weird scenarios where the guest can observe KVM_FEATURE_HC_PAGE_ENC_STATUS=1
> but fail the hypercall.  Those would be fairly clearcut VMM bugs, but at the
> same time KVM is essentially going out of its way to manufacture the problem.

Doh, I was thinking of the MSR behavior, not the hypercall.  I'll respond to
Paolo's mail, I have one more hail mary idea.
