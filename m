Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D584243E56
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 19:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgHMRbx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 13:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbgHMRbx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Aug 2020 13:31:53 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B5DAC061757
        for <kvm@vger.kernel.org>; Thu, 13 Aug 2020 10:31:53 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id a24so5758041oia.6
        for <kvm@vger.kernel.org>; Thu, 13 Aug 2020 10:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S0mJn9glHvgBKds8mjTmLlgE2xICxjsY+0mNXnuT3Ps=;
        b=puw3EcPEVQASOhNPkfKBnDy0DJDfSfmsG10pcPqII3pGaR2Mq+QDu53CRMvu7GYsZa
         CWnR1VoAkCEBTwsuz4qnYc0f2Dkxl5UEf303i9cMjsPQsj4fL45kjOM+y191JNCli56+
         l4E0N8LVQgGc3YvdpYYBSLRp0DzYMID7u3N5cnV8xfRgqoZY0+V5KnaYqrLxazLsTRRz
         kmIOERZUpI6fXf3ElJiREa3seR1LoULHwYPmo8AgxTWVUxbtv8aOJ6o+yR5lJWdQZc+O
         ms7pRxvjpZOUetuUyUf7+1DEakazTxV5qDW4zFJPMUBKoFMDrTaqB/x7hc5OtbnRlrBw
         5VbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S0mJn9glHvgBKds8mjTmLlgE2xICxjsY+0mNXnuT3Ps=;
        b=cMoTIpHsGqQUuqDXTCt96hmDtsaH2QlLvmrGNL74bcJsnqWZC1xxwfo2nkOXXuGzvb
         TrTEJ18d/9YrssEjKmk/nVWTxEugaDjy8ttXoMLZzYWqWWwCeFE0fWDyHbp5fTL6gam1
         QFyE102R7mk9Ud0dk1PqIBrkkOrdLfPaq+8fNCaHIA3nHYst3jmTcGwP4i/N5psXErfL
         USXtubQoHhEShICDBZ69EgO253uY+as0JsQOswtURq2BRQry3O/VzG8cvzgRYy2xmFIh
         m1FMVgEpD198Tp2B4hMZiaGUu9HBBg7SYZv9rEpB2/wABW/L6ROPmrgZ9ws69B7s9HzD
         ZjsQ==
X-Gm-Message-State: AOAM531Z3rr9BMQiVQGt6UYNTZrmVcUkazqejxMYBB7gauoD+zx2YkJA
        3ZpUPI2xcgjx/e0s5ZNQuDvocyEHUZwha3fis05RIA==
X-Google-Smtp-Source: ABdhPJwdR5FTDq9CbRiChGWtu1ufGfl7Dalv+5O3zt5gsgcAhuL6wrIBY2QfOF+CMmFX5XWI9yNir9yFzeBAldvL6Xo=
X-Received: by 2002:aca:670b:: with SMTP id z11mr4137097oix.6.1597339912244;
 Thu, 13 Aug 2020 10:31:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200807084841.7112-1-chenyi.qiang@intel.com> <20200807084841.7112-3-chenyi.qiang@intel.com>
 <CALMp9eQiyRxJ0jkvVi+fWMZcDQbvyCcuTwH1wrYV-u_E004Bhg@mail.gmail.com> <34b083be-b9d5-fd85-b42d-af0549e3b002@intel.com>
In-Reply-To: <34b083be-b9d5-fd85-b42d-af0549e3b002@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 13 Aug 2020 10:31:40 -0700
Message-ID: <CALMp9eS=dO7=JvvmGp-nt-LBO9evH-bLd2LQMO9wdYJ5V6S0_Q@mail.gmail.com>
Subject: Re: [RFC 2/7] KVM: VMX: Expose IA32_PKRS MSR
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 12, 2020 at 10:42 PM Chenyi Qiang <chenyi.qiang@intel.com> wrote:
>
>
>
> On 8/13/2020 5:21 AM, Jim Mattson wrote:
> > On Fri, Aug 7, 2020 at 1:46 AM Chenyi Qiang <chenyi.qiang@intel.com> wrote:
> >>
> >> Protection Keys for Supervisor Pages (PKS) uses IA32_PKRS MSR (PKRS) at
> >> index 0x6E1 to allow software to manage supervisor protection key
> >> rights. For performance consideration, PKRS intercept will be disabled
> >> so that the guest can access the PKRS without VM exits.
> >> PKS introduces dedicated control fields in VMCS to switch PKRS, which
> >> only does the retore part. In addition, every VM exit saves PKRS into
> >> the guest-state area in VMCS, while VM enter won't save the host value
> >> due to the expectation that the host won't change the MSR often. Update
> >> the host's value in VMCS manually if the MSR has been changed by the
> >> kernel since the last time the VMCS was run.
> >> The function get_current_pkrs() in arch/x86/mm/pkeys.c exports the
> >> per-cpu variable pkrs_cache to avoid frequent rdmsr of PKRS.
> >>
> >> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> >> ---
> >
> >> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> >> index 11e4df560018..df2c2e733549 100644
> >> --- a/arch/x86/kvm/vmx/nested.c
> >> +++ b/arch/x86/kvm/vmx/nested.c
> >> @@ -289,6 +289,7 @@ static void vmx_sync_vmcs_host_state(struct vcpu_vmx *vmx,
> >>          dest->ds_sel = src->ds_sel;
> >>          dest->es_sel = src->es_sel;
> >>   #endif
> >> +       dest->pkrs = src->pkrs;
> >
> > Why isn't this (and other PKRS code) inside the #ifdef CONFIG_X86_64?
> > PKRS isn't usable outside of long mode, is it?
> >
>
> Yes, I'm also thinking about whether to put all pks code into
> CONFIG_X86_64. The kernel implementation also wrap its pks code inside
> CONFIG_ARCH_HAS_SUPERVISOR_PKEYS which has dependency with CONFIG_X86_64.
> However, maybe this can help when host kernel disable PKS but the guest
> enable it. What do you think about this?

I see no problem in exposing PKRS to the guest even if the host
doesn't have CONFIG_ARCH_HAS_SUPERVISOR_PKEYS.
