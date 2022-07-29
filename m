Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 084D9585120
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 15:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236205AbiG2Nvq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 09:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236910AbiG2NvY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 09:51:24 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E905A72ECB
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 06:51:17 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id y9so4666147pff.12
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 06:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=f8C06rWDnabiVcFlgJ+UgwkudoctnDN6mfhX9wOsdF4=;
        b=o7qom6zQ0W8otqq7nXz0A4nViHUnNZbupgjcb281+K4RRXVe6OGv1IH4j/TOIuwILq
         g129ESd4HAONEy2mhnARHmHXW8gDI+KJ8FBQpQ9k5q0Y1BIJrJX52czJTfbG9oLtIFiK
         oAgDy5H4SriAcMiHGKiC069nAqxG/Gg0UP/7Bi+a6Eb/NOoFv1IJb83i3ebTXlaYgo/m
         tYZjPKEon4vBEeJWRunRWPaOAl1isLGnWKJ42+966fpgJppHp8jmmywydJy0Hz9jW2D0
         NShmnF0nVKvDXRe4OzrzgVO6y+mySZ90vvKcSla6wj4tf5AGzxeuw4X3ysuix+oGc7Tv
         wlAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=f8C06rWDnabiVcFlgJ+UgwkudoctnDN6mfhX9wOsdF4=;
        b=qKlUZq6fT24PgaX32bRuLkon6SsnKnwHVniJZrBjOUoxYLdHfk7sq4aeXiv2qRLzgX
         xQMNvr6DUol/XSYDElZ+NsrX+Dt/HUr+YlxSvUEp4U8STOf26vl+o5E9lGJGEP1i9CeM
         JTJUHeziacZ/lj7W+ExRc3aHqDDQqqawiHEDEEJm3aOFXjjnIa1e20yS2JiCM7rcuqPn
         CAt7zf3VjtMuKicxGi2EvsiJJ5tIxRjywMNnjzkURxLZrg2EMyXGx1KInWq4O650o9lh
         WCaS/tCi1WnPo8K7u0oN7c4RuBaiVSRK1wzD+wgw6WwLTli2P9wwUJqgiLbwvfGoWpBO
         6OLA==
X-Gm-Message-State: AJIora/KPAB3vkW2KbJ3Tm7ehelkbsRO3/Gy7CkVBMOCpltZabZVjqIp
        8vRmHqBPpPPIuTRmy/setGekPw==
X-Google-Smtp-Source: AGRyM1ugu0ZMAIN/uxPPceRZ9TJVJVgURFyIuWCGDMfS+TSwBEqBgq6vtS6SB72Bn/UXbF/ZBzpl/g==
X-Received: by 2002:a63:8049:0:b0:414:e8aa:b6bd with SMTP id j70-20020a638049000000b00414e8aab6bdmr3155757pgd.10.1659102677195;
        Fri, 29 Jul 2022 06:51:17 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id pt1-20020a17090b3d0100b001ef3cec7f47sm127468pjb.52.2022.07.29.06.51.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 06:51:16 -0700 (PDT)
Date:   Fri, 29 Jul 2022 13:51:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: x86: Refresh PMU after writes to
 MSR_IA32_PERF_CAPABILITIES
Message-ID: <YuPl0KqHPagKKAgo@google.com>
References: <20220727233424.2968356-1-seanjc@google.com>
 <20220727233424.2968356-2-seanjc@google.com>
 <271bddfa-9e48-d5f6-6147-af346d7946bf@gmail.com>
 <YuKqyTvbVx2UyP2w@google.com>
 <5090d500-1549-79ba-53a9-4929114eb569@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5090d500-1549-79ba-53a9-4929114eb569@gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 29, 2022, Like Xu wrote:
> On 28/7/2022 11:27 pm, Sean Christopherson wrote:
> > On Thu, Jul 28, 2022, Like Xu wrote:
> > > On 28/7/2022 7:34 am, Sean Christopherson wrote:
> > > > Refresh the PMU if userspace modifies MSR_IA32_PERF_CAPABILITIES.  KVM
> > > > consumes the vCPU's PERF_CAPABILITIES when enumerating PEBS support, but
> > > > relies on CPUID updates to refresh the PMU.  I.e. KVM will do the wrong
> > > > thing if userspace stuffs PERF_CAPABILITIES _after_ setting guest CPUID.
> > > 
> > > Unwise userspace should reap its consequences if it does not break KVM or host.
> > 
> > I don't think this is a case of userspace being weird or unwise.  IMO, setting
> > CPUID before MSRs is perfectly logical and intuitive.
> 
> The concern is whether to allow changing the semantically featured MSR value
> (as an alternative to CPUID or KVM_CAP.) from user space after the guest CPUID
> is finalized or the guest has run for a while.

Hrm, I forgot about that problem.

> > KVM does have "rules" in the sense that it has an established ABI for things
> > like KVM_CAP and module params, though documentation may be lacking in some cases.
> > The CPUID and MSR ioctls don't have a prescribe ordering though.
> 
> Should we continue with this inter-dependence (as a silent feature) ?
> The patch implies that it should be left as it is in order not to break any
> user space.
> 
> How we break out of this rut ?

The correct fix in KVM is to reject writes to feature MSRs after KVM_RUN.  KVM
already does this for CPUID.   I'm pretty sure KVM needs to allow writes with the
same value to support QEMU's hotplug behavior, but that's easy enough to handle
(in theory).  There are few enough feature MSRs that I think we can get away with
a linear walk, e.g.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5366f884e9a7..fffc57dea304 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2150,6 +2150,22 @@ static int do_get_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)

 static int do_set_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 {
+       u64 current_val;
+       int i;
+
+       if (vcpu->arch.last_vmentry_cpu != -1 && index != MSR_IA32_UCODE_REV) {
+               for (i = 0; i < num_msr_based_features; i++) {
+                       if (index != msr_based_features[i])
+                               continue;
+
+                       if (do_get_msr(vcpu, index, &current_val) ||
+                           *data != current_val)
+                               return -EINVAL;
+
+                       return 0;
+               }
+       }
+
        return kvm_set_msr_ignored_check(vcpu, index, *data, true);
 }


