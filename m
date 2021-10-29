Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6863440372
	for <lists+kvm@lfdr.de>; Fri, 29 Oct 2021 21:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbhJ2Tox (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Oct 2021 15:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbhJ2Tow (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Oct 2021 15:44:52 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF308C061714
        for <kvm@vger.kernel.org>; Fri, 29 Oct 2021 12:42:23 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id b4so3758633pgh.10
        for <kvm@vger.kernel.org>; Fri, 29 Oct 2021 12:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lK1voEAYQM1Zw18e5E1VVoH3wBqqtv/okEv7iiFVh70=;
        b=GaF7547hqixI5UkbbfFOY7HdihpFrDQNoseyonrv1aBGlub3UrkKpkyROHB0fjjFtC
         AqTJtRcepoRxh+duQknvJiM9otwlZMA9YfoBJQsevcn/JtCoxAnLN0MK/Vi/G5KvFVMP
         SgR2fpvRw1qKNLxOlSKohK6UplG5zpgvpjzf03wlnHhQflZqSkMjhSkHJ8AMR0gGYpKN
         153DTVeJcvnRAfBYA7J9okg/fe8v/rVHsVjFCrkq9bHM0f4aBngNs4f2DfbpMAxQs2W8
         Z+L0tVi2/aIRG1g7/LBwUccgWnSEoWknlQOOGEYUP/yNo6M/es9LZsqO86AT4q05X0TF
         1RPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lK1voEAYQM1Zw18e5E1VVoH3wBqqtv/okEv7iiFVh70=;
        b=mWzMJTHJkL7VMc5uVTxgaX+PGTbDSBMpoQN3+33j6DEna3NkcnpocREe/ETiQRTmc9
         4qQz0383r47S5DAyhS6DoLqt/EEbXOHr8Nm9MIYxImkfDERatYo6mzP4xpnltFLLjk/A
         KXxhXP79eRbbamv0I5R2gBA6GKzidz428u9wYVpczIgCq7Lp1E0L5iYmUJZAteYTPOam
         oAKb5TKjk/nSEyKYYEtJiTm6XH0KxG+8LBeAFwlSAOpMohGARySuUrjiYR4k+S6pRpKi
         DVQyLAeulCxSPZqwmmrD04Ty/j7uC+6/JOFMvlclwJutiIytpXH+9FQYKP/38/ZO2Lv5
         g+Ig==
X-Gm-Message-State: AOAM531OYY0qCPu5V9S6+scdfn90tGwTRUOZcNGVODWWEin7Ew71XjpE
        3fDyc/2QnlO8ML8vDd50j1gJZQ==
X-Google-Smtp-Source: ABdhPJwK4k7Rz5/QJaWcnrGW0kx9mF1xEg5+NlPhkY5Mk4ZNEzcn/PNdEHi442Efhty6I/tib/scAg==
X-Received: by 2002:a05:6a00:998:b0:47b:e61e:c0f4 with SMTP id u24-20020a056a00099800b0047be61ec0f4mr12967519pfg.31.1635536543015;
        Fri, 29 Oct 2021 12:42:23 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id ne7sm2324275pjb.36.2021.10.29.12.42.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 12:42:22 -0700 (PDT)
Date:   Fri, 29 Oct 2021 19:42:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Ajay Garg <ajaygargnsit@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] KVM: x86: Shove vp_bitmap handling down into
 sparse_set_to_vcpu_mask()
Message-ID: <YXxOmoAPDtwblW51@google.com>
References: <20211028213408.2883933-1-seanjc@google.com>
 <87pmrokn16.fsf@vitty.brq.redhat.com>
 <YXwF+jSnDq9ONTQJ@google.com>
 <YXxGO5/xO8KWfnKj@google.com>
 <YXxK8CcIk2MiVw2p@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXxK8CcIk2MiVw2p@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 29, 2021, Sean Christopherson wrote:
> On Fri, Oct 29, 2021, Sean Christopherson wrote:
> > On Fri, Oct 29, 2021, Sean Christopherson wrote:
> > > On Fri, Oct 29, 2021, Vitaly Kuznetsov wrote:
> > > > > +	/* If vp_index == vcpu_idx for all vCPUs, fill vcpu_mask directly. */
> > > > > +	if (likely(!has_mismatch))
> > > > > +		bitmap = (u64 *)vcpu_mask;
> > > > > +
> > > > > +	memset(bitmap, 0, sizeof(vp_bitmap));
> > > > 
> > > > ... but in the unlikely case has_mismatch == true 'bitmap' is still
> > > > uninitialized here, right? How doesn't it crash?
> > > 
> > > I'm sure it does crash.  I'll hack the guest to actually test this.
> > 
> > Crash confirmed.  But I don't feel too bad about my one-line goof because the
> > existing code botches sparse VP_SET, i.e. _EX flows.  The spec requires the guest
> > to explicit specify the number of QWORDS in the variable header[*], e.g. VP_SET
> > in this case, but KVM ignores that and does a harebrained calculation to "count"
> > the number of sparse banks.  It does this by counting the number of bits set in
> > valid_bank_mask, which is comically broken because (a) the whole "sparse" thing
> > should be a clue that they banks are not packed together, (b) the spec clearly
> > states that "bank = VPindex / 64", (c) the sparse_bank madness makes this waaaay
> > more complicated than it needs to be, and (d) the massive sparse_bank allocation
> > on the stack is completely unnecessary because KVM simply ignores everything that
> > wouldn't fit in vp_bitmap.
> > 
> > To reproduce, stuff vp_index in descending order starting from KVM_MAX_VCPUS - 1.
> > 
> > 	hv_vcpu->vp_index = KVM_MAX_VCPUS - vcpu->vcpu_idx - 1;
> > 
> > E.g. with an 8 vCPU guest, KVM will calculate sparse_banks_len=1, read zeros, and
> > do nothing, hanging the guest because it never sends IPIs.
>  
> Ugh, I can't read.  The example[*] clarifies that the "sparse" VP_SET packs things
> into BankContents.  I don't think I imagined my guest hanging though, so something
> is awry.  Back to debugging...

Found the culprit.  When __send_ipi_mask_ex() (in the guest) sees that the target
set is all present CPUs, it skips setting the sparse VP_SET and goes straight to
HV_GENERIC_SET_ALL, but still issues the _EX versions.  KVM mishandles that case
by skipping the IPIs altogether when there's no sparse banks.  The spec says that
it's legal for there to be no sparse banks if the data is not needed, which is
the case here since the format is not sparse.
