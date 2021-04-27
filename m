Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7788F36CA30
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 19:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235762AbhD0RRb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 13:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235512AbhD0RRb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 13:17:31 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFEB7C061574
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 10:16:47 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id i81so60397009oif.6
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 10:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cjLN3S0GeULsbPxdT9hsZGLgbdFkdVSdByKi9ZEU5XQ=;
        b=Ul2bV2VZHH6Ai6ZqOr5blonHZPiadyI7u70WLXhRACTBIvpTGcM168KyQh5qF2NIcD
         IYAwn5soV6P76rDDSneuhX4JJ+iQsYnTG8teS3Poz0M/t/RQ81FeLeNN9KkIdCfvTVdc
         YRP4GDGrL8fs+iJPShYe2eozRY/j5ut6XufjaNv0AC2x6H0Z6YTqzfaktMGIbK9oLOpD
         PQxCZwDAYXivbLP21O8job3Q1nP340jAeSDKvqXBAivyDqLLxrHQTDLbEBtJwHLvsuKH
         VSgWO5A3BdYNLJiYj7qOQs7dKbsacHsdUPP3gqQUSxa/3CuXa2jJpqfupu1pIQGD9hmj
         5+QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cjLN3S0GeULsbPxdT9hsZGLgbdFkdVSdByKi9ZEU5XQ=;
        b=nSs7ZLtnRyiY2Ard4ARPQOTBnfGwu98PhC7yrKWlIlR8fmFtkQfhNZlxO7irkHlJo8
         Hw/i6yDLYk5XcARvcTjad0wBDJcyq8MR4jUs0Akf0Mq3hgSuKAarMWQUxILIL7Mh9pLf
         czc26tKv9mDjrqs0Ad8a6fNTdYuRubq06LPPF6v485UHaHV+MVqPp+3HOfq716xCYV7e
         zvSP1uxT0gixUQWeZxUnUhaPPhLJMGMib31rXRbEr2gZLRVBPjWeJnaw81reKi8fG/N6
         hT275gN7Wi7PlGUNcyGv2VdaV+yat2ZfRiQvj6H2LedhqR2tAuyybDi+f5Czxi0JFWwY
         Cmqg==
X-Gm-Message-State: AOAM5314/16UpMB16AdbKi5F9YIrAGqZjMF1bS/UpkIXG6gJdWl26FLr
        gVJPLOZ3Tpeo1GvZQVOWSGC16+iIJaK53KyD5rcFhg==
X-Google-Smtp-Source: ABdhPJyC2GcXZmSkD+cIPWyDka0DgbCKhoOdedWjvH76R54ZiDq+3yLOSjizHfeHHHsqdOoV8+E56OQGxMCHYRaPSQg=
X-Received: by 2002:aca:3cd6:: with SMTP id j205mr16864460oia.28.1619543806617;
 Tue, 27 Apr 2021 10:16:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210427170332.706287-1-aaronlewis@google.com>
In-Reply-To: <20210427170332.706287-1-aaronlewis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 27 Apr 2021 10:16:33 -0700
Message-ID: <CALMp9eRW2V7y8Z76dmkO3hoh3Ly9QBLOtT-Madxhi5T8z+eVmA@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] kvm: x86: Allow userspace to handle emulation errors
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     David Edmondson <david.edmondson@oracle.com>,
        Sean Christopherson <seanjc@google.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 27, 2021 at 10:03 AM Aaron Lewis <aaronlewis@google.com> wrote:
>
> Add a fallback mechanism to the in-kernel instruction emulator that
> allows userspace the opportunity to process an instruction the emulator
> was unable to.  When the in-kernel instruction emulator fails to process
> an instruction it will either inject a #UD into the guest or exit to
> userspace with exit reason KVM_INTERNAL_ERROR.  This is because it does
> not know how to proceed in an appropriate manner.  This feature lets
> userspace get involved to see if it can figure out a better path
> forward.
>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
...
> +static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
> +{
> +       struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
> +       u64 insn_size = ctxt->fetch.end - ctxt->fetch.data;
> +       struct kvm_run *run = vcpu->run;
> +       const u64 max_insn_size = 15;

Nit: insn_size and max_insn_size could both be just unsigned int.

> +       run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +       run->emulation_failure.suberror = KVM_INTERNAL_ERROR_EMULATION;
> +       run->emulation_failure.ndata = 0;
> +       run->emulation_failure.flags = 0;
> +
> +       if (insn_size) {
> +               run->emulation_failure.ndata = 3;
> +               run->emulation_failure.flags |=
> +                       KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES;
> +               run->emulation_failure.insn_size = insn_size;
> +               memset(run->emulation_failure.insn_bytes, 0x90, max_insn_size);
> +               memcpy(run->emulation_failure.insn_bytes,
> +                      ctxt->fetch.data, insn_size);

It's tempting to check that insn_size doesn't exceed 15, but I'm sure
we all trust the emulator.

> +       }
> +}
> +
>  static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
>  {
> +       struct kvm *kvm = vcpu->kvm;
> +
>         ++vcpu->stat.insn_emulation_fail;
>         trace_kvm_emulate_insn_failed(vcpu);
>
> @@ -7129,10 +7159,9 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
>                 return 1;
>         }
>
> -       if (emulation_type & EMULTYPE_SKIP) {
> -               vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> -               vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
> -               vcpu->run->internal.ndata = 0;
> +       if (kvm->arch.exit_on_emulation_error ||
> +           (emulation_type & EMULTYPE_SKIP)) {
> +               prepare_emulation_failure_exit(vcpu);
>                 return 0;
>         }
>
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index f6afee209620..87009222c20c 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -279,6 +279,9 @@ struct kvm_xen_exit {
>  /* Encounter unexpected vm-exit reason */
>  #define KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON      4
>
> +/* Flags that describe what fields in emulation_failure hold valid data. */
> +#define KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES (1ULL << 0)
> +
>  /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
>  struct kvm_run {
>         /* in */
> @@ -382,6 +385,25 @@ struct kvm_run {
>                         __u32 ndata;
>                         __u64 data[16];
>                 } internal;
> +               /*
> +                * KVM_INTERNAL_ERROR_EMULATION
> +                *
> +                * "struct emulation_failure" is an overlay of "struct internal"
> +                * that is used for the KVM_INTERNAL_ERROR_EMULATION sub-type of
> +                * KVM_EXIT_INTERNAL_ERROR.  Note, unlike other internal error
> +                * sub-types, this struct is ABI!  It also needs to be backwards
> +                * compabile with "struct internal".  Take special care that
> +                * "ndata" is correct, that new fields are enumerated in "flags",
> +                * and that each flag enumerates fields that are 64-bit aligned
> +                * and sized (so that ndata+internal.data[] is valid/accurate).
> +                */
> +               struct {
> +                       __u32 suberror;
> +                       __u32 ndata;
> +                       __u64 flags;
> +                       __u8  insn_size;
> +                       __u8  insn_bytes[15];
> +               } emulation_failure;
>                 /* KVM_EXIT_OSI */
>                 struct {
>                         __u64 gprs[32];
> @@ -1078,6 +1100,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_DIRTY_LOG_RING 192
>  #define KVM_CAP_X86_BUS_LOCK_EXIT 193
>  #define KVM_CAP_PPC_DAWR1 194
> +#define KVM_CAP_EXIT_ON_EMULATION_FAILURE 195
>
>  #ifdef KVM_CAP_IRQ_ROUTING
>
> diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
> index f6afee209620..87009222c20c 100644
> --- a/tools/include/uapi/linux/kvm.h
> +++ b/tools/include/uapi/linux/kvm.h
> @@ -279,6 +279,9 @@ struct kvm_xen_exit {
>  /* Encounter unexpected vm-exit reason */
>  #define KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON      4
>
> +/* Flags that describe what fields in emulation_failure hold valid data. */
> +#define KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES (1ULL << 0)
> +
>  /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
>  struct kvm_run {
>         /* in */
> @@ -382,6 +385,25 @@ struct kvm_run {
>                         __u32 ndata;
>                         __u64 data[16];
>                 } internal;
> +               /*
> +                * KVM_INTERNAL_ERROR_EMULATION
> +                *
> +                * "struct emulation_failure" is an overlay of "struct internal"
> +                * that is used for the KVM_INTERNAL_ERROR_EMULATION sub-type of
> +                * KVM_EXIT_INTERNAL_ERROR.  Note, unlike other internal error
> +                * sub-types, this struct is ABI!  It also needs to be backwards
> +                * compabile with "struct internal".  Take special care that
> +                * "ndata" is correct, that new fields are enumerated in "flags",
> +                * and that each flag enumerates fields that are 64-bit aligned
> +                * and sized (so that ndata+internal.data[] is valid/accurate).
> +                */
> +               struct {
> +                       __u32 suberror;
> +                       __u32 ndata;
> +                       __u64 flags;
> +                       __u8  insn_size;
> +                       __u8  insn_bytes[15];
> +               } emulation_failure;
>                 /* KVM_EXIT_OSI */
>                 struct {
>                         __u64 gprs[32];
> @@ -1078,6 +1100,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_DIRTY_LOG_RING 192
>  #define KVM_CAP_X86_BUS_LOCK_EXIT 193
>  #define KVM_CAP_PPC_DAWR1 194
> +#define KVM_CAP_EXIT_ON_EMULATION_FAILURE 195
>
>  #ifdef KVM_CAP_IRQ_ROUTING
>
> --
> 2.31.1.498.g6c1eba8ee3d-goog
>
