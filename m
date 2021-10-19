Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49A14433D89
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 19:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234632AbhJSRgg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 13:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbhJSRgf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 13:36:35 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E62C061746
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 10:34:22 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id e5-20020a17090a804500b001a116ad95caso466003pjw.2
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 10:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NjGdMesKPRHMsbGOSSUvBzUH+Hfo6W31ARL6oUWKiVk=;
        b=NpNjfiEeF9ovOS5X62Qo1rOzKILbUXV8rLjQBCIASPsAgVSSetl7LO7FoEMfiWQzQf
         STxb0KG8a/k5Nzk4V/Bevt/znGcymafg1kf+Wxgjc5zE6GXPvRneqXNhEwh/ba7e98n0
         D/G2JeMN3HfA36a3jeCGrDBdsPPEnTtUXl55OooYMm38h8aYAUT+n1oiRq8iNzDdboNu
         iIm44+DG/E1sjYcMS1TXzyP37EkOepSqkMjx6BIK7RagqShk9quQ2UIX2/ezIC2mgPaZ
         pjglccqEESx9azyyh8s/9O8Hz/RMqVd40765ObKujuZOuyNLxrJkzpYenv+sozPVlK7p
         wCLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NjGdMesKPRHMsbGOSSUvBzUH+Hfo6W31ARL6oUWKiVk=;
        b=h4wc8B9D7a/uJfrqadJmoczivFFPAB575CGuAqULpxxJvlOZlaGVgqo/ACGhQdex/g
         RDrKwjeeDJQhpKUt6FoPhW1WBEaPRLX7ijBLumhwKFuaKS708Kmvi/HjTz6WJnOnKlPG
         g3x2aIgNX/1ful2ZUQ46uHRGA1eXdygItDy2R4WI848Wii6/DfyDa6C1a4Gqh532gitT
         lKixamXaas/hUbg4hZRbLfSfE4WchmJfsWrxQ2NxtUOiumuA8TXspGtGHkATR/Gfw/+G
         sWxl64qPeyxw5nEZ8Peb8VpFoFfJP/nZaTKuc1de4QaBcviAYrEikss3g2kN0Uu3wTb2
         7A5w==
X-Gm-Message-State: AOAM531iUYQadsqJGKkDHS2/L6zeFtRQUNz1uGrU2mdSWPRq7y67aIUd
        HKTBgUNM6vTkYxEJ58fSSPhd2A==
X-Google-Smtp-Source: ABdhPJwv8dT6ctIw/V+txBO/4qohNN2lLT+h81JZKV6hYfYpQcQXY3q/sqedSLACiph6PuhDh/7sNQ==
X-Received: by 2002:a17:902:7c94:b0:13b:8d10:cc4f with SMTP id y20-20020a1709027c9400b0013b8d10cc4fmr35001584pll.54.1634664862116;
        Tue, 19 Oct 2021 10:34:22 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p5sm17439165pfb.95.2021.10.19.10.34.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 10:34:21 -0700 (PDT)
Date:   Tue, 19 Oct 2021 17:34:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v3 3/3] KVM: vCPU kick tax cut for running vCPU
Message-ID: <YW8BmRJHVvFscWTo@google.com>
References: <1634631160-67276-1-git-send-email-wanpengli@tencent.com>
 <1634631160-67276-3-git-send-email-wanpengli@tencent.com>
 <24e67e43-c50c-7e0f-305a-c7f6129f8d70@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24e67e43-c50c-7e0f-305a-c7f6129f8d70@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 19, 2021, Paolo Bonzini wrote:
> On 19/10/21 10:12, Wanpeng Li wrote:
> > -	if (kvm_vcpu_wake_up(vcpu))
> > -		return;
> > +	me = get_cpu();
> > +
> > +	if (rcuwait_active(kvm_arch_vcpu_get_wait(vcpu)) && kvm_vcpu_wake_up(vcpu))
> > +		goto out;
> 
> This is racy.  You are basically doing the same check that rcuwait_wake_up
> does, but without the memory barrier before.

I was worried that was the case[*], but I didn't have the two hours it would have
taken me to verify there was indeed a problem :-)

The intent of the extra check was to avoid the locked instruction that comes with
disabling preemption via rcu_read_lock().  But thinking more, the extra op should
be little more than a basic arithmetic operation in the grand scheme on modern x86
since the cache line is going to be locked and written no matter what, either
immediately before or immediately after.

So with Paolo's other comment, maybe just this?  And if this doesn't provide the
desired performance boost, changes to the rcuwait behavior should go in separate
patch.

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9ec99f5b972c..ebc6d4f2fbfa 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3333,11 +3333,22 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
         * vCPU also requires it to leave IN_GUEST_MODE.
         */
        me = get_cpu();
+
+       /*
+        * Avoid the moderately expensive "should kick" operation if this pCPU
+        * is currently running the target vCPU, in which case it's a KVM bug
+        * if the vCPU is in the inner run loop.
+        */
+       if (vcpu == __this_cpu_read(kvm_running_vcpu) &&
+           !WARN_ON_ONCE(vcpu->mode == IN_GUEST_MODE))
+               goto out;
+
        if (kvm_arch_vcpu_should_kick(vcpu)) {
                cpu = READ_ONCE(vcpu->cpu);
                if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
                        smp_send_reschedule(cpu);
        }
+out:
        put_cpu();
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_kick);

[*] https://lkml.kernel.org/r/YWoOG40Ap0Islpu2@google.com
