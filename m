Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66D29EF0B9
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 23:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729730AbfKDWsQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 17:48:16 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:36947 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729122AbfKDWsQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 17:48:16 -0500
Received: by mail-io1-f65.google.com with SMTP id 1so20424768iou.4
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2019 14:48:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y/D0JhOEJj+Mv4jTw8R4i3fKqP5gPG7RohvOhgAywAE=;
        b=dGUjqPeow/WnMM06Jck9RftJqRYQS63K4leVr9y6/rmj1p7kgNlzk4hTI+6/azkYdQ
         hO+gcsZCpuYimRgG7r4FmDA+B1mhzdR0U6Z6s+ZTsX2STxeGWc1ny8ZShsi9BzGosnvj
         4GHVOy92GxDH1+OrI8lyTUGxo0Wmcbu6/fwEvNYzZqKFucek0hj01WF4WI0dml7LFjBV
         Gt/PFRFBbuZ+pAAlqrmMvX9STyjdef9luxeL227+Iu2BnPaw9CeaIX8hGLGAQkNMSFRU
         RBT7vNbw7sG3oExhvCTyP8JLwOlCdCqhNcaVvUg6oSKNHEd9XyZWniv8YWmzotse5OVY
         1n8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y/D0JhOEJj+Mv4jTw8R4i3fKqP5gPG7RohvOhgAywAE=;
        b=kSXvjd8cm62WSr7aSSOPzCCSx3WGDOzkDoEIND3gfeR0Zm81Qn+ROtfHTjXScgbFhr
         7OvGv3hf60RraMqe78Lc8zD80gK+1r9eCVLR6zMH+IyyKJm0WFK/RCeYeEHhhy+k5Chv
         ZLfX/dELPolOzW0EMOU6sCR9UhSBVEvE/4ZuuKEMW3HPaejmeF56vBot5NpqJWfB7q/j
         KXP75npYjLoofQHdNVSPmfLDiSVYslHOZvHed/XYZ2p6haq5e0SIShSophcaH+eUjALy
         2tcMCOmd7R3nlHRyfd8iXT40MFPnzkoRBwcr2entf3CwBMG7gwp8as1WwQiSqez5uJAX
         YyTA==
X-Gm-Message-State: APjAAAVdHYU0th/rLiAKBtWL6KS9UEJJlerex9MsyI5j9Ze6QNrnY4G6
        tr36bXir/Z6FkOmwwD4ZwJg4CWIEojGrylFxsemHGw==
X-Google-Smtp-Source: APXvYqw2V0nQlQNPL+Zyzz8sSZcyrbeR6qkX6cCbW9u9hm+xJMWgDUseRjO1TH7xXPhIzBrbyx4oLNhRzqwEld8Cau8=
X-Received: by 2002:a5d:888d:: with SMTP id d13mr4099583ioo.119.1572907695159;
 Mon, 04 Nov 2019 14:48:15 -0800 (PST)
MIME-Version: 1.0
References: <20191029210555.138393-1-aaronlewis@google.com> <20191029210555.138393-5-aaronlewis@google.com>
In-Reply-To: <20191029210555.138393-5-aaronlewis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 4 Nov 2019 14:48:04 -0800
Message-ID: <CALMp9eTqdPHRHRLg6FNMFJG4TqLCsHA3AgzS2sACOXg=NcXwcw@mail.gmail.com>
Subject: Re: [PATCH 4/4] KVM: nVMX: Add support for capturing highest
 observable L2 TSC
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 29, 2019 at 2:06 PM Aaron Lewis <aaronlewis@google.com> wrote:
>
> The L1 hypervisor may include the IA32_TIME_STAMP_COUNTER MSR in the
> vmcs12 MSR VM-exit MSR-store area as a way of determining the highest
> TSC value that might have been observed by L2 prior to VM-exit. The
> current implementation does not capture a very tight bound on this
> value.  To tighten the bound, add the IA32_TIME_STAMP_COUNTER MSR to the
> vmcs02 VM-exit MSR-store area whenever it appears in the vmcs12 VM-exit
> MSR-store area.  When L0 processes the vmcs12 VM-exit MSR-store area
> during the emulation of an L2->L1 VM-exit, special-case the
> IA32_TIME_STAMP_COUNTER MSR, using the value stored in the vmcs02
> VM-exit MSR-store area to derive the value to be stored in the vmcs12
> VM-exit MSR-store area.
>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> Change-Id: I876e79d98e8f2e5439deafb070be1daa2e1a8e4a
Drop the Change-Id.

> ---
>  arch/x86/kvm/vmx/nested.c | 91 ++++++++++++++++++++++++++++++++++++---
>  arch/x86/kvm/vmx/vmx.h    |  4 ++
>  2 files changed, 89 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 7b058d7b9fcc..19863f2a6588 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -929,6 +929,36 @@ static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
>         return i + 1;
>  }
>
> +static bool nested_vmx_get_msr_value(struct kvm_vcpu *vcpu, u32 msr_index,
> +                                    u64 *data)
Maybe change this to nested_vmx_get_vmexit_msr_value, to clarify that
this is for getting the value of an MSR at emulated VM-exit from L2 ot
L1?

Reviewed-by: Jim Mattson <jmattson@google.com>
