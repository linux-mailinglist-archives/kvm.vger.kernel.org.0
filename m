Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A908C55E778
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 18:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346257AbiF1P2Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 11:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347447AbiF1P2P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 11:28:15 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F585221
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 08:28:14 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id h65so17620096oia.11
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 08:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VcRyPc8yqfBxbqxUzat8njTxsc7Bb/ts4TuWMruxwXc=;
        b=qk/4IDec+8fxrqULQrpZO7A+IWJXUJpEiB5Ohkg+/CQhlzu0O0WgEpbiGmUM5FmEq/
         RpC3JfEieF+a7vYutAGb4X2QB6YnZddV3GSi0w2AcY4/1nm54BZ5Bjy2BiXeNYvjscQv
         WnTICfihQqVLUe+okt4h6XX9qsyKCqdYPAeA7oboAum1CHfo/15nmR7R6EZIFzVNxlPc
         0sJcbeIUzVlK3l1I6tIeQ8ulpcZCnjjh6O3PFvLiDNXPaQgkx7Aj1qm8mzAXSj7JtlmZ
         NbdREPs4SYGKMzuG4LpLjtxUyQqlv8GYjlVlJo4OyG3RBk+MaqMSZJZfwEAip8PUan+x
         koDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VcRyPc8yqfBxbqxUzat8njTxsc7Bb/ts4TuWMruxwXc=;
        b=cB/soWW83OOTaZplR+Vj68K3xe4zV039MbWZs2RqqJpYyK7+PMxtUX5TgWOWhaRAu/
         VzoT9aso0lQdoX04nHzzrIThMBDDiKYze/d5xcLOKNMxC3oeG6ydkKM3HHmacZcxcAUe
         bOmAj5x/a37WYAPcLjkjY/c1koJ52icj7X1KfXVMdNvu7VVYXWOPARIZ5Kyqq+0gmRBs
         na6tfWJ/dUU4dymYG8NNBau7jdqikWAc6d1yvSEquetSThr8AkMASnWRxrbxXE5g1PSs
         fs34ZT5AgqPmrVlwffKmi6sTvJLVkk8YESQ2kIQehWKglj9W1v0hTLQD3uxJKVxR/aME
         Hqig==
X-Gm-Message-State: AJIora8rzANZgLwvJvhHmPZSg5ng2HwY9Ubr6qPfS7aSYyAN/djrYEFf
        zJCeACLx9u0ZBRYW4BZY9jT0/enQAl8FTzX5iQ5wBA==
X-Google-Smtp-Source: AGRyM1tXngT9JL9wLeQfuXpG9o8+IuZ1kJ+YSWsVi8szy046wDER0SHngLlWaqB2LZAeuTSoZmOQDF7S2pRCt0uG0KE=
X-Received: by 2002:a05:6808:2124:b0:335:7483:f62d with SMTP id
 r36-20020a056808212400b003357483f62dmr128877oiw.112.1656430093380; Tue, 28
 Jun 2022 08:28:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220627160440.31857-1-vkuznets@redhat.com> <CALMp9eQL2a+mStk-cLwVX6NVqwAso2UYxAO7UD=Xi2TSGwUM2A@mail.gmail.com>
 <87y1xgubot.fsf@redhat.com>
In-Reply-To: <87y1xgubot.fsf@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 28 Jun 2022 08:28:02 -0700
Message-ID: <CALMp9eSBLcvuNDquvSfUnaF3S3f4ZkzqDRSsz-v93ZeX=xnssg@mail.gmail.com>
Subject: Re: [PATCH 00/14] KVM: nVMX: Use vmcs_config for setting up nested
 VMX MSRs
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Tue, Jun 28, 2022 at 7:04 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Jim Mattson <jmattson@google.com> writes:
>
> > On Mon, Jun 27, 2022 at 9:04 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> >>
> >> Changes since RFC:
> >> - "KVM: VMX: Extend VMX controls macro shenanigans" PATCH added and the
> >>   infrastructure is later used in other patches [Sean] PATCHes 1-3 added
> >>   to support the change.
> >> - "KVM: VMX: Clear controls obsoleted by EPT at runtime, not setup" PATCH
> >>   added [Sean].
> >> - Commit messages added.
> >>
> >> vmcs_config is a sanitized version of host VMX MSRs where some controls are
> >> filtered out (e.g. when Enlightened VMCS is enabled, some know bugs are
> >> discovered, some inconsistencies in controls are detected,...) but
> >> nested_vmx_setup_ctls_msrs() uses raw host MSRs instead. This may end up
> >> in exposing undesired controls to L1. Switch to using vmcs_config instead.
> >>
> >> Sean Christopherson (1):
> >>   KVM: VMX: Clear controls obsoleted by EPT at runtime, not setup
> >>
> >> Vitaly Kuznetsov (13):
> >>   KVM: VMX: Check VM_ENTRY_IA32E_MODE in setup_vmcs_config()
> >>   KVM: VMX: Check CPU_BASED_{INTR,NMI}_WINDOW_EXITING in
> >>     setup_vmcs_config()
> >>   KVM: VMX: Tweak the special handling of SECONDARY_EXEC_ENCLS_EXITING
> >>     in setup_vmcs_config()
> >>   KVM: VMX: Extend VMX controls macro shenanigans
> >>   KVM: VMX: Move CPU_BASED_CR8_{LOAD,STORE}_EXITING filtering out of
> >>     setup_vmcs_config()
> >>   KVM: VMX: Add missing VMEXIT controls to vmcs_config
> >>   KVM: VMX: Add missing VMENTRY controls to vmcs_config
> >>   KVM: VMX: Add missing CPU based VM execution controls to vmcs_config
> >>   KVM: nVMX: Use sanitized allowed-1 bits for VMX control MSRs
> >>   KVM: VMX: Store required-1 VMX controls in vmcs_config
> >>   KVM: nVMX: Use sanitized required-1 bits for VMX control MSRs
> >>   KVM: VMX: Cache MSR_IA32_VMX_MISC in vmcs_config
> >>   KVM: nVMX: Use cached host MSR_IA32_VMX_MISC value for setting up
> >>     nested MSR
> >>
> >>  arch/x86/kvm/vmx/capabilities.h |  16 +--
> >>  arch/x86/kvm/vmx/nested.c       |  37 +++---
> >>  arch/x86/kvm/vmx/nested.h       |   2 +-
> >>  arch/x86/kvm/vmx/vmx.c          | 198 ++++++++++++++------------------
> >>  arch/x86/kvm/vmx/vmx.h          | 118 +++++++++++++++++++
> >>  5 files changed, 229 insertions(+), 142 deletions(-)
> >>
> >> --
> >> 2.35.3
> >>
> >
> > Just checking that this doesn't introduce any backwards-compatibility
> > issues. That is, all features that were reported as being available in
> > the past should still be available moving forward.
> >
>
> All the controls nested_vmx_setup_ctls_msrs() set are in the newly
> introduced KVM_REQ_VMX_*/KVM_OPT_VMX_* sets so we should be good here
> (unless I screwed up, of course).
>
> There's going to be some changes though. E.g this series was started by
> Anirudh's report when KVM was exposing SECONDARY_EXEC_TSC_SCALING while
> running on KVM and using eVMCS which doesn't support the control. This
> is a bug and I don't think we need and 'bug compatibility' here.

You cannot force VM termination on a kernel upgrade. On live migration
from an older kernel, the new kernel must be willing to accept the
suspended state of a VM that was running under the older kernel. In
particular, the new KVM_SET_MSRS must accept the values of the VMX
capability MSRS that userspace obtains from the older KVM_GET_MSRS. I
don't know if this is what you are referring to as "bug
compatibility," but if it is, then we absolutely do need it.

> Another change is that VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL/
> VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL will now be filtered out on the
> "broken" CPUs (the list is in setup_vmcs_config()). I *think* this is
> also OK but if not, we can move the filtering to vmx_vmentry_ctrl()/
> vmx_vmexit_ctrl().
>
> --
> Vitaly
>
