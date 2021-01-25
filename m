Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 273CA302D2B
	for <lists+kvm@lfdr.de>; Mon, 25 Jan 2021 22:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732432AbhAYVCa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 16:02:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732426AbhAYVCN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 16:02:13 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E820CC061574
        for <kvm@vger.kernel.org>; Mon, 25 Jan 2021 13:01:32 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id b21so2945483pgk.7
        for <kvm@vger.kernel.org>; Mon, 25 Jan 2021 13:01:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XrFM/8QZQpJqubUYMWbsYAtcpteTwR0TS9zSLkjNBQ0=;
        b=A9Krd7YKB/E6MJjbPlEaeRBR5DGxp7BWQNcVvc6RB5bUkzucc5BJSEYWTwxmycUtcI
         +ppahFQsF5HjOR1pzA2sdTQclWgudUW5IfowMUQcf14n+tohg4unKWaLm2bfhQFfnlBb
         LS7HFxtziTXHTqOeA/NQ41o9ezLSykqtw14i0KhEGzDzXyv9g49M19EuCrooXVsd8e/k
         xoSBbOdDQmXY25Un5WSHsMrFr0a5Reh6XV2QZ5zVYLbiSZl07R3ahJpmmzoALXoWAGVc
         deCcqPMdBebuv3YBA43fLYvJXh4kwVvEgQcd3ZwjGyzsSmQ/VRL0WjwfWDnp4OkzgSmU
         Sgtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XrFM/8QZQpJqubUYMWbsYAtcpteTwR0TS9zSLkjNBQ0=;
        b=dc890fWOwIsAFVK3cfCDBxQfzUm5LzaYKs8yPqCDOsu3GCK35QV2PcPKSc03/urc14
         79cfIUV4mRG0+Z3qITz0ZQxt3iYTsKgn8yrI5BTuTXlClIHxOo/KmtmUnKAxWHTWnjkf
         ABM8ei6HZ2kMwRPVdh7QiV42lWUyaswMawDTMtbxa9oJrUHcmhn/CW9oRQ3HVUbeJS/r
         JHbQ9ZxOvZT14H1ApAlhh9nWP1dGChiDkZlDjJZ3sEZsPHoBCUIqEKTfc/A6Bk0rCVHz
         u7Oj12TsJEGvON3Qb8Fc8tW9/LvFzW1vud3F92xm02wBaBkcafMtPFB6yUpY/oq9uADw
         MP4w==
X-Gm-Message-State: AOAM531ndGCpm+XCGIy45zamLkqug9kph/ReQ+zu0MNrb1DBjTlPHSuN
        kARpQJquwZcGmkLbY7jJYtJYNw==
X-Google-Smtp-Source: ABdhPJy8FdSJ4e529ngWMTyYGKzqJd7StrPl9DiNqWCiJaOOzNjTWj+MteOGrXa8Pe+YjNhvTWafzQ==
X-Received: by 2002:aa7:8a8b:0:b029:1ae:8c71:9915 with SMTP id a11-20020aa78a8b0000b02901ae8c719915mr2010264pfc.79.1611608492236;
        Mon, 25 Jan 2021 13:01:32 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id m1sm250048pjz.16.2021.01.25.13.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 13:01:31 -0800 (PST)
Date:   Mon, 25 Jan 2021 13:01:25 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>
Subject: Re: Thoughts on sharing KVM tracepoints [was:Re: [PATCH 2/2] KVM:
 nVMX: trace nested vm entry]
Message-ID: <YA8xpfPtonJdxU2D@google.com>
References: <20210121171043.946761-1-mlevitsk@redhat.com>
 <20210121171043.946761-3-mlevitsk@redhat.com>
 <YAn/t7TWP0xmVEHs@google.com>
 <f1c90d8a44795bbdef549a5fcf375bcf1d52af93.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1c90d8a44795bbdef549a5fcf375bcf1d52af93.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 25, 2021, Maxim Levitsky wrote:
> On Thu, 2021-01-21 at 14:27 -0800, Sean Christopherson wrote:
> > I still don't see why VMX can't share this with SVM.  "npt' can easily be "tdp",
> > differentiating between VMCB and VMCS can be down with ISA, and VMX can give 0
> > for int_ctl (or throw in something else interesting/relevant).
> 
> I understand very well your point, and I don't strongly disagree with you.
> However let me voice my own thoughts on this:
>  
> I think that sharing tracepoints between SVM and VMX isn't necessarily a good idea.
> It does make sense in some cases but not in all of them.
>  
> The trace points are primarily intended for developers, thus they should capture as
> much as possible relevant info but not everything because traces can get huge.
>  
> Also despite the fact that a developer will look at the traces, some usability is welcome
> as well (e.g for new developers), and looking at things like info1/info2/intr_info/error_code
> isn't very usable

I'm not opposed to printing different names on VMX, e.g. exit_qual and
idt_vec_info, but I 100% think that VMX and SVM should share the bulk of the
code.  Improvements to VMX almost always apply in some way to SVM, and vice
versa.  It's all but guaranteed that splitting flows will eventually cause
divergence in a bad way.  Divergence in tracepoints is likely to be minor at
worst, but I don't think that's a good reason to intentionally split the code
when it's quite easy to share.

> (btw the error_code should at least be called intr_info_error_code, and

Heh, I disagree even on this.  IMO, after debugging a few times, associating
error_code with the event being injected is second nature.  Prepending
intr_info_ would just add extra characters and slow down mental processing.

> of course both it and intr_info are VMX specific).

Not really, SVM has the exact same fields with slightly different names.

> So I don't even like the fact that kvm_entry/kvm_exit are shared, and neither I want
> to add even more shared trace points.
>
> I understand that there are some benefits of sharing, namely a userspace tool can use
> the same event to *profile* kvm, but I am not sure that this is worth it.

Why is it not worth it?  It's a small amount of one-time kernel pain that allows
all users/developers to reuse scripts and tools across VMX and SVM.  Even manual
usage benefits, e.g. I don't have to remember that a tracepoint is 'x' on VMX
but 'y' on SVM.

> What we could have done is to have ISA (and maybe even x86) agnostic kvm_exit/kvm_entry
> tracepoints that would have no data attached to them, or have very little (like maybe RIP),
> and then have ISA specific tracepoints with the reset of the info.

That would probably end up as the least user friendly combination.  Usually I
enable a tracepoint to get more info, rarely am I interested in _just_ the
logging of the tracepoint itself.  The generic tracepoint would either be
useless and never enabled, or even worse would cause people to overlook the
vendor-specific variant.

> Same could be applied to kvm_nested_vmenter, although for this one I don't think that we
> need an ISA agnostic tracepoint.
>  
> Having said all that, I am not hell bent on this. If you really want it to be this way,
> I won't argue that much.
>  
> Thoughts?
