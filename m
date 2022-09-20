Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1317D5BEB5A
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 18:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbiITQu7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 12:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiITQu6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 12:50:58 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D31AA4DB05
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 09:50:56 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id a80so3302024pfa.4
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 09:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date;
        bh=tJ0MDKHA5vJWXi8Ax19UpV1RwrQzRYfQtWqOPMNkLRk=;
        b=VpoSh0W+roXAOOUC1IOpPs0jUIbaT+zaUdv0d9am+Sy+f0b/uoPGLwa6FWar9awTZv
         eDPU3myte8MmUH1EIuskCJKCZu0c5Ga9LPgPtdJGe4X/FhS0kdyDs7XsO1MUiU5f/Da8
         XEA5HSWAL0keqXxehoTmvtlPCIVWwACMNzcFXuOzeq4MYTk8wOqOEquIQpCcrsfiAlDD
         qtUB2R469plVNherjgOqWCgoWAJrKEL161ftZC0wEf6FbIAyb12XJq5B9C5E1OJjClaP
         3A9s+Dyg6tpn7q5FgjHLGW5z5QbfFmS5e5Ld87UzFr3//rm/O+/53e5wc6mEtf5gGotG
         BbzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=tJ0MDKHA5vJWXi8Ax19UpV1RwrQzRYfQtWqOPMNkLRk=;
        b=Pj5Hbkm3H46vy+vaFUdidiQnRJK3t06rQqIOArwguJRqT9VMADRjxBmxqyaTrJUezp
         YVIP6wadRlgc7b4j6voA6zbAyc0HHOb6RaZUHBn1bZ5TqTVLpawLxdAPLrCyo+Q36aKE
         PMBgISzFxWaLcCyiNMlr/Ys2D94TECsHMc6Yt7LEVMDbgcDMXpZCD7y8+8MjWMjIqwFF
         iTmX/Jlc/qZsymWd1GkkgX6Ly7xB55rQvSMKMQca6DosNEqGklAtIWVGeh3FbP+RXyl3
         mhRmS3/8/idhdZXFMDfJ7Dyi/12eL9uTVQekP3vVyHdhyjdSThxg51F0Ct4p7TSMg+sA
         qc9A==
X-Gm-Message-State: ACrzQf1HC+knC1y8Zw3K52ockMR6IkF0lmdMNJrIQr+PToSSx6R1PL2L
        wOnZv53JFfxO8qU43dYXM6nocd/qp7zLjA==
X-Google-Smtp-Source: AMsMyM4xd5P7ZoJYaPrBy3SINvZGFjwpUij8ReLC2fPc2M4OwJdq/xwDUJ7AkIFnLQT45qqXjsmmoA==
X-Received: by 2002:a05:6a00:c86:b0:542:7c38:4a59 with SMTP id a6-20020a056a000c8600b005427c384a59mr25241917pfv.74.1663692656216;
        Tue, 20 Sep 2022 09:50:56 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c10-20020a170902d48a00b0016c0eb202a5sm98149plg.225.2022.09.20.09.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 09:50:55 -0700 (PDT)
Date:   Tue, 20 Sep 2022 16:50:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Subject: Re: [PATCH v2 04/23] KVM: x86: Inhibit AVIC SPTEs if any vCPU
 enables x2APIC
Message-ID: <Yynva7GV+XpU0Llx@google.com>
References: <20220903002254.2411750-1-seanjc@google.com>
 <20220903002254.2411750-5-seanjc@google.com>
 <8a24c36efebfa4fb302587a74e3bc1e088e17be8.camel@redhat.com>
 <Yyngcg3ainoD0fNc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yyngcg3ainoD0fNc@google.com>
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

On Tue, Sep 20, 2022, Sean Christopherson wrote:
> On Tue, Sep 20, 2022, Maxim Levitsky wrote:
> > On Sat, 2022-09-03 at 00:22 +0000, Sean Christopherson wrote:
> > > Reintroduce APICV_INHIBIT_REASON_X2APIC as a "partial" inhibit for AMD
> > > to fix a bug where the APIC access page is visible to vCPUs that have
> > > x2APIC enabled, i.e. shouldn't be able to "see" the xAPIC MMIO region.
> > > 
> > > On AMD, due to its "hybrid" mode where AVIC is enabled when x2APIC is
> > > enabled even without x2AVIC support, the bug occurs any time AVIC is
> > > enabled as x2APIC is fully emulated by KVM.  I.e. hardware isn't aware
> > > that the guest is operating in x2APIC mode.
> > > 
> > > Opportunistically drop the "can" while updating avic_activate_vmcb()'s
> > > comment, i.e. to state that KVM _does_ support the hybrid mode.  Move
> > > the "Note:" down a line to conform to preferred kernel/KVM multi-line
> > > comment style.
> > > 
> > > Leave Intel as-is for now to avoid a subtle performance regression, even
> > > though Intel likely suffers from the same bug.  On Intel, in theory the
> > > bug rears its head only when vCPUs share host page tables (extremely
> > > likely) and x2APIC enabling is not consistent within the guest, i.e. if
> > > some vCPUs have x2APIC enabled and other does do not (unlikely to occur
> > > except in certain situations, e.g. bringing up APs).
> > 
> > Are you sure about this?
> 
> Ah, no.  The key on Intel is the separate VMCS control for virtualizing xAPIC
> accesses.  As you note below, KVM will provide memory semantics, which is technically
> wrong.
> 
> > This is what I am thinking will happen, I might be wrong but I am not sure:
> 
> ...
> 
> > 3. guest accesses the 0xfee00xxx, assuming APICv/x2avic, the hardware won't redirect
> > the access to apic backing page, but will instead just use that SPTE and let the guest
> > read/write the private page that we mapped in the range, which is wrong.
> > 
> > Am I missing something?
> 
> No, I don't believe so.  I'm still hesitant to add the effetive inhibit to Intel,
> though that's probably just pure paranoia at this point.  Probably makes sense to
> just do it and verify that x2APIC virtualization still works.

Scratch that, Intel can end up with memory semantics irrespective of x2APIC, e.g.
if APICv is enabled but a vCPU disables its APIC.  We could force a bus error by
inhibiting APICv if any vCPU has its APIC hardware disabled, but IMO that's a bad
tradeoff as there are legitimate reasons to disable the APIC on select vCPUs.

So, I'll omit Intel from the x2APIC pseudo-inhibit, and maybe add a KVM erratum
to document that KVM may provide memory semantics for APIC_BASE when APICv/AVIC
is enabled.
