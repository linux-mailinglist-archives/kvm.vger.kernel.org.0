Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AAEA767B4B
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 03:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237718AbjG2BmX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 21:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237587AbjG2BmF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 21:42:05 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53575FDF
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:41:16 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1bbb97d27d6so18495435ad.1
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690594875; x=1691199675;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=etHIErEcW2Snp48GMQTn4g9bxzrUdUzMcla8D7qkAKU=;
        b=NYiDMaTVhIAWqq2Ku68RdD957FUpBniR7RICpd5Ta09Re7OeUgl3W+OEMsjWPdln08
         CJUpUT+gN+e7y12/Jmtw9OK/yUGfFrF0aCGTfISkVXFlrfzCfe6JEhpxpQxcSfXu4Zar
         QFlbWgnGGbV2L7tbZ3Ml+7OSARYS6BW1hrXOYGgW8AR729AU438PBsH8dUTu0xLfuOVM
         /cZ/Guv0sEuG/xN+qbxm8Fmks6OZNOYfX087Ejj0cZXQc84D35YWo4l9+6yMV7vnh9WY
         GTn0ni7vkbyhH3Fjlt9O2wGe37ppCa/NiCE1vyOifDl+V3vRrHTZmlxHlaajqNl/WpeH
         cGvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690594875; x=1691199675;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=etHIErEcW2Snp48GMQTn4g9bxzrUdUzMcla8D7qkAKU=;
        b=SM4iKqk/RJbRj/7bNWppv6MvqbpXCL4jigbfTclQBaKwmB4UnhgRBeaYtuoxo9KM8o
         HaDpMqLv2lDMsPUFXzlqqEcdTin7UBgVZD03m9StxLQcYDZdWhtsuZISgx3i/ZK9ORht
         6hXEiNypUt3JNG7FJH8c4BOGp/TMb6apCZ4fwtiVCs4ytpEYSw6zBiybf3sjnOBYfbNI
         Gku5cHkssd9ib7n9pd4TJbtlI0VmY6iG+4D0PEAfOn7QEcJcbqPergIasRLABjbyyqpu
         vWbPEEPdzlpf7lQIqLeheWRzQX2CYSDUbyyjZAgOvGjO54rfDch84XTExwbJXDtMrXi2
         VX1g==
X-Gm-Message-State: ABy/qLZ5Wl8R8s4WvrQt4AvRnzsCNOoXwMB6Wj9oaxfNN5ISuw6Y3C+D
        oR1bcUQG3SQP9Tj9Aj/c8DVHenLkiOk=
X-Google-Smtp-Source: APBJJlEgel2xyk023tQstWnd108PwEKYO8pRsbSFOhwxNCzG4vrLLyhebl7F/zmViiPb+nRZMMcJ8NjGMt4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2445:b0:1bb:c7bc:ce9a with SMTP id
 l5-20020a170903244500b001bbc7bcce9amr13831pls.10.1690594873732; Fri, 28 Jul
 2023 18:41:13 -0700 (PDT)
Date:   Fri, 28 Jul 2023 18:41:12 -0700
In-Reply-To: <20230726135945.260841-1-mlevitsk@redhat.com>
Mime-Version: 1.0
References: <20230726135945.260841-1-mlevitsk@redhat.com>
Message-ID: <ZMRuON4m1qZZWWip@google.com>
Subject: Re: [PATCH v2 0/3] Fix 'Spurious APIC interrupt (vector 0xFF) on
 CPU#n' issue
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 26, 2023, Maxim Levitsky wrote:
> Maxim Levitsky (3):
>   KVM: x86: VMX: __kvm_apic_update_irr must update the IRR atomically
>   KVM: x86: VMX: set irr_pending in kvm_apic_update_irr
>   KVM: x86: check the kvm_cpu_get_interrupt result before using it
> 
>  arch/x86/kvm/lapic.c | 25 +++++++++++++++++--------
>  arch/x86/kvm/x86.c   | 10 +++++++---
>  2 files changed, 24 insertions(+), 11 deletions(-)

Paolo, are you still planning on taking these directly?  I can also grab them
and send them your way next week.  I have a couple of (not super urgent, but
kinda urgent) fixes for 6.5 that I'm planning on sending a PULL request for, just
didn't get around to that today.
