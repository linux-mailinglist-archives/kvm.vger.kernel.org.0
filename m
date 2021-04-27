Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0501C36BD30
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 04:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbhD0CUA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 22:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbhD0CT7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 22:19:59 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1130C061574
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 19:19:16 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id k25so58413068oic.4
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 19:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=stonybrook.edu; s=sbu-gmail;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hrHKmIfBIcMjhw0JQdGpkfRgnab+2X4SAi9olXFMVAc=;
        b=rtbGsdKaHzEtDJqdQqtFPJhTDvqH8p9JEHQQkQqnMOzQvDg2amMEKvBQLEHbuOIo18
         hqhDlnenECQpctFqbGog74r3bam8hURUgG8ZKw8y4WXomn1vKGgho79AIzEPuBWe1UwI
         d120luiSbObZSPhjbWr7uYKfjDQBWmcm1h4rM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hrHKmIfBIcMjhw0JQdGpkfRgnab+2X4SAi9olXFMVAc=;
        b=sqRRJLehBVBtLDaJ/kNiMRmkPAUIEDL97FiZGAiKiccW5lUtrzFszp28j1VG6KVqZx
         ip//6fCg1Ti8GLKmML+ejDh1+LT4SEdtRglIOp8FlB7dKs/dA5FmHOH7rutHCfKFfCOP
         nq2IORslgRUurzCRfY0XgBEVUvSl8wQiVneQVFwY7RlbN9wGQNB4tQIEcmNDHBOpq95v
         e7MxMqHtGyD/z7bf0gFUUnaT41/ojVl8LUuqRf6W2Qh+1Oas67wDk7RxZBGdNLsEm+Du
         V+FFV8su+a/KIIcMBxhZqSJ+h/usvApERvwqdCbdQxtdPofsbf2p46pxIiRJbrVVs/1q
         0zdw==
X-Gm-Message-State: AOAM530tEHfuXex6lqK9SsU3mp9sYMyQWrF0H0tkGi2N3TMZaiheF7Q7
        Axq51ZUeaeySNbWJ7R1ONbSeJekqiTM4rghVIwzXFA==
X-Google-Smtp-Source: ABdhPJw7flIluNbImVhsOCUe4YIKldkeWijMrcSEHUm2b3DgG+lXdVJq2remNnjMSsqnSrYvtgimTLrJsaGUVZXKmfY=
X-Received: by 2002:aca:ba09:: with SMTP id k9mr14340838oif.178.1619489956142;
 Mon, 26 Apr 2021 19:19:16 -0700 (PDT)
MIME-Version: 1.0
References: <CAJGDS+GKd_YR9QmTR-6KsiE16=4s8fuqh8pmQTYnxHXS=mYp9g@mail.gmail.com>
 <YH2z3uuQYwSyGJfL@google.com> <CAJGDS+FGnDFssYXLfLrog+AJu62rrs6DzAQuESJSDaNNdsYdcw@mail.gmail.com>
 <CAJGDS+GT1mKHz6K=qHQf54S_97ym=nRP12MfO6OSEOpLYGht=A@mail.gmail.com> <YIbkxXwHPTPhN20C@google.com>
In-Reply-To: <YIbkxXwHPTPhN20C@google.com>
From:   Arnabjyoti Kalita <akalita@cs.stonybrook.edu>
Date:   Tue, 27 Apr 2021 07:49:04 +0530
Message-ID: <CAJGDS+EjtHmV7fdQmtHfiRG3uywd5=XbFb_VWr-GhCpmuN+=zA@mail.gmail.com>
Subject: Re: Intercepting RDTSC instruction by causing a VMEXIT
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Sean,

Thank you very much again. I didn't know about the tracepointing
methodology. This is very helpful, indeed.

In addition to my requirement of recording tsc values, I am trying to
track when the VMEXITs happen in userspace(QEMU). This allows me to
correlate recorded TSC values with the VMEXIT sequence. So, causing a
VMEXIT in userspace is absolutely essential to me and I would love to
have some pointers on how to do it.

I run a server within the guest and I'm okay with performance dropping
down to within a factor of 2 compared to running the server on native
hardware. I run this experiment for about 20-30 seconds.

Best Regards,
Arnabjyoti Kalita


On Mon, Apr 26, 2021 at 9:35 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Apr 26, 2021, Arnabjyoti Kalita wrote:
> > Hello Sean,
> >
> > Thank you very much for your answer again. I could actually see that the
> > RDTSC handler gets called successfully. I added a "printk" statement to the
> > handler and I can see the messages being printed out to the kernel syslog.
> >
> > However, I am not sure if a VMEXIT is happening in userspace. I use QEMU
> > and I do not see any notification from QEMU that tells me that a VMEXIT
> > happened due to RDTSC being executed. Is there a mechanism to confirm this?
>
> Without further modification, KVM will _not_ exit to userspace in this case.
>
> > My actual requirement to record tsc values read out as a result of RDTSC
> > execution still stands.
>
> Your requirement didn't clarify that userspace needed to record the values ;-)
>
> Forcing an exit to userspace is very doable, but will tank guest performance and
> possibly interfere with whatever you're trying to do.  I would try adding a
> tracepoint and using that to capture the TSC values.  Adding guest RIP, etc...
> as needed is trivial.
>
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index a61c015870e3..e962e813ba04 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -821,6 +821,23 @@ TRACE_EVENT(
>                   __entry->gpa_match ? "GPA" : "GVA")
>  );
>
> +TRACE_EVENT(kvm_emulate_rdtsc,
> +       TP_PROTO(unsigned int vcpu_id, __u64 tsc),
> +       TP_ARGS(vcpu_id, tsc),
> +
> +       TP_STRUCT__entry(
> +               __field( unsigned int,  vcpu_id         )
> +               __field(        __u64,  tsc             )
> +       ),
> +
> +       TP_fast_assign(
> +               __entry->vcpu_id                = vcpu_id;
> +               __entry->tsc                    = tsc;
> +       ),
> +
> +       TP_printk("vcpu=%u tsc=%llu", __entry->vcpu_id, __entry->tsc)
> +);
> +
>  TRACE_EVENT(kvm_write_tsc_offset,
>         TP_PROTO(unsigned int vcpu_id, __u64 previous_tsc_offset,
>                  __u64 next_tsc_offset),
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 61bf0b86770b..1fbeef520349 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5254,6 +5254,8 @@ static int handle_rdtsc(struct kvm_vcpu *vcpu)
>  {
>         u64 tsc = kvm_read_l1_tsc(vcpu, rdtsc());
>
> +       trace_kvm_emulate_rdtsc(vcpu->vcpu_id, tsc);
> +
>         kvm_rax_write(vcpu, tsc & -1u);
>         kvm_rdx_write(vcpu, (tsc >> 32) & -1u);
>         return kvm_skip_emulated_instruction(vcpu);
