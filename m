Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B62512FF070
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 17:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732253AbhAUQfG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 11:35:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732591AbhAUQec (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jan 2021 11:34:32 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83417C0613ED
        for <kvm@vger.kernel.org>; Thu, 21 Jan 2021 08:33:51 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id z21so1694289pgj.4
        for <kvm@vger.kernel.org>; Thu, 21 Jan 2021 08:33:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=X+t7xR7tyEcXG4BO7PJTLqhUyVQaz5DDSBnf2PrL/nI=;
        b=h0OcGN4YIxE6sMTc9bbCaLvNg2aM5EWSgRQcee2Is1A6sx7464yb36gSDPdZw0/zRe
         ri6xDyydJYJNx6bx+B92IATXKm0Y1fzMy1NsQ4VOrD10va1vxyG7GE3ywJWttwfjTsoy
         rFhFKVTkm423z129/Ho1VRFqzRyefIPJpCkcgkI8mRaexhNptKDK/UeZ2xhBQrqCRf66
         SwCFtsUyLm6JngRLrUHNKgYnjlLL1q3DwUhT+9rbhWUtoaT5QdJILgBjI0BtUww5vuxj
         K07sGiZ4wJ1FYuJ1rGjQZpK7MK0udfFVCxfc/FPCK7ohn5W1T7Iy4qKX+Eqy9ILyjL+G
         AT1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=X+t7xR7tyEcXG4BO7PJTLqhUyVQaz5DDSBnf2PrL/nI=;
        b=D3DucUsTA1aBf/GkigBNUxU7nMqXsvgw3P9rza8cqbNDNBlTMaBnkty3UU10ZrcVhi
         RHFFjid75gOaWt9TqyWbXQH7fUpYtlDfvXe9KnI6L4bz0gAoNyrwhUVHP6szfSV5bV8W
         LU3ob7b27+ejpYQxgrexSNTusvmoRm3UxwoD6QbwfqpkK59FQZyQPwvtwAh2nYJIIDMD
         p5PMdgQT45msay/A84+MgvqqsssQ5Asa7XdAKzaKEkBRF997U5fexGYUVM9nLy8EFAtM
         R7ZRqH2MB+VCEycQfPywVBBcrqXgw7j6KFHnLJS13V5v89yWPhtBIKZ5OaPdhviJFhj4
         Poqg==
X-Gm-Message-State: AOAM530M6F3AAof7SC7DcSglPmotQNuhUxyJ9MLViifFj6KanqlP8zur
        PcBWiZaiNjUT6nhvHx+xVt9K6Q==
X-Google-Smtp-Source: ABdhPJxvRI5mxPw7f28/ltKkO2cdfjerbSpq0FoPFmCNKZTX3D2wcTvXB/aNsyz8ueGv9pBpXwDFlA==
X-Received: by 2002:a62:2aca:0:b029:1bb:4349:f889 with SMTP id q193-20020a622aca0000b02901bb4349f889mr279548pfq.26.1611246830897;
        Thu, 21 Jan 2021 08:33:50 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id w192sm6116401pff.181.2021.01.21.08.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 08:33:50 -0800 (PST)
Date:   Thu, 21 Jan 2021 08:33:43 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com
Subject: Re: [RFC PATCH v2 15/26] KVM: VMX: Convert vcpu_vmx.exit_reason to a
 union
Message-ID: <YAms5375BLAp/x1W@google.com>
References: <cover.1610935432.git.kai.huang@intel.com>
 <72e2f0e0fb28af55cb11f259eb5bc9e034fb705c.1610935432.git.kai.huang@intel.com>
 <YAg7vzevfw5iL9kN@kernel.org>
 <YAhcvqXNxq0ALCyO@google.com>
 <YAjPC5VTiyO3XFsJ@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAjPC5VTiyO3XFsJ@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 21, 2021, Jarkko Sakkinen wrote:
> On Wed, Jan 20, 2021 at 08:39:26AM -0800, Sean Christopherson wrote:
> > On Wed, Jan 20, 2021, Jarkko Sakkinen wrote:
> > > On Mon, Jan 18, 2021 at 04:28:26PM +1300, Kai Huang wrote:
> > > > ---
> > > >  arch/x86/kvm/vmx/nested.c | 42 +++++++++++++++---------
> > > >  arch/x86/kvm/vmx/vmx.c    | 68 ++++++++++++++++++++-------------------
> > > >  arch/x86/kvm/vmx/vmx.h    | 25 +++++++++++++-
> > > >  3 files changed, 86 insertions(+), 49 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > > index 0fbb46990dfc..f112c2482887 100644
> > > > --- a/arch/x86/kvm/vmx/nested.c
> > > > +++ b/arch/x86/kvm/vmx/nested.c
> > > > @@ -3311,7 +3311,11 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
> > > >  	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
> > > >  	enum vm_entry_failure_code entry_failure_code;
> > > >  	bool evaluate_pending_interrupts;
> > > > -	u32 exit_reason, failed_index;
> > > > +	u32 failed_index;
> > > > +	union vmx_exit_reason exit_reason = {
> > > > +		.basic = -1,
> > > > +		.failed_vmentry = 1,
> > > > +	};
> > > 
> > > Instead, put this declaration to the correct place, following the
> > > reverse christmas tree ordering:
> > > 
> > >         union vmx_exit_reason exit_reason = {};
> > > 
> > > And after declarations:
> > > 
> > >         exit_reason.basic = -1;
> > >         exit_reason.failed_vmentry = 1;
> > > 
> > > More pleasing for the eye.
> > 
> > I disagree (obviously, since I wrote the patch).  Initializing the fields to
> > their respective values is a critical, but subtle, aspect of this code.  Making
> > the code stand out via explicit initialization is a good thing, and we really
> > don't want any possibility of code touching exit_reason before it is initialized.
> 
> The struct does get initialized to zero, and fields get initialized
> to their respective values. What is the critical aspect that is gone?
> I'm not following.

Setting exit_reason.failed_vmentry from time zero.  This code should never
synthesize a nested VM-Exit with failed_vmentry=0.  There have been bugs around
the exit_reason in this code in the past, I strongly prefer to not have any
window where exit_reason has the "wrong" value.
