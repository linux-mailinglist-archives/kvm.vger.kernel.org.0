Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D7C21A729
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 20:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgGISlG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 14:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgGISlF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 14:41:05 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBFBDC08C5DC
        for <kvm@vger.kernel.org>; Thu,  9 Jul 2020 11:41:05 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id r12so2918264ilh.4
        for <kvm@vger.kernel.org>; Thu, 09 Jul 2020 11:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SJQldr4+VKrEQsjFpeywG2H0CUaXEr03YCsdEkG+QHU=;
        b=sLHHvMcaaw8F8Vc2qUuZTPf0IOPqoaIrg15SnfkoSsQmKU1+z+Xx3tk6XwpKmXSnaj
         W1BEXXfegRmyrI7K/2oTAPrzFILjPz3KB7Tqr54DRPZxyGQs3JbShF2FYSxh30PJVIqm
         Ty8WWF6+Ucg9fMASWJszsePs+ghbxuknkGkVkfITDrRs4rNfHofSslmeUjTT4XFeZFDZ
         dbkU/YKhBu1a3I+POGNOjJPmTJaA4gbyV3+QANd1agBsHBPmp+VJ2D3TDedQgfSWnx1M
         wm3y9hAHi3kKcadop2Dy/D9nbKdtz+KS3woGn9ItvMWJRZl9zaj9oObwlRII/3MjIWwG
         w5eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SJQldr4+VKrEQsjFpeywG2H0CUaXEr03YCsdEkG+QHU=;
        b=YkZTrjZnVOKRPk6YY9F+sV46GynHN3F620nBa5uDrWpHkiGbmsWSbCK6FKK6bW3Hh/
         8XBtaHz+4pUOwM3nZowy2SCk3gnrrXQyGVIOmA4vxDjGhDwLnkJubENUZwqN1JBJCj+4
         GK5/HVsdiDtnFNwwvuzoiv7diiAkJFQYvB5GeJOq5HqSg3clvlgTvqR++WO52Rny01Sy
         jeSqZ4vq3+id/6vD7vjLlMVxxXdJTmLfTClAZayLJehePtsNqYT36WKe+0WhDXqdrJp6
         cdncwG6fmEBdukMjt4GGLxSR39knlRZu5C21YTFx4IChud2HGyMdKRTcbpZ2VjS+8Tm1
         89Qw==
X-Gm-Message-State: AOAM532Bkqd2UNigpiWZharblPkCsGyKqJedYJsRj28yK38UrcaY9Xo0
        5cHSqu3Br0LGj4uU4SSt49UUOqx4JNaZddbpy+RfPg==
X-Google-Smtp-Source: ABdhPJxUhfmTOSdMHniBtR0MgiiEHBwdV0hZSBl2vpyCS+aoz3HFiQw7kcr/bpfFq9jTLI/nJrrymrJQSdKsbrYwHxw=
X-Received: by 2002:a05:6e02:de6:: with SMTP id m6mr47488213ilj.296.1594320064774;
 Thu, 09 Jul 2020 11:41:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200709095525.907771-1-pbonzini@redhat.com> <CALMp9eREY4e7kb22CxReNV83HwR7D_tBkn2i5LUbGLGe_yw5nQ@mail.gmail.com>
 <782fdf92-38f8-c081-9796-5344ab3050d5@redhat.com> <CALMp9eRSvdx+UHggLbvFPms3Li2KY-RjZhjGjcQ3=GbSB1YyyA@mail.gmail.com>
 <717a1b5d-1bf3-5f72-147a-faccd4611b87@redhat.com>
In-Reply-To: <717a1b5d-1bf3-5f72-147a-faccd4611b87@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 9 Jul 2020 11:40:53 -0700
Message-ID: <CALMp9eThSjLY92-WURobbJBHRKLxGuYPLBWMnq+=FxxYHquTiw@mail.gmail.com>
Subject: Re: [PATCH] KVM: nSVM: vmentry ignores EFER.LMA and possibly RFLAGS.VM
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 9, 2020 at 11:31 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 09/07/20 20:28, Jim Mattson wrote:
> >> That said, the VMCB here is guest memory and it can change under our
> >> feet between nested_vmcb_checks and nested_prepare_vmcb_save.  Copying
> >> the whole save area is overkill, but we probably should copy at least
> >> EFER/CR0/CR3/CR4 in a struct at the beginning of nested_svm_vmrun; this
> >> way there'd be no TOC/TOU issues between nested_vmcb_checks and
> >> nested_svm_vmrun.  This would also make it easier to reuse the checks in
> >> svm_set_nested_state.  Maybe Maxim can look at it while I'm on vacation,
> >> as he's eager to do more nSVM stuff. :D
> >
> > I fear that nested SVM is rife with TOCTTOU issues.
>
> I am pretty sure about that, actually. :)
>
> Another possibility to stomp them in a more efficient manner could be to
> rely on the dirty flags, and use them to set up an in-memory copy of the
> VMCB.

That sounds like a great idea! Is Maxim going to look into that?
