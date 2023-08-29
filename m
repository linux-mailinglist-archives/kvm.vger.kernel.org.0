Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 776BC78BD30
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 05:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232746AbjH2DPK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Aug 2023 23:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234401AbjH2DOn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Aug 2023 23:14:43 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6752184
        for <kvm@vger.kernel.org>; Mon, 28 Aug 2023 20:14:33 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-58fc7afa4beso58473247b3.2
        for <kvm@vger.kernel.org>; Mon, 28 Aug 2023 20:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693278873; x=1693883673;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=H7r0FmL4Rt3tE8UPTlyCHBp7KWo6VePqpO90c3oIFgQ=;
        b=vHBG5kthW+WMTWHjWNtbySW6PYLYTZoXCTpQqh3R1mPDK0RoL3sMsfbOtWwfmgj+1u
         2kpVJ64vvFQflMWiI4DwYehrkcAQ7cBYi9OXrHqnTL2jZ6XioKPArpwOm9ntMg43zqXJ
         FYbK0yLM8yih8hTHxc0dmF68indvaOnn7Y6wXiAyltj5KlxK81kHQgNM1L/nCgDYORfj
         RbHTaOTlZDSqXX9JSUsGN11QVo+0Ym837I9lR23R8kMtbvofx8gOkTQTpCgqmo3XVdyj
         5ON0Frc8Be0qbLykKLwZh42Nw6gylR+MaWhr0RYQxNPuH3CIQWKRDJZKaVQehmBJfa1z
         1QhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693278873; x=1693883673;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H7r0FmL4Rt3tE8UPTlyCHBp7KWo6VePqpO90c3oIFgQ=;
        b=F1uj8S9OHMPVdY+e2t6aVQKLMeIWGA1WLcsofpcZJx4CCaxmN9cskP8nu4foyLFk/w
         yvtgIct91Gnxs+zLlVCtsHCRT6Af6VCerq8I8AltetFpp+w8804Tj/TLDsF9n+wYUtqg
         fyi9strXh5O8qDyx5/5gh2NW38LCtu9MXGPoZEs20iU234TP7NWK+bpn+px53p0Pue2J
         22C3uuiGcfUtBl2rKaeWcAMsZ+875Km3vAnJiWohP7VzVe4kVMnkmdY4HqdYcr6B4iBM
         J0RRbZodhL9ebTuohQtxavAUGn71KLlSchRZ1QhJy+Ti4D23FtA+6LrQh1mR3YxOiFIw
         V8jA==
X-Gm-Message-State: AOJu0Yx+DpMNOyc9dOhX/RVewSnFcZkE+tLBl+MpwEgJgLQpheQxdBAL
        4i3FiSRBpt8e/d/0XXQ4pEc/c3ADU8s=
X-Google-Smtp-Source: AGHT+IF2sPuxmT54rgiWZEO6+bRa4s/8PQ4PpuuqI7Ey8HdCRnwVLmUnK+ZWB+IHPDKoNK7l9wQ0QbcNqP0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:710:b0:592:7bfe:d479 with SMTP id
 bs16-20020a05690c071000b005927bfed479mr782428ywb.5.1693278873130; Mon, 28 Aug
 2023 20:14:33 -0700 (PDT)
Date:   Mon, 28 Aug 2023 20:11:21 -0700
In-Reply-To: <20230825014532.2846714-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230825014532.2846714-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.rc2.253.gd59a3bf2b4-goog
Message-ID: <169327846893.3063999.9479426554624511592.b4-ty@google.com>
Subject: Re: [PATCH] KVM: VMX: Refresh available regs and IDT vectoring info
 before NMI handling
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 24 Aug 2023 18:45:32 -0700, Sean Christopherson wrote:
> Reset the mask of available "registers" and refresh the IDT vectoring
> info snapshot in vmx_vcpu_enter_exit(), before KVM potentially handles a
> an NMI VM-Exit.  One of the "registers" that KVM VMX lazily loads is the
> vmcs.VM_EXIT_INTR_INFO field, which is holds the vector+type on "exception
> or NMI" VM-Exits, i.e. is needed to identify NMIs.  Clearing the available
> registers bitmask after handling NMIs results in KVM querying info from
> the last VM-Exit that read vmcs.VM_EXIT_INTR_INFO, and leads to both
> missed NMIs and spurious NMIs in the host.
> 
> [...]

Applied to kvm-x86 vmx, gonna try to squeeze this into the initial 6.6 pull
request as I got confirmation from another reporter that this fixed their
problem[*].  I'll make sure to make note of this patch in the pull request to
Paolo, worst case scenario I'll drop this one commit if Paolo spots something.

https://lore.kernel.org/all/SY4P282MB10841E53BAF421675FCE991D9DE0A@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM/

[1/1] KVM: VMX: Refresh available regs and IDT vectoring info before NMI handling
      https://github.com/kvm-x86/linux/commit/50011c2a2457

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
