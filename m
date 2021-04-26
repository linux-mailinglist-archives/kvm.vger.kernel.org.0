Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA0F36B677
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 18:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234224AbhDZQGN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 12:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234124AbhDZQGM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 12:06:12 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C000EC061574
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 09:05:30 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id m12so19622558pgr.9
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 09:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qreSVuxOJTtp8pKovfio55oMnuf6cgyA30eK8p4l9HQ=;
        b=GukUXgL4RUD8LUUZsycG8zz+tAimq8EFwX1EbwBljqNgNt4vsxNOdydQYogODsokfC
         O8moxJGNOvPDcUxFAfLcVXeJMXx0joHtuB4ksT3+cHleDBv1LRIZNYILLCKluqPVtayx
         U6bcdIM5m+whSwffThP1Bw98FwksghQsoqQHkrw6EEDYn6GRD/bzOW2Od5gQDKJeik9C
         cKo1dBEaeSkYUGyaK08/weaWwSPFINA7TbVDVmCuNoG0nAhh/zrC5RDeuoW/88q+kFYA
         vBhg7aTJQGJVI7MVE+KjBjnICvgQBw5N/R37iLcGkBU0K/uuybRAPWLQeUMBjJg3XWWj
         +Qug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qreSVuxOJTtp8pKovfio55oMnuf6cgyA30eK8p4l9HQ=;
        b=cDzpus+40j+HAgDoHEOKklC+t3OsYSnOxFVpnPovZjovcK4Ibc8Jpg1K8e7/fRSMP+
         5j+RqK8v4LvBTob5PrRHa4vcQNXETzePsgG5SCmSfIdN6Xah7Xh76wsApqnNMkwm00aX
         4plvBvBKz7pN6ya7Fz+OM8jKMVqGxm22BCJC4eTiuzDQspdbKVYT1coH4TvjiYzVti0b
         D1lwLHrgNzGe+LbzGjNaT4go6i3xvXpXwwUrVHpcChX2QmWN1U8w2nsQ8/hOU0EVLBG9
         3F9qmWsQ55/zqC6HfKFQiOr8dEg+wukWeiS259Vx8fbBrBceBJ0sgWKp2yxLoXkCyLT7
         kI9g==
X-Gm-Message-State: AOAM532M5Qj8mRA+xHqkpH7Z42zU7UAdSPIa+sfNrjIqEh+YD1zTsE+N
        Sch+AOfrAN0ijxULHr1McUNH8g==
X-Google-Smtp-Source: ABdhPJyfo9aKqpyV2OaifBfA5UJGLdFqrK3AEDrVXxT1wrKR74wDxkaKXq5iHEaNdf5Wf2wijxLxHg==
X-Received: by 2002:a65:60c1:: with SMTP id r1mr17732530pgv.446.1619453130154;
        Mon, 26 Apr 2021 09:05:30 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id 22sm15701030pjl.31.2021.04.26.09.05.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 09:05:29 -0700 (PDT)
Date:   Mon, 26 Apr 2021 16:05:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Arnabjyoti Kalita <akalita@cs.stonybrook.edu>
Cc:     kvm@vger.kernel.org
Subject: Re: Intercepting RDTSC instruction by causing a VMEXIT
Message-ID: <YIbkxXwHPTPhN20C@google.com>
References: <CAJGDS+GKd_YR9QmTR-6KsiE16=4s8fuqh8pmQTYnxHXS=mYp9g@mail.gmail.com>
 <YH2z3uuQYwSyGJfL@google.com>
 <CAJGDS+FGnDFssYXLfLrog+AJu62rrs6DzAQuESJSDaNNdsYdcw@mail.gmail.com>
 <CAJGDS+GT1mKHz6K=qHQf54S_97ym=nRP12MfO6OSEOpLYGht=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJGDS+GT1mKHz6K=qHQf54S_97ym=nRP12MfO6OSEOpLYGht=A@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 26, 2021, Arnabjyoti Kalita wrote:
> Hello Sean,
> 
> Thank you very much for your answer again. I could actually see that the
> RDTSC handler gets called successfully. I added a "printk" statement to the
> handler and I can see the messages being printed out to the kernel syslog.
> 
> However, I am not sure if a VMEXIT is happening in userspace. I use QEMU
> and I do not see any notification from QEMU that tells me that a VMEXIT
> happened due to RDTSC being executed. Is there a mechanism to confirm this?

Without further modification, KVM will _not_ exit to userspace in this case.

> My actual requirement to record tsc values read out as a result of RDTSC
> execution still stands.

Your requirement didn't clarify that userspace needed to record the values ;-)

Forcing an exit to userspace is very doable, but will tank guest performance and
possibly interfere with whatever you're trying to do.  I would try adding a
tracepoint and using that to capture the TSC values.  Adding guest RIP, etc...
as needed is trivial.

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index a61c015870e3..e962e813ba04 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -821,6 +821,23 @@ TRACE_EVENT(
                  __entry->gpa_match ? "GPA" : "GVA")
 );

+TRACE_EVENT(kvm_emulate_rdtsc,
+       TP_PROTO(unsigned int vcpu_id, __u64 tsc),
+       TP_ARGS(vcpu_id, tsc),
+
+       TP_STRUCT__entry(
+               __field( unsigned int,  vcpu_id         )
+               __field(        __u64,  tsc             )
+       ),
+
+       TP_fast_assign(
+               __entry->vcpu_id                = vcpu_id;
+               __entry->tsc                    = tsc;
+       ),
+
+       TP_printk("vcpu=%u tsc=%llu", __entry->vcpu_id, __entry->tsc)
+);
+
 TRACE_EVENT(kvm_write_tsc_offset,
        TP_PROTO(unsigned int vcpu_id, __u64 previous_tsc_offset,
                 __u64 next_tsc_offset),
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 61bf0b86770b..1fbeef520349 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5254,6 +5254,8 @@ static int handle_rdtsc(struct kvm_vcpu *vcpu)
 {
        u64 tsc = kvm_read_l1_tsc(vcpu, rdtsc());

+       trace_kvm_emulate_rdtsc(vcpu->vcpu_id, tsc);
+
        kvm_rax_write(vcpu, tsc & -1u);
        kvm_rdx_write(vcpu, (tsc >> 32) & -1u);
        return kvm_skip_emulated_instruction(vcpu);
