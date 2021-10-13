Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEE8C42C447
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 16:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237470AbhJMPAe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 11:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237931AbhJMPA0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 11:00:26 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFBB0C0613F0
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 07:57:26 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id l6so1977815plh.9
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 07:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uDYijPr0Yh2iWrykg/fgeR/p6benxlh+9aTXBd8BpcE=;
        b=Ewin6Nh1ACTbNkr1rqmz4UrYtZseZlwquysPfl7+mjcL5lj1bIpCP/WSrMM9vJO+cu
         xrHOBubB4TaSxkRl6Zepq++NXNgX42LPrx4YjBDfrZB/cVz6cG/6Qw7gL1pM92dmemNb
         HEjHdzSSTA4q6CMVdPKCG7ezPzOEYYok/NFTrUiG+tJvwWaP6IyH7qSfbMNUX1itPT2a
         vlm5Wy4OBOJvp9GrvG13f5Yoeqh0XeEUOpFQWsBbaDca+TURLj5yctViM1GSMN7sZtom
         YfkwD0EpIwdxO46OCaoOFWk44v7//t9PunuIwcf9MgPo5xuL8/EGCuDZZyvxdTMB0ghf
         9Ayw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uDYijPr0Yh2iWrykg/fgeR/p6benxlh+9aTXBd8BpcE=;
        b=VmFn2P7wwUXR/TSgBGx6vN0OyXDnj9fiCznKjiP8od+ZYlxRG6jFYmwcz+j8UZeHr1
         ppcx5nzUc36+Zs1XYjO7YtU5Ejuz2VwQo8uflVlUTddIPRizYDwRcdhy30WFbzuQADmp
         KYPxlb9q3ToPZA2ErrXftdhc6/1hEPEu+w8DkQ2+36XE4eWHr098aTDwbdJGbrbkwXTO
         hG7aR9j5wFHXIS4A+7nzxvGaoyB5nj7SOXWYC/KUWLMtVzsjfxBltM6ev+F0uv5ZZA6D
         FtYtqLUCcSa1xNeSIY2sDM4ds0lJW0JqKdDfL9AXQx3STNzOKhKGTKii3sw+m8mowsrI
         aXXQ==
X-Gm-Message-State: AOAM5314T9RD2sMaoUPWd2QVe3gasbx/+Sf/8eRpQqywFPR9s4PJV4vt
        7HCAMppmAt2cWYc/jLn8uAEfRQ==
X-Google-Smtp-Source: ABdhPJzeuUeO0jTkof/GqyMsBMDNyN3NpY7hogLcEpA27/uxAGnEK7i4RrxYWRE8Q4gySw5dA35SQw==
X-Received: by 2002:a17:90b:1645:: with SMTP id il5mr13877422pjb.158.1634137045914;
        Wed, 13 Oct 2021 07:57:25 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u24sm14136669pfm.81.2021.10.13.07.57.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 07:57:25 -0700 (PDT)
Date:   Wed, 13 Oct 2021 14:57:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [patch 14/31] x86/fpu: Replace KVMs homebrewn FPU copy from user
Message-ID: <YWbz0ayrpoxbBo5U@google.com>
References: <20211011215813.558681373@linutronix.de>
 <20211011223611.129308001@linutronix.de>
 <YWW/PEQyQAwS9/qv@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWW/PEQyQAwS9/qv@zn.tnic>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 12, 2021, Borislav Petkov wrote:
> On Tue, Oct 12, 2021 at 02:00:19AM +0200, Thomas Gleixner wrote:
> > --- a/arch/x86/include/asm/fpu/api.h
> > +++ b/arch/x86/include/asm/fpu/api.h
> > @@ -116,4 +116,7 @@ extern void fpu_init_fpstate_user(struct
> >  /* KVM specific functions */
> >  extern void fpu_swap_kvm_fpu(struct fpu *save, struct fpu *rstor, u64 restore_mask);
> >  
> > +struct kvm_vcpu;
> > +extern int fpu_copy_kvm_uabi_to_vcpu(struct fpu *fpu, const void *buf, u64 xcr0, u32 *pkru);
> > +
> >  #endif /* _ASM_X86_FPU_API_H */
> > --- a/arch/x86/kernel/fpu/core.c
> > +++ b/arch/x86/kernel/fpu/core.c
> > @@ -174,7 +174,43 @@ void fpu_swap_kvm_fpu(struct fpu *save,
> >  	fpregs_unlock();
> >  }
> >  EXPORT_SYMBOL_GPL(fpu_swap_kvm_fpu);
> > -#endif
> > +
> > +int fpu_copy_kvm_uabi_to_vcpu(struct fpu *fpu, const void *buf, u64 xcr0,
> > +			      u32 *vpkru)
> 
> Right, except that there's no @vcpu in the args of that function. I
> guess you could call it
> 
> fpu_copy_kvm_uabi_to_buf()
> 
> and that @buf can be
> 
> vcpu->arch.guest_fpu

But the existing @buf is the userspace pointer, which semantically makes sense
because the userspace pointer is the "buffer" and the destination @fpu (and @prku)
is vCPU state, not a buffer.

That said, I also struggled with the lack of @vcpu.  What about prepending vcpu_
to fpu and to pkru?  E.g.

  int fpu_copy_kvm_uabi_to_vcpu(struct fpu *vcpu_fpu, const void *buf, u64 xcr0,
  				u32 *vcpu_pkru)
