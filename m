Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30B794C71CC
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 17:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237960AbiB1Qer (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 11:34:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237965AbiB1Qeo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 11:34:44 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5832147078
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 08:34:02 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id s11so1090343pfu.13
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 08:34:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7sXWiwrkTFLBiy3HiF28IEOXkCRsXA6X0D5m/kmUEDE=;
        b=KLGJxN9fEocNTWpAlrzYvOTGdT4InWUttQAT2IlxOo7tmi8Od3T/Wswsi347GdEf2p
         Va2Ah6M+Wol56tYa27SXMnIXpGfPwD+zMPfDvMKJGYDm/QwgOOZwxWRJ7UzbOBDb15kw
         SF7AwmQu64bYr5/gqRRPtwtOQ1f9EgIA8XyzuH2d6U71yqge5+7jy/6WnCkP2bs8wxy3
         lKtwlab1u4hjNfIX8REhKVZOASEXnwfRjD1WndhrkS2SYO88vteqmjp/cTLu3xPt0hBu
         Et+6Qj9Z61EV6I/ZRMCoJgVG2VvWxkmn5jmXeqAztItmOchX9nXi25QqZvgFo0dQcP28
         mZ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7sXWiwrkTFLBiy3HiF28IEOXkCRsXA6X0D5m/kmUEDE=;
        b=E4nN+rQ2y6zbnHbCRJkfMQJQxbiIxFehbkUrOw11xJODHxkXUPQdFwwulPBUbUH62d
         zeivBa87XE/+CUbKZJ+BdVb6lMm8S+/Zwq/UmP9zDJk4W60R3puxGfm6zStVFEEdL+b2
         5cHw05A+m4F10hFuwNAVrx67Cm6wSeBipLoYj8cIGTgKFH7+hwR4A8tj3KFq4+4MCQIJ
         iTUE0V04JL58WxjWgXabGbqbLcP1ARh0uCwsP2Aw9pZoBzodbrFYQTYSxdRefHzgPXO1
         zlbUdAYQKB38JP3L5DXxc42F0UVysmzaUGu1CVn8nfCCGlgscu4+ahyzTES7zXHojsEX
         9JmQ==
X-Gm-Message-State: AOAM532tydXVrvE1QPOzHop+ZqZFYHKzhmrg9f9HJekLG9+Gx1/WduUv
        g39Ycy/18mqOtuX2uaeKaKyMlw==
X-Google-Smtp-Source: ABdhPJzXCgVxeVuTj6VeBf2hy3AknSZCEgyupjJYCriSOyOEZNUbBgqKhxC7CmAiSFickBD0N9usLg==
X-Received: by 2002:a63:4c46:0:b0:378:4b82:aa9e with SMTP id m6-20020a634c46000000b003784b82aa9emr12782184pgl.331.1646066041509;
        Mon, 28 Feb 2022 08:34:01 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o12-20020a17090aac0c00b001b9e5286c90sm274682pjq.0.2022.02.28.08.34.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 08:34:00 -0800 (PST)
Date:   Mon, 28 Feb 2022 16:33:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>
Subject: Re: [PATCH] KVM: x86: Introduce KVM_CAP_DISABLE_QUIRKS2
Message-ID: <Yhz5dRH/7gF45Zee@google.com>
References: <20220226002124.2747985-1-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220226002124.2747985-1-oupton@google.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 26, 2022, Oliver Upton wrote:
> KVM_CAP_DISABLE_QUIRKS is irrevocably broken. The capability does not
> advertise the set of quirks which may be disabled to userspace, so it is
> impossible to predict the behavior of KVM. Worse yet,
> KVM_CAP_DISABLE_QUIRKS will tolerate any value for cap->args[0], meaning
> it fails to reject attempts to set invalid quirk bits.

FWIW, we do have a way out without adding another capability.  The 'flags' field
is enforced for all capabilities, we could use a bit there to add "v2" functionality.
Userspace can assume KVM_QUIRK_ENFORCE_QUIRKS is allowed if the return from probing
the capability is >1.

It's gross and forced, just an idea if we want to avoid yet another cap.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c712c33c1521..2a8449d1cf24 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4229,7 +4229,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
        case KVM_CAP_HYPERV_TIME:
        case KVM_CAP_IOAPIC_POLARITY_IGNORED:
        case KVM_CAP_TSC_DEADLINE_TIMER:
-       case KVM_CAP_DISABLE_QUIRKS:
        case KVM_CAP_SET_BOOT_CPU_ID:
        case KVM_CAP_SPLIT_IRQCHIP:
        case KVM_CAP_IMMEDIATE_EXIT:
@@ -4254,6 +4253,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
        case KVM_CAP_VAPIC:
                r = 1;
                break;
+       case KVM_CAP_DISABLE_QUIRKS:
+               r = KVM_X86_VALID_QUIRKS;
+               break;
        case KVM_CAP_EXIT_HYPERCALL:
                r = KVM_EXIT_HYPERCALL_VALID_MASK;
                break;
@@ -5892,11 +5894,19 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 {
        int r;

-       if (cap->flags)
+       if (cap->flags && cap->cap != KVM_CAP_DISABLE_QUIRKS)
                return -EINVAL;

        switch (cap->cap) {
        case KVM_CAP_DISABLE_QUIRKS:
+               r = -EINVAL;
+               if (cap->flags & ~KVM_QUIRK_ENFORCE_QUIRKS)
+                       break;
+
+               if ((cap->flags & KVM_QUIRK_ENFORCE_QUIRKS) &&
+                   (cap->args[0] & ~KVM_X86_VALID_QUIRKS))
+                       break;
+
                kvm->arch.disabled_quirks = cap->args[0];
                r = 0;
                break;

> +7.30 KVM_CAP_DISABLE_QUIRKS2
> +----------------------------
> +
> +:Capability: KVM_CAP_DISABLE_QUIRKS2
> +:Parameters: args[0] - set of KVM quirks to disable
> +:Architectures: x86
> +:Type: vm
> +
> +This capability, if enabled, will cause KVM to disable some behavior
> +quirks.
> +
> +Calling KVM_CHECK_EXTENSION for this capability returns a bitmask of
> +quirks that can be disabled in KVM.
> +
> +The argument to KVM_ENABLE_CAP for this capability is a bitmask of
> +quirks to disable, and must be a subset of the bitmask returned by
> +KVM_CHECK_EXTENSION.
> +
> +The valid bits in cap.args[0] are:
> +
> +=================================== ============================================
> + KVM_X86_QUIRK_LINT0_ENABLED        By default, the reset value for the LVT

LINT0_REEANBLED.
