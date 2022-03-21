Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 857924E2EF9
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 18:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351789AbiCURYW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 13:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349471AbiCURYU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 13:24:20 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 262B99F39B
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 10:22:54 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id s25so20848618lji.5
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 10:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZZT8+TFC23/AaV+DRFsEWiZYsV60D0EaygpL7J9asyY=;
        b=l3xYWkl9rDrcVXwTo8URDFqpjnwf5HDy7Rm/hS6hrfmTQimfNuobTHqbU5ws2hXyYy
         vJLDTsN6bBVSys185PpX+YXy3kL9Tn2QDvQ0fuladCkxw5Pqg92by1vxDJxtARzJmIDQ
         Sq5cdXBFx6st3cbAF4/8MscBYdVazgz/vZUaJ7iNGzWQmlx/REEgIS6FZwmCj0aGHpOT
         YT/wAuYvydl5iskA27eSCQ8kS2eCxpTs16k3/XEKg2u/YwnLhmoq0e3oHxM8qG+JP0rR
         pHTm/S1dSM5BG4cTDagrDX7N2QOcYSgujZih1IwuIU+9gPX5jswVe0siECbqSKA6aoVa
         WDlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZZT8+TFC23/AaV+DRFsEWiZYsV60D0EaygpL7J9asyY=;
        b=4i2C/z/k4HJxB4wUB83Z7UKqZ2UeuN0LEVw3G/j/MhB4XWa/N4ymvvHpz8X8KhJ8pb
         ySK33mEHEbOolR8+C5WPlUuUcbD3O+RBNCgSWrIWOZydnWKmX8qEtfInQopCljjBCObX
         PdOfPf7zBECxTRtQlVieZVe5+8EJUm5o6BnYXp6b4GZWH15EPq1FE3Agog9HYXjXRTRE
         TEBASnkN+boOAfzMPoZSuuc9Rbi1goM7G5B+J1Ebo2vehrHE4S+aRreT5ZN3BgmsqYsg
         UiHzx2HTcI6Ioo/RnuZPhZ8p2hwQwFGreuTH7H2QrbMPKX3/lhzJTzzszITIC9tmHT2e
         swnQ==
X-Gm-Message-State: AOAM531kNd0XLb/hTYwYeMmtYsqy5zO75YJRYpvVIdKSlUzcXkigxRJQ
        PrK7zwgEYkHQWCGC3zaqwLZE7Pb+h5YIQOJ7ZNApDA==
X-Google-Smtp-Source: ABdhPJwd+VJrkswex1WkGk+m0EmD/YTPqK14jcWtgSCwua815oFulCrxMjof6yeDvJBcB/qOMdMbjGCOvsCPx0v39mc=
X-Received: by 2002:a2e:9e81:0:b0:248:7c35:385a with SMTP id
 f1-20020a2e9e81000000b002487c35385amr16519097ljk.527.1647883369900; Mon, 21
 Mar 2022 10:22:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220321150214.1895231-1-pgonda@google.com> <f8500809-610e-ce44-9906-785b7ddc0911@redhat.com>
 <CAMkAt6pNE9MC7U_qQDwTrFG5e8qaiWZ6f0HzR+mk4dCNC2Ue8A@mail.gmail.com> <d94532b7-67bc-295b-fe40-73c519b6f916@redhat.com>
In-Reply-To: <d94532b7-67bc-295b-fe40-73c519b6f916@redhat.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Mon, 21 Mar 2022 11:22:38 -0600
Message-ID: <CAMkAt6qkZ6zpdmWL6Wmujr3SJVaxHE3y2Qa+kuZUAO7OJu8+HQ@mail.gmail.com>
Subject: Re: [PATCH] Add KVM_EXIT_SHUTDOWN metadata for SEV-ES
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>, Marc Orr <marcorr@google.com>,
        Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 21, 2022 at 11:08 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 3/21/22 16:42, Peter Gonda wrote:
> > On Mon, Mar 21, 2022 at 9:27 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >>
> >> On 3/21/22 16:02, Peter Gonda wrote:
> >>> SEV-ES guests can request termination using the GHCB's MSR protocol. See
> >>> AMD's GHCB spec section '4.1.13 Termination Request'. Currently when a
> >>> guest does this the userspace VMM sees an KVM_EXIT_UNKNOWN (-EVINAL)
> >>> return code from KVM_RUN. By adding a KVM_EXIT_SHUTDOWN_ENTRY to kvm_run
> >>> struct the userspace VMM can clearly see the guest has requested a SEV-ES
> >>> termination including the termination reason code set and reason code.
> >>>
> >>> Signed-off-by: Peter Gonda <pgonda@google.com>
> >>> Cc: Borislav Petkov <bp@alien8.de>
> >>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> >>> Cc: Brijesh Singh <brijesh.singh@amd.com>
> >>> Cc: Joerg Roedel <jroedel@suse.de>
> >>> Cc: Marc Orr <marcorr@google.com>
> >>> Cc: Sean Christopherson <seanjc@google.com>
> >>> Cc: kvm@vger.kernel.org
> >>> Cc: linux-kernel@vger.kernel.org
> >>
> >> Looks good, but it has to also add a capability.
> >
> > Thanks for the quick review! Just so I understand. I should add
> > KVM_CAP_SEV_TERM or something, then if that has been enabled do the
> > new functionality, else keep the old functionality?
>
> No, much simpler; just something for which KVM_CHECK_EXTENSION returns
> 1, so that userspace knows that there is a "shutdown" member to be
> filled by KVM_EXIT_SHUTDOWN.  e.g. KVM_CAP_EXIT_SHUTDOWN_REASON.

Makes sense, thanks for help. Will do for V2.

>
> Paolo
>
