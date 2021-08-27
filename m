Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBE43F9BA4
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 17:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245343AbhH0PX3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 11:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245257AbhH0PX2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 11:23:28 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C099C061757
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 08:22:39 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id t42so5940564pfg.12
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 08:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QatDM27fKYA9pWDzVSAqlJ2DDoFQbm13fmaaMfb9ulg=;
        b=LbfQeRJPD2tlThKAHYznAy0sM0IgIfh1wTpRJBZ2a8T56zVu98PuMUUVUbHs4fqFWr
         6+86/kLM/nQLlWQf9dDa+no5hVa+6sXIHhmX9R3rM1SD9hRro8HWA2j/NGyx2O8VrgV+
         oGP6lA9WOmK8FVw2oSIVs+avOR5GJ+s6JTH9S2ut8a2dmjwSmakGT8siao8WSM0rYY/D
         l8AtqZP9IsjFRz1XRX7SFZjz8ry7nluU0QO8loudJxQXIIhTLPgOJCI+sU7b8vw4rsbo
         7ceZSl6gyIwnJ0+ZB+tg2Cex82NuQqvIiek/SOq2xNCKjHmmV/miz2C81kIq6WQooMor
         pjmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QatDM27fKYA9pWDzVSAqlJ2DDoFQbm13fmaaMfb9ulg=;
        b=E3t6SM2VMz3uI1qcKD7c8FHruQwnFdBP54F9gSG2Vqnm89MZqjWJxJWp379y8j546G
         agEQ2+VIEX+O08F5rJaalrheuvGTbAiHlM8lKMNtHX5EnFaeWMS4iCdBHXvNBsTK4R1z
         wnx7aK9jFZIemZ9Lulvg0B/T+JYbdU0/up59UdFwlthaMDUqPBaCmJcraXTh8Cahqhyl
         nwVYfA0n440xayyF9nk5zT+sDfeAZSWP3aN+3A+ZPH4K4J+wYjeYcPZIDf6+qMpouvaz
         MBUHa9HCV37q9t0imN28hU8N2uJZsbcBo+kk9Svhn6SDStZTrSTmbSUBPV91oQHkZ325
         xTXg==
X-Gm-Message-State: AOAM532B1njRtUai3XdbiM8ZO9TYMmnXfN+SfEAZUqm8tfhjtX7NLxlJ
        uUDjnFQtGzjnYNNVKaGa6cpf6A==
X-Google-Smtp-Source: ABdhPJzEumx17gqrFfS4IgX2tHxkXDWTQYfyqElR8d63vRz/R/VGX/kHlh1uWjTReV2Ta0/ixjnVag==
X-Received: by 2002:a05:6a00:26f6:b0:3ed:834e:153 with SMTP id p54-20020a056a0026f600b003ed834e0153mr9605926pfw.53.1630077758383;
        Fri, 27 Aug 2021 08:22:38 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q3sm7448697pgf.18.2021.08.27.08.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 08:22:37 -0700 (PDT)
Date:   Fri, 27 Aug 2021 15:22:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Guo Ren <guoren@kernel.org>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-csky@vger.kernel.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        Artem Kashkanov <artem.kashkanov@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: Re: [PATCH 05/15] perf: Track guest callbacks on a per-CPU basis
Message-ID: <YSkDOWze5dBHkJnA@google.com>
References: <20210827005718.585190-1-seanjc@google.com>
 <20210827005718.585190-6-seanjc@google.com>
 <YSiRBQQE7md7ZrNC@hirez.programming.kicks-ass.net>
 <YSj7jq32U8Euf38o@google.com>
 <YSj9LQfbKxOhxqcP@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YSj9LQfbKxOhxqcP@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021, Peter Zijlstra wrote:
> On Fri, Aug 27, 2021 at 02:49:50PM +0000, Sean Christopherson wrote:
> > On Fri, Aug 27, 2021, Peter Zijlstra wrote:
> > > On Thu, Aug 26, 2021 at 05:57:08PM -0700, Sean Christopherson wrote:
> > > > Use a per-CPU pointer to track perf's guest callbacks so that KVM can set
> > > > the callbacks more precisely and avoid a lurking NULL pointer dereference.
> > > 
> > > I'm completely failing to see how per-cpu helps anything here...
> > 
> > It doesn't help until KVM is converted to set the per-cpu pointer in flows that
> > are protected against preemption, and more specifically when KVM only writes to
> > the pointer from the owning CPU.  
> 
> So the 'problem' I have with this is that sane (!KVM using) people, will
> still have to suffer that load, whereas with the static_call() we patch
> in an 'xor %rax,%rax' and only have immediate code flow.

Again, I've no objection to the static_call() approach.  I didn't even see the
patch until I had finished testing my series :-/

> > Ignoring static call for the moment, I don't see how the unreg side can be safe
> > using a bare single global pointer.  There is no way for KVM to prevent an NMI
> > from running in parallel on a different CPU.  If there's a more elegant solution,
> > especially something that can be backported, e.g. an rcu-protected pointer, I'm
> > all for it.  I went down the per-cpu path because it allowed for cleanups in KVM,
> > but similar cleanups can be done without per-cpu perf callbacks.
> 
> If all the perf_guest_cbs dereferences are with preemption disabled
> (IRQs disabled, IRQ context, NMI context included), then the sequence:
> 
> 	WRITE_ONCE(perf_guest_cbs, NULL);
> 	synchronize_rcu();
> 
> Ensures that all prior observers of perf_guest_csb will have completed
> and future observes must observe the NULL value.

That alone won't be sufficient, as the read side also needs to ensure it doesn't
reload perf_guest_cbs between NULL checks and dereferences.  But that's easy
enough to solve with a READ_ONCE and maybe a helper to make it more cumbersome
to use perf_guest_cbs directly.

How about this for a series?

  1. Use READ_ONCE/WRITE_ONCE + synchronize_rcu() to fix the underlying bug
  2. Fix KVM PT interrupt handler bug
  3. Kill off perf_guest_cbs usage in architectures that don't need the callbacks
  4. Replace ->is_in_guest()/->is_user_mode() with ->state(), and s/get_guest_ip/get_ip
  5. Implement static_call() support
  6. Cleanups, if there are any
  6..N KVM cleanups, e.g. to eliminate current_vcpu and share x86+arm64 callbacks
