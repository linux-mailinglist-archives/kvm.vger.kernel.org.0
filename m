Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14C72FD5E9
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 17:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732628AbhATQnP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 11:43:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391611AbhATQkQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 11:40:16 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940C6C061575
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 08:39:34 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id x18so12804491pln.6
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 08:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nuK0zgKpAn8bzQ1mtmeXEwK3kY3X8JH630/Yem/GinQ=;
        b=gIXzr+069d/0fSiLThZbkPQeXmsQRTA6DjfqW/10j2gExSlk9huiiDDtiCOiN/Tu5M
         rns0U/Wr07wrfCqvQZOFkv/zvBv93JdbzykMYcYj+pGumuLDlMG1Q0/lWcdEMCS9f2Q2
         uotpqsKxh+CgYeYzZbcM3pugbyYc3Yl/RERF71wHJziT0kzZFIr4zKzjEGrR0srj2hTW
         mWjIxXPdSACvzeroplr2kVvNz0m7+btstdaOKt8VT78blNBNQNl3+RaCyYAuK5PXzCqW
         P66oyaxTK8OVJrDEeUQtWv9p3V1sIXxxtiI35cOZWF6o87ParWHAVYwYct6on+Dt3qhR
         nSmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nuK0zgKpAn8bzQ1mtmeXEwK3kY3X8JH630/Yem/GinQ=;
        b=LBcVY3PptpygOLO64nGf3yyeQl6MbzCO983kUPA1TaPAfvIV52foIR1SPSeIoJW5ay
         8mtkE2cF2uVeiWnuuKB1OWYAA1LI6xlw+CrugNUPPsQX0iHZUx2Bm1OzyACgMjz3aogl
         cD/BwvD2o36lFnLdpmsjYs4Ljq3+uSo7XlkhEjbV838H1qCbWW/EoV8qhuRh6dpHe7zK
         FkkeftVGRh3hDTFc4rAfcqAHErVCJMFNo1PTJW/N0Ofh3CrkNwSRcibTgtc3BjTOGcNu
         eVp1ifxgWBFvLDRVKYB7OERCELD+zpWWRJa3b2JPCoPfr8uJUKWURT55dKdCvgHq7gY8
         c4Hw==
X-Gm-Message-State: AOAM531e4sj7IUwp4qZyiNOXzGCLhlSkiDsfIn+4bweN314rqpNZfyRM
        +oVantTO76hVzd5oNJd8Hq0Ddg==
X-Google-Smtp-Source: ABdhPJxDnTAJfxEaIlpQNTYS5GtZPsaetfRE5nmAw+H2XkASTdS3RyZDqs+FHwbl9QlVipCd8xoYEw==
X-Received: by 2002:a17:902:9a03:b029:dc:31af:8dc2 with SMTP id v3-20020a1709029a03b02900dc31af8dc2mr10774139plp.39.1611160773822;
        Wed, 20 Jan 2021 08:39:33 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id fv19sm2926134pjb.20.2021.01.20.08.39.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 08:39:33 -0800 (PST)
Date:   Wed, 20 Jan 2021 08:39:26 -0800
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
Message-ID: <YAhcvqXNxq0ALCyO@google.com>
References: <cover.1610935432.git.kai.huang@intel.com>
 <72e2f0e0fb28af55cb11f259eb5bc9e034fb705c.1610935432.git.kai.huang@intel.com>
 <YAg7vzevfw5iL9kN@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAg7vzevfw5iL9kN@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 20, 2021, Jarkko Sakkinen wrote:
> On Mon, Jan 18, 2021 at 04:28:26PM +1300, Kai Huang wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > Convert vcpu_vmx.exit_reason from a u32 to a union (of size u32).  The
> > full VM_EXIT_REASON field is comprised of a 16-bit basic exit reason in
> > bits 15:0, and single-bit modifiers in bits 31:16.
> > 
> > Historically, KVM has only had to worry about handling the "failed
> > VM-Entry" modifier, which could only be set in very specific flows and
> > required dedicated handling.  I.e. manually stripping the FAILED_VMENTRY
> > bit was a somewhat viable approach.  But even with only a single bit to
> > worry about, KVM has had several bugs related to comparing a basic exit
> > reason against the full exit reason store in vcpu_vmx.
> > 
> > Upcoming Intel features, e.g. SGX, will add new modifier bits that can
> > be set on more or less any VM-Exit, as opposed to the significantly more
> > restricted FAILED_VMENTRY, i.e. correctly handling everything in one-off
> > flows isn't scalable.  Tracking exit reason in a union forces code to
> > explicitly choose between consuming the full exit reason and the basic
> > exit, and is a convenient way to document and access the modifiers.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > ---
> >  arch/x86/kvm/vmx/nested.c | 42 +++++++++++++++---------
> >  arch/x86/kvm/vmx/vmx.c    | 68 ++++++++++++++++++++-------------------
> >  arch/x86/kvm/vmx/vmx.h    | 25 +++++++++++++-
> >  3 files changed, 86 insertions(+), 49 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 0fbb46990dfc..f112c2482887 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -3311,7 +3311,11 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
> >  	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
> >  	enum vm_entry_failure_code entry_failure_code;
> >  	bool evaluate_pending_interrupts;
> > -	u32 exit_reason, failed_index;
> > +	u32 failed_index;
> > +	union vmx_exit_reason exit_reason = {
> > +		.basic = -1,
> > +		.failed_vmentry = 1,
> > +	};
> 
> Instead, put this declaration to the correct place, following the
> reverse christmas tree ordering:
> 
>         union vmx_exit_reason exit_reason = {};
> 
> And after declarations:
> 
>         exit_reason.basic = -1;
>         exit_reason.failed_vmentry = 1;
> 
> More pleasing for the eye.

I disagree (obviously, since I wrote the patch).  Initializing the fields to
their respective values is a critical, but subtle, aspect of this code.  Making
the code stand out via explicit initialization is a good thing, and we really
don't want any possibility of code touching exit_reason before it is initialized.
