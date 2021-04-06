Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5718D355791
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 17:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345581AbhDFPUi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 11:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345575AbhDFPUg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 11:20:36 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D464EC06174A
        for <kvm@vger.kernel.org>; Tue,  6 Apr 2021 08:20:26 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id i190so2397024pfc.12
        for <kvm@vger.kernel.org>; Tue, 06 Apr 2021 08:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3nOOElHtuWxIjwzeA4Qinf+awOERwf/3FOuhhm/HNjs=;
        b=DXRlea9AoD5zyghCYi8ymKEiSBVn7dC3We79fEcLjckA7HgurQXC9sPhgikxfaiDs2
         8KAKCaBzmH481ePtDqo4g6kz7zbSRfyUx/DvlFAH6CHx5DUTBs5OP1BnjQOz+Gd3sg2M
         zwJmQYLdw561TJwF7XJexozk62vjy/+h4lWXWt3MLea5Oz9wiBmthw0kvzrE0Cgm438+
         XvxTUqmU0QJRsyQ7CyvCrUAt+JNXM35W2OdV4cdgBIrNAdrHCWKJuShFQXQdyoKzsTgw
         E8SZ7jejXiHOFJqVmoQ2P8hCw3S952lQCIT7SwCj1dW1sI2OF48QOQhENP19wORlLoQH
         0s0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3nOOElHtuWxIjwzeA4Qinf+awOERwf/3FOuhhm/HNjs=;
        b=inaKxpkBBEG5xMrxM8XKOuGRSrCFRkOlkn6PozVYDwq9Y1Y1tVCj1WGdXnU9rsvqDM
         bFIwW+8dD+m25xCBV8J/YCSFBhW8wJPktkw5hL991BGJwviPNteY2mFauxbRjaTS73XA
         eThoFK6hjXM8xt3KOfRY033mkJjSn1C0fq4ePDQaiSdAdLDVIYhhErh39Dv11m7GGina
         LJBCZRoJoql3gBS+GyG+7OyMX+i1F9+ZNsBHw/U+eK2MNU8Q6ObCIatVanzkJu/VFzbi
         tiQGClx0j4YYNocX2AiiQ+0Fikyuua6aoy506xHON6jhRn89oSDZkFZs6364QswsBMz9
         GmwQ==
X-Gm-Message-State: AOAM531RArUvPU5BBHelCrenfPvRGiPGjoeqao4Ikc0OE3c0WQrC+L4u
        u5wuRxP1zISJepnRh4nYuzueTg==
X-Google-Smtp-Source: ABdhPJwIlNMnMJhHkep8TJKMaoNN2Ei5py3EvYJq4iN+mOj72qEFF1vT7r+lHVAyRTf0ba12RUuvKQ==
X-Received: by 2002:a63:4522:: with SMTP id s34mr27217308pga.250.1617722426232;
        Tue, 06 Apr 2021 08:20:26 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id p22sm2882027pjg.39.2021.04.06.08.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 08:20:25 -0700 (PDT)
Date:   Tue, 6 Apr 2021 15:20:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     Steve Rutherford <srutherford@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Will Deacon <will@kernel.org>, maz@kernel.org,
        Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v11 08/13] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS
 hypercall
Message-ID: <YGx8NbG6TGm7LnQh@google.com>
References: <cover.1617302792.git.ashish.kalra@amd.com>
 <4da0d40c309a21ba3952d06f346b6411930729c9.1617302792.git.ashish.kalra@amd.com>
 <CABayD+fF7+sn444rMuE_SNwN-SYSPwJr1mrW3qRYw4H7ryi-aw@mail.gmail.com>
 <20210406062248.GA22937@ashkalra_ubuntu_server>
 <YGx6JqTVO97GUzn7@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGx6JqTVO97GUzn7@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 06, 2021, Sean Christopherson wrote:
> On Tue, Apr 06, 2021, Ashish Kalra wrote:
> > On Mon, Apr 05, 2021 at 01:42:42PM -0700, Steve Rutherford wrote:
> > > On Mon, Apr 5, 2021 at 7:28 AM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > index f7d12fca397b..ef5c77d59651 100644
> > > > --- a/arch/x86/kvm/x86.c
> > > > +++ b/arch/x86/kvm/x86.c
> > > > @@ -8273,6 +8273,18 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> > > >                 kvm_sched_yield(vcpu->kvm, a0);
> > > >                 ret = 0;
> > > >                 break;
> > > > +       case KVM_HC_PAGE_ENC_STATUS: {
> > > > +               int r;
> > > > +
> > > > +               ret = -KVM_ENOSYS;
> > > > +               if (kvm_x86_ops.page_enc_status_hc) {
> > > > +                       r = kvm_x86_ops.page_enc_status_hc(vcpu, a0, a1, a2);
> > > > +                       if (r >= 0)
> > > > +                               return r;
> > > > +                       ret = r;
> > > Style nit: Why not just set ret, and return ret if ret >=0?
> > > 
> > 
> > But ret is "unsigned long", if i set ret and return, then i will return to guest
> > even in case of error above ?
> 
> As proposed, svm_page_enc_status_hc() already hooks complete_userspace_io(), so
> this could be hoisted out of the switch statement.
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 16fb39503296..794dde3adfab 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8261,6 +8261,10 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>                 goto out;
>         }
> 
> +       /* comment goes here */
> +       if (nr == KVM_HC_PAGE_ENC_STATUS && kvm_x86_ops.page_enc_status_hc)
> +               return static_call(kvm_x86_page_enc_status_hc(vcpu, a0, a1, a2));

Gah, the SEV implementation can also return -EINVAL, and that should fail the
hypercall, not kill the guest.  Normally we try to avoid output params, but
in this case it might be less ugly to do:

		case KVM_HC_PAGE_ENC_STATUS: {
			if (!kvm_x86_ops.page_enc_status_hc)
				break;

			if (!static_call(kvm_x86_page_enc_status_hc(vcpu, a0, a1,
								    a2, &ret));
				return 0;
			break;

> +
>         ret = -KVM_ENOSYS;
> 
>         switch (nr) {
> 
