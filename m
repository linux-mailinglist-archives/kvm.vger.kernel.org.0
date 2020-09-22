Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7B0B2746DF
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 18:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgIVQmf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 12:42:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50865 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726578AbgIVQmf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 12:42:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600792953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iC8G1whfqPByL39Es6pKKfyv7XS871I1AqRax9as92w=;
        b=R5ssn8sJ+VYGEB8Ynep8CSy9dHoAbQA7faniHCDBu6Aq8tJep5R0nyyv50hVkSF2NHUg8c
        OZPRmkg6agjmO8qpXPKbqDWgIAmY2v0xfPHdo2PPsAstaz00/MEWw7NTj5jgONxahmbnxH
        7PlSqLl1pqadQBZOEW+9uPYe+DemMTM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56-K6cKmxt6N-60IH8sglPe6Q-1; Tue, 22 Sep 2020 12:42:20 -0400
X-MC-Unique: K6cKmxt6N-60IH8sglPe6Q-1
Received: by mail-wr1-f70.google.com with SMTP id 33so7691993wre.0
        for <kvm@vger.kernel.org>; Tue, 22 Sep 2020 09:42:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=iC8G1whfqPByL39Es6pKKfyv7XS871I1AqRax9as92w=;
        b=fVO+OmVB2iqObrxB7NU1c7LOVeJtLG4rDq+0+Kj21vOA8waOksSOncuIfMCblnP/Dq
         t/NbOP62a+agjaOk5kymeBLGT/0n5xXZ9MGchhGlD2E3IPp52ufQ9ukcxdllmSjqcCr/
         0gwhQ5m/nCyhsZ0M0deiOZM4YZFCE76JmfVOWIJP2DEo8kpE6l/IXyYHzeS2gXwunmik
         FLkgNHZljiE+z7TzNtsKYpXjMM0gJC4aElkOrydWdzXyU7+oQQ+c/+Cwuwk98EXDg3Jv
         VUO4+YXARZLJH7bwOr280/XU71jSYtCscQdrAJvWCwIs6x+hh+apa9//DjmynRu3VNzr
         740w==
X-Gm-Message-State: AOAM530dNsYZbIjjsvspvVx99DxKtOnp9HulQI9xYcU+qip704m07fPI
        SCUy68ArwLGmVbL2AQfZkaOP6rXXeTr8+2L88YuZwjbO9+c1yOh3h221VTLF1o0gagdPVUQFeCj
        fpnKj3OKc1Ddr
X-Received: by 2002:adf:fa02:: with SMTP id m2mr6306453wrr.273.1600792938759;
        Tue, 22 Sep 2020 09:42:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzSvIwNCluQ4FAdd7gj+dZFejqLTr9QQqBoSt51Uv0sBnAa3cF1jWqs2VgojAtFDe4WXBTOyA==
X-Received: by 2002:adf:fa02:: with SMTP id m2mr6306426wrr.273.1600792938539;
        Tue, 22 Sep 2020 09:42:18 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id u63sm5469043wmb.13.2020.09.22.09.42.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 09:42:18 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Eduardo Habkost <ehabkost@redhat.com>
Cc:     qemu-devel@nongnu.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        1896263@bugs.launchpad.net, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH] i386: Don't try to set MSR_KVM_ASYNC_PF_EN if kernel-irqchip=off
In-Reply-To: <20200922161055.GY57321@habkost.net>
References: <20200922151455.1763896-1-ehabkost@redhat.com> <87v9g5es9n.fsf@vitty.brq.redhat.com> <20200922161055.GY57321@habkost.net>
Date:   Tue, 22 Sep 2020 18:42:17 +0200
Message-ID: <87pn6depau.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Eduardo Habkost <ehabkost@redhat.com> writes:

> On Tue, Sep 22, 2020 at 05:38:12PM +0200, Vitaly Kuznetsov wrote:
>> Eduardo Habkost <ehabkost@redhat.com> writes:
>> 
>> > This addresses the following crash when running Linux v5.8
>> > with kernel-irqchip=off:
>> >
>> >   qemu-system-x86_64: error: failed to set MSR 0x4b564d02 to 0x0
>> >   qemu-system-x86_64: ../target/i386/kvm.c:2714: kvm_buf_set_msrs: Assertion `ret == cpu->kvm_msr_buf->nmsrs' failed.
>> >
>> > There is a kernel-side fix for the issue too (kernel commit
>> > d831de177217 "KVM: x86: always allow writing '0' to
>> > MSR_KVM_ASYNC_PF_EN"), but it's nice to simply not trigger
>> > the bug if running an older kernel.
>> >
>> > Fixes: https://bugs.launchpad.net/bugs/1896263
>> > Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
>> > ---
>> >  target/i386/kvm.c | 7 ++++++-
>> >  1 file changed, 6 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/target/i386/kvm.c b/target/i386/kvm.c
>> > index 9efb07e7c83..1492f41349f 100644
>> > --- a/target/i386/kvm.c
>> > +++ b/target/i386/kvm.c
>> > @@ -2818,7 +2818,12 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>> >          kvm_msr_entry_add(cpu, MSR_IA32_TSC, env->tsc);
>> >          kvm_msr_entry_add(cpu, MSR_KVM_SYSTEM_TIME, env->system_time_msr);
>> >          kvm_msr_entry_add(cpu, MSR_KVM_WALL_CLOCK, env->wall_clock_msr);
>> > -        if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_ASYNC_PF)) {
>> > +        /*
>> > +         * Some kernel versions (v5.8) won't let MSR_KVM_ASYNC_PF_EN to be set
>> > +         * at all if kernel-irqchip=off, so don't try to set it in that case.
>> > +         */
>> > +        if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_ASYNC_PF) &&
>> > +            kvm_irqchip_in_kernel()) {
>> >              kvm_msr_entry_add(cpu, MSR_KVM_ASYNC_PF_EN, env->async_pf_en_msr);
>> >          }
>> >          if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_PV_EOI)) {
>> 
>> I'm not sure kvm_irqchip_in_kernel() was required before we switched to
>> interrupt-based APF (as we were always injecting #PF) but with
>> kernel-5.8+ this should work. [...]
>
> Were guests able to set MSR_KVM_ASYNC_PF_EN to non-zero with
> kernel-irqchip=off on hosts running Linux <= 5.7? 

lapic_in_kernel() check appeared in kernel with the following commit:

commit 9d3c447c72fb2337ca39f245c6ae89f2369de216
Author: Wanpeng Li <wanpengli@tencent.com>
Date:   Mon Jun 29 18:26:31 2020 +0800

    KVM: X86: Fix async pf caused null-ptr-deref

which was post-interrupt-based-APF. I *think* it was OK to enable APF
with !lapic_in_kernel() before (at least I don't see what would not
allow that).

> I am assuming
> kvm-asyncpf never worked with kernel-irqchip=off (and enabling it
> by default with kernel-irqchip=off was a mistake).
>
>
>>                         [...] We'll need to merge this with
>> 
>> https://lists.nongnu.org/archive/html/qemu-devel/2020-09/msg02963.html
>> (queued by Paolo) and
>> https://lists.nongnu.org/archive/html/qemu-devel/2020-09/msg06196.html
>> which fixes a bug in it.
>> 
>> as kvm_irqchip_in_kernel() should go around both KVM_FEATURE_ASYNC_PF
>> and KVM_FEATURE_ASYNC_PF_INT I believe.
>
> Shouldn't we just disallow kvm-asyncpf-int=on if kernel-irqchip=off?

(Sarcasm: if disallowing 'kernel-irqchip=off' is not an option, then)
yes, we probably can, but kvm-asyncpf-int=on is the default we have so
we can't just implicitly change it underneath or migration will break...

-- 
Vitaly

