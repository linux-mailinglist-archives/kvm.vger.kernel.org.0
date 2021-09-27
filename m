Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 844974196EF
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 17:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234966AbhI0PBe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 11:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234873AbhI0PBc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 11:01:32 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C9BC06176E
        for <kvm@vger.kernel.org>; Mon, 27 Sep 2021 07:59:53 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id n18so18010710pgm.12
        for <kvm@vger.kernel.org>; Mon, 27 Sep 2021 07:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8d5KqXA5Mi92PwzZc0N/pdrf/YfLC80LCsk313TOlF8=;
        b=m7Sxwd73+QIO2WuPaGefD2VV92Ixlana/rvgLp3fywdfnLLEysnYWnlbrJZMSHvky2
         P+dNFDKl+i/DMSPcDLNPjzckqkQLgh9pdU/c3JQwnIagXzSzhgOa+ncEZvwMUJLQWG1m
         fybm6n4GY1o2I/TIIMUtFfjJTQU9KFbL0J/XoEro7oVzMh1zw+XmI5tRZQQeuZDe42Dg
         Tmmp6oePrkChYyER1Tnna/qEz55zzNMH1ZMLBsrMQL84AaEtkyNXBlm2Xx+ZucKX/mXL
         yMhzhoMAfnJyECqCajIjTuZBzhOpC4zX9voYjWadeZj+T2l75O1okb7Y4J7XHlu7WdkY
         kHUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8d5KqXA5Mi92PwzZc0N/pdrf/YfLC80LCsk313TOlF8=;
        b=hAHdhPAk9bjp2Yw8Om6xea53LZrge7cQZPgG/YeNlJLM26iJVyTUrpxuFyQiEG9dM+
         nMduh+1MOhJ+cx9BTV8U24E5NTKw0kXXlXQyM/PZ7JJHnD6KNvYYuSCpV7rm/oB02vlC
         NIRdogbmKgrr5FO05WoWBMF7ETqebSdJQMCY0AUBy56LK24jEQRVWP/0HqAPqMedgZBn
         KjNZRRKjJNFfZ/ObiS2xXx+h1Chy8UKqNqT7dtmcIE90MiAJfKZszL52dgG7IkoFdA1a
         kZGpwZE2t1Gbcx36EdmWi0YT02R5jORHKpsxjIlkWtdOqS1agW+d1K0qBUtRFCqC2Ggm
         ZJTg==
X-Gm-Message-State: AOAM532GliyzGo7AAjBRTWQ3TnKSSb+NN7fHE6OO5OIoZdLvB6Ws06Rn
        tNUw76B1jq01pw3K34hbmypOIw==
X-Google-Smtp-Source: ABdhPJyg70ia4mflauFBTnYYkPuZeGu0PUo7u3KrQoV6hyYnlf5Ujo4gsfK+PdoDvaYqAOyRoeDCGg==
X-Received: by 2002:a63:e057:: with SMTP id n23mr107748pgj.183.1632754792472;
        Mon, 27 Sep 2021 07:59:52 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id n14sm19177569pgd.48.2021.09.27.07.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 07:59:51 -0700 (PDT)
Date:   Mon, 27 Sep 2021 14:59:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jon Cargille <jcargill@google.com>,
        Jim Mattson <jmattson@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jing Zhang <jingzhangos@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: disabling halt polling broken? (was Re: [PATCH 00/14] KVM:
 Halt-polling fixes, cleanups and a new stat)
Message-ID: <YVHcY6y1GmvGJnMg@google.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <03f2f5ab-e809-2ba5-bd98-3393c3b843d2@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03f2f5ab-e809-2ba5-bd98-3393c3b843d2@de.ibm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 27, 2021, Christian Borntraeger wrote:
> While looking into this series,
> 
> I realized that Davids patch
> 
> commit acd05785e48c01edb2c4f4d014d28478b5f19fb5
> Author:     David Matlack <dmatlack@google.com>
> AuthorDate: Fri Apr 17 15:14:46 2020 -0700
> Commit:     Paolo Bonzini <pbonzini@redhat.com>
> CommitDate: Fri Apr 24 12:53:17 2020 -0400
> 
>     kvm: add capability for halt polling
> 
> broke the possibility for an admin to disable halt polling for already running KVM guests.
> In past times doing
> echo 0 > /sys/module/kvm/parameters/halt_poll_ns
> 
> stopped polling system wide.
> Now all KVM guests will use the halt_poll_ns value that was active during
> startup - even those that do not use KVM_CAP_HALT_POLL.
> 
> I guess this was not intended?

Ouch.  I would go so far as to say that halt_poll_ns should be a hard limit on
the capability.  What about having the per-VM variable track only the capability,
and then use the module param to cap the max when doing adjustments?  E.g. add
a variant of this early in the series?

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 80f78daa6b8d..f50e4e31a0cf 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1078,8 +1078,6 @@ static struct kvm *kvm_create_vm(unsigned long type)
                        goto out_err_no_arch_destroy_vm;
        }

-       kvm->max_halt_poll_ns = halt_poll_ns;
-
        r = kvm_arch_init_vm(kvm, type);
        if (r)
                goto out_err_no_arch_destroy_vm;
@@ -3136,7 +3134,8 @@ void kvm_sigset_deactivate(struct kvm_vcpu *vcpu)
        sigemptyset(&current->real_blocked);
 }

-static void grow_halt_poll_ns(struct kvm_vcpu *vcpu)
+static void grow_halt_poll_ns(struct kvm_vcpu *vcpu,
+                             unsigned int max_halt_poll_ns)
 {
        unsigned int old, val, grow, grow_start;

@@ -3150,8 +3149,8 @@ static void grow_halt_poll_ns(struct kvm_vcpu *vcpu)
        if (val < grow_start)
                val = grow_start;

-       if (val > vcpu->kvm->max_halt_poll_ns)
-               val = vcpu->kvm->max_halt_poll_ns;
+       if (val > max_halt_poll_ns)
+               val = max_halt_poll_ns;

        vcpu->halt_poll_ns = val;
 out:
@@ -3261,6 +3260,7 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
 {
        bool halt_poll_allowed = !kvm_arch_no_poll(vcpu);
        bool do_halt_poll = halt_poll_allowed && vcpu->halt_poll_ns;
+       unsigned int max_halt_poll_ns;
        ktime_t start, cur, poll_end;
        bool waited = false;
        u64 halt_ns;
@@ -3304,19 +3304,25 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
                update_halt_poll_stats(vcpu, start, poll_end, !waited);

        if (halt_poll_allowed) {
+               max_halt_poll_ns = vcpu->kvm->max_halt_poll_ns;
+               if (max_halt_poll_ns)
+                       max_halt_poll_ns = min(max_halt_poll_ns, halt_poll_ns);
+               else
+                       max_halt_poll_ns = halt_poll_ns;
+
                if (!vcpu_valid_wakeup(vcpu)) {
                        shrink_halt_poll_ns(vcpu);
-               } else if (vcpu->kvm->max_halt_poll_ns) {
+               } else if (max_halt_poll_ns) {
                        if (halt_ns <= vcpu->halt_poll_ns)
                                ;
                        /* we had a long block, shrink polling */
                        else if (vcpu->halt_poll_ns &&
-                                halt_ns > vcpu->kvm->max_halt_poll_ns)
+                                halt_ns > max_halt_poll_ns)
                                shrink_halt_poll_ns(vcpu);
                        /* we had a short halt and our poll time is too small */
-                       else if (vcpu->halt_poll_ns < vcpu->kvm->max_halt_poll_ns &&
-                                halt_ns < vcpu->kvm->max_halt_poll_ns)
-                               grow_halt_poll_ns(vcpu);
+                       else if (vcpu->halt_poll_ns < max_halt_poll_ns &&
+                                halt_ns < max_halt_poll_ns)
+                               grow_halt_poll_ns(vcpu, max_halt_poll_ns);
                } else {
                        vcpu->halt_poll_ns = 0;
                }
