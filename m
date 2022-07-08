Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 313AD56C2ED
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 01:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238456AbiGHW4G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 18:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237347AbiGHW4E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 18:56:04 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E89FA37195
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 15:56:03 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id a15so312566pjs.0
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 15:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XFUextg8+A7izU4Qfr46JgCq2Cnv/dm+5SuqQWzRBHI=;
        b=A86Wq9spd82HyU9VHUFUn/druUkCjCRw3EuVFjHUTNPiEUvnEnlx7SqtO1fzeihe/9
         7qzWAGB18FnsoRm6r/ZqeElMQoneuATkuSneq/j7CfdhEbmsNblz6LlFh+AAl0L8Prqf
         0bNlGedSfeQpwMeIuZbzZQyXvr9KyqKJJ8xt9RF04+HK1xeWPkJa0wZAP6taCBKrONY1
         axX6pX5aQgO9ljTrAiVSQv/nzI04Z47n5gGMTs0hF/ptJkZKjDMlkw0WazgVYBbiu2kQ
         HruEnZ49FR1FkSoWIUlTWrm0V8w/CMjr6DaxmF0stitiTz5Qzg/Mf7InGOCLtQAnQEbO
         Q8Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XFUextg8+A7izU4Qfr46JgCq2Cnv/dm+5SuqQWzRBHI=;
        b=JrisdDTj5SUW2sNKozfJ8olvIGNTJyQbjwJ96y4RAA8/kknzLFIqWW5urvNSs2lGpt
         ROZ3oU9vLNjoGebrDgzQNzWHnEMcS3Cr1RawVfvhE5DUPPGB36qaYeOxqgMXXPO1GKeK
         lZvYAahz7lt4LNQ9fB+Op8UHPYizyV7PHVDPdvamsodJ5n1JAAaiYcKj1XWpavr/Qgt8
         6dj13Awr+/Imof4y6RdbVcdWgmi2dLXQWjpDYJpZ//8pCz8VjxCeTNYDBCgvp+0xSC3a
         zIlqAqxcfuvhOZoIG3IjYt61NrACfH/ChB/95hNKKZerH0cCg1WdRChL5Exgg5hC0Hy0
         Vxtw==
X-Gm-Message-State: AJIora+JVqYpd8RZ/zeRTeI4N6Px+kdOp01YlxAyFN/cvf3faRfyC0hg
        dgw5DmEucGDY1zIQCAgDY9oddg==
X-Google-Smtp-Source: AGRyM1t3HupuXdDtzh950UmpV5k+Kyq/zQ+gQ2gpWHzwTdjh0AMWj2mnsmduiI9iI0h19bFUprJ8jA==
X-Received: by 2002:a17:902:ea4f:b0:16a:cfc:7f49 with SMTP id r15-20020a170902ea4f00b0016a0cfc7f49mr5712691plg.135.1657320963344;
        Fri, 08 Jul 2022 15:56:03 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id b7-20020a17090a12c700b001efa4a1bb3esm2170342pjg.35.2022.07.08.15.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 15:56:02 -0700 (PDT)
Date:   Fri, 8 Jul 2022 22:55:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jue Wang <juew@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Siddh Raman Pant <code@siddh.me>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Matlack <dmatlack@google.com>,
        Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v2 1/2] KVM: x86: Initialize nr_lvt_entries to a proper
 default value
Message-ID: <Ysi1/pldBpdtUt8y@google.com>
References: <20220706145957.32156-1-juew@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220706145957.32156-1-juew@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 06, 2022, Jue Wang wrote:
> Set the default value of nr_lvt_entries to KVM_APIC_MAX_NR_LVT_ENTRIES-1
> to address the cases when KVM_X86_SETUP_MCE is not called.
> 
> Fixes: 4b903561ec49 ("KVM: x86: Add Corrected Machine Check Interrupt (CMCI) emulation to lapic.")
> Signed-off-by: Jue Wang <juew@google.com>
> ---
>  arch/x86/kvm/lapic.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 8537b66cc646..257366b8e3ae 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2524,6 +2524,7 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
>  
>  	vcpu->arch.apic = apic;
>  
> +	apic->nr_lvt_entries = KVM_APIC_MAX_NR_LVT_ENTRIES - 1;

This works, but I don't love the subtle math nor the reliance on mcg_cap.MCG_CMCI_P
being clear by default.  I'll properly post the below patch next week (compile tested
only at this point).

From: Sean Christopherson <seanjc@google.com>
Date: Fri, 8 Jul 2022 15:38:51 -0700
Subject: [PATCH] KVM: x86: Initialize number of APIC LVT entries during APIC
 creation

Initialize the number of LVT entries during APIC creation, else the field
will be incorrectly left '0' if userspace never invokes KVM_X86_SETUP_MCE.

Add and use a helper to calculate the number of entries even though
MCG_CMCI_P is not set by default in vcpu->arch.mcg_cap.  Relying on that
to always be true is unnecessarily risky, and subtle/confusing as well.

Fixes: 4b903561ec49 ("KVM: x86: Add Corrected Machine Check Interrupt (CMCI) emulation to lapic.")
Reported-by: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Jue Wang <juew@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 6ff17d5a2ae3..1540d01ecb67 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -405,6 +405,11 @@ static inline bool kvm_lapic_lvt_supported(struct kvm_lapic *apic, int lvt_index
 	return apic->nr_lvt_entries > lvt_index;
 }

+static inline int kvm_apic_calc_nr_lvt_entries(struct kvm_vcpu *vcpu)
+{
+	return KVM_APIC_MAX_NR_LVT_ENTRIES - !(vcpu->arch.mcg_cap & MCG_CMCI_P);
+}
+
 void kvm_apic_set_version(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
@@ -2561,6 +2566,8 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 	}
 	apic->vcpu = vcpu;

+	apic->nr_lvt_entries = kvm_apic_calc_nr_lvt_entries(vcpu);
+
 	hrtimer_init(&apic->lapic_timer.timer, CLOCK_MONOTONIC,
 		     HRTIMER_MODE_ABS_HARD);
 	apic->lapic_timer.timer.function = apic_timer_fn;

base-commit: 4a627b0b162b9495f3646caa6edb0e0f97d8f2de
--

