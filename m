Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 413EA31DEA7
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 18:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234688AbhBQR6p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 12:58:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232216AbhBQR6n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Feb 2021 12:58:43 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5645C061756
        for <kvm@vger.kernel.org>; Wed, 17 Feb 2021 09:58:02 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id m2so8964047pgq.5
        for <kvm@vger.kernel.org>; Wed, 17 Feb 2021 09:58:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PoIPEb3cJaoO15qUdGXOK4VdWSU6X8gTdQslJu2SzXM=;
        b=mwiH+KOkEgPnBs2j/jYq/1jyU2RT2Qt36YKFXAkBxmz9L2jqBKuI5OO4cJFSKXxHi5
         45ykmUuHr8SyEpxAnzI7auY/HZFBtlmVCylljSEvVeZXMY4HMi51jsD36gG30NL9C18R
         9bMmO67O/8A1V/xjWQcX08hs/wF8nao6ghFTP/QE8dnW4d4NpFlmb7iTzttrM/6fihd1
         /qfK4ybyULMnVOPNCRFhxz9u48ivHDkQqLaC54XISNr2eKsh7aSJXBXOFfm2RqwWGniH
         bu5QLD79IHivALbhEm1Zu6xLfKmTQO6I7Aex8nEqylDLe4WspGvFGIBH+6fKNy/e8IBC
         AxWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PoIPEb3cJaoO15qUdGXOK4VdWSU6X8gTdQslJu2SzXM=;
        b=PcDZf+ysf5hp19ebT7HKcf5gNfpgzGxzMkF/8dEvOj0N7/sXbDzmLTvXvTV8Eh4j47
         ADcPh5CAhV/waN5IcSNBCi6mJlPkpMWLwvfgL4hOgE1ce/COeZVknUIqwrg3if9Gz5ar
         MHYWMzrUIgMHt77HRYV/1ycdkAVN51MgDPAzAlsrtQbSEcDxRTkHc/Poe35++YYhf3ek
         TMDk5tgOSCbZ4sAP+Zh4PullsFhFMw5ovAl72Rt/ZkIEAUWpUBGlcEMZs4zZPS3O2oKO
         0RMsfGcP/C/LLAHlqa7jPujo6zhb8WdWuJ8CrMn8apOaDG/4lYht8eow6TmvFtgmo4yk
         FAHQ==
X-Gm-Message-State: AOAM5321P/RZ/XhdAKswvsL2tVnNOzwW+PNepKKn3teHAx0TgX2qMgkm
        KI7GowpL2scaKowr7A5KS6HC4g==
X-Google-Smtp-Source: ABdhPJyjyz+ZCBmOTi2t6osFAbSVUzTL5//qYLsDcNG1WP1Apmj9aEkE1RhuACgO+bjOlTRW25k1DQ==
X-Received: by 2002:a63:5453:: with SMTP id e19mr450722pgm.439.1613584682279;
        Wed, 17 Feb 2021 09:58:02 -0800 (PST)
Received: from google.com ([2620:15c:f:10:6948:259b:72c6:5517])
        by smtp.gmail.com with ESMTPSA id y67sm2975404pfb.71.2021.02.17.09.58.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 09:58:01 -0800 (PST)
Date:   Wed, 17 Feb 2021 09:57:55 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 4/7] KVM: nVMX: move inject_page_fault tweak to
 .complete_mmu_init
Message-ID: <YC1ZI6DW49u0UP7m@google.com>
References: <20210217145718.1217358-1-mlevitsk@redhat.com>
 <20210217145718.1217358-5-mlevitsk@redhat.com>
 <YC1ShhSZ+6ST63nZ@google.com>
 <5a8bea9b-deb1-673a-3dc8-f08b679de4c5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a8bea9b-deb1-673a-3dc8-f08b679de4c5@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 17, 2021, Paolo Bonzini wrote:
> On 17/02/21 18:29, Sean Christopherson wrote:
> > All that being said, I'm pretty we can eliminate setting
> > inject_page_fault dynamically. I think that would yield more
> > maintainable code. Following these flows is a nightmare. The change
> > itself will be scarier, but I'm pretty sure the end result will be a lot
> > cleaner.
> 
> I had a similar reaction, though my proposal was different.
> 
> The only thing we're changing in complete_mmu_init is the page fault
> callback for init_kvm_softmmu, so couldn't that be the callback directly
> (i.e. something like context->inject_page_fault =
> kvm_x86_ops.inject_softmmu_page_fault)?  And then adding is_guest_mode to
> the conditional that is already in vmx_inject_page_fault_nested and
> svm_inject_page_fault_nested.

Heh, that exact code crossed my mind as well.

> That said, I'm also rusty on _why_ this code is needed.  Why isn't it enough
> to inject the exception normally, and let nested_vmx_check_exception decide
> whether to inject a vmexit to L1 or an exception into L2?

Hmm, I suspect it was required at one point due to deficiencies elsewhere.
Handling this in the common fault handler logic does seem like the right
approach.

> Also, bonus question which should have been in the 5/7 changelog: are there
> kvm-unit-tests testcases that fail with npt=0, and if not could we write
> one?  [Answer: the mode_switch testcase fails, but I haven't checked why].
> 
> 
> Paolo
> 
