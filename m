Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56E646257F
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 23:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234192AbhK2WkX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 17:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232922AbhK2Wj4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 17:39:56 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26CC0C03AA1F
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 10:16:35 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id 8so17768710pfo.4
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 10:16:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mHx/Rm0v3abugHNIW+k1AFYioeHEBBih2PCymCoJv40=;
        b=jcm4ABsEgSE+FD2P5CkCiBvNU0wdL+YiaxfQOlKNnZ5///U3+pb2tKo0O5KiPLZeAv
         chh6M3ISiAOCtms6ipPHE+q0ipPVwzB+fYG53RcQ4ReHokq6R5VN1teeU77Nje7KzMpZ
         Z5VNpbeU6YbfLfVx0MTXgdczBcI+u06swdgmroIsgSv5iFlt0j9xdOosA2gtaSW6m0/j
         s7LGaU4/mTMzMn9CqOQgpqQEsFRZ0N121D9Z25SNLkUp5ZQICAwtuTfQfeR8CPeN86AO
         6D1Na8TQ+cug2tK7P89Y6v5Gk7dGug0qQxe550tzht/cj+CARj6Yw48VKp04/cHk11dE
         4Naw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mHx/Rm0v3abugHNIW+k1AFYioeHEBBih2PCymCoJv40=;
        b=iiXU6pRuUIJ8oKopGAK0kr+XZI1oErTk7dKes+9EDuBdovFjEooNAfCyCm9bk1psYm
         CIKtcp42iWyjGVtvVMojJn4xQh4q2VMM3kGZ+8Hz/hr30bgTpU9ElakURRvw57v9Szy6
         ED4NTk5b2Rtbi5DycczOHUiXR7IgIKSXe25z5CsrYaHWcro6kyzD3f8p7Eli6NOf/TMg
         W9ZTA4pHam9e0CNx1hxNye1wAKRI71h3ABGoSL7izhdsPnhCqdvu19pciDAjWcVIHra5
         bbw4/Ccw9PDwBqhKuhG/ogp7AcFllYeCATK6Mu/NkczuNA2/WNjyLxp3QQLc/4rwfF4Y
         KDvg==
X-Gm-Message-State: AOAM533bdePTMnu+6Oc+bN5DzEk0cTZ4f9Q8rM3WHzX9JRFMdWwJoOzY
        AkKGeabXK7MT63Hk78wnI+9KIQ==
X-Google-Smtp-Source: ABdhPJykaqk8ISKzZvwwtrKmVYkkWoBaqSjfkjvItEqz2J/5mNmNk5Eo2YIxCE6Pg5mB3KVl1Ak5rg==
X-Received: by 2002:a63:5758:: with SMTP id h24mr20182539pgm.110.1638209794208;
        Mon, 29 Nov 2021 10:16:34 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f21sm20219411pfc.85.2021.11.29.10.16.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 10:16:33 -0800 (PST)
Date:   Mon, 29 Nov 2021 18:16:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, isaku.yamahata@intel.com,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [RFC PATCH v3 26/59] KVM: x86: Introduce vm_teardown() hook in
 kvm_arch_vm_destroy()
Message-ID: <YaUY/vlFX22DFhsE@google.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <1fa2d0db387a99352d44247728c5b8ae5f5cab4d.1637799475.git.isaku.yamahata@intel.com>
 <87a6hsj9wd.ffs@tglx>
 <21e8d65c-62bd-b410-1260-1ff4b0e0c251@redhat.com>
 <8735nkhre8.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8735nkhre8.ffs@tglx>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 25, 2021, Thomas Gleixner wrote:
> On Thu, Nov 25 2021 at 21:54, Paolo Bonzini wrote:
> > On 11/25/21 20:46, Thomas Gleixner wrote:
> >> On Wed, Nov 24 2021 at 16:20, isaku yamahata wrote:
> >>> Add a second kvm_x86_ops hook in kvm_arch_vm_destroy() to support TDX's
> >>> destruction path, which needs to first put the VM into a teardown state,
> >>> then free per-vCPU resource, and finally free per-VM resources.
> >>>
> >>> Note, this knowingly creates a discrepancy in nomenclature for SVM as
> >>> svm_vm_teardown() invokes avic_vm_destroy() and sev_vm_destroy().
> >>> Moving the now-misnamed functions or renaming them is left to a future
> >>> patch so as not to introduce a functional change for SVM.
> >> That's just the wrong way around. Fixup SVM first and then add the TDX
> >> muck on top. Stop this 'left to a future patch' nonsense. I know for
> >> sure that those future patches never materialize.
> >
> > Or just keep vm_destroy for the "early" destruction, and give a new name 
> > to the new hook.  It is used to give back the TDCS memory, so perhaps 
> > you can call it vm_free?
> 
> Up to you, but the current approach is bogus. I rather go for a fully
> symmetric interface and let the various incarnations opt in at the right
> place. Similar to what cpu hotplug states are implementing.

Naming aside, that's what is being done, TDX simply needs two hooks instead of one
due to the way KVM handles VM and vCPU destruction.  The alternative would be to
shove and duplicate what is currently common x86 code into VMX/SVM, which IMO is
far worse.

Regarding the naming, I 100% agree SVM should be refactored prior to adding TDX
stuff if we choose to go with vm_teardown() and vm_destroy() instead of Paolo's
suggestion of vm_destroy() and vm_free().  When this patch/code was originally
written, letting SVM become stale was a deliberate choice to reduce conflicts with
upstream as we knew the code would live out of tree for quite some time.  But that
was purely meant to be development "hack", not upstream behavior.
