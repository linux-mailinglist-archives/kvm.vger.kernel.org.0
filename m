Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE18074F235
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 16:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233677AbjGKO1P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 10:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233449AbjGKO1B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 10:27:01 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 142FC2139
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 07:26:17 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-57745160c1dso65000137b3.2
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 07:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689085527; x=1691677527;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=p56sBbCS+VPrS5cOX2wwAyiH2Cg/fGXPAAbSLjc9HmQ=;
        b=G9ZmthhhEWojkB7p9qdG0NlmayOu64h8X2dBXxGMYbiFdGXXEUX2oyzC6fFrumID5N
         98vlOxYGDbsB8BsZYbCu5+cNjdgpXDDF3wPvFmpX1D/3wiXeEI7iIbWaLd2Y8S1kcK51
         g9AEp3AGfRn3IH5ErdyFegxvkav3Hez4Pqo60UTx9c8Mo77h2wLDQUn/qNlpfbjeYv3l
         BXG4TLJ1lnjA9oyO1JcxOVrUNvF1oP+UeGFwZ78x/HxF67SpfkkngNuMfv0ud6ParpnM
         ur81S62LVTRhXeUfmkPypJAXBF0q5GmQYpveV1kpJbP42oZcLd7cONmfF2+Ipt3sxdG7
         gZpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689085527; x=1691677527;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p56sBbCS+VPrS5cOX2wwAyiH2Cg/fGXPAAbSLjc9HmQ=;
        b=e1tJwxzs59by3yvmiwyupxPIPcwdEIAHMmwG8ywBI6KwaUiy1pOx+i9cmQEEenn/u4
         MhfahZorNcSqJahn7tLvlzXLmkayMwfx2MZmo8pz+4NjAPiIGaiJd6wuTHZ/v+qUW7jo
         6dq5hRV07dS2RgFZLZFbOekZ+UOCiPAofd1Cw2LtNSxFWfMyEURVbg8+bta+3GpcT6g1
         dK391bcQdf5lIPtL1pdBxlugol4vIX+uk0ndAmy1+47Gmv9mykhIxXBQYvT9QBnrodm/
         uQrkhjw3W2PW8dcjovdoDA72FutpXNzgNvdQ0dPEpp6Py57/lNhY0fb1QW300+Z/OQyQ
         zy0A==
X-Gm-Message-State: ABy/qLbayCv4s5AD+F7teiLhsIWsKj7yZSdV4v9+5Euld7xFGl1NcfS0
        a71UObLI40HqRe948w0OBmR9Gx8K924=
X-Google-Smtp-Source: APBJJlGypUsi6FziBQD/5n1q9oaBq8wtOZmggi8VuvEfNqxbkCHQTwUdZQaONZSNZ8Qt3Y2NvWdpI/kBNjM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ac44:0:b0:55d:6af3:1e2c with SMTP id
 z4-20020a81ac44000000b0055d6af31e2cmr126252ywj.3.1689085527641; Tue, 11 Jul
 2023 07:25:27 -0700 (PDT)
Date:   Tue, 11 Jul 2023 07:25:26 -0700
In-Reply-To: <ZKzSf82kuik7wYkA@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-4-amoorthy@google.com>
 <ZIn6VQSebTRN1jtX@google.com> <ZKf7+D474ESdNP3D@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <CAF7b7mr7BZayOxE2y8K87+AfYuGoDc7_kA2ouA3kBuhSgDiomg@mail.gmail.com> <ZKzSf82kuik7wYkA@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
Message-ID: <ZK1mVriphYnZu6Cd@google.com>
Subject: Re: [PATCH v4 03/16] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
From:   Sean Christopherson <seanjc@google.com>
To:     Kautuk Consul <kconsul@linux.vnet.ibm.com>
Cc:     Anish Moorthy <amoorthy@google.com>, oliver.upton@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
        maz@kernel.org, robert.hoo.linux@gmail.com, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 11, 2023, Kautuk Consul wrote:
> > > That said, I agree that there's a risk that KVM could clobber vcpu->run_run by
> > > hitting an -EFAULT without the vCPU loaded, but that's a solvable problem, e.g.
> > > the helper to fill KVM_EXIT_MEMORY_FAULT could be hardened to yell if called
> > > without the target vCPU being loaded:
> > >
> > >     int kvm_handle_efault(struct kvm_vcpu *vcpu, ...)
> > >     {
> > >         preempt_disable();
> > >         if (WARN_ON_ONCE(vcpu != __this_cpu_read(kvm_running_vcpu)))
> > >             goto out;
> > >
> > >         vcpu->run->exit_reason = KVM_EXIT_MEMORY_FAULT;
> > >         ...
> > >     out:
> > >         preempt_enable();
> > >         return -EFAULT;
> > >     }
> > 
> > Ancient history aside, let's figure out what's really needed here.
> > 
> > > Why use WARN_ON_ONCE when there is a clear possiblity of preemption
> > > kicking in (with the possibility of vcpu_load/vcpu_put being called
> > > in the new task) before preempt_disable() is called in this function ?
> > > I think you should use WARN_ON_ONCE only where there is some impossible
> > > or unhandled situation happening, not when there is a possibility of that
> > > situation clearly happening as per the kernel code.
> > 
> > I did some mucking around to try and understand the kvm_running_vcpu
> > variable, and I don't think preemption/rescheduling actually trips the
> > WARN here? From my (limited) understanding, it seems that the
> > thread being preempted will cause a vcpu_put() via kvm_sched_out().
> > But when the thread is eventually scheduled back in onto whatever
> > core, it'll vcpu_load() via kvm_sched_in(), and the docstring for
> > kvm_get_running_vcpu() seems to imply the thing that vcpu_load()
> > stores into the per-cpu "kvm_running_vcpu" variable will be the same
> > thing which would have been observed before preemption.
> > 
> > All that's to say: I wouldn't expect the value of
> > "__this_cpu_read(kvm_running_vcpu)" to change in any given thread. If
> > that's true, then the things I would expect this WARN to catch are (a)
> > bugs where somehow the thread gets scheduled without calling
> > vcpu_load() or (b) bizarre situations (probably all bugs?) where some
> > vcpu thread has a hold of some _other_ kvm_vcpu* and is trying to do
> > something with it.
> Oh I completely missed the scheduling path for KVM.
> But since vcpu_put and vcpu_load are exported symbols, I wonder what'll
> happen when there are calls to these functions from places other
> than kvm_sched_in() and kvm_sched_out() ? Just thinking out loud.

Invoking this helper without the target vCPU loaded on the current task would be
considered a bug.  kvm.ko exports a rather disgusting number of symbols purely for
use by vendor modules, e.g. kvm-intel.ko and kvm-amd.ko on x86.  The exports are
not at all intended to be used by non-KVM code, i.e. any such misuse would also be
considered a bug.
