Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D97D5492BA4
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 17:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346923AbiARQxy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 11:53:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346692AbiARQxm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 11:53:42 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E71B4C06173F
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 08:53:41 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id i8-20020a17090a138800b001b3936fb375so3146295pja.1
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 08:53:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=17ero+JmYY0rlZzqUnRpiJFjxd5WooY484e7ezxJnGg=;
        b=nA/EqyokxQDh0Z6iSAsPN5gQz3pg9mc1HDd1NqsDnOLJ0ePnZX9vLIR+TpvO90ouFb
         83kv0wR+ZnAvt2FkLIUIXPak0/x8jA69CLCvG50Ju+i4dPisAGOcFOSdlWbYjCvhAoki
         NJPqZIWUj+XsXsvdE8ZgHZcqXg6CEuMbXgGAttGCl/99d7pdibE58+iPNYh2qViVV67V
         TIx9WiVpq+r33DZ6nhx2L5IQTLtLJvW2m08s0Fdhw4TqXZH+R0i7JKzEDf9zhqvbhtk6
         gdKf/heJtyMIXLAgNiEdCmGGmdE5xVWL2KrU0PdSvdcIiEp2WAarLHnuXkbgMSUkDCwq
         ZqyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=17ero+JmYY0rlZzqUnRpiJFjxd5WooY484e7ezxJnGg=;
        b=t3GIxeYCqble9IYEdvZFvDfUYtIXB90KjCJwCvNOiJztDSBfEN48AfRUhX1qhy7wo4
         9k8zMxG9UKS5Nj2ca8qehrGUzvwLe7M+pEohc2sBC2sYw7RRYYHvVR22sOUqW28u5EjP
         lsy1hg3RMGt7hXHVC6/R50lfDPIQzynsOwI1eizbt20z7iZi4JX9gosf7obiXYfif9Qi
         PEOqtRApL/ABIWBf4OchNxn0osSoeJZqHWK8qkRUYX/Eax2vO8+yV4papnFbSOoh0FnU
         dMTSj+DyGleBnHwfJO7ByeATN13nZ4h/zVUhG2EYNs/bBZMrqY8Ipr3xik3g+9Si9YXo
         GdpA==
X-Gm-Message-State: AOAM5309PF/DYTcbxIt5NWqqW71eb4uXpdYeUrBmmVc1zv4mTbUQdh0j
        nGwDG1enB1d99BAXWd6MUWKEWA==
X-Google-Smtp-Source: ABdhPJz0fVRfWk8EqtTK8SitT8n+5BnP/3ULo+oRVr/GFzb5/kUW6Uoe1TU6AMmp5qrYVPJT31K2rA==
X-Received: by 2002:a17:90a:e618:: with SMTP id j24mr2791720pjy.40.1642524821267;
        Tue, 18 Jan 2022 08:53:41 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y13sm15552465pgi.53.2022.01.18.08.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 08:53:40 -0800 (PST)
Date:   Tue, 18 Jan 2022 16:53:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Igor Mammedov <imammedo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] KVM: x86: Partially allow KVM_SET_CPUID{,2} after
 KVM_RUN for CPU hotplug
Message-ID: <YebwkcAgszlyTzJ+@google.com>
References: <20220117150542.2176196-1-vkuznets@redhat.com>
 <20220118153531.11e73048@redhat.com>
 <498eb39c-c50a-afef-4d46-5c6753489d7e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498eb39c-c50a-afef-4d46-5c6753489d7e@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 18, 2022, Paolo Bonzini wrote:
> On 1/18/22 15:35, Igor Mammedov wrote:
> > Can you check following scenario:
> >   * on host that has IA32_TSX_CTRL and TSX enabled (RTM/HLE cpuid bits present)
> >   * boot 2 vcpus VM with TSX enabled on VMM side but with tsx=off on kernel CLI
> > 
> >       that should cause kernel to set MSR_IA32_TSX_CTRL to 3H from initial 0H
> >       and clear RTM+HLE bits in CPUID, check that RTM/HLE cpuid it cleared
> > 
> >   * hotunplug a VCPU and then replug it again
> >      if IA32_TSX_CTRL is reset to initial state, that should re-enable
> >      RTM/HLE cpuid bits and KVM_SET_CPUID2 might fail due to difference
> > 
> > and as Sean pointed out there might be other non constant leafs,
> > where exact match check could leave userspace broken.
> 
> 
> MSR_IA32_TSX_CTRL is handled differently straight during the CPUID call:
> 
>                 if (function == 7 && index == 0) {
>                         u64 data;
>                         if (!__kvm_get_msr(vcpu, MSR_IA32_TSX_CTRL, &data, true) &&
>                             (data & TSX_CTRL_CPUID_CLEAR))
>                                 *ebx &= ~(F(RTM) | F(HLE));
>                 }
> 
> 
> and I think we should redo all or most of kvm_update_cpuid_runtime
> the same way.

Please no.  xstate_required_size() requires multiple host CPUID calls, and glibc
does CPUID.0xD.0x0 and CPUID.0xD.0x1 as part of its initialization, i.e. launching
a new userspace process in the guest will see additional performance overhread due
to KVM dynamically computing the XSAVE size instead of caching it based on vCPU
state.  Nested virtualization would be especially painful as every one of those
"host" CPUID invocations will trigger and exit from L1=>L0.
