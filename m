Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B37C23C15D4
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 17:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbhGHPW5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 11:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231815AbhGHPW4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jul 2021 11:22:56 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8BE2C061574;
        Thu,  8 Jul 2021 08:20:14 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id y4so5707620pfi.9;
        Thu, 08 Jul 2021 08:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Oa1n/03ttdi3Zf5gHmQjIpSy/crMGDJ29NI1GoGfvEg=;
        b=V5amZpP3ONMVJggcdh2j+5YpI3lV2lc9De0dnPy6kSqUgUMXtpBLZx6oid6aMklJ5N
         WtCINBljJl7ZXHVWCPK0UmPAdmjaxsrGzcvTH6iQDacbxNsYwE03lyoOrZ6iEl7mltcF
         X6zpNM7RXTbKzFEmvf/izet8wS3XpXzj6FuVFYZMdBtPdSxIZLziBZ31KOBzf0LX3j82
         ILB5s8bUgkxJdXCd8IspfKo2kGhyhrSU65ZJPsURrXhViij29Qd5EEcZRw+cwQEW1jDE
         wc/NrLB67VyMnnrN04RZ2uTfG998Gs8R/roCehGIFmUR5uyCLBviNcWG8LyKAYqDz6jA
         WcHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Oa1n/03ttdi3Zf5gHmQjIpSy/crMGDJ29NI1GoGfvEg=;
        b=es2ASJ+u3R47FmgydJ7YSqWHy0ppUhNasfIUFre/8wUTDLv432qVwSawSFRb90MOce
         ++rRSg+FIKoWTgESov83PH7Yy0mnZ/gx5vgaw6Jo1RmswEuWpl/m3ha8UzCq7Immlry6
         kdYlBf6sTmIPBwMv1pn73w76XYc1CZIS4uMLR4hnDzReELtiZC+s8e1byPyfMP4aRPFX
         +9UiyPc+uyoWatBzB7H54VQMeq3xh7kisDB+6Sm24FuyuWkT/6wmgIwQjOUfCj7szhGL
         bF2ARWO4Vv5PJAcJok3ZFqm+b7dwHOw8Bs74kgAhvJsjqdf5J9mCHvpS+JIGJd/1RmI+
         wEMg==
X-Gm-Message-State: AOAM5337Sg8i+913w61aHF23LHMacbqMW+q5k5dmlnY0bae/K3SaVGXJ
        lx0K7qcB3qsRrs0ZT/j1HaM=
X-Google-Smtp-Source: ABdhPJzSKnaFQnkVkV8bkLbOKU0rfchxmthNXjsLQBZBVV3tO/4LG8SauJrN5U1F/4rQ9RoBWaEngQ==
X-Received: by 2002:a65:450c:: with SMTP id n12mr28900567pgq.98.1625757614264;
        Thu, 08 Jul 2021 08:20:14 -0700 (PDT)
Received: from localhost ([2601:647:4600:1ed4:adaa:7ff5:893e:b91])
        by smtp.gmail.com with ESMTPSA id 133sm3530456pfx.39.2021.07.08.08.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 08:20:13 -0700 (PDT)
Date:   Thu, 8 Jul 2021 08:20:12 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [RFC PATCH v2 43/69] KVM: x86/mmu: Allow non-zero init value for
 shadow PTE
Message-ID: <20210708152012.GA278847@private.email.ne.jp>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <2a12f8867229459dba2da233bf7762cb1ac2722c.1625186503.git.isaku.yamahata@intel.com>
 <c27da555-b0f2-045c-d577-7e9afb858da1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c27da555-b0f2-045c-d577-7e9afb858da1@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 06, 2021 at 04:56:07PM +0200,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > TDX will run with EPT violation #VEs enabled, which means KVM needs to
> > set the "suppress #VE" bit in unused PTEs to avoid unintentionally
> > reflecting not-present EPT violations into the guest.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >   arch/x86/kvm/mmu.h      |  1 +
> >   arch/x86/kvm/mmu/mmu.c  | 50 +++++++++++++++++++++++++++++++++++------
> >   arch/x86/kvm/mmu/spte.c | 10 +++++++++
> >   arch/x86/kvm/mmu/spte.h |  2 ++
> >   4 files changed, 56 insertions(+), 7 deletions(-)
> 
> Please ensure that this also works for tdp_mmu.c (if anything, consider
> supporting TDX only for TDP MMU; it's quite likely that mmu.c support for
> EPT/NPT will go away).

It's on my TODO list. Will address it.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
