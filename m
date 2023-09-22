Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7572C7AB98B
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 20:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbjIVSqt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 14:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjIVSqr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 14:46:47 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039D7AB
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 11:46:42 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1c5b1e55d5eso22048185ad.3
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 11:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695408401; x=1696013201; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=00AG5nfMcCEryiAXl2nXsmLTxTv6ntIW1FODct26ihI=;
        b=BW4SFsGGXZFMtBxO1yFDGq24CM2oWahvhqJp6H836idcd93iY77GlUAauxhm2TSqnA
         OAsPNilCmNYIJ9QFa3qADtByOywiUU9WOT/T/rMUJazFmbrGrmmieaET+C83l/lYdaaI
         tXbNElTUpieWce37G+KtOdCQA6TxAw1tt6KoephehQ+8Om4VaGgvhGHFJs8OrSw7HHrg
         b6tLjvfGA+rWIpH1oL16gWvl5K0JkEScOnd8gYOM+D2TIkWQChcek2Aooxc1zervJXNx
         fQmWjQgXzDZ1CHJyO58IVSyZtK45H5q1FHJhnagvb690/1vxAw7Pd8+LszlYclZbL6x4
         ciOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695408401; x=1696013201;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=00AG5nfMcCEryiAXl2nXsmLTxTv6ntIW1FODct26ihI=;
        b=SosZv4BbDvAfTvotcR8ECBCN9Fts8fUgLWCOKz7kK+Zw0etlRIIt9iJWqhJ15TOwXE
         o4TnV6DpJR92hJc/S7zg/22aXmp5KbzVEG/3Cb3IM/uCV2w+tr17Gxyw3hGSTr6RjN6n
         nBQqTBw88cx9OMLKQ+RhOqnObb5146jIb0fZn3rO8wwQ7tc1UUNzNJAllcqQTdE6Sti+
         bVRjl/k6m0qxKGnIxRxVcQr74/vrHOB684Kgg1DL/R47Q3EK1M7gXhpE6LGSM7Q9v5Nj
         MjtjL5J2oBkNQgadp1LZU7E3BwudIZLTTPlzxS6x91CJ08X9dBi3ELRR0bDMn2ZRL2TI
         d1wg==
X-Gm-Message-State: AOJu0YyUeBQlJ1cDwSJP+dIjiTlTjUMRmUn8+kBcJsTM44/j/bV41QEx
        Ze/MSfoCQqGQrIcWdinmBmevO1mP1hU=
X-Google-Smtp-Source: AGHT+IE8atdcTI1/rym9RFFNZzF9uOcZ7bVSo+yqYQkvECiGua5UyMBpz0VfMvdtWrUWyrSk/P7mbICx+jY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:41c2:b0:1bf:cc5:7b57 with SMTP id
 u2-20020a17090341c200b001bf0cc57b57mr4298ple.3.1695408401449; Fri, 22 Sep
 2023 11:46:41 -0700 (PDT)
Date:   Fri, 22 Sep 2023 11:46:39 -0700
In-Reply-To: <20230901185646.2823254-1-jmattson@google.com>
Mime-Version: 1.0
References: <20230901185646.2823254-1-jmattson@google.com>
Message-ID: <ZQ3hD+zBCkZxZclS@google.com>
Subject: Re: [PATCH 1/2] KVM: x86: Synthesize at most one PMI per VM-exit
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Like Xu <likexu@tencent.com>,
        Mingwei Zhang <mizhang@google.com>,
        Roman Kagan <rkagan@amazon.de>,
        Kan Liang <kan.liang@intel.com>,
        Dapeng1 Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 01, 2023, Jim Mattson wrote:
> When the irq_work callback, kvm_pmi_trigger_fn(), is invoked during a
> VM-exit that also invokes __kvm_perf_overflow() as a result of
> instruction emulation, kvm_pmu_deliver_pmi() will be called twice
> before the next VM-entry.
> 
> That shouldn't be a problem. The local APIC is supposed to
> automatically set the mask flag in LVTPC when it handles a PMI, so the
> second PMI should be inhibited. However, KVM's local APIC emulation
> fails to set the mask flag in LVTPC when it handles a PMI, so two PMIs
> are delivered via the local APIC. In the common case, where LVTPC is
> configured to deliver an NMI, the first NMI is vectored through the
> guest IDT, and the second one is held pending. When the NMI handler
> returns, the second NMI is vectored through the IDT. For Linux guests,
> this results in the "dazed and confused" spurious NMI message.
> 
> Though the obvious fix is to set the mask flag in LVTPC when handling
> a PMI, KVM's logic around synthesizing a PMI is unnecessarily
> convoluted.

To address Like's question about whether not this is necessary, I think we should
rephrase this to explicitly state this is a bug irrespective of the whole LVTPC
masking thing.

And I think it makes sense to swap the order of the two patches.  The LVTPC masking
fix is a clearcut architectural violation.  This is a bit more of a grey area,
though still blatantly buggy.

So, put this patch second, and replace the above paragraphs with something like?

  Calling kvm_pmu_deliver_pmi() twice is unlikely to be problematic now that
  KVM sets the LVTPC mask bit when delivering a PMI.  But using IRQ work to
  trigger the PMI is still broken, albeit very theoretically.

  E.g. if the self-IPI to trigger IRQ work is be delayed long enough for the
  vCPU to be migrated to a different pCPU, then it's possible for
  kvm_pmi_trigger_fn() to race with the kvm_pmu_deliver_pmi() from
  KVM_REQ_PMI and still generate two PMIs.

  KVM could set the mask bit using an atomic operation, but that'd just be
  piling on unnecessary code to workaround what is effectively a hack.  The
  *only* reason KVM uses IRQ work is to ensure the PMI is treated as a wake
  event, e.g. if the vCPU just executed HLT.

> Remove the irq_work callback for synthesizing a PMI, and all of the
> logic for invoking it. Instead, to prevent a vcpu from leaving C0 with
> a PMI pending, add a check for KVM_REQ_PMI to kvm_vcpu_has_events().
