Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB723C764D
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 20:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233762AbhGMSRd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 14:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233456AbhGMSRc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 14:17:32 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B034C0613DD
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 11:14:41 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id y4so20372491pfi.9
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 11:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qYLRuC1J401GJNPoirPCf0sUsfjE1s5mBPfucqVBo/o=;
        b=TemUpZC6DppCYmoiy4LOJWEQeqEKh09xAT6P4VzLXIMbauvxoS4EP330OrBhT+KMD8
         cR2UVyVjCHceV7KPG7a9NZZmYbyYSNNWo475SwL++N6I4zXO9yWb6VASQns9WnzfMOFh
         bHOmRt1m1x3AWl7z7ZKkjnUYvtZBijxS76sM/rse9ZmiC4tDHj3JBMAKP7TwgtjAxjVn
         Xf7JqdMkTGH04bfp2wk+pGQ3QGL2Tjh7KcfaEciMt87JIcLooAuNboN9SqoujtPQpTeI
         OX+q/7+1EwbpEtAufvbfEpN5lwH2yQY3OLYOTHt6yHv4KeueUCfkzIhTGMNnAtOJtiw6
         ZiUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qYLRuC1J401GJNPoirPCf0sUsfjE1s5mBPfucqVBo/o=;
        b=cFSMs2cegMVeBl2qRHy8aoQPTHerz/E4+YJB+0mn+BeKWpKxgNuqapY5XTfi+v9E0/
         4KoQHfNmjfKysmeHNhEYh4lseQK1kdUy9AiN9b2U917fgYAom6BXyJLfRZXC5q4ELN/V
         nYpu9+iXLfb0egsIfzszvv6vjgZPxO3n+Fv6C7PsTDd+02GeYInQHy+ImuENxsxrdJBu
         yrwV072e/KNA83rdfeJMCDqSwDVcgRR8xvL5UyM07muJCv9EJsKapsAsq3X7GaLAU6HO
         Y4S+0UtUXCbqFvoRJBC/MbwnHHSyu34yrKTfpSHpZWA0E9oFdLMXrF/hC17sgSJ+Yte+
         Ht9w==
X-Gm-Message-State: AOAM531V1jfHNWTqBKr4ecrI26l7uLRHPi4/xLLxJZaiU5mBi/cs3rcj
        iVnvL4N7UtukknMcOfoUEada2w==
X-Google-Smtp-Source: ABdhPJw025D+QHvSXH7m/XdthsugBc+I0Bqri4rgbbh9zByxwSwtsOJDy77eNp2z0ZK1gdsXdBMXIg==
X-Received: by 2002:a63:5c1b:: with SMTP id q27mr5441771pgb.284.1626200081027;
        Tue, 13 Jul 2021 11:14:41 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x9sm109548pfd.100.2021.07.13.11.14.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 11:14:40 -0700 (PDT)
Date:   Tue, 13 Jul 2021 18:14:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@gmail.com, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [RFC PATCH v2 65/69] KVM: X86: Introduce initial_tsc_khz in
 struct kvm_arch
Message-ID: <YO3YDXLV7RQzMmXX@google.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <5f87f0b888555b52041a0fe32280adee0d563e63.1625186503.git.isaku.yamahata@intel.com>
 <792040b0-4463-d805-d14e-ba264a3f8bbf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <792040b0-4463-d805-d14e-ba264a3f8bbf@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 06, 2021, Paolo Bonzini wrote:
> On 03/07/21 00:05, isaku.yamahata@intel.com wrote:
> > From: Xiaoyao Li <xiaoyao.li@intel.com>
> > 
> > Introduce a per-vm variable initial_tsc_khz to hold the default tsc_khz
> > for kvm_arch_vcpu_create().
> > 
> > This field is going to be used by TDX since TSC frequency for TD guest
> > is configured at TD VM initialization phase.
> > 
> > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >   arch/x86/include/asm/kvm_host.h | 1 +
> >   arch/x86/kvm/x86.c              | 3 ++-
> >   2 files changed, 3 insertions(+), 1 deletion(-)
> 
> So this means disabling TSC frequency scaling on TDX.  Would it make sense
> to delay VM creation to a separate ioctl, similar to KVM_ARM_VCPU_FINALIZE
> (KVM_VM_FINALIZE)?

There's an equivalent of that in the next mega-patch, the KVM_TDX_INIT_VM sub-ioctl
of KVM_MEMORY_ENCRYPT_OP.  The TSC frequency for the guest gets provided at that
time.
