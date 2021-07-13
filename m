Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 858A93C7788
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 21:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234733AbhGMT4e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 15:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234726AbhGMT4d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 15:56:33 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E57BC0613DD
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 12:53:42 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id h1so1693plf.6
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 12:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i+ChRVHeQRLsognjL7kCE49bk6Q9AmWd9nE0xVG+7jY=;
        b=qP794rDkvkCuUyhn/Zr5+LRuSKtvGchzbx4iIamKsCXhfLVFB/p4v9vAgGQ7yzW3gC
         3XtFwn9xj74qAYfWJ7zIrtiEs7e25CnVk3Vw9B3nvDqBrENmKpLLr6MMeHf4+grMnZkS
         Ti1rRQIBzd3w8ugjrdBbOJFGNxil7UodR3E0ZeV1nRkYL1kBXW9myIxw/p4Eh/Zu6/jC
         jAZQ5fel973r75H3iA8aPi/BmlSkMc4hc8kJayzG2w92HajpUp5xQho65R7Fzh6IUJSC
         EJ3a/V0AXG8ZoYRz6+tU/V3Sec9qJrA/mqfNSPTBJIlXVelbbDvD+oKjwBVwnDctS7PL
         nRrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i+ChRVHeQRLsognjL7kCE49bk6Q9AmWd9nE0xVG+7jY=;
        b=iEXW39V3o09SQbdTMKDZQT9Ale2Zdwwxg/wCryZEy2z3btd+wsmLMG1XMciKPvM54f
         bT9B3jpqTg010lBylGNA1KEAH2WR7t3NGNCOBBYNn7c9WOrMi4mS6B7lp9HhoJXQhmlR
         yUVE/fdn9LYsiimRIl8XjfgiWfMs9v+B52D1dOwya8zM8GsJ/WNhqJfhV98pSSsAT+Zr
         7z5t91X+pKoMr5AeiVNrYTvnPt7CF88yjSnd1fA3KzLX3KvRCJbKC7N0r2TxNn3XtWMw
         crgVDcNJl6FjMHQvN+ae7J4YBoqdU+S2yQBsQo6dnamkaFOnlDh74EKaYq/gMK7gv7xn
         HefQ==
X-Gm-Message-State: AOAM531xgsWcq+oaLvDHYF+zEWIkKPVs8x1Y/FOhbjTEbrE2ZjNjMqNJ
        kRJmrsaGvYXKaUojNnX6riEJbg==
X-Google-Smtp-Source: ABdhPJxl54thaSjZzKhXcbdf5NDKNSg+1Cfvkpz7gpcaa6j1mm9dMhXaSFhWwmLTbd/A5aWsCgkNzw==
X-Received: by 2002:a17:90b:3b4e:: with SMTP id ot14mr982960pjb.50.1626206021487;
        Tue, 13 Jul 2021 12:53:41 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p3sm22663637pgi.20.2021.07.13.12.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 12:53:40 -0700 (PDT)
Date:   Tue, 13 Jul 2021 19:53:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@gmail.com
Subject: Re: [RFC PATCH v2 08/69] KVM: TDX: add trace point before/after TDX
 SEAMCALLs
Message-ID: <YO3vQY64R2uoj2ST@google.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <28a0ae6b767260fcb410c6ddff7de84f4e13062c.1625186503.git.isaku.yamahata@intel.com>
 <03a48573-85b2-f908-f058-205e9aa02787@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03a48573-85b2-f908-f058-205e9aa02787@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 06, 2021, Paolo Bonzini wrote:
> On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
> > +	trace_kvm_tdx_seamcall_enter(smp_processor_id(), op,
> > +				     rcx, rdx, r8, r9, r10);
> > +	err = __seamcall(op, rcx, rdx, r8, r9, r10, ex);
> > +	if (ex)
> > +		trace_kvm_tdx_seamcall_exit(smp_processor_id(), op, err, ex->rcx,
> > +					    ex->rdx, ex->r8, ex->r9, ex->r10,
> > +					    ex->r11);
> > +	else
> > +		trace_kvm_tdx_seamcall_exit(smp_processor_id(), op, err,
> > +					    0, 0, 0, 0, 0, 0);
> 
> Would it make sense to do the zeroing of ex directly in __seamcall in case
> there is an error?

A better option would be to pass "ex" into the tracepoint.  tdx_arch.h is already
included by trace.h (though I'm not sure that's a good thing), and the cost of
checking ex against NULL over and over is a non-issue because it's buried in the
tracepoint, i.e. hidden behind a patch nop.  The below reduces the footprint of
_seamcall by 100+ bytes of code, presumably due to avoiding even more register
shuffling (I didn't look too closely).

That said, I'm not sure adding generic tracepoints is a good idea.  The flows
that truly benefit from tracepoints will likely want to provide more/different
information, e.g. the entry/exit flow already uses kvm_trace_entry/exit, and the
SEPT flows have dedicated tracepoints.  For flows like tdh_vp_flush(), which
might benefit from a tracepoint, they'll only provide the host PA of the TDVPR,
which is rather useless on its own.  It's probably possible to cross-reference
everything to understand what's going on, but it certainly won't be easy.

I can see the generic tracepoint being somewhat useful for debugging early
development and/or a new TDX module, but otherwise I think it will be mostly
overhead.  E.g. if a TDX failure pops up in production, enabling the tracepoint
might not even be viable.  And even for the cases where the tracepoint is useful,
I would be quite surprised if additional instrumentation wasn't needed to debug
non-trivial issues.


diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 58631124f08d..e2868f6d84f8 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -701,9 +701,8 @@ TRACE_EVENT(kvm_tdx_seamcall_enter,
  * Tracepoint for the end of TDX SEAMCALLs.
  */
 TRACE_EVENT(kvm_tdx_seamcall_exit,
-       TP_PROTO(int cpuid, __u64 op, __u64 err, __u64 rcx, __u64 rdx, __u64 r8,
-                __u64 r9, __u64 r10, __u64 r11),
-       TP_ARGS(cpuid, op, err, rcx, rdx, r8, r9, r10, r11),
+       TP_PROTO(int cpuid, __u64 op, __u64 err, struct tdx_ex_ret *ex),
+       TP_ARGS(cpuid, op, err, ex),

        TP_STRUCT__entry(
                __field(        int,            cpuid   )
@@ -721,12 +720,12 @@ TRACE_EVENT(kvm_tdx_seamcall_exit,
                __entry->cpuid                  = cpuid;
                __entry->op                     = op;
                __entry->err                    = err;
-               __entry->rcx                    = rcx;
-               __entry->rdx                    = rdx;
-               __entry->r8                     = r8;
-               __entry->r9                     = r9;
-               __entry->r10                    = r10;
-               __entry->r11                    = r11;
+               __entry->rcx                    = ex ? ex->rcx : 0;
+               __entry->rdx                    = ex ? ex->rdx : 0;
+               __entry->r8                     = ex ? ex->r8  : 0;
+               __entry->r9                     = ex ? ex->r9  : 0;
+               __entry->r10                    = ex ? ex->r10 : 0;
+               __entry->r11                    = ex ? ex->r11 : 0;
        ),

        TP_printk("cpu: %d op: %s err %s 0x%llx rcx: 0x%llx rdx: 0x%llx r8: 0x%llx r9: 0x%llx r10: 0x%llx r11: 0x%llx",
diff --git a/arch/x86/kvm/vmx/seamcall.h b/arch/x86/kvm/vmx/seamcall.h
index 85eeedc06a4f..b2067f7e6a9d 100644
--- a/arch/x86/kvm/vmx/seamcall.h
+++ b/arch/x86/kvm/vmx/seamcall.h
@@ -23,13 +23,8 @@ static inline u64 _seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9, u64 r10,
        trace_kvm_tdx_seamcall_enter(smp_processor_id(), op,
                                     rcx, rdx, r8, r9, r10);
        err = __seamcall(op, rcx, rdx, r8, r9, r10, ex);
-       if (ex)
-               trace_kvm_tdx_seamcall_exit(smp_processor_id(), op, err, ex->rcx,
-                                           ex->rdx, ex->r8, ex->r9, ex->r10,
-                                           ex->r11);
-       else
-               trace_kvm_tdx_seamcall_exit(smp_processor_id(), op, err,
-                                           0, 0, 0, 0, 0, 0);
+       trace_kvm_tdx_seamcall_exit(smp_processor_id(), op, err, ex);
+
        return err;
 }


